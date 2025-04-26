-- Example 7016
SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '<provider_service_name>',
  '<host_name>'
)

-- Example 7017
SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '<provider_resource_id>',
  '<host_name>'
  [, '<subresource>' ]
)

-- Example 7018
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 7019
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'aztest1-external-function-api.azure.net',
  'Gateway'
  );

-- Example 7020
Private endpoint with ID "/subscriptions/e48379a7-2fc4-473e-b071-f94858cc83f5/resourcegroups/test_rg/providers/microsoft.network/privateendpoints/32bd3122-bfbd-417d-8620-1a02fd68fcf8" to resource "/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api" has been provisioned successfully. Please note down the endpoint ID and approve the connection from it on the Azure portal.

-- Example 7021
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/leorg1/providers/Microsoft.Sql/servers/myserver/databases/testdb',
  'testdb.database.windows.net',
  'sqlServer'
  );

-- Example 7022
"Resource Endpoint with id "/subscriptions/f0abb333-1b05-47c6-8c31-dd36d2512fd1/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" provisioned successfully"

-- Example 7023
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cc2909f2-ed22-4c89-8e5d-bdc40e5eac26/resourceGroups/mystorage/providers/Microsoft.Storage/storageAccounts/storagedemo',
  'storagedemo.blob.core.windows.net',
  'blob'
);

-- Example 7024
"Resource Endpoint with id "/subscriptions/57faea9a-20c2-4d35-b283-9c0c1e9593d8/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" provisioned successfully"

-- Example 7025
SYSTEM$QUERY_REFERENCE('<select_statement>', [ , <use_session_scope> ] )

-- Example 7026
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE insert_row(table_identifier VARCHAR)
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
  LET stmt VARCHAR := 'INSERT INTO ' || table_identifier || ' VALUES (10)';
  LET res RESULTSET := (EXECUTE IMMEDIATE stmt);
  RETURN TABLE(res);
END;
$$;

-- Example 7027
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE insert_row(table_identifier VARCHAR)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
$$
  let res = snowflake.execute({
    sqlText: "INSERT INTO IDENTIFIER(?) VALUES (10);",
    binds : [TABLE_IDENTIFIER]
  });
  res.next()
  return res.getColumnValue(1);
$$;

-- Example 7028
USE ROLE table_owner;

CREATE OR REPLACE TABLE table_with_different_owner (x NUMBER) AS SELECT 42;

-- Example 7029
USE ROLE table_owner;

CALL insert_row('table_with_different_owner');

-- Example 7030
002003 (42S02): Uncaught exception of type 'STATEMENT_ERROR' on line 4 at position 25 : SQL compilation error:
Table 'TABLE_WITH_DIFFERENT_OWNER' does not exist or not authorized.

-- Example 7031
USE ROLE table_owner;

