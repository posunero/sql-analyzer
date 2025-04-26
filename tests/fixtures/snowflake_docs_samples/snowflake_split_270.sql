-- Example 18068
Unknown user-defined function SNOWFLAKE.LOCAL.ACTIVATE

-- Example 18069
FAILURE: Uncaught exception of type 'BUDGET_ALREADY_ACTIVATED' on line X at position X

-- Example 18070
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_CONFIG();

-- Example 18071
-20000 (P0001): Uncaught exception of type 'NO_PERMISSION_TO_ACTIVATE_BUDGET' on line X at position X

-- Example 18072
FAILURE: SQL access control error: Insufficient privileges to operate on class 'BUDGET'

-- Example 18073
FAILURE: Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 :
Uncaught exception of type 'UNSUPPORTED_BUDGET_TYPE' on line X at position X

-- Example 18074
FAILURE: Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 :
Uncaught exception of type 'UNSUPPORTED_BUDGET_TYPE' on line X at position X

-- Example 18075
-20000 (P0001): Uncaught exception of type 'FUNCTION_NOT_SUPPORTED_FOR_ACCOUNT_ROOT_BUDGET' on line 11 at position 18

-- Example 18076
-20000 (P0001): Uncaught exception of type 'ACCOUNT_ROOT_BUDGET_NOT_ACTIVATED' on line X at position X

-- Example 18077
002141 (42601): SQL compilation error:
Unknown user-defined function <budget_db>.<budget_schema>.<budget_name>!ADD_RESOURCE

-- Example 18078
002003 (02000): SQL compilation error:
<object_type> '<object_name>' does not exist or not authorized.

-- Example 18079
Uncaught exception of type 'EXPRESSION_ERROR' on line 10 at position 21 :
Privilege 'APPLYBUDGET' is not authorized on the reference object.

-- Example 18080
505001 (55000): Uncaught exception of type 'EXPRESSION_ERROR' on line 10
at position 21 : Specified object does not exist or not authorized for
the reference.

-- Example 18081
Unknown user-defined function <database_name>.<schema_name>.<budget_name>.SET_EMAIL_NOTIFICATIONS

-- Example 18082
Integration '<INTEG_NAME>' does not exist or not authorized.

-- Example 18083
FAILURE: Uncaught exception of type 'EXPRESSION_ERROR' on line 16 at position 34 : Following email address(es) are not
allowed by the email integration <INTEGRATION_NAME>: [<email>]

-- Example 18084
Email recipients in the given list at indexes [<index_list>] are not allowed. Either these email addresses are not yet validated
or do not belong to any user in the current account.

-- Example 18085
001044 (42P13): SQL compilation error: error line 0 at position -1 Invalid argument types for function 'GET_SERVICE_TYPE_USAGE':
(VARCHAR(X), VARCHAR(X), VARCHAR(X), VARCHAR(X))

-- Example 18086
002151 (22023): Uncaught exception of type 'STATEMENT_ERROR' on line 16 at position 23 : SQL compilation error:
[:TIME_DEPART] is not a valid date/time component for function DATE_TRUNC.

-- Example 18087
100094 (22000): Uncaught exception of type 'STATEMENT_ERROR' on line 16 at position 23 : Unknown timezone: '<invalid_timezone>'

-- Example 18088
FAILURE: SQL compilation error: Class 'SNOWFLAKE.CORE.BUDGET' does not exist or not authorized.

-- Example 18089
000002 (0A000): Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 : Unsupported feature 'TOK_RESOURCE_GROUP'.

-- Example 18090
USE ROLE accountadmin;

GRANT ROLE samooha_app_role TO USER joe;

-- Example 18091
USE ROLE ACCOUNTADMIN;
CREATE ROLE MARKETING_ANALYST_ROLE;
GRANT USAGE ON WAREHOUSE APP_WH TO MARKETING_ANALYST_ROLE; -- Or whichever warehouse you are using
GRANT ROLE MARKETING_ANALYST_ROLE TO USER george.washington;

-- Example 18092
CALL samooha_by_snowflake_local_db.consumer.grant_run_on_cleanrooms_to_role(
  ['overlap_cleanroom', 'market_share_cleanroom'],
  'MARKETING_ANALYST_ROLE'
);

