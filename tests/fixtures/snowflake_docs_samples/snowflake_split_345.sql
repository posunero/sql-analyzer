-- Example 23093
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     },
     {
        "Sid":"s3-event-notifier",
        "Effect":"Allow",
        "Principal":{
           "Service":"s3.amazonaws.com"
        },
        "Action":"SNS:Publish",
        "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
        "Condition":{
           "ArnLike":{
              "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
           }
        }
      }
   ]
 }

-- Example 23094
CREATE STAGE mystage
  URL = 's3://mybucket/load/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 23095
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = TRUE
  AWS_SNS_TOPIC='<sns_topic_arn>'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 23096
-- Create a role to contain the Snowpipe privileges
USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE snowpipe_role;

-- Grant the required privileges on the database objects
GRANT USAGE ON DATABASE snowpipe_db TO ROLE snowpipe_role;

GRANT USAGE ON SCHEMA snowpipe_db.public TO ROLE snowpipe_role;

GRANT INSERT, SELECT ON snowpipe_db.public.mytable TO ROLE snowpipe_role;

GRANT USAGE, READ ON STAGE snowpipe_db.public.mystage TO ROLE snowpipe_role;

-- Pause the pipe for OWNERSHIP transfer
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = TRUE;

-- Grant the OWNERSHIP privilege on the pipe object
GRANT OWNERSHIP ON PIPE snowpipe_db.public.mypipe TO ROLE snowpipe_role;

-- Grant the role to a user
GRANT ROLE snowpipe_role TO USER jsmith;

-- Set the role as the default role for the user
ALTER USER jsmith SET DEFAULT_ROLE = snowpipe_role;

-- Resume the pipe
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = FALSE;

