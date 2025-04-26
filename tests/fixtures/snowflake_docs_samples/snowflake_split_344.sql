-- Example 23026
SELECT start_time,
  end_time,
  task_id,
  task_name,
  credits_used,
  schema_id,
  schema_name,
  database_id,
  database_name
FROM snowflake.account_usage.serverless_task_history
ORDER BY start_time, task_id;

-- Example 23027
SELECT start_time, 
  end_time, 
  replication_group_name, 
  credits_used, 
  bytes_transferred
FROM snowflake.account_usage.replication_group_usage_history
WHERE start_time >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 23028
SELECT TO_DATE(start_time) AS date,
  database_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.database_replication_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 23029
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.database_replication_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23030
-- This Is Approximate Credit Consumption By Client Application
WITH
  client_hour_execution_cte AS (
    SELECT
      CASE
        WHEN client_application_id LIKE 'Go %' THEN 'Go'
        WHEN client_application_id LIKE 'Snowflake UI %' THEN 'Snowflake UI'
        WHEN client_application_id LIKE 'SnowSQL %' THEN 'SnowSQL'
        WHEN client_application_id LIKE 'JDBC %' THEN 'JDBC'
        WHEN client_application_id LIKE 'PythonConnector %' THEN 'Python'
        WHEN client_application_id LIKE 'ODBC %' THEN 'ODBC'
        ELSE 'NOT YET MAPPED: ' || CLIENT_APPLICATION_ID
      END AS client_application_name,
      warehouse_name,
      DATE_TRUNC('hour',start_time) AS start_time_hour,
      SUM(execution_time)  AS client_hour_execution_time
    FROM snowflake.account_usage.query_history qh
      JOIN snowflake.account_usage.sessions se
        ON se.session_id = qh.session_id
    WHERE warehouse_name IS NOT NULL
      AND execution_time > 0
      AND start_time > DATEADD(month,-1,CURRENT_TIMESTAMP())
    GROUP BY 1,2,3
  ),
  hour_execution_cte AS (
    SELECT start_time_hour,
      warehouse_name,
      SUM(client_hour_execution_time) AS hour_execution_time
    FROM client_hour_execution_cte
    GROUP BY 1,2
  ),
  approximate_credits AS (
    SELECT A.client_application_name,
      C.warehouse_name,
      (A.client_hour_execution_time/B.hour_execution_time)*C.credits_used AS approximate_credits_used
    FROM client_hour_execution_cte A
      JOIN hour_execution_cte B
        ON A.start_time_hour = B.start_time_hour and B.warehouse_name = A.warehouse_name
      JOIN snowflake.account_usage.warehouse_metering_history C
        ON C.warehouse_name = A.warehouse_name AND C.start_time = A.start_time_hour
  )

SELECT client_application_name,
  warehouse_name,
  SUM(approximate_credits_used) AS approximate_credits_used
FROM approximate_credits
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 23031
-- Credits used (all time = past year)

SELECT object_type,
  SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
GROUP BY 1;

-- Credits used (past N days/weeks/months)

SELECT object_type,
  SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.HYBRID_TABLE_USAGE_HISTORY
WHERE start_time >= DATEADD(day, -5, CURRENT_TIMESTAMP()) 
GROUP BY 1;

-- Example 23032
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;

-- Example 23033
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FINE_TUNING_USAGE_HISTORY;

-- Example 23034
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;

-- Example 23035
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY
  WHERE model_name = 'mistral-large';

-- Example 23036
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY
  WHERE query_id = 'query-id';

-- Example 23037
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_SEARCH_DAILY_USAGE_HISTORY;

-- Example 23038
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_SEARCH_SERVING_USAGE_HISTORY;

-- Example 23039
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.DOCUMENT_AI_USAGE_HISTORY;

-- Example 23040
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_DOCUMENT_PROCESSING_USAGE_HISTORY
  WHERE CREDITS_USED > 0.072

-- Example 23041
ALTER SESSION SET TIMEZONE = UTC;

-- Example 23042
SELECT
    usage_date,
    credits_used_cloud_services,
    credits_adjustment_cloud_services,
    credits_used_cloud_services + credits_adjustment_cloud_services AS billed_cloud_services
FROM snowflake.account_usage.metering_daily_history
WHERE usage_date >= DATEADD(month,-1,CURRENT_TIMESTAMP())
    AND credits_used_cloud_services > 0
ORDER BY 4 DESC;

