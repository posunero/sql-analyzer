-- Example 24028
SELECT
    COUNT(O_ORDERDATE) as orders,
    :datebucket(O_ORDERDATE) as bucket
FROM
    SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
WHERE
    O_ORDERDATE = :daterange
GROUP BY
    :datebucket(O_ORDERDATE)
ORDER BY
    bucket;

-- Example 24029
+--------+------------+
| orders |  buckets   |
+--------+------------+
|    621 | 1992-01-01 |
|    612 | 1992-01-02 |
|    598 | 1992-01-03 |
|    670 | 1992-01-04 |
+--------+------------+

-- Example 24030
+--------+------------+
| orders |  buckets   |
+--------+------------+
|   3142 | 1991-12-30 |
|   4404 | 1992-01-06 |
|   4306 | 1992-01-13 |
|   4284 | 1992-01-20 |
+--------+------------+

-- Example 24031
from example_package import function
import other_package

-- Example 24032
import scikit-learn

-- Example 24033
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
    # your code goes here

-- Example 24034
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col

# Add parameters with optional type hints to the main handler function
def main(session: snowpark.Session, language: str):
  # Your code goes here, inside the "main" handler.
  table_name = 'information_schema.packages'
  dataFrame = session.table(table_name).filter(col("language") == language)

  # Print a sample of the dataFrame to standard output
  dataFrame.show()

  # The return value appears in the Results tab
  return dataFrame

# Add a second function to supply a value for the language parameter to validate that your main handler function runs.
def test_language(session: snowpark.Session):
  return main(session, 'java')

-- Example 24035
import snowflake.snowpark as snowpark

def main(session: snowpark.Session):
  tableName = "range_table"
  df_range = session.range(1, 10, 2).to_df('a')
  df_range.write.mode("overwrite").save_as_table(tableName)
  return tableName + " table successfully created"

-- Example 24036
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
from snowflake.snowpark.dataframe_reader import *
from snowflake.snowpark.functions import *

def main(session: snowpark.Session):

  inputTableName = "snowflake.account_usage.task_history"
  outputTableName = "aggregate_task_history"

  df = session.table(inputTableName)
  df.filter(col("STATE") != "SKIPPED")\
    .group_by(("SCHEDULED_TIME"), "STATE").count()\
    .write.mode("overwrite").save_as_table(outputTableName)
  return outputTableName + " table successfully written"

-- Example 24037
import snowflake.snowpark as snowpark
from snowflake.snowpark.types import *

schema_for_file = StructType([
  StructField("name", StringType()),
  StructField("role", StringType())
])

fileLocation = "@DB1.PUBLIC.FILES/data_0_0_0.csv.gz"
outputTableName = "employees"

def main(session: snowpark.Session):
  df_reader = session.read.schema(schema_for_file)
  df = df_reader.csv(fileLocation)
  df.write.mode("overwrite").save_as_table(outputTableName)

  return outputTableName + " table successfully written from stage"

-- Example 24038
GRANT USAGE ON <database-name> TO ROLE <role-name> WITH GRANT OPTION;

-- Example 24039
use role sysadmin;

create or replace table mydb.private.sensitive_data (
    name string,
    date date,
    time time(9),
    bid_price float,
    ask_price float,
    bid_size int,
    ask_size int,
    access_id string /* granularity for access */ )
    cluster by (date);

insert into mydb.private.sensitive_data
    values('AAPL',dateadd(day,  -1,current_date()), '10:00:00', 116.5, 116.6, 10, 10, 'STOCK_GROUP_1'),
          ('AAPL',dateadd(month,-2,current_date()), '10:00:00', 116.5, 116.6, 10, 10, 'STOCK_GROUP_1'),
          ('MSFT',dateadd(day,  -1,current_date()), '10:00:00',  58.0,  58.9, 20, 25, 'STOCK_GROUP_1'),
          ('MSFT',dateadd(month,-2,current_date()), '10:00:00',  58.0,  58.9, 20, 25, 'STOCK_GROUP_1'),
          ('IBM', dateadd(day,  -1,current_date()), '11:00:00', 175.2, 175.4, 30, 15, 'STOCK_GROUP_2'),
          ('IBM', dateadd(month,-2,current_date()), '11:00:00', 175.2, 175.4, 30, 15, 'STOCK_GROUP_2');

