-- Example 2585
SHOW PARAMETERS LIKE 'time%' IN ACCOUNT;

-- Example 2586
CREATE TABLE test(c1 INTEGER, c2 STRING, c3 STRING COLLATE 'en-cs');

CREATE TABLE test(c1 INTEGER, c2 STRING COLLATE 'en-ci', c3 STRING COLLATE 'en-cs');

-- Example 2587
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 2588
{
  "certificate": "",
  "issuer": "",
  "ssoUrl": "",
  "type"  : "",
  "label" : ""
}

-- Example 2589
Shared view consumer simulation requires that the executing role owns the view.

-- Example 2590
alter session set TIMESTAMP_DAY_IS_ALWAYS_24H = true;

-- With DST beginning on 2018-03-11 at 2 AM, America/Los_Angeles time zone
select dateadd(day, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ), dateadd(day, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ);

+-------------------------------------------------------+-------------------------------------------------------+
| DATEADD(DAY, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ) | DATEADD(DAY, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ) |
|-------------------------------------------------------+-------------------------------------------------------|
| 2018-03-11 10:00:00.000 -0700                         | 2018-11-04 08:00:00.000 -0800                         |
+-------------------------------------------------------+-------------------------------------------------------+

alter session set TIMESTAMP_DAY_IS_ALWAYS_24H = false;

select dateadd(day, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ), dateadd(day, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ);

+-------------------------------------------------------+-------------------------------------------------------+
| DATEADD(DAY, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ) | DATEADD(DAY, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ) |
|-------------------------------------------------------+-------------------------------------------------------|
| 2018-03-11 09:00:00.000 -0700                         | 2018-11-04 09:00:00.000 -0800                         |
+-------------------------------------------------------+-------------------------------------------------------+

-- Example 2591
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'SELECT');

-- Example 2592
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'CALL', 'SELECT');

-- Example 2593
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'PERSISTENT', 'INSERT');

-- Example 2594
SELECT SYSTEM$QUERY_REFERENCE('SELECT id FROM my_table', FALSE);

-- Example 2595
SHOW REFERENCES IN APPLICATION my_app;

-- Example 2596
ALTER APPLICATION my_app UNSET REFERENCES('table_to_read');

-- Example 2597
ALTER APPLICATION my_app UNSET REFERENCES;

-- Example 2598
SHOW REFERENCES IN APPLICATION my_app;

-- Example 2599
CREATE TABLE <table_name> ( <col_name> <col_type> COLLATE '<collation_specification>'
                            [ , <col_name> <col_type> COLLATE '<collation_specification>' ... ]
                            [ , ... ]
                          )

-- Example 2600
COLLATE( <expression> , '<collation_specification>' )

-- Example 2601
<expression> COLLATE '<collation_specification>'

-- Example 2602
SELECT * FROM t1 WHERE COLLATE(col1 , 'en-ci') = 'Tango';

-- Example 2603
SELECT * FROM t1 ORDER BY COLLATE(col1 , 'de');

-- Example 2604
CREATE TABLE t2 AS SELECT COLLATE(col1, 'fr') AS col1 FROM t1;

-- Example 2605
CREATE TABLE t2 AS SELECT col1 COLLATE 'fr' AS col1 FROM t1;

-- Example 2606
COLLATION( <expression> )

-- Example 2607
SELECT DISTINCT COLLATION(column1) FROM table1;

-- Example 2608
CREATE OR REPLACE TABLE test_table (col1 VARCHAR, col2 VARCHAR);
INSERT INTO test_table VALUES ('ı', 'i');

-- Example 2609
SELECT col1 = col2,
       COLLATE(col1, 'lower') = COLLATE(col2, 'lower'),
       COLLATE(col1, 'upper') = COLLATE(col2, 'upper')
  FROM test_table;

-- Example 2610
+-------------+-------------------------------------------------+-------------------------------------------------+
| COL1 = COL2 | COLLATE(COL1, 'LOWER') = COLLATE(COL2, 'LOWER') | COLLATE(COL1, 'UPPER') = COLLATE(COL2, 'UPPER') |
|-------------+-------------------------------------------------+-------------------------------------------------|
| False       | False                                           | True                                            |
+-------------+-------------------------------------------------+-------------------------------------------------+

