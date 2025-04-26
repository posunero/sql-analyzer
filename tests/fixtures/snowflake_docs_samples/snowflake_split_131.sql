-- Example 8758
CREATE OR ALTER
    [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | TRANSIENT } ]
  TABLE <table_name> (
    -- Column definition
    <col_name> <col_type>
      [ inlineConstraint ]
      [ NOT NULL ]
      [ COLLATE '<collation_specification>' ]
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
      [ COMMENT '<string_literal>' ]

    -- Additional column definitions
    [ , <col_name> <col_type> [ ... ] ]

    -- Out-of-line constraints
    [ , outoflineConstraint [ ... ] ]
  )
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ ENABLE_SCHEMA_EVOLUTION = { TRUE | FALSE } ]
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ COMMENT = '<string_literal>' ]

-- Example 8759
CREATE [ OR REPLACE ] TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  AS <query>
  [ ... ]

-- Example 8760
CREATE TABLE <table_name> ( <col1> <data_type> [ WITH ] MASKING POLICY <policy_name> [ , ... ] )
  ...
  [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col1> [ , ... ] )
  AS <query>
  [ ... ]

-- Example 8761
CREATE [ OR REPLACE ] TABLE <table_name>
  [ COPY GRANTS ]
  USING TEMPLATE <query>
  [ ... ]

-- Example 8762
CREATE [ OR REPLACE ] TABLE <table_name> LIKE <source_table>
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  [ ... ]

-- Example 8763
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

-- Example 8764
CREATE TABLE <table_name> AS SELECT ...

-- Example 8765
CREATE TABLE <table_name> ( <col1_name> , <col2_name> , ... ) AS SELECT ...

-- Example 8766
CREATE OR ALTER TABLE my_table (
  a INT PRIMARY KEY,
  b VARCHAR(20)
)
DEFAULT_DDL_COLLATION = 'fr';

-- Example 8767
CREATE OR ALTER TABLE my_table (
  a INT PRIMARY KEY,
  b VARCHAR(200) COLLATE 'fr'
)
DEFAULT_DDL_COLLATION = 'de';

-- Example 8768
CREATE OR ALTER execution failed. Partial updates may have been applied.

-- Example 8769
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

-- Example 8770
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

-- Example 8771
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

-- Example 8772
CREATE TABLE testtable_summary (name, summary_amount) AS SELECT name, amount1 + amount2 FROM testtable;

-- Example 8773
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

-- Example 8774
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

-- Example 8775
CREATE TABLE mytable (date TIMESTAMP_NTZ, id NUMBER, content VARIANT) CLUSTER BY (date, id);

SHOW TABLES LIKE 'mytable';

+---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------+
| created_on                      | name    | database_name | schema_name | kind  | comment | cluster_by       | rows | bytes | owner        | retention_time |
|---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------|
| Mon, 11 Sep 2017 16:20:41 -0700 | MYTABLE | TESTDB        | PUBLIC      | TABLE |         | LINEAR(DATE, ID) |    0 |     0 | ACCOUNTADMIN | 1              |
+---------------------------------+---------+---------------+-------------+-------+---------+------------------+------+-------+--------------+----------------+

-- Example 8776
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

-- Example 8777
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

-- Example 8778
CREATE TEMPORARY TABLE demo_temporary (i INTEGER);
CREATE TEMP TABLE demo_temp (i INTEGER);

-- Example 8779
CREATE LOCAL TEMPORARY TABLE demo_local_temporary (i INTEGER);
CREATE LOCAL TEMP TABLE demo_local_temp (i INTEGER);

CREATE GLOBAL TEMPORARY TABLE demo_global_temporary (i INTEGER);
CREATE GLOBAL TEMP TABLE demo_global_temp (i INTEGER);

CREATE VOLATILE TABLE demo_volatile (i INTEGER);

-- Example 8780
CREATE OR ALTER TABLE my_table(a INT);

-- Example 8781
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    b VARCHAR(200)
  )
  DATA_RETENTION_TIME_IN_DAYS = 5
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8782
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    c VARCHAR(200)
  )
  DEFAULT_DDL_COLLATION = 'de';

-- Example 8783
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    b INT
  );

-- Example 8784
INSERT INTO my_table VALUES (1, 2), (2, 3);

SELECT * FROM my_table;

-- Example 8785
+---+---+
| A | B |
|---+---|
| 1 | 2 |
| 2 | 3 |
+---+---+

-- Example 8786
CREATE OR ALTER TABLE my_table(
    a INT PRIMARY KEY,
    c INT
  );

-- Example 8787
SELECT * FROM my_table;

