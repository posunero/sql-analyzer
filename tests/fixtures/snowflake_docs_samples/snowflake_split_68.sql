-- Example 4539
-- Create a file format that sets the file type as JSON.
CREATE FILE FORMAT my_json_format
  TYPE = json;

-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@mystage/json/'
      , FILE_FORMAT=>'my_json_format'
      )
    );

+-------------+---------------+----------+---------------------------+--------------------------+----------+
| COLUMN_NAME | TYPE          | NULLABLE | EXPRESSION                | FILENAMES                | ORDER_ID |
|-------------+---------------+----------+---------------------------+--------------------------|----------+
| col_bool    | BOOLEAN       | True     | $1:col_bool::BOOLEAN      | json/schema_A_1.json     | 0        |
| col_date    | DATE          | True     | $1:col_date::DATE         | json/schema_A_1.json     | 1        |
| col_ts      | TIMESTAMP_NTZ | True     | $1:col_ts::TIMESTAMP_NTZ  | json/schema_A_1.json     | 2        |
+-------------+---------------+----------+---------------------------+--------------------------+----------+

-- Example 4540
CREATE TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@mystage/json/',
          FILE_FORMAT=>'my_json_format'
        )
      ));

-- Example 4541
-- Create a file format that sets the file type as CSV.
CREATE FILE FORMAT my_csv_format
  TYPE = csv
  PARSE_HEADER = true;

-- Query the INFER_SCHEMA function.
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@mystage/csv/'
      , FILE_FORMAT=>'my_csv_format'
      )
    );

+-------------+---------------+----------+---------------------------+--------------------------+----------+
| COLUMN_NAME | TYPE          | NULLABLE | EXPRESSION                | FILENAMES                | ORDER_ID |
|-------------+---------------+----------+---------------------------+--------------------------|----------+
| col_bool    | BOOLEAN       | True     | $1:col_bool::BOOLEAN      | json/schema_A_1.csv      | 0        |
| col_date    | DATE          | True     | $1:col_date::DATE         | json/schema_A_1.csv      | 1        |
| col_ts      | TIMESTAMP_NTZ | True     | $1:col_ts::TIMESTAMP_NTZ  | json/schema_A_1.csv      | 2        |
+-------------+---------------+----------+---------------------------+--------------------------+----------+

-- Load the CSV file using MATCH_BY_COLUMN_NAME.
COPY INTO mytable FROM @mystage/csv/
  FILE_FORMAT = (
    FORMAT_NAME= 'my_csv_format'
  )
  MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;

-- Example 4542
GENERATOR( ROWCOUNT => <count> [ , TIMELIMIT => <sec> ] )

GENERATOR( [ TIMELIMIT => <sec> ] )

-- Example 4543
SELECT seq4(), uniform(1, 10, RANDOM(12)) 
  FROM TABLE(GENERATOR(ROWCOUNT => 10)) v 
  ORDER BY 1;
+--------+----------------------------+
| SEQ4() | UNIFORM(1, 10, RANDOM(12)) |
|--------+----------------------------|
|      0 |                          7 |
|      1 |                          2 |
|      2 |                          5 |
|      3 |                          9 |
|      4 |                          6 |
|      5 |                          9 |
|      6 |                          9 |
|      7 |                          5 |
|      8 |                          3 |
|      9 |                          8 |
+--------+----------------------------+

-- Example 4544
SELECT seq4(), uniform(1, 10, 42) 
  FROM TABLE(GENERATOR(ROWCOUNT => 10)) v 
  ORDER BY 1;
+--------+--------------------+
| SEQ4() | UNIFORM(1, 10, 42) |
|--------+--------------------|
|      0 |                 10 |
|      1 |                 10 |
|      2 |                 10 |
|      3 |                 10 |
|      4 |                 10 |
|      5 |                 10 |
|      6 |                 10 |
|      7 |                 10 |
|      8 |                 10 |
|      9 |                 10 |
+--------+--------------------+

-- Example 4545
SELECT seq4(), uniform(1, 10, RANDOM(12)) 
  FROM TABLE(GENERATOR()) v 
  ORDER BY 1;
+--------+----------------------------+
| SEQ4() | UNIFORM(1, 10, RANDOM(12)) |
|--------+----------------------------|
+--------+----------------------------+

-- Example 4546
SELECT COUNT(seq4()) FROM TABLE(GENERATOR(TIMELIMIT => 10)) v;

