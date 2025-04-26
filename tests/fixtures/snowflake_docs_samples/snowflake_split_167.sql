-- Example 11169
ALTER MATERIALIZED VIEW my_mv SUSPEND RECLUSTER;

-- Example 11170
ALTER MATERIALIZED VIEW my_mv RESUME RECLUSTER;

-- Example 11171
ALTER MATERIALIZED VIEW my_mv SUSPEND;

-- Example 11172
ALTER MATERIALIZED VIEW my_mv RESUME;

-- Example 11173
ALTER MATERIALIZED VIEW my_mv DROP CLUSTERING KEY;

-- Example 11174
ALTER MATERIALIZED VIEW mv1 SET SECURE;

-- Example 11175
ALTER MATERIALIZED VIEW mv1 SET COMMENT = 'Sample view';

-- Example 11176
CREATE [ OR REPLACE ] [ SECURE ] MATERIALIZED VIEW [ IF NOT EXISTS ] <name>
  [ COPY GRANTS ]
  ( <column_list> )
  [ <col1> [ WITH ] MASKING POLICY <policy_name> [ USING ( <col1> , <cond_col1> , ... ) ]
           [ WITH ] PROJECTION POLICY <policy_name>
           [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ , <col2> [ ... ] ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> [ ENTITY KEY ( <col_name> [ , <col_name> ... ] ) ] ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ CLUSTER BY ( <expr1> [, <expr2> ... ] ) ]
  AS <select_statement>

-- Example 11177
Failure during expansion of view 'MV1':
  SQL compilation error: Materialized View MV1 is invalid.
  Invalidation reason: DDL Statement was executed on the base table 'MY_INVENTORY'.
  Marked Materialized View as invalid.

-- Example 11178
CREATE MATERIALIZED VIEW mymv
    COMMENT='Test view'
    AS
    SELECT col1, col2 FROM mytable;

-- Example 11179
CREATE SECURE VIEW myview
  AS SELECT a FROM mytable;

-- Example 11180
DROP TABLE mytable;

-- Example 11181
SELECT * FROM myview;

-- Example 11182
002037 (42601): SQL compilation error:
Failure during expansion of view 'MYVIEW': SQL compilation error:
Object 'DB.SC.MYTABLE' does not exist or not authorized.

-- Example 11183
002037 (42601): SQL compilation error:
Failure during expansion of view 'MYVIEW': Error in secure object

-- Example 11184
CREATE SECURE FUNCTION myfunction1(x FLOAT, y FLOAT)
  RETURNS FLOAT
  LANGUAGE SQL
AS
  'SELECT x / y';

-- Example 11185
SELECT myfunction1(1, 0);

-- Example 11186
100051 (22012): Division by zero

-- Example 11187
100051 (22012): Error in secure object

-- Example 11188
CREATE SECURE FUNCTION myfunction2()
  RETURNS TABLE (a NUMBER)
  LANGUAGE SQL
AS
  'SELECT * FROM mytable';

-- Example 11189
DROP TABLE mytable;

-- Example 11190
SELECT * FROM TABLE(myfunction2());

-- Example 11191
002003 (42S02): SQL compilation error:
Object 'DB.SC.MYTABLE' does not exist or not authorized

-- Example 11192
002003 (42S02): Error in secure object

-- Example 11193
CREATE MASKING POLICY allowed_role_names_mp as (val NUMBER) RETURNS NUMBER ->
  CASE
    WHEN EXISTS
      (SELECT role FROM allowed_roles WHERE role = CURRENT_ROLE()) THEN val
    ELSE '********'
  END;

-- Example 11194
CREATE TABLE test_masking_policy(x NUMBER) AS
  SELECT * FROM VALUES (1), (2), (3);

CREATE VIEW myview_mp
  AS SELECT * FROM test_masking_policy;

ALTER VIEW myview_mp
  MODIFY COLUMN x SET MASKING POLICY allowed_role_names_mp;

-- Example 11195
DROP TABLE allowed_roles;

-- Example 11196
SELECT * FROM myview_mp;

-- Example 11197
002003 (42S02): SQL compilation error:
Object 'DB.SC.ALLOWED_ROLES' does not exist or not authorized.

-- Example 11198
002003 (42S02): Error in secure object

-- Example 11199
CREATE OR REPLACE ROW ACCESS POLICY myrap AS (role NUMBER) RETURNS BOOLEAN ->
  EXISTS (
    SELECT 1 FROM allowed_roles
      WHERE role::STRING = CURRENT_ROLE());

-- Example 11200
CREATE TABLE test_row_access_policy(x NUMBER) AS
  SELECT * FROM VALUES (1), (2), (3);

CREATE VIEW myview_rap
  AS SELECT * FROM test_row_access_policy;

ALTER VIEW myview_rap
  ADD ROW ACCESS POLICY myrap ON (x);

-- Example 11201
DROP TABLE allowed_roles;

-- Example 11202
SELECT * FROM myview_rap;

-- Example 11203
002003 (42S02): SQL compilation error:
Object 'DB.SC.ALLOWED_ROLES' does not exist or not authorized.

-- Example 11204
002003 (42S02): Error in secure object

-- Example 11205
SHOW [ TERSE ] VIEWS [ LIKE '<pattern>' ]
                     [ IN { ACCOUNT | DATABASE [ <db_name> ] | [ SCHEMA ] [ <schema_name> ] | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]
                     [ STARTS WITH '<name_string>' ]
                     [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 11206
SHOW VIEWS LIKE 'line%' IN mydb.public;

+-------------------------------+---------+----------+---------------+-------------+----------+---------+-------------------------------------------------------+-----------+-----------------+-----------------+-----------------+
| created_on                    | name    | reserved | database_name | schema_name | owner    | comment | text                                                  | is_secure | is_materialized | change_tracking | owner_role_type |
+-------------------------------+---------+----------+---------------+-------------+----------+---------+-------------------------------------------------------+-----------+-----------------+-----------------+-----------------+
| 2019-05-24 18:41:14.247 -0700 | liners1 |          | MYDB          | PUBLIC      | SYSADMIN |         | create materialized views liners1 as select * from t; | false     | false           | on              | ROLE            |
+-------------------------------+---------+----------+---------------+-------------+----------+---------+-------------------------------------------------------+-----------+-----------------+-----------------+-----------------+

-- Example 11207
SHOW MATERIALIZED VIEWS [ LIKE '<pattern>' ]
                        [ IN
                             {
                               ACCOUNT                                         |

                               DATABASE                                        |
                               DATABASE <database_name>                        |

                               SCHEMA                                          |
                               SCHEMA <schema_name>                            |
                               <schema_name>

                               APPLICATION <application_name>                  |
                               APPLICATION PACKAGE <application_package_name>  |
                             }
                        ]

-- Example 11208
SHOW MATERIALIZED VIEWS;

-- Example 11209
SHOW MATERIALIZED VIEWS LIKE 'mv1%';

+-------------------------------+------+----------+---------------+-------------+------------+------+-------+----------------------+--------------------+-------------------+-------------------------------+--------------+----------+---------+----------------+-----------+---------+--------------------------------------------+-----------+----------------------+-----------------+----------+
| created_on                    | name | reserved | database_name | schema_name | cluster_by | rows | bytes | source_database_name | source_schema_name | source_table_name | refreshed_on                  | compacted_on | owner    | invalid | invalid_reason | behind_by | comment | text                                       | is_secure | automatic_clustering | owner_role_type | budget   |
|-------------------------------+------+----------+---------------+-------------+------------+------+-------+----------------------+--------------------+-------------------+-------------------------------+--------------+----------+---------+----------------+-----------+---------+--------------------------------------------+-----------|----------------------+-----------------+----------|
| 2018-10-05 17:13:17.579 -0700 | MV1  |          | TEST_DB1      | PUBLIC      |            |    0 |     0 | TEST_DB1             | PUBLIC             | INVENTORY         | 2018-10-05 17:13:50.373 -0700 | NULL         | SYSADMIN | false   | NULL           | 0s        |         | CREATE OR REPLACE MATERIALIZED VIEW mv1 AS | false     | OFF                  | ROLE            | MYBUDGET |
|                               |      |          |               |             |            |      |       |                      |                    |                   |                               |              |          |         |                |           |         |       SELECT ID, price FROM inventory;     |           |                      |                 |          |
+-------------------------------+------+----------+---------------+-------------+------------+------+-------+----------------------+--------------------+-------------------+-------------------------------+--------------+----------+---------+----------------+-----------+---------+--------------------------------------------+-----------+----------------------+-----------------+----------+

-- Example 11210
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

-- Example 11211
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

-- Example 11212
CREATE [ OR REPLACE ] SCHEMA [ IF NOT EXISTS ] <name> CLONE <source_schema>
  [ ... ]

-- Example 11213
CREATE SCHEMA myschema;

SHOW SCHEMAS;

+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------+
| created_on                    | name               | is_default | is_current | database_name | owner        | comment                                                   | options | retention_time |
|-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------|
| 2018-12-10 09:34:02.127 -0800 | INFORMATION_SCHEMA | N          | N          | MYDB          |              | Views describing the contents of schemas in this database |         | 1              |
| 2018-12-10 09:33:56.793 -0800 | MYSCHEMA           | N          | Y          | MYDB          | PUBLIC       |                                                           |         | 1              |
| 2018-11-26 06:08:24.263 -0800 | PUBLIC             | N          | N          | MYDB          | PUBLIC       |                                                           |         | 1              |
+-------------------------------+--------------------+------------+------------+---------------+--------------+-----------------------------------------------------------+---------+----------------+

-- Example 11214
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

-- Example 11215
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

-- Example 11216
CREATE OR ALTER SCHEMA s1;

-- Example 11217
CREATE OR ALTER SCHEMA s1
  WITH MANAGED ACCESS
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 11218
CREATE OR ALTER SCHEMA s1
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 11219
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 11220
CREATE OR REPLACE ICEBERG TABLE iceberg_table_1 (
  col_1 int,
  col_2 string
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'iceberg_table_1';

CREATE OR REPLACE ICEBERG TABLE iceberg_table_2 (
  col_1 int,
  col_2 string
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'iceberg_table_2';

-- Example 11221
STORAGE_BASE_URL
|-- iceberg_table_1.<randomId>
|   |-- data/
|   |-- metadata/
|-- iceberg_table_2.<randomId>
|   |-- data/
|   |-- metadata/

-- Example 11222
SELECT col1, col2 FROM my_iceberg_table;

-- Example 11223
INSERT INTO store_sales VALUES (-99);

UPDATE store_sales
  SET cola = 1
  WHERE cola = -99;

-- Example 11224
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('db1.schema1.it1');

-- Example 11225
+-----------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_ICEBERG_TABLE_INFORMATION('DB1.SCHEMA1.IT1')                                                   |
|-----------------------------------------------------------------------------------------------------------|
| {"metadataLocation":"s3://mybucket/metadata/v1.metadata.json","status":"success"}                         |
+-----------------------------------------------------------------------------------------------------------+

-- Example 11226
ALTER ICEBERG TABLE my_iceberg_table REFRESH;

-- Example 11227
ALTER ICEBERG TABLE my_iceberg_table REFRESH 'metadata/v1.metadata.json';

-- Example 11228
SELECT metrics.* FROM
  snowflake.account_usage.table_storage_metrics metrics
  INNER JOIN snowflake.account_usage.tables tables
  ON (
    metrics.id = tables.table_id
    AND metrics.table_schema_id = tables.table_schema_id
    AND metrics.table_catalog_id = tables.table_catalog_id
  )
  WHERE tables.is_iceberg='YES';

-- Example 11229
ALTER TABLE t1 DROP SEARCH OPTIMIZATION;

-- Example 11230
ALTER TASK [ IF EXISTS ] <name> RESUME | SUSPEND

ALTER TASK [ IF EXISTS ] <name> REMOVE AFTER <string> [ , <string> , ... ] | ADD AFTER <string> [ , <string> , ... ]

ALTER TASK [ IF EXISTS ] <name> SET
  [ { WAREHOUSE = <string> } | { USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> } ]
  [ SCHEDULE = { '<num> { HOURS | MINUTES | SECONDS }'
               | 'USING CRON <expr> <time_zone>' } ]
  [ CONFIG = <configuration_string> ]
  [ ALLOW_OVERLAPPING_EXECUTION = TRUE | FALSE ]
  [ USER_TASK_TIMEOUT_MS = <num> ]
  [ SUSPEND_TASK_AFTER_NUM_FAILURES = <num> ]
  [ ERROR_INTEGRATION = <integration_name> ]
  [ SUCCESS_INTEGRATION = <integration_name> ]
  [ LOG_LEVEL = '<log_level>' ]
  [ COMMENT = <string> ]
  [ <session_parameter> = <value> [ , <session_parameter> = <value> ... ] ]
  [ TASK_AUTO_RETRY_ATTEMPTS = <num> ]
  [ USER_TASK_MINIMUM_TRIGGER_INTERVAL_IN_SECONDS = <num> ]
  [ TARGET_COMPLETION_INTERVAL = '<num> { HOURS | MINUTES | SECONDS }' ]
  [ SERVERLESS_TASK_MIN_STATEMENT_SIZE= 'XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ...' ]
  [ SERVERLESS_TASK_MAX_STATEMENT_SIZE= 'XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ...' ]


ALTER TASK [ IF EXISTS ] <name> UNSET
  [ WAREHOUSE ]
  [ SCHEDULE ]
  [ CONFIG ]
  [ ALLOW_OVERLAPPING_EXECUTION ]
  [ USER_TASK_TIMEOUT_MS ]
  [ SUSPEND_TASK_AFTER_NUM_FAILURES ]
  [ LOG_LEVEL ]
  [ COMMENT ]
  [ <session_parameter> [ , <session_parameter> ... ] ]
  [ TARGET_COMPLETION_INTERVAL ]
  [ SERVERLESS_TASK_MIN_STATEMENT_SIZE ]
  [ SERVERLESS_TASK_MAX_STATEMENT_SIZE ]
  [ , ... ]

ALTER TASK [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER TASK [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER TASK [ IF EXISTS ] <name> SET FINALIZE = <string>

ALTER TASK [ IF EXISTS ] <name> UNSET FINALIZE

ALTER TASK [ IF EXISTS ] <name> MODIFY AS <sql>

ALTER TASK [ IF EXISTS ] <name> MODIFY WHEN <boolean_expr>

ALTER TASK [ IF EXISTS ] <name> REMOVE WHEN

-- Example 11231
ALTER TASK mytask RESUME;

-- Example 11232
ALTER TASK mytask UNSET WAREHOUSE;

ALTER TASK mytask SET USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL';

-- Example 11233
ALTER TASK mytask SET TIMEZONE = 'America/Los_Angeles', CLIENT_TIMESTAMP_TYPE_MAPPING = TIMESTAMP_LTZ;

-- Example 11234
ALTER TASK mytask SET SCHEDULE = 'USING CRON */3 * * * * UTC';

-- Example 11235
ALTER TASK mytask REMOVE AFTER pred_task1, pred_task2;

ALTER TASK mytask ADD AFTER pred_task3;

