-- Example 5542
SELECT TO_JSON(NULL), TO_JSON('null'::VARIANT),
       PARSE_JSON(NULL), PARSE_JSON('null');

-- Example 5543
+---------------+--------------------------+------------------+--------------------+
| TO_JSON(NULL) | TO_JSON('NULL'::VARIANT) | PARSE_JSON(NULL) | PARSE_JSON('NULL') |
|---------------+--------------------------+------------------+--------------------|
| NULL          | "null"                   | NULL             | null               |
+---------------+--------------------------+------------------+--------------------+

-- Example 5544
CREATE OR REPLACE TABLE jdemo2 (
  varchar1 VARCHAR, 
  variant1 VARIANT);

INSERT INTO jdemo2 (varchar1) VALUES ('{"PI":3.14}');

UPDATE jdemo2 SET variant1 = PARSE_JSON(varchar1);

-- Example 5545
SELECT varchar1, 
       PARSE_JSON(varchar1), 
       variant1, 
       TO_JSON(variant1),
       PARSE_JSON(varchar1) = variant1, 
       TO_JSON(variant1) = varchar1
  FROM jdemo2;

-- Example 5546
+-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------+
| VARCHAR1    | PARSE_JSON(VARCHAR1) | VARIANT1     | TO_JSON(VARIANT1) | PARSE_JSON(VARCHAR1) = VARIANT1 | TO_JSON(VARIANT1) = VARCHAR1 |
|-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------|
| {"PI":3.14} | {                    | {            | {"PI":3.14}       | True                            | True                         |
|             |   "PI": 3.14         |   "PI": 3.14 |                   |                                 |                              |
|             | }                    | }            |                   |                                 |                              |
+-------------+----------------------+--------------+-------------------+---------------------------------+------------------------------+

-- Example 5547
SELECT TO_JSON(PARSE_JSON('{"b":1,"a":2}')),
       TO_JSON(PARSE_JSON('{"b":1,"a":2}')) = '{"b":1,"a":2}',
       TO_JSON(PARSE_JSON('{"b":1,"a":2}')) = '{"a":2,"b":1}';

-- Example 5548
+--------------------------------------+--------------------------------------------------------+--------------------------------------------------------+
| TO_JSON(PARSE_JSON('{"B":1,"A":2}')) | TO_JSON(PARSE_JSON('{"B":1,"A":2}')) = '{"B":1,"A":2}' | TO_JSON(PARSE_JSON('{"B":1,"A":2}')) = '{"A":2,"B":1}' |
|--------------------------------------+--------------------------------------------------------+--------------------------------------------------------|
| {"a":2,"b":1}                        | False                                                  | True                                                   |
+--------------------------------------+--------------------------------------------------------+--------------------------------------------------------+

-- Example 5549
CREATE OR REPLACE TABLE jdemo3 (
  variant1 VARIANT,
  variant2 VARIANT);

INSERT INTO jdemo3 (variant1, variant2)
  SELECT
    PARSE_JSON('{"PI":3.14}'),
    TO_VARIANT('{"PI":3.14}');

-- Example 5550
SELECT variant1,
       TYPEOF(variant1),
       variant2,
       TYPEOF(variant2),
       variant1 = variant2
  FROM jdemo3;

-- Example 5551
+--------------+------------------+-----------------+------------------+---------------------+
| VARIANT1     | TYPEOF(VARIANT1) | VARIANT2        | TYPEOF(VARIANT2) | VARIANT1 = VARIANT2 |
|--------------+------------------+-----------------+------------------+---------------------|
| {            | OBJECT           | "{\"PI\":3.14}" | VARCHAR          | False               |
|   "PI": 3.14 |                  |                 |                  |                     |
| }            |                  |                 |                  |                     |
+--------------+------------------+-----------------+------------------+---------------------+

-- Example 5552
PARSE_URL(<string>, [<permissive>])

-- Example 5553
CREATE OR REPLACE TABLE parse_url_test (id INT, sample_url VARCHAR);

INSERT INTO parse_url_test VALUES
  (1, 'mailto:abc@xyz.com'),
  (2, 'https://www.snowflake.com/'),
  (3, 'http://USER:PASS@EXAMPLE.INT:4345/HELLO.PHP?USER=1'),
  (4, NULL);

SELECT * FROM parse_url_test;

-- Example 5554
+----+----------------------------------------------------+
| ID | SAMPLE_URL                                         |
|----+----------------------------------------------------|
|  1 | mailto:abc@xyz.com                                 |
|  2 | https://www.snowflake.com/                         |
|  3 | http://USER:PASS@EXAMPLE.INT:4345/HELLO.PHP?USER=1 |
|  4 | NULL                                               |
+----+----------------------------------------------------+

-- Example 5555
SELECT PARSE_URL(sample_url) FROM parse_url_test;

