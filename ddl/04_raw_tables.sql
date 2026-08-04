
USE ROLE TRANSFORMER;

CREATE FILE FORMAT IF NOT EXISTS AIRBNB.RAW.CSV_FORMAT
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"';

CREATE TABLE IF NOT EXISTS AIRBNB.RAW.LISTINGS (
    listing_id NUMBER,
    host_id NUMBER,
    property_type VARCHAR,
    room_type VARCHAR,
    city VARCHAR,
    country VARCHAR,
    accommodates NUMBER,
    bedrooms NUMBER,
    bathrooms NUMBER,
    price_per_night NUMBER(10,2),
    created_at TIMESTAMP_NTZ
);

CREATE TABLE IF NOT EXISTS AIRBNB.RAW.HOSTS (
    host_id NUMBER,
    host_name VARCHAR,
    host_since DATE,
    is_superhost BOOLEAN,
    response_rate NUMBER,
    created_at TIMESTAMP_NTZ
);

-- booking_id is a UUID in the source data, stored as VARCHAR (not a number).
CREATE TABLE IF NOT EXISTS AIRBNB.RAW.BOOKINGS (
    booking_id VARCHAR,
    listing_id NUMBER,
    booking_date DATE,
    nights_booked NUMBER,
    booking_amount NUMBER(10,2),
    cleaning_fee NUMBER(10,2),
    service_fee NUMBER(10,2),
    booking_status VARCHAR,
    created_at TIMESTAMP_NTZ
);
