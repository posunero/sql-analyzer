-- Example 4874
+--------------------------+
| IFF(TRUE, NULL, 'FALSE') |
|--------------------------|
| NULL                     |
+--------------------------+

-- Example 4875
SELECT value, IFF(value::INT = value, 'integer', 'non-integer')
  FROM ( SELECT column1 AS value
           FROM VALUES(1.0), (1.1), (-3.1415), (-5.000), (NULL) )
  ORDER BY value DESC;

-- Example 4876
+---------+---------------------------------------------------+
|   VALUE | IFF(VALUE::INT = VALUE, 'INTEGER', 'NON-INTEGER') |
|---------+---------------------------------------------------|
|    NULL | non-integer                                       |
|  1.1000 | non-integer                                       |
|  1.0000 | integer                                           |
| -3.1415 | non-integer                                       |
| -5.0000 | integer                                           |
+---------+---------------------------------------------------+

-- Example 4877
SELECT value, IFF(value > 50, 'High', 'Low')
FROM ( SELECT column1 AS value
         FROM VALUES(22), (63), (5), (99), (NULL) );

-- Example 4878
+-------+--------------------------------+
| VALUE | IFF(VALUE > 50, 'HIGH', 'LOW') |
|-------+--------------------------------|
|    22 | Low                            |
|    63 | High                           |
|     5 | Low                            |
|    99 | High                           |
|  NULL | Low                            |
+-------+--------------------------------+

-- Example 4879
IFNULL( <expr1> , <expr2> )

-- Example 4880
CREATE TABLE IF NOT EXISTS suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(30),
  phone_region_1 VARCHAR(15),
  phone_region_2 VARCHAR(15));

-- Example 4881
INSERT INTO suppliers(supplier_id, supplier_name, phone_region_1, phone_region_2)
  VALUES(1, 'Company_ABC', NULL, '555-01111'),
        (2, 'Company_DEF', '555-01222', NULL),
        (3, 'Company_HIJ', '555-01333', '555-01444'),
        (4, 'Company_KLM', NULL, NULL);

-- Example 4882
SELECT supplier_id,
       supplier_name,
       phone_region_1,
       phone_region_2,
       IFNULL(phone_region_1, phone_region_2) IF_REGION_1_NULL,
       IFNULL(phone_region_2, phone_region_1) IF_REGION_2_NULL
  FROM suppliers
  ORDER BY supplier_id;

-- Example 4883
+-------------+---------------+----------------+----------------+------------------+------------------+
| SUPPLIER_ID | SUPPLIER_NAME | PHONE_REGION_1 | PHONE_REGION_2 | IF_REGION_1_NULL | IF_REGION_2_NULL |
|-------------+---------------+----------------+----------------+------------------+------------------|
|           1 | Company_ABC   | NULL           | 555-01111      | 555-01111        | 555-01111        |
|           2 | Company_DEF   | 555-01222      | NULL           | 555-01222        | 555-01222        |
|           3 | Company_HIJ   | 555-01333      | 555-01444      | 555-01333        | 555-01444        |
|           4 | Company_KLM   | NULL           | NULL           | NULL             | NULL             |
+-------------+---------------+----------------+----------------+------------------+------------------+

-- Example 4884
<subject> [ NOT ] ILIKE <pattern> [ ESCAPE <escape> ]

ILIKE( <subject> , <pattern> [ , <escape> ] )

-- Example 4885
'SOMETHING%' ILIKE '%\\%%' ESCAPE '\\';

-- Example 4886
CREATE OR REPLACE TABLE ilike_ex(name VARCHAR(20));
INSERT INTO ilike_ex VALUES
  ('John  Dddoe'),
  ('Joe   Doe'),
  ('John_down'),
  ('Joe down'),
  (null);

-- Example 4887
SELECT * 
  FROM ilike_ex 
  WHERE name ILIKE '%j%h%do%'
  ORDER BY 1;

-- Example 4888
+-------------+                                                                 
| NAME        |
|-------------|
| John  Dddoe |
| John_down   |
+-------------+

-- Example 4889
SELECT *
  FROM ilike_ex
  WHERE name NOT ILIKE '%j%h%do%'
  ORDER BY 1;

