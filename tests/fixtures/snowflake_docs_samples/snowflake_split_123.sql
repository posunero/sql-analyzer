-- Example 8222
select start_time::date as usage_date,
       warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1,2
order by 2,1;

-- Example 8223
select date_trunc(month, usage_date) as usage_month
  , avg(storage_bytes + stage_bytes + failsafe_bytes) / power(1024, 4) as billable_tb
from storage_usage
group by 1
order by 1;

-- Example 8224
select count(*) as number_of_jobs
from query_history
where start_time >= date_trunc(month, current_date);

-- Example 8225
select warehouse_name,
       count(*) as number_of_jobs
from query_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

-- Example 8226
select user_name,
       avg(execution_time) as average_execution_time
from query_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

-- Example 8227
select query_type,
       warehouse_size,
       avg(execution_time) as average_execution_time
from query_history
where start_time >= date_trunc(month, current_date)
group by 1,2
order by 3 desc;

-- Example 8228
select l.user_name,
       l.event_timestamp as login_time,
       l.client_ip,
       l.reported_client_type,
       l.first_authentication_factor,
       l.second_authentication_factor,
       count(q.query_id)
from snowflake.account_usage.login_history l
join snowflake.account_usage.sessions s on l.event_id = s.login_event_id
join snowflake.account_usage.query_history q on q.session_id = s.session_id
group by 1,2,3,4,5,6
order by l.user_name
;

-- Example 8229
SHOW REPLICATION ACCOUNTS;

+------------------+---------------------------------+---------------+------------------+---------+-------------------+
| snowflake_region | created_on                      | account_name  | account_locator  | comment | organization_name |
|------------------+---------------------------------+---------------+------------------+---------+-------------------|
| AWS_US_WEST_2    | 2018-11-19 16:11:12.720 -0700   | ACCOUNT1      | MYACCOUNT1       |         | MYORG             |
| AWS_US_EAST_1    | 2019-06-02 14:12:23.192 -0700   | ACCOUNT2      | MYACCOUNT2       |         | MYORG             |
+------------------+---------------------------------+---------------+------------------+---------+-------------------+

-- Example 8230
ALTER DATABASE mydb1 ENABLE REPLICATION TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 8231
-- Executed from primary account
ALTER DATABASE mydb1 ENABLE FAILOVER TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 8232
-- Log into the ACCOUNT2 account.

-- Query the set of primary and secondary databases in your organization.
-- In this example, the MYORG.ACCOUNT1 primary database is available to replicate.
SHOW REPLICATION DATABASES;

+------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------+
| snowflake_region | created_on                    | account_name    | name     | comment | is_primary | primary                    | replication_allowed_to_accounts | failover_allowed_to_accounts | organization_name | account_locator |
|------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------|
| AWS_US_WEST_2    | 2019-11-15 00:51:45.473 -0700 | ACCOUNT1        | MYDB1    | NULL    | true       | MYORG.ACCOUNT1.MYDB1       | MYORG.ACCOUNT2, MYORG,ACCOUNT1  | MYORG.ACCOUNT1               | MYORG             | MYACCOUNT1      |
+------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------+

-- Create a replica of the 'mydb1' primary database
-- If the primary database has the DATA_RETENTION_TIME_IN_DAYS parameter set to a value other than the default value,
-- set the same value for the parameter on the secondary database.
CREATE DATABASE mydb1
  AS REPLICA OF myorg.account1.mydb1
  DATA_RETENTION_TIME_IN_DAYS = 10;

-- Verify the secondary database
SHOW REPLICATION DATABASES;

+------------------+-------------------------------+---------------+----------+---------+------------+-------------------------+---------------------------------+------------------------------+-------------------+-----------------+
| snowflake_region | created_on                    | account_name  | name     | comment | is_primary | primary                 | replication_allowed_to_accounts | failover_allowed_to_accounts | organization_name | account_locator |
|------------------+-------------------------------+---------------+----------+---------+------------+------------------------------------------+----------------+------------------------------+-------------------------------------|
| AWS_US_WEST_2    | 2019-11-15 00:51:45.473 -0700 | ACCOUNT1      | MYDB1    | NULL    | true       | MYORG.ACCOUNT1.MYDB1    | MYORG.ACCOUNT2, MYORG.ACCOUNT1  | MYORG.ACCOUNT1               | MYORG             | MYACCOUNT1      |
| AWS_US_EAST_1    | 2019-08-15 15:51:49.094 -0700 | ACCOUNT2      | MYDB1    | NULL    | false      | MYORG.ACCOUNT1.MYDB1    |                                 |                              | MYORG             | MYACCOUNT2      |
+------------------+-------------------------------+---------------+----------+---------+------------+-------------------------+---------------------------------+------------------------------+-------------------+-----------------+

