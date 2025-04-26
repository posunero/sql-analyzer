-- Example 25368
split [-a suffix_length] [-b byte_count[k|m]] [-l line_count] [-p pattern] [file [name]]

-- Example 25369
split -l 100000 pagecounts-20151201.csv pages

-- Example 25370
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_02');

-- Example 25371
CREATE OR REPLACE TABLE my_table (
  c1 VARCHAR(134217728),
  c2 BINARY(67108864));

-- Example 25372
ALTER TABLE my_table ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

-- Example 25373
CREATE OR REPLACE TABLE my_table (c1 VARIANT);

-- Example 25374
CREATE OR REPLACE FUNCTION udf_varchar(g1 VARCHAR)
  RETURNS VARCHAR
  AS $$
    'Hello' || g1
  $$;

-- Example 25375
ALTER ICEBERG TABLE my_iceberg_table ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

-- Example 25376
100067 (54000): The data length in result column <column_name> is not supported by this version of the client.
Actual length <actual_size> exceeds supported length of 16777216.

-- Example 25377
Max LOB size (16777216) exceeded

-- Example 25378
COPY INTO <table>
  FROM @~/<file>.json
  FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY = true);

-- Example 25379
{
  "ID": 1,
  "CustomerDetails": {
    "RegistrationDate": 158415500,
    "FirstName": "John",
    "LastName": "Doe",
    "Events": [
      {
        "Type": "LOGIN",
        "Time": 1584158401,
        "EventID": "NZ0000000001"
      },
      /* ... */
      /* this array contains thousands of elements */
      /* with total size exceeding 16 MB */
      /* ... */
      {
        "Type": "LOGOUT",
        "Time": 1584158402,
        "EventID": "NZ0000000002"
      }
    ]
  }
}

-- Example 25380
CREATE OR REPLACE TABLE mytable AS
  SELECT
    t1.$1:ID AS id,
    t1.$1:CustomerDetails:RegistrationDate::VARCHAR AS RegistrationDate,
    t1.$1:CustomerDetails:FirstName::VARCHAR AS First_Name,
    t1.$1:CustomerDetails:LastName::VARCHAR AS as Last_Name,
    t2.value AS Event
  FROM @json t1,
    TABLE(FLATTEN(INPUT => $1:CustomerDetails:Events)) t2;

-- Example 25381
+----+-------------------+------------+------------+------------------------------+
| ID | REGISTRATION_DATE | FIRST_NAME | LAST_NAME  | EVENT                        |
|----+-------------------+------------+------------+------------------------------|
| 1  | 158415500         | John       | Doe        | {                            |
|    |                   |            |            |   "EventID": "NZ0000000001", |
|    |                   |            |            |   "Time": 1584158401,        |
|    |                   |            |            |   "Type": "LOGIN"            |
|    |                   |            |            | }                            |
|                     ... thousands of rows ...                                   |
| 1  | 158415500         | John       | Doe        | {                            |
|    |                   |            |            |   "EventID": "NZ0000000002", |
|    |                   |            |            |   "Time": 1584158402,        |
|    |                   |            |            |   "Type": "LOGOUT"           |
|    |                   |            |            | }                            |
+----+-------------------+------------+------------+------------------------------+

-- Example 25382
CREATE OR REPLACE TABLE mytable (
  id VARCHAR,
  registration_date VARCHAR(16777216),
  first_name VARCHAR(16777216),
  last_name VARCHAR(16777216),
  event VARCHAR(16777216));

INSERT INTO mytable
  SELECT
    t1.$1:ID,
    t1.$1:CustomerDetails:RegistrationDate::VARCHAR,
    t1.$1:CustomerDetails:FirstName::VARCHAR,
    t1.$1:CustomerDetails:LastName::VARCHAR,
    t2.value
  FROM @json t1,
    TABLE(FLATTEN(INPUT => $1:CustomerDetails:Events)) t2;

-- Example 25383
<?xml version='1.0' encoding='UTF-8'?>
<osm version="0.6" generator="osmium/1.14.0">
  <node id="197798" version="17" timestamp="2021-09-06T17:01:27Z" />
  <node id="197824" version="7" timestamp="2021-08-04T23:17:18Z" >
    <tag k="highway" v="traffic_signals"/>
  </node>
  <!--  thousands of node elements with total size exceeding 16 MB -->
  <node id="197826" version="4" timestamp="2021-08-04T16:43:28Z" />
