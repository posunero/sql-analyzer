-- Example 5276
SELECT LPAD('123.50', 19, '*_');

-- Example 5277
+--------------------------+
| LPAD('123.50', 19, '*_') |
|--------------------------|
| *_*_*_*_*_*_*123.50      |
+--------------------------+

-- Example 5278
LTRIM( <expr> [, <characters> ] )

-- Example 5279
SELECT LTRIM('#000000123', '0#');

-- Example 5280
+---------------------------+
| LTRIM('#000000123', '0#') |
|---------------------------|
| 123                       |
+---------------------------+

-- Example 5281
CREATE OR REPLACE TABLE test_ltrim_function(column1 VARCHAR);

INSERT INTO test_ltrim_function VALUES ('  #Leading Spaces');

-- Example 5282
SELECT CONCAT('>', CONCAT(column1, '<')) AS original_value,
       CONCAT('>', CONCAT(LTRIM(column1), '<')) AS trimmed_value
  FROM test_ltrim_function;

-- Example 5283
+---------------------+-------------------+
| ORIGINAL_VALUE      | TRIMMED_VALUE     |
|---------------------+-------------------|
| >  #Leading Spaces< | >#Leading Spaces< |
+---------------------+-------------------+

-- Example 5284
SELECT CONCAT('>', CONCAT(column1, '<')) AS original_value,
       CONCAT('>', CONCAT(LTRIM(column1, ' #'), '<')) AS trimmed_value
  FROM test_ltrim_function;

-- Example 5285
+---------------------+------------------+
| ORIGINAL_VALUE      | TRIMMED_VALUE    |
|---------------------+------------------|
| >  #Leading Spaces< | >Leading Spaces< |
+---------------------+------------------+

-- Example 5286
MAP_CAT( <map1> , <map2> )

-- Example 5287
SELECT MAP_CAT(
  {'map1key1':'map1value1','map1key2':'map1value2'}::MAP(VARCHAR,VARCHAR),
  {'map2key1':'map2value1','map2key2':'map2value2'}::MAP(VARCHAR,VARCHAR))
  AS concatenated_maps;

-- Example 5288
+-----------------------------+
| CONCATENATED_MAPS           |
|-----------------------------|
| {                           |
|   "map1key1": "map1value1", |
|   "map1key2": "map1value2", |
|   "map2key1": "map2value1", |
|   "map2key2": "map2value2"  |
| }                           |
+-----------------------------+

-- Example 5289
MAP_CONTAINS_KEY( <key> , <map> )

-- Example 5290
SELECT MAP_CONTAINS_KEY(
  'k1',{'k1':'v1','k2':'v2','k3':'v3'}::MAP(VARCHAR,VARCHAR))
  AS contains_key;

-- Example 5291
+--------------+
| CONTAINS_KEY |
|--------------|
| True         |
+--------------+

-- Example 5292
SELECT MAP_CONTAINS_KEY(
  'k1',{'ka':'va','kb':'vb','kc':'vc'}::MAP(VARCHAR,VARCHAR))
  AS contains_key;

-- Example 5293
+--------------+
| CONTAINS_KEY |
|--------------|
| False        |
+--------------+

-- Example 5294
SELECT MAP_CONTAINS_KEY(
  'k1',{'1':'va','2':'vb','3':'vc'}::MAP(NUMBER,VARCHAR))
  AS contains_key;

-- Example 5295
001065 (22023): SQL compilation error:
Function MAP_CONTAINS_KEY cannot be used with arguments of types VARCHAR(2) and map(NUMBER
(38,0), VARCHAR(16777216))

-- Example 5296
MAP_DELETE( <map>, <key1> [, <key2>, ... ] )

-- Example 5297
SELECT MAP_DELETE({'a':1,'b':2,'c':3}::MAP(VARCHAR,NUMBER),'a','b');

-- Example 5298
+--------------------------------------------------------------+
| MAP_DELETE({'A':1,'B':2,'C':3}::MAP(VARCHAR,NUMBER),'A','B') |
|--------------------------------------------------------------|
| {                                                            |
|   "c": 3                                                     |
| }                                                            |
+--------------------------------------------------------------+

-- Example 5299
MAP_INSERT( <map> , <key> , <value> [ , <updateFlag> ] )

-- Example 5300
SELECT MAP_INSERT({'a':1,'b':2}::MAP(VARCHAR,NUMBER),'c',3);

-- Example 5301
+------------------------------------------------------+
| MAP_INSERT({'A':1,'B':2}::MAP(VARCHAR,NUMBER),'C',3) |
|------------------------------------------------------|
| {                                                    |
|   "a": 1,                                            |
|   "b": 2,                                            |
|   "c": 3                                             |
| }                                                    |
+------------------------------------------------------+

-- Example 5302
SELECT MAP_INSERT(MAP_INSERT(MAP_INSERT({}::MAP(VARCHAR,VARCHAR),
  'Key_One', PARSE_JSON('NULL')), 'Key_Two', NULL), 'Key_Three', 'null');

