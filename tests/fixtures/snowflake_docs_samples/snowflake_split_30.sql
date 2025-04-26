-- Example 1973
snow app teardown --cascade --force -c tut-connection

-- Example 1974
snow object list compute-pool -l "na_spcs_tutorial_app_%"

-- Example 1975
references:
  - WAREHOUSE_REFERENCE:
      label: "Warehouse used for ingestion"
      description: "Warehouse which will be used to schedule ingestion tasks"
      privileges: [USAGE]
      object_type: WAREHOUSE
      register_callback: PUBLIC.REGISTER_REFERENCE

-- Example 1976
references:
  - GITHUB_EAI_REFERENCE:
      label: "GitHub API access integration"
      description: "External access integration that will enable connection to the GitHub API using OAuth2"
      privileges: [USAGE]
      object_type: "EXTERNAL ACCESS INTEGRATION"
      register_callback: PUBLIC.REGISTER_REFERENCE
      configuration_callback: PUBLIC.GET_REFERENCE_CONFIG
  - GITHUB_SECRET_REFERENCE:
      label: "GitHub API secret"
      description: "Secret that will enable connection to the GitHub API using OAuth2"
      privileges: [READ]
      object_type: SECRET
      register_callback: PUBLIC.REGISTER_REFERENCE
      configuration_callback: PUBLIC.GET_REFERENCE_CONFIG

-- Example 1977
CREATE OR REPLACE PROCEDURE PUBLIC.GET_REFERENCE_CONFIG(ref_name STRING)
    RETURNS STRING
    LANGUAGE SQL
    AS
        BEGIN
            CASE (ref_name)
                WHEN 'GITHUB_EAI_REFERENCE' THEN
                    RETURN OBJECT_CONSTRUCT(
                        'type', 'CONFIGURATION',
                        'payload', OBJECT_CONSTRUCT(
                            'host_ports', ARRAY_CONSTRUCT('api.github.com'),
                            'allowed_secrets', 'LIST',
                            'secret_references', ARRAY_CONSTRUCT('GITHUB_SECRET_REFERENCE')
                        )
                    )::STRING;
                WHEN 'GITHUB_SECRET_REFERENCE' THEN
                    RETURN OBJECT_CONSTRUCT(
                        'type', 'CONFIGURATION',
                        'payload', OBJECT_CONSTRUCT(
                            'type', 'OAUTH2',
                            'security_integration', OBJECT_CONSTRUCT(
                                'oauth_scopes', ARRAY_CONSTRUCT('repo'),
                                'oauth_token_endpoint', 'https://github.com/login/oauth/access_token',
                                'oauth_authorization_endpoint', 'https://github.com/login/oauth/authorize'
                            )
                        )
                    )::STRING;
                ELSE
                    RETURN '';
            END CASE;
        END;

-- Example 1978
SELECT * FROM DEST_DATABASE.DEST_SCHEMA.ISSUES;

SELECT * FROM DEST_DATABASE.DEST_SCHEMA.ISSUES_VIEW;

-- Example 1979
snow init <project_dir> \
  --template-source https://github.com/snowflakedb/connectors-native-sdk \
  --template templates/connectors-native-sdk-template

-- Example 1980
$ snow init my_connector \
    --template-source https://github.com/snowflakedb/connectors-native-sdk \
    --template templates/connectors-native-sdk-template

Name of the application instance which will be created in Snowflake [connectors-native-sdk-template]: MY_CONNECTOR
Name of the schema in which the connector files stage will be created [TEST_SCHEMA]:
Name of the stage used to store connector files in the application package [TEST_STAGE]: CUSTOM_STAGE_NAME
Initialized the new project in my_connector

-- Example 1981
MERGE INTO STATE.PREREQUISITES AS dest
USING (SELECT * FROM VALUES
           ('1',
            'Sample prerequisite',
            'Prerequisites can be used to notice the end user of the connector about external configurations. Read more in the SDK documentation below. This content can be modified inside `setup.sql` script',
            'https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/flow/prerequisites',
            NULL,
            NULL,
            1
           )
) AS src (id, title, description, documentation_url, learnmore_url, guide_url, position)
ON dest.id = src.id
WHEN NOT MATCHED THEN
    INSERT (id, title, description, documentation_url, learnmore_url, guide_url, position)
    VALUES (src.id, src.title, src.description, src.documentation_url, src.learnmore_url, src.guide_url, src.position);

