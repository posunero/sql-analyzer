-- Example 12911
-- View the list of the accounts in your organization
-- Note the organization name and account name for each account for which you are enabling replication
SHOW ACCOUNTS;

-- Enable replication by executing this statement for each source and target account in your organization
SELECT SYSTEM$GLOBAL_ACCOUNT_SET_PARAMETER('<organization_name>.<account_name>', 'ENABLE_ACCOUNT_DATABASE_REPLICATION', 'true');

-- Example 12912
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
    TO ROLE myrole;

-- Example 12913
SHOW REPLICATION ACCOUNTS;

-- Example 12914
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| snowflake_region | created_on                    | account_name | account_locator | comment         | organization_name | is_org_admin |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_WEST_2    | 2020-07-15 21:59:25.455 -0800 | myaccount1   | myacctlocator1  |                 | myorg             | true         |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_EAST_1    | 2020-07-23 14:12:23.573 -0800 | myaccount2   | myacctlocator2  |                 | myorg             | false        |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+
| AWS_US_EAST_2    | 2020-07-25 19:25:04.412 -0800 | myaccount3   | myacctlocator3  |                 | myorg             | false        |
+------------------+-------------------------------+--------------+-----------------+-----------------+-------------------+--------------+

-- Example 12915
SHOW FAILOVER GROUPS;

-- Example 12916
SHOW DATABASES IN FAILOVER GROUP myfg;

-- Example 12917
SHOW SHARES IN FAILOVER GROUP myfg;

-- Example 12918
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES, INTEGRATIONS, NETWORK POLICIES
    ALLOWED_DATABASES = db1, db2
    ALLOWED_INTEGRATION_TYPES = API INTEGRATIONS
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12919
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
    TO ROLE myrole;

-- Example 12920
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  AS REPLICA OF myorg.myaccount1.myfg;

-- Example 12921
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 12922
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 12923
USE ROLE my_replication_role;

ALTER FAILOVER GROUP myfg REFRESH;

-- Example 12924
GRANT FAILOVER ON FAILOVER GROUP myfg TO ROLE my_failover_role;

-- Example 12925
ALTER DATABASE <name> SET REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' }
ALTER DATABASE <name> UNSET REPLICABLE_WITH_FAILOVER_GROUPS

ALTER SCHEMA <name> SET REPLICABLE_WITH_FAILOVER_GROUPS = { 'YES' | 'NO' }
ALTER SCHEMA <name> UNSET REPLICABLE_WITH_FAILOVER_GROUPS

-- Example 12926
USE ROLE ACCOUNTADMIN;

GRANT REPLICATE ON ACCOUNT TO ROLE replicationadmin;
GRANT USAGE ON DATABASE db1 TO ROLE replicationadmin;
GRANT USAGE ON SCHEMA db1.sch1 TO ROLE replicationadmin;

-- Example 12927
USE ROLE replicationadmin;

ALTER DATABASE db1 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'NO';
ALTER SCHEMA sch1 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'YES';

-- Example 12928
USE ROLE replicationadmin;

ALTER DATABASE db2 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'YES';
ALTER SCHEMA sch2 SET REPLICABLE_WITH_FAILOVER_GROUPS = 'NO';

-- Example 12929
USE ROLE replicationadmin;

SELECT database_name, replicable_with_failover_groups
  FROM db1.INFORMATION_SCHEMA.DATABASES;

-- Example 12930
+---------------+---------------------------------+
| DATABASE_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+---------------+---------------------------------+
| DB1           | NO                              |
| DB2           | YES                             |
| DB3           | UNSET                           |
+---------------+---------------------------------+

-- Example 12931
SELECT schema_name, catalog_name, replicable_with_failover_groups
  FROM db1.INFORMATION_SCHEMA.SCHEMATA ORDER BY catalog_name;

-- Example 12932
+--------------------+--------------+---------------------------------+
| SCHEMA_NAME        | CATALOG_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+--------------------+--------------+---------------------------------+
| PUBLIC             | DB1          | NO                              |
| SCH1               | DB1          | YES                             |
| SCH2               | DB1          | NO                              |
| SCH3               | DB1          | NO                              |
| INFORMATION_SCHEMA | DB1          | UNSET                           |
+--------------------+--------------+---------------------------------+

-- Example 12933
USE ROLE replicationadmin;

SELECT schema_name, catalog_name, replicable_with_failover_groups
  FROM db2.INFORMATION_SCHEMA.SCHEMATA
  ORDER BY catalog_name;

-- Example 12934
+--------------------+--------------+---------------------------------+
| SCHEMA_NAME        | CATALOG_NAME | REPLICABLE_WITH_FAILOVER_GROUPS |
+--------------------+--------------+---------------------------------+
| PUBLIC             | DB2          | YES                             |
| SCH1               | DB2          | YES                             |
| SCH2               | DB2          | NO                              |
| SCH3               | DB2          | YES                             |
| INFORMATION_SCHEMA | DB2          | UNSET                           |
+--------------------+--------------+---------------------------------+

-- Example 12935
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('myfg');

-- Example 12936
ALTER FAILOVER GROUP <fg_name> REFRESH FORCE;

