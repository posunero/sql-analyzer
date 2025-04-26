-- Example 23293
DESC INTEGRATION my_s3_storage_int;

-- Example 23294
SELECT SYSTEM$GET_AWS_SNS_IAM_POLICY('<topic_arn>');

-- Example 23295
ALTER FAILOVER GROUP my_pipe_failover_group REFRESH;

-- Example 23296
ALTER FAILOVER GROUP my_pipe_failover_group PRIMARY;

-- Example 23297
SELECT * FROM mytable;

-- Example 23298
SELECT SYSTEM$CONVERT_PIPES_SQS_TO_SNS('s3_mybucket', 'arn:aws:sns:us-west-2:001234567890:MySNSTopic')

-- Example 23299
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override');

-- Example 23300
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe1','staleness_check_override, ownership_transfer_check_override');

-- Example 23301
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 23302
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.vpce.us-west-2.vpce-svc-012345678910f1234',
  'my.onprem.storage.com'
);

-- Example 23303
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 23304
SELECT SYSTEM$RESTORE_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 23305
SELECT SYSTEM$GET_PRIVATELINK_ENDPOINTS_INFO();

-- Example 23306
[
  {
    "provider_service_name": "com.amazonaws.us-west-2.s3",
    "snowflake_endpoint_name": "vpce-123456789012abcdea",
    "endpoint_state": "CREATED",
    "host": "*.s3.us-west-2.amazonaws.com",
    "status": "Available"
  },
  ...
]

-- Example 23307
CREATE API INTEGRATION external_api_integration_azure_private
  API_PROVIDER = azure_private_api_management
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  AZURE_AD_APPLICATION_ID = 'dv3421nq-1g4s-4ap4-x89c-xrf28hna7m2o'
  API_ALLOWED_PREFIXES = ('https://aztest1-external-function-api.azure.net')
  ENABLED = TRUE
  COMMENT = 'API integration for private connectivity to an external service with external functions on Azure.';

-- Example 23308
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'aztest1-external-function-api.azure.net',
  'Gateway'
  );

-- Example 23309
CREATE DATABASE private_external_service_db;
CREATE SCHEMA private_ext_functions;

-- Example 23310
CREATE OR REPLACE SECURE EXTERNAL FUNCTION private_ext_function_azure_portal(
  a INTEGER , b VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = external_api_integration_azure_private
  AS 'https://aztest1-external-function-api.azure.net/my-api-url-suffix/http-function-name';

-- Example 23311
SELECT private_ext_function_azure(66, 'Mario');

-- Example 23312
[0, 66, 'Mario']

-- Example 23313
az apim update --name <api-name> --resource-group <resource group name> --public-network-access false

-- Example 23314
CREATE API INTEGRATION external_api_integration_azure_private
  API_PROVIDER = azure_private_api_management
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  AZURE_AD_APPLICATION_ID = 'dv3421nq-1g4s-4ap4-x89c-xrf28hna7m2o'
  API_ALLOWED_PREFIXES = ('https://aztest1-external-function-api.azure.net')
  ENABLED = TRUE
  COMMENT = 'API integration for private connectivity to an external service with external functions on Azure.';

-- Example 23315
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'aztest1-external-function-api.azure.net',
  'Gateway'
  );

-- Example 23316
CREATE DATABASE private_external_service_db;
CREATE SCHEMA private_ext_functions;

