-- Example 26775
jar cmf my_udf.manifest ./my_udf.jar example/MyClass.class

-- Example 26776
CREATE OR REPLACE TABLE test_larger_sizes(col1 VARCHAR, col2 VARCHAR) AS
  SELECT 'foo', 'bar';

SELECT SYSTEM$TYPEOF(CONCAT(col1, col2)) FROM test_larger_sizes;

-- Example 26777
+-----------------------------------+
| SYSTEM$TYPEOF(CONCAT(COL1, COL2)) |
|-----------------------------------|
| VARCHAR(33554432)[LOB]            |
+-----------------------------------+

-- Example 26778
CREATE OR REPLACE FUNCTION test_larger_sized_func(in_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  CALLED ON NULL INPUT AS
$$
  RETURN NULL;
$$
;

SELECT data_type FROM INFORMATION_SCHEMA.FUNCTIONS
  WHERE function_name = 'TEST_LARGER_SIZED_FUNC';

-- Example 26779
+--------------------+
| DATA_TYPE          |
|--------------------|
| VARCHAR(134217728) |
+--------------------+

-- Example 26780
CREATE OR REPLACE TABLE test_larger_size_error(col VARCHAR);
INSERT INTO test_larger_size_error SELECT RANDSTR(20000000, 1);

-- Example 26781
100082 (22000): Max LOB size (16777216) exceeded, actual size of parsed column is 20000000

-- Example 26782
100078 (22000): String
'CaFHJdoX3upWliCCdAPXXgytQuXzQpFO4laQEFdmiE1NDOywjwHoBqSNTCzTW66ynuR7EsI4ZxStCh3VMIBMYeHWgv1gUZRmHEK4kGmZcC02jGQhnnFJ0jtcIEWBIN6vKGkvSwG482IvfgVVwF3FTj7sb86t1SK9qigI6ujlSNByytIYBk0lkI1MM0zpRFeH2BNvGxtI.'
is too long and would be truncated

-- Example 26783
100067 (54000): The data length in result column <column_name> is not supported by this version of the client.
Actual length <actual_size> exceeds supported length of 16777216.

-- Example 26784
ALTER ICEBERG TABLE my_iceberg_table
  ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

-- Example 26785
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 26786
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 26787
DESC STORAGE INTEGRATION <integration_name>;

-- Example 26788
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 26789
$ gsutil notification create -t <topic> -f json -e OBJECT_FINALIZE -e OBJECT_DELETE gs://<bucket-name>

-- Example 26790
CREATE NOTIFICATION INTEGRATION <integration_name>
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>';

-- Example 26791
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

-- Example 26792
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 26793
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 26794
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 26795
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 26796
CREATE OR REPLACE EXTERNAL TABLE ext_table
 INTEGRATION = 'MY_NOTIFICATION_INT'
 WITH LOCATION = @mystage/path1/
 FILE_FORMAT = (TYPE = JSON);

-- Example 26797
ALTER EXTERNAL TABLE ext_table REFRESH;

+---------------------------------------------+----------------+-------------------------------+
| file                                        | status         | description                   |
|---------------------------------------------+----------------+-------------------------------|
| files/path1/file1.json                      | REGISTERED_NEW | File registered successfully. |
| files/path1/file2.json                      | REGISTERED_NEW | File registered successfully. |
| files/path1/file3.json                      | REGISTERED_NEW | File registered successfully. |
+---------------------------------------------+----------------+-------------------------------+

-- Example 26798
-- Create a table to store the names and fees paid by members of a gym
CREATE OR REPLACE TABLE members (
  id number(8) NOT NULL,
  name varchar(255) default NULL,
  fee number(3) NULL
);

-- Create a stream to track changes to date in the MEMBERS table
CREATE OR REPLACE STREAM member_check ON TABLE members;

-- Create a table to store the dates when gym members joined
CREATE OR REPLACE TABLE signup (
  id number(8),
  dt DATE
  );

INSERT INTO members (id,name,fee)
VALUES
(1,'Joe',0),
(2,'Jane',0),
(3,'George',0),
(4,'Betty',0),
(5,'Sally',0);

INSERT INTO signup
VALUES
(1,'2018-01-01'),
(2,'2018-02-15'),
(3,'2018-05-01'),
(4,'2018-07-16'),
(5,'2018-08-21');

-- The stream records the inserted rows
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    |   0 | INSERT          | False             | d200504bf3049a7d515214408d9a804fd03b46cd |
|  2 | Jane   |   0 | INSERT          | False             | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
|  3 | George |   0 | INSERT          | False             | b98ad609fffdd6f00369485a896c52ca93b92b1f |
|  4 | Betty  |   0 | INSERT          | False             | e554e6e68293a51d8e69d68e9b6be991453cc901 |
|  5 | Sally  |   0 | INSERT          | False             | c94366cf8a4270cf299b049af68a04401c13976d |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Apply a $90 fee to members who joined the gym after a free trial period ended:
MERGE INTO members m
  USING (
    SELECT id, dt
    FROM signup s
    WHERE DATEDIFF(day, '2018-08-15'::date, s.dt::DATE) < -30) s
    ON m.id = s.id
  WHEN MATCHED THEN UPDATE SET m.fee = 90;

SELECT * FROM members;

+----+--------+-----+
| ID | NAME   | FEE |
|----+--------+-----|
|  1 | Joe    |  90 |
|  2 | Jane   |  90 |
|  3 | George |  90 |
|  4 | Betty  |   0 |
|  5 | Sally  |   0 |
+----+--------+-----+

-- The stream records the updated FEE column as a set of inserts
-- rather than deletes and inserts because the stream contents
-- have not been consumed yet
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    |  90 | INSERT          | False             | 957e84b34ef0f3d957470e02bddccb027810892c |
|  2 | Jane   |  90 | INSERT          | False             | b00168a4edb9fb399dd5cc015e5f78cbea158956 |
|  3 | George |  90 | INSERT          | False             | 75206259362a7c89126b7cb039371a39d821f76a |
|  4 | Betty  |   0 | INSERT          | False             | 9b225bc2612d5e57b775feea01dd04a32ce2ad18 |
|  5 | Sally  |   0 | INSERT          | False             | 5a68f6296c975980fbbc569ce01033c192168eca |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Create a table to store member details in production
CREATE OR REPLACE TABLE members_prod (
  id number(8) NOT NULL,
  name varchar(255) default NULL,
  fee number(3) NULL
);

-- Insert the first batch of stream data into the production table
INSERT INTO members_prod(id,name,fee) SELECT id, name, fee FROM member_check WHERE METADATA$ACTION = 'INSERT';

-- The stream position is advanced
select * from member_check;

+----+------+-----+-----------------+-------------------+-----------------+
| ID | NAME | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----+-----------------+-------------------+-----------------|
+----+------+-----+-----------------+-------------------+-----------------+

-- Access and lock the stream
BEGIN;

-- Increase the fee paid by paying members
UPDATE members SET fee = fee + 15 where fee > 0;

+------------------------+-------------------------------------+
| number of rows updated | number of multi-joined rows updated |
|------------------------+-------------------------------------|
|                      3 |                                   0 |
+------------------------+-------------------------------------+

-- These changes are not visible because the change interval of the stream object starts at the current offset and ends at the current
-- transactional time point, which is the beginning time of the transaction
SELECT * FROM member_check;

+----+------+-----+-----------------+-------------------+-----------------+
| ID | NAME | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----+-----------------+-------------------+-----------------|
+----+------+-----+-----------------+-------------------+-----------------+

-- Commit changes
COMMIT;

-- The changes surface now because the stream object uses the current transactional time as the end point of the change interval that now
-- includes the changes in the source table
SELECT * FROM member_check;

+----+--------+-----+-----------------+-------------------+------------------------------------------+
| ID | NAME   | FEE | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+--------+-----+-----------------+-------------------+------------------------------------------|
|  1 | Joe    | 105 | INSERT          | True              | 123a45b67cd0e8f012345g01abcdef012345678a |
|  2 | Jane   | 105 | INSERT          | True              | 456b45b67cd1e8f123456g01ghijkl123456779b |
|  3 | George | 105 | INSERT          | True              | 567890c89de2f9g765438j20jklmn0234567890d |
|  1 | Joe    |  90 | DELETE          | True              | 123a45b67cd0e8f012345g01abcdef012345678a |
|  2 | Jane   |  90 | DELETE          | True              | 456b45b67cd1e8f123456g01ghijkl123456779b |
|  3 | George |  90 | DELETE          | True              | 567890c89de2f9g765438j20jklmn0234567890d |
+----+--------+-----+-----------------+-------------------+------------------------------------------+

-- Example 26799
-- Create a source table.
create or replace table t(id int, name string);

-- Create a standard stream on the source table.
create or replace  stream delta_s on table t;

-- Create an append-only stream on the source table.
create or replace  stream append_only_s on table t append_only=true;

-- Insert 3 rows into the source table.
insert into t values (0, 'charlie brown');
insert into t values (1, 'lucy');
insert into t values (2, 'linus');

-- Delete 1 of the 3 rows.
delete from t where id = '0';

-- The standard stream removes the deleted row.
select * from delta_s order by id;

+----+-------+-----------------+-------------------+------------------------------------------+
| ID | NAME  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+-------+-----------------+-------------------+------------------------------------------|
|  1 | lucy  | INSERT          | False             | 7b12c9ee7af9245497a27ac4909e4aa97f126b50 |
|  2 | linus | INSERT          | False             | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+-------+-----------------+-------------------+------------------------------------------+

-- The append-only stream does not remove the deleted row.
select * from append_only_s order by id;

+----+---------------+-----------------+-------------------+------------------------------------------+
| ID | NAME          | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+---------------+-----------------+-------------------+------------------------------------------|
|  0 | charlie brown | INSERT          | False             | e83abf629af50ccf94d1e78c547bfd8079e68d00 |
|  1 | lucy          | INSERT          | False             | 7b12c9ee7af9245497a27ac4909e4aa97f126b50 |
|  2 | linus         | INSERT          | False             | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+---------------+-----------------+-------------------+------------------------------------------+

-- Create a table to store the change data capture records in each of the streams.
create or replace  table t2(id int, name string, stream_type string default NULL);

-- Insert the records from the streams into the new table, advancing the offset of each stream.
insert into t2(id,name,stream_type) select id, name, 'delta stream' from delta_s;
insert into t2(id,name,stream_type) select id, name, 'append_only stream' from append_only_s;

-- Update a row in the source table.
update t set name = 'sally' where name = 'linus';

-- The standard stream records the update operation.
select * from delta_s order by id;

+----+-------+-----------------+-------------------+------------------------------------------+
| ID | NAME  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|----+-------+-----------------+-------------------+------------------------------------------|
|  2 | sally | INSERT          | True              | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
|  2 | linus | DELETE          | True              | 461cd468d8cc2b0bd11e1e3c0d5f1133ac763d39 |
+----+-------+-----------------+-------------------+------------------------------------------+

-- The append-only stream does not record the update operation.
select * from append_only_s order by id;

+----+------+-----------------+-------------------+-----------------+
| ID | NAME | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID |
|----+------+-----------------+-------------------+-----------------|
+----+------+-----------------+-------------------+-----------------+

-- Example 26800
-- Create a staging table that stores raw JSON data
CREATE OR REPLACE TABLE data_staging (
  raw variant);

-- Create a stream on the staging table
CREATE OR REPLACE STREAM data_check ON TABLE data_staging;

-- Create 2 production tables to store transformed
-- JSON data in relational columns
CREATE OR REPLACE TABLE data_prod1 (
    id number(8),
    ts TIMESTAMP_TZ
    );

CREATE OR REPLACE TABLE data_prod2 (
    id number(8),
    color VARCHAR,
    num NUMBER
    );

-- Load JSON data into staging table
-- using COPY statement, Snowpipe,
-- or inserts

SELECT * FROM data_staging;

+--------------------------------------+
| RAW                                  |
|--------------------------------------|
| {                                    |
|   "id": 7077,                        |
|   "x1": "2018-08-14T20:57:01-07:00", |
|   "x2": [                            |
|     {                                |
|       "y1": "green",                 |
|       "y2": "35"                     |
|     }                                |
|   ]                                  |
| }                                    |
| {                                    |
|   "id": 7078,                        |
|   "x1": "2018-08-14T21:07:26-07:00", |
|   "x2": [                            |
|     {                                |
|       "y1": "cyan",                  |
|       "y2": "107"                    |
|     }                                |
|   ]                                  |
| }                                    |
+--------------------------------------+

--  Stream table shows inserted data
SELECT * FROM data_check;

+--------------------------------------+-----------------+-------------------+------------------------------------------+
| RAW                                  | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
|--------------------------------------+-----------------+-------------------|------------------------------------------|
| {                                    | INSERT          | False             | 789012e01ef4j3k890123k35mnopqr567890124j |
|   "id": 7077,                        |                 |                   |                                          |
|   "x1": "2018-08-14T20:57:01-07:00", |                 |                   |                                          |
|   "x2": [                            |                 |                   |                                          |
|     {                                |                 |                   |                                          |
|       "y1": "green",                 |                 |                   |                                          |
|       "y2": "35"                     |                 |                   |                                          |
|     }                                |                 |                   |                                          |
|   ]                                  |                 |                   |                                          |
| }                                    |                 |                   |                                          |
| {                                    | INSERT          | False             | 765432u89tk3l6y456789012rst7vx678912456k |
|   "id": 7078,                        |                 |                   |                                          |
|   "x1": "2018-08-14T21:07:26-07:00", |                 |                   |                                          |
|   "x2": [                            |                 |                   |                                          |
|     {                                |                 |                   |                                          |
|       "y1": "cyan",                  |                 |                   |                                          |
|       "y2": "107"                    |                 |                   |                                          |
|     }                                |                 |                   |                                          |
|   ]                                  |                 |                   |                                          |
| }                                    |                 |                   |                                          |
+--------------------------------------+-----------------+-------------------+------------------------------------------+

-- Access and lock the stream
BEGIN;

-- Transform and copy JSON elements into relational columns
-- in the production tables
INSERT INTO data_prod1 (id, ts)
SELECT t.raw:id, to_timestamp_tz(t.raw:x1)
FROM data_check t
WHERE METADATA$ACTION = 'INSERT';

INSERT INTO data_prod2 (id, color, num)
SELECT t.raw:id, f.value:y1, f.value:y2
FROM data_check t
, lateral flatten(input => raw:x2) f
WHERE METADATA$ACTION = 'INSERT';

-- Commit changes in the stream objects participating in the transaction
COMMIT;

SELECT * FROM data_prod1;

+------+---------------------------+
|   ID | TS                        |
|------+---------------------------|
| 7077 | 2018-08-14 20:57:01 -0700 |
| 7078 | 2018-08-14 21:07:26 -0700 |
+------+---------------------------+

SELECT * FROM data_prod2;

+------+-------+-----+
|   ID | COLOR | NUM |
|------+-------+-----|
| 7077 | green |  35 |
| 7078 | cyan  | 107 |
+------+-------+-----+

SELECT * FROM data_check;

+-----+-----------------+-------------------+
| RAW | METADATA$ACTION | METADATA$ISUPDATE |
|-----+-----------------+-------------------|
+-----+-----------------+-------------------+

-- Example 26801
-- Create multiple tables with matching column values.
CREATE TABLE birds (
  id number,
  common varchar(100),
  class varchar(100)
);

CREATE TABLE sightings (
  d date,
  loc varchar(100),
  b_id number,
  c number
);

-- Create a view that queries the tables with a join.
CREATE VIEW bird_sightings AS
SELECT b.id AS id,
       b.common AS common_name,
       b.class AS classification,
       s.d AS date,
       s.loc AS location,
       s.c AS count
FROM birds b
INNER JOIN sightings s ON b.id = s.b_id;

-- Create a stream on the view.
CREATE STREAM bird_sightings_s ON VIEW bird_sightings;

-- Insert values into the tables.
INSERT INTO birds
VALUES
    (1,'Scarlet Tanager','P. olivacea'),
    (14,'Mallard','A. platyrhynchos'),
    (48,'Spotted Sandpiper','A. macularius'),
    (92,'Great Blue Heron','A. herodias');

INSERT INTO sightings
VALUES
    (current_date(),'Gibson Island',1,4),
    (current_date(),'Lake Los Pajaro',14,12),
    (current_date(),'Lake Los Pajaro',92,12),
    (current_date(),'Gibson Island',14,21),
    (current_date(),'Gibson Island',92,5);

-- Query the stream.
-- The stream displays a record for each row added to the view.
SELECT * FROM bird_sightings_s;

+----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+
| ID | COMMON_NAME      | CLASSIFICATION   | DATE       | LOCATION        | COUNT | METADATA$ROW_ID                          | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------|
|  1 | Scarlet Tanager  | P. olivacea      | 2021-09-07 | Gibson Island   |     4 | a2522b47726ac2a922104c8e2f668d065ff6fcd0 | INSERT          | False             |
| 14 | Mallard          | A. platyrhynchos | 2021-09-07 | Lake Los Pajaro |    12 | fceb4ad5cb6d2df2865d0f572b8a2aa98f240b70 | INSERT          | False             |
| 92 | Great Blue Heron | A. herodias      | 2021-09-07 | Lake Los Pajaro |    12 | 0db99176fe8bd50749b2b48fb2befab416ff9272 | INSERT          | False             |
| 14 | Mallard          | A. platyrhynchos | 2021-09-07 | Gibson Island   |    21 | 2e94ef3a33e52ba5de5d816dc41c60fedf9cb1eb | INSERT          | False             |
| 92 | Great Blue Heron | A. herodias      | 2021-09-07 | Gibson Island   |     5 | a1df477ac8e388e1cf0ada77e9097c6effa346a7 | INSERT          | False             |
+----+------------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+

-- Consume the stream records in a DML statement (INSERT, MERGE, etc.).

-- Query the stream.
-- The stream is empty.
+----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------+
| ID | COMMON_NAME | CLASSIFICATION | DATE | LOCATION | COUNT | METADATA$ROW_ID | METADATA$ACTION | METADATA$ISUPDATE |
|----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------|
+----+-------------+----------------+------+----------+-------+-----------------+-----------------+-------------------+

-- Delete a row from the birds table.
DELETE FROM birds WHERE id = 14;

-- Query the stream.
-- The stream displays two records for the single DELETE operation.
SELECT * FROM bird_sightings_s;

+----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+
| ID | COMMON_NAME | CLASSIFICATION   | DATE       | LOCATION        | COUNT | METADATA$ROW_ID                          | METADATA$ACTION | METADATA$ISUPDATE |
|----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------|
| 14 | Mallard     | A. platyrhynchos | 2021-09-07 | Lake Los Pajaro |    12 | 83c22ff4be80d65a2e9776df0e35b22079cb4430 | DELETE          | False             |
| 14 | Mallard     | A. platyrhynchos | 2021-09-07 | Gibson Island   |    21 | e29cfae8c3c7d261ed903c2303f61e4d49c01ba1 | DELETE          | False             |
+----+-------------+------------------+------------+-----------------+-------+------------------------------------------+-----------------+-------------------+

-- Example 26802
-- Create a table.
CREATE TABLE ndf (
  c1 number
);

-- Create a view that queries the table and
-- also returns the CURRENT_USER and CURRENT_TIMESTAMP values
-- for the query transaction.
CREATE VIEW ndf_v AS
SELECT CURRENT_USER() AS u,
       CURRENT_TIMESTAMP() AS ts,
       c1 AS num
FROM ndf;

-- Create a stream on the view.
CREATE STREAM ndf_s ON VIEW ndf_v;

-- User peter inserts rows into table ndf.
INSERT INTO ndf
VALUES
    (1),
    (2),
    (3);

-- User marie inserts rows into table ndf.
INSERT INTO ndf
VALUES
    (4),
    (5),
    (6);

-- User PETER queries the stream.
-- The stream returns the username for the user.
-- The stream also returns the current timestamp for the query transaction in each row,
-- NOT the timestamp when each row was inserted.
SELECT * FROM ndf_s;

+-------+-------------------------------+-----+-----------------+------------------------------------------+
| U     | TS                            | NUM | METADATA$ACTION | METADATA$ROW_ID                          |
|-------+-------------------------------+-----+-----------------+------------------------------------------|
| PETER | 2021-08-16 11:56:33.778 -0700 |   1 | INSERT          | d200504bf3049a7d515214408d9a804fd03b46cd |
| PETER | 2021-08-16 11:56:33.778 -0700 |   2 | INSERT          | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
| PETER | 2021-08-16 11:56:33.778 -0700 |   3 | INSERT          | b98ad609fffdd6f00369485a896c52ca93b92b1f |
| PETER | 2021-08-16 11:56:33.778 -0700 |   4 | INSERT          | 62d34abc3fac85c037fb9f47f7758f08d025d9ed |
| PETER | 2021-08-16 11:56:33.778 -0700 |   5 | INSERT          | e554e6e68293a51d8e69d68e9b6be991453cc901 |
| PETER | 2021-08-16 11:56:33.778 -0700 |   6 | INSERT          | f6fa32c498a28b2349d2c6f6be55c30eb1d5310f |
+-------+-------------------------------+-----+-----------------+------------------------------------------+

-- User MARIE queries the stream.
-- The stream returns the username for the user
-- and the current timestamp for the query transaction in each row.
SELECT * FROM ndf_s;
+-------+-------------------------------+-----+-----------------+------------------------------------------+
| U     | TS                            | NUM | METADATA$ACTION | METADATA$ROW_ID                          |
|-------+-------------------------------+-----+-----------------+------------------------------------------|
| MARIE | 2021-08-16 12:04:21.768 -0700 |   1 | INSERT          | d200504bf3049a7d515214408d9a804fd03b46cd |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   2 | INSERT          | d0a551cecbee0f9ad2b8a9e81bcc33b15a525a1e |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   3 | INSERT          | b98ad609fffdd6f00369485a896c52ca93b92b1f |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   4 | INSERT          | 62d34abc3fac85c037fb9f47f7758f08d025d9ed |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   5 | INSERT          | e554e6e68293a51d8e69d68e9b6be991453cc901 |
| MARIE | 2021-08-16 12:04:21.768 -0700 |   6 | INSERT          | f6fa32c498a28b2349d2c6f6be55c30eb1d5310f |
+-------+-------------------------------+-----+-----------------+------------------------------------------+

-- Example 26803
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
   -- Message type and content.
  '{ "text/html": "<p>This is a message.</p>" }',
  -- Integration used to send the notification and values used for the subject and recipients.
  -- These values override the defaults specified in the integration.
  '{
    "my_email_int": {
      "subject": "Status update",
      "toAddress": ["person_a@example.com", "person_b@example.com"],
      "ccAddress": ["person_c@example.com"],
      "bccAddress": ["person_d@example.com"]
    }
  }'
);

