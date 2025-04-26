-- Example 4070
CURRENT_SCHEMA()

-- Example 4071
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 4072
+---------------------+--------------------+------------------+
| CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|---------------------+--------------------+------------------|
| DEV_WAREHOUSE       | TEST_DATABASE      | UDF_TEST_SCHEMA  |
+---------------------+--------------------+------------------+

-- Example 4073
CURRENT_SCHEMAS()

-- Example 4074
SELECT CURRENT_SCHEMAS();

-- Example 4075
+-----------------------------------------+
| CURRENT_SCHEMAS()                       |
|-----------------------------------------|
| ["TEST_DB1.BILLING", "TEST_DB1.PUBLIC"] |
+-----------------------------------------+

-- Example 4076
CURRENT_SECONDARY_ROLES()

-- Example 4077
SELECT CURRENT_SECONDARY_ROLES();

-- Example 4078
+------------------------------------------------------+
|           CURRENT_SECONDARY_ROLES()                  |
+------------------------------------------------------+
| {"roles":"ROLE1,ROLE2,ROLE3","value":"ALL"}          |
+------------------------------------------------------+

-- Example 4079
CURRENT_SESSION()

-- Example 4080
SELECT CURRENT_SESSION();
-------------------+
 CURRENT_SESSION() |
-------------------+
 34359980038       |
-------------------+

-- Example 4081
CURRENT_STATEMENT()

-- Example 4082
SELECT 2.71, CURRENT_STATEMENT();

-- Example 4083
+------+-----------------------------------+
| 2.71 | CURRENT_STATEMENT()               |
|------+-----------------------------------|
| 2.71 | SELECT 2.71, CURRENT_STATEMENT(); |
+------+-----------------------------------+

-- Example 4084
CURRENT_TASK_GRAPHS(
      [ RESULT_LIMIT => <integer> ]
      [, ROOT_TASK_NAME => '<string>' ] )

-- Example 4085
select *
  from table(information_schema.current_task_graphs())
  order by scheduled_time;

-- Example 4086
select *
  from table(information_schema.current_task_graphs(
    result_limit => 10,
    root_task_name=>'MYTASK'));

-- Example 4087
CURRENT_TIME( [ <fract_sec_precision> ] )

CURRENT_TIME

-- Example 4088
ALTER SESSION SET TIME_OUTPUT_FORMAT = 'HH24:MI:SS.FF';

SELECT CURRENT_TIME(2);

-- Example 4089
+-----------------+
| CURRENT_TIME(2) |
|-----------------|
| 15:35:51.24     |
+-----------------+

-- Example 4090
SELECT CURRENT_TIME(4);

-- Example 4091
+-----------------+
| CURRENT_TIME(4) |
|-----------------|
| 15:36:53.5570   |
+-----------------+

-- Example 4092
SELECT CURRENT_TIME;

-- Example 4093
+--------------------+
| CURRENT_TIME       |
|--------------------|
| 15:37:29.644000000 |
+--------------------+

-- Example 4094
CURRENT_TIMESTAMP( [ <fract_sec_precision> ] )

CURRENT_TIMESTAMP

-- Example 4095
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Example 4096
SELECT CURRENT_TIMESTAMP(2);

-- Example 4097
+------------------------+
| CURRENT_TIMESTAMP(2)   |
|------------------------|
| 2024-04-17 15:41:38.29 |
+------------------------+

-- Example 4098
SELECT CURRENT_TIMESTAMP(4);

-- Example 4099
+--------------------------+
| CURRENT_TIMESTAMP(4)     |
|--------------------------|
| 2024-04-17 15:42:14.2100 |
+--------------------------+

-- Example 4100
SELECT CURRENT_TIMESTAMP;

-- Example 4101
+-------------------------------+
| CURRENT_TIMESTAMP             |
|-------------------------------|
| 2024-04-17 15:42:55.130000000 |
+-------------------------------+

-- Example 4102
CURRENT_TRANSACTION()

-- Example 4103
SELECT CURRENT_TRANSACTION();

-- Example 4104
+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------|
| 1661899308790000000   |
+-----------------------+

-- Example 4105
CURRENT_USER()

CURRENT_USER

-- Example 4106
SELECT CURRENT_USER();

-- Example 4107
+----------------+
| CURRENT_USER() |
|----------------|
| TSMITH         |
+----------------+

-- Example 4108
CURRENT_VERSION()

-- Example 4109
<major_version>.<minor_version>.<patch_version>  <internal_identifier>

-- Example 4110
SELECT CURRENT_VERSION();

-- Example 4111
+-------------------+
| CURRENT_VERSION() |
|-------------------|
| 7.32.1            |
+-------------------+

