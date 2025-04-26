-- Example 29521
SELECT ... FROM my_table
JOIN TABLE(FLATTEN(input=>[col_a]))
ON ... ;
SELECT ... FROM my_table
INNER JOIN TABLE(FLATTEN(input=>[col_a]))
ON ... ;
SELECT ... FROM my_table
JOIN TABLE(my_js_udtf(col_a))
ON ...;
SELECT ... FROM my_table
INNER JOIN TABLE(my_js_udtf(col_a))
ON ... ;

-- Example 29522
SELECT ... FROM my_table
LEFT JOIN TABLE(FLATTEN(input=>[col_a]))
ON ... ;
SELECT ... FROM my_table
FULL JOIN TABLE(FLATTEN(input=>[col_a]))
ON ... ;
SELECT ... FROM my_table
LEFT JOIN TABLE(my_js_udtf(col_a))
ON ... ;
SELECT ... FROM my_table
FULL JOIN TABLE(my_js_udtf(col_a))
ON ... ;

-- Example 29523
000002 (0A000): Unsupported feature 'lateral table function called with
    OUTER JOIN syntax or a join predicate (ON clause)'

-- Example 29524
SELECT ... FROM <table>,
    TABLE(<ptable_function_other_than_sql_udtf>) ... ;

-- Example 29525
SELECT ... FROM my_table,
TABLE(FLATTEN(input=>[col_a]));

-- Example 29526
SELECT ... FROM <table>
[{ [ INNER  | { LEFT | RIGHT | FULL } [ OUTER ] | CROSS } JOIN
TABLE(<table_function_other_than_sql_udtf>) ...;

-- Example 29527
SELECT ... FROM my_table
FULL JOIN TABLE(FLATTEN(input=>[col_a]));
SELECT ... FROM my_table
LEFT JOIN OUTER TABLE(FLATTEN(input=>[col_a]));

-- Example 29528
SELECT * FROM <db_name>.INFORMATION_SCHEMA.PACKAGE
    WHERE LANGUAGE = 'python' AND RUNTIME_VERSION='3.9';

-- Example 29529
CREATE DATABASE <name> AS REPLICA OF <primary_database_name>
    WITH TAG (tag_name = 'tag_value');

-- Example 29530
ALTER ( { FAILOVER | REPLICATION } ) GROUP <rg_name> REFRESH FORCE;

-- Example 29531
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('<rg_name>');

-- Example 29532
FAILURE: SQL access control error:
Insufficient privileges to operate on schema '<schema_name>'

-- Example 29533
SELECT 1 AS a, 2 AS a_1, 3 AS a;
+---+-----+---+
| A | A_1 | A |
|---+-----+---|
| 1 |   2 | 3 |
+---+-----+---+
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
+---+-----+-----+
| A | A_1 | A_1 |
|---+-----+-----|
| 1 |   2 |   3 |
+---+-----+-----+

-- Example 29534
SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));
+---+-----+-----+
| A | A_1 | A_2 |
|---+-----+-----|
| 1 |   2 |   3 |
+---+-----+-----+

-- Example 29535
-- One stored procedure
CREATE OR REPLACE PROCEDURE proc(STRARG1 varchar, STRARG2 varchar)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  return 'hello';
END
$$;
-- Another procedure
CREATE OR REPLACE PROCEDURE proc(ARG1 number, ARG2 number)
RETURNS BOOLEAN
LANGUAGE SQL
AS
$$
BEGIN
  return ARG1 < ARG2;
END
$$;
-- Example A
-- Before: returns 'hello'
-- After: returns TRUE
CALL PROC(ARG1 => '5', ARG2 => '100');
-- Example B
-- Before: returns TRUE
-- After: returns 'hello'
CALL PROC(STRARG1 => 5, STRARG2 => 100); -- 'hello'.

-- Example 29536
SnowflakeFile sfFile = SnowflakeFile.newInstance(file_url);
InputStream is = sfFile.getInputStream();

-- Example 29537
SnowflakeFile sfFile = SnowflakeFile.newInstance(scopedFileUrl);
InputStream is = sfFile.getInputStream();

-- Example 29538
String filename = "@my_stage/filename.txt";
SnowflakeFile sfFile = SnowflakeFile.newInstance(filename, require_scoped_url = false);

-- Example 29539
grant reference_usage on database mydb to role r1;
grant modify, reference_usage on database mydb to role r1;
grant all privileges on database mydb to role r1;

-- Example 29540
SELECT ARRAY_POSITION(NULL, [10, NULL, 30]);

+--------------------------------------+
| ARRAY_POSITION(NULL, [10, NULL, 30]) |
|--------------------------------------|
|                                 NULL |
+--------------------------------------+

-- Example 29541
SELECT ARRAY_POSITION(NULL, [10, NULL, 30]);
+--------------------------------------+
| ARRAY_POSITION(NULL, [10, NULL, 30]) |
|--------------------------------------|
|                                    1 |
+--------------------------------------+

-- Example 29542
SF_AUTH_SOCKET_PORT=3037 SNOWFLAKE_AUTH_SOCKET_REUSE_PORT=true poetry run python somescript.py

-- Example 29543
[prod]
account = "my_account"
user = "my_user"
password = "my_password"

-- Example 29544
python -c "from snowflake.connector.constants import CONNECTIONS_FILE; print(str(CONNECTIONS_FILE))"

-- Example 29545
schema.create_or_update(schema_def, with_managed_access = True)

-- Example 29546
df = df.select(col("a").alias("b"))
df = copy(df)
df.select(col("b").alias("c"))  # Threw an error. Now it's fixed.

