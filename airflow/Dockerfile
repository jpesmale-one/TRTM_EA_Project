FROM apache/airflow:2.10.3-python3.12

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-venv \
    libpq-dev \
    gcc \
    libc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create isolated venv for dbt — separate from Airflow's Python.
# psycopg2-binary installed first so dbt-postgres never attempts source build.
RUN python3 -m venv /opt/dbt-venv \
    && /opt/dbt-venv/bin/pip install --no-cache-dir psycopg2-binary \
    && /opt/dbt-venv/bin/pip install --no-cache-dir dbt-postgres==1.8.0

USER airflow

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt