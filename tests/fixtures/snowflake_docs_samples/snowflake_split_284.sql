-- Example 19006
DESC INTEGRATION my_notify_int;

-- Example 19007
DESC[RIBE] PACKAGES POLICY <name>

-- Example 19008
DESC PACKAGES POLICY packages_policy_prod_1;

-- Example 19009
DESC[RIBE] PASSWORD POLICY <name>

-- Example 19010
DESC PASSWORD POLICY password_policy_prod_1;

-- Example 19011
+-----------------------------------+----------------------------------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
|   property                        |   value                                |   default   |   description                                                                                                                                 |
+-----------------------------------+----------------------------------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
|   NAME                            |   PASSWORD_POLICY_PROD_1               |   null      |   Name of password policy.                                                                                                                    |
|   OWNER                           |   PROD_ADMIN                           |   null      |   Owner of password policy.                                                                                                                   |
|   COMMENT                         |   production account password policy   |   null      |   user comment associated to an object in the dictionary                                                                                      |
|   PASSWORD_MIN_LENGTH             |   12                                   |   8         |   Minimum length of new password.                                                                                                             |
|   PASSWORD_MAX_LENGTH             |   24                                   |   256       |   Maximum length of new password.                                                                                                             |
|   PASSWORD_MIN_UPPER_CASE_CHARS   |   2                                    |   1         |   Minimum number of uppercase characters in new password.                                                                                     |
|   PASSWORD_MIN_LOWER_CASE_CHARS   |   2                                    |   1         |   Minimum number of lowercase characters in new password.                                                                                     |
|   PASSWORD_MIN_NUMERIC_CHARS      |   2                                    |   1         |   Minimum number of numeric characters in new password.                                                                                       |
|   PASSWORD_MIN_SPECIAL_CHARS      |   2                                    |   0         |   Minimum number of special characters in new password.                                                                                       |
|   PASSWORD_MIN_AGE_DAYS           |   1                                    |   0         |   Period after a password is changed during which a password cannot be changed again, in days.                                                |
|   PASSWORD_MAX_AGE_DAYS           |   30                                   |   90        |   Period after which password must be changed, in days.                                                                                       |
|   PASSWORD_MAX_RETRIES            |   5                                    |   5         |   Number of attempts users have to enter the correct password before their account is locked.                                                 |
|   PASSWORD_LOCKOUT_TIME_MINS      |   30                                   |   15        |   Period of time for which users will be locked after entering their password incorrectly many times (specified by MAX_RETRIES), in minutes   |
|   PASSWORD_HISTORY                |   5                                    |   24        |   Number of most recent passwords that may not be repeated by the user                                                                        |
+-----------------------------------+----------------------------------------+-------------+-----------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 19012
{ DESC | DESCRIBE } PRIVACY POLICY <name>

-- Example 19013
DESCRIBE PRIVACY POLICY myprivpolicy;

-- Example 19014
+--------------------+---------------+--------------------+-----------------------------------------------+
|   name             |   signature   |   return_type      |   body                                        |
+--------------------+---------------+--------------------+-----------------------------------------------+
|   MYPRIVPOLICY     |   ()          |   PRIVACY_BUDGET   |   PRIVACY_BUDGET(BUDGET_NAME=>'new_budget')   |
+--------------------+---------------+--------------------+-----------------------------------------------+

-- Example 19015
DESC[RIBE] ROW ACCESS POLICY <name>;

-- Example 19016
DESC ROW ACCESS POLICY rap_table_employee_info;

-- Example 19017
+-------------------------+-------------+-------------+------+
| name                    |  signature  | return_type | body |
+-------------------------+-------------+-------------+------+
| RAP_TABLE_EMPLOYEE_INFO | (V VARCHAR) | BOOLEAN     | true |
+-------------------------+-------------+-------------+------+

-- Example 19018
DESC[RIBE] SCHEMA <schema_name>

-- Example 19019
CREATE SCHEMA sample_schema_2;
USE SCHEMA sample_schema_2;

CREATE TABLE sample_table_1 (i INTEGER);

CREATE VIEW sample_view_1 AS
    SELECT i FROM sample_table_1;

CREATE MATERIALIZED VIEW sample_mview_1 AS
    SELECT i FROM sample_table_1 WHERE i < 100;

