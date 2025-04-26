-- Example 24363
SELECT ... FROM my_table,
  TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 24364
CREATE TABLE t1 (col1 INTEGER);
CREATE TABLE t2 (col1 INTEGER);

-- Example 24365
INSERT INTO t1 (col1) VALUES 
   (2),
   (3),
   (4);
INSERT INTO t2 (col1) VALUES 
   (1),
   (2),
   (2),
   (3);

-- Example 24366
SELECT t1.col1, t2.col1
    FROM t1 INNER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 24367
SELECT t1.col1, t2.col1
    FROM t1 LEFT OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
|    4 | NULL |
+------+------+

-- Example 24368
SELECT t1.col1, t2.col1
    FROM t1 RIGHT OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
| NULL |    1 |
+------+------+

-- Example 24369
SELECT t1.col1, t2.col1
    FROM t1 FULL OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
|    4 | NULL |
| NULL |    1 |
+------+------+

-- Example 24370
SELECT t1.col1, t2.col1
    FROM t1 CROSS JOIN t2
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    1 |
|    2 |    2 |
|    2 |    2 |
|    2 |    3 |
|    3 |    1 |
|    3 |    2 |
|    3 |    2 |
|    3 |    3 |
|    4 |    1 |
|    4 |    2 |
|    4 |    2 |
|    4 |    3 |
+------+------+

-- Example 24371
SELECT t1.col1, t2.col1
    FROM t1 CROSS JOIN t2
    WHERE t2.col1 = t1.col1
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 24372
CREATE OR REPLACE TABLE d1 (
  id number,
  name string
  );
+--------------------------------+
| status                         |
|--------------------------------|
| Table D1 successfully created. |
+--------------------------------+
INSERT INTO d1 (id, name) VALUES
  (1,'a'),
  (2,'b'),
  (4,'c');
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
CREATE OR REPLACE TABLE d2 (
  id number,
  value string
  );
+--------------------------------+
| status                         |
|--------------------------------|
| Table D2 successfully created. |
+--------------------------------+
INSERT INTO d2 (id, value) VALUES
  (1,'xx'),
  (2,'yy'),
  (5,'zz');
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
SELECT *
    FROM d1 NATURAL INNER JOIN d2
    ORDER BY id;
+----+------+-------+
| ID | NAME | VALUE |
|----+------+-------|
|  1 | a    | xx    |
|  2 | b    | yy    |
+----+------+-------+

-- Example 24373
SELECT *
  FROM d1 NATURAL FULL OUTER JOIN d2
  ORDER BY ID;
+----+------+-------+
| ID | NAME | VALUE |
|----+------+-------|
|  1 | a    | xx    |
|  2 | b    | yy    |
|  4 | c    | NULL  |
|  5 | NULL | zz    |
+----+------+-------+

-- Example 24374
CREATE TABLE t3 (col1 INTEGER);
INSERT INTO t3 (col1) VALUES 
   (2),
   (6);

-- Example 24375
SELECT t1.*, t2.*, t3.*
  FROM t1
     LEFT OUTER JOIN t2 ON (t1.col1 = t2.col1)
     RIGHT OUTER JOIN t3 ON (t3.col1 = t2.col1)
  ORDER BY t1.col1;
+------+------+------+
| COL1 | COL1 | COL1 |
|------+------+------|
|    2 |    2 |    2 |
|    2 |    2 |    2 |
| NULL | NULL |    6 |
+------+------+------+

-- Example 24376
SELECT t1.*, t2.*, t3.*
  FROM t1
     LEFT OUTER JOIN
     (t2 RIGHT OUTER JOIN t3 ON (t3.col1 = t2.col1))
     ON (t1.col1 = t2.col1)
  ORDER BY t1.col1;
+------+------+------+
| COL1 | COL1 | COL1 |
|------+------+------|
|    2 |    2 |    2 |
|    2 |    2 |    2 |
|    3 | NULL | NULL |
|    4 | NULL | NULL |
+------+------+------+

