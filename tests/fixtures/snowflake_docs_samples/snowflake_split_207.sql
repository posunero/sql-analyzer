-- Example 13849
my_nb_res = root.databases["my_db"].schemas["my_schema"].notebooks["my_nb"]

my_nb_res.add_live_version(from_last=True)
my_nb_res.commit()
my_nb_res.execute()
my_nb_res.drop()

-- Example 13850
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13851
from snowflake.core.compute_pool import ComputePool

compute_pool = ComputePool(name="my_compute_pool", min_nodes=1, max_nodes=2, instance_family="CPU_X64_XS", auto_resume=False)
root.compute_pools.create(compute_pool)

-- Example 13852
compute_pool = root.compute_pools["my_compute_pool"].fetch()
print(compute_pool.to_dict())

-- Example 13853
compute_pool = root.compute_pools["my_compute_pool"].fetch()
compute_pool.max_nodes = 3
compute_pool_res = root.compute_pools["my_compute_pool"].create_or_alter(compute_pool)

-- Example 13854
compute_pools = root.compute_pools.iter(like="my%")
for compute_pool in compute_pools:
  print(compute_pool.name)

-- Example 13855
compute_pool_res = root.compute_pools["my_compute_pool"]
compute_pool_res.suspend()
compute_pool_res.resume()
compute_pool_res.stop_all_services()

-- Example 13856
from snowflake.core.image_repository import ImageRepository

my_repo = ImageRepository("my_repo")
root.databases["my_db"].schemas["my_schema"].image_repositories.create(my_repo)

-- Example 13857
my_repo_res = root.databases["my_db"].schemas["my_schema"].image_repositories["my_repo"]
my_repo = my_repo_res.fetch()
print(my_repo.owner)

-- Example 13858
repo_list = root.databases["my_db"].schemas["my_schema"].image_repositories.iter()
for repo_obj in repo_list:
  print(repo_obj.name)

-- Example 13859
my_repo_res = root.databases["my_db"].schemas["my_schema"].image_repositories["my_repo"]
my_repo_res.drop()

-- Example 13860
session.file.put("/local_location/my_service_spec.yaml", "@my_stage")

-- Example 13861
service_spec_string = """
// Specification as a string.
"""
session.file.put_stream(StringIO(sepc_in_string), "@my_stage/my_service_spec.yaml")

-- Example 13862
from snowflake.core.service import Service, ServiceSpec

my_service = Service(name="my_service", min_instances=1, max_instances=2, compute_pool="my_compute_pool", spec=ServiceSpec("@my_stage/my_service_spec.yaml"))
root.databases["my_db"].schemas["my_schema"].services.create(my_service)

-- Example 13863
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

-- Example 13864
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

-- Example 13865
result = root.databases["my_db"].schemas["my_schema"].functions["my-udf(TEXT)"].execute_function(["test"])
print(result)

-- Example 13866
my_service = root.databases["my_db"].schemas["my_schema"].services["my_service"].fetch()

-- Example 13867
services = root.databases["my_db"].schemas["my_schema"].services.iter(like="my%")
for service_obj in services:
  print(service_obj.name)

-- Example 13868
my_service_res = root.databases["my_db"].schemas["my_schema"].services["my_service"]

my_service_res.suspend()
my_service_res.resume()
status = my_service_res.get_service_status(10)

-- Example 13869
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13870
from snowflake.core.stream import PointOfTimeOffset, Stream, StreamSourceTable

stream_on_table = Stream(
  "my_stream_on_table",
  StreamSourceTable(
      point_of_time = PointOfTimeOffset(reference="before", offset="1"),
      name = 'my_table',
      append_only = True,
      show_initial_rows = False,
  ),
  comment = 'create stream on table'
)

streams = root.databases['my_db'].schemas['my_schema'].streams
streams.create(stream_on_table)

-- Example 13871
from snowflake.core.stream import PointOfTimeOffset, Stream, StreamSourceView

stream_on_view = Stream(
  "my_stream_on_view",
  StreamSourceView(
      point_of_time = PointOfTimeOffset(reference="before", offset="1"),
      name = 'my_view',
  ),
  comment = 'create stream on view'
)

streams = root.databases['my_db'].schemas['my_schema'].streams
streams.create(stream_on_view)

-- Example 13872
from snowflake.core.stream import PointOfTimeOffset, Stream, StreamSourceStage

