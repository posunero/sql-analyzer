-- Example 23425
select * from mv1 where column_1 = Y;

-- Example 23426
create materialized view mv2 as
  select * from table1 where column_1 = X;

-- Example 23427
select column_1, column_2 from table1 where column_1 = X AND column_2 = Y;

-- Example 23428
select * from mv2 where column_2 = Y;

-- Example 23429
create materialized view mv4 as
  select column_1, column_2, sum(column_3) from table1 group by column_1, column_2;

-- Example 23430
select column_1, sum(column_3) from table1 group by column_1;

-- Example 23431
select column_1, sum(column_3) from mv4 group by column_1;

-- Example 23432
CREATE MATERIALIZED VIEW mv AS
  SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;

-- Example 23433
CREATE MATERIALIZED VIEW mv AS
  SELECT 100 * sum_c1 AS sigma FROM (
    SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;
  ) WHERE sum_c1 > 0;

-- Example 23434
CREATE MATERIALIZED VIEW mv AS
  SELECT SUM(c1) AS sum_c1, c2 FROM t GROUP BY c2;

CREATE VIEW view_on_mv AS
  SELECT 100 * sum_c1 AS sigma FROM mv WHERE sum_c1 > 0;

-- Example 23435
OVER ( [ PARTITION BY <expr1> ] [ ORDER BY <expr2> ] )

-- Example 23436
create materialized view bad_example (ts1) as
    select to_timestamp(n) from t1;

-- Example 23437
create materialized view good_example (ts1) as
    select to_timestamp(n)::TIMESTAMP_NTZ from t1;

-- Example 23438
CREATE OR REPLACE MATERIALIZED VIEW mv1 AS
  SELECT My_ResourceIntensive_Function(binary_col) FROM table1;

SELECT * FROM mv1;

-- Example 23439
Failure during expansion of view 'MY_MV':
  SQL compilation error: Materialized View MY_MV is invalid.
  Invalidation reason: Division by zero

-- Example 23440
ALTER MATERIALIZED VIEW <name> SUSPEND

-- Example 23441
ALTER MATERIALIZED VIEW <name> RESUME

-- Example 23442
CREATE OR REPLACE MATERIALIZED VIEW <view_name> ... COPY GRANTS ...

-- Example 23443
SELECT * FROM TABLE(INFORMATION_SCHEMA.MATERIALIZED_VIEW_REFRESH_HISTORY());

-- Example 23444
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.materialized_view_refresh_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 23445
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.materialized_view_refresh_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 23446
CREATE TABLE inventory (product_ID INTEGER, wholesale_price FLOAT,
  description VARCHAR);
    
CREATE OR REPLACE MATERIALIZED VIEW mv1 AS
  SELECT product_ID, wholesale_price FROM inventory;

INSERT INTO inventory (product_ID, wholesale_price, description) VALUES 
    (1, 1.00, 'cog');

-- Example 23447
SELECT product_ID, wholesale_price FROM mv1;
+------------+-----------------+
| PRODUCT_ID | WHOLESALE_PRICE |
|------------+-----------------|
|          1 |               1 |
+------------+-----------------+

-- Example 23448
CREATE TABLE sales (product_ID INTEGER, quantity INTEGER, price FLOAT);

INSERT INTO sales (product_ID, quantity, price) VALUES 
   (1,  1, 1.99);

CREATE or replace VIEW profits AS
  SELECT m.product_ID, SUM(IFNULL(s.quantity, 0)) AS quantity,
      SUM(IFNULL(quantity * (s.price - m.wholesale_price), 0)) AS profit
    FROM mv1 AS m LEFT OUTER JOIN sales AS s ON s.product_ID = m.product_ID
    GROUP BY m.product_ID;

-- Example 23449
SELECT * FROM profits;
+------------+----------+--------+
| PRODUCT_ID | QUANTITY | PROFIT |
|------------+----------+--------|
|          1 |        1 |   0.99 |
+------------+----------+--------+

-- Example 23450
ALTER MATERIALIZED VIEW mv1 SUSPEND;
    
INSERT INTO inventory (product_ID, wholesale_price, description) VALUES 
    (2, 2.00, 'sprocket');

INSERT INTO sales (product_ID, quantity, price) VALUES 
   (2, 10, 2.99),
   (2,  1, 2.99);

-- Example 23451
SELECT * FROM profits ORDER BY product_ID;

-- Example 23452
002037 (42601): SQL compilation error:
Failure during expansion of view 'PROFITS': SQL compilation error:
Failure during expansion of view 'MV1': SQL compilation error: Materialized View MV1 is invalid.

-- Example 23453
ALTER MATERIALIZED VIEW mv1 RESUME;

