"""
ShadowTradeMonitor - Ingestion DAG
===================================
Runs the ingestion script hourly to backfill any new CSV rows
into bronze.trade_monitor_logs.

Runs independently from the dbt pipeline DAG so schedules are
decoupled — ingestion can run hourly while dbt runs at midnight.

ON CONFLICT DO NOTHING guarantees no duplicates regardless of
how many times this runs against the same files.
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "shadow_trade",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
    "email_on_failure": False,
    "email_on_retry": False,
}

with DAG(
    dag_id="shadow_ingest_pipeline",
    description="ShadowTradeMonitor: hourly CSV ingestion into bronze",
    default_args=default_args,
    start_date=datetime(2026, 3, 30),
    schedule_interval="0 * * * *",    # every hour on the hour
    catchup=False,
    max_active_runs=1,                # prevent overlapping runs
    tags=["shadow_trade", "ingestion"],
) as dag:

    run_ingestion = BashOperator(
        task_id="run_ingestion",
        bash_command="""
            set -e
            echo "=== Starting ingestion ==="
            WATCH_DIR=/opt/metatrader/files \
            POSTGRES_HOST=$POSTGRES_HOST \
            POSTGRES_PORT=$POSTGRES_PORT \
            POSTGRES_DB=$POSTGRES_DB \
            POSTGRES_USER=$POSTGRES_USER \
            POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
            python /opt/pipeline/ingest_trade_logs.py --once
            echo "=== Ingestion complete ==="
        """,
        execution_timeout=timedelta(minutes=30),
    )
