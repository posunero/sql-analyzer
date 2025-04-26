-- Example 10700
USE ROLE USERADMIN;

CREATE ROLE join_policy_admin;

-- Example 10701
GRANT USAGE ON DATABASE privacy TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;

GRANT CREATE JOIN POLICY
  ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;

GRANT APPLY JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

-- Example 10702
USE ROLE join_policy_admin;
USE SCHEMA privacy.join_policies;

CREATE OR REPLACE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

-- Example 10703
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT CREATE JOIN POLICY ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT APPLY ON JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

-- Example 10704
USE ROLE securityadmin;
GRANT CREATE JOIN POLICY ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT APPLY ON JOIN POLICY cost_center TO ROLE finance_role;

-- Example 10705
SHOW PARAMETERS [ LIKE '<pattern>' ] IN ACCOUNT

-- Example 10706
SHOW PARAMETERS IN ACCOUNT;

+-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| key                                 | value                            | default                          | level   | description                                                                                                                                                                         |
|-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ABORT_DETACHED_QUERY                | false                            | false                            |         | If true, Snowflake will automatically abort queries when it detects that the client has disappeared.                                                                                |
| AUTOCOMMIT                          | true                             | true                             |         | The autocommit property determines whether is statement should to be implicitly                                                                                                     |
|                                     |                                  |                                  |         | wrapped within a transaction or not. If autocommit is set to true, then a                                                                                                           |
|                                     |                                  |                                  |         | statement that requires a transaction is executed within a transaction                                                                                                              |
|                                     |                                  |                                  |         | implicitly. If autocommit is off then an explicit commit or rollback is required                                                                                                    |
|                                     |                                  |                                  |         | to close a transaction. The default autocommit value is true.                                                                                                                       |
| AUTOCOMMIT_API_SUPPORTED            | true                             | true                             |         | Whether autocommit feature is enabled for this client. This parameter is for                                                                                                        |
|                                     |                                  |                                  |         | Snowflake use only.                                                                                                                                                                 |
| BINARY_INPUT_FORMAT                 | HEX                              | HEX                              |         | input format for binary                                                                                                                                                             |
| BINARY_OUTPUT_FORMAT                | HEX                              | HEX                              |         | display format for binary                                                                                                                                                           |
| CLIENT_ENCRYPTION_KEY_SIZE          | 128                              | 128                              |         | Client-side encryption key size in bits. Either 128 or 256.                                                                                                                         |
| CLIENT_SESSION_KEEP_ALIVE           | false                            | false                            |         | If true, client session will not expire automatically                                                                                                                               |
| DATA_RETENTION_TIME_IN_DAYS         | 1                                | 1                                |         | number of days to retain the old version of deleted/updated data                                                                                                                    |
| DATE_INPUT_FORMAT                   | AUTO                             | AUTO                             |         | input format for date                                                                                                                                                               |
| DATE_OUTPUT_FORMAT                  | YYYY-MM-DD                       | YYYY-MM-DD                       |         | display format for date                                                                                                                                                             |
| ERROR_ON_NONDETERMINISTIC_MERGE     | true                             | true                             |         | raise an error when attempting to merge-update a row that joins many rows                                                                                                           |
| ERROR_ON_NONDETERMINISTIC_UPDATE    | false                            | false                            |         | raise an error when attempting to update a row that joins many rows                                                                                                                 |
| LOCK_TIMEOUT                        | 43200                            | 43200                            |         | Number of seconds to wait while trying to lock a resource, before timing out                                                                                                        |
|                                     |                                  |                                  |         | and aborting the statement. A value of 0 turns off lock waiting i.e. the                                                                                                            |
|                                     |                                  |                                  |         | statement must acquire the lock immediately or abort. If multiple resources                                                                                                         |
|                                     |                                  |                                  |         | need to be locked by the statement, the timeout applies separately to each                                                                                                          |
|                                     |                                  |                                  |         | lock attempt.                                                                                                                                                                       |
| MAX_CONCURRENCY_LEVEL               | 8                                | 8                                |         | Concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse cluster (used to determine when statements are queued or additional clusters are started).      |
| NETWORK_POLICY                      |                                  |                                  |         | Network policy assigned for the given target.                                                                                                                                       |
| PERIODIC_DATA_REKEYING              | false                            | false                            |         | If true, Snowflake will re-encrypt data that was encrypted more than a year ago.                                                                                                    |
| QUERY_TAG                           |                                  |                                  |         | String (up to 2000 characters) used to tag statements executed by the session                                                                                                       |
| QUOTED_IDENTIFIERS_IGNORE_CASE      | false                            | false                            |         | If true, the case of quoted identifiers is ignored                                                                                                                                  |
| ROWS_PER_RESULTSET                  | 0                                | 0                                |         | maxium number of rows in a result set                                                                                                                                               |
| SAML_IDENTITY_PROVIDER              |                                  |                                  |         | Authentication attributes for the SAML Identity provider                                                                                                                            |
| SSO_LOGIN_PAGE                      | true                             | false                            | ACCOUNT | Enable federated authentication for console login and redirects preview page to console login                                                                                       |
| STATEMENT_QUEUED_TIMEOUT_IN_SECONDS | 0                                | 0                                |         | Timeout in seconds for queued statements: statements will automatically be canceled if they are queued on a warehouse for longer than this amount of time; disabled if set to zero. |
| STATEMENT_TIMEOUT_IN_SECONDS        | 0                                | 0                                |         | Timeout in seconds for statements: statements will automatically be canceled if they run for longer than this amount of time; disabled if set to zero.                              |
| TIMESTAMP_DAY_IS_ALWAYS_24H         | false                            | true                             | SYSTEM  | If set, arithmetic on days always uses 24 hours per day,                                                                                                                            |
|                                     |                                  |                                  |         | possibly not preserving the time (due to DST changes)                                                                                                                               |
| TIMESTAMP_INPUT_FORMAT              | AUTO                             | AUTO                             |         | input format for timestamp                                                                                                                                                          |
| TIMESTAMP_LTZ_OUTPUT_FORMAT         |                                  |                                  |         | Display format for TIMESTAMP_LTZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                 |
| TIMESTAMP_NTZ_OUTPUT_FORMAT         | YYYY-MM-DD HH24:MI:SS.FF3        | YYYY-MM-DD HH24:MI:SS.FF3        | SYSTEM  | Display format for TIMESTAMP_NTZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                 |
| TIMESTAMP_OUTPUT_FORMAT             | YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM | YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM | SYSTEM  | Default display format for all timestamp types.                                                                                                                                     |
| TIMESTAMP_TYPE_MAPPING              | TIMESTAMP_NTZ                    | TIMESTAMP_NTZ                    | SYSTEM  | If TIMESTAMP type is used, what specific TIMESTAMP* type it should map to:                                                                                                          |
|                                     |                                  |                                  |         |   TIMESTAMP_LTZ (default), TIMESTAMP_NTZ or TIMESTAMP_TZ                                                                                                                            |
| TIMESTAMP_TZ_OUTPUT_FORMAT          |                                  |                                  |         | Display format for TIMESTAMP_TZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                  |
| TIMEZONE                            | America/Los_Angeles              | America/Los_Angeles              |         | time zone                                                                                                                                                                           |
| TIME_INPUT_FORMAT                   | AUTO                             | AUTO                             |         | input format for time                                                                                                                                                               |
| TIME_OUTPUT_FORMAT                  | HH24:MI:SS                       | HH24:MI:SS                       |         | display format for time                                                                                                                                                             |
| TRANSACTION_ABORT_ON_ERROR          | false                            | false                            |         | If this parameter is true, and a statement issued within a non-autocommit                                                                                                           |
|                                     |                                  |                                  |         | transaction returns with an error, then the non-autocommit transaction is                                                                                                           |
|                                     |                                  |                                  |         | aborted. All statements issued inside that transaction will fail until an                                                                                                           |
|                                     |                                  |                                  |         | commit or rollback statement is executed to close that transaction.                                                                                                                 |
| TRANSACTION_DEFAULT_ISOLATION_LEVEL | READ COMMITTED                   | READ COMMITTED                   |         | The default isolation level when starting a starting a transaction, when no                                                                                                         |
|                                     |                                  |                                  |         | isolation level was specified                                                                                                                                                       |
| TWO_DIGIT_CENTURY_START             | 1970                             | 1970                             |         | For 2-digit dates, defines a century-start year.                                                                                                                                    |
|                                     |                                  |                                  |         | For example, when set to 1980:                                                                                                                                                      |
|                                     |                                  |                                  |         |   - parsing a string '79' will produce 2079                                                                                                                                         |
|                                     |                                  |                                  |         |   - parsing a string '80' will produce 1980                                                                                                                                         |
| UNSUPPORTED_DDL_ACTION              | ignore                           | ignore                           |         | The action to take upon encountering an unsupported ddl statement                                                                                                                   |
| USE_CACHED_RESULT                   | true                             | true                             |         | If enabled, query results can be reused between successive invocations of the same query as long as the original result has not expired                                             |
+-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 10707
ALTER ACCOUNT SET <param> = <value>

