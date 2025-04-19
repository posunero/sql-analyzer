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
2. Integrate:
   - In `sql_analyzer/grammar/snowflake.lark`:
     * Line 386: modify `create_table_stmt` to include `| clone_clause` after the `| AS select_stmt` alternative.
     * Line 446: modify `create_database_stmt` to include `| clone_clause` as an alternative.
     * Line 448: modify `create_schema_stmt` to include `| clone_clause` as an alternative.
   - No changes to `create_stmt` union are needed, since `clone_clause` is scoped inside individual create_* rules.

**Test file:** `tests/grammar/clone.sql`

### 5.2 SHARE Commands
1. Add rules:
    ```lark
    create_share_stmt: CREATE (OR REPLACE)? SHARE (IF NOT EXISTS)? qualified_name
    alter_share_stmt: ALTER SHARE qualified_name (ADD DATA? | DROP DATA?)?
    ```
2. Integrate:
   - In `sql_analyzer/grammar/snowflake.lark`:
     * Lines 362–370 (the `create_stmt` union): insert `| create_share_stmt` after `create_authentication_policy_stmt`.
     * Lines 504–513 (the `alter_stmt` union): insert `| alter_share_stmt` after `alter_authentication_policy_stmt`.
     * Line 553 (the `drop_stmt` rule): extend to
       ```lark
       drop_stmt: DROP object_type (IF EXISTS)? qualified_name
                | drop_share_stmt
       ```
     * Line 557 (the `object_type` rule): add `| SHARE` after `SEQUENCE`.

**Test:** `tests/grammar/share.sql`

### 5.3 INTEGRATION Objects
**Minimal BNF sketch:**
```lark
create_integration_stmt: CREATE (OR REPLACE)? INTEGRATION (IF NOT EXISTS)? qualified_name integration_param*
integration_param: TYPE EQ (IDENTIFIER | SINGLE_QUOTED_STRING)
                 | ENABLED EQ boolean
                 | COMMENT EQ SINGLE_QUOTED_STRING
                 | SECRETS EQ LPAREN SINGLE_QUOTED_STRING (COMMA SINGLE_QUOTED_STRING)* RPAREN
```
1. Define `create_integration_stmt`, `alter_integration_stmt`, `drop_integration_stmt`.
2. Integrate:
   - Lines 362–370: add `| create_integration_stmt` to the `create_stmt` union.
   - Lines 504–513: add `| alter_integration_stmt` to the `alter_stmt` union.
   - Line 553: extend `drop_stmt` to include `| drop_integration_stmt`.
   - Line 557: in `object_type`, add `| INTEGRATION` after `SHARE`.

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

## 9. Analyzer & Engine Integration
To wire up new grammar rules into our semantic analysis pass, update the `SQLVisitor` and confirm the `AnalysisEngine` supports the new action types.

**Note:** Apply all visitor updates in a single patch *after* completing all grammar changes. This allows one end‑to‑end run of parser + visitor tests, ensuring the whole pipeline is correct.

