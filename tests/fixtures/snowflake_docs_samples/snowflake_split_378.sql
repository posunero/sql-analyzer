-- Example 25301
CREATE STAGE s1
  URL='azure://mycontainer/files/logs/'
  ...
  ;

-- Example 25302
SELECT metadata$filename FROM @s1/;

+----------------------------------------+
| METADATA$FILENAME                      |
|----------------------------------------|
| files/logs/2018/08/05/0524/log.parquet |
| files/logs/2018/08/27/1408/log.parquet |
+----------------------------------------+

-- Example 25303
CREATE EXTERNAL TABLE et1(
 date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
   || '/' || SPLIT_PART(metadata$filename, '/', 4)
   || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
 timestamp bigint AS (value:timestamp::bigint),
 col2 varchar AS (value:col2::varchar))
 PARTITION BY (date_part)
 LOCATION=@s1/logs/
 AUTO_REFRESH = true
 FILE_FORMAT = (TYPE = PARQUET)
 AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket';

-- Example 25304
CREATE EXTERNAL TABLE et1(
  date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
    || '/' || SPLIT_PART(metadata$filename, '/', 4)
    || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
  timestamp bigint AS (value:timestamp::bigint),
  col2 varchar AS (value:col2::varchar))
  PARTITION BY (date_part)
  LOCATION=@s1/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET);

-- Example 25305
CREATE EXTERNAL TABLE et1(
  date_part date AS TO_DATE(SPLIT_PART(metadata$filename, '/', 3)
    || '/' || SPLIT_PART(metadata$filename, '/', 4)
    || '/' || SPLIT_PART(metadata$filename, '/', 5), 'YYYY/MM/DD'),
  timestamp bigint AS (value:timestamp::bigint),
  col2 varchar AS (value:col2::varchar))
  PARTITION BY (date_part)
  INTEGRATION = 'MY_INT'
  LOCATION=@s1/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET);

-- Example 25306
ALTER EXTERNAL TABLE et1 REFRESH;

-- Example 25307
SELECT timestamp, col2 FROM et1 WHERE date_part = to_date('08/05/2018');

-- Example 25308
CREATE STAGE s2
  URL='s3://mybucket/files/logs/'
  ...
  ;

-- Example 25309
CREATE STAGE s2
  URL='gcs://mybucket/files/logs/'
  ...
  ;

-- Example 25310
CREATE STAGE s2
  URL='azure://mycontainer/files/logs/'
  ...
  ;

-- Example 25311
create external table et2(
  col1 date as (parse_json(metadata$external_table_partition):COL1::date),
  col2 varchar as (parse_json(metadata$external_table_partition):COL2::varchar),
  col3 number as (parse_json(metadata$external_table_partition):COL3::number))
  partition by (col1,col2,col3)
  location=@s2/logs/
  partition_type = user_specified
  file_format = (type = parquet);

-- Example 25312
ALTER EXTERNAL TABLE et2 ADD PARTITION(col1='2022-01-24', col2='a', col3='12') LOCATION '2022/01';

-- Example 25313
+---------------------------------------+----------------+-------------------------------+
|                       file            |     status     |          description          |
+---------------------------------------+----------------+-------------------------------+
| mycontainer/files/logs/2022/01/24.csv | REGISTERED_NEW | File registered successfully. |
| mycontainer/files/logs/2022/01/25.csv | REGISTERED_NEW | File registered successfully. |
+---------------------------------------+----------------+-------------------------------+

-- Example 25314
SELECT col1, col2, col3 FROM et1 WHERE col1 = TO_DATE('2022-01-24') AND col2 = 'a' ORDER BY METADATA$FILE_ROW_NUMBER;

-- Example 25315
CREATE MATERIALIZED VIEW et1_mv
  AS
  SELECT col2 FROM et1;

-- Example 25316
CREATE EXTERNAL TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@mystage',
        FILE_FORMAT=>'my_parquet_format'
      )
    )
  )
  LOCATION=@mystage
  FILE_FORMAT=my_parquet_format
  AUTO_REFRESH=false;

