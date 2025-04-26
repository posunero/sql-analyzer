-- Example 11906
SELECT *
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'FAILED' AND
    resource_attributes:"snow.schema.name" = 'MY_SCHEMA' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 11907
+-------------------------+-----------------+-------------------------+-------+----------+------------------------------------------------------------+-------+------------------+-------------+-------------------------------+-------------------+------------------------------------------------------------------------------------------------------+-----------+
| TIMESTAMP               | START_TIMESTAMP | OBSERVED_TIMESTAMP      | TRACE | RESOURCE | RESOURCE_ATTRIBUTES                                        | SCOPE | SCOPE_ATTRIBUTES | RECORD_TYPE | RECORD                        | RECORD_ATTRIBUTES | VALUE                                                                                                | EXEMPLARS |
|-------------------------+-----------------+-------------------------+-------+----------+------------------------------------------------------------+-------+------------------+-------------+-------------------------------+-------------------+------------------------------------------------------------------------------------------------------+-----------|
| 2025-02-18 00:21:19.461 | NULL            | 2025-02-18 00:21:19.461 | NULL  | NULL     | {                                                          | NULL  | NULL             | EVENT       | {                             | NULL              | {                                                                                                    | NULL      |
|                         |                 |                         |       |          |   "snow.database.id": 49,                                  |       |                  |             |   "name": "execution.status", |                   |   "message": "002003: SQL compilation error:\nObject 'EMP_TABLE' does not exist or not authorized.", |           |
|                         |                 |                         |       |          |   "snow.database.name": "MY_DB",                        |       |                  |                |   "severity_text": "ERROR"    |                   |   "state": "FAILED"                                                                                  |           |
|                         |                 |                         |       |          |   "snow.executable.id": 518,                               |       |                  |             | }                             |                   | }                                                                                                    |           |
|                         |                 |                         |       |          |   "snow.executable.name": "T1",                            |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.executable.type": "TASK",                          |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.owner.id": 2601,                                   |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.owner.name": "DATA_ADMIN",                         |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.owner.type": "ROLE",                               |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.query.id": "01ba76b5-0107-e56d-0000-a995024f4222", |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.schema.id": 411,                                   |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.schema.name": "MY_SCHEMA",                      |       |                  |             |                               |                   |                                                                                                      |              |
|                         |                 |                         |       |          |   "snow.warehouse.id": 41,                                 |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          |   "snow.warehouse.name": "INTAKE_WAREHOUSE"                |       |                  |             |                               |                   |                                                                                                      |           |
|                         |                 |                         |       |          | }                                                          |       |                  |             |                               |                   |                                                                                                      |           |
+-------------------------+-----------------+-------------------------+-------+----------+------------------------------------------------------------+-------+------------------+-------------+-------------------------------+-------------------+------------------------------------------------------------------------------------------------------+-----------+

-- Example 11908
EXECUTE ALERT <name>

-- Example 11909
EXECUTE ALERT myalert;

-- Example 11910
SELECT
    start_time,
    end_time,
    alert_id,
    alert_name,
    credits_used,
    schema_id,
    schema_name,
    database_id,
    database_name,
  FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_ALERT_HISTORY
  LIMIT 2;

-- Example 11911
+---------------------------------+---------------------------------+----------+---------------------+--------------+-----------+-------------+-------------+---------------+
|           START_TIME            |            END_TIME             | ALERT_ID |     ALERT_NAME      | CREDITS_USED | SCHEMA_ID | SCHEMA_NAME | DATABASE_ID | DATABASE_NAME |
+---------------------------------+---------------------------------+----------+---------------------+--------------+-----------+-------------+-------------+---------------+
| Tue, 10 Sep 2024 17:57:00 -0700 | Tue, 10 Sep 2024 17:58:00 -0700 | 202      | MY_SERVERLESS_ALERT | 0.000869065  | 52        | SCTEST      | 30          | DBTEST        |
| Tue, 10 Sep 2024 18:57:00 -0700 | Tue, 10 Sep 2024 18:58:00 -0700 | 202      | MY_SERVERLESS_ALERT | 0.000841918  | 52        | SCTEST      | 30          | DBTEST        |
+---------------------------------+---------------------------------+----------+---------------------+--------------+-----------+-------------+-------------+---------------+

-- Example 11912
GRANT ROLE ACCOUNTADMIN, SYSADMIN TO USER user2;

ALTER USER user2 SET EMAIL='user2@domain.com', DEFAULT_ROLE=SYSADMIN;

-- Example 11913
CREATE ROLE r1
   COMMENT = 'This role has all privileges on schema_1';