-- Example 23097
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::<bucket>",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "<prefix>/*"
                    ]
                }
            }
        }
    ]
}

-- Example 23098
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  STORAGE_ALLOWED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('<protocol>://<bucket>/<path>/', '<protocol>://<bucket>/<path>/') ]

-- Example 23099
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket1/mypath1/sensitivedata/', 's3://mybucket2/mypath2/sensitivedata/');

-- Example 23100
DESC INTEGRATION <integration_name>;

-- Example 23101
DESC INTEGRATION s3_int;

-- Example 23102
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+
| property                  | property_type | property_value                                                                 | property_default |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------|
| ENABLED                   | Boolean       | true                                                                           | false            |
| STORAGE_ALLOWED_LOCATIONS | List          | s3://mybucket1/mypath1/,s3://mybucket2/mypath2/                                | []               |
| STORAGE_BLOCKED_LOCATIONS | List          | s3://mybucket1/mypath1/sensitivedata/,s3://mybucket2/mypath2/sensitivedata/    | []               |
| STORAGE_AWS_IAM_USER_ARN  | String        | arn:aws:iam::123456789001:user/abc1-b-self1234                                 |                  |
| STORAGE_AWS_ROLE_ARN      | String        | arn:aws:iam::001234567890:role/myrole                                          |                  |
| STORAGE_AWS_EXTERNAL_ID   | String        | MYACCOUNT_SFCRole=2_a123456/s0aBCDEfGHIJklmNoPq=                               |                  |
+---------------------------+---------------+--------------------------------------------------------------------------------+------------------+

-- Example 23103
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "<snowflake_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<snowflake_external_id>"
        }
      }
    }
  ]
}

-- Example 23104
USE SCHEMA snowpipe_db.public;

CREATE STAGE mystage
  URL = 's3://mybucket/load/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 23105
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = TRUE
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 23106
-- Create a role to contain the Snowpipe privileges
USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE snowpipe_role;

-- Grant the required privileges on the database objects
GRANT USAGE ON DATABASE snowpipe_db TO ROLE snowpipe_role;

GRANT USAGE ON SCHEMA snowpipe_db.public TO ROLE snowpipe_role;

GRANT INSERT, SELECT ON snowpipe_db.public.mytable TO ROLE snowpipe_role;

GRANT USAGE ON STAGE snowpipe_db.public.mystage TO ROLE snowpipe_role;

-- Pause the pipe for OWNERSHIP transfer
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = TRUE;

-- Grant the OWNERSHIP privilege on the pipe object
GRANT OWNERSHIP ON PIPE snowpipe_db.public.mypipe TO ROLE snowpipe_role;

-- Grant the role to a user
GRANT ROLE snowpipe_role TO USER jsmith;

-- Set the role as the default role for the user
ALTER USER jsmith SET DEFAULT_ROLE = snowpipe_role;

-- Resume the pipe
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = FALSE;

-- Example 23107
SHOW PIPES;

-- Example 23108
select system$get_aws_sns_iam_policy('<sns_topic_arn>');

-- Example 23109
select system$get_aws_sns_iam_policy('arn:aws:sns:us-west-2:001234567890:s3_mybucket');

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_AWS_SNS_IAM_POLICY('ARN:AWS:SNS:US-WEST-2:001234567890:S3_MYBUCKET')                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {"Version":"2012-10-17","Statement":[{"Sid":"1","Effect":"Allow","Principal":{"AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"},"Action":["sns:Subscribe"],"Resource":["arn:aws:sns:us-west-2:001234567890:s3_mybucket"]}]}                 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 23110
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     }
   ]
 }

-- Example 23111
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     }
   ]
 }

-- Example 23112
{
    "Sid":"s3-event-notifier",
    "Effect":"Allow",
    "Principal":{
       "Service":"s3.amazonaws.com"
    },
    "Action":"SNS:Publish",
    "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
    "Condition":{
       "ArnLike":{
          "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
       }
    }
 }

-- Example 23113
{
  "Version":"2008-10-17",
  "Id":"__default_policy_ID",
  "Statement":[
     {
        "Sid":"__default_statement_ID",
        "Effect":"Allow",
        "Principal":{
           "AWS":"*"
        }
        ..
     },
     {
        "Sid":"1",
        "Effect":"Allow",
        "Principal":{
          "AWS":"arn:aws:iam::123456789001:user/vj4g-a-abcd1234"
         },
         "Action":[
           "sns:Subscribe"
         ],
         "Resource":[
           "arn:aws:sns:us-west-2:001234567890:s3_mybucket"
         ]
     },
     {
        "Sid":"s3-event-notifier",
        "Effect":"Allow",
        "Principal":{
           "Service":"s3.amazonaws.com"
        },
        "Action":"SNS:Publish",
        "Resource":"arn:aws:sns:us-west-2:001234567890:s3_mybucket",
        "Condition":{
           "ArnLike":{
              "aws:SourceArn":"arn:aws:s3:*:*:s3_mybucket"
           }
        }
      }
   ]
 }

-- Example 23114
CREATE STAGE mystage
  URL = 's3://mybucket/load/files'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 23115
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = TRUE
  AWS_SNS_TOPIC='<sns_topic_arn>'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage
      FILE_FORMAT = (type = 'JSON');

-- Example 23116
-- Create a role to contain the Snowpipe privileges
USE ROLE SECURITYADMIN;

CREATE OR REPLACE ROLE snowpipe_role;

-- Grant the required privileges on the database objects
GRANT USAGE ON DATABASE snowpipe_db TO ROLE snowpipe_role;

GRANT USAGE ON SCHEMA snowpipe_db.public TO ROLE snowpipe_role;

GRANT INSERT, SELECT ON snowpipe_db.public.mytable TO ROLE snowpipe_role;

GRANT USAGE, READ ON STAGE snowpipe_db.public.mystage TO ROLE snowpipe_role;

-- Pause the pipe for OWNERSHIP transfer
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = TRUE;

-- Grant the OWNERSHIP privilege on the pipe object
GRANT OWNERSHIP ON PIPE snowpipe_db.public.mypipe TO ROLE snowpipe_role;

-- Grant the role to a user
GRANT ROLE snowpipe_role TO USER jsmith;

-- Set the role as the default role for the user
ALTER USER jsmith SET DEFAULT_ROLE = snowpipe_role;

-- Resume the pipe
ALTER PIPE mypipe SET PIPE_EXECUTION_PAUSED = FALSE;

-- Example 23117
CREATE OR REPLACE PROCEDURE <schema_name>.custom_event_billing()
 RETURNS NULL
 LANGUAGE JAVASCRIPT
 AS
 $$
   /**
    * Helper method to add a billable event
    * Format timestamps as Unix timestamps in milliseconds
    */

   function createBillingEvent(className, subclassName, startTimestampVal, timestampVal, baseCharge, objects, additionalInfo) {
        try {
            var res = snowflake.createStatement({
            sqlText: `SELECT SYSTEM$CREATE_BILLING_EVENT('${className}',
                                                      '${subclassName}',
                                                      ${startTimestampVal},
                                                      ${timestampVal},
                                                      ${baseCharge},
                                                      '${objects}',
                                                      '${additionalInfo}')`
            }).execute();

            res.next();

            return res.getColumnValue(1);
        } catch(err) {
            return err.message;
        }
    }
