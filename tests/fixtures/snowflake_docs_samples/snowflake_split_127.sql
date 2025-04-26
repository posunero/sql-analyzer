-- Example 8490
GRANT IMPORTED PRIVILEGES ON DATABASE db_share TO ROLE db_share_role;

-- Example 8491
GRANT DATABASE ROLE my_db_role TO ROLE consumer_analyst_role;

-- Example 8492
CREATE SHARE sales_s;

-- Example 8493
CREATE DATABASE ROLE sales_db.dr1;

GRANT USAGE ON DATABASE sales_db TO DATABASE ROLE sales_db.dr1;

GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO DATABASE ROLE sales_db.dr1;

GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO DATABASE ROLE sales_db.dr1;

GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;

GRANT DATABASE ROLE sales_db.dr1 TO SHARE sales_s;

-- Example 8494
GRANT USAGE ON DATABASE sales_db TO SHARE sales_s;

GRANT USAGE ON SCHEMA sales_db.aggregates_eula TO SHARE sales_s;

GRANT SELECT ON TABLE sales_db.aggregates_eula.aggregate_1 TO SHARE sales_s;

-- Example 8495
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 8496
ALTER SHARE sales_s ADD ACCOUNTS=xy12345, yz23456;

-- Example 8497
SHOW SHARES;

-- Example 8498
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.XY12345         | SALES_S2      | UPDATED_SALES_DB      |                  |              | Transformed and updated sales data     |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 8499
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

GRANT SELECT ON VIEW sales_db.aggregates_eula.agg_secure TO SHARE sales_s;

SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-17 12:33:15.310 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGG_SECURE  | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 8500
SHOW GRANTS TO SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-17 12:33:15.310 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGG_SECURE  | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

REVOKE SELECT ON VIEW sales_db.aggregates_eula.agg_secure FROM SHARE sales_s;

+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+
| created_on                    | privilege | granted_on | name                                 | granted_to | grantee_name   | grant_option | granted_by   |
|-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------|
| 2017-06-15 16:45:07.307 -0700 | USAGE     | DATABASE   | SALES_DB                             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:10.310 -0700 | USAGE     | SCHEMA     | SALES_DB.AGGREGATES_EULA             | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
| 2017-06-15 16:45:12.312 -0700 | SELECT    | TABLE      | SALES_DB.AGGREGATES_EULA.AGGREGATE_1 | SHARE      | PRVDR1.SALES_S | false        | ACCOUNTADMIN |
+-------------------------------+-----------+------------+--------------------------------------+------------+----------------+--------------+--------------+

-- Example 8501
SHOW SHARES;

-- Example 8502
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.PRVDR1          | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.PRVDR1          | SALES_S2      | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 8503
SHOW GRANTS OF SHARE sales_s;

-- Example 8504
+-------------------------------+----------------+------------+----------+
| created_on                    | share          | granted_to | account  |
|-------------------------------+----------------+------------+----------|
| 2017-06-15 18:00:03.803 -0700 | PRVDR1.SALES_S | ACCOUNT    | XY12345  |
+-------------------------------+----------------+------------+----------+

-- Example 8505
SHOW GRANTS OF SHARE sales_s2;

-- Example 8506
+------------+-------+------------+---------+
| created_on | share | granted_to | account |
|------------+-------+------------+---------|
+------------+-------+------------+---------+

-- Example 8507
GRANT OWNERSHIP ON TASK mytask TO ROLE myrole;
GRANT DATABASE ROLE USAGE_VIEWER TO ROLE myrole;

-- Example 8508
ALTER ACCOUNT SET LOG_LEVEL = ERROR;

-- Example 8509
ALTER DATABASE my_db SET LOG_LEVEL = INFO;

-- Example 8510
ALTER DYNAMIC TABLE my_dynamic_table SET LOG_LEVEL = WARN;

