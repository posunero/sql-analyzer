-- Example 7284
GRANT USAGE
  ON WAREHOUSE warehouse1
  TO ROLE warehouse_task_creation;

-- Example 7285
from snowflake.core.role import Securable

root.roles['warehouse_task_creation'].grant_privileges(
    privileges=["USAGE"], securable_type="warehouse", securable=Securable(name='warehouse1')
)

-- Example 7286
USE SYSADMIN;

CREATE ROLE serverless_task_creation
  COMMENT = 'This role can create serverless tasks.';

-- Example 7287
from snowflake.core.role import Role

root.session.use_role("SYSADMIN")

my_role = Role(
    name="serverless_task_creation",
    comment="This role can create serverless tasks."
)
root.roles.create(my_role)

-- Example 7288
USE ACCOUNTADMIN;

GRANT CREATE TASK
  ON SCHEMA schema1
  TO ROLE serverless_task_creation;

-- Example 7289
from snowflake.core.role import Securable

root.session.use_role("ACCOUNTADMIN")

root.roles['serverless_task_creation'].grant_privileges(
    privileges=["CREATE TASK"], securable_type="schema", securable=Securable(name='schema1')
)

-- Example 7290
GRANT EXECUTE MANAGED TASK ON ACCOUNT
  TO ROLE serverless_task_creation;

-- Example 7291
root.roles['serverless_task_creation'].grant_privileges(
    privileges=["EXECUTE MANAGED TASK"], securable_type="account"
)

-- Example 7292
USE ROLE securityadmin;

CREATE ROLE taskadmin;

-- Example 7293
from snowflake.core.role import Role

root.session.use_role("securityadmin")

root.roles.create(Role(name="taskadmin"))

-- Example 7294
USE ROLE accountadmin;

GRANT EXECUTE TASK, EXECUTE MANAGED TASK ON ACCOUNT TO ROLE taskadmin;

-- Example 7295
root.session.use_role("accountadmin")

root.roles['taskadmin'].grant_privileges(
    privileges=["EXECUTE TASK", "EXECUTE MANAGED TASK"], securable_type="account"
)

-- Example 7296
USE ROLE securityadmin;

GRANT ROLE taskadmin TO ROLE myrole;

-- Example 7297
from snowflake.core.role import Securable

root.session.use_role("securityadmin")

root.roles['myrole'].grant_role(role_type="ROLE", role=Securable(name='taskadmin'))

-- Example 7298
SNOWFLAKE.NOTIFICATION.TEXT_HTML( '<message>' )

-- Example 7299
'{"text/html":"<p>A message</p>"}'

-- Example 7300
SNOWFLAKE.NOTIFICATION.TEXT_PLAIN( '<message>' )

-- Example 7301
'{"text/plain":"A message"}'

-- Example 7302
TIME_FROM_PARTS( <hour>, <minute>, <second> [, <nanoseconds>] )

-- Example 7303
ALTER SESSION SET TIME_OUTPUT_FORMAT='HH24:MI:SS.FF9';

-- Example 7304
select time_from_parts(12, 34, 56, 987654321);

----------------------------------------+
 TIME_FROM_PARTS(12, 34, 56, 987654321) |
----------------------------------------+
 12:34:56.987654321                     |
----------------------------------------+

-- Example 7305
select time_from_parts(0, 100, 0), time_from_parts(12, 0, 12345);

----------------------------+-------------------------------+
 TIME_FROM_PARTS(0, 100, 0) | TIME_FROM_PARTS(12, 0, 12345) |
----------------------------+-------------------------------+
 01:40:00.000000000         | 15:25:45.000000000            |
----------------------------+-------------------------------+

-- Example 7306
TIMEADD( <date_or_time_part> , <value> , <date_or_time_expr> )

-- Example 7307
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, 2, TO_DATE('2022-05-08')) AS date_plus_two_years;

-- Example 7308
+---------------+---------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS |
|---------------+---------------------|
| 2022-05-08    | 2024-05-08          |
+---------------+---------------------+

-- Example 7309
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, -2, TO_DATE('2022-05-08')) AS date_minus_two_years;

-- Example 7310
+---------------+----------------------+
| ORIGINAL_DATE | DATE_MINUS_TWO_YEARS |
|---------------+----------------------|
| 2022-05-08    | 2020-05-08           |
+---------------+----------------------+

