-- Example 5877
+---------+--------------+-------------------------+
| CUST_ID | CUST_PHONE   | PHONE_WITHOUT_AREA_CODE |
|---------+--------------+-------------------------|
|       1 | 800-555-0100 | 555-0100                |
|       2 | 800-555-0101 | 555-0101                |
|       3 | 800-555-0102 | 555-0102                |
+---------+--------------+-------------------------+

-- Example 5878
SELECT cust_id,
       activation_date,
       RIGHT(activation_date, 2) AS day
  FROM customer_contact_example;

-- Example 5879
+---------+-----------------+-----+
| CUST_ID | ACTIVATION_DATE | DAY |
|---------+-----------------+-----|
|       1 | 20210320        | 20  |
|       2 | 20240509        | 09  |
|       3 | 20191017        | 17  |
+---------+-----------------+-----+

-- Example 5880
-- 1st syntax
RLIKE( <subject> , <pattern> [ , <parameters> ] )

-- 2nd syntax
<subject> [ NOT ] RLIKE <pattern>

-- Example 5881
CREATE OR REPLACE TABLE rlike_ex(city VARCHAR(20));
INSERT INTO rlike_ex VALUES ('Sacramento'), ('San Francisco'), ('San Jose'), (null);

-- Example 5882
SELECT * FROM rlike_ex WHERE RLIKE(city, 'san.*', 'i');

-- Example 5883
+---------------+
| CITY          |
|---------------|
| San Francisco |
| San Jose      |
+---------------+

-- Example 5884
SELECT * FROM rlike_ex WHERE NOT RLIKE(city, 'san.*', 'i');

-- Example 5885
+------------+
| CITY       |
|------------|
| Sacramento |
+------------+

-- Example 5886
SELECT RLIKE('800-456-7891',
             $$[2-9]\d{2}-\d{3}-\d{4}$$) AS matches_phone_number;

-- Example 5887
+----------------------+
| MATCHES_PHONE_NUMBER |
|----------------------|
| True                 |
+----------------------+

-- Example 5888
SELECT RLIKE('jsmith@email.com',
             $$\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$$) AS matches_email_address;

-- Example 5889
+-----------------------+
| MATCHES_EMAIL_ADDRESS |
|-----------------------|
| True                  |
+-----------------------+

-- Example 5890
SELECT RLIKE('800-456-7891',
             '[2-9]\\d{2}-\\d{3}-\\d{4}') AS matches_phone_number;

-- Example 5891
+----------------------+
| MATCHES_PHONE_NUMBER |
|----------------------|
| True                 |
+----------------------+

-- Example 5892
SELECT RLIKE('jsmith@email.com',
             '\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}') AS matches_email_address;

-- Example 5893
+-----------------------+
| MATCHES_EMAIL_ADDRESS |
|-----------------------|
| True                  |
+-----------------------+

-- Example 5894
SELECT RLIKE('800-456-7891',
             '[2-9][0-9]{2}-[0-9]{3}-[0-9]{4}') AS matches_phone_number;

-- Example 5895
+----------------------+
| MATCHES_PHONE_NUMBER |
|----------------------|
| True                 |
+----------------------+

-- Example 5896
SELECT RLIKE('jsmith@email.com',
             '[a-zA-Z_]+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}') AS matches_email_address;

-- Example 5897
+-----------------------+
| MATCHES_EMAIL_ADDRESS |
|-----------------------|
| True                  |
+-----------------------+

-- Example 5898
SELECT * FROM rlike_ex WHERE city RLIKE 'San.* [fF].*';

-- Example 5899
+---------------+
| CITY          |
|---------------|
| San Francisco |
+---------------+

-- Example 5900
ROUND( <input_expr> [ , <scale_expr> [ , <rounding_mode> ] ] )

-- Example 5901
ROUND( EXPR => <input_expr> ,
       SCALE => <scale_expr>
       [ , ROUNDING_MODE => <rounding_mode>  ] )

-- Example 5902
SELECT ROUND(135.135), ROUND(-975.975);
+----------------+-----------------+
| ROUND(135.135) | ROUND(-975.975) |
|----------------+-----------------|
|            135 |            -976 |
+----------------+-----------------+

-- Example 5903
SELECT n, scale, ROUND(n, scale)
  FROM test_ceiling
  ORDER BY n, scale;
