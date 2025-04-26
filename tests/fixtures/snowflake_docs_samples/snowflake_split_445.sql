-- Example 29787
SELECT
   fulfillment_group_name,
   databases,
   listings,
   SUM(credits_used) AS total_credits_used
FROM snowflake.data_sharing_usage.listing_auto_fulfillment_refresh_daily
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Example 29788
SELECT
   databases,
   listings,
   SUM(credits_used) AS total_credits_used
FROM snowflake.data_sharing_usage.listing_auto_fulfillment_refresh_daily
WHERE 1=1
   AND usage_date BETWEEN '2023-04-17' AND '2023-04-30'
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 29789
PRIVACY DOMAIN
  {
      [ BETWEEN ( <lo_value>, <hi_value> ) ]
    | [ IN ( '<value1>, '<value2>', ... ) ]
    | [ REFERENCES <table_name>( <col_name> ) ]
  }

-- Example 29790
CREATE TABLE <table_name>
  ( <col_name> <col_type> PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }
  )

-- Example 29791
ALTER TABLE <table_name>
  ADD COLUMN <col_name> <col_type> PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }

-- Example 29792
ALTER TABLE <table_name>
  { ALTER | MODIFY } COLUMN <col1_name> SET PRIVACY DOMAIN
    {
        [ BETWEEN ( <lo_value>, <hi_value> ) ]
      | [ IN ( '<value1>', '<value2>', ... ) ]
      | [ REFERENCES <table_name>( <col_name> ) ]
    }

-- Example 29793
ALTER TABLE <table_name>
  { ALTER | MODIFY } COLUMN <col1_name> UNSET PRIVACY DOMAIN

-- Example 29794
SHOW [ TERSE ] TABLES [ HISTORY ] [ LIKE '<pattern>' ]
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

-- Example 29795
SHOW TERSE TABLES IN tpch_sf1 STARTS WITH 'LINE';

-- Example 29796
+-------------------------------+----------+-------+-----------------------+-------------+
| created_on                    | name     | kind  | database_name         | schema_name |
|-------------------------------+----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | LINEITEM | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+----------+-------+-----------------------+-------------+

-- Example 29797
SHOW TERSE TABLES LIKE '%PART%' IN tpch_sf1;

-- Example 29798
+-------------------------------+-----------+-------+-----------------------+-------------+
| created_on                    | name      | kind  | database_name         | schema_name |
|-------------------------------+-----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | JPART     | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JPARTSUPP | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | PART      | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | PARTSUPP  | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+-----------+-------+-----------------------+-------------+

-- Example 29799
SHOW TERSE TABLES IN tpch_sf1 LIMIT 3 FROM 'J';

-- Example 29800
+-------------------------------+-----------+-------+-----------------------+-------------+
| created_on                    | name      | kind  | database_name         | schema_name |
|-------------------------------+-----------+-------+-----------------------+-------------|
| 2016-07-08 13:41:59.960 -0700 | JCUSTOMER | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JLINEITEM | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
| 2016-07-08 13:41:59.960 -0700 | JNATION   | TABLE | SNOWFLAKE_SAMPLE_DATA | TPCH_SF1    |
+-------------------------------+-----------+-------+-----------------------+-------------+

-- Example 29801
CREATE OR REPLACE TABLE test_show_tables_history(c1 NUMBER);

DROP TABLE test_show_tables_history;

-- Example 29802
SHOW TABLES HISTORY LIKE 'test_show_tables_history';

-- Example 29803
snow app events
  --since <since>
  --until <until>
  --type <record_types>
  --scope <scopes>
  --consumer-org <consumer_org>
  --consumer-account <consumer_account>
  --consumer-app-hash <consumer_app_hash>
  --first <first>
  --last <last>
  --follow
  --follow-interval <follow_interval>
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 29804
snow app events

-- Example 29805
# Limiting the number of events
snow app events --first 10
snow app events --last 10

# Narrowing the time range using interval syntax
snow app events --since '5 minutes'
snow app events --until '1 hour'

# Filtering events
snow app events --type log
snow app events --scope com.myapp.MyClass1 --scope com.myapp.MyClass2

-- Example 29806
snow app events --consumer-org <organization-name> --consumer-account <account-name>

-- Example 29807
snow app events --consumer-org <organization-name> --consumer-account <account-name> --consumer-app-hash cafc10bf6a5deb574ada0e3a009b63bbbe9bdb84

-- Example 29808
snow app events --format json

-- Example 29809
snow app open
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 29810
snow app open --connection="dev"

-- Example 29811
snow app publish
  --version <version>
  --patch <patch>
  --channel <channel>
  --directive <directive>
  --interactive / --no-interactive
  --force
  --create-version
  --from-stage
  --label <label>
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 29812
snow app publish --version v1 --patch 2

-- Example 29813
snow app publish --version v1 --patch 2 --channel ALPHA --directive customers_group_1

-- Example 29814
snow app publish --version v1 --patch 2 --channel QA

-- Example 29815
snow app publish --version v2 --create-version --directive early_adopters

