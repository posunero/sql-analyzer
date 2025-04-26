-- Example 25837
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.CONSUMER.GET_SQL_JINJA(
$$
SELECT COUNT(*), IDENTIFIER({{ group_by_col }})
  FROM IDENTIFIER({{ my_table | sqlsafe }})
  INNER JOIN IDENTIFIER({{ source_table | sqlsafe }})
  ON IDENTIFIER({{ consumer_join_col }}) = IDENTIFIER({{ provider_join_col }})
  GROUP BY IDENTIFIER({{ group_by_col }});
$$,
object_construct(
'group_by_col', 'city',
'consumer_join_col', 'hashed_email',
'provider_join_col', 'hashed_email',
'my_table', 'mydb.mysch.t1',
'source_table', 'mydb.mysch.t2'));

-- Example 25838
SELECT COUNT(*), IDENTIFIER('city')
  FROM IDENTIFIER(mydb.mysch.t1)
  INNER JOIN IDENTIFIER(mydb.mysch.t2)
  ON IDENTIFIER('hashed_email') = IDENTIFIER('hashed_email')
  GROUP BY IDENTIFIER('city');

-- Example 25839
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.CONSUMER.GENERATE_PYTHON_REQUEST_TEMPLATE(
  'my_func',                         // SQL should use this name to call your function
  ['data variant', 'index integer'], // Arguments and types for the function
  ['pandas', 'numpy'],               // Standard libraries used
  [],                                // No custom libraries needed.
  'integer',                         // Return type integer
  'main',                            // Standard main handler
// Python implementation as UDF  
  $$
import pandas as pd
import numpy as np

def main(data, index):
    df = pd.DataFrame(data)  # you can do something with df but this is just an example
    return np.random.randint(1, 100)
    $$
);

-- Example 25840
BEGIN

-- First define the Python UDF
CREATE OR REPLACE FUNCTION CLEANROOM.my_func(data variant, index integer)
RETURNS integer
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
PACKAGES = ('pandas', 'numpy')

HANDLER = 'main'
AS '
import pandas as pd
import numpy as np

def main(data, index):
    df = pd.DataFrame(data)  # you can do something with df but this is just an example
    return np.random.randint(1, 100)
    ';
        

-- Then define and execute the SQL query
LET SQL_TEXT varchar := '<INSERT SQL TEMPLATE HERE>';

-- Execute the query and return the result
LET RES resultset := (EXECUTE IMMEDIATE :SQL_TEXT);
RETURN TABLE(RES);

END;

-- Example 25841
CALL samooha_by_snowflake_local_db.consumer.list_template_requests('dcr_cleanroom');

-- Example 25842
call samooha_by_snowflake_local_db.consumer.describe_cleanroom($cleanroom_name);

-- Example 25843
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 25844
call samooha_by_snowflake_local_db.consumer.view_join_policy($cleanroom_name);

-- Example 25845
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);

-- Example 25846
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 25847
CALL samooha_by_snowflake_local_db.library.is_consumer_run_enabled($cleanroom_name);

-- Example 25848
call samooha_by_snowflake_local_db.consumer.view_column_policy($cleanroom_name);

-- Example 25849
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 25850
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 25851
CALL samooha_by_snowflake_local_db.consumer.view_installed_cleanrooms();

-- Example 25852
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 25853
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 25854
call samooha_by_snowflake_local_db.consumer.set_cleanroom_ui_accessibility($cleanroom_name, 'HIDDEN');

-- Example 25855
CALL samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

-- Example 25856
CALL samooha_by_snowflake_local_db.library.disable_local_db_auto_upgrades();

-- Example 25857
if (x < 0):
  raise ValueError("x must be non-negative.");

-- Example 25858
SELECT *
   FROM samooha_by_snowflake_local_db.public.provider_activation_summary;

-- Example 25859
SELECT *
    FROM samooha_by_snowflake_local_db.public.consumer_direct_activation_summary;

-- Example 25860
SELECT c1, c2
FROM open_table
WHERE c1 = (SELECT x FROM protected_table WHERE y = open_table.c2);

-- Example 25861
SELECT
  SUM(SELECT COUNT(*) FROM open_table ot WHERE pt.id = ot.id)
FROM protected_table pt;

-- Example 25862
CREATE [ OR REPLACE ] AGGREGATION POLICY <name>
  AS () RETURNS AGGREGATION_CONSTRAINT -> <body>
  [ COMMENT = '<string_literal>' ];

-- Example 25863
CREATE AGGREGATION POLICY my_agg_policy
  AS () RETURNS AGGREGATION_CONSTRAINT -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5);

-- Example 25864
CREATE AGGREGATION POLICY my_agg_policy
  AS () RETURNS AGGREGATION_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ADMIN'
        THEN NO_AGGREGATION_CONSTRAINT()
      ELSE AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5)
    END;

-- Example 25865
ALTER AGGREGATION POLICY my_policy SET BODY -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE=>2);

-- Example 25866
ALTER { TABLE | VIEW } <name> SET AGGREGATION POLICY <policy_name> [ FORCE ]

-- Example 25867
ALTER TABLE t1 SET AGGREGATION POLICY my_agg_policy;

-- Example 25868
CREATE TABLE t1 WITH AGGREGATION POLICY my_agg_policy;

-- Example 25869
ALTER TABLE privacy SET AGGREGATION POLICY agg_policy_2 FORCE;

-- Example 25870
ALTER {TABLE | VIEW} <name> UNSET AGGREGATION POLICY

