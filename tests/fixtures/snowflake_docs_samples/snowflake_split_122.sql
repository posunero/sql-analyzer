-- Example 8155
{
    "root": [
        {
            "employees": [
                {
                    "firstName": "Anna",
                    "lastName": "Smith"
                },
                {
                    "firstName": "Peter",
                    "lastName": "Jones"
                }
            ]
        }
    ]
}

-- Example 8156
SELECT 'The First Employee Record is '||
    S.$1:root[0].employees[0].firstName||
    ' '||S.$1:root[0].employees[0].lastName
FROM @%customers/contacts.json.gz (file_format => 'my_json_format') as S;

+----------------------------------------------+
| 'THE FIRST EMPLOYEE RECORD IS '||            |
|      S.$1:ROOT[0].EMPLOYEES[0].FIRSTNAME||   |
|      ' '||S.$1:ROOT[0].EMPLOYEES[0].LASTNAME |
|----------------------------------------------|
| The First Employee Record is Anna Smith      |
+----------------------------------------------+

-- Example 8157
a -> a * 2

-- Example 8158
a -> a:value > 50

-- Example 8159
a -> a || ' some string'

-- Example 8160
(x INT, y INT) -> (x + y)

-- Example 8161
a -> UPPER(a)

-- Example 8162
a -> a + (SELECT MAX(c1) FROM mytable)

-- Example 8163
a -> mysqlfunction(5)

-- Example 8164
SHOW SERVICE CONTAINERS IN SERVICE <name>

-- Example 8165
SHOW SERVICE CONTAINERS IN SERVICE echo_service;

-- Example 8166
+---------------+-------------+--------------+-------------+----------------+--------+---------+---------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+----------------------+----------------+-------------------+
| database_name | schema_name | service_name | instance_id | container_name | status | message | image_name                                                                                                                | image_digest                                                            | restart_count | start_time           | last_exit_code | last_restart_time |
|---------------+-------------+--------------+-------------+----------------+--------+---------+---------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+----------------------+----------------+-------------------|
| TUTORIAL_DB   | DATA_SCHEMA | ECHO_SERVICE | 0           | echo           | READY  | Running | orgname-acctname.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest | sha256:d04a2d7b7d9bd607df994926e3cc672edcb541474e4888a01703e8bb0dd3f173 |             0 | 2024-12-13T07:30:25Z |           NULL | NULL              |
+---------------+-------------+--------------+-------------+----------------+--------+---------+---------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+----------------------+----------------+-------------------+

-- Example 8167
SHOW IMAGES IN IMAGE REPOSITORY <name>

-- Example 8168
SHOW IMAGES IN IMAGE REPOSITORY tutorial_db.data_schema.tutorial_repository;

-- Example 8169
+-------------------------------+-----------------------+--------+-------------------------------------------------------------------------+--------------------------------------------------------------------------+
| created_on                    | image_name            | tags   | digest                                                                  | image_path                                                               |
|-------------------------------+-----------------------+--------+-------------------------------------------------------------------------+--------------------------------------------------------------------------|
| 2024-04-18 13:51:35.000 -0700 | my_echo_service_image | latest | sha256:70421668b2635b2996c6d5bc80627cf6d98c0716948b5f60d198d6411d4b4681 | tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest |
+-------------------------------+-----------------------+--------+-------------------------------------------------------------------------+--------------------------------------------------------------------------+

-- Example 8170
SELECT ...
FROM objectReference [ JOIN objectReference [ ... ] ]
[ ... ]

-- Example 8171
objectReference ::=
   {
      [<namespace>.]<object_name>
           [ AT | BEFORE ( <object_state> ) ]
           [ CHANGES ( <change_tracking_type> ) ]
           [ MATCH_RECOGNIZE ]
           [ PIVOT | UNPIVOT ]
           [ [ AS ] <alias_name> ]
           [ SAMPLE ]
     | <table_function>
           [ PIVOT | UNPIVOT ]
           [ [ AS ] <alias_name> ]
           [ SAMPLE ]
     | ( VALUES (...) )
           [ SAMPLE ]
     | [ LATERAL ] ( <subquery> )
           [ [ AS ] <alias_name> ]
     | @[<namespace>.]<stage_name>[/<path>]
           [ ( FILE_FORMAT => <format_name>, PATTERN => '<regex_pattern>' ) ]
           [ [AS] <alias_name> ]
     | DIRECTORY( @<stage_name> )
   }

