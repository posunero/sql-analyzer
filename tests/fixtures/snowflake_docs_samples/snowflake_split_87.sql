-- Example 5810
CREATE TABLE xy (col_x DOUBLE, col_y DOUBLE);
INSERT INTO xy (col_x, col_y) VALUES
    (1.0, 2.0),
    (3.0, NULL),
    (NULL, 6.0);

-- Example 5811
SELECT col_y, col_x, REGR_VALX(col_y, col_x), REGR_VALY(col_y, col_x)
    FROM xy;
+-------+-------+-------------------------+-------------------------+
| COL_Y | COL_X | REGR_VALX(COL_Y, COL_X) | REGR_VALY(COL_Y, COL_X) |
|-------+-------+-------------------------+-------------------------|
|     2 |     1 |                       1 |                       2 |
|  NULL |     3 |                    NULL |                    NULL |
|     6 |  NULL |                    NULL |                    NULL |
+-------+-------+-------------------------+-------------------------+

-- Example 5812
REPEAT(<input>, <n>)

-- Example 5813
SELECT REPEAT('xy', 5);

-----------------+
 REPEAT('XY', 5) |
-----------------+
 xyxyxyxyxy      |
-----------------+

-- Example 5814
REPLACE( <subject> , <pattern> [ , <replacement> ] )

-- Example 5815
SELECT REPLACE('down', 'down', 'up');

-- Example 5816
+-------------------------------+
| REPLACE('DOWN', 'DOWN', 'UP') |
|-------------------------------|
| up                            |
+-------------------------------+

-- Example 5817
SELECT REPLACE('Vacation in Athens', 'Athens', 'Rome');

-- Example 5818
+-------------------------------------------------+
| REPLACE('VACATION IN ATHENS', 'ATHENS', 'ROME') |
|-------------------------------------------------|
| Vacation in Rome                                |
+-------------------------------------------------+

-- Example 5819
SELECT REPLACE('abcd', 'bc');

-- Example 5820
+-----------------------+
| REPLACE('ABCD', 'BC') |
|-----------------------|
| ad                    |
+-----------------------+

-- Example 5821
CREATE OR REPLACE TABLE replace_example(
  subject VARCHAR(10),
  pattern VARCHAR(10),
  replacement VARCHAR(10));

INSERT INTO replace_example VALUES
  ('old car', 'old car', 'new car'),
  ('sad face', 'sad', 'happy'),
  ('snowman', 'snow', 'fire');

-- Example 5822
SELECT subject,
       pattern,
       replacement,
       REPLACE(subject, pattern, replacement) AS new
  FROM replace_example
  ORDER BY subject;

-- Example 5823
+----------+---------+-------------+------------+
| SUBJECT  | PATTERN | REPLACEMENT | NEW        |
|----------+---------+-------------+------------|
| old car  | old car | new car     | new car    |
| sad face | sad     | happy       | happy face |
| snowman  | snow    | fire        | fireman    |
+----------+---------+-------------+------------+

-- Example 5824
REPLICATION_GROUP_REFRESH_HISTORY( '<secondary_group_name>' )

REPLICATION_GROUP_REFRESH_HISTORY_ALL()

-- Example 5825
SELECT phase_name, start_time, end_time,
       total_bytes, object_count, error
  FROM TABLE(
      INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg')
  );

-- Example 5826
SELECT phase_name, start_time, end_time,
       total_bytes, object_count, error
  FROM TABLE(
      INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY_ALL()
  );

-- Example 5827
REPLICATION_GROUP_REFRESH_PROGRESS( '<secondary_group_name>' )

REPLICATION_GROUP_REFRESH_PROGRESS_BY_JOB( '<query_id>' )

REPLICATION_GROUP_REFRESH_PROGRESS_ALL()

-- Example 5828
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('rg1'));

-- Example 5829
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(
    INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS_BY_JOB(
      '012a3b45-1234-a12b-0000-1aa200012345'));

-- Example 5830
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS_ALL());