-- Example 24377
WITH
    l AS (
         SELECT 'a' AS userid
         ),
    r AS (
         SELECT 'b' AS userid
         )
  SELECT *
    FROM l LEFT JOIN r USING(userid)
;
+--------+
| USERID |
|--------|
| a      |
+--------+

-- Example 24378
WITH
    l AS (
         SELECT 'a' AS userid
       ),
    r AS (
         SELECT 'b' AS userid
         )
  SELECT l.userid as UI_L,
         r.userid as UI_R
    FROM l LEFT JOIN r USING(userid)
;
+------+------+
| UI_L | UI_R |
|------+------|
| a    | NULL |
+------+------+

-- Example 24379
<expr> comparisonOperator { ALL | ANY } ( <query> )

-- Example 24380
comparisonOperator ::=
  { = | != | > | >= | < | <= }

-- Example 24381
SELECT department_id
  FROM departments d
  WHERE d.department_id != ALL (
    SELECT e.department_id
      FROM employees e);

-- Example 24382
[ NOT ] EXISTS ( <query> )

-- Example 24383
SELECT department_id
  FROM departments d
  WHERE NOT EXISTS (
    SELECT 1
      FROM employees e
      WHERE e.department_id = d.department_id);

-- Example 24384
<expr> [ NOT ] IN ( <query> )

-- Example 24385
SELECT department_id
  FROM departments d
  WHERE d.department_id NOT IN (
    SELECT e.department_id
      FROM employees e);

-- Example 24386
ALTER RESOURCE MONITOR [ IF EXISTS ] <name> [ SET { [ CREDIT_QUOTA = <num> ]
                                                    [ FREQUENCY = { MONTHLY | DAILY | WEEKLY | YEARLY | NEVER } ]
                                                    [ START_TIMESTAMP = { <timestamp> | IMMEDIATELY } ]
                                                    [ END_TIMESTAMP = <timestamp> ]
                                                    [ NOTIFY_USERS = ( <user_name> [ , <user_name> , ... ] ) ] } ]
                                            [ TRIGGERS triggerDefinition [ triggerDefinition ... ] ]

-- Example 24387
triggerDefinition ::=
   ON <threshold> PERCENT DO { SUSPEND | SUSPEND_IMMEDIATE | NOTIFY }

-- Example 24388
ALTER RESOURCE MONITOR limiter
  SET CREDIT_QUOTA=2000
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Example 24389
ALTER RESOURCE MONITOR limiter
  SET CREDIT_QUOTA = 2000
      NOTIFY_USERS = (JDOE, "Jane Smith", "John Doe")
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND_IMMEDIATE

-- Example 24390
select system$get_snowflake_platform_info();

-- Example 24391
{
  "snowflake-vpc-id": ["vpc-12345678"],
  "snowflake-egress-vpc-ids": [
    ...
   {
     "id": "vpc-12345678",
     "expires": "2025-03-01T00:00:00",
     "purpose": "generic"
   },
   ...
   ]
 }

-- Example 24392
===========================================================================
================ Tracking Worksheet: AWS Management Console ===============
===========================================================================

****** Step 1: Information about the Lambda Function (remote service) *****

Your AWS Account ID: ______________________________________________________

Lambda Function Name: _____________________________________________________


******** Step 2: Information about the API Gateway (proxy Service) ********

New IAM Role Name: ________________________________________________________

New IAM Role ARN: _________________________________________________________

Snowflake VPC ID (optional): ______________________________________________

New API Name: _____________________________________________________________

API Gateway Resource Name: ________________________________________________

Resource Invocation URL: __________________________________________________

Method Request ARN: _______________________________________________________


*** Step 3: Information about the API Integration and External Function ***

API Integration Name: _____________________________________________________

API_AWS_IAM_USER_ARN: _____________________________________________________

API_AWS_EXTERNAL_ID: ______________________________________________________

External Function Name: ___________________________________________________

-- Example 24393
===========================================================================
================== Tracking Worksheet: CloudFormation Template ============
===========================================================================