-- Example 25317
CREATE EXTERNAL TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT('COLUMN_NAME',COLUMN_NAME, 'TYPE',TYPE, 'NULLABLE', NULLABLE, 'EXPRESSION',EXPRESSION))
    FROM TABLE(
      INFER_SCHEMA(
        LOCATION=>'@mystage',
        FILE_FORMAT=>'my_parquet_format'
      )
    )
  )
  LOCATION=@mystage
  FILE_FORMAT=my_parquet_format
  AUTO_REFRESH=false;

-- Example 25318
GRANT SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER ROLE <name>!PRIVACY_USER
  TO ROLE <role_name>

REVOKE SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER ROLE <name>!PRIVACY_USER
  FROM ROLE <role_name>

GRANT SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER ROLE <name>!PRIVACY_USER
  TO DATABASE ROLE <database_role_name>

REVOKE SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER ROLE <name>!PRIVACY_USER
  FROM DATABASE ROLE <database_role_name>

-- Example 25319
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.CLASSIFICATION_ADMIN
  TO ROLE my_classification_role;
GRANT USAGE ON DATABASE mydb TO ROLE my_classification_role;
GRANT USAGE ON SCHEMA mydb.instances TO ROLE my_classification_role;
GRANT USAGE ON WAREHOUSE wh_classification TO ROLE my_classification_role;

-- Example 25320
GRANT SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER ROLE
  mydb.sch.my_instance!PRIVACY_USER TO ROLE data_analyst;

-- Example 25321
+-------------+----------------------------------------------------------+
| ICD_10_CODE | DESCRIPTION                                              |
+-------------+----------------------------------------------------------+
| G30.9       | Alzheimer's disease, unspecified                         |
| G80.8       | Other cerebral palsy                                     |
| S13.4XXA    | Sprain of ligaments of cervical spine, initial encounter |
+-------------+----------------------------------------------------------+

-- Example 25322
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.CLASSIFICATION_ADMIN
  TO ROLE data_owner;

-- Example 25323
USE ROLE data_owner;
CREATE SCHEMA data.classifiers;

-- Example 25324
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER medical_codes();

-- Example 25325
SHOW SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER;

-- Example 25326
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+
| created_on                       | name          | database_name | schema_name | current_version | comment | owner       |
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+
| 2023-09-08 07:00:00.123000+00:00 | MEDICAL_CODES | DATA          | CLASSIFIERS | 1.0             | None    | DATA_OWNER  |
+----------------------------------+---------------+---------------+-------------+-----------------+---------+-------------+

-- Example 25327
CALL medical_codes!ADD_REGEX(
  'ICD_10_CODES',
  'IDENTIFIER',
  '[A-TV-Z][0-9][0-9AB]\.?[0-9A-TV-Z]{0,4}',
  'ICD.*',
  'Add a regex to identify ICD-10 medical codes in a column',
  0.8
);

-- Example 25328
+---------------+
|   ADD_REGEX   |
+---------------+
| ICD_10_CODES  |
+---------------+

-- Example 25329
SELECT icd_10_code
FROM medical_codes
WHERE icd_10_code REGEXP('[A-TV-Z][0-9][0-9AB]\.?[0-9A-TV-Z]{0,4}');

-- Example 25330
+-------------+
| ICD-10-CODE |
+-------------+
| G30.9       |
| G80.8       |
| S13.4XXA    |
+-------------+

-- Example 25331
SELECT medical_codes!LIST();

-- Example 25332
+--------------------------------------------------------------------------------+
| MEDICAL_CODES!LIST()                                                           |
+--------------------------------------------------------------------------------+
| {                                                                              |
|   "ICD-10-CODES": {                                                            |
|     "col_name_regex": "ICD.*",                                                 |
|     "description": "Add a regex to identify ICD-10 medical codes in a column", |
|     "privacy_category": "IDENTIFIER",                                          |
|     "threshold": 0.8,                                                          |
|     "value_regex": "[A-TV-Z][0-9][0-9AB]\.?[0-9A-TV-Z]{0,4}"                   |
|   }                                                                            |
| }                                                                              |
+--------------------------------------------------------------------------------+