+---------------+
| COUNT(SEQ4()) |
|---------------|
|    3615440896 |
+---------------+

-- Example 4547
GET( <array> , <index> )

GET( <variant> , <index> )

-- Example 4548
GET( <object> , <field_name> )

GET( <variant> , <field_name> )

-- Example 4549
GET( <map> , <key> )

-- Example 4550
CREATE TABLE vartab (a ARRAY, o OBJECT, v VARIANT);
INSERT INTO vartab (a, o, v) 
  SELECT
    ARRAY_CONSTRUCT(2.71, 3.14),
    OBJECT_CONSTRUCT('Ukraine', 'Kyiv'::VARIANT, 
                     'France',  'Paris'::VARIANT),
    TO_VARIANT(OBJECT_CONSTRUCT('weatherStationID', 42::VARIANT,
                     'timestamp', '2022-03-07 14:00'::TIMESTAMP_LTZ::VARIANT,
                     'temperature', 31.5::VARIANT,
                     'sensorType', 'indoor'::VARIANT))
    ;

-- Example 4551
SELECT a, o, v FROM vartab;
+---------+----------------------+-------------------------------------------------+
| A       | O                    | V                                               |
|---------+----------------------+-------------------------------------------------|
| [       | {                    | {                                               |
|   2.71, |   "France": "Paris", |   "sensorType": "indoor",                       |
|   3.14  |   "Ukraine": "Kyiv"  |   "temperature": 31.5,                          |
| ]       | }                    |   "timestamp": "2022-03-07 14:00:00.000 -0800", |
|         |                      |   "weatherStationID": 42                        |
|         |                      | }                                               |
+---------+----------------------+-------------------------------------------------+

-- Example 4552
SELECT GET(a, 0) FROM vartab;
+-----------+
| GET(A, 0) |
|-----------|
| 2.71      |
+-----------+

-- Example 4553
SELECT GET(o, 'Ukraine') FROM vartab;
+-------------------+
| GET(O, 'UKRAINE') |
|-------------------|
| "Kyiv"            |
+-------------------+

-- Example 4554
SELECT GET(v, 'temperature') FROM vartab;
+-----------------------+
| GET(V, 'TEMPERATURE') |
|-----------------------|
| 31.5                  |
+-----------------------+

-- Example 4555
GET_ABSOLUTE_PATH( @<stage_name> , '<relative_file_path>' )

-- Example 4556
SELECT GET_ABSOLUTE_PATH(@images_stage, 'us/yosemite/half_dome.jpg');

+------------------------------------------------------------------------------------------+
| GET_ABSOLUTE_PATH(@IMAGES_STAGE, 'US/YOSEMITE/HALF_DOME.JPG')                            |
+------------------------------------------------------------------------------------------+
| s3://photos/national_parks/us/yosemite/half_dome.jpg                                     |
+------------------------------------------------------------------------------------------+

-- Example 4557
SNOWFLAKE.SNOWPARK.GET_ANACONDA_PACKAGES_REPODATA( '<architecture>' )

-- Example 4558
USE ROLE ACCOUNTADMIN;

select SNOWFLAKE.SNOWPARK.GET_ANACONDA_PACKAGES_REPODATA('linux-64');

-- Example 4559
SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()

-- Example 4560
GRANT DATABASE ROLE snowflake.alert_viewer TO ROLE alert_role;

-- Example 4561
GET_DDL( '<object_type>' , '[<namespace>.]<object_name>' [ , <use_fully_qualified_names_for_recreated_objects> ] )

-- Example 4562
CREATE VIEW view_t1
  -- GET_DDL() removes this comment.
  AS SELECT * FROM t1;

-- Example 4563
SELECT GET_DDL('VIEW', 'books_view');
+-----------------------------------------------------------------------------+ 
| GET_DDL('VIEW', 'BOOKS_VIEW')                                               |
|-----------------------------------------------------------------------------|
|                                                                             |
| CREATE OR REPLACE VIEW BOOKS_VIEW as select title, author from books_table; |
|                                                                             |
+-----------------------------------------------------------------------------+

