-- Example 10901
prompt_format="[#FF0000][user]@[#00FF00][database][schema][#0000FF][warehouse]"

-- Example 10902
user#> !help

+------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------+
| Command    | Use                                       | Aliases     | Description                                                                                |
|------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------|
| !abort     | !abort <query id>                         |             | Abort a query                                                                              |
| !connect   | !connect <connection_name>                |             | Create a new connection                                                                    |
| !define    | !define <variable>=<value>                |             | Define a variable as the given value                                                       |
| !edit      | !edit <query>                             |             | Opens up a text editor. Useful for writing longer queries. Defaults to last query          |
| !exit      | !exit                                     | !disconnect | Drop the current connection                                                                |
| !help      | !help                                     | !helps, !h  | Show the client help.                                                                      |
| !options   | !options                                  | !opts       | Show all options and their values                                                          |
| !pause     | !pause                                    |             | Pauses running queries.                                                                    |
| !print     | !print <message>                          |             | Print given text                                                                           |
| !queries   | !queries help, <filter>=<value>, <filter> |             | Lists queries matching the specified filters. Write <!queries> help for a list of filters. |
| !quit      | !quit                                     | !q          | Drop all connections and quit SnowSQL                                                      |
| !rehash    | !rehash                                   |             | Refresh autocompletion                                                                     |
| !result    | !result <query id>                        |             | See the result of a query                                                                  |
| !set       | !set <option>=<value>                     |             | Set an option to the given value                                                           |
| !source    | !source <filename>, <url>                 | !load       | Execute given sql file                                                                     |
| !spool     | !spool <filename>, off                    |             | Turn on or off writing results to file                                                     |
| !system    | !system <system command>                  |             | Run a system command in the shell                                                          |
| !variables | !variables                                | !vars       | Show all variables and their values                                                        |
+------------+-------------------------------------------+-------------+--------------------------------------------------------------------------------------------+

-- Example 10903
[variables]
<variable_name>=<variable_value>

-- Example 10904
[variables]
tablename=CENUSTRACKONE

-- Example 10905
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=$DB_KEY

-- Example 10906
$ snowsql ... -D tablename=CENUSTRACKONE --variable db_key=%DB_KEY%

-- Example 10907
user#> !define tablename=CENUSTRACKONE

-- Example 10908
[options]
variable_substitution = True

-- Example 10909
$ snowsql ... -o variable_substitution=true

-- Example 10910
user#> !set variable_substitution=true

-- Example 10911
user#> !define snowshell=bash

user#> !set variable_substitution=true

user#> select '&snowshell';

+--------+
| 'BASH' |
|--------|
| bash   |
+--------+

-- Example 10912
user#> !define snowshell=bash

user#> !set variable_substitution=false

user#> select '&snowshell';

+--------------+
| '&SNOWSHELL' |
|--------------|
| &snowshell   |
+--------------+

-- Example 10913
select '&z';

Variable z is not defined

-- Example 10914
user#> !define snowshell=bash

user#> !set variable_substitution=true

select '&{snowshell}_shell';

+--------------+
| 'BASH_SHELL' |
|--------------|
| bash_shell   |
+--------------+

-- Example 10915
user#> !set variable_substitution=true

user#> select '&notsubstitution';

Variable notsubstitution is not defined

user#> select '&&notsubstitution';

+--------------------+
| '&NOTSUBSTITUTION' |
|--------------------|
| &notsubstitution   |
+--------------------+

-- Example 10916
user#> !variables

+-----------+-------+
| Name      | Value |
|-----------+-------|
| snowshell | bash  |
+-----------+-------+

-- Example 10917
user#> insert into a values(1),(2),(3);

+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
3 Row(s) produced. Time Elapsed: 0.950s

user#> !set variable_substitution=true

user#> select &__rowcount;

+---+
| 3 |
|---|
| 3 |
+---+

-- Example 10918
user#> !set variable_substitution=true

user#> select * from a;

user#> select '&__sfqid';

+----------------------------------------+
| 'A5F35B56-49A2-4437-BA0E-998496CE793E' |
|----------------------------------------|
| a5f35b56-49a2-4437-ba0e-998496ce793e   |
+----------------------------------------+

-- Example 10919
snowsql -a myorganization-myaccount -u jsmith -f /tmp/input_script.sql -o output_file=/tmp/output.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv

-- Example 10920
user#> !source example.sql

-- Example 10921
snowsql -c my_example_connection -d sales_db -s public -q 'select * from mytable limit 10' -o output_format=csv -o header=false -o timing=false -o friendly=false  > output_file.csv