-- Example 18093
-- User george.washington logs in and uses the proper role.
 USE WAREHOUSE APP_WH
 USE ROLE MARKETING_ANALYST_ROLE;

 -- Consumer-run analyses should succeed.
 CALL samooha_by_snowflake_local_db.consumer.run_analysis(
   $cleanroom_name,
   'prod_overlap_analysis',
   ['SAMOOHA_SAMPLE_DATABASE.MYDATA.CONVERSIONS'],  -- Consumer tables
   ['SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES'],      -- Provider tables
   object_construct(
     'max_age', 30
   )
 );

-- Most other procedures will fail.
CALL samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 18094
SHOW GRANTS OF ROLE <run_role_name>;

-- Example 18095
USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE my_big_warehouse WITH WAREHOUSE_SIZE = X5LARGE;
GRANT USAGE, OPERATE ON WAREHOUSE my_big_warehouse TO ROLE SAMOOHA_APP_ROLE;

-- Example 18096
SELECT *,
  TRY_PARSE_JSON(query_tag) AS query_tag_details
  FROM snowflake.account_usage.query_history
  WHERE query_tag_details IS NOT NULL
    AND query_tag_details:request_type = 'DCR'
    AND query_tag_details:user_email = 'joe@example.com';

-- Example 18097
-- Retrieve clean room UUID
SELECT cleanroom_id FROM samooha_by_snowflake_local_db.public.cleanroom_record
  WHERE cleanroom_name = '<cleanroom_name>';

-- Retrieve queries with provider-run query tag
SELECT * FROM snowflake.account_usage.query_history
  WHERE query_tag = cleanroom_id || '<provider_account_locator>;

-- Example 18098
SHOW AUTHENTICATION POLICIES;

-- Example 18099
GRANT USAGE ON FUNCTION
  governance.dmfs.count_positive_numbers(TABLE(NUMBER, NUMBER, NUMBER))
  TO data_engineer;

-- Example 18100
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('8cd54bf0-1651-5b1c-ac9c-6a9582ebd20f'));

-- Example 18101
{
  "estimatedQueryTimes": {
    "1": 171,
    "10": 115,
    "2": 152,
    "4": 133,
    "8": 120
  },
  "originalQueryTime": 300.291,
  "queryUUID": "8cd54bf0-1651-5b1c-ac9c-6a9582ebd20f",
  "status": "eligible",
  "upperLimitScaleFactor": 10
}

-- Example 18102
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('cf23522b-3b91-cf14-9fe0-988a292a4bfa'));

-- Example 18103
{
  "estimatedQueryTimes": {},
  "originalQueryTime": 20.291,
  "queryUUID": "cf23522b-3b91-cf14-9fe0-988a292a4bfa",
  "status": "ineligible",
  "upperLimitScaleFactor": 0
}

-- Example 18104
USE ROLE ACCOUNTADMIN;

-- Example 18105
SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY eligible_query_acceleration_time DESC;

-- Example 18106
SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY eligible_query_acceleration_time DESC;

-- Example 18107
SELECT warehouse_name, COUNT(query_id) AS num_eligible_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

-- Example 18108
SELECT warehouse_name, SUM(eligible_query_acceleration_time) AS total_eligible_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY total_eligible_time DESC;

-- Example 18109
SELECT MAX(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP());

