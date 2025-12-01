{{ config(schema='analytics', materialized='table') }}

WITH base AS (
    SELECT
        cp.customer_id,

        COALESCE(rfm.monetary, 0) AS monetary_value,
        COALESCE(em.session_count, 0) AS engagement_level,
        COALESCE(s.avg_csat, 5) AS satisfaction_score,
        COALESCE(cr.churn_risk_score, 0) AS churn_risk

    FROM {{ ref('customer_profile') }} cp
    LEFT JOIN {{ ref('rfm_metrics') }} rfm USING (customer_id)
    LEFT JOIN {{ ref('engagement_metrics') }} em USING (customer_id)
    LEFT JOIN {{ ref('support_metrics') }} s USING (customer_id)
    LEFT JOIN {{ ref('churn_risk_score') }} cr USING (customer_id)
)

SELECT
    customer_id,
    monetary_value,
    engagement_level,
    satisfaction_score,
    churn_risk,

    -- Weighted score
    (
        (monetary_value * 0.3) +
        (engagement_level * 0.3) +
        (satisfaction_score * 0.2) +
        ((1 - churn_risk) * 0.2)
    ) AS customer_health_score

FROM base