-- Example 10834
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 10835
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 10836
CREATE REPLICATION GROUP my_rg
  OBJECT_TYPES = databases, shares
  ALLOWED_DATABASES = database1, database2, database3
  ALLOWED_SHARES = share1
  ALLOWED_ACCOUNTS = acme.account_2;

-- Example 10837
USE ROLE ACCOUNTADMIN;

CREATE REPLICATION GROUP my_rg
  AS REPLICA OF acme_org.account_1.my_rg;

-- Example 10838
ALTER REPLICATION GROUP my_rg REFRESH;

-- Example 10839
ALTER SHARE share1 ADD ACCOUNTS = consumer_org.consumer_account_name;

-- Example 10840
SELECT query_id,
  ROW_NUMBER() OVER(ORDER BY partitions_scanned DESC) AS query_id_int,
  query_text,
  total_elapsed_time/1000 AS query_execution_time_seconds,
  partitions_scanned,
  partitions_total,
FROM snowflake.account_usage.query_history Q
WHERE warehouse_name = 'my_warehouse' AND TO_DATE(Q.start_time) > DATEADD(day,-1,TO_DATE(CURRENT_TIMESTAMP()))
  AND total_elapsed_time > 0 --only get queries that actually used compute
  AND error_code IS NULL
  AND partitions_scanned IS NOT NULL
ORDER BY total_elapsed_time desc
LIMIT 50;

-- Example 10841
SELECT
  CASE
    WHEN Q.total_elapsed_time <= 60000 THEN 'Less than 60 seconds'
    WHEN Q.total_elapsed_time <= 300000 THEN '60 seconds to 5 minutes'
    WHEN Q.total_elapsed_time <= 1800000 THEN '5 minutes to 30 minutes'
    ELSE 'more than 30 minutes'
  END AS BUCKETS,
  COUNT(query_id) AS number_of_queries
FROM snowflake.account_usage.query_history Q
WHERE  TO_DATE(Q.START_TIME) >  DATEADD(month,-1,TO_DATE(CURRENT_TIMESTAMP()))
  AND total_elapsed_time > 0
  AND warehouse_name = 'my_warehouse'
GROUP BY 1;

-- Example 10842
SELECT
    query_hash,
    COUNT(*),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE warehouse_name = 'MY_WAREHOUSE'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 7
  GROUP BY query_hash
  ORDER BY SUM(total_elapsed_time) DESC
  LIMIT 100;

-- Example 10843
SELECT
    DATE_TRUNC('day', start_time),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_parameterized_hash = 'cbd58379a88c37ed6cc0ecfebb053b03'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 30
  GROUP BY DATE_TRUNC('day', start_time);

-- Example 10844
SELECT TO_DATE(start_time) AS date,
  warehouse_name,
  SUM(avg_running) AS sum_running,
  SUM(avg_queued_load) AS sum_queued
FROM snowflake.account_usage.warehouse_load_history
WHERE TO_DATE(start_time) >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
HAVING SUM(avg_queued_load) >0;

-- Example 10845
SELECT DATEDIFF(seconds, query_start_time,completed_time) AS duration_seconds,*
FROM snowflake.account_usage.task_history
WHERE state = 'SUCCEEDED'
  AND query_start_time >= DATEADD (day, -1, CURRENT_TIMESTAMP())
ORDER BY duration_seconds DESC;

-- Example 10846
SELECT
  SUM(quantity) AS sum_qty,
  SUM(extendedprice) AS sum_base_price,
  AVG(quantity) AS avg_qty,
  AVG(extendedprice) AS avg_price,
  COUNT(*) AS count_order
