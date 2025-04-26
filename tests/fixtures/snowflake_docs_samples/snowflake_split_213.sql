-- Example 14251
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0;

-- Example 14252
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0 PATCH 2;

-- Example 14253
CREATE APPLICATION hello_snowflake_app FROM APPLICATION PACKAGE hello_snowflake_package;

-- Example 14254
ALTER APPLICATION HelloSnowflake
  UPGRADE USING @CODEDATABASE.CODESCHEMA.AppCodeStage;

-- Example 14255
ALTER APPLICATION HelloSnowflake
 UPGRADE USING VERSION "v1_1";

-- Example 14256
USE APPlICATION hello_snowflake_app;

-- Example 14257
SHOW APPLICATIONS;

-- Example 14258
DESC APPLICATION hello_snowflake_app;

-- Example 14259
ALTER APPLICATION hello_snowflake_app SET DEBUG_MODE = TRUE;

-- Example 14260
ALTER APPLICATION hello_snowflake_app SET DEBUG_MODE = FALSE;

-- Example 14261
SELECT SYSTEM$BEGIN_DEBUG_APPLICATION(‘hello_snowflake_app’);

-- Example 14262
SYSTEM$BEGIN_DEBUG_APPLICATION( 'hello_snowflake_app', execution_mode ='AS_APPLICATION')

-- Example 14263
SELECT SYSTEM$GET_DEBUG_STATUS();

-- Example 14264
SELECT SYSTEM$END_DEBUG_APPLICATION();

-- Example 14265
ALTER APPLICATION hello_snowflake_app SET DISABLE_APPLICATION_REDACTION = TRUE;

-- Example 14266
ALTER APPLICATION hello_snowflake_app SET DISABLE_APPLICATION_REDACTION = FALSE;

-- Example 14267
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING @path_to_staged_files
  AUTHORIZE_TELEMETRY_EVENT_SHARING = TRUE;

CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION v1_0
  PATCH 0
  AUTHORIZE_TELEMETRY_EVENT_SHARING = TRUE;

-- Example 14268
required_compute_pools:
  - HIGH_MEM_POOL_1:
      label: "High memory pool"
      description: "A compute pool for computational tasks."
      compatible_instance_families:
        - HIGHMEM_X64_M
        - HIGHMEM_X64_L

-- Example 14269
connections:
  - LAUNCH_DARKLY:
     label: "Launch Darkly"
     description: "Feature flag and configuration"
     required: true
     endpoints:
       - "mobile.launchdarkly.com"
       - "stream.launchdarkly.com"
  - OPEN_AI:
     label: "OpenAPI"
     description: "LLM Connection"
     required: false
     endpoints:
       - "openai.com"

