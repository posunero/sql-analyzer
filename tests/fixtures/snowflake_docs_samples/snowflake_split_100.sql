-- Example 6681
Private endpoint with id "/subscriptions/e48379a7-2fc4-473e-b071-f94858cc83f5/resourcegroups/test_rg/providers/microsoft.network/privateendpoints/5ef8fd34-07db-4583-b0dd-0e2360398ed3" successfully marked for deletion. Before it is fully deleted in 7-8 days, it can be restored.

-- Example 6682
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/11111111-2222-3333-4444-5555555555/resourceGroups/leorg1/providers/Microsoft.Sql/servers/myserver/databases/testdb',
  'sqlServer'
  );

-- Example 6683
"Resource Endpoint with id "/subscriptions/f0abb333-1b05-47c6-8c31-dd36d2512fd1/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" deprovisioned successfully"

-- Example 6684
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cb72345g5-d347-4sdc-r3ee-70d234551a78/resourceGroups/rg-db-dev/providers/Microsoft.Storage/storageAccounts/dbasdfffext',
  'blob'
);

-- Example 6685
"Resource Endpoint with id "/subscriptions/57faea9a-20c2-4d35-b283-9c0c1e9593d8/resourceGroups/privatelink-test/providers/Microsoft.Network/privateEndpoints/external-network-access-pe" deprovisioned successfully"

-- Example 6686
SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE( '<bundle_name>' )

-- Example 6687
SELECT SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2020_08');

-- Example 6688
+--------------------------------------------------+
| SYSTEM$DISABLE_BEHAVIOR_CHANGE_BUNDLE('2020_08') |
|--------------------------------------------------|
| DISABLED                                         |
+--------------------------------------------------+

-- Example 6689
SYSTEM$DISABLE_DATABASE_REPLICATION('<db_name>');

-- Example 6690
SELECT SYSTEM$DISABLE_DATABASE_REPLICATION('mydb');

-- Example 6691
SYSTEM$DISABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT( '<account_name>' )

-- Example 6692
SELECT SYSTEM$DISABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('my_account');

-- Example 6693
+--------------------------------------------------------------------+
| SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('my_account') |
|--------------------------------------------------------------------|
| Statement executed successfully                                    |
+--------------------------------------------------------------------+

-- Example 6694
SYSTEM$DISABLE_PREVIEW_ACCESS()

-- Example 6695
+----------------------------------------------------------------+
| SYSTEM$DISABLE_PREVIEW_ACCESS()                                |
+----------------------------------------------------------------+
| Preview access has been successfully disabled for this account |
+----------------------------------------------------------------+

-- Example 6696
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$DISABLE_PREVIEW_ACCESS();

-- Example 6697
SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE( '<bundle_name>' )

-- Example 6698
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2020_08');

-- Example 6699
+-------------------------------------------------+
| SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2020_08') |
|-------------------------------------------------|
| ENABLED                                         |
+-------------------------------------------------+

-- Example 6700
SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT( '<account_name>' )

-- Example 6701
SELECT SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('my_account');

-- Example 6702
+--------------------------------------------------------------------+
| SYSTEM$SYSTEM$ENABLE_GLOBAL_DATA_SHARING_FOR_ACCOUNT('my_account') |
|--------------------------------------------------------------------|
| Statement executed successfully                                    |
+--------------------------------------------------------------------+

-- Example 6703
SYSTEM$ENABLE_PREVIEW_ACCESS()

-- Example 6704
+---------------------------------------------------------------+
| SELECT SYSTEM$ENABLE_PREVIEW_ACCESS();                        |
+---------------------------------------------------------------+
| Preview access has been successfully enabled for this account |
+---------------------------------------------------------------+

-- Example 6705
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$ENABLE_PREVIEW_ACCESS();

-- Example 6706
SYSTEM$END_DEBUG_APPLICATION()

-- Example 6707
SYSTEM$ESTIMATE_AUTOMATIC_CLUSTERING_COSTS( '<table_name>' ,
 [ '( <expr1> [ , <expr2> ... ] )' ] )

