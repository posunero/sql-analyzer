-- Example 18671
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ ALLOWED_RECIPIENTS = ( '<email_address>' [ , ... '<email_address>' ] ) ]
  [ DEFAULT_RECIPIENTS = ( '<email_address>' [ , ... '<email_address>' ] ) ]
  [ DEFAULT_SUBJECT = '<subject_line>' ]
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET
  ENABLED            |
  ALLOWED_RECIPIENTS |
  DEFAULT_RECIPIENTS |
  DEFAULT_SUBJECT    |
  COMMENT

-- Example 18672
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18673
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18674
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  AWS_SNS_TOPIC_ARN = '<topic_arn>'
  AWS_SNS_ROLE_ARN = '<iam_role_arn>'
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18675
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "<sns_topic_arn>"
    }
  ]
}

-- Example 18676
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = TRUE
  DIRECTION = OUTBOUND
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AWS_SNS
  AWS_SNS_TOPIC_ARN = 'arn:aws:sns:us-east-2:111122223333:sns_topic'
  AWS_SNS_ROLE_ARN = 'arn:aws:iam::111122223333:role/error_sns_role';

-- Example 18677
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 18678
+---------------------------+-------------------+------------------------------------------------------+----------------------+
|   property                |   property_type   |   property_value                                     |   property_default   |
+---------------------------+-------------------+------------------------------------------------------+----------------------+
|   ENABLED                 |   Boolean         |   true                                               |   false              |
|   NOTIFICATION_PROVIDER   |   String          |   AWS_SNS                                            |                      |
|   DIRECTION               |   String          |   OUTBOUND                                           |   INBOUND            |
|   AWS_SNS_TOPIC_ARN       |   String          |   arn:aws:sns:us-east-2:111122223333:myaccount       |                      |
|   AWS_SNS_ROLE_ARN        |   String          |   arn:aws:iam::111122223333:role/myrole              |                      |
|   SF_AWS_IAM_USER_ARN     |   String          |   arn:aws:iam::123456789001:user/c_myaccount         |                      |
|   SF_AWS_EXTERNAL_ID      |   String          |   MYACCOUNT_SFCRole=2_a123456/s0aBCDEfGHIJklmNoPq=   |                      |
+---------------------------+-------------------+------------------------------------------------------+----------------------+

-- Example 18679
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<sf_aws_iam_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<sf_aws_external_id>"
        }
      }
    }
  ]
}

-- Example 18680
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  AZURE_STORAGE_QUEUE_PRIMARY_URI = '<queue_URL>'
  AZURE_TENANT_ID = '<directory_ID>';
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18681
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = TRUE
  DIRECTION = OUTBOUND
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_EVENT_GRID
  AZURE_EVENT_GRID_TOPIC_ENDPOINT = 'https://myaccount.region-1.eventgrid.azure.net/api/events'
  AZURE_TENANT_ID = 'mytenantid';

-- Example 18682
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>'
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ NOTIFICATION ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18683
gsutil notification create -t <topic>

-- Example 18684
CREATE NOTIFICATION INTEGRATION my_notification_int
  ENABLED = TRUE
  DIRECTION = OUTBOUND
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  GCP_PUBSUB_TOPIC_NAME = 'projects/sdm-prod/topics/mytopic';