-- Example 8233
ALTER DATABASE mydb1 REFRESH;

-- Example 8234
CREATE TASK refresh_mydb1_task
  WAREHOUSE = mywh
  SCHEDULE = '10 minute'
  USER_TASK_TIMEOUT_MS = 14400000
AS
  ALTER DATABASE mydb1 REFRESH;

-- Example 8235
ALTER TASK refresh_mydb1_task RESUME;

-- Example 8236
-- The commands below are executed from the source account

-- View replication enabled accounts
SHOW REPLICATION ACCOUNTS;

ALTER DATABASE mydb ENABLE REPLICATION TO ACCOUNTS myorg.account2, myorg.account3;
ALTER DATABASE mydb ENABLE FAILOVER TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 8237
-- The commands below are executed from each target account

-- View replication enabled databases
-- Note the primary column of the source database for the CREATE DATABASE statement below
SHOW REPLICATION DATABASES;

-- If the primary database has the DATA_RETENTION_TIME_IN_DAYS parameter set to a value other than the default value,
-- set the same value for the parameter on the secondary database.
CREATE DATABASE mydb
  AS REPLICA OF myorg.account1.mydb
  DATA_RETENTION_TIME_IN_DAYS = 10;

-- Increase statement timeout for initial refresh
-- Optional but recommended for initial refresh of a large database
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;
-- If you have an active warehouse in current session, update warehouse statement timeout
SELECT CURRENT_WAREHOUSE();
ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;
-- Reset warehouse statement timeout after initial refresh
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Refresh a secondary database
ALTER DATABASE mydb REFRESH;

-- Create task
-- Set up refresh schedule for each secondary database using a separate database
USE DATABASE my_db2;

-- Create a task and RESUME the task for each secondary database
-- Edit the task schedule and timeout for your specific use case
CREATE TASK my_refresh_task
  WAREHOUSE = my_wh
  SCHEDULE = '10 minute'
  USER_TASK_TIMEOUT_MS = 14400000
AS
  ALTER DATABASE mydb REFRESH;

-- Start task
ALTER TASK my_refresh_task RESUME;

-- Example 8238
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 8239
-- determine the active warehouse in the current session (if any)
SELECT CURRENT_WAREHOUSE();

+---------------------+
| CURRENT_WAREHOUSE() |
|---------------------|
| MY_WH               |
+---------------------+

-- change the STATEMENT_TIMEOUT_IN_SECONDS value for the active warehouse

ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 8240
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Example 8241
select *
  from table(information_schema.database_refresh_progress(mydb1));

-- Example 8242
select *
  from table(information_schema.database_refresh_history(mydb1));

-- Example 8243
SELECT TO_DATE(start_time) AS date,
  database_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.database_replication_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 8244
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.database_replication_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 8245
select parse_json(details)['snapshot_transaction_timestamp']
from table(information_schema.database_refresh_progress(mydb))
where phase_name = 'PRIMARY_UPLOADING_DATA';

-- Example 8246
SELECT HASH_AGG( * ) FROM mytable;

-- Example 8247
SELECT HASH_AGG( * ) FROM mytable AT(TIMESTAMP => '<snapshot_transaction_timestamp>'::TIMESTAMP);

-- Example 8248
CALL SYSTEM$SEND_EMAIL(
    'my_email_int',
    'first.last@example.com, first2.last2@example.com',
    'Email Alert: Task A has finished.',
    'Task A has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
);

-- Example 8249
use role accountadmin;
use database demo_db;
use schema information_schema;
select *
    from table(rest_event_history(
        'scim',
        dateadd('minutes',-5,current_timestamp()),
        current_timestamp(),
        200))
    order by event_timestamp;

-- Example 8250
GRANT USAGE ON DATABASE securitydb TO ROLE network_admin;
GRANT USAGE ON SCHEMA securitydb.myrules TO ROLE network_admin;
GRANT CREATE NETWORK RULE ON SCHEMA securitydb.myrules TO ROLE network_admin;
USE ROLE network_admin;

CREATE NETWORK RULE cloud_network TYPE = IPV4 MODE = INGRESS VALUE_LIST = ('47.88.25.32/27');

-- Example 8251
CREATE TABLE table2 AS SELECT col1 FROM table1;

-- Example 8252
UPDATE mydb.schema1.table1 FROM mydb.schema2.table2 SET table1.col1 = table2.col1;

-- Example 8253
ASSOCIATE_SEMANTIC_CATEGORY_TAGS( '<object_name>' , <category_extraction_result> )

