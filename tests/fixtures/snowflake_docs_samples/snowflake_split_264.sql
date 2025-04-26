-- Example 17666
CREATE TABLE <table_name> ( <col1> <data_type> [ WITH ] MASKING POLICY <policy_name> [ , ... ] )
  ...
  [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col1> [ , ... ] )
  AS <query>
  [ ... ]

-- Example 17667
CREATE [ OR REPLACE ] TABLE <table_name>
  [ COPY GRANTS ]
  USING TEMPLATE <query>
  [ ... ]

-- Example 17668
CREATE [ OR REPLACE ] TABLE <table_name> LIKE <source_table>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  [ ... ]

-- Example 17669
CREATE [ OR REPLACE ]
    [ {
          [ { LOCAL | GLOBAL } ] TEMP [ READ ONLY ] |
          TEMPORARY [ READ ONLY ] |
          VOLATILE |
          TRANSIENT
    } ]
  TABLE <name> CLONE <source_table>
    [ { AT | BEFORE } ( { TIMESTAMP => <timestamp> | OFFSET => <time_difference> | STATEMENT => <id> } ) ]
    [ COPY GRANTS ]
    [ ... ]

-- Example 17670
CREATE TABLE <table_name> AS SELECT ...

-- Example 17671
CREATE TABLE <table_name> ( <col1_name> , <col2_name> , ... ) AS SELECT ...

-- Example 17672
CREATE OR ALTER TABLE my_table (
  a INT PRIMARY KEY,
  b VARCHAR(20)
)
DEFAULT_DDL_COLLATION = 'fr';

-- Example 17673
CREATE OR ALTER TABLE my_table (
  a INT PRIMARY KEY,
  b VARCHAR(200) COLLATE 'fr'
)
DEFAULT_DDL_COLLATION = 'de';

-- Example 17674
CREATE OR ALTER execution failed. Partial updates may have been applied.

-- Example 17675
CREATE TABLE mytable (amount NUMBER);

+-------------------------------------+
| status                              |
|-------------------------------------|
| Table MYTABLE successfully created. |
+-------------------------------------+

INSERT INTO mytable VALUES(1);

SHOW TABLES like 'mytable';

+---------------------------------+---------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
| created_on                      | name    | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner        | retention_time |
|---------------------------------+---------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------|
| Mon, 11 Sep 2017 16:32:28 -0700 | MYTABLE | TESTDB        | PUBLIC      | TABLE |         |            |    1 |  1024 | ACCOUNTADMIN | 1              |
+---------------------------------+---------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

DESC TABLE mytable;

+--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name   | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| AMOUNT | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

-- Example 17676
CREATE TABLE example (col1 NUMBER COMMENT 'a column comment') COMMENT='a table comment';

+-------------------------------------+
| status                              |
|-------------------------------------|
| Table EXAMPLE successfully created. |
+-------------------------------------+

SHOW TABLES LIKE 'example';

+---------------------------------+---------+---------------+-------------+-------+-----------------+------------+------+-------+--------------+----------------+
| created_on                      | name    | database_name | schema_name | kind  | comment         | cluster_by | rows | bytes | owner        | retention_time |
|---------------------------------+---------+---------------+-------------+-------+-----------------+------------+------+-------+--------------+----------------|
| Mon, 11 Sep 2017 16:35:59 -0700 | EXAMPLE | TESTDB        | PUBLIC      | TABLE | a table comment |            |    0 |     0 | ACCOUNTADMIN | 1              |
+---------------------------------+---------+---------------+-------------+-------+-----------------+------------+------+-------+--------------+----------------+

DESC TABLE example;

+------+--------------+--------+-------+---------+-------------+------------+-------+------------+------------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment          |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+------------------|
| COL1 | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | a column comment |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+------------------+

-- Example 17677
CREATE TABLE mytable_copy (b) AS SELECT * FROM mytable;

DESC TABLE mytable_copy;

+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| B    | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

CREATE TABLE mytable_copy2 AS SELECT b+1 AS c FROM mytable_copy;

DESC TABLE mytable_copy2;

