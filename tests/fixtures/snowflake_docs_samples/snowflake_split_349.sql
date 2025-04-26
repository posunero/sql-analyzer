-- Example 23360
SELECT account_name, phase_name, start_time, end_time,
       total_bytes, object_count, error
  FROM SNOWFLAKE.ORGANIZATION_USAGE.REPLICATION_GROUP_REFRESH_HISTORY
  WHERE replication_group_name = 'MYFG';

-- Example 23361
SELECT account_name, replication_group_name, phase_name,
       start_time, end_time,
       total_bytes, object_count, error,
       ROW_NUMBER() OVER (
         PARTITION BY replication_group_name
         ORDER BY end_time DESC
       ) AS row_num
  FROM SNOWFLAKE.ORGANIZATION_USAGE.REPLICATION_GROUP_REFRESH_HISTORY
  QUALIFY row_num = 1;

-- Example 23362
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_admin;

GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_ADMIN TO ROLE account_budget_admin;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_admin;

-- Example 23363
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ACTIVATE();

-- Example 23364
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_SPENDING_LIMIT(1000);

-- Example 23365
USE ROLE ACCOUNTADMIN;
   
CREATE ROLE budget_owner;
  
GRANT USAGE ON DATABASE budgets_db TO ROLE budget_owner;
GRANT USAGE ON SCHEMA budgets_db.budgets_schema TO ROLE budget_owner;

GRANT DATABASE ROLE SNOWFLAKE.BUDGET_CREATOR TO ROLE budget_owner;

GRANT CREATE SNOWFLAKE.CORE.BUDGET ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_owner;

-- Example 23366
SELECT SYSTEM$SHOW_BUDGETS_IN_ACCOUNT();

-- Example 23367
USE SCHEMA budgets_db.budgets_schema;

CREATE SNOWFLAKE.CORE.BUDGET my_budget();

-- Example 23368
CALL my_budget!SET_SPENDING_LIMIT(500);

-- Example 23369
GRANT USAGE ON DATABASE budgets_db TO ROLE budget_admin;

GRANT USAGE ON SCHEMA budget_db.budgets_schema TO ROLE budget_admin;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.my_budget!ADMIN
  TO ROLE budget_admin;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_admin;

-- Example 23370
GRANT USAGE ON DATABASE db1 TO ROLE budget_admin;

GRANT APPLYBUDGET ON DATABASE db1 TO ROLE budget_admin;

-- Example 23371
CREATE NOTIFICATION INTEGRATION budgets_notification_integration
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('costadmin@example.com','budgetadmin@example.com');

