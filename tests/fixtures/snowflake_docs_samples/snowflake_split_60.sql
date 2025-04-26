-- Example 4003
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +
|                      transcript_text                       |     region      | agent_id | _GENERATED_EMBEDDINGS_MY_MODEL |
| ---------------------------------------------------------- | --------------- | -------- | ------------------------------ |
| 'My internet has been down since yesterday, can you help?' | 'North America' | 'AG1001' | [0.1, 0.2, 0.3, 0.4]           |
| 'I was overcharged for my last bill, need an explanation.' | 'Europe'        | 'AG1002' | [0.1, 0.2, 0.3, 0.4]           |
+ ---------------------------------------------------------- + --------------- + -------- + ------------------------------ +

-- Example 4004
COS( <real_expr> )

-- Example 4005
SELECT COS(0), COS(PI()/3), COS(RADIANS(90));

--------+-------------+------------------+
 COS(0) | COS(PI()/3) | COS(RADIANS(90)) |
--------+-------------+------------------+
 1      | 0.5         | 6.123233996e-17  |
--------+-------------+------------------+

-- Example 4006
COSH( <real_expr> )

-- Example 4007
SELECT COSH(1.5);

-------------+
  COSH(1.5)  |
-------------+
 2.352409615 |
-------------+

-- Example 4008
COT( <real_expr> )

-- Example 4009
SELECT COT(0), COT(PI()/3), COT(RADIANS(90));

--------+--------------+------------------+
 COT(0) | COT(PI()/3)  | COT(RADIANS(90)) |
--------+--------------+------------------+
 inf    | 0.5773502692 | 6.123233996e-17  |
--------+--------------+------------------+

-- Example 4010
SNOWFLAKE.CORTEX.COUNT_TOKENS( <model_name> , <input_text> )

SNOWFLAKE.CORTEX.COUNT_TOKENS( <function_name> , <input_text> )

-- Example 4011
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS( 'snowflake-arctic', 'what is a large language model?' );

-- Example 4012
+---+
| 6 |
+---+

-- Example 4013
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('SUMMARIZE', prompt) FROM mydb.myschema.mytable LIMIT 10;

-- Example 4014
+-----------+
| 1 |  1932 |
+-----------+
| 2 |  2379 |
+-----------+
| 3 |  2185 |
+-----------+
| 4 |  1195 |
+-----------+
| 5 |  2908 |
+-----------+
| 6 |  2601 |
+-----------+
| 7 |  2122 |
+-----------+
| 8 |  1720 |
+-----------+
| 9 |  2512 |
+-----------+
| 10 | 1510 |
+-----------+

-- Example 4015
SELECT SNOWFLAKE.CORTEX.COUNT_TOKENS('translate', 'Dies ist ein kurzer Text.');

-- Example 4016
+---+
| 9 |
+---+

-- Example 4017
CUME_DIST() OVER ( [ PARTITION BY <partition_expr> ] ORDER BY <order_expr>  [ ASC | DESC ] )

-- Example 4018
SELECT
    symbol,
    exchange,
    CUME_DIST() OVER (PARTITION BY exchange ORDER BY price) AS cume_dist
  FROM trades;

-- Example 4019
+------+--------+------------+
|symbol|exchange|CUME_DIST   |
+------+--------+------------+
|SPY   |C       |0.3333333333|
|AAPL  |C       |         1.0|
|AAPL  |C       |         1.0|
|YHOO  |N       |0.1666666667|
|QQQ   |N       |         0.5|
|QQQ   |N       |         0.5|
|SPY   |N       |0.8333333333|
|SPY   |N       |0.8333333333|
|AAPL  |N       |         1.0|
|YHOO  |Q       |0.3333333333|
|YHOO  |Q       |0.3333333333|
|MSFT  |Q       |0.6666666667|
|MSFT  |Q       |0.6666666667|
|QQQ   |Q       |         1.0|
|QQQ   |Q       |         1.0|
|YHOO  |P       |         0.2|
|MSFT  |P       |         0.6|
|MSFT  |P       |         0.6|
|SPY   |P       |         0.8|
|AAPL  |P       |         1.0|
+------+--------+------------+

