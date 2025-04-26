-- Example 1021
TO_GEOGRAPHY( <input> [, <allowInvalid> ] )

-- Example 1022
ST_GEOGFROMWKB( <input> [, <allowInvalid> ] )

-- Example 1023
ST_GEOGFROMWKT( <input> [, <allowInvalid> ] )

-- Example 1024
TO_GEOMETRY( <input> [, <allowInvalid> ] )

-- Example 1025
ST_GEOMFROMWKB( <input> [, <allowInvalid> ] )

-- Example 1026
ST_GEOMFROMWKT( <input> [, <allowInvalid> ] )

-- Example 1027
SELECT TO_GEOMETRY('LINESTRING(100 102,100 102)', TRUE);

-- Example 1028
SELECT TO_GEOMETRY('LINESTRING(100 102,100 102)', TRUE) AS g, ST_ISVALID(g);

-- Example 1029
create or replace table orders (id int, order_name varchar);
create or replace table customers (id int, customer_name varchar);

-- Example 1030
create or replace view ordersByCustomer as select * from orders natural join customers;
insert into orders values (1, 'order1');
insert into customers values (1, 'customer1');

-- Example 1031
create or replace stream ordersByCustomerStream on view ordersBycustomer;

-- Example 1032
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
+----+------------+---------------+

select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
+----+------------+---------------+-----------------+-------------------+

-- Example 1033
insert into orders values (1, 'order2');
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
|  1 | order2     | customer1     |
+----+------------+---------------+

-- Example 1034
select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
|  1 | order2     | customer1     | INSERT          | False             |
+----+------------+---------------+-----------------+-------------------+

-- Example 1035
insert into customers values (1, 'customer2');
select * from ordersByCustomer;
+----+------------+---------------+
| ID | ORDER_NAME | CUSTOMER_NAME |
|----+------------+---------------|
|  1 | order1     | customer1     |
|  1 | order2     | customer1     |
|  1 | order1     | customer2     |
|  1 | order2     | customer2     |
+----+------------+---------------+

-- Example 1036
select * exclude metadata$row_id from ordersByCustomerStream;
+----+------------+---------------+-----------------+-------------------+
| ID | ORDER_NAME | CUSTOMER_NAME | METADATA$ACTION | METADATA$ISUPDATE |
|----+------------+---------------+-----------------+-------------------|
|  1 | order1     | customer2     | INSERT          | False             |
|  1 | order2     | customer1     | INSERT          | False             |
|  1 | order2     | customer2     | INSERT          | False             |
+----+------------+---------------+-----------------+-------------------+

-- Example 1037
USE ROLE ACCOUNTADMIN;

CREATE ROLE my_alert_role;

-- Example 1038
GRANT EXECUTE ALERT ON ACCOUNT TO ROLE my_alert_role;

-- Example 1039
GRANT EXECUTE MANAGED ALERT ON ACCOUNT TO ROLE my_alert_role;

-- Example 1040
GRANT ROLE my_alert_role TO USER my_user;

-- Example 1041
GRANT CREATE ALERT ON SCHEMA my_schema TO ROLE my_alert_role;
GRANT USAGE ON SCHEMA my_schema TO ROLE my_alert_role;

-- Example 1042
GRANT USAGE ON DATABASE my_database TO ROLE my_alert_role;

-- Example 1043
GRANT USAGE ON WAREHOUSE my_warehouse TO ROLE my_alert_role;

-- Example 1044
CREATE OR REPLACE ALERT my_alert
  WAREHOUSE = mywarehouse
  SCHEDULE = '1 minute'
  IF( EXISTS(
    SELECT gauge_value FROM gauge WHERE gauge_value>200))
  THEN
    INSERT INTO gauge_value_exceeded_history VALUES (current_timestamp());

-- Example 1045
CREATE OR REPLACE ALERT my_alert
  SCHEDULE = '1 minute'
  IF( EXISTS(
    SELECT gauge_value FROM gauge WHERE gauge_value>200))
  THEN
    INSERT INTO gauge_value_exceeded_history VALUES (current_timestamp());

