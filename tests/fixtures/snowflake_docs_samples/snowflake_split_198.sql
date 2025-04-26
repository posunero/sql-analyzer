-- Example 13246
ProgrammingError occurred: "000707 (02000): None: Data is not available." with query id None

-- Example 13247
CREATE TABLE t_sales (numeric integer) data_retention_time_in_days=1;

CREATE OR REPLACE TABLE sales.public.t_sales_20170522 CLONE sales.public.t_sales at(offset => -60*30);

-- Example 13248
002003 (02000): SQL compilation error:
Object 'SALES.PUBLIC.T_SALES' does not exist.

-- Example 13249
DROP NOTEBOOK <name>

-- Example 13250
DROP NOTEBOOK mynotebook;

-- Example 13251
UNDROP NOTEBOOK <name>

-- Example 13252
UNDROP NOTEBOOK mynotebook;

-- Example 13253
+--------------------------------------------+
| status                                     |
|--------------------------------------------|
| Notebook mynotebook successfully restored. |
+--------------------------------------------+

-- Example 13254
UNDROP TABLE <name>

-- Example 13255
UNDROP TABLE t2;

-- Example 13256
+---------------------------------+
| status                          |
|---------------------------------|
| Table T2 successfully restored. |
+---------------------------------+

-- Example 13257
SELECT table_id,
  table_name,
  table_schema,
  table_catalog,
  created,
  deleted,
  comment
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES
WHERE table_catalog = 'DB1'
AND table_schema = 'S1'
AND table_name = 'MY_TABLE'
AND deleted IS NOT NULL
ORDER BY deleted;

-- Example 13258
+----------+------------+--------------+---------------+-------------------------------+-------------------------------+---------+
| TABLE_ID | TABLE_NAME | TABLE_SCHEMA | TABLE_CATALOG | CREATED                       | DELETED                       | COMMENT |
|----------+------------+--------------+---------------+-------------------------------+-------------------------------+---------|
|   408578 | MY_TABLE   | S1           | DB1           | 2024-07-01 15:39:07.565 -0700 | 2024-07-01 15:40:28.161 -0700 | NULL    |
+----------+------------+--------------+---------------+-------------------------------+-------------------------------+---------+
|   408607 | MY_TABLE   | S1           | DB1           | 2024-07-01 17:43:07.565 -0700 | 2024-07-01 17:44:28.161 -0700 | NULL    |
+----------+------------+--------------+---------------+-------------------------------+-------------------------------+---------+

-- Example 13259
UNDROP TABLE IDENTIFIER(408578);

-- Example 13260
UNDROP SCHEMA <name>

-- Example 13261
UNDROP SCHEMA myschema;

-- Example 13262
+----------------------------------------+
| status                                 |
|----------------------------------------|
| Schema MYSCHEMA successfully restored. |
+----------------------------------------+

-- Example 13263
SHOW SCHEMAS HISTORY;

-- Example 13264
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+------------+
| created_on                      | name               | is_default | is_current | database_name | owner  | comment                                                   | options | retention_time | dropped_on |
|---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+------------|
| Fri, 13 May 2016 17:26:07 -0700 | INFORMATION_SCHEMA | N          | N          | MYTESTDB      |        | Views describing the contents of schemas in this database |         |              1 | [NULL]     |
| Tue, 17 Mar 2015 17:18:42 -0700 | MYSCHEMA           | N          | N          | MYTESTDB      | PUBLIC |                                                           |         |              1 | [NULL]     |
| Tue, 17 Mar 2015 16:57:04 -0700 | PUBLIC             | N          | Y          | MYTESTDB      | PUBLIC |                                                           |         |              1 | [NULL]     |
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+------------+

-- Example 13265
SELECT schema_id,
  schema_name,
  catalog_name,
  created,
  deleted,
  comment
FROM SNOWFLAKE.ACCOUNT_USAGE.SCHEMATA
WHERE schema_name = 'S1'
AND catalog_name = 'DB1'
AND deleted IS NOT NULL
ORDER BY deleted;

