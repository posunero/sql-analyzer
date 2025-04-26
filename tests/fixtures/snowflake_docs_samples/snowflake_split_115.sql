-- Example 7686
-- S3 bucket
COPY INTO mytable FROM 's3://mybucket/./../a.csv';

-- Google Cloud Storage bucket
COPY INTO mytable FROM 'gcs://mybucket/./../a.csv';

-- Azure container
COPY INTO mytable FROM 'azure://myaccount.blob.core.windows.net/mycontainer/./../a.csv';

-- Example 7687
|"Hello world"|
|" Hello world "|
| "Hello world" |

-- Example 7688
+---------------+
| C1            |
|----+----------|
| Hello world   |
|  Hello world  |
| Hello world   |
+---------------+

-- Example 7689
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 7690
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

-- Example 7691
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

-- Example 7692
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

-- Example 7693
COPY INTO [<namespace>.]<table_name> [ ( <col_name> [ , <col_name> ... ] ) ]
FROM ( SELECT [<alias>.]$<file_col_num>[.<element>] [ , [<alias>.]$<file_col_num>[.<element>] ... ]
    FROM { internalStage | externalStage } )
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
            TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
MATCH_BY_COLUMN_NAME = CASE_SENSITIVE | CASE_INSENSITIVE | NONE
[ other copyOptions ]

-- Example 7694
COPY INTO table1 FROM @stage1
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
INCLUDE_METADATA = (
    ingestdate = METADATA$START_SCAN_TIME, filename = METADATA$FILENAME);

-- Example 7695
+-----+-----------------------+---------------------------------+-----+
| ... | FILENAME              | INGESTDATE                      | ... |
|---------------------------------------------------------------+-----|
| ... | example_file.json.gz  | Thu, 22 Feb 2024 19:14:55 +0000 | ... |
+-----+-----------------------+---------------------------------+-----+

-- Example 7696
LIST @my_gcs_stage;

+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Sep 2019 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Sep 2019 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 7697
COPY INTO mytable
FROM @my_int_stage;

-- Example 7698
COPY INTO mytable
FILE_FORMAT = (TYPE = CSV);

-- Example 7699
COPY INTO mytable from @~/staged
FILE_FORMAT = (FORMAT_NAME = 'mycsv');

-- Example 7700
COPY INTO mycsvtable
  FROM @my_ext_stage/tutorials/dataloading/contacts1.csv;

-- Example 7701
COPY INTO mytable
  FROM @my_ext_stage/tutorials/dataloading/sales.json.gz
  FILE_FORMAT = (TYPE = 'JSON')
  MATCH_BY_COLUMN_NAME='CASE_INSENSITIVE';

