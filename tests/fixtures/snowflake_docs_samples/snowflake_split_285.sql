-- Example 19073
CREATE WAREHOUSE temporary_warehouse WAREHOUSE_SIZE=XSMALL;

-- Example 19074
DESCRIBE WAREHOUSE temporary_warehouse;

-- Example 19075
+-------------------------------+---------------------+-----------+
| created_on                    | name                | kind      |
|-------------------------------+---------------------+-----------|
| 2022-06-23 00:00:00.000 -0700 | TEMPORARY_WAREHOUSE | WAREHOUSE |
+-------------------------------+---------------------+-----------+

-- Example 19076
DROP ACCOUNT [ IF EXISTS ] <name> GRACE_PERIOD_IN_DAYS = <integer>

-- Example 19077
DROP ACCOUNT my_account GRACE_PERIOD_IN_DAYS = 14;

-- Example 19078
DROP ACCOUNT my_account GRACE_PERIOD_IN_DAYS = 14;

-- Example 19079
SHOW ACCOUNTS HISTORY;

-- Example 19080
UNDROP ACCOUNT myaccount123;

-- Example 19081
DROP AUTHENTICATION POLICY [ IF EXISTS ] <name>

-- Example 19082
DROP AUTHENTICATION POLICY my_auth_policy;

-- Example 19083
DROP CATALOG INTEGRATION [ IF EXISTS ] <name>

-- Example 19084
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "catalog_name" = 'my_catalog_integration_1';

-- Example 19085
DROP CATALOG INTEGRATION myInt;

-- Example 19086
DROP CATALOG INTEGRATION IF EXISTS myInt;

-- Example 19087
DROP COMPUTE POOL [ IF EXISTS ] <name>

-- Example 19088
DROP COMPUTE POOL tutorial_compute_pool;

-- Example 19089
+---------------------------------------------+
| status                                      |
|---------------------------------------------|
| TUTORIAL_COMPUTE_POOL successfully dropped. |
+---------------------------------------------+

-- Example 19090
DROP CORTEX SEARCH SERVICE <name>;

-- Example 19091
DROP CORTEX SEARCH SERVICE mysvc;

-- Example 19092
+------------------------------+
| status                       |
|------------------------------|
| mysvc successfully dropped.  |
+------------------------------+

-- Example 19093
DROP DATABASE ROLE [ IF EXISTS ] <name>

-- Example 19094
SELECT *
  FROM snowflake.account_usage.grants_to_roles
  WHERE grantee_name = upper('<database_name>.<db_role_name>') OR granted_by = upper('<database_name>.<db_role_name>');

-- Example 19095
SELECT *
  FROM snowflake.account_usage.grants_to_roles
  WHERE grantee_name = upper('d1.dr1') OR granted_by = upper('d1.dr1');

-- Example 19096
DROP DATABASE ROLE d1.dr1;

-- Example 19097
DROP DYNAMIC TABLE [ IF EXISTS ] <name>

-- Example 19098
DROP DYNAMIC TABLE product;

-- Example 19099
DROP TABLE product;

-- Example 19100
DROP EXTERNAL TABLE [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 19101
SHOW EXTERNAL TABLES LIKE 't2%';

+-------------------------------+------------------+---------------+-------------+-----------------------+---------+-----------------------------------------+------------------+------------------+-------+-----------+----------------------+
| created_on                    | name             | database_name | schema_name | owner                 | comment | location                                | file_format_name | file_format_type | cloud | region    | notification_channel |
|-------------------------------+------------------+---------------+-------------+-----------------------+---------+-----------------------------------------+------------------+------------------+-------+-----------+----------------------|
| 2018-08-06 06:00:42.340 -0700 | T2               | MYDB          | PUBLIC      | MYROLE                |         | @MYDB.PUBLIC.MYSTAGE/                   |                  | JSON             | AWS   | us-east-1 | NULL                 |
+-------------------------------+------------------+---------------+-------------+-----------------------+---------+-----------------------------------------+------------------+------------------+-------+-----------+----------------------+

DROP EXTERNAL TABLE t2;

+--------------------------+
| status                   |
|--------------------------|
| T2 successfully dropped. |
+--------------------------+

SHOW EXTERNAL TABLES LIKE 't2%';

+------------+------+---------------+-------------+-------+---------+----------+------------------+------------------+-------+--------+----------------------+
| created_on | name | database_name | schema_name | owner | comment | location | file_format_name | file_format_type | cloud | region | notification_channel |
|------------+------+---------------+-------------+-------+---------+----------+------------------+------------------+-------+--------+----------------------|
+------------+------+---------------+-------------+-------+---------+----------+------------------+------------------+-------+--------+----------------------+

-- Example 19102
DROP EXTERNAL TABLE IF EXISTS t2;

+------------------------------------------------------------+
| status                                                     |
|------------------------------------------------------------|
| Drop statement executed successfully (T2 already dropped). |
+------------------------------------------------------------+

-- Example 19103
DROP EXTERNAL VOLUME [ IF EXISTS ] <name>

-- Example 19104
SHOW ICEBERG TABLES;

SELECT * FROM TABLE(
  RESULT_SCAN(
      LAST_QUERY_ID()
    )
  )
  WHERE "external_volume_name" = 'my_external_volume_1';

-- Example 19105
DROP EXTERNAL VOLUME my_external_volume;

-- Example 19106
DROP FAILOVER GROUP [ IF EXISTS ] <name>

-- Example 19107
DROP FAILOVER GROUP IF EXISTS myfg;

-- Example 19108
DROP FILE FORMAT [ IF EXISTS ] <name>

-- Example 19109
DROP FILE FORMAT my_format;

---------------------------------+
           status                |
---------------------------------+
MY_FORMAT successfully dropped.  |
---------------------------------+

-- Example 19110
DROP FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )

-- Example 19111
DROP FUNCTION multiply(number, number);

--------------------------------+
             status             |
--------------------------------+
 MULTIPLY successfully dropped. |
--------------------------------+

-- Example 19112
DROP FUNCTION [ IF EXISTS ] <name>(
TABLE(  <arg_data_type> [ , ... ] ) [ , TABLE( <arg_data_type> [ , ... ] ) ]
)

-- Example 19113
DROP FUNCTION governance.dmfs.count_positive_numbers(
  TABLE(
    NUMBER, NUMBER, NUMBER
  )
);

-- Example 19114
DROP FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] )

-- Example 19115
DROP FUNCTION my_echo_udf(VARCHAR);

-- Example 19116
+-----------------------------------+
| status                            |
|-----------------------------------|
| MY_ECHO_UDF successfully dropped. |
+-----------------------------------+

-- Example 19117
DROP [ ICEBERG ] TABLE [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 19118
DROP ICEBERG TABLE t2;

+--------------------------+
| status                   |
|--------------------------|
| T2 successfully dropped. |
+--------------------------+

-- Example 19119
DROP ICEBERG TABLE IF EXISTS t2;

+------------------------------------------------------------+
| status                                                     |
|------------------------------------------------------------|
| Drop statement executed successfully (T2 already dropped). |
+------------------------------------------------------------+

-- Example 19120
DROP IMAGE REPOSITORY [ IF EXISTS ] <name>

-- Example 19121
DROP IMAGE REPOSITORY tutorial_repository;

-- Example 19122
+-------------------------------------------+
| status                                    |
|-------------------------------------------|
| TUTORIAL_REPOSITORY successfully dropped. |
+-------------------------------------------+

-- Example 19123
DROP INDEX [ IF EXISTS ] <table_name>.<index_name>

-- Example 19124
DROP INDEX t0.c_idx;

-- Example 19125
DROP JOIN POLICY <name>

-- Example 19126
SELECT * FROM TABLE(mydb.INFORMATION_SCHEMA.POLICY_REFERENCES(POLICY_NAME=>'my_join_policy'));

-- Example 19127
DROP JOIN POLICY my_join_policy;

-- Example 19128
DROP LISTING <name>

-- Example 19129
GRANT OWNERSHIP ON REPLICATION GROUP myrg TO ROLE accountadmin
REVOKE CURRENT GRANTS;
DROP REPLICATION GROUP myrg;

-- Example 19130
DROP LISTING IF EXISTS MYLISTING

-- Example 19131
+----------------------------------+
| status                           |
|----------------------------------|
| MYLISTING successfully dropped. |
+----------------------------------+

-- Example 19132
DROP MANAGED ACCOUNT <name>

-- Example 19133
DROP MANAGED ACCOUNT reader_acct1;

  +------------------------------------+
  | status                             |
  |------------------------------------|
  | READER_ACCT1 successfully dropped. |
  +------------------------------------+

-- Example 19134
DROP MATERIALIZED VIEW [ IF EXISTS ] <view_name>

-- Example 19135
DROP MATERIALIZED VIEW mv1;

---------------------------+
           status          |
---------------------------+
 MV1 successfully dropped. |
---------------------------+

-- Example 19136
DROP MODEL MONITOR [ IF EXISTS ] <monitor_name>;

-- Example 19137
DROP NETWORK POLICY [ IF EXISTS ] <name>

-- Example 19138
DROP NETWORK POLICY mypolicy;

-- Example 19139
DROP NETWORK RULE [ IF EXISTS ] <name>