-- Example 13266
+-----------+-------------+---------------+-------------------------------+-------------------------------+---------+
| SCHEMA_ID | SCHEMA_NAME | CATALOG_NAME  | CREATED                       | DELETED                       | COMMENT |
|-----------+-------------+---------------+-------------------------------+-------------------------------+---------|
|       797 | S1          | DB1           | 2024-07-01 17:53:01.955 -0700 | 2024-07-01 17:53:11.889 -0700 | NULL    |
|       798 | S1          | DB1           | 2024-07-01 17:53:11.889 -0700 | 2024-07-01 17:53:16.327 -0700 | NULL    |
|       799 | S1          | DB1           | 2024-07-01 17:53:16.327 -0700 | 2024-07-01 17:53:25.066 -0700 | NULL    |
+-----------+-------------+---------------+-------------------------------+-------------------------------+---------+

-- Example 13267
UNDROP SCHEMA IDENTIFIER(798);

-- Example 13268
UNDROP DATABASE <name>

-- Example 13269
UNDROP DATABASE mytestdb2;

-- Example 13270
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| Database MYTESTDB2 successfully restored. |
+-------------------------------------------+

-- Example 13271
SHOW DATABASES HISTORY;

-- Example 13272
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+------------+
| created_on                      | name      | is_default | is_current | origin | owner  | comment | options | retention_time | dropped_on |
|---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+------------|
| Tue, 17 Mar 2015 16:57:04 -0700 | MYTESTDB  | N          | Y          |        | PUBLIC |         |         |              1 | [NULL]     |
| Tue, 17 Mar 2015 17:06:32 -0700 | MYTESTDB2 | N          | N          |        | PUBLIC |         |         |              1 | [NULL]     |
| Wed, 25 Feb 2015 17:30:04 -0800 | SALES1    | N          | N          |        | PUBLIC |         |         |              1 | [NULL]     |
| Fri, 13 Feb 2015 19:21:49 -0800 | DEMO1     | N          | N          |        | PUBLIC |         |         |              1 | [NULL]     |
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+------------+

-- Example 13273
SELECT database_id,
  database_name,
  created,
  deleted,
  comment
FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES
WHERE database_name = 'MY_DATABASE'
AND deleted IS NOT NULL
ORDER BY deleted;

-- Example 13274
+-------------+---------------+-------------------------------+-------------------------------+---------+
| DATABASE_ID | DATABASE_NAME | CREATED                       | DELETED                       | COMMENT |
|-------------+---------------+-------------------------------+-------------------------------+---------|
|         494 | MY_DATABASE   | 2024-07-01 17:51:33.380 -0700 | 2024-07-01 17:51:46.228 -0700 | NULL    |
|         492 | MY_DATABASE   | 2024-07-01 17:51:52.560 -0700 | 2024-07-01 17:52:39.881 -0700 | NULL    |
|         493 | MY_DATABASE   | 2024-07-01 17:52:39.849 -0700 | 2024-07-01 17:52:44.562 -0700 | NULL    |
+-------------+---------------+-------------------------------+-------------------------------+---------+

-- Example 13275
UNDROP DATABASE IDENTIFIER(492);

-- Example 13276
UNDROP ICEBERG TABLE <name>

-- Example 13277
UNDROP ICEBERG TABLE my_iceberg_table;

-- Example 13278
UNDROP DYNAMIC TABLE <name>

-- Example 13279
UNDROP DYNAMIC TABLE product;

-- Example 13280
UNDROP EXTERNAL VOLUME <name>

-- Example 13281
UNDROP EXTERNAL VOLUME my_external_volume;

-- Example 13282
UNDROP ACCOUNT <name>

-- Example 13283
UNDROP ACCOUNT myaccount123;

-- Example 13284
CREATE OR ALTER execution failed. Partial updates may have been applied.

-- Example 13285
--!jinja

-- Example 13286
#!jinja

