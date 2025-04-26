-- Example 69
SELECT COUNT(v:Title)
    FROM count_example_with_variant_column;

-- Example 70
+----------------+
| COUNT(V:TITLE) |
|----------------|
|              2 |
+----------------+

-- Example 71
COUNT_IF( <condition> )

-- Example 72
COUNT_IF( <condition> )
    OVER ( [ PARTITION BY <expr1> ] [ ORDER BY <expr2> [ ASC | DESC ] [ <window_frame> ] ] )

-- Example 73
CREATE TABLE basic_example (i_col INTEGER, j_col INTEGER);
INSERT INTO basic_example VALUES
    (11,101), (11,102), (11,NULL), (12,101), (NULL,101), (NULL,102);

-- Example 74
SELECT *
    FROM basic_example
    ORDER BY i_col;

-- Example 75
+-------+-------+
| I_COL | J_COL |
|-------+-------|
|    11 |   101 |
|    11 |   102 |
|    11 |  NULL |
|    12 |   101 |
|  NULL |   101 |
|  NULL |   102 |
+-------+-------+

-- Example 76
SELECT COUNT_IF(TRUE) FROM basic_example;

-- Example 77
+----------------+
| COUNT_IF(TRUE) |
|----------------|
|              6 |
+----------------+

-- Example 78
SELECT COUNT_IF(j_col > i_col) FROM basic_example;

-- Example 79
+-------------------------+
| COUNT_IF(J_COL > I_COL) |
|-------------------------|
|                       3 |
+-------------------------+

-- Example 80
SELECT COUNT_IF(i_col IS NOT NULL AND j_col IS NOT NULL) FROM basic_example;

-- Example 81
+---------------------------------------------------+
| COUNT_IF(I_COL IS NOT NULL AND J_COL IS NOT NULL) |
|---------------------------------------------------|
|                                                 3 |
+---------------------------------------------------+

-- Example 82
COVAR_POP( y , x )

-- Example 83
COVAR_POP( y , x ) OVER ( [ PARTITION BY <expr1> ] )

-- Example 84
CREATE OR REPLACE TABLE aggr(k int, v decimal(10,2), v2 decimal(10, 2));
INSERT INTO aggr VALUES(1, 10, NULL);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, NULL), (2, 30, 35);

SELECT * FROM aggr;

-- Example 85
+---+-------+-------+
| K |     V |    V2 |
|---+-------+-------|
| 1 | 10.00 |  NULL |
| 2 | 10.00 | 11.00 |
| 2 | 20.00 | 22.00 |
| 2 | 25.00 |  NULL |
| 2 | 30.00 | 35.00 |
+---+-------+-------+

-- Example 86
SELECT k, COVAR_POP(v, v2) FROM aggr GROUP BY k;

-- Example 87
+---+------------------+
| K | COVAR_POP(V, V2) |
|---+------------------|
| 1 |             NULL |
| 2 |               80 |
+---+------------------+

-- Example 88
COVAR_SAMP( y , x )

-- Example 89
COVAR_SAMP( y , x ) OVER ( [ PARTITION BY <expr1> ] )

-- Example 90
CREATE OR REPLACE TABLE aggr(k int, v decimal(10,2), v2 decimal(10, 2));
INSERT INTO aggr VALUES(1, 10, NULL);
INSERT INTO aggr VALUES(2, 10, 11), (2, 20, 22), (2, 25, NULL), (2, 30, 35);

SELECT k, COVAR_SAMP(v, v2) FROM aggr GROUP BY k;

-- Example 91
+---+-------------------+
| K | COVAR_SAMP(V, V2) |
|---+-------------------|
| 1 |              NULL |
| 2 |               120 |
+---+-------------------+

-- Example 92
LISTAGG( [ DISTINCT ] <expr1> [, <delimiter> ] )
    [ WITHIN GROUP ( <orderby_clause> ) ]

-- Example 93
LISTAGG( [ DISTINCT ] <expr1> [, <delimiter> ] )
    [ WITHIN GROUP ( <orderby_clause> ) ]
    OVER ( [ PARTITION BY <expr2> ] )