-- Example 1982
# TODO: Here you can add additional fields in connector configuration.
# For example:
st.subheader("Operational warehouse")
input_col, _ = st.columns([2, 1])
with input_col:
    st.text_input("", key="operational_warehouse", label_visibility="collapsed")
st.caption("Name of the operational warehouse to be used")

-- Example 1983
# TODO: Additional configuration properties can be added to the UI like this:
st.subheader("Additional connection parameter")
input_col, _ = st.columns([2, 1])
with input_col:
    st.text_input("", key="additional_connection_property", label_visibility="collapsed")
st.caption("Some description of the additional property")

-- Example 1984
def finish_config():
try:
    # TODO: If some additional properties were specified they need to be passed to the set_connection_configuration function.
    # The properties can also be validated, for example, check whether they are not blank strings etc.
    response = set_connection_configuration(
        custom_connection_property=st.session_state["custom_connection_property"],
        additional_connection_property=st.session_state["additional_connection_property"],
    )

# rest of the method without changes

-- Example 1985
def set_connection_configuration(custom_connection_property: str, additional_connection_property: str):
    # TODO: this part of the code sends the config to the backend so all custom properties need to be added here
    config = {
        "custom_connection_property": escape_identifier(custom_connection_property),
        "additional_connection_property": escape_identifier(additional_connection_property),
    }

    return call_procedure(
        "PUBLIC.SET_CONNECTION_CONFIGURATION",
        [variant_argument(config)]
    )

-- Example 1986
public class TemplateConfigurationInputValidator implements ConnectionConfigurationInputValidator {

    private static final String ERROR_CODE = "INVALID_CONNECTION_CONFIGURATION";

    @Override
    public ConnectorResponse validate(Variant config) {
      // TODO: IMPLEMENT ME connection configuration validate: If the connection configuration input
      // requires some additional validation this is the place to implement this logic.
      // See more in docs:
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/reference/connection_configuration_reference
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/flow/connection_configuration
      var integrationCheck = checkParameter(config, INTEGRATION_PARAM, false);
      if (!integrationCheck.isOk()) {
        return integrationCheck;
      }

      var secretCheck = checkParameter(config, SECRET_PARAM, true);
      if (!secretCheck.isOk()) {
        return ConnectorResponse.error(ERROR_CODE);
      }

      return ConnectorResponse.success();
    }
}

-- Example 1987
public class TemplateConnectionConfigurationCallback implements ConnectionConfigurationCallback {

    private static final String[] EXTERNAL_SOURCE_PROCEDURE_SIGNATURES = {
        asVarchar(format("%s.%s()", PUBLIC_SCHEMA, TEST_CONNECTION_PROCEDURE)),
        asVarchar(format("%s.%s(VARIANT)", PUBLIC_SCHEMA, FINALIZE_CONNECTOR_CONFIGURATION_PROCEDURE)),
        asVarchar(format("%s.%s(NUMBER, STRING)", PUBLIC_SCHEMA, WORKER_PROCEDURE))
      };

    private final Session session;

    public TemplateConnectionConfigurationCallback(Session session) {
      this.session = session;
    }

    @Override
    public ConnectorResponse execute(Variant config) {
      // TODO: If you need to alter some procedures with external access you can use
      // configureProcedure method or implement a similar method on your own.
      // TODO: IMPLEMENT ME connection callback: Implement the custom logic of changes in application
      // to be done after connection configuration, like altering procedures with external access.
      // See more in docs:
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/reference/connection_configuration_reference
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/flow/connection_configuration
      var response = configureProceduresWithReferences();
      if (response.isNotOk()) {
         return response;
      }
      return ConnectorResponse.success();
    }

    private ConnectorResponse configureProceduresWithReferences() {
      return callProcedure(
        session,
        PUBLIC_SCHEMA,
        SETUP_EXTERNAL_INTEGRATION_WITH_NAMES_PROCEDURE,
        EXTERNAL_SOURCE_PROCEDURE_SIGNATURES);
    }
}

-- Example 1988
public class TemplateConnectionValidator {

