-- Example 30256
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

-- Example 30257
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

-- Example 30258
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

-- Example 30259
-- Sample data:
{"location": {"city": "Lexington","zip": "40503"},"dimensions": {"sq_ft": "1000"},"type": "Residential","sale_date": "4-25-16","price": "75836"},
{"location": {"city": "Belmont","zip": "02478"},"dimensions": {"sq_ft": "1103"},"type": "Residential","sale_date": "6-18-16","price": "92567"},
{"location": {"city": "Winchester","zip": "01890"},"dimensions": {"sq_ft": "1122"},"type": "Condo","sale_date": "1-31-16","price": "89921"}

-- Example 30260
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

-- Example 30261
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

-- Example 30262
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

-- Example 30263
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

-- Example 30264
SELECT ...
FROM ...
[ ... ]
GROUP BY ROLLUP ( groupRollup [ , groupRollup [ , ... ] ] )
[ ... ]

-- Example 30265
groupRollup ::= { <column_alias> | <position> | <expr> }

-- Example 30266
-- Create some tables and insert some rows.
CREATE TABLE products (product_ID INTEGER, wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES 
    (1, 1.00),
    (2, 2.00);

CREATE TABLE sales (product_ID INTEGER, retail_price REAL, 
    quantity INTEGER, city VARCHAR, state VARCHAR);
INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES 
    (1, 2.00,  1, 'SF', 'CA'),
    (1, 2.00,  2, 'SJ', 'CA'),
    (2, 5.00,  4, 'SF', 'CA'),
    (2, 5.00,  8, 'SJ', 'CA'),
    (2, 5.00, 16, 'Miami', 'FL'),
    (2, 5.00, 32, 'Orlando', 'FL'),
    (2, 5.00, 64, 'SJ', 'PR');

-- Example 30267
SELECT state, city, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit 
 FROM products AS p, sales AS s
 WHERE s.product_ID = p.product_ID
 GROUP BY ROLLUP (state, city)
 ORDER BY state, city NULLS LAST
 ;
+-------+---------+--------+
| STATE | CITY    | PROFIT |
|-------+---------+--------|
| CA    | SF      |     13 |
| CA    | SJ      |     26 |
| CA    | NULL    |     39 |
| FL    | Miami   |     48 |
| FL    | Orlando |     96 |
| FL    | NULL    |    144 |
| PR    | SJ      |    192 |
| PR    | NULL    |    192 |
| NULL  | NULL    |    375 |
+-------+---------+--------+

-- Example 30268
EXPLAIN [ USING { TABULAR | JSON | TEXT } ] <statement>

-- Example 30269
CREATE TABLE Z1 (ID INTEGER);
CREATE TABLE Z2 (ID INTEGER);
CREATE TABLE Z3 (ID INTEGER);

-- Example 30270
EXPLAIN USING TABULAR SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+
| step | id   | parentOperators | operation   | objects                      | alias | expressions              | partitionsTotal | partitionsAssigned | bytesAssigned |
|------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------|
| NULL | NULL |            NULL | GlobalStats | NULL                         | NULL  | NULL                     |               2 |                  2 |          1024 |
|    1 |    0 |            NULL | Result      | NULL                         | NULL  | Z1.ID, Z2.ID             |            NULL |               NULL |          NULL |
|    1 |    1 |             [0] | InnerJoin   | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    2 |             [1] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z2 | NULL  | ID                       |               1 |                  1 |           512 |
|    1 |    3 |             [1] | JoinFilter  | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    4 |             [3] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z1 | NULL  | ID                       |               1 |                  1 |           512 |
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+

-- Example 30271
EXPLAIN USING TEXT SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+------------------------------------------------------------------------------------------------------------------------------------+
| content                                                                                                                            |
|------------------------------------------------------------------------------------------------------------------------------------|
| GlobalStats:                                                                                                                       |
|     partitionsTotal=2                                                                                                              |
|     partitionsAssigned=2                                                                                                           |
|     bytesAssigned=1024                                                                                                             |
| Operations:                                                                                                                        |
| 1:0     ->Result  Z1.ID, Z2.ID                                                                                                     |
| 1:1          ->InnerJoin  joinKey: (Z2.ID = Z1.ID)                                                                                 |
| 1:2               ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z2  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512}      |
| 1:3               ->JoinFilter  joinKey: (Z2.ID = Z1.ID)                                                                           |
| 1:4                    ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z1  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512} |
|                                                                                                                                    |
+------------------------------------------------------------------------------------------------------------------------------------+

