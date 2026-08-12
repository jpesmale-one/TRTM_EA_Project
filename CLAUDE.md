# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ShadowTradeMonitor** — A data pipeline that ingests MetaQuotes MT4/MT5 trade logs, transforms them through a medallion architecture (bronze → silver → gold), and exposes analytics to Power BI dashboards.

## Environment Setup

**dbt venv** (required for all dbt commands):
```bash
C:\Users\jpesm\.venvs\dbt-env\Scripts\activate
cd Shadow_Trade_Pipeline
```

**Airflow stack** (Docker):
```bash
cd airflow
docker-compose up -d        # Start
docker-compose down         # Stop
# UI at http://localhost:8080 (admin/admin123)
```

## Commands

### dbt (from `Shadow_Trade_Pipeline/` with venv active)
```bash
dbt run          # Build all models
dbt test         # Run data quality tests
dbt build        # run + test
dbt debug        # Verify connection/config
dbt run --select staging    # Run a specific layer
dbt run --select mart_strategy_performance   # Run single model
```

### Ingestion script (from repo root)
```bash
python Ingest_Trade_Logs.py          # Live watch mode (polls Scratch/ directory)
python Ingest_Trade_Logs.py --once   # One-shot (used by Airflow DAG)
```

### Airflow DAG trigger (manual)
```bash
docker exec airflow-scheduler airflow dags trigger shadow_trade_pipeline
```

## Architecture

### Data Flow
```
MetaQuotes (MT4/MT5)
  → Scratch/*.csv (TradeMonitor logs)
  → [Ingest_Trade_Logs.py] via watchdog
  → PostgreSQL: bronze.trade_monitor_logs   (raw events, one row per event)
  → dbt staging:      silver.stg_trade_logs         (view, cleaned/parsed)
  → dbt intermediate: silver.int_trade_lifecycle     (view, open+modify+close joined)
                      silver.int_trade_sequences     (view, grouped by SL)
  → dbt marts:        gold.mart_strategy_performance (table → Power BI)
                      gold.mart_level_analysis       (table → KPI dashboard)
                      gold.mart_symbol_overview      (table → symbol summary)
```

### Ingestion (`Ingest_Trade_Logs.py`)
- Uses `watchdog` to detect new/modified files in `Scratch/`
- 0.8s delay after file event to let MetaQuotes finish writing
- Upserts via a temp staging table; dedup key: `(ticket, event_type, server_time)`
- Filters out `LOG_ROLL` and `EA_START` system events before loading
- DB connection is hardcoded at line ~38 (host: localhost:5432, db: shadowtradedb)

### dbt Layer Contracts
- **Bronze source** (`sources.yml`): `bronze.trade_monitor_logs` — raw, one row per event (OPEN/MODIFY/CLOSE)
- **Staging** (`stg_trade_logs`): Parses the `Notes` field into `strategy_name`, `position_tier`, `close_price`; normalizes 0.0 SL/TP to NULL
- **Intermediate** (`int_trade_lifecycle`): Reconstructs full trades by joining OPEN + MODIFY + CLOSE events on `(symbol, trade_type, stop_loss)`. Determines `trade_result` (WIN/LOSS/BREAKEVEN/CANCELLED) using sequence-aware logic
- **Intermediate** (`int_trade_sequences`): Groups trades into grid/pyramid sequences, calculates `max_level_in_sequence`
- **Mart** (`mart_strategy_performance`): One row per completed trade; the primary Power BI dataset. Includes pip calculations, cumulative P&L, planned/actual R-multiples

### Macros
- `get_level_from_lots(lots)` — maps lot size to trade level (L1–L30+); uses `round()` for float precision
- `get_pip_size(symbol)` — returns pip size by instrument (XAU=0.1, JPY pairs=0.01, others=0.0001)
- `generate_schema_name` — custom schema resolution (overrides dbt default)

### Orchestration (`airflow/dags/shadow_trade_dag.py`)
Daily DAG at midnight: `run_ingestion → run_dbt_models → run_dbt_tests → notify_completion`
- Ingestion runs `--once` mode with 30-min timeout
- dbt uses pre-built venv at `/opt/dbt-env` inside container
- Windows host paths mounted as Docker volumes (see `docker-compose.yml`)

## Key Configuration
- **dbt profile**: `shadow_trade_pipeline` — connect to PostgreSQL on localhost:5432, db `shadowtradedb`
- **Schema layout**: staging/intermediate → `silver` schema (views), marts → `gold` schema (tables)
- **Airflow metadata DB**: Separate PostgreSQL on port 5432 (db: `airflow_meta`)
- **Log files**: `ingest_trade_logs.log` (root), `Shadow_Trade_Pipeline/logs/` (dbt)