New IAM Role Name: ________________________________________________________

New IAM Role ARN: _________________________________________________________

Resource Invocation URL: __________________________________________________

API_AWS_IAM_USER_ARN: _____________________________________________________

API_AWS_EXTERNAL_ID: ______________________________________________________

-- Example 24394
USE DATABASE <database_name>;
USE SCHEMA <schema_name>;

-- Example 24395
GRANT USAGE ON FUNCTION <external_function_name>(<parameter_data_type>) TO <role_name>;

-- Example 24396
GRANT USAGE ON FUNCTION echo(INTEGER, VARCHAR) TO analyst_role;

-- Example 24397
SELECT echo(42, 'Adams');

-- Example 24398
[0, 42, "Adams"]

-- Example 24399
SQL execution error: Error assuming AWS_ROLE. Please verify the role and externalId are
configured correctly in your AWS policy.

-- Example 24400
Request failed for external function <function_name>.
Error: 403 '{"Message":"User: <ARN> is not authorized to perform: execute-api:Invoke on resource: <MethodRequestARN>"}'

-- Example 24401
Request failed for external function <function_name>.
Error: 403 '{"Message":"User: anonymous is not authorized to perform: execute-api:Invoke on resource: <MethodRequestARN>"}'

-- Example 24402
Error parsing JSON response for external function ... Error: top-level JSON object must contain "data" JSON array element

-- Example 24403
{
"statusCode": <http_status_code>,
"body":
        {
            "data":
                  [
                      [ 0, <value> ],
                      [ 1, <value> ]
                      ...
                  ]
        }
}

-- Example 24404
{
  "body":
    "{ \"data\": [ [ 0, 43, \"page\" ], [ 1, 42, \"life, the universe, and everything\" ] ] }"
}

-- Example 24405
{
  "statusCode": 200,
  "body": "{\"data\": [[0, [\"Echoing inputs:\", 43, \"page\"]], [1, [\"Echoing inputs:\", 42, \"life, the universe, and everything\"]]]}"
}

-- Example 24406
CREATE OR REPLACE HYBRID TABLE application_log (
  id NUMBER PRIMARY KEY AUTOINCREMENT,
  col1 VARCHAR(20),
  col2 VARCHAR(20) NOT NULL
  );

INSERT INTO application_log (col1, col2) VALUES ('A1', 'B1');
INSERT INTO application_log (col1, col2) VALUES ('A2', 'B2');
INSERT INTO application_log (col1, col2) VALUES ('A3', 'B3');
INSERT INTO application_log (col1, col2) VALUES ('A4', 'B4');

SELECT * FROM application_log;

UPDATE application_log SET col2 = 'B3-updated' WHERE id = 3;

DELETE FROM application_log WHERE id = 4;

SELECT * FROM application_log;

-- Example 24407
CREATE OR REPLACE HYBRID TABLE dept_employees (
  employee_id INT PRIMARY KEY,
  department_id VARCHAR(200)
  )
AS SELECT employee_id, department_id FROM company_employees;

-- Example 24408
CREATE OR REPLACE HYBRID TABLE target_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0) UNIQUE,
    col3 NUMBER(38,0),
    INDEX index_col3 (col3)
    )
  AS SELECT col1, col2, col3 FROM source_table;

-- Example 24409
CREATE OR REPLACE HYBRID TABLE ref_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0) UNIQUE
);

CREATE OR REPLACE HYBRID TABLE fk_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0),
    col3 NUMBER(38,0),
    FOREIGN KEY (col2) REFERENCES ref_hybrid_table(col2),
    INDEX index_col3 (col3)
);

-- Example 24410
The value is too long for index "IDX_HT100_COLS".

-- Example 24411
CREATE OR REPLACE HYBRID TABLE icecream_orders (
  id NUMBER PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1 ORDER,
  store_id NUMBER NOT NULL,
  flavor VARCHAR(20) NOT NULL,
  order_ts TIMESTAMP_NTZ,
  num_scoops NUMERIC,
  INDEX idx_icecream_order_store (store_id, order_ts),
  INDEX idx_icecream_timestamp (order_ts)
  );

