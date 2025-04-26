-- Example 25971
from snowflake import snowpark
from snowflake.ml import dataset

# Create Snowpark Session
# See https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-session
session = snowpark.Session.builder.configs(connection_parameters).create()

# Create a Snowpark DataFrame to serve as a data source
# In this example, we generate a random table with 100 rows and 1 column
df = session.sql(
  "select uniform(0, 10, random(1)) as x, uniform(0, 10, random(2)) as y from table(generator(rowcount => 100))"
)

# Materialize DataFrame contents into a Dataset
ds1 = dataset.create_from_dataframe(
    session,
    "my_dataset",
    "version1",
    input_dataframe=df)

-- Example 25972
# Inspect currently selected version
print(ds1.selected_version) # DatasetVersion(dataset='my_dataset', version='version1')
print(ds1.selected_version.created_on) # Prints creation timestamp

# List all versions in the Dataset
print(ds1.list_versions()) # ["version1"]

# Create a new version
ds2 = ds1.create_version("version2", df)
print(ds1.selected_version.name)  # "version1"
print(ds2.selected_version.name)  # "version2"
print(ds1.list_versions())        # ["version1", "version2"]

# selected_version is immutable, meaning switching versions with
# ds1.select_version() returns a new Dataset object without
# affecting ds1.selected_version
ds3 = ds1.select_version("version2")
print(ds1.selected_version.name)  # "version1"
print(ds3.selected_version.name)  # "version2"

-- Example 25973
import tensorflow as tf

# Convert Snowflake Dataset to TensorFlow Dataset
tf_dataset = ds1.read.to_tf_dataset(batch_size=32)

# Train a TensorFlow model
for batch in tf_dataset:
    # Extract and build tensors as needed
    input_tensor = tf.stack(list(batch.values()), axis=-1)

    # Forward pass (details not included for brevity)
    outputs = model(input_tensor)

-- Example 25974
import torch

# Convert Snowflake Dataset to PyTorch DataPipe
pt_datapipe = ds1.read.to_torch_datapipe(batch_size=32)

# Train a PyTorch model
for batch in pt_datapipe:
    # Extract and build tensors as needed
    input_tensor = torch.stack([torch.from_numpy(v) for v in batch.values()], dim=-1)

    # Forward pass (details not included for brevity)
    outputs = model(input_tensor)

-- Example 25975
from snowflake.ml.modeling.ensemble import random_forest_regressor

# Get a Snowpark DataFrame
ds_df = ds1.read.to_snowpark_dataframe()

# Note ds_df != df
ds_df.explain()
df.explain()

# Train a model in Snowpark ML
xgboost_model = random_forest_regressor.RandomForestRegressor(
    n_estimators=100,
    random_state=42,
    input_cols=["X"],
    label_cols=["Y"],
)
xgboost_model.fit(ds_df)

-- Example 25976
print(ds1.read.files()) # ['snow://dataset/my_dataset/versions/version1/data_0_0_0.snappy.parquet']

import pyarrow.parquet as pq
pd_ds = pq.ParquetDataset(ds1.read.files(), filesystem=ds1.read.filesystem())

import dask.dataframe as dd
dd_df = dd.read_parquet(ds1.read.files(), filesystem=ds1.read.filesystem())

-- Example 25977
LIST 'snow://dataset/<dataset_name>/versions/<dataset_version>'

-- Example 25978
INFER_SCHEMA(
  LOCATION => 'snow://dataset/<dataset_name>/versions/<dataset_version>',
  FILE_FORMAT => '<file_format_name>'
)

-- Example 25979
CREATE FILE FORMAT my_parquet_format TYPE = PARQUET;

SELECT *
FROM TABLE(
    INFER_SCHEMA(
        FILE_FORMAT => 'snow://dataset/MYDS/versions/v1,
        FILE_FORMAT => 'my_parquet_format'
    )
);

-- Example 25980
SELECT $1
FROM 'snow://dataset/foo/versions/V1'
( FILE_FORMAT => 'my_parquet_format',
PATTERN => '.*data.*' ) t;

