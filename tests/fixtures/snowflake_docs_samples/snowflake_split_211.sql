-- Example 14117
{
  ...
  "data": [
    ["customer1", "1234 A Avenue", "98765", "2021-01-20 12:34:56.03459878"],
    ["customer2", "987 B Street", "98765", "2020-05-31 01:15:43.765432134"],
    ["customer3", "8777 C Blvd", "98765", "2019-07-01 23:12:55.123467865"],
    ["customer4", "64646 D Circle", "98765", "2021-08-03 13:43:23.0"]
  ],
  ...
}

-- Example 14118
GET /api/v2/statements/<handle>?partition=1

-- Example 14119
"data" : [ [ null ], ... ]

-- Example 14120
POST /api/v2/statements?nullable=false

-- Example 14121
"data" : [ [ "null" ], ... ]

-- Example 14122
{
  "statement": "select date_column from mytable",
  "resultSetMetaData": {
    "format": "jsonv2",
  },
  "parameters": {
    "DATE_OUTPUT_FORMAT": "MM/DD/YYYY"
  }
  ...
}

-- Example 14123
POST /api/v2/statements HTTP/1.1
Authorization: Bearer <jwt>
Content-Type: application/json
Accept: application/json
User-Agent: myApplication/1.0

{
  "statement": "alter session set QUERY_TAG='mytesttag'; select count(*) from mytable",
  ...
  "parameters": {
      "MULTI_STATEMENT_COUNT": "2"
  }
}

-- Example 14124
Actual statement count <actual_count> did not match the desired statement count <desired_count>.

-- Example 14125
Actual statement count 3 did not match the desired statement count 1.

-- Example 14126
POST /api/v2/statements HTTP/1.1
Authorization: Bearer <jwt>
Content-Type: application/json
Accept: application/json
User-Agent: myApplication/1.0

{
  "statement": "select * from A; select * from B",
  ...
}

-- Example 14127
HTTP/1.1 200 OK
...
{
  ...
  "statementHandles" : [ "019c9fce-0502-f1fc-0000-438300e02412", "019c9fce-0502-f1fc-0000-438300e02416" ],
  ...
}

-- Example 14128
GET /api/v2/statements/019c9fce-0502-f1fc-0000-438300e02412
...

-- Example 14129
GET /api/v2/statements/019c9fce-0502-f1fc-0000-438300e02416
...

-- Example 14130
{
  "statement": "create or replace table table1 (i int); insert into table1 (i) values (1); insert into table1 (i) values ('This is not a valid integer.'); insert into table1 (i) values (2); select i from table1 order by i",
  ...
}

-- Example 14131
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json
...
{
  "code" : "100132",
  "message" : "JavaScript execution error: Uncaught Execution of multiple statements failed on statement \"insert into table1 (i) values ...\" (at line 1, position 75).\nNumeric value 'This is not a valid integer.' is not recognized in SYSTEM$MULTISTMT at '    throw `Execution of multiple statements failed on statement {0} (at line {1}, position {2}).`.replace('{1}', LINES[i])' position 4\nstackstrace: \nSYSTEM$MULTISTMT line: 10",
  "sqlState" : "P0000",
  "statementHandle" : "019d6e97-0502-317e-0000-096d0041f036"
}

-- Example 14132
{
  "statement": "create or replace procedure sql_api_stored_proc(table_name varchar) returns varchar language javascript as $$var sql_command = \"select count(*) from \" + TABLE_NAME; var rs = snowflake.execute({sqlText: sql_command}); rs.next(); var rowCount = rs.getColumnValue(1); return rowCount; $$;",
  "role": "MY_ROLE",
  "warehouse": "MY_WAREHOUSE",
  "database": "MY_DB",
  "schema": "MY_SCHEMA"
}