DESCRIBE SCHEMA sample_schema_2;

+-------------------------------+----------------+-------------------+
| created_on                    | name           | kind              |
|-------------------------------+----------------+-------------------|
| 2022-06-23 01:00:00.000 -0700 | SAMPLE_TABLE_1 | TABLE             |
| 2022-06-23 02:00:00.000 -0700 | SAMPLE_VIEW_1  | VIEW              |
| 2022-06-23 03:00:00.000 -0700 | SAMPLE_MVIEW_1 | MATERIALIZED_VIEW |
+-------------------------------+----------------+-------------------+

-- Example 19020
DESC[RIBE] SEARCH OPTIMIZATION ON <table_name>;

-- Example 19021
GRANT ADD SEARCH OPTIMIZATION ON SCHEMA <schema_name> TO ROLE <role>

-- Example 19022
ALTER TABLE <name> ADD SEARCH OPTIMIZATION
  ON FULL_TEXT( { * | <col1> [ , <col2>, ... ] } [ , ANALYZER => '<analyzer_name>' ]);

-- Example 19023
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 19024
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 19025
+---------------+----------------------------+-----------+------------------+--------+
| expression_id | method                     | target    | target_data_type | active |
|---------------+----------------------------+-----------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | PLAY      | VARCHAR(50)      | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | CHARACTER | VARCHAR(30)      | true   |
|             3 | FULL_TEXT DEFAULT_ANALYZER | LINE      | VARCHAR(2000)    | true   |
+---------------+----------------------------+-----------+------------------+--------+

-- Example 19026
ALTER TABLE ipt ADD SEARCH OPTIMIZATION ON FULL_TEXT(ip1, ANALYZER => 'ENTITY_ANALYZER');

-- Example 19027
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 19028
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON play, character, line;

-- Example 19029
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON 1, 2, 3;

-- Example 19030
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3);

-- Example 19031
-- This statement is equivalent to the previous statement.
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 19032
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(*);

-- Example 19033
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2), SUBSTRING(c3);

-- Example 19034
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), SUBSTRING(c1);

-- Example 19035
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c4:user.uuid);

-- Example 19036
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON GEO(c1);

-- Example 19037
ALTER TABLE test_table ADD SEARCH OPTIMIZATION;

-- Example 19038
SHOW TABLES LIKE '%test_table%';

-- Example 19039
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1);

-- Example 19040
DESCRIBE SEARCH OPTIMIZATION ON t1;

-- Example 19041
+---------------+----------+--------+------------------+--------+
| expression_id |  method  | target | target_data_type | active |
+---------------+----------+--------+------------------+--------+
| 1             | EQUALITY | C1     | NUMBER(38,0)     | true   |
+---------------+----------+--------+------------------+--------+

-- Example 19042
DESCRIBE SEARCH OPTIMIZATION ON t1;

-- Example 19043
+---------------+-----------+-----------+-------------------+--------+
| expression_id |  method   | target    | target_data_type  | active |
+---------------+-----------+-----------+-------------------+--------+
|             1 | EQUALITY  | C1        | NUMBER(38,0)      | true   |
|             2 | EQUALITY  | C2        | VARCHAR(16777216) | true   |
|             3 | EQUALITY  | C4        | NUMBER(38,0)      | true   |
|             4 | EQUALITY  | C5        | VARCHAR(16777216) | true   |
|             5 | EQUALITY  | V1        | VARIANT           | true   |
|             6 | SUBSTRING | C2        | VARCHAR(16777216) | true   |
|             7 | SUBSTRING | C5        | VARCHAR(16777216) | true   |
|             8 | GEO       | G1        | GEOGRAPHY         | true   |
|             9 | EQUALITY  | V1:"key1" | VARIANT           | true   |
|            10 | EQUALITY  | V1:"key2" | VARIANT           | true   |
+---------------+-----------+-----------+-------------------+--------+

-- Example 19044
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON SUBSTRING(c2);

-- Example 19045
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON c5;

-- Example 19046
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON EQUALITY(c1), 6, 8;

-- Example 19047
ALTER TABLE [IF EXISTS] <table_name> DROP SEARCH OPTIMIZATION;

-- Example 19048
ALTER TABLE test_table DROP SEARCH OPTIMIZATION;