-- Example 5303
+---------------------------------------------------------------------------+
| MAP_INSERT(MAP_INSERT(MAP_INSERT({}::MAP(VARCHAR,VARCHAR),                |
|    'KEY_ONE', PARSE_JSON('NULL')), 'KEY_TWO', NULL), 'KEY_THREE', 'NULL') |
|---------------------------------------------------------------------------|
| {                                                                         |
|   "Key_One": null,                                                        |
|   "Key_Three": "null",                                                    |
|   "Key_Two": null                                                         |
| }                                                                         |
+---------------------------------------------------------------------------+

-- Example 5304
SELECT MAP_INSERT({'k1':100}::MAP(VARCHAR,VARCHAR), 'k1', 'string-value', TRUE) AS map;

-- Example 5305
+------------------------+
| MAP                    |
|------------------------|
| {                      |
|   "k1": "string-value" |
| }                      |
+------------------------+

-- Example 5306
MAP_KEYS( <map> )

-- Example 5307
SELECT MAP_KEYS({'a':1,'b':2,'c':3}::MAP(VARCHAR,NUMBER))
  AS map_keys;

-- Example 5308
+----------+
| MAP_KEYS |
|----------|
| [        |
|   "a",   |
|   "b",   |
|   "c"    |
| ]        |
+----------+

-- Example 5309
MAP_PICK( <map>, <key1> [, <key2>, ... ] )

MAP_PICK( <map>, <array> )

-- Example 5310
SELECT MAP_PICK({'a':1,'b':2,'c':3}::MAP(VARCHAR,NUMBER),'a', 'b')
  AS new_map;

-- Example 5311
+-----------+
| NEW_MAP   |
|-----------|
| {         |
|   "a": 1, |
|   "b": 2  |
| }         |
+-----------+

-- Example 5312
SELECT MAP_PICK({'a':1,'b':2,'c':3}::MAP(VARCHAR,NUMBER), ['a', 'b'])
  AS new_map;

-- Example 5313
+-----------+
| NEW_MAP   |
|-----------|
| {         |
|   "a": 1, |
|   "b": 2  |
| }         |
+-----------+

-- Example 5314
MAP_SIZE( <map> )

-- Example 5315
SELECT MAP_SIZE({'a':1,'b':2,'c':3}::MAP(VARCHAR,NUMBER))
  AS map_size;

-- Example 5316
+----------+
| MAP_SIZE |
|----------|
|        3 |
+----------+

-- Example 5317
MATERIALIZED_VIEW_REFRESH_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , MATERIALIZED_VIEW_NAME => '<string>' ] )

-- Example 5318
select *
  from table(information_schema.materialized_view_refresh_history(
    date_range_start=>'2019-05-22 19:00:00.000',
    date_range_end=>'2019-05-22 20:00:00.000'));

-- Example 5319
+-------------------------------+-------------------------------+--------------+-----------------------------------------+
| START_TIME                    | END_TIME                      | CREDITS_USED | MATERIALIZED_VIEW_NAME                  |
|-------------------------------+-------------------------------+--------------+-----------------------------------------|
| 2019-05-22 19:00:00.000 -0700 | 2019-05-22 20:00:00.000 -0700 |  0.223276651 | TEST_DB.TEST_SCHEMA.MATERIALIZED_VIEW_1 |
+-------------------------------+-------------------------------+--------------+-----------------------------------------+

-- Example 5320
select *
  from table(information_schema.materialized_view_refresh_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 5321
select *
  from table(information_schema.materialized_view_refresh_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date));

-- Example 5322
select *
  from table(information_schema.materialized_view_refresh_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date,
    materialized_view_name=>'mydb.myschema.my_materialized_view'));

-- Example 5323
GRANT CREATE MATERIALIZED VIEW ON SCHEMA <schema_name> TO ROLE <role_name>;

-- Example 5324
CREATE OR REPLACE MATERIALIZED VIEW mv AS
  SELECT SYSTEM$ALPHA AS col1, ...

-- Example 5325
-- Example of a materialized view with a range filter
create materialized view v1 as
  select * from table1 where column_1 between 100 and 400;

-- Example 5326
-- Example of a query that might be rewritten to use the materialized view
select * from table1 where column_1 between 200 and 300;

-- Example 5327
create materialized view mv1 as
  select * from tab1 where column_1 = X or column_1 = Y;

-- Example 5328
select * from tab1 where column_1 = Y;

-- Example 5329
select * from mv1 where column_1 = Y;

-- Example 5330
create materialized view mv1 as
  select * from tab1 where column_1 in (X, Y);

-- Example 5331
select * from tab1 where column_1 = Y;

-- Example 5332
select * from mv1 where column_1 = Y;

-- Example 5333
create materialized view mv2 as
  select * from table1 where column_1 = X;

-- Example 5334
select column_1, column_2 from table1 where column_1 = X AND column_2 = Y;

-- Example 5335
select * from mv2 where column_2 = Y;

-- Example 5336
create materialized view mv4 as
  select column_1, column_2, sum(column_3) from table1 group by column_1, column_2;

-- Example 5337
select column_1, sum(column_3) from table1 group by column_1;

-- Example 5338
select column_1, sum(column_3) from mv4 group by column_1;

-- Example 5339
CREATE MATERIALIZED VIEW mv AS
  SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;

-- Example 5340
CREATE MATERIALIZED VIEW mv AS
  SELECT 100 * sum_c1 AS sigma FROM (
    SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;
  ) WHERE sum_c1 > 0;