+----------+-------+-----------------+
|        N | SCALE | ROUND(N, SCALE) |
|----------+-------+-----------------|
| -975.975 |    -1 |        -980     |
| -975.975 |     0 |        -976     |
| -975.975 |     2 |        -975.98  |
|  135.135 |    -2 |         100     |
|  135.135 |     0 |         135     |
|  135.135 |     1 |         135.1   |
|  135.135 |     3 |         135.135 |
|  135.135 |    50 |         135.135 |
|  135.135 |  NULL |            NULL |
+----------+-------+-----------------+

-- Example 5904
SELECT ROUND(2.5, 0), ROUND(2.5, 0, 'HALF_TO_EVEN');

-- Example 5905
+---------------+-------------------------------+
| ROUND(2.5, 0) | ROUND(2.5, 0, 'HALF_TO_EVEN') |
|---------------+-------------------------------|
|             3 |                             2 |
+---------------+-------------------------------+

-- Example 5906
SELECT ROUND(-2.5, 0), ROUND(2.5, 0, 'HALF_TO_EVEN');

-- Example 5907
+---------------+--------------------------------+
| ROUND(2.5, 0) | ROUND(-2.5, 0, 'HALF_TO_EVEN') |
|---------------+--------------------------------|
|            -3 |                             -2 |
+---------------+--------------------------------+

-- Example 5908
SELECT ROUND(
  EXPR => -2.5,
  SCALE => 0);

-- Example 5909
+---------------------------------+
| ROUND(EXPR => -2.5, SCALE => 0) |
|---------------------------------|
|                              -3 |
+---------------------------------+

-- Example 5910
SELECT ROUND(
  EXPR => -2.5,
  SCALE => 0,
  ROUNDING_MODE => 'HALF_TO_EVEN');

-- Example 5911
+------------------------------------------------------------------+
| ROUND(EXPR => -2.5, SCALE => 0, ROUNDING_MODE => 'HALF_TO_EVEN') |
|------------------------------------------------------------------|
|                                                               -2 |
+------------------------------------------------------------------+

-- Example 5912
CREATE OR REPLACE TEMP TABLE rnd1(f float, d DECIMAL(10, 3));
INSERT INTO rnd1 (f, d) VALUES
      ( -10.005,  -10.005),
      (  -1.005,   -1.005),
      (   1.005,    1.005),
      (  10.005,   10.005)
      ;

-- Example 5913
select f, round(f, 2), 
       d, round(d, 2) 
    from rnd1 
    order by 1;
+---------+-------------+---------+-------------+
|       F | ROUND(F, 2) |       D | ROUND(D, 2) |
|---------+-------------+---------+-------------|
| -10.005 |      -10.01 | -10.005 |      -10.01 |
|  -1.005 |       -1    |  -1.005 |       -1.01 |
|   1.005 |        1    |   1.005 |        1.01 |
|  10.005 |       10.01 |  10.005 |       10.01 |
+---------+-------------+---------+-------------+

-- Example 5914
ROW_NUMBER() OVER (
  [ PARTITION BY <expr1> [, <expr2> ... ] ]
  ORDER BY <expr3> [ , <expr4> ... ] [ { ASC | DESC } ]
  )

-- Example 5915
SELECT
    symbol,
    exchange,
    shares,
    ROW_NUMBER() OVER (PARTITION BY exchange ORDER BY shares) AS row_number
  FROM trades;

-- Example 5916
+------+--------+------+----------+
|SYMBOL|EXCHANGE|SHARES|ROW_NUMBER|
+------+--------+------+----------+
|SPY   |C       |   250|         1|
|AAPL  |C       |   250|         2|
|AAPL  |C       |   300|         3|
|SPY   |N       |   100|         1|
|AAPL  |N       |   300|         2|
|SPY   |N       |   500|         3|
|QQQ   |N       |   800|         4|
|QQQ   |N       |  2000|         5|
|YHOO  |N       |  5000|         6|
+------+--------+------+----------+

-- Example 5917
RPAD( <base>, <length_expr> [, <pad>] )

-- Example 5918
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

-- Example 5919
SELECT * FROM padding_example;

-- Example 5920
+----------------+------------------------------+
| V              | B                            |
|----------------+------------------------------|
| Hi             | 4869                         |
| -123.00        | 2D3132332E3030               |
| Twelve Dollars | 5477656C766520446F6C6C617273 |
+----------------+------------------------------+

