-- Example 12241
accountObjectPrivileges ::=
-- For APPLICATION PACKAGE
    { ATTACH LISTING | DEVELOP | INSTALL | MANAGE VERSIONS | MANAGE RELEASES } [ , ... ]
-- For COMPUTE POOL
   { MODIFY | MONITOR | OPERATE | USAGE } [ , ... ]
-- For CONNECTION
   { FAILOVER } [ , ... ]
-- For DATABASE
   { APPLYBUDGET | CREATE { DATABASE ROLE | SCHEMA }
   | IMPORTED PRIVILEGES | MODIFY | MONITOR | USAGE } [ , ... ]
-- For EXTERNAL VOLUME
   { USAGE } [ , ... ]
-- For FAILOVER GROUP
   { FAILOVER | MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For INTEGRATION
   { USAGE | USE_ANY_ROLE } [ , ... ]
-- For ORGANIZATION PROFILE
   { MODIFY } [ , ... ]
-- For REPLICATION GROUP
   { MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For RESOURCE MONITOR
   { MODIFY | MONITOR } [ , ... ]
-- For USER
   { MONITOR } [ , ... ]
-- For WAREHOUSE
   { APPLYBUDGET | MODIFY | MONITOR | USAGE | OPERATE } [ , ... ]

-- Example 12242
schemaPrivileges ::=

    ADD SEARCH OPTIMIZATION | APPLYBUDGET
  | CREATE {
        ALERT | CORTEX SEARCH SERVICE | DATA METRIC FUNCTION | DATASET
      | EVENT TABLE | FILE FORMAT | FUNCTION
      | { GIT | IMAGE } REPOSITORY
      | MODEL | NETWORK RULE | NOTEBOOK | PIPE | PROCEDURE
      | { AGGREGATION | AUTHENTICATION | MASKING | PACKAGES
         | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY
      | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM | STREAMLIT
      | SNOWFLAKE.CORE.BUDGET
      | SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
      | SNOWFLAKE.DATA_PRIVACY.CUSTOM_CLASSIFIER
      | SNOWFLAKE.ML.ANOMALY_DETECTION | SNOWFLAKE.ML.CLASSIFICATION
         | SNOWFLAKE.ML.FORECAST | SNOWFLAKE.ML.TOP_INSIGHTS
      | SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE
      | [ { DYNAMIC | EXTERNAL | ICEBERG } ] TABLE
      | TAG | TASK | [ { MATERIALIZED | SEMANTIC } ] VIEW
      }
   | MODIFY | MONITOR | USAGE
   [ , ... ]

-- Example 12243
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DATA METRIC FUNCTION
     USAGE [ , ... ]
  -- For DYNAMIC TABLE
     MONITOR, OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { APPLYBUDGET | DELETE | OWNERSHIP | REFERENCES | SELECT | TRUNCATE } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), MODEL, PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For GIT REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For HYBRID TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For ICEBERG TABLE
     { APPLYBUDGET | DELETE | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { AGGREGATION | AUTHENTICATION | MASKING | JOIN | PACKAGES | PASSWORD | PRIVACY | PROJECTION | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     { READ | USAGE } [ , ... ]
  -- For SEMANTIC VIEW
     REFERENCES [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For STREAMLIT
     USAGE [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]

-- Example 12244
<udf_or_stored_procedure_name> ( [ <arg_data_type> [ , ... ] ] )

-- Example 12245
GRANT SELECT ON FUTURE TABLES IN DATABASE d1 TO ROLE r1;

-- Example 12246
GRANT INSERT, DELETE ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE r2;

-- Example 12247
GRANT OPERATE ON WAREHOUSE report_wh TO ROLE analyst;

-- Example 12248
GRANT OPERATE ON WAREHOUSE report_wh TO ROLE analyst WITH GRANT OPTION;

-- Example 12249
GRANT SELECT ON ALL TABLES IN SCHEMA mydb.myschema to ROLE analyst;

-- Example 12250
GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(number) TO ROLE analyst;

GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(string) TO ROLE analyst;

-- Example 12251
GRANT USAGE ON PROCEDURE mydb.myschema.myprocedure(number) TO ROLE analyst;

-- Example 12252
GRANT CREATE MATERIALIZED VIEW ON SCHEMA mydb.myschema TO ROLE myrole;

-- Example 12253
GRANT SELECT, INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema TO ROLE role1;

-- Example 12254
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE mydb TO ROLE role1;

-- Example 12255
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ht_schema TO ROLE ht_role;

-- Example 12256
GRANT SELECT ON ALL TABLES IN SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 12257
GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(number)
  TO DATABASE ROLE mydb.dr1;

GRANT ALL PRIVILEGES ON FUNCTION mydb.myschema.add5(string)
  TO DATABASE ROLE mydb.dr1;

-- Example 12258
GRANT USAGE ON PROCEDURE mydb.myschema.myprocedure(number)
  TO DATABASE ROLE mydb.dr1;

-- Example 12259
GRANT CREATE MATERIALIZED VIEW ON SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 12260
GRANT SELECT,INSERT ON FUTURE TABLES IN SCHEMA mydb.myschema
  TO DATABASE ROLE mydb.dr1;

-- Example 12261
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE mydb
  TO DATABASE ROLE mydb.dr1;

-- Example 12262
USE ROLE ACCOUNTADMIN;

GRANT CREATE SNOWFLAKE.CORE.BUDGET ON SCHEMA budgets_db.budgets_schema
  TO ROLE budget_admin;

-- Example 12263
SYSTEM$LOG('error', 'Error message');

-- Example 12264
artifacts:
  ...
  setup_script: scripts/setup.sql
  ...

-- Example 12265
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql

-- Example 12266
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql
    ├── scripts/secondary_script.sql
    ├── scripts/procs/setup_procs.sql
    ├── scripts/views/setup_views.sql
    ├── scripts/data/setup_data.sql

-- Example 12267
...
EXECUTE IMMEDIATE FROM 'secondary_script.sql';
EXECUTE IMMEDIATE FROM './procs/setup_procs.sql';
EXECUTE IMMEDIATE FROM '../scripts/views/setup_views.sql';
EXECUTE IMMEDIATE FROM '/scripts/data/setup_data.sql';
...

-- Example 12268
CREATE SCHEMA IF NOT EXISTS app_config;
CREATE TABLE IF NOT EXISTS app_config.params(...);

-- Example 12269
CREATE OR REPLACE PROCEDURE app_state.proc()...;
GRANT USAGE ON PROCEDURE app_state.proc()
  TO APPLICATION ROLE app_user;

-- Example 12270
A TAG in a versioned schema can only be assigned to the objects in the same schema. An object in a versioned schema can only have a TAG assigned that is defined in the same schema.

-- Example 12271
CREATE APPLICATION ROLE admin;
CREATE APPLICATION ROLE user;
GRANT APPLICATION ROLE user TO APPLICATION ROLE admin;

CREATE OR ALTER VERSIONED SCHEMA app_code;
GRANT USAGE ON SCHEMA app_code TO APPLICATION ROLE admin;
GRANT USAGE ON SCHEMA app_code TO APPLICATION ROLE user;
CREATE OR REPLACE PROCEDURE app_code.config_app(...)
GRANT USAGE ON PROCEDURE app_code.config_app(..)
  TO APPLICATION ROLE admin;

CREATE OR REPLACE FUNCTION app_code.add(x INT, y INT)
GRANT USAGE ON FUNCTION app_code.add(INT, INT)
  TO APPLICATION ROLE admin;
GRANT USAGE ON FUNCTION app_code.add(INT, INT)
  TO APPLICATION ROLE user;

-- Example 12272
IS_DATABASE_ROLE_IN_SESSION( '<string_literal>' )

-- Example 12273
IS_DATABASE_ROLE_IN_SESSION( <column_name> )

-- Example 12274
Could not resolve the database for IS_DATABASE_ROLE_IN_SESSION({})

-- Example 12275
SELECT IS_ROLE_IN_SESSION(UPPER(authz_role)) FROM t1;

-- Example 12276
CREATE VIEW v2 AS
SELECT
  authz_role,
  UPPER(authz_role) AS upper_authz_role
FROM t2;

SELECT IS_ROLE_IN_SESSION(upper_authz_role) FROM v2;

-- Example 12277
SELECT IS_DATABASE_ROLE_IN_SESSION('R1');

-- Example 12278
+-----------------------------------+
| IS_DATABASE_ROLE_IN_SESSION('R1') |
+-----------------------------------+
| True                              |
+-----------------------------------+

-- Example 12279
SELECT *
FROM myb.s1.t1
WHERE IS_DATABASE_ROLE_IN_SESSION(role_name);

-- Example 12280
IS_ROLE_IN_SESSION( '<string_literal>' )

-- Example 12281
IS_ROLE_IN_SESSION( <column_name> )

-- Example 12282
SELECT IS_ROLE_IN_SESSION(UPPER(authz_role)) FROM t1;

-- Example 12283
CREATE VIEW v2 AS
SELECT
  authz_role,
  UPPER(authz_role) AS upper_authz_role
FROM t2;

SELECT IS_ROLE_IN_SESSION(upper_authz_role) FROM v2;

-- Example 12284
SELECT IS_ROLE_IN_SESSION('ANALYST');

+-------------------------------+
| IS_ROLE_IN_SESSION('ANALYST') |
|-------------------------------|
| True                          |
+-------------------------------+

-- Example 12285
SELECT *
FROM myb.s1.t1
WHERE IS_ROLE_IN_SESSION(t1.role_name);

-- Example 12286
CREATE OR REPLACE MASKING POLICY allow_analyst AS (val string)
RETURNS string ->
CASE
  WHEN IS_ROLE_IN_SESSION('ANALYST') THEN val
  ELSE '*******'
END;

-- Example 12287
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role AS (authz_role string)
RETURNS boolean ->
IS_ROLE_IN_SESSION(authz_role);

-- Example 12288
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role ON (authz_role);

-- Example 12289
CREATE OR REPLACE ROW ACCESS POLICY rap_authz_role_map AS (authz_role string)
RETURNS boolean ->
EXISTS (
  SELECT 1 FROM mapping_table m
  WHERE authz_role = m.key and IS_ROLE_IN_SESSION(m.role_name)
);

-- Example 12290
ALTER TABLE allowed_roles
  ADD ROW ACCESS POLICY rap_authz_role_map ON (authz_role);

-- Example 12291
USE DATABASE mounted_db;

-- Example 12292
SELECT * FROM mounted_db.myschema.mytable;

-- Example 12293
SELECT * FROM mydb.myschema.t WHERE IS_DATABASE_ROLE_IN_SESSION(AUTHZ_ROLE);

-- Example 12294
CREATE OR REPLACE MASKING POLICY mydb.policies.email_mask
  AS (val string) RETURNS string ->
  CASE
    WHEN IS_DATABASE_ROLE_IN_SESSION('ANALYST_DBROLE')
      THEN val
    WHEN IS_DATABASE_ROLE_IN_SESSION('SUPPORT_DBROLE')
      THEN REGEXP_REPLACE(val,'.+\@','*****@')
    ELSE '********'
  END
  COMMENT = 'use database role for shared data'
  ;

-- Example 12295
USE ROLE r1;
CREATE SHARE analyst_share;

-- Example 12296
USE ROLE r1;
GRANT USAGE ON DATABASE mydb TO SHARE analyst_share;
GRANT USAGE ON SCHEMA mydb.tables TO SHARE analyst_share;
GRANT SELECT ON TABLE mydb.tables.empl_info TO SHARE analyst_share;
GRANT DATABASE ROLE analyst_dbrole TO SHARE analyst_share;

-- Example 12297
ALTER SHARE analyst_share ADD ACCOUNTS = consumer_account;

-- Example 12298
USE ROLE ACCOUNTADMIN;
CREATE ROLE r1;

GRANT USAGE ON WAREHOUSE my_warehouse TO ROLE r1;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE r1;
GRANT IMPORT SHARE ON ACCOUNT TO ROLE r1;
GRANT ROLE r1 TO ROLE ACCOUNTADMIN;

-- Example 12299
USE ROLE r1;
CREATE DATABASE mounted_db FROM SHARE provider_account.analyst_share;

-- Example 12300
USE DATABASE mounted_db;
USE SCHEMA mounted_db.tables;

SELECT IS_DATABASE_ROLE_IN_SESSION('ANALYST_DBROLE');

-- Example 12301
SELECT * FROM empl_info;

-- Example 12302
USE ROLE r1;
CREATE SHARE analyst_policy_share;
CREATE SHARE analyst_table_share;

-- Example 12303
USE ROLE r1;
GRANT USAGE ON SCHEMA mydb2.tables TO SHARE analyst_table_share;
GRANT SELECT ON TABLE mydb2.tables.empl_info TO SHARE analyst_table_share;
GRANT DATABASE ROLE mydb2.analyst_dbrole TO SHARE analyst_table_share;

-- Example 12304
ALTER SHARE analyst_table_share ADD ACCOUNTS = consumer_account;

-- Example 12305
USE ROLE ACCOUNTADMIN;
CREATE ROLE r1;

GRANT USAGE ON WAREHOUSE my_warehouse TO ROLE r1;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE r1;
GRANT IMPORT SHARE ON ACCOUNT TO ROLE r1;
GRANT ROLE r1 TO ROLE ACCOUNTADMIN;

-- Example 12306
USE ROLE r1;
CREATE DATABASE mounted_db2 FROM SHARE provider_account.analyst_table_share;

-- Example 12307
USE DATABASE mounted_db2;
USE SCHEMA mounted_db2.tables;

SELECT IS_DATABASE_ROLE_IN_SESSION('ANALYST_DBROLE');