-- Example 14133
{
  "resultSetMetaData": {
    "numRows": 1,
    "format": "jsonv2",
    "rowType": [ {
      "name": "status",
      "database": "",
      "schema": "",
      "table": "",
      "type": "text",
      "byteLength": 16777216,
      "scale": null,
      "precision": null,
      "nullable": true,
      "collation": null,
      "length": 16777216
    } ]
  },
  "data": [ [ "Function SQL_API_STORED_PROC successfully created." ] ],
  "code": "090001",
  "statementStatusUrl": "/api/v2/statements/019c9f28-0502-f257-0000-438300e0a02a?requestId=...",
  "sqlState": "00000",
  "statementHandle": "019c9f28-0502-f257-0000-438300e0a02a",
  "message": "Statement executed successfully.",
  "createdOn": 1622494569592
}

-- Example 14134
{
  "statement": "call sql_api_stored_proc('prices');",
  "role": "MY_ROLE",
  "warehouse": "MY_WAREHOUSE",
  "database": "MY_DB",
  "schema": "MY_SCHEMA"
}

-- Example 14135
{
  "resultSetMetaData": {
    "numRows": 1,
    "format": "jsonv2",
    "rowType": [ {
      "name": "SQL_API_STORED_PROC",
      "database": "",
      "schema": "",
      "table": "",
      "type": "text",
      "byteLength": 16777216,
      "length": 16777216,
      "scale": null,
      "precision": null,
      "nullable": true,
      "collation": null
    } ]
  },
  "data": [ [ "4" ] ],
  "code": "090001",
  "statementStatusUrl": "/api/v2/statements/019c9f2a-0502-f244-0000-438300e04496?requestId=...",
  "sqlState": "00000",
  "statementHandle": "019c9f2a-0502-f244-0000-438300e04496",
  "message": "Statement executed successfully.",
  "createdOn": 1622494718694
}

-- Example 14136
{
  "statement": "begin transaction; insert into table2 (i) values (1); commit; select i from table1 order by i",
  ...
  "parameters": {
      "MULTI_STATEMENT_COUNT": "4"
  }
  ...
}

-- Example 14137
HTTP/1.1 200 OK
Content-Type: application/json

{
  "resultSetMetaData" : {
    "numRows" : 1,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "multiple statement execution",
      "database" : "",
      "schema" : "",
      "table" : "",
      "type" : "text",
      "byteLength" : 16777216,
      "scale" : null,
      "precision" : null,
      "nullable" : false,
      "collation" : null,
      "length" : 16777216
    } ]
  },
  "data" : [ [ "Multiple statements executed successfully." ] ],
  "code" : "090001",
  "statementHandles" : [ "019d6ed0-0502-3101-0000-096d00421082", "019d6ed0-0502-3101-0000-096d00421086", "019d6ed0-0502-3101-0000-096d0042108a", "019d6ed0-0502-3101-0000-096d0042108e" ],
  "statementStatusUrl" : "/api/v2/statements/019d6ed0-0502-3101-0000-096d0042107e?requestId=066920fa-e589-43c6-8cca-9dcb2d4be978",
  "sqlState" : "00000",
  "statementHandle" : "019d6ed0-0502-3101-0000-096d0042107e",
  "message" : "Statement executed successfully.",
  "createdOn" : 1625684162876
}

-- Example 14138
POST /api/v2/statements/{statementHandle}/cancel

-- Example 14139
HTTP/1.1 200 OK
...
{
  "code": "391908",
  ...
}

-- Example 14140
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_creator;
GRANT USAGE ON WAREHOUSE streamlit_wh TO ROLE streamlit_creator;
GRANT CREATE STREAMLIT ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT CREATE STAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Example 14141
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_role;
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;
GRANT USAGE ON STREAMLIT streamlit_db.streamlit_schema.streamlit_app TO ROLE streamlit_role;

-- Example 14142
GRANT USAGE ON FUTURE STREAMLITS IN SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;

-- Example 14143
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Get the current credentials
session = get_active_session()

warehouse_sql = f"USE WAREHOUSE LARGE_WH"
session.sql(warehouse_sql).collect()

# Execute the SQL using a different warehouse
sql = """SELECT * from MY_DB.INFORMATION_SCHEMA.PACKAGES limit 100"""
session.sql(sql).collect()

