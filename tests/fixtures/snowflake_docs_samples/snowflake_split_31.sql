-- Example 2041
COPY INTO mycsvtable
  FROM @my_csv_stage/contacts3.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

-- Example 2042
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                        | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts3.csv.gz | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 2043
SELECT * FROM mycsvtable;

-- Example 2044
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------+
| ID | LAST_NAME | FIRST_NAME | COMPANY                          | EMAIL                                  | WORKPHONE      | CELLPHONE      | STREETADDRESS                   | CITY             | POSTALCODE |
|----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------|
|  6 | Reed      | Moses      | Neque Corporation                | eget.lacus@facilisis.com               | 1-449-871-0780 | 1-454-964-5318 | Ap #225-4351 Dolor Ave          | Titagarh         |      62631 |
|  7 | Audrey    | Franks     | Arcu Eu Limited                  | eu.dui@aceleifendvitae.org             | 1-527-945-8935 | 1-263-127-1173 | Ap #786-9241 Mauris Road        | Bergen           |      81958 |
|  8 | Jakeem    | Erickson   | A Ltd                            | Pellentesque.habitant@liberoProinmi.ca | 1-381-591-9386 | 1-379-391-9490 | 319-1703 Dis Rd.                | Pangnirtung      |      62399 |
|  9 | Xaviera   | Brennan    | Bibendum Ullamcorper Limited     | facilisi.Sed.neque@dictum.edu          | 1-260-757-1919 | 1-211-651-0925 | P.O. Box 146, 8385 Vel Road     | Béziers          |      13082 |
| 10 | Francis   | Ortega     | Vitae Velit Egestas Associates   | egestas.rhoncus.Proin@faucibus.com     | 1-257-584-6487 | 1-211-870-2111 | 733-7191 Neque Rd.              | Chatillon        |      33081 |
| 16 | Aretha    | Sykes      | Lobortis Tellus Justo Foundation | eget@Naminterdumenim.net               | 1-670-849-1866 | 1-283-783-3710 | Ap #979-2481 Dui. Av.           | Thurso           |      66851 |
| 17 | Akeem     | Casey      | Pharetra Quisque Ac Institute    | dictum.eu@magna.edu                    | 1-277-657-0361 | 1-623-630-8848 | Ap #363-6074 Ullamcorper, Rd.   | Idar-Oberstei    |      30848 |
| 18 | Keelie    | Mendez     | Purus In Foundation              | Nulla.eu.neque@Aeneanegetmetus.co.uk   | 1-330-370-8231 | 1-301-568-0413 | 3511 Tincidunt Street           | Lanklaar         |      73942 |
| 19 | Lane      | Bishop     | Libero At PC                     | non@dapibusligula.ca                   | 1-340-862-4623 | 1-513-820-9039 | 7459 Pede. Street               | Linkebeek        |      89252 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                  | Stornaway        |      61290 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                  | Stornaway        |      61290 |
| 21 | Lance     | Harper     | Rutrum Lorem Limited             | Sed.neque@risus.com                    | 1-685-778-6726 | 1-494-188-6168 | 663-7682 Et St.                 | Gisborne         |      73449 |
| 22 | Keely     | Pace       | Eleifend Limited                 | ante.bibendum.ullamcorper@necenim.edu  | 1-312-381-5244 | 1-432-225-9226 | P.O. Box 506, 5233 Aliquam Av.  | Woodlands County |      61213 |
| 23 | Sage      | Leblanc    | Egestas A Consulting             | dapibus@elementum.org                  | 1-630-981-0327 | 1-301-287-0495 | 4463 Lorem Road                 | Woodlands County |      33951 |
| 24 | Marny     | Holt       | Urna Nec Luctus Associates       | ornare@vitaeorci.ca                    | 1-522-364-3947 | 1-460-971-8360 | P.O. Box 311, 4839 Nulla Av.    | Port Coquitlam   |      36733 |
| 25 | Holly     | Park       | Mauris PC                        | Vestibulum.ante@Maecenasliberoest.org  | 1-370-197-9316 | 1-411-413-4602 | P.O. Box 732, 8967 Eu Avenue    | Provost          |      45507 |
|  1 | Imani     | Davidson   | At Ltd                           | nec@sem.net                            | 1-243-889-8106 | 1-730-771-0412 | 369-6531 Molestie St.           | Russell          |      74398 |
|  2 | Kelsie    | Abbott     | Neque Sed Institute              | lacus@pede.net                         | 1-467-506-9933 | 1-441-508-7753 | P.O. Box 548, 1930 Pede. Road   | Campbellton      |      27022 |
|  3 | Hilel     | Durham     | Pede Incorporated                | eu@Craspellentesque.net                | 1-752-108-4210 | 1-391-449-8733 | Ap #180-2360 Nisl. Street       | Etalle           |      84025 |
|  4 | Graiden   | Molina     | Sapien Institute                 | sit@fermentum.net                      | 1-130-156-6666 | 1-269-605-7776 | 8890 A, Rd.                     | Dundee           |      70504 |
|  5 | Karyn     | Howard     | Pede Ac Industries               | sed.hendrerit@ornaretortorat.edu       | 1-109-166-5492 | 1-506-782-5089 | P.O. Box 902, 5398 Et, St.      | Saint-Hilarion   |      26232 |
| 11 | Ishmael   | Burnett    | Dolor Elit Pellentesque Ltd      | vitae.erat@necmollisvitae.ca           | 1-872-600-7301 | 1-513-592-6779 | P.O. Box 975, 553 Odio, Road    | Hulste           |      63345 |
| 12 | Ian       | Fields     | Nulla Magna Malesuada PC         | rutrum.non@condimentumDonec.co.uk      | 1-138-621-8354 | 1-369-126-7068 | P.O. Box 994, 7053 Quisque Ave  | Ostra Vetere     |      90433 |
| 13 | Xanthus   | Acosta     | Tortor Company                   | Nunc.lectus@a.org                      | 1-834-909-8838 | 1-693-411-2633 | 282-7994 Nunc Av.               | Belcarra         |      28890 |
| 14 | Sophia    | Christian  | Turpis Ltd                       | lectus.pede@non.ca                     | 1-962-503-3253 | 1-157-850-3602 | P.O. Box 824, 7971 Sagittis Rd. | Chattanooga      |      56188 |
| 15 | Dorothy   | Watson     | A Sollicitudin Orci Company      | diam.dictum@fermentum.co.uk            | 1-158-596-8622 | 1-402-884-3438 | 3348 Nec Street                 | Qu�bec City      |      63320 |
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------+

