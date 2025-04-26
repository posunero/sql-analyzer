-- Example 26440
user#> !set variable_substitution=true

user#> !define SnowAlpha=_ALPHA_

user#> !variables

+------------------+---------+
| Name             | Value   |
|------------------+---------|
| snowalpha        | _ALPHA_ |
+------------------+---------+

user#> !define SnowAlpha

user#> !variables

+------------------+-------+
| Name             | Value |
|------------------+-------|
| snowalpha        |       |
+------------------+-------+

user#> !define snowalpha=456

user#> select &snowalpha;

+-----+
| 456 |
|-----|
| 456 |
+-----+

-- Example 26441
create function mask_bits(...)
    ...
    as
    $$
    var masked = (x & y);
    ...
    $$;

-- Example 26442
!set variable_substitution=false;

-- Example 26443
ALTER USER <username> ADD DELEGATED AUTHORIZATION
    OF ROLE <role_name>
    TO SECURITY INTEGRATION <integration_name>;

-- Example 26444
ALTER USER jane.smith ADD DELEGATED AUTHORIZATION
    OF ROLE custom1
    TO SECURITY INTEGRATION myint;

-- Example 26445
SHOW DELEGATED AUTHORIZATIONS;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
+-------------------------------+-----------+-----------+-------------------+--------------------+
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT      | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 26446
SHOW DELEGATED AUTHORIZATIONS
    BY USER <username>;

-- Example 26447
SHOW DELEGATED AUTHORIZATIONS
    TO SECURITY INTEGRATION <integration_name>;

-- Example 26448
ALTER USER <username>
  REMOVE DELEGATED AUTHORIZATIONS
  FROM SECURITY INTEGRATION <integration_name>

-- Example 26449
ALTER USER <username>
  REMOVE DELEGATED AUTHORIZATION OF ROLE <role_name>
  FROM SECURITY INTEGRATION <integration_name>

-- Example 26450
ALTER USER jane.smith
  REMOVE DELEGATED AUTHORIZATION OF ROLE custom1
  FROM SECURITY INTEGRATION myint;

-- Example 26451
CREATE ROLE create_wh_role;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE create_wh_role;
GRANT ROLE create_wh_role TO ROLE SYSADMIN;

-- Example 26452
from snowflake.core.role import Role, Securable

my_role = Role(name="create_wh_role")
my_role_res = root.roles.create(my_role)

my_role_res.grant_privileges(
  privileges=["CREATE WAREHOUSE"], securable_type="ACCOUNT"
)

root.roles['SYSADMIN'].grant_role(role_type="ROLE", role=Securable(name='create_wh_role'))

-- Example 26453
CREATE ROLE manage_wh_role;
GRANT MANAGE WAREHOUSES ON ACCOUNT TO ROLE manage_wh_role;
GRANT ROLE manage_wh_role TO ROLE SYSADMIN;

-- Example 26454
from snowflake.core.role import Role, Securable

my_role = Role(name="manage_wh_role")
my_role_res = root.roles.create(my_role)

my_role_res.grant_privileges(
  privileges=["MANAGE WAREHOUSES"], securable_type="ACCOUNT"
)

root.roles['SYSADMIN'].grant_role(role_type="ROLE", role=Securable(name='manage_wh_role'))

-- Example 26455
USE ROLE create_wh_role;
CREATE OR REPLACE WAREHOUSE test_wh
    WITH WAREHOUSE_SIZE= XSMALL;

-- Example 26456
from snowflake.core import CreateMode
from snowflake.core.warehouse import Warehouse

root.session.use_role("create_wh_role")

my_wh = Warehouse(
  name="test_wh",
  warehouse_size="XSMALL"
)
root.warehouses.create(my_wh, mode=CreateMode.or_replace)

-- Example 26457
USE ROLE manage_wh_role;

-- Example 26458
root.session.use_role("manage_wh_role")

-- Example 26459
ALTER WAREHOUSE test_wh SUSPEND;
ALTER WAREHOUSE test_wh RESUME;

-- Example 26460
my_wh_res = root.warehouses["test_wh"]
my_wh_res.suspend()
my_wh_res.resume()

-- Example 26461
ALTER WAREHOUSE test_wh SET WAREHOUSE_SIZE = SMALL;

