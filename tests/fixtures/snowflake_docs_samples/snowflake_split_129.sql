-- Example 8624
az account get-access-token --subscription <subscription_id>

-- Example 8625
aws sts get-federation-token --name snowflake --policy
'{ "Version": "2012-10-17", "Statement":
  [ {
  "Effect": "Allow", "Action": ["ec2:DescribeVpcEndpoints"],
  "Resource": ["*"] }
  ] }'

-- Example 8626
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  'vpce-0c1...',
  '123.....',
  '{
    "Credentials": {
      "AccessKeyId": "ASI...",
      "SecretAccessKey": "alD...",
      "SessionToken": "IQo...",
      "Expiration": "2024-12-10T08:20:20+00:00"
    },
    "FederatedUser": {
      "FederatedUserId": "0123...:snowflake",
      "Arn": "arn:aws:sts::174...:federated-user/snowflake"
    },
    "PackedPolicySize": 9,
    }',
  120
  );

-- Example 8627
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  '123....',
  '/subscriptions/0cc51670-.../resourceGroups/dbsec_test_rg/providers/Microsoft.Network/
  privateEndpoints/...',
  'eyJ...',
  120
);

-- Example 8628
Resource Monitor MY_ACCOUNT_MONITOR has reached 50% of its MONTHLY
quota of 500 credits which has triggered a <action> action.

-- Example 8629
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
  TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 8630
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
  TRIGGERS ON 90 PERCENT DO SUSPEND
           ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 8631
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
   TRIGGERS ON 50 PERCENT DO NOTIFY
            ON 75 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND
            ON 110 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 8632
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 8633
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=2000
    FREQUENCY = WEEKLY
    START_TIMESTAMP = '2019-03-04 00:00 PST'
    TRIGGERS ON 80 PERCENT DO SUSPEND
             ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

ALTER WAREHOUSE wh2 SET RESOURCE_MONITOR = limit1;

-- Example 8634
ALTER RESOURCE MONITOR limit1 SET CREDIT_QUOTA=3000;

-- Example 8635
SHOW WAREHOUSES;

-- Example 8636
+--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------+
| name   | state     | type     | size    | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment | resource_monitor | actives | pendings | failed | suspended | uuid       | budget | owner_role_type |
|--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------|
| MY_WH1 | STARTED   | STANDARD | X-Small |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2024-01-17 14:37:36.223 -0800 | 2024-01-17 14:37:36.325 -0800 | 2024-01-17 14:47:49.854 -0800 | MY_ROLE      |         | null             |       0 |        0 |      0 |         1 | 1222706972 | NULL   | ROLE            |
| MY_WH2 | SUSPENDED | STANDARD | X-Small |       0 |      0 | N          | Y          |          600 | true        |           |              |           |       | 2023-12-20 13:50:50.972 -0800 | 2024-01-17 14:28:39.170 -0800 | 2024-01-17 14:37:57.560 -0800 | ACCOUNTADMIN |         | MY_RM            |       0 |        0 |      0 |         1 | 1222706948 | NULL   | ROLE            |
| MY_WH3 | SUSPENDED | STANDARD | Small   |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2024-01-17 14:26:26.911 -0800 | 2024-01-17 14:33:39.260 -0800 | 2024-01-17 14:38:31.192 -0800 | ACCOUNTADMIN |         | MY_RM            |       0 |        0 |      0 |         2 | 1222706960 | NULL   | ROLE            |
+--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------+

-- Example 8637
ALTER WAREHOUSE my_wh2 UNSET RESOURCE_MONITOR;

ALTER WAREHOUSE my_wh3 UNSET RESOURCE_MONITOR;

-- Example 8638
ALTER ACCOUNT my_account SET RESOURCE_MONITOR = my_rm;

-- Example 8639
ALTER RESOURCE MONITOR my_warehouse_rm
  SET NOTIFY_USERS = (USER1, USER2);

-- Example 8640
USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR my_account_rm WITH CREDIT_QUOTA=10000
  TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER ACCOUNT SET RESOURCE_MONITOR = my_account_rm;

-- Example 8641
ALTER WAREHOUSE my_wh SET RESOURCE_MONITOR = my_rm;

