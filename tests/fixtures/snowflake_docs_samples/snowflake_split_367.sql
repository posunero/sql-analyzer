-- Example 24564
snowsql -o sql_split=snowflake.connector.util_text

-- Example 24565
[options]
sql_split=snowflake.cli.sqlsplit

-- Example 24566
snowsql -o sql_split=snowflake.cli.sqlsplit ...

-- Example 24567
LIST @mystage pattern='.*t.*';

-- Example 24568
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24569
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24570
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24571
{
  "snowflake-vpc-id": ["<existing VPC ID>"],
  "snowflake-egress-vpc-ids": [
    {
      "id": "<existing VPC ID>",
      "expires": "2025-03-01T00:00:00",
      "purpose": "generic"
    },
    {
      "id": "<new VPC ID>",
      "expires": "2025-03-01T00:00:00",
      "purpose": "generic"
    }
  ]
}

-- Example 24572
USE ROLE ACCOUNTADMIN;

SELECT stage_url, stage_region, stage_owner, stage_catalog, stage_schema
  FROM SNOWFLAKE.ACCOUNT_USAGE.STAGES
  WHERE STARTSWITH(stage_url, 's3')
    AND stage_url IS NOT NULL
    AND deleted IS NULL;

-- Example 24573
USE ROLE ACCOUNTADMIN;

SELECT function_name, function_definition, function_owner, function_catalog, function_schema
  FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTIONS
  WHERE function_language = 'EXTERNAL'
    AND function_definition ILIKE '%.execute-api.%.amazonaws.com%'
    AND deleted IS NULL;

-- Example 24574
use role accountadmin;

DECLARE
res1 RESULTSET;
res2 RESULTSET;
sql_vol VARCHAR;
rpt VARIANT;
rpt_int VARIANT;
BEGIN
  rpt := object_construct();
  sql_vol := 'SELECT PROPERTY, VALUE:"NAME"::VARCHAR as NAME, VALUE:"STORAGE_ALLOWED_LOCATIONS"::VARCHAR as S3_PATH FROM (
SELECT PARSE_JSON(T."property_value") AS VALUE, T."property" as PROPERTY
FROM TABLE(RESULT_SCAN(last_query_id())) T
WHERE T."property_type" = \'String\'
AND T."property" != \'ACTIVE\'
AND VALUE:"STORAGE_PROVIDER"=\'S3\')
;';
  show external volumes;
  LET c1 CURSOR FOR SELECT * FROM TABLE(RESULT_SCAN(last_query_id()));
  OPEN c1;
  FOR record IN c1 DO
    res1 := (execute immediate 'describe external volume ' || record."name");
    res2 := (execute immediate :sql_vol);
    rpt_int := object_construct();
    let c2 CURSOR for res2;
    open c2;
    for inner_record in c2 do
        rpt_int := object_insert( rpt_int, inner_record.NAME, inner_record.S3_PATH);
    end for;

    rpt := object_insert( rpt, record."name", rpt_int );
  END FOR;
  RETURN rpt;
END;

-- Example 24575
SNOWFLAKE_VPC_ID="<VPC ID returned in snowflake-vpc-id>"

# List ARNs of IAM policies that contain the current Snowflake VPC ID.
aws iam list-policies --scope Local --query 'Policies[*].Arn' --output text | tr '\t' '\n' | while read -r policy_arn; do
  version_id=$(aws iam get-policy --policy-arn "${policy_arn}" --query 'Policy.DefaultVersionId' --output text)
  aws iam get-policy-version --policy-arn "${policy_arn}" --version-id "${version_id}" | grep -q "${SNOWFLAKE_VPC_ID}" && echo "${policy_arn}"
done

# List API IDs of API Gateways that contain resource policies with the current Snowflake VPC ID.
aws apigateway get-rest-apis --query 'items[*].id' --output text --profile | tr '\t' '\n' | while read -r api_id; do
  aws apigateway get-rest-api --rest-api-id "${api_id}" --query 'policy' --output text | grep -q "${SNOWFLAKE_VPC_ID}" && echo "${api_id}"