</osm>

-- Example 25384
CREATE OR REPLACE TABLE mytable AS
  SELECT
    value:"@id" AS id,
    value:"@version" AS version,
    value:"@timestamp"::datetime AS TIMESTAMP,
    value:"$" AS tags
  FROM @mystage,
    LATERAL FLATTEN(INPUT => $1:"$")
  WHERE value:"@" = 'node';

-- Example 25385
+--------+---------+-------------------------+---------------------------------------------+
| ID     | VERSION | TIMESTAMP               | TAGS                                        |
|--------+---------+-------------------------+---------------------------------------------|
| 197798 | 17      | 2021-09-06 17:01:27.000 | ""                                          |
| 197824 | 7       | 2021-08-04 23:17:18.000 | <tag k="highway" v="traffic_signals"></tag> |
|                   ... thousands of rows ...                                              |
| 197826 | 4       | 2021-08-04 16:43:28.000 | ""                                          |
+--------+---------+-------------------------+---------------------------------------------+

-- Example 25386
CREATE OR REPLACE TABLE mytable AS
  SELECT
    ST_SIMPLIFY($1:geo, 10) AS geo
  FROM @mystage;

-- Example 25387
CREATE OR REPLACE TABLE mytable (
  id VARCHAR,
  registration_date VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR);

COPY INTO mytable (
  id,
  registration_date,
  first_name,
  last_name
) FROM (
    SELECT
      $1:ID,
      $1:CustomerDetails::OBJECT:RegistrationDate::VARCHAR,
      $1:CustomerDetails::OBJECT:FirstName::VARCHAR,
      $1:CustomerDetails::OBJECT:LastName::VARCHAR
    FROM @mystage
);

-- Example 25388
{"foo":1}

-- Example 25389
{"foo":"1"}

-- Example 25390
CREATE STAGE my_stage URL='s3://mybucket/United_States/California/Los_Angeles/' CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z');

-- Example 25391
PUT file:///data/mydata.csv @%t1/United_States/California/Los_Angeles/2016/06/01/11/

-- Example 25392
COPY INTO t1 from @%t1/United_States/California/Los_Angeles/2016/06/01/11/mydata;

-- Example 25393
COPY INTO t1 from @%t1/United_States/California/Los_Angeles/2016/06/01/11/
  FILES=('mydata1.csv', 'mydata1.csv');

COPY INTO t1 from @%t1/United_States/California/Los_Angeles/2016/06/01/11/
  PATTERN='.*mydata[^[0-9]{1,3}$$].csv';

-- Example 25394
COPY INTO load1 FROM @%load1/data1/ FILES=('test1.csv', 'test2.csv', 'test3.csv')

-- Example 25395
COPY INTO people_data FROM @%people_data/data1/
   PATTERN='.*person_data[^0-9{1,3}$$].csv';

-- Example 25396
"value1", "value2", "value3"

-- Example 25397
COPY INTO mytable
FROM @%mytable
FILE_FORMAT = (TYPE = CSV TRIM_SPACE=true FIELD_OPTIONALLY_ENCLOSED_BY = '0x22');

SELECT * FROM mytable;

+--------+--------+--------+
| col1   | col2   | col3   |
+--------+--------+--------+
| value1 | value2 | value3 |
+--------+--------+--------+

-- Example 25398
PUT file:///tmp/file_20160701.11*.csv @my_stage/<application_one>/<location_one>/2016/07/01/11/;

-- Example 25399
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 25400
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 25401
DESC STORAGE INTEGRATION <integration_name>;

-- Example 25402
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 25403
$ gsutil notification create -t <topic> -f json -e OBJECT_FINALIZE gs://<bucket-name>

-- Example 25404
CREATE NOTIFICATION INTEGRATION <integration_name>
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>';

-- Example 25405
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

-- Example 25406
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 25407
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 25408
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 25409
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 25410
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = true
  INTEGRATION = 'MY_NOTIFICATION_INT'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage/path2;

-- Example 25411
{"executionState":"<value>","oldestFileTimestamp":<value>,"pendingFileCount":<value>,"notificationChannelName":"<value>","numOutstandingMessagesOnChannel":<value>,"lastReceivedMessageTimestamp":"<value>","lastForwardedMessageTimestamp":"<value>","error":<value>,"fault":<value>}

