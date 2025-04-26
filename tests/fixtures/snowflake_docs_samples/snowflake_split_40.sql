-- Example 2653
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'LOWER' |
|-------------------------------------------------|
| False                                           |
+-------------------------------------------------+

-- Example 2654
SELECT CONTAINS('\u03b9\u0308', '\u03b9' COLLATE 'en-ci');

-- Example 2655
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U03B9' COLLATE 'EN-CI') |
|----------------------------------------------------|
| False                                              |
+----------------------------------------------------+

-- Example 2656
SELECT CONTAINS('\u03b9\u0308', '\u0308' COLLATE 'en-ci');

-- Example 2657
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U0308' COLLATE 'EN-CI') |
|----------------------------------------------------|
| False                                              |
+----------------------------------------------------+

-- Example 2658
SELECT CONTAINS('\u03b9\u0308', '\u03b9' COLLATE 'upper');

-- Example 2659
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U03B9' COLLATE 'UPPER') |
|----------------------------------------------------|
| True                                               |
+----------------------------------------------------+

-- Example 2660
SELECT CONTAINS('\u03b9\u0308', '\u0308' COLLATE 'upper');

-- Example 2661
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U0308' COLLATE 'UPPER') |
|----------------------------------------------------|
| True                                               |
+----------------------------------------------------+

-- Example 2662
SELECT CONTAINS('ß' , 's' COLLATE 'upper');

-- Example 2663
+--------------------------------------+
| CONTAINS('SS' , 'S' COLLATE 'UPPER') |
|--------------------------------------|
| False                                |
+--------------------------------------+

-- Example 2664
SELECT CONTAINS('ss', 's' COLLATE 'upper');

-- Example 2665
+-------------------------------------+
| CONTAINS('SS', 'S' COLLATE 'UPPER') |
|-------------------------------------|
| True                                |
+-------------------------------------+

-- Example 2666
SELECT '+' < '-' COLLATE 'en-ci';

-- Example 2667
+---------------------------+
| '+' < '-' COLLATE 'EN-CI '|
|---------------------------|
| False                     |
+---------------------------+

-- Example 2668
SELECT '+' < '-' COLLATE 'upper';

-- Example 2669
+---------------------------+
| '+' < '-' COLLATE 'UPPER' |
|---------------------------|
| True                      |
+---------------------------+

-- Example 2670
SELECT 'a\u0001b' < 'ab' COLLATE 'en-ci';

-- Example 2671
+-----------------------------------+
| 'A\U0001B' < 'AB' COLLATE 'EN-CI' |
|-----------------------------------|
| False                             |
+-----------------------------------+

-- Example 2672
SELECT 'a\u0001b' < 'ab' COLLATE 'upper';

-- Example 2673
+-----------------------------------+
| 'A\U0001B' < 'AB' COLLATE 'UPPER' |
|-----------------------------------|
| True                              |
+-----------------------------------+

-- Example 2674
SELECT 'abc' < '❄' COLLATE 'en-ci';

-- Example 2675
+-----------------------------+
| 'ABC' < '❄' COLLATE 'EN-CI' |
|-----------------------------|
| False                       |
+-----------------------------+

-- Example 2676
SELECT 'abc' < '❄' COLLATE 'upper';

-- Example 2677
+-----------------------------+
| 'ABC' < '❄' COLLATE 'UPPER' |
|-----------------------------|
| True                        |
+-----------------------------+

-- Example 2678
COLLATE(VARIANT_COL:fld1::VARCHAR, 'en-ci') = VARIANT_COL:fld2::VARCHAR

-- Example 2679
CREATE OR REPLACE TABLE collation_demo (
  uncollated_phrase VARCHAR, 
  utf8_phrase VARCHAR COLLATE 'utf8',
  english_phrase VARCHAR COLLATE 'en',
  spanish_phrase VARCHAR COLLATE 'es');

INSERT INTO collation_demo (
      uncollated_phrase, 
      utf8_phrase, 
      english_phrase, 
      spanish_phrase) 
   VALUES (
     'pinata', 
     'pinata', 
     'pinata', 
     'piñata');

-- Example 2680
SELECT * FROM collation_demo;

-- Example 2681
+-------------------+-------------+----------------+----------------+
| UNCOLLATED_PHRASE | UTF8_PHRASE | ENGLISH_PHRASE | SPANISH_PHRASE |
|-------------------+-------------+----------------+----------------|
| pinata            | pinata      | pinata         | piñata         |
+-------------------+-------------+----------------+----------------+