-- Example 26462
my_wh = root.warehouses["test_wh"].fetch()
my_wh.warehouse_size = "SMALL"
root.warehouses["test_wh"].create_or_alter(my_wh)

-- Example 26463
DESC WAREHOUSE test_wh;

-- Example 26464
my_wh = root.warehouses["test_wh"].fetch()
print(my_wh.to_dict())

-- Example 26465
SELECT account_name,
  ROUND(SUM(usage_in_currency), 2) as usage_in_currency
FROM snowflake.organization_usage.usage_in_currency_daily
WHERE usage_date > DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 2 desc;

-- Example 26466
USE ROLE tag_admin;

CREATE DATABASE cost_management;
CREATE SCHEMA tags;

-- Example 26467
CREATE TAG cost_center
  ALLOWED_VALUES 'finance', 'marketing', 'engineering', 'product';

-- Example 26468
CREATE REPLICATION GROUP cost_management_repl_group
  OBJECT_TYPES = DATABASES
  ALLOWED_DATABASES = cost_management
  ALLOWED_ACCOUNTS = my_org.my_account_1, my_org.my_account_2
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 26469
CREATE REPLICATION GROUP cost_management_repl_group
  AS REPLICA OF my_org.my_org_account.cost_management_repl_group;

ALTER REPLICATION GROUP cost_management_repl_group REFRESH;

-- Example 26470
USE ROLE tag_admin;

ALTER WAREHOUSE warehouse1 SET TAG cost_management.tags.cost_center='SALES';
ALTER WAREHOUSE warehouse2 SET TAG cost_management.tags.cost_center='SALES';
ALTER WAREHOUSE warehouse3 SET TAG cost_management.tags.cost_center='FINANCE';

ALTER USER finance_user SET TAG cost_management.tags.cost_center='FINANCE';
ALTER USER sales_user SET TAG cost_management.tags.cost_center='SALES';

-- Example 26471
SELECT
    TAG_REFERENCES.tag_name,
    COALESCE(TAG_REFERENCES.tag_value, 'untagged') AS tag_value,
    SUM(WAREHOUSE_METERING_HISTORY.credits_used_compute) AS total_credits
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
        ON WAREHOUSE_METERING_HISTORY.warehouse_id = TAG_REFERENCES.object_id
          AND TAG_REFERENCES.domain = 'WAREHOUSE'
  WHERE
    WAREHOUSE_METERING_HISTORY.start_time >= DATE_TRUNC('MONTH', DATEADD(MONTH, -1, CURRENT_DATE))
      AND WAREHOUSE_METERING_HISTORY.start_time < DATE_TRUNC('MONTH',  CURRENT_DATE)
  GROUP BY TAG_REFERENCES.tag_name, COALESCE(TAG_REFERENCES.tag_value, 'untagged')
  ORDER BY total_credits DESC;

-- Example 26472
+-------------+-------------+-----------------+
| TAG_NAME    | TAG_VALUE   |   TOTAL_CREDITS |
|-------------+-------------+-----------------|
| NULL        | untagged    |    20.360277159 |
| COST_CENTER | Sales       |    17.173333333 |
| COST_CENTER | Finance     |      8.14444444 |
+-------------+-------------+-----------------+

-- Example 26473
SELECT
    TAG_REFERENCES.tag_name,
    COALESCE(TAG_REFERENCES.tag_value, 'untagged') AS tag_value,
    SUM(WAREHOUSE_METERING_HISTORY.credits_used_compute) AS total_credits
  FROM
    SNOWFLAKE.ORGANIZATION_USAGE.WAREHOUSE_METERING_HISTORY
      LEFT JOIN SNOWFLAKE.ORGANIZATION_USAGE.TAG_REFERENCES
        ON WAREHOUSE_METERING_HISTORY.warehouse_id = TAG_REFERENCES.object_id
          AND TAG_REFERENCES.domain = 'WAREHOUSE'
          AND tag_database = 'COST_MANAGEMENT' AND tag_schema = 'TAGS'
  WHERE
    WAREHOUSE_METERING_HISTORY.start_time >= DATE_TRUNC('MONTH', DATEADD(MONTH, -1, CURRENT_DATE))
      AND WAREHOUSE_METERING_HISTORY.start_time < DATE_TRUNC('MONTH',  CURRENT_DATE)
  GROUP BY TAG_REFERENCES.tag_name, COALESCE(TAG_REFERENCES.tag_value, 'untagged')
  ORDER BY total_credits DESC;

