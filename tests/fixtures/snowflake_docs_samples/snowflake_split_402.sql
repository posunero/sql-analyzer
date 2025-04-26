-- Example 26909
USE DATABASE my_db;
USE SCHEMA INFORMATION_SCHEMA;
SELECT
    policy_name,
    policy_kind,
    ref_entity_name,
    ref_entity_domain,
    ref_column_name,
    ref_arg_column_names,
    policy_status
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(ref_entity_name => 'my_db.my_schema.join_table', ref_entity_domain => 'table'));

-- Example 26910
+-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------+
| POLICY_NAME | POLICY_KIND | REF_ENTITY_NAME | REF_ENTITY_DOMAIN | REF_COLUMN_NAME | REF_ARG_COLUMN_NAMES | POLICY_STATUS |
|-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------|
| JP1         | JOIN_POLICY | JOIN_TABLE      | TABLE             | NULL            | [ "COL1" ]           | ACTIVE        |
+-------------+-------------+-----------------+-------------------+-----------------+----------------------+---------------+

-- Example 26911
USE ROLE USERADMIN;

CREATE ROLE join_policy_admin;

-- Example 26912
GRANT USAGE ON DATABASE privacy TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;

GRANT CREATE JOIN POLICY
  ON SCHEMA privacy.join_policies TO ROLE join_policy_admin;

GRANT APPLY JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

-- Example 26913
USE ROLE join_policy_admin;
USE SCHEMA privacy.join_policies;

CREATE OR REPLACE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

-- Example 26914
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE join_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT CREATE JOIN POLICY ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT APPLY ON JOIN POLICY ON ACCOUNT TO ROLE join_policy_admin;

-- Example 26915
USE ROLE securityadmin;
GRANT CREATE JOIN POLICY ON SCHEMA mydb.schema TO ROLE join_policy_admin;
GRANT APPLY ON JOIN POLICY cost_center TO ROLE finance_role;

-- Example 26916
SHOW FAILOVER GROUPS [ IN ACCOUNT <account> ]

-- Example 26917
SHOW FAILOVER GROUPS IN ACCOUNT myaccount1;

+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| snowflake_region | created_on                    | account_name | name | type     | comment | is_primary | primary               | object_types                                | allowed_integration_types |  allowed_accounts                            | organization_name | account_locator   | replication_schedule | secondary_state | next_scheduled_refresh        | owner      | is_listing_auto_fulfillment_group |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| AWS_US_EAST_1    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT1   | MYFG | FAILOVER |         | true       | MYORG.MYACCOUNT1.MYFG | DATABASES, ROLES, USERS, WAREHOUSES, SHARES |                           | MYORG.MYACCOUNT1.MYFG,MYORG.MYACCOUNT2.MYFG  | MYORG             | MYACCOUNT1LOCATOR | 10 MINUTE            | NULL            |                               | MYROLE     | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| AWS_US_WEST_2    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT2   | MYFG | FAILOVER |         | false      | MYORG.MYACCOUNT1.MYFG |                                             |                           |                                              | MYORG             | MYACCOUNT2LOCATOR | 10 MINUTE            | STARTED         | 2022-03-06 12:10:35.280 -0800 | NULL       | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+

-- Example 26918
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = databases, shares
  ALLOWED_DATABASES = db1
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme.account_2;

-- Example 26919
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme.account1.my_rg;

-- Example 26920
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 26921
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 26922
USE ROLE ACCOUNTADMIN;

CREATE DATABASE db1;

CREATE SCHEMA db1.sch;

CREATE TABLE db1.sch.table_b AS
  SELECT customerid, user_order_count, total_spent
  FROM source_db.sch.table_a
  WHERE REGION='azure_eastus2';

-- Example 26923
CREATE SECURE VIEW db1.sch.view1 AS
  SELECT customerid, user_order_count, total_spent
  FROM db1.sch.table_b;

-- Example 26924
CREATE STREAM mystream ON TABLE source_db.sch.table_a APPEND_ONLY = TRUE;

-- Example 26925
CREATE TASK mytask1
  WAREHOUSE = mywh
  SCHEDULE = '5 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('mystream')