-- Example 29816
snow app publish --version v2 --create-version

-- Example 29817
snow app publish --version v2 --patch 11 --create-version --from-stage

-- Example 29818
snow app teardown
  --force
  --cascade / --no-cascade
  --interactive / --no-interactive
  --package-entity-id <package_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 29819
snow app teardown --connection="dev"

-- Example 29820
snow app teardown --force --connection="dev"

-- Example 29821
snow app validate
  --package-entity-id <package_entity_id>
  --app-entity-id <app_entity_id>
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 29822
snow app validate

-- Example 29823
Validating Snowflake Native App setup script.
  Checking if stage st_version_pkg_<user>.app_src.stage_snowflake_cli_scratch exists, or creating a new one if none exists.
  Performing a diff between the Snowflake stage and your local deploy_root ('<APP_PATH>/apps/st-version/output/deploy') directory.
  There are no new files that exist only on the stage.
There are no existing files that have been modified, or their status is unknown.
There are no existing files that are identical to the ones on the stage.
New files only on your local:
README.md
manifest.yml
setup_script.sql
streamlit/environment.yml
streamlit/ui.py
  Uploading diff-ed files from your local <APP_PATH>/apps/st-version/output/deploy directory to the Snowflake stage.
  Dropping stage st_version_pkg_<user>.app_src.stage_snowflake_cli_scratch.
Snowflake Native App validation succeeded.

-- Example 29824
snow app validate --format json

-- Example 29825
{
    "errors": [],
    "warnings": [],
    "status": "SUCCESS"
}

-- Example 29826
snow app validate --format json

-- Example 29827
{
    "errors": [
        {
            "message": "Error in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/empty.sql': Empty SQL statement.",
            "cause": "Empty SQL statement.",
            "errorCode": "000900",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/empty.sql",
            "line": -1,
            "column": -1
        },
        {
            "message": "Error in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/second.sql': Unsupported feature 'CREATE VERSIONED SCHEMA without OR ALTER'.",
            "cause": "Unsupported feature 'CREATE VERSIONED SCHEMA without OR ALTER'.",
            "errorCode": "000002",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/second.sql",
            "line": -1,
            "column": -1
        },
        {
            "message": "Error in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql': File '/does-not-exist.sql' cannot be found in the same stage as the setup script is located.",
            "cause": "File '/does-not-exist.sql' cannot be found in the same stage as the setup script is located.",
            "errorCode": "093159",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql",
            "line": -1,
            "column": -1
        }
    ],
    "warnings": [
        {
            "message": "Warning in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql' on line 11 at position 35: APPLICATION ROLE should be created with IF NOT EXISTS.",
            "cause": "APPLICATION ROLE should be created with IF NOT EXISTS.",
            "errorCode": "093352",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql",
            "line": 11,
            "column": 35
        },
        {
            "message": "Warning in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql' on line 15 at position 13: CREATE Table statement in the setup script should have \"IF NOT EXISTS\", \"OR REPLACE\", or \"OR ALTER\".",
            "cause": "CREATE Table statement in the setup script should have \"IF NOT EXISTS\", \"OR REPLACE\", or \"OR ALTER\".",
            "errorCode": "093351",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql",
            "line": 15,
            "column": 13
        },
        {
            "message": "Warning in file '@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql' on line 15 at position 13: Table identifier 'MY_TABLE' should include its parent schema name.",
            "cause": "Table identifier 'MY_TABLE' should include its parent schema name.",
            "errorCode": "093353",
            "fileName": "@STAGE_SNOWFLAKE_CLI_SCRATCH/setup_script.sql",
            "line": 15,
            "column": 13
        }
    ],
    "status": "FAIL"
}

-- Example 29828
snow app release-channel list

-- Example 29829
snow app publish --version v1 --patch 1

-- Example 29830
snow app publish --version v1 --create-version

-- Example 29831
snow app publish --version v1 --patch 1 --channel ALPHA

-- Example 29832
snow app publish --version v1 --patch 1 --channel ALPHA --directive customers_group_1

-- Example 29833
snow app release-channel add-version --version v1 ALPHA
snow app release-directive set customers_group_1 --version v1 --patch 1

-- Example 29834
snow app publish --version v1 --patch 1

-- Example 29835
snow app publish --version v1 --create-version

-- Example 29836
snow app publish --version v1 --patch 1 --directive customers_group_1

-- Example 29837
class CustomOnIngestionScheduledCallback implements OnIngestionScheduledCallback {
    @Override
    public void onIngestionScheduled(String processId) {
        // CUSTOM LOGIC
    }
}

class CustomHandler {

    // Path to this method needs to be specified in the PUBLIC.RUN_SCHEDULER_ITERATION procedure using SQL
    public static Variant runIteration(Session session) {
        return RunSchedulerIterationHandler.builder(session)
            .withOnIngestionScheduledCallback(new CustomOnIngestionScheduledCallback())
            .build()
            .runIteration()
            .toVariant();
    }
}

