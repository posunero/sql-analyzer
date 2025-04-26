-- Example 5209
<subject> [ NOT ] LIKE <pattern> [ ESCAPE <escape> ]

LIKE( <subject> , <pattern> [ , <escape> ] )

-- Example 5210
'SOMETHING%' LIKE '%\\%%' ESCAPE '\\';

-- Example 5211
CREATE OR REPLACE TABLE like_ex(name VARCHAR(20));
INSERT INTO like_ex VALUES
  ('John  Dddoe'),
  ('John \'alias\' Doe'),
  ('Joe   Doe'),
  ('John_down'),
  ('Joe down'),
  ('Elaine'),
  (''),    -- empty string
  (null);

-- Example 5212
SELECT name
  FROM like_ex
  WHERE name LIKE '%Jo%oe%'
  ORDER BY name;

-- Example 5213
+------------------+
| NAME             |
|------------------|
| Joe   Doe        |
| John  Dddoe      |
| John 'alias' Doe |
+------------------+

-- Example 5214
SELECT name
  FROM like_ex
  WHERE name NOT LIKE '%Jo%oe%'
  ORDER BY name;

-- Example 5215
+-----------+
| NAME      |
|-----------|
|           |
| Elaine    |
| Joe down  |
| John_down |
+-----------+

-- Example 5216
SELECT name
  FROM like_ex
  WHERE name NOT LIKE 'John%'
  ORDER BY name;

-- Example 5217
+-----------+                                                                   
| NAME      |
|-----------|
|           |
| Elaine    |
| Joe   Doe |
| Joe down  |
+-----------+

-- Example 5218
SELECT name
  FROM like_ex
  WHERE name NOT LIKE ''
  ORDER BY name;

-- Example 5219
+------------------+
| NAME             |
|------------------|
| Elaine           |
| Joe   Doe        |
| Joe down         |
| John  Dddoe      |
| John 'alias' Doe |
| John_down        |
+------------------+

-- Example 5220
SELECT name
  FROM like_ex
  WHERE name LIKE '%\'%'
  ORDER BY name;

-- Example 5221
+------------------+
| NAME             |
|------------------|
| John 'alias' Doe |
+------------------+

-- Example 5222
SELECT name
  FROM like_ex
  WHERE name LIKE '%J%h%^_do%' ESCAPE '^'
  ORDER BY name;

-- Example 5223
+-----------+                                                                   
| NAME      |
|-----------|
| John_down |
+-----------+

-- Example 5224
INSERT INTO like_ex (name) VALUES 
  ('100 times'),
  ('1000 times'),
  ('100%');

-- Example 5225
SELECT * FROM like_ex WHERE name LIKE '100%'
  ORDER BY 1;

-- Example 5226
+------------+                                                                  
| NAME       |
|------------|
| 100 times  |
| 100%       |
| 1000 times |
+------------+

-- Example 5227
SELECT * FROM like_ex WHERE name LIKE '100^%' ESCAPE '^'
  ORDER BY 1;

-- Example 5228
+------+                                                                        
| NAME |
|------|
| 100% |
+------+

-- Example 5229
SELECT * FROM like_ex WHERE name LIKE '100\\%' ESCAPE '\\'
  ORDER BY 1;

-- Example 5230
+------+                                                                        
| NAME |
|------|
| 100% |
+------+

-- Example 5231
<subject> LIKE ALL (<pattern1> [, <pattern2> ... ] ) [ ESCAPE <escape_char> ]

-- Example 5232
SELECT ...
  WHERE x LIKE ALL (SELECT ...)

-- Example 5233
CREATE OR REPLACE TABLE like_all_example(name VARCHAR(20));
INSERT INTO like_all_example VALUES
    ('John  Dddoe'),
    ('Joe   Doe'),
    ('John_do%wn'),
    ('Joe down'),
    ('Tom   Doe'),
    ('Tim down'),
    (null);

-- Example 5234
SELECT * 
  FROM like_all_example 
  WHERE name LIKE ALL ('%Jo%oe%','J%e')
  ORDER BY name;

-- Example 5235
+-------------+                                                                 
| NAME        |
|-------------|
| Joe   Doe   |
| John  Dddoe |
+-------------+

-- Example 5236
SELECT * 
  FROM like_all_example 
  WHERE name LIKE ALL ('%Jo%oe%','J%n')
  ORDER BY name;