-- Generate sample data for testing

INSERT INTO icecream_orders (store_id, flavor, order_ts, num_scoops)
  SELECT
    UNIFORM(1, 10, RANDOM()),
    ARRAY_CONSTRUCT('CHOCOLATE', 'VANILLA', 'STRAWBERRY', 'LEMON')[UNIFORM(0, 3, RANDOM())],
    DATEADD(SECOND, UNIFORM(0, 86400, RANDOM()), DATEADD(DAY, UNIFORM(-90, 0, RANDOM()), CURRENT_DATE())),
    UNIFORM(1, 3, RANDOM())
  FROM TABLE(GENERATOR(ROWCOUNT => 10000))
  ;

-- Use idx_icecream_order_store (first column)

  SELECT *
    FROM icecream_orders
    WHERE store_id = 5;

-- Use idx_icecream_order_store (both columns)

  SELECT *
    FROM icecream_orders
    WHERE store_id IN (1,2,3) AND order_ts > DATEADD(DAY, -7, CURRENT_DATE());

-- Use idx_icecream_timestamp

  SELECT *
    FROM icecream_orders
    WHERE order_ts BETWEEN DATEADD(DAY, -2, CURRENT_DATE()) AND DATEADD(DAY, -2, CURRENT_DATE());

-- Example 24412
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.AGGREGATE_QUERY_HISTORY
  WHERE warehouse_name = 'HYBRID_TABLES_WAREHOUSE'
  AND query_type = 'SELECT'
  AND interval_start_time >= DATEADD(hour, -24, CURRENT_TIMESTAMP());

-- Example 24413
CREATE OR REPLACE HYBRID TABLE sensor_data_device1 (
  timestamp TIMESTAMP_NTZ PRIMARY KEY,
  device_id VARCHAR(10),
  temperature DECIMAL(6,4),
  vibration DECIMAL(6,4),
  motor_rpm INT,
  INDEX device_idx(device_id)
 );

-- Example 24414
SELECT * FROM sensor_data_device1 WHERE timestamp='2024-03-01 13:45:56.000';

-- Example 24415
SELECT COUNT(*) FROM sensor_data_device1 WHERE device_id='DEVICE2';

-- Example 24416
UPDATE sensor_data_device2 SET device_id='DEVICE3' WHERE timestamp = '2024-04-02 00:00:05.000';

-- Example 24417
SELECT device_id, AVG(temperature)
  FROM sensor_data_device2
  WHERE temperature>33
  GROUP BY device_id;

-- Example 24418
SELECT
    interval_start_time
    , SUM(calls) as execution_count
    , SUM(calls) / 60 as queries_per_second
    , COUNT(DISTINCT session_id) as unique_sessions
    , COUNT(user_name) as unique_users
FROM snowflake.account_usage.aggregate_query_history
WHERE warehouse_name = '<MY_WAREHOUSE>'
  AND interval_start_time > $START_DATE
  AND interval_start_time < $END_DATE
GROUP BY ALL;

-- Example 24419
WITH time_issues AS
(
    SELECT
        interval_start_time
        , SUM(transaction_blocked_time:"SUM") as transaction_blocked_time
        , SUM(queued_provisioning_time:"SUM") as queued_provisioning_time
        , SUM(queued_repair_time:"SUM") as queued_repair_time
        , SUM(queued_overload_time:"SUM") as queued_overload_time
        , SUM(hybrid_table_requests_throttled_count) as hybrid_table_requests_throttled_count
    FROM snowflake.account_usage.aggregate_query_history
    WHERE WAREHOUSE_NAME = '<MY_WAREHOUSE>'
      AND interval_start_time > $START_DATE
      AND interval_start_time < $END_DATE
    GROUP BY ALL
),
errors AS
(
    SELECT
        interval_start_time
        , SUM(value:"count") as error_count
    FROM
    (
        SELECT
            a.interval_start_time
            ,e.*
        FROM
            snowflake.account_usage.aggregate_query_history a,
            TABLE(flatten(input => errors)) e
        WHERE interval_start_time > $START_DATE
          AND interval_start_time < $END_DATE
  )
  GROUP BY ALL
)
    SELECT
        ts.interval_start_time
        , error_count
        , transaction_blocked_time
        , queued_provisioning_time
        , queued_repair_time
        , queued_overload_time
        , hybrid_table_requests_throttled_count
    FROM time_issues ts
    FULL JOIN errors e ON e.interval_start_time = ts.interval_start_time
