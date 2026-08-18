-- One-time migration: models moved from PUBLIC into per-layer schemas
-- (BRONZE / SILVER / SNAPSHOTS) via the generate_schema_name macro override
-- in macros/generate_schema_name.sql plus +schema configs in dbt_project.yml.
--
-- Only needed for a warehouse that was built BEFORE that change. A fresh
-- setup running ddl/00-05 then `dbt build` lands in the right schemas directly.

USE ROLE TRANSFORMER;

-- 1. Preserve snapshot history BEFORE running dbt.
--    dbt does not migrate existing tables when their target schema changes --
--    it would treat SNAPSHOTS.scd_* as first-run and start SCD2 history over,
--    stranding the accumulated version rows in PUBLIC. Snapshot history cannot
--    be reconstructed retroactively, so this rename must happen first.
CREATE SCHEMA IF NOT EXISTS AIRBNB.SNAPSHOTS;

ALTER TABLE AIRBNB.PUBLIC.scd_listings RENAME TO AIRBNB.SNAPSHOTS.scd_listings;
ALTER TABLE AIRBNB.PUBLIC.scd_hosts    RENAME TO AIRBNB.SNAPSHOTS.scd_hosts;

-- Verify before continuing: should return 501 (500 listings + 1 SCD2 version
-- row from the price change in ddl/99b_demo_scd2_change.sql).
-- SELECT COUNT(*) FROM AIRBNB.SNAPSHOTS.scd_listings;

-- 2. Rebuild models into the new schemas.
--    `dbt run` -- is_incremental() returns False because {{ this }} now points
--    at tables that don't exist yet, so every model does a full build.

-- 3. Drop the now-orphaned originals.
--    dbt never cleans up a model's previous location; without this, PUBLIC
--    keeps stale duplicates of every table forever.
DROP TABLE IF EXISTS AIRBNB.PUBLIC.bronze_bookings;
DROP TABLE IF EXISTS AIRBNB.PUBLIC.bronze_hosts;
DROP TABLE IF EXISTS AIRBNB.PUBLIC.bronze_listings;
DROP TABLE IF EXISTS AIRBNB.PUBLIC.silver_bookings;
DROP TABLE IF EXISTS AIRBNB.PUBLIC.silver_hosts;
DROP TABLE IF EXISTS AIRBNB.PUBLIC.silver_listings;

-- Note: the country_region_map seed intentionally remains in PUBLIC -- it is
-- reference data rather than a medallion layer, so it has no +schema config.
