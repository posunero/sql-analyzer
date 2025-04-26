-- Example 11102
SELECT * 
    FROM employee_hierarchy 
    ORDER BY employee_ID;
+----------------------------+-------------+------------+-----------------------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MGR_EMP_ID (SHOULD BE SAME) | MGR TITLE                  |
|----------------------------+-------------+------------+-----------------------------+----------------------------|
| President                  |           1 |       NULL |                        NULL | President                  |
| Vice President Engineering |          10 |          1 |                           1 | President                  |
| Vice President HR          |          20 |          1 |                           1 | President                  |
| Programmer                 |         100 |         10 |                          10 | Vice President Engineering |
| QA Engineer                |         101 |         10 |                          10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 |                          20 | Vice President HR          |
+----------------------------+-------------+------------+-----------------------------+----------------------------+

-- Example 11103
CREATE RECURSIVE VIEW employee_hierarchy_02 (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_02.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_02.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_02
        WHERE employee_hierarchy_02.employee_ID = employees.manager_ID
);

-- Example 11104
SELECT * 
    FROM employee_hierarchy_02 
    ORDER BY employee_ID;
+----------------------------+-------------+------------+-----------------------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MGR_EMP_ID (SHOULD BE SAME) | MGR TITLE                  |
|----------------------------+-------------+------------+-----------------------------+----------------------------|
| President                  |           1 |       NULL |                        NULL | President                  |
| Vice President Engineering |          10 |          1 |                           1 | President                  |
| Vice President HR          |          20 |          1 |                           1 | President                  |
| Programmer                 |         100 |         10 |                          10 | Vice President Engineering |
| QA Engineer                |         101 |         10 |                          10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 |                          20 | Vice President HR          |
+----------------------------+-------------+------------+-----------------------------+----------------------------+

-- Example 11105
CREATE OR ALTER TABLE my_table(a INT);

-- Example 11106
CREATE OR ALTER VIEW v2(one)
  AS SELECT a FROM my_table;

-- Example 11107
CREATE OR ALTER VIEW v2(one)
  COMMENT = 'fff'
  CHANGE_TRACKING = true
  AS SELECT a FROM my_table;

-- Example 11108
CREATE OR ALTER VIEW v2(one COMMENT 'bar')
  COMMENT = 'foo'
  AS SELECT a FROM my_table;

-- Example 11109
CREATE OR ALTER VIEW v2(one COMMENT 'bar')
  CHANGE_TRACKING = true
  AS SELECT a FROM my_table;

-- Example 11110
WITH
    my_cte (cte_col_1, cte_col_2) AS (
        SELECT col_1, col_2
            FROM ...
    )
SELECT ... FROM my_cte;

-- Example 11111
WITH [ RECURSIVE ] <cte_name> AS
(
  <anchor_clause> UNION ALL <recursive_clause>
)
SELECT ... FROM ...;

-- Example 11112
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 11113
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 11114
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

-- Example 11115
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

-- Example 11116
CREATE OR REPLACE FUNCTION skey(ID VARCHAR)
  RETURNS VARCHAR
  AS
  $$
    SUBSTRING('0000' || ID::VARCHAR, -4) || ' '
  $$
  ;

-- Example 11117
SELECT skey(12);
+----------+
| SKEY(12) |
|----------|
| 0012     |
+----------+

-- Example 11118
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

-- Example 11119
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

-- Example 11120
WITH RECURSIVE t(n) AS
    (
    SELECT 1
    UNION ALL
    SELECT N + 1 FROM t
   )
 SELECT n FROM t LIMIT 10;

-- Example 11121
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

-- Example 11122
employee_ID  manager_ID
-----------  ---------
      1         NULL

-- Example 11123
employee_ID  manager_ID
-----------  ----------
       1         NULL

-- Example 11124
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 11125
table1.employee_ID  table1.manager_ID  cte.employee_ID  cte.manager_ID
-----------------   -----------------  ---------------  --------------
 ...
       2                   1                 1                NULL
 ...

-- Example 11126
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 11127
employee_ID  manager_ID
-----------  ----------
 ...
       1         2        -- Because manager and employee IDs reversed
 ...

-- Example 11128
employee_ID  manager_ID
-----------  ----------
       1         2

-- Example 11129
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 11130
table1.employee_ID  table1.manager_ID  cte.employee_ID  cte.manager_ID
-----------------   -----------------  ---------------  --------------
 ...
       2                   1                 1                2
 ...

-- Example 11131
employee_ID  manager_ID
-----------  ----------
 ...
       2         1
 ...

-- Example 11132
employee_ID  manager_ID
-----------  ----------
 ...
       1         2        -- Because manager and employee IDs reversed
 ...

