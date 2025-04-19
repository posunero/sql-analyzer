# Snowflake Full Core Coverage Implementation Plan

## 1. Introduction
This document outlines step-by-step instructions to implement all core Snowflake SQL syntax features missing from our current Lark grammar (`sql_analyzer/grammar/snowflake.lark`). The plan is detailed enough for a junior engineer to follow without ambiguity.

## 2. Prerequisites
- Familiarity with Python and the Lark parsing library
- Local checkout of the repo, with the grammar file at `sql_analyzer/grammar/snowflake.lark`
- A test harness under `tests/grammar/` that executes sample SQL files against the parser

## 3. Grammar File Structure
1. **Terminals block**: at the top of `snowflake.lark`, keywords (e.g. `SELECT`, `CREATE`) are defined in uppercase.
2. **Parser rules**: statements are grouped by type:
   - `dml_stmt`
   - `ddl_stmt` → `create_stmt`, `alter_stmt`, `drop_stmt`, etc.
   - `statement` includes all top‐level rules

## 4. Terminal Definitions

### 4.1 Locate the Keywords Section
Open `snowflake.lark` and scroll to where terminals are declared (lines with `%import` and names in ALL CAPS).

### 4.2 Add Missing Keywords
Insert the following lines (in alphabetical order) under the DDL keywords group:
```lark
CLONE: "CLONE"i
EXTERNAL: "EXTERNAL"i
FORCE: "FORCE"i
GET: "GET"i
HEADER: "HEADER"i
INTEGRATION: "INTEGRATION"i
LIST: "LIST"i
MATERIALIZED: "MATERIALIZED"i
NETWORK: "NETWORK"i
PATTERN: "PATTERN"i
PURGE: "PURGE"i
REPLICATION: "REPLICATION"i
SHARE: "SHARE"i
UNSET: "UNSET"i
VALIDATE: "VALIDATE"i
```

## 5. Grammar Rule Additions
For each feature below, perform these general steps:
1. **Add new rule(s):** define one or more `_stmt` or helper rules.
2. **Integrate:** include them in the union rules (`create_stmt`, `alter_stmt`, `drop_stmt`, `show_stmt`, `statement`).
3. **Test:** create example SQL in `tests/grammar/feature_name.sql` and verify parsing.

### 5.1 CLONE Commands
**File:** `sql_analyzer/grammar/snowflake.lark`
1. Define a helper clause:
    ```lark
    // after existing helper rules
    clone_clause: CLONE qualified_name
    ```
2. Extend existing `create_<object>_stmt` rules:
    ```diff
    create_table_stmt: CREATE (OR REPLACE)? TRANSIENT? TABLE qualified_name (
      LPAREN ... RPAREN (cluster_by_clause? data_retention_clause? with_tag_clause?)?
      | AS select_stmt
    + | clone_clause
    )
    ```
3. Apply the same pattern to:
   - `create_database_stmt`
   - `create_schema_stmt`

**Test file:** `tests/grammar/clone.sql`:
```sql
CREATE TABLE new_tbl CLONE old_db.old_schema.old_tbl;
CREATE SCHEMA new_schema CLONE old_db.old_schema;
CREATE DATABASE new_db CLONE production_db;
```

### 5.2 SHARE Commands
1. Add rules:
    ```lark
    create_share_stmt: CREATE (OR REPLACE)? SHARE (IF NOT EXISTS)? qualified_name
    alter_share_stmt: ALTER SHARE qualified_name (ADD DATA? | DROP DATA?)? // refine per docs
    drop_share_stmt: DROP SHARE (IF EXISTS)? qualified_name
    ```
2. Integrate:
    ```lark
    create_stmt: ... | create_share_stmt
    alter_stmt: ... | alter_share_stmt
    drop_stmt: ...   | drop_share_stmt
    ```
**Test:** `tests/grammar/share.sql`

### 5.3 INTEGRATION Objects
1. Define `create_integration_stmt`, `alter_integration_stmt`, `drop_integration_stmt` with appropriate clauses (e.g. TYPE = ...).
2. Add into `create_stmt`, `alter_stmt`, `drop_stmt`.
**Test:** `tests/grammar/integration.sql`

### 5.4 External Tables
1. Add `create_external_table_stmt`, `alter_external_table_stmt`, `drop_external_table_stmt`.
2. Integrate into unions.
**Test:** `tests/grammar/external_table.sql`

