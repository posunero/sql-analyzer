-- Example 5142
JAROWINKLER_SIMILARITY( <string_expr1> , <string_expr2> )

-- Example 5143
SELECT s, t, JAROWINKLER_SIMILARITY(s, t), JAROWINKLER_SIMILARITY(t, s) FROM ed;

----------------+-----------------+------------------------------+------------------------------+
      S         |        T        | JAROWINKLER_SIMILARITY(S, T) | JAROWINKLER_SIMILARITY(T, S) |
----------------+-----------------+------------------------------+------------------------------+
                |                 | 0                            | 0                            |
 Gute nacht     | Ich weis nicht  | 56                           | 56                           |
 Ich weiß nicht | Ich wei? nicht  | 98                           | 98                           |
 Ich weiß nicht | Ich weiss nicht | 97                           | 97                           |
 Ich weiß nicht | [NULL]          | [NULL]                       | [NULL]                       |
 Snowflake      | Oracle          | 61                           | 61                           |
 święta         | swieta          | 77                           | 77                           |
 [NULL]         |                 | [NULL]                       | [NULL]                       |
 [NULL]         | [NULL]          | [NULL]                       | [NULL]                       |
----------------+-----------------+------------------------------+------------------------------+

-- Example 5144
JSON_EXTRACT_PATH_TEXT( <column_identifier> , '<path_name>' )

-- Example 5145
CREATE TABLE demo1 (id INTEGER, json_data VARCHAR);
INSERT INTO demo1 SELECT
   1, '{"level_1_key": "level_1_value"}';
INSERT INTO demo1 SELECT
   2, '{"level_1_key": {"level_2_key": "level_2_value"}}';
INSERT INTO demo1 SELECT
   3, '{"level_1_key": {"level_2_key": ["zero", "one", "two"]}}';

-- Example 5146
SELECT 
        TO_VARCHAR(GET_PATH(PARSE_JSON(json_data), 'level_1_key')) 
            AS OLD_WAY,
        JSON_EXTRACT_PATH_TEXT(json_data, 'level_1_key')
            AS JSON_EXTRACT_PATH_TEXT
    FROM demo1
    ORDER BY id;
+--------------------------------------+--------------------------------------+
| OLD_WAY                              | JSON_EXTRACT_PATH_TEXT               |
|--------------------------------------+--------------------------------------|
| level_1_value                        | level_1_value                        |
| {"level_2_key":"level_2_value"}      | {"level_2_key":"level_2_value"}      |
| {"level_2_key":["zero","one","two"]} | {"level_2_key":["zero","one","two"]} |
+--------------------------------------+--------------------------------------+

-- Example 5147
SELECT 
        TO_VARCHAR(GET_PATH(PARSE_JSON(json_data), 'level_1_key.level_2_key'))
            AS OLD_WAY,
        JSON_EXTRACT_PATH_TEXT(json_data, 'level_1_key.level_2_key')
            AS JSON_EXTRACT_PATH_TEXT
    FROM demo1
    ORDER BY id;
+----------------------+------------------------+
| OLD_WAY              | JSON_EXTRACT_PATH_TEXT |
|----------------------+------------------------|
| NULL                 | NULL                   |
| level_2_value        | level_2_value          |
| ["zero","one","two"] | ["zero","one","two"]   |
+----------------------+------------------------+

-- Example 5148
SELECT 
      TO_VARCHAR(GET_PATH(PARSE_JSON(json_data), 'level_1_key.level_2_key[1]'))
          AS OLD_WAY,
      JSON_EXTRACT_PATH_TEXT(json_data, 'level_1_key.level_2_key[1]')
          AS JSON_EXTRACT_PATH_TEXT
    FROM demo1
    ORDER BY id;
+---------+------------------------+
| OLD_WAY | JSON_EXTRACT_PATH_TEXT |
|---------+------------------------|
| NULL    | NULL                   |
| NULL    | NULL                   |
| one     | one                    |
+---------+------------------------+

-- Example 5149
LAG ( <expr> [ , <offset> , <default> ] ) [ { IGNORE | RESPECT } NULLS ]
    OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] )

-- Example 5150
CREATE OR REPLACE TABLE sales(emp_id INTEGER, year INTEGER, revenue DECIMAL(10,2));

