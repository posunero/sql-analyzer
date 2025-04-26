-- Example 14586
my_user = root.users["janesmith"].fetch()
print(my_user.to_dict())

-- Example 14587
users = root.users.iter(like="jane%")
for user in users:
  print(user.name)

-- Example 14588
DROP USER janesmith;

-- Example 14589
root.users["janesmith"].drop()

-- Example 14590
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

-- Example 14591
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

-- Example 14592
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'DISABLED';

-- Example 14593
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US,AWS_EU';

-- Example 14594
SNOWFLAKE.CORTEX.COMPLETE(
    <model>, <prompt_or_history> [ , <options> ] )

-- Example 14595
SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'What are large language models?');

-- Example 14596
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
        CONCAT('Critique this review in bullet points: <review>', content, '</review>')
) FROM reviews LIMIT 10;

-- Example 14597
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama2-70b-chat',
    [
        {
            'role': 'user',
            'content': 'how does a snowflake get its unique pattern?'
        }
    ],
    {
        'temperature': 0.7,
        'max_tokens': 10
    }
);

-- Example 14598
{
    "choices": [
        {
            "messages": " The unique pattern on a snowflake is"
        }
    ],
    "created": 1708536426,
    "model": "llama2-70b-chat",
    "usage": {
        "completion_tokens": 10,
        "prompt_tokens": 22,
        "guardrail_tokens": 0,
        "total_tokens": 32
    }
}

-- Example 14599
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-7b',
    [
        {
            'role': 'user',
            'content': <'Prompt that generates an unsafe response'>
        }
    ],
    {
        'guardrails': true
    }
);

-- Example 14600
{
    "choices": [
        {
            "messages": "Response filtered by Cortex Guard"
        }
    ],
    "created": 1718882934,
    "model": "mistral-7b",
    "usage": {
        "completion_tokens": 402,
        "prompt_tokens": 93,
        "guardrails _tokens": 677,
        "total_tokens": 1172
    }
}

-- Example 14601
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama2-70b-chat',
    [
        {'role': 'system', 'content': 'You are a helpful AI assistant. Analyze the movie review text and determine the overall sentiment. Answer with just \"Positive\", \"Negative\", or \"Neutral\"' },
        {'role': 'user', 'content': 'this was really good'}
    ], {}
    ) as response;

-- Example 14602
{
    "choices": [
        {
        "messages": " Positive"
        }
    ],
    "created": 1708479449,
    "model": "llama2-70b-chat",
    "usage": {
        "completion_tokens": 3,
        "prompt_tokens": 64,
        "total_tokens": 67
    }
}

-- Example 14603
conda create --name snowpark-ml

-- Example 14604
conda activate snowpark-ml

-- Example 14605
conda install --override-channels --channel https://repo.anaconda.com/pkgs/snowflake/ snowflake-ml-python

-- Example 14606
cd ~/projects/ml
source .venv/bin/activate

-- Example 14607
python -m pip install snowflake-ml-python

-- Example 14608
conda activate snowpark-ml
conda install --override-channels --channel https://repo.anaconda.com/pkgs/snowflake/ lightgbm

-- Example 14609
.venv/bin/activate
python -m pip install 'snowflake-ml-python[lightgbm]'

-- Example 14610
.venv/bin/activate
python -m pip install 'snowflake-ml-python[all]'

-- Example 14611
from snowflake.snowpark import Session
from snowflake.ml.utils import connection_params

params = connection_params.SnowflakeLoginOptions("myaccount")
sp_session = Session.builder.configs(params).create()

-- Example 14612
session = Session.builder.configs({"connection": connection}).create()

-- Example 14613
from snowflake.snowpark import Session
from snowflake.ml.utils import connection_params
# Get named connection from SnowSQL configuration file
params = connection_params.SnowflakeLoginOptions("myaccount")
# Add warehouse name for model method calls if it's not already present
if "warehouse" not in params:
    params["warehouse"] = "mlwarehouse"
sp_session = Session.builder.configs(params).create()

-- Example 14614
sp_session.use_warehouse("mlwarehouse")

-- Example 14615
from snowflake.ml.modeling.preprocessing import OneHotEncoder

help(OneHotEncoder)

-- Example 14616
tool_resources: {
    "toolName1": {configuration object for toolName1},
    "toolName2": {configuration object for toolName2},
    ...
}

-- Example 14617
"SearchName": {
    "name": "database.schema.service_name",            # Required: The Snowflake search service identifier
    "max_results": 5,                                  # Optional: Number of search results to include
    "title_column": "title",                           # Optional: Column to use as document title
    "id_column": "id",                                 # Optional: Column to use as document identifier
    "filter": {                                        # Optional: Filters to apply to search results
      "@eq": {"<column>": "<value>"}
    }
}