-- Example 4020
SNOWFLAKE.DATA_PRIVACY.CUMULATIVE_PRIVACY_LOSSES( '<privacy_policy>' )

-- Example 4021
SELECT *
  FROM TABLE(SNOWFLAKE.DATA_PRIVACY.CUMULATIVE_PRIVACY_LOSSES(
    'my_policy_db.my_policy_schema.my_policy_privacy'));

-- Example 4022
CREATE PRIVACY POLICY  <name>
  AS ( ) RETURNS PRIVACY_BUDGET -> <body>

-- Example 4023
CREATE PRIVACY POLICY my_priv_policy
  AS ( ) RETURNS PRIVACY_BUDGET ->
  PRIVACY_BUDGET(BUDGET_NAME=> 'analysts');

-- Example 4024
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
    END;

-- Example 4025
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      WHEN CURRENT_ACCOUNT() = 'YE74187'
        THEN PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'external.' || CURRENT_ACCOUNT())
    END;

-- Example 4026
ALTER PRIVACY POLICY my_priv_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME => 'external_analysts');

-- Example 4027
ALTER { TABLE | [ MATERIALIZED ] VIEW } <name>
  ADD PRIVACY POLICY <policy_name>
  { NO ENTITY KEY | ENTITY KEY ( <column_name> ) }

-- Example 4028
ALTER TABLE t1 ADD PRIVACY POLICY my_priv_policy ENTITY KEY (email);

-- Example 4029
ALTER TABLE finance.accounting.customers
  DROP PRIVACY POLICY priv_policy_1,
  ADD PRIVACY POLICY priv_policy_2 ENTITY KEY (email);

-- Example 4030
ALTER { TABLE | [ MATERIALIZED ] VIEW } <name> DROP PRIVACY POLICY <policy_name>

-- Example 4031
ALTER TABLE finance.accounting.customers
  DROP PRIVACY POLICY my_priv_policy;

-- Example 4032
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.PRIVACY_POLICIES
  ORDER BY POLICY_NAME;

-- Example 4033
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.privpolicy'));

-- Example 4034
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

-- Example 4035
CURRENT_ACCOUNT()

-- Example 4036
SELECT CURRENT_ACCOUNT();

-- Example 4037
+-------------------+
| CURRENT_ACCOUNT() |
|-------------------|
| XY12345           |
+-------------------+

-- Example 4038
SELECT CURRENT_ORGANIZATION_NAME() || '-' || CURRENT_ACCOUNT_NAME();

-- Example 4039
[connections]
[connections.myconnection]
account = "myorganization-myaccount"

-- Example 4040
CURRENT_ACCOUNT_NAME()

-- Example 4041
SELECT CURRENT_ACCOUNT_NAME();

-- Example 4042
+-----------------------------+
| CURRENT_ACCOUNT_NAME()      |
|-----------------------------|
| my_account1                 |
+-----------------------------+

-- Example 4043
CURRENT_AVAILABLE_ROLES()

-- Example 4044
SELECT CURRENT_AVAILABLE_ROLES();

+----------------------------------------------------------+
| ROW | CURRENT_AVAILABLE_ROLES()                          |
+-----+----------------------------------------------------+
|  1  | [ "PUBLIC", "ANALYST", "DATA_ADMIN", "DATA_USER" ] |
+-----+----------------------------------------------------+

-- Example 4045
SELECT INDEX,VALUE,THIS FROM TABLE(FLATTEN(input => PARSE_JSON(CURRENT_AVAILABLE_ROLES())));