-- Example 1046
ALTER ALERT my_alert RESUME;

-- Example 1047
SHOW PARAMETERS LIKE 'EVENT_TABLE' IN ACCOUNT;

-- Example 1048
+-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------+
| key         | value                     | default                    | level   | description                             | type   |
|-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------|
| EVENT_TABLE | my_db.my_schema.my_events | snowflake.telemetry.events | ACCOUNT | Event destination for the given target. | STRING |
+-------------+---------------------------+----------------------------+---------+-----------------------------------------+--------+

-- Example 1049
ALTER TABLE my_db.my_schema.my_events SET CHANGE_TRACKING = TRUE;

-- Example 1050
CREATE OR REPLACE ALERT my_alert
  WAREHOUSE = mywarehouse
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENTS
      WHERE
        resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
        record_type='EVENT' AND
        value:"state"='ERROR'
  ))
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

-- Example 1051
CREATE OR REPLACE ALERT my_alert
  IF( EXISTS(
    SELECT * FROM SNOWFLAKE.TELEMETRY.EVENTS
      WHERE
        resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
        record_type='EVENT' AND
        value:"state"='ERROR'
  ))
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

-- Example 1052
ALTER ALERT my_alert RESUME;

-- Example 1053
<now> - <last_execution_of_the_alert>

-- Example 1054
GRANT DATABASE ROLE SNOWFLAKE.ALERT_VIEWER TO ROLE alert_role;

-- Example 1055
CREATE OR REPLACE ALERT alert_new_rows
  WAREHOUSE = my_warehouse
  SCHEDULE = '1 MINUTE'
  IF (EXISTS (
      SELECT *
      FROM my_table
      WHERE row_timestamp BETWEEN SNOWFLAKE.ALERT.LAST_SUCCESSFUL_SCHEDULED_TIME()
       AND SNOWFLAKE.ALERT.SCHEDULED_TIME()
  ))
  THEN CALL SYSTEM$SEND_EMAIL(...);

-- Example 1056
CREATE ALERT my_alert
  WAREHOUSE = my_warehouse
  SCHEDULE = '1 MINUTE'
  IF (EXISTS (
    SELECT * FROM my_source_table))
  THEN
    BEGIN
      LET condition_result_set RESULTSET :=
        (SELECT * FROM TABLE(RESULT_SCAN(SNOWFLAKE.ALERT.GET_CONDITION_QUERY_UUID())));
      ...
    END;

-- Example 1057
EXECUTE ALERT my_alert;

-- Example 1058
ALTER ALERT my_alert SUSPEND;

-- Example 1059
ALTER ALERT my_alert RESUME;

-- Example 1060
ALTER ALERT my_alert SET WAREHOUSE = my_other_warehouse;

-- Example 1061
ALTER ALERT my_alert SET SCHEDULE = '2 minutes';

-- Example 1062
ALTER ALERT my_alert MODIFY CONDITION EXISTS (SELECT gauge_value FROM gauge WHERE gauge_value>300);

-- Example 1063
ALTER ALERT my_alert MODIFY ACTION CALL my_procedure();

-- Example 1064
DROP ALERT my_alert;

-- Example 1065
DROP ALERT IF EXISTS my_alert;

-- Example 1066
SHOW ALERTS;

-- Example 1067
DESC ALERT my_alert;

-- Example 1068
SELECT *
FROM
  TABLE(INFORMATION_SCHEMA.ALERT_HISTORY(
    SCHEDULED_TIME_RANGE_START
      =>dateadd('hour',-1,current_timestamp())))
ORDER BY SCHEDULED_TIME DESC;

-- Example 1069
GRANT MONITOR ON ALERT my_alert TO ROLE my_alert_role;

-- Example 1070
USE ROLE my_alert_role;

-- Example 1071
SELECT query_text FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
  WHERE query_text LIKE '%Some condition%'
    OR query_text LIKE '%Some action%'
  ORDER BY start_time DESC;

