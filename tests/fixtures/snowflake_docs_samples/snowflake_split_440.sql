-- Example 29454
create or replace table MYTABLE(
  MYCOL ... start 1 increment 1
  ...

-- Example 29455
create or replace table MYTABLE(
  MYCOL ... start 1 increment 1 order
  ...

-- Example 29456
create or replace table MYTABLE(
  MYCOL ... start 1 increment 1 noorder
  ...

-- Example 29457
Insufficient privileges to operate on account '<account_name>'

-- Example 29458
SELECT KEY, VALUE
  FROM TABLE(FLATTEN(
    input=>PARSE_JSON(
      SYSTEM$GET_PRIVATELINK_CONFIG())));

-- Example 29459
SELECT my_database.my_schema.array_flatten(...);

-- Example 29460
CREATE OR REPLACE VIEW my_task_history
  AS SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY;

-- Example 29461
View definition for MY_DB.MY_SCHEMA.MY_TASK_HISTORY' declared 22 column(s),
but view query produces 27 column(s).

-- Example 29462
CREATE OR REPLACE VIEW my_task_history
  AS SELECT query_text, completed_time FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY;

-- Example 29463
GRANT USAGE ON DATABASE mydb TO SHARE myshare;
GRANT OWNERSHIP ON DATABASE mydb TO ROLE r2 REVOKE CURRENT GRANTS;

-- Example 29464
DROP ROLE r2;

-- Example 29465
Cannot transfer ownership on a database that is granted to a share

-- Example 29466
REVOKE USAGE ON DATABASE mydb FROM SHARE myshare;
GRANT OWNERSHIP ON DATABASE mydb TO ROLE r2;
GRANT USAGE ON DATABASE mydb TO SHARE r2;

-- Example 29467
Cannot drop a role that is the owner of one or more shared databases. Run 'SHOW GRANTS TO ROLE <role_name>' to find these shared
databases and transfer their ownership to appropriate role using 'GRANT OWNERSHIP ON DATABASE <database_name> TO ROLE
<target_role_name> COPY CURRENT GRANTS'.

-- Example 29468
DROP ACCOUNT reader_acct1;

-- Example 29469
Drop account command not allowed for managed accounts. Use command drop managed account. For more details visit https://docs.snowflake.com/en/sql-reference/sql/drop-managed-account.

-- Example 29470
SQL compilation error: Invalid object type: '{0}'

-- Example 29471
SQL compilation error: This operation is not supported on APPLICATION PACKAGE 'app pkg'

-- Example 29472
Unsupported statement type PUT_FILES

-- Example 29473
GRANT SELECT ON FUTURE TABLES IN SCHEMA sh TO DATABASE ROLE dbr1;
GRANT DATABASE ROLE dbr1 TO SHARE myshare;

-- Example 29474
GRANT DATABASE ROLE dbr1 TO SHARE myshare;
GRANT SELECT ON FUTURE TABLES IN SCHEMA sh TO DATABASE ROLE dbr1;

-- Example 29475
SHOW FUTURE GRANTS IN DATABASE parent_db;
SHOW FUTURE GRANTS IN shared_schema;

-- Example 29476
Cannot share a database role with future grants to it.

-- Example 29477
Cannot grant future grants to a database role that is granted to a share.

-- Example 29478
SELECT * FROM my_mv;

-- Example 29479
002037 (42601): SQL compilation error:
  Failure during expansion of view 'MY_MV':
    SQL compilation error: Materialized View MY_MV is invalid.
    Invalidation reason: Division by zero

-- Example 29480
SHOW MATERIALIZED VIEWS;

-- Example 29481
...  +---------+------------------+ ...
...  | invalid | invalid_reason   | ...
...  +---------+------------------+ ...
...  | true    | Division by zero | ...
...  +---------+------------------+ ...

-- Example 29482
CREATE OR REPLACE TABLE my_base_table (a INT, b INT, c VARCHAR(16));

-- Example 29483
INSERT INTO my_base_table VALUES (1, 1, 'valid data');

-- Example 29484
CREATE OR REPLACE MATERIALIZED VIEW my_mv AS SELECT a / b AS div FROM my_base_table;

-- Example 29485
INSERT INTO my_base_table VALUES (1, 0, 'invalid data');

-- Example 29486
SELECT * FROM my_mv;

-- Example 29487
002037 (42601): SQL compilation error:
  Failure during expansion of view 'MY_MV':
    SQL compilation error: Materialized View MY_MV is invalid.
    Invalidation reason: Division by zero

-- Example 29488
SHOW MATERIALIZED VIEWS;

-- Example 29489
...  +---------+------------------+ ...
...  | invalid | invalid_reason   | ...
...  +---------+------------------+ ...
...  | true    | Division by zero | ...
...  +---------+------------------+ ...

-- Example 29490
ALTER MATERIALIZED VIEW my_mv RESUME;

-- Example 29491
SELECT my_database.my_schema.array_sort(...);

-- Example 29492
WITH wv AS (
    SELECT a FROM t WHERE a % 2 = 1
  )
  SELECT a FROM wv WHERE a % 3 = 1
  UNION ALL
  SELECT a FROM wv WHERE a % 5 = 1;

-- Example 29493
EXPLAIN WITH wv AS (
    SELECT a FROM t WHERE a % 2 = 1
  )
  SELECT a FROM wv WHERE a % 3 = 1
  UNION ALL
  SELECT a FROM wv WHERE a % 5 = 1;

-- Example 29494
+------+------+--------+---------------+ ...
| step | id   | parent | operation     | ...
+------+------+--------+---------------+ ...
| NULL | NULL |   NULL | GlobalStats   | ...
|    1 |    0 |   NULL | Result        | ...
|    1 |    1 |      0 | UnionAll      | ...
|    1 |    2 |      1 | Filter        | ...
|    1 |    3 |      2 | WithReference | ...
|    1 |    4 |      3 | WithClause    | ...
...

-- Example 29495
+------+------+-----------------+---------------+ ...
| step | id   | parentOperators | operation     | ...
|------+------+-----------------+---------------+ ...
| NULL | NULL | NULL            | GlobalStats   | ...
|    1 |    0 | NULL            | Result        | ...
|    1 |    1 | [0]             | UnionAll      | ...
|    1 |    2 | [1]             | Filter        | ...
|    1 |    3 | [2]             | WithReference | ...
|    1 |    4 | [3, 8]          | WithClause    | ...
...

-- Example 29496
EXPLAIN USING JSON WITH wv AS (
    SELECT a FROM t WHERE a % 2 = 1
  )
  SELECT a FROM wv WHERE a % 3 = 1
  UNION ALL
  SELECT a FROM wv WHERE a % 5 = 1;

-- Example 29497
{
  ...
  "Operations": [[
    ...
    {"id":1,"parent":0,"operation":"UnionAll"},
    {"id":2,"parent":1,"operation":"Filter", ...},
    {"id":3,"parent":2,"operation":"WithReference"},
    {"id":4,"parent":3,"operation":"WithClause", ...},
    ...

-- Example 29498
{
  ...
  "Operations":[[
    ...
    {"id":1,"operation":"UnionAll","parentOperators":[0]},
    {"id":2,"operation":"Filter",... , "parentOperators":[1]},
    {"id":3,"operation":"WithReference","parentOperators":[2]},
    {"id":4,"operation":"WithClause",... ,"parentOperators":[3,8]},
    ...

-- Example 29499
WITH wv AS (
    SELECT a FROM t WHERE a % 2 = 1
  )
  SELECT a FROM wv WHERE a % 3 = 1
  UNION ALL
  SELECT a FROM wv WHERE a % 5 = 1;

-- Example 29500
SET lid = LAST_QUERY_ID();

-- Example 29501
SELECT * FROM TABLE(GET_QUERY_OPERATOR_STATS($lid));

-- Example 29502
+-----+---------+-------------+--------------------+---------------+ ...
| ... | STEP_ID | OPERATOR_ID | PARENT_OPERATOR_ID | OPERATOR_TYPE | ...
+-----+---------+-------------+--------------------+---------------+ ...
| ... |       1 |           0 |               NULL | Result        | ...
| ... |       1 |           1 |                  0 | UnionAll      | ...
| ... |       1 |           2 |                  1 | Filter        | ...
| ... |       1 |           3 |                  2 | WithReference | ...
| ... |       1 |           4 |                  3 | WithClause    | ...
...

-- Example 29503
|-----+---------+-------------+------------------+---------------+ ...
| ... | STEP_ID | OPERATOR_ID | PARENT_OPERATORS | OPERATOR_TYPE | ...
|-----+---------+-------------+------------------+---------------+ ...
| ... |       1 |           0 | NULL             | Result        | ...
| ... |       1 |           1 | [                | UnionAll      | ...
|     |         |             |   0              |               | ...
|     |         |             | ]                |               | ...
| ... |       1 |           2 | [                | Filter        | ...
|     |         |             |   1              |               | ...
|     |         |             | ]                |               | ...
| ... |       1 |           3 | [                | WithReference | ...
|     |         |             |   2              |               | ...
|     |         |             | ]                |               | ...
| ... |       1 |           4 | [                | WithClause    | ...
|     |         |             |   3,             |               | ...
|     |         |             |   8              |               | ...
|     |         |             | ]                |               | ...
...

-- Example 29504
{
    "<col1_name>": {
    "extra_info" : {
        "alternates" : [<semantic_categories>],
        "probability" : "<number>"
    },
    "privacy_category" : "<value>",
    "semantic_category" : "<value>"
    },
...
...
    "<colN_name>": {
    "extra_info" : {
        "alternates" : [<semantic_categories>],
        "probability" : "<number>"
    },
    "privacy_category" : "<value>",
    "semantic_category" : "<value>"
    }
}

-- Example 29505
{
  "valid_value_ratio": 1.0,
  "recommendation": {
    "semantic_category": "PASSPORT",
    "privacy_category": "IDENTIFIER",
    "confidence": "HIGH",
    "coverage": 0.7,
    "details": [
      {
        "semantic_category": "US_PASSPORT",
        "coverage": 0.7
      },
      {
        "semantic_category": "CA_PASSPORT",
        "coverage": 0.1
      }
    ]
  },
  "alternates": [
    {
      "semantic_category": "NATIONAL_IDENTIFIER",
      "privacy_category": "IDENTIFIER",
      "confidence": "LOW",
      "coverage": 0.3,
      "details": [
        {
          "semantic_category": "US_SSN",
          "privacy_category": "IDENTIFIER",
          "coverage": 0.3
        }
      ]
    }
  ]
}

-- Example 29506
ALTER TABLE mydb.myschema.mytable
  MODIFY COLUMN passport
  SET TAG SNOWFLAKE.CORE.SEMANTIC_CATEGORY = 'PASSPORT';

-- Example 29507
GRANT ALL ON ACCOUNT TO ROLE r1;

-- Example 29508
+--------------------------------------------------------------------------------------------------------------------------+
| status                                                                                                                   |
|--------------------------------------------------------------------------------------------------------------------------|
| Grant partially executed: privileges [MANAGE LISTING AUTO FULFILLMENT, MANAGE ORGANIZATION SUPPORT CASES] not granted.   |
+--------------------------------------------------------------------------------------------------------------------------+

-- Example 29509
003011 (42501): Grant partially executed: privileges [MANAGE LISTING AUTO FULFILLMENT, MANAGE ORGANIZATION SUPPORT CASES] not granted.

-- Example 29510
003011: Grant partially executed: [ one or more privileges ] not granted.
003012: Revoke partially executed: [ one or more privileges ] not revoked.
003102: Grant not executed: Insufficient privileges.
003103: Revoke not executed: Insufficient privileges.
003104: Grant not executed: Operation not supported on a SHARE object.
003105: Revoke not executed: Operation not supported on a SHARE object.

-- Example 29511
SHOW <domain_plural> [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 29512
SHOW GRANTS [ LIMIT <rows> ]

-- Example 29513
SHOW APPLICATION ROLES IN APPLICATION myapp LIMIT 10 FROM 'app_role2';

-- Example 29514
GRANT READ ON TAG mytag TO SHARE myshare;

-- Example 29515
GRANT READ ON TAG mytag TO DATABASE ROLE mydb.dbrole;
GRANT DATABASE ROLE mydb.dbrole TO SHARE myshare;

-- Example 29516
SHOW TAGS IN shared_database;
SHOW TAGS IN shared_schema;

-- Example 29517
USE ROLE ACCOUNTADMIN;

SELECT *
    FROM snowflake.account_usage.masking_policies
    WHERE policy_body ilike '%is_granted_to_invoker_role%';

-- Example 29518
SELECT
    COUNT(*) > 0 AS IS_IMPACTED
FROM
    SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS AS GL
        INNER JOIN SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_USERS AS GR
            ON GL.ROLE = GR.ROLE
            AND GL.GRANTED_TO = GR.GRANTED_TO
            AND GL.GRANTEE_NAME = GR.GRANTEE_NAME
            AND GL.GRANTED_BY = GR.GRANTED_BY
            AND GL.DELETED_ON = GR.CREATED_ON
            AND GR.DELETED_ON IS NOT NULL;

-- Example 29519
{
"cluster_by_keys" : "LINEAR(i)",
"notes" : "Clustering key columns contain high cardinality key I which
might result in expensive re-clustering. Consider reducing the
cardinality of clustering keys. Please refer to
https://docs.snowflake.net/manuals/user-guide/tables-clustering-keys.html
for more information.",
"total_partition_count" : 0,
"total_constant_partition_count" : 0,
"average_overlaps" : 0.0,
"average_depth" : 0.0,
"partition_depth_histogram" : {
    "00000" : 0,
    // omitted for brevity
},
"clustering_errors" : [ {
    "timestamp" : "2023-04-03 17:50:42 +0000",
    "error" : "(003325) Clustering service has been disabled.\n"
} ]
}

-- Example 29520
SELECT SYSTEM$CLUSTERING_INFORMATION( 'my_table' , 25);

