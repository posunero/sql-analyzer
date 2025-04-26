-- Example 16595
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE developer;

-- Example 16596
USE ROLE developer;

CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'get_translation'
EXTERNAL_ACCESS_INTEGRATIONS = (google_apis_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = oauth_token )
AS
$$
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

-- Example 16597
GRANT USAGE ON FUNCTION google_translate_python(string, string) TO ROLE user;

-- Example 16598
USE ROLE user;
SELECT google_translate_python('Happy Thursday!', 'zh-CN');

-- Example 16599
-------------------------------------------------------
| GOOGLE_TRANSLATE_PYTHON('HAPPY THURSDAY!', 'ZH-CN') |
-------------------------------------------------------
| 快乐星期四！                                          |
-------------------------------------------------------

-- Example 16600
ALTER EXTERNAL ACCESS INTEGRATION [ IF EXISTS ] <name> SET
  [ ALLOWED_NETWORK_RULES = (<rule_name> [ , <rule_name> ... ]) ]
  [ ALLOWED_API_AUTHENTICATION_INTEGRATIONS = ( { <integration_name_1> [, <integration_name_2>, ... ] | none } ) ]
  [ ALLOWED_AUTHENTICATION_SECRETS = ( { <secret_name> [ , <secret_name> ... ] | all | none } ) ]
  [ ENABLED = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ] ]

ALTER EXTERNAL ACCESS INTEGRATION [ IF EXISTS ] <name> UNSET {
  ALLOWED_NETWORK_RULES |
  ALLOWED_API_AUTHENTICATION_INTEGRATIONS |
  ALLOWED_AUTHENTICATION_SECRETS |
  COMMENT |
  TAG <tag_name> }
  [ , ... ]

-- Example 16601
ALTER EXTERNAL ACCESS INTEGRATION IF EXISTS dev_integration
  SET ALLOWED_AUTHENTICATION_SECRETS = (my_new_secret);

-- Example 16602
ALTER EXTERNAL ACCESS INTEGRATION IF EXISTS dev_integration_disabled
  SET ENABLED = FALSE;

ALTER EXTERNAL ACCESS INTEGRATION IF EXISTS dev_integration_disabled
  SET COMMENT = 'Disabled until the end of the Q1.';

-- Example 16603
DROP [ { API | CATALOG | EXTERNAL ACCESS | NOTIFICATION | SECURITY | STORAGE } ] INTEGRATION [ IF EXISTS ] <name>

-- Example 16604
SHOW INTEGRATIONS LIKE 't2%';

DROP INTEGRATION t2;

SHOW INTEGRATIONS LIKE 't2%';

-- Example 16605
DROP INTEGRATION IF EXISTS t2;

-- Example 16606
SHOW [ { API | CATALOG | EXTERNAL ACCESS | NOTIFICATION | SECURITY | STORAGE } ] INTEGRATIONS [ LIKE '<pattern>' ]

-- Example 16607
SHOW NOTIFICATION INTEGRATIONS;

-- Example 16608
SHOW INTEGRATIONS LIKE 'line%';

-- Example 16609
-- Use a role that can create and manage roles and privileges.
USE ROLE securityadmin;

-- Create a Snowflake role with the privileges to work with the connector.
CREATE ROLE kafka_connector_role_1;

-- Grant privileges on the database.
GRANT USAGE ON DATABASE kafka_db TO ROLE kafka_connector_role_1;

-- Grant privileges on the schema.
GRANT USAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE TABLE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE STAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE PIPE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will load data into an existing table.
GRANT OWNERSHIP ON TABLE existing_table1 TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will stage data files in an existing internal stage: (not recommended).
GRANT READ, WRITE ON STAGE existing_stage1 TO ROLE kafka_connector_role_1;

-- Grant the custom role to an existing user.
GRANT ROLE kafka_connector_role_1 TO USER kafka_connector_user_1;

-- Set the custom role as the default role for the user.
-- If you encounter an 'Insufficient privileges' error, verify the role that has the OWNERSHIP privilege on the user.
ALTER USER kafka_connector_user_1 SET DEFAULT_ROLE = kafka_connector_role_1;

