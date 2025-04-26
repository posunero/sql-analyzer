-- Example 23492
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23493
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23494
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --user <OAUTH_CLIENT_ID>:<OAUTH_CLIENT_SECRET> \
  --data-urlencode "username=<IdP_USER_USERNAME>" \
  --data-urlencode "password=<IdP_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=session:role:analyst" \
  <IdP_TOKEN_ENDPOINT>

-- Example 23495
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23496
"appRoles":[
    {
        "allowedMemberTypes": [ "Application" ],
        "description": "Account Administrator.",
        "displayName": "Account Admin",
        "id": "3ea51f40-2ad7-4e79-aa18-12c45156dc6a",
        "isEnabled": true,
        "lang": null,
        "origin": "Application",
        "value": "session:role:analyst"
    }
]

-- Example 23497
create security integration external_oauth_azure_1
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = '<AZURE_AD_JWS_KEY_ENDPOINT>'
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23498
create security integration external_oauth_azure_2
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = '<AZURE_AD_JWS_KEY_ENDPOINT>'
    external_oauth_audience_list = ('<SNOWFLAKE_APPLICATION_ID_URI>')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23499
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23500
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23501
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23502
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --data-urlencode "client_id=<OAUTH_CLIENT_ID>" \
  --data-urlencode "client_secret=<OAUTH_CLIENT_SECRET>" \
  --data-urlencode "username=<AZURE_AD_USER>" \
  --data-urlencode "password=<AZURE_AD_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=<AZURE_APP_URI+AZURE_APP_SCOPE>" \
  '<AZURE_AD_OAUTH_TOKEN_ENDPOINT>'

-- Example 23503
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23504
create security integration external_oauth_okta_2
    type = external_oauth
    enabled = true
    external_oauth_type = okta
    external_oauth_issuer = '<OKTA_ISSUER>'
    external_oauth_jws_keys_url = '<OKTA_JWS_KEY_ENDPOINT>'
    external_oauth_audience_list = ('<snowflake_account_url')
    external_oauth_token_user_mapping_claim = 'sub'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23505
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23506
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23507
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23508
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --user <OAUTH_CLIENT_ID>:<OAUTH_CLIENT_SECRET> \
  --data-urlencode "username=<OKTA_USER_USERNAME>" \
  --data-urlencode "password=<OKTA_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=session:role:analyst" \
  <OKTA_OAUTH_TOKEN_ENDPOINT>

-- Example 23509
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23510
create or replace security integration external_oauth_pf_1
    type = external_oauth
    enabled = true
    external_oauth_type = ping_federate
    external_oauth_rsa_public_key = '<BASE64_PUBLIC_KEY>'
    external_oauth_issuer = '<unique_id>'
    external_oauth_token_user_mapping_claim = 'username'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23511
create security integration external_oauth_pf_2
    type = external_oauth
    enabled=true
    external_oauth_type = ping_federate
    external_oauth_issuer = '<ISSUER>'
    external_oauth_rsa_public_key = '<BASE64_PUBLIC_KEY>'
    external_oauth_audience_list = ('<snowflake_account_url>')
    external_oauth_token_user_mapping_claim = 'username'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23512
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23513
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23514
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23515
curl -k 'https://10.211.55.4:9031/as/token.oauth2' \
  --data-urlencode 'client_id=<CLIENT_ID>&grant_type=password&username=<USERNAME>&password=<PASSWORD>&client_secret=<CLIENT_SECRET>&scope=session:role:analyst'

-- Example 23516
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23517
{
  "aud": "<audience_url>",
  "iat": 1576705500,
  "exp": 1576709100,
  "iss": "<issuer_url>",
  "scp": [
    "session:role:analyst"
  ]
}

-- Example 23518
create security integration external_oauth_custom
    type = external_oauth
    enabled = true
    external_oauth_type = custom
    external_oauth_issuer = '<authorization_server_url>'
    external_oauth_rsa_public_key = '<public_key_value>'
    external_oauth_audience_list = ('<audience_url_1>', '<audience_url_2>')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23519
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23520
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23521
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23522
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --user <OAUTH_CLIENT_ID>:<OAUTH_CLIENT_SECRET> \
  --data-urlencode "username=<IdP_USER_USERNAME>" \
  --data-urlencode "password=<IdP_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=session:role:analyst" \
  <IdP_TOKEN_ENDPOINT>

-- Example 23523
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23524
create security integration powerbi
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
    external_oauth_audience_list = ('https://analysis.windows.net/powerbi/connector/Snowflake', 'https://analysis.windows.net/powerbi/connector/snowflake')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name'