-- Example 26804
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>a message</p>'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int',
    'Status update',
    ARRAY_CONSTRUCT('person_a@example.com', 'person_b@example.com'),
    ARRAY_CONSTRUCT('person_c@example.com'),
    ARRAY_CONSTRUCT('person_d@example.com')
  )
);

-- Example 26805
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{ "text/html": "<p>This is a message.</p>" }',
  '{
    "my_email_int": {
      "subject": "Status update",
      "toAddress": ["person_a@example.com", "person_b@example.com"],
      "ccAddress": ["person_c@example.com"],
      "bccAddress": ["person_d@example.com"]
    }
  }'
);

-- Example 26806
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('Your message'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int,
    'Service down',
    ARRAY_CONSTRUCT('oncall-a@example.com', 'oncall-b@example.com')
  )
);

-- Example 26807
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('Your message'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int,
    'Service down',
    ARRAY_CONSTRUCT('oncall-a@example.com', 'oncall-b@example.com'),
    ARRAY_CONSTRUCT('cc-a@example.com', 'cc-b@example.com'),
    ARRAY_CONSTRUCT('bcc-a@example.com', 'bcc-b@example.com')
  )
);

-- Example 26808
'{ "<message_type>": "<message>" }'

-- Example 26809
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{ "text/html": "<p>This is a message.</p>" }',
  '{ "my_email_int": {} }'
);

