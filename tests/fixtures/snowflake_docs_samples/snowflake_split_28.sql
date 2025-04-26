-- Example 1837
REPO_URL=$(snow spcs image-repository url tutorial_image_database.tutorial_image_schema.tutorial_image_repo -c tut-connection)
echo $REPO_URL

-- Example 1838
docker tag <image_name> <image_url>/<image_name>

-- Example 1839
docker tag my_echo_service_image:tutorial $REPO_URL/my_echo_service_image:tutorial

-- Example 1840
snow spcs image-registry login -c tut-connection

-- Example 1841
docker push $REPO_URL/<image_name>

-- Example 1842
docker push $REPO_URL/my_echo_service_image:tutorial

-- Example 1843
snow spcs image-repository list-images tutorial_image_database.tutorial_image_schema.tutorial_image_repo -c tut-connection

-- Example 1844
manifest_version: 1

artifacts:
   setup_script: setup_script.sql
   readme: README.md
   container_services:
      images:
      - /tutorial_image_database/tutorial_image_schema/tutorial_image_repo/my_echo_service_image:tutorial

privileges:
- BIND SERVICE ENDPOINT:
     description: "A service that can respond to requests from public endpoints."
- CREATE COMPUTE POOL:
     description: "Permission to create compute pools for running services"

-- Example 1845
CREATE APPLICATION ROLE IF NOT EXISTS app_user;

CREATE SCHEMA IF NOT EXISTS core;
GRANT USAGE ON SCHEMA core TO APPLICATION ROLE app_user;

CREATE OR ALTER VERSIONED SCHEMA app_public;
GRANT USAGE ON SCHEMA app_public TO APPLICATION ROLE app_user;

CREATE OR REPLACE PROCEDURE app_public.start_app()
   RETURNS string
   LANGUAGE sql
   AS
$$
BEGIN
   -- account-level compute pool object prefixed with app name to prevent clashes
   LET pool_name := (SELECT CURRENT_DATABASE()) || '_compute_pool';

   CREATE COMPUTE POOL IF NOT EXISTS IDENTIFIER(:pool_name)
      MIN_NODES = 1
      MAX_NODES = 1
      INSTANCE_FAMILY = CPU_X64_XS
      AUTO_RESUME = true;

   CREATE SERVICE IF NOT EXISTS core.echo_service
      IN COMPUTE POOL identifier(:pool_name)
      FROM spec='service/echo_spec.yaml';

   CREATE OR REPLACE FUNCTION core.my_echo_udf (TEXT VARCHAR)
      RETURNS varchar
      SERVICE=core.echo_service
      ENDPOINT=echoendpoint
      AS '/echo';

   GRANT USAGE ON FUNCTION core.my_echo_udf (varchar) TO APPLICATION ROLE app_user;

   RETURN 'Service successfully created';
END;
$$;

GRANT USAGE ON PROCEDURE app_public.start_app() TO APPLICATION ROLE app_user;

CREATE OR REPLACE PROCEDURE app_public.service_status()
RETURNS TABLE ()
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
   BEGIN
         LET stmt VARCHAR := 'SHOW SERVICE CONTAINERS IN SERVICE core.echo_service';
         LET res RESULTSET := (EXECUTE IMMEDIATE :stmt);
         RETURN TABLE(res);
   END;
$$;

GRANT USAGE ON PROCEDURE app_public.service_status() TO APPLICATION ROLE app_user;

-- Example 1846
Welcome to your first app with containers!