-- Example 11914
GRANT USAGE
  ON WAREHOUSE w1
  TO ROLE r1;

GRANT USAGE
  ON DATABASE d1
  TO ROLE r1;

GRANT USAGE
  ON SCHEMA d1.s1
  TO ROLE r1;

GRANT SELECT
  ON TABLE d1.s1.t1
  TO ROLE r1;

-- Example 11915
GRANT ROLE r1
   TO USER smith;

-- Example 11916
ALTER USER smith
   SET DEFAULT_ROLE = r1;

-- Example 11917
GRANT USAGE
  ON DATABASE d1
  TO ROLE read_only;

GRANT USAGE
  ON SCHEMA d1.s1
  TO ROLE read_only;

GRANT SELECT
  ON ALL TABLES IN SCHEMA d1.s1
  TO ROLE read_only;

GRANT USAGE
  ON WAREHOUSE w1
  TO ROLE read_only;

-- Example 11918
GRANT SELECT ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE read_only;

-- Example 11919
GRANT ROLE r1
   TO ROLE sysadmin;

-- Example 11920
SHOW GRANTS ON SCHEMA <database_name>.<schema_name>;

-- Example 11921
SHOW GRANTS ON SCHEMA database_a.schema_1;

-- Example 11922
+-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------+
| created_on                    | privilege             | granted_on | name                 | granted_to | grantee_name             | grant_option | granted_by    |
|-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------|
| 2022-03-07 09:04:23.635 -0800 | USAGE                 | SCHEMA     | D1.S1                | ROLE       | R1                       | false        | SECURITYADMIN |
+-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------+

-- Example 11923
SHOW GRANTS TO ROLE <role_name>;
SHOW GRANTS TO USER <user_name>;

-- Example 11924
SHOW GRANTS TO ROLE r1;

-- Example 11925
+-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------+
| created_on                    | privilege | granted_on | name                 | granted_to | grantee_name | grant_option | granted_by    |
|-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------|
| 2022-03-07 09:08:43.773 -0800 | USAGE     | DATABASE   | D1                   | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:08:55.253 -0800 | USAGE     | SCHEMA     | D1.S1                | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:09:07.206 -0800 | SELECT    | TABLE      | D1.S1.T1             | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:08:34.838 -0800 | USAGE     | WAREHOUSE  | W1                   | ROLE       | R1           | false        | SECURITYADMIN |
+-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------+

-- Example 11926
GRANT SELECT ON FUTURE TABLES IN DATABASE d1 TO ROLE r1;

-- Example 11927
GRANT INSERT,DELETE ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE r2;

-- Example 11928
GRANT MONITOR USAGE ON ACCOUNT TO ROLE custom;

GRANT IMPORTED PRIVILEGES ON DATABASE snowflake TO ROLE custom;

-- Example 11929
CREATE [ OR REPLACE ] ALERT [ IF NOT EXISTS ] <name>
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
  [ SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }' ]
  [ WAREHOUSE = <warehouse_name> ]
  [ COMMENT = '<string_literal>' ]
  IF( EXISTS(
    <condition>
  ))
  THEN
    <action>

-- Example 11930
CREATE [ OR REPLACE ] ALERT <name> CLONE <source_alert>
  [ ... ]

-- Example 11931
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 11932
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE;

-- Example 11933
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE
  ALLOWED_RECIPIENTS=('first.last@example.com','first2.last2@example.com');

-- Example 11934
CREATE NOTIFICATION INTEGRATION my_email_int
  TYPE=EMAIL
  ENABLED=TRUE
  DEFAULT_RECIPIENTS = ('person_a@example.com','person_b@example.com')
  DEFAULT_SUBJECT = 'Service status';

-- Example 11935
https://hooks.slack.com/services/<secret>

-- Example 11936
https://<hostname>.webhook.office.com/webhookb2/<secret>