CALL insert_row(SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT'));

-- Example 7032
CALL select_from_table(SYSTEM$REFERENCE('TABLE', 'my_table');

-- Example 7033
SET tableRef = (SELECT SYSTEM$REFERENCE('TABLE', 'my_table'));

SELECT * FROM IDENTIFIER($tableRef);

-- Example 7034
CALL insert_row(SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT'));

-- Example 7035
SELECT SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT', 'UPDATE', 'TRUNCATE');

-- Example 7036
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
  RETURNS INTEGER
  LANGUAGE SQL
  AS
  DECLARE
    row_count INTEGER DEFAULT 0;
    stmt VARCHAR DEFAULT 'SELECT COUNT(*) FROM (' || query || ')';
    res RESULTSET DEFAULT (EXECUTE IMMEDIATE :stmt);
    cur CURSOR FOR res;
  BEGIN
    OPEN cur;
    FETCH cur INTO row_count;
    RETURN row_count;
  END;

-- Example 7037
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
$$
  let res = snowflake.execute({
    sqlText: "SELECT COUNT(*) FROM (" + QUERY + ");",
  });
  res.next()
  return res.getColumnValue(1);
$$;

-- Example 7038
USE ROLE table_owner;
CREATE OR REPLACE TABLE table_with_different_owner (x NUMBER) AS SELECT 42;

CALL get_num_results('SELECT x FROM table_with_different_owner');

-- Example 7039
002003 (42S02): Uncaught exception of type 'STATEMENT_ERROR' on line 4 at position 29 : SQL compilation error:
Object 'TABLE_WITH_DIFFERENT_OWNER' does not exist or not authorized.

-- Example 7040
USE ROLE table_owner;

CALL get_num_results(
  SYSTEM$QUERY_REFERENCE('SELECT x FROM table_with_different_owner', true)
);

-- Example 7041
+-----------------+
| GET_NUM_RESULTS |
|-----------------|
|               1 |
+-----------------+

-- Example 7042
snowflake.execute({
  sqlText: "SELECT COUNT(*) FROM (" + QUERY + ");"
});

-- Example 7043
TABLE( [[<database_name>.]<schema_name>.]<object_name> )

-- Example 7044
TABLE("<object_name_that_requires_double_quotes>")

-- Example 7045
TABLE(IDENTIFIER('string_literal_for_object_name'))

-- Example 7046
CALL my_procedure(TABLE(my_table));

-- Example 7047
CALL my_procedure(TABLE(my_database.my_schema.my_view));

-- Example 7048
CALL my_procedure(TABLE("My Table Name"));

-- Example 7049
CALL my_procedure(TABLE(IDENTIFIER('my_view')));

-- Example 7050
TABLE(<select_statement>)

-- Example 7051
CALL my_procedure(TABLE(SELECT * FROM my_view));

-- Example 7052
CALL my_procedure(TABLE(WITH c(s) as (SELECT $1 FROM VALUES (1), (2)) SELECT a, count(*) FROM T, C WHERE s = a GROUP BY a));

-- Example 7053
SYSTEM$REFERENCE('<object_type>', '<object_identifier>',
  [ , '<reference_scope>' [ , '<privilege>' [ , '<privilege>' ... ] ] ] )

-- Example 7054
CALL myprocedure( SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT'. 'UPDATE', 'TRUNCATE'));

-- Example 7055
505028 (42601): Object type <object_type> does not match the specified type <type_of_the_specified_object> for reference creation

-- Example 7056
SYSTEM$REGISTER_CMK_INFO( '<cmk-arn>' )

-- Example 7057
SYSTEM$REGISTER_CMK_INFO( '<vault-uri>' , '<key-name>' )

-- Example 7058
SYSTEM$REGISTER_CMK_INFO( '<project-id>' , '<location>', '<key-ring>' , '<key-name>' )

-- Example 7059
SELECT SYSTEM$REGISTER_CMK_INFO('arn:aws:kms:us-west-2:736112632310:key/ceab36e4-f0e5-4b46-9a78-86e8f17a0f59');

-- Example 7060
SELECT SYSTEM$REGISTER_CMK_INFO('https://trisecretsite.vault.azure.net/', 'trisecretazkey');

-- Example 7061
SELECT SYSTEM$REGISTER_CMK_INFO('my-env', 'us-west1', 'trisecrettest', 'trisecretgcpkey');

-- Example 7062
SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  '<aws_private_endpoint_vpce_id>',
  '<aws_account_id>',
  '<token>',
  [ <delay_time> ]
  )

-- Example 7063
SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  '<azure_private_endpoint_link_id>',
  '<azure_private_endpoint_resource_id>',
  '<token>',
  [ <delay_time> ]
  )

-- Example 7064
aws ec2 describe-vpc-endpoints

-- Example 7065
aws sts get-caller-identity

-- Example 7066
az network private-endpoint list --resource-group my_resource_group

-- Example 7067
aws sts get-federation-token --name snowflake --policy '{ "Version": "2012-10-17", "Statement"
: [ { "Effect": "Allow", "Action": ["ec2:DescribeVpcEndpoints"], "Resource": ["*"] } ] }'

-- Example 7068
az account get-access-token --subscription <subscription_id>

-- Example 7069
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  'vpce-0c1...',
  '123.....',
  '{
    "Credentials": {
      "AccessKeyId": "ASI...",
      "SecretAccessKey": "alD...",
      "SessionToken": "IQo...",
      "Expiration": "2024-12-10T08:20:20+00:00"
    },
    "FederatedUser": {
      "FederatedUserId": "0123...:snowflake",
      "Arn": "arn:aws:sts::174...:federated-user/snowflake"
    },
    "PackedPolicySize": 9,
    }',
  120
  );

-- Example 7070
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  '123....',
  '/subscriptions/0cc51670-.../resourceGroups/dbsec_test_rg/providers/Microsoft.Network/
  privateEndpoints/...',
  'eyJ...',
  120
);

-- Example 7071
SYSTEM$REGISTRY_LIST_IMAGES( '/<dbName>/<schemaName>/<repositoryName>' )

-- Example 7072
SELECT SYSTEM$REGISTRY_LIST_IMAGES('/tutorial_db/data_schema/tutorial_repository');

-- Example 7073
+-----------------------------------------------------------------------------+
| SYSTEM$REGISTRY_LIST_IMAGES('/TUTORIAL_DB/DATA_SCHEMA/TUTORIAL_REPOSITORY') |
|-----------------------------------------------------------------------------|
| {"images":["my_echo_service_image","my_job_image"]}                         |
+-----------------------------------------------------------------------------+

-- Example 7074
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 7075
<registry-hostname>/<db_name>/<schema_name>/<repository_name>

-- Example 7076
myorg-myacct.registry.snowflake.com/my_db/my_schema/my_repository

-- Example 7077
SYSTEM$REMOVE_ALL_REFERENCES('<reference_name>')

-- Example 7078
SYSTEM$REMOVE_REFERENCE('<reference_name>'[, '<alias>'])

-- Example 7079
SYSTEM$RESTORE_PRIVATELINK_ENDPOINT( '<provider_service_name>' )

-- Example 7080
SYSTEM$RESTORE_PRIVATELINK_ENDPOINT(
  '<provider_resource_id>'
  [, '<subresource>' ]
  )

-- Example 7081
SELECT SYSTEM$RESTORE_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 7082
SELECT SYSTEM$RESTORE_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/my_rg/providers/Microsoft.Sql/servers/my_db_server',
  'sqlServer'
);

