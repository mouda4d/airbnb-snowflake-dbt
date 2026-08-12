{{ config(materialized='incremental', unique_key='host_id') }}

SELECT * FROM {{ source('airbnb_source', 'hosts') }}

{% if is_incremental() %}
WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})
{% endif %}