-- Example 16610
tar xzvf kafka_<scala_version>-<kafka_version>.tgz

-- Example 16611
{
  "name":"XYZCompanySensorData",
  "config":{
    "connector.class":"com.snowflake.kafka.connector.SnowflakeSinkConnector",
    "tasks.max":"8",
    "topics":"topic1,topic2",
    "snowflake.topic2table.map": "topic1:table1,topic2:table2",
    "buffer.count.records":"10000",
    "buffer.flush.time":"60",
    "buffer.size.bytes":"5000000",
    "snowflake.url.name":"myorganization-myaccount.snowflakecomputing.com:443",
    "snowflake.user.name":"jane.smith",
    "snowflake.private.key":"xyz123",
    "snowflake.private.key.passphrase":"jkladu098jfd089adsq4r",
    "snowflake.database.name":"mydb",
    "snowflake.schema.name":"myschema",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "value.converter":"com.snowflake.kafka.connector.records.SnowflakeAvroConverter",
    "value.converter.schema.registry.url":"http://localhost:8081",
    "value.converter.basic.auth.credentials.source":"USER_INFO",
    "value.converter.basic.auth.user.info":"jane.smith:MyStrongPassword"
  }
}

-- Example 16612
connector.class=com.snowflake.kafka.connector.SnowflakeSinkConnector
tasks.max=8
topics=topic1,topic2
snowflake.topic2table.map= topic1:table1,topic2:table2
buffer.count.records=10000
buffer.flush.time=60
buffer.size.bytes=5000000
snowflake.url.name=myorganization-myaccount.snowflakecomputing.com:443
snowflake.user.name=jane.smith
snowflake.private.key=xyz123
snowflake.private.key.passphrase=jkladu098jfd089adsq4r
snowflake.database.name=mydb
snowflake.schema.name=myschema
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=com.snowflake.kafka.connector.records.SnowflakeAvroConverter
value.converter.schema.registry.url=http://localhost:8081
value.converter.basic.auth.credentials.source=USER_INFO
value.converter.basic.auth.user.info=jane.smith:MyStrongPassword

-- Example 16613
topics="topic1,topic2,topic5,topic6"
snowflake.topic2table.map="topic1:low_range,topic2:low_range,topic5:high_range,topic6:high_range"

-- Example 16614
topics.regex="topic[0-9]"
snowflake.topic2table.map="topic[0-4]:low_range,topic[5-9]:high_range"

-- Example 16615
$ openssl genrsa -out rsa_key.pem 2048

-- Example 16616
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 <algorithm> -inform PEM -out rsa_key.p8

-- Example 16617
$ openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 aes256 -inform PEM -out rsa_key.p8

-- Example 16618
-----BEGIN ENCRYPTED PRIVATE KEY-----
MIIE6TAbBgkqhkiG9w0BBQMwDgQILYPyCppzOwECAggABIIEyLiGSpeeGSe3xHP1
wHLjfCYycUPennlX2bd8yX8xOxGSGfvB+99+PmSlex0FmY9ov1J8H1H9Y3lMWXbL
...
-----END ENCRYPTED PRIVATE KEY-----

-- Example 16619
$ openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

-- Example 16620
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy+Fw2qv4Roud3l6tjPH4
zxybHjmZ5rhtCz9jppCV8UTWvEXxa88IGRIHbJ/PwKW/mR8LXdfI7l/9vCMXX4mk
...
-----END PUBLIC KEY-----

-- Example 16621
ALTER USER jsmith SET RSA_PUBLIC_KEY='MIIBIjANBgkqh...';

-- Example 16622
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

-- Example 16623
curl -X POST -H "Content-Type: application/json" --data @<path>/<config_file>.json http://localhost:8083/connectors

-- Example 16624
<kafka_dir>/bin/connect-standalone.sh <kafka_dir>/<path>/connect-standalone.properties <kafka_dir>/config/SF_connect.properties

-- Example 16625
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote=true
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
    -Djava.rmi.server.hostname=<ip_address>
    -Dcom.sun.management.jmxremote.port=<jmx_port>"

