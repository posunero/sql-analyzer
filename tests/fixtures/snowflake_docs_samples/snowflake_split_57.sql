-- Example 3802
-- Create a table that stores the relative file path for each staged file along with any other related data.
CREATE TABLE acct_table (
  acct_name string,
  relative_file_path string
);

-- Create a secure view on the table you created.
-- A role that has the SELECT privilege on the secure view has scoped access to the filtered set of files that include the acct1 text string.
CREATE SECURE VIEW acct1_files
AS
  SELECT BUILD_SCOPED_FILE_URL(@acct_files, relative_file_path, FALSE) scoped_url
  FROM acct_table
  WHERE acct_name = 'acct1';

-- Example 3803
BUILD_STAGE_FILE_URL( @<stage_name> , '<relative_file_path>' )

-- Example 3804
https://<account_identifier>/api/files/<db_name>/<schema_name>/<stage_name>/<relative_path>

-- Example 3805
SELECT BUILD_STAGE_FILE_URL(@images_stage,'/us/yosemite/half_dome.jpg');

-- Example 3806
https://my_account.snowflakecomputing.com/api/files/MY_DB/PUBLIC/IMAGES_STAGE/us/yosemite/half_dome.jpg

-- Example 3807
CASE
    WHEN <condition1> THEN <result1>
  [ WHEN <condition2> THEN <result2> ]
  [ ... ]
  [ ELSE <result3> ]
END

CASE <expr>
    WHEN <value1> THEN <result1>
  [ WHEN <value2> THEN <result2> ]
  [ ... ]
  [ ELSE <result3> ]
END

-- Example 3808
CASE
    WHEN <condition1> THEN <result1>
  [ WHEN <condition2> THEN <result2> ]

-- Example 3809
CASE <expr>
    WHEN <value1> THEN <result1>
  [ WHEN <value2> THEN <result2> ]
  ...

-- Example 3810
SELECT
    column1,
    CASE
        WHEN column1=1 THEN 'one'
        WHEN column1=2 THEN 'two'
        ELSE 'other'
    END AS result
FROM (values(1),(2),(3)) v;

-- Example 3811
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|       3 | other  |
+---------+--------+

-- Example 3812
SELECT
    column1,
    CASE
        WHEN column1=1 THEN 'one'
        WHEN column1=2 THEN 'two'
    END AS result
FROM (values(1),(2),(3)) v;

-- Example 3813
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|       3 | NULL   |
+---------+--------+

-- Example 3814
SELECT
    column1,
    CASE 
        WHEN column1 = 1 THEN 'one'
        WHEN column1 = 2 THEN 'two'
        WHEN column1 IS NULL THEN 'NULL'
        ELSE 'other'
    END AS result
FROM VALUES (1), (2), (NULL);

-- Example 3815
+---------+--------+
| COLUMN1 | RESULT |
|---------+--------|
|       1 | one    |
|       2 | two    |
|    NULL | NULL   |
+---------+--------+

-- Example 3816
SELECT CASE COLLATE('m', 'upper')
    WHEN 'M' THEN TRUE
    ELSE FALSE
END;

-- Example 3817
+----------------------------+
| CASE COLLATE('M', 'UPPER') |
|     WHEN 'M' THEN TRUE     |
|     ELSE FALSE             |
| END                        |
|----------------------------|
| True                       |
+----------------------------+

-- Example 3818
SELECT CASE 'm'
    WHEN COLLATE('M', 'lower') THEN TRUE
    ELSE FALSE
END;

-- Example 3819
+------------------------------------------+
| CASE 'M'                                 |
|     WHEN COLLATE('M', 'LOWER') THEN TRUE |
|     ELSE FALSE                           |
| END                                      |
|------------------------------------------|
| True                                     |
+------------------------------------------+

-- Example 3820
CAST( <source_expr> AS <target_data_type> )
  [ RENAME FIELDS | ADD FIELDS ]

<source_expr> :: <target_data_type>

-- Example 3821
CREATE OR REPLACE TABLE test_data_type_conversion (
  varchar_value VARCHAR,
  number_value NUMBER(5, 4),
  timestamp_value TIMESTAMP);

INSERT INTO test_data_type_conversion VALUES (
  '9.8765',
  1.2345,
  '2024-05-09 14:32:29.135 -0700');

SELECT * FROM test_data_type_conversion;

-- Example 3822
+---------------+--------------+-------------------------+
| VARCHAR_VALUE | NUMBER_VALUE | TIMESTAMP_VALUE         |
|---------------+--------------+-------------------------|
| 9.8765        |       1.2345 | 2024-05-09 14:32:29.135 |
+---------------+--------------+-------------------------+