-- Example 10708
ALTER ACCOUNT SET DATE_OUTPUT_FORMAT = 'DD/MM/YYYY';

SHOW PARAMETERS LIKE 'DATE_OUTPUT%' IN ACCOUNT;

+--------------------+------------+------------+---------+-------------------------+
| key                | value      | default    | level   | description             |
|--------------------+------------+------------+---------+-------------------------|
| DATE_OUTPUT_FORMAT | DD/MM/YYYY | YYYY-MM-DD | ACCOUNT | display format for date |
+--------------------+------------+------------+---------+-------------------------+

-- Example 10709
ALTER ACCOUNT UNSET <param>

-- Example 10710
ALTER ACCOUNT UNSET DATE_OUTPUT_FORMAT;

-- Example 10711
Dangling references in the snapshot. Correct the errors before refreshing again.
The following references are missing (referred entity <- [referring entities])

-- Example 10712
003131 (55000): Dangling references in the snapshot. Correct the errors before refreshing again.
The following references are missing (referred entity <- [referring entities]):
POLICY '<policy_db>.<policy_schema>.<packages_policy_name>' <- [ACCOUNT '<account_locator>']

-- Example 10713
Primary database: the source object ''<object_name>'' for this stream ''<stream_name>'' is not included in the replication group.
Stream replication does not support replication across databases in different replication groups. Please see Streams Documentation
https://docs.snowflake.com/en/user-guide/account-replication-considerations#replication-and-streams for options.