-- Example 23043
SELECT
    usage_date,
    credits_used_cloud_services,
    credits_adjustment_cloud_services,
    credits_used_cloud_services + credits_adjustment_cloud_services AS billed_cloud_services
FROM snowflake.organization_usage.metering_daily_history
WHERE usage_date >= DATEADD(month,-1,CURRENT_TIMESTAMP())
    AND credits_used_cloud_services > 0
ORDER BY 4 DESC;

-- Example 23044
SELECT query_text, completed_time
FROM snowflake.account_usage.task_history
ORDER BY completed_time DESC
LIMIT 10;

-- Example 23045
SELECT query_text, completed_time
FROM snowflake.account_usage.task_history
WHERE completed_time > DATEADD(hours, -1, CURRENT_TIMESTAMP());

-- Example 23046
SOUNDEX( <varchar_expr> )

-- Example 23047
SELECT SOUNDEX('I love rock and roll music.'),
       SOUNDEX('I love rocks and gemstones.'),
       SOUNDEX('I leave a rock wherever I go.');
+----------------------------------------+--------------------------+------------------------------------------+
| SOUNDEX('I LOVE ROCK AND ROLL MUSIC.') | SOUNDEX('I LOVE ROCKS.') | SOUNDEX('I LEAVE A ROCK WHEREVER I GO.') |
|----------------------------------------+--------------------------+------------------------------------------|
| I416                                   | I416                     | I416                                     |
+----------------------------------------+--------------------------+------------------------------------------+

-- Example 23048
SELECT SOUNDEX('Marks'), SOUNDEX('Marx');
+------------------+-----------------+
| SOUNDEX('MARKS') | SOUNDEX('MARX') |
|------------------+-----------------|
| M620             | M620            |
+------------------+-----------------+

-- Example 23049
CREATE TABLE sounding_board (v VARCHAR);
CREATE TABLE sounding_bored (v VARCHAR);
INSERT INTO sounding_board (v) VALUES ('Marsha');
INSERT INTO sounding_bored (v) VALUES ('Marcia');

-- Example 23050
SELECT * 
    FROM sounding_board AS board, sounding_bored AS bored 
    WHERE bored.v = board.v;
+---+---+
| V | V |
|---+---|
+---+---+

-- Example 23051
SELECT * 
    FROM sounding_board AS board, sounding_bored AS bored 
    WHERE SOUNDEX(bored.v) = SOUNDEX(board.v);
+--------+--------+
| V      | V      |
|--------+--------|
| Marsha | Marcia |
+--------+--------+

-- Example 23052
SUBSTR( <base_expr>, <start_expr> [ , <length_expr> ] )

SUBSTRING( <base_expr>, <start_expr> [ , <length_expr> ] )

-- Example 23053
SELECT SUBSTR('testing 1 2 3', 9, 3);

-- Example 23054
+-------------------------------+
| SUBSTR('TESTING 1 2 3', 9, 3) |
|-------------------------------|
| 1 2                           |
+-------------------------------+

-- Example 23055
CREATE OR REPLACE TABLE test_substr (
    base_value VARCHAR,
    start_value INT,
    length_value INT)
  AS SELECT
    column1,
    column2,
    column3
  FROM
    VALUES
      ('mystring', -1, 3),
      ('mystring', -3, 3),
      ('mystring', -3, 7),
      ('mystring', -5, 3),
      ('mystring', -7, 3),
      ('mystring', 0, 3),
      ('mystring', 0, 7),
      ('mystring', 1, 3),
      ('mystring', 1, 7),
      ('mystring', 3, 3),
      ('mystring', 3, 7),
      ('mystring', 5, 3),
      ('mystring', 5, 7),
      ('mystring', 7, 3),
      ('mystring', NULL, 3),
      ('mystring', 3, NULL);

SELECT base_value,
       start_value,
       length_value,
       SUBSTR(base_value, start_value, length_value) AS substring
  FROM test_substr;

-- Example 23056
+------------+-------------+--------------+-----------+
| BASE_VALUE | START_VALUE | LENGTH_VALUE | SUBSTRING |
|------------+-------------+--------------+-----------|
| mystring   |          -1 |            3 | g         |
| mystring   |          -3 |            3 | ing       |
| mystring   |          -3 |            7 | ing       |
| mystring   |          -5 |            3 | tri       |
| mystring   |          -7 |            3 | yst       |
| mystring   |           0 |            3 | mys       |
| mystring   |           0 |            7 | mystrin   |
| mystring   |           1 |            3 | mys       |
| mystring   |           1 |            7 | mystrin   |
| mystring   |           3 |            3 | str       |
| mystring   |           3 |            7 | string    |
| mystring   |           5 |            3 | rin       |
| mystring   |           5 |            7 | ring      |
| mystring   |           7 |            3 | ng        |
| mystring   |        NULL |            3 | NULL      |
| mystring   |           3 |         NULL | NULL      |
+------------+-------------+--------------+-----------+

