-- Example 18537
SELECT department_id
  FROM departments d
  WHERE d.department_id != ALL (
    SELECT e.department_id
      FROM employees e);

-- Example 18538
[ NOT ] EXISTS ( <query> )

-- Example 18539
SELECT department_id
  FROM departments d
  WHERE NOT EXISTS (
    SELECT 1
      FROM employees e
      WHERE e.department_id = d.department_id);

-- Example 18540
<expr> [ NOT ] IN ( <query> )

-- Example 18541
SELECT department_id
  FROM departments d
  WHERE d.department_id NOT IN (
    SELECT e.department_id
      FROM employees e);

-- Example 18542
COMMENT [ IF EXISTS ] ON <object_type> <object_name> IS '<string_literal>';

COMMENT [ IF EXISTS ] ON COLUMN <table_name>.<column_name> IS '<string_literal>';

-- Example 18543
CREATE SCHEMA my_schema COMMENT='this is comment1';

SHOW SCHEMAS LIKE 'my_schema';

-- Example 18544
+-------------------------------+-----------+------------+------------+---------------+---------+------------------+---------+----------------+------+
| created_on                    | name      | is_default | is_current | database_name | owner   | comment          | options | retention_time | ...  |
|-------------------------------+-----------+------------+------------+---------------+---------+------------------+---------+----------------+------|
| 2025-02-26 12:08:52.363 -0800 | MY_SCHEMA | N          | Y          | MY_DB         | MY_ROLE | this is comment1 |         | 1              |  ... |
+-------------------------------+-----------+------------+------------+---------------+---------+------------------+---------+----------------+------+

-- Example 18545
COMMENT ON SCHEMA my_schema IS 'now comment2';

SHOW SCHEMAS LIKE 'my_schema';

-- Example 18546
+-------------------------------+-----------+------------+------------+---------------+---------+--------------+---------+----------------+-----+
| created_on                    | name      | is_default | is_current | database_name | owner   | comment      | options | retention_time | ... |
|-------------------------------+-----------+------------+------------+---------------+---------+--------------+---------+----------------+-----+
| 2025-02-26 12:08:52.363 -0800 | MY_SCHEMA | N          | Y          | MY_DB         | MY_ROLE | now comment2 |         | 1              | ... |
+-------------------------------+-----------+------------+------------+---------------+---------+--------------+---------+----------------+-----+

-- Example 18547
CREATE OR REPLACE TABLE test_comment_table_column(my_column STRING COMMENT 'this is comment3');

DESC TABLE test_comment_table_column;

-- Example 18548
+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+------------------+-------------+----------------+
| name      | type              | kind   | null? | default | primary key | unique key | check | expression | comment          | policy name | privacy domain |
|-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+------------------+-------------+----------------|
| MY_COLUMN | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | this is comment3 | NULL        | NULL           |
+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+------------------+-------------+----------------+

-- Example 18549
COMMENT ON COLUMN test_comment_table_column.my_column IS 'now comment4';

DESC TABLE test_comment_table_column;

-- Example 18550
+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+--------------+-------------+----------------+
| name      | type              | kind   | null? | default | primary key | unique key | check | expression | comment      | policy name | privacy domain |
|-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+--------------+-------------+----------------|
| MY_COLUMN | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | now comment4 | NULL        | NULL           |
+-----------+-------------------+--------+-------+---------+-------------+------------+-------+------------+--------------+-------------+----------------+

-- Example 18551
CREATE OR REPLACE VIEW test_comment_view COMMENT='this is comment5' AS (SELECT * FROM test_comment_table_column);

SHOW VIEWS LIKE 'test_comment_view';

-- Example 18552
+-------------------------------+-------------------+----------+---------------+-------------+---------+------------------+-----+
| created_on                    | name              | reserved | database_name | schema_name | owner   | comment          | ... |
|-------------------------------+-------------------+----------+---------------+-------------+---------+------------------+-----+
| 2025-02-26 12:38:35.440 -0800 | TEST_COMMENT_VIEW |          | MY_DB         | MY_SCHEMA   | MY_ROLE | this is comment5 | ... |
+-------------------------------+-------------------+----------+---------------+-------------+---------+------------------+-----+

