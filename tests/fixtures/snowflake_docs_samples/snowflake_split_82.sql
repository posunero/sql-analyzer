-- Example 5475
+-------------------+-------------------+------------------+
| WITHOUT_KEEP_NULL | KEEP_NULL_1       | KEEP_NULL_2      |
|-------------------+-------------------+------------------|
| {                 | {                 | {                |
|   "key_1": "one"  |   "key_1": "one", |   "key_1": "one" |
| }                 |   "key_2": null   | }                |
|                   | }                 |                  |
+-------------------+-------------------+------------------+

-- Example 5476
CREATE TABLE demo_table_1_with_nulls (province VARCHAR, created_date DATE);
INSERT INTO demo_table_1_with_nulls (province, created_date) VALUES
  ('Manitoba', '2024-01-18'::DATE),
  ('British Columbia', NULL),
  ('Alberta', '2024-01-19'::DATE),
  (NULL, '2024-01-20'::DATE);

-- Example 5477
SELECT *
  FROM demo_table_1_with_nulls
  ORDER BY province;

-- Example 5478
+------------------+--------------+
| PROVINCE         | CREATED_DATE |
|------------------+--------------|
| Alberta          | 2024-01-19   |
| British Columbia | NULL         |
| Manitoba         | 2024-01-18   |
| NULL             | 2024-01-20   |
+------------------+--------------+

-- Example 5479
SELECT OBJECT_CONSTRUCT(*) AS oc,
       OBJECT_CONSTRUCT_KEEP_NULL(*) AS oc_keep_null
  FROM demo_table_1_with_nulls
  ORDER BY oc_keep_null['PROVINCE'];

-- Example 5480
+----------------------------------+----------------------------------+
| OC                               | OC_KEEP_NULL                     |
|----------------------------------+----------------------------------|
| {                                | {                                |
|   "CREATED_DATE": "2024-01-19",  |   "CREATED_DATE": "2024-01-19",  |
|   "PROVINCE": "Alberta"          |   "PROVINCE": "Alberta"          |
| }                                | }                                |
| {                                | {                                |
|   "PROVINCE": "British Columbia" |   "CREATED_DATE": null,          |
| }                                |   "PROVINCE": "British Columbia" |
|                                  | }                                |
| {                                | {                                |
|   "CREATED_DATE": "2024-01-18",  |   "CREATED_DATE": "2024-01-18",  |
|   "PROVINCE": "Manitoba"         |   "PROVINCE": "Manitoba"         |
| }                                | }                                |
| {                                | {                                |
|   "CREATED_DATE": "2024-01-20"   |   "CREATED_DATE": "2024-01-20",  |
| }                                |   "PROVINCE": null               |
|                                  | }                                |
+----------------------------------+----------------------------------+

-- Example 5481
OBJECT_DELETE( <object>, <key1> [, <key2>, ... ] )

-- Example 5482
SELECT OBJECT_DELETE( {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR), 'zip_code' );

-- Example 5483
093201 (23001): Function OBJECT_DELETE: expected structured object to contain field zip_code but it did not.

