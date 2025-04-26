-- Example 16930
CALL select_from_table(SYSTEM$REFERENCE('TABLE', 'my_table');

-- Example 16931
SET tableRef = (SELECT SYSTEM$REFERENCE('TABLE', 'my_table'));

SELECT * FROM IDENTIFIER($tableRef);

-- Example 16932
CALL insert_row(SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT'));

-- Example 16933
SELECT SYSTEM$REFERENCE('TABLE', 'table_with_different_owner', 'SESSION', 'INSERT', 'UPDATE', 'TRUNCATE');

-- Example 16934
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
  RETURNS INTEGER
  LANGUAGE SQL
  AS
  DECLARE
    row_count INTEGER DEFAULT 0;
    stmt VARCHAR DEFAULT 'SELECT COUNT(*) FROM (' || query || ')';
    res RESULTSET DEFAULT (EXECUTE IMMEDIATE :stmt);
    cur CURSOR FOR res;
  BEGIN
    OPEN cur;
    FETCH cur INTO row_count;
    RETURN row_count;
  END;

-- Example 16935
USE ROLE stored_proc_owner;

CREATE OR REPLACE PROCEDURE get_num_results(query VARCHAR)
RETURNS FLOAT
LANGUAGE JAVASCRIPT
AS
$$
  let res = snowflake.execute({
    sqlText: "SELECT COUNT(*) FROM (" + QUERY + ");",
  });
  res.next()
  return res.getColumnValue(1);
$$;

-- Example 16936
USE ROLE table_owner;
CREATE OR REPLACE TABLE table_with_different_owner (x NUMBER) AS SELECT 42;

CALL get_num_results('SELECT x FROM table_with_different_owner');

-- Example 16937
002003 (42S02): Uncaught exception of type 'STATEMENT_ERROR' on line 4 at position 29 : SQL compilation error:
Object 'TABLE_WITH_DIFFERENT_OWNER' does not exist or not authorized.

-- Example 16938
USE ROLE table_owner;

CALL get_num_results(
  SYSTEM$QUERY_REFERENCE('SELECT x FROM table_with_different_owner', true)
);

-- Example 16939
+-----------------+
| GET_NUM_RESULTS |
|-----------------|
|               1 |
+-----------------+

-- Example 16940
snowflake.execute({
  sqlText: "SELECT COUNT(*) FROM (" + QUERY + ");"
});

-- Example 16941
TABLE( [[<database_name>.]<schema_name>.]<object_name> )

-- Example 16942
TABLE("<object_name_that_requires_double_quotes>")

-- Example 16943
TABLE(IDENTIFIER('string_literal_for_object_name'))

-- Example 16944
CALL my_procedure(TABLE(my_table));

-- Example 16945
CALL my_procedure(TABLE(my_database.my_schema.my_view));

-- Example 16946
CALL my_procedure(TABLE("My Table Name"));

-- Example 16947
CALL my_procedure(TABLE(IDENTIFIER('my_view')));

-- Example 16948
TABLE(<select_statement>)

-- Example 16949
CALL my_procedure(TABLE(SELECT * FROM my_view));

-- Example 16950
CALL my_procedure(TABLE(WITH c(s) as (SELECT $1 FROM VALUES (1), (2)) SELECT a, count(*) FROM T, C WHERE s = a GROUP BY a));

-- Example 16951
CREATE STAGE my_int_stage
  DIRECTORY = (
    ENABLE = TRUE
    AUTO_REFRESH = TRUE
  );

-- Example 16952
DESCRIBE COMPUTE POOL my_pool;

-- Example 16953
ALTER COMPUTE POOL <compute_pool_name>
    SET MAX_NODES = <total_capacity>;

-- Example 16954
snowflake.ml.runtime_cluster.scale_cluster(
    expected_cluster_size: int,
    *,
    notebook_name: Optional[str] = None,
    is_async: bool = False,
    options: Optional[Dict[str, Any]] = None
) -> bool

-- Example 16955
from snowflake.ml.runtime_cluster import scale_cluster

# Example 1: Scale up the cluster
scale_cluster(3) # Scales the cluster to 3 total nodes (1 head + 2 workers)

# Example 2: Scale down the cluster
scale_cluster(1) # Scales the cluster to 1 head + 0 workers

# Example 3: Asynchronous scaling - function returns immediately after request is accepted
scale_cluster(5, is_async=True)

# Example 4: Scaling with custom options - wait for at least 2 nodes to be ready
scale_cluster(5, options={"block_until_min_cluster_size": 2})

-- Example 16956
get_nodes() -> list

-- Example 16957
from snowflake.ml.runtime_cluster import get_nodes

# Example: Get the active nodes in the cluster
nodes = get_nodes()
print(len(nodes), nodes)

-- Example 16958
2 [{'name': "IP1", 'cpus': 4, 'gpus': 0}, {'name': "IP2", 'cpus': 8, 'gpus': 1}]

-- Example 16959
from snowflake.ml.modeling.distributors.xgboost import XGBEstimator, XGBScalingConfig
from snowflake.ml.data.data_connector import DataConnector
from implementations.ray_data_ingester import RayDataIngester
table_name = "MULTINODE_SAMPLE_TRAIN_DS"

# Use code like the following to generate example data
"""
# Create a table in current database/schema and store data there
def generate_dataset_sql(db, schema, table_name) -> str:
    sql_script = f"CREATE TABLE IF NOT EXISTS {db}.{schema}.{table_name} AS \n"
    sql_script += f"select \n"
    for i in range(1, 10):
        sql_script += f"uniform(0::float, 10::float, random()) AS FT_{i}, \n"
    sql_script += f"FT_1 + FT_2 AS TARGET, \n"
    sql_script += f"from TABLE(generator(rowcount=>({10000})));"
    return sql_script
session.sql(generate_dataset_sql(session.get_current_database(), session.get_current_schema(), table_name)).collect()
"""

sample_train_df = session.table(table_name)
INPUT_COLS = list(sample_train_df.columns)
LABEL_COL = "TARGET"
INPUT_COLS.remove(LABEL_COL)

params = {
    "eta": 0.1,
    "max_depth": 8,
    "min_child_weight": 100,
    "tree_method": "hist",
}

scaling_config = XGBScalingConfig(
    use_gpu=False
)

estimator = XGBEstimator(
    n_estimators=50,
    objective="reg:squarederror",
    params=params,
    scaling_config=scaling_config,
)
data_connector = DataConnector.from_dataframe(
    sample_train_df, ingestor_class=RayDataIngester
)

xgb_model = estimator.fit(
    data_connector, input_cols=INPUT_COLS, label_col=LABEL_COL
)

-- Example 16960
dataset_map = context.get_dataset_map()
train_dataset = DecodedDataset(dataset_map["train"].get_shard().to_torch_dataset())
test_dataset = DecodedDataset(dataset_map["test"].to_torch_dataset())

hyper_parms = context.get_hyper_params()
num_epochs = int(hyper_parms['num_epochs'])

-- Example 16961
context.get_metrics_reporter().log_metrics({"train_func_train_time": int(now-start_time)})

-- Example 16962
def train_func():
    import io
    import base64
    import time
    import torch
    import torch.nn as nn
    import torch.nn.functional as F
    import torch.optim as optim
    import torch.distributed as dist
    from torch.nn.parallel import DistributedDataParallel as DDP
    from torchvision import transforms
    from torch.utils.data import IterableDataset
    from torch.optim.lr_scheduler import StepLR
    from PIL import Image
    from snowflake.ml.modeling.distributors.pytorch import get_context

    class Net(nn.Module):
        def __init__(self):
            super(Net, self).__init__()
            self.conv1 = nn.Conv2d(1, 32, 3, 1)
            self.conv2 = nn.Conv2d(32, 64, 3, 1)
            self.dropout1 = nn.Dropout(0.25)
            self.dropout2 = nn.Dropout(0.5)
            self.fc1 = nn.Linear(9216, 128)
            self.fc2 = nn.Linear(128, 10)

        def forward(self, x):
            x = self.conv1(x)
            x = F.relu(x)
            x = self.conv2(x)
            x = F.relu(x)
            x = F.max_pool2d(x, 2)
            x = self.dropout1(x)
            x = torch.flatten(x, 1)
            x = self.fc1(x)
            x = F.relu(x)
            x = self.dropout2(x)
            x = self.fc2(x)
            output = F.log_softmax(x, dim=1)
            return output

    class DecodedDataset(IterableDataset):
        def __init__(self, source_dataset):
            self.source_dataset = source_dataset
            self.transforms = transforms.ToTensor()  # Ensure we apply ToTensor transform

        def __iter__(self):
            for row in self.source_dataset:
                base64_image = row['IMAGE']
                image = Image.open(io.BytesIO(base64.b64decode(base64_image)))
                # Convert the image to a tensor
                image = self.transforms(image)  # Converts PIL image to tensor

                labels = row['LABEL']
                yield image, int(labels)

    def train(model, device, train_loader, optimizer, epoch):
        model.train()
        batch_idx = 1
        for data, target in train_loader:
            # print(f"data : {data} \n target: {target}")
            # raise RuntimeError("test")
            data, target = data.to(device), target.to(device)
            optimizer.zero_grad()
            output = model(data)
            loss = F.nll_loss(output, target)
            loss.backward()
            optimizer.step()
            if batch_idx % 100 == 0:
                print('Train Epoch: {} [Processed {} images]\tLoss: {:.6f}'.format(epoch, batch_idx * len(data), loss.item()))
            batch_idx += 1

    context = get_context()
    rank = context.get_local_rank()
    device = f"cuda:{rank}"
    is_distributed = context.get_world_size() > 1
    if is_distributed:
        dist.init_process_group(backend="nccl")
    print(f"Worker Rank : {context.get_rank()}, world_size: {context.get_world_size()}")

    dataset_map = context.get_dataset_map()
    train_dataset = DecodedDataset(dataset_map["train"].get_shard().to_torch_dataset())
    test_dataset = DecodedDataset(dataset_map["test"].to_torch_dataset())

    batch_size = 64
    train_loader = torch.utils.data.DataLoader(
        train_dataset,
        batch_size=batch_size,
        pin_memory=True,
        pin_memory_device=f"cuda:{rank}"
    )
    test_loader = torch.utils.data.DataLoader(
        test_dataset,
        batch_size=batch_size,
        pin_memory=True,
        pin_memory_device=f"cuda:{rank}"
    )

    model = Net().to(device)
    if is_distributed:
        model = DDP(model)
    optimizer = optim.Adadelta(model.parameters())
    scheduler = StepLR(optimizer, step_size=1)

    hyper_parms = context.get_hyper_params()
    num_epochs = int(hyper_parms['num_epochs'])
    start_time = time.time()
    for epoch in range(num_epochs):
        train(model, device, train_loader, optimizer, epoch+1)
        scheduler.step()
    now = time.time()
    context.get_metrics_reporter().log_metrics({"train_func_train_time": int(now-start_time)})
    test(model, device, test_loader, context)

-- Example 16963
# Set up PyTorchDistributor
from snowflake.ml.modeling.distributors.pytorch import PyTorchDistributor, PyTorchScalingConfig, WorkerResourceConfig
from snowflake.ml.data.sharded_data_connector import ShardedDataConnector
from snowflake.ml.data.data_connector import DataConnector

df = session.table("MNIST_60K")

train_df, test_df = df.random_split([0.99, 0.01], 0)

# Create data connectors for training and test data
train_data = ShardedDataConnector.from_dataframe(train_df)
test_data = DataConnector.from_dataframe(test_df)

pytorch_trainer = PyTorchDistributor(
    train_func=train_func,
    scaling_config=PyTorchScalingConfig(  # scaling configuration
        num_nodes=2,
        num_workers_per_node=1,
        resource_requirements_per_worker=WorkerResourceConfig(num_cpus=0, num_gpus=1),
    )
)

# Run the trainer.
results = pytorch_trainer.run(  # accepts context values as parameters
    dataset_map={"train": train_data, "test": test_data},
    hyper_params={"num_epochs": "1"}
)

-- Example 16964
scale_cluster(3, is_async=True)

-- Example 16965
scale_cluster(3, options={"rollback_after_seconds": 1200})

-- Example 16966
# Explicitly specifying the notebook name if naming auto detection doesn't work
try:
    scale_cluster(2)
except Exception as e:
    print(e)  # Output: "Notebook "WRONG_NOTEBOOK" does not exist or not authorized"
    scale_cluster(2, notebook_name='"MY_NOTEBOOK"')

-- Example 16967
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE some_user_role;

-- Example 16968
GRANT DATABASE ROLE SNOWFLAKE.PYPI_REPOSITORY_USER TO ROLE PUBLIC;

-- Example 16969
CREATE OR REPLACE FUNCTION sklearn_udf()
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  ARTIFACT_REPOSITORY = snowflake.snowpark.pypi_shared_repository
  ARTIFACT_REPOSITORY_PACKAGES = ('scikit-learn')
  HANDLER = 'udf'
  AS
$$
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

def udf():
  X, y = load_iris(return_X_y=True)
  X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.25, random_state=42)

  model = RandomForestClassifier()
  model.fit(X_train, y_train)
  return model.score(X_test, y_test)
$$;

SELECT sklearn_udf();

-- Example 16970
CREATE OR REPLACE PROCEDURE TEST_PRESIDIO(x)
  RETURNS STRING
  LANGUAGE PYTHON
  RESOURCE_CONSTRAINT=(architecture='x86')
  RUNTIME_VERSION = 3.9
  HANDLER = 'main'
  ARTIFACT_REPOSITORY = snowflake.snowpark.pypi_shared_repository
  ARTIFACT_REPOSITORY_PACKAGES = ('presidio_analyzer','presidio_anonymizer')
  AS
$$
from presidio_analyzer import AnalyzerEngine

# Set up the engine, loads the NLP module (spaCy model by default) and other PII recognizers
analyzer = AnalyzerEngine()

# Call analyzer to get results
results = analyzer.analyze(text="My phone number is 425-xxx-xxxx",
entities=["PHONE_NUMBER"],
language='en')
return results
$$;

-- Example 16971
...
artifact_repository="snowflake.snowpark.pypi_shared_repository",
artifact_repository_packages=["urllib3", "requests"],
...

-- Example 16972
pip install <package name> --only-binary=:all: --python-version 3.9 –platform <platform_tag>

-- Example 16973
pip install snowflake-sqlalchemy --dry-run --ignore-installed

-- Example 16974
CREATE OR REPLACE FUNCTION sklearn_udf()
  RETURNS FLOAT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('snowpark','snowflake-sqlalchemy')
  ARTIFACT_REPOSITORY = my_pypirepo
  ARTIFACT_REPOSITORY_PACKAGES = ('scikit-learn')
  HANDLER = 'udf'
  AS
  ...

-- Example 16975
CREATE WAREHOUSE so_warehouse WITH
   WAREHOUSE_SIZE = 'LARGE'
   WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
   RESOURCE_CONSTRAINT = 'MEMORY_16X_X86';

-- Example 16976
create or replace function native_module_test_zip()
   returns string
   language python
   runtime_version=3.9
   resource_constraint=(architecture='x86')
   imports=('@mystage/mycustompackage.zip')
   handler='compute'
   as
   $$
   def compute():
      import mycustompackage
      return mycustompackage.mycustompackage()
   $$;

-- Example 16977
select * from information_schema.packages where language = 'python';

-- Example 16978
select * from information_schema.packages where (package_name = 'numpy' and language = 'python');

-- Example 16979
desc function stock_sale_average(varchar, number, number);

-- Example 16980
conda create --name py39_env -c https://repo.anaconda.com/pkgs/snowflake python=3.9 numpy pandas

-- Example 16981
import xgboost as xgb
model = xgb.Booster()
model.set_param('nthread', 1)
model.load_model(...)

-- Example 16982
import xgboost as xgb
model = xgb.XGBRegressor(n_jobs=1)

-- Example 16983
import keras
model = keras.models.load_model(...)
model.predict_on_batch(np.array([input]))

-- Example 16984
SELECT * FROM "ORGDATACLOUD$<ProfileName>$<ListingName>.<SchemaName>.<TableName>;

-- Example 16985
spec:
  containers:                           # container list
  - name: <name>
    image: <image-name>
    command:                            # optional list of strings
      - <cmd>
      - <arg1>
    args:                               # optional list of strings
      - <arg2>
      - <arg3>
      - ...
    env:                                # optional
        <key>: <value>
        <key>: <value>
        ...
    readinessProbe:                     # optional
        port: <TCP port-num>
        path: <http-path>
    volumeMounts:                       # optional list
      - name: <volume-name>
        mountPath: <mount-path>
      - name: <volume-name>
        ...
    resources:                          # optional
        requests:
          memory: <amount-of-memory>
          nvidia.com/gpu: <count>
          cpu: <cpu-units>
        limits:
          memory: <amount-of-memory>
          nvidia.com/gpu: <count>
          cpu: <cpu-units>
    secrets:                                # optional list
      - snowflakeSecret:
          objectName: <object-name>         # specify this or objectReference
          objectReference: <reference-name> # specify this or objectName
        directoryPath: <path>               # specify this or envVarName
        envVarName: <name>                  # specify this or directoryPath
        secretKeyRef: username | password | secret_string # specify only with envVarName
  endpoints:                             # optional endpoint list
    - name: <name>
      port: <TCP port-num>                     # specify this or portRange
      portRange: <TCP port-num>-<TCP port-num> # specify this or port
      public: <true / false>
      protocol : < TCP / HTTP >
      corsSettings:                  # optional CORS configuration
        Access-Control-Allow-Origin: # required list of allowed origins, for example, "http://example.com"
          - <origin>
          - <origin>
            ...
        Access-Control-Allow-Methods: # optional list of HTTP methods
          - <method>
          - <method>
            ...
        Access-Control-Allow-Headers: # optional list of HTTP headers
          - <header-name>
          - <header-name>
            ...
        Access-Control-Expose-Headers: # optional list of HTTP headers
          - <header-name>
          - <header-name>
            ...
    - name: <name>
      ...
  volumes:                               # optional volume list
    - name: <name>
      source: local | @<stagename> | memory | block
      size: <bytes-of-storage>           # specify if memory or block is the volume source
      blockConfig:                       # optional
        initialContents:
          fromSnapshot: <snapshot-name>
        iops: <number-of-operations>
        throughput: <MiB per second>
      uid: <UID-value>                   # optional, only for stage volumes
      gid: <GID-value>                   # optional, only for stage volumes
    - name: <name>
      source: local | @<stagename> | memory | block
      size: <bytes-of-storage>           # specify if memory or block is the volume source
      ...
  logExporters:
    eventTableConfig:
      logLevel: <INFO | ERROR | NONE>
  platformMonitor:                      # optional, platform metrics to log to the event table
    metricConfig:
      groups:
      - <group-1>
      - <group-2>
      ...
capabilities:
  securityContext:
    executeAsCaller: <true / false>     # optional, indicates whether application intends to use caller’s rights
serviceRoles:                   # Optional list of service roles
- name: <service-role-name>
  endpoints:
  - <endpoint_name1>
  - <endpoint_name2>
  - ...
- ...

-- Example 16986
spec:
  containers:
    - name: echo
      image: /tutorial_db/data_schema/tutorial_repository/echo_service:dev

-- Example 16987
ENTRYPOINT ["python3", "main.py"]
CMD ["Bob"]

-- Example 16988
spec:
  containers:
  - name: echo
    image: <image_name>
    command:
    - python3.9
    - main.py

-- Example 16989
spec:
  containers:
  - name: echo
    image: <image_name>
    args:
      - Alice

-- Example 16990
spec:
  containers:
  - name: <name>
    image: <image_name>
    env:
      ENV_VARIABLE_1: <value1>
      ENV_VARIABLE_2: <value2>
      …
      …

-- Example 16991
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)

-- Example 16992
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      CHARACTER_NAME: Bob
      SERVER_PORT: 8085
  endpoints:
  - name: echo-endpoint
    port: 8085

-- Example 16993
@app.get("/healthcheck")
def readiness_probe():

-- Example 16994
spec:
  containers:
  - name: echo
    image: <image_name>
    env:
      SERVER_PORT: 8088
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8088
      path: /healthcheck
  endpoints:
  - name: echo-endpoint
    port: 8088

-- Example 16995
spec:
  containers:
  - name: resource-test-gpu
    image: ...
    resources:
      requests:
        memory: 2G
        cpu: 0.5
        nvidia.com/gpu: 1
      limits:
        memory: 4G
        nvidia.com/gpu: 1

-- Example 16996
CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 2
  MAX_NODES = 2
  INSTANCE_FAMILY = gpu_nv_s

