-- Example 14787
from torch.utils.data import DataLoader

# See later sections about shuffling and batching
pipe = fileset_df.to_torch_datapipe(
    batch_size=4,
    shuffle=True,
    drop_last_batch=True)

for batch in DataLoader(pipe, batch_size=None, num_workers=0):
    print(batch)
    break

-- Example 14788
import tensorflow as tf

# See following sections about shuffling and batching
ds = fileset_df.to_tf_dataset(
    batch_size=4,
    shuffle=True,
    drop_last_batch=True)

for batch in ds:
    print(batch)
    break

-- Example 14789
from sklearn import datasets, ensemble

iris_X, iris_y = datasets.load_iris(return_X_y=True, as_frame=True)
clf = ensemble.RandomForestClassifier(random_state=42)
clf.fit(iris_X, iris_y)
model_ref = registry.log_model(
    clf,
    model_name="RandomForestClassifier",
    version_name="v1",
    sample_input_data=iris_X,
    options={
        "method_options": {
            "predict": {"case_sensitive": True},
            "predict_proba": {"case_sensitive": True},
            "predict_log_proba": {"case_sensitive": True},
        }
    },
)
model_ref.run(iris_X[-10:], function_name='"predict_proba"')

-- Example 14790
from sklearn import datasets, ensemble, pipeline, preprocessing

iris_X, iris_y = datasets.load_iris(return_X_y=True, as_frame=True)
pipe = pipeline.Pipeline([
    ('scaler', preprocessing.StandardScaler()),
    ('classifier', ensemble.RandomForestClassifier(random_state=42)),
])
pipe.fit(iris_X, iris_y)
model_ref = registry.log_model(
    pipe,
    model_name="Pipeline",
    version_name="v1",
    sample_input_data=iris_X,
    options={
        "method_options": {
            "predict": {"case_sensitive": True},
            "predict_proba": {"case_sensitive": True},
            "predict_log_proba": {"case_sensitive": True},
        }
    },
)
model_ref.run(iris_X[-10:], function_name='"predict_proba"')

-- Example 14791
import xgboost
from sklearn import datasets, model_selection

cal_X, cal_y = datasets.load_breast_cancer(as_frame=True, return_X_y=True)
cal_X_train, cal_X_test, cal_y_train, cal_y_test = model_selection.train_test_split(cal_X, cal_y)
params = dict(n_estimators=100, reg_lambda=1, gamma=0, max_depth=3, objective="binary:logistic")
regressor = xgboost.train(params, xgboost.DMatrix(data=cal_X_train, label=cal_y_train))
model_ref = registry.log_model(
    regressor,
    model_name="xgBooster",
    version_name="v1",
    sample_input_data=cal_X_test,
    options={
        "target_methods": ["predict"],
        "method_options": {
            "predict": {"case_sensitive": True},
        },
    },
)
model_ref.run(cal_X_test[-10:])

-- Example 14792
lm_hf_model = transformers.pipeline(
    task="text-generation",
    model="bigscience/bloom-560m",
    token="...",  # Put your HuggingFace token here.
    return_full_text=False,
    max_new_tokens=100,
)

lmv = reg.log_model(lm_hf_model, model_name='bloom', version_name='v560m')

-- Example 14793
{'name': '__CALL__',
  'target_method': '__call__',
  'signature': ModelSignature(
                      inputs=[
                          FeatureSpec(dtype=DataType.STRING, name='inputs')
                      ],
                      outputs=[
                          FeatureSpec(dtype=DataType.STRING, name='outputs')
                      ]
                  )}]

-- Example 14794
import pandas as pd
remote_prediction = lmv.run(pd.DataFrame(["Hello, how are you?"], columns=["inputs"]))

-- Example 14795
'[{"score": 0.61094731092453, "start": 139, "end": 178, "answer": "learn more about the world of athletics"},
{"score": 0.17750297486782074, "start": 139, "end": 180, "answer": "learn more about the world of athletics.\""}]'

-- Example 14796
# Prepare model
import transformers
import pandas as pd

finbert_model = transformers.pipeline(
    task="text-classification",
    model="ProsusAI/finbert",
    top_k=2,
)

# Log the model
mv = registry.log_model(
    finbert_model,
    model_name="finbert",
    version_name="v1",
)

# Use the model
mv.run(pd.DataFrame(
        [
            ["I have a problem with my Snowflake that needs to be resolved asap!!", ""],
            ["I would like to have udon for today's dinner.", ""],
        ]
    )
)