-- Example 2611
SELECT 'abc' COLLATE 'bin' = 'abc' COLLATE 'utf8';

-- Example 2612
CREATE OR REPLACE TABLE demo (
    no_explicit_collation VARCHAR,
    en_ci VARCHAR COLLATE 'en-ci',
    en VARCHAR COLLATE 'en',
    utf_8 VARCHAR collate 'utf8');
INSERT INTO demo (no_explicit_collation) VALUES
    ('-'),
    ('+');
UPDATE demo SET
    en_ci = no_explicit_collation,
    en = no_explicit_collation,
    utf_8 = no_explicit_collation;

-- Example 2613
SELECT MAX(no_explicit_collation), MAX(en_ci), MAX(en), MAX(utf_8)
  FROM demo;

-- Example 2614
+----------------------------+------------+---------+------------+
| MAX(NO_EXPLICIT_COLLATION) | MAX(EN_CI) | MAX(EN) | MAX(UTF_8) |
|----------------------------+------------+---------+------------|
| -                          | +          | +       | -          |
+----------------------------+------------+---------+------------+

-- Example 2615
CREATE OR REPLACE TABLE collation_precedence_example(
  col1    VARCHAR,               -- equivalent to COLLATE ''
  col2_fr VARCHAR COLLATE 'fr',  -- French locale
  col3_de VARCHAR COLLATE 'de'   -- German locale
);

-- Example 2616
... WHERE col1 = col2_fr ...

-- Example 2617
... WHERE col1 COLLATE 'en' = col2_fr ...

-- Example 2618
... WHERE col2_fr = col3_de ...

-- Example 2619
... WHERE col2_fr COLLATE '' = col3_de ...

-- Example 2620
... WHERE col2_fr COLLATE 'en' = col3_de COLLATE 'de' ...

-- Example 2621
CREATE OR REPLACE TABLE collation_precedence_example2(
  s1 STRING COLLATE '',
  s2 STRING COLLATE 'utf8',
  s3 STRING COLLATE 'fr'
);

-- Example 2622
... WHERE s1 = 'a' ...

-- Example 2623
... WHERE s1 = s2 ...

-- Example 2624
... WHERE s1 = s3 ...

-- Example 2625
... WHERE s2 = s3 ...

-- Example 2626
002322 (42846): SQL compilation error: Incompatible collations: 'fr' and 'utf8'

-- Example 2627
SELECT ... WHERE COLLATE(French_column, 'de') = Polish_column;

-- Example 2628
CREATE OR REPLACE TABLE different_widths(codepoint STRING, description STRING);

INSERT INTO different_widths VALUES
  ('a', 'ASCII a'),
  ('A', 'ASCII A'),
  ('ａ', 'Full-width a'),
  ('Ａ', 'Full-width A');

SELECT codepoint VISUAL_CHAR,
       'U+'  || TO_CHAR(UNICODE(codepoint), '0XXX') codepoint_representation,
       description
  FROM different_widths;

-- Example 2629
+-------------+--------------------------+--------------+
| VISUAL_CHAR | CODEPOINT_REPRESENTATION | DESCRIPTION  |
|-------------+--------------------------+--------------|
| a           | U+0061                   | ASCII a      |
| A           | U+0041                   | ASCII A      |
| ａ          | U+FF41                   | Full-width a |
| Ａ          | U+FF21                   | Full-width A |
+-------------+--------------------------+--------------+

-- Example 2630
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) DistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_widths;

-- Example 2631
+---------+--------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | DISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+--------------------+-------------------------+--------------------------+--------------------------|
|       4 |                  4 |                       1 |                        2 |                        2 |
+---------+--------------------+-------------------------+--------------------------+--------------------------+

-- Example 2632
CREATE OR REPLACE TABLE different_whitespaces(codepoint STRING, description STRING);

INSERT INTO different_whitespaces VALUES
  (' ', 'ASCII space'),
  ('\u00A0', 'Non-breaking space'),
  (' ', 'Ogham space mark'),
  (' ', 'en space'),
  (' ', 'em space');

