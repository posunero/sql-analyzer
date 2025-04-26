-- Example 29387
ALTER WAREHOUSE my_wh SET
  COMMENT = 'Updated comment for warehouse';

-- Example 29388
ALTER WAREHOUSE my_wh SET
  WAREHOUSE_SIZE = 'SMALL';

-- Example 29389
GRANT CREATE SNOWFLAKE.CORE.BUDGET
  ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_creator;

-- Example 29390
GRANT CREATE SNOWFLAKE.ML.FORECAST
  ON SCHEMA admin_db.admin_schema
  TO ROLE analyst;

-- Example 29391
GRANT CREATE SNOWFLAKE.ML.FORECAST
  ON SCHEMA admin_db.admin_schema
  TO ROLE analyst;

-- Example 29392
SELECT my_database.my_schema.greatest_ignore_nulls(...);

SELECT my_database.my_schema.least_ignore_nulls(...);

-- Example 29393
ExecuteStreamlit,streamlitName: STREAMLIT_DB.STREAMLIT_SCHEMA.OBJECT_NAME,streamlitId:123456789

-- Example 29394
File "/usr/lib/python_udf/ed2bb26281494c8405804a3281315153bd4c74b8d05d7de038bb8ce6fe8796d5/lib/python3.8/site-packages/streamlit/runtime/scriptrunner/script_runner.py", line 552, in _run_script
exec(code, module.dict)
File "/home/udf/10380937708282/streamlit_app.py", line 29, in <module>
df = session.sql(sql).collect()
File "/usr/lib/python_udf/ed2bb26281494c8405804a3281315153bd4c74b8d05d7de038bb8ce6fe8796d5/lib/python3.8/site-packages/snowflake/snowpark/_internal/telemetry.py", line 139, in wrap
result = func(*args, **kwargs)

-- Example 29395
{
  "StreamlitEngine": "ExecuteStreamlit",
  "StreamlitName": "STREAMLIT_DB.STREAMLIT_SCHEMA.OBJECT_NAME"
}

-- Example 29396
{
  "StreamlitEngine": "ExecuteStreamlit",
  "StreamlitName": "STREAMLIT_DB.STREAMLIT_SCHEMA.OBJECT_NAME",
  "ChildQuery": "true"
}

-- Example 29397
090841 (0A000): Database cannot have "DATACLOUD$" as prefix in its name.

-- Example 29398
CREATE OR REPLACE TABLE collated_like (
  col_a VARCHAR,
  col_b VARCHAR COLLATE 'lower'
);

INSERT INTO collated_like VALUES ('abc', 'abc'), ('ABC','ABC');

-- Example 29399
SELECT * FROM collated_like WHERE col_a LIKE '%b%';

SELECT * FROM collated_like WHERE col_a COLLATE 'lower' LIKE '%b%';

SELECT * FROM collated_like WHERE col_b LIKE '%b%';

-- Example 29400
+-------+-------+
| COL_A | COL_B |
|-------+-------|
| abc   | abc   |
+-------+-------+

-- Example 29401
SELECT * FROM collated_like WHERE col_a LIKE '%b%';

-- Example 29402
+-------+-------+
| COL_A | COL_B |
|-------+-------|
| abc   | abc   |
+-------+-------+

-- Example 29403
SELECT * FROM collated_like WHERE col_a COLLATE 'lower' LIKE '%b%';

SELECT * FROM collated_like WHERE col_b LIKE '%b%';

-- Example 29404
+-------+-------+
| COL_A | COL_B |
|-------+-------|
| abc   | abc   |
| ABC   | ABC   |
+-------+-------+

-- Example 29405
SELECT * FROM collated_like WHERE col_b COLLATE '' LIKE '%b%';

-- Example 29406
SELECT * FROM asof;
WITH match_condition AS (SELECT * FROM T1)
  SELECT * FROM match_condition;

-- Example 29407
SELECT * FROM "asof";
WITH "match_condition" AS (SELECT * FROM T1)
  SELECT * FROM "match_condition";

-- Example 29408
SELECT * FROM "ASOF";
WITH "MATCH_CONDITION" AS (SELECT * FROM T1)
  SELECT * FROM "MATCH_CONDITION";

-- Example 29409
SELECT * FROM t1 asof;
SELECT * FROM t2 match_condition;

-- Example 29410
SELECT * FROM t1 AS asof;
SELECT * FROM t1 "asof";
SELECT * FROM t2 AS match_condition;
SELECT * FROM t2 "match_condition";

-- Example 29411
set asof ='2024/01/15';

-- Example 29412
001003 (42000): SQL compilation error:
syntax error line 1 at position 4 unexpected 'asof'.

-- Example 29413
set "asof" ='2024/01/15';

-- Example 29414
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 29415
CREATE OR REPLACE PROCEDURE my_proc (
  arg1 string,
  arg2 boolean default true
)
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
  return 'hello world';
$$;

-- Example 29416
A POLICY in a versioned schema can only be assigned to the objects in the same schema. An object in a versioned schema can only have a POLICY assigned that is defined in the same schema.

-- Example 29417
A TAG in a versioned schema can only be assigned to the objects in the same schema. An object in a versioned schema can only have a TAG assigned that is defined in the same schema.

