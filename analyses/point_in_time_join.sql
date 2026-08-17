-- Joining a fact table to an SCD2 dimension: three approaches and their traps.
-- Files in analyses/ are compiled by `dbt compile` (so ref() resolves and the
-- SQL is validated) but are never executed as models.

-- 1. NAIVE JOIN -- WRONG. Silently duplicates facts.
-- Once a listing has more than one version row, every booking for it matches
-- every version. Verified: 10 bookings for listing_id 1 became 20 rows.
-- Aggregating booking_amount over this doubles revenue with no error raised.
--
-- SELECT COUNT(*)
-- FROM {{ ref('silver_bookings') }} b
-- JOIN {{ ref('scd_listings') }} l ON b.listing_id = l.listing_id

-- 2. CURRENT STATE ONLY -- correct for "what are this listing's attributes today?"
-- Filters the dimension to its open version. Relies on dbt_valid_to_current
-- being set to '9999-12-31'; with dbt's default NULL this predicate would
-- exclude every current row instead.
SELECT
    b.booking_id,
    b.booking_date,
    b.booking_amount,
    l.price_per_night AS current_price,
    l.room_type,
    l.city
FROM {{ ref('silver_bookings') }} b
JOIN {{ ref('scd_listings') }} l
    ON b.listing_id = l.listing_id
    AND l.dbt_valid_to = '9999-12-31'

-- 3. TRUE POINT-IN-TIME -- correct for "what were the attributes WHEN this happened?"
-- Key equality PLUS a validity window. This is the version that makes
-- historical analysis honest (e.g. "did superhosts earn more?" must compare
-- against superhost status at booking time, not today's status).
--
-- SELECT b.booking_id, b.booking_date, b.booking_amount,
--        l.price_per_night AS price_at_booking_time
-- FROM {{ ref('silver_bookings') }} b
-- JOIN {{ ref('scd_listings') }} l
--     ON b.listing_id = l.listing_id
--     AND b.booking_date >= l.dbt_valid_from
--     AND b.booking_date <  l.dbt_valid_to
--
-- IMPORTANT: against this project's data, query 3 returns ZERO rows -- and that
-- is correct, not a bug. Snapshot history only begins at the first `dbt snapshot`
-- run (2026-08-17 here); every booking predates that, so no version window
-- covers them. History cannot be reconstructed retroactively.
--
-- Mitigations when this matters:
--   a. Backdate the initial snapshot's dbt_valid_from (e.g. '1900-01-01') so
--      pre-existing facts join to the earliest known version. Document it --
--      it is an approximation, not real history.
--   b. LEFT JOIN point-in-time, COALESCE to the earliest version on no match.
--   c. Accept the boundary; only run point-in-time analysis from inception on.
