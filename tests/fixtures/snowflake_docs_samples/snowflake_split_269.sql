-- Example 18001
ALTER DATABASE my_database_1
  SET EXTERNAL_VOLUME = 'my_s3_vol';

-- Example 18002
CREATE ICEBERG TABLE iceberg_reviews_table (
  id STRING,
  product_name STRING,
  product_id STRING,
  reviewer_name STRING,
  review_date DATE,
  review STRING
)
CATALOG = 'SNOWFLAKE'
BASE_LOCATION = 'my/product_reviews/';

-- Example 18003
SELECT col1, col2 FROM my_iceberg_table;

-- Example 18004
INSERT INTO store_sales VALUES (-99);

UPDATE store_sales
  SET cola = 1
  WHERE cola = -99;

-- Example 18005
SELECT SYSTEM$GET_ICEBERG_TABLE_INFORMATION('db1.schema1.it1');

-- Example 18006
+-----------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_ICEBERG_TABLE_INFORMATION('DB1.SCHEMA1.IT1')                                                   |
|-----------------------------------------------------------------------------------------------------------|
| {"metadataLocation":"s3://mybucket/metadata/v1.metadata.json","status":"success"}                         |
+-----------------------------------------------------------------------------------------------------------+

-- Example 18007
ALTER ICEBERG TABLE my_iceberg_table REFRESH;

-- Example 18008
ALTER ICEBERG TABLE my_iceberg_table REFRESH 'metadata/v1.metadata.json';

-- Example 18009
SELECT metrics.* FROM
  snowflake.account_usage.table_storage_metrics metrics
  INNER JOIN snowflake.account_usage.tables tables
  ON (
    metrics.id = tables.table_id
    AND metrics.table_schema_id = tables.table_schema_id
    AND metrics.table_catalog_id = tables.table_catalog_id
  )
  WHERE tables.is_iceberg='YES';

-- Example 18010
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE;

-- Example 18011
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE
  ALLOWED_RECIPIENTS=('first.last@example.com','first2.last2@example.com');

-- Example 18012
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE
  DEFAULT_RECIPIENTS = ('person_a@example.com','person_b@example.com')
  DEFAULT_SUBJECT = 'Service status';

-- Example 18013
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_admin;

GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_ADMIN TO ROLE account_budget_admin;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_admin;

-- Example 18014
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ACTIVATE();

-- Example 18015
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_SPENDING_LIMIT(1000);

-- Example 18016
USE ROLE ACCOUNTADMIN;
   
CREATE ROLE budget_owner;
  
GRANT USAGE ON DATABASE budgets_db TO ROLE budget_owner;
GRANT USAGE ON SCHEMA budgets_db.budgets_schema TO ROLE budget_owner;

GRANT DATABASE ROLE SNOWFLAKE.BUDGET_CREATOR TO ROLE budget_owner;

GRANT CREATE SNOWFLAKE.CORE.BUDGET ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_owner;

-- Example 18017
SELECT SYSTEM$SHOW_BUDGETS_IN_ACCOUNT();

-- Example 18018
USE SCHEMA budgets_db.budgets_schema;

CREATE SNOWFLAKE.CORE.BUDGET my_budget();

-- Example 18019
CALL my_budget!SET_SPENDING_LIMIT(500);

-- Example 18020
GRANT USAGE ON DATABASE budgets_db TO ROLE budget_admin;

GRANT USAGE ON SCHEMA budget_db.budgets_schema TO ROLE budget_admin;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.my_budget!ADMIN
  TO ROLE budget_admin;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_admin;

-- Example 18021
GRANT USAGE ON DATABASE db1 TO ROLE budget_admin;

GRANT APPLYBUDGET ON DATABASE db1 TO ROLE budget_admin;

-- Example 18022
CREATE NOTIFICATION INTEGRATION budgets_notification_integration
  TYPE = EMAIL
  ENABLED = TRUE
  ALLOWED_RECIPIENTS = ('costadmin@example.com','budgetadmin@example.com');

