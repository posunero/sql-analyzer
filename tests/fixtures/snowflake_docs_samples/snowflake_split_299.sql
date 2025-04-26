-- Example 20011
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type                              | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| A1   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0)                      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0)                      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0)                      | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A5   | VARCHAR(16777216) COLLATE 'en_us' | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+-----------------------------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20012
ALTER TABLE t1 RENAME COLUMN a1 TO b1;

-- Example 20013
DESC TABLE t1;

-- Example 20014
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A2   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20015
ALTER TABLE t1 DROP COLUMN a2;

-- Example 20016
DESC TABLE t1;

-- Example 20017
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20018
ALTER TABLE t1 DROP COLUMN IF EXISTS a2;

-- Example 20019
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| B1   | NUMBER(38,0) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A3   | NUMBER(38,0) | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| A4   | NUMBER(38,0) | COLUMN | N     | 0       | N           | N          | NULL  | NULL       | NULL    | NULL        |
+------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 20020
CREATE EXTERNAL TABLE exttable1
  LOCATION=@mystage/logs/
  AUTO_REFRESH = true
  FILE_FORMAT = (TYPE = PARQUET)
  ;

-- Example 20021
DESC EXTERNAL TABLE exttable1;

-- Example 20022
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 20023
ALTER TABLE exttable1 ADD COLUMN a1 VARCHAR AS (value:a1::VARCHAR);

-- Example 20024
DESC EXTERNAL TABLE exttable1;

-- Example 20025
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
| A1        | VARCHAR(16777216) | VIRTUAL   | Y     | NULL    | N           | N          | NULL  | TO_CHAR(GET(VALUE, 'a1'))                                | NULL                  |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 20026
ALTER TABLE exttable1 RENAME COLUMN a1 TO b1;

-- Example 20027
DESC EXTERNAL TABLE exttable1;

-- Example 20028
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
| B1        | VARCHAR(16777216) | VIRTUAL   | Y     | NULL    | N           | N          | NULL  | TO_CHAR(GET(VALUE, 'a1'))                                | NULL                  |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 20029
ALTER TABLE exttable1 DROP COLUMN b1;

-- Example 20030
DESC EXTERNAL TABLE exttable1;

-- Example 20031
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+
| name      | type              | kind      | null? | default | primary key | unique key | check | expression                                               | comment               |
|-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------|
| VALUE     | VARIANT           | COLUMN    | Y     | NULL    | N           | N          | NULL  | NULL                                                     | The value of this row |
+-----------+-------------------+-----------+-------+---------+-------------+------------+-------+----------------------------------------------------------+-----------------------+

-- Example 20032
CREATE OR REPLACE TABLE T1 (id NUMBER, date TIMESTAMP_NTZ, name STRING) CLUSTER BY (id, date);

-- Example 20033
SHOW TABLES LIKE 'T1';

-- Example 20034
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (ID,DATE)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Example 20035
ALTER TABLE t1 CLUSTER BY (date, id);

-- Example 20036
SHOW TABLES LIKE 'T1';

-- Example 20037
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |    owner     | retention_time |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+
 Tue, 21 Jun 2016 15:42:12 -0700 | T1   | TESTDB        | TESTSCHEMA  | TABLE |         | (DATE,ID)  | 0    | 0     | ACCOUNTADMIN | 1              |
---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+--------------+----------------+

-- Example 20038
ALTER TABLE t1 ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- Example 20039
ALTER TABLE t1 ADD ROW ACCESS POLICY rap_test2 ON (cost, item);

-- Example 20040
ALTER TABLE t1 DROP ROW ACCESS POLICY rap_v1;

-- Example 20041
alter table t1
  drop row access policy rap_t1_version_1,
  add row access policy rap_t1_version_2 on (empl_id);

-- Example 20042
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = '5 MINUTE';

-- Example 20043
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * * UTC';

-- Example 20044
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * MON,TUE,WED,THU,FRI UTC';

-- Example 20045
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 6,12,18 * * * UTC';

-- Example 20046
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES';

-- Example 20047
ALTER TABLE join_table_2
  SET JOIN POLICY jp1 ALLOWED JOIN KEYS (col1);

-- Example 20048
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = '5 MINUTE';

-- Example 20049
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * * UTC';

-- Example 20050
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 8 * * MON,TUE,WED,THU,FRI UTC';

-- Example 20051
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'USING CRON 0 6,12,18 * * * UTC';

-- Example 20052
ALTER TABLE hr.tables.empl_info SET
  DATA_METRIC_SCHEDULE = 'TRIGGER_ON_CHANGES';

-- Example 20053
SHOW PARAMETERS LIKE 'DATA_METRIC_SCHEDULE' IN TABLE hr.tables.empl_info;

-- Example 20054
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+
| key                  | value                          | default | level | description                                                                                                                  | type   |
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+
| DATA_METRIC_SCHEDULE | USING CRON 0 6,12,18 * * * UTC |         | TABLE | Specify the schedule that data metric functions associated to the table must be executed in order to be used for evaluation. | STRING |
+----------------------+--------------------------------+---------+-------+------------------------------------------------------------------------------------------------------------------------------+--------+

-- Example 20055
SHOW PARAMETERS LIKE 'DATA_METRIC_SCHEDULE' IN TABLE mydb.public.my_view;

-- Example 20056
ALTER TABLE t
  ADD DATA METRIC FUNCTION SNOWFLAKE.CORE.NULL_COUNT
    ON (c1);

