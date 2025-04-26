-- Example 1293
GRANT FAILOVER ON CONNECTION myconnection TO ROLE my_failover_role;

-- Example 1294
USE ROLE my_failover_role;

ALTER CONNECTION myconnection PRIMARY;

-- Example 1295
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
|--------------------|-------------------------------|---------------------|-------------------|-----------------|---------------|-------------------------------|-------------------------------------|-------------------------------------------|-------------------|-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 1296
myaccount1.us-west-2.privatelink.snowflakecomputing.com.
ocsp.myaccount1.us-west-2.privatelink.snowflakecomputing.com.

-- Example 1297
myorg-myaccount1.privatelink.snowflakecomputing.com.
ocsp.myorg-myaccount1.privatelink.snowflakecomputing.com.

-- Example 1298
<organization-name>-<connection-name>

-- Example 1299
myorg-myconnection

-- Example 1300
https://<organization_name>-<connection_name>.snowflakecomputing.com/

-- Example 1301
https://myorg-myconnection.snowflakecomputing.com/

-- Example 1302
accountname = <organization_name>-<connection_name>
username = <username>
password = <password>

-- Example 1303
accountname = myorg-myconnection
username = jsmith
password = mySecurePassword

-- Example 1304
con = snowflake.connector.connect (
      account = <organization_name>-<connection_name>
      user = <username>
      password = <password>
)

-- Example 1305
con = snowflake.connector.connect (
      account = myorg-myconnection
      user = jsmith
      password = mySecurePassword
)

-- Example 1306
jdbc:snowflake://<organization_name>-<connection_name>.snowflakecomputing.com/?user=<username>&password=<password>

-- Example 1307
jdbc:snowflake://myorg-myconnection.snowflakecomputing.com/?user=jsmith&password=mySecurePassword

-- Example 1308
[ODBC Data Sources]
<account_name> = SnowflakeDSIIDriver

[<dsn_name>]
Description     = SnowflakeDB
Driver          = SnowflakeDSIIDriver
Locale          = en-US
SERVER          = <organization_name>-<connection_name>.snowflakecomputing.com

-- Example 1309
[ODBC Data Sources]
myaccount = SnowflakeDSIIDriver

[client_redirect]
Description     = SnowflakeDB
Driver          = SnowflakeDSIIDriver
Locale          = en-US
SERVER          = myorg-myconnection.snowflakecomputing.com

-- Example 1310
var configuration = {
  username: '<username>',
  password: '<password>',
  account: <organization_name>-<connection_name>.
}

var connection = snowflake.createConnection(configuration)

-- Example 1311
var configuration = {
  username: 'jsmith',
  password: 'mySecurePassword',
  account: myorg-myconnection.
}

var connection = snowflake.createConnection(configuration)

-- Example 1312
cfg := &Config{
  Account: "<organization_name>-<connection_name>",
  User: "<username>",
  Password: "<password>"
}

dsn, err := DSN(cfg)

-- Example 1313
cfg := &Config{
  Account: "myorg-myconnection",
  User: "jsmith",
  Password: "mySecurePassword"
}

dsn, err := DSN(cfg)

-- Example 1314
connection_parameters = {
  "account": "<organization_name>-<connection_name>",
  "user": "<snowflake_user>",
  "password": "<snowflake_password>"
}

-- Example 1315
connection_parameters = {
  "account": "myorg-myconnection",
  "user": "jsmith",
  "password": "mySecurePassword"
}

-- Example 1316
# Properties file (a text file) for establishing a Snowpark session
URL = https://<organization_name>-<connection_name>.snowflakecomputing.com

-- Example 1317
# Properties file (a text file) for establishing a Snowpark session
URL = https://myorg-myconnection.snowflakecomputing.com

-- Example 1318
# Properties file (a text file) for establishing a Snowpark session
URL = https://<organization_name>-<connection_name>.snowflakecomputing.com

-- Example 1319
# Properties file (a text file) for establishing a Snowpark session
URL = https://myorg-myconnection.snowflakecomputing.com

-- Example 1320
SHOW CONNECTIONS;

-- Example 1321
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 1322
ALTER CONNECTION myconnection PRIMARY;

-- Example 1323
SHOW CONNECTIONS;

-- Example 1324
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 1325
myaccount1.us-east-1.privatelink.snowflakecomputing.com.
ocsp.myaccount1.us-east-1.privatelink.snowflakecomputing.com.

-- Example 1326
SELECT CURRENT_REGION();

-- Example 1327
SHOW CONNECTIONS;

-- Example 1328
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2023-07-05 08:57:11.143 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2023-07-08 09:15:11.143 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|

