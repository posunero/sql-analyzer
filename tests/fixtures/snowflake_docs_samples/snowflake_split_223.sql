-- Example 14921
+--------------+---------------+-------------------------+----------+-------------------------+--------------+
| STOCK_SYMBOL | COMPANY_NAME  | TRADE_TIME              | QUANTITY | QUOTE_TIME              |        PRICE |
|--------------+---------------+-------------------------+----------+-------------------------+--------------|
| AAPL         | Apple Inc     | 2023-10-01 09:00:05.000 |     2000 | 2023-10-01 09:00:03.000 | 139.00000000 |
| SNOW         | Snowflake Inc | 2023-09-30 12:02:55.000 |     3000 | NULL                    |         NULL |
| SNOW         | Snowflake Inc | 2023-10-01 09:00:05.000 |     1000 | 2023-10-01 09:00:02.000 | 163.00000000 |
| SNOW         | Snowflake Inc | 2023-10-01 09:00:10.000 |     1500 | 2023-10-01 09:00:08.000 | 165.00000000 |
+--------------+---------------+-------------------------+----------+-------------------------+--------------+

-- Example 14922
SELECT * FROM trades_unixtime;

-- Example 14923
+--------------+------------+----------+--------------+
| STOCK_SYMBOL | TRADE_TIME | QUANTITY |        PRICE |
|--------------+------------+----------+--------------|
| SNOW         | 1696150805 |      100 | 165.33300000 |
+--------------+------------+----------+--------------+

-- Example 14924
SELECT * FROM quotes_unixtime;

-- Example 14925
+--------------+------------+----------+--------------+--------------+
| STOCK_SYMBOL | QUOTE_TIME | QUANTITY |          BID |          ASK |
|--------------+------------+----------+--------------+--------------|
| SNOW         | 1696150802 |      100 | 166.00000000 | 165.00000000 |
+--------------+------------+----------+--------------+--------------+

-- Example 14926
SELECT *
  FROM trades_unixtime tu
    ASOF JOIN quotes_unixtime qu
    MATCH_CONDITION(tu.trade_time>=qu.quote_time);

-- Example 14927
+--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------+
| STOCK_SYMBOL | TRADE_TIME | QUANTITY |        PRICE | STOCK_SYMBOL | QUOTE_TIME | QUANTITY |          BID |          ASK |
|--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------|
| SNOW         | 1696150805 |      100 | 165.33300000 | SNOW         | 1696150802 |      100 | 166.00000000 | 165.00000000 |
+--------------+------------+----------+--------------+--------------+------------+----------+--------------+--------------+

-- Example 14928
CREATE OR REPLACE TABLE raintime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO raintime VALUES
  ('14:42:59.230', 'Ahwahnee', 'CA', 0.90),
  ('14:42:59.001', 'Oakhurst', 'CA', 0.50),
  ('14:42:44.435', 'Reno', 'NV', 0.00)
;

CREATE OR REPLACE TABLE preciptime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO preciptime VALUES
  ('14:42:59.230', 'Ahwahnee', 'CA', 0.91),
  ('14:42:59.001', 'Oakhurst', 'CA', 0.51),
  ('14:41:44.435', 'Las Vegas', 'NV', 0.01),
  ('14:42:44.435', 'Reno', 'NV', 0.01),
  ('14:40:34.000', 'Bozeman', 'MT', 1.11)
;

CREATE OR REPLACE TABLE snowtime(
  observed TIME(9),
  location VARCHAR(40),
  state VARCHAR(2),
  observation NUMBER(5,2)
);

INSERT INTO snowtime VALUES
  ('14:42:59.199', 'Fish Camp', 'CA', 3.20),
  ('14:42:44.435', 'Reno', 'NV', 3.00),
  ('14:43:01.000', 'Lake Tahoe', 'CA', 4.20),
  ('14:42:45.000', 'Bozeman', 'MT', 1.80)
;

-- Example 14929
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed>=s.observed)
  ORDER BY p.observed;

