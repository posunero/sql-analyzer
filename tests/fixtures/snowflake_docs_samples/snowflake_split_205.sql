-- Example 13715
my_warehouses = root.warehouses # my_warehouses is a WarehouseCollection

-- Example 13716
my_wh_ref = my_warehouses.warehouses["my_wh"] # my_wh_ref is a WarehouseResource

-- Example 13717
my_wh = my_wh_ref.fetch() # my_wh is a Warehouse model object

-- Example 13718
my_wh.warehouse_size = "X-Small"

-- Example 13719
my_wh_ref.create_or_alter(my_wh) # Use the WarehouseResource to perform create_or_alter

-- Example 13720
# my_wh is fetched from an existing warehouse
my_warehouses = root.warehouses # my_warehouses is a WarehouseCollection
my_wh_ref = my_warehouses.warehouses["my_wh"] # my_wh_ref is a WarehouseResource
my_wh = my_wh_ref.fetch() # my_wh is a Warehouse model object
my_wh.warehouse_size = "X-Small"

my_wh_ref.create_or_alter(my_wh) # Use the WarehouseResource perform create_or_alter

-- Example 13721
conda create -n <env_name> python==3.10

-- Example 13722
conda activate <env_name>

-- Example 13723
cd <your Python project root folder>
python3 -m venv '.venv'

-- Example 13724
source '.venv/bin/activate'

-- Example 13725
pip install snowflake -U

-- Example 13726
pip install "snowflake[ml]" -U

-- Example 13727
%env _SNOWFLAKE_PRINT_VERBOSE_STACK_TRACE=false

-- Example 13728
import os

CONNECTION_PARAMETERS = {
    "account": os.environ["snowflake_account_demo"],
    "user": os.environ["snowflake_user_demo"],
    "password": os.environ["snowflake_password_demo"],
    "role": "test_role",
    "database": "test_database",
    "warehouse": "test_warehouse",
    "schema": "test_schema",
}

-- Example 13729
[myconnection]
account = "test-account"
user = "test_user"
password = "******"
role = "test_role"
warehouse = "test_warehouse"
database = "test_database"
schema = "test_schema"

-- Example 13730
pip install 'snowflake-snowpark-python>=1.5.0,<2.0.0'

-- Example 13731
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13732
from snowflake.connector import connect
from snowflake.core import Root

connection = connect(connection_name="myconnection")
root = Root(connection)

-- Example 13733
tasks = root.databases["mydb"].schemas["myschema"].tasks
mytask = tasks["mytask"]
mytask.resume()

-- Example 13734
pip install snowflake.demos

-- Example 13735
default_connection_name = '<connection_name>'

-- Example 13736
python3

-- Example 13737
from snowflake.demos import help, load_demo, teardown

-- Example 13738
load_demo('get-started-snowflake-ml')

-- Example 13739
demo = load_demo('get-started-snowflake-ml')

-- Example 13740
Connecting to Snowflake...✅
Using ACCOUNTADMIN role...✅
Creating Database SNOWFLAKE_DEMO_DB...✅
Creating Schema SNOWFLAKE_DEMO_SCHEMA...✅
Creating Warehouse SNOWFLAKE_DEMO_WH...✅
Creating Stage SNOWFLAKE_DEMO_STAGE...✅
Uploading files to stage SNOWFLAKE_DEMO_STAGE/get-started-snowflake-ml and creating notebooks...
Creating notebook get_started_snowflake_ml_start_here...✅
Creating notebook get_started_snowflake_ml_sf_nb_snowflake_ml_feature_transformations...✅
Creating notebook get_started_snowflake_ml_sf_nb_snowflake_ml_model_training_inference...✅
Creating notebook get_started_snowflake_ml_sf_nb_snowpark_ml_adv_mlops...✅
Running setup for this demo...✅

-- Example 13741
demo.show()

-- Example 13742
Showing step 1.
Please copy and paste this url in your web browser to open the notebook:
https://app.snowflake.com/myorg/myaccount/#/notebooks/SNOWFLAKE_DEMO_DB.SNOWFLAKE_DEMO_SCHEMA.GET_STARTED_SNOWFLAKE_ML_START_HERE

-- Example 13743
demo.show(step=1)

-- Example 13744
demo.show_next()

-- Example 13745
demo.teardown()

-- Example 13746
teardown()

-- Example 13747
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13748
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

-- Example 13749
account_iter = root.accounts.iter(like="my%")  # returns a PagedIter[Account]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13750
account_iter = root.accounts.iter(history=True)  # returns a PagedIter[Account]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13751
my_account_res = root.accounts["my_account1"]
my_account_res.drop(grace_period_in_days=4)
my_account_res.undrop()

-- Example 13752
from snowflake.core.managed_account import ManagedAccount

my_managed_account = ManagedAccount(
  name="reader_acct1",
  admin_name="admin",
  admin_password="TestPassword1",
  type="READER",
  comment="creating my managed account",
)