-- Example 8172
CREATE TABLE ftable1 (retail_price FLOAT, wholesale_cost FLOAT, description VARCHAR);
INSERT INTO ftable1 (retail_price, wholesale_cost, description) 
  VALUES (14.00, 6.00, 'bling');

-- Example 8173
SELECT description, retail_price, wholesale_cost 
    FROM ftable1;
+-------------+--------------+----------------+
| DESCRIPTION | RETAIL_PRICE | WHOLESALE_COST |
|-------------+--------------+----------------|
| bling       |           14 |              6 |
+-------------+--------------+----------------+

-- Example 8174
SELECT description, retail_price, wholesale_cost 
    FROM temporary_doc_test.ftable1;
+-------------+--------------+----------------+
| DESCRIPTION | RETAIL_PRICE | WHOLESALE_COST |
|-------------+--------------+----------------|
| bling       |           14 |              6 |
+-------------+--------------+----------------+

-- Example 8175
SELECT v.profit 
    FROM (SELECT retail_price - wholesale_cost AS profit FROM ftable1) AS v;
+--------+
| PROFIT |
|--------|
|      8 |
+--------+

-- Example 8176
SELECT *
    FROM sales SAMPLE(10);

-- Example 8177
SELECT *
    FROM TABLE(Fibonacci_Sequence_UDTF(6.0::FLOAT));

-- Example 8178
SELECT *
    FROM sales AT(OFFSET => -86400);
SELECT *
    FROM sales AT(TIMESTAMP => '2018-07-27 12:00:00'::TIMESTAMP);

-- Example 8179
SELECT
    v.$1, v.$2, ...
  FROM
    @my_stage( FILE_FORMAT => 'csv_format', PATTERN => '.*my_pattern.*') v;

-- Example 8180
SELECT * FROM DIRECTORY(@mystage);

-- Example 8181
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE SIZE > 100000;

-- Example 8182
SELECT FILE_URL FROM DIRECTORY(@mystage) WHERE RELATIVE_PATH LIKE '%.csv';

-- Example 8183
CREATE OR REPLACE TABLE car_sales
( 
  src variant
)
AS
SELECT PARSE_JSON(column1) AS src
FROM VALUES
('{ 
    "date" : "2017-04-28", 
    "dealership" : "Valley View Auto Sales",
    "salesperson" : {
      "id": "55",
      "name": "Frank Beasley"
    },
    "customer" : [
      {"name": "Joyce Ridgely", "phone": "16504378889", "address": "San Francisco, CA"}
    ],
    "vehicle" : [
      {"make": "Honda", "model": "Civic", "year": "2017", "price": "20275", "extras":["ext warranty", "paint protection"]}
    ]
}'),
('{ 
    "date" : "2017-04-28", 
    "dealership" : "Tindel Toyota",
    "salesperson" : {
      "id": "274",
      "name": "Greg Northrup"
    },
    "customer" : [
      {"name": "Bradley Greenbloom", "phone": "12127593751", "address": "New York, NY"}
    ],
    "vehicle" : [
      {"make": "Toyota", "model": "Camry", "year": "2017", "price": "23500", "extras":["ext warranty", "rust proofing", "fabric protection"]}  
    ]
}') v;

