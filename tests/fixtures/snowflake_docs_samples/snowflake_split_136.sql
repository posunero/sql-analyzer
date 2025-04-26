-- Example 9093
LIST @%mytable;

-- Example 9094
LIST @mystage/path1;

-- Example 9095
LIST @%mytable PATTERN='.*data_0.*';

-- Example 9096
LIST @my_csv_stage/analysis/ PATTERN='.*data_0.*';

-- Example 9097
LS @~;

-- Example 9098
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY | VOLATILE } ] FILE FORMAT [ IF NOT EXISTS ] <name>
  [ TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM} [ formatTypeOptions ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 9099
formatTypeOptions ::=
-- If TYPE = CSV
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
     FILE_EXTENSION = '<string>'
     PARSE_HEADER = TRUE | FALSE
     SKIP_HEADER = <integer>
     SKIP_BLANK_LINES = TRUE | FALSE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     ESCAPE = '<character>' | NONE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     TRIM_SPACE = TRUE | FALSE
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If TYPE = JSON
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     FILE_EXTENSION = '<string>'
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If TYPE = AVRO
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = ORC
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = PARQUET
     COMPRESSION = AUTO | LZO | SNAPPY | NONE
     SNAPPY_COMPRESSION = TRUE | FALSE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = XML
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 9100
CREATE OR ALTER [ { TEMP | TEMPORARY | VOLATILE } ] FILE FORMAT <name>
  [ TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] ]
  [ COMMENT = '<string_literal>' ]

-- Example 9101
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 9102
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 9103
"person":
 {
  "name": "Adam",
  "nickname": null,
  "age": 34,
  "phone_numbers":
  [
    "1234567890",
    "0987654321",
    null,
    "6781234590"
  ]
  }

-- Example 9104
"my_map":
 {
  "key_value":
  [
   {
          "key": "k1",
          "value": "v1"
      },
      {
          "key": "k2",
          "value": "v2"
      }
    ]
  }

-- Example 9105
"person":
 {
  "name": "Adam",
  "age": 34
  "phone_numbers":
  [
   "1234567890",
   "0987654321",
   "6781234590"
  ]
 }

-- Example 9106
CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = CSV
  COMMENT = 'my_file_format';

-- Example 9107
CREATE OR ALTER FILE FORMAT my_csv_format
  TYPE = CSV
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null')
  EMPTY_FIELD_AS_NULL = true
  COMPRESSION = gzip;

-- Example 9108
CREATE OR REPLACE FILE FORMAT my_json_format
  TYPE = JSON;

-- Example 9109
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  COMPRESSION = SNAPPY;

-- Example 9110
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_LOGICAL_TYPE = TRUE;

-- Example 9111
copy into home_sales(city, zip, sale_date, price)
   from (select t.$1, t.$2, t.$6, t.$7 from @mystage/sales.csv.gz t)
   FILE_FORMAT = (FORMAT_NAME = mycsvformat);

-- Example 9112
copy into home_sales(city, zip, sale_date, price)
   from (select SUBSTR(t.$2,4), t.$1, t.$5, t.$4 from @mystage t)
   FILE_FORMAT = (FORMAT_NAME = mycsvformat);

-- Example 9113
snowflake,2.8,2016-10-5
warehouse,-12.3,2017-01-23

-- Example 9114
-- Stage a data file in the internal user stage
PUT file:///tmp/datafile.csv @~;

-- Query the staged data file
select t.$1,t.$2,t.$3 from @~/datafile.csv.gz t;

-- Create the target table
create or replace table casttb (
  col1 binary,
  col2 decimal,
  col3 timestamp_ntz
  );

-- Convert the staged CSV column data to the specified data types before loading it into the destination table
copy into casttb(col1, col2, col3)
from (
  select to_binary(t.$1, 'utf-8'),to_decimal(t.$2, '99.9', 9, 5),to_timestamp_ntz(t.$3)
  from @~/datafile.csv.gz t
)
file_format = (type = csv);

-- Query the target table
select * from casttb;

+--------------------+------+-------------------------+
| COL1               | COL2 | COL3                    |
|--------------------+------+-------------------------|
| 736E6F77666C616B65 |    3 | 2016-10-05 00:00:00.000 |
| 77617265686F757365 |  -12 | 2017-01-23 00:00:00.000 |
+--------------------+------+-------------------------+

-- Example 9115
-- Create a sequence
create sequence seq1;