-- Example 14797
0  [{"label": "negative", "score": 0.8106237053871155}, {"label": "neutral", "score": 0.16587384045124054}]
1  [{"label": "neutral", "score": 0.9263970851898193}, {"label": "positive", "score": 0.05286872014403343}]

-- Example 14798
---------------------------------------------------------------------------
|"user_inputs"                                    |"generated_responses"  |
---------------------------------------------------------------------------
|[                                                |[                      |
|  "Do you speak French?",                        |  "Yes I do."          |
|  "Do you know how to say Snowflake in French?"  |]                      |
|]                                                |                       |
---------------------------------------------------------------------------

-- Example 14799
-------------------------
|"generated_responses"  |
-------------------------
|[                      |
|  "Yes I do.",         |
|  "I speak French."    |
|]                      |
-------------------------

-- Example 14800
--------------------------------------------------
|"inputs"                                        |
--------------------------------------------------
|LynYuu is the [MASK] of the Grand Duchy of Yu.  |
--------------------------------------------------

-- Example 14801
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"outputs"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|[{"score": 0.9066258072853088, "token": 3007, "token_str": "capital", "sequence": "lynyuu is the capital of the grand duchy of yu."}, {"score": 0.08162177354097366, "token": 2835, "token_str": "seat", "sequence": "lynyuu is the seat of the grand duchy of yu."}, {"score": 0.0012052370002493262, "token": 4075, "token_str": "headquarters", "sequence": "lynyuu is the headquarters of the grand duchy of yu."}, {"score": 0.0006560495239682496, "token": 2171, "token_str": "name", "sequence": "lynyuu is the name of the grand duchy of yu."}, {"score": 0.0005427763098850846, "token": 3200, "token_str"...  |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14802
------------------------------------------------
|"inputs"                                      |
------------------------------------------------
|My name is Izumi and I live in Tokyo, Japan.  |
------------------------------------------------

-- Example 14803
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"outputs"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|[{"entity": "PRON", "score": 0.9994392991065979, "index": 1, "word": "my", "start": 0, "end": 2}, {"entity": "NOUN", "score": 0.9968984127044678, "index": 2, "word": "name", "start": 3, "end": 7}, {"entity": "AUX", "score": 0.9937735199928284, "index": 3, "word": "is", "start": 8, "end": 10}, {"entity": "PROPN", "score": 0.9928083419799805, "index": 4, "word": "i", "start": 11, "end": 12}, {"entity": "PROPN", "score": 0.997334361076355, "index": 5, "word": "##zumi", "start": 12, "end": 16}, {"entity": "CCONJ", "score": 0.999173104763031, "index": 6, "word": "and", "start": 17, "end": 20}, {...  |

-- Example 14804
-----------------------------------------------------------------------------------
|"question"                  |"context"                                           |
-----------------------------------------------------------------------------------
|What did Doris want to do?  |Doris is a cheerful mermaid from the ocean dept...  |
-----------------------------------------------------------------------------------

-- Example 14805
--------------------------------------------------------------------------------
|"score"           |"start"  |"end"  |"answer"                                 |
--------------------------------------------------------------------------------
|0.61094731092453  |139      |178    |learn more about the world of athletics  |
--------------------------------------------------------------------------------

-- Example 14806
-----------------------------------------------------------------------------------
|"question"                  |"context"                                           |
-----------------------------------------------------------------------------------
|What did Doris want to do?  |Doris is a cheerful mermaid from the ocean dept...  |
-----------------------------------------------------------------------------------

-- Example 14807
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"outputs"                                                                                                                                                                                                                                                                                                                                        |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|[{"score": 0.61094731092453, "start": 139, "end": 178, "answer": "learn more about the world of athletics"}, {"score": 0.17750297486782074, "start": 139, "end": 180, "answer": "learn more about the world of athletics.\""}, {"score": 0.06438097357749939, "start": 138, "end": 178, "answer": "\"learn more about the world of athletics"}]  |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14808
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"documents"                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|Neuro-sama is a chatbot styled after a female VTuber that hosts live streams on the Twitch channel "vedal987". Her speech and personality are generated by an artificial intelligence (AI) system  wh...  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14809
---------------------------------------------------------------------------------
|"summary_text"                                                                 |
---------------------------------------------------------------------------------
| Neuro-sama is a chatbot styled after a female VTuber that hosts live streams  |
---------------------------------------------------------------------------------

-- Example 14810
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"query"                                  |"table"                                                                                                                                                                                                                                                   |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|Which channel has the most subscribers?  |{"Channel": ["A.I.Channel", "Kaguya Luna", "Mirai Akari", "Siro"], "Subscribers": ["3,020,000", "872,000", "694,000", "660,000"], "Videos": ["1,200", "113", "639", "1,300"], "Created At": ["Jun 30 2016", "Dec 4 2017", "Feb 28 2014", "Jun 23 2017"]}  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14811
----------------------------------------------------------------
|"answer"     |"coordinates"  |"cells"          |"aggregator"  |
----------------------------------------------------------------
|A.I.Channel  |[              |[                |NONE          |
|             |  [            |  "A.I.Channel"  |              |
|             |    0,         |]                |              |
|             |    0          |                 |              |
|             |  ]            |                 |              |
|             |]              |                 |              |
----------------------------------------------------------------

-- Example 14812
----------------------------------
|"text"       |"text_pair"       |
----------------------------------
|I like you.  |I love you, too.  |
----------------------------------

-- Example 14813
--------------------------------
|"label"  |"score"             |
--------------------------------
|LABEL_0  |0.9760091304779053  |
--------------------------------

-- Example 14814
--------------------------------------------------------------------
|"text"                                              |"text_pair"  |
--------------------------------------------------------------------
|I am wondering if I should have udon or rice fo...  |             |
--------------------------------------------------------------------

-- Example 14815
--------------------------------------------------------
|"outputs"                                             |
--------------------------------------------------------
|[{"label": "NEGATIVE", "score": 0.9987024068832397}]  |
--------------------------------------------------------

-- Example 14816
--------------------------------------------------------------------------------
|"inputs"                                                                      |
--------------------------------------------------------------------------------
|A descendant of the Lost City of Atlantis, who swam to Earth while saying, "  |
--------------------------------------------------------------------------------

-- Example 14817
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|"outputs"                                                                                                                                                                                                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|[{"generated_text": "A descendant of the Lost City of Atlantis, who swam to Earth while saying, \"For my life, I don't know if I'm gonna land upon Earth.\"\n\nIn \"The Misfits\", in a flashback, wh...  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14818
--------------------------------------------------------------------------------
|"inputs"                                                                      |
--------------------------------------------------------------------------------
|A descendant of the Lost City of Atlantis, who swam to Earth while saying, "  |
--------------------------------------------------------------------------------

-- Example 14819
----------------------------------------------------------------
|"generated_text"                                              |
----------------------------------------------------------------
|, said that he was a descendant of the Lost City of Atlantis  |
----------------------------------------------------------------

-- Example 14820
------------------------------------------------------------------------------------------------------
|"inputs"                                                                                            |
------------------------------------------------------------------------------------------------------
|Snowflake's Data Cloud is powered by an advanced data platform provided as a self-managed service.  |
------------------------------------------------------------------------------------------------------

-- Example 14821
---------------------------------------------------------------------------------------------------------------------------------
|"translation_text"                                                                                                             |
---------------------------------------------------------------------------------------------------------------------------------
|Le Cloud de données de Snowflake est alimenté par une plate-forme de données avancée fournie sous forme de service autogérés.  |
---------------------------------------------------------------------------------------------------------------------------------

-- Example 14822
-----------------------------------------------------------------------------------------
|"sequences"                                                       |"candidate_labels"  |
-----------------------------------------------------------------------------------------
|I have a problem with Snowflake that needs to be resolved asap!!  |[                   |
|                                                                  |  "urgent",         |
|                                                                  |  "not urgent"      |
|                                                                  |]                   |
|I have a problem with Snowflake that needs to be resolved asap!!  |[                   |
|                                                                  |  "English",        |
|                                                                  |  "Japanese"        |
|                                                                  |]                   |
-----------------------------------------------------------------------------------------

-- Example 14823
--------------------------------------------------------------------------------------------------------------
|"sequence"                                                        |"labels"        |"scores"                |
--------------------------------------------------------------------------------------------------------------
|I have a problem with Snowflake that needs to be resolved asap!!  |[               |[                       |
|                                                                  |  "urgent",     |  0.9952737092971802,   |
|                                                                  |  "not urgent"  |  0.004726255778223276  |
|                                                                  |]               |]                       |
|I have a problem with Snowflake that needs to be resolved asap!!  |[               |[                       |
|                                                                  |  "Japanese",   |  0.5790848135948181,   |
|                                                                  |  "English"     |  0.42091524600982666   |
|                                                                  |]               |]                       |
--------------------------------------------------------------------------------------------------------------

-- Example 14824
import mlflow
from sklearn import datasets, model_selection, ensemble

db = datasets.load_diabetes(as_frame=True)
X_train, X_test, y_train, y_test = model_selection.train_test_split(db.data, db.target)
with mlflow.start_run() as run:
    rf = ensemble.RandomForestRegressor(n_estimators=100, max_depth=6, max_features=3)
    rf.fit(X_train, y_train)

    # Use the model to make predictions on the test dataset.
    predictions = rf.predict(X_test)
    signature = mlflow.models.signature.infer_signature(X_test, predictions)
    mlflow.sklearn.log_model(
        rf,
        "model",
        signature=signature,
    )
    run_id = run.info.run_id


model_ref = registry.log_model(
    mlflow.pyfunc.load_model(f"runs:/{run_id}/model"),
    model_name="mlflowModel",
    version_name="v1",
    conda_dependencies=["mlflow<=2.4.0", "scikit-learn", "scipy"],
    options={"ignore_mlflow_dependencies": True}
)
model_ref.run(X_test)

-- Example 14825
from snowflake.ml.registry import Registry

# create a session
session = ...

registry = Registry(session=session)

# Define `method_options` for each inference method if needed.
method_options={
  "predict": {
    "case_sensitive": True
  }
}

registry.log_model(
  model=model,
  model_name="my_model",
  options={"method_options": method_options},
)

-- Example 14826
GET internalStage file://<local_directory_path>
    [ PARALLEL = <integer> ]
    [ PATTERN = '<regex_pattern>'' ]

-- Example 14827
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 14828
GET @my_int_stage my_target_path PATTERN = "tmp.parquet";

-- Example 14829
GET @%mytable file:///tmp/data/;

-- Example 14830
GET @~/myfiles file:///tmp/data/;

-- Example 14831
>>> # Create a temp stage.
>>> _ = session.sql("create or replace temp stage mystage").collect()
>>> # Upload a file to a stage.
>>> _ = session.file.put("tests/resources/t*.csv", "@mystage/prefix1")
>>> # Download one file from a stage.
>>> get_result1 = session.file.get("@myStage/prefix1/test2CSV.csv", "tests/downloaded/target1")
>>> assert len(get_result1) == 1
>>> # Download all the files from @myStage/prefix.
>>> get_result2 = session.file.get("@myStage/prefix1", "tests/downloaded/target2")
>>> assert len(get_result2) > 1
>>> # Download files with names that match a regular expression pattern.
>>> get_result3 = session.file.get("@myStage/prefix1", "tests/downloaded/target3", pattern=".*test.*.csv.gz")
>>> assert len(get_result3) > 1

-- Example 14832
DROP MODEL <name>

-- Example 14833
SHOW MODELS [ LIKE '<pattern>' ]
            [ IN { DATABASE [ <db_name> ] | SCHEMA [ <schema_name> ] } ]

-- Example 14834
ALTER MODEL [ IF EXISTS ] <name> SET
  [ COMMENT = '<string_literal>' ]
  [ DEFAULT_VERSION = '<version_name>']

ALTER MODEL [ IF EXISTS ] <model_name> SET TAG <tag_name> = '<tag_value>'

ALTER MODEL [ IF EXISTS ] <model_name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER MODEL [ IF EXISTS ] <model_name> VERSION <version_name> SET ALIAS = '<alias_name>'

ALTER MODEL [ IF EXISTS ] <model_name> VERSION <version_or_alias_name> UNSET ALIAS

ALTER MODEL <model_name> RENAME TO <new_name>

-- Example 14835
SHOW VERSIONS [ LIKE '<pattern>' ] IN MODEL <model_name>

-- Example 14836
ALTER MODEL [ IF EXISTS ] <name> DROP VERSION <version_name>

-- Example 14837
ALTER MODEL [ IF EXISTS ] <name> MODIFY VERSION <version_or_alias_name> SET
  [ COMMENT = '<string_literal>' ]
  [ METADATA = '<json_metadata>']

-- Example 14838
COPY FILES INTO @[<namespace>.]<stage_name>[/<path>/]
  FROM @[<namespace>.]<stage_name>[/<path>/]
  [ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
  [ PATTERN = '<regex_pattern>' ]
  [ DETAILED_OUTPUT = { TRUE | FALSE } ]

-- Example 14839
COPY FILES INTO @[<namespace>.]<stage_name>[/<path>/]
  FROM ( SELECT <existing_url> [ , <new_filename> ] FROM ... )
  [ DETAILED_OUTPUT = { TRUE | FALSE } ]

-- Example 14840
+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Aug 2022 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Aug 2022 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 14841
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 14842
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  FILES = ('file1.csv', 'file2.csv');

-- Example 14843
COPY FILES
  INTO @trg_stage/trg_path/
  FROM @src_stage/src_path/;

-- Example 14844
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  PATTERN='.*/.*/.*[.]csv[.]gz';

-- Example 14845
COPY FILES
  INTO @trg_stage
  FROM @src_stage
  PATTERN='.*sales.*[.]csv';

-- Example 14846
COPY FILES
  INTO @trg_stage
  FROM (SELECT '@src_stage/file.txt');

-- Example 14847
COPY FILES
  INTO @trg_stage
  FROM (SELECT '@src_stage/file.txt', 'new_filename.txt');

-- Example 14848
-- Create a table with URLs
CREATE TABLE urls(src_file STRING, trg_file STRING);
INSERT INTO urls VALUES ('@src_stage/file.txt', 'new_filename.txt');

-- Insert additional URLs here
COPY FILES
  INTO @trg_stage
  FROM (SELECT src_file, trg_file FROM urls);

-- Example 14849
COPY FILES
  INTO @trg_stage
  FROM (SELECT src_file, trg_file FROM urls WHERE src_file LIKE '%file%');

-- Example 14850
COPY FILES
  INTO @trg_stage
  FROM (SELECT relative_path FROM directory(@src_stage) WHERE relative_path LIKE '%.txt');

-- Example 14851
from snowflake.ml.feature_store import setup_feature_store

setup_feature_store(
    session=session,
    database="<FS_DATABASE_NAME>",
    schema="<FS_SCHEMA_NAME>",
    warehouse="<FS_WAREHOUSE>",
    producer_role="<FS_PRODUCER_ROLE>",
    consumer_role="<FS_CONSUMER_ROLE>",
)

-- Example 14852
-- Initialize variables for usage in SQL scripts below
SET FS_ROLE_PRODUCER = '<FS_PRODUCER_ROLE>';
SET FS_ROLE_CONSUMER = '<FS_CONSUMER_ROLE>';
SET FS_DATABASE = '<FS_DATABASE_NAME>';
SET FS_SCHEMA = '<FS_SCHEMA_NAME>';
SET FS_WAREHOUSE = '<FS_WAREHOUSE>';

-- Create schema
SET SCHEMA_FQN = CONCAT($FS_DATABASE, '.', $FS_SCHEMA);
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($SCHEMA_FQN);

-- Create roles
CREATE ROLE IF NOT EXISTS IDENTIFIER($FS_ROLE_PRODUCER);
CREATE ROLE IF NOT EXISTS IDENTIFIER($FS_ROLE_CONSUMER);

-- Build role hierarchy
GRANT ROLE IDENTIFIER($FS_ROLE_PRODUCER) TO ROLE SYSADMIN;
GRANT ROLE IDENTIFIER($FS_ROLE_CONSUMER) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);

-- Grant PRODUCER role privileges
GRANT CREATE DYNAMIC TABLE ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);
GRANT CREATE VIEW ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);
GRANT CREATE TAG ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);
GRANT CREATE DATASET ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);
GRANT CREATE TABLE ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_PRODUCER);

-- Grant CONSUMER role privileges
GRANT USAGE ON DATABASE IDENTIFIER($FS_DATABASE) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);
GRANT USAGE ON SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);

GRANT SELECT, MONITOR ON FUTURE DYNAMIC TABLES IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);
GRANT SELECT, MONITOR ON ALL DYNAMIC TABLES IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);

GRANT SELECT, REFERENCES ON FUTURE VIEWS IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);
GRANT SELECT, REFERENCES ON ALL VIEWS IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);

GRANT USAGE ON FUTURE DATASETS IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);
GRANT USAGE ON ALL DATASETS IN SCHEMA IDENTIFIER($SCHEMA_FQN) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);

-- Grant USAGE ON WAREHOUSE to CONSUMER
GRANT USAGE ON WAREHOUSE IDENTIFIER($FS_WAREHOUSE) TO ROLE IDENTIFIER($FS_ROLE_CONSUMER);

-- Example 14853
from snowflake.ml.feature_store import FeatureStore, CreationMode

fs = FeatureStore(
        session=session,
        database="MY_DB",
        name="MY_FEATURE_STORE",
        default_warehouse="MY_WH",
        creation_mode=CreationMode.CREATE_IF_NOT_EXIST,
     )