-- Example 11133
CREATE [ OR REPLACE ] [ SECURE ] [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | VOLATILE } ] [ RECURSIVE ] VIEW [ IF NOT EXISTS ] <name>
  [ ( <column_list> ) ]
  [ <col1> [ WITH ] MASKING POLICY <policy_name> [ USING ( <col1> , <cond_col1> , ... ) ]
           [ WITH ] PROJECTION POLICY <policy_name>
           [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ , <col2> [ ... ] ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> [ ENTITY KEY ( <col_name> [ , <col_name> ... ] ) ] ]
  [ [ WITH ] JOIN POLICY <policy_name> [ ALLOWED JOIN KEYS ( <col_name> [ , ... ] ) ] ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  AS <select_statement>

-- Example 11134
CREATE OR ALTER [ SECURE ] [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | VOLATILE } ] [ RECURSIVE ] VIEW <name>
  [ ( <column_list> ) ]
  [ CHANGE_TRACKING =  { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  AS <select_statement>

-- Example 11135
CREATE VIEW v1 (pre_tax_profit, taxes, after_tax_profit) AS
    SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
    FROM table1;

-- Example 11136
CREATE VIEW v1 (pre_tax_profit COMMENT 'revenue minus cost',
                taxes COMMENT 'assumes taxes are a fixed percentage of profit',
                after_tax_profit)
    AS
    SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
    FROM table1;

-- Example 11137
CREATE OR REPLACE FORCE VIEW ...

-- Example 11138
CREATE VIEW myview COMMENT='Test view' AS SELECT col1, col2 FROM mytable;

SHOW VIEWS;

+---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------+
| created_on                      | name              | reserved | database_name | schema_name | owner    | comment   | text                                                                     |
|---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------|
| Thu, 19 Jan 2017 15:00:37 -0800 | MYVIEW            |          | MYTEST1       | PUBLIC      | SYSADMIN | Test view | CREATE VIEW myview COMMENT='Test view' AS SELECT col1, col2 FROM mytable |
+---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------+

-- Example 11139
CREATE OR REPLACE SECURE VIEW myview COMMENT='Test secure view' AS SELECT col1, col2 FROM mytable;

SELECT is_secure FROM information_schema.views WHERE table_name = 'MYVIEW';

-- Example 11140
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 11141
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 11142
CREATE VIEW employee_hierarchy (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
   WITH RECURSIVE employee_hierarchy_cte (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_cte.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_cte.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_cte
       WHERE employee_hierarchy_cte.employee_ID = employees.manager_ID
   )
   SELECT * 
      FROM employee_hierarchy_cte
);

-- Example 11143
SELECT * 
    FROM employee_hierarchy 
    ORDER BY employee_ID;
+----------------------------+-------------+------------+-----------------------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MGR_EMP_ID (SHOULD BE SAME) | MGR TITLE                  |
|----------------------------+-------------+------------+-----------------------------+----------------------------|
| President                  |           1 |       NULL |                        NULL | President                  |
| Vice President Engineering |          10 |          1 |                           1 | President                  |
| Vice President HR          |          20 |          1 |                           1 | President                  |
| Programmer                 |         100 |         10 |                          10 | Vice President Engineering |
| QA Engineer                |         101 |         10 |                          10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 |                          20 | Vice President HR          |
+----------------------------+-------------+------------+-----------------------------+----------------------------+

-- Example 11144
CREATE RECURSIVE VIEW employee_hierarchy_02 (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_02.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_02.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_02
        WHERE employee_hierarchy_02.employee_ID = employees.manager_ID
);

-- Example 11145
SELECT * 
    FROM employee_hierarchy_02 
    ORDER BY employee_ID;
+----------------------------+-------------+------------+-----------------------------+----------------------------+
| TITLE                      | EMPLOYEE_ID | MANAGER_ID | MGR_EMP_ID (SHOULD BE SAME) | MGR TITLE                  |
|----------------------------+-------------+------------+-----------------------------+----------------------------|
| President                  |           1 |       NULL |                        NULL | President                  |
| Vice President Engineering |          10 |          1 |                           1 | President                  |
| Vice President HR          |          20 |          1 |                           1 | President                  |
| Programmer                 |         100 |         10 |                          10 | Vice President Engineering |
| QA Engineer                |         101 |         10 |                          10 | Vice President Engineering |
| Health Insurance Analyst   |         200 |         20 |                          20 | Vice President HR          |
+----------------------------+-------------+------------+-----------------------------+----------------------------+

-- Example 11146
CREATE OR ALTER TABLE my_table(a INT);

-- Example 11147
CREATE OR ALTER VIEW v2(one)
  AS SELECT a FROM my_table;

-- Example 11148
CREATE OR ALTER VIEW v2(one)
  COMMENT = 'fff'
  CHANGE_TRACKING = true
  AS SELECT a FROM my_table;

-- Example 11149
CREATE OR ALTER VIEW v2(one COMMENT 'bar')
  COMMENT = 'foo'
  AS SELECT a FROM my_table;

-- Example 11150
CREATE OR ALTER VIEW v2(one COMMENT 'bar')
  CHANGE_TRACKING = true
  AS SELECT a FROM my_table;

-- Example 11151
ALTER VIEW [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER VIEW [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER VIEW [ IF EXISTS ] <name> UNSET COMMENT

ALTER VIEW [ IF EXISTS ] <name> SET SECURE

ALTER VIEW [ IF EXISTS ] <name> SET CHANGE_TRACKING =  { TRUE | FALSE }

ALTER VIEW <name> UNSET SECURE

ALTER VIEW <name> dataMetricFunctionAction

ALTER VIEW [ IF EXISTS ] <name> dataGovnPolicyTagAction

-- Example 11152
dataMetricFunctionAction ::=

    SET DATA_METRIC_SCHEDULE = {
        '<num> MINUTE'
      | 'USING CRON <expr> <time_zone>'
      | 'TRIGGER_ON_CHANGES'
    }

  | UNSET DATA_METRIC_SCHEDULE

  | { ADD | DROP } DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] )
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) ]

  | MODIFY DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME }
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME } ]

