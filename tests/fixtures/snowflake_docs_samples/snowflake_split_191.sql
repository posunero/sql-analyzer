-- Example 12777
SELECT * FROM TABLE(mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(POLICY_NAME=>'my_agg_policy'));

-- Example 12778
DROP AGGREGATION POLICY my_aggpolicy;

-- Example 12779
SHOW AGGREGATION POLICIES  [ LIKE '<pattern>' ]
                           [ IN
                               {
                                 ACCOUNT                  |

                                 DATABASE [ <database_name> ] |

                                 SCHEMA [ <schema_name> ]     |
                               }
                           ]

-- Example 12780
SHOW AGGREGATION POLICIES;

-- Example 12781
SELECT ...
FROM ...
    UNPIVOT [ { INCLUDE | EXCLUDE } NULLS ]
      ( <value_column>
        FOR <name_column> IN ( <column_list> ) )

[ ... ]

-- Example 12782
CREATE OR REPLACE TABLE monthly_sales(
  empid INT,
  dept TEXT,
  jan INT,
  feb INT,
  mar INT,
  apr INT);

INSERT INTO monthly_sales VALUES
  (1, 'electronics', 100, 200, 300, 100),
  (2, 'clothes', 100, 300, 150, 200),
  (3, 'cars', 200, 400, 100, 50),
  (4, 'appliances', 100, NULL, 100, 50);

SELECT * FROM monthly_sales;

-- Example 12783
+-------+-------------+-----+------+------+-----+
| EMPID | DEPT        | JAN | FEB  | MAR  | APR |
|-------+-------------+-----+------+------+-----|
|     1 | electronics | 100 | 200  | 300  | 100 |
|     2 | clothes     | 100 | 300  | 150  | 200 |
|     3 | cars        | 200 | 400  | 100  |  50 |
|     4 | appliances  | 100 | NULL | 100  |  50 |
+-------+-------------+-----+------+------+-----+

-- Example 12784
SELECT *
  FROM monthly_sales
    UNPIVOT (sales FOR month IN (jan, feb, mar, apr))
  ORDER BY empid;

-- Example 12785
+-------+-------------+-------+-------+
| EMPID | DEPT        | MONTH | SALES |
|-------+-------------+-------+-------|
|     1 | electronics | JAN   |   100 |
|     1 | electronics | FEB   |   200 |
|     1 | electronics | MAR   |   300 |
|     1 | electronics | APR   |   100 |
|     2 | clothes     | JAN   |   100 |
|     2 | clothes     | FEB   |   300 |
|     2 | clothes     | MAR   |   150 |
|     2 | clothes     | APR   |   200 |
|     3 | cars        | JAN   |   200 |
|     3 | cars        | FEB   |   400 |
|     3 | cars        | MAR   |   100 |
|     3 | cars        | APR   |    50 |
|     4 | appliances  | JAN   |   100 |
|     4 | appliances  | MAR   |   100 |
|     4 | appliances  | APR   |    50 |
+-------+-------------+-------+-------+

-- Example 12786
SELECT *
  FROM monthly_sales
    UNPIVOT INCLUDE NULLS (sales FOR month IN (jan, feb, mar, apr))
  ORDER BY empid;

-- Example 12787
+-------+-------------+-------+-------+
| EMPID | DEPT        | MONTH | SALES |
|-------+-------------+-------+-------|
|     1 | electronics | JAN   |   100 |
|     1 | electronics | FEB   |   200 |
|     1 | electronics | MAR   |   300 |
|     1 | electronics | APR   |   100 |
|     2 | clothes     | JAN   |   100 |
|     2 | clothes     | FEB   |   300 |
|     2 | clothes     | MAR   |   150 |
|     2 | clothes     | APR   |   200 |
|     3 | cars        | JAN   |   200 |
|     3 | cars        | FEB   |   400 |
|     3 | cars        | MAR   |   100 |
|     3 | cars        | APR   |    50 |
|     4 | appliances  | JAN   |   100 |
|     4 | appliances  | FEB   |  NULL |
|     4 | appliances  | MAR   |   100 |
|     4 | appliances  | APR   |    50 |
+-------+-------------+-------+-------+

-- Example 12788
SELECT dept, month, sales
  FROM monthly_sales
    UNPIVOT INCLUDE NULLS (sales FOR month IN (jan, feb, mar, apr))
  ORDER BY dept;