+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| C    | NUMBER(39,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

SELECT * FROM mytable_copy2;

+---+
| C |
|---|
| 2 |
+---+

-- Example 17678
CREATE TABLE testtable_summary (name, summary_amount) AS SELECT name, amount1 + amount2 FROM testtable;

-- Example 17679
CREATE OR REPLACE TABLE parquet_col (
  custKey NUMBER DEFAULT NULL,
  orderDate DATE DEFAULT NULL,
  orderStatus VARCHAR(100) DEFAULT NULL,
  price VARCHAR(255)
)
AS SELECT
  $1:o_custkey::number,
  $1:o_orderdate::date,
  $1:o_orderstatus::text,
  $1:o_totalprice::text
FROM @my_stage;

+-----------------------------------------+
| status                                  |
|-----------------------------------------|
| Table PARQUET_COL successfully created. |
+-----------------------------------------+

DESC TABLE parquet_col;

+-------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name        | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|-------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| CUSTKEY     | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| ORDERDATE   | DATE         | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| ORDERSTATUS | VARCHAR(100) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
| PRICE       | VARCHAR(255) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+-------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

-- Example 17680
CREATE TABLE mytable (amount NUMBER);

INSERT INTO mytable VALUES(1);

SELECT * FROM mytable;

+--------+
| AMOUNT |
|--------|
|      1 |
+--------+

CREATE TABLE mytable_2 LIKE mytable;

DESC TABLE mytable_2;

+--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+
| name   | type         | kind   | null? | default | primary key | unique key | check | expression | comment |
|--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------|
| AMOUNT | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    |
+--------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+

SELECT * FROM mytable_2;

+--------+
| AMOUNT |
|--------|
+--------+

-- Example 17681
CREATE TABLE mytable (date TIMESTAMP_NTZ, id NUMBER, content VARIANT) CLUSTER BY (date, id);

SHOW TABLES LIKE 'mytable';

+---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------+
| created_on                      | name    | database_name | schema_name | kind  | comment | cluster_by       | rows | bytes | owner        | retention_time |
|---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------|
| Mon, 11 Sep 2017 16:20:41 -0700 | MYTABLE | TESTDB        | PUBLIC      | TABLE |         | LINEAR(DATE, ID) |    0 |     0 | ACCOUNTADMIN | 1              |
+---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------+

-- Example 17682
CREATE OR REPLACE TABLE collation_demo (
  uncollated_phrase VARCHAR, 
  utf8_phrase VARCHAR COLLATE 'utf8',
  english_phrase VARCHAR COLLATE 'en',
  spanish_phrase VARCHAR COLLATE 'es');

INSERT INTO collation_demo (
      uncollated_phrase, 
      utf8_phrase, 
      english_phrase, 
      spanish_phrase) 
   VALUES (
     'pinata', 
     'pinata', 
     'pinata', 
     'piñata');

-- Example 17683
CREATE TABLE mytable
  USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    WITHIN GROUP (ORDER BY order_id)
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@mystage',
          FILE_FORMAT=>'my_parquet_format'
        )
      ));

-- Example 17684
CREATE TEMPORARY TABLE demo_temporary (i INTEGER);
CREATE TEMP TABLE demo_temp (i INTEGER);

-- Example 17685
CREATE LOCAL TEMPORARY TABLE demo_local_temporary (i INTEGER);
CREATE LOCAL TEMP TABLE demo_local_temp (i INTEGER);

CREATE GLOBAL TEMPORARY TABLE demo_global_temporary (i INTEGER);
CREATE GLOBAL TEMP TABLE demo_global_temp (i INTEGER);

CREATE VOLATILE TABLE demo_volatile (i INTEGER);

-- Example 17686
CREATE OR ALTER TABLE my_table(a INT);

-- Example 17687
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    b VARCHAR(200)
  )
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 17688
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    c VARCHAR(200)
  )
  DEFAULT_DDL_COLLATION = 'de';

-- Example 17689
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    b INT
  );

-- Example 17690
INSERT INTO my_table VALUES (1, 2), (2, 3);

SELECT * FROM my_table;

-- Example 17691
+---+---+
| A | B |
|---+---|
| 1 | 2 |
| 2 | 3 |
+---+---+

-- Example 17692
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    c INT
  );