-- Example 8511
CREATE ALERT my_alert_on_dt_refreshes
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENT_TABLE
      WHERE resource_attributes:"snow.executable.type" = 'dynamic_table'
        AND resource_attributes:"snow.database.name" = 'my_db'
        AND record_attributes:"event.name" = 'refresh.status'
        AND record:"severity_text" = 'ERROR'
        AND value:"state" = 'FAILED'))
  THEN
    BEGIN
      LET result_str VARCHAR;
      (SELECT ARRAY_TO_STRING(ARRAY_ARG(name)::ARRAY, ',') INTO :result_str
         FROM (
           SELECT resource_attributes:"snow.executable.name"::VARCHAR name
             FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID()))
             LIMIT 10
         )
      );
      CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
        SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(:result_str),
        '{"my_slack_integration": {}}'
      );
    END;

-- Example 8512
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS dt_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 8513
+-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------+
| TIMESTAMP               | DT_NAME          | QUERY_ID                             | ERROR                                                                           |
|-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------|
| 2025-02-17 21:40:45.444 | MY_DYNAMIC_TABLE | 01ba7614-0107-e56c-0000-a995024f304a | SQL compilation error:                                                          |
|                         |                  |                                      | Failure during expansion of view 'MY_DYNAMIC_TABLE': SQL compilation error:     |
|                         |                  |                                      | Object 'MY_DB.MY_SCHEMA.MY_BASE_TABLE' does not exist or not authorized.        |
+-------------------------+------------------+--------------------------------------+---------------------------------------------------------------------------------+

-- Example 8514
SELECT *
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.schema.name" = 'MY_SCHEMA' AND
    value:state = 'UPSTREAM_FAILURE'
  ORDER BY timestamp DESC;

-- Example 8515
+-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------+
| TIMESTAMP               | START_TIMESTAMP | OBSERVED_TIMESTAMP      | TRACE | RESOURCE | RESOURCE_ATTRIBUTES                             | SCOPE | SCOPE_ATTRIBUTES | RECORD_TYPE | RECORD                      | RECORD_ATTRIBUTES | VALUE                         | EXEMPLARS |
|-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------|
| 2025-02-17 21:40:45.486 | NULL            | 2025-02-17 21:40:45.486 | NULL  | NULL     | {                                               | NULL  | NULL             | EVENT       | {                           | NULL              | {                             | NULL      |
|                         |                 |                         |       |          |   "snow.database.id": 49,                       |       |                  |             |   "name": "refresh.status", |                   |   "state": "UPSTREAM_FAILURE" |           |
|                         |                 |                         |       |          |   "snow.database.name": "MY_DB",                |       |                  |             |   "severity_text": "WARN"   |                   | }                             |           |
|                         |                 |                         |       |          |   "snow.executable.id": 487426,                 |       |                  |             | }                           |                   |                               |           |
|                         |                 |                         |       |          |   "snow.executable.name": "MY_DYNAMIC_TABLE_2", |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.executable.type": "DYNAMIC_TABLE",      |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.id": 2601,                        |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.name": "DATA_ADMIN",              |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.owner.type": "ROLE",                    |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.schema.id": 411,                        |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          |   "snow.schema.name": "MY_SCHEMA"               |       |                  |             |                             |                   |                               |           |
|                         |                 |                         |       |          | }                                               |       |                  |             |                             |                   |                               |           |
+-------------------------+-----------------+-------------------------+-------+----------+-------------------------------------------------+-------+------------------+-------------+-----------------------------+-------------------+-------------------------------+-----------+

-- Example 8516
SELECT name, state, state_code, state_message, query_id, data_timestamp, refresh_start_time, refresh_end_time
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(NAME_PREFIX => 'MYDB.MYSCHEMA.', ERROR_ONLY => TRUE))
ORDER BY name, data_timestamp;

-- Example 8517
SELECT account_name,
  ROUND(SUM(usage_in_currency), 2) as usage_in_currency
FROM snowflake.organization_usage.usage_in_currency_daily
WHERE usage_date > DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 desc;

