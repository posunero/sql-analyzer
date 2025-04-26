-- Example 16528
CREATE OR REPLACE FUNCTION aws_s3_python_function()
  RETURNS VARCHAR
  LANGUAGE PYTHON
  EXTERNAL_ACCESS_INTEGRATIONS = (aws_s3_external_access_integration)
  RUNTIME_VERSION = '3.9'
  SECRETS = ('cred' = aws_s3_access_token)
  PACKAGES = ('boto3')
  HANDLER = 'main_handler'
AS
$$
  import boto3
  import _snowflake
  from botocore.config import Config

  def main_handler():
      # Get the previously created token as an object
      cloud_provider_object = _snowflake.get_cloud_provider_token('cred')

      # Configure boto3 connection settings
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

      # Use the s3 object upload/download resources
      # ...

      return 'Successfully connected to AWS S3'
$$;

-- Example 16529
CREATE OR REPLACE FUNCTION aws_s3_java_function()
  RETURNS STRING
  LANGUAGE JAVA
  EXTERNAL_ACCESS_INTEGRATIONS = (aws_s3_external_access_integration)
  SECRETS = ('cred' = aws_s3_access_token)
  HANDLER = 'AWSTokenProvider.handle'
AS
$$
  import com.snowflake.snowpark_java.types.CloudProviderToken;
  import com.snowflake.snowpark_java.types.SnowflakeSecrets;

  public class AWSTokenProvider {
      public static String handle() {
          // Get the previously created token as an object
          SnowflakeSecrets sfSecret = SnowflakeSecrets.newInstance();
          CloudProviderToken cloudProviderToken = sfSecret.getCloudProviderToken("cred");

          // Create variables for the AWS session credentials
          String accessKeyId = cloudProviderToken.getAccessKeyId();
          String secretAccessKey = cloudProviderToken.getSecretAccessKey();
          String token = cloudProviderToken.getToken();

          // Use the token to create an S3 client
          // ...

          return "Successfully connected to AWS S3 with the following access token: " + token;
      }
  }
$$;

-- Example 16530
SELECT aws_s3_python_function();

-- Example 16531
SELECT aws_s3_java_function();

-- Example 16532
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.bedrock-runtime',
  'bedrock-runtime.us-west-2.amazonaws.com'
);

-- Example 16533
CREATE OR REPLACE NETWORK RULE bedrock_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('bedrock-runtime.us-west-2.amazonaws.com');

-- Example 16534
CREATE OR REPLACE SECURITY INTEGRATION bedrock_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 16535
DESC  SECURITY INTEGRATION bedrock_security_integration;

-- Example 16536
CREATE OR REPLACE SECRET aws_bedrock_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = bedrock_security_integration;

