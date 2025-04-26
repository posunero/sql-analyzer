-- Example 13782
from snowflake.core.table import Table, TableColumn

my_table = Table(
  name="my_table",
  columns=[TableColumn(name="c1", datatype="int", nullable=False),
           TableColumn(name="c2", datatype="string")]
)
root.databases["my_db"].schemas["my_schema"].tables.create(my_table)

-- Example 13783
my_table = root.databases["my_db"].schemas["my_schema"].tables["my_table"].fetch()
print(my_table.to_dict())

-- Example 13784
from snowflake.core.table import PrimaryKey, TableColumn

my_table = root.databases["my_db"].schemas["my_schema"].tables["my_table"].fetch()
my_table.columns.append(TableColumn(name="c3", datatype="int", nullable=False, constraints=[PrimaryKey()]))

my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.create_or_alter(my_table)

-- Example 13785
tables = root.databases["my_db"].schemas["my_schema"].tables.iter(like="my%")
for table_obj in tables:
  print(table_obj.name)

-- Example 13786
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.swap_with("other_table")

-- Example 13787
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.swap_with(to_swap_table_name="other_table", target_database="other_db", target_schema="other_schema")

-- Example 13788
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]

my_table_res.suspend_recluster()
my_table_res.resume_recluster()
my_table_res.drop()
my_table_res.undrop()

-- Example 13789
from snowflake.core.event_table import EventTable

event_table = EventTable(
  name="my_event_table",
  data_retention_time_in_days = 3,
  max_data_extension_time_in_days = 5,
  change_tracking = True,
  default_ddl_collation = 'EN-CI',
  comment = 'CREATE EVENT TABLE'
)

event_tables = root.databases["my_db"].schemas["my_schema"].event_tables
event_tables.create(my_event_table)

-- Example 13790
my_event_table = root.databases["my_db"].schemas["my_schema"].event_tables["my_event_table"].fetch()
print(my_event_table.to_dict())

-- Example 13791
from snowflake.core.event_table import EventTableCollection

event_tables: EventTableCollection = root.databases["my_db"].schemas["my_schema"].event_tables
event_table_iter = event_tables.iter(like="my%")  # returns a PagedIter[EventTable]
for event_table_obj in event_table_iter:
  print(event_table_obj.name)

-- Example 13792
event_tables: EventTableCollection = root.databases["my_db"].schemas["my_schema"].event_tables
event_table_iter = event_tables.iter(starts_with="my", show_limit=10)
for event_table_obj in event_table_iter:
  print(event_table_obj.name)

-- Example 13793
my_event_table_res = root.databases["my_db"].schemas["my_schema"].event_tables["my_event_table"]

my_event_table_res.rename("my_other_event_table")
my_event_table_res.drop()

-- Example 13794
from snowflake.core.view import View, ViewColumn

my_view = View(
  name="my_view",
  columns=[
      ViewColumn(name="c1"), ViewColumn(name="c2"), ViewColumn(name="c3"),
  ],
  query="SELECT * FROM my_table",
)

root.databases["my_db"].schemas["my_schema"].views.create(my_view)

-- Example 13795
my_view = root.databases["my_db"].schemas["my_schema"].views["my_view"].fetch()
print(my_view.to_dict())

-- Example 13796
view_list = root.databases["my_db"].schemas["my_schema"].views.iter(like="my%")
for view_obj in view_list:
  print(view_obj.name)

-- Example 13797
view_list = root.databases["my_db"].schemas["my_schema"].views.iter(starts_with="my", show_limit=10)
for view_obj in view_list:
  print(view_obj.name)

-- Example 13798
my_view_res = root.databases["my_db"].schemas["my_schema"].views["my_view"]
my_view_res.drop()

-- Example 13799
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13800
from snowflake.core.dynamic_table import DynamicTable, DownstreamLag

my_dt = DynamicTable(
  name='my_dynamic_table',
  target_lag=DownstreamLag(),
  warehouse='my_wh',
  query='SELECT * FROM t',
)
dynamic_tables = root.databases['my_db'].schemas['my_schema'].dynamic_tables
dynamic_tables.create(my_dt)

-- Example 13801
from snowflake.core.dynamic_table import DynamicTable, UserDefinedLag

root.databases['my_db'].schemas['my_schema'].dynamic_tables.create(
  DynamicTable(
      name='my_dynamic_table2',
      kind='PERMANENT',
      target_lag=UserDefinedLag(seconds=60),
      warehouse='my_wh',
      query='SELECT * FROM t',
      refresh_mode='FULL',
      initialize='ON_SCHEDULE',
      cluster_by=['id > 1'],
      comment='test table',
      data_retention_time_in_days=7,
      max_data_extension_time_in_days=7,
  )
)