create or replace table mydb.private.sharing_access (
  access_id string,
  snowflake_account string
);


/* In the first insert, CURRENT_ACCOUNT() gives your account access to the AAPL and MSFT data.       */

insert into mydb.private.sharing_access values('STOCK_GROUP_1', CURRENT_ACCOUNT());


/* In the second insert, replace <consumer_account> with an account name; this account will have     */
/* access to IBM data only. Note that account names are case-sensitive and must be in uppercase      */
/* enclosed in single-quotes, e.g.                                                                   */
/*                                                                                                   */
/*      insert into mydb.private.sharing_access values('STOCK_GROUP_2', 'ACCT1')                */
/*                                                                                                   */
/* To share the IBM data with multiple accounts, repeat the second insert for each account.          */

insert into mydb.private.sharing_access values('STOCK_GROUP_2', '<consumer_account>');

-- Example 24040
create or replace secure view mydb.public.paid_sensitive_data as
    select name, date, time, bid_price, ask_price, bid_size, ask_size
    from mydb.private.sensitive_data sd
    join mydb.private.sharing_access sa on sd.access_id = sa.access_id
    and sa.snowflake_account = current_account();

grant select on mydb.public.paid_sensitive_data to public;


/* Test the table and secure view by first querying the data as the provider account. */

select count(*) from mydb.private.sensitive_data;

select * from mydb.private.sensitive_data;

select count(*) from mydb.public.paid_sensitive_data;

select * from mydb.public.paid_sensitive_data;

select * from mydb.public.paid_sensitive_data where name = 'AAPL';


/* Next, test the secure view by querying the data as a simulated consumer account. You specify the  */
/* account to simulate using the SIMULATED_DATA_SHARING_CONSUMER session parameter.                  */
/*                                                                                                   */
/* In the ALTER command, replace <consumer_account> with one of the accounts you specified in the    */
/* mapping table. Note that the account name is not case-sensitive and does not need to be enclosed  */
/* in single-quotes, e.g.                                                                            */
/*                                                                                                   */
/*      alter session set simulated_data_sharing_consumer=acct1;                                     */

alter session set simulated_data_sharing_consumer=<account_name>;

select * from mydb.public.paid_sensitive_data;

-- Example 24041
use role accountadmin;

create or replace share mydb_shared
  comment = 'Example of using Secure Data Sharing with secure views';

show shares;

-- Example 24042
/* Option 1: Create a database role, grant privileges on the objects to the database role, and then grant the database role to the share */

create database role mydb.dr1;

grant usage on database mydb to database role mydb.dr1;

grant usage on schema mydb.public to database role mydb.dr1;

grant select on mydb.public.paid_sensitive_data to database role mydb.dr1;

grant usage on database mydb to share mydb_shared;

grant database role mydb.dr1 to share mydb_shared;


/* Option 2: Grant privileges on the database objects to include in the share.  */

grant usage on database mydb to share mydb_shared;

grant usage on schema mydb.public to share mydb_shared;

grant select on mydb.public.paid_sensitive_data to share mydb_shared;


/*  Confirm the contents of the share. */

show grants to share mydb_shared;

-- Example 24043
/* In the alter statement, replace <consumer_accounts> with the  */
/* consumer account(s) you assigned to STOCK_GROUP2 earlier,     */
/* with each account name separated by commas, e.g.              */
/*                                                               */
/*    alter share mydb_shared set accounts = acct1, acct2;       */

alter share mydb_shared set accounts = <consumer_accounts>;

-- Example 24044
/* In the following commands, the share name must be fully qualified by replacing     */
/* <provider_account> with the name of the account that provided the share, e.g.      */
/*                                                                                    */
/*    desc prvdr1.mydb_shared;                                                        */

use role accountadmin;

show shares;

desc share <provider_account>.mydb_shared;

create database mydb_shared1 from share <provider_account>.mydb_shared;

-- Example 24045
/* Option 1 */
grant database role mydb_shared1.db1 to role custom_role1;

