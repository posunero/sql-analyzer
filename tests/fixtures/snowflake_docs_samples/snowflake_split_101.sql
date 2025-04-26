-- Example 6748
SYSTEM$GET_ALL_REFERENCES('<reference_name>', [, <include_details> = True | False ])

-- Example 6749
{
  "alias": "<value>",
  "database": "<value>",
  "schema": "<value>",
  "name": "<value>"
}

-- Example 6750
SYSTEM$GET_AWS_SNS_IAM_POLICY( '<sns_topic_arn>' )

-- Example 6751
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6752
SELECT SYSTEM$GET_CLASSIFICATION_RESULT( '<object_name>' )

-- Example 6753
{
  "classification_profile_config": {
    "classification_profile_name": "db1.sch.sensitive_data_detection_profile"
  },
  "classification_result": {
    "col1_name": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "QUASI_IDENTIFIER",
        "semantic_category": "DATE_OF_BIRTH",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "DATE_OF_BIRTH"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "QUASI_IDENTIFIER"
          }
        ]
      },
      "valid_value_ratio": 1
    }
  }
}

-- Example 6754
SELECT SYSTEM$GET_CLASSIFICATION_RESULT('hr.tables.empl_info');

-- Example 6755
SYSTEM$GET_CMK_AKV_CONSENT_URL( '<account_identifier>' , '<tenant_id>' )

-- Example 6756
SELECT SYSTEM$GET_CMK_AKV_CONSENT_URL('my-account' , 'b3ddabe4-e5ed-4e71-8827-0cefb99af240');

-- Example 6757
https://login.microsoftonline.com/tenantId/oauth2/authorize?client_id=myClientId&response_type=code

-- Example 6758
SYSTEM$GET_CMK_CONFIG()

-- Example 6759
SYSTEM$GET_CMK_CONFIG( '<tenant-id>' )

-- Example 6760
{"Sid": "Allow use of the key by Snowflake","Effect": "Allow","Principal": {"AWS": "my-arn:name/TRISECRETTEST"},"Action": ["kms:Decrypt","kms:GenerateDataKeyWithoutPlaintext"],"Resource": "arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59"},

-- Example 6761
Consent url is: https://login.microsoftonline.com/tenantId/oauth2/authorize?client_id=c03edcfb-19f9-435f-92fa-e8ec9e24f40e&response_type=code and Snowflake Service Principal name is: trisec_cmk_azure"

-- Example 6762
gcloud kms keys add-iam-policy-binding TriSecretGCPKey --project my-env --location us-west1 --keyring TriSecretTest --member serviceAccount:site-trisecret@my-env.iam.serviceaccount.com --role roles/cloudkms.cryptoKeyEncrypterDecrypter

-- Example 6763
SELECT SYSTEM$GET_CMK_CONFIG('b3ddabe4-e5ed-4e71-8827-0cefb99af240');

-- Example 6764
SYSTEM$GET_CMK_INFO()

-- Example 6765
CMK with ARN: arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59 is pre-registered for Tri-Secret Secure

-- Example 6766
CMK with ARN: arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59 is activated for Tri-Secret Secure

-- Example 6767
CMK with ARN: arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59 is activated with Tri-Secret Secure, but CMK with ARN: arn:aws:kms:us-west-2:481048248138:key/e08cb6c0-7c09-4f37-8e55-e395a12fe965 is pre-registered for Tri-Secret Secure

-- Example 6768
CMK info has not been pre-registered in this account yet, but CMK arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59 is activated with Tri-Secret Secure

-- Example 6769
CMK info has not been pre-registered in this account yet

-- Example 6770
SELECT SYSTEM$GET_CMK_INFO();

-- Example 6771
SYSTEM$GET_CMK_KMS_KEY_POLICY()

-- Example 6772
SELECT SYSTEM$GET_CMK_KMS_KEY_POLICY();

-- Example 6773
SYSTEM$GET_COMPUTE_POOL_PENDING_MAINTENANCE()

-- Example 6774
SELECT SYSTEM$GET_COMPUTE_POOL_PENDING_MAINTENANCE();

-- Example 6775
+---------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_COMPUTE_POOL_PENDING_MAINTENANCE()                                                           |
|---------------------------------------------------------------------------------------------------------|
| {"maintenanceRequired":false,"maintenanceWindow":{"start":"2025-02-27T23:00","end":"2025-02-28T00:00"}} |
+---------------------------------------------------------------------------------------------------------+

-- Example 6776
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;

-- Example 6777
ALTER COMPUTE POOL <name> { SUSPEND | RESUME | STOP ALL }

-- Example 6778
ALTER COMPUTE POOL <name> SET propertiesToAlter = <value>
propertiesToAlter := { MIN_NODES | MAX_NODES | AUTO_RESUME | AUTO_SUSPEND_SECS | COMMENT }

-- Example 6779
ALTER COMPUTE POOL my_pool SET MIN_NODES = 2  MAX_NODES = 2;

-- Example 6780
DROP COMPUTE POOL <name>

-- Example 6781
USE ROLE ACCOUNTADMIN;
ALTER COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU STOP ALL;
DROP COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU;

-- Example 6782
USE ROLE ACCOUNTADMIN;
REVOKE USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU FROM ROLE PUBLIC;
GRANT USAGE ON COMPUTE POOL SYSTEM_COMPUTE_POOL_CPU TO ROLE <role-name>;

-- Example 6783
ALTER ACCOUNT SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 6784
ALTER DATABASE my_db SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 6785
ALTER SCHEMA my_db.my_schema SET DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU='my_pool';

-- Example 6786
SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN ACCOUNT;

SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN DATABASE my_db;

SHOW PARAMETERS LIKE 'DEFAULT_NOTEBOOK_COMPUTE_POOL_GPU' IN SCHEMA my_db.my_schema;

-- Example 6787
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE <role_name> [WITH GRANT OPTION];

-- Example 6788
SYSTEM$GET_DEBUG_STATUS()

-- Example 6789
SYSTEM$GET_DIRECTORY_TABLE_STATUS( [ '<stage_name>' ] )

-- Example 6790
{
  "stage" : "STAGE1",
  "status" : "INCONSISTENT"
}

-- Example 6791
SELECT SYSTEM$GET_DIRECTORY_TABLE_STATUS();

-- Example 6792
[
  {
    "stage" : "STAGE1",
    "status" : "CONSISTENT"
  },
  {
    "stage" : "STAGE2",
    "status" : "INCONSISTENT"
  }
]

-- Example 6793
SELECT SYSTEM$GET_DIRECTORY_TABLE_STATUS('stage1');

-- Example 6794
[
  {
    "stage" : "STAGE1",
    "status" : "CONSISTENT"
  }
]

-- Example 6795
SYSTEM$GET_GCP_KMS_CMK_GRANT_ACCESS_CMD()

-- Example 6796
select SYSTEM$GET_GCP_KMS_CMK_GRANT_ACCESS_CMD();

-- Example 6797
gcloud kms keys add-iam-policy-binding <key-name> --project <project-id> --location <location> --keyring <key-ring> --member serviceAccount:<service-account-email> --role roles/cloudkms.cryptoKeyEncrypterDecrypter

-- Example 6798
SYSTEM$GET_HASH_FOR_APPLICATION( '<app_name>' [ , '<query_id>' ] )

-- Example 6799
SELECT SYSTEM$GET_HASH_FOR_APPLICATION('hello_snowflake_app');

-- Example 6800
+--------------------------------------------------------+
| SYSTEM$GET_HASH_FOR_APPLICATION('HELLO_SNOWFLAKE_APP') |
|--------------------------------------------------------|
| yksY1823VLDNSbwRW3LrIuI+sfUII                          |
+--------------------------------------------------------+

-- Example 6801
SELECT SYSTEM$GET_HASH_FOR_APPLICATION('hello_snowflake_app', '01bafe06-3210-d462-0000-04150406931a');

-- Example 6802
+------------------------------------------------------------------------------------------------+
| SYSTEM$GET_HASH_FOR_APPLICATION('HELLO_SNOWFLAKE_APP', '01bafe06-3210-d462-0000-04150406931a') |
|------------------------------------------------------------------------------------------------|
| nGEP/JvFhc9a7r41p+y98hUx6Q=                                                                    |
+------------------------------------------------------------------------------------------------+

-- Example 6803
SYSTEM$GET_ICEBERG_TABLE_INFORMATION('<iceberg_table_name>')

-- Example 6804
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('db1.schema1.it1');

-- Example 6805
+-----------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_ICEBERG_TABLE_INFORMATION('DB1.SCHEMA1.IT1')                                                   |
|-----------------------------------------------------------------------------------------------------------|
| {"metadataLocation":"s3://mybucket/metadata/v1.metadata.json","status":"success"}                         |
+-----------------------------------------------------------------------------------------------------------+

-- Example 6806
SYSTEM$GET_LOGIN_FAILURE_DETAILS('<uuid>')

-- Example 6807
Invalid  OAuth access token. [0ce9eb56-821d-4ca9-a774-04ae89a0cf5a]

-- Example 6808
SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('0ce9eb56-821d-4ca9-a774-04ae89a0cf5a'), 'errorCode');

-- Example 6809
SYSTEM$GET_PREDECESSOR_RETURN_VALUE('<task_name>')

-- Example 6810
CREATE TASK task_root
  SCHEDULE = '1 MINUTE'
  AS SELECT 1;

CREATE TASK task_a
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_b
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_c
  AFTER task_a, task_b
  AS SELECT 1;

-- Example 6811
CREATE TASK task_finalizer
  FINALIZE = task_root
  AS SELECT 1;

-- Example 6812
CREATE OR REPLACE TASK task_root
  SCHEDULE = '1 MINUTE'
  TASK_AUTO_RETRY_ATTEMPTS = 2   --  Failed task graph retries up to 2 times
  SUSPEND_TASK_AFTER_NUM_FAILURES = 3   --  Task graph suspends after 3 consecutive failures
  AS SELECT 1;

-- Example 6813
CREATE OR REPLACE TASK "task_root"
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  CONFIG='{"environment": "production", "path": "/prod_directory/"}'
  AS
    SELECT 1;

CREATE OR REPLACE TASK "task_a"
  USER_TASK_TIMEOUT_MS = 600000
  AFTER "task_root"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_TASK_GRAPH_CONFIG('path'));
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
      INSERT INTO demo_table VALUES('task c path',:value);
    END;

-- Example 6814
CREATE OR REPLACE TASK "task_c"
  SCHEDULE = '1 MINUTE'
  USER_TASK_TIMEOUT_MS = 60000
  AS
    BEGIN
      CALL SYSTEM$SET_RETURN_VALUE('task_c successful');
    END;

CREATE OR REPLACE TASK "task_d"
  USER_TASK_TIMEOUT_MS = 60000
  AFTER "task_c"
  AS
    BEGIN
      LET VALUE := (SELECT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_c'));
      CREATE TABLE IF NOT EXISTS demo_table(NAME VARCHAR, VALUE VARCHAR);
      INSERT INTO demo_table VALUES('Value from predecessor task_c', :value);
    END;