-- Example 13802
from snowflake.core.dynamic_table import DynamicTableClone

root.databases['my_db'].schemas['my_schema'].dynamic_tables.create(
  DynamicTableClone(
      name='my_dynamic_table2',
      warehouse='my_wh2',
  ),
  clone_table='my_dynamic_table',
)

-- Example 13803
dynamic_table = root.databases['my_db'].schemas['my_schema'].dynamic_tables['my_dynamic_table']
dt_details = dynamic_table.fetch()
print(dt_details.to_dict())

-- Example 13804
from snowflake.core.dynamic_table import DynamicTableCollection

dt_list = root.databases['my_db'].schemas['my_schema'].dynamic_tables.iter(like='my%')
for dt_obj in dt_list:
  print(dt_obj.name)

-- Example 13805
my_table_res = root.databases['my_db'].schemas['my_schema'].tables['my_dynamic_table']
my_table_res.swap_with('other_dynamic_table')

-- Example 13806
my_dynamic_table_res = root.databases["my_db"].schemas["my_schema"].dynamic_tables["my_dynamic_table"]

my_dynamic_table_res.refresh()
my_dynamic_table_res.suspend()
my_dynamic_table_res.resume()
my_dynamic_table_res.drop()
my_dynamic_table_res.undrop()

-- Example 13807
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13808
from snowflake.core.user_defined_function import (
    PythonFunction,
    ReturnDataType,
    UserDefinedFunction
)

function_of_python = UserDefinedFunction(
    "my_python_function",
    arguments=[],
    return_type=ReturnDataType(datatype="VARIANT"),
    language_config=PythonFunction(runtime_version="3.9", packages=[], handler="udf"),
    body="""
def udf():
    return {"key": "value"}
    """,
)

root.databases["my_db"].schemas["my_schema"].user_defined_functions.create(function_of_python)

-- Example 13809
from snowflake.core.user_defined_function import (
    Argument,
    JavaFunction,
    ReturnDataType,
    UserDefinedFunction
)

function_body = """
    class TestFunc {
        public static String echoVarchar(String x) {
            return x;
        }
    }
"""

function_of_java = UserDefinedFunction(
    name="my_java_function",
    arguments=[Argument(name="x", datatype="STRING")],
    return_type=ReturnDataType(datatype="VARCHAR", nullable=True),
    language_config=JavaFunction(
        handler="TestFunc.echoVarchar",
        runtime_version="11",
        target_path=target_path,
        packages=[],
        called_on_null_input=True,
        is_volatile=True,
    ),
    body=function_body,
    comment="test_comment",
)

root.databases["my_db"].schemas["my_schema"].user_defined_functions.create(function_of_java)

-- Example 13810
from snowflake.core.user_defined_function import (
    Argument,
    ReturnDataType,
    JavaScriptFunction,
    UserDefinedFunction
)

function_body = """
    if (D <= 0) {
        return 1;
    } else {
        var result = 1;
        for (var i = 2; i <= D; i++) {
            result = result * i;
        }
        return result;
    }
"""

function_of_javascript = UserDefinedFunction(
    name="my_javascript_function",
    arguments=[Argument(name="d", datatype="DOUBLE")],
    return_type=ReturnDataType(datatype="DOUBLE"),
    language_config=JavaScriptFunction(),
    body=function_body,
)

root.databases["my_db"].schemas["my_schema"].user_defined_functions.create(function_of_javascript)

-- Example 13811
from snowflake.core.user_defined_function import (
    Argument,
    ReturnDataType,
    ScalaFunction,
    UserDefinedFunction
)

function_body = """
    class Echo {
        def echoVarchar(x : String): String = {
            return x
        }
    }
"""

function_of_scala = UserDefinedFunction(
    name="my_scala_function",
    arguments=[Argument(name="x", datatype="VARCHAR")],
    return_type=ReturnDataType(datatype="VARCHAR"),
    language_config=ScalaFunction(
        runtime_version="2.12", handler="Echo.echoVarchar", target_path=target_path, packages=[]
    ),
    body=function_body,
    comment="test_comment",
)

root.databases["my_db"].schemas["my_schema"].user_defined_functions.create(function_of_scala)

-- Example 13812
from snowflake.core.user_defined_function import (
    ReturnDataType,
    SQLFunction,
    UserDefinedFunction
)

function_body = """3.141592654::FLOAT"""

function_of_sql = UserDefinedFunction(
    name="my_sql_function",
    arguments=[],
    return_type=ReturnDataType(datatype="FLOAT"),
    language_config=SQLFunction(),
    body=function_body,
)

