-- Example 18939
SELECT seq_01.nextval;
+---------+
| NEXTVAL |
|---------|
|       2 |
+---------+

-- Example 18940
INSERT INTO sequence_test_table (i) VALUES (seq_01.nextval);

-- Example 18941
SELECT i FROM sequence_test_table;
+---+
| I |
|---|
| 3 |
+---+

-- Example 18942
CREATE OR REPLACE SEQUENCE seq_5 START = 1 INCREMENT = 5;

-- Example 18943
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d;
+---+---+----+----+
| A | B |  C |  D |
|---+---+----+----|
| 1 | 6 | 11 | 16 |
+---+---+----+----+

-- Example 18944
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d;
+----+----+----+----+
|  A |  B |  C |  D |
|----+----+----+----|
| 36 | 41 | 46 | 51 |
+----+----+----+----+

-- Example 18945
CREATE OR REPLACE SEQUENCE seq90;
CREATE OR REPLACE TABLE sequence_demo (i INTEGER DEFAULT seq90.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Keep doubling the number of rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 18946
SELECT i FROM sequence_demo ORDER BY i LIMIT 10;
+----+
|  I |
|----|
|  1 |
|  2 |
|  3 |
|  4 |
|  5 |
|  6 |
|  7 |
|  8 |
|  9 |
| 10 |
+----+

-- Example 18947
SELECT COUNT(i), COUNT(DISTINCT i) FROM sequence_demo;
+----------+-------------------+
| COUNT(I) | COUNT(DISTINCT I) |
|----------+-------------------|
|     1024 |              1024 |
+----------+-------------------+

-- Example 18948
CREATE [OR REPLACE] SESSION POLICY [IF NOT EXISTS] <name>
  [ SESSION_IDLE_TIMEOUT_MINS = <integer> ]
  [ SESSION_UI_IDLE_TIMEOUT_MINS = <integer> ]
  [ ALLOWED_SECONDARY_ROLES = ( [ { 'ALL' | <role_name> [ , <role_name> ... ] } ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 18949
CREATE SESSION POLICY session_policy_prod_1
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  COMMENT = 'session policy for use in the prod_1 environment'
;

-- Example 18950
CREATE [ OR REPLACE ] SHARE [ IF NOT EXISTS ] <name>
  [ COMMENT = '<string_literal>' ]

-- Example 18951
CREATE SHARE sales_s;

-- Example 18952
+-----------------------------------------+
| status                                  |
|-----------------------------------------|
| Share SALES_S successfully created.     |
+-----------------------------------------+

-- Example 18953
volumes:
  - name: <name>
    source: block
    size: <size in Gi>
    blockConfig:                             # optional
      initialContents:
        fromSnapshot: <snapshot name>
      iops: <number-of-operations>
      throughput: <MiB per second>

-- Example 18954
volumes:
  - name: vol-1
    source: block
    size: 200Gi
    blockConfig:
      initialContents:
        fromSnapshot: snapshot1
      iops: 3000
      throughput: 125

-- Example 18955
{ DESC | DESCRIBE } AUTHENTICATION POLICY <name>

-- Example 18956
DESC AUTHENTICATION POLICY my_auth_policy;

-- Example 18957
DESC[RIBE] CATALOG INTEGRATION <name>

-- Example 18958
DESC CATALOG INTEGRATION my_catalog_integration;

-- Example 18959
+-----------------------+---------------+----------------------------------+------------------+
|       property        | property_type |          property_value          | property_default |
+-----------------------+---------------+----------------------------------+------------------+
| ENABLED               | Boolean       | true                             | false            |
| CATALOG_SOURCE        | String        | GLUE                             |                  |
| CATALOG_NAMESPACE     | String        | dbname                           |                  |
| TABLE_FORMAT          | String        | ICEBERG                          |                  |
| GLUE_AWS_ROLE_ARN     | String        | arn:aws:iam::123:role/dummy-role |                  |
| GLUE_CATALOG_ID       | String        | 123456789012                     |                  |
| GLUE_REGION           | String        | us-west-2                        |                  |
| GLUE_AWS_IAM_USER_ARN | String        | arn:aws:iam::123:user/example    |                  |
| GLUE_AWS_EXTERNAL_ID  | String        | exampleGlueExternalId            |                  |
| COMMENT               | String        |                                  |                  |
+-----------------------+---------------+----------------------------------+------------------+

-- Example 18960
DESC[RIBE] COMPUTE POOL <name>

-- Example 18961
DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 18962
+-----------------------+--------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+-----------+---------+--------------+-------------+--------+------------+----------------+
| name                  | state  | min_nodes | max_nodes | instance_family | num_services | num_jobs | auto_suspend_secs | auto_resume | active_nodes | idle_nodes | target_nodes | created_on                    | resumed_on                    | updated_on                    | owner     | comment | is_exclusive | application | budget | error_code | status_message |
|-----------------------+--------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+-----------+---------+--------------+-------------+--------+------------+----------------|
| TUTORIAL_COMPUTE_POOL | ACTIVE |         1 |         1 | CPU_X64_XS      |            3 |        0 |              3600 | true        |            1 |          0 |            1 | 2024-02-24 20:41:31.978 -0800 | 2024-08-08 11:27:01.775 -0700 | 2024-08-18 13:29:08.124 -0700 | TEST_ROLE | NULL    | false        | NULL        | NULL   |            |                |
+-----------------------+--------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+-----------+---------+--------------+-------------+--------+------------+----------------+

-- Example 18963
DESC[RIBE] DATABASE <database_name>

-- Example 18964
CREATE DATABASE desc_demo;

CREATE SCHEMA sample_schema_1;

CREATE SCHEMA sample_schema_2;

DESCRIBE DATABASE desc_demo;

-- Example 18965
+-------------------------------+--------------------+--------+
| created_on                    | name               | kind   |
|-------------------------------+--------------------+--------|
| 2022-06-23 00:00:00.000 -0700 | INFORMATION_SCHEMA | SCHEMA |
| 2022-06-23 00:00:00.000 -0700 | PUBLIC             | SCHEMA |
| 2022-06-23 01:00:00.000 -0700 | SAMPLE_SCHEMA_1    | SCHEMA |
| 2022-06-23 02:00:00.000 -0700 | SAMPLE_SCHEMA_2    | SCHEMA |
+-------------------------------+--------------------+--------+

-- Example 18966
DESC[RIBE] DYNAMIC TABLE <name>

-- Example 18967
DESC DYNAMIC TABLE product;

-- Example 18968
DESC[RIBE] EVENT TABLE <name>

-- Example 18969
DESC EVENT TABLE my_logged_events;

-- Example 18970
DESC[RIBE] [ EXTERNAL ] TABLE <name> [ TYPE =  { COLUMNS | STAGE } ]

-- Example 18971
CREATE EXTERNAL TABLE emp ( ... );

-- Example 18972
DESC EXTERNAL TABLE emp;

-- Example 18973
DESC[RIBE] FILE FORMAT <name>

-- Example 18974
DESC FILE FORMAT my_csv_format;

-- Example 18975
+--------------------------------+---------------+----------------+------------------+
| property                       | property_type | property_value | property_default |
+--------------------------------+---------------+----------------+------------------+
| TYPE                           | String        | csv            | CSV              |
| RECORD_DELIMITER               | String        | \n             | \n               |
| FIELD_DELIMITER                | String        | ,              | ,                |
| FILE_EXTENSION                 | String        |                |                  |
| SKIP_HEADER                    | Integer       | 0              | 0                |
| PARSE_HEADER                   | Boolean       | FALSE          | FALSE            |
| DATE_FORMAT                    | String        | AUTO           | AUTO             |
| TIME_FORMAT                    | String        | AUTO           | AUTO             |
| TIMESTAMP_FORMAT               | String        | AUTO           | AUTO             |
| BINARY_FORMAT                  | String        | HEX            | HEX              |
| ESCAPE                         | String        | NONE           | NONE             |
| ESCAPE_UNENCLOSED_FIELD        | String        | \\             | \\               |
| TRIM_SPACE                     | Boolean       | FALSE          | FALSE            |
| FIELD_OPTIONALLY_ENCLOSED_BY   | String        | NONE           | NONE             |
| NULL_IF                        | List          | [\\N]          | [\\N]            |
| COMPRESSION                    | String        | AUTO           | AUTO             |
| ERROR_ON_COLUMN_COUNT_MISMATCH | Boolean       | TRUE           | TRUE             |
| VALIDATE_UTF8                  | Boolean       | TRUE           | TRUE             |
| SKIP_BLANK_LINES               | Boolean       | FALSE          | FALSE            |
| REPLACE_INVALID_CHARACTERS     | Boolean       | FALSE          | FALSE            |
| EMPTY_FIELD_AS_NULL            | Boolean       | TRUE           | TRUE             |
| SKIP_BYTE_ORDER_MARK           | Boolean       | TRUE           | TRUE             |
| ENCODING                       | String        | UTF8           | UTF8             |
+--------------------------------+---------------+----------------+------------------+

-- Example 18976
DESC FILE FORMAT `my_json_format`;

-- Example 18977
+----------------------------+---------------+----------------+------------------+
| property                   | property_type | property_value | property_default |
+----------------------------+---------------+----------------+------------------+
| TYPE                       | String        | JSON           | CSV              |
| FILE_EXTENSION             | String        |                |                  |
| DATE_FORMAT                | String        | AUTO           | AUTO             |
| TIME_FORMAT                | String        | AUTO           | AUTO             |
| TIMESTAMP_FORMAT           | String        | AUTO           | AUTO             |
| BINARY_FORMAT              | String        | HEX            | HEX              |
| TRIM_SPACE                 | Boolean       | FALSE          | FALSE            |
| NULL_IF                    | List          | []             | [\\N]            |
| COMPRESSION                | String        | AUTO           | AUTO             |
| ENABLE_OCTAL               | Boolean       | FALSE          | FALSE            |
| ALLOW_DUPLICATE            | Boolean       | FALSE          | FALSE            |
| STRIP_OUTER_ARRAY          | Boolean       | FALSE          | FALSE            |
| STRIP_NULL_VALUES          | Boolean       | FALSE          | FALSE            |
| IGNORE_UTF8_ERRORS         | Boolean       | FALSE          | FALSE            |
| REPLACE_INVALID_CHARACTERS | Boolean       | FALSE          | FALSE            |
| SKIP_BYTE_ORDER_MARK       | Boolean       | TRUE           | TRUE             |
+----------------------------+---------------+----------------+------------------+

-- Example 18978
DESC FILE FORMAT `my_parquet_format`;

-- Example 18979
+----------------+---------------+----------------+------------------+
| property       | property_type | property_value | property_default |
+----------------+---------------+----------------+------------------+
| TYPE           | String        | PARQUET        | CSV              |
| TRIM_SPACE     | Boolean       | FALSE          | FALSE            |
| NULL_IF        | List          | []             | [\\N]            |
| COMPRESSION    | String        | SNAPPY         | AUTO             |
| BINARY_AS_TEXT | Boolean       | TRUE           | TRUE             |
+----------------+---------------+----------------+------------------+

-- Example 18980
{ DESC | DESCRIBE } FUNCTION [ IF EXISTS ] <name>(
  TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ]
  )

-- Example 18981
DESC FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

-- Example 18982
+-----------+---------------------------------------------------------------------+
| property  | value                                                               |
+-----------+---------------------------------------------------------------------+
| signature | (ARG_T TABLE(ARG_C1 NUMBER, ARG_C2 NUMBER, ARG_C3 NUMBER))          |
| returns   | NUMBER(38,0)                                                        |
| language  | SQL                                                                 |
| body      | SELECT COUNT(*) FROM arg_t WHERE arg_c1>0 AND arg_c2>0 AND arg_c3>0 |
+-----------+---------------------------------------------------------------------+

-- Example 18983
{ DESC | DESCRIBE } FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> ] [ , ... ] )

-- Example 18984
DESC FUNCTION my_echo_udf(VARCHAR);

-- Example 18985
+------------------+----------------------+
| property         | value                |
|------------------+----------------------|
| signature        | (INPUTTEXT VARCHAR)  |
| returns          | VARCHAR(16777216)    |
| language         | NULL                 |
| null handling    | CALLED ON NULL INPUT |
| volatility       | VOLATILE             |
| body             | /echo                |
| headers          | null                 |
| context_headers  | null                 |
| max_batch_rows   | not set              |
| service          | ECHO_SERVICE         |
| service_endpoint | echoendpoint         |
+------------------+----------------------+

-- Example 18986
DESC[RIBE] [ ICEBERG ] TABLE <name> [ TYPE =  { COLUMNS | STAGE } ]

-- Example 18987
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_01');

-- Example 18988
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table
  CATALOG='my_catalog_integration'
  EXTERNAL_VOLUME='my_ext_volume'
  METADATA_FILE_PATH='path/to/metadata/v2.metadata.json';

-- Example 18989
DESC ICEBERG TABLE my_iceberg_table ;

-- Example 18990
{ DESCRIBE | DESC } JOIN POLICY <name>

-- Example 18991
DESCRIBE JOIN POLICY jp3;

-- Example 18992
+------+-----------+-----------------+-----------------------------------------+
| name | signature | return_type     | body                                    |
|------+-----------+-----------------+-----------------------------------------|
| JP3  | ()        | JOIN_CONSTRAINT | JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE) |
+------+-----------+-----------------+-----------------------------------------+

