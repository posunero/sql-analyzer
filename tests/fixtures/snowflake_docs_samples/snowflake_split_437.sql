-- Example 29253
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29254
CREATE or REPLACE FILE FORMAT xml_format TYPE = XML;

CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR) AS
  SELECT $1 AS XML
    FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format');

-- Example 29255
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29256
100078 (22000): String '<string_preview>' is too long and would be truncated

-- Example 29257
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1::VARCHAR
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format'));

-- Example 29258
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29259
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29260
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1:"Driver_Status"
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format'));

-- Example 29261
100069 (22P02): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29262
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29263
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar FROM (
  SELECT $1::VARCHAR AS lob_column
    FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format'));

-- Example 29264
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29265
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29266
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar (lob_column)
  FROM @lob_int_stage/driver_status.json.gz
  FILE_FORMAT = (FORMAT_NAME = json_format);

-- Example 29267
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29268
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29269
CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR);

COPY INTO table_varchar (lob_column)
  FROM @lob_int_stage/large_xml.xte
  FILE_FORMAT = (FORMAT_NAME = xml_format);

-- Example 29270
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29271
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29272
SELECT $1
  FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format');

-- Example 29273
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

-- Example 29274
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29275
SELECT $1 as lob_column
  FROM @lob_int_stage/large_xml.xte (FILE_FORMAT => 'xml_format');

-- Example 29276
100100 (22P02): Error parsing XML: document is too large, max size 16777216 bytes

-- Example 29277
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29278
SELECT $1
  FROM @lob_int_stage/driver_status.csv.gz (FILE_FORMAT => 'csv_format');

-- Example 29279
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29280
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29281
SELECT $1
  FROM @lob_int_stage/driver_status.parquet (FILE_FORMAT => 'parquet_format');

-- Example 29282
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <object_size>

-- Example 29283
100082 (22000): The data length in result column $1 is not supported by this version of the client. Actual length <actual_length> exceeds supported length of 16777216.

-- Example 29284
SELECT large_str || large_str FROM lob_strings;

-- Example 29285
100078 (22000): String '<preview_of_string>' is too long and would be truncated in 'CONCAT'

-- Example 29286
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29287
CREATE OR REPLACE TABLE table_varchar
  AS SELECT large_str || large_str as LOB_column
  FROM lob_strings;

-- Example 29288
100078 (22000): String '<preview_of_string>' is too long and would be truncated in 'CONCAT'

-- Example 29289
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29290
SELECT ARRAY_AGG(status) FROM lob_object;

-- Example 29291
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is <actual_size>

-- Example 29292
100067 (54000): The data length in result column <column_name> is not supported by this version of the client. Actual length <actual_size> exceeds supported length of 16777216.

-- Example 29293
CREATE SCHEMA dst CLONE src;
CREATE DATABASE dst CLONE src
  BEFORE (STATEMENT => '01b7676a-0002-d908-0000-a99500f6e00e');

-- Example 29294
CREATE DATABASE dst CLONE src;

-- Example 29295
CREATE SCHEMA dst CLONE src;

-- Example 29296
392105 (0A000): SQL execution error: Cloning a SCHEMA which contains a HYBRID TABLE is unsupported. To perform the clone while skipping HYBRID TABLES, append the `IGNORE HYBRID TABLES` syntax to your DDL.

-- Example 29297
CREATE SCHEMA dst CLONE src IGNORE HYBRID TABLES;

-- Example 29298
CREATE DATABASE dst CLONE src;

-- Example 29299
CREATE DATABASE dst CLONE src
  BEFORE (STATEMENT => '01b7676a-0002-d908-0000-a99500f6e00e');

-- Example 29300
392106 (0A000): SQL execution error: Time Travel cloning a DATABASE which contains a HYBRID TABLE, when specifying the time via a `STATEMENT` is unsupported. To perform the clone while skipping HYBRID TABLES, append the `IGNORE HYBRID TABLES` syntax to your DDL.

