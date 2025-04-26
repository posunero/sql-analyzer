-- Example 27914
snow spcs --help

-- Example 27915
Usage: snow spcs [OPTIONS] COMMAND [ARGS]...

Manages Snowpark Container Services compute pools, services, image registries, and image repositories.

╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --help  -h        Show this message and exit.                                                                        │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ compute-pool       Manages compute pools.                                                                            │
│ image-registry     Manages image registries.                                                                         │
│ image-repository   Manages image repositories.                                                                       │
│ service            Manages services.                                                                                 │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

-- Example 27916
pip install --upgrade snowflake-cli

-- Example 27917
pip install --upgrade snowflake-cli

-- Example 27918
CREATE OR REPLACE PROCEDURE MYPROC(fromTable STRING, toTable STRING, count INT)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:latest')
  HANDLER = 'MyJavaClass.run'
  AS
  $$
    import com.snowflake.snowpark_java.*;

    public class MyJavaClass {
      public String run(Session session, String fromTable, String toTable, int count) {
        session.table(fromTable).limit(count).write().saveAsTable(toTable);
        return "SUCCESS";
      }
    }
  $$;

-- Example 27919
CREATE FUNCTION my_udf(i NUMBER)
  RETURNS NUMBER
  LANGUAGE JAVA
  IMPORTS = ('@mystage/handlers/my_handler.jar')
  HANDLER = 'MyClass.myFunction'

-- Example 27920
snow cortex complete
  <text>
  --model <model>
  --file <file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27921
snow cortex complete "Is 5 more than 4? Please answer using one word without a period." -c snowhouse

-- Example 27922
Yes

-- Example 27923
snow cortex complete "Is 5 more than 4? Please answer using one word without a period." -c snowhouse --model reka-flash

-- Example 27924
Yes

-- Example 27925
snow cortex extract-answer
  <question>
  <source_document_text>
  --file <file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27926
snow cortex extract-answer "what is snowflake?" "snowflake is a company" -c snowhouse

-- Example 27927
a company

-- Example 27928
snow cortex sentiment
  <text>
  --file <file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27929
snow cortex sentiment "Mary had a little Lamb" -c "snowhouse"

-- Example 27930
0.21522656

-- Example 27931
snow cortex summarize
  <text>
  --file <file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27932
snow cortex summarize "John has a car. John's car is blue. John's car is old and John is thinking about buying a new car. There are a lot of cars to choose from and John cannot sleep because it's an important decision for John."

-- Example 27933
John has an old blue car and is considering buying a new one due to the many options available, causing him sleepless nights.

-- Example 27934
Snowflake Cortex gives you instant access to industry-leading large language models (LLMs) trained by researchers at companies like Mistral, Reka, Meta, and Google, including Snowflake Arctic, an open enterprise-grade model developed by Snowflake.

Since these LLMs are fully hosted and managed by Snowflake, using them requires no setup. Your data stays within Snowflake, giving you the performance, scalability, and governance you expect.

Snowflake Cortex features are provided as SQL functions and are also available in Python. The available functions are summarized below.

COMPLETE: Given a prompt, returns a response that completes the prompt. This function accepts either a single prompt or a conversation with multiple prompts and responses.
EMBED_TEXT_768: Given a piece of text, returns a vector embedding that represents that text.
EXTRACT_ANSWER: Given a question and unstructured data, returns the answer to the question if it can be found in the data.
SENTIMENT: Returns a sentiment score, from -1 to 1, representing the detected positive or negative sentiment of the given text.
SUMMARIZE: Returns a summary of the given text.
TRANSLATE: Translates given text from any supported language to any other.

-- Example 27935
snow cortex summarize --file about_cortex.txt

-- Example 27936
Snowflake Cortex offers instant access to industry-leading language models, including Snowflake Arctic, with SQL functions for completing prompts (COMPLETE), text embedding (EMBED\_TEXT\_768), extracting answers (EXTRACT\_ANSWER), sentiment analysis (SENTIMENT), summarizing text (SUMMARIZE), and translating text (TRANSLATE).

-- Example 27937
snow cortex translate
  <text>
  --from <from_language>
  --to <to_language>
  --file <file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27938
snow cortex translate herb --to pl

-- Example 27939
ziołowy

-- Example 27940
snow cortex translate herb --from pl --to en

-- Example 27941
coat of arms

-- Example 27942
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

-- Example 27943
{
    "response_instruction": "You will always maintain a friendly tone and provide concise response"
}

-- Example 27944
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

-- Example 27945
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

-- Example 27946
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

-- Example 27947
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

-- Example 27948
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

-- Example 27949
from snowflake.snowpark.context import get_active_session
from snowflake.ml.data.data_connector import DataConnector
import pandas as pd
import xgboost as xgb
from sklearn.model_selection import train_test_split

