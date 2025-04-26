-- Example 19207
EXECUTE NOTEBOOK my_notebook();

-- Example 19208
EXECUTE TASK <name>

EXECUTE TASK <name> RETRY LAST

-- Example 19209
EXECUTE TASK mytask;

-- Example 19210
GRANT CALLER <object_privilege> [ , <object_privilege> ... ]
  ON <object_type> <object_name>
  TO { ROLE | DATABASE ROLE } <grantee_name>

GRANT ALL CALLER PRIVILEGES
  ON <object_type> <object_name>
  TO { ROLE | DATABASE ROLE } <grantee_name>

GRANT INHERITED CALLER <object_privilege> [ , <object_privilege> ... ]
  ON ALL <object_type_plural>
  IN { ACCOUNT | DATABASE <db_name> | SCHEMA <schema_name> | APPLICATION <app_name> | APPLICATION PACKAGE <app_pkg_name> }
  TO { ROLE | DATABASE ROLE } <grantee_name>

GRANT ALL INHERITED CALLER PRIVILEGES
  ON ALL <object_type_plural>
  IN { ACCOUNT | DATABASE <db_name> | SCHEMA <schema_name> | APPLICATION <app_name> | APPLICATION PACKAGE <app_pkg_name> }
  TO { ROLE | DATABASE ROLE } <grantee_name>

-- Example 19211
GRANT CALLER SELECT ON VIEW v1 TO owner_role;

-- Example 19212
GRANT INHERITED CALLER SELECT, INSERT ON ALL TABLES IN SCHEMA db.sch TO ROLE owner_role;

-- Example 19213
GRANT ALL INHERITED CALLER PRIVILEGES ON ALL SCHEMAS IN ACCOUNT TO ROLE owner_role;

-- Example 19214
GRANT CALLER SELECT ON TABLE db.sch1.t1 TO DATABASE ROLE db.r;

-- Example 19215
GRANT ALL CALLER PRIVILEGES ON DATABASE my_db TO ROLE owner_role;

-- Example 19216
CREATE OR REPLACE PROCEDURE sp_pi()
  RETURNS FLOAT NOT NULL
  LANGUAGE JAVASCRIPT
  EXECUTE AS RESTRICTED CALLER
  AS
  $$
  RETURN 3.1415926;
  $$
  ;

-- Example 19217
GRANT CALLER SELECT ON VIEW v1 TO owner_role;

-- Example 19218
GRANT INHERITED CALLER SELECT, INSERT ON ALL TABLES IN SCHEMA db.sch TO ROLE owner_role;

-- Example 19219
GRANT ALL INHERITED CALLER PRIVILEGES ON ALL SCHEMAS IN ACCOUNT TO ROLE owner_role;

-- Example 19220
GRANT CALLER SELECT ON TABLE db.sch1.t1 TO DATABASE ROLE db.r;

-- Example 19221
GRANT ALL CALLER PRIVILEGES ON DATABASE my_db TO ROLE owner_role;

-- Example 19222
REVOKE ALL INHERITED CALLER PRIVILEGES ON ALL VIEWS IN ACCOUNT FROM ROLE owner_role;

-- Example 19223
REVOKE CALLER USAGE ON SCHEMA db.sch1 FROM ROLE owner_role;

-- Example 19224
SHOW CALLER GRANTS ON TABLE t1;

-- Example 19225
SHOW CALLER GRANTS ON ACCOUNT;

-- Example 19226
SHOW CALLER GRANTS TO DATABASE ROLE db.owner_role;

-- Example 19227
GRANT DATABASE ROLE <name>
  TO SHARE <share_name>

-- Example 19228
GRANT SELECT ON FUTURE TABLES IN SCHEMA sh TO DATABASE ROLE dbr1;
GRANT DATABASE ROLE dbr1 TO SHARE myshare;

-- Example 19229
Cannot share a database role with future grants to it.

-- Example 19230
GRANT DATABASE ROLE dbr1 TO SHARE myshare;
GRANT SELECT ON FUTURE TABLES IN SCHEMA sh TO DATABASE ROLE dbr1;

-- Example 19231
Cannot grant future grants to a database role that is granted to a share.

-- Example 19232
SHOW FUTURE GRANTS IN DATABASE parent_db;
SHOW FUTURE GRANTS IN shared_schema;

-- Example 19233
GRANT DATABASE ROLE d1.dr1 TO SHARE share1;

-- Example 19234
GRANT {  { globalPrivileges } ON ACCOUNT
       | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | CONNECTION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME } <object_name>
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
      }
    TO APPLICATION <name>

-- Example 19235
globalPrivileges ::=
  {
      CREATE {
       COMPUTE POOL | DATABASE | WAREHOUSE
      }
      | BIND SERVICE ENDPOINT
      | EXECUTE MANAGED TASK
      | MANAGE WAREHOUSES
      | READ SESSION
  }
  [ , ... ]