-- Example 4564
SELECT GET_DDL('SCHEMA', 'books_schema');
+-----------------------------------------------------------------------------+ 
| GET_DDL('SCHEMA', 'BOOKS_SCHEMA')                                           |
|-----------------------------------------------------------------------------|
| CREATE OR REPLACE SCHEMA BOOKS_SCHEMA;                                      |
|                                                                             |
| CREATE OR REPLACE TABLE BOOKS_TABLE (                                       |
| 	ID NUMBER(38,0),                                                          |
| 	TITLE VARCHAR(255),                                                       |
| 	AUTHOR VARCHAR(255)                                                       |
| );                                                                          |
|                                                                             |
| CREATE OR REPLACE VIEW BOOKS_VIEW as select title, author from books_table; |
|                                                                             |
+-----------------------------------------------------------------------------+

-- Example 4565
SELECT GET_DDL('SCHEMA', 'books_schema', true);
+---------------------------------------------------------------------------------------------------+
| GET_DDL('SCHEMA', 'BOOKS_SCHEMA', TRUE)                                                           |
|---------------------------------------------------------------------------------------------------|
| CREATE OR REPLACE SCHEMA BOOKS_DB.BOOKS_SCHEMA;                                                   |
|                                                                                                   |
| CREATE OR REPLACE TABLE BOOKS_DB.BOOKS_SCHEMA.BOOKS_TABLE (                                       |
| 	ID NUMBER(38,0),                                                                                |
| 	TITLE VARCHAR(255),                                                                             |
| 	AUTHOR VARCHAR(255)                                                                             |
| );                                                                                                |
|                                                                                                   |
| CREATE OR REPLACE VIEW BOOKS_DB.BOOKS_SCHEMA.BOOKS_VIEW as select title, author from books_table; |
|                                                                                                   |
+---------------------------------------------------------------------------------------------------+

-- Example 4566
SELECT GET_DDL('FUNCTION', 'multiply(number, number)');

+--------------------------------------------------+
| GET_DDL('FUNCTION', 'MULTIPLY(NUMBER, NUMBER)')  |
+--------------------------------------------------+
| CREATE OR REPLACE "MULTIPLY"(A NUMBER, B NUMBER) |
| RETURNS NUMBER(38,0)                             |
| COMMENT='multiply two numbers'                   |
| AS 'a * b';                                      |
+--------------------------------------------------+

-- Example 4567
SELECT GET_DDL('procedure', 'stproc_1(float)');
+---------------------------------------------------+
| GET_DDL('PROCEDURE', 'STPROC_1(FLOAT)')           |
|---------------------------------------------------|
| CREATE OR REPLACE PROCEDURE "STPROC_1"("F" FLOAT) |
| RETURNS FLOAT                                     |
| LANGUAGE JAVASCRIPT                               |
| EXECUTE AS OWNER                                  |
| AS '                                              |
| ''return F;''                                     |
| ';                                                |
+---------------------------------------------------+

-- Example 4568
SELECT GET_DDL('POLICY', 'employee_ssn_mask');

+----------------------------------------------------------------------------+
|                   GET_DDL('POLICY', 'EMPLOYEE_SSN_MASK')                   |
+----------------------------------------------------------------------------+
| CREATE MASKING POLICY employee_ssn_mask AS (val string) RETURNS string ->  |
| case                                                                       |
|   when current_role() in ('PAYROLL')                                       |
|   then val                                                                 |
|   else '******'                                                            |
| end;                                                                       |
+----------------------------------------------------------------------------+

-- Example 4569
SELECT GET_DDL('INTEGRATION', s3_int);

+----------------------------------------------------------------------------+
| GET_DDL('INTEGRATION', 's3_int')                                           |
|----------------------------------------------------------------------------|
| CREATE OR REPLACE STORAGE INTEGRATION s3_int                               |
|   TYPE = EXTERNAL_STAGE                                                    |
|   STORAGE_PROVIDER = 'S3'                                                  |
|   STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'           |
|   STORAGE_AWS_EXTERNAL_ID='ACCOUNT_SFCRole=2_kztjogs3W9S18I+iWapHpIz/wq4=' |
|   ENABLED = TRUE                                                           |
|   STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket1/path1/');                   |
+----------------------------------------------------------------------------+

-- Example 4570
CREATE OR REPLACE WAREHOUSE my_wh
  WAREHOUSE_SIZE=LARGE
  INITIALLY_SUSPENDED=TRUE;

-- Example 4571
SELECT GET_DDL('WAREHOUSE', 'my_wh');

