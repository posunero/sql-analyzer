-- Example 4807
H3_TRY_GRID_DISTANCE( <cell_id_1> , <cell_id_2> )

-- Example 4808
SELECT H3_TRY_GRID_DISTANCE(582046271372525567, 581883543651614719);

-- Example 4809
+--------------------------------------------------------------+
| H3_TRY_GRID_DISTANCE(582046271372525567, 581883543651614719) |
|--------------------------------------------------------------|
|                                                         NULL |
+--------------------------------------------------------------+

-- Example 4810
H3_TRY_GRID_PATH( <cell_id_1> , <cell_id_2> )

-- Example 4811
SELECT H3_TRY_GRID_PATH('813d7ffffffffff', '81343ffffffffff');

-- Example 4812
+--------------------------------------------------------+
| H3_TRY_GRID_PATH('813D7FFFFFFFFFF', '81343FFFFFFFFFF') |
|--------------------------------------------------------|
| NULL                                                   |
+--------------------------------------------------------+

-- Example 4813
H3_TRY_POLYGON_TO_CELLS( <geography_polygon> , <target_resolution> )

-- Example 4814
SELECT H3_TRY_POLYGON_TO_CELLS(
  TO_GEOGRAPHY('POLYGON((-108.959 40.948,
                         -109.015 37.077,
                         -102.117 36.956,
                         -102.134 40.953,
                         -108.959 40.948))'
              ), 15) AS h3_cells_in_polygon;

-- Example 4815
+---------------------+
| H3_CELLS_IN_POLYGON |
|---------------------|
| NULL                |
+---------------------+

-- Example 4816
H3_TRY_POLYGON_TO_CELLS_STRINGS( <geography_polygon> , <target_resolution> )

-- Example 4817
SELECT H3_TRY_POLYGON_TO_CELLS_STRINGS(
  TO_GEOGRAPHY('POLYGON((-108.959 40.948,
                         -109.015 37.077,
                         -102.117 36.956,
                         -102.134 40.953,
                         -108.959 40.948))'
              ), 15) AS h3_cells_in_polygon;

-- Example 4818
+---------------------+
| H3_CELLS_IN_POLYGON |
|---------------------|
| NULL                |
+---------------------+

-- Example 4819
H3_UNCOMPACT_CELLS( <array_of_cell_ids> , <target_resolution> )

-- Example 4820
SELECT H3_UNCOMPACT_CELLS(
  [
    622236750558396415,
    617733150935089151
  ],
  10
) AS uncompacted;

-- Example 4821
+-----------------------+
| UNCOMPACTED           |
|-----------------------|
| [                     |
|   622236750558396415, |
|   622236750562230271, |
|   622236750562263039, |
|   622236750562295807, |
|   622236750562328575, |
|   622236750562361343, |
|   622236750562394111, |
|   622236750562426879  |
| ]                     |
+-----------------------+

-- Example 4822
H3_UNCOMPACT_CELLS_STRINGS( <array_of_cell_ids> , <target_resolution> )

-- Example 4823
SELECT H3_UNCOMPACT_CELLS_STRINGS(
  [
    '8a2a1072339ffff',
    '892a1072377ffff'
  ],
  10
) AS uncompacted;

-- Example 4824
+----------------------+
| UNCOMPACTED          |
|----------------------|
| [                    |
|   "8a2a1072339ffff", |
|   "8a2a10723747fff", |
|   "8a2a1072374ffff", |
|   "8a2a10723757fff", |
|   "8a2a1072375ffff", |
|   "8a2a10723767fff", |
|   "8a2a1072376ffff", |
|   "8a2a10723777fff"  |
| ]                    |
+----------------------+

-- Example 4825
HASH( <expr> [ , <expr> ... ] )

HASH(*)

-- Example 4826
(mytable.*)

-- Example 4827
(* ILIKE 'col1%')

-- Example 4828
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 4829
(mytable.* ILIKE 'col1%')

-- Example 4830
SELECT HASH(SEQ8()) FROM TABLE(GENERATOR(rowCount=>10));

-- Example 4831
+----------------------+
|         HASH(SEQ8()) |
|----------------------|
| -6076851061503311999 |
| -4730168494964875235 |
| -3690131753453205264 |
| -7287585996956442977 |
| -1285360004004520191 |
|  4801857165282451853 |
| -2112898194861233169 |
|  1885958945512144850 |
| -3994946021335987898 |
| -3559031545629922466 |
+----------------------+

