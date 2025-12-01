select
    interaction_id,
    customer_id,
    channel,
    interaction_type,
    interaction_date,
    duration_seconds,
    page_or_product,
    session_id
from {{ source('raw', 'interactions') }}