-- Example 8254
USE ROLE data_engineer;

CALL ASSOCIATE_SEMANTIC_CATEGORY_TAGS('mydb.my_schema.hr_data',
                                      EXTRACT_SEMANTIC_CATEGORIES('mydb.my_schema.hr_data'));

-- Example 8255
USE ROLE data_engineer;

CALL ASSOCIATE_SEMANTIC_CATEGORY_TAGS('mydb.my_schema.hr_data',
                                      (SELECT * FROM classification_results));

-- Example 8256
USE ROLE data_engineer;

UPDATE classification_results SET V =
    OBJECT_INSERT(V,'LNAME',OBJECT_INSERT(
        OBJECT_INSERT(V:LNAME,'semantic_category','NAME',TRUE),
        'privacy_category','IDENTIFIER',TRUE),
        TRUE
        );

CALL ASSOCIATE_SEMANTIC_CATEGORY_TAGS('mydb.my_schema.hr_data',
                                      (SELECT * FROM classification_results));

-- Example 8257
SYSTEM$CLASSIFY( '<object_name>' ,
  { '<classification_profile>' | <options> } )

-- Example 8258
{
  "classification_profile_config": {
    "classification_profile_name": "db1.sch.sensitive_data_detection_profile"
  },
  "classification_result": {
    "col1_name": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "QUASI_IDENTIFIER",
        "semantic_category": "DATE_OF_BIRTH",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "DATE_OF_BIRTH"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "QUASI_IDENTIFIER"
          }
        ]
      },
      "valid_value_ratio": 1
    }
  }
}

-- Example 8259
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', null);

-- Example 8260
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', {'sample_count': 1000});

-- Example 8261
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', {'auto_tag': true});

-- Example 8262
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', {'sample_count': 1000, 'auto_tag': true});

-- Example 8263
CALL SYSTEM$CLASSIFY('hr.tables.empl_info, 'my_config_profile');

-- Example 8264
SYSTEM$CLASSIFY_SCHEMA( '<schema_name>' , <object> )

-- Example 8265
{
  "failed": [
    {
      "message": "Insufficient privileges.",
      "table_name": "t4"
    }
  ],
  "succeeded": [
    {
      "table_name": "t1"
    },
    {
      "table_name": "t2"
    },
    {
      "table_name": "t3"
    }
  ]
}

-- Example 8266
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', null);

-- Example 8267
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'sample_count': 1000});

-- Example 8268
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'auto_tag': true});

-- Example 8269
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'sample_count': 1000, 'auto_tag': true});

-- Example 8270
SYSTEM$CANCEL_CLASSIFY_SCHEMA( '<object_name>' )

-- Example 8271
{
  "failed": [],
  "succeeded": [
    {
      "message": "Classification Cancelled for table [T1].",
      "table_name": "T1"
    },
    {
      "message": "Classification Cancelled for table [T2].",
      "table_name": "T2"
    },
    ...
    }
  ]
}

-- Example 8272
{
  "failed": [
    {
      "message": "Unable to cancel classification for table [T1] since its already complete.",
      "table_name": "T1"
    },
    {
      "message": "Unable to cancel classification for table [T2] since its already complete.",
      "table_name": "T2"
    },
    ...
  ],
  "succeeded": []
}

-- Example 8273
CALL SYSTEM$CANCEL_CLASSIFY_SCHEMA('hr.tables');

-- Example 8274
SNOWFLAKE.DATA_PRIVACY.RESET_PRIVACY_BUDGET(
  '<privacy_policy_name>',
  '<budget_name>',
  '<organization_name>',
  '<account_name>')

-- Example 8275
CALL SNOWFLAKE.DATA_PRIVACY.RESET_PRIVACY_BUDGET(
  'my_policy_db.my_policy_schema.my_policy',
  'analyst_budget',
  'companyorg',
  'account_123');

-- Example 8276
SYSTEM$SEND_EMAIL(
  '<integration_name>',
  '<email_address_1> [ , ... <email_address_N> ]',
  '<email_subject>',
  '<email_content>',
  [ '<mime_type>' ] )

-- Example 8277
SYSTEM$REQUEST_LISTING_AND_WAIT( '<listing_global_name>' [ , <timeout_mins> ] )

-- Example 8278
CALL SYSTEM$REQUEST_LISTING_AND_WAIT('GZ13Z1VEWIJ', 60);

-- Example 8279
SNOWFLAKE.TELEMETRY.ADD_ROW_ACCESS_POLICY_ON_EVENTS_VIEW(
  <row_access_policy_reference>,
  <apply_on_columns>
)