-- Example 5831
REPLICATION_GROUP_USAGE_HISTORY(
   [ DATE_RANGE_START => <constant_expr> ]
   [, DATE_RANGE_END => <constant_expr> ]
   [, REPLICATION_GROUP_NAME => '<string>' ] )

-- Example 5832
SELECT START_TIME, END_TIME, REPLICATION_GROUP_NAME, CREDITS_USED, BYTES_TRANSFERRED
  FROM TABLE(information_schema.replication_group_usage_history(date_range_start=>dateadd('day', -7, current_date())));

-- Example 5833
SELECT START_TIME, END_TIME, REPLICATION_GROUP_NAME, CREDITS_USED, BYTES_TRANSFERRED
  FROM TABLE(information_schema.replication_group_usage_history(
    date_range_start => dateadd('day', -7, current_date()),
    replication_group_name => 'myrg'
));

-- Example 5834
REPLICATION_USAGE_HISTORY(
  [ DATE_RANGE_START => <constant_expr> ]
  [ , DATE_RANGE_END => <constant_expr> ]
  [ , DATABASE_NAME => '<string>' ] )

-- Example 5835
select *
  from table(information_schema.replication_usage_history(
    date_range_start=>'2019-02-10 12:00:00.000 +0000',
    date_range_end=>'2019-02-10 12:30:00.000 +0000'));

-- Example 5836
select *
  from table(information_schema.replication_usage_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 5837
select *
  from table(information_schema.replication_usage_history(
    date_range_start=>dateadd(d, -7, current_date),
    date_range_end=>current_date));

-- Example 5838
select *
  from table(information_schema.replication_usage_history(
    date_range_start=>dateadd(d, -7, current_date),
    date_range_end=>current_date,
    database_name=>'mydb'));

-- Example 5839
REST_EVENT_HISTORY(
      REST_SERVICE_TYPE => 'scim'
      [, TIME_RANGE_START => <constant_expr> ]
      [, TIME_RANGE_END => <constant_expr> ]
      [, RESULT_LIMIT => <integer> ] )

-- Example 5840
use role accountadmin;
use database my_db;
use schema information_schema;
select *
  from table(rest_event_history(
      rest_service_type => 'scim',
      time_range_start => dateadd('minutes',-5,current_timestamp()),
      time_range_end => current_timestamp(),
      200))
  order by event_timestamp;

-- Example 5841
RESULT_SCAN ( { '<query_id>' | <query_index>  | LAST_QUERY_ID() } )

-- Example 5842
SELECT LAST_QUERY_ID(-2);

-- Example 5843
SELECT $1 AS value FROM VALUES (1), (2), (3);

+-------+
| VALUE |
|-------|
|     1 |
|     2 |
|     3 |
+-------+

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) WHERE value > 1;

+-------+
| VALUE |
|-------|
|     2 |
|     3 |
+-------+

-- Example 5844
SELECT * FROM table(RESULT_SCAN(LAST_QUERY_ID(-2)));

-- Example 5845
SELECT * FROM table(RESULT_SCAN(LAST_QUERY_ID(1)));

-- Example 5846
SELECT c2 FROM TABLE(RESULT_SCAN('ce6687a4-331b-4a57-a061-02b2b0f0c17c'));

-- Example 5847
DESC USER jessicajones;
SELECT "property", "value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'DEFAULT_ROLE'
  ;

-- Example 5848
SHOW TABLES;
-- Show the tables that are more than 21 days old and that are empty
-- (i.e. tables that I might have forgotten about).
SELECT "database_name", "schema_name", "name" as "table_name", "rows", "created_on"
    FROM table(RESULT_SCAN(LAST_QUERY_ID()))
    WHERE "rows" = 0 AND "created_on" < DATEADD(day, -21, CURRENT_TIMESTAMP())
    ORDER BY "created_on";