-- Example 8184
SELECT * FROM car_sales;
+-------------------------------------------+
| SRC                                       |
|-------------------------------------------|
| {                                         |
|   "customer": [                           |
|     {                                     |
|       "address": "San Francisco, CA",     |
|       "name": "Joyce Ridgely",            |
|       "phone": "16504378889"              |
|     }                                     |
|   ],                                      |
|   "date": "2017-04-28",                   |
|   "dealership": "Valley View Auto Sales", |
|   "salesperson": {                        |
|     "id": "55",                           |
|     "name": "Frank Beasley"               |
|   },                                      |
|   "vehicle": [                            |
|     {                                     |
|       "extras": [                         |
|         "ext warranty",                   |
|         "paint protection"                |
|       ],                                  |
|       "make": "Honda",                    |
|       "model": "Civic",                   |
|       "price": "20275",                   |
|       "year": "2017"                      |
|     }                                     |
|   ]                                       |
| }                                         |
| {                                         |
|   "customer": [                           |
|     {                                     |
|       "address": "New York, NY",          |
|       "name": "Bradley Greenbloom",       |
|       "phone": "12127593751"              |
|     }                                     |
|   ],                                      |
|   "date": "2017-04-28",                   |
|   "dealership": "Tindel Toyota",          |
|   "salesperson": {                        |
|     "id": "274",                          |
|     "name": "Greg Northrup"               |
|   },                                      |
|   "vehicle": [                            |
|     {                                     |
|       "extras": [                         |
|         "ext warranty",                   |
|         "rust proofing",                  |
|         "fabric protection"               |
|       ],                                  |
|       "make": "Toyota",                   |
|       "model": "Camry",                   |
|       "price": "23500",                   |
|       "year": "2017"                      |
|     }                                     |
|   ]                                       |
| }                                         |
+-------------------------------------------+

-- Example 8185
SELECT src:dealership
    FROM car_sales
    ORDER BY 1;
+--------------------------+
| SRC:DEALERSHIP           |
|--------------------------|
| "Tindel Toyota"          |
| "Valley View Auto Sales" |
+--------------------------+

-- Example 8186
-- This contains a blank.
SELECT src:"company name" FROM partners;

-- This does not start with a letter or underscore.
SELECT zipcode_info:"94987" FROM addresses;

-- This contains characters that are not letters, digits, or underscores, and
-- it does not start with a letter or underscore.
SELECT measurements:"#sPerSquareInch" FROM english_metrics;

-- Example 8187
SELECT src:salesperson.name
    FROM car_sales
    ORDER BY 1;
+----------------------+
| SRC:SALESPERSON.NAME |
|----------------------|
| "Frank Beasley"      |
| "Greg Northrup"      |
+----------------------+

-- Example 8188
SELECT src['salesperson']['name']
    FROM car_sales
    ORDER BY 1;
+----------------------------+
| SRC['SALESPERSON']['NAME'] |
|----------------------------|
| "Frank Beasley"            |
| "Greg Northrup"            |
+----------------------------+

-- Example 8189
SELECT src:customer[0].name, src:vehicle[0]
    FROM car_sales
    ORDER BY 1;
+----------------------+-------------------------+
| SRC:CUSTOMER[0].NAME | SRC:VEHICLE[0]          |
|----------------------+-------------------------|
| "Bradley Greenbloom" | {                       |
|                      |   "extras": [           |
|                      |     "ext warranty",     |
|                      |     "rust proofing",    |
|                      |     "fabric protection" |
|                      |   ],                    |
|                      |   "make": "Toyota",     |
|                      |   "model": "Camry",     |
|                      |   "price": "23500",     |
|                      |   "year": "2017"        |
|                      | }                       |
| "Joyce Ridgely"      | {                       |
|                      |   "extras": [           |
|                      |     "ext warranty",     |
|                      |     "paint protection"  |
|                      |   ],                    |
|                      |   "make": "Honda",      |
|                      |   "model": "Civic",     |
|                      |   "price": "20275",     |
|                      |   "year": "2017"        |
|                      | }                       |
+----------------------+-------------------------+

-- Example 8190
SELECT src:customer[0].name, src:vehicle[0].price
    FROM car_sales
    ORDER BY 1;
+----------------------+----------------------+
| SRC:CUSTOMER[0].NAME | SRC:VEHICLE[0].PRICE |
|----------------------+----------------------|
| "Bradley Greenbloom" | "23500"              |
| "Joyce Ridgely"      | "20275"              |
+----------------------+----------------------+

-- Example 8191
SELECT src:vehicle[0].price::NUMBER * 0.10 AS tax
    FROM car_sales
    ORDER BY tax;
