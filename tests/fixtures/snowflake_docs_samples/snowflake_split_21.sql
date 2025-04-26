-- Example 1361
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'None';

-- Example 1362
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
  WHERE SERVICE_TYPE='AI_SERVICES';

-- Example 1363
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;

-- Example 1364
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY;

-- Example 1365
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY
WHERE query_id='<query-id>';

-- Example 1366
SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-7b', 'Is a hot dog a sandwich'), SNOWFLAKE.CORTEX.COMPLETE('mistral-large', 'Is a hot dog a sandwich');

-- Example 1367
from snowflake.cortex import Complete, ExtractAnswer, Sentiment, Summarize, Translate, ClassifyText

text = """
    The Snowflake company was co-founded by Thierry Cruanes, Marcin Zukowski,
    and Benoit Dageville in 2012 and is headquartered in Bozeman, Montana.
"""

print(Complete("llama2-70b-chat", "how do snowflakes get their unique patterns?"))
print(ExtractAnswer(text, "When was snowflake founded?"))
print(Sentiment("I really enjoyed this restaurant. Fantastic service!"))
print(Summarize(text))
print(Translate(text, "en", "fr"))
print(ClassifyText("France", ["Europe", "Asia"]))

-- Example 1368
from snowflake.cortex import Complete,CompleteOptions

model_options1 = CompleteOptions(
    {'max_tokens':30}
)

print(Complete("llama3.1-8b", "how do snowflakes get their unique patterns?", options=model_options1))

-- Example 1369
from snowflake.cortex import Summarize
from snowflake.snowpark.functions import col

article_df = session.table("articles")
article_df = article_df.withColumn(
    "abstract_summary",
    Summarize(col("abstract_text"))
)
article_df.collect()

-- Example 1370
snow cortex complete "Is 5 more than 4? Please answer using one word without a period." -c "snowhouse"

-- Example 1371
snow cortex extract-answer "what is snowflake?" "snowflake is a company" -c "snowhouse"

-- Example 1372
snow cortex sentiment "Mary had a little Lamb" -c "snowhouse"

-- Example 1373
snow cortex summarize "John has a car. John's car is blue. John's car is old and John is thinking about buying a new car. There are a lot of cars to choose from and John cannot sleep because it's an important decision for John."

-- Example 1374
snow cortex translate herb --to pl

-- Example 1375
Snowflake Cortex gives you instant access to industry-leading large language models (LLMs) trained by researchers at companies like Anthropic, Mistral, Reka, Meta, and Google, including Snowflake Arctic, an open enterprise-grade model developed by Snowflake.

Since these LLMs are fully hosted and managed by Snowflake, using them requires no setup. Your data stays within Snowflake, giving you the performance, scalability, and governance you expect.

Snowflake Cortex features are provided as SQL functions and are also available in Python. The available functions are summarized below.

COMPLETE: Given a prompt, returns a response that completes the prompt. This function accepts either a single prompt or a conversation with multiple prompts and responses.
EMBED_TEXT_768: Given a piece of text, returns a vector embedding that represents that text.
EXTRACT_ANSWER: Given a question and unstructured data, returns the answer to the question if it can be found in the data.
SENTIMENT: Returns a sentiment score, from -1 to 1, representing the detected positive or negative sentiment of the given text.
SUMMARIZE: Returns a summary of the given text.
TRANSLATE: Translates given text from any supported language to any other.

-- Example 1376
snow cortex summarize --file about_cortex.txt

-- Example 1377
Snowflake Cortex offers instant access to industry-leading language models, including Snowflake Arctic, with SQL functions for completing prompts (COMPLETE), text embedding (EMBED\_TEXT\_768), extracting answers (EXTRACT\_ANSWER), sentiment analysis (SENTIMENT), summarizing text (SUMMARIZE), and translating text (TRANSLATE).

-- Example 1378
USE ROLE ACCOUNTADMIN;

REVOKE DATABASE ROLE SNOWFLAKE.COPILOT_USER
  FROM ROLE PUBLIC;

-- Example 1379
USE ROLE ACCOUNTADMIN;

CREATE ROLE copilot_access_role;
GRANT DATABASE ROLE SNOWFLAKE.COPILOT_USER TO ROLE copilot_access_role;

GRANT ROLE copilot_access_role TO USER some_user;

-- Example 1380
GRANT DATABASE ROLE SNOWFLAKE.COPILOT_USER TO ROLE analyst;

-- Example 1381
Can you explain this query to me step-by-step?

