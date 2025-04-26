-- Example 17867
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>",
  "SQLCODE": "<code of a thrown exception>",
  "SQLERRM": "<error message of a thrown exception>",
  "SQLCODE": "<sql code of a thrown exception>"
}

-- Example 17868
CALL PUBLIC.SETUP_EXTERNAL_INTEGRATION_WITH_NAMES(ARRAY_CONSTRUCT(
    'PUBLIC.TEST_CONNECTION()',
    'PUBLIC.FINALIZE_CONFIGURATION(VARIANT)',
    'PUBLIC.TEMPLATE_WORKER(NUMBER, STRING)')
);

-- Example 17869
CREATE OR REPLACE PROCEDURE PUBLIC.SETUP_EXTERNAL_INTEGRATION_WITH_REFERENCES(methods ARRAY)
    RETURNS VARIANT
    LANGUAGE SQL
    [...]

-- Example 17870
{
  "response_code": "OK",
  "message": "Successfully set up <number> method(s)."
}

-- Example 17871
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>",
  "SQLCODE": "<code of a thrown exception>",
  "SQLERRM": "<error message of a thrown exception>",
  "SQLCODE": "<sql code of a thrown exception>"
}

-- Example 17872
CALL PUBLIC.SETUP_EXTERNAL_INTEGRATION_WITH_REFERENCES(ARRAY_CONSTRUCT(
    'PUBLIC.TEST_CONNECTION()',
    'PUBLIC.FINALIZE_CONFIGURATION(VARIANT)',
    'PUBLIC.TEMPLATE_WORKER(NUMBER, STRING)')
);

-- Example 17873
CREATE OR REPLACE PROCEDURE PUBLIC.SETUP_EXTERNAL_INTEGRATION(eai_idf VARCHAR, secret_idf VARCHAR, methods ARRAY)
    RETURNS VARIANT
    LANGUAGE SQL
    [...]

-- Example 17874
{
  "response_code": "OK",
  "message": "Successfully set up <number> method(s)."
}

-- Example 17875
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>",
  "SQLCODE": "<code of a thrown exception>",
  "SQLERRM": "<error message of a thrown exception>",
  "SQLCODE": "<sql code of a thrown exception>"
}

-- Example 17876
CALL PUBLIC.SETUP_EXTERNAL_INTEGRATION(
    'EXAMPLE_EAI_IDF',
    'reference(\'CUSTOM_REFERENCE_NAME\')',
    ARRAY_CONSTRUCT('PUBLIC.TEST_CONNECTION()',
    'PUBLIC.FINALIZE_CONFIGURATION(VARIANT)',
    'PUBLIC.TEMPLATE_WORKER(NUMBER, STRING)')
);

-- Example 17877
EXECUTE IMMEDIATE $$
    DECLARE
        eai_idf VARCHAR;
        secret_idf VARCHAR;
    BEGIN
        -- retrieve name of an EXTERNAL ACCESS INTEGRATION object
        :eai_idf = <eai_object_name>;

        -- retrieve name of a SECRET object
        :secret_idf = <secret_object_name>;

        CALL PUBLIC.SETUP_EXTERNAL_INTEGRATION(
            :eai_idf,
            :secret_idf,
            ARRAY_CONSTRUCT('PUBLIC.TEST_CONNECTION()',
            'PUBLIC.FINALIZE_CONFIGURATION(VARIANT)',
            'PUBLIC.TEMPLATE_WORKER(NUMBER, STRING)')
        );
    END;
$$
;

-- Example 17878
{
    "status": "STARTED",
    "configurationStatus": "FINALIZED"
}

-- Example 17879
{
  "response_code": "OK"
}

-- Example 17880
{
  "response_code": "<ERROR_CODE>",
  "message": "<error message>"
}