-- Example 14618
"AnalystName": {
    "semantic_model_file": "@database.schema.stage/my_semantic_model.yaml"  # Required: Stage path to semantic model file
}

-- Example 14619
{
  "type": "text",
  "text": "Show me sales by region for Q1 2024"
}

-- Example 14620
{
  "type": "chart",
  "chart": {
    "chart_spec": "{\"$schema\":\"https://vega.github.io/schema/vega-lite/v5.json\",\"data\":{\"values\":[{\"REGION\":\"NORTH_AMERICA\",\"SUM(SALES)\":\"2000.00\"},{\"REGION\":\"EUROPE\",\"SUM(SALES)\":\"1700.00\"},{\"REGION\":\"SAUTH_AMERICA\",\"SUM(SALES)\":\"1500.00\"}]},\"encoding\":{\"x\":{\"field\":\"REGION\",\"sort\":null,\"type\":\"nominal\"},\"y\":{\"field\":\"SUM(SALES)\",\"sort\":null,\"type\":\"quantitative\"}},\"mark\":\"bar\"}",
  }
}

-- Example 14621
{
  "type": "tool_use",
  "tool_use": {
    "tool_use_id": "tu_01",
    "name": "Analyst1",
    "input": {
      "query": "Show me sales by region for Q1 2024"
    }
  }
}

-- Example 14622
{
  "type": "tool_results",
  "tool_results": {
    "tool_use_id": "tu_01",
    "status": "success",
    "content": [
      {
        "type": "json",
        "json": {
          "sql": "SELECT region, SUM(sales) FROM sales_data WHERE quarter='Q1' AND year=2024 GROUP BY region"
          "text": "This is our interpretation of your question: Show me sales by region for Q1 2024. We have generated the following SQL query for you: SELECT region, SUM(sales) FROM sales_data WHERE quarter='Q1' AND year=2024 GROUP BY region"
        }
      }
    ]
  }
}

-- Example 14623
{
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "Show me sales by region for Q1 2024"
        }
      ]
    },
    {
      "role": "assistant",
      "content": [
        {
          "type": "tool_use",
          "tool_use": {
            "tool_use_id": "tu_01",
            "name": "Analyst1",
            "input": {
              "query": "Show me sales by region for Q1 2024"
            }
          }
        },
        {
          "type": "tool_results",
          "tool_results": {
            "tool_use_id": "tu_01",
            "name": "Analyst1",
            "status": "success",
            "content": [
              {
                "type": "json",
                "json": {
                  "sql": "SELECT region, SUM(sales) FROM sales_data WHERE quarter='Q1' AND year=2024 GROUP BY region"
                  "text": "This is our interpretation of your question: Show me sales by region for Q1 2024. We have generated the following SQL query for you: SELECT region, SUM(sales) FROM sales_data WHERE quarter='Q1' AND year=2024 GROUP BY region"
                }
              }
            ]
          }
        }
      ]
    }
  ]
}