-- Example 7311
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF9';
CREATE TABLE datetest (d date);
INSERT INTO datetest VALUES ('2022-04-05');

-- Example 7312
SELECT d AS original_date,
       DATEADD(year, 2, d) AS date_plus_two_years,
       TO_TIMESTAMP(d) AS original_timestamp,
       DATEADD(hour, 2, d) AS timestamp_plus_two_hours
  FROM datetest;

-- Example 7313
+---------------+---------------------+-------------------------+--------------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS | ORIGINAL_TIMESTAMP      | TIMESTAMP_PLUS_TWO_HOURS |
|---------------+---------------------+-------------------------+--------------------------|
| 2022-04-05    | 2024-04-05          | 2022-04-05 00:00:00.000 | 2022-04-05 02:00:00.000  |
+---------------+---------------------+-------------------------+--------------------------+

-- Example 7314
SELECT DATEADD(month, 1, '2023-01-31'::DATE) AS date_plus_one_month;

-- Example 7315
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-02-28          |
+---------------------+

-- Example 7316
SELECT DATEADD(month, 1, '2023-02-28'::DATE) AS date_plus_one_month;

-- Example 7317
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-03-28          |
+---------------------+

-- Example 7318
SELECT TO_TIME('05:00:00') AS original_time,
       DATEADD(hour, 3, TO_TIME('05:00:00')) AS time_plus_three_hours;

-- Example 7319
+---------------+-----------------------+
| ORIGINAL_TIME | TIME_PLUS_THREE_HOURS |
|---------------+-----------------------|
| 05:00:00      | 08:00:00              |
+---------------+-----------------------+

-- Example 7320
TIMEDIFF( <date_or_time_part> , <date_or_time_expr1> , <date_or time_expr2> )

-- Example 7321
DATEDIFF(month, '2021-01-01'::DATE, '2021-02-28'::DATE)

-- Example 7322
SELECT TIMEDIFF(YEAR, '2017-01-01', '2019-01-01') AS Years;
+-------+
| YEARS |
|-------|
|     2 |
+-------+

-- Example 7323
SELECT TIMEDIFF(MONTH, '2017-01-1', '2017-12-31') AS Months;
+--------+
| MONTHS |
|--------|
|     11 |
+--------+

-- Example 7324
TIMESTAMP_FROM_PARTS( <year>, <month>, <day>, <hour>, <minute>, <second> [, <nanosecond> ] [, <time_zone> ] )

TIMESTAMP_FROM_PARTS( <date_expr>, <time_expr> )

-- Example 7325
TIMESTAMP_LTZ_FROM_PARTS( <year>, <month>, <day>, <hour>, <minute>, <second> [, <nanosecond>] )

-- Example 7326
TIMESTAMP_NTZ_FROM_PARTS( <year>, <month>, <day>, <hour>, <minute>, <second> [, <nanosecond>] )

TIMESTAMP_NTZ_FROM_PARTS( <date_expr>, <time_expr> )

-- Example 7327
TIMESTAMP_TZ_FROM_PARTS( <year>, <month>, <day>, <hour>, <minute>, <second> [, <nanosecond>] [, <time_zone>] )

-- Example 7328
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT='YYYY-MM-DD HH24:MI:SS.FF9 TZH:TZM';
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT='YYYY-MM-DD HH24:MI:SS.FF9 TZH:TZM';
ALTER SESSION SET TIMEZONE='America/New_York';

-- Example 7329
SELECT TIMESTAMP_LTZ_FROM_PARTS(2013, 4, 5, 12, 00, 00);
+--------------------------------------------------+
| TIMESTAMP_LTZ_FROM_PARTS(2013, 4, 5, 12, 00, 00) |
|--------------------------------------------------|
| 2013-04-05 12:00:00.000000000 -0400              |
+--------------------------------------------------+

-- Example 7330
select timestamp_ntz_from_parts(2013, 4, 5, 12, 00, 00, 987654321);
+-------------------------------------------------------------+
| TIMESTAMP_NTZ_FROM_PARTS(2013, 4, 5, 12, 00, 00, 987654321) |
|-------------------------------------------------------------|
| 2013-04-05 12:00:00.987654321                               |
+-------------------------------------------------------------+