-- Example 5849
-- Show byte counts with suffixes such as "KB", "MB", and "GB".
CREATE OR REPLACE FUNCTION NiceBytes(NUMBER_OF_BYTES INTEGER)
RETURNS VARCHAR
AS
$$
CASE
    WHEN NUMBER_OF_BYTES < 1024
        THEN NUMBER_OF_BYTES::VARCHAR
    WHEN NUMBER_OF_BYTES >= 1024 AND NUMBER_OF_BYTES < 1048576
        THEN (NUMBER_OF_BYTES / 1024)::VARCHAR || 'KB'
   WHEN NUMBER_OF_BYTES >= 1048576 AND NUMBER_OF_BYTES < (POW(2, 30))
       THEN (NUMBER_OF_BYTES / 1048576)::VARCHAR || 'MB'
    ELSE
        (NUMBER_OF_BYTES / POW(2, 30))::VARCHAR || 'GB'
END
$$
;
SHOW TABLES;
-- Show all of my tables in descending order of size.
SELECT "database_name", "schema_name", "name" as "table_name", NiceBytes("bytes") AS "size"
    FROM table(RESULT_SCAN(LAST_QUERY_ID()))
    ORDER BY "bytes" DESC;

-- Example 5850
CREATE OR REPLACE PROCEDURE return_JSON()
    RETURNS VARCHAR
    LANGUAGE JavaScript
    AS
    $$
        return '{"keyA": "ValueA", "keyB": "ValueB"}';
    $$
    ;

-- Example 5851
CALL return_JSON();
+--------------------------------------+
| RETURN_JSON                          |
|--------------------------------------|
| {"keyA": "ValueA", "keyB": "ValueB"} |
+--------------------------------------+

-- Example 5852
SELECT $1 AS output_col FROM table(RESULT_SCAN(LAST_QUERY_ID()));
+--------------------------------------+
| OUTPUT_COL                           |
|--------------------------------------|
| {"keyA": "ValueA", "keyB": "ValueB"} |
+--------------------------------------+

-- Example 5853
SELECT PARSE_JSON(output_col) AS JSON_COL FROM table(RESULT_SCAN(LAST_QUERY_ID()));
+---------------------+
| JSON_COL            |
|---------------------|
| {                   |
|   "keyA": "ValueA", |
|   "keyB": "ValueB"  |
| }                   |
+---------------------+

-- Example 5854
SELECT JSON_COL:keyB FROM table(RESULT_SCAN(LAST_QUERY_ID()));
+---------------+
| JSON_COL:KEYB |
|---------------|
| "ValueB"      |
+---------------+

-- Example 5855
CALL return_JSON();
+--------------------------------------+
| RETURN_JSON                          |
|--------------------------------------|
| {"keyA": "ValueA", "keyB": "ValueB"} |
+--------------------------------------+
SELECT JSON_COL:keyB 
   FROM (
        SELECT PARSE_JSON($1::VARIANT) AS JSON_COL 
            FROM table(RESULT_SCAN(LAST_QUERY_ID()))
        );
+---------------+
| JSON_COL:KEYB |
|---------------|
| "ValueB"      |
+---------------+

-- Example 5856
+--------------------------------------+
|              RETURN_JSON             |
+--------------------------------------+
| {"keyA": "ValueA", "keyB": "ValueB"} |
+--------------------------------------+

-- Example 5857
CALL return_JSON();
+--------------------------------------+
| RETURN_JSON                          |
|--------------------------------------|
| {"keyA": "ValueA", "keyB": "ValueB"} |
+--------------------------------------+
SELECT JSON_COL:keyB
        FROM (
             SELECT PARSE_JSON(RETURN_JSON::VARIANT) AS JSON_COL 
                 FROM table(RESULT_SCAN(LAST_QUERY_ID()))
             );
+---------------+
| JSON_COL:KEYB |
|---------------|
| "ValueB"      |
+---------------+

-- Example 5858
CREATE TABLE employees (id INT);

-- Example 5859
CREATE TABLE dependents (id INT, employee_id INT);

-- Example 5860
INSERT INTO employees (id) VALUES (11);

