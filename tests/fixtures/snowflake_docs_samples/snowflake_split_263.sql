-- Example 17599
SELECT COUNT(score_derived)
  FROM (SELECT score, score_derived FROM t1 WHERE score <= 2);

-- Example 17600
----------------------------
|"count(""SCORE_DERIVED"")"|
----------------------------
|31                        |
----------------------------

-- Example 17601
SELECT COUNT(num_scores)
  FROM (SELECT COUNT(score) AS num_scores
    FROM t1
    GROUP BY age)
  WHERE num_scores >= 0 AND num_scores <= 100;

-- Example 17602
PRIVACY DOMAIN
  {
      [ BETWEEN ( <lo_value>, <hi_value> ) ]
    | [ IN ( '<value1>, '<value2>', ... ) ]
    | [ REFERENCES <table_name>( <col_name> ) ]
  }

-- Example 17603
CREATE TABLE <table_name>
  ( <col_name> <col_type> PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }
  )

-- Example 17604
ALTER TABLE <table_name>
  ADD COLUMN <col_name> <col_type> PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }

-- Example 17605
ALTER TABLE <table_name>
  { ALTER | MODIFY } COLUMN <col1_name> SET PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }

-- Example 17606
ALTER TABLE <table_name>
  { ALTER | MODIFY } COLUMN <col1_name> UNSET PRIVACY DOMAIN

-- Example 17607
CREATE OR REPLACE HYBRID TABLE application_log (
  id NUMBER PRIMARY KEY AUTOINCREMENT,
  col1 VARCHAR(20),
  col2 VARCHAR(20) NOT NULL
  );

INSERT INTO application_log (col1, col2) VALUES ('A1', 'B1');
INSERT INTO application_log (col1, col2) VALUES ('A2', 'B2');
INSERT INTO application_log (col1, col2) VALUES ('A3', 'B3');
INSERT INTO application_log (col1, col2) VALUES ('A4', 'B4');

SELECT * FROM application_log;

UPDATE application_log SET col2 = 'B3-updated' WHERE id = 3;

DELETE FROM application_log WHERE id = 4;

SELECT * FROM application_log;

-- Example 17608
CREATE OR REPLACE HYBRID TABLE dept_employees (
  employee_id INT PRIMARY KEY,
  department_id VARCHAR(200)
  )
AS SELECT employee_id, department_id FROM company_employees;

-- Example 17609
CREATE OR REPLACE HYBRID TABLE target_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0) UNIQUE,
    col3 NUMBER(38,0),
    INDEX index_col3 (col3)
    )
  AS SELECT col1, col2, col3 FROM source_table;

-- Example 17610
CREATE OR REPLACE HYBRID TABLE ref_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0) UNIQUE
);

CREATE OR REPLACE HYBRID TABLE fk_hybrid_table (
    col1 VARCHAR(32) PRIMARY KEY,
    col2 NUMBER(38,0),
    col3 NUMBER(38,0),
    FOREIGN KEY (col2) REFERENCES ref_hybrid_table(col2),
    INDEX index_col3 (col3)
);

-- Example 17611
The value is too long for index "IDX_HT100_COLS".

-- Example 17612
CREATE TABLE table1 (i int);
BEGIN TRANSACTION;
INSERT INTO table1 (i) VALUES (1);
INSERT INTO table1 (i) VALUES ('This is not a valid integer.');    -- FAILS!
INSERT INTO table1 (i) VALUES (2);
COMMIT;
SELECT i FROM table1 ORDER BY i;

-- Example 17613
Modifying a transaction that has started at a different scope is not allowed.

-- Example 17614
CREATE PROCEDURE ...
  AS
  $$
    ...
    statement1;

    BEGIN TRANSACTION;
    statement2;
    COMMIT;

    statement3;
    ...

  $$;

-- Example 17615
CREATE PROCEDURE my_procedure()
  ...
  AS
  $$
    statement X;
    statement Y;
  $$;

BEGIN TRANSACTION;
  statement W;
  CALL my_procedure();
  statement Z;
COMMIT;

-- Example 17616
BEGIN TRANSACTION;
statement W;
statement X;
statement Y;
statement Z;
COMMIT;

