-- Example 18269
SELECT
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  ) AS object_cast_type,
  SYSTEM$TYPEOF(
     {'city':'San Mateo','state':'CA'}::VARIANT::OBJECT(city VARCHAR, state VARCHAR)
  ) AS variant_cast_type;

-- Example 18270
+--------------------------------------------------------------+--------------------------------------------------------------+
| OBJECT_CAST_TYPE                                             | VARIANT_CAST_TYPE                                            |
|--------------------------------------------------------------+--------------------------------------------------------------|
| OBJECT(city VARCHAR(16777216), state VARCHAR(16777216))[LOB] | OBJECT(city VARCHAR(16777216), state VARCHAR(16777216))[LOB] |
+--------------------------------------------------------------+--------------------------------------------------------------+

-- Example 18271
SELECT
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    CAST ({'my_key':'my_value'} AS MAP(VARCHAR, VARCHAR))
  ) AS variant_cast_type;

-- Example 18272
SELECT
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::MAP(VARCHAR, VARCHAR)
  ) AS map_cast_type,
  SYSTEM$TYPEOF(
    {'my_key':'my_value'}::VARIANT::MAP(VARCHAR, VARCHAR)
  ) AS variant_cast_type;

-- Example 18273
+------------------------------------------------+------------------------------------------------+
| MAP_CAST_TYPE                                  | VARIANT_CAST_TYPE                              |
|------------------------------------------------+------------------------------------------------|
| MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] | MAP(VARCHAR(16777216), VARCHAR(16777216))[LOB] |
+------------------------------------------------+------------------------------------------------+

-- Example 18274
SELECT [1,2,NULL,3]::ARRAY(INTEGER)::VARIANT;

-- Example 18275
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

-- Example 18276
SELECT CAST(
  CAST([1,2,3] AS ARRAY(NUMBER))
  AS ARRAY(VARCHAR)) AS cast_array;

-- Example 18277
+------------+
| CAST_ARRAY |
|------------|
| [          |
|   "1",     |
|   "2",     |
|   "3"      |
| ]          |
+------------+

-- Example 18278
SELECT CAST(
  {'city': 'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(state VARCHAR, city VARCHAR)) AS object_value_order;

-- Example 18279
+-----------------------+
| OBJECT_VALUE_ORDER    |
|-----------------------|
| {                     |
|   "state": "CA",      |
|   "city": "San Mateo" |
| }                     |
+-----------------------+

-- Example 18280
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city_name VARCHAR, state_name VARCHAR) RENAME FIELDS) AS object_value_key_names;

-- Example 18281
+-----------------------------+
| OBJECT_VALUE_KEY_NAMES      |
|-----------------------------|
| {                           |
|   "city_name": "San Mateo", |
|   "state_name": "CA"        |
| }                           |
+-----------------------------+

-- Example 18282
SELECT CAST({'city':'San Mateo','state': 'CA'}::OBJECT(city VARCHAR, state VARCHAR)
  AS OBJECT(city VARCHAR, state VARCHAR, zipcode NUMBER) ADD FIELDS) AS add_fields;

-- Example 18283
+------------------------+
| ADD_FIELDS             |
|------------------------|
| {                      |
|   "city": "San Mateo", |
|   "state": "CA",       |
|   "zipcode": null      |
| }                      |
+------------------------+

-- Example 18284
SELECT ARRAY_CONSTRUCT(10, 20, 30)::ARRAY(NUMBER);

-- Example 18285
SELECT OBJECT_CONSTRUCT(
  'oname', 'abc',
  'created_date', '2020-01-18'::DATE
)::OBJECT(
  oname VARCHAR,
  created_date DATE
);

-- Example 18286
SELECT [10, 20, 30]::ARRAY(NUMBER);

-- Example 18287
SELECT {
  'oname': 'abc',
  'created_date': '2020-01-18'::DATE
}::OBJECT(
  oname VARCHAR,
  created_date DATE
);

-- Example 18288
SELECT OBJECT_CONSTRUCT(
  'city', 'San Mateo',
  'state', 'CA'
)::MAP(
  VARCHAR,
  VARCHAR
);

-- Example 18289
SELECT {
  'city': 'San Mateo',
  'state': 'CA'
}::MAP(
  VARCHAR,
  VARCHAR
);

