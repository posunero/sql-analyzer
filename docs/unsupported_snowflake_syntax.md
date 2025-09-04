# Unsupported Snowflake Syntax

The SQL Analyzer currently parses a large portion of Snowflake SQL, but several syntax areas remain unsupported or only partially implemented. This document summarizes the main gaps.

## Core SQL Features
- (none currently identified)

## DDL and Data Types
- Streamlit apps, dynamic tables, hybrid tables, datasets, and snapshots
- Snowpark Container Services such as compute pools and services
- Application packages, listings, and connections
- Secrets, password policies, and network rules
- Advanced table and schema options (classification profiles, storage serialization policy, compute pool defaults)
- Creation of user-defined table functions (UDTFs)

## Ecosystem and Advanced Services
- Machine learning model DDL and management (`CREATE MODEL`, `ALTER MODEL`, versioning)
- Advanced function options like `SERVICE` and `CONTEXT_HEADERS`

## Recently Implemented Features

- Join variants including `ASOF`, `NATURAL`, and `DIRECTED` joins
- Hierarchical queries with `START WITH`/`CONNECT BY`, `LEVEL`, and `CONNECT_BY_ROOT`
- LATERAL `TABLE` functions with named arguments using `=>`
- `VALUES` sources with positional `$n` column references
- `PIVOT` and `UNPIVOT` table operators
- `QUALIFY` clause for post-aggregation filtering
- `SAMPLE`/`TABLESAMPLE` with optional `REPEATABLE` seeds
- Time-travel clauses `AT`, `BEFORE`, and `CHANGES`
- Result limiting via `TOP`, `FETCH`, and `FOR UPDATE`
- `MATCH_RECOGNIZE` table operator
- `GROUPING SETS`, `ROLLUP`, `CUBE`, `GROUPING`, and `GROUPING_ID`
- `CREATE SEMANTIC VIEW` and `SEMANTIC_VIEW()` table references
- New data types `VECTOR`, `GEOGRAPHY`, and `GEOMETRY`
- Comprehensive window frame definitions with `ROWS`, `RANGE`, or `GROUPS` and `EXCLUDE` options
- `CREATE/ALTER/DROP/GRANT/REVOKE DATABASE ROLE` (e.g., `CREATE DATABASE ROLE IF NOT EXISTS reporting_role`)
- `CREATE/ALTER/DROP/GRANT/REVOKE APPLICATION ROLE` (e.g., `CREATE APPLICATION ROLE app_role`)
- `CREATE/ALTER/DROP/SHOW/DESCRIBE/EXECUTE ALERT` (e.g., `CREATE ALERT my_alert WAREHOUSE = my_wh SCHEDULE = '1 minute' IF EXISTS (SELECT 1) THEN CALL my_proc();`)
- Notification integrations (e.g., `CREATE NOTIFICATION INTEGRATION email_int TYPE = EMAIL DIRECTION = OUTBOUND ENABLED = TRUE`)
- `ML.PREDICT` and `ML.TRAIN` function calls
- Star modifiers `EXCLUDE`, `REPLACE`, and `RENAME` in `SELECT *` lists
- Enhanced `COPY INTO` options including `LOAD_MODE`
- `CREATE EXTERNAL TABLE` without column definitions and with `INTEGRATION`/`WITH LOCATION` clauses
- Apache Iceberg table DDL
- Snowpark package management (`CREATE/INSTALL/REMOVE PACKAGE`)
- Row access and masking policies
- Authentication policy statements
- Resource monitor statements

These gaps represent opportunities for future enhancements. Contributions and issue reports are welcome to help extend coverage.
