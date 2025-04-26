-- Example 1429
metrics = mv.show_metrics()

-- Example 1430
mv.delete_metric("test_accuracy")

-- Example 1431
mv.export("~/mymodel/")

-- Example 1432
mv.export("~/mymodel/", export_mode=ExportMode.FULL)

-- Example 1433
clf = mv.load()

-- Example 1434
conda_env = session.file.get("snow://model/<modelName>/versions/<versionName>/runtimes/python_runtime/env/conda.yml", ".")
open("~/conda.yml", "w").write(conda_env)

-- Example 1435
conda env create --name newenv --file=~/conda.yml
conda activate newenv

-- Example 1436
clf = mv.load(options={"use_gpu": True})

-- Example 1437
remote_prediction = mv.run(test_features, function_name="predict")
remote_prediction.show()   # assuming test_features is Snowpark DataFrame

-- Example 1438
from snowflake import snowpark
from snowflake.ml import dataset

# Create Snowpark Session
# See https://docs.snowflake.com/en/developer-guide/snowpark/python/creating-session
session = snowpark.Session.builder.configs(connection_parameters).create()

# Create a Snowpark DataFrame to serve as a data source
# In this example, we generate a random table with 100 rows and 1 column
df = session.sql(
  "select uniform(0, 10, random(1)) as x, uniform(0, 10, random(2)) as y from table(generator(rowcount => 100))"
)

# Materialize DataFrame contents into a Dataset
ds1 = dataset.create_from_dataframe(
    session,
    "my_dataset",
    "version1",
    input_dataframe=df)

-- Example 1439
# Inspect currently selected version
print(ds1.selected_version) # DatasetVersion(dataset='my_dataset', version='version1')
print(ds1.selected_version.created_on) # Prints creation timestamp

# List all versions in the Dataset
print(ds1.list_versions()) # ["version1"]

# Create a new version
ds2 = ds1.create_version("version2", df)
print(ds1.selected_version.name)  # "version1"
print(ds2.selected_version.name)  # "version2"
print(ds1.list_versions())        # ["version1", "version2"]

# selected_version is immutable, meaning switching versions with
# ds1.select_version() returns a new Dataset object without
# affecting ds1.selected_version
ds3 = ds1.select_version("version2")
print(ds1.selected_version.name)  # "version1"
print(ds3.selected_version.name)  # "version2"

-- Example 1440
import tensorflow as tf

# Convert Snowflake Dataset to TensorFlow Dataset
tf_dataset = ds1.read.to_tf_dataset(batch_size=32)

# Train a TensorFlow model
for batch in tf_dataset:
    # Extract and build tensors as needed
    input_tensor = tf.stack(list(batch.values()), axis=-1)

    # Forward pass (details not included for brevity)
    outputs = model(input_tensor)

-- Example 1441
import torch

# Convert Snowflake Dataset to PyTorch DataPipe
pt_datapipe = ds1.read.to_torch_datapipe(batch_size=32)

# Train a PyTorch model
for batch in pt_datapipe:
    # Extract and build tensors as needed
    input_tensor = torch.stack([torch.from_numpy(v) for v in batch.values()], dim=-1)

    # Forward pass (details not included for brevity)
    outputs = model(input_tensor)

-- Example 1442
from snowflake.ml.modeling.ensemble import random_forest_regressor

# Get a Snowpark DataFrame
ds_df = ds1.read.to_snowpark_dataframe()

# Note ds_df != df
ds_df.explain()
df.explain()

# Train a model in Snowpark ML
xgboost_model = random_forest_regressor.RandomForestRegressor(
    n_estimators=100,
    random_state=42,
    input_cols=["X"],
    label_cols=["Y"],
)
xgboost_model.fit(ds_df)

-- Example 1443
print(ds1.read.files()) # ['snow://dataset/my_dataset/versions/version1/data_0_0_0.snappy.parquet']

import pyarrow.parquet as pq
pd_ds = pq.ParquetDataset(ds1.read.files(), filesystem=ds1.read.filesystem())

import dask.dataframe as dd
dd_df = dd.read_parquet(ds1.read.files(), filesystem=ds1.read.filesystem())

-- Example 1444
LIST 'snow://dataset/<dataset_name>/versions/<dataset_version>'