-- Example 17617
CREATE PROCEDURE p1()
...
$$
  BEGIN TRANSACTION;
  statement C;
  statement D;
  COMMIT;

  BEGIN TRANSACTION;
  statement E;
  statement F;
  COMMIT;
$$;

-- Example 17618
BEGIN TRANSACTION;
statement A;
statement B;
COMMIT;

CALL p1();

BEGIN TRANSACTION;
statement G;
statement H;
COMMIT;

-- Example 17619
BEGIN TRANSACTION;
statement A;
statement B;
COMMIT;

BEGIN TRANSACTION;
statement C;
statement D;
COMMIT;

BEGIN TRANSACTION;
statement E;
statement F;
COMMIT;

BEGIN TRANSACTION;
statement G;
statement H;
COMMIT;

-- Example 17620
CREATE PROCEDURE p2()
...
$$
  BEGIN TRANSACTION;
  statement C;
  COMMIT;
$$;

CREATE PROCEDURE p1()
...
$$
  BEGIN TRANSACTION;
  statement B;
  CALL p2();
  statement D;
  COMMIT;
$$;

BEGIN TRANSACTION;
statement A;
CALL p1();
statement E;
COMMIT;

-- Example 17621
CREATE PROCEDURE p1() ...
$$
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
CALL p1;
COMMIT WORK;

-- Example 17622
CREATE PROCEDURE p1() ...
$$
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
BEGIN TRANSACTION;
CALL p1;
COMMIT WORK;

-- Example 17623
CREATE PROCEDURE p1() ...
$$
  BEGIN TRANSACTION;
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
  COMMIT WORK;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
CALL p1;

-- Example 17624
CREATE OR REPLACE PROCEDURE outer_sp1()
...
AS
$$
  INSERT 'osp1_alpha';
  BEGIN WORK;
  INSERT 'osp1_beta';
  CALL inner_sp2();
  INSERT 'osp1_delta';
  COMMIT WORK;
  INSERT 'osp1_omega';
$$;

CREATE OR REPLACE PROCEDURE inner_sp2()
...
AS
$$
  BEGIN WORK;
  INSERT 'isp2';
  -- Missing COMMIT, so implicitly rolls back!
$$;

CALL outer_sp1();

SELECT * FROM st;

-- Example 17625
ALTER SESSION SET LOCK_TIMEOUT=7200;
SHOW PARAMETERS LIKE 'lock_timeout';

-- Example 17626
+--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------+
| key          | value | default | level   | description                                                                   | type   |
|--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------|
| LOCK_TIMEOUT | 7200  | 43200   | SESSION | Number of seconds to wait while trying to lock a resource, before timing out  | NUMBER |
|              |       |         |         | and aborting the statement. A value of 0 turns off lock waiting i.e. the      |        |
|              |       |         |         | statement must acquire the lock immediately or abort. If multiple resources   |        |
|              |       |         |         | need to be locked by the statement, the timeout applies separately to each    |        |
|              |       |         |         | lock attempt.                                                                 |        |
+--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------+

-- Example 17627
ALTER SESSION SET HYBRID_TABLE_LOCK_TIMEOUT=600;
SHOW PARAMETERS LIKE 'hybrid_table_lock_timeout';

-- Example 17628
+---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------|
| key                       | value | default | level   | description                                                                    | type   |
|---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------+
| HYBRID_TABLE_LOCK_TIMEOUT | 600   | 3600    | SESSION | Number of seconds to wait while trying to acquire locks, before timing out and | NUMBER |
|                           |       |         |         | aborting the statement. A value of 0 turns off lock waiting i.e. the statement |        |
|                           |       |         |         | must acquire the lock immediately or abort.                                    |        |
+---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------+

-- Example 17629
SELECT query_id, query_text, start_time, session_id, execution_status, total_elapsed_time,
       compilation_time, execution_time, transaction_blocked_time
  FROM snowflake.account_usage.query_history
  WHERE start_time >= dateadd('hours', -24, current_timestamp())
  AND transaction_blocked_time > 0
  ORDER BY transaction_blocked_time DESC;

-- Example 17630
SELECT object_name, lock_type, transaction_id, blocker_queries
  FROM snowflake.account_usage.lock_wait_history
  WHERE query_id = '<query_id>';

-- Example 17631
SELECT query_id, query_text, start_time, session_id, execution_status, total_elapsed_time, compilation_time, execution_time
  FROM snowflake.account_usage.query_history
  WHERE transaction_id = '<transaction_id>';

