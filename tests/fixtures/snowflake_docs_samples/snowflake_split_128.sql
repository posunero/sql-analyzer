-- Example 8557
ALTER ACCOUNT <account_name> SET IS_ORG_ADMIN = FALSE;

-- Example 8558
SHOW REGIONS [ LIKE '<pattern>' ]

-- Example 8559
*.duosecurity.com:443

-- Example 8560
ALTER ACCOUNT SET ALLOW_CLIENT_MFA_CACHING = TRUE;

-- Example 8561
pip install "snowflake-connector-python[secure-local-storage]"

-- Example 8562
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 8563
ALTER ACCOUNT UNSET ALLOW_CLIENT_MFA_CACHING;

-- Example 8564
SELECT EVENT_TIMESTAMP,
       USER_NAME,
       IS_SUCCESS
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
  WHERE SECOND_AUTHENTICATION_FACTOR = 'MFA_TOKEN';

-- Example 8565
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=demo&passcode=123456

-- Example 8566
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=demo&passcodeInPassword=on

-- Example 8567
authenticator: 'USERNAME_PASSWORD_MFA',
password: "abc123987654", // passcode 987654 is part of the password
passcodeInPassword: true  // because passcodeInPassword is true

-- Example 8568
authenticator: 'USERNAME_PASSWORD_MFA',
password: "abc123", // password and MFA passcode are input separately
passcode: "987654"

-- Example 8569
CREATE SCHEMA S1;
USE SCHEMA S1;
CREATE TASK T1 AS SELECT 1;
CREATE SCHEMA S2 CLONE S1 AT(TIMESTAMP => '2025-04-01 12:00:00');
  -- T1 is not cloned into S2
CREATE SCHEMA S3 CLONE S1;
  -- T1 is cloned into S3

-- Example 8570
SHOW TABLES;
-- ... output omitted ...
SELECT "name", "retention_time" FROM TABLE(RESULT_SCAN(-1))
  WHERE "name" IN ('my_table1', 'my_table2');

-- Example 8571
SHOW SCHEMAS;
-- ... output omitted ...
SELECT "name", "retention_time" FROM TABLE(RESULT_SCAN(-1))
  WHERE "retention_time" = 0;

-- Example 8572
SHOW DATABASES HISTORY;
-- ... output omitted ...
SELECT "name", "retention_time", "dropped_on" FROM TABLE(RESULT_SCAN(-1))
  WHERE "retention_time" > 1;

-- Example 8573
CREATE TABLE mytable(col1 NUMBER, col2 DATE) DATA_RETENTION_TIME_IN_DAYS=90;

ALTER TABLE mytable SET DATA_RETENTION_TIME_IN_DAYS=30;

-- Example 8574
SELECT * FROM my_table AT(TIMESTAMP => 'Wed, 26 Jun 2024 09:20:00 -0700'::timestamp_tz);

-- Example 8575
SELECT * FROM my_table AT(OFFSET => -60*5);

-- Example 8576
SELECT * FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 8577
CREATE TABLE restored_table CLONE my_table
  AT(TIMESTAMP => 'Wed, 26 Jun 2024 01:01:00 +0300'::timestamp_tz);

-- Example 8578
CREATE SCHEMA restored_schema CLONE my_schema AT(OFFSET => -3600);

-- Example 8579
CREATE DATABASE restored_db CLONE my_db
  BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 8580
CREATE DATABASE restored_db CLONE my_db
  AT(TIMESTAMP => DATEADD(days, -4, current_timestamp)::timestamp_tz)
  IGNORE TABLES WITH INSUFFICIENT DATA RETENTION;

-- Example 8581
SHOW TABLES HISTORY LIKE 'load%' IN mytestdb.myschema;

SHOW SCHEMAS HISTORY IN mytestdb;

SHOW DATABASES HISTORY;

-- Example 8582
UNDROP TABLE mytable;

UNDROP SCHEMA myschema;

UNDROP DATABASE mydatabase;

UNDROP NOTEBOOK mynotebook;

-- Example 8583
SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

DROP TABLE loaddata1;

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

CREATE TABLE loaddata1 (c1 number);
INSERT INTO loaddata1 VALUES (1111), (2222), (3333), (4444);

