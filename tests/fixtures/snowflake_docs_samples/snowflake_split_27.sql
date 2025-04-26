-- Example 1769
url = f'{snowflake_account_url}/oauth/token'
response = requests.post(url, data=data)
assert 200 == response.status_code, "unable to get Snowflake token"
return response.text

-- Example 1770
headers = {'Authorization': f'Snowflake Token="{token}"'}
response = requests.post(f'{url}', headers=headers)

-- Example 1771
from flask import Flask
from flask import request
from flask import make_response
from flask import render_template
import logging
import os
import sys

SERVICE_HOST = os.getenv('SERVER_HOST', '0.0.0.0')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')


def get_logger(logger_name):
  logger = logging.getLogger(logger_name)
  logger.setLevel(logging.DEBUG)
  handler = logging.StreamHandler(sys.stdout)
  handler.setLevel(logging.DEBUG)
  handler.setFormatter(
    logging.Formatter(
      '%(name)s [%(asctime)s] [%(levelname)s] %(message)s'))
  logger.addHandler(handler)
  return logger


logger = get_logger('echo-service')

app = Flask(__name__)


@app.get("/healthcheck")
def readiness_probe():
  return "I'm ready!"


@app.post("/echo")
def echo():
  '''
  Main handler for input data sent by Snowflake.
  '''
  message = request.json
  logger.debug(f'Received request: {message}')

  if message is None or not message['data']:
    logger.info('Received empty message')
    return {}

  # input format:
  #   {"data": [
  #     [row_index, column_1_value, column_2_value, ...],
  #     ...
  #   ]}
  input_rows = message['data']
  logger.info(f'Received {len(input_rows)} rows')

  # output format:
  #   {"data": [
  #     [row_index, column_1_value, column_2_value, ...}],
  #     ...
  #   ]}
  output_rows = [[row[0], get_echo_response(row[1])] for row in input_rows]
  logger.info(f'Produced {len(output_rows)} rows')

  response = make_response({"data": output_rows})
  response.headers['Content-type'] = 'application/json'
  logger.debug(f'Sending response: {response.json}')
  return response


@app.route("/ui", methods=["GET", "POST"])
def ui():
  '''
  Main handler for providing a web UI.
  '''
  if request.method == "POST":
    # getting input in HTML form
    input_text = request.form.get("input")
    # display input and output
    return render_template("basic_ui.html",
      echo_input=input_text,
      echo_reponse=get_echo_response(input_text))
  return render_template("basic_ui.html")


def get_echo_response(input):
  return f'{CHARACTER_NAME} said {input}'

if __name__ == '__main__':
  app.run(host=SERVICE_HOST, port=SERVER_PORT)

-- Example 1772
@app.post("/echo")
def echo():

-- Example 1773
@app.route("/ui", methods=["GET", "POST"])
def ui():

-- Example 1774
@app.get("/healthcheck")
def readiness_probe():

-- Example 1775
ARG BASE_IMAGE=python:3.10-slim-buster
FROM $BASE_IMAGE
COPY echo_service.py ./
COPY templates/ ./templates/
RUN pip install --upgrade pip && \\
pip install flask
CMD ["python", "echo_service.py"]

-- Example 1776
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Welcome to echo service!</title>
  </head>
  <body>
    <h1>Welcome to echo service!</h1>
    <form action="{{ url_for("ui") }}" method="post">
      <label for="input">Input:<label><br>
      <input type="text" id="input" name="input"><br>
    </form>
    <h2>Input:</h2>
    {{ echo_input }}
    <h2>Output:</h2>
    {{ echo_reponse }}
  </body>
</html>

-- Example 1777
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
    env:
      SERVER_PORT: 8000
      CHARACTER_NAME: Bob
    readinessProbe:
      port: 8000
      path: /healthcheck
  endpoints:
  - name: echoendpoint
    port: 8000
    public: true

-- Example 1778
CHARACTER_NAME = os.getenv('CHARACTER_NAME', 'I')
SERVER_PORT = os.getenv('SERVER_PORT', 8080)

-- Example 1779
@app.get("/healthcheck")
def readiness_probe():

-- Example 1780
CREATE FUNCTION my_echo_udf (InputText VARCHAR)
  RETURNS VARCHAR
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 1781
docker build --rm -t my_service:local .

-- Example 1782
docker run --rm -p 8080:8080 my_service:local