/* Option 2 */
grant imported privileges on database mydb_shared1 to custom_role1;

-- Example 24046
use role custom_role1;

show views;

use warehouse <warehouse_name>;

select * from paid_sensitive_data;

-- Example 24047
USE ROLE ACCOUNTADMIN;

GRANT IMPORT SHARE ON ACCOUNT TO SYSADMIN;

-- Example 24048
use role accountadmin;
grant override share restrictions on account to role sysadmin;

-- Example 24049
use role sysadmin;
alter share my_share add accounts = consumerorg.consumeraccount SHARE_RESTRICTIONS=false;

-- Example 24050
CREATE OR REPLACE HYBRID TABLE sensor_data_device1 (
  timestamp TIMESTAMP_NTZ PRIMARY KEY,
  device_id VARCHAR(10),
  temperature DECIMAL(6,4),
  vibration DECIMAL(6,4),
  motor_rpm INT,
  INDEX device_idx(device_id)
 );

-- Example 24051
SELECT * FROM sensor_data_device1 WHERE timestamp='2024-03-01 13:45:56.000';

-- Example 24052
SELECT COUNT(*) FROM sensor_data_device1 WHERE device_id='DEVICE2';

-- Example 24053
UPDATE sensor_data_device2 SET device_id='DEVICE3' WHERE timestamp = '2024-04-02 00:00:05.000';

-- Example 24054
SELECT device_id, AVG(temperature)
  FROM sensor_data_device2
  WHERE temperature>33
  GROUP BY device_id;

-- Example 24055
SHOW DYNAMIC TABLES;

-- Example 24056
CREATE TABLE persons
  AS
    SELECT column1 AS id, parse_json(column2) AS entity
    FROM values
      (12712555,
      '{ name:  { first: "John", last: "Smith"},
        contact: [
        { business:[
          { type: "phone", content:"555-1234" },
          { type: "email", content:"j.smith@example.com" } ] } ] }'),
      (98127771,
      '{ name:  { first: "Jane", last: "Doe"},
        contact: [
        { business:[
          { type: "phone", content:"555-1236" },
          { type: "email", content:"j.doe@example.com" } ] } ] }') v;

CREATE DYNAMIC TABLE example
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = mywh
  REFRESH_MODE = INCREMENTAL
  AS
    SELECT p.id, f.value, f.path
    FROM persons p,
    LATERAL FLATTEN(input => p.entity) f;

-- Example 24057
CREATE DYNAMIC TABLE sums
  AS
    SELECT date_trunc(minute, ts), sum(c1) FROM table
    GROUP BY 1;

-- Example 24058
CREATE DYNAMIC TABLE intermediate
  AS
    SELECT date_trunc(minute, ts) ts_min, c1 FROM table;

-- Example 24059
CREATE DYNAMIC TABLE sums
  AS
    SELECT ts_min, sum(c1) FROM intermediate
    GROUP BY 1;

-- Example 24060
SHOW DYNAMIC TABLES LIKE 'product_%' IN SCHEMA mydb.myschema;

-- Example 24061
+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | created_on               | name       | database_name | schema_name | cluster_by | rows | bytes  | owner    | target_lag | refresh_mode | refresh_mode_reason  | warehouse | comment | text                            | automatic_clustering | scheduling_state | last_suspended_on | is_clone  | is_replica  | is_iceberg | data_timestamp           | owner_role_type |
  |-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  |2025-01-01 16:32:28 +0000 | product_dt | my_db         | my_schema   |            | 2    | 2048   | ORGADMIN | DOWNSTREAM | INCREMENTAL  | null                 | mywh      |         | create or replace dynamic table | OFF                  | ACTIVE           | null              | false     | false       | false      |2025-01-01 16:32:28 +0000 | ROLE            |
                                                                                                                                                                                         |  product dt ...                 |                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                       |
  +-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 24062
DESC DYNAMIC TABLE my_dynamic_table;

