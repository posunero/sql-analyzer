-- Example 27981
from snowflake.snowpark import Session
connection_parameters = {
  "account": "<your snowflake account>",
  "user": "<your snowflake user>",
  "role":"<your snowflake role>",
  "database":"<your snowflake database>",
  "schema":"<your snowflake schema",
  "warehouse":"<your snowflake warehouse>",
  "authenticator":"externalbrowser"
}
session = Session.builder.configs(connection_parameters).create()

-- Example 27982
new_session.close()

-- Example 27983
def my_g(x):
    return x ** 3, (3 * x ** 2).mean(axis=-1)

-- Example 27984
n_components == min(n_samples, n_features)

-- Example 27985
n_components == min(n_samples, n_features) - 1

-- Example 27986
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27987
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27988
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27989
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27990
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27991
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 27992
def optimizer(obj_func, initial_theta, bounds):
    # * 'obj_func' is the objective function to be maximized, which
    #   takes the hyperparameters theta as parameter and an
    #   optional flag eval_gradient, which determines if the
    #   gradient is returned additionally to the function value
    # * 'initial_theta': the initial value for theta, which can be
    #   used by local optimizers
    # * 'bounds': the bounds on the values of theta
    ....
    # Returned are the best found hyperparameters theta and
    # the corresponding value of the target function.
    return theta_opt, func_min

-- Example 27993
'fmin_l_bfgs_b'

-- Example 27994
def optimizer(obj_func, initial_theta, bounds):
    # * 'obj_func': the objective function to be minimized, which
    #   takes the hyperparameters theta as a parameter and an
    #   optional flag eval_gradient, which determines if the
    #   gradient is returned additionally to the function value
    # * 'initial_theta': the initial value for theta, which can be
    #   used by local optimizers
    # * 'bounds': the bounds on the values of theta
    ....
    # Returned are the best found hyperparameters theta and
    # the corresponding value of the target function.
    return theta_opt, func_min

-- Example 27995
N >= log(1 - probability) / log(1 - e**m)

-- Example 27996
'auto': use 'svd' if n_samples > n_features, otherwise use 'eigen'
'svd': force use of singular value decomposition of X when X is
    dense, eigenvalue decomposition of X^T.X when X is sparse.
'eigen': force computation via eigendecomposition of X.X^T

-- Example 27997
F1 = 2 * (precision * recall) / (precision + recall)

-- Example 27998
'full' (each component has its own general covariance matrix),
'tied' (all components share the same general covariance matrix),
'diag' (each component has its own diagonal covariance matrix),
'spherical' (each component has its own single variance).

-- Example 27999
(n_features, n_features) if 'full',
(n_features, n_features) if 'tied',
(n_features)             if 'diag',
float                    if 'spherical'

-- Example 28000
(n_components,)                        if 'spherical',
(n_features, n_features)               if 'tied',
(n_components, n_features)             if 'diag',
(n_components, n_features, n_features) if 'full'

-- Example 28001
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 28002
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 28003
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 28004
N_t / N * (impurity - N_t_R / N_t * right_impurity
                    - N_t_L / N_t * left_impurity)

-- Example 28005
# Load from Snowpark Dataframe
df = session.table("TRAIN_DATA_TABLE")
train_data = ShardedDataConnector.from_dataframe(df)

# Pass to pytorch trainer to retrieve shard in training function.
def train_func():
    dataset_map = context.get_dataset_map()
    training_data = dataset_map["train"].get_shard().to_torch_dataset()

pytroch_trainer = PyTorchTrainer(
    train_func=train_func,
)

pytroch_trainer.run(
    dataset_map=dict(
        train=train_data
    )
)

-- Example 28006
>>> fs = FeatureStore(...)
>>> # draft_fv is a local object that hasn't materiaized to Snowflake backend yet.
>>> feature_df = session.sql("select f_1, f_2 from source_table")
>>> draft_fv = FeatureView(
...     name="my_fv",
...     entities=[e1, e2],
...     feature_df=feature_df,
...     timestamp_col='TS', # optional
...     refresh_freq='1d',  # optional
...     desc='A line about this feature view',  # optional
...     warehouse='WH'      # optional, the warehouse used to refresh (managed) feature view
... )
>>> print(draft_fv.status)
FeatureViewStatus.DRAFT

