-- Example 4338
SELECT
    DECRYPT(
        ENCRYPT('penicillin', $passphrase, 'John Dough AAD', 'aes-gcm'),
        $passphrase, 'wrong patient AAD', 'aes-gcm') AS medicine
    ;

-- Example 4339
100311 (22023): Decryption failed. Check encrypted data, key, AAD, or AEAD tag.

-- Example 4340
ENCRYPT_RAW( <value_to_encrypt> , <key> , <iv> ,
         [ [ <additional_authenticated_data> , ] <encryption_method> ]
       )

-- Example 4341
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 4342
ALTER SESSION SET BINARY_OUTPUT_FORMAT='HEX';

-- Example 4343
CREATE OR REPLACE TABLE binary_table (
    encryption_key BINARY,   -- DO NOT STORE REAL ENCRYPTION KEYS THIS WAY!
    initialization_vector BINARY(12), -- DO NOT STORE REAL IV'S THIS WAY!!
    binary_column BINARY,
    encrypted_binary_column VARIANT,
    aad_column BINARY);

INSERT INTO binary_table (encryption_key,
                          initialization_vector,
                          binary_column,
                          aad_column)
    SELECT SHA2_BINARY('NotSecretEnough', 256),
            SUBSTR(TO_BINARY(HEX_ENCODE('AlsoNotSecretEnough'), 'HEX'), 0, 12),
            TO_BINARY(HEX_ENCODE('Bonjour'), 'HEX'),
            TO_BINARY(HEX_ENCODE('additional data'), 'HEX')
    ;

-- Example 4344
UPDATE binary_table SET encrypted_binary_column =
    ENCRYPT_RAW(binary_column, 
        encryption_key, 
        initialization_vector, 
        aad_column,
        'AES-GCM');
+------------------------+-------------------------------------+
| number of rows updated | number of multi-joined rows updated |
|------------------------+-------------------------------------|
|                      1 |                                   0 |
+------------------------+-------------------------------------+

-- Example 4345
SELECT 'Bonjour' as original_value,
       binary_column,
       hex_decode_string(to_varchar(binary_column)) as decoded,
       encrypted_binary_column,
       decrypt_raw(as_binary(get(encrypted_binary_column, 'ciphertext')),
                  encryption_key,
                  as_binary(get(encrypted_binary_column, 'iv')),
                  aad_column,
                  'AES-GCM',
                  as_binary(get(encrypted_binary_column, 'tag')))
           as decrypted,
       hex_decode_string(to_varchar(decrypt_raw(as_binary(get(encrypted_binary_column, 'ciphertext')),
                  encryption_key,
                  as_binary(get(encrypted_binary_column, 'iv')),
                  aad_column,
                  'AES-GCM',
                  as_binary(get(encrypted_binary_column, 'tag')))
                  ))
           as decrypted_and_decoded
    FROM binary_table;
+----------------+----------------+---------+---------------------------------------------+----------------+-----------------------+
| ORIGINAL_VALUE | BINARY_COLUMN  | DECODED | ENCRYPTED_BINARY_COLUMN                     | DECRYPTED      | DECRYPTED_AND_DECODED |
|----------------+----------------+---------+---------------------------------------------+----------------+-----------------------|
| Bonjour        | 426F6E6A6F7572 | Bonjour | {                                           | 426F6E6A6F7572 | Bonjour               |
|                |                |         |   "ciphertext": "CA2F4A383F6F55",           |                |                       |
|                |                |         |   "iv": "416C736F4E6F745365637265",         |                |                       |
|                |                |         |   "tag": "91F28FBC6A2FE9B213D1C44B8D75D147" |                |                       |
|                |                |         | }                                           |                |                       |
+----------------+----------------+---------+---------------------------------------------+----------------+-----------------------+

-- Example 4346
WITH
    decrypted_but_not_decoded as (
        decrypt_raw(as_binary(get(encrypted_binary_column, 'ciphertext')),
                      encryption_key,
                      as_binary(get(encrypted_binary_column, 'iv')),
                      aad_column,
                      'AES-GCM',
                      as_binary(get(encrypted_binary_column, 'tag')))
    )
SELECT 'Bonjour' as original_value,
       binary_column,
       hex_decode_string(to_varchar(binary_column)) as decoded,
       encrypted_binary_column,
       decrypted_but_not_decoded,
       hex_decode_string(to_varchar(decrypted_but_not_decoded))
           as decrypted_and_decoded
    FROM binary_table;