-- Example 25412
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 25413
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 25414
DESC STORAGE INTEGRATION <integration_name>;

-- Example 25415
az group create --name <resource_group_name> --location <location>

-- Example 25416
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

-- Example 25417
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind BlobStorage --access-tier Hot

-- Example 25418
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind StorageV2

-- Example 25419
az storage queue create --name <storage_queue_name> --account-name <storage_account_name>

-- Example 25420
export storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queueid="$queuestorageid/queueservices/default/queues/<storage_queue_name>"

-- Example 25421
set storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queueid="%queuestorageid%/queueservices/default/queues/<storage_queue_name>"

-- Example 25422
az extension add --name eventgrid

-- Example 25423
az eventgrid event-subscription create \
--source-resource-id $storageid \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint $queueid \
--advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit

-- Example 25424
az eventgrid event-subscription create \
--source-resource-id %storageid% \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint %queueid% \
-advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit

-- Example 25425
https://<storage_account_name>.queue.core.windows.net/<storage_queue_name>

-- Example 25426
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';

-- Example 25427
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://myqueue.queue.core.windows.net/mystoragequeue'
  AZURE_TENANT_ID = 'a123bcde-1234-5678-abc1-9abc12345678';

-- Example 25428
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 25429
USE SCHEMA snowpipe_db.public;

CREATE STAGE mystage
  URL = 'azure://myaccount.blob.core.windows.net/mycontainer/load/files/'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 25430
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = true
  INTEGRATION = 'MY_NOTIFICATION_INT'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 25431
pip install snowflake-ingest

-- Example 25432
create pipe mydb.myschema.mypipe if not exists as copy into mydb.myschema.mytable from @mydb.myschema.mystage;

-- Example 25433
-- Create a role for the Snowpipe privileges.
use role securityadmin;

create or replace role snowpipe1;

-- Grant the USAGE privilege on the database and schema that contain the pipe object.
grant usage on database mydb to role snowpipe1;
grant usage on schema mydb.myschema to role snowpipe1;

-- Grant the INSERT and SELECT privileges on the target table.
grant insert, select on mydb.myschema.mytable to role snowpipe1;

-- Grant the USAGE privilege on the external stage.
grant usage on stage mydb.myschema.mystage to role snowpipe1;

-- Grant the OPERATE and MONITOR privileges on the pipe object.
grant operate, monitor on pipe mydb.myschema.mypipe to role snowpipe1;

-- Grant the role to a user
grant role snowpipe1 to user jsmith;

-- Set the role as the default role for the user
alter user jsmith set default_role = snowpipe1;

-- Example 25434
from __future__ import print_function
from snowflake.ingest import SimpleIngestManager
from snowflake.ingest import StagedFile
from requests import HTTPError
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.hazmat.primitives.serialization import Encoding
from cryptography.hazmat.primitives.serialization import PrivateFormat
from cryptography.hazmat.primitives.serialization import NoEncryption
from cryptography.hazmat.backends import default_backend

import os

with open("./rsa_key.p8", 'rb') as pem_in:
  pemlines = pem_in.read()
  private_key_obj = load_pem_private_key(pemlines,
  os.environ['PRIVATE_KEY_PASSPHRASE'].encode(),
  default_backend())

private_key_text = private_key_obj.private_bytes(
  Encoding.PEM, PrivateFormat.PKCS8, NoEncryption()).decode('utf-8')
# Assume the public key has been registered in Snowflake:
# private key in PEM format

# List of files in the stage specified in the pipe definition
ingest_manager = SimpleIngestManager(account='<account_identifier>',
                   host='<account_identifier>.snowflakecomputing.com',
                   user='<user_login_name>',
                   pipe='<db_name>.<schema_name>.<pipe_name>',
                   private_key=private_key_text)

def handler(event, context):
  for record in event['Records']:
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']

    print("Bucket: " + bucket + " Key: " + key)
    # List of files in the stage specified in the pipe definition
    # wrapped into a class
    staged_file_list = []
    staged_file_list.append(StagedFile(key, None))

    print('Pushing file list to ingest REST API')
    resp = ingest_manager.ingest_files(staged_file_list)