-- Example 20057
ALTER TABLE t
  DROP DATA METRIC FUNCTION governance.dmfs.count_positive_numbers
    ON (c1, c2, c3);

-- Example 20058
SELECT <data_metric_function>(<query>)

-- Example 20059
SELECT governance.dmfs.count_positive_numbers(
  SELECT c1, c2, c3
  FROM t);

-- Example 20060
SELECT SNOWFLAKE.CORE.NULL_COUNT(
  SELECT ssn
  FROM hr.tables.empl_info);

-- Example 20061
CREATE NETWORK RULE block_public_access
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('0.0.0.0/0');

CREATE NETWORK RULE allow_vpceid_access
  MODE = INGRESS
  TYPE = AWSVPCEID
  VALUE_LIST = ('vpce-0fa383eb170331202');

CREATE NETWORK POLICY allow_vpceid_block_public_policy
  ALLOWED_NETWORK_RULE_LIST = ('allow_vpceid_access')
  BLOCKED_NETWORK_RULE_LIST=('block_public_access');

-- Example 20062
CREATE NETWORK RULE allow_access_rule
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('192.168.1.0/24');

CREATE NETWORK RULE block_access_rule
  MODE = INGRESS
  TYPE = IPV4
  VALUE_LIST = ('192.168.1.99');

CREATE NETWORK POLICY public_network_policy
  ALLOWED_NETWORK_RULE_LIST = ('allow_access_rule')
  BLOCKED_NETWORK_RULE_LIST=('block_access_rule');

-- Example 20063
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENFORCE_NETWORK_RULES_FOR_INTERNAL_STAGES = true;

-- Example 20064
GRANT USAGE ON DATABASE securitydb TO ROLE network_admin;
GRANT USAGE ON SCHEMA securitydb.myrules TO ROLE network_admin;
GRANT CREATE NETWORK RULE ON SCHEMA securitydb.myrules TO ROLE network_admin;
USE ROLE network_admin;

CREATE NETWORK RULE cloud_network TYPE = IPV4 VALUE_LIST = ('47.88.25.32/27');

-- Example 20065
SHOW PARAMETERS LIKE 'network_policy' IN ACCOUNT;

-- Example 20066
ALTER NETWORK POLICY my_policy SET BLOCKED_NETWORK_RULE_LIST = ( 'other_network' );

-- Example 20067
ALTER NETWORK POLICY my_policy ADD ALLOWED_NETWORK_RULE_LIST = ( 'new_rule' );

-- Example 20068
ALTER NETWORK POLICY my_policy REMOVE BLOCKED_NETWORK_RULE_LIST = ( 'other_network' );

-- Example 20069
ALTER ACCOUNT SET NETWORK_POLICY = my_policy;

-- Example 20070
ALTER USER joe SET NETWORK_POLICY = my_policy;

-- Example 20071
CREATE SECURITY INTEGRATION oauth_kp_int
  TYPE = oauth
  ENABLED = true
  OAUTH_CLIENT = custom
  OAUTH_CLIENT_TYPE = 'CONFIDENTIAL'
  OAUTH_REDIRECT_URI = 'https://example.com'
  NETWORK_POLICY = mypolicy;

-- Example 20072
connection.execute({
  sqlText: 'SELECT * FROM sometable',
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('Number of rows produced: ' + rows.length);
    }
  }
});

-- Example 20073
var connection = snowflake.createConnection({
    account: process.env.SFACCOUNT,
    username: process.env.SFUSER,
    // ...
    streamResult: true
});

// [..rest of the code..]

connection.execute({
  sqlText: "select L_COMMENT from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.LINEITEM limit 100000;",
  streamResult: true,
  complete: function (err, stmt)
  {
    var stream = stmt.streamRows();
    // Read data from the stream when it is available
    stream.on('readable', function (row)
    {
      while ((row = this.read()) !== null)
      {
        console.log(row);
      }
    }).on('end', function ()
    {
      console.log('done');
    }).on('error', function (err)
    {
      console.log(err);
    });
  }
});

-- Example 20074
connection.execute({
  sqlText: 'SELECT * FROM sometable',
  streamResult: true, // prevent rows from being returned inline in the complete callback
  complete: function(err, stmt, rows) {
    // no rows returned inline because streamResult was set to true
    console.log('rows: ' + rows); // 'rows: undefined'

    // only consume at most the last 5 rows in the result
    rows = [];
    stmt.streamRows({
      start: Math.max(0, stmt.getNumRows() - 5),
      end: stmt.getNumRows() - 1,
    })
    .on('error', function(err) {
      console.error('Unable to consume requested rows');
    })
    .on('data', function(row) {
      rows.push(row);
    })
    .on('end', function() {
      console.log('Number of rows consumed: ' + rows.length);
    });
  }
})

-- Example 20075
connection.execute( {
                    sqlText: 'ALTER SESSION SET JS_TREAT_INTEGER_AS_BIGINT = TRUE',
                    complete: function ...
                    }
                  );

-- Example 20076
var connection = snowflake.createConnection(
      {
      username: 'fakeusername',
      password: 'fakepassword',
      account: 'fakeaccountidentifier',
      jsTreatIntegerAsBigInt: true
      }
    );

-- Example 20077
connection.execute({
  sqlText: 'SELECT 1.123456789123456789123456789 as "c1"',
  fetchAsString: ['Number'],
  complete: function(err, stmt, rows) {
    if (err) {
      console.error('Failed to execute statement due to the following error: ' + err.message);
    } else {
      console.log('c1: ' + rows[0].c1); // c1: 1.123456789123456789123456789
    }
  }
});

