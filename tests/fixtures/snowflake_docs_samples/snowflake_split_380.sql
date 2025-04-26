-- Example 25435
export PRIVATE_KEY_PASSPHRASE='<passphrase>'

-- Example 25436
set PRIVATE_KEY_PASSPHRASE='<passphrase>'

-- Example 25437
scp -i key.pem /<path>/SnowpipeLambdaCode.py ec2-user@<machine>.<region_id>.compute.amazonaws.com:~/SnowpipeLambdaCode.py

-- Example 25438
ssh -i key.pem ec2-user@<machine>.<region_id>.compute.amazonaws.com

-- Example 25439
sudo yum install -y gcc zlib zlib-devel openssl openssl-devel

wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz

tar -xzvf Python-3.6.1.tgz

cd Python-3.6.1 && ./configure && make

sudo make install

sudo /usr/local/bin/pip3 install virtualenv

/usr/local/bin/virtualenv ~/shrink_venv

source ~/shrink_venv/bin/activate

pip install Pillow

pip install boto3

pip install requests

pip install snowflake-ingest

-- Example 25440
cd $VIRTUAL_ENV/lib/python3.6/site-packages

zip -r9 ~/Snowpipe.zip .

cd ~

zip -g Snowpipe.zip SnowpipeLambdaCode.py

-- Example 25441
aws lambda create-function \
--region us-west-2 \
--function-name IngestFile \
--zip-file fileb://~/Snowpipe.zip \
--role arn:aws:iam::<aws_account_id>:role/lambda-s3-execution-role \
--handler SnowpipeLambdaCode.handler \
--runtime python3.6 \
--profile adminuser \
--timeout 10 \
--memory-size 1024

-- Example 25442
aws lambda add-permission \
--function-name IngestFile \
--region us-west-2 \
--statement-id enable-ingest-calls \
--action "lambda:InvokeFunction" \
--principal s3.amazonaws.com \
--source-arn arn:aws:s3:::<SourceBucket> \
--source-account <aws_account_id> \
--profile adminuser

-- Example 25443
CREATE PIPE <name>
  [ AUTO_INGEST = TRUE | FALSE  ]
  ERROR_INTEGRATION = <integration_name>
  AS <copy_statement>

-- Example 25444
CREATE PIPE mypipe
  AUTO_INGEST = TRUE
  ERROR_INTEGRATION = my_notification_int
  AS
  COPY INTO mydb.public.mytable
  FROM @mydb.public.mystage;

-- Example 25445
ALTER PIPE <name> SET ERROR_INTEGRATION = <integration_name>;

-- Example 25446
ALTER PIPE mypipe SET ERROR_INTEGRATION = my_notification_int;

