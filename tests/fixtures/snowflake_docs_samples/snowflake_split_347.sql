-- Example 23226
[
  {
    "provider_service_name": "com.amazonaws.us-west-2.s3",
    "snowflake_endpoint_name": "vpce-123456789012abcdea",
    "endpoint_state": "CREATED",
    "host": "*.s3.us-west-2.amazonaws.com",
    "status": "Available"
  },
  ...
]

-- Example 23227
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 23228
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 23229
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = 'v1_0'
  PATCH = '2'
  UPGRADE_AFTER = '2025-04-06 11:00:00'

-- Example 23230
ALTER APPLICATION PACKAGE my_application_package SET DEFAULT RELEASE DIRECTIVE
  VERSION = v2
  PATCH = 0;

-- Example 23231
ALTER APPLICATION PACKAGE my_application_package
  SET RELEASE DIRECTIVE my_custom_release_directive
  ACCOUNTS = ( USER_ACCOUNT.snowflakecomputing.com )
  VERSION = v2
  PATCH = 0;

-- Example 23232
ALTER APPLICATION <name> UPGRADE

-- Example 23233
SELECT * FROM snowflake.data_sharing_usage.APPLICATION_STATE

-- Example 23234
select my_database.my_schema.my_external_function(col1) from table1;

-- Example 23235
select my_external_function_2(column_1, column_2)
    from table_1;

select col1
    from table_1
    where my_external_function_3(col2) < 0;

create view view1 (col1) as
    select my_external_function_5(col1)
        from table9;

-- Example 23236
select upper(zipcode_to_city_external_function(zipcode))
  from address_table;

-- Example 23237
CREATE VIEW my_shared_view AS SELECT my_external_function(x) ...;
CREATE SHARE things_to_share;
...
GRANT SELECT ON VIEW my_shared_view TO SHARE things_to_share;
...

-- Example 23238
https://api-id.execute-api.region.amazonaws.com/stage

-- Example 23239
USE ROLE ACCOUNTADMIN;

-- Example 23240
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Example 23241
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Example 23242
{
  "snowflake-project-id":["preprod-deployment1-a12b"],
  "snowflake-customer-directory-id":["A01bcd2ef"]
}

-- Example 23243
USE ROLE ACCOUNTADMIN;

-- Example 23244
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Example 23245
Unable retrieve endpoint status for one or more subnets. Status 'insufficient permissions' indicates lack of subnet read permissions ('Microsoft.Network/virtualNetworks/subnets/read').

-- Example 23246
CREATE OR REPLACE CATALOG INTEGRATION tabular_catalog_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'default'
  REST_CONFIG = (
    CATALOG_URI = 'https://api.tabular.io/ws'
    CATALOG_NAME = '<tabular_warehouse_name>'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_TOKEN_URI = 'https://api.tabular.io/ws/v1/oauth/tokens'
    OAUTH_CLIENT_ID = '<oauth_client_id>'
    OAUTH_CLIENT_SECRET = '<oauth_secret>'
    OAUTH_ALLOWED_SCOPES = ('catalog')
  )
  ENABLED = TRUE;

-- Example 23247
CREATE OR REPLACE CATALOG INTEGRATION unity_catalog_int_oauth
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'default'
  REST_CONFIG = (
    CATALOG_URI = 'https://my-api/api/2.1/unity-catalog/iceberg'
    CATALOG_NAME = '<catalog_name>'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_TOKEN_URI = 'https://my-api/oidc/v1/token'
    OAUTH_CLIENT_ID = '123AbC ...'
    OAUTH_CLIENT_SECRET = '1365910ab ...'
    OAUTH_ALLOWED_SCOPES = ('all-apis', 'sql')
  )
  ENABLED = TRUE;

-- Example 23248
CREATE OR REPLACE CATALOG INTEGRATION unity_catalog_int_pat
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://my-api/api/2.1/unity-catalog/iceberg'
    CATALOG_NAME= '<catalog_name>'
  )
  REST_AUTHENTICATION = (
    TYPE = BEARER
    BEARER_TOKEN = 'eyAbCD...eyDeF...'
  )
  ENABLED = TRUE;