-- Example 4832
SELECT HASH(10), HASH(10::number(38,0)), HASH(10::number(5,3)), HASH(10::float);

-- Example 4833
+---------------------+------------------------+-----------------------+---------------------+
|            HASH(10) | HASH(10::NUMBER(38,0)) | HASH(10::NUMBER(5,3)) |     HASH(10::FLOAT) |
|---------------------+------------------------+-----------------------+---------------------|
| 1599627706822963068 |    1599627706822963068 |   1599627706822963068 | 1599627706822963068 |
+---------------------+------------------------+-----------------------+---------------------+

-- Example 4834
SELECT HASH(10), HASH('10');

-- Example 4835
+---------------------+---------------------+
|            HASH(10) |          HASH('10') |
|---------------------+---------------------|
| 1599627706822963068 | 3622494980440108984 |
+---------------------+---------------------+

-- Example 4836
SELECT HASH(null), HASH(null, null), HASH(null, null, null);

-- Example 4837
+---------------------+--------------------+------------------------+
|          HASH(NULL) |   HASH(NULL, NULL) | HASH(NULL, NULL, NULL) |
|---------------------+--------------------+------------------------|
| 8817975702393619368 | 953963258351104160 |    2941948363845684412 |
+---------------------+--------------------+------------------------+

-- Example 4838
CREATE TABLE orders (order_ID INTEGER, customer_ID INTEGER, order_date ...);

...

SELECT HASH(*) FROM orders LIMIT 10;

-- Example 4839
+-----------------------+
|        HASH(*)        |
|-----------------------|
|  -3527903796973745449 |
|  6296330861892871310  |
|  6918165900200317484  |
|  -2762842444336053314 |
|  -2340602249668223387 |
|  5248970923485160358  |
|  -5807737826218607124 |
|  428973568495579456   |
|  2583438210124219420  |
|  4041917286051184231  |
+ ----------------------+

-- Example 4840
HAVERSINE( <lat1>, <lon1>, <lat2>, <lon2> )

-- Example 4841
SELECT HAVERSINE(40.7127, -74.0059, 34.0500, -118.2500) AS distance;

-- Example 4842
+----------------+
|       DISTANCE |
|----------------|
| 3936.385096389 |
+----------------+

-- Example 4843
HEX_DECODE_BINARY(<input>)

-- Example 4844
CREATE TABLE binary_table (v VARCHAR, b BINARY);
INSERT INTO binary_table (v, b) 
    SELECT 'HELLO', HEX_DECODE_BINARY(HEX_ENCODE('HELLO'));

-- Example 4845
SELECT v, b, HEX_DECODE_STRING(TO_VARCHAR(b)) FROM binary_table;
+-------+------------+----------------------------------+
| V     | B          | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|-------+------------+----------------------------------|
| HELLO | 48454C4C4F | HELLO                            |
+-------+------------+----------------------------------+

-- Example 4846
SELECT HEX_DECODE_BINARY(HEX_ENCODE(MD5_BINARY('Snowflake')));

--------------------------------------------------------+
 HEX_DECODE_BINARY(HEX_ENCODE(MD5_BINARY('SNOWFLAKE'))) |
--------------------------------------------------------+
 EDF1439075A83A447FB8B630DDC9C8DE                       |
--------------------------------------------------------+

-- Example 4847
HEX_DECODE_STRING(<input>)

-- Example 4848
SELECT HEX_DECODE_STRING('536E6F77666C616B65');

-----------------------------------------+
 HEX_DECODE_STRING('536E6F77666C616B65') |
-----------------------------------------+
 Snowflake                               |
-----------------------------------------+

-- Example 4849
SELECT HEX_DECODE_STRING('536e6f77666c616b65');

-----------------------------------------+
 HEX_DECODE_STRING('536E6F77666C616B65') |
-----------------------------------------+
 Snowflake                               |
-----------------------------------------+

-- Example 4850
CREATE TABLE binary_table (v VARCHAR, b BINARY);
INSERT INTO binary_table (v, b) 
    SELECT 'HELLO', HEX_DECODE_BINARY(HEX_ENCODE('HELLO'));

-- Example 4851
SELECT v, b, HEX_DECODE_STRING(TO_VARCHAR(b)) FROM binary_table;
+-------+------------+----------------------------------+
| V     | B          | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|-------+------------+----------------------------------|
| HELLO | 48454C4C4F | HELLO                            |
+-------+------------+----------------------------------+

