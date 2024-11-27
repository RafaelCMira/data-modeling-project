#!/bin/bash
CSV_FILE=$1
TABLE_NAME=$2
#PGPASSWORD=root psql -h localhost -p 5432 -U postgres -d test -c "COPY $TABLE_NAME FROM '$CSV_FILE' WITH (FORMAT csv, HEADER true);"

PGPASSWORD=root psql -h winhost  -p 5432 -U postgres -d test