-- Example 14144
CREATE OR REPLACE TABLE <your_database>.<your_schema>.BUG_REPORT_DATA (
  AUTHOR VARCHAR(25),
  BUG_TYPE VARCHAR(25),
  COMMENT VARCHAR(100),
  DATE DATE,
  BUG_SEVERITY NUMBER(38,0)
);

-- Example 14145
INSERT INTO <your_database>.<your_schema>.BUG_REPORT_DATA (AUTHOR, BUG_TYPE, COMMENT, DATE, BUG_SEVERITY)
VALUES
('John Doe', 'UI', 'The button is not aligned properly', '2024-03-01', 3),
('Aisha Patel', 'Performance', 'Page load time is too long', '2024-03-02', 5),
('Bob Johnson', 'Functionality', 'Unable to submit the form', '2024-03-03', 4),
('Sophia Kim', 'Security', 'SQL injection vulnerability found', '2024-03-04', 8),
('Michael Lee', 'Compatibility', 'Does not work on Internet Explorer', '2024-03-05', 2),
('Tyrone Johnson', 'UI', 'Font size is too small', '2024-03-06', 3),
('David Martinez', 'Performance', 'Search feature is slow', '2024-03-07', 4),
('Fatima Abadi', 'Functionality', 'Logout button not working', '2024-03-08', 3),
('William Taylor', 'Security', 'Sensitive data exposed in logs', '2024-03-09', 7),
('Nikolai Petrov', 'Compatibility', 'Not compatible with Safari', '2024-03-10', 2);

-- Example 14146
import streamlit as st

st.set_page_config(page_title="Bug report", layout="centered")

session = st.connection('snowflake').session()

# Change the query to point to your table
def get_data(_session):
    query = """
    select * from <your_database>.<your_schema>.BUG_REPORT_DATA
    order by date desc
    limit 100
    """
    data = _session.sql(query).collect()
    return data

# Change the query to point to your table
def add_row_to_db(session, row):
    sql = f"""INSERT INTO <your_database>.<your_schema>.BUG_REPORT_DATA VALUES
    ('{row['author']}',
    '{row['bug_type']}',
    '{row['comment']}',
    '{row['date']}',
    '{row['bug_severity']}')"""

    session.sql(sql).collect()

st.title("Bug report demo!")

st.sidebar.write(
    f"This app demos how to read and write data from a Snowflake Table"
)

form = st.form(key="annotation", clear_on_submit=True)

with form:
    cols = st.columns((1, 1))
    author = cols[0].text_input("Report author:")
    bug_type = cols[1].selectbox(
        "Bug type:", ["Front-end", "Back-end", "Data related", "404"], index=2
    )
    comment = st.text_area("Comment:")
    cols = st.columns(2)
    date = cols[0].date_input("Bug date occurrence:")
    bug_severity = cols[1].slider("Bug priority :", 1, 5, 2)
    submitted = st.form_submit_button(label="Submit")

if submitted:
    try:
        add_row_to_db(
            session,
            {'author':author,
            'bug_type': bug_type,
            'comment':comment,
            'date':str(date),
            'bug_severity':bug_severity
        })
        st.success("Thanks! Your bug was recorded in the database.")
        st.balloons()
    except Exception as e:
        st.error(f"An error occurred: {e}")

expander = st.expander("See 100 most recent records")
with expander:
    st.dataframe(get_data(session))

-- Example 14147
# This will not work
import streamlit.components.v1 as components
components.html("""
<script src="http://www.example.com/example.js"></script>
""", height=0)

-- Example 14148
MessageSizeError: Data Size exceeds message limit

-- Example 14149
https://app.snowflake.com/org/account_name/#/streamlit-apps/DB.SCHEMA.APP_NAME?streamlit-first_key=one&streamlit-second_key=two

-- Example 14150
{
   "first_key" : "one",
   "second_key" : "two"
}

-- Example 14151
└── streamlit/
    └── environment.yml
    └── streamlit_main.py
    └── pages/
         └── data_frame_demo.py
         └── plot_demo.py

