-- Example 26239
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

-- Example 26240
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind BlobStorage --access-tier Hot

-- Example 26241
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind StorageV2

-- Example 26242
az storage queue create --name <storage_queue_name> --account-name <storage_account_name>

-- Example 26243
export storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queueid="$queuestorageid/queueservices/default/queues/<storage_queue_name>"

-- Example 26244
set storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queueid="%queuestorageid%/queueservices/default/queues/<storage_queue_name>"

-- Example 26245
az extension add --name eventgrid

-- Example 26246
az eventgrid event-subscription create \
--source-resource-id $storageid \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint $queueid \
--advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 26247
az eventgrid event-subscription create \
--source-resource-id %storageid% \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint %queueid% \
-advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 26248
https://<storage_account_name>.queue.core.windows.net/<storage_queue_name>

-- Example 26249
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';

-- Example 26250
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://myqueue.queue.core.windows.net/mystoragequeue'
  AZURE_TENANT_ID = 'a123bcde-1234-5678-abc1-9abc12345678';

-- Example 26251
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 26252
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26253
directoryTable (for Microsoft Azure) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 26254
USE SCHEMA mydb.public;

-- Example 26255
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 26256
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26257
ALTER STAGE mystage REFRESH;

-- Example 26258
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 26259
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 26260
DESC STORAGE INTEGRATION <integration_name>;

-- Example 26261
az group create --name <resource_group_name> --location <location>

-- Example 26262
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

-- Example 26263
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind BlobStorage --access-tier Hot

-- Example 26264
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind StorageV2

-- Example 26265
az storage queue create --name <storage_queue_name> --account-name <storage_account_name>

-- Example 26266
export storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queueid="$queuestorageid/queueservices/default/queues/<storage_queue_name>"

-- Example 26267
set storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queueid="%queuestorageid%/queueservices/default/queues/<storage_queue_name>"

-- Example 26268
az extension add --name eventgrid

-- Example 26269
az eventgrid event-subscription create \
--source-resource-id $storageid \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint $queueid \
--advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit

-- Example 26270
az eventgrid event-subscription create \
--source-resource-id %storageid% \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint %queueid% \
-advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit

-- Example 26271
https://<storage_account_name>.queue.core.windows.net/<storage_queue_name>

-- Example 26272
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';

-- Example 26273
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://myqueue.queue.core.windows.net/mystoragequeue'
  AZURE_TENANT_ID = 'a123bcde-1234-5678-abc1-9abc12345678';

-- Example 26274
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 26275
USE SCHEMA snowpipe_db.public;

CREATE STAGE mystage
  URL = 'azure://myaccount.blob.core.windows.net/mycontainer/load/files/'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 26276
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = true
  INTEGRATION = 'MY_NOTIFICATION_INT'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 26277
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::1234567898012:user/development/development_user"
      },
      "Action": "sts:AssumeRole",
      "Condition": {"StringEquals": { "sts:ExternalId": "EXTERNAL_FUNCTIONS_SFCRole=3_8Hcmbi9halFOkt+MdilPi7rdgOv=" }}
    }
  ]
}

-- Example 26278
securityDefinitions:
  <security-def-name>:
    authorizationUrl: ""
    flow: "implicit"
    type: "oauth2"
    x-google-issuer: "<gmail service account>"
    x-google-jwks_uri: "https://www.googleapis.com/robot/v1/metadata/x509/<gmail service account>"

-- Example 26279
security:
  - <security-def-name>: []

-- Example 26280
security:
  - snowflakeAccess01: []

-- Example 26281
swagger: '2.0'
info:
  title: API Gateway config for Snowflake external function
  description: This configuration file connects the API Gateway resource to the remote service (Cloud Function).
  version: 1.0.0
securityDefinitions:
  snowflakeAccess01:
    authorizationUrl: ""
    flow: "implicit"
    type: "oauth2"
    x-google-issuer: "<API_GCP_SERVICE_ACCOUNT>"
    x-google-jwks_uri: "https://www.googleapis.com/robot/v1/metadata/x509/<API_GCP_SERVICE_ACCOUNT>"
schemes:
  - https
produces:
  - application/json
paths:
  /demo-func-resource:
    post:
      summary: Echo the input
      operationId: operationID
      security:
        - snowflakeAccess01: []
      x-google-backend:
        address: <Cloud Function Trigger URL>
        protocol: h2
      responses:
        '200':
          description: <DESCRIPTION>
          schema:
            type: string

-- Example 26282
describe api integration <integration_name>;

-- Example 26283
https://login.microsoftonline.com/<tenant_id>/oauth2/authorize?client_id=<snowflake_application_id>&response_type=code

-- Example 26284
use role accountadmin;
create role if not exists okta_provisioner;
grant create user on account to role okta_provisioner;
grant create role on account to role okta_provisioner;
grant role okta_provisioner to role accountadmin;
create or replace security integration okta_provisioning
    type = scim
    scim_client = 'okta'
    run_as_role = 'OKTA_PROVISIONER';
select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 26285
use role accountadmin;

-- Example 26286
create role if not exists okta_provisioner;
grant create user on account to role okta_provisioner;
grant create role on account to role okta_provisioner;

-- Example 26287
grant role okta_provisioner to role accountadmin;
create or replace security integration okta_provisioning
    type = scim
    scim_client = 'okta'
    run_as_role = 'OKTA_PROVISIONER';

-- Example 26288
select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 26289
use role accountadmin;
grant ownership on user <user_name> to role okta_provisioner;

-- Example 26290
alter security integration okta_provisioning set network_policy = <scim_network_policy>;

-- Example 26291
alter security integration okta_provisioning unset network_policy;

-- Example 26292
grant ownership on user <username> to role OKTA_PROVISIONER;

-- Example 26293
use role accountadmin;
use database demo_db;
use schema information_schema;
select * from table(rest_event_history('scim'));
select *
    from table(rest_event_history(
        'scim',
        dateadd('minutes',-5,current_timestamp()),
        current_timestamp(),
        200))
    order by event_timestamp;

-- Example 26294
Error authenticating: Forbidden. Errors reported by remote server: Invalid JSON: Unexpected character ('<' (code 60)): expected a valid value (number, String, array, object, 'true', 'false' or 'null') at [Source: java.io.StringReader@4c76ba04; line: 1, column: 2]

-- Example 26295
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

-- Example 26296
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

-- Example 26297
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 26298
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 26299
DESC INTEGRATION <integration_name>;

-- Example 26300
DESC INTEGRATION s3_int;

-- Example 26301
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

-- Example 26302
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

-- Example 26303
GRANT CREATE STAGE ON SCHEMA public TO ROLE myrole;

GRANT USAGE ON INTEGRATION s3_int TO ROLE myrole;

-- Example 26304
USE SCHEMA mydb.public;

CREATE STAGE my_s3_stage
  STORAGE_INTEGRATION = s3_int
  URL = 's3://bucket1/path1/'
  FILE_FORMAT = my_csv_format;

-- Example 26305
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