-- Example 10714
CREATE REPLICATION GROUP myrg
  OBJECT_TYPES = DATABASES, ROLES, USERS
  ALLOWED_DATABASES = session_policy_db
  ALLOWED_ACCOUNTS = myorg.myaccount
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10715
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1, db2
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10716
SELECT SYSTEM$DISABLE_DATABASE_REPLICATION('mydb');

-- Example 10717
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
  TO ROLE myrole;

-- Example 10718
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES
  ALLOWED_DATABASES = db1, db2
  ALLOWED_ACCOUNTS = myorg.myaccount2, myorg.myaccount3
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10719
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
  TO ROLE myrole;

-- Example 10720
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  AS REPLICA OF myorg.myaccount1.myfg;

-- Example 10721
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 10722
USE ROLE my_replication_role;

ALTER FAILOVER GROUP myfg REFRESH;

-- Example 10723
GRANT FAILOVER ON FAILOVER GROUP myfg TO ROLE my_failover_role;;

-- Example 10724
-- View the list of the accounts in your organization
-- Note the organization name and account name for each account for which you are enabling replication
SHOW ACCOUNTS;

-- Enable replication by executing this statement for each source and target account in your organization
SELECT SYSTEM$GLOBAL_ACCOUNT_SET_PARAMETER('<organization_name>.<account_name>', 'ENABLE_ACCOUNT_DATABASE_REPLICATION', 'true');

