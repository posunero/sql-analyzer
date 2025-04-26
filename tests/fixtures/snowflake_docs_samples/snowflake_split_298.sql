-- Example 19944
const snowflake=require('snowflake-sdk');
snowflake.configure({ useEnvProxy: false });

-- Example 19945
var connection = snowflake.createConnection({
      account: "account",
      username: "user",
      password: "password",
      proxyHost: "localhost",
      proxyPort: 3128,
      proxyUser: "myname",
      proxyPassword: "mypass"
});

-- Example 19946
var connection = snowflake.createConnection({
      account: "account",
      username: "user",
      password: "password",
      proxyHost: "localhost",
      proxyPort: 3128,
      proxyUser: "myname",
      proxyPassword: "mypass",
      proxyProtocol: "https"
});

-- Example 19947
connection.destroy(function(err, conn) {
  if (err) {
    console.error('Unable to disconnect: ' + err.message);
  } else {
    console.log('Disconnected connection with id: ' + connection.getId());
  }
});

-- Example 19948
[HKEY_LOCAL_MACHINE\SOFTWARE\Snowflake\Driver]

-- Example 19949
[HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI\<DSN_NAME>]

[HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\<DSN_NAME>]

-- Example 19950
[HKEY_CURRENT_USER\SOFTWARE\WOW6432NODE\ODBC\ODBC.INI\<DSN_NAME>]

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\ODBC\ODBC.INI\<DSN_NAME>]

-- Example 19951
Requested conversion is not supported
Cannot get the current row value of column

-- Example 19952
no_proxy=localhost,.example.com,myorganization-myaccount.snowflakecomputing.com,192.168.1.15,192.168.1.16

-- Example 19953
driver={SnowflakeDSIIDriver};server=myorganization-myaccount.snowflakecomputing.com;uid=myloginname;pwd=mypassword;database=mydatabase;schema=myschema;warehouse=mywarehouse;role=myrole;...

-- Example 19954
[connection]
Description = SnowflakeDB
Driver      = SnowflakeDSIIDriver
Locale      = en-US
server      = myorganization-myaccount.snowflakecomputing.com
proxy       = http://proxyserver.company:80
no_proxy    = .amazonaws.com

-- Example 19955
export http_proxy=http://proxyserver.example.com:80
export https_proxy=http://proxyserver.example.com:80

-- Example 19956
export https_proxy=http://username:password@proxyserver.example.com:80

-- Example 19957
set http_proxy=http://proxyserver.example.com:80
set https_proxy=http://proxyserver.example.com:80

-- Example 19958
set https_proxy=http://username:password@proxyserver.example.com:80

-- Example 19959
EnablePidLogFileNames = true  # Appends the process ID to each log file
LogFileSize = 30,145,728      # Sets log files size to 30MB
LogFileCount = 100            # Saves the 100 most recent log files

-- Example 19960
{
  "common": {
    "log_level": "DEBUG",
    "log_path": "/home/user/logs"
  }
}

-- Example 19961
ALTER TABLE [ IF EXISTS ] <name> RENAME TO <new_table_name>

ALTER TABLE [ IF EXISTS ] <name> SWAP WITH <target_table_name>

ALTER TABLE [ IF EXISTS ] <name> { clusteringAction | tableColumnAction | constraintAction  }

ALTER TABLE [ IF EXISTS ] <name> dataMetricFunctionAction

ALTER TABLE [ IF EXISTS ] <name> dataGovnPolicyTagAction

ALTER TABLE [ IF EXISTS ] <name> extTableColumnAction

ALTER TABLE [ IF EXISTS ] <name> searchOptimizationAction

ALTER TABLE [ IF EXISTS ] <name> SET
  [ DATA_RETENTION_TIME_IN_DAYS = <integer> ]
  [ MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer> ]
  [ CHANGE_TRACKING = { TRUE | FALSE  } ]
  [ DEFAULT_DDL_COLLATION = '<collation_specification>' ]
  [ ENABLE_SCHEMA_EVOLUTION = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]

ALTER TABLE [ IF EXISTS ] <name> UNSET {
                                       DATA_RETENTION_TIME_IN_DAYS         |
                                       MAX_DATA_EXTENSION_TIME_IN_DAYS     |
                                       CHANGE_TRACKING                     |
                                       DEFAULT_DDL_COLLATION               |
                                       ENABLE_SCHEMA_EVOLUTION             |
                                       COMMENT                             |
                                       }
                                       [ , ... ]

-- Example 19962
clusteringAction ::=
  {
     CLUSTER BY ( <expr> [ , <expr> , ... ] )
     /* RECLUSTER is deprecated */
   | RECLUSTER [ MAX_SIZE = <budget_in_bytes> ] [ WHERE <condition> ]
     /* { SUSPEND | RESUME } RECLUSTER is valid action */
   | { SUSPEND | RESUME } RECLUSTER
   | DROP CLUSTERING KEY
  }

