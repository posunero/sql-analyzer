-- Example 14720
-- Change the warehouse for my_dynamic_table to my_other_wh:
ALTER DYNAMIC TABLE my_dynamic_table SET
  WAREHOUSE = my_other_wh;

-- Example 14721
-- Specify the downstream target lag for a dynamic table:
ALTER DYNAMIC TABLE my_dynamic_table SET
  TARGET_LAG = DOWNSTREAM;

-- Example 14722
ALTER DYNAMIC TABLE my_dynamic_table RENAME TO my_new_dynamic_table;

-- Example 14723
-- Swap my_dynamic_table with the my_new_dynamic_table:
ALTER DYNAMIC TABLE my_dynamic_table SWAP WITH my_new_dynamic_table;

-- Example 14724
ALTER DYNAMIC TABLE my_dynamic_table CLUSTER BY (date);

-- Example 14725
DROP DYNAMIC TABLE my_dynamic_table;

-- Example 14726
UNDROP DYNAMIC TABLE my_dynamic_table;

-- Example 14727
SELECT name, scheduling_state
  FROM TABLE (INFORMATION_SCHEMA.DYNAMIC_TABLE_GRAPH_HISTORY());

-- Example 14728
+-------------------+---------------------------------------------------------------------------------+
  | NAME              | SCHEDULING_STATE                                                                |
  |-------------------+---------------------------------------------------------------------------------|
  | DTSIMPLE          | {                                                                               |
  |                   |   "reason_code": "SUSPENDED_DUE_TO_ERRORS",                                     |
  |                   |   "reason_message": "The DT was suspended due to 5 consecutive refresh errors", |
  |                   |   "state": "SUSPENDED",                                                         |
  |                   |   "suspended_on": "2023-06-06 19:27:29.142 -0700"                               |
  |                   | }                                                                               |
  | DT_TEST           | {                                                                               |
  |                   |   "state": "ACTIVE"                                                             |
  |                   | }                                                                               |
  +-------------------+---------------------------------------------------------------------------------+

-- Example 14729
ALTER DYNAMIC TABLE my_dynamic_table SUSPEND;

-- Example 14730
ALTER DYNAMIC TABLE my_dynamic_table RESUME;

-- Example 14731
ALTER DYNAMIC TABLE my_dynamic_table REFRESH

-- Example 14732
!pip install transformers scipy ftfy accelerate

-- Example 14733
CREATE OR REPLACE NETWORK RULE jfrog_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('<your-repo>.jfrog.io');

-- Example 14734
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION jfrog_integration
  ALLOWED_NETWORK_RULES = (jfrog_network_rule)
  ENABLED = TRUE;

GRANT USAGE ON INTEGRATION jfrog_integration TO ROLE data_scientist;

-- Example 14735
!pip install hello-jfrog --index-url https://<user>:<token>@<your-repo>.jfrog.io/artifactory/api/pypi/test-pypi/simple

-- Example 14736
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION private_repo_integration
  ALLOWED_NETWORK_RULES = (PRIVATE_LINK_NETWORK_RULE)
  ENABLED = TRUE;

GRANT USAGE ON INTEGRATION private_repo_integration TO ROLE data_scientist;

-- Example 14737
!pip install my_package --index-url https://my-private-repo-url.com/simple

-- Example 14738
from snowflake.snowpark.context import get_active_session
import pandas as pd
import xgboost as xgb
from sklearn.model_selection import train_test_split

session = get_active_session()
df = session.table("my_dataset")
# Pull data into local memory
df_pd = df.to_pandas()
X = df_pd[['feature1', 'feature2']]
y = df_pd['label']
# Split data into test and train in memory
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=34)
# Train in memory
model = xgb.XGBClassifier()
model.fit(X_train, y_train)
# Predict
y_pred = model.predict(X_test)

-- Example 14739
from snowflake.snowpark.context import get_active_session
import pandas as pd
import xgboost as xgb
from sklearn.model_selection import train_test_split

session = get_active_session()
df = session.table("my_dataset")
# Pull data into local memory
df_pd = df.to_pandas()
X = df_pd[['feature1', 'feature2']]
y = df_pd['label']
# Split data into test and train in memory
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=34)

-- Example 14740
pip install snowflake-ml-python>=1.8.2

-- Example 14741
CREATE COMPUTE POOL IF NOT EXISTS MY_COMPUTE_POOL
  MIN_NODES = <MIN_NODES>
  MAX_NODES = <MAX_NODES>
  INSTANCE_FAMILY = <INSTANCE_FAMILY>;

-- Example 14742
from snowflake.snowpark import Session
from snowflake.ml.jobs import list_jobs

ls = list_jobs() # This will fail! You must create a session first.