-- Example 10725
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
    TO ROLE myrole;

-- Example 10726
SHOW REPLICATION ACCOUNTS;

-- Example 10727
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| snowflake_region | created_on                    | account_name | account_locator | comment         | organization_name | is_org_admin |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_WEST_2    | 2020-07-15 21:59:25.455 -0800 | myaccount1   | myacctlocator1  |                 | myorg             | true         |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_EAST_1    | 2020-07-23 14:12:23.573 -0800 | myaccount2   | myacctlocator2  |                 | myorg             | false        |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_EAST_2    | 2020-07-25 19:25:04.412 -0800 | myaccount3   | myacctlocator3  |                 | myorg             | false        |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+

-- Example 10728
SHOW FAILOVER GROUPS;

-- Example 10729
SHOW DATABASES IN FAILOVER GROUP myfg;

-- Example 10730
SHOW SHARES IN FAILOVER GROUP myfg;

-- Example 10731
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES, INTEGRATIONS, NETWORK POLICIES
    ALLOWED_DATABASES = db1, db2
    ALLOWED_INTEGRATION_TYPES = API INTEGRATIONS
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10732
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
    TO ROLE myrole;

-- Example 10733
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  AS REPLICA OF myorg.myaccount1.myfg;

-- Example 10734
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 10735
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 10736
USE ROLE my_replication_role;

ALTER FAILOVER GROUP myfg REFRESH;

-- Example 10737
GRANT FAILOVER ON FAILOVER GROUP myfg TO ROLE my_failover_role;

-- Example 10738
ALTER DATABASE <name> SET REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' }
ALTER DATABASE <name> UNSET REPLICABLE_WITH_FAILOVER_GROUPS

ALTER SCHEMA <name> SET REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' }
ALTER SCHEMA <name> UNSET REPLICABLE_WITH_FAILOVER_GROUPS

-- Example 10739
USE ROLE ACCOUNTADMIN;

GRANT REPLICATE ON ACCOUNT TO ROLE replicationadmin;
GRANT USAGE ON DATABASE db1 TO ROLE replicationadmin;
GRANT USAGE ON SCHEMA db1.sch1 TO ROLE replicationadmin;

-- Example 10740
USE ROLE replicationadmin;

ALTER DATABASE db1 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'NO';
ALTER SCHEMA sch1 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'YES';

-- Example 10741
USE ROLE replicationadmin;

ALTER DATABASE db2 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'YES';
ALTER SCHEMA sch2 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'NO';

-- Example 10742
USE ROLE replicationadmin;

SELECT database_name, replicable_with_failover_groups
  FROM db1.INFORMATION_SCHEMA.DATABASES;

-- Example 10743
+---------------+---------------------------------+
| DATABASE_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+---------------+---------------------------------+
| DB1           | NO                              |
| DB2           | YES                             |
| DB3           | UNSET                           |
+---------------+---------------------------------+

-- Example 10744
SELECT schema_name, catalog_name, replicable_with_failover_groups
  FROM db1.INFORMATION_SCHEMA.SCHEMATA ORDER BY catalog_name;

-- Example 10745
+--------------------+--------------+---------------------------------+
| SCHEMA_NAME        | CATALOG_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+--------------------+--------------+---------------------------------+
| PUBLIC             | DB1          | NO                              |
| SCH1               | DB1          | YES                             |
| SCH2               | DB1          | NO                              |
| SCH3               | DB1          | NO                              |
| INFORMATION_SCHEMA | DB1          | UNSET                           |
+--------------------+--------------+---------------------------------+