SELECT codepoint visual_char,
       'U+'  || TO_CHAR(unicode(codepoint), '0XXX')
       codepoint_representation, description
  FROM different_whitespaces;

-- Example 2633
+-------------+--------------------------+--------------------+
| VISUAL_CHAR | CODEPOINT_REPRESENTATION | DESCRIPTION        |
|-------------+--------------------------+--------------------|
|             | U+0020                   | ASCII space        |
|             | U+00A0                   | Non-breaking space |
|             | U+1680                   | Ogham space mark   |
|             | U+2002                   | en space           |
|             | U+2003                   | em space           |
+-------------+--------------------------+--------------------+

-- Example 2634
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) NumDistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_whitespaces;

-- Example 2635
+---------+-----------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | NUMDISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+-----------------------+-------------------------+--------------------------+--------------------------|
|       5 |                     5 |                       1 |                        5 |                        5 |
+---------+-----------------------+-------------------------+--------------------------+--------------------------+

-- Example 2636
CREATE OR REPLACE TABLE different_scripts(codepoint STRING, description STRING);

INSERT INTO different_scripts VALUES
  ('1', 'ASCII digit 1'),
  ('¹', 'Superscript 1'),
  ('₁', 'Subscript 1'),
  ('①', 'Circled digit 1'),
  ('੧', 'Gurmukhi digit 1'),
  ('௧', 'Tamil digit 1');

SELECT codepoint VISUAL_CHAR,
       'U+'  || TO_CHAR(UNICODE(codepoint), '0XXX') codepoint_representation,
       description
  FROM different_scripts;

-- Example 2637
+-------------+--------------------------+------------------+
| VISUAL_CHAR | CODEPOINT_REPRESENTATION | DESCRIPTION      |
|-------------+--------------------------+------------------|
| 1           | U+0031                   | ASCII digit 1    |
| ¹           | U+00B9                   | Superscript 1    |
| ₁           | U+2081                   | Subscript 1      |
| ①           | U+2460                   | Circled digit 1  |
| ੧           | U+0A67                   | Gurmukhi digit 1 |
| ௧           | U+0BE7                   | Tamil digit 1    |
+-------------+--------------------------+------------------+

-- Example 2638
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) DistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_scripts;

-- Example 2639
+---------+--------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | DISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+--------------------+-------------------------+--------------------------+--------------------------|
|       6 |                  6 |                       1 |                        6 |                        6 |
+---------+--------------------+-------------------------+--------------------------+--------------------------+

-- Example 2640
SELECT '\u0001' = '' COLLATE 'en-ci';

-- Example 2641
+-------------------------------+
| '\U0001' = '' COLLATE 'EN-CI' |
|-------------------------------|
| True                          |
+-------------------------------+

-- Example 2642
SELECT '\u0001' = '' COLLATE 'upper';

-- Example 2643
+-------------------------------+
| '\U0001' = '' COLLATE 'UPPER' |
|-------------------------------|
| False                         |
+-------------------------------+

-- Example 2644
SELECT
  LEN('abc\u0001') AS original_length,
  LEN(REPLACE('abc\u0001' COLLATE 'en-ci', '\u0001')) AS length_after_replacement;

-- Example 2645
+-----------------+--------------------------+
| ORIGINAL_LENGTH | LENGTH_AFTER_REPLACEMENT |
|-----------------+--------------------------|
|               4 |                        4 |
+-----------------+--------------------------+

-- Example 2646
SELECT
  LEN('abc\u0001') AS original_length,
  LEN(REPLACE('abc\u0001' COLLATE 'upper', '\u0001')) AS length_after_replacement;

-- Example 2647
+-----------------+--------------------------+
| ORIGINAL_LENGTH | LENGTH_AFTER_REPLACEMENT |
|-----------------+--------------------------|
|               4 |                        3 |
+-----------------+--------------------------+

-- Example 2648
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'en-ci';

-- Example 2649
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'EN-CI' |
|-------------------------------------------------|
| True                                            |
+-------------------------------------------------+

-- Example 2650
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'upper';

-- Example 2651
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'UPPER' |
|-------------------------------------------------|
| True                                            |
+-------------------------------------------------+

-- Example 2652
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'lower';

