-- Example 28048
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

-- Example 28049
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

-- Example 28050
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

-- Example 28051
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

-- Example 28052
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

-- Example 28053
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

-- Example 28054
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

-- Example 28055
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

-- Example 28056
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

-- Example 28057
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

-- Example 28058
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

-- Example 28059
>>> fs = FeatureStore(...)
>>> # e_1 is a local object that hasn't registered to Snowflake backend yet.
>>> e_1 = Entity("my_entity", ['col_1'], desc='My first entity.')
>>> fs.register_entity(e_1)

>>> # e_2 is a local object that points a backend object in Snowflake.
>>> e_2 = fs.get_entity("my_entity")
>>> print(e_2)
Entity(name=MY_ENTITY, join_keys=['COL_1'], owner=REGTEST_RL, desc=My first entity.)

-- Example 28060
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

-- Example 28061
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

-- Example 28062
>>> fs = FeatureStore(...)
>>> e_1 = Entity("my_entity", ['col_1'], desc='My first entity.')
>>> fs.register_entity(e_1)
>>> fs.list_entities().show()
-----------------------------------------------------------
|"NAME"     |"JOIN_KEYS"  |"DESC"            |"OWNER"     |
-----------------------------------------------------------
|MY_ENTITY  |["COL_1"]    |My first entity.  |REGTEST_RL  |
-----------------------------------------------------------

-- Example 28063
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

-- Example 28064
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

-- Example 28065
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

-- Example 28066
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

-- Example 28067
>>> fs = FeatureStore(...)
>>> e = Entity('BAR', ['A'], desc='entity bar')
>>> fs.register_entity(e)
>>> fs.list_entities().show()
--------------------------------------------------
|"NAME"  |"JOIN_KEYS"  |"DESC"      |"OWNER"     |
--------------------------------------------------
|BAR     |["A"]        |entity bar  |REGTEST_RL  |
--------------------------------------------------

-- Example 28068
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

-- Example 28069
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

-- Example 28070
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

-- Example 28071
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

-- Example 28072
>>> fs = FeatureStore(...)
>>> fs.update_default_warehouse("MYWH_2")
>>> draft_fv = FeatureView("my_fv", ...)
>>> registered_fv = fs.register_feature_view(draft_fv, '2.0')
>>> print(registered_fv.warehouse)
MYWH_2

-- Example 28073
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

-- Example 28074
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

-- Example 28075
>>> conn = snowflake.connector.connect(**connection_parameters)
>>> sffs = SFFileSystem(sf_connection=conn)
>>> sffs.ls("@MYDB.public.FOO/nytrain")
['@MYDB.public.FOO/nytrain/data_0_0_0.csv', '@MYDB.public.FOO/nytrain/data_0_0_1.csv']
>>> with sffs.open('@MYDB.public.FOO/nytrain/nytrain/data_0_0_1.csv', mode='rb') as f:
>>>     print(f.readline())
b'2014-02-05 14:35:00.00000054,13,2014-02-05 14:35:00 UTC,-74.00688,40.73049,-74.00563,40.70676,2

-- Example 28076
>>> conn = snowflake.connector.connect(**connection_parameters)
>>> sffs = fsspec.filesystem("sfc", sf_connection=conn)
>>> sffs.ls("@MYDB.public.FOO/nytrain")
['@MYDB.public.FOO/nytrain/data_0_0_0.csv', '@MYDB.public.FOO/nytrain/data_0_0_1.csv']
>>> with sffs.open('@MYDB.public.FOO/nytrain/nytrain/data_0_0_1.csv', mode='rb') as f:
>>>     print(f.readline())
b'2014-02-05 14:35:00.00000054,13,2014-02-05 14:35:00 UTC,-74.00688,40.73049,-74.00563,40.70676,2