-- Example 2045
SELECT * FROM myjsontable;

-- Example 2046
+-----------------------------------------------------------------+
| JSON_DATA                                                       |
|-----------------------------------------------------------------|
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864df388f1d653e37e6f",                          |
|     "address": "509 Kings Hwy, Comptche, Missouri, 4848",       |
|     "company": "ORBIN",                                         |
|     "email": "blankenship.patrick@orbin.ca",                    |
|     "name": {                                                   |
|       "first": "Blankenship",                                   |
|       "last": "Patrick"                                         |
|     },                                                          |
|     "phone": "+1 (999) 407-2274"                                |
|   }                                                             |
| }                                                               |
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864d4d8523c8baa8baf6",                          |
|     "address": "290 Lefferts Avenue, Malott, Delaware, 1575",   |
|     "company": "SNIPS",                                         |
|     "email": "anna.glass@snips.name",                           |
|     "name": {                                                   |
|       "first": "Anna",                                          |
|       "last": "Glass"                                           |
|     },                                                          |
|     "phone": "+1 (958) 411-2876"                                |
|   }                                                             |
| }                                                               |
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864e375e08523150fc04",                          |
|     "address": "756 Randolph Street, Omar, Rhode Island, 3310", |
|     "company": "ESCHOIR",                                       |
|     "email": "sparks.ramos@eschoir.co.uk",                      |
|     "name": {                                                   |
|       "first": "Sparks",                                        |
|       "last": "Ramos"                                           |
|     },                                                          |
|     "phone": "+1 (962) 436-2519"                                |
|   }                                                             |
| }                                                               |
+-----------------------------------------------------------------+

-- Example 2047
REMOVE @my_csv_stage PATTERN='.*.csv.gz';

-- Example 2048
+-------------------------------+---------+
| name                          | result  |
|-------------------------------+---------|
| my_csv_stage/contacts1.csv.gz | removed |
| my_csv_stage/contacts4.csv.gz | removed |
| my_csv_stage/contacts2.csv.gz | removed |
| my_csv_stage/contacts3.csv.gz | removed |
| my_csv_stage/contacts5.csv.gz | removed |
+-------------------------------+---------+

-- Example 2049
REMOVE @my_json_stage PATTERN='.*.json.gz';

-- Example 2050
+--------------------------------+---------+
| name                           | result  |
|--------------------------------+---------|
| my_json_stage/contacts.json.gz | removed |
+--------------------------------+---------+

-- Example 2051
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 2052
CREATE DATABASE doc_ai_db;
CREATE SCHEMA doc_ai_db.doc_ai_schema;

