-- Example 24497
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;
CALL samooha_by_snowflake_local_db.consumer.
  uninstall_cleanroom($cleanroom_name).

-- Example 24498
custom_instructions: "Ensure that all numeric columns are rounded to 2 decimal points in the output."

-- Example 24499
SELECT
  ROUND(column_name, 2) AS column_name,
  ...
FROM
  your_table;

-- Example 24500
custom_instructions: "For any percentage or rate calculation, multiply the result by 100."

-- Example 24501
SELECT
  (column_a / column_b) * 100 AS percentage_rate,
  ...
FROM
  your_table;

-- Example 24502
custom_instructions: "If no date filter is provided, apply a filter for the last year."

-- Example 24503
SELECT
  ...
FROM
  your_table
WHERE
  date_column >= DATEADD(YEAR, -1, CURRENT_DATE);

-- Example 24504
custom_instructions: "If a filter is applied on column X, ensure that the same filter is applied to dimension Y."

-- Example 24505
SELECT
  ...
FROM
  your_table
WHERE
  column_x = 'filter_value' AND
  dimension_y = 'filter_value';

-- Example 24506
SELECT * FROM table(SNOWFLAKE.LOCAL.CORTEX_ANALYST_REQUESTS('FILE_ON_STAGE', '@my_db.my_schema.my_stage/path/to/file.yaml'));

-- Example 24507
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

-- Example 24508
time_dimensions:
  - name: shipment_duration
    synonyms:
      - "shipping time"
      - "shipment time"
    description: The time it takes for items to be shipped.

    expr: DATEDIFF(day, lineitem.L_SHIPDATE, lineitem.L_RECEIPTDATE)
    data_type: NUMBER
    unique: false

-- Example 24509
# Fact columns in the logical table.
facts:
  - name: net_revenue
    synonyms:
      - "revenue after discount"
      - "net sales"
    description: Net revenue after applying discounts.

    expr: lineitem.L_EXTENDEDPRICE * (1 - lineitem.L_DISCOUNT)
    data_type: NUMBER

-- Example 24510
- name: north_america
  synonyms:
    - "NA"
    - "North America region"
  description: >
    Filter to restrict data to orders from North America.
  comments: Used for analysis focusing on North American customers.
  expr: nation.N_NAME IN ('Canada', 'Mexico', 'United States')

-- Example 24511
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

-- Example 24512
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

-- Example 24513
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

-- Example 24514
snow stage copy
  <source_path>
  <destination_path>
  --overwrite / --no-overwrite
  --parallel <parallel>
  --recursive / --no-recursive
  --auto-compress / --no-auto-compress
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

-- Example 24515
snow stage copy local_example_app @example_app_stage/app

-- Example 24516
put file:///.../local_example_app/* @example_app_stage/app4 auto_compress=false parallel=4 overwrite=False
+--------------------------------------------------------------------------------------
| source           | target           | source_size | target_size | source_compression...
|------------------+------------------+-------------+-------------+--------------------
| environment.yml  | environment.yml  | 62          | 0           | NONE             ...
| snowflake.yml    | snowflake.yml    | 252         | 0           | NONE             ...
| streamlit_app.py | streamlit_app.py | 109         | 0           | NONE             ...
+--------------------------------------------------------------------------------------

-- Example 24517
mkdir local_app_backup
snow stage copy @example_app_stage/app local_app_backup

-- Example 24518
get @example_app_stage/app file:///.../local_app_backup/ parallel=4
+------------------------------------------------+
| file             | size | status     | message |
|------------------+------+------------+---------|
| environment.yml  | 62   | DOWNLOADED |         |
| snowflake.yml    | 252  | DOWNLOADED |         |
| streamlit_app.py | 109  | DOWNLOADED |         |
+------------------------------------------------+

-- Example 24519
snow stage copy "testdir/*.txt" @TEST_STAGE_3

-- Example 24520
put file:///.../testdir/*.txt @TEST_STAGE_3 auto_compress=false parallel=4 overwrite=False
+------------------------------------------------------------------------------------------------------------+
| source | target | source_size | target_size | source_compression | target_compression | status   | message |
|--------+--------+-------------+-------------+--------------------+--------------------+----------+---------|
| b1.txt | b1.txt | 3           | 16          | NONE               | NONE               | UPLOADED |         |
| b2.txt | b2.txt | 3           | 16          | NONE               | NONE               | UPLOADED |         |
+------------------------------------------------------------------------------------------------------------+

-- Example 24521
SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  '<name>',
  '<base_model>',
  '<training_data_query>'
  [
    , '<validation_data_query>'
    [, '<options>' ]
  ]
)

-- Example 24522
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM train',
  'SELECT prompt, completion FROM validation'
);

-- Example 24523
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM train'
);

-- Example 24524
ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299

-- Example 24525
SNOWFLAKE.CORTEX.FINETUNE('SHOW')

-- Example 24526
SELECT SNOWFLAKE.CORTEX.FINETUNE('SHOW');

