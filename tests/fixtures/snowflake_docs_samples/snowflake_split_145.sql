-- Example 9696
CREATE OR REPLACE FILE FORMAT my_csv_unload_format
  TYPE = 'CSV'
  FIELD_DELIMITER = '|';

-- Example 9697
CREATE OR REPLACE FILE FORMAT my_json_unload_format
  TYPE = 'JSON';

-- Example 9698
CREATE OR REPLACE STAGE my_unload_stage
  FILE_FORMAT = my_csv_unload_format;

-- Example 9699
COPY INTO @mystage/unload/ from mytable;

-- Example 9700
LIST @mystage;

+----------------------------------+------+----------------------------------+-------------------------------+
| name                             | size | md5                              | last_modified                 |
|----------------------------------+------+----------------------------------+-------------------------------|
| mystage/unload/data_0_0_0.csv.gz |  112 | 6f77daba007a643bdff4eae10de5bed3 | Mon, 11 Sep 2017 18:13:07 GMT |
+----------------------------------+------+----------------------------------+-------------------------------+

-- Example 9701
GET @mystage/unload/data_0_0_0.csv.gz file:///data/unload;

-- Example 9702
GET @mystage/unload/data_0_0_0.csv.gz file://C:\data\unload;

-- Example 9703
COPY INTO @%mytable/unload/ from mytable FILE_FORMAT = (FORMAT_NAME = 'my_csv_unload_format' COMPRESSION = NONE);

-- Example 9704
LIST @%mytable;

+-----------------------+------+----------------------------------+-------------------------------+
| name                  | size | md5                              | last_modified                 |
|-----------------------+------+----------------------------------+-------------------------------|
| unload/data_0_0_0.csv |   96 | 29918f18bcb35e7b6b628ca41024236c | Mon, 11 Sep 2017 17:45:20 GMT |
+-----------------------+------+----------------------------------+-------------------------------+

-- Example 9705
GET @%mytable/unload/data_0_0_0.csv file:///data/unload;

-- Example 9706
GET @%mytable/unload/data_0_0_0.csv file://C:\data\unload;

-- Example 9707
COPY INTO @~/unload/ from mytable FILE_FORMAT = (FORMAT_NAME = 'my_csv_unload_format' COMPRESSION = NONE);

-- Example 9708
LIST @~;

+-----------------------+------+----------------------------------+-------------------------------+
| name                  | size | md5                              | last_modified                 |
|-----------------------+------+----------------------------------+-------------------------------|
| unload/data_0_0_0.csv |   96 | 94a306c55733b95a0887511ff355936b | Mon, 11 Sep 2017 17:25:07 GMT |
+-----------------------+------+----------------------------------+-------------------------------+

-- Example 9709
GET @~/unload/data_0_0_0.csv file:///data/unload;

-- Example 9710
GET @~/unload/data_0_0_0.csv file://C:\data\unload;

-- Example 9711
CREATE OR REPLACE STAGE my_ext_unload_stage URL='s3://unload/files/'
  STORAGE_INTEGRATION = s3_int
  FILE_FORMAT = my_csv_unload_format;

-- Example 9712
COPY INTO @my_ext_unload_stage/d1 from mytable;

-- Example 9713
COPY INTO 's3://mybucket/unload/'
  FROM mytable
  STORAGE_INTEGRATION = s3_int;

-- Example 9714
CREATE OR REPLACE STAGE my_ext_unload_stage
  URL='gcs://mybucket/unload'
  STORAGE_INTEGRATION = gcs_int
  FILE_FORMAT = my_csv_unload_format;

-- Example 9715
COPY INTO @my_ext_unload_stage/d1
FROM mytable;

-- Example 9716
COPY INTO 'gcs://mybucket/unload/'
  FROM mytable
  STORAGE_INTEGRATION = gcs_int;

-- Example 9717
CREATE OR REPLACE STAGE my_ext_unload_stage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/unload'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPxX0jzYfIamtnJEUTHwq80Au6NbSgPH5r4BDDwOaO8=')
  FILE_FORMAT = my_csv_unload_format;

-- Example 9718
COPY INTO @my_ext_unload_stage/d1 from mytable;

-- Example 9719
COPY INTO 'azure://myaccount.blob.core.windows.net/mycontainer/unload/' FROM mytable STORAGE_INTEGRATION = myint;

-- Example 9720
SELECT * FROM projects ORDER BY project_ID;
+------------+------------------+
| PROJECT_ID | PROJECT_NAME     |
|------------+------------------|
|       1000 | COVID-19 Vaccine |
|       1001 | Malaria Vaccine  |
|       1002 | NewProject       |
+------------+------------------+

