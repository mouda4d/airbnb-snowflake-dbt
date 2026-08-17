-- Demo fixture, NOT part of core setup (see also 99_demo_incremental_test.sql).
-- Simulates a business-meaningful attribute change so the SCD2 snapshot has
-- something to record.
--
-- Sequence and expected results:
--   1. Run this UPDATE.
--   2. dbt run --select bronze_listings silver_listings
--      -> SUCCESS 0. The incremental filter keys on created_at, which this
--         UPDATE does not touch, so the change is INVISIBLE to the pipeline.
--         This is deliberate: it demonstrates the core limitation of
--         timestamp-based incremental loading (misses updates that don't bump
--         the timestamp, misses hard deletes, misses late-arriving data).
--   3. dbt run --select bronze_listings silver_listings --full-refresh
--      -> SUCCESS 500. Full rebuild picks the change up.
--   4. dbt snapshot --select scd_listings
--      -> SUCCESS 1, and scd_listings grows 500 -> 501 rows: the old version
--         is closed (dbt_valid_to set) and a new open version inserted.

USE ROLE TRANSFORMER;

UPDATE AIRBNB.RAW.LISTINGS
SET price_per_night = 999
WHERE listing_id = 1;

-- To reset: set it back to the original value from listings.csv, then
-- --full-refresh the models. Note the snapshot history is NOT reversible --
-- it will simply record another change back to 84.
--
-- UPDATE AIRBNB.RAW.LISTINGS SET price_per_night = 84 WHERE listing_id = 1;
