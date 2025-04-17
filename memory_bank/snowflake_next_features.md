# Implementation Plan: High-Priority Snowflake Feature Expansion

This document outlines the steps to add key missing Snowflake features to the SQL Analyzer's grammar, parser, and analysis engine. The focus is on improving coverage for common data engineering and DML tasks.

**High-Priority Features:**

1.  `COPY INTO` (including related `CREATE STAGE` and `CREATE FILE FORMAT` options)
2.  `CREATE TASK` / `ALTER TASK`
3.  `CREATE STREAM` / `ALTER STREAM`
4.  `CREATE PIPE` / `ALTER PIPE`
5.  `MERGE` Statement

**General Approach for Each Feature:**

*   **Grammar (`snowflake.lark`):** Define Lark rules for the statement's syntax. Start with core functionality and iteratively add options.
*   **Visitor (`parser/visitor.py`):** Implement `visit_...` methods for the new Lark tree nodes corresponding to these statements.
*   **Analysis (`analysis/engine.py`, `analysis/models.py`):** Extract relevant information (object names, actions, dependencies, referenced objects) within the visitor methods and update the `AnalysisResult` accordingly. This may involve adding new `action` types to `ObjectInfo` or modifying how interactions are recorded.
*   **Reporting (`reporting/formats/...`):** Update text, JSON, and HTML report formats to display information about the newly analyzed statements and objects.
*   **Testing (`tests/...`):** Create new `.sql` fixture files demonstrating the features and add corresponding tests in `test_parser.py`, `test_analysis.py`, and `test_reporting.py`.

---

## 1. `COPY INTO`, `STAGE`, `FILE FORMAT`

**Progress Update (Implementation in Progress):**
- [x] Visitor methods for `CREATE STAGE`, `CREATE FILE FORMAT`, and `COPY INTO` have been implemented in `parser/visitor.py` (now extract and record object names, actions, and detailed options/references such as FILE_FORMAT, URL, TYPE, etc.).
- [x] Extraction of detailed options and references for these statements is complete in the visitor.
- [x] Reporting layer (text, JSON, HTML) now highlights and summarizes STAGE, FILE_FORMAT, and COPY INTO actions and references.
- [x] Thorough tests (positive and negative) have been added for CREATE STAGE, CREATE FILE FORMAT, and COPY INTO, covering parsing, analysis, and reporting.
- [x] Feature 1 is fully implemented and tested.

**Goal:** Parse and analyze data loading/unloading commands, including the necessary stage and file format definitions.

**Steps:**

1.  **Grammar (`snowflake.lark`):**
    *   Define rules for `CREATE STAGE`: Include basic options like `URL`, `STORAGE_INTEGRATION`, `CREDENTIALS` (perhaps simplified initially), `FILE_FORMAT` reference, `COPY_OPTIONS` (basic `ON_ERROR`).
    *   Define rules for `CREATE FILE FORMAT`: Include `TYPE = CSV | JSON | PARQUET | ...`, and common options for each type (e.g., `FIELD_DELIMITER`, `SKIP_HEADER` for CSV; `STRIP_OUTER_ARRAY` for JSON).
    *   Define rules for `COPY INTO <table> FROM <location>`:
        *   `<location>`: `@<stage_name>[/<path>]` or internal stage names (`@%<table>`, `@~`).
        *   Options: `FILES = (...)`, `PATTERN = '...'`, `FILE_FORMAT = (TYPE = ... | FORMAT_NAME = ...)`, `COPY_OPTIONS` (`ON_ERROR`, `VALIDATION_MODE`), basic `SELECT` transformations (`COPY INTO ... FROM (SELECT ... FROM @stage)`).
    *   Define rules for `COPY INTO <location> FROM <table>`: Include basic options.
    *   *Note:* The `COPY INTO` command has many options. Start with the core syntax and common options, planning for iterative enhancement.
2.  **Visitor (`parser/visitor.py`):**
    *   Add `visit_create_stage_statement`, `visit_alter_stage_statement` (if adding alter).
    *   Add `visit_create_file_format_statement`, `visit_alter_file_format_statement`.
    *   Add `visit_copy_statement`.
3.  **Analysis (`analysis/engine.py` / `models.py`):**
    *   For `CREATE STAGE`/`FILE FORMAT`: Record object creation (`action='CREATE'`). Note referenced integrations or formats.
    *   For `COPY INTO`:
        *   Identify direction (to table or to stage).
        *   Record action: `COPY_INTO_TABLE` or `COPY_INTO_STAGE`.
        *   Identify source and target (table/stage name).
        *   Record references to the stage, table, and any specified `FILE_FORMAT` or `STORAGE_INTEGRATION`.
        *   If a `SELECT` transformation is used, analyze the inner `SELECT` statement recursively.
