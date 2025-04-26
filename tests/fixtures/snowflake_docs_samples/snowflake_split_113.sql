-- Example 7552
SELECT TRANSLATE('peña','ñ','n') AS translation;

-- Example 7553
+-------------+
| TRANSLATION |
|-------------|
| pena        |
+-------------+

-- Example 7554
SELECT TRANSLATE('❄a❄bX❄dYZ❄','XYZ❄','cef') AS translation;

-- Example 7555
+-------------+
| TRANSLATION |
|-------------|
| abcdef      |
+-------------+

-- Example 7556
TRIM( <expr> [, <characters> ] )

-- Example 7557
SELECT '*-*ABC-*-' AS original,
       TRIM('*-*ABC-*-', '*-') AS trimmed;

-- Example 7558
+-----------+---------+
| ORIGINAL  | TRIMMED |
|-----------+---------|
| *-*ABC-*- | ABC     |
+-----------+---------+

-- Example 7559
SELECT CONCAT('>', CONCAT('ABC\n', '<')) AS original,
       CONCAT('>', CONCAT(TRIM('ABC\n', '\n'), '<')) AS trimmed;

-- Example 7560
+----------+---------+
| ORIGINAL | TRIMMED |
|----------+---------|
| >ABC     | >ABC<   |
| <        |         |
+----------+---------+

-- Example 7561
CREATE OR REPLACE TABLE test_trim_function(column1 VARCHAR);

INSERT INTO test_trim_function VALUES ('  Leading Spaces'), ('Trailing Spaces  '), (NULL);

SELECT CONCAT('>', CONCAT(column1, '<')) AS original_values,
       CONCAT('>', CONCAT(TRIM(column1), '<')) AS trimmed_values
  FROM test_trim_function;

-- Example 7562
+---------------------+-------------------+
| ORIGINAL_VALUES     | TRIMMED_VALUES    |
|---------------------+-------------------|
| >  Leading Spaces<  | >Leading Spaces<  |
| >Trailing Spaces  < | >Trailing Spaces< |
| NULL                | NULL              |
+---------------------+-------------------+

-- Example 7563
TRUNCATE( <input_expr> [ , <scale_expr> ] )

TRUNC( <input_expr> [ , <scale_expr> ] )

-- Example 7564
CREATE TABLE numeric_trunc_demo (n FLOAT, scale INTEGER);
INSERT INTO numeric_trunc_demo (n, scale) VALUES
   (-975.975, -1), (-975.975,  0), (-975.975,  2),
   ( 135.135, -2), ( 135.135,  0), ( 135.135,  1),
   ( 135.135,  3), ( 135.135, 50), ( 135.135, NULL);

-- Example 7565
SELECT DISTINCT n, TRUNCATE(n)
  FROM numeric_trunc_demo ORDER BY n;

-- Example 7566
+----------+-------------+
|        N | TRUNCATE(N) |
|----------+-------------|
| -975.975 |        -975 |
|  135.135 |         135 |
+----------+-------------+

-- Example 7567
SELECT n, scale, TRUNC(n, scale)
  FROM numeric_trunc_demo ORDER BY n, scale;

-- Example 7568
+----------+-------+-----------------+
|        N | SCALE | TRUNC(N, SCALE) |
|----------+-------+-----------------|
| -975.975 |    -1 |        -970     |
| -975.975 |     0 |        -975     |
| -975.975 |     2 |        -975.97  |
|  135.135 |    -2 |         100     |
|  135.135 |     0 |         135     |
|  135.135 |     1 |         135.1   |
|  135.135 |     3 |         135.135 |
|  135.135 |    50 |         135.135 |
|  135.135 |  NULL |            NULL |
+----------+-------+-----------------+

-- Example 7569
TRUNC( <date_or_time_expr>, <date_or_time_part> )

-- Example 7570
CREATE OR REPLACE TABLE test_date_trunc (
 mydate DATE,
 mytime TIME,
 mytimestamp TIMESTAMP);

INSERT INTO test_date_trunc VALUES (
  '2024-05-09',
  '08:50:48',
  '2024-05-09 08:50:57.891 -0700');

