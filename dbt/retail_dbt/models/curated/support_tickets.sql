SELECT ticket_id,
    customer_id,
    issue_category,
    priority,
    submission_date,
    resolution_date,
    resolution_status,
    resolution_time_hours,
    customer_satisfaction_score
FROM raw.support_tickets