-- Example 20346
BEGIN
  INSERT INTO table1 VALUES (1, "One");
  INSERT INTO table1 VALUES (2, "Two");
  ALTER ICEBERG TABLE table1 ALTER COLUMN c3 SET DATA TYPE ARRAY(long);
  INSERT INTO table1 VALUES (3, "Three");
  INSERT INTO table1 VALUES (4, "Four");
COMMIT;

-- Example 20347
SELECT query_id, object_name, transaction_id, blocker_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOCK_WAIT_HISTORY
  WHERE requested_at >= DATEADD('hours', -24, CURRENT_TIMESTAMP());

-- Example 20348
SELECT function_name,
       function_instance_name AS instance_name,
       argument_signature,
       data_type AS return_value_data_type
    FROM mydatabase.INFORMATION_SCHEMA.CLASS_INSTANCE_FUNCTIONS;

-- Example 20349
SELECT procedure_name,
       procedure_instance_name,
       argument_signature,
       data_type AS return_value_data_type
    FROM mydatabase.INFORMATION_SCHEMA.CLASS_INSTANCE_PROCEDURES;

-- Example 20350
SELECT name, class_name, class_schema_name, class_database_name
    FROM mydatabase.INFORMATION_SCHEMA.CLASS_INSTANCES;

-- Example 20351
SELECT name, schema_name, database_name, version
    FROM SNOWFLAKE.INFORMATION_SCHEMA.CLASSES;

-- Example 20352
SELECT TABLE_NAME
    FROM mydatabase.information_schema.event_tables;

-- Example 20353
SELECT table_name, last_altered FROM mydatabase.information_schema.external_tables;

-- Example 20354
WHERE last_load_time > 'Sun, 01 Apr 2016 16:00:00 -0800'

-- Example 20355
USE DATABASE mydb;

SELECT table_name, last_load_time
  FROM information_schema.load_history
  WHERE schema_name=current_schema() AND
  table_name='MYTABLE' AND
  last_load_time > 'Fri, 01 Apr 2016 16:00:00 -0800';

-- Example 20356
USE DATABASE mydb;

SELECT table_name, last_load_time
  FROM information_schema.load_history
  ORDER BY last_load_time DESC
  LIMIT 10;

-- Example 20357
SELECT model_version_name, model_name, functions, schema_name, database_name
    FROM mydatabase.INFORMATION_SCHEMA.MODEL_VERSIONS;

-- Example 20358
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;

-- Example 20359
+--------------------+-------------------+-----------------------------------------------------+---------------------------+--------------------------+-----------------------------------------------------+--------------+-------------+-------------+---------+-------------------------------+-------------------------------+
| CONSTRAINT_CATALOG | CONSTRAINT_SCHEMA | CONSTRAINT_NAME                                     | UNIQUE_CONSTRAINT_CATALOG | UNIQUE_CONSTRAINT_SCHEMA | UNIQUE_CONSTRAINT_NAME                              | MATCH_OPTION | UPDATE_RULE | DELETE_RULE | COMMENT | CREATED                       | LAST_ALTERED                  |
|--------------------+-------------------+-----------------------------------------------------+---------------------------+--------------------------+-----------------------------------------------------+--------------+-------------+-------------+---------+-------------------------------+-------------------------------|
| HTABLES_DB         | HTABLES_SCHEMA    | SYS_CONSTRAINT_51118aaf-1ee6-4548-bc9a-f87e65d92528 | HTABLES_DB                | HTABLES_SCHEMA           | SYS_CONSTRAINT_aad16788-491a-4e68-b0e3-30d48a33a1c1 | FULL         | NO ACTION   | NO ACTION   | NULL    | 2024-09-19 13:51:37.355 -0700 | 2024-09-19 13:51:37.608 -0700 |
| HTABLES_DB         | HTABLES_SCHEMA    | SYS_CONSTRAINT_c97bfe9b-6098-4b8a-b796-e341071db72a | HTABLES_DB                | HTABLES_SCHEMA           | SYS_CONSTRAINT_0bd41d0f-11f7-4366-82a3-f03f31fcce7e | FULL         | NO ACTION   | NO ACTION   | NULL    | 2024-05-28 18:21:43.899 -0700 | 2024-05-28 18:21:44.268 -0700 |
+--------------------+-------------------+-----------------------------------------------------+---------------------------+--------------------------+-----------------------------------------------------+--------------+-------------+-------------+---------+-------------------------------+-------------------------------+