-- Example 17632
SHOW TRANSACTIONS;

-- Example 17633
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+
|                  id | user    |         session | name                                 | started_on                    | state   | scope |
|---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------|
| 1721165674582000000 | CALIBAN | 186457423713330 | 551f494d-90ed-438d-b32b-1161396c3a22 | 2024-07-16 14:34:34.582 -0700 | running |     0 |
| 1721165584820000000 | CALIBAN | 186457423749354 | a092aa44-9a0a-4955-9659-123b35c0efeb | 2024-07-16 14:33:04.820 -0700 | running |     0 |
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+

-- Example 17634
SELECT CURRENT_TRANSACTION();

-- Example 17635
+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1721161383427000000   |
+-----------------------+

-- Example 17636
DESCRIBE TRANSACTION 1721161383427000000;

-- Example 17637
+---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------+
|                  id | user    |        session | name                                 | started_on                    | state     | ended_on                      |
|---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------|
| 1721161383427000000 | CALIBAN | 10363774361222 | 7db0ec5c-2e5d-47be-ac37-66cbf905668b | 2024-07-16 13:23:03.427 -0700 | committed | 2024-07-16 13:24:14.402 -0700 |
+---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------+

-- Example 17638
SHOW LOCKS;

-- Example 17639
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+
| resource            | type |         transaction | transaction_started_on        | status  | acquired_on | query_id                             |
|---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------|
| 1721165584820000000 | ROW  | 1721165584820000000 | 2024-07-16 14:33:04.820 -0700 | HOLDING | NULL        |                                      |
| 1721165584820000000 | ROW  | 1721165674582000000 | 2024-07-16 14:34:34.582 -0700 | WAITING | NULL        | 01b5b715-0002-852b-0000-a99500665352 |
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+

-- Example 17640
SELECT query_id, object_name, transaction_id, blocker_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOCK_WAIT_HISTORY
  WHERE requested_at >= DATEADD('hours', -48, CURRENT_TIMESTAMP()) LIMIT 1;

-- Example 17641
+--------------------------------------+-------------+---------------------+---------------------------------------------------------+
| QUERY_ID                             | OBJECT_NAME |      TRANSACTION_ID | BLOCKER_QUERIES                                         |
|--------------------------------------+-------------+---------------------+---------------------------------------------------------|
| 01b5b715-0002-852b-0000-a99500665352 | Row         | 1721165674582000000 | [                                                       |
|                                      |             |                     |   {                                                     |
|                                      |             |                     |     "is_snowflake": false,                              |
|                                      |             |                     |     "query_id": "01b5b70d-0002-8513-0000-a9950065d43e", |
|                                      |             |                     |     "transaction_id": 1721165584820000000               |
|                                      |             |                     |   }                                                     |
|                                      |             |                     | ]                                                       |
+--------------------------------------+-------------+---------------------+---------------------------------------------------------+

-- Example 17642
create table tracker_1 (id integer, name varchar);
create table tracker_2 (id integer, name varchar);

-- Example 17643
create procedure sp1()
returns varchar
language javascript
AS
$$
    // This is part of the outer transaction that started before this
    // stored procedure was called. This is committed or rolled back
    // as part of that outer transaction.
    snowflake.execute (
        {sqlText: "insert into tracker_1 values (11, 'p1_alpha')"}
        );

    // This is an independent transaction. Anything inserted as part of this
    // transaction is committed or rolled back based on this transaction.
    snowflake.execute (
        {sqlText: "begin transaction"}
        );
    snowflake.execute (
        {sqlText: "insert into tracker_2 values (12, 'p1_bravo')"}
        );
    snowflake.execute (
        {sqlText: "rollback"}
        );

    // This is part of the outer transaction started before this
    // stored procedure was called. This is committed or rolled back
    // as part of that outer transaction.
    snowflake.execute (
        {sqlText: "insert into tracker_1 values (13, 'p1_charlie')"}
        );

    // Dummy value.
    return "";
$$;

-- Example 17644
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1();
insert into tracker_1 values (09, 'outer_zulu');
commit;