    private static final String ERROR_CODE = "TEST_CONNECTION_FAILED";

    public static Variant testConnection(Session session) {
      // TODO: IMPLEMENT ME test connection: Implement the custom logic of testing the connection to
      // the source system here. This usually requires connection to some webservice or other external
      // system. It is suggested to perform only the basic connectivity validation here.
      // If that's the case then this procedure must be altered in TemplateConnectionConfigurationCallback first.
      // See more in docs:
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/reference/connection_configuration_reference
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/flow/connection_configuration
      return test().toVariant();
    }

    private static ConnectorResponse test() {
      try {
        var response = SourceSystemHttpHelper.testEndpoint();

        if (isSuccessful(response.statusCode())) {
          return ConnectorResponse.success();
        } else {
          return ConnectorResponse.error(ERROR_CODE, "Connection to source system failed");
        }
      } catch (Exception exception) {
        return ConnectorResponse.error(ERROR_CODE, "Test connection failed");
      }
    }
}

-- Example 1989
# TODO: Here you can add additional fields in finalize connector configuration.
# For example:
st.subheader("Some additional property")
input_col, _ = st.columns([2, 1])
with input_col:
    st.text_input("", key="some_additional_property", label_visibility="collapsed")
st.caption("Description of some new additional property")

-- Example 1990
def finalize_configuration():
    try:
        st.session_state["show_main_error"] = False
        # TODO: If some additional properties were introduced, they need to be passed to the finalize_connector_configuration function.
        response = finalize_connector_configuration(
            st.session_state.get("custom_property"),
            st.session_state.get("some_additional_property")
        )

-- Example 1991
def finalize_connector_configuration(custom_property: str, some_additional_property: str):
    # TODO: If some custom properties were configured, then they need to be specified here and passed to the FINALIZE_CONNECTOR_CONFIGURATION procedure.
    config = {
        "custom_property": custom_property,
        "some_additional_property": some_additional_property,
    }
    return call_procedure(
        "PUBLIC.FINALIZE_CONNECTOR_CONFIGURATION",
        [variant_argument(config)]
    )

-- Example 1992
public class SourceSystemAccessValidator implements SourceValidator {

    @Override
    public ConnectorResponse validate(Variant variant) {
      // TODO: IMPLEMENT ME validate source: Implement the custom logic of validating the source
      // system. In some cases this can be the same validation that happened in
      // TemplateConnectionValidator.
      // However, it is suggested to perform more complex validations, like specific access rights to
      // some specific resources here.
      // See more in docs:
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/reference/finalize_configuration_reference
      // https://docs.snowflake.com/developer-guide/native-apps/connector-sdk/flow/finalize_configuration
      var finalizeProperties = Configuration.fromCustomConfig(variant);

      var httpResponse = SourceSystemHttpHelper.validateSource(finalizeProperties.get("custom_property"));
      return prepareConnectorResponse(httpResponse.statusCode());
    }

    private ConnectorResponse prepareConnectorResponse(int statusCode) {
      switch (statusCode) {
        case 200:
          return ConnectorResponse.success();
        case 401:
          return ConnectorResponse.error("Unauthorized error");
        case 404:
          return ConnectorResponse.error("Not found error");
        default:
          return ConnectorResponse.error("Unknown error");
      }
    }
}

-- Example 1993
# TODO: specify all the properties needed to define a resource in the source system. A subset of those properties should allow for a identification of a single resource, be it a table, endpoint, repository or some other data storage abstraction
st.text_input(
    "Resource name",
    key="resource_name",
)
st.text_input(
    "Some resource parameter",
    key="some_resource_parameter"
)

-- Example 1994
def queue_resource():
    # TODO: add additional properties here and pass them to create_resource function
    resource_name = st.session_state.get("resource_name")
    some_resource_parameter = st.session_state.get("some_resource_parameter")

    if not resource_name:
        st.error("Resource name cannot be empty")
        return

    result = create_resource(resource_name, some_resource_parameter)
    if result.is_ok():
        st.success("Resource created")
    else:
        st.error(result.get_message())

