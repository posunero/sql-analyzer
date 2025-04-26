-- Example 11035
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE mydb TO ROLE role1;

-- Example 11036
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ht_schema TO ROLE ht_role;

-- Example 11037
GRANT SELECT ON ALL TABLES IN SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 11038
GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(number)
  TO DATABASE ROLE mydb.dr1;

GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(string)
  TO DATABASE ROLE mydb.dr1;

-- Example 11039
GRANT USAGE ON PROCEDURE mydb.myschema.myprocedure(number)
  TO DATABASE ROLE mydb.dr1;

-- Example 11040
GRANT CREATE MATERIALIZED VIEW ON SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 11041
GRANT SELECT,INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 11042
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE mydb
  TO DATABASE ROLE mydb.dr1;

-- Example 11043
USE ROLE ACCOUNTADMIN;

GRANT CREATE SNOWFLAKE.CORE.BUDGET ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_admin;

-- Example 11044
-- Must do the SHOW first to produce the full result set.
SHOW WAREHOUSES;
-- result_scan() helps to customize a report using the result set from the previous query.
SELECT "name", "state", "size", "max_cluster_count", "started_clusters", "type"
  FROM TABLE(result_scan(-1))
  WHERE "state" IN ('STARTED','SUSPENDED')
  ORDER BY "type" DESC, "name";

-- Example 11045
CREATE WAREHOUSE mywh WITH MAX_CLUSTER_COUNT = 2, SCALING_POLICY = 'STANDARD';
ALTER WAREHOUSE mywh SET SCALING_POLICY = 'ECONOMY';

-- Example 11046
SELECT warehouse_name, COUNT(query_id) AS num_eligible_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time >= '2024-06-01 00:00'::TIMESTAMP
  AND end_time <= '2024-06-07 00:00'::TIMESTAMP
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

-- Example 11047
CREATE [ OR REPLACE ] WAREHOUSE [ IF NOT EXISTS ] <name>
       [ [ WITH ] objectProperties ]
       [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
       [ objectParams ]

-- Example 11048
objectProperties ::=
  WAREHOUSE_TYPE = { STANDARD | 'SNOWPARK-OPTIMIZED' }
  WAREHOUSE_SIZE = { XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | XXXLARGE | X4LARGE | X5LARGE | X6LARGE }
  RESOURCE_CONSTRAINT = { MEMORY_1X | MEMORY_1X_x86 | MEMORY_16X | MEMORY_16X_x86 | MEMORY_64X | MEMORY_64X_x86 }
  MAX_CLUSTER_COUNT = <num>
  MIN_CLUSTER_COUNT = <num>
  SCALING_POLICY = { STANDARD | ECONOMY }
  AUTO_SUSPEND = { <num> | NULL }
  AUTO_RESUME = { TRUE | FALSE }
  INITIALLY_SUSPENDED = { TRUE | FALSE }
  RESOURCE_MONITOR = <monitor_name>
  COMMENT = '<string_literal>'
  ENABLE_QUERY_ACCELERATION = { TRUE | FALSE }
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <num>

-- Example 11049
objectParams ::=
  MAX_CONCURRENCY_LEVEL = <num>
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>

-- Example 11050
CREATE OR ALTER WAREHOUSE <name>
     [ [ WITH ] objectProperties ]
     [ objectParams ]

objectProperties ::=
  WAREHOUSE_TYPE = { STANDARD | 'SNOWPARK-OPTIMIZED' }
  WAREHOUSE_SIZE = { XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | XXXLARGE | X4LARGE | X5LARGE | X6LARGE }
  RESOURCE_CONSTRAINT = { MEMORY_1X | MEMORY_1X_x86 | MEMORY_16X | MEMORY_16X_x86 | MEMORY_64X | MEMORY_64X_x86 }
  MAX_CLUSTER_COUNT = <num>
  MIN_CLUSTER_COUNT = <num>
  SCALING_POLICY = { STANDARD | ECONOMY }
  AUTO_SUSPEND = { <num> | NULL }
  AUTO_RESUME = { TRUE | FALSE }
  INITIALLY_SUSPENDED = { TRUE | FALSE }
  RESOURCE_MONITOR = <monitor_name>
  COMMENT = '<string_literal>'
  ENABLE_QUERY_ACCELERATION = { TRUE | FALSE }
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <num>

objectParams ::=
  MAX_CONCURRENCY_LEVEL = <num>
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>

-- Example 11051
SET current_wh_name = (SELECT CURRENT_WAREHOUSE());

CREATE OR REPLACE WAREHOUSE my_wh
  WAREHOUSE_SIZE = 'XSMALL';

USE WAREHOUSE IDENTIFIER($current_wh_name);

-- Example 11052
CREATE OR REPLACE WAREHOUSE my_wh WITH WAREHOUSE_SIZE='X-LARGE';

-- Example 11053
CREATE OR REPLACE WAREHOUSE my_wh WAREHOUSE_SIZE=LARGE INITIALLY_SUSPENDED=TRUE;

-- Example 11054
CREATE WAREHOUSE so_warehouse WITH
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
  WAREHOUSE_SIZE = xlarge
  RESOURCE_CONSTRAINT = 'MEMORY_16X_x86';

-- Example 11055
CREATE OR ALTER WAREHOUSE so_warehouse
  WAREHOUSE_TYPE = 'SNOWPARK_OPTIMIZED'
  WAREHOUSE_SIZE = 'X-LARGE'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86'
  AUTO_RESUME = TRUE
  COMMENT = 'Snowpark warehouse for ingestion';

-- Example 11056
CREATE OR ALTER WAREHOUSE so_warehouse
  WAREHOUSE_TYPE = 'SNOWPARK_OPTIMIZED'
  WAREHOUSE_SIZE = 'X-LARGE'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86'
  AUTO_RESUME = FALSE
  COMMENT = 'Snowpark warehouse for ingestion (disabled for auto-resume)';

-- Example 11057
ALTER SESSION SET TIMEZONE = UTC;

-- Example 11058
SELECT warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE start_time >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1
  ORDER BY 2 DESC;

-- Example 11059
ALTER TABLE t1 RECLUSTER;

-- Example 11060
ALTER TABLE t2 RECLUSTER WHERE CREATE_DATE BETWEEN ('2016-01-01') AND ('2016-01-07');

-- Example 11061
CREATE TABLE <name> ( <col1_name> <col1_type>    [ NOT NULL ] { inlineUniquePK | inlineFK }
                     [ , <col2_name> <col2_type> [ NOT NULL ] { inlineUniquePK | inlineFK } ]
                     [ , ... ] )

ALTER TABLE <name> ADD COLUMN <col_name> <col_type> [ NOT NULL ] { inlineUniquePK | inlineFK }

-- Example 11062
inlineUniquePK ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY }
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]

