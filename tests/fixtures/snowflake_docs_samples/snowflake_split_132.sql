-- Example 8825
WITH RECURSIVE current_f (current_val, previous_val) AS
    (
    SELECT 0, 1
    UNION ALL 
    SELECT current_val + previous_val, current_val FROM current_f
      WHERE current_val + previous_val < 100
    )
  SELECT current_val FROM current_f ORDER BY current_val;
+-------------+
| CURRENT_VAL |
|-------------|
|           0 |
|           1 |
|           1 |
|           2 |
|           3 |
|           5 |
|           8 |
|          13 |
|          21 |
|          34 |
|          55 |
|          89 |
+-------------+

-- Example 8826
-- The components of a car.
CREATE TABLE components (
    description VARCHAR,
    component_ID INTEGER,
    quantity INTEGER,
    parent_component_ID INTEGER
    );

INSERT INTO components (description, quantity, component_ID, parent_component_ID) VALUES
    ('car', 1, 1, 0),
       ('wheel', 4, 11, 1),
          ('tire', 1, 111, 11),
          ('#112 bolt', 5, 112, 11),
          ('brake', 1, 113, 11),
             ('brake pad', 1, 1131, 113),
       ('engine', 1, 12, 1),
          ('piston', 4, 121, 12),
          ('cylinder block', 1, 122, 12),
          ('#112 bolt', 16, 112, 12)   -- Can use same type of bolt in multiple places
    ;

-- Example 8827
WITH RECURSIVE current_layer (indent, layer_ID, parent_component_ID, component_id, description, sort_key) AS (
  SELECT 
      '...', 
      1, 
      parent_component_ID, 
      component_id, 
      description, 
      '0001'
    FROM components WHERE component_id = 1
  UNION ALL
  SELECT indent || '...',
      layer_ID + 1,
      components.parent_component_ID,
      components.component_id, 
      components.description,
      sort_key || SUBSTRING('000' || components.component_ID, -4)
    FROM current_layer JOIN components 
      ON (components.parent_component_id = current_layer.component_id)
  )
SELECT
  -- The indentation gives us a sort of "side-ways tree" view, with
  -- sub-components indented under their respective components.
  indent || description AS description, 
  component_id,
  parent_component_ID
  -- The layer_ID and sort_key are useful for debugging, but not
  -- needed in the report.
--  , layer_ID, sort_key
  FROM current_layer
  ORDER BY sort_key;
+-------------------------+--------------+---------------------+
| DESCRIPTION             | COMPONENT_ID | PARENT_COMPONENT_ID |
|-------------------------+--------------+---------------------|
| ...car                  |            1 |                   0 |
| ......wheel             |           11 |                   1 |
| .........tire           |          111 |                  11 |
| .........#112 bolt      |          112 |                  11 |
| .........brake          |          113 |                  11 |
| ............brake pad   |         1131 |                 113 |
| ......engine            |           12 |                   1 |
| .........#112 bolt      |          112 |                  12 |
| .........piston         |          121 |                  12 |
| .........cylinder block |          122 |                  12 |
+-------------------------+--------------+---------------------+

-- Example 8828
Show Change Log

-- Example 8829
CREATE STAGE my_s3compat_stage
  URL = 's3compat://my_bucket/files/'
  ENDPOINT = 'mystorage.com'
  CREDENTIALS = (AWS_KEY_ID = '1a2b3c...' AWS_SECRET_KEY = '4x5y6z...')

-- Example 8830
COPY INTO t1
  FROM @my_s3compat_stage/load/;

-- Example 8831
COPY INTO @my_s3compat_stage/unload/
  FROM t2;

-- Example 8832
CREATE EXTERNAL TABLE et
 LOCATION=@my_s3compat_stage/path1/
 AUTO_REFRESH = FALSE
 REFRESH_ON_CREATE = TRUE
 FILE_FORMAT = (TYPE = PARQUET);

-- Example 8833
SELECT value FROM et;

