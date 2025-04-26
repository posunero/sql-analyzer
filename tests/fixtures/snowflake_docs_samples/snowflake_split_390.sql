-- Example 26105
SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 26106
snowsql --bootstrap-version

-- Example 26107
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/darwin_x86_64/snowsql-<version>-darwin_x86_64.pkg

-- Example 26108
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/darwin_x86_64/snowsql-<version>-darwin_x86_64.pkg

-- Example 26109
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/darwin_x86_64/snowsql-1.3.3-darwin_x86_64.pkg

-- Example 26110
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/darwin_x86_64/snowsql-1.3.3-darwin_x86_64.pkg

-- Example 26111
installer -pkg snowsql-darwin_x86_64.pkg -target CurrentUserHomeDirectory

-- Example 26112
snowsql -v

-- Example 26113
Version: 1.3.0

-- Example 26114
snowsql -v 1.3.1

-- Example 26115
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 26116
brew install --cask snowflake-snowsql

-- Example 26117
alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql

-- Example 26118
SNOWSQL_DOWNLOAD_DIR=/var/shared snowsql -h

-- Example 26119
snowsql --bootstrap-version

-- Example 26120
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/windows_x86_64/snowsql-<version>-windows_x86_64.msi

-- Example 26121
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/<bootstrap_version>/windows_x86_64/snowsql-<version>-windows_x86_64.msi

-- Example 26122
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/windows_x86_64/snowsql-1.3.3-windows_x86_64.msi

-- Example 26123
curl -O https://sfc-repo.azure.snowflakecomputing.com/snowsql/bootstrap/1.3/windows_x86_64/snowsql-1.3.3-windows_x86_64.msi

-- Example 26124
C:\Users\<username> msiexec /i snowsql-windows_x86_64.msi /q

-- Example 26125
snowsql -v

-- Example 26126
Version: 1.3.1

-- Example 26127
snowsql -v 1.3.0

-- Example 26128
snowsql -v

-- Example 26129
Version: 1.3.1

-- Example 26130
snowsql -o noup=False

-- Example 26131
$ snowsql -v

  Version: 1.3.1

-- Example 26132
$ snowsql --versions

 1.3.1
 1.3.0