-- Example 2053
USE ROLE ACCOUNTADMIN;

CREATE ROLE doc_ai_role;

-- Example 2054
GRANT DATABASE ROLE SNOWFLAKE.DOCUMENT_INTELLIGENCE_CREATOR TO ROLE doc_ai_role;

-- Example 2055
GRANT USAGE, OPERATE ON WAREHOUSE <your_warehouse> TO ROLE doc_ai_role;

-- Example 2056
GRANT USAGE ON DATABASE doc_ai_db TO ROLE doc_ai_role;
GRANT USAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 2057
GRANT CREATE STAGE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 2058
GRANT CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT CREATE MODEL ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;

-- Example 2059
GRANT CREATE STREAM, CREATE TABLE, CREATE TASK, CREATE VIEW ON SCHEMA doc_ai_db.doc_ai_schema TO ROLE doc_ai_role;
GRANT EXECUTE TASK ON ACCOUNT TO ROLE doc_ai_role;

-- Example 2060
GRANT ROLE doc_ai_role TO USER <your_user_name>;

-- Example 2061
CREATE OR REPLACE STAGE my_pdf_stage
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 2062
CREATE STREAM my_pdf_stream ON STAGE my_pdf_stage;

-- Example 2063
ALTER STAGE my_pdf_stage REFRESH;

-- Example 2064
USE DATABASE doc_ai_db;
USE SCHEMA doc_ai_schema;

-- Example 2065
CREATE OR REPLACE TABLE pdf_reviews (
  file_name VARCHAR,
  file_size VARIANT,
  last_modified VARCHAR,
  snowflake_file_url VARCHAR,
  json_content VARCHAR
);

-- Example 2066
CREATE OR REPLACE TASK load_new_file_data
  WAREHOUSE = <your_warehouse>
  SCHEDULE = '1 minute'
  COMMENT = 'Process new files in the stage and insert data into the pdf_reviews table.'
WHEN SYSTEM$STREAM_HAS_DATA('my_pdf_stream')
AS
INSERT INTO pdf_reviews (
  SELECT
    RELATIVE_PATH AS file_name,
    size AS file_size,
    last_modified,
    file_url AS snowflake_file_url,
    inspection_reviews!PREDICT(GET_PRESIGNED_URL('@my_pdf_stage', RELATIVE_PATH), 1) AS json_content
  FROM my_pdf_stream
  WHERE METADATA$ACTION = 'INSERT'
);

-- Example 2067
ALTER TASK load_new_file_data RESUME;

-- Example 2068
SELECT * FROM pdf_reviews;

-- Example 2069
CREATE OR REPLACE TABLE doc_ai_db.doc_ai_schema.pdf_reviews_2 AS (
 WITH temp AS (
   SELECT
     RELATIVE_PATH AS file_name,
     size AS file_size,
     last_modified,
     file_url AS snowflake_file_url,
     inspection_reviews!PREDICT(get_presigned_url('@my_pdf_stage', RELATIVE_PATH), 1) AS json_content
   FROM directory(@my_pdf_stage)
 )

 SELECT
   file_name,
   file_size,
   last_modified,
   snowflake_file_url,
   json_content:__documentMetadata.ocrScore::FLOAT AS ocrScore,
   f.value:score::FLOAT AS inspection_date_score,
   f.value:value::STRING AS inspection_date_value,
   g.value:score::FLOAT AS inspection_grade_score,
   g.value:value::STRING AS inspection_grade_value,
   i.value:score::FLOAT AS inspector_score,
   i.value:value::STRING AS inspector_value,
   ARRAY_TO_STRING(ARRAY_AGG(j.value:value::STRING), ', ') AS list_of_units
 FROM temp,
   LATERAL FLATTEN(INPUT => json_content:inspection_date) f,
   LATERAL FLATTEN(INPUT => json_content:inspection_grade) g,
   LATERAL FLATTEN(INPUT => json_content:inspector) i,
   LATERAL FLATTEN(INPUT => json_content:list_of_units) j
 GROUP BY ALL
);

-- Example 2070
SELECT * FROM pdf_reviews_2;

-- Example 2071
CREATE WAREHOUSE iceberg_tutorial_wh
  WAREHOUSE_TYPE = STANDARD
  WAREHOUSE_SIZE = XSMALL;

USE WAREHOUSE iceberg_tutorial_wh;

CREATE OR REPLACE DATABASE iceberg_tutorial_db;
USE DATABASE iceberg_tutorial_db;