;

-- Example 24420
SELECT
    query_parameterized_hash
    , any_value(query_text)
    , SUM(calls) as execution_count
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
          AND warehouse_name = '<MY_WAREHOUSE>'
          AND interval_start_time > '2024-02-01'
          AND interval_start_time < '2024-02-08'
GROUP BY
          query_parameterized_hash
ORDER BY execution_count DESC
;

-- Example 24421
SELECT
    query_parameterized_hash
    , any_value(query_text)
    , SUM(total_elapsed_time:"sum"::NUMBER) / SUM (calls) as avg_latency
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
          AND warehouse_name = '<MY_WAREHOUSE>'
          AND interval_start_time > '2024-02-01'
          AND interval_start_time < '2024-02-08'
GROUP BY
          query_parameterized_hash
ORDER BY avg_latency DESC
;

-- Example 24422
SELECT
    interval_start_time
    , total_elapsed_time:"avg"::number avg_elapsed_time
    , total_elapsed_time:"min"::number min_elapsed_time
    , total_elapsed_time:"p90"::number p90_elapsed_time
    , total_elapsed_time:"p99"::number p99_elapsed_time
    , total_elapsed_time:"max"::number max_elapsed_time
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
          AND query_parameterized_hash = '<123456>'
          AND interval_start_time > '2024-02-01'
          AND interval_start_time < '2024-02-08'
ORDER BY interval_start_time DESC
;

-- Example 24423
CREATE [ OR REPLACE ] HYBRID TABLE [ IF NOT EXISTS ] <table_name>
  ( <col_name> <col_type>
    [
      {
        DEFAULT <expr>
        | { AUTOINCREMENT | IDENTITY }
          [
            {
              ( <start_num> , <step_num> )
              | START <num> INCREMENT <num>
            }
          ]
          [ { ORDER | NOORDER } ]
      }
    ]
    [ NOT NULL ]
    [ inlineConstraint ]
    [ COMMENT '<string_literal>' ]
    [ , <col_name> <col_type> [ ... ] ]
    [ , outoflineConstraint ]
    [ , outoflineIndex ]
    [ , ... ]
  )
  [ COMMENT = '<string_literal>' ]

-- Example 24424
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY | { [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ] } }
  [ <constraint_properties> ]

outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]
  [ COMMENT '<string_literal>' ]

outoflineIndex ::=
  INDEX <index_name> ( <col_name> [ , <col_name> , ... ] )
    [ INCLUDE ( <col_name> [ , <col_name> , ... ] ) ]

-- Example 24425
CREATE OR REPLACE HYBRID TABLE ht2pk (
  col1 INTEGER NOT NULL,
  col2 INTEGER NOT NULL,
  col3 VARCHAR,
  CONSTRAINT pkey_1 PRIMARY KEY (col1, col2)
  );

-- Example 24426
CREATE [ OR REPLACE ] HYBRID TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  AS <query>
  [ ... ]

-- Example 24427
CREATE [ OR REPLACE ] HYBRID TABLE <table_name> LIKE <source_hybrid_table>
  [ ... ]

-- Example 24428
CREATE HYBRID TABLE mytable (
  customer_id INT AUTOINCREMENT PRIMARY KEY,
  full_name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  extended_customer_info VARIANT,
  INDEX index_full_name (full_name)
);

-- Example 24429
+-------------------------------------+
| status                              |
|-------------------------------------|
| Table MYTABLE successfully created. |
+-------------------------------------+

