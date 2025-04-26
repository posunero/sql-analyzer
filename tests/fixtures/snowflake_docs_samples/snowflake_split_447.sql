-- Example 29921
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #"
           ALL ROWS PER MATCH
           PATTERN (MINIMUM_37 UP UP)
           DEFINE
               MINIMUM_37 AS price >= 37.00,
               UP AS price > LAG(price)
           )
    ORDER BY company, "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # |
|---------+------------+-------+---------+------------------|
| ABCD    | 2020-10-06 |    47 |       1 |                1 |
| ABCD    | 2020-10-07 |    71 |       1 |                2 |
| ABCD    | 2020-10-08 |    80 |       1 |                3 |
| XYZ     | 2020-10-03 |    37 |       1 |                1 |
| XYZ     | 2020-10-04 |    63 |       1 |                2 |
| XYZ     | 2020-10-05 |    65 |       1 |                3 |
+---------+------------+-------+---------+------------------+

-- Example 29922
select * from stock_price_history match_recognize(
        partition by company
        order by price_date
        measures
            match_number() as "MATCH_NUMBER",
            first(price_date) as "START",
            last(price_date) as "END",
            count(up.price) as ups,
            count(*) as "PRICE_COUNT",
            last(classifier()) = 'DOWN' up_spike
        after match skip to next row
        pattern(ANY_ROW PERMUTE(UP{2}, DOWN+))
        define
            ANY_ROW AS TRUE,
            UP as price > lag(price),
            DOWN as price < lag(price)
    )
    order by company, match_number;
+---------+--------------+------------+------------+-----+-------------+----------+
| COMPANY | MATCH_NUMBER | START      | END        | UPS | PRICE_COUNT | UP_SPIKE |
|---------+--------------+------------+------------+-----+-------------+----------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |   2 |           4 | False    |
| ABCD    |            2 | 2020-10-02 | 2020-10-05 |   2 |           4 | True     |
| ABCD    |            3 | 2020-10-04 | 2020-10-07 |   2 |           4 | False    |
| ABCD    |            4 | 2020-10-06 | 2020-10-10 |   2 |           5 | True     |
| XYZ     |            1 | 2020-10-01 | 2020-10-04 |   2 |           4 | False    |
| XYZ     |            2 | 2020-10-03 | 2020-10-07 |   2 |           5 | True     |
+---------+--------------+------------+------------+-----+-------------+----------+

-- Example 29923
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        first(price_date) as "START",
        last(price_date) as "END",
        count(*) as "PRICE_COUNT"
    after match skip to next row
    pattern(ANY_ROW DOWN+ UP+ DOWN+ UP+)
    define
        ANY_ROW AS TRUE,
        UP as price > lag(price),
        DOWN as price < lag(price)
)
order by company, match_number;
+---------+--------------+------------+------------+-------------+
| COMPANY | MATCH_NUMBER | START      | END        | PRICE_COUNT |
|---------+--------------+------------+------------+-------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-08 |           8 |
| XYZ     |            1 | 2020-10-01 | 2020-10-08 |           8 |
| XYZ     |            2 | 2020-10-05 | 2020-10-10 |           6 |
| XYZ     |            3 | 2020-10-06 | 2020-10-10 |           5 |
+---------+--------------+------------+------------+-------------+

-- Example 29924
select * from stock_price_history match_recognize(
        partition by company
        order by price_date
        measures
            match_number() as "MATCH_NUMBER",
            classifier as cl,
            count(*) as "PRICE_COUNT"
        all rows per match
        pattern(ANY_ROW {- DOWN+ -} UP+ {- DOWN+ -} UP+)
        define
            ANY_ROW AS TRUE,
            UP as price > lag(price),
            DOWN as price < lag(price)
    )
    order by company, price_date;
+---------+------------+-------+--------------+---------+-------------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER | CL      | PRICE_COUNT |
|---------+------------+-------+--------------+---------+-------------|
| ABCD    | 2020-10-01 |    50 |            1 | ANY_ROW |           1 |
| ABCD    | 2020-10-03 |    39 |            1 | UP      |           3 |
| ABCD    | 2020-10-04 |    42 |            1 | UP      |           4 |
| ABCD    | 2020-10-06 |    47 |            1 | UP      |           6 |
| ABCD    | 2020-10-07 |    71 |            1 | UP      |           7 |
| ABCD    | 2020-10-08 |    80 |            1 | UP      |           8 |
| XYZ     | 2020-10-01 |    89 |            1 | ANY_ROW |           1 |
| XYZ     | 2020-10-03 |    37 |            1 | UP      |           3 |
| XYZ     | 2020-10-04 |    63 |            1 | UP      |           4 |
| XYZ     | 2020-10-05 |    65 |            1 | UP      |           5 |
| XYZ     | 2020-10-08 |    54 |            1 | UP      |           8 |
+---------+------------+-------+--------------+---------+-------------+