-- Example 20360
SELECT tc.constraint_catalog, tc.constraint_schema, tc.constraint_name, tc.table_name, tc.constraint_type, tc.enforced
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
    JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc ON tc.constraint_name=rc.constraint_name;

-- Example 20361
+--------------------+-------------------+-----------------------------------------------------+------------+-----------------+----------+
| CONSTRAINT_CATALOG | CONSTRAINT_SCHEMA | CONSTRAINT_NAME                                     | TABLE_NAME | CONSTRAINT_TYPE | ENFORCED |
|--------------------+-------------------+-----------------------------------------------------+------------+-----------------+----------|
| HTABLES_DB         | HTABLES_SCHEMA    | SYS_CONSTRAINT_51118aaf-1ee6-4548-bc9a-f87e65d92528 | HTFK       | FOREIGN KEY     | YES      |
| HTABLES_DB         | HTABLES_SCHEMA    | SYS_CONSTRAINT_c97bfe9b-6098-4b8a-b796-e341071db72a | HT619      | FOREIGN KEY     | YES      |
+--------------------+-------------------+-----------------------------------------------------+------------+-----------------+----------+

-- Example 20362
SELECT *
FROM my_database.information_schema.services
WHERE service_name LIKE '%myservice_%';

-- Example 20363
SELECT table_schema, SUM(bytes)
  FROM mydatabase.INFORMATION_SCHEMA.TABLES
  GROUP BY TABLE_SCHEMA;

-- Example 20364
#
# Listing prefix
#
title: <listing title>
subtitle: <Optional listing subtitle>
description: <listing description>
profile : <Optional name of the provider profile>

listing_terms:
  - # Required listing terms that the consumer must sign.
auto_fulfillment:
  - # Required when the target accounts are outside the provider's region, otherwise optional.
data_dictionary:
  - # Required for public listings, and optional for all other listing types.
data_preview:
  - # Required for public listings, and optional for all other listing types.
business_needs:
  - # Optional <List>BusinessNeed elements, maximum 6.
usage_examples:
  - # Optional <List>UsageExample elements, maximum 10.
targets:
  - # Required <List> Consumer accounts to target with this private listing.

-- Example 20365
title: Weather information
subtitle: Historical weather by postcode.
description: This listing includes historical weather data by post code.
profile: My provider profile

-- Example 20366
. . .
listing_terms:
  type: "CUSTOM"
  link: "http://example.com/my/listing/terms"
. . .

-- Example 20367
SHOW REGIONS IN DATA EXCHANGE SNOWFLAKE_DATA_MARKETPLACE;

-- Example 20368
. . .
targets:
   accounts: ["Org1.Account1", "Org2.Account2"]
. . .

-- Example 20369
. . .
targets:
   regions: ["PUBLIC.AWS_US_EAST_1", "PUBLIC.AZURE_WESTUS2"]
. . .

-- Example 20370
. . .
listing_terms: . . .
. . .
auto_fulfillment:
  refresh_schedule: 10 MINUTE
  refresh_type: SUB_DATABASE
. . .

-- Example 20371
. . .
listing_terms: . . .
. . .
auto_fulfillment:
  refresh_schedule: USING CRON  0 17 * * MON-FRI Europe/London
  refresh_type: SUB_DATABASE
. . .

-- Example 20372
. . .
listing_terms: . . .
. . .
auto_fulfillment:
  refresh_schedule: 10 MINUTE
  refresh_type: SUB_DATABASE
  refresh_schedule_override: TRUE
. . .

-- Example 20373
. . .
listing_terms: . . .
. . .
auto_fulfillment:
  refresh_type: SUB_DATABASE_WITH_REFERENCE_USAGE
