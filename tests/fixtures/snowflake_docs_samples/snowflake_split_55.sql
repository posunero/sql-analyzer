-- Example 3668
ASIN( <real_expr> )

-- Example 3669
SELECT ASIN(0), ASIN(0.5), ASIN(1);

---------+--------------+-------------+
 ASIN(0) |  ASIN(0.5)   |   ASIN(1)   |
---------+--------------+-------------+
 0       | 0.5235987756 | 1.570796327 |
---------+--------------+-------------+

-- Example 3670
ASINH( <real_expr> )

-- Example 3671
SELECT ASINH(2.129279455);

--------------------+
 ASINH(2.129279455) |
--------------------+
 1.5                |
--------------------+

-- Example 3672
ATAN( <real_expr> )

-- Example 3673
SELECT ATAN(1);

--------------+
   ATAN(1)    |
--------------+
 0.7853981634 |
--------------+

-- Example 3674
ATAN2( <y> , <x> )

-- Example 3675
SELECT ATAN2(5, 5);

--------------+
 ATAN2(5, 5)  |
--------------+
 0.7853981634 |
--------------+

-- Example 3676
ATANH( <real_expr> )

-- Example 3677
SELECT ATANH(0.9051482536);

---------------------+
 ATANH(0.9051482536) |
---------------------+
 1.5                 |
---------------------+

-- Example 3678
AUTO_REFRESH_REGISTRATION_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ]
      [, OBJECT_TYPE => '<string>' [, OBJECT_NAME => '<string>'] ])

-- Example 3679
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>to_timestamp_tz('2021-06-17 12:00:00.000 -0700'),
    date_range_end=>to_timestamp_tz('2021-06-17 12:30:00.000 -0700'),
    object_type=>'external_table'));

-- Example 3680
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>dateadd('day',-14,current_date()),
    date_range_end=>current_date(),
    object_type=>'external_table'));

-- Example 3681
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>dateadd('day',-14,current_date()),
    date_range_end=>current_date(),
    object_type=>'external_table'));

-- Example 3682
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>dateadd('hour',-12,current_timestamp()),
    object_type=>'external_table',
    object_name=>'myexttable'));

-- Example 3683
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>dateadd('hour',-12,current_timestamp()),
    object_type=>'external_table',
    object_name=>'mydb.myschema.myexttable'));

-- Example 3684
AUTOMATIC_CLUSTERING_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , TABLE_NAME => '<string>' ] )

-- Example 3685
select *
  from table(information_schema.automatic_clustering_history(
    date_range_start=>'2018-04-10 13:00:00.000 -0700',
    date_range_end=>'2018-04-10 14:00:00.000 -0700'));

-- Example 3686
select *
  from table(information_schema.automatic_clustering_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 3687
select *
  from table(information_schema.automatic_clustering_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date));

-- Example 3688
select *
  from table(information_schema.automatic_clustering_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date,
    table_name=>'mydb.myschema.mytable'));

-- Example 3689
ALTER TABLE t1 SUSPEND RECLUSTER;

SHOW TABLES LIKE 't1';

+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
|           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |  owner   | retention_time | automatic_clustering |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| Thu, 12 Apr 2018 13:29:01 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         | LINEAR(C1) | 0    | 0     | SYSADMIN | 1              | OFF                  |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 3690
ALTER TABLE t1 RESUME RECLUSTER;

SHOW TABLES LIKE 't1';

+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
|           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |  owner   | retention_time | automatic_clustering |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| Thu, 12 Apr 2018 13:29:01 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         | LINEAR(C1) | 0    | 0     | SYSADMIN | 1              | ON                   |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 3691
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.automatic_clustering_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 3692
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.automatic_clustering_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
      AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 3693
AVAILABLE_LISTING_REFRESH_HISTORY(
  OBJECT_TYPE => '<object_type>',
  OBJECT_NAME => '<object_name>' )

-- Example 3694
SELECT * FROM TABLE(
  INFORMATION_SCHEMA.AVAILABLE_LISTING_REFRESH_HISTORY(
    OBJECT_TYPE=>'database',
    OBJECT_NAME=>'my_mounted_database'
  )
);

-- Example 3695
BASE64_DECODE_BINARY( <input> [ , <alphabet> ] )

-- Example 3696
CREATE OR REPLACE TABLE binary_table (v VARCHAR, b BINARY, b64_string VARCHAR);
INSERT INTO binary_table (v) VALUES ('HELP');
UPDATE binary_table SET b = TO_BINARY(v, 'UTF-8');
UPDATE binary_table SET b64_string = BASE64_ENCODE(b);

-- Example 3697
-- Note that the binary data in column b is displayed in hexadecimal
--   format to make it human-readable.
SELECT v, b, b64_string FROM binary_table;
+------+----------+------------+
| V    | B        | B64_STRING |
|------+----------+------------|
| HELP | 48454C50 | SEVMUA==   |
+------+----------+------------+