SELECT * FROM test_date_trunc;

-- Example 7571
+------------+----------+-------------------------+
| MYDATE     | MYTIME   | MYTIMESTAMP             |
|------------+----------+-------------------------|
| 2024-05-09 | 08:50:48 | 2024-05-09 08:50:57.891 |
+------------+----------+-------------------------+

-- Example 7572
SELECT mydate AS "DATE",
       TRUNC(mydate, 'year') AS "TRUNCATED TO YEAR",
       TRUNC(mydate, 'month') AS "TRUNCATED TO MONTH",
       TRUNC(mydate, 'day') AS "TRUNCATED TO DAY"
  FROM test_date_trunc;

-- Example 7573
+------------+-------------------+--------------------+------------------+
| DATE       | TRUNCATED TO YEAR | TRUNCATED TO MONTH | TRUNCATED TO DAY |
|------------+-------------------+--------------------+------------------|
| 2024-05-09 | 2024-01-01        | 2024-05-01         | 2024-05-09       |
+------------+-------------------+--------------------+------------------+

-- Example 7574
SELECT mytime AS "TIME",
       TRUNCATE(mytime, 'minute') AS "TRUNCATED TO MINUTE"
  FROM test_date_trunc;

-- Example 7575
+----------+---------------------+
| TIME     | TRUNCATED TO MINUTE |
|----------+---------------------|
| 08:50:48 | 08:50:00            |
+----------+---------------------+

-- Example 7576
SELECT mytimestamp AS "TIMESTAMP",
       TRUNCATE(mytimestamp, 'hour') AS "TRUNCATED TO HOUR",
       TRUNCATE(mytimestamp, 'minute') AS "TRUNCATED TO MINUTE",
       TRUNCATE(mytimestamp, 'second') AS "TRUNCATED TO SECOND"
  FROM test_date_trunc;

-- Example 7577
+-------------------------+-------------------------+-------------------------+-------------------------+
| TIMESTAMP               | TRUNCATED TO HOUR       | TRUNCATED TO MINUTE     | TRUNCATED TO SECOND     |
|-------------------------+-------------------------+-------------------------+-------------------------|
| 2024-05-09 08:50:57.891 | 2024-05-09 08:00:00.000 | 2024-05-09 08:50:00.000 | 2024-05-09 08:50:57.000 |
+-------------------------+-------------------------+-------------------------+-------------------------+

-- Example 7578
SELECT TRUNC(mytimestamp, 'quarter') AS "TRUNCATED",
       EXTRACT('quarter', mytimestamp) AS "EXTRACTED"
  FROM test_date_trunc;

-- Example 7579
+-------------------------+-----------+
| TRUNCATED               | EXTRACTED |
|-------------------------+-----------|
| 2024-04-01 00:00:00.000 |         2 |
+-------------------------+-----------+

-- Example 7580
TRY_BASE64_DECODE_BINARY(<input> [, <alphabet>])

-- Example 7581
CREATE TABLE base64 (v VARCHAR, base64_encoded_varchar VARCHAR, b BINARY);
INSERT INTO base64 (v, base64_encoded_varchar, b)
   SELECT 'HELP', BASE64_ENCODE('HELP'),
      TRY_BASE64_DECODE_BINARY(BASE64_ENCODE('HELP'));

-- Example 7582
SELECT v, base64_encoded_varchar, 
    -- Convert binary -> base64-encoded-string
    TO_VARCHAR(b, 'BASE64'),
    -- Convert binary back to original value
    TO_VARCHAR(b, 'UTF-8')
  FROM base64;
+------+------------------------+-------------------------+------------------------+
| V    | BASE64_ENCODED_VARCHAR | TO_VARCHAR(B, 'BASE64') | TO_VARCHAR(B, 'UTF-8') |
|------+------------------------+-------------------------+------------------------|
| HELP | SEVMUA==               | SEVMUA==                | HELP                   |
+------+------------------------+-------------------------+------------------------+

-- Example 7583
TRY_BASE64_DECODE_STRING(<input> [, <alphabet>])