-- Example 26810
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>a message</p>'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
);

-- Example 26811
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
);

-- Example 26812
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{ "name": "value" }'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int')
);

-- Example 26813
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{"text/plain":"A message"}',
  ARRAY_CONSTRUCT(
    '{"my_sns_int":{}}',
    '{"my_email_int":{}}',
 )
);

-- Example 26814
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int'),
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
  )
);

-- Example 26815
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
    SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>A message</p>'),
    SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{ "name": "value" }')
  ),
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int'),
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
  )
);

-- Example 26816
USE ROLE ACCOUNTADMIN;

REVOKE DATABASE ROLE SNOWFLAKE.COPILOT_USER
  FROM ROLE PUBLIC;

-- Example 26817
USE ROLE ACCOUNTADMIN;

CREATE ROLE copilot_access_role;
GRANT DATABASE ROLE SNOWFLAKE.COPILOT_USER TO ROLE copilot_access_role;

GRANT ROLE copilot_access_role TO USER some_user;

-- Example 26818
GRANT DATABASE ROLE SNOWFLAKE.COPILOT_USER TO ROLE analyst;

-- Example 26819
Can you explain this query to me step-by-step?

-- Example 26820
SELECT
  github_repos.repo_name,
  COUNT(github_stars.repo_id) AS total_stars