-- Example 1995
def create_resource(resource_name, some_resource_parameter):
    ingestion_config = [{
        "id": "ingestionConfig",
        "ingestionStrategy": "INCREMENTAL",
        # TODO: HINT: scheduleType and scheduleDefinition are currently not supported out of the box, due to globalSchedule being used. However, a custom implementation of the scheduler can use those fields. They need to be provided because they are mandatory in the resourceDefinition.
        "scheduleType": "INTERVAL",
        "scheduleDefinition": "60m"
    }]
    # TODO: HINT: resource_id should allow identification of a table, endpoint etc. in the source system. It should be unique.
    resource_id = {
        "resource_name": resource_name,
    }
    id = f"{resource_name}_{random_suffix()}"

    # TODO: if you specified some additional resource parameters then you need to put them inside resource metadata:
    resource_metadata = {
        "some_resource_parameter": some_resource_parameter
    }

    return call_procedure("PUBLIC.CREATE_RESOURCE",
                          [
                              varchar_argument(id),
                              variant_argument(resource_id),
                              variant_list_argument(ingestion_config),
                              varchar_argument(id),
                              "true",
                              variant_argument(resource_metadata)
                          ])

-- Example 1996
public final class SourceSystemHttpHelper {

  private static final String DATA_URL = "https://source_system.com/data/%s";
  private static final SourceSystemHttpClient sourceSystemClient = new SourceSystemHttpClient();
  private static final ObjectMapper objectMapper = new ObjectMapper();

  private static List<Variant> fetchData(String resourceId) {
    var response = sourceSystemClient.get(String.format(url, resourceId));
    var body = response.body();

    try {
        return Arrays.stream(objectMapper.readValue(body, Map[].class))
              .map(Variant::new)
              .collect(Collectors.toList());
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Cannot parse json", e);
    }
  }
}

-- Example 1997
public class SourceSystemHttpClient {

  private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(15);

  private final HttpClient client;
  private final String secret;

  public SourceSystemHttpClient() {
    this.client = HttpClient.newHttpClient();
    this.secret =
        SnowflakeSecrets.newInstance()
            .getGenericSecretString(ConnectionConfiguration.TOKEN_NAME);
  }

  public HttpResponse<String> get(String url) {
    var request =
        HttpRequest.newBuilder()
            .uri(URI.create(url))
            .GET()
            .header("Authorization", format("Bearer %s", secret))
            .header("Content-Type", "application/json")
            .timeout(REQUEST_TIMEOUT)
            .build();

    try {
      return client.send(request, HttpResponse.BodyHandlers.ofString());
    } catch (IOException | InterruptedException ex) {
      throw new RuntimeException(format("HttpRequest failed: %s", ex.getMessage()), ex);
    }
  }
}

-- Example 1998
def connection_config_page():
    current_config = get_connection_configuration()

    # TODO: implement the display for all the custom properties defined in the connection configuration step
    custom_property = current_config.get("custom_connection_property", "")
    additional_connection_property = current_config.get("additional_connection_property", "")


    st.header("Connector configuration")
    st.caption("Here you can see the connector connection configuration saved during the connection configuration step "
               "of the Wizard. If some new property was introduced it has to be added here to display.")
    st.divider()

    st.text_input(
        "Custom connection property:",
        value=custom_property,
        disabled=True
    )
    st.text_input(
        "Additional connection property:",
        value=additional_connection_property,
        disabled=True
    )
    st.divider()

-- Example 1999
/*--
• Database, schema, warehouse, and stage creation
--*/

USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS cortex_user_role;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE cortex_user_role;

GRANT ROLE cortex_user_role TO USER <user>;

USE ROLE sysadmin;

-- Create demo database
CREATE OR REPLACE DATABASE cortex_analyst_demo;

-- Create schema
CREATE OR REPLACE SCHEMA cortex_analyst_demo.revenue_timeseries;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE cortex_analyst_wh
    WAREHOUSE_SIZE = 'large'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
COMMENT = 'Warehouse for Cortex Analyst demo';

GRANT USAGE ON WAREHOUSE cortex_analyst_wh TO ROLE cortex_user_role;
GRANT OPERATE ON WAREHOUSE cortex_analyst_wh TO ROLE cortex_user_role;