-- Example 5151
INSERT INTO sales VALUES 
    (0, 2010, 1000), 
    (0, 2011, 1500), 
    (0, 2012, 500), 
    (0, 2013, 750);
INSERT INTO sales VALUES 
    (1, 2010, 10000), 
    (1, 2011, 12500), 
    (1, 2012, 15000), 
    (1, 2013, 20000);
INSERT INTO sales VALUES 
    (2, 2012, 500), 
    (2, 2013, 800);

-- Example 5152
SELECT emp_id, year, revenue, 
       revenue - LAG(revenue, 1, 0) OVER (PARTITION BY emp_id ORDER BY year) AS diff_to_prev 
    FROM sales 
    ORDER BY emp_id, year;
+--------+------+----------+--------------+
| EMP_ID | YEAR |  REVENUE | DIFF_TO_PREV |
|--------+------+----------+--------------|
|      0 | 2010 |  1000.00 |      1000.00 |
|      0 | 2011 |  1500.00 |       500.00 |
|      0 | 2012 |   500.00 |     -1000.00 |
|      0 | 2013 |   750.00 |       250.00 |
|      1 | 2010 | 10000.00 |     10000.00 |
|      1 | 2011 | 12500.00 |      2500.00 |
|      1 | 2012 | 15000.00 |      2500.00 |
|      1 | 2013 | 20000.00 |      5000.00 |
|      2 | 2012 |   500.00 |       500.00 |
|      2 | 2013 |   800.00 |       300.00 |
+--------+------+----------+--------------+

-- Example 5153
CREATE OR REPLACE TABLE t1 (col_1 NUMBER, col_2 NUMBER);

-- Example 5154
INSERT INTO t1 VALUES 
    (1, 5),
    (2, 4),
    (3, NULL),
    (4, 2),
    (5, NULL),
    (6, NULL),
    (7, 6);

-- Example 5155
SELECT col_1, col_2, LAG(col_2) IGNORE NULLS OVER (ORDER BY col_1) 
    FROM t1
    ORDER BY col_1;
+-------+-------+-----------------------------------------------+
| COL_1 | COL_2 | LAG(COL_2) IGNORE NULLS OVER (ORDER BY COL_1) |
|-------+-------+-----------------------------------------------|
|     1 |     5 |                                          NULL |
|     2 |     4 |                                             5 |
|     3 |  NULL |                                             4 |
|     4 |     2 |                                             4 |
|     5 |  NULL |                                             2 |
|     6 |  NULL |                                             2 |
|     7 |     6 |                                             2 |
+-------+-------+-----------------------------------------------+

-- Example 5156
LAST_DAY( <date_or_time_expr> [ , <date_part> ] )

-- Example 5157
SELECT TO_DATE('2015-05-08T23:39:20.123-07:00') AS "DATE",
       LAST_DAY("DATE") AS "LAST DAY OF MONTH";
+------------+-------------------+
| DATE       | LAST DAY OF MONTH |
|------------+-------------------|
| 2015-05-08 | 2015-05-31        |
+------------+-------------------+

-- Example 5158
SELECT TO_DATE('2015-05-08T23:39:20.123-07:00') AS "DATE",
       LAST_DAY("DATE", 'year') AS "LAST DAY OF YEAR";
+------------+------------------+
| DATE       | LAST DAY OF YEAR |
|------------+------------------|
| 2015-05-08 | 2015-12-31       |
+------------+------------------+

-- Example 5159
LAST_QUERY_ID( [ <num> ] )

-- Example 5160
SELECT LAST_QUERY_ID();

-- Example 5161
SELECT LAST_QUERY_ID(1);

-- Example 5162
SNOWFLAKE.ALERT.LAST_SUCCESSFUL_SCHEDULED_TIME()

-- Example 5163
GRANT DATABASE ROLE snowflake.alert_viewer TO ROLE alert_role;

-- Example 5164
LAST_TRANSACTION()

-- Example 5165
SELECT LAST_TRANSACTION();

-- Example 5166
+---------------------+
| LAST_TRANSACTION()  |
|---------------------|
| 1661899308790000000 |
+---------------------+

-- Example 5167
LAST_VALUE( <expr> ) [ { IGNORE | RESPECT } NULLS ]
  OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] [ NULLS { FIRST | LAST } ] [ <window_frame> ] )

-- Example 5168
PARTITION BY column_1, column_2

-- Example 5169
ORDER BY column_3, column_4

