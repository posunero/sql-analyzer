-- Example 2721
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 2722
SHOW VARIABLES;

-- Example 2723
+----------------+-------------------------------+-------------------------------+------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name | value | type  | comment |
|----------------+-------------------------------+-------------------------------+------+-------+-------+---------|
| 10363773891062 | 2024-06-28 10:09:57.990 -0700 | 2024-06-28 10:09:58.032 -0700 | MAX  | 70    | fixed |         |
| 10363773891062 | 2024-06-28 10:09:57.990 -0700 | 2024-06-28 10:09:58.021 -0700 | MIN  | 40    | fixed |         |
+----------------+-------------------------------+-------------------------------+------+-------+-------+---------+

-- Example 2724
SET var_artist_name = 'Jackson Browne';

-- Example 2725
+----------------------------------+
| status                           |
+----------------------------------+
| Statement executed successfully. |
+----------------------------------+

-- Example 2726
SELECT GETVARIABLE('var_artist_name');

-- Example 2727
SELECT GETVARIABLE('VAR_ARTIST_NAME');

-- Example 2728
+--------------------------------+
| GETVARIABLE('VAR_ARTIST_NAME') |
+--------------------------------+
| Jackson Browne                 |
+--------------------------------+

-- Example 2729
SELECT album_title
  FROM albums
  WHERE artist = $var_artist_name;

-- Example 2730
UNSET my_variable;

-- Example 2731
INSERT INTO t (c1, c2) VALUES (1, 'Test string');

-- Example 2732
INSERT INTO t (c1, c2) VALUES (?, ?);

-- Example 2733
INSERT INTO t (col1, col2) VALUES (?, ?)

-- Example 2734
INSERT INTO t (c1) VALUES (:variable1)

-- Example 2735
EXECUTE IMMEDIATE :query USING (minimum_price, maximum_price);

-- Example 2736
LET c1 CURSOR FOR SELECT id FROM invoices WHERE price > ? AND price < ?;
OPEN c1 USING (minimum_price, maximum_price);

-- Example 2737
EXECUTE IMMEDIATE $$
DECLARE
  i INTEGER DEFAULT 1;
  v VARCHAR DEFAULT 'SnowFlake';
  r RESULTSET;
BEGIN
  CREATE OR REPLACE TABLE snowflake_scripting_bind_demo (id INTEGER, value VARCHAR);
  EXECUTE IMMEDIATE 'INSERT INTO snowflake_scripting_bind_demo (id, value)
    SELECT :1, (:2 || :1)' USING (i, v);
  r := (SELECT * FROM snowflake_scripting_bind_demo);
  RETURN TABLE(r);
END;
$$
;

-- Example 2738
+----+------------+
| ID | VALUE      |
|----+------------|
|  1 | SnowFlake1 |
+----+------------+

-- Example 2739
conn = snowflake.connector.connect( ... )
rows_to_insert = [('milk', 2), ('apple', 3), ('egg', 2)]
conn.cursor().executemany(
            "insert into grocery (item, quantity) values (?, ?)",
            rows_to_insert)

-- Example 2740
+-------+----+
| C1    | C2 |
|-------+----|
| milk  |  2 |
| apple |  3 |
| egg   |  2 |
+-------+----+

-- Example 2741
VALUES (?,?), (?,?)

-- Example 2742
INSERT INTO t VALUES (?,?), (?,?);

-- Example 2743
CREATE TABLE t (a VARIANT);
-- Code that supplies a bind value for ? of '{'a': 'abc', 'x': 'xyz'}'
INSERT INTO t SELECT PARSE_JSON(a) FROM VALUES (?);

-- Example 2744
SELECT * FROM t;

-- Example 2745
+---------------+
| A             |
|---------------|
| {             |
|   "a": "abc", |
|   "x": "xyz"  |
| }             |
+---------------+

-- Example 2746
INSERT INTO t SELECT ARRAY_CONSTRUCT(column1) FROM VALUES (?);

-- Example 2747
CREATE TABLE table1 (i int);
BEGIN TRANSACTION;
INSERT INTO table1 (i) VALUES (1);
INSERT INTO table1 (i) VALUES ('This is not a valid integer.');    -- FAILS!
INSERT INTO table1 (i) VALUES (2);
COMMIT;
SELECT i FROM table1 ORDER BY i;

-- Example 2748
Modifying a transaction that has started at a different scope is not allowed.

-- Example 2749
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

-- Example 2750
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

-- Example 2751
BEGIN TRANSACTION;
statement W;
statement X;
statement Y;
statement Z;
COMMIT;

-- Example 2752
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

-- Example 2753
BEGIN TRANSACTION;
statement A;
statement B;
COMMIT;

CALL p1();

BEGIN TRANSACTION;
statement G;
statement H;
COMMIT;

-- Example 2754
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

-- Example 2755
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

-- Example 2756
CREATE PROCEDURE p1() ...
$$
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
CALL p1;
COMMIT WORK;

-- Example 2757
CREATE PROCEDURE p1() ...
$$
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
BEGIN TRANSACTION;
CALL p1;
COMMIT WORK;

-- Example 2758
CREATE PROCEDURE p1() ...
$$
  BEGIN TRANSACTION;
  INSERT INTO parent_table ...;
  INSERT INTO child_table ...;
  COMMIT WORK;
$$;

ALTER SESSION SET AUTOCOMMIT = FALSE;
CALL p1;

-- Example 2759
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