GRANT OWNERSHIP ON SCHEMA cortex_analyst_demo.revenue_timeseries TO ROLE cortex_user_role;
GRANT OWNERSHIP ON DATABASE cortex_analyst_demo TO ROLE cortex_user_role;


USE ROLE cortex_user_role;

-- Use the created warehouse
USE WAREHOUSE cortex_analyst_wh;

USE DATABASE cortex_analyst_demo;
USE SCHEMA cortex_analyst_demo.revenue_timeseries;

-- Create stage for raw data
CREATE OR REPLACE STAGE raw_data DIRECTORY = (ENABLE = TRUE);

/*--
• Fact and Dimension Table Creation
--*/

-- Fact table: daily_revenue
CREATE OR REPLACE TABLE cortex_analyst_demo.revenue_timeseries.daily_revenue (
    date DATE,
    revenue FLOAT,
    cogs FLOAT,
    forecasted_revenue FLOAT,
    product_id INT,
    region_id INT
);

-- Dimension table: product_dim
CREATE OR REPLACE TABLE cortex_analyst_demo.revenue_timeseries.product_dim (
    product_id INT,
    product_line VARCHAR(16777216)
);

-- Dimension table: region_dim
CREATE OR REPLACE TABLE cortex_analyst_demo.revenue_timeseries.region_dim (
    region_id INT,
    sales_region VARCHAR(16777216),
    state VARCHAR(16777216)
);

-- Example 2000
USE WAREHOUSE cortex_analyst_wh;

COPY INTO cortex_analyst_demo.revenue_timeseries.daily_revenue
FROM @raw_data
FILES = ('daily_revenue.csv')
FILE_FORMAT = (
    TYPE=CSV,
    SKIP_HEADER=1,
    FIELD_DELIMITER=',',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    REPLACE_INVALID_CHARACTERS=TRUE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
    EMPTY_FIELD_AS_NULL = FALSE
    error_on_column_count_mismatch=false
)
ON_ERROR=CONTINUE
FORCE = TRUE ;

COPY INTO cortex_analyst_demo.revenue_timeseries.product_dim
FROM @raw_data
FILES = ('product.csv')
FILE_FORMAT = (
    TYPE=CSV,
    SKIP_HEADER=1,
    FIELD_DELIMITER=',',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    REPLACE_INVALID_CHARACTERS=TRUE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
    EMPTY_FIELD_AS_NULL = FALSE
    error_on_column_count_mismatch=false
)
ON_ERROR=CONTINUE
FORCE = TRUE ;

COPY INTO cortex_analyst_demo.revenue_timeseries.region_dim
FROM @raw_data
FILES = ('region.csv')
FILE_FORMAT = (
    TYPE=CSV,
    SKIP_HEADER=1,
    FIELD_DELIMITER=',',
    TRIM_SPACE=FALSE,
    FIELD_OPTIONALLY_ENCLOSED_BY=NONE,
    REPLACE_INVALID_CHARACTERS=TRUE,
    DATE_FORMAT=AUTO,
    TIME_FORMAT=AUTO,
    TIMESTAMP_FORMAT=AUTO
    EMPTY_FIELD_AS_NULL = FALSE
    error_on_column_count_mismatch=false
)
ON_ERROR=CONTINUE
FORCE = TRUE ;

-- Example 2001
from typing import Any, Dict, List, Optional

import pandas as pd
import requests
import snowflake.connector
import streamlit as st

DATABASE = "CORTEX_ANALYST_DEMO"
SCHEMA = "REVENUE_TIMESERIES"
STAGE = "RAW_DATA"
FILE = "revenue_timeseries.yaml"
WAREHOUSE = "cortex_analyst_wh"

# replace values below with your Snowflake connection information
HOST = "<host>"
ACCOUNT = "<account>"
USER = "<user>"
PASSWORD = "<password>"
ROLE = "<role>"

if 'CONN' not in st.session_state or st.session_state.CONN is None:
    st.session_state.CONN = snowflake.connector.connect(
        user=USER,
        password=PASSWORD,
        account=ACCOUNT,
        host=HOST,
        port=443,
        warehouse=WAREHOUSE,
        role=ROLE,
    )

