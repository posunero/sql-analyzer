-- Example 11973
DESC SECURITY INTEGRATION my_idp;

-- Example 11974
DESC SECURITY INTEGRATION my_idp;

-- Example 11975
ALTER SECURITY INTEGRATION my_idp SET SAML2_REQUESTED_NAMEID_FORMAT = '<string_literal>';

-- Example 11976
DESC SECURITY INTEGRATION my_idp;

-- Example 11977
DESC SECURITY INTEGRATION my_idp;

-- Example 11978
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

-- Example 11979
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

-- Example 11980
ALTER SECURITY INTEGRATION my_idp SET SAML2_FORCE_AUTHN = true;

-- Example 11981
DESC SECURITY INTEGRATION my_idp;

-- Example 11982
ALTER SECURITY INTEGRATION my_idp SET SAML2_POST_LOGOUT_REDIRECT_URL = 'https://logout.example.com';

-- Example 11983
ALTER SECURITY INTEGRATION my_idp SET SAML2_X509_CERT = 'AX2bv...';

-- Example 11984
ALTER SECURITY INTEGRATION my_idp REFRESH SAML2_SNOWFLAKE_PRIVATE_KEY;

-- Example 11985
DESCRIBE SECURITY INTEGRATION my_idp;
SELECT "property_value" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
  WHERE "property" = 'SAML2_SNOWFLAKE_X509_CERT';

-- Example 11986
ALTER SECURITY INTEGRATION my_idp SET SAML2_SIGN_REQUEST = true;

-- Example 11987
ALTER SECURITY INTEGRATION my_idp SET SAML2_REQUESTED_NAMEID_FORMAT = 'urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified';

-- Example 11988
ALTER SECURITY INTEGRATION my_idp SET SAML2_FORCE_AUTHN = true;

-- Example 11989
ALTER SECURITY INTEGRATION my_idp UNSET SAML2_FORCE_AUTHN;

-- Example 11990
ALTER SECURITY INTEGRATION my_idp SET SAML2_POST_LOGOUT_REDIRECT_URL = 'https://logout.example.com';

-- Example 11991
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENABLE_IDENTIFIER_FIRST_LOGIN = true;

-- Example 11992
CREATE OR REPLACE SECURITY INTEGRATION entra_id_public
  TYPE = SAML2
  ENABLED = TRUE
  SAML2_ISSUER = '<microsoft_entra_identifier>/<application_id>'
  SAML2_SSO_URL = '<login_url>'
  SAML2_PROVIDER = 'CUSTOM'
  SAML2_X509_CERT = 'MIIC...TAs/'
  SAML2_SP_INITIATED_LOGIN_PAGE_LABEL = 'Entra ID SSO Public'
  SAML2_ENABLE_SP_INITIATED = TRUE
  SAML2_SNOWFLAKE_ACS_URL = 'https://<organization_name>-<account_name>.snowflakecomputing.com/fed/login'
  SAML2_SNOWFLAKE_ISSUER_URL = 'https://<organization_name>-<account_name>.snowflakecomputing.com';

-- Example 11993
alter account set allow_id_token = true;

-- Example 11994
pip install "snowflake-connector-python[secure-local-storage]"

-- Example 11995
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 11996
SAML response is invalid or matching user is not found. Contact your local system administrator. [eb55b777-50a4-4db5-b231-9ee457fb3981]

-- Example 11997
SELECT JSON_EXTRACT_PATH_TEXT(SYSTEM$GET_LOGIN_FAILURE_DETAILS('eb55b777-50a4-4db5-b231-9ee457fb3981'), 'errorCode');

-- Example 11998
desc security integration <integration_name>;

-- Example 11999
CREATE ROLE db_hr_r;
CREATE ROLE db_fin_r;
CREATE ROLE db_fin_rw;
CREATE ROLE accountant;
CREATE ROLE analyst;

-- Example 12000
-- Grant read-only permissions on database HR to db_hr_r role.
GRANT USAGE ON DATABASE hr TO ROLE db_hr_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE hr TO ROLE db_hr_r;
GRANT SELECT ON ALL TABLES IN DATABASE hr TO ROLE db_hr_r;