-- Example 1783
curl -X POST http://localhost:8080/echo \
  -H "Content-Type: application/json" \
  -d '{"data":[[0, "Hello friend"], [1, "Hello World"]]}'

-- Example 1784
{"data":[[0,"I said Hello Friend"],[1,"I said Hello World"]]}

-- Example 1785
{
  "name": "demo_db",
  "kind": "PERMANENT",
  "comment": "snowflake rest api demo-db",
  "data_retention_time_in_days": "1",
  "max_data_extension_time_in_days": "1"
}

-- Example 1786
{
  "name": "demo_sc",
}

-- Example 1787
{
  "name": "demo_tbl",
  "columns": [
    {
    "name": "c1",
    "datatype": "integer",
    "nullable": true,
    "comment": "An integral value column"
    }
  ],
  "comment": "Demo table for Snowflake REST API"
}

-- Example 1788
{
  "name": "demo_tbl",
  "columns": [
    {
    "name": "c1",
    "datatype": "integer",
    "nullable": true,
    "comment": "An integral value column"
    },
    {
    "name": "c2",
    "datatype": "string",
    "comment": "An string value column"
    }
  ],
  "comment": "Demo table for Snowflake REST API"
}

-- Example 1789
CREATE DATABASE IF NOT EXISTS cortex_search_tutorial_db;

CREATE OR REPLACE WAREHOUSE cortex_search_tutorial_wh WITH
    WAREHOUSE_SIZE='X-SMALL'
    AUTO_SUSPEND = 120
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED=TRUE;

USE WAREHOUSE cortex_search_tutorial_wh;

-- Example 1790
CREATE OR REPLACE STAGE books_data_stage
    DIRECTORY = (ENABLE = TRUE)
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 1791
CREATE OR REPLACE FUNCTION cortex_search_tutorial_db.public.books_chunk(
    description string, title string, authors string, category string, publisher string
)
    returns table (chunk string, title string, authors string, category string, publisher string)
    language python
    runtime_version = '3.9'
    handler = 'text_chunker'
    packages = ('snowflake-snowpark-python','langchain')
    as
$$
from langchain.text_splitter import RecursiveCharacterTextSplitter
import copy
from typing import Optional

class text_chunker:

    def process(self, description: Optional[str], title: str, authors: str, category: str, publisher: str):
        if description == None:
            description = "" # handle null values

        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size = 2000,
            chunk_overlap  = 300,
            length_function = len
        )
        chunks = text_splitter.split_text(description)
        for chunk in chunks:
            yield (title + "\n" + authors + "\n" + chunk, title, authors, category, publisher) # always chunk with title
$$;

-- Example 1792
CREATE TABLE cortex_search_tutorial_db.public.book_description_chunks AS (
    SELECT
        books.*,
        t.CHUNK as CHUNK
    FROM cortex_search_tutorial_db.public.books_dataset_raw books,
        TABLE(cortex_search_tutorial_db.public.books_chunk(books.description, books.title, books.authors, books.category, books.publisher)) t
);

-- Example 1793
SELECT chunk, * FROM book_description_chunks LIMIT 10;

-- Example 1794
CREATE CORTEX SEARCH SERVICE cortex_search_tutorial_db.public.books_dataset_service
    ON CHUNK
    WAREHOUSE = cortex_search_tutorial_wh
    TARGET_LAG = '1 hour'
    AS (
        SELECT *
        FROM cortex_search_tutorial_db.public.book_description_chunks
    );

-- Example 1795
import streamlit as st
from snowflake.core import Root # requires snowflake>=0.8.0
from snowflake.snowpark.context import get_active_session

MODELS = [
    "mistral-large",
    "snowflake-arctic",
    "llama3-70b",
    "llama3-8b",
]

def init_messages():
    """
    Initialize the session state for chat messages. If the session state indicates that the
    conversation should be cleared or if the "messages" key is not in the session state,
    initialize it as an empty list.
    """
    if st.session_state.clear_conversation or "messages" not in st.session_state:
        st.session_state.messages = []