def send_message(prompt: str) -> Dict[str, Any]:
    """Calls the REST API and returns the response."""
    request_body = {
        "messages": [{"role": "user", "content": [{"type": "text", "text": prompt}]}],
        "semantic_model_file": f"@{DATABASE}.{SCHEMA}.{STAGE}/{FILE}",
    }
    resp = requests.post(
        url=f"https://{HOST}/api/v2/cortex/analyst/message",
        json=request_body,
        headers={
            "Authorization": f'Snowflake Token="{st.session_state.CONN.rest.token}"',
            "Content-Type": "application/json",
        },
    )
    request_id = resp.headers.get("X-Snowflake-Request-Id")
    if resp.status_code < 400:
        return {**resp.json(), "request_id": request_id}  # type: ignore[arg-type]
    else:
        raise Exception(
            f"Failed request (id: {request_id}) with status {resp.status_code}: {resp.text}"
        )

def process_message(prompt: str) -> None:
    """Processes a message and adds the response to the chat."""
    st.session_state.messages.append(
        {"role": "user", "content": [{"type": "text", "text": prompt}]}
    )
    with st.chat_message("user"):
        st.markdown(prompt)
    with st.chat_message("assistant"):
        with st.spinner("Generating response..."):
            response = send_message(prompt=prompt)
            request_id = response["request_id"]
            content = response["message"]["content"]
            display_content(content=content, request_id=request_id)  # type: ignore[arg-type]
    st.session_state.messages.append(
        {"role": "assistant", "content": content, "request_id": request_id}
    )

def display_content(
    content: List[Dict[str, str]],
    request_id: Optional[str] = None,
    message_index: Optional[int] = None,
) -> None:
    """Displays a content item for a message."""
    message_index = message_index or len(st.session_state.messages)
    if request_id:
        with st.expander("Request ID", expanded=False):
            st.markdown(request_id)
    for item in content:
        if item["type"] == "text":
            st.markdown(item["text"])
        elif item["type"] == "suggestions":
            with st.expander("Suggestions", expanded=True):
                for suggestion_index, suggestion in enumerate(item["suggestions"]):
                    if st.button(suggestion, key=f"{message_index}_{suggestion_index}"):
                        st.session_state.active_suggestion = suggestion
        elif item["type"] == "sql":
            with st.expander("SQL Query", expanded=False):
                st.code(item["statement"], language="sql")
            with st.expander("Results", expanded=True):
                with st.spinner("Running SQL..."):
                    df = pd.read_sql(item["statement"], st.session_state.CONN)
                    if len(df.index) > 1:
                        data_tab, line_tab, bar_tab = st.tabs(
                            ["Data", "Line Chart", "Bar Chart"]
                        )
                        data_tab.dataframe(df)
                        if len(df.columns) > 1:
                            df = df.set_index(df.columns[0])
                        with line_tab:
                            st.line_chart(df)
                        with bar_tab:
                            st.bar_chart(df)
                    else:
                        st.dataframe(df)

st.title("Cortex Analyst")
st.markdown(f"Semantic Model: `{FILE}`")

if "messages" not in st.session_state:
    st.session_state.messages = []
    st.session_state.suggestions = []
    st.session_state.active_suggestion = None

for message_index, message in enumerate(st.session_state.messages):
    with st.chat_message(message["role"]):
        display_content(
            content=message["content"],
            request_id=message.get("request_id"),
            message_index=message_index,
        )

if user_input := st.chat_input("What is your question?"):
    process_message(prompt=user_input)

if st.session_state.active_suggestion:
    process_message(prompt=st.session_state.active_suggestion)
    st.session_state.active_suggestion = None

-- Example 2002
DROP DATABASE IF EXISTS cortex_analyst_demo;
DROP WAREHOUSE IF EXISTS cortex_analyst_wh;

-- Example 2003
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS governance_db;
CREATE SCHEMA IF NOT EXISTS governance_db.sch;

-- Example 2004
CREATE WAREHOUSE IF NOT EXISTS tutorial_wh;

-- Example 2005
CREATE DATABASE IF NOT EXISTS data_db;
CREATE SCHEMA IF NOT EXISTS data_db.sch;

-- Example 2006
CREATE TABLE data_db.sch.customers (
  account_number NUMBER(38,0),
  first_name VARCHAR(16777216),
  last_name VARCHAR(16777216),
  email VARCHAR(16777216)
);