-- Example 8518
GRANT ROLE ACCOUNTADMIN, SYSADMIN TO USER user2;

ALTER USER user2 SET EMAIL='user2@domain.com', DEFAULT_ROLE=SYSADMIN;

-- Example 8519
CREATE ROLE r1
   COMMENT = 'This role has all privileges on schema_1';

-- Example 8520
GRANT USAGE
  ON WAREHOUSE w1
  TO ROLE r1;

GRANT USAGE
  ON DATABASE d1
  TO ROLE r1;

GRANT USAGE
  ON SCHEMA d1.s1
  TO ROLE r1;

GRANT SELECT
  ON TABLE d1.s1.t1
  TO ROLE r1;

-- Example 8521
GRANT ROLE r1
   TO USER smith;

-- Example 8522
ALTER USER smith
   SET DEFAULT_ROLE = r1;

-- Example 8523
GRANT USAGE
  ON DATABASE d1
  TO ROLE read_only;

GRANT USAGE
  ON SCHEMA d1.s1
  TO ROLE read_only;

GRANT SELECT
  ON ALL TABLES IN SCHEMA d1.s1
  TO ROLE read_only;

GRANT USAGE
  ON WAREHOUSE w1
  TO ROLE read_only;

-- Example 8524
GRANT SELECT ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE read_only;

-- Example 8525
GRANT ROLE r1
   TO ROLE sysadmin;

-- Example 8526
SHOW GRANTS ON SCHEMA <database_name>.<schema_name>;

-- Example 8527
SHOW GRANTS ON SCHEMA database_a.schema_1;

-- Example 8528
+-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------+
| created_on                    | privilege             | granted_on | name                 | granted_to | grantee_name             | grant_option | granted_by    |
|-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------|
| 2022-03-07 09:04:23.635 -0800 | USAGE                 | SCHEMA     | D1.S1                | ROLE       | R1                       | false        | SECURITYADMIN |
+-------------------------------+-----------------------+------------+----------------------+------------+--------------------------+--------------+---------------+

-- Example 8529
SHOW GRANTS TO ROLE <role_name>;
SHOW GRANTS TO USER <user_name>;

-- Example 8530
SHOW GRANTS TO ROLE r1;

-- Example 8531
+-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------+
| created_on                    | privilege | granted_on | name                 | granted_to | grantee_name | grant_option | granted_by    |
|-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------|
| 2022-03-07 09:08:43.773 -0800 | USAGE     | DATABASE   | D1                   | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:08:55.253 -0800 | USAGE     | SCHEMA     | D1.S1                | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:09:07.206 -0800 | SELECT    | TABLE      | D1.S1.T1             | ROLE       | R1           | false        | SECURITYADMIN |
| 2022-03-07 09:08:34.838 -0800 | USAGE     | WAREHOUSE  | W1                   | ROLE       | R1           | false        | SECURITYADMIN |
+-------------------------------+-----------+------------+----------------------+------------+--------------+--------------+---------------+

-- Example 8532
GRANT SELECT ON FUTURE TABLES IN DATABASE d1 TO ROLE r1;

-- Example 8533
GRANT INSERT,DELETE ON FUTURE TABLES IN SCHEMA d1.s1 TO ROLE r2;

-- Example 8534
GRANT MONITOR USAGE ON ACCOUNT TO ROLE custom;

GRANT IMPORTED PRIVILEGES ON DATABASE snowflake TO ROLE custom;

-- Example 8535
GRANT MANAGE USER SUPPORT CASES ON ACCOUNT TO ROLE myrole;

-- Example 8536
select (V:main.temp_max - 273.15) * 1.8000 + 32.00 as temp_max_far,
       (V:main.temp_min - 273.15) * 1.8000 + 32.00 as temp_min_far,
       cast(V:time as TIMESTAMP) time,
       V:city.coord.lat lat,
       V:city.coord.lon lon,
       V
from snowflake_sample_data.weather.WEATHER_14_TOTAL
where v:city.name = 'New York'
and   v:city.country = 'US'
order by time desc
limit 10;

