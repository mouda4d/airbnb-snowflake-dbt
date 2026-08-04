SELECT *
FROM {{ ref('bronze_bookings') }}
QUALIFY ROW_NUMBER() OVER(PARTITION BY booking_id ORDER BY created_at DESC) = 1