-- Example 14270
CREATE [ OR REPLACE ] USER [ IF NOT EXISTS ] <name>
  [ objectProperties ]
  [ objectParams ]
  [ sessionParams ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 14271
objectProperties ::=
  PASSWORD = '<string>'
  LOGIN_NAME = <string>
  DISPLAY_NAME = <string>
  FIRST_NAME = <string>
  MIDDLE_NAME = <string>
  LAST_NAME = <string>
  EMAIL = <string>
  MUST_CHANGE_PASSWORD = TRUE | FALSE
  DISABLED = TRUE | FALSE
  DAYS_TO_EXPIRY = <integer>
  MINS_TO_UNLOCK = <integer>
  DEFAULT_WAREHOUSE = <string>
  DEFAULT_NAMESPACE = <string>
  DEFAULT_ROLE = <string>
  DEFAULT_SECONDARY_ROLES = ( 'ALL' ) | ()
  MINS_TO_BYPASS_MFA = <integer>
  RSA_PUBLIC_KEY = <string>
  RSA_PUBLIC_KEY_FP = <string>
  RSA_PUBLIC_KEY_2 = <string>
  RSA_PUBLIC_KEY_2_FP = <string>
  TYPE = PERSON | SERVICE | LEGACY_SERVICE | NULL
  COMMENT = '<string_literal>'

-- Example 14272
objectParams ::=
  ENABLE_UNREDACTED_QUERY_SYNTAX_ERROR = TRUE | FALSE
  ENABLE_UNREDACTED_SECURE_OBJECT_ERROR = TRUE | FALSE
  NETWORK_POLICY = <string>

-- Example 14273
sessionParams ::=
  ABORT_DETACHED_QUERY = TRUE | FALSE
  AUTOCOMMIT = TRUE | FALSE
  BINARY_INPUT_FORMAT = <string>
  BINARY_OUTPUT_FORMAT = <string>
  DATE_INPUT_FORMAT = <string>
  DATE_OUTPUT_FORMAT = <string>
  DEFAULT_NULL_ORDERING = <string>
  ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE
  ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE
  JSON_INDENT = <num>
  LOCK_TIMEOUT = <num>
  QUERY_TAG = <string>
  ROWS_PER_RESULTSET = <num>
  SIMULATED_DATA_SHARING_CONSUMER = <string>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>
  STRICT_JSON_OUTPUT = TRUE | FALSE
  TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE
  TIMESTAMP_INPUT_FORMAT = <string>
  TIMESTAMP_LTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_NTZ_OUTPUT_FORMAT = <string>
  TIMESTAMP_OUTPUT_FORMAT = <string>
  TIMESTAMP_TYPE_MAPPING = <string>
  TIMESTAMP_TZ_OUTPUT_FORMAT = <string>
  TIMEZONE = <string>
  TIME_INPUT_FORMAT = <string>
  TIME_OUTPUT_FORMAT = <string>
  TRANSACTION_DEFAULT_ISOLATION_LEVEL = <string>
  TWO_DIGIT_CENTURY_START = <num>
  UNSUPPORTED_DDL_ACTION = <string>
  USE_CACHED_RESULT = TRUE | FALSE
  WEEK_OF_YEAR_POLICY = <num>
  WEEK_START = <num>

-- Example 14274
CREATE USER user1 PASSWORD='abc123' DEFAULT_ROLE = myrole DEFAULT_SECONDARY_ROLES = ('ALL') MUST_CHANGE_PASSWORD = TRUE;

-- Example 14275
repositories {
    mavenCentral()
}

dependencies {
    compileOnly 'com.snowflake:connectors-native-sdk:2.0.0'
    testImplementation 'com.snowflake:connectors-native-sdk-test:2.0.0'
}

-- Example 14276
String defaultBuildDir = './sf_build'
String defaultSrcDir = './app'
String libraryName = 'connectors-native-sdk'

project.tasks.register('copySdkComponents') {
    it.group = 'Snowflake'
    it.description = "Copies .sql files from ${sdkComponentsDirName} directory to the connector build file."
    doLast {
        copySdkComponents(libraryName, defaultBuildDir, sdkComponentsDirName)
    }
}

private void copySdkComponents(String libraryName, String defaultBuildDir, String sdkComponentsDirName) {
    TaskLogger.info("Starting 'copySdkComponents' task...")
    def targetDir = getCommandArgument('targetDir', {defaultBuildDir})

    try {
        project.copy {
            TaskLogger.info("Copying [${sdkComponentsDirName}] directory with .sql files to '${targetDir}'")
            from project.zipTree(project.configurations.compileClasspath.find {
                it.name.startsWith(libraryName)})
            into targetDir
            include "${sdkComponentsDirName}/**"
        }
    } catch (IllegalArgumentException e) {
        Utils.exitWithErrorLog("Unable to find [${libraryName}] in the compile classpath. Make sure that the library is " +
                "published to Maven local repository and the proper dependency is added to the build.gradle file.")
    }
    project.copy {
        TaskLogger.info("Copying [${libraryName}] jar file to [${targetDir}]")
        from configurations.runtimeClasspath.find {
            it.name.startsWith(libraryName)
        }
        into targetDir
        rename ("^.*${libraryName}.*\$", "${libraryName}.jar")
    }
    TaskLogger.success("Copying sdk components finished successfully.")
}

-- Example 14277
./gradlew copySdkComponents

-- Example 14278
var customResourceRepository = new InMemoryDefaultResourceIngestionDefinitionRepository();
var key = "test_key";

var resource = createResource(key);
customResourceRepository.save(resource);

var result = customResourceRepository.fetch(key);

-- Example 14279
var table = new InMemoryDefaultKeyValueTable();
var repository = new DefaultConfigurationRepository(table);
var connectorService = new DefaultConnectorConfigurationService(repository);

-- Example 14280
new ConfigureConnectorHandlerTestBuilder()
                .withErrorHelper(mock(ConnectorErrorHelper.class))
                .withInputValidator(mock(ConfigureConnectorInputValidator.class))
                .withCallback(mock(ConfigureConnectorCallback.class))
                .withConfigurationService(mock(ConnectorConfigurationService.class))
                .withStatusService(mock(ConnectorStatusService.class))
                .build();

-- Example 14281
{
    "data": [
                [0, 10, "Alex", "2014-01-01 16:00:00"],
                [1, 20, "Steve", "2015-01-01 16:00:00"],
                [2, 30, "Alice", "2016-01-01 16:00:00"],
                [3, 40, "Adrian", "2017-01-01 16:00:00"]
            ]
}

-- Example 14282
def handler(event, context):

    request_headers = event["headers"]
    signature = request_headers["sf-external-function-signature"]

-- Example 14283
{
    "data":
        [
            [ 0, { "City" : "Warsaw",  "latitude" : 52.23, "longitude" :  21.01 } ],
            [ 1, { "City" : "Toronto", "latitude" : 43.65, "longitude" : -79.38 } ]
        ]
}

-- Example 14284
...
row_number = 0
output_value = {}

output_value["city"] = "Warsaw"
output_value["latitude"] = 21.01
output_value["longitude"] = 52.23
row_to_return = [row_number, output_value]
...

-- Example 14285
select val:city, val:latitude, val:longitude
    from (select ext_func_city_lat_long(city_name) as val from table_of_city_names);

-- Example 14286
import json
import hashlib
import base64

def handler(event, context):

    # The return value should contain an array of arrays (one inner array
    # per input row for a scalar function).
    array_of_rows_to_return = [ ]

    ...

    json_compatible_string_to_return = json.dumps({"data" : array_of_rows_to_return})

    # Calculate MD5 checksum for the response
    md5digest = hashlib.md5(json_compatible_string_to_return.encode('utf-8')).digest()
    response_headers = {
        'Content-MD5' : base64.b64encode(md5digest)
    }

    # Return the HTTP status code, the processed data, and the headers
    # (including the Content-MD5 header).
    return {
        'statusCode': 200,
        'body': json_compatible_string_to_return,
        'headers': response_headers
    }

-- Example 14287
CREATE EXTERNAL FUNCTION f(...)
    RETURNS OBJECT
    ...
    REQUEST_TRANSLATOR = my_request_translator_udf
    RESPONSE_TRANSLATOR = my_response_translator_udf
    ...
    AS <url_of_proxy_and_resource>;

-- Example 14288
CREATE EXTERNAL FUNCTION f(...)
    RETURNS OBJECT
    ...
    [ REQUEST_TRANSLATOR = <request_translator_udf_name> ]
    [ RESPONSE_TRANSLATOR = <response_translator_udf_name> ]
    ...

-- Example 14289
ALTER FUNCTION ...
    SET [REQUEST_TRANSLATOR | RESPONSE_TRANSLATOR] = <udf_name>;

-- Example 14290
ALTER FUNCTION ...
    UNSET [REQUEST_TRANSLATOR | RESPONSE_TRANSLATOR];

-- Example 14291
{
  "body": {
          "data": [
                    [0,"cat"],
                    [1,"dog"]
                  ]
          }
}

-- Example 14292
{
  "body": {
          "data": [
                    [0, "Life"],
                    [1, "the universe"],
                    [2, "and everything"]
                  ]
           }
}

-- Example 14293
USE ROLE ACCOUNTADMIN;

-- Example 14294
USE WAREHOUSE w;
USE DATABASE a;
USE SCHEMA b;

-- Example 14295
CREATE TABLE demo(vc varchar);
INSERT INTO demo VALUES('Today is a good day'),('I am feeling mopey');

-- Example 14296
CREATE OR REPLACE EXTERNAL FUNCTION ComprehendSentiment(thought varchar)
RETURNS VARIANT
API_INTEGRATION = aws_comprehend_gateway
AS 'https://<MY_GATEWAY>.execute-api.us-east-1.amazonaws.com/test/comprehend_proxy';

-- Example 14297
SELECT ComprehendSentiment(vc), vc FROM demo;

-- Example 14298
{"body":{"data:" [[0, "Today is a good day"],[1,"I am feeling mopey"]]}}

-- Example 14299
{"body": { Language: "en", TextList: [ "Today is a good day", "I am feeling mopey"]}}

-- Example 14300
CREATE OR REPLACE FUNCTION AWSComprehendrequest_translator(EVENT OBJECT)
RETURNS OBJECT
LANGUAGE JAVASCRIPT AS
'
var textlist = []
for(i = 0; i < EVENT.body.data.length; i++) {
   let row = EVENT.body.data[i];
   // row[0] is the row number and row[1] is the input text.
   textlist.push(row[1]); //put text into the textlist
}
// create the request for the service. Also pass the input request as part of the output.
return { "body": { "LanguageCode": "en", "TextList" : textlist }, "translatorData": EVENT.body }
';

-- Example 14301
SELECT AWSComprehendrequest_translator(parse_json('{"body":{"data": [[0, "I am so happy we got a sunny day for my birthday."], [1, "$$$$$."], [2, "Today is my last day in the old house."]]}}'));

-- Example 14302
{"body":{
   "LanguageCode": "en",
   "TextList": [
      "I am so happy we got a sunny day for my birthday.",
      "$$$$$.",
      "Today is my last day in the old house."
               ]
         },
   "translatorData": {
      "data": [[0, "I am so happy we got a sunny day for my birthday."],
               [1, "$$$$$."],
               [2, "Today is my last day in the old house."]]
                     }
}

-- Example 14303
{"body":{
   "ErrorList": [ { "ErrorCode": 57, "ErrorMessage": "Language unknown", "Index": 1} ],
   "ResultList":[ { "Index": 0, "Sentiment": "POSITIVE",
                    "SentimentScore": { "Mixed": 25, "Negative": 5, "Neutral": 1, "Positive": 90 }},
                  { "Index": 2, "Sentiment": "NEGATIVE",
                    "SentimentScore": { "Mixed": 25, "Negative": 75, "Neutral": 30, "Positive": 20 }}
                ]
         }
}

-- Example 14304
CREATE OR REPLACE FUNCTION AWSComprehendresponse_translator(EVENT OBJECT)
RETURNS OBJECT
LANGUAGE JAVASCRIPT AS
'
// Combine the scored results and the errors into a single list.
var responses = new Array(EVENT.translatorData.data.length);
// output format: array of {
// "Sentiment": (POSITIVE, NEUTRAL, MIXED, NEGATIVE, or ERROR),
// "SentimentScore": <score>, "ErrorMessage": ErrorMessage }.
// If error, set ErrorMessage; otherwise, set SentimentScore.
// Insert good results into proper position.
for(i = 0; i < EVENT.body.ResultList.length; i++) {
   let row = EVENT.body.ResultList[i];
   let result = [row.Index, {"Sentiment": row.Sentiment, "SentimentScore": row.SentimentScore}]
   responses[row.Index] = result
}
// Insert errors.
for(i = 0; i < EVENT.body.ErrorList.length; i++) {
   let row = EVENT.body.ErrorList[i];
   let result = [row.Index, {"Sentiment": "Error", "ErrorMessage": row.ErrorMessage}]
   responses[row.Index] = result
}
return { "body": { "data" : responses } };
';

-- Example 14305
SELECT AWSComprehendresponse_translator(
    parse_json('{
        "translatorData": {
            "data": [[0, "I am so happy we got a sunny day for my birthday."],
                    [1, "$$$$$."],
                    [2, "Today is my last day in the old house."]]
                          }
        "body": {
            "ErrorList":  [ { "ErrorCode": 57,  "ErrorMessage": "Language unknown",  "Index": 1 } ],
            "ResultList": [
                            { "Index": 0,  "Sentiment": "POSITIVE",
                              "SentimentScore": { "Mixed": 25,  "Negative": 5,  "Neutral": 1,  "Positive": 90 }
                            },
                            { "Index": 2, "Sentiment": "NEGATIVE",
                              "SentimentScore": { "Mixed": 25,  "Negative": 75,  "Neutral": 30,  "Positive": 20 }
                            }
                          ]
            },
        }'
    )
);

