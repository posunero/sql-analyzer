# Implementation Plan: Snowflake Feature Gaps

This document outlines grammar extensions and parser work needed to cover
Snowflake SQL constructs that are still unsupported.  Each section lists
EBNF fragments for the sample syntax and implementation notes for
updating the Lark grammar, AST, and tests.

## 1. Semi-structured data operations

### 1.1 VARIANT path notation
```
path_expr   = column_ref ":" path_root { path_suffix } ;
path_root   = IDENTIFIER ;
path_suffix = "." IDENTIFIER | "[" INT "]" ;
```
* Extend expression rules to recognise `path_expr` after any column
  reference.
* Emit a dedicated AST node for path access.
* Add tests for chained object and array traversal.

### 1.2 OBJECT and ARRAY helpers
```
array_construct  = "ARRAY_CONSTRUCT" "(" [expr {"," expr}] ")" ;
object_construct = "OBJECT_CONSTRUCT" "(" expr "," expr {"," expr "," expr} ")" ;
flatten_tf       = "LATERAL" "FLATTEN" "(" "INPUT" "=>" expr ["," named_arg]* ")" ;
named_arg        = IDENTIFIER "=>" expr ;
```
* Allow `array_construct` and `object_construct` wherever function calls
  appear.
* Special-case `flatten_tf` as a table function in `from_clause`.

## 2. Time travel and cloning features

### 2.1 AT and BEFORE clause
```
time_travel    = ("AT" | "BEFORE") "(" time_travel_spec ")" ;
time_travel_spec = "TIMESTAMP" "=>" expr
                  | "OFFSET" "=>" expr
                  | "STATEMENT" "=>" STRING ;
table_ref      = identifier [time_travel] ;
```
* Add `time_travel` after any table reference and join source.
* Validate that only one spec is supplied.
* Tests for timestamp, offset, and statement variants.

### 2.2 CLONE operations
```
clone_stmt = "CREATE" object_type object_name
             "CLONE" source_name [time_travel] ;
```
* Extend DDL rules for `CREATE TABLE|SCHEMA|DATABASE` with the `CLONE`
  branch.
* Ensure time-travel grammar is reused.

## 3. Advanced DDL statements

### 3.1 External tables
```
create_external_table = "CREATE" "EXTERNAL" "TABLE" table_name
                        "(" ext_column_def {"," ext_column_def} ")"
                        "LOCATION" "=" STRING
                        "FILE_FORMAT" "=" "(" file_format_opts ")"
                        ["AUTO_REFRESH" "=" BOOLEAN] ;
ext_column_def       = column_name data_type "AS" "(" expr ")" ;
```
* Extend `create_table` with the EXTERNAL variant and computed columns.
* Reuse existing `file_format` rules where possible.

### 3.2 Streams and tasks
```
create_stream = "CREATE" "STREAM" stream_name "ON" "TABLE" table_name
                ["APPEND_ONLY" "=" BOOLEAN]
                ["SHOW_INITIAL_ROWS" "=" BOOLEAN] ;

create_task = "CREATE" "TASK" task_name
              "WAREHOUSE" "=" IDENTIFIER
              "SCHEDULE"  "=" STRING
              "AS" statement ;
```
* Add new statements under the DDL module.
* Provide minimal AST nodes capturing options.

### 3.3 Stages and file formats
```
create_stage = "CREATE" "STAGE" stage_name
               "URL" "=" STRING
               "CREDENTIALS" "=" "(" credential_kv {credential_kv} ")"
               "FILE_FORMAT" "=" "(" file_format_opts ")" ;
credential_kv = "AWS_KEY_ID" "=" STRING
              | "AWS_SECRET_KEY" "=" STRING ;

create_file_format = "CREATE" "FILE" "FORMAT" format_name
                     "TYPE" "=" STRING {file_format_kv} ;
file_format_kv     = IDENTIFIER "=" value ;
```
* Extend `create_stage` and `create_file_format` rules with option lists.

## 4. Data loading and unloading
```
copy_into = "COPY" "INTO" target
            "FROM" source
            ["FILE_FORMAT" "=" "(" file_format_opts ")"]
            ["PATTERN" "=" STRING]
            ["ON_ERROR" "=" STRING]
            ["VALIDATION_MODE" "=" STRING]
            ["PARTITION" "BY" "(" expr ")"] ;

stage_ref = "@" stage_name ["/" path] ;
```
* Add `copy_into` to command set and update stage references in
  expressions and FROM items.