-- Example 23525
create security integration powerbi_mag
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
    external_oauth_audience_list = ('https://analysis.usgovcloudapi.net/powerbi/connector/Snowflake', 'https://analysis.usgovcloudapi.net/powerbi/connector/snowflake')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name'

-- Example 23526
create security integration powerbi
    type = external_oauth
    ...
    external_oauth_snowflake_user_mapping_attribute = 'email_address';

-- Example 23527
create security integration powerbi
  type = external_oauth
  enabled = true
  external_oauth_type = azure
  external_oauth_issuer = '<AZURE_AD_ISSUER>'
  external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
  external_oauth_audience_list = ('https://analysis.windows.net/powerbi/connector/Snowflake', 'https://analysis.windows.net/powerbi/connector/snowflake')
  external_oauth_token_user_mapping_claim = 'unique_name'
  external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23528
use role accountadmin;
select *
from table(information_schema.login_history(dateadd('hours',-1,current_timestamp()),current_timestamp()))
order by event_timestamp;

-- Example 23529
SYSTEM$GET_LOGIN_FAILURE_DETAILS('<uuid>')

-- Example 23530
Invalid  OAuth access token. [0ce9eb56-821d-4ca9-a774-04ae89a0cf5a]

-- Example 23531
SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('0ce9eb56-821d-4ca9-a774-04ae89a0cf5a'), 'errorCode');

-- Example 23532
{
   "Version": "2012-10-17",
   "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:GetObjectVersion",
               "s3:DeleteObject",
               "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>/*"
         },
         {
            "Effect": "Allow",
            "Action": [
               "s3:ListBucket",
               "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>",
            "Condition": {
               "StringLike": {
                     "s3:prefix": [
                        "*"
                     ]
               }
            }
         }
   ]
}

-- Example 23533
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://<my_bucket>/'
            STORAGE_AWS_ROLE_ARN = '<arn:aws:iam::123456789012:role/myrole>'
            STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
         )
      )
      ALLOW_WRITES = TRUE;

-- Example 23534
DESC EXTERNAL VOLUME iceberg_external_volume;

-- Example 23535
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
          "sts:ExternalId": "<iceberg_table_external_id>"
        }
      }
    }
  ]
}

-- Example 23536
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 23537
CREATE OR REPLACE EXTERNAL VOLUME ext_vol_s3_compat
  STORAGE_LOCATIONS = (
    (
      NAME = 'my_s3_compat_storage_location'
      STORAGE_PROVIDER = 'S3COMPAT'
      STORAGE_BASE_URL = 's3compat://mybucket/unload/mys3compatdata'
      CREDENTIALS = (
        AWS_KEY_ID = '1a2b3c...'
        AWS_SECRET_KEY = '4x5y6z...'
      )
      STORAGE_ENDPOINT = 'mystorage.com'
    )
  )
  ALLOW_WRITES = FALSE;

-- Example 23538
CREATE OR REPLACE CATALOG INTEGRATION my_iceberg_catalog_int
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = ICEBERG
  ENABLED = TRUE;

-- Example 23539
CREATE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME = 'ext_vol_s3_compat'
  CATALOG = 'my_iceberg_catalog_int'
  METADATA_FILE_PATH = 'path/to/metadata/v1.metadata.json';

-- Example 23540
ALTER EXTERNAL VOLUME ext_vol_s3_compat UPDATE
  STORAGE_LOCATION = 'my_s3_compat_storage_location'
  CREDENTIALS = (
    AWS_KEY_ID = '4d5e6f...'
    AWS_SECRET_KEY = '7g8h9i...'
  );

-- Example 23541
columns: {
  "email": {
    objectId: {
      "value": 1
    },
    "subOperationType": "ADD"
  }
}

-- Example 23542
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 23543
SELECT * FROM table1 WHERE table1.name = 'AIHUA'

-- Example 23544
SET (START_DATE, END_DATE) = ('2023-11-01', '2023-11-08');

WITH time_issues AS
(
    SELECT
        interval_start_time
        , SUM(transaction_blocked_time:"sum") AS transaction_blocked_time
        , SUM(queued_provisioning_time:"sum") AS queued_provisioning_time
        , SUM(queued_repair_time:"sum") AS queued_repair_time
        , SUM(queued_overload_time:"sum") AS queued_overload_time
        , SUM(hybrid_table_requests_throttled_count) AS hybrid_table_requests_throttled_count
    FROM snowflake.account_usage.aggregate_query_history
    WHERE TRUE
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
            , e.*
        FROM
            snowflake.account_usage.aggregate_query_history a,
            TABLE(FLATTEN(input => errors)) e
        WHERE TRUE
            AND interval_start_time > $START_DATE
            AND interval_start_time < $END_DATE
    )
    GROUP BY ALL
)
SELECT
    time_issues.interval_start_time
    , error_count
    , transaction_blocked_time
    , queued_provisioning_time
    , queued_repair_time
    , queued_overload_time
    , hybrid_table_requests_throttled_count