-- Example 4852
HEX_ENCODE(<input> [, <case>])

-- Example 4853
SELECT HEX_ENCODE('Snowflake');

-------------------------+
 HEX_ENCODE('SNOWFLAKE') |
-------------------------+
 536E6F77666C616B65      |
-------------------------+

-- Example 4854
SELECT HEX_ENCODE('Snowflake',0);

---------------------------+
 HEX_ENCODE('SNOWFLAKE',0) |
---------------------------+
 536e6f77666c616b65        |
---------------------------+

-- Example 4855
HOUR( <time_or_timestamp_expr> )

MINUTE( <time_or_timestamp_expr> )

SECOND( <time_or_timestamp_expr> )

-- Example 4856
SELECT '2025-04-08T23:39:20.123-07:00'::TIMESTAMP AS tstamp,
       HOUR(tstamp) AS "HOUR",
       MINUTE(tstamp) AS "MINUTE",
       SECOND(tstamp) AS "SECOND";

-- Example 4857
+-------------------------+------+--------+--------+
| TSTAMP                  | HOUR | MINUTE | SECOND |
|-------------------------+------+--------+--------|
| 2025-04-08 23:39:20.123 |   23 |     39 |     20 |
+-------------------------+------+--------+--------+

-- Example 4858
ICEBERG_TABLE_FILES(
  TABLE_NAME => '<table_name>'
  [, AT => '<timestamp_ltz>']
)

-- Example 4859
SELECT *
  FROM TABLE(
    INFORMATION_SCHEMA.ICEBERG_TABLE_FILES(
      TABLE_NAME => 'my_iceberg_table'
    )
  );

-- Example 4860
+-------------------------------------------------------+--------------------------------+------------+--------------------------------+------------+------------------+-----------------------------------+-----------------------------------+
| FILE_NAME                                             | REGISTERED_ON                  | FILE_SIZE  | LAST_MODIFIED_ON               | ROW_COUNT  | ROW_GROUP_COUNT  | ETAG                              | MD5                              |
| data/87/snow_D9zlAoeipII_AODxT1uXDxg_0_1_003.parquet  | 1969-12-31 16:00:00.000 -0800  | 27136      | 2024-12-09 11:00:41.000 -0800  | 30000      | 1                | 5cae923b13581f87cf6397ec491fb5d5  | 5cae923b13581f87cf6397ec491fb5d5 |
| data/08/snow_D9zlAoeipII_AODxT1uXDxg_0_1_006.parquet  | 1969-12-31 16:00:00.000 -0800  | 45568      | 2024-12-09 11:00:41.000 -0800  | 45000      | 1                | 3659cb341fec3a57309480d2e1bb7fc3  | 3659cb341fec3a57309480d2e1bb7fc3 |
| data/94/snow_D9zlAoeipII_AODxT1uXDxg_0_1_008.parquet  | 1969-12-31 16:00:00.000 -0800  | 45056      | 2024-12-09 11:00:41.000 -0800  | 45000      | 1                | 5bee899fa8ee60fa668329acae0ed215  | 5bee899fa8ee60fa668329acae0ed215 |
| data/24/snow_D9zlAoeipII_AODxT1uXDxg_0_1_004.parquet  | 1969-12-31 16:00:00.000 -0800  | 27136      | 2024-12-09 11:00:41.000 -0800  | 30000      | 1                | 43a489e450831c717d909a5c79ab9388  | 43a489e450831c717d909a5c79ab9388 |
+-------------------------------------------------------+--------------------------------+------------+--------------------------------+------------+------------------+-----------------------------------+-----------------------------------+

-- Example 4861
SELECT file_name, file_size, row_count, row_group_count, etag, md5
  FROM TABLE(
    INFORMATION_SCHEMA.ICEBERG_TABLE_FILES(
      TABLE_NAME => 'my_iceberg_table',
      AT => CAST('2024-12-09 11:02:00' AS TIMESTAMP_LTZ)
    )
  );