>>> # registered_fv is a local object that maps to a Snowflake backend object.
>>> registered_fv = fs.register_feature_view(draft_fv, "v1")
>>> print(registered_fv.status)
FeatureViewStatus.ACTIVE

-- Example 28007
>>> fs = FeatureStore(...)
>>> e = fs.get_entity('TRIP_ID')
>>> feature_df = session.table(source_table).select('TRIPDURATION', 'START_STATION_LATITUDE', 'TRIP_ID')
>>> draft_fv = FeatureView(name='F_TRIP', entities=[e], feature_df=feature_df)
>>> draft_fv = draft_fv.attach_feature_desc({
...     "TRIPDURATION": "Duration of a trip.",
...     "START_STATION_LATITUDE": "Latitude of the start station."
... })
>>> registered_fv = fs.register_feature_view(draft_fv, version='1.0')
>>> registered_fv.feature_descs
OrderedDict([('TRIPDURATION', 'Duration of a trip.'),
    ('START_STATION_LATITUDE', 'Latitude of the start station.')])

-- Example 28008
>>> fs = FeatureStore(...)
>>> e = fs.get_entity('TRIP_ID')
>>> feature_df = session.table(source_table).select(
...     'TRIPDURATION',
...     'START_STATION_LATITUDE',
...     'TRIP_ID'
... )
>>> darft_fv = FeatureView(name='F_TRIP', entities=[e], feature_df=feature_df)
>>> registered_fv = fs.register_feature_view(darft_fv, version='1.0')
>>> registered_fv.fully_qualified_name()
'MY_DB.MY_SCHEMA."F_TRIP$1.0"'

-- Example 28009
>>> fs = FeatureStore(...)
>>> e = Entity("foo", ["id"], desc='my entity')
>>> fs.register_entity(e)

>>> draft_fv = FeatureView(
...     name="fv",
...     entities=[e],
...     feature_df=self._session.table(<source_table>).select(["NAME", "ID", "TITLE", "AGE", "TS"]),
...     timestamp_col="ts",
>>> ).attach_feature_desc({"AGE": "my age", "TITLE": '"my title"'})
>>> fv = fs.register_feature_view(draft_fv, '1.0')

>>> fv.list_columns().show()
--------------------------------------------------
|"NAME"  |"CATEGORY"  |"DTYPE"      |"DESC"      |
--------------------------------------------------
|NAME    |FEATURE     |string(64)   |            |
|ID      |ENTITY      |bigint       |my entity   |
|TITLE   |FEATURE     |string(128)  |"my title"  |
|AGE     |FEATURE     |bigint       |my age      |
|TS      |TIMESTAMP   |bigint       |NULL        |
--------------------------------------------------

-- Example 28010
>>> fs = FeatureStore(...)
>>> e = fs.get_entity('TRIP_ID')
>>> # feature_df contains 3 features and 1 entity
>>> feature_df = session.table(source_table).select(
...     'TRIPDURATION',
...     'START_STATION_LATITUDE',
...     'END_STATION_LONGITUDE',
...     'TRIP_ID'
... )
>>> darft_fv = FeatureView(name='F_TRIP', entities=[e], feature_df=feature_df)
>>> fv = fs.register_feature_view(darft_fv, version='1.0')
>>> # shows all 3 features
>>> fv.feature_names
['TRIPDURATION', 'START_STATION_LATITUDE', 'END_STATION_LONGITUDE']

>>> # slice a subset of features
>>> fv_slice = fv.slice(['TRIPDURATION', 'START_STATION_LATITUDE'])
>>> fv_slice.names
['TRIPDURATION', 'START_STATION_LATITUDE']

>>> # query the full set of features in original feature view
>>> fv_slice.feature_view_ref.feature_names
['TRIPDURATION', 'START_STATION_LATITUDE', 'END_STATION_LONGITUDE']

-- Example 28011
>>> fs = FeatureStore(...)
>>> e = Entity("foo", ["id"], desc='my entity')
>>> fs.register_entity(e)