-- Example 4112
CURRENT_WAREHOUSE()

-- Example 4113
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 4114
+---------------------+--------------------+------------------+
| CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|---------------------+--------------------+------------------|
| DEV_WAREHOUSE       | TEST_DATABASE      | UDF_TEST_SCHEMA  |
+---------------------+--------------------+------------------+

-- Example 4115
DATA_METRIC_FUNCTION_REFERENCES(
  METRIC_NAME => '<string>' )

DATA_METRIC_FUNCTION_REFERENCES(
  REF_ENTITY_NAME => '<string>' ,
  REF_ENTITY_DOMAIN => '<string>'
  )

-- Example 4116
USE DATABASE governance;
USE SCHEMA INFORMATION_SCHEMA;
SELECT *
  FROM TABLE(
    INFORMATION_SCHEMA.DATA_METRIC_FUNCTION_REFERENCES(
      REF_ENTITY_NAME => 'hr.tables.empl_info',
      REF_ENTITY_DOMAIN => 'table'
    )
  );

-- Example 4117
USE DATABASE governance;
USE SCHEMA INFORMATION_SCHEMA;
SELECT *
  FROM TABLE(
    INFORMATION_SCHEMA.DATA_METRIC_FUNCTION_REFERENCES(
      METRIC_NAME => 'governance.dmfs.count_positive_numbers'
    )
  );

-- Example 4118
DATA_QUALITY_MONITORING_RESULTS(
  REF_ENTITY_NAME => '<string>' ,
  REF_ENTITY_DOMAIN => '<string>'
  )

-- Example 4119
USE DATABASE SNOWFLAKE;
USE SCHEMA LOCAL;
SELECT *
  FROM TABLE(SNOWFLAKE.LOCAL.DATA_QUALITY_MONITORING_RESULTS(
    REF_ENTITY_NAME => 'my_db.my_schema.my_table',
    REF_ENTITY_DOMAIN => 'table'));

-- Example 4120
DATA_TRANSFER_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ] )

-- Example 4121
select *
  from table(mydb.information_schema.data_transfer_history(
    date_range_start=>to_timestamp_tz('2017-10-24 12:00:00.000 -0700'),
    date_range_end=>to_timestamp_tz('2017-10-24 12:30:00.000 -0700')));

-- Example 4122
select *
  from table(information_schema.data_transfer_history(
    date_range_start=>dateadd('hour',-12,current_timestamp())));

-- Example 4123
select *
  from table(information_schema.data_transfer_history(
    date_range_start=>dateadd('day',-14,current_date()),
    date_range_end=>current_date()));

-- Example 4124
DATABASE_REFRESH_HISTORY( '<secondary_db_name>' )

-- Example 4125
select *
from table(information_schema.database_refresh_history());

-- Example 4126
DATABASE_REFRESH_PROGRESS( '<secondary_db_name>' )

DATABASE_REFRESH_PROGRESS_BY_JOB( '<query_id>' )

-- Example 4127
select *
from table(information_schema.database_refresh_progress(mydb1));

-- Example 4128
select *
from table(information_schema.database_refresh_progress_by_job('012a3b45-1234-a12b-0000-1aa200012345'));

-- Example 4129
DATABASE_REPLICATION_USAGE_HISTORY(
  [ DATE_RANGE_START => <constant_expr> ]
  [ , DATE_RANGE_END => <constant_expr> ]
  [ , DATABASE_NAME => '<string>' ] )

-- Example 4130
select database_name, credits_used, bytes_transferred
  from table(information_schema.database_replication_usage_history(
    date_range_start=>'2023-03-28 12:00:00.000 +0000',
    date_range_end=>'2023-03-28 12:30:00.000 +0000'));

-- Example 4131
select database_name, credits_used, bytes_transferred
  from table(information_schema.database_replication_usage_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 4132
select start_time, end_time, database_name, credits_used, bytes_transferred
  from table(information_schema.database_replication_usage_history(
    date_range_start=>dateadd(d, -7, current_date),
    date_range_end=>current_date));

-- Example 4133
select start_time, end_time, database_name, credits_used, bytes_transferred
  from table(information_schema.database_replication_usage_history(
    date_range_start=>dateadd(d, -7, current_date),
    date_range_end=>current_date,
    database_name=>'mydb'));

-- Example 4134
DATABASE_STORAGE_USAGE_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [, DATE_RANGE_END => <constant_expr> ]
      [, DATABASE_NAME => '<string>' ] )

-- Example 4135
select *
from table(information_schema.database_storage_usage_history(dateadd('days',-10,current_date()),current_date()));

-- Example 4136
DATE_FROM_PARTS( <year>, <month>, <day> )