-- Example 29418
CREATE OR REPLACE PROCEDURE myproc_child()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  SELECT * FROM mydb.mysch.mytable;
  RETURN 1;
  END
$$;

CREATE OR REPLACE PROCEDURE myproc_parent()
RETURNS INTEGER
LANGUAGE SQL
AS
$$
  BEGIN
  CALL myproc_child();
  RETURN 1;
  END
$$;

CALL myproc_parent();

-- Example 29419
USE ROLE GOVERNANCE_VIEWER;

SELECT
  query_id,
  parent_query_id,
  root_query_id,
  direct_objects_accessed
FROM
  SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY;

-- Example 29420
+----------+-----------------+---------------+-----------------------------------+
| QUERY_ID | PARENT_QUERY_ID | ROOT_QUERY_ID |      DIRECT_OBJECTS_ACCESSED      |
+----------+-----------------+---------------+-----------------------------------+
|  1       | NULL            | NULL          | [{"objectName": "myproc_parent"}] |
|  2       | 1               | 1             | [{"objectName": "myproc_child"}]  |
|  3       | 2               | 1             | [{"objectName": "mytable"}]       |
+----------+-----------------+---------------+-----------------------------------+

-- Example 29421
SELECT DIV0(5, 9), DIV0NULL(5, 9), 5/9;

-- Example 29422
+------------+----------------+----------+
| DIV0(5, 9) | DIV0NULL(5, 9) |      5/9 |
|------------+----------------+----------|
|   0.555555 |       0.555555 | 0.555556 |
+------------+----------------+----------+

-- Example 29423
+------------+----------------+----------+
| DIV0(5, 9) | DIV0NULL(5, 9) |      5/9 |
|------------+----------------+----------|
|   0.555556 |       0.555556 | 0.555556 |
+------------+----------------+----------+

-- Example 29424
000939 (22023): SQL compilation error: ...
  too many arguments for function [DIV0] expected 2, got 3

-- Example 29425
Reference definition '<REF_DEF_NAME>' cannot be found in the current version of the application '<APP_NAME>'

-- Example 29426
COPY_HISTORY( START_TIME=> ?, ...

-- Example 29427
COPY_HISTORY( START_TIME=> DATEADD('days', ?, ...

-- Example 29428
Invalid argument types for function 'MAP_KEYS' ...

-- Example 29429
SELECT my_database.my_schema.map_keys(...);

-- Example 29430
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'SELECT');

-- Example 29431
SELECT SYSTEM$REFERENCE('TABLE', 'v1', 'SESSION', 'SELECT');

-- Example 29432
505028 (42601): Object type VIEW does not match the specified type TABLE for reference creation

-- Example 29433
CREATE OR REPLACE FUNCTION "passthrough:function"(arg VARCHAR)
  RETURNS VARCHAR
  ...

-- Example 29434
+--------------------+------------------------+
| ARGUMENT_SIGNATURE | DATA_TYPE              |
|--------------------+------------------------|
| (                  | TABLEVARCHAR(16777216) |
+--------------------+------------------------+

-- Example 29435
+--------------------+-------------------+
| ARGUMENT_SIGNATURE | DATA_TYPE         |
|--------------------+-------------------|
| (ARG VARCHAR)      | VARCHAR(16777216) |
+--------------------+-------------------+

-- Example 29436
OPERATE privilege is required on all upstream Dynamic Tables of '<table_name>' to perform a synchronous INITIAL refresh. Please acquire the right privileges.

-- Example 29437
GRANT REFERENCE USAGE ON DATABASE <database_name> TO SHARE IN APPLICATION PACKAGE <app_package>;

-- Example 29438
SELECT * FROM my_table AS my_table_alias(my_column_1_alias, my_column_2_alias);

-- Example 29439
SELECT * FROM table_1 AS my_table_alias("my_column_alias");

-- Example 29440
SELECT """my_column_alias""" FROM table_1 AS my_table_alias("my_column_alias");

-- Example 29441
SELECT * FROM table_1 AS my_table_alias("my_column_alias");

-- Example 29442
SELECT """my_column_alias""" FROM table_1 AS my_table_alias("my_column_alias");

-- Example 29443
SELECT """My_Column_Alias"""
  FROM table_1 AS my_table_alias("My_Column_Alias")

-- Example 29444
WITH my_table_alias("""My_Column_Alias""")
    AS (SELECT * FROM table_1)
  SELECT """My_Column_Alias""" FROM my_table_alias

-- Example 29445
SELECT """my_column_alias"""
  FROM table_1 AS my_table_alias("my_column_alias");

-- Example 29446
SELECT my_column_alias
  FROM table_1 AS my_table_alias(my_column_alias);

-- Example 29447
Any policy of kind ROW_ACCESS_POLICY is not attached to TABLE T1.

-- Example 29448
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 29449
GRANT REFERENCE_USAGE ON DATABASE <name> TO SHARE IN APPLICATION PACKAGE <app_package>

-- Example 29450
091032 (22000): Your client app version, {0}, is using a deprecated pre-signed URL for
PUT. Please upgrade to a version that supports GCP downscoped token. See
https://community.snowflake.com/s/article/faq-2023-client-driver-deprecation-for-GCP-customers.

-- Example 29451
start 1 increment 1

-- Example 29452
start 1 increment 1 order

-- Example 29453
start 1 increment 1 noorder