-- Example 28077
>>> conn = snowflake.connector.connect(**connection_parameters)
>>> with fsspec.open("sfc://@MYDB.public.FOO/nytrain/data_0_0_1.csv", mode='rb', sf_connection=conn) as f:
>>>     print(f.readline())
b'2014-02-05 14:35:00.00000054,13,2014-02-05 14:35:00 UTC,-74.00688,40.73049,-74.00563,40.70676,2

-- Example 28078
>>> # Now we can restore the FileSet in another program as long as the FileSet is not deleted
>>> conn = snowflake.connector.connect(**connection_parameters)
>>> my_fileset_pointer = FileSet(sf_connection=conn,
                                 target_stage_loc="@mydb.mychema.mystage/mydir",
                                 name="helloworld")
>>> my_fileset.files()
----
['sfc://@mydb.myschema.mystage/mydir/helloworld/data_0_0_0.snappy.parquet']

-- Example 28079
>>> conn = snowflake.connector.connect(**connection_parameters)
>>> my_fileset = snowflake.ml.fileset.FileSet.make(
>>>     target_stage_loc="@mydb.mychema.mystage/mydir"
>>>     name="helloworld",
>>>     sf_connection=conn,
>>>     query="SELECT * FROM mytable limit 1000000",
>>> )
>>> my_fileset.files()
----
['sfc://@mydb.myschema.mystage/helloworld/data_0_0_0.snappy.parquet']

-- Example 28080
>>> new_session = snowflake.snowpark.Session.builder.configs(connection_parameters).create()
>>> df = new_session.sql("SELECT * FROM Mytable limit 1000000")
>>> my_fileset = snowflake.ml.fileset.FileSet.make(
>>>     target_stage_loc="@mydb.mychema.mystage/mydir"
>>>     name="helloworld",
>>>     snowpark_dataframe=df,
>>> )
>>> my_fileset.files()
----
['sfc://@mydb.myschema.mystage/helloworld/data_0_0_0.snappy.parquet']

-- Example 28081
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

-- Example 28082
cosign verify-blob snowflake_ml_python-1.7.0.tar.gz --key snowflake-ml-python-1.7.0.pub --signature resources.linux.snowflake_ml_python-1.7.0.tar.gz.sig

cosign verify-blob snowflake_ml_python-1.7.0.tar.gz --key snowflake-ml-python-1.7.0.pub --signature resources.linux.snowflake_ml_python-1.7.0

-- Example 28083
ModelSignature(
      inputs=[
          FeatureSpec(name="inputs", dtype=DataType.STRING),
      ],
      outputs=[
          FeatureSpec(name="outputs", dtype=DataType.STRING),
      ],
)