-- Example 9721
SELECT * FROM employees ORDER BY employee_ID;
+-------------+-----------------+------------+
| EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|-------------+-----------------+------------|
|    10000001 | Terry Smith     | 1000       |
|    10000002 | Maria Inverness | 1000       |
|    10000003 | Pat Wang        | 1001       |
|    10000004 | NewEmployee     | NULL       |
+-------------+-----------------+------------+

-- Example 9722
SELECT p.project_ID, project_name, employee_ID, employee_name, e.project_ID
    FROM projects AS p JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------+------------------+-------------+-----------------+------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|------------+------------------+-------------+-----------------+------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     | 1000       |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness | 1000       |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        | 1001       |
+------------+------------------+-------------+-----------------+------------+

-- Example 9723
table1 join (table2 join table 3)

-- Example 9724
SELECT p.project_ID, project_name, employee_ID, employee_name, e.project_ID
    FROM projects AS p INNER JOIN employees AS e
        ON e.project_id = p.project_id
    ORDER BY p.project_ID, e.employee_ID;
+------------+------------------+-------------+-----------------+------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|------------+------------------+-------------+-----------------+------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     | 1000       |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness | 1000       |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        | 1001       |
+------------+------------------+-------------+-----------------+------------+

-- Example 9725
SELECT p.project_name, e.employee_name
    FROM projects AS p LEFT OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NewProject       | NULL            |
+------------------+-----------------+

-- Example 9726
SELECT p.project_name, e.employee_name
    FROM projects AS p RIGHT OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NULL             | NewEmployee     |
+------------------+-----------------+

-- Example 9727
SELECT p.project_name, e.employee_name
    FROM projects AS p FULL OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NewProject       | NULL            |
| NULL             | NewEmployee     |
+------------------+-----------------+

-- Example 9728
SELECT p.project_name, e.employee_name
    FROM projects AS p CROSS JOIN employees AS e
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Pat Wang        |
| COVID-19 Vaccine | NewEmployee     |
| Malaria Vaccine  | Terry Smith     |
| Malaria Vaccine  | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
| Malaria Vaccine  | NewEmployee     |
| NewProject       | Terry Smith     |
| NewProject       | Maria Inverness |
| NewProject       | Pat Wang        |
| NewProject       | NewEmployee     |
+------------------+-----------------+

-- Example 9729
SELECT p.project_name, e.employee_name
    FROM projects AS p CROSS JOIN employees AS e
    WHERE e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
+------------------+-----------------+

-- Example 9730
SELECT p.project_name, e.employee_name
    FROM projects AS p INNER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
+------------------+-----------------+

-- Example 9731
SELECT *
    FROM projects NATURAL JOIN employees
    ORDER BY employee_ID;
+------------+------------------+-------------+-----------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   |
|------------+------------------+-------------+-----------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        |
+------------+------------------+-------------+-----------------+

-- Example 9732
-- Uncorrelated subquery:
SELECT c1, c2
  FROM table1 WHERE c1 = (SELECT MAX(x) FROM table2);

-- Correlated subquery:
SELECT c1, c2
  FROM table1 WHERE c1 = (SELECT x FROM table2 WHERE y = table1.c2);

-- Example 9733
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p
  WHERE p.annual_wage < (SELECT per_capita_GDP
                           FROM international_GDP
                           WHERE name = 'Brazil');

-- Example 9734
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p
  WHERE p.annual_wage < (SELECT MAX(per_capita_GDP)
                           FROM international_GDP i
                           WHERE p.country = i.name);

-- Example 9735
SELECT employee_id
FROM employees
WHERE salary = (SELECT max(salary) FROM employees);

-- Example 9736
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p INNER JOIN (SELECT name, per_capita_GDP
                              FROM international_GDP
                              WHERE per_capita_GDP >= 10000.0) AS pcg
    ON pcg.per_capita_GDP = p.annual_wage AND p.country = pcg.name;

-- Example 9737
CREATE OR REPLACE TABLE managers  (title VARCHAR, employee_ID INTEGER);

-- Example 9738
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 9739
INSERT INTO managers (title, employee_ID) VALUES
    ('President', 1);
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('Vice President Engineering', 10, 1),
    ('Vice President HR', 20, 1);

