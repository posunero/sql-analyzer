-- Example 7820
SELECT * ILIKE '%id%' FROM employee_table;

-- Example 7821
+-------------+---------------+
| EMPLOYEE_ID | DEPARTMENT_ID |
|-------------+---------------|
|         101 |             1 |
|         102 |             2 |
|         103 |             2 |
+-------------+---------------+

-- Example 7822
SELECT * EXCLUDE department_id FROM employee_table;

-- Example 7823
+-------------+------------+------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME |
|-------------+------------+------------|
|         101 | Montgomery | Pat        |
|         102 | Levine     | Terry      |
|         103 | Comstock   | Dana       |
+-------------+------------+------------+

-- Example 7824
SELECT * EXCLUDE (department_id, employee_id) FROM employee_table;

-- Example 7825
+------------+------------+
| LAST_NAME  | FIRST_NAME |
|------------+------------|
| Montgomery | Pat        |
| Levine     | Terry      |
| Comstock   | Dana       |
+------------+------------+

-- Example 7826
SELECT * RENAME department_id AS department FROM employee_table;

-- Example 7827
+-------------+------------+------------+------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME | DEPARTMENT |
|-------------+------------+------------+------------|
|         101 | Montgomery | Pat        |          1 |
|         102 | Levine     | Terry      |          2 |
|         103 | Comstock   | Dana       |          2 |
+-------------+------------+------------+------------+

-- Example 7828
SELECT * RENAME (department_id AS department, employee_id AS id) FROM employee_table;

-- Example 7829
+-----+------------+------------+------------+
|  ID | LAST_NAME  | FIRST_NAME | DEPARTMENT |
|-----+------------+------------+------------|
| 101 | Montgomery | Pat        |          1 |
| 102 | Levine     | Terry      |          2 |
| 103 | Comstock   | Dana       |          2 |
+-----+------------+------------+------------+

-- Example 7830
SELECT * EXCLUDE first_name RENAME (department_id AS department, employee_id AS id) FROM employee_table;

-- Example 7831
+-----+------------+------------+
|  ID | LAST_NAME  | DEPARTMENT |
|-----+------------+------------|
| 101 | Montgomery |          1 |
| 102 | Levine     |          2 |
| 103 | Comstock   |          2 |
+-----+------------+------------+

-- Example 7832
SELECT * ILIKE '%id%' RENAME department_id AS department FROM employee_table;

-- Example 7833
+-------------+------------+
| EMPLOYEE_ID | DEPARTMENT |
|-------------+------------|
|         101 |          1 |
|         102 |          2 |
|         103 |          2 |
+-------------+------------+

-- Example 7834
SELECT * REPLACE ('DEPT-' || department_id AS department_id) FROM employee_table;

-- Example 7835
+-------------+------------+------------+---------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME | DEPARTMENT_ID |
|-------------+------------+------------+---------------|
|         101 | Montgomery | Pat        | DEPT-1        |
|         102 | Levine     | Terry      | DEPT-2        |
|         103 | Comstock   | Dana       | DEPT-2        |
+-------------+------------+------------+---------------+

-- Example 7836
SELECT * REPLACE ('DEPT-' || department_id AS department_id) RENAME department_id AS department FROM employee_table;

-- Example 7837
+-------------+------------+------------+------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME | DEPARTMENT |
|-------------+------------+------------+------------|
|         101 | Montgomery | Pat        | DEPT-1     |
|         102 | Levine     | Terry      | DEPT-2     |
|         103 | Comstock   | Dana       | DEPT-2     |
+-------------+------------+------------+------------+

-- Example 7838
SELECT * ILIKE '%id%' REPLACE('DEPT-' || department_id AS department_id) FROM employee_table;

-- Example 7839
+-------------+---------------+
| EMPLOYEE_ID | DEPARTMENT_ID |
|-------------+---------------|
|         101 | DEPT-1        |
|         102 | DEPT-2        |
|         103 | DEPT-2        |
+-------------+---------------+

-- Example 7840
SELECT
  employee_table.* EXCLUDE department_id,
  department_table.* RENAME department_name AS department
FROM employee_table INNER JOIN department_table
  ON employee_table.department_id = department_table.department_id