-- Example 5921
SELECT v,
       RPAD(v, 10, '_') AS pad_with_underscore,
       RPAD(v, 10, '$') AS pad_with_dollar_sign
  FROM padding_example
  ORDER BY v;

-- Example 5922
+----------------+---------------------+----------------------+
| V              | PAD_WITH_UNDERSCORE | PAD_WITH_DOLLAR_SIGN |
|----------------+---------------------+----------------------|
| -123.00        | -123.00___          | -123.00$$$           |
| Hi             | Hi________          | Hi$$$$$$$$           |
| Twelve Dollars | Twelve Dol          | Twelve Dol           |
+----------------+---------------------+----------------------+

-- Example 5923
SELECT b,
       RPAD(b, 10, TO_BINARY(HEX_ENCODE('_'))) AS pad_with_underscore,
       RPAD(b, 10, TO_BINARY(HEX_ENCODE('$'))) AS pad_with_dollar_sign
  FROM padding_example
  ORDER BY b;

-- Example 5924
+------------------------------+----------------------+----------------------+
| B                            | PAD_WITH_UNDERSCORE  | PAD_WITH_DOLLAR_SIGN |
|------------------------------+----------------------+----------------------|
| 2D3132332E3030               | 2D3132332E30305F5F5F | 2D3132332E3030242424 |
| 4869                         | 48695F5F5F5F5F5F5F5F | 48692424242424242424 |
| 5477656C766520446F6C6C617273 | 5477656C766520446F6C | 5477656C766520446F6C |
+------------------------------+----------------------+----------------------+

-- Example 5925
SELECT RPAD('123.50', 19, '*_');

-- Example 5926
+--------------------------+
| RPAD('123.50', 19, '*_') |
|--------------------------|
| 123.50*_*_*_*_*_*_*      |
+--------------------------+

-- Example 5927
RTRIM(<expr> [, <characters> ])

-- Example 5928
SELECT RTRIM('$125.00', '0.');

-- Example 5929
+------------------------+
| RTRIM('$125.00', '0.') |
|------------------------|
| $125                   |
+------------------------+

-- Example 5930
CREATE OR REPLACE TABLE test_rtrim_function(column1 VARCHAR);

INSERT INTO test_rtrim_function VALUES ('Trailing Spaces#  ');

-- Example 5931
SELECT CONCAT('>', CONCAT(column1, '<')) AS original_value,
       CONCAT('>', CONCAT(RTRIM(column1), '<')) AS trimmed_value
  FROM test_rtrim_function;

-- Example 5932
+----------------------+--------------------+
| ORIGINAL_VALUE       | TRIMMED_VALUE      |
|----------------------+--------------------|
| >Trailing Spaces#  < | >Trailing Spaces#< |
+----------------------+--------------------+

-- Example 5933
SELECT CONCAT('>', CONCAT(column1, '<')) AS original_value,
       CONCAT('>', CONCAT(RTRIM(column1, '# '), '<')) AS trimmed_value
  FROM test_rtrim_function;

-- Example 5934
+----------------------+-------------------+
| ORIGINAL_VALUE       | TRIMMED_VALUE     |
|----------------------+-------------------|
| >Trailing Spaces#  < | >Trailing Spaces< |
+----------------------+-------------------+

-- Example 5935
RTRIMMED_LENGTH( <string_expr> )

-- Example 5936
SELECT RTRIMMED_LENGTH(' ABCD ');

+---------------------------+
| RTRIMMED_LENGTH(' ABCD ') |
|---------------------------|
|                         5 |
+---------------------------+

-- Example 5937
SNOWFLAKE.NOTIFICATION.SANITIZE_WEBHOOK_CONTENT( <message> )

-- Example 5938
SNOWFLAKE.ALERT.SCHEDULED_TIME()

-- Example 5939
GRANT DATABASE ROLE snowflake.alert_viewer TO ROLE alert_role;

-- Example 5940
SEARCH( <search_data>, <search_string>
  [ , ANALYZER => '<analyzer_name>' ]
  [ , SEARCH_MODE => { 'OR' | 'AND' } ] )

-- Example 5941
(mytable.*)

-- Example 5942
(* ILIKE 'col1%')

-- Example 5943
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

