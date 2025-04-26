-- Example 7083
Private endpoint with id ''/subscriptions/66666666-7777-8888-9999-0000000000/resourcegroups/rg/providers/microsoft.network/privateendpoints/00000000-1111-2222-3333-4444444444'' restored successfully.

-- Example 7084
SYSTEM$REVOKE_PRIVATELINK( '<aws_id>' , '<federated_token>' )

-- Example 7085
SYSTEM$REVOKE_PRIVATELINK( '<private-endpoint-resource-id>' , '<federated_token>' )

-- Example 7086
aws sts get-federation-token --name sam

-- Example 7087
az account get-access-token --subscription <SubscriptionID>

-- Example 7088
az account list --output table

-- Example 7089
Name     CloudName   SubscriptionId                        State    IsDefault
-------  ----------  ------------------------------------  -------  ----------
MyCloud  AzureCloud  13c...                                Enabled  True

-- Example 7090
use role accountadmin;

select SYSTEM$REVOKE_PRIVATELINK(
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

-- Example 7091
use role accountadmin;

select SYSTEM$REVOKE_PRIVATELINK(
  '/subscriptions/26d.../resourcegroups/sf-1/providers/microsoft.network/privateendpoints/test-self-service',
  'eyJ...');

-- Example 7092
-- Azure
SYSTEM$REVOKE_STAGE_PRIVATELINK_ACCESS( '<privateEndpointResourceID>' )

-- Example 7093
use role accountadmin;

select SYSTEM$REVOKE_STAGE_PRIVATELINK_ACCESS('/subscriptions/subId/resourceGroups/rg1/providers/Microsoft.Network/privateEndpoints/pe1');

-- Example 7094
SYSTEM$SCHEDULE_ASYNC_REPLICATION_GROUP_REFRESH(<replication_group_name>)
SYSTEM$SCHEDULE_ASYNC_REPLICATION_GROUP_REFRESH(<failover_group_name>)

-- Example 7095
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$SCHEDULE_ASYNC_REPLICATION_GROUP_REFRESH('failover_group_1');
SELECT SYSTEM$SCHEDULE_ASYNC_REPLICATION_GROUP_REFRESH('failover_group_2');

-- Example 7096
SYSTEM$SEND_NOTIFICATIONS_TO_CATALOG( '<domain>' , '<entity_name>' [ , '<notification_type>'] [ , '<catalog_sync_integration_name>'] )

-- Example 7097
SELECT VALUE[0]::STRING AS tableName,
       VALUE[1]::BOOLEAN notificationStatus,
       VALUE[2]::STRING errorCode,
       VALUE[3]::STRING errorMessage
  FROM TABLE(FLATTEN(PARSE_JSON(
    SELECT SYSTEM$SEND_NOTIFICATIONS_TO_CATALOG(
      'SCHEMA',
      'testSchema'))));

-- Example 7098
SELECT VALUE[0]::STRING AS tableName,
       VALUE[1]::BOOLEAN notificationStatus,
       VALUE[2]::STRING errorCode,
       VALUE[3]::STRING errorMessage
   FROM TABLE(FLATTEN(PARSE_JSON(
     SELECT SYSTEM$SEND_NOTIFICATIONS_TO_CATALOG(
       'TABLE',
       'icebergTable',
       'DROP',
       'my_catalog_sync_integration'))));

-- Example 7099
SYSTEM$SET_APPLICATION_RESTRICTED_FEATURE_ACCESS(
  '<app_name>',
  '<type>',
  '<parameters>'
)

-- Example 7100
{"external_data": {"allowed_cloud_providers" : "all"}}

-- Example 7101
"{""external_data"":{""allowed_cloud_providers"":""none""}}"

-- Example 7102
SELECT SYSTEM$SET_APPLICATION_RESTRICTED_FEATURE_ACCESS('hello_snowflake_app', 'external_data', '{"allowed_cloud_providers" : "none"}');

-- Example 7103
"SYSTEM$SET_APPLICATION_RESTRICTED_FEATURE_ACCESS('EXTERNAL_DATA_DEMO_APP', 'EXTERNAL_DATA', '{""ALLOWED_CLOUD_PROVIDERS"" : ""NONE""}')"
"{""external_data"":{""allowed_cloud_providers"":""none""}}"

-- Example 7104
SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION( '<snowflake_region>' , '<region_group>' , '<account_name>' )

-- Example 7105
SELECT SYSTEM$SET_EVENT_SHARING_ACCOUNT_FOR_REGION('aws_us_west_2', 'public', 'myaccount');

-- Example 7106
SYSTEM$SET_REFERENCE('<reference_name>', '<reference_string>')

-- Example 7107
SYSTEM$SET_RETURN_VALUE( '<string_expression>' )

-- Example 7108
-- create a table to store the return values.
create or replace table return_values (str varchar);

-- create a task that sets the return value for the task.
create task set_return_value
  warehouse=return_task_wh
  schedule='1 minute' as
  call system$set_return_value('The quick brown fox jumps over the lazy dog');

-- create a task that identifies the first task as the predecessor task and retrieves the return value set for that task.
create task get_return_value
  warehouse=return_task_wh
  after set_return_value
  as
    insert into return_values values(system$get_predecessor_return_value());


-- Note that if there are multiple predecessor tasks that are enabled, you must specify the name of the task to retrieve the return value for that task.
create task get_return_value_by_pred
  warehouse=return_task_wh
  after set_return_value
  as
    insert into return_values values(system$get_predecessor_return_value('SET_RETURN_VALUE'));

-- resume task (using ALTER TASK ... RESUME).
-- wait for task to run on schedule.

select distinct(str) from return_values;
+-----------------------------------------------+
|                      STR                      |
+-----------------------------------------------+
|  The quick brown fox jumps over the lazy dog  |
+-----------------------------------------------+

select distinct(RETURN_VALUE)
  from table(information_schema.task_history())
  where RETURN_VALUE is not NULL;

+-----------------------------------------------+
|                  RETURN_VALUE                 |
+-----------------------------------------------+
|  The quick brown fox jumps over the lazy dog  |
+-----------------------------------------------+

-- Example 7109
-- create a table to store the return values.
create or replace table return_values_sp (str varchar);

-- create a stored procedure that sets the return value for the task.
create or replace procedure set_return_value_sp()
returns string
language javascript
execute as caller
as $$
  var stmt = snowflake.createStatement({sqlText:`call system$set_return_value('The quick brown fox jumps over the lazy dog');`});
  var res = stmt.execute();
$$;

-- create a stored procedure that inserts the return value for the predecessor task into the 'return_values_sp' table.
create or replace procedure get_return_value_sp()
returns string
language javascript
execute as caller
as $$
var stmt = snowflake.createStatement({sqlText:`insert into return_values_sp values(system$get_predecessor_return_value());`});
var res = stmt.execute();
$$;

-- create a task that calls the set_return_value stored procedure.
create task set_return_value_t
warehouse=warehouse1
schedule='1 minute'
as
  call set_return_value_sp();

-- create a task that calls the get_return_value stored procedure.
create task get_return_value_t
warehouse=warehouse1
after set_return_value_t
as
  call get_return_value_sp();

-- resume task.
-- wait for task to run on schedule.

select distinct(str) from return_values_sp;
+-----------------------------------------------+
|                      STR                      |
+-----------------------------------------------+
|  The quick brown fox jumps over the lazy dog  |
+-----------------------------------------------+

select distinct(RETURN_VALUE)
  from table(information_schema.task_history())
  where RETURN_VALUE is not NULL;

+-----------------------------------------------+
|                  RETURN_VALUE                 |
+-----------------------------------------------+
|  The quick brown fox jumps over the lazy dog  |
+-----------------------------------------------+

-- Example 7110
SYSTEM$SET_SPAN_ATTRIBUTES('<object>');

-- Example 7111
create procedure MYPROC()
returns double
language sql
as
$$
begin
    -- Add an event without attributes
    SYSTEM$ADD_EVENT('name_a');

    -- Add an event with attributes
    let attr := {'score':89, 'pass':true};
    SYSTEM$ADD_EVENT('name_b', attr);

    -- Set attributes for the span
    SYSTEM$SET_SPAN_ATTRIBUTES('{'attr1':'value1', 'attr2':true}');

    return 3.14;
end;
$$
;

-- Example 7112
SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES()

-- Example 7113
SELECT SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES();

-- Example 7114
+--------------------------------------------------------------------------------------------------------------+
| SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES()                                                                 |
|--------------------------------------------------------------------------------------------------------------|
| [{"name":"2023_08","isDefault":true,"isEnabled":true},{"name":"2024_01","isDefault":false,"isEnabled":true}] |
+--------------------------------------------------------------------------------------------------------------+

-- Example 7115
SELECT
    bundles.VALUE:name::VARCHAR AS bundle_name,
    bundles.VALUE:isDefault::BOOLEAN AS is_enabled_by_default,
    bundles.VALUE:isEnabled::BOOLEAN AS is_actually_enabled_in_account
  FROM
    TABLE(FLATTEN(input => PARSE_JSON(SYSTEM$SHOW_ACTIVE_BEHAVIOR_CHANGE_BUNDLES())))
    AS bundles;

-- Example 7116
+-------------+-----------------------+--------------------------------+
| BUNDLE_NAME | IS_ENABLED_BY_DEFAULT | IS_ACTUALLY_ENABLED_IN_ACCOUNT |
|-------------+-----------------------+--------------------------------|
| 2023_08     | True                  | True                           |
| 2024_01     | False                 | True                           |
+-------------+-----------------------+--------------------------------+

-- Example 7117
SYSTEM$SHOW_BUDGETS_FOR_RESOURCE( '<resource_domain>' , '<resource_name>' )

-- Example 7118
SELECT SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('SCHEMA', 'my_db.my_schema');

-- Example 7119
+---------------------------------------------------------------+
| SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('SCHEMA', 'MY_DB.MY_SCHEMA') |
|---------------------------------------------------------------|
| [BUDGETS_DB.BUDGETS_SCHEMA.MY_BUDGET]                         |
+---------------------------------------------------------------+

-- Example 7120
SELECT SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'my_db.my_schema.my_table');

