"""
ShadowTradeMonitor - dbt Pipeline DAG
=======================================
Runs dbt models and tests daily at midnight.

Ingestion is handled separately by shadow_ingest_pipeline DAG
which runs hourly — decoupled so schedules are independent.
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
import logging

log = logging.getLogger(__name__)

DBT_BIN      = "/opt/dbt-venv/bin/dbt"
DBT_PROJECT  = "/opt/dbt/shadow_trade_pipeline"
DBT_PROFILES = "/home/airflow/.dbt"

default_args = {
    "owner": "shadow_trade",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
    "email_on_failure": False,
    "email_on_retry": False,
}

with DAG(
    dag_id="shadow_trade_pipeline",
    description="ShadowTradeMonitor: dbt transform and test (daily midnight)",
    default_args=default_args,
    start_date=datetime(2026, 3, 26),
    schedule_interval="0 0,8,16 * * *",    # daily at midnight and 8 AM and 4 PM
    catchup=False,
    max_active_runs=1,
    tags=["shadow_trade", "trading", "dbt"],
) as dag:

    # ── Task 1: Run dbt models (bronze → silver → gold) ───────────────────────
    run_dbt_models = BashOperator(
        task_id="run_dbt_models",
        bash_command=f"""
            set -e
            echo "=== Running dbt models ==="
            {DBT_BIN} run \
                --profiles-dir {DBT_PROFILES} \
                --project-dir {DBT_PROJECT} \
                --log-path /tmp/dbt-logs \
                --target-path /tmp/dbt-target
            echo "=== dbt run complete ==="
        """,
        execution_timeout=timedelta(minutes=20),
    )

    # ── Task 2: Run dbt tests ─────────────────────────────────────────────────
    run_dbt_tests = BashOperator(
        task_id="run_dbt_tests",
        bash_command=f"""
            set -e
            echo "=== Running dbt tests ==="
            {DBT_BIN} test \
                --profiles-dir {DBT_PROFILES} \
                --project-dir {DBT_PROJECT} \
                --log-path /tmp/dbt-logs \
                --target-path /tmp/dbt-target
            echo "=== dbt tests complete ==="
        """,
        execution_timeout=timedelta(minutes=10),
    )

    # ── Task 3: Log completion summary ────────────────────────────────────────
    def log_summary(**context):
        log.info("=" * 60)
        log.info(f"Pipeline completed — run date: {context['ds']}")
        log.info("gold.mart_strategy_performance is up to date")
        log.info("Refresh Power BI dataset to see latest data")
        log.info("=" * 60)

    notify_completion = PythonOperator(
        task_id="notify_completion",
        python_callable=log_summary,
    )

    # ── Execution order ───────────────────────────────────────────────────────
    run_dbt_models >> run_dbt_tests >> notify_completion