-- Example 1445
INFER_SCHEMA(
  LOCATION => 'snow://dataset/<dataset_name>/versions/<dataset_version>',
  FILE_FORMAT => '<file_format_name>'
)

-- Example 1446
CREATE FILE FORMAT my_parquet_format TYPE = PARQUET;

SELECT *
FROM TABLE(
    INFER_SCHEMA(
        FILE_FORMAT => 'snow://dataset/MYDS/versions/v1,
        FILE_FORMAT => 'my_parquet_format'
    )
);

-- Example 1447
SELECT $1
FROM 'snow://dataset/foo/versions/V1'
( FILE_FORMAT => 'my_parquet_format',
PATTERN => '.*data.*' ) t;

-- Example 1448
from snowflake.ml import dataset
from snowflake.ml.data import DataConnector

# Create a DataConnector from a SQL query
connector = DataConnector.from_sql("SELECT * FROM my_table", session=session)

# Create a DataConnector from a Snowpark DataFrame
df = session.table(my_table)
connector = DataConnector.from_dataframe(df)

# Create a DataConnector from a Snowflake Dataset
ds = dataset.load_dataset(session, "my_dataset", "v1")
connector = DataConnector.from_dataset(ds)

-- Example 1449
from torch.utils.data import DataLoader

torch_ds = connector.to_torch_dataset(
    batch_size=4,
    shuffle=True,
    drop_last_batch=True
)

for batch in DataLoader(torch_ds, batch_size=None, num_workers=0):
    print(batch)

-- Example 1450
tf_ds = connector.to_tf_dataset(
    batch_size=4,
    shuffle=True,
    drop_last_batch=True
)

for batch in tf_ds:
    print(batch)

-- Example 1451
conda create --name snowpark-ml

-- Example 1452
conda activate snowpark-ml

-- Example 1453
conda install --override-channels --channel https://repo.anaconda.com/pkgs/snowflake/ snowflake-ml-python

-- Example 1454
cd ~/projects/ml
source .venv/bin/activate

-- Example 1455
python -m pip install snowflake-ml-python

-- Example 1456
conda activate snowpark-ml
conda install --override-channels --channel https://repo.anaconda.com/pkgs/snowflake/ lightgbm

-- Example 1457
.venv/bin/activate
python -m pip install 'snowflake-ml-python[lightgbm]'

-- Example 1458
.venv/bin/activate
python -m pip install 'snowflake-ml-python[all]'

-- Example 1459
from snowflake.snowpark import Session
from snowflake.ml.utils import connection_params

params = connection_params.SnowflakeLoginOptions("myaccount")
sp_session = Session.builder.configs(params).create()

-- Example 1460
session = Session.builder.configs({"connection": connection}).create()

-- Example 1461
from snowflake.snowpark import Session
from snowflake.ml.utils import connection_params
# Get named connection from SnowSQL configuration file
params = connection_params.SnowflakeLoginOptions("myaccount")
# Add warehouse name for model method calls if it's not already present
if "warehouse" not in params:
    params["warehouse"] = "mlwarehouse"
sp_session = Session.builder.configs(params).create()

-- Example 1462
sp_session.use_warehouse("mlwarehouse")

-- Example 1463
from snowflake.ml.modeling.preprocessing import OneHotEncoder

help(OneHotEncoder)

-- Example 1464
>>> connection_parameters = dict(
...    account = 'your account name',
...    user = 'your user name',
...    password = 'your password',
...    database = 'database name',
...    schema = 'schema name',
...    role = 'role if needed',
...    warehouse = 'warehouse name',
... )

-- Example 1465
>>> session = Session.builder.configs(connection_parameters).create()

-- Example 1466
>>> from snowflake.core import Root
>>> root = Root(session)

-- Example 1467
>>> from snowflake.core.task import Task
>>> from datetime import timedelta
>>> task_definition = Task(
...     'task1', definition='select 1', schedule=timedelta(hours=1))
... )

-- Example 1468
>>> schema = root.databases['my_db'].schemas['public']
>>> print(schema.name)
public
>>> print(schema.database.name)
my_db

-- Example 1469
>>> task_reference = schema.tasks.create(task_definition)

-- Example 1470
>>> task_reference.name
'task1'

-- Example 1471
>>> task = task_reference.fetch()
>>> task.name
'TASK1'

