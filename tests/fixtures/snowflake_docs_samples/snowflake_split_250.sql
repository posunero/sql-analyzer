-- Example 16729
var sfOptions = Map(
    "sfURL" -> "<account_identifier>.snowflakecomputing.com",
    "sfUser" -> "<user_name>",
    "sfPassword" -> "<password>",
    "sfDatabase" -> "<database>",
    "sfSchema" -> "<schema>",
    "sfWarehouse" -> "<warehouse>"
    )
Utils.runQuery(sfOptions, "CREATE TABLE MY_TABLE(A INTEGER)")

-- Example 16730
java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("UTC"))

-- Example 16731
import org.apache.spark.sql._

//
// Configure your Snowflake environment
//
var sfOptions = Map(
    "sfURL" -> "<account_identifier>.snowflakecomputing.com",
    "sfUser" -> "<user_name>",
    "sfPassword" -> "<password>",
    "sfDatabase" -> "<database>",
    "sfSchema" -> "<schema>",
    "sfWarehouse" -> "<warehouse>"
)

//
// Create a DataFrame from a Snowflake table
//
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t1")
    .load()

//
// DataFrames can also be populated via a SQL query
//
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("query", "select c1, count(*) from t1 group by c1")
    .load()

//
// Join, augment, aggregate, etc. the data in Spark and then use the
// Data Source API to write the data back to a table in Snowflake
//
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t2")
    .mode(SaveMode.Overwrite)
    .save()

-- Example 16732
bin/pyspark --packages net.snowflake:snowflake-jdbc:3.13.22,net.snowflake:spark-snowflake_2.12:2.11.0-spark_3.3

-- Example 16733
sc._jvm.net.snowflake.spark.snowflake.SnowflakeConnectorUtils.disablePushdownSession(sc._jvm.org.apache.spark.sql.SparkSession.builder().getOrCreate())

-- Example 16734
df = spark.read.format(SNOWFLAKE_SOURCE_NAME) \
  .options(**sfOptions) \
  .option("query",  query) \
  .option("autopushdown", "off") \
  .load()

-- Example 16735
from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local").appName("Simple App").getOrCreate()

# You might need to set these
sc._jsc.hadoopConfiguration().set("fs.s3n.awsAccessKeyId", "<AWS_KEY>")
sc._jsc.hadoopConfiguration().set("fs.s3n.awsSecretAccessKey", "<AWS_SECRET>")

# Set options below
sfOptions = {
  "sfURL" : "<account_identifier>.snowflakecomputing.com",
  "sfUser" : "<user_name>",
  "sfPassword" : "<password>",
  "sfDatabase" : "<database>",
  "sfSchema" : "<schema>",
  "sfWarehouse" : "<warehouse>",
  "sfRole" : "Accountadmin"
}

SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

df = spark.read.format(SNOWFLAKE_SOURCE_NAME) \
  .options(**sfOptions) \
  .option("query",  "select 1 as my_num union all select 2 as my_num") \
  .load()

df.show()

-- Example 16736
val dfWithRowsToShow = originalDf.sort("my_col").limit(5)
dfWithRowsToShow.show(5)

-- Example 16737
spark-submit --packages net.snowflake:snowflake-jdbc:3.13.22,net.snowflake:spark-snowflake_2.12:2.11.0-spark_3.3 <file.py>

-- Example 16738
from pyspark.sql import SQLContext
from pyspark import SparkConf, SparkContext
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
import re
import os

with open("<path>/rsa_key.p8", "rb") as key_file:
  p_key = serialization.load_pem_private_key(
    key_file.read(),
    password = os.environ['PRIVATE_KEY_PASSPHRASE'].encode(),
    backend = default_backend()
    )

pkb = p_key.private_bytes(
  encoding = serialization.Encoding.PEM,
  format = serialization.PrivateFormat.PKCS8,
  encryption_algorithm = serialization.NoEncryption()
  )

pkb = pkb.decode("UTF-8")
pkb = re.sub("-*(BEGIN|END) PRIVATE KEY-*\n","",pkb).replace("\n","")

sc = SparkContext("local", "Simple App")
spark = SQLContext(sc)
spark_conf = SparkConf().setMaster('local').setAppName('Simple App')

sfOptions = {
  "sfURL" : "<account_identifier>.snowflakecomputing.com",
  "sfUser" : "<user_name>",
  "pem_private_key" : pkb,
  "sfDatabase" : "<database>",
  "sfSchema" : "schema",
  "sfWarehouse" : "<warehouse>"
}

SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

df = spark.read.format(SNOWFLAKE_SOURCE_NAME) \
    .options(**sfOptions) \
    .option("query", "COLORS") \
    .load()

df.show()

-- Example 16739
// spark connector version

val SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"
import net.snowflake.spark.snowflake2.Utils.SNOWFLAKE_SOURCE_NAME
import org.apache.spark.sql.DataFrame

var sfOptions = Map(
    "sfURL" -> "<account_identifier>.snowflakecomputing.com",
    "sfUser" -> "<username>",
    "sfAuthenticator" -> "oauth",
    "sfToken" -> "<external_oauth_access_token>",
    "sfDatabase" -> "<database>",
    "sfSchema" -> "<schema>",
    "sfWarehouse" -> "<warehouse>"
)

//
// Create a DataFrame from a Snowflake table
//
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "region")
    .load()

//
// Join, augment, aggregate, etc. the data in Spark and then use the
// Data Source API to write the data back to a table in Snowflake
//
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t2")
    .mode(SaveMode.Overwrite)
    .save()

-- Example 16740
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *

sc = SparkContext("local", "Simple App")
spark = SQLContext(sc)
spark_conf = SparkConf().setMaster('local').setAppName('<APP_NAME>')

# You might need to set these
sc._jsc.hadoopConfiguration().set("fs.s3n.awsAccessKeyId", "<AWS_KEY>")
sc._jsc.hadoopConfiguration().set("fs.s3n.awsSecretAccessKey", "<AWS_SECRET>")

# Set options below
sfOptions = {
  "sfURL" : "<account_identifier>.snowflakecomputing.com",
  "sfUser" : "<user_name>",
  "sfAuthenticator" : "oauth",
  "sfToken" : "<external_oauth_access_token>",
  "sfDatabase" : "<database>",
  "sfSchema" : "<schema>",
  "sfWarehouse" : "<warehouse>"
}

SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

df = spark.read.format(SNOWFLAKE_SOURCE_NAME) \
  .options(**sfOptions) \
  .option("query",  "select 1 as my_num union all select 2 as my_num") \
  .load()

df.show()

-- Example 16741
sc.hadoopConfiguration.set("fs.azure", "org.apache.hadoop.fs.azure.NativeAzureFileSystem")
sc.hadoopConfiguration.set("fs.AbstractFileSystem.wasb.impl", "org.apache.hadoop.fs.azure.Wasb")
sc.hadoopConfiguration.set("fs.azure.sas.<container>.<account>.<azure_endpoint>", <azure_sas>)

-- Example 16742
// ... assuming sfOptions contains Snowflake connector options

// Add to the options request to keep connection alive
sfOptions += ("USE_CACHED_RESULT" -> "false")

// ... now use sfOptions with the .options() method

-- Example 16743
sc.hadoopConfiguration.set("fs.s3n.awsAccessKeyId", "<access_key>")
sc.hadoopConfiguration.set("fs.s3n.awsSecretAccessKey", "<secret_key>")

// Then, configure your Snowflake environment
//
var sfOptions = Map(
    "sfURL" -> "<account_identifier>.snowflakecomputing.com",
    "sfUser" -> "<user_name>",
    "sfPassword" -> "<password>",
    "sfDatabase" -> "<database>",
    "sfSchema" -> "<schema>",
    "sfWarehouse" -> "<warehouse>",
    "awsAccessKey" -> sc.hadoopConfiguration.get("fs.s3n.awsAccessKeyId"),
    "awsSecretKey" -> sc.hadoopConfiguration.get("fs.s3n.awsSecretAccessKey"),
    "tempdir" -> "s3n://<temp-bucket-name>"
)

-- Example 16744
val hadoopConf = sc.hadoopConfiguration
hadoopConf.set("fs.s3a.access.key", <accessKey>)
hadoopConf.set("fs.s3a.secret.key", <secretKey>)

-- Example 16745
val hadoopConf = sc.hadoopConfiguration
hadoopConf.set("fs.s3.impl", "org.apache.hadoop.fs.s3native.NativeS3FileSystem")
hadoopConf.set("fs.s3.awsAccessKeyId", <accessKey>)
hadoopConf.set("fs.s3.awsSecretAccessKey", <secretKey>)

-- Example 16746
import com.amazonaws.services.securitytoken.AWSSecurityTokenServiceClient
import com.amazonaws.services.securitytoken.model.GetSessionTokenRequest

import net.snowflake.spark.snowflake.Parameters

