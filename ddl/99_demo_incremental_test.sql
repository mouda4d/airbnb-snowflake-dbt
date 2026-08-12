-- Demo fixture, NOT part of core setup (hence 99).
-- Inserts one synthetic booking with a future created_at to prove that the
-- incremental models actually filter to new rows only.
--
-- Expected: `dbt run --select bronze_bookings` reports SUCCESS 1 (not 5001),
-- because the is_incremental() filter matches only this row.
--
-- The rest of the source data shares an identical created_at (it is
-- dataset-generation metadata, not a real load timestamp), so without this
-- row an incremental re-run correctly processes 0 rows and demonstrates
-- nothing visible.

USE ROLE TRANSFORMER;

INSERT INTO AIRBNB.RAW.BOOKINGS VALUES
('99999999-9999-9999-9999-999999999999', 42, '2026-08-05', 4, 800.00, 50.00, 30.00, 'confirmed', '2026-08-05 12:00:00.000');

-- To undo (note: removing it from RAW does NOT remove it from the incremental
-- bronze model -- incremental models never delete rows they've already loaded.
-- A `dbt run --select bronze_bookings --full-refresh` is required after this):
--
-- DELETE FROM AIRBNB.RAW.BOOKINGS
-- WHERE booking_id = '99999999-9999-9999-9999-999999999999';