-- Example 7584
SELECT TRY_BASE64_DECODE_STRING(BASE64_ENCODE('HELLO'));
+--------------------------------------------------+
| TRY_BASE64_DECODE_STRING(BASE64_ENCODE('HELLO')) |
|--------------------------------------------------|
| HELLO                                            |
+--------------------------------------------------+

-- Example 7585
CREATE TABLE base64 (v VARCHAR, base64_string VARCHAR, garbage VARCHAR);
INSERT INTO base64 (v, base64_string, garbage) 
  SELECT 'HELLO', BASE64_ENCODE('HELLO'), '127';

-- Example 7586
SELECT v, base64_string, TRY_BASE64_DECODE_STRING(base64_string), TRY_BASE64_DECODE_STRING(garbage) FROM base64;
+-------+---------------+-----------------------------------------+-----------------------------------+
| V     | BASE64_STRING | TRY_BASE64_DECODE_STRING(BASE64_STRING) | TRY_BASE64_DECODE_STRING(GARBAGE) |
|-------+---------------+-----------------------------------------+-----------------------------------|
| HELLO | SEVMTE8=      | HELLO                                   | NULL                              |
+-------+---------------+-----------------------------------------+-----------------------------------+

-- Example 7587
TRY_CAST( <source_string_expr> AS <target_data_type> )

-- Example 7588
SELECT TRY_CAST('05-Mar-2016' AS TIMESTAMP);
+--------------------------------------+
| TRY_CAST('05-MAR-2016' AS TIMESTAMP) |
|--------------------------------------|
| 2016-03-05 00:00:00.000              |
+--------------------------------------+

-- Example 7589
SELECT TRY_CAST('05/16' AS TIMESTAMP);
+--------------------------------+
| TRY_CAST('05/16' AS TIMESTAMP) |
|--------------------------------|
| NULL                           |
+--------------------------------+

-- Example 7590
SELECT TRY_CAST('ABCD' AS CHAR(2));
+-----------------------------+
| TRY_CAST('ABCD' AS CHAR(2)) |
|-----------------------------|
| NULL                        |
+-----------------------------+

-- Example 7591
SELECT TRY_CAST('ABCD' AS VARCHAR(10));
+---------------------------------+
| TRY_CAST('ABCD' AS VARCHAR(10)) |
|---------------------------------|
| ABCD                            |
+---------------------------------+

-- Example 7592
SNOWFLAKE.CORTEX.TRY_COMPLETE( <model>, <prompt_or_history> [ , <options> ] )

-- Example 7593
SELECT SNOWFLAKE.CORTEX.TRY_COMPLETE('snowflake-arctic', 'What are large language models?');

-- Example 7594
SELECT SNOWFLAKE.CORTEX.TRY_COMPLETE(
    'llama2-70b-chat',
    [
        {
            'role': 'user',
            'content': 'how does a snowflake get its unique pattern?'
        }
    ],
    {
        'temperature': 0.7,
        'max_tokens': 10
    }
);

-- Example 7595
{
    "choices": [
        {
            "messages": " The unique pattern on a snowflake is"
        }
    ],
    "created": 1708536426,
    "model": "llama2-70b-chat",
    "usage": {
        "completion_tokens": 10,
        "prompt_tokens": 22,
        "total_tokens": 32
    }
}

-- Example 7596
TRY_DECRYPT( <value_to_decrypt> , <passphrase> ,
         [ [ <additional_authenticated_data> , ] <encryption_method> ]
       )

-- Example 7597
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 7598
TRY_DECRYPT_RAW( <value_to_decrypt> , <key> , <iv> ,
         [ [ [ <additional_authenticated_data> , ] <encryption_method> , ] <aead_tag> ]
       )

-- Example 7599
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 7600
TRY_HEX_DECODE_BINARY(<input>)

-- Example 7601
CREATE TABLE hex (v VARCHAR, b BINARY);
INSERT INTO hex (v, b)
   SELECT 'ABab', 
     -- Convert string -> hex-encoded string -> binary.
     TRY_HEX_DECODE_BINARY(HEX_ENCODE('ABab'));