-- Example 6708
SELECT SYSTEM$ESTIMATE_AUTOMATIC_CLUSTERING_COSTS('myTable', '(day, tenantId)');

-- Example 6709
{
  "reportTime": "Fri, 12 Jul 2024 01:06:18 GMT",
  "clusteringKey": "LINEAR(day, tenantId)",
  "initial": {
    "unit": "Credits",
    "value": 98.2,
    "comment": "Total upper bound of one-time cost"
  },
  "maintenance": {
    "unit": "Credits",
    "value": 10.0,
    "comment": "Daily maintenance cost estimate provided based on DML history from the
    past seven days."
  }
}

-- Example 6710
SYSTEM$ESTIMATE_QUERY_ACCELERATION( '<query_id>' )

-- Example 6711
...
"estimatedQueryTimes" : {
  "1" : 171,
  "2": 152,
  "4": 133,
  "8": 120
}
...

-- Example 6712
SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS('<table_name>' [ , '<search_method_with_target>' ])

-- Example 6713
...
"costPositions" : [
  {
    "name" : "BuildCosts",
    ...
  }, {
    "name" : "StorageCosts",
    ...
  }, {
    "name" : "Benefit",
    ...
  }, {
    "name" : "MaintenanceCosts",
    ...
  }
]
...

-- Example 6714
No active warehouse selected in the current session.
Select an active warehouse with the 'use warehouse' command.

-- Example 6715
SELECT SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS('table_without_search_opt')
  AS estimate_for_table_without_search_optimization;

