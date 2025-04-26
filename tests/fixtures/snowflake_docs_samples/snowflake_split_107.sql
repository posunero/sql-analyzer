-- Example 7150
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('mydb.myschema.mytask');

-- Example 7151
SELECT SYSTEM$TASK_DEPENDENTS_ENABLE('mydb.myschema."myTask"');

-- Example 7152
SYSTEM$TASK_RUNTIME_INFO('<arg_name>')

-- Example 7153
CREATE OR REPLACE TASK my_task ...
  AS
  ...

  -- Inside Python UDF

  query_result = session.sql("""select
        SYSTEM$TASK_RUNTIME_INFO('CURRENT_ROOT_TASK_NAME')
        root_name,
        SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID')
        run_id""").collect()
  current_root_task_name, current_graph_run_id = result.ROOT_NAME, result.RUN_ID

  -- Logging information here

  logger.debug(f"start training for {current_root_task_name} at run {current_graph_run_id}")

  -- Create a unique output directory to store intermediate information

  output_dir_name = f"{current_root_task_name}/{current_graph_run_id}/preprocessing.out"
  with open(output_dir_name, "rw+") as f:
    ....
...;

-- Example 7154
CREATE OR REPLACE TASK my_task ...
  AS
  ...
  INSERT INTO my_output_table
    SELECT * FROM my_source_table
      WHERE TRUE
        ...
        AND TIMESTAMP BETWEEN
          COALESCE(
            SYSTEM$TASK_RUNTIME_INFO(‘LAST_SUCCESSFUL_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP’),
            '2023-07-01'
          ) AND SYSTEM$TASK_RUNTIME_INFO(‘CURRENT_TASK_GRAPH_ORIGINAL_SCHEDULED_TIMESTAMP’)
   ...;

-- Example 7155
CREATE OR REPLACE TASK my_task ...
  AS
  ...

  -- Inside Python UDF

  query_result = session.sql("select
      SYSTEM$TASK_RUNTIME_INFO('CURRENT_ROOT_TASK_NAME') root_name, SYSTEM$TASK_RUNTIME_INFO('LAST_SUCCESSFUL_TASK_GRAPH_RUN_GROUP_ID') last_run_id").collect()
  current_root_task_name, last_graph_run_id = result.ROOT_NAME,result.LAST_RUN_ID
  logger.log(f"graph name: {current_root_task_name}, last successful run: {last_graph_run_id}")
  ...;

-- Example 7156
SYSTEM$TRIGGER_LISTING_REFRESH( '<type>' , '<name>' )

-- Example 7157
SELECT SYSTEM$TRIGGER_LISTING_REFRESH('DATABASE', 'MY_DATABASE');

-- Example 7158
SYSTEM$TYPEOF( <expr> )

-- Example 7159
SELECT SYSTEM$TYPEOF(NULL);

-- Example 7160
+---------------------+
| SYSTEM$TYPEOF(NULL) |
|---------------------|
| NULL[LOB]           |
+---------------------+

-- Example 7161
SELECT SYSTEM$TYPEOF(1);

-- Example 7162
+------------------+
| SYSTEM$TYPEOF(1) |
|------------------|
| NUMBER(1,0)[SB1] |
+------------------+

-- Example 7163
SELECT SYSTEM$TYPEOF(1e10);

-- Example 7164
+---------------------+
| SYSTEM$TYPEOF(1E10) |
|---------------------|
| NUMBER(11,0)[SB8]   |
+---------------------+

-- Example 7165
SELECT SYSTEM$TYPEOF(10000);

-- Example 7166
+----------------------+
| SYSTEM$TYPEOF(10000) |
|----------------------|
| NUMBER(5,0)[SB2]     |
+----------------------+

-- Example 7167
SELECT SYSTEM$TYPEOF('something');

-- Example 7168
+----------------------------+
| SYSTEM$TYPEOF('SOMETHING') |
|----------------------------|
| VARCHAR(9)[LOB]            |
+----------------------------+

-- Example 7169
SELECT SYSTEM$TYPEOF(CONCAT('every', 'body'));

-- Example 7170
+----------------------------------------+
| SYSTEM$TYPEOF(CONCAT('EVERY', 'BODY')) |
|----------------------------------------|
| VARCHAR(9)[LOB]                        |
+----------------------------------------+

-- Example 7171
SYSTEM$UNBLOCK_INTERNAL_STAGES_PUBLIC_ACCESS()

-- Example 7172
USE ROLE accountadmin;

SELECT SYSTEM$UNBLOCK_INTERNAL_STAGES_PUBLIC_ACCESS();

-- Example 7173
SYSTEM$UNREGISTER_PRIVATELINK_ENDPOINT(
  '<aws_private_endpoint_vpce_id>',
  '<aws_account_id>',
  '<token>',
  )

-- Example 7174
SYSTEM$UNREGISTER_PRIVATELINK_ENDPOINT(
  '<azure_private_endpoint_link_id>',
  '<azure_private_endpoint_resource_id>',
  '<token>',
  )

-- Example 7175
aws ec2 describe-vpc-endpoints

-- Example 7176
aws sts get-caller-identity

-- Example 7177
az network private-endpoint list --resource-group my_resource_group

-- Example 7178
aws sts get-federation-token --name snowflake --policy '{ "Version": "2012-10-17", "Statement"
: [ { "Effect": "Allow", "Action": ["ec2:DescribeVpcEndpoints"], "Resource": ["*"] } ] }'