-- Example 14930
+----------+-----------+-------+-------------+----------+-----------+-------+-------------+
| OBSERVED | LOCATION  | STATE | OBSERVATION | OBSERVED | LOCATION  | STATE | OBSERVATION |
|----------+-----------+-------+-------------+----------+-----------+-------+-------------|
| 14:40:34 | Bozeman   | MT    |        1.11 | NULL     | NULL      | NULL  |        NULL |
| 14:41:44 | Las Vegas | NV    |        0.01 | NULL     | NULL      | NULL  |        NULL |
| 14:42:44 | Reno      | NV    |        0.01 | 14:42:44 | Reno      | NV    |        3.00 |
| 14:42:59 | Oakhurst  | CA    |        0.51 | 14:42:45 | Bozeman   | MT    |        1.80 |
| 14:42:59 | Ahwahnee  | CA    |        0.91 | 14:42:59 | Fish Camp | CA    |        3.20 |
+----------+-----------+-------+-------------+----------+-----------+-------+-------------+

-- Example 14931
ALTER SESSION SET TIME_OUTPUT_FORMAT = 'HH24:MI:SS.FF3';

-- Example 14932
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 14933
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed>=s.observed)
  ORDER BY p.observed;

-- Example 14934
+--------------+-----------+-------+-------------+--------------+-----------+-------+-------------+
| OBSERVED     | LOCATION  | STATE | OBSERVATION | OBSERVED     | LOCATION  | STATE | OBSERVATION |
|--------------+-----------+-------+-------------+--------------+-----------+-------+-------------|
| 14:40:34.000 | Bozeman   | MT    |        1.11 | NULL         | NULL      | NULL  |        NULL |
| 14:41:44.435 | Las Vegas | NV    |        0.01 | NULL         | NULL      | NULL  |        NULL |
| 14:42:44.435 | Reno      | NV    |        0.01 | 14:42:44.435 | Reno      | NV    |        3.00 |
| 14:42:59.001 | Oakhurst  | CA    |        0.51 | 14:42:45.000 | Bozeman   | MT    |        1.80 |
| 14:42:59.230 | Ahwahnee  | CA    |        0.91 | 14:42:59.199 | Fish Camp | CA    |        3.20 |
+--------------+-----------+-------+-------------+--------------+-----------+-------+-------------+

-- Example 14935
ALTER SESSION SET TIME_OUTPUT_FORMAT = 'HH24:MI:SS.FF3';

SELECT *
  FROM snowtime s
    ASOF JOIN raintime r
      MATCH_CONDITION(s.observed>=r.observed)
      ON s.state=r.state
    ASOF JOIN preciptime p
      MATCH_CONDITION(s.observed>=p.observed)
      ON s.state=p.state
  ORDER BY s.observed;

-- Example 14936
+--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------+
| OBSERVED     | LOCATION   | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION |
|--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------|
| 14:42:44.435 | Reno       | NV    |        3.00 | 14:42:44.435 | Reno     | NV    |        0.00 | 14:42:44.435 | Reno     | NV    |        0.01 |
| 14:42:45.000 | Bozeman    | MT    |        1.80 | NULL         | NULL     | NULL  |        NULL | 14:40:34.000 | Bozeman  | MT    |        1.11 |
| 14:42:59.199 | Fish Camp  | CA    |        3.20 | 14:42:59.001 | Oakhurst | CA    |        0.50 | 14:42:59.001 | Oakhurst | CA    |        0.51 |
| 14:43:01.000 | Lake Tahoe | CA    |        4.20 | 14:42:59.230 | Ahwahnee | CA    |        0.90 | 14:42:59.230 | Ahwahnee | CA    |        0.91 |
+--------------+------------+-------+-------------+--------------+----------+-------+-------------+--------------+----------+-------+-------------+

-- Example 14937
SELECT *
  FROM snowtime s
    ASOF JOIN raintime r
      MATCH_CONDITION(s.observed>r.observed)
      ON s.state=r.state
    ASOF JOIN preciptime p
      MATCH_CONDITION(s.observed<p.observed)
      ON s.state=p.state
  ORDER BY s.observed;

