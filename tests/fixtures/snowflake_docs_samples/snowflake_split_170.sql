-- Example 11370
... WHERE s2 = s3 ...

-- Example 11371
002322 (42846): SQL compilation error: Incompatible collations: 'fr' and 'utf8'

-- Example 11372
SELECT ... WHERE COLLATE(French_column, 'de') = Polish_column;

-- Example 11373
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

-- Example 11374
+-------------+--------------------------+--------------+
| VISUAL_CHAR | CODEPOINT_REPRESENTATION | DESCRIPTION  |
|-------------+--------------------------+--------------|
| a           | U+0061                   | ASCII a      |
| A           | U+0041                   | ASCII A      |
| ａ          | U+FF41                   | Full-width a |
| Ａ          | U+FF21                   | Full-width A |
+-------------+--------------------------+--------------+

-- Example 11375
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) DistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_widths;

-- Example 11376
+---------+--------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | DISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+--------------------+-------------------------+--------------------------+--------------------------|
|       4 |                  4 |                       1 |                        2 |                        2 |
+---------+--------------------+-------------------------+--------------------------+--------------------------+

-- Example 11377
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

-- Example 11378
+-------------+--------------------------+--------------------+
| VISUAL_CHAR | CODEPOINT_REPRESENTATION | DESCRIPTION        |
|-------------+--------------------------+--------------------|
|             | U+0020                   | ASCII space        |
|             | U+00A0                   | Non-breaking space |
|             | U+1680                   | Ogham space mark   |
|             | U+2002                   | en space           |
|             | U+2003                   | em space           |
+-------------+--------------------------+--------------------+

-- Example 11379
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) NumDistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_whitespaces;

-- Example 11380
+---------+-----------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | NUMDISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+-----------------------+-------------------------+--------------------------+--------------------------|
|       5 |                     5 |                       1 |                        5 |                        5 |
+---------+-----------------------+-------------------------+--------------------------+--------------------------+

-- Example 11381
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

-- Example 11382
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

-- Example 11383
SELECT COUNT(*) NumRows,
       COUNT(DISTINCT UNICODE(codepoint)) DistinctCodepoints,
       COUNT(DISTINCT codepoint COLLATE 'en-ci') DistinctCodepoints_EnCi,
       COUNT(DISTINCT codepoint COLLATE 'upper') DistinctCodepoints_Upper,
       COUNT(DISTINCT codepoint COLLATE 'lower') DistinctCodepoints_Lower
  FROM different_scripts;

-- Example 11384
+---------+--------------------+-------------------------+--------------------------+--------------------------+
| NUMROWS | DISTINCTCODEPOINTS | DISTINCTCODEPOINTS_ENCI | DISTINCTCODEPOINTS_UPPER | DISTINCTCODEPOINTS_LOWER |
|---------+--------------------+-------------------------+--------------------------+--------------------------|
|       6 |                  6 |                       1 |                        6 |                        6 |
+---------+--------------------+-------------------------+--------------------------+--------------------------+

-- Example 11385
SELECT '\u0001' = '' COLLATE 'en-ci';

-- Example 11386
+-------------------------------+
| '\U0001' = '' COLLATE 'EN-CI' |
|-------------------------------|
| True                          |
+-------------------------------+

-- Example 11387
SELECT '\u0001' = '' COLLATE 'upper';

-- Example 11388
+-------------------------------+
| '\U0001' = '' COLLATE 'UPPER' |
|-------------------------------|
| False                         |
+-------------------------------+

-- Example 11389
SELECT
  LEN('abc\u0001') AS original_length,
  LEN(REPLACE('abc\u0001' COLLATE 'en-ci', '\u0001')) AS length_after_replacement;

-- Example 11390
+-----------------+--------------------------+
| ORIGINAL_LENGTH | LENGTH_AFTER_REPLACEMENT |
|-----------------+--------------------------|
|               4 |                        4 |
+-----------------+--------------------------+

-- Example 11391
SELECT
  LEN('abc\u0001') AS original_length,
  LEN(REPLACE('abc\u0001' COLLATE 'upper', '\u0001')) AS length_after_replacement;

-- Example 11392
+-----------------+--------------------------+
| ORIGINAL_LENGTH | LENGTH_AFTER_REPLACEMENT |
|-----------------+--------------------------|
|               4 |                        3 |
+-----------------+--------------------------+

-- Example 11393
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'en-ci';

-- Example 11394
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'EN-CI' |
|-------------------------------------------------|
| True                                            |
+-------------------------------------------------+

-- Example 11395
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'upper';

-- Example 11396
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'UPPER' |
|-------------------------------------------------|
| True                                            |
+-------------------------------------------------+

-- Example 11397
SELECT '\u03b9\u0308\u0301' = '\u0390' COLLATE 'lower';

-- Example 11398
+-------------------------------------------------+
| '\U03B9\U0308\U0301' = '\U0390' COLLATE 'LOWER' |
|-------------------------------------------------|
| False                                           |
+-------------------------------------------------+

-- Example 11399
SELECT CONTAINS('\u03b9\u0308', '\u03b9' COLLATE 'en-ci');

-- Example 11400
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U03B9' COLLATE 'EN-CI') |
|----------------------------------------------------|
| False                                              |
+----------------------------------------------------+

-- Example 11401
SELECT CONTAINS('\u03b9\u0308', '\u0308' COLLATE 'en-ci');