root.databases["my_db"].schemas["my_schema"].user_defined_functions.create(function_of_sql)

-- Example 13813
my_udf = root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"].fetch()
print(my_udf.to_dict())

-- Example 13814
udf_iter = root.databases["my_db"].schemas["my_schema"].user_defined_functions.iter(like="my_java%")
for udf_obj in udf_iter:
    print(udf_obj.name)

-- Example 13815
root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"].rename(
    "my_other_js_function",
    target_database = "my_other_database",
    target_schema = "my_other_schema"
)

-- Example 13816
my_udf_res = root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"]
my_udf_res.drop()

-- Example 13817
from snowflake.core.procedure import Argument, ColumnType, Procedure, ReturnTable, SQLFunction

procedure = Procedure(
    name="my_procedure",
    arguments=[Argument(name="id", datatype="VARCHAR")],
    return_type=ReturnTable(
        column_list=[
            ColumnType(name="id", datatype="NUMBER),
            ColumnType(name="price", datatype="NUMBER"),
        ]
    ),
    language_config=SQLFunction(),
    body="
        DECLARE
            res RESULTSET DEFAULT (SELECT * FROM invoices WHERE id = :id);
        BEGIN
            RETURN TABLE(res);
        END;
    ",
)

procedures = root.databases["my_db"].schemas["my_schema"].procedures
procedures.create(procedure)

-- Example 13818
from snowflake.core.procedure import CallArgument, CallArgumentList

procedure_reference = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"]
call_argument_list = CallArgumentList(call_arguments=[
    CallArgument(name="id", datatype="NUMBER", value=1),
])
procedure_reference.call(call_argument_list)

-- Example 13819
my_procedure = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"].fetch()
print(my_procedure.to_dict())

-- Example 13820
procedure_iter = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="my%")
for procedure_obj in procedure_iter:
    print(procedure_obj.name)

-- Example 13821
my_procedure_res = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"]
my_procedure_res.drop()

-- Example 13822
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13823
from snowflake.core.catalog_integration import CatalogIntegration, Glue

root.catalog_integrations.create(CatalogIntegration(
    name="my_catalog_integration",
    catalog = Glue(
        catalog_namespace="abcd-ns",
        glue_aws_role_arn="arn:aws:iam::123456789012:role/sqsAccess",
        glue_catalog_id="1234567",
    ),
    table_format="ICEBERG",
    enabled=True,
))

-- Example 13824
from snowflake.core.catalog_integration import CatalogIntegration, ObjectStore

root.catalog_integrations.create(CatalogIntegration(
    name="my_catalog_integration",
    catalog = ObjectStore(),
    table_format="ICEBERG",
    enabled=True,
))

-- Example 13825
from snowflake.core.catalog_integration import CatalogIntegration, OAuth, Polaris, RestConfig

root.catalog_integrations.create(CatalogIntegration(
    name="my_catalog_integration",
    catalog = Polaris(
        catalog_namespace="abcd-ns",
        rest_config=RestConfig(
            catalog_uri="https://my_account.snowflakecomputing.com/polaris/api/catalog",
            warehouse="my-warehouse",
        ),
        rest_authentication=OAuth(
            type="OAUTH",
            oauth_client_id="my_client_id",
            oauth_client_secret="my_client_secret",
            oauth_allowed_scopes=["PRINCIPAL_ROLE:ALL"],
        ),
    ),
    table_format="ICEBERG",
    enabled=True,
))

-- Example 13826
my_catalog_integration = root.catalog_integrations["my_catalog_integration"].fetch()
print(my_catalog_integration.to_dict())

-- Example 13827
catalog_integration_iter = root.catalog_integrations.iter(like="my%")
for catalog_integration_obj in catalog_integration_iter:
  print(catalog_integration_obj.name)

-- Example 13828
my_catalog_integration_res = root.catalog_integrations["my_catalog_integration"]
my_catalog_integration_res.drop()

-- Example 13829
from snowflake.core.notification_integration import NotificationEmail, NotificationIntegration

my_notification_integration = NotificationIntegration(
  name="my_email_notification_integration",
  notification_hook=NotificationEmail(
      allowed_recipients=["test1@snowflake.com", "test2@snowflake.com"],
      default_recipients=["test1@snowflake.com"],
      default_subject="test default subject",
  ),
  enabled=True,
)

root.notification_integrations.create(my_notification_integration)

-- Example 13830
from snowflake.core.notification_integration import NotificationIntegration, NotificationWebhook