-- Example 18553
COMMENT ON VIEW test_comment_view IS 'now comment6';

SHOW VIEWS LIKE 'test_comment_view';

-- Example 18554
+-------------------------------+-------------------+----------+---------------+-------------+---------+--------------+-----+
| created_on                    | name              | reserved | database_name | schema_name | owner   | comment      | ... |
|-------------------------------+-------------------+----------+---------------+-------------+---------+--------------+-----+
| 2025-02-26 12:38:35.440 -0800 | TEST_COMMENT_VIEW |          | MY_DB         | MY_SCHEMA   | MY_ROLE | now comment6 | ... |
+-------------------------------+-------------------+----------+---------------+-------------+---------+--------------+-----+

-- Example 18555
SELECT CURRENT_ROLE(),
       CURRENT_SECONDARY_ROLES(),
       CURRENT_WAREHOUSE(),
       CURRENT_DATABASE(),
       CURRENT_SCHEMA();

-- Example 18556
+----------------+--------------------------+---------------------+--------------------+------------------+
| CURRENT_ROLE() | CURRENT_SECONDARY_ROLES  | CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|----------------+--------------------------+---------------------+--------------------+------------------|
| SYSADMIN       | ALL                      | MYWH                | MYTESTDB           | PUBLIC           |
+----------------+--------------------------+---------------------+--------------------+------------------+

-- Example 18557
-- Unconditional multi-table insert
INSERT [ OVERWRITE ] ALL
  intoClause [ ... ]
<subquery>

-- Conditional multi-table insert
INSERT [ OVERWRITE ] { FIRST | ALL }
  { WHEN <condition> THEN intoClause [ ... ] }
  [ ... ]
  [ ELSE intoClause ]
<subquery>

-- Example 18558
intoClause ::=
  INTO <target_table> [ ( <target_col_name> [ , ... ] ) ] [ VALUES ( { <source_col_name> | DEFAULT | NULL } [ , ... ] ) ]

-- Example 18559
DROP TABLE t;
CREATE TABLE t AS SELECT * FROM ... ;

-- Example 18560
INSERT ALL
  INTO t1
  INTO t1 (c1, c2, c3) VALUES (n2, n1, DEFAULT)
  INTO t2 (c1, c2, c3)
  INTO t2 VALUES (n3, n2, n1)
SELECT n1, n2, n3 from src;

-- If t1 and t2 need to be truncated before inserting, OVERWRITE must be specified
INSERT OVERWRITE ALL
  INTO t1
  INTO t1 (c1, c2, c3) VALUES (n2, n1, DEFAULT)
  INTO t2 (c1, c2, c3)
  INTO t2 VALUES (n3, n2, n1)
SELECT n1, n2, n3 from src;

-- Example 18561
INSERT ALL
  WHEN n1 > 100 THEN
    INTO t1
  WHEN n1 > 10 THEN
    INTO t1
    INTO t2
  ELSE
    INTO t2
SELECT n1 from src;

-- Example 18562
INSERT FIRST
  WHEN n1 > 100 THEN
    INTO t1
  WHEN n1 > 10 THEN
    INTO t1
    INTO t2
  ELSE
    INTO t2
SELECT n1 from src;

-- Example 18563
INSERT ALL
  INTO t1 VALUES ($1, an_alias, "10 + 20")
SELECT 1, 50 AS an_alias, 10 + 20;

-- Example 18564
-- Returns error
  INSERT ALL
    WHEN c > 10 THEN
      INTO t1 (col1, col2) VALUES (a, b)
  SELECT a FROM src;

-- Completes successfully
  INSERT ALL
    WHEN c > 10 THEN
      INTO t1 (col1, col2) VALUES (a, b)
  SELECT a, b, c FROM src;

-- Example 18565
-- Returns error
  INSERT ALL
    INTO t1 VALUES (src1.key, a)
  SELECT src1.a AS a
  FROM src1, src2 WHERE src1.key = src2.key;

-- Completes successfully
  INSERT ALL
    INTO t1 VALUES (key, a)
  SELECT src1.key AS key, src1.a AS a
  FROM src1, src2 WHERE src1.key = src2.key;