-- Example 14938
+--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------+
| OBSERVED     | LOCATION   | STATE | OBSERVATION | OBSERVED     | LOCATION  | STATE | OBSERVATION | OBSERVED     | LOCATION | STATE | OBSERVATION |
|--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------|
| 14:42:44.435 | Reno       | NV    |        3.00 | 14:41:44.435 | Las Vegas | NV    |        0.00 | NULL         | NULL     | NULL  |        NULL |
| 14:42:45.000 | Bozeman    | MT    |        1.80 | NULL         | NULL      | NULL  |        NULL | NULL         | NULL     | NULL  |        NULL |
| 14:42:59.199 | Fish Camp  | CA    |        3.20 | 14:42:59.001 | Oakhurst  | CA    |        0.50 | 14:42:59.230 | Ahwahnee | CA    |        0.91 |
| 14:43:01.000 | Lake Tahoe | CA    |        4.20 | 14:42:59.230 | Ahwahnee  | CA    |        0.90 | NULL         | NULL     | NULL  |        NULL |
+--------------+------------+-------+-------------+--------------+-----------+-------+-------------+--------------+----------+-------+-------------+

-- Example 14939
SELECT * FROM snowtime s ASOF JOIN preciptime p MATCH_CONDITION(p.observed>=s.observed);

-- Example 14940
010002 (42601): SQL compilation error:
MATCH_CONDITION clause is invalid: The left side allows only column references from the left side table, and the right side allows only column references from the right side table.

-- Example 14941
SELECT * FROM preciptime p ASOF JOIN snowtime s MATCH_CONDITION(p.observed=s.observed);

-- Example 14942
010001 (42601): SQL compilation error:
MATCH_CONDITION clause is invalid: Only comparison operators '>=', '>', '<=' and '<' are allowed. Keywords such as AND and OR are not allowed.

-- Example 14943
SELECT *
  FROM preciptime p ASOF JOIN snowtime s
  MATCH_CONDITION(p.observed>=s.observed)
  ON s.state>=p.state;

-- Example 14944
010010 (42601): SQL compilation error:
ON clause for ASOF JOIN must contain conjunctions of equality conditions only. Disjunctions are not allowed. Each side of an equality condition must only refer to either the left table or the right table. S.STATE >= P.STATE is invalid.

-- Example 14945
SELECT *
  FROM preciptime p ASOF JOIN snowtime s
  MATCH_CONDITION(p.observed>=s.observed)
  ON s.state=p.state OR s.location=p.location;

-- Example 14946
010010 (42601): SQL compilation error:
ON clause for ASOF JOIN must contain conjunctions of equality conditions only. Disjunctions are not allowed. Each side of an equality condition must only refer to either the left table or the right table. (S.STATE = P.STATE) OR (S.LOCATION = P.LOCATION) is invalid.

-- Example 14947
SELECT t1.a "t1a", t2.a "t2a"
  FROM t1 ASOF JOIN
    LATERAL(SELECT a FROM t2 WHERE t1.b = t2.b) t2
    MATCH_CONDITION(t1.a >= t2.a)
  ORDER BY 1,2;

-- Example 14948
010004 (42601): SQL compilation error:
ASOF JOIN is not supported for joins with LATERAL table functions or LATERAL views.

-- Example 14949
CREATE [ OR REPLACE ] [ IF NOT EXISTS ] DATASET <name>

-- Example 14950
CREATE DATASET my_dataset;

-- Example 14951
CREATE OR REPLACE DATASET my_dataset;