-- Example 7121
+-----------------------------------------------------------------------+
| SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'MY_DB.MY_SCHEMA.MY_TABLE') |
|-----------------------------------------------------------------------|
| []                                                                    |
+-----------------------------------------------------------------------+

-- Example 7122
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN ACCOUNT;

-- Example 7123
SHOW PARAMETERS LIKE 'TIMESTAMP_INPUT_FORMAT' IN ACCOUNT;

-- Example 7124
SYSTEM$SHOW_BUDGETS_IN_ACCOUNT()

-- Example 7125
SELECT SYSTEM$SHOW_BUDGETS_IN_ACCOUNT();

-- Example 7126
SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS()

-- Example 7127
SELECT SYSTEM$SHOW_EVENT_SHARING_ACCOUNTS();

-- Example 7128
SYSTEM$SHOW_MOVE_ORGANIZATION_ACCOUNT_STATUS( )

-- Example 7129
SELECT SYSTEM$SHOW_MOVE_ORGANIZATION_ACCOUNT_STATUS();

-- Example 7130
SYSTEM$SHOW_OAUTH_CLIENT_SECRETS( '<integration_name>' )

-- Example 7131
select system$show_oauth_client_secrets('MYINT');

-- Example 7132
SYSTEM$SNOWPIPE_STREAMING_UPDATE_CHANNEL_OFFSET_TOKEN('<dbName>.<schemaName>.<tableName>', '<channelName>', '<new_offset_token>')