-- Example 29547
warehouse_name = '<connector warehouse name>' AND role_name = 'APP_PRIMARY'

-- Example 29548
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    '<application_instance_name>.cortex.search_service',
      '{
        "query": "<your_question>",
         "columns": ["chunk", "web_url"],
         "filter": {"@contains": {"user_emails": "<user_emailID>"} },
         "limit": <number_of_results>
       }'
   )
)['results'] AS results

-- Example 29549
SELECT PARSE_JSON(
     SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
          '<application_instance_name>.cortex.search_service',
          '{
             "query": "What is my vacation carry over policy?",
             "columns": ["chunk", "web_url"],
             "filter": {"@contains": {"user_emails": "<user_emailID>"} },
             "limit": 1
          }'
     )
 )['results'] AS results

-- Example 29550
import snowflake.snowpark as snowpark
from snowflake.snowpark import Session
from snowflake.core import Root

def main(session: snowpark.Session):

   root = Root(session)

   # fetch service
   my_service = (root
     .databases["<application_instance_name>"]
     .schemas["cortex"]
     .cortex_search_services["search_service"]
   )

   # query service
   resp = my_service.search(
     query="What is my vacation carry over policy?",
     columns = ["chunk", "web_url"],
     filter = {"@contains": {"user_emails": "<user_emailID>"} },
     limit=1
   )
   return (resp.to_json())

-- Example 29551
curl --location "https://<account_url>/api/v2/databases/<application_instance_name>/schemas/cortex/cortex-search-services/search_service" \
     --header 'Content-Type: application/json' \
     --header 'Accept: application/json' \
     --header "Authorization: Bearer <CORTEX_SEARCH_JWT>" \
     --data '{
         "query": "What is my vacation carry over policy?",
         "columns": ["chunk", "web_url"],
         "limit": 1
     }'

-- Example 29552
{
  "results" : [ {
  "web_url" : "https://<domain>.sharepoint.com/sites/<site_name>/<path_to_file>",
  "chunk" : "Answer to the question asked."
  } ]
}

-- Example 29553
CALL PUBLIC.REFRESH_SHAREPOINT_CONTENT();

-- Example 29554
SELECT * FROM <APPLICATION_INSTANCE_DATABASE>.PUBLIC.CONNECTOR_CONFIGURATION;
SELECT * FROM <APPLICATION_INSTANCE_DATABASE>.PUBLIC.CONNECTOR_ERRORS;
SELECT * FROM <APPLICATION_INSTANCE_DATABASE>.PUBLIC.SYNC_STATUS;

-- Example 29555
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 29556
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 29557
DESC STORAGE INTEGRATION <integration_name>;

-- Example 29558
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 29559
$ gsutil notification create -t <topic> -f json -e OBJECT_FINALIZE -e OBJECT_DELETE gs://<bucket-name>

-- Example 29560
CREATE NOTIFICATION INTEGRATION <integration_name>
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>';

-- Example 29561
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

-- Example 29562
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 29563
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 29564
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 29565
-- External stage
CREATE [ OR REPLACE ] [ TEMPORARY ] STAGE [ IF NOT EXISTS ] <external_stage_name>
      <cloud_storage_access_settings>
    [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
    [ directoryTable ]
    [ COPY_OPTIONS = ( copyOptions ) ]
    [ COMMENT = '<string_literal>' ]

-- Example 29566
directoryTable ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 29567
USE SCHEMA mydb.public;

-- Example 29568
CREATE STAGE mystage
  URL='gcs://mybucket/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 29569
ALTER STAGE [ IF EXISTS ] <name> REFRESH [ SUBPATH = '<relative-path>' ]

-- Example 29570
ALTER STAGE mystage REFRESH;

-- Example 29571
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('azure://<account>.blob.core.windows.net/<container>/<path>/', 'azure://<account>.blob.core.windows.net/<container>/<path>/') ]

-- Example 29572
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer1/mypath1/sensitivedata/', 'azure://myaccount.blob.core.windows.net/mycontainer2/mypath2/sensitivedata/');

-- Example 29573
DESC STORAGE INTEGRATION <integration_name>;

-- Example 29574
az group create --name <resource_group_name> --location <location>

-- Example 29575
az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

-- Example 29576
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind BlobStorage --access-tier Hot

-- Example 29577
az storage account create --resource-group <resource_group_name> --name <storage_account_name> --sku Standard_LRS --location <location> --kind StorageV2

-- Example 29578
az storage queue create --name <storage_queue_name> --account-name <storage_account_name>

-- Example 29579
export storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
export queueid="$queuestorageid/queueservices/default/queues/<storage_queue_name>"

-- Example 29580
set storageid=$(az storage account show --name <data_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queuestorageid=$(az storage account show --name <queue_storage_account_name> --resource-group <resource_group_name> --query id --output tsv)
set queueid="%queuestorageid%/queueservices/default/queues/<storage_queue_name>"

-- Example 29581
az extension add --name eventgrid

-- Example 29582
az eventgrid event-subscription create \
--source-resource-id $storageid \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint $queueid \
--advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 29583
az eventgrid event-subscription create \
--source-resource-id %storageid% \
--name <subscription_name> --endpoint-type storagequeue \
--endpoint %queueid% \
-advanced-filter data.api stringin CopyBlob PutBlob PutBlockList FlushWithClose SftpCommit DeleteBlob DeleteFile SftpRemove

-- Example 29584
https://<storage_account_name>.queue.core.windows.net/<storage_queue_name>

-- Example 29585
CREATE NOTIFICATION INTEGRATION <integration_name>
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';