-- Example 23454
SELECT * FROM profits ORDER BY product_ID;
+------------+----------+--------+
| PRODUCT_ID | QUANTITY | PROFIT |
|------------+----------+--------|
|          1 |        1 |   0.99 |
|          2 |       11 |  10.89 |
+------------+----------+--------+

-- Example 23455
CREATE TABLE pipeline_segments (
    segment_ID BIGINT,
    material VARCHAR, -- e.g. copper, cast iron, PVC.
    installation_year DATE,  -- older pipes are more likely to be corroded.
    rated_pressure FLOAT  -- maximum recommended pressure at installation time.
    );
    
INSERT INTO pipeline_segments 
    (segment_ID, material, installation_year, rated_pressure)
  VALUES
    (1, 'PVC', '1994-01-01'::DATE, 60),
    (2, 'cast iron', '1950-01-01'::DATE, 120)
    ;

CREATE TABLE pipeline_pressures (
    segment_ID BIGINT,
    pressure_psi FLOAT,  -- pressure in Pounds per Square Inch
    measurement_timestamp TIMESTAMP
    );
INSERT INTO pipeline_pressures 
   (segment_ID, pressure_psi, measurement_timestamp) 
  VALUES
    (2, 10, '2018-09-01 00:01:00'),
    (2, 95, '2018-09-01 00:02:00')
    ;

-- Example 23456
CREATE MATERIALIZED VIEW vulnerable_pipes 
  (segment_ID, installation_year, rated_pressure) 
  AS
    SELECT segment_ID, installation_year, rated_pressure
        FROM pipeline_segments 
        WHERE material = 'cast iron' AND installation_year < '1980'::DATE;

-- Example 23457
ALTER MATERIALIZED VIEW vulnerable_pipes CLUSTER BY (installation_year);

-- Example 23458
CREATE VIEW high_risk AS
    SELECT seg.segment_ID, installation_year, measurement_timestamp::DATE AS measurement_date, 
         DATEDIFF('YEAR', installation_year::DATE, measurement_timestamp::DATE) AS age, 
         rated_pressure - age AS safe_pressure, pressure_psi AS actual_pressure
       FROM vulnerable_pipes AS seg INNER JOIN pipeline_pressures AS psi 
           ON psi.segment_ID = seg.segment_ID
       WHERE pressure_psi > safe_pressure
       ;

-- Example 23459
SELECT * FROM high_risk;
+------------+-------------------+------------------+-----+---------------+-----------------+
| SEGMENT_ID | INSTALLATION_YEAR | MEASUREMENT_DATE | AGE | SAFE_PRESSURE | ACTUAL_PRESSURE |
|------------+-------------------+------------------+-----+---------------+-----------------|
|          2 | 1950-01-01        | 2018-09-01       |  68 |            52 |              95 |
+------------+-------------------+------------------+-----+---------------+-----------------+

-- Example 23460
create or replace table db1.schema1.table1(c1 int);
create or replace share sh1;
grant usage on database db1 to share sh1;
alter share sh1 add accounts = account2;
grant usage on schema db1.schema1 to share sh1;
grant select on table db1.schema1.table1 to share sh1;

-- Example 23461
create or replace database dbshared from share account1.sh1;
create or replace materialized view mv1 as select * from dbshared.schema1.table1 where c1 >= 50;

-- Example 23462
Failure during expansion of view 'MY_MV':
  SQL compilation error: Materialized View MY_MV is invalid.
  Invalidation reason: Division by zero

-- Example 23463
"appRoles":[
    {
        "allowedMemberTypes": [ "Application" ],
        "description": "Account Administrator.",
        "displayName": "Account Admin",
        "id": "3ea51f40-2ad7-4e79-aa18-12c45156dc6a",
        "isEnabled": true,
        "lang": null,
        "origin": "Application",
        "value": "session:role:analyst"
    }
]

-- Example 23464
create security integration external_oauth_azure_1
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = '<AZURE_AD_JWS_KEY_ENDPOINT>'
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23465
create security integration external_oauth_azure_2
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = '<AZURE_AD_JWS_KEY_ENDPOINT>'
    external_oauth_audience_list = ('<SNOWFLAKE_APPLICATION_ID_URI>')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23466
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23467
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23468
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23469
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --data-urlencode "client_id=<OAUTH_CLIENT_ID>" \
  --data-urlencode "client_secret=<OAUTH_CLIENT_SECRET>" \
  --data-urlencode "username=<AZURE_AD_USER>" \
  --data-urlencode "password=<AZURE_AD_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=<AZURE_APP_URI+AZURE_APP_SCOPE>" \
  '<AZURE_AD_OAUTH_TOKEN_ENDPOINT>'