-- Example 5861
INSERT INTO dependents (id, employee_id) VALUES (101, 11);

-- Example 5862
SELECT * 
    FROM employees INNER JOIN dependents
        ON dependents.employee_ID = employees.id
    ORDER BY employees.id, dependents.id
    ;
+----+-----+-------------+
| ID |  ID | EMPLOYEE_ID |
|----+-----+-------------|
| 11 | 101 |          11 |
+----+-----+-------------+

-- Example 5863
SELECT id, id_1, employee_id
    FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
    WHERE id_1 = 101;
+----+------+-------------+
| ID | ID_1 | EMPLOYEE_ID |
|----+------+-------------|
| 11 |  101 |          11 |
+----+------+-------------+

-- Example 5864
REVERSE(<subject>)

-- Example 5865
SELECT REVERSE('Hello, world!');
+--------------------------+
| REVERSE('HELLO, WORLD!') |
|--------------------------|
| !dlrow ,olleH            |
+--------------------------+

-- Example 5866
SELECT '2019-05-22'::DATE, REVERSE('2019-05-22'::DATE) AS reversed;
+--------------------+------------+
| '2019-05-22'::DATE | REVERSED   |
|--------------------+------------|
| 2019-05-22         | 22-50-9102 |
+--------------------+------------+

-- Example 5867
CREATE TABLE strings (s1 VARCHAR COLLATE 'en', s2 VARCHAR COLLATE 'hu');
INSERT INTO strings (s1, s2) VALUES ('dzsa', COLLATE('dzsa', 'hu'));

-- Example 5868
SELECT s1, s2, REVERSE(s1), REVERSE(s2) 
    FROM strings;
+------+------+-------------+-------------+
| S1   | S2   | REVERSE(S1) | REVERSE(S2) |
|------+------+-------------+-------------|
| dzsa | dzsa | aszd        | aszd        |
+------+------+-------------+-------------+

-- Example 5869
RIGHT( <string_expr> , <length_expr> )

-- Example 5870
SELECT RIGHT('ABCDEFG', 3);

-- Example 5871
+---------------------+
| RIGHT('ABCDEFG', 3) |
|---------------------|
| EFG                 |
+---------------------+

-- Example 5872
CREATE OR REPLACE TABLE customer_contact_example (
    cust_id INT,
    cust_email VARCHAR,
    cust_phone VARCHAR,
    activation_date VARCHAR)
  AS SELECT
    column1,
    column2,
    column3,
    column4
  FROM
    VALUES
      (1, 'some_text@example.com', '800-555-0100', '20210320'),
      (2, 'some_other_text@example.org', '800-555-0101', '20240509'),
      (3, 'some_different_text@example.net', '800-555-0102', '20191017');

SELECT * from customer_contact_example;

-- Example 5873
+---------+---------------------------------+--------------+-----------------+
| CUST_ID | CUST_EMAIL                      | CUST_PHONE   | ACTIVATION_DATE |
|---------+---------------------------------+--------------+-----------------|
|       1 | some_text@example.com           | 800-555-0100 | 20210320        |
|       2 | some_other_text@example.org     | 800-555-0101 | 20240509        |
|       3 | some_different_text@example.net | 800-555-0102 | 20191017        |
+---------+---------------------------------+--------------+-----------------+

-- Example 5874
SELECT cust_id,
       cust_email,
       RIGHT(cust_email, LENGTH(cust_email) - (POSITION('@' IN cust_email))) AS domain
  FROM customer_contact_example;

-- Example 5875
+---------+---------------------------------+-------------+
| CUST_ID | CUST_EMAIL                      | DOMAIN      |
|---------+---------------------------------+-------------|
|       1 | some_text@example.com           | example.com |
|       2 | some_other_text@example.org     | example.org |
|       3 | some_different_text@example.net | example.net |
+---------+---------------------------------+-------------+

-- Example 5876
SELECT cust_id,
       cust_phone,
       RIGHT(cust_phone, 8) AS phone_without_area_code
  FROM customer_contact_example;