-- Example 2682
SELECT * FROM collation_demo WHERE spanish_phrase = uncollated_phrase;

-- Example 2683
+-------------------+-------------+----------------+----------------+
| UNCOLLATED_PHRASE | UTF8_PHRASE | ENGLISH_PHRASE | SPANISH_PHRASE |
|-------------------+-------------+----------------+----------------|
+-------------------+-------------+----------------+----------------+

-- Example 2684
CREATE OR REPLACE TABLE collation_demo1 (
  uncollated_phrase VARCHAR, 
  utf8_phrase VARCHAR COLLATE 'utf8',
  english_phrase VARCHAR COLLATE 'en-ai',
  spanish_phrase VARCHAR COLLATE 'es-ai');

INSERT INTO collation_demo1 (
    uncollated_phrase, 
    utf8_phrase, 
    english_phrase, 
    spanish_phrase) 
  VALUES (
    'piñata', 
    'piñata', 
    'piñata', 
    'piñata');

SELECT uncollated_phrase = 'pinata', 
       utf8_phrase = 'pinata', 
       english_phrase = 'pinata', 
       spanish_phrase = 'pinata'
  FROM collation_demo1;

-- Example 2685
+------------------------------+------------------------+---------------------------+---------------------------+
| UNCOLLATED_PHRASE = 'PINATA' | UTF8_PHRASE = 'PINATA' | ENGLISH_PHRASE = 'PINATA' | SPANISH_PHRASE = 'PINATA' |
|------------------------------+------------------------+---------------------------+---------------------------|
| False                        | False                  | True                      | False                     |
+------------------------------+------------------------+---------------------------+---------------------------+

-- Example 2686
INSERT INTO collation_demo (spanish_phrase) VALUES
  ('piña colada'),
  ('Pinatubo (Mount)'),
  ('pint'),
  ('Pinta');

-- Example 2687
SELECT spanish_phrase FROM collation_demo 
  ORDER BY spanish_phrase;

-- Example 2688
+------------------+
| SPANISH_PHRASE   |
|------------------|
| Pinatubo (Mount) |
| pint             |
| Pinta            |
| piña colada      |
| piñata           |
+------------------+

-- Example 2689
SELECT spanish_phrase FROM collation_demo 
  ORDER BY COLLATE(spanish_phrase, 'utf8');

-- Example 2690
+------------------+
| SPANISH_PHRASE   |
|------------------|
| Pinatubo (Mount) |
| Pinta            |
| pint             |
| piña colada      |
| piñata           |
+------------------+

-- Example 2691
CREATE OR REPLACE TABLE collation_demo2 (
  c1 VARCHAR COLLATE 'fr', 
  c2 VARCHAR COLLATE '');

INSERT INTO collation_demo2 (c1, c2) VALUES
  ('a', 'a'),
  ('b', 'b');

-- Example 2692
SELECT DISTINCT COLLATION(c1), COLLATION(c2) FROM collation_demo2;

-- Example 2693
+---------------+---------------+
| COLLATION(C1) | COLLATION(C2) |
|---------------+---------------|
| fr            | NULL          |
+---------------+---------------+

-- Example 2694
DESC TABLE collation_demo2;

-- Example 2695
+------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type                           | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| C1   | VARCHAR(16777216) COLLATE 'fr' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
| C2   | VARCHAR(16777216)              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+--------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 2696
select to_varchar(-123.45, '999.99MI') as EXAMPLE;

-- Example 2697
create table sample_numbers (f float);
insert into sample_numbers (f) values (1.2);
insert into sample_numbers (f) values (123.456);
insert into sample_numbers (f) values (1234.56);
insert into sample_numbers (f) values (-123456.789);
select to_varchar(f, '999,999.999'), to_varchar(f, 'S000,000.000') from sample_numbers;

-- Example 2698
+------------------------------+-------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'S000,000.000') |
+==============================+===============================+
|        1.2                   | +000,001.200                  |
+------------------------------+-------------------------------+
|      123.456                 | +000,123.456                  |
+------------------------------+-------------------------------+
|    1,234.56                  | +001,234.560                  |
+------------------------------+-------------------------------+
| -123,456.789                 | -123,456.789                  |
+------------------------------+-------------------------------+

-- Example 2699
select to_varchar(f, '999,999.999'), to_varchar(f, 'S999,999.999') from sample_numbers;