-- Example 17881
CREATE OR REPLACE PROCEDURE PUBLIC.FINALIZE_CONNECTOR_CONFIGURATION(CUSTOM_CONFIGURATION VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomFinalizeConnectorHandler.finalizeConnectorConfiguration';

GRANT USAGE ON PROCEDURE PUBLIC.CONFIGURE_CONNECTOR(VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 17882
CREATE OR REPLACE PROCEDURE PUBLIC.FINALIZE_CONNECTOR_CONFIGURATION_INTERNAL(config VARIANT)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- SOME CUSTOM LOGIC BEGIN
    SELECT sysdate();
    -- SOME CUSTOM LOGIC END

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

CREATE OR REPLACE PROCEDURE PUBLIC.FINALIZE_CONNECTOR_CONFIGURATION_VALIDATE (config VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomFinalizeConnectorConfigurationValidateHandler.validate';

-- Example 17883
class CustomFinalizeConnectorValidator implements FinalizeConnectorValidator {
  @Override
  public ConnectorResponse validate(Variant config) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.FINALIZE_CONNECTOR_CONFIGURATION procedure using SQL
  public static Variant finalizeConnector(Session session, Variant configuration) {
    //Using builder
    var handler = FinalizeConnectorHandler.builder(session)
      .withValidator(new CustomFinalizeConnectorValidator())
      .build();
    return handler.finalizeConnector(configuration).toVariant();
  }
}

-- Example 17884
public static String executeWork(Session session, int workerId, String taskReactorSchema) {
  FakeIngestion fakeIngestion = new FakeIngestion(session, workerId);
  WorkerId workerIdentifier = new WorkerId(workerId);
  Identifier schemaIdentifier = Identifier.fromWithAutoQuoting(taskReactorSchema);
  try {
    IngestionWorker.from(session, fakeIngestion, workerIdentifier, schemaIdentifier).run();
  } catch (WorkerException e) {
    // handle the exception...
    throw new RuntimeException(e);
  }
  return "Worker procedure executed.";
}

-- Example 17885
CREATE OR REPLACE PROCEDURE CONNECTOR.WORKER_PROCEDURE(worker_id number, task_reactor_schema string)
  RETURNS STRING
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0', 'com.snowflake:telemetry:0.0.1')
  IMPORTS = ('@jars/myconnector-1.0.0.jar')
  HANDLER = 'com.snowflake.myconnector.WorkerImpl.executeWork';

-- Example 17886
public static String selectWork(Session session, String[] queueItems) {
  Variant[] sorted =
    Arrays.stream(queueItems)
      .map(Variant::new)
      .filter(
        queueItem ->
          !queueItem.asMap().get("resourceId").asString().equals("filter-out-resource"))
      .sorted(comparing(queueItem -> queueItem.asMap().get("resourceId").asString()))
      .toArray(Variant[]::new);
  return new Variant(sorted).asJsonString();
}

-- Example 17887
CREATE VIEW CONNECTOR_SCHEMA.WORK_SELECTOR_VIEW AS SELECT * FROM TASK_REACTOR.QUEUE ORDER BY RESOURCE_ID;

-- Example 17888
CREATE OR REPLACE PROCEDURE CONNECTOR.WORK_SELECTOR(work_items array)
  RETURNS ARRAY
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('@jars/myconnector-1.0.0.jar')
  HANDLER = 'com.snowflake.myconnector.WorkSelector.selectWork';

-- Example 17889
CREATE VIEW CONNECTOR_SCHEMA.EXPIRED_WORK_SELECTOR_VIEW
  AS SELECT * FROM TASK_REACTOR.QUEUE q
  WHERE DATEDIFF(day, q.timestamp, sysdate()) > 3;

-- Example 17890
SET EVENT_TABLE = 'TOOLS.PUBLIC.EVENTS';
SET APP_NAME = 'YOUR_APP_NAME';

SELECT
    event.record:name::string AS EVENT_NAME,
    span.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    span.record_attributes:worker_id AS WORKER_ID,
    event.record_attributes AS PAYLOAD
  FROM IDENTIFIER($EVENT_TABLE) event
  JOIN IDENTIFIER($EVENT_TABLE) span ON event.trace:span_id = span.trace:span_id AND event.record_type = 'SPAN_EVENT' AND span.record_type = 'SPAN'
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
  ORDER BY event.timestamp DESC;

-- Example 17891
SELECT
  event.record:name::string AS EVENT_NAME,
    span.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    span.record_attributes:worker_id AS WORKER_ID,
    event.record_attributes:value AS DURATION
  FROM IDENTIFIER($EVENT_TABLE) event
  JOIN IDENTIFIER($EVENT_TABLE) span ON event.trace:span_id = span.trace:span_id AND event.record_type = 'SPAN_EVENT' AND span.record_type = 'SPAN'
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
      AND event.record:name = 'TASK_REACTOR_WORKER_WORKING_TIME'
  ORDER BY event.timestamp DESC;

-- Example 17892
SELECT
    event.record:name::string AS EVENT_NAME,
    span.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    span.record_attributes:worker_id AS WORKER_ID,
    event.record_attributes:value AS DURATION
  FROM IDENTIFIER($EVENT_TABLE) event
  JOIN IDENTIFIER($EVENT_TABLE) span ON event.trace:span_id = span.trace:span_id AND event.record_type = 'SPAN_EVENT' AND span.record_type = 'SPAN'
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
        AND event.record:name = 'TASK_REACTOR_WORKER_IDLE_TIME'
  ORDER BY event.timestamp DESC;

-- Example 17893
SELECT
    event.record:name::string AS EVENT_NAME,
    span.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    event.record_attributes:value AS DURATION,
    event.timestamp
  FROM IDENTIFIER($EVENT_TABLE) event
  JOIN IDENTIFIER($EVENT_TABLE) span ON event.trace:span_id = span.trace:span_id AND event.record_type = 'SPAN_EVENT' AND span.record_type = 'SPAN'
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
      AND event.record:name = 'TASK_REACTOR_WORK_ITEM_WAITING_IN_QUEUE_TIME'
  ORDER BY event.timestamp DESC;

-- Example 17894
SELECT
    event.record:name::string AS EVENT_NAME,
    event.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    event.record_attributes:value AS WORK_ITEMS_NUMBER,
    event.timestamp
  FROM IDENTIFIER($EVENT_TABLE) event
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
      AND event.record:name = 'TASK_REACTOR_WORK_ITEMS_NUMBER_IN_QUEUE'
  ORDER BY event.timestamp DESC;

-- Example 17895
SELECT
    event.record:name::string AS EVENT_NAME,
    span.record_attributes:task_reactor_instance::string AS INSTANCE_NAME,
    event.record_attributes:TOTAL AS WORKERS_TOTAL,
    IFNULL(event.record_attributes:AVAILABLE, 0) AS WORKERS_AVAILABLE,
    IFNULL(event.record_attributes:WORK_ASSIGNED, 0) AS WORKERS_WORK_ASSIGNED,
    IFNULL(event.record_attributes:IN_PROGRESS, 0) AS WORKERS_IN_PROGRESS,
    IFNULL(event.record_attributes:SCHEDULED_FOR_CANCELLATION, 0) AS WORKERS_SCHEDULED_FOR_CANCELLATION,
    event.timestamp
  FROM IDENTIFIER($EVENT_TABLE) event
  JOIN IDENTIFIER($EVENT_TABLE) span ON event.trace:span_id = span.trace:span_id AND event.record_type = 'SPAN_EVENT' AND span.record_type = 'SPAN'
  WHERE
    event.resource_attributes:"snow.database.name" = $APP_NAME
      AND event.record:name = 'TASK_REACTOR_WORKER_STATUS'
  ORDER BY event.timestamp DESC;

-- Example 17896
{
    "response_code": "OK",
    "message": "Instance has been initialized successfully."
}

-- Example 17897
{
    "response_code": "OK"
}

-- Example 17898
{
    "response_code": "OK"
}

-- Example 17899
{
    "response_code": "OK"
}

-- Example 17900
{
    "response_code": "OK"
}

-- Example 17901
class CustomOnIngestionScheduledCallback implements OnIngestionScheduledCallback {
    @Override
    public void onIngestionScheduled(String processId) {
        // CUSTOM LOGIC
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.RUN_SCHEDULER_ITERATION procedure using SQL
    public static Variant runIteration(Session session) {
        return RunSchedulerIterationHandler.builder(session)
            .withOnIngestionScheduledCallback(new CustomOnIngestionScheduledCallback())
            .build()
            .runIteration()
            .toVariant();
    }
}

-- Example 17902
CREATE OR REPLACE PROCEDURE PUBLIC.CONFIGURE_CONNECTOR(input VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/jar_with_custom_code.jar')
  HANDLER = 'com.custom.handler.CustomHandler.configure';

-- Example 17903
CREATE OR REPLACE PROCEDURE PUBLIC.CONFIGURE_CONNECTOR_INTERNAL(config VARIANT)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- input some custom logic here
    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

-- Example 17904
class CustomConnectionConfigurationInputValidator implements ConnectionConfigurationInputValidator {
  @Override
  public ConnectorResponse validate(Variant config) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.SET_CONNECTION_CONFIGURATION procedure using SQL
  public static Variant configureConnection(Session session, Variant configuration) {
    //Using builder
    var handler = ConnectionConfigurationHandler.builder(session)
      .withInputValidator(new CustomConnectionConfigurationInputValidator())
      .build();
    return handler.connectionConfiguration(configuration).toVariant();
  }
}

-- Example 17905
CREATE OR REPLACE PROCEDURE PUBLIC.SET_CONNECTION_CONFIGURATION(input VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/jar_with_custom_code.jar')
  HANDLER = 'com.custom.handler.CustomHandler.configureConnection';

-- Example 17906
CREATE OR REPLACE PROCEDURE PUBLIC.CREATE_RESOURCE(name VARCHAR,resource_id VARIANT,ingestion_configurations VARIANT,id VARCHAR,enabled BOOLEAN,resource_metadata VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomCreateResourceHandler.createResource';

  GRANT USAGE ON PROCEDURE PUBLIC.CREATE_RESOURCE(VARCHAR, VARIANT, VARIANT, VARCHAR, BOOLEAN, VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 17907
CREATE OR REPLACE PROCEDURE PUBLIC.CREATE_RESOURCE_VALIDATE(resource VARIANT)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
      -- SOME CUSTOM LOGIC BEGIN
      SELECT sysdate();
      -- SOME CUSTOM LOGIC END

      RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

  CREATE OR REPLACE PROCEDURE PUBLIC.CREATE_RESOURCE_VALIDATE(resource VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomHandler.createResourceValidate';

-- Example 17908
class CustomPreCreateResourceCallback implements PreCreateResourceCallback {
  @Override
  public ConnectorResponse execute(String resourceIngestionDefinitionId) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.CREATE_RESOURCE procedure using SQL
  public static Variant createResource(
      Session session,
      String name,
      Variant resourceId,
      Variant ingestionConfigurations,
      String id,
      boolean enabled,
      Variant resourceMetadata) {
    //Using builder
    var handler = CreateResourceHandlerBuilder.builder(session)
      .withPreCreateResourceCallback(new CustomPreCreateResourceCallback())
      .build();
    return handler.createResource(resourceIngestionDefinitionId).toVariant();
  }
}

-- Example 17909
CREATE OR REPLACE PROCEDURE PUBLIC.ENABLE_RESOURCE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomEnableResourceHandler.enableResource';

  GRANT USAGE ON PROCEDURE PUBLIC.ENABLE_RESOURCE(VARCHAR) TO APPLICATION ROLE ADMIN;

-- Example 17910
CREATE OR REPLACE PROCEDURE PUBLIC.ENABLE_RESOURCE_VALIDATE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- SOME CUSTOM LOGIC BEGIN
    SELECT sysdate();
    -- SOME CUSTOM LOGIC END

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

CREATE OR REPLACE PROCEDURE PUBLIC.ENABLE_RESOURCE_VALIDATE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomHandler.enableResourceValidate';

-- Example 17911
class CustomPreEnableResourceCallback implements PreEnableResourceCallback {
  @Override
  public ConnectorResponse execute(String resourceIngestionDefinitionId) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.ENABLE_RESOURCE procedure using SQL
  public static Variant enableResource(Session session, String resourceIngestionDefinitionId) {
    //Using builder
    var handler = EnableResourceHandlerBuilder.builder(session)
      .withPreEnableResourceCallback(new CustomPreEnableResourceCallback())
      .build();
    return handler.enableResource(resourceIngestionDefinitionId).toVariant();
  }
}

-- Example 17912
CREATE OR REPLACE PROCEDURE PUBLIC.DISABLE_RESOURCE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomDisableResourceHandler.disableResource';

GRANT USAGE ON PROCEDURE PUBLIC.DISABLE_RESOURCE(VARCHAR) TO APPLICATION ROLE ADMIN;

-- Example 17913
CREATE OR REPLACE PROCEDURE PUBLIC.PRE_DISABLE_RESOURCE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
      -- SOME CUSTOM LOGIC BEGIN
      SELECT sysdate();
      -- SOME CUSTOM LOGIC END

      RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

CREATE OR REPLACE PROCEDURE PUBLIC.PRE_DISABLE_RESOURCE(resource_ingestion_definition_id VARCHAR)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomHandler.disableResourceValidate';

-- Example 17914
class CustomPreDisableResourceCallback implements PreDisableResourceCallback {
  @Override
  public ConnectorResponse execute(String resourceIngestionDefinitionId) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.DISABLE_RESOURCE procedure using SQL
  public static Variant disableResource(Session session, String resourceIngestionDefinitionId) {
    //Using builder
    var handler = DisableResourceHandlerBuilder.builder(session)
      .withPreDisableResourceCallback(new CustomPreDisableResourceCallback())
      .build();
    return handler.disableResource(resourceIngestionDefinitionId).toVariant();
  }
}

-- Example 17915
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_RESOURCE(resource_ingestion_definition_id VARCHAR, ingestion_configurations VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomUpdateResourceHandler.updateResource';

GRANT USAGE ON PROCEDURE PUBLIC.UPDATE_RESOURCE(VARCHAR, VARIANT) TO APPLICATION ROLE ADMIN;

-- Example 17916
CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_RESOURCE_VALIDATE(resource_ingestion_definition_id VARCHAR, ingestion_configurations VARIANT)
  RETURNS VARIANT
  LANGUAGE SQL
  EXECUTE AS OWNER
  AS
  BEGIN
    -- SOME CUSTOM LOGIC BEGIN
    SELECT sysdate();
    -- SOME CUSTOM LOGIC END

    RETURN OBJECT_CONSTRUCT('response_code', 'OK');
  END;

CREATE OR REPLACE PROCEDURE PUBLIC.UPDATE_RESOURCE_VALIDATE(resource_ingestion_definition_id VARCHAR, ingestion_configurations VARIANT)
  RETURNS VARIANT
  LANGUAGE JAVA
  RUNTIME_VERSION = '11'
  PACKAGES = ('com.snowflake:snowpark:1.11.0')
  IMPORTS = ('/connectors-native-sdk.jar')
  HANDLER = 'com.custom.handler.CustomHandler.updateResourceValidate';

-- Example 17917
class CustomPreUpdateResourceCallback implements PreUpdateResourceCallback {
  @Override
  public ConnectorResponse execute(String resourceIngestionDefinitionId, Variant updatedIngestionConfigurations) {
    // CUSTOM LOGIC
    return ConnectorResponse.success();
  }
}

class CustomHandler {

  // Path to this method needs to be specified in the PUBLIC.UPDATE_RESOURCE procedure using SQL
  public static Variant updateResource(Session session, String resourceIngestionDefinitionId, Variant updatedIngestionConfigurations) {
    //Using builder
    var handler = UpdateResourceHandlerBuilder.builder(session)
      .withPreUpdateResourceCallback(new CustomPreUpdateResourceCallback())
      .build();
    return handler.updateResource(resourceIngestionDefinitionId).toVariant();
  }
}

-- Example 17918
tables:
  - name: order_lineitems
    description: >
      The order line items table contains detailed information about each item within an
      order, including quantities, pricing, and dates.

    base_table:
      database: SNOWFLAKE_SAMPLE_DATA
      schema: TPCH_SF1
      table: LINEITEM
    primary_key:
      columns:
        - order_key
        - order_lineitem_number

-- Example 17919
time_dimensions:
  - name: shipment_duration
    synonyms:
      - "shipping time"
      - "shipment time"
    description: The time it takes for items to be shipped.

    expr: DATEDIFF(day, lineitem.L_SHIPDATE, lineitem.L_RECEIPTDATE)
    data_type: NUMBER
    unique: false

-- Example 17920
# Fact columns in the logical table.
facts:
  - name: net_revenue
    synonyms:
      - "revenue after discount"
      - "net sales"
    description: Net revenue after applying discounts.

    expr: lineitem.L_EXTENDEDPRICE * (1 - lineitem.L_DISCOUNT)
    data_type: NUMBER

-- Example 17921
- name: north_america
  synonyms:
    - "NA"
    - "North America region"
  description: >
    Filter to restrict data to orders from North America.
  comments: Used for analysis focusing on North American customers.
  expr: nation.N_NAME IN ('Canada', 'Mexico', 'United States')

-- Example 17922
metrics:

# Simple metric referencing objects from the same logical table
- name: total_revenue
  expr: SUM(lineitem.l_extendedprice * (1 - lineitem.l_discount))

# Complex metric referencing objects from multiple logical tables.
# The relationships between tables have been defined below.
- name: total_profit_margin
  description: >
              The profit margin from orders. This metric is not additive
              and should always be calculated directly from the base tables.
  expr: (SUM(order_lineitems.net_revenue) -
        SUM(part_suppliers.part_supplier_cost * order_lineitems.lineitem_quantity))
        / SUM(order_lineitems.net_revenue)

-- Example 17923
relationships:

  # Relationship between orders and lineitems
  - name: order_lineitems_to_orders
    left_table: order_lineitems
    right_table: orders
    relationship_columns:
      - left_column: order_key
        right_column: order_key
    join_type: left_outer
    relationship_type: many_to_one

  # Relationship between lineitems and partsuppliers
  - name: order_lineitems_to_part_suppliers
    left_table: order_lineitems
    right_table: part_suppliers
    # The relationship requires equality of multiple columns from each table
    relationship_columns:
      - left_column: part_key
        right_column: part_key
      - left_column: supplier_key
        right_column: supplier_key
    join_type: left_outer
    relationship_type: many_to_one

-- Example 17924
# Name and description of the semantic model.
name: <name>
description: <string>
comments: <string>

# Logical table-level concepts

# A semantic model can contain one or more logical tables.
tables:

  # A logical table on top of a base table.
  - name: <name>
    description: <string>


    # The fully qualified name of the base table.
    base_table:
      database: <database>
      schema: <schema>
      table: <base table name>

    # Dimension columns in the logical table.
    dimensions:
      - name: <name>
        synonyms: <array of strings>
        description: <string>

        expr: <SQL expression>
        data_type: <data type>
        unique: <boolean>
        cortex_search_service:
          service: <string>
          literal_column: <string>
          database: <string>
          schema: <string>
        is_enum: <boolean>


    # Time dimension columns in the logical table.
    time_dimensions:
      - name: <name>
        synonyms:  <array of strings>
        description: <string>

        expr: <SQL expression>
        data_type: <data type>
        unique: <boolean>

    # Fact columns in the logical table.
    facts:
      - name: <name>
        synonyms: <array of strings>
        description: <string>

        expr: <SQL expression>
        data_type: <data type>


    # Business metrics across logical objects
    metrics:
      - name: <name>
        synonyms: <array of strings>
        description: <string>

        expr: <SQL expression>


    # Commonly used filters over the logical table.
    filters:
      - name: <name>
        synonyms: <array of strings>
        description: <string>

        expr: <SQL expression>



# Model-level concepts

# Relationships between logical tables
relationships:
  - name: <string>

    left_table: <table>
    right_table: <table>
    relationship_columns:
      - left_column: <column>
        right_column: <column>
      - left_column: <column>
        right_column: <column>
    join_type: <left_outer | inner>
    relationship_type: < one_to_one | many_to_one>


# Additional context concepts

#  Verified queries with example questions and queries that answer them
verified_queries:
# Verified Query (1 of n)
  - name:        # A descriptive name of the query.

    question:    # The natural language question that this query answers.
    verified_at: # Optional: Time (in seconds since the UNIX epoch, January 1, 1970) when the query was verified.
    verified_by: # Optional: Name of the person who verified the query.
    use_as_onboarding_question:  # Optional: Marks this question as an onboarding question for the end user.
    expr:                         # The SQL query for answering the question

-- Example 17925
verified_queries:

# Verified Query 1
- name:                         # A descriptive name of the query.
  question:                     # The natural language question that this query answers.
  verified_at:                  # Optional: Time (in seconds since the UNIX epoch, January 1, 1970) when the query was verified.
  verified_by:                  # Optional: Name of the person who verified the query.
  use_as_onboarding_question:   # Optional: Marks this question as an onboarding question for the end user.
  sql:                          # The SQL query for answering the question.

# Verified Query 2
- name:
  question:
  verified_at:
  verified_by:
  use_as_onboarding_question:
  sql:

-- Example 17926
name: Sales Data
tables:
- name: sales_data
  base_table:
    database: sales
    schema: public
    table: sd_data

  dimensions:
    - name: state
      description: The state where the sale took place.
      expr: d_state
      data_type: TEXT
        unique: false
        sample_values:
          - "CA"
          - "IL"

    # Time dimension columns in the logical table.
    time_dimensions:
      - name: sale_timestamp
        synonyms:
          - "time_of_sale"
          - "transaction_time"
        description: The time when the sale occurred. In UTC.
        expr: dt
        data_type: TIMESTAMP
        unique: false

    # Measure columns in the logical table.
    measures:
      - name: profit
        synonyms:
          - "earnings"
          - "net income"
        description: The profit generated from a sale.
        expr: amt - cst
        data_type: NUMBER
        default_aggregation: sum

verified_queries:
  - name: "California profit"
    question: "What was the profit from California last month?"
    verified_at: 1714497970
    verified_by: Jane Doe
    use_as_onboarding_question: true
    sql: "
SELECT sum(profit)
FROM __sales_data
WHERE state = 'CA'
    AND sale_timestamp >= DATE_TRUNC('month', DATEADD('month', -1, CURRENT_DATE))
    AND sale_timestamp < DATE_TRUNC('month', CURRENT_DATE)
"

-- Example 17927
{
  "type": "text",
  "text":  "Which company had the most revenue?"
}

-- Example 17928
{
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "which company had the most revenue?"
                }
            ]
        }
    ],
    "semantic_model_file": "@my_db.my_schema.my_stage/my_semantic_model.yaml"
}

-- Example 17929
{
    "request_id": "75d343ee-699c-483f-83a1-e314609fb563",
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "We interpreted your question as ..."
            },
            {
                "type": "sql",
                "statement": "SELECT * FROM table",
                "confidence": {
                    "verified_query_used": {
                        "name": "My verified query",
                        "question": "What was the total revenue?",
                        "sql": "SELECT * FROM table2",
                        "verified_at": 1714497970,
                        "verified_by": "Jane Doe"
                    }
                }
            }
        ]
    },
    "warnings": [
        {
            "message": "Table table1 has (30) columns, which exceeds the recommended maximum of 10"
        },
        {
            "message": "Table table2 has (40) columns, which exceeds the recommended maximum of 10"
        }
    ]
}

-- Example 17930
{
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "This is how we interpreted your question and this is how the sql is generated"
            },
            {
                "type": "sql",
                "statement": "SELECT * FROM table"
            }
        ]
    }
}

-- Example 17931
event: status
data: { status: "interpreting_question" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: "This is how we interpreted your question"
}

event: status
data: { status: "generating_sql" }

event: status
data: { status: "validating_sql" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: " and this is how the sql is generated"
}

event: message.content.delta
data: {
  index: 1,
  type: "sql",
  statement_delta: "SELECT * FROM table"
}

event: status
data: { status: "done" }

-- Example 17932
{
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "Your question is ambigous, here are some alternatives:"
            },
            {
                "type": "suggestions",
                "suggestions": [
                    "which company had the most revenue?",
                    "which company placed the most orders?"
                ]
            }
        ]
    }
}

-- Example 17933
event: status
data: { status: "interpreting_question" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: "Your question is ambigous,"
}

event: status
data: { status: "generating_suggestions" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: " here are some alternatives:"
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 0,
    suggestion_delta: "which company had",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 0,
    suggestion_delta: " the most revenue?",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 1,
    suggestion_delta: "which company placed",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 1,
    suggestion_delta: " the most orders?",
  }
}

event: status
data: { status: "done" }