-- Example 3823
SELECT CAST(varchar_value AS NUMBER(5,2)) AS varchar_to_number1,
       SYSTEM$TYPEOF(varchar_to_number1) AS data_type
  FROM test_data_type_conversion;

-- Example 3824
+--------------------+------------------+
| VARCHAR_TO_NUMBER1 | DATA_TYPE        |
|--------------------+------------------|
|               9.88 | NUMBER(5,2)[SB4] |
+--------------------+------------------+

-- Example 3825
SELECT varchar_value::NUMBER(6,5) AS varchar_to_number2,
       SYSTEM$TYPEOF(varchar_to_number2) AS data_type
  FROM test_data_type_conversion;

-- Example 3826
+--------------------+------------------+
| VARCHAR_TO_NUMBER2 | DATA_TYPE        |
|--------------------+------------------|
|            9.87650 | NUMBER(6,5)[SB4] |
+--------------------+------------------+

-- Example 3827
SELECT CAST(number_value AS INTEGER) AS number_to_integer,
       SYSTEM$TYPEOF(number_to_integer) AS data_type
  FROM test_data_type_conversion;

-- Example 3828
+-------------------+-------------------+
| NUMBER_TO_INTEGER | DATA_TYPE         |
|-------------------+-------------------|
|                 1 | NUMBER(38,0)[SB1] |
+-------------------+-------------------+

-- Example 3829
SELECT CAST(number_value AS VARCHAR) AS number_to_varchar,
       SYSTEM$TYPEOF(number_to_varchar) AS data_type
  FROM test_data_type_conversion;

-- Example 3830
+-------------------+------------------------+
| NUMBER_TO_VARCHAR | DATA_TYPE              |
|-------------------+------------------------|
| 1.2345            | VARCHAR(16777216)[LOB] |
+-------------------+------------------------+

-- Example 3831
SELECT CAST(timestamp_value AS DATE) AS timestamp_to_date,
       SYSTEM$TYPEOF(timestamp_to_date) AS data_type
  FROM test_data_type_conversion;

-- Example 3832
+-------------------+-----------+
| TIMESTAMP_TO_DATE | DATA_TYPE |
|-------------------+-----------|
| 2024-05-09        | DATE[SB4] |
+-------------------+-----------+

-- Example 3833
CBRT(expr)

-- Example 3834
SELECT x, cbrt(x) FROM tab;

--------+-------------+
   x    |   cbrt(x)   |
--------+-------------+
 0      | 0           |
 2      | 1.25992105  |
 -10    | -2.15443469 |
 [NULL] | [NULL]      |
--------+-------------+

-- Example 3835
CEIL( <input_expr> [, <scale_expr> ] )

-- Example 3836
SELECT CEIL(135.135), CEIL(-975.975);
+---------------+----------------+
| CEIL(135.135) | CEIL(-975.975) |
|---------------+----------------|
|           136 |           -975 |
+---------------+----------------+

-- Example 3837
CREATE TRANSIENT TABLE test_ceiling (n FLOAT, scale INTEGER);
INSERT INTO test_ceiling (n, scale) VALUES
   (-975.975, -1),
   (-975.975,  0),
   (-975.975,  2),
   ( 135.135, -2),
   ( 135.135,  0),
   ( 135.135,  1),
   ( 135.135,  3),
   ( 135.135, 50),
   ( 135.135, NULL)
   ;

-- Example 3838
SELECT n, scale, ceil(n, scale)
  FROM test_ceiling
  ORDER BY n, scale;
+----------+-------+----------------+
|        N | SCALE | CEIL(N, SCALE) |
|----------+-------+----------------|
| -975.975 |    -1 |       -970     |
| -975.975 |     0 |       -975     |
| -975.975 |     2 |       -975.97  |
|  135.135 |    -2 |        200     |
|  135.135 |     0 |        136     |
|  135.135 |     1 |        135.2   |
|  135.135 |     3 |        135.135 |
|  135.135 |    50 |        135.135 |
|  135.135 |  NULL |           NULL |
+----------+-------+----------------+

-- Example 3839
CHARINDEX( <expr1>, <expr2> [ , <start_pos> ] )

-- Example 3840
select charindex('an', 'banana', 1);
+------------------------------+
| CHARINDEX('AN', 'BANANA', 1) |
|------------------------------|
|                            2 |
+------------------------------+

-- Example 3841
select charindex('an', 'banana', 3);
+------------------------------+
| CHARINDEX('AN', 'BANANA', 3) |
|------------------------------|
|                            4 |
+------------------------------+

-- Example 3842
SELECT n, h, CHARINDEX(n, h) FROM pos;

