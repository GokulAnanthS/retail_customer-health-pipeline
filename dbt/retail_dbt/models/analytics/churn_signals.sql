{{ config(schema='analytics', materialized='table') }}

SELECT
    cp.customer_id,

    COALESCE(em.days_since_engagement, 999) AS inactivity_days,
    COALESCE(rfm.recency, 999) AS recency_days,
    COALESCE(s.ticket_count, 0) AS ticket_count,
    COALESCE(s.avg_csat, 5) AS avg_csat,

    CASE
        WHEN COALESCE(em.days_since_engagement, 999) > 60 THEN 1
        WHEN COALESCE(rfm.recency, 999) > 90 THEN 1
        WHEN COALESCE(s.avg_csat, 5) < 3 THEN 1
        ELSE 0
    END AS churn_flag

FROM {{ ref('customer_profile') }} cp
LEFT JOIN {{ ref('engagement_metrics') }} em USING (customer_id)
LEFT JOIN {{ ref('rfm_metrics') }} rfm USING (customer_id)
LEFT JOIN {{ ref('support_metrics') }} s USING (customer_id)