+--------+
|    TAX |
|--------|
| 2027.5 |
| 2350.0 |
+--------+

-- Example 8192
SELECT src:dealership, src:dealership::VARCHAR
    FROM car_sales
    ORDER BY 2;
+--------------------------+-------------------------+
| SRC:DEALERSHIP           | SRC:DEALERSHIP::VARCHAR |
|--------------------------+-------------------------|
| "Tindel Toyota"          | Tindel Toyota           |
| "Valley View Auto Sales" | Valley View Auto Sales  |
+--------------------------+-------------------------+

-- Example 8193
CREATE TABLE pets (v variant);

INSERT INTO pets SELECT PARSE_JSON ('{"species":"dog", "name":"Fido", "is_dog":"true"} ');
INSERT INTO pets SELECT PARSE_JSON ('{"species":"cat", "name":"Bubby", "is_dog":"false"}');
INSERT INTO pets SELECT PARSE_JSON ('{"species":"cat", "name":"dog terror", "is_dog":"false"}');

SELECT a.v, b.key, b.value FROM pets a,LATERAL FLATTEN(input => a.v) b
WHERE b.value LIKE '%dog%';

+-------------------------+---------+--------------+
| V                       | KEY     | VALUE        |
|-------------------------+---------+--------------|
| {                       | species | "dog"        |
|   "is_dog": "true",     |         |              |
|   "name": "Fido",       |         |              |
|   "species": "dog"      |         |              |
| }                       |         |              |
| {                       | name    | "dog terror" |
|   "is_dog": "false",    |         |              |
|   "name": "dog terror", |         |              |
|   "species": "cat"      |         |              |
| }                       |         |              |
+-------------------------+---------+--------------+

-- Example 8194
SELECT REGEXP_REPLACE(f.path, '\\[[0-9]+\\]', '[]') AS "Path",
  TYPEOF(f.value) AS "Type",
  COUNT(*) AS "Count"
FROM <table>,
LATERAL FLATTEN(<variant_column>, RECURSIVE=>true) f
GROUP BY 1, 2 ORDER BY 1, 2;

-- Example 8195
{"a": 1, "b": 2, "special" : "data"}   <--- row 1 of VARIANT column
{"c": 3, "d": 4, "normal" : "data"}    <----row 2 of VARIANT column

Output from query:

+---------+---------+-------+
| Path    | Type    | Count |
|---------+---------+-------|
| a       | INTEGER |     1 |
| b       | INTEGER |     1 |
| c       | INTEGER |     1 |
| d       | INTEGER |     1 |
| normal  | VARCHAR |     1 |
| special | VARCHAR |     1 |
+---------+---------+-------+

-- Example 8196
SELECT
  t.<variant_column>,
  f.seq,
  f.key,
  f.path,
  REGEXP_COUNT(f.path,'\\.|\\[') +1 AS Level,
  TYPEOF(f.value) AS "Type",
  f.index,
  f.value AS "Current Level Value",
  f.this AS "Above Level Value"
FROM <table> t,
LATERAL FLATTEN(t.<variant_column>, recursive=>true) f;

-- Example 8197
SELECT
  t.<variant_column>,
  f.seq,
  f.key,
  f.path,
  REGEXP_COUNT(f.path,'\\.|\\[') +1 AS Level,
  TYPEOF(f.value) AS "Type",
  f.value AS "Current Level Value",
  f.this AS "Above Level Value"
FROM <table> t,
LATERAL FLATTEN(t.<variant_column>, recursive=>true) f
WHERE "Type" NOT IN ('OBJECT','ARRAY');

-- Example 8198
SELECT
  value:name::string as "Customer Name",
  value:address::string as "Address"
  FROM
    car_sales
  , LATERAL FLATTEN(INPUT => SRC:customer);

+--------------------+-------------------+
| Customer Name      | Address           |
|--------------------+-------------------|
| Joyce Ridgely      | San Francisco, CA |
| Bradley Greenbloom | New York, NY      |
+--------------------+-------------------+