-- Example 1329
SELECT event_timestamp, user_name, client_ip, reported_client_type, is_success, connection
  FROM TABLE(INFORMATION_SCHEMA.LOGIN_HISTORY(
    DATEADD('HOURS',-72,CURRENT_TIMESTAMP()),
    CURRENT_TIMESTAMP()))
  ORDER BY EVENT_TIMESTAMP;

-- Example 1330
CREATE SCHEMA S1;
USE SCHEMA S1;
CREATE TASK T1 AS SELECT 1;
CREATE SCHEMA S2 CLONE S1 AT(TIMESTAMP => '2025-04-01 12:00:00');
  -- T1 is not cloned into S2
CREATE SCHEMA S3 CLONE S1;
  -- T1 is cloned into S3

-- Example 1331
SHOW TABLES;
-- ... output omitted ...
SELECT "name", "retention_time" FROM TABLE(RESULT_SCAN(-1))
  WHERE "name" IN ('my_table1', 'my_table2');

-- Example 1332
SHOW SCHEMAS;
-- ... output omitted ...
SELECT "name", "retention_time" FROM TABLE(RESULT_SCAN(-1))
  WHERE "retention_time" = 0;

-- Example 1333
SHOW DATABASES HISTORY;
-- ... output omitted ...
SELECT "name", "retention_time", "dropped_on" FROM TABLE(RESULT_SCAN(-1))
  WHERE "retention_time" > 1;

-- Example 1334
CREATE TABLE mytable(col1 NUMBER, col2 DATE) DATA_RETENTION_TIME_IN_DAYS=90;

ALTER TABLE mytable SET DATA_RETENTION_TIME_IN_DAYS=30;

-- Example 1335
SELECT * FROM my_table AT(TIMESTAMP => 'Wed, 26 Jun 2024 09:20:00 -0700'::timestamp_tz);

-- Example 1336
SELECT * FROM my_table AT(OFFSET => -60*5);

-- Example 1337
SELECT * FROM my_table BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 1338
CREATE TABLE restored_table CLONE my_table
  AT(TIMESTAMP => 'Wed, 26 Jun 2024 01:01:00 +0300'::timestamp_tz);

-- Example 1339
CREATE SCHEMA restored_schema CLONE my_schema AT(OFFSET => -3600);

-- Example 1340
CREATE DATABASE restored_db CLONE my_db
  BEFORE(STATEMENT => '8e5d0ca9-005e-44e6-b858-a8f5b37c5726');

-- Example 1341
CREATE DATABASE restored_db CLONE my_db
  AT(TIMESTAMP => DATEADD(days, -4, current_timestamp)::timestamp_tz)
  IGNORE TABLES WITH INSUFFICIENT DATA RETENTION;

-- Example 1342
SHOW TABLES HISTORY LIKE 'load%' IN mytestdb.myschema;

SHOW SCHEMAS HISTORY IN mytestdb;

SHOW DATABASES HISTORY;

-- Example 1343
UNDROP TABLE mytable;

UNDROP SCHEMA myschema;

UNDROP DATABASE mydatabase;

UNDROP NOTEBOOK mynotebook;

-- Example 1344
SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

DROP TABLE loaddata1;

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

CREATE TABLE loaddata1 (c1 number);
INSERT INTO loaddata1 VALUES (1111), (2222), (3333), (4444);

DROP TABLE loaddata1;

CREATE TABLE loaddata1 (c1 varchar);

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | Fri, 13 May 2016 19:05:51 -0700 |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

ALTER TABLE loaddata1 RENAME TO loaddata3;

UNDROP TABLE loaddata1;

SHOW TABLES HISTORY;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA3 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | Fri, 13 May 2016 19:04:46 -0700 |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

ALTER TABLE loaddata1 RENAME TO loaddata2;

UNDROP TABLE loaddata1;

+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+
| created_on                      | name      | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | dropped_on                      |
|---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------|
| Tue, 17 Mar 2016 17:41:55 -0700 | LOADDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 48   | 16248 | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:05:32 -0700 | LOADDATA2 | MYTESTDB      | PUBLIC      | TABLE |         |            | 4    | 4096  | PUBLIC | 1              | [NULL]                          |
| Fri, 13 May 2016 19:06:01 -0700 | LOADDATA3 | MYTESTDB      | PUBLIC      | TABLE |         |            | 0    | 0     | PUBLIC | 1              | [NULL]                          |
| Tue, 17 Mar 2016 17:51:30 -0700 | PRODDATA1 | MYTESTDB      | PUBLIC      | TABLE |         |            | 12   | 4096  | PUBLIC | 1              | [NULL]                          |
+---------------------------------+-----------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+---------------------------------+

-- Example 1345
CREATE OR ALTER TASK {{ environment }}.my_schema.my_task
  WAREHOUSE = my_warehouse
  SCHEDULE = '60 minute'
  AS select pi();