done

-- Example 24576
{"snowflake-vnet-subnet-id":[
"/subscriptions/ae0c1e4e-d49e-4115-b3ba-888d77ea97a3/resourceGroups/azure-prod/providers/Microsoft.Network/virtualNetworks/azure-prod/subnets/xp",
"/subscriptions/ae0c1e4e-d49e-4115-b3ba-888d77ea97a3/resourceGroups/azure-prod/providers/Microsoft.Network/virtualNetworks/azure-prod/subnets/gs",
"/subscriptions/37265438-aa4f-49f6-adc4-46271ae19193/resourceGroups/deployment-infra-rg2/providers/Microsoft.Network/virtualNetworks/deployment-vnet2/subnets/xp",
"/subscriptions/37265438-aa4f-49f6-adc4-46271ae19193/resourceGroups/deployment-infra-rg2/providers/Microsoft.Network/virtualNetworks/deployment-vnet2/subnets/gs",
"/subscriptions/63c9e19b-5cf1-4dcf-ace5-bf0f416f2ff7/resourceGroups/deployment-infra-rg3/providers/Microsoft.Network/virtualNetworks/deployment-vnet3/subnets/xp",
"/subscriptions/63c9e19b-5cf1-4dcf-ace5-bf0f416f2ff7/resourceGroups/deployment-infra-rg3/providers/Microsoft.Network/virtualNetworks/deployment-vnet3/subnets/gs"
]}

-- Example 24577
GRANT OWNERSHIP ON ROLE my_role TO ROLE my_role;

-- Example 24578
GRANT OWNERSHIP ON ROLE my_role TO ROLE my_role;

-- Example 24579
003645 (42501): SQL execution error: Transferring OWNERSHIP of a role to itself is not allowed.

-- Example 24580
ALTER USER <username> ADD DELEGATED AUTHORIZATION
    OF ROLE <role_name>
    TO SECURITY INTEGRATION <integration_name>;

-- Example 24581
ALTER USER jane.smith ADD DELEGATED AUTHORIZATION
    OF ROLE custom1
    TO SECURITY INTEGRATION myint;

-- Example 24582
SHOW DELEGATED AUTHORIZATIONS;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
+-------------------------------+-----------+-----------+-------------------+--------------------+
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT      | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 24583
SHOW DELEGATED AUTHORIZATIONS
    BY USER <username>;

-- Example 24584
SHOW DELEGATED AUTHORIZATIONS
    TO SECURITY INTEGRATION <integration_name>;

-- Example 24585
ALTER USER <username>
  REMOVE DELEGATED AUTHORIZATIONS
  FROM SECURITY INTEGRATION <integration_name>

-- Example 24586
ALTER USER <username>
  REMOVE DELEGATED AUTHORIZATION OF ROLE <role_name>
  FROM SECURITY INTEGRATION <integration_name>

-- Example 24587
ALTER USER jane.smith
  REMOVE DELEGATED AUTHORIZATION OF ROLE custom1
  FROM SECURITY INTEGRATION myint;

-- Example 24588
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

-- Example 24589
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

-- Example 24590
USE SCHEMA mydb.public;

CREATE STAGE my_s3_stage
  URL='s3://mybucket/load/files'
  CREDENTIALS = (AWS_ROLE = 'arn:aws:iam::001234567890:role/mysnowflakerole')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 24591
DESC STAGE my_S3_stage;

+--------------------+--------------------------------+---------------+----------------------------------------------------------------+------------------+
| parent_property    | property                       | property_type | property_value                                                 | property_default |
|--------------------+--------------------------------+---------------+----------------------------------------------------------------+------------------|
...
| STAGE_CREDENTIALS  | AWS_ROLE                       | String        | arn:aws:iam::001234567890:role/mysnowflakerole                 |                  |
| STAGE_CREDENTIALS  | AWS_EXTERNAL_ID                | String        | MYACCOUNT_SFCRole=2_jYfRf+gT0xSH7G2q0RAODp00Cqw=               |                  |
| STAGE_CREDENTIALS  | SNOWFLAKE_IAM_USER             | String        | arn:aws:iam::123456789001:user/vj4g-a-abcd1234                 |                  |
+--------------------+--------------------------------+---------------+----------------------------------------------------------------+------------------+

