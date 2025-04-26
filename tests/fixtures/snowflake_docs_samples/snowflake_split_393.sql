-- Example 26306
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 26307
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 26308
DESC INTEGRATION <integration_name>;

-- Example 26309
DESC INTEGRATION s3_int;

-- Example 26310
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

-- Example 26311
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

-- Example 26312
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26313
directoryTable (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 26314
USE SCHEMA mydb.public;

-- Example 26315
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  );

-- Example 26316
DESC STAGE <stage_name>;

-- Example 26317
DESC STAGE mystage;

-- Example 26318
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26319
ALTER STAGE mystage REFRESH;

-- Example 26320
select system$get_aws_sns_iam_policy('<sns_topic_arn>');

-- Example 26321
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 26322
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

-- Example 26323
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

-- Example 26324
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

-- Example 26325
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
     },
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
   ]
 }

-- Example 26326
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26327
directoryTable (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ AWS_SNS_TOPIC = '<sns_topic_arn>' ] ) ]

-- Example 26328
USE SCHEMA mydb.public;

-- Example 26329
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket'
  );

-- Example 26330
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26331
ALTER STAGE mystage REFRESH;

-- Example 26332
CREATE DATABASE database1;
CREATE SCHEMA database1.sch;
CREATE TABLE database1.sch.table1 (id INT);
CREATE VIEW database1.sch.view1 AS SELECT * FROM database1.sch.table1;

-- Example 26333
CREATE DATABASE database2;
CREATE SCHEMA database2.sch;
CREATE TABLE database2.sch.table2 (id INT);

-- Example 26334
CREATE DATABASE database3;
CREATE SCHEMA database3.sch;
CREATE TABLE database3.sch.table3 (id INT);

-- Example 26335
CREATE SECURE VIEW database3.sch.view3 AS
  SELECT view1.id AS View1Id,
         table2.id AS table2id,
         table3.id AS table3id
  FROM database1.sch.view1 view1,
       database2.sch.table2 table2,
       database3.sch.table3 table3;

-- Example 26336
CREATE SHARE share1;
GRANT USAGE ON DATABASE database3 TO SHARE share1;
GRANT USAGE ON SCHEMA database3.sch TO SHARE share1;

-- Example 26337
GRANT REFERENCE_USAGE ON DATABASE database1 TO SHARE share1;
GRANT REFERENCE_USAGE ON DATABASE database2 TO SHARE share1;

GRANT SELECT ON VIEW database3.sch.view3 TO SHARE share1;

-- Example 26338
CREATE DATABASE customer1_db;
CREATE SCHEMA customer1_db.sch;
CREATE TABLE customer1_db.sch.table1 (id INT);
CREATE VIEW customer1_db.sch.view1 AS SELECT * FROM customer1_db.sch.table1;

-- Example 26339
CREATE DATABASE customer2_db;
CREATE SCHEMA customer2_db.sch;
CREATE TABLE customer2_db.sch.table2 (id INT);

-- Example 26340
CREATE DATABASE new_db;
CREATE SCHEMA new_db.sch;

-- Example 26341
CREATE SECURE VIEW new_db.sch.view3 AS
  SELECT view1.id AS view1Id,
         table2.id AS table2ID
  FROM customer1_db.sch.view1 view1,
       customer2_db.sch.table2 table2;

-- Example 26342
CREATE SHARE share1;

GRANT USAGE ON DATABASE new_db TO SHARE share1;
GRANT USAGE ON SCHEMA new_db.sch TO SHARE share1;

-- Example 26343
GRANT REFERENCE_USAGE ON DATABASE customer1_db TO SHARE share1;
GRANT REFERENCE_USAGE ON DATABASE customer2_db TO SHARE share1;

GRANT SELECT ON VIEW new_db.sch.view3 TO SHARE share1;

-- Example 26344
SELECT TO_DATE(start_time) AS date
  ,warehouse_name
  ,SUM(avg_running) AS sum_running
  ,SUM(avg_queued_load) AS sum_queued
FROM snowflake.account_usage.warehouse_load_history
WHERE TO_DATE(start_time) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
HAVING SUM(avg_queued_load) > 0;

-- Example 26345
SELECT query_id, SUBSTR(query_text, 1, 50) partial_query_text, user_name, warehouse_name,
  bytes_spilled_to_local_storage, bytes_spilled_to_remote_storage
FROM  snowflake.account_usage.query_history
WHERE (bytes_spilled_to_local_storage > 0
  OR  bytes_spilled_to_remote_storage > 0 )
  AND start_time::date > dateadd('days', -45, current_date)
ORDER BY bytes_spilled_to_remote_storage, bytes_spilled_to_local_storage DESC
LIMIT 10;

-- Example 26346
SELECT TO_DATE(start_time) AS date,
  warehouse_name,
  SUM(avg_running) AS sum_running,
  SUM(avg_queued_load) AS sum_queued
FROM snowflake.account_usage.warehouse_load_history
WHERE TO_DATE(start_time) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
HAVING SUM(avg_queued_load) >0;

-- Example 26347
ALTER WAREHOUSE my_wh SET WAREHOUSE_SIZE = large;

-- Example 26348
SELECT PARSE_JSON(system$estimate_query_acceleration('8cd54bf0-1651-5b1c-ac9c-6a9582ebd20f'));

-- Example 26349
SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY eligible_query_acceleration_time DESC;

-- Example 26350
SELECT warehouse_name, SUM(eligible_query_acceleration_time) AS total_eligible_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY total_eligible_time DESC;

-- Example 26351
SELECT warehouse_name, COUNT(query_id) AS num_eligible_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