// ...

val sts_client = new AWSSecurityTokenServiceClient()
val session_token_request = new GetSessionTokenRequest()

// Set the token duration to 2 hours.

session_token_request.setDurationSeconds(7200)
val session_token_result = sts_client.getSessionToken(session_token_request)
val session_creds = session_token_result.getCredentials()

// Create a new set of Snowflake connector options, based on the existing
// sfOptions definition, with additional temporary credential options that override
// the credential options in sfOptions.
// Note that constants from Parameters are used to guarantee correct
// key names, but literal values, such as temporary_aws_access_key_id are, of course,
// also allowed.

var sfOptions2 = collection.mutable.Map[String, String]() ++= sfOptions
sfOptions2 += (Parameters.PARAM_TEMP_KEY_ID -> session_creds.getAccessKeyId())
sfOptions2 += (Parameters.PARAM_TEMP_KEY_SECRET -> session_creds.getSecretAccessKey())
sfOptions2 += (Parameters.PARAM_TEMP_SESSION_TOKEN -> session_creds.getSessionToken())

-- Example 16747
sc.hadoopConfiguration.set("fs.azure", "org.apache.hadoop.fs.azure.NativeAzureFileSystem")
sc.hadoopConfiguration.set("fs.AbstractFileSystem.wasb.impl", "org.apache.hadoop.fs.azure.Wasb")
sc.hadoopConfiguration.set("fs.azure.sas.<container>.<account>.<azure_endpoint>", <azure_sas>)

// Then, configure your Snowflake environment
//
val sfOptions = Map(
  "sfURL" -> "<account_identifier>.snowflakecomputing.com",
  "sfUser" -> "<user_name>",
  "sfPassword" -> "<password>",
  "sfDatabase" -> "<database_name>",
  "sfSchema" -> "<schema_name>",
  "sfWarehouse" -> "<warehouse_name>",
  "sfCompress" -> "on",
  "sfSSL" -> "on",
  "tempdir" -> "wasb://<azure_container>@<azure_account>.<Azure_endpoint>/",
  "temporary_azure_sas_token" -> "<azure_sas>"
)

-- Example 16748
val hadoopConf = sc.hadoopConfiguration
sc.hadoopConfiguration.set("fs.azure", "org.apache.hadoop.fs.azure.NativeAzureFileSystem")
sc.hadoopConfiguration.set("fs.AbstractFileSystem.wasb.impl", "org.apache.hadoop.fs.azure.Wasb")
sc.hadoopConfiguration.set("fs.azure.sas.<container>.<account>.<azure_endpoint>", <azure_sas>)

-- Example 16749
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = OAUTH2
  API_AUTHENTICATION = <security_integration_name>
  OAUTH_SCOPES = ( '<scope_1>' [ , '<scope_2>' ... ] )
  [ COMMENT = '<string_literal>' ]

-- Example 16750
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '<string_literal>'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '<string_literal>'
  API_AUTHENTICATION = <security_integration_name>;
  [ COMMENT = '<string_literal>' ]

-- Example 16751
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = '<cloud_provider_security_integration>'
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]

-- Example 16752
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = PASSWORD
  USERNAME = '<username>'
  PASSWORD = '<password>'
  [ COMMENT = '<string_literal>' ]

-- Example 16753
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = GENERIC_STRING
  SECRET_STRING = '<string_literal>'
  [ COMMENT = '<string_literal>' ]

-- Example 16754
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
TYPE = SYMMETRIC_KEY
ALGORITHM = GENERIC

-- Example 16755
CREATE OR REPLACE SECRET mysecret
  TYPE = OAUTH2
  API_AUTHENTICATION = mysecurityintegration
  OAUTH_SCOPES = ('useraccount')
  COMMENT = 'secret for the service now connector'

-- Example 16756
CREATE SECRET service_now_creds_oauth_code
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '34n;vods4nQsdg09wee4qnfvadH'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '2022-01-06 20:00:00'
  API_AUTHENTICATION = sn_oauth;

-- Example 16757
CREATE SECRET aws_secret
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = myawsiamintegration
  ENABLED = TRUE;

-- Example 16758
CREATE SECRET service_now_creds_pw
  TYPE = password
  USERNAME = 'jsmith1'
  PASSWORD = 'W3dr@fg*7B1c4j';

-- Example 16759
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = OAUTH2
  API_AUTHENTICATION = <security_integration_name>
  OAUTH_SCOPES = ( '<scope_1>' [ , '<scope_2>' ... ] )
  [ COMMENT = '<string_literal>' ]

