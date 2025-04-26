-- Example 4204
DECOMPRESS_BINARY(<input>, <method>)

-- Example 4205
SELECT DECOMPRESS_BINARY(TO_BINARY('0920536E6F77666C616B65', 'HEX'), 'SNAPPY');
+-------------------------------------------------------------------------+
| DECOMPRESS_BINARY(TO_BINARY('0920536E6F77666C616B65', 'HEX'), 'SNAPPY') |
|-------------------------------------------------------------------------|
| 536E6F77666C616B65                                                      |
+-------------------------------------------------------------------------+

-- Example 4206
DECOMPRESS_STRING(<input>, <method>)

-- Example 4207
SELECT COMPRESS('Snowflake', 'SNAPPY');
+---------------------------------+
| COMPRESS('SNOWFLAKE', 'SNAPPY') |
|---------------------------------|
| 0920536E6F77666C616B65          |
+---------------------------------+

-- Example 4208
SELECT DECOMPRESS_STRING(TO_BINARY('0920536E6F77666C616B65', 'HEX'), 'SNAPPY');
+-------------------------------------------------------------------------+
| DECOMPRESS_STRING(TO_BINARY('0920536E6F77666C616B65', 'HEX'), 'SNAPPY') |
|-------------------------------------------------------------------------|
| Snowflake                                                               |
+-------------------------------------------------------------------------+

-- Example 4209
DECRYPT( <value_to_decrypt> , <passphrase> ,
         [ [ <additional_authenticated_data> , ] <encryption_method> ]
       )

-- Example 4210
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 4211
... TO_VARCHAR(DECRYPT(ENCRYPT('secret', 'key'), 'key'), 'utf-8') ...

-- Example 4212
SET passphrase='poiuqewjlkfsd';

-- Example 4213
SELECT
    TO_VARCHAR(
        DECRYPT(
            ENCRYPT('Patient tested positive for COVID-19', $passphrase),
            $passphrase),
        'utf-8')
        AS decrypted
    ;
+--------------------------------------+
| DECRYPTED                            |
|--------------------------------------|
| Patient tested positive for COVID-19 |
+--------------------------------------+

-- Example 4214
ALTER SESSION SET BINARY_OUTPUT_FORMAT='hex';

-- Example 4215
CREATE TABLE binary_table (
    binary_column BINARY,
    encrypted_binary_column BINARY);
INSERT INTO binary_table (binary_column) 
    SELECT (TO_BINARY(HEX_ENCODE('Hello')));
UPDATE binary_table 
    SET encrypted_binary_column = ENCRYPT(binary_column, 'SamplePassphrase');

-- Example 4216
SELECT 'Hello' as original_value,
       binary_column, 
       hex_decode_string(to_varchar(binary_column)) as decoded,
       -- encrypted_binary_column,
       decrypt(encrypted_binary_column, 'SamplePassphrase') as decrypted,
       hex_decode_string(to_varchar(decrypt(encrypted_binary_column, 'SamplePassphrase'))) as decrypted_and_decoded
    FROM binary_table;
+----------------+---------------+---------+------------+-----------------------+
| ORIGINAL_VALUE | BINARY_COLUMN | DECODED | DECRYPTED  | DECRYPTED_AND_DECODED |
|----------------+---------------+---------+------------+-----------------------|
| Hello          | 48656C6C6F    | Hello   | 48656C6C6F | Hello                 |
+----------------+---------------+---------+------------+-----------------------+

-- Example 4217
select encrypt(to_binary(hex_encode('secret!')), 'sample_passphrase', NULL, 'aes-cbc/pad:pkcs') as encrypted_data;

-- Example 4218
SELECT
    TO_VARCHAR(
        DECRYPT(
            ENCRYPT('penicillin', $passphrase, 'John Dough AAD', 'aes-gcm'),
            $passphrase, 'John Dough AAD', 'aes-gcm'),
        'utf-8')
        AS medicine
    ;
+------------+
| MEDICINE   |
|------------|
| penicillin |
+------------+

-- Example 4219
SELECT
    DECRYPT(
        ENCRYPT('penicillin', $passphrase, 'John Dough AAD', 'aes-gcm'),
        $passphrase, 'wrong patient AAD', 'aes-gcm') AS medicine
    ;

-- Example 4220
100311 (22023): Decryption failed. Check encrypted data, key, AAD, or AEAD tag.