-- Example 8788
+---+------+
| A | C    |
|---+------|
| 1 | NULL |
| 2 | NULL |
+---+------+

-- Example 8789
CREATE TABLE t(a INT);

-- Example 8790
CREATE OR ALTER TABLE t(a INT PRIMARY KEY);

-- Example 8791
DESC TABLE t;

-- Example 8792
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | privacy domain |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------|
| A    | NUMBER(38,0) | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | NULL    | NULL        | NULL           |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+----------------+

-- Example 8793
CREATE OR REPLACE TABLE t(a INT);

-- Example 8794
INSERT INTO t VALUES (null);

-- Example 8795
CREATE OR ALTER TABLE t(a INT PRIMARY KEY);

-- Example 8796
001471 (42601): SQL compilation error:
Column 'A' contains null values. Not null constraint cannot be added.

-- Example 8797
SELECT <column_list> [ , <level_expression> ]
  FROM <data_source>
    START WITH <predicate>
    CONNECT BY [ PRIOR ] <col1_identifier> = [ PRIOR ] <col2_identifier>
           [ , [ PRIOR ] <col3_identifier> = [ PRIOR ] <col4_identifier> ]
           ...
  ...

-- Example 8798
... CONNECT BY manager_ID = PRIOR employee_ID ...

-- Example 8799
... CONNECT BY y = PRIOR x AND b = PRIOR a ...

-- Example 8800
CONNECT BY <col_1_identifier> = <col_2_identifier>

-- Example 8801
CONNECT BY <col_1_identifier> = PRIOR <col_2_identifier>

-- Example 8802
CONNECT BY PRIOR <col_1_identifier> = <col_2_identifier>

-- Example 8803
CREATE OR REPLACE TABLE employees (title VARCHAR, employee_ID INTEGER, manager_ID INTEGER);

-- Example 8804
INSERT INTO employees (title, employee_ID, manager_ID) VALUES
    ('President', 1, NULL),  -- The President has no manager.
        ('Vice President Engineering', 10, 1),
            ('Programmer', 100, 10),
            ('QA Engineer', 101, 10),
        ('Vice President HR', 20, 1),
            ('Health Insurance Analyst', 200, 20);

-- Example 8805
SELECT employee_ID, manager_ID, title
  FROM employees
    START WITH title = 'President'
    CONNECT BY
      manager_ID = PRIOR employee_id
  ORDER BY employee_ID;
+-------------+------------+----------------------------+
| EMPLOYEE_ID | MANAGER_ID | TITLE                      |
|-------------+------------+----------------------------|
|           1 |       NULL | President                  |
|          10 |          1 | Vice President Engineering |
|          20 |          1 | Vice President HR          |
|         100 |         10 | Programmer                 |
|         101 |         10 | QA Engineer                |
|         200 |         20 | Health Insurance Analyst   |
+-------------+------------+----------------------------+

-- Example 8806
SELECT SYS_CONNECT_BY_PATH(title, ' -> '), employee_ID, manager_ID, title
  FROM employees
    START WITH title = 'President'
    CONNECT BY
      manager_ID = PRIOR employee_id
  ORDER BY employee_ID;
+----------------------------------------------------------------+-------------+------------+----------------------------+
| SYS_CONNECT_BY_PATH(TITLE, ' -> ')                             | EMPLOYEE_ID | MANAGER_ID | TITLE                      |
|----------------------------------------------------------------+-------------+------------+----------------------------|
|  -> President                                                  |           1 |       NULL | President                  |
|  -> President -> Vice President Engineering                    |          10 |          1 | Vice President Engineering |
|  -> President -> Vice President HR                             |          20 |          1 | Vice President HR          |
|  -> President -> Vice President Engineering -> Programmer      |         100 |         10 | Programmer                 |
|  -> President -> Vice President Engineering -> QA Engineer     |         101 |         10 | QA Engineer                |
|  -> President -> Vice President HR -> Health Insurance Analyst |         200 |         20 | Health Insurance Analyst   |
+----------------------------------------------------------------+-------------+------------+----------------------------+

-- Example 8807
SELECT 
employee_ID, manager_ID, title,
CONNECT_BY_ROOT title AS root_title
  FROM employees
    START WITH title = 'President'
    CONNECT BY
      manager_ID = PRIOR employee_id
  ORDER BY employee_ID;
+-------------+------------+----------------------------+------------+
| EMPLOYEE_ID | MANAGER_ID | TITLE                      | ROOT_TITLE |
|-------------+------------+----------------------------+------------|
|           1 |       NULL | President                  | President  |
|          10 |          1 | Vice President Engineering | President  |
|          20 |          1 | Vice President HR          | President  |
|         100 |         10 | Programmer                 | President  |
|         101 |         10 | QA Engineer                | President  |
|         200 |         20 | Health Insurance Analyst   | President  |
+-------------+------------+----------------------------+------------+

