-- Example 1225
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
    WHERE TAG_NAME = 'PRIVACY_CATEGORY'
    ORDER BY OBJECT_DATABASE, OBJECT_SCHEMA, OBJECT_NAME, COLUMN_NAME;

-- Example 1226
SELECT * FROM
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES(
      'my_db.my_schema.hr_data.fname',
      'COLUMN'
    ));

-- Example 1227
SELECT * from
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
      'my_db.my_schema.hr_data',
      'table'
    ));

-- Example 1228
SELECT SYSTEM$GET_TAG(
  'SNOWFLAKE.CORE.PRIVACY_CATEGORY',
  'hr_data.fname',
  'COLUMN'
  );

-- Example 1229
SELECT c1, c2
FROM open_table
WHERE c1 = (SELECT x FROM protected_table WHERE y = open_table.c2);

-- Example 1230
SELECT
  SUM(SELECT COUNT(*) FROM open_table ot WHERE pt.id = ot.id)
FROM protected_table pt;

-- Example 1231
CREATE [ OR REPLACE ] AGGREGATION POLICY <name>
  AS () RETURNS AGGREGATION_CONSTRAINT -> <body>
  [ COMMENT = '<string_literal>' ];

-- Example 1232
CREATE AGGREGATION POLICY my_agg_policy
  AS () RETURNS AGGREGATION_CONSTRAINT -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5);

-- Example 1233
CREATE AGGREGATION POLICY my_agg_policy
  AS () RETURNS AGGREGATION_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ADMIN'
        THEN NO_AGGREGATION_CONSTRAINT()
      ELSE AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5)
    END;

-- Example 1234
ALTER AGGREGATION POLICY my_policy SET BODY -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE=>2);

-- Example 1235
ALTER { TABLE | VIEW } <name> SET AGGREGATION POLICY <policy_name> [ FORCE ]

-- Example 1236
ALTER TABLE t1 SET AGGREGATION POLICY my_agg_policy;

-- Example 1237
CREATE TABLE t1 WITH AGGREGATION POLICY my_agg_policy;

-- Example 1238
ALTER TABLE privacy SET AGGREGATION POLICY agg_policy_2 FORCE;

-- Example 1239
ALTER {TABLE | VIEW} <name> UNSET AGGREGATION POLICY

-- Example 1240
ALTER VIEW v1 UNSET AGGREGATION POLICY;

-- Example 1241
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.AGGREGATION_POLICIES
ORDER BY POLICY_NAME;

-- Example 1242
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.aggpolicy'));

-- Example 1243
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 1244
SELECT * FROM open_table ot WHERE ot.a > (SELECT SUM(id) FROM protected_table pt)

-- Example 1245
SELECT c, COUNT(*)
FROM agg_t, open_t
WHERE agg_t.c = open_t.c
GROUP BY agg_t.c;

-- Example 1246
+-----------------+
|  c   | COUNT(*) |
|------+----------|
|  2   |  2       |
|------+----------|
| null |  3       |
+-----------------+

-- Example 1247
SELECT a, COUNT(*)
FROM (
    SELECT a, b FROM protected_table1
    UNION ALL
    SELECT a, b FROM protected_table2
)
GROUP BY a;

-- Example 1248
USE ROLE USERADMIN;

CREATE ROLE AGG_POLICY_ADMIN;

-- Example 1249
GRANT USAGE ON DATABASE privacy TO ROLE agg_policy_admin;
GRANT USAGE ON SCHEMA privacy.agg_policies TO ROLE agg_policy_admin;

GRANT CREATE AGGREGATION POLICY
  ON SCHEMA privacy.agg_policies TO ROLE agg_policy_admin;

GRANT APPLY AGGREGATION POLICY ON ACCOUNT TO ROLE agg_policy_admin;

-- Example 1250
USE ROLE agg_policy_admin;
USE SCHEMA privacy.agg_policies;

CREATE AGGREGATION POLICY my_policy
  AS () RETURNS AGGREGATION_CONSTRAINT -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 3);

-- Example 1251
ALTER TABLE t1 SET AGGREGATION POLICY my_policy;

-- Example 1252
SELECT state, AVG(elevation) AS avg_elevation
FROM t1
GROUP BY state;

-- Example 1253
+----------+-----------------+
|  STATE   |  AVG_ELEVATION  |
|----------+-----------------+
|  NH      |  4435           |
|  NULL    |  3543           |
+----------+-----------------+

-- Example 1254
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE aggregation_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT CREATE AGGREGATION POLICY ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT APPLY ON AGGREGATION POLICY ON ACCOUNT TO ROLE aggregation_policy_admin;

-- Example 1255
USE ROLE securityadmin;
GRANT CREATE AGGREGATION POLICY ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT APPLY ON AGGREGATION POLICY cost_center TO ROLE finance_role;

-- Example 1256
SELECT t_unprotected.email
  FROM t_unprotected JOIN t_protected ON t_unprotected.email = t_protected.email;

-- Example 1257
CREATE OR REPLACE PROJECTION POLICY <name>
  AS () RETURNS PROJECTION_CONSTRAINT -> <body>

-- Example 1258
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => true)

-- Example 1259
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => false)