-- Example 18566
ALTER [ API ] INTEGRATION [ IF EXISTS ] <name> SET
  [ API_AWS_ROLE_ARN = '<iam_role>' ]
  [ AZURE_AD_APPLICATION_ID = '<azure_application_id>' ]
  [ API_KEY = '<api_key>' ]
  [ ENABLED = { TRUE | FALSE } ]
  [ API_ALLOWED_PREFIXES = ('<...>') ]
  [ API_BLOCKED_PREFIXES = ('<...>') ]
  [ COMMENT = '<string_literal>' ]

ALTER [ API ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ API ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ API ] INTEGRATION [ IF EXISTS ] <name>  UNSET {
                                                      API_KEY              |
                                                      ENABLED              |
                                                      API_BLOCKED_PREFIXES |
                                                      COMMENT
                                                      }
                                                      [ , ... ]

-- Example 18567
ALTER API INTEGRATION myint SET ENABLED = TRUE;

-- Example 18568
ALTER AUTHENTICATION POLICY <name> RENAME TO <new_name>

ALTER AUTHENTICATION POLICY [ IF EXISTS ] <name> SET
  [ AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_AUTHENTICATION_METHODS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ MFA_ENROLLMENT = { REQUIRED | OPTIONAL } ]
  [ CLIENT_TYPES = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ SECURITY_INTEGRATIONS = ( '<string_literal>' [ , '<string_literal>' , ...  ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER AUTHENTICATION POLICY [ IF EXISTS ] <name> UNSET
  [ CLIENT_TYPES ]
  [ AUTHENTICATION_METHODS ]
  [ SECURITY_INTEGRATIONS ]
  [ MFA_AUTHENTICATION_METHODS ]
  [ MFA_ENROLLMENT ]
  [ COMMENT ]

-- Example 18569
ALTER AUTHENTICATION POLICY restrict_client_types_policy SET CLIENT_TYPES = ('SNOWFLAKE_UI', 'SNOWSQL');

-- Example 18570
ALTER CATALOG INTEGRATION [ IF EXISTS ] <name> SET
  [ REFRESH_INTERVAL_SECONDS = <value> ]
  [ COMMENT = '<string_literal>' ]

-- Example 18571
ALTER CATALOG INTEGRATION myCatalogIntegration SET REFRESH_INTERVAL_SECONDS = 30;

-- Example 18572
ALTER COMPUTE POOL [ IF EXISTS ] <name> { SUSPEND | RESUME }

ALTER COMPUTE POOL [ IF EXISTS ] <name> STOP ALL;

ALTER COMPUTE POOL [ IF EXISTS ] <name> SET [ MIN_NODES = <num> ]
                                            [ MAX_NODES = <num> ]
                                            [ AUTO_RESUME = { TRUE | FALSE } ]
                                            [ AUTO_SUSPEND_SECS = <num> ]
                                            [ COMMENT = '<string_literal>' ]
                                            [ TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ]

ALTER COMPUTE POOL [ IF EXISTS ] <name> UNSET { AUTO_SUSPEND_SECS |
                                                AUTO_RESUME       |
                                                COMMENT
                                              }
                                              [ , ... ]

-- Example 18573
ALTER COMPUTE POOL tutorial_compute_pool SET
  MAX_NODES = 5
  AUTO_RESUME = FALSE

-- Example 18574
ALTER DATASET <name> ADD VERSION <version_name>
  FROM <select_statement>
  [ PARTITION BY <string_expr> ]
  [ COMMENT = <string_literal> ]
  [ METADATA = <json_string_literal> ]

-- Example 18575
{"source": "my_table", "job_id": "123"}

-- Example 18576
ALTER DATASET abc
ADD VERSION 'v1' FROM (
    SELECT seq4() as ID, uniform(1, 10, random(721)) as PART
    FROM TABLE(GENERATOR(ROWCOUNT => 100000)) v)
PARTITION BY PART
COMMENT = 'Initial version'
METADATA = '{"source":"some_table","created_by":"analyst1"}';

-- Example 18577
ALTER DATASET [ IF EXISTS ] <name> DROP VERSION <version_name>

-- Example 18578
ALTER DATASET my_dataset
DROP VERSION 'v1';

-- Example 18579
ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { SUSPEND | RESUME }

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> SWAP WITH <target_dynamic_table_name>

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> REFRESH [ COPY SESSION ]

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { clusteringAction }

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> { tableColumnCommentAction }

ALTER DYNAMIC TABLE <name> { SET | UNSET } COMMENT = '<string_literal>'

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> SET
  [ TARGET_LAG = { '<num> { seconds | minutes | hours | days }'  | DOWNSTREAM } ]
  [ WAREHOUSE = <warehouse_name> ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ LOG_LEVEL = '<log_level>' ]

ALTER DYNAMIC TABLE [ IF EXISTS ] <name> UNSET
  [ DATA_RETENTION_TIME_IN_DAYS ],
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS ],
  [ DEFAULT_DDL_COLLATION ]
  [ LOG_LEVEL ]

-- Example 18580
clusteringAction ::=
  {
    CLUSTER BY ( <expr> [ , <expr> , ... ] )
    | { SUSPEND | RESUME } RECLUSTER
    | DROP CLUSTERING KEY
  }

-- Example 18581
tableCommentAction ::=
  {
    ALTER | MODIFY [ ( ]
                           [ COLUMN ] <col1_name> COMMENT '<string>'
                         , [ COLUMN ] <col1_name> UNSET COMMENT
                       [ , ... ]
                   [ ) ]
  }

-- Example 18582
dataGovnPolicyTagAction ::=
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                  , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }

-- Example 18583
searchOptimizationAction ::=
  {
    ADD SEARCH OPTIMIZATION [
      ON <search_method_with_target> [ , <search_method_with_target> ... ]
        [ EQUALITY ]
      ]

    | DROP SEARCH OPTIMIZATION [
      ON { <search_method_with_target> | <column_name> | <expression_id> }
        [ EQUALITY ]
        [ , ... ]
      ]

    | SUSPEND SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]

    | RESUME SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]
  }

