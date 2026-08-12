-- Cleanup of the SCRATCH schema used for hands-on SQL practice
-- (MERGE semantics, dedup patterns, surrogate keys).
--
-- Nothing in the pipeline depends on these objects -- they were disposable
-- practice tables, deliberately kept out of RAW so that layer stayed immutable.
-- Dropping the schema removes: TEST_BOOKING, INCOMING_BOOKING_UPDATES,
-- KEYS_TO_DELETE, TEST_BOOKING_DEDUPED.

USE ROLE TRANSFORMER;

DROP SCHEMA IF EXISTS AIRBNB.SCRATCH;