-- Example 2007
USE WAREHOUSE tutorial_wh;

INSERT INTO data_db.sch.customers (account_number, first_name, last_name, email)
  VALUES
    (1589420, 'john', 'doe', 'john.doe@example.com'),
    (2834123, 'jane', 'doe', 'jane.doe@example.com'),
    (4829381, 'jim', 'doe', 'jim.doe@example.com'),
    (9821802, 'susan', 'smith', 'susan.smith@example.com'),
    (8028387, 'bart', 'simpson', 'bart.barber@example.com');

-- Example 2008
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  governance_db.sch.my_classification_profile(
      {
        'minimum_object_age_for_classification_days': 0,
        'maximum_classification_validity_days': 30,
        'auto_tag': true
      });

-- Example 2009
CREATE TAG governance_db.sch.tutorial_pii;

-- Example 2010
CALL governance_db.sch.my_classification_profile!SET_TAG_MAP(
  {'column_tag_map':[
    {
      'tag_name':'governance_db.sch.tutorial_pii',
      'tag_value':'sensitive_name',
      'semantic_categories':['NAME']
    }]});

-- Example 2011
ALTER SCHEMA data_db.sch
  SET CLASSIFICATION_PROFILE = 'governance_db.sch.my_classification_profile';

-- Example 2012
CALL SYSTEM$GET_CLASSIFICATION_RESULT('data_db.sch.customers');

-- Example 2013
{
  "classification_profile_config": {
    "classification_profile_name": "GOVERNANCE_DB.SCH.MY_CLASSIFICATION_PROFILE"
  },
  "classification_result": {
    "ACCOUNT_NUMBER": {
      "alternates": []
    },
    "EMAIL": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "EMAIL",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "EMAIL"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          }
        ]
      },
      "valid_value_ratio": 1
    },
    "FIRST_NAME": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "NAME",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "NAME"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "governance_db.sch.tutorial_pii",
            "tag_value": "sensitive_name"
          }
        ]
      },
      "valid_value_ratio": 1
    },
    "LAST_NAME": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "NAME",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "NAME"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "governance_db.sch.tutorial_pii",
            "tag_value": "sensitive_name"
          }
        ]
      },
      "valid_value_ratio": 1
    }
  }
}

-- Example 2014
DROP TAG governance_db.sch.tutorial_pii;
DROP DATABASE governance_db;
DROP DATABASE data_db;
DROP WAREHOUSE tutorial_wh;

-- Example 2015
ID|lastname|firstname|company|email|workphone|cellphone|streetaddress|city|postalcode
6|Reed|Moses|Neque Corporation|eget.lacus@facilisis.com|1-449-871-0780|1-454-964-5318|Ap #225-4351 Dolor Ave|Titagarh|62631

-- Example 2016
[
 {
   "customer": {
     "address": "509 Kings Hwy, Comptche, Missouri, 4848",
     "phone": "+1 (999) 407-2274",
     "email": "blankenship.patrick@orbin.ca",
     "company": "ORBIN",
     "name": {
       "last": "Patrick",
       "first": "Blankenship"
     },
     "_id": "5730864df388f1d653e37e6f"
   }
 },
]

-- Example 2017
-- Create a database. A database automatically includes a schema named 'public'.

CREATE OR REPLACE DATABASE mydatabase;

/* Create target tables for CSV and JSON data. The tables are temporary, meaning they persist only for the duration of the user session and are not visible to other users. */

CREATE OR REPLACE TEMPORARY TABLE mycsvtable (
  id INTEGER,
  last_name STRING,
  first_name STRING,
  company STRING,
  email STRING,
  workphone STRING,
  cellphone STRING,
  streetaddress STRING,
  city STRING,
  postalcode STRING);

CREATE OR REPLACE TEMPORARY TABLE myjsontable (
  json_data VARIANT);

-- Create a warehouse

CREATE OR REPLACE WAREHOUSE mywarehouse WITH
  WAREHOUSE_SIZE='X-SMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED=TRUE;

-- Example 2018
CREATE OR REPLACE FILE FORMAT mycsvformat
  TYPE = 'CSV'
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1;

-- Example 2019
CREATE OR REPLACE FILE FORMAT myjsonformat
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Example 2020
CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat;

