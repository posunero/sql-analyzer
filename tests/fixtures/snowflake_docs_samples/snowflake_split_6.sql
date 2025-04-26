-- Example 341
+---+-----------------+
| k | regr_sxx(v, v2) |
|---+-----------------|
| 1 | [NULL]          |
| 2 | 288.666666667   |
+---+-----------------+

-- Example 342
REGR_SXY(y, x)

-- Example 343
REGR_SXY(y, x) OVER ( [ PARTITION BY <expr3> ] )

-- Example 344
CREATE OR REPLACE TABLE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, REGR_SXY(v, v2) FROM aggr GROUP BY k;

-- Example 345
+---+-----------------+
| k | regr_sxy(v, v2) |
+---+-----------------+
| 1 | [NULL]          |
| 2 | 240             |
+---+-----------------+

-- Example 346
REGR_SYY(y, x)

-- Example 347
REGR_SYY(y, x) ( [ PARTITION BY <expr3> ] )

-- Example 348
CREATE OR REPLACE TABLEE aggr(k INT, v DECIMAL(10,2), v2 DECIMAL(10, 2));
INSERT INTO aggr VALUES(1, 10, null);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, null), (2, 30, 35);

SELECT k, REGR_SYY(v, v2) FROM aggr GROUP BY k;

-- Example 349
+---+-----------------+
| k | regr_syy(v, v2) |
|---+-----------------|
| 1 | [NULL]          |
| 2 | 200             |
+---+-----------------+

-- Example 350
KURTOSIS( <expr> )

-- Example 351
KURTOSIS( <expr> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 352
create or replace table aggr(k int, v decimal(10,2), v2 decimal(10, 2));

insert into aggr values
    (1, 10, null),
    (2, 10, 12),
    (2, 20, 22),
    (2, 25, null),
    (2, 30, 35);

-- Example 353
select *
    from aggr
    order by k, v;
+---+-------+-------+
| K |     V |    V2 |
|---+-------+-------|
| 1 | 10.00 |  NULL |
| 2 | 10.00 | 12.00 |
| 2 | 20.00 | 22.00 |
| 2 | 25.00 |  NULL |
| 2 | 30.00 | 35.00 |
+---+-------+-------+

-- Example 354
select KURTOSIS(K), KURTOSIS(V), KURTOSIS(V2) 
    from aggr;
+----------------+-----------------+--------------+
|    KURTOSIS(K) |     KURTOSIS(V) | KURTOSIS(V2) |
|----------------+-----------------+--------------|
| 5.000000000000 | -2.324218750000 |         NULL |
+----------------+-----------------+--------------+

-- Example 355
SKEW( <expr> )

-- Example 356
create or replace table aggr(k int, v decimal(10,2), v2 decimal(10, 2));

insert into aggr values
    (1, 10, null),
    (2, 10, null),
    (2, 20, 22),
    (2, 25, null),
    (2, 30, 35);

-- Example 357
select * 
    from aggr
    order by k, v;
+---+-------+-------+
| K |     V |    V2 |
|---+-------+-------|
| 1 | 10.00 |  NULL |
| 2 | 10.00 |  NULL |
| 2 | 20.00 | 22.00 |
| 2 | 25.00 |  NULL |
| 2 | 30.00 | 35.00 |
+---+-------+-------+

-- Example 358
select SKEW(K), SKEW(V), SKEW(V2) 
    from aggr;
+--------------+---------------+----------+
|      SKEW(K) |       SKEW(V) | SKEW(V2) |
|--------------+---------------+----------|
| -2.236069766 | 0.05240788515 |     NULL |
+--------------+---------------+----------+

-- Example 359
ARRAY_UNION_AGG( <column> )

-- Example 360
CREATE TABLE union_test(a array);

INSERT INTO union_test
    SELECT PARSE_JSON('[ 1, 1, 2]')
    UNION ALL
    SELECT PARSE_JSON('[ 1, 2, 3]');

SELECT ARRAY_UNION_AGG(a) FROM union_test;
+-------------------------+
| ARRAY_UNION_AGG(A)      |
+-------------------------+
| [ 1, 1, 2, 3]           |
+-------------------------+

-- Example 361
ARRAY_UNIQUE_AGG( <column> )

-- Example 362
BITMAP_BIT_POSITION( <numeric_expr> )

-- Example 363
BITMAP_BUCKET_NUMBER( <numeric_expr> )

-- Example 364
BITMAP_COUNT( <bitmap> )

-- Example 365
BITMAP_CONSTRUCT_AGG( <relative_position> )

-- Example 366
BITMAP_OR_AGG( <bitmap> )

-- Example 367
APPROX_COUNT_DISTINCT( [ DISTINCT ] <expr1>  [ , ... ] )

APPROX_COUNT_DISTINCT(*)

-- Example 368
APPROX_COUNT_DISTINCT( [ DISTINCT ] <expr1>  [ , ... ] ) OVER ( [ PARTITION BY <expr2> ] )

APPROX_COUNT_DISTINCT(*) OVER ( [ PARTITION BY <expr2> ] )

-- Example 369
(mytable.*)

-- Example 370
(* ILIKE 'col1%')

-- Example 371
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 372
(mytable.* ILIKE 'col1%')

-- Example 373
SELECT COUNT(i), COUNT(DISTINCT i), APPROX_COUNT_DISTINCT(i), HLL(i)
  FROM sequence_demo;

-- Example 374
+----------+-------------------+--------------------------+--------+
| COUNT(I) | COUNT(DISTINCT I) | APPROX_COUNT_DISTINCT(I) | HLL(I) |
|----------+-------------------+--------------------------+--------|
|     1024 |              1024 |                     1007 |   1007 |
+----------+-------------------+--------------------------+--------+

-- Example 375
HLL( [ DISTINCT ] <expr1> [ , ... ] )

HLL(*)

-- Example 376
HLL( [ DISTINCT ] <expr1> [ , ... ] ) OVER ( [ PARTITION BY <expr2> ] )

HLL(*) OVER ( [ PARTITION BY <expr2> ] )

-- Example 377
SELECT COUNT(i), COUNT(DISTINCT i), APPROX_COUNT_DISTINCT(i), HLL(i)
  FROM sequence_demo;

-- Example 378
HLL_ACCUMULATE( [ DISTINCT ] <expr> )

HLL_ACCUMULATE(*)

-- Example 379
CREATE TABLE temporary_hll_state_for_manitoba AS
 SELECT HLL_ACCUMULATE(postal_code) as h_a_p_c
  FROM postal_data
  WHERE province = 'Manitoba'
  ;

-- Example 380
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq92;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq92.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 381
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT hll_accumulate(c1) AS rs1
        FROM sequence_demo);