def init_service_metadata():
    """
    Initialize the session state for cortex search service metadata. Query the available
    cortex search services from the Snowflake session and store their names and search
    columns in the session state.
    """
    if "service_metadata" not in st.session_state:
        services = session.sql("SHOW CORTEX SEARCH SERVICES;").collect()
        service_metadata = []
        if services:
            for s in services:
                svc_name = s["name"]
                svc_search_col = session.sql(
                    f"DESC CORTEX SEARCH SERVICE {svc_name};"
                ).collect()[0]["search_column"]
                service_metadata.append(
                    {"name": svc_name, "search_column": svc_search_col}
                )

        st.session_state.service_metadata = service_metadata

def init_config_options():
    """
    Initialize the configuration options in the Streamlit sidebar. Allow the user to select
    a cortex search service, clear the conversation, toggle debug mode, and toggle the use of
    chat history. Also provide advanced options to select a model, the number of context chunks,
    and the number of chat messages to use in the chat history.
    """
    st.sidebar.selectbox(
        "Select cortex search service:",
        [s["name"] for s in st.session_state.service_metadata],
        key="selected_cortex_search_service",
    )

    st.sidebar.button("Clear conversation", key="clear_conversation")
    st.sidebar.toggle("Debug", key="debug", value=False)
    st.sidebar.toggle("Use chat history", key="use_chat_history", value=True)

    with st.sidebar.expander("Advanced options"):
        st.selectbox("Select model:", MODELS, key="model_name")
        st.number_input(
            "Select number of context chunks",
            value=5,
            key="num_retrieved_chunks",
            min_value=1,
            max_value=10,
        )
        st.number_input(
            "Select number of messages to use in chat history",
            value=5,
            key="num_chat_messages",
            min_value=1,
            max_value=10,
        )

    st.sidebar.expander("Session State").write(st.session_state)

def query_cortex_search_service(query):
    """
    Query the selected cortex search service with the given query and retrieve context documents.
    Display the retrieved context documents in the sidebar if debug mode is enabled. Return the
    context documents as a string.

    Args:
        query (str): The query to search the cortex search service with.

    Returns:
        str: The concatenated string of context documents.
    """
    db, schema = session.get_current_database(), session.get_current_schema()

    cortex_search_service = (
        root.databases[db]
        .schemas[schema]
        .cortex_search_services[st.session_state.selected_cortex_search_service]
    )

    context_documents = cortex_search_service.search(
        query, columns=[], limit=st.session_state.num_retrieved_chunks
    )
    results = context_documents.results

    service_metadata = st.session_state.service_metadata
    search_col = [s["search_column"] for s in service_metadata
                    if s["name"] == st.session_state.selected_cortex_search_service][0]

    context_str = ""
    for i, r in enumerate(results):
        context_str += f"Context document {i+1}: {r[search_col]} \n" + "\n"

    if st.session_state.debug:
        st.sidebar.text_area("Context documents", context_str, height=500)

    return context_str

def get_chat_history():
    """
    Retrieve the chat history from the session state limited to the number of messages specified
    by the user in the sidebar options.

    Returns:
        list: The list of chat messages from the session state.
    """
    start_index = max(
        0, len(st.session_state.messages) - st.session_state.num_chat_messages
    )
    return st.session_state.messages[start_index : len(st.session_state.messages) - 1]

def complete(model, prompt):
    """
    Generate a completion for the given prompt using the specified model.

    Args:
        model (str): The name of the model to use for completion.
        prompt (str): The prompt to generate a completion for.

    Returns:
        str: The generated completion.
    """
    return session.sql("SELECT snowflake.cortex.complete(?,?)", (model, prompt)).collect()[0][0]

def make_chat_history_summary(chat_history, question):
    """
    Generate a summary of the chat history combined with the current question to extend the query
    context. Use the language model to generate this summary.

    Args:
        chat_history (str): The chat history to include in the summary.
        question (str): The current user question to extend with the chat history.

    Returns:
        str: The generated summary of the chat history and question.
    """
    prompt = f"""
        [INST]
        Based on the chat history below and the question, generate a query that extend the question
        with the chat history provided. The query should be in natural language.
        Answer with only the query. Do not add any explanation.

        <chat_history>
        {chat_history}
        </chat_history>
        <question>
        {question}
        </question>
        [/INST]
    """

    summary = complete(st.session_state.model_name, prompt)

    if st.session_state.debug:
        st.sidebar.text_area(
            "Chat history summary", summary.replace("$", "\$"), height=150
        )

    return summary