-- Example 25981
yyyy-mm-dd hh:mm:ss.nnn n.s.c.jdbc.SnowflakeSQLException FINE <init>:40 -
Snowflake exception: JWT token is invalid. [0ce9eb56-821d-4ca9-a774-04ae89a0cf5a],
sqlState:08001, vendorCode:390,144, queryId:

-- Example 25982
SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('0ce9eb56-821d-4ca9-a774-04ae89a0cf5a'), 'errorCode');

-- Example 25983
[connections.myconnection]
account = "myaccount"
user = "jondoe"
password = "password"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 25984
default_connection_name = "myconnection"

[connections.myconnection]
account = "myaccount"
...

-- Example 25985
chown $USER config.toml
chmod 0600 config.toml

-- Example 25986
snow connection add

-- Example 25987
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

-- Example 25988
snow --config-file config.toml connection add -n myconnection2 --account myaccount2 --user jdoe2

-- Example 25989
snow connection add -n myconnection2 --user jdoe2 --no-interactive

-- Example 25990
snow connection list

-- Example 25991
+-------------------------------------------------------------------------------------------------+
| connection_name | parameters                                                       | is_default |
|-----------------+------------------------------------------------------------------+------------|
| myconnection    | {'account': 'myaccount', 'user': 'jondoe', 'password': '****',   | False      |
|                 | 'database': 'my_db', 'schema': 'my_schema', 'warehouse':         |            |
|                 | 'my-wh'}                                                         |            |
| myconnection2   | {'account': 'myaccount2', 'user': 'jdoe2'}                       | False      |
+-------------------------------------------------------------------------------------------------+

-- Example 25992
snow connection test -c myconnection2

-- Example 25993
+--------------------------------------------------+
| key             | value                          |
|-----------------+--------------------------------|
| Connection name | myconnection2                  |
| Status          | OK                             |
| Host            | example.snowflakecomputing.com |
| Account         | myaccount2                     |
| User            | jdoe2                          |
| Role            | ACCOUNTADMIN                   |
| Database        | not set                        |
| Warehouse       | not set                        |
+--------------------------------------------------+

-- Example 25994
snow connection test -c myconnection2 --enable-diag --diag-log-path $(HOME)/report

-- Example 25995
+----------------------------------------------------------------------------+
| key                  | value                                               |
|----------------------+-----------------------------------------------------|
| Connection name      | myconnection2                                       |
| Status               | OK                                                  |
| Host                 | example.snowflakecomputing.com                      |
| Account              | myaccount2                                          |
| User                 | jdoe2                                               |
| Role                 | ACCOUNTADMIN                                        |
| Database             | not set                                             |
| Warehouse            | not set                                             |
| Diag Report Location | /Users/<username>/SnowflakeConnectionTestReport.txt |
+----------------------------------------------------------------------------+

-- Example 25996
snow connection set-default myconnection2

-- Example 25997
Default connection set to: myconnection2

-- Example 25998
snow sql --help

-- Example 25999
╭─ Connection configuration ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --connection,--environment             -c      TEXT     Name of the connection, as defined in your config.toml. Default: default.            │
│ --host                                         TEXT     Host address for the connection. Overrides the value specified for the connection.   │
│ --port                                         INTEGER  Port for the connection. Overrides the value specified for the connection.           │
│ --account,--accountname                        TEXT     Name assigned to your Snowflake account. Overrides the value specified for the       │
│                                                         connection.                                                                          │
│ --user,--username                              TEXT     Username to connect to Snowflake. Overrides the value specified for the connection.  │
│ --password                                     TEXT     Snowflake password. Overrides the value specified for the connection.                │
│ --authenticator                                TEXT     Snowflake authenticator. Overrides the value specified for the connection.           │
│ --private-key-file,--private-key-path          TEXT     Snowflake private key file path. Overrides the value specified for the connection.   │
│ --token-file-path                              TEXT     Path to file with an OAuth token that should be used when connecting to Snowflake    │
│ --database,--dbname                            TEXT     Database to use. Overrides the value specified for the connection.                   │
│ --schema,--schemaname                          TEXT     Database schema to use. Overrides the value specified for the connection.            │
│ --role,--rolename                              TEXT     Role to use. Overrides the value specified for the connection.                       │
│ --warehouse                                    TEXT     Warehouse to use. Overrides the value specified for the connection.                  │
│ --temporary-connection                 -x               Uses connection defined with command line parameters, instead of one defined in      │
│                                                         config                                                                               │
│ --mfa-passcode                                 TEXT     Token to use for multi-factor authentication (MFA)                                   │
│ --enable-diag                                           Run python connector diagnostic test                                                 │
│ --diag-log-path                                TEXT     Diagnostic report path                                                               │
│ --diag-allowlist-path                          TEXT     Diagnostic report path to optional allowlist                                         │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