-- Example 19963
tableColumnAction ::=
  {
     ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
        [
           {
              DEFAULT <default_value>
              | { AUTOINCREMENT | IDENTITY }
                 /* AUTOINCREMENT (or IDENTITY) is supported only for           */
                 /* columns with numeric data types (NUMBER, INT, FLOAT, etc.). */
                 /* Also, if the table is not empty (i.e. if the table contains */
                 /* any rows), only DEFAULT can be altered.                     */
                 [
                    {
                       ( <start_num> , <step_num> )
                       | START <num> INCREMENT <num>
                    }
                 ]
                 [  { ORDER | NOORDER } ]
           }
        ]
        [ inlineConstraint ]
        [ COLLATE '<collation_specification>' ]

   | RENAME COLUMN <col_name> TO <new_col_name>

   | ALTER | MODIFY [ ( ]
                            [ COLUMN ] <col1_name> DROP DEFAULT
                          , [ COLUMN ] <col1_name> SET DEFAULT <seq_name>.NEXTVAL
                          , [ COLUMN ] <col1_name> { [ SET ] NOT NULL | DROP NOT NULL }
                          , [ COLUMN ] <col1_name> [ [ SET DATA ] TYPE ] <type>
                          , [ COLUMN ] <col1_name> COMMENT '<string>'
                          , [ COLUMN ] <col1_name> UNSET COMMENT
                        [ , [ COLUMN ] <col2_name> ... ]
                        [ , ... ]
                    [ ) ]

   | DROP [ COLUMN ] [ IF EXISTS ] <col1_name> [, <col2_name> ... ]
  }

  inlineConstraint ::=
    [ NOT NULL ]
    [ CONSTRAINT <constraint_name> ]
    { UNIQUE | PRIMARY KEY | { [ FOREIGN KEY ] REFERENCES <ref_table_name> [ ( <ref_col_name> ) ] } }
    [ <constraint_properties> ]

-- Example 19964
dataMetricFunctionAction ::=

    SET DATA_METRIC_SCHEDULE = {
        '<num> MINUTE'
      | 'USING CRON <expr> <time_zone>'
      | 'TRIGGER_ON_CHANGES'
    }

  | UNSET DATA_METRIC_SCHEDULE

  | { ADD | DROP } DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] )
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) ]

  | MODIFY DATA METRIC FUNCTION <metric_name>
      ON ( <col_name> [ , ... ]
      [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME }
      [ , <metric_name_2> ON ( <col_name> [ , ... ]
        [ , TABLE <table_name>( <col_name> [ , ... ] ) ] ) { SUSPEND | RESUME } ]

-- Example 19965
dataGovnPolicyTagAction ::=
  {
      SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
    | UNSET TAG <tag_name> [ , <tag_name> ... ]
  }
  |
  {
      ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ROW ACCESS POLICY <policy_name>
    | DROP ROW ACCESS POLICY <policy_name> ,
        ADD ROW ACCESS POLICY <policy_name> ON ( <col_name> [ , ... ] )
    | DROP ALL ROW ACCESS POLICIES
  }
  |
  {
      SET AGGREGATION POLICY <policy_name>
        [ ENTITY KEY ( <col_name> [, ... ] ) ]
        [ FORCE ]
    | UNSET AGGREGATION POLICY
  }
  |
  {
      SET JOIN POLICY <policy_name>
        [ FORCE ]
    | UNSET JOIN POLICY
  }
  |
  ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type>
    [ [ WITH ] MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] ]
    [ [ WITH ] PROJECTION POLICY <policy_name> ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>'
          [ , <tag_name> = '<tag_value>' , ... ] ) ]
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET MASKING POLICY <policy_name>
          [ USING ( <col1_name> , <cond_col_1> , ... ) ] [ FORCE ]
      | UNSET MASKING POLICY
  }
  |
  {
    { ALTER | MODIFY } [ COLUMN ] <col1_name>
        SET PROJECTION POLICY <policy_name>
          [ FORCE ]
      | UNSET PROJECTION POLICY
  }
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> SET TAG
      <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
      , [ COLUMN ] <col2_name> SET TAG
          <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]
  |
  { ALTER | MODIFY } [ COLUMN ] <col1_name> UNSET TAG <tag_name> [ , <tag_name> ... ]
                   , [ COLUMN ] <col2_name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 19966
extTableColumnAction ::=
  {
     ADD [ COLUMN ] [ IF NOT EXISTS ] <col_name> <col_type> AS ( <expr> )

   | RENAME COLUMN <col_name> TO <new_col_name>

   | DROP [ COLUMN ] [ IF EXISTS ] <col1_name> [, <col2_name> ... ]
  }

-- Example 19967
constraintAction ::=
  {
     ADD outoflineConstraint
   | RENAME CONSTRAINT <constraint_name> TO <new_constraint_name>
   | { ALTER | MODIFY } { CONSTRAINT <constraint_name> | PRIMARY KEY | UNIQUE | FOREIGN KEY } ( <col_name> [ , ... ] )
                         [ [ NOT ] ENFORCED ] [ VALIDATE | NOVALIDATE ] [ RELY | NORELY ]
   | DROP { CONSTRAINT <constraint_name> | PRIMARY KEY | UNIQUE | FOREIGN KEY } ( <col_name> [ , ... ] )
                         [ CASCADE | RESTRICT ]
  }

  outoflineConstraint ::=
    [ CONSTRAINT <constraint_name> ]
    {
       UNIQUE [ ( <col_name> [ , <col_name> , ... ] ) ]
     | PRIMARY KEY [ ( <col_name> [ , <col_name> , ... ] ) ]
     | [ FOREIGN KEY ] [ ( <col_name> [ , <col_name> , ... ] ) ]
                          REFERENCES <ref_table_name> [ ( <ref_col_name> [ , <ref_col_name> , ... ] ) ]
    }
    [ <constraint_properties> ]