-- Example 17645
select id, name FROM tracker_1
union all
select id, name FROM tracker_2
order by id;
+----+-------------+
| ID | NAME        |
|----+-------------|
|  0 | outer_alpha |
|  9 | outer_zulu  |
| 11 | p1_alpha    |
| 13 | p1_charlie  |
+----+-------------+

-- Example 17646
create table data_table (id integer);
create table log_table (message varchar);

-- Example 17647
create procedure log_message(MESSAGE VARCHAR)
returns varchar
language javascript
AS
$$
    // This is an independent transaction. Anything inserted as part of this
    // transaction is committed or rolled back based on this transaction.
    snowflake.execute (
        {sqlText: "begin transaction"}
        );
    snowflake.execute (
        {sqlText: "insert into log_table values ('" + MESSAGE + "')"}
        );
    snowflake.execute (
        {sqlText: "commit"}
        );

    // Dummy value.
    return "";
$$;

create procedure update_data()
returns varchar
language javascript
AS
$$
    snowflake.execute (
        {sqlText: "begin transaction"}
        );
    snowflake.execute (
        {sqlText: "insert into data_table (id) values (17)"}
        );
    snowflake.execute (
        {sqlText: "call log_message('You should see this saved.')"}
        );
    snowflake.execute (
        {sqlText: "rollback"}
        );

    // Dummy value.
    return "";
$$;

-- Example 17648
begin transaction;
call update_data();
rollback;

-- Example 17649
select * from data_table;
+----+
| ID |
|----|
+----+

-- Example 17650
select * from log_table;
+----------------------------+
| MESSAGE                    |
|----------------------------|
| You should see this saved. |
+----------------------------+

-- Example 17651
create table tracker_1 (id integer, name varchar);
create table tracker_2 (id integer, name varchar);
create table tracker_3 (id integer, name varchar);

-- Example 17652
create procedure sp1_outer(
    USE_BEGIN varchar,
    USE_INNER_BEGIN varchar,
    USE_INNER_COMMIT_OR_ROLLBACK varchar,
    USE_COMMIT_OR_ROLLBACK varchar
    )
returns varchar
language javascript
AS
$$
    // This should be part of the outer transaction started before this
    // stored procedure was called. This should be committed or rolled back
    // as part of that outer transaction.
    snowflake.execute (
        {sqlText: "insert into tracker_1 values (11, 'p1_alpha')"}
        );

    // This is an independent transaction. Anything inserted as part of this
    // transaction is committed or rolled back based on this transaction.
    if (USE_BEGIN != '')  {
        snowflake.execute (
            {sqlText: USE_BEGIN}
            );
        }
    snowflake.execute (
        {sqlText: "insert into tracker_2 values (12, 'p1_bravo')"}
        );
    // Call (and optionally begin/commit-or-rollback) an inner stored proc...
    var command = "call sp2_inner('";
    command = command.concat(USE_INNER_BEGIN);
    command = command.concat("', '");
    command = command.concat(USE_INNER_COMMIT_OR_ROLLBACK);
    command = command.concat( "')" );
    snowflake.execute (
        {sqlText: command}
        );
    if (USE_COMMIT_OR_ROLLBACK != '') {
        snowflake.execute (
            {sqlText: USE_COMMIT_OR_ROLLBACK}
            );
        }

    // This is part of the outer transaction started before this
    // stored procedure was called. This is committed or rolled back
    // as part of that outer transaction.
    snowflake.execute (
        {sqlText: "insert into tracker_1 values (13, 'p1_charlie')"}
        );

    // Dummy value.
    return "";
$$;

-- Example 17653
create procedure sp2_inner(
    USE_BEGIN varchar,
    USE_COMMIT_OR_ROLLBACK varchar)
returns varchar
language javascript
AS
$$
    snowflake.execute (
        {sqlText: "insert into tracker_2 values (21, 'p2_alpha')"}
        );

    if (USE_BEGIN != '')  {
        snowflake.execute (
            {sqlText: USE_BEGIN}
            );
        }
    snowflake.execute (
        {sqlText: "insert into tracker_3 values (22, 'p2_bravo')"}
        );
    if (USE_COMMIT_OR_ROLLBACK != '')  {
        snowflake.execute (
            {sqlText: USE_COMMIT_OR_ROLLBACK}
            );
        }

    snowflake.execute (
        {sqlText: "insert into tracker_2 values (23, 'p2_charlie')"}
        );

    // Dummy value.
    return "";