-- Example 26474
WITH
  wh_bill AS (
    SELECT SUM(credits_used_compute) AS compute_credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
        AND start_time < CURRENT_DATE
  ),
  user_credits AS (
    SELECT user_name, SUM(credits_attributed_compute) AS credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
        AND start_time < CURRENT_DATE
      GROUP BY user_name
  ),
  total_credit AS (
    SELECT SUM(credits) AS sum_all_credits
    FROM user_credits
  )
SELECT
    u.user_name,
    u.credits / t.sum_all_credits * w.compute_credits AS attributed_credits
  FROM user_credits u, total_credit t, wh_bill w
  ORDER BY attributed_credits DESC;

-- Example 26475
+-----------+--------------------+
| USER_NAME | ATTRIBUTED_CREDITS |
|-----------+--------------------+
| FINUSER   | 6.603575468        |
| SALESUSER | 4.321378049        |
| ENGUSER   | 0.6217131392       |
|-----------+--------------------+

-- Example 26476
WITH joined_data AS (
  SELECT
      tr.tag_name,
      tr.tag_value,
      qah.credits_attributed_compute,
      qah.start_time
    FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES tr
      JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY qah
        ON tr.domain = 'USER' AND tr.object_name = qah.user_name
)
SELECT
    tag_name,
    tag_value,
    SUM(credits_attributed_compute) AS total_credits
  FROM joined_data
  WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY tag_name, tag_value
  ORDER BY tag_name, tag_value;

-- Example 26477
+-------------+-------------+-----------------+
| TAG_NAME    | TAG_VALUE   |   TOTAL_CREDITS |
|-------------+-------------+-----------------|
| COST_CENTER | engineering |   0.02493688426 |
| COST_CENTER | finance     |    0.2281084988 |
| COST_CENTER | marketing   |    0.3686840545 |
|-------------+-------------+-----------------|

-- Example 26478
SELECT user_name, SUM(credits_attributed_compute) AS credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE
    start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY user_name;

-- Example 26479
+-----------+--------------------+
| USER_NAME | ATTRIBUTED_CREDITS |
|-----------+--------------------|
| JSMITH    |       17.173333333 |
| MJONES    |         8.14444444 |
| SYSTEM    |         5.33985393 |
+-----------+--------------------+

-- Example 26480
SELECT qah.user_name, SUM(qah.credits_attributed_compute) as total_credits
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY qah
    LEFT JOIN snowflake.account_usage.tag_references tr
    ON qah.user_name = tr.object_name AND tr.DOMAIN = 'USER'
  WHERE
    start_time >= dateadd(month, -1, current_date)
    AND qah.user_name IS NULL OR tr.object_name IS NULL
  GROUP BY qah.user_name
  ORDER BY total_credits DESC;

-- Example 26481
+------------+---------------+
| USER_NAME  | TOTAL_CREDITS |
|------------+---------------|
| RSMITH     |  0.1830555556 |
+------------+---------------+

-- Example 26482
ALTER SESSION SET QUERY_TAG = 'COST_CENTER=finance';

-- Example 26483
SELECT
    query_tag,
    SUM(credits_attributed_compute) AS compute_credits,
    SUM(credits_used_query_acceleration) AS qas
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE query_tag = 'COST_CENTER=finance'
  GROUP BY query_tag;

-- Example 26484
+---------------------+-----------------+------+
| QUERY_TAG           | COMPUTE_CREDITS | QAS  |
|---------------------+-----------------|------|
| COST_CENTER=finance |      0.00576115 | null |
+---------------------+-----------------+------+

-- Example 26485
SELECT
    COALESCE(NULLIF(query_tag, ''), 'untagged') AS tag,
    SUM(credits_attributed_compute) AS compute_credits,
    SUM(credits_used_query_acceleration) AS qas
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
  GROUP BY tag
  ORDER BY compute_credits DESC;