-- Example 19968
searchOptimizationAction ::=
  {
     ADD SEARCH OPTIMIZATION [
       ON <search_method_with_target> [ , <search_method_with_target> ... ]
     ]

   | DROP SEARCH OPTIMIZATION [
       ON { <search_method_with_target> | <column_name> | <expression_id> }
          [ , ... ]
     ]
  }

-- Example 19969
ALTER TABLE t1 ADD COLUMN c5 VARCHAR DEFAULT 12345::VARCHAR;

-- Example 19970
002263 (22000): SQL compilation error:
Invalid column default expression [CAST(12345 AS VARCHAR(16777216))]

-- Example 19971
ALTER TABLE t1 ADD COLUMN c6 DATE DEFAULT '20230101';

-- Example 19972
002023 (22000): SQL compilation error:
Expression type does not match column data type, expecting DATE but got VARCHAR(8) for column C6

-- Example 19973
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | _ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 19974
mycol varchar as (value:c1::varchar)

-- Example 19975
{ "a":"1", "b": { "c":"2", "d":"3" } }

-- Example 19976
mycol varchar as (value:"b"."c"::varchar)

-- Example 19977
<search_method>( <target> [ , <target> , ... ] [ , ANALYZER => '<analyzer_name>' ] )

-- Example 19978
-- Allowed
ON SUBSTRING(*)
ON EQUALITY(*), SUBSTRING(*), GEO(*)

-- Example 19979
-- Not allowed
ON EQUALITY(*, c1)
ON EQUALITY(c1, *)
ON EQUALITY(v1:path, *)
ON EQUALITY(c1), EQUALITY(*)

-- Example 19980
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 19981
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c3, c4);

-- Example 19982
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3, c4);

-- Example 19983
CREATE TABLE parent ... CONSTRAINT primary_key_1 PRIMARY KEY (c_1, c_2) ...
CREATE TABLE child  ... CONSTRAINT foreign_key_1 FOREIGN KEY (...) REFERENCES parent (c_1, c_2) ...

-- Example 19984
CREATE OR REPLACE TABLE t1(a1 number);

-- Example 19985
SHOW TABLES LIKE 't1';

-- Example 19986
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | change_tracking | is_external | enable_schema_evolution | owner_role_type | is_event | budget |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------|
| 2023-10-19 10:37:04.858 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         |            |    0 |     0 | PUBLIC | 1              | OFF             | N           | N                       | ROLE            | N        | NULL   |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+

-- Example 19987
ALTER TABLE t1 RENAME TO tt1;

-- Example 19988
SHOW TABLES LIKE 'tt1';

-- Example 19989
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+
| created_on                    | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes | owner  | retention_time | change_tracking | is_external | enable_schema_evolution | owner_role_type | is_event | budget |
|-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------|
| 2023-10-19 10:37:04.858 -0700 | TT1  | TESTDB        | MY_SCHEMA   | TABLE |         |            |    0 |     0 | PUBLIC | 1              | OFF             | N           | N                       | ROLE            | N        | NULL   |
+-------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------+----------------+-----------------+-------------+-------------------------+-----------------+----------+--------+

-- Example 19990
CREATE OR REPLACE TABLE t1(a1 NUMBER, a2 VARCHAR, a3 DATE);
CREATE OR REPLACE TABLE t2(b1 VARCHAR);

-- Example 19991
DESC TABLE t1;

-- Example 19992
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | DATE              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 19993
DESC TABLE t2;

-- Example 19994
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 19995
ALTER TABLE t1 SWAP WITH t2;

-- Example 19996
DESC TABLE t1;

-- Example 19997
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 19998
DESC TABLE t2;

-- Example 19999
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | DATE              | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20000
CREATE OR REPLACE TABLE t1(a1 NUMBER);

-- Example 20001
DESC TABLE t1;

-- Example 20002
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20003
ALTER TABLE t1 ADD COLUMN a2 NUMBER;

-- Example 20004
ALTER TABLE t1 ADD COLUMN a3 NUMBER NOT NULL;

-- Example 20005
ALTER TABLE t1 ADD COLUMN a4 NUMBER DEFAULT 0 NOT NULL;

-- Example 20006
ALTER TABLE t1 ADD COLUMN a5 VARCHAR COLLATE 'en_US';

-- Example 20007
DESC TABLE t1;

-- Example 20008
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type                              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0)                      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0)                      | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A5   | VARCHAR(16777216) COLLATE 'en_us' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20009
ALTER TABLE t1 ADD COLUMN IF NOT EXISTS a2 NUMBER;

-- Example 20010
DESC TABLE t1;

