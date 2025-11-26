import os
import pandas as pd
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime

DATA_DIR = "/opt/airflow/data/raw"

from sqlalchemy import create_engine

def get_clean_engine():
    # Matches docker-compose.yml settings
    user = "airflow"
    password = "airflow"
    host = "postgres"
    port = 5432
    db = "retail_db"

    conn_str = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}"
    return create_engine(conn_str)


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
    engine = get_clean_engine()

    files = {
        "customers.csv": "raw.customers",
        "transactions.csv": "raw.transactions",
        "interactions.csv": "raw.interactions",
        "campaigns.csv": "raw.campaigns",
        "customer_reviews_complete.csv": "raw.customer_reviews",
        "support_tickets.csv": "raw.support_tickets"
    }

    for filename, table in files.items():
        path = os.path.join(DATA_DIR, filename)
        df = pd.read_csv(path)
        df.to_sql(
            table.split(".")[1],
            engine,
            schema="raw",
            if_exists="replace",
            index=False
        )
        print(f"Loaded {filename} → {table}")


with DAG(
    dag_id="ingest_raw_csvs",
    start_date=datetime(2024,1,1),
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