-- Example 4221
DECRYPT_RAW( <value_to_decrypt> , <key> , <iv> ,
         [ [ [ <additional_authenticated_data> , ] <encryption_method> , ] <aead_tag> ]
       )

-- Example 4222
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 4223
as_binary(get(encrypted_value, '<field_name>'))

-- Example 4224
as_binary(get(encrypted_value, 'ciphertext'))

-- Example 4225
ALTER SESSION SET BINARY_OUTPUT_FORMAT='HEX';

-- Example 4226
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

-- Example 4227
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

-- Example 4228
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

-- Example 4229
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

-- Example 4230
DEGREES( <real_expr> )

-- Example 4231
SELECT DEGREES(PI()/3), DEGREES(PI()), DEGREES(3 * PI()), DEGREES(1);
+-----------------+---------------+-------------------+--------------+
| DEGREES(PI()/3) | DEGREES(PI()) | DEGREES(3 * PI()) |   DEGREES(1) |
|-----------------+---------------+-------------------+--------------|
|              60 |           180 |               540 | 57.295779513 |
+-----------------+---------------+-------------------+--------------+

-- Example 4232
DENSE_RANK() OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2> [ ASC | DESC ] [ <window_frame> ] )

-- Example 4233
-- Create table and load data.
create or replace table corn_production (farmer_ID INTEGER, state varchar, bushels float);
insert into corn_production (farmer_ID, state, bushels) values
    (1, 'Iowa', 100),
    (2, 'Iowa', 110),
    (3, 'Kansas', 120),
    (4, 'Kansas', 130);