-- Example 7133
show channels;
select SYSTEM$SNOWPIPE_STREAMING_UPDATE_CHANNEL_OFFSET_TOKEN('mydb.myschema.mytable', 'mychannel', '<new_offset_token>');
show channels;

-- Example 7134
SYSTEM$STREAM_BACKLOG('<stream_name>')

-- Example 7135
SELECT * FROM TABLE(SYSTEM$STREAM_BACKLOG('db1.schema1.s1'));

-- Example 7136
create or replace table orders (id int, order_name varchar);
create or replace table customers (id int, customer_name varchar);

-- Example 7137
create or replace view ordersByCustomer as select * from orders natural join customers;
insert into orders values (1, 'order1');
insert into customers values (1, 'customer1');

-- Example 7138
create or replace stream ordersByCustomerStream on view ordersBycustomer;

-- Example 7139
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
+----+------------+---------------+

select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
+----+------------+---------------+-----------------+-------------------+

-- Example 7140
insert into orders values (1, 'order2');
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
|  1 | order2     | customer1     |
+----+------------+---------------+

-- Example 7141
select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
|  1 | order2     | customer1     | INSERT          | False             |
+----+------------+---------------+-----------------+-------------------+

-- Example 7142
insert into customers values (1, 'customer2');
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
|  1 | order2     | customer1     |
|  1 | order1     | customer2     |
|  1 | order2     | customer2     |
+----+------------+---------------+

-- Example 7143
select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
|  1 | order1     | customer2     | INSERT          | False             |
|  1 | order2     | customer1     | INSERT          | False             |
|  1 | order2     | customer2     | INSERT          | False             |
+----+------------+---------------+-----------------+-------------------+

-- Example 7144
SYSTEM$STREAM_GET_TABLE_TIMESTAMP('<stream_name>')

-- Example 7145
CREATE STREAM ... AT ( STREAM => '<stream-name>' )

-- Example 7146
create table MYTABLE1 (id int);

create table MYTABLE2(id int);

create or replace stream MYSTREAM on table MYTABLE1;

insert into MYTABLE1 values (1);

-- consume the stream
begin;
insert into MYTABLE2 select id from MYSTREAM;
commit;

-- return the current offset for the stream
select system$stream_get_table_timestamp('MYSTREAM');

-- Example 7147
SYSTEM$STREAM_HAS_DATA('<stream_name>')

-- Example 7148
create table MYTABLE1 (id int);

create table MYTABLE2(id int);

create stream MYSTREAM on table MYTABLE1;

insert into MYTABLE1 values (1);

-- returns true because the stream contains change tracking information
select system$stream_has_data('MYSTREAM');

+----------------------------------------+
| SYSTEM$STREAM_HAS_DATA('MYSTREAM')     |
|----------------------------------------|
| True                                   |
+----------------------------------------+

 -- consume the stream
begin;
insert into MYTABLE2 select id from MYSTREAM;
commit;

-- returns false because the stream was consumed
select system$stream_has_data('MYSTREAM');

+----------------------------------------+
| SYSTEM$STREAM_HAS_DATA('MYSTREAM')     |
|----------------------------------------|
| False                                  |
+----------------------------------------+

-- Example 7149
SYSTEM$TASK_DEPENDENTS_ENABLE( '<task_name>' )