-- Example 11937
{
   "routing_key" : "<integration_key>",
   ...

-- Example 11938
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

-- Example 11939
CREATE OR REPLACE SECRET my_slack_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX';

-- Example 11940
https://mymsofficehost.webhook.office.com/webhookb2/xxxxxxxx

-- Example 11941
CREATE OR REPLACE SECRET my_teams_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'xxxxxxxx';

-- Example 11942
xxxxxxxx

-- Example 11943
CREATE OR REPLACE SECRET my_pagerduty_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'xxxxxxxx';

-- Example 11944
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

-- Example 11945
CREATE OR REPLACE NOTIFICATION INTEGRATION my_slack_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://hooks.slack.com/services/SNOWFLAKE_WEBHOOK_SECRET'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_slack_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 11946
https://mymsofficehost.webhook.office.com/webhookb2/xxxxxxxx

-- Example 11947
CREATE OR REPLACE NOTIFICATION INTEGRATION my_teams_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://mymsofficehost.webhook.office.com/webhookb2/SNOWFLAKE_WEBHOOK_SECRET'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_teams_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 11948
https://events.pagerduty.com/v2/enqueue

-- Example 11949
CREATE OR REPLACE NOTIFICATION INTEGRATION my_pagerduty_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://events.pagerduty.com/v2/enqueue'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_pagerduty_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{
    "routing_key": "SNOWFLAKE_WEBHOOK_SECRET",
    "event_action": "trigger",
    "payload": {
      "summary": "SNOWFLAKE_WEBHOOK_MESSAGE",
      "source": "Snowflake monitoring",
      "severity": "INFO"
    }
  }'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 11950
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(
    SNOWFLAKE.NOTIFICATION.SANITIZE_WEBHOOK_CONTENT('my message')
  ),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_slack_webhook_int')
);

-- Example 11951
CREATE OR REPLACE NOTIFICATION INTEGRATION my_slack_webhook_int
  ...
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  ...

-- Example 11952
{"text": "my message"}

-- Example 11953
CREATE ROLE CAN_VIEWMD COMMENT = 'This role can view metadata per SNOWFLAKE database role definitions';

-- Example 11954
GRANT DATABASE ROLE OBJECT_VIEWER TO ROLE CAN_VIEWMD;

-- Example 11955
GRANT ROLE CAN_VIEWMD TO USER smith;

-- Example 11956
GRANT DATABASE ROLE <name> TO { ROLE | DATABASE ROLE } <parent_role_name>

-- Example 11957
GRANT DATABASE ROLE analyst TO ROLE SYSADMIN;

-- Example 11958
GRANT DATABASE ROLE dr1 TO DATABASE ROLE dr2;

-- Example 11959
DROP ALERT [ IF EXISTS ] <name>

-- Example 11960
SHOW [ TERSE ] ALERTS [ LIKE '<pattern>' ]
                      [ IN
                            {
                              ACCOUNT                                         |

                              DATABASE                                        |
                              DATABASE <database_name>                        |

                              SCHEMA                                          |
                              SCHEMA <schema_name>                            |
                              <schema_name>

                              APPLICATION <application_name>                  |
                              APPLICATION PACKAGE <application_package_name>  |
                            }
                      ]
                      [ STARTS WITH '<name_string>' ]
                      [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 11961
DESC[RIBE] ALERT <name>

-- Example 11962
SELECT name, condition, condition_query_id, action, action_query_id, state
FROM snowflake.account_usage.alert_history
LIMIT 10;

-- Example 11963
SELECT name, condition, condition_query_id, action, action_query_id, state
FROM snowflake.account_usage.alert_history
WHERE COMPLETED_TIME > DATEADD(hours, -1, CURRENT_TIMESTAMP());

-- Example 11964
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENABLE_IDENTIFIER_FIRST_LOGIN = true;

-- Example 11965
-----BEGIN CERTIFICATE-----
<certificate>
-----END CERTIFICATE-----

-- Example 11966
CREATE SECURITY INTEGRATION my_idp
  TYPE = saml2
  ENABLED = true
  SAML2_ISSUER = 'https://example.com'
  SAML2_SSO_URL = 'http://myssoprovider.com'
  SAML2_PROVIDER = 'ADFS'
  SAML2_X509_CERT = 'MIICr...'
  SAML2_SNOWFLAKE_ISSUER_URL = 'https://<orgname>-<account_name>.privatelink.snowflakecomputing.com'
  SAML2_SNOWFLAKE_ACS_URL = 'https://<orgname>-<account_name>.privatelink.snowflakecomputing.com/fed/login';

-- Example 11967
ALTER SECURITY INTEGRATION my_idp SET SAML2_ENABLE_SP_INITIATED = true;
ALTER SECURITY INTEGRATION my_idp SET SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'My IdP';

-- Example 11968
DESC SECURITY INTEGRATION my_idp;

-- Example 11969
-----BEGIN CERTIFICATE-----
MIICr...
-----END CERTIFICATE-----

-- Example 11970
ALTER SECURITY INTEGRATION my_idp SET SAML2_SNOWFLAKE_X509_CERT = 'AX2bv...';

-- Example 11971
DESC SECURITY INTEGRATION my_idp;

-- Example 11972
ALTER SECURITY INTEGRATION my_idp SET SAML2_SIGN_REQUEST = true;