-- Example 8642
select system$get_snowflake_platform_info();

-- Example 8643
{
  "snowflake-vpc-id": ["vpc-12345678"],
  "snowflake-egress-vpc-ids": [
    ...
   {
     "id": "vpc-12345678",
     "expires": "2025-03-01T00:00:00",
     "purpose": "generic"
   },
   ...
   ]
 }

-- Example 8644
===========================================================================
================ Tracking Worksheet: AWS Management Console ===============
===========================================================================

****** Step 1: Information about the Lambda Function (remote service) *****

Your AWS Account ID: ______________________________________________________

Lambda Function Name: _____________________________________________________


******** Step 2: Information about the API Gateway (proxy Service) ********

New IAM Role Name: ________________________________________________________

New IAM Role ARN: _________________________________________________________

Snowflake VPC ID (optional): ______________________________________________

New API Name: _____________________________________________________________

API Gateway Resource Name: ________________________________________________

Resource Invocation URL: __________________________________________________

Method Request ARN: _______________________________________________________


*** Step 3: Information about the API Integration and External Function ***

API Integration Name: _____________________________________________________

API_AWS_IAM_USER_ARN: _____________________________________________________

API_AWS_EXTERNAL_ID: ______________________________________________________

External Function Name: ___________________________________________________

-- Example 8645
===========================================================================
================== Tracking Worksheet: CloudFormation Template ============
===========================================================================

New IAM Role Name: ________________________________________________________

New IAM Role ARN: _________________________________________________________

Resource Invocation URL: __________________________________________________

API_AWS_IAM_USER_ARN: _____________________________________________________

API_AWS_EXTERNAL_ID: ______________________________________________________

-- Example 8646
SELECT ...
    FROM my_table INNER JOIN my_materialized_view
        ON my_materialized_view.col1 = my_table.col1
    ...

-- Example 8647
CREATE TABLE <name> ... CLUSTER BY ( <expr1> [ , <expr2> ... ] )

-- Example 8648
-- cluster by base columns
CREATE OR REPLACE TABLE t1 (c1 DATE, c2 STRING, c3 NUMBER) CLUSTER BY (c1, c2);

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(C1, C2) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+

-- cluster by expressions
CREATE OR REPLACE TABLE t2 (c1 timestamp, c2 STRING, c3 NUMBER) CLUSTER BY (TO_DATE(C1), substring(c2, 0, 10));

SHOW TABLES LIKE 't2';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:07:51.307 -0700 | T2   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(CAST(C1 AS DATE), SUBSTRING(C2, 0, 10)) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+

-- cluster by paths in variant columns
CREATE OR REPLACE TABLE T3 (t timestamp, v variant) cluster by (v:"Data":id::number);

SHOW TABLES LIKE 'T3';

+-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 16:30:11.330 -0700 | T3   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(TO_NUMBER(GET_PATH(V, 'Data.id'))) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+-------------------------------------------+------+-------+----------+----------------+----------------------+

-- Example 8649
create or replace table t3 (vc varchar) cluster by (SUBSTRING(vc, 5, 5));

-- Example 8650
ALTER TABLE <name> CLUSTER BY ( <expr1> [ , <expr2> ... ] )

-- Example 8651
-- cluster by base columns
ALTER TABLE t1 CLUSTER BY (c1, c3);

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(C1, C3) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+----------------+------+-------+----------+----------------+----------------------+

-- cluster by expressions
ALTER TABLE T2 CLUSTER BY (SUBSTRING(C2, 5, 15), TO_DATE(C1));

SHOW TABLES LIKE 't2';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                     | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:07:51.307 -0700 | T2   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(SUBSTRING(C2, 5, 15), CAST(C1 AS DATE)) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------+------+-------+----------+----------------+----------------------+

-- cluster by paths in variant columns
ALTER TABLE T3 CLUSTER BY (v:"Data":name::string, v:"Data":id::number);

SHOW TABLES LIKE 'T3';

