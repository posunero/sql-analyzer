-- Example 12978
['_libgcc_mutex==0.1', '_openmp_mutex==5.1', 'blas==1.0', 'ca-certificates==2024.9.24', 'intel-openmp==2023.1.0',
'ld_impl_linux-64==2.40', 'ld_impl_linux-aarch64==2.40', 'libffi==3.4.4', 'libgcc-ng==11.2.0', 'libgfortran-ng==11.2.0',
'libgfortran5==11.2.0', 'libgomp==11.2.0', 'libopenblas==0.3.21', 'libstdcxx-ng==11.2.0', 'mkl-service==2.4.0', 'mkl==2023.1.0',
'mkl_fft==1.3.10', 'mkl_random==1.2.7', 'ncurses==6.4', 'numpy-base==2.0.1', 'numpy==2.0.1', 'openssl==3.0.15', 'python==3.9.20',
'readline==8.2', 'sqlite==3.45.3', 'tbb==2021.8.0', 'tk==8.6.14', 'tzdata==2024b', 'xz==5.4.6', 'zlib==1.2.13']

-- Example 12979
SELECT SNOWFLAKE.SNOWPARK.SHOW_PYTHON_PACKAGES_DEPENDENCIES('3.9', []);

-- Example 12980
CREATE OR REPLACE FUNCTION my_udf()
  RETURNS STRING
  LANGUAGE PYTHON
  PACKAGES = ('snowflake-snowpark-python')
  RUNTIME_VERSION = 3.10
  HANDLER = 'echo'
AS $$
def echo():
 return 'hi'
$$;

DESCRIBE FUNCTION my_udf();

-- Example 12981
SELECT * FROM information_schema.packages;

-- Example 12982
-- at the database level

CREATE OR REPLACE VIEW USED_ANACONDA_PACKAGES
  ASSELECT FUNCTION_NAME, VALUE PACKAGE_NAME
  FROM (SELECT FUNCTION_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM INFORMATION_SCHEMA.FUNCTIONS
  WHERE FUNCTION_LANGUAGE='PYTHON') USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES);

-- at the account level

CREATE OR REPLACE VIEW ACCOUNT_USED_ANACONDA_PACKAGES
  AS SELECT FUNCTION_CATALOG, FUNCTION_SCHEMA, FUNCTION_NAME, VALUE PACKAGE_NAME
  FROM (SELECT FUNCTION_CATALOG, FUNCTION_SCHEMA, FUNCTION_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTIONS
  WHERE FUNCTION_LANGUAGE='PYTHON') USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES);

-- Example 12983
USE ROLE ACCOUNTADMIN;

SELECT SNOWFLAKE.SNOWPARK.GET_ANACONDA_PACKAGES_REPODATA('linux-64');

-- Example 12984
USE ROLE policy_admin;

ALTER ACCOUNT SET PACKAGES POLICY yourdb.yourschema.packages_policy_prod_1;

-- Example 12985
ALTER ACCOUNT SET PACKAGES POLICY yourdb.yourschema.packages_policy_prod_2 force;

-- Example 12986
SELECT * FROM TABLE(information_schema.policy_references(ref_entity_domain=>'ACCOUNT', ref_entity_name=>'<your_account_name>'))

-- Example 12987
ALTER ACCOUNT UNSET PACKAGES POLICY;

-- Example 12988
GRANT USAGE ON PACKAGES POLICY <packages policy name> TO ROLE <user role>;

-- Example 12989
SELECT * FROM information_schema.current_packages_policy;

-- Example 12990
+------+----------+-----------+-----------+-------------------------------+---------+
| NAME | LANGUAGE | ALLOWLIST | BLOCKLIST | ADDITIONAL_CREATION_BLOCKLIST | COMMENT |
+------+----------+-----------+-----------+-------------------------------+---------+
| P1   | PYTHON   | ['*']     | []        | [NULL]                        | [NULL]  |
+------+----------+-----------+-----------+-------------------------------+---------+

-- Example 12991
USE DATABASE mydb;