-- Example 10746
USE ROLE replicationadmin;

SELECT schema_name, catalog_name, replicable_with_failover_groups
  FROM db2.INFORMATION_SCHEMA.SCHEMATA
  ORDER BY catalog_name;

-- Example 10747
+--------------------+--------------+---------------------------------+
| SCHEMA_NAME        | CATALOG_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+--------------------+--------------+---------------------------------+
| PUBLIC             | DB2          | YES                             |
| SCH1               | DB2          | YES                             |
| SCH2               | DB2          | NO                              |
| SCH3               | DB2          | YES                             |
| INFORMATION_SCHEMA | DB2          | UNSET                           |
+--------------------+--------------+---------------------------------+

-- Example 10748
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('myfg');

-- Example 10749
ALTER FAILOVER GROUP <fg_name> REFRESH FORCE;

-- Example 10750
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('<rg_name>');

-- Example 10751
SELECT PARSE_JSON(details)['primarySnapshotTimestamp']
  FROM TABLE(information_schema.replication_group_refresh_progress('myfg'))
  WHERE PHASE_NAME = 'PRIMARY_UPLOADING_METADATA';

-- Example 10752
SELECT HASH_AGG( * ) FROM mytable;

-- Example 10753
SELECT HASH_AGG( * ) FROM mytable AT(TIMESTAMP => '<primarySnapshotTimestamp>'::TIMESTAMP);

-- Example 10754
Database '<database_name>' is already configured to replicate to
account '<account_name>' by replication group '<group_name>'.

-- Example 10755
Cannot directly add previously replicated object '<database_name>' to a
replication group. Please use the provided system functions to convert
this object first.

-- Example 10756
Share '<share_name>' is already configured to replicate to
account '<account_name>' by replication group '<group_name>'.

-- Example 10757
ALTER CONNECTION global
ENABLE FAILOVER TO ACCOUNTS example.northamericaeast;

-- Example 10758
CREATE OR REPLACE SECURITY INTEGRATION my_idp
  TYPE = saml2
  ENABLED = true
  SAML2_ISSUER = 'http://www.okta.com/exk6e8mmrgJPj68PH4x7'
  SAML2_SSO_URL = 'https://example.okta.com/app/snowflake/exk6e8mmrgJPj68PH4x7/sso/saml'
  SAML2_PROVIDER = 'OKTA'
  SAML2_X509_CERT = 'MIIDp...'
  SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'OKTA'
  SAML2_ENABLE_SP_INITIATED = true
  SAML2_SNOWFLAKE_ISSUER_URL = 'https://example-global.snowflakecomputing.com'
  SAML2_SNOWFLAKE_ACS_URL = 'https://example-global.snowflakecomputing.com/fed/login';

-- Example 10759
CREATE FAILOVER GROUP FG
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations
  ALLOWED_ACCOUNTS = example.northamericaeast
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10760
CREATE CONNECTION global AS REPLICA OF example.northamericawest.global;

-- Example 10761
CREATE FAILOVER GROUP fg
AS REPLICA OF example.northamericawest.fg;

-- Example 10762
ALTER FAILOVER GROUP fg REFRESH;

-- Example 10763
ALTER CONNECTION global PRIMARY;

-- Example 10764
CREATE ROLE IF NOT EXISTS okta_provisioner;
GRANT CREATE USER ON ACCOUNT TO ROLE okta_provisioner;
GRANT CREATE ROLE ON ACCOUNT TO ROLE okta_provisioner;
GRANT ROLE okta_provisioner TO ROLE ACCOUNTADMIN;
CREATE OR REPLACE SECURITY INTEGRATION okta_provisioning
   TYPE = scim
   SCIM_CLIENT = 'okta'
   RUN_AS_ROLE = 'OKTA_PROVISIONER';

select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 10765
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 10766
ALTER FAILOVER GROUP fg REFRESH;

