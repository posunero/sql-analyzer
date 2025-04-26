-- Example 9562
SELECT SYSTEM$GET_TAG(
  'SNOWFLAKE.CORE.PRIVACY_CATEGORY',
  'hr_data.fname',
  'COLUMN'
  );

-- Example 9563
USE ROLE ACCOUNTADMIN;

CREATE ROLE trust_center_admin_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_ADMIN TO ROLE trust_center_admin_role;

CREATE ROLE trust_center_viewer_role;
GRANT APPLICATION ROLE SNOWFLAKE.TRUST_CENTER_VIEWER TO ROLE trust_center_viewer_role;

GRANT ROLE trust_center_admin_role TO USER example_admin_user;

GRANT ROLE trust_center_viewer_role TO USER example_nonadmin_user;

-- Example 9564
SELECT start_timestamp,
       end_timestamp,
       scanner_id,
       scanner_short_description,
       impact,
       severity,
       total_at_risk_count,
       AT_RISK_ENTITIES
  FROM snowflake.trust_center.findings
  WHERE scanner_type = 'Threat' AND
        completion_status = 'SUCCEEDED'
  ORDER BY event_id DESC;

-- Example 9565
[
  {
    "entity_detail": {
      "granted_by": joe_smith,
      "grantee_name": "SNOWFLAKE$SUSPICIOUS_ROLE",
      "modified_on": "2025-01-01 07:00:00.000 Z",
      "role_granted": "ACCOUNTADMIN"
    },
    "entity_id": "SNOWFLAKE$SUSPICIOUS_ROLE",
    "entity_name": "SNOWFLAKE$SUSPICIOUS_ROLE",
    "entity_object_type": "ROLE"
  }
]

-- Example 9566
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON WAREHOUSE ai_wh TO ROLE table_owner_role;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE table_owner_role;

-- Example 9567
SELECT CURRENT_ORGANIZATION_NAME() || '-' || CURRENT_ACCOUNT_NAME();

-- Example 9568
SELECT CURRENT_ACCOUNT();

-- Example 9569
SELECT CURRENT_USER();

-- Example 9570
SELECT CURRENT_ROLE();

-- Example 9571
SELECT CURRENT_REGION();

-- Example 9572
SELECT CURRENT_WAREHOUSE();

-- Example 9573
SELECT CURRENT_DATABASE();

-- Example 9574
SELECT CURRENT_SCHEMA();

-- Example 9575
CREATE OR REPLACE WAREHOUSE snowpark_opt_wh WITH
  WAREHOUSE_SIZE = 'MEDIUM'
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED';

-- Example 9576
CREATE WAREHOUSE so_warehouse WITH
  WAREHOUSE_SIZE = 'LARGE'
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86';

-- Example 9577
from snowflake.core import CreateMode
from snowflake.core.warehouse import Warehouse

my_wh = Warehouse(
  name="snowpark_opt_wh",
  warehouse_size="MEDIUM",
  warehouse_type="SNOWPARK-OPTIMIZED"
)
root.warehouses.create(my_wh, mode=CreateMode.or_replace)

-- Example 9578
ALTER WAREHOUSE snowpark_opt_wh SUSPEND;

-- Example 9579
root.warehouses["snowpark_opt_wh"].suspend()

-- Example 9580
ALTER WAREHOUSE so_warehouse SET
  RESOURCE_CONSTRAINT = 'MEMORY_1X_x86';

-- Example 9581
COPY INTO { internalStage | externalStage | externalLocation }
     FROM { [<namespace>.]<table_name> | ( <query> ) }
[ PARTITION BY <expr> ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
                    TYPE = { CSV | JSON | PARQUET } [ formatTypeOptions ] } ) ]
[ copyOptions ]
[ VALIDATION_MODE = RETURN_ROWS ]
[ HEADER ]

-- Example 9582
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 9583
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 9584
externalLocation (for Amazon S3) ::=
  '<protocol>://<bucket>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] [ MASTER_KEY = '<string>' ] |
                   [ TYPE = 'AWS_SSE_S3' ] |
                   [ TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ] ] |
                   [ TYPE = 'NONE' ] ) ]