-- Example 14306
CREATE OR REPLACE EXTERNAL FUNCTION ComprehendSentiment(thought varchar)
RETURNS VARIANT
API_INTEGRATION = aws_comprehend_gateway
request_translator = db_name.schema_name.AWSComprehendrequest_translator
response_translator = db_name.schema_name.AWSComprehendresponse_translator
AS 'https://<MY_GATEWAY>.execute-api.us-east-1.amazonaws.com/test/comprehend_proxy';

-- Example 14307
DESCRIBE FUNCTION ComprehendSentiment(VARCHAR);

-- Example 14308
SELECT ComprehendSentiment('Today is a good day');

-- Example 14309
{"Sentiment": "POSITIVE",
 "SentimentScore":{"Mixed":0.002436627633869648,
                   "Negative":0.0014803812373429537,
                   "Neutral":0.015923455357551575,
                   "Positive": 0.9801595211029053}}

-- Example 14310
SELECT ComprehendSentiment(vc), vc FROM demo;

-- Example 14311
select my_request_translator_function(parse_json('{"body": {"data": [ [0,"cat",867], [1,"dog",5309] ] } }'));

-- Example 14312
my_response_translator_udf(my_request_translator_udf(x)) = x

-- Example 14313
SELECT test_case_column
    FROM test_table
    WHERE my_response_translator_udf(my_request_translator_udf(x)) != x;