-- Example 3698
SELECT v, b, b64_string, 
        BASE64_DECODE_BINARY(b64_string) AS FROM_BASE64_BACK_TO_BINARY,
        TO_VARCHAR(BASE64_DECODE_BINARY(b64_string), 'UTF-8') AS BACK_TO_STRING
    FROM binary_table;
+------+----------+------------+----------------------------+----------------+
| V    | B        | B64_STRING | FROM_BASE64_BACK_TO_BINARY | BACK_TO_STRING |
|------+----------+------------+----------------------------+----------------|
| HELP | 48454C50 | SEVMUA==   | 48454C50                   | HELP           |
+------+----------+------------+----------------------------+----------------+

-- Example 3699
SET MY_STRING = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()abcdefghijklmnopqrstuvwzyz1234567890[]{};:,./<>?-=~';
CREATE OR REPLACE TABLE binary_table (v VARCHAR, b BINARY, b64_string VARCHAR);
INSERT INTO binary_table (v) VALUES ($MY_STRING);
UPDATE binary_table SET b = TO_BINARY(v, 'UTF-8');
UPDATE binary_table SET b64_string = BASE64_ENCODE(b, 0, '$');

-- Example 3700
SELECT v
    FROM binary_table;
+-----------------------------------------------------------------------------------------+
| V                                                                                       |
|-----------------------------------------------------------------------------------------|
| ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()abcdefghijklmnopqrstuvwzyz1234567890[]{};:,./<>?-=~ |
+-----------------------------------------------------------------------------------------+
SELECT b
    FROM binary_table;
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| B                                                                                                                                                                              |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 4142434445464748494A4B4C4D4E4F505152535455565758595A21402324255E262A28296162636465666768696A6B6C6D6E6F70717273747576777A797A313233343536373839305B5D7B7D3B3A2C2E2F3C3E3F2D3D7E |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
SELECT b64_string
    FROM binary_table;
+----------------------------------------------------------------------------------------------------------------------+
| B64_STRING                                                                                                           |
|----------------------------------------------------------------------------------------------------------------------|
| QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVohQCMkJV4mKigpYWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd6eXoxMjM0NTY3ODkwW117fTs6LC4vPD4/LT1$ |
+----------------------------------------------------------------------------------------------------------------------+
SELECT BASE64_DECODE_BINARY(b64_string, '$') AS FROM_BASE64_BACK_TO_BINARY
    FROM binary_table;
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| FROM_BASE64_BACK_TO_BINARY                                                                                                                                                     |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 4142434445464748494A4B4C4D4E4F505152535455565758595A21402324255E262A28296162636465666768696A6B6C6D6E6F70717273747576777A797A313233343536373839305B5D7B7D3B3A2C2E2F3C3E3F2D3D7E |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
SELECT TO_VARCHAR(BASE64_DECODE_BINARY(b64_string, '$'), 'UTF-8') AS BACK_TO_STRING
    FROM binary_table;
+-----------------------------------------------------------------------------------------+
| BACK_TO_STRING                                                                          |
|-----------------------------------------------------------------------------------------|
| ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()abcdefghijklmnopqrstuvwzyz1234567890[]{};:,./<>?-=~ |
+-----------------------------------------------------------------------------------------+

-- Example 3701
BASE64_DECODE_STRING( <input> [ , <alphabet> ] )

-- Example 3702
SELECT BASE64_DECODE_STRING('U25vd2ZsYWtl');
+--------------------------------------+
| BASE64_DECODE_STRING('U25VD2ZSYWTL') |
|--------------------------------------|
| Snowflake                            |
+--------------------------------------+

-- Example 3703
CREATE OR REPLACE TABLE base64_table (v VARCHAR, base64_string VARCHAR);
INSERT INTO base64_table (v) VALUES ('HELLO');
UPDATE base64_table SET base64_string = BASE64_ENCODE(v);

-- Example 3704
SELECT v, base64_string, BASE64_DECODE_STRING(base64_string) 
    FROM base64_table;
+-------+---------------+-------------------------------------+
| V     | BASE64_STRING | BASE64_DECODE_STRING(BASE64_STRING) |
|-------+---------------+-------------------------------------|
| HELLO | SEVMTE8=      | HELLO                               |
+-------+---------------+-------------------------------------+

-- Example 3705
BASE64_ENCODE( <input> [ , <max_line_length> ] [ , <alphabet> ] )

-- Example 3706
SELECT BASE64_ENCODE('Snowflake');

----------------------------+
 BASE64_ENCODE('SNOWFLAKE') |
----------------------------+
 U25vd2ZsYWtl               |
----------------------------+

-- Example 3707
SELECT BASE64_ENCODE('Snowflake ❄❄❄ Snowman ☃☃☃',32,'$');

---------------------------------------------------+
 BASE64_ENCODE('SNOWFLAKE ❄❄❄ SNOWMAN ☃☃☃',32,'$') |
---------------------------------------------------+
 U25vd2ZsYWtlIOKdhOKdhOKdhCBTbm93                  |
 bWFuIOKYg$KYg$KYgw==                              |
