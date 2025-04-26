-- Example 10767
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 10768
ALTER CONNECTION global PRIMARY;

-- Example 10769
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 10770
ALTER FAILOVER GROUP fg REFRESH;

-- Example 10771
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 10772
ALTER CONNECTION global PRIMARY;

-- Example 10773
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 10774
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, account parameters, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 10775
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, users, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 10776
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, integrations, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_INTEGRATION_TYPES = security integrations
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 10777
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations, network policies, account parameters
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 10778
ALTER FAILOVER GROUP fg REFRESH;

-- Example 10779
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 10780
ALTER CONNECTION global PRIMARY;

-- Example 10781
show secrets in database secretsdb;
show security integrations;
show api integrations;
show tables in database destdb;
show warehouses;
show roles;

-- Example 10782
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = databases, users, roles, warehouses, resource monitors, integrations, network policies, account parameters
  ALLOWED_DATABASES = secretsdb, destdb
  ALLOWED_INTEGRATION_TYPES = security integrations, api integrations;

-- Example 10783
ALTER FAILOVER GROUP fg REFRESH;

-- Example 10784
show secrets;
show security integrations;
show api integrations;
show database;
show tables in database destdb;
show roles;

-- Example 10785
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 10786
ALTER CONNECTION global PRIMARY;

-- Example 10787
ALTER FAILOVER GROUP my_failover_group SET
  OBJECT_TYPES = ROLES, INTEGRATIONS
  ALLOWED_INTEGRATION_TYPES = API INTEGRATIONS, STORAGE INTEGRATIONS;

-- Example 10788
CREATE OR REPLACE STAGE my_stage
  DIRECTORY = (ENABLE = TRUE);

COPY INTO @my_stage/folder1/file1 from my_table;
COPY INTO @my_stage/folder2/file2 from my_table;
ALTER STAGE my_stage REFRESH;

COPY INTO @my_stage/folder3/file3 from my_table;

-- Example 10789
CREATE FAILOVER GROUP my_stage_failover_group
  OBJECT_TYPES = DATABASES
  ALLOWED_DATABASES = my_database_1
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 10790
CREATE FAILOVER GROUP my_stage_failover_group
  AS REPLICA OF myorg.my_account_1.my_stage_failover_group;

ALTER FAILOVER GROUP my_stage_failover_group REFRESH;

ALTER FAILOVER GROUP my_stage_failover_group PRIMARY;

-- Example 10791
ALTER STAGE my_stage REFRESH;

COPY INTO my_table FROM @my_stage;

-- Example 10792
CREATE STORAGE INTEGRATION my_storage_int
  TYPE = external_stage
  STORAGE_PROVIDER = 's3'
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket/path')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket/blockedpath')
  ENABLED = true;

-- Example 10793
CREATE STAGE my_ext_stage
  URL = 's3://mybucket/path'
  STORAGE_INTEGRATION = my_storage_int

-- Example 10794
CREATE FAILOVER GROUP my_external_stage_fg
  OBJECT_TYPES = databases, integrations
  ALLOWED_INTEGRATION_TYPES = storage integrations
  ALLOWED_DATABASES = my_database_2
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 10795
CREATE FAILOVER GROUP my_external_stage_fg
  AS REPLICA OF myorg.my_account_1.my_external_stage_fg;

ALTER FAILOVER GROUP my_external_stage_fg REFRESH;

-- Example 10796
CREATE PIPE snowpipe_db.public.mypipe AUTO_INGEST=TRUE
 AWS_SNS_TOPIC='<topic_arn>'
 AS
   COPY INTO snowpipe_db.public.mytable
   FROM @snowpipe_db.public.my_s3_stage
   FILE_FORMAT = (TYPE = 'JSON');

-- Example 10797
ALTER PIPE mypipe REFRESH;

-- Example 10798
CREATE FAILOVER GROUP my_pipe_failover_group
  OBJECT_TYPES = DATABASES, INTEGRATIONS
  ALLOWED_INTEGRATION_TYPES = STORAGE INTEGRATIONS
  ALLOWED_DATABASES = snowpipe_db
  ALLOWED_ACCOUNTS = myorg.my_account_2;

-- Example 10799
CREATE FAILOVER GROUP my_pipe_failover_group
  AS REPLICA OF myorg.my_account_1.my_pipe_failover_group;

-- Example 10800
DESC INTEGRATION my_s3_storage_int;

-- Example 10801
SELECT SYSTEM$GET_AWS_SNS_IAM_POLICY('<topic_arn>');

-- Example 10802
ALTER FAILOVER GROUP my_pipe_failover_group REFRESH;

-- Example 10803
ALTER FAILOVER GROUP my_pipe_failover_group PRIMARY;

-- Example 10804
SELECT * FROM mytable;

-- Example 10805
SELECT SYSTEM$CONVERT_PIPES_SQS_TO_SNS('s3_mybucket', 'arn:aws:sns:us-west-2:001234567890:MySNSTopic')

-- Example 10806
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('myfg'));

-- Example 10807
SELECT PHASE_NAME, START_TIME, END_TIME, TOTAL_BYTES, OBJECT_COUNT
  FROM TABLE(information_schema.replication_group_refresh_history('myfg'))
  WHERE START_TIME >= CURRENT_DATE() - INTERVAL '7 days';