-- Example 11402
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U0308' COLLATE 'EN-CI') |
|----------------------------------------------------|
| False                                              |
+----------------------------------------------------+

-- Example 11403
SELECT CONTAINS('\u03b9\u0308', '\u03b9' COLLATE 'upper');

-- Example 11404
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U03B9' COLLATE 'UPPER') |
|----------------------------------------------------|
| True                                               |
+----------------------------------------------------+

-- Example 11405
SELECT CONTAINS('\u03b9\u0308', '\u0308' COLLATE 'upper');

-- Example 11406
+----------------------------------------------------+
| CONTAINS('\U03B9\U0308', '\U0308' COLLATE 'UPPER') |
|----------------------------------------------------|
| True                                               |
+----------------------------------------------------+

-- Example 11407
SELECT CONTAINS('ß' , 's' COLLATE 'upper');

-- Example 11408
+--------------------------------------+
| CONTAINS('SS' , 'S' COLLATE 'UPPER') |
|--------------------------------------|
| False                                |
+--------------------------------------+

-- Example 11409
SELECT CONTAINS('ss', 's' COLLATE 'upper');

-- Example 11410
+-------------------------------------+
| CONTAINS('SS', 'S' COLLATE 'UPPER') |
|-------------------------------------|
| True                                |
+-------------------------------------+

-- Example 11411
SELECT '+' < '-' COLLATE 'en-ci';

-- Example 11412
+---------------------------+
| '+' < '-' COLLATE 'EN-CI '|
|---------------------------|
| False                     |
+---------------------------+

-- Example 11413
SELECT '+' < '-' COLLATE 'upper';

-- Example 11414
+---------------------------+
| '+' < '-' COLLATE 'UPPER' |
|---------------------------|
| True                      |
+---------------------------+

-- Example 11415
SELECT 'a\u0001b' < 'ab' COLLATE 'en-ci';

-- Example 11416
+-----------------------------------+
| 'A\U0001B' < 'AB' COLLATE 'EN-CI' |
|-----------------------------------|
| False                             |
+-----------------------------------+

-- Example 11417
SELECT 'a\u0001b' < 'ab' COLLATE 'upper';

-- Example 11418
+-----------------------------------+
| 'A\U0001B' < 'AB' COLLATE 'UPPER' |
|-----------------------------------|
| True                              |
+-----------------------------------+

-- Example 11419
SELECT 'abc' < '❄' COLLATE 'en-ci';

-- Example 11420
+-----------------------------+
| 'ABC' < '❄' COLLATE 'EN-CI' |
|-----------------------------|
| False                       |
+-----------------------------+

-- Example 11421
SELECT 'abc' < '❄' COLLATE 'upper';

-- Example 11422
+-----------------------------+
| 'ABC' < '❄' COLLATE 'UPPER' |
|-----------------------------|
| True                        |
+-----------------------------+

-- Example 11423
COLLATE(VARIANT_COL:fld1::VARCHAR, 'en-ci') = VARIANT_COL:fld2::VARCHAR

-- Example 11424
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

-- Example 11425
SELECT * FROM collation_demo;

-- Example 11426
+-------------------+-------------+----------------+----------------+
| UNCOLLATED_PHRASE | UTF8_PHRASE | ENGLISH_PHRASE | SPANISH_PHRASE |
|-------------------+-------------+----------------+----------------|
| pinata            | pinata      | pinata         | piñata         |
+-------------------+-------------+----------------+----------------+

-- Example 11427
SELECT * FROM collation_demo WHERE spanish_phrase = uncollated_phrase;

-- Example 11428
+-------------------+-------------+----------------+----------------+
| UNCOLLATED_PHRASE | UTF8_PHRASE | ENGLISH_PHRASE | SPANISH_PHRASE |
|-------------------+-------------+----------------+----------------|
+-------------------+-------------+----------------+----------------+

-- Example 11429
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

-- Example 11430
+------------------------------+------------------------+---------------------------+---------------------------+
| UNCOLLATED_PHRASE = 'PINATA' | UTF8_PHRASE = 'PINATA' | ENGLISH_PHRASE = 'PINATA' | SPANISH_PHRASE = 'PINATA' |
|------------------------------+------------------------+---------------------------+---------------------------|
| False                        | False                  | True                      | False                     |
+------------------------------+------------------------+---------------------------+---------------------------+

-- Example 11431
INSERT INTO collation_demo (spanish_phrase) VALUES
  ('piña colada'),
  ('Pinatubo (Mount)'),
  ('pint'),
  ('Pinta');

-- Example 11432
SELECT spanish_phrase FROM collation_demo 
  ORDER BY spanish_phrase;

-- Example 11433
+------------------+
| SPANISH_PHRASE   |
|------------------|
| Pinatubo (Mount) |
| pint             |
| Pinta            |
| piña colada      |
| piñata           |
+------------------+

-- Example 11434
SELECT spanish_phrase FROM collation_demo 
  ORDER BY COLLATE(spanish_phrase, 'utf8');

-- Example 11435
+------------------+
| SPANISH_PHRASE   |
|------------------|
| Pinatubo (Mount) |
| Pinta            |
| pint             |
| piña colada      |
| piñata           |
+------------------+

-- Example 11436
CREATE OR REPLACE TABLE collation_demo2 (
  c1 VARCHAR COLLATE 'fr', 
  c2 VARCHAR COLLATE '');

INSERT INTO collation_demo2 (c1, c2) VALUES
  ('a', 'a'),
  ('b', 'b');