-- Example 29925
MATCH_RECOGNIZE (
    ...
    ORDER BY log_message_timestamp
    ...
    ALL ROWS PER MATCH
    PATTERN ( WARNING1  {- ANY_ROW* -}  WARNING2  {- ANY_ROW* -}  FATAL_ERROR )
    DEFINE
        ANY_ROW AS TRUE,
        WARNING1 AS SUBSTR(log_message, 1, 42) = 'WARNING: Available memory is less than 10%',
        WARNING2 AS SUBSTR(log_message, 1, 41) = 'WARNING: Available memory is less than 5%',
        FATAL_ERROR AS SUBSTR(log_message, 1, 11) = 'FATAL ERROR'
    )
...

-- Example 29926
CREATE ICEBERG TABLE myIcebergTable
  EXTERNAL_VOLUME='icebergMetadataVolume'
  CATALOG='icebergCatalogInt'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 29927
ALTER ICEBERG TABLE myIcebergTable REFRESH 'metadata/v2.metadata.json';

-- Example 29928
ALTER ICEBERG TABLE myIcebergTable CONVERT TO MANAGED
  BASE_LOCATION = 'my/relative/path/from/external_volume';

-- Example 29929
SHOW REPLICATION GROUPS [ IN ACCOUNT <account> ]

-- Example 29930
SHOW REPLICATION GROUPS IN ACCOUNT myaccount1;

+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| snowflake_region | created_on                    | account_name | name | type     | comment | is_primary | primary               | object_types                                | allowed_integration_types | allowed_accounts                             | organization_name | account_locator   | replication_schedule | secondary_state | next_scheduled_refresh        | owner   | is_listing_auto_fulfillment_group |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| AWS_US_EAST_1    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT1   | MYFG | FAILOVER |         | true       | MYORG.MYACCOUNT1.MYFG | DATABASES, ROLES, USERS, WAREHOUSES, SHARES |                           | MYORG.MYACCOUNT1.MYFG,MYORG.MYACCOUNT2.MYFG  | MYORG             | MYACCOUNT1LOCATOR | 10 MINUTE            |                 |                               | MYROLE  | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| AWS_US_WEST_2    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT2   | MYFG | FAILOVER |         | false      | MYORG.MYACCOUNT1.MYFG |                                             |                           |                                              | MYORG             | MYACCOUNT2LOCATOR | 10 MINUTE            | STARTED         | 2022-03-06 12:10:35.280 -0800 | NULL    | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+

-- Example 29931
GRANT MANAGE USER SUPPORT CASES ON ACCOUNT TO ROLE myrole;

-- Example 29932
CREATE OR REPLACE CATALOG INTEGRATION open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE= 'myOpenCatalogNamespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://<orgname>-<my-snowflake-open-catalog-account-name>.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'myOpenCatalogName'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my-client-id'
    OAUTH_CLIENT_SECRET = 'my-client-secret'
    OAUTH_ALLOWED_SCOPES = ( 'PRINCIPAL_ROLE:ALL' )
  )
  ENABLED = TRUE;

-- Example 29933
CREATE ICEBERG TABLE open_catalog_iceberg_table
  CATALOG = 'open_catalog_int'
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG_TABLE_NAME = 'my_iceberg_table';

-- Example 29934
SELECT id, date
  FROM open_catalog_iceberg_table
  LIMIT 10;