-- Example 8280
CALL SNOWFLAKE.TELEMETRY.ADD_ROW_ACCESS_POLICY_ON_EVENTS_VIEW(
  SYSTEM$REFERENCE('ROW_ACCESS_POLICY', 'mydb.myschema.mypolicy', 'SESSION', 'APPLY'),
  ARRAY_CONSTRUCT('record_type', 'resource_attributes')
);

-- Example 8281
SNOWFLAKE.TELEMETRY.DROP_ROW_ACCESS_POLICY_ON_EVENTS_VIEW(
  <row_access_policy_reference>
)

-- Example 8282
CALL SNOWFLAKE.TELEMETRY.DROP_ROW_ACCESS_POLICY_ON_EVENTS_VIEW(
  SYSTEM$REFERENCE('ROW_ACCESS_POLICY', 'mydb.myschema.mypolicy', 'SESSION', 'APPLY')
);

-- Example 8283
SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA(<configuration_object>)

-- Example 8284
{
  'datasets': [
    {
      'input_table': '<input_table_name>',
      'output_table' : '<output_table_name>',
      'columns': {
        '<column_name>': {
          <property_name>: <property_value>
        }
        , ...
      }
    }
    , ...
  ],
  'similarity_filter': <boolean>,
  'replace_output_tables': <boolean>,
  'consistency_secret': <session-scoped reference string>
}

-- Example 8285
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
    'datasets':[
        {
          'input_table': 'syndata_db.sch.faker_source_t',
          'output_table': 'syndata_db.sch.faker_synthetic_t',
          'columns': { 'blood_type': {'join_key': TRUE} , 'ethnicity': {'join_key': TRUE}}
        }
      ]
  });

-- Example 8286
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'syndata_db.sch.faker_source_t',
        'output_table': 'syndata_db.sch.faker_synthetic_t'
      }
    ]
});

-- Example 8287
CREATE OR REPLACE SECRET my_db.public.my_consistency_secret
  TYPE = SYMMETRIC_KEY
  ALGORITHM = GENERIC;

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
  'datasets':[
      {
        'input_table': 'CLINICAL_DB.PUBLIC.BASE_TABLE',
        'output_table': 'my_db.public.test_syndata',
        'columns': { 'patient_id': {'join_key': TRUE, 'replace': 'uuid'}}
      }
    ],
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_CONSISTENCY_SECRET', 'SESSION', 'READ')::STRING,
    'replace_output_tables': TRUE
});

-- Example 8288
+---------------------------+-------------------+--------------+----------------+------------------------+-------------------+---------------------+-----------------------+------------------------+------------------------------------+----------------+
| CREATED_ON                | TABLE_NAME        | TABLE_SCHEMA | TABLE_DATABASE | COLUMNS                | SOURCE_TABLE_NAME | SOURCE_TABLE_SCHEMA | SOURCE_TABLE_DATABASE | SOURCE_COLUMNS         | METRIC_TYPE                        | METRIC_VALUE   |
+---------------------------+-------------------+--------------+----------------+------------------------+-------------------+---------------------+-----------------------+------------------------+------------------------------------+----------------+
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "BLOOD_TYPE,GENDER"    | faker_source_t    | sch                 | syndata_db            | "BLOOD_TYPE,GENDER"    | CORRELATION_COEFFICIENT_DIFFERENCE | 0.02430214616  |
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "BLOOD_TYPE,AGE"       | faker_source_t    | sch                 | syndata_db            | "BLOOD_TYPE,AGE"       | CORRELATION_COEFFICIENT_DIFFERENCE | 0.001919343586 |
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "BLOOD_TYPE,ETHNICITY" | faker_source_t    | sch                 | syndata_db            | "BLOOD_TYPE,ETHNICITY" | CORRELATION_COEFFICIENT_DIFFERENCE | 0.003720197046 |
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "GENDER,AGE"           | faker_source_t    | sch                 | syndata_db            | "GENDER,AGE"           | CORRELATION_COEFFICIENT_DIFFERENCE | 0.004348586645 |
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "GENDER,ETHNICITY"     | faker_source_t    | sch                 | syndata_db            | "GENDER,ETHNICITY"     | CORRELATION_COEFFICIENT_DIFFERENCE | 0.001171535243 |
| 2024-07-30 09:53:28.439 Z | faker_synthetic_t | sch          | syndata_db     | "AGE,ETHNICITY"        | faker_source_t    | sch                 | syndata_db            | "AGE,ETHNICITY"        | CORRELATION_COEFFICIENT_DIFFERENCE | 0.004265938158 |
+---------------------------+-------------------+--------------+----------------+------------------------+-------------------+---------------------+-----------------------+------------------------+------------------------------------+----------------+

