
{{ config(
    materialized='incremental',
    unique_key='listing_id',
) 
}}

SELECT *
FROM {{ ref('bronze_listings') }}

{% if is_incremental() %}

WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})

{% endif %}
QUALIFY ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY created_at DESC) = 1