### 5.5 Materialized Views
1. Add `create_materialized_view_stmt`, `alter_materialized_view_stmt`, `drop_materialized_view_stmt`.
2. Integrate.
**Test:** `tests/grammar/materialized_view.sql`

### 5.6 External Functions
1. Add `create_external_function_stmt`, `alter_external_function_stmt`, `drop_external_function_stmt`.
2. Integrate.
**Test:** `tests/grammar/external_function.sql`

### 5.7 Network Policies
1. Add `create_network_policy_stmt`, `alter_network_policy_stmt`, `drop_network_policy_stmt`.
2. Integrate.
**Test:** `tests/grammar/network_policy.sql`

### 5.8 Replication
1. Add `create_replication_stmt`, `alter_replication_stmt`, `show_replication_stmt`, `failover_stmt`.
2. Integrate under `statement`.
**Test:** `tests/grammar/replication.sql`

### 5.9 Account-Level Commands
1. Define `create_account_stmt`, `alter_account_stmt`, `drop_account_stmt`, `show_accounts_stmt`, `failover_recovery_stmt`.
2. Integrate.
**Test:** `tests/grammar/account.sql`

### 5.10 Session Management
1. Extend `set_stmt` to allow `UNSET IDENTIFIER`.
2. Add `alter_session_stmt`, `show_parameters_stmt`.
**Test:** `tests/grammar/session.sql`

### 5.11 Stage File Utilities
1. Add:
    ```lark
    list_stmt: LIST STAGE_PATH (PATTERN SINGLE_QUOTED_STRING)?
    get_stmt: GET file_path STAGE_PATH (PURGE | VALIDATE)?
    remove_stmt: REMOVE STAGE_PATH (PATTERN SINGLE_QUOTED_STRING)?
    alter_stage_stmt: ALTER STAGE qualified_name SET (FILE_FORMAT EQ qualified_name | URL EQ SINGLE_QUOTED_STRING)
    ```
2. Integrate into `statement`.
**Test:** `tests/grammar/stage_utils.sql`

### 5.12 SHOW Variants
1. In the `show_stmt` rule, extend `object_types` to include:
    ```lark
    object_types: TABLES | VIEWS | WAREHOUSES | ... | SHARES | INTEGRATIONS | REPLICATIONS | EXTERNAL TABLES | MATERIALIZED VIEWS | USERS | ROLES | PARAMETERS
    ```
2. Or create specialized show_xxx rules.
**Test:** `tests/grammar/show_variants.sql`

### 5.13 COPY INTO Enhancements
1. Update `copy_option` to include:
    ```lark
    copy_option: ...
      | FORCE
      | PATTERN SINGLE_QUOTED_STRING
      | HEADER number
      | VALIDATE boolean
      | PURGE boolean
    ```
2. Integrate into `copy_into_stmt`.
**Test:** `tests/grammar/copy_enhancements.sql`

### 5.14 ALTER Command Enhancements
1. **Warehouse**: add `| RENAME TO qualified_name` to `alter_warehouse_stmt`.
2. **Table**: add `| CLUSTER BY LPAREN expr (COMMA expr)* RPAREN` to `alter_table_stmt`.
3. **Resource Monitor**: add `| SUSPEND` and `| RESUME` to `alter_resource_monitor_stmt` (if split out).
4. **Stage**: covered above.

## 6. Testing and Validation
1. Place each feature's examples in `tests/grammar/`.
2. Run the parser against each file:
   ```bash
   pytest tests/grammar/ --maxfail=1 -q
   ```
3. Confirm no Lark parse errors.
4. Add CI check to reject untested grammar rules.

## 7. Documentation Updates
- **README.md**: update "Supported Statements" section.
- **docs/grammar_coverage.md**: update coverage table and mark new rules.

## 8. Timeline & Milestones
- **Phase 1 (2d):** CLONE, SHARE
- **Phase 2 (3d):** INTEGRATION, EXTERNAL TABLE, MVIEW
- **Phase 3 (2d):** EXT FUNCTION, NETWORK POLICY, REPLICATION
- **Phase 4 (2d):** ACCOUNT/SESSION, STAGE UTILS, SHOW VARIANTS
- **Phase 5 (2d):** COPY INTO, ALTER enhancements, testing & docs

---
_End of Snowflake Full Core Coverage Implementation Plan._ 