-- Example 4862
+------------------------------------------------------+-----------+-----------+-----------------+----------------------------------+----------------------------------+
| FILE_NAME                                            | FILE_SIZE | ROW_COUNT | ROW_GROUP_COUNT | ETAG                             | MD5                              |
|------------------------------------------------------+-----------+-----------+-----------------+----------------------------------+----------------------------------|
| data/87/snow_D9zlAoeipII_AODxT1uXDxg_0_1_003.parquet |     27136 |     30000 |               1 | 5cae923b13581f87cf6397ec491fb5d5 | 5cae923b13581f87cf6397ec491fb5d5 |
| data/08/snow_D9zlAoeipII_AODxT1uXDxg_0_1_006.parquet |     45568 |     45000 |               1 | 3659cb341fec3a57309480d2e1bb7fc3 | 3659cb341fec3a57309480d2e1bb7fc3 |
| data/94/snow_D9zlAoeipII_AODxT1uXDxg_0_1_008.parquet |     45056 |     45000 |               1 | 5bee899fa8ee60fa668329acae0ed215 | 5bee899fa8ee60fa668329acae0ed215 |
| data/24/snow_D9zlAoeipII_AODxT1uXDxg_0_1_004.parquet |     27136 |     30000 |               1 | 43a489e450831c717d909a5c79ab9388 | 43a489e450831c717d909a5c79ab9388 |
+------------------------------------------------------+-----------+-----------+-----------------+----------------------------------+----------------------------------+
4 Row(s) produced. Time Elapsed: 1.502s

-- Example 4863
ICEBERG_TABLE_SNAPSHOT_REFRESH_HISTORY(
  TABLE_NAME => '<table_name>'
)

-- Example 4864
SELECT *
  FROM TABLE(INFORMATION_SCHEMA.ICEBERG_TABLE_SNAPSHOT_REFRESH_HISTORY(
    TABLE_NAME => 'my_iceberg_table'
  ));

-- Example 4865
+-------------------------------+----------------------------------------------------------------------------------+---------------------+-----------------+-------------------+--------------------------------------+---------------------+---------------------------------+
| REFRESHED_ON                  | METADATA_FILE_NAME                                                               | SNAPSHOT_ID         | SEQUENCE_NUMBER | ICEBERG_SCHEMA_ID | QUERY_ID                             | IS_CURRENT_SNAPSHOT | SNAPSHOT_SUMMARY                |
|-------------------------------+----------------------------------------------------------------------------------+---------------------+-----------------+-------------------+--------------------------------------+---------------------+---------------------------------|
| 2024-12-09 11:00:50.506 -0800 | s3://my-bucket/metadata/00000-e3bf7230-283f-4626-a770-fe97a3ca239e.metadata.json | NULL                | NULL            | 0                 | 01b8ebb4-0002-3a10-0000-012903c7e42a | False               | NULL                            |
| 2024-12-09 11:01:35.543 -0800 | s3://my-bucket/metadata/00001-bf116652-b5b0-479a-947e-6c799e4ca124.metadata.json | 6201065399847600377 | NULL            | 0                 | 01b8ebb5-0002-3a14-0000-012903c7f336 | True                | {                               |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "added-data-files": "4",      |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "added-files-size": "144896", |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "added-records": "150000",    |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "manifests-created": "1",     |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "manifests-kept": "0",        |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "manifests-replaced": "0",    |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "total-data-files": "4",      |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "total-files-size": "144896", |
|                               |                                                                                  |                     |                 |                   |                                      |                     |   "total-records": "150000"     |
|                               |                                                                                  |                     |                 |                   |                                      |                     | }                               |
+-------------------------------+----------------------------------------------------------------------------------+---------------------+-----------------+-------------------+--------------------------------------+---------------------+---------------------------------+

-- Example 4866
IFF( <condition> , <expr1> , <expr2> )

-- Example 4867
SELECT IFF(TRUE, 'true', 'false');

-- Example 4868
+----------------------------+
| IFF(TRUE, 'TRUE', 'FALSE') |
|----------------------------|
| true                       |
+----------------------------+

-- Example 4869
SELECT IFF(FALSE, 'true', 'false');

-- Example 4870
+-----------------------------+
| IFF(FALSE, 'TRUE', 'FALSE') |
|-----------------------------|
| false                       |
+-----------------------------+

-- Example 4871
SELECT IFF(NULL, 'true', 'false');

-- Example 4872
+----------------------------+
| IFF(NULL, 'TRUE', 'FALSE') |
|----------------------------|
| false                      |
+----------------------------+

-- Example 4873
SELECT IFF(TRUE, NULL, 'false');