-- Example 14314
sudo dpkg -i snowflake-cli-<version>.deb

-- Example 14315
sudo rpm -i snowflake-cli-<version>.deb

-- Example 14316
snow --help

-- Example 14317
Usage: snow [OPTIONS] COMMAND [ARGS]...

Snowflake CLI tool for developers.

╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --version                           Shows version of the Snowflake CLI                                                                   │
│ --info                              Shows information about the Snowflake CLI                                                            │
│ --config-file                 FILE  Specifies Snowflake CLI configuration file that should be used [default: None]                       │
│ --install-completion                Install completion for the current shell.                                                            │
│ --show-completion                   Show completion for the current shell, to copy it or customize the installation.                     │
│ --help                -h            Show this message and exit.                                                                          │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ app          Manages a Snowflake Native App                                                                                              │
│ connection   Manages connections to Snowflake.                                                                                           │
│ cortex       Provides access to Snowflake Cortex.                                                                                        │
│ git          Manages git repositories in Snowflake.                                                                                      │
│ notebook     Manages notebooks in Snowflake.                                                                                             │
│ object       Manages Snowflake objects like warehouses and stages                                                                        │
│ snowpark     Manages procedures and functions.                                                                                           │
│ spcs         Manages Snowpark Container Services compute pools, services, image registries, and image repositories.                      │
│ sql          Executes Snowflake query.                                                                                                   │
│ stage        Manages stages.                                                                                                             │
│ streamlit    Manages a Streamlit app in Snowflake.                                                                                       │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

