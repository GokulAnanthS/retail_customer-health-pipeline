SELECT transaction_id,
    customer_id,
    product_name,
    product_category,
    quantity,
    price,
    transaction_date,
    store_location,
    payment_method
FROM raw.transactions