-- Example 23057
CREATE OR REPLACE TABLE customer_contact_example (
    cust_id INT,
    cust_email VARCHAR,
    cust_phone VARCHAR,
    activation_date VARCHAR)
  AS SELECT
    column1,
    column2,
    column3,
    column4
  FROM
    VALUES
      (1, 'some_text@example.com', '800-555-0100', '20210320'),
      (2, 'some_other_text@example.org', '800-555-0101', '20240509'),
      (3, 'some_different_text@example.net', '800-555-0102', '20191017');

SELECT * from customer_contact_example;

-- Example 23058
+---------+---------------------------------+--------------+-----------------+
| CUST_ID | CUST_EMAIL                      | CUST_PHONE   | ACTIVATION_DATE |
|---------+---------------------------------+--------------+-----------------|
|       1 | some_text@example.com           | 800-555-0100 | 20210320        |
|       2 | some_other_text@example.org     | 800-555-0101 | 20240509        |
|       3 | some_different_text@example.net | 800-555-0102 | 20191017        |
+---------+---------------------------------+--------------+-----------------+

-- Example 23059
SELECT cust_id,
       cust_email,
       SUBSTR(cust_email, POSITION('@' IN cust_email) + 1) AS domain
  FROM customer_contact_example;

-- Example 23060
+---------+---------------------------------+-------------+
| CUST_ID | CUST_EMAIL                      | DOMAIN      |
|---------+---------------------------------+-------------|
|       1 | some_text@example.com           | example.com |
|       2 | some_other_text@example.org     | example.org |
|       3 | some_different_text@example.net | example.net |
+---------+---------------------------------+-------------+

-- Example 23061
SELECT cust_id,
       cust_phone,
       SUBSTR(cust_phone, 1, 3) AS area_code
  FROM customer_contact_example;

-- Example 23062
+---------+--------------+-----------+
| CUST_ID | CUST_PHONE   | AREA_CODE |
|---------+--------------+-----------|
|       1 | 800-555-0100 | 800       |
|       2 | 800-555-0101 | 800       |
|       3 | 800-555-0102 | 800       |
+---------+--------------+-----------+

-- Example 23063
SELECT cust_id,
       cust_phone,
       SUBSTR(cust_phone, 5) AS phone_without_area_code
  FROM customer_contact_example;

-- Example 23064
+---------+--------------+-------------------------+
| CUST_ID | CUST_PHONE   | PHONE_WITHOUT_AREA_CODE |
|---------+--------------+-------------------------|
|       1 | 800-555-0100 | 555-0100                |
|       2 | 800-555-0101 | 555-0101                |
|       3 | 800-555-0102 | 555-0102                |
+---------+--------------+-------------------------+

-- Example 23065
SELECT cust_id,
       activation_date,
       SUBSTR(activation_date, 1, 4) AS year,
       SUBSTR(activation_date, 5, 2) AS month,
       SUBSTR(activation_date, 7, 2) AS day
  FROM customer_contact_example;

-- Example 23066
+---------+-----------------+------+-------+-----+
| CUST_ID | ACTIVATION_DATE | YEAR | MONTH | DAY |
|---------+-----------------+------+-------+-----|
|       1 | 20210320        | 2021 | 03    | 20  |
|       2 | 20240509        | 2024 | 05    | 09  |
|       3 | 20191017        | 2019 | 10    | 17  |
+---------+-----------------+------+-------+-----+

-- Example 23067
ST_CONTAINS( <geography_expression_1> , <geography_expression_2> )

ST_CONTAINS( <geometry_expression_1> , <geometry_expression_2> )

-- Example 23068
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 23069
SELECT ST_CONTAINS(g1, g2) 
    FROM geospatial_table_01;
+---------------------+
| ST_CONTAINS(G1, G2) |
|---------------------|
| True                |
+---------------------+

