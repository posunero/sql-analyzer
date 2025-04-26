-- Example 25904
GRANT MODIFY ON DATA EXCHANGE PROFILE "<provider_profile_name>" TO ROLE myrole;

-- Example 25905
GRANT OWNERSHIP ON DATA EXCHANGE PROFILE "<provider_profile_name>" TO ROLE myrole;

-- Example 25906
CREATE DATABASE IF NOT EXISTS cortex_search_db;

CREATE OR REPLACE WAREHOUSE cortex_search_wh WITH
   WAREHOUSE_SIZE='X-SMALL';

CREATE OR REPLACE SCHEMA cortex_search_db.services;

-- Example 25907
CREATE OR REPLACE TABLE support_transcripts (
    transcript_text VARCHAR,
    region VARCHAR,
    agent_id VARCHAR
);

INSERT INTO support_transcripts VALUES
    ('My internet has been down since yesterday, can you help?', 'North America', 'AG1001'),
    ('I was overcharged for my last bill, need an explanation.', 'Europe', 'AG1002'),
    ('How do I reset my password? The email link is not working.', 'Asia', 'AG1003'),
    ('I received a faulty router, can I get it replaced?', 'North America', 'AG1004');

-- Example 25908
ALTER TABLE support_transcripts SET
  CHANGE_TRACKING = TRUE;

-- Example 25909
CREATE OR REPLACE CORTEX SEARCH SERVICE transcript_search_service
  ON transcript_text
  ATTRIBUTES region
  WAREHOUSE = cortex_search_wh
  TARGET_LAG = '1 day'
  EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
  AS (
    SELECT
        transcript_text,
        region,
        agent_id
    FROM support_transcripts
);

-- Example 25910
GRANT USAGE ON DATABASE cortex_search_db TO ROLE customer_support;
GRANT USAGE ON SCHEMA services TO ROLE customer_support;

GRANT USAGE ON CORTEX SEARCH SERVICE transcript_search_service TO ROLE customer_support;

-- Example 25911
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'cortex_search_db.services.transcript_search_service',
      '{
        "query": "internet issues",
        "columns":[
            "transcript_text",
            "region"
        ],
        "filter": {"@eq": {"region": "North America"} },
        "limit":1
      }'
  )
)['results'] as results;

-- Example 25912
[
  {
  "transcript_text" : "My internet has been down since yesterday, can you help?",
  "region" : "North America"
  }
]

-- Example 25913
SELECT
  *
FROM
  TABLE (
    CORTEX_SEARCH_DATA_SCAN (
      SERVICE_NAME => 'transcript_search_service'
    )
  );

-- Example 25914
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +
|                      transcript_text                       |     region      | agent_id | _GENERATED_EMBEDDINGS_MY_MODEL |
| ---------------------------------------------------------- | --------------- | -------- | ------------------------------ |
| 'My internet has been down since yesterday, can you help?' | 'North America' | 'AG1001' | [0.1, 0.2, 0.3, 0.4]           |
| 'I was overcharged for my last bill, need an explanation.' | 'Europe'        | 'AG1002' | [0.1, 0.2, 0.3, 0.4]           |
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +

-- Example 25915
from snowflake.core import Root
from snowflake.snowpark import Session

CONNECTION_PARAMETERS = {"..."}

session = Session.builder.configs(CONNECTION_PARAMETERS).create()
root = Root(session)

transcript_search_service = (root
  .databases["cortex_search_db"]
  .schemas["services"]
  .cortex_search_services["transcript_search_service"]
)

resp = transcript_search_service.search(
  query="internet issues",
  columns=["transcript_text", "region"],
  filter={"@eq": {"region": "North America"} },
  limit=1
)
print(resp.to_json())

-- Example 25916
{
  "results": [
    {
      "transcript_text": "My internet has been down since yesterday, can you help?",
      "region": "North America"
    }
  ],
  "request_id": "5d8eaa5a-800c-493c-a561-134c712945ba"
}

-- Example 25917
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('snowflake-arctic-embed-m', '<input_text>') as token_count

-- Example 25918
from trulens.core.otel.instrument import instrument

-- Example 25919
@instrument()
def answer_query(self, query: str) -> str:
    context_str = self.retrieve_context(query)
    return self.generate_completion(query, context_str)

-- Example 25920
from trulens.otel.semconv.trace import SpanAttributes

-- Example 25921
@instrument(span_type=SpanAttributes.SpanType.RETRIEVAL)
def retrieve_context(self, query: str) -> list:
    """
    Retrieve relevant text from vector store.
    """
    return self.retrieve(query)

@instrument(span_type=SpanAttributes.SpanType.GENERATION)
def generate_completion(self, query: str, context_str: list) -> str:
    """
    Generate answer from context by calling an LLM.
    """
    return response

@instrument(span_type=SpanAttributes.SpanType.RECORD_ROOT)
def answer_query(self, query: str) -> str:
    context_str = self.retrieve_context(query)
    return self.generate_completion(query, context_str)

-- Example 25922
from trulens.otel.semconv.trace import SpanAttributes

-- Example 25923
@instrument(
    span_type=SpanAttributes.SpanType.RETRIEVAL,
    attributes={
        SpanAttributes.RETRIEVAL.QUERY_TEXT: "query",
        SpanAttributes.RETRIEVAL.RETRIEVED_CONTEXTS: "return",
    }
)
def retrieve_context(self, query: str) -> list:
    """
    Retrieve relevant text from vector store.
    """
    return self.retrieve(query)