-- Example 5556
+------------------------------------+
| PARSE_URL(SAMPLE_URL)              |
|------------------------------------|
| {                                  |
|   "fragment": null,                |
|   "host": null,                    |
|   "parameters": null,              |
|   "path": "abc@xyz.com",           |
|   "port": null,                    |
|   "query": null,                   |
|   "scheme": "mailto"               |
| }                                  |
| {                                  |
|   "fragment": null,                |
|   "host": "www.snowflake.com",     |
|   "parameters": null,              |
|   "path": "",                      |
|   "port": null,                    |
|   "query": null,                   |
|   "scheme": "https"                |
| }                                  |
| {                                  |
|   "fragment": null,                |
|   "host": "USER:PASS@EXAMPLE.INT", |
|   "parameters": {                  |
|     "USER": "1"                    |
|   },                               |
|   "path": "HELLO.PHP",             |
|   "port": "4345",                  |
|   "query": "USER=1",               |
|   "scheme": "http"                 |
| }                                  |
| NULL                               |
+------------------------------------+

-- Example 5557
SELECT PARSE_URL(sample_url):host FROM parse_url_test;

-- Example 5558
+----------------------------+
| PARSE_URL(SAMPLE_URL):HOST |
|----------------------------|
| null                       |
| "www.snowflake.com"        |
| "USER:PASS@EXAMPLE.INT"    |
| NULL                       |
+----------------------------+

-- Example 5559
SELECT *
  FROM parse_url_test
  WHERE PARSE_URL(sample_url):port = '4345';

-- Example 5560
+----+----------------------------------------------------+
| ID | SAMPLE_URL                                         |
|----+----------------------------------------------------|
|  3 | http://USER:PASS@EXAMPLE.INT:4345/HELLO.PHP?USER=1 |
+----+----------------------------------------------------+

-- Example 5561
SELECT *
  FROM parse_url_test
  WHERE PARSE_URL(sample_url):host = 'www.snowflake.com';

-- Example 5562
+----+----------------------------+
| ID | SAMPLE_URL                 |
|----+----------------------------|
|  2 | https://www.snowflake.com/ |
+----+----------------------------+

-- Example 5563
SELECT PARSE_URL('example.int/hello.php?user=12#nofragment', 0);

-- Example 5564
100139 (22000): Error parsing URL: scheme not specified

-- Example 5565
SELECT PARSE_URL('example.int/hello.php?user=12#nofragment', 1);

-- Example 5566
+----------------------------------------------------------+
| PARSE_URL('EXAMPLE.INT/HELLO.PHP?USER=12#NOFRAGMENT', 1) |
|----------------------------------------------------------|
| {                                                        |
|   "error": "scheme not specified"                        |
| }                                                        |
+----------------------------------------------------------+

-- Example 5567
PARSE_XML( <string_containing_xml> [ , <disable_auto_convert> ] )

-- Example 5568
PARSE_XML( STR => <string_containing_xml>
  [ , DISABLE_AUTO_CONVERT => <disable_auto_convert> ] )

-- Example 5569
CREATE OR REPLACE TABLE xtab (v OBJECT);

INSERT INTO xtab SELECT PARSE_XML(column1) AS v
  FROM VALUES ('<a/>'), ('<a attr="123">text</a>'), ('<a><b>X</b><b>Y</b></a>');

SELECT * FROM xtab;

-- Example 5570
+------------------------+
| V                      |
|------------------------|
| <a></a>                |
| <a attr="123">text</a> |
| <a>                    |
|   <b>X</b>             |
|   <b>Y</b>             |
| </a>                   |
+------------------------+

-- Example 5571
SELECT PARSE_XML('<test>22257e111</test>'), PARSE_XML('<test>22257e111</test>', TRUE);

-- Example 5572
+-------------------------------------+-------------------------------------------+
| PARSE_XML('<TEST>22257E111</TEST>') | PARSE_XML('<TEST>22257E111</TEST>', TRUE) |
|-------------------------------------+-------------------------------------------|
| <test>2.225700000000000e+115</test> | <test>22257e111</test>                    |
+-------------------------------------+-------------------------------------------+

-- Example 5573
SELECT PARSE_XML(STR => '<test>22257e111</test>', DISABLE_AUTO_CONVERT => TRUE);

-- Example 5574
+--------------------------------------------------------------------------+
| PARSE_XML(STR => '<TEST>22257E111</TEST>', DISABLE_AUTO_CONVERT => TRUE) |
|--------------------------------------------------------------------------|
| <test>22257e111</test>                                                   |
+--------------------------------------------------------------------------+

-- Example 5575
PERCENT_RANK()
  OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] [ <fixedRangeFrame> ] )

-- Example 5576
fixedRangeFrame ::=
    {
       RANGE UNBOUNDED PRECEDING
     | RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
     | RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    }

-- Example 5577
SELECT
    exchange,
    symbol,
    PERCENT_RANK() OVER (PARTITION BY exchange ORDER BY price) AS percent_rank
  FROM trades;