-- Example 11063
inlineFK :=
  [ CONSTRAINT <constraint_name> ]
  [ FOREIGN KEY ]
  REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  [ MATCH { FULL | SIMPLE | PARTIAL } ]
  [ ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
       [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ] ]
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]

-- Example 11064
CREATE TABLE <name> ... ( <col1_name> <col1_type>
                         [ , <col2_name> <col2_type> , ... ]
                         [ , { outoflineUniquePK | outoflineFK } ]
                         [ , { outoflineUniquePK | outoflineFK } ]
                         [ , ... ] )

ALTER TABLE <name> ... ADD { outoflineUniquePK | outoflineFK }

-- Example 11065
outoflineUniquePK ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY } ( <col_name> [ , <col_name> , ... ] )
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]
  [ COMMENT '<string_literal>' ]

-- Example 11066
outoflineFK :=
  [ CONSTRAINT <constraint_name> ]
  FOREIGN KEY ( <col_name> [ , <col_name> , ... ] )
  REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  [ MATCH { FULL | SIMPLE | PARTIAL } ]
  [ ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
       [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ] ]
  [ [ NOT ] ENFORCED ]
  [ [ NOT ] DEFERRABLE ]
  [ INITIALLY { DEFERRED | IMMEDIATE } ]
  [ { ENABLE | DISABLE } ]
  [ { VALIDATE | NOVALIDATE } ]
  [ { RELY | NORELY } ]
  [ COMMENT '<string_literal>' ]

-- Example 11067
[ NOT ] ENFORCED
[ NOT ] DEFERRABLE
INITIALLY { DEFERRED | IMMEDIATE }
{ ENABLE | DISABLE }
{ VALIDATE | NOVALIDATE }
{ RELY | NORELY }

-- Example 11068
ALTER TABLE table_with_primary_key ALTER CONSTRAINT a_primary_key_constraint RELY;
ALTER TABLE table_with_foreign_key ALTER CONSTRAINT a_foreign_key_constraint RELY;

-- Example 11069
MATCH { FULL | SIMPLE | PARTIAL }
ON [ UPDATE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]
   [ DELETE { CASCADE | SET NULL | SET DEFAULT | RESTRICT | NO ACTION } ]

-- Example 11070
CREATE OR REPLACE TABLE uni (c1 INT, c2 int, CONSTRAINT uni1 UNIQUE(C1) COMMENT 'Unique column');

-- Example 11071
CREATE OR REPLACE TABLE uni (c1 INT UNIQUE COMMENT 'Unique column', c2 int);

-- Example 11072
COMMENT = 'My comment'