-- Example 26486
+-------------------------+-----------------+------+
| TAG                     | COMPUTE_CREDITS | QAS  |
|-------------------------+-----------------+------+
| untagged                | 3.623173449     | null |
| COST_CENTER=engineering | 0.531431948     | null |
|-------------------------+-----------------+------+

-- Example 26487
WITH
  wh_bill AS (
    SELECT SUM(credits_used_compute) AS compute_credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
      AND start_time < CURRENT_DATE
  ),
  tag_credits AS (
    SELECT
        COALESCE(NULLIF(query_tag, ''), 'untagged') AS tag,
        SUM(credits_attributed_compute) AS credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
      WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
      GROUP BY tag
  ),
  total_credit AS (
    SELECT SUM(credits) AS sum_all_credits
      FROM tag_credits
  )
SELECT
    tc.tag,
    tc.credits / t.sum_all_credits * w.compute_credits AS attributed_credits
  FROM tag_credits tc, total_credit t, wh_bill w
  ORDER BY attributed_credits DESC;

-- Example 26488
+-------------------------+--------------------+
| TAG                     | ATTRIBUTED_CREDITS |
+-------------------------+--------------------|
| untagged                |        9.020031304 |
| COST_CENTER=finance     |        1.027742521 |
| COST_CENTER=engineering |        1.018755812 |
| COST_CENTER=marketing   |       0.4801370376 |
+-------------------------+--------------------+

-- Example 26489
SELECT query_parameterized_hash,
       COUNT(*) AS query_count,
       SUM(credits_attributed_compute) AS total_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
  AND start_time < CURRENT_DATE
  GROUP BY query_parameterized_hash
  ORDER BY total_credits DESC
  LIMIT 20;

-- Example 26490
SET query_id = '<query_id>';

SELECT query_id,
       parent_query_id,
       root_query_id,
       direct_objects_accessed
  FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
  WHERE query_id = $query_id;

-- Example 26491
SET query_id = '<root_query_id>';

SELECT SUM(credits_attributed_compute) AS total_attributed_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE (root_query_id = $query_id OR query_id = $query_id);

-- Example 26492
CREATE [ OR REPLACE ] EXTERNAL ACCESS INTEGRATION <name>
  ALLOWED_NETWORK_RULES = ( <rule_name_1> [, <rule_name_2>, ... ] )
  [ ALLOWED_API_AUTHENTICATION_INTEGRATIONS = ( { <integration_name_1> [, <integration_name_2>, ... ] | none } ) ]
  [ ALLOWED_AUTHENTICATION_SECRETS = ( { <secret_name_1> [, <secret_name_2>, ... ] | all | none } ) ]
  ENABLED = { TRUE | FALSE }
  [ COMMENT = '<string_literal>' ]

-- Example 26493
CREATE OR REPLACE SECRET oauth_token
  TYPE = OAUTH2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 26494
USE ROLE USERADMIN;
CREATE OR REPLACE ROLE developer;

-- Example 26495
USE ROLE SECURITYADMIN;
GRANT READ ON SECRET oauth_token TO ROLE developer;

-- Example 26496
USE ROLE SYSADMIN;
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 26497
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = true;

-- Example 26498
GRANT USAGE ON INTEGRATION google_apis_access_integration TO ROLE developer;

-- Example 26499
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

-- Example 26500
GRANT USAGE ON FUNCTION google_translate_python(string, string) TO ROLE user;

-- Example 26501
USE ROLE user;
SELECT google_translate_python('Happy Thursday!', 'zh-CN');

-- Example 26502
-------------------------------------------------------
| GOOGLE_TRANSLATE_PYTHON('HAPPY THURSDAY!', 'ZH-CN') |
-------------------------------------------------------
| 快乐星期四！                                          |
-------------------------------------------------------

-- Example 26503
VALUE_LIST = ('example.com:80')

-- Example 26504
CREATE OR REPLACE NETWORK RULE google_apis_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('translation.googleapis.com');

-- Example 26505
CREATE OR REPLACE SECRET oauth_token
  TYPE = OAUTH2
  API_AUTHENTICATION = google_translate_oauth
  OAUTH_REFRESH_TOKEN = 'my-refresh-token';

-- Example 26506
CREATE OR REPLACE SECRET bp_maps_api
  TYPE = GENERIC_STRING
  SECRET_STRING = 'replace-with-your-api-key';