FROM
  github_repos
  JOIN github_stars ON github_repos.repo_id = github_stars.repo_id
GROUP BY
  github_repos.repo_name
ORDER BY
  total_stars DESC;

-- Example 26821
CREATE [ OR REPLACE ] SECURITY INTEGRATION [ IF NOT EXISTS ]
    <name>
    TYPE = SAML2
    ENABLED = { TRUE | FALSE }
    SAML2_ISSUER = '<string_literal>'
    SAML2_SSO_URL = '<string_literal>'
    SAML2_PROVIDER = '<string_literal>'
    SAML2_X509_CERT = '<string_literal>'
    [ ALLOWED_USER_DOMAINS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ ALLOWED_EMAIL_PATTERNS = ( '<string_literal>' [ , '<string_literal>' , ... ] ) ]
    [ SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = '<string_literal>' ]
    [ SAML2_ENABLE_SP_INITIATED = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_X509_CERT = '<string_literal>' ]
    [ SAML2_SIGN_REQUEST = TRUE | FALSE ]
    [ SAML2_REQUESTED_NAMEID_FORMAT = '<string_literal>' ]
    [ SAML2_POST_LOGOUT_REDIRECT_URL = '<string_literal>' ]
    [ SAML2_FORCE_AUTHN = TRUE | FALSE ]
    [ SAML2_SNOWFLAKE_ISSUER_URL = '<string_literal>' ]
    [ SAML2_SNOWFLAKE_ACS_URL = '<string_literal>' ]
    [ COMMENT = '<string_literal>' ]