ORDER BY department, last_name, first_name;

-- Example 7841
+-------------+------------+------------+---------------+------------------+
| EMPLOYEE_ID | LAST_NAME  | FIRST_NAME | DEPARTMENT_ID | DEPARTMENT       |
|-------------+------------+------------+---------------+------------------|
|         103 | Comstock   | Dana       |             2 | Customer Support |
|         102 | Levine     | Terry      |             2 | Customer Support |
|         101 | Montgomery | Pat        |             1 | Engineering      |
+-------------+------------+------------+---------------+------------------+

-- Example 7842
SELECT last_name FROM employee_table WHERE employee_ID = 101;
+------------+
| LAST_NAME  |
|------------|
| Montgomery |
+------------+

-- Example 7843
SELECT department_name, last_name, first_name
    FROM employee_table INNER JOIN department_table
        ON employee_table.department_ID = department_table.department_ID
    ORDER BY department_name, last_name, first_name;
+------------------+------------+------------+
| DEPARTMENT_NAME  | LAST_NAME  | FIRST_NAME |
|------------------+------------+------------|
| Customer Support | Comstock   | Dana       |
| Customer Support | Levine     | Terry      |
| Engineering      | Montgomery | Pat        |
+------------------+------------+------------+

-- Example 7844
SELECT $2 FROM employee_table ORDER BY $2;
+------------+
| $2         |
|------------|
| Comstock   |
| Levine     |
| Montgomery |
+------------+

-- Example 7845
SELECT pi() * 2.0 * 2.0 AS area_of_circle;
+----------------+
| AREA_OF_CIRCLE |
|----------------|
|   12.566370614 |
+----------------+

-- Example 7846
CREATE OR REPLACE TABLE table1 (product_id NUMBER);

CREATE OR REPLACE TABLE table2 (prod_id NUMBER);

SELECT t1.product_id AS prod_id, t2.prod_id
  FROM table1 AS t1 JOIN table2 AS t2
    ON t1.product_id=t2.prod_id
  GROUP BY prod_id, t2.prod_id;

-- Example 7847
001104 (42601): SQL compilation error: error line 1 at position 7
'T1.PRODUCT_ID' in select clause is neither an aggregate nor in the group by clause.

-- Example 7848
CREATE TABLE simple (x INTEGER, y INTEGER);
INSERT INTO simple (x, y) VALUES
    (10, 20),
    (20, 44),
    (30, 70);

-- Example 7849
SELECT x, y 
    FROM simple
    ORDER BY x,y;

-- Example 7850
+----+----+
|  X |  Y |
|----+----|
| 10 | 20 |
| 20 | 44 |
| 30 | 70 |
+----+----+

-- Example 7851
SELECT COS(x)
    FROM simple
    ORDER BY x;

-- Example 7852
+---------------+
|        COS(X) |
|---------------|
| -0.8390715291 |
|  0.4080820618 |
|  0.1542514499 |
+---------------+

-- Example 7853
SELECT SUM(x)
    FROM simple;

-- Example 7854
+--------+
| SUM(X) |
|--------|
|     60 |
+--------+

-- Example 7855
SELECT COUNT(col1, col2) FROM table1;

-- Example 7856
CREATE OR REPLACE TABLE test_null_aggregate_functions (x INT, y INT);
INSERT INTO test_null_aggregate_functions (x, y) VALUES
  (1, 2),         -- No NULLs.
  (3, NULL),      -- One but not all columns are NULL.
  (NULL, 6),      -- One but not all columns are NULL.
  (NULL, NULL);   -- All columns are NULL.

-- Example 7857
SELECT COUNT(x, y) FROM test_null_aggregate_functions;

-- Example 7858
+-------------+
| COUNT(X, Y) |
|-------------|
|           1 |
+-------------+

-- Example 7859
SELECT SUM(x + y) FROM test_null_aggregate_functions;

-- Example 7860
+------------+
| SUM(X + Y) |
|------------|
|          3 |
+------------+

-- Example 7861
SELECT x AS X_COL, y AS Y_COL 
  FROM test_null_aggregate_functions 
  GROUP BY x, y;