stream_on_directory_table = Stream(
  "my_stream_on_directory_table",
  StreamSourceStage(
      point_of_time = PointOfTimeOffset(reference="before", offset="1"),
      name = 'my_directory_table',
  ),
  comment = 'create stream on directory table'
)

streams = root.databases['my_db'].schemas['my_schema'].streams
streams.create(stream_on_directory_table)

-- Example 13873
from snowflake.core.stream import Stream

streams = root.databases['my_db'].schemas['my_schema'].streams
streams.create("my_stream", clone_stream="my_other_stream")

-- Example 13874
stream = root.databases['my_db'].schemas['my_schema'].streams['my_stream']
stream_details = stream.fetch()
print(stream_details.to_dict())

-- Example 13875
stream_list = root.databases['my_db'].schemas['my_schema'].streams.iter(like='my%')
for stream_obj in stream_list:
  print(stream_obj.name)

-- Example 13876
stream_list = root.databases['my_db'].schemas['my_schema'].streams.iter(starts_with="my", show_limit=10)
for stream_obj in stream_list:
  print(stream_obj.name)

-- Example 13877
my_stream_res = root.streams["my_stream"]
my_stream_res.drop()

-- Example 13878
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13879
from datetime import timedelta
from snowflake.core.task import Task

my_task = Task(name="my_task", definition="<sql query>", schedule=timedelta(hours=1))
tasks = root.databases['my_db'].schemas['my_schema'].tasks
tasks.create(my_task)

-- Example 13880
from snowflake.core.task import StoredProcedureCall, Task

my_task2 = Task(
  "my_task2",
  StoredProcedureCall(
      dosomething, stage_location="@mystage"
  ),
  warehouse="test_warehouse"
)
tasks = root.databases['my_db'].schemas['my_schema'].tasks
tasks.create(my_task2)

-- Example 13881
from datetime import timedelta
from snowflake.core.task import Task

my_task = root.databases['my_db'].schemas['my_schema'].tasks['my_task'].fetch()
my_task.definition = "<sql query 2>"
my_task.schedule = timedelta(hours=2)

my_task_res = root.databases['my_db'].schemas['my_schema'].tasks['my_task']
my_task_res.create_or_alter(my_task)

-- Example 13882
from snowflake.core.task import TaskCollection

tasks: TaskCollection = root.databases['my_db'].schemas['my_schema'].tasks
task_iter = tasks.iter(like="my%")  # returns a PagedIter[Task]
for task_obj in task_iter:
  print(task_obj.name)

-- Example 13883
tasks = root.databases['my_db'].schemas['my_schema'].tasks
task_res = tasks['my_task']

task_res.execute()
task_res.suspend()
task_res.resume()
task_res.drop()

-- Example 13884
from snowflake.core.task import StoredProcedureCall
from snowflake.core.task.dagv1 import DAG, DAGTask, DAGOperation
from snowflake.snowpark import Session
from snowflake.snowpark.functions import sum as sum_

def dosomething(session: Session) -> None:
  df = session.table("target")
  df.group_by("a").agg(sum_("b")).save_as_table("agg_table")

with DAG("my_dag", schedule=timedelta(days=1)) as dag:
  # Create a task that runs some SQL.
  dag_task1 = DAGTask(
    "dagtask1",
    "MERGE INTO target USING source_stream WHEN MATCHED THEN UPDATE SET target.v = source_stream.v"
  )
  # Create a task that runs a Python function.
  dag_task2 = DAGTask(
    StoredProcedureCall(
      dosomething, stage_location="@mystage",
      packages=["snowflake-snowpark-python"]
    ),
    warehouse="test_warehouse"
  )
# Shift right and left operators can specify task relationships.
dag_task1 >> dag_task2  # dag_task1 is a predecessor of dag_task2
schema = root.databases["my_db"].schemas["my_schema"]
dag_op = DAGOperation(schema)
dag_op.deploy(dag)

-- Example 13885
from snowflake.core._common import CreateMode
from snowflake.core.task import Cron
from snowflake.core.task.dagv1 import DAG, DAGTask, DAGOperation, DAGTaskBranch
from snowflake.snowpark import Session

def task_handler(session: Session) -> None:
  pass  # do something

def task_branch_handler(session: Session) -> str:
  # do something
  return "task3"

