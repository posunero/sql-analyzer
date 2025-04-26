-- Example 409
USE SCHEMA snowflake_sample_data.tpch_sf1;

SELECT APPROXIMATE_SIMILARITY(mh) FROM
    (
      (SELECT MINHASH(100, C5) mh FROM orders WHERE c2 <= 50000)
         UNION
      (SELECT MINHASH(100, C5) mh FROM orders WHERE C2 > 50000)
    );

+----------------------------+
| APPROXIMATE_SIMILARITY(MH) |
|----------------------------|
|                       0.97 |
+----------------------------+

-- Example 410
CREATE TABLE ta (i INTEGER);
CREATE TABLE tb (i INTEGER);
CREATE TABLE tc (i INTEGER);

-- Insert values into the 3 tables.
INSERT INTO ta (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
-- Almost the same as the preceding values.
INSERT INTO tb (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (11);
-- Different values and different number of values.
INSERT INTO tc (i) VALUES (-1), (-20), (-300), (-4000);

-- Example 411
CREATE TABLE minhash_a_1 (mh) AS SELECT MINHASH(100, i) FROM ta;
CREATE TABLE minhash_b (mh) AS SELECT MINHASH(100, i) FROM tb;
CREATE TABLE minhash_c (mh) AS SELECT MINHASH(100, i) FROM tc;

-- Example 412
INSERT INTO ta (i) VALUES (12);

-- Example 413
-- Record minhash information about only the new rows:
CREATE TABLE minhash_a_2 (mh) AS SELECT MINHASH(100, i) FROM ta WHERE i > 10;

-- Now combine all the minhash info for the old and new rows in table ta.
CREATE TABLE minhash_a (mh) AS
  SELECT MINHASH_COMBINE(mh) FROM
    (
      (SELECT mh FROM minhash_a_1)
      UNION ALL
      (SELECT mh FROM minhash_a_2)
    );

-- Example 414
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_b)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                        0.75 |
+-----------------------------+

-- Example 415
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_c)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                           0 |
+-----------------------------+

-- Example 416
MINHASH( <k> , [ DISTINCT ] expr+ )

MINHASH( <k> , * )

-- Example 417
USE SCHEMA snowflake_sample_data.tpch_sf1;

SELECT MINHASH(5, *) FROM orders;

+----------------------+
| MINHASH(5, *)        |
|----------------------|
| {                    |
|   "state": [         |
|     78678383574307,  |
|     586952033158539, |
|     525995912623966, |
|     508991839383217, |
|     492677003405678  |
|   ],                 |
|   "type": "minhash", |
|   "version": 1       |
| }                    |
+----------------------+

-- Example 418
CREATE TABLE ta (i INTEGER);
CREATE TABLE tb (i INTEGER);
CREATE TABLE tc (i INTEGER);

-- Insert values into the 3 tables.
INSERT INTO ta (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
-- Almost the same as the preceding values.
INSERT INTO tb (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (11);
-- Different values and different number of values.
INSERT INTO tc (i) VALUES (-1), (-20), (-300), (-4000);

-- Example 419
CREATE TABLE minhash_a_1 (mh) AS SELECT MINHASH(100, i) FROM ta;
CREATE TABLE minhash_b (mh) AS SELECT MINHASH(100, i) FROM tb;
CREATE TABLE minhash_c (mh) AS SELECT MINHASH(100, i) FROM tc;

-- Example 420
INSERT INTO ta (i) VALUES (12);

-- Example 421
-- Record minhash information about only the new rows:
CREATE TABLE minhash_a_2 (mh) AS SELECT MINHASH(100, i) FROM ta WHERE i > 10;

-- Now combine all the minhash info for the old and new rows in table ta.
CREATE TABLE minhash_a (mh) AS
  SELECT MINHASH_COMBINE(mh) FROM
    (
      (SELECT mh FROM minhash_a_1)
      UNION ALL
      (SELECT mh FROM minhash_a_2)
    );

-- Example 422
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_b)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                        0.75 |
+-----------------------------+

-- Example 423
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_c)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                           0 |
+-----------------------------+

-- Example 424
MINHASH_COMBINE( [ DISTINCT ] <state> )

-- Example 425
USE SCHEMA snowflake_sample_data.tpch_sf1;

SELECT MINHASH_COMBINE(mh) FROM
    (
      (SELECT MINHASH(5, c2) mh FROM orders WHERE c2 <= 10000)
        UNION
      (SELECT MINHASH(5, c2) mh FROM orders WHERE c2 > 10000 AND c2 <= 20000)
        UNION
      (SELECT MINHASH(5, C2) mh FROM orders WHERE c2 > 20000)
    );

+-----------------------+
| MINHASH_COMBINE(MH)   |
|-----------------------|
| {                     |
|   "state": [          |
|     628914288006793,  |
|     1071764954434168, |
|     991489123966035,  |
|     2395105834644106, |
|     680224867834949   |
|   ],                  |
|   "type": "minhash",  |
|   "version": 1        |
| }                     |
+-----------------------+