>>> draft_fv = FeatureView(
...     name="fv",
...     entities=[e],
...     feature_df=self._session.table(<source_table>).select(["NAME", "ID", "TITLE", "AGE", "TS"]),
...     timestamp_col="ts",
>>> ).attach_feature_desc({"AGE": "my age", "TITLE": '"my title"'})
>>> fv = fs.register_feature_view(draft_fv, '1.0')

>>> fv.to_df().show()
----------------------------------------------------------------...
|"NAME"  |"ENTITIES"                |"TIMESTAMP_COL"  |"DESC"  |
----------------------------------------------------------------...
|FV      |[                         |TS               |foobar  |
|        |  {                       |                 |        |
|        |    "desc": "my entity",  |                 |        |
|        |    "join_keys": [        |                 |        |
|        |      "ID"                |                 |        |
|        |    ],                    |                 |        |
|        |    "name": "FOO",        |                 |        |
|        |    "owner": null         |                 |        |
|        |  }                       |                 |        |
|        |]                         |                 |        |
----------------------------------------------------------------...

-- Example 28012
GET internalStage file://<local_directory_path>
    [ PARALLEL = <integer> ]
    [ PATTERN = '<regex_pattern>'' ]

-- Example 28013
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 28014
GET @my_int_stage my_target_path PATTERN = "tmp.parquet";

-- Example 28015
GET @%mytable file:///tmp/data/;

-- Example 28016
GET @~/myfiles file:///tmp/data/;

-- Example 28017
from snowflake.ml.feature_store import FeatureView

managed_fv = FeatureView(
    name="MY_MANAGED_FV",
    entities=[entity],
    feature_df=my_df,                   # Snowpark DataFrame containing feature transformations
    timestamp_col="ts",                 # optional timestamp column name in the dataframe
    refresh_freq="5 minutes",           # how often feature data refreshes
    desc="my managed feature view"      # optional description
)

-- Example 28018
external_fv = FeatureView(
    name="MY_EXTERNAL_FV",
    entities=[entity],
    feature_df=my_df,                   # Snowpark DataFrame referencing the feature table
    timestamp_col="ts",                 # optional timestamp column name in the dataframe
    refresh_freq=None,                  # None means the feature view is external
    desc="my external feature view"     # optional description
)

-- Example 28019
external_fv = external_fv.attach_feature_desc(
    {
        "SENDERID": "Sender account ID for the transaction",
        "RECEIVERID": "Receiver account ID for the transaction",
        "IBAN": "International Bank Identifier for the receiver bank",
        "AMOUNT": "Amount of the transaction"
    }
)

-- Example 28020
registered_fv: FeatureView = fs.register_feature_view(
    feature_view=managed_fv,    # feature view created above, could also use external_fv
    version="1",
    block=True,         # whether function call blocks until initial data is available
    overwrite=False,    # whether to replace existing feature view with same name/version
)

-- Example 28021
retrieved_fv: FeatureView = fs.get_feature_view(
    name="MY_MANAGED_FV",
    version="1"
)

-- Example 28022
fs.list_feature_views(
    entity_name="<entity_name>",                # optional
    feature_view_name="<feature_view_name>",    # optional
).show()

-- Example 28023
fs.update_feature_view(
    name="<name>",
    version="<version>",
    refresh_freq="<new_fresh_freq>",    # optional
    warehouse="<new_warehouse>",        # optional
    desc="<new_description>",           # optional
)

-- Example 28024
fs.delete_feature_view(
    feature_view="<name>",
    version="<version>",
)

-- Example 28025
>>> fs = FeatureStore(...)
>>> e_1 = Entity(
...     name="my_entity",
...     join_keys=['col_1'],
...     desc='My first entity.'
... )
>>> fs.register_entity(e_1)
>>> fs.list_entities().show()
-----------------------------------------------------------
|"NAME"     |"JOIN_KEYS"  |"DESC"            |"OWNER"     |
-----------------------------------------------------------
|MY_ENTITY  |["COL_1"]    |My first entity.  |REGTEST_RL  |
-----------------------------------------------------------

-- Example 28026
>>> from snowflake.ml.feature_store import (
...     FeatureStore,
...     CreationMode,
... )

>>> # Create a new Feature Store:
>>> fs = FeatureStore(
...     session=session,
...     database="MYDB",
...     name="MYSCHEMA",
...     default_warehouse="MYWH",
...     creation_mode=CreationMode.CREATE_IF_NOT_EXIST
... )

>>> # Connect to an existing Feature Store:
>>> fs = FeatureStore(
...     session=session,
...     database="MYDB",
...     name="MYSCHEMA",
...     default_warehouse="MYWH",
...     creation_mode=CreationMode.FAIL_IF_NOT_EXIST
... )

-- Example 28027
>>> fs = FeatureStore(...)
>>> e_1 = Entity("my_entity", ['col_1'], desc='My first entity.')
>>> fs.register_entity(e_1)
>>> fs.list_entities().show()
-----------------------------------------------------------
|"NAME"     |"JOIN_KEYS"  |"DESC"            |"OWNER"     |
-----------------------------------------------------------
|MY_ENTITY  |["COL_1"]    |My first entity.  |REGTEST_RL  |
-----------------------------------------------------------

>>> fs.delete_entity("my_entity")
>>> fs.list_entities().show()
-------------------------------------------
|"NAME"  |"JOIN_KEYS"  |"DESC"  |"OWNER"  |
-------------------------------------------
|        |             |        |         |
-------------------------------------------

-- Example 28028
>>> fs = FeatureStore(...)
>>> fv = FeatureView('FV0', ...)
>>> fv1 = fs.register_feature_view(fv, 'FIRST')
>>> fv2 = fs.register_feature_view(fv, 'SECOND')
>>> fs.list_feature_views().select('NAME', 'VERSION').show()
----------------------
|"NAME"  |"VERSION"  |
----------------------
|FV0     |SECOND     |
|FV0     |FIRST      |
----------------------

>>> # delete with name and version
>>> fs.delete_feature_view('FV0', 'FIRST')
>>> fs.list_feature_views().select('NAME', 'VERSION').show()
----------------------
|"NAME"  |"VERSION"  |
----------------------
|FV0     |SECOND     |
----------------------

>>> # delete with feature view object
>>> fs.delete_feature_view(fv2)
>>> fs.list_feature_views().select('NAME', 'VERSION').show()
----------------------
|"NAME"  |"VERSION"  |
----------------------
|        |           |
----------------------

-- Example 28029
>>> fs = FeatureStore(session, ...)
>>> # Assume you already have feature view registered.
>>> fv = fs.get_feature_view("MY_FV", "1")
>>> # Spine dataframe has same join keys as the entity of fv.
>>> spine_df = session.create_dataframe(["1", "2"], schema=["id"])
>>> my_dataset = fs.generate_dataset(
...     "my_dataset"
...     spine_df,
...     [fv],
... )
>>> # Current timestamp will be used as default version name.
>>> # You can explicitly overwrite by setting a version.
>>> my_dataset.list_versions()
['2024_07_12_11_26_22']

>>> my_dataset.read.to_snowpark_dataframe().show(n=3)
-------------------------------------------------------
|"QUALITY"  |"FIXED_ACIDITY"     |"VOLATILE_ACIDITY"  |
-------------------------------------------------------
|3          |11.600000381469727  |0.5799999833106995  |
|3          |8.300000190734863   |1.0199999809265137  |
|3          |7.400000095367432   |1.184999942779541   |
-------------------------------------------------------

-- Example 28030
>>> fs = FeatureStore(session, ...)
>>> # Assume you already have feature view registered.
>>> fv = fs.get_feature_view("MY_FV", "1")
>>> # Spine dataframe has same join keys as the entity of fv.
>>> spine_df = session.create_dataframe(["1", "2"], schema=["id"])
>>> training_set = fs.generate_training_set(
...     spine_df,
...     [fv],
...     save_as="my_training_set",
... )
>>> print(type(training_set))
<class 'snowflake.snowpark.table.Table'>

>>> print(training_set.queries)
{'queries': ['SELECT  *  FROM (my_training_set)'], 'post_actions': []}

-- Example 28031
>>> fs = FeatureStore(...)
>>> # e_1 is a local object that hasn't registered to Snowflake backend yet.
>>> e_1 = Entity("my_entity", ['col_1'], desc='My first entity.')
>>> fs.register_entity(e_1)

>>> # e_2 is a local object that points a backend object in Snowflake.
>>> e_2 = fs.get_entity("my_entity")
>>> print(e_2)
Entity(name=MY_ENTITY, join_keys=['COL_1'], owner=REGTEST_RL, desc=My first entity.)

-- Example 28032
>>> fs = FeatureStore(...)
>>> # draft_fv is a local object that hasn't materiaized to Snowflake backend yet.
>>> draft_fv = FeatureView(
...     name='foo',
...     entities=[e1],
...     feature_df=session.sql('...'),
...     desc='this is description',
... )
>>> fs.register_feature_view(feature_view=draft_fv, version='v1')

>>> # fv is a local object that maps to a Snowflake backend object.
>>> fv = fs.get_feature_view('foo', 'v1')
>>> print(f"name: {fv.name}")
>>> print(f"version:{fv.version}")
>>> print(f"desc:{fv.desc}")
name: FOO
version:v1
desc:this is description

-- Example 28033
>>> fs = FeatureStore(...)
>>> fv = fs.get_feature_view(name='MY_FV', version='v1')
>>> # refresh with name and version
>>> fs.refresh_feature_view('MY_FV', 'v1')
>>> fs.get_refresh_history('MY_FV', 'v1').show()
-----------------------------------------------------------------------------------------------------
|"NAME"    |"STATE"    |"REFRESH_START_TIME"        |"REFRESH_END_TIME"          |"REFRESH_ACTION"  |
-----------------------------------------------------------------------------------------------------
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:53:58.504000  |2024-07-10 14:53:59.088000  |INCREMENTAL       |
-----------------------------------------------------------------------------------------------------

>>> # refresh with feature view object
>>> fs.refresh_feature_view(fv)
>>> fs.get_refresh_history(fv).show()
-----------------------------------------------------------------------------------------------------
|"NAME"    |"STATE"    |"REFRESH_START_TIME"        |"REFRESH_END_TIME"          |"REFRESH_ACTION"  |
-----------------------------------------------------------------------------------------------------
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:54:06.680000  |2024-07-10 14:54:07.226000  |INCREMENTAL       |
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:53:58.504000  |2024-07-10 14:53:59.088000  |INCREMENTAL       |
-----------------------------------------------------------------------------------------------------

-- Example 28034
>>> fs = FeatureStore(...)
>>> e_1 = Entity("my_entity", ['col_1'], desc='My first entity.')
>>> fs.register_entity(e_1)
>>> fs.list_entities().show()
-----------------------------------------------------------
|"NAME"     |"JOIN_KEYS"  |"DESC"            |"OWNER"     |
-----------------------------------------------------------
|MY_ENTITY  |["COL_1"]    |My first entity.  |REGTEST_RL  |
-----------------------------------------------------------

-- Example 28035
>>> fs = FeatureStore(...)
>>> draft_fv = FeatureView(
...     name='foo',
...     entities=[e1, e2],
...     feature_df=session.sql('...'),
...     desc='this is description',
... )
>>> fs.register_feature_view(feature_view=draft_fv, version='v1')
>>> fs.list_feature_views().select("name", "version", "desc").show()
--------------------------------------------
|"NAME"  |"VERSION"  |"DESC"               |
--------------------------------------------
|FOO     |v1         |this is description  |
--------------------------------------------

-- Example 28036
>>> fs = FeatureStore(session, ...)
>>> # Assume you already have feature view registered.
>>> fv = fs.get_feature_view("MY_FV", "1.0")
>>> # Spine dataframe has same join keys as the entity of fv.
>>> spine_df = session.create_dataframe(["1", "2"], schema=["id"])
>>> my_dataset = fs.generate_dataset(
...     "my_dataset"
...     spine_df,
...     [fv],
... )
>>> fvs = fs.load_feature_views_from_dataset(my_dataset)
>>> print(len(fvs))
1

>>> print(type(fvs[0]))
<class 'snowflake.ml.feature_store.feature_view.FeatureView'>

>>> print(fvs[0].name)
MY_FV

>>> print(fvs[0].version)
1.0

-- Example 28037
>>> fs = FeatureStore(...)
>>> # Read from feature view name and version.
>>> fs.read_feature_view('foo', 'v1').show()
------------------------------------------
|"NAME"  |"ID"  |"TITLE"  |"AGE"  |"TS"  |
------------------------------------------
|jonh    |1     |boss     |20     |100   |
|porter  |2     |manager  |30     |200   |
------------------------------------------

>>> # Read from feature view object.
>>> fv = fs.get_feature_view('foo', 'v1')
>>> fs.read_feature_view(fv).show()
------------------------------------------
|"NAME"  |"ID"  |"TITLE"  |"AGE"  |"TS"  |
------------------------------------------
|jonh    |1     |boss     |20     |100   |
|porter  |2     |manager  |30     |200   |
------------------------------------------

-- Example 28038
>>> fs = FeatureStore(...)
>>> fv = fs.get_feature_view(name='MY_FV', version='v1')

>>> # refresh with name and version
>>> fs.refresh_feature_view('MY_FV', 'v1')
>>> fs.get_refresh_history('MY_FV', 'v1').show()
-----------------------------------------------------------------------------------------------------
|"NAME"    |"STATE"    |"REFRESH_START_TIME"        |"REFRESH_END_TIME"          |"REFRESH_ACTION"  |
-----------------------------------------------------------------------------------------------------
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:53:58.504000  |2024-07-10 14:53:59.088000  |INCREMENTAL       |
-----------------------------------------------------------------------------------------------------

>>> # refresh with feature view object
>>> fs.refresh_feature_view(fv)
>>> fs.get_refresh_history(fv).show()
-----------------------------------------------------------------------------------------------------
|"NAME"    |"STATE"    |"REFRESH_START_TIME"        |"REFRESH_END_TIME"          |"REFRESH_ACTION"  |
-----------------------------------------------------------------------------------------------------
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:54:06.680000  |2024-07-10 14:54:07.226000  |INCREMENTAL       |
|MY_FV$v1  |SUCCEEDED  |2024-07-10 14:53:58.504000  |2024-07-10 14:53:59.088000  |INCREMENTAL       |
-----------------------------------------------------------------------------------------------------

-- Example 28039
>>> fs = FeatureStore(...)
>>> e = Entity('BAR', ['A'], desc='entity bar')
>>> fs.register_entity(e)
>>> fs.list_entities().show()
--------------------------------------------------
|"NAME"  |"JOIN_KEYS"  |"DESC"      |"OWNER"     |
--------------------------------------------------
|BAR     |["A"]        |entity bar  |REGTEST_RL  |
--------------------------------------------------

-- Example 28040
>>> fs = FeatureStore(...)
>>> # draft_fv is a local object that hasn't materiaized to Snowflake backend yet.
>>> feature_df = session.sql("select f_1, f_2 from source_table")
>>> draft_fv = FeatureView("my_fv", [entities], feature_df)
>>> print(draft_fv.status)
FeatureViewStatus.DRAFT

>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|        |           |                    |
-------------------------------------------

>>> # registered_fv is a local object that maps to a Snowflake backend object.
>>> registered_fv = fs.register_feature_view(draft_fv, "v1")
>>> print(registered_fv.status)
FeatureViewStatus.ACTIVE

>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|MY_FV   |v1         |ACTIVE              |
-------------------------------------------

-- Example 28041
>>> fs = FeatureStore(...)
>>> # you must already have feature views registered
>>> fv = fs.get_feature_view(name='MY_FV', version='v1')
>>> fs.suspend_feature_view('MY_FV', 'v1')
>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|MY_FV   |v1         |SUSPENDED           |
-------------------------------------------

>>> fs.resume_feature_view('MY_FV', 'v1')
>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|MY_FV   |v1         |ACTIVE              |
-------------------------------------------

-- Example 28042
>>> fs = FeatureStore(...)
>>> # Assume you already have feature view registered.
>>> fv = fs.get_feature_view('my_fv', 'v1')
>>> # Spine dataframe has same join keys as the entity of fv.
>>> spine_df = session.create_dataframe(["1", "2"], schema=["id"])
>>> fs.retrieve_feature_values(spine_df, [fv]).show()
--------------------
|"END_STATION_ID"  |
--------------------
|505               |
|347               |
|466               |
--------------------

-- Example 28043
>>> fs = FeatureStore(...)
>>> # assume you already have feature views registered
>>> fv = fs.get_feature_view(name='MY_FV', version='v1')
>>> fs.suspend_feature_view('MY_FV', 'v1')
>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|MY_FV   |v1         |SUSPENDED           |
-------------------------------------------

>>> fs.resume_feature_view('MY_FV', 'v1')
>>> fs.list_feature_views().select("NAME", "VERSION", "SCHEDULING_STATE").show()
-------------------------------------------
|"NAME"  |"VERSION"  |"SCHEDULING_STATE"  |
-------------------------------------------
|MY_FV   |v1         |ACTIVE              |
-------------------------------------------

-- Example 28044
>>> fs = FeatureStore(...)
>>> fs.update_default_warehouse("MYWH_2")
>>> draft_fv = FeatureView("my_fv", ...)
>>> registered_fv = fs.register_feature_view(draft_fv, '2.0')
>>> print(registered_fv.warehouse)
MYWH_2

-- Example 28045
>>> fs = FeatureStore(...)

>>> e = Entity(name='foo', join_keys=['COL_1'], desc='old desc')
>>> fs.list_entities().show()
------------------------------------------------
|"NAME"  |"JOIN_KEYS"  |"DESC"    |"OWNER"     |
------------------------------------------------
|FOO     |["COL_1"]    |old desc  |REGTEST_RL  |
------------------------------------------------

>>> fs.update_entity('foo', desc='NEW DESC')
>>> fs.list_entities().show()
------------------------------------------------
|"NAME"  |"JOIN_KEYS"  |"DESC"    |"OWNER"     |
------------------------------------------------
|FOO     |["COL_1"]    |NEW DESC  |REGTEST_RL  |
------------------------------------------------

-- Example 28046
>>> fs = FeatureStore(...)
>>> fv = FeatureView(
...     name='foo',
...     entities=[e1, e2],
...     feature_df=session.sql('...'),
...     desc='this is old description',
... )
>>> fv = fs.register_feature_view(feature_view=fv, version='v1')
>>> fs.list_feature_views().select("name", "version", "desc").show()
------------------------------------------------
|"NAME"  |"VERSION"  |"DESC"                   |
------------------------------------------------
|FOO     |v1         |this is old description  |
------------------------------------------------

>>> # update_feature_view will apply new arguments to the registered feature view.
>>> new_fv = fs.update_feature_view(
...     name='foo',
...     version='v1',
...     desc='that is new descption',
... )
>>> fs.list_feature_views().select("name", "version", "desc").show()
------------------------------------------------
|"NAME"  |"VERSION"  |"DESC"                   |
------------------------------------------------
|FOO     |v1         |THAT IS NEW DESCRIPTION  |
------------------------------------------------

-- Example 28047
>>> fs = FeatureStore(...)
>>> # draft_fv is a local object that hasn't materiaized to Snowflake backend yet.
>>> feature_df = session.sql("select f_1, f_2 from source_table")
>>> draft_fv = FeatureView(
...     name="my_fv",
...     entities=[e1, e2],
...     feature_df=feature_df,
...     timestamp_col='TS', # optional
...     refresh_freq='1d',  # optional
...     desc='A line about this feature view',  # optional
...     warehouse='WH'      # optional, the warehouse used to refresh (managed) feature view
... )
>>> print(draft_fv.status)
FeatureViewStatus.DRAFT

>>> # registered_fv is a local object that maps to a Snowflake backend object.
>>> registered_fv = fs.register_feature_view(draft_fv, "v1")
>>> print(registered_fv.status)
FeatureViewStatus.ACTIVE