-- Example 18023
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{"name": "value"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 18024
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 18025
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_EMAIL_NOTIFICATIONS(
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 18026
CALL my_budget!SET_EMAIL_NOTIFICATIONS(
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 18027
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_EMAIL_NOTIFICATIONS(
  'budgets_notification_integration',
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 18028
CALL my_budget!SET_EMAIL_NOTIFICATIONS(
  'budgets_notification_integration',
  'costadmin@example.com, budgetadmin@example.com'
);

-- Example 18029
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 18030
CALL my_budget!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 18031
CREATE OR REPLACE NOTIFICATION INTEGRATION budgets_notification_integration
  ENABLED = TRUE
  TYPE = QUEUE
  DIRECTION = OUTBOUND
  NOTIFICATION_PROVIDER = AWS_SNS
  AWS_SNS_TOPIC_ARN = '<ARN_for_my_SNS_topic>'
  AWS_SNS_ROLE_ARN = '<ARN_for_my_IAM_role>';

-- Example 18032
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{"name": "value"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 18033
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 18034
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 18035
CALL my_budget!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 18036
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATIONS();

-- Example 18037
CALL my_budget!GET_NOTIFICATION_INTEGRATIONS();

-- Example 18038
+----------------------------------+------------------------+------------+
|  INTEGRATION_NAME                | LAST_NOTIFICATION_TIME | ADDED_DATE |
+----------------------------------+------------------------+------------+
| budgets_notification_integration | -1                     | 2024-09-23 |
+----------------------------------+------------------------+------------+

-- Example 18039
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

-- Example 18040
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{\\\"name\\\": \\\"value\\\"}'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('budgets_notification_integration')
);

-- Example 18041
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION snowflake;

-- Example 18042
GRANT READ ON SECRET slack_secret TO APPLICATION snowflake;
GRANT USAGE ON SCHEMA my_schema TO APPLICATION snowflake;
GRANT USAGE ON DATABASE my_database TO APPLICATION snowflake;

-- Example 18043
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 18044
CALL my_budget!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 18045
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATIONS();

-- Example 18046
CALL my_budget!GET_NOTIFICATION_INTEGRATIONS();

-- Example 18047
+----------------------------------+------------------------+------------+
|  INTEGRATION_NAME                | LAST_NOTIFICATION_TIME | ADDED_DATE |
+----------------------------------+------------------------+------------+
| budgets_notification_integration | -1                     | 2024-09-23 |
+----------------------------------+------------------------+------------+

-- Example 18048
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

-- Example 18049
SELECT * FROM TABLE(
  INFORMATION_SCHEMA.NOTIFICATION_HISTORY(
    INTEGRATION_NAME=>'budgets_notification_integration'
  )
);

-- Example 18050
CALL my_budget!REMOVE_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 18051
CALL budgets_db.budgets_schema.my_budget!GET_LINKED_RESOURCES();

-- Example 18052
+-------------+-----------------+-----------+-------------+---------------+
| RESOURCE_ID | NAME            | DOMAIN    | SCHEMA_NAME | DATABASE_NAME |
|-------------+-----------------+-----------+-------------+---------------|
|         326 | DB1             | DATABASE  | NULL        | NULL          |
|         157 | MY_WH           | WAREHOUSE | NULL        | NULL          |
+-------------+-----------------+-----------+-------------+---------------+

-- Example 18053
GRANT APPLYBUDGET ON TABLE t1 TO ROLE budget_admin;

-- Example 18054
CALL budgets_db.budgets_schema.my_budget!ADD_RESOURCE(
   SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'applybudget'));

-- Example 18055
GRANT APPLYBUDGET ON DATABASE db1 TO ROLE budget_admin;

-- Example 18056
CALL budgets_db.budgets_schema.my_budget!REMOVE_RESOURCE(
   SYSTEM$REFERENCE('DATABASE', 'db1', 'SESSION', 'applybudget'));

-- Example 18057
SELECT SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'my_db.my_schema.my_table');

-- Example 18058
+-----------------------------------------------------------------------+
| SYSTEM$SHOW_BUDGETS_FOR_RESOURCE('TABLE', 'MY_DB.MY_SCHEMA.MY_TABLE') |
|-----------------------------------------------------------------------|
| [BUDGETS_DB.BUDGETS_SCHEMA.MY_BUDGET]                                 |
+-----------------------------------------------------------------------+

-- Example 18059
USE ROLE ACCOUNTADMIN;

CREATE ROLE account_budget_monitor;
 
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE account_budget_monitor;

GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE account_budget_monitor;

-- Example 18060
USE ROLE custom_budget_owner;

GRANT USAGE ON DATABASE budgets_db TO ROLE budget_monitor;

GRANT USAGE ON SCHEMA budget_db.budgets_schema TO ROLE budget_monitor;

GRANT SNOWFLAKE.CORE.BUDGET ROLE budgets_db.budgets_schema.my_budget!VIEWER
  TO ROLE budget_monitor;

GRANT DATABASE ROLE SNOWFLAKE.USAGE_VIEWER TO ROLE budget_monitor;

-- Example 18061
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 18062
USE ROLE account_budget_monitor;

CALL snowflake.local.account_root_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'SEARCH_OPTIMIZATION',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => DATEADD('day', -7, CURRENT_TIMESTAMP()),
   TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 18063
USE ROLE budget_monitor;

CALL budgets_db.budgets_schema.na_finance_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND => DATEADD('days', -7, CURRENT_TIMESTAMP()),
  TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 18064
USE ROLE budget_monitor;

CALL budgets_db.budgets_schema.na_finance_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'MATERIALIZED_VIEW',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => DATEADD('day', -7, CURRENT_TIMESTAMP()),
   TIME_UPPER_BOUND => CURRENT_TIMESTAMP()
);

-- Example 18065
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!SET_NOTIFICATION_MUTE_FLAG(TRUE);

-- Example 18066
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!DEACTIVATE();

-- Example 18067
SELECT SUM(credits_used)
  FROM snowflake.account_usage.serverless_task_history
  WHERE task_name = '_MEASUREMENT_TASK'
    AND start_time >= DATEADD('day', -28, current_timestamp());