-- Example 26000
snow helpers import-snowsql-connections

-- Example 26001
snow helpers import-snowsql-connections

-- Example 26002
SnowSQL config file [/etc/snowsql.cnf] does not exist. Skipping.
SnowSQL config file [/etc/snowflake/snowsql.cnf] does not exist. Skipping.
SnowSQL config file [/usr/local/etc/snowsql.cnf] does not exist. Skipping.
Trying to read connections from [/Users/<user>/.snowsql.cnf].
Reading SnowSQL's connection configuration [connections.connection1] from [/Users/<user>/.snowsql.cnf]
Trying to read connections from [/Users/<user>/.snowsql/config].
Reading SnowSQL's default connection configuration from [/Users/<user>/.snowsql/config]
Reading SnowSQL's connection configuration [connections.connection1] from [/Users/<user>/.snowsql/config]
Reading SnowSQL's connection configuration [connections.connection2] from [/Users/<user>/.snowsql/config]
Connection 'connection1' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: Y
Connection 'connection2' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: n
Connection 'default' already exists in Snowflake CLI, do you want to use SnowSQL definition and override existing connection in Snowflake CLI? [y/N]: n
Saving [connection1] connection in Snowflake CLI's config.
Connections successfully imported from SnowSQL to Snowflake CLI.

-- Example 26003
snow sql -q "select 42;" --temporary-connection \
                           --account myaccount \
                           --user jdoe

-- Example 26004
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 26005
SNOWFLAKE_ACCOUNT = "account"
SNOWFLAKE_USER = "user"
SNOWFLAKE_PRIVATE_KEY_FILE = "/path/to/key.p8"

-- Example 26006
snow sql -q "select 42" --temporary-connection

-- Example 26007
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 26008
SNOWFLAKE_ACCOUNT = "account"
SNOWFLAKE_USER = "user"
SNOWFLAKE_PRIVATE_KEY_RAW = "-----BEGIN PRIVATE KEY-----..."

-- Example 26009
snow sql -q "select 42" --temporary-connection

-- Example 26010
select 42;
+----+
| 42 |
|----|
| 42 |
+----+

-- Example 26011
snow connection add \
   --connection-name jwt \
   --authenticator SNOWFLAKE_JWT \
   --private-key-file ~/.ssh/sf_private_key.p8

-- Example 26012
[connections.jwt]
account = "my_account"
user = "jdoe"
authenticator = "SNOWFLAKE_JWT"
private_key_file = "~/sf_private_key.p8"

-- Example 26013
snow connection add --token-file-path "my-token.txt"

-- Example 26014
[connections.oauth]
account = "my_account"
user = "jdoe"
authenticator = "oauth"
token_file_path = "my-token.txt"

-- Example 26015
snow connection add --authenticator externalbrowser

-- Example 26016
[connections.externalbrowser]
account = "my_account"
user = "jdoe"
authenticator = "externalbrowser"

-- Example 26017
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'aztest1-external-function-api.azure.net',
  'Gateway'
  );

-- Example 26018
Private endpoint with ID "/subscriptions/e48379a7-2fc4-473e-b071-f94858cc83f5/resourcegroups/test_rg/providers/microsoft.network/privateendpoints/32bd3122-bfbd-417d-8620-1a02fd68fcf8" to resource "/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api" has been provisioned successfully. Please note down the endpoint ID and approve the connection from it on the Azure portal.

-- Example 26019
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/leorg1/providers/Microsoft.Sql/servers/myserver/databases/testdb',
  'testdb.database.windows.net',
  'sqlServer'
  );

-- Example 26020
"Resource Endpoint with id "/subscriptions/f0abb333-1b05-47c6-8c31-dd36d2512fd1/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" provisioned successfully"

