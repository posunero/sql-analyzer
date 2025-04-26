-- Example 23894
select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 23895
use role accountadmin;
grant ownership on user <user_name> to role okta_provisioner;

-- Example 23896
alter security integration okta_provisioning set network_policy = <scim_network_policy>;

-- Example 23897
alter security integration okta_provisioning unset network_policy;

-- Example 23898
grant ownership on user <username> to role OKTA_PROVISIONER;

-- Example 23899
use role accountadmin;
use database demo_db;
use schema information_schema;
select * from table(rest_event_history('scim'));
select *
    from table(rest_event_history(
        'scim',
        dateadd('minutes',-5,current_timestamp()),
        current_timestamp(),
        200))
    order by event_timestamp;

-- Example 23900
Error authenticating: Forbidden. Errors reported by remote server: Invalid JSON: Unexpected character ('<' (code 60)): expected a valid value (number, String, array, object, 'true', 'false' or 'null') at [Source: java.io.StringReader@4c76ba04; line: 1, column: 2]

-- Example 23901
use role accountadmin;
create role if not exists aad_provisioner;
grant create user on account to role aad_provisioner;
grant create role on account to role aad_provisioner;
grant role aad_provisioner to role accountadmin;
create or replace security integration aad_provisioning
    type = scim
    scim_client = 'azure'
    run_as_role = 'AAD_PROVISIONER';
select system$generate_scim_access_token('AAD_PROVISIONING');

-- Example 23902
use role accountadmin;

-- Example 23903
create role if not exists aad_provisioner;
grant create user on account to role aad_provisioner;
grant create role on account to role aad_provisioner;

-- Example 23904
grant role aad_provisioner to role accountadmin;
create or replace security integration aad_provisioning
    type=scim
    scim_client='azure'
    run_as_role='AAD_PROVISIONER';

-- Example 23905
select system$generate_scim_access_token('AAD_PROVISIONING');

-- Example 23906
alter security integration aad_provisioning set network_policy = <scim_network_policy>;

-- Example 23907
alter security integration aad_provisioning unset network_policy;

-- Example 23908
use role accountadmin;
use database demo_db;
use schema information_schema;
select * from table(rest_event_history('scim'));
select *
    from table(rest_event_history(
        'scim',
        dateadd('minutes',-5,current_timestamp()),
        current_timestamp(),
        200))
    order by event_timestamp;

-- Example 23909
grant ownership on user <username> to role AAD_PROVISIONER;

-- Example 23910
use role accountadmin;
create role if not exists generic_scim_provisioner;
grant create user on account to role generic_scim_provisioner;
grant create role on account to role generic_scim_provisioner;
grant role generic_scim_provisioner to role accountadmin;
create or replace security integration generic_scim_provisioning
    type=scim
    scim_client='generic'
    run_as_role='GENERIC_SCIM_PROVISIONER';
select system$generate_scim_access_token('GENERIC_SCIM_PROVISIONING');

-- Example 23911
use role accountadmin;

-- Example 23912
create role if not exists generic_scim_provisioner;
grant create user on account to role generic_scim_provisioner;
grant create role on account to role generic_scim_provisioner;

-- Example 23913
grant role generic_scim_provisioner to role accountadmin;
create or replace security integration generic_scim_provisioning
    type = scim
    scim_client = 'generic'
    run_as_role = 'GENERIC_SCIM_PROVISIONER';

-- Example 23914
select system$generate_scim_access_token('GENERIC_SCIM_PROVISIONING');

-- Example 23915
alter security integration generic_scim_provisioning set network_policy = <scim_network_policy>;

-- Example 23916
alter security integration generic_scim_provisioning unset network_policy;

-- Example 23917
{
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User",
    "urn:ietf:params:scim:schemas:extension:2.0:User"
  ],
  "userName": "test_user_1",
  "password": "test",
  "name": {
    "givenName": "test",
    "familyName": "user"
  },
  "emails": [
    {"value": "test.user@snowflake.com"}
  ],
  "displayName": "test user",
  "active": true
}

-- Example 23918
{
  "active": true,
  "displayName": "test user",
  "emails": [
    {"value": "test.user@snowflake.com"}
  ],
  "name": {
    "familyName": "test_last_name",
    "givenName": "test_first_name"
  },
  "password": "test_password",
  "schemas": [
    "urn:ietf:params:scim:schemas:core:2.0:User",
    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
  ],
  "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
    "snowflakeUserName": "USER5"
  },
  "userName": "USER5"
}

-- Example 23919
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {"op": "replace", "value": { "active": false }}
    {"op": "replace", "value": { "givenName": "deactivated_user" }}
  ],
}

-- Example 23920
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [
    {"op": "replace", "value": { "active": false }}
  ]
}