-- Example 382
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 383
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT hll_accumulate(c1) AS rs1 
     FROM test_table2);

-- Example 384
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT hll_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 385
SELECT hll_estimate(c1) FROM combined_resultstate;

-- Example 386
+------------------+
| HLL_ESTIMATE(C1) |
|------------------|
|               12 |
+------------------+

-- Example 387
HLL_COMBINE([DISTINCT] state)

-- Example 388
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq92;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq92.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 389
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT hll_accumulate(c1) AS rs1
        FROM sequence_demo);

-- Example 390
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 391
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT hll_accumulate(c1) AS rs1 
     FROM test_table2);

-- Example 392
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT hll_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 393
SELECT hll_estimate(c1) FROM combined_resultstate;

-- Example 394
+------------------+
| HLL_ESTIMATE(C1) |
|------------------|
|               12 |
+------------------+

-- Example 395
HLL_ESTIMATE( <state> )

-- Example 396
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq92;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq92.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 397
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT hll_accumulate(c1) AS rs1
        FROM sequence_demo);

-- Example 398
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 399
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT hll_accumulate(c1) AS rs1 
     FROM test_table2);

-- Example 400
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT hll_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 401
SELECT hll_estimate(c1) FROM combined_resultstate;

-- Example 402
+------------------+
| HLL_ESTIMATE(C1) |
|------------------|
|               12 |
+------------------+

-- Example 403
HLL_EXPORT( <binary_expr> )

-- Example 404
SELECT HLL(o_orderdate), HLL_ESTIMATE(HLL_IMPORT(HLL_EXPORT(HLL_ACCUMULATE(o_orderdate))))
FROM orders;

------------------+-------------------------------------------------------------------+
 HLL(O_ORDERDATE) | HLL_ESTIMATE(HLL_IMPORT(HLL_EXPORT(HLL_ACCUMULATE(O_ORDERDATE)))) |
------------------+-------------------------------------------------------------------+
 2398             | 2398                                                              |
------------------+-------------------------------------------------------------------+

-- Example 405
HLL_IMPORT(obj)

-- Example 406
APPROXIMATE_JACCARD_INDEX( [ DISTINCT ] <expr> [ , ... ] )

APPROXIMATE_JACCARD_INDEX(*)

-- Example 407
USE SCHEMA snowflake_sample_data.tpch_sf1;

SELECT APPROXIMATE_JACCARD_INDEX(mh) FROM
    (
      (SELECT MINHASH(100, C5) mh FROM orders WHERE c2 <= 50000)
         UNION
      (SELECT MINHASH(100, C5) mh FROM orders WHERE C2 > 50000)
    );

+-------------------------------+
| APPROXIMATE_JACCARD_INDEX(MH) |
|-------------------------------|
|                          0.97 |
+-------------------------------+

-- Example 408
APPROXIMATE_SIMILARITY( [ DISTINCT ] <expr> [ , ... ] )

APPROXIMATE_SIMILARITY(*)

