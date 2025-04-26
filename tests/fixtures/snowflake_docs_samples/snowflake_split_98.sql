-- Example 6547
SELECT SYSTEM$ABORT_SESSION(1065153868222);

+-------------------------------------+
| SYSTEM$ABORT_SESSION(1065153868222) |
|-------------------------------------|
| session [1065153868222] terminated. |
+-------------------------------------+

-- Example 6548
SYSTEM$ABORT_TRANSACTION(<transaction_id>)

-- Example 6549
SHOW LOCKS IN ACCOUNT;

--------------+--------+---------------+---------------------------------+---------+---------------------------------+--------------------------------------+
   session    | table  |  transaction  |     transaction_started_on      | status  |           acquired_on           |               query_id               |
--------------+--------+---------------+---------------------------------+---------+---------------------------------+--------------------------------------+
 103079321618 | ORDERS | 1442254688149 | Mon, 14 Sep 2015 11:18:08 -0700 | HOLDING | Mon, 14 Sep 2015 11:18:16 -0700 | 6a478582-9e8c-4603-b5bf-89b14c042e1a |
 103079325702 | ORDERS | 1442255439400 | Mon, 14 Sep 2015 11:30:39 -0700 | WAITING | [NULL]                          | 82fea8a6-a679-4de1-b6e9-7a80905831cf |
--------------+--------+---------------+---------------------------------+---------+---------------------------------+--------------------------------------+

SELECT SYSTEM$ABORT_TRANSACTION(1442254688149);

-----------------------------------------+
 SYSTEM$ABORT_TRANSACTION(1442254688149) |
-----------------------------------------+
 Aborted transaction id: 1442254688149   |
-----------------------------------------+

-- Example 6550
SYSTEM$ADD_EVENT('<name>', '<object>');

-- Example 6551
CREATE OR REPLACE PROCEDURE pi_proc()
  RETURNS DOUBLE
  LANGUAGE SQL
  AS $$
  BEGIN
    -- Add an event without attributes
    SYSTEM$ADD_EVENT('name_a');

    -- Add an event with attributes
    LET attr := {'score': 89, 'pass': TRUE};
    SYSTEM$ADD_EVENT('name_b', attr);

    -- Set attributes for the span
    SYSTEM$SET_SPAN_ATTRIBUTES({'key1': 'value1', 'key2': TRUE});

    RETURN 3.14;
  END;
  $$;

-- Example 6552
SYSTEM$ADD_REFERENCE('<reference_name>', '<reference_string>')

-- Example 6553
SYSTEM$ALLOWLIST()

-- Example 6554
SYSTEM$ALLOWLIST: Fail to get SSL context
SYSTEM$ALLOWLIST: SSLContext init failed
SYSTEM$ALLOWLIST: Could not find host in OCSP dumping
SYSTEM$ALLOWLIST: Peer unverified
SYSTEM$ALLOWLIST: Connection failure

-- Example 6555
SELECT SYSTEM$ALLOWLIST();

-- Example 6556
[
  {"type":"SNOWFLAKE_DEPLOYMENT", "host":"xy12345.snowflakecomputing.com",                 "port":443},
  {"type":"STAGE",                "host":"sfc-customer-stage.s3.us-west-2.amazonaws.com",  "port":443},
  ...
  {"type":"SNOWSQL_REPO",         "host":"sfc-repo.snowflakecomputing.com",                "port":443},
  ...
  {"type":"OCSP_CACHE",           "host":"ocsp.snowflakecomputing.com",                    "port":80}
  {"type":"OCSP_RESPONDER",       "host":"o.ss2.us",                                       "port":80},
  ...
]

-- Example 6557
SELECT t.VALUE:type::VARCHAR as type,
       t.VALUE:host::VARCHAR as host,
       t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$ALLOWLIST()))) AS t;

-- Example 6558
+-----------------------+---------------------------------------------------+------+
| TYPE                  | HOST                                              | PORT |
|-----------------------+---------------------------------------------------+------|
| SNOWFLAKE_DEPLOYMENT  | xy12345.snowflakecomputing.com                    | 443  |
| STAGE                 | sfc-customer-stage.s3.us-west-2.amazonaws.com     | 443  |
  ...
| SNOWSQL_REPO          | sfc-repo.snowflakecomputing.com                   | 443  |
  ...
| OCSP_CACHE            | ocsp.snowflakecomputing.com                       | 80   |
| OCSP_RESPONDER        | ocsp.sca1b.amazontrust.com                        | 80   |
  ...