-- Example 26021
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cc2909f2-ed22-4c89-8e5d-bdc40e5eac26/resourceGroups/mystorage/providers/Microsoft.Storage/storageAccounts/storagedemo',
  'storagedemo.blob.core.windows.net',
  'blob'
);

-- Example 26022
"Resource Endpoint with id "/subscriptions/57faea9a-20c2-4d35-b283-9c0c1e9593d8/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" provisioned successfully"

-- Example 26023
SELECT SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO();

-- Example 26024
[
     {
        "provider_resource_id": "/subscriptions/11111111-2222-3333-4444-5555555555/...",
        "subresource": "sqlServer",
        "snowflake_resource_id": "/subscriptions/fa57a1f0-b4e6-4847-9c00-95f39520f...",
        "host": "testdb.database.windows.net",
        "endpoint_state": "CREATED",
        "status": "Approved",
     }
  ]

-- Example 26025
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'Gateway'
  );

-- Example 26026
Private endpoint with id "/subscriptions/e48379a7-2fc4-473e-b071-f94858cc83f5/resourcegroups/test_rg/providers/microsoft.network/privateendpoints/5ef8fd34-07db-4583-b0dd-0e2360398ed3" successfully marked for deletion. Before it is fully deleted in 7-8 days, it can be restored.

-- Example 26027
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/leorg1/providers/Microsoft.Sql/servers/myserver/databases/testdb',
  'sqlServer'
  );

-- Example 26028
"Resource Endpoint with id "/subscriptions/f0abb333-1b05-47c6-8c31-dd36d2512fd1/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" deprovisioned successfully"

-- Example 26029
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cb72345g5-d347-4sdc-r3ee-70d234551a78/resourceGroups/rg-db-dev/providers/Microsoft.Storage/storageAccounts/dbasdfffext',
  'blob'
);

-- Example 26030
"Resource Endpoint with id "/subscriptions/57faea9a-20c2-4d35-b283-9c0c1e9593d8/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" deprovisioned successfully"

-- Example 26031
SELECT SYSTEM$RESTORE_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/my_rg/providers/Microsoft.Sql/servers/my_db_server',
  'sqlServer'
);

-- Example 26032
Private endpoint with id ''/subscriptions/66666666-7777-8888-9999-0000000000/resourcegroups/rg/providers/microsoft.network/privateendpoints/00000000-1111-2222-3333-4444444444'' restored successfully.

-- Example 26033
(LinkedAuthorizationFailed) The client has permission to perform action '<action_name>' on scope '<service_name>', however the current tenant '<tenant_id>' is not authorized to access linked subscription '<subscription_id'.

Code: LinkedAuthorizationFailed

Message: The client has permission to perform action '<action_name>' on scope '<service_name>', however the current tenant '<tenant_id>' is not authorized to access linked subscription '<subscription_id>'.

-- Example 26034
CREATE OR REPLACE EXTERNAL VOLUME <ext_volume_name>
  STORAGE_LOCATIONS =
  (
    (
      NAME = 'my-s3-loc'
      STORAGE_PROVIDER = 's3'
      STORAGE_BASE_URL = 's3://<bucket>[/<path>/]'
      STORAGE_AWS_ROLE_ARN = '<iam_role>'
      USE_PRIVATELINK_ENDPOINT = [ TRUE | FALSE ]
    )
  )
  ALLOW_WRITES=true;

ALTER EXTERNAL VOLUME <ext_volume_name>
  UPDATE STORAGE_LOCATION = '<storage_location_name>'
  USE_PRIVATELINK_ENDPOINT = [ TRUE | FALSE ];

-- Example 26035
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
    'com.amazonaws.us-west-2.s3',
    '*.s3.us-west-2.amazonaws.com');

-- Example 26036
CREATE EXTERNAL VOLUME external_volume
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-s3-loc'
        STORAGE_PROVIDER = 's3'
        STORAGE_BASE_URL = 's3://bucketinuswest2/'
        STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
        USE_PRIVATELINK_ENDPOINT = TRUE
      )
    )
  ALLOW_WRITES=TRUE;

-- Example 26037
CREATE ICEBERG TABLE rand_table (data string)
  BASE_LOCATION='table'
  EXTERNAL_VOLUME=external_volume
  CATALOG='snowflake';