. . .

-- Example 20374
. . .
listing_terms: . . .
. . .
auto_fulfillment:
  refresh_type: SUB_DATABASE
. . .

-- Example 20375
. . .
business_needs:
 - name: "Real World Data (RWD)"
   description: "Global weather data"
. . .

-- Example 20376
. . .
business_needs:
 - name: "Real World Data (RWD)"
   description: "Global weather data"
   type: STANDARD
. . .

-- Example 20377
. . .
business_needs:
 - name: "Machinery Maintenance"
   description: "Repair and maintenance data for machinery"
   type: CUSTOM
. . .

-- Example 20378
. . .
categories:
 - ECONOMY
. . .

-- Example 20379
. . .
data_attributes:
  refresh_rate: DAILY
  geography:
    granularity:
      - REGION_CONTINENT
    geo_option: COUNTRIES
    coverage:
      continents:
        ASIA:
          - INDIA
          - CHINA
        NORTH AMERICA:
          - UNITED STATES
          - CANADA
        EUROPE:
          - UNITED KINGDOM
    time:
      granularity: MONTHLY
      time_range:
        time_frame: LAST
        unit: MONTHS
        value: 6

-- Example 20380
. . .
data_dictionary:
 featured:
    database: "WEATHERDATA"
    objects:
       - name: "GLOBAL_WEATHER"
         schema: "PUBLIC"
         domain: "TABLE"
       - name: "GLOBAL_WEATHER_REPORT"
         schema: "PUBLIC"
         domain: "TABLE"
. . .

-- Example 20381
. . .
data_preview:
 has_pii: TRUE
 metadata_overrides:
    database: WEATHERDATA
    objects:
       - schema: PUBLIC
         domain: TABLE
         name: GLOBAL_WEATHER
         pii_columns: [ADDRESS, PHONE]
         overridden_pii_columns: [FIRST_NAME, LAST_NAME]
. . .

-- Example 20382
. . .
usage_examples:
  - title: "Return all weather for the US"
    description: "Example of how to select weather information for the United States"
    query: "select * from weather where country_code='USA'";
. . .

-- Example 20383
. . .
resources:
  documentation: https://www.example.com/documentation/
  media: https://www.youtube.com/watch?v=MEFlT3dc3uc
. . .

-- Example 20384
title: "Covid data listing"
subtitle: "Listing about covid"
description: "Example covid manifest"
profile: "MyProfile"
listing_terms:
  type: "STANDARD"
targets:
  accounts: ["Org1.Account1", "Org2.Account2"]
auto_fulfillment:
  refresh_schedule: "120 MINUTE"
  refresh_type: "SUB_DATABASE"
business_needs:
  - name: "Life Sciences Commercialization"
    description: "COVID-19 Epidemiological Data"
usage_examples:
  - title: "Get total case count by country"
    description: "Calculates the total number of cases by country, aggregated over time."
    query: "SELECT  COUNTRY_REGION, SUM(CASES) AS Cases FROM ECDC_GLOBAL GROUP BY COUNTRY_REGION;"
data_attributes:
  refresh_rate: HOURLY
  geography:
    granularity:
      - ADDRESS
    geo_option: COUNTRIES
    coverage:
      continents:
        ASIA:
          - INDIA
          - CHINA
        NORTH AMERICA:
          - UNITED STATES
          - CANADA
        EUROPE:
          - UNITED KINGDOM
    time:
      granularity: MONTHLY
      time_range:
      time_frame: BETWEEN
      start_date: 12-24-2020
      end_date: 12-25-2021
data_preview:
  has_pii: TRUE
  metadata_overrides:
    database: WEATHERDATA
    objects:
      schema: PUBLIC
      domain: TABLE
      name: GLOBAL_WEATHER
      pii_columns: [ADDRESS, PHONE]
      overridden_pii_columns: [FIRST_NAME, LAST_NAME]
resources:
  documentation: https://www.example.com/documentation/
  media: https://www.youtube.com/watch?v=MEFlT3dc3uc
categories:
 - HEALTH