-- Example 23470
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23471
create security integration external_oauth_okta_2
    type = external_oauth
    enabled = true
    external_oauth_type = okta
    external_oauth_issuer = '<OKTA_ISSUER>'
    external_oauth_jws_keys_url = '<OKTA_JWS_KEY_ENDPOINT>'
    external_oauth_audience_list = ('<snowflake_account_url')
    external_oauth_token_user_mapping_claim = 'sub'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23472
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23473
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23474
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23475
curl -X POST -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
  --user <OAUTH_CLIENT_ID>:<OAUTH_CLIENT_SECRET> \
  --data-urlencode "username=<OKTA_USER_USERNAME>" \
  --data-urlencode "password=<OKTA_USER_PASSWORD>" \
  --data-urlencode "grant_type=password" \
  --data-urlencode "scope=session:role:analyst" \
  <OKTA_OAUTH_TOKEN_ENDPOINT>

-- Example 23476
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23477
create or replace security integration external_oauth_pf_1
    type = external_oauth
    enabled = true
    external_oauth_type = ping_federate
    external_oauth_rsa_public_key = '<BASE64_PUBLIC_KEY>'
    external_oauth_issuer = '<unique_id>'
    external_oauth_token_user_mapping_claim = 'username'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23478
create security integration external_oauth_pf_2
    type = external_oauth
    enabled=true
    external_oauth_type = ping_federate
    external_oauth_issuer = '<ISSUER>'
    external_oauth_rsa_public_key = '<BASE64_PUBLIC_KEY>'
    external_oauth_audience_list = ('<snowflake_account_url>')
    external_oauth_token_user_mapping_claim = 'username'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23479
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

-- Example 23480
revoke USE_ANY_ROLE on integration external_oauth_1 from role1;

-- Example 23481
create security integration external_oauth_1
    type = external_oauth
    enabled = true
    external_oauth_any_role_mode = 'ENABLE'
    ...

-- Example 23482
curl -k 'https://10.211.55.4:9031/as/token.oauth2' \
  --data-urlencode 'client_id=<CLIENT_ID>&grant_type=password&username=<USERNAME>&password=<PASSWORD>&client_secret=<CLIENT_SECRET>&scope=session:role:analyst'

-- Example 23483
ctx = snowflake.connector.connect(
   user="<username>",
   host="<hostname>",
   account="<account_identifier>",
   authenticator="oauth",
   token="<external_oauth_access_token>",
   warehouse="test_warehouse",
   database="test_db",
   schema="test_schema"
)

-- Example 23484
create security integration powerbi
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
    external_oauth_audience_list = ('https://analysis.windows.net/powerbi/connector/Snowflake', 'https://analysis.windows.net/powerbi/connector/snowflake')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name'

-- Example 23485
create security integration powerbi_mag
    type = external_oauth
    enabled = true
    external_oauth_type = azure
    external_oauth_issuer = '<AZURE_AD_ISSUER>'
    external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
    external_oauth_audience_list = ('https://analysis.usgovcloudapi.net/powerbi/connector/Snowflake', 'https://analysis.usgovcloudapi.net/powerbi/connector/snowflake')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name'

-- Example 23486
create security integration powerbi
    type = external_oauth
    ...
    external_oauth_snowflake_user_mapping_attribute = 'email_address';

-- Example 23487
create security integration powerbi
  type = external_oauth
  enabled = true
  external_oauth_type = azure
  external_oauth_issuer = '<AZURE_AD_ISSUER>'
  external_oauth_jws_keys_url = 'https://login.windows.net/common/discovery/keys'
  external_oauth_audience_list = ('https://analysis.windows.net/powerbi/connector/Snowflake', 'https://analysis.windows.net/powerbi/connector/snowflake')
  external_oauth_token_user_mapping_claim = 'unique_name'
  external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23488
use role accountadmin;
select *
from table(information_schema.login_history(dateadd('hours',-1,current_timestamp()),current_timestamp()))
order by event_timestamp;

-- Example 23489
{
  "aud": "<audience_url>",
  "iat": 1576705500,
  "exp": 1576709100,
  "iss": "<issuer_url>",
  "scp": [
    "session:role:analyst"
  ]
}

-- Example 23490
create security integration external_oauth_custom
    type = external_oauth
    enabled = true
    external_oauth_type = custom
    external_oauth_issuer = '<authorization_server_url>'
    external_oauth_rsa_public_key = '<public_key_value>'
    external_oauth_audience_list = ('<audience_url_1>', '<audience_url_2>')
    external_oauth_token_user_mapping_claim = 'upn'
    external_oauth_snowflake_user_mapping_attribute = 'login_name';

-- Example 23491
grant USE_ANY_ROLE on integration external_oauth_1 to role1;