$$;

-- Example 23118
CREATE OR REPLACE PROCEDURE <app_provider_db_1><app_provider_schema_1>.external_proc_batch()
 RETURNS STRING
 LANGUAGE JAVASCRIPT
 EXECUTE AS OWNER
 AS
 $$
   function createBillingEventsBulk(events) {
     try {
       var res = snowflake.execute({
                    sqlText: `call SYSTEM$CREATE_BILLING_EVENTS('${events}')`
                 });
       res.next();
       return res.getColumnValueAsString(1);
     } catch (err) {
       return err.message;
     }
   }

   return createBillingEventsBulk(`
                                   [
                                     {
                                       "class": "class_1",
                                       "subclass": "subclass_1",
                                       "start_timestamp": ${Date.now()},
                                       "timestamp": ${Date.now()},
                                       "base_charge": 6.1,
                                       "objects": "obj1",
                                       "additional_info": "info1"
                                     },
                                     {
                                       "class": "class_2",
                                       "subclass": "subclass_2",
                                       "start_timestamp": ${Date.now()},
                                       "timestamp": ${Date.now()},
                                       "base_charge": 9.1,
                                       "objects": "obj2",
                                       "additional_info": "info2"
                                     }
                                   ]
                                 `);
$$;

-- Example 23119
...
  //
  // Send a billable event when a stored procedure is called.
  //
  var event_ts = Date.now();
  var billing_quantity = 1.0;
  var base_charge = billing_quantity;
  var objects = "[ \"db_1.public.procedure_1\" ]";
  var retVal = createBillingEvent("PROCEDURE_CALL", "", event_ts, event_ts, base_charge, objects, "");
  // Run the rest of the procedure ...
$$;

-- Example 23120
...
  // Run a query and get the number of rows in the result
  var select_query = "select i from db_1.public.t1";
  res = snowflake.execute ({sqlText: select_query});
  res.next();
  //
  // Send a billable event for rows returned from the select query
  //
  var event_ts = Date.now();
  var billing_quantity = 2.5;
  var base_charge = res.getRowcount() * billing_quantity;
  var objects = "[ \"db_1.public.t1\" ]";
  createBillingEvent("ROWS_CONSUMED", "", event_ts, event_ts, base_charge, objects, "");
  // Run the rest of the procedure ...
$$;