-- Example 14152
PUT file:///<path_to_your_root_folder>/streamlit/streamlit_main.py @streamlit_db.streamlit_schema.streamlit_stage overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/environment.yml @streamlit_db.streamlit_schema.streamlit_stage overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/pages/streamlit_page_2.py @streamlit_db.streamlit_schema.streamlit_stage/pages/ overwrite=true auto_compress=false;
PUT file:///<path_to_your_root_folder>/streamlit/pages/streamlit_page_3.py @streamlit_db.streamlit_schema.streamlit_stage/pages/ overwrite=true auto_compress=false;

-- Example 14153
CREATE STREAMLIT hello_streamlit
ROOT_LOCATION = '@streamlit_db.streamlit_schema.streamlit_stage'
MAIN_FILE = 'streamlit_main.py'
QUERY_WAREHOUSE = my_warehouse;

-- Example 14154
SHOW STREAMLITS;

-- Example 14155
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn

-- Example 14156
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn
- streamlit=1.31.1

-- Example 14157
DESC STREAMLIT hello_streamlit;

-- Example 14158
ALTER STREAMLIT hello_streamlit RENAME TO hello_snowflake;

-- Example 14159
ALTER STREAMLIT hello_streamlit SET ROOT_LOCATION = '@snowflake_db.snowflake_schema.snowflake_stage'

-- Example 14160
ALTER STREAMLIT hello_streamlit SET MAIN_FILE = 'snowflake_main.py'

-- Example 14161
ALTER STREAMLIT hello_streamlit SET QUERY_WAREHOUSE = my_new_warehouse;

-- Example 14162
SHOW STREAMLITS;

-- Example 14163
DROP STREAMLIT hello_streamlit;

-- Example 14164
# Name the GitHub Action
name: Deploy via Snowflake CLI

on:
push:
    branches:
    - main

env:
PYTHON_VERSION: '3.9'

jobs:
build-and-deploy:
    runs-on: ubuntu-latest
    environment: dev
    steps:
    # Checks out your repository under $GITHUB_WORKSPACE, so your workflow can access it
    - name: 'Checkout GitHub Action'
    uses: actions/checkout@v3

    - name: Install Python
    uses: actions/setup-python@v4
    with:
        python-version: ${{ env.PYTHON_VERSION }}

    - name: 'Install Snowflake CLI'
    shell: bash
    run: |
        python -m pip install --upgrade pip
        pip install snowflake-cli

    - name: 'Create config'
    shell: bash
    env:
        SNOWFLAKE_PASSWORD: ${{ secrets.SNOWCLI_PW }}
    run: |
        mkdir -p ~/.snowflake
        cp config.toml ~/.snowflake/config.toml
        echo "password = \"$SNOWFLAKE_PASSWORD\"" >> ~/.snowflake/config.toml
        chmod 0600 ~/.snowflake/config.toml

    - name: 'Deploy the Streamlit app'
    shell: bash
    run: |
        snow streamlit deploy --replace

-- Example 14165
import streamlit as st

st.title('Multi-page app demo')
st.write('This is the landing page for the app. Click in the left sidebar to open other pages in the app')

-- Example 14166
import streamlit as st

# Write directly to the app
st.title("Dataframe Demo App :balloon:")

# Get the current credentials
session = st.connection('snowflake').session()

# Use an interactive slider to get user input
hifives_val = st.slider(
    "Number of high-fives in Q3",
    min_value=0,
    max_value=90,
    value=60,
    help="Use this to enter the number of high-fives you gave in Q3",
)

#  Create an example dataframe
#  Note: this is just some dummy data, but you can easily connect to your Snowflake data
#  It is also possible to query data using raw SQL using session.sql() e.g. session.sql("select * from table")
created_dataframe = session.create_dataframe(
    [[50, 25, "Q1"], [20, 35, "Q2"], [hifives_val, 30, "Q3"]],
    schema=["HIGH_FIVES", "FIST_BUMPS", "QUARTER"],
)

# Execute the query and convert it into a Pandas dataframe
queried_data = created_dataframe.to_pandas()

