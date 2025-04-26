-- Example 26172
SHOW FAILOVER GROUPS;

-- Example 26173
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 26174
Replication group "<GROUP_NAME>" cannot currently be set as primary because it is being
refreshed. Either wait for the refresh to finish or cancel the refresh and try again.

-- Example 26175
ALTER FAILOVER GROUP myfg SUSPEND;

-- Example 26176
ALTER FAILOVER GROUP myfg SUSPEND IMMEDIATE;

-- Example 26177
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name <> 'COMPLETED' and phase_name <> 'CANCELED';

-- Example 26178
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name = 'CANCELED';

-- Example 26179
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 26180
ALTER FAILOVER GROUP myfg RESUME;

-- Example 26181
SELECT phase_name, start_time, end_time
  FROM TABLE(
    INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('myfg')
  );

-- Example 26182
SELECT query_id, query_text
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
  WHERE query_type = 'REFRESH REPLICATION GROUP'
  AND execution_status = 'RUNNING'
  ORDER BY start_time;

-- Example 26183
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name <> 'COMPLETED' and phase_name <> 'CANCELED';

-- Example 26184
SELECT SYSTEM$CANCEL_QUERY('<QUERY_ID | JOB_UUID>');

-- Example 26185
query [<QUERY_ID>] terminated.

-- Example 26186
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 26187
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 26188
DESC STORAGE INTEGRATION <integration_name>;

-- Example 26189
GRANT CREATE STAGE ON SCHEMA public TO ROLE myrole;

GRANT USAGE ON INTEGRATION azure_int TO ROLE myrole;

-- Example 26190
USE SCHEMA mydb.public;

CREATE STAGE my_azure_stage
  STORAGE_INTEGRATION = azure_int
  URL = 'azure://myaccount.blob.core.windows.net/container1/path1'
  FILE_FORMAT = my_csv_format;

-- Example 26191
CREATE OR REPLACE STAGE my_azure_stage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/load/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = my_csv_format;

-- Example 26192
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

-- Example 26193
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 26194
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 26195
DESC INTEGRATION <integration_name>;

-- Example 26196
DESC INTEGRATION s3_int;

-- Example 26197
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

-- Example 26198
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

-- Example 26199
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26200
directoryTable (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 26201
USE SCHEMA mydb.public;

-- Example 26202
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  );

-- Example 26203
DESC STAGE <stage_name>;

-- Example 26204
DESC STAGE mystage;

-- Example 26205
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26206
ALTER STAGE mystage REFRESH;

-- Example 26207
select system$get_aws_sns_iam_policy('<sns_topic_arn>');

-- Example 26208
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 26209
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

-- Example 26210
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

-- Example 26211
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

-- Example 26212
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

-- Example 26213
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26214
directoryTable (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ AWS_SNS_TOPIC = '<sns_topic_arn>' ] ) ]

-- Example 26215
USE SCHEMA mydb.public;

-- Example 26216
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket'
  );

-- Example 26217
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26218
ALTER STAGE mystage REFRESH;

-- Example 26219
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 26220
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 26221
DESC STORAGE INTEGRATION <integration_name>;

-- Example 26222
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 26223
$ gsutil notification create -t <topic> -f json -e OBJECT_FINALIZE -e OBJECT_DELETE gs://<bucket-name>

-- Example 26224
CREATE NOTIFICATION INTEGRATION <integration_name>
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>';

-- Example 26225
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

-- Example 26226
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 26227
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 26228
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 26229
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 26230
directoryTable ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 26231
USE SCHEMA mydb.public;

-- Example 26232
CREATE STAGE mystage
  URL='gcs://mybucket/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 26233
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 26234
ALTER STAGE mystage REFRESH;

-- Example 26235
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 26236
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 26237
DESC STORAGE INTEGRATION <integration_name>;

-- Example 26238
az group create --name <resource_group_name> --location <location>