-- Example 1072
CALL SYSTEM$SEND_EMAIL(
    'my_email_int',
    'first.last@example.com, first2.last2@example.com',
    'Email Alert: Task A has finished.',
    'Task A has successfully finished.\nStart Time: 10:10:32\nEnd Time: 12:15:45\nTotal Records Processed: 115678'
);

-- Example 1073
ALTER ACCOUNT SET ENABLE_TRI_SECRET_AND_REKEY_OPT_OUT_FOR_IMAGE_REPOSITORY=True;

ALTER ACCOUNT SET PERIODIC_DATA_REKEYING = true;

-- Example 1074
-- create encrypted stage
create stage encrypted_customer_stage
url='s3://customer-bucket/data/'
credentials=(AWS_KEY_ID='ABCDEFGH' AWS_SECRET_KEY='12345678')
encryption=(MASTER_KEY='eSxX...=');

-- Example 1075
-- create table and ingest data from stage
CREATE TABLE users (id bigint, name varchar(500), purchases int);
COPY INTO users FROM @encrypted_customer_stage/users;

-- Example 1076
-- find top 10 users by purchases, unload into stage
CREATE TABLE most_purchases as select * FROM users ORDER BY purchases desc LIMIT 10;
COPY INTO @encrypted_customer_stage/most_purchases FROM most_purchases;

-- Example 1077
CREATE NETWORK RULE block_public_access
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('0.0.0.0/0');

CREATE NETWORK RULE allow_vpceid_access
  MODE = INGRESS
  TYPE = AWSVPCEID
  VALUE_LIST = ('vpce-0fa383eb170331202');

CREATE NETWORK POLICY allow_vpceid_block_public_policy
  ALLOWED_NETWORK_RULE_LIST = ('allow_vpceid_access')
  BLOCKED_NETWORK_RULE_LIST=('block_public_access');

-- Example 1078
CREATE NETWORK RULE allow_access_rule
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('192.168.1.0/24');

CREATE NETWORK RULE block_access_rule
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('192.168.1.99');

CREATE NETWORK POLICY public_network_policy
  ALLOWED_NETWORK_RULE_LIST = ('allow_access_rule')
  BLOCKED_NETWORK_RULE_LIST=('block_access_rule');

-- Example 1079
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENFORCE_NETWORK_RULES_FOR_INTERNAL_STAGES = true;

-- Example 1080
GRANT USAGE ON DATABASE securitydb TO ROLE network_admin;
GRANT USAGE ON SCHEMA securitydb.myrules TO ROLE network_admin;
GRANT CREATE NETWORK RULE ON SCHEMA securitydb.myrules TO ROLE network_admin;
USE ROLE network_admin;

CREATE NETWORK RULE cloud_network TYPE = IPV4 VALUE_LIST = ('47.88.25.32/27');

-- Example 1081
SHOW PARAMETERS LIKE 'network_policy' IN ACCOUNT;

-- Example 1082
ALTER NETWORK POLICY my_policy SET BLOCKED_NETWORK_RULE_LIST = ( 'other_network' );

-- Example 1083
ALTER NETWORK POLICY my_policy ADD ALLOWED_NETWORK_RULE_LIST = ( 'new_rule' );

-- Example 1084
ALTER NETWORK POLICY my_policy REMOVE BLOCKED_NETWORK_RULE_LIST = ( 'other_network' );

-- Example 1085
ALTER ACCOUNT SET NETWORK_POLICY = my_policy;

-- Example 1086
ALTER USER joe SET NETWORK_POLICY = my_policy;

-- Example 1087
CREATE SECURITY INTEGRATION oauth_kp_int
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = custom
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://example.com'
  NETWORK_POLICY = mypolicy;

-- Example 1088
CREATE OR REPLACE VIEW v1 (vc1, vc2) AS
SELECT c1 as vc1,
       c2 as vc2
FROM t
WHERE t.c3 > 0
;