-- Example 19049
{ DESC | DESCRIBE } SECRET <name>

-- Example 19050
DESC SECRET service_now_creds_pw;

-- Example 19051
{ DESCRIBE | DESC } SEMANTIC VIEW <name>

-- Example 19052
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+
| object_kind  | object_name                  | parent_entity | property                 | property_value                         |
|--------------+------------------------------+---------------+--------------------------+----------------------------------------|
| NULL         | NULL                         | NULL          | COMMENT                  | Comment about the semantic view        |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| ...          | ...                          | ...           | ...                      | ...                                    |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | TABLE                    | CUSTOMERS                              |
| ...          | ...                          | ...           | ...                      | ...                                    |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| ...          | ...                          | ...           | ...                      | ...                                    |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| ...          | ...                          | ...           | ...                      | ...                                    |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | TABLE                    | ORDERS                                 |
| ...          | ...                          | ...           | ...                      | ...                                    |
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+

-- Example 19053
DESC SEMANTIC VIEW tpch_rev_analysis;

-- Example 19054
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+
| object_kind  | object_name                  | parent_entity | property                 | property_value                         |
|--------------+------------------------------+---------------+--------------------------+----------------------------------------|
| NULL         | NULL                         | NULL          | COMMENT                  | Comment about the semantic view        |
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

-- Example 19055
DESC[RIBE] SEQUENCE <name>

-- Example 19056
DESC SEQUENCE my_sequence;

-- Example 19057
{ DESCRIBE | DESC } SESSION POLICY <name>

-- Example 19058
DESC SESSION POLICY session_policy_prod_1;

-- Example 19059
+---------------------------------+-----------------------+---------------------------+------------------------------+-------------------------+--------------------------------------------------+
| created_on                       | name                 | session_idle_timeout_mins | session_ui_idle_timeout_mins | allowed_secondary_roles |  comment                                         |
+---------------------------------+-----------------------+---------------------------+------------------------------+-------------------------+--------------------------------------------------+
| Mon, 11 Jan 2021 00:00:00 -0700 | session_policy_prod_1 | 60                        | 30                           |           []            | session policy for use in the prod_1 environment |
+---------------------------------+-----------------------+---------------------------+------------------------------+-------------------------+--------------------------------------------------+

-- Example 19060
DESC[RIBE] SHARE <name>

-- Example 19061
DESC[RIBE] SHARE <provider_account>.<share_name>

-- Example 19062
DESC SHARE sales_s;

+----------+--------------------------------------+-------------------------------+
| kind     | name                                 | shared_on                     |
|----------+--------------------------------------+-------------------------------|
| DATABASE | SALES_DB                             | 2017-06-15 17:03:16.642 -0700 |
| SCHEMA   | SALES_DB.AGGREGATES_EULA             | 2017-06-15 17:03:16.790 -0700 |
| TABLE    | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | 2017-06-15 17:03:16.963 -0700 |
+----------+--------------------------------------+-------------------------------+

-- Example 19063
DESC SHARE ab67890.sales_s;

+----------+----------------------------------+---------------------------------+
| kind     | name                             | shared_on                       |
|----------+----------------------------------+---------------------------------|
| DATABASE | <DB>                             | Thu, 15 Jun 2017 17:03:16 -0700 |
| SCHEMA   | <DB>.AGGREGATES_EULA             | Thu, 15 Jun 2017 17:03:16 -0700 |
| TABLE    | <DB>.AGGREGATES_EULA.AGGREGATE_1 | Thu, 15 Jun 2017 17:03:16 -0700 |
+----------+----------------------------------+---------------------------------+

-- Example 19064
DESC[RIBE] STAGE <name>