* Tests for load and unload variants and direct stage queries.

## 5. Security and governance
```
create_row_access = "CREATE" "ROW" "ACCESS" "POLICY" policy_name
                    "AS" "(" column_list ")" "RETURNS" "BOOLEAN" "->" expr ;
masking_policy    = "CREATE" "MASKING" "POLICY" policy_name
                    "AS" "(" IDENTIFIER data_type ")" "RETURNS" data_type
                    "->" expr ;
create_share      = "CREATE" "SHARE" share_name ["COMMENT" "=" STRING] ;
```
* Extend DDL grammar with policy and share definitions.
* Implement `ALTER TABLE` hooks to attach policies.

## 6. User-defined functions and procedures
```
create_function = "CREATE" "FUNCTION" func_name
                  "(" param_list ")"
                  "RETURNS" data_type
                  "LANGUAGE" IDENTIFIER
                  [runtime_option]*
                  "AS" dollar_string ;

dollar_string = "$$" { character } "$$" ;
```
* Reuse existing function/procedure rules but ensure multi-language
  options and package lists are parsed.

## 7. Unique syntax patterns
```
qualify_clause = "QUALIFY" expr ;

sample_clause  = "SAMPLE" "(" number ["PERCENT"|"ROWS"] ")"
                 [ ("SEED"|"REPEATABLE") "(" INT ")" ] ;
```
* Allow `qualify_clause` after HAVING in `select_stmt`.
* Accept numeric and row-based sampling with optional seed.

## 8. Cloud infrastructure management
```
create_warehouse = "CREATE" "WAREHOUSE" warehouse_name "WITH"
                   warehouse_opt {warehouse_opt} ;
warehouse_opt   = "WAREHOUSE_SIZE" "=" STRING
                | "AUTO_SUSPEND" "=" INT
                | "AUTO_RESUME" "=" BOOLEAN
                | "MIN_CLUSTER_COUNT" "=" INT
                | "MAX_CLUSTER_COUNT" "=" INT
                | "SCALING_POLICY" "=" STRING ;

create_resource_monitor = "CREATE" "RESOURCE" "MONITOR" monitor_name "WITH"
                          resource_opt {resource_opt}
                          "TRIGGERS" trigger+ ;
resource_opt  = "CREDIT_QUOTA" "=" INT
              | "FREQUENCY" "=" STRING
              | "START_TIMESTAMP" "=" STRING ;
trigger       = "ON" INT "PERCENT" "DO" IDENTIFIER ;
```
* Introduce statements for warehouses and resource monitors with option
  lists.

## 9. Performance optimization features
```
cluster_by = "CLUSTER" "BY" "(" expr_list ")" ;

search_optimization = "ALTER" "TABLE" table_name
                       "ADD" "SEARCH" "OPTIMIZATION" "ON" search_spec ;
search_spec = "EQUALITY" "(" column_name ")"
            | "SUBSTRING" "(" column_name ")" ;

create_materialized_view = "CREATE" "MATERIALIZED" "VIEW" view_name
                            "AS" select_stmt ;
```
* Add `cluster_by` at table creation and alteration.
* Support search optimization and materialized view creation.

## 10. System and metadata functions
* Treat `CURRENT_ACCOUNT`, `CURRENT_ROLE`, `GET_DDL`,
  `SYSTEM$CLUSTERING_INFORMATION`, etc., as reserved function names.

## Implementation priorities

- **High**: VARIANT path expressions, time travel clauses, COPY INTO,
  JSON path functions, dollar-quoted strings.
- **Medium**: external tables, streams and tasks, multi-language UDFs,
  CLONE operations, stage & file format objects.
- **Low**: row access and masking policies, data sharing, warehouse &
  monitor management, search optimization, geospatial types.

## Testing strategy

1. For each grammar addition, add unit tests under
   `tests/grammar/test_snowflake_constructs.py`.
2. Provide positive and negative cases mirroring the examples in this
   document.
3. Ensure the full test suite (`pytest`) remains green.