-- Example 18685
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 18686
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 18687
ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ WEBHOOK_URL = '<url>' ]
  [ WEBHOOK_SECRET = <secret_name> ]
  [ WEBHOOK_BODY_TEMPLATE = '<template_for_http_request_body>' ]
  [ WEBHOOK_HEADERS = ( '<header_1>'='<value_1>' [ , '<header_N>'='<value_N>', ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER [ NOTIFICATION ] INTEGRATION [ IF EXISTS ] <name> UNSET {
  ENABLED               |
  WEBHOOK_SECRET        |
  WEBHOOK_BODY_TEMPLATE |
  WEBHOOK_HEADERS       |
  COMMENT
}

-- Example 18688
https://<hostname>.webhook.office.com/webhookb2/<path_components>/IncomingWebhook/<path_components>

-- Example 18689
WEBHOOK_URL='https://hooks.slack.com/services/SNOWFLAKE_WEBHOOK_SECRET'

-- Example 18690
WEBHOOK_SECRET = my_secrets_db.my_secrets_schema.my_slack_webhook_secret

-- Example 18691
WEBHOOK_BODY_TEMPLATE='{
  "routing_key": "SNOWFLAKE_WEBHOOK_SECRET",
  "event_action": "trigger",
  "payload":
    {
      "summary": "SNOWFLAKE_WEBHOOK_MESSAGE",
      "source": "Snowflake monitoring",
      "severity": "INFO",
    }
  }'

-- Example 18692
WEBHOOK_HEADERS=('Content-Type'='application/json')

-- Example 18693
WEBHOOK_HEADERS=('Authorization'='Basic SNOWFLAKE_WEBHOOK_SECRET')

-- Example 18694
ALTER ORGANIZATION ACCOUNT SET { [ accountParams ] | [ objectParams ] | [ sessionParams ] }

ALTER ORGANIZATION ACCOUNT UNSET <param_name> [ , ... ]

ALTER ORGANIZATION ACCOUNT SET RESOURCE_MONITOR = <monitor_name>

ALTER ORGANIZATION ACCOUNT SET { PASSWORD | SESSION } POLICY <policy_name>

ALTER ORGANIZATION ACCOUNT UNSET { PASSWORD | SESSION } POLICY

ALTER ORGANIZATION ACCOUNT SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER ORGANIZATION ACCOUNT UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER ORGANIZATION ACCOUNT <name> RENAME TO <new_name> [ SAVE_OLD_URL = { TRUE | FALSE } ]

ALTER ORGANIZATION ACCOUNT <name> DROP OLD URL

-- Example 18695
ALTER ORGANIZATION ACCOUNT original_acctname RENAME TO new_acctname;

-- Example 18696
ALTER PACKAGES POLICY [ IF EXISTS ] <name> SET
  [ ALLOWLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ BLOCKLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ ADDITIONAL_CREATION_BLOCKLIST = ( [ '<packageSpec>' ] [ , '<packageSpec>' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER PACKAGES POLICY [ IF EXISTS ] <name> UNSET
  [ ALLOWLIST ]
  [ BLOCKLIST ]
  [ ADDITIONAL_CREATION_BLOCKLIST ]
  [ COMMENT ]

-- Example 18697
ALTER PACKAGES POLICY packages_policy_prod_1 SET ALLOWLIST = ('pandas==1.2.3');

-- Example 18698
ALTER PRIVACY POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER PRIVACY POLICY [ IF EXISTS ] <name> SET BODY -> <expression>

ALTER PRIVACY POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PRIVACY POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PRIVACY POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER PRIVACY POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18699
PRIVACY_BUDGET(
  BUDGET_NAME=> '<string>'
  [, BUDGET_LIMIT=> <decimal> ]
  [, MAX_BUDGET_PER_AGGREGATE=> <decimal> ]
  [, BUDGET_WINDOW=> <string> ]
)

-- Example 18700
-- Modify the body of privacy policy "my_priv_policy" so it always returns a
-- budget named "analysts"
ALTER PRIVACY POLICY my_priv_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME => 'analysts');

-- Set budget limit to 50 and max budget per aggregate to 0.1
-- budget window is not mentioned so it is reset to its default value
ALTER PRIVACY POLICY users_policy SET BODY ->
  privacy_budget(budget_name=>'analysts', budget_limit=>50, max_budget_per_aggregate=>0.1);

-- Example 18701
ALTER REPLICATION GROUP [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SET
  [ OBJECT_TYPES = <object_type> [ , <object_type> , ... ] ]
  [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
  [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SET
  OBJECT_TYPES = INTEGRATIONS [ , <object_type> , ... ]
  ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> ... ]

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SET
  REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }'

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SET
  TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SET
  ERROR_INTEGRATION = <integration_name>

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  ADD <db_name> [ , <db_name> ,  ... ] TO ALLOWED_DATABASES

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  MOVE DATABASES <db_name> [ , <db_name> ,  ... ] TO REPLICATION GROUP <move_to_rg_name>

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  REMOVE <db_name> [ , <db_name> ,  ... ] FROM ALLOWED_DATABASES

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  ADD <share_name> [ , <share_name> ,  ... ] TO ALLOWED_SHARES

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  MOVE SHARES <share_name> [ , <share_name> ,  ... ] TO REPLICATION GROUP <move_to_rg_name>

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  REMOVE <share_name> [ , <share_name> ,  ... ] FROM ALLOWED_SHARES

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  ADD <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] TO ALLOWED_ACCOUNTS
  [ IGNORE EDITION CHECK ]

ALTER REPLICATION GROUP [ IF EXISTS ] <name>
  REMOVE <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] FROM ALLOWED_ACCOUNTS

-- Example 18702
ALTER REPLICATION GROUP [ IF EXISTS ] <name> REFRESH

ALTER REPLICATION GROUP [ IF EXISTS ] <name> SUSPEND [ IMMEDIATE ]

ALTER REPLICATION GROUP [ IF EXISTS ] <name> RESUME

-- Example 18703
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 18704
ALTER REPLICATION GROUP myrg ADD myorg.myaccount3 TO ALLOWED_ACCOUNTS;

-- Example 18705
ALTER REPLICATION GROUP myrg SET
  OBJECT_TYPES = DATABASES, SHARES;

-- Example 18706
ALTER REPLICATION GROUP myrg
  ADD db1 to ALLOWED_DATABASES;

-- Example 18707
ALTER REPLICATION GROUP myrg
  ADD s2 TO ALLOWED_SHARES;

-- Example 18708
ALTER REPLICATION GROUP myrg
  MOVE DATABASES db1 TO REPLICATION GROUP myrg2;

-- Example 18709
ALTER REPLICATION GROUP myrg SET
  REPLICATION_SCHEDULE = '15 MINUTE';

-- Example 18710
ALTER REPLICATION GROUP myrg REFRESH;

-- Example 18711
ALTER REPLICATION GROUP myrg SUSPEND;

-- Example 18712
ALTER RESOURCE MONITOR [ IF EXISTS ] <name> [ SET { [ CREDIT_QUOTA = <num> ]
                                                    [ FREQUENCY = { MONTHLY | DAILY | WEEKLY | YEARLY | NEVER } ]
                                                    [ START_TIMESTAMP = { <timestamp> | IMMEDIATELY } ]
                                                    [ END_TIMESTAMP = <timestamp> ]
                                                    [ NOTIFY_USERS = ( <user_name> [ , <user_name> , ... ] ) ] } ]
                                            [ TRIGGERS triggerDefinition [ triggerDefinition ... ] ]

-- Example 18713
triggerDefinition ::=
   ON <threshold> PERCENT DO { SUSPEND | SUSPEND_IMMEDIATE | NOTIFY }

-- Example 18714
ALTER RESOURCE MONITOR limiter
  SET CREDIT_QUOTA=2000
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Example 18715
ALTER RESOURCE MONITOR limiter
  SET CREDIT_QUOTA = 2000
      NOTIFY_USERS = (JDOE, "Jane Smith", "John Doe")
  TRIGGERS ON 80 PERCENT DO NOTIFY
           ON 100 PERCENT DO SUSPEND_IMMEDIATE

-- Example 18716
ALTER ROLE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER ROLE [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER ROLE [ IF EXISTS ] <name> UNSET COMMENT

ALTER ROLE [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER ROLE [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18717
ALTER ROLE role1 RENAME TO role2;

-- Example 18718
ALTER ROLE myrole SET COMMENT = 'New comment for role';

-- Example 18719
ALTER SECRET [ IF EXISTS ] <name> SET [ OAUTH_SCOPES = ( '<scope_1>' [ , '<scope_2>' ... ] ) ]
                                      [ COMMENT = '<string_literal>' ]

ALTER SECRET [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18720
ALTER SECRET [ IF EXISTS ] <name> SET [ OAUTH_REFRESH_TOKEN = '<token>' ]
                                      [ OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '<string_literal>' ]
                                      [ COMMENT = '<string_literal>' ]

ALTER SECRET [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18721
ALTER SECRET [ IF EXISTS ] <name> SET [ API_AUTHENTICATION = '<cloud_provider_security_integration>' ]
                                      [ COMMENT = '<string_literal>' ]

ALTER SECRET [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18722
ALTER SECRET [ IF EXISTS ] <name> SET [ USERNAME = '<username>' ]
                                      [ PASSWORD = '<password>' ]
                                      [ COMMENT = '<string_literal>' ]

ALTER SECRET [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18723
ALTER SECRET [ IF EXISTS ] <name> SET [ SECRET_STRING = '<string_literal>' ]
                                      [ COMMENT = '<string_literal>' ]

ALTER SECRET [ IF EXISTS ] <name> UNSET COMMENT

-- Example 18724
ALTER SECRET service_now_creds_pw SET COMMENT = 'production secret for servicenow';

-- Example 18725
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET <parameters>

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name>  UNSET <parameter>

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18726
ALTER SECURITY INTEGRATION <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'CLIENT_CREDENTIALS']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_ALLOWED_SCOPES = ( '<scope_1>' [ , '<scope_2>' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> UNSET {
  ENABLED | [ , ... ]
}

-- Example 18727
ALTER SECURITY INTEGRATION <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_AUTHORIZATION_ENDPOINT = '<string_literal>' ]
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'AUTHORIZATION_CODE']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> UNSET {
  ENABLED | [ , ... ]
}

-- Example 18728
ALTER SECURITY INTEGRATION <name> SET
  [ ENABLED = { TRUE | FALSE } ]
  [ OAUTH_AUTHORIZATION_ENDPOINT = '<string_literal>' ]
  [ OAUTH_TOKEN_ENDPOINT = '<string_literal>' ]
  [ OAUTH_CLIENT_AUTH_METHOD = CLIENT_SECRET_POST ]
  [ OAUTH_CLIENT_ID = '<string_literal>' ]
  [ OAUTH_CLIENT_SECRET = '<string_literal>' ]
  [ OAUTH_GRANT = 'JWT_BEARER']
  [ OAUTH_ACCESS_TOKEN_VALIDITY = <integer> ]
  [ OAUTH_REFRESH_TOKEN_VALIDITY = <integer> ]
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> UNSET {
  ENABLED | [ , ... ]
}

-- Example 18729
https://<instance_name>.service-now.com/oauth_token.do

-- Example 18730
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

-- Example 18731
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
  [ TYPE = AWS_IAM ]
  [ AWS_ROLE_ARN = '<iam_role_arn>' ]
  [ ENABLED = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18732
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

-- Example 18733
ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name> SET
  [ TYPE = EXTERNAL_OAUTH ]
  [ ENABLED = { TRUE | FALSE } ]
  [ EXTERNAL_OAUTH_TYPE = { OKTA | AZURE | PING_FEDERATE | CUSTOM } ]
  [ EXTERNAL_OAUTH_ISSUER = '<string_literal>' ]
  [ EXTERNAL_OAUTH_TOKEN_USER_MAPPING_CLAIM = '<string_literal>' | ('<string_literal>', '<string_literal>' [ , ... ] ) ]
  [ EXTERNAL_OAUTH_SNOWFLAKE_USER_MAPPING_ATTRIBUTE = 'LOGIN_NAME | EMAIL_ADDRESS' ]
  [ EXTERNAL_OAUTH_JWS_KEYS_URL = '<string_literal>' ] -- For OKTA | PING_FEDERATE | CUSTOM
  [ EXTERNAL_OAUTH_JWS_KEYS_URL = '<string_literal>' | ('<string_literal>' [ , '<string_literal>' ... ] ) ] -- For Azure
  [ EXTERNAL_OAUTH_RSA_PUBLIC_KEY = <public_key1> ]
  [ EXTERNAL_OAUTH_RSA_PUBLIC_KEY_2 = <public_key2> ]
  [ EXTERNAL_OAUTH_BLOCKED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ EXTERNAL_OAUTH_ALLOWED_ROLES_LIST = ( '<role_name>' [ , '<role_name>' , ... ] ) ]
  [ EXTERNAL_OAUTH_AUDIENCE_LIST = ('<string_literal>') ]
  [ EXTERNAL_OAUTH_ANY_ROLE_MODE = DISABLE | ENABLE | ENABLE_FOR_PRIVILEGE ]
  [ EXTERNAL_OAUTH_SCOPE_DELIMITER = '<string_literal>' ] -- Only for EXTERNAL_OAUTH_TYPE = CUSTOM
  [ COMMENT = '<string_literal>' ]

ALTER [ SECURITY ] INTEGRATION [ IF EXISTS ] <name>  UNSET {
                                                            ENABLED                      |
                                                            EXTERNAL_OAUTH_AUDIENCE_LIST |
                                                            }
                                                            [ , ... ]

ALTER [ SECURITY ] INTEGRATION <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER [ SECURITY ] INTEGRATION <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 18734
external_oauth_audience_list = ('https://example.com/api/v2/', 'https://example.com')

-- Example 18735
GRANT USE_ANY_ROLE ON INTEGRATION external_oauth_1 TO role1;

-- Example 18736
REVOKE USE_ANY_ROLE ON INTEGRATION external_oauth_1 FROM role1;

-- Example 18737
ALTER SECURITY INTEGRATION myint SET ENABLED = TRUE;