-- Example 94
SELECT LISTAGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERKEY) ...;

-- Example 95
SELECT LISTAGG(DISTINCT O_ORDERKEY) WITHIN GROUP (ORDER BY O_ORDERSTATUS) ...;

-- Example 96
SQL compilation error: [ORDERS.O_ORDERSTATUS] is not a valid order by expression

-- Example 97
SELECT LISTAGG(x, ', ') WITHIN GROUP (ORDER BY last_name COLLATE 'es')
  FROM table1
  ORDER BY last_name;

-- Example 98
USE SCHEMA snowflake_sample_data.tpch_sf1;

-- Example 99
SELECT LISTAGG(DISTINCT o_orderkey, ' ')
  FROM orders
  WHERE o_totalprice > 520000;

-- Example 100
+-------------------------------------------------+
| LISTAGG(DISTINCT O_ORDERKEY, ' ')               |
|-------------------------------------------------|
| 2232932 1750466 3043270 4576548 4722021 3586919 |
+-------------------------------------------------+

-- Example 101
SELECT LISTAGG(DISTINCT o_orderstatus, '|')
  FROM orders
  WHERE o_totalprice > 520000;

-- Example 102
+--------------------------------------+
| LISTAGG(DISTINCT O_ORDERSTATUS, '|') |
|--------------------------------------|
| O|F                                  |
+--------------------------------------+

-- Example 103
SELECT o_orderstatus,
   LISTAGG(o_clerk, ', ')
     WITHIN GROUP (ORDER BY o_totalprice DESC)
  FROM orders
  WHERE o_totalprice > 520000
  GROUP BY o_orderstatus;

-- Example 104
+---------------+---------------------------------------------------+
| O_ORDERSTATUS | LISTAGG(O_CLERK, ', ')                            |
|               |      WITHIN GROUP (ORDER BY O_TOTALPRICE DESC)    |
|---------------+---------------------------------------------------|
| O             | Clerk#000000699, Clerk#000000336, Clerk#000000245 |
| F             | Clerk#000000040, Clerk#000000230, Clerk#000000924 |
+---------------+---------------------------------------------------+

-- Example 105
CREATE OR REPLACE TABLE collation_demo (
  spanish_phrase VARCHAR COLLATE 'es');

-- Example 106
INSERT INTO collation_demo (spanish_phrase) VALUES
  ('piña colada'),
  ('Pinatubo (Mount)'),
  ('pint'),
  ('Pinta');

-- Example 107
SELECT LISTAGG(spanish_phrase, '|')
    WITHIN GROUP (ORDER BY COLLATE(spanish_phrase, 'es')) AS es_collation
  FROM collation_demo;

-- Example 108
+-----------------------------------------+
| ES_COLLATION                            |
|-----------------------------------------|
| Pinatubo (Mount)|pint|Pinta|piña colada |
+-----------------------------------------+

-- Example 109
SELECT LISTAGG(spanish_phrase, '|')
    WITHIN GROUP (ORDER BY COLLATE(spanish_phrase, 'utf8')) AS utf8_collation
  FROM collation_demo;

-- Example 110
+-----------------------------------------+
| UTF8_COLLATION                          |
|-----------------------------------------|
| Pinatubo (Mount)|Pinta|pint|piña colada |
+-----------------------------------------+

-- Example 111
MAX_BY( <col_to_return>, <col_containing_maximum> [ , <maximum_number_of_values_to_return> ] )

-- Example 112
CREATE OR REPLACE TABLE employees(employee_id NUMBER, department_id NUMBER, salary NUMBER);

INSERT INTO employees VALUES
  (1001, 10, 10000),
  (1020, 10, 9000),
  (1030, 10, 8000),
  (900, 20, 15000),
  (2000, 20, NULL),
  (2010, 20, 15000),
  (2020, 20, 8000);

-- Example 113
SELECT * FROM employees;