-- Example 23249
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "execute-api:Invoke"
        ],
        "Resource": "arn:aws:execute-api:*:<aws_account_id>:*"
    }
  ]
}

-- Example 23250
SELECT SYSTEM$GET_SNOWFLAKE_PLATFORM_INFO();

-- Example 23251
{
  "snowflake-vpc-id": ["vpc-c1c234a5"],
  "snowflake-egress-vpc-ids": [
    ...
    {
      "id": "vpc-c1c234a5",
      "expires": "2025-03-01T00:00:00",
      "purpose": "generic"
    },
    ...
  ]
}

-- Example 23252
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": "<api_gateway_arn>",
      "Condition": {
        "StringNotEquals": {
          "aws:sourceVpc": "<snowflake_vpc_id>"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:sts::123456789XXX:assumed-role/<my_api_permissions_role_name>/snowflake"
      },
      "Action": "execute-api:Invoke",
      "Resource": "<api_gateway_arn>/*/*/*",
      "Condition": {
        "StringEquals": {
          "aws:sourceVpc": "<snowflake_vpc_id>"
        }
      }
    }
  ]
}

-- Example 23253
CREATE OR REPLACE CATALOG INTEGRATION my_rest_catalog_integration
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://asdlkfjwoalk-execute-api.us-west-2-amazonaws.com/MyApiStage'
    CATALOG_API_TYPE = AWS_API_GATEWAY
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789XXX:role/my_api_permissions_role'
    SIGV4_EXTERNAL_ID = 'my_iceberg_external_id'
  )
  ENABLED = TRUE;

-- Example 23254
CREATE OR REPLACE CATALOG INTEGRATION my_rest_catalog_integration
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://asdlkfjwoalk-execute-api.us-west-2-amazonaws.com/MyApiStage'
    CATALOG_API_TYPE = AWS_PRIVATE_API_GATEWAY
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789XXX:role/my_api_permissions_role'
    SIGV4_EXTERNAL_ID = 'my_iceberg_external_id'
  )
  ENABLED = TRUE;

-- Example 23255
DESCRIBE CATALOG INTEGRATION my_rest_catalog_integration;

-- Example 23256
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<api_aws_iam_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<api_aws_external_id>"
        }
      }
    }
  ]
}

-- Example 23257
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "AllowGlueCatalogTableAccess",
         "Effect": "Allow",
         "Action": [
           "glue:GetCatalog",
           "glue:GetDatabase",
           "glue:GetDatabases",
           "glue:GetTable",
           "glue:GetTables"
         ],
         "Resource": [
            "arn:aws:glue:*:<accountid>:table/*/*",
            "arn:aws:glue:*:<accountid>:catalog",
            "arn:aws:glue:*:<accountid>:database/<database-name>"
         ]
      }
   ]
}

-- Example 23258
CREATE CATALOG INTEGRATION glue_rest_catalog_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'rest_catalog_integration'
  REST_CONFIG = (
    CATALOG_URI = 'https://glue.us-west-2.amazonaws.com/iceberg'
    CATALOG_API_TYPE = AWS_GLUE
    CATALOG_NAME= '123456789012'
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789012:role/my-role'
    SIGV4_SIGNING_REGION = 'us-west-2'
  )
  ENABLED = TRUE;

-- Example 23259
CREATE CATALOG INTEGRATION my_rest_cat_int
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'default'
  REST_CONFIG = (
    CATALOG_URI = 'https://abc123.us-west-2.aws.myapi.com/polaris/api/catalog'
    CATALOG_NAME = 'my_catalog_name'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = '123AbC ...'
    OAUTH_CLIENT_SECRET = '1365910abIncorrectSecret ...'
    OAUTH_ALLOWED_SCOPES = ('all-apis', 'sql')
  )
  ENABLED = TRUE;

-- Example 23260
SELECT SYSTEM$VERIFY_CATALOG_INTEGRATION('my_rest_cat_int');