AS
  INSERT INTO table_b(CUSTOMERID, USER_ORDER_COUNT, TOTAL_SPENT)
    SELECT customerid, user_order_count, total_spent
    FROM mystream
    WHERE region='azure_eastus2'
    AND METADATA$ACTION = 'INSERT';

-- Example 26926
ALTER TASK mytask1 RESUME;

-- Example 26927
CREATE SHARE share1;

GRANT USAGE ON DATABASE db1 TO SHARE share1;
GRANT USAGE ON SCHEMA db1.sch TO SHARE share1;
GRANT SELECT ON VIEW db1.sch.view1 TO SHARE share1;

-- Example 26928
CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = DATABASES, SHARES
  ALLOWED_DATABASES = db1
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme_org.account_2;

-- Example 26929
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme_org.account_1.my_rg;

-- Example 26930
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 26931
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 26932
CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = databases, shares
  ALLOWED_DATABASES = database1, database2, database3
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme.account_2;

-- Example 26933
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme_org.account_1.my_rg;

-- Example 26934
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 26935
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 26936
SYSTEM$CLASSIFY_SCHEMA( '<schema_name>' , <object> )

-- Example 26937
{
  "failed": [
    {
      "message": "Insufficient privileges.",
      "table_name": "t4"
    }
  ],
  "succeeded": [
    {
      "table_name": "t1"
    },
    {
      "table_name": "t2"
    },
    {
      "table_name": "t3"
    }
  ]
}

-- Example 26938
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', null);

-- Example 26939
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'sample_count': 1000});

-- Example 26940
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'auto_tag': true});

-- Example 26941
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'sample_count': 1000, 'auto_tag': true});

-- Example 26942
{
    "data": [
                [0, 10, "Alex", "2014-01-01 16:00:00"],
                [1, 20, "Steve", "2015-01-01 16:00:00"],
                [2, 30, "Alice", "2016-01-01 16:00:00"],
                [3, 40, "Adrian", "2017-01-01 16:00:00"]
            ]
}

-- Example 26943
def handler(event, context):

    request_headers = event["headers"]
    signature = request_headers["sf-external-function-signature"]

-- Example 26944
{
    "data":
        [
            [ 0, { "City" : "Warsaw",  "latitude" : 52.23, "longitude" :  21.01 } ],
            [ 1, { "City" : "Toronto", "latitude" : 43.65, "longitude" : -79.38 } ]
        ]
}

-- Example 26945
...
row_number = 0
output_value = {}

output_value["city"] = "Warsaw"
output_value["latitude"] = 21.01
output_value["longitude"] = 52.23
row_to_return = [row_number, output_value]
...

-- Example 26946
select val:city, val:latitude, val:longitude
    from (select ext_func_city_lat_long(city_name) as val from table_of_city_names);

-- Example 26947
import json
import hashlib
import base64

def handler(event, context):

    # The return value should contain an array of arrays (one inner array
    # per input row for a scalar function).
    array_of_rows_to_return = [ ]

    ...

    json_compatible_string_to_return = json.dumps({"data" : array_of_rows_to_return})

    # Calculate MD5 checksum for the response
    md5digest = hashlib.md5(json_compatible_string_to_return.encode('utf-8')).digest()
    response_headers = {
        'Content-MD5' : base64.b64encode(md5digest)
    }

    # Return the HTTP status code, the processed data, and the headers
    # (including the Content-MD5 header).
    return {
        'statusCode': 200,
        'body': json_compatible_string_to_return,
        'headers': response_headers
    }

-- Example 26948
Date.prototype._originalToString = Date.prototype.toString;
Date.prototype.toString = function() {
  /* ... SOME CUSTOM CODE ... */
  this._originalToString()
  }

-- Example 26949
var setup = function() {
/* SETUP LOGIC */
};

if (typeof(setup_done) === "undefined") {
  setup();
  setup_done = true;  // setting global variable to true
}

-- Example 26950
CREATE OR REPLACE FUNCTION tf (arg1 VARCHAR(1))
RETURNS VARCHAR(1)
LANGUAGE JAVASCRIPT AS 'return A.substr(3, 3);';

