#!/bin/bash
# Fetches the source Airbnb CSVs from the tutorial's source-of-truth repo.
# Run from the airbnb_dbt/ project root: bash scripts/fetch_source_data.sh
set -e

mkdir -p SourceData

curl -o SourceData/listings.csv https://raw.githubusercontent.com/anshlambagit/Airbnb_Snowflake_DBT_Data_Engineer_Project/main/SourceData/listings.csv
curl -o SourceData/hosts.csv https://raw.githubusercontent.com/anshlambagit/Airbnb_Snowflake_DBT_Data_Engineer_Project/main/SourceData/hosts.csv
curl -o SourceData/bookings.csv https://raw.githubusercontent.com/anshlambagit/Airbnb_Snowflake_DBT_Data_Engineer_Project/main/SourceData/bookings.csv

echo "Downloaded source CSVs:"
wc -l SourceData/*.csv
