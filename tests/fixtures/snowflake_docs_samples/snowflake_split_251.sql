-- Example 16796
https://github.com/my-account/snowflake-extensions.git

-- Example 16797
USE ROLE ACCOUNTADMIN;
GRANT CREATE GIT REPOSITORY ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_git_admin;

CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = myco_git_secret
  ORIGIN = 'https://github.com/my-account/snowflake-extensions.git';

-- Example 16798
--!jinja

-- Example 16799
#!jinja

-- Example 16800
{% include "@my_stage/path/to/my_template" %}
{% import "@my_stage/path/to/my_template" as my_template %}
{% extends "@my_stage/path/to/my_template" %}
{{ SnowflakeFile.open("@my_stage/path/to/my_template", 'r', require_scoped_url = False).read() }}

-- Example 16801
{% include "my_template" %}
{% import "../my_template" as my_template %}
{% extends "/path/to/my_template" %}

-- Example 16802
EXECUTE IMMEDIATE
  FROM { absoluteFilePath | relativeFilePath }
  [ USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )  ]
  [ DRY_RUN = { TRUE | FALSE } ]

-- Example 16803
absoluteFilePath ::=
   @[ <namespace>. ]<stage_name>/<path>/<filename>

-- Example 16804
relativeFilePath ::=
  '[ / | ./ | ../ ]<path>/<filename>'

-- Example 16805
PUT file://~/sql/scripts/my_file.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 16806
001501 (02000): File '<directory_name>' not found in stage '<stage_name>'.

-- Example 16807
001503 (42601): Relative file references like '<filename.sql>' cannot be used in top-level EXECUTE IMMEDIATE calls.

-- Example 16808
001003 (42000): SQL compilation error: syntax error line <n> at position <m> unexpected '<string>'.

-- Example 16809
002003 (02000): SQL compilation error: Stage '<stage_name>' does not exist or not authorized.

-- Example 16810
003001 (42501): Uncaught exception of type 'STATEMENT_ERROR' in file <file_name> on line <n> at position <m>:
SQL access control error: Insufficient privileges to operate on schema '<schema_name>'

-- Example 16811
001003 (42000): SQL compilation error:
syntax error line [n] at position [m] unexpected '{'.

-- Example 16812
000005 (XX000): Python Interpreter Error:
jinja2.exceptions.UndefinedError: '<key>' is undefined
in template processing

-- Example 16813
001510 (42601): Unable to use value of template variable '<key>'

-- Example 16814
001518 (42601): Size of expanded template exceeds limit of 100,000 bytes.

-- Example 16815
CREATE OR REPLACE TABLE my_inventory(
  sku VARCHAR,
  price NUMBER
);

EXECUTE IMMEDIATE FROM './insert-inventory.sql';

SELECT sku, price
  FROM my_inventory
  ORDER BY price DESC;

-- Example 16816
INSERT INTO my_inventory
  VALUES ('XYZ12345', 10.00),
         ('XYZ81974', 50.00),
         ('XYZ34985', 30.00),
         ('XYZ15324', 15.00);

-- Example 16817
CREATE STAGE my_stage;

-- Example 16818
PUT file://~/sql/scripts/create-inventory.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

PUT file://~/sql/scripts/insert-inventory.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 16819
EXECUTE IMMEDIATE FROM @my_stage/scripts/create-inventory.sql;

-- Example 16820
+----------+-------+
| SKU      | PRICE |
|----------+-------|
| XYZ81974 |    50 |
| XYZ34985 |    30 |
| XYZ15324 |    15 |
| XYZ12345 |    10 |
+----------+-------+

-- Example 16821
--!jinja

CREATE SCHEMA {{env}};

CREATE TABLE RAW (COL OBJECT)
    DATA_RETENTION_TIME_IN_DAYS = {{retention_time}};

-- Example 16822
CREATE STAGE my_stage;

-- Example 16823
PUT file://path/to/setup.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 16824
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup.sql
    USING (env=>'dev', retention_time=>0);

-- Example 16825
{%- macro get_environments(deployment_type) -%}
  {%- if deployment_type == 'prod' -%}
    {{ "prod1,prod2" }}
  {%- else -%}
    {{ "dev,qa,staging" }}
  {%- endif -%}
{%- endmacro -%}

-- Example 16826
--!jinja2
{% from "macros.jinja" import get_environments %}

{%- set environments = get_environments(DEPLOYMENT_TYPE).split(",") -%}

{%- for environment in environments -%}
  CREATE DATABASE {{ environment }}_db;
  USE DATABASE {{ environment }}_db;
  CREATE TABLE {{ environment }}_orders (
    id NUMBER,
    item VARCHAR,
    quantity NUMBER);
  CREATE TABLE {{ environment }}_customers (
    id NUMBER,
    name VARCHAR);
{% endfor %}

-- Example 16827
CREATE STAGE my_stage;

-- Example 16828
PUT file://path/to/setup-env.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;
PUT file://path/to/macros.jinja @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 16829
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup-env.sql
  USING (DEPLOYMENT_TYPE => 'prod') DRY_RUN = TRUE;

-- Example 16830
+----------------------------------+
| rendered file contents           |
|----------------------------------|
| --!jinja2                        |
| CREATE DATABASE prod1_db;        |
|   USE DATABASE prod1_db;         |
|   CREATE TABLE prod1_orders (    |
|     id NUMBER,                   |
|     item VARCHAR,                |
|     quantity NUMBER);            |
|   CREATE TABLE prod1_customers ( |
|     id NUMBER,                   |
|     name VARCHAR);               |
| CREATE DATABASE prod2_db;        |
|   USE DATABASE prod2_db;         |
|   CREATE TABLE prod2_orders (    |
|     id NUMBER,                   |
|     item VARCHAR,                |
|     quantity NUMBER);            |
|   CREATE TABLE prod2_customers ( |
|     id NUMBER,                   |
|     name VARCHAR);               |
|                                  |
+----------------------------------+

-- Example 16831
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup-env.sql
  USING (DEPLOYMENT_TYPE => 'prod');

-- Example 16832
CREATE OR REPLACE TABLE demo_dml_error_message (v VARCHAR);

INSERT INTO demo_dml_error_message (v) VALUES
  (3),
  ('d');

-- Example 16833
100038 (22018): Numeric value 'd' is not recognized

-- Example 16834
100038 (22018): DML operation to table DEMO_INSERT_TYPE_MISMATCH failed on
column V with error: Numeric value 'd' is not recognized

-- Example 16835
USE ROLE SAMOOHA_APP_ROLE;
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.library.apply_patch();

-- Example 16836
USE ROLE SAMOOHA_APP_ROLE;
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.library.enable_local_db_auto_upgrades();

-- Example 16837
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.library.apply_patch();

-- Example 16838
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

-- Example 16839
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.library.apply_patch();

-- Example 16840
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

-- Example 16841
CALL samooha_by_snowflake_local_db.provider.patch_cleanroom($cleanroom_name, TRUE);

-- Example 16842
CALL samooha_by_snowflake_local_db.consumer.patch_cleanroom($cleanroom_name);

-- Example 16843
CREATE OR REPLACE TABLE demo_dml_error_message (v VARCHAR);

INSERT INTO demo_dml_error_message (v) VALUES
  (3),
  ('d');

-- Example 16844
100038 (22018): Numeric value 'd' is not recognized

-- Example 16845
100038 (22018): DML operation to table DEMO_INSERT_TYPE_MISMATCH failed on
column V with error: Numeric value 'd' is not recognized

-- Example 16846
st.markdown("""
  <style>
    [data-testid=stSidebar] {
      background-color: #94d3e6;
    }
  </style>
""", unsafe_allow_html=True)

-- Example 16847
from streamlit_extras.app_logo import add_logo
add_logo("./Logo.png", height=60)

-- Example 16848
import streamlit.components.v1 as components

components.html("""
  <script>
    window.parent.document.querySelector('[data-testid="stSidebar"]').style.width = "300px";
  </script>
""", height=0)

-- Example 16849
import streamlit as st
import streamlit.components.v1 as components
from sklearn.datasets import load_iris
from ydata_profiling import ProfileReport

st.set_page_config(layout="wide")
df = load_iris(as_frame=True).data
html = ProfileReport(df).to_html()
components.html(html, height=500, scrolling=True)

-- Example 16850
CREATE OR REPLACE NETWORK RULE network_rules
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('api.openai.com');

-- Example 16851
CREATE OR REPLACE SECRET openai_key
  TYPE = GENERIC_STRING
  SECRET_STRING = '<any_string>';

-- Example 16852
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION openai_access_int
  ALLOWED_NETWORK_RULES = (network_rules)
  ALLOWED_AUTHENTICATION_SECRETS = (openai_key)
  ENABLED = TRUE;

-- Example 16853
GRANT READ ON SECRET openai_key TO ROLE streamlit_app_creator_role;
GRANT USAGE ON INTEGRATION openai_access_int TO ROLE streamlit_app_creator_role;

-- Example 16854
USE ROLE streamlit_app_creator_role;

ALTER STREAMLIT streamlit_db.streamlit_schema.streamlit_app
  SET EXTERNAL_ACCESS_INTEGRATIONS = (openai_access_int)
  SECRETS = ('my_openai_key' = streamlit_db.streamlit_schema.openai_key);

-- Example 16855
CREATE STREAMLIT streamlit_db.streamlit_schema.streamlit_app
  ROOT_LOCATION = '<stage_path_and_root_directory>'
  MAIN_FILE = '<path_to_main_file_in_root_directory>'
  EXTERNAL_ACCESS_INTEGRATIONS = (openai_access_int)
  SECRETS = ('my_openai_key' = streamlit_db.streamlit_schema.openai_key);

-- Example 16856
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

-- Example 16857
[snowflake]
[snowflake.sleep]
streamlitSleepTimeoutMinutes = 8

-- Example 16858
PUT file:///<path_to_your_root_folder>/my_app/config.toml @streamlit_db.streamlit_schema.streamlit_stage/.streamlit/ overwrite=true auto_compress=false;

-- Example 16859
USE ROLE ACCOUNTADMIN;
GRANT READ SESSION ON ACCOUNT TO ROLE streamlit_owner_role;

-- Example 16860
CREATE TABLE row_access_policy_test_table (
    id INT,
    some_data VARCHAR(100),
    the_owner VARCHAR(50)
);

INSERT INTO row_access_policy_test_table (id, some_data, the_owner)
VALUES
    (4, 'Some information 4', 'ALICE'),
    (5, 'Some information 5', 'FRANK'),
    (6, 'Some information 6', 'ALICE');

-- Example 16861
CREATE OR REPLACE ROW ACCESS POLICY st_schema.row_access_policy
AS (the_owner VARCHAR) RETURNS BOOLEAN ->
    the_owner = CURRENT_USER();

-- Example 16862
ALTER TABLE row_access_policy_test_table ADD ROW ACCESS POLICY st_schema.row_access_policy ON (the_owner);