-- Example 2760
ALTER SESSION SET LOCK_TIMEOUT=7200;
SHOW PARAMETERS LIKE 'lock_timeout';

-- Example 2761
+--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------+
| key          | value | default | level   | description                                                                   | type   |
|--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------|
| LOCK_TIMEOUT | 7200  | 43200   | SESSION | Number of seconds to wait while trying to lock a resource, before timing out  | NUMBER |
|              |       |         |         | and aborting the statement. A value of 0 turns off lock waiting i.e. the      |        |
|              |       |         |         | statement must acquire the lock immediately or abort. If multiple resources   |        |
|              |       |         |         | need to be locked by the statement, the timeout applies separately to each    |        |
|              |       |         |         | lock attempt.                                                                 |        |
+--------------+-------+---------+---------+-------------------------------------------------------------------------------+--------+

-- Example 2762
ALTER SESSION SET HYBRID_TABLE_LOCK_TIMEOUT=600;
SHOW PARAMETERS LIKE 'hybrid_table_lock_timeout';

-- Example 2763
+---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------|
| key                       | value | default | level   | description                                                                    | type   |
|---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------+
| HYBRID_TABLE_LOCK_TIMEOUT | 600   | 3600    | SESSION | Number of seconds to wait while trying to acquire locks, before timing out and | NUMBER |
|                           |       |         |         | aborting the statement. A value of 0 turns off lock waiting i.e. the statement |        |
|                           |       |         |         | must acquire the lock immediately or abort.                                    |        |
+---------------------------+-------+---------+---------+--------------------------------------------------------------------------------+--------+

-- Example 2764
SELECT query_id, query_text, start_time, session_id, execution_status, total_elapsed_time,
       compilation_time, execution_time, transaction_blocked_time
  FROM snowflake.account_usage.query_history
  WHERE start_time >= dateadd('hours', -24, current_timestamp())
  AND transaction_blocked_time > 0
  ORDER BY transaction_blocked_time DESC;

-- Example 2765
SELECT object_name, lock_type, transaction_id, blocker_queries
  FROM snowflake.account_usage.lock_wait_history
  WHERE query_id = '<query_id>';

-- Example 2766
SELECT query_id, query_text, start_time, session_id, execution_status, total_elapsed_time, compilation_time, execution_time
  FROM snowflake.account_usage.query_history
  WHERE transaction_id = '<transaction_id>';

-- Example 2767
SHOW TRANSACTIONS;

-- Example 2768
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+
|                  id | user    |         session | name                                 | started_on                    | state   | scope |
|---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------|
| 1721165674582000000 | CALIBAN | 186457423713330 | 551f494d-90ed-438d-b32b-1161396c3a22 | 2024-07-16 14:34:34.582 -0700 | running |     0 |
| 1721165584820000000 | CALIBAN | 186457423749354 | a092aa44-9a0a-4955-9659-123b35c0efeb | 2024-07-16 14:33:04.820 -0700 | running |     0 |
+---------------------+---------+-----------------+--------------------------------------+-------------------------------+---------+-------+

-- Example 2769
SELECT CURRENT_TRANSACTION();

-- Example 2770
+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1721161383427000000   |
+-----------------------+

-- Example 2771
DESCRIBE TRANSACTION 1721161383427000000;

-- Example 2772
+---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------+
|                  id | user    |        session | name                                 | started_on                    | state     | ended_on                      |
|---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------|
| 1721161383427000000 | CALIBAN | 10363774361222 | 7db0ec5c-2e5d-47be-ac37-66cbf905668b | 2024-07-16 13:23:03.427 -0700 | committed | 2024-07-16 13:24:14.402 -0700 |
+---------------------+---------+----------------+--------------------------------------+-------------------------------+-----------+-------------------------------+

-- Example 2773
SHOW LOCKS;

-- Example 2774
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+
| resource            | type |         transaction | transaction_started_on        | status  | acquired_on | query_id                             |
|---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------|
| 1721165584820000000 | ROW  | 1721165584820000000 | 2024-07-16 14:33:04.820 -0700 | HOLDING | NULL        |                                      |
| 1721165584820000000 | ROW  | 1721165674582000000 | 2024-07-16 14:34:34.582 -0700 | WAITING | NULL        | 01b5b715-0002-852b-0000-a99500665352 |
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+

-- Example 2775
SELECT query_id, object_name, transaction_id, blocker_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOCK_WAIT_HISTORY
  WHERE requested_at >= DATEADD('hours', -48, CURRENT_TIMESTAMP()) LIMIT 1;

-- Example 2776
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

-- Example 2777
create table tracker_1 (id integer, name varchar);
create table tracker_2 (id integer, name varchar);

-- Example 2778
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

-- Example 2779
begin transaction;
insert into tracker_1 values (00, 'outer_alpha');
call sp1();
insert into tracker_1 values (09, 'outer_zulu');
commit;

-- Example 2780
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

-- Example 2781
create table data_table (id integer);
create table log_table (message varchar);

-- Example 2782
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

-- Example 2783
begin transaction;
call update_data();
rollback;

-- Example 2784
select * from data_table;
+----+
| ID |
|----|
+----+

-- Example 2785
select * from log_table;
+----------------------------+
| MESSAGE                    |
|----------------------------|
| You should see this saved. |
+----------------------------+

-- Example 2786
create table tracker_1 (id integer, name varchar);
create table tracker_2 (id integer, name varchar);
create table tracker_3 (id integer, name varchar);

-- Example 2787
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

-- Example 2788
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

