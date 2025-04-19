# Implementation Plan: Snowflake Advanced & Specialized Feature Expansion

This document describes an unambiguous, step-by-step plan to implement the next set of Snowflake features in the SQL Analyzer.  All syntax and semantics are based on the official Snowflake documentation (e.g., https://docs.snowflake.com).

## Feature Groups

A. Semi-Structured Data & Table Functions (LATERAL FLATTEN) [COMPLETED]
B. Cortex Search (SEARCH optimization) [COMPLETED]
C. Role Management (Application & Database Roles) [COMPLETED]
D. Container Services & Job Features (Snowpark & Jobs) [COMPLETED]
E. Machine Learning Operations (MODEL PREDICT, ML functions) [COMPLETED]
F. Apache Iceberg Table Support [COMPLETED]
G. Snowpark Container Services [COMPLETED]
H. Advanced Monitoring & Alerting (Resource Monitors, Alerts) [COMPLETED]
I. Row Access Policies (enhanced) [COMPLETED]
J. Column-Level Security & Dynamic Data Masking [COMPLETED]
K. Authentication Policies [COMPLETED]

---

### A. Semi-Structured Data & Table Functions [COMPLETED]
Documentation: https://docs.snowflake.com/en/sql-reference/functions/flatten.html

1. Grammar (`snowflake.lark`)
   - Add rule to support `LATERAL` and table function `FLATTEN` in `from_clause`:
     ```lark
     table_function_ref: LATERAL? function_call (AS? IDENTIFIER)?
     base_table_ref: ... | table_function_ref
     ```
   - Ensure `function_call` covers `FLATTEN(input => expr, path => ..., outer => boolean)`.
2. Visitor (`parser/visitor.py`)
   - Implement `visit_function_call` to detect `FLATTEN` and record its parameters.
   - In `select_stmt`, handle `table_function_ref` similar to `base_table_ref`, invoking a new `visit_flatten_call`:
     - Extract source column/expression and alias.
     - Record object reference for the JSON/XML source table.
3. Analysis (`analysis/engine.py` / `models.py`)
   - Record `FLATTEN` usage as a distinct action (e.g., `FLATTEN`) on the source table or column.
   - Track dependencies on JSON/XML columns.
4. Reporting (`reporting/formats/*`)
   - Add `FLATTEN` under query object interactions.
   - In text/JSON/HTML reports, list any flatten operations and their parameters.
5. Testing (`tests/fixtures/valid/flatten.sql` + `tests/test_parser.py`, `tests/test_analysis.py`)
   - Create SQL fixtures using `LATERAL FLATTEN` and nested JSON paths.
   - Write parser tests to ensure no syntax errors.
   - Write analysis tests verifying `FLATTEN` action and source object references.

---

### B. Snowflake Search Optimization [COMPLETED]
Documentation: https://docs.snowflake.com/en/sql-reference/commands/search-optimization-enable-disable.html

1. Grammar
   - Add rules for `ALTER SEARCH OPTIMIZATION ON <table>` and `ENABLE/DISABLE SEARCH OPTIMIZATION`.
2. Visitor
   - Add `visit_alter_search_optimization_stmt` to capture enable/disable operations.
3. Analysis
   - Record actions `ENABLE_SEARCH_OPTIMIZATION` and `DISABLE_SEARCH_OPTIMIZATION` on the target table.
4. Reporting
   - Include these in DDL statement counts and object interactions.
5. Testing
   - Fixtures for enabling/disabling search optimization on tables.

---

### C. Role Management (Application & Database Roles)
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-role.html, https://docs.snowflake.com/en/sql-reference/sql/grant-role.html

1. Grammar
   - `create_role_stmt`: already exists; extend to allow `IF NOT EXISTS`, `MANAGED ACCESS` options.
   - New rules for `grant_role_stmt`, `revoke_role_stmt`:
     ```lark
     grant_role_stmt: GRANT ROLE qualified_name TO ROLE qualified_name
     revoke_role_stmt: REVOKE ROLE qualified_name FROM ROLE qualified_name
     ```
2. Visitor
   - Implement `visit_grant_role_stmt` and `visit_revoke_role_stmt` in `parser/visitor.py`.
3. Analysis
   - Record object actions `GRANT_ROLE` and `REVOKE_ROLE`, dependencies between roles.
4. Reporting
   - Summarize role grants and revocations.
5. Testing
   - Fixtures with nested grants, roles, and cross-role hierarchies.

---

### D. Container Services & Job Features [COMPLETED]
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-job.html

1. Grammar
   - Add `create_job_stmt` and `alter_job_stmt` rules:
     ```lark
     create_job_stmt: CREATE JOB qualified_name JOB_PARAM* AS _statement_wrapper
     alter_job_stmt: ALTER JOB qualified_name (SUSPEND | RESUME | REMOVE SCHEDULE | ADD SCHEDULE)
     ```
2. Visitor
   - Implement `visit_create_job_stmt` and `visit_alter_job_stmt`.
   - Record job parameters (schedule, max_concurrency, warehouse).
3. Analysis
   - Record actions `CREATE_JOB`, `ALTER_JOB_SUSPEND`, `ALTER_JOB_RESUME`, `SCHEDULE_CHANGE`.
4. Reporting
   - Add job DDL to summaries and list job schedules.
5. Testing
   - Fixtures covering job creation, schedule modification, suspend/resume.

---

### E. Machine Learning Operations
Documentation: https://docs.snowflake.com/en/sql-reference/ml_predict.html

1. Grammar
   - Add support for `ML.PREDICT`, `ML.TRAIN` functions:
     ```lark
     function_call: ... | ML_CALL
     ML_CALL: "ML" "." ("PREDICT"|"TRAIN")
     ```
2. Visitor
   - Detect `ML.PREDICT` and `ML.TRAIN` in `visit_function_call`.
3. Analysis
   - Record these as `ML_PREDICT` and `ML_TRAIN` actions on model objects.
4. Reporting
   - Summarize ML operations in reports.
5. Testing
   - Fixtures using `ML.PREDICT(...)`, `ML.TRAIN(...)` on tables and UDFs.

---

### F. Apache Iceberg Table Support
Documentation: https://docs.snowflake.com/en/sql-reference/iceberg.html

1. Grammar
   - Add `CREATE ICEBERG TABLE`, `ALTER ICEBERG TABLE`, `DROP ICEBERG TABLE` rules.
2. Visitor
   - Implement visits to capture Iceberg-specific DDL.
3. Analysis
   - Record `CREATE_ICEBERG_TABLE`, `ALTER_ICEBERG_TABLE`, `DROP_ICEBERG_TABLE`.
4. Reporting
   - Include Iceberg table operations.
5. Testing
   - Fixtures with `CREATE ICEBERG TABLE ... LOCATION ...`, `ALTER ICEBERG TABLE ...`.

---

### G. Snowpark Container Services
Documentation: https://docs.snowflake.com/en/developer-guide/snowpark

1. Grammar
   - Support `CREATE PACKAGE`, `INSTALL PACKAGE`, `REMOVE PACKAGE` statements.
2. Visitor
   - Capture package management operations in `visit_create_package_stmt` etc.
3. Analysis
   - Record package install/uninstall actions.
4. Reporting
   - Summarize Snowpark package interactions.
5. Testing
   - Fixtures with Python/JAR package installs.

---

### H. Advanced Monitoring & Alerting
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-alert.html

1. Grammar
   - Add `CREATE ALERT`, `ALTER ALERT`, `DROP ALERT` rules.
2. Visitor
   - Implement `visit_create_alert_stmt`, `visit_alter_alert_stmt`.
3. Analysis
   - Record alert DDL and referenced objects (warehouse, database).
4. Reporting
   - Include alerts in DDL summary.
5. Testing
   - Fixtures with threshold-based alerts.

---

### I. Row Access Policies (Enhanced)
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-row-access-policy.html

1. Grammar: Already has `create_row_access_policy_stmt`; extend ALTER and DROP.
2. Visitor:
   - Add `visit_alter_row_access_policy_stmt`, `visit_drop_row_access_policy_stmt`.
3. Analysis: Record `ALTER_ROW_ACCESS_POLICY`, `DROP_ROW_ACCESS_POLICY` actions.
4. Reporting: Show policy changes per table.
5. Testing: Fixtures adding/dropping policies.

---

### J. Column-Level Security & Dynamic Data Masking
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-masking-policy.html

1. Grammar: Already supports `create_masking_policy_stmt`; extend `ALTER TABLE ... MODIFY COLUMN ... SET MASKING POLICY`.
2. Visitor: Implement `visit_alter_table_set_masking_policy`.
3. Analysis: Record `SET_MASKING_POLICY` on columns.
4. Reporting: Summarize masking policy assignments.
5. Testing: Fixtures setting and dropping masking policies on columns.

---

### K. Authentication Policies
Documentation: https://docs.snowflake.com/en/sql-reference/sql/create-authentication-policy.html

1. Grammar: Add `create_authentication_policy_stmt`, `alter_authentication_policy_stmt`, `drop_authentication_policy_stmt`.
2. Visitor: Implement corresponding `visit_...` methods.
3. Analysis: Record `CREATE_AUTH_POLICY`, `ALTER_AUTH_POLICY`, `DROP_AUTH_POLICY`.
4. Reporting: Include in security DDL summary.
5. Testing: Fixtures for complex authentication policy definitions.

---

## General Approach

* Implement one feature group at a time, fully covering grammar, visitor, analysis, reporting, and tests before moving to the next.
* Reference official Snowflake docs URLs in the implementation tickets.
* Use existing patterns in `snowflake_next_features.md` and ensure consistency in naming conventions.
* Ensure full test coverage: positive, negative, and edge cases.
* Aim for incremental pull requests to allow review and avoid merge conflicts. 