-- Example 24592
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "AWS": [
                  "arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
              ]
          },
          "Action": "sts:AssumeRole",
          "Condition": {
              "StringEquals": {
                  "sts:ExternalId": "MYACCOUNT_SFCRole=2_jYfRf+gT0xSH7G2q0RAODp00Cqw="
              }
          }
      }
    ]
}

-- Example 24593
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
            "Resource": "arn:aws:s3:::<bucket_name>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket_name>",
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

-- Example 24594
USE SCHEMA mydb.public;

CREATE OR REPLACE STAGE my_S3_stage
  URL='s3://mybucket/load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 24595
CREATE STAGE my_s3_stage
  STORAGE_INTEGRATION = s3_int
  URL = 's3://mybucket/encrypted_files/'
  FILE_FORMAT = my_csv_format;

-- Example 24596
from snowflake.core.stage import Stage

my_stage = Stage(
  name="my_s3_stage",
  storage_integration="s3_int",
  url="s3://mybucket/encrypted_files/"
)
root.databases["<database>"].schemas["<schema>"].stages.create(my_stage)

-- Example 24597
CREATE OR REPLACE STORAGE INTEGRATION my_int
  ...
  USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE }

-- Example 24598
ALTER STORAGE INTEGRATION my_int
  SET USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE }

-- Example 24599
CREATE OR REPLACE STAGE my_sas_private_stage
  URL = '...'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE }

ALTER STAGE my_sas_private_stage
  SET USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE }

-- Example 24600
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
    'com.amazonaws.us-west-2.s3',
    '*.s3.us-west-2.amazonaws.com');

-- Example 24601
{
  "Sid": "AccesstospecificVPCEonly",
  "Effect": "Deny",
  "Principal": {
    "AWS": "arn:aws:iam::001234567890:role/myrole"
  },
  "Action": "s3:*",
  "Resource": [
    "arn:aws:s3:::mybucket1",
    "arn:aws:s3:::mybucket1/*"
  ],
  "Condition": {
    "StringNotEquals": {
      "aws:SourceVpce": "vpce-01c31eb5f4a1e817d"
    }
  }
}

-- Example 24602
CREATE OR REPLACE STORAGE INTEGRATION outbound_private_link_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket1/path1/')
  USE_PRIVATELINK_ENDPOINT = TRUE
  ENABLED = TRUE;

-- Example 24603
CREATE OR REPLACE STAGE my_storage_private_stage
  URL = 's3://mybucket1/path1/'
  STORAGE_INTEGRATION = outbound_private_link_int;

-- Example 24604
COPY INTO @my_storage_private_stage
  FROM mytable
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 24605
CREATE STAGE my_azure_stage
  STORAGE_INTEGRATION = azure_int
  URL = 'azure://myaccount.blob.core.windows.net/mycontainer/load/files/'
  FILE_FORMAT = my_csv_format;

-- Example 24606
from snowflake.core.stage import Stage

my_stage = Stage(
  name="my_azure_stage",
  storage_integration="azure_int",
  url="azure://myaccount.blob.core.windows.net/mycontainer/load/files/"
)
root.databases["<database>"].schemas["<schema>"].stages.create(my_stage)

-- Example 24607
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cc2909f2-ed22-4c89-8e5d-bdc40e5eac26/resourceGroups/mystorage/providers/Microsoft.Storage/storageAccounts/storagedemo',
  'mystorageaccount.blob.core.windows.net',
  'blob'
);

-- Example 24608
CREATE OR REPLACE STORAGE INTEGRATION outbound_private_link_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  AZURE_TENANT_ID = 'cc2909f2-ed22-4c89-8e5d-bdc40e5eac26'
  STORAGE_ALLOWED_LOCATIONS = ('azure://mystorageaccount.blob.core.windows.net/mycontainer/snowflake_privatelink_external_stage_test/')
  USE_PRIVATELINK_ENDPOINT = TRUE
  ENABLED = TRUE;