def create_prompt(user_question):
    """
    Create a prompt for the language model by combining the user question with context retrieved
    from the cortex search service and chat history (if enabled). Format the prompt according to
    the expected input format of the model.

    Args:
        user_question (str): The user's question to generate a prompt for.

    Returns:
        str: The generated prompt for the language model.
    """
    if st.session_state.use_chat_history:
        chat_history = get_chat_history()
        if chat_history != []:
            question_summary = make_chat_history_summary(chat_history, user_question)
            prompt_context = query_cortex_search_service(question_summary)
        else:
            prompt_context = query_cortex_search_service(user_question)
    else:
        prompt_context = query_cortex_search_service(user_question)
        chat_history = ""

    prompt = f"""
            [INST]
            You are a helpful AI chat assistant with RAG capabilities. When a user asks you a question,
            you will also be given context provided between <context> and </context> tags. Use that context
            with the user's chat history provided in the between <chat_history> and </chat_history> tags
            to provide a summary that addresses the user's question. Ensure the answer is coherent, concise,
            and directly relevant to the user's question.

            If the user asks a generic question which cannot be answered with the given context or chat_history,
            just say "I don't know the answer to that question.

            Don't saying things like "according to the provided context".

            <chat_history>
            {chat_history}
            </chat_history>
            <context>
            {prompt_context}
            </context>
            <question>
            {user_question}
            </question>
            [/INST]
            Answer:
        """
    return prompt

def main():
    st.title(f":speech_balloon: Chatbot with Snowflake Cortex")

    init_service_metadata()
    init_config_options()
    init_messages()

    icons = {"assistant": "❄️", "user": "👤"}

    # Display chat messages from history on app rerun
    for message in st.session_state.messages:
        with st.chat_message(message["role"], avatar=icons[message["role"]]):
            st.markdown(message["content"])

    disable_chat = (
        "service_metadata" not in st.session_state
        or len(st.session_state.service_metadata) == 0
    )
    if question := st.chat_input("Ask a question...", disabled=disable_chat):
        # Add user message to chat history
        st.session_state.messages.append({"role": "user", "content": question})
        # Display user message in chat message container
        with st.chat_message("user", avatar=icons["user"]):
            st.markdown(question.replace("$", "\$"))

        # Display assistant response in chat message container
        with st.chat_message("assistant", avatar=icons["assistant"]):
            message_placeholder = st.empty()
            question = question.replace("'", "")
            with st.spinner("Thinking..."):
                generated_response = complete(
                    st.session_state.model_name, create_prompt(question)
                )
                message_placeholder.markdown(generated_response)

        st.session_state.messages.append(
            {"role": "assistant", "content": generated_response}
        )

if __name__ == "__main__":
    session = get_active_session()
    root = Root(session)
    main()

-- Example 1796
DROP DATABASE IF EXISTS cortex_search_tutorial_db;
DROP WAREHOUSE IF EXISTS cortex_search_tutorial_wh;

-- Example 1797
SHOW IMAGE REPOSITORIES;

-- Example 1798
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 1799
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 1800
docker build --rm --platform linux/amd64 -t <repository_url>/<image_name> .

-- Example 1801
docker build --rm --platform linux/amd64 -t myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_job_image:latest .

-- Example 1802
docker login <registry_hostname> -u <username>

-- Example 1803
docker push <repository_url>/<image_name>

-- Example 1804
docker push myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_job_image:latest

-- Example 1805
PUT file://<file-path>[/\]my_job_spec.yaml @tutorial_stage
  AUTO_COMPRESS=FALSE
  OVERWRITE=TRUE;

-- Example 1806
PUT file:///tmp/my_job_spec.yaml @tutorial_stage
  AUTO_COMPRESS=FALSE
  OVERWRITE=TRUE;

-- Example 1807
PUT file://C:\temp\my_job_spec.yaml @tutorial_stage
  AUTO_COMPRESS=FALSE
  OVERWRITE=TRUE;

-- Example 1808
PUT file://./my_job_spec.yaml @tutorial_stage
  AUTO_COMPRESS=FALSE
  OVERWRITE=TRUE;

-- Example 1809
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME=tutorial_2_job_service
  FROM @tutorial_stage
  SPEC='my_job_spec.yaml';

-- Example 1810
+------------------------------------------------------------------------------------+
|                      status                                                        |
-------------------------------------------------------------------------------------+
| Job TUTORIAL_2_JOB_SERVICE completed successfully with status: DONE.               |
+------------------------------------------------------------------------------------+