-- Example 12789
+-------------+-------+-------+
| DEPT        | MONTH | SALES |
|-------------+-------+-------|
| appliances  | JAN   |   100 |
| appliances  | FEB   |  NULL |
| appliances  | MAR   |   100 |
| appliances  | APR   |    50 |
| cars        | JAN   |   200 |
| cars        | FEB   |   400 |
| cars        | MAR   |   100 |
| cars        | APR   |    50 |
| clothes     | JAN   |   100 |
| clothes     | FEB   |   300 |
| clothes     | MAR   |   150 |
| clothes     | APR   |   200 |
| electronics | JAN   |   100 |
| electronics | FEB   |   200 |
| electronics | MAR   |   300 |
| electronics | APR   |   100 |
+-------------+-------+-------+

-- Example 12790
CREATE OR REPLACE FUNCTION echo_varchar(x VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVA
  CALLED ON NULL INPUT
  HANDLER = 'TestFunc.echoVarchar'
  TARGET_PATH = '@~/testfunc.jar'
  AS
  'class TestFunc {
    public static String echoVarchar(String x) {
      return x;
    }
  }';

-- Example 12791
-- Create the UDF.
CREATE OR REPLACE FUNCTION my_array_reverse(a ARRAY)
  RETURNS ARRAY
  LANGUAGE JAVASCRIPT
AS
$$
  return A.reverse();
$$
;

-- Example 12792
-- flatten all arrays and values of objects into a single array
-- order of objects may be lost
CREATE OR REPLACE FUNCTION flatten_complete(v variant)
  RETURNS variant
  LANGUAGE JAVASCRIPT
  AS '
  // Define a function flatten(), which always returns an array.
  function flatten(input) {
    var returnArray = [];
    if (Array.isArray(input)) {
      var arrayLength = input.length;
      for (var i = 0; i < arrayLength; i++) {
        returnArray.push.apply(returnArray, flatten(input[i]));
      }
    } else if (typeof input === "object") {
      for (var key in input) {
        if (input.hasOwnProperty(key)) {
          returnArray.push.apply(returnArray, flatten(input[key]));
        }
      }
    } else {
      returnArray.push(input);
    }
    return returnArray;
  }

  // Now call the function flatten() that we defined earlier.
  return flatten(V);
  ';