-- Example 19065
DESC STAGE my_s3_stage;
+--------------------+--------------------------------+---------------+-------------------------------------------------------+------------------+
| parent_property    | property                       | property_type | property_value                                        | property_default |
|--------------------+--------------------------------+---------------+-------------------------------------------------------+------------------|
| STAGE_FILE_FORMAT  | TYPE                           | String        | CSV                                                   | CSV              |
| STAGE_FILE_FORMAT  | RECORD_DELIMITER               | String        | \n                                                    | \n               |
| STAGE_FILE_FORMAT  | FIELD_DELIMITER                | String        | ,                                                     | ,                |
| STAGE_FILE_FORMAT  | FILE_EXTENSION                 | String        |                                                       |                  |
| STAGE_FILE_FORMAT  | SKIP_HEADER                    | Integer       | 0                                                     | 0                |
| STAGE_FILE_FORMAT  | DATE_FORMAT                    | String        | AUTO                                                  | AUTO             |
| STAGE_FILE_FORMAT  | TIME_FORMAT                    | String        | AUTO                                                  | AUTO             |
| STAGE_FILE_FORMAT  | TIMESTAMP_FORMAT               | String        | AUTO                                                  | AUTO             |
| STAGE_FILE_FORMAT  | BINARY_FORMAT                  | String        | HEX                                                   | HEX              |
| STAGE_FILE_FORMAT  | ESCAPE                         | String        | NONE                                                  | NONE             |
| STAGE_FILE_FORMAT  | ESCAPE_UNENCLOSED_FIELD        | String        | \\                                                    | \\               |
| STAGE_FILE_FORMAT  | TRIM_SPACE                     | Boolean       | false                                                 | false            |
| STAGE_FILE_FORMAT  | FIELD_OPTIONALLY_ENCLOSED_BY   | String        | NONE                                                  | NONE             |
| STAGE_FILE_FORMAT  | NULL_IF                        | List          | [\\N]                                                 | [\\N]            |
| STAGE_FILE_FORMAT  | COMPRESSION                    | String        | AUTO                                                  | AUTO             |
| STAGE_FILE_FORMAT  | ERROR_ON_COLUMN_COUNT_MISMATCH | Boolean       | true                                                  | true             |
| STAGE_FILE_FORMAT  | VALIDATE_UTF8                  | Boolean       | true                                                  | true             |
| STAGE_FILE_FORMAT  | SKIP_BLANK_LINES               | Boolean       | false                                                 | false            |
| STAGE_FILE_FORMAT  | REPLACE_INVALID_CHARACTERS     | Boolean       | false                                                 | false            |
| STAGE_FILE_FORMAT  | EMPTY_FIELD_AS_NULL            | Boolean       | true                                                  | true             |
| STAGE_FILE_FORMAT  | SKIP_BYTE_ORDER_MARK           | Boolean       | true                                                  | true             |
| STAGE_FILE_FORMAT  | ENCODING                       | String        | UTF8                                                  | UTF8             |
| STAGE_COPY_OPTIONS | ON_ERROR                       | String        | ABORT_STATEMENT                                       | ABORT_STATEMENT  |
| STAGE_COPY_OPTIONS | SIZE_LIMIT                     | Long          |                                                       |                  |
| STAGE_COPY_OPTIONS | PURGE                          | Boolean       | false                                                 | false            |
| STAGE_COPY_OPTIONS | RETURN_FAILED_ONLY             | Boolean       | false                                                 | false            |
| STAGE_COPY_OPTIONS | ENFORCE_LENGTH                 | Boolean       | true                                                  | true             |
| STAGE_COPY_OPTIONS | TRUNCATECOLUMNS                | Boolean       | false                                                 | false            |
| STAGE_COPY_OPTIONS | FORCE                          | Boolean       | false                                                 | false            |
| STAGE_LOCATION     | URL                            | String        | ["s3://EXAMPLE-S3-PATH/my-csvfiles/"] |                  |
| STAGE_CREDENTIALS  | AWS_KEY_ID                     | String        |                                                       |                  |
| DIRECTORY          | LAST_REFRESHED_ON              | Timestamp     | 2023-05-03 12:50:28.000 -0700                         |                  |
| DIRECTORY          | ENABLE                         | Boolean       | true                                                  | false            |
| DIRECTORY          | AUTO_REFRESH                   | Boolean       | false                                                 | false            |
+--------------------+--------------------------------+---------------+-------------------------------------------------------+------------------+

-- Example 19066
DESC[RIBE] STREAMLIT <name>

-- Example 19067
DESC[RIBE] TASK <name>

-- Example 19068
CREATE TASK mytask ( ... );

-- Example 19069
DESC TASK mytask;

-- Example 19070
{ DESC | DESCRIBE } TRANSACTION <transaction_id>

-- Example 19071
DESC TRANSACTION 1651535571261000000;

-- Example 19072
DESC[RIBE] WAREHOUSE <name>

