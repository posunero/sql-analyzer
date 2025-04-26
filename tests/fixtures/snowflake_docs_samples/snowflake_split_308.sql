-- Example 20614
formatTypeOptions ::=
-- If FILE_FORMAT = ( TYPE = CSV ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
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
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If FILE_FORMAT = ( TYPE = JSON ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If FILE_FORMAT = ( TYPE = AVRO ... )
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = ORC ... )
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = PARQUET ... )
     COMPRESSION = AUTO | SNAPPY | NONE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = XML ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 20615
copyOptions ::=
     ON_ERROR = { CONTINUE | SKIP_FILE | SKIP_FILE_<num> | 'SKIP_FILE_<num>%' | ABORT_STATEMENT }
     SIZE_LIMIT = <num>
     PURGE = TRUE | FALSE
     RETURN_FAILED_ONLY = TRUE | FALSE
     MATCH_BY_COLUMN_NAME = CASE_SENSITIVE | CASE_INSENSITIVE | NONE
     INCLUDE_METADATA = ( <column_name> = METADATA$<field> [ , <column_name> = METADATA${field} ... ] )
     ENFORCE_LENGTH = TRUE | FALSE
     TRUNCATECOLUMNS = TRUE | FALSE
     FORCE = TRUE | FALSE
     LOAD_UNCERTAIN_FILES = TRUE | FALSE
     FILE_PROCESSOR = (SCANNER = <custom_scanner_type> SCANNER_OPTIONS = (<scanner_options>))
     LOAD_MODE = { FULL_INGEST | ADD_FILES_COPY }

-- Example 20616
-- S3 bucket
COPY INTO mytable FROM 's3://mybucket/./../a.csv';

-- Google Cloud Storage bucket
COPY INTO mytable FROM 'gcs://mybucket/./../a.csv';

-- Azure container
COPY INTO mytable FROM 'azure://myaccount.blob.core.windows.net/mycontainer/./../a.csv';

-- Example 20617
|"Hello world"|
|" Hello world "|
| "Hello world" |

-- Example 20618
+---------------+
| C1            |
|----+----------|
| Hello world   |
|  Hello world  |
| Hello world   |
+---------------+

-- Example 20619
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 20620
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

-- Example 20621
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

-- Example 20622
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

-- Example 20623
COPY INTO [<namespace>.]<table_name> [ ( <col_name> [ , <col_name> ... ] ) ]
FROM ( SELECT [<alias>.]$<file_col_num>[.<element>] [ , [<alias>.]$<file_col_num>[.<element>] ... ]
    FROM { internalStage | externalStage } )
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
            TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
MATCH_BY_COLUMN_NAME = CASE_SENSITIVE | CASE_INSENSITIVE | NONE
[ other copyOptions ]

-- Example 20624
COPY INTO table1 FROM @stage1
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
INCLUDE_METADATA = (
    ingestdate = METADATA$START_SCAN_TIME, filename = METADATA$FILENAME);

-- Example 20625
+-----+-----------------------+---------------------------------+-----+
| ... | FILENAME              | INGESTDATE                      | ... |
|---------------------------------------------------------------+-----|
| ... | example_file.json.gz  | Thu, 22 Feb 2024 19:14:55 +0000 | ... |
+-----+-----------------------+---------------------------------+-----+

-- Example 20626
LIST @my_gcs_stage;

+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Sep 2019 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Sep 2019 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 20627
COPY INTO mytable
FROM @my_int_stage;

-- Example 20628
COPY INTO mytable
FILE_FORMAT = (TYPE = CSV);

-- Example 20629
COPY INTO mytable from @~/staged
FILE_FORMAT = (FORMAT_NAME = 'mycsv');

-- Example 20630
COPY INTO mycsvtable
  FROM @my_ext_stage/tutorials/dataloading/contacts1.csv;

-- Example 20631
COPY INTO mytable
  FROM @my_ext_stage/tutorials/dataloading/sales.json.gz
  FILE_FORMAT = (TYPE = 'JSON')
  MATCH_BY_COLUMN_NAME='CASE_INSENSITIVE';