-- Example 23121
...
    // Run the merge query
    var merge_query = "MERGE INTO target_table USING source_table ON target_table.i = source_table.i
        WHEN MATCHED THEN UPDATE SET target_table.j = source_table.j
        WHEN NOT MATCHED
        THEN INSERT (i, j)
        VALUES (source_table.i, source_table.j)";
    res = snowflake.execute ({sqlText: merge_query});
    res.next();
    // rows ingested = rows inserted + rows updated
    var numRowsIngested = res.getColumnValue(1) + res.getColumnValue(2);

    //
    // Send a billable event for rows changed by the merge query
    //
    var event_ts = Date.now();
    var billing_quantity = 2.5;
    var base_charge = numRowsIngested * billing_quantity;
    var objects = "[ \"db_1.public.target_table\" ]";
    createBillingEvent("ROWS_CHANGED", "", event_ts, event_ts, base_charge, objects, "");
    // Run the rest of the procedure ...
$$;

-- Example 23122
...
    //
    // Get monthly active rows
    //
    var monthly_active_rows_query = "
     SELECT
         count(*)
     FROM
         source_table
     WHERE
         source_table.i not in
         (
           SELECT
             i
           FROM
             target_table
           WHERE
             updated_on >= DATE_TRUNC('MONTH', CURRENT_TIMESTAMP)
         )";
    res = snowflake.execute ({sqlText: monthly_active_rows_query});
    res.next();
    var monthlyActiveRows = parseInt(res.getColumnValue(1));
    //
    // Run the merge query and update the updated_on values for the rows
    //
    var merge_query = "
        MERGE INTO
            target_table
        USING
            source_table
        ON
            target_table.i = source_table.i
        WHEN MATCHED THEN
         UPDATE SET target_table.j = source_table.j
                    ,target_table.updated_on = current_timestamp
        WHEN NOT MATCHED THEN
            INSERT (i, j, updated_on) VALUES (source_table.i, source_table.j, current_timestamp)";
    res = snowflake.execute ({sqlText: merge_query});
    res.next();
    //
    // Emit a billable event for monthly active rows changed by the merge query
    //
    var event_ts = Date.now();
    var billing_quantity = 0.02
    var base_charge = monthlyActiveRows * billing_quantity;
    var objects = "[ \"db_1.public.target_table\" ]";
    createBillingEvent("MONTHLY_ACTIVE_ROWS", "", event_ts, event_ts, base_charge, objects, "");
    // Run the rest of the procedure ...
$$;

-- Example 23123
CREATE OR REPLACE PROCEDURE app_schema.billing_event_rows()
   RETURNS STRING
   LANGUAGE PYTHON
   RUNTIME_VERSION = '3.9'
   PACKAGES = ('snowflake-snowpark-python')
   HANDLER = 'run'
   EXECUTE AS OWNER
   AS $$
import time

# Helper method that calls the system function for billing
def createBillingEvent(session, class_name, subclass_name, start_timestamp, timestamp, base_charge, objects, additional_info):
   session.sql(f"SELECT SYSTEM$CREATE_BILLING_EVENT('{class_name}', '{subclass_name}', {start_timestamp}, {timestamp}, {base_charge}, '{objects}', '{additional_info}')").collect()
   return "Success"

# Handler function for the stored procedure
def run(session):
   # insert code to identify monthly active rows and calculate a charge
   try:

      # Run a query to select rows from a table
      query =  "select i from db_1.public.t1"
      res = session.sql(query).collect()

      # Define the price to charge per row
      billing_quantity = 2.5

      # Calculate the base charge based on number of rows in the result
      charge = len(res) * billing_quantity

      # Current time in Unix timestamp (epoch) time in milliseconds
      current_time_epoch = int(time.time() * 1000)

      return createBillingEvent(session, 'ROWS_CONSUMED', '', current_time_epoch, current_time_epoch, charge, '["billing_event_rows"]', '')
   except Exception as ex:
      return "Error " + ex
$$;

-- Example 23124
CALL merge_procedure()

-- Example 23125
SELECT listing_global_name,
   listing_display_name,
   charge_type,
   charge
FROM SNOWFLAKE.DATA_SHARING_USAGE.MARKETPLACE_PAID_USAGE_DAILY
WHERE charge_type='MONETIZABLE_BILLING_EVENTS'
      AND PROVIDER_ACCOUNT_NAME = <account_name>
      AND PROVIDER_ORGANIZATION_NAME= <organization_name>;

