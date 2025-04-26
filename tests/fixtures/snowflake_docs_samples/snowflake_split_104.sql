-- Example 6949
SELECT SYSTEM$GLOBAL_ACCOUNT_SET_PARAMETER('myorg.account1',
  'ENABLE_ACCOUNT_DATABASE_REPLICATION', 'true');

SELECT SYSTEM$GLOBAL_ACCOUNT_SET_PARAMETER('myorg.account2',
  'ENABLE_ACCOUNT_DATABASE_REPLICATION', 'true');

-- Example 6950
SYSTEM$INITIATE_MOVE_ORGANIZATION_ACCOUNT(
    '<temp_name>' ,
    '<region>' ,
    { 'ALL' | '<object> [, <object> ...]' } )

-- Example 6951
SELECT SYSTEM$INITIATE_MOVE_ORGANIZATION_ACCOUNT('TEMP_ACCT', 'aws_us_west_2', 'ALL');

-- Example 6952
SYSTEM$INTERNAL_STAGES_PUBLIC_ACCESS_STATUS()

-- Example 6953
USE ROLE accountadmin;

SELECT SYSTEM$INTERNAL_STAGES_PUBLIC_ACCESS_STATUS();

-- Example 6954
Public Access to internal stages is blocked

-- Example 6955
SYSTEM$IS_APPLICATION_INSTALLED_FROM_SAME_ACCOUNT()

-- Example 6956
SELECT SYSTEM$IS_APPLICATION_INSTALLED_FROM_SAME_ACCOUNT();

-- Example 6957
SYSTEM$IS_APPLICATION_SHARING_EVENTS_WITH_PROVIDER()

-- Example 6958
SELECT SYSTEM$IS_APPLICATION_SHARING_EVENTS_WITH_PROVIDER();

-- Example 6959
SYSTEM$IS_GLOBAL_DATA_SHARING_ENABLED_FOR_ACCOUNT( '<account_name>' )

-- Example 6960
SELECT SYSTEM$IS_GLOBAL_DATA_SHARING_ENABLED_FOR_ACCOUNT('my_account');

-- Example 6961
+------------------------------------------------------------------------+
| SYSTEM$SYSTEM$IS_GLOBAL_DATA_SHARING_ENABLED_FOR_ACCOUNT('my_account') |
|------------------------------------------------------------------------|
| TRUE                                                                   |
+------------------------------------------------------------------------+

-- Example 6962
SYSTEM$LAST_CHANGE_COMMIT_TIME( '<object_name>'  )

-- Example 6963
CALL SYSTEM$LAST_CHANGE_COMMIT_TIME('mytable');

+--------------------------------+
| SYSTEM$LAST_CHANGE_COMMIT_TIME |
|--------------------------------|
|            1661920053987000000 |
+--------------------------------+

-- Example 6964
SELECT SYSTEM$LAST_CHANGE_COMMIT_TIME('mytable');

+--------------------------------+
| SYSTEM$LAST_CHANGE_COMMIT_TIME |
|--------------------------------|
|            1661920118648000000 |
+--------------------------------+

INSERT INTO mytable VALUES (2,100), (3,300);

SELECT SYSTEM$LAST_CHANGE_COMMIT_TIME('mytable');

+--------------------------------+
| SYSTEM$LAST_CHANGE_COMMIT_TIME |
|--------------------------------|
|            1661920131893000000 |
+--------------------------------+

-- Example 6965
SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('<group_name>')

-- Example 6966
SELECT SYSTEM$LINK_ACCOUNT_OBJECTS_BY_NAME('myfg');

-- Example 6967
SYSTEM$LIST_APPLICATION_RESTRICTED_FEATURES( '<app_name>' )

-- Example 6968
"{""external_data"":{""allowed_cloud_providers"":""all""}}"

-- Example 6969
SELECT SYSTEM$LIST_APPLICATION_RESTRICTED_FEATURES('hello_snowflake_app');

-- Example 6970
[
    {"external_data":{"allowed_cloud_providers":"all"}}
]

-- Example 6971
SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG( '<catalog_integration_name>'
  [ , '<parent_namespace>', <levels> ] )

-- Example 6972
[
  {
    "namespace": "<namespace_identifier>",
    "name": "<table_name>"
  },
  {
    "namespace": "<namespace_identifier>",
    "name": "<table_name_n>"
  },
]