-- Example 1346
import os
from snowflake.core import Root, CreateMode
from datetime import timedelta
from snowflake.core.task import Task

my_task = Task(
    name="my_task",
    warehouse="my_warehouse",
    definition="select pi()",
    schedule=timedelta(minutes=60)
)
root = Root(Session.builder.getOrCreate())
tasks = root.databases[os.environ["environment"]].schemas["my_schema"].tasks
tasks.create(my_task, mode=CreateMode.or_replace)

-- Example 1347
snow git execute @my_git_repo/branches/main/path/to/my_scripts" \
    -D "environment='preprod'"

-- Example 1348
CREATE OR ALTER TABLE vacation_spots (
  city VARCHAR,
  airport VARCHAR,
  avg_temperature_air_f FLOAT,
  avg_relative_humidity_pct FLOAT,
  avg_cloud_cover_pct FLOAT,
  precipitation_probability_pct FLOAT
) data_retention_time_in_days = 1;

-- Example 1349
from snowflake.core import Root
from snowflake.core.table import PrimaryKey, Table, TableColumn

my_table = root.databases["my_db"].schemas["my_schema"].tables["vacation_spots"].fetch()
my_table.columns.append(TableColumn(name="city", datatype="varchar", nullable=False]))
my_table.columns.append(TableColumn(name="airport", datatype="varchar", nullable=False]))
my_table.columns.append(TableColumn(name="avg_temperature_air_f", datatype="float", nullable=False]))
my_table.columns.append(TableColumn(name="avg_relative_humidity_pct", datatype="float", nullable=False]))
my_table.columns.append(TableColumn(name="avg_cloud_cover_pct", datatype="float", nullable=False]))
my_table.columns.append(TableColumn(name="precipitation_probability_pct", datatype="float", nullable=False]))

my_table_res = root.databases["my_db"].schemas["my_schema"].tables["vacation_spots"]
my_table_res.create_or_alter(my_table)

-- Example 1350
name: Deploy scripts to preprod

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    env:
      SNOWFLAKE_CONNECTIONS_DEFAULT_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
      SNOWFLAKE_CONNECTIONS_DEFAULT_USER: ${{ secrets.SNOWFLAKE_USER }}
      SNOWFLAKE_CONNECTIONS_DEFAULT_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Install snowflake-cli
        uses: Snowflake-Labs/snowflake-cli-action@v1.5
        with:
          cli-version: "latest"
          default-config-file-path: ".snowflake/config.toml"

      - name: Fetch repository changes
        run: snow git fetch my_git_repo

      - name: Deploy scripts to preprod environment
        run: snow git execute @my_git_repo/branches/main/scripts/* \
            -D "environment='preprod'"

-- Example 1351
count = session.table(...).select().filter().join().count()

if count > 0:
  session.table(...).select().filter().join().write.save_as_table(...) # same query as the count, this will execute again
else:
  session.table(...).select().filter('other criteria').join() # nearly same query as the count

-- Example 1352
cached_df = session.table(...).select().filter().join().cache_result()
count = df.count()

if count > 0:
  cached_df.write.save_as_table() # reuses the cached DF
else:
  cached_df

-- Example 1353
>>> # Import the col function from the functions module.
>>> from snowflake.snowpark.functions import col

>>> # Create a DataFrame that contains the id, name, and serial_number
>>> # columns in the "sample_product_data" table.
>>> df = session.table("sample_product_data").select(col("id"), col("name"), col("serial_number"))
>>> df.show()

-- Example 1354
>>> # Create a DataFrame with the "id" and "name" columns from the "sample_product_data" table.
>>> # This does not execute the query.
>>> df = session.table("sample_product_data").select(col("id"), col("name"))

>>> # Send the query to the server for execution and
>>> # return a list of Rows containing the results.
>>> results = df.collect()

-- Example 1355
>>> from snowflake.snowpark.types import IntegerType
>>> add_one = udf(lambda x: x+1, return_type=IntegerType(), input_types=[IntegerType()], name="my_udf", replace=True)

-- Example 1356
REVOKE DATABASE ROLE SNOWFLAKE.CORTEX_USER
  FROM ROLE PUBLIC;

REVOKE IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE
  FROM ROLE PUBLIC;

-- Example 1357
USE ROLE ACCOUNTADMIN;

CREATE ROLE cortex_user_role;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE cortex_user_role;

GRANT ROLE cortex_user_role TO USER some_user;

-- Example 1358
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE analyst;

-- Example 1359
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'All';

-- Example 1360
ALTER ACCOUNT SET CORTEX_MODELS_ALLOWLIST = 'mistral-large2,llama3.1-70b';