-- Example 9740
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 9741
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 9742
SELECT 
        employees.title, 
        employees.employee_ID, 
        managers.employee_ID AS MANAGER_ID, 
        managers.title AS "MANAGER TITLE"
    FROM employees, managers
    WHERE employees.manager_ID = managers.employee_ID
    ORDER BY employees.title;
+----------------------------+-------------+------------+---------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MANAGER TITLE |
|----------------------------+-------------+------------+---------------|
| Vice President Engineering |          10 |          1 | President     |
| Vice President HR          |          20 |          1 | President     |
+----------------------------+-------------+------------+---------------+

-- Example 9743
SELECT
     emps.title,
     emps.employee_ID,
     mgrs.employee_ID AS MANAGER_ID, 
     mgrs.title AS "MANAGER TITLE"
  FROM employees AS emps LEFT OUTER JOIN employees AS mgrs
    ON emps.manager_ID = mgrs.employee_ID
  ORDER BY mgrs.employee_ID NULLS FIRST, emps.employee_ID;
+----------------------------+-------------+------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MANAGER TITLE              |
|----------------------------+-------------+------------+----------------------------|
| President                  |           1 |       NULL | NULL                       |
| Vice President Engineering |          10 |          1 | President                  |
| Vice President HR          |          20 |          1 | President                  |
| Programmer                 |         100 |         10 | Vice President Engineering |
| QA Engineer                |         101 |         10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 | Vice President HR          |
+----------------------------+-------------+------------+----------------------------+

-- Example 9744
SELECT indent(LEVEL) || employee_ID, manager_ID, title
  FROM employees
    -- This sub-clause specifies the record at the top of the hierarchy,
    -- but does not allow additional derived fields, such as the sort key.
    START WITH TITLE = 'President'
    CONNECT BY ...

WITH RECURSIVE current_layer
   (employee_ID, manager_ID, sort_key) AS (
     -- This allows us to add columns, such as sort_key, that are not part
     -- of the employees table.
     SELECT employee_ID, manager_ID, employee_ID AS sort_key
     ...
     )

-- Example 9745
WITH
    my_cte (cte_col_1, cte_col_2) AS (
        SELECT col_1, col_2
            FROM ...
    )
SELECT ... FROM my_cte;

-- Example 9746
WITH [ RECURSIVE ] <cte_name> AS
(
  <anchor_clause> UNION ALL <recursive_clause>
)
SELECT ... FROM ...;

-- Example 9747
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 9748
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 9749
SELECT
     emps.title,
     emps.employee_ID,
     mgrs.employee_ID AS MANAGER_ID, 
     mgrs.title AS "MANAGER TITLE"
  FROM employees AS emps LEFT OUTER JOIN employees AS mgrs
    ON emps.manager_ID = mgrs.employee_ID
  ORDER BY mgrs.employee_ID NULLS FIRST, emps.employee_ID;
+----------------------------+-------------+------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MANAGER TITLE              |
|----------------------------+-------------+------------+----------------------------|
| President                  |           1 |       NULL | NULL                       |
| Vice President Engineering |          10 |          1 | President                  |
| Vice President HR          |          20 |          1 | President                  |
| Programmer                 |         100 |         10 | Vice President Engineering |
| QA Engineer                |         101 |         10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 | Vice President HR          |
+----------------------------+-------------+------------+----------------------------+

-- Example 9750
WITH RECURSIVE managers                                     -- Line 1
    (indent, employee_ID, manager_ID, employee_title)       -- Line 2
  AS                                                        -- Line 3
    (                                                       -- Line 4
                                                            -- Line 5
      SELECT '' AS indent,                                  -- Line 6
             employee_ID,                                   -- Line 7
             manager_ID,                                    -- Line 8
             title AS employee_title                        -- Line 9
        FROM employees                                      -- Line 10
        WHERE title = 'President'                           -- Line 11
                                                            -- Line 12
        UNION ALL                                           -- Line 13
                                                            -- Line 14
        SELECT indent || '--- ',                            -- Line 15
               employees.employee_ID,                       -- Line 16
               employees.manager_ID,                        -- Line 17
               employees.title                              -- Line 18
          FROM employees JOIN managers                      -- Line 19
            ON employees.manager_ID = managers.employee_ID  -- Line 20
    )                                                       -- Line 21
                                                            -- Line 22
SELECT indent || employee_title AS Title,                   -- Line 23
       employee_ID,                                         -- Line 24
       manager_ID                                           -- Line 25
  FROM managers;                                            -- Line 26