DROP TABLE loaddata1;

CREATE TABLE loaddata1 (c1 varchar);

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | Fri, 13 May 2016 19:05:51 -0700 |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

ALTER TABLE loaddata1 RENAME TO loaddata3;

UNDROP TABLE loaddata1;

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA3 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

ALTER TABLE loaddata1 RENAME TO loaddata2;

UNDROP TABLE loaddata1;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA2 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA3 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

-- Example 8584
ALTER ACCOUNT SET ENABLE_TRI_SECRET_AND_REKEY_OPT_OUT_FOR_IMAGE_REPOSITORY=True;

ALTER ACCOUNT SET PERIODIC_DATA_REKEYING = true;

-- Example 8585
CREATE OR REPLACE ROW ACCESS POLICY rap_it
AS (empl_id varchar) RETURNS BOOLEAN ->
  'it_admin' = current_role()
;

-- Example 8586
SELECT *
FROM TABLE(
  mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME=>'mydb.policies.rap1'
  )
);

-- Example 8587
SELECT *
FROM TABLE(
  mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(
    REF_ENTITY_NAME => 'mydb.tables.t1',
    REF_ENTITY_DOMAIN => 'table'
  )
);

-- Example 8588
-- table
CREATE TABLE sales (
  customer   varchar,
  product    varchar,
  spend      decimal(20, 2),
  sale_date  date,
  region     varchar
)
WITH ROW ACCESS POLICY sales_policy ON (region);

-- view
CREATE VIEW sales_v WITH ROW ACCESS POLICY sales_policy ON (region)
AS SELECT * FROM sales;

-- Example 8589
-- table

ALTER TABLE t1 ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- view

ALTER VIEW v1 ADD ROW ACCESS POLICY rap_v1 ON (empl_id);

-- Example 8590
EXPLAIN SELECT * FROM my_table;

-- Example 8591
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+
|  step |   id   | parent |     operation     |           objects              | alias  | expressions | partitionsTotal | partitionsAssigned | bytesAssigned |
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+
...

| 1     | 2      | 1      | DynamicSecureView | "MY_TABLE (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
+-------+--------+--------+-------------------+--------------------------------+--------+-------------+-----------------+--------------------+---------------+

-- Example 8592
EXPLAIN SELECT product FROM sales
  WHERE revenue > (SELECT AVG(revenue) FROM sales)
  ORDER BY product;

-- Example 8593
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+
|  step  |   id   | parent |     operation     |           objects           | alias  | expressions | partitionsTotal | partitionsAssigned | bytesAssigned |
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+
...
| 1      | 0      | [NULL] | DynamicSecureView | "SALES (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
...
| 2      | 2      | 1      | DynamicSecureView | "SALES (+ RowAccessPolicy)" | [NULL] | [NULL]      | [NULL]          | [NULL]             | [NULL]        |
+--------+--------+--------+-------------------+-----------------------------+--------+-------------+-----------------+--------------------+---------------+

-- Example 8594
use role securityadmin;
grant create row access policy on schema <db_name.schema_name> to role rap_admin;
grant apply row access policy on account to role rap_admin;

-- Example 8595
use role securityadmin;
grant create row access policy on schema <db_name.schema_name> to role rap_admin;
grant apply on row access policy rap_finance to role finance_role;

-- Example 8596
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.ROW_ACCESS_POLICIES
ORDER BY POLICY_NAME;

-- Example 8597
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
ORDER BY POLICY_NAME, REF_COLUMN_NAME;

-- Example 8598
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'rap_t1'
  )
);

-- Example 8599
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 8600
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| created_on                    | privilege | granted_on    | name                        | granted_to | grantee_name    | grant_option | granted_by |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|
| 2024-01-24 17:12:26.984 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.GOVERNANCE_VIEWER | ROLE       | DATA_ENGINEER   | false        |            |
| 2024-01-24 17:12:47.967 +0000 | USAGE     | DATABASE_ROLE | SNOWFLAKE.OBJECT_VIEWER     | ROLE       | DATA_ENGINEER   | false        |            |
|-------------------------------+-----------+---------------+-----------------------------+------------+-----------------+--------------+------------|

