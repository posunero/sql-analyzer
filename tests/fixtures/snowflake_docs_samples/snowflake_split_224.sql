-- Example 14988
CREATE TASK my_task
    WHEN SYSTEM$STREAM_HAS_DATA('my_customer_stream')
    OR   SYSTEM$STREAM_HAS_DATA('my_order_stream')
    WAREHOUSE = my_warehouse
    AS
      SELECT CURRENT_TIMESTAMP;

-- Example 14989
CREATE TASK t1
  SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  AS
    SELECT CURRENT_TIMESTAMP;

-- Example 14990
CREATE TASK mytask_hour
  WAREHOUSE = mywh
  SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'
  AS
    SELECT CURRENT_TIMESTAMP;

-- Example 14991
CREATE TASK t1
  SCHEDULE = '60 MINUTES'
  TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  AS
    INSERT INTO mytable(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 14992
CREATE TASK mytask_minute
  WAREHOUSE = mywh
  SCHEDULE = '5 MINUTES'
  AS
    INSERT INTO mytable(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 14993
CREATE TASK mytask1
  WAREHOUSE = mywh
  SCHEDULE = '5 MINUTES'
  WHEN
    SYSTEM$STREAM_HAS_DATA('MYSTREAM')
  AS
    INSERT INTO mytable1(id,name) SELECT id, name FROM mystream WHERE METADATA$ACTION = 'INSERT';

-- Example 14994
-- Create task5 and specify task2, task3, task4 as predecessors tasks.
-- The new task is a serverless task that inserts the current timestamp into a table column.
CREATE TASK task5
  AFTER task2, task3, task4
AS
  INSERT INTO t1(ts) VALUES(CURRENT_TIMESTAMP);

-- Example 14995
-- Create a stored procedure that unloads data from a table
-- The COPY statement in the stored procedure unloads data to files in a path identified by epoch time (using the Date.now() method)
CREATE OR REPLACE PROCEDURE my_unload_sp()
  returns string not null
  language javascript
  AS
    $$
      var my_sql_command = ""
      var my_sql_command = my_sql_command.concat("copy into @mystage","/",Date.now(),"/"," from mytable overwrite=true;");
      var statement1 = snowflake.createStatement( {sqlText: my_sql_command} );
      var result_set1 = statement1.execute();
    return my_sql_command; // Statement returned for info/debug purposes
    $$;

-- Create a task that calls the stored procedure every hour
CREATE TASK my_copy_task
  WAREHOUSE = mywh
  SCHEDULE = '60 MINUTES'
  AS
    CALL my_unload_sp();

-- Example 14996
!set sql_delimiter=/
CREATE OR REPLACE TASK test_logging
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = 'USING CRON  0 * * * * America/Los_Angeles'
  AS
    BEGIN
      ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
      SELECT CURRENT_TIMESTAMP;
    END;/
!set sql_delimiter=';'

-- Example 14997
CREATE TASK t1
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '15 SECONDS'
  AS
    EXECUTE IMMEDIATE
    $$
    DECLARE
      radius_of_circle float;
      area_of_circle float;
    BEGIN
      radius_of_circle := 3;
      area_of_circle := pi() * radius_of_circle * radius_of_circle;
      return area_of_circle;
    END;
    $$;

-- Example 14998
CREATE OR REPLACE TASK root_task_with_config
  WAREHOUSE=mywarehouse
  SCHEDULE='10 m'
  CONFIG=$${"output_dir": "/temp/test_directory/", "learning_rate": 0.1}$$
  AS
    BEGIN
      LET OUTPUT_DIR STRING := SYSTEM$GET_TASK_GRAPH_CONFIG('output_dir')::string;
      LET LEARNING_RATE DECIMAL := SYSTEM$GET_TASK_GRAPH_CONFIG('learning_rate')::DECIMAL;
    ...
    END;

-- Example 14999
CREATE TASK finalize_task
  WAREHOUSE = my_warehouse
  FINALIZE = my_root_task
  AS
    CALL SYSTEM$SEND_EMAIL(
      'my_email_int',
      'first.last@example.com, first2.last2@example.com',
      'Email Alert: Task A has finished.',
      'Task A has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
    );

-- Example 15000
CREATE TASK triggeredTask  WAREHOUSE = my_warehouse
  WHEN system$stream_has_data('my_stream')
  AS
    INSERT INTO my_downstream_table
    SELECT * FROM my_stream;

ALTER TASK triggeredTask RESUME;

-- Example 15001
CREATE OR ALTER TASK my_task
  WAREHOUSE = my_warehouse
  SCHEDULE = '60 MINUTES'
  AS
    SELECT PI();

-- Example 15002
CREATE OR ALTER TASK my_task
  WAREHOUSE = regress
  AFTER my_other_task
  AS
    SELECT 2 * PI();

-- Example 15003
>>> fqn = FQN.from_string("my_schema.object").using_connection(conn)

-- Example 15004
>>> fqn = FQN.from_string("my_name").set_database("db").set_schema("foo")

-- Example 15005
>>> operation = root.databases.iter_async()

-- Example 15006
>>> result = operation.result()

-- Example 15007
>>> result = operation.result(timeout=60)

-- Example 15008
>>> is_running = operation.running()

-- Example 15009
>>> cancelled = operation.cancel()

-- Example 15010
>>> exception = operation.exception()

-- Example 15011
>>> exception = operation.exception(timeout=60)

-- Example 15012
>>> operations = [task_collection.create_async(Task(name=f"task_{n}", definition="select 1")) for n in range(100)]
>>> concurrent.futures.wait(operations)

-- Example 15013
>>> from snowflake.connector import connect
>>> from snowflake.core import Root
>>> from snowflake.snowpark import Session
>>> CONNECTION_PARAMETERS = {
...    "account": os.environ["snowflake_account_demo"],
...    "user": os.environ["snowflake_user_demo"],
...    "password": os.environ["snowflake_password_demo"],
...    "database": test_database,
...    "warehouse": test_warehouse,
...    "schema": test_schema,
... }
>>> # create from a Snowflake Connection
>>> connection = connect(**CONNECTION_PARAMETERS)
>>> root = Root(connection)
>>> # or create from a Snowpark Session
>>> session = Session.builder.config(CONNECTION_PARAMETERS).create()
>>> root = Root(session)

-- Example 15014
>>> tasks = root.databases["mydb"].schemas["myschema"].tasks
>>> mytask = tasks["mytask"]
>>> mytask.resume()
>>> compute_pools = root.compute_pools
>>> my_computepool = compute_pools["mycomputepool"]
>>> my_computepool.delete()

-- Example 15015
>>> root = Root(session)
>>> my_account = root.accounts["my_account"]

-- Example 15016
>>> root = Root(session)
>>> my_api_int = root.api_integrations["my_api_int"]

-- Example 15017
>>> root = Root(session)
>>> my_catalog_integration = root.catalog_integrations["my_catalog_integration"]

-- Example 15018
>>> root = Root(session)
>>> my_cp = root.compute_pools["my_cp"]

-- Example 15019
>>> root = Root(session)
>>> my_cortex_agent_service = root.cortex_agent_service

-- Example 15020
>>> root = Root(session)
>>> my_cortex_chat_service = root.cortex_chat_service

-- Example 15021
>>> root = Root(session)
>>> my_cortex_embed_service = root.cortex_embed_service

-- Example 15022
>>> root = Root(session)
>>> my_cortex_inference_service = root.cortex_inference_service

-- Example 15023
>>> root = Root(session)
>>> my_db = root.databases["my_db"]

-- Example 15024
>>> root = Root(session)
>>> my_external_volume = root.external_volumes["my_external_volume"]

-- Example 15025
>>> grants.grant(
...    Grant(
...        grantee=Grantees.role(name="public"),
...        securable=Securables.database("invaliddb123"),
...        privileges=[Privileges.create_database],
...        grant_option=False,
...    )
... )

-- Example 15026
>>> root = Root(session)
>>> my_managed_account = root.managed_accounts["my_managed_account"]

-- Example 15027
>>> root = Root(session)
>>> my_network_policy = root.network_policies["my_network_policy"]

-- Example 15028
>>> root = Root(session)
>>> my_nis = list(root.notification_integrations.iter())

-- Example 15029
>>> root = Root(session)
>>> my_role = root.roles["my_role"]

-- Example 15030
>>> root = Root(session)
>>> my_user = root.users["my_user"]

-- Example 15031
>>> root = Root(session)
>>> my_wh = root.warehouses["my_wh"]

-- Example 15032
>>> account_collection = root.accounts
>>> account = Account(
...     name="MY_ACCOUNT",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     first_name = "Jane"
...     last_name = "Smith"
...     email = 'myemail@myorg.org'
...     edition = "enterprise"
...     region = "aws_us_west_2"
...  )
>>> account_collection.create(account)

-- Example 15033
>>> account = Account(
...     name="MY_ACCOUNT",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     first_name = "Jane"
...     last_name = "Smith"
...     email = 'myemail@myorg.org'
...     edition = "enterprise"
...     region = "aws_us_west_2"
...  )
>>> # Use the account collection created before to create a reference to the account resource
>>> # in Snowflake.
>>> account_reference = account_collection.create(account)

-- Example 15034
>>> accounts = account_collection.iter()

-- Example 15035
>>> accounts = account_collection.iter(like="your-account-name")

-- Example 15036
>>> accounts = account_collection.iter(like="your-account-name%")

-- Example 15037
>>> for account in accounts:
>>>     print(account.name, account.comment)

-- Example 15038
>>> account_reference.drop()

-- Example 15039
>>> account_reference.drop(if_exists=True)

-- Example 15040
>>> account_reference.undrop()

-- Example 15041
>>> alert_reference.drop()

-- Example 15042
>>> alert_reference.drop(if_exists=True)

-- Example 15043
>>> alert_reference.execute()

-- Example 15044
>>> my_alert = alert_reference.fetch()
>>> print(my_alert.name, my_alert.condition, my_alert.action)

-- Example 15045
>>> alerts = schema.alerts
>>> alerts.create(
...     new_alert_name,
...     clone_alert=alert_name_to_be_cloned,
...     mode=CreateMode.if_not_exists,
... )

-- Example 15046
>>> alerts.create(
...     Alert(
...         name="my_alert",
...         warehouse="my_warehouse",
...         schedule="MinutesSchedule(minutes=1)",
...         condition="SELECT COUNT(*) FROM my_table > 100",
...         action="DROP TABLE my_table",
...     ),
...     mode=CreateMode.if_not_exists,
... )

-- Example 15047
>>> alerts = alert_collection.iter()

-- Example 15048
>>> alerts = alert_collection.iter(like="your-alert-name")

-- Example 15049
>>> alerts = alert_collection.iter(like="your-alert-name-%")

-- Example 15050
>>> for alert in alerts:
>>>     print(alert.name, alert.condition, alert.action)

-- Example 15051
>>> root.api_integrations["my_api"].create_or_alter(my_api_def)

-- Example 15052
>>> api_integration_reference.drop()

-- Example 15053
>>> api_integration_reference.drop(if_exists=True)

-- Example 15054
>>> api_integration_reference = root.api_integrations["foo"]
>>> my_api_integration = api_integration_reference.fetch()
>>> print(my_api_integration.name)