-- Example 8834
CREATE [ OR REPLACE ] [ TRANSIENT ] DATABASE [ IF NOT EXISTS ] <name>
    [ CLONE <source_schema>
        [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
        [ IGNORE TABLES WITH INSUFFICIENT DATA RETENTION ]
        [ IGNORE HYBRID TABLES ] ]
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
    [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
    [ EXTERNAL_VOLUME = <external_volume_name> ]
    [ CATALOG = <catalog_integration_name> ]
    [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
    [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
    [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
    [ COMMENT = '<string_literal>' ]
    [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>' ]
    [ CATALOG_SYNC_NAMESPACE_MODE = { NEST | FLATTEN } ]
    [ CATALOG_SYNC_NAMESPACE_FLATTEN_DELIMITER = '<string_literal>' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 8835
CREATE DATABASE <name> FROM LISTING '<listing_global_name>'

-- Example 8836
CREATE DATABASE <name> FROM SHARE <provider_account>.<share_name>

-- Example 8837
CREATE DATABASE <name>
    AS REPLICA OF <account_identifier>.<primary_db_name>
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]

-- Example 8838
CREATE OR ALTER [ TRANSIENT ] DATABASE <name>
    [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
    [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
    [ EXTERNAL_VOLUME = <external_volume_name> ]
    [ CATALOG = <catalog_integration_name> ]
    [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
    [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
    [ LOG_LEVEL = '<log_level>' ]
    [ TRACE_LEVEL = '<trace_level>' ]
    [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
    [ COMMENT = '<string_literal>' ]

-- Example 8839
CREATE [ OR REPLACE ] DATABASE [ IF NOT EXISTS ] <name> CLONE <source_database>
  [ ... ]

-- Example 8840
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 8841
-- determine the active warehouse in the current session (if any)
SELECT CURRENT_WAREHOUSE();

+---------------------+
| CURRENT_WAREHOUSE() |
|---------------------|
| MY_WH               |
+---------------------+

-- change the STATEMENT_TIMEOUT_IN_SECONDS value for the active warehouse

ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 8842
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Example 8843
CREATE DATABASE mytestdb;

CREATE DATABASE mytestdb2 DATA_RETENTION_TIME_IN_DAYS = 10;

SHOW DATABASES LIKE 'my%';

+---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------+
| created_on                      | name       | is_default | is_current | origin | owner    | comment | options | retention_time |
|---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------|
| Tue, 17 Mar 2016 16:57:04 -0700 | MYTESTDB   | N          | N          |        | PUBLIC   |         |         | 1              |
| Tue, 17 Mar 2016 17:06:32 -0700 | MYTESTDB2  | N          | N          |        | PUBLIC   |         |         | 10             |
+---------------------------------+------------+------------+------------+--------+----------+---------+---------+----------------+

-- Example 8844
CREATE TRANSIENT DATABASE mytransientdb;

SHOW DATABASES LIKE 'my%';

+---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------+
| created_on                      | name          | is_default | is_current | origin | owner    | comment | options   | retention_time |
|---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------|
| Tue, 17 Mar 2016 16:57:04 -0700 | MYTESTDB      | N          | N          |        | PUBLIC   |         |           | 1              |
| Tue, 17 Mar 2016 17:06:32 -0700 | MYTESTDB2     | N          | N          |        | PUBLIC   |         |           | 10             |
| Tue, 17 Mar 2015 17:07:51 -0700 | MYTRANSIENTDB | N          | N          |        | PUBLIC   |         | TRANSIENT | 1              |
+---------------------------------+---------------+------------+------------+--------+----------+---------+-----------+----------------+

-- Example 8845
CREATE DATABASE snow_sales FROM SHARE ab67890.sales_s;

-- Example 8846
CREATE OR ALTER DATABASE db1;

-- Example 8847
CREATE OR ALTER DATABASE db1
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8848
CREATE OR ALTER DATABASE db1
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8849
ALTER DATABASE [ IF EXISTS ] <name> RENAME TO <new_db_name>

ALTER DATABASE [ IF EXISTS ] <name> SWAP WITH <target_db_name>

ALTER DATABASE [ IF EXISTS ] <name> SET [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
                                        [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
                                        [ EXTERNAL_VOLUME = <external_volume_name> ]
                                        [ CATALOG = <catalog_integration_name> ]
                                        [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
                                        [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
                                        [ DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU = '<compute_pool_name>' ]
                                        [ DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU = '<compute_pool_name>' ]
                                        [ LOG_LEVEL = '<log_level>' ]
                                        [ TRACE_LEVEL = '<trace_level>' ]
                                        [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
                                        [ EVENT_TABLE = <event_table_name> ]
                                        [ COMMENT = '<string_literal>' ]
                                        [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>' ]
                                        [ REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' } ]
                                        [ BASE_LOCATION_PREFIX = '<string>' ]
                                        [ DEFAULT_STREAMLIT_NOTEBOOK_WAREHOUSE = <warehouse_name> ]

ALTER DATABASE <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER DATABASE <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER DATABASE [ IF EXISTS ] <name> UNSET { DATA_RETENTION_TIME_IN_DAYS         |
                                            MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                            EXTERNAL_VOLUME                     |
                                            CATALOG                             |
                                            DEFAULT_DDL_COLLATION               |
                                            DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU   |
                                            DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU   |
                                            STORAGE_SERIALIZATION_POLICY        |
                                            EVENT_TABLE = <event_table_name>    |
                                            COMMENT                             |
                                            CATALOG_SYNC                        |
                                            REPLICABLE_WITH_FAILOVER_GROUPS     |
                                            BASE_LOCATION_PREFIX                |
                                            DEFAULT_STREAMLIT_NOTEBOOK_WAREHOUSE
                                          }
                                          [ , ... ]

-- Example 8850
ALTER DATABASE <name> ENABLE REPLICATION TO ACCOUNTS <account_identifier> [ , <account_identifier> ... ] [ IGNORE EDITION CHECK ]

ALTER DATABASE <name> DISABLE REPLICATION [ TO ACCOUNTS <account_identifier> [ , <account_identifier> ... ] ]

ALTER DATABASE <name> REFRESH

-- Example 8851
ALTER DATABASE <name> ENABLE FAILOVER TO ACCOUNTS <account_identifier> [ , <account_identifier> ... ]

ALTER DATABASE <name> DISABLE FAILOVER [ TO ACCOUNTS <account_identifier> [ , <account_identifier> ... ] ]

ALTER DATABASE <name> PRIMARY

-- Example 8852
ALTER DATABASE IF EXISTS db1 RENAME TO db2;

-- Example 8853
CREATE [ OR REPLACE ] [ TRANSIENT ] SCHEMA [ IF NOT EXISTS ] <name>
  [ CLONE <source_schema>
      [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
      [ IGNORE TABLES WITH INSUFFICIENT DATA RETENTION ]
      [ IGNORE HYBRID TABLES ] ]
  [ WITH MANAGED ACCESS ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ EXTERNAL_VOLUME = <external_volume_name> ]
  [ CATALOG = <catalog_integration_name> ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
  [ CLASSIFICATION_PROFILE = '<classification_profile>' ]
  [ COMMENT = '<string_literal>' ]
  [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 8854
CREATE OR ALTER [ TRANSIENT ] SCHEMA <name>
  [ WITH MANAGED ACCESS ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ EXTERNAL_VOLUME = <external_volume_name> ]
  [ CATALOG = <catalog_integration_name> ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ LOG_LEVEL = '<log_level>' ]
  [ TRACE_LEVEL = '<trace_level>' ]
  [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
  [ COMMENT = '<string_literal>' ]

-- Example 8855
CREATE [ OR REPLACE ] SCHEMA [ IF NOT EXISTS ] <name> CLONE <source_schema>
  [ ... ]

-- Example 8856
CREATE SCHEMA myschema;

SHOW SCHEMAS;

+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------+
| created_on                    | name               | is_default | is_current | database_name | owner        | comment                                                   | options | retention_time |
|-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------|
| 2018-12-10 09:34:02.127 -0800 | INFORMATION_SCHEMA | N          | N          | MYDB          |              | Views describing the contents of schemas in this database |         | 1              |
| 2018-12-10 09:33:56.793 -0800 | MYSCHEMA           | N          | Y          | MYDB          | PUBLIC       |                                                           |         | 1              |
| 2018-11-26 06:08:24.263 -0800 | PUBLIC             | N          | N          | MYDB          | PUBLIC       |                                                           |         | 1              |
+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------+

-- Example 8857
CREATE TRANSIENT SCHEMA tschema;

SHOW SCHEMAS;

+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+-----------+----------------+
| created_on                    | name               | is_default | is_current | database_name | owner        | comment                                                   | options   | retention_time |
|-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+-----------+----------------|
| 2018-12-10 09:34:02.127 -0800 | INFORMATION_SCHEMA | N          | N          | MYDB          |              | Views describing the contents of schemas in this database |           | 1              |
| 2018-12-10 09:33:56.793 -0800 | MYSCHEMA           | N          | Y          | MYDB          | PUBLIC       |                                                           |           | 1              |
| 2018-11-26 06:08:24.263 -0800 | PUBLIC             | N          | N          | MYDB          | PUBLIC       |                                                           |           | 1              |
| 2018-12-10 09:35:32.326 -0800 | TSCHEMA            | N          | Y          | MYDB          | PUBLIC       |                                                           | TRANSIENT | 1              |
+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+-----------+----------------+

-- Example 8858
CREATE SCHEMA mschema WITH MANAGED ACCESS;

SHOW SCHEMAS;

+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+----------------+----------------+
| created_on                    | name               | is_default | is_current | database_name | owner        | comment                                                   | options        | retention_time |
|-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+----------------+----------------|
| 2018-12-10 09:34:02.127 -0800 | INFORMATION_SCHEMA | N          | N          | MYDB          |              | Views describing the contents of schemas in this database |                | 1              |
| 2018-12-10 09:36:47.738 -0800 | MSCHEMA            | N          | Y          | MYDB          | ROLE1        |                                                           | MANAGED ACCESS | 1              |
| 2018-12-10 09:33:56.793 -0800 | MYSCHEMA           | N          | Y          | MYDB          | PUBLIC       |                                                           |                | 1              |
| 2018-11-26 06:08:24.263 -0800 | PUBLIC             | N          | N          | MYDB          | PUBLIC       |                                                           |                | 1              |
| 2018-12-10 09:35:32.326 -0800 | TSCHEMA            | N          | Y          | MYDB          | PUBLIC       |                                                           | TRANSIENT      | 1              |
+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+----------------+----------------+

-- Example 8859
CREATE OR ALTER SCHEMA s1;

-- Example 8860
CREATE OR ALTER SCHEMA s1
  WITH MANAGED ACCESS
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8861
CREATE OR ALTER SCHEMA s1
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8862
ALTER SCHEMA [ IF EXISTS ] <name> RENAME TO <new_schema_name>

ALTER SCHEMA [ IF EXISTS ] <name> SWAP WITH <target_schema_name>

ALTER SCHEMA [ IF EXISTS ] <name> SET {
                                      [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
                                      [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
                                      [ EXTERNAL_VOLUME = <external_volume_name> ]
                                      [ CATALOG = <catalog_integration_name> ]
                                      [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
                                      [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
                                      [ DEFAULT_NOTEBOOK_COMPUTE_POOL_CPU = <'compute_pool_name>' ]
                                      [ DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU = '<compute_pool_name>' ]
                                      [ LOG_LEVEL = '<log_level>' ]
                                      [ TRACE_LEVEL = '<trace_level>' ]
                                      [ STORAGE_SERIALIZATION_POLICY = { COMPATIBLE | OPTIMIZED } ]
                                      [ CLASSIFICATION_PROFILE = '<classification_profile>' ]
                                      [ COMMENT = '<string_literal>' ]
                                      [ CATALOG_SYNC = '<snowflake_open_catalog_integration_name>' ]
                                      [ REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' } ]
                                      [ BASE_LOCATION_PREFIX = '<string>']
                                      [ DEFAULT_STREAMLIT_NOTEBOOK_WAREHOUSE = '<warehouse_name>']
                                      }

ALTER SCHEMA [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER SCHEMA [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER SCHEMA [ IF EXISTS ] <name> UNSET {
                                        DATA_RETENTION_TIME_IN_DAYS         |
                                        MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                        EXTERNAL_VOLUME                     |
                                        CATALOG                             |
                                        REPLACE_INVALID_CHARACTERS          |
                                        DEFAULT_DDL_COLLATION               |
                                        LOG_LEVEL                           |
                                        TRACE_LEVEL                         |
                                        STORAGE_SERIALIZATION_POLICY        |
                                        COMMENT                             |
                                        CATALOG_SYNC                        |
                                        REPLICABLE_WITH_FAILOVER_GROUPS     |
                                        BASE_LOCATION_PREFIX                |
                                        DEFAULT_STREAMLIT_NOTEBOOK_WAREHOUSE
                                        }
                                        [ , ... ]

ALTER SCHEMA [ IF EXISTS ] <name> { ENABLE | DISABLE } MANAGED ACCESS

-- Example 8863
ALTER SCHEMA IF EXISTS schema1 RENAME TO schema2;

-- Example 8864
ALTER SCHEMA schema2 ENABLE MANAGED ACCESS;

-- Example 8865
ALTER TABLE [ IF EXISTS ] <name> RENAME TO <new_table_name>

ALTER TABLE [ IF EXISTS ] <name> SWAP WITH <target_table_name>

ALTER TABLE [ IF EXISTS ] <name> { clusteringAction | tableColumnAction | constraintAction  }

ALTER TABLE [ IF EXISTS ] <name> dataMetricFunctionAction

ALTER TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER TABLE [ IF EXISTS ] <name> extTableColumnAction

ALTER TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER TABLE [ IF EXISTS ] <name> SET
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE  } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ ENABLE_SCHEMA_EVOLUTION = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

ALTER TABLE [ IF EXISTS ] <name> UNSET {
                                       DATA_RETENTION_TIME_IN_DAYS         |
                                       MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                       CHANGE_TRACKING                     |
                                       DEFAULT_DDL_COLLATION               |
                                       ENABLE_SCHEMA_EVOLUTION             |
                                       COMMENT                             |
                                       }
                                       [ , ... ]

-- Example 8866
clusteringAction ::=
  {
     CLUSTER BY ( <expr> [ , <expr> , ... ] )
     /* RECLUSTER is deprecated */
   | RECLUSTER [ MAX_SIZE = <budget_in_bytes> ] [ WHERE <condition> ]
     /* { SUSPEND | RESUME } RECLUSTER is valid action */
   | { SUSPEND | RESUME } RECLUSTER
   | DROP CLUSTERING KEY
  }

-- Example 8867
tableColumnAction ::=
  {
     ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
        [
           {
              DEFAULT <default_value>
              | { AUTOINCREMENT | IDENTITY }
                 /* AUTOINCREMENT (or IDENTITY) is supported only for           */
                 /* columns with numeric data types (NUMBER, INT, FLOAT, etc.). */
                 /* Also, if the table is not empty (i.e. if the table contains */
                 /* any rows), only DEFAULT can be altered.                     */
                 [
                    {
                       ( <start_num> , <step_num> )
                       | START <num> INCREMENT <num>
                    }
                 ]
                 [  { ORDER | NOORDER } ]
           }
        ]
        [ inlineConstraint ]
        [ COLLATE '<collation_specification>' ]

   | RENAME COLUMN <col_name> TO <new_col_name>

   | ALTER | MODIFY [ ( ]
                            [ COLUMN ] <col1_name> DROP DEFAULT
                          , [ COLUMN ] <col1_name> SET DEFAULT <seq_name>.NEXTVAL
                          , [ COLUMN ] <col1_name> { [ SET ] NOT NULL | DROP NOT NULL }
                          , [ COLUMN ] <col1_name> [ [ SET DATA ] TYPE ] <type>
                          , [ COLUMN ] <col1_name> COMMENT '<string>'
                          , [ COLUMN ] <col1_name> UNSET COMMENT
                        [ , [ COLUMN ] <col2_name> ... ]
                        [ , ... ]
                    [ ) ]

   | DROP [ COLUMN ] [ IF EXISTS ] <col1_name> [, <col2_name> ... ]
  }

  inlineConstraint ::=
    [ NOT NULL ]
    [ CONSTRAINT <constraint_name> ]
    { UNIQUE | PRIMARY KEY | { [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ] } }
    [ <constraint_properties> ]

-- Example 8868
dataMetricFunctionAction ::=

    SET DATA_METRIC_SCHEDULE = {
        '<num> MINUTE'
      | 'USING CRON <expr> <time_zone>'
      | 'TRIGGER_ON_CHANGES'
    }

  | UNSET DATA_METRIC_SCHEDULE

  | { ADD | DROP } DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] )
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) ]

  | MODIFY DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME }
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME } ]

-- Example 8869
dataGovnPolicyTagAction ::=
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
      SET AGGREGATION POLICY <policy_name>
        [ ENTITY KEY ( <col_name> [, ... ] ) ]
        [ FORCE ]
    | UNSET AGGREGATION POLICY
  }
  |
  {
      SET JOIN POLICY <policy_name>
        [ FORCE ]
    | UNSET JOIN POLICY
  }
  |
  ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
    [ [ WITH ] MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] ]
    [ [ WITH ] PROJECTION POLICY <policy_name> ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>'
          [ , <tag_name> = '<tag_value>' , ... ] ) ]
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET PROJECTION POLICY <policy_name>
          [ FORCE ]
      | UNSET PROJECTION POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                   , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 8870
extTableColumnAction ::=
  {
     ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type> AS ( <expr> )

   | RENAME COLUMN <col_name> TO <new_col_name>

   | DROP [ COLUMN ] [ IF EXISTS ] <col1_name> [, <col2_name> ... ]
  }

-- Example 8871
constraintAction ::=
  {
     ADD outoflineConstraint
   | RENAME CONSTRAINT <constraint_name> TO <new_constraint_name>
   | { ALTER | MODIFY } { CONSTRAINT <constraint_name> | PRIMARY KEY | UNIQUE | FOREIGN KEY } ( <col_name> [ , ... ] )
                         [ [ NOT ] ENFORCED ] [ VALIDATE | NOVALIDATE ] [ RELY | NORELY ]
   | DROP { CONSTRAINT <constraint_name> | PRIMARY KEY | UNIQUE | FOREIGN KEY } ( <col_name> [ , ... ] )
                         [ CASCADE | RESTRICT ]
  }

  outoflineConstraint ::=
    [ CONSTRAINT <constraint_name> ]
    {
       UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
     | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
     | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
                          REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
    }
    [ <constraint_properties> ]

-- Example 8872
searchOptimizationAction ::=
  {
     ADD SEARCH OPTIMIZATION [
       ON <search_method_with_target> [ , <search_method_with_target> ... ]
     ]

   | DROP SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]
  }

-- Example 8873
ALTER TABLE t1 ADD COLUMN c5 VARCHAR DEFAULT 12345::VARCHAR;

-- Example 8874
002263 (22000): SQL compilation error:
Invalid column default expression [CAST(12345 AS VARCHAR(16777216))]

-- Example 8875
ALTER TABLE t1 ADD COLUMN c6 DATE DEFAULT '20230101';

-- Example 8876
002023 (22000): SQL compilation error:
Expression type does not match column data type, expecting DATE but got VARCHAR(8) for column C6

-- Example 8877
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 8878
mycol varchar as (value:c1::varchar)

-- Example 8879
{ "a":"1", "b": { "c":"2", "d":"3" } }

-- Example 8880
mycol varchar as (value:"b"."c"::varchar)

-- Example 8881
<search_method>( <target> [ , <target> , ... ] [ , ANALYZER => '<analyzer_name>' ] )

-- Example 8882
-- Allowed
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 8883
-- Not allowed
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 8884
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 8885
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 8886
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 8887
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 8888
CREATE OR REPLACE TABLE t1(a1 number);

-- Example 8889
SHOW TABLES LIKE 't1';

-- Example 8890
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | change_tracking | is_external | enable_schema_evolution | owner_role_type | is_event | budget |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------|
| 2023-10-19 10:37:04.858 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         |            |    0 |     0 | PUBLIC | 1              | OFF             | N           | N                       | ROLE            | N        | NULL   |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+

-- Example 8891
ALTER TABLE t1 RENAME TO tt1;