-- Example 14952
SHOW DATASETS
  [ LIKE '<pattern>' ]
  [ IN { SCHEMA <schema_name> | DATABASE <db_name> | ACCOUNT } ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 14953
SHOW DATASETS IN SCHEMA PUBLIC LIMIT 2;

-- Example 14954
SHOW VERSIONS [ LIKE '<pattern>' ] IN DATASET <dataset_name>
  [ LIMIT <rows>]

-- Example 14955
conda create --name py39_env --override-channels -c https://repo.anaconda.com/pkgs/snowflake python=3.9 numpy pandas pyarrow

-- Example 14956
CONDA_SUBDIR=osx-64 conda create -n snowpark python=3.9 numpy pandas pyarrow --override-channels -c https://repo.anaconda.com/pkgs/snowflake
conda activate snowpark
conda config --env --set subdir osx-64

-- Example 14957
conda install snowflake-snowpark-python

-- Example 14958
pip install snowflake-snowpark-python

-- Example 14959
conda install snowflake-snowpark-python pandas pyarrow

-- Example 14960
pip install "snowflake-snowpark-python[pandas]"

-- Example 14961
pip install notebook

-- Example 14962
jupyter notebook

-- Example 14963
>>> from snowflake.snowpark.functions import avg

-- Example 14964
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

-- Example 14965
>>> new_pool_def = ComputePool(
...     name="MYCOMPUTEPOOL",
...     instance_family="STANDARD_1",
...     min_nodes=1,
...     max_nodes=1,
... )
>>> new_pool = root.compute_pools.create(new_pool_def)
>>> cp_snapshot = new_pool.fetch()
>>> cp_data = root.compute_pools.iter(like=”%COMPUTEPOOL”)
>>> new_pool.resume()
>>> new_pool.stop_all_services()
>>> new_pool.suspend()
>>> new_pool.delete()
>>> an_existing_pool = root.compute_pools["existing_compute_pool"]
>>> an_existing_pool.suspend()

-- Example 14966
>>> database_role_name = "test_database_role"
>>> database_role = DatabaseRole(name=database_role_name, comment="test_comment")
>>> created_database_role = database_roles.create(database_role)
>>> database_roles[database_role_name].drop()

-- Example 14967
>>> new_external_volume_def = ExternalVolume(
...     name="MY_EXTERNAL_VOLUME",
...     storage_location=StorageLocationS3(
...         name="abcd-my-s3-us-west-2",
...         storage_base_url="s3://MY_EXAMPLE_BUCKET/",
...         storage_aws_role_arn="arn:aws:iam::123456789022:role/myrole",
...         encryption=Encryption(type="AWS_SSE_KMS",
...                                kms_key_id="1234abcd-12ab-34cd-56ef-1234567890ab")
...     ),
...     comment="This is my external volume",
... )
>>> new_external_volume = root.external_volumes.create(new_external_volume_def)
>>> external_volume_snapshot = new_external_volume.fetch()
>>> external_volume_data = root.external_volumes.iter(like=”%MY_EXTERNAL_VOLUME)
>>> new_external_volume.drop()

-- Example 14968
>>> root.grants.grant(Grant(
>>>        grantee=Grantees.role(name=role_name),
>>>        securable=Securables.current_account,
>>>        privileges=[Privileges.create_database]))

-- Example 14969
>>> new_image_repository = ImageRepository(
...     name="my_imagerepo",
... )
>>> image_repositories = root.databases["MYDB"].schemas["MYSCHEMA"].image_repositories
>>> my_image_repo = image_repositories.create(new_image_repository)
>>> my_image_repo_snapshot = my_image_repo.fetch()
>>> ir_data = image_repositories.iter(like="%my")
>>> an_existing_repo = image_repositories["an_existing_repo"]
>>> an_existing_repo.delete()

-- Example 14970
>>> managed_account_collection = root.managed_accounts
>>> managed_account = ManagedAccount(
...     name="managed_account_name",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     account_type = "READER"
...  )
>>> managed_account_collection.create(managed_account)

-- Example 14971
>>> notebooks: NotebookCollection = root.databases["my_db"].schemas["my_schema"].notebooks
>>> my_notebook = notebooks.create(Notebook("my_notebook"))
>>> notebook_iter = notebooks.iter(like="my%")
>>> notebook = notebooks["my_notebook"]
>>> an_existing_notebook = notebooks["an_existing_notebook"]

-- Example 14972
>>> pipes: PipeCollection = root.databases["mydb"].schemas["myschema"].pipes
>>> mypipe = pipes.create(Pipe("mypipe"))
>>> pipe_iter = pipes.iter(like="my%")
>>> pipe = pipes["mypipe"]
>>> an_existing_pipe = pipes["an_existing_pipe"]

-- Example 14973
>>> role_name = "test_role"
>>> test_role = Role(name=role_name, comment="test_comment")
>>> created_role = roles.create(test_role)
>>> roles[role_name].delete()

-- Example 14974
>>> new_service_def  = Service(
...     name="MYSERVICE",
...     compute_pool="MYCOMPUTEPOOL",
...     spec="@~/myservice_spec.yml",
...     min_instances=1,
...     max_instances=1,
... )
>>> services = root.databases["MYDB"].schemas["MYSCHEMA"].services
>>> myservice = services.create(new_service_def)
>>> myservice_snapshot = myservice.fetch()
>>> service_data = services.iter(like="%SERVICE")
>>> myservice.suspend()
>>> myservice.resume()
>>> service_status = myservice.get_service_status()
>>> logs = myservice.get_service_logs()
>>> myservice.delete()
>>> an_existing_service = services["an_existing_service"]
>>> an_existing_service.suspend()

-- Example 14975
>>> stages: StageCollection = root.databases["mydb"].schemas["myschema"].stages
>>> mystage = stages.create(Stage("mystage"))
>>> stage_iter = stages.iter(like="my%")
>>> mystage = stages["mystage"]
>>> an_existing_stage = stages["an_existing_stage"]

-- Example 14976
>>> tasks: TaskCollection = root.databases["mydb"].schemas["myschema"].tasks
>>> mytask = tasks.create(Task("mytask", definition="select 1"))
>>> task_iter = tasks.iter(like="my%")
>>> mytask = tasks["mytask"]
>>> # Then call other APIs to manage this task.
>>> mytask.resume()
>>> mytask.suspend()
>>> an_existing_task = tasks["an_existing_task"]
>>> an_existing_task.suspend()

-- Example 14977
>>> from snowflake.snowpark.functions import sum as sum_
>>> from snowflake.core.task import StoredProcedureCall
>>> from snowflake.core.task.dagv1 import DAG, DAGTask, DAGOperation
>>> def dosomething(session: Session) -> None:
...     df = session.table("target")
...     df.group_by("a").agg(sum_("b")).save_as_table("agg_table")
>>> with DAG("my_dag", schedule=timedelta(days=1)) as dag:
...     # Create a task that runs some SQL.
...     dag_task1 = DAGTask(
...         "dagtask1",
...         "MERGE INTO target USING source_stream WHEN MATCHED THEN UPDATE SET target.v = source_stream.v")
...     # Create a task that runs a Python function.
...     dag_task2 = DAGTask(
...         StoredProcedureCall(
...             dosomething, stage_location="@mystage",
...             packages=["snowflake-snowpark-python"]
...         ),
...         warehouse="test_warehouse")
...     )
>>> # Shift right and left operators can specify task relationships.
>>> dag_task1 >> dag_task2
>>> schema = root.databases["MYDB"].schemas["MYSCHEMA"]
>>> dag_op = DAGOperation(schema)
>>> dag_op.deploy(dag)