+--------+---------------------+-----------------+
| N      | H                   | CHARINDEX(N, H) |
|--------+---------------------+-----------------|
|        |                     |               1 |
|        | sth                 |               1 |
| 43     | 41424344            |               5 |
| a      | NULL                |            NULL |
| dog    | catalog             |               0 |
| log    | catalog             |               5 |
| lésine | le péché, la lésine |              14 |
| nicht  | Ich weiß nicht      |              10 |
| sth    |                     |               0 |
| ☃c     | ☃a☃b☃c☃d            |               5 |
| ☃☃     | bunch of ☃☃☃☃       |              10 |
| ❄c     | ❄a☃c❄c☃             |               5 |
| NULL   | a                   |            NULL |
| NULL   | NULL                |            NULL |
+--------+---------------------+-----------------+

-- Example 3843
SELECT CHARINDEX(X'EF', X'ABCDEF');
+-----------------------------+
| CHARINDEX(X'EF', X'ABCDEF') |
|-----------------------------|
|                           3 |
+-----------------------------+

-- Example 3844
SELECT CHARINDEX(X'BC', X'ABCD');
+---------------------------+
| CHARINDEX(X'BC', X'ABCD') |
|---------------------------|
|                         0 |
+---------------------------+

-- Example 3845
CHECK_JSON( <string_or_variant_expr> )

-- Example 3846
CREATE TABLE sample_json_table (ID INTEGER, varchar1 VARCHAR, variant1 VARIANT);
INSERT INTO sample_json_table (ID, varchar1) VALUES 
    (1, '{"ValidKey1": "ValidValue1"}'),
    (2, '{"Malformed -- Missing value": }'),
    (3, NULL)
    ;
UPDATE sample_json_table SET variant1 = varchar1::VARIANT;

-- Example 3847
SELECT ID, CHECK_JSON(varchar1), varchar1 FROM sample_json_table ORDER BY ID;
+----+----------------------+----------------------------------+
| ID | CHECK_JSON(VARCHAR1) | VARCHAR1                         |
|----+----------------------+----------------------------------|
|  1 | NULL                 | {"ValidKey1": "ValidValue1"}     |
|  2 | misplaced }, pos 32  | {"Malformed -- Missing value": } |
|  3 | NULL                 | NULL                             |
+----+----------------------+----------------------------------+

-- Example 3848
SELECT ID, CHECK_JSON(variant1), variant1 FROM sample_json_table ORDER BY ID;
+----+----------------------+--------------------------------------+
| ID | CHECK_JSON(VARIANT1) | VARIANT1                             |
|----+----------------------+--------------------------------------|
|  1 | NULL                 | "{\"ValidKey1\": \"ValidValue1\"}"   |
|  2 | misplaced }, pos 32  | "{\"Malformed -- Missing value\": }" |
|  3 | NULL                 | NULL                                 |
+----+----------------------+--------------------------------------+

-- Example 3849
CHECK_XML( <string_containing_xml> [ , <disable_auto_convert> ] )

-- Example 3850
CHECK_XML( STR => <string_containing_xml>
  [ , DISABLE_AUTO_CONVERT => <disable_auto_convert> ] )

-- Example 3851
SELECT CHECK_XML('<name> Valid </name>');

-- Example 3852
+-----------------------------------+
| CHECK_XML('<NAME> VALID </NAME>') |
|-----------------------------------|
| NULL                              |
+-----------------------------------+

-- Example 3853
SELECT CHECK_XML('<name> Invalid </WRONG_CLOSING_TAG>');

-- Example 3854
+--------------------------------------------------+
| CHECK_XML('<NAME> INVALID </WRONG_CLOSING_TAG>') |
|--------------------------------------------------|
| no opening tag for </WRONG_CLOSING_TAG>, pos 35  |
+--------------------------------------------------+

-- Example 3855
SELECT xml_str, CHECK_XML(xml_str)
  FROM my_table
  WHERE CHECK_XML(xml_str) IS NOT NULL;

-- Example 3856
{"firstName":"John", "empid":45611}

-- Example 3857
{"firstName":"John", "lastName":"Doe"}

-- Example 3858
{"employees":[
    {"firstName":"John", "lastName":"Doe"},
    {"firstName":"Anna", "lastName":"Smith"},
    {"firstName":"Peter", "lastName":"Jones"}
  ]
}

-- Example 3859
{"root":[{"employees":[
    {"firstName":"John", "lastName":"Doe"},
    {"firstName":"Anna", "lastName":"Smith"},
    {"firstName":"Peter", "lastName":"Jones"}
]}]}