-- Example 16626
export JMX_PORT=<port_number>

-- Example 16627
{
 "name":"XYZCompanySensorData",
   "config":{
     ..
     "key.converter":"io.confluent.connect.protobuf.ProtobufConverter",
     "key.converter.schema.registry.url":"CONFLUENT_SCHEMA_REGISTRY",
     "value.converter":"io.confluent.connect.protobuf.ProtobufConverter",
     "value.converter.schema.registry.url":"http://localhost:8081"
   }
 }

-- Example 16628
{
  "name":"XYZCompanySensorData",
  "config":{
    "connector.class":"com.snowflake.kafka.connector.SnowflakeSinkConnector",
    "tasks.max":"8",
    "topics":"topic1,topic2",
    "snowflake.topic2table.map": "topic1:table1,topic2:table2",
    "buffer.count.records":"10000",
    "buffer.flush.time":"60",
    "buffer.size.bytes":"5000000",
    "snowflake.url.name":"myorganization-myaccount.snowflakecomputing.com:443",
    "snowflake.user.name":"jane.smith",
    "snowflake.private.key":"xyz123",
    "snowflake.private.key.passphrase":"jkladu098jfd089adsq4r",
    "snowflake.database.name":"mydb",
    "snowflake.schema.name":"myschema",
    "key.converter":"io.confluent.connect.protobuf.ProtobufConverter",
    "key.converter.schema.registry.url":"CONFLUENT_SCHEMA_REGISTRY",
    "value.converter":"io.confluent.connect.protobuf.ProtobufConverter",
    "value.converter.schema.registry.url":"http://localhost:8081"
  }
}

-- Example 16629
git clone https://github.com/blueapron/kafka-connect-protobuf-converter

-- Example 16630
cd kafka-connect-protobuf-converter

git checkout tags/v3.1.0

mvn clean package

-- Example 16631
protoc -I=$SRC_DIR --java_out=$DST_DIR $SRC_DIR/sensor.proto

-- Example 16632
protobuf_folder
├── pom.xml
└── src
    └── main
        └── java
            └── com
                └── ..

-- Example 16633
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>

   <groupId><group_id></groupId>
   <artifactId><artifact_id></artifactId>
   <version><version></version>

   <properties>
       <java.version><java_version></java.version>
       <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
   </properties>

   <dependencies>
       <dependency>
           <groupId>com.google.protobuf</groupId>
           <artifactId>protobuf-java</artifactId>
           <version>3.11.1</version>
       </dependency>
   </dependencies>

   <build>
       <plugins>
           <plugin>
               <groupId>org.apache.maven.plugins</groupId>
               <artifactId>maven-compiler-plugin</artifactId>
               <version>3.3</version>
               <configuration>
                   <source>${java.version}</source>
                   <target>${java.version}</target>
               </configuration>
           </plugin>
           <plugin>
               <artifactId>maven-assembly-plugin</artifactId>
               <version>3.1.0</version>
               <configuration>
                   <descriptorRefs>
                       <descriptorRef>jar-with-dependencies</descriptorRef>
                   </descriptorRefs>
               </configuration>
               <executions>
                   <execution>
                       <id>make-assembly</id>
                       <phase>package</phase>
                       <goals>
                           <goal>single</goal>
                       </goals>
                   </execution>
               </executions>
           </plugin>
       </plugins>
   </build>
</project>

