{{ config(
    materialized='incremental',
    unique_key='booking_id',
) 
}}

SELECT *
FROM {{ ref('bronze_bookings') }}


{% if is_incremental() %}

WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})

{% endif %}
QUALIFY ROW_NUMBER() OVER(PARTITION BY booking_id ORDER BY created_at DESC) = 1