-- Example 23070
SELECT ST_CONTAINS(poly, poly_inside),
      ST_CONTAINS(poly, poly),
      ST_CONTAINS(poly, line_on_boundary),
      ST_CONTAINS(poly, line_inside)
  FROM (SELECT
    TO_GEOMETRY('POLYGON((-2 0, 0 2, 2 0, -2 0))') AS poly,
    TO_GEOMETRY('POLYGON((-1 0, 0 1, 1 0, -1 0))') AS poly_inside,
    TO_GEOMETRY('LINESTRING(-1 1, 0 2, 1 1)') AS line_on_boundary,
    TO_GEOMETRY('LINESTRING(-2 0, 0 0, 0 1)') AS line_inside);

-- Example 23071
+--------------------------------+------------------------+------------------------------------+-------------------------------+
| ST_CONTAINS(POLY, POLY_INSIDE) | ST_CONTAINS(POLY,POLY) | ST_CONTAINS(POLY,LINE_ON_BOUNDARY) | ST_CONTAINS(POLY,LINE_INSIDE) |
|--------------------------------+------------------------+------------------------------------+-------------------------------|
| True                           | True                   | False                              | True                          |
+--------------------------------+------------------------+------------------------------------+-------------------------------+

-- Example 23072
USE ROLE GLOBALORGADMIN;

-- Example 23073
USE ROLE ORGADMIN;

-- Example 23074
USE ROLE ORGADMIN;

ALTER ACCOUNT my_account1 SET IS_ORG_ADMIN = TRUE;

-- Example 23075
USE ROLE GLOBALORGADMIN;

-- Example 23076
ALTER ACCOUNT <account_name> SET IS_ORG_ADMIN = FALSE;

-- Example 23077
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket>",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "<prefix>/*"
                    ]
                }
            }
        }
    ]
}

-- Example 23078
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 23079
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 23080
DESC INTEGRATION <integration_name>;

-- Example 23081
DESC INTEGRATION s3_int;

-- Example 23082
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+
| property                  | property_type | property_value                                                                 | property_default |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------|
| ENABLED                   | Boolean       | true                                                                           | false            |
| STORAGE_ALLOWED_LOCATIONS | List          | s3://mybucket1/mypath1/,s3://mybucket2/mypath2/                                | []               |
| STORAGE_BLOCKED_LOCATIONS | List          | s3://mybucket1/mypath1/sensitivedata/,s3://mybucket2/mypath2/sensitivedata/    | []               |
| STORAGE_AWS_IAM_USER_ARN  | String        | arn:aws:iam::123456789001:user/abc1-b-self1234                                 |                  |
| STORAGE_AWS_ROLE_ARN      | String        | arn:aws:iam::001234567890:role/myrole                                          |                  |
| STORAGE_AWS_EXTERNAL_ID   | String        | MYACCOUNT_SFCRole=2_a123456/s0aBCDEfGHIJklmNoPq=                               |                  |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+

-- Example 23083
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake_external_id>"
        }
      }
    }
  ]
}

-- Example 23084
USE SCHEMA snowpipe_db.public;

CREATE STAGE mystage
  URL = 's3://mybucket/load/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 23085
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = TRUE
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 23086
-- Create a role to contain the Snowpipe privileges
USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE snowpipe_role;

-- Grant the required privileges on the database objects
GRANT USAGE ON DATABASE snowpipe_db TO ROLE snowpipe_role;

GRANT USAGE ON SCHEMA snowpipe_db.public TO ROLE snowpipe_role;

GRANT INSERT, SELECT ON snowpipe_db.public.mytable TO ROLE snowpipe_role;

GRANT USAGE ON STAGE snowpipe_db.public.mystage TO ROLE snowpipe_role;

-- Pause the pipe for OWNERSHIP transfer
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = TRUE;

-- Grant the OWNERSHIP privilege on the pipe object
GRANT OWNERSHIP ON PIPE snowpipe_db.public.mypipe TO ROLE snowpipe_role;

-- Grant the role to a user
GRANT ROLE snowpipe_role TO USER jsmith;

-- Set the role as the default role for the user
ALTER USER jsmith SET DEFAULT_ROLE = snowpipe_role;

-- Resume the pipe
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = FALSE;

-- Example 23087
SHOW PIPES;

-- Example 23088
select system$get_aws_sns_iam_policy('<sns_topic_arn>');

-- Example 23089
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 23090
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     }
   ]
 }

-- Example 23091
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     }
   ]
 }

-- Example 23092
{
    "Sid":"s3-event-notifier",
    "Effect":"Allow",
    "Principal":{
       "Service":"s3.amazonaws.com"
    },
    "Action":"SNS:Publish",
    "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
    "Condition":{
       "ArnLike":{
          "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
       }
    }
 }