-- Example 14978
>>> from snowflake.snowpark import Session
>>> from snowflake.core import Root
>>> from snowflake.core._common import CreateMode
>>> from snowflake.core.task import Cron
>>> from snowflake.core.task.dagv1 import DAG, DAGTask, DAGOperation, DAGTaskBranch
>>> session = Session.builder.create()
>>> test_stage = "mystage"
>>> test_dag = "mydag"
>>> test_db = "mydb"
>>> test_schema = "public"
>>> test_warehouse = "testwh_python"
>>> root = Root(session)
>>> schema = root.databases[test_db].schemas[test_schema]
>>> def task_handler1(session: Session) -> None:
...     pass  # do something
>>> def task_handler2(session: Session) -> None:
...     pass  # do something
>>> def task_handler3(session: Session) -> None:
...     pass  # do something
>>> def task_branch_handler(session: Session) -> str:
...     # do something
...     return "task3"
>>> try:
...     with DAG(
...         test_dag,
...         schedule=Cron("10 * * * *", "America/Los_Angeles"),
...         stage_location=test_stage,
...         packages=["snowflake-snowpark-python"],
...         warehouse=test_warehouse,
...         use_func_return_value=True,
...     ) as dag:
...         task1 = DAGTask(
...             "task1",
...             task_handler1,
...         )
...         task1_branch = DAGTaskBranch("task1_branch", task_branch_handler, warehouse=test_warehouse)
...         task2 = DAGTask("task2", task_handler2)
...         task1 >> task1_branch
...         task1_branch >> [task2, task_handler3]  # after >> you can use a DAGTask or a function.
...     op = DAGOperation(schema)
...     op.deploy(dag, mode=CreateMode.or_replace)
>>> finally:
...     session.close()