-- Example 16537
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION bedrock_external_access_integration
  ALLOWED_NETWORK_RULES = (bedrock_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS=(aws_bedrock_access_token)
  ENABLED=true ;

-- Example 16538
CREATE OR REPLACE FUNCTION bedrock_private_connectivity_tests(
  id INT,
  instructions VARCHAR,
  user_context VARCHAR,
  model_id VARCHAR
)
  RETURNS VARCHAR
  LANGUAGE PYTHON
  EXTERNAL_ACCESS_INTEGRATIONS = (bedrock_external_access_integration)
  RUNTIME_VERSION = '3.8'
  SECRETS = ('cred' = aws_bedrock_access_token)
  PACKAGES = ('boto3')
  HANDLER = 'bedrock_py'
AS
$$
  import boto3
  import json
  import _snowflake
  def bedrock_py(id, instructions, user_context, model_id):
      # Get the previously created token as an object
      cloud_provider_object = _snowflake.get_cloud_provider_token('cred')
      cloud_provider_dictionary = {
          "ACCESS_KEY_ID": cloud_provider_object.access_key_id,
          "SECRET_ACCESS_KEY": cloud_provider_object.secret_access_key,
          "TOKEN": cloud_provider_object.token
      }
      # Assign AWS credentials and choose a region
      boto3_session_args = {
          'aws_access_key_id': cloud_provider_dictionary["ACCESS_KEY_ID"],
          'aws_secret_access_key': cloud_provider_dictionary["SECRET_ACCESS_KEY"],
          'aws_session_token': cloud_provider_dictionary["TOKEN"],
          'region_name': 'us-west-2'
      }
      session = boto3.Session(**boto3_session_args)
      client = session.client('bedrock-runtime')
      # Prepare the request body for the specified model
      def prepare_request_body(model_id, instructions, user_context):
          default_max_tokens = 512
          default_temperature = 0.7
          default_top_p = 1.0
          if model_id == 'amazon.titan-text-express-v1':
              body = {
                  "inputText": f"<SYSTEM>Follow these:{instructions}<END_SYSTEM>\n<USER_CONTEXT>Use this user context in your response:{user_context}<END_USER_CONTEXT>",
                  "textGenerationConfig": {
                      "maxTokenCount": default_max_tokens,
                      "stopSequences": [],
                      "temperature": default_temperature,
                      "topP": default_top_p
                  }
              }
          elif model_id == 'ai21.j2-ultra-v1':
              body = {
                  "prompt": f"<SYSTEM>Follow these:{instructions}<END_SYSTEM>\n<USER_CONTEXT>Use this user context in your response:{user_context}<END_USER_CONTEXT>",
                  "temperature": default_temperature,
                  "topP": default_top_p,
                  "maxTokens": default_max_tokens
              }
          elif model_id == 'anthropic.claude-3-sonnet-20240229-v1:0':
              body = {
                  "max_tokens": default_max_tokens,
                  "messages": [{"role": "user", "content": f"<SYSTEM>Follow these:{instructions}<END_SYSTEM>\n<USER_CONTEXT>Use this user context in your response:{user_context}<END_USER_CONTEXT>"}],
                  "anthropic_version": "bedrock-2023-05-31"
              }
          else:
              raise ValueError("Unsupported model ID")
          return json.dumps(body)
      # Call Bedrock to get a completion
      body = prepare_request_body(model_id, instructions, user_context)
      response = client.invoke_model(modelId=model_id, body=body)
      response_body = json.loads(response.get('body').read())
      # Parse the API response based on the model
      def get_completion_from_response(response_body, model_id):
          if model_id == 'amazon.titan-text-express-v1':
              output_text = response_body.get('results')[0].get('outputText')
          elif model_id == 'ai21.j2-ultra-v1':
              output_text = response_body.get('completions')[0].get('data').get('text')
          elif model_id == 'anthropic.claude-3-sonnet-20240229-v1:0':
              output_text = response_body.get('content')[0].get('text')
          else:
              raise ValueError("Unsupported model ID")
          return output_text
      # Get the generated text from Bedrock
      output_text = get_completion_from_response(response_body, model_id)
      return output_text
  $$;

-- Example 16539
SELECT bedrock_private_connectivity_tests(1, 'Summarize the main benefits of attending this university.', 'University of Waterloo', 'amazon.titan-text-express-v1');

-- Example 16540
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/1111-22-333-4444-55555/resourceGroups/external-access/providers/Microsoft.Sql/servers/externalaccessdemo',
  'externalaccessdemo.database.windows.net',
  'sqlServer'
);

-- Example 16541
CREATE DATABASE ext_network_access_db;
CREATE SCHEMA secrets;
CREATE SCHEMA network_rules;
CREATE SCHEMA procedures;

-- Example 16542
CREATE OR REPLACE NETWORK RULE ext_network_access_db.network_rules.azure_sql_private_rule
   MODE = EGRESS
   TYPE = PRIVATE_HOST_PORT
   VALUE_LIST = ('externalaccessdemo.database.windows.net');

-- Example 16543
CREATE OR REPLACE SECRET ext_network_access_db.secrets.secret_password
   TYPE = PASSWORD
   USERNAME = 'my-username'
   PASSWORD = 'my-password';

-- Example 16544
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION azure_private_access_sql_store_integration
   ALLOWED_NETWORK_RULES = (ext_network_access_db.network_rules.azure_sql_private_rule)
   ALLOWED_AUTHENTICATION_SECRETS = (ext_network_access_db.secrets.secret_password)
   ENABLED = TRUE;

-- Example 16545
CREATE OR REPLACE PROCEDURE ext_network_access_db.procedures.connect_azure_sqlserver()
  RETURNS TABLE()
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.10
  HANDLER = 'connect_sqlserver'
  EXTERNAL_ACCESS_INTEGRATIONS = (azure_private_access_sql_store_integration)
  SECRETS = ('cred' = ext_network_access_db.secrets.secret_password)
  IMPORTS = ('@demo/pytds.zip')
  PACKAGES = ('snowflake-snowpark-python','pyopenssl','bitarray','certifi')
