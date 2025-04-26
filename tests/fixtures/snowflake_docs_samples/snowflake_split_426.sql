-- Example 28517
>>> tables = my_schema.tables.iter(like="my-table-name")

-- Example 28518
>>> tables = my_schema.tables.iter(like="my-table-name-%")

-- Example 28519
>>> for table in table:
>>>     print(table.name, table.kind)

-- Example 28520
>>> cron1 = Cron("0 0 10-20 * TUE,THU", "America/Los_Angeles")

-- Example 28521
>>> task_collection = root.databases["mydb"].schemas["myschema"].tasks
>>> task = Task(
...     name="mytask",
...     definition="select 1"
... )
>>> task_collection.create(task)

-- Example 28522
>>> task_parameters = Task(
...     name="mytask",
...     definition="select 1"
... )
>>> # Use the task collection created before to create a reference to the task resource
>>> # in Snowflake.
>>> task_reference = task_collection.create(task_parameters)

-- Example 28523
>>> tasks = task_collection.iter()

-- Example 28524
>>> tasks = task_collection.iter(like="your-task-name")

-- Example 28525
>>> tasks = task_collection.iter(like="your-task-name-%")

-- Example 28526
>>> for task in tasks:
...     print(task.name, task.comment)

-- Example 28527
>>> task_parameters = Task(
...     name="your-task-name",
...     definition="select 1"
... )

-- Example 28528
>>> root.warehouses["your-task-name"].create_or_alter(task_parameters)

-- Example 28529
>>> task_reference.drop()

-- Example 28530
>>> task_reference.execute()

-- Example 28531
>>> task = task_reference.fetch()

-- Example 28532
>>> print(task.name, task.comment)

-- Example 28533
>>> child_tasks = task_reference.fetch_task_dependents()

-- Example 28534
>>> completed_graphs = task_reference.get_complete_graphs()

-- Example 28535
>>> current_graphs = task_reference.get_current_graphs()

-- Example 28536
>>> task_reference.resume()

-- Example 28537
>>> task_reference.suspend()

-- Example 28538
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     task_name = context.get_current_task_name()

-- Example 28539
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     pred_return_value = context.get_predecessor_return_value("pred_task_name")

-- Example 28540
>>> def task_handler(session: Session) -> None:
>>>     from snowflake.core.task.context import TaskContext
>>>     context = TaskContext(session)
>>>     # this return value can be retrieved by successor Tasks.
>>>     context.set_return_value("predecessor_return_value")

-- Example 28541
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

-- Example 28542
>>> child_task = DagTask(
...     "child_task",
...     "select 'child_task'",
...     warehouse="test_warehouse"
... )
>>> dag.add_task(child_task)
)

-- Example 28543
>>> finalizer_task = dag.get_finalizer_task()

-- Example 28544
>>> task = dag.get_task("child_task")

-- Example 28545
>>> task1 = DAGTask("task1", "select 'task1'")
>>> task2 = DAGTask("task2", "select 'task2'")
>>> task1.add_predecessors(task2)

-- Example 28546
>>> task1 = DAGTask("task1", "select 'task1'")
>>> task2 = DAGTask("task2", "select 'task2'")
>>> task1.add_successors(task2)

-- Example 28547
>>> dag_op.drop("your-dag-name")

-- Example 28548
>>> dag_op.get_complete_dag_runs("your-dag-name")

-- Example 28549
>>> dag_op.get_current_dag_runs("your-dag-name")

-- Example 28550
>>> dags = dag_op.iter_dags(like="your-dag-name")

-- Example 28551
>>> dag_op.run("your-dag-name")

-- Example 28552
>>> sample_user = User(name="test_user")
>>> root.users.create(sample_user)

-- Example 28553
>>> sample_user = User(name = "test_user")
>>> root.users.create(sample_user, mode = CreateMode.or_replace)

-- Example 28554
>>> user_parameters = User(
...     name="User1",
...     first_name="Snowy",
...     last_name="User",
...     must_change_password=False
...)
>>> user_reference.create_or_alter(user_parameters)

-- Example 28555
>>> user_ref.drop()

-- Example 28556
>>> user_ref.drop(if_exists=True)

-- Example 28557
>>> user_ref = root.users["test_user"].fetch()
>>> print(user_ref.name, user_ref.first_name)

-- Example 28558
>>> user_reference.grant_role("role", Securable(name="test_role"))

-- Example 28559
>>> user_reference.iter_grants_to()

-- Example 28560
>>> user_reference.revoke_role("role", Securable(name="test_role"))

-- Example 28561
>>> user_defined_function_reference.drop()

-- Example 28562
>>> user_defined_function_reference.drop(if_exists = True)

-- Example 28563
>>> print(user_defined_function_reference.fetch().created_on)

-- Example 28564
>>> user_defined_function_reference.rename("my_other_user_defined_function")

-- Example 28565
>>> user_defined_function_reference.rename("my_other_user_defined_function", if_exists = True)

-- Example 28566
>>> user_defined_function_reference.rename(
...     "my_other_user_defined_function",
...     target_schema = "my_other_schema",
...     if_exists = True
... )

-- Example 28567
>>> user_defined_function_reference.rename(
...     "my_other_user_defined_function",
...     target_database = "my_other_database",
...     target_schema = "my_other_schema",
...     if_exists = True
... )

-- Example 28568
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

-- Example 28569
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

-- Example 28570
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

-- Example 28571
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

-- Example 28572
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

-- Example 28573
>>> function_body = '''
...     SELECT 1, 2
...     UNION ALL
...     SELECT 3, 4
... '''
>>> user_defined_function_created = user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_sql_function",
...         arguments=[],
...         return_type=ReturnTable(
...             column_list=[ColumnType(name="x", datatype="INTEGER"), ColumnType(name="y", datatype="INTEGER")]
...         ),
...         language_config=SQLFunction(),
...         body=function_body,
...     )
... )

-- Example 28574
>>> user_defined_functions = user_defined_function_collection.iter()

-- Example 28575
>>> user_defined_functions = user_defined_function_collection.iter(like="your-user-defined-function-name")

-- Example 28576
>>> user_defined_functions = user_defined_function_collection.iter(like="your-user-defined-function-name-%")

-- Example 28577
>>> for user_defined_function in user_defined_functions:
...     print(user_defined_function.name)

-- Example 28578
>>> view_reference.drop()

-- Example 28579
>>> view_reference.drop(if_exists = True)

-- Example 28580
>>> my_view = view_reference.fetch()
>>> print(my_view.name, my_view.query)

-- Example 28581
>>> views = root.databases["my_db"].schemas["my_schema"].views
>>> new_view = View(
...     name="my_view",
...     columns=[
...        ViewColumn(name="col1"), ViewColumn(name="col2"), ViewColumn(name="col3"),
...     ],
...     query="SELECT * FROM my_table",
...    )
>>> views.create(new_view)

-- Example 28582
>>> views = root.databases["my_db"].schemas["my_schema"].views
>>> new_view = View(
...     name="my_view",
...     columns=[
...        ViewColumn(name="col1"), ViewColumn(name="col2"), ViewColumn(name="col3"),
...     ],
...     query="SELECT * FROM my_table",
...    )
>>> views.create(new_view, mode=CreateMode.or_replace)

-- Example 28583
>>> views = view_collection.iter()

