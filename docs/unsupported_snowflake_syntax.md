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

These gaps represent opportunities for future enhancements. Contributions and issue reports are welcome to help extend coverage.