FROM
    time_issues FULL JOIN errors ON errors.interval_start_time = time_issues.interval_start_time
;

-- Example 23545
SELECT
    interval_start_time
    , SUM(calls) AS execution_count
    , SUM(calls) / 60 AS queries_per_second
    , COUNT(DISTINCT session_id) AS unique_sessions
    , COUNT(user_name) AS unique_users
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
    AND warehouse_name = 'MY_WAREHOUSE'
    AND interval_start_time > '2023-11-01'
    AND interval_start_time < '2023-11-08'
GROUP BY
    interval_start_time
;

-- Example 23546
SELECT
    query_parameterized_hash
    , ANY_VALUE(query_text)
    , SUM(calls) AS execution_count
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
    AND warehouse_name = 'MY_WAREHOUSE'
    AND interval_start_time > '2023-11-01'
    AND interval_start_time < '2023-11-08'
GROUP BY
    query_parameterized_hash
ORDER BY execution_count DESC
;

-- Example 23547
SELECT
    query_parameterized_hash
    , any_value(query_text)
    , SUM(total_elapsed_time:"sum"::NUMBER) / SUM (calls) as avg_latency
FROM snowflake.account_usage.aggregate_query_history
WHERE TRUE
    AND warehouse_name = 'MY_WAREHOUSE'
    AND interval_start_time > '2023-07-01'
    AND interval_start_time < '2023-07-08'
GROUP BY
    query_parameterized_hash
ORDER BY avg_latency DESC
;

-- Example 23548
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
    AND interval_start_time > '2023-07-01'
    AND interval_start_time < '2023-07-08'
ORDER BY interval_start_time DESC
;

-- Example 23549
[
  {
    "credits": 0.005840921,
    "serviceType": "AUTO_CLUSTERING"
  },
  {
    "credits": 0.115940725,
    "serviceType": "SERVERLESS_TASK"
  },
  {
    "credits": 6.033448041,
    "serviceType": "SNOWPARK_CONTAINER_SERVICES"
  }
]

-- Example 23550
[
  {
    "bytes": 34043221,
    "storageType": "DATABASE"
  },
  {
    "bytes": 109779541,
    "storageType": "FAILSAFE"
  }
]

-- Example 23551
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.APPLICATION_DAILY_USAGE_HISTORY
  ORDER BY usage_date DESC;

-- Example 23552
SELECT * FROM snowflake.account_usage.BLOCK_STORAGE_HISTORY

-- Example 23553
+-------------------------------+---------------+-----------------------+----------------+
| USAGE_DATE                    | STORAGE_TYPE  | COMPUTE_POOL_NAME     |      BYTES     |
|-------------------------------+---------------+-----------------------+----------------|
| 2024-02-01 00:00:00.000 -0700 | BLOCK_STORAGE | POOL_1                | 2500000000     |
| 2024-02-01 00:00:00.000 -0700 | BLOCK_STORAGE | POOL_2                | 5000000000     |
| 2024-02-01 00:00:00.000 -0700 | SNAPSHOT      | NULL                  | 20000000000    |
+-------------------------------+---------------+-----------------------+----------------+

-- Example 23554
SELECT NAME, DATABASE_NAME, SCHEMA_NAME, CLASS_NAME
  FROM SNOWFLAKE.ACCOUNT_USAGE.CLASS_INSTANCES
  WHERE CLASS_NAME = 'ANOMALY_DETECTION';

-- Example 23555
SELECT a.TABLE_NAME,
       b.NAME AS instance_name,
       b.CLASS_NAME
  FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES a
  JOIN SNOWFLAKE.ACCOUNT_USAGE.CLASS_INSTANCES b
  ON a.INSTANCE_ID = b.ID
  WHERE b.DELETED IS NULL;

-- Example 23556
SELECT name, database_name, schema_name
  FROM SNOWFLAKE.ACCOUNT_USAGE.CLASSES;

-- Example 23557
ALTER SESSION SET TIMEZONE = UTC;

-- Example 23558
SELECT
    data_timestamp,
    database_name,
    schema_name,
    name,
    state,
    state_message,
    query_id
  FROM snowflake.account_usage.dynamic_table_refresh_history
  WHERE state = 'FAILED' AND data_timestamp >= dateadd(WEEK, -1, current_date())
  ORDER BY data_timestamp DESC
  LIMIT 10;

