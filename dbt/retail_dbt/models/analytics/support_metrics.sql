{{ config(schema='analytics', materialized='table') }}

WITH t AS (
    SELECT
        customer_id,
        COUNT(*) AS ticket_count,
        AVG(resolution_time_hours) AS avg_resolution_time,
        AVG(customer_satisfaction_score) AS avg_csat,
        MAX(submission_date) AS last_ticket_date
    FROM curated.support_tickets
    GROUP BY customer_id
)

SELECT
    customer_id,
    ticket_count,
    avg_resolution_time,
    avg_csat,
    DATE_PART('day', CURRENT_DATE - last_ticket_date) AS days_since_last_ticket
FROM t