-- Example 28084
ModelSignature(
    inputs=[
        FeatureSpec(name="inputs", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureGroupSpec(
            name="outputs",
            specs=[
                FeatureSpec(name="sequence", dtype=DataType.STRING),
                FeatureSpec(name="score", dtype=DataType.DOUBLE),
                FeatureSpec(name="token", dtype=DataType.INT64),
                FeatureSpec(name="token_str", dtype=DataType.STRING),
            ],
            shape=(-1,),
        ),
    ],
)

-- Example 28085
ModelSignature(
    inputs=[
        FeatureSpec(name="inputs", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="outputs", dtype=DataType.STRING),
    ],
)

-- Example 28086
ModelSignature(
    inputs=[FeatureSpec(name="inputs", dtype=DataType.STRING)],
    outputs=[
        FeatureGroupSpec(
            name="outputs",
            specs=[
                FeatureSpec(name="word", dtype=DataType.STRING),
                FeatureSpec(name="score", dtype=DataType.DOUBLE),
                FeatureSpec(name="entity", dtype=DataType.STRING),
                FeatureSpec(name="index", dtype=DataType.INT64),
                FeatureSpec(name="start", dtype=DataType.INT64),
                FeatureSpec(name="end", dtype=DataType.INT64),
            ],
            shape=(-1,),
        ),
    ],
)

-- Example 28087
ModelSignature(
    inputs=[
        FeatureSpec(name="question", dtype=DataType.STRING),
        FeatureSpec(name="context", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="outputs", dtype=DataType.STRING),
    ],
)

-- Example 28088
ModelSignature(
    inputs=[
        FeatureSpec(name="question", dtype=DataType.STRING),
        FeatureSpec(name="context", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureGroupSpec(
            name="answers",
            specs=[
                FeatureSpec(name="score", dtype=DataType.DOUBLE),
                FeatureSpec(name="start", dtype=DataType.INT64),
                FeatureSpec(name="end", dtype=DataType.INT64),
                FeatureSpec(name="answer", dtype=DataType.STRING),
            ],
            shape=(-1,),
        ),
    ],
)

-- Example 28089
ModelSignature(
    inputs=[
        FeatureSpec(name="question", dtype=DataType.STRING),
        FeatureSpec(name="context", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="outputs", dtype=DataType.STRING),
    ],
)

-- Example 28090
ModelSignature(
    inputs=[
        FeatureSpec(name="question", dtype=DataType.STRING),
        FeatureSpec(name="context", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureGroupSpec(
            name="answers",
            specs=[
                FeatureSpec(name="score", dtype=DataType.DOUBLE),
                FeatureSpec(name="start", dtype=DataType.INT64),
                FeatureSpec(name="end", dtype=DataType.INT64),
                FeatureSpec(name="answer", dtype=DataType.STRING),
            ],
            shape=(-1,),
        ),
    ],
)

-- Example 28091
ModelSignature(
    inputs=[
        FeatureSpec(name="text", dtype=DataType.STRING),
        FeatureSpec(name="text_pair", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="label", dtype=DataType.STRING),
        FeatureSpec(name="score", dtype=DataType.DOUBLE),
    ],
)

-- Example 28092
ModelSignature(
    inputs=[
        FeatureSpec(name="text", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="label", dtype=DataType.STRING),
        FeatureSpec(name="score", dtype=DataType.DOUBLE),
    ],
)

-- Example 28093
ModelSignature(
    inputs=[
        FeatureSpec(name="text", dtype=DataType.STRING),
        FeatureSpec(name="text_pair", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureSpec(name="outputs", dtype=DataType.STRING),
    ],
)

-- Example 28094
ModelSignature(
    inputs=[
        FeatureSpec(name="text", dtype=DataType.STRING),
    ],
    outputs=[
        FeatureGroupSpec(
            name="labels",
            specs=[
                FeatureSpec(name="label", dtype=DataType.STRING),
                FeatureSpec(name="score", dtype=DataType.DOUBLE),
            ],
            shape=(-1,),
        ),
    ],
)

-- Example 28095
ModelSignature(
    inputs=[FeatureSpec(name="inputs", dtype=DataType.STRING)],
    outputs=[
        FeatureSpec(name="outputs", dtype=DataType.STRING),
    ],
)

-- Example 28096
ModelSignature(
    inputs=[
        FeatureGroupSpec(
            name="inputs",
            specs=[
                FeatureSpec(name="role", dtype=DataType.STRING),
                FeatureSpec(name="content", dtype=DataType.STRING),
            ],
            shape=(-1,),
        ),
    ],
    outputs=[
        FeatureGroupSpec(
            name="outputs",
            specs=[
                FeatureSpec(name="generated_text", dtype=DataType.STRING),
            ],
            shape=(-1,),
        )
    ],
)

-- Example 28097
import torch

class TorchModel(torch.nn.Module):
    def __init__(self, n_input: int, n_hidden: int, n_out: int, dtype: torch.dtype = torch.float32) -> None:
        super().__init__()
        self.model = torch.nn.Sequential(
            torch.nn.Linear(n_input, n_hidden, dtype=dtype),
            torch.nn.ReLU(),
            torch.nn.Linear(n_hidden, n_out, dtype=dtype),
            torch.nn.Sigmoid(),
        )

    def forward(self, tensor: torch.Tensor) -> torch.Tensor:
        return cast(torch.Tensor, self.model(tensor))

# Sample usage:
data_x = torch.rand(size=(batch_size, n_input))

# Log model with single tensor
reg.log_model(
    model=model,
    ...,
    sample_input_data=data_x
)

# Run inference with single tensor
mv.run(data_x)

-- Example 28098
reg.log_model(
    model=model,
    ...,
    sample_input_data=[data_x_1, data_x_2],
    options={"multiple_inputs": True}
)

-- Example 28099
cosign verify-blob snowflake_ml_python-1.7.0.tar.gz --key snowflake-ml-python-1.7.0.pub --signature resources.linux.snowflake_ml_python-1.7.0.tar.gz.sig

cosign verify-blob snowflake_ml_python-1.7.0.tar.gz --key snowflake-ml-python-1.7.0.pub --signature resources.linux.snowflake_ml_python-1.7.0

-- Example 28100
ds = connector.to_torch_dataset(shuffle=False, batch_size=3)

-- Example 28101
mc = custom_model.ModelContext(
    config = 'local_model_dir/config.json',
    m1 = model1
)

class ExamplePipelineModel(custom_model.CustomModel):
    def __init__(self, context: custom_model.ModelContext) -> None:
        super().__init__(context)
        v = open(self.context['config']).read()
        self.bias = json.loads(v)['bias']
    @custom_model.inference_api
    def predict(self, input: pd.DataFrame) -> pd.DataFrame:
        model_output = self.context['m1'].predict(input)
        return pd.DataFrame({'output': model_output + self.bias})

-- Example 28102
from snowflake.ml.modeling._internal.snowpark_implementations import ( distributed_hpo_trainer, )
distributed_hpo_trainer.ENABLE_EFFICIENT_MEMORY_USAGE = False

-- Example 28103
log_model(..., options={"target_methods": ["apply", ...]})

-- Example 28104
from snowflake.snowpark.context import get_active_session
session = get_active_session()

-- Example 28105
df = session.read.options({"infer_schema":True}).csv('@TASTYBYTE_STAGE/app_order.csv')

-- Example 28106
df = session.table("APP_ORDER")

-- Example 28107
df

-- Example 28108
import streamlit as st
import pandas as pd

-- Example 28109
species = ["setosa"] * 3 + ["versicolor"] * 3 + ["virginica"] * 3
measurements = ["sepal_length", "sepal_width", "petal_length"] * 3
values = [5.1, 3.5, 1.4, 6.2, 2.9, 4.3, 7.3, 3.0, 6.3]
df = pd.DataFrame({"species": species,"measurement": measurements,"value": values})
df

-- Example 28110
st.markdown("""# Interactive Filtering with Streamlit! :balloon:
            Values will automatically cascade down the notebook cells""")
value = st.slider("Move the slider to change the filter value 👇", df.value.min(), df.value.max(), df.value.mean(), step = 0.3 )

-- Example 28111
df[df["value"]>value].sort_values("value")

-- Example 28112
from snowflake.ml.registry import Registry
# Create a registry and log the model
native_registry = Registry(session=session, database_name=db, schema_name=schema)

# Let's first log the very first model we trained
model_ver = native_registry.log_model(
    model_name=model_name,
    version_name='V0',
    model=regressor,
    sample_input_data=X, # to provide the feature schema
)

# Add evaluation metric
model_ver.set_metric(metric_name="mean_abs_pct_err", value=mape)

# Add a description
model_ver.comment = "This is the first iteration of our Diamonds Price Prediction model. It is used for demo purposes."

# Show Models
native_registry.get_model(model_name).show_versions()

-- Example 28113
import modin.pandas as pd
import snowflake.snowpark.modin.plugin

-- Example 28114
from snowflake.snowpark.context import get_active_session
session = get_active_session()