-- Example 24609
CREATE OR REPLACE STAGE my_storage_private_stage
  URL = 'azure://mystorageaccount.blob.core.windows.net/mycontainer/snowflake_privatelink_external_stage_test/'
  STORAGE_INTEGRATION = outbound_private_link_int;

-- Example 24610
COPY INTO @my_storage_private_stage
  FROM mytable
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 24611
CREATE [ OR REPLACE ] NOTIFICATION INTEGRATION [ IF NOT EXISTS ] <name>
  ...
  USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE }

-- Example 24612
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cc2909f2-ed22-4c89-8e5d-bdc40e5eac26/resourceGroups/mystorage/providers/Microsoft.Storage/storageAccounts/mystorageaccount',
    'mystorageaccount.queue.core.windows.net',
    'queue'
);

-- Example 24613
CREATE OR REPLACE NOTIFICATION INTEGRATION ni_pl
  ENABLED = TRUE
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = "https://storageaccount.queue.core.windows.net/queuename"
  AZURE_TENANT_ID = '00000000-0000-0000-0000-000000000000'
  USE_PRIVATELINK_ENDPOINT = TRUE;

-- Example 24614
Failure using stage area. Cause: [Request violates VPC Service Controls. (Status Code: 403)]

-- Example 24615
DESC STORAGE INTEGRATION <integration_name>;

-- Example 24616
- members:
   - serviceAccount:<service_account>

-- Example 24617
- members:
   - serviceAccount:service-account-id@project1-123456.iam.gserviceaccount.com

-- Example 24618
gcloud access-context-manager levels create <access_level_name> \
   --title snowflake \
   --basic-level-spec snowflake_policy.yaml \
   --combine-function=OR \
   --policy=<policy_name>

-- Example 24619
SELECT <model_name>!<method_name>(...) FROM <table_name>;

-- Example 24620
WITH <model_version_alias> AS MODEL <model_name> VERSION <version_or_alias_name>
    SELECT <model_version_alias>!<method_name>(...) FROM <table_name>;

-- Example 24621
WITH latest AS MODEL my_model VERSION LAST
    SELECT latest!predict(...) FROM my_table;

-- Example 24622
[connections.myconnection]
account = "myaccount"
user = "jondoe"
password = "password"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 24623
default_connection_name = "myconnection"

[connections.myconnection]
account = "myaccount"
...

-- Example 24624
chown $USER config.toml
chmod 0600 config.toml

-- Example 24625
snow connection add

-- Example 24626
Enter connection name: <connection_name>
Enter account: <account>
Enter user: <user-name>
Enter password: <password>
Enter role: <role-name>
Enter warehouse: <warehouse-name>
Enter database: <database-name>
Enter schema: <schema-name>
Enter host: <host-name>
Enter port: <port-number>
Enter region: <region-name>
Enter authenticator: <authentication-method>
Enter private key file: <path-to-private-key-file>
Enter token file path: <path-to-mfa-token>
Do you want to configure key pair authentication? [y/N]: y
Key length [2048]: <key-length>
Output path [~/.ssh]: <path-to-output-file>
Private key passphrase: <key-description>
Wrote new connection <connection-name> to config.toml

-- Example 24627
snow --config-file config.toml connection add -n myconnection2 --account myaccount2 --user jdoe2

-- Example 24628
snow connection add -n myconnection2 --user jdoe2 --no-interactive

-- Example 24629
snow connection list

-- Example 24630
+-------------------------------------------------------------------------------------------------+
| connection_name | parameters                                                       | is_default |
|-----------------+------------------------------------------------------------------+------------|
| myconnection    | {'account': 'myaccount', 'user': 'jondoe', 'password': '****',   | False      |
|                 | 'database': 'my_db', 'schema': 'my_schema', 'warehouse':         |            |
|                 | 'my-wh'}                                                         |            |
| myconnection2   | {'account': 'myaccount2', 'user': 'jdoe2'}                       | False      |
+-------------------------------------------------------------------------------------------------+