-- Example 16760
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '<string_literal>'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '<string_literal>'
  API_AUTHENTICATION = <security_integration_name>;
  [ COMMENT = '<string_literal>' ]

-- Example 16761
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = '<cloud_provider_security_integration>'
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]

-- Example 16762
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = PASSWORD
  USERNAME = '<username>'
  PASSWORD = '<password>'
  [ COMMENT = '<string_literal>' ]

-- Example 16763
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
  TYPE = GENERIC_STRING
  SECRET_STRING = '<string_literal>'
  [ COMMENT = '<string_literal>' ]

-- Example 16764
CREATE [ OR REPLACE ] SECRET [ IF NOT EXISTS ] <name>
TYPE = SYMMETRIC_KEY
ALGORITHM = GENERIC

-- Example 16765
CREATE OR REPLACE SECRET mysecret
  TYPE = OAUTH2
  API_AUTHENTICATION = mysecurityintegration
  OAUTH_SCOPES = ('useraccount')
  COMMENT = 'secret for the service now connector'

-- Example 16766
CREATE SECRET service_now_creds_oauth_code
  TYPE = OAUTH2
  OAUTH_REFRESH_TOKEN = '34n;vods4nQsdg09wee4qnfvadH'
  OAUTH_REFRESH_TOKEN_EXPIRY_TIME = '2022-01-06 20:00:00'
  API_AUTHENTICATION = sn_oauth;

-- Example 16767
CREATE SECRET aws_secret
  TYPE = CLOUD_PROVIDER_TOKEN
  API_AUTHENTICATION = myawsiamintegration
  ENABLED = TRUE;

-- Example 16768
CREATE SECRET service_now_creds_pw
  TYPE = password
  USERNAME = 'jsmith1'
  PASSWORD = 'W3dr@fg*7B1c4j';