-- Example 7179
az account get-access-token --subscription <subscription_id>

-- Example 7180
SELECT SYSTEM$UNREGISTER_PRIVATELINK_ENDPOINT(
  'vpce-0c1...',
  '174...',
  '{
    "Credentials": {
      "AccessKeyId": "ASI...",
      "SecretAccessKey": "aFP...",
      "SessionToken": "Fwo...",
      "Expiration": "2024-04-26 05:49:09+00:00"
    },
    "FederatedUser": {
      "FederatedUserId": "0123...:snowflake",
      "Arn": "arn:aws:sts::174...:federated-user/sam"
    },
    "PackedPolicySize": 9,
  }'
);

-- Example 7181
SELECT SYSTEM$UNREGISTER_PRIVATELINK_ENDPOINT(
  '123...',
  '/subscriptions/0cc51670-.../resourceGroups/dbsec_test_rg/providers/Microsoft.Network/
  privateEndpoints/...',
  'eyJ...',
  );

-- Example 7182
SYSTEM$UNSET_EVENT_SHARING_ACCOUNT_FOR_REGION( '<snowflake_region>' , '<region_group>' , '<account_name>' )

-- Example 7183
SELECT SYSTEM$UNSET_EVENT_SHARING_ACCOUNT_FOR_REGION('aws_us_west_2', 'public', 'myaccount');

-- Example 7184
SYSTEM$USER_TASK_CANCEL_ONGOING_EXECUTIONS( '<task_name>' )

-- Example 7185
SELECT SYSTEM$USER_TASK_CANCEL_ONGOING_EXECUTIONS('mydb.myschema.mytask');

-- Example 7186
SELECT SYSTEM$USER_TASK_CANCEL_ONGOING_EXECUTIONS('mydb.myschema."myTask"');

-- Example 7187
TASK_HISTORY(
      [ SCHEDULED_TIME_RANGE_START => <constant_expr> ]
      [, SCHEDULED_TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <integer> ]
      [, TASK_NAME => '<string>' ]
      [, ERROR_ONLY => { TRUE | FALSE } ]
      [, ROOT_TASK_ID => '<string>'] )

-- Example 7188
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
  ORDER BY SCHEDULED_TIME;