-- Example 1847
definition_version: 2
entities:
   na_spcs_tutorial_pkg:
      type: application package
      manifest: app/manifest.yml
      artifacts:
         - src: app/*
           dest: ./
         - service/echo_spec.yaml
      meta:
         role: tutorial_role
         warehouse: tutorial_warehouse
   na_spcs_tutorial_app:
      type: application
      from:
         target: na_spcs_tutorial_pkg
      debug: false
      meta:
         role: tutorial_role
         warehouse: tutorial_warehouse

-- Example 1848
snow app run -c tut-connection

-- Example 1849
GRANT CREATE COMPUTE POOL ON ACCOUNT TO APPLICATION na_spcs_tutorial_app;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO APPLICATION na_spcs_tutorial_app;

-- Example 1850
CALL na_spcs_tutorial_app.app_public.start_app();

-- Example 1851
SHOW FUNCTIONS LIKE '%my_echo_udf%' IN APPLICATION na_spcs_tutorial_app;

-- Example 1852
CALL na_spcs_tutorial_app.app_public.service_status();

-- Example 1853
SELECT na_spcs_tutorial_app.core.my_echo_udf('hello');

-- Example 1854
``Bob said hello``

-- Example 1855
snow object list compute-pool -l "na_spcs_tutorial_app_%"

-- Example 1856
snow app teardown --cascade --force -c tut-connection

-- Example 1857
snow object list compute-pool -l "na_spcs_tutorial_app_%"

-- Example 1858
{
  "name": "demo_wh",
  "warehouse_size": "xsmall"
}

-- Example 1859
{
  "name": "{{test_task_name}}",
  "definition": "SELECT 1",
  "warehouse": "{{default_wh}}",
  "schedule": {"minutes": 2, "schedule_type": "MINUTES_TYPE"},
  "config": {"consecteture": false, "sed_9": 61393640, "doloref3": -85761000},
  "comment": "comment",
  "session_parameters": {
    "TIMEZONE": "America/Los Angeles",
    "AUTOCOMMIT": true
  },
  "error_integration": null,
  "user_task_managed_initial_warehouse_size": null,
  "predecessors": null,
  "task_auto_retry_attempts": 3,
  "user_task_timeout_ms": 10000,
  "suspend_task_after_num_failures": 3,
  "condition": true,
  "allow_overlapping_execution": false
}

-- Example 1860
{
  "name": "test_child_task",
  "definition": "SELECT 1",
  "warehouse": "{{default_wh}}",
  "predecessors": "{{test_task_name}}"
}

-- Example 1861
database = root.databases.create(
  Database(
    name="PYTHON_API_DB"),
    mode=CreateMode.or_replace
  )

schema = database.schemas.create(
  Schema(
    name="PYTHON_API_SCHEMA"),
    mode=CreateMode.or_replace,
  )

-- Example 1862
stages = root.databases[database.name].schemas[schema.name].stages
stages.create(Stage(name="TASKS_STAGE"))

-- Example 1863
def trunc(session: Session, from_table: str, to_table: str, count: int) -> str:
  (
    session
    .table(from_table)
    .limit(count)
    .write.save_as_table(to_table)
  )
  return "Truncated table successfully created!"

def filter_by_shipmode(session: Session, mode: str) -> str:
  (
    session
    .table("snowflake_sample_data.tpch_sf100.lineitem")
    .filter(col("L_SHIPMODE") == mode)
    .limit(10)
    .write.save_as_table("filter_table")
  )
  return "Filter table successfully created!"

-- Example 1864
tasks_stage = f"{database.name}.{schema.name}.TASKS_STAGE"

task1 = Task(
    name="task_python_api_trunc",
    definition=StoredProcedureCall(
      func=trunc,
      stage_location=f"@{tasks_stage}",
      packages=["snowflake-snowpark-python"],
    ),
    warehouse="COMPUTE_WH",
    schedule=timedelta(minutes=1)
)

task2 = Task(
    name="task_python_api_filter",
    definition=StoredProcedureCall(
      func=filter_by_shipmode,
      stage_location=f"@{tasks_stage}",
      packages=["snowflake-snowpark-python"],
    ),
    warehouse="COMPUTE_WH"
)

-- Example 1865
# create the task in the Snowflake database
tasks = schema.tasks
trunc_task = tasks.create(task1, mode=CreateMode.or_replace)

task2.predecessors = [trunc_task.name]
filter_task = tasks.create(task2, mode=CreateMode.or_replace)

-- Example 1866
taskiter = tasks.iter()
for t in taskiter:
    print(t.name)

-- Example 1867
trunc_task.resume()

-- Example 1868
taskiter = tasks.iter()
for t in taskiter:
    print("Name: ", t.name, "| State: ", t.state)

-- Example 1869
Name:  TASK_PYTHON_API_FILTER | State:  suspended
Name:  TASK_PYTHON_API_TRUNC | State:  started

-- Example 1870
trunc_task.suspend()

-- Example 1871
trunc_task.drop()
filter_task.drop()

-- Example 1872
dag_name = "python_api_dag"
dag = DAG(name=dag_name, schedule=timedelta(days=1))
with dag:
    dag_task1 = DAGTask(
        name="task_python_api_trunc",
        definition=StoredProcedureCall(
            func=trunc,
            stage_location=f"@{tasks_stage}",
            packages=["snowflake-snowpark-python"]),
        warehouse="COMPUTE_WH",
    )
    dag_task2 = DAGTask(
        name="task_python_api_filter",
        definition=StoredProcedureCall(
            func=filter_by_shipmode,
            stage_location=f"@{tasks_stage}",
            packages=["snowflake-snowpark-python"]),
        warehouse="COMPUTE_WH",
    )
    dag_task1 >> dag_task2
dag_op = DAGOperation(schema)
dag_op.deploy(dag, mode=CreateMode.or_replace)

-- Example 1873
taskiter = tasks.iter()
for t in taskiter:
    print("Name: ", t.name, "| State: ", t.state)

-- Example 1874
dag_op.run(dag)

-- Example 1875
dag_op.drop(dag)

-- Example 1876
database.drop()

-- Example 1877
CREATE DATABASE IF NOT EXISTS cortex_search_tutorial_db;

CREATE OR REPLACE WAREHOUSE cortex_search_tutorial_wh WITH
     WAREHOUSE_SIZE='X-SMALL'
     AUTO_SUSPEND = 120
     AUTO_RESUME = TRUE
     INITIALLY_SUSPENDED=TRUE;

 USE WAREHOUSE cortex_search_tutorial_wh;

-- Example 1878
CREATE OR REPLACE STAGE cortex_search_tutorial_db.public.fomc
    DIRECTORY = (ENABLE = TRUE)
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 1879
CREATE OR REPLACE FUNCTION cortex_search_tutorial_db.public.pdf_text_chunker(file_url STRING)
    RETURNS TABLE (chunk VARCHAR)
    LANGUAGE PYTHON
    RUNTIME_VERSION = '3.9'
    HANDLER = 'pdf_text_chunker'
    PACKAGES = ('snowflake-snowpark-python', 'PyPDF2', 'langchain')
    AS
$$
from snowflake.snowpark.types import StringType, StructField, StructType
from langchain.text_splitter import RecursiveCharacterTextSplitter
from snowflake.snowpark.files import SnowflakeFile
import PyPDF2, io
import logging
import pandas as pd

class pdf_text_chunker:

    def read_pdf(self, file_url: str) -> str:
        logger = logging.getLogger("udf_logger")
        logger.info(f"Opening file {file_url}")

        with SnowflakeFile.open(file_url, 'rb') as f:
            buffer = io.BytesIO(f.readall())

        reader = PyPDF2.PdfReader(buffer)
        text = ""
        for page in reader.pages:
            try:
                text += page.extract_text().replace('\n', ' ').replace('\0', ' ')
            except:
                text = "Unable to Extract"
                logger.warn(f"Unable to extract from file {file_url}, page {page}")

        return text

    def process(self, file_url: str):
        text = self.read_pdf(file_url)

        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size = 2000,  # Adjust this as needed
            chunk_overlap = 300,  # Overlap to keep chunks contextual
            length_function = len
        )

        chunks = text_splitter.split_text(text)
        df = pd.DataFrame(chunks, columns=['chunk'])

        yield from df.itertuples(index=False, name=None)
$$;

-- Example 1880
CREATE OR REPLACE TABLE cortex_search_tutorial_db.public.docs_chunks_table AS
    SELECT
        relative_path,
        build_scoped_file_url(@cortex_search_tutorial_db.public.fomc, relative_path) AS file_url,
        -- preserve file title information by concatenating relative_path with the chunk
        CONCAT(relative_path, ': ', func.chunk) AS chunk,
        'English' AS language
    FROM
        directory(@cortex_search_tutorial_db.public.fomc),
        TABLE(cortex_search_tutorial_db.public.pdf_text_chunker(build_scoped_file_url(@cortex_search_tutorial_db.public.fomc, relative_path))) AS func;

-- Example 1881
CREATE OR REPLACE CORTEX SEARCH SERVICE cortex_search_tutorial_db.public.fomc_meeting
    ON chunk
    ATTRIBUTES language
    WAREHOUSE = cortex_search_tutorial_wh
    TARGET_LAG = '1 hour'
    AS (
    SELECT
        chunk,
        relative_path,
        file_url,
        language
    FROM cortex_search_tutorial_db.public.docs_chunks_table
    );

-- Example 1882
import streamlit as st
from snowflake.core import Root # requires snowflake>=0.8.0
from snowflake.cortex import Complete
from snowflake.snowpark.context import get_active_session

""""
The available models are subject to change. Check the model availability for the REST API:
https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-llm-rest-api#model-availability
""""
MODELS = [
    "mistral-large2",
    "llama3.1-70b",
    "llama3.1-8b",
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


def query_cortex_search_service(query, columns = [], filter={}):
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
        query, columns=columns, filter=filter, limit=st.session_state.num_retrieved_chunks
    )
    results = context_documents.results

    service_metadata = st.session_state.service_metadata
    search_col = [s["search_column"] for s in service_metadata
                    if s["name"] == st.session_state.selected_cortex_search_service][0].lower()

    context_str = ""
    for i, r in enumerate(results):
        context_str += f"Context document {i+1}: {r[search_col]} \n" + "\n"

    if st.session_state.debug:
        st.sidebar.text_area("Context documents", context_str, height=500)

    return context_str, results


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
    return Complete(model, prompt).replace("$", "\$")


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
            prompt_context, results = query_cortex_search_service(
                question_summary,
                columns=["chunk", "file_url", "relative_path"],
                filter={"@and": [{"@eq": {"language": "English"}}]},
            )
        else:
            prompt_context, results = query_cortex_search_service(
                user_question,
                columns=["chunk", "file_url", "relative_path"],
                filter={"@and": [{"@eq": {"language": "English"}}]},
            )
    else:
        prompt_context, results = query_cortex_search_service(
            user_question,
            columns=["chunk", "file_url", "relative_path"],
            filter={"@and": [{"@eq": {"language": "English"}}]},
        )
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
    return prompt, results


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
            prompt, results = create_prompt(question)
            with st.spinner("Thinking..."):
                generated_response = complete(
                    st.session_state.model_name, prompt
                )
                # build references table for citation
                markdown_table = "###### References \n\n| PDF Title | URL |\n|-------|-----|\n"
                for ref in results:
                    markdown_table += f"| {ref['relative_path']} | [Link]({ref['file_url']}) |\n"
                message_placeholder.markdown(generated_response + "\n\n" + markdown_table)

        st.session_state.messages.append(
            {"role": "assistant", "content": generated_response}
        )


if __name__ == "__main__":
    session = get_active_session()
    root = Root(session)
    main()

-- Example 1883
DROP DATABASE IF EXISTS cortex_search_tutorial_db;
DROP WAREHOUSE IF EXISTS cortex_search_tutorial_wh;

-- Example 1884
from snowflake.snowpark.context import get_active_session
from snowflake.core import Root
from snowflake.core import CreateMode

-- Example 1885
current_user = get_active_session().get_current_user()
user_role_name = "test_role"
compute_pool_name = "tutorial_compute_pool"
warehouse_name = "tutorial_warehouse"
database_name = "tutorial_db"
schema_name = "data_schema"
repo_name = "tutorial_repository"
stage_name = "tutorial_stage"
service_name = "echo_service"
print("configured!")

-- Example 1886
from snowflake.core.compute_pool import ComputePool
from snowflake.core.database import Database
from snowflake.core.grant import Grant, Grantees, Privileges, Securable, Securables
from snowflake.core.role import Role
from snowflake.core.warehouse import Warehouse

session = get_active_session()
session.use_role("ACCOUNTADMIN")
root = Root(session)

# CREATE ROLE test_role;
root.roles.create(
    Role(name=user_role_name),
    mode=CreateMode.if_not_exists)
print(f"Created role:", user_role_name)

# GRANT ROLE test_role TO USER <user_name>
root.grants.grant(Grant(
    securable=Securables.role(user_role_name),
    grantee=Grantees.user(name=current_user),
    ))

# CREATE COMPUTE POOL IF NOT EXISTS tutorial_compute_pool
#   MIN_NODES = 1 MAX_NODES = 1
#   INSTANCE_FAMILY = CPU_X64_XS
root.compute_pools.create(
    mode=CreateMode.if_not_exists,
    compute_pool=ComputePool(
        name=compute_pool_name,
        instance_family="CPU_X64_XS",
        min_nodes=1,
        max_nodes=2,
    )
)

# GRANT USAGE, OPERATE, MONITOR ON COMPUTE POOL tutorial_compute_pool TO ROLE test_role
root.grants.grant(Grant(
    privileges=[Privileges.usage, Privileges.operate, Privileges.monitor],
    securable=Securables.compute_pool(compute_pool_name),
    grantee=Grantees.role(name=user_role_name)
    ))

print(f"Created compute pool:", compute_pool_name)

# CREATE DATABASE IF NOT EXISTS tutorial_db;
root.databases.create(
    Database(name=database_name),
    mode=CreateMode.if_not_exists)

# GRANT ALL ON DATABASE tutorial_db TO ROLE test_role;
root.grants.grant(Grant(
    privileges=[Privileges.all_privileges],
    securable=Securables.database(database_name),
    grantee=Grantees.role(name=user_role_name),
    ))

print("Created database:", database_name)

# CREATE OR REPLACE WAREHOUSE tutorial_warehouse WITH WAREHOUSE_SIZE='X-SMALL';
root.warehouses.create(
    Warehouse(name=warehouse_name, warehouse_size="X-SMALL"),
    mode=CreateMode.if_not_exists)

# GRANT USAGE ON WAREHOUSE tutorial_warehouse TO ROLE test_role;
root.grants.grant(Grant(
    privileges=[Privileges.usage],
    grantee=Grantees.role(name=user_role_name),
    securable=Securables.warehouse(warehouse_name)
    ))

print("Created warehouse:", warehouse_name)

# GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE test_role
root.grants.grant(Grant(
    privileges=[Privileges.bind_service_endpoint],
    securable=Securables.current_account,
    grantee=Grantees.role(name=user_role_name)
    ))

print("Done: GRANT BIND SERVICE ENDPOINT")

-- Example 1887
from snowflake.core.image_repository import ImageRepository
from snowflake.core.schema import Schema
from snowflake.core.stage import Stage, StageDirectoryTable

session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

# CREATE SCHEMA IF NOT EXISTS {schema_name}
schema = root.databases[database_name].schemas.create(
    Schema(name=schema_name),
    mode=CreateMode.if_not_exists)
print("Created schema:", schema.name)

# CREATE IMAGE REPOSITORY IF NOT EXISTS {repo}
repo = schema.image_repositories.create(
    ImageRepository(name=repo_name),
    mode=CreateMode.if_not_exists)
print("Create image repository:", repo.fully_qualified_name)

repo_url = repo.fetch().repository_url
print("image registry hostname:", repo_url.split("/")[0])
print("image repository url:", repo_url + "/")


#CREATE STAGE IF NOT EXISTS tutorial_stage
#  DIRECTORY = ( ENABLE = true );
stage = schema.stages.create(
    Stage(
        name=stage_name,
        directory_table=StageDirectoryTable(enable=True)),
    mode=CreateMode.if_not_exists)
print("Created stage:", stage.fully_qualified_name)

-- Example 1888
session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]
repo =  schema.image_repositories[repo_name]

repo_url = repo.fetch().repository_url
print("image registry hostname:", repo_url.split("/")[0])
print("image repository url:", repo_url + "/")

-- Example 1889
session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

repo = schema.image_repositories[repo_name]
for image in repo.list_images_in_repository():
    print(image.image_path)

-- Example 1890
import time

session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

cp = root.compute_pools[compute_pool_name]

cpm = cp.fetch()
print(cpm.state, cpm.status_message)
if cpm.state == 'SUSPENDED':
    cp.resume()
while cpm.state in ['STARTING', 'SUSPENDED']:
    time.sleep(5)
    cpm = cp.fetch()
    print(cpm.state, cpm.status_message)

-- Example 1891
from snowflake.core.service import Service, ServiceSpec

session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

repo = schema.image_repositories[repo_name]
repo_url = repo.fetch().repository_url

specification = f"""
    spec:
      containers:
      - name: echo
        image: {repo_url}/my_echo_service_image:latest
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

    """
echo_service = schema.services.create(Service(
    name=service_name,
    compute_pool=compute_pool_name,
    spec=ServiceSpec(specification),
    min_instances=1,
    max_instances=1),
    mode=CreateMode.if_not_exists)
print("created service:", echo_service.name)

-- Example 1892
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
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
  $$
  MIN_INSTANCES=1
  MAX_INSTANCES=1;

-- Example 1893
from snowflake.core.function import ServiceFunction, FunctionArgument

session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

# CREATE FUNCTION my_echo_udf (inputtext VARCHAR)
#  RETURNS VARCHAR
#  SERVICE=echo_service
#  ENDPOINT=echoendpoint
#  AS '/echo';
svcfn = schema.functions.create(mode=CreateMode.or_replace,
    function=ServiceFunction(
        name="my_echo_function",
        arguments=[FunctionArgument(name="inputtext", datatype="TEXT")],
        returns="TEXT",
        service=service_name,
        endpoint="echoendpoint",
        path="/echo"))
print("created service function:", svcfn.name_with_args)

-- Example 1894
svcfn = schema.functions["my_echo_function(TEXT)"]
print(svcfn.execute(["hello"]))

-- Example 1895
+--------------------------+
| **MY_ECHO_UDF('HELLO!')**|
|------------------------- |
| Bob said hello!          |
+--------------------------+

-- Example 1896
# helper to check if service is ready and return endpoint url
def get_ingress_for_endpoint(svc, endpoint):
    for _ in range(10): # only try 10 times
        # Find the target endpoint.
        target_endpoint = None
        for ep in svc.get_endpoints():
            if ep.is_public and ep.name == endpoint:
                target_endpoint = ep
                break;
        else:
            print(f"Endpoint {endpoint} not found")
            return None

        # Return endpoint URL or wait for it to be provisioned.
        if target_endpoint.ingress_url.startswith("Endpoints provisioning "):
            print(f"{target_endpoint.ingress_url} is still in provisioning. Wait for 10 seconds.")
            time.sleep(10)
        else:
            return target_endpoint.ingress_url
    print("Timed out waiting for endpoint to become available")

endpoint_url = get_ingress_for_endpoint(echo_service, "echoendpoint")
print(f"https://{endpoint_url}/ui")

-- Example 1897
session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]
repo =  schema.image_repositories[repo_name]

repo_url = repo.fetch().repository_url
print("image registry hostname:", repo_url.split("/")[0])
print("image repository url:", repo_url + "/")

-- Example 1898
session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

repo = schema.image_repositories[repo_name]
for image in repo.list_images_in_repository():
    print(image.image_path)

-- Example 1899
from snowflake.core.service import JobService, ServiceSpec

session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

repo = schema.image_repositories[repo_name]
repo_url = repo.fetch().repository_url

job_name = "test_job"

# cleanup previous job if present.
schema.services[job_name].drop()(if_exists=True)

specification = f"""
    spec:
      containers:
      - name: main
        image: {repo_url}/my_job_image:latest
        env:
          SNOWFLAKE_WAREHOUSE: {warehouse_name}
        args:
        - "--query=select current_time() as time,'hello'"
        - "--result_table=results"
    """
job = schema.services.execute_job(JobService(
    name=job_name,
    compute_pool=compute_pool_name,
    spec=ServiceSpec(specification)))
print("executed job:", job.name, "status:", job.fetch().status)

print("job logs:")
print(job.get_service_logs(0, "main"))

-- Example 1900
session = get_active_session()
session.use_role(user_role_name)
# show that above job wrote to results table
session.sql(f"select * from {database_name}.{schema_name}.results").collect()

-- Example 1901
session = get_active_session()
session.use_role(user_role_name)
root = Root(session)

schema = root.databases[database_name].schemas[schema_name]

# now let's clean up

schema.functions["my_echo_function(TEXT)"].drop()
schema.services[service_name].drop()

-- Example 1902
schema.image_repositories[repo_name].drop()

-- Example 1903
root.databases[database_name].schemas[schema_name].drop()

-- Example 1904
root.compute_pool[compute_pool_name].suspend()