-- Example 17693
SELECT * FROM my_table;

-- Example 17694
+---+------+
| A | C    |
|---+------|
| 1 | NULL |
| 2 | NULL |
+---+------+

-- Example 17695
CREATE TABLE t(a INT);

-- Example 17696
CREATE OR ALTER TABLE t(a INT PRIMARY KEY);

-- Example 17697
DESC TABLE t;

-- Example 17698
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| A    | NUMBER(38,0) | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 17699
CREATE OR REPLACE TABLE t(a INT);

-- Example 17700
INSERT INTO t VALUES (null);

-- Example 17701
CREATE OR ALTER TABLE t(a INT PRIMARY KEY);

-- Example 17702
001471 (42601): SQL compilation error:
Column 'A' contains null values. Not null constraint cannot be added.

-- Example 17703
CREATE [ OR REPLACE ] HYBRID TABLE [ IF NOT EXISTS ] <table_name>
  ( <col_name> <col_type>
    [
      {
        DEFAULT <expr>
        | { AUTOINCREMENT | IDENTITY }
          [
            {
              ( <start_num> , <step_num> )
              | START <num> INCREMENT <num>
            }
          ]
          [ { ORDER | NOORDER } ]
      }
    ]
    [ NOT NULL ]
    [ inlineConstraint ]
    [ COMMENT '<string_literal>' ]
    [ , <col_name> <col_type> [ ... ] ]
    [ , outoflineConstraint ]
    [ , outoflineIndex ]
    [ , ... ]
  )
  [ COMMENT = '<string_literal>' ]

-- Example 17704
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE | PRIMARY KEY | { [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ] } }
  [ <constraint_properties> ]

outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]
  [ COMMENT '<string_literal>' ]

outoflineIndex ::=
  INDEX <index_name> ( <col_name> [ , <col_name> , ... ] )
    [ INCLUDE ( <col_name> [ , <col_name> , ... ] ) ]

-- Example 17705
CREATE OR REPLACE HYBRID TABLE ht2pk (
  col1 INTEGER NOT NULL,
  col2 INTEGER NOT NULL,
  col3 VARCHAR,
  CONSTRAINT pkey_1 PRIMARY KEY (col1, col2)
  );

-- Example 17706
CREATE [ OR REPLACE ] HYBRID TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  AS <query>
  [ ... ]

-- Example 17707
CREATE [ OR REPLACE ] HYBRID TABLE <table_name> LIKE <source_hybrid_table>
  [ ... ]

-- Example 17708
CREATE HYBRID TABLE mytable (
  customer_id INT AUTOINCREMENT PRIMARY KEY,
  full_name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  extended_customer_info VARIANT,
  INDEX index_full_name (full_name)
);

-- Example 17709
+-------------------------------------+
| status                              |
|-------------------------------------|
| Table MYTABLE successfully created. |
+-------------------------------------+

-- Example 17710
INSERT INTO mytable (customer_id, full_name, email, extended_customer_info)
  SELECT 100, 'Jane Doe', 'jdoe@example.com',
    parse_json('{"address": "1234 Main St", "city": "San Francisco", "state": "CA", "zip":"94110"}');

-- Example 17711
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 17712
200001 (22000): Primary key already exists

-- Example 17713
Duplicate key value violates unique constraint "SYS_INDEX_MYTABLE_UNIQUE_EMAIL"

-- Example 17714
SHOW TABLES LIKE 'mytable';

-- Example 17715
+-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+
| created_on                    | name    | database_name | schema_name | kind  | is_hybrid | comment | cluster_by | rows | bytes | owner  | retention_time | automatic_clustering | change_tracking | search_optimization | search_optimization_progress | search_optimization_bytes | is_external |
|-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------|
| 2022-02-23 23:53:19.707 +0000 | MYTABLE | MYDB          | PUBLIC      | TABLE | Y         |         |            | NULL |  NULL | MYROLE | 10             | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           |
+-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+

-- Example 17716
SHOW HYBRID TABLES;

-- Example 17717
+-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------+
| created_on                    | name                      | database_name | schema_name | owner        | datastore_id | rows | bytes | comment |
|-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------|
| 2022-02-24 02:07:31.877 +0000 | MYTABLE                   | DEMO_DB       | PUBLIC      | ACCOUNTADMIN |         2002 | NULL |  NULL |         |
+-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------+