AS $$
import pytds
import certifi
import _snowflake
from snowflake.snowpark import types as T

def connect_sqlserver(session):
   server = 'externalaccessdemo.database.windows.net'
   database = 'externalaccess'
   username_password_object = _snowflake.get_username_password('cred');


   # Create a connection to the database
   with pytds.connect(server, database, username_password_object.username, username_password_object.password, cafile=certifi.where(), validate_host=False) as conn:
         with conn.cursor() as cur:
            cur.execute("""
            SELECT O.OrderId,
                  O.OrderDate,
                  O.SodName,
                  O.UnitPrice,
                  O.Quantity,
                  C.Region
            FROM Orders AS O
            INNER JOIN Customers AS C
               ON O.CustomerID = C.CustomerID;""")
            rows = cur.fetchall()

            schema = T.StructType([
                  T.StructField("ORDER_ID", T.LongType(), True),
                  T.StructField("ORDER_DATE", T.DateType(), True),
                  T.StructField("SOD_NAME", T.StringType(), True),
                  T.StructField("UNIT_PRICE", T.FloatType(), True),
                  T.StructField("QUANTITY", T.FloatType(), True),
                  T.StructField("REGION", T.StringType(), True)
               ])

            final_df = session.createDataFrame(rows, schema)

            return final_df
   $$;

-- Example 16546
CALL ext_network_access_db.procedures.connect_azure_sqlserver();

-- Example 16547
Cannot assign requested address

-- Example 16548
CREATE [OR REPLACE] EXTERNAL ACCESS INTEGRATION pypi_access
  ALLOWED_NETWORK_RULES = (snowflake.external_access.pypi_rule)
  ENABLED = true;

-- Example 16549
CREATE OR REPLACE ROLE developer;

-- Example 16550
GRANT USAGE ON INTEGRATION pypi_access TO ROLE developer;

-- Example 16551
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 16552
CREATE OR REPLACE SECURITY INTEGRATION google_translate_oauth
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = OAUTH2
  OAUTH_CLIENT_ID = 'my-client-id'
  OAUTH_CLIENT_SECRET = 'my-client-secret'
  OAUTH_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token'
  OAUTH_AUTHORIZATION_ENDPOINT = 'https://accounts.google.com/o/oauth2/auth'
  OAUTH_ALLOWED_SCOPES = ('https://www.googleapis.com/auth/cloud-platform')
  ENABLED = TRUE;

-- Example 16553
USE DATABASE my_db;
USE SCHEMA secret_schema;

CREATE OR REPLACE SECRET oauth_token
  TYPE = oauth2
  API_AUTHENTICATION = google_translate_oauth;

-- Example 16554
CALL SYSTEM$START_OAUTH_FLOW( 'my_db.secret_schema.oauth_token' );

-- Example 16555
CALL SYSTEM$FINISH_OAUTH_FLOW( 'state=<remaining_url_text>' );

-- Example 16556
CREATE OR REPLACE SECRET oauth_token
  TYPE = oauth2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 16557
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = TRUE;

-- Example 16558
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 16559
GRANT READ ON SECRET oauth_token TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE developer;

-- Example 16560
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

-- Example 16561
GRANT USAGE ON FUNCTION google_translate_python(string, string) TO ROLE user;

-- Example 16562
USE ROLE user;

SELECT google_translate_python('Happy Thursday!', 'zh-CN');

-- Example 16563
-------------------------------------------------------
| GOOGLE_TRANSLATE_PYTHON('HAPPY THURSDAY!', 'ZH-CN') |
-------------------------------------------------------
| 快乐星期四！                                          |
-------------------------------------------------------

-- Example 16564
CREATE OR REPLACE NETWORK RULE lambda_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('my_external_service');

-- Example 16565
CREATE OR REPLACE SECRET secret_password
  TYPE = PASSWORD
  USERNAME = 'my_user_name'
  PASSWORD = 'my_password';

-- Example 16566
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 16567
GRANT READ ON SECRET secret_password TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;

