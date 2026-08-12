{{ 
    config( 
        materialized='incremental', 
        unique_key='host_id' ) 
}}

SELECT * REPLACE (COALESCE(host_name, 'Anonymous') AS host_name)
FROM {{ ref('bronze_hosts') }} 

{% if is_incremental() %}

WHERE created_at > (SELECT COALESCE(MAX(created_at), '1900-01-01') FROM {{ this }})

{% endif %}