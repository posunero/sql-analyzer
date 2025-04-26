-- Example 13983
my_event_table_res = root.databases["my_db"].schemas["my_schema"].event_tables["my_event_table"]

my_event_table_res.rename("my_other_event_table")
my_event_table_res.drop()

-- Example 13984
from snowflake.core.view import View, ViewColumn

my_view = View(
  name="my_view",
  columns=[
      ViewColumn(name="c1"), ViewColumn(name="c2"), ViewColumn(name="c3"),
  ],
  query="SELECT * FROM my_table",
)

root.databases["my_db"].schemas["my_schema"].views.create(my_view)

-- Example 13985
my_view = root.databases["my_db"].schemas["my_schema"].views["my_view"].fetch()
print(my_view.to_dict())

-- Example 13986
view_list = root.databases["my_db"].schemas["my_schema"].views.iter(like="my%")
for view_obj in view_list:
  print(view_obj.name)

-- Example 13987
view_list = root.databases["my_db"].schemas["my_schema"].views.iter(starts_with="my", show_limit=10)
for view_obj in view_list:
  print(view_obj.name)

-- Example 13988
my_view_res = root.databases["my_db"].schemas["my_schema"].views["my_view"]
my_view_res.drop()

-- Example 13989
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13990
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

-- Example 13991
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

-- Example 13992
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

-- Example 13993
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

-- Example 13994
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

-- Example 13995
my_udf = root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"].fetch()
print(my_udf.to_dict())

-- Example 13996
udf_iter = root.databases["my_db"].schemas["my_schema"].user_defined_functions.iter(like="my_java%")
for udf_obj in udf_iter:
    print(udf_obj.name)

-- Example 13997
root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"].rename(
    "my_other_js_function",
    target_database = "my_other_database",
    target_schema = "my_other_schema"
)

-- Example 13998
my_udf_res = root.databases["my_db"].schemas["my_schema"].user_defined_functions["my_javascript_function(DOUBLE)"]
my_udf_res.drop()

-- Example 13999
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

-- Example 14000
from snowflake.core.procedure import CallArgument, CallArgumentList

procedure_reference = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"]
call_argument_list = CallArgumentList(call_arguments=[
    CallArgument(name="id", datatype="NUMBER", value=1),
])
procedure_reference.call(call_argument_list)

-- Example 14001
my_procedure = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"].fetch()
print(my_procedure.to_dict())

-- Example 14002
procedure_iter = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="my%")
for procedure_obj in procedure_iter:
    print(procedure_obj.name)

-- Example 14003
my_procedure_res = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure(NUMBER, NUMBER)"]
my_procedure_res.drop()

-- Example 14004
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 14005
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

-- Example 14006
from snowflake.core.catalog_integration import CatalogIntegration, ObjectStore

root.catalog_integrations.create(CatalogIntegration(
    name="my_catalog_integration",
    catalog = ObjectStore(),
    table_format="ICEBERG",
    enabled=True,
))

-- Example 14007
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

-- Example 14008
my_catalog_integration = root.catalog_integrations["my_catalog_integration"].fetch()
print(my_catalog_integration.to_dict())

-- Example 14009
catalog_integration_iter = root.catalog_integrations.iter(like="my%")
for catalog_integration_obj in catalog_integration_iter:
  print(catalog_integration_obj.name)

-- Example 14010
my_catalog_integration_res = root.catalog_integrations["my_catalog_integration"]
my_catalog_integration_res.drop()

-- Example 14011
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

-- Example 14012
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

-- Example 14013
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

-- Example 14014
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

-- Example 14015
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

-- Example 14016
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueGcpPubsubOutbound

my_notification_integration = NotificationIntegration(
  name="my_gcp_outbound_notification_integration",
  enabled=False,
  notification_hook=NotificationQueueGcpPubsubOutbound(
      gcp_pubsub_topic_name="projects/fake-project-name/topics/pythonapi-test",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 14017
from snowflake.core.notification_integration import NotificationIntegration, NotificationQueueGcpPubsubInbound

my_notification_integration = NotificationIntegration(
  name="my_gcp_inbound_notification_integration",
  enabled=True,
  notification_hook=NotificationQueueGcpPubsubInbound(
      gcp_pubsub_subscription_name="projects/fake-project-name/subscriptions/sub-test",
  )
)

root.notification_integrations.create(my_notification_integration)

-- Example 14018
my_notification_integration = root.notification_integrations["my_notification_integration"].fetch()
print(my_notification_integration.to_dict())

-- Example 14019
notification_integration_iter = root.notification_integrations.iter(like="my%")
for notification_integration_obj in notification_integration_iter:
  print(notification_integration_obj.name)

-- Example 14020
my_notification_integration_res = root.notification_integrations["my_notification_integration"]
my_notification_integration_res.drop()

-- Example 14021
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 14022
from snowflake.core.compute_pool import ComputePool

compute_pool = ComputePool(name="my_compute_pool", min_nodes=1, max_nodes=2, instance_family="CPU_X64_XS", auto_resume=False)
root.compute_pools.create(compute_pool)

-- Example 14023
compute_pool = root.compute_pools["my_compute_pool"].fetch()
print(compute_pool.to_dict())

-- Example 14024
compute_pool = root.compute_pools["my_compute_pool"].fetch()
compute_pool.max_nodes = 3
compute_pool_res = root.compute_pools["my_compute_pool"].create_or_alter(compute_pool)

-- Example 14025
compute_pools = root.compute_pools.iter(like="my%")
for compute_pool in compute_pools:
  print(compute_pool.name)

-- Example 14026
compute_pool_res = root.compute_pools["my_compute_pool"]
compute_pool_res.suspend()
compute_pool_res.resume()
compute_pool_res.stop_all_services()

-- Example 14027
from snowflake.core.image_repository import ImageRepository

my_repo = ImageRepository("my_repo")
root.databases["my_db"].schemas["my_schema"].image_repositories.create(my_repo)

-- Example 14028
my_repo_res = root.databases["my_db"].schemas["my_schema"].image_repositories["my_repo"]
my_repo = my_repo_res.fetch()
print(my_repo.owner)

-- Example 14029
repo_list = root.databases["my_db"].schemas["my_schema"].image_repositories.iter()
for repo_obj in repo_list:
  print(repo_obj.name)

-- Example 14030
my_repo_res = root.databases["my_db"].schemas["my_schema"].image_repositories["my_repo"]
my_repo_res.drop()

-- Example 14031
session.file.put("/local_location/my_service_spec.yaml", "@my_stage")

-- Example 14032
service_spec_string = """
// Specification as a string.
"""
session.file.put_stream(StringIO(sepc_in_string), "@my_stage/my_service_spec.yaml")

-- Example 14033
from snowflake.core.service import Service, ServiceSpec

my_service = Service(name="my_service", min_instances=1, max_instances=2, compute_pool="my_compute_pool", spec=ServiceSpec("@my_stage/my_service_spec.yaml"))
root.databases["my_db"].schemas["my_schema"].services.create(my_service)

-- Example 14034
from textwrap import dedent
from snowflake.core.service import Service, ServiceSpec

spec_text = dedent(f"""\
    spec:
      containers:
      - name: hello-world
        image: repo/hello-world:latest
      endpoints:
      - name: hello-world-endpoint
        port: 8080
        public: true
    """)

my_service = Service(name="my_service", min_instances=1, max_instances=2, compute_pool="my_compute_pool", spec=ServiceSpec(spec_text))
root.databases["my_db"].schemas["my_schema"].services.create(my_service)

-- Example 14035
from snowflake.core import CreateMode
from snowflake.core.function import FunctionArgument, ServiceFunction

root.databases["my_db"].schemas["my_schema"].functions.create(
  ServiceFunction(
    name="my-udf",
    arguments=[
        FunctionArgument(name="input", datatype="TEXT")
    ],
    returns="TEXT",
    service="hello-world",
    endpoint="'hello-world-endpoint'",
    path="/hello-world-path",
    max_batch_rows=5,
  ),
  mode = CreateMode.or_replace
)

-- Example 14036
result = root.databases["my_db"].schemas["my_schema"].functions["my-udf(TEXT)"].execute_function(["test"])
print(result)

-- Example 14037
my_service = root.databases["my_db"].schemas["my_schema"].services["my_service"].fetch()

-- Example 14038
services = root.databases["my_db"].schemas["my_schema"].services.iter(like="my%")
for service_obj in services:
  print(service_obj.name)

-- Example 14039
my_service_res = root.databases["my_db"].schemas["my_schema"].services["my_service"]

my_service_res.suspend()
my_service_res.resume()
status = my_service_res.get_service_status(10)

-- Example 14040
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 14041
from snowflake.core.user import User

my_user = User(name="my_user")
root.users.create(my_user)

-- Example 14042
my_user = root.users["my_user"].fetch()
print(my_user.to_dict())

-- Example 14043
user_parameters = root.users["my_user"].fetch()
user_parameters.first_name="Snowy"
user_parameters.last_name="User"
user_parameters.must_change_password=False
root.users["my_user"].create_or_alter(user_parameters)

-- Example 14044
users = root.users.iter(like="my%")
for user in users:
  print(user.name)

-- Example 14045
my_user_res = root.users["my_user"]
my_user_res.drop()

-- Example 14046
from snowflake.core.role import Role

my_role = Role(name="my_role")
root.roles.create(my_role)

-- Example 14047
root.session.use_role("my_role")

-- Example 14048
role_list = root.roles.iter()
for role_obj in role_list:
  print(role_obj.name)

-- Example 14049
my_role_res = root.roles["my_role"]
my_role_res.drop()