-- Example 17718
DESCRIBE TABLE mytable;

-- Example 17719
+-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name              | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| CUSTOMER_ID       | NUMBER(38,0) | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | NULL    | NULL        |
| FULL_NAME         | VARCHAR(256) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| APPLICATION_STATE | VARIANT      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 17720
SELECT customer_id, full_name, email, extended_customer_info
  FROM mytable
  WHERE extended_customer_info['state'] = 'CA';

-- Example 17721
+-------------+-----------+------------------+------------------------------+
| CUSTOMER_ID | FULL_NAME | EMAIL            | EXTENDED_CUSTOMER_INFO       |
|-------------+-----------+------------------+------------------------------|
|         100 | Jane Doe  | jdoe@example.com | {                            |
|             |           |                  |   "address": "1234 Main St", |
|             |           |                  |   "city": "San Francisco",   |
|             |           |                  |   "state": "CA",             |
|             |           |                  |   "zip": "94110"             |
|             |           |                  | }                            |
+-------------+-----------+------------------+------------------------------+

-- Example 17722
CREATE OR REPLACE HYBRID TABLE team
  (team_id INT PRIMARY KEY,
  team_name VARCHAR(40),
  stadium VARCHAR(40));

CREATE OR REPLACE HYBRID TABLE player
  (player_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  team_id INT,
  FOREIGN KEY (team_id) REFERENCES team(team_id));

-- Example 17723
INSERT INTO team VALUES (1, 'Bayern Munich', 'Allianz Arena');
INSERT INTO player VALUES (100, 'Harry', 'Kane', 1);
INSERT INTO player VALUES (301, 'Gareth', 'Bale', 3);

-- Example 17724
200009 (22000): Foreign key constraint "SYS_INDEX_PLAYER_FOREIGN_KEY_TEAM_ID_TEAM_TEAM_ID" was violated.

-- Example 17725
INSERT INTO player VALUES (200, 'Tommy', 'Atkins', NULL);

-- Example 17726
200009 (22000): Foreign key constraint "SYS_INDEX_PLAYER_FOREIGN_KEY_TEAM_ID_TEAM_TEAM_ID" was violated.

-- Example 17727
SELECT * FROM team t, player p WHERE t.team_id=p.team_id;

-- Example 17728
+---------+---------------+---------------+-----------+------------+-----------+---------+
| TEAM_ID | TEAM_NAME     | STADIUM       | PLAYER_ID | FIRST_NAME | LAST_NAME | TEAM_ID |
|---------+---------------+---------------+-----------+------------+-----------+---------|
|       1 | Bayern Munich | Allianz Arena |       100 | Harry      | Kane      |       1 |
+---------+---------------+---------------+-----------+------------+-----------+---------+

-- Example 17729
INSERT INTO team VALUES (0, 'Unknown', 'Unknown');
INSERT INTO player VALUES (200, 'Tommy', 'Atkins', 0);

SELECT * FROM team t, player p WHERE t.team_id=p.team_id;

-- Example 17730
+---------+---------------+---------------+-----------+------------+-----------+---------+
| TEAM_ID | TEAM_NAME     | STADIUM       | PLAYER_ID | FIRST_NAME | LAST_NAME | TEAM_ID |
|---------+---------------+---------------+-----------+------------+-----------+---------|
|       1 | Bayern Munich | Allianz Arena |       100 | Harry      | Kane      |       1 |
|       0 | Unknown       | Unknown       |       200 | Tommy      | Atkins    |       0 |
+---------+---------------+---------------+-----------+------------+-----------+---------+

-- Example 17731
CREATE HYBRID TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(200),
    employee_department VARCHAR(200),
    INDEX idx_department (employee_department) INCLUDE (employee_name)
);

-- Example 17732
INSERT INTO employee VALUES
  (1, 'John Doe', 'Marketing'),
  (2, 'Jane Smith', 'Sales'),
  (3, 'Bob Johnson', 'Finance'),
  (4, 'Alice Brown', 'Marketing');