-- Example 26951
CREATE OR REPLACE FUNCTION RECURSION_TEST (STR VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  AS $$
  return (STR.length <= 1 ? STR : STR.substring(0,1) + '_' + RECURSION_TEST(STR.substring(1)));
  $$
  ;

-- Example 26952
SELECT RECURSION_TEST('ABC');
+-----------------------+
| RECURSION_TEST('ABC') |
|-----------------------|
| A_B_C                 |
+-----------------------+

-- Example 26953
CREATE FUNCTION validate_ID(ID FLOAT)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
    try {
        if (ID < 0) {
            throw "ID cannot be negative!";
        } else {
            return "ID validated.";
        }
    } catch (err) {
        return "Error: " + err;
    }
$$;

-- Example 26954
CREATE TABLE employees (ID INTEGER);
INSERT INTO employees (ID) VALUES 
    (1),
    (-1);

-- Example 26955
SELECT ID, validate_ID(ID) FROM employees ORDER BY ID;
+----+-------------------------------+
| ID | VALIDATE_ID(ID)               |
|----+-------------------------------|
| -1 | Error: ID cannot be negative! |
|  1 | ID validated.                 |
+----+-------------------------------+

-- Example 26956
create function mask_bits(...)
    ...
    as
    $$
    var masked = (x & y);
    ...
    $$;

-- Example 26957
!set variable_substitution=false;

-- Example 26958
CREATE OR REPLACE FUNCTION RECURSION_TEST (STR VARCHAR)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  AS $$
  return (STR.length <= 1 ? STR : STR.substring(0,1) + '_' + RECURSION_TEST(STR.substring(1)));
  $$
  ;

-- Example 26959
SELECT RECURSION_TEST('ABC');
+-----------------------+
| RECURSION_TEST('ABC') |
|-----------------------|
| A_B_C                 |
+-----------------------+

-- Example 26960
CREATE FUNCTION validate_ID(ID FLOAT)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS $$
    try {
        if (ID < 0) {
            throw "ID cannot be negative!";
        } else {
            return "ID validated.";
        }
    } catch (err) {
        return "Error: " + err;
    }
$$;

-- Example 26961
CREATE TABLE employees (ID INTEGER);
INSERT INTO employees (ID) VALUES 
    (1),
    (-1);

-- Example 26962
SELECT ID, validate_ID(ID) FROM employees ORDER BY ID;
+----+-------------------------------+
| ID | VALIDATE_ID(ID)               |
|----+-------------------------------|
| -1 | Error: ID cannot be negative! |
|  1 | ID validated.                 |
+----+-------------------------------+

-- Example 26963
CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
 return i+1
$$;

-- Example 26964
SELECT addone(10);

-- Example 26965
+------------+
| ADDONE(10) |
|------------|
|         11 |
+------------+

-- Example 26966
def snore(n):   # return a series of n snores
  result = []
  for a in range(n):
    result.append("Zzz")
  return result

-- Example 26967
put
file:///Users/Me/sleepy.py
@~/
auto_compress = false
overwrite = true
;

-- Example 26968
CREATE OR REPLACE FUNCTION dream(i INT)
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'sleepy.snore'
  IMPORTS = ('@~/sleepy.py')

-- Example 26969
SELECT dream(3);

-- Example 26970
+----------+
| DREAM(3) |
|----------|
| [        |
|   "Zzz", |
|   "Zzz", |
|   "Zzz"  |
| ]        |
+----------+

-- Example 26971
CREATE OR REPLACE FUNCTION multiple_import_files(s STRING)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  IMPORTS = ('@python_udf_dep/bar/python_imports_a.zip', '@python_udf_dep/foo/python_imports_b.zip')
  HANDLER = 'compute'
AS $$
def compute(s):
  return s
$$;

-- Example 26972
GRANT USAGE ON FUNCTION my_python_udf(number, number) TO my_role;

-- Example 26973
CREATE OR REPLACE FUNCTION py_udf()
  RETURNS VARIANT
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  PACKAGES = ('numpy','pandas','xgboost==1.5.0')
  HANDLER = 'udf'
AS $$
import numpy as np
import pandas as pd
import xgboost as xgb
def udf():
  return [np.__version__, pd.__version__, xgb.__version__]
$$;

-- Example 26974
SELECT py_udf();

-- Example 26975
+-------------+
| PY_UDF()    |
|-------------|
| [           |
|   "1.19.2", |
|   "1.4.0",  |
|   "1.5.0"   |
| ]           |
+-------------+

