-- Example 2313
SELECT
  SYSTEM$TYPEOF(
    [1,2,3]::ARRAY(NUMBER)
  ) AS array_cast_type,
  SYSTEM$TYPEOF(
    [1,2,3]::VARIANT::ARRAY(NUMBER)
  ) AS variant_cast_type;

-- Example 2314
+--------------------------+--------------------------+
| ARRAY_CAST_TYPE          | VARIANT_CAST_TYPE        |
|--------------------------+--------------------------|
| ARRAY(NUMBER(38,0))[LOB] | ARRAY(NUMBER(38,0))[LOB] |
+--------------------------+--------------------------+

-- Example 2315
SELECT
  CAST ([1,2,3] AS ARRAY(VARCHAR)) AS varchar_array,
  SYSTEM$TYPEOF(varchar_array) AS array_cast_type;

-- Example 2316
+---------------+-------------------------------+
| VARCHAR_ARRAY | ARRAY_CAST_TYPE               |
|---------------+-------------------------------|
| [             | ARRAY(VARCHAR(16777216))[LOB] |
|   "1",        |                               |
|   "2",        |                               |
|   "3"         |                               |
| ]             |                               |
+---------------+-------------------------------+

-- Example 2317
SELECT
  SYSTEM$TYPEOF(
    CAST ({'city':'San Mateo','state':'CA'} AS OBJECT(city VARCHAR, state VARCHAR))
  ) AS object_cast_type,
  SYSTEM$TYPEOF(
    CAST ({'city':'San Mateo','state':'CA'}::VARIANT AS OBJECT(city VARCHAR, state VARCHAR))
  ) AS variant_cast_type;

-- Example 2318
SELECT
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  ) AS object_cast_type,
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::VARIANT::OBJECT(city VARCHAR, state VARCHAR)
  ) AS variant_cast_type;

-- Example 2319
+--------------------------------------------------------------+--------------------------------------------------------------+
| OBJECT_CAST_TYPE                                             | VARIANT_CAST_TYPE                                            |
|--------------------------------------------------------------+--------------------------------------------------------------|
| OBJECT(city VARCHAR(16777216), state VARCHAR(16777216))[LOB] | OBJECT(city VARCHAR(16777216), state VARCHAR(16777216))[LOB] |
+--------------------------------------------------------------+--------------------------------------------------------------+

-- Example 2320
SELECT
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS variant_cast_type;

-- Example 2321
SELECT
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::MAP(VARCHAR, VARCHAR)
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::VARIANT::MAP(VARCHAR, VARCHAR)
  ) AS variant_cast_type;

-- Example 2322
+------------------------------------------------+------------------------------------------------+
| MAP_CAST_TYPE                                  | VARIANT_CAST_TYPE                              |
|------------------------------------------------+------------------------------------------------|
| MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] | MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] |
+------------------------------------------------+------------------------------------------------+

-- Example 2323
SELECT [1,2,NULL,3]::ARRAY(INTEGER)::VARIANT;

-- Example 2324
+---------------------------------------+
| [1,2,NULL,3]::ARRAY(INTEGER)::VARIANT |
|---------------------------------------|
| [                                     |
|   1,                                  |
|   2,                                  |
|   undefined,                          |
|   3                                   |
| ]                                     |
+---------------------------------------+

-- Example 2325
SELECT CAST(
  CAST([1,2,3] AS ARRAY(NUMBER))
  AS ARRAY(VARCHAR)) AS cast_array;

-- Example 2326
+------------+
| CAST_ARRAY |
|------------|
| [          |
|   "1",     |
|   "2",     |
|   "3"      |
| ]          |
+------------+

-- Example 2327
SELECT CAST(
  {'city': 'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(state VARCHAR, city VARCHAR)) AS object_value_order;

-- Example 2328
+-----------------------+
| OBJECT_VALUE_ORDER    |
|-----------------------|
| {                     |
|   "state": "CA",      |
|   "city": "San Mateo" |
| }                     |
+-----------------------+

-- Example 2329
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city_name VARCHAR, state_name VARCHAR) RENAME FIELDS) AS object_value_key_names;

-- Example 2330
+-----------------------------+
| OBJECT_VALUE_KEY_NAMES      |
|-----------------------------|
| {                           |
|   "city_name": "San Mateo", |
|   "state_name": "CA"        |
| }                           |
+-----------------------------+

-- Example 2331
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city VARCHAR, state VARCHAR, zipcode NUMBER) ADD FIELDS) AS add_fields;

