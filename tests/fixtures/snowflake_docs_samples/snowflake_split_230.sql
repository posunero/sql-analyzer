-- Example 15390
>>> table_ref = my_schema.tables["my_table"].fetch()
>>> print(table_ref.comment)

-- Example 15391
>>> my_schema.tables["my_table"].resume_recluster()

-- Example 15392
>>> my_schema.tables["my_table"].suspend_recluster()

-- Example 15393
>>> my_table = my_schema.tables["my_table"].swap("other_table")

-- Example 15394
>>> table_ref.delete()
>>> table_ref.undelete()
The `undelete` method is deprecated; use `undrop` instead.

-- Example 15395
>>> table_ref.drop()
>>> table_ref.undrop()

-- Example 15396
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> new_table = Table(
...     name="accounts",
...     columns=[
...         TableColumn(
...             name="id",
...             datatype="int",
...             nullable=False,
...             autoincrement=True,
...             autoincrement_start=0,
...             autoincrement_increment=1,
...         ),
...         TableColumn(name="created_on", datatype="timestamp_tz", nullable=False),
...         TableColumn(name="email", datatype="string", nullable=False),
...         TableColumn(name="password_hash", datatype="string", nullable=False),
...     ],
... )
>>> tables.create(new_tables)

-- Example 15397
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> new_table = Table(
...     name="events",
...     columns=[
...         TableColumn(
...             name="id",
...             datatype="int",
...             nullable=False,
...             autoincrement=True,
...             autoincrement_start=0,
...             autoincrement_increment=1,
...         ),
...         TableColumn(name="category", datatype="string"),
...         TableColumn(name="event", datatype="string"),
...     ],
...     comment="store events/logs in here",
... )
>>> tables.create(new_tables)

-- Example 15398
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> tables.create("new_table", clone_table="original_table_name")

-- Example 15399
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> tables.create("new_table", clone_table="database_name.schema_name.original_table_name")

-- Example 15400
>>> tables = my_schema.tables.iter()

-- Example 15401
>>> tables = my_schema.tables.iter(like="my-table-name")

-- Example 15402
>>> tables = my_schema.tables.iter(like="my-table-name-%")

-- Example 15403
>>> for table in table:
>>>     print(table.name, table.kind)

-- Example 15404
>>> cron1 = Cron("0 0 10-20 * TUE,THU", "America/Los_Angeles")

-- Example 15405
>>> task_collection = root.databases["mydb"].schemas["myschema"].tasks
>>> task = Task(
...     name="mytask",
...     definition="select 1"
... )
>>> task_collection.create(task)

-- Example 15406
>>> task_parameters = Task(
...     name="mytask",
...     definition="select 1"
... )
>>> # Use the task collection created before to create a reference to the task resource
>>> # in Snowflake.
>>> task_reference = task_collection.create(task_parameters)

-- Example 15407
>>> tasks = task_collection.iter()

-- Example 15408
>>> tasks = task_collection.iter(like="your-task-name")

-- Example 15409
>>> tasks = task_collection.iter(like="your-task-name-%")

-- Example 15410
>>> for task in tasks:
...     print(task.name, task.comment)

-- Example 15411
>>> task_parameters = Task(
...     name="your-task-name",
...     definition="select 1"
... )

-- Example 15412
>>> root.warehouses["your-task-name"].create_or_alter(task_parameters)

-- Example 15413
>>> task_reference.drop()

-- Example 15414
>>> task_reference.execute()

-- Example 15415
>>> task = task_reference.fetch()

-- Example 15416
>>> print(task.name, task.comment)

-- Example 15417
>>> child_tasks = task_reference.fetch_task_dependents()

-- Example 15418
>>> completed_graphs = task_reference.get_complete_graphs()

-- Example 15419
>>> current_graphs = task_reference.get_current_graphs()

-- Example 15420
>>> task_reference.resume()

-- Example 15421
>>> task_reference.suspend()

-- Example 15422
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     task_name = context.get_current_task_name()

-- Example 15423
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     pred_return_value = context.get_predecessor_return_value("pred_task_name")

-- Example 15424
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     # this return value can be retrieved by successor Tasks.
>>>     context.set_return_value("predecessor_return_value")

-- Example 15425
>>> dag = DAG("TEST_DAG",
...     schedule=timedelta(minutes=10),
...     use_func_return_value=True,
...     warehouse="TESTWH_DAG",
...     packages=["snowflake-snowpark-python"],
...     stage_location="@TESTDB_DAG.TESTSCHEMA_DAG.TEST_STAGE_DAG"
... )
>>> def task1(session: Session) -> None:
...     session.sql("select 'task1'").collect()
>>> def task2(session: Session) -> None:
...     session.sql("select 'task2'").collect()
>>> def cond(session: Session) -> str:
...     return 'TASK1'
>>> with dag:
...     task1 = DAGTask("TASK1", definition=task1, warehouse="TESTWH_DAG")
...     task2 = DAGTask("TASK2", definition=task2, warehouse="TESTWH_DAG")
...     condition = DAGTaskBranch("COND", definition=cond, warehouse="TESTWH_DAG")
...     condition >> [task1, task2]
>>> dag_op = DAGOperation(schema)
>>> dag_op.deploy(dag, mode="orReplace")
>>> dag_op.run(dag)
Note:
    When defining a task branch handler, simply return the task name you want to jump to. The task name is
    case-sensitive, and it has to match the name property in DAGTask. For exmaple, in above sample code, return
    'TASK1' instead of 'TEST_DAG$TASK1', 'task1' or 'Task1' will not be considered as a exact match.