-- Example 4890
+-----------+
| NAME      |
|-----------|
| Joe   Doe |
| Joe down  |
+-----------+

-- Example 4891
SELECT * 
  FROM ilike_ex 
  WHERE name ILIKE '%j%h%^_do%' ESCAPE '^'
  ORDER BY 1;

-- Example 4892
+-----------+                                                                   
| NAME      |
|-----------|
| John_down |
+-----------+

-- Example 4893
<subject> ILIKE ANY (<pattern1> [, <pattern2> ... ] ) [ ESCAPE <escape_char> ]

-- Example 4894
SELECT ...
  WHERE x ILIKE ANY (SELECT ...)

-- Example 4895
CREATE OR REPLACE TABLE ilike_example(name VARCHAR(20));
INSERT INTO ilike_example VALUES
    ('jane doe'),
    ('Jane Doe'),
    ('JANE DOE'),
    ('John Doe'),
    ('John Smith');

-- Example 4896
SELECT * 
  FROM ilike_example 
  WHERE name ILIKE ANY ('jane%', '%SMITH')
  ORDER BY name;

-- Example 4897
+------------+                                                                  
| NAME       |
|------------|
| JANE DOE   |
| Jane Doe   |
| John Smith |
| jane doe   |
+------------+

-- Example 4898
<value> [ NOT ] IN ( <value_1> [ , <value_2> ...  ] )

-- Example 4899
( <value_A> [, <value_B> ... ] ) [ NOT ] IN (  ( <value_1> [ , <value_2> ... ] )  [ , ( <value_3> [ , <value_4> ... ] )  ...  ]  )

-- Example 4900
<value> [ NOT ] IN ( <subquery> )

-- Example 4901
SELECT NULL IN (1, 2, NULL) AS RESULT;

-- Example 4902
SELECT
    f(a, b),
    x IN (y, z) ...

-- Example 4903
SELECT
    f(a, b),
    IN(x, (y, z)) ...

-- Example 4904
SELECT 1 IN (1, 2, 3) AS RESULT;

-- Example 4905
+--------+
| RESULT |
|--------|
| True   |
+--------+

-- Example 4906
SELECT 4 NOT IN (1, 2, 3) AS RESULT;

-- Example 4907
+--------+
| RESULT |
|--------|
| True   |
+--------+

-- Example 4908
SELECT 'a' IN (
  SELECT column1 FROM VALUES ('b'), ('c'), ('d')
  ) AS RESULT;

-- Example 4909
+--------+
| RESULT |
|--------|
| False  |
+--------+

-- Example 4910
CREATE OR REPLACE TABLE in_function_demo (
  col_1 INTEGER,
  col_2 INTEGER,
  col_3 INTEGER);

INSERT INTO in_function_demo (col_1, col_2, col_3) VALUES
  (1, 1, 1),
  (1, 2, 3),
  (4, 5, NULL);

-- Example 4911
SELECT col_1, col_2, col_3
  FROM in_function_demo
  WHERE (col_1) IN (1, 10, 100, 1000)
  ORDER BY col_1, col_2, col_3;

-- Example 4912
+-------+-------+-------+
| COL_1 | COL_2 | COL_3 |
|-------+-------+-------|
|     1 |     1 |     1 |
|     1 |     2 |     3 |
+-------+-------+-------+

-- Example 4913
SELECT col_1, col_2, col_3
  FROM in_function_demo
  WHERE (col_1, col_2, col_3) IN (
    (1,2,3),
    (4,5,6));

-- Example 4914
+-------+-------+-------+
| COL_1 | COL_2 | COL_3 |
|-------+-------+-------|
|     1 |     2 |     3 |
+-------+-------+-------+

-- Example 4915
SELECT (1, 2, 3) IN (
  SELECT col_1, col_2, col_3 FROM in_function_demo
  ) AS RESULT;

-- Example 4916
+--------+
| RESULT |
|--------|
| True   |
+--------+

-- Example 4917
SELECT NULL IN (1, 2, NULL) AS RESULT;

-- Example 4918
+--------+
| RESULT |
|--------|
| NULL   |
+--------+

-- Example 4919
SELECT (4, 5, NULL) IN ( (4, 5, NULL), (7, 8, 9) ) AS RESULT;