# Create a simple bar chart
# See docs.streamlit.io for more types of charts
st.subheader("Number of high-fives")
st.bar_chart(data=queried_data, x="QUARTER", y="HIGH_FIVES")

st.subheader("Underlying data")
st.dataframe(queried_data, use_container_width=True)

-- Example 14167
import time

import numpy as np

import streamlit as st
from streamlit.hello.utils import show_code


def plotting_demo():
    progress_bar = st.sidebar.progress(0)
    status_text = st.sidebar.empty()
    last_rows = np.random.randn(1, 1)
    chart = st.line_chart(last_rows)

    for i in range(1, 101):
        new_rows = last_rows[-1, :] + np.random.randn(5, 1).cumsum(axis=0)
        status_text.text("%i%% Complete" % i)
        chart.add_rows(new_rows)
        progress_bar.progress(i)
        last_rows = new_rows
        time.sleep(0.05)

    progress_bar.empty()

    # Streamlit widgets automatically run the script from top to bottom. Because
    # this button is not connected to any other logic, it just causes a plain
    # rerun.
    st.button("Re-run")


st.set_page_config(page_title="Plotting Demo", page_icon="📈")
st.markdown("# Plotting Demo")
st.sidebar.header("Plotting Demo")
st.write(
    """This demo illustrates a combination of plotting and animation with
    Streamlit. We're generating a bunch of random numbers in a loop for around
    5 seconds. Enjoy!"""
)

plotting_demo()

show_code(plotting_demo)

-- Example 14168
-- Create an event table if it doesn't already exist
CREATE EVENT TABLE SAMPLEDATABASE.LOGGING_AND_TRACING.SAMPLE_EVENTS;

-- Associate the event table with the account
ALTER ACCOUNT SET EVENT_TABLE = SAMPLEDATABASE.LOGGING_AND_TRACING.SAMPLE_EVENTS;

-- Set the log level for the database containing your app
ALTER DATABASE STREAMLIT_TEST SET LOG_LEVEL = INFO;

-- Set the trace level for the database containing your app
ALTER DATABASE SAMPLEDATABASE SET TRACE_LEVEL = ON_EVENT;

-- Example 14169
import logging
import streamlit as st

logger = logging.getLogger("simple_logger")

# Write directly to the app
st.title("Simple Logging Example")

# Get the current credentials
session = st.connection('snowflake').session()

def get_log_messages_query() -> str:
    """
    Get data from the `EVENT TABLE` where the logs were created by this app.
    """
    return """
            SELECT
                TIMESTAMP,
                RECORD:"severity_text"::VARCHAR AS SEVERITY,
                RESOURCE_ATTRIBUTES:"db.user"::VARCHAR AS USER,
                VALUE::VARCHAR AS VALUE
            FROM
                SAMPLE_EVENTS
            WHERE
                SCOPE:"name" = 'simple_logger'
            ORDER BY
                TIMESTAMP DESC;
            """

button = st.button("Log a message")

if button:
    try:
        logger.info("Logging an info message through Stremlit App.")
        st.success('Logged a message')
    except Exception as e:
        logger.error("Logging an error message through Stremlit App: %s",e)
        st.error('Logged an error')

sql = get_log_messages_query()

df = session.sql(sql).to_pandas()

with st.expander("**Show All Messages**"):
     st.dataframe(df, use_container_width=True)

-- Example 14170
import streamlit as st
import time
import random
from snowflake import telemetry

def sleep_function() -> int:
    """
    Function that sleeps for a random period of time, between one and ten seconds.
    """
    random_time = random.randint(1, 10)
    time.sleep(random_time)
    return random_time

def get_trace_messages_query() -> str:
    """
    Get data from the `EVENT TABLE` where the logs were created by this app.
    """
    return """
            SELECT
                TIMESTAMP,
                RESOURCE_ATTRIBUTES :"db.user" :: VARCHAR AS USER,
                RECORD_TYPE,
                RECORD_ATTRIBUTES
            FROM
                SAMPLE_EVENTS
            WHERE
                RECORD :"name" :: VARCHAR = 'tracing_some_data'
                OR RECORD_ATTRIBUTES :"loggin_demo.tracing" :: VARCHAR = 'begin_span'
            ORDER BY
                TIMESTAMP DESC;
            """

def trace_message() -> None:
    """
    Add a new trace message into the event table.
    """
    execution_time = sleep_function()
    telemetry.set_span_attribute("loggin_demo.tracing", "begin_span")
    telemetry.add_event(
        "tracing_some_data",
        {"function_name": "sleep_function", "execution_time": execution_time},
    )

# Write directly to the app
st.title("Simple Tracing Example")

# Get the current credentials
session = st.connection('snowflake').session()

button = st.button("Add trace event")

if button:
    with st.spinner("Executing function..."):
        trace_message()
        st.toast("Successfully log a trace message!", icon="✅")

sql = get_trace_messages_query()

df = session.sql(sql).to_pandas()

with st.expander("**Show All Trace Messages**"):
     st.dataframe(df, use_container_width=True)

-- Example 14171
st.markdown("""
  <style>
    [data-testid=stSidebar] {
      background-color: #94d3e6;
    }
  </style>
""", unsafe_allow_html=True)

-- Example 14172
from streamlit_extras.app_logo import add_logo
add_logo("./Logo.png", height=60)

-- Example 14173
import streamlit.components.v1 as components

components.html("""
  <script>
    window.parent.document.querySelector('[data-testid="stSidebar"]').style.width = "300px";
  </script>
""", height=0)

-- Example 14174
import streamlit as st
import streamlit.components.v1 as components
from sklearn.datasets import load_iris
from ydata_profiling import ProfileReport

st.set_page_config(layout="wide")
df = load_iris(as_frame=True).data
html = ProfileReport(df).to_html()
components.html(html, height=500, scrolling=True)

-- Example 14175
CREATE OR REPLACE NETWORK RULE network_rules
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('api.openai.com');

-- Example 14176
CREATE OR REPLACE SECRET openai_key
  TYPE = GENERIC_STRING
  SECRET_STRING = '<any_string>';

-- Example 14177
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION openai_access_int
  ALLOWED_NETWORK_RULES = (network_rules)
  ALLOWED_AUTHENTICATION_SECRETS = (openai_key)
  ENABLED = TRUE;

-- Example 14178
GRANT READ ON SECRET openai_key TO ROLE streamlit_app_creator_role;
GRANT USAGE ON INTEGRATION openai_access_int TO ROLE streamlit_app_creator_role;

-- Example 14179
USE ROLE streamlit_app_creator_role;

ALTER STREAMLIT streamlit_db.streamlit_schema.streamlit_app
  SET EXTERNAL_ACCESS_INTEGRATIONS = (openai_access_int)
  SECRETS = ('my_openai_key' = streamlit_db.streamlit_schema.openai_key);

-- Example 14180
CREATE STREAMLIT streamlit_db.streamlit_schema.streamlit_app
  ROOT_LOCATION = '<stage_path_and_root_directory>'
  MAIN_FILE = '<path_to_main_file_in_root_directory>'
  EXTERNAL_ACCESS_INTEGRATIONS = (openai_access_int)
  SECRETS = ('my_openai_key' = streamlit_db.streamlit_schema.openai_key);

-- Example 14181
from openai import OpenAI
import streamlit as st
import _snowflake

st.title(":speech_balloon: Simple chat app using an external LLM")
st.write("This app shows how to call an external LLM to build a simple chat application.")

# Use the _snowflake library to access secrets
secret = _snowflake.get_generic_secret_string('my_openai_key')
client = OpenAI(api_key=secret)

# ...
# code to use API
# ...

-- Example 14182
[snowflake]
[snowflake.sleep]
streamlitSleepTimeoutMinutes = 8

-- Example 14183
PUT file:///<path_to_your_root_folder>/my_app/config.toml @streamlit_db.streamlit_schema.streamlit_stage/.streamlit/ overwrite=true auto_compress=false;