-- Example 2072
{
   "Version": "2012-10-17",
   "Statement": [
         {
            "Effect": "Allow",
            "Action": [
               "s3:PutObject",
               "s3:GetObject",
               "s3:GetObjectVersion",
               "s3:DeleteObject",
               "s3:DeleteObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>/*"
         },
         {
            "Effect": "Allow",
            "Action": [
               "s3:ListBucket",
               "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<my_bucket>",
            "Condition": {
               "StringLike": {
                     "s3:prefix": [
                        "*"
                     ]
               }
            }
         }
   ]
}

-- Example 2073
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'my-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://<my_bucket>/'
            STORAGE_AWS_ROLE_ARN = '<arn:aws:iam::123456789012:role/myrole>'
            STORAGE_AWS_EXTERNAL_ID = 'iceberg_table_external_id'
         )
      )
      ALLOW_WRITES = TRUE;

-- Example 2074
DESC EXTERNAL VOLUME iceberg_external_volume;

-- Example 2075
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<iceberg_table_external_id>"
        }
      }
    }
  ]
}

-- Example 2076
CREATE OR REPLACE ICEBERG TABLE customer_iceberg (
    c_custkey INTEGER,
    c_name STRING,
    c_address STRING,
    c_nationkey INTEGER,
    c_phone STRING,
    c_acctbal INTEGER,
    c_mktsegment STRING,
    c_comment STRING
)
    CATALOG = 'SNOWFLAKE'
    EXTERNAL_VOLUME = 'iceberg_external_volume'
    BASE_LOCATION = 'customer_iceberg';

-- Example 2077
ALTER DATABASE iceberg_tutorial_db SET CATALOG = 'SNOWFLAKE';
ALTER DATABASE iceberg_tutorial_db SET EXTERNAL_VOLUME = 'iceberg_external_volume';

-- Example 2078
SHOW PARAMETERS IN DATABASE ;

-- Example 2079
CREATE OR REPLACE ICEBERG TABLE nation_iceberg (
  n_nationkey INTEGER,
  n_name STRING
)
  BASE_LOCATION = 'nation_iceberg'
  AS SELECT
    N_NATIONKEY,
    N_NAME
  FROM snowflake_sample_data.tpch_sf1.nation;

-- Example 2080
INSERT INTO customer_iceberg
  SELECT * FROM snowflake_sample_data.tpch_sf1.customer;

-- Example 2081
SELECT
    c.c_name AS customer_name,
    c.c_mktsegment AS market_segment,
    n.n_name AS nation
  FROM customer_iceberg c
  INNER JOIN nation_iceberg n
    ON c.c_nationkey = n.n_nationkey
  LIMIT 15;

-- Example 2082
+--------------------+----------------+----------------+
| CUSTOMER_NAME      | MARKET_SEGMENT | NATION         |
|--------------------+----------------+----------------|
| Customer#000015001 | HOUSEHOLD      | MOROCCO        |
| Customer#000015002 | BUILDING       | VIETNAM        |
| Customer#000015003 | BUILDING       | INDONESIA      |
| Customer#000015004 | FURNITURE      | SAUDI ARABIA   |
| Customer#000015005 | HOUSEHOLD      | KENYA          |
| Customer#000015006 | BUILDING       | UNITED KINGDOM |
| Customer#000015007 | MACHINERY      | FRANCE         |
| Customer#000015008 | HOUSEHOLD      | INDIA          |
| Customer#000015009 | FURNITURE      | EGYPT          |
| Customer#000015010 | HOUSEHOLD      | ETHIOPIA       |
| Customer#000015011 | FURNITURE      | UNITED KINGDOM |
| Customer#000015012 | BUILDING       | FRANCE         |
| Customer#000015013 | FURNITURE      | SAUDI ARABIA   |
| Customer#000015014 | HOUSEHOLD      | KENYA          |
| Customer#000015015 | MACHINERY      | ROMANIA        |
+--------------------+----------------+----------------+

-- Example 2083
SELECT
    c_name AS customer_name,
    c_mktsegment AS market_segment
  FROM customer_iceberg
  LIMIT 10;

-- Example 2084
+--------------------+----------------+
| CUSTOMER_NAME      | MARKET_SEGMENT |
|--------------------+----------------|
| Customer#000000001 | BUILDING       |
| Customer#000000002 | AUTOMOBILE     |
| Customer#000000003 | AUTOMOBILE     |
| Customer#000000004 | MACHINERY      |
| Customer#000000005 | HOUSEHOLD      |
| Customer#000000006 | AUTOMOBILE     |
| Customer#000000007 | AUTOMOBILE     |
| Customer#000000008 | BUILDING       |
| Customer#000000009 | FURNITURE      |
| Customer#000000010 | HOUSEHOLD      |
+--------------------+----------------+

