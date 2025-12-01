{{ config(schema='analytics', materialized='table') }}

WITH i AS (
    SELECT
        customer_id,
        COUNT(*) AS total_interactions,
        COUNT(DISTINCT session_id) AS session_count,
        AVG(duration_seconds) AS avg_session_duration,
        MAX(interaction_date) AS last_interaction
    FROM curated.interactions
    GROUP BY customer_id
)

SELECT
    customer_id,
    total_interactions,
    session_count,
    avg_session_duration,
    DATE_PART('day', CURRENT_DATE - last_interaction) AS days_since_engagement
FROM i