-- Example 8808
-- The components of a car.
CREATE TABLE components (
    description VARCHAR,
    quantity INTEGER,
    component_ID INTEGER,
    parent_component_ID INTEGER
    );

INSERT INTO components (description, quantity, component_ID, parent_component_ID) VALUES
    ('car', 1, 1, 0),
       ('wheel', 4, 11, 1),
          ('tire', 1, 111, 11),
          ('#112 bolt', 5, 112, 11),
          ('brake', 1, 113, 11),
             ('brake pad', 1, 1131, 113),
       ('engine', 1, 12, 1),
          ('piston', 4, 121, 12),
          ('cylinder block', 1, 122, 12),
          ('#112 bolt', 16, 112, 12)   -- Can use same type of bolt in multiple places
    ;

-- Example 8809
SELECT
  description,
  quantity,
  component_id, 
  parent_component_ID,
  SYS_CONNECT_BY_PATH(component_ID, ' -> ') AS path
  FROM components
    START WITH component_ID = 1
    CONNECT BY 
      parent_component_ID = PRIOR component_ID
  ORDER BY path
  ;
+----------------+----------+--------------+---------------------+----------------------------+
| DESCRIPTION    | QUANTITY | COMPONENT_ID | PARENT_COMPONENT_ID | PATH                       |
|----------------+----------+--------------+---------------------+----------------------------|
| car            |        1 |            1 |                   0 |  -> 1                      |
| wheel          |        4 |           11 |                   1 |  -> 1 -> 11                |
| tire           |        1 |          111 |                  11 |  -> 1 -> 11 -> 111         |
| #112 bolt      |        5 |          112 |                  11 |  -> 1 -> 11 -> 112         |
| brake          |        1 |          113 |                  11 |  -> 1 -> 11 -> 113         |
| brake pad      |        1 |         1131 |                 113 |  -> 1 -> 11 -> 113 -> 1131 |
| engine         |        1 |           12 |                   1 |  -> 1 -> 12                |
| #112 bolt      |       16 |          112 |                  12 |  -> 1 -> 12 -> 112         |
| piston         |        4 |          121 |                  12 |  -> 1 -> 12 -> 121         |
| cylinder block |        1 |          122 |                  12 |  -> 1 -> 12 -> 122         |
+----------------+----------+--------------+---------------------+----------------------------+

