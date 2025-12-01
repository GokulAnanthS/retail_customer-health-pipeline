{{ config(schema='analytics', materialized='table') }}

SELECT
    c.customer_id,
    c.full_name,
    c.gender,
    c.age,
    c.city,
    c.state,
    c.registration_date,

    EXTRACT(DAY FROM AGE(CURRENT_DATE, c.registration_date)) AS tenure_days,

    CASE
        WHEN age < 25 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_bucket

FROM curated.customers c
