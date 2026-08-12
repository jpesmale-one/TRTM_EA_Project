"""
ShadowTradeMonitor - Bronze Ingestion Script
============================================
Watches the MetaQuotes log directory for new/modified TradeMonitor CSV files
and bulk-loads them into the bronze.trade_monitor_logs PostgreSQL table.

Usage:
    1. pip install pandas sqlalchemy psycopg2-binary watchdog
    2. Update DB_URL below with your PostgreSQL credentials
    3. python ingest_trade_logs.py

Dedup strategy:
    ON CONFLICT (ticket, event_type, server_time) DO NOTHING
    A ticket can have many MODIFY events (bot adjusts SL/TP multiple
    times per trade). The triple key makes each event row unique.
    Already-loaded rows are silently skipped — safe to re-run anytime.

LOG_ROLL events:
    MetaQuotes writes a LOG_ROLL row (ticket=0) at end of each day
    to signal a new log file is starting. These are filtered out and
    not loaded into the bronze table.
"""

import os
import time
import logging
import pandas as pd
from sqlalchemy import create_engine, text
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# ── Configuration ──────────────────────────────────────────────────────────────

# WATCH_DIR can be overridden by environment variable.
# Airflow passes: WATCH_DIR=/opt/metatrader/files (container mount path)
# Local use falls back to the Windows MetaQuotes directory.
WATCH_DIR = os.environ.get(
    "WATCH_DIR",
    r"C:\Users\jpesm\AppData\Roaming\MetaQuotes\Terminal\Common\Files"
)

# Update with your actual PostgreSQL credentials:
# format: postgresql+psycopg2://user:password@host:port/database
DB_HOST     = os.environ.get("POSTGRES_HOST",     "localhost")
DB_PORT     = os.environ.get("POSTGRES_PORT",     "5432")
DB_NAME     = os.environ.get("POSTGRES_DB",       "your_database")
DB_USER     = os.environ.get("POSTGRES_USER",     "postgres")
DB_PASSWORD = os.environ.get("POSTGRES_PASSWORD", "your_password")

DB_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

TABLE_SCHEMA = "bronze"
TABLE_NAME   = "trade_monitor_logs"
FULL_TABLE   = f"{TABLE_SCHEMA}.{TABLE_NAME}"

# MetaQuotes timestamp format: "2026.03.24 20:07:12"
MT_DATE_FORMAT = "%Y.%m.%d %H:%M:%S"

# Trade events we want to keep — everything else is filtered out.
# Includes both normal and RESYNC variants (emitted during EA resynchronisation).
# This whitelist approach means new system event types are automatically
# excluded without any code change.
TRADE_EVENT_TYPES = {
    "OPEN", "MODIFY", "CLOSE",
    "OPEN [RESYNC]", "MODIFY [RESYNC]", "CLOSE [RESYNC]"
}

# Column mapping: CSV header → database column name
COLUMN_MAP = {
    "ServerTime":      "server_time",
    "LocalTime":       "local_time",
    "BrokerTZOffset":  "broker_tz_offset",
    "EventType":       "event_type",
    "Ticket":          "ticket",
    "Symbol":          "symbol",
    "TradeType":       "trade_type",
    "Lots":            "lots",
    "OpenPrice":       "open_price",
    "StopLoss":        "stop_loss",
    "TakeProfit":      "take_profit",
    "ProfitLoss":      "profit_loss",
    "Notes":           "notes",
}

# ── Logging setup ──────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("ingest_trade_logs.log", encoding="utf-8"),
    ]
)
log = logging.getLogger(__name__)

# ── Database engine (created once, reused across all file events) ──────────────

engine = create_engine(DB_URL, pool_pre_ping=True)

# ── Core ingestion function ────────────────────────────────────────────────────