-- Example 20385
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 2A3149C82551A34A

-- Example 20386
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 5A125630709DD64B

-- Example 20387
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 630D9F3CAB551AF3

-- Example 20388
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 37C7086698CB005C

-- Example 20389
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys EC218558EABB25A1

-- Example 20390
$ gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 93DB296A69BE019A

-- Example 20391
gpg: keyserver receive failed: Server indicated a failure

-- Example 20392
gpg --keyserver hkp://keyserver.ubuntu.com:80  ...

-- Example 20393
$ gpg --verify snowflake-jdbc-3.23.2.jar.asc snowflake-jdbc-3.23.2.jar
gpg: Signature made Wed 22 Feb 2017 04:31:58 PM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>"

-- Example 20394
gpg: Signature made Mon 24 Sep 2018 03:03:45 AM UTC using RSA key ID <gpg_key_id>
gpg: Good signature from "Snowflake Computing <snowflake_gpg@snowflake.net>" unknown
gpg: WARNING: This key is not certified with a trusted signature!
gpg: There is no indication that the signature belongs to the owner.

-- Example 20395
$ gpg --delete-key "Snowflake Computing"

-- Example 20396
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 20397
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc-fips</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 20398
<dependencies>
  ...
  <dependency>
    <groupId>net.snowflake</groupId>
    <artifactId>snowflake-jdbc-thin</artifactId>
    <version>3.23.2</version>
  </dependency>
  ...
</dependencies>

-- Example 20399
Statement statement1;
...
// Unwrap the statement1 object to expose the SnowflakeStatement object, and call the
// SnowflakeStatement object's setParameter() method.
statement1.unwrap(SnowflakeStatement.class).setParameter(...);