-- Example 16634
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
   <modelVersion>4.0.0</modelVersion>

   <groupId>com.snowflake</groupId>
   <artifactId>kafka-test-protobuf</artifactId>
   <version>1.0.0</version>

   <properties>
       <java.version>1.8</java.version>
       <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
   </properties>

   <dependencies>
       <dependency>
           <groupId>com.google.protobuf</groupId>
           <artifactId>protobuf-java</artifactId>
           <version>3.11.1</version>
       </dependency>
   </dependencies>

   <build>
       <plugins>
           <plugin>
               <groupId>org.apache.maven.plugins</groupId>
               <artifactId>maven-compiler-plugin</artifactId>
               <version>3.3</version>
               <configuration>
                   <source>${java.version}</source>
                   <target>${java.version}</target>
               </configuration>
           </plugin>
           <plugin>
               <artifactId>maven-assembly-plugin</artifactId>
               <version>3.1.0</version>
               <configuration>
                   <descriptorRefs>
                       <descriptorRef>jar-with-dependencies</descriptorRef>
                   </descriptorRefs>
               </configuration>
               <executions>
                   <execution>
                       <id>make-assembly</id>
                       <phase>package</phase>
                       <goals>
                           <goal>single</goal>
                       </goals>
                   </execution>
               </executions>
           </plugin>
       </plugins>
   </build>
</project>

-- Example 16635
mvn clean package

-- Example 16636
{
 "name":"XYZCompanySensorData",
   "config":{
     ..
     "value.converter.protoClassName":"com.snowflake.kafka.test.protobuf.SensorReadingImpl$SensorReading"
   }
 }

-- Example 16637
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON EXTERNAL VOLUME kafka_external_volume TO ROLE kafka_connector_role;

-- Example 16638
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table (
    record_metadata OBJECT()
  )
  EXTERNAL_VOLUME = 'my_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my_location/my_iceberg_table';

-- Example 16639
{
    "id": 1,
    "name": "Steve",
    "body_temperature": 36.6,
    "approved_coffee_types": ["Espresso", "Doppio", "Ristretto", "Lungo"],
    "animals_possessed":
    {
        "dogs": true,
        "cats": false
    },
    "date_added": "2024-10-15"
}

-- Example 16640
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table (
    record_content OBJECT(
        id INT,
        body_temperature FLOAT,
        name STRING,
        approved_coffee_types ARRAY(STRING),
        animals_possessed OBJECT(dogs BOOLEAN, cats BOOLEAN),
        date_added DATE
    )
  )
  EXTERNAL_VOLUME = 'my_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my_location/my_iceberg_table';

-- Example 16641
LIST @mydb.public.%mytable;

-- Example 16642
LIST @mydb.public.%mytable;

-- Example 16643
GET @mydb.public.%mytable file:///data/;

-- Example 16644
GET @mydb.public.%mytable file://C:\data\;

-- Example 16645
CREATE STAGE kafka_json FILE_FORMAT = (TYPE = JSON);

-- Example 16646
PUT file:///data/ @mydb.public.kafka_json;

-- Example 16647
PUT file://C:\data\ @mydb.public.kafka_json;

-- Example 16648
CREATE TEMPORARY TABLE t1 (col1 variant);

-- Example 16649
COPY INTO mydb.public.t1
  FROM @mydb.public.kafka_json
  FILE_FORMAT = (TYPE = JSON)
  VALIDATION_MODE = 'RETURN_ALL_ERRORS';

-- Example 16650
PUT file:///tmp/myfile.csv @mydb.public.%mytable OVERWRITE = TRUE;

-- Example 16651
PUT file://C:\temp\myfile.csv @mydb.public.%mytable OVERWRITE = TRUE;

-- Example 16652
COPY INTO mydb.public.mytable(RECORD_METADATA, RECORD_CONTENT)
  FROM (SELECT $1:meta, $1:content FROM @mydb.public.%mytable)
  FILE_FORMAT = (TYPE = 'JSON')
  PURGE = TRUE;

-- Example 16653
org.apache.kafka.clients.consumer.CommitFailedException: Commit cannot be completed since the group has already rebalanced and assigned the partitions to another member.

This means that the time between subsequent calls to poll() was longer than the configured max.poll.interval.ms, which typically implies that the poll loop is spending too much time message processing. You can address this either by increasing max.poll.interval.ms or by reducing the maximum size of batches returned in poll() with max.poll.records.

at org.apache.kafka.clients.consumer.internals.ConsumerCoordinator.sendOffsetCommitRequest(ConsumerCoordinator.java:1061)

-- Example 16654
com.snowflake.kafka.connector.internal.SnowflakeKafkaConnectorException: [SF_KAFKA_CONNECTOR] Exception: Failure in Streaming Channel Offset Migration Response Error Code: 5023