-- Example 5237
+------+                                                                        
| NAME |
|------|
+------+

-- Example 5238
SELECT * 
  FROM like_all_example 
  WHERE name LIKE ALL ('%J%h%^_do%', 'J%^%wn') ESCAPE '^'
  ORDER BY name;

-- Example 5239
+------------+                                                                  
| NAME       |
|------------|
| John_do%wn |
+------------+

-- Example 5240
<subject> LIKE ANY (<pattern1> [, <pattern2> ... ] ) [ ESCAPE <escape_char> ]

-- Example 5241
SELECT ...
  WHERE x LIKE ANY (SELECT ...)

-- Example 5242
CREATE OR REPLACE TABLE like_example(name VARCHAR(20));
INSERT INTO like_example VALUES
    ('John  Dddoe'),
    ('Joe   Doe'),
    ('John_down'),
    ('Joe down'),
    ('Tom   Doe'),
    ('Tim down'),
    (null);

-- Example 5243
SELECT * 
  FROM like_example 
  WHERE name LIKE ANY ('%Jo%oe%','T%e')
  ORDER BY name;

-- Example 5244
+-------------+                                                                 
| NAME        |
|-------------|
| Joe   Doe   |
| John  Dddoe |
| Tom   Doe   |
+-------------+

-- Example 5245
SELECT * 
  FROM like_example 
  WHERE name LIKE ANY ('%J%h%^_do%', 'T%^%e') ESCAPE '^'
  ORDER BY name;

-- Example 5246
+-----------+                                                                   
| NAME      |
|-----------|
| John_down |
+-----------+

-- Example 5247
LISTING_REFRESH_HISTORY(
  LISTING_NAME => '<listing_name>'
  [ , SNOWFLAKE_REGION => '<snowflake_region>' ]
  [ , REGION_GROUP => '<region_group>' ] )