-- Example 18584
<search_method>(<target> [, ...])

-- Example 18585
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 18586
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 18587
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 18588
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 18589
ALTER DYNAMIC TABLE product ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 18590
ALTER DYNAMIC TABLE IDENTIFIER(product) SUSPEND;

-- Example 18591
ALTER DYNAMIC TABLE product SET
  TARGET_LAG = '1 hour';

-- Example 18592
ALTER DYNAMIC TABLE product SET TARGET_LAG = DOWNSTREAM;

-- Example 18593
ALTER DYNAMIC TABLE product SUSPEND;

-- Example 18594
ALTER DYNAMIC TABLE product RESUME;

-- Example 18595
ALTER DYNAMIC TABLE product RENAME TO updated_product;

-- Example 18596
ALTER DYNAMIC TABLE product SWAP WITH new_product;

-- Example 18597
ALTER DYNAMIC TABLE product CLUSTER BY (date);

-- Example 18598
ALTER DYNAMIC TABLE product DROP CLUSTERING KEY;

-- Example 18599
ALTER DYNAMIC TABLE product REFRESH COPY SESSION

-- Example 18600
ALTER EXTERNAL TABLE [ IF EXISTS ] <name> REFRESH [ '<relative-path>' ]

ALTER EXTERNAL TABLE [ IF EXISTS ] <name> ADD FILES ( '<path>/[<filename>]' [ , '<path>/[<filename>'] ] )

ALTER EXTERNAL TABLE [ IF EXISTS ] <name> REMOVE FILES ( '<path>/[<filename>]' [ , '<path>/[<filename>]' ] )

ALTER EXTERNAL TABLE [ IF EXISTS ] <name> SET AUTO_REFRESH = { TRUE | FALSE }

-- Example 18601
ALTER EXTERNAL TABLE <name> [ IF EXISTS ] ADD PARTITION ( <part_col_name> = '<string>' [ , <part_col_name> = '<string>' ] ) LOCATION '<path>'

ALTER EXTERNAL TABLE <name> [ IF EXISTS ] DROP PARTITION LOCATION '<path>'

-- Example 18602
ALTER TABLE <name> ADD COLUMN ( <col_name> <col_type> AS <expr> ) [, ...]

-- Example 18603
ALTER TABLE <name> RENAME COLUMN <col_name> to <new_col_name>