-- Example 26822
CREATE SECURITY INTEGRATION my_idp
    TYPE = saml2
    ENABLED = true
    SAML2_ISSUER = 'https://example.com'
    SAML2_SSO_URL = 'http://myssoprovider.com'
    SAML2_PROVIDER = 'ADFS'
    SAML2_X509_CERT = 'my_x509_cert'
    SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'my_idp'
    SAML2_ENABLE_SP_INITIATED = false
    ;

-- Example 26823
DESC SECURITY INTEGRATION my_idp;

-- Example 26824
ALTER NETWORK RULE [ IF EXISTS ] <name> SET
  VALUE_LIST = ( '<value>'  [ , '<value>', ... ] )
  [ COMMENT = '<string_literal>' ]

ALTER NETWORK RULE [ IF EXISTS ] <name> UNSET { VALUE_LIST | COMMENT }

-- Example 26825
ALTER NETWORK RULE cloud_network SET VALUE_LIST = ('47.88.25.32/27');

-- Example 26826
ALTER NETWORK RULE corporate_network SET VALUE_LIST = ('vpce-123abc3420c1931');

-- Example 26827
ALTER NETWORK RULE external_access_rule SET VALUE_LIST = ('example.com', 'example.com:443');

-- Example 26828
USE ROLE GLOBALORGADMIN;