# Requires valid ~/.snowflake/config.toml file
session = Session.builder.getOrCreate()

ls = list_jobs(session=session)
ls = list_jobs() # Infers created session from context

-- Example 14743
from snowflake.ml.jobs import remote

@remote("MY_COMPUTE_POOL", stage_name="payload_stage", session=session)
def train_model(data_table: str):
  # Provide your ML code here, including imports and function calls
  ...

job = train_model("my_training_data")

-- Example 14744
from snowflake.ml.jobs import submit_file

# Run a single file
job1 = submit_file(
  "train.py",
  "MY_COMPUTE_POOL",
  stage_name="payload_stage",
  args=["--data-table", "my_training_data"],
  session=session,
)

-- Example 14745
from snowflake.ml.jobs import submit_directory

# Run from a directory
job2 = submit_directory(
  "./ml_project/",
  "MY_COMPUTE_POOL",
  entrypoint="train.py",
  stage_name="payload_stage",
  session=session,
)

-- Example 14746
from snowflake.ml.jobs import MLJob, get_job, list_jobs

# List all jobs
jobs = list_jobs()

# Retrieve an existing job based on ID
job = get_job("<job_id>")  # job is an MLJob instance

# Retrieve status and logs for the retrieved job
print(job.status)  # PENDING, RUNNING, FAILED, DONE
print(job.get_logs())

-- Example 14747
result = job.result()

-- Example 14748
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION PYPI_EAI
  ALLOWED_NETWORK_RULES = (snowflake.external_access.pypi_rule)
  ENABLED = true;

-- Example 14749
@remote(
  "MY_COMPUTE_POOL",
  stage_name="payload_stage",
  pip_requirements=["custom-package"],
  external_access_integrations=["PYPI_EAI"],
  session=session,
)
def my_function():
  # Your code here

-- Example 14750
from snowflake.ml.jobs import submit_file

# Can include version specifier to specify version(s)
job = submit_file(
  "/path/to/repo/my_script.py",
  compute_pool,
  stage_name="payload_stage",
  pip_requirements=["custom-package==1.0.*"],
  external_access_integrations=["pypi_eai"],
  session=session,
)

-- Example 14751
CREATE OR REPLACE NETWORK RULE private_feed_nr
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('<your-repo>.jfrog.io');

-- Example 14752
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION private_feed_eai
ALLOWED_NETWORK_RULES = (PRIVATE_FEED_NR)
ENABLED = true;

GRANT USAGE ON INTEGRATION private_feed_eai TO ROLE <role_name>;

-- Example 14753
# Option 1: Specify private feed URL in pip_requirements
job = submit_file(
  "/path/to/script.py",
  compute_pool="MY_COMPUTE_POOL",
  stage_name="payload_stage",
  pip_requirements=[
    "--index-url=https://your.private.feed.url",
    "internal-package==1.2.3"
  ],
  external_access_integrations=["PRIVATE_FEED_EAI"]
)

-- Example 14754
# Option 2: Specify private feed URL by environment variable
job = submit_directory(
  "/path/to/code/",
  compute_pool="MY_COMPUTE_POOL",
  entrypoint="script.py",
  stage_name="payload_stage",
  pip_requirements=["internal-package==1.2.3"],
  external_access_integrations=["PRIVATE_FEED_EAI"],
  env_vars={'PIP_INDEX_URL': 'https://your.private.feed.url'},
)

-- Example 14755
# Create secret for private feed URL with embedded auth token
feed_url = "<your-repo>.jfrog.io/artifactory/api/pypi/test-pypi/simple"
user = "<auth_user>"
token = "<auth_token>"
session.sql(f"""
CREATE SECRET IF NOT EXISTS PRIVATE_FEED_URL_SECRET
 TYPE = GENERIC_STRING
 SECRET_STRING = 'https://{auth_user}:{auth_token}@{feed_url}'
""").collect()

# Prepare service spec override for mounting secret into job execution
spec_overrides = {
 "spec": {
  "containers": [
    {
     "name": "main",  # Primary container name is always "main"
     "secrets": [
      {
        "snowflakeSecret": "PRIVATE_FEED_URL_SECRET",
        "envVarName": "PIP_INDEX_URL",
        "secretKeyRef": "secret_string"
      },
     ],
    }
  ]
 }
}

# Load private feed URL from secret (e.g. if URL includes auth token)
job = submit_file(
  "/path/to/script.py",
  compute_pool="MY_COMPUTE_POOL",
  stage_name="payload_stage",
  pip_requirements=[
    "internal-package==1.2.3"
  ],
  external_access_integrations=["PRIVATE_FEED_EAI"],
  spec_overrides=spec_overrides,
)