-- Example 4572
+-------------------------------------------+
| GET_DDL('WAREHOUSE', 'MY_WH')             |
|-------------------------------------------|
| create or replace warehouse MY_WH         |
| with                                      |
|     warehouse_type='STANDARD'             |
|     warehouse_size='Large'                |
|     max_cluster_count=1                   |
|     min_cluster_count=1                   |
|     scaling_policy=STANDARD               |
|     auto_suspend=600                      |
|     auto_resume=TRUE                      |
|     initially_suspended=TRUE              |
|     enable_query_acceleration=FALSE       |
|     query_acceleration_max_scale_factor=8 |
|     max_concurrency_level=8               |
|     statement_queued_timeout_in_seconds=0 |
|     statement_timeout_in_seconds=172800   |
| ;                                         |
+-------------------------------------------+

-- Example 4573
CREATE OR REPLACE HYBRID TABLE ht_weather
 (id INT PRIMARY KEY,
  start_time TIMESTAMP,
  precip NUMBER(3,2),
  city VARCHAR(20),
  county VARCHAR(20));

-- Example 4574
SELECT GET_DDL('TABLE','ht_weather');

-- Example 4575
+---------------------------------------------+
| GET_DDL('TABLE','HT_WEATHER')               |
|---------------------------------------------|
| create or replace HYBRID TABLE HT_WEATHER ( |
|   ID NUMBER(38,0) NOT NULL,                 |
|   START_TIME TIMESTAMP_NTZ(9),              |
|   PRECIP NUMBER(3,2),                       |
|   CITY VARCHAR(20),                         |
|   COUNTY VARCHAR(20),                       |
|   primary key (ID)                          |
| );                                          |
+---------------------------------------------+

-- Example 4576


-- Example 4577
GET_IGNORE_CASE( <object> , <field_name> )

GET_IGNORE_CASE( <variant> , <field_name> )

-- Example 4578
GET_IGNORE_CASE( <map> , <key> )

-- Example 4579
SELECT GET_IGNORE_CASE(TO_OBJECT(PARSE_JSON('{"aa":1, "aA":2, "Aa":3, "AA":4}')),'aA') as output;

+--------+
| OUTPUT |
|--------|
| 2      |
+--------+

-- Example 4580
SELECT GET_IGNORE_CASE(TO_OBJECT(PARSE_JSON('{"aa":1, "aA":2, "Aa":3}')),'AA') as output;

+--------+
| OUTPUT |
|--------|
| 3      |
+--------+

-- Example 4581
SNOWFLAKE.CORE.GET_LINEAGE(
    '<object_name>',
    '<object_domain>',
    '<direction>',
    [ <distance>, ]
    [ '<object_version>' ]
)

-- Example 4582
SELECT
    DISTANCE,
    SOURCE_OBJECT_DOMAIN,
    SOURCE_OBJECT_DATABASE,
    SOURCE_OBJECT_SCHEMA,
    SOURCE_OBJECT_NAME,
    SOURCE_STATUS,
    TARGET_OBJECT_DOMAIN,
    TARGET_OBJECT_DATABASE,
    TARGET_OBJECT_SCHEMA,
    TARGET_OBJECT_NAME,
    TARGET_STATUS,
FROM TABLE (SNOWFLAKE.CORE.GET_LINEAGE('my_database.sch.table_a', 'TABLE', 'DOWNSTREAM', 2));

-- Example 4583
+----------+----------------------+------------------------+----------------------+--------------------+---------------+----------------------+------------------------+----------------------+--------------------+---------------+
| DISTANCE | SOURCE_OBJECT_DOMAIN | SOURCE_OBJECT_DATABASE | SOURCE_OBJECT_SCHEMA | SOURCE_OBJECT_NAME | SOURCE_STATUS | TARGET_OBJECT_DOMAIN | TARGET_OBJECT_DATABASE | TARGET_OBJECT_SCHEMA | TARGET_OBJECT_NAME | TARGET_STATUS |
|----------+----------------------+------------------------+----------------------+--------------------+---------------+----------------------+------------------------+----------------------+--------------------+---------------|
|        1 | TABLE                | MY_DATABASE            | SCH                  | TABLE_A            | ACTIVE        | TABLE                | MY_DATABASE            | SCH                  | TABLE_B            | ACTIVE        |
|        2 | TABLE                | MY_DATABASE            | SCH                  | TABLE_B            | ACTIVE        | TABLE                | MY_DATABASE            | SCH                  | TABLE_C            | ACTIVE        |
+----------+----------------------+------------------------+----------------------+--------------------+---------------+----------------------+------------------------+----------------------+--------------------+---------------+