-- Example 29935
CREATE [ OR REPLACE ] ICEBERG TABLE [ IF NOT EXISTS ] <table_name>
  [ EXTERNAL_VOLUME = '<external_volume_name>' ]
  [ CATALOG = '<catalog_integration_name>' ]
  CATALOG_TABLE_NAME = '<rest_catalog_table_name>'
  [ CATALOG_NAMESPACE = '<catalog_namespace>' ]
  [ REPLACE_INVALID_CHARACTERS = { TRUE | FALSE } ]
  [ AUTO_REFRESH = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 29936
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'my_rest_catalog_integration'
  CATALOG_TABLE_NAME = 'my_remote_table';

-- Example 29937
CREATE ICEBERG TABLE open_catalog_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'open_catalog_int'
  CATALOG_TABLE_NAME = 'my_open_catalog_table';

-- Example 29938
CREATE EXTERNAL LISTING SHARED_WITH_ANOTHER_ACCOUNT
SHARE MySHARE AS
$$
   title: "weather data"
   description: "Listing of weather data for all zipcodes in America"
   listing_terms:
     type: "OFFLINE"
   targets:
     accounts: ["targetorg.targetaccount"]
$$ PUBLISH=TRUE REVIEW=TRUE;

-- Example 29939
CREATE EXTERNAL LISTING SHARED_AND_REPLICATED
SHARE MySHARE AS
$$
   title: "weather data"
   description: "Listing containing weather data for all zipcodes in America"
   listing_terms:
     type: “OFFLINE”
   targets:
     accounts: [“targetorg.targetaccount”]
   auto_fulfillment:
     refresh_type: SUB_DATABASE
     refresh_schedule: '10 MINUTE'
$$;

-- Example 29940
CREATE EXTERNAL LISTING PUB_SHARE_AND_REPLICATE
SHARE MySHARE AS
$$
 title: "Weather Data"
 subtitle: "Weather Data on Snowflake"
 description: "This listing contains weather data for all zipcodes in America"
 terms_of_service:
   type: "STANDARD"
 targets:
   regions: ["PUBLIC.US_WEST", "PUBLIC.AWS_US_EAST_1"]
 auto_fulfillment:
   refresh_schedule: "10 MINUTE"
   refresh_type: "SUB_DATABASE"
 profile: "VERY_STARK_INDUSTRIES_PUBLIC_PROFILE"
 categories: ["BUSINESS"]
 data_dictionary:
   featured:
     database: "DATABASE_NAME"
     objects:
       - schema: "SCHEMA_NAME"
         domain: TABLE
         name: "TABLE_NAME"
 business_needs:
   - name: "Data Quality and Cleansing"
     description: "Test listing for data cleansing"
 usage_examples:
   - title: "Aggregate Weather data for a location"
     description: "Calculate the minimum and maximum temperatures over a year"
     query: "SELECT 1"
 data_attributes:
   refresh_rate: "HOURLY"
   geography:
     geo_option: "NOT_APPLICABLE"
 resources:
   documentation: "https://snowflake.com/doc"
   media: "https://www.youtube.com/watch?v=AR88dZG-hwo"
 $$;

-- Example 29941
CREATE EXTERNAL LISTING DRAFT_PRIVATE_REPLICATED
SHARE MySHARE AS
$$
   title: "weather data"
   description: "Listing containing weather data for all zipcodes in America"
   listing_terms:
     type: “OFFLINE”
   targets:
     accounts: [“targetorg.targetaccount”]
   auto_fulfillment:
     refresh_type: SUB_DATABASE
     refresh_schedule: '10 MINUTE'
$$ PUBLISH=FALSE REVIEW=FALSE;

-- Example 29942
snow object describe
  <object_type>
  <object_name>
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

-- Example 29943
snow object describe function "hello_function(string)"

-- Example 29944
describe function hello_function(string)
+---------------------------------------------------------------------
| property           | value
|--------------------+------------------------------------------------
| signature          | (NAME VARCHAR)
| returns            | VARCHAR(16777216)
| language           | PYTHON
| null handling      | CALLED ON NULL INPUT
| volatility         | VOLATILE
| body               | None
| imports            |
| handler            | functions.hello_function
| runtime_version    | 3.9
| packages           | ['snowflake-snowpark-python']
| installed_packages | ['_libgcc_mutex==0.1','_openmp_mutex==5.1',...
+---------------------------------------------------------------------

-- Example 29945
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 29946
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(line, ANALYZER => 'UNICODE_ANALYZER');

-- Example 29947
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 29948
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 29949
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(line);

-- Example 29950
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 29951
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | LINE   | VARCHAR(2000)    | false  |
+---------------+----------------------------+--------+------------------+--------+

-- Example 29952
ALTER TABLE car_sales ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(src);

DESCRIBE SEARCH OPTIMIZATION ON car_sales;

-- Example 29953
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | SRC    | VARIANT          | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 29954
CREATE OR REPLACE TABLE so_object_example (object_column OBJECT);

INSERT INTO so_object_example (object_column)
  SELECT OBJECT_CONSTRUCT('a', 1::VARIANT, 'b', 2::VARIANT);

-- Example 29955
ALTER TABLE so_object_example ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(object_column);

DESCRIBE SEARCH OPTIMIZATION ON so_object_example;

-- Example 29956
+---------------+----------------------------+---------------+------------------+--------+
| expression_id | method                     | target        | target_data_type | active |
|---------------+----------------------------+---------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | OBJECT_COLUMN | OBJECT           | true   |
+---------------+----------------------------+---------------+------------------+--------+

-- Example 29957
CREATE OR REPLACE TABLE so_array_example (array_column ARRAY);

INSERT INTO so_array_example (array_column)
  SELECT ARRAY_CONSTRUCT('a', 'b', 'c');

-- Example 29958
ALTER TABLE so_array_example ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(array_column);

DESCRIBE SEARCH OPTIMIZATION ON so_array_example;

-- Example 29959
+---------------+----------------------------+--------------+------------------+--------+
| expression_id | method                     | target       | target_data_type | active |
|---------------+----------------------------+--------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | ARRAY_COLUMN | ARRAY            | true   |
+---------------+----------------------------+--------------+------------------+--------+

-- Example 29960
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, act_scene_line, character, line, ANALYZER => 'UNICODE_ANALYZER');

DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 29961
+---------------+----------------------------+----------------+------------------+--------+
| expression_id | method                     | target         | target_data_type | active |
|---------------+----------------------------+----------------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | PLAY           | VARCHAR(50)      | true   |
|             2 | FULL_TEXT UNICODE_ANALYZER | ACT_SCENE_LINE | VARCHAR(10)      | true   |
|             3 | FULL_TEXT UNICODE_ANALYZER | CHARACTER      | VARCHAR(30)      | true   |
|             4 | FULL_TEXT UNICODE_ANALYZER | LINE           | VARCHAR(2000)    | true   |
+---------------+----------------------------+----------------+------------------+--------+

-- Example 29962
ALTER TABLE lines DROP SEARCH OPTIMIZATION ON 1, 2, 3;

-- Example 29963
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 29964
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             4 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 29965
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(*);

-- Example 29966
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 29967
+---------------+----------------------------+----------------+------------------+--------+
| expression_id | method                     | target         | target_data_type | active |
|---------------+----------------------------+----------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | PLAY           | VARCHAR(50)      | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | ACT_SCENE_LINE | VARCHAR(10)      | true   |
|             3 | FULL_TEXT DEFAULT_ANALYZER | CHARACTER      | VARCHAR(30)      | true   |
|             4 | FULL_TEXT DEFAULT_ANALYZER | LINE           | VARCHAR(2000)    | true   |
+---------------+----------------------------+----------------+------------------+--------+

-- Example 29968
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, speech_num, act_scene_line, character, line);