+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by                                                                   | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 16:30:11.330 -0700 | T3   | TESTDB        | PUBLIC      | TABLE |         | LINEAR(TO_CHAR(GET_PATH(V, 'Data.name')), TO_NUMBER(GET_PATH(V, 'Data.id'))) |    0 |     0 | SYSADMIN | 1              | ON                   |
+-------------------------------+------+---------------+-------------+-------+---------+------------------------------------------------------------------------------+------+-------+----------+----------------+----------------------+

-- Example 8652
ALTER TABLE <name> DROP CLUSTERING KEY

-- Example 8653
ALTER TABLE t1 DROP CLUSTERING KEY;

SHOW TABLES LIKE 't1';

+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner    | retention_time | automatic_clustering |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------|
| 2019-06-20 12:06:07.517 -0700 | T1   | TESTDB        | PUBLIC      | TABLE |         |            |    0 |     0 | SYSADMIN | 1              | OFF                  |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 8654
-- Create table t1 in schema d1.s1, with the column definitions derived from the staged file1.parquet file.
USE SCHEMA d1.s1;

CREATE OR REPLACE TABLE t1
  USING TEMPLATE (
    SELECT ARRAY_AGG(object_construct(*))
      FROM TABLE(
        INFER_SCHEMA(
          LOCATION=>'@mystage/file1.parquet',
          FILE_FORMAT=>'my_parquet_format'
        )
      ));

-- Row data in file1.parquet.
+------+------+------+
| COL1 | COL2 | COL3 |
|------+------+------|
| a    | b    | c    |
+------+------+------+

-- Describe the table.
-- Note that column c2 is required in the Parquet file metadata. Therefore, the NOT NULL constraint is set for the column.
DESCRIBE TABLE t1;
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| COL1 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL2 | VARCHAR(16777216) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Use the SECURITYADMIN role or another role that has the global MANAGE GRANTS privilege.
-- Grant the EVOLVE SCHEMA privilege to any other roles that could insert data and evolve table schema in addition to the table owner.

GRANT EVOLVE SCHEMA ON TABLE d1.s1.t1 TO ROLE r1;

-- Enable schema evolution on the table.
-- Note that the ENABLE_SCHEMA_EVOLUTION property can also be set at table creation with CREATE OR REPLACE TABLE
ALTER TABLE t1 SET ENABLE_SCHEMA_EVOLUTION = TRUE;

-- Load a new set of data into the table.
-- The new data drops the NOT NULL constraint on the col2 column.
-- The new data adds the new column col4.
COPY INTO t1
  FROM @mystage/file2.parquet
  FILE_FORMAT = (type=parquet)
  MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;

-- Row data in file2.parquet.
+------+------+------+
| col1 | COL3 | COL4 |
|------+------+------|
| d    | e    | f    |
+------+------+------+

-- Describe the table.
DESCRIBE TABLE t1;
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name | schema evolution record                                                                                                                                                                  |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| COL1 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL                                                                                                                                                                                     |
| COL2 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | {"evolutionType":"DROP_NOT_NULL","evolutionMode":"COPY","fileName":"file2.parquet","triggeringTime":"2024-03-15 23:52:59.514000000Z","queryId":"01b303b8-0808-c9ed-0000-0971491b5932"}   |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | NULL                                                                                                                                                                                     |
| COL4 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        | {"evolutionType":"ADD_COLUMN","evolutionMode":"COPY","fileName":"file2.parquet","triggeringTime":"2024-03-15 23:52:59.514000000Z","queryId":"01b303b8-0808-c9ed-0000-0971491b5932"}      |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- Note that since MATCH_BY_COLUMN_NAME is set as CASE_INSENSITIVE, all column names are retrieved as uppercase letters.

-- Example 8655
[{"type":"STAGE","host":"<storage_location>.s3.<region_id>.amazonaws.com","port":443},
{"type":"STAGE","host":"<storage_location>.s3-<region_id>.amazonaws.com","port":443},
{"type":"STAGE","host":"<storage_location>.s3.amazonaws.com","port":443},
{"type":"SNOWSQL_REPO","host":"<repository_name_1>.s3.<region_id>.amazonaws.com","port":443},
{"type":"SNOWSQL_REPO","host":"<repository_name_2>.snowflakecomputing.com","port":443},
{"type":"OUT_OF_BAND_TELEMETRY","host":"<telemetry_subdomain>.snowflakecomputing.com","port":443},
{"type":"OCSP_CACHE","host":"ocsp.snowflakecomputing.com","port":80},
{"type":"OCSP_RESPONDER","host":"ocsp.digicert.com","port":80}]

