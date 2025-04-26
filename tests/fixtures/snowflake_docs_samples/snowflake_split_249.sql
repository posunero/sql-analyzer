-- Example 16662
topics.regex="topic[0-9]"
snowflake.topic2table.map="topic[0-4]:low_range,topic[5-9]:high_range"

-- Example 16663
$ openssl genrsa -out rsa_key.pem 2048

-- Example 16664
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 <algorithm> -inform PEM -out rsa_key.p8

-- Example 16665
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 aes256 -inform PEM -out rsa_key.p8

-- Example 16666
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6TAbBgkqhkiG9w0BBQMwDgQILYPyCppzOwECAggABIIEyLiGSpeeGSe3xHP1
wHLjfCYycUPennlX2bd8yX8xOxGSGfvB+99+PmSlex0FmY9ov1J8H1H9Y3lMWXbL
...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 16667
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 16668
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy+Fw2qv4Roud3l6tjPH4
zxybHjmZ5rhtCz9jppCV8UTWvEXxa88IGRIHbJ/PwKW/mR8LXdfI7l/9vCMXX4mk
...
-----END PUBLIC KEY-----

-- Example 16669
ALTER USER jsmith SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 16670
DESC USER jsmith;
+-------------------------------+-----------------------------------------------------+---------+-------------------------------------------------------------------------------+
| property                      | value                                               | default | description                                                                   |
|-------------------------------+-----------------------------------------------------+---------+-------------------------------------------------------------------------------|
| NAME                          | JSMITH                                              | null    | Name                                                                          |
...
...
| RSA_PUBLIC_KEY_FP             | SHA256:nvnONUsfiuycCLMXIEWG4eTp4FjhVUZQUQbNpbSHXiA= | null    | Fingerprint of user's RSA public key.                                         |
| RSA_PUBLIC_KEY_2_FP           | null                                                | null    | Fingerprint of user's second RSA public key.                                  |
+-------------------------------+-----------------------------------------------------+---------+-------------------------------------------------------------------------------+

-- Example 16671
curl -X POST -H "Content-Type: application/json" --data @<path>/<config_file>.json http://localhost:8083/connectors

-- Example 16672
<kafka_dir>/bin/connect-standalone.sh <kafka_dir>/<path>/connect-standalone.properties <kafka_dir>/config/SF_connect.properties

-- Example 16673
net.snowflake:spark-snowflake_C.C:N.N.N-spark_P.P

-- Example 16674
net.snowflake:spark-snowflake_2.12:2.16.0-spark_3.4

-- Example 16675
net.snowflake:spark-snowflake_C.C:N.N.N

-- Example 16676
net.snowflake:spark-snowflake_2.13:3.1.1

-- Example 16677
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 16678
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 16679
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 16680
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 16681
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 16682
gpg: keyserver receive failed: Server indicated a failure

-- Example 16683
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 16684
$ gpg --verify spark-snowflake_x.xx-N.N.N-spark_P.P.jar.asc spark-snowflake_x.xx-N.N.N-spark_P.P.jar
gpg: Signature made Wed 22 Feb 2017 04:31:58 PM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg\ @snowflake.net>"

-- Example 16685
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 16686
$ gpg --delete-key "Snowflake Computing"

-- Example 16687
spark-shell --packages net.snowflake:snowflake-jdbc:3.13.22,net.snowflake:spark-snowflake_2.12:2.16.0-spark_3.4

-- Example 16688
spark-shell --packages org.apache.hadoop:hadoop-aws:2.7.1,org.apache.httpcomponents:httpclient:4.3.6,org.apache.httpcomponents:httpcore:4.3.3

-- Example 16689
val SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

-- Example 16690
import net.snowflake.spark.snowflake.Utils.SNOWFLAKE_SOURCE_NAME

-- Example 16691
SnowflakeConnectorUtils.disablePushdownSession(spark)

-- Example 16692
val df = sparkSession.read.format(SNOWFLAKE_SOURCE_NAME)
  .options(sfOptions)
  .option("query", query)
  .option("autopushdown", "off")
  .load()

-- Example 16693
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t1")
    .load()

-- Example 16694
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("query", "SELECT DEPT, SUM(SALARY) AS SUM_SALARY FROM T1")
    .load()

-- Example 16695
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t2")
    .mode(SaveMode.Overwrite)
    .save()

-- Example 16696
val rdd = myDataFrame.toJSON
val schema = new StructType(Array(StructField("JSON", StringType)))
val jsonDataFrame = sqlContext.createDataFrame(
            rdd.map(s => Row(s)), schema)

-- Example 16697
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
public class SnowflakeJDBCExample {
  public static void main(String[] args) throws Exception {
    String jdbcUrl = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/";

    Properties properties = new Properties();
    properties.put("user", "peter");
    properties.put("password", "test");
    properties.put("account", "myorganization-myaccount");
    properties.put("warehouse", "mywh");
    properties.put("db", "mydb");
    properties.put("schema", "public");

    // get connection
    System.out.println("Create JDBC connection");
    Connection connection = DriverManager.getConnection(jdbcUrl, properties);
    System.out.println("Done creating JDBC connection\n");
    // create statement
    System.out.println("Create JDBC statement");
    Statement statement = connection.createStatement();
    System.out.println("Done creating JDBC statement\n");
    // create a table
    System.out.println("Create my_variant_table table");
    statement.executeUpdate("create or replace table my_variant_table(json VARIANT)");
    statement.close();
    System.out.println("Done creating demo table\n");

    connection.close();
    System.out.println("Close connection\n");
  }
}

-- Example 16698
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "my_variant_table")
    .mode(SaveMode.Append)
    .save()