root.managed_accounts.create(my_managed_account)

-- Example 13753
account_iter = root.managed_accounts.iter(like="reader%")  # returns a PagedIter[ManagedAccount]
for account_obj in account_iter:
  print(account_obj.name)

-- Example 13754
my_managed_account_res = root.managed_accounts["reader_acct1"]
my_managed_account_res.drop()

-- Example 13755
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13756
from snowflake.core.alert import Alert, MinutesSchedule

root.alerts.create(Alert(
    name="my_alert",
    condition="SELECT 1",
    action="SELECT 2",
    schedule=MinutesSchedule(minutes=1),
    comment="test comment"
))

-- Example 13757
my_alert = root.alerts["my_alert"].fetch()
print(my_alert.to_dict())

-- Example 13758
alerts_iter = root.alerts.iter(like="my%", show_limit=5)
for alert_obj in alerts_iter:
  print(alert_obj.name)

-- Example 13759
my_alert_res = root.alerts["my_alert"]

my_alert_res.execute()
my_alert_res.drop()

-- Example 13760
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13761
from snowflake.core.stage import Stage, StageEncryption

my_stage = Stage(
  name="my_stage",
  encryption=StageEncryption(type="SNOWFLAKE_SSE")
)
stages = root.databases["my_db"].schemas["my_schema"].stages
stages.create(my_stage)

-- Example 13762
my_stage = root.databases["my_db"].schemas["my_schema"].stages["my_stage"].fetch()
print(my_stage.to_dict())

-- Example 13763
from snowflake.core.stage import StageCollection

stages: StageCollection = root.databases["my_db"].schemas["my_schema"].stages
stage_iter = stages.iter(like="my%")  # returns a PagedIter[Stage]
for stage_obj in stage_iter:
  print(stage_obj.name)

-- Example 13764
my_stage_res = root.databases["my_db"].schemas["my_schema"].stages["my_stage"]

my_stage_res.put("./my-file.yaml", "/", auto_compress=False, overwrite=True)

stageFiles = root.databases["my_db"].schemas["my_schema"].stages["my_stage"].list_files()
for stageFile in stageFiles:
  print(stageFile)

my_stage_res.drop()

-- Example 13765
from snowflake.core.pipe import Pipe

my_pipe = Pipe(
  name="my_pipe",
  comment="creating my pipe",
  copy_statement="COPY INTO my_table FROM @mystage FILE_FORMAT = (TYPE = 'JSON')",
)

pipes = root.databases["my_db"].schemas["my_schema"].pipes
pipes.create(my_pipe)

-- Example 13766
my_pipe = root.databases["my_db"].schemas["my_schema"].pipes["my_pipe"].fetch()
print(my_pipe.to_dict())

-- Example 13767
from snowflake.core.pipe import PipeCollection

pipes: PipeCollection = root.databases["my_db"].schemas["my_schema"].pipes
pipe_iter = pipes.iter(like="my%")  # returns a PagedIter[Pipe]
for pipe_obj in pipe_iter:
  print(pipe_obj.name)

-- Example 13768
my_pipe_res = root.databases["my_db"].schemas["my_schema"].pipes["my_pipe"]

# equivalent to: ALTER PIPE my_pipe REFRESH PREFIX = 'dir3/'
my_pipe_res.refresh(prefix="dir3/")

my_pipe_res.drop()

-- Example 13769
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

-- Example 13770
my_external_volume = root.external_volumes["my_external_volume"].fetch()
print(my_external_volume.to_dict())

-- Example 13771
external_volume_iter = root.external_volumes.iter(like="my%")
for external_volume_obj in external_volume_iter:
  print(external_volume_obj.name)

-- Example 13772
my_external_volume_res = root.external_volumes["my_external_volume"]
my_external_volume_res.drop()
my_external_volume_res.undrop()

-- Example 13773
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 13774
from snowflake.core.database import Database

my_db = Database(name="my_db")
root.databases.create(my_db)

-- Example 13775
my_db = root.databases["my_db"].fetch()
print(my_db.to_dict())

-- Example 13776
databases = root.databases.iter(like="my%")
for database in databases:
  print(database.name)

-- Example 13777
my_db_res = root.databases["my_db"]
my_db_res.drop()
my_db_res.undrop()

-- Example 13778
from snowflake.core.schema import Schema

my_schema = Schema(name="my_schema")
root.databases["my_db"].schemas.create(my_schema)

-- Example 13779
my_schema = root.databases["my_db"].schemas["my_schema"].fetch()
print(my_schema.to_dict())

-- Example 13780
schema_list = root.databases["my_db"].schemas.iter()
for schema_obj in schema_list:
  print(schema_obj.name)

-- Example 13781
my_schema_res = root.databases["my_db"].schemas["my_schema"]
my_schema_res.drop()
my_schema_res.undrop()