4.  **Reporting:**
    *   Add counts for `CREATE_STAGE`, `CREATE_FILE_FORMAT`, `COPY_INTO_TABLE`, `COPY_INTO_STAGE` to summaries.
    *   List created stages/formats and copy operations in detailed object/interaction lists.
5.  **Testing:**
    *   Create `.sql` fixtures with various `CREATE STAGE`, `CREATE FILE FORMAT`, and `COPY INTO` commands (both directions, different options).
    *   Add tests verifying correct parsing and extraction of sources, targets, and referenced objects.

---

## 2. `TASK`

**Progress Update:**
- [x] The grammar now correctly supports CREATE TASK, ALTER TASK, DROP TASK, and EXECUTE TASK statements
- [x] Visitor methods for `create_task_stmt`, `alter_task_stmt`, and `execute_task_stmt` have been implemented
- [x] Fixed the `drop_stmt` visitor method to correctly identify and extract TASK objects from DROP TASK statements
- [x] Added special handling in the engine's `record_destructive_statement` to ensure DROP_TASK statements are properly counted
- [x] Added tests to verify correct parsing and analysis of DROP TASK statements
- [x] Basic dependency tracking between tasks (via AFTER clause) implemented (ADD/REMOVE AFTER)
- [x] Basic analysis of SQL in the AS clause implemented (identifies table/proc references)
- [x] Further enhancement needed for complex dependency scenarios (AFTER clause)
- [x] Further enhancement needed for full dependency tracking within AS clause SQL

**Goal:** Parse and analyze task creation and alteration for scheduled SQL execution.

**Steps:**

1.  **Grammar (`snowflake.lark`):**
    *   Define rules for `CREATE TASK [IF NOT EXISTS] <name> ...`: Include `WAREHOUSE = <name>`, `SCHEDULE = '...'`, `ALLOW_OVERLAPPING_EXECUTION`, `USER_TASK_TIMEOUT_MS`, `AFTER <task_name>` (dependency), `AS <sql_statement>`.
    *   Define rules for `ALTER TASK <name> ...`: Include `RESUME`, `SUSPEND`, `REMOVE AFTER <task_name>`, `ADD AFTER <task_name>`, `SET WAREHOUSE = ...`, `SET SCHEDULE = ...`, `MODIFY AS <sql_statement>`.
2.  **Visitor (`parser/visitor.py`):**
    *   Add `visit_create_task_statement`.
    *   Add `visit_alter_task_statement`.
3.  **Analysis (`analysis/engine.py` / `models.py`):**
    *   Record task creation/alteration (`action='CREATE_TASK'`, `'ALTER_TASK'`).
    *   Record reference to the specified `WAREHOUSE`.
    *   Record dependencies (`AFTER`).
    *   Analyze the SQL statement within the `AS` clause recursively to find its object dependencies. Link these dependencies back to the task itself.
4.  **Reporting:**
    *   Add counts for `CREATE_TASK`, `ALTER_TASK`.
    *   List tasks, their referenced warehouses, schedules (if extracted), and dependencies.
5.  **Testing:**
    *   Create `.sql` fixtures with `CREATE TASK` (simple, with schedule, with `AFTER`), and `ALTER TASK` (resume/suspend, set options).
    *   Add tests verifying parsing and extraction of task properties, warehouse references, and dependencies from the `AS` clause.

---

## 3. `STREAM` ✅

**Goal:** Parse and analyze stream creation and alteration for CDC.

**Steps:**

1.  **Grammar (`snowflake.lark`):**
    *   Define rules for `CREATE STREAM [IF NOT EXISTS] <name> ON TABLE <table_name>`: Include `APPEND_ONLY = TRUE|FALSE`, `SHOW_INITIAL_ROWS = TRUE|FALSE`, `AT/BEFORE (TIMESTAMP => ..., OFFSET => ..., STATEMENT => ...)`. 
    *   Define rules for `ALTER STREAM <name> SET ...` (e.g., `COMMENT = '...'`).
    *   Define rules for `DROP STREAM [IF EXISTS] <name>`.
2.  **Visitor (`parser/visitor.py`):**
    *   Add `visit_create_stream_statement`.
    *   Add `visit_alter_stream_statement`.
    *   Add `visit_drop_stream_statement`.
3.  **Analysis (`analysis/engine.py` / `models.py`):**
    *   Record stream actions (`action='CREATE_STREAM'`, `'ALTER_STREAM'`, `'DROP_STREAM'`).
    *   Identify the base table (`ON TABLE`). Record this as a dependency/reference.
    *   Extract properties like `APPEND_ONLY`.
4.  **Reporting:**
    *   Add counts for stream DDL.
    *   List streams, their base tables, and key properties.