-- Example 20400
QueryStatus queryStatus = QueryStatus.RUNNING;
while (queryStatus != QueryStatus.SUCCESS)  {     //  NOT RECOMMENDED
    Thread.sleep(2000);   // 2000 milliseconds.
    queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

-- Example 20401
// Assume that the query is not done yet.
QueryStatus queryStatus = QueryStatus.RUNNING;
while (queryStatus == QueryStatus.RUNNING || queryStatus == QueryStatus.RESUMING_WAREHOUSE)  {
    Thread.sleep(2000);   // 2000 milliseconds.
    queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

if (queryStatus == QueryStatus.SUCCESS) {
    ...
    }

-- Example 20402
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import net.snowflake.client.core.QueryStatus;
import net.snowflake.client.jdbc.SnowflakeConnection;
import net.snowflake.client.jdbc.SnowflakeResultSet;
import net.snowflake.client.jdbc.SnowflakeStatement;

-- Example 20403
String sql_command = "";
    ResultSet resultSet;

    System.out.println("Create JDBC statement.");
    Statement statement = connection.createStatement();
    sql_command = "SELECT PI()";
    System.out.println("Simple SELECT query: " + sql_command);
    resultSet = statement.unwrap(SnowflakeStatement.class).executeAsyncQuery(sql_command);

    // Assume that the query isn't done yet.
    QueryStatus queryStatus = QueryStatus.RUNNING;
    while (queryStatus == QueryStatus.RUNNING || queryStatus == QueryStatus.RESUMING_WAREHOUSE) {
      Thread.sleep(2000); // 2000 milliseconds.
      queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

    if (queryStatus == QueryStatus.FAILED_WITH_ERROR) {
      // Print the error code to stdout
      System.out.format("Error code: %d%n", queryStatus.getErrorCode());
      System.out.format("Error message: %s%n", queryStatus.getErrorMessage());
    } else if (queryStatus != QueryStatus.SUCCESS) {
      System.out.println("ERROR: unexpected QueryStatus: " + queryStatus);
    } else {
      boolean result_exists = resultSet.next();
      if (!result_exists) {
        System.out.println("ERROR: No rows returned.");
      } else {
        float pi_result = resultSet.getFloat(1);
        System.out.println("pi = " + pi_result);
      }
    }

-- Example 20404
String sql_command = "";
    ResultSet resultSet;
    String queryID = "";

    System.out.println("Create JDBC statement.");
    Statement statement = connection.createStatement();
    sql_command = "SELECT PI() * 2";
    System.out.println("Simple SELECT query: " + sql_command);
    resultSet = statement.unwrap(SnowflakeStatement.class).executeAsyncQuery(sql_command);
    queryID = resultSet.unwrap(SnowflakeResultSet.class).getQueryID();
    System.out.println("INFO: Closing statement.");
    statement.close();
    System.out.println("INFO: Closing connection.");
    connection.close();

    System.out.println("INFO: Re-opening connection.");
    connection = create_connection(args);
    use_warehouse_db_and_schema(connection);
    resultSet = connection.unwrap(SnowflakeConnection.class).createResultSet(queryID);

    // Assume that the query isn't done yet.
    QueryStatus queryStatus = QueryStatus.RUNNING;
    while (queryStatus == QueryStatus.RUNNING) {
      Thread.sleep(2000); // 2000 milliseconds.
      queryStatus = resultSet.unwrap(SnowflakeResultSet.class).getStatus();
    }

    if (queryStatus == QueryStatus.FAILED_WITH_ERROR) {
      System.out.format(
          "ERROR %d: %s%n", queryStatus.getErrorMessage(), queryStatus.getErrorCode());
    } else if (queryStatus != QueryStatus.SUCCESS) {
      System.out.println("ERROR: unexpected QueryStatus: " + queryStatus);
    } else {
      boolean result_exists = resultSet.next();
      if (!result_exists) {
        System.out.println("ERROR: No rows returned.");
      } else {
        float pi_result = resultSet.getFloat(1);
        System.out.println("pi = " + pi_result);
      }
    }

-- Example 20405
/**
 * Method to compress data from a stream and upload it at a stage location.
 * The data will be uploaded as one file. No splitting is done in this method.
 *
 * Caller is responsible for releasing the inputStream after the method is
 * called.
 *
 * @param stageName    stage name: e.g. ~ or table name or stage name
 * @param destPrefix   path / prefix under which the data should be uploaded on the stage
 * @param inputStream  input stream from which the data will be uploaded
 * @param destFileName destination file name to use
 * @param compressData compress data or not before uploading stream
 * @throws java.sql.SQLException failed to compress and put data from a stream at stage
 */
public void uploadStream(String stageName,
                         String destPrefix,
                         InputStream inputStream,
                         String destFileName,
                         boolean compressData)
    throws SQLException

-- Example 20406
Connection connection = DriverManager.getConnection(url, prop);
File file = new File("/tmp/test.csv");
FileInputStream fileInputStream = new FileInputStream(file);

// upload file stream to user stage
connection.unwrap(SnowflakeConnection.class).uploadStream("MYSTAGE", "testUploadStream",
   fileInputStream, "destFile.csv", true);

-- Example 20407
...

// For versions prior to 3.9.2:
// upload file stream to user stage
((SnowflakeConnectionV1) connection.uploadStream("MYSTAGE", "testUploadStream",
   fileInputStream, "destFile.csv", true));

-- Example 20408
/**
 * Download file from the given stage and return an input stream
 *
 * @param stageName      stage name
 * @param sourceFileName file path in stage
 * @param decompress     true if file compressed
 * @return an input stream
 * @throws SnowflakeSQLException if any SQL error occurs.
 */
InputStream downloadStream(String stageName,
                           String sourceFileName,
                           boolean decompress) throws SQLException;

-- Example 20409
Connection connection = DriverManager.getConnection(url, prop);
InputStream out = connection.unwrap(SnowflakeConnection.class).downloadStream(
    "~",
    DEST_PREFIX + "/" + TEST_DATA_FILE + ".gz",
    true);

-- Example 20410
...

// For versions prior to 3.9.2:
// download file stream to user stage
((SnowflakeConnectionV1) connection.downloadStream(...));

-- Example 20411
alter session set MULTI_STATEMENT_COUNT = 0;

-- Example 20412
alter account set MULTI_STATEMENT_COUNT = 0;