-- Example 6973
SELECT SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG('myCatalogIntegration');

-- Example 6974
SELECT SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG('myCatalogIntegration', '', 0);

-- Example 6975
SELECT SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG('myCatalogIntegration', 'db1', 0);

-- Example 6976
SELECT SYSTEM$LIST_ICEBERG_TABLES_FROM_CATALOG('myCatalogIntegration', 'db1', 3);

-- Example 6977
SYSTEM$LIST_NAMESPACES_FROM_CATALOG( '<catalog_integration_name>'
  [ , '<parent_namespace>', <levels> ] )

-- Example 6978
[
  "<namespace_identifier>",
  "<namespace_identifier_n>"
]

-- Example 6979
SELECT SYSTEM$LIST_NAMESPACES_FROM_CATALOG('my_catalog_integration');

-- Example 6980
SELECT SYSTEM$LIST_NAMESPACES_FROM_CATALOG('my_catalog_integration', '', 0);

-- Example 6981
SELECT SYSTEM$LIST_NAMESPACES_FROM_CATALOG('my_catalog_integration', 'db1');

-- Example 6982
SELECT SYSTEM$LIST_NAMESPACES_FROM_CATALOG('my_catalog_integration', 'db1', 3);

-- Example 6983
SYSTEM$LOG('<level>', <message>);

SYSTEM$LOG_TRACE(<message>);
SYSTEM$LOG_DEBUG(<message>);
SYSTEM$LOG_INFO(<message>);
SYSTEM$LOG_WARN(<message>);
SYSTEM$LOG_ERROR(<message>);
SYSTEM$LOG_FATAL(<message>);

-- Example 6984
-- The following calls are equivalent.
-- Both log information-level messages.
SYSTEM$LOG('info', 'Information-level message');
SYSTEM$LOG_INFO('Information-level message');

-- The following calls are equivalent.
-- Both log error messages.
SYSTEM$LOG('error', 'Error message');
SYSTEM$LOG_ERROR('Error message');


-- The following calls are equivalent.
-- Both log warning messages.
SYSTEM$LOG('warning', 'Warning message');
SYSTEM$LOG_WARN('Warning message');

-- The following calls are equivalent.
-- Both log debug messages.
SYSTEM$LOG('debug', 'Debug message');
SYSTEM$LOG_DEBUG('Debug message');

-- The following calls are equivalent.
-- Both log trace messages.
SYSTEM$LOG('trace', 'Trace message');
SYSTEM$LOG_TRACE('Trace message');

-- The following calls are equivalent.
-- Both log fatal messages.
SYSTEM$LOG('fatal', 'Fatal message');
SYSTEM$LOG_FATAL('Fatal message');

-- Example 6985
SYSTEM$MIGRATE_SAML_IDP_REGISTRATION( '<integration_name>', '<issuer>' )

-- Example 6986
SELECT SYSTEM$MIGRATE_SAML_IDP_REGISTRATION('my_fed_integration', 'http://my_idp.com');

-- Example 6987
+---------------------------------------------------------------------------------+
| SYSTEM$MIGRATE_SAML_IDP_REGISTRATION('MY_FED_INTEGRATION', 'HTTP://MY_IDP.COM') |
+---------------------------------------------------------------------------------+
| SUCCESS : [MY_FED_INTEGRATION] Fed SAML integration created                     |
+---------------------------------------------------------------------------------+

-- Example 6988
DESC INTEGRATION my_fed_integration;

-- Example 6989
SHOW PARAMETERS;

-- Example 6990
SHOW PARAMETERS IN DATABASE mydb;

SHOW PARAMETERS IN WAREHOUSE mywh;

-- Example 6991
SHOW PARAMETERS IN ACCOUNT;

-- Example 6992
SHOW PARAMETERS LIKE '%time%';

-- Example 6993
SHOW PARAMETERS LIKE 'time%' IN ACCOUNT;

-- Example 6994
CREATE TABLE test(c1 INTEGER, c2 STRING, c3 STRING COLLATE 'en-cs');

CREATE TABLE test(c1 INTEGER, c2 STRING COLLATE 'en-ci', c3 STRING COLLATE 'en-cs');