CREATE OR REPLACE VIEW USED_ANACONDA_PACKAGES
  AS
  SELECT FUNCTION_NAME, VALUE PACKAGE_NAME
  FROM (SELECT FUNCTION_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM INFORMATION_SCHEMA.FUNCTIONS
  WHERE FUNCTION_LANGUAGE='PYTHON') USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES);

-- Example 12992
USE DATABASE mydb;

CREATE OR REPLACE VIEW ACCOUNT_USED_ANACONDA_PACKAGES
  AS
  SELECT  FUNCTION_CATALOG, FUNCTION_SCHEMA, FUNCTION_NAME, VALUE PACKAGE_NAME
  FROM (SELECT FUNCTION_CATALOG, FUNCTION_SCHEMA, FUNCTION_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTIONS
  WHERE FUNCTION_LANGUAGE='PYTHON') USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES);

-- Example 12993
USE DATABASE mydb;

CREATE OR REPLACE VIEW ACCOUNT_USED_ANACONDA_PACKAGES
  AS
  SELECT 'FUNCTION' TYPE, FUNCTION_CATALOG DATABASE, FUNCTION_SCHEMA SCHEMA, FUNCTION_NAME NAME, VALUE::STRING PACKAGE_NAME
  FROM (SELECT FUNCTION_CATALOG, FUNCTION_SCHEMA, FUNCTION_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM SNOWFLAKE.ACCOUNT_USAGE.FUNCTIONS
  WHERE FUNCTION_LANGUAGE='PYTHON' AND PACKAGES IS NOT NULL) USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES)
  UNION
  (SELECT 'PROCEDURE' TYPE, PROCEDURE_CATALOG DATABASE, PROCEDURE_SCHEMA SCHEMA, PROCEDURE_NAME, VALUE::STRING PACKAGE_NAME
  FROM (SELECT PROCEDURE_CATALOG, PROCEDURE_SCHEMA,PROCEDURE_NAME,PARSE_JSON(PACKAGES)
  PACKAGES FROM SNOWFLAKE.ACCOUNT_USAGE.PROCEDURES
  WHERE PROCEDURE_LANGUAGE='PYTHON' AND PACKAGES IS NOT NULL) USED_PACKAGES,LATERAL FLATTEN(USED_PACKAGES.PACKAGES));

-- Example 12994
Resource Monitor MY_ACCOUNT_MONITOR has reached 50% of its MONTHLY
quota of 500 credits which has triggered a <action> action.

-- Example 12995
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
  TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 12996
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
  TRIGGERS ON 90 PERCENT DO SUSPEND
           ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 12997
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
   TRIGGERS ON 50 PERCENT DO NOTIFY
            ON 75 PERCENT DO NOTIFY
            ON 100 PERCENT DO SUSPEND
            ON 110 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 12998
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=1000
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

-- Example 12999
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR limit1 WITH CREDIT_QUOTA=2000
    FREQUENCY = WEEKLY
    START_TIMESTAMP = '2019-03-04 00:00 PST'
    TRIGGERS ON 80 PERCENT DO SUSPEND
             ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER WAREHOUSE wh1 SET RESOURCE_MONITOR = limit1;

ALTER WAREHOUSE wh2 SET RESOURCE_MONITOR = limit1;

-- Example 13000
ALTER RESOURCE MONITOR limit1 SET CREDIT_QUOTA=3000;

-- Example 13001
SHOW WAREHOUSES;

-- Example 13002
+--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------+
| name   | state     | type     | size    | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment | resource_monitor | actives | pendings | failed | suspended | uuid       | budget | owner_role_type |
|--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------|
| MY_WH1 | STARTED   | STANDARD | X-Small |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2024-01-17 14:37:36.223 -0800 | 2024-01-17 14:37:36.325 -0800 | 2024-01-17 14:47:49.854 -0800 | MY_ROLE      |         | null             |       0 |        0 |      0 |         1 | 1222706972 | NULL   | ROLE            |
| MY_WH2 | SUSPENDED | STANDARD | X-Small |       0 |      0 | N          | Y          |          600 | true        |           |              |           |       | 2023-12-20 13:50:50.972 -0800 | 2024-01-17 14:28:39.170 -0800 | 2024-01-17 14:37:57.560 -0800 | ACCOUNTADMIN |         | MY_RM            |       0 |        0 |      0 |         1 | 1222706948 | NULL   | ROLE            |
| MY_WH3 | SUSPENDED | STANDARD | Small   |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2024-01-17 14:26:26.911 -0800 | 2024-01-17 14:33:39.260 -0800 | 2024-01-17 14:38:31.192 -0800 | ACCOUNTADMIN |         | MY_RM            |       0 |        0 |      0 |         2 | 1222706960 | NULL   | ROLE            |
+--------+-----------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+------------------+---------+----------+--------+-----------+------------+--------+-----------------+