-- Example 14624
{
  "model": "llama3.3-70b",
  "response_instruction": "You will always maintain a friendly tone and provide concise response.",
  "experimental": {},
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Analyst1"
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "Analyst2"
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
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "Search1"
      }
    }
  ],
  "tool_resources": {
    "Analyst1": { "semantic_model_file": "stage1"},
    "Analyst2": { "semantic_model_file": "stage2"},
    "Search1": {
      "name": "db.schema.service_name",
      "filter": {"@eq": {"region": "North America"} }
    }
  },
  "tool_choice": {
    "type": "auto"
  },
  "messages": [
    {
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": "What are the top three customers by revenue?"
        }
      ]
    },
    {
      "role": "assistant",
      "content": [
        {
          "type": "tool_use",
          "tool_use": {
            "tool_use_id": "tool_001",
            "name": "Analyst1",
            "input": {
              "messages": [
                "role:USER content:{text:{text:\"What are the top three customers by revenue?\"}}"
              ],
              "model": "snowflake-hosted-semantic",
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
                  "sql": "select * from table",
                  "text": "This is our interpretation of your question: What are the top three customers by revenue? \n\n"
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
    },
    {
      "role": "user",
      "content": [
        {
          "type": "tool_results",
          "tool_results": {
            "tool_use_id": "tool_002",
            "result": {
              "query_id": "01bbff92-0304-c8c7-0022-b7869a076c22"
            }
          }
        }
      ]
    }
  ]
}

-- Example 14625
{
  "id": "msg_001",
  "object": "message.delta",
  "delta": {
    "content": [
      {
        "index": 0,
        "type": "tool_use",
        "tool_use": {
          "tool_use_id": "toolu_XXXXXX",
          "name": "analyst1",
          "input": {
            "messages": [
              "role:USER content:{text:{text:\"count book id\"}}"
            ],
            "model": "snowflake-hosted-semantic",
            "experimental": ""
          }
        }
      },
      {
        "index": 0,
        "type": "tool_results",
        "tool_results": {
          "tool_use_id": "toolu_XXXXXX",
          "content": [
            {
              "type": "json",
              "json": {
                "suggestions": [],
                "sql": "WITH __books AS (\n  SELECT\n    book_id\n  FROM user_database.user_schema.user_table\n)\nSELECT\n  COUNT(book_id) AS book_count\nFROM __books\n -- Generated by Cortex Analyst\n;",
                "text": "This is our interpretation of your question:\n\n__Count the total number of books__ \n\n"
              }
            }
          ],
          "status": "success"
        }
      }
    ]
  }
}

-- Example 14626
REVOKE DATABASE ROLE SNOWFLAKE.CORTEX_USER
  FROM ROLE PUBLIC;

REVOKE IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE
  FROM ROLE PUBLIC;

-- Example 14627
USE ROLE ACCOUNTADMIN;

CREATE ROLE cortex_user_role;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE cortex_user_role;

GRANT ROLE cortex_user_role TO USER some_user;

-- Example 14628
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE analyst;

-- Example 14629
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'All';

-- Example 14630
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'mistral-large2,llama3.1-70b';

-- Example 14631
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'None';

-- Example 14632
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
  WHERE SERVICE_TYPE='AI_SERVICES';

-- Example 14633
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;

-- Example 14634
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY;

-- Example 14635
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_QUERY_USAGE_HISTORY
WHERE query_id='<query-id>';

-- Example 14636
SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-7b', 'Is a hot dog a sandwich'), SNOWFLAKE.CORTEX.COMPLETE('mistral-large', 'Is a hot dog a sandwich');

-- Example 14637
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

-- Example 14638
from snowflake.cortex import Complete,CompleteOptions

model_options1 = CompleteOptions(
    {'max_tokens':30}
)

print(Complete("llama3.1-8b", "how do snowflakes get their unique patterns?", options=model_options1))

-- Example 14639
from snowflake.cortex import Summarize
from snowflake.snowpark.functions import col

article_df = session.table("articles")
article_df = article_df.withColumn(
    "abstract_summary",
    Summarize(col("abstract_text"))
)
article_df.collect()

-- Example 14640
snow cortex complete "Is 5 more than 4? Please answer using one word without a period." -c "snowhouse"

-- Example 14641
snow cortex extract-answer "what is snowflake?" "snowflake is a company" -c "snowhouse"

-- Example 14642
snow cortex sentiment "Mary had a little Lamb" -c "snowhouse"

-- Example 14643
snow cortex summarize "John has a car. John's car is blue. John's car is old and John is thinking about buying a new car. There are a lot of cars to choose from and John cannot sleep because it's an important decision for John."

-- Example 14644
snow cortex translate herb --to pl

-- Example 14645
Snowflake Cortex gives you instant access to industry-leading large language models (LLMs) trained by researchers at companies like Anthropic, Mistral, Reka, Meta, and Google, including Snowflake Arctic, an open enterprise-grade model developed by Snowflake.

Since these LLMs are fully hosted and managed by Snowflake, using them requires no setup. Your data stays within Snowflake, giving you the performance, scalability, and governance you expect.

Snowflake Cortex features are provided as SQL functions and are also available in Python. The available functions are summarized below.

COMPLETE: Given a prompt, returns a response that completes the prompt. This function accepts either a single prompt or a conversation with multiple prompts and responses.
EMBED_TEXT_768: Given a piece of text, returns a vector embedding that represents that text.
EXTRACT_ANSWER: Given a question and unstructured data, returns the answer to the question if it can be found in the data.
SENTIMENT: Returns a sentiment score, from -1 to 1, representing the detected positive or negative sentiment of the given text.
SUMMARIZE: Returns a summary of the given text.
TRANSLATE: Translates given text from any supported language to any other.

-- Example 14646
snow cortex summarize --file about_cortex.txt

-- Example 14647
Snowflake Cortex offers instant access to industry-leading language models, including Snowflake Arctic, with SQL functions for completing prompts (COMPLETE), text embedding (EMBED\_TEXT\_768), extracting answers (EXTRACT\_ANSWER), sentiment analysis (SENTIMENT), summarizing text (SUMMARIZE), and translating text (TRANSLATE).

-- Example 14648
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 14649
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token=<oauth_token>

-- Example 14650
$ snowsql -a <account_identifier> -u <user> --authenticator=oauth --token="<oauth_token>"

-- Example 14651
USE ROLE ACCOUNTADMIN;

ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST_MODEL_AZURE_OPENAI = TRUE;

-- Example 14652
SHOW PARAMETERS LIKE 'ENABLE_CORTEX_ANALYST_MODEL_AZURE_OPENAI' IN ACCOUNT