def parse_and_load(filepath: str) -> None:
    """
    Reads a single TradeMonitor CSV file, parses it, filters out
    system rows, and upserts trade rows into bronze.trade_monitor_logs.
    Already-existing rows are skipped. Safe to call multiple times.
    """
    filename = os.path.basename(filepath)

    if "TradeMonitor_Log" not in filename or not filename.endswith(".csv"):
        return

    log.info(f"Processing: {filename}")

    try:
        # ── 1. Read CSV ──────────────────────────────────────────────────────
        df = pd.read_csv(filepath, dtype=str)

        if df.empty:
            log.warning(f"Empty file, skipping: {filename}")
            return

        # ── 2. Rename columns to snake_case ──────────────────────────────────
        df.rename(columns=COLUMN_MAP, inplace=True)

        missing = set(COLUMN_MAP.values()) - set(df.columns)
        if missing:
            log.error(f"Missing columns in {filename}: {missing}")
            return

        # ── 3. Keep only known trade events ──────────────────────────────────
        #    Whitelist approach — OPEN, MODIFY, CLOSE only.
        #    Any new system event types (LOG_ROLL, EA_START, EA_STOP, etc.)
        #    are automatically excluded without any code change needed.
        non_trade = df[~df["event_type"].isin(TRADE_EVENT_TYPES)]
        if not non_trade.empty:
            counts = non_trade["event_type"].value_counts().to_dict()
            log.info(f"Filtered non-trade rows from {filename}: {counts}")
        df = df[df["event_type"].isin(TRADE_EVENT_TYPES)].copy()

        if df.empty:
            log.warning(f"No trade rows after filtering system events: {filename}")
            return

        # ── 4. Parse and cast data types ─────────────────────────────────────
        df["server_time"]      = pd.to_datetime(df["server_time"],     format=MT_DATE_FORMAT, errors="coerce")
        df["local_time"]       = pd.to_datetime(df["local_time"],      format=MT_DATE_FORMAT, errors="coerce")
        df["broker_tz_offset"] = pd.to_numeric(df["broker_tz_offset"], errors="coerce").astype("Int16")
        df["ticket"]           = pd.to_numeric(df["ticket"],           errors="coerce").astype("Int64")
        df["lots"]             = pd.to_numeric(df["lots"],             errors="coerce")
        df["open_price"]       = pd.to_numeric(df["open_price"],       errors="coerce")
        df["stop_loss"]        = pd.to_numeric(df["stop_loss"],        errors="coerce")
        df["take_profit"]      = pd.to_numeric(df["take_profit"],      errors="coerce")
        df["profit_loss"]      = pd.to_numeric(df["profit_loss"],      errors="coerce")

        before = len(df)
        df.dropna(subset=["server_time", "ticket", "event_type"], inplace=True)
        dropped = before - len(df)
        if dropped:
            log.warning(f"Dropped {dropped} unparseable rows from {filename}")

        if df.empty:
            log.warning(f"No valid rows after type parsing: {filename}")
            return

        # ── 5. Add pipeline metadata ─────────────────────────────────────────
        df["ingested_at"] = pd.Timestamp.now()
        df["source_file"] = filename

        # ── 6. Upsert into PostgreSQL ─────────────────────────────────────────
        inserted, skipped = bulk_upsert(df)
        log.info(
            f"Done [{filename}]: {inserted} inserted, {skipped} skipped (dupes). "
            f"Events: {df['event_type'].value_counts().to_dict()}"
        )

    except Exception as e:
        log.error(f"Failed to process {filename}: {e}", exc_info=True)


def bulk_upsert(df: pd.DataFrame) -> tuple[int, int]:
    """
    Inserts df rows into bronze.trade_monitor_logs using direct SQLAlchemy
    bulk insert with ON CONFLICT DO NOTHING dedup.

    Avoids df.to_sql() entirely — pandas 2.x + SQLAlchemy 2.x have
    compatibility issues with the temp table approach.

    Dedup key: (ticket, event_type, server_time)
    Returns (inserted_count, skipped_count).
    """
    # Convert dataframe to list of dicts for SQLAlchemy bulk insert
    rows = df.where(pd.notnull(df), None).to_dict(orient="records")

    insert_sql = text(f"""
        INSERT INTO {FULL_TABLE} (
            server_time, local_time, broker_tz_offset, event_type,
            ticket, symbol, trade_type, lots, open_price,
            stop_loss, take_profit, profit_loss, notes,
            ingested_at, source_file
        ) VALUES (
            :server_time, :local_time, :broker_tz_offset, :event_type,
            :ticket, :symbol, :trade_type, :lots, :open_price,
            :stop_loss, :take_profit, :profit_loss, :notes,
            :ingested_at, :source_file
        )
        ON CONFLICT (ticket, event_type, server_time) DO NOTHING
    """)

    with engine.begin() as conn:
        result = conn.execute(insert_sql, rows)
        inserted = result.rowcount
        skipped  = len(rows) - inserted

    return inserted, skipped


# ── Watchdog event handler ─────────────────────────────────────────────────────

class TradeLogHandler(FileSystemEventHandler):
    """
    Triggers ingestion whenever MetaQuotes writes or appends to a log file.

    on_created : fires when MetaQuotes rolls over to a new daily log file
    on_modified: fires each time a new trade row is appended mid-session
    Both paths are handled. A brief sleep lets MetaQuotes finish writing.
    """

    def on_created(self, event):
        if not event.is_directory:
            time.sleep(0.8)
            parse_and_load(event.src_path)

    def on_modified(self, event):
        if not event.is_directory:
            time.sleep(0.8)
            parse_and_load(event.src_path)


# ── Entry point ────────────────────────────────────────────────────────────────

if __name__ == "__main__":

    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--once",
        action="store_true",
        help="Run backfill only then exit (used by Airflow DAG). "
             "Omit this flag for live Watchdog mode."
    )
    args = parser.parse_args()

    # ── Step A: Backfill all existing CSV files ──────────────────────────────
    log.info("=== ShadowTradeMonitor Ingestion Starting ===")
    log.info(f"Directory: {WATCH_DIR}")
    log.info(f"Mode: {'one-shot (Airflow)' if args.once else 'live watch (Watchdog)'}")

    existing_files = sorted([
        f for f in os.listdir(WATCH_DIR)
        if "TradeMonitor_Log" in f and f.endswith(".csv")
    ])

    if existing_files:
        log.info(f"Backfilling {len(existing_files)} existing file(s)...")
        for fname in existing_files:
            parse_and_load(os.path.join(WATCH_DIR, fname))
        log.info("Backfill complete.")
    else:
        log.info("No existing files found.")

    # ── Step B: Watchdog live watch (skipped when --once flag is used) ────────
    if args.once:
        log.info("=== One-shot mode complete. Exiting. ===")
    else:
        observer = Observer()
        observer.schedule(TradeLogHandler(), path=WATCH_DIR, recursive=False)
        observer.start()
        log.info("Live watch mode active. Press Ctrl+C to stop.")

        try:
            while True:
                time.sleep(2)
        except KeyboardInterrupt:
            log.info("Shutting down...")
            observer.stop()

        observer.join()
        log.info("=== Ingestion process stopped ===")