-- Example 8656
[{
  "type": "STAGE",
  "host": "<storage_location>.s3.<region_id>.amazonaws.com",
  "port": 443
}, {
  "type": "STAGE",
  "host": "<storage_location>.s3-<region_id>.amazonaws.com",
  "port": 443
}, {
  "type": "STAGE",
  "host": "<storage_location>.s3.amazonaws.com",
  "port": 443
}, {
  "type": "SNOWSQL_REPO",
  "host": "<repository_name_1>.s3.<region_id>.amazonaws.com",
  "port": 443
}, {
  "type": "SNOWSQL_REPO",
  "host": "<repository_name_2>.snowflakecomputing.com",
  "port": 443
}, {
  "type": "OUT_OF_BAND_TELEMETRY",
  "host": "<telemetry_subdomain>.snowflakecomputing.com",
  "port": 443
}, {
  "type": "OCSP_CACHE",
  "host": "ocsp.snowflakecomputing.com",
  "port": 80
}, {
  "type": "OCSP_RESPONDER",
  "host": "ocsp.digicert.com",
  "port": 80
}]

-- Example 8657
[{"type":"SNOWFLAKE_DEPLOYMENT","host":"<storage_location>.<region>.privatelink.snowflakecomputing.com","port":443},
{"type":"STAGE","host":"<storage_location>.<region>.amazonaws.com","port":443},
{"type":"STAGE","host":"<storage_location>-<region>.amazonaws.com","port":443},
{"type":"STAGE","host":"<storage_location>.amazonaws.com","port":443},
{"type":"SNOWSQL_REPO","host":"<repository_name_1>.s3.<region>.amazonaws.com","port":443},
{"type":"SNOWSQL_REPO","host":"<repository_name_2>.snowflakecomputing.com","port":443},
{"type":"OUT_OF_BAND_TELEMETRY","host":"<telemetry_subdomain>.snowflakecomputing.com","port":443},
{"type":"OCSP_CACHE","host":"ocsp.<storage_location>.<region>.privatelink.snowflakecomputing.com","port":80}]

-- Example 8658
[{
  "type": "SNOWFLAKE_DEPLOYMENT",
  "host": "<storage_location>.<region>.privatelink.snowflakecomputing.com",
  "port": 443
}, {
  "type": "STAGE",
  "host": "<storage_location>.<region>.amazonaws.com",
  "port": 443
}, {
  "type": "STAGE",
  "host": "<storage_location>-<region>.amazonaws.com",
  "port": 443
}, {
  "type": "STAGE",
  "host": "<storage_location>.amazonaws.com",
  "port": 443
}, {
  "type": "SNOWSQL_REPO",
  "host": "<repository_name_1>.s3.<region>.amazonaws.com",
  "port": 443
}, {
  "type": "SNOWSQL_REPO",
  "host": "<repository_name_2>.snowflakecomputing.com",
  "port": 443
}, {
  "type": "OUT_OF_BAND_TELEMETRY",
  "host": "<telemetry_subdomain>.snowflakecomputing.com",
  "port": 443
}, {
  "type": "OCSP_CACHE",
  "host": "ocsp.<storage_location>.<region>.privatelink.snowflakecomputing.com",
  "port": 80
}]

-- Example 8659
use warehouse my_warehouse;
select value:type as type,
       value:host as host,
       value:port as port
   from table(flatten(input => parse_json(system$allowlist())));

-- Example 8660
$ sha256sum <filename>

-- Example 8661
$ gunzip <filename>

-- Example 8662
$ chmod +x <filename>

-- Example 8663
$ mv <filename> snowcd

-- Example 8664
$ shasum -a 256 <filename>

-- Example 8665
Performing 30 checks on 12 hosts
All checks passed

-- Example 8666
Error: please provide whitelist generated by SYSTEM$ALLOWLIST()
Usage:
./snowcd <path to input json file> [flags]