-- Create the target table
create or replace table mytable (
  col1 number default seq1.nextval,
  col2 varchar,
  col3 varchar
  );

-- Stage a data file in the internal user stage
PUT file:///tmp/myfile.csv @~;

-- Query the staged data file
select $1, $2 from @~/myfile.csv.gz t;

+-----+-----+
| $1  | $2  |
|-----+-----|
| abc | def |
| ghi | jkl |
| mno | pqr |
| stu | vwx |
+-----+-----+

-- Include the sequence nextval expression in the COPY statement
copy into mytable (col1, col2, col3)
from (
  select seq1.nextval, $1, $2
  from @~/myfile.csv.gz t
)
;

select * from mytable;

+------+------+------+
| COL1 | COL2 | COL3 |
|------+------+------|
|    1 | abc  | def  |
|    2 | ghi  | jkl  |
|    3 | mno  | pqr  |
|    4 | stu  | vwx  |
+------+------+------+

-- Example 9116
-- Create the target table
create or replace table mytable (
  col1 number autoincrement start 1 increment 1,
  col2 varchar,
  col3 varchar
  );

-- Stage a data file in the internal user stage
PUT file:///tmp/myfile.csv @~;

-- Query the staged data file
select $1, $2 from @~/myfile.csv.gz t;

+-----+-----+
| $1  | $2  |
|-----+-----|
| abc | def |
| ghi | jkl |
| mno | pqr |
| stu | vwx |
+-----+-----+

-- Omit the sequence column in the COPY statement
copy into mytable (col2, col3)
from (
  select $1, $2
  from @~/myfile.csv.gz t
)
;

select * from mytable;

+------+------+------+
| COL1 | COL2 | COL3 |
|------+------+------|
|    1 | abc  | def  |
|    2 | ghi  | jkl  |
|    3 | mno  | pqr  |
|    4 | stu  | vwx  |
+------+------+------+

-- Example 9117
-- Sample data:
{"location": {"city": "Lexington","zip": "40503"},"dimensions": {"sq_ft": "1000"},"type": "Residential","sale_date": "4-25-16","price": "75836"},
{"location": {"city": "Belmont","zip": "02478"},"dimensions": {"sq_ft": "1103"},"type": "Residential","sale_date": "6-18-16","price": "92567"},
{"location": {"city": "Winchester","zip": "01890"},"dimensions": {"sq_ft": "1122"},"type": "Condo","sale_date": "1-31-16","price": "89921"}

-- Example 9118
-- Create an internal stage with the file type set as JSON.
 CREATE OR REPLACE STAGE mystage
   FILE_FORMAT = (TYPE = 'json');

 -- Stage a JSON data file in the internal stage.
 PUT file:///tmp/sales.json @mystage;

 -- Query the staged data. The data file comprises three objects in NDJSON format.
 SELECT t.$1 FROM @mystage/sales.json.gz t;

 +------------------------------+
 | $1                           |
 |------------------------------|
 | {                            |
 |   "dimensions": {            |
 |     "sq_ft": "1000"          |
 |   },                         |
 |   "location": {              |
 |     "city": "Lexington",     |
 |     "zip": "40503"           |
 |   },                         |
 |   "price": "75836",          |
 |   "sale_date": "2022-08-25", |
 |   "type": "Residential"      |
 | }                            |
 | {                            |
 |   "dimensions": {            |
 |     "sq_ft": "1103"          |
 |   },                         |
 |   "location": {              |
 |     "city": "Belmont",       |
 |     "zip": "02478"           |
 |   },                         |
 |   "price": "92567",          |
 |   "sale_date": "2022-09-18", |
 |   "type": "Residential"      |
 | }                            |
 | {                            |
 |   "dimensions": {            |
 |     "sq_ft": "1122"          |
 |   },                         |
 |   "location": {              |
 |     "city": "Winchester",    |
 |     "zip": "01890"           |
 |   },                         |
 |   "price": "89921",          |
 |   "sale_date": "2022-09-23", |
 |   "type": "Condo"            |
 | }                            |
 +------------------------------+

 -- Create a target table for the data.
 CREATE OR REPLACE TABLE home_sales (
   CITY VARCHAR,
   POSTAL_CODE VARCHAR,
   SQ_FT NUMBER,
   SALE_DATE DATE,
   PRICE NUMBER
 );

 -- Copy elements from the staged file into the target table.
 COPY INTO home_sales(city, postal_code, sq_ft, sale_date, price)
 FROM (select
 $1:location.city::varchar,
 $1:location.zip::varchar,
 $1:dimensions.sq_ft::number,
 $1:sale_date::date,
 $1:price::number
 FROM @mystage/sales.json.gz t);

 -- Query the target table.
 SELECT * from home_sales;