-- Example 1382
SELECT
  github_repos.repo_name,
  COUNT(github_stars.repo_id) AS total_stars
FROM
  github_repos
  JOIN github_stars ON github_repos.repo_id = github_stars.repo_id
GROUP BY
  github_repos.repo_name
ORDER BY
  total_stars DESC;

-- Example 1383
curl -X POST "$SNOWFLAKE_ACCOUNT_BASE_URL/api/v2/cortex/agent:run" \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $YOUR_JWT" \
--data '{
    "model": "llama3.1-70b",
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "what are the top 3 customers by revenue"
                }
            ]
        }
    ],
    "tools": [
        {
            "tool_spec": {
                "type": "cortex_search",
                "name": "transcript_search"
            }
        },
        {
            "tool_spec": {
                "type": "cortex_analyst_text_to_sql",
                "name": "data_model"
            }
        }
    ],
    "tool_resources": {
        "transcript_search": {"name": "testdb.testschema.transcript_search_service"},
        "data_model": {"semantic_model_file": "@testdb.testschema.stage/sample_data_model.yaml"}
    }
}'

-- Example 1384
{
    "response_instruction": "You will always maintain a friendly tone and provide concise response"
}

-- Example 1385
{
    "tools": [
        {
            "tool_spec": {
                "name": "data_model",
                "type": "cortex_analyst_text_to_sql"
            }
        },
        {
            "tool_spec": {
                "name": "transcript_search",
                "type": "cortex_search"
            }
        },
        {
            "tool_spec": {
                "type": "sql_exec",
                "name": "sql_exec"
            }
        },
        {
            "tool_spec": {
                "type": "data_to_chart",
                "name": "data_to_chart"
            }
        }
    ]
}

-- Example 1386
{
    "tool_resources": {
        "data_model": {
            "semantic_model_file": "@cortex_tutorial_db.public.revenue_semantic_model.yaml"
        },
        "transcript_search": {
            "name": "cortex_tutorial_db.public.contract_terms",
            "max_results": 5,
            "title_column": "TRANSCRIPT_TITLE",
            "id_column": "TRANSCRIPT_ID",
            "filter": {"@eq": {"TRANSCRIPT_TYPE": "ENTERPRISE"} }
        }
    }
}

-- Example 1387
{
    "model": "claude-3-5-sonnet",
    "messages": [
        {
            "role": "system",
            "content": {
                "type": "text",
                "text": "You’re a friendly assistant to answer questions."
            }
        }
    ]
}

-- Example 1388
{
    "model": "claude-3-5-sonnet",
    "messages": [
        {
            "role": "system",
            "content": [
                {
                    "type": "text",
                    "text": "You’re a friendly assistant to answer questions"
                }
            ]
        },
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "hello"
                }
            ]
        },
        {
            "role": "assistant",
            "content": [
                {
                    "type": "text",
                    "text": "hi there!"
                }
            ]
        },
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "..."
                }
            ]
        }
    ]
}

-- Example 1389
{
    "role": "assistant",
    "content": [
        {
            "type": "tool_use",
            "tool_use": {
                "tool_use_id": "tool_001",
                "name": "cortex_analyst_text_to_sql",
                "input": {
                    "query": "...",
                    "semantic_model_file": "..."
                }
            }
        },
        {
            "type": "tool_results",
            "tool_results": {
                "status": "success",
                "tool_use_id": "tool_001",
                "content": [
                    {
                        "type": "json",
                        "json": {
                            "sql": "select * from table"
                        }
                    }
                ]
            }
        },
        {
            "type": "tool_use",
            "tool_use": {
                "tool_use_id": "tool_002",
                "name": "sql_exec",
                "input": {
                    "sql": "select * from table"
                }
            }
        }
    ]
}

-- Example 1390
CREATE DATABASE IF NOT EXISTS cortex_search_db;

CREATE OR REPLACE WAREHOUSE cortex_search_wh WITH
   WAREHOUSE_SIZE='X-SMALL';

CREATE OR REPLACE SCHEMA cortex_search_db.services;

-- Example 1391
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

-- Example 1392
ALTER TABLE support_transcripts SET
  CHANGE_TRACKING = TRUE;

-- Example 1393
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

-- Example 1394
GRANT USAGE ON DATABASE cortex_search_db TO ROLE customer_support;
GRANT USAGE ON SCHEMA services TO ROLE customer_support;

GRANT USAGE ON CORTEX SEARCH SERVICE transcript_search_service TO ROLE customer_support;

-- Example 1395
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

-- Example 1396
[
  {
  "transcript_text" : "My internet has been down since yesterday, can you help?",
  "region" : "North America"
  }
]