-- Example 5248
select * from table(information_schema.listing_refresh_history(listing_name=>'my_listing',snowflake_region=>'AWS_US_EAST_1))

-- Example 5249
LN(<expr>)

-- Example 5250
SELECT x, ln(x) FROM tab;

--------+-------------+
   X    |    LN(X)    |
--------+-------------+
 1      | 0           |
 10     | 2.302585093 |
 100    | 4.605170186 |
 [NULL] | [NULL]      |
--------+-------------+

-- Example 5251
LOCALTIME()

LOCALTIME

-- Example 5252
SELECT LOCALTIME(), LOCALTIMESTAMP();

-- Example 5253
+-------------+-------------------------------+
| LOCALTIME() | LOCALTIMESTAMP()              |
|-------------+-------------------------------|
| 15:32:45    | 2024-04-17 15:32:45.775 -0700 |
+-------------+-------------------------------+

-- Example 5254
LOCALTIMESTAMP( [ <fract_sec_precision> ] )

LOCALTIMESTAMP

-- Example 5255
SELECT LOCALTIME(), LOCALTIMESTAMP();

-- Example 5256
+-------------+-------------------------------+
| LOCALTIME() | LOCALTIMESTAMP()              |
|-------------+-------------------------------|
| 07:58:09    | 2024-04-18 07:58:09.848 -0700 |
+-------------+-------------------------------+

-- Example 5257
LOG(<base>, <expr>)

-- Example 5258
SELECT x, y, log(x, y) FROM tab;

--------+--------+-------------+
   X    |   Y    |  LOG(X, Y)  |
--------+--------+-------------+
 2      | 0.5    | -1          |
 2      | 1      | 0           |
 2      | 8      | 3           |
 2      | 16     | 4           |
 10     | 10     | 1           |
 10     | 20     | 1.301029996 |
 10     | [NULL] | [NULL]      |
 [NULL] | 10     | [NULL]      |
 [NULL] | [NULL] | [NULL]      |
--------+--------+-------------+

-- Example 5259
LOGIN_HISTORY(
      [  TIME_RANGE_START => <constant_expr> ]
      [, TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ] )

LOGIN_HISTORY_BY_USER(
      [  USER_NAME => '<string>' ]
      [, TIME_RANGE_START => <constant_expr> ]
      [, TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <num> ] )

-- Example 5260
select *
from table(information_schema.login_history_by_user())
order by event_timestamp;

-- Example 5261
select *
from table(information_schema.login_history_by_user(USER_NAME => 'USER1', result_limit => 1000))
order by event_timestamp;

-- Example 5262
select *
from table(information_schema.login_history(TIME_RANGE_START => dateadd('hours',-1,current_timestamp()),current_timestamp()))
order by event_timestamp;

-- Example 5263
LOWER( <expr> )

-- Example 5264
SELECT v, LOWER(v) FROM lu;

-- Example 5265
+----------------------------------+----------------------------------+
|                v                 |             lower(v)             |
+----------------------------------+----------------------------------+
|                                  |                                  |
| The Quick Gray Fox               | the quick gray fox               |
| LAUGHING ALL THE WAY             | laughing all the way             |
| OVER the River 2 Times           | over the river 2 times           |
| UuVvWwXxYyZz                     | uuvvwwxxyyzz                     |
| ÁáÄäÉéÍíÓóÔôÚúÝý                 | ááääééííóóôôúúýý                 |
| ÄäÖößÜü                          | ääöößüü                          |
| ÉéÀàÈèÙùÂâÊêÎîÔôÛûËëÏïÜüŸÿÇçŒœÆæ | ééààèèùùââêêîîôôûûëëïïüüÿÿççœœææ |
| ĄąĆćĘęŁłŃńÓóŚśŹźŻż               | ąąććęęłłńńóóśśźźżż               |
| ČčĎďĹĺĽľŇňŔŕŠšŤťŽž               | ččďďĺĺľľňňŕŕššťťžž               |
| АаБбВвГгДдЕеЁёЖжЗзИиЙй           | ааббввггддееёёжжззиийй           |
| КкЛлМмНнОоПпРрСсТтУуФф           | ккллммннооппррссттууфф           |
| ХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя           | ххццччшшщщъъыыььээююяя           |
| [NULL]                           | [NULL]                           |
+----------------------------------+----------------------------------+

-- Example 5266
SELECT LOWER('I' COLLATE 'tr');

-- Example 5267
+-------------------------+
| LOWER('I' COLLATE 'TR') |
|-------------------------|
| ı                       |
+-------------------------+

-- Example 5268
LPAD( <base>, <length_expr> [, <pad>] )

-- Example 5269
CREATE OR REPLACE TABLE padding_example (v VARCHAR, b BINARY);

INSERT INTO padding_example (v, b)
  SELECT
    'Hi',
    HEX_ENCODE('Hi');

INSERT INTO padding_example (v, b)
  SELECT
    '-123.00',
    HEX_ENCODE('-123.00');

INSERT INTO padding_example (v, b)
  SELECT
    'Twelve Dollars',
    TO_BINARY(HEX_ENCODE('Twelve Dollars'), 'HEX');

-- Example 5270
SELECT * FROM padding_example;

-- Example 5271
+----------------+------------------------------+
| V              | B                            |
|----------------+------------------------------|
| Hi             | 4869                         |
| -123.00        | 2D3132332E3030               |
| Twelve Dollars | 5477656C766520446F6C6C617273 |
+----------------+------------------------------+

-- Example 5272
SELECT v,
       LPAD(v, 10, ' ') AS pad_with_blank,
       LPAD(v, 10, '$') AS pad_with_dollar_sign
  FROM padding_example
  ORDER BY v;

-- Example 5273
+----------------+----------------+----------------------+
| V              | PAD_WITH_BLANK | PAD_WITH_DOLLAR_SIGN |
|----------------+----------------+----------------------|
| -123.00        |    -123.00     | $$$-123.00           |
| Hi             |         Hi     | $$$$$$$$Hi           |
| Twelve Dollars | Twelve Dol     | Twelve Dol           |
+----------------+----------------+----------------------+

-- Example 5274
SELECT b,
       LPAD(b, 10, TO_BINARY(HEX_ENCODE(' '))) AS pad_with_blank,
       LPAD(b, 10, TO_BINARY(HEX_ENCODE('$'))) AS pad_with_dollar_sign
  FROM padding_example
  ORDER BY b;

-- Example 5275
+------------------------------+----------------------+----------------------+
| B                            | PAD_WITH_BLANK       | PAD_WITH_DOLLAR_SIGN |
|------------------------------+----------------------+----------------------|
| 2D3132332E3030               | 2020202D3132332E3030 | 2424242D3132332E3030 |
| 4869                         | 20202020202020204869 | 24242424242424244869 |
| 5477656C766520446F6C6C617273 | 5477656C766520446F6C | 5477656C766520446F6C |
+------------------------------+----------------------+----------------------+