-- Example 16769
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = { aws_api_gateway | aws_private_api_gateway | aws_gov_api_gateway | aws_gov_private_api_gateway }
  API_AWS_ROLE_ARN = '<iam_role>'
  [ API_KEY = '<api_key>' ]
  API_ALLOWED_PREFIXES = ('<...>')
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16770
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = azure_api_management
  AZURE_TENANT_ID = '<tenant_id>'
  AZURE_AD_APPLICATION_ID = '<azure_application_id>'
  [ API_KEY = '<api_key>' ]
  API_ALLOWED_PREFIXES = ( '<...>' )
  [ API_BLOCKED_PREFIXES = ( '<...>' ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16771
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = google_api_gateway
  GOOGLE_AUDIENCE = '<google_audience_claim>'
  API_ALLOWED_PREFIXES = ( '<...>' )
  [ API_BLOCKED_PREFIXES = ( '<...>' ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16772
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('<...>')
  [ API_BLOCKED_PREFIXES = ('<...>') ]
  [ ALLOWED_AUTHENTICATION_SECRETS = ( { <secret_name> [, <secret_name>, ... ] | all | none } ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16773
CREATE OR REPLACE API INTEGRATION demonstration_external_api_integration_01
  API_PROVIDER = aws_api_gateway
  API_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/my_cloud_account_role'
  API_ALLOWED_PREFIXES = ('https://xyz.execute-api.us-west-2.amazonaws.com/production')
  ENABLED = TRUE;

CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/production/remote_echo';

-- Example 16774
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = { aws_api_gateway | aws_private_api_gateway | aws_gov_api_gateway | aws_gov_private_api_gateway }
  API_AWS_ROLE_ARN = '<iam_role>'
  [ API_KEY = '<api_key>' ]
  API_ALLOWED_PREFIXES = ('<...>')
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16775
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = azure_api_management
  AZURE_TENANT_ID = '<tenant_id>'
  AZURE_AD_APPLICATION_ID = '<azure_application_id>'
  [ API_KEY = '<api_key>' ]
  API_ALLOWED_PREFIXES = ( '<...>' )
  [ API_BLOCKED_PREFIXES = ( '<...>' ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16776
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = google_api_gateway
  GOOGLE_AUDIENCE = '<google_audience_claim>'
  API_ALLOWED_PREFIXES = ( '<...>' )
  [ API_BLOCKED_PREFIXES = ( '<...>' ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16777
CREATE [ OR REPLACE ] API INTEGRATION [ IF NOT EXISTS ] <integration_name>
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('<...>')
  [ API_BLOCKED_PREFIXES = ('<...>') ]
  [ ALLOWED_AUTHENTICATION_SECRETS = ( { <secret_name> [, <secret_name>, ... ] | all | none } ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]
  ;

-- Example 16778
CREATE OR REPLACE API INTEGRATION demonstration_external_api_integration_01
  API_PROVIDER = aws_api_gateway
  API_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/my_cloud_account_role'
  API_ALLOWED_PREFIXES = ('https://xyz.execute-api.us-west-2.amazonaws.com/production')
  ENABLED = TRUE;

CREATE OR REPLACE EXTERNAL FUNCTION local_echo(string_col VARCHAR)
  RETURNS VARIANT
  API_INTEGRATION = demonstration_external_api_integration_01
  AS 'https://xyz.execute-api.us-west-2.amazonaws.com/production/remote_echo';

-- Example 16779
CREATE [ OR REPLACE ] GIT REPOSITORY [ IF NOT EXISTS ] <name>
  ORIGIN = '<repository_url>'
  API_INTEGRATION = <integration_name>
  [ GIT_CREDENTIALS = <secret_name> ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 16780
$ git config --get remote.origin.url
https://github.com/mycompany/My-Repo.git

-- Example 16781
CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = git_secret
  ORIGIN = 'https://github.com/my-account/snowflake-extensions.git';

-- Example 16782
ALTER GIT REPOSITORY <name> SET
  [ GIT_CREDENTIALS = <secret_name> ]
  [ API_INTEGRATION = <integration_name> ]
  [ COMMENT = '<string_literal>' ]

ALTER GIT REPOSITORY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER GIT REPOSITORY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER GIT REPOSITORY <name> UNSET {
  GIT_CREDENTIALS |
  COMMENT }
  [ , ... ]

ALTER GIT REPOSITORY <name> FETCH

-- Example 16783
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 16784
SHOW GIT BRANCHES [ LIKE '<pattern>' ] IN [ GIT REPOSITORY ] <repository_name>

-- Example 16785
SHOW GIT BRANCHES IN snowflake_extensions;

-- Example 16786
--------------------------------------------------------------------------------
| name | path           | checkouts | commit_hash                              |
--------------------------------------------------------------------------------
| main | /branches/main |           | 0f81b1487dfc822df9f73ac6b3096b9ea9e42d69 |
--------------------------------------------------------------------------------

-- Example 16787
SHOW GIT TAGS [ LIKE '<pattern>' ] IN [ GIT REPOSITORY ] <repository_name>

-- Example 16788
SHOW GIT TAGS IN snowflake_extensions;

-- Example 16789
-----------------------------------------------------------------------------------------------------------------------------------------------
| name    | path          | commit_hash                              | author                                     | message                   |
-----------------------------------------------------------------------------------------------------------------------------------------------
| example | /tags/example | 16e262d401297cd097d5d6c266c80ff9f7e1e4be | Gladys Kravits (gladyskravits@example.com) | Example code for preview. |
-----------------------------------------------------------------------------------------------------------------------------------------------

-- Example 16790
{ DESC | DESCRIBE } GIT REPOSITORY <name>

-- Example 16791
DESCRIBE GIT REPOSITORY snowflake_extensions;

-- Example 16792
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| CREATED_ON                    | NAME                 | DATABASE_NAME | SCHEMA_NAME | ORIGIN                                                 | API_INTEGRATION     | GIT_CREDENTIALS           | OWNER        | OWNER_ROLE_TYPE | COMMENT |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_EXTENSIONS | MY_DB         | MAIN        | https://github.com/my-account/snowflake-extensions.git | GIT_API_INTEGRATION | MY_DB.MAIN.GIT_SECRET     | ACCOUNTADMIN | ROLE            |         |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 16793
USE ROLE ACCOUNTADMIN;
CREATE ROLE myco_secrets_admin;
GRANT CREATE SECRET ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_secrets_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

USE ROLE myco_secrets_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE SECRET myco_git_secret
  TYPE = password
  USERNAME = 'gladyskravitz'
  PASSWORD = 'ghp_token';

-- Example 16794
USE ROLE ACCOUNTADMIN;
CREATE ROLE myco_git_admin;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE myco_git_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_git_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_secrets_admin;
GRANT USAGE ON SECRET myco_git_secret TO ROLE myco_git_admin;

USE ROLE myco_git_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-account')
  ALLOWED_AUTHENTICATION_SECRETS = (myco_git_secret)
  ENABLED = TRUE;

-- Example 16795
$ git config --get remote.origin.url

