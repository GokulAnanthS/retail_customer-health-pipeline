{{ config(schema='analytics', materialized='table') }}

WITH t AS (
    SELECT
        customer_id,
        MAX(transaction_date) AS last_purchase,
        COUNT(*) AS frequency,
        SUM(quantity * price) AS monetary
    FROM curated.transactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    EXTRACT(DAY FROM AGE(CURRENT_DATE, last_purchase)) AS recency,
    frequency,
    monetary
FROM t