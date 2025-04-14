# Extended Analytics Feature Specification

This document outlines the requirements and implementation considerations for adding extended analytics and risk assessment capabilities to the SQL Analyzer.

## 1. Feature Goal

Enhance the SQL Analyzer to provide deeper insights into SQL scripts, specifically focusing on identifying and quantifying potentially destructive or high-risk operations, and tracking object interactions. This involves:

*   Collecting more granular statistics about SQL statement types and patterns.
*   Identifying statements that modify or destroy data/objects (e.g., `DELETE`, `DROP`, `REPLACE`, `TRUNCATE`, `ALTER TABLE ... DROP COLUMN`).
*   Reporting on the specific database objects (tables, views, etc.) targeted by both destructive and non-destructive actions.
*   Providing a basic risk assessment based on the presence and nature of destructive operations.

## 2. New Statistics and Information to Collect

The analysis engine needs to be extended to gather the following:

*   **Destructive Statement Counts:**
    *   Count of `DELETE` statements.
    *   Count of `DROP TABLE`, `DROP VIEW`, `DROP SCHEMA`, `DROP DATABASE`, etc. statements (categorized by object type dropped).
    *   Count of `TRUNCATE TABLE` statements.
    *   Count of `CREATE OR REPLACE ...` statements (categorized by object type being replaced). Treat these as potentially destructive.
    *   Count of `ALTER TABLE ... DROP COLUMN` statements.
    *   Count of `UPDATE` statements.
*   **Targeted Objects (Destructive Actions):**
    *   For each destructive statement identified above (`DELETE`, `DROP`, `TRUNCATE`, `CREATE OR REPLACE`, `ALTER ... DROP COLUMN`), record the name(s) and type(s) of the object(s) being targeted, associated with the specific action.
    *   Example: `DELETE FROM my_table` -> Record `my_table` (Table) associated with `DELETE`.
    *   Example: `DROP VIEW my_view` -> Record `my_view` (View) associated with `DROP`.
    *   Example: `CREATE OR REPLACE TABLE my_data ...` -> Record `my_data` (Table) associated with `REPLACE`.
    *   Example: `ALTER TABLE t1 DROP COLUMN c1` -> Record `t1` (Table) and `c1` (Column) associated with `DROP COLUMN`.
*   **Targeted Objects (Non-Destructive Actions):**
    *   For other common DML/query statements (`SELECT`, `INSERT`, `UPDATE`), record the name(s) and type(s) of the primary object(s) being targeted (read from or written to), associated with the specific action.
    *   Example: `SELECT col1 FROM my_table` -> Record `my_table` (Table) associated with `SELECT`.
    *   Example: `INSERT INTO my_other_table ...` -> Record `my_other_table` (Table) associated with `INSERT`.
    *   Example: `UPDATE my_table SET ...` -> Record `my_table` (Table) associated with `UPDATE`.

## 3. Risk Assessment

*   The primary goal is **identification and reporting** of potentially destructive actions, not a complex scoring system. Simple identification is sufficient for this phase.
*   The presence of any destructive statements (as defined in section 2) should be flagged in the report.
*   The report should clearly list which objects are subject to which destructive actions.
*   Contextual analysis (e.g., checking if a `DELETE` is within a transaction) is out of scope for this phase due to complexity.
*   Snowflake-specific features like Time Travel (`UNDROP`) will not be considered in the risk assessment for this phase.

## 4. Implementation Considerations

*   **`analysis/models.py`:**
    *   Extend `AnalysisResult` to store the destructive counts (e.g., `destructive_counts: Dict[str, int]`), including counts for `ALTER TABLE ... DROP COLUMN`.
    *   Add/refine a structure to store targeted objects associated with actions. This should handle both destructive and non-destructive actions. (e.g., `object_interactions: Dict[Tuple[str, str], List[str]]`, mapping (object_type, object_name) tuples to a list of actions like 'DELETE', 'DROP', 'REPLACE', 'DROP COLUMN', 'SELECT', 'INSERT', 'UPDATE').
*   **`parser/visitor.py`:**
    *   Add or modify visitor methods (`visit_delete_statement`, `visit_drop_table_statement`, `visit_truncate_statement`, `visit_create_or_replace_table_statement`, `visit_alter_table_statement`, `visit_select_statement`, `visit_insert_statement`, `visit_update_statement`, etc.) to identify these statements and the objects they target.
    *   Ensure the visitor extracts the target object names (and potentially column names for `DROP COLUMN`) from these statements.
*   **`analysis/engine.py`:**
    *   Add methods to the `AnalysisEngine` to be called by the visitor when relevant statements or targets are found.
    *   These methods will update the `AnalysisResult` object, populating the destructive counts and the `object_interactions` structure.
*   **Grammar (`snowflake.lark`):**
    *   Verify that the grammar correctly and unambiguously parses `DELETE`, `DROP`, `TRUNCATE`, `CREATE OR REPLACE`, and `ALTER TABLE ... DROP COLUMN` statements for various object types. Enhancements may be required.
    *   Ensure target table names can be reliably extracted from `SELECT`, `INSERT`, and `UPDATE` statements.

## 5. Reporting (`reporting/formats/`)

*   **Text Format (`text.py`):**
    *   Add a dedicated "Destructive Operations Summary" section listing counts of each destructive statement type.
    *   Add a section "Object Interaction Summary" (or similar). This section should list each object identified and the specific actions (destructive and non-destructive) performed on it.
    *   Example:
        ```
        Object Interaction Summary:
        - Table: my_table
          - Actions: DELETE, SELECT, UPDATE
        - View: my_view
          - Actions: DROP
        - Table: my_data
          - Actions: REPLACE
        - Table: t1
          - Actions: DROP COLUMN (c1), SELECT
        - Table: my_other_table
          - Actions: INSERT
        ```
*   **JSON Format (`json.py`):**
    *   Include the destructive counts and the detailed object interaction structure (e.g., the `object_interactions` dictionary proposed above) within the JSON output, likely nested under a specific key like `extended_analysis`.

## 6. Open Questions for Discussion

1.  **Scope of "Destructive":** Are `UPDATE` statements considered destructive enough to track specifically? What about `ALTER TABLE ... DROP COLUMN`? Should we focus only on object/data removal initially?
    DROP column is a good callout, please also highlight this type of action as well.
2.  **Risk Level Categorization:** Is simple identification sufficient for now, or should we attempt to categorize risks (e.g., `DROP DATABASE` is higher risk than `DELETE FROM table WHERE ...`)?
    Let's keep it simple for now
3.  **Contextual Analysis:** Should the analysis attempt to understand context (e.g., `DELETE` within a transaction)?
    Too complex, please keep it simple here
4.  **`CREATE OR REPLACE` Nuance:** How exactly should `CREATE OR REPLACE` be flagged? It's destructive *if* the object exists. Should it always be flagged as potentially destructive?
    Yes it should always be flagged
5.  **Reporting Granularity:** How detailed should the reporting of affected objects be? Just a list, or associate each object with the specific action(s) targeting it? 
    Associate them with actions
6.  **Snowflake Specifics:** Should Snowflake features like Time Travel (`UNDROP`) be considered in the risk assessment?
    No
7.  **Further Statistics:** Beyond destructive actions, are there other specific non-destructive statement types or patterns that would be valuable to count (e.g., usage of specific functions, joins, window functions)? 
    Please also keep track of target tables for non-destructive actions as well