-- Example 13003
ALTER WAREHOUSE my_wh2 UNSET RESOURCE_MONITOR;

ALTER WAREHOUSE my_wh3 UNSET RESOURCE_MONITOR;

-- Example 13004
ALTER ACCOUNT my_account SET RESOURCE_MONITOR = my_rm;

-- Example 13005
ALTER RESOURCE MONITOR my_warehouse_rm
  SET NOTIFY_USERS = (USER1, USER2);

-- Example 13006
USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR my_account_rm WITH CREDIT_QUOTA=10000
  TRIGGERS ON 100 PERCENT DO SUSPEND;

ALTER ACCOUNT SET RESOURCE_MONITOR = my_account_rm;

-- Example 13007
ALTER WAREHOUSE my_wh SET RESOURCE_MONITOR = my_rm;

-- Example 13008
ALTER FAILOVER GROUP [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  [ OBJECT_TYPES = <object_type> [ , <object_type> , ... ] ]
  [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
  [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  OBJECT_TYPES = INTEGRATIONS [ , <object_type> , ... ]
  ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> ... ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }'

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  ERROR_INTEGRATION = <integration_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <db_name> [ , <db_name> ,  ... ] TO ALLOWED_DATABASES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  MOVE DATABASES <db_name> [ , <db_name> ,  ... ] TO FAILOVER GROUP <move_to_fg_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <db_name> [ , <db_name> ,  ... ] FROM ALLOWED_DATABASES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <share_name> [ , <share_name> ,  ... ] TO ALLOWED_SHARES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  MOVE SHARES <share_name> [ , <share_name> ,  ... ] TO FAILOVER GROUP <move_to_fg_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <share_name> [ , <share_name> ,  ... ] FROM ALLOWED_SHARES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] TO ALLOWED_ACCOUNTS
  [ IGNORE EDITION CHECK ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] FROM ALLOWED_ACCOUNTS

-- Example 13009
ALTER FAILOVER GROUP [ IF EXISTS ] <name> REFRESH

ALTER FAILOVER GROUP [ IF EXISTS ] <name> PRIMARY

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SUSPEND [ IMMEDIATE ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> RESUME

-- Example 13010
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 13011
ALTER FAILOVER GROUP myfg ADD myorg.myaccount3 TO ALLOWED_ACCOUNTS;

-- Example 13012
ALTER FAILOVER GROUP myfg SET
  OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES
  ALLOWED_DATABASES = db1;

-- Example 13013
ALTER FAILOVER GROUP myfg
  ADD db2, db3 TO ALLOWED_DATABASES;

-- Example 13014
ALTER FAILOVER GROUP myfg
  MOVE DATABASES db3 TO FAILOVER GROUP myfg2;

-- Example 13015
ALTER FAILOVER GROUP myfg3 SET
  OBJECT_TYPES = DATABASES, SHARES;

-- Example 13016
ALTER FAILOVER GROUP myfg
  MOVE DATABASES db2 TO FAILOVER GROUP myfg3;

-- Example 13017
ALTER FAILOVER GROUP myfg
  SET ALLOWED_DATABASES = NULL;

-- Example 13018
ALTER FAILOVER GROUP myfg
  REMOVE databases FROM OBJECT_TYPES;

-- Example 13019
ALTER FAILOVER GROUP myfg
  SET REPLICATION_SCHEDULE = '15 MINUTE';

-- Example 13020
ALTER FAILOVER GROUP myfg REFRESH;

-- Example 13021
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 13022
ALTER FAILOVER GROUP myfg SUSPEND;

-- Example 13023
ALTER FAILOVER GROUP [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  [ OBJECT_TYPES = <object_type> [ , <object_type> , ... ] ]
  [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
  [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  OBJECT_TYPES = INTEGRATIONS [ , <object_type> , ... ]
  ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> ... ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }'

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SET
  ERROR_INTEGRATION = <integration_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <db_name> [ , <db_name> ,  ... ] TO ALLOWED_DATABASES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  MOVE DATABASES <db_name> [ , <db_name> ,  ... ] TO FAILOVER GROUP <move_to_fg_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <db_name> [ , <db_name> ,  ... ] FROM ALLOWED_DATABASES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <share_name> [ , <share_name> ,  ... ] TO ALLOWED_SHARES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  MOVE SHARES <share_name> [ , <share_name> ,  ... ] TO FAILOVER GROUP <move_to_fg_name>

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <share_name> [ , <share_name> ,  ... ] FROM ALLOWED_SHARES

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  ADD <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] TO ALLOWED_ACCOUNTS
  [ IGNORE EDITION CHECK ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name>
  REMOVE <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ] FROM ALLOWED_ACCOUNTS

-- Example 13024
ALTER FAILOVER GROUP [ IF EXISTS ] <name> REFRESH

ALTER FAILOVER GROUP [ IF EXISTS ] <name> PRIMARY

ALTER FAILOVER GROUP [ IF EXISTS ] <name> SUSPEND [ IMMEDIATE ]

ALTER FAILOVER GROUP [ IF EXISTS ] <name> RESUME

-- Example 13025
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 13026
ALTER FAILOVER GROUP myfg ADD myorg.myaccount3 TO ALLOWED_ACCOUNTS;

-- Example 13027
ALTER FAILOVER GROUP myfg SET
  OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, DATABASES
  ALLOWED_DATABASES = db1;

-- Example 13028
ALTER FAILOVER GROUP myfg
  ADD db2, db3 TO ALLOWED_DATABASES;

-- Example 13029
ALTER FAILOVER GROUP myfg
  MOVE DATABASES db3 TO FAILOVER GROUP myfg2;

-- Example 13030
ALTER FAILOVER GROUP myfg3 SET
  OBJECT_TYPES = DATABASES, SHARES;

-- Example 13031
ALTER FAILOVER GROUP myfg
  MOVE DATABASES db2 TO FAILOVER GROUP myfg3;

-- Example 13032
ALTER FAILOVER GROUP myfg
  SET ALLOWED_DATABASES = NULL;

-- Example 13033
ALTER FAILOVER GROUP myfg
  REMOVE databases FROM OBJECT_TYPES;

-- Example 13034
ALTER FAILOVER GROUP myfg
  SET REPLICATION_SCHEDULE = '15 MINUTE';

-- Example 13035
ALTER FAILOVER GROUP myfg REFRESH;

-- Example 13036
ALTER FAILOVER GROUP myfg PRIMARY;

-- Example 13037
ALTER FAILOVER GROUP myfg SUSPEND;

-- Example 13038
CREATE REPLICATION GROUP [ IF NOT EXISTS ] <name>
    OBJECT_TYPES = <object_type> [ , <object_type> , ... ]
    [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
    [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]
    [ ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> , ... ] ]
    ALLOWED_ACCOUNTS = <org_name>.<target_account_name> [ , <org_name>.<target_account_name> , ... ]
    [ IGNORE EDITION CHECK ]
    [ REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ ERROR_INTEGRATION = <integration_name> ]

-- Example 13039
CREATE REPLICATION GROUP [ IF NOT EXISTS ] <secondary_name>
    AS REPLICA OF <org_name>.<source_account_name>.<name>

-- Example 13040
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 13041
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 13042
CREATE REPLICATION GROUP myrg
    AS REPLICA OF myorg.myaccount1.myrg;

-- Example 13043
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES, SHARES
    ALLOWED_DATABASES = db1
    ALLOWED_SHARES = s1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 13044
CREATE REPLICATION GROUP myrg
    AS REPLICA OF myorg.myaccount1.myrg;