-- Example 2332
+------------------------+
| ADD_FIELDS             |
|------------------------|
| {                      |
|   "city": "San Mateo", |
|   "state": "CA",       |
|   "zipcode": null      |
| }                      |
+------------------------+

-- Example 2333
SELECT ARRAY_CONSTRUCT(10, 20, 30)::ARRAY(NUMBER);

-- Example 2334
SELECT OBJECT_CONSTRUCT(
  'oname', 'abc',
  'created_date', '2020-01-18'::DATE
)::OBJECT(
  oname VARCHAR,
  created_date DATE
);

-- Example 2335
SELECT [10, 20, 30]::ARRAY(NUMBER);

-- Example 2336
SELECT {
  'oname': 'abc',
  'created_date': '2020-01-18'::DATE
}::OBJECT(
  oname VARCHAR,
  created_date DATE
);

-- Example 2337
SELECT OBJECT_CONSTRUCT(
  'city', 'San Mateo',
  'state', 'CA'
)::MAP(
  VARCHAR,
  VARCHAR
);

-- Example 2338
SELECT {
  'city': 'San Mateo',
  'state': 'CA'
}::MAP(
  VARCHAR,
  VARCHAR
);

-- Example 2339
SELECT {
  '-10': 'CA',
  '-20': 'OR'
}::MAP(
  NUMBER,
  VARCHAR
);

-- Example 2340
SELECT OBJECT_KEYS({'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR));

-- Example 2341
SELECT MAP_KEYS({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));

-- Example 2342
SELECT
  SYSTEM$TYPEOF(
    ARRAY_CONSTRUCT('San Mateo')[0]
  ) AS semi_structured_array_element,
  SYSTEM$TYPEOF(
    CAST(
      ARRAY_CONSTRUCT('San Mateo') AS ARRAY(VARCHAR)
    )[0]
  ) AS structured_array_element;

-- Example 2343
+-------------------------------+-----------------------------+
| SEMI_STRUCTURED_ARRAY_ELEMENT | STRUCTURED_ARRAY_ELEMENT    |
|-------------------------------+-----------------------------|
| VARIANT[LOB]                  | VARCHAR(16777216)[LOB]      |
+-------------------------------+-----------------------------+

-- Example 2344
SELECT ARRAY_SIZE([1,2,3]::ARRAY(NUMBER));

-- Example 2345
SELECT MAP_SIZE({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));

-- Example 2346
SELECT ARRAY_CONTAINS(10, [1, 10, 100]::ARRAY(NUMBER));

-- Example 2347
SELECT ARRAY_POSITION(10, [1, 10, 100]::ARRAY(NUMBER));

-- Example 2348
SELECT MAP_CONTAINS_KEY('key_to_find', my_map);

-- Example 2349
SELECT MAP_CONTAINS_KEY(10, my_map);

-- Example 2350
{'a':2,'b':1}::OBJECT(b INTEGER,a INTEGER)

-- Example 2351
{'a':1,'b':2}::OBJECT(b INTEGER,a INTEGER)

-- Example 2352
SELECT ARRAYS_OVERLAP(numeric_array, other_numeric_array);

-- Example 2353
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), 3::NUMBER );

-- Example 2354
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), '3' );

-- Example 2355
SELECT ARRAY_APPEND( [1,2]::ARRAY(NUMBER), '2022-02-02'::DATE );

-- Example 2356
SELECT ARRAY_CAT( [1,2]::ARRAY(NUMBER), ['3','4'] );

-- Example 2357
SELECT ARRAY_CAT( [1,2], ['3','4']::ARRAY(VARCHAR) );

-- Example 2358
SELECT
  ARRAY_CAT(
    [1, 2, 3]::ARRAY(NUMBER NOT NULL),
    [5.5, NULL]::ARRAY(NUMBER(2, 1))
  ) AS concatenated_array,
  SYSTEM$TYPEOF(concatenated_array);

-- Example 2359
+--------------------+-----------------------------------+
| CONCATENATED_ARRAY | SYSTEM$TYPEOF(CONCATENATED_ARRAY) |
|--------------------+-----------------------------------|
| [                  | ARRAY(NUMBER(38,1))[LOB]          |
|   1,               |                                   |
|   2,               |                                   |
|   3,               |                                   |
|   5.5,             |                                   |
|   undefined        |                                   |
| ]                  |                                   |
+--------------------+-----------------------------------+

-- Example 2360
SELECT ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), [2,3]::ARRAY(DOUBLE) );

-- Example 2361
SELECT ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), ['2','3']::ARRAY(VARCHAR) );