-- Example 1811
SELECT * FROM results;

-- Example 1812
+----------+-----------+
| TIME     | TEXT      |
|----------+-----------|
| 10:56:52 | hello     |
+----------+-----------+

-- Example 1813
SHOW SERVICE CONTAINERS IN SERVICE tutorial_2_job_service;

-- Example 1814
+---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------+
| database_name | schema_name | service_name           | instance_id | container_name | status | message                | image_name                                                                                                                             | image_digest                                                            | restart_count | start_time |
|---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------|
| TUTORIAL_DB   | DATA_SCHEMA | TUTORIAL_2_JOB_SERVICE | 0           | main           | DONE   | Completed successfully | myorg-myacct.registry.snowflakecomputing.com/tutorial_db/tutorial_db/data_schema/tutorial_repository/my_job_image:latest | sha256:aa3fa2e5c1552d16904a5bbc97d400316ebb4a608bb110467410485491d9d8d0 |             0 |            |
+---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------+

-- Example 1815
SELECT SYSTEM$GET_SERVICE_LOGS('tutorial_2_job_service', 0, 'main')

-- Example 1816
job-tutorial - INFO - Job started
job-tutorial - INFO - Connection succeeded. Current session context: database="TUTORIAL_DB", schema="DATA_SCHEMA", warehouse="TUTORIAL_WAREHOUSE", role="TEST_ROLE"
job-tutorial - INFO - Executing query [select current_time() as time,'hello'] and writing result to table [results]
job-tutorial - INFO - Job finished

-- Example 1817
#!/opt/conda/bin/python3

import argparse
import logging
import os
import sys

from snowflake.snowpark import Session
from snowflake.snowpark.exceptions import *

# Environment variables below will be automatically populated by Snowflake.
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_HOST = os.getenv("SNOWFLAKE_HOST")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE")
SNOWFLAKE_SCHEMA = os.getenv("SNOWFLAKE_SCHEMA")

# Custom environment variables
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")


def get_arg_parser():
  """
  Input argument list.
  """
  parser = argparse.ArgumentParser()
  parser.add_argument("--query", required=True, help="query text to execute")
  parser.add_argument(
    "--result_table",
    required=True,
    help="name of the table to store result of query specified by flag --query")

  return parser


def get_logger():
  """
  Get a logger for local logging.
  """
  logger = logging.getLogger("job-tutorial")
  logger.setLevel(logging.DEBUG)
  handler = logging.StreamHandler(sys.stdout)
  handler.setLevel(logging.DEBUG)
  formatter = logging.Formatter("%(name)s - %(levelname)s - %(message)s")
  handler.setFormatter(formatter)
  logger.addHandler(handler)
  return logger


def get_login_token():
  """
  Read the login token supplied automatically by Snowflake. These tokens
  are short lived and should always be read right before creating any new connection.
  """
  with open("/snowflake/session/token", "r") as f:
    return f.read()


def get_connection_params():
  """
  Construct Snowflake connection params from environment variables.
  """
  if os.path.exists("/snowflake/session/token"):
    return {
      "account": SNOWFLAKE_ACCOUNT,
      "host": SNOWFLAKE_HOST,
      "authenticator": "oauth",
      "token": get_login_token(),
      "warehouse": SNOWFLAKE_WAREHOUSE,
      "database": SNOWFLAKE_DATABASE,
      "schema": SNOWFLAKE_SCHEMA
    }
  else:
    return {
      "account": SNOWFLAKE_ACCOUNT,
      "host": SNOWFLAKE_HOST,
      "user": SNOWFLAKE_USER,
      "password": SNOWFLAKE_PASSWORD,
      "role": SNOWFLAKE_ROLE,
      "warehouse": SNOWFLAKE_WAREHOUSE,
      "database": SNOWFLAKE_DATABASE,
      "schema": SNOWFLAKE_SCHEMA
    }