5.  **Testing:**
    *   Create `.sql` fixtures with `CREATE STREAM` (default, append-only) and `ALTER STREAM`.
    *   Add tests verifying parsing and extraction of stream name, base table, and properties.

---

## 4. `PIPE`

**Goal:** Parse and analyze pipe creation and alteration for Snowpipe.

**Steps:**

1.  **Grammar (`snowflake.lark`):**
    *   Define rules for `CREATE PIPE [IF NOT EXISTS] <name> ...`: Include `AUTO_INGEST = TRUE|FALSE`, `AWS_SNS_TOPIC = '...'` / `AZURE_EVENT_GRID_TOPIC = '...'` / `GCP_PUBSUB_SUBSCRIPTION = '...'`, `COMMENT = '...'`, `AS <copy_statement>`.
    *   Define rules for `ALTER PIPE <name> ...`: Include `SET ...` (e.g., `PIPE_EXECUTION_PAUSED = TRUE|FALSE`), `REFRESH`.
    *   Define rules for `DROP PIPE [IF EXISTS] <name>`.
2.  **Visitor (`parser/visitor.py`):**
    *   Add `visit_create_pipe_statement`.
    *   Add `visit_alter_pipe_statement`.
    *   Add `visit_drop_pipe_statement`.
3.  **Analysis (`analysis/engine.py` / `models.py`):**
    *   Record pipe actions (`action='CREATE_PIPE'`, `'ALTER_PIPE'`, `'DROP_PIPE'`).
    *   Extract properties like `AUTO_INGEST`.
    *   Crucially, parse and analyze the embedded `<copy_statement>` recursively, linking its dependencies (source stage, target table, file format) back to the pipe.
4.  **Reporting:**
    *   Add counts for pipe DDL.
    *   List pipes and key properties. Indicate the associated `COPY` command details.
5.  **Testing:**
    *   Create `.sql` fixtures with `CREATE PIPE` embedding a valid `COPY INTO` statement. Include `ALTER PIPE`.
    *   Add tests verifying parsing and extraction of pipe properties and the details/dependencies of the embedded `COPY` statement.

---

## 5. `MERGE`

**Goal:** Parse and analyze the `MERGE` DML statement.

**Steps:**

1.  **Grammar (`snowflake.lark`):**
    *   Define rules for `MERGE INTO <target_table> USING <source> ON <join_condition> ...`:
        *   Source: table name, subquery.
        *   Clauses: `WHEN MATCHED [AND <condition>] THEN <UPDATE | DELETE>`, `WHEN NOT MATCHED [AND <condition>] THEN INSERT (...) VALUES (...)`. Multiple `WHEN` clauses allowed.
2.  **Visitor (`parser/visitor.py`):**
    *   Add `visit_merge_statement`.
    *   Add visitors for sub-clauses if needed (`visit_when_matched_clause`, `visit_when_not_matched_clause`).
3.  **Analysis (`analysis/engine.py` / `models.py`):**
    *   Record statement type `MERGE`.
    *   Identify target table and source table/subquery.
    *   Record interactions on the *target table*:
        *   `REFERENCE` (for the `ON` condition).
        *   `UPDATE` (if `WHEN MATCHED THEN UPDATE`).
        *   `DELETE` (if `WHEN MATCHED THEN DELETE`).
        *   `INSERT` (if `WHEN NOT MATCHED THEN INSERT`).
    *   Record `REFERENCE` interaction for the source table/objects within the source subquery.
    *   Record `REFERENCE` for columns used in `ON` and `AND` conditions.
4.  **Reporting:**
    *   Add `MERGE` count to statement summaries.
    *   Ensure the Object Interactions table reflects the underlying `INSERT`/`UPDATE`/`DELETE`/`REFERENCE` actions performed by the `MERGE` on the target and source tables.
5.  **Testing:**
    *   Create `.sql` fixtures with `MERGE` statements (simple, with `UPDATE`, `DELETE`, `INSERT`, multiple clauses, subquery source).
    *   Add tests verifying parsing and the correct recording of interactions on target and source tables.

---

## 6. General Considerations

*   **Iterative Development:** Tackle one feature group at a time (e.g., start with `MERGE` or `STAGE`/`FILE FORMAT`/`COPY`). Fully implement grammar, visitor, analysis, reporting, and tests for that group before moving to the next. The `COPY INTO` grammar is complex and may require several iterations.
*   **Parser Ambiguity:** Be mindful of potential ambiguities when adding complex syntax. Use Lark's features (`%import common.WS`, precedence rules `%left`, `%right`) as needed. Test ambiguous cases.
*   **Testing:** Thoroughly test parsing edge cases and ensure the analysis correctly identifies all relevant objects and actions.
*   **Performance:** While less critical initially, complex grammars can impact parsing speed. Keep an eye on performance for very large files. 