-- Example 25924
tru_app = TruApp(
    test_app: Any,
    app_name: str,
    app_version: str,
    connector: SnowflakeConnector,
    main_method: callable  # i.e. test_app.answer_query
)

-- Example 25925
run_config = RunConfig(
    run_name=run_name,
    description="desc",
    label="custom tag useful for grouping comparable runs",
    source_type="DATAFRAME",
    dataset_name="My test dataframe name",
    dataset_spec={
        "RETRIEVAL.QUERY_TEXT": "user_query_field",
        "RECORD_ROOT.INPUT": "user_query_field",
        "RECORD_ROOT.GROUND_TRUTH_OUTPUT": "golden_answer_field",
    },
    llm_judge_name: "mistral-large2"
)

-- Example 25926
run = tru_app.add_run(run_config=run_config)

-- Example 25927
run = tru_app.get_run(run_name=run_name)

-- Example 25928
run.describe()

-- Example 25929
run.start()  # if source_type is "TABLE"

run.start(input_df=user_input_df)  # if source_type is "DATAFRAME"

-- Example 25930
run.compute_metrics(metrics=[
    "coherence",
    "answer_relevance",
    "groundedness",
    "context_relevance",
    "correctness",
])

-- Example 25931
run.get_status()

-- Example 25932
run.cancel()

-- Example 25933
run.delete()

-- Example 25934
tru_app.list_runs()

-- Example 25935
from snowflake.ml.registry import Registry

reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")

-- Example 25936
from snowflake.ml.model import type_hints
mv = reg.log_model(clf,
                   model_name="my_model",
                   version_name="v1",
                   conda_dependencies=["scikit-learn"],
                   comment="My awesome ML model",
                   metrics={"score": 96},
                   sample_input_data=train_features,
                   task=type_hints.Task.TABULAR_BINARY_CLASSIFICATION)

-- Example 25937
from snowflake.ml.model._model_composer.model_manifest import model_manifest
model_manifest.ModelManifest._ENABLE_USER_FILES = True

-- Example 25938
LIST 'snow://model/my_model/versions/V3/';

-- Example 25939
name                                      size                  md5                      last_modified
versions/V3/MANIFEST.yml           30639    2f6186fb8f7d06e737a4dfcdab8b1350        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/apply.py      2249    e9df6db11894026ee137589a9b92c95d        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/predict.py    2251    132699b4be39cc0863c6575b18127f26        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model.zip             721663    e92814d653cecf576f97befd6836a3c6        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/env/conda.yml          332        1574be90b7673a8439711471d58ec746        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/model.yaml       25718    33e3d9007f749bb2e98f19af2a57a80b        Thu, 18 Jan 2024 09:24:37 GMT

-- Example 25940
GET 'snow://model/model_my_model/versions/V3/MANIFEST.yml'

-- Example 25941
session.file.get('snow://model/my_model/versions/V3/MANIFEST.yml', 'model_artifacts')

-- Example 25942
reg.delete_model("mymodel")

-- Example 25943
model_df = reg.show_models()

-- Example 25944
model_list = reg.models()

-- Example 25945
m = reg.get_model("MyModel")

-- Example 25946
print(m.comment)
m.comment = "A better description than the one I provided originally"

-- Example 25947
print(m.description)
m.description = "A better description than the one I provided originally"

-- Example 25948
print(m.show_tags())

-- Example 25949
m.set_tag("live_version", "v1")

-- Example 25950
m.get_tag("live_version")

-- Example 25951
m.unset_tag("live_version")

-- Example 25952
m.rename("MY_MODEL_TOO")

-- Example 25953
version_list = m.versions()

-- Example 25954
version_df = m.show_versions()

-- Example 25955
m.delete_version("rc1")

-- Example 25956
default_version = m.default
m.default = "v2"

-- Example 25957
m = reg.get_model("MyModel")

mv = m.version("v1")
mv = m.default

-- Example 25958
print(mv.comment)
print(mv.description)

mv.comment = "A model version comment"
mv.description = "Same as setting the comment"

-- Example 25959
from sklearn import metrics

test_accuracy = metrics.accuracy_score(test_labels, prediction)

-- Example 25960
test_confusion_matrix = metrics.confusion_matrix(test_labels, prediction)

-- Example 25961
# scalar metric
mv.set_metric("test_accuracy", test_accuracy)

# hierarchical (dictionary) metric
mv.set_metric("evaluation_info", {"dataset_used": "my_dataset", "accuracy": test_accuracy, "f1_score": f1_score})

# multivalent (matrix) metric
mv.set_metric("confusion_matrix", test_confusion_matrix)

-- Example 25962
metrics = mv.show_metrics()

-- Example 25963
mv.delete_metric("test_accuracy")

-- Example 25964
mv.export("~/mymodel/")

-- Example 25965
mv.export("~/mymodel/", export_mode=ExportMode.FULL)

-- Example 25966
clf = mv.load()

-- Example 25967
conda_env = session.file.get("snow://model/<modelName>/versions/<versionName>/runtimes/python_runtime/env/conda.yml", ".")
open("~/conda.yml", "w").write(conda_env)

-- Example 25968
conda env create --name newenv --file=~/conda.yml
conda activate newenv

-- Example 25969
clf = mv.load(options={"use_gpu": True})

-- Example 25970
remote_prediction = mv.run(test_features, function_name="predict")
remote_prediction.show()   # assuming test_features is Snowpark DataFrame