-- Example 10808
SELECT REPLICATION_GROUP_NAME, PHASE_NAME, START_TIME, END_TIME, TOTAL_BYTES, OBJECT_COUNT
  FROM snowflake.account_usage.replication_group_refresh_history
  WHERE START_TIME >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 10809
SELECT start_time, end_time, replication_group_name, credits_used, bytes_transferred
  FROM TABLE(information_schema.replication_group_usage_history(date_range_start=>DATEADD('day', -7, CURRENT_DATE())));

-- Example 10810
SELECT start_time, 
  end_time, 
  replication_group_name, 
  credits_used, 
  bytes_transferred
FROM snowflake.account_usage.replication_group_usage_history
WHERE start_time >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 10811
SELECT SUM(value:totalBytesToReplicate) as sum_database_bytes
  FROM snowflake.account_usage.replication_group_refresh_history rh,
    LATERAL FLATTEN(input => rh.total_bytes:databases)
  WHERE rh.replication_group_name = 'MYRG' AND
        rh.start_time >= CURRENT_DATE() - INTERVAL '30 days';

-- Example 10812
+--------------------+
| SUM_DATABASE_BYTES |
|--------------------|
|              22016 |
+--------------------+

-- Example 10813
SELECT SUM(credits_used) AS credits_used, SUM(bytes_transferred) AS bytes_transferred
  FROM snowflake.account_usage.replication_group_usage_history
  WHERE replication_group_name = 'MYRG' AND
        start_time >= CURRENT_DATE() - INTERVAL '30 days';

-- Example 10814
+--------------+-------------------+
| CREDITS_USED | BYTES_TRANSFERRED |
|--------------+-------------------|
|  1.357923604 |             22013 |
+--------------+-------------------+

-- Example 10815
SELECT SUM(value:totalBytesToReplicate)
  FROM TABLE(information_schema.replication_group_refresh_history('myrg')) AS rh,
  LATERAL FLATTEN(input => total_bytes:databases)
  WHERE rh.phase_name = 'COMPLETED' AND
        rh.start_time >= CURRENT_DATE() - INTERVAL '14 days';

-- Example 10816
SELECT SUM(credits_used), SUM(bytes_transferred)
  FROM TABLE(information_schema.replication_group_usage_history(
    date_range_start => DATEADD('day', -14, CURRENT_DATE()),
    replication_group_name => 'myrg'));

-- Example 10817
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = EMAIL
  ENABLED = TRUE
  DEFAULT_RECIPIENTS = ('first.last@example.com');

-- Example 10818
WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'

-- Example 10819
WEBHOOK_BODY_TEMPLATE='{
  "routing_key": "SNOWFLAKE_WEBHOOK_SECRET",
  "event_action": "trigger",
  "payload": {
    "summary": "Snowflake replication failure",
    "source": "Snowflake monitoring",
    "severity": "INFO",
    "custom_details": {
      "message": "SNOWFLAKE_WEBHOOK_MESSAGE"
    }
  }
}'

-- Example 10820
ALTER FAILOVER GROUP my_fg SET
  ERROR_INTEGRATION = my_notification_int;

-- Example 10821
CREATE FAILOVER GROUP my_fg
  OBJECT_TYPES = DATABASES
  ALLOWED_DATABASES = db1, db2
  ALLOWED_ACCOUNTS = myorg.myaccount2, myorg.myaccount3
  REPLICATION_SCHEDULE = '10 MINUTE'
  ERROR_INTEGRATION = my_notification_int;

-- Example 10822
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = databases, shares
  ALLOWED_DATABASES = db1
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme.account_2;

-- Example 10823
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme.account1.my_rg;

-- Example 10824
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 10825
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 10826
USE ROLE ACCOUNTADMIN;

CREATE DATABASE db1;

CREATE SCHEMA db1.sch;

CREATE TABLE db1.sch.table_b AS
  SELECT customerid, user_order_count, total_spent
  FROM source_db.sch.table_a
  WHERE REGION='azure_eastus2';

-- Example 10827
CREATE SECURE VIEW db1.sch.view1 AS
  SELECT customerid, user_order_count, total_spent
  FROM db1.sch.table_b;

-- Example 10828
CREATE STREAM mystream ON TABLE source_db.sch.table_a APPEND_ONLY = TRUE;

-- Example 10829
CREATE TASK mytask1
  WAREHOUSE = mywh
  SCHEDULE = '5 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('mystream')
AS
  INSERT INTO table_b(CUSTOMERID, USER_ORDER_COUNT, TOTAL_SPENT)
    SELECT customerid, user_order_count, total_spent
    FROM mystream
    WHERE region='azure_eastus2'
    AND METADATA$ACTION = 'INSERT';

-- Example 10830
ALTER TASK mytask1 RESUME;

-- Example 10831
CREATE SHARE share1;

GRANT USAGE ON DATABASE db1 TO SHARE share1;
GRANT USAGE ON SCHEMA db1.sch TO SHARE share1;
GRANT SELECT ON VIEW db1.sch.view1 TO SHARE share1;

-- Example 10832
CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = DATABASES, SHARES
  ALLOWED_DATABASES = db1
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme_org.account_2;

-- Example 10833
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme_org.account_1.my_rg;