-- Example 25333
DROP SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER data.classifiers.medical_codes;

-- Example 25334
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE 'create % snowflake.data_privacy.custom_classifier%';

-- Example 25335
SELECT
    QUERY_HISTORY.user_name,
    QUERY_HISTORY.role_name,
    QUERY_HISTORY.query_text,
    QUERY_HISTORY.query_id
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY query_history,
    SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY access_history,
      TABLE(FLATTEN(input => access_history.direct_objects_accessed)) flattened_value
WHERE flattened_value.value:"objectName" = 'DB.SCH.MY_INSTANCE!ADD_REGEX'
AND QUERY_HISTORY.query_id = ACCESS_HISTORY.query_id;

-- Example 25336
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE query_text ILIKE 'drop % snowflake.data_privacy.custom_classifier%';

-- Example 25337
SELECT
   SUM(credits_used) AS total_credits
FROM snowflake.account_usage.metering_history
WHERE
   service_type = 'TRUST_CENTER' AND
   start_time >= '2024-12-01' AND
   end_time <= '2024-12-31';

-- Example 25338
SELECT
   usage_date AS date,
   credits_used AS credits
FROM snowflake.account_usage.metering_daily_history
WHERE
   service_type = 'TRUST_CENTER' AND
   date > '2024-12-01';

-- Example 25339
SELECT SUM(CREDITS_USED)
  FROM snowflake.account_usage.serverless_task_history
  WHERE
    DATABASE_NAME = 'SNOWFLAKE' AND
    SCHEMA_NAME = 'TRUST_CENTER_STATE' AND
    START_TIME BETWEEN '2024-05-20 07:00:00.000 -0700' AND '2024-05-22 07:00:00.000 -0700';

-- Example 25340
SELECT
   SUM(credits_used) AS total_credits
FROM snowflake.account_usage.metering_history
WHERE
   service_type = 'TRUST_CENTER' AND
   start_time >= '2024-12-01' AND
   end_time <= '2024-12-31';

-- Example 25341
SELECT
   usage_date AS date,
   credits_used AS credits
FROM snowflake.account_usage.metering_daily_history
WHERE
   service_type = 'TRUST_CENTER' AND
   date > '2024-12-01';

-- Example 25342
SELECT SUM(CREDITS_USED)
  FROM snowflake.account_usage.serverless_task_history
  WHERE
    DATABASE_NAME = 'SNOWFLAKE' AND
    SCHEMA_NAME = 'TRUST_CENTER_STATE' AND
    START_TIME BETWEEN '2024-05-20 07:00:00.000 -0700' AND '2024-05-22 07:00:00.000 -0700';

-- Example 25343
CREATE ACCOUNT <name>
      ADMIN_NAME = '<string_literal>'
    { ADMIN_PASSWORD = '<string_literal>' | ADMIN_RSA_PUBLIC_KEY = '<string_literal>' }
    [ ADMIN_USER_TYPE = { PERSON | SERVICE | LEGACY_SERVICE | NULL } ]
    [ FIRST_NAME = '<string_literal>' ]
    [ LAST_NAME = '<string_literal>' ]
      EMAIL = '<string_literal>'
    [ MUST_CHANGE_PASSWORD = { TRUE | FALSE } ]
      EDITION = { STANDARD | ENTERPRISE | BUSINESS_CRITICAL }
    [ REGION_GROUP = <region_group_id> ]
    [ REGION = <snowflake_region_id> ]
    [ COMMENT = '<string_literal>' ]
    [ POLARIS = { TRUE | FALSE } ]

-- Example 25344
create account myaccount1
  admin_name = admin
  admin_password = 'TestPassword1'
  first_name = Jane
  last_name = Smith
  email = 'myemail@myorg.org'
  edition = enterprise
  region = aws_us_west_2;