+----------------+----------------+---------+---------------------------------------------+---------------------------+-----------------------+
| ORIGINAL_VALUE | BINARY_COLUMN  | DECODED | ENCRYPTED_BINARY_COLUMN                     | DECRYPTED_BUT_NOT_DECODED | DECRYPTED_AND_DECODED |
|----------------+----------------+---------+---------------------------------------------+---------------------------+-----------------------|
| Bonjour        | 426F6E6A6F7572 | Bonjour | {                                           | 426F6E6A6F7572            | Bonjour               |
|                |                |         |   "ciphertext": "CA2F4A383F6F55",           |                           |                       |
|                |                |         |   "iv": "416C736F4E6F745365637265",         |                           |                       |
|                |                |         |   "tag": "91F28FBC6A2FE9B213D1C44B8D75D147" |                           |                       |
|                |                |         | }                                           |                           |                       |
+----------------+----------------+---------+---------------------------------------------+---------------------------+-----------------------+

-- Example 4347
ENDSWITH( <expr1> , <expr2> )

-- Example 4348
CREATE OR REPLACE TABLE strings_test (s VARCHAR);

INSERT INTO strings_test values
  ('coffee'),
  ('ice tea'),
  ('latte'),
  ('tea'),
  (NULL);

SELECT * from strings_test;

-- Example 4349
+---------+
| S       |
|---------|
| coffee  |
| ice tea |
| latte   |
| tea     |
| NULL    |
+---------+

-- Example 4350
SELECT * FROM strings_test WHERE ENDSWITH(s, 'te');

-- Example 4351
+-------+
| S     |
|-------|
| latte |
+-------+

-- Example 4352
SELECT ENDSWITH(COLLATE('nñ', 'en-ci-ai'), 'n'),
       ENDSWITH(COLLATE('nñ', 'es-ci-ai'), 'n');

-- Example 4353
+------------------------------------------+------------------------------------------+
| ENDSWITH(COLLATE('NÑ', 'EN-CI-AI'), 'N') | ENDSWITH(COLLATE('NÑ', 'ES-CI-AI'), 'N') |
|------------------------------------------+------------------------------------------|
| True                                     | False                                    |
+------------------------------------------+------------------------------------------+

-- Example 4354
SNOWFLAKE.CORTEX.ENTITY_SENTIMENT(<text> [, <entities> ])

-- Example 4355
SELECT SNOWFLAKE.CORTEX.ENTITY_SENTIMENT(review_content,
    ['concept', 'performance', 'script', 'cinematography', 'soundtrack']),
        review_content FROM reviews LIMIT 10;

-- Example 4356
EQUAL_NULL( <expr1> , <expr2> )

-- Example 4357
CREATE OR REPLACE TABLE x (i number);
INSERT INTO x values
    (1), 
    (2), 
    (null);

-- Example 4358
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2
    ORDER BY x1.i, x2.i;
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    1 |    2 |
|    1 | NULL |
|    2 |    1 |
|    2 |    2 |
|    2 | NULL |
| NULL |    1 |
| NULL |    2 |
| NULL | NULL |
+------+------+

-- Example 4359
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2 
    WHERE x1.i=x2.i;
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    2 |    2 |
+------+------+

-- Example 4360
SELECT x1.i x1_i, x2.i x2_i 
    FROM x x1, x x2 
    WHERE EQUAL_NULL(x1.i,x2.i);
+------+------+
| X1_I | X2_I |
|------+------|
|    1 |    1 |
|    2 |    2 |
| NULL | NULL |
+------+------+

-- Example 4361
SELECT x1.i x1_i, 
       x2.i x2_i,
       x1.i=x2.i, 
       iff(x1.i=x2.i, 'Selected', 'Not') "SELECT IF X1.I=X2.I",
       x1.i<>x2.i, 
       iff(not(x1.i=x2.i), 'Selected', 'Not') "SELECT IF X1.I<>X2.I"
    FROM x x1, x x2;
+------+------+-----------+---------------------+------------+----------------------+
| X1_I | X2_I | X1.I=X2.I | SELECT IF X1.I=X2.I | X1.I<>X2.I | SELECT IF X1.I<>X2.I |
|------+------+-----------+---------------------+------------+----------------------|
|    1 |    1 | True      | Selected            | False      | Not                  |
|    1 |    2 | False     | Not                 | True       | Selected             |
|    1 | NULL | NULL      | Not                 | NULL       | Not                  |
|    2 |    1 | False     | Not                 | True       | Selected             |
|    2 |    2 | True      | Selected            | False      | Not                  |
|    2 | NULL | NULL      | Not                 | NULL       | Not                  |
| NULL |    1 | NULL      | Not                 | NULL       | Not                  |
| NULL |    2 | NULL      | Not                 | NULL       | Not                  |
| NULL | NULL | NULL      | Not                 | NULL       | Not                  |
+------+------+-----------+---------------------+------------+----------------------+

-- Example 4362
SELECT x1.i x1_i, 
       x2.i x2_i,
       equal_null(x1.i,x2.i), 
       iff(equal_null(x1.i,x2.i), 'Selected', 'Not') "SELECT IF EQUAL_NULL(X1.I,X2.I)",
       not(equal_null(x1.i,x2.i)), 
       iff(not(equal_null(x1.i,x2.i)), 'Selected', 'Not') "SELECT IF NOT(EQUAL_NULL(X1.I,X2.I))"
    FROM x x1, x x2;