-- Example 23921
{
  "Operations": [
    {
      "op": "replace",
      "path": "userName",
      "value": "test_updated_name"
    },
    {
      "op": "replace",
      "path": "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User.snowflakeUserName",
      "value": "USER5"
    }
  ],
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"]
}

-- Example 23922
{
  "schemas": [
   "urn:ietf:params:scim:schemas:core:2.0:User",
   "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
  ],
  "userName": "test_user_1",
  "password": "test",
  "name": {
    "givenName": "test",
    "familyName": "user"
  },
  "emails": [{
    "primary": true,
    "value": "test.user@snowflake.com",
    "type": "work"
  }
  ],
  "displayName": "test user",
  "active": true,
  "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
    "defaultRole" : "test_role",
    "defaultSecondaryRoles" : "ALL",
    "defaultWarehouse" : "test_warehouse"
  }
}

-- Example 23923
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:Group"],
  "displayName":"scim_test_group2"
}

-- Example 23924
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [{
    "op": "replace",
    "value": { "displayName": "updated_name" }
  },
  {
    "op" : "remove",
    "path": "members[value eq \"user_id_1\"]"
  },
  {
    "op": "add",
    "value": [{ "value": "user_id_2" }]
  }]
}

-- Example 23925
CREATE [OR REPLACE] EXTERNAL ACCESS INTEGRATION pypi_access
  ALLOWED_NETWORK_RULES = (snowflake.external_access.pypi_rule)
  ENABLED = true;

-- Example 23926
CREATE OR REPLACE ROLE developer;

-- Example 23927
GRANT USAGE ON INTEGRATION pypi_access TO ROLE developer;

-- Example 23928
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 23929
CREATE OR REPLACE SECURITY INTEGRATION google_translate_oauth
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_ID = 'my-client-id'
  OAUTH_CLIENT_SECRET = 'my-client-secret'
  OAUTH_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token'
  OAUTH_AUTHORIZATION_ENDPOINT = 'https://accounts.google.com/o/oauth2/auth'
  OAUTH_ALLOWED_SCOPES = ('https://www.googleapis.com/auth/cloud-platform')
  ENABLED = TRUE;

-- Example 23930
USE DATABASE my_db;
USE SCHEMA secret_schema;

CREATE OR REPLACE SECRET oauth_token
  TYPE = oauth2
  API_AUTHENTICATION = google_translate_oauth;

-- Example 23931
CALL SYSTEM$START_OAUTH_FLOW( 'my_db.secret_schema.oauth_token' );

-- Example 23932
CALL SYSTEM$FINISH_OAUTH_FLOW( 'state=<remaining_url_text>' );

-- Example 23933
CREATE OR REPLACE SECRET oauth_token
  TYPE = oauth2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 23934
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = TRUE;

-- Example 23935
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 23936
GRANT READ ON SECRET oauth_token TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE developer;

-- Example 23937
USE ROLE developer;

CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'get_translation'
  EXTERNAL_ACCESS_INTEGRATIONS = (google_apis_access_integration)
  PACKAGES = ('snowflake-snowpark-python','requests')
  SECRETS = ('cred' = oauth_token )
AS $$
import _snowflake
import requests
import json
session = requests.Session()
def get_translation(sentence, language):
  token = _snowflake.get_oauth_access_token('cred')
  url = "https://translation.googleapis.com/language/translate/v2"
  data = {'q': sentence,'target': language}
  response = session.post(url, json = data, headers = {"Authorization": "Bearer " + token})
  return response.json()['data']['translations'][0]['translatedText']
$$;

-- Example 23938
GRANT USAGE ON FUNCTION google_translate_python(string, string) TO ROLE user;

-- Example 23939
USE ROLE user;

SELECT google_translate_python('Happy Thursday!', 'zh-CN');

-- Example 23940
-------------------------------------------------------
| GOOGLE_TRANSLATE_PYTHON('HAPPY THURSDAY!', 'ZH-CN') |
-------------------------------------------------------
| 快乐星期四！                                          |
-------------------------------------------------------

-- Example 23941
CREATE OR REPLACE NETWORK RULE lambda_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('my_external_service');

-- Example 23942
CREATE OR REPLACE SECRET secret_password
  TYPE = PASSWORD
  USERNAME = 'my_user_name'
  PASSWORD = 'my_password';

-- Example 23943
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 23944
GRANT READ ON SECRET secret_password TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;

