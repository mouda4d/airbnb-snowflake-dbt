SELECT * REPLACE (COALESCE(host_name, 'Anonymous') AS host_name)
FROM {{ ref('bronze_hosts') }} 
