-- Example 12844
[ODBC Data Sources]
myaccount = SnowflakeDSIIDriver

[client_redirect]
Description     = SnowflakeDB
Driver          = SnowflakeDSIIDriver
Locale          = en-US
SERVER          = myorg-myconnection.snowflakecomputing.com

-- Example 12845
var configuration = {
  username: '<username>',
  password: '<password>',
  account: <organization_name>-<connection_name>.
}

var connection = snowflake.createConnection(configuration)

-- Example 12846
var configuration = {
  username: 'jsmith',
  password: 'mySecurePassword',
  account: myorg-myconnection.
}

var connection = snowflake.createConnection(configuration)

-- Example 12847
cfg := &Config{
  Account: "<organization_name>-<connection_name>",
  User: "<username>",
  Password: "<password>"
}

dsn, err := DSN(cfg)

-- Example 12848
cfg := &Config{
  Account: "myorg-myconnection",
  User: "jsmith",
  Password: "mySecurePassword"
}

dsn, err := DSN(cfg)

-- Example 12849
connection_parameters = {
  "account": "<organization_name>-<connection_name>",
  "user": "<snowflake_user>",
  "password": "<snowflake_password>"
}

-- Example 12850
connection_parameters = {
  "account": "myorg-myconnection",
  "user": "jsmith",
  "password": "mySecurePassword"
}

-- Example 12851
# Properties file (a text file) for establishing a Snowpark session
URL = https://<organization_name>-<connection_name>.snowflakecomputing.com

-- Example 12852
# Properties file (a text file) for establishing a Snowpark session
URL = https://myorg-myconnection.snowflakecomputing.com

-- Example 12853
# Properties file (a text file) for establishing a Snowpark session
URL = https://<organization_name>-<connection_name>.snowflakecomputing.com

-- Example 12854
# Properties file (a text file) for establishing a Snowpark session
URL = https://myorg-myconnection.snowflakecomputing.com

-- Example 12855
SHOW CONNECTIONS;

-- Example 12856
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12857
ALTER CONNECTION myconnection PRIMARY;

-- Example 12858
SHOW CONNECTIONS;

-- Example 12859
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12860
myaccount1.us-east-1.privatelink.snowflakecomputing.com.
ocsp.myaccount1.us-east-1.privatelink.snowflakecomputing.com.

-- Example 12861
SELECT CURRENT_REGION();

-- Example 12862
SHOW CONNECTIONS;

-- Example 12863
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2023-07-05 08:57:11.143 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2023-07-08 09:15:11.143 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|

-- Example 12864
SELECT event_timestamp, user_name, client_ip, reported_client_type, is_success, connection
  FROM TABLE(INFORMATION_SCHEMA.LOGIN_HISTORY(
    DATEADD('HOURS',-72,CURRENT_TIMESTAMP()),
    CURRENT_TIMESTAMP()))
  ORDER BY EVENT_TIMESTAMP;

-- Example 12865
ALTER ACCOUNT original_acctname RENAME TO new_acctname;

-- Example 12866
default_connection_name = "myconnection"

[connections]
[connections.myconnection]
account = "myorganization-myaccount"
user = "jdoe"
...

[connections.testingconnection]
account = "myorganization-myaccount"
user = "jdoe"
...

[cli.logs]
save_logs = true
level = "info"
path = "/home/<username>/.snowflake/logs"

-- Example 12867
chown $USER config.toml
chmod 0600 config.toml

-- Example 12868
snow --config-file="my_config.toml" connection test

-- Example 12869
SNOWFLAKE_<config-section>_<variable>=<value>

-- Example 12870
export SNOWFLAKE_CLI_LOGS_PATH="/Users/jondoe/snowcli_logs"

-- Example 12871
export SNOWFLAKE_CONNECTIONS_MYCONNECTION_PASSWORD="*******"

-- Example 12872
export SNOWFLAKE_DEFAULT_CONNECTION_NAME="myconnection"

-- Example 12873
CREATE AUTHENTICATION POLICY snowflake_cli_only
  CLIENT_TYPES = ('SNOWFLAKE_CLI');

-- Example 12874
ALTER USER user1
  SET AUTHENTICATION POLICY snowflake_cli_only;

-- Example 12875
[cli.features]
enable_separate_authentication_policy_id = true

-- Example 12876
export HTTP_PROXY='http://username:password@proxyserver.example.com:80'
export HTTPS_PROXY='http://username:password@proxyserver.example.com:80'

-- Example 12877
set HTTP_PROXY=http://username:password@proxyserver.example.com:80
set HTTPS_PROXY=http://username:password@proxyserver.example.com:80

-- Example 12878
localhost,.example.com,.snowflakecomputing.com,192.168.1.15,192.168.1.16

-- Example 12879
[cli.logs]
save_logs = true
level = "info"
path = "/home/<username>/.snowflake/logs"

-- Example 12880
ls logs/

-- Example 12881
snowflake-cli.log            snowflake-cli.log.2024-10-22