-- Example 16568
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION lambda_external_access_integration
  ALLOWED_NETWORK_RULES = (lambda_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (secret_password)
  ENABLED = TRUE;

-- Example 16569
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

-- Example 16570
GRANT USAGE ON FUNCTION return_double_column(int) TO ROLE user;

-- Example 16571
CREATE OR REPLACE TABLE t1 (a INT, b INT);
INSERT INTO t1 SELECT SEQ4(), SEQ4() FROM TABLE(GENERATOR(ROWCOUNT => 100000000));

SELECT return_double_column(a) AS retval FROM t1 ORDER BY retval;

-- Example 16572
CREATE OR REPLACE NETWORK RULE aws_s3_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('external-access-iam-bucket.s3.us-west-2.amazonaws.com');

-- Example 16573
CREATE OR REPLACE SECURITY INTEGRATION aws_s3_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 16574
DESC SECURITY INTEGRATION aws_s3_security_integration;

-- Example 16575
CREATE OR REPLACE SECRET aws_s3_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = aws_s3_security_integration;

-- Example 16576
CREATE OR REPLACE ROLE developer;
CREATE OR REPLACE ROLE user;

-- Example 16577
GRANT READ ON SECRET aws_s3_access_token TO ROLE developer;
GRANT USAGE ON SCHEMA secret_schema TO ROLE developer;

-- Example 16578
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION aws_s3_external_access_integration
  ALLOWED_NETWORK_RULES = (aws_s3_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (aws_s3_access_token)
  ENABLED = TRUE
  COMMENT = 'Testing S3 connectivity';

-- Example 16579
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

-- Example 16580
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

-- Example 16581
GRANT USAGE ON FUNCTION return_double_column(int) TO ROLE user;

-- Example 16582
SELECT aws_s3_python_function();

-- Example 16583
SELECT aws_s3_java_function();

-- Example 16584
CREATE OR REPLACE FUNCTION get_secret_type()
  RETURNS STRING
  LANGUAGE JAVA
  HANDLER = 'SecretTest.getSecretType'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  PACKAGES = ('com.snowflake:snowpark:latest')
  SECRETS = ('cred' = oauth_token )
  AS
  $$
  import com.snowflake.snowpark_java.types.SnowflakeSecrets;

  public class SecretTest {
    public static String getSecretType() {
      SnowflakeSecrets sfSecrets = SnowflakeSecrets.newInstance();

      String secretType = sfSecrets.getSecretType("cred");

      return secretType;
    }
  }
  $$;

-- Example 16585
CREATE OR REPLACE FUNCTION get_secret_type()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'get_secret'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  SECRETS = ('cred' = oauth_token )
  AS
$$
import _snowflake

def get_secret():
  secret_type = _snowflake.get_secret_type('cred')
  return secret_type
$$;

-- Example 16586
CREATE OR REPLACE FUNCTION get_secret_username_password()
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'get_secret_username_password'
  EXTERNAL_ACCESS_INTEGRATIONS = (external_access_integration)
  SECRETS = ('cred' = credentials_secret )
  AS
$$
import _snowflake

def get_secret_username_password():
  username_password_object = _snowflake.get_username_password('cred');

  username_password_dictionary = {}
  username_password_dictionary["Username"] = username_password_object.username
  username_password_dictionary["Password"] = username_password_object.password

  return username_password_dictionary
$$;

-- Example 16587
Secrets can only be accessed from the main thread.

-- Example 16588
with ThreadPoolExecutor(max_workers=1) as executor:
  futures = [executor.submit(function, get_generic_secret)]

-- Example 16589
CREATE [ OR REPLACE ] EXTERNAL ACCESS INTEGRATION <name>
  ALLOWED_NETWORK_RULES = ( <rule_name_1> [, <rule_name_2>, ... ] )
  [ ALLOWED_API_AUTHENTICATION_INTEGRATIONS = ( { <integration_name_1> [, <integration_name_2>, ... ] | none } ) ]
  [ ALLOWED_AUTHENTICATION_SECRETS = ( { <secret_name_1> [, <secret_name_2>, ... ] | all | none } ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]

-- Example 16590
CREATE OR REPLACE SECRET oauth_token
  TYPE = OAUTH2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 16591
USE ROLE USERADMIN;
CREATE OR REPLACE ROLE developer;

-- Example 16592
USE ROLE SECURITYADMIN;
GRANT READ ON SECRET oauth_token TO ROLE developer;

-- Example 16593
USE ROLE SYSADMIN;
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 16594
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = true;