try:
  with DAG(
    "my_dag",
    schedule=Cron("10 * * * *", "America/Los_Angeles"),
    stage_location="@mystage",
    packages=["snowflake-snowpark-python"],
    use_func_return_value=True,
  ) as dag:
    task1 = DAGTask(
      "task1",
      task_handler,
      warehouse=test_warehouse,
    )
    task1_branch = DAGTaskBranch("task1_branch", task_branch_handler, warehouse=test_warehouse)
    task2 = DAGTask("task2", task_handler, warehouse=test_warehouse)
    task3 = DAGTask("task3", task_handler, warehouse=test_warehouse, condition="1=1")
    task1 >> task1_branch
    task1_branch >> [task2, task3]
  schema = root.databases["my_db"].schemas["my_schema"]
  op = DAGOperation(schema)
  op.deploy(dag, mode=CreateMode.or_replace)
finally:
  session.close()

-- Example 13886
from snowflake.core.task.context import TaskContext
from snowflake.snowpark import Session

def task_handler(session: Session) -> None:
  context = TaskContext(session)
  # this return value can be retrieved by successor Tasks.
  context.set_return_value("predecessor_return_value")

-- Example 13887
from snowflake.core.task.context import TaskContext
from snowflake.snowpark import Session

def task_handler(session: Session) -> None:
  context = TaskContext(session)
  pred_return_value = context.get_predecessor_return_value("pred_task_name")

-- Example 13888
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13889
from snowflake.core.user import User

my_user = User(name="my_user")
root.users.create(my_user)

-- Example 13890
my_user = root.users["my_user"].fetch()
print(my_user.to_dict())

-- Example 13891
user_parameters = root.users["my_user"].fetch()
user_parameters.first_name="Snowy"
user_parameters.last_name="User"
user_parameters.must_change_password=False
root.users["my_user"].create_or_alter(user_parameters)

-- Example 13892
users = root.users.iter(like="my%")
for user in users:
  print(user.name)

-- Example 13893
my_user_res = root.users["my_user"]
my_user_res.drop()

-- Example 13894
from snowflake.core.role import Role

my_role = Role(name="my_role")
root.roles.create(my_role)

-- Example 13895
root.session.use_role("my_role")

-- Example 13896
role_list = root.roles.iter()
for role_obj in role_list:
  print(role_obj.name)

-- Example 13897
my_role_res = root.roles["my_role"]
my_role_res.drop()

-- Example 13898
from snowflake.core.database_role import DatabaseRole

my_db_role = DatabaseRole(
  name="my_db_role",
  comment="sample comment"
)

my_db_role_ref = root.databases['my_db'].database_roles.create(my_db_role)

-- Example 13899
database_role_ref = root.databases['my_db'].database_roles['dr1'].clone(target_database_role='dr2', target_database='my_db_2')

-- Example 13900
db_role_list = root.databases['my_db'].database_roles.iter(limit=1, from_name='my_db_role')
for db_role_obj in db_role_list:
  print(db_role_obj.name)

-- Example 13901
root.databases['my_db'].database_roles['my_db_role'].drop()

-- Example 13902
from snowflake.core.role import Securable

root.roles['my_role'].grant_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 13903
from snowflake.core.role import Securable

root.roles['my_role'].grant_role(role_type="ROLE", role=Securable(name='my_role_1'))

-- Example 13904
from snowflake.core.role import ContainingScope

root.roles['my_role'].grant_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13905
from snowflake.core.role import ContainingScope

root.roles['my_role'].grant_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13906
from snowflake.core.role import Securable

root.roles['my_role'].revoke_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 13907
from snowflake.core.role import Securable

root.roles['my_role'].revoke_role(role_type="ROLE", role=Securable(name='my_role_1'))

-- Example 13908
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13909
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13910
from snowflake.core.role import Securable

 root.roles['my_role'].revoke_grant_option_for_privileges(
    privileges=["OPERATE"], securable_type="WAREHOUSE", securable=Securable(name='my_wh')
)

-- Example 13911
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_grant_option_for_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13912
from snowflake.core.role import ContainingScope

root.roles['my_role'].revoke_grant_option_for_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13913
root.roles['my_role'].iter_grants_to()

-- Example 13914
root.roles['my_role'].iter_grants_on()

-- Example 13915
root.roles['my_role'].iter_grants_of()