-- Example 1472
>>> task.schedule
datetime.timedelta(seconds=3600)

-- Example 1473
>>> task.schema_name
'PUBLIC'

-- Example 1474
>>> task_reference.fully_qualified_name
'my_db.public.task1'

-- Example 1475
>>> task_reference.resume()
>>> task_reference.suspend()
>>> task_reference.execute()

-- Example 1476
>>> task_reference.delete()

-- Example 1477
>>> task_reference.execute()
...
snowflake.core.exceptions.NotFoundError: (404)
Reason: None
HTTP response headers: HTTPHeaderDict({'Content-Type': 'application/json'})
HTTP response body: {"error_code": "404", ... }

-- Example 1478
CREATE ROLE tutorial1_role;

-- Example 1479
GRANT ROLE tutorial1_role TO USER <user_name>;

-- Example 1480
GRANT ALL PRIVILEGES ON warehouse <warehouse_name> TO ROLE tutorial1_role;
GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE tutorial1_role;
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE tutorial1_role;

-- Example 1481
snow connection add

-- Example 1482
snow connection test -c tut1-connection

-- Example 1483
+----------------------------------------------------------------------------------+
| key             | value                                                          |
|-----------------+----------------------------------------------------------------|
| Connection name | tut1-connection                                                |
| Status          | OK                                                             |
| Host            | USER_ACCOUNT.snowflakecomputing.com                            |
| Account         | USER_ACCOUNT                                                   |
| User            | tutorial_user                                                  |
| Role            | TUTORIAL1_ROLE                                                 |
| Database        | not set                                                        |
| Warehouse       | WAREHOUSE_NAME                                                 |
+----------------------------------------------------------------------------------+

-- Example 1484
snow init --template app_basic tutorial

-- Example 1485
-- Setup script for the Hello Snowflake! app.

-- Example 1486
This is the readme file for the Hello Snowflake app.

-- Example 1487
manifest_version: 1
artifacts:
   setup_script: setup_script.sql
   readme: README.md

-- Example 1488
definition_version: 2
entities:
   hello_snowflake_package:
      type: application package
      stage: stage_content.hello_snowflake_stage
      manifest: app/manifest.yml
      identifier: hello_snowflake_package
      artifacts:
         - src: app/*
           dest: ./
   hello_snowflake_app:
      type: application
      from:
         target: hello_snowflake_package
      debug: false

-- Example 1489
/tutorial
  snowflake.yml
  README.md
  /app/
    manifest.yml
    README.md
    setup_script.sql

-- Example 1490
CREATE APPLICATION ROLE IF NOT EXISTS app_public;
CREATE SCHEMA IF NOT EXISTS core;
GRANT USAGE ON SCHEMA core TO APPLICATION ROLE app_public;

-- Example 1491
CREATE OR REPLACE PROCEDURE CORE.HELLO()
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    RETURN 'Hello Snowflake!';
  END;

-- Example 1492
GRANT USAGE ON PROCEDURE core.hello() TO APPLICATION ROLE app_public;

-- Example 1493
snow app run -c tut1-connection

-- Example 1494
snow sql -q "call hello_snowflake_app.core.hello()" -c tut1-connection

-- Example 1495
+------------------+
| HELLO            |
|------------------|
| Hello Snowflake! |
+------------------+

-- Example 1496
USE APPLICATION PACKAGE <% ctx.entities.hello_snowflake_package.identifier %>;

CREATE SCHEMA IF NOT EXISTS shared_data;
USE SCHEMA shared_data;
CREATE TABLE IF NOT EXISTS accounts (ID INT, NAME VARCHAR, VALUE VARCHAR);
TRUNCATE TABLE accounts;
INSERT INTO accounts VALUES
  (1, 'Joe', 'Snowflake'),
  (2, 'Nima', 'Snowflake'),
  (3, 'Sally', 'Snowflake'),
  (4, 'Juan', 'Acme');
-- grant usage on the ``ACCOUNTS`` table
GRANT USAGE ON SCHEMA shared_data TO SHARE IN APPLICATION PACKAGE <% ctx.entities.hello_snowflake_package.identifier %>;
GRANT SELECT ON TABLE accounts TO SHARE IN APPLICATION PACKAGE <% ctx.entities.hello_snowflake_package.identifier %>;