+------+------+-----------------------+---------------------------------+----------------------------+--------------------------------------+
| X1_I | X2_I | EQUAL_NULL(X1.I,X2.I) | SELECT IF EQUAL_NULL(X1.I,X2.I) | NOT(EQUAL_NULL(X1.I,X2.I)) | SELECT IF NOT(EQUAL_NULL(X1.I,X2.I)) |
|------+------+-----------------------+---------------------------------+----------------------------+--------------------------------------|
|    1 |    1 | True                  | Selected                        | False                      | Not                                  |
|    1 |    2 | False                 | Not                             | True                       | Selected                             |
|    1 | NULL | False                 | Not                             | True                       | Selected                             |
|    2 |    1 | False                 | Not                             | True                       | Selected                             |
|    2 |    2 | True                  | Selected                        | False                      | Not                                  |
|    2 | NULL | False                 | Not                             | True                       | Selected                             |
| NULL |    1 | False                 | Not                             | True                       | Selected                             |
| NULL |    2 | False                 | Not                             | True                       | Selected                             |
| NULL | NULL | True                  | Selected                        | False                      | Not                                  |
+------+------+-----------------------+---------------------------------+----------------------------+--------------------------------------+

-- Example 4363
SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('<table_name>')

-- Example 4364
SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 4365
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 994               |     233      |     WEEKLY    |     1.8      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 4366
EXP( <real_expr> )

-- Example 4367
SELECT EXP(1), EXP(LN(10));
-------------+-------------+
   EXP(1)    | EXP(LN(10)) |
-------------+-------------+
 2.718281828 | 10          |
-------------+-------------+

-- Example 4368
EXPLAIN_JSON( <explain_output_in_json_format> )

-- Example 4369
SELECT * FROM TABLE(
    EXPLAIN_JSON(
        SYSTEM$EXPLAIN_PLAN_JSON(
           'SELECT Z1.ID, Z2.ID FROM Z1, Z2 WHERE Z2.ID = Z1.ID')
        )
    );
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+
| step | id   | parentOperators | operation   | objects                      | alias | expressions              | partitionsTotal | partitionsAssigned | bytesAssigned |
|------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------|
| NULL | NULL |          NULL | GlobalStats | NULL                         | NULL  | NULL                     |               2 |                  2 |          1024 |
|    1 |    0 |            NULL | Result      | NULL                         | NULL  | Z1.ID, Z2.ID             |            NULL |               NULL |          NULL |
|    1 |    1 |             [0] | InnerJoin   | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    2 |             [1] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z2 | NULL  | ID                       |               1 |                  1 |           512 |
|    1 |    3 |             [1] | JoinFilter  | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    4 |             [3] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z1 | NULL  | ID                       |               1 |                  1 |           512 |
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+

-- Example 4370
EXTERNAL_FUNCTIONS_HISTORY(
      [ DATE_RANGE_START => <constant_date_expression> ]
      [, DATE_RANGE_END => <constant_date_expression> ]
      [, FUNCTION_SIGNATURE => '<string>' ] )

-- Example 4371
function_signature => 'mydb.public.myfunction(integer, varchar)'

-- Example 4372
select *
  from table(information_schema.external_functions_history(
    date_range_start => to_timestamp_ltz('2020-05-24 12:00:00.000'),
    date_range_end => to_timestamp_ltz('2020-05-24 12:30:00.000')));

-- Example 4373
select *
  from table(information_schema.external_functions_history(
    date_range_start => dateadd('hour', -12, current_timestamp()),
    function_signature => 'mydb.public.myfunction(integer, varchar)'));

-- Example 4374
select *
  from table(information_schema.external_functions_history(
    date_range_start => dateadd('day', -14, current_date()),
    date_range_end => current_date()));

-- Example 4375
select *
  from table(information_schema.external_functions_history(
    date_range_start => dateadd('day', -14, current_date()),
    date_range_end => current_date(),
    function_signature => 'mydb.public.myfunction(integer, varchar)'));

-- Example 4376
select *
  from table(information_schema.external_functions_history(
    function_signature => mydb.public.myfunction(integer, varchar)));

-- Example 4377
select *
  from table(information_schema.external_functions_history(
    function_signature => 'mydb.public.myfunction(integer, varchar)'));

-- Example 4378
EXTERNAL_TABLE_FILES(
      TABLE_NAME => '<string>' )

-- Example 4379
select *
from table(information_schema.external_table_files(TABLE_NAME=>'MYTABLE'));