-- Example 29301
CREATE DATABASE dst CLONE src
  BEFORE (STATEMENT => '01b7676a-0002-d908-0000-a99500f6e00e')
  IGNORE HYBRID TABLES;

-- Example 29302
CREATE OR REPLACE DYNAMIC ICEBERG TABLE iceberg_dt (id int)
  WAREHOUSE = mywh
  TARGET_LAG = 'downstream'
  EXTERNAL_VOLUME = 'iceberg_default_volume'
  BASE_LOCATION = 'my_base_location'
  CATALOG = 'snowflake'
  AS
    SELECT id FROM base_table;

-- Example 29303
CREATE OR REPLACE USER nulltest DISPLAY_NAME = 'iamnull';

-- Example 29304
CREATE OR REPLACE USER nulltest DISPLAY_NAME = 'iamnull';

-- Example 29305
SELECT query_history.*
FROM snowflake.account_usage.query_history
WHERE user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service-name>'
AND user_database_name = '<service-db-name>'
AND user_schema_name = '<service-schema-name>'
order by start_time;

-- Example 29306
SELECT *
FROM TABLE(<any-user-db-name>.information_schema.query_history())
WHERE user_database_name = '<service-db-name>'
AND user_schema_name = '<service-schema-name>'
AND user_type = 'SNOWFLAKE_SERVICE'
AND user_name = '<service-name>'
order by start_time;

-- Example 29307
SELECT query_history.*, services.*
FROM snowflake.account_usage.query_history
JOIN snowflake.account_usage.services
ON query_history.user_name = services.service_name
AND query_history.user_schema_id = services.service_schema_id
AND query_history.user_type = 'SNOWFLAKE_SERVICE'

-- Example 29308
SELECT services.*, users.*
FROM snowflake.account_usage.users
JOIN snowflake.account_usage.services
ON users.name = services.service_name
AND users.schema_id = services.service_schema_id
AND users.type = 'SNOWFLAKE_SERVICE'

-- Example 29309
SELECT (
   SUM(credits_used_compute) -
   SUM(credits_attributed_compute_queries)
) AS idle_cost,
    warehouse_name
 FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
    WHERE start_time >= DATEADD('days', -10, CURRENT_DATE())
          AND end_time < CURRENT_DATE()
    GROUP BY warehouse_name;

-- Example 29310
ALTER ACCOUNT SET EVENT_TABLE = NONE

-- Example 29311
CREATE OR REPLACE FUNCTION udf_varchar(g1 VARCHAR)
  RETURNS VARCHAR
  AS $$
    'Hello' || g1
  $$;

-- Example 29312
SELECT GET_DDL('function', 'udf_varchar(VARCHAR)');

-- Example 29313
CREATE OR REPLACE FUNCTION "UDF_VARCHAR"("G1" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS '
  ''Hello'' || g1
';

-- Example 29314
CREATE OR REPLACE FUNCTION "UDF_VARCHAR"("G1" VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS '
  ''Hello'' || g1
';

-- Example 29315
DESCRIBE FUNCTION udf_varchar(VARCHAR);

-- Example 29316
+-----------+-------------------+
| property  | value             |
|-----------+-------------------|
| signature | (G1 VARCHAR)      |
| returns   | VARCHAR(16777216) |
| language  | SQL               |
| body      |                   |
|           |   'Hello' || g1   |
|           |                   |
+-----------+-------------------+

-- Example 29317
+-----------+-------------------+
| property  | value             |
|-----------+-------------------|
| signature | (G1 VARCHAR)      |
| returns   | VARCHAR           |
| language  | SQL               |
| body      |                   |
|           |   'Hello' || g1   |
|           |                   |
+-----------+-------------------+

-- Example 29318
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "UDF_VARCHAR(X VARCHAR):VARCHAR(16777216)",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

-- Example 29319
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "UDF_VARCHAR(X VARCHAR):VARCHAR",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