-- Example 15426
>>> child_task = DagTask(
...     "child_task",
...     "select 'child_task'",
...     warehouse="test_warehouse"
... )
>>> dag.add_task(child_task)
)

-- Example 15427
>>> finalizer_task = dag.get_finalizer_task()

-- Example 15428
>>> task = dag.get_task("child_task")

-- Example 15429
>>> task1 = DAGTask("task1", "select 'task1'")
>>> task2 = DAGTask("task2", "select 'task2'")
>>> task1.add_predecessors(task2)

-- Example 15430
>>> task1 = DAGTask("task1", "select 'task1'")
>>> task2 = DAGTask("task2", "select 'task2'")
>>> task1.add_successors(task2)

-- Example 15431
>>> dag_op.drop("your-dag-name")

-- Example 15432
>>> dag_op.get_complete_dag_runs("your-dag-name")

-- Example 15433
>>> dag_op.get_current_dag_runs("your-dag-name")

-- Example 15434
>>> dags = dag_op.iter_dags(like="your-dag-name")

-- Example 15435
>>> dag_op.run("your-dag-name")

-- Example 15436
>>> sample_user = User(name="test_user")
>>> root.users.create(sample_user)

-- Example 15437
>>> sample_user = User(name = "test_user")
>>> root.users.create(sample_user, mode = CreateMode.or_replace)

-- Example 15438
>>> user_parameters = User(
...     name="User1",
...     first_name="Snowy",
...     last_name="User",
...     must_change_password=False
...)
>>> user_reference.create_or_alter(user_parameters)

-- Example 15439
>>> user_ref.drop()

-- Example 15440
>>> user_ref.drop(if_exists=True)

-- Example 15441
>>> user_ref = root.users["test_user"].fetch()
>>> print(user_ref.name, user_ref.first_name)

-- Example 15442
>>> user_reference.grant_role("role", Securable(name="test_role"))

-- Example 15443
>>> user_reference.iter_grants_to()

-- Example 15444
>>> user_reference.revoke_role("role", Securable(name="test_role"))

-- Example 15445
>>> user_defined_function_reference.drop()

-- Example 15446
>>> user_defined_function_reference.drop(if_exists = True)

-- Example 15447
>>> print(user_defined_function_reference.fetch().created_on)

-- Example 15448
>>> user_defined_function_reference.rename("my_other_user_defined_function")

-- Example 15449
>>> user_defined_function_reference.rename("my_other_user_defined_function", if_exists = True)

-- Example 15450
>>> user_defined_function_reference.rename(
...     "my_other_user_defined_function",
...     target_schema = "my_other_schema",
...     if_exists = True
... )

-- Example 15451
>>> user_defined_function_reference.rename(
...     "my_other_user_defined_function",
...     target_database = "my_other_database",
...     target_schema = "my_other_schema",
...     if_exists = True
... )

-- Example 15452
>>> user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_python_function",
...         arguments=[],
...         return_type=ReturnDataType(datatype="VARIANT"),
...         language_config=PythonFunction(runtime_version="3.9", packages=[], handler="udf"),
...         body='''
... def udf():
...     return {"key": "value"}
...             ''',
...     )
... )

-- Example 15453
>>> user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_python_function",
...         arguments=[],
...         return_type=ReturnDataType(datatype="VARIANT"),
...         language_config=PythonFunction(runtime_version="3.9", packages=[], handler="udf"),
...         body='''
... def udf():
...     return {"key": "value"}
...             ''',
...     )
... )

-- Example 15454
>>> function_body = '''
... class TestFunc {
...     public static String echoVarchar(String x) {
...         return x;
...     }
... }
... '''
>>> user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_java_function",
...         arguments=[Argument(name="x", datatype="STRING")],
...         return_type=ReturnDataType(datatype="VARCHAR", nullable=True),
...         language_config=JavaFunction(
...             handler="TestFunc.echoVarchar",
...             runtime_version="11",
...             target_path="@~/my_java.jar",
...             packages=[],
...             called_on_null_input=True,
...             is_volatile=True,
...         ),
...         body=function_body,
...         comment="test_comment",
...     )
... )

-- Example 15455
>>> function_body = '''
...     if (D <= 0) {
...         return 1;
...     } else {
...         var result = 1;
...         for (var i = 2; i <= D; i++) {
...             result = result * i;
...         }
...         return result;
...     }
... '''
>>> user_defined_function_created = user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_js_function",
...         arguments=[Argument(name="d", datatype="DOUBLE")],
...         return_type=ReturnDataType(datatype="DOUBLE"),
...         language_config=JavaScriptFunction(),
...         body=function_body,
...     )
... )

-- Example 15456
>>> function_body = '''
...     class Echo {
...         def echoVarchar(x : String): String = {
...             return x
...         }
...     }
... '''
>>> user_defined_function_created = user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_scala_function",
...         arguments=[Argument(name="x", datatype="VARCHAR")],
...         return_type=ReturnDataType(datatype="VARCHAR"),
...         language_config=ScalaFunction(
...             runtime_version="2.12", handler="Echo.echoVarchar", target_path="@~/my_scala.jar", packages=[]
...         ),
...         body=function_body,
...         comment="test_comment",
...     )
... )

