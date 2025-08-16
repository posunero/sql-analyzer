# Unsupported Snowflake Syntax

The SQL Analyzer currently parses a large portion of Snowflake SQL, but several syntax areas remain unsupported or only partially implemented. This document summarizes the main gaps.

## Core SQL Features
- `QUALIFY` clause
- `SAMPLE`/`TABLESAMPLE`
- `PIVOT` and `UNPIVOT`
- Window frame options like `ROWS BETWEEN` and `RANGE BETWEEN`
- Advanced built-in functions such as `DATEADD`, `DATEDIFF`, `RESULT_SCAN`, and `LAST_QUERY_ID`

## DDL and Data Types
- Complete support for Snowflake data types (e.g., `VARIANT`, `OBJECT`, `ARRAY`, `TIME`, `GEOGRAPHY`)
- `ALTER TABLE` variants like `PIVOT`/`UNPIVOT` and advanced clustering options
- Expanded `GRANT`/`REVOKE` privileges and role management features
- `SHOW`/`DESCRIBE` for all Snowflake object kinds

## Procedural and Scripting Constructs
- `IF`, `ELSE`, and `CASE` blocks inside scripting
- Looping constructs (`LOOP`, `WHILE`, `FOR`)
- Exception handling (`TRY`/`CATCH`)
- Multi-statement blocks with variable scoping and `RETURN`

## Semi-Structured Data and Table Functions
- Full `FLATTEN` support including `PATH`, `OUTER`, and `RECURSIVE` parameters
- Additional table functions like `OBJECT_KEYS` and `ARRAY_SIZE`
- User-defined table functions (UDTFs)

## Ecosystem and Advanced Services
- Snowpipe and Snowpipe Streaming commands
- Snowpark Container Services and Python UDF features
- Machine learning operations (`CREATE MODEL`, `PREDICT`)
- Organization-wide features such as privacy policies and external access integrations

These gaps represent opportunities for future enhancements. Contributions and issue reports are welcome to help extend coverage.