+------------+-------------+-------+------------+-------+
| CITY       | POSTAL_CODE | SQ_FT | SALE_DATE  | PRICE |
|------------+-------------+-------+------------+-------|
| Lexington  | 40503       |  1000 | 2022-08-25 | 75836 |
| Belmont    | 02478       |  1103 | 2022-09-18 | 92567 |
| Winchester | 01890       |  1122 | 2022-09-23 | 89921 |
+------------+-------------+-------+------------+-------+

-- Example 9119
-- Create a file format object that sets the file format type. Accept the default options.
create or replace file format my_parquet_format
  type = 'parquet';

-- Create an internal stage and specify the new file format
create or replace temporary stage mystage
  file_format = my_parquet_format;

-- Create a target table for the data.
create or replace table parquet_col (
  custKey number default NULL,
  orderDate date default NULL,
  orderStatus varchar(100) default NULL,
  price varchar(255)
);

-- Stage a data file in the internal stage
put file:///tmp/mydata.parquet @mystage;

-- Copy data from elements in the staged Parquet file into separate columns
-- in the target table.
-- Note that all Parquet data is stored in a single column ($1)
-- SELECT list items correspond to element names in the Parquet file
-- Cast element values to the target column data type
copy into parquet_col
  from (select
  $1:o_custkey::number,
  $1:o_orderdate::date,
  $1:o_orderstatus::varchar,
  $1:o_totalprice::varchar
  from @mystage/mydata.parquet);

-- Query the target table
SELECT * from parquet_col;

+---------+------------+-------------+-----------+
| CUSTKEY | ORDERDATE  | ORDERSTATUS | PRICE     |
|---------+------------+-------------+-----------|
|   27676 | 1996-09-04 | O           | 83243.94  |
|  140252 | 1994-01-09 | F           | 198402.97 |
...
+---------+------------+-------------+-----------+

-- Example 9120
-- Create an internal stage with the file delimiter set as none and the record delimiter set as the new line character
create or replace stage mystage
  file_format = (type = 'json');

-- Stage a JSON data file in the internal stage with the default values
put file:///tmp/sales.json @mystage;

-- Create a table composed of the output from the FLATTEN function
create or replace table flattened_source
(seq string, key string, path string, index string, value variant, element variant)
as
  select
    seq::string
  , key::string
  , path::string
  , index::string
  , value::variant
  , this::variant
  from @mystage/sales.json.gz
    , table(flatten(input => parse_json($1)));

  select * from flattened_source;

+-----+-----------+-----------+-------+-------------------------+-----------------------------+
| SEQ | KEY       | PATH      | INDEX | VALUE                   | ELEMENT                     |
|-----+-----------+-----------+-------+-------------------------+-----------------------------|
| 1   | location  | location  | NULL  | {                       | {                           |
|     |           |           |       |   "city": "Lexington",  |   "location": {             |
|     |           |           |       |   "zip": "40503"        |     "city": "Lexington",    |
|     |           |           |       | }                       |     "zip": "40503"          |
|     |           |           |       |                         |   },                        |
|     |           |           |       |                         |   "price": "75836",         |
|     |           |           |       |                         |   "sale_date": "2017-3-5",  |
|     |           |           |       |                         |   "sq__ft": "1000",         |
|     |           |           |       |                         |   "type": "Residential"     |
|     |           |           |       |                         | }                           |
...
| 3   | type      | type      | NULL  | "Condo"                 | {                           |
|     |           |           |       |                         |   "location": {             |
|     |           |           |       |                         |     "city": "Winchester",   |
|     |           |           |       |                         |     "zip": "01890"          |
|     |           |           |       |                         |   },                        |
|     |           |           |       |                         |   "price": "89921",         |
|     |           |           |       |                         |   "sale_date": "2017-3-21", |
|     |           |           |       |                         |   "sq__ft": "1122",         |
|     |           |           |       |                         |   "type": "Condo"           |
|     |           |           |       |                         | }                           |
+-----+-----------+-----------+-------+-------------------------+-----------------------------+