-- Example 25345
create account myaccount2
  admin_name = admin
  admin_password = 'TestPassword1'
  email = 'myemail@myorg.org'
  edition = enterprise;

-- Example 25346
create account myaccount1
  admin_name = admin
  admin_password = 'TestPassword1'
  first_name = Jane
  last_name = Smith
  email = 'myemail@myorg.org'
  edition = enterprise
  region = aws_us_west_2
  polaris = true;

-- Example 25347
import os

CONNECTION_PARAMETERS = {
    "account": os.environ["snowflake_account_demo"],
    "user": os.environ["snowflake_user_demo"],
    "password": os.environ["snowflake_password_demo"],
    "role": "test_role",
    "database": "test_database",
    "warehouse": "test_warehouse",
    "schema": "test_schema",
}

-- Example 25348
[myconnection]
account = "test-account"
user = "test_user"
password = "******"
role = "test_role"
warehouse = "test_warehouse"
database = "test_database"
schema = "test_schema"

-- Example 25349
pip install 'snowflake-snowpark-python>=1.5.0,<2.0.0'

-- Example 25350
from snowflake.core import Root
from snowflake.snowpark import Session

session = Session.builder.config("connection_name", "myconnection").create()
root = Root(session)

-- Example 25351
from snowflake.connector import connect
from snowflake.core import Root

connection = connect(connection_name="myconnection")
root = Root(connection)

-- Example 25352
tasks = root.databases["mydb"].schemas["myschema"].tasks
mytask = tasks["mytask"]
mytask.resume()

-- Example 25353
{
  "files":[
    {
      "path":"filePath/file1.csv",
      "size":100
    },
    {
      "path":"filePath/file2.csv",
      "size":100
    }
  ]
}

-- Example 25354
{
  "pipe": "TESTDB.TESTSCHEMA.pipe2",
  "completeResult": true,
  "nextBeginMark": "1_39",
  "files": [
    {
      "path": "data2859002086815673867.csv",
      "stageLocation": "s3://mybucket/",
      "fileSize": 57,
      "timeReceived": "2017-06-21T04:47:41.453Z",
      "lastInsertTime": "2017-06-21T04:48:28.575Z",
      "rowsInserted": 1,
      "rowsParsed": 1,
      "errorsSeen": 0,
      "errorLimit": 1,
      "complete": true,
      "status": "LOADED"
    }
  ]
}

-- Example 25355
{
  "pipe": "TESTDB.TESTSCHEMA.pipe2",
  "completeResult": true,
  "startTimeInclusive": "2017-08-25T18:42:31.081Z",
  "endTimeExclusive":"2017-08-25T22:43:45.552Z",
  "rangeStartTime":"2017-08-25T22:43:45.383Z",
  "rangeEndTime":"2017-08-25T22:43:45.383Z",
  "files": [
    {
      "path": "data2859002086815673867.csv",
      "stageLocation": "s3://mystage/",
      "fileSize": 57,
      "timeReceived": "2017-08-25T22:43:45.383Z",
      "lastInsertTime": "2017-08-25T22:43:45.383Z",
      "rowsInserted": 1,
      "rowsParsed": 1,
      "errorsSeen": 0,
      "errorLimit": 1,
      "complete": true,
      "status": "LOADED"
    }
  ]
}