-- Example 24063
+-------------------+--------------------------------------------------------------------------------------------------------------------------+
  | name   | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name  | privacy domain |
  |-------------------+------------------------------------------------------------------------------------------------------------------------|
  | AMOUNT | NUMBER(38,0) | COLUMN | Y     | null    | N           | N          | null  | null       | null    | null         | null           |                                                                                                                                                  |                                                                                                                                                                                                                                                                                                                                                                                                                       |
  +-------------------+------------------------------------------------------------------------------------------------------------------------+

-- Example 24064
GRANT OWNERSHIP ON DYNAMIC TABLE my_dynamic_table TO ROLE budget_admin;

-- Example 24065
GRANT OWNERSHIP ON FUTURE DYNAMIC TABLES IN SCHEMA mydb.myschema TO ROLE budget_admin;

-- Example 24066
-- Change the warehouse for my_dynamic_table to my_other_wh:
ALTER DYNAMIC TABLE my_dynamic_table SET
  WAREHOUSE = my_other_wh;

-- Example 24067
-- Specify the downstream target lag for a dynamic table:
ALTER DYNAMIC TABLE my_dynamic_table SET
  TARGET_LAG = DOWNSTREAM;

-- Example 24068
ALTER DYNAMIC TABLE my_dynamic_table RENAME TO my_new_dynamic_table;

-- Example 24069
-- Swap my_dynamic_table with the my_new_dynamic_table:
ALTER DYNAMIC TABLE my_dynamic_table SWAP WITH my_new_dynamic_table;

-- Example 24070
ALTER DYNAMIC TABLE my_dynamic_table CLUSTER BY (date);

-- Example 24071
DROP DYNAMIC TABLE my_dynamic_table;

-- Example 24072
UNDROP DYNAMIC TABLE my_dynamic_table;

-- Example 24073
SELECT name, scheduling_state
  FROM TABLE (INFORMATION_SCHEMA.DYNAMIC_TABLE_GRAPH_HISTORY());

-- Example 24074
+-------------------+---------------------------------------------------------------------------------+
  | NAME              | SCHEDULING_STATE                                                                |
  |-------------------+---------------------------------------------------------------------------------|
  | DTSIMPLE          | {                                                                               |
  |                   |   "reason_code": "SUSPENDED_DUE_TO_ERRORS",                                     |
  |                   |   "reason_message": "The DT was suspended due to 5 consecutive refresh errors", |
  |                   |   "state": "SUSPENDED",                                                         |
  |                   |   "suspended_on": "2023-06-06 19:27:29.142 -0700"                               |
  |                   | }                                                                               |
  | DT_TEST           | {                                                                               |
  |                   |   "state": "ACTIVE"                                                             |
  |                   | }                                                                               |
  +-------------------+---------------------------------------------------------------------------------+

-- Example 24075
ALTER DYNAMIC TABLE my_dynamic_table SUSPEND;

-- Example 24076
ALTER DYNAMIC TABLE my_dynamic_table RESUME;

-- Example 24077
ALTER DYNAMIC TABLE my_dynamic_table REFRESH

-- Example 24078
CREATE STREAM append_only_comparison ON EVENT TABLE my_event_table APPEND_ONLY=TRUE;

-- Example 24079
SYSTEM$GET_PRIVATELINK_CONFIG()

-- Example 24080
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-internal-stage": "<privatelink_stage_endpoint>",
  "privatelink-account-url": "<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-vpce-id": "<aws_vpce_id>",
  "privatelink-account-principal": "<aws_principal_arn>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>",
  "app-service-privatelink-url": "<privatelink_streamlit_url>"
}

-- Example 24081
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-internal-stage": "<privatelink_stage_endpoint>",
  "privatelink-account-url":"<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-pls-id": "<azure_privatelink_service_id>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>"
}

-- Example 24082
{
  "regionless-snowsight-privatelink-url": "<privatelink_org_snowsight_url>",
  "privatelink-account-name": "<account_identifier>",
  "privatelink-connection-ocsp-urls": "<client_redirect_ocsp_url_list>",
  "snowsight-privatelink-url": "<privatelink_region_snowsight_url>",
  "privatelink-account-url": "<privatelink_account_url>",
  "privatelink-connection-urls": "<privatelink_connection_url_list>",
  "regionless-privatelink-account-url": "<privatelink_org_account_url>",
  "privatelink-ocsp-url": "<privatelink_ocsp_url>",
  "privatelink-gcp-service-attachment": "<snowflake_service_endpoint>",
  "regionless-privatelink-ocsp-url": "<privatelink_org_ocsp_url>"
}

