-- Example 205
VARIANCE( [ DISTINCT ] <expr1> )

-- Example 206
VARIANCE( [ DISTINCT ] <expr1> ) OVER (
                                      [ PARTITION BY <expr2> ]
                                      [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                      )

-- Example 207
VARIANCE_POP( [ DISTINCT ] <expr1> )

-- Example 208
VARIANCE_POP( [ DISTINCT ] <expr1> ) OVER (
                                          [ PARTITION BY <expr2> ]
                                          [ ORDER BY <expr3> [ ASC | DESC ] [ <window_frame> ] ]
                                          )

-- Example 209
BITAND_AGG( <expr1> )

-- Example 210
BITAND_AGG( <expr1> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 211
CREATE OR REPLACE TABLE bitwise_example
  (k INT, d DECIMAL(10,5), s1 VARCHAR(10), s2 VARCHAR(10));

INSERT INTO bitwise_example VALUES
  (15, 1.1, '12','one'),
  (26, 2.9, '10','two'),
  (12, 7.1, '7.9','two'),
  (14, NULL, NULL,'null'),
  (8, NULL, NULL, 'null'),
  (NULL, 9.1, '14','nine');

-- Example 212
SELECT k AS k_col, d AS d_col, s1, s2
  FROM bitwise_example
  ORDER BY k_col;

-- Example 213
+-------+---------+------+------+
| K_COL |   D_COL | S1   | S2   |
|-------+---------+------+------|
|     8 |    NULL | NULL | null |
|    12 | 7.10000 | 7.9  | two  |
|    14 |    NULL | NULL | null |
|    15 | 1.10000 | 12   | one  |
|    26 | 2.90000 | 10   | two  |
|  NULL | 9.10000 | 14   | nine |
+-------+---------+------+------+

-- Example 214
SELECT BITAND_AGG(k), 
       BITAND_AGG(d), 
       BITAND_AGG(s1) 
  FROM bitwise_example;

-- Example 215
+---------------+---------------+----------------+
| BITAND_AGG(K) | BITAND_AGG(D) | BITAND_AGG(S1) |
|---------------+---------------+----------------|
|             8 |             1 |              8 |
+---------------+---------------+----------------+

-- Example 216
SELECT s2, 
       BITAND_AGG(k), 
       BITAND_AGG(d) 
  FROM bitwise_example 
  GROUP BY s2
  ORDER BY 3;

-- Example 217
+------+---------------+---------------+
| S2   | BITAND_AGG(K) | BITAND_AGG(D) |
|------+---------------+---------------|
| one  |            15 |             1 |
| two  |             8 |             3 |
| nine |          NULL |             9 |
| null |             8 |          NULL |
+------+---------------+---------------+

-- Example 218
SELECT BITAND_AGG(s2) FROM bitwise_example;

-- Example 219
100038 (22018): Numeric value 'one' is not recognized

-- Example 220
BITOR_AGG( <expr1> )

-- Example 221
BITOR_AGG( <expr1> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 222
CREATE OR REPLACE TABLE bitwise_example
  (k INT, d DECIMAL(10,5), s1 VARCHAR(10), s2 VARCHAR(10));

INSERT INTO bitwise_example VALUES
  (15, 1.1, '12','one'),
  (26, 2.9, '10','two'),
  (12, 7.1, '7.9','two'),
  (14, NULL, NULL,'null'),
  (8, NULL, NULL, 'null'),
  (NULL, 9.1, '14','nine');

-- Example 223
SELECT k AS k_col, d AS d_col, s1, s2
  FROM bitwise_example
  ORDER BY k_col;

-- Example 224
+-------+---------+------+------+
| K_COL |   D_COL | S1   | S2   |
|-------+---------+------+------|
|     8 |    NULL | NULL | null |
|    12 | 7.10000 | 7.9  | two  |
|    14 |    NULL | NULL | null |
|    15 | 1.10000 | 12   | one  |
|    26 | 2.90000 | 10   | two  |
|  NULL | 9.10000 | 14   | nine |
+-------+---------+------+------+

-- Example 225
SELECT BITOR_AGG(k), 
       BITOR_AGG(d), 
       BITOR_AGG(s1) 
  FROM bitwise_example;

-- Example 226
+--------------+--------------+---------------+
| BITOR_AGG(K) | BITOR_AGG(D) | BITOR_AGG(S1) |
|--------------+--------------+---------------|
|           31 |           15 |            14 |
+--------------+--------------+---------------+

-- Example 227
SELECT s2, 
       BITOR_AGG(k), 
       BITOR_AGG(d) 
  FROM bitwise_example group by s2
  ORDER BY 3;

-- Example 228
+------+--------------+--------------+
| S2   | BITOR_AGG(K) | BITOR_AGG(D) |
|------+--------------+--------------|
| one  |           15 |            1 |
| two  |           30 |            7 |
| nine |         NULL |            9 |
| null |           14 |         NULL |
+------+--------------+--------------+

-- Example 229
SELECT BITOR_AGG(s2) FROM bitwise_example;

-- Example 230
100038 (22018): Numeric value 'one' is not recognized

-- Example 231
BITXOR_AGG( [ DISTINCT ] <expr1> )

-- Example 232
BITXOR_AGG( [ DISTINCT ] <expr1> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 233
CREATE OR REPLACE TABLE bitwise_example
  (k INT, d DECIMAL(10,5), s1 VARCHAR(10), s2 VARCHAR(10));

INSERT INTO bitwise_example VALUES
  (15, 1.1, '12','one'),
  (26, 2.9, '10','two'),
  (12, 7.1, '7.9','two'),
  (14, NULL, NULL,'null'),
  (8, NULL, NULL, 'null'),
  (NULL, 9.1, '14','nine');

-- Example 234
SELECT k AS k_col, d AS d_col, s1, s2
  FROM bitwise_example
  ORDER BY k_col;

-- Example 235
+-------+---------+------+------+
| K_COL |   D_COL | S1   | S2   |
|-------+---------+------+------|
|     8 |    NULL | NULL | null |
|    12 | 7.10000 | 7.9  | two  |
|    14 |    NULL | NULL | null |
|    15 | 1.10000 | 12   | one  |
|    26 | 2.90000 | 10   | two  |
|  NULL | 9.10000 | 14   | nine |
+-------+---------+------+------+

-- Example 236
SELECT BITXOR_AGG(k), 
       BITXOR_AGG(d), 
       BITXOR_AGG(s1) 
  FROM bitwise_example;

-- Example 237
+---------------+---------------+----------------+
| BITXOR_AGG(K) | BITXOR_AGG(D) | BITXOR_AGG(S1) |
|---------------+---------------+----------------|
|            31 |            12 |              0 |
+---------------+---------------+----------------+

-- Example 238
SELECT s2, 
       BITXOR_AGG(k), 
       BITXOR_AGG(d) 
  FROM bitwise_example 
  GROUP BY s2
  ORDER BY 3;

-- Example 239
+------+---------------+---------------+
| S2   | BITXOR_AGG(K) | BITXOR_AGG(D) |
|------+---------------+---------------|
| one  |            15 |             1 |
| two  |            22 |             4 |
| nine |          NULL |             9 |
| null |             6 |          NULL |
+------+---------------+---------------+

-- Example 240
SELECT BITXOR_AGG(s2) FROM bitwise_example;

-- Example 241
100038 (22018): Numeric value 'one' is not recognized

-- Example 242
BOOLAND_AGG( <expr> )

-- Example 243
BOOLAND_AGG( <expr> )  OVER ( [ PARTITION BY <partition_expr> ] )

-- Example 244
create or replace table test_boolean_agg(
    id integer,
    c1 boolean, 
    c2 boolean,
    c3 boolean,
    c4 boolean
    );

insert into test_boolean_agg (id, c1, c2, c3, c4) values 
    (1, true, true,  true,  false),
    (2, true, false, false, false),
    (3, true, true,  false, false),
    (4, true, false, false, false);

-- Example 245
select * from test_boolean_agg;
+----+------+-------+-------+-------+
| ID | C1   | C2    | C3    | C4    |
|----+------+-------+-------+-------|
|  1 | True | True  | True  | False |
|  2 | True | False | False | False |
|  3 | True | True  | False | False |
|  4 | True | False | False | False |
+----+------+-------+-------+-------+

-- Example 246
select booland_agg(c1), booland_agg(c2), booland_agg(c3), booland_agg(c4)
    from test_boolean_agg;
+-----------------+-----------------+-----------------+-----------------+
| BOOLAND_AGG(C1) | BOOLAND_AGG(C2) | BOOLAND_AGG(C3) | BOOLAND_AGG(C4) |
|-----------------+-----------------+-----------------+-----------------|
| True            | False           | False           | False           |
+-----------------+-----------------+-----------------+-----------------+

-- Example 247
insert into test_boolean_agg (id, c1, c2, c3, c4) values
    (-4, false, false, false, true),
    (-3, false, true,  true,  true),
    (-2, false, false, true,  true),
    (-1, false, true,  true,  true);

-- Example 248
select * 
    from test_boolean_agg
    order by id;
+----+-------+-------+-------+-------+
| ID | C1    | C2    | C3    | C4    |
|----+-------+-------+-------+-------|
| -4 | False | False | False | True  |
| -3 | False | True  | True  | True  |
| -2 | False | False | True  | True  |
| -1 | False | True  | True  | True  |
|  1 | True  | True  | True  | False |
|  2 | True  | False | False | False |
|  3 | True  | True  | False | False |
|  4 | True  | False | False | False |
+----+-------+-------+-------+-------+

-- Example 249
select 
      id,
      booland_agg(c1) OVER (PARTITION BY (id > 0)),
      booland_agg(c2) OVER (PARTITION BY (id > 0)),
      booland_agg(c3) OVER (PARTITION BY (id > 0)),
      booland_agg(c4) OVER (PARTITION BY (id > 0))
    from test_boolean_agg
    order by id;
+----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------+
| ID | BOOLAND_AGG(C1) OVER (PARTITION BY (ID > 0)) | BOOLAND_AGG(C2) OVER (PARTITION BY (ID > 0)) | BOOLAND_AGG(C3) OVER (PARTITION BY (ID > 0)) | BOOLAND_AGG(C4) OVER (PARTITION BY (ID > 0)) |
|----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------|
| -4 | False                                        | False                                        | False                                        | True                                         |
| -3 | False                                        | False                                        | False                                        | True                                         |
| -2 | False                                        | False                                        | False                                        | True                                         |
| -1 | False                                        | False                                        | False                                        | True                                         |
|  1 | True                                         | False                                        | False                                        | False                                        |
|  2 | True                                         | False                                        | False                                        | False                                        |
|  3 | True                                         | False                                        | False                                        | False                                        |
|  4 | True                                         | False                                        | False                                        | False                                        |
+----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------+

-- Example 250
select booland_agg('invalid type');

100037 (22018): Boolean value 'invalid_type' is not recognized

-- Example 251
BOOLOR_AGG( <expr> )

-- Example 252
BOOLOR_AGG( <expr> ) OVER ( [ PARTITION BY <partition_expr> ] )

-- Example 253
create or replace table test_boolean_agg(
    id integer,
    c1 boolean, 
    c2 boolean,
    c3 boolean,
    c4 boolean
    );

insert into test_boolean_agg (id, c1, c2, c3, c4) values 
    (1, true, true,  true,  false),
    (2, true, false, false, false),
    (3, true, true,  false, false),
    (4, true, false, false, false);

-- Example 254
select * from test_boolean_agg;
+----+------+-------+-------+-------+
| ID | C1   | C2    | C3    | C4    |
|----+------+-------+-------+-------|
|  1 | True | True  | True  | False |
|  2 | True | False | False | False |
|  3 | True | True  | False | False |
|  4 | True | False | False | False |
+----+------+-------+-------+-------+

-- Example 255
select boolor_agg(c1), boolor_agg(c2), boolor_agg(c3), boolor_agg(c4)
    from test_boolean_agg;
+----------------+----------------+----------------+----------------+
| BOOLOR_AGG(C1) | BOOLOR_AGG(C2) | BOOLOR_AGG(C3) | BOOLOR_AGG(C4) |
|----------------+----------------+----------------+----------------|
| True           | True           | True           | False          |
+----------------+----------------+----------------+----------------+

-- Example 256
insert into test_boolean_agg (id, c1, c2, c3, c4) values
    (-4, false, false, false, true),
    (-3, false, true,  true,  true),
    (-2, false, false, true,  true),
    (-1, false, true,  true,  true);

-- Example 257
select * 
    from test_boolean_agg
    order by id;
+----+-------+-------+-------+-------+
| ID | C1    | C2    | C3    | C4    |
|----+-------+-------+-------+-------|
| -4 | False | False | False | True  |
| -3 | False | True  | True  | True  |
| -2 | False | False | True  | True  |
| -1 | False | True  | True  | True  |
|  1 | True  | True  | True  | False |
|  2 | True  | False | False | False |
|  3 | True  | True  | False | False |
|  4 | True  | False | False | False |
+----+-------+-------+-------+-------+

-- Example 258
select 
      id,
      boolor_agg(c1) OVER (PARTITION BY (id > 0)),
      boolor_agg(c2) OVER (PARTITION BY (id > 0)),
      boolor_agg(c3) OVER (PARTITION BY (id > 0)),
      boolor_agg(c4) OVER (PARTITION BY (id > 0))
    from test_boolean_agg
    order by id;
+----+---------------------------------------------+---------------------------------------------+---------------------------------------------+---------------------------------------------+
| ID | BOOLOR_AGG(C1) OVER (PARTITION BY (ID > 0)) | BOOLOR_AGG(C2) OVER (PARTITION BY (ID > 0)) | BOOLOR_AGG(C3) OVER (PARTITION BY (ID > 0)) | BOOLOR_AGG(C4) OVER (PARTITION BY (ID > 0)) |
|----+---------------------------------------------+---------------------------------------------+---------------------------------------------+---------------------------------------------|
| -4 | False                                       | True                                        | True                                        | True                                        |
| -3 | False                                       | True                                        | True                                        | True                                        |
| -2 | False                                       | True                                        | True                                        | True                                        |
| -1 | False                                       | True                                        | True                                        | True                                        |
|  1 | True                                        | True                                        | True                                        | False                                       |
|  2 | True                                        | True                                        | True                                        | False                                       |
|  3 | True                                        | True                                        | True                                        | False                                       |
|  4 | True                                        | True                                        | True                                        | False                                       |
+----+---------------------------------------------+---------------------------------------------+---------------------------------------------+---------------------------------------------+

-- Example 259
select boolor_agg('invalid type');

100037 (22018): Boolean value 'invalid_type' is not recognized

-- Example 260
BOOLXOR_AGG( <expr> )

-- Example 261
BOOLXOR_AGG( <expr> ) OVER ( [ PARTITION BY <partition_expr> ] )

-- Example 262
create or replace table test_boolean_agg(
    id integer,
    c1 boolean, 
    c2 boolean,
    c3 boolean,
    c4 boolean
    );

insert into test_boolean_agg (id, c1, c2, c3, c4) values 
    (1, true, true,  true,  false),
    (2, true, false, false, false),
    (3, true, true,  false, false),
    (4, true, false, false, false);

-- Example 263
select * from test_boolean_agg;
+----+------+-------+-------+-------+
| ID | C1   | C2    | C3    | C4    |
|----+------+-------+-------+-------|
|  1 | True | True  | True  | False |
|  2 | True | False | False | False |
|  3 | True | True  | False | False |
|  4 | True | False | False | False |
+----+------+-------+-------+-------+

-- Example 264
select boolxor_agg(c1), boolxor_agg(c2), boolxor_agg(c3), boolxor_agg(c4)
    from test_boolean_agg;
+-----------------+-----------------+-----------------+-----------------+
| BOOLXOR_AGG(C1) | BOOLXOR_AGG(C2) | BOOLXOR_AGG(C3) | BOOLXOR_AGG(C4) |
|-----------------+-----------------+-----------------+-----------------|
| False           | False           | True            | False           |
+-----------------+-----------------+-----------------+-----------------+

-- Example 265
insert into test_boolean_agg (id, c1, c2, c3, c4) values
    (-4, false, false, false, true),
    (-3, false, true,  true,  true),
    (-2, false, false, true,  true),
    (-1, false, true,  true,  true);

-- Example 266
select * 
    from test_boolean_agg
    order by id;
+----+-------+-------+-------+-------+
| ID | C1    | C2    | C3    | C4    |
|----+-------+-------+-------+-------|
| -4 | False | False | False | True  |
| -3 | False | True  | True  | True  |
| -2 | False | False | True  | True  |
| -1 | False | True  | True  | True  |
|  1 | True  | True  | True  | False |
|  2 | True  | False | False | False |
|  3 | True  | True  | False | False |
|  4 | True  | False | False | False |
+----+-------+-------+-------+-------+

-- Example 267
select 
      id, 
      boolxor_agg(c1) OVER (PARTITION BY (id > 0)),
      boolxor_agg(c2) OVER (PARTITION BY (id > 0)),
      boolxor_agg(c3) OVER (PARTITION BY (id > 0)),
      boolxor_agg(c4) OVER (PARTITION BY (id > 0))
    from test_boolean_agg
    order by id;
+----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------+
| ID | BOOLXOR_AGG(C1) OVER (PARTITION BY (ID > 0)) | BOOLXOR_AGG(C2) OVER (PARTITION BY (ID > 0)) | BOOLXOR_AGG(C3) OVER (PARTITION BY (ID > 0)) | BOOLXOR_AGG(C4) OVER (PARTITION BY (ID > 0)) |
|----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------|
| -4 | False                                        | False                                        | False                                        | False                                        |
| -3 | False                                        | False                                        | False                                        | False                                        |
| -2 | False                                        | False                                        | False                                        | False                                        |
| -1 | False                                        | False                                        | False                                        | False                                        |
|  1 | False                                        | False                                        | True                                         | False                                        |
|  2 | False                                        | False                                        | True                                         | False                                        |
|  3 | False                                        | False                                        | True                                         | False                                        |
|  4 | False                                        | False                                        | True                                         | False                                        |
+----+----------------------------------------------+----------------------------------------------+----------------------------------------------+----------------------------------------------+

-- Example 268
select boolxor_agg('invalid type');

100037 (22018): Boolean value 'invalid_type' is not recognized

-- Example 269
HASH_AGG( [ DISTINCT ] <expr> [ , <expr2> ... ] )

HASH_AGG(*)

-- Example 270
HASH_AGG( [ DISTINCT ] <expr> [ , <expr2> ... ] ) OVER ( [ PARTITION BY <expr3> ] )

HASH_AGG(*) OVER ( [ PARTITION BY <expr3> ] )

-- Example 271
(mytable.*)

-- Example 272
(* ILIKE 'col1%')