-- Grant read-only permissions on database FIN to db_fin_r role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_r;
GRANT SELECT ON ALL TABLES IN DATABASE fin TO ROLE db_fin_r;

-- Grant read-write permissions on database FIN to db_fin_rw role.
GRANT USAGE ON DATABASE fin TO ROLE db_fin_rw;
GRANT USAGE ON ALL SCHEMAS IN DATABASE fin TO ROLE db_fin_rw;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN DATABASE fin TO ROLE db_fin_rw;

-- Example 12001
GRANT ROLE db_fin_rw TO ROLE accountant;
GRANT ROLE db_hr_r TO ROLE analyst;
GRANT ROLE db_fin_r TO ROLE analyst;

-- Example 12002
GRANT ROLE accountant,analyst TO ROLE sysadmin;

-- Example 12003
GRANT ROLE accountant TO USER user1;
GRANT ROLE analyst TO USER user2;

-- Example 12004
-- Grant the SELECT privilege on all new (i.e. future) tables in a schema to role R1
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r1;

-- / Create tables in the schema /

-- Grant the SELECT privilege on all new tables in a schema to role R2
GRANT SELECT ON FUTURE TABLES IN SCHEMA s1 TO ROLE r2;

-- Grant the SELECT privilege on all existing tables in a schema to role R2
GRANT SELECT ON ALL TABLES IN SCHEMA s1 TO ROLE r2;

-- Revoke the SELECT privilege on all new tables in a schema (i.e. future grant) from role R1
REVOKE SELECT ON FUTURE TABLES IN SCHEMA s1 FROM ROLE r1;

-- Revoke the SELECT privilege on all existing tables in a schema from role R1
REVOKE SELECT ON ALL TABLES IN SCHEMA s1 FROM ROLE r1;

-- Example 12005
GRANT OWNERSHIP
  { ON {
            <object_type> <object_name>
          | ALL <object_type_plural> IN { DATABASE <database_name> | SCHEMA <schema_name> }
       }
    | ON FUTURE <object_type_plural> IN { DATABASE <database_name> | SCHEMA <schema_name> }
  }
  TO { ROLE <role_name> | DATABASE ROLE <database_role_name> }
  [ { REVOKE | COPY } CURRENT GRANTS ]

-- Example 12006
GRANT OWNERSHIP
  ON  <class_name> <instance_name>
  TO { ROLE <role_name> | DATABASE ROLE <database_role_name> }
  [ { REVOKE | COPY } CURRENT GRANTS ]

-- Example 12007
REVOKE ALL PRIVILEGES ON DATABASE mydb FROM ROLE manager;

GRANT OWNERSHIP ON DATABASE mydb TO ROLE analyst;

GRANT ALL PRIVILEGES ON DATABASE mydb TO ROLE analyst;

-- Example 12008
GRANT OWNERSHIP ON ALL TABLES IN SCHEMA mydb.public TO ROLE analyst COPY CURRENT GRANTS;

-- Example 12009
GRANT OWNERSHIP ON TABLE mydb.public.mytable TO ROLE analyst COPY CURRENT GRANTS;

-- Example 12010
GRANT OWNERSHIP ON ALL TABLES IN SCHEMA mydb.public
  TO DATABASE ROLE mydb.dr1
  COPY CURRENT GRANTS;

-- Example 12011
GRANT OWNERSHIP ON TABLE mydb.public.mytable
  TO ROLE mydb.dr1
  COPY CURRENT GRANTS;

-- Example 12012
REVOKE USAGE ON DATABASE mydb FROM SHARE myshare;
GRANT OWNERSHIP ON DATABASE mydb TO ROLE r2;
GRANT USAGE ON DATABASE mydb TO ROLE r2;

-- Example 12013
ALTER USER my_user UNSET DEFAULT_SECONDARY_ROLES;
ALTER USER my_user SET DEFAULT_SECONDARY_ROLES = ('ALL');

-- Example 12014
USE SECONDARY ROLES ALL;

-- Example 12015
USE DATABASE USER$bobr;
CREATE SCHEMA bobr_schema;
USE SCHEMA bobr_schema;

-- Example 12016
ALTER SCHEMA bobr_schema RENAME TO bobr_personal_schema;
SHOW TERSE SCHEMAS;