-- Example 11073
COMMENT 'My comment'

-- Example 11074
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 11075
GRANT REFERENCES ON TABLE <pk_table_name> TO ROLE <role_name>

REVOKE REFERENCES ON TABLE <pk_table_name> FROM ROLE <role_name>

-- Example 11076
CREATE TABLE table1 (col1 INTEGER NOT NULL);

-- Example 11077
ALTER TABLE table1 ADD COLUMN col2 VARCHAR NOT NULL;

-- Example 11078
ALTER TABLE table1 
  ADD COLUMN col3 VARCHAR NOT NULL CONSTRAINT uniq_col3 UNIQUE NOT ENFORCED;

-- Example 11079
CREATE TABLE table2 (
  col1 INTEGER NOT NULL,
  col2 INTEGER NOT NULL,
  CONSTRAINT pkey_1 PRIMARY KEY (col1, col2) NOT ENFORCED
);
CREATE TABLE table3 (
  col_a INTEGER NOT NULL,
  col_b INTEGER NOT NULL,
  CONSTRAINT fkey_1 FOREIGN KEY (col_a, col_b) REFERENCES table2 (col1, col2) NOT ENFORCED
);

-- Example 11080
CREATE OR REPLACE HYBRID TABLE HT2PK
  (col1 NUMBER(38,0) NOT NULL,
  col2 NUMBER(38,0) NOT NULL,
  col3 VARCHAR(16777216),
  CONSTRAINT PKEY_2 PRIMARY KEY (col1, col2) COMMENT 'Primary key on two columns');

SELECT constraint_name, table_name, constraint_type, enforced, comment
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE COMMENT IS NOT NULL;

-- Example 11081
+-----------------+------------+-----------------+----------+----------------------------+
| CONSTRAINT_NAME | TABLE_NAME | CONSTRAINT_TYPE | ENFORCED | COMMENT                    |
|-----------------+------------+-----------------+----------+----------------------------|
| PKEY_2          | HT2PK      | PRIMARY KEY     | YES      | Primary key on two columns |
+-----------------+------------+-----------------+----------+----------------------------+

-- Example 11082
SELECT constraint_name, table_name, constraint_type, enforced, comment
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE table_name LIKE 'HT%'
  ORDER BY table_name;

-- Example 11083
+-----------------------------------------------------+------------------------+-----------------+----------+----------------------------+
| CONSTRAINT_NAME                                     | TABLE_NAME             | CONSTRAINT_TYPE | ENFORCED | COMMENT                    |
|-----------------------------------------------------+------------------------+-----------------+----------+----------------------------|
| SYS_CONSTRAINT_da2e8533-5501-4862-ae42-0a7798d578eb | HT01                   | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_5b3c6d13-f607-4ef6-a147-0026bae98c71 | HT1                    | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_d5887706-0e3b-4d5b-8787-e3327cdf4851 | HT100                  | PRIMARY KEY     | YES      | NULL                       |
| PK1                                                 | HT1PK                  | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_f1d1e153-cc32-477c-9a24-5c049e40ca0a | HT239                  | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_fe27c4f3-23f6-4091-92c4-5acd53cc5029 | HT239                  | UNIQUE          | YES      | NULL                       |
| PKEY_2                                              | HT2PK                  | PRIMARY KEY     | YES      | Primary key on two columns |
| SYS_CONSTRAINT_0bd41d0f-11f7-4366-82a3-f03f31fcce7e | HT616                  | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_6124310b-5f50-4009-a5c0-dc1b5a89b0bc | HT616                  | UNIQUE          | YES      | NULL                       |
| SYS_CONSTRAINT_bf3d76ba-de1e-4227-954f-9f53de777ed4 | HT619                  | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_c97bfe9b-6098-4b8a-b796-e341071db72a | HT619                  | FOREIGN KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_6e02d776-1759-449e-aece-467aaaefcfc8 | HTFK                   | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_51118aaf-1ee6-4548-bc9a-f87e65d92528 | HTFK                   | FOREIGN KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_fe27c4f3-23f6-4091-92c4-5acd53cc5029 | HTLIKE                 | UNIQUE          | YES      | NULL                       |
| SYS_CONSTRAINT_f1d1e153-cc32-477c-9a24-5c049e40ca0a | HTLIKE                 | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_aad16788-491a-4e68-b0e3-30d48a33a1c1 | HTPK                   | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_0bdff17e-e90a-4929-99c5-98e3597e3069 | HTT1                   | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_39e9110f-7a72-454e-bfe2-0a26eca97e7c | HT_PRECIP              | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_6acd8274-04e7-4b22-b9ae-29185b979219 | HT_SENSOR_DATA_DEVICE1 | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_39e9110f-7a72-454e-bfe2-0a26eca97e7c | HT_WEATHER             | PRIMARY KEY     | YES      | NULL                       |
| SYS_CONSTRAINT_843d828a-900d-409e-a57d-8f27b602eccf | HT_WEATHER             | PRIMARY KEY     | YES      | NULL                       |
+-----------------------------------------------------+------------------------+-----------------+----------+----------------------------+