-- Example 10922
snowsql -c my_example_connection -d sales_db -s public -q "select * from mytable limit 10" -o output_format=csv -o header=false -o timing=false -o friendly=false  > output_file.csv

-- Example 10923
[user]#[warehouse]@[database].[schema]>

-- Example 10924
jdoe#DATALOAD@BOOKS_DB.PUBLIC>

-- Example 10925
jdoe#DATALOAD@BOOKS_DB.PUBLIC> !set prompt_format=[#FF0000][user].[role].[#00FF00][database].[schema].[#0000FF][warehouse]>

-- Example 10926
user#> !abort 77589bd1-bcbf-4ec8-9ebc-6c949b00614d;

-- Example 10927
[connections.my_example_connection]
...

-- Example 10928
user#> !connect my_example_connection

-- Example 10929
user#> !print Include This Text

-- Example 10930
!queries session

-- Example 10931
!queries amount=20

-- Example 10932
!queries amount=20 duration=200

-- Example 10933
!queries warehouse=mywh

-- Example 10934
user#> !queries session

+-----+--------------------------------------+----------+-----------+----------+
| VAR | QUERY ID                             | SQL TEXT | STATUS    | DURATION |
|-----+--------------------------------------+----------+-----------+----------|
| &0  | acbd6778-c68c-4e79-a977-510b2d8c08f1 | select 1 | SUCCEEDED |       19 |
+-----+--------------------------------------+----------+-----------+----------+

user#> !result &0

+---+
| 1 |
|---|
| 1 |
+---+

user#> !result acbd6778-c68c-4e79-a977-510b2d8c08f1

+---+
| 1 |
|---|
| 1 |
+---+

-- Example 10935
user#> !result 77589bd1-bcbf-4ec8-9ebc-6c949b00614d;

-- Example 10936
user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 1000              |
 ...
+-----------------------+-------------------+

user#> !set rowset_size=500

user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 500               |
 ...
+-----------------------+-------------------+

user#> !set rowset_size=1000

user#> !options

+-----------------------+-------------------+
| Name                  | Value             |
|-----------------------+-------------------|
 ...
| rowset_size           | 1000              |
 ...
+-----------------------+-------------------+

-- Example 10937
user#> !source example.sql

user#> !load /tmp/scripts/example.sql

user#> !load http://www.example.com/sql_text.sql

-- Example 10938
user#> select 1 num;

+-----+
| NUM |
|-----|
|   1 |
+-----+

user#> !spool /tmp/spool_example

user#> select 2 num;

+---+
| 2 |
|---|
| 2 |
+---+

user#> !spool off

user#> select 3 num;

+---+
| 3 |
|---|
| 3 |
+---+

user#> !exit

Goodbye!

$ cat /tmp/spool_example

+---+
| 2 |
|---|
| 2 |
+---+

-- Example 10939
user#> !set output_format=csv

user#> !spool /tmp/spool_example

-- Example 10940
user#> !system ls ~

-- Example 10941
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

-- Example 10942
create function mask_bits(...)
    ...
    as
    $$
    var masked = (x & y);
    ...
    $$;

-- Example 10943
!set variable_substitution=false;

-- Example 10944
ALTER USER [ IF EXISTS ] [ <name> ] RENAME TO <new_name>

ALTER USER [ IF EXISTS ] [ <name> ] RESET PASSWORD

ALTER USER [ IF EXISTS ] [ <name> ] ABORT ALL QUERIES

ALTER USER [ IF EXISTS ] [ <name> ] ADD DELEGATED AUTHORIZATION OF ROLE <role_name> TO SECURITY INTEGRATION <integration_name>

ALTER USER [ IF EXISTS ] [ <name> ] REMOVE DELEGATED { AUTHORIZATION OF ROLE <role_name> | AUTHORIZATIONS } FROM SECURITY INTEGRATION <integration_name>

ALTER USER [ IF EXISTS ] [ <name> ] SET { AUTHENTICATION | PASSWORD | SESSION } POLICY <policy_name>

ALTER USER [ IF EXISTS ] [ <name> ] UNSET { AUTHENTICATION | PASSWORD | SESSION } POLICY

ALTER USER [ IF EXISTS ] [ <name> ] SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER USER [ IF EXISTS ] [ <name> ] UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER USER [ IF EXISTS ] [ <name> ] SET { [ objectProperties ] [ objectParams ] [ sessionParams ] }

ALTER USER [ IF EXISTS ] [ <name> ] UNSET { <object_property_name> | <object_param_name> | <session_param_name> } [ , ... ]

