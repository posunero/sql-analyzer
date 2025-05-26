-- More Extracted Snowflake SQL Examples (Set 4)

-- From snowflake_split_400.sql

CREATE OR REPLACE TABLE test_larger_sizes(col1 VARCHAR, col2 VARCHAR) AS
  SELECT 'foo', 'bar';

SELECT SYSTEM$TYPEOF(CONCAT(col1, col2)) FROM test_larger_sizes;

CREATE OR REPLACE FUNCTION test_larger_sized_func(in_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  CALLED ON NULL INPUT AS
$$
  RETURN NULL;
$$;

SELECT data_type FROM INFORMATION_SCHEMA.FUNCTIONS
  WHERE function_name = 'TEST_LARGER_SIZED_FUNC';

CREATE OR REPLACE TABLE test_larger_size_error(col VARCHAR);
INSERT INTO test_larger_size_error SELECT RANDSTR(20000000, 1);

ALTER ICEBERG TABLE my_iceberg_table
  ALTER COLUMN col1 SET DATA TYPE VARCHAR(134217728);

CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

DESC STORAGE INTEGRATION gcs_int;

CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

DESC NOTIFICATION INTEGRATION my_notification_int;

USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int;

CREATE OR REPLACE EXTERNAL TABLE ext_table
 INTEGRATION = 'MY_NOTIFICATION_INT'
 WITH LOCATION = @mystage/path1/
 FILE_FORMAT = (TYPE = JSON);

ALTER EXTERNAL TABLE ext_table REFRESH;

CREATE OR REPLACE TABLE members (
  id number(8) NOT NULL,
  name varchar(255) default NULL,
  fee number(3) NULL
);

CREATE OR REPLACE STREAM member_check ON TABLE members;

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

SELECT * FROM member_check;

MERGE INTO members m
  USING (
    SELECT id, dt
    FROM signup s
    WHERE DATEDIFF(day, '2018-08-15'::date, s.dt::DATE) < -30) s
    ON m.id = s.id
  WHEN MATCHED THEN UPDATE SET m.fee = 90;

SELECT * FROM members; 