-- Example 1397
SELECT
  *
FROM
  TABLE (
    CORTEX_SEARCH_DATA_SCAN (
      SERVICE_NAME => 'transcript_search_service'
    )
  );

-- Example 1398
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +
|                      transcript_text                       |     region      | agent_id | _GENERATED_EMBEDDINGS_MY_MODEL |
| ---------------------------------------------------------- | --------------- | -------- | ------------------------------ |
| 'My internet has been down since yesterday, can you help?' | 'North America' | 'AG1001' | [0.1, 0.2, 0.3, 0.4]           |
| 'I was overcharged for my last bill, need an explanation.' | 'Europe'        | 'AG1002' | [0.1, 0.2, 0.3, 0.4]           |
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +

-- Example 1399
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

-- Example 1400
{
  "results": [
    {
      "transcript_text": "My internet has been down since yesterday, can you help?",
      "region": "North America"
    }
  ],
  "request_id": "5d8eaa5a-800c-493c-a561-134c712945ba"
}

-- Example 1401
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('snowflake-arctic-embed-m', '<input_text>') as token_count

-- Example 1402
from snowflake.ml.registry import Registry

reg = Registry(session=sp_session, database_name="ML", schema_name="REGISTRY")

-- Example 1403
from snowflake.ml.model import type_hints
mv = reg.log_model(clf,
                   model_name="my_model",
                   version_name="v1",
                   conda_dependencies=["scikit-learn"],
                   comment="My awesome ML model",
                   metrics={"score": 96},
                   sample_input_data=train_features,
                   task=type_hints.Task.TABULAR_BINARY_CLASSIFICATION)

-- Example 1404
from snowflake.ml.model._model_composer.model_manifest import model_manifest
model_manifest.ModelManifest._ENABLE_USER_FILES = True

-- Example 1405
LIST 'snow://model/my_model/versions/V3/';

-- Example 1406
name                                      size                  md5                      last_modified
versions/V3/MANIFEST.yml           30639    2f6186fb8f7d06e737a4dfcdab8b1350        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/apply.py      2249    e9df6db11894026ee137589a9b92c95d        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/functions/predict.py    2251    132699b4be39cc0863c6575b18127f26        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model.zip             721663    e92814d653cecf576f97befd6836a3c6        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/env/conda.yml          332        1574be90b7673a8439711471d58ec746        Thu, 18 Jan 2024 09:24:37 GMT
versions/V3/model/model.yaml       25718    33e3d9007f749bb2e98f19af2a57a80b        Thu, 18 Jan 2024 09:24:37 GMT

-- Example 1407
GET 'snow://model/model_my_model/versions/V3/MANIFEST.yml'

-- Example 1408
session.file.get('snow://model/my_model/versions/V3/MANIFEST.yml', 'model_artifacts')

-- Example 1409
reg.delete_model("mymodel")

-- Example 1410
model_df = reg.show_models()

-- Example 1411
model_list = reg.models()

-- Example 1412
m = reg.get_model("MyModel")

-- Example 1413
print(m.comment)
m.comment = "A better description than the one I provided originally"

-- Example 1414
print(m.description)
m.description = "A better description than the one I provided originally"

-- Example 1415
print(m.show_tags())

-- Example 1416
m.set_tag("live_version", "v1")

-- Example 1417
m.get_tag("live_version")

-- Example 1418
m.unset_tag("live_version")

-- Example 1419
m.rename("MY_MODEL_TOO")

-- Example 1420
version_list = m.versions()

-- Example 1421
version_df = m.show_versions()

-- Example 1422
m.delete_version("rc1")

-- Example 1423
default_version = m.default
m.default = "v2"

-- Example 1424
m = reg.get_model("MyModel")

mv = m.version("v1")
mv = m.default

-- Example 1425
print(mv.comment)
print(mv.description)

mv.comment = "A model version comment"
mv.description = "Same as setting the comment"

-- Example 1426
from sklearn import metrics

test_accuracy = metrics.accuracy_score(test_labels, prediction)

-- Example 1427
test_confusion_matrix = metrics.confusion_matrix(test_labels, prediction)

-- Example 1428
# scalar metric
mv.set_metric("test_accuracy", test_accuracy)

# hierarchical (dictionary) metric
mv.set_metric("evaluation_info", {"dataset_used": "my_dataset", "accuracy": test_accuracy, "f1_score": f1_score})

# multivalent (matrix) metric
mv.set_metric("confusion_matrix", test_confusion_matrix)