-- Example 2700
+------------------------------+-------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'S999,999.999') |
+==============================+===============================+
|        1.2                   |       +1.2                    |
+------------------------------+-------------------------------+
|      123.456                 |     +123.456                  |
+------------------------------+-------------------------------+
|    1,234.56                  |   +1,234.56                   |
+------------------------------+-------------------------------+
| -123,456.789                 | -123,456.789                  |
+------------------------------+-------------------------------+

-- Example 2701
select  to_varchar(f, '999,999.999'), to_varchar(f, 'FM999,999.999') from sample_numbers;

-- Example 2702
+------------------------------+--------------------------------+
| TO_VARCHAR(F, '999,999.999') | TO_VARCHAR(F, 'FM999,999.999') |
+==============================+================================+
|        1.2                   | 1.2                            |
+------------------------------+--------------------------------+
|      123.456                 | 123.456                        |
+------------------------------+--------------------------------+
|    1,234.56                  | 1,234.56                       |
+------------------------------+--------------------------------+
| -123,456.789                 | -123,456.789                   |
+------------------------------+--------------------------------+

-- Example 2703
select to_char(1234, '9d999EE'), 'will look like', '1.234E3';

-- Example 2704
+--------------------------+------------------+-----------+
| TO_CHAR(1234, '9D999EE') | 'WILL LOOK LIKE' | '1.234E3' |
+==========================+==================+===========+
| 1.234E3                  |  will look like  |  1.234E3  |
+--------------------------+------------------+-----------+

-- Example 2705
select to_char(12, '">"99"<"');

-- Example 2706
+-------+
| > 12< |
+-------+

-- Example 2707
-- All of the following convert the input to the number 12,345.67.
SELECT TO_NUMBER('012,345.67', '999,999.99', 8, 2);
SELECT TO_NUMBER('12,345.67', '999,999.99', 8, 2);
SELECT TO_NUMBER(' 12,345.67', '999,999.99', 8, 2);
-- The first of the following works, but the others will not convert.
-- (They are not supposed to convert, so "failure" is correct.)
SELECT TO_NUMBER('012,345.67', '000,000.00', 8, 2);
SELECT TO_NUMBER('12,345.67', '000,000.00', 8, 2);
SELECT TO_NUMBER(' 12,345.67', '000,000.00', 8, 2);

-- Example 2708
-- Create the table and insert data.
create table format1 (v varchar, i integer);
insert into format1 (v) values ('-101');
insert into format1 (v) values ('102-');
insert into format1 (v) values ('103');

-- Try to convert varchar to integer without a
-- format model.  This fails (as expected)
-- with a message similar to:
--    "Numeric value '102-' is not recognized"
update format1 set i = TO_NUMBER(v);

-- Now try again with a format specifier that allows the minus sign
-- to be at either the beginning or the end of the number.
-- Note the use of the vertical bar ("|") to indicate that
-- either format is acceptable.
update format1 set i = TO_NUMBER(v, 'MI999|999MI');
select i from format1;

-- Example 2709
SET my_variable=10;
SET my_variable='example';

-- Example 2710
SET (var1, var2, var3)=(10, 20, 30);
SET (var1, var2, var3)=(SELECT 10, 20, 30);

-- Example 2711
// Build connection properties
Properties properties = new Properties();

// Required connection properties
properties.put("user"    ,  "jsmith"      );
properties.put("password",  "mypassword");
properties.put("account" ,  "myaccount");

// Set some additional variables.
properties.put("$variable_1", "some example");
properties.put("$variable_2", "1"           );

// Create a new connection
String connectStr = "jdbc:snowflake://localhost:8080";

// Open a connection under the snowflake account and enable variable support
Connection con = DriverManager.getConnection(connectStr, properties);

-- Example 2712
SET (min, max)=(40, 70);

SELECT $min;

SELECT AVG(salary) FROM emp WHERE age BETWEEN $min AND $max;

-- Example 2713
SET my_table_name='table1';

-- Example 2714
CREATE TABLE IDENTIFIER($my_table_name) (i INTEGER);
INSERT INTO IDENTIFIER($my_table_name) (i) VALUES (42);

-- Example 2715
SELECT * FROM IDENTIFIER($my_table_name);

-- Example 2716
+----+
|  I |
|----|
| 42 |
+----+

-- Example 2717
SELECT * FROM TABLE($my_table_name);

-- Example 2718
+----+
|  I |
|----|
| 42 |
+----+

-- Example 2719
DROP TABLE IDENTIFIER($my_table_name);

-- Example 2720
SET (min, max)=(40, 70);

