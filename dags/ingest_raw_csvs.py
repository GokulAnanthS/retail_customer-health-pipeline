import os
import pandas as pd
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime

DATA_DIR = "/opt/airflow/data/raw"

def create_raw_schema():
    hook = PostgresHook(postgres_conn_id="postgres_default")
    sql_path = "/opt/airflow/sql/ingestion/create_raw_schema.sql"
    with open(sql_path, "r") as f:
        hook.run(f.read())

def create_raw_tables():
    hook = PostgresHook(postgres_conn_id="postgres_default")
    sql_path = "/opt/airflow/sql/create_raw_tables.sql"
    with open(sql_path, "r") as f:
        hook.run(f.read())

def load_csv_to_postgres():
    hook = PostgresHook(postgres_conn_id="postgres_default")
    engine = hook.get_sqlalchemy_engine()
    conn = engine.connect()

    files = {
        "customers.csv": "raw.customers",
        "transactions.csv": "raw.transactions",
        "interactions.csv": "raw.interactions",
        "campaigns.csv": "raw.campaigns",
        "customer_reviews_complete.csv": "raw.customer_reviews",
        "support_tickets.csv": "raw.support_tickets"
    }

    for filename, table in files.items():
        schema, table_name = table.split(".")

        df = pd.read_csv(os.path.join(DATA_DIR, filename))

        # 👉 FIX COLUMN NAME MISMATCH FOR INTERACTIONS
        if table_name == "interactions" and "duration" in df.columns:
            df = df.rename(columns={"duration": "duration_seconds"})

        # TRUNCATE old data (safe for dbt dependencies)
        conn.execute(f"TRUNCATE TABLE {schema}.{table_name} RESTART IDENTITY;")

        # INSERT fresh rows
        df.to_sql(
            name=table_name,
            con=engine,
            schema=schema,
            if_exists="append",
            index=False
        )

        print(f"[INGEST] Loaded {filename} → {table} (rows={len(df)})")


    conn.close()

with DAG(
    dag_id="ingest_raw_csvs",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False
):
    create_schema_task = PythonOperator(
        task_id="create_raw_schema",
        python_callable=create_raw_schema
    )

    create_tables_task = PythonOperator(
        task_id="create_raw_tables",
        python_callable=create_raw_tables
    )

    load_csv_task = PythonOperator(
        task_id="load_csv_to_postgres",
        python_callable=load_csv_to_postgres
    )

    create_schema_task >> create_tables_task >> load_csv_task