-- Example 26133
$ snowsql -v 1.3.0

  Installing version: 1.3.0 [####################################]  100%

-- Example 26134
$ snowsql -v 1.3.0

-- Example 26135
snowsql -o repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 26136
repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 26137
repository_base_url=https://sfc-repo.azure.snowflakecomputing.com/snowsql

-- Example 26138
create view myview as select * from mytable;

-- Example 26139
create stage my_ext_stage
  url='s3://load/files/'
  storage_integration = myint;

-- Example 26140
create or replace view v_on_stage_function
as
select *
from T1
where get_presigned_url(@stage1, 'data_0.csv.gz')
is not null;

-- Example 26141
CREATE OR REPLACE MATERIALIZED VIEW sales_view AS SELECT * FROM sales_staging_table;

-- Example 26142
SELECT referencing_object_name, referencing_object_domain, referenced_object_name, referenced_object_domain
FROM snowflake.account_usage.object_dependencies
WHERE referenced_object_name = 'SALES_STAGING_TABLE' and referenced_object_domain = 'EXTERNAL TABLE';

-- Example 26143
+-------------------------+---------------------------+------------------------+--------------------------+
| REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN |
+-------------------------+---------------------------+------------------------+--------------------------+
| SALES_VIEW              | MATERIALIZED VIEW         | SALES_STAGING_TABLE    | EXTERNAL TABLE           |
+-------------------------+---------------------------+------------------------+--------------------------+

-- Example 26144
CREATE TABLE sales_na(product string);
CREATE OR REPLACE VIEW north_america_sales AS SELECT * FROM sales_na;
CREATE VIEW us_sales AS SELECT * FROM north_america_sales;
CREATE VIEW cal_sales AS SELECT * FROM north_america_sales;

-- Example 26145
CREATE TABLE sales_uk (product string);
CREATE VIEW global_sales AS SELECT * FROM sales_uk UNION ALL SELECT * FROM north_america_sales;

-- Example 26146
WITH RECURSIVE referenced_cte
(object_name_path, referenced_object_name, referenced_object_domain, referencing_object_domain, referencing_object_name, referenced_object_id, referencing_object_id)
    AS
      (
        SELECT referenced_object_name || '-->' || referencing_object_name as object_name_path,
               referenced_object_name, referenced_object_domain, referencing_object_domain, referencing_object_name, referenced_object_id, referencing_object_id
          FROM snowflake.account_usage.object_dependencies referencing
          WHERE true
            AND referenced_object_name = 'SALES_NA' AND referenced_object_domain='TABLE'

        UNION ALL

        SELECT object_name_path || '-->' || referencing.referencing_object_name,
              referencing.referenced_object_name, referencing.referenced_object_domain, referencing.referencing_object_domain, referencing.referencing_object_name,
              referencing.referenced_object_id, referencing.referencing_object_id
          FROM snowflake.account_usage.object_dependencies referencing JOIN referenced_cte
            ON referencing.referenced_object_id = referenced_cte.referencing_object_id
            AND referencing.referenced_object_domain = referenced_cte.referencing_object_domain
      )

  SELECT object_name_path, referenced_object_name, referenced_object_domain, referencing_object_name, referencing_object_domain
    FROM referenced_cte
;

-- Example 26147
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+
| OBJECT_NAME_PATH                              | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN | REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN |
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+
| SALES_NA-->NORTH_AMERICA_SALES                | SALES_NA               | TABLE                    | NORTH_AMERICA_SALES     | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->CAL_SALES    | NORTH_AMERICA_SALES    | VIEW                     | CAL_SALES               | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->US_SALES     | NORTH_AMERICA_SALES    | VIEW                     | US_SALES                | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->GLOBAL_SALES | NORTH_AMERICA_SALES    | VIEW                     | GLOBAL_SALES            | VIEW                      |
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+

-- Example 26148
CREATE TABLE sales_na (product string);
CREATE OR REPLACE VIEW north_america_sales AS SELECT * FROM sales_na;
CREATE TABLE sales_uk (product string);
CREATE VIEW global_sales AS SELECT * FROM sales_uk UNION ALL SELECT * FROM north_america_sales;

-- Example 26149
WITH RECURSIVE referenced_cte
(object_name_path, referenced_object_name, referenced_object_domain, referencing_object_domain, referencing_object_name, referenced_object_id, referencing_object_id)
    AS
      (
        SELECT referenced_object_name || '<--' || referencing_object_name AS object_name_path,
               referenced_object_name, referenced_object_domain, referencing_object_domain, referencing_object_name, referenced_object_id, referencing_object_id
          from snowflake.account_usage.object_dependencies referencing
          WHERE true
            AND referencing_object_name = 'GLOBAL_SALES' and referencing_object_domain='VIEW'

        UNION ALL

        SELECT referencing.referenced_object_name || '<--' || object_name_path,
              referencing.referenced_object_name, referencing.referenced_object_domain, referencing.referencing_object_domain, referencing.referencing_object_name,
              referencing.referenced_object_id, referencing.referencing_object_id
          FROM snowflake.account_usage.object_dependencies referencing JOIN referenced_cte
            ON referencing.referencing_object_id = referenced_cte.referenced_object_id
            AND referencing.referencing_object_domain = referenced_cte.referenced_object_domain
      )

  SELECT object_name_path, referencing_object_name, referencing_object_domain, referenced_object_name, referenced_object_domain
    FROM referenced_cte
;

-- Example 26150
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+
| OBJECT_NAME_PATH                              | REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN |
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+
| SALES_UK<--GLOBAL_SALES                       | GLOBAL_SALES            | VIEW                      | SALES_UK               | TABLE                    |
| NORTH_AMERICA_SALES<--GLOBAL_SALES            | GLOBAL_SALES            | VIEW                      | NORTH_AMERICA_SALES    | VIEW                     |
| SALES_NA<--NORTH_AMERICA_SALES<--GLOBAL_SALES | NORTH_AMERICA_SALES     | VIEW                      | SALES_NA               | TABLE                    |
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+

-- Example 26151
ALTER ACCOUNT my_account1 DROP OLD URL;

-- Example 26152
ALTER ACCOUNT my_account1 DROP OLD ORGANIZATION URL;

-- Example 26153
SHOW REPLICATION ACCOUNTS;

+------------------+---------------------------------+---------------+------------------+---------+-------------------+
| snowflake_region | created_on                      | account_name  | account_locator  | comment | organization_name |
|------------------+---------------------------------+---------------+------------------+---------+-------------------|
| AWS_US_WEST_2    | 2018-11-19 16:11:12.720 -0700   | ACCOUNT1      | MYACCOUNT1       |         | MYORG             |
| AWS_US_EAST_1    | 2019-06-02 14:12:23.192 -0700   | ACCOUNT2      | MYACCOUNT2       |         | MYORG             |
+------------------+---------------------------------+---------------+------------------+---------+-------------------+

-- Example 26154
ALTER DATABASE mydb1 ENABLE REPLICATION TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 26155
-- Executed from primary account
ALTER DATABASE mydb1 ENABLE FAILOVER TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 26156
-- Log into the ACCOUNT2 account.

-- Query the set of primary and secondary databases in your organization.
-- In this example, the MYORG.ACCOUNT1 primary database is available to replicate.
SHOW REPLICATION DATABASES;

+------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------+
| snowflake_region | created_on                    | account_name    | name     | comment | is_primary | primary                    | replication_allowed_to_accounts | failover_allowed_to_accounts | organization_name | account_locator |
|------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------|
| AWS_US_WEST_2    | 2019-11-15 00:51:45.473 -0700 | ACCOUNT1        | MYDB1    | NULL    | true       | MYORG.ACCOUNT1.MYDB1       | MYORG.ACCOUNT2, MYORG,ACCOUNT1  | MYORG.ACCOUNT1               | MYORG             | MYACCOUNT1      |
+------------------+-------------------------------+-----------------+----------+---------+------------+----------------------------+---------------------------------+------------------------------+-------------------+-----------------+

-- Create a replica of the 'mydb1' primary database
-- If the primary database has the DATA_RETENTION_TIME_IN_DAYS parameter set to a value other than the default value,
-- set the same value for the parameter on the secondary database.
CREATE DATABASE mydb1
  AS REPLICA OF myorg.account1.mydb1
  DATA_RETENTION_TIME_IN_DAYS = 10;

-- Verify the secondary database
SHOW REPLICATION DATABASES;

+------------------+-------------------------------+---------------+----------+---------+------------+-------------------------+---------------------------------+------------------------------+-------------------+-----------------+
| snowflake_region | created_on                    | account_name  | name     | comment | is_primary | primary                 | replication_allowed_to_accounts | failover_allowed_to_accounts | organization_name | account_locator |
|------------------+-------------------------------+---------------+----------+---------+------------+------------------------------------------+----------------+------------------------------+-------------------------------------|
| AWS_US_WEST_2    | 2019-11-15 00:51:45.473 -0700 | ACCOUNT1      | MYDB1    | NULL    | true       | MYORG.ACCOUNT1.MYDB1    | MYORG.ACCOUNT2, MYORG.ACCOUNT1  | MYORG.ACCOUNT1               | MYORG             | MYACCOUNT1      |
| AWS_US_EAST_1    | 2019-08-15 15:51:49.094 -0700 | ACCOUNT2      | MYDB1    | NULL    | false      | MYORG.ACCOUNT1.MYDB1    |                                 |                              | MYORG             | MYACCOUNT2      |
+------------------+-------------------------------+---------------+----------+---------+------------+-------------------------+---------------------------------+------------------------------+-------------------+-----------------+

-- Example 26157
ALTER DATABASE mydb1 REFRESH;

-- Example 26158
CREATE TASK refresh_mydb1_task
  WAREHOUSE = mywh
  SCHEDULE = '10 minute'
  USER_TASK_TIMEOUT_MS = 14400000
AS
  ALTER DATABASE mydb1 REFRESH;

-- Example 26159
ALTER TASK refresh_mydb1_task RESUME;

-- Example 26160
-- The commands below are executed from the source account

-- View replication enabled accounts
SHOW REPLICATION ACCOUNTS;

ALTER DATABASE mydb ENABLE REPLICATION TO ACCOUNTS myorg.account2, myorg.account3;
ALTER DATABASE mydb ENABLE FAILOVER TO ACCOUNTS myorg.account2, myorg.account3;

-- Example 26161
-- The commands below are executed from each target account

-- View replication enabled databases
-- Note the primary column of the source database for the CREATE DATABASE statement below
SHOW REPLICATION DATABASES;

-- If the primary database has the DATA_RETENTION_TIME_IN_DAYS parameter set to a value other than the default value,
-- set the same value for the parameter on the secondary database.
CREATE DATABASE mydb
  AS REPLICA OF myorg.account1.mydb
  DATA_RETENTION_TIME_IN_DAYS = 10;

-- Increase statement timeout for initial refresh
-- Optional but recommended for initial refresh of a large database
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;
-- If you have an active warehouse in current session, update warehouse statement timeout
SELECT CURRENT_WAREHOUSE();
ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;
-- Reset warehouse statement timeout after initial refresh
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Refresh a secondary database
ALTER DATABASE mydb REFRESH;

-- Create task
-- Set up refresh schedule for each secondary database using a separate database
USE DATABASE my_db2;

-- Create a task and RESUME the task for each secondary database
-- Edit the task schedule and timeout for your specific use case
CREATE TASK my_refresh_task
  WAREHOUSE = my_wh
  SCHEDULE = '10 minute'
  USER_TASK_TIMEOUT_MS = 14400000
AS
  ALTER DATABASE mydb REFRESH;

-- Start task
ALTER TASK my_refresh_task RESUME;

-- Example 26162
ALTER SESSION SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 26163
-- determine the active warehouse in the current session (if any)
SELECT CURRENT_WAREHOUSE();

+---------------------+
| CURRENT_WAREHOUSE() |
|---------------------|
| MY_WH               |
+---------------------+

-- change the STATEMENT_TIMEOUT_IN_SECONDS value for the active warehouse

ALTER WAREHOUSE my_wh SET STATEMENT_TIMEOUT_IN_SECONDS = 604800;

-- Example 26164
ALTER WAREHOUSE my_wh UNSET STATEMENT_TIMEOUT_IN_SECONDS;

-- Example 26165
select *
  from table(information_schema.database_refresh_progress(mydb1));

-- Example 26166
select *
  from table(information_schema.database_refresh_history(mydb1));

-- Example 26167
SELECT TO_DATE(start_time) AS date,
  database_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.database_replication_usage_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2
ORDER BY 3 DESC;

-- Example 26168
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.database_replication_usage_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
  AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 26169
select parse_json(details)['snapshot_transaction_timestamp']
from table(information_schema.database_refresh_progress(mydb))
where phase_name = 'PRIMARY_UPLOADING_DATA';

-- Example 26170
SELECT HASH_AGG( * ) FROM mytable;

-- Example 26171
SELECT HASH_AGG( * ) FROM mytable AT(TIMESTAMP => '<snapshot_transaction_timestamp>'::TIMESTAMP);