session = get_active_session()

# Use the DataConnector API to pull in large data efficiently
df = session.table("my_dataset")
pandas_df = DataConnector.from_dataframe(df).to_pandas()

# Build with open source

X = df_pd[['feature1', 'feature2']]
y = df_pd['label']

# Split data into test and train in memory
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=34)

# Train in memory
model = xgb.XGBClassifier()
model.fit(X_train, y_train)

# Predict
y_pred = model.predict(X_test)

-- Example 27950
# Top-level Header

-- Example 27951
## 2nd-level Header

-- Example 27952
### 3rd-level Header

-- Example 27953
*italicized text*

-- Example 27954
**bolded text**

-- Example 27955
[Link text](url)

-- Example 27956
1. first item
2. second item
  1. Nested first
  2. Nested second

-- Example 27957
- first item
- second item
  - Nested first
  - Nested second

-- Example 27958
```python
import pandas as pd
df = pd.DataFrame([1,2,3])
```

-- Example 27959
```sql
SELECT * FROM MYTABLE
```

-- Example 27960
![<alt_text>](<path_to_image>)

-- Example 27961
SELECT 'FRIDAY' as SNOWDAY, 0.2 as CHANCE_OF_SNOW
UNION ALL
SELECT 'SATURDAY',0.5
UNION ALL
SELECT 'SUNDAY', 0.9;

-- Example 27962
snowpark_df = cell1.to_df()

-- Example 27963
my_df = cell1.to_pandas()

-- Example 27964
SELECT * FROM {{cell2}} where PRICE > 500

-- Example 27965
c = "USA"

-- Example 27966
SELECT * FROM my_table WHERE COUNTRY = '{{c}}'

-- Example 27967
column_name = "COUNTRY"

-- Example 27968
SELECT * FROM my_table WHERE {{column_name}} = 'USA'

-- Example 27969
from snowflake.snowpark.context import get_active_session
session = get_active_session()
code_to_run = """
BEGIN
    CALL TRANSACTION_ANOMALY_MODEL!DETECT_ANOMALIES(
        INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'ANOMALY_INFERENCE'),
        TIMESTAMP_COLNAME =>'DATE',
        TARGET_COLNAME => 'TRANSACTION_AMOUNT',
        CONFIG_OBJECT => {'prediction_interval': 0.95}
    );

    LET x := SQLID;
    CREATE TABLE ANOMALY_PREDICTIONS AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;
"""
data = session.sql(code_to_run).collect(block=True);

-- Example 27970
CREATE OR REPLACE NETWORK RULE pypi_network_rule
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org',  'files.pythonhosted.org');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION pypi_access_integration
ALLOWED_NETWORK_RULES = (pypi_network_rule)
ENABLED = true;

-- Example 27971
CREATE OR REPLACE NETWORK RULE hf_network_rule
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('huggingface.co', 'cdn-lfs.huggingface.co');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION hf_access_integration
ALLOWED_NETWORK_RULES = (hf_network_rule)
ENABLED = true;

-- Example 27972
CREATE OR REPLACE NETWORK RULE allow_all_rule
MODE= 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION allow_all_integration
ALLOWED_NETWORK_RULES = (allow_all_rule)
ENABLED = true;

-- Example 27973
GRANT USAGE ON INTEGRATION pypi_access_integration TO ROLE my_notebook_role;
GRANT USAGE ON INTEGRATION hf_access_integration TO ROLE my_notebook_role;
GRANT USAGE ON INTEGRATION allow_all_integration TO ROLE my_notebook_role;

-- Example 27974
ALTER NOTEBOOK <name>
 SET SECRETS = ('<secret_variable_name>' = <secret_name>);

-- Example 27975
from snowflake.snowpark import Session

-- Example 27976
vi connections.toml

-- Example 27977
[myconnection]
account = "myaccount"
user = "jdoe"
password = "******"
warehouse = "my-wh"
database = "my_db"
schema = "my_schema"

-- Example 27978
[myconnection_test]
account = "myaccount"
user = "jdoe-test"
password = "******"
warehouse = "my-test_wh"
database = "my_test_db"
schema = "my_schema"

-- Example 27979
session = Session.builder.config("connection_name", "myconnection").create()

-- Example 27980
connection_parameters = {
  "account": "<your snowflake account>",
  "user": "<your snowflake user>",
  "password": "<your snowflake password>",
  "role": "<your snowflake role>",  # optional
  "warehouse": "<your snowflake warehouse>",  # optional
  "database": "<your snowflake database>",  # optional
  "schema": "<your snowflake schema>",  # optional
}

new_session = Session.builder.configs(connection_parameters).create()

