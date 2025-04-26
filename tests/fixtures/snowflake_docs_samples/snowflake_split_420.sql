-- Example 28115
# Create a Snowpark Pandas DataFrame with sample data.
df = pd.DataFrame([[1, 'Big Bear', 8],[2, 'Big Bear', 10],[3, 'Big Bear', None],
                    [1, 'Tahoe', 3],[2, 'Tahoe', None],[3, 'Tahoe', 13],
                    [1, 'Whistler', None],['Friday', 'Whistler', 40],[3, 'Whistler', 25]],
                    columns=["DAY", "LOCATION", "SNOWFALL"])
# Drop rows with null values.
df.dropna()
# Compute the average daily snowfall across locations.
df.groupby("LOCATION").mean()["SNOWFALL"]

-- Example 28116
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 28117
from snowflake.core import Root
api_root = Root(session)

-- Example 28118
# Create a database and schema by running the following cell in the notebook:
database_ref = api_root.databases.create(Database(name="demo_database"), mode="orreplace")
schema_ref = database_ref.schemas.create(Schema(name="demo_schema"), mode="orreplace")

-- Example 28119
>>> fqn = FQN.from_string("my_schema.object").using_connection(conn)

-- Example 28120
>>> fqn = FQN.from_string("my_name").set_database("db").set_schema("foo")

-- Example 28121
>>> operation = root.databases.iter_async()

-- Example 28122
>>> result = operation.result()

-- Example 28123
>>> result = operation.result(timeout=60)

-- Example 28124
>>> is_running = operation.running()

-- Example 28125
>>> cancelled = operation.cancel()

-- Example 28126
>>> exception = operation.exception()

-- Example 28127
>>> exception = operation.exception(timeout=60)

-- Example 28128
>>> operations = [task_collection.create_async(Task(name=f"task_{n}", definition="select 1")) for n in range(100)]
>>> concurrent.futures.wait(operations)

-- Example 28129
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

-- Example 28130
>>> tasks = root.databases["mydb"].schemas["myschema"].tasks
>>> mytask = tasks["mytask"]
>>> mytask.resume()
>>> compute_pools = root.compute_pools
>>> my_computepool = compute_pools["mycomputepool"]
>>> my_computepool.delete()

-- Example 28131
>>> root = Root(session)
>>> my_account = root.accounts["my_account"]

-- Example 28132
>>> root = Root(session)
>>> my_api_int = root.api_integrations["my_api_int"]

-- Example 28133
>>> root = Root(session)
>>> my_catalog_integration = root.catalog_integrations["my_catalog_integration"]

-- Example 28134
>>> root = Root(session)
>>> my_cp = root.compute_pools["my_cp"]

-- Example 28135
>>> root = Root(session)
>>> my_cortex_agent_service = root.cortex_agent_service

-- Example 28136
>>> root = Root(session)
>>> my_cortex_chat_service = root.cortex_chat_service

-- Example 28137
>>> root = Root(session)
>>> my_cortex_embed_service = root.cortex_embed_service

-- Example 28138
>>> root = Root(session)
>>> my_cortex_inference_service = root.cortex_inference_service

-- Example 28139
>>> root = Root(session)
>>> my_db = root.databases["my_db"]

-- Example 28140
>>> root = Root(session)
>>> my_external_volume = root.external_volumes["my_external_volume"]

-- Example 28141
>>> grants.grant(
...    Grant(
...        grantee=Grantees.role(name="public"),
...        securable=Securables.database("invaliddb123"),
...        privileges=[Privileges.create_database],
...        grant_option=False,
...    )
... )

-- Example 28142
>>> root = Root(session)
>>> my_managed_account = root.managed_accounts["my_managed_account"]

-- Example 28143
>>> root = Root(session)
>>> my_network_policy = root.network_policies["my_network_policy"]

-- Example 28144
>>> root = Root(session)
>>> my_nis = list(root.notification_integrations.iter())

-- Example 28145
>>> root = Root(session)
>>> my_role = root.roles["my_role"]

-- Example 28146
>>> root = Root(session)
>>> my_user = root.users["my_user"]