-- Example 7331
select timestamp_ntz_from_parts(to_date('2013-04-05'), to_time('12:00:00'));
+----------------------------------------------------------------------+
| TIMESTAMP_NTZ_FROM_PARTS(TO_DATE('2013-04-05'), TO_TIME('12:00:00')) |
|----------------------------------------------------------------------|
| 2013-04-05 12:00:00.000000000                                        |
+----------------------------------------------------------------------+

-- Example 7332
select timestamp_tz_from_parts(2013, 4, 5, 12, 00, 00);
+-------------------------------------------------+
| TIMESTAMP_TZ_FROM_PARTS(2013, 4, 5, 12, 00, 00) |
|-------------------------------------------------|
| 2013-04-05 12:00:00.000000000 -0400             |
+-------------------------------------------------+

-- Example 7333
select timestamp_tz_from_parts(2013, 4, 5, 12, 00, 00, 0, 'America/Los_Angeles');
+---------------------------------------------------------------------------+
| TIMESTAMP_TZ_FROM_PARTS(2013, 4, 5, 12, 00, 00, 0, 'AMERICA/LOS_ANGELES') |
|---------------------------------------------------------------------------|
| 2013-04-05 12:00:00.000000000 -0700                                       |
+---------------------------------------------------------------------------+

-- Example 7334
select timestamp_from_parts(2013, 4, 5, 12, 0, -3600);
+------------------------------------------------+
| TIMESTAMP_FROM_PARTS(2013, 4, 5, 12, 0, -3600) |
|------------------------------------------------|
| 2013-04-05 11:00:00.000000000                  |
+------------------------------------------------+

-- Example 7335
TIMESTAMPADD( <date_or_time_part> , <time_value> , <date_or_time_expr> )

-- Example 7336
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, 2, TO_DATE('2022-05-08')) AS date_plus_two_years;

-- Example 7337
+---------------+---------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS |
|---------------+---------------------|
| 2022-05-08    | 2024-05-08          |
+---------------+---------------------+

-- Example 7338
SELECT TO_DATE('2022-05-08') AS original_date,
       DATEADD(year, -2, TO_DATE('2022-05-08')) AS date_minus_two_years;

-- Example 7339
+---------------+----------------------+
| ORIGINAL_DATE | DATE_MINUS_TWO_YEARS |
|---------------+----------------------|
| 2022-05-08    | 2020-05-08           |
+---------------+----------------------+

-- Example 7340
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF9';
CREATE TABLE datetest (d date);
INSERT INTO datetest VALUES ('2022-04-05');

-- Example 7341
SELECT d AS original_date,
       DATEADD(year, 2, d) AS date_plus_two_years,
       TO_TIMESTAMP(d) AS original_timestamp,
       DATEADD(hour, 2, d) AS timestamp_plus_two_hours
  FROM datetest;

-- Example 7342
+---------------+---------------------+-------------------------+--------------------------+
| ORIGINAL_DATE | DATE_PLUS_TWO_YEARS | ORIGINAL_TIMESTAMP      | TIMESTAMP_PLUS_TWO_HOURS |
|---------------+---------------------+-------------------------+--------------------------|
| 2022-04-05    | 2024-04-05          | 2022-04-05 00:00:00.000 | 2022-04-05 02:00:00.000  |
+---------------+---------------------+-------------------------+--------------------------+

-- Example 7343
SELECT DATEADD(month, 1, '2023-01-31'::DATE) AS date_plus_one_month;

-- Example 7344
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-02-28          |
+---------------------+

-- Example 7345
SELECT DATEADD(month, 1, '2023-02-28'::DATE) AS date_plus_one_month;

-- Example 7346
+---------------------+
| DATE_PLUS_ONE_MONTH |
|---------------------|
| 2023-03-28          |
+---------------------+

-- Example 7347
SELECT TO_TIME('05:00:00') AS original_time,
       DATEADD(hour, 3, TO_TIME('05:00:00')) AS time_plus_three_hours;

-- Example 7348
+---------------+-----------------------+
| ORIGINAL_TIME | TIME_PLUS_THREE_HOURS |
|---------------+-----------------------|
| 05:00:00      | 08:00:00              |
+---------------+-----------------------+

-- Example 7349
TIMESTAMPDIFF( <date_or_time_part> , <date_or_time_expr1> , <date_or_time_expr2> )

-- Example 7350
DATEDIFF(month, '2021-01-01'::DATE, '2021-02-28'::DATE)