-- Example 6995
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 6996
{
  "certificate": "",
  "issuer": "",
  "ssoUrl": "",
  "type"  : "",
  "label" : ""
}

-- Example 6997
Shared view consumer simulation requires that the executing role owns the view.

-- Example 6998
alter session set TIMESTAMP_DAY_IS_ALWAYS_24H = true;

-- With DST beginning on 2018-03-11 at 2 AM, America/Los_Angeles time zone
select dateadd(day, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ), dateadd(day, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ);

+-------------------------------------------------------+-------------------------------------------------------+
| DATEADD(DAY, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ) | DATEADD(DAY, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ) |
|-------------------------------------------------------+-------------------------------------------------------|
| 2018-03-11 10:00:00.000 -0700                         | 2018-11-04 08:00:00.000 -0800                         |
+-------------------------------------------------------+-------------------------------------------------------+

alter session set TIMESTAMP_DAY_IS_ALWAYS_24H = false;

select dateadd(day, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ), dateadd(day, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ);

+-------------------------------------------------------+-------------------------------------------------------+
| DATEADD(DAY, 1, '2018-03-10 09:00:00'::TIMESTAMP_LTZ) | DATEADD(DAY, 1, '2018-11-03 09:00:00'::TIMESTAMP_LTZ) |
|-------------------------------------------------------+-------------------------------------------------------|
| 2018-03-11 09:00:00.000 -0700                         | 2018-11-04 09:00:00.000 -0800                         |
+-------------------------------------------------------+-------------------------------------------------------+

-- Example 6999
SYSTEM$PIPE_FORCE_RESUME( '<pipe_name>' , '[ STALENESS_CHECK_OVERRIDE ] [ , OWNERSHIP_TRANSFER_CHECK_OVERRIDE ]')

-- Example 7000
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.mypipe');

-- Example 7001
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema."myPipe"');

-- Example 7002
SELECT SYSTEM$PIPE_FORCE_RESUME('mydb.myschema.stalepipe','staleness_check_override, ownership_transfer_check_override');

-- Example 7003
ALTER PIPE [ IF EXISTS ] <name> SET { [ objectProperties ]
                                      [ COMMENT = '<string_literal>' ] }

ALTER PIPE <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER PIPE <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER PIPE [ IF EXISTS ] <name> UNSET { <property_name> | COMMENT } [ , ... ]

ALTER PIPE [ IF EXISTS ] <name> REFRESH { [ PREFIX = '<path>' ] [ MODIFIED_AFTER = <start_time> ] }

-- Example 7004
objectProperties ::=
  PIPE_EXECUTION_PAUSED = TRUE | FALSE

-- Example 7005
alter pipe mypipe SET PIPE_EXECUTION_PAUSED = true;

-- Example 7006
alter pipe mypipe SET COMMENT = "Pipe for North American sales data";

-- Example 7007
CREATE PIPE mypipe AS COPY INTO mytable FROM @mystage/path1/;

-- Example 7008
ALTER PIPE mypipe REFRESH;

-- Example 7009
ALTER PIPE mypipe REFRESH PREFIX='d1/';

-- Example 7010
ALTER PIPE mypipe REFRESH PREFIX='d1/' MODIFIED_AFTER='2018-07-30T13:56:46-07:00';

-- Example 7011
SYSTEM$PIPE_REBINDING_WITH_NOTIFICATION( '<pipe_name>')

-- Example 7012
SELECT SYSTEM$PIPE_REBINDING_WITH_NOTIFICATION_CHANNEL('mydb.myschema.mypipe');

-- Example 7013
SYSTEM$PIPE_STATUS( '<pipe_name>' )

-- Example 7014
SELECT SYSTEM$PIPE_STATUS('mydb.myschema.mypipe');

+---------------------------------------------------+
| SYSTEM$PIPE_STATUS('MYDB.MYSCHEMA.MYPIPE')        |
|---------------------------------------------------|
| {"executionState":"RUNNING","pendingFileCount":0} |
+---------------------------------------------------+

-- Example 7015
SELECT SYSTEM$PIPE_STATUS('mydb.myschema."myPipe"');

+---------------------------------------------------+
| SYSTEM$PIPE_STATUS('MYDB.MYSCHEMA."MYPIPE"')      |
|---------------------------------------------------|
| {"executionState":"RUNNING","pendingFileCount":0} |
+---------------------------------------------------+