-- Example 2362
SELECT OBJECT_DELETE( {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR), 'zip_code' );

-- Example 2363
093201 (23001): Function OBJECT_DELETE: expected structured object to contain field zip_code but it did not.

-- Example 2364
SELECT
  OBJECT_DELETE(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'city'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 2365
+-----------------+--------------------------------------+
| NEW_OBJECT      | SYSTEM$TYPEOF(NEW_OBJECT)            |
|-----------------+--------------------------------------|
| {               | OBJECT(state VARCHAR(16777216))[LOB] |
|   "state": "CA" |                                      |
| }               |                                      |
+-----------------+--------------------------------------+

-- Example 2366
SELECT
  OBJECT_DELETE(
    {'state':'CA'}::OBJECT(state VARCHAR),
    'state'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 2367
+------------+---------------------------+
| NEW_OBJECT | SYSTEM$TYPEOF(NEW_OBJECT) |
|------------+---------------------------|
| {}         | OBJECT()[LOB]             |
+------------+---------------------------+

-- Example 2368
SELECT OBJECT_INSERT(
  {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
  'city',
  'San Jose',
  false
);

-- Example 2369
093202 (23001): Function OBJECT_INSERT:
  expected structured object to not contain field city but it did.

-- Example 2370
SELECT
  OBJECT_INSERT(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'zip_code',
    94402::FLOAT,
    false
  ) AS new_object,
  SYSTEM$TYPEOF(new_object) AS type;

-- Example 2371
+-------------------------------------+---------------------------------------------------------------------------------------+
| NEW_OBJECT                          | TYPE                                                                                  |
|-------------------------------------+---------------------------------------------------------------------------------------|
| {                                   | OBJECT(city VARCHAR(16777216), state VARCHAR(16777216), zip_code FLOAT NOT NULL)[LOB] |
|   "city": "San Mateo",              |                                                                                       |
|   "state": "CA",                    |                                                                                       |
|   "zip_code": 9.440200000000000e+04 |                                                                                       |
| }                                   |                                                                                       |
+-------------------------------------+---------------------------------------------------------------------------------------+

-- Example 2372
SELECT
  OBJECT_PICK(
    {'city':'San Mateo','state':'CA','zip_code':94402}::OBJECT(city VARCHAR,state VARCHAR,zip_code DOUBLE),
    'state',
    'city') AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 2373
+-----------------------+--------------------------------------------------------------+
| NEW_OBJECT            | SYSTEM$TYPEOF(NEW_OBJECT)                                    |
|-----------------------+--------------------------------------------------------------|
| {                     | OBJECT(state VARCHAR(16777216), city VARCHAR(16777216))[LOB] |
|   "state": "CA",      |                                                              |
|   "city": "San Mateo" |                                                              |
| }                     |                                                              |
+-----------------------+--------------------------------------------------------------+

-- Example 2374
SELECT value, SYSTEM$TYPEOF(value)
  FROM TABLE(FLATTEN(INPUT => [1.08, 2.13, 3.14]::ARRAY(DOUBLE)));

-- Example 2375
+-------+----------------------+
| VALUE | SYSTEM$TYPEOF(VALUE) |
|-------+----------------------|
|  1.08 | FLOAT[DOUBLE]        |
|  2.13 | FLOAT[DOUBLE]        |
|  3.14 | FLOAT[DOUBLE]        |
+-------+----------------------+

-- Example 2376
SELECT key, SYSTEM$TYPEOF(key), value, SYSTEM$TYPEOF(value)
  FROM TABLE(FLATTEN(INPUT => {'my_key': 'my_value'}::MAP(VARCHAR, VARCHAR)));

-- Example 2377
+--------+------------------------+----------+------------------------+
| KEY    | SYSTEM$TYPEOF(KEY)     | VALUE    | SYSTEM$TYPEOF(VALUE)   |
|--------+------------------------+----------+------------------------|
| my_key | VARCHAR(16777216)[LOB] | my_value | VARCHAR(16777216)[LOB] |
+--------+------------------------+----------+------------------------+

-- Example 2378
String result = resultSet.getString(1);

-- Example 2379
CREATE OR REPLACE FUNCTION my_udf(
    location OBJECT(city VARCHAR, zipcode NUMBER, val ARRAY(BOOLEAN)))
  RETURNS VARCHAR
  AS
  $$
    ...
  $$;

-- Example 2380
CREATE OR REPLACE FUNCTION my_udtf(check BOOLEAN)
  RETURNS TABLE(col1 ARRAY(VARCHAR))
  AS
  $$
  ...
  $$;

