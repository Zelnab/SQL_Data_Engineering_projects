--duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

--step 2: DW - Load data from CSV files into tables
.read 02_load_schema_dw.sql

--step 3: Mart _ Create flat mart
.read 03_create_flat_mart.sql

.read 04_create_skills_marts.sql