-- Example 25356
CREATE SEMANTIC VIEW tpch_rev_analysis

  TABLES (
    orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
      PRIMARY KEY (o_orderkey)
      WITH SYNONYMS ('sales orders')
      COMMENT = 'All orders table for the sales domain',
    customers AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
      PRIMARY KEY (c_custkey)
      COMMENT = 'Main table for customer data',
    line_items AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
      PRIMARY KEY (l_orderkey, l_linenumber)
      COMMENT = 'Line items in orders'
  )

  RELATIONSHIPS (
    orders_to_customers AS
      orders (o_custkey) REFERENCES customers,
    line_item_to_orders AS
      line_items (l_orderkey) REFERENCES orders
  )

  FACTS (
    line_items.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
    orders.count_line_items AS COUNT(line_items.line_item_id),
    line_items.discounted_price AS l_extendedprice * (1 - l_discount)
      COMMENT = 'Extended price after discount'
  )

  DIMENSIONS (
    customers.customer_name AS customers.c_name
      WITH SYNONYMS = ('customer name')
      COMMENT = 'Name of the customer',
    orders.order_date AS o_orderdate
      COMMENT = 'Date when the order was placed',
    orders.order_year AS YEAR(o_orderdate)
      COMMENT = 'Year when the order was placed'
  )

  METRICS (
    customers.customer_count AS COUNT(c_custkey)
      COMMENT = 'Count of number of customers',
    orders.order_average_value AS AVG(orders.o_totalprice)
      COMMENT = 'Average order value across all orders',
    orders.average_line_items_per_order AS AVG(orders.count_line_items)
      COMMENT = 'Average number of line items per order'
  )

  COMMENT = 'Semantic view for revenue analysis';