-- Example 2085
DELETE FROM customer_iceberg WHERE c_mktsegment = 'AUTOMOBILE';

-- Example 2086
+------------------------+
| number of rows deleted |
|------------------------|
|                  29752 |
+------------------------+

-- Example 2087
SELECT
    c_name AS customer_name,
    c_mktsegment AS market_segment
 FROM customer_iceberg
 WHERE c_mktsegment = 'AUTOMOBILE';

-- Example 2088
+---------------+----------------+
| CUSTOMER_NAME | MARKET_SEGMENT |
|---------------+----------------|
+---------------+----------------+
0 Row(s) produced. Time Elapsed: 1.426s

-- Example 2089
DROP ICEBERG TABLE customer_iceberg;
DROP ICEBERG TABLE nation_iceberg;
DROP EXTERNAL VOLUME iceberg_external_volume;
USE DATABASE <my_other_database>;
DROP DATABASE iceberg_tutorial_db;
USE WAREHOUSE <my_other_warehouse>;
DROP WAREHOUSE iceberg_tutorial_wh;

-- Example 2090
USE ROLE ACCOUNTADMIN;

CREATE NOTIFICATION INTEGRATION budgets_notification_integration
  TYPE=EMAIL
  ENABLED=TRUE
  ALLOWED_RECIPIENTS=('<YOUR_EMAIL_ADDRESS>');

-- Example 2091
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 2092
USE ROLE ACCOUNTADMIN;

CREATE DATABASE budgets_db;

CREATE SCHEMA budgets_db.budgets_schema;

-- Example 2093
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_admin;

GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_ADMIN TO ROLE account_budget_admin;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_admin;

-- Example 2094
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_monitor;
 
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE account_budget_monitor;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_monitor;

-- Example 2095
USE ROLE ACCOUNTADMIN;
   
CREATE ROLE budget_owner;
  
GRANT USAGE ON DATABASE budgets_db TO ROLE budget_owner;
GRANT USAGE ON SCHEMA budgets_db.budgets_schema TO ROLE budget_owner;

GRANT DATABASE ROLE SNOWFLAKE.BUDGET_CREATOR TO ROLE budget_owner;

GRANT CREATE SNOWFLAKE.CORE.BUDGET ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_owner;

-- Example 2096
USE ROLE ACCOUNTADMIN;

CREATE ROLE budget_admin;

GRANT USAGE ON DATABASE budgets_db TO ROLE budget_admin;

GRANT USAGE ON SCHEMA budgets_db.budgets_schema TO ROLE budget_admin;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_admin;

-- Example 2097
USE ROLE ACCOUNTADMIN;

CREATE ROLE budget_monitor;

GRANT USAGE ON DATABASE budgets_db TO ROLE budget_monitor;

GRANT USAGE ON SCHEMA budgets_db.budgets_schema TO ROLE budget_monitor;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_monitor;

-- Example 2098
GRANT ROLE account_budget_admin
  TO USER <YOUR_USER_NAME>;

-- Example 2099
GRANT ROLE account_budget_monitor
  TO USER <YOUR_USER_NAME>;

-- Example 2100
GRANT ROLE budget_owner
  TO USER <YOUR_USER_NAME>;

-- Example 2101
GRANT ROLE budget_monitor
  TO USER <YOUR_USER_NAME>;

-- Example 2102
CREATE WAREHOUSE na_finance_wh;

-- Example 2103
GRANT USAGE ON WAREHOUSE na_finance_wh TO ROLE account_budget_admin;
GRANT USAGE ON WAREHOUSE na_finance_wh TO ROLE account_budget_monitor;
GRANT USAGE ON WAREHOUSE na_finance_wh TO ROLE budget_admin;
GRANT USAGE ON WAREHOUSE na_finance_wh TO ROLE budget_owner;
GRANT USAGE ON WAREHOUSE na_finance_wh TO ROLE budget_monitor;

-- Example 2104
GRANT APPLYBUDGET ON WAREHOUSE na_finance_wh TO ROLE budget_owner;

-- Example 2105
CREATE DATABASE na_finance_db;

-- Example 2106
GRANT APPLYBUDGET ON DATABASE  na_finance_db TO ROLE budget_owner;

-- Example 2107
USE ROLE account_budget_admin;

CALL snowflake.local.account_root_budget!ACTIVATE();

-- Example 2108
CALL snowflake.local.account_root_budget!SET_SPENDING_LIMIT(500);