-- Example 7862
+-------+-------+
| X_COL | Y_COL |
|-------+-------|
|     1 |     2 |
|     3 |  NULL |
|  NULL |     6 |
|  NULL |  NULL |
+-------+-------+

-- Example 7863
CREATE OR REPLACE ROW ACCESS POLICY rap_it
AS (empl_id varchar) RETURNS BOOLEAN ->
  'it_admin' = current_role()
;

-- Example 7864
SELECT *
FROM TABLE(
  mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME=>'mydb.policies.rap1'
  )
);

-- Example 7865
SELECT *
FROM TABLE(
  mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(
    REF_ENTITY_NAME => 'mydb.tables.t1',
    REF_ENTITY_DOMAIN => 'table'
  )
);

-- Example 7866
-- table
CREATE TABLE sales (
  customer   varchar,
  product    varchar,
  spend      decimal(20, 2),
  sale_date  date,
  region     varchar
)
WITH ROW ACCESS POLICY sales_policy ON (region);

-- view
CREATE VIEW sales_v WITH ROW ACCESS POLICY sales_policy ON (region)
AS SELECT * FROM sales;

-- Example 7867
-- table

ALTER TABLE t1 ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- view

ALTER VIEW v1 ADD ROW ACCESS POLICY rap_v1 ON (empl_id);

-- Example 7868
EXPLAIN SELECT * FROM my_table;

-- Example 7869
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+
|  step |   id   | parent |     operation     |           objects              | alias  | expressions | partitionsTotal | partitionsAssigned | bytesAssigned |
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+
...

| 1     | 2      | 1      | DynamicSecureView | "MY_TABLE (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+

-- Example 7870
EXPLAIN SELECT product FROM sales
  WHERE revenue > (SELECT AVG(revenue) FROM sales)
  ORDER BY product;

-- Example 7871
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+
|  step  |   id   | parent |     operation     |           objects           | alias  | expressions | partitionsTotal | partitionsAssigned | bytesAssigned |
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+
...
| 1      | 0      | [NULL] | DynamicSecureView | "SALES (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
...
| 2      | 2      | 1      | DynamicSecureView | "SALES (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+

-- Example 7872
use role securityadmin;
grant create row access policy on schema <db_name.schema_name> to role rap_admin;
grant apply row access policy on account to role rap_admin;

-- Example 7873
use role securityadmin;
grant create row access policy on schema <db_name.schema_name> to role rap_admin;
grant apply on row access policy rap_finance to role finance_role;

-- Example 7874
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.ROW_ACCESS_POLICIES
ORDER BY POLICY_NAME;

-- Example 7875
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
ORDER BY POLICY_NAME, REF_COLUMN_NAME;

-- Example 7876
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'rap_t1'
  )
);

-- Example 7877
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 7878
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 7879
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 7880
SELECT ...
FROM ...
ORDER BY orderItem [ , orderItem , ... ]
[ ... ]

-- Example 7881
orderItem ::= { <column_alias> | <position> | <expr> } [ { ASC | DESC } ] [ NULLS { FIRST | LAST } ]

-- Example 7882
SELECT * 
  FROM (
    SELECT branch_name
      FROM branch_offices
      ORDER BY monthly_sales DESC
      LIMIT 3
  );

-- Example 7883
SELECT column1
  FROM VALUES ('a'), ('1'), ('B'), (null), ('2'), ('01'), ('05'), (' this'), ('this'), ('this and that'), ('&'), ('%')
  ORDER BY column1;

-- Example 7884
+---------------+
| COLUMN1       |
|---------------|
|  this         |
| %             |
| &             |
| 01            |
| 05            |
| 1             |
| 2             |
| B             |
| a             |
| this          |
| this and that |
| NULL          |
+---------------+

-- Example 7885
SELECT column1
  FROM VALUES (3), (4), (null), (1), (2), (6), (5), (0005), (.05), (.5), (.5000)
  ORDER BY column1;

-- Example 7886
+---------+
| COLUMN1 |
|---------|
|    0.05 |
|    0.50 |
|    0.50 |
|    1.00 |
|    2.00 |
|    3.00 |
|    4.00 |
|    5.00 |
|    5.00 |
|    6.00 |
|    NULL |
+---------+