### 9.1 SQLVisitor Updates
0. Bundle and apply all changes below in one commit once all grammar edits are in place.
1. In `sql_analyzer/parser/visitor.py`, locate the `stmt_type_mapping` inside the `statement(self, tree)` method and add entries for each new statement:
```python
stmt_type_mapping.update({
    'CREATE_SHARE_STMT':           'CREATE_SHARE',
    'ALTER_SHARE_STMT':            'ALTER_SHARE',
    'DROP_SHARE_STMT':             'DROP_SHARE',
    'CREATE_INTEGRATION_STMT':     'CREATE_INTEGRATION',
    'ALTER_INTEGRATION_STMT':      'ALTER_INTEGRATION',
    'DROP_INTEGRATION_STMT':       'DROP_INTEGRATION',
    'CREATE_EXTERNAL_TABLE_STMT':  'CREATE_EXTERNAL_TABLE',
    'ALTER_EXTERNAL_TABLE_STMT':   'ALTER_EXTERNAL_TABLE',
    'DROP_EXTERNAL_TABLE_STMT':    'DROP_EXTERNAL_TABLE',
    'CREATE_MATERIALIZED_VIEW_STMT':'CREATE_MATERIALIZED_VIEW',
    'ALTER_MATERIALIZED_VIEW_STMT': 'ALTER_MATERIALIZED_VIEW',
    'DROP_MATERIALIZED_VIEW_STMT':  'DROP_MATERIALIZED_VIEW',
    'CREATE_EXTERNAL_FUNCTION_STMT':'CREATE_EXTERNAL_FUNCTION',
    'ALTER_EXTERNAL_FUNCTION_STMT': 'ALTER_EXTERNAL_FUNCTION',
    'DROP_EXTERNAL_FUNCTION_STMT':  'DROP_EXTERNAL_FUNCTION',
    'CREATE_NETWORK_POLICY_STMT':   'CREATE_NETWORK_POLICY',
    'ALTER_NETWORK_POLICY_STMT':    'ALTER_NETWORK_POLICY',
    'DROP_NETWORK_POLICY_STMT':     'DROP_NETWORK_POLICY',
    'CREATE_REPLICATION_STMT':      'CREATE_REPLICATION',
    'ALTER_REPLICATION_STMT':       'ALTER_REPLICATION',
    'SHOW_REPLICATION_STMT':        'SHOW_REPLICATION',
    'FAILOVER_STMT':                'FAILOVER',
    'CREATE_ACCOUNT_STMT':          'CREATE_ACCOUNT',
    'ALTER_ACCOUNT_STMT':           'ALTER_ACCOUNT',
    'DROP_ACCOUNT_STMT':            'DROP_ACCOUNT',
    'SHOW_ACCOUNTS_STMT':           'SHOW_ACCOUNTS',
    'FAILOVER_RECOVERY_STMT':       'FAILOVER_RECOVERY',
    'ALTER_SESSION_STMT':           'ALTER_SESSION',
    'SHOW_PARAMETERS_STMT':         'SHOW_PARAMETERS',
    'LIST_STMT':                    'LIST_STAGE',
    'GET_STMT':                     'GET_STAGE',
    'REMOVE_STMT':                  'REMOVE_STAGE',
    'ALTER_STAGE_STMT':             'ALTER_STAGE',
})
```
2. Extend the `SIMPLE_QN_METHODS` list at the bottom of the same file to include simple, single‐qualified‐name statements:
```python
SIMPLE_QN_METHODS += [
    ('create_share_stmt', 'SHARE', 'CREATE_SHARE', 'Create Share'),
    ('alter_share_stmt',  'SHARE', 'ALTER_SHARE',  'Alter Share'),
    ('drop_share_stmt',   'SHARE', 'DROP_SHARE',   'Drop Share'),
    ('create_integration_stmt', 'INTEGRATION', 'CREATE_INTEGRATION', 'Create Integration'),
    ('alter_integration_stmt',  'INTEGRATION', 'ALTER_INTEGRATION',  'Alter Integration'),
    ('drop_integration_stmt',   'INTEGRATION', 'DROP_INTEGRATION',   'Drop Integration'),
    ('create_external_table_stmt', 'EXTERNAL TABLE', 'CREATE_EXTERNAL_TABLE', 'Create External Table'),
    ('alter_external_table_stmt',  'EXTERNAL TABLE', 'ALTER_EXTERNAL_TABLE',  'Alter External Table'),
    ('drop_external_table_stmt',   'EXTERNAL TABLE', 'DROP_EXTERNAL_TABLE',   'Drop External Table'),
    ('create_materialized_view_stmt', 'MATERIALIZED VIEW', 'CREATE_MATERIALIZED_VIEW', 'Create Materialized View'),
    ('alter_materialized_view_stmt',  'MATERIALIZED VIEW', 'ALTER_MATERIALIZED_VIEW',  'Alter Materialized View'),
    ('drop_materialized_view_stmt',   'MATERIALIZED VIEW', 'DROP_MATERIALIZED_VIEW',   'Drop Materialized View'),
    ('create_external_function_stmt', 'EXTERNAL FUNCTION', 'CREATE_EXTERNAL_FUNCTION', 'Create External Function'),
    ('alter_external_function_stmt',  'EXTERNAL FUNCTION', 'ALTER_EXTERNAL_FUNCTION',  'Alter External Function'),
    ('drop_external_function_stmt',   'EXTERNAL FUNCTION', 'DROP_EXTERNAL_FUNCTION',   'Drop External Function'),
    ('create_network_policy_stmt', 'NETWORK POLICY', 'CREATE_NETWORK_POLICY', 'Create Network Policy'),
    ('alter_network_policy_stmt',  'NETWORK POLICY', 'ALTER_NETWORK_POLICY',  'Alter Network Policy'),
    ('drop_network_policy_stmt',   'NETWORK POLICY', 'DROP_NETWORK_POLICY',   'Drop Network Policy'),
    ('create_replication_stmt', 'REPLICATION', 'CREATE_REPLICATION', 'Create Replication'),
    ('alter_replication_stmt',  'REPLICATION', 'ALTER_REPLICATION',  'Alter Replication'),
    ('show_replication_stmt',   'REPLICATION', 'SHOW_REPLICATION',   'Show Replication'),
    ('failover_stmt', 'REPLICATION', 'FAILOVER', 'Failover'),
    ('create_account_stmt', 'ACCOUNT', 'CREATE_ACCOUNT', 'Create Account'),
    ('alter_account_stmt',  'ACCOUNT', 'ALTER_ACCOUNT',  'Alter Account'),
    ('drop_account_stmt',   'ACCOUNT', 'DROP_ACCOUNT',   'Drop Account'),
    ('show_accounts_stmt', 'ACCOUNT', 'SHOW_ACCOUNTS', 'Show Accounts'),
    ('failover_recovery_stmt', 'ACCOUNT', 'FAILOVER_RECOVERY', 'Failover Recovery'),
    ('alter_session_stmt', 'SESSION', 'ALTER_SESSION', 'Alter Session'),
    ('show_parameters_stmt', 'SESSION', 'SHOW_PARAMETERS', 'Show Parameters'),
    ('list_stmt', 'STAGE', 'LIST_STAGE', 'List Stage'),
    ('get_stmt', 'STAGE', 'GET_STAGE', 'Get Stage'),
    ('remove_stmt', 'STAGE', 'REMOVE_STAGE', 'Remove Stage'),
    ('alter_stage_stmt', 'STAGE', 'ALTER_STAGE', 'Alter Stage'),
]
```
3. In the `create_table_stmt(self, tree)` visitor method, after recording the CREATE action, detect any `clone_clause` children and emit a CLONE reference:
```python
# inside create_table_stmt(self, tree), after existing logic
for clone in tree.find_data('clone_clause'):
    qn_node = clone.children[0]
    source   = self._extract_qualified_name(qn_node)
    tok      = next((t for t in clone.children if isinstance(t, Token)), None)
    if source and tok:
        self._record_object_reference(source, 'TABLE', 'CLONE', tok)
```

### 9.2 AnalysisEngine Updates
No code changes are strictly required in `AnalysisEngine`, since it already accepts arbitrary action labels via `record_statement` and `record_object`. However, review `sql_analyzer/analysis/models.py` to ensure new action types (e.g. `'CREATE_SHARE'`, `'CLONE'`) are accounted for in any enums or downstream filters.

---
_End of Snowflake Full Core Coverage Implementation Plan._ 