-- Example 13916
root.roles['my_role'].iter_future_grants_to()

-- Example 13917
from snowflake.core.user import Securable

root.users['my_user'].grant_role(role_type="ROLE", role=Securable(name='my_role'))

-- Example 13918
from snowflake.core.user import Securable

root.users['my_user'].revoke_role(role_type="ROLE", role=Securable(name='my_role'))

-- Example 13919
root.users['my_user'].iter_grants_to()

-- Example 13920
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].grant_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 13921
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].grant_role(role_type="DATABASE ROLE", role=Securable(name='my_db_role_1'))

-- Example 13922
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].grant_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13923
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].grant_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13924
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 13925
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_role(role_type="DATABASE ROLE", role=Securable(name='my_db_role_1'))

-- Example 13926
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13927
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13928
from snowflake.core.database_role import Securable

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_privileges(
    privileges=["MODIFY"], securable_type="DATABASE", securable=Securable(name='my_db')
)

-- Example 13929
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_privileges_on_all(
    privileges=["SELECT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13930
from snowflake.core.database_role import ContainingScope

root.databases['my_db'].database_roles['my_db_role'].revoke_grant_option_for_future_privileges(
    privileges=["SELECT", "INSERT"],
    securable_type="TABLE",
    containing_scope=ContainingScope(database='my_db', schema='my_schema'),
)

-- Example 13931
root.databases['my_db'].database_roles['my_db_role'].iter_grants_to()

-- Example 13932
root.databases['my_db'].database_roles['my_db_role'].iter_future_grants_to()

-- Example 13933
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._privileges import Privileges
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role(name='my_role'),
    securable=Securables.current_account,
    privileges=[Privileges.create_database,
                Privileges.create_warehouse],
  )
)

-- Example 13934
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._privileges import Privileges
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role('my_role'),
    securable=Securables.database('my_db'),
    privileges=[Privileges.imported_privileges],
  )
)

-- Example 13935
from snowflake.core.grant import Grant
from snowflake.core.grant._grantee import Grantees
from snowflake.core.grant._securables import Securables

root.grants.grant(
  Grant(
    grantee=Grantees.role('ACCOUNTADMIN'),
    securable=Securables.role('my_role'),
  )
)

-- Example 13936
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13937
from snowflake.core.warehouse import Warehouse

my_wh = Warehouse(
  name="my_wh",
  warehouse_size="SMALL",
  auto_suspend=600,
)
warehouses = root.warehouses
warehouses.create(my_wh)

-- Example 13938
my_wh = root.warehouses["my_wh"].fetch()
print(my_wh.to_dict())

-- Example 13939
from snowflake.core.warehouse import Warehouse

my_wh = root.warehouses["my_wh"].fetch()
my_wh.warehouse_size = "LARGE"
my_wh.auto_suspend = 1800

my_wh_res = root.warehouses["my_wh"]
my_wh_res.create_or_alter(my_wh)

-- Example 13940
from snowflake.core.warehouse import WarehouseCollection

warehouses: WarehouseCollection = root.warehouses
wh_iter = warehouses.iter(like="my%")  # returns a PagedIter[Warehouse]
for wh_obj in wh_iter:
  print(wh_obj.name)

-- Example 13941
my_wh_res = root.warehouses["my_wh"]

my_wh_res.suspend()
my_wh_res.resume()
my_wh_res.abort_all_queries()
my_wh_res.drop()

-- Example 13942
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13943
from snowflake.core.account import Account

my_account = Account(
  name="my_account1",
  admin_name="admin",
  admin_password="TestPassword1",
  first_name="Jane",
  last_name="Smith",
  email="myemail@myorg.org",
  edition="ENTERPRISE",
  region="aws_us_west_2",
  comment="creating my account",
)

root.accounts.create(my_account)

-- Example 13944
account_iter = root.accounts.iter(like="my%")  # returns a PagedIter[Account]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13945
account_iter = root.accounts.iter(history=True)  # returns a PagedIter[Account]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13946
my_account_res = root.accounts["my_account1"]
my_account_res.drop(grace_period_in_days=4)
my_account_res.undrop()

-- Example 13947
from snowflake.core.managed_account import ManagedAccount

my_managed_account = ManagedAccount(
  name="reader_acct1",
  admin_name="admin",
  admin_password="TestPassword1",
  type="READER",
  comment="creating my managed account",
)

root.managed_accounts.create(my_managed_account)

-- Example 13948
account_iter = root.managed_accounts.iter(like="reader%")  # returns a PagedIter[ManagedAccount]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13949
my_managed_account_res = root.managed_accounts["reader_acct1"]
my_managed_account_res.drop()

-- Example 13950
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13951
from snowflake.core.stage import Stage, StageEncryption

my_stage = Stage(
  name="my_stage",
  encryption=StageEncryption(type="SNOWFLAKE_SSE")
)
stages = root.databases["my_db"].schemas["my_schema"].stages
stages.create(my_stage)

-- Example 13952
my_stage = root.databases["my_db"].schemas["my_schema"].stages["my_stage"].fetch()
print(my_stage.to_dict())

-- Example 13953
from snowflake.core.stage import StageCollection

stages: StageCollection = root.databases["my_db"].schemas["my_schema"].stages
stage_iter = stages.iter(like="my%")  # returns a PagedIter[Stage]
for stage_obj in stage_iter:
  print(stage_obj.name)

-- Example 13954
my_stage_res = root.databases["my_db"].schemas["my_schema"].stages["my_stage"]

my_stage_res.put("./my-file.yaml", "/", auto_compress=False, overwrite=True)

stageFiles = root.databases["my_db"].schemas["my_schema"].stages["my_stage"].list_files()
for stageFile in stageFiles:
  print(stageFile)

my_stage_res.drop()