-- Example 7189
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START=>TO_TIMESTAMP_LTZ('2024-11-9 12:00:00.000 -0700'),
    SCHEDULED_TIME_RANGE_END=>TO_TIMESTAMP_LTZ('2024-11-9 12:30:00.000 -0700')));

-- Example 7190
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START=>DATEADD('hour',-1,current_timestamp()),
    RESULT_LIMIT => 10,
    TASK_NAME=>'mytask'));

-- Example 7191
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(ROOT_TASK_ID=>'d4b89013-c942-465c-bcb8-e7037a932b04'));

-- Example 7192
DESC TASK my_task
SET task_id=(SELECT "id" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())));
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(ROOT_TASK_ID=>$task_id));

-- Example 7193
SYSTEM$VALIDATE_STORAGE_INTEGRATION( '<storage_integration_name>', '<storage_path>', '<test_file_name>', '<validate_action>' )

-- Example 7194
{
  "status" : "success",
  "actions" : {
    "READ" : {
      "status" : "success"
    },
    "DELETE" : {
      "status" : "success"
    },
    "LIST" : {
      "status" : "success"
    },
    "WRITE" : {
      "status" : "success"
    }
  }
}

-- Example 7195
SELECT
  SYSTEM$VALIDATE_STORAGE_INTEGRATION(
    'example_integration',
    's3://example_bucket/test_path/'',
    'validate_all.txt', 'all');

-- Example 7196
+----------------------------+
|           RESULT           |
+----------------------------+
| {                          |
|   "status" : "success",    |
|   "actions" : {            |
|     "READ" : {             |
|       "status" : "success" |
|     },                     |
|     "DELETE" : {           |
|       "status" : "success" |
|     },                     |
|     "LIST" : {             |
|       "status" : "success" |
|     },                     |
|     "WRITE" : {            |
|       "status" : "success" |
|     }                      |
|   }                        |
| }                          |
+----------------------------+

-- Example 7197
SELECT
  SYSTEM$VALIDATE_STORAGE_INTEGRATION(
    'example_integration',
    'gcs://example_bucket/test_path/'',
    'read_fail.txt', 'all');

-- Example 7198
+----------------------------------------------------------------------------------------------------------------+
|                                                     RESULT                                                     |
+----------------------------------------------------------------------------------------------------------------+
| {                                                                                                              |
|   "status" : "failure",                                                                                        |
|   "actions" : {                                                                                                |
|     "READ" : {                                                                                                 |
|       "message" : "Access Denied (Status Code: 403; Error Code: AccessDenied)",                                |
|       "status" : "failure"                                                                                     |
|     },                                                                                                         |
|     "DELETE" : {                                                                                               |
|       "status" : "success"                                                                                     |
|     },                                                                                                         |
|     "LIST" : {                                                                                                 |
|       "status" : "success"                                                                                     |
|     },                                                                                                         |
|     "WRITE" : {                                                                                                |
|       "status" : "success"                                                                                     |
|     }                                                                                                          |
|   },                                                                                                           |
|   "message" : "Some of the integration checks failed. Check the Snowflake documentation for more information." |
| }                                                                                                              |
+----------------------------------------------------------------------------------------------------------------+

-- Example 7199
SYSTEM$VERIFY_CATALOG_INTEGRATION( '<rest_catalog_integration_name>' )

-- Example 7200
{
  "success" : false,
  "errorCode" : "004140",
  "errorMessage" : "SQL Execution Error: Failed to access the REST endpoint of catalog integration CAT_INT_VERIFICATION with error: Unable to process: Unable to find warehouse my_warehouse. Check the accessibility of the REST catalog URI or warehouse."
}

-- Example 7201
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

-- Example 7202
SELECT SYSTEM$VERIFY_CATALOG_INTEGRATION('my_rest_cat_int');