-- Example 18993
{ DESC | DESCRIBE } LISTING <name>  [ REVISION = { DRAFT | PUBLISHED } ]

-- Example 18994
DESC LISTING MYLISTING;

-- Example 18995
+------------------------------+---------------------+------------------+---------------------+--------------------------------------+--------------------------------------+--------------------------------------+----------------------------------------------------------------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+---------------------+------------------+--------------------+-----------------+---------------+---------------------+-------------+----------------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+-------------------------+--------------------------------------------------+-----------------------------+----------------------+------------------------------------------------------------------------------------------------------------------------------------+-------------+-----------------------------------------------------------------------------------+------------------+----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+---------------------------------+
|   global_name                |   name              |   owner          |   owner_role_type   |   created_on                         |   updated_on                         |   published_on                       |   title                                                        |   subtitle                                         |   description                                                                                                              |   target_accounts   |   is_monetized   |   is_application   |   is_targeted   |   state       |   revisions         |   comment   |   refresh_schedule   |   refresh_type    |   business_needs                                                                                                                                         |   usage_examples                                                                                                     |   listing_terms         |   profile                                        |   customized_contact_info   |  application_package |  data_dictionary                                                                                                                   |   regions   |   manifest_yaml                                                                   |   review_state   |   rejection_reason   |   categories   |   resources                                                                                                     |   unpublished_by_admin_reason   |
+------------------------------+---------------------+------------------+---------------------+--------------------------------------+--------------------------------------+--------------------------------------+----------------------------------------------------------------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+---------------------+------------------+--------------------+-----------------+---------------+---------------------+-------------+----------------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+-------------------------+--------------------------------------------------+-----------------------------+----------------------+------------------------------------------------------------------------------------------------------------------------------------+-------------+-----------------------------------------------------------------------------------+------------------+----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+---------------------------------+
|   GZ13Z1VEWNG                |   CDC_COVID_19_DATA |   ACCOUNTADMIN   |   ROLE              |   2023-12-01T13:01:13.367-08:00      |   2023-12-01T13:25:11.331-08:00      |   2023-12-01T13:25:11.331-08:00      |   Understanding COVID-19: Explore the Latest Data from the CDC |   Track cases, deaths, vaccination rates, and more |   Get the most up-to-date information on the COVID-19 pandemic from the Centers for Disease Control and Prevention (CDC).  |                     |   false          |   false            |   false         |   PUBLISHED   |   DRAFT,PUBLISHED   |             |   60 MINUTE          |   FULL_DATABASE   |   [{""type"":""CUSTOM"",""name"":""Public Health Monitoring and Response"",""description"":""Monitor trends in cases, deaths, and other key metrics.""}] |   [{""title"":""Identify potential outbreaks of COVID-19 in [country name] by tracking trends in confirmed cases"    |   {"type":"STANDARD"}   |   RAVENCLAW_9A314599_F644_4664_946B_4DE0B2169C28 |                             |                      |  {""database"":""COVIDDATADB"",""objects"":[{""schema"":""PUBLIC"",""domain"":""TABLE"",""name"":""GLOBAL_COVID_STATISTICS""}]}"   |   ALL       |   title: "Understanding COVID-19: Explore the Latest Data from the CDC"  . . .    |                  |                      |   HEALTH       |   "{""documentation"":""https://snowflake.com/doc"",""media"":""https://www.youtube.com/watch?v=AR88dZG-hwo""}" |                                 |
+------------------------------+---------------------+------------------+---------------------+--------------------------------------+--------------------------------------+--------------------------------------+----------------------------------------------------------------+----------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------+---------------------+------------------+--------------------+-----------------+---------------+---------------------+-------------+----------------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------+-------------------------+--------------------------------------------------+-----------------------------+----------------------+------------------------------------------------------------------------------------------------------------------------------------+-------------+-----------------------------------------------------------------------------------+------------------+----------------------+----------------+-----------------------------------------------------------------------------------------------------------------+---------------------------------+

-- Example 18996
DESC[RIBE] MATERIALIZED VIEW <name>

-- Example 18997
CREATE MATERIALIZED VIEW emp_view
    AS
    SELECT id "Employee Number", lname "Last Name", location "Home Base" FROM emp;

-- Example 18998
DESC MATERIALIZED VIEW emp_view;

-- Example 18999
+-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name            | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| Employee Number | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| Last Name       | VARCHAR(50)  | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| Home Base       | VARCHAR(100) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+-----------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

-- Example 19000
{ DESCRIBE | DESC } MODEL MONITOR <monitor_name>

-- Example 19001
DESC[RIBE] NETWORK RULE <name>

-- Example 19002
DESC NETWORK RULE myrule;

-- Example 19003
{ DESC | DESCRIBE } NOTEBOOK <name>

-- Example 19004
DESCRIBE NOTEBOOK mybook;

-- Example 19005
{ DESC | DESCRIBE } NOTIFICATION INTEGRATION <name>