-- Example 10945
objectProperties ::=
    PASSWORD = '<string>'
    LOGIN_NAME = <string>
    DISPLAY_NAME = <string>
    FIRST_NAME = <string>
    MIDDLE_NAME = <string>
    LAST_NAME = <string>
    EMAIL = <string>
    MUST_CHANGE_PASSWORD = TRUE | FALSE
    DISABLED = TRUE | FALSE
    DAYS_TO_EXPIRY = <integer>
    MINS_TO_UNLOCK = <integer>
    DEFAULT_WAREHOUSE = <string>
    DEFAULT_NAMESPACE = <string>
    DEFAULT_ROLE = <string>
    DEFAULT_SECONDARY_ROLES = ( 'ALL' )
    MINS_TO_BYPASS_MFA = <integer>
    DISABLE_MFA = TRUE | FALSE
    RSA_PUBLIC_KEY = <string>
    RSA_PUBLIC_KEY_FP = <string>
    RSA_PUBLIC_KEY_2 = <string>
    RSA_PUBLIC_KEY_2_FP = <string>
    TYPE = PERSON | SERVICE | LEGACY_SERVICE | NULL
    COMMENT = '<string>'

-- Example 10946
objectParams ::=
    ENABLE_PERSONAL_DATABASE = { TRUE | FALSE }
    ENABLE_UNREDACTED_QUERY_SYNTAX_ERROR = TRUE | FALSE
    ENABLE_UNREDACTED_SECURE_OBJECT_ERROR = TRUE | FALSE
    NETWORK_POLICY = <string>
    PREVENT_UNLOAD_TO_INLINE_URL = TRUE | FALSE
    PREVENT_UNLOAD_TO_INTERNAL_STAGES = TRUE | FALSE

-- Example 10947
sessionParams ::=
    ABORT_DETACHED_QUERY = TRUE | FALSE
    AUTOCOMMIT = TRUE | FALSE
    BINARY_INPUT_FORMAT = <string>
    BINARY_OUTPUT_FORMAT = <string>
    DATE_INPUT_FORMAT = <string>
    DATE_OUTPUT_FORMAT = <string>
    DEFAULT_NULL_ORDERING = <string>
    ERROR_ON_NONDETERMINISTIC_MERGE = TRUE | FALSE
    ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE | FALSE
    JSON_INDENT = <num>
    LOCK_TIMEOUT = <num>
    QUERY_TAG = <string>
    ROWS_PER_RESULTSET = <num>
    S3_STAGE_VPCE_DNS_NAME = <string>
    SEARCH_PATH = <string>
    SIMULATED_DATA_SHARING_CONSUMER = <string>
    STATEMENT_TIMEOUT_IN_SECONDS = <num>
    STRICT_JSON_OUTPUT = TRUE | FALSE
    TIMESTAMP_DAY_IS_ALWAYS_24H = TRUE | FALSE
    TIMESTAMP_INPUT_FORMAT = <string>
    TIMESTAMP_LTZ_OUTPUT_FORMAT = <string>
    TIMESTAMP_NTZ_OUTPUT_FORMAT = <string>
    TIMESTAMP_OUTPUT_FORMAT = <string>
    TIMESTAMP_TYPE_MAPPING = <string>
    TIMESTAMP_TZ_OUTPUT_FORMAT = <string>
    TIMEZONE = <string>
    TIME_INPUT_FORMAT = <string>
    TIME_OUTPUT_FORMAT = <string>
    TRANSACTION_DEFAULT_ISOLATION_LEVEL = <string>
    TWO_DIGIT_CENTURY_START = <num>
    UNSUPPORTED_DDL_ACTION = <string>
    USE_CACHED_RESULT = TRUE | FALSE
    WEEK_OF_YEAR_POLICY = <num>
    WEEK_START = <num>

-- Example 10948
ALTER USER user1 RENAME TO user2;

-- Example 10949
ALTER USER user1 SET PASSWORD = 'H8MZRqa8gEe/kvHzvJ+Giq94DuCYoQXmfbb$Xnt' MUST_CHANGE_PASSWORD = TRUE;

-- Example 10950
ALTER USER user1 SET TYPE = SERVICE;

-- Example 10951
ALTER USER user1 UNSET COMMENT;

-- Example 10952
ALTER USER user1 SET DEFAULT_SECONDARY_ROLES = ();

-- Example 10953
ALTER USER user1 UNSET DEFAULT_SECONDARY_ROLES;

-- Example 10954
ALTER USER user1 SET DEFAULT_SECONDARY_ROLES = ('ALL');