-- Example 14756
dataset_map = {
  "x_train": DataConnector.from_dataframe(session.create_dataframe(X_train)),
  "y_train": DataConnector.from_dataframe(
      session.create_dataframe(y_train.to_frame())
  ),
  "x_test": DataConnector.from_dataframe(session.create_dataframe(X_test)),
  "y_test": DataConnector.from_dataframe(
      session.create_dataframe(y_test.to_frame())
  ),
}

-- Example 14757
search_space = {
    "n_estimators": [50, 51],
    "max_depth": [4, 5]),
    "learning_rate": [0.01, 0.3],
}
In the preceding example, each parameter has two possible values. There are 8 (2 * 2 * 2) possible combinations of hyperparameters.

-- Example 14758
from entities import search_algorithm
search_alg = search_algorithm.BayesOpt()
search_alg = search_algorithm.RandomSearch()
search_alg = search_algorithm.GridSearch()

-- Example 14759
search_space = {
    "n_estimators": tune.uniform(50, 200),
    "max_depth": tune.uniform(3, 10),
    "learning_rate": tune.uniform(0.01, 0.3),
}

-- Example 14760
from snowflake.ml.modeling import tune
tuner_config = tune.TunerConfig(
  metric="accuracy",
  mode="max",
  search_alg=search_algorithm.BayesOpt(
      utility_kwargs={"kind": "ucb", "kappa": 2.5, "xi": 0.0}
  ),
  num_trials=5,
  max_concurrent_trials=1,
)

-- Example 14761
def train_func():
  tuner_context = get_tuner_context()
  config = tuner_context.get_hyper_params()
  dm = tuner_context.get_dataset_map()
  ...
  tuner_context.report(metrics={"accuracy": accuracy}, model=model)

-- Example 14762
from snowflake.ml.modeling import tune
tuner = tune.Tuner(train_func, search_space, tuner_config)
tuner_results = tuner.run(dataset_map=dataset_map)

-- Example 14763
print(tuner_results.results)
print(tuner_results.best_model)
print(tuner_results.best_result)

-- Example 14764
from snowflake.ml.modeling.tune import Tuner

-- Example 14765
class Tuner:
  def __init__(
      self,
      train_func: Callable,
      search_space: SearchSpace,
      tuner_config: TunerConfig,
  )

  def run(
      self, dataset_map: Optional[Dict[str, DataConnector]] = None
  ) -> TunerResults

-- Example 14766
from entities.search_space import uniform, choice, loguniform, randint

-- Example 14767
def uniform(lower: float, upper: float)
    """
    Sample a float value uniformly between lower and upper.

    Use for parameters where all values in range are equally likely to be optimal.
    Examples: dropout rates (0.1 to 0.5), batch normalization momentum (0.1 to 0.9).
    """


def loguniform(lower: float, upper: float) -> float:
    """
    Sample a float value uniformly in log space between lower and upper.

    Use for parameters spanning several orders of magnitude.
    Examples: learning rates (1e-5 to 1e-1), regularization strengths (1e-4 to 1e-1).
    """


def randint(lower: int, upper: int) -> int:
    """
    Sample an integer value uniformly between lower(inclusive) and upper(exclusive).

    Use for discrete parameters with a range of values.
    Examples: number of layers, number of epochs, number of estimators.
    """



def choice(options: List[Union[float, int, str]]) -> Union[float, int, str]:
    """
    Sample a value uniformly from the given options.

    Use for categorical parameters or discrete options.
    Examples: activation functions ['relu', 'tanh', 'sigmoid']
    """

-- Example 14768
from snowflake.ml.modeling.tune import TunerConfig

-- Example 14769
class TunerConfig:
  """
  Configuration class for the tuning process.

  Attributes:
    metric (str): The name of the metric to optimize. This should correspond
        to a key in the metrics dictionary reported by the training function.

    mode (str): The optimization mode for the metric. Must be either "min"
        for minimization or "max" for maximization.

    search_alg (SearchAlgorithm): The search algorithm to use for
        exploring the hyperparameter space. Defaults to random search.

    num_trials (int): The maximum number of parameter configurations to
        try. Defaults to 5

    max_concurrent_trials (Optional[int]): The maximum number of concurrently running trials per node. If   not specified, it defaults to the total number of nodes in the cluster. This value must be a positive
    integer if provided.


  Example:
      >>> from entities import search_algorithm        >>> from snowflake.ml.modeling.tune import  TunerConfig
      >>> config = TunerConfig(
      ...     metric="accuracy",
      ...     mode="max",
      ...     num_trials=5,
      ...     max_concurrent_trials=1
      ... )
  """

-- Example 14770
from entities.search_algorithm import BayesOpt, RandomSearch, GridSearch