-- Example 8199
"vehicle" : [
     {"make": "Honda", "model": "Civic", "year": "2017", "price": "20275", "extras":["ext warranty", "paint protection"]}
   ]

-- Example 8200
SELECT
  vm.value:make::string as make,
  vm.value:model::string as model,
  ve.value::string as "Extras Purchased"
  FROM
    car_sales
    , LATERAL FLATTEN(INPUT => SRC:vehicle) vm
    , LATERAL FLATTEN(INPUT => vm.value:extras) ve
  ORDER BY make, model, "Extras Purchased";
+--------+-------+-------------------+
| MAKE   | MODEL | Extras Purchased  |
|--------+-------+-------------------|
| Honda  | Civic | ext warranty      |
| Honda  | Civic | paint protection  |
| Toyota | Camry | ext warranty      |
| Toyota | Camry | fabric protection |
| Toyota | Camry | rust proofing     |
+--------+-------+-------------------+

-- Example 8201
CREATE OR replace TABLE colors (v variant);

INSERT INTO
   colors
   SELECT
      parse_json(column1) AS v
   FROM
   VALUES
     ('[{r:255,g:12,b:0},{r:0,g:255,b:0},{r:0,g:0,b:255}]'),
     ('[{c:0,m:1,y:1,k:0},{c:1,m:0,y:1,k:0},{c:1,m:1,y:0,k:0}]')
    v;

SELECT *, GET(v, ARRAY_SIZE(v)-1) FROM colors;

+---------------+-------------------------+
| V             | GET(V, ARRAY_SIZE(V)-1) |
|---------------+-------------------------|
| [             | {                       |
|   {           |   "b": 255,             |
|     "b": 0,   |   "g": 0,               |
|     "g": 12,  |   "r": 0                |
|     "r": 255  | }                       |
|   },          |                         |
|   {           |                         |
|     "b": 0,   |                         |
|     "g": 255, |                         |
|     "r": 0    |                         |
|   },          |                         |
|   {           |                         |
|     "b": 255, |                         |
|     "g": 0,   |                         |
|     "r": 0    |                         |
|   }           |                         |
| ]             |                         |
| [             | {                       |
|   {           |   "c": 1,               |
|     "c": 0,   |   "k": 0,               |
|     "k": 0,   |   "m": 1,               |
|     "m": 1,   |   "y": 0                |
|     "y": 1    | }                       |
|   },          |                         |
|   {           |                         |
|     "c": 1,   |                         |
|     "k": 0,   |                         |
|     "m": 0,   |                         |
|     "y": 1    |                         |
|   },          |                         |
|   {           |                         |
|     "c": 1,   |                         |
|     "k": 0,   |                         |
|     "m": 1,   |                         |
|     "y": 0    |                         |
|   }           |                         |
| ]             |                         |
+---------------+-------------------------+

-- Example 8202
SELECT GET_PATH(src, 'vehicle[0]:make') FROM car_sales;

+----------------------------------+
| GET_PATH(SRC, 'VEHICLE[0]:MAKE') |
|----------------------------------|
| "Honda"                          |
| "Toyota"                         |
+----------------------------------+

-- Example 8203
SELECT GET_PATH(src, 'vehicle[0].make') FROM car_sales;

SELECT src:vehicle[0].make FROM car_sales;

-- Example 8204
{
    "root": [
        {
            "employees": [
                {
                    "firstName": "Anna",
                    "lastName": "Smith"
                },
                {
                    "firstName": "Peter",
                    "lastName": "Jones"
                }
            ]
        }
    ]
}

-- Example 8205
SELECT 'The First Employee Record is '||
    S.$1:root[0].employees[0].firstName||
    ' '||S.$1:root[0].employees[0].lastName
FROM @%customers/contacts.json.gz (file_format => 'my_json_format') as S;

+----------------------------------------------+
| 'THE FIRST EMPLOYEE RECORD IS '||            |
|      S.$1:ROOT[0].EMPLOYEES[0].FIRSTNAME||   |
|      ' '||S.$1:ROOT[0].EMPLOYEES[0].LASTNAME |
|----------------------------------------------|
| The First Employee Record is Anna Smith      |
+----------------------------------------------+