-- Example 30272
EXPLAIN USING JSON SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| content                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {"GlobalStats":{"partitionsTotal":2,"partitionsAssigned":2,"bytesAssigned":1024},"Operations":[[{"id":0,"operation":"Result","expressions":["Z1.ID","Z2.ID"]},{"id":1,"parentOperators":[0],"operation":"InnerJoin","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":2,"parentOperators":[1],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z2"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512},{"id":3,"parentOperators":[1],"operation":"JoinFilter","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":4,"parentOperators":[3],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z1"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512}]]} |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 30273
FLATTEN( INPUT => <expr> [ , PATH => <constant_expr> ]
                         [ , OUTER => TRUE | FALSE ]
                         [ , RECURSIVE => TRUE | FALSE ]
                         [ , MODE => 'OBJECT' | 'ARRAY' | 'BOTH' ] )

-- Example 30274
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|

-- Example 30275
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[1, ,77]'))) f;

-- Example 30276
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|
|   1 | NULL | [0]  |     0 |     1 | [    |
|     |      |      |       |       |   1, |
|     |      |      |       |       |   ,  |
|     |      |      |       |       |   77 |
|     |      |      |       |       | ]    |
|   1 | NULL | [2]  |     2 |    77 | [    |
|     |      |      |       |       |   1, |
|     |      |      |       |       |   ,  |
|     |      |      |       |       |   77 |
|     |      |      |       |       | ]    |
+-----+------+------+-------+-------+------+

-- Example 30277
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88]}'), OUTER => TRUE)) f;

-- Example 30278
+-----+-----+------+-------+-------+-----------+
| SEQ | KEY | PATH | INDEX | VALUE | THIS      |
|-----+-----+------+-------+-------+-----------|
|     |     |      |       |       |   "a": 1, |
|     |     |      |       |       |   "b": [  |
|     |     |      |       |       |     77,   |
|     |     |      |       |       |     88    |
|     |     |      |       |       |   ]       |
|     |     |      |       |       | }         |
|   1 | b   | b    |  NULL | [     | {         |
|     |     |      |       |   77, |   "a": 1, |
|     |     |      |       |   88  |   "b": [  |
|     |     |      |       | ]     |     77,   |
|     |     |      |       |       |     88    |
|     |     |      |       |       |   ]       |
|     |     |      |       |       | }         |
+-----+-----+------+-------+-------+-----------+

-- Example 30279
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88]}'), PATH => 'b')) f;

-- Example 30280
+-----+------+------+-------+-------+-------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS  |
|-----+------+------+-------+-------+-------|
|   1 | NULL | b[0] |     0 |    77 | [     |
|     |      |      |       |       |   77, |
|     |      |      |       |       |   88  |
|     |      |      |       |       | ]     |
|   1 | NULL | b[1] |     1 |    88 | [     |
|     |      |      |       |       |   77, |
|     |      |      |       |       |   88  |
|     |      |      |       |       | ]     |
+-----+------+------+-------+-------+-------+

-- Example 30281
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[]'))) f;

-- Example 30282
+-----+-----+------+-------+-------+------+
| SEQ | KEY | PATH | INDEX | VALUE | THIS |
|-----+-----+------+-------+-------+------|
+-----+-----+------+-------+-------+------+

-- Example 30283
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('[]'), OUTER => TRUE)) f;

-- Example 30284
+-----+------+------+-------+-------+------+
| SEQ |  KEY | PATH | INDEX | VALUE | THIS |
|-----+------+------+-------+-------+------|
|   1 | NULL |      |  NULL |  NULL | []   |
+-----+------+------+-------+-------+------+

-- Example 30285
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'))) f;