-- Example 5170
... OVER (PARTITION BY p ORDER BY o COLLATE 'lower') ...

-- Example 5171
SELECT
    column1,
    column2,
    LAST_VALUE(column2) OVER (PARTITION BY column1 ORDER BY column2) AS column2_last
  FROM VALUES
    (1, 10), (1, 11), (1, 12),
    (2, 20), (2, 21), (2, 22);

-- Example 5172
+---------+---------+--------------+
| COLUMN1 | COLUMN2 | COLUMN2_LAST |
|---------+---------+--------------|
|       1 |      10 |           12 |
|       1 |      11 |           12 |
|       1 |      12 |           12 |
|       2 |      20 |           22 |
|       2 |      21 |           22 |
|       2 |      22 |           22 |
+---------+---------+--------------+

-- Example 5173
CREATE TABLE demo1 (i INTEGER, partition_col INTEGER, order_col INTEGER);

INSERT INTO demo1 (i, partition_col, order_col) VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 1, 3),
  (4, 1, 4),
  (5, 1, 5),
  (1, 2, 1),
  (2, 2, 2),
  (3, 2, 3),
  (4, 2, 4);

-- Example 5174
SELECT
    partition_col, order_col, i,
    FIRST_VALUE(i)  OVER (PARTITION BY partition_col ORDER BY order_col
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS FIRST_VAL,
    NTH_VALUE(i, 2) OVER (PARTITION BY partition_col ORDER BY order_col
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS NTH_VAL,
    LAST_VALUE(i)   OVER (PARTITION BY partition_col ORDER BY order_col
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS LAST_VAL
  FROM demo1
  ORDER BY partition_col, i, order_col;

-- Example 5175
+---------------+-----------+---+-----------+---------+----------+
| PARTITION_COL | ORDER_COL | I | FIRST_VAL | NTH_VAL | LAST_VAL |
|---------------+-----------+---+-----------+---------+----------|
|             1 |         1 | 1 |         1 |       2 |        2 |
|             1 |         2 | 2 |         1 |       2 |        3 |
|             1 |         3 | 3 |         2 |       3 |        4 |
|             1 |         4 | 4 |         3 |       4 |        5 |
|             1 |         5 | 5 |         4 |       5 |        5 |
|             2 |         1 | 1 |         1 |       2 |        2 |
|             2 |         2 | 2 |         1 |       2 |        3 |
|             2 |         3 | 3 |         2 |       3 |        4 |
|             2 |         4 | 4 |         3 |       4 |        4 |
+---------------+-----------+---+-----------+---------+----------+

-- Example 5176
LEAD ( <expr> [ , <offset> , <default> ] ) [ { IGNORE | RESPECT } NULLS ]
  OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ { ASC | DESC } ] )

-- Example 5177
CREATE OR REPLACE TABLE sales(emp_id INTEGER, year INTEGER, revenue DECIMAL(10,2));
INSERT INTO sales VALUES (0, 2010, 1000), (0, 2011, 1500), (0, 2012, 500), (0, 2013, 750);
INSERT INTO sales VALUES (1, 2010, 10000), (1, 2011, 12500), (1, 2012, 15000), (1, 2013, 20000);
INSERT INTO sales VALUES (2, 2012, 500), (2, 2013, 800);

SELECT emp_id, year, revenue,
    LEAD(revenue) OVER (PARTITION BY emp_id ORDER BY year) - revenue AS diff_to_next
  FROM sales
  ORDER BY emp_id, year;

-- Example 5178
+--------+------+----------+--------------+
| EMP_ID | YEAR |  REVENUE | DIFF_TO_NEXT |
|--------+------+----------+--------------|
|      0 | 2010 |  1000.00 |       500.00 |
|      0 | 2011 |  1500.00 |     -1000.00 |
|      0 | 2012 |   500.00 |       250.00 |
|      0 | 2013 |   750.00 |         NULL |
|      1 | 2010 | 10000.00 |      2500.00 |
|      1 | 2011 | 12500.00 |      2500.00 |
|      1 | 2012 | 15000.00 |      5000.00 |
|      1 | 2013 | 20000.00 |         NULL |
|      2 | 2012 |   500.00 |       300.00 |
|      2 | 2013 |   800.00 |         NULL |
+--------+------+----------+--------------+

-- Example 5179
CREATE OR REPLACE TABLE t1 (c1 NUMBER, c2 NUMBER);
INSERT INTO t1 VALUES (1,5),(2,4),(3,NULL),(4,2),(5,NULL),(6,NULL),(7,6);

SELECT c1, c2, LEAD(c2) IGNORE NULLS OVER (ORDER BY c1) FROM t1;

-- Example 5180
+----+------+------------------------------------------+
| C1 | C2   | LEAD(C2) IGNORE NULLS OVER (ORDER BY C1) |
|----+------+------------------------------------------|
|  1 |  5   |                                        4 |
|  2 |  4   |                                        2 |
|  3 | NULL |                                        2 |
|  4 |  2   |                                        6 |
|  5 | NULL |                                        6 |
|  6 | NULL |                                        6 |
|  7 |  6   |                                     NULL |
+----+------+------------------------------------------+

-- Example 5181
LEAST(( <expr1> [ , <expr2> ... ] )

-- Example 5182
SELECT LEAST(1, 3, 0, 4);

-- Example 5183
+-------------------+
| LEAST(1, 3, 0, 4) |
|-------------------|
|                 0 |
+-------------------+

-- Example 5184
SELECT col_1,
       col_2,
       col_3,
       LEAST(col_1, col_2, col_3) AS least
  FROM (SELECT 1 AS col_1, 2 AS col_2, 3 AS col_3
    UNION ALL
    SELECT 2, 4, -1
    UNION ALL
    SELECT 3, 6, NULL);

-- Example 5185
+-------+-------+-------+-------+
| COL_1 | COL_2 | COL_3 | LEAST |
|-------+-------+-------+-------|
|     1 |     2 |     3 |     1 |
|     2 |     4 |    -1 |    -1 |
|     3 |     6 |  NULL |  NULL |
+-------+-------+-------+-------+

-- Example 5186
LEAST_IGNORE_NULLS( <expr1> [ , <expr2> ... ] )

-- Example 5187
CREATE TABLE test_least_ignore_nulls (
  col_1 INTEGER,
  col_2 INTEGER,
  col_3 INTEGER,
  col_4 FLOAT);

INSERT INTO test_least_ignore_nulls (col_1, col_2, col_3, col_4) VALUES
  (1, 2,    3,  4.25),
  (2, 4,   -1,  NULL),
  (3, 6, NULL,  -2.75);

-- Example 5188
SELECT col_1,
       col_2,
       col_3,
       col_4,
       LEAST_IGNORE_NULLS(col_1, col_2, col_3, col_4) AS least_ignore_nulls
 FROM test_least_ignore_nulls
 ORDER BY col_1;

-- Example 5189
+-------+-------+-------+-------+--------------------+
| COL_1 | COL_2 | COL_3 | COL_4 | LEAST_IGNORE_NULLS |
|-------+-------+-------+-------+--------------------|
|     1 |     2 |     3 |  4.25 |               1    |
|     2 |     4 |    -1 |  NULL |              -1    |
|     3 |     6 |  NULL | -2.75 |              -2.75 |
+-------+-------+-------+-------+--------------------+

-- Example 5190
LEFT( <string_expr> , <length_expr> )

-- Example 5191
SELECT LEFT('ABCDEF', 3);

-- Example 5192
+-------------------+
| LEFT('ABCDEF', 3) |
|-------------------|
| ABC               |
+-------------------+

-- Example 5193
CREATE OR REPLACE TABLE customer_contact_example (
    cust_id INT,
    cust_email VARCHAR,
    cust_phone VARCHAR,
    activation_date VARCHAR)
  AS SELECT
    column1,
    column2,
    column3,
    column4
  FROM
    VALUES
      (1, 'some_text@example.com', '800-555-0100', '20210320'),
      (2, 'some_other_text@example.org', '800-555-0101', '20240509'),
      (3, 'some_different_text@example.net', '800-555-0102', '20191017');

SELECT * from customer_contact_example;

-- Example 5194
+---------+---------------------------------+--------------+-----------------+
| CUST_ID | CUST_EMAIL                      | CUST_PHONE   | ACTIVATION_DATE |
|---------+---------------------------------+--------------+-----------------|
|       1 | some_text@example.com           | 800-555-0100 | 20210320        |
|       2 | some_other_text@example.org     | 800-555-0101 | 20240509        |
|       3 | some_different_text@example.net | 800-555-0102 | 20191017        |
+---------+---------------------------------+--------------+-----------------+

-- Example 5195
SELECT cust_id,
       cust_email,
       LEFT(cust_email, POSITION('@' IN cust_email) - 1) AS username
  FROM customer_contact_example;

-- Example 5196
+---------+---------------------------------+---------------------+
| CUST_ID | CUST_EMAIL                      | USERNAME            |
|---------+---------------------------------+---------------------|
|       1 | some_text@example.com           | some_text           |
|       2 | some_other_text@example.org     | some_other_text     |
|       3 | some_different_text@example.net | some_different_text |
+---------+---------------------------------+---------------------+

-- Example 5197
SELECT cust_id,
       cust_phone,
       LEFT(cust_phone, 3) AS area_code
  FROM customer_contact_example;

-- Example 5198
+---------+--------------+-----------+
| CUST_ID | CUST_PHONE   | AREA_CODE |
|---------+--------------+-----------|
|       1 | 800-555-0100 | 800       |
|       2 | 800-555-0101 | 800       |
|       3 | 800-555-0102 | 800       |
+---------+--------------+-----------+

-- Example 5199
SELECT cust_id,
       activation_date,
       LEFT(activation_date, 4) AS year
  FROM customer_contact_example;

-- Example 5200
+---------+-----------------+------+
| CUST_ID | ACTIVATION_DATE | YEAR |
|---------+-----------------+------|
|       1 | 20210320        | 2021 |
|       2 | 20240509        | 2024 |
|       3 | 20191017        | 2019 |
+---------+-----------------+------+

-- Example 5201
LENGTH( <expression> )

LEN( <expression> )

-- Example 5202
CREATE OR REPLACE TABLE length_function_demo (s VARCHAR);

INSERT INTO length_function_demo VALUES
  (''),
  ('Joyeux Noël'),
  ('Merry Christmas'),
  ('Veselé Vianoce'),
  ('Wesołych Świąt'),
  ('圣诞节快乐'),
  (NULL);

-- Example 5203
SELECT s, LENGTH(s) FROM length_function_demo;

-- Example 5204
+-----------------+-----------+
| S               | LENGTH(S) |
|-----------------+-----------|
|                 |         0 |
| Joyeux Noël     |        11 |
| Merry Christmas |        15 |
| Veselé Vianoce  |        14 |
| Wesołych Świąt  |        14 |
| 圣诞节快乐        |         5 |
| NULL            |      NULL |
+-----------------+-----------+

-- Example 5205
CREATE OR REPLACE TABLE binary_demo_table (
  v VARCHAR,
  b_hex BINARY,
  b_base64 BINARY,
  b_utf8 BINARY);

INSERT INTO binary_demo_table (v) VALUES ('hello');

UPDATE binary_demo_table SET
  b_hex    = TO_BINARY(HEX_ENCODE(v), 'HEX'),
  b_base64 = TO_BINARY(BASE64_ENCODE(v), 'BASE64'),
  b_utf8   = TO_BINARY(v, 'UTF-8');

SELECT * FROM binary_demo_table;

-- Example 5206
+-------+------------+------------+------------+
| V     | B_HEX      | B_BASE64   | B_UTF8     |
|-------+------------+------------+------------|
| hello | 68656C6C6F | 68656C6C6F | 68656C6C6F |
+-------+------------+------------+------------+

-- Example 5207
SELECT v, LENGTH(v),
       TO_VARCHAR(b_hex, 'HEX') AS b_hex, LENGTH(b_hex),
       TO_VARCHAR(b_base64, 'BASE64') AS b_base64, LENGTH(b_base64),
       TO_VARCHAR(b_utf8, 'UTF-8') AS b_utf8, LENGTH(b_utf8)
  FROM binary_demo_table;

-- Example 5208
+-------+-----------+------------+---------------+----------+------------------+--------+----------------+
| V     | LENGTH(V) | B_HEX      | LENGTH(B_HEX) | B_BASE64 | LENGTH(B_BASE64) | B_UTF8 | LENGTH(B_UTF8) |
|-------+-----------+------------+---------------+----------+------------------+--------+----------------|
| hello |         5 | 68656C6C6F |             5 | aGVsbG8= |                5 | hello  |              5 |
+-------+-----------+------------+---------------+----------+------------------+--------+----------------+