-- Example 10955
SHOW WAREHOUSES
  [ LIKE '<pattern>' ]
  [ WITH PRIVILEGES <objectPrivilege> [ , <objectPrivilege> [ , ... ] ] ]

-- Example 10956
SHOW WAREHOUSES LIKE 'test%';

-- Example 10957
+---------------+-----------+--------------------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+----------+-----------------+---------------------+
| name          | state     | type               | size    | min_cluster_count | max_cluster_count | started_clusters | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment | enable_query_acceleration | query_acceleration_max_scale_factor | resource_monitor | actives | pendings | failed | suspended | uuid     | scaling_policy | budget   | owner_role_type | resource_constraint |
|---------------+-----------+--------------------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+----------|-----------------|---------------------+
| TEST1         | SUSPENDED | STANDARD           | Medium  |                 1 |                 1 |                0 |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-01-27 14:57:07.768 -0800 | 2023-05-10 16:17:49.258 -0700 | 2023-05-10 16:17:49.258 -0700 | MY_ROLE      |         | true                      |                                   8 | null             |       0 |        0 |      0 |         4 | 76064    | STANDARD       | NULL     | ROLE            | NULL                +
| TEST2         | SUSPENDED | STANDARD           | X-Small |                 1 |                 1 |                0 |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-01-27 14:57:07.953 -0800 | 1969-12-31 16:00:00.000 -0800 | 2023-01-27 14:57:08.356 -0800 | MY_ROLE      |         | true                      |                                  16 | MYTEST_RM        |       0 |        0 |      0 |         1 | 76116    | STANDARD       | MYBUDGET | ROLE            | NULL                +
| TEST3         | SUSPENDED | STANDARD           | Small   |                 1 |                 1 |                0 |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-08-08 10:26:45.534 -0700 | 2023-08-08 10:26:45.681 -0700 | 2023-08-08 10:26:45.681 -0700 | MY_ROLE      |         | false                     |                                   8 | null             |       0 |        0 |      0 |         2 | 19464517 | STANDARD       | NULL     | ROLE            | NULL                +
| TEST4         | RESUMING  | SNOWPARK-OPTIMIZED | Large   |                 1 |                 1 |                0 |       0 |      0 | N          | Y          |          600 | true        |           |              |           |       | 2023-09-21 17:29:58.165 -0700 | 2023-09-21 17:29:58.165 -0700 | 2023-09-21 17:29:58.207 -0700 | MY_ROLE      |         | false                     |                                   8 | null             |       0 |        0 |      0 |         0 | 19464585 | STANDARD       | NULL     | ROLE            | MEMORY_16X_X86      +
+---------------+-----------+--------------------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+----------+-----------------+---------------------+

-- Example 10958
SHOW WAREHOUSES WITH PRIVILEGES MODIFY, OPERATE;

-- Example 10959
+------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+--------------------------+-----------------+---------------------+
| name                         | state     | type     | size    | min_cluster_count | max_cluster_count | started_clusters | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment                                         | enable_query_acceleration | query_acceleration_max_scale_factor | resource_monitor | actives | pendings | failed | suspended | uuid     | scaling_policy | budget                   | owner_role_type |
|------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+--------------------------+-----------------+---------------------+
| TEST_WH                      | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |                0 |       0 |      0 | Y          | Y          |          600 | true        |           |              |           |       | 2023-01-27 14:57:07.768 -0800 | 2024-07-30 13:39:24.118 -0700 | 2024-07-30 13:39:24.118 -0700 | TEST_ROLE    |                                                 | true                      |                                  32 | TEST_RM          |       0 |        0 |      0 |         1 | 76056    | STANDARD       | KATS_RENAMED_TEST_BUDGET | ROLE            | NULL                +
| SNOWPARK_DEMO                | SUSPENDED | STANDARD | X-Large |                 1 |                 1 |                0 |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-01-27 14:57:07.903 -0800 | 2023-04-10 11:47:03.146 -0700 | 2023-04-10 11:47:03.146 -0700 | ACCOUNTADMIN | Created by straut for Snowpark quickstart       | false                     |                                   8 | null             |       0 |        0 |      0 |        16 | 76104    | STANDARD       | NULL                     | ROLE            | NULL                +
| TASTY_DEV_WH                 | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |                0 |       0 |      0 | N          | N          |           60 | true        |           |              |           |       | 2023-10-25 16:25:43.681 -0700 | 2023-10-25 16:25:43.681 -0700 | 2023-10-25 16:25:43.711 -0700 | SYSADMIN     | developer warehouse for tasty bytes             | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 19464633 | STANDARD       | NULL                     | ROLE            | NULL                +
| TB_DOCS_WH                   | SUSPENDED | STANDARD | X-Small |                 1 |                 1 |                0 |       0 |      0 | N          | N          |           60 | true        |           |              |           |       | 2024-07-24 15:02:32.172 -0700 | 2024-07-24 15:33:30.502 -0700 | 2024-07-24 15:33:30.502 -0700 | SYSADMIN     | developer warehouse for tasty bytes             | false                     |                                   8 | null             |       0 |        0 |      0 |         1 | 19465097 | STANDARD       | NULL                     | ROLE            | NULL                +
+------------------------------+-----------+----------+---------+-------------------+-------------------+------------------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+-------------------------------------------------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+----------+----------------+--------------------------+-----------------+---------------------+