-- Example 4584
GET_OBJECT_REFERENCES(
  DATABASE_NAME => '<string>'
  , SCHEMA_NAME => '<string>'
  , OBJECT_NAME => '<string>' )

-- Example 4585
Insufficient privileges to operate on view '<view_name>'

-- Example 4586
-- create a database
create or replace database ex1_gor_x;
use database ex1_gor_x;
use schema PUBLIC;

-- create a set of tables
create or replace table x_tab_a (mycol int not null);
create or replace table x_tab_b (mycol int not null);
create or replace table x_tab_c (mycol int not null);

-- create views with increasing complexity of references
create or replace view x_view_d as
select * from x_tab_a
join x_tab_b
using ( mycol );

create or replace view x_view_e as
select x_tab_b.* from x_tab_b, x_tab_c
where x_tab_b.mycol=x_tab_c.mycol;

--create a second database
create or replace database ex1_gor_y;
use database ex1_gor_y;
use schema PUBLIC;

-- create a table in the second database
create or replace table y_tab_a (mycol int not null);

-- create more views with increasing levels of references
create or replace view y_view_b as
select * from ex1_gor_x.public.x_tab_a
join y_tab_a
using ( mycol );

create or replace view y_view_c as
select b.* from ex1_gor_x.public.x_tab_b b, ex1_gor_x.public.x_tab_c c
where b.mycol=c.mycol;

create or replace view y_view_d as
select * from ex1_gor_x.public.x_view_e;

create or replace view y_view_e as
select e.* from ex1_gor_x.public.x_view_e e, y_tab_a
where e.mycol=y_tab_a.mycol;

create or replace view y_view_f as
select e.* from ex1_gor_x.public.x_view_e e, ex1_gor_x.public.x_tab_c c, y_tab_a
where e.mycol=y_tab_a.mycol
and e.mycol=c.mycol;

-- retrieve the references for the last view created
select * from table(get_object_references(database_name=>'ex1_gor_y', schema_name=>'public', object_name=>'y_view_f'));

+---------------+-------------+-----------+--------------------------+------------------------+------------------------+------------------------+
| DATABASE_NAME | SCHEMA_NAME | VIEW_NAME | REFERENCED_DATABASE_NAME | REFERENCED_SCHEMA_NAME | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_TYPE |
|---------------+-------------+-----------+--------------------------+------------------------+------------------------+------------------------|
| EX1_GOR_Y     | PUBLIC      | Y_VIEW_F  | EX1_GOR_Y                | PUBLIC                 | Y_TAB_A                | TABLE                  |
| EX1_GOR_Y     | PUBLIC      | Y_VIEW_F  | EX1_GOR_X                | PUBLIC                 | X_TAB_B                | TABLE                  |
| EX1_GOR_Y     | PUBLIC      | Y_VIEW_F  | EX1_GOR_X                | PUBLIC                 | X_TAB_C                | TABLE                  |
| EX1_GOR_Y     | PUBLIC      | Y_VIEW_F  | EX1_GOR_X                | PUBLIC                 | X_VIEW_E               | VIEW                   |
+---------------+-------------+-----------+--------------------------+------------------------+------------------------+------------------------+

-- Example 4587
GET_PATH( <column_identifier> , '<path_name>' )

<column_identifier>:<path_name>

:( <column_identifier> , '<path_name>' )

-- Example 4588
SELECT GET_PATH(v, 'attr[0].name') FROM vartab;

-- Example 4589
SELECT v:attr[0].name FROM vartab;

-- Example 4590
SELECT GET_PATH('v:"attr"[0]:"name"') FROM vartab;

-- Example 4591
GET_PRESIGNED_URL( @<stage_name> , '<relative_file_path>' , [ <expiration_time> ] )

-- Example 4592
SELECT GET_PRESIGNED_URL(@images_stage, 'us/yosemite/half_dome.jpg', 3600);

+================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================-------+
| GET_PRESIGNED_URL(@IMAGES_STAGE, 'US/YOSEMITE/HALF_DOME.JPG', 3600)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================-------|
| http://myaccount.s3.amazonaws.com/national_parks/us/yosemite/half_dome.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxAus-west-xxxxxxxxxaws1_request&X-Amz-Date=20200625T162738Z&X-Amz-Expires=3600&X-Amz-Security-Token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-Amz-SignedHeaders=host&X-Amz-Signature=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx   |
+================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================-------+