-- Example 11084
SELECT ...
    FROM my_table INNER JOIN my_materialized_view
        ON my_materialized_view.col1 = my_table.col1
    ...

-- Example 11085
CREATE TABLE <name> ... CLUSTER BY ( <expr1> [ , <expr2> ... ] )

-- Example 11086
-- cluster by base columns
CREATE OR REPLACE TABLE t1 (c1 DATE, c2 STRING, c3 NUMBER) CLUSTER BY (c1, c2);

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(C1, C2) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+

-- cluster by expressions
CREATE OR REPLACE TABLE t2 (c1 timestamp, c2 STRING, c3 NUMBER) CLUSTER BY (TO_DATE(C1), substring(c2, 0, 10));

SHOW TABLES LIKE 't2';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:07:51.307 -0700 | T2   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(CAST(C1 AS DATE), SUBSTRING(C2, 0, 10)) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+

-- cluster by paths in variant columns
CREATE OR REPLACE TABLE T3 (t timestamp, v variant) cluster by (v:"Data":id::number);

SHOW TABLES LIKE 'T3';

+-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 16:30:11.330 -0700 | T3   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(TO_NUMBER(GET_PATH(V, 'Data.id'))) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------+

-- Example 11087
create or replace table t3 (vc varchar) cluster by (SUBSTRING(vc, 5, 5));

-- Example 11088
ALTER TABLE <name> CLUSTER BY ( <expr1> [ , <expr2> ... ] )

-- Example 11089
-- cluster by base columns
ALTER TABLE t1 CLUSTER BY (c1, c3);

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(C1, C3) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+

-- cluster by expressions
ALTER TABLE T2 CLUSTER BY (SUBSTRING(C2, 5, 15), TO_DATE(C1));

SHOW TABLES LIKE 't2';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:07:51.307 -0700 | T2   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(SUBSTRING(C2, 5, 15), CAST(C1 AS DATE)) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+

-- cluster by paths in variant columns
ALTER TABLE T3 CLUSTER BY (v:"Data":name::string, v:"Data":id::number);

SHOW TABLES LIKE 'T3';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                                                   | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 16:30:11.330 -0700 | T3   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(TO_CHAR(GET_PATH(V, 'Data.name')), TO_NUMBER(GET_PATH(V, 'Data.id'))) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------+

-- Example 11090
ALTER TABLE <name> DROP CLUSTERING KEY

-- Example 11091
ALTER TABLE t1 DROP CLUSTERING KEY;

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         |            |    0 |     0 | SYSADMIN | 1              | OFF                  |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 11092
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

-- Example 11093
CREATE OR ALTER [ SECURE ] [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | VOLATILE } ] [ RECURSIVE ] VIEW <name>
  [ ( <column_list> ) ]
  [ CHANGE_TRACKING =  { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  AS <select_statement>

-- Example 11094
CREATE VIEW v1 (pre_tax_profit, taxes, after_tax_profit) AS
    SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
    FROM table1;

-- Example 11095
CREATE VIEW v1 (pre_tax_profit COMMENT 'revenue minus cost',
                taxes COMMENT 'assumes taxes are a fixed percentage of profit',
                after_tax_profit)
    AS
    SELECT revenue - cost, (revenue - cost) * tax_rate, (revenue - cost) * (1.0 - tax_rate)
    FROM table1;

-- Example 11096
CREATE OR REPLACE FORCE VIEW ...

-- Example 11097
CREATE VIEW myview COMMENT='Test view' AS SELECT col1, col2 FROM mytable;

SHOW VIEWS;

+---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------+
| created_on                      | name              | reserved | database_name | schema_name | owner    | comment   | text                                                                     |
|---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------|
| Thu, 19 Jan 2017 15:00:37 -0800 | MYVIEW            |          | MYTEST1       | PUBLIC      | SYSADMIN | Test view | CREATE VIEW myview COMMENT='Test view' AS SELECT col1, col2 FROM mytable |
+---------------------------------+-------------------+----------+---------------+-------------+----------+-----------+--------------------------------------------------------------------------+

-- Example 11098
CREATE OR REPLACE SECURE VIEW myview COMMENT='Test secure view' AS SELECT col1, col2 FROM mytable;

SELECT is_secure FROM information_schema.views WHERE table_name = 'MYVIEW';

-- Example 11099
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 11100
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 11101
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