---------------------------------------------------+

-- Example 3708
CREATE OR REPLACE TABLE base64_table (v VARCHAR, base64_string VARCHAR);
INSERT INTO base64_table (v) VALUES ('HELLO');
UPDATE base64_table SET base64_string = BASE64_ENCODE(v);

-- Example 3709
SELECT v, base64_string, BASE64_DECODE_STRING(base64_string) 
    FROM base64_table;
+-------+---------------+-------------------------------------+
| V     | BASE64_STRING | BASE64_DECODE_STRING(BASE64_STRING) |
|-------+---------------+-------------------------------------|
| HELLO | SEVMTE8=      | HELLO                               |
+-------+---------------+-------------------------------------+

-- Example 3710
<expr> [ NOT ] BETWEEN <lower_bound> AND <upper_bound>

-- Example 3711
SELECT 'true' WHERE 1 BETWEEN 0 AND 10;

-- Example 3712
+--------+
| 'TRUE' |
|--------|
| true   |
+--------+

-- Example 3713
SELECT 'true' WHERE 1.35 BETWEEN 1 AND 2;

-- Example 3714
+--------+
| 'TRUE' |
|--------|
| true   |
+--------+

-- Example 3715
SELECT 'true' WHERE 'the' BETWEEN 'that' AND 'then';

-- Example 3716
+--------+
| 'TRUE' |
|--------|
| true   |
+--------+

-- Example 3717
SELECT 'm' BETWEEN COLLATE('A', 'lower') AND COLLATE('Z', 'lower');

-- Example 3718
+-------------------------------------------------------------+
| 'M' BETWEEN COLLATE('A', 'LOWER') AND COLLATE('Z', 'LOWER') |
|-------------------------------------------------------------|
| True                                                        |
+-------------------------------------------------------------+

-- Example 3719
SELECT COLLATE('m', 'upper') BETWEEN 'A' AND 'Z';

-- Example 3720
+-------------------------------------------+
| COLLATE('M', 'UPPER') BETWEEN 'A' AND 'Z' |
|-------------------------------------------|
| True                                      |
+-------------------------------------------+

-- Example 3721
BIT_LENGTH(<string_or_binary>)

-- Example 3722
CREATE TABLE bl (v VARCHAR, b BINARY);
INSERT INTO bl (v, b) VALUES 
   ('abc', NULL),
   ('\u0394', X'A1B2');

-- Example 3723
SELECT v, b, BIT_LENGTH(v), BIT_LENGTH(b) FROM bl ORDER BY v;
+-----+------+---------------+---------------+
| V   | B    | BIT_LENGTH(V) | BIT_LENGTH(B) |
|-----+------+---------------+---------------|
| abc | NULL |            24 |          NULL |
| Δ   | A1B2 |            16 |            16 |
+-----+------+---------------+---------------+

-- Example 3724
BITAND( <expr1> , <expr2> [ , '<padside>' ] )

-- Example 3725
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3726
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3727
SELECT bit1, 
       bit2, 
       BITAND(bit1, bit2), 
       BITOR(bit1, bit2), 
       BITXOR(bit1, BIT2)
  FROM bits
  ORDER BY bit1;

-- Example 3728
+------+-------+--------------------+-------------------+--------------------+
| BIT1 |  BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+-------+--------------------+-------------------+--------------------|
|    0 | 65504 |                  0 |             65504 |              65504 |
|    1 |     1 |                  1 |                 1 |                  0 |
|    2 |     4 |                  0 |                 6 |                  6 |
|    4 |     2 |                  0 |                 6 |                  6 |
|   16 |    24 |                 16 |                24 |                  8 |
| NULL |  NULL |               NULL |              NULL |               NULL |
+------+-------+--------------------+-------------------+--------------------+

-- Example 3729
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3730
SELECT bit1,
       bit2,
       BITAND(bit1, bit2),
       BITOR(bit1, bit2),
       BITXOR(bit1, bit2)
  FROM bits;

-- Example 3731
+------+------+--------------------+-------------------+--------------------+
| BIT1 | BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+------+--------------------+-------------------+--------------------|
| 1010 | 0101 | 0000               | 1111              | 1111               |
| 1100 | 0011 | 0000               | 1111              | 1111               |
| BCBC | EEFF | ACBC               | FEFF              | 5243               |
| NULL | NULL | NULL               | NULL              | NULL               |
+------+------+--------------------+-------------------+--------------------+

-- Example 3732
SELECT bit1,
       bit3,
       BITAND(bit1, bit3),
       BITOR(bit1, bit3),
       BITXOR(bit1, bit3)
  FROM bits;

-- Example 3733
100544 (22026): The lengths of two variable-sized fields do not match: first length 2, second length 4

-- Example 3734
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'LEFT'),
       BITOR(bit1, bit3, 'LEFT'),
       BITXOR(bit1, bit3, 'LEFT')
  FROM bits;