-- Example 20632
COPY INTO mytable
  FROM s3://mybucket/data/files
  STORAGE_INTEGRATION = myint
  ENCRYPTION=(MASTER_KEY = 'eSx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 20633
COPY INTO mytable
  FROM s3://mybucket/data/files
  CREDENTIALS=(AWS_KEY_ID='$AWS_ACCESS_KEY_ID' AWS_SECRET_KEY='$AWS_SECRET_ACCESS_KEY')
  ENCRYPTION=(MASTER_KEY = 'eSx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 20634
COPY INTO mytable
  FROM 'gcs://mybucket/data/files'
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 20635
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/data/files'
  STORAGE_INTEGRATION = myint
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 20636
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/mycontainer/data/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 20637
COPY INTO mytable
  FILE_FORMAT = (TYPE = 'CSV')
  PATTERN='.*/.*/.*[.]csv[.]gz';

-- Example 20638
COPY INTO mytable
  FILE_FORMAT = (FORMAT_NAME = myformat)
  PATTERN='.*sales.*[.]csv';

-- Example 20639
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

-- Example 20640
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

-- Example 20641
COPY INTO load1 FROM @%load1/data1/
    FILES=('test1.csv', 'test2.csv');

COPY INTO load1 FROM @%load1/data1/
    FILES=('test1.csv', 'test2.csv')
    FORCE=TRUE;

-- Example 20642
ALTER TABLE mytable SET STAGE_COPY_OPTIONS = (PURGE = TRUE);

COPY INTO mytable;

-- Example 20643
COPY INTO mytable PURGE = TRUE;

-- Example 20644
COPY INTO mytable VALIDATION_MODE = 'RETURN_ERRORS';

+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+
|                                                         ERROR                                                                 |            FILE        | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |  CODE  | SQL_STATE |   COLUMN_NAME        | ROW_NUMBER | ROW_START_LINE |
+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+
| Field delimiter ',' found while expecting record delimiter '\n'                                                               | @MYTABLE/data1.csv.gz  | 3    | 21        | 76          | parsing  | 100016 | 22000     | "MYTABLE"["QUOTA":3] | 3          | 3              |
| NULL result in a non-nullable column. Use quotes if an empty field should be interpreted as an empty string instead of a null | @MYTABLE/data3.csv.gz  | 3    | 2         | 62          | parsing  | 100088 | 22000     | "MYTABLE"["NAME":1]  | 3          | 3              |
| End of record reached while expected to parse column '"MYTABLE"["QUOTA":3]'                                                   | @MYTABLE/data3.csv.gz  | 4    | 20        | 96          | parsing  | 100068 | 22000     | "MYTABLE"["QUOTA":3] | 4          | 4              |
+-------------------------------------------------------------------------------------------------------------------------------+------------------------+------+-----------+-------------+----------+--------+-----------+----------------------+------------+----------------+

-- Example 20645
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

-- Example 20646
CREATE OR REPLACE FILE FORMAT my_parquet_format
  TYPE = PARQUET
  USE_VECTORIZED_SCANNER = TRUE;

-- Example 20647
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

-- Example 20648
COPY INTO customer_iceberg_ingest
  FROM @my_parquet_stage
  FILE_FORMAT = 'my_parquet_format'
  LOAD_MODE = ADD_FILES_COPY
  PURGE = TRUE
  MATCH_BY_COLUMN_NAME = CASE_SENSITIVE;

-- Example 20649
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                          | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_008.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_006.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_005.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_002.parquet | LOADED |           5 |           5 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| my_parquet_stage/snow_af9mR2HShTY_AABspxOVwhc_0_1_010.parquet | LOADED |       15000 |       15000 |           0 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 20650
SELECT
    c_custkey,
    c_name,
    c_mktsegment
  FROM customer_iceberg_ingest
  LIMIT 10;

-- Example 20651
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

-- Example 20652
PUT file://<absolute_path_to_file>/<filename> internalStage
    [ PARALLEL = <integer> ]
    [ AUTO_COMPRESS = TRUE | FALSE ]
    [ SOURCE_COMPRESSION = AUTO_DETECT | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE ]
    [ OVERWRITE = TRUE | FALSE ]

-- Example 20653
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 20654
PUT file:///tmp/data/** @my_int_stage AUTO_COMPRESS=FALSE;

-- Example 20655
PUT file:///tmp/data/mydata.csv @my_int_stage;

-- Example 20656
PUT file:///tmp/data/orders_001.csv @%orderstiny_ext
  AUTO_COMPRESS = FALSE;

-- Example 20657
PUT file:///tmp/data/orders_*01.csv @my_int_stage
  AUTO_COMPRESS = FALSE;

-- Example 20658
PUT 'file:///tmp/data/orders 001.csv' @my_int_stage
  AUTO_COMPRESS = FALSE;

-- Example 20659
PUT file://C:\temp\data\mydata.csv @~
  AUTO_COMPRESS = TRUE;

-- Example 20660
PUT 'file://C:/temp/data/my data.csv' @my_int_stage
  AUTO_COMPRESS = TRUE;

-- Example 20661
GET /api/v2/statements/{statementHandle}

-- Example 20662
{
  "code": "090001",
  "sqlState": "00000",
  "message": "successfully executed",
  "statementHandle": "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl": "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 20663
{
  ...
  "statementHandles" : [ "019c9fce-0502-f1fc-0000-438300e02412", "019c9fce-0502-f1fc-0000-438300e02416" ],
  ...
}

-- Example 20664
curl -i -X GET \
    -H "Authorization: Bearer <jwt>" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "User-Agent: myApplicationName/1.0" \
    "https://<account_identifier>.snowflakecomputing.com/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"

-- Example 20665
{
  "code": "090001",
  "statementHandle": "536fad38-b564-4dc5-9892-a4543504df6c",
  "sqlState": "00000",
  "message": "successfully executed",
  "createdOn": 1597090533987,
  "statementStatusUrl": "/api/v2/statements/536fad38-b564-4dc5-9892-a4543504df6c",
  "resultSetMetaData" : {
    "numRows" : 50000,
    "format" : "jsonv2",
    "partitionInfo" : [ {
      "rowCount" : 12288,
      "uncompressedSize" : 124067,
      "compressedSize" : 29591
    }, {
      "rowCount" : 37712,
      "uncompressedSize" : 414841,
      "compressedSize" : 84469
    }],
  },
  "data": [
    ["customer1", "1234 A Avenue", "98765", "2021-01-20
    12:34:56.03459878"],
    ["customer2", "987 B Street", "98765", "2020-05-31
    01:15:43.765432134"],
    ["customer3", "8777 C Blvd", "98765", "2019-07-01
    23:12:55.123467865"],
    ["customer4", "64646 D Circle", "98765", "2021-08-03
    13:43:23.0"]
  ]
}

-- Example 20666
{
 "resultSetMetaData": {
  "numRows": 1300,
  "rowType": [
   {
    "name":"ROWNUM",
    "type":"FIXED",
    "length":0,
    "precision":38,
    "scale":0,
    "nullable":false
   }, {
    "name":"ACCOUNT_NAME",
    "type":"TEXT",
    "length":1024,
    "precision":0,
    "scale":0,
    "nullable":false
   }, {
    "name":"ADDRESS",
    "type":"TEXT",
    "length":16777216,
    "precision":0,
    "scale":0,
    "nullable":true
   }, {
    "name":"ZIP",
    "type":"TEXT",
    "length":100,
    "precision":0,
    "scale":0,
    "nullable":true
   }, {
    "name":"CREATED_ON",
    "type":"TIMESTAMP_NTZ",
    "length":0,
    "precision":0,
    "scale":3,
    "nullable":false
   }],
  "partitionInfo": [{
    ... // Partition metadata
  }]
 }
}

-- Example 20667
{
    "resultSetMetaData": {
    "numRows: 103477,
    "format": "jsonv2"
    "rowType": {
      ... // Column metadata.
    },
    "partitionInfo": [{
        "rowCount": 12344,
        "uncompressedSize": 14384873,
      },{
        "rowCount": 47387,
        "uncompressedSize": 76483423,
        "compressedSize": 4342748
      },{
        "rowCount": 43746,
        "uncompressedSize": 43748274,
        "compressedSize": 746323
    }]
  },
  ...
}

-- Example 20668
{
  ...
  "data": [
    ["customer1", "1234 A Avenue", "98765", "2021-01-20 12:34:56.03459878"],
    ["customer2", "987 B Street", "98765", "2020-05-31 01:15:43.765432134"],
    ["customer3", "8777 C Blvd", "98765", "2019-07-01 23:12:55.123467865"],
    ["customer4", "64646 D Circle", "98765", "2021-08-03 13:43:23.0"]
  ],
  ...
}

-- Example 20669
GET /api/v2/statements/<handle>?partition=1

-- Example 20670
"data" : [ [ null ], ... ]

-- Example 20671
POST /api/v2/statements?nullable=false

-- Example 20672
"data" : [ [ "null" ], ... ]

-- Example 20673
{
  "statement": "select date_column from mytable",
  "resultSetMetaData": {
    "format": "jsonv2",
  },
  "parameters": {
    "DATE_OUTPUT_FORMAT": "MM/DD/YYYY"
  }
  ...
}

-- Example 20674
CREATE OR REPLACE TABLE sample_product_data (id INT, parent_id INT, category_id INT, name VARCHAR, serial_number VARCHAR, key INT, "3rd" INT);
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

-- Example 20675
SELECT * FROM sample_product_data;

-- Example 20676
// Create a DataFrame from the data in the "sample_product_data" table.
val dfTable = session.table("sample_product_data")

// To print out the first 10 rows, call:
//   dfTable.show()

-- Example 20677
// Create a DataFrame containing a sequence of values.
// In the DataFrame, name the columns "i" and "s".
val dfSeq = session.createDataFrame(Seq((1, "one"), (2, "two"))).toDF("i", "s")

-- Example 20678
// Create a DataFrame from a range
val dfRange = session.range(1, 10, 2)

-- Example 20679
// Create a DataFrame from data in a stage.
val dfJson = session.read.json("@mystage2/data1.json")

-- Example 20680
// Create a DataFrame from a SQL query
val dfSql = session.sql("SELECT name from products")