-- Example 23261
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                              SYSTEM$VERIFY_CATALOG_INTEGRATION('MY_REST_CAT_INT')                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {                                                                                                                                                                                                                                                                               |
|  "success" : false,                                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                                                    |
|   "errorCode" : "004155",                                                                                                                                                                                                                                                       |
|   "errorMessage" : "SQL Execution Error: Failed to perform OAuth client credential flow for the REST Catalog integration MY_REST_CAT_INT due to error: SQL execution error: OAuth2 Access token request failed with error 'unauthorized_client:The client is not authorized'.." |
| }                                                                                                                                                                                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 23262
curl -X POST https://xx123xx.us-west-2.aws.snowflakecomputing.com/polaris/api/catalog/v1/oauth/tokens \
    -H "Accepts: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "scope=PRINCIPAL_ROLE:ALL" \
    --data-urlencode "client_id=<my_client_id>" \
    --data-urlencode "client_secret=<my_client_secret>" | jq

-- Example 23263
{
  "access_token": "xxxxxxxxxxxxxxxx",
  "token_type": "bearer",
  "issued_token_type": "urn:ietf:params:oauth:token-type:access_token",
  "expires_in": 3600
}

-- Example 23264
curl -X GET "https://xx123xx.us-west-2.aws.snowflakecomputing.com/polaris/api/catalog/v1/config?warehouse=<warehouse>" \
    -H "Accepts: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq

-- Example 23265
{
  "defaults": {
    "default-base-location": "s3://my-bucket/polaris/"
  },
  "overrides": {
    "prefix": "my-catalog"
  }
}

-- Example 23266
curl -X GET "https://xx123xx.us-west-2.aws.snowflakecomputing.com/polaris/api/catalog/v1/<prefix>/namespaces/<namespace>/tables/<table>" \
    -H "Accepts: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq

-- Example 23267
curl -X GET "https://xx123xx.us-west-2.aws.snowflakecomputing.com/polaris/api/catalog/v1/config?warehouse=<warehouse>" \
    -H "Accepts: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Authorization: Bearer ${BEARER_TOKEN}" | jq

-- Example 23268
{
  "defaults": {
    "default-base-location": "s3://my-bucket/polaris"
  },
  "overrides": {
    "prefix": "my-catalog"
  }
}

-- Example 23269
curl -X GET "https://xx123xx.us-west-2.aws.snowflakecomputing.com/polaris/api/catalog/v1/<prefix>/namespaces/<namespace>/tables/<table>" \
    -H "Accepts: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Authorization: Bearer ${BEARER_TOKEN}" | jq

-- Example 23270
aws sts get-caller-identity

-- Example 23271
{
  "UserId": "ABCDEFG1XXXXXXXXXXX",
  "Account": "123456789XXX",
  "Arn": "arn:aws:iam::123456789XXX:user/managed/my_user"
}

-- Example 23272
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "<snowflake_iam_user_arn>",
          "<my_iam_user_arn>"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "my_external_id"
        }
      }
    }
  ]
}

-- Example 23273
aws sts assume-role \
  --role-arn <my_role_arn> \
  --role-session-name <session_name>

-- Example 23274
{
  "Credentials": {
      "AccessKeyId": "XXXXXXXXXXXXXXXXXXXXX",
      "SecretAccessKey": "XXXXXXXXXXXXXXXXXXXXX",
      "SessionToken": "XXXXXXXXXXXXXXXXXXXXX",
      "Expiration": "2024-10-09T08:13:15+00:00"
  },
  "AssumedRoleUser": {
      "AssumedRoleId": "{AccessKeyId}:my_rest_catalog_session",
      "Arn": "arn:aws:sts::123456789XXX:assumed-role/my_catalog_role/my_rest_catalog_session"
  }
}

-- Example 23275
curl -v -X GET  "https://123xxxxxxx.execute-api.us-west-2.amazonaws.com/test_v2/v1/config?warehouse=<warehouse>" \
  --user "$AWS_ACCESS_KEY_ID":"$AWS_SECRET_ACCESS_KEY" \
  --aws-sigv4 "aws:amz:us-west-2:execute-api" \
  -H "x-amz-security-token: $AWS_SESSION_TOKEN"

-- Example 23276
{
  "defaults": {},
  "overrides": {
    "prefix": "my-catalog"
  }
}