-- Example 30286
+-----+-----+------+-------+------------+--------------+
| SEQ | KEY | PATH | INDEX | VALUE      | THIS         |
|-----+-----+------+-------+------------+--------------|
|   1 | a   | a    |  NULL | 1          | {            |
|     |     |      |       |            |   "a": 1,    |
|     |     |      |       |            |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | b   | b    |  NULL | [          | {            |
|     |     |      |       |   77,      |   "a": 1,    |
|     |     |      |       |   88       |   "b": [     |
|     |     |      |       | ]          |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | c   | c    |  NULL | {          | {            |
|     |     |      |       |   "d": "X" |   "a": 1,    |
|     |     |      |       | }          |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
+-----+-----+------+-------+------------+--------------+

-- Example 30287
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'),
                            RECURSIVE => TRUE )) f;

-- Example 30288
+-----+------+------+-------+------------+--------------+
| SEQ | KEY  | PATH | INDEX | VALUE      | THIS         |
|-----+------+------+-------+------------+--------------|
|   1 | a    | a    |  NULL | 1          | {            |
|     |      |      |       |            |   "a": 1,    |
|     |      |      |       |            |   "b": [     |
|     |      |      |       |            |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | b    | b    |  NULL | [          | {            |
|     |      |      |       |   77,      |   "a": 1,    |
|     |      |      |       |   88       |   "b": [     |
|     |      |      |       | ]          |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | NULL | b[0] |     0 | 77         | [            |
|     |      |      |       |            |   77,        |
|     |      |      |       |            |   88         |
|     |      |      |       |            | ]            |
|   1 | NULL | b[1] |     1 | 88         | [            |
|     |      |      |       |            |   77,        |
|     |      |      |       |            |   88         |
|     |      |      |       |            | ]            |
|   1 | c    | c    |  NULL | {          | {            |
|     |      |      |       |   "d": "X" |   "a": 1,    |
|     |      |      |       | }          |   "b": [     |
|     |      |      |       |            |     77,      |
|     |      |      |       |            |     88       |
|     |      |      |       |            |   ],         |
|     |      |      |       |            |   "c": {     |
|     |      |      |       |            |     "d": "X" |
|     |      |      |       |            |   }          |
|     |      |      |       |            | }            |
|   1 | d    | c.d  |  NULL | "X"        | {            |
|     |      |      |       |            |   "d": "X"   |
|     |      |      |       |            | }            |
+-----+------+------+-------+------------+--------------+

-- Example 30289
SELECT * FROM TABLE(FLATTEN(INPUT => PARSE_JSON('{"a":1, "b":[77,88], "c": {"d":"X"}}'),
                            RECURSIVE => TRUE, MODE => 'OBJECT' )) f;

-- Example 30290
+-----+-----+------+-------+------------+--------------+
| SEQ | KEY | PATH | INDEX | VALUE      | THIS         |
|-----+-----+------+-------+------------+--------------|
|   1 | a   | a    |  NULL | 1          | {            |
|     |     |      |       |            |   "a": 1,    |
|     |     |      |       |            |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | b   | b    |  NULL | [          | {            |
|     |     |      |       |   77,      |   "a": 1,    |
|     |     |      |       |   88       |   "b": [     |
|     |     |      |       | ]          |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | c   | c    |  NULL | {          | {            |
|     |     |      |       |   "d": "X" |   "a": 1,    |
|     |     |      |       | }          |   "b": [     |
|     |     |      |       |            |     77,      |
|     |     |      |       |            |     88       |
|     |     |      |       |            |   ],         |
|     |     |      |       |            |   "c": {     |
|     |     |      |       |            |     "d": "X" |
|     |     |      |       |            |   }          |
|     |     |      |       |            | }            |
|   1 | d   | c.d  |  NULL | "X"        | {            |
|     |     |      |       |            |   "d": "X"   |
|     |     |      |       |            | }            |
+-----+-----+------+-------+------------+--------------+

-- Example 30291
CREATE OR REPLACE TABLE persons AS
  SELECT column1 AS id, PARSE_JSON(column2) as c
    FROM values
      (12712555,
       '{ name:  { first: "John", last: "Smith"},
         contact: [
         { business:[
           { type: "phone", content:"555-1234" },
           { type: "email", content:"j.smith@example.com" } ] } ] }'),
      (98127771,
       '{ name:  { first: "Jane", last: "Doe"},
         contact: [
         { business:[
           { type: "phone", content:"555-1236" },
           { type: "email", content:"j.doe@example.com" } ] } ] }') v;

-- Example 30292
SELECT id as "ID",
    f.value AS "Contact",
    f1.value:type AS "Type",
    f1.value:content AS "Details"
  FROM persons p,
    LATERAL FLATTEN(INPUT => p.c, PATH => 'contact') f,
    LATERAL FLATTEN(INPUT => f.value:business) f1;

-- Example 30293
+----------+-----------------------------------------+---------+-----------------------+
|       ID | Contact                                 | Type    | Details               |
|----------+-----------------------------------------+---------+-----------------------|
| 12712555 | {                                       | "phone" | "555-1234"            |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1234",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.smith@example.com", |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 12712555 | {                                       | "email" | "j.smith@example.com" |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1234",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.smith@example.com", |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 98127771 | {                                       | "phone" | "555-1236"            |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1236",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.doe@example.com",   |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
| 98127771 | {                                       | "email" | "j.doe@example.com"   |
|          |   "business": [                         |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "555-1236",            |         |                       |
|          |       "type": "phone"                   |         |                       |
|          |     },                                  |         |                       |
|          |     {                                   |         |                       |
|          |       "content": "j.doe@example.com",   |         |                       |
|          |       "type": "email"                   |         |                       |
|          |     }                                   |         |                       |
|          |   ]                                     |         |                       |
|          | }                                       |         |                       |
+----------+-----------------------------------------+---------+-----------------------+

-- Example 30294
SELECT ...
FROM ...
  { SAMPLE | TABLESAMPLE } [ samplingMethod ]
[ ... ]

-- Example 30295
samplingMethod ::= { { BERNOULLI | ROW } ( { <probability> | <num> ROWS } ) |
                     { SYSTEM | BLOCK } ( <probability> ) [ { REPEATABLE | SEED } ( <seed> ) ] }

-- Example 30296
SELECT * FROM example_table SAMPLE SYSTEM (10 ROWS);

SELECT * FROM example_table SAMPLE ROW (10 ROWS) SEED (99);

-- Example 30297
SELECT * FROM (SELECT * FROM example_table) SAMPLE (1) SEED (99);

-- Example 30298
SELECT * FROM testtable SAMPLE (10);

-- Example 30299
SELECT * FROM testtable TABLESAMPLE BERNOULLI (20.3);

-- Example 30300
SELECT * FROM testtable TABLESAMPLE (100);

-- Example 30301
SELECT * FROM testtable SAMPLE ROW (0);

-- Example 30302
SELECT i, j
  FROM
    table1 AS t1 SAMPLE (25)
      INNER JOIN
    table2 AS t2 SAMPLE (50)
  WHERE t2.j = t1.i;

-- Example 30303
SELECT i, j
  FROM table1 AS t1 INNER JOIN table2 AS t2 SAMPLE (50)
  WHERE t2.j = t1.i;

-- Example 30304
SELECT *
  FROM (
       SELECT *
         FROM t1 JOIN t2
           ON t1.a = t2.c
       ) SAMPLE (1);

-- Example 30305
SELECT * FROM testtable SAMPLE SYSTEM (3) SEED (82);

-- Example 30306
SELECT * FROM testtable SAMPLE BLOCK (0.012) REPEATABLE (99992);

-- Example 30307
SELECT * FROM testtable SAMPLE (10 ROWS);

-- Example 30308
val session = Session.builder.configFile("/path/to/file.properties").create

-- Example 30309
val configMap = Map(
"URL" -> "demo.snowflakecomputing.com",
"USER" -> "testUser",
"PASSWORD" -> "******",
"ROLE" -> "myrole",
"WAREHOUSE" -> "warehouse1",
"DB" -> "db1",
"SCHEMA" -> "schema1"
)
Session.builder.configs(configMap).create

-- Example 30310
val session = Session.builder.configFile(..).create
import session.implicits._

-- Example 30311
// Create a DataFrame from a local sequence of integers.
val df = (1 to 10).toDF("a")
val df = Seq((1, "one"), (2, "two")).toDF("a", "b")

-- Example 30312
// Refer to a column in a DataFrame by using $"colName".
val df = session.table("T").filter($"a" > 1)
// Refer to columns by using 'colName.
val df = session.table("T").filter('a > 1)

-- Example 30313
val session = Session.builder.appName("myApp").configFile(myConfigFile).create
print(session.getQueryTag().get)
{"APPNAME":"myApp"}

-- Example 30314
val session = Session.builder.appName("myApp").configFile(myConfigFile).create
print(session.getQueryTag().get)
APPNAME=myApp

-- Example 30315
CallableStatement stmt = testConnection.prepareCall("call read_result_set(?,?) ");

-- Example 30316
CallableStatement stmt = testConnection.prepareCall("? = call read_result_set() ");  -- INVALID

-- Example 30317
ResultSet resultSet;
resultSet = connection.unwrap(SnowflakeConnection.class).createResultSet(queryID);

-- Example 30318
getColumns( connection,
    "TEMPORARYDB1",      // Database name.
    "TEMPORARYSCHEMA1",  // Schema name.
    "%",                 // All table names.
    "%"                  // All column names.
    );

-- Example 30319
getColumns(
    connection, "TEMPORARYDB1", "TEMPORARYSCHEMA1", "T\\_\\\\", "%" // All column names.
    );

-- Example 30320
Java sees...............: T\\_\\%\\\\
SQL sees................: T\_\%\\
The actual table name is: T_%\

-- Example 30321
// Demonstrate the Driver.getPropertyInfo() method.
  public static void do_the_real_work(String connectionString) throws Exception {
    Properties properties = new Properties();
    Driver driver = DriverManager.getDriver(connectionString);
    DriverPropertyInfo[] dpinfo = driver.getPropertyInfo("", properties);
    System.out.println(dpinfo[0].description);
  }

-- Example 30322
INSERT INTO t1 (c1, c2) VALUES (1, 'One');   -- single row inserted.

INSERT INTO t1 (c1, c2) VALUES (1, 'One'),   -- multiple rows inserted.
                               (2, 'Two'),
                               (3, 'Three');