-- Example 12017
+-------------------------------+----------------------+------+---------------+-------------+
| created_on                    | name                 | kind | database_name | schema_name |
|-------------------------------+----------------------+------+---------------+-------------|
| 2024-10-28 19:33:18.437 -0700 | BOBR_PERSONAL_SCHEMA | NULL | USER$BOBR     | NULL        |
| 2024-10-29 14:11:33.267 -0700 | INFORMATION_SCHEMA   | NULL | USER$BOBR     | NULL        |
| 2024-10-28 12:47:21.502 -0700 | PUBLIC               | NULL | USER$BOBR     | NULL        |
+-------------------------------+----------------------+------+---------------+-------------+

-- Example 12018
CREATE NOTEBOOK bobr_prod_notebook
  FROM 'snow://notebook/USER$BOBR.PUBLIC.bobr_private_notebook/versions/version$1/'
  QUERY_WAREHOUSE = 'PUBLIC_WH'
  MAIN_FILE = 'notebook_app.ipynb'
  COMMENT = 'Duplicated from personal database';

-- Example 12019
Notebook BOBR_PROD_NOTEBOOK successfully created.

-- Example 12020
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES;

-- Example 12021
DESCRIBE NOTEBOOK USER$.PUBLIC.bobr_private_notebook;

-- Example 12022
SHOW DATABASES LIKE 'USER$BOBR';

-- Example 12023
CREATE ROLE CAN_VIEWMD COMMENT = 'This role can view metadata per SNOWFLAKE database role definitions';

-- Example 12024
GRANT DATABASE ROLE OBJECT_VIEWER TO ROLE CAN_VIEWMD;

-- Example 12025
GRANT ROLE CAN_VIEWMD TO USER smith;

-- Example 12026
SYSTEM$LOG('error', 'Error message');

-- Example 12027
artifacts:
  ...
  setup_script: scripts/setup.sql
  ...

-- Example 12028
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql

-- Example 12029
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql
    ├── scripts/secondary_script.sql
    ├── scripts/procs/setup_procs.sql
    ├── scripts/views/setup_views.sql
    ├── scripts/data/setup_data.sql

-- Example 12030
...
EXECUTE IMMEDIATE FROM 'secondary_script.sql';
EXECUTE IMMEDIATE FROM './procs/setup_procs.sql';
EXECUTE IMMEDIATE FROM '../scripts/views/setup_views.sql';
EXECUTE IMMEDIATE FROM '/scripts/data/setup_data.sql';
...

-- Example 12031
CREATE SCHEMA IF NOT EXISTS app_config;
CREATE TABLE IF NOT EXISTS app_config.params(...);

-- Example 12032
CREATE OR REPLACE PROCEDURE app_state.proc()...;
GRANT USAGE ON PROCEDURE app_state.proc()
  TO APPLICATION ROLE app_user;

-- Example 12033
A TAG in a versioned schema can only be assigned to the objects in the same schema. An object in a versioned schema can only have a TAG assigned that is defined in the same schema.

-- Example 12034
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

-- Example 12035
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN ACCOUNT;

-- Example 12036
SHOW PARAMETERS LIKE 'TIMESTAMP_INPUT_FORMAT' IN ACCOUNT;

-- Example 12037
CREATE SERVICE echo_service
   IN COMPUTE POOL tutorial_compute_pool
   FROM SPECIFICATION $$
   spec:
     containers:
     - name: echo
       image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:tutorial
       readinessProbe:
         port: 8000
         path: /healthcheck
     endpoints:
     - name: echoendpoint
       port: 8000
       public: true
   $$;

-- Example 12038
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM @tutorial_stage
  SPECIFICATION_FILE='echo_spec.yaml';

-- Example 12039
EXECUTE JOB SERVICE
   IN COMPUTE POOL tutorial_compute_pool
   NAME = example_job_service
   FROM SPECIFICATION $$
   spec:
     container:
     - name: main
       image: /tutorial_db/data_schema/tutorial_repository/my_job_image:latest
       env:
         SNOWFLAKE_WAREHOUSE: tutorial_warehouse
       args:
       - "--query=select current_time() as time,'hello'"
       - "--result_table=results"
   $$;