GRANT APPLICATION ROLE ORG_USAGE_ADMIN TO ROLE custom_role;

GRANT ROLE custom_role TO USER joe;

-- Example 26829
IS_GRANTED_TO_INVOKER_ROLE( '<string_literal>' )

-- Example 26830
IS_GRANTED_TO_INVOKER_ROLE('ANALYST')

--------------------------------------+
IS_GRANTED_TO_INVOKER_ROLE('ANALYST') |
--------------------------------------+
                TRUE                  |
--------------------------------------+

-- Example 26831
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN IS_GRANTED_TO_INVOKER_ROLE('ANALYST') then val
  ELSE '*******'
END;

-- Example 26832
CREATE [ OR REPLACE ] MASKING POLICY [ IF NOT EXISTS ] <name> AS
( <arg_name_to_mask> <arg_type_to_mask> [ , <arg_1> <arg_type_1> ... ] )
RETURNS <arg_type_to_mask> -> <body>
[ COMMENT = '<string_literal>' ]
[ EXEMPT_OTHER_POLICIES = { TRUE | FALSE } ]

-- Example 26833
CREATE OR REPLACE MASKING POLICY email_mask AS (val string) returns string ->
  CASE
    WHEN current_role() IN ('ANALYST') THEN VAL
    ELSE '*********'
  END;

-- Example 26834
case
  when current_account() in ('<prod_account_identifier>') then val
  else '*********'
end;

-- Example 26835
case
  when current_role() IN ('ANALYST') then val
  else NULL
end;

-- Example 26836
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 26837
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE sha2(val) -- return hash of the column value
END;

-- Example 26838
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  WHEN current_role() IN ('SUPPORT') THEN regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  ELSE '********'
END;

-- Example 26839
case
  WHEN current_role() in ('SUPPORT') THEN val
  else date_from_parts(0001, 01, 01)::timestamp_ntz -- returns 0001-01-01 00:00:00.000
end;

-- Example 26840
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE mask_udf(val) -- custom masking function
END;

-- Example 26841
CASE
   WHEN current_role() IN ('ANALYST') THEN val
   ELSE OBJECT_INSERT(val, 'USER_IPADDRESS', '****', true)
END;