-- Example 4234
SELECT state, bushels,
        RANK() OVER (ORDER BY bushels DESC),
        DENSE_RANK() OVER (ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+-------------------------------------+-------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (ORDER BY BUSHELS DESC) |
|--------+---------+-------------------------------------+-------------------------------------------|
| Kansas |     130 |                                   1 |                                         1 |
| Kansas |     120 |                                   2 |                                         2 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     100 |                                   4 |                                         4 |
+--------+---------+-------------------------------------+-------------------------------------------+

-- Example 4235
SELECT state, bushels,
        RANK() OVER (PARTITION BY state ORDER BY bushels DESC),
        DENSE_RANK() OVER (PARTITION BY state ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+--------------------------------------------------------+--------------------------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (PARTITION BY STATE ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (PARTITION BY STATE ORDER BY BUSHELS DESC) |
|--------+---------+--------------------------------------------------------+--------------------------------------------------------------|
| Iowa   |     110 |                                                      1 |                                                            1 |
| Iowa   |     100 |                                                      2 |                                                            2 |
| Kansas |     130 |                                                      1 |                                                            1 |
| Kansas |     120 |                                                      2 |                                                            2 |
+--------+---------+--------------------------------------------------------+--------------------------------------------------------------+

-- Example 4236
SELECT state, bushels,
        RANK() OVER (ORDER BY bushels DESC),
        DENSE_RANK() OVER (ORDER BY bushels DESC)
    FROM corn_production;
+--------+---------+-------------------------------------+-------------------------------------------+
| STATE  | BUSHELS | RANK() OVER (ORDER BY BUSHELS DESC) | DENSE_RANK() OVER (ORDER BY BUSHELS DESC) |
|--------+---------+-------------------------------------+-------------------------------------------|
| Kansas |     130 |                                   1 |                                         1 |
| Kansas |     120 |                                   2 |                                         2 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     110 |                                   3 |                                         3 |
| Iowa   |     100 |                                   5 |                                         4 |
+--------+---------+-------------------------------------+-------------------------------------------+

-- Example 4237
DIV0( <dividend> , <divisor> )

-- Example 4238
SELECT 1/2;
+----------+                                                                    
|      1/2 |
|----------|
| 0.500000 |
+----------+
SELECT DIV0(1, 2);
+------------+                                                                  
| DIV0(1, 2) |
|------------|
|   0.500000 |
+------------+

-- Example 4239
select 1/0;
100051 (22012): Division by zero

-- Example 4240
SELECT DIV0(1, 0);
+------------+                                                                  
| DIV0(1, 0) |
|------------|
|   0.000000 |
+------------+

-- Example 4241
DIV0NULL( <dividend> , <divisor> )

-- Example 4242
SELECT 1/2;

+----------+
|      1/2 |
|----------|
| 0.500000 |
+----------+

-- Example 4243
SELECT DIV0NULL(1, 2);

+----------------+
| DIV0NULL(1, 2) |
|----------------|
|       0.500000 |
+----------------+

-- Example 4244
SELECT 1/0;
100051 (22012): Division by zero

-- Example 4245
SELECT DIV0NULL(1, 0);

+----------------+
| DIV0NULL(1, 0) |
|----------------|
|       0.000000 |
+----------------+

-- Example 4246
SELECT 1/NULL;

+--------+
| 1/NULL |
|--------|
|   NULL |
+--------+

-- Example 4247
SELECT DIV0NULL(1, NULL);

+-------------------+
| DIV0NULL(1, NULL) |
|-------------------|
|          0.000000 |
+-------------------+

-- Example 4248
SNOWFLAKE.CORE.AVG(<query>)

-- Example 4249
SELECT SNOWFLAKE.CORE.AVG(
  SELECT
    salary
  FROM hr.tables.empl_info
);

-- Example 4250
+------------------------------------------------------------+
| SNOWFLAKE.CORE.AVG(SELECT salary FROM hr.tables.empl_info) |
+------------------------------------------------------------+
| 137000                                                     |
+------------------------------------------------------------+

-- Example 4251
SNOWFLAKE.CORE.BLANK_COUNT(<query>)

-- Example 4252
SELECT SNOWFLAKE.CORE.BLANK_COUNT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4253
+-----------------------------------------------------------------+
| SNOWFLAKE.CORE.BLANK_COUNT(SELECT ssn FROM hr.tables.empl_info) |
+-----------------------------------------------------------------+
| 1                                                               |
+-----------------------------------------------------------------+

-- Example 4254
SNOWFLAKE.CORE.BLANK_PERCENT(<query>)

-- Example 4255
SELECT SNOWFLAKE.CORE.BLANK_PERCENT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4256
+-------------------------------------------------------------------+
| SNOWFLAKE.CORE.BLANK_PERCENT(SELECT ssn FROM hr.tables.empl_info) |
+-------------------------------------------------------------------+
| 1                                                                 |
+-------------------------------------------------------------------+

-- Example 4257
SNOWFLAKE.CORE.DATA_METRIC_SCHEDULED_TIME()

-- Example 4258
CREATE OR REPLACE DATA METRIC FUNCTION data_freshness_hour(
  ARG_T TABLE (ARG_C TIMESTAMP_LTZ))
  RETURNS NUMBER AS
  'SELECT TIMEDIFF(
     minute,
     MAX(ARG_C),
     SNOWFLAKE.CORE.DATA_METRIC_SCHEDULED_TIME())
   FROM ARG_T';

-- Example 4259
SELECT data_freshness_hour(SELECT last_updated FROM hr.tables.empl_info) < 60;

-- Example 4260
SNOWFLAKE.CORE.DUPLICATE_COUNT(<query>)

-- Example 4261
SELECT SNOWFLAKE.CORE.DUPLICATE_COUNT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4262
+---------------------------------------------------------------------+
| SNOWFLAKE.CORE.DUPLICATE_COUNT(SELECT ssn FROM hr.tables.empl_info) |
+---------------------------------------------------------------------+
| 0                                                                   |
+---------------------------------------------------------------------+

-- Example 4263
SNOWFLAKE.CORE.FRESHNESS(<query>)

-- Example 4264
SELECT SNOWFLAKE.CORE.FRESHNESS(
  SELECT
    timestamp
  FROM hr.tables.empl_info
) < 300;

-- Example 4265
+---------------------------------------------------------------------+
| SNOWFLAKE.CORE.FRESHNESS(SELECT timestamp FROM hr.tables.empl_info) |
+---------------------------------------------------------------------+
| True                                                                |
+---------------------------------------------------------------------+

-- Example 4266
SNOWFLAKE.CORE.MAX(<query>)

-- Example 4267
SELECT SNOWFLAKE.CORE.MAX(
  SELECT
    salary
  FROM hr.tables.empl_info);

-- Example 4268
+------------------------------------------------------------+
| SNOWFLAKE.CORE.MAX(SELECT salary FROM hr.tables.empl_info) |
+------------------------------------------------------------+
| 325000                                                     |
+------------------------------------------------------------+

-- Example 4269
SNOWFLAKE.CORE.MIN(<query>)

-- Example 4270
SELECT SNOWFLAKE.CORE.MIN(
  SELECT
    salary
  FROM hr.tables.empl_info
);