-- Example 12882
SHOW REPLICATION ACCOUNTS [ LIKE '<pattern>' ]

-- Example 12883
SHOW REPLICATION ACCOUNTS LIKE 'myaccount%';

-- Example 12884
SHOW SHARES;

-- Example 12885
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |                  |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 12886
DESC SHARE xy12345.sales_s;

+----------+------------------------------------+---------------------------------+
| kind     | name                               | shared_on                       |
|----------+------------------------------------+---------------------------------|
| DATABASE | <DB>                               | Thu, 15 Jun 2017 17:03:16 -0700 |
| SCHEMA   | <DB>.AGGREGATES_EULA               | Thu, 15 Jun 2017 17:03:16 -0700 |
| TABLE    | <DB>.AGGREGATES_EULA.AGGREGATE_1   | Thu, 15 Jun 2017 17:03:16 -0700 |
| VIEW     | <DB>.AGGREGATES_EULA.AGGREGATE_1_v | Thu, 15 Jun 2017 17:03:16 -0700 |
+----------+------------------------------------+---------------------------------+

-- Example 12887
CREATE DATABASE <name> FROM SHARE <provider_account>.<share_name>

-- Example 12888
CREATE DATABASE snow_sales FROM SHARE xy12345.sales_s;

-- Example 12889
SHOW DATABASES LIKE 'snow%';

+---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+
| created_on                      | name                  | is_default | is_current | origin                  | owner        | comment | options | retention_time |
|---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------|
| Sun, 10 Jul 2016 23:28:50 -0700 | SNOWFLAKE_SAMPLE_DATA | N          | N          | SFC_SAMPLES.SAMPLE_DATA | ACCOUNTADMIN |         |         | 1              |
| Thu, 15 Jun 2017 18:30:08 -0700 | SNOW_SALES            | N          | Y          | xy12345.SALES_S         | ACCOUNTADMIN |         |         | 1              |
+---------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+

-- Example 12890
SHOW SHARES;

-- Example 12891
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 12892
DESC SHARE xy12345.sales_s;

+----------+------------------------------------------+---------------------------------+
| kind     | name                                     | shared_on                       |
|----------+------------------------------------------+---------------------------------|
| DATABASE | SNOW_SALES                               | Thu, 15 Jun 2017 17:03:16 -0700 |
| SCHEMA   | SNOW_SALES.AGGREGATES_EULA               | Thu, 15 Jun 2017 17:03:16 -0700 |
| TABLE    | SNOW_SALES.AGGREGATES_EULA.AGGREGATE_1   | Thu, 15 Jun 2017 17:03:16 -0700 |
| VIEW     | SNOW_SALES.AGGREGATES_EULA.AGGREGATE_1_v | Thu, 15 Jun 2017 17:03:16 -0700 |
+----------+------------------------------------------+---------------------------------+

-- Example 12893
use role r1;
create database snow_sales from share xy12345.sales_s;

-- Example 12894
grant imported privileges on database snow_sales to role r2;

-- Example 12895
use role r2;
grant imported privileges on database snow_sales to role r3;
revoke imported privileges on database snow_sales from role r3;

-- Example 12896
CREATE DATABASE c1 FROM SHARE provider1.share1;

-- Example 12897
SHOW DATABASE ROLES in DATABASE c1;
GRANT DATABASE ROLE c1.r1 TO ROLE analyst;

-- Example 12898
CREATE STREAM <name> ON VIEW <shared_db>.<schema>.<view>;

-- Example 12899
CREATE STREAM aggregate_1_v_stream ON VIEW snow_sales.aggregates_eula.aggregate_1_v;

-- Example 12900
CREATE STREAM <name> ON TABLE <shared_db>.<schema>.<table>;

-- Example 12901
CREATE STREAM aggregate_1_stream ON TABLE snow_sales.aggregates_eula.aggregate_1;

-- Example 12902
USE ROLE r1;

USE DATABASE snow_sales;

SELECT * FROM aggregates_1;

-- Example 12903
SELECT SYSTEM$DISABLE_DATABASE_REPLICATION('mydb');

-- Example 12904
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
  TO ROLE myrole;

-- Example 12905
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES
  ALLOWED_DATABASES = db1, db2
  ALLOWED_ACCOUNTS = myorg.myaccount2, myorg.myaccount3
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12906
USE ROLE ACCOUNTADMIN;

CREATE ROLE myrole;

GRANT CREATE FAILOVER GROUP ON ACCOUNT
  TO ROLE myrole;

-- Example 12907
USE ROLE myrole;

CREATE FAILOVER GROUP myfg
  AS REPLICA OF myorg.myaccount1.myfg;

-- Example 12908
GRANT REPLICATE ON FAILOVER GROUP myfg TO ROLE my_replication_role;

-- Example 12909
USE ROLE my_replication_role;

ALTER FAILOVER GROUP myfg REFRESH;

-- Example 12910
GRANT FAILOVER ON FAILOVER GROUP myfg TO ROLE my_failover_role;;

