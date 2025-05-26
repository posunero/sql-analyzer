-- More Extracted Snowflake SQL Examples (Set 5)

-- From snowflake_split_402.sql

USE DATABASE my_db;
USE SCHEMA INFORMATION_SCHEMA;
SELECT
    policy_name,
    policy_kind,
    ref_entity_name,
    ref_entity_domain,
    ref_column_name,
    ref_arg_column_names,
    policy_status
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(ref_entity_name => 'my_db.my_schema.join_table', ref_entity_domain => 'table'));

USE ROLE USERADMIN;
CREATE ROLE join_policy_admin;
GRANT USAGE ON DATABASE privacy TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;
GRANT CREATE JOIN POLICY
  ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;
GRANT APPLY JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

USE ROLE join_policy_admin;
USE SCHEMA privacy.join_policies;
CREATE OR REPLACE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT CREATE JOIN POLICY ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT APPLY ON JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

SHOW FAILOVER GROUPS IN ACCOUNT myaccount1;

USE ROLE ACCOUNTADMIN;
CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = databases, shares
  ALLOWED_DATABASES = db1
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme.account_2;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme.account1.my_rg;

ALTER REPLICATION GROUP my_rg REFRESH;
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

CREATE DATABASE db1;
CREATE SCHEMA db1.sch;
CREATE TABLE db1.sch.table_b AS
  SELECT customerid, user_order_count, total_spent
  FROM source_db.sch.table_a
  WHERE REGION='azure_eastus2';

CREATE SECURE VIEW db1.sch.view1 AS
  SELECT customerid, user_order_count, total_spent
  FROM db1.sch.table_b;

CREATE STREAM mystream ON TABLE source_db.sch.table_a APPEND_ONLY = TRUE;

CREATE TASK mytask1
  WAREHOUSE = mywh
  SCHEDULE = '5 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('mystream')
AS
  INSERT INTO table_b(CUSTOMERID, USER_ORDER_COUNT, TOTAL_SPENT)
    SELECT customerid, user_order_count, total_spent
    FROM mystream
    WHERE region='azure_eastus2'
    AND METADATA$ACTION = 'INSERT';

ALTER TASK mytask1 RESUME;

CREATE SHARE share1;
GRANT USAGE ON DATABASE db1 TO SHARE share1;
GRANT USAGE ON SCHEMA db1.sch TO SHARE share1;
GRANT SELECT ON VIEW db1.sch.view1 TO SHARE share1; 