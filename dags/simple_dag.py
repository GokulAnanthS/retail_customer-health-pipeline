from airflow import DAG
from airflow.operators.empty import EmptyOperator
from datetime import datetime

with DAG(
    dag_id="sample_dag",
    start_date=datetime(2024,1,1),
    schedule_interval=None,
    catchup=False
):
    t1 = EmptyOperator(task_id="start")