FROM lineitem
WHERE shipdate >= DATEADD(day, -90, to_date('2023-01-01));

-- Example 10847
SELECT error_message, receiver_ip
FROM logs
WHERE sender_ip IN ('198.2.2.1', '198.2.2.2');

-- Example 10848
SELECT
  orderdate,
  SUM(totalprice)
FROM mv_view1
GROUP BY 1;

-- Example 10849
USE ROLE ACCOUNTADMIN;

CREATE ROLE cost_viewer_role;
GRANT APPLICATION ROLE APP_USAGE_VIEWER TO ROLE cost_viewer_role;
GRANT DATABASE ROLE USAGE_VIEWER TO ROLE cost_viewer_role;
GRANT ROLE cost_viewer_role TO USER joe;

-- Example 10850
ALTER TABLE t1 SUSPEND RECLUSTER;

-- Example 10851
DROP MATERIALIZED VIEW mv1;

-- Example 10852
ALTER TABLE t1 DROP SEARCH OPTIMIZATION;

-- Example 10853
DROP TABLE t1;

-- Example 10854
DROP TABLE t1;

-- Example 10855
CREATE TRANSIENT TABLE t1;

-- Example 10856
ALTER WAREHOUSE wh1 SET MIN_CLUSTER_COUNT = 1;

-- Example 10857
USE ROLE tag_admin;

CREATE DATABASE cost_management;
CREATE SCHEMA tags;

-- Example 10858
CREATE TAG cost_center
  ALLOWED_VALUES 'finance', 'marketing', 'engineering', 'product';

-- Example 10859
CREATE REPLICATION GROUP cost_management_repl_group
  OBJECT_TYPES = DATABASES
  ALLOWED_DATABASES = cost_management
  ALLOWED_ACCOUNTS = my_org.my_account_1, my_org.my_account_2
  REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 10860
CREATE REPLICATION GROUP cost_management_repl_group
  AS REPLICA OF my_org.my_org_account.cost_management_repl_group;

ALTER REPLICATION GROUP cost_management_repl_group REFRESH;

-- Example 10861
USE ROLE tag_admin;

ALTER WAREHOUSE warehouse1 SET TAG cost_management.tags.cost_center='SALES';
ALTER WAREHOUSE warehouse2 SET TAG cost_management.tags.cost_center='SALES';
ALTER WAREHOUSE warehouse3 SET TAG cost_management.tags.cost_center='FINANCE';

ALTER USER finance_user SET TAG cost_management.tags.cost_center='FINANCE';
ALTER USER sales_user SET TAG cost_management.tags.cost_center='SALES';

-- Example 10862
SELECT
    TAG_REFERENCES.tag_name,
    COALESCE(TAG_REFERENCES.tag_value, 'untagged') AS tag_value,
    SUM(WAREHOUSE_METERING_HISTORY.credits_used_compute) AS total_credits
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      LEFT JOIN SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
        ON WAREHOUSE_METERING_HISTORY.warehouse_id = TAG_REFERENCES.object_id
          AND TAG_REFERENCES.domain = 'WAREHOUSE'
  WHERE
    WAREHOUSE_METERING_HISTORY.start_time >= DATE_TRUNC('MONTH', DATEADD(MONTH, -1, CURRENT_DATE))
      AND WAREHOUSE_METERING_HISTORY.start_time < DATE_TRUNC('MONTH',  CURRENT_DATE)
  GROUP BY TAG_REFERENCES.tag_name, COALESCE(TAG_REFERENCES.tag_value, 'untagged')
  ORDER BY total_credits DESC;

-- Example 10863
+-------------+-------------+-----------------+
| TAG_NAME    | TAG_VALUE   |   TOTAL_CREDITS |
|-------------+-------------+-----------------|
| NULL        | untagged    |    20.360277159 |
| COST_CENTER | Sales       |    17.173333333 |
| COST_CENTER | Finance     |      8.14444444 |
+-------------+-------------+-----------------+

-- Example 10864
SELECT
    TAG_REFERENCES.tag_name,
    COALESCE(TAG_REFERENCES.tag_value, 'untagged') AS tag_value,
    SUM(WAREHOUSE_METERING_HISTORY.credits_used_compute) AS total_credits
  FROM
    SNOWFLAKE.ORGANIZATION_USAGE.WAREHOUSE_METERING_HISTORY
      LEFT JOIN SNOWFLAKE.ORGANIZATION_USAGE.TAG_REFERENCES
        ON WAREHOUSE_METERING_HISTORY.warehouse_id = TAG_REFERENCES.object_id
          AND TAG_REFERENCES.domain = 'WAREHOUSE'
          AND tag_database = 'COST_MANAGEMENT' AND tag_schema = 'TAGS'
  WHERE
    WAREHOUSE_METERING_HISTORY.start_time >= DATE_TRUNC('MONTH', DATEADD(MONTH, -1, CURRENT_DATE))
      AND WAREHOUSE_METERING_HISTORY.start_time < DATE_TRUNC('MONTH',  CURRENT_DATE)
  GROUP BY TAG_REFERENCES.tag_name, COALESCE(TAG_REFERENCES.tag_value, 'untagged')
  ORDER BY total_credits DESC;

-- Example 10865
WITH
  wh_bill AS (
    SELECT SUM(credits_used_compute) AS compute_credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
        AND start_time < CURRENT_DATE
  ),
  user_credits AS (
    SELECT user_name, SUM(credits_attributed_compute) AS credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
        AND start_time < CURRENT_DATE
      GROUP BY user_name
  ),
  total_credit AS (
    SELECT SUM(credits) AS sum_all_credits
    FROM user_credits
  )
SELECT
    u.user_name,
    u.credits / t.sum_all_credits * w.compute_credits AS attributed_credits
  FROM user_credits u, total_credit t, wh_bill w
  ORDER BY attributed_credits DESC;

-- Example 10866
+-----------+--------------------+
| USER_NAME | ATTRIBUTED_CREDITS |
|-----------+--------------------+
| FINUSER   | 6.603575468        |
| SALESUSER | 4.321378049        |
| ENGUSER   | 0.6217131392       |
|-----------+--------------------+

-- Example 10867
WITH joined_data AS (
  SELECT
      tr.tag_name,
      tr.tag_value,
      qah.credits_attributed_compute,
      qah.start_time
    FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES tr
      JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY qah
        ON tr.domain = 'USER' AND tr.object_name = qah.user_name
)
SELECT
    tag_name,
    tag_value,
    SUM(credits_attributed_compute) AS total_credits
  FROM joined_data
  WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY tag_name, tag_value
  ORDER BY tag_name, tag_value;

-- Example 10868
+-------------+-------------+-----------------+
| TAG_NAME    | TAG_VALUE   |   TOTAL_CREDITS |
|-------------+-------------+-----------------|
| COST_CENTER | engineering |   0.02493688426 |
| COST_CENTER | finance     |    0.2281084988 |
| COST_CENTER | marketing   |    0.3686840545 |
|-------------+-------------+-----------------|

-- Example 10869
SELECT user_name, SUM(credits_attributed_compute) AS credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE
    start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
    AND start_time < CURRENT_DATE
  GROUP BY user_name;

-- Example 10870
+-----------+--------------------+
| USER_NAME | ATTRIBUTED_CREDITS |
|-----------+--------------------|
| JSMITH    |       17.173333333 |
| MJONES    |         8.14444444 |
| SYSTEM    |         5.33985393 |
+-----------+--------------------+

-- Example 10871
SELECT qah.user_name, SUM(qah.credits_attributed_compute) as total_credits
  FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY qah
    LEFT JOIN snowflake.account_usage.tag_references tr
    ON qah.user_name = tr.object_name AND tr.DOMAIN = 'USER'
  WHERE
    start_time >= dateadd(month, -1, current_date)
    AND qah.user_name IS NULL OR tr.object_name IS NULL
  GROUP BY qah.user_name
  ORDER BY total_credits DESC;

-- Example 10872
+------------+---------------+
| USER_NAME  | TOTAL_CREDITS |
|------------+---------------|
| RSMITH     |  0.1830555556 |
+------------+---------------+

-- Example 10873
ALTER SESSION SET QUERY_TAG = 'COST_CENTER=finance';

-- Example 10874
SELECT
    query_tag,
    SUM(credits_attributed_compute) AS compute_credits,
    SUM(credits_used_query_acceleration) AS qas
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE query_tag = 'COST_CENTER=finance'
  GROUP BY query_tag;

-- Example 10875
+---------------------+-----------------+------+
| QUERY_TAG           | COMPUTE_CREDITS | QAS  |
|---------------------+-----------------|------|
| COST_CENTER=finance |      0.00576115 | null |
+---------------------+-----------------+------+

-- Example 10876
SELECT
    COALESCE(NULLIF(query_tag, ''), 'untagged') AS tag,
    SUM(credits_attributed_compute) AS compute_credits,
    SUM(credits_used_query_acceleration) AS qas
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
  GROUP BY tag
  ORDER BY compute_credits DESC;

-- Example 10877
+-------------------------+-----------------+------+
| TAG                     | COMPUTE_CREDITS | QAS  |
|-------------------------+-----------------+------+
| untagged                | 3.623173449     | null |
| COST_CENTER=engineering | 0.531431948     | null |
|-------------------------+-----------------+------+

-- Example 10878
WITH
  wh_bill AS (
    SELECT SUM(credits_used_compute) AS compute_credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
      WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
      AND start_time < CURRENT_DATE
  ),
  tag_credits AS (
    SELECT
        COALESCE(NULLIF(query_tag, ''), 'untagged') AS tag,
        SUM(credits_attributed_compute) AS credits
      FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
      WHERE start_time >= DATEADD(MONTH, -1, CURRENT_DATE)
      GROUP BY tag
  ),
  total_credit AS (
    SELECT SUM(credits) AS sum_all_credits
      FROM tag_credits
  )
SELECT
    tc.tag,
    tc.credits / t.sum_all_credits * w.compute_credits AS attributed_credits
  FROM tag_credits tc, total_credit t, wh_bill w
  ORDER BY attributed_credits DESC;

-- Example 10879
+-------------------------+--------------------+
| TAG                     | ATTRIBUTED_CREDITS |
+-------------------------+--------------------|
| untagged                |        9.020031304 |
| COST_CENTER=finance     |        1.027742521 |
| COST_CENTER=engineering |        1.018755812 |
| COST_CENTER=marketing   |       0.4801370376 |
+-------------------------+--------------------+

-- Example 10880
SELECT query_parameterized_hash,
       COUNT(*) AS query_count,
       SUM(credits_attributed_compute) AS total_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE start_time >= DATE_TRUNC('MONTH', CURRENT_DATE)
  AND start_time < CURRENT_DATE
  GROUP BY query_parameterized_hash
  ORDER BY total_credits DESC
  LIMIT 20;

-- Example 10881
SET query_id = '<query_id>';

SELECT query_id,
       parent_query_id,
       root_query_id,
       direct_objects_accessed
  FROM SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY
  WHERE query_id = $query_id;

-- Example 10882
SET query_id = '<root_query_id>';

SELECT SUM(credits_attributed_compute) AS total_attributed_credits
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY
  WHERE (root_query_id = $query_id OR query_id = $query_id);

-- Example 10883
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN ACCOUNT;
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN USER <username>;
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN SESSION;
SHOW PARAMETERS LIKE 'STATEMENT_TIMEOUT_IN_SECONDS' IN WAREHOUSE <warehouse_name>;

-- Example 10884
ALTER ACCOUNT SET STATEMENT_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER USER <username> SET STATEMENT_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER WAREHOUSE <warehouse_name> SET STATEMENT_TIMEOUT_IN_SECONDS = <number_of_seconds>;

-- Example 10885
SHOW PARAMETERS LIKE 'STATEMENT_QUEUED_TIMEOUT_IN_SECONDS' IN ACCOUNT;
SHOW PARAMETERS LIKE 'STATEMENT_QUEUED_TIMEOUT_IN_SECONDS' IN USER <username>;
SHOW PARAMETERS LIKE 'STATEMENT_QUEUED_TIMEOUT_IN_SECONDS' IN SESSION;
SHOW PARAMETERS LIKE 'STATEMENT_QUEUED_TIMEOUT_IN_SECONDS' IN WAREHOUSE <warehouse_name>;

-- Example 10886
ALTER ACCOUNT SET STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER USER <username> SET STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER SESSION SET STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <number_of_seconds>;
ALTER WAREHOUSE <warehouse_name> SET STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = <number_of_seconds>;

-- Example 10887
SHOW WAREHOUSES
;

SELECT "name" AS WAREHOUSE_NAME
    ,"size" AS WAREHOUSE_SIZE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE IFNULL("auto_suspend",0) = 0;

-- Example 10888
SHOW WAREHOUSES
;

SELECT "name" AS WAREHOUSE_NAME
    ,"size" AS WAREHOUSE_SIZE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "auto_resume" = 'false';

-- Example 10889
SELECT "name" AS WAREHOUSE_NAME
      ,"size" AS WAREHOUSE_SIZE
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "resource_monitor" = 'null'
;

-- Example 10890
SELECT date,
       contract_number,
       (capacity_balance + free_usage_balance + rollover_balance) AS remaining_balance
  FROM snowflake.organization_usage.remaining_balance_daily
  WHERE TRUE
    AND date = LAST_DAY(TO_DATE('2024-01-01'));

-- Example 10891
SELECT contract_number,
       SUM(usage_in_currency) AS total_consumed
  FROM snowflake.organization_usage.usage_in_currency_daily
  WHERE TRUE
    AND usage_date <= LAST_DAY(TO_DATE('2024-01-01'))
    AND LOWER(balance_source) != 'overage'
  GROUP BY 1
  ORDER BY 1;

-- Example 10892
SELECT contract_number,
       DATE_TRUNC(month, usage_date) AS usage_month,
       CONCAT(account_locator,'-',region) AS account_name,
       SUM(usage_in_currency) AS total_consumed,
  FROM snowflake.organization_usage.usage_in_currency_daily
  WHERE TRUE
    AND usage_month = DATE_TRUNC(month,to_date('2024-01-01'))
    AND LOWER(balance_source) != 'overage'
  GROUP BY 1,2,3
  ORDER BY 1,2,3;

-- Example 10893
SELECT contract_number,
       DATE_TRUNC(month, usage_date) AS usage_month,
       CONCAT(account_locator,'-',region) AS account_name,
       usage_type AS usage_category,
       SUM(usage) AS units_consumed,
       SUM(usage_in_currency) AS total_usage
  FROM snowflake.organization_usage.usage_in_currency_daily
  WHERE TRUE
    AND usage_month = DATE_TRUNC(month, TO_DATE('2024-01-01'))
  GROUP BY 1,2,3,4
  ORDER BY 1,2,3,4;

-- Example 10894
[connections]
# *WARNING* *WARNING* *WARNING* *WARNING* *WARNING* *WARNING*
#
# The Snowflake user password is stored in plain text in this file.
# Pay special attention to the management of this file.
# Thank you.
#
# *WARNING* *WARNING* *WARNING* *WARNING* *WARNING* *WARNING*

#If a connection doesn't specify a value, it will default to these
#
#accountname = defaultaccount
#region = defaultregion
#username = defaultuser
#password = defaultpassword
#dbname = defaultdbname
#schemaname = defaultschema
#warehousename = defaultwarehouse
#rolename = defaultrolename
#proxy_host = defaultproxyhost
#proxy_port = defaultproxyport

[connections.example]
#Can be used in SnowSql as #connect example

accountname = my_organization-my_account
username = username
password = password1234

[variables]
# SnowSQL defines the variables in this section on startup.
# You can use these variables in SQL statements. For details, see
# https://docs.snowflake.com/en/user-guide/snowsql-use.html#using-variables

# example_variable=27

[options]
# If set to false auto-completion will not occur interactive mode.
auto_completion = True

# main log file location. The file includes the log from SnowSQL main
# executable.
log_file = ~/.snowsql/log

# bootstrap log file location. The file includes the log from SnowSQL bootstrap
# executable.
# log_bootstrap_file = ~/.snowsql/log_bootstrap

# Default log level. Possible values: "CRITICAL", "ERROR", "WARNING", "INFO"
# and "DEBUG".
log_level = INFO

# Timing of sql statements and table rendering.
timing = True

# Table format. Possible values: psql, plain, simple, grid, fancy_grid, pipe,
# orgtbl, rst, mediawiki, html, latex, latex_booktabs, tsv.
# Recommended: psql, fancy_grid and grid.
output_format = psql

# Keybindings: Possible values: emacs, vi.
# Emacs mode: Ctrl-A is home, Ctrl-E is end. All emacs keybindings are available in the REPL.
# When Vi mode is enabled you can use modal editing features offered by Vi in the REPL.
key_bindings = emacs

# OCSP Fail Open Mode.
# The only OCSP scenario which will lead to connection failure would be OCSP response with a
# revoked status. Any other errors or in the OCSP module will not raise an error.
# ocsp_fail_open = True

# Enable temporary credential file for Linux users
# For Linux users, since there are no OS-key-store, an unsecure temporary credential for SSO can be enabled by this option. The default value for this option is False.
# client_store_temporary_credential = True

# Select statement split method (default is to use the sql_split method in snowsql, which does not support 'sql_delimiter')
# sql_split = snowflake.connector.util_text # to use connector's statement_split which has legacy support to 'sql_delimiter'.

# Force the result data to be decoded in utf-8. By default the value is set to false for compatibility with legacy data. It is recommended to set the value to true.
# json_result_force_utf8_decoding = False

-- Example 10895
$ chmod 700 ~/.snowsql/config

-- Example 10896
password = "my$^pwd"

-- Example 10897
password = "my$^\"\'pwd"

-- Example 10898
prompt_format='''[#FFFF00][user]@[account]
[#00FF00]> '''

-- Example 10899
[options]
<option_name> = <option_value>

-- Example 10900
+----------------------------+---------------------+------------------------------------------------------------------------------------+
| Name                       | Value               | Help                                                                               |
+----------------------------+---------------------+------------------------------------------------------------------------------------+
| auto_completion            | True                | Displays auto-completion suggestions for commands and Snowflake objects.           |
| client_session_keep_alive  | False               | Keeps the session active indefinitely, even if there is no activity from the user. |
| echo                       | False               | Outputs the SQL command to the terminal when it is executed.                       |
| editor                     | vim                 | Changes the editor to use for the !edit command.                                   |
| empty_for_null_in_tsv      | False               | Outputs an empty string for NULL values in TSV format.                             |
| environment_variables      | ['PATH']            | Specifies the environment variables that can be referenced as SnowSQL variables.   |
|                            |                     | The variable names should be comma separated.                                      |
| execution_only             | False               | Executes queries only.                                                             |
| exit_on_error              | False               | Quits when SnowSQL encounters an error.                                            |
| fix_parameter_precedence   | True                | Controls the precedence of the environment variable and the config file entries    |
|                            |                     | for password, proxy password, and private key phrase.                              |
| force_put_overwrite        | False               | Force PUT command to stage data files without checking whether already exists.     |
| friendly                   | True                | Shows the splash text and goodbye messages.                                        |
| header                     | True                | Outputs the header in query results.                                               |
| insecure_mode              | False               | Turns off OCSP certificate checks.                                                 |
| key_bindings               | emacs               | Changes keybindings for navigating the prompt to emacs or vi.                      |
| log_bootstrap_file         | ~/.snowsql/log_...  | SnowSQL bootstrap log file location.                                               |
| log_file                   | ~/.snowsql/log      | SnowSQL main log file location.                                                    |
| log_level                  | CRITICAL            | Changes the log level (critical, debug, info, error, warning).                     |
| login_timeout              | 120                 | Login timeout in seconds.                                                          |
| noup                       | False               | Turns off auto upgrading SnowSQL.                                                  |
| output_file                | None                | Writes output to the specified file in addition to the terminal.                   |
| output_format              | psql                | Sets the output format for query results.                                          |
| paging                     | False               | Enables paging to pause output per screen height.                                  |
| progress_bar               | True                | Shows progress bar while transferring data.                                        |
| prompt_format              | [user]#[warehou...] | Sets the prompt format. Experimental feature, currently not documented.            |
| sfqid                      | False               | Turns on/off Snowflake query id in the summary.                                    |
| sfqid_in_error             | False               | Turns on/off Snowflake query id in the error message.                              |
| quiet                      | False               | Hides all output.                                                                  |
| remove_comments            | False               | Removes comments before sending query to Snowflake.                                |
| remove_trailing_semicolons | True                | Removes trailing semicolons from SQL text before sending queries to Snowflake.     |
| results                    | True                | If set to off, queries will be sent asynchronously, but no results will be fetched.|
|                            |                     | Use !queries to check the status.                                                  |
| rowset_size                | 1000                | Sets the size of rowsets to fetch from the server.                                 |
|                            |                     | Set the option low for smooth output, high for fast output.                        |
| stop_on_error              | False               | Stops all queries yet to run when SnowSQL encounters an error.                     |
| syntax_style               | default             | Sets the colors for the text of SnowSQL.                                           |
| timing                     | True                | Turns on/off timing for each query.                                                |
| timing_in_output_file      | False               | Includes timing in the output file.                                                |
| variable_substitution      | False               | Substitutes variables (starting with '&') with values.                             |
| version                    | 1.1.70              | Returns SnowSQL version.                                                           |
| wrap                       | True                | Truncates lines at the width of the terminal screen.                               |
+----------------------------+---------------------+------------------------------------------------------------------------------------+