-- Example 9751
CREATE OR REPLACE FUNCTION skey(ID VARCHAR)
  RETURNS VARCHAR
  AS
  $$
    SUBSTRING('0000' || ID::VARCHAR, -4) || ' '
  $$
  ;

-- Example 9752
SELECT skey(12);
+----------+
| SKEY(12) |
|----------|
| 0012     |
+----------+

-- Example 9753
WITH RECURSIVE managers 
      -- Column list of the "view"
      (indent, employee_ID, manager_ID, employee_title, sort_key) 
    AS 
      -- Common Table Expression
      (
        -- Anchor Clause
        SELECT '' AS indent, 
            employee_ID, manager_ID, title AS employee_title, skey(employee_ID)
          FROM employees
          WHERE title = 'President'

        UNION ALL

        -- Recursive Clause
        SELECT indent || '--- ',
            employees.employee_ID, employees.manager_ID, employees.title, 
            sort_key || skey(employees.employee_ID)
          FROM employees JOIN managers 
            ON employees.manager_ID = managers.employee_ID
      )

  -- This is the "main select".
  SELECT 
         indent || employee_title AS Title, employee_ID, 
         manager_ID, 
         sort_key
    FROM managers
    ORDER BY sort_key
  ;
+----------------------------------+-------------+------------+-----------------+
| TITLE                            | EMPLOYEE_ID | MANAGER_ID | SORT_KEY        |
|----------------------------------+-------------+------------+-----------------|
| President                        |           1 |       NULL | 0001            |
| --- Vice President Engineering   |          10 |          1 | 0001 0010       |
| --- --- Programmer               |         100 |         10 | 0001 0010 0100  |
| --- --- QA Engineer              |         101 |         10 | 0001 0010 0101  |
| --- Vice President HR            |          20 |          1 | 0001 0020       |
| --- --- Health Insurance Analyst |         200 |         20 | 0001 0020 0200  |
+----------------------------------+-------------+------------+-----------------+

-- Example 9754
WITH RECURSIVE managers 
      -- Column names for the "view"/CTE
      (employee_ID, manager_ID, employee_title, mgr_title) 
    AS
      -- Common Table Expression
      (

        -- Anchor Clause
        SELECT employee_ID, manager_ID, title AS employee_title, NULL AS mgr_title
          FROM employees
          WHERE title = 'President'

        UNION ALL

        -- Recursive Clause
        SELECT 
            employees.employee_ID, employees.manager_ID, employees.title, managers.employee_title AS mgr_title
          FROM employees JOIN managers 
            ON employees.manager_ID = managers.employee_ID
      )

  -- This is the "main select".
  SELECT employee_title AS Title, employee_ID, manager_ID, mgr_title
    FROM managers
    ORDER BY manager_id NULLS FIRST, employee_ID
  ;
+----------------------------+-------------+------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MGR_TITLE                  |
|----------------------------+-------------+------------+----------------------------|
| President                  |           1 |       NULL | NULL                       |
| Vice President Engineering |          10 |          1 | President                  |
| Vice President HR          |          20 |          1 | President                  |
| Programmer                 |         100 |         10 | Vice President Engineering |
| QA Engineer                |         101 |         10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 | Vice President HR          |
+----------------------------+-------------+------------+----------------------------+

-- Example 9755
WITH RECURSIVE t(n) AS
    (
    SELECT 1
    UNION ALL
    SELECT N + 1 FROM t
   )
 SELECT n FROM t LIMIT 10;

-- Example 9756
CREATE TABLE employees (employee_ID INT, manager_ID INT, ...);
INSERT INTO employees (employee_ID, manager_ID) VALUES
        (1, NULL),
        (2, 1);

WITH cte_name (employee_ID, manager_ID, ...) AS
  (
     -- Anchor Clause
     SELECT employee_ID, manager_ID FROM table1
     UNION ALL
     SELECT manager_ID, employee_ID   -- <<< WRONG
         FROM table1 JOIN cte_name
           ON table1.manager_ID = cte_name.employee_ID
  )
SELECT ...

-- Example 9757
employee_ID  manager_ID
-----------  ---------
      1         NULL

-- Example 9758
employee_ID  manager_ID
-----------  ----------
       1         NULL

-- Example 9759
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 9760
table1.employee_ID  table1.manager_ID  cte.employee_ID  cte.manager_ID
-----------------   -----------------  ---------------  --------------
 ...
       2                   1                 1                NULL
 ...

-- Example 9761
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 9762
employee_ID  manager_ID
-----------  ----------
 ...
       1         2        -- Because manager and employee IDs reversed
 ...

