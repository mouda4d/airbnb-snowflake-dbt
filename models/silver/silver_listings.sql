SELECT *
FROM {{ ref('bronze_listings') }}
QUALIFY ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY created_at DESC) = 1