-- Example 25447
{\"version\":\"1.0\",\"messageId\":\"a62e34bc-6141-4e95-92d8-f04fe43b43f5\",\"messageType\":\"INGEST_FAILED_FILE\",\"timestamp\":\"2021-10-22T19:15:29.471Z\",\"accountName\":\"MYACCOUNT\",\"pipeName\":\"MYDB.MYSCHEMA.MYPIPE\",\"tableName\":\"MYDB.MYSCHEMA.MYTABLE\",\"stageLocation\":\"s3://mybucket/mypath\",\"messages\":[{\"fileName\":\"/file1.csv_0_0_0.csv.gz\",\"firstError\":\"Numeric value 'abc' is not recognized\"}]}

-- Example 25448
CREATE PIPE <name>
  AUTO_INGEST = TRUE
  [ INTEGRATION = '<string>' ]
  ERROR_INTEGRATION = <integration_name>
  AS <copy_statement>

-- Example 25449
CREATE PIPE mypipe
  AUTO_INGEST = TRUE
  INTEGRATION = 'my_storage_int'
  ERROR_INTEGRATION = my_notification_int
  AS
  COPY INTO mydb.public.mytable
  FROM @mydb.public.mystage;

-- Example 25450
ALTER PIPE <name> SET ERROR_INTEGRATION = <integration_name>;

-- Example 25451
ALTER PIPE mypipe SET ERROR_INTEGRATION = my_notification_int;

-- Example 25452
{\"version\":\"1.0\",\"messageId\":\"a62e34bc-6141-4e95-92d8-f04fe43b43f5\",\"messageType\":\"INGEST_FAILED_FILE\",\"timestamp\":\"2021-10-22T19:15:29.471Z\",\"accountName\":\"MYACCOUNT\",\"pipeName\":\"MYDB.MYSCHEMA.MYPIPE\",\"tableName\":\"MYDB.MYSCHEMA.MYTABLE\",\"stageLocation\":\"azure://myaccount.blob.core.windows.net/mycontainer/mypath\",\"messages\":[{\"fileName\":\"/file1.csv_0_0_0.csv.gz\",\"firstError\":\"Numeric value 'abc' is not recognized\"}]}

-- Example 25453
CREATE PIPE <name>
  AUTO_INGEST = TRUE
  [ INTEGRATION = '<string>' ]
  ERROR_INTEGRATION = <integration_name>
  AS <copy_statement>

-- Example 25454
CREATE PIPE mypipe
  AUTO_INGEST = TRUE
  INTEGRATION = 'my_storage_int'
  ERROR_INTEGRATION = my_notification_int
  AS
  COPY INTO mydb.public.mytable
  FROM @mydb.public.mystage;

-- Example 25455
ALTER PIPE <name> SET ERROR_INTEGRATION = <integration_name>;

-- Example 25456
ALTER PIPE mypipe SET ERROR_INTEGRATION = my_notification_int;

-- Example 25457
{\"version\":\"1.0\",\"messageId\":\"a62e34bc-6141-4e95-92d8-f04fe43b43f5\",\"messageType\":\"INGEST_FAILED_FILE\",\"timestamp\":\"2021-10-22T19:15:29.471Z\",\"accountName\":\"MYACCOUNT\",\"pipeName\":\"MYDB.MYSCHEMA.MYPIPE\",\"tableName\":\"MYDB.MYSCHEMA.MYTABLE\",\"stageLocation\":\"gcs://mybucket/mypath\",\"messages\":[{\"fileName\":\"/file1.csv_0_0_0.csv.gz\",\"firstError\":\"Numeric value 'abc' is not recognized\"}]}

-- Example 25458
CREATE STORAGE INTEGRATION <integration_name>
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/')
  [ STORAGE_BLOCKED_LOCATIONS = ('gcs://<bucket>/<path>/', 'gcs://<bucket>/<path>/') ]

-- Example 25459
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket1/path1/sensitivedata/', 'gcs://mybucket2/path2/sensitivedata/');

-- Example 25460
DESC STORAGE INTEGRATION <integration_name>;

-- Example 25461
DESC STORAGE INTEGRATION gcs_int;

+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+
| property                    | property_type | property_value                                                              | property_default |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------|
| ENABLED                     | Boolean       | true                                                                        | false            |
| STORAGE_ALLOWED_LOCATIONS   | List          | gcs://mybucket1/path1/,gcs://mybucket2/path2/                               | []               |
| STORAGE_BLOCKED_LOCATIONS   | List          | gcs://mybucket1/path1/sensitivedata/,gcs://mybucket2/path2/sensitivedata/   | []               |
| STORAGE_GCP_SERVICE_ACCOUNT | String        | service-account-id@project1-123456.iam.gserviceaccount.com                  |                  |
+-----------------------------+---------------+-----------------------------------------------------------------------------+------------------+

-- Example 25462
$ gsutil notification create -t <topic> -f json -e OBJECT_FINALIZE gs://<bucket-name>

-- Example 25463
CREATE NOTIFICATION INTEGRATION <integration_name>
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = '<subscription_id>';

-- Example 25464
CREATE NOTIFICATION INTEGRATION my_notification_int
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = GCP_PUBSUB
  ENABLED = true
  GCP_PUBSUB_SUBSCRIPTION_NAME = 'projects/project-1234/subscriptions/sub2';

-- Example 25465
DESC NOTIFICATION INTEGRATION <integration_name>;

-- Example 25466
DESC NOTIFICATION INTEGRATION my_notification_int;

-- Example 25467
<service_account>@<project_id>.iam.gserviceaccount.com

-- Example 25468
USE SCHEMA mydb.public;

CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int;

-- Example 25469
CREATE PIPE snowpipe_db.public.mypipe
  AUTO_INGEST = true
  INTEGRATION = 'MY_NOTIFICATION_INT'
  AS
    COPY INTO snowpipe_db.public.mytable
      FROM @snowpipe_db.public.mystage/path2;

-- Example 25470
{"executionState":"<value>","oldestFileTimestamp":<value>,"pendingFileCount":<value>,"notificationChannelName":"<value>","numOutstandingMessagesOnChannel":<value>,"lastReceivedMessageTimestamp":"<value>","lastForwardedMessageTimestamp":"<value>","error":<value>,"fault":<value>}

-- Example 25471
CREATE [ OR REPLACE ] PIPE [ IF NOT EXISTS ] <name>
  [ AUTO_INGEST = [ TRUE | FALSE ] ]
  [ ERROR_INTEGRATION = <integration_name> ]
  [ AWS_SNS_TOPIC = '<string>' ]
  [ INTEGRATION = '<string>' ]
  [ COMMENT = '<string_literal>' ]
  AS <copy_statement>

-- Example 25472
CREATE PIPE mypipe
  AS
  COPY INTO mytable
  FROM @mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25473
CREATE PIPE mypipe2
  AS
  COPY INTO mytable(C1, C2)
  FROM (SELECT $5, $4 FROM @mystage)
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25474
CREATE PIPE mypipe3
  AS
  (COPY INTO mytable
    FROM @mystage
    MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE
    INCLUDE_METADATA = (c1= METADATA$START_SCAN_TIME, c2=METADATA$FILENAME)
    FILE_FORMAT = (TYPE = 'JSON'));

-- Example 25475
CREATE PIPE mypipe_s3
  AUTO_INGEST = TRUE
  AWS_SNS_TOPIC = 'arn:aws:sns:us-west-2:001234567890:s3_mybucket'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25476
CREATE PIPE mypipe_gcs
  AUTO_INGEST = TRUE
  INTEGRATION = 'MYINT'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25477
CREATE PIPE mypipe_azure
  AUTO_INGEST = TRUE
  INTEGRATION = 'MYINT'
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25478
CREATE PIPE mypipe_aws
  AUTO_INGEST = TRUE
  AS
  COPY INTO snowpipe_db.public.mytable
  FROM @snowpipe_db.public.mystage
  FILE_FORMAT = (TYPE = 'JSON');

-- Example 25479
{
    "meta":
    {
        "offset": 1,
        "topic": "PressureOverloadWarning",
        "partition": 12,
        "key": "key name",
        "schema_id": 123,
        "CreateTime": 1234567890,
        "headers":
        {
            "name1": "value1",
            "name2": "value2"
        }
    },
    "content":
    {
        "ID": 62,
        "PSI": 451,
        "etc": "..."
    }
}

-- Example 25480
select
       record_metadata:CreateTime,
       record_content:ID
    from table1
    where record_metadata:topic = 'PressureOverloadWarning';

-- Example 25481
+------------+-----+
| CREATETIME | ID  |
+------------+-----+
| 1234567890 | 62  |
+------------+-----+

-- Example 25482
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SCALA
  CALLED ON NULL INPUT
  RUNTIME_VERSION = 2.12
  HANDLER='Echo.echoVarchar'
  AS
  $$
  class Echo {
    def echoVarchar(x : String): String = {
      return x
    }
  }
  $$;

-- Example 25483
SELECT echo_varchar('Hello');

-- Example 25484
SELECT echo_varchar(NULL);

-- Example 25485
CREATE OR REPLACE FUNCTION return_a_null()
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='TemporaryTestLibrary.returnNull'
  AS
  $$
  class TemporaryTestLibrary {
    def returnNull(): String = {
      return null
    }
  }
  $$;

-- Example 25486
SELECT return_a_null();

-- Example 25487
CREATE TABLE objectives (o OBJECT);
INSERT INTO objectives SELECT PARSE_JSON('{"outer_key" : {"inner_key" : "inner_value"} }');

-- Example 25488
CREATE OR REPLACE FUNCTION extract_from_object(x OBJECT, key VARCHAR)
  RETURNS VARIANT
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='VariantLibrary.extract'
  AS
  $$
  import scala.collection.immutable.Map

  class VariantLibrary {
    def extract(m: Map[String, String], key: String): String = {
      return m(key)
    }
  }
  $$;

-- Example 25489
SELECT extract_from_object(o, 'outer_key'),
  extract_from_object(o, 'outer_key')['inner_key'] FROM OBJECTIVES;

-- Example 25490
CREATE OR REPLACE FUNCTION generate_greeting(greeting_words ARRAY)
  RETURNS VARCHAR
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER='StringHandler.handleStrings'
  AS
  $$
  class StringHandler {
    def handleStrings(strings: Array[String]): String = {
      return concatenate(strings)
    }
    private def concatenate(strings: Array[String]): String = {
      var concatenated : String = ""
      for (newString <- strings)  {
          concatenated = concatenated + " " + newString
      }
      return concatenated
    }
  }
  $$;

-- Example 25491
var filename = "@my_stage/filename.txt"
var sfFile = SnowflakeFile.newInstance(filename, false)

-- Example 25492
CREATE OR REPLACE FUNCTION sum_total_sales_snowflake_file(file STRING)
  RETURNS INTEGER
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  PACKAGES=('com.snowflake:snowpark:latest')
  HANDLER='SalesSum.sumTotalSales'
  AS
  $$
  import java.io.InputStream
  import java.io.IOException
  import java.nio.charset.StandardCharsets
  import com.snowflake.snowpark_java.types.SnowflakeFile

  object SalesSum {
    @throws(classOf[IOException])
    def sumTotalSales(filePath: String): Int = {
      var total = -1

      // Use a SnowflakeFile instance to read sales data from a stage.
      val file = SnowflakeFile.newInstance(filePath)
      val stream = file.getInputStream()
      val contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8)

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total
    }
  }
  $$;

-- Example 25493
SELECT sum_total_sales_input_stream(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25494
CREATE OR REPLACE FUNCTION sum_total_sales_input_stream(file STRING)
  RETURNS NUMBER
  LANGUAGE SCALA
  RUNTIME_VERSION = 2.12
  HANDLER = 'SalesSum.sumTotalSales'
  PACKAGES = ('com.snowflake:snowpark:latest')
  AS $$
  import com.snowflake.snowpark.types.Variant
  import java.io.InputStream
  import java.io.IOException
  import java.nio.charset.StandardCharsets
  object SalesSum {
    @throws(classOf[IOException])
    def sumTotalSales(stream: InputStream): Int = {
      val total = -1
      val contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8)

      // Omitted for brevity: code to retrieve sales data from JSON and assign it to the total variable.

      return total
    }
  }
  $$;

-- Example 25495
SELECT sum_total_sales_input_stream(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25496
var filename = "@my_stage/filename.txt"
var sfFile = SnowflakeFile.newInstance(filename, false)

-- Example 25497
CREATE OR REPLACE PROCEDURE file_reader_scala_proc_snowflakefile(input VARCHAR)
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = 2.12
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream
import java.nio.charset.StandardCharsets
import com.snowflake.snowpark_java.types.SnowflakeFile
import com.snowflake.snowpark_java.Session

object FileReader {
  def execute(session: Session, fileName: String): String = {
    var input: InputStream = SnowflakeFile.newInstance(fileName).getInputStream()
    return new String(input.readAllBytes(), StandardCharsets.UTF_8)
  }
}
$$;

-- Example 25498
CALL file_reader_scala_proc_snowflakefile(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25499
CREATE OR REPLACE PROCEDURE file_reader_scala_proc_input(input VARCHAR)
RETURNS VARCHAR
LANGUAGE SCALA
RUNTIME_VERSION = 2.12
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream
import java.nio.charset.StandardCharsets
import com.snowflake.snowpark_java.Session

object FileReader {
  def execute(session: Session, stream: InputStream): String = {
    val contents = new String(stream.readAllBytes(), StandardCharsets.UTF_8)
    return contents
  }
}
$$;

-- Example 25500
CALL file_reader_scala_proc_input(BUILD_SCOPED_FILE_URL('@sales_data_stage', '/car_sales.json'));

-- Example 25501
CREATE OR REPLACE PROCEDURE file_reader_java_proc_snowflakefile(input VARCHAR)
RETURNS VARCHAR
LANGUAGE JAVA
RUNTIME_VERSION = 11
HANDLER = 'FileReader.execute'
PACKAGES=('com.snowflake:snowpark:latest')
AS $$
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import com.snowflake.snowpark_java.types.SnowflakeFile;
import com.snowflake.snowpark_java.Session;

class FileReader {
  public String execute(Session session, String fileName) throws IOException {
    InputStream input = SnowflakeFile.newInstance(fileName).getInputStream();
    return new String(input.readAllBytes(), StandardCharsets.UTF_8);
  }
}
$$;