-- Example 426
CREATE TABLE ta (i INTEGER);
CREATE TABLE tb (i INTEGER);
CREATE TABLE tc (i INTEGER);

-- Insert values into the 3 tables.
INSERT INTO ta (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
-- Almost the same as the preceding values.
INSERT INTO tb (i) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (11);
-- Different values and different number of values.
INSERT INTO tc (i) VALUES (-1), (-20), (-300), (-4000);

-- Example 427
CREATE TABLE minhash_a_1 (mh) AS SELECT MINHASH(100, i) FROM ta;
CREATE TABLE minhash_b (mh) AS SELECT MINHASH(100, i) FROM tb;
CREATE TABLE minhash_c (mh) AS SELECT MINHASH(100, i) FROM tc;

-- Example 428
INSERT INTO ta (i) VALUES (12);

-- Example 429
-- Record minhash information about only the new rows:
CREATE TABLE minhash_a_2 (mh) AS SELECT MINHASH(100, i) FROM ta WHERE i > 10;

-- Now combine all the minhash info for the old and new rows in table ta.
CREATE TABLE minhash_a (mh) AS
  SELECT MINHASH_COMBINE(mh) FROM
    (
      (SELECT mh FROM minhash_a_1)
      UNION ALL
      (SELECT mh FROM minhash_a_2)
    );

-- Example 430
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_b)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                        0.75 |
+-----------------------------+

-- Example 431
SELECT APPROXIMATE_SIMILARITY (mh) FROM
  (
    (SELECT mh FROM minhash_a)
    UNION ALL
    (SELECT mh FROM minhash_c)
  );
+-----------------------------+
| APPROXIMATE_SIMILARITY (MH) |
|-----------------------------|
|                           0 |
+-----------------------------+

-- Example 432
APPROX_TOP_K( <expr> [ , <k> [ , <counters> ] ] )

-- Example 433
APPROX_TOP_K( <expr> [ , <k> [ , <counters> ] ] ) OVER ( [ PARTITION BY <expr4> ] )

-- Example 434
SELECT APPROX_TOP_K(C4) FROM lineitem;

-- Example 435
+--------------------+
| APPROX_TOP_K(C4,3) |
+--------------------+
| [                  |
|   [                |
|     1,             |
|     124923         |
|   ],               |
|   [                |
|     2,             |
|     107093         |
|   ],               |
|   [                |
|     3,             |
|    89315           |
|   ]                |
| ]                  |
+--------------------+

-- Example 436
WITH states AS (
  SELECT approx_top_k(C4, 3, 5) AS state
  FROM lineitem)
SELECT value[0]::INT AS value, value[1]::INT AS frequency
  FROM states, LATERAL FLATTEN(state);

-- Example 437
+-------+-----------+
| VALUE | FREQUENCY |
+-------+-----------+
|     1 |    124923 |
|     2 |    107093 |
|     3 |     89438 |
+-------+-----------+

-- Example 438
APPROX_TOP_K_ACCUMULATE( <expr> , <counters> )

-- Example 439
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq91;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq91.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 440
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT approx_top_k_accumulate(c1, 50) AS rs1
        FROM sequence_demo);

-- Example 441
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 442
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT approx_top_k_accumulate(c1, 50) AS rs1 
     FROM test_table2);

-- Example 443
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT approx_top_k_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 444
SELECT approx_top_k_estimate(c1, 4) FROM combined_resultstate;

-- Example 445
+------------------------------+
| APPROX_TOP_K_ESTIMATE(C1, 4) |
|------------------------------|
| [                            |
|   [                          |
|     5,                       |
|     2                        |
|   ],                         |
|   [                          |
|     6,                       |
|     2                        |
|   ],                         |
|   [                          |
|     7,                       |
|     2                        |
|   ],                         |
|   [                          |
|     8,                       |
|     2                        |
|   ]                          |
| ]                            |
+------------------------------+

-- Example 446
APPROX_TOP_K_COMBINE( <state> [ , <counters> ] )

-- Example 447
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq91;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq91.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 448
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT approx_top_k_accumulate(c1, 50) AS rs1
        FROM sequence_demo);

-- Example 449
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 450
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT approx_top_k_accumulate(c1, 50) AS rs1 
     FROM test_table2);

-- Example 451
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT approx_top_k_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 452
SELECT approx_top_k_estimate(c1, 4) FROM combined_resultstate;

-- Example 453
+------------------------------+
| APPROX_TOP_K_ESTIMATE(C1, 4) |
|------------------------------|
| [                            |
|   [                          |
|     5,                       |
|     2                        |
|   ],                         |
|   [                          |
|     6,                       |
|     2                        |
|   ],                         |
|   [                          |
|     7,                       |
|     2                        |
|   ],                         |
|   [                          |
|     8,                       |
|     2                        |
|   ]                          |
| ]                            |
+------------------------------+