-- Example 18110
SELECT upper_limit_scale_factor, COUNT(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY 1 ORDER BY 1;

-- Example 18111
CREATE WAREHOUSE my_wh WITH
  ENABLE_QUERY_ACCELERATION = true;

-- Example 18112
SHOW WAREHOUSES LIKE 'my_wh';

+---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------+
| name    | state   | type     | size    | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment | enable_query_acceleration | query_acceleration_max_scale_factor | resource_monitor | actives | pendings | failed | suspended | uuid       |
|---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------|
| MY_WH   | SUSPENDED | STANDARD | Medium |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-01-20 14:31:49.283 -0800 | 2023-01-20 14:31:49.388 -0800 | 2023-01-20 16:34:28.583 -0800 | ACCOUNTADMIN |         | true                      |                                   8 | null             |       0 |        0 |      0 |         4 | 1132659053 |
+---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------+

-- Example 18113
ALTER WAREHOUSE my_wh SET
  ENABLE_QUERY_ACCELERATION = true
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = 0;

-- Example 18114
SELECT query_id,
       query_text,
       warehouse_name,
       start_time,
       end_time,
       query_acceleration_bytes_scanned,
       query_acceleration_partitions_scanned,
       query_acceleration_upper_limit_scale_factor
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_acceleration_partitions_scanned > 0 
  AND start_time >= DATEADD(hour, -24, CURRENT_TIMESTAMP())
  ORDER BY query_acceleration_bytes_scanned DESC;

-- Example 18115
SELECT query_id,
       query_text,
       warehouse_name,
       start_time,
       end_time,
       query_acceleration_bytes_scanned,
       query_acceleration_partitions_scanned,
       query_acceleration_upper_limit_scale_factor
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_acceleration_partitions_scanned > 0 
  AND start_time >= DATEADD(hour, -24, CURRENT_TIMESTAMP())
  ORDER BY query_acceleration_partitions_scanned DESC;

-- Example 18116
SELECT warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE start_time >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1
  ORDER BY 2 DESC;

-- Example 18117
SELECT account_name,
       warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ORGANIZATION_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE usage_date >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1, 2
  ORDER BY 3 DESC;

-- Example 18118
SELECT start_time,
       end_time,
       credits_used,
       warehouse_name,
       num_files_scanned,
       num_bytes_scanned
  FROM TABLE(INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
    date_range_start=>DATEADD(H, -12, CURRENT_TIMESTAMP)));