-- Example 9121
-- Create an internal stage with the file delimiter set as none and the record delimiter set as the new line character
create or replace stage mystage
  file_format = (type = 'json');

-- Stage a semi-structured data file in the internal stage
put file:///tmp/ipaddress.json @mystage auto_compress=true;

-- Query the staged data
select t.$1 from @mystage/ipaddress.json.gz t;

+----------------------------------------------------------------------+
| $1                                                                   |
|----------------------------------------------------------------------|
| {"ip_address": {"router1": "192.168.1.1","router2": "192.168.0.1"}}, |
| {"ip_address": {"router1": "192.168.2.1","router2": "192.168.3.1"}}  |
+----------------------------------------------------------------------+

-- Create a target table for the semi-structured data
create or replace table splitjson (
  col1 array,
  col2 array
  );

-- Split the elements into individual arrays using the SPLIT function and load them into separate columns
-- Note that all JSON data is stored in a single column ($1)
copy into splitjson(col1, col2)
from (
  select split($1:ip_address.router1, '.'),split($1:ip_address.router2, '.')
  from @mystage/ipaddress.json.gz t
);

-- Query the target table
select * from splitjson;

+----------+----------+
| COL1     | COL2     |
|----------+----------|
| [        | [        |
|   "192", |   "192", |
|   "168", |   "168", |
|   "1",   |   "0",   |
|   "1"    |   "1"    |
| ]        | ]        |
| [        | [        |
|   "192", |   "192", |
|   "168", |   "168", |
|   "2",   |   "3",   |
|   "1"    |   "1"    |
| ]        | ]        |
+----------+----------+

-- Example 9122
CREATE ROLE db_hr_r;
CREATE ROLE db_fin_r;
CREATE ROLE db_fin_rw;
CREATE ROLE accountant;
CREATE ROLE analyst;

-- Example 9123
-- Grant read-only permissions on database HR to db_hr_r role.
GRANT USAGE ON DATABASE hr TO ROLE db_hr_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE hr TO ROLE db_hr_r;
GRANT SELECT ON ALL TABLES IN DATABASE hr TO ROLE db_hr_r;

-- Grant read-only permissions on database FIN to db_fin_r role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_r;
GRANT SELECT ON ALL TABLES IN DATABASE fin TO ROLE db_fin_r;

-- Grant read-write permissions on database FIN to db_fin_rw role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_rw;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_rw;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN DATABASE fin TO ROLE db_fin_rw;

-- Example 9124
GRANT ROLE db_fin_rw TO ROLE accountant;
GRANT ROLE db_hr_r TO ROLE analyst;
GRANT ROLE db_fin_r TO ROLE analyst;

-- Example 9125
GRANT ROLE accountant,analyst TO ROLE sysadmin;

-- Example 9126
GRANT ROLE accountant TO USER user1;
GRANT ROLE analyst TO USER user2;

-- Example 9127
-- Grant the SELECT privilege on all new (i.e. future) tables in a schema to role R1
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r1;

-- / Create tables in the schema /

-- Grant the SELECT privilege on all new tables in a schema to role R2
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r2;

-- Grant the SELECT privilege on all existing tables in a schema to role R2
GRANT SELECT ON ALL TABLES IN SCHEMA s1 TO ROLE r2;

-- Revoke the SELECT privilege on all new tables in a schema (i.e. future grant) from role R1
REVOKE SELECT ON FUTURE TABLES IN SCHEMA s1 FROM ROLE r1;

-- Revoke the SELECT privilege on all existing tables in a schema from role R1
REVOKE SELECT ON ALL TABLES IN SCHEMA s1 FROM ROLE r1;

-- Example 9128
USE ROLE <name>

-- Example 9129
USE ROLE myrole;

