# Unsupported Snowflake Syntax

The SQL Analyzer currently parses a large portion of Snowflake SQL, but several syntax areas remain unsupported or only partially implemented. This document summarizes the main gaps.

## Core SQL Features
- Advanced built-in functions such as `DATEADD` and `DATEDIFF`

## DDL and Data Types
- `ALTER TABLE` variants like `PIVOT`/`UNPIVOT` and advanced clustering options

## Semi-Structured Data and Table Functions
- User-defined table functions (UDTFs)

## Ecosystem and Advanced Services
- Snowpipe and Snowpipe Streaming commands
- Snowpark Container Services and Python UDF features
- Machine learning operations (`CREATE MODEL`, `PREDICT`)
- Organization-wide features such as privacy policies and external access integrations

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

These gaps represent opportunities for future enhancements. Contributions and issue reports are welcome to help extend coverage.