-- Example 8810
[ WITH
       <cte_name1> [ ( <cte_column_list> ) ] AS ( SELECT ...  )
   [ , <cte_name2> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
   [ , <cte_nameN> [ ( <cte_column_list> ) ] AS ( SELECT ...  ) ]
]
SELECT ...

-- Example 8811
[ WITH [ RECURSIVE ]
       <cte_name1> ( <cte_column_list> ) AS ( anchorClause UNION ALL recursiveClause )
   [ , <cte_name2> ( <cte_column_list> ) AS ( anchorClause UNION ALL recursiveClause ) ]
   [ , <cte_nameN> ( <cte_column_list> ) AS ( anchorClause UNION ALL recursiveClause ) ]
]
SELECT ...

-- Example 8812
anchorClause ::=
    SELECT <anchor_column_list> FROM ...

recursiveClause ::=
    SELECT <recursive_column_list> FROM ... [ JOIN ... ]

-- Example 8813
WITH cte AS (
  SELECT ..., 1 as level ...

  UNION ALL

  SELECT ..., cte.level + 1 as level
   FROM cte ...
   WHERE ... level < 10
) ...

-- Example 8814
WITH RECURSIVE cte_name (X, Y) AS
(
  SELECT related_to_X, related_to_Y FROM table1
  UNION ALL
  SELECT also_related_to_X, also_related_to_Y
    FROM table1 JOIN cte_name ON <join_condition>
)
SELECT ... FROM ...

-- Example 8815
with
  albums_1976 as (select * from music_albums where album_year = 1976)
select album_name from albums_1976 order by album_name;
+----------------------+
| ALBUM_NAME           |
|----------------------|
| Amigos               |
| Look Into The Future |
+----------------------+

-- Example 8816
with
   album_info_1976 as (select m.album_ID, m.album_name, b.band_name
      from music_albums as m inner join music_bands as b
      where m.band_id = b.band_id and album_year = 1976),
   Journey_album_info_1976 as (select *
      from album_info_1976 
      where band_name = 'Journey')
select album_name, band_name 
   from Journey_album_info_1976;
+----------------------+-----------+
| ALBUM_NAME           | BAND_NAME |
|----------------------+-----------|
| Look Into The Future | Journey   |
+----------------------+-----------+

-- Example 8817
select distinct musicians.musician_id, musician_name
 from musicians inner join musicians_and_albums inner join music_albums inner join music_bands
 where musicians.musician_ID = musicians_and_albums.musician_ID
   and musicians_and_albums.album_ID = music_albums.album_ID
   and music_albums.band_ID = music_bands.band_ID
   and music_bands.band_name = 'Santana'
intersect
select distinct musicians.musician_id, musician_name
 from musicians inner join musicians_and_albums inner join music_albums inner join music_bands
 where musicians.musician_ID = musicians_and_albums.musician_ID
   and musicians_and_albums.album_ID = music_albums.album_ID
   and music_albums.band_ID = music_bands.band_ID
   and music_bands.band_name = 'Journey'
order by musician_ID;
+-------------+---------------+
| MUSICIAN_ID | MUSICIAN_NAME |
|-------------+---------------|
|         305 | Gregg Rolie   |
|         306 | Neal Schon    |
+-------------+---------------+

-- Example 8818
create or replace view view_musicians_in_bands AS
  select distinct musicians.musician_id, musician_name, band_name
    from musicians inner join musicians_and_albums inner join music_albums inner join music_bands
    where musicians.musician_ID = musicians_and_albums.musician_ID
      and musicians_and_albums.album_ID = music_albums.album_ID
      and music_albums.band_ID = music_bands.band_ID;

-- Example 8819
select musician_id, musician_name from view_musicians_in_bands where band_name = 'Santana'
intersect
select musician_id, musician_name from view_musicians_in_bands where band_name = 'Journey'
order by musician_ID;
+-------------+---------------+
| MUSICIAN_ID | MUSICIAN_NAME |
|-------------+---------------|
|         305 | Gregg Rolie   |
|         306 | Neal Schon    |
+-------------+---------------+

-- Example 8820
with
  musicians_in_bands as (
     select distinct musicians.musician_id, musician_name, band_name
      from musicians inner join musicians_and_albums inner join music_albums inner join music_bands
      where musicians.musician_ID = musicians_and_albums.musician_ID
        and musicians_and_albums.album_ID = music_albums.album_ID
        and music_albums.band_ID = music_bands.band_ID)
select musician_ID, musician_name from musicians_in_bands where band_name = 'Santana'
intersect
select musician_ID, musician_name from musicians_in_bands where band_name = 'Journey'
order by musician_ID
  ;
+-------------+---------------+
| MUSICIAN_ID | MUSICIAN_NAME |
|-------------+---------------|
|         305 | Gregg Rolie   |
|         306 | Neal Schon    |
+-------------+---------------+

-- Example 8821
create or replace view view_album_IDs_by_bands AS
 select album_ID, music_bands.band_id, band_name
  from music_albums inner join music_bands
  where music_albums.band_id = music_bands.band_ID;

-- Example 8822
create or replace view view_musicians_in_bands AS
 select distinct musicians.musician_id, musician_name, band_name
  from musicians inner join musicians_and_albums inner join view_album_IDs_by_bands
  where musicians.musician_ID = musicians_and_albums.musician_ID
    and musicians_and_albums.album_ID = view_album_IDS_by_bands.album_ID;

-- Example 8823
select musician_id, musician_name from view_musicians_in_bands where band_name = 'Santana'
intersect
select musician_id, musician_name from view_musicians_in_bands where band_name = 'Journey'
order by musician_ID;
+-------------+---------------+
| MUSICIAN_ID | MUSICIAN_NAME |
|-------------+---------------|
|         305 | Gregg Rolie   |
|         306 | Neal Schon    |
+-------------+---------------+

-- Example 8824
with
  album_IDs_by_bands as (select album_ID, music_bands.band_id, band_name
                          from music_albums inner join music_bands
                          where music_albums.band_id = music_bands.band_ID),
  musicians_in_bands as (select distinct musicians.musician_id, musician_name, band_name
                          from musicians inner join musicians_and_albums inner join album_IDs_by_bands
                          where musicians.musician_ID = musicians_and_albums.musician_ID
                            and musicians_and_albums.album_ID = album_IDS_by_bands.album_ID)
select musician_ID, musician_name from musicians_in_bands where band_name = 'Santana'
intersect
select musician_ID, musician_name from musicians_in_bands where band_name = 'Journey'
order by musician_ID
  ;
+-------------+---------------+
| MUSICIAN_ID | MUSICIAN_NAME |
|-------------+---------------|
|         305 | Gregg Rolie   |
|         306 | Neal Schon    |
+-------------+---------------+