-- Example 8206
a -> a * 2

-- Example 8207
a -> a:value > 50

-- Example 8208
a -> a || ' some string'

-- Example 8209
(x INT, y INT) -> (x + y)

-- Example 8210
a -> UPPER(a)

-- Example 8211
a -> a + (SELECT MAX(c1) FROM mytable)

-- Example 8212
a -> mysqlfunction(5)

-- Example 8213
USE ROLE ACCOUNTADMIN;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE SYSADMIN;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE customrole1;

-- Example 8214
USE ROLE customrole1;

SELECT database_name, database_owner FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES;

-- Example 8215
ALTER SESSION SET TIMEZONE = UTC;

-- Example 8216
USE ROLE ACCOUNTADMIN;

USE SCHEMA snowflake.account_usage;

-- Example 8217
select user_name,
       count(*) as failed_logins,
       avg(seconds_between_login_attempts) as average_seconds_between_login_attempts
from (
      select user_name,
             timediff(seconds, event_timestamp, lead(event_timestamp)
                 over(partition by user_name order by event_timestamp)) as seconds_between_login_attempts
      from login_history
      where event_timestamp > date_trunc(month, current_date)
      and is_success = 'NO'
     )
group by 1
order by 3;

-- Example 8218
select user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1
order by 4 desc;

-- Example 8219
select reported_client_type,
       user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1,2
order by 5 desc;

-- Example 8220
WITH
params AS (
SELECT
    CURRENT_WAREHOUSE() AS warehouse_name,
    '2021-11-01' AS time_from,
    '2021-11-02' AS time_to
),

jobs AS (
SELECT
    query_id,
    time_slice(start_time::timestamp_ntz, 15, 'minute','start') as interval_start,
    qh.warehouse_name,
    database_name,
    query_type,
    total_elapsed_time,
    compilation_time AS compilation_and_scheduling_time,
    (queued_provisioning_time + queued_repair_time + queued_overload_time) AS queued_time,
    transaction_blocked_time,
    execution_time
FROM snowflake.account_usage.query_history qh, params
WHERE
    qh.warehouse_name = params.warehouse_name
AND start_time >= params.time_from
AND start_time <= params.time_to
AND execution_status = 'SUCCESS'
AND query_type IN ('SELECT','UPDATE','INSERT','MERGE','DELETE')
),

interval_stats AS (
SELECT
    query_type,
    interval_start,
    COUNT(DISTINCT query_id) AS numjobs,
    MEDIAN(total_elapsed_time)/1000 AS p50_total_duration,
    (percentile_cont(0.95) within group (order by total_elapsed_time))/1000 AS p95_total_duration,
    SUM(total_elapsed_time)/1000 AS sum_total_duration,
    SUM(compilation_and_scheduling_time)/1000 AS sum_compilation_and_scheduling_time,
    SUM(queued_time)/1000 AS sum_queued_time,
    SUM(transaction_blocked_time)/1000 AS sum_transaction_blocked_time,
    SUM(execution_time)/1000 AS sum_execution_time,
    ROUND(sum_compilation_and_scheduling_time/sum_total_duration,2) AS compilation_and_scheduling_ratio,
    ROUND(sum_queued_time/sum_total_duration,2) AS queued_ratio,
    ROUND(sum_transaction_blocked_time/sum_total_duration,2) AS blocked_ratio,
    ROUND(sum_execution_time/sum_total_duration,2) AS execution_ratio,
    ROUND(sum_total_duration/numjobs,2) AS total_duration_perjob,
    ROUND(sum_compilation_and_scheduling_time/numjobs,2) AS compilation_and_scheduling_perjob,
    ROUND(sum_queued_time/numjobs,2) AS queued_perjob,
    ROUND(sum_transaction_blocked_time/numjobs,2) AS blocked_perjob,
    ROUND(sum_execution_time/numjobs,2) AS execution_perjob
FROM jobs
GROUP BY 1,2
ORDER BY 1,2
)
SELECT * FROM interval_stats;

-- Example 8221
select warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