-- Example 454
APPROX_TOP_K_ESTIMATE( <state> [ , <k> ] )

-- Example 455
-- Create a sequence to use to generate values for the table.
CREATE OR REPLACE SEQUENCE seq91;
CREATE OR REPLACE TABLE sequence_demo (c1 INTEGER DEFAULT seq91.nextval, dummy SMALLINT);
INSERT INTO sequence_demo (dummy) VALUES (0);

-- Double the number of rows a few times, until there are 8 rows:
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;
INSERT INTO sequence_demo (dummy) SELECT dummy FROM sequence_demo;

-- Example 456
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT approx_top_k_accumulate(c1, 50) AS rs1
        FROM sequence_demo);

-- Example 457
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) SELECT c1 + 4 FROM sequence_demo;

-- Example 458
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT approx_top_k_accumulate(c1, 50) AS rs1 
     FROM test_table2);

-- Example 459
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT approx_top_k_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

-- Example 460
SELECT approx_top_k_estimate(c1, 4) FROM combined_resultstate;

-- Example 461
+------------------------------+
| APPROX_TOP_K_ESTIMATE(C1, 4) |
|------------------------------|
| [                            |
|   [                          |
|     5,                       |
|     2                        |
|   ],                         |
|   [                          |
|     6,                       |
|     2                        |
|   ],                         |
|   [                          |
|     7,                       |
|     2                        |
|   ],                         |
|   [                          |
|     8,                       |
|     2                        |
|   ]                          |
| ]                            |
+------------------------------+

-- Example 462
APPROX_PERCENTILE( <expr> , <percentile> )

-- Example 463
APPROX_PERCENTILE( <expr> , <percentile> ) OVER ( [ PARTITION BY <expr3> ] )

-- Example 464
CREATE TABLE testtable (c1 INTEGER);
INSERT INTO testtable (c1) VALUES 
    (0),
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10);

-- Example 465
SELECT APPROX_PERCENTILE(c1, 0.1) FROM testtable;
+----------------------------+
| APPROX_PERCENTILE(C1, 0.1) |
|----------------------------|
|                        1.5 |
+----------------------------+

-- Example 466
SELECT APPROX_PERCENTILE(c1, 0.5) FROM testtable;
+----------------------------+
| APPROX_PERCENTILE(C1, 0.5) |
|----------------------------|
|                        5.5 |
+----------------------------+

-- Example 467
SELECT APPROX_PERCENTILE(c1, 0.999) FROM testtable;
+------------------------------+
| APPROX_PERCENTILE(C1, 0.999) |
|------------------------------|
|                         10.5 |
+------------------------------+

-- Example 468
APPROX_PERCENTILE_ACCUMULATE( <expr> )

-- Example 469
-- create a table from the accumulated t-Digest state for testtable.c1
create or replace table resultstate as
    select approx_percentile_accumulate(c1) s from testtable;

-- Next, use the t-Digest state to compute percentiles for testtable.

-- returns an approximated value for the 1.5th percentile of testtable.c1
select approx_percentile_estimate(s, 0.015) from resultstate;

-- returns an approximated value for the 20th percentile of testtable.c1
select approx_percentile_estimate(s, 0.2) from resultstate;

-- Example 470
-- Create a table and insert some rows for which we'll later estimate the 
-- median value (the value at the 50th percentile).
CREATE OR REPLACE TABLE test_table1 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table1 (c1) VALUES (1), (2), (3), (4);

-- Example 471
CREATE OR REPLACE TABLE resultstate1 AS (
     SELECT approx_percentile_accumulate(c1) AS rs1
        FROM test_table1);

-- Example 472
SELECT approx_percentile_estimate(rs1, 0.5) 
    FROM resultstate1;

-- Example 473
SELECT approx_percentile_estimate(rs1, 0.5) 
    FROM resultstate1;
+--------------------------------------+
| APPROX_PERCENTILE_ESTIMATE(RS1, 0.5) |
|--------------------------------------|
|                                  2.5 |
+--------------------------------------+

-- Example 474
CREATE OR REPLACE TABLE test_table2 (c1 INTEGER);
-- Insert data.
INSERT INTO test_table2 (c1) VALUES (5), (6), (7), (8);

-- Example 475
CREATE OR REPLACE TABLE resultstate2 AS 
  (SELECT approx_percentile_accumulate(c1) AS rs1 
     FROM test_table2);

-- Example 476
CREATE OR REPLACE TABLE combined_resultstate (c1) AS 
  SELECT approx_percentile_combine(rs1) AS apc1
    FROM (
        SELECT rs1 FROM resultstate1
        UNION ALL
        SELECT rs1 FROM resultstate2
      )
      ;

