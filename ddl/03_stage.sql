-- M3 Lesson 5: named internal stage for landing the source CSVs
-- Run as TRANSFORMER

USE ROLE TRANSFORMER;

CREATE STAGE IF NOT EXISTS AIRBNB.RAW.CSV_STAGE;

-- READ must be granted before/with WRITE on an internal stage -- Snowflake
-- enforces this ordering (verified: a role can't get blind write-only access
-- to a stage it can't also list/verify the contents of).
GRANT READ ON STAGE AIRBNB.RAW.CSV_STAGE TO ROLE TRANSFORMER;
GRANT WRITE ON STAGE AIRBNB.RAW.CSV_STAGE TO ROLE TRANSFORMER;