-- Example 25357
TABLES (
  orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
    PRIMARY KEY (o_orderkey)
    WITH SYNONYMS ('sales orders')
    COMMENT = 'All orders table for the sales domain',
  customers AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
    PRIMARY KEY (c_custkey)
    COMMENT = 'Main table for customer data',
  line_items AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
    PRIMARY KEY (l_orderkey, l_linenumber)
    COMMENT = 'Line items in orders'

-- Example 25358
RELATIONSHIPS (
  orders_to_customers AS
    orders (o_custkey) REFERENCES customers (c_custkey),
  line_item_to_orders AS
    line_items (l_orderkey) REFERENCES orders (o_orderkey)
)

-- Example 25359
FACTS (
  line_items.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
  orders.count_line_items AS COUNT(line_items.line_item_id),
  line_items.discounted_price AS l_extendedprice * (1 - l_discount)
    COMMENT = 'Extended price after discount'
)

DIMENSIONS (
  customers.customer_name AS customers.c_name
    WITH SYNONYMS = ('customer name')
    COMMENT = 'Name of the customer',
  orders.order_date AS o_orderdate
    COMMENT = 'Date when the order was placed',
  orders.order_year AS YEAR(o_orderdate)
    COMMENT = 'Year when the order was placed'
)

METRICS (
  customers.customer_count AS COUNT(c_custkey)
    COMMENT = 'Count of number of customers',
  orders.order_average_value AS AVG(orders.o_totalprice)
    COMMENT = 'Average order value across all orders',
  orders.average_line_items_per_order AS AVG(orders.count_line_items)
    COMMENT = 'Average number of line items per order'
)

-- Example 25360
SHOW SEMANTIC VIEWS;

-- Example 25361
+-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------+
| created_on                    | name                  | database_name | schema_name       | comment                                      | owner           | owner_role_type | extension |
|-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------|
| 2025-03-20 15:06:34.039 -0700 | MY_NEW_SEMANTIC_MODEL | MY_DB         | MY_SCHEMA         | A semantic model created through the wizard. | MY_ROLE         | ROLE            | ["CA"]    |
| 2025-02-28 16:16:04.002 -0800 | O_TPCH_SEMANTIC_VIEW  | MY_DB         | MY_SCHEMA         | NULL                                         | MY_ROLE         | ROLE            | NULL      |
| 2025-03-21 07:03:54.120 -0700 | TPCH_REV_ANALYSIS     | MY_DB         | MY_SCHEMA         | Semantic view for revenue analysis           | MY_ROLE         | ROLE            | NULL      |
+-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------+

-- Example 25362
DESCRIBE SEMANTIC VIEW tpch_rev_analysis;

-- Example 25363
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+
| object_kind  | object_name                  | parent_entity | property                 | property_value                         |
|--------------+------------------------------+---------------+--------------------------+----------------------------------------|
| NULL         | NULL                         | NULL          | COMMENT                  | Semantic view for revenue analysis     |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_NAME          | CUSTOMER                               |
| TABLE        | CUSTOMERS                    | NULL          | PRIMARY_KEY              | ["C_CUSTKEY"]                          |
| TABLE        | CUSTOMERS                    | NULL          | COMMENT                  | Main table for customer data           |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | TABLE                    | CUSTOMERS                              |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | EXPRESSION               | customers.c_name                       |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | DATA_TYPE                | VARCHAR(25)                            |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | SYNONYMS                 | ["customer name"]                      |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | COMMENT                  | Name of the customer                   |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_NAME          | LINEITEM                               |
| TABLE        | LINE_ITEMS                   | NULL          | PRIMARY_KEY              | ["L_ORDERKEY","L_LINENUMBER"]          |
| TABLE        | LINE_ITEMS                   | NULL          | COMMENT                  | Line items in orders                   |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | REF_TABLE                | ORDERS                                 |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | FOREIGN_KEY              | ["L_ORDERKEY"]                         |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | REF_KEY                  | ["O_ORDERKEY"]                         |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | EXPRESSION               | l_extendedprice * (1 - l_discount)     |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | DATA_TYPE                | NUMBER(25,4)                           |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | COMMENT                  | Extended price after discount          |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | EXPRESSION               | CONCAT(l_orderkey, '-', l_linenumber)  |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | DATA_TYPE                | VARCHAR(134217728)                     |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_NAME          | ORDERS                                 |
| TABLE        | ORDERS                       | NULL          | SYNONYMS                 | ["sales orders"]                       |
| TABLE        | ORDERS                       | NULL          | PRIMARY_KEY              | ["O_ORDERKEY"]                         |
| TABLE        | ORDERS                       | NULL          | COMMENT                  | All orders table for the sales domain  |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | TABLE                    | ORDERS                                 |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | REF_TABLE                | CUSTOMERS                              |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | FOREIGN_KEY              | ["O_CUSTKEY"]                          |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | REF_KEY                  | ["C_CUSTKEY"]                          |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | TABLE                    | ORDERS                                 |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | EXPRESSION               | AVG(orders.count_line_items)           |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | DATA_TYPE                | NUMBER(36,6)                           |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | COMMENT                  | Average number of line items per order |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | TABLE                    | ORDERS                                 |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | EXPRESSION               | COUNT(line_items.line_item_id)         |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | DATA_TYPE                | NUMBER(18,0)                           |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | TABLE                    | ORDERS                                 |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | EXPRESSION               | AVG(orders.o_totalprice)               |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | DATA_TYPE                | NUMBER(30,8)                           |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | COMMENT                  | Average order value across all orders  |
| DIMENSION    | ORDER_DATE                   | ORDERS        | TABLE                    | ORDERS                                 |
| DIMENSION    | ORDER_DATE                   | ORDERS        | EXPRESSION               | o_orderdate                            |
| DIMENSION    | ORDER_DATE                   | ORDERS        | DATA_TYPE                | DATE                                   |
| DIMENSION    | ORDER_DATE                   | ORDERS        | COMMENT                  | Date when the order was placed         |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | TABLE                    | ORDERS                                 |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | EXPRESSION               | YEAR(o_orderdate)                      |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | DATA_TYPE                | NUMBER(4,0)                            |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | COMMENT                  | Year when the order was placed         |
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+

-- Example 25364
SELECT GET_DDL('SEMANTIC_VIEW', 'tpch_rev_analysis', TRUE);

-- Example 25365
+-----------------------------------------------------------------------------------+
| GET_DDL('SEMANTIC_VIEW', 'TPCH_REV_ANALYSIS', TRUE)                               |
|-----------------------------------------------------------------------------------|
| create or replace semantic view DYOSHINAGA_DB.DYOSHINAGA_SCHEMA.TPCH_REV_ANALYSIS |
|     tables (                                                                                                                                                                       |
|             ORDERS primary key (O_ORDERKEY) with synonyms=('sales orders') comment='All orders table for the sales domain',                                                                                                                                                                       |
|             CUSTOMERS as CUSTOMER primary key (C_CUSTKEY) comment='Main table for customer data',                                                                                                                                                                       |
|             LINE_ITEMS as LINEITEM primary key (L_ORDERKEY,L_LINENUMBER) comment='Line items in orders'                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     relationships (                                                                                                                                                                       |
|             ORDERS_TO_CUSTOMERS as ORDERS(O_CUSTKEY) references CUSTOMERS(C_CUSTKEY),                                                                                                                                                                       |
|             LINE_ITEM_TO_ORDERS as LINE_ITEMS(L_ORDERKEY) references ORDERS(O_ORDERKEY)                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     facts (                                                                                                                                                                       |
|             ORDERS.COUNT_LINE_ITEMS as COUNT(line_items.line_item_id),                                                                                                                                                                       |
|             LINE_ITEMS.DISCOUNTED_PRICE as l_extendedprice * (1 - l_discount) comment='Extended price after discount',                                                                                                                                                                       |
|             LINE_ITEMS.LINE_ITEM_ID as CONCAT(l_orderkey, '-', l_linenumber)                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     dimensions (                                                                                                                                                                       |
|             ORDERS.ORDER_DATE as o_orderdate comment='Date when the order was placed',                                                                                                                                                                       |
|             ORDERS.ORDER_YEAR as YEAR(o_orderdate) comment='Year when the order was placed',                                                                                                                                                                       |
|             CUSTOMERS.CUSTOMER_NAME as customers.c_name with synonyms=('customer name') comment='Name of the customer'                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     metrics (                                                                                                                                                                       |
|             ORDERS.AVERAGE_LINE_ITEMS_PER_ORDER as AVG(orders.count_line_items) comment='Average number of line items per order',                                                                                                                                                                       |
|             ORDERS.ORDER_AVERAGE_VALUE as AVG(orders.o_totalprice) comment='Average order value across all orders'                                                                                                                                                                       |
|     );                                                                                                                                                                       |
+-----------------------------------------------------------------------------------+

-- Example 25366
DROP SEMANTIC VIEW tpch_rev_analysis;

-- Example 25367
CREATE OR REPLACE SEMANTIC VIEW tpch_analysis

  TABLES (
    region AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION PRIMARY KEY (r_regionkey),
    nation AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION PRIMARY KEY (n_nationkey),
    customer AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER PRIMARY KEY (c_custkey),
    orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS PRIMARY KEY (o_orderkey),
    lineitem AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM PRIMARY KEY (l_orderkey, l_linenumber),
    supplier AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER PRIMARY KEY (s_suppkey)
  )

  RELATIONSHIPS (
    nation   (n_regionkey) REFERENCES region,
    customer (c_nationkey) REFERENCES nation,
    orders   (o_custkey)   REFERENCES customer,
    lineitem (l_orderkey)  REFERENCES orders,
    supplier (s_nationkey) REFERENCES nation
  )

  FACTS (
    region.r_name AS r_name,
    nation.n_name AS n_name,
    orders.o_orderkey AS o_orderkey,
    customer.c_customer_order_count AS COUNT(orders.o_orderkey),
    lineitem.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
    orders.count_line_items AS COUNT(lineitem.line_item_id)
  )

  DIMENSIONS (
    nation.nation_name AS n_name,
    customer.customer_name AS c_name,
    customer.customer_region_name AS region.r_name,
    customer.customer_nation_name AS nation.n_name,
    customer.customer_market_segment AS c_mktsegment,
    customer.customer_country_code AS LEFT(c_phone, 2),
    orders.order_date AS orders.o_orderdate
  )

  METRICS (
    customer.customer_count AS COUNT(c_custkey),
    customer.customer_order_count AS SUM(c_customer_order_count),
    orders.order_count AS COUNT(o_orderkey),
    orders.order_average_value AS AVG(orders.o_totalprice),
    orders.average_line_items_per_order AS AVG(orders.count_line_items),
    supplier.supplier_count AS COUNT(s_suppkey)
  )
;