-- Example 14979
>>> user = User("test_user")
>>> created_user = root.users.create(user)
>>> root.users["test_user"].fetch()
>>> root.users["test_user"].delete()

-- Example 14980
>>> warehouse_name = "MYWAREHOUSE"

-- Example 14981
CREATE [ OR REPLACE ] TASK [ IF NOT EXISTS ] <name>
    [ WITH TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ { WAREHOUSE = <string> } | { USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> } ]
    [ SCHEDULE = { '<num> { HOURS | MINUTES | SECONDS }'
                 | 'USING CRON <expr> <time_zone>' } ]
    [ CONFIG = <configuration_string> ]
    [ ALLOW_OVERLAPPING_EXECUTION = TRUE | FALSE ]
    [ <session_parameter> = <value> [ , <session_parameter> = <value> ... ] ]
    [ USER_TASK_TIMEOUT_MS = <num> ]
    [ SUSPEND_TASK_AFTER_NUM_FAILURES = <num> ]
    [ ERROR_INTEGRATION = <integration_name> ]
    [ SUCCESS_INTEGRATION = <integration_name> ]
    [ LOG_LEVEL = '<log_level>' ]
    [ COMMENT = '<string_literal>' ]
    [ FINALIZE = <string> ]
    [ TASK_AUTO_RETRY_ATTEMPTS = <num> ]
    [ USER_TASK_MINIMUM_TRIGGER_INTERVAL_IN_SECONDS = <num> ]
    [ TARGET_COMPLETION_INTERVAL = '<num> { HOURS | MINUTES | SECONDS }' ]
    [ SERVERLESS_TASK_MIN_STATEMENT_SIZE = '{ XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ... }' ]
    [ SERVERLESS_TASK_MAX_STATEMENT_SIZE = '{ XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | ... }' ]
  [ AFTER <string> [ , <string> , ... ] ]
  [ WHEN <boolean_expr> ]
  AS
    <sql>

-- Example 14982
CREATE OR ALTER TASK <name>
    [ { WAREHOUSE = <string> } | { USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = <string> } ]
    [ SCHEDULE = '{ <num> { HOURS | MINUTES | SECONDS } | USING CRON <expr> <time_zone> }' ]
    [ CONFIG = <configuration_string> ]
    [ ALLOW_OVERLAPPING_EXECUTION = TRUE | FALSE ]
    [ USER_TASK_TIMEOUT_MS = <num> ]
    [ <session_parameter> = <value> [ , <session_parameter> = <value> ... ] ]
    [ SUSPEND_TASK_AFTER_NUM_FAILURES = <num> ]
    [ ERROR_INTEGRATION = <integration_name> ]
    [ SUCCESS_INTEGRATION = <integration_name> ]
    [ COMMENT = '<string_literal>' ]
    [ FINALIZE = <string> ]
    [ TASK_AUTO_RETRY_ATTEMPTS = <num> ]
  [ AFTER <string> [ , <string> , ... ] ]
  [ WHEN <boolean_expr> ]
  AS
    <sql>

-- Example 14983
CREATE [ OR REPLACE ] TASK <name> CLONE <source_task>
  [ ... ]

-- Example 14984
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 14985
WHEN NOT SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name')::BOOLEAN

-- Example 14986
WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name') != 'VALIDATION'

-- Example 14987
WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE('task_name')::FLOAT < 0.2