-- Example 7602
SELECT v, b, 
    -- Convert binary -> hex-encoded-string -> string.
    TRY_HEX_DECODE_STRING(TO_VARCHAR(b)) 
  FROM hex;

-- Example 7603
+------+----------+--------------------------------------+
| V    | B        | TRY_HEX_DECODE_STRING(TO_VARCHAR(B)) |
|------+----------+--------------------------------------|
| ABab | 41426162 | ABab                                 |
+------+----------+--------------------------------------+

-- Example 7604
TRY_HEX_DECODE_STRING(<input>)

-- Example 7605
CREATE TABLE hex (v VARCHAR, hex_string VARCHAR, garbage VARCHAR);
INSERT INTO hex (v, hex_string, garbage) 
  SELECT 'AaBb', HEX_ENCODE('AaBb'), '127';

-- Example 7606
SELECT v, hex_string, TRY_HEX_DECODE_STRING(hex_string), TRY_HEX_DECODE_STRING(garbage) FROM hex;

-- Example 7607
+------+------------+-----------------------------------+--------------------------------+
| V    | HEX_STRING | TRY_HEX_DECODE_STRING(HEX_STRING) | TRY_HEX_DECODE_STRING(GARBAGE) |
|------+------------+-----------------------------------+--------------------------------|
| AaBb | 41614262   | AaBb                              | NULL                           |
+------+------------+-----------------------------------+--------------------------------+

-- Example 7608
TRY_PARSE_JSON( <expr> [ , '<parameter>' ] )

-- Example 7609
CREATE OR REPLACE TEMPORARY TABLE vartab (ID INTEGER, v VARCHAR);

INSERT INTO vartab (id, v) VALUES
  (1, '[-1, 12, 289, 2188, FALSE,]'),
  (2, '{ "x" : "abc", "y" : FALSE, "z": 10} '),
  (3, '{ "bad" : "json", "missing" : TRUE, "close_brace": 10 ');

-- Example 7610
SELECT ID, TRY_PARSE_JSON(v)
  FROM vartab
  ORDER BY ID;

-- Example 7611
+----+-------------------+
| ID | TRY_PARSE_JSON(V) |
|----+-------------------|
|  1 | [                 |
|    |   -1,             |
|    |   12,             |
|    |   289,            |
|    |   2188,           |
|    |   false,          |
|    |   undefined       |
|    | ]                 |
|  2 | {                 |
|    |   "x": "abc",     |
|    |   "y": false,     |
|    |   "z": 10         |
|    | }                 |
|  3 | NULL              |
+----+-------------------+

-- Example 7612
TRY_TO_BINARY( <string_expr> [, '<format>'] )

-- Example 7613
CREATE TABLE strings (v VARCHAR, hex_encoded_string VARCHAR, b BINARY);
INSERT INTO strings (v) VALUES
    ('01'),
    ('A B'),
    ('Hello'),
    (NULL);
UPDATE strings SET hex_encoded_string = HEX_ENCODE(v);
UPDATE strings SET b = TRY_TO_BINARY(hex_encoded_string, 'HEX');

-- Example 7614
SELECT v, hex_encoded_string, TO_VARCHAR(b, 'UTF-8')
  FROM strings
  ORDER BY v
  ;
+-------+--------------------+------------------------+
| V     | HEX_ENCODED_STRING | TO_VARCHAR(B, 'UTF-8') |
|-------+--------------------+------------------------|
| 01    | 3031               | 01                     |
| A B   | 412042             | A B                    |
| Hello | 48656C6C6F         | Hello                  |
| NULL  | NULL               | NULL                   |
+-------+--------------------+------------------------+

-- Example 7615
TRY_TO_BOOLEAN( <string_expr> )

-- Example 7616
SELECT TRY_TO_BOOLEAN('True')  AS "T",
       TRY_TO_BOOLEAN('False') AS "F",
       TRY_TO_BOOLEAN('Not valid')  AS "N";

-- Example 7617
+------+-------+------+
| T    | F     | N    |
|------+-------+------|
| True | False | NULL |
+------+-------+------+

-- Example 7618
TRY_TO_DATE( <string_expr> [, <format> ] )
TRY_TO_DATE( '<integer>' )