-- Example 12937
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('<rg_name>');

-- Example 12938
SELECT PARSE_JSON(details)['primarySnapshotTimestamp']
  FROM TABLE(information_schema.replication_group_refresh_progress('myfg'))
  WHERE PHASE_NAME = 'PRIMARY_UPLOADING_METADATA';

-- Example 12939
SELECT HASH_AGG( * ) FROM mytable;

-- Example 12940
SELECT HASH_AGG( * ) FROM mytable AT(TIMESTAMP => '<primarySnapshotTimestamp>'::TIMESTAMP);

-- Example 12941
Database '<database_name>' is already configured to replicate to
account '<account_name>' by replication group '<group_name>'.

-- Example 12942
Cannot directly add previously replicated object '<database_name>' to a
replication group. Please use the provided system functions to convert
this object first.

-- Example 12943
Share '<share_name>' is already configured to replicate to
account '<account_name>' by replication group '<group_name>'.

-- Example 12944
ALTER CONNECTION global
ENABLE FAILOVER TO ACCOUNTS example.northamericaeast;

-- Example 12945
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

-- Example 12946
CREATE FAILOVER GROUP FG
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations
  ALLOWED_ACCOUNTS = example.northamericaeast
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12947
CREATE CONNECTION global AS REPLICA OF example.northamericawest.global;

-- Example 12948
CREATE FAILOVER GROUP fg
AS REPLICA OF example.northamericawest.fg;

-- Example 12949
ALTER FAILOVER GROUP fg REFRESH;

-- Example 12950
ALTER CONNECTION global PRIMARY;

-- Example 12951
CREATE ROLE IF NOT EXISTS okta_provisioner;
GRANT CREATE USER ON ACCOUNT TO ROLE okta_provisioner;
GRANT CREATE ROLE ON ACCOUNT TO ROLE okta_provisioner;
GRANT ROLE okta_provisioner TO ROLE ACCOUNTADMIN;
CREATE OR REPLACE SECURITY INTEGRATION okta_provisioning
   TYPE = scim
   SCIM_CLIENT = 'okta'
   RUN_AS_ROLE = 'OKTA_PROVISIONER';

select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 12952
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 12953
ALTER FAILOVER GROUP fg REFRESH;

-- Example 12954
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 12955
ALTER CONNECTION global PRIMARY;

-- Example 12956
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 12957
ALTER FAILOVER GROUP fg REFRESH;

-- Example 12958
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 12959
ALTER CONNECTION global PRIMARY;

-- Example 12960
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 12961
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, account parameters, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 12962
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, users, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 12963
CREATE FAILOVER GROUP fg
   OBJECT_TYPES = network policies, integrations, databases
   ALLOWED_DATABASES = testdb2
   ALLOWED_INTEGRATION_TYPES = security integrations
   ALLOWED_ACCOUNTS = myorg.myaccount2;

-- Example 12964
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = users, roles, warehouses, resource monitors, integrations, network policies, account parameters
  ALLOWED_INTEGRATION_TYPES = security integrations;

-- Example 12965
ALTER FAILOVER GROUP fg REFRESH;

-- Example 12966
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 12967
ALTER CONNECTION global PRIMARY;

-- Example 12968
show secrets in database secretsdb;
show security integrations;
show api integrations;
show tables in database destdb;
show warehouses;
show roles;

-- Example 12969
ALTER FAILOVER GROUP fg SET
  OBJECT_TYPES = databases, users, roles, warehouses, resource monitors, integrations, network policies, account parameters
  ALLOWED_DATABASES = secretsdb, destdb
  ALLOWED_INTEGRATION_TYPES = security integrations, api integrations;

-- Example 12970
ALTER FAILOVER GROUP fg REFRESH;

-- Example 12971
show secrets;
show security integrations;
show api integrations;
show database;
show tables in database destdb;
show roles;

-- Example 12972
ALTER FAILOVER GROUP fg PRIMARY;

-- Example 12973
ALTER CONNECTION global PRIMARY;

-- Example 12974
USE ROLE useradmin;

CREATE ROLE policy_admin;

-- Example 12975
USE ROLE securityadmin;

GRANT USAGE ON DATABASE yourdb TO ROLE policy_admin;

GRANT USAGE, CREATE PACKAGES POLICY ON SCHEMA yourdb.yourschema TO ROLE policy_admin;

GRANT APPLY PACKAGES POLICY ON ACCOUNT TO ROLE policy_admin;

-- Example 12976
USE ROLE policy_admin;

CREATE PACKAGES POLICY yourdb.yourschema.packages_policy_prod_1
  LANGUAGE PYTHON
  ALLOWLIST = ('numpy', 'pandas==1.2.3', ...)
  BLOCKLIST = ('numpy==1.2.3', 'bad_package', ...)
  ADDITIONAL_CREATION_BLOCKLIST = ('bad_package2', 'bad_package3', ...)
  COMMENT = 'Packages policy for the prod_1 environment'
;

-- Example 12977
USE ROLE ACCOUNTADMIN;

SELECT SNOWFLAKE.SNOWPARK.SHOW_PYTHON_PACKAGES_DEPENDENCIES('3.9', ['numpy']);