-- Example 7203
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                              SYSTEM$VERIFY_CATALOG_INTEGRATION('MY_REST_CAT_INT')                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {                                                                                                                                                                                                                                                                               |
|  "success" : false,                                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                                                    |
|   "errorCode" : "004155",                                                                                                                                                                                                                                                       |
|   "errorMessage" : "SQL Execution Error: Failed to perform OAuth client credential flow for the REST Catalog integration MY_REST_CAT_INT due to error: SQL execution error: OAuth2 Access token request failed with error 'unauthorized_client:The client is not authorized'.." |
| }                                                                                                                                                                                                                                                                               |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 7204
SYSTEM$VERIFY_CMK_INFO()

-- Example 7205
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                                                                                                               SYSTEM$VERIFY_CMK_INFO()                                                                                                                                                                                               |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Verification failed due to an exception with message: Access is denied to the customer managed key (CMK) for this account. This could be because: 1) the CMK access permissions granted to Snowflake have been revoked OR 2) the CMK is disabled OR 3) the CMK is scheduled for deletion OR 4) the CMK specified is wrong. CMK ARN used: arn:aws:kms:us-west-2:736112632311:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59 |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 7206
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                                                                     SYSTEM$VERIFY_CMK_INFO()                                                                                                                                                     |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Verification failed due to an exception with message: Error received from the customer managed key (CMK) provider caused by user: 'Your request cannot be completed because of the failure of an external dependency. Please try again later.'. CMK KEY URI used: https://trisecretsite.vault.azure.net/keys/TriSecretAZKeyWrong |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 7207
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                                                                                                                                   SYSTEM$VERIFY_CMK_INFO()                                                                                                                                                                                                                    |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Verification failed due to an exception with message: Access is denied to the customer managed key (CMK) for this account. This could be because: 1) the CMK access permissions granted to Snowflake have been revoked OR 2) the CMK is disabled OR 3) the CMK is scheduled for deletion OR 4) the CMK specified is wrong. CMK resource ID used: projects/my-env/locations/us-west2/keyRings/TriSecretTest/cryptoKeys/TriSecretGCPKey                         |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 7208
SELECT SYSTEM$VERIFY_CMK_INFO();

-- Example 7209
SYSTEM$VERIFY_EXTERNAL_OAUTH_TOKEN( '<access_token>' )

-- Example 7210
SELECT SYSTEM$VERIFY_EXTERNAL_OAUTH_TOKEN('<access_token>');

+-----------------------------------------------------------------------------------------------+
| Token Validation finished.{"Validation Result":"Passed","Issuer":"<URL>","User":"<username>"} |
+-----------------------------------------------------------------------------------------------+

-- Example 7211
SYSTEM$VERIFY_EXTERNAL_VOLUME('<external_volume_name>')

-- Example 7212
{
  "success": true,
  "storageLocationSelectionResult": "PASSED",
  "storageLocationName": "my-azure-westus-1",
  "servicePrincipalProperties": "AZURE_MULTI_TENANT_APP_NAME: powerful-azure-ad-auth-test-snowflake-app_...; AZURE_CONSENT_URL: https://login.microsoftonline.com...",
  "location": "azure://myStorageAccount.blob.core.windows.net/myStorageLocation/",
  "storageAccount": "myStorageAccount",
  "region": "westus",
  "writeResult": "PASSED",
  "readResult": "PASSED",
  "listResult": "PASSED",
  "deleteResult": "PASSED",
  "awsRoleArnValidationResult": "SKIPPED",
  "azureGetUserDelegationKeyResult": "PASSED"
}

-- Example 7213
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_s3_external_volume');

-- Example 7214
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_s3_external_volume');

-- Example 7215
ALTER DATABASE my_database_1
  SET EXTERNAL_VOLUME = 'my_s3_vol';

-- Example 7216
CREATE ICEBERG TABLE iceberg_reviews_table (
  id STRING,
  product_name STRING,
  product_id STRING,
  reviewer_name STRING,
  review_date DATE,
  review STRING
)
CATALOG = 'SNOWFLAKE'
BASE_LOCATION = 'my/product_reviews/';