Examples:
./snowcd test.json

Flags:
  -h, --help                   help for ./snowcd
  --logLevel string            log level (panic, fatal[default], error, warning, info, debug, trace) (default "fatal")
  --logPath string             Output directory for log. When not specified, no log is generated
  --proxyHost string           host for http proxy. (When not specified, does not use proxy at all)
  --proxyIsHTTPS               Is connection to proxy secure, i.e. https. (default false)
  --proxyPassword string       password for http proxy.(default empty)
  --proxyPort int              port for http proxy.(default 8080) (default 8080)
  --proxyUser string           user name for http proxy.(default empty)
  -t, --timeout int            timeout for each hostname's checks in seconds (default 5) (default 5)
  --version                    version for ./snowcd

-- Example 8667
Check for 1 hosts failed, display as follow:
==============================================
Host: www.google1.com
Port: 443
Type: SNOWFLAKE_DEPLOYMENT
Failed Check: DNS Check
Error: lookup www.google1.com: no such host
Suggestion: Check your configuration on DNS server

-- Example 8668
snowcd allowlist.json \
  --proxyHost <hostname> \
  --proxyPort <port_number> \
  --proxyUser <username> \
  --proxyPassword <password>

-- Example 8669
snowcd allowlist.json \
  --proxyHost <hostname> \
  --proxyPort <port_number> \
  --proxyUser <username> \
  --proxyPassword <password> \
  --logLevel trace \
  --logPath test.log

-- Example 8670
SHOW FAILOVER GROUPS;

-- Example 8671
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 8672
Replication group "<GROUP_NAME>" cannot currently be set as primary because it is being
refreshed. Either wait for the refresh to finish or cancel the refresh and try again.

-- Example 8673
ALTER FAILOVER GROUP myfg SUSPEND;

-- Example 8674
ALTER FAILOVER GROUP myfg SUSPEND IMMEDIATE;

-- Example 8675
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name <> 'COMPLETED' and phase_name <> 'CANCELED';

-- Example 8676
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name = 'CANCELED';

-- Example 8677
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 8678
ALTER FAILOVER GROUP myfg RESUME;

-- Example 8679
SELECT phase_name, start_time, end_time
  FROM TABLE(
    INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('myfg')
  );

-- Example 8680
SELECT query_id, query_text
  FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
  WHERE query_type = 'REFRESH REPLICATION GROUP'
  AND execution_status = 'RUNNING'
  ORDER BY start_time;

-- Example 8681
SELECT phase_name, start_time, job_uuid
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_HISTORY('myfg'))
  WHERE phase_name <> 'COMPLETED' and phase_name <> 'CANCELED';

-- Example 8682
SELECT SYSTEM$CANCEL_QUERY('<QUERY_ID | JOB_UUID>');

-- Example 8683
query [<QUERY_ID>] terminated.

-- Example 8684
USE ROLE ACCOUNTADMIN;

ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST_MODEL_AZURE_OPENAI = TRUE;

-- Example 8685
SHOW PARAMETERS LIKE 'ENABLE_CORTEX_ANALYST_MODEL_AZURE_OPENAI' IN ACCOUNT

-- Example 8686
{
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What is the month over month revenue growth for 2021 in Asia?"
                }
            ]
        },
        {
            "role": "analyst",
            "content": [
                {
                    "type": "text",
                    "text": "We interpreted your question as ..."
                },
                {
                    "type": "sql",
                    "statement": "SELECT * FROM table"
                }
            ]
        },
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What about North America?"
                }
            ]
        },
    ],
    "semantic_model_file": "@my_stage/my_semantic_model.yaml"
}

-- Example 8687
CREATE DATABASE semantic_model;
CREATE SCHEMA semantic_model.definitions;
GRANT USAGE ON DATABASE semantic_model TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA semantic_model.definitions TO ROLE PUBLIC;

USE SCHEMA semantic_model.definitions;

-- Example 8688
CREATE STAGE public DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE public TO ROLE PUBLIC;

CREATE STAGE sales DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE sales TO ROLE sales_analyst;

-- Example 8689
snow stage copy file:///path/to/local/file.yaml @sales

-- Example 8690
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = FALSE;