-- Example 10960
CREATE OR REPLACE PROCEDURE started_and_suspended_warehouses()
  RETURNS TABLE(name VARCHAR, status VARCHAR, type VARCHAR, size VARCHAR)
  LANGUAGE SQL
  AS
  $$
    DECLARE
      res RESULTSET;
    BEGIN
      SHOW WAREHOUSES;
      res := (SELECT "name" name, "state" state, "type" type, "size" size
        FROM TABLE(RESULT_SCAN(LAST_QUERY_ID(-1)))
        WHERE "state" IN ('STARTED','SUSPENDED')
        ORDER BY "state", "name");
      RETURN TABLE(res);
    END;
  $$
  ;

CALL started_and_suspended_warehouses();

-- Example 10961
+------------------------------+-----------+--------------------+---------+
| NAME                         | STATUS    | TYPE               | SIZE    |
|------------------------------+-----------+--------------------+---------|
| COMPUTE_WH                   | STARTED   | STANDARD           | X-Small |
| DEFAULT_SIZE                 | SUSPENDED | STANDARD           | Small   |
| DEFAULT_SIZE_2               | SUSPENDED | STANDARD           | X-Small |
| MEDIUM                       | SUSPENDED | SNOWPARK-OPTIMIZED | Medium  |
| PRIV_WH                      | SUSPENDED | STANDARD           | X-Small |
| SYSTEM$STREAMLIT_NOTEBOOK_WH | SUSPENDED | STANDARD           | X-Small |
| XSMALL                       | SUSPENDED | STANDARD           | Medium  |
+------------------------------+-----------+--------------------+---------+

-- Example 10962
ALTER WAREHOUSE [ IF EXISTS ] [ <name> ] { SUSPEND | RESUME [ IF SUSPENDED ] }

ALTER WAREHOUSE [ IF EXISTS ] [ <name> ] ABORT ALL QUERIES

ALTER WAREHOUSE [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER WAREHOUSE [ IF EXISTS ] <name> SET [ objectProperties ]
                                         [ objectParams ]

ALTER WAREHOUSE [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER WAREHOUSE [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER WAREHOUSE [ IF EXISTS ] <name> UNSET { <property_name> | <param_name> } [ , ... ]

-- Example 10963
objectProperties ::=
  WAREHOUSE_TYPE = { STANDARD | 'SNOWPARK-OPTIMIZED' }
  WAREHOUSE_SIZE = { XSMALL | SMALL | MEDIUM | LARGE | XLARGE | XXLARGE | XXXLARGE | X4LARGE | X5LARGE | X6LARGE }
  RESOURCE_CONSTRAINT = { MEMORY_1X | MEMORY_1X_x86 | MEMORY_16X | MEMORY_16X_x86 | MEMORY_64X | MEMORY_64X_x86 }
  WAIT_FOR_COMPLETION = { TRUE | FALSE }
  MAX_CLUSTER_COUNT = <num>
  MIN_CLUSTER_COUNT = <num>
  SCALING_POLICY = { STANDARD | ECONOMY }
  AUTO_SUSPEND = { <num> | NULL }
  AUTO_RESUME = { TRUE | FALSE }
  RESOURCE_MONITOR = <monitor_name>
  COMMENT = '<string_literal>'
  ENABLE_QUERY_ACCELERATION = { TRUE | FALSE }
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = <num>

-- Example 10964
objectParams ::=
  MAX_CONCURRENCY_LEVEL = <num>
  STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <num>
  STATEMENT_TIMEOUT_IN_SECONDS = <num>

-- Example 10965
ALTER WAREHOUSE mywh SUSPEND;

-- Example 10966
ALTER WAREHOUSE IF EXISTS wh1 RENAME TO wh2;

-- Example 10967
ALTER WAREHOUSE my_wh RESUME;

ALTER WAREHOUSE my_wh SET warehouse_size=MEDIUM;