def run_job():
  """
  Main body of this job.
  """
  logger = get_logger()
  logger.info("Job started")

  # Parse input arguments
  args = get_arg_parser().parse_args()
  query = args.query
  result_table = args.result_table

  # Start a Snowflake session, run the query and write results to specified table
  with Session.builder.configs(get_connection_params()).create() as session:
    # Print out current session context information.
    database = session.get_current_database()
    schema = session.get_current_schema()
    warehouse = session.get_current_warehouse()
    role = session.get_current_role()
    logger.info(
      f"Connection succeeded. Current session context: database={database}, schema={schema}, warehouse={warehouse}, role={role}"
    )

    # Execute query and persist results in a table.
    logger.info(
      f"Executing query [{query}] and writing result to table [{result_table}]"
    )
    res = session.sql(query)
    # If the table already exists, the query result must match the table scheme.
    # If the table does not exist, this will create a new table.
    res.write.mode("append").save_as_table(result_table)

  logger.info("Job finished")


if __name__ == "__main__":
  run_job()

-- Example 1818
if __name__ == "__main__":
  run_job()

-- Example 1819
ARG BASE_IMAGE=continuumio/miniconda3:4.12.0
FROM $BASE_IMAGE
RUN conda install python=3.9 && \
  conda install snowflake-snowpark-python
COPY main.py ./
ENTRYPOINT ["python3", "main.py"]

-- Example 1820
spec:
  containers:
  - name: main
    image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
    env:
      SNOWFLAKE_WAREHOUSE: tutorial_warehouse
    args:
    - "--query=select current_time() as time,'hello'"
    - "--result_table=results"

-- Example 1821
docker build --rm -t my_service:local .

-- Example 1822
docker run --rm \
  -e SNOWFLAKE_ACCOUNT=<orgname>-<acctname> \
  -e SNOWFLAKE_HOST=<orgname>-<acctname>.snowflakecomputing.com \
  -e SNOWFLAKE_DATABASE=tutorial_db \
  -e SNOWFLAKE_SCHEMA=data_schema \
  -e SNOWFLAKE_ROLE=test_role \
  -e SNOWFLAKE_USER=<username> \
  -e SNOWFLAKE_PASSWORD=<password> \
  -e SNOWFLAKE_WAREHOUSE=tutorial_warehouse \
  my_job:local \
  --query="select current_time() as time,'hello'" \
  --result_table=tutorial_db.data_schema.results

-- Example 1823
+----------+----------+
| TIME     | TEXT     |
|----------+----------|
| 10:56:52 | hello    |
+----------+----------+

-- Example 1824
CREATE ROLE tutorial_role;

-- Example 1825
GRANT ROLE tutorial_role TO USER <user_name>;

-- Example 1826
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE tutorial_role;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE tutorial_role;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE tutorial_role;
GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE tutorial_role;
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE tutorial_role;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE tutorial_role WITH GRANT OPTION;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE tutorial_role WITH GRANT OPTION;

-- Example 1827
USE ROLE tutorial_role;

-- Example 1828
CREATE OR REPLACE WAREHOUSE tutorial_warehouse WITH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 180
  AUTO_RESUME = true
  INITIALLY_SUSPENDED = false;

-- Example 1829
CREATE DATABASE tutorial_image_database;
CREATE SCHEMA tutorial_image_schema;
CREATE IMAGE REPOSITORY tutorial_image_repo;

-- Example 1830
snow connection add

-- Example 1831
snow connection test -c tut-connection

-- Example 1832
+----------------------------------------------------------------------------------+
| key             | value                                                          |
|-----------------+----------------------------------------------------------------|
| Connection name | tut-connection                                                 |
| Status          | OK                                                             |
| Host            | USER_ACCOUNT.snowflakecomputing.com                            |
| Account         | USER_ACCOUNT                                                   |
| User            | tutorial_user                                                  |
| Role            | TUTORIAL_ROLE                                                  |
| Database        | TUTORIAL_IMAGE_DATABASE                                        |
| Warehouse       | TUTORIAL_WAREHOUSE                                             |
+----------------------------------------------------------------------------------+

-- Example 1833
snow init --template app_basic na-spcs-tutorial

-- Example 1834
├── README.md
├── app
    └── manifest.yml
    └── README.md
    └── setup_script.sql
├── snowflake.yml

-- Example 1835
├── app
      └── manifest.yml
      └── README.md
      └── setup_script.sql
├── README.md
├── service
      └── echo_service.py
      ├── echo_spec.yaml
      ├── Dockerfile
      └── templates
         └── basic_ui.html
├── snowflake.yml

-- Example 1836
docker build --rm --platform linux/amd64 -t my_echo_service_image:tutorial .