-- Example 5484
SELECT
  OBJECT_DELETE(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'city'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 5485
+-----------------+--------------------------------------+
| NEW_OBJECT      | SYSTEM$TYPEOF(NEW_OBJECT)            |
|-----------------+--------------------------------------|
| {               | OBJECT(state VARCHAR(16777216))[LOB] |
|   "state": "CA" |                                      |
| }               |                                      |
+-----------------+--------------------------------------+

-- Example 5486
SELECT
  OBJECT_DELETE(
    {'state':'CA'}::OBJECT(state VARCHAR),
    'state'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 5487
+------------+---------------------------+
| NEW_OBJECT | SYSTEM$TYPEOF(NEW_OBJECT) |
|------------+---------------------------|
| {}         | OBJECT()[LOB]             |
+------------+---------------------------+

-- Example 5488
SELECT OBJECT_DELETE(OBJECT_CONSTRUCT('a', 1, 'b', 2, 'c', 3), 'a', 'b') AS object_returned;

-- Example 5489
+-----------------+
| OBJECT_RETURNED |
|-----------------|
| {               |
|   "c": 3        |
| }               |
+-----------------+

-- Example 5490
CREATE OR REPLACE TABLE object_delete_example (
  id INTEGER,
  ov OBJECT);

INSERT INTO object_delete_example (id, ov)
  SELECT
    1,
    {
      'employee_id': 1001,
      'employee_date_of_birth': '12-10-2003',
      'employee_contact':
        {
          'city': 'San Mateo',
          'state': 'CA',
          'phone': '800-555‑0100'
        }
    };

INSERT INTO object_delete_example (id, ov)
  SELECT
    2,
    {
      'employee_id': 1002,
      'employee_date_of_birth': '01-01-1990',
      'employee_contact':
        {
          'city': 'Seattle',
          'state': 'WA',
          'phone': '800-555‑0101'
        }
    };

-- Example 5491
SELECT * FROM object_delete_example;

-- Example 5492
+----+-------------------------------------------+
| ID | OV                                        |
|----+-------------------------------------------|
|  1 | {                                         |
|    |   "employee_contact": {                   |
|    |     "city": "San Mateo",                  |
|    |     "phone": "800-555‑0100",              |
|    |     "state": "CA"                         |
|    |   },                                      |
|    |   "employee_date_of_birth": "12-10-2003", |
|    |   "employee_id": 1001                     |
|    | }                                         |
|  2 | {                                         |
|    |   "employee_contact": {                   |
|    |     "city": "Seattle",                    |
|    |     "phone": "800-555‑0101",              |
|    |     "state": "WA"                         |
|    |   },                                      |
|    |   "employee_date_of_birth": "01-01-1990", |
|    |   "employee_id": 1002                     |
|    | }                                         |
+----+-------------------------------------------+

-- Example 5493
SELECT id,
       OBJECT_DELETE(ov, 'employee_date_of_birth') AS contact_without_date_of_birth
  FROM object_delete_example;

-- Example 5494
+----+-------------------------------+
| ID | CONTACT_WITHOUT_DATE_OF_BIRTH |
|----+-------------------------------|
|  1 | {                             |
|    |   "employee_contact": {       |
|    |     "city": "San Mateo",      |
|    |     "phone": "800-555‑0100",  |
|    |     "state": "CA"             |
|    |   },                          |
|    |   "employee_id": 1001         |
|    | }                             |
|  2 | {                             |
|    |   "employee_contact": {       |
|    |     "city": "Seattle",        |
|    |     "phone": "800-555‑0101",  |
|    |     "state": "WA"             |
|    |   },                          |
|    |   "employee_id": 1002         |
|    | }                             |
+----+-------------------------------+

-- Example 5495
SELECT id,
       OBJECT_DELETE(ov:"employee_contact", 'phone') AS contact_without_phone
  FROM object_delete_example;

-- Example 5496
+----+------------------------+
| ID | CONTACT_WITHOUT_PHONE  |
|----+------------------------|
|  1 | {                      |
|    |   "city": "San Mateo", |
|    |   "state": "CA"        |
|    | }                      |
|  2 | {                      |
|    |   "city": "Seattle",   |
|    |   "state": "WA"        |
|    | }                      |
+----+------------------------+

-- Example 5497
OBJECT_INSERT( <object> , <key> , <value> [ , <updateFlag> ] )

-- Example 5498
SELECT OBJECT_INSERT(
  {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
  'city',
  'San Jose',
  false
);

-- Example 5499
093202 (23001): Function OBJECT_INSERT:
  expected structured object to not contain field city but it did.

-- Example 5500
SELECT
  OBJECT_INSERT(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'zip_code',
    94402::FLOAT,
    false
  ) AS new_object,
  SYSTEM$TYPEOF(new_object) AS type;

-- Example 5501
+-------------------------------------+---------------------------------------------------------------------------------------+
| NEW_OBJECT                          | TYPE                                                                                  |
|-------------------------------------+---------------------------------------------------------------------------------------|
| {                                   | OBJECT(city VARCHAR(16777216), state VARCHAR(16777216), zip_code FLOAT NOT NULL)[LOB] |
|   "city": "San Mateo",              |                                                                                       |
|   "state": "CA",                    |                                                                                       |
|   "zip_code": 9.440200000000000e+04 |                                                                                       |
| }                                   |                                                                                       |
+-------------------------------------+---------------------------------------------------------------------------------------+

-- Example 5502
CREATE OR REPLACE TABLE object_insert_examples (object_column OBJECT);

INSERT INTO object_insert_examples (object_column)
  SELECT OBJECT_CONSTRUCT('a', 'value1', 'b', 'value2');

SELECT * FROM object_insert_examples;

-- Example 5503
+------------------+
| OBJECT_COLUMN    |
|------------------|
| {                |
|   "a": "value1", |
|   "b": "value2"  |
| }                |
+------------------+

-- Example 5504
UPDATE object_insert_examples
  SET object_column = OBJECT_INSERT(object_column, 'c', 'value3');

SELECT * FROM object_insert_examples;

-- Example 5505
+------------------+
| OBJECT_COLUMN    |
|------------------|
| {                |
|   "a": "value1", |
|   "b": "value2", |
|   "c": "value3"  |
| }                |
+------------------+

-- Example 5506
UPDATE object_insert_examples
  SET object_column = OBJECT_INSERT(object_column, 'd', PARSE_JSON('null'));

UPDATE object_insert_examples
  SET object_column = OBJECT_INSERT(object_column, 'e', NULL);

UPDATE object_insert_examples
  SET object_column = OBJECT_INSERT(object_column, 'f', 'null');

SELECT * FROM object_insert_examples;

-- Example 5507
+------------------+
| OBJECT_COLUMN    |
|------------------|
| {                |
|   "a": "value1", |
|   "b": "value2", |
|   "c": "value3", |
|   "d": null,     |
|   "f": "null"    |
| }                |
+------------------+

-- Example 5508
UPDATE object_insert_examples
  SET object_column = OBJECT_INSERT(object_column, 'b', 'valuex', TRUE);

SELECT * FROM object_insert_examples;

-- Example 5509
+------------------+
| OBJECT_COLUMN    |
|------------------|
| {                |
|   "a": "value1", |
|   "b": "valuex", |
|   "c": "value3", |
|   "d": null,     |
|   "f": "null"    |
| }                |
+------------------+

-- Example 5510
OBJECT_KEYS( <object> )

-- Example 5511
CREATE TABLE objects_1 (id INTEGER, object1 OBJECT, variant1 VARIANT);

-- Example 5512
INSERT INTO objects_1 (id, object1, variant1) 
  SELECT
    1,
    OBJECT_CONSTRUCT('a', 1, 'b', 2, 'c', 3),
    TO_VARIANT(OBJECT_CONSTRUCT('a', 1, 'b', 2, 'c', 3))
    ;

-- Example 5513
SELECT OBJECT_KEYS(object1), OBJECT_KEYS(variant1) 
    FROM objects_1
    ORDER BY id;
+----------------------+-----------------------+
| OBJECT_KEYS(OBJECT1) | OBJECT_KEYS(VARIANT1) |
|----------------------+-----------------------|
| [                    | [                     |
|   "a",               |   "a",                |
|   "b",               |   "b",                |
|   "c"                |   "c"                 |
| ]                    | ]                     |
+----------------------+-----------------------+

-- Example 5514
SELECT OBJECT_KEYS (
           PARSE_JSON (
               '{
                    "level_1_A": {
                                 "level_2": "two"
                                 },
                    "level_1_B": "one"
                    }'
               )
           ) AS keys
    ORDER BY 1;
+----------------+
| KEYS           |
|----------------|
| [              |
|   "level_1_A", |
|   "level_1_B"  |
| ]              |
+----------------+

-- Example 5515
OBJECT_PICK( <object>, <key1> [, <key2>, ... ] )

OBJECT_PICK( <object>, <array> )

-- Example 5516
SELECT
  OBJECT_PICK(
    {'city':'San Mateo','state':'CA','zip_code':94402}::OBJECT(city VARCHAR,state VARCHAR,zip_code DOUBLE),
    'state',
    'city') AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 5517
+-----------------------+--------------------------------------------------------------+
| NEW_OBJECT            | SYSTEM$TYPEOF(NEW_OBJECT)                                    |
|-----------------------+--------------------------------------------------------------|
| {                     | OBJECT(state VARCHAR(16777216), city VARCHAR(16777216))[LOB] |
|   "state": "CA",      |                                                              |
|   "city": "San Mateo" |                                                              |
| }                     |                                                              |
+-----------------------+--------------------------------------------------------------+

-- Example 5518
SELECT OBJECT_PICK(
    OBJECT_CONSTRUCT(
        'a', 1,
        'b', 2,
        'c', 3
    ),
    'a', 'b'
) AS new_object;
+------------+
| NEW_OBJECT |
|------------|
| {          |
|   "a": 1,  |
|   "b": 2   |
| }          |
+------------+

-- Example 5519
SELECT OBJECT_PICK(
    OBJECT_CONSTRUCT(
        'a', 1,
        'b', 2,
        'c', 3
    ),
    ARRAY_CONSTRUCT('a', 'b')
) AS new_object;
+------------+
| NEW_OBJECT |
|------------|
| {          |
|   "a": 1,  |
|   "b": 2   |
| }          |
+------------+

-- Example 5520
OCTET_LENGTH(<string_or_binary>)

-- Example 5521
SELECT OCTET_LENGTH('abc'), OCTET_LENGTH('\u0392'), OCTET_LENGTH(X'A1B2');

---------------------+------------------------+-----------------------+
 OCTET_LENGTH('ABC') | OCTET_LENGTH('\U0392') | OCTET_LENGTH(X'A1B2') |
---------------------+------------------------+-----------------------+
 3                   | 2                      | 2                     |
---------------------+------------------------+-----------------------+

-- Example 5522
SNOWFLAKE.CORTEX.PARSE_DOCUMENT( '@<stage>', '<path>', [ { 'mode': '<mode>' }, ] )

-- Example 5523
SELECT TO_VARCHAR(
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
        '@PARSE_DOCUMENT.DEMO.documents',
        'document_1.pdf',
        {'mode': 'OCR'})
    ) AS OCR;

-- Example 5524
{
    "content": "content of the document"
}

-- Example 5525
SELECT
  TO_VARCHAR (
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT (
        '@PARSE_DOCUMENT.DEMO.documents',
        'document_1.pdf',
        {'mode': 'LAYOUT'} ) ) AS LAYOUT;

-- Example 5526
{
  "content": "# This is PARSE DOCUMENT example
     Example table:
     |Header|Second header|Third Header|
     |:---:|:---:|:---:|
     |First row header|Data in first row|Data in first row|
     |Second row header|Data in second row|Data in second row|

     Some more text."
 }

-- Example 5527
PARSE_IP(<expr>, '<type>' [, <permissive>])

-- Example 5528
SELECT column1, PARSE_IP(column1, 'INET') FROM VALUES('192.168.242.188/24'), ('192.168.243.189/24');
--------------------+-----------------------------------+
 COLUMN1            | PARSE_IP(COLUMN1, 'INET')         |
--------------------+-----------------------------------|
 192.168.242.188/24 | {                                 |
                    |   "family": 4,                    |
                    |   "host": "192.168.242.188",      |
                    |   "ip_fields": [                  |
                    |     3232297660,                   |
                    |     0,                            |
                    |     0,                            |
                    |     0                             |
                    |   ],                              |
                    |   "ip_type": "inet",              |
                    |   "ipv4": 3232297660,             |
                    |   "ipv4_range_end": 3232297727,   |
                    |   "ipv4_range_start": 3232297472, |
                    |   "netmask_prefix_length": 24,    |
                    |   "snowflake$type": "ip_address"  |
                    | }                                 |
 192.168.243.189/24 | {                                 |
                    |   "family": 4,                    |
                    |   "host": "192.168.243.189",      |
                    |   "ip_fields": [                  |
                    |     3232297917,                   |
                    |     0,                            |
                    |     0,                            |
                    |     0                             |
                    |   ],                              |
                    |   "ip_type": "inet",              |
                    |   "ipv4": 3232297917,             |
                    |   "ipv4_range_end": 3232297983,   |
                    |   "ipv4_range_start": 3232297728, |
                    |   "netmask_prefix_length": 24,    |
                    |   "snowflake$type": "ip_address"  |
                    | }                                 |
--------------------+-----------------------------------+

-- Example 5529
SELECT PARSE_IP('fe80::20c:29ff:fe2c:429/64', 'INET');

----------------------------------------------------------------+
  PARSE_IP('FE80::20C:29FF:FE2C:429/64', 'INET')                |
----------------------------------------------------------------|
  {                                                             |
    "family": 6,                                                |
    "hex_ipv6": "FE80000000000000020C29FFFE2C0429",             |
    "hex_ipv6_range_end": "FE80000000000000FFFFFFFFFFFFFFFF",   |
    "hex_ipv6_range_start": "FE800000000000000000000000000000", |
    "host": "fe80::20c:29ff:fe2c:429",                          |
    "ip_fields": [                                              |
      4269801472,                                               |
      0,                                                        |
      34351615,                                                 |
      4264297513                                                |
    ],                                                          |
    "ip_type": "inet",                                          |
    "netmask_prefix_length": 64,                                |
    "snowflake$type": "ip_address"                              |
  }                                                             |
----------------------------------------------------------------+

-- Example 5530
WITH
lookup AS (
  SELECT column1 AS tag, PARSE_IP(column2, 'INET') AS obj FROM VALUES('San Francisco', '192.168.242.0/24'), ('New York', '192.168.243.0/24')
),
entries AS (
  SELECT PARSE_IP(column1, 'INET') AS ipv4 FROM VALUES('192.168.242.188/24'), ('192.168.243.189/24')
)
SELECT lookup.tag, entries.ipv4:host, entries.ipv4
FROM lookup, entries
WHERE lookup.tag = 'San Francisco'
AND entries.IPv4:ipv4 BETWEEN lookup.obj:ipv4_range_start AND lookup.obj:ipv4_range_end;

---------------+-------------------+-----------------------------------+
 TAG           | ENTRIES.IPV4:HOST | IPV4                              |
---------------+-------------------+-----------------------------------|
 San Francisco | "192.168.242.188" | {                                 |
               |                   |   "family": 4,                    |
               |                   |   "host": "192.168.242.188",      |
               |                   |   "ip_fields": [                  |
               |                   |     3232297660,                   |
               |                   |     0,                            |
               |                   |     0,                            |
               |                   |     0                             |
               |                   |   ],                              |
               |                   |   "ip_type": "inet",              |
               |                   |   "ipv4": 3232297660,             |
               |                   |   "ipv4_range_end": 3232297727,   |
               |                   |   "ipv4_range_start": 3232297472, |
               |                   |   "netmask_prefix_length": 24,    |
               |                   |   "snowflake$type": "ip_address"  |
               |                   | }                                 |
---------------+-------------------+-----------------------------------+

-- Example 5531
CREATE OR REPLACE TABLE ipv6_lookup (tag String, obj VARIANT);

-----------------------------------------+
 status                                  |
-----------------------------------------|
 Table IPV6_LOOKUP successfully created. |
-----------------------------------------+

INSERT INTO ipv6_lookup
    SELECT column1 AS tag, parse_ip(column2, 'INET') AS obj
    FROM VALUES('west', 'fe80:12:20c:29ff::/64'), ('east', 'fe80:12:1:29ff::/64');

-------------------------+
 number of rows inserted |
-------------------------|
                       2 |
-------------------------+

CREATE OR REPLACE TABLE ipv6_entries (obj VARIANT);
------------------------------------------+
 status                                   |
------------------------------------------|
 Table IPV6_ENTRIES successfully created. |
------------------------------------------+

INSERT INTO ipv6_entries
    SELECT parse_ip(column1, 'INET') as obj
    FROM VALUES
        ('fe80:12:20c:29ff:fe2c:430:370:2/64'),
        ('fe80:12:20c:29ff:fe2c:430:370:00F0/64'),
        ('fe80:12:20c:29ff:fe2c:430:370:0F00/64'),
        ('fe80:12:20c:29ff:fe2c:430:370:F000/64'),
        ('fe80:12:20c:29ff:fe2c:430:370:FFFF/64'),
        ('fe80:12:1:29ff:fe2c:430:370:FFFF/64'),
        ('fe80:12:1:29ff:fe2c:430:370:F000/64'),
        ('fe80:12:1:29ff:fe2c:430:370:0F00/64'),
        ('fe80:12:1:29ff:fe2c:430:370:00F0/64'),
        ('fe80:12:1:29ff:fe2c:430:370:2/64');

-------------------------+
 number of rows inserted |
-------------------------|
                      10 |
-------------------------+

SELECT lookup.tag, entries.obj:host
    FROM ipv6_lookup AS lookup, ipv6_entries AS entries
    WHERE lookup.tag = 'east'
    AND entries.obj:hex_ipv6 BETWEEN lookup.obj:hex_ipv6_range_start AND lookup.obj:hex_ipv6_range_end;

------+------------------------------------+
 TAG  | ENTRIES.OBJ:HOST                   |
------+------------------------------------|
 east | "fe80:12:1:29ff:fe2c:430:370:FFFF" |
 east | "fe80:12:1:29ff:fe2c:430:370:F000" |
 east | "fe80:12:1:29ff:fe2c:430:370:0F00" |
 east | "fe80:12:1:29ff:fe2c:430:370:00F0" |
 east | "fe80:12:1:29ff:fe2c:430:370:2"    |
------+------------------------------------+

-- Example 5532
PARSE_JSON( <expr> [ , '<parameter>' ] )

-- Example 5533
CREATE OR REPLACE TABLE vartab (n NUMBER(2), v VARIANT);

INSERT INTO vartab
  SELECT column1 AS n, PARSE_JSON(column2) AS v
    FROM VALUES (1, 'null'), 
                (2, null), 
                (3, 'true'),
                (4, '-17'), 
                (5, '123.12'), 
                (6, '1.912e2'),
                (7, '"Om ara pa ca na dhih"  '), 
                (8, '[-1, 12, 289, 2188, false,]'), 
                (9, '{ "x" : "abc", "y" : false, "z": 10} ') 
       AS vals;

-- Example 5534
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 5535
+---+------------------------+------------+
| N | V                      | TYPEOF(V)  |
|---+------------------------+------------|
| 1 | null                   | NULL_VALUE |
| 2 | NULL                   | NULL       |
| 3 | true                   | BOOLEAN    |
| 4 | -17                    | INTEGER    |
| 5 | 123.12                 | DECIMAL    |
| 6 | 1.912000000000000e+02  | DOUBLE     |
| 7 | "Om ara pa ca na dhih" | VARCHAR    |
| 8 | [                      | ARRAY      |
|   |   -1,                  |            |
|   |   12,                  |            |
|   |   289,                 |            |
|   |   2188,                |            |
|   |   false,               |            |
|   |   undefined            |            |
|   | ]                      |            |
| 9 | {                      | OBJECT     |
|   |   "x": "abc",          |            |
|   |   "y": false,          |            |
|   |   "z": 10              |            |
|   | }                      |            |
+---+------------------------+------------+

-- Example 5536
INSERT INTO vartab
SELECT column1 AS n, PARSE_JSON(column2) AS v
  FROM VALUES (10, '{ "a" : "123", "b" : "456", "a": "789"} ')
     AS vals;

-- Example 5537
100069 (22P02): Error parsing JSON: duplicate object attribute "a", pos 31

-- Example 5538
INSERT INTO vartab
SELECT column1 AS n, PARSE_JSON(column2, 'd') AS v
  FROM VALUES (10, '{ "a" : "123", "b" : "456", "a": "789"} ')
     AS vals;

-- Example 5539
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 5540
SELECT v
  FROM vartab
  WHERE n = 10;

-- Example 5541
+---------------+
| V             |
|---------------|
| {             |
|   "a": "789", |
|   "b": "456"  |
| }             |
+---------------+

