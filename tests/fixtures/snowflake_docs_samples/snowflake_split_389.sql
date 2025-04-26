-- Example 26038
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/cc2909f2-ed22-4c89-8e5d-bdc40e5eac26/resourceGroups/mystorage/providers/Microsoft.Storage/storageAccounts/storagedemo',
  'mystorageaccount.blob.core.windows.net',
  'blob'
);

-- Example 26039
CREATE EXTERNAL VOLUME exvol
  STORAGE_LOCATIONS =
    (
      (
        NAME = 'my-azure-northeurope'
        STORAGE_PROVIDER = 'AZURE'
        STORAGE_BASE_URL = 'azure://exampleacct.blob.core.windows.net/my_container_northeurope/'
        AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
        USE_PRIVATELINK_ENDPOINT = TRUE
      )
    );

-- Example 26040
USE ROLE USERADMIN;

CREATE ROLE policy_admin;

-- Example 26041
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE mydb TO ROLE policy_admin;

GRANT USAGE, CREATE SESSION POLICY ON SCHEMA mydb.policies TO ROLE policy_admin;

GRANT APPLY SESSION POLICY ON ACCOUNT TO ROLE policy_admin;

-- Example 26042
GRANT APPLY SESSION POLICY ON USER jsmith TO ROLE policy_admin;

-- Example 26043
USE ROLE policy_admin;

CREATE SESSION POLICY mydb.policies.session_policy_prod_1
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  COMMENT = 'Session policy for the prod_1 environment';

-- Example 26044
USE ROLE policy_admin;

ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_1;

ALTER USER jsmith SET SESSION POLICY my_database.my_schema.session_policy_prod_1;

-- Example 26045
ALTER ACCOUNT UNSET session policy;

ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_2;

-- Example 26046
CREATE OR REPLACE SESSION POLICY prod_env_session_policy
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  ALLOWED_SECONDARY_ROLES = ('ALL')
  COMMENT = 'session policy for use in the prod_1 environment';

-- Example 26047
ALTER SESSION POLICY prod_env_session_policy
  SET ALLOWED_SECONDARY_ROLES = ();

-- Example 26048
ALTER SESSION POLICY prod_env_session_policy
  UNSET ALLOWED_SECONDARY_ROLES;

-- Example 26049
ALTER SESSION POLICY prod_env_session_policy SET ALLOWED_SECONDARY_ROLES = ();

-- Example 26050
ALTER ACCOUNT SET SESSION POLICY prod_env_session_policy;

-- Example 26051
SQL execution error: USE SECONDARY ROLES '[ANALYST]' not allowed as per session policy.

-- Example 26052
ALTER USER jsmith SET SESSION POLICY prod_env_session_policy;

-- Example 26053
SQL execution error: USE SECONDARY ROLES '[ANALYST, DATA_SCIENTIST]' not allowed as per session policy.

-- Example 26054
CREATE OR REPLACE SESSION POLICY prod_env_session_policy
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  ALLOWED_SECONDARY_ROLES = (DATA_SCIENTIST, ANALYST)
  COMMENT = 'session policy for user secondary roles data_scientist and analyst';

-- Example 26055
ALTER USER bsmith SET SESSION POLICY prod_env_session_policy;

-- Example 26056
USE SECONDARY ROLES ALL;

-- Example 26057
USE SECONDARY ROLES DATA_SCIENTIST;

-- Example 26058
ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_1;

-- Example 26059
ALTER ACCOUNT UNSET SESSION POLICY;

-- Example 26060
ALTER USER jsmith SET SESSION POLICY mydb.policies.session_policy_prod_1_jsmith;

-- Example 26061
ALTER USER jsmith UNSET SESSION POLICY;

-- Example 26062
POLICY_REFERENCES( POLICY_NAME => '<session_policy_name>' )

-- Example 26063
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'my_db.my_schema.session_policy_prod_1'
  ));

-- Example 26064
USE ROLE USERADMIN;

CREATE ROLE policy_admin;

-- Example 26065
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE mydb TO ROLE policy_admin;

