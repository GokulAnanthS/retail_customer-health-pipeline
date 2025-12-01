SELECT interaction_id,
    customer_id,
    channel,
    interaction_type,
    interaction_date,
    duration as duration_seconds,
    session_id
FROM raw.interactions