+-----+-------+------------------------+---------------------------+
| ROW | INDEX | VALUE                  | THIS                      |
+-----+-------+------------------------+---------------------------+
|   1 |     0 | "PUBLIC"               | [                         |
|     |       |                        |   "PUBLIC",               |
|     |       |                        |   "ANALYST",              |
|     |       |                        |   "DATA_ADMIN",           |
|     |       |                        |   "DATA_USER"             |
|     |       |                        | ]                         |
+-----+-------+------------------------+---------------------------+
|   2 |     1 | "ANALYST"              | [                         |
|     |       |                        |   "PUBLIC",               |
|     |       |                        |   "ANALYST",              |
|     |       |                        |   "DATA_ADMIN",           |
|     |       |                        |   "DATA_USER"             |
|     |       |                        | ]                         |
+-----+-------+------------------------+---------------------------+
|   3 |     2 | "DATA_ADMIN"           | [                         |
|     |       |                        |   "PUBLIC",               |
|     |       |                        |   "ANALYST",              |
|     |       |                        |   "DATA_ADMIN",           |
|     |       |                        |   "DATA_USER"             |
|     |       |                        | ]                         |
+-----+-------+------------------------+---------------------------+
|   4 |     3 | "DATA_USER"            | [                         |
|     |       |                        |   "PUBLIC",               |
|     |       |                        |   "ANALYST",              |
|     |       |                        |   "DATA_ADMIN",           |
|     |       |                        |   "DATA_USER"             |
|     |       |                        | ]                         |
+-----+-------+------------------------+---------------------------+

-- Example 4046
CURRENT_CLIENT()

-- Example 4047
SELECT CURRENT_CLIENT();

+------------------+
| CURRENT_CLIENT() |
|------------------|
| SnowSQL 1.1.18   |
+------------------+

-- Example 4048
SELECT CURRENT_CLIENT();

-- Example 4049
CURRENT_DATABASE()

-- Example 4050
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 4051
+---------------------+--------------------+------------------+
| CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|---------------------+--------------------+------------------|
| DEV_WAREHOUSE       | TEST_DATABASE      | UDF_TEST_SCHEMA  |
+---------------------+--------------------+------------------+

-- Example 4052
CURRENT_DATE()

CURRENT_DATE

-- Example 4053
SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP();

-- Example 4054
+----------------+----------------+-------------------------------+
| CURRENT_DATE() | CURRENT_TIME() | CURRENT_TIMESTAMP()           |
|----------------+----------------+-------------------------------|
| 2024-04-18     | 07:47:37       | 2024-04-18 07:47:37.084 -0700 |
+----------------+----------------+-------------------------------+

-- Example 4055
CURRENT_IP_ADDRESS()

-- Example 4056
select current_ip_address();

+----------------------+
| CURRENT_IP_ADDRESS() |
+----------------------+
| 192.0.2.255          |
+----------------------+

-- Example 4057
CURRENT_ORGANIZATION_NAME()

-- Example 4058
SELECT CURRENT_ORGANIZATION_NAME();

-- Example 4059
+-----------------------------+
| CURRENT_ORGANIZATION_NAME() |
|-----------------------------|
| bazco                       |
+-----------------------------+

-- Example 4060
CURRENT_REGION()

-- Example 4061
SELECT CURRENT_REGION();

-- Example 4062
+------------------+
| CURRENT_REGION() |
|------------------|
| AWS_US_WEST_2    |
+------------------+

-- Example 4063
SELECT CURRENT_REGION();

-- Example 4064
+----------------------+
| CURRENT_REGION()     |
|----------------------|
| PUBLIC.AWS_US_WEST_2 |
+----------------------+

-- Example 4065
CURRENT_ROLE()

-- Example 4066
SELECT CURRENT_ROLE();

-- Example 4067
+----------------+
| CURRENT_ROLE() |
|----------------|
| SYSADMIN       |
+----------------+

-- Example 4068
CURRENT_ROLE_TYPE()

-- Example 4069
SELECT CURRENT_ROLE_TYPE();

+---------------------+
| CURRENT_ROLE_TYPE() |
|---------------------|
| ROLE                |
+---------------------+