GRANT USAGE, CREATE SESSION POLICY ON SCHEMA mydb.policies TO ROLE policy_admin;

GRANT APPLY SESSION POLICY ON ACCOUNT TO ROLE policy_admin;

-- Example 26066
GRANT APPLY SESSION POLICY ON USER jsmith TO ROLE policy_admin;

-- Example 26067
USE ROLE policy_admin;

CREATE SESSION POLICY mydb.policies.session_policy_prod_1
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  COMMENT = 'Session policy for the prod_1 environment';

-- Example 26068
USE ROLE policy_admin;

ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_1;

ALTER USER jsmith SET SESSION POLICY my_database.my_schema.session_policy_prod_1;

-- Example 26069
ALTER ACCOUNT UNSET session policy;

ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_2;

-- Example 26070
CREATE OR REPLACE SESSION POLICY prod_env_session_policy
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  ALLOWED_SECONDARY_ROLES = ('ALL')
  COMMENT = 'session policy for use in the prod_1 environment';

-- Example 26071
ALTER SESSION POLICY prod_env_session_policy
  SET ALLOWED_SECONDARY_ROLES = ();

-- Example 26072
ALTER SESSION POLICY prod_env_session_policy
  UNSET ALLOWED_SECONDARY_ROLES;

-- Example 26073
ALTER SESSION POLICY prod_env_session_policy SET ALLOWED_SECONDARY_ROLES = ();

-- Example 26074
ALTER ACCOUNT SET SESSION POLICY prod_env_session_policy;

-- Example 26075
SQL execution error: USE SECONDARY ROLES '[ANALYST]' not allowed as per session policy.

-- Example 26076
ALTER USER jsmith SET SESSION POLICY prod_env_session_policy;

-- Example 26077
SQL execution error: USE SECONDARY ROLES '[ANALYST, DATA_SCIENTIST]' not allowed as per session policy.

-- Example 26078
CREATE OR REPLACE SESSION POLICY prod_env_session_policy
  SESSION_IDLE_TIMEOUT_MINS = 30
  SESSION_UI_IDLE_TIMEOUT_MINS = 30
  ALLOWED_SECONDARY_ROLES = (DATA_SCIENTIST, ANALYST)
  COMMENT = 'session policy for user secondary roles data_scientist and analyst';

-- Example 26079
ALTER USER bsmith SET SESSION POLICY prod_env_session_policy;

-- Example 26080
USE SECONDARY ROLES ALL;

-- Example 26081
USE SECONDARY ROLES DATA_SCIENTIST;

-- Example 26082
$ SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 26083
$ snowsql --bootstrap-version

-- Example 26084
$ curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/linux_x86_64/snowsql-<version>-linux_x86_64.bash

-- Example 26085
$ curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/linux_x86_64/snowsql-<version>-linux_x86_64.bash

-- Example 26086
$ curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash

-- Example 26087
$ curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash

-- Example 26088
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 26089
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 26090
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 26091
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 26092
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 26093
gpg: keyserver receive failed: Server indicated a failure

-- Example 26094
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 26095
# If you prefer to use curl to download the signature file, run this command:
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash.sig

# Verify the package signature.
gpg --verify snowsql-1.3.3-linux_x86_64.bash.sig snowsql-1.3.3-linux_x86_64.bash

-- Example 26096
# If you prefer to use curl to download the signature file, run this command:
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowsql-1.3.3-linux_x86_64.bash.sig

# Verify the package signature.
gpg --verify snowsql-1.3.3-linux_x86_64.bash.sig snowsql-1.3.3-linux_x86_64.bash

-- Example 26097
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 26098
gpg --delete-key "Snowflake Computing"

-- Example 26099
bash snowsql-linux_x86_64.bash

-- Example 26100
SNOWSQL_DEST=~/bin SNOWSQL_LOGIN_SHELL=~/.profile bash snowsql-linux_x86_64.bash

-- Example 26101
snowsql -v

-- Example 26102
Version: 1.3.1

-- Example 26103
snowsql -v 1.3.0

-- Example 26104
rpm -i <package_name>

