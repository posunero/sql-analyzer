-- Example 9026
DROP TABLE IF EXISTS t2;

+------------------------------------------------------------+
| status                                                     |
|------------------------------------------------------------|
| Drop statement executed successfully (T2 already dropped). |
+------------------------------------------------------------+

-- Example 9027
DROP SCHEMA [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 9028
DROP SCHEMA myschema;

+--------------------------------+
| status                         |
|--------------------------------|
| MYSCHEMA successfully dropped. |
+--------------------------------+

SHOW SCHEMAS;

+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+
| created_on                      | name               | is_default | is_current | database_name | owner  | comment                                                   | options | retention_time |
|---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------|
| Fri, 13 May 2016 17:26:07 -0700 | INFORMATION_SCHEMA | N          | N          | MYTESTDB      |        | Views describing the contents of schemas in this database |         |              1 |
| Tue, 17 Mar 2015 16:57:04 -0700 | PUBLIC             | N          | Y          | MYTESTDB      | PUBLIC |                                                           |         |              1 |
+---------------------------------+--------------------+------------+------------+---------------+--------+-----------------------------------------------------------+---------+----------------+

-- Example 9029
DROP DATABASE [ IF EXISTS ] <name> [ CASCADE | RESTRICT ]

-- Example 9030
DROP DATABASE mytestdb2;

+---------------------------------+
| status                          |
|---------------------------------|
| MYTESTDB2 successfully dropped. |
+---------------------------------+

SHOW DATABASES LIKE 'mytestdb2';

+------------+------+------------+------------+--------+-------+---------+---------+----------------+
| created_on | name | is_default | is_current | origin | owner | comment | options | retention_time |
|------------+------+------------+------------+--------+-------+---------+---------+----------------|
+------------+------+------------+------------+--------+-------+---------+---------+----------------+

SHOW DATABASES HISTORY LIKE 'mytestdb2';

+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------+
| created_on                      | name      | is_default | is_current | origin | owner  | comment | options | retention_time | dropped_on                      |
|---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------|
| Wed, 25 Feb 2015 16:16:54 -0800 | MYTESTDB2 | N          | N          |        | PUBLIC |         |         |              1 | Fri, 13 May 2016 17:35:09 -0700 |
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------+

-- Example 9031
$ snowsql <connection_parameters>

-- Example 9032
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY

-- Example 9033
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=%DB_KEY%

-- Example 9034
[connections]
#accountname = <string>   # Account identifier to connect to Snowflake (for example, myorganization-myaccount).
#username = <string>      # User name in the account. Optional.
#password = <string>      # User password. Optional.
#dbname = <string>        # Default database. Optional.
#schemaname = <string>    # Default schema. Optional.
#warehousename = <string> # Default warehouse. Optional.
#rolename = <string>      # Default role. Optional.
#authenticator = <string> # Authenticator: 'snowflake', 'externalbrowser' (to use any IdP and a web browser),  https://<okta_account_name>.okta.com (to use Okta natively), 'oauth' to authenticate using OAuth.

-- Example 9035
$ chmod 700 ~/.snowsql/config

-- Example 9036
[connections.my_example_connection]
accountname = myorganization-myaccount
username = jsmith
password = xxxxxxxxxxxxxxxxxxxx
dbname = mydb
schemaname = public
warehousename = mywh

-- Example 9037
$ snowsql -c my_example_connection

-- Example 9038
private_key_path = <path>/rsa_key.p8

-- Example 9039
export SNOWSQL_PRIVATE_KEY_PASSPHRASE=<passphrase>

-- Example 9040
set SNOWSQL_PRIVATE_KEY_PASSPHRASE=<passphrase>

-- Example 9041
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 9042
export HTTP_PROXY='http://username:password@proxyserver.example.com:80'
export HTTPS_PROXY='http://username:password@proxyserver.example.com:80'

-- Example 9043
set HTTP_PROXY=http://username:password@proxyserver.example.com:80
set HTTPS_PROXY=http://username:password@proxyserver.example.com:80

-- Example 9044
$ snowsql -a <account_identifier> -u <username> --authenticator externalbrowser

-- Example 9045
$ sudo bash -c "echo '-b snowsql' > /etc/prelink.conf.d/snowsql.conf"

-- Example 9046
$ export SNOWSQL_ACCOUNT=myorganization-myaccount

$ snowsql -a $SNOWSQL_ACCOUNT

-- Example 9047
$ export SNOWSQL_USER=jdoe

$ snowsql -u $SNOWSQL_USER

-- Example 9048
$ snowsql ... -P ...

Password: PASSWORD123456

-- Example 9049
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY ...

-- Example 9050
SHOW ACCOUNTS [ HISTORY ] [ LIKE '<pattern>' ]

-- Example 9051
SHOW ACCOUNTS LIKE 'myaccount%';

-- Example 9052
$ snowsql <connection_parameters>

-- Example 9053
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY

-- Example 9054
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=%DB_KEY%

-- Example 9055
[connections]
#accountname = <string>   # Account identifier to connect to Snowflake (for example, myorganization-myaccount).
#username = <string>      # User name in the account. Optional.
#password = <string>      # User password. Optional.
#dbname = <string>        # Default database. Optional.
#schemaname = <string>    # Default schema. Optional.
#warehousename = <string> # Default warehouse. Optional.
#rolename = <string>      # Default role. Optional.
#authenticator = <string> # Authenticator: 'snowflake', 'externalbrowser' (to use any IdP and a web browser),  https://<okta_account_name>.okta.com (to use Okta natively), 'oauth' to authenticate using OAuth.

-- Example 9056
$ chmod 700 ~/.snowsql/config

-- Example 9057
[connections.my_example_connection]
accountname = myorganization-myaccount
username = jsmith
password = xxxxxxxxxxxxxxxxxxxx
dbname = mydb
schemaname = public
warehousename = mywh

-- Example 9058
$ snowsql -c my_example_connection

-- Example 9059
private_key_path = <path>/rsa_key.p8

-- Example 9060
export SNOWSQL_PRIVATE_KEY_PASSPHRASE=<passphrase>

-- Example 9061
set SNOWSQL_PRIVATE_KEY_PASSPHRASE=<passphrase>

-- Example 9062
$ snowsql -a <account_identifier> -u <user> --private-key-path <path>/rsa_key.p8

-- Example 9063
export HTTP_PROXY='http://username:password@proxyserver.example.com:80'
export HTTPS_PROXY='http://username:password@proxyserver.example.com:80'

-- Example 9064
set HTTP_PROXY=http://username:password@proxyserver.example.com:80
set HTTPS_PROXY=http://username:password@proxyserver.example.com:80

-- Example 9065
$ snowsql -a <account_identifier> -u <username> --authenticator externalbrowser

-- Example 9066
$ sudo bash -c "echo '-b snowsql' > /etc/prelink.conf.d/snowsql.conf"

-- Example 9067
$ export SNOWSQL_ACCOUNT=myorganization-myaccount

$ snowsql -a $SNOWSQL_ACCOUNT

-- Example 9068
$ export SNOWSQL_USER=jdoe

$ snowsql -u $SNOWSQL_USER

-- Example 9069
$ snowsql ... -P ...

Password: PASSWORD123456

-- Example 9070
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY ...

-- Example 9071
CREATE [ OR REPLACE ] WAREHOUSE [ IF NOT EXISTS ] <name>
       [ [ WITH ] objectProperties ]
       [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
       [ objectParams ]

-- Example 9072
objectProperties ::=
  WAREHOUSE_TYPE = { STANDARD | 'SNOWPARK-OPTIMIZED' }
  WAREHOUSE_SIZE = { XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | XXXLARGE | X4LARGE | X5LARGE | X6LARGE }
  RESOURCE_CONSTRAINT = { MEMORY_1X | MEMORY_1X_x86 | MEMORY_16X | MEMORY_16X_x86 | MEMORY_64X | MEMORY_64X_x86 }
  MAX_CLUSTER_COUNT = <num>
  MIN_CLUSTER_COUNT = <num>
  SCALING_POLICY = { STANDARD | ECONOMY }
  AUTO_SUSPEND = { <num> | NULL }
  AUTO_RESUME = { TRUE | FALSE }
  INITIALLY_SUSPENDED = { TRUE | FALSE }
  RESOURCE_MONITOR = <monitor_name>
  COMMENT = '<string_literal>'
  ENABLE_QUERY_ACCELERATION = { TRUE | FALSE }
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <num>

-- Example 9073
objectParams ::=
  MAX_CONCURRENCY_LEVEL = <num>
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>

-- Example 9074
CREATE OR ALTER WAREHOUSE <name>
     [ [ WITH ] objectProperties ]
     [ objectParams ]

objectProperties ::=
  WAREHOUSE_TYPE = { STANDARD | 'SNOWPARK-OPTIMIZED' }
  WAREHOUSE_SIZE = { XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | XXXLARGE | X4LARGE | X5LARGE | X6LARGE }
  RESOURCE_CONSTRAINT = { MEMORY_1X | MEMORY_1X_x86 | MEMORY_16X | MEMORY_16X_x86 | MEMORY_64X | MEMORY_64X_x86 }
  MAX_CLUSTER_COUNT = <num>
  MIN_CLUSTER_COUNT = <num>
  SCALING_POLICY = { STANDARD | ECONOMY }
  AUTO_SUSPEND = { <num> | NULL }
  AUTO_RESUME = { TRUE | FALSE }
  INITIALLY_SUSPENDED = { TRUE | FALSE }
  RESOURCE_MONITOR = <monitor_name>
  COMMENT = '<string_literal>'
  ENABLE_QUERY_ACCELERATION = { TRUE | FALSE }
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <num>

objectParams ::=
  MAX_CONCURRENCY_LEVEL = <num>
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>

-- Example 9075
SET current_wh_name = (SELECT CURRENT_WAREHOUSE());

CREATE OR REPLACE WAREHOUSE my_wh
  WAREHOUSE_SIZE = 'XSMALL';

USE WAREHOUSE IDENTIFIER($current_wh_name);

-- Example 9076
CREATE OR REPLACE WAREHOUSE my_wh WITH WAREHOUSE_SIZE='X-LARGE';

-- Example 9077
CREATE OR REPLACE WAREHOUSE my_wh WAREHOUSE_SIZE=LARGE INITIALLY_SUSPENDED=TRUE;

-- Example 9078
CREATE WAREHOUSE so_warehouse WITH
  WAREHOUSE_TYPE = 'SNOWPARK-OPTIMIZED'
  WAREHOUSE_SIZE = xlarge
  RESOURCE_CONSTRAINT = 'MEMORY_16X_x86';

-- Example 9079
CREATE OR ALTER WAREHOUSE so_warehouse
  WAREHOUSE_TYPE = 'SNOWPARK_OPTIMIZED'
  WAREHOUSE_SIZE = 'X-LARGE'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86'
  AUTO_RESUME = TRUE
  COMMENT = 'Snowpark warehouse for ingestion';

-- Example 9080
CREATE OR ALTER WAREHOUSE so_warehouse
  WAREHOUSE_TYPE = 'SNOWPARK_OPTIMIZED'
  WAREHOUSE_SIZE = 'X-LARGE'
  RESOURCE_CONSTRAINT = 'MEMORY_16X_X86'
  AUTO_RESUME = FALSE
  COMMENT = 'Snowpark warehouse for ingestion (disabled for auto-resume)';

-- Example 9081
PUT file://<absolute_path_to_file>/<filename> internalStage
    [ PARALLEL = <integer> ]
    [ AUTO_COMPRESS = TRUE | FALSE ]
    [ SOURCE_COMPRESSION = AUTO_DETECT | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE ]
    [ OVERWRITE = TRUE | FALSE ]

-- Example 9082
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 9083
PUT file:///tmp/data/** @my_int_stage AUTO_COMPRESS=FALSE;

-- Example 9084
PUT file:///tmp/data/mydata.csv @my_int_stage;

-- Example 9085
PUT file:///tmp/data/orders_001.csv @%orderstiny_ext
  AUTO_COMPRESS = FALSE;

-- Example 9086
PUT file:///tmp/data/orders_*01.csv @my_int_stage
  AUTO_COMPRESS = FALSE;

-- Example 9087
PUT 'file:///tmp/data/orders 001.csv' @my_int_stage
  AUTO_COMPRESS = FALSE;

-- Example 9088
PUT file://C:\temp\data\mydata.csv @~
  AUTO_COMPRESS = TRUE;

-- Example 9089
PUT 'file://C:/temp/data/my data.csv' @my_int_stage
  AUTO_COMPRESS = TRUE;

-- Example 9090
LIST { internalStage | externalStage } [ PATTERN = '<regex_pattern>' ]

-- Example 9091
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 9092
externalStage ::=
    @[<namespace>.]<ext_stage_name>[/<path>]