-- Example 23126
+---------------------+------------------------+----------------------------+--------+
| LISTING_GLOBAL_NAME |  LISTING_DISPLAY_NAME  |        CHARGE_TYPE         | CHARGE |
+---------------------+------------------------+----------------------------+--------+
| AAAA0BBB1CC         | Snowy Mountain Listing | MONETIZABLE_BILLING_EVENTS |   18.6 |
+---------------------+------------------------+----------------------------+--------+

-- Example 23127
ALTER TABLE [ IF EXISTS ] <name> RENAME TO <new_table_name>

ALTER TABLE [ IF EXISTS ] <name> clusteringAction

ALTER TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER TABLE [ IF EXISTS ] <name> SET
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE  } ]
  [ COMMENT = '<string_literal>' ]

ALTER TABLE [ IF EXISTS ] <name> UNSET {
                                       DATA_RETENTION_TIME_IN_DAYS         |
                                       MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                       CHANGE_TRACKING                     |
                                       COMMENT                             |
                                       }

-- Example 23128
clusteringAction ::=
  {
     CLUSTER BY ( <expr> [ , <expr> , ... ] )
   | { SUSPEND | RESUME } RECLUSTER
   | DROP CLUSTERING KEY
  }

-- Example 23129
dataGovnPolicyTagAction ::=
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }

-- Example 23130
searchOptimizationAction ::=
  {
     ADD SEARCH OPTIMIZATION [
       ON <search_method_with_target> [ , <search_method_with_target> ... ]
     ]

   | DROP SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]

  }

-- Example 23131
<search_method>(<target> [, ...])

-- Example 23132
-- Allowed
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 23133
-- Not allowed
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 23134
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 23135
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 23136
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 23137
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 23138
CREATE OR REPLACE TABLE t1(a1 number);

SHOW TABLES LIKE 't1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
 Tue, 17 Mar 2015 16:52:33 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         |            | 0    | 0     | PUBLIC | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+

ALTER TABLE t1 RENAME TO tt1;

SHOW TABLES LIKE 'tt1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+
 Tue, 17 Mar 2015 16:52:33 -0700 | TT1  | TESTDB        | MY_SCHEMA   | TABLE |         |            | 0    | 0     | PUBLIC | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+

-- Example 23139
CREATE OR REPLACE TABLE T1 (id NUMBER, date TIMESTAMP_NTZ, name STRING) CLUSTER BY (id, date);

SHOW TABLES LIKE 'T1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (ID,DATE)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Change the order of the clustering key
ALTER TABLE t1 CLUSTER BY (date, id);

SHOW TABLES LIKE 'T1';

---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (DATE,ID)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Example 23140
ALTER TABLE t1
  ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- Example 23141
ALTER TABLE t1
  ADD ROW ACCESS POLICY rap_test2 ON (cost, item);

-- Example 23142
ALTER TABLE t1
  DROP ROW ACCESS POLICY rap_v1;

-- Example 23143
alter table t1
  drop row access policy rap_t1_version_1,
  add row access policy rap_t1_version_2 on (empl_id);

-- Example 23144
CREATE SECURITY INTEGRATION my_idp
  TYPE = saml2
  ENABLED = true
  SAML2_ISSUER = 'https://example.com'
  SAML2_SSO_URL = 'http://myssoprovider.com'
  SAML2_PROVIDER = 'ADFS'
  SAML2_X509_CERT = 'MIICr...'
  SAML2_SNOWFLAKE_ISSUER_URL = 'https://<orgname>-<account_name>.privatelink.snowflakecomputing.com'
  SAML2_SNOWFLAKE_ACS_URL = 'https://<orgname>-<account_name>.privatelink.snowflakecomputing.com/fed/login';

-- Example 23145
ALTER SECURITY INTEGRATION my_idp SET SAML2_ENABLE_SP_INITIATED = true;
ALTER SECURITY INTEGRATION my_idp SET SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'My IdP';