-- Example 29969
001128 (42601): SQL compilation error: error line 1 at position 76
Expression FULL_TEXT(IDX_SRC_TABLE.SPEECH_NUM) cannot be used in search optimization.

-- Example 29970
SHOW [ TERSE ] TASKS [ LIKE '<pattern>' ]
                     [ IN { ACCOUNT | DATABASE [ <db_name> ] | [ SCHEMA ] [ <schema_name> ] | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]
                     [ STARTS WITH '<name_string>' ]
                     [ ROOT ONLY ]
                     [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 29971
SHOW TASKS LIKE 'line%' IN tpch.public;

-- Example 29972
SHOW TASKS IN tpch.public;

-- Example 29973
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
  <name>
  TYPE = OAUTH
  ENABLED = { TRUE | FALSE }
  OAUTH_CLIENT = <partner_application>
  oauthClientParams
  [ COMMENT = '<string_literal>' ]

-- Example 29974
oauthClientParams ::=
  [ OAUTH_ISSUE_REFRESH_TOKENS = TRUE | FALSE ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ BLOCKED_ROLES_LIST = ('<role_name>', '<role_name>') ]

-- Example 29975
CREATE SECURITY INTEGRATION td_oauth_int1
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_DESKTOP;

-- Example 29976
DESC SECURITY INTEGRATION td_oauth_int1;

-- Example 29977
CREATE SECURITY INTEGRATION td_oauth_int2
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 36000
  BLOCKED_ROLES_LIST = ('SYSADMIN')
  OAUTH_CLIENT = TABLEAU_DESKTOP;

-- Example 29978
CREATE SECURITY INTEGRATION ts_oauth_int1
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_SERVER;

-- Example 29979
DESC SECURITY INTEGRATION ts_oauth_int1;

-- Example 29980
CREATE SECURITY INTEGRATION ts_oauth_int2
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = TABLEAU_SERVER
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  BLOCKED_ROLES_LIST = ('SYSADMIN');

-- Example 29981
SHOW DELEGATED AUTHORIZATIONS;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
|-------------------------------+-----------+-----------+-------------------+--------------------|
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT      | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 29982
SHOW DELEGATED AUTHORIZATIONS
    BY USER <username>;

-- Example 29983
SHOW DELEGATED AUTHORIZATIONS
    TO SECURITY INTEGRATION <integration_name>;

-- Example 29984
ALTER USER <username> REMOVE DELEGATED AUTHORIZATIONS
    FROM SECURITY INTEGRATION <integration_name>

-- Example 29985
ALTER USER <username> REMOVE DELEGATED AUTHORIZATION
    OF ROLE <role_name>
    FROM SECURITY INTEGRATION <integration_name>

-- Example 29986
<model_name>!SHOW_TRAINING_LOGS();

-- Example 29987
Unknown user-defined function SNOWFLAKE.LOCAL.ACTIVATE

