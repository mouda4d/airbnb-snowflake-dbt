-- M3 Lesson 4: medallion layer schemas inside the AIRBNB database
-- Run as TRANSFORMER -- it created these, so it owns them automatically,
-- unlike PUBLIC (see 01_rbac.sql).

USE ROLE TRANSFORMER;

CREATE SCHEMA IF NOT EXISTS AIRBNB.RAW;

-- BRONZE / SILVER / GOLD schemas: created here manually for now, but the
-- source-of-truth repo generates these automatically via a custom
-- generate_schema_name macro (dbt, M7) -- revisit once we get there.