-- Example 4593
{
  "file_url": "s3://photos/national_parks/us/yosemite/half_dome.jpg",
  "image_format": "jpeg",
  "dimensions": {"x" : 1024, "y" : 768},
  "tags":[
    "rock",
    "cliff",
    "valley"
  ],
  "dominant_color": "gray"
}

-- Example 4594
-- Create a table to store the file metadata

  CREATE TABLE images_table
  (
      file_url string,
      image_format string,
      dimensions_X number,
      dimensions_Y number,
      tags array,
      dominant_color string,
      relative_path string
  );

-- Load the metadata from the JSON document into the table.

COPY INTO images_table
  FROM
  (SELECT $1:file_url::STRING, $1:image_format::STRING, $1:size::NUMBER, $1:tags, $1:dominant_color::STRING, GET_RELATIVE_PATH(@images_stage, $1:file_url)
  FROM
  @images_stage/image_metadata.json)
  FILE_FORMAT = (type = json);

-- Create a view that queries the pre-signed URL for an image as well as the image metadata stored in a table.
CREATE VIEW image_catalog AS
(
  SELECT
   size,
   get_presigned_url(@images_stage, relative_path) AS presigned_url,
   tags
  FROM
    images_table
);

-- Example 4595
SNOWFLAKE.CORE.GET_PYTHON_PROFILER_OUTPUT(<query_id>)

-- Example 4596
Handler Name: main
Python Runtime Version: 3.8
Modules Profiled: ['main_module']
File: _udf_code.py
Function: main at line 4

Line #   Mem usage    Increment  Occurrences  Line Contents
=============================================================
    4    245.3 MiB    245.3 MiB           1   def main(session, last_n, total):
    5                                             # create sample dataset to emulate id + elapsed time
    6    245.8 MiB      0.5 MiB           1       session.sql('''
    7                                                 CREATE OR REPLACE TABLE sample_query_history (query_id INT, elapsed_time FLOAT)''').collect()
    8    245.8 MiB      0.0 MiB           2       session.sql('''
    9                                             INSERT INTO sample_query_history
    10                                             SELECT
    11                                             seq8() AS query_id,
    12                                             uniform(0::float, 100::float, random()) as elapsed_time
    13    245.8 MiB      0.0 MiB           1       FROM table(generator(rowCount => {0}));'''.format(total)).collect()
    14
    15                                             # get the mean of the last n query elapsed time
    16    245.8 MiB      0.0 MiB           3       df = session.table('sample_query_history').select(
    17    245.8 MiB      0.0 MiB           1           funcs.col('query_id'),
    18    245.8 MiB      0.0 MiB           2           funcs.col('elapsed_time')).limit(last_n)
    19
    20    327.9 MiB     82.1 MiB           1       pandas_df = df.to_pandas()
    21    328.9 MiB      1.0 MiB           1       mean_time = pandas_df.loc[:, 'ELAPSED_TIME'].mean()
    22    320.9 MiB     -8.0 MiB           1       del pandas_df
    23    320.9 MiB      0.0 MiB           1       return mean_time

-- Example 4597
USE DATABASE my_database;
USE SCHEMA my_schema;

CREATE TEMPORARY STAGE profiler_output;
ALTER SESSION SET PYTHON_PROFILER_TARGET_STAGE = "my_database.my_schema.profiler_output";

-- Example 4598
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'LINE';

-- Example 4599
ALTER SESSION SET ACTIVE_PYTHON_PROFILER = 'MEMORY';

-- Example 4600
CALL YOUR_STORED_PROCEDURE();

-- Example 4601
SELECT SNOWFLAKE.CORE.GET_PYTHON_PROFILER_OUTPUT(<query_id>);

-- Example 4602
CREATE OR REPLACE PROCEDURE my_sproc()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.10
  PACKAGES = ('snowflake-snowpark-python', 'other_package')
  HANDLER='handler'
AS $$
from other_package import some_method

def helper():
...

def handler(session):
...
$$;

-- Example 4603
ALTER SESSION SET PYTHON_PROFILER_MODULES = 'module_a, my_module';

-- Example 4604
CREATE OR REPLACE PROCEDURE test_udf_1()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES=('snowflake-snowpark-python')
  HANDLER = 'test_python_import_main.my_udf'
  IMPORTS = ('@stage1/test_python_import_main.py', '@stage2/test_python_import_module.py');

-- Example 4605
ALTER SESSION SET PYTHON_PROFILER_MODULES = 'test_python_import_main, test_python_import_module';