-- Example 9130
CREATE [ OR REPLACE ] USER [ IF NOT EXISTS ] <name>
  [ objectProperties ]
  [ objectParams ]
  [ sessionParams ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 9131
objectProperties ::=
  PASSWORD = '<string>'
  LOGIN_NAME = <string>
  DISPLAY_NAME = <string>
  FIRST_NAME = <string>
  MIDDLE_NAME = <string>
  LAST_NAME = <string>
  EMAIL = <string>
  MUST_CHANGE_PASSWORD = TRUE | FALSE
  DISABLED = TRUE | FALSE
  DAYS_TO_EXPIRY = <integer>
  MINS_TO_UNLOCK = <integer>
  DEFAULT_WAREHOUSE = <string>
  DEFAULT_NAMESPACE = <string>
  DEFAULT_ROLE = <string>
  DEFAULT_SECONDARY_ROLES = ( 'ALL' ) | ()
  MINS_TO_BYPASS_MFA = <integer>
  RSA_PUBLIC_KEY = <string>
  RSA_PUBLIC_KEY_FP = <string>
  RSA_PUBLIC_KEY_2 = <string>
  RSA_PUBLIC_KEY_2_FP = <string>
  TYPE = PERSON | SERVICE | LEGACY_SERVICE | NULL
  COMMENT = '<string_literal>'

-- Example 9132
objectParams ::=
  ENABLE_UNREDACTED_QUERY_SYNTAX_ERROR = TRUE | FALSE
  ENABLE_UNREDACTED_SECURE_OBJECT_ERROR = TRUE | FALSE
  NETWORK_POLICY = <string>

-- Example 9133
sessionParams ::=
  ABORT_DETACHED_QUERY = TRUE | FALSE
  AUTOCOMMIT = TRUE | FALSE
  BINARY_INPUT_FORMAT = <string>
  BINARY_OUTPUT_FORMAT = <string>
  DATE_INPUT_FORMAT = <string>
  DATE_OUTPUT_FORMAT = <string>
  DEFAULT_NULL_ORDERING = <string>
  ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE
  ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE
  JSON_INDENT = <num>
  LOCK_TIMEOUT = <num>
  QUERY_TAG = <string>
  ROWS_PER_RESULTSET = <num>
  SIMULATED_DATA_SHARING_CONSUMER = <string>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>
  STRICT_JSON_OUTPUT = TRUE | FALSE
  TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE
  TIMESTAMP_INPUT_FORMAT = <string>
  TIMESTAMP_LTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_NTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_OUTPUT_FORMAT = <string>
  TIMESTAMP_TYPE_MAPPING = <string>
  TIMESTAMP_TZ_OUTPUT_FORMAT = <string>
  TIMEZONE = <string>
  TIME_INPUT_FORMAT = <string>
  TIME_OUTPUT_FORMAT = <string>
  TRANSACTION_DEFAULT_ISOLATION_LEVEL = <string>
  TWO_DIGIT_CENTURY_START = <num>
  UNSUPPORTED_DDL_ACTION = <string>
  USE_CACHED_RESULT = TRUE | FALSE
  WEEK_OF_YEAR_POLICY = <num>
  WEEK_START = <num>

-- Example 9134
CREATE USER user1 PASSWORD='abc123' DEFAULT_ROLE = myrole DEFAULT_SECONDARY_ROLES = ('ALL') MUST_CHANGE_PASSWORD = TRUE;

-- Example 9135
GRANT ROLE <name> TO { ROLE <parent_role_name> | USER <user_name> }

-- Example 9136
GRANT ROLE analyst TO ROLE SYSADMIN;

-- Example 9137
GRANT ROLE analyst TO USER user1;

-- Example 9138
SHOW [ TERSE ] USERS
[ LIKE '<pattern>' ]
[ STARTS WITH '<name_string>' ]
[ LIMIT <rows> ]
[ FROM '<name_string>' ]

-- Example 9139
| name | created_on | display_name | first_name | last_name | email | org_identity | comment | has_password | has_rsa_public_key | type | has_mfa

-- Example 9140
SHOW [ TERSE ] ROLES
  [ LIKE '<pattern>' ]
  [ IN CLASS <class_name> ]
  [ STARTS WITH '<name_string>']
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 9141
| created_on | name | comment |

-- Example 9142
SHOW ROLES;

-- Example 9143
---------------------------------+---------------+------------+------------+--------------+-------------------+------------------+---------------+---------------+--------------------------+
           created_on            |     name      | is_default | is_current | is_inherited | assigned_to_users | granted_to_roles | granted_roles |     owner     |         comment          |
---------------------------------+---------------+------------+------------+--------------+-------------------+------------------+---------------+---------------+--------------------------+
 Fri, 05 Dec 2014 16:25:06 -0800 | ACCOUNTADMIN  | Y          | Y          | N            | 1                 | 0                | 2             |               |                          |
 Mon, 15 Dec 2014 17:58:33 -0800 | ANALYST       | N          | N          | N            | 0                 | 6                | 0             | SECURITYADMIN | Data analyst             |
 Fri, 05 Dec 2014 16:25:06 -0800 | PUBLIC        | N          | N          | Y            | 0                 | 0                | 0             |               |                          |
 Fri, 05 Dec 2014 16:25:06 -0800 | SECURITYADMIN | N          | N          | Y            | 0                 | 1                | 0             |               |                          |
 Fri, 05 Dec 2014 16:25:06 -0800 | SYSADMIN      | N          | N          | Y            | 5                 | 1                | 2             |               |                          |
---------------------------------+---------------+------------+------------+--------------+-------------------+------------------+---------------+---------------+--------------------------+

-- Example 9144
SHOW ROLES LIMIT 10 FROM 'my_role2';

-- Example 9145
DROP USER [ IF EXISTS ] <name>

-- Example 9146
DROP USER user1;

-- Example 9147
SELECT
    [ TOP <n> ]
    ...
FROM ...
[ ORDER BY ... ]
[ ... ]

-- Example 9148
select c1 from testtable;

+------+
|   C1 |
|------|
|    1 |
|    2 |
|    3 |
|   20 |
|   19 |
|   18 |
|    1 |
|    2 |
|    3 |
|    4 |
| NULL |
|   30 |
| NULL |
+------+

select TOP 4 c1 from testtable;

+----+
| C1 |
|----|
|  1 |
|  2 |
|  3 |
| 20 |
+----+

-- Example 9149
>>> # create a dataframe from a SQL query
>>> df = session.sql("select 1/2")
>>> # execute the query
>>> df.collect()
[Row(1/2=Decimal('0.500000'))]

>>> # Use params to bind variables
>>> session.sql("select * from values (?, ?), (?, ?)", params=[1, "a", 2, "b"]).sort("column1").collect()
[Row(COLUMN1=1, COLUMN2='a'), Row(COLUMN1=2, COLUMN2='b')]

-- Example 9150
session.sql('CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT)').collect()

-- Example 9151
[Row(status='Table SAMPLE_PRODUCT_DATA successfully created.')]

-- Example 9152
session.sql("""
INSERT INTO sample_product_data VALUES
(1, 0, 5, 'Product 1', 'prod-1', 1, 10),
(2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20),
(3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30),
(4, 0, 10, 'Product 2', 'prod-2', 2, 40),
(5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50),
(6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60),
(7, 0, 20, 'Product 3', 'prod-3', 3, 70),
(8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80),
(9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90),
(10, 0, 50, 'Product 4', 'prod-4', 4, 100),
(11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100),
(12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100)
""").collect()

-- Example 9153
[Row(number of rows inserted=12)]

-- Example 9154
session.sql("SELECT count(*) FROM sample_product_data").collect()

-- Example 9155
[Row(COUNT(*)=12)]

-- Example 9156
CREATE OR REPLACE TABLE sample_product_data
  (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT);

INSERT INTO sample_product_data VALUES
  (1, 0, 5, 'Product 1', 'prod-1', 1, 10),
  (2, 1, 5, 'Product 1A', 'prod-1-A', 1, 20),
  (3, 1, 5, 'Product 1B', 'prod-1-B', 1, 30),
  (4, 0, 10, 'Product 2', 'prod-2', 2, 40),
  (5, 4, 10, 'Product 2A', 'prod-2-A', 2, 50),
  (6, 4, 10, 'Product 2B', 'prod-2-B', 2, 60),
  (7, 0, 20, 'Product 3', 'prod-3', 3, 70),
  (8, 7, 20, 'Product 3A', 'prod-3-A', 3, 80),
  (9, 7, 20, 'Product 3B', 'prod-3-B', 3, 90),
  (10, 0, 50, 'Product 4', 'prod-4', 4, 100),
  (11, 10, 50, 'Product 4A', 'prod-4-A', 4, 100),
  (12, 10, 50, 'Product 4B', 'prod-4-B', 4, 100);

SELECT count(*) FROM sample_product_data;

-- Example 9157
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

def main(session: snowpark.Session):
  df_table = session.table("sample_product_data")

-- Example 9158
# Create a DataFrame from the data in the "sample_product_data" table.
df_table = session.table("sample_product_data")

# To print out the first 10 rows, call df_table.show()

-- Example 9159
# Create a DataFrame with one column named a from specified values.
df1 = session.create_dataframe([1, 2, 3, 4]).to_df("a")
df1.show()
# To return the DataFrame as a table in a Python worksheet use return instead of show()
# return df1