-- Example 6716
+---------------------------------------------------------------------------+
| ESTIMATE_FOR_TABLE_WITHOUT_SEARCH_OPTIMIZATION                            |
|---------------------------------------------------------------------------|
| {                                                                         |
|   "tableName" : "TABLE_WITHOUT_SEARCH_OPT",                               |
|   "searchOptimizationEnabled" : false,                                    |
|   "costPositions" : [ {                                                   |
|     "name" : "BuildCosts",                                                |
|     "costs" : {                                                           |
|       "value" : 11.279,                                                   |
|       "unit" : "Credits"                                                  |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "StorageCosts",                                              |
|     "costs" : {                                                           |
|       "value" : 0.070493,                                                 |
|       "unit" : "TB"                                                       |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "MaintenanceCosts",                                          |
|     "costs" : {                                                           |
|       "value" : 30.296,                                                   |
|       "unit" : "Credits",                                                 |
|       "perTimeUnit" : "MONTH"                                             |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "Estimated from historic change rate over last ~11 days." |
|   } ]                                                                     |
| }                                                                         |
+---------------------------------------------------------------------------+

-- Example 6717
SELECT SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS('table_with_search_opt')
  AS estimate_for_table_with_search_optimization;

-- Example 6718
+---------------------------------------------------------------------------+
| ESTIMATE_FOR_TABLE_WITH_SEARCH_OPTIMIZATION                               |
|---------------------------------------------------------------------------|
| {                                                                         |
|   "tableName" : "TABLE_WITH_SEARCH_OPT",                                  |
|   "searchOptimizationEnabled" : true,                                     |
|   "costPositions" : [ {                                                   |
|     "name" : "BuildCosts",                                                |
|     "computationMethod" : "NotAvailable",                                 |
|     "comment" : "Search optimization is already enabled."                 |
|   }, {                                                                    |
|     "name" : "StorageCosts",                                              |
|     "costs" : {                                                           |
|       "value" : 0.052048,                                                 |
|       "unit" : "TB"                                                       |
|     },                                                                    |
|     "computationMethod" : "Measured"                                      |
|   }, {                                                                    |
|     "name" : "Benefit",                                                   |
|     "computationMethod" : "NotAvailable",                                 |
|     "comment" : "Currently not supported."                                |
|   }, {                                                                    |
|     "name" : "MaintenanceCosts",                                          |
|     "costs" : {                                                           |
|       "value" : 30.248,                                                   |
|       "unit" : "Credits",                                                 |
|       "perTimeUnit" : "MONTH"                                             |
|     },                                                                    |
|     "computationMethod" : "EstimatedUpperBound",                          |
|     "comment" : "Estimated from historic change rate over last ~11 days." |
|   } ]                                                                     |
| }                                                                         |
+---------------------------------------------------------------------------+

-- Example 6719
SELECT SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS('table_without_search_opt', 'EQUALITY(C1, C2, C3)')
  AS estimate_for_columns_without_search_optimization;

-- Example 6720
+---------------------------------------------------------------------------+
| ESTIMATE_FOR_COLUMNS_WITHOUT_SEARCH_OPTIMIZATION                          |
|---------------------------------------------------------------------------|
| {                                                                         |
|   "tableName" : "TABLE_WITHOUT_SEARCH_OPT",                               |
|   "searchOptimizationEnabled" : false,                                    |
|   "costPositions" : [ {                                                   |
|     "name" : "BuildCosts",                                                |
|     "costs" : {                                                           |
|       "value" : 10.527,                                                   |
|       "unit" : "Credits"                                                  |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "StorageCosts",                                              |
|     "costs" : {                                                           |
|       "value" : 0.040323,                                                 |
|       "unit" : "TB"                                                       |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "MaintenanceCosts",                                          |
|     "costs" : {                                                           |
|       "value" : 22.821,                                                   |
|       "unit" : "Credits",                                                 |
|       "perTimeUnit" : "MONTH"                                             |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "Estimated from historic change rate over last ~7 days."  |
|   } ]                                                                     |
| }                                                                         |
+---------------------------------------------------------------------------+

-- Example 6721
SELECT SYSTEM$ESTIMATE_SEARCH_OPTIMIZATION_COSTS('table_with_search_opt', 'EQUALITY(C1, C2, C3)')
  AS estimate_for_columns_with_search_optimization;

-- Example 6722
+---------------------------------------------------------------------------+
| ESTIMATE_FOR_COLUMNS_WITH_SEARCH_OPTIMIZATION                             |
|---------------------------------------------------------------------------|
| {                                                                         |
|   "tableName" : "TABLE_WITH_SEARCH_OPT",                                  |
|   "searchOptimizationEnabled" : true,                                     |
|   "costPositions" : [ {                                                   |
|     "name" : "BuildCosts",                                                |
|     "costs" : {                                                           |
|       "value" : 8.331,                                                    |
|       "unit" : "Credits"                                                  |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "StorageCosts",                                              |
|     "costs" : {                                                           |
|       "value" : 0.040323,                                                 |
|       "unit" : "TB"                                                       |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "estimated via sampling"                                  |
|   }, {                                                                    |
|     "name" : "Benefit",                                                   |
|     "computationMethod" : "NotAvailable",                                 |
|     "comment" : "Currently not supported."                                |
|   }, {                                                                    |
|     "name" : "MaintenanceCosts",                                          |
|     "costs" : {                                                           |
|       "value" : 22.821,                                                   |
|       "unit" : "Credits",                                                 |
|       "perTimeUnit" : "MONTH"                                             |
|     },                                                                    |
|     "computationMethod" : "Estimated",                                    |
|     "comment" : "Estimated from historic change rate over last ~7 days."  |
|   } ]                                                                     |
| }                                                                         |
+---------------------------------------------------------------------------+

-- Example 6723
SYSTEM$EXPLAIN_JSON_TO_TEXT( <explain_output_in_json_format> )

-- Example 6724
CREATE TABLE Z1 (ID INTEGER);
CREATE TABLE Z2 (ID INTEGER);
CREATE TABLE Z3 (ID INTEGER);

-- Example 6725
SET QUERY_10 = 'SELECT Z1.ID, Z2.ID FROM Z1, Z2 WHERE Z2.ID = Z1.ID';
CREATE TABLE json_explain_output_for_analysis (
    ID INTEGER,
    query VARCHAR,
    explain_plan VARCHAR
    );
INSERT INTO json_explain_output_for_analysis (ID, query, explain_plan) 
    SELECT 
        1,
        $QUERY_10 AS query,
        SYSTEM$EXPLAIN_PLAN_JSON($QUERY_10) AS explain_plan;

-- Example 6726
SELECT query, explain_plan FROM json_explain_output_for_analysis;
+-----------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| QUERY                                               | EXPLAIN_PLAN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|-----------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SELECT Z1.ID, Z2.ID FROM Z1, Z2 WHERE Z2.ID = Z1.ID | {"GlobalStats":{"partitionsTotal":2,"partitionsAssigned":2,"bytesAssigned":1024},"Operations":[[{"id":0,"operation":"Result","expressions":["Z1.ID","Z2.ID"]},{"id":1,"parentOperators":[0],"operation":"InnerJoin","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":2,"parentOperators":[1],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z2"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512},{"id":3,"parentOperators":[1],"operation":"JoinFilter","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":4,"parentOperators":[3],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z1"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512}]]} |
+-----------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6727
SELECT SYSTEM$EXPLAIN_JSON_TO_TEXT(explain_plan) 
    FROM json_explain_output_for_analysis
    WHERE json_explain_output_for_analysis.ID = 1;
+------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$EXPLAIN_JSON_TO_TEXT(EXPLAIN_PLAN)                                                                                          |
|------------------------------------------------------------------------------------------------------------------------------------|
| GlobalStats:                                                                                                                       |
| 	bytesAssigned=1024                                                                                                                                                                                                                                                                         |
| 	partitionsAssigned=2                                                                                                                                                                                                                                                                         |
| 	partitionsTotal=2                                                                                                                                                                                                                                                                         |
| Operations:                                                                                                                        |
| 1:0     ->Result  Z1.ID, Z2.ID                                                                                                     |
| 1:1          ->InnerJoin  joinKey: (Z2.ID = Z1.ID)                                                                                 |
| 1:2               ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z2  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512}      |
| 1:3               ->JoinFilter  joinKey: (Z2.ID = Z1.ID)                                                                           |
| 1:4                    ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z1  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512} |
|                                                                                                                                    |
+------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6728
SYSTEM$EXPLAIN_PLAN_JSON( { <sql_statement_expression> | <sql_query_id_expression> } )

-- Example 6729
CREATE TABLE Z1 (ID INTEGER);
CREATE TABLE Z2 (ID INTEGER);
CREATE TABLE Z3 (ID INTEGER);

-- Example 6730
SELECT SYSTEM$EXPLAIN_PLAN_JSON(
    'SELECT Z1.ID, Z2.ID FROM Z1, Z2 WHERE Z2.ID = Z1.ID'
    ) AS explain_plan;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN_PLAN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {"GlobalStats":{"partitionsTotal":2,"partitionsAssigned":2,"bytesAssigned":1024},"Operations":[[{"id":0,"operation":"Result","expressions":["Z1.ID","Z2.ID"]},{"id":1,"parentOperators":[0],"operation":"InnerJoin","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":2,"parentOperators":[1],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z2"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512},{"id":3,"parentOperators":[1],"operation":"JoinFilter","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":4,"parentOperators":[3],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z1"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512}]]} |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6731
SELECT SYSTEM$EXPLAIN_PLAN_JSON(
    $$ SELECT symptom, IFNULL(diagnosis, '(not yet diagnosed)') FROM medical $$
    );

-- Example 6732
SELECT Z1.ID, Z2.ID FROM Z1, Z2 WHERE Z2.ID = Z1.ID;

-- Example 6733
SELECT SYSTEM$EXPLAIN_PLAN_JSON(LAST_QUERY_ID()) AS explain_plan;

-- Example 6734
SYSTEM$EXTERNAL_TABLE_PIPE_STATUS( '<external_table_name>' )

-- Example 6735
SELECT SYSTEM$EXTERNAL_TABLE_PIPE_STATUS('mydb.myschema.exttable');

+---------------------------------------------------------------+
| SYSTEM$EXTERNAL_TABLE_PIPE_STATUS('MYDB.MYSCHEMA.EXTTABLE')   |
|---------------------------------------------------------------|
| {"executionState":"RUNNING","pendingFileCount":0}             |
+---------------------------------------------------------------+

-- Example 6736
SELECT SYSTEM$EXTERNAL_TABLE_PIPE_STATUS('mydb.myschema."extTable"');

+---------------------------------------------------------------+
| SYSTEM$EXTERNAL_TABLE_PIPE_STATUS('MYDB.MYSCHEMA."extTable"') |
|---------------------------------------------------------------|
| {"executionState":"RUNNING","pendingFileCount":0}             |
+---------------------------------------------------------------+

-- Example 6737
SYSTEM$FINISH_OAUTH_FLOW( '<query_string>' )

-- Example 6738
SELECT SYSTEM$FINISH_OAUTH_FLOW('state=252462476&authz_code=54264262');

-- Example 6739
SYSTEM$START_OAUTH_FLOW( '<database_name.schema_name.secret_name>' )

-- Example 6740
SYSTEM$GENERATE_SAML_CSR( <name> , <DN> )

-- Example 6741
select system$generate_saml_csr('my_idp');

--------------------------------------------------------------------------------------------------+
SYSTEM$GENERATE_SAML_CSR('MY_IDP')                                                                |
--------------------------------------------------------------------------------------------------+
-----BEGIN NEW CERTIFICATE REQUEST-----                                                           |
MIICWzCCAUMCAQAwFjEUMBIGA1UEAxMLVEVTVEFDQ09VTlQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDCRpyZ  |
...                                                                                               |
-----END NEW CERTIFICATE REQUEST-----                                                             |
--------------------------------------------------------------------------------------------------+

-- Example 6742
select system$generate_saml_csr('my_idp', 'cn=juser, ou=dev, ou=people, o=eng, dc=com');

--------------------------------------------------------------------------------------------------+
SYSTEM$GENERATE_SAML_CSR('MY_IDP')                                                                |
--------------------------------------------------------------------------------------------------+
-----BEGIN NEW CERTIFICATE REQUEST-----                                                           |
MIICWzCCAUMCAQAwFjEUMBIGA1UEAxMLVEVTVEFDQ09VTlQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDCRpyZ  |
...                                                                                               |
-----END NEW CERTIFICATE REQUEST-----                                                             |
--------------------------------------------------------------------------------------------------+

-- Example 6743
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
    <name>
    TYPE = SAML2
    ENABLED = { TRUE | FALSE }
    SAML2_ISSUER = '<string_literal>'
    SAML2_SSO_URL = '<string_literal>'
    SAML2_PROVIDER = '<string_literal>'
    SAML2_X509_CERT = '<string_literal>'
    [ ALLOWED_USER_DOMAINS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ ALLOWED_EMAIL_PATTERNS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = '<string_literal>' ]
    [ SAML2_ENABLE_SP_INITIATED = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_X509_CERT = '<string_literal>' ]
    [ SAML2_SIGN_REQUEST = TRUE | FALSE ]
    [ SAML2_REQUESTED_NAMEID_FORMAT = '<string_literal>' ]
    [ SAML2_POST_LOGOUT_REDIRECT_URL = '<string_literal>' ]
    [ SAML2_FORCE_AUTHN = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_ISSUER_URL = '<string_literal>' ]
    [ SAML2_SNOWFLAKE_ACS_URL = '<string_literal>' ]
    [ COMMENT = '<string_literal>' ]

-- Example 6744
CREATE SECURITY INTEGRATION my_idp
    TYPE = saml2
    ENABLED = true
    SAML2_ISSUER = 'https://example.com'
    SAML2_SSO_URL = 'http://myssoprovider.com'
    SAML2_PROVIDER = 'ADFS'
    SAML2_X509_CERT = 'my_x509_cert'
    SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'my_idp'
    SAML2_ENABLE_SP_INITIATED = false
    ;

-- Example 6745
DESC SECURITY INTEGRATION my_idp;

-- Example 6746
SYSTEM$GENERATE_SCIM_ACCESS_TOKEN('<integration_name>')

-- Example 6747
SELECT SYSTEM$GENERATE_SCIM_ACCESS_TOKEN('OKTA_PROVISIONING');