-- Example 25871
ALTER VIEW v1 UNSET AGGREGATION POLICY;

-- Example 25872
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.AGGREGATION_POLICIES
ORDER BY POLICY_NAME;

-- Example 25873
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.aggpolicy'));

-- Example 25874
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 25875
SELECT * FROM open_table ot WHERE ot.a > (SELECT SUM(id) FROM protected_table pt)

-- Example 25876
SELECT c, COUNT(*)
FROM agg_t, open_t
WHERE agg_t.c = open_t.c
GROUP BY agg_t.c;

-- Example 25877
+-----------------+
|  c   | COUNT(*) |
|------+----------|
|  2   |  2       |
|------+----------|
| null |  3       |
+-----------------+

-- Example 25878
SELECT a, COUNT(*)
FROM (
    SELECT a, b FROM protected_table1
    UNION ALL
    SELECT a, b FROM protected_table2
)
GROUP BY a;

-- Example 25879
USE ROLE USERADMIN;

CREATE ROLE AGG_POLICY_ADMIN;

-- Example 25880
GRANT USAGE ON DATABASE privacy TO ROLE agg_policy_admin;
GRANT USAGE ON SCHEMA privacy.agg_policies TO ROLE agg_policy_admin;

GRANT CREATE AGGREGATION POLICY
  ON SCHEMA privacy.agg_policies TO ROLE agg_policy_admin;

GRANT APPLY AGGREGATION POLICY ON ACCOUNT TO ROLE agg_policy_admin;

-- Example 25881
USE ROLE agg_policy_admin;
USE SCHEMA privacy.agg_policies;

CREATE AGGREGATION POLICY my_policy
  AS () RETURNS AGGREGATION_CONSTRAINT -> AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 3);

-- Example 25882
ALTER TABLE t1 SET AGGREGATION POLICY my_policy;

-- Example 25883
SELECT state, AVG(elevation) AS avg_elevation
FROM t1
GROUP BY state;

-- Example 25884
+----------+-----------------+
|  STATE   |  AVG_ELEVATION  |
|----------+-----------------+
|  NH      |  4435           |
|  NULL    |  3543           |
+----------+-----------------+

-- Example 25885
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE aggregation_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT CREATE AGGREGATION POLICY ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT APPLY ON AGGREGATION POLICY ON ACCOUNT TO ROLE aggregation_policy_admin;

-- Example 25886
USE ROLE securityadmin;
GRANT CREATE AGGREGATION POLICY ON SCHEMA mydb.schema TO ROLE aggregation_policy_admin;
GRANT APPLY ON AGGREGATION POLICY cost_center TO ROLE finance_role;

-- Example 25887
SELECT * FROM TABLE(SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.PRA_CONSUMPTION_UDTF(-5));

-- Example 25888
call samooha_by_snowflake_local_db.provider.add_consumers(
  $cleanroom_name, 'ACCOUNT_IN_OTHER_REGION', 'ORGNAME.ACCOUNTNAME');
call samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- **FAILURE**: Cannot enable LAF for this cleanroom.
--   Please enable LAF for Samooha on the account first through
--   the Samooha web application.

call samooha_by_snowflake_local_db.provider.remove_consumers(
  $cleanroom_name, 'ACCOUNT_IN_OTHER_REGION');
samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Success

-- Example 25889
USE ROLE ACCOUNTADMIN;
CALL system$accept_legal_terms('DATA_EXCHANGE_LISTING', 'GZSTZTP0KKO');
CREATE APPLICATION SAMOOHA_BY_SNOWFLAKE FROM LISTING 'GZSTZTP0KKO';

-- Example 25890
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.CHECK_MOUNT_STATUS();

-- Example 25891
USE ROLE USERADMIN;
CREATE USER <SERVICE-USER-USERNAME> PASSWORD='<SERVICE-USER-PASSWORD>'
FIRST_NAME='DCR' LAST_NAME='Service User'
EMAIL='<SERVICE-USER-EMAIL-ADDRESS>';

-- Example 25892
SELECT * FROM TABLE(SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.PRA_CONSUMPTION_UDTF(-5));

-- Example 25893
CREATE DATABASE shared_db1 FROM SHARE ab12345.share1;

CREATE DATABASE shared_db2 FROM SHARE ab12345.share2;

-- Example 25894
GRANT DATABASE ROLE shared_db1.dr1 TO ROLE PUBLIC;

-- Example 25895
GRANT IMPORTED PRIVILEGES ON DATABASE shared_db1 TO ROLE PUBLIC;

GRANT IMPORTED PRIVILEGES ON DATABASE shared_db2 TO ROLE PUBLIC;

-- Example 25896
GRANT USAGE ON WAREHOUSE testing_vw TO ROLE PUBLIC;

-- Example 25897
GRANT ALL ON WAREHOUSE testing_vs TO ROLE SYSADMIN;

-- Example 25898
ALTER USER ra_user1 RESET PASSWORD;

ALTER USER ra_user2 RESET PASSWORD;

-- Example 25899
GRANT IMPORTED PRIVILEGES ON DATA EXCHANGE <exchange_name> TO <role_name>;

-- Example 25900
USE ROLE ACCOUNTADMIN;

GRANT IMPORTED PRIVILEGES ON DATA EXCHANGE mydataexchange TO myrole;

-- Example 25901
USE ROLE ACCOUNTADMIN;

-- Example 25902
GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE myrole;

-- Example 25903
GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE myrole WITH GRANT OPTION;