-- Example 4920
+--------+
| RESULT |
|--------|
| NULL   |
+--------+

-- Example 4921
INITCAP( <expr> [ , '<delimiters>' ] )

-- Example 4922
<whitespace> ! ? @ " ^ # $ & ~ _ , . : ; + - * % / | \ [ ] ( ) { } < >

-- Example 4923
SELECT v, INITCAP(v) FROM testinit;

-- Example 4924
+---------------------------------+---------------------------------+
| C1                              | INITCAP(C1)                     |
|---------------------------------+---------------------------------|
| The Quick Gray Fox              | The Quick Gray Fox              |
| the sky is blue                 | The Sky Is Blue                 |
| OVER the River 2 Times          | Over The River 2 Times          |
| WE CAN HANDLE THIS              | We Can Handle This              |
| HelL0_hi+therE                  | Hell0_Hi+There                  |
| νησί του ποταμού                | Νησί Του Ποταμού                |
| ÄäÖößÜü                         | Ääöößüü                         |
| Hi,are?you!there                | Hi,Are?You!There                |
| to je dobré                     | To Je Dobré                     |
| ÉéÀàè]çÂâ ÊêÎÔô ÛûËÏ ïÜŸÇç ŒœÆæ | Ééààè]Çââ Êêîôô Ûûëï Ïüÿçç Œœææ |
| ĄąĆ ćĘęŁ łŃńÓ óŚśŹźŻż           | Ąąć Ćęęł Łńńó Óśśźźżż           |
| АаБб ВвГгД дЕеЁёЖ жЗзИиЙй       | Аабб Ввггд Дееёёж Жззиийй       |
| ХхЦц ЧчШш ЩщЪъ ЫыЬь ЭэЮ юЯя     | Ххцц Ччшш Щщъъ Ыыьь Ээю Юяя     |
| NULL                            | NULL                            |
+---------------------------------+---------------------------------+

-- Example 4925
SELECT INITCAP('this is the new Frame+work', '') AS initcap_result;

-- Example 4926
+----------------------------+
| INITCAP_RESULT             |
|----------------------------|
| This is the new frame+work |
+----------------------------+

-- Example 4927
SELECT INITCAP('iqamqinterestedqinqthisqtopic','q') AS initcap_result;

-- Example 4928
+-------------------------------+
| INITCAP_RESULT                |
|-------------------------------|
| IqAmqInterestedqInqThisqTopic |
+-------------------------------+

-- Example 4929
SELECT INITCAP('lion☂fRog potato⨊cLoUD', '⨊☂') AS initcap_result;

-- Example 4930
+------------------------+
| INITCAP_RESULT         |
|------------------------|
| Lion☂Frog potato⨊Cloud |
+------------------------+

-- Example 4931
SELECT INITCAP('apple is僉sweetandballIsROUND', '僉a b') AS initcap_result;

-- Example 4932
+-------------------------------+
| INITCAP_RESULT                |
|-------------------------------|
| aPple Is僉SweetaNdbaLlisround |
+-------------------------------+

-- Example 4933
INSERT( <base_expr>, <pos>, <len>, <insert_expr> )

-- Example 4934
SELECT INSERT('abc', 1, 2, 'Z') as STR;
+-----+
| STR |
|-----|
| Zc  |
+-----+

-- Example 4935
SELECT INSERT('abcdef', 3, 2, 'zzz') as STR;
+---------+
| STR     |
|---------|
| abzzzef |
+---------+

-- Example 4936
SELECT INSERT('abc', 2, 1, '') as STR;
+-----+
| STR |
|-----|
| ac  |
+-----+

-- Example 4937
SELECT INSERT('abc', 4, 0, 'Z') as STR;
+------+
| STR  |
|------|
| abcZ |
+------+

-- Example 4938
SELECT INSERT(NULL, 1, 2, 'Z') as STR;
+------+
| STR  |
|------|
| NULL |
+------+

-- Example 4939
SELECT INSERT('abc', NULL, 2, 'Z') as STR;
+------+
| STR  |
|------|
| NULL |
+------+

-- Example 4940
SELECT INSERT('abc', 1, NULL, 'Z') as STR;
+------+
| STR  |
|------|
| NULL |
+------+