-- Example 18290
SELECT {
  '-10': 'CA',
  '-20': 'OR'
}::MAP(
  NUMBER,
  VARCHAR
);

-- Example 18291
SELECT OBJECT_KEYS({'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR, state VARCHAR));

-- Example 18292
SELECT MAP_KEYS({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));

-- Example 18293
SELECT
  SYSTEM$TYPEOF(
    ARRAY_CONSTRUCT('San Mateo')[0]
  ) AS semi_structured_array_element,
  SYSTEM$TYPEOF(
    CAST(
      ARRAY_CONSTRUCT('San Mateo') AS ARRAY(VARCHAR)
    )[0]
  ) AS structured_array_element;

-- Example 18294
+-------------------------------+-----------------------------+
| SEMI_STRUCTURED_ARRAY_ELEMENT | STRUCTURED_ARRAY_ELEMENT    |
|-------------------------------+-----------------------------|
| VARIANT[LOB]                  | VARCHAR(16777216)[LOB]      |
+-------------------------------+-----------------------------+

-- Example 18295
SELECT ARRAY_SIZE([1,2,3]::ARRAY(NUMBER));

-- Example 18296
SELECT MAP_SIZE({'my_key':'my_value'}::MAP(VARCHAR,VARCHAR));

-- Example 18297
SELECT ARRAY_CONTAINS(10, [1, 10, 100]::ARRAY(NUMBER));

-- Example 18298
SELECT ARRAY_POSITION(10, [1, 10, 100]::ARRAY(NUMBER));

-- Example 18299
SELECT MAP_CONTAINS_KEY('key_to_find', my_map);

-- Example 18300
SELECT MAP_CONTAINS_KEY(10, my_map);

-- Example 18301
{'a':2,'b':1}::OBJECT(b INTEGER,a INTEGER)

-- Example 18302
{'a':1,'b':2}::OBJECT(b INTEGER,a INTEGER)

-- Example 18303
SELECT ARRAYS_OVERLAP(numeric_array, other_numeric_array);

-- Example 18304
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), 3::NUMBER );

-- Example 18305
SELECT ARRAY_APPEND( [1,2]::ARRAY(DOUBLE), '3' );

-- Example 18306
SELECT ARRAY_APPEND( [1,2]::ARRAY(NUMBER), '2022-02-02'::DATE );

-- Example 18307
SELECT ARRAY_CAT( [1,2]::ARRAY(NUMBER), ['3','4'] );

-- Example 18308
SELECT ARRAY_CAT( [1,2], ['3','4']::ARRAY(VARCHAR) );

-- Example 18309
SELECT
  ARRAY_CAT(
    [1, 2, 3]::ARRAY(NUMBER NOT NULL),
    [5.5, NULL]::ARRAY(NUMBER(2, 1))
  ) AS concatenated_array,
  SYSTEM$TYPEOF(concatenated_array);

-- Example 18310
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

-- Example 18311
SELECT ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), [2,3]::ARRAY(DOUBLE) );

-- Example 18312
SELECT ARRAY_EXCEPT( [1,2]::ARRAY(NUMBER), ['2','3']::ARRAY(VARCHAR) );

-- Example 18313
SELECT OBJECT_DELETE( {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR), 'zip_code' );

-- Example 18314
093201 (23001): Function OBJECT_DELETE: expected structured object to contain field zip_code but it did not.