$$;

-- Example 17654
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1_outer('begin transaction', 'begin transaction', 'rollback', 'commit');
insert into tracker_1 values (09, 'outer_charlie');
rollback;

-- Example 17655
-- Should return only 12, 21, 23.
select id, name from tracker_1
union all
select id, name from tracker_2
union all
select id, name from tracker_3
order by id;
+----+------------+
| ID | NAME       |
|----+------------|
| 12 | p1_bravo   |
| 21 | p2_alpha   |
| 23 | p2_charlie |
+----+------------+

-- Example 17656
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1_outer('begin transaction', 'begin transaction', 'commit', 'rollback');
insert into tracker_1 values (09, 'outer_charlie');
commit;

-- Example 17657
select id, name from tracker_1
union all
select id, name from tracker_2
union all
select id, name from tracker_3
order by id;
+----+---------------+
| ID | NAME          |
|----+---------------|
|  0 | outer_alpha   |
|  9 | outer_charlie |
| 11 | p1_alpha      |
| 13 | p1_charlie    |
| 22 | p2_bravo      |
+----+---------------+

-- Example 17658
begin transaction;

create table parent(id integer);
create table child (child_id integer, parent_ID integer);

-- ----------------------------------------------------- --
-- Wrap multiple related statements in a transaction,
-- and use try/catch to commit or roll back.
-- ----------------------------------------------------- --
-- Create the procedure
create or replace procedure cleanup(FORCE_FAILURE varchar)
  returns varchar not null
  language javascript
  as
  $$
  var result = "";
  snowflake.execute( {sqlText: "begin transaction;"} );
  try {
      snowflake.execute( {sqlText: "delete from child where parent_id = 1;"} );
      snowflake.execute( {sqlText: "delete from parent where id = 1;"} );
      if (FORCE_FAILURE === "fail")  {
          // To see what happens if there is a failure/rollback,
          snowflake.execute( {sqlText: "delete from no_such_table;"} );
          }
      snowflake.execute( {sqlText: "commit;"} );
      result = "Succeeded";
      }
  catch (err)  {
      snowflake.execute( {sqlText: "rollback;"} );
      return "Failed: " + err;   // Return a success/error indicator.
      }
  return result;
  $$
  ;

commit;

-- Example 17659
call cleanup('fail');
+----------------------------------------------------------+
| CLEANUP                                                  |
|----------------------------------------------------------|
| Failed: SQL compilation error:                           |
| Object 'NO_SUCH_TABLE' does not exist or not authorized. |
+----------------------------------------------------------+

-- Example 17660
call cleanup('do not fail');
+-----------+
| CLEANUP   |
|-----------|
| Succeeded |
+-----------+

-- Example 17661
CREATE [ OR REPLACE ]
    [ { [ { LOCAL | GLOBAL } ] TEMP | TEMPORARY | VOLATILE | TRANSIENT } ]
  TABLE [ IF NOT EXISTS ] <table_name>

  (
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
      [ [ WITH ] MASKING POLICY <policy_name> [ USING ( <col_name> , <cond_col1> , ... ) ] ]
      [ [ WITH ] PROJECTION POLICY <policy_name> ]
      [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
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
  [ COPY GRANTS ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , <col_name> ... ] ) ]
  [ [ WITH ] AGGREGATION POLICY <policy_name> [ ENTITY KEY ( <col_name> [ , <col_name> ... ] ) ] ]
  [ [ WITH ] JOIN POLICY <policy_name> [ ALLOWED JOIN KEYS ( <col_name> [ , ... ] ) ] ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17662
inlineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE
    | PRIMARY KEY
    | [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ]
  }
  [ <constraint_properties> ]

-- Example 17663
outoflineConstraint ::=
  [ CONSTRAINT <constraint_name> ]
  { UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
    | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
    | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
      REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
  }
  [ <constraint_properties> ]
  [ COMMENT '<string_literal>' ]

-- Example 17664
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

-- Example 17665
CREATE [ OR REPLACE ] TABLE <table_name> [ ( <col_name> [ <col_type> ] , <col_name> [ <col_type> ] , ... ) ]
  [ CLUSTER BY ( <expr> [ , <expr> , ... ] ) ]
  [ COPY GRANTS ]
  AS <query>
  [ ... ]

