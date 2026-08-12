{{ config(materialized='incremental', unique_key='booking_id') }}

SELECT * FROM {{ source('airbnb_source', 'bookings') }}

{% if is_incremental() %}
WHERE booking_date > (SELECT COALESCE(MAX(booking_date), '1900-01-01') FROM {{ this }})
{% endif %}