-- Example 24527
[{"id":"ft_9544250a-20a9-42b3-babe-74f0a6f88f60","status":"SUCCESS","base_model":"llama3.1-8b","created_on":1730835118114},
{"id":"ft_354cf617-2fd1-4ffa-a3f9-190633f42a25","status":"ERROR","base_model":"llama3.1-8b","created_on":1730834536632}]

-- Example 24528
SNOWFLAKE.CORTEX.FINETUNE(
  'DESCRIBE',
  '<finetune_job_id>'
)

-- Example 24529
trained tokens = number of input tokens  * number of epochs trained

-- Example 24530
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'DESCRIBE',
  'ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299'
);

-- Example 24531
{
  "base_model":"mistral-7b",
  "created_on":1717004388348,
  "finished_on":1717004691577,
  "id":"ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299",
  "model":"mydb.myschema.my_tuned_model",
  "progress":1.0,
  "status":"SUCCESS",
  "training_data":"SELECT prompt, completion FROM train",
  "trained_tokens":2670734,
  "training_result":{"validation_loss":1.0138969421386719,"training_loss":0.6477728401547047},
  "validation_data":"SELECT prompt, completion FROM validation",
  "options":{"max_epochs":3}
}

-- Example 24532
SNOWFLAKE.CORTEX.FINETUNE(
  'CANCEL',
  '<finetune_job_id>'
)

-- Example 24533
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CANCEL',
  'ft_194bbea4-1208-42f3-88c6-cfb202086125'
);

-- Example 24534
Canceled Cortex Fine-tuning job: ft_194bbea4-1208-42f3-88c6-cfb202086125

-- Example 24535
SELECT * FROM SNOWFLAKE.ORGANIZATION_USAGE.METERING_DAILY_HISTORY
  WHERE service_type ILIKE '%ai_services%';

-- Example 24536
CREATE STAGE doc_ai_stage
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 24537
USE ROLE ACCOUNTADMIN;

CREATE ROLE doc_ai_role;
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE doc_ai_role;

-- Example 24538
CREATE DATABASE doc_ai_db;
CREATE SCHEMA doc_ai_db.doc_ai_schema;
CREATE WAREHOUSE doc_ai_wh;

-- Example 24539
GRANT USAGE, OPERATE ON WAREHOUSE doc_ai_wh TO ROLE doc_ai_role;

-- Example 24540
GRANT USAGE ON DATABASE doc_ai_db TO ROLE doc_ai_role;
GRANT USAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24541
GRANT CREATE STAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24542
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 24543
GRANT CREATE STREAM, CREATE TABLE, CREATE TASK, CREATE VIEW ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE doc_ai_role;

-- Example 24544
GRANT ROLE doc_ai_role TO USER doc_ai_user;

-- Example 24545
{   "__processingErrors": [     "File extension does not match actual mime type. Mime-Type: application/octet-stream"   ] }

-- Example 24546
{   "__processingErrors": [     "cannot identify image file <_io.BytesIO object at 0x7f8a800ba020>"   ] }

-- Example 24547
CREATE STAGE doc_ai_stage
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 24548
{ "__processingErrors": [ "Received HTTP 403 response for presigned URL. URL may be expired." ] }

-- Example 24549
{ "__processingErrors": [ "Query limit reached: too many documents in a single query." ] }

-- Example 24550
{ "__processingErrors": [ "Page 0 size is larger than the limit. Actual: 1083 mm x 1384 mm. Maximum: 1200 mm x 1200 mm." ] }

-- Example 24551
{ "__processingErrors": [ "Document has too many pages. Actual: 150. Maximum: 125." ] }

-- Example 24552
{ "__processingErrors": [ "Image size is too small. Actual: 20x20 px. Minimum: 50x50 px." ] }

-- Example 24553
{ "__processingErrors": [ "Unsupported file format. Actual: csv. Supported: docx, eml, htm, html, jpeg, jpg, pdf, png, text, tif, tiff, txt." ] }

-- Example 24554
{ "__processingErrors": [ "File exceeds maximum size. Actual: 54096026 bytes. Maximum: 50000000 bytes." ] }

-- Example 24555
Request failed for external function DOCUMENT_EXTRACT_FEATURES$V1 with remote service error: 422

-- Example 24556
Unable to create a build on the specified database and schema. Please check the documentation to learn more.

-- Example 24557
USE DATABASE doc_ai_db;
USE SCHEMA doc_ai_schema;

-- Example 24558
CREATE SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'frequency': '1 day'}
);

-- Example 24559
CREATE SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {
    'frequency': '1 day',
    'aggregation_categorical': 'MODE',
    'aggregation_numeric': 'MEDIAN'}
);

-- Example 24560
CREATE SNOWFLAKE.ML.FORECAST model1(
  INPUT_DATA => TABLE(v1),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {
    'frequency': '1 day',
    'aggregation_target': 'MEDIAN',
    'aggregation_column': {
        'temperature': 'MEDIAN',
        'employee_id': 'FIRST'
    }
  }
);

-- Example 24561
keytool -list -keystore <path_to_keystore_file>

-- Example 24562
curl -I 'http://ocsp.digicert.com'
HTTP/1.1 200 OK
...

-- Example 24563
[options]
sql_split=snowflake.connector.util_text

