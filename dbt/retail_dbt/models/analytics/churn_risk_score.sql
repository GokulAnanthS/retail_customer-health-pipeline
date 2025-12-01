{{ config(schema='analytics', materialized='table') }}

SELECT
    customer_id,
    (0.4 * (recency_days / 100.0)) +
    (0.4 * (inactivity_days / 100.0)) +
    (0.2 * churn_flag) AS churn_risk_score
FROM {{ ref('churn_signals') }}