Detail: Streaming Channel Offset Migration from Source to Destination Channel has no/invalid response, please contact Snowflake Support

Message: Snowflake experienced a transient exception, please retry the migration request.

-- Example 16655
show stages like 'snowflake_kafka_connector%<your table name>';

-- Example 16656
list @<your stage name> pattern = '.+/<your-table-name>/[0-9]{1,4}/[0-9]+_[0-9]+_[0-9]+\.json\.gz$';

-- Example 16657
-- Use a role that can create and manage roles and privileges.
USE ROLE securityadmin;

-- Create a Snowflake role with the privileges to work with the connector.
CREATE ROLE kafka_connector_role_1;

-- Grant privileges on the database.
GRANT USAGE ON DATABASE kafka_db TO ROLE kafka_connector_role_1;

-- Grant privileges on the schema.
GRANT USAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE TABLE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE STAGE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;
GRANT CREATE PIPE ON SCHEMA kafka_schema TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will load data into an existing table.
GRANT OWNERSHIP ON TABLE existing_table1 TO ROLE kafka_connector_role_1;

-- Only required if the Kafka connector will stage data files in an existing internal stage: (not recommended).
GRANT READ, WRITE ON STAGE existing_stage1 TO ROLE kafka_connector_role_1;

-- Grant the custom role to an existing user.
GRANT ROLE kafka_connector_role_1 TO USER kafka_connector_user_1;

-- Set the custom role as the default role for the user.
-- If you encounter an 'Insufficient privileges' error, verify the role that has the OWNERSHIP privilege on the user.
ALTER USER kafka_connector_user_1 SET DEFAULT_ROLE = kafka_connector_role_1;

-- Example 16658
tar xzvf kafka_<scala_version>-<kafka_version>.tgz

-- Example 16659
{
  "name":"XYZCompanySensorData",
  "config":{
    "connector.class":"com.snowflake.kafka.connector.SnowflakeSinkConnector",
    "tasks.max":"8",
    "topics":"topic1,topic2",
    "snowflake.topic2table.map": "topic1:table1,topic2:table2",
    "buffer.count.records":"10000",
    "buffer.flush.time":"60",
    "buffer.size.bytes":"5000000",
    "snowflake.url.name":"myorganization-myaccount.snowflakecomputing.com:443",
    "snowflake.user.name":"jane.smith",
    "snowflake.private.key":"xyz123",
    "snowflake.private.key.passphrase":"jkladu098jfd089adsq4r",
    "snowflake.database.name":"mydb",
    "snowflake.schema.name":"myschema",
    "key.converter":"org.apache.kafka.connect.storage.StringConverter",
    "value.converter":"com.snowflake.kafka.connector.records.SnowflakeAvroConverter",
    "value.converter.schema.registry.url":"http://localhost:8081",
    "value.converter.basic.auth.credentials.source":"USER_INFO",
    "value.converter.basic.auth.user.info":"jane.smith:MyStrongPassword"
  }
}

-- Example 16660
connector.class=com.snowflake.kafka.connector.SnowflakeSinkConnector
tasks.max=8
topics=topic1,topic2
snowflake.topic2table.map= topic1:table1,topic2:table2
buffer.count.records=10000
buffer.flush.time=60
buffer.size.bytes=5000000
snowflake.url.name=myorganization-myaccount.snowflakecomputing.com:443
snowflake.user.name=jane.smith
snowflake.private.key=xyz123
snowflake.private.key.passphrase=jkladu098jfd089adsq4r
snowflake.database.name=mydb
snowflake.schema.name=myschema
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=com.snowflake.kafka.connector.records.SnowflakeAvroConverter
value.converter.schema.registry.url=http://localhost:8081
value.converter.basic.auth.credentials.source=USER_INFO
value.converter.basic.auth.user.info=jane.smith:MyStrongPassword

-- Example 16661
topics="topic1,topic2,topic5,topic6"
snowflake.topic2table.map="topic1:low_range,topic2:low_range,topic5:high_range,topic6:high_range"