-- Example 23146
DESC SECURITY INTEGRATION my_idp;

-- Example 23147
-----BEGIN CERTIFICATE-----
MIICr...
-----END CERTIFICATE-----

-- Example 23148
ALTER SECURITY INTEGRATION my_idp SET SAML2_SNOWFLAKE_X509_CERT = 'AX2bv...';

-- Example 23149
DESC SECURITY INTEGRATION my_idp;

-- Example 23150
ALTER SECURITY INTEGRATION my_idp SET SAML2_SIGN_REQUEST = true;

-- Example 23151
DESC SECURITY INTEGRATION my_idp;

-- Example 23152
DESC SECURITY INTEGRATION my_idp;

-- Example 23153
ALTER SECURITY INTEGRATION my_idp SET SAML2_REQUESTED_NAMEID_FORMAT = '<string_literal>';

-- Example 23154
DESC SECURITY INTEGRATION my_idp;

-- Example 23155
DESC SECURITY INTEGRATION my_idp;

-- Example 23156
------------------------------------+---------------+-----------------------------------------------------------------------------+------------------+
              property              | property_type |                               property_value                                | property_default |
------------------------------------+---------------+-----------------------------------------------------------------------------+------------------+
SAML2_X509_CERT                     | String        | MIICr...                                                                    |                  |
SAML2_PROVIDER                      | String        | OKTA                                                                        |                  |
SAML2_ENABLE_SP_INITIATED           | Boolean       | false                                                                       | false            |
SAML2_SP_INITIATED_LOGIN_PAGE_LABEL | String        | my_idp                                                                      |                  |
SAML2_SSO_URL                       | String        | https://okta.com/sso                                                        |                  |
SAML2_ISSUER                        | String        | https://okta.com                                                            |                  |
SAML2_SNOWFLAKE_X509_CERT           | String        | MIICr...                                                                    |                  |
SAML2_REQUESTED_NAMEID_FORMAT       | String        | urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress                      |                  |
SAML2_SNOWFLAKE_ACS_URL             | String        | https://example.snowflakecomputing.com/fed/login                            |                  |
SAML2_SNOWFLAKE_ISSUER_URL          | String        | https://example.snowflakecomputing.com                                      |                  |
SAML2_SNOWFLAKE_METADATA            | String        | <md:EntityDescriptor entityID="https://example.snowflakecomputing.com"> ... |                  |
SAML2_DIGEST_METHODS_USED           | String        | http://www.w3.org/2001/04/xmlenc#sha256                                     |                  |
SAML2_SIGNATURE_METHODS_USED        | String        | http://www.w3.org/2001/04/xmldsig-more#rsa-sha256                           |                  |
------------------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 23157
<md:EntityDescriptor xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:xenc="http://www.w3.org/2001/04/xmlenc#" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" entityID="https://example.snowflakecomputing.com">
 <md:SPSSODescriptor AuthnRequestsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
  <md:KeyDescriptor use="signing">
    <dsig:KeyInfo>
      <dsig:X509Data>
        <dsig:X509Certificate>MIICr...</dsig:X509Certificate>
      </dsig:X509Data>
    </dsig:KeyInfo>
  </md:KeyDescriptor>
  <md:KeyDescriptor use="encryption">
    <dsig:KeyInfo>
      <dsig:X509Data>
        <dsig:X509Certificate>MIICr...</dsig:X509Certificate>
      </dsig:X509Data>
    </dsig:KeyInfo>
  </md:KeyDescriptor>
  <md:AssertionConsumerService index="0" isDefault="true" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://example.snowflakecomputing.com/fed/login" />
 </md:SPSSODescriptor>
</md:EntityDescriptor>

-- Example 23158
ALTER SECURITY INTEGRATION my_idp SET SAML2_FORCE_AUTHN = true;

-- Example 23159
DESC SECURITY INTEGRATION my_idp;