-- Example 1260
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN CURRENT_ROLE() = 'ANALYST'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 1261
CREATE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col') = 'public'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 1262
CREATE OR REPLACE PROJECTION POLICY restrict_consumer_accounts
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN CURRENT_ACCOUNT() = 'provider.account'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 1263
CREATE OR REPLACE PROJECTION POLICY projection_share
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN INVOKER_SHARE() IN ('SHARE1', 'SHARE2')
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 1264
-- Create mapping table with two columns: role name, whether that role can project the column
CREATE OR REPLACE TABLE roles_with_access(role string, allowed boolean)
AS SELECT * FROM VALUES ('ACCOUNTADMIN', true), ('RANDOM_ROLE', false);

-- Create a policy that queries the mapping table, and allows projection when current
-- user role has an `allowed` value of TRUE.
-- Note that the logic is written to default to FALSE in all other cases, including the
-- current role not being in the queried table.
CREATE OR REPLACE PROJECTION POLICY pp AS () RETURNS projection_constraint ->
  CASE WHEN
    exists(
      SELECT 1 FROM roles_with_access WHERE role = current_role() AND allowed = true
    ) THEN projection_constraint(ALLOW=>true)
  ELSE projection_constraint(ALLOW=>false) END;

-- Create a new table with the policy and query it in one step.
CREATE OR REPLACE TABLE t(user string, address string WITH PROJECTION POLICY pp)
  AS SELECT * FROM VALUES ('Carson', 'CA'), ('Emily', 'NY'), ('John', 'NV');

-- Succeeds
USE ROLE ACCOUNTADMIN;
SELECT * FROM t;

-- Fails with projection policy error on column ADDRESS
USE ROLE any_other_role;
SELECT * FROM t;

-- Example 1265
ALTER { TABLE | VIEW } <name>
{ ALTER | MODIFY } COLUMN <col1_name>
SET PROJECTION POLICY <policy_name> [ FORCE ]
[ , <col2_name> SET PROJECTION POLICY <policy_name> [ FORCE ] ... ]

-- Example 1266
ALTER TABLE finance.accounting.customers
 MODIFY COLUMN account_number
 SET PROJECTION POLICY proj_policy_acctnumber;

-- Example 1267
CREATE TABLE t1 (account_number NUMBER WITH PROJECTION POLICY my_proj_policy);

-- Example 1268
ALTER TABLE customers ADD COLUMN account_number NUMBER WITH PROJECTION POLICY my_proj_policy;

-- Example 1269
ALTER TABLE finance.accounting.customers
  MODIFY COLUMN account_number
  SET PROJECTION POLICY proj_policy2 FORCE;

-- Example 1270
ALTER { TABLE | VIEW } <name>
{ ALTER | MODIFY } COLUMN <col1_name>
UNSET PROJECTION POLICY
[ , <col2_name> UNSET PROJECTION POLICY ... ]

-- Example 1271
ALTER TABLE finance.accounting.customers
 MODIFY COLUMN account_number
 UNSET PROJECTION POLICY;

-- Example 1272
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.PROJECTION_POLICIES
ORDER BY POLICY_NAME;

-- Example 1273
USE DATABASE my_db;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.projpolicy'));

-- Example 1274
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 1275
USE ROLE useradmin;

CREATE ROLE proj_policy_admin;

-- Example 1276
GRANT USAGE ON DATABASE privacy TO ROLE proj_policy_admin;
GRANT USAGE ON SCHEMA privacy.projpolicies TO ROLE proj_policy_admin;

GRANT CREATE PROJECTION POLICY
  ON SCHEMA privacy.projpolicies TO ROLE proj_policy_admin;

GRANT APPLY PROJECTION POLICY ON ACCOUNT TO ROLE proj_policy_admin;

-- Example 1277
USE ROLE proj_policy_admin;
USE SCHEMA privacy.projpolicies;

CREATE OR REPLACE PROJECTION POLICY proj_policy_false
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => false);

-- Example 1278
ALTER TABLE customers MODIFY COLUMN active
SET PROJECTION POLICY privacy.projpolicies.proj_policy_false;

-- Example 1279
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE projection_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE projection_policy_admin;

GRANT CREATE PROJECTION POLICY ON SCHEMA mydb.schema TO ROLE projection_policy_admin;
GRANT APPLY ON PROJECTION POLICY ON ACCOUNT TO ROLE projection_policy_admin;

-- Example 1280
USE ROLE securityadmin;
GRANT CREATE PROJECTION POLICY ON SCHEMA mydb.schema TO ROLE projection_policy_admin;
GRANT APPLY ON PROJECTION POLICY cost_center TO ROLE finance_role;

-- Example 1281
SELECT CURRENT_ORGANIZATION_NAME() || '-' || CURRENT_ACCOUNT_NAME();

-- Example 1282
[connections]
[connections.myconnection]
account = "myorganization-myaccount"

-- Example 1283
-- Create a new primary connection
CREATE CONNECTION myconnection;

-- View accounts in your organization that are enabled for replication
SHOW REPLICATION ACCOUNTS;

-- Configure failover accounts for the primary connection
ALTER CONNECTION myconnection
  ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- View the details for the connection
SHOW CONNECTIONS;

-- Example 1284
CREATE CONNECTION myconnection
  AS REPLICA OF myorg.myaccount1.myconnection;

-- Example 1285
ALTER CONNECTION myconnection PRIMARY;

-- Example 1286
ALTER CONNECTION myconnection PRIMARY;

-- Example 1287
CREATE CONNECTION myconnection;

-- Example 1288
ALTER CONNECTION myconnection ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- Example 1289
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 1290
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 1291
CREATE CONNECTION myconnection
  AS REPLICA OF MYORG.MYACCOUNT1.MYCONNECTION;

-- Example 1292
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