-- Example 8601
USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE data_engineer;
GRANT DATABASE ROLE SNOWFLAKE.OBJECT_VIEWER TO ROLE data_engineer;
SHOW GRANTS LIKE '%VIEWER%' TO ROLE data_engineer;

-- Example 8602
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "GOVERNANCE.FUNCTIONS.RETURN_SUM",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  },
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "GOVERNANCE.TABLES.T1"
  }
]

-- Example 8603
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "GOVERNANCE.FUNCTIONS.RETURN_SUM",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  },
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "GOVERNANCE.TABLES.T1"
  }
]

-- Example 8604
[
  {
    "objectDomain": "STRING",
    "objectId":  NUMBER,
    "objectName": "STRING",
    "columns": [
      {
        "columnId": "NUMBER",
        "columnName": "STRING",
        "baseSources": [
          {
            "columnName": STRING,
            "objectDomain": "STRING",
            "objectId": NUMBER,
            "objectName": "STRING"
          }
        ],
        "directSources": [
          {
            "columnName": STRING,
            "objectDomain": "STRING",
            "objectId": NUMBER,
            "objectName": "STRING"
          }
        ]
      }
    ]
  },
  ...
]

-- Example 8605
{
  "objectDomain": STRING,
  "objectName": STRING,
  "objectId": NUMBER,
  "operationType": STRING,
  "properties": ARRAY
}

-- Example 8606
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "SSN",
        "policies": [
          {
              "policyName": "governance.policies.ssn_mask",
              "policyId": 68811,
              "policyKind": "MASKING_POLICY"
          }
        ]
      }
    ],
    "objectDomain": "VIEW",
    "objectId": 66564,
    "objectName": "GOVERNANCE.VIEWS.V1",
    "policies": [
      {
        "policyName": "governance.policies.rap1",
        "policyId": 68813,
        "policyKind": "ROW_ACCESS_POLICY"
      }
    ]
  }
]

-- Example 8607
columns: {
  "email": {
    objectId: {
      "value": 1
    },
    "subOperationType": "ADD"
  }
}

-- Example 8608
UPDATE mydb.s1.t1 SET col_1 = col_1 + 1;

-- Example 8609
UPDATE mydb.s1.t1 FROM mydb.s2.t2 SET t1.col1 = t2.col1;

-- Example 8610
insert into a(c1)
select c2
from b
where c3 > 1;

-- Example 8611
insert into A(col1) select f(col2) from B;

-- Example 8612
CREATE OR REPLACE

ALTER ... { SET | UNSET }

ALTER ... ADD ROW ACCESS POLICY

ALTER ... DROP ROW ACCESS POLICY

ALTER ... DROP ALL ROW ACCESS POLICIES

DROP | UNDROP

-- Example 8613
GRANT APPLICATION ROLE SNOWFLAKE.EVENTS_ADMIN TO ROLE my_admin_role

GRANT APPLICATION ROLE SNOWFLAKE.EVENTS_VIEWER TO ROLE my_analysis_role

-- Example 8614
CREATE EVENT TABLE my_database.my_schema.my_events;

-- Example 8615
ALTER DATABASE my_database SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8616
ALTER ACCOUNT SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8617
ALTER ACCOUNT UNSET EVENT_TABLE;

-- Example 8618
SHOW PARAMETERS LIKE 'event_table' IN ACCOUNT;

-- Example 8619
ALTER DATABASE my_database SET EVENT_TABLE = my_database.my_schema.my_events;

-- Example 8620
ALTER DATABASE my_database UNSET EVENT_TABLE;

-- Example 8621
SHOW PARAMETERS LIKE 'event_table' IN DATABASE my_database;

-- Example 8622
az role definition create --role-definition '{"Name":"snowflake-pep-role","Description":
"To generate advanced proof of access token for Snowflake private endpoint pinning","Actions":
["Microsoft.Network/privateEndpoints/read"],"AssignableScopes":["/subscriptions/<subscription_id>"]}'

-- Example 8623
az role assignment create --assignee <user> --role snowflake-pep-role --scope <private_endpoint_resource_id>