-- Example 18315
SELECT
  OBJECT_DELETE(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'city'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 18316
+-----------------+--------------------------------------+
| NEW_OBJECT      | SYSTEM$TYPEOF(NEW_OBJECT)            |
|-----------------+--------------------------------------|
| {               | OBJECT(state VARCHAR(16777216))[LOB] |
|   "state": "CA" |                                      |
| }               |                                      |
+-----------------+--------------------------------------+

-- Example 18317
SELECT
  OBJECT_DELETE(
    {'state':'CA'}::OBJECT(state VARCHAR),
    'state'
  ) AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 18318
+------------+---------------------------+
| NEW_OBJECT | SYSTEM$TYPEOF(NEW_OBJECT) |
|------------+---------------------------|
| {}         | OBJECT()[LOB]             |
+------------+---------------------------+

-- Example 18319
SELECT OBJECT_INSERT(
  {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
  'city',
  'San Jose',
  false
);

-- Example 18320
093202 (23001): Function OBJECT_INSERT:
  expected structured object to not contain field city but it did.

-- Example 18321
SELECT
  OBJECT_INSERT(
    {'city':'San Mateo','state':'CA'}::OBJECT(city VARCHAR,state VARCHAR),
    'zip_code',
    94402::FLOAT,
    false
  ) AS new_object,
  SYSTEM$TYPEOF(new_object) AS type;

-- Example 18322
+-------------------------------------+---------------------------------------------------------------------------------------+
| NEW_OBJECT                          | TYPE                                                                                  |
|-------------------------------------+---------------------------------------------------------------------------------------|
| {                                   | OBJECT(city VARCHAR(16777216), state VARCHAR(16777216), zip_code FLOAT NOT NULL)[LOB] |
|   "city": "San Mateo",              |                                                                                       |
|   "state": "CA",                    |                                                                                       |
|   "zip_code": 9.440200000000000e+04 |                                                                                       |
| }                                   |                                                                                       |
+-------------------------------------+---------------------------------------------------------------------------------------+

-- Example 18323
SELECT
  OBJECT_PICK(
    {'city':'San Mateo','state':'CA','zip_code':94402}::OBJECT(city VARCHAR,state VARCHAR,zip_code DOUBLE),
    'state',
    'city') AS new_object,
  SYSTEM$TYPEOF(new_object);

-- Example 18324
+-----------------------+--------------------------------------------------------------+
| NEW_OBJECT            | SYSTEM$TYPEOF(NEW_OBJECT)                                    |
|-----------------------+--------------------------------------------------------------|
| {                     | OBJECT(state VARCHAR(16777216), city VARCHAR(16777216))[LOB] |
|   "state": "CA",      |                                                              |
|   "city": "San Mateo" |                                                              |
| }                     |                                                              |
+-----------------------+--------------------------------------------------------------+

-- Example 18325
SELECT value, SYSTEM$TYPEOF(value)
  FROM TABLE(FLATTEN(INPUT => [1.08, 2.13, 3.14]::ARRAY(DOUBLE)));

-- Example 18326
+-------+----------------------+
| VALUE | SYSTEM$TYPEOF(VALUE) |
|-------+----------------------|
|  1.08 | FLOAT[DOUBLE]        |
|  2.13 | FLOAT[DOUBLE]        |
|  3.14 | FLOAT[DOUBLE]        |
+-------+----------------------+

-- Example 18327
SELECT key, SYSTEM$TYPEOF(key), value, SYSTEM$TYPEOF(value)
  FROM TABLE(FLATTEN(INPUT => {'my_key': 'my_value'}::MAP(VARCHAR, VARCHAR)));

-- Example 18328
+--------+------------------------+----------+------------------------+
| KEY    | SYSTEM$TYPEOF(KEY)     | VALUE    | SYSTEM$TYPEOF(VALUE)   |
|--------+------------------------+----------+------------------------|
| my_key | VARCHAR(16777216)[LOB] | my_value | VARCHAR(16777216)[LOB] |
+--------+------------------------+----------+------------------------+

-- Example 18329
String result = resultSet.getString(1);

-- Example 18330
CREATE OR REPLACE FUNCTION my_udf(
    location OBJECT(city VARCHAR, zipcode NUMBER, val ARRAY(BOOLEAN)))
  RETURNS VARCHAR
  AS
  $$
    ...
  $$;

-- Example 18331
CREATE OR REPLACE FUNCTION my_udtf(check BOOLEAN)
  RETURNS TABLE(col1 ARRAY(VARCHAR))
  AS
  $$
  ...
  $$;

-- Example 18332
CREATE OR REPLACE PROCEDURE my_procedure(values ARRAY(INTEGER))
  RETURNS ARRAY(INTEGER)
  LANGUAGE SQL
  AS
  $$
    ...
  $$;

-- Example 18333
CREATE OR REPLACE FUNCTION my_function(values ARRAY(INTEGER))
  RETURNS ARRAY(INTEGER)
  LANGUAGE PYTHON
  RUNTIME_VERSION=3.10
  AS
  $$
    ...
  $$;

-- Example 18334
map(VARCHAR(16777216), VARCHAR(16777216))

-- Example 18335
ARRAY(NUMBER(38,0))

