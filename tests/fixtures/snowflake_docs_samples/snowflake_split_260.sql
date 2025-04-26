-- Example 17398
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

-- Example 17399
call samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 17400
call samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 17401
BEGIN
  CALL model!FORECAST(FORECASTING_PERIODS => 7);
  LET x := SQLID;
  CREATE TABLE my_forecasts AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;
SELECT * FROM my_forecasts;

-- Example 17402
CREATE TABLE my_forecasts AS
  SELECT * FROM TABLE(model!forecast(forecasting_periods => 7));

-- Example 17403
BEGIN
  CALL model!FORECAST(FORECASTING_PERIODS => 7);
  LET x := SQLID;
  CREATE TABLE my_forecasts AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;
SELECT * FROM my_forecasts;

-- Example 17404
CREATE TABLE my_forecasts AS
  SELECT * FROM TABLE(model!forecast(forecasting_periods => 7));

-- Example 17405
CALL my_procedure(SYSTEM$REFERENCE('table', my_table));

-- Example 17406
CALL my_procedure(TABLE(my_table));

-- Example 17407
CALL my_procedure(SYSTEM$REFERENCE('table', my_table));

-- Example 17408
CALL my_procedure(TABLE(my_table));

-- Example 17409
CREATE FUNCTION my_udf(
  arg_1 VARCHAR,
  arg_2_optional VARCHAR DEFAULT 'default'
  arg_3_optional INTEGER DEFAULT 0) ...

-- Example 17410
SELECT my_udf(arg_1 => 'value', arg_3_optional => 1);

-- Example 17411
CREATE FUNCTION my_udf(
  arg_1 VARCHAR,
  arg_2_optional VARCHAR DEFAULT 'default'
  arg_3_optional INTEGER DEFAULT 0) ...

-- Example 17412
SELECT my_udf(arg_1 => 'value', arg_3_optional => 1);

-- Example 17413
ALTER TABLE test_table
  ADD SEARCH OPTIMIZATION ON SUBSTRING(variant_col:data.field);

-- Example 17414
ALTER TABLE test_table
  ADD SEARCH OPTIMIZATION ON SUBSTRING(variant_col:data.field);

-- Example 17415
ALTER TABLE my_table ADD COLUMN IF NOT EXISTS total NUMBER;

-- Example 17416
ALTER TABLE my_table DROP COLUMN IF EXISTS total;

-- Example 17417
ALTER TABLE my_table ADD COLUMN IF NOT EXISTS total NUMBER;

-- Example 17418
ALTER TABLE my_table DROP COLUMN IF EXISTS total;

-- Example 17419
SELECT ... , SUM(my_column) AS total, ROUND(total) FROM mytable GROUP BY ALL ... ;

-- Example 17420
Error Code: 000979
  Error Message: SQL compilation error:
    [SUM(MYTABLE.MY_COLUMN)] is not a valid group by expression

-- Example 17421
SELECT ... , SUM(my_column) AS total, ROUND(total) FROM mytable GROUP BY ALL ... ;

-- Example 17422
Error Code: 000979
  Error Message: SQL compilation error:
    [SUM(MYTABLE.MY_COLUMN)] is not a valid group by expression

-- Example 17423
SELECT * ILIKE '<pattern>' ...

-- Example 17424
SELECT * ILIKE '%id%' ...

-- Example 17425
SELECT * REPLACE (<expr> AS <col_name> [ , <expr> AS <col_name> , ... ])

-- Example 17426
SELECT * REPLACE ('DEPT-' || department_id AS department_id) ...

-- Example 17427
-- Set the output format to EWKT
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT
  ST_TRANSFORM(
    ST_GEOMFROMWKT('POINT(389866.35 5819003.03)', 32633),
    3857
  ) AS transformed_geom;

-- Example 17428
+---------------------------------------------------------------+
| transformed_geom                                              |
|---------------------------------------------------------------|
| SRID=3857;POINT(1489140.093765644 6892872.198680112)          |
+---------------------------------------------------------------+

-- Example 17429
SELECT * ILIKE '<pattern>' ...

-- Example 17430
SELECT * ILIKE '%id%' ...