-- Example 23277
curl -v -X GET "https://123xxxxxxx.execute-api.us-west-2.amazonaws.com/test_v2/v1/<prefix>/namespaces/<namespace>/tables/<table>" \
    --user "$AWS_ACCESS_KEY_ID":"$AWS_SECRET_ACCESS_KEY" \
    --aws-sigv4 "aws:amz:us-west-2:execute-api" \
    -H "x-amz-security-token: $AWS_SESSION_TOKEN"

-- Example 23278
curl -v -X GET  "https://vpce-xxxxxxxxxxxxxxxxxxxxxxxxxx.execute-api.us-west-2.vpce.amazonaws.com/test_v2/v1/config?warehouse=<warehouse>" \
  --user "$AWS_ACCESS_KEY_ID":"$AWS_SECRET_ACCESS_KEY" \
  --aws-sigv4 "aws:amz:us-west-2:execute-api" \
  -H "x-amz-security-token: $AWS_SESSION_TOKEN"
  -H "Host: abc1defgh2.execute-api.us-west-2.amazonaws.com"

-- Example 23279
CREATE OR REPLACE CATALOG INTEGRATION my_open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'myOpenCatalogCatalogNamespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://<orgname>-<my-snowflake-open-catalog-account-name>.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'myOpenCatalogExternalCatalogName'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'myClientId'
    OAUTH_CLIENT_SECRET = 'myClientSecret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;

-- Example 23280
ALTER FAILOVER GROUP my_failover_group SET
  OBJECT_TYPES = ROLES, INTEGRATIONS
  ALLOWED_INTEGRATION_TYPES = API INTEGRATIONS, STORAGE INTEGRATIONS;

-- Example 23281
CREATE OR REPLACE STAGE my_stage
  DIRECTORY = (ENABLE = TRUE);

COPY INTO @my_stage/folder1/file1 from my_table;
COPY INTO @my_stage/folder2/file2 from my_table;
ALTER STAGE my_stage REFRESH;

COPY INTO @my_stage/folder3/file3 from my_table;

-- Example 23282
CREATE FAILOVER GROUP my_stage_failover_group
  OBJECT_TYPES = DATABASES
  ALLOWED_DATABASES = my_database_1
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 23283
CREATE FAILOVER GROUP my_stage_failover_group
  AS REPLICA OF myorg.my_account_1.my_stage_failover_group;

ALTER FAILOVER GROUP my_stage_failover_group REFRESH;

ALTER FAILOVER GROUP my_stage_failover_group PRIMARY;

-- Example 23284
ALTER STAGE my_stage REFRESH;

COPY INTO my_table FROM @my_stage;

-- Example 23285
CREATE STORAGE INTEGRATION my_storage_int
  TYPE = external_stage
  STORAGE_PROVIDER = 's3'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket/path')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket/blockedpath')
  ENABLED = true;

-- Example 23286
CREATE STAGE my_ext_stage
  URL = 's3://mybucket/path'
  STORAGE_INTEGRATION = my_storage_int

-- Example 23287
CREATE FAILOVER GROUP my_external_stage_fg
  OBJECT_TYPES = databases, integrations
  ALLOWED_INTEGRATION_TYPES = storage integrations
  ALLOWED_DATABASES = my_database_2
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 23288
CREATE FAILOVER GROUP my_external_stage_fg
  AS REPLICA OF myorg.my_account_1.my_external_stage_fg;

ALTER FAILOVER GROUP my_external_stage_fg REFRESH;

-- Example 23289
CREATE PIPE snowpipe_db.public.mypipe AUTO_INGEST=TRUE
 AWS_SNS_TOPIC='<topic_arn>'
 AS
   COPY INTO snowpipe_db.public.mytable
   FROM @snowpipe_db.public.my_s3_stage
   FILE_FORMAT = (TYPE = 'JSON');

-- Example 23290
ALTER PIPE mypipe REFRESH;

-- Example 23291
CREATE FAILOVER GROUP my_pipe_failover_group
  OBJECT_TYPES = DATABASES, INTEGRATIONS
  ALLOWED_INTEGRATION_TYPES = STORAGE INTEGRATIONS
  ALLOWED_DATABASES = snowpipe_db
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 23292
CREATE FAILOVER GROUP my_pipe_failover_group
  AS REPLICA OF myorg.my_account_1.my_pipe_failover_group;