-- Example 9585
externalLocation (for Google Cloud Storage) ::=
  'gcs://<bucket>[/<path>]'
  [ STORAGE_INTEGRATION = <integration_name> ]
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] | [ TYPE = 'NONE' ] ) ]

-- Example 9586
externalLocation (for Microsoft Azure) ::=
  'azure://<account>.blob.core.windows.net/<container>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = ( [ TYPE = { 'AZURE_CSE' | 'NONE' } ] [ MASTER_KEY = '<string>' ] ) ]

-- Example 9587
formatTypeOptions ::=
-- If FILE_FORMAT = ( TYPE = CSV ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     FILE_EXTENSION = '<string>'
     ESCAPE = '<character>' | NONE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string1>' [ , '<string2>' , ... ] )
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
-- If FILE_FORMAT = ( TYPE = JSON ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     FILE_EXTENSION = '<string>'
-- If FILE_FORMAT = ( TYPE = PARQUET ... )
     COMPRESSION = AUTO | LZO | SNAPPY | NONE
     SNAPPY_COMPRESSION = TRUE | FALSE

-- Example 9588
copyOptions ::=
     OVERWRITE = TRUE | FALSE
     SINGLE = TRUE | FALSE
     MAX_FILE_SIZE = <num>
     INCLUDE_QUERY_ID = TRUE | FALSE
     DETAILED_OUTPUT = TRUE | FALSE

-- Example 9589
-- S3 bucket
COPY INTO 's3://mybucket/./../a.csv' FROM mytable;

-- Google Cloud Storage bucket
COPY INTO 'gcs://mybucket/./../a.csv' FROM mytable;

-- Azure container
COPY INTO 'azure://myaccount.blob.core.windows.net/mycontainer/./../a.csv' FROM mytable;

-- Example 9590
COPY INTO @mystage/data.csv ...

-- Example 9591
COPY INTO @mystage/data.gz ...

COPY INTO @mystage/data.csv.gz ...

-- Example 9592
COPY INTO @%orderstiny/result/data_
  FROM orderstiny FILE_FORMAT = (FORMAT_NAME ='myformat' COMPRESSION='GZIP');

-- Example 9593
COPY INTO @my_stage/result/data_ FROM (SELECT * FROM orderstiny)
   file_format=(format_name='myformat' compression='gzip');

-- Example 9594
COPY INTO 's3://mybucket/unload/'
  FROM mytable
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9595
COPY INTO 's3://mybucket/unload/'
  FROM mytable
  CREDENTIALS = (AWS_KEY_ID='xxxx' AWS_SECRET_KEY='xxxxx' AWS_TOKEN='xxxxxx')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9596
COPY INTO 'gcs://mybucket/unload/'
  FROM mytable
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9597
COPY INTO 'azure://myaccount.blob.core.windows.net/unload/'
  FROM mytable
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9598
COPY INTO 'azure://myaccount.blob.core.windows.net/mycontainer/unload/'
  FROM mytable
  CREDENTIALS=(AZURE_SAS_TOKEN='xxxx')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9599
CREATE or replace TABLE t1 (
  dt date,
  ts time
  )
AS
  SELECT TO_DATE($1)
        ,TO_TIME($2)
    FROM VALUES
           ('2020-01-28', '18:05')
          ,('2020-01-28', '22:57')
          ,('2020-01-28', NULL)
          ,('2020-01-29', '02:15')
;

SELECT * FROM t1;

+------------+----------+
| DT         | TS       |
|------------+----------|
| 2020-01-28 | 18:05:00 |
| 2020-01-28 | 22:57:00 |
| 2020-01-28 | 22:32:00 |
| 2020-01-29 | 02:15:00 |
+------------+----------+

-- Partition the unloaded data by date and hour. Set ``32000000`` (32 MB) as the upper size limit of each file to be generated in parallel per thread.
COPY INTO @%t1
  FROM t1
  PARTITION BY ('date=' || to_varchar(dt, 'YYYY-MM-DD') || '/hour=' || to_varchar(date_part(hour, ts))) -- Concatenate labels and column values to output meaningful filenames
  FILE_FORMAT = (TYPE=parquet)
  MAX_FILE_SIZE = 32000000
  HEADER=true;

LIST @%t1;

+------------------------------------------------------------------------------------------+------+----------------------------------+------------------------------+
| name                                                                                     | size | md5                              | last_modified                |
|------------------------------------------------------------------------------------------+------+----------------------------------+------------------------------|
| __NULL__/data_019c059d-0502-d90c-0000-438300ad6596_006_4_0.snappy.parquet                |  512 | 1c9cb460d59903005ee0758d42511669 | Wed, 5 Aug 2020 16:58:16 GMT |
| date=2020-01-28/hour=18/data_019c059d-0502-d90c-0000-438300ad6596_006_4_0.snappy.parquet |  592 | d3c6985ebb36df1f693b52c4a3241cc4 | Wed, 5 Aug 2020 16:58:16 GMT |
| date=2020-01-28/hour=22/data_019c059d-0502-d90c-0000-438300ad6596_006_6_0.snappy.parquet |  592 | a7ea4dc1a8d189aabf1768ed006f7fb4 | Wed, 5 Aug 2020 16:58:16 GMT |
| date=2020-01-29/hour=2/data_019c059d-0502-d90c-0000-438300ad6596_006_0_0.snappy.parquet  |  592 | 2d40ccbb0d8224991a16195e2e7e5a95 | Wed, 5 Aug 2020 16:58:16 GMT |
+------------------------------------------------------------------------------------------+------+----------------------------------+------------------------------+

-- Example 9600
-- View the table column values
SELECT * FROM HOME_SALES;

+------------+-------+-------+-------------+--------+------------+
| CITY       | STATE | ZIP   | TYPE        | PRICE  | SALE_DATE  |
|------------+-------+-------+-------------+--------+------------|
| Lexington  | MA    | 95815 | Residential | 268880 | 2017-03-28 |
| Belmont    | MA    | 95815 | Residential |        | 2017-02-21 |
| Winchester | MA    | NULL  | Residential |        | 2017-01-31 |
+------------+-------+-------+-------------+--------+------------+

-- Unload the table data into the current user's personal stage. The file format options retain both the NULL value and the empty values in the output file
COPY INTO @~ FROM HOME_SALES
  FILE_FORMAT = (TYPE = csv NULL_IF = ('NULL', 'null') EMPTY_FIELD_AS_NULL = false);

-- Contents of the output file
Lexington,MA,95815,Residential,268880,2017-03-28
Belmont,MA,95815,Residential,,2017-02-21
Winchester,MA,NULL,Residential,,2017-01-31

-- Example 9601
copy into @~ from HOME_SALES
single = true;

-- Example 9602
-- Unload rows from the T1 table into the T1 table stage:
COPY INTO @%t1
  FROM t1
  FILE_FORMAT=(TYPE=parquet)
  INCLUDE_QUERY_ID=true;

-- Retrieve the query ID for the COPY INTO location statement.
-- This optional step enables you to see that the query ID for the COPY INTO location statement
-- is identical to the UUID in the unloaded files.
SELECT last_query_id();
+--------------------------------------+
| LAST_QUERY_ID()                      |
|--------------------------------------|
| 019260c2-00c0-f2f2-0000-4383001cf046 |
+--------------------------------------+

LS @%t1;
+----------------------------------------------------------------+------+----------------------------------+-------------------------------+
| name                                                           | size | md5                              | last_modified                 |
|----------------------------------------------------------------+------+----------------------------------+-------------------------------|
| data_019260c2-00c0-f2f2-0000-4383001cf046_0_0_0.snappy.parquet |  544 | eb2215ec3ccce61ffa3f5121918d602e | Thu, 20 Feb 2020 16:02:17 GMT |
+----------------------------------------------------------------+------+----------------------------------+-------------------------------+

-- Example 9603
COPY INTO @my_stage
  FROM (SELECT * FROM orderstiny LIMIT 5)
  VALIDATION_MODE='RETURN_ROWS';

-- Example 9604
+-----+--------+----+-----------+------------+----------+-----------------+----+---------------------------------------------------------------------------+
|  C1 |   C2   | C3 |    C4     |     C5     |    C6    |       C7        | C8 |                                    C9                                     |
+-----+--------+----+-----------+------------+----------+-----------------+----+---------------------------------------------------------------------------+
|  1  | 36901  | O  | 173665.47 | 1996-01-02 | 5-LOW    | Clerk#000000951 | 0  | nstructions sleep furiously among                                         |
|  2  | 78002  | O  | 46929.18  | 1996-12-01 | 1-URGENT | Clerk#000000880 | 0  |  foxes. pending accounts at the pending\, silent asymptot                 |
|  3  | 123314 | F  | 193846.25 | 1993-10-14 | 5-LOW    | Clerk#000000955 | 0  | sly final accounts boost. carefully regular ideas cajole carefully. depos |
|  4  | 136777 | O  | 32151.78  | 1995-10-11 | 5-LOW    | Clerk#000000124 | 0  | sits. slyly regular warthogs cajole. regular\, regular theodolites acro   |
|  5  | 44485  | F  | 144659.20 | 1994-07-30 | 5-LOW    | Clerk#000000925 | 0  | quickly. bold deposits sleep slyly. packages use slyly                    |
+-----+--------+----+-----------+------------+----------+-----------------+----+---------------------------------------------------------------------------+

-- Example 9605
CREATE TEMPORARY TABLE mytemptable (id NUMBER, creation_date DATE);

-- Example 9606
from snowflake.core.table import Table, TableColumn

my_temp_table = Table(
  name="mytemptable",
  columns=[TableColumn(name="id", datatype="int"),
          TableColumn(name="creation_date", datatype="timestamp_tz")],
  kind="TEMPORARY"
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_temp_table)

-- Example 9607
CREATE TRANSIENT TABLE mytranstable (id NUMBER, creation_date DATE);

-- Example 9608
from snowflake.core.table import Table, TableColumn

my_trans_table = Table(
  name="mytranstable",
  columns=[TableColumn(name="id", datatype="int"),
          TableColumn(name="creation_date", datatype="timestamp_tz")],
  kind="TRANSIENT"
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_trans_table)

-- Example 9609
COPY INTO mytable
  FROM @mystage/myfile.csv.gz
  VALIDATION_MODE=RETURN_ALL_ERRORS;

SET qid=last_query_id();

COPY INTO @mystage/errors/load_errors.txt FROM (SELECT rejected_record FROM TABLE(result_scan($qid)));

-- Example 9610
003139=SQL compilation error:\nIntegration ''{0}'' associated with the stage ''{1}'' cannot be found.

-- Example 9611
snowflake.ingest.error.IngestResponseError: Http Error: 401, Vender Code: 390144, Message: JWT token is invalid.

-- Example 9612
create or replace pipe mypipe as copy into mytable from @mystage;

-- Example 9613
003139=SQL compilation error:\nIntegration ''{0}'' associated with the stage ''{1}'' cannot be found.

-- Example 9614
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override');

-- Example 9615
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override, ownership_transfer_check_override');

-- Example 9616
SELECT TO_DATE(start_time) AS date,
  pipe_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.pipe_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 9617
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.pipe_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 9618
-- Before schema detection and evolution is enabled, the table only consists of two VARIANT columns, RECORD_CONTENT and RECORD_METADATA, as the following example demonstrates.
+------+---------------------------------------------------------+---------------------------------------------------+
| Row  | RECORD_METADATA                                         | RECORD_CONTENT                                    |
|------+---------------------------------------------------------+---------------------------------------------------|
| 1    |{"CreateTime":1669074170090, "headers": {"current.iter...| "account": "ABC123", "symbol": "ZTEST", "side":...|
| 2    |{"CreateTime":1669074170400, "headers": {"current.iter...| "account": "XYZ789", "symbol": "ZABZX", "side":...|
| 3    |{"CreateTime":1669074170659, "headers": {"current.iter...| "account": "XYZ789", "symbol": "ZTEST", "side":...|
| 4    |{"CreateTime":1669074170904, "headers": {"current.iter...| "account": "ABC123", "symbol": "ZABZX", "side":...|
| 5    |{"CreateTime":1669074171063, "headers": {"current.iter...| "account": "ABC123", "symbol": "ZTEST", "side":...|
+------+---------------------------------------------------------+---------------------------------------------------|

-- After schema detection and evolution is enabled, the table contains the columns that match the user-defined schema. The table can also automatically evolve to support the structure of new Snowpipe streaming data loaded by the Kafka connector.
+------+---------------------------------------------------------+---------+--------+-------+----------+
| Row  | RECORD_METADATA                                         | ACCOUNT | SYMBOL | SIDE  | QUANTITY |
|------+---------------------------------------------------------+---------+--------+-------+----------|
| 1    |{"CreateTime":1669074170090, "headers": {"current.iter...| ABC123  | ZTEST  | BUY   | 3572     |
| 2    |{"CreateTime":1669074170400, "headers": {"current.iter...| XYZ789  | ZABZX  | SELL  | 3024     |
| 3    |{"CreateTime":1669074170659, "headers": {"current.iter...| XYZ789  | ZTEST  | SELL  | 799      |
| 4    |{"CreateTime":1669074170904, "headers": {"current.iter...| ABC123  | ZABZX  | BUY   | 2033     |
| 5    |{"CreateTime":1669074171063, "headers": {"current.iter...| ABC123  | ZTEST  | BUY   | 1558     |
+------+---------------------------------------------------------+---------+--------+-------+----------|

-- Example 9619
SELECT PARSE_JSON(NULL) AS "SQL NULL",
       PARSE_JSON('null') AS "JSON NULL",
       PARSE_JSON('[ null ]') AS "JSON NULL",
       PARSE_JSON('{ "a": null }'):a AS "JSON NULL",
       PARSE_JSON('{ "a": null }'):b AS "ABSENT VALUE";

-- Example 9620
+----------+-----------+-----------+-----------+--------------+
| SQL NULL | JSON NULL | JSON NULL | JSON NULL | ABSENT VALUE |
|----------+-----------+-----------+-----------+--------------|
| NULL     | null      | [         | null      | NULL         |
|          |           |   null    |           |              |
|          |           | ]         |           |              |
+----------+-----------+-----------+-----------+--------------+

-- Example 9621
SELECT PARSE_JSON('{ "a": null }'):a,
       TO_CHAR(PARSE_JSON('{ "a": null }'):a);

-- Example 9622
+-------------------------------+----------------------------------------+
| PARSE_JSON('{ "A": NULL }'):A | TO_CHAR(PARSE_JSON('{ "A": NULL }'):A) |
|-------------------------------+----------------------------------------|
| null                          | NULL                                   |
+-------------------------------+----------------------------------------+

-- Example 9623
SELECT ARRAY_CONSTRUCT(1, NULL, PARSE_JSON('null')) AS array_with_null_values;

-- Example 9624
+------------------------+
| ARRAY_WITH_NULL_VALUES |
|------------------------|
| [                      |
|   1,                   |
|   undefined,           |
|   null                 |
| ]                      |
+------------------------+

-- Example 9625
{"foo":1}

-- Example 9626
{"foo":"1"}

-- Example 9627
SELECT column1
  , TO_VARCHAR(PARSE_JSON(column1):a)
FROM
  VALUES('{"a" : null}')
, ('{"b" : "hello"}')
, ('{"a" : "world"}');

+-----------------+-----------------------------------+
| COLUMN1         | TO_VARCHAR(PARSE_JSON(COLUMN1):A) |
|-----------------+-----------------------------------|
| {"a" : null}    | NULL                              |
| {"b" : "hello"} | NULL                              |
| {"a" : "world"} | world                             |
+-----------------+-----------------------------------+

-- Example 9628
import requests
response = requests.get(url,
    headers={
      "User-Agent": "reg-tests",
      "Accept": "*/*",
      "Authorization": """Bearer {}""".format(token)
      },
    allow_redirects=True)
print(response.status_code)
print(response.content)