-- Example 2021
CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = myjsonformat;

-- Example 2022
PUT file:///tmp/load/contacts*.csv @my_csv_stage AUTO_COMPRESS=TRUE;

-- Example 2023
PUT file://C:\temp\load\contacts*.csv @my_csv_stage AUTO_COMPRESS=TRUE;

-- Example 2024
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source        | target           | source_size | target_size | source_compression | target_compression | status   | message |
|---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| contacts1.csv | contacts1.csv.gz |         694 |         506 | NONE               | GZIP               | UPLOADED |         |
| contacts2.csv | contacts2.csv.gz |         763 |         565 | NONE               | GZIP               | UPLOADED |         |
| contacts3.csv | contacts3.csv.gz |         771 |         567 | NONE               | GZIP               | UPLOADED |         |
| contacts4.csv | contacts4.csv.gz |         750 |         561 | NONE               | GZIP               | UPLOADED |         |
| contacts5.csv | contacts5.csv.gz |         887 |         621 | NONE               | GZIP               | UPLOADED |         |
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+

-- Example 2025
PUT file:///tmp/load/contacts.json @my_json_stage AUTO_COMPRESS=TRUE;

-- Example 2026
PUT file://C:\temp\load\contacts.json @my_json_stage AUTO_COMPRESS=TRUE;

-- Example 2027
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source        | target           | source_size | target_size | source_compression | target_compression | status   | message |
|---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| contacts.json | contacts.json.gz |         965 |         446 | NONE               | GZIP               | UPLOADED |         |
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+

-- Example 2028
LIST @my_csv_stage;

-- Example 2029
LIST @my_json_stage;

-- Example 2030
COPY INTO mycsvtable
  FROM @my_csv_stage/contacts1.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

-- Example 2031
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                        | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts1.csv.gz | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 2032
COPY INTO mycsvtable
  FROM @my_csv_stage
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  PATTERN='.*contacts[1-5].csv.gz'
  ON_ERROR = 'skip_file';

-- Example 2033
+-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+
| file                        | status      | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                                                                                                                                                          | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts2.csv.gz | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| mycsvtable/contacts3.csv.gz | LOAD_FAILED |           5 |           0 |           1 |           2 | Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error |                3 |                     1 | "MYCSVTABLE"[11]        |
| mycsvtable/contacts4.csv.gz | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| mycsvtable/contacts5.csv.gz | LOADED      |           6 |           6 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
+-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+

-- Example 2034
COPY INTO myjsontable
  FROM @my_json_stage/contacts.json.gz
  FILE_FORMAT = (FORMAT_NAME = myjsonformat)
  ON_ERROR = 'skip_file';

-- Example 2035
+------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                         | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| myjsontable/contacts.json.gz | LOADED |           3 |           3 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 2036
CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(mycsvtable, JOB_ID=>'<query_id>'));

-- Example 2037
SELECT * FROM SAVE_COPY_ERRORS;

-- Example 2038
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| ERROR                                                                                                                                                                | FILE                                | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |   CODE | SQL_STATE | COLUMN_NAME                   | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error | mycsvtable/contacts3.csv.gz         |    3 |         1 |         234 | parsing  | 100080 |     22000 | "MYCSVTABLE"[11]              |          1 |              2 | 11|Ishmael|Burnett|Dolor Elit Pellentesque Ltd|vitae.erat@necmollisvitae.ca|1-872|600-7301|1-513-592-6779|P.O. Box 975, 553 Odio, Road|Hulste|63345 |
| Field delimiter '|' found while expecting record delimiter '\n'                                                                                                      | mycsvtable/contacts3.csv.gz         |    5 |       125 |         625 | parsing  | 100016 |     22000 | "MYCSVTABLE"["POSTALCODE":10] |          4 |              5 | 14|Sophia|Christian|Turpis Ltd|lectus.pede@non.ca|1-962-503-3253|1-157-|850-3602|P.O. Box 824, 7971 Sagittis Rd.|Chattanooga|56188                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 2039
PUT file:///tmp/load/contacts3.csv @my_csv_stage AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

-- Example 2040
PUT file://C:\temp\load\contacts3.csv @my_csv_stage AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