-- Example 11153
dataGovnPolicyTagAction ::=
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
      SET AGGREGATION POLICY <policy_name>
        [ ENTITY KEY ( <col_name> [, ... ] ) ]
        [ FORCE ]
    | UNSET AGGREGATION POLICY
  }
  |
  {
      SET JOIN POLICY <policy_name>
        [ FORCE ]
    | UNSET JOIN POLICY
  }
  |
  ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
    [ [ WITH ] MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] ]
    [ [ WITH ] PROJECTION POLICY <policy_name> ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>'
          [ , <tag_name> = '<tag_value>' , ... ] ) ]
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET PROJECTION POLICY <policy_name>
          [ FORCE ]
      | UNSET PROJECTION POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                   , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 11154
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 11155
ALTER VIEW view1 RENAME TO view2;

-- Example 11156
ALTER VIEW view1 SET SECURE;

-- Example 11157
ALTER VIEW view1 UNSET SECURE;

-- Example 11158
-- single column

ALTER VIEW user_info_v MODIFY COLUMN ssn_number SET MASKING POLICY ssn_mask_v;

-- multiple columns

ALTER VIEW user_info_v MODIFY
  COLUMN ssn_number SET MASKING POLICY ssn_mask_v,
  COLUMN dob SET MASKING POLICY dob_mask_v
  ;

-- Example 11159
-- single column

ALTER VIEW user_info_v MODIFY COLUMN ssn_number UNSET MASKING POLICY;

-- multiple columns

ALTER VIEW user_info_v MODIFY
  COLUMN ssn_number UNSET MASKING POLICY,
  COLUMN dob UNSET MASKING POLICY
  ;

-- Example 11160
ALTER VIEW v1
  ADD ROW ACCESS POLICY rap_v1 ON (empl_id);

-- Example 11161
ALTER VIEW v1
  DROP ROW ACCESS POLICY rap_v1;

-- Example 11162
ALTER VIEW v1
  DROP ROW ACCESS POLICY rap_v1_version_1,
  ADD ROW ACCESS POLICY rap_v1_version_2 ON (empl_id);

-- Example 11163
ALTER VIEW join_view
  SET JOIN POLICY jp1;

-- Example 11164
ALTER MATERIALIZED VIEW <name>
  {
  RENAME TO <new_name>                     |
  CLUSTER BY ( <expr1> [, <expr2> ... ] )  |
  DROP CLUSTERING KEY                      |
  SUSPEND RECLUSTER                        |
  RESUME RECLUSTER                         |
  SUSPEND                                  |
  RESUME                                   |
  SET {
    [ SECURE ]
    [ COMMENT = '<comment>' ]
    }                                      |
  UNSET {
    SECURE                                 |
    COMMENT
    }
  }

ALTER MATERIALIZED VIEW
  SET DATA_METRIC_SCHEDULE = {
      '<num> MINUTE'
    | 'USING CRON <expr> <time_zone>'
  }

ALTER MATERIALIZED VIEW UNSET DATA_METRIC_SCHEDULE

-- Example 11165
Failure during expansion of view 'MV1':
  SQL compilation error: Materialized View MV1 is invalid.
  Invalidation reason: Marked Materialized View as invalid manually.

-- Example 11166
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 11167
ALTER MATERIALIZED VIEW table1_MV RENAME TO my_mv;

-- Example 11168
ALTER MATERIALIZED VIEW my_mv CLUSTER BY(i);