-- Example 18119
WITH credits AS (
  SELECT 'QC' AS credit_type,
         TO_DATE(end_time) AS credit_date,
         SUM(credits_used) AS num_credits
    FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
    WHERE warehouse_name = 'my_warehouse'
    AND credit_date BETWEEN
           DATEADD(WEEK, -8, (
             SELECT TO_DATE(MIN(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
               WHERE warehouse_name = 'my_warehouse'
           ))
           AND
           DATEADD(WEEK, +8, (
             SELECT TO_DATE(MAX(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
               WHERE warehouse_name = 'my_warehouse'
           ))
  GROUP BY credit_date
  UNION ALL
  SELECT 'WC' AS credit_type,
         TO_DATE(end_time) AS credit_date,
         SUM(credits_used) AS num_credits
    FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
    WHERE warehouse_name = 'my_warehouse'
    AND credit_date BETWEEN
           DATEADD(WEEK, -8, (
             SELECT TO_DATE(MIN(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
               WHERE warehouse_name = 'my_warehouse'
           ))
           AND
           DATEADD(WEEK, +8, (
             SELECT TO_DATE(MAX(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
               WHERE warehouse_name = 'my_warehouse'
           ))
  GROUP BY credit_date
)
SELECT credit_date,
       SUM(IFF(credit_type = 'QC', num_credits, 0)) AS qas_credits,
       SUM(IFF(credit_type = 'WC', num_credits, 0)) AS compute_credits,
       compute_credits + qas_credits AS total_credits,
       AVG(total_credits) OVER (
         PARTITION BY NULL ORDER BY credit_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
         AS avg_total_credits_7days
  FROM credits
  GROUP BY credit_date
  ORDER BY credit_date;

-- Example 18120
WITH qas_eligible_or_accelerated AS (
  SELECT TO_DATE(qh.end_time) AS exec_date,
        COUNT(*) AS num_execs,
        SUM(qh.execution_time) AS exec_time,
        MAX(IFF(qh.query_acceleration_bytes_scanned > 0, 1, NULL)) AS qas_accel_flag
    FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY AS qh
    WHERE qh.warehouse_name = 'my_warehouse'
    AND TO_DATE(qh.end_time) BETWEEN
           DATEADD(WEEK, -8, (
             SELECT TO_DATE(MIN(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
              WHERE warehouse_name = 'my_warehouse'
           ))
           AND
           DATEADD(WEEK, +8, (
             SELECT TO_DATE(MAX(end_time))
               FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
              WHERE warehouse_name = 'my_warehouse'
           ))
    AND (qh.query_acceleration_bytes_scanned > 0
          OR
          EXISTS (
            SELECT 1
              FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE AS qae
               WHERE qae.query_id = qh.query_id
               AND qae.warehouse_name = qh.warehouse_name
          )
         )
    GROUP BY exec_date
)
SELECT exec_date,
       SUM(exec_time) OVER (
         PARTITION BY NULL ORDER BY exec_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) /
       NULLIFZERO(SUM(num_execs) OVER (
         PARTITION BY NULL ORDER BY exec_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
       ) AS avg_exec_time_7days,
      exec_time / NULLIFZERO(num_execs) AS avg_exec_time,
      qas_accel_flag,
      num_execs,
      exec_time
  FROM qas_eligible_or_accelerated;

-- Example 18121
SHOW ENDPOINTS IN SERVICE <name>

-- Example 18122
SHOW ENDPOINTS IN SERVICE echo_service;

-- Example 18123
+--------------+------+------------+----------+-----------+------------------------------------------------------------------------------+
| name         | port | port_range | protocol | is_public | ingress_url                                                                  |
|--------------+------+------------+----------+-----------+------------------------------------------------------------------------------|
| echoendpoint | 8080 |            | HTTP     | true      | d7qoajz-orgname-acctname.pp-snowflakecomputing.app                           |
+--------------+------+------------+----------+-----------+------------------------------------------------------------------------------+

-- Example 18124
from snowflake.snowpark.session import Session

@pytest.fixture(scope='module')
def session(request) -> Session:
    connection_parameters = {}
    return Session.builder.configs(...).create()

-- Example 18125
def fahrenheit_to_celsius(temp_f: float) -> float:
    """
    Converts fahrenheit to celsius
    """
    return (float(temp_f) - 32) * (5/9)

-- Example 18126
import fahrenheit_to_celsius

def test_fahrenheit_to_celsius():
    expected = 0.0
    actual = fahrenheit_to_celsius(32)
    assert expected == actual

-- Example 18127
from snowflake.snowpark.dataframe import DataFrame, col

def my_df_tranformer(df: DataFrame) -> DataFrame:
    return df \
        .with_column('c', df['a']+df['b']) \
        .filter(col('c') > 3)

-- Example 18128
# test/test_transformers.py

import my_df_transformer

def test_my_df_transformer(session):
    input_df = session.create_dataframe([[1,2],[3,4]], ['a', 'b'])
    expected_df = session.create_dataframe([3,4,7], ['a','b','c'])
    actual_df = my_df_transformer(input_df)
    assert input_df.collect() == actual_df.collect()

-- Example 18129
from project import my_sproc_handler  # import stored proc handler

def test_my_sproc_handler(session: Session):

    # Create input table
    input_tbl = session.create_dataframe(
        data=[...],
        schema=[...],
    )

    input_tbl.write.mode('overwrite').save_as_table(['DB', 'SCHEMA', 'INPUT_TBL'], mode='overwrite')

    # Create expected output dataframe
    expected_df = session.create_dataframe(
        data=[...],
        schema=[...],
    ).collect()

    # Call the stored procedure
    my_sproc_handler()

    # Get actual table
    actual_tbl = session.table(['DB', 'SCHEMA', 'OUTPUT_TBL']).collect()

    # Clean up tables
    session.table(['DB', 'SCHEMA', 'OUTPUT_TBL']).delete()
    session.table(['DB', 'SCHEMA', 'INPUT_TBL']).delete()

    # Compare the actual and expected tables
    assert expected_df == actual_tbl

-- Example 18130
pip install "snowflake-snowpark-python[localtest]"

-- Example 18131
from snowflake.snowpark import Session

session = Session.builder.config('local_testing', True).create()

-- Example 18132
df = session.create_dataframe([[1,2],[3,4]],['a','b'])
df.with_column('c', df['a']+df['b']).show()

-- Example 18133
col1,col2,col3,col4
1,a,true,1.23
2,b,false,4.56

-- Example 18134
from snowflake.snowpark.types import StructType, StructField, IntegerType, BooleanType, StringType, DoubleType


# Put file onto stage
session.file.put("data.csv", "@mystage", auto_compress=False)
schema = StructType(
    [
        StructField("col1", IntegerType()),
        StructField("col2", StringType()),
        StructField("col3", BooleanType()),
        StructField("col4", DoubleType()),
    ]
)

# with option SKIP_HEADER set to 1, the header will be skipped when the csv file is loaded
dataframe = session.read.schema(schema).option("SKIP_HEADER", 1).csv("@mystage/data.csv")
dataframe.show()