-- Example 28147
>>> root = Root(session)
>>> my_wh = root.warehouses["my_wh"]

-- Example 28148
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

-- Example 28149
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

-- Example 28150
>>> accounts = account_collection.iter()

-- Example 28151
>>> accounts = account_collection.iter(like="your-account-name")

-- Example 28152
>>> accounts = account_collection.iter(like="your-account-name%")

-- Example 28153
>>> for account in accounts:
>>>     print(account.name, account.comment)

-- Example 28154
>>> account_reference.drop()

-- Example 28155
>>> account_reference.drop(if_exists=True)

-- Example 28156
>>> account_reference.undrop()

-- Example 28157
>>> alert_reference.drop()

-- Example 28158
>>> alert_reference.drop(if_exists=True)

-- Example 28159
>>> alert_reference.execute()

-- Example 28160
>>> my_alert = alert_reference.fetch()
>>> print(my_alert.name, my_alert.condition, my_alert.action)

-- Example 28161
>>> alerts = schema.alerts
>>> alerts.create(
...     new_alert_name,
...     clone_alert=alert_name_to_be_cloned,
...     mode=CreateMode.if_not_exists,
... )

-- Example 28162
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

-- Example 28163
>>> alerts = alert_collection.iter()

-- Example 28164
>>> alerts = alert_collection.iter(like="your-alert-name")

-- Example 28165
>>> alerts = alert_collection.iter(like="your-alert-name-%")

-- Example 28166
>>> for alert in alerts:
>>>     print(alert.name, alert.condition, alert.action)

-- Example 28167
>>> root.api_integrations["my_api"].create_or_alter(my_api_def)

-- Example 28168
>>> api_integration_reference.drop()

-- Example 28169
>>> api_integration_reference.drop(if_exists=True)

-- Example 28170
>>> api_integration_reference = root.api_integrations["foo"]
>>> my_api_integration = api_integration_reference.fetch()
>>> print(my_api_integration.name)

-- Example 28171
>>> api_integrations = root.api_integrations
>>> new_api_integration = ApiIntegration(
...     name="name",
...     api_hook=AwsHook(
...         api_provider="AWS_API_GATEWAY",
...         api_aws_role_arn="your_arn",
...         api_key=os.environ.get("YOUR_API_KEY"),
...     ),
...     api_allowed_prefixes=["https://snowflake.com"],
...     enabled=True,
... )
>>> api_integrations.create(new_api_integration)

-- Example 28172
>>> api_integrations = root.api_integrations
>>> new_api_integration = ApiIntegration(
...     name="name",
...     api_hook=AwsHook(
...         api_provider="AWS_API_GATEWAY",
...         api_aws_role_arn="your_arn",
...         api_key=os.environ.get("YOUR_API_KEY"),
...     ),
...     api_allowed_prefixes=["https://snowflake.com"],
...     enabled=True,
... )
>>> api_integrations.create(new_api_integration, mode=CreateMode.or_replace)

-- Example 28173
>>> api_integrations = root.api_integrations.iter()

-- Example 28174
>>> api_integrations = root.api_integrations.iter(like="your-api-integration-name")

-- Example 28175
>>> api_integrations = root.api_integrations.iter(like="your-api-integration-name-%")

-- Example 28176
>>> for api_integration in api_integrations:
...     print(api_integration.name)

-- Example 28177
>>> catalog_integration_reference.drop()

-- Example 28178
>>> catalog_integration_reference.drop(if_exists = True)

-- Example 28179
>>> print(catalog_integration_reference.fetch().created_on)

-- Example 28180
>>> root.catalog_integrations.create(CatalogIntegration(
...     name = 'my_catalog_integration',
...     catalog = ObjectStore(),
...     table_format = "ICEBERG",
...     enabled = True,
... ))

-- Example 28181
>>> root.catalog_integrations.create(CatalogIntegration(
...     name = 'my_catalog_integration',
...     catalog = Glue(
...         catalog_namespace="abcd-ns",
...         glue_aws_role_arn="arn:aws:iam::123456789012:role/sqsAccess",
...         glue_catalog_id="1234567",
...     ),
...     table_format = "ICEBERG",
...     enabled = True,
... ))