my_notification_integration = NotificationIntegration(
  name="my_webhook_notification_integration",
  enabled=False,
  notification_hook=NotificationWebhook(
      webhook_url=webhook_url,
      webhook_secret=WebhookSecret(
          # This example assumes that this secret already exists
          name="mySecret".upper(), database_name=database, schema_name=schema
      ),
      webhook_body_template=webhook_template,
      webhook_headers=webhook_headers,
  ),
)

root.notification_integrations.create(my_notification_integration)

-- Example 13831
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueAwsSnsOutbound

my_notification_integration = NotificationIntegration(
  name="my_aws_sns_outbound_notification_integration",
  enabled=False,
  notification_hook=NotificationQueueAwsSnsOutbound(
      aws_sns_topic_arn="arn:aws:sns:us-west-1:123456789012:sns-test-topic",
      aws_sns_role_arn="arn:aws:iam::123456789012:role/sns-test-topic",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 13832
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueAzureEventGridOutbound

my_notification_integration = NotificationIntegration(
  name="my_azure_outbound_notification_integration",
  enabled=False,
  notification_hook=NotificationQueueAzureEventGridOutbound(
      azure_event_grid_topic_endpoint="https://fake.queue.core.windows.net/api/events",
      azure_tenant_id="fake.onmicrosoft.com",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 13833
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueAzureEventGridInbound

my_notification_integration = NotificationIntegration(
  name="my_azure_inbound_notification_integration",
  enabled=False,
  notification_hook=NotificationQueueAzureEventGridInbound(
      azure_storage_queue_primary_uri="https://fake.queue.core.windows.net/snowapi_queue",
      azure_tenant_id="fake.onmicrosoft.com",
  ),
)

root.notification_integrations.create(my_notification_integration)

-- Example 13834
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueGcpPubsubOutbound

my_notification_integration = NotificationIntegration(
  name="my_gcp_outbound_notification_integration",
  enabled=False,
  notification_hook=NotificationQueueGcpPubsubOutbound(
      gcp_pubsub_topic_name="projects/fake-project-name/topics/pythonapi-test",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 13835
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueGcpPubsubInbound

my_notification_integration = NotificationIntegration(
  name="my_gcp_inbound_notification_integration",
  enabled=True,
  notification_hook=NotificationQueueGcpPubsubInbound(
      gcp_pubsub_subscription_name="projects/fake-project-name/subscriptions/sub-test",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 13836
my_notification_integration = root.notification_integrations["my_notification_integration"].fetch()
print(my_notification_integration.to_dict())

-- Example 13837
notification_integration_iter = root.notification_integrations.iter(like="my%")
for notification_integration_obj in notification_integration_iter:
  print(notification_integration_obj.name)

-- Example 13838
my_notification_integration_res = root.notification_integrations["my_notification_integration"]
my_notification_integration_res.drop()

-- Example 13839
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13840
from snowflake.core.network_policy import NetworkPolicy

my_network_policy = NetworkPolicy(
  name = 'my_network_policy',
  allowed_network_rule_list = ['allowed_network_rule1','allowed_network_rule2'],
  blocked_network_rule_list = ['blocked_network_rule1','blocked_network_rule2'],
  allowed_ip_list=['8.8.8.8'],
  blocked_ip_list=['192.100.123.0'],
)

root.network_policies.create(my_network_policy)

-- Example 13841
my_network_policy = root.network_policies["my_network_policy"].fetch()
print(my_network_policy.to_dict())

-- Example 13842
network_policy_iter = root.network_policies.iter(like="my%")  # returns a PagedIter[NetworkPolicy]
for network_policy_obj in network_policy_iter:
  print(network_policy_obj.name)

-- Example 13843
my_network_policy_res = root.network_policies["my_network_policy"]
my_network_policy_res.drop()

-- Example 13844
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13845
from snowflake.core.notebook import Notebook

my_nb = Notebook(name="my_nb")

notebooks = root.databases["my_db"].schemas["my_schema"].notebooks
notebooks.create(my_nb)

-- Example 13846
from snowflake.core.notebook import Notebook

my_nb = Notebook(name="my_nb",
  query_warehouse="my_wh",
  from_location="@my_stage",
  main_file="notebook_file.ipynb")

notebooks = root.databases["my_db"].schemas["my_schema"].notebooks
notebooks.create(my_nb)

-- Example 13847
my_nb = root.databases["my_db"].schemas["my_schema"].notebooks["my_nb"].fetch()
print(my_nb.to_dict())

-- Example 13848
from snowflake.core.notebook import NotebookCollection

notebooks: NotebookCollection = root.databases["my_db"].schemas["my_schema"].notebooks
nb_iter = notebooks.iter(like="my%")  # returns a PagedIter[Notebook]
for nb_obj in nb_iter:
  print(nb_obj.name)