-- Example 23945
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION lambda_external_access_integration
  ALLOWED_NETWORK_RULES = (lambda_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (secret_password)
  ENABLED = TRUE;

-- Example 23946
CREATE OR REPLACE FUNCTION return_double_column(x int)
  RETURNS INT
  LANGUAGE PYTHON
  EXTERNAL_ACCESS_INTEGRATIONS = (lambda_external_access_integration)
  SECRETS = ('cred' = secret_password)
  RUNTIME_VERSION = 3.9
  HANDLER = 'return_first_column'
  PACKAGES = ('pandas', 'requests')
AS $$
import pandas
import numpy as np
import json
import requests
import base64
import _snowflake
from _snowflake import vectorized
from requests.auth import HTTPBasicAuth
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

session = requests.Session()
retries = Retry(total=10, backoff_factor=1, status_forcelist=[429, 500, 502, 503, 504], allowed_methods = None)

session.mount('https://', HTTPAdapter(max_retries=retries))

@vectorized(input=pandas.DataFrame)
def return_first_column(df):
  request_rows = []

  df.iloc[:,0] = df.iloc[:,0].astype(int)
  request_rows = np.column_stack([df.index, df.iloc[:,0]]).tolist()

  request_payload = {"data" : request_rows}

  username_password_object = _snowflake.get_username_password('cred');
  basic = HTTPBasicAuth(username_password_object.username, username_password_object.password)

  url = 'my_external_service'

  response = session.post(url, json=request_payload, auth=basic)

  response.raise_for_status()
  response_payload = json.loads(response.text)

  response_rows = response_payload["data"]

  return pandas.DataFrame(response_rows)[1]
$$;

-- Example 23947
GRANT USAGE ON FUNCTION return_double_column(int) TO ROLE user;

-- Example 23948
CREATE OR REPLACE TABLE t1 (a INT, b INT);
INSERT INTO t1 SELECT SEQ4(), SEQ4() FROM TABLE(GENERATOR(ROWCOUNT => 100000000));

SELECT return_double_column(a) AS retval FROM t1 ORDER BY retval;

-- Example 23949
CREATE OR REPLACE NETWORK RULE aws_s3_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('external-access-iam-bucket.s3.us-west-2.amazonaws.com');

-- Example 23950
CREATE OR REPLACE SECURITY INTEGRATION aws_s3_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 23951
DESC SECURITY INTEGRATION aws_s3_security_integration;

-- Example 23952
CREATE OR REPLACE SECRET aws_s3_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = aws_s3_security_integration;

-- Example 23953
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 23954
GRANT READ ON SECRET aws_s3_access_token TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;

-- Example 23955
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION aws_s3_external_access_integration
  ALLOWED_NETWORK_RULES = (aws_s3_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (aws_s3_access_token)
  ENABLED = TRUE
  COMMENT = 'Testing S3 connectivity';

-- Example 23956
CREATE OR REPLACE FUNCTION aws_s3_python_function()
  RETURNS VARCHAR
  LANGUAGE PYTHON
  EXTERNAL_ACCESS_INTEGRATIONS = (aws_s3_external_access_integration)
  RUNTIME_VERSION = '3.9'
  SECRETS = ('cred' = aws_s3_access_token)
  PACKAGES = ('boto3')
  HANDLER = 'main_handler'
AS $$
import boto3
import _snowflake
from botocore.config import Config

def main_handler():
  # Get token object
  cloud_provider_object = _snowflake.get_cloud_provider_token('cred')

  # Boto3 configuration
  config = Config(
    retries=dict(total_max_attempts=9),
    connect_timeout=30,
    read_timeout=30,
    max_pool_connections=50
  )

  # Connect to S3 using boto3
  s3 = boto3.client(
    's3',
    region_name='us-west-2',
    aws_access_key_id=cloud_provider_object.access_key_id,
    aws_secret_access_key=cloud_provider_object.secret_access_key,
    aws_session_token=cloud_provider_object.token,
    config=config
  )

  # Use S3 object to upload/download
  return 'Successfully connected with S3'
$$;

-- Example 23957
CREATE OR REPLACE FUNCTION aws_s3_java_function()
  RETURNS STRING
  LANGUAGE JAVA
  EXTERNAL_ACCESS_INTEGRATIONS = (aws_s3_external_access_integration)
  SECRETS = ('cred' = aws_s3_access_token)
  HANDLER = 'AWSTokenProvider.handle'
AS $$
import com.snowflake.snowpark_java.types.CloudProviderToken;
import com.snowflake.snowpark_java.types.SnowflakeSecrets;

public class AWSTokenProvider {
  public static String handle() {
    // Get token object
    SnowflakeSecrets sfSecret = SnowflakeSecrets.newInstance();
    CloudProviderToken cloudProviderToken = sfSecret.getCloudProviderToken("cred");

    // Create variables for AWS session credentials
    String accessKeyId = cloudProviderToken.getAccessKeyId();
    String secretAccessKey = cloudProviderToken.getSecretAccessKey();
    String token = cloudProviderToken.getToken();

    // Create S3 client using AWS APIs.

    return "Successfully connected with S3 with temp access token: " + token;
  }
}
$$;

-- Example 23958
GRANT USAGE ON FUNCTION return_double_column(int) TO ROLE user;

-- Example 23959
SELECT aws_s3_python_function();

-- Example 23960
SELECT aws_s3_java_function();