-- Example 17431
SELECT * REPLACE (<expr> AS <col_name> [ , <expr> AS <col_name> , ... ])

-- Example 17432
SELECT * REPLACE ('DEPT-' || department_id AS department_id) ...

-- Example 17433
-- Set the output format to EWKT
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT
  ST_TRANSFORM(
    ST_GEOMFROMWKT('POINT(389866.35 5819003.03)', 32633),
    3857
  ) AS transformed_geom;

-- Example 17434
+---------------------------------------------------------------+
| transformed_geom                                              |
|---------------------------------------------------------------|
| SRID=3857;POINT(1489140.093765644 6892872.198680112)          |
+---------------------------------------------------------------+

-- Example 17435
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column);

-- Example 17436
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column:field);

-- Example 17437
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column:field.nested_field);

-- Example 17438
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column);

-- Example 17439
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column:field);

-- Example 17440
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(semi_structured_column:field.nested_field);

-- Example 17441
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY state, city;

-- Example 17442
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY ALL;

-- Example 17443
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY state, city;

-- Example 17444
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY ALL;

-- Example 17445
CREATE OR REPLACE FUNCTION add_numbers (n1 NUMBER, n2 NUMBER)
  RETURNS NUMBER
  AS 'n1 + n2';

-- Example 17446
SELECT add_numbers(n1 => 10, n2 => 5);

-- Example 17447
SELECT add_numbers(n2 => 5, n1 => 10);

-- Example 17448
CREATE OR REPLACE FUNCTION add_numbers (n1 NUMBER, n2 NUMBER)
  RETURNS NUMBER
  AS 'n1 + n2';

-- Example 17449
SELECT add_numbers(n1 => 10, n2 => 5);

-- Example 17450
SELECT add_numbers(n2 => 5, n1 => 10);

-- Example 17451
https://app.snowflake.com/<orgname>/<account_name>

-- Example 17452
https://app.snowflake.com/<orgname>/<account_name>

-- Example 17453
ALTER <policy_kind> POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

-- Example 17454
ALTER <policy_kind> POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 17455
SELECT TO_GEOMETRY('POINT(1820.12 890.56)', 4326);

-- Example 17456
ALTER <policy_kind> POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

-- Example 17457
ALTER <policy_kind> POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 17458
SELECT TO_GEOMETRY('POINT(1820.12 890.56)', 4326);

-- Example 17459
SELECT ROUND(2.5, 0);

+---------------+
| ROUND(2.5, 0) |
|---------------|
|             3 |
+---------------+

SELECT ROUND(-2.5, 0);

+----------------+
| ROUND(-2.5, 0) |
|----------------|
|             -3 |
+----------------+

-- Example 17460
ROUND( <input_expr> [ , <scale_expr>  [ , <rounding_mode> ] ] )

-- Example 17461
SELECT ROUND(2.5, 0, 'HALF_TO_EVEN');

+-------------------------------+
| ROUND(2.5, 0, 'HALF_TO_EVEN') |
|-------------------------------|
|                             2 |
+-------------------------------+

SELECT ROUND(-2.5, 0, 'HALF_TO_EVEN');

+--------------------------------+
| ROUND(-2.5, 0, 'HALF_TO_EVEN') |
|--------------------------------|
|                             -2 |
+--------------------------------+

-- Example 17462
SELECT ROUND(2.5, 0);

+---------------+
| ROUND(2.5, 0) |
|---------------|
|             3 |
+---------------+

SELECT ROUND(-2.5, 0);

+----------------+
| ROUND(-2.5, 0) |
|----------------|
|             -3 |
+----------------+

-- Example 17463
ROUND( <input_expr> [ , <scale_expr>  [ , <rounding_mode> ] ] )

-- Example 17464
SELECT ROUND(2.5, 0, 'HALF_TO_EVEN');

+-------------------------------+
| ROUND(2.5, 0, 'HALF_TO_EVEN') |
|-------------------------------|
|                             2 |
+-------------------------------+

SELECT ROUND(-2.5, 0, 'HALF_TO_EVEN');

+--------------------------------+
| ROUND(-2.5, 0, 'HALF_TO_EVEN') |
|--------------------------------|
|                             -2 |
+--------------------------------+