-- Example 3860
{"root":
   [
    { "kind": "person",
      "fullName": "John Doe",
      "age": 22,
      "gender": "Male",
      "phoneNumber":
        {"areaCode": "206",
         "number": "1234567"},
      "children":
         [
           {
             "name": "Jane",
             "gender": "Female",
             "age": "6"
           },
           {
              "name": "John",
              "gender": "Male",
              "age": "15"
           }
         ],
      "citiesLived":
         [
            {
               "place": "Seattle",
               "yearsLived": ["1995"]
            },
            {
               "place": "Stockholm",
               "yearsLived": ["2005"]
            }
         ]
      },
      {"kind": "person", "fullName": "Mike Jones", "age": 35, "gender": "Male", "phoneNumber": { "areaCode": "622", "number": "1567845"}, "children": [{ "name": "Earl", "gender": "Male", "age": "10"}, {"name": "Sam", "gender": "Male", "age": "6"}, { "name": "Kit", "gender": "Male", "age": "8"}], "citiesLived": [{"place": "Los Angeles", "yearsLived": ["1989", "1993", "1998", "2002"]}, {"place": "Washington DC", "yearsLived": ["1990", "1993", "1998", "2008"]}, {"place": "Portland", "yearsLived": ["1993", "1998", "2003", "2005"]}, {"place": "Austin", "yearsLived": ["1973", "1998", "2001", "2005"]}]},
      {"kind": "person", "fullName": "Anna Karenina", "age": 45, "gender": "Female", "phoneNumber": { "areaCode": "425", "number": "1984783"}, "citiesLived": [{"place": "Stockholm", "yearsLived": ["1992", "1998", "2000", "2010"]}, {"place": "Russia", "yearsLived": ["1998", "2001", "2005"]}, {"place": "Austin", "yearsLived": ["1995", "1999"]}]}
    ]
}

-- Example 3861
{
 "type": "record",
 "name": "person",
 "namespace": "example.avro",
 "fields": [
     {"name": "fullName", "type": "string"},
     {"name": "age",  "type": ["int", "null"]},
     {"name": "gender", "type": ["string", "null"]}
     ]
}

-- Example 3862
"map": [{"key": "chani", "value": {"int1": 5, "string1": "chani"}}, {"key": "mauddib", "value": {"int1": 1, "string1": "mauddib"}}]

-- Example 3863
{"time": "1970-05-05 12:34:56.197", "union": {"tag": 0, "value": 3880900}, "decimal": 3863316326626557453.000000000000000000}

-- Example 3864
+--------------------------------------+
| SRC                                  |
|--------------------------------------|
| {                                    |
|   "boolean1": false,                 |
|   "byte1": 1,                        |
|   "bytes1": "0001020304",            |
|   "decimal1": 12345678.654745,       |
|   "double1": -1.500000000000000e+01, |
|   "float1": 1.000000000000000e+00,   |
|   "int1": 65536,                     |
|   "list": [                          |
|     {                                |
|       "int1": 3,                     |
|       "string1": "good"              |
|     },                               |
|     {                                |
|       "int1": 4,                     |
|       "string1": "bad"               |
|     }                                |
|   ]                                  |
| }                                    |
+--------------------------------------+

-- Example 3865
+------------------------------------------+
| SRC                                      |
|------------------------------------------|
| {                                        |
|   "continent": "Europe",                 |
|   "country": {                           |
|     "city": {                            |
|       "bag": [                           |
|         {                                |
|           "array_element": "Paris"       |
|         },                               |
|         {                                |
|           "array_element": "Nice"        |
|         },                               |
|         {                                |
|           "array_element": "Marseilles"  |
|         },                               |
|         {                                |
|           "array_element": "Cannes"      |
|         }                                |
|       ]                                  |
|     },                                   |
|     "name": "France"                     |
|   }                                      |
| }                                        |
+------------------------------------------+

-- Example 3866
<?xml version="1.0"?>
<!DOCTYPE parts system "parts.dtd">
<?xml-stylesheet type="text/css" href="xmlpartsstyle.css"?>
<parts>
   <part count="4">
      <item>Spark Plugs</item>
      <partnum>A3-400</partnum>
      <manufacturer>ABC company</manufacturer>
      <price units="dollar"> 27.00</price>
   </part>
   <part count="1">
      <item>Motor Oil</item>
      <partnum>B5-200</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 14.00</price>
   </part>
   <part count="1">
      <item>Motor Oil</item>
      <partnum>B5-300</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 16.75</price>
   </part>
   <part count="1">
      <item>Engine Coolant</item>
      <partnum>B6-120</partnum>
       <source>XYZ company</source>
      <price units="dollar"> 19.00</price>
   </part>
   <part count="1">
      <item>Engine Coolant</item>
      <partnum>B6-220</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 18.25</price>
   </part>
</parts>

-- Example 3867
PUT FILE:///examples/xml/auto-parts.xml @~/xml_stage;

-- Example 3868
CREATE OR REPLACE TABLE sample_xml_parts(src VARIANT);