-- Example 13287
{% include "@my_stage/path/to/my_template" %}
{% import "@my_stage/path/to/my_template" as my_template %}
{% extends "@my_stage/path/to/my_template" %}
{{ SnowflakeFile.open("@my_stage/path/to/my_template", 'r', require_scoped_url = False).read() }}

-- Example 13288
{% include "my_template" %}
{% import "../my_template" as my_template %}
{% extends "/path/to/my_template" %}

-- Example 13289
EXECUTE IMMEDIATE
  FROM { absoluteFilePath | relativeFilePath }
  [ USING ( <key> => <value> [ , <key> => <value> [ , ... ] ]  )  ]
  [ DRY_RUN = { TRUE | FALSE } ]

-- Example 13290
absoluteFilePath ::=
   @[ <namespace>. ]<stage_name>/<path>/<filename>

-- Example 13291
relativeFilePath ::=
  '[ / | ./ | ../ ]<path>/<filename>'

-- Example 13292
PUT file://~/sql/scripts/my_file.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 13293
001501 (02000): File '<directory_name>' not found in stage '<stage_name>'.

-- Example 13294
001503 (42601): Relative file references like '<filename.sql>' cannot be used in top-level EXECUTE IMMEDIATE calls.

-- Example 13295
001003 (42000): SQL compilation error: syntax error line <n> at position <m> unexpected '<string>'.

-- Example 13296
002003 (02000): SQL compilation error: Stage '<stage_name>' does not exist or not authorized.

-- Example 13297
003001 (42501): Uncaught exception of type 'STATEMENT_ERROR' in file <file_name> on line <n> at position <m>:
SQL access control error: Insufficient privileges to operate on schema '<schema_name>'

-- Example 13298
001003 (42000): SQL compilation error:
syntax error line [n] at position [m] unexpected '{'.

-- Example 13299
000005 (XX000): Python Interpreter Error:
jinja2.exceptions.UndefinedError: '<key>' is undefined
in template processing

-- Example 13300
001510 (42601): Unable to use value of template variable '<key>'

-- Example 13301
001518 (42601): Size of expanded template exceeds limit of 100,000 bytes.

-- Example 13302
CREATE OR REPLACE TABLE my_inventory(
  sku VARCHAR,
  price NUMBER
);

EXECUTE IMMEDIATE FROM './insert-inventory.sql';

SELECT sku, price
  FROM my_inventory
  ORDER BY price DESC;

-- Example 13303
INSERT INTO my_inventory
  VALUES ('XYZ12345', 10.00),
         ('XYZ81974', 50.00),
         ('XYZ34985', 30.00),
         ('XYZ15324', 15.00);

-- Example 13304
CREATE STAGE my_stage;

-- Example 13305
PUT file://~/sql/scripts/create-inventory.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

PUT file://~/sql/scripts/insert-inventory.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 13306
EXECUTE IMMEDIATE FROM @my_stage/scripts/create-inventory.sql;

-- Example 13307
+----------+-------+
| SKU      | PRICE |
|----------+-------|
| XYZ81974 |    50 |
| XYZ34985 |    30 |
| XYZ15324 |    15 |
| XYZ12345 |    10 |
+----------+-------+

-- Example 13308
--!jinja

CREATE SCHEMA {{env}};

CREATE TABLE RAW (COL OBJECT)
    DATA_RETENTION_TIME_IN_DAYS = {{retention_time}};

-- Example 13309
CREATE STAGE my_stage;

-- Example 13310
PUT file://path/to/setup.sql @my_stage/scripts/
  AUTO_COMPRESS=FALSE;

-- Example 13311
EXECUTE IMMEDIATE FROM @my_stage/scripts/setup.sql
    USING (env=>'dev', retention_time=>0);

-- Example 13312
{%- macro get_environments(deployment_type) -%}
  {%- if deployment_type == 'prod' -%}
    {{ "prod1,prod2" }}
  {%- else -%}
    {{ "dev,qa,staging" }}
  {%- endif -%}
{%- endmacro -%}