select value from table(flatten(flatten_complete(parse_json(
'[
  {"key1" : [1, 2], "key2" : ["string1", "string2"]},
  {"key3" : [{"inner key 1" : 10, "inner key 2" : 11}, 12]}
  ]'))));

-----------+
   VALUE   |
-----------+
 1         |
 2         |
 "string1" |
 "string2" |
 10        |
 11        |
 12        |
-----------+

-- Example 12793
-- Valid UDF.  'N' must be capitalized.
CREATE OR REPLACE FUNCTION add5(n double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return N + 5;';

select add5(0.0);

-- Valid UDF. Lowercase argument is double-quoted.
CREATE OR REPLACE FUNCTION add5_quoted("n" double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return n + 5;';

select add5_quoted(0.0);

-- Invalid UDF. Error returned at runtime because JavaScript identifier 'n' cannot be resolved.
CREATE OR REPLACE FUNCTION add5_lowercase(n double)
  RETURNS double
  LANGUAGE JAVASCRIPT
  AS 'return n + 5;';

select add5_lowercase(0.0);

-- Example 12794
create or replace table strings (s string);
insert into strings values (null), ('non-null string');

-- Example 12795
CREATE OR REPLACE FUNCTION string_reverse_nulls(s string)
    RETURNS string
    LANGUAGE JAVASCRIPT
    AS '
    if (S === undefined) {
        return "string was null";
    } else
    {
        return undefined;
    }
    ';

-- Example 12796
select string_reverse_nulls(s) 
    from strings
    order by 1;
+-------------------------+
| STRING_REVERSE_NULLS(S) |
|-------------------------|
| string was null         |
| NULL                    |
+-------------------------+

-- Example 12797
CREATE OR REPLACE FUNCTION variant_nulls(V VARIANT)
      RETURNS VARCHAR
      LANGUAGE JAVASCRIPT
      AS '
      if (V === undefined) {
        return "input was SQL null";
      } else if (V === null) {
        return "input was variant null";
      } else {
        return V;
      }
      ';

-- Example 12798
select null, 
       variant_nulls(cast(null as variant)),
       variant_nulls(PARSE_JSON('null'))
       ;
+------+--------------------------------------+-----------------------------------+
| NULL | VARIANT_NULLS(CAST(NULL AS VARIANT)) | VARIANT_NULLS(PARSE_JSON('NULL')) |
|------+--------------------------------------+-----------------------------------|
| NULL | input was SQL null                   | input was variant null            |
+------+--------------------------------------+-----------------------------------+

-- Example 12799
CREATE OR REPLACE FUNCTION variant_nulls(V VARIANT)
      RETURNS variant
      LANGUAGE JAVASCRIPT
      AS $$
      if (V == 'return undefined') {
        return undefined;
      } else if (V == 'return null') {
        return null;
      } else if (V == 3) {
        return {
            key1 : undefined,
            key2 : null
            };
      } else {
        return V;
      }
      $$;

-- Example 12800
select variant_nulls('return undefined'::VARIANT) AS "RETURNED UNDEFINED",
       variant_nulls('return null'::VARIANT) AS "RETURNED NULL",
       variant_nulls(3) AS "RETURNED VARIANT WITH UNDEFINED AND NULL; NOTE THAT UNDEFINED WAS REMOVED";
+--------------------+---------------+---------------------------------------------------------------------------+
| RETURNED UNDEFINED | RETURNED NULL | RETURNED VARIANT WITH UNDEFINED AND NULL; NOTE THAT UNDEFINED WAS REMOVED |
|--------------------+---------------+---------------------------------------------------------------------------|
| NULL               | null          | {                                                                         |
|                    |               |   "key2": null                                                            |
|                    |               | }                                                                         |
+--------------------+---------------+---------------------------------------------------------------------------+

-- Example 12801
CREATE OR REPLACE FUNCTION num_test(a double)
  RETURNS string
  LANGUAGE JAVASCRIPT
AS
$$
  return A;
$$
;

-- Example 12802
select hash(1) AS a, 
       num_test(hash(1)) AS b, 
       a - b;
+----------------------+----------------------+------------+
|                    A | B                    |      A - B |
|----------------------+----------------------+------------|
| -4730168494964875235 | -4730168494964875000 | -235.00000 |
+----------------------+----------------------+------------+

-- Example 12803
getColumnValueAsString()

-- Example 12804
CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
  return i+1
$$;

-- Example 12805
CREATE [ OR REPLACE ] PROJECTION POLICY [ IF NOT EXISTS ] <name>
  AS () RETURNS PROJECTION_CONSTRAINT -> <body>
  [ COMMENT = '<string_literal>' ]

-- Example 12806
CREATE OR REPLACE PROJECTION POLICY do_not_project AS ()
  RETURNS PROJECTION_CONSTRAINT ->
  PROJECTION_CONSTRAINT(ALLOW => false);

-- Example 12807
CREATE OR REPLACE PROJECTION POLICY project_analyst_only AS ()
  RETURNS PROJECTION_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ANALYST'
        THEN PROJECTION_CONSTRAINT(ALLOW => true)
      ELSE PROJECTION_CONSTRAINT(ALLOW => false)
    END;

-- Example 12808
DESC[RIBE] PROJECTION POLICY <name>

-- Example 12809
DESC PROJECTION POLICY do_not_project;

-- Example 12810
DROP PROJECTION POLICY <name>

-- Example 12811
SELECT * from table(mydb.information_schema.policy_references(policy_name=>'do_not_project'));

-- Example 12812
DROP PROJECTION POLICY do_not_project;

-- Example 12813
SHOW PROJECTION POLICIES [ LIKE '<pattern>' ]
                         [ IN
                              {
                                ACCOUNT                  |

                                DATABASE [ <database_name> ] |

                                SCHEMA [ <schema_name> ]     |
                              }
                         ]

-- Example 12814
SHOW PROJECTION POLICIES;

-- Example 12815
CREATE ACCOUNT my_admin ADMIN_USER_TYPE = PERSON;

-- Example 12816
CREATE ACCOUNT my_admin
  ADMIN_USER_TYPE = SERVICE
  ADMIN_RSA_PUBLIC_KEY = 'MIIBIj...';

-- Example 12817
USE ROLE GLOBALORGADMIN;

GRANT APPLICATION ROLE ORG_USAGE_ADMIN TO ROLE custom_role;

GRANT ROLE custom_role TO USER joe;

-- Example 12818
-- Create a new primary connection
CREATE CONNECTION myconnection;

-- View accounts in your organization that are enabled for replication
SHOW REPLICATION ACCOUNTS;

-- Configure failover accounts for the primary connection
ALTER CONNECTION myconnection
  ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- View the details for the connection
SHOW CONNECTIONS;

-- Example 12819
CREATE CONNECTION myconnection
  AS REPLICA OF myorg.myaccount1.myconnection;

-- Example 12820
ALTER CONNECTION myconnection PRIMARY;

-- Example 12821
ALTER CONNECTION myconnection PRIMARY;

-- Example 12822
CREATE CONNECTION myconnection;

-- Example 12823
ALTER CONNECTION myconnection ENABLE FAILOVER TO ACCOUNTS myorg.myaccount2, myorg.myaccount3;

-- Example 12824
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12825
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12826
CREATE CONNECTION myconnection
  AS REPLICA OF MYORG.MYACCOUNT1.MYCONNECTION;

-- Example 12827
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12828
GRANT FAILOVER ON CONNECTION myconnection TO ROLE my_failover_role;

-- Example 12829
USE ROLE my_failover_role;

ALTER CONNECTION myconnection PRIMARY;

-- Example 12830
SHOW CONNECTIONS;

+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+
| snowflake_region   | created_on                    | account_name        | name              | comment         | is_primary    | primary                       | failover_allowed_to_accounts        | connection_url                            | organization_name | account_locator   |
|--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
|--------------------|-------------------------------|---------------------|-------------------|-----------------|---------------|-------------------------------|-------------------------------------|-------------------------------------------|-------------------|-------------------|
| AWS_US_WEST_2      | 2020-07-19 14:49:11.183 -0700 | MYORG.MYACCOUNT1    | MYCONNECTION      | NULL            | true          | MYORG.MYACCOUNT1.MYCONNECTION | MYORG.MYACCOUNT2, MYORG.MYACCOUNT3  | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR1 |
| AWS_US_EAST_1      | 2020-07-22 13:52:04.925 -0700 | MYORG.MYACCOUNT2    | MYCONNECTION      | NULL            | false         | MYORG.MYACCOUNT1.MYCONNECTION |                                     | myorg-myconnection.snowflakecomputing.com | MYORG             | MYACCOUNTLOCATOR2 |
+--------------------+-------------------------------+---------------------+-------------------+-----------------+---------------+-------------------------------+-------------------------------------+-------------------------------------------+-------------------+-------------------+

-- Example 12831
myaccount1.us-west-2.privatelink.snowflakecomputing.com.
ocsp.myaccount1.us-west-2.privatelink.snowflakecomputing.com.

-- Example 12832
myorg-myaccount1.privatelink.snowflakecomputing.com.
ocsp.myorg-myaccount1.privatelink.snowflakecomputing.com.

-- Example 12833
<organization-name>-<connection-name>

-- Example 12834
myorg-myconnection

-- Example 12835
https://<organization_name>-<connection_name>.snowflakecomputing.com/

-- Example 12836
https://myorg-myconnection.snowflakecomputing.com/

-- Example 12837
accountname = <organization_name>-<connection_name>
username = <username>
password = <password>

-- Example 12838
accountname = myorg-myconnection
username = jsmith
password = mySecurePassword

-- Example 12839
con = snowflake.connector.connect (
      account = <organization_name>-<connection_name>
      user = <username>
      password = <password>
)

-- Example 12840
con = snowflake.connector.connect (
      account = myorg-myconnection
      user = jsmith
      password = mySecurePassword
)

-- Example 12841
jdbc:snowflake://<organization_name>-<connection_name>.snowflakecomputing.com/?user=<username>&password=<password>

-- Example 12842
jdbc:snowflake://myorg-myconnection.snowflakecomputing.com/?user=jsmith&password=mySecurePassword

-- Example 12843
[ODBC Data Sources]
<account_name> = SnowflakeDSIIDriver

[<dsn_name>]
Description     = SnowflakeDB
Driver          = SnowflakeDSIIDriver
Locale          = en-US
SERVER          = <organization_name>-<connection_name>.snowflakecomputing.com