-- Example 29838
{
  "type": "text",
  "text":  "Which company had the most revenue?"
}

-- Example 29839
{
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "which company had the most revenue?"
                }
            ]
        }
    ],
    "semantic_model_file": "@my_db.my_schema.my_stage/my_semantic_model.yaml"
}

-- Example 29840
{
    "request_id": "75d343ee-699c-483f-83a1-e314609fb563",
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "We interpreted your question as ..."
            },
            {
                "type": "sql",
                "statement": "SELECT * FROM table",
                "confidence": {
                    "verified_query_used": {
                        "name": "My verified query",
                        "question": "What was the total revenue?",
                        "sql": "SELECT * FROM table2",
                        "verified_at": 1714497970,
                        "verified_by": "Jane Doe"
                    }
                }
            }
        ]
    },
    "warnings": [
        {
            "message": "Table table1 has (30) columns, which exceeds the recommended maximum of 10"
        },
        {
            "message": "Table table2 has (40) columns, which exceeds the recommended maximum of 10"
        }
    ]
}

-- Example 29841
{
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "This is how we interpreted your question and this is how the sql is generated"
            },
            {
                "type": "sql",
                "statement": "SELECT * FROM table"
            }
        ]
    }
}

-- Example 29842
event: status
data: { status: "interpreting_question" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: "This is how we interpreted your question"
}

event: status
data: { status: "generating_sql" }

event: status
data: { status: "validating_sql" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: " and this is how the sql is generated"
}

event: message.content.delta
data: {
  index: 1,
  type: "sql",
  statement_delta: "SELECT * FROM table"
}

event: status
data: { status: "done" }

-- Example 29843
{
    "message": {
        "role": "analyst",
        "content": [
            {
                "type": "text",
                "text": "Your question is ambigous, here are some alternatives:"
            },
            {
                "type": "suggestions",
                "suggestions": [
                    "which company had the most revenue?",
                    "which company placed the most orders?"
                ]
            }
        ]
    }
}

-- Example 29844
event: status
data: { status: "interpreting_question" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: "Your question is ambigous,"
}

event: status
data: { status: "generating_suggestions" }

event: message.content.delta
data: {
  index: 0,
  type: "text",
  text_delta: " here are some alternatives:"
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 0,
    suggestion_delta: "which company had",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 0,
    suggestion_delta: " the most revenue?",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 1,
    suggestion_delta: "which company placed",
  }
}

event: message.content.delta
data: {
  index: 1,
  type: "suggestions",
  suggestions_delta: {
    index: 1,
    suggestion_delta: " the most orders?",
  }
}

event: status
data: { status: "done" }

-- Example 29845
StreamingError:
type: object
properties:
  message:
    type: string
    description: A description of the error
  code:
    type: string
    description: The Snowflake error code categorizing the error
  request_id:
    type: string
    description: Unique request ID

-- Example 29846
Warnings:
type: object
description: Warnings found while processing the request
properties:
  warnings:
    type: array
    items:
      $ref: "#/components/schemas/Warning"
Warning:
type: object
title: The warning object
description: Represents a warning within a chat.
properties:
  message:
    type: string
    description: A human-readable message describing the warning

-- Example 29847
SQL Execution Error: Cannot create catalog integration <catalog_integration_name> due to error: Unable to process: Unable to find
warehouse <catalog_name>. Check the REST configuration and ensure the warehouse name '<catalog_name>' matches the Polaris catalog
name.

-- Example 29848
SQL Execution Error: User provided authentication credentials are invalid for catalog integration <catalog_integration_name> due
to error: Malformed request: unauthorized_client: The client is not authorized.

-- Example 29849
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The Snowflake service
connection associated with the Polaris catalog integration does not have the required privileges to send notifications. The
minimum required privileges are TABLE_CREATE, TABLE_WRITE_PROPERTIES, TABLE_DROP, NAMESPACE_CREATE, and NAMESPACE_DROP.

-- Example 29850
SQL Execution Error: Failed to access the REST endpoint of catalog integration <catalog_integration_name> with error: Unable to
process: Failed to get subscoped credentials: Error assuming AWS_ROLE:
User: <IAM_user_arn> is not authorized to perform: sts:AssumeRole on resource: <S3_role_arn>. Check the accessibility of the REST
catalog URI or warehouse.

-- Example 29851
{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
           "AWS": [
               "arn:aws:iam::111111111111:user/----0000-s",
               "arn:aws:iam::222222222222:user/----0000-s"
            ]
         },
         "Action": "sts:AssumeRole",
         "Condition": {
           "StringEquals": {
             "sts:ExternalId": "iceberg_table_external_id"
           }
         }
       }
     ]
   }

-- Example 29852
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The associated Polaris
catalog cannot be of type INTERNAL.

-- Example 29853
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: SQL Execution Error:
Resource on the REST endpoint of catalog integration CATINT is forbidden due to error: Forbidden: Invalid locations '[<path to metadata file>]'
for identifier '<identifier>': <path to metadata file> is not in the list of allowed locations: [<list of allowed locations>].