-- Example 13955
from snowflake.core.pipe import Pipe

my_pipe = Pipe(
  name="my_pipe",
  comment="creating my pipe",
  copy_statement="COPY INTO my_table FROM @mystage FILE_FORMAT = (TYPE = 'JSON')",
)

pipes = root.databases["my_db"].schemas["my_schema"].pipes
pipes.create(my_pipe)

-- Example 13956
my_pipe = root.databases["my_db"].schemas["my_schema"].pipes["my_pipe"].fetch()
print(my_pipe.to_dict())

-- Example 13957
from snowflake.core.pipe import PipeCollection

pipes: PipeCollection = root.databases["my_db"].schemas["my_schema"].pipes
pipe_iter = pipes.iter(like="my%")  # returns a PagedIter[Pipe]
for pipe_obj in pipe_iter:
  print(pipe_obj.name)

-- Example 13958
my_pipe_res = root.databases["my_db"].schemas["my_schema"].pipes["my_pipe"]

# equivalent to: ALTER PIPE my_pipe REFRESH PREFIX = 'dir3/'
my_pipe_res.refresh(prefix="dir3/")

my_pipe_res.drop()

-- Example 13959
from snowflake.core.external_volume import (
    ExternalVolume,
    StorageLocationS3,
)

my_external_volume = ExternalVolume(
    name="my_external_volume",
    storage_locations=[
        StorageLocationS3(
            name="my-s3-us-west-1",
            storage_base_url="s3://MY_EXAMPLE_BUCKET/",
            storage_aws_role_arn="arn:aws:iam::123456789012:role/myrole",
            encryption=Encryption(type="AWS_SSE_KMS", kms_key_id="1234abcd-12ab-34cd-56ef-1234567890ab"),
        ),
        StorageLocationS3(
            name="my-s3-us-west-2",
            storage_base_url="s3://MY_EXAMPLE_BUCKET/",
            storage_aws_role_arn="arn:aws:iam::123456789012:role/myrole",
            encryption=Encryption(type="AWS_SSE_KMS", kms_key_id="1234abcd-12ab-34cd-56ef-1234567890ab"),
        ),
    ]
)

root.external_volumes.create(my_external_volume)

-- Example 13960
my_external_volume = root.external_volumes["my_external_volume"].fetch()
print(my_external_volume.to_dict())

-- Example 13961
external_volume_iter = root.external_volumes.iter(like="my%")
for external_volume_obj in external_volume_iter:
  print(external_volume_obj.name)

-- Example 13962
my_external_volume_res = root.external_volumes["my_external_volume"]
my_external_volume_res.drop()
my_external_volume_res.undrop()

-- Example 13963
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13964
from snowflake.core.database import Database

my_db = Database(name="my_db")
root.databases.create(my_db)

-- Example 13965
my_db = root.databases["my_db"].fetch()
print(my_db.to_dict())

-- Example 13966
databases = root.databases.iter(like="my%")
for database in databases:
  print(database.name)

-- Example 13967
my_db_res = root.databases["my_db"]
my_db_res.drop()
my_db_res.undrop()

-- Example 13968
from snowflake.core.schema import Schema

my_schema = Schema(name="my_schema")
root.databases["my_db"].schemas.create(my_schema)

-- Example 13969
my_schema = root.databases["my_db"].schemas["my_schema"].fetch()
print(my_schema.to_dict())

-- Example 13970
schema_list = root.databases["my_db"].schemas.iter()
for schema_obj in schema_list:
  print(schema_obj.name)

-- Example 13971
my_schema_res = root.databases["my_db"].schemas["my_schema"]
my_schema_res.drop()
my_schema_res.undrop()

-- Example 13972
from snowflake.core.table import Table, TableColumn

my_table = Table(
  name="my_table",
  columns=[TableColumn(name="c1", datatype="int", nullable=False),
           TableColumn(name="c2", datatype="string")]
)
root.databases["my_db"].schemas["my_schema"].tables.create(my_table)

-- Example 13973
my_table = root.databases["my_db"].schemas["my_schema"].tables["my_table"].fetch()
print(my_table.to_dict())

-- Example 13974
from snowflake.core.table import PrimaryKey, TableColumn

my_table = root.databases["my_db"].schemas["my_schema"].tables["my_table"].fetch()
my_table.columns.append(TableColumn(name="c3", datatype="int", nullable=False, constraints=[PrimaryKey()]))

my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.create_or_alter(my_table)

-- Example 13975
tables = root.databases["my_db"].schemas["my_schema"].tables.iter(like="my%")
for table_obj in tables:
  print(table_obj.name)

-- Example 13976
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.swap_with("other_table")

-- Example 13977
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]
my_table_res.swap_with(to_swap_table_name="other_table", target_database="other_db", target_schema="other_schema")

-- Example 13978
my_table_res = root.databases["my_db"].schemas["my_schema"].tables["my_table"]

my_table_res.suspend_recluster()
my_table_res.resume_recluster()
my_table_res.drop()
my_table_res.undrop()

-- Example 13979
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

-- Example 13980
my_event_table = root.databases["my_db"].schemas["my_schema"].event_tables["my_event_table"].fetch()
print(my_event_table.to_dict())

-- Example 13981
from snowflake.core.event_table import EventTableCollection

event_tables: EventTableCollection = root.databases["my_db"].schemas["my_schema"].event_tables
event_table_iter = event_tables.iter(like="my%")  # returns a PagedIter[EventTable]
for event_table_obj in event_table_iter:
  print(event_table_obj.name)

-- Example 13982
event_tables: EventTableCollection = root.databases["my_db"].schemas["my_schema"].event_tables
event_table_iter = event_tables.iter(starts_with="my", show_limit=10)
for event_table_obj in event_table_iter:
  print(event_table_obj.name)