-- Example 114
+-------------+---------------+--------+
| EMPLOYEE_ID | DEPARTMENT_ID | SALARY |
|-------------+---------------+--------|
|        1001 |            10 |  10000 |
|        1020 |            10 |   9000 |
|        1030 |            10 |   8000 |
|         900 |            20 |  15000 |
|        2000 |            20 |   NULL |
|        2010 |            20 |  15000 |
|        2020 |            20 |   8000 |
+-------------+---------------+--------+

-- Example 115
SELECT MAX_BY(employee_id, salary) FROM employees;

-- Example 116
+-----------------------------+
| MAX_BY(EMPLOYEE_ID, SALARY) |
|-----------------------------|
|                         900 |
+-----------------------------+

-- Example 117
SELECT MAX_BY(employee_id, salary, 3) from employees;

-- Example 118
+--------------------------------+
| MAX_BY(EMPLOYEE_ID, SALARY, 3) |
|--------------------------------|
| [                              |
|   900,                         |
|   2010,                        |
|   1001                         |
| ]                              |
+--------------------------------+

-- Example 119
MEDIAN( <expr> )

-- Example 120
MEDIAN( <expr> ) OVER ( [ PARTITION BY <expr2> ] )

-- Example 121
CREATE OR REPLACE TABLE aggr(k int, v decimal(10,2));

-- Example 122
SELECT MEDIAN (v) FROM aggr;
+------------+
| MEDIAN (V) |
|------------|
|       NULL |
+------------+

-- Example 123
INSERT INTO aggr VALUES(1, 10), (1,20), (1, 21);
INSERT INTO aggr VALUES(2, 10), (2, 20), (2, 25), (2, 30);
INSERT INTO aggr VALUES(3, NULL);

-- Example 124
SELECT k, MEDIAN(v) FROM aggr GROUP BY k ORDER BY k;
+---+-----------+
| K | MEDIAN(V) |
|---+-----------|
| 1 |  20.00000 |
| 2 |  22.50000 |
| 3 |      NULL |
+---+-----------+

-- Example 125
MIN( <expr> )

-- Example 126
MIN( <expr> ) [ OVER ( [ PARTITION BY <expr1> ] [ ORDER BY <expr2> [ <window_frame> ] ] ) ]

-- Example 127
CREATE OR REPLACE TABLE sample_table(k CHAR(4), d CHAR(4));

INSERT INTO sample_table VALUES
    ('1', '1'), ('1', '5'), ('1', '3'),
    ('2', '2'), ('2', NULL),
    ('3', NULL),
    (NULL, '7'), (NULL, '1');

-- Example 128
SELECT k, d
    FROM sample_table
    ORDER BY k, d;

-- Example 129
+------+------+
| K    | D    |
|------+------|
| 1    | 1    |
| 1    | 3    |
| 1    | 5    |
| 2    | 2    |
| 2    | NULL |
| 3    | NULL |
| NULL | 1    |
| NULL | 7    |
+------+------+

-- Example 130
SELECT MIN(d) FROM sample_table;

-- Example 131
+--------+                                                                      
| MIN(D) |
|--------|
| 1      |
+--------+

-- Example 132
SELECT k, MIN(d)
  FROM sample_table 
  GROUP BY k
  ORDER BY k;

-- Example 133
+------+--------+                                                               
| K    | MIN(D) |
|------+--------|
| 1    | 1      |
| 2    | 2      |
| 3    | NULL   |
| NULL | 1      |
+------+--------+

-- Example 134
SELECT k, d, MIN(d) OVER (PARTITION BY k)
  FROM sample_table
  ORDER BY k, d;

-- Example 135
+------+------+------------------------------+                                  
| K    | D    | MIN(D) OVER (PARTITION BY K) |
|------+------+------------------------------|
| 1    | 1    | 1                            |
| 1    | 3    | 1                            |
| 1    | 5    | 1                            |
| 2    | 2    | 2                            |
| 2    | NULL | 2                            |
| 3    | NULL | NULL                         |
| NULL | 1    | 1                            |
| NULL | 7    | 1                            |
+------+------+------------------------------+

-- Example 136
SELECT k, d, MIN(d) OVER (ORDER BY k, d ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
  FROM sample_table
  ORDER BY k, d;