-- Example 7702
COPY INTO mytable
  FROM s3://mybucket/data/files
  STORAGE_INTEGRATION = myint
  ENCRYPTION=(MASTER_KEY = 'eSx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 7703
COPY INTO mytable
  FROM s3://mybucket/data/files
  CREDENTIALS=(AWS_KEY_ID='$AWS_ACCESS_KEY_ID' AWS_SECRET_KEY='$AWS_SECRET_ACCESS_KEY')
  ENCRYPTION=(MASTER_KEY = 'eSx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 7704
COPY INTO mytable
  FROM 'gcs://mybucket/data/files'
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 7705
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/data/files'
  STORAGE_INTEGRATION = myint
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 7706
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/mycontainer/data/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 7707
COPY INTO mytable
  FILE_FORMAT = (TYPE = 'CSV')
  PATTERN='.*/.*/.*[.]csv[.]gz';

-- Example 7708
COPY INTO mytable
  FILE_FORMAT = (FORMAT_NAME = myformat)
  PATTERN='.*sales.*[.]csv';

-- Example 7709
[{
    "location": {
      "city": "Lexington",
      "zip": "40503",
      },
      "sq__ft": "1000",
      "sale_date": "4-25-16",
      "price": "75836"
},
{
    "location": {
      "city": "Belmont",
      "zip": "02478",
      },
      "sq__ft": "1103",
      "sale_date": "6-18-16",
      "price": "92567"
}
{
    "location": {
      "city": "Winchester",
      "zip": "01890",
      },
      "sq__ft": "1122",
      "sale_date": "1-31-16",
      "price": "89921"
}]

-- Example 7710
/* Create a JSON file format that strips the outer array. */

CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

/* Create an internal stage that references the JSON file format. */

CREATE OR REPLACE STAGE mystage
  FILE_FORMAT = json_format;

/* Stage the JSON file. */

PUT file:///tmp/sales.json @mystage AUTO_COMPRESS=TRUE;

/* Create a target table for the JSON data. */

CREATE OR REPLACE TABLE house_sales (src VARIANT);

/* Copy the JSON data into the target table. */

COPY INTO house_sales
   FROM @mystage/sales.json.gz;

SELECT * FROM house_sales;

+---------------------------+
| SRC                       |
|---------------------------|
| {                         |
|   "location": {           |
|     "city": "Lexington",  |
|     "zip": "40503"        |
|   },                      |
|   "price": "75836",       |
|   "sale_date": "4-25-16", |
|   "sq__ft": "1000",       |
|   "type": "Residential"   |
| }                         |
| {                         |
|   "location": {           |
|     "city": "Belmont",    |
|     "zip": "02478"        |
|   },                      |
|   "price": "92567",       |
|   "sale_date": "6-18-16", |
|   "sq__ft": "1103",       |
|   "type": "Residential"   |
| }                         |
| {                         |
|   "location": {           |
|     "city": "Winchester", |
|     "zip": "01890"        |
|   },                      |
|   "price": "89921",       |
|   "sale_date": "1-31-16", |
|   "sq__ft": "1122",       |
|   "type": "Condo"         |
| }                         |
+---------------------------+

-- Example 7711
COPY INTO load1 FROM @%load1/data1/
    FILES=('test1.csv', 'test2.csv');

COPY INTO load1 FROM @%load1/data1/
    FILES=('test1.csv', 'test2.csv')
    FORCE=TRUE;

-- Example 7712
ALTER TABLE mytable SET STAGE_COPY_OPTIONS = (PURGE = TRUE);

COPY INTO mytable;

-- Example 7713
COPY INTO mytable PURGE = TRUE;

-- Example 7714
COPY INTO mytable VALIDATION_MODE = 'RETURN_ERRORS';

+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+
|                                                         ERROR                                                                 |            FILE        | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |  CODE  | SQL_STATE |   COLUMN_NAME        | ROW_NUMBER | ROW_START_LINE |
+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+
| Field delimiter ',' found while expecting record delimiter '\n'                                                               | @MYTABLE/data1.csv.gz  | 3    | 21        | 76          | parsing  | 100016 | 22000     | "MYTABLE"["QUOTA":3] | 3          | 3              |
| NULL result in a non-nullable column. Use quotes if an empty field should be interpreted as an empty string instead of a null | @MYTABLE/data3.csv.gz  | 3    | 2         | 62          | parsing  | 100088 | 22000     | "MYTABLE"["NAME":1]  | 3          | 3              |
| End of record reached while expected to parse column '"MYTABLE"["QUOTA":3]'                                                   | @MYTABLE/data3.csv.gz  | 4    | 20        | 96          | parsing  | 100068 | 22000     | "MYTABLE"["QUOTA":3] | 4          | 4              |
+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+

-- Example 7715
COPY INTO mytable VALIDATION_MODE = 'RETURN_2_ROWS';

+--------------------+----------+-------+
|        NAME        |    ID    | QUOTA |
+--------------------+----------+-------+
| Joe Smith          |  456111  | 0     |
| Tom Jones          |  111111  | 3400  |
+--------------------+----------+-------+

COPY INTO mytable VALIDATION_MODE = 'RETURN_3_ROWS';

FAILURE: NULL result in a non-nullable column. Use quotes if an empty field should be interpreted as an empty string instead of a null
  File '@MYTABLE/data3.csv.gz', line 3, character 2
  Row 3, column "MYTABLE"["NAME":1]

-- Example 7716
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_VECTORIZED_SCANNER = TRUE;

-- Example 7717
CREATE OR REPLACE ICEBERG TABLE customer_iceberg_ingest (
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
  EXTERNAL_VOLUME = 'iceberg_ingest_vol'
  BASE_LOCATION = 'customer_iceberg_ingest/';

-- Example 7718
COPY INTO customer_iceberg_ingest
  FROM @my_parquet_stage
  FILE_FORMAT = 'my_parquet_format'
  LOAD_MODE = ADD_FILES_COPY
  PURGE = TRUE
  MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- Example 7719
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                          | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_008.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_006.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_005.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_002.parquet | LOADED |           5 |           5 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_010.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 7720
SELECT
    c_custkey,
    c_name,
    c_mktsegment
  FROM customer_iceberg_ingest
  LIMIT 10;

-- Example 7721
+-----------+--------------------+--------------+
| C_CUSTKEY | C_NAME             | C_MKTSEGMENT |
|-----------+--------------------+--------------|
|     75001 | Customer#000075001 | FURNITURE    |
|     75002 | Customer#000075002 | FURNITURE    |
|     75003 | Customer#000075003 | MACHINERY    |
|     75004 | Customer#000075004 | AUTOMOBILE   |
|     75005 | Customer#000075005 | FURNITURE    |
|         1 | Customer#000000001 | BUILDING     |
|         2 | Customer#000000002 | AUTOMOBILE   |
|         3 | Customer#000000003 | AUTOMOBILE   |
|         4 | Customer#000000004 | MACHINERY    |
|         5 | Customer#000000005 | HOUSEHOLD    |
+-----------+--------------------+--------------+

-- Example 7722
VALIDATE_PIPE_LOAD(
      PIPE_NAME => '<string>'
       , START_TIME => <constant_expr>
      [, END_TIME => <constant_expr> ] )

-- Example 7723
select * from table(validate_pipe_load(
  pipe_name=>'MY_DB.PUBLIC.MYPIPE',
  start_time=>dateadd(hour, -1, current_timestamp())));

-- Example 7724
VECTOR_COSINE_SIMILARITY( <vector>, <vector> )

-- Example 7725
SELECT a, VECTOR_COSINE_SIMILARITY(a, [1,2,3]::VECTOR(FLOAT, 3)) AS similarity
  FROM vectors
  ORDER BY similarity DESC
  LIMIT 1;

-- Example 7726
+-------------------------+
| [1, 2.2, 3] | 0.9990... |
+-------------------------+

-- Example 7727
CREATE TABLE vectors (a VECTOR(float, 3), b VECTOR(float, 3));
INSERT INTO vectors SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO vectors SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

-- Compute the pairwise inner product between columns a and b
SELECT VECTOR_INNER_PRODUCT(a, b) FROM vectors;

-- Example 7728
+------+
| 6.3  |
|------|
| 41.2 |
+------+

-- Example 7729
SELECT a, VECTOR_COSINE_SIMILARITY(a, [1,2,3]::VECTOR(FLOAT, 3)) AS similarity
    FROM vectors
ORDER BY similarity DESC
LIMIT 1;

-- Example 7730
+-------------------------+
| [1, 2.2, 3] | 0.9990... |
+-------------------------+

-- Example 7731
import snowflake.connector

conn = ... # Set up connection
cur = conn.cursor()

# Create a table and insert some vectors
cur.execute("CREATE OR REPLACE TABLE vectors (a VECTOR(FLOAT, 3), b VECTOR(FLOAT, 3))")
values = [([1.1, 2.2, 3], [1, 1, 1]), ([1, 2.2, 3], [4, 6, 8])]
for row in values:
        cur.execute(f"""
            INSERT INTO vectors(a, b)
                SELECT {row[0]}::VECTOR(FLOAT,3), {row[1]}::VECTOR(FLOAT,3)
        """)

# Compute the pairwise inner product between columns a and b
cur.execute("SELECT VECTOR_INNER_PRODUCT(a, b) FROM vectors")
print(cur.fetchall())

-- Example 7732
[(6.30...,), (41.2...,)]

-- Example 7733
# Find the closest vector to [1,2,3]
cur.execute(f"""
    SELECT a, VECTOR_COSINE_SIMILARITY(a, {[1,2,3]}::VECTOR(FLOAT, 3))
        AS similarity
        FROM vectors
        ORDER BY similarity DESC
        LIMIT 1;
""")
print(cur.fetchall())

-- Example 7734
[([1.0, 2.2..., 3.0], 0.9990...)]

-- Example 7735
from snowflake.snowpark import Session, Row
session = ... # Set up session
from snowflake.snowpark.types import VectorType, StructType, StructField
from snowflake.snowpark.functions import col, lit, vector_l2_distance
schema = StructType([StructField("vec", VectorType(int, 3))])
data = [Row([1, 2, 3]), Row([4, 5, 6]), Row([7, 8, 9])]
df = session.create_dataframe(data, schema)
df.select(
    "vec",
    vector_l2_distance(df.vec, lit([1, 2, 2]).cast(VectorType(int, 3))).as_("dist"),
).sort("dist").limit(1).show()

-- Example 7736
----------------------
|"VEC"      |"DIST"  |
----------------------
|[1, 2, 3]  |1.0     |
----------------------

-- Example 7737
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(model, text)

-- Example 7738
ALTER TABLE issues ADD COLUMN issue_vec VECTOR(FLOAT, 768);

UPDATE issues
  SET issue_vec = SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', issue_text);

-- Example 7739
SELECT
  issue,
  VECTOR_COSINE_SIMILARITY(
    issue_vec,
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', 'User could not install Facebook app on his phone')
  ) AS similarity
FROM issues
ORDER BY similarity DESC
LIMIT 5
WHERE DATEDIFF(day, CURRENT_DATE(), issue_date) < 90 AND similarity > 0.7;

-- Example 7740
-- Create embedding vectors for wiki articles (only do once)
ALTER TABLE wiki ADD COLUMN vec VECTOR(FLOAT, 768);
UPDATE wiki SET vec = SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', content);

-- Embed incoming query
SET query = 'in which year was Snowflake Computing founded?';
CREATE OR REPLACE TABLE query_table (query_vec VECTOR(FLOAT, 768));
INSERT INTO query_table SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', $query);

-- Do a semantic search to find the relevant wiki for the query
WITH result AS (
    SELECT
        w.content,
        $query AS query_text,
        VECTOR_COSINE_SIMILARITY(w.vec, q.query_vec) AS similarity
    FROM wiki w, query_table q
    ORDER BY similarity DESC
    LIMIT 1
)

-- Pass to large language model as context
SELECT SNOWFLAKE.CORTEX.COMPLETE('mistral-7b',
    CONCAT('Answer this question: ', query_text, ' using this text: ', content)) FROM result;

-- Example 7741
VECTOR_INNER_PRODUCT( <vector>, <vector> )

-- Example 7742
CREATE TABLE vectors (a VECTOR(FLOAT, 3), b VECTOR(FLOAT, 3));
INSERT INTO vectors SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO vectors SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

-- Compute the pairwise inner product between columns a and b
SELECT VECTOR_INNER_PRODUCT(a, b) FROM vectors;

-- Example 7743
+------+
| 6.3  |
|------|
| 41.2 |
+------+

-- Example 7744
VECTOR_L1_DISTANCE( <vector>, <vector> )

-- Example 7745
CREATE TABLE vectors (a VECTOR(FLOAT, 3), b VECTOR(FLOAT, 3));
INSERT INTO vectors SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO vectors SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

SELECT VECTOR_L1_DISTANCE(a, b) FROM vectors;

-- Example 7746
+--------------+
| 3.300000191  |
|--------------|
| 11.800000191 |
+--------------+

-- Example 7747
VECTOR_L2_DISTANCE( <vector>, <vector> )

-- Example 7748
CREATE TABLE vectors (a VECTOR(FLOAT, 3), b VECTOR(FLOAT, 3));
INSERT INTO vectors SELECT [1.1,2.2,3]::VECTOR(FLOAT,3), [1,1,1]::VECTOR(FLOAT,3);
INSERT INTO vectors SELECT [1,2.2,3]::VECTOR(FLOAT,3), [4,6,8]::VECTOR(FLOAT,3);

-- Compute the pairwise inner product between columns a and b
SELECT VECTOR_L2_DISTANCE(a, b) FROM vectors;

-- Example 7749
+------+
| 2.3  |
|------|
| 6.95 |
+------+

-- Example 7750
WAREHOUSE_LOAD_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ]
      [, WAREHOUSE_NAME => '<string>' ] )

-- Example 7751
use warehouse mywarehouse;

select *
from table(information_schema.warehouse_load_history(date_range_start=>dateadd('hour',-1,current_timestamp())));

-- Example 7752
use warehouse mywarehouse;

select *
from table(information_schema.warehouse_load_history(date_range_start=>dateadd('day',-14,current_date()), date_range_end=>current_date()));