-- Example 24083
SELECT SYSTEM$GET_PRIVATELINK_CONFIG();

-- Example 24084
select key, value from table(flatten(input=>parse_json(SYSTEM$GET_PRIVATELINK_CONFIG())));

+--------------------------------------+--------------------------------------+
| KEY                                  | VALUE                                |
+--------------------------------------+--------------------------------------+
| regionless-snowsight-privatelink-url | "<privatelink_org_snowsight_url>"    |
|--------------------------------------+--------------------------------------|
| privatelink-account-name             | "<account_identifier>"               |
|--------------------------------------+--------------------------------------|
| privatelink-connection-ocsp-urls     | "<client_redirect_ocsp_url_list>"    |
|--------------------------------------+--------------------------------------|
| snowsight-privatelink-url            | "<privatelink_region_snowsight_url>" |
|--------------------------------------+--------------------------------------|
| privatelink-internal-stage           | "<privatelink_stage_endpoint>"       |
|--------------------------------------+--------------------------------------|
| privatelink-account-url              | "<privatelink_account_url>"          |
|--------------------------------------+--------------------------------------|
| privatelink-connection-urls          | "<privatelink_connection_url_list>"  |
|--------------------------------------+--------------------------------------|
| privatelink-pls-id                   | "<azure_private_link_service_id>"    |
|--------------------------------------+--------------------------------------|
| regionless-privatelink-account-url   | "<privatelink_org_account_url>"      |
|--------------------------------------+--------------------------------------|
| privatelink-ocsp-url                 | "<privatelink_ocsp_url>"             |
|--------------------------------------+--------------------------------------|
| regionless-privatelink-ocsp-url      | "<privatelink_org_ocsp_url>"         |
+--------------------------------------+--------------------------------------+

-- Example 24085
ALTER SECURITY INTEGRATION <oauth_integration> SET NETWORK_POLICY = <oauth_network_policy>;

-- Example 24086
ALTER SECURITY INTEGRATION <oauth_integration> UNSET <oauth_network_policy>;

-- Example 24087
ALTER ACCOUNT my_account1 DROP OLD URL;

-- Example 24088
ALTER ACCOUNT my_account1 DROP OLD ORGANIZATION URL;

-- Example 24089
aws sts get-federation-token --name sam

-- Example 24090
{
   ...
   "FederatedUser": {
       "FederatedUserId": "185...:sam",
       "Arn": "arn:aws:sts::185...:federated-user/sam"
   },
   "PackedPolicySize": 0
 }

-- Example 24091
select SYSTEM$AUTHORIZE_PRIVATELINK ( '<aws_id>' , '<federated_token>' );

-- Example 24092
use role accountadmin;

select SYSTEM$AUTHORIZE_PRIVATELINK (
    '185...',
    '{
       "Credentials": {
           "AccessKeyId": "ASI...",
           "SecretAccessKey": "enw...",
           "SessionToken": "Fwo...",
           "Expiration": "2021-01-07T19:06:23+00:00"
       },
       "FederatedUser": {
           "FederatedUserId": "185...:sam",
           "Arn": "arn:aws:sts::185...:federated-user/sam"
       },
       "PackedPolicySize": 0
    }'
  );

-- Example 24093
CREATE SECURITY INTEGRATION oauth_kp_int
  TYPE = OAUTH
  ENABLED = TRUE
  OAUTH_CLIENT = CUSTOM
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://localhost.com'
  OAUTH_ISSUE_REFRESH_TOKENS = TRUE
  OAUTH_REFRESH_TOKEN_VALIDITY = 86400
  BLOCKED_ROLES_LIST = ('SYSADMIN')
  OAUTH_CLIENT_RSA_PUBLIC_KEY ='
  MIIBI
  ...
  ';

-- Example 24094
<snowflake_account_url>/oauth/authorize