-- Example 8537
with
forecast as
(select ow.V:time         as prediction_dt,
        ow.V:city.name    as city,
        ow.V:city.country as country,
        cast(f.value:dt   as timestamp) as forecast_dt,
        f.value:temp.max  as forecast_max_k,
        f.value:temp.min  as forecast_min_k,
        f.value           as forecast
 from snowflake_sample_data.weather.daily_16_total ow, lateral FLATTEN(input => V, path => 'data') f),

actual as
(select V:main.temp_max as temp_max_k,
        V:main.temp_min as temp_min_k,
        cast(V:time as timestamp)     as time_dt,
        V:city.name     as city,
        V:city.country  as country
 from snowflake_sample_data.weather.WEATHER_14_TOTAL)

select cast(forecast.prediction_dt as timestamp) prediction_dt,
       forecast.forecast_dt,
       forecast.forecast_max_k,
       forecast.forecast_min_k,
       actual.temp_max_k,
       actual.temp_min_k
from actual
left join forecast on actual.city = forecast.city and
                      actual.country = forecast.country and
                      date_trunc(day, actual.time_dt) = date_trunc(day, forecast.forecast_dt)
where actual.city = 'New York'
and   actual.country = 'US'
order by forecast_dt desc, prediction_dt desc;

-- Example 8538
use role accountadmin;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 8539
gcloud components update

-- Example 8540
gcloud auth login

-- Example 8541
gcloud config set project <project_id>

-- Example 8542
gcloud projects list --sort-by=projectId

-- Example 8543
gcloud compute addresses create <customer_vip_name> \
--subnet=<subnet_name> \
--addresses=<customer_vip_address>
--region=<region>

-- Example 8544
gcloud compute addresses create psc-vip-1 \
--subnet=psc-subnet \
--addresses=192.168.3.3 \
--region=us-central1

# returns

Created [https://www.googleapis.com/compute/v1/projects/docstest-123456/regions/us-central1/addresses/psc-vip-1].

-- Example 8545
gcloud compute forwarding-rules create <name> \
--region=<region> \
--network=<network_name> \
--address=<customer_vip_name> \
--target-service-attachment=<privatelink-gcp-service-attachment>

-- Example 8546
gcloud compute forwarding-rules create test-psc-rule \
--region=us-central1 \
--network=psc-vpc \
--address=psc-vip-1 \
--target-service-attachment=projects/us-central1-deployment1-c8cc/regions/us-central1/serviceAttachments/snowflake-us-central1-psc

# returns

Created [https://www.googleapis.com/compute/projects/mdlearning-293607/regions/us-central1/forwardingRules/test-psc-rule].

-- Example 8547
gcloud compute forwarding-rules list --regions=<region>

-- Example 8548
Name     CloudName   SubscriptionId                        State    IsDefault
-------  ----------  ------------------------------------  -------  ----------
MyCloud  AzureCloud  13c...                                Enabled  True

-- Example 8549
az network private-endpoint show

-- Example 8550
az account get-access-token --subscription <SubscriptionID>

-- Example 8551
{
   "accessToken": "eyJ...",
   "expiresOn": "2021-05-21 21:38:31.401332",
   "subscription": "0cc...",
   "tenant": "d47...",
   "tokenType": "Bearer"
 }

-- Example 8552
USE ROLE ACCOUNTADMIN;

SELECT SYSTEM$AUTHORIZE_PRIVATELINK (
  '/subscriptions/26d.../resourcegroups/sf-1/providers/microsoft.network/privateendpoints/test-self-service',
  'eyJ...'
  );

-- Example 8553
USE ROLE GLOBALORGADMIN;

-- Example 8554
USE ROLE ORGADMIN;

-- Example 8555
USE ROLE ORGADMIN;

ALTER ACCOUNT my_account1 SET IS_ORG_ADMIN = TRUE;

-- Example 8556
USE ROLE GLOBALORGADMIN;