-- Example 19236
accountObjectPrivileges ::=
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
-- For REPLICATION GROUP
   { MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For RESOURCE MONITOR
   { MODIFY | MONITOR } [ , ... ]
-- For USER
   { MONITOR } [ , ... ]
-- For WAREHOUSE
   { APPLYBUDGET | MODIFY | MONITOR | USAGE | OPERATE } [ , ... ]

-- Example 19237
schemaPrivileges ::=
ADD SEARCH OPTIMIZATION
| CREATE {
    ALERT | EXTERNAL TABLE | FILE FORMAT | FUNCTION
    | IMAGE REPOSITORY | MATERIALIZED VIEW | PIPE | PROCEDURE
    | { AGGREGATION | MASKING | PASSWORD | PROJECTION | ROW ACCESS | SESSION } POLICY
    | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM
    | TAG | TABLE | TASK | VIEW
  }
| MODIFY | MONITOR | USAGE
[ , ... ]

-- Example 19238
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DYNAMIC TABLE
     OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { INSERT | SELECT } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { AGGREGATION | MASKING | PACKAGES | PASSWORD | PROJECTION | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     READ, USAGE [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]

-- Example 19239
GRANT SELECT ON VIEW data.views.credit_usage
  TO APPLICATION app_snowflake_credits;

-- Example 19240
GRANT {
        { schemaPrivileges         | ALL [ PRIVILEGES ] } ON SCHEMA <schema_name>
        | { schemaObjectPrivileges | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
        | { schemaObjectPrivileges | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN SCHEMA <schema_name>
      }
    TO APPLICATION ROLE <name> [ WITH GRANT OPTION ]

-- Example 19241
schemaPrivileges ::=
ADD SEARCH OPTIMIZATION
| CREATE {
    ALERT | EXTERNAL TABLE | FILE FORMAT | FUNCTION
    | IMAGE REPOSITORY | MATERIALIZED VIEW | PIPE | PROCEDURE
    | { AGGREGATION | MASKING | PASSWORD | PROJECTION | ROW ACCESS | SESSION } POLICY
    | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM
    | TAG | TABLE | TASK | VIEW
  }
| MODIFY | MONITOR | USAGE
[ , ... ]

-- Example 19242
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DYNAMIC TABLE
     OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { INSERT | SELECT } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { AGGREGATION | MASKING | PACKAGES | PASSWORD | PROJECTION | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     READ, USAGE [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]

-- Example 19243
<udf_or_stored_procedure_name> ( [ <arg_data_type> [ , ... ] ] )

-- Example 19244
SHOW OBJECTS OWNED BY APPLICATION myapp;

-- Example 19245
GRANT SELECT ON VIEW data.views.credit_usage
  TO APPLICATION ROLE app_snowflake_credits;

-- Example 19246
GRANT objectPrivilege ON
     {  DATABASE <name>
      | SCHEMA <name>
      | FUNCTION <name>
      | SEMANTIC VIEW <name>
      | { TABLE <name> | ALL TABLES IN SCHEMA <schema_name> }
      | { EXTERNAL TABLE <name> | ALL EXTERNAL TABLES IN SCHEMA <schema_name> }
      | { ICEBERG TABLE <name> | ALL ICEBERG TABLES IN SCHEMA <schema_name> }
      | { DYNAMIC TABLE <name> | ALL DYNAMIC TABLES IN SCHEMA <schema_name> }
      | TAG <name>
      | VIEW <name>  }
  TO SHARE <share_name>

-- Example 19247
objectPrivilege ::=
-- For DATABASE
   REFERENCE_USAGE [ , ... ]
-- For DATABASE, FUNCTION, or SCHEMA
   USAGE [ , ... ]
-- For SEMANTIC VIEW
   REFERENCES [ , ... ]
-- For TABLE
   EVOLVE SCHEMA [ , ... ]
-- For EXTERNAL TABLE, ICEBERG TABLE, TABLE, or VIEW
   SELECT [ , ... ]
-- For TAG
   READ

-- Example 19248
GRANT USAGE ON DATABASE mydb TO SHARE share1;

GRANT USAGE ON SCHEMA mydb.public TO SHARE share1;

GRANT USAGE ON FUNCTION mydb.shared_schema.function1 TO SHARE share1;

GRANT USAGE ON FUNCTION mydb.shared_schema.function2 TO SHARE share1;

GRANT SELECT ON ALL TABLES IN SCHEMA mydb.public TO SHARE share1;

GRANT SELECT ON ALL EXTERNAL TABLES IN SCHEMA mydb.public TO SHARE share1;

GRANT SELECT ON ALL ICEBERG TABLES IN SCHEMA mydb.public TO SHARE share1;

GRANT SELECT ON ALL DYNAMIC TABLES IN SCHEMA mydb.public TO SHARE share1;

GRANT USAGE ON SCHEMA mydb.shared_schema TO SHARE share1;

GRANT SELECT ON VIEW mydb.shared_schema.view1 TO SHARE share1;

GRANT SELECT ON VIEW mydb.shared_schema.view3 TO SHARE share1;

GRANT SELECT ON ICEBERG TABLE mydb.shared_schema.iceberg_table_1 TO SHARE share1;

GRANT SELECT ON DYNAMIC TABLE mydb.public TO SHARE share1;

-- Example 19249
CREATE SECURE VIEW view2 AS SELECT * FROM database2.public.sampletable;

GRANT USAGE ON DATABASE database1 TO SHARE share1;

GRANT USAGE ON SCHEMA database1.schema1 TO SHARE share1;

GRANT REFERENCE_USAGE ON DATABASE database2 TO SHARE share1;

GRANT SELECT ON VIEW view2 TO SHARE share1;

-- Example 19250
GRANT SERVICE ROLE <name> TO
{
  ROLE <role_name>                     |
  APPLICATION ROLE <application_role_name>  |
  DATABASE ROLE <database_role_name>
}

-- Example 19251
GRANT SERVICE ROLE echo_service!echoendpoint_role TO ROLE service_function_user_role;

-- Example 19252
REVOKE CALLER <object_privilege> [ , <object_privilege> ... ]
  ON <object_type> <object_name>
  FROM { ROLE | DATABASE ROLE } <grantee_name>

REVOKE ALL CALLER PRIVILEGES
  ON <object_type> <object_name>
  FROM { ROLE | DATABASE ROLE } <grantee_name>

REVOKE INHERITED CALLER <object_privilege> [ , <object_privilege> ... ]
  ON ALL <object_type_plural>
  IN { ACCOUNT | DATABASE <db_name> | SCHEMA <schema_name> | APPLICATION <app_name> | APPLICATION PACKAGE <app_pkg_name> }
  FROM { ROLE | DATABASE ROLE } <grantee_name>

REVOKE ALL INHERITED CALLER PRIVILEGES
  ON ALL <object_type_plural>
  IN { ACCOUNT | DATABASE <db_name> | SCHEMA <schema_name> | APPLICATION <app_name> | APPLICATION PACKAGE <app_pkg_name> }
  FROM { ROLE | DATABASE ROLE } <grantee_name>

-- Example 19253
REVOKE ALL INHERITED CALLER PRIVILEGES ON ALL VIEWS IN ACCOUNT FROM ROLE owner_role;

-- Example 19254
REVOKE CALLER USAGE ON SCHEMA db.sch1 FROM ROLE owner_role;

-- Example 19255
REVOKE DATABASE ROLE <name> FROM { ROLE | DATABASE ROLE } <parent_role_name>

-- Example 19256
REVOKE DATABASE ROLE analyst FROM ROLE SYSADMIN;

-- Example 19257
REVOKE DATABASE ROLE dr1 FROM DATABASE ROLE dr2;

-- Example 19258
REVOKE DATABASE ROLE <name>
  FROM SHARE <share_name>

-- Example 19259
REVOKE DATABASE ROLE d1.dr1 FROM SHARE share1;

-- Example 19260
REVOKE {  { globalPrivileges } ON ACCOUNT
        | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | CONNECTION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME } <object_name>
        | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
        | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
       }
     FROM APPLICATION <name>

-- Example 19261
globalPrivileges ::=
  {
      CREATE {
       COMPUTE POOL | DATABASE | WAREHOUSE
      }
      | BIND SERVICE ENDPOINT
      | EXECUTE MANAGED TASK
      | MANAGE WAREHOUSES
      | READ SESSION
  }
  [ , ... ]

-- Example 19262
accountObjectPrivileges ::=
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
-- For REPLICATION GROUP
   { MODIFY | MONITOR | REPLICATE } [ , ... ]
-- For RESOURCE MONITOR
   { MODIFY | MONITOR } [ , ... ]
-- For USER
   { MONITOR } [ , ... ]
-- For WAREHOUSE
   { APPLYBUDGET | MODIFY | MONITOR | USAGE | OPERATE } [ , ... ]

-- Example 19263
schemaPrivileges ::=
ADD SEARCH OPTIMIZATION
| CREATE {
    ALERT | EXTERNAL TABLE | FILE FORMAT | FUNCTION
    | IMAGE REPOSITORY | MATERIALIZED VIEW | PIPE | PROCEDURE
    | { AGGREGATION | MASKING | PASSWORD | PROJECTION | ROW ACCESS | SESSION } POLICY
    | SECRET | SEQUENCE | SERVICE | SNAPSHOT | STAGE | STREAM
    | TAG | TABLE | TASK | VIEW
  }
| MODIFY | MONITOR | USAGE
[ , ... ]

-- Example 19264
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DYNAMIC TABLE
     OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { INSERT | SELECT } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { MASKING | PACKAGES | PASSWORD | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     READ, USAGE [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]

-- Example 19265
REVOKE SELECT ON VIEW data.views.credit_usage
  FROM APPLICATION app_snowflake_credits;

-- Example 19266
REVOKE [ GRANT OPTION FOR ]
    {
    | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
    | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
    | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN SCHEMA <schema_name> }
    | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
    }
  FROM APPLICATION ROLE <name> [ RESTRICT | CASCADE ]

-- Example 19267
schemaObjectPrivileges ::=
  -- For ALERT
     { MONITOR | OPERATE } [ , ... ]
  -- For DYNAMIC TABLE
     OPERATE, SELECT [ , ...]
  -- For EVENT TABLE
     { INSERT | SELECT } [ , ... ]
  -- For FILE FORMAT, FUNCTION (UDF or external function), PROCEDURE, SECRET, SEQUENCE, or SNAPSHOT
     USAGE [ , ... ]
  -- For IMAGE REPOSITORY
     { READ, WRITE } [ , ... ]
  -- For PIPE
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For { MASKING | PACKAGES | PASSWORD | ROW ACCESS | SESSION } POLICY or TAG
     APPLY [ , ... ]
  -- For SECRET
     READ, USAGE [ , ... ]
  -- For SERVICE
     { MONITOR | OPERATE } [ , ... ]
  -- For external STAGE
     USAGE [ , ... ]
  -- For internal STAGE
     READ [ , WRITE ] [ , ... ]
  -- For STREAM
     SELECT [ , ... ]
  -- For TABLE
     { APPLYBUDGET | DELETE | EVOLVE SCHEMA | INSERT | REFERENCES | SELECT | TRUNCATE | UPDATE } [ , ... ]
  -- For TAG
     READ
  -- For TASK
     { APPLYBUDGET | MONITOR | OPERATE } [ , ... ]
  -- For VIEW
     { REFERENCES | SELECT } [ , ... ]
  -- For MATERIALIZED VIEW
     { APPLYBUDGET | REFERENCES | SELECT } [ , ... ]

-- Example 19268
REVOKE SELECT ON VIEW data.views.credit_usage
  FROM APPLICATION ROLE app_snowflake_credits;

-- Example 19269
REVOKE objectPrivilege ON
     {  DATABASE <name>
      | SCHEMA <name>
      | SEMANTIC VIEW <name>
      | { TABLE <name> | ALL TABLES IN SCHEMA <schema_name> }
      | { EXTERNAL TABLE <name> | ALL EXTERNAL TABLES IN SCHEMA <schema_name> }
      | { ICEBERG TABLE <name> | ALL ICEBERG TABLES IN SCHEMA <schema_name> }
      | { DYNAMIC TABLE <name> | ALL DYNAMIC TABLES IN SCHEMA <schema_name> }
      | { VIEW <name> | ALL VIEWS IN SCHEMA <schema_name> }  }
  FROM SHARE <share_name>

-- Example 19270
objectPrivilege ::=
-- For DATABASE
   REFERENCE_USAGE [ , ... ]
-- For DATABASE, FUNCTION, or SCHEMA
   USAGE [ , ... ]
-- For SEMANTIC VIEW
   REFERENCES [ , ... ]
-- For TABLE
   EVOLVE SCHEMA [ , ... ]
-- For EXTERNAL TABLE, ICEBERG TABLE, TABLE, or VIEW
   SELECT [ , ... ]
-- For TAG
   READ

-- Example 19271
REVOKE SELECT ON VIEW mydb.shared_schema.view1 FROM SHARE share1;

REVOKE SELECT ON VIEW mydb.shared_schema.view3 FROM SHARE share1;

REVOKE USAGE ON SCHEMA mydb.shared_schema FROM SHARE share1;

REVOKE SELECT ON ALL TABLES IN SCHEMA mydb.public FROM SHARE share1;

REVOKE SELECT ON ALL ICEBERG TABLES IN SCHEMA mydb.public FROM SHARE share1;

REVOKE SELECT ON ALL DYNAMIC TABLES IN SCHEMA mydb.public FROM SHARE share1;

REVOKE SELECT ON ICEBERG TABLE mydb.shared_schema.iceberg_table_1 FROM SHARE share1;

REVOKE SELECT ON DYNAMIC TABLE mydb TO SHARE share1;

REVOKE USAGE ON SCHEMA mydb.public FROM SHARE share1;

REVOKE USAGE ON DATABASE mydb FROM SHARE share1;

-- Example 19272
REVOKE REFERENCE_USAGE ON DATABASE database2 FROM SHARE share1;

-- Example 19273
REVOKE ROLE <name> FROM { ROLE <parent_role_name> | USER <user_name> }