+-----------------------+---------------------------------------------------+------+

-- Example 6559
SYSTEM$ALLOWLIST_PRIVATELINK()

-- Example 6560
SELECT SYSTEM$ALLOWLIST_PRIVATELINK();

-- Example 6561
[
  {"type":"SNOWFLAKE_DEPLOYMENT", "host":"xy12345.us-west-2.privatelink.snowflakecomputing.com","port":443},
  {"type":"STAGE",                "host":"sfc-ss-ds2-customer-stage.s3.us-west-2.amazonaws.com","port":443},
  ...
  {"type":"SNOWSQL_REPO",         "host":"sfc-repo.snowflakecomputing.com",                     "port":443},
  ...
  {"type":"OUT_OF_BAND_TELEMETRY","host":"client-telemetry.snowflakecomputing.com","port":443},
  {"type":"OCSP_CACHE",           "host":"ocsp.station00752.us-west-2.privatelink.snowflakecomputing.com","port":80}
]

-- Example 6562
SELECT t.VALUE:type::VARCHAR as type,
       t.VALUE:host::VARCHAR as host,
       t.VALUE:port as port
FROM TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$ALLOWLIST_PRIVATELINK()))) AS t;

-- Example 6563
+-----------------------+---------------------------------------------------+------+
| TYPE                  | HOST                                              | PORT |
+-----------------------+---------------------------------------------------+------+
| SNOWFLAKE_DEPLOYMENT  | xy12345.snowflakecomputing.com                    | 443  |
| STAGE                 | sfc-customer-stage.s3.us-west-2.amazonaws.com     | 443  |
  ...
| SNOWSQL_REPO          | sfc-repo.snowflakecomputing.com                   | 443  |
  ...
| OCSP_CACHE            | ocsp.snowflakecomputing.com                       | 80   |
  ...
+-----------------------+---------------------------------------------------+------+

-- Example 6564
SYSTEM$APPLICATION_GET_LOG_LEVEL( '<schema_name>.<object_name>' )

-- Example 6565
SYSTEM$APPLICATION_GET_METRIC_LEVEL( '<schema_name>.<object_name>' )

-- Example 6566
SYSTEM$APPLICATION_GET_TRACE_LEVEL( '<schema_name>.<object_name>' )

-- Example 6567
SELECT SYSTEM$APPLICATION_GET_TRACE_LEVEL('my_schema');

-- Example 6568
SYSTEM$AUTHORIZE_PRIVATELINK( '<aws_id>' , '<federated_token>' )

-- Example 6569
SYSTEM$AUTHORIZE_PRIVATELINK( '<private-endpoint-resource-id>' , '<federated_token>' )

-- Example 6570
aws sts get-federation-token --name sam

-- Example 6571
az account get-access-token --subscription <SubscriptionID>

-- Example 6572
az account list --output table

-- Example 6573
Name     CloudName   SubscriptionId                        State    IsDefault
-------  ----------  ------------------------------------  -------  ----------
MyCloud  AzureCloud  13c....                               Enabled  True

-- Example 6574
use role accountadmin;

select SYSTEM$AUTHORIZE_PRIVATELINK(
    '185...',
    '{
      "Credentials": {
          "AccessKeyId": "ASI...",
          "SecretAccessKey": "enw...",
          "SessionToken": "Fwo...",
          "Expiration": "2021-01-07T19:06:23+00:00"
      },
      "FederatedUser": {
          "FederatedUserId": "185...:sam",
          "Arn": "arn:aws:sts::185...:federated-user/sam"
      },
      "PackedPolicySize": 0
  }'
  );

-- Example 6575
use role accountadmin;

select SYSTEM$AUTHORIZE_PRIVATELINK(
  '/subscriptions/26d.../resourcegroups/sf-1/providers/microsoft.network/privateendpoints/test-self-service',
  'eyJ...');

-- Example 6576
-- Azure
SYSTEM$AUTHORIZE_STAGE_PRIVATELINK_ACCESS( '<privateEndpointResourceID>' )

-- Example 6577
use role accountadmin;

select SYSTEM$AUTHORIZE_STAGE_PRIVATELINK_ACCESS('/subscriptions/subId/resourceGroups/rg1/providers/Microsoft.Network/privateEndpoints/pe1');

-- Example 6578
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 6579
use role accountadmin;
select system$authorize_stage_privatelink_access('<privateEndpointResourceID>');