-- Example 26352
ALTER WAREHOUSE my_wh SET
  ENABLE_QUERY_ACCELERATION = true
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = 0;

-- Example 26353
ALTER WAREHOUSE my_wh SET MAX_CONCURRENCY_LEVEL = 4;

-- Example 26354
SELECT query_id,
  ROW_NUMBER() OVER(ORDER BY partitions_scanned DESC) AS query_id_int,
  query_text,
  total_elapsed_time/1000 AS query_execution_time_seconds,
  partitions_scanned,
  partitions_total,
FROM snowflake.account_usage.query_history Q
WHERE warehouse_name = 'my_warehouse' AND TO_DATE(Q.start_time) > DATEADD(day,-1,TO_DATE(CURRENT_TIMESTAMP()))
  AND total_elapsed_time > 0 --only get queries that actually used compute
  AND error_code IS NULL
  AND partitions_scanned IS NOT NULL
ORDER BY total_elapsed_time desc
LIMIT 50;

-- Example 26355
SELECT
  CASE
    WHEN Q.total_elapsed_time <= 60000 THEN 'Less than 60 seconds'
    WHEN Q.total_elapsed_time <= 300000 THEN '60 seconds to 5 minutes'
    WHEN Q.total_elapsed_time <= 1800000 THEN '5 minutes to 30 minutes'
    ELSE 'more than 30 minutes'
  END AS BUCKETS,
  COUNT(query_id) AS number_of_queries
FROM snowflake.account_usage.query_history Q
WHERE  TO_DATE(Q.START_TIME) >  DATEADD(month,-1,TO_DATE(CURRENT_TIMESTAMP()))
  AND total_elapsed_time > 0
  AND warehouse_name = 'my_warehouse'
GROUP BY 1;

-- Example 26356
SELECT
    query_hash,
    COUNT(*),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE warehouse_name = 'MY_WAREHOUSE'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 7
  GROUP BY query_hash
  ORDER BY SUM(total_elapsed_time) DESC
  LIMIT 100;

-- Example 26357
SELECT
    DATE_TRUNC('day', start_time),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_parameterized_hash = 'cbd58379a88c37ed6cc0ecfebb053b03'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 30
  GROUP BY DATE_TRUNC('day', start_time);

-- Example 26358
SELECT TO_DATE(start_time) AS date,
  warehouse_name,
  SUM(avg_running) AS sum_running,
  SUM(avg_queued_load) AS sum_queued
FROM snowflake.account_usage.warehouse_load_history
WHERE TO_DATE(start_time) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
HAVING SUM(avg_queued_load) >0;

-- Example 26359
SELECT DATEDIFF(seconds, query_start_time,completed_time) AS duration_seconds,*
FROM snowflake.account_usage.task_history
WHERE state = 'SUCCEEDED'
  AND query_start_time >= DATEADD (day, -1, CURRENT_TIMESTAMP())
ORDER BY duration_seconds DESC;

-- Example 26360
SET query_id = '<query_id>';

WITH query_hash_of_query AS (
  SELECT query_parameterized_hash
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE query_id = $query_id
  LIMIT 1
)
SELECT
  query_parameterized_hash,
  COUNT (*) AS query_count,
  SUM(credits_attributed_compute) AS recurrent_query_attributed_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
  AND start_time < CURRENT_DATE
  AND query_parameterized_hash = (SELECT query_parameterized_hash FROM query_hash_of_query)
GROUP BY ALL;

-- Example 26361
SELECT user_name, SUM(credits_attributed_compute) AS credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE user_name = CURRENT_USER()
    AND start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY user_name;

-- Example 26362
SET query_id = '<query_id>';

SELECT query_id,
       parent_query_id,
       root_query_id,
       direct_objects_accessed
  FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
  WHERE query_id = $query_id;

-- Example 26363
SET query_id = '<root_query_id>';

SELECT SUM(credits_attributed_compute) AS total_attributed_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE (root_query_id = $query_id OR query_id = $query_id);

-- Example 26364
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 26365
df = session.read.options({"infer_schema":True}).csv('@TASTYBYTE_STAGE/app_order.csv')

-- Example 26366
df = session.table("APP_ORDER")

-- Example 26367
df

-- Example 26368
import streamlit as st
import pandas as pd

-- Example 26369
species = ["setosa"] * 3 + ["versicolor"] * 3 + ["virginica"] * 3
measurements = ["sepal_length", "sepal_width", "petal_length"] * 3
values = [5.1, 3.5, 1.4, 6.2, 2.9, 4.3, 7.3, 3.0, 6.3]
df = pd.DataFrame({"species": species,"measurement": measurements,"value": values})
df

-- Example 26370
st.markdown("""# Interactive Filtering with Streamlit! :balloon:
            Values will automatically cascade down the notebook cells""")
value = st.slider("Move the slider to change the filter value 👇", df.value.min(), df.value.max(), df.value.mean(), step = 0.3 )

-- Example 26371
df[df["value"]>value].sort_values("value")

-- Example 26372
from snowflake.ml.registry import Registry
# Create a registry and log the model
native_registry = Registry(session=session, database_name=db, schema_name=schema)

# Let's first log the very first model we trained
model_ver = native_registry.log_model(
    model_name=model_name,
    version_name='V0',
    model=regressor,
    sample_input_data=X, # to provide the feature schema
)

# Add evaluation metric
model_ver.set_metric(metric_name="mean_abs_pct_err", value=mape)

# Add a description
model_ver.comment = "This is the first iteration of our Diamonds Price Prediction model. It is used for demo purposes."

# Show Models
native_registry.get_model(model_name).show_versions()

