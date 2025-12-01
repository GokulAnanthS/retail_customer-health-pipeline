from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_DIR = "/opt/airflow/dbt/retail_dbt"

with DAG(
    dag_id="run_dbt_curated",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False
):

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_DIR} && dbt run"
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_DIR} && dbt test"
    )
    dbt_analytics = BashOperator(
    task_id="dbt_analytics",
    bash_command=f"cd {DBT_DIR} && dbt run --select analytics"
)

dbt_test_analytics = BashOperator(
    task_id="dbt_test_analytics",
    bash_command=f"cd {DBT_DIR} && dbt test --select analytics"
)

dbt_test >> dbt_analytics >> dbt_test_analytics