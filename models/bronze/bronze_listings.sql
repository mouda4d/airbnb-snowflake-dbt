{{ config(materialized='incremental', unique_key='listing_id') }}

SELECT * FROM {{ source('airbnb_source', 'listings') }}

{% if is_incremental() %}
WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})
{% endif %}