-- Example 6580
dig <storage_account_name>.blob.core.windows.net

-- Example 6581
SELECT SYSTEM$BLOCK_INTERNAL_STAGES_PUBLIC_ACCESS();

-- Example 6582
use role accountadmin;
alter account set enable_internal_stages_privatelink = false;
select system$revoke_stage_privatelink_access('<privateEndpointResourceID>');

-- Example 6583
dig CNAME <storage_account_name>.privatelink.blob.core.windows.net

-- Example 6584
SYSTEM$AUTO_REFRESH_STATUS('<table_name>')

-- Example 6585
{
  "executionState":"<value>",
  "invalidExecutionStateReason":"<value>",
  "pendingSnapshotCount":"<value>",
  "oldestSnapshotTime":"<value>",
  "currentSnapshotId":"<value>",
  "currentSnapshotSummary":"<value>",
  "lastSnapshotTime":"<value>",
  "lastUpdatedTime":"<value>",
  "currentMetadataFile":"<value>",
  "currentSchemaId":"<value>"
}

-- Example 6586
SELECT SYSTEM$AUTO_REFRESH_STATUS('db1.schema1.my_iceberg_table');

-- Example 6587
SYSTEM$BEGIN_DEBUG_APPLICATION( '<app_name>' [ , <execution_mode>] )

-- Example 6588
SELECT SYSTEM$BEGIN_DEBUG_APPLICATION( 'hello_snowflake_app', execution_mode ='AS_APPLICATION')

-- Example 6589
SELECT SYSTEM$BEGIN_DEBUG_APPLICATION( 'hello_snowflake_app', execution_mode = 'AS_SETUP_SCRIPT')

-- Example 6590
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE provider_role;
GRANT INSTALL ON APPLICATION PACKAGE hello_snowflake_package
  TO ROLE provider_role;

-- Example 6591
GRANT DEVELOP ON APPLICATION PACKAGE hello_snowflake_package TO ROLE other_dev_role;

-- Example 6592
CREATE APPLICATION hello_snowflake_app FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

-- Example 6593
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0;

-- Example 6594
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0 PATCH 2;

-- Example 6595
CREATE APPLICATION hello_snowflake_app FROM APPLICATION PACKAGE hello_snowflake_package;

-- Example 6596
ALTER APPLICATION HelloSnowflake
  UPGRADE USING @CODEDATABASE.CODESCHEMA.AppCodeStage;

-- Example 6597
ALTER APPLICATION HelloSnowflake
 UPGRADE USING VERSION "v1_1";

-- Example 6598
USE APPlICATION hello_snowflake_app;

-- Example 6599
SHOW APPLICATIONS;

-- Example 6600
DESC APPLICATION hello_snowflake_app;

-- Example 6601
ALTER APPLICATION hello_snowflake_app SET DEBUG_MODE = TRUE;

-- Example 6602
ALTER APPLICATION hello_snowflake_app SET DEBUG_MODE = FALSE;

-- Example 6603
SELECT SYSTEM$BEGIN_DEBUG_APPLICATION(‘hello_snowflake_app’);

-- Example 6604
SYSTEM$BEGIN_DEBUG_APPLICATION( 'hello_snowflake_app', execution_mode ='AS_APPLICATION')

-- Example 6605
SELECT SYSTEM$GET_DEBUG_STATUS();

-- Example 6606
SELECT SYSTEM$END_DEBUG_APPLICATION();

-- Example 6607
ALTER APPLICATION hello_snowflake_app SET DISABLE_APPLICATION_REDACTION = TRUE;

-- Example 6608
ALTER APPLICATION hello_snowflake_app SET DISABLE_APPLICATION_REDACTION = FALSE;

-- Example 6609
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING @path_to_staged_files
  AUTHORIZE_TELEMETRY_EVENT_SHARING = TRUE;

CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0
  PATCH 0
  AUTHORIZE_TELEMETRY_EVENT_SHARING = TRUE;

-- Example 6610
SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS( '<bundle_name>' )

-- Example 6611
SELECT SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2020_08');

-- Example 6612
+-------------------------------------------------+
| SYSTEM$BEHAVIOR_CHANGE_BUNDLE_STATUS('2020_08') |
|-------------------------------------------------|
| DISABLED                                        |
+-------------------------------------------------+

-- Example 6613
SYSTEM$BLOCK_INTERNAL_STAGES_PUBLIC_ACCESS()