-- Example 23372
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{"name": "value"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 23373
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 23374
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_EMAIL_NOTIFICATIONS(
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 23375
CALL my_budget!SET_EMAIL_NOTIFICATIONS(
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 23376
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_EMAIL_NOTIFICATIONS(
  'budgets_notification_integration',
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 23377
CALL my_budget!SET_EMAIL_NOTIFICATIONS(
  'budgets_notification_integration',
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 23378
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 23379
CALL my_budget!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 23380
CREATE OR REPLACE NOTIFICATION INTEGRATION budgets_notification_integration
  ENABLED = TRUE
  TYPE = QUEUE
  DIRECTION = OUTBOUND
  NOTIFICATION_PROVIDER = AWS_SNS
  AWS_SNS_TOPIC_ARN = '<ARN_for_my_SNS_topic>'
  AWS_SNS_ROLE_ARN = '<ARN_for_my_IAM_role>';

-- Example 23381
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{"name": "value"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 23382
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 23383
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 23384
CALL my_budget!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 23385
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATIONS();

-- Example 23386
CALL my_budget!GET_NOTIFICATION_INTEGRATIONS();

-- Example 23387
+----------------------------------+------------------------+------------+
|  INTEGRATION_NAME                | LAST_NOTIFICATION_TIME | ADDED_DATE |
+----------------------------------+------------------------+------------+
| budgets_notification_integration | -1                     | 2024-09-23 |
+----------------------------------+------------------------+------------+

-- Example 23388
CREATE OR REPLACE SECRET my_database.my_schema.slack_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = '... secret in my Slack webhook URL ...';

CREATE OR REPLACE NOTIFICATION INTEGRATION budgets_notification_integration
  ENABLED = TRUE
  TYPE = WEBHOOK
  WEBHOOK_URL = 'https://hooks.slack.com/services/SNOWFLAKE_WEBHOOK_SECRET'
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  WEBHOOK_HEADERS=('Content-Type'='application/json')
  WEBHOOK_SECRET = slack_secret;

-- Example 23389
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{\\\"name\\\": \\\"value\\\"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 23390
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 23391
GRANT READ ON SECRET slack_secret TO APPLICATION snowflake;
GRANT USAGE ON SCHEMA my_schema TO APPLICATION snowflake;
GRANT USAGE ON DATABASE my_database TO APPLICATION snowflake;

-- Example 23392
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 23393
CALL my_budget!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 23394
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATIONS();

-- Example 23395
CALL my_budget!GET_NOTIFICATION_INTEGRATIONS();

-- Example 23396
+----------------------------------+------------------------+------------+
|  INTEGRATION_NAME                | LAST_NOTIFICATION_TIME | ADDED_DATE |
+----------------------------------+------------------------+------------+
| budgets_notification_integration | -1                     | 2024-09-23 |
+----------------------------------+------------------------+------------+

-- Example 23397
{
  "account_name": "MY_ACCOUNT",
  "budget_name": "MY_BUDGET_NAME",
  "type": "BUDGET_LIMIT_WARNING",
  "limit": "100",
  "spending": "67.42",
  "spending_percent": "67.42",
  "spending_trend_percent": "130.63",
  "time_percent":"51.61"
}

-- Example 23398
SELECT * FROM TABLE(
  INFORMATION_SCHEMA.NOTIFICATION_HISTORY(
    INTEGRATION_NAME=>'budgets_notification_integration'
  )
);

-- Example 23399
CALL my_budget!REMOVE_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 23400
CALL budgets_db.budgets_schema.my_budget!GET_LINKED_RESOURCES();

-- Example 23401
+-------------+-----------------+-----------+-------------+---------------+
| RESOURCE_ID | NAME            | DOMAIN    | SCHEMA_NAME | DATABASE_NAME |
|-------------+-----------------+-----------+-------------+---------------|
|         326 | DB1             | DATABASE  | NULL        | NULL          |
|         157 | MY_WH           | WAREHOUSE | NULL        | NULL          |
+-------------+-----------------+-----------+-------------+---------------+

-- Example 23402
GRANT APPLYBUDGET ON TABLE t1 TO ROLE budget_admin;

-- Example 23403
CALL budgets_db.budgets_schema.my_budget!ADD_RESOURCE(
   SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'applybudget'));

-- Example 23404
GRANT APPLYBUDGET ON DATABASE db1 TO ROLE budget_admin;

-- Example 23405
CALL budgets_db.budgets_schema.my_budget!REMOVE_RESOURCE(
   SYSTEM$REFERENCE('DATABASE', 'db1', 'SESSION', 'applybudget'));

-- Example 23406
SELECT SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'my_db.my_schema.my_table');

-- Example 23407
+-----------------------------------------------------------------------+
| SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'MY_DB.MY_SCHEMA.MY_TABLE') |
|-----------------------------------------------------------------------|
| [BUDGETS_DB.BUDGETS_SCHEMA.MY_BUDGET]                                 |
+-----------------------------------------------------------------------+

-- Example 23408
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_monitor;
 
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE account_budget_monitor;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_monitor;

-- Example 23409
USE ROLE custom_budget_owner;

GRANT USAGE ON DATABASE budgets_db TO ROLE budget_monitor;

GRANT USAGE ON SCHEMA budget_db.budgets_schema TO ROLE budget_monitor;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.my_budget!VIEWER
  TO ROLE budget_monitor;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_monitor;

-- Example 23410
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 23411
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'SEARCH_OPTIMIZATION',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => DATEADD('day', -7, CURRENT_TIMESTAMP()),
   TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 23412
USE ROLE budget_monitor;

CALL budgets_db.budgets_schema.na_finance_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 23413
USE ROLE budget_monitor;

CALL budgets_db.budgets_schema.na_finance_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'MATERIALIZED_VIEW',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => DATEADD('day', -7, CURRENT_TIMESTAMP()),
   TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 23414
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_NOTIFICATION_MUTE_FLAG(TRUE);

-- Example 23415
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!DEACTIVATE();

-- Example 23416
GRANT CREATE MATERIALIZED VIEW ON SCHEMA <schema_name> TO ROLE <role_name>;

-- Example 23417
CREATE OR REPLACE MATERIALIZED VIEW mv AS
  SELECT SYSTEM$ALPHA AS col1, ...

-- Example 23418
-- Example of a materialized view with a range filter
create materialized view v1 as
  select * from table1 where column_1 between 100 and 400;

-- Example 23419
-- Example of a query that might be rewritten to use the materialized view
select * from table1 where column_1 between 200 and 300;

-- Example 23420
create materialized view mv1 as
  select * from tab1 where column_1 = X or column_1 = Y;

-- Example 23421
select * from tab1 where column_1 = Y;

-- Example 23422
select * from mv1 where column_1 = Y;

-- Example 23423
create materialized view mv1 as
  select * from tab1 where column_1 in (X, Y);

-- Example 23424
select * from tab1 where column_1 = Y;