-- Example 5578
+--------+------+------------+
|exchange|symbol|PERCENT_RANK|
+--------+------+------------+
|C       |SPY   |         0.0|
|C       |AAPL  |         0.5|
|C       |AAPL  |         1.0|
|N       |YHOO  |         0.0|
|N       |QQQ   |         0.2|
|N       |QQQ   |         0.4|
|N       |SPY   |         0.6|
|N       |SPY   |         0.6|
|N       |AAPL  |         1.0|
|Q       |YHOO  |         0.0|
|Q       |YHOO  |         0.2|
|Q       |MSFT  |         0.4|
|Q       |MSFT  |         0.6|
|Q       |QQQ   |         0.8|
|Q       |QQQ   |         1.0|
|P       |YHOO  |         0.0|
|P       |MSFT  |        0.25|
|P       |MSFT  |         0.5|
|P       |SPY   |        0.75|
|P       |AAPL  |         1.0|
+--------+------+------------+

-- Example 5579
PI()

-- Example 5580
SELECT PI();
-------------+
    PI()     |
-------------+
 3.141592654 |
-------------+

-- Example 5581
PIPE_USAGE_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ]
      [, PIPE_NAME => '<string>' ] )

-- Example 5582
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>to_timestamp_tz('2017-10-24 12:00:00.000 -0700'),
    date_range_end=>to_timestamp_tz('2017-10-24 12:30:00.000 -0700')));

-- Example 5583
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>dateadd('day',-14,current_date()),
    date_range_end=>current_date()));

-- Example 5584
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>dateadd('hour',-12,current_timestamp()),
    pipe_name=>'mydb.public.mypipe'));

-- Example 5585
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>dateadd('day',-14,current_date()),
    date_range_end=>current_date(),
    pipe_name=>'mydb.public.mypipe'));

-- Example 5586
EXECUTE USING
POLICY_CONTEXT( <arg_1> => '<string_literal>' [ , <arg_2> => '<string_literal>' , ... , <arg_n> => '<string_literal>' ] )
AS
SELECT <query>

-- Example 5587
SELECT CURRENT_USER();

+----------------+
| CURRENT_USER() |
|----------------|
| JSMITH         |
+----------------+

-- Example 5588
execute using policy_context(current_account => '<consumer_account_name>') ... ;

-- Example 5589
EXECUTE USING POLICY_CONTEXT(CURRENT_ROLE => 'PUBLIC')
  AS SELECT * FROM empl_info;

-- Example 5590
POLICY_REFERENCES(
      POLICY_NAME => '<string>' ,
      POLICY_KIND => 'NETWORK_POLICY'
      )

-- Example 5591
POLICY_REFERENCES(
      POLICY_NAME => '<string>'
      )

-- Example 5592
POLICY_REFERENCES(
    REF_ENTITY_NAME => '<string>' ,
    REF_ENTITY_DOMAIN => '<string>'
    )

-- Example 5593
use database my_db;
use schema information_schema;
select *
  from table(information_schema.policy_references(policy_name => 'my_db.my_schema.ssn_mask'));

-- Example 5594
use database my_db;
use schema information_schema;
select *
  from table(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 5595
POSITION( <expr1>, <expr2> [ , <start_pos> ] )

POSITION( <expr1> IN <expr2> )

-- Example 5596
SELECT POSITION('an', 'banana', 1);

-- Example 5597
+-----------------------------+
| POSITION('AN', 'BANANA', 1) |
|-----------------------------|
|                           2 |
+-----------------------------+

-- Example 5598
SELECT POSITION('an', 'banana', 3);

-- Example 5599
+-----------------------------+
| POSITION('AN', 'BANANA', 3) |
|-----------------------------|
|                           4 |
+-----------------------------+

-- Example 5600
SELECT n, h, POSITION(n IN h) FROM pos;

-- Example 5601
+--------+---------------------+------------------+
| N      | H                   | POSITION(N IN H) |
|--------+---------------------+------------------|
|        |                     |                1 |
|        | sth                 |                1 |
| 43     | 41424344            |                5 |
| a      | NULL                |             NULL |
| dog    | catalog             |                0 |
| log    | catalog             |                5 |
| lésine | le péché, la lésine |               14 |
| nicht  | Ich weiß nicht      |               10 |
| sth    |                     |                0 |
| ☃c     | ☃a☃b☃c☃d            |                5 |
| ☃☃     | bunch of ☃☃☃☃       |               10 |
| ❄c     | ❄a☃c❄c☃             |                5 |
| NULL   | a                   |             NULL |
| NULL   | NULL                |             NULL |
+--------+---------------------+------------------+

-- Example 5602
SELECT POSITION(X'EF', X'ABCDEF');

-- Example 5603
+----------------------------+
| POSITION(X'EF', X'ABCDEF') |
|----------------------------|
|                          3 |
+----------------------------+

-- Example 5604
SELECT POSITION(X'BC', X'ABCD');

-- Example 5605
+--------------------------+
| POSITION(X'BC', X'ABCD') |
|--------------------------|
|                        0 |
+--------------------------+

-- Example 5606
POW(x, y)

POWER (x, y)

-- Example 5607
SELECT x, y, pow(x, y) FROM tab;

-----+-----+-------------+
  X  |  Y  |  POW(X, Y)  |
-----+-----+-------------+
 0.1 | 2   | 0.01        |
 2   | 3   | 8           |
 2   | 0.5 | 1.414213562 |
 2   | -1  | 0.5         |
-----+-----+-------------+

-- Example 5608
PREVIOUS_DAY( <date_or_time_expr> , <dow> )

