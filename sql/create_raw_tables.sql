CREATE SCHEMA IF NOT EXISTS raw;
CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id TEXT PRIMARY KEY,
    full_name TEXT,
    age INTEGER,
    gender TEXT,
    email TEXT,
    phone TEXT,
    street_address TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    registration_date DATE,
    preferred_channel TEXT
);
CREATE TABLE IF NOT EXISTS raw.transactions (
    transaction_id TEXT PRIMARY KEY,
    customer_id TEXT,
    product_name TEXT,
    product_category TEXT,
    quantity INTEGER,
    price NUMERIC,
    transaction_date DATE,
    store_location TEXT,
    payment_method TEXT,
    discount_applied NUMERIC
);
CREATE TABLE IF NOT EXISTS raw.interactions (
    interaction_id VARCHAR(255),
    customer_id VARCHAR(255),
    channel VARCHAR(255),
    interaction_type VARCHAR(255),
    interaction_date TIMESTAMP,
    duration_seconds FLOAT,
    page_or_product VARCHAR(255),
    session_id VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS raw.campaigns (
    campaign_id TEXT PRIMARY KEY,
    campaign_name TEXT,
    campaign_type TEXT,
    start_date DATE,
    end_date DATE,
    target_segment TEXT,
    budget NUMERIC,
    impressions BIGINT,
    clicks BIGINT,
    conversions BIGINT,
    conversion_rate NUMERIC,
    roi NUMERIC
);
CREATE TABLE IF NOT EXISTS raw.customer_reviews (
    review_id VARCHAR(255),
    customer_id VARCHAR(255),
    product_name VARCHAR(255),
    product_category VARCHAR(255),
    full_name VARCHAR(255),
    transaction_date DATE,
    review_date DATE,
    rating INT,
    review_title VARCHAR(500),
    review_text TEXT
);

CREATE TABLE IF NOT EXISTS raw.support_tickets (
    ticket_id TEXT PRIMARY KEY,
    customer_id TEXT,
    issue_category TEXT,
    priority TEXT,
    submission_date TIMESTAMP,
    resolution_date TIMESTAMP,
    resolution_status TEXT,
    resolution_time_hours NUMERIC,
    customer_satisfaction_score NUMERIC,
    notes TEXT
);