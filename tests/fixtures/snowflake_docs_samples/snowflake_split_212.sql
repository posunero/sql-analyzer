-- Example 14184
USE ROLE ACCOUNTADMIN;
GRANT READ SESSION ON ACCOUNT TO ROLE streamlit_owner_role;

-- Example 14185
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

-- Example 14186
CREATE OR REPLACE ROW ACCESS POLICY st_schema.row_access_policy
AS (the_owner VARCHAR) RETURNS BOOLEAN ->
    the_owner = CURRENT_USER();

-- Example 14187
ALTER TABLE row_access_policy_test_table ADD ROW ACCESS POLICY st_schema.row_access_policy ON (the_owner);

-- Example 14188
GRANT READ SESSION ON ACCOUNT TO ROLE streamlit_owner_role;

-- Example 14189
# Import Python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

st.title("CURRENT_USER() + Row Access Policy in SiS Demo :balloon:")
st.write(
        """You can access `CURRENT_USER()` and data from tables with row access policies
        in Streamlit in Snowflake apps
        """)

# Get the current credentials
session = get_active_session()

st.header('Demo')

st.subheader('Credentials')
sql = "SELECT CURRENT_USER();"
df = session.sql(sql).collect()
st.write(df)

st.subheader('Row Access on a Table')
sql = "SELECT * FROM st_db.st_schema.row_access_policy_test_table;"
df = session.sql(sql).collect()

st.write(df)

-- Example 14190
Could not reload streamlit files.
Error: 092806 (P0002): The specified Streamlit was not found.

-- Example 14191
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_creator;
GRANT USAGE ON WAREHOUSE streamlit_wh TO ROLE streamlit_creator;
GRANT CREATE STREAMLIT ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT CREATE STAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Example 14192
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_role;
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;
GRANT USAGE ON STREAMLIT streamlit_db.streamlit_schema.streamlit_app TO ROLE streamlit_role;

-- Example 14193
GRANT USAGE ON FUTURE STREAMLITS IN SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;

-- Example 14194
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Get the current credentials
session = get_active_session()

warehouse_sql = f"USE WAREHOUSE LARGE_WH"
session.sql(warehouse_sql).collect()

# Execute the SQL using a different warehouse
sql = """SELECT * from MY_DB.INFORMATION_SCHEMA.PACKAGES limit 100"""
session.sql(sql).collect()

-- Example 14195
CREATE OR REPLACE TABLE <your_database>.<your_schema>.BUG_REPORT_DATA (
  AUTHOR VARCHAR(25),
  BUG_TYPE VARCHAR(25),
  COMMENT VARCHAR(100),
  DATE DATE,
  BUG_SEVERITY NUMBER(38,0)
);

-- Example 14196
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

-- Example 14197
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

-- Example 14198
manifest_version: 1 # required
version:
  name: hello_snowflake
  patch: 3
  label: "v1.0"
  comment: "The first version of a Snowflake Native App"

artifacts:
  readme: readme.md
  setup_script: scripts/setup.sql
  default_streamlit: streamlit/ux_schema.homepage_streamlit

configuration:
  log_level: debug
  trace_level: always
  metric_level: all

privileges:
  - EXECUTE TASK:
      description: "Run ingestion tasks for replicating Redshift data"
  - EXECUTE MANAGED TASK:
      description: "To run serverless ingestion tasks for replicating Redshift data"
  - CREATE WAREHOUSE:
      description: "To create warehouses for executing tasks"
  - MANAGE WAREHOUSES:
      description: "To manage warehouses for optimizing the efficiency of your accounts"
  - CREATE DATABASE:
      description: "To create sink databases for replicating Redshift data"
  - IMPORTED PRIVILEGES ON SNOWFLAKE DB:
      description: "To access account_usage views"
  - READ SESSION:
      description: "To allow Streamlit to access some context functions"

references:
  - consumer_table:
      label: "Consumer table"
      description: "A table in the consumer account that exists outside the APPLICATION object."
      privileges:
        - SELECT
        - INSERT
        - UPDATE
      object_type: Table
      multi_valued: true
      register_callback: config.register_reference
  - consumer_external_access:
      label: "Consumer external access integration"
      description: "An external access integration in the consumer account that exists outside the APPLICATION object."
      privileges:
        - USAGE
      object_type: EXTERNAL ACCESS INTEGRATION
      register_callback: config.register_reference
      configuration_callback: config.get_configuration_for_reference
      required_at_setup: true

-- Example 14199
/<database>/<schema>/<image_repository>/<image_name>:tag

-- Example 14200
artifacts
...
  container_services
    ...
    images
      - /dev_db/dev_schema/dev_repo/image1
      - /dev_db/dev_schema/dev_repo/image2

-- Example 14201
default_web_endpoint:
  service: ux_schema.ux_service
  endpoint: ui

-- Example 14202
privileges:
- CREATE COMPUTE POOL
  description: 'Required to allow the app to create a compute pool in the consumer account.'
- BIND SERVICE ENDPOINT
  description: 'Required to allow endpoints to be externally accessible.'

-- Example 14203
manifest_version: 1

version:
  name: v1

artifacts:
  readme: readme.md
  setup_script: setup.sql
  container_services:
    images:
      - /dev_db/dev_schema/dev_repo/image1
      - /dev_db/dev_schema/dev_repo/image2

  default_web_endpoint:
    service: ux_schema.ux_service
    endpoint: ui

privileges:
 - CREATE COMPUTE POOL
   description: "...”
 - BIND SERVICE ENDPOINT
   description: "...”

-- Example 14204
CREATE APPLICATION PACKAGE HelloSnowflakePackage;

-- Example 14205
GRANT MANAGE RELEASES ON APPLICATION PACKAGE hello_snowflake_package TO ROLE app_release_mgr;

-- Example 14206
GRANT OWNERSHIP ON APPLICATION PACKAGE hello_snowflake_package TO ROLE native_app_dev;

-- Example 14207
DROP APPLICATION PACKAGE hello_snowflake_package;

-- Example 14208
@DEV_DB.DEV_SCHEMA.DEV_STAGE/V1:
└── app_files/
    └── dev
        ├── manifest.yml
        └── scripts/
            ├── setup_script.sql
            └── libraries/
                └── jars/
                    ├── lookup.jar
                    └── log4j.jar
            └── python
                └── evaluation.py

-- Example 14209
CREATE PROCEDURE PROGRAMS.LOOKUP(...)
  RETURNS STRING
  LANGUAGE JAVA
  PACKAGES = ('com.snowflake:snowpark:latest')
  IMPORTS = ('/scripts/libraries/jar/lookup.jar',
             '/scripts/libraries/jar/log4j.jar')
  HANDLER = 'com.acme.programs.Lookup';

-- Example 14210
CREATE OR ALTER VERSIONED SCHEMA app_code;
CREATE STAGE app_code.app_jars;

CREATE FUNCTION app_code.add(x INT, y INT)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  TARGET_PATH = '@app_code.app_jars/TestAddFunc.jar'
  AS
  $$
  class TestAddFunc {
    public static int add(int x, int y) {
      Return x + y;
    }
  }
  $$;

-- Example 14211
@DEV_DB.DEV_SCHEMA.DEV_STAGE/V1:
└── V1/
    ├── manifest.yml
    ├── setup_script.sql
    └── JARs/
        ├── Java/
        │   └── TestAddFunc.jar
        └── Scala/
            └── TestMulFunc.jar

-- Example 14212
CREATE FUNCTION app_code.add(x INTEGER, y INTEGER)
  RETURNS INTEGER
  LANGUAGE JAVA
  HANDLER = 'TestAddFunc.add'
  IMPORTS = ('/JARs/Java/TestAddFunc.jar');

-- Example 14213
CREATE FUNCTION app_code.py_echo_func(str STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'echo'
AS
$$
def echo(str):
  return "ECHO: " + str
$$;

-- Example 14214
CREATE FUNCTION PY_PROCESS_DATA_FUNC()
  RETURNS STRING
  LANGUAGE PYTHON
  HANDLER = 'TestPythonFunc.process'
  IMPORTS = ('/python_modules/TestPythonFunc.py',
    '/python_modules/data.csv')

-- Example 14215
CREATE OR REPLACE PROCEDURE APP_SCHEMA.ERROR_CATCH()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS OWNER
  AS $$
    try {
      let x = y.length;
    }
    catch(err){
      return "There is an error.";
    }
    return "Done";
  $$;

-- Example 14216
CREATE OR REPLACE PROCEDURE calculator.create_external_function(integration_name STRING)
  RETURNS STRING
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  DECLARE
    CREATE_STATEMENT VARCHAR;
  BEGIN
    CREATE_STATEMENT := 'CREATE OR REPLACE EXTERNAL FUNCTION EXTERNAL_ADD(NUM1 FLOAT, NUM2 FLOAT)
        RETURNS FLOAT API_INTEGRATION = ? AS ''https://xyz.execute-api.us-west-2.amazonaws.com/production/sum'';' ;
    EXECUTE IMMEDIATE :CREATE_STATEMENT USING (INTEGRATION_NAME);
    RETURN 'EXTERNAL FUNCTION CREATED';
  END;

GRANT USAGE ON PROCEDURE calculator.create_external_function(string) TO APPLICATION ROLE app_public;

-- Example 14217
CREATE APPLICATION PACKAGE app_package;

GRANT USAGE ON SCHEMA app_package.shared_schema
  TO SHARE IN APPLICATION PACKAGE app_package;
GRANT SELECT ON TABLE app_package.shared_schema.shared_table
  TO SHARE IN APPLICATION PACKAGE app_package;

-- Example 14218
GRANT REFERENCE_USAGE ON DATABASE other_db
  TO SHARE IN APPLICATION PACKAGE app_pkg;

-- Example 14219
CREATE VIEW app_pkg.shared_schema.shared_view
  AS SELECT c1, c2, c3, c4
  FROM other_db.other_schema.other_table;

-- Example 14220
GRANT USAGE ON SCHEMA app_pkg.shared_schema
  TO SHARE IN APPLICATION PACKAGE app_pkg;
GRANT SELECT ON VIEW app_pkg.shared_schema.shared_view
  TO SHARE IN APPLICATION PACKAGE app_pkg;

-- Example 14221
CREATE APPLICATION ROLE app_user;

CREATE OR ALTER VERSIONED SCHEMA inst_schema;
GRANT USAGE ON SCHEMA inst_schema
  TO APPLICATION ROLE app_user;

CREATE VIEW IF NOT EXISTS inst_schema.shared_view
  AS SELECT c1, c2, c3, c4
  FROM shared_schema.shared_table;

GRANT SELECT ON VIEW inst_schema.shared_view
  TO APPLICATION ROLE app_user;

-- Example 14222
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql
    └── code_artifacts/
        └── streamlit/
            └── environment.yml
            └── streamlit_app.py

-- Example 14223
CREATE OR REPLACE STREAMLIT app_schema.my_test_app_na
     FROM '/code_artifacts/streamlit'
     MAIN_FILE = '/streamlit_app.py';

GRANT USAGE ON SCHEMA APP_SCHEMA TO APPLICATION ROLE app_public;
GRANT USAGE ON STREAMLIT APP_SCHEMA.MY_TEST_APP_NA TO APPLICATION ROLE app_public;

-- Example 14224
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn

-- Example 14225
name: sf_env
channels:
- snowflake
dependencies:
- streamlit=1.22.0|1.26.0

-- Example 14226
artifacts:
  ...
  default_streamlit: app_schema.streamlit_app_na
  ...

-- Example 14227
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

-- Example 14228
artifacts:
  readme: readme.md
  setup_script: scripts/setup.sql
  container_services:
    uses_gpu: true|false
    images:
    - /provider_db/provider_schema/provider_repo/server:prod
    - /provider_db/provider_schema/provider_repo/web:1.0

-- Example 14229
...
privileges:
 - CREATE COMPUTE POOL
   description: "Enable application to create one to five compute pools"
 ...

-- Example 14230
CREATE COMPUTE POOL IF NOT EXISTS app_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = standard_1
  AUTO_RESUME = true;

-- Example 14231
LET POOL_NAME := (select current_database()) || '_app_pool';
CREATE COMPUTE POOL IF NOT EXISTS identifier(:pool_name)
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = STANDARD_2;

-- Example 14232
CREATE OR REPLACE PROCEDURE public.create_cp()
 RETURNS VARCHAR
 LANGUAGE SQL
 EXECUTE AS OWNER
 AS $$
  BEGIN
      LET POOL_NAME := (select current_database()) || '_app_pool';
      LET INSTANCE_FAMILY := IFF( CONTAINS(current_region(), 'AZURE') , 'GPU_NV_XS' , 'GPU_NV_S' );
      CREATE COMPUTE POOL IF NOT EXISTS identifier(:pool_name)
          MIN_NODES = 1
          MAX_NODES = 1
          INSTANCE_FAMILY = :instance_family;
      RETURN 'Compute Pool Created';
  END;
$$;

-- Example 14233
CREATE SERVICE IF NOT EXISTS app_service
  IN COMPUTE POOL app_compute_pool
  FROM SPECIFICATION_FILE = '/containers/service1_spec.yaml';

-- Example 14234
CREATE SERVICE IF NOT EXISTS app_service
  IN COMPUTE POOL app_compute_pool
  FROM SPECIFICATION_TEMPLATE_FILE = '/containers/service1_spec.yaml';

-- Example 14235
configuration:
  log_level: INFO
  trace_level: ALWAYS
  metric_level: ALL
  grant_callback: core.grant_callback

-- Example 14236
CREATE SCHEMA core;
 CREATE APPLICATION ROLE app_public;

 CREATE OR REPLACE PROCEDURE core.grant_callback(privileges array)
 RETURNS STRING
 AS $$
 BEGIN
   IF (ARRAY_CONTAINS('CREATE COMPUTE POOL'::VARIANT, privileges)) THEN
      CREATE COMPUTE POOL IF NOT EXISTS app_compute_pool
          MIN_NODES = 1
          MAX_NODES = 3
          INSTANCE_FAMILY = GPU_NV_M;
   END IF;
   IF (ARRAY_CONTAINS('BIND SERVICE ENDPOINT'::VARIANT, privileges)) THEN
      CREATE SERVICE IF NOT EXISTS core.app_service
       IN COMPUTE POOL my_compute_pool
       FROM SPECIFICATION_FILE = '/containers/service1_spec.yaml';
   END IF;
   RETURN 'DONE';
 END;
 $$;

GRANT USAGE ON PROCEDURE core.grant_callback(array) TO APPLICATION ROLE app_public;

-- Example 14237
EXECUTE JOB SERVICE
  IN COMPUTE POOL consumer_compute_pool
  FROM SPECIFICATION_FILE = 'job_service.yml'
  NAME = 'services_schema.job_service'

GRANT MONITOR ON SERVICE services.job_service TO APPLICATION ROLE app_public;

-- Example 14238
CALL SYSTEM$GET_SERVICE_STATUS('schema.job_name')

-- Example 14239
CALL SYSTEM$GET_SERVICE_LOGS('schema.job_name', 'instance_id', 'container_name'[, 10])

-- Example 14240
references:
  ...
  - my_external_access:
      label: "Default External Access Integration"
      description: "This EAI is required to access xyz.com"
      privileges:
        - USAGE
      object_type: EXTERNAL ACCESS INTEGRATION
      required_at_setup: true
      register_callback: config.REGISTER_EAI_CALLBACK
      configuration_callback: config.get_config_for_ref

-- Example 14241
references:
 ...
 - consumer_secret:
     label: "Consumer secret"
     description: "Needed to authenticate with an external endpoint"
     privileges:
       - READ
     object_type: SECRET
     register_callback: config.register_my_secret
     configuration_callback: config.get_config_for_ref

-- Example 14242
CREATE OR REPLACE PROCEDURE CONFIG.GET_CONFIG_FOR_REFERENCE(ref_name STRING)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
 CASE (UPPER(ref_name))
   WHEN 'my_external_access' THEN
     RETURN '{
       "type": "CONFIGURATION",
       "payload":{
         "host_ports":["google.com"],
         "allowed_secrets" : "LIST",
         "secret_references":["CONSUMER_SECRET"]}}';
   WHEN 'consumer_secret' THEN
     RETURN '{
       "type": "CONFIGURATION",
       "payload":{
         "type" : "OAUTH2",
         "security_integration": {
           "oauth_scopes": ["https://www.googleapis.com/auth/analytics.readonly"],
           "oauth_token_endpoint": "https://oauth2.googleapis.com/token",
           "oauth_authorization_endpoint":
               "https://accounts.google.com/o/oauth2/auth"}}}';
  END CASE;
  RETURN '';
END;
$$;

-- Example 14243
GRANT USAGE ON PROCEDURE CONFIG.GET_CONFIG_FOR_REFERENCE(STRING)
  TO APPLICATION ROLE app_admin;

-- Example 14244
CREATE DATABASE provider_db;
CREATE SCHEMA provider_schema;
CREATE IMAGE REPOSITORY provider_repo;

-- Example 14245
$ docker login org-provider-account.registry.snowflakecomputing.com
$ docker build --rm --platform linux/amd64 -t service:1.0 .
$ docker tag service:1.0 org-provider-account.registry.snowflakecomputing.com/provider_db/provider_schema/provider_repo/service:1.0
$ docker push org-provider-account.registry.snowflakecomputing.comprovider_db/provider_schema/provider_repo/service:1.0

-- Example 14246
spec:
  containers:
  - image: /provider_db/provider_schema/provider_repo/server:prod
    name: server
    ...
  - image: /provider_db/provider_schema/provider_repo/web:1.0
    name: web
    ...
  endpoints:
  - name: invoke
    port: 8000
  - name: ui
    port: 5000
    public: true

-- Example 14247
spec:
  containers:
  - image: /provider_db/provider_schema/provider_repo/server:prod
    name: my_app_container
  endpoints:
  - name: invoke
    port: 8000
  - name: ui
    port: 5000
    public: true

-- Example 14248
GRANT CREATE APPLICATION ON ACCOUNT TO ROLE provider_role;
GRANT INSTALL ON APPLICATION PACKAGE hello_snowflake_package
  TO ROLE provider_role;

-- Example 14249
GRANT DEVELOP ON APPLICATION PACKAGE hello_snowflake_package TO ROLE other_dev_role;

-- Example 14250
CREATE APPLICATION hello_snowflake_app FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