-- Example 14771
@dataclass
class BayesOpt():
    """
    Bayesian Optimization class that encapsulates parameters for the acquisition function.

    This class is designed to facilitate Bayesian optimization by configuring
    the acquisition function through a dictionary of keyword arguments.

    Attributes:
        utility_kwargs (Optional[Dict[str, Any]]):
            A dictionary specifying parameters for the utility (acquisition) function.
            If not provided, it defaults to:
                {
                    'kind': 'ucb',   # Upper Confidence Bound acquisition strategy
                    'kappa': 2.576,  # Exploration parameter for UCB
                    'xi': 0.0      # Exploitation parameter
                }
    """
    utility_kwargs: Optional[Dict[str, Any]] = None

-- Example 14772
@dataclass
class RandomSearch():
    The default and most basic way to do hyperparameter search is via random search.

    Attributes:
Seed or NumPy random generator for reproducible results. If set to None (default), the global generator (np.random) is used.
    random_state: Optional[int] = None

-- Example 14773
from entities.tuner_results import TunerResults

-- Example 14774
@dataclass
class TunerResults:
    results: pd.DataFrame
    best_result: pd.DataFrame
    best_model: Optional[Any]

-- Example 14775
from snowflake.ml.modeling.tune import get_tuner_context

-- Example 14776
class TunerContext:
    """
    A centralized context class for managing trial configuration, reporting, and dataset information.
    """

    def get_hyper_params(self) -> Dict[str, Any]:
        """
        Retrieve the configuration dictionary.

        Returns:
            Dict[str, Any]: The configuration dictionary for the trial.
        """
        return self._hyper_params

    def report(self, metrics: Dict[str, Any], model: Optional[Any] = None) -> None:
    """
    Report metrics and optionally the model if provided.

    This method is used to report the performance metrics of a model and, if provided, the model itself.
    The reported metrics will be used to guide the next set of hyperparameters selection in the
    optimization process.

    Args:
        metrics (Dict[str, Any]): A dictionary containing the performance metrics of the model.
            The keys are metric names, and the values are the corresponding metric values.
        model (Optional[Any], optional): The trained model to be reported. Defaults to None.

    Returns:
        None: This method doesn't return anything.
    """

    def get_dataset_map(self) -> Optional[Dict[str, Type[DataConnector]]]:
        """
        Retrieve the dataset mapping.

        Returns:
            Optional[Dict[str, Type[DataConnector]]]: A mapping of dataset names to DataConnector types, if available.
        """
        return self._dataset_map

-- Example 14777
import fsspec
from snowflake.ml.fileset import sfcfs

sf_fs1 = sfcfs.SFFileSystem(sf_connection=sf_connection)

-- Example 14778
import fsspec
from snowflake.ml.fileset import sfcfs

sf_fs2 = sfcfs.SFFileSystem(snowpark_session=sp_session)

-- Example 14779
local_cache_path = "/tmp/sf_files/"
cached_fs = fsspec.filesystem("cached", target_protocol="sfc",
                    target_options={"sf_connection": sf_connection,
                                    "cache_types": "bytes",
                                    "block_size": 32 * 2**20},
                    cache_storage=local_cache_path)

-- Example 14780
print(*cached_fs.ls("@ML_DATASETS.public.my_models/sales_predict/"), end='\n')

-- Example 14781
path = '@ML_DATASETS.public.my_models/test/data_7_7_3.snappy.parquet'

with sf_fs1.open(path, mode='rb') as f:
    print(f.read(16))

-- Example 14782
import pyarrow.parquet as pq

table = pq.read_table(path, filesystem=sf_fs1)
table.take([1, 3])

-- Example 14783
path = "sfc://@ML_DATASETS.public.my_models/dataset.csv.gz"

with cached_fs.open(path, mode='rb', sf_connection=sf_connection) as f:
    g = gzip.GzipFile(fileobj=f)
    for i in range(3):
        print(g.readline())

-- Example 14784
# Snowpark Python equivalent of "SELECT * FROM MYDATA LIMIT 5000000"
df = snowpark_session.table('mydata').limit(5000000)
fileset_df = fileset.FileSet.make(
    target_stage_loc="@ML_DATASETS.public.my_models/",
    name="from_dataframe",
    snowpark_dataframe=df,
    shuffle=True,
)

-- Example 14785
fileset_sf = fileset.FileSet.make(
    target_stage_loc="@ML_DATASETS.public.my_models/",
    name="from_connector",
    sf_connection=sf_connection,
    query="SELECT * FROM MYDATA LIMIT 5000000",
    shuffle=True,           # see later section about shuffling
)

-- Example 14786
print(*fileset_df.files())