-- Example 16699
var sfOptions = Map(
    "sfURL" -> "<account_identifier>.snowflakecomputing.com",
    "sfUser" -> "<user_name>",
    "sfPassword" -> "<password>",
    "sfDatabase" -> "<database>",
    "sfSchema" -> "<schema>",
    "sfWarehouse" -> "<warehouse>"
    )
Utils.runQuery(sfOptions, "CREATE TABLE MY_TABLE(A INTEGER)")

-- Example 16700
java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("UTC"))

-- Example 16701
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

-- Example 16702
bin/pyspark --packages net.snowflake:snowflake-jdbc:3.13.22,net.snowflake:spark-snowflake_2.12:2.11.0-spark_3.3

-- Example 16703
sc._jvm.net.snowflake.spark.snowflake.SnowflakeConnectorUtils.disablePushdownSession(sc._jvm.org.apache.spark.sql.SparkSession.builder().getOrCreate())

-- Example 16704
df = spark.read.format(SNOWFLAKE_SOURCE_NAME) \
  .options(**sfOptions) \
  .option("query",  query) \
  .option("autopushdown", "off") \
  .load()

-- Example 16705
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

-- Example 16706
val dfWithRowsToShow = originalDf.sort("my_col").limit(5)
dfWithRowsToShow.show(5)

-- Example 16707
spark-submit --packages net.snowflake:snowflake-jdbc:3.13.22,net.snowflake:spark-snowflake_2.12:2.11.0-spark_3.3 <file.py>

-- Example 16708
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

-- Example 16709
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

-- Example 16710
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

-- Example 16711
sc.hadoopConfiguration.set("fs.azure", "org.apache.hadoop.fs.azure.NativeAzureFileSystem")
sc.hadoopConfiguration.set("fs.AbstractFileSystem.wasb.impl", "org.apache.hadoop.fs.azure.Wasb")
sc.hadoopConfiguration.set("fs.azure.sas.<container>.<account>.<azure_endpoint>", <azure_sas>)

-- Example 16712
// ... assuming sfOptions contains Snowflake connector options

// Add to the options request to keep connection alive
sfOptions += ("USE_CACHED_RESULT" -> "false")

// ... now use sfOptions with the .options() method

-- Example 16713
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

-- Example 16714
val hadoopConf = sc.hadoopConfiguration
hadoopConf.set("fs.s3a.access.key", <accessKey>)
hadoopConf.set("fs.s3a.secret.key", <secretKey>)

-- Example 16715
val hadoopConf = sc.hadoopConfiguration
hadoopConf.set("fs.s3.impl", "org.apache.hadoop.fs.s3native.NativeS3FileSystem")
hadoopConf.set("fs.s3.awsAccessKeyId", <accessKey>)
hadoopConf.set("fs.s3.awsSecretAccessKey", <secretKey>)

-- Example 16716
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

-- Example 16717
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

-- Example 16718
val hadoopConf = sc.hadoopConfiguration
sc.hadoopConfiguration.set("fs.azure", "org.apache.hadoop.fs.azure.NativeAzureFileSystem")
sc.hadoopConfiguration.set("fs.AbstractFileSystem.wasb.impl", "org.apache.hadoop.fs.azure.Wasb")
sc.hadoopConfiguration.set("fs.azure.sas.<container>.<account>.<azure_endpoint>", <azure_sas>)

-- Example 16719
val SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

-- Example 16720
import net.snowflake.spark.snowflake.Utils.SNOWFLAKE_SOURCE_NAME

-- Example 16721
SnowflakeConnectorUtils.disablePushdownSession(spark)

-- Example 16722
val df = sparkSession.read.format(SNOWFLAKE_SOURCE_NAME)
  .options(sfOptions)
  .option("query", query)
  .option("autopushdown", "off")
  .load()

-- Example 16723
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t1")
    .load()

-- Example 16724
val df: DataFrame = sqlContext.read
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("query", "SELECT DEPT, SUM(SALARY) AS SUM_SALARY FROM T1")
    .load()

-- Example 16725
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "t2")
    .mode(SaveMode.Overwrite)
    .save()

-- Example 16726
val rdd = myDataFrame.toJSON
val schema = new StructType(Array(StructField("JSON", StringType)))
val jsonDataFrame = sqlContext.createDataFrame(
            rdd.map(s => Row(s)), schema)

-- Example 16727
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
public class SnowflakeJDBCExample {
  public static void main(String[] args) throws Exception {
    String jdbcUrl = "jdbc:snowflake://myorganization-myaccount.snowflakecomputing.com/";

    Properties properties = new Properties();
    properties.put("user", "peter");
    properties.put("password", "test");
    properties.put("account", "myorganization-myaccount");
    properties.put("warehouse", "mywh");
    properties.put("db", "mydb");
    properties.put("schema", "public");

    // get connection
    System.out.println("Create JDBC connection");
    Connection connection = DriverManager.getConnection(jdbcUrl, properties);
    System.out.println("Done creating JDBC connection\n");
    // create statement
    System.out.println("Create JDBC statement");
    Statement statement = connection.createStatement();
    System.out.println("Done creating JDBC statement\n");
    // create a table
    System.out.println("Create my_variant_table table");
    statement.executeUpdate("create or replace table my_variant_table(json VARIANT)");
    statement.close();
    System.out.println("Done creating demo table\n");

    connection.close();
    System.out.println("Close connection\n");
  }
}

-- Example 16728
df.write
    .format(SNOWFLAKE_SOURCE_NAME)
    .options(sfOptions)
    .option("dbtable", "my_variant_table")
    .mode(SaveMode.Append)
    .save()