-- Example 4380
EXTERNAL_TABLE_FILE_REGISTRATION_HISTORY (
      TABLE_NAME => '<string>'
      [, START_TIME => <constant_expr> ] )

-- Example 4381
select *
from table(information_schema.external_table_file_registration_history(TABLE_NAME=>'MYTABLE'));

-- Example 4382
select *
  from table(information_schema.external_table_file_registration_history(
    start_time=>dateadd('hour',-1,current_timestamp()),
    table_name=>'mydb.public.external_table_name'));

-- Example 4383
select *
  from table(information_schema.external_table_file_registration_history(
    start_time=>cast('2022-04-25' as timestamp),
    table_name=>'mydb.public.external_table_name'));

-- Example 4384
EXTRACT( <date_or_time_part> FROM <date_or_time_expr> )

-- Example 4385
EXTRACT( <date_or_time_part> , <date_or_timestamp_expr> )

-- Example 4386
SELECT EXTRACT(year FROM TO_TIMESTAMP('2024-04-10T23:39:20.123-07:00')) AS YEAR;

-- Example 4387
+------+
| YEAR |
|------|
| 2024 |
+------+

-- Example 4388
SELECT DECODE(EXTRACT(dayofweek FROM SYSTIMESTAMP()),
  1, 'Monday',
  2, 'Tuesday',
  3, 'Wednesday',
  4, 'Thursday',
  5, 'Friday',
  6, 'Saturday',
  7, 'Sunday') AS DAYOFWEEK;

-- Example 4389
+-----------+
| DAYOFWEEK |
|-----------|
| Thursday  |
+-----------+

-- Example 4390
SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
    <source_document>, <question>)

-- Example 4391
SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER(review_content,
    'What dishes does this review mention?')
FROM reviews LIMIT 10;

-- Example 4392
EXTRACT_SEMANTIC_CATEGORIES( '<object_name>' [ , <max_rows_to_scan> ] )

-- Example 4393
{
  "valid_value_ratio": 1.0,
  "recommendation": {
    "semantic_category": "PASSPORT",
    "privacy_category": "IDENTIFIER",
    "confidence": "HIGH",
    "coverage": 0.7,
    "details": [
      {
        "semantic_category": "US_PASSPORT",
        "coverage": 0.7
      },
      {
        "semantic_category": "CA_PASSPORT",
        "coverage": 0.1
      }
    ]
  },
  "alternates": [
    {
      "semantic_category": "NATIONAL_IDENTIFIER",
      "privacy_category": "IDENTIFIER",
      "confidence": "LOW",
      "coverage": 0.3,
      "details": [
        {
          "semantic_category": "US_SSN",
          "privacy_category": "IDENTIFIER",
          "coverage": 0.3
        }
      ]
    }
  ]
}

-- Example 4394
USE ROLE data_engineer;

USE WAREHOUSE classification_wh;

SELECT EXTRACT_SEMANTIC_CATEGORIES('my_db.my_schema.hr_data');

-- Example 4395
USE ROLE data_engineer;

SELECT EXTRACT_SEMANTIC_CATEGORIES('my_db.my_schema.hr_data', 5000);

-- Example 4396
USE ROLE data_engineer;

CREATE OR REPLACE TABLE classification_results(v VARIANT) AS
  SELECT EXTRACT_SEMANTIC_CATEGORIES('my_db.my_schema.hr_data');

-- Example 4397
FACTORIAL( <integer_expr> )

-- Example 4398
SELECT FACTORIAL(0), FACTORIAL(1), FACTORIAL(5), FACTORIAL(10);

+--------------+--------------+--------------+---------------+
| FACTORIAL(0) | FACTORIAL(1) | FACTORIAL(5) | FACTORIAL(10) |
|--------------+--------------+--------------+---------------|
|            1 |            1 |          120 |       3628800 |
+--------------+--------------+--------------+---------------+

-- Example 4399
FILTER( <array> , <lambda_expression> )

-- Example 4400
<arg> [ <datatype> ] -> <expr>

-- Example 4401
SELECT FILTER(
  [
    {'name':'Pat', 'value': 50},
    {'name':'Terry', 'value': 75},
    {'name':'Dana', 'value': 25}
  ],
  a -> a:value >= 50) AS "Filter >= 50";

-- Example 4402
+----------------------+
| Filter >= 50         |
|----------------------|
| [                    |
|   {                  |
|     "name": "Pat",   |
|     "value": 50      |
|   },                 |
|   {                  |
|     "name": "Terry", |
|     "value": 75      |
|   }                  |
| ]                    |
+----------------------+

-- Example 4403
SELECT FILTER([1, NULL, 3, 5, NULL], a -> a IS NOT NULL) AS "Not NULL Elements";

-- Example 4404
+-------------------+
| Not NULL Elements |
|-------------------|
| [                 |
|   1,              |
|   3,              |
|   5               |
| ]                 |
+-------------------+