-- Example 23317
CREATE OR REPLACE SECURE EXTERNAL FUNCTION private_ext_function_azure_portal(
  a INTEGER , b VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = external_api_integration_azure_private
  AS 'https://aztest1-external-function-api.azure.net/my-api-url-suffix/http-function-name';

-- Example 23318
SELECT private_ext_function_azure(66, 'Mario');

-- Example 23319
[0, 66, 'Mario']

-- Example 23320
az apim update --name <api-name> --resource-group <resource group name> --public-network-access false

-- Example 23321
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

-- Example 23322
CREATE OR REPLACE NETWORK RULE aws_s3_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('external-access-iam-bucket.s3.us-west-2.amazonaws.com');

-- Example 23323
CREATE OR REPLACE SECURITY INTEGRATION aws_s3_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 23324
DESC SECURITY INTEGRATION aws_s3_security_integration;

-- Example 23325
CREATE OR REPLACE SECRET aws_s3_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = aws_s3_security_integration;

-- Example 23326
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION aws_s3_external_access_integration
  ALLOWED_NETWORK_RULES = (aws_s3_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (aws_s3_access_token)
  ENABLED = TRUE
  COMMENT = 'Testing S3 connectivity';

-- Example 23327
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

-- Example 23328
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

-- Example 23329
SELECT aws_s3_python_function();

-- Example 23330
SELECT aws_s3_java_function();

-- Example 23331
USE ROLE ACCOUNTADMIN;
SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.s3',
  '*.s3.us-west-2.amazonaws.com'
);

SELECT SYSTEM$PROVISION_PRIVATELINK_ENDPOINT(
  'com.amazonaws.us-west-2.bedrock-runtime',
  'bedrock-runtime.us-west-2.amazonaws.com'
);

-- Example 23332
CREATE OR REPLACE NETWORK RULE bedrock_network_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('bedrock-runtime.us-west-2.amazonaws.com');

-- Example 23333
CREATE OR REPLACE SECURITY INTEGRATION bedrock_security_integration
  TYPE = API_AUTHENTICATION
  AUTH_TYPE = AWS_IAM
  ENABLED = TRUE
  AWS_ROLE_ARN = 'arn:aws:iam::736112632310:role/external-access-iam-bucket';

-- Example 23334
DESC  SECURITY INTEGRATION bedrock_security_integration;

-- Example 23335
CREATE OR REPLACE SECRET aws_bedrock_access_token
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = bedrock_security_integration;

-- Example 23336
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION bedrock_external_access_integration
  ALLOWED_NETWORK_RULES = (bedrock_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS=(aws_bedrock_access_token)
  ENABLED=true ;

-- Example 23337
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

-- Example 23338
SELECT bedrock_private_connectivity_tests(1, 'Summarize the main benefits of attending this university.', 'University of Waterloo', 'amazon.titan-text-express-v1');

-- Example 23339
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'SELECT');

-- Example 23340
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'CALL', 'SELECT');

-- Example 23341
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'PERSISTENT', 'INSERT');

-- Example 23342
SELECT SYSTEM$QUERY_REFERENCE('SELECT id FROM my_table', FALSE);

-- Example 23343
SHOW REFERENCES IN APPLICATION my_app;

-- Example 23344
ALTER APPLICATION my_app UNSET REFERENCES('table_to_read');

-- Example 23345
ALTER APPLICATION my_app UNSET REFERENCES;

-- Example 23346
SHOW REFERENCES IN APPLICATION my_app;

-- Example 23347
az role definition create --role-definition '{"Name":"snowflake-pep-role","Description":
"To generate advanced proof of access token for Snowflake private endpoint pinning","Actions":
["Microsoft.Network/privateEndpoints/read"],"AssignableScopes":["/subscriptions/<subscription_id>"]}'

-- Example 23348
az role assignment create --assignee <user> --role snowflake-pep-role --scope <private_endpoint_resource_id>

-- Example 23349
az account get-access-token --subscription <subscription_id>

-- Example 23350
aws sts get-federation-token --name snowflake --policy
'{ "Version": "2012-10-17", "Statement":
  [ {
  "Effect": "Allow", "Action": ["ec2:DescribeVpcEndpoints"],
  "Resource": ["*"] }
  ] }'

-- Example 23351
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  'vpce-0c1...',
  '123.....',
  '{
    "Credentials": {
      "AccessKeyId": "ASI...",
      "SecretAccessKey": "alD...",
      "SessionToken": "IQo...",
      "Expiration": "2024-12-10T08:20:20+00:00"
    },
    "FederatedUser": {
      "FederatedUserId": "0123...:snowflake",
      "Arn": "arn:aws:sts::174...:federated-user/snowflake"
    },
    "PackedPolicySize": 9,
    }',
  120
  );

-- Example 23352
SELECT SYSTEM$REGISTER_PRIVATELINK_ENDPOINT(
  '123....',
  '/subscriptions/0cc51670-.../resourceGroups/dbsec_test_rg/providers/Microsoft.Network/
  privateEndpoints/...',
  'eyJ...',
  120
);

-- Example 23353
snow spcs image-registry login
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 23354
snow spcs image-registry login

-- Example 23355
Login Succeeded

-- Example 23356
snow spcs image-registry token
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 23357
snow spcs image-registry token --connection mytest

-- Example 23358
+----------------------------------------------------------------------------------------------------------------------+
| key        | value                                                                                                   |
|------------+---------------------------------------------------------------------------------------------------------|
| token      | ****************************************************************************************************    |
|            | ****************************************************************************************************    |
| expires_in | 3600                                                                                                    |
+----------------------------------------------------------------------------------------------------------------------+

-- Example 23359
snow spcs image-registry token --format=JSON | docker login YOUR_HOST -u 0sessiontoken --password-stdin

