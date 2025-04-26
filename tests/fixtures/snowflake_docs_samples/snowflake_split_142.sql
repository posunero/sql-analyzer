-- Example 9495
CREATE STAGE my_int_stage
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

-- Example 9496
CREATE TEMPORARY STAGE my_temp_int_stage;

-- Example 9497
CREATE TEMPORARY STAGE my_int_stage
  FILE_FORMAT = my_csv_format;

-- Example 9498
CREATE STAGE mystage
  DIRECTORY = (ENABLE = TRUE)
  FILE_FORMAT = myformat;

-- Example 9499
CREATE STAGE my_ext_stage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 9500
CREATE STAGE my_ext_stage1
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z');

-- Example 9501
CREATE STAGE my_ext_stage2
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(MASTER_KEY = 'eSx...');

-- Example 9502
CREATE STAGE my_ext_stage3
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 9503
CREATE STAGE my_ext_stage3
  URL='s3://load/encrypted_files/'
  CREDENTIALS=(AWS_ROLE='arn:aws:iam::001234567890:role/mysnowflakerole')
  ENCRYPTION=(TYPE='AWS_SSE_KMS' KMS_KEY_ID = 'aws/key');

-- Example 9504
CREATE STAGE mystage
  URL='s3://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  );

-- Example 9505
CREATE STAGE my_ext_stage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 9506
CREATE STAGE mystage
  URL='gcs://load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 9507
CREATE STAGE my_ext_stage2
  URL='gcs://load/encrypted_files/'
  STORAGE_INTEGRATION = my_storage_int
  ENCRYPTION=(TYPE = 'GCS_SSE_KMS' KMS_KEY_ID = '{a1b2c3});

-- Example 9508
CREATE STAGE my_ext_stage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = myint;

-- Example 9509
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/mycontainer/files/'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=bgqQwoXwxzuD2GJfagRg7VOS8hzNr3QLT7rhS8OFRLQ%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'kPx...');

-- Example 9510
CREATE STAGE mystage
  URL='azure://myaccount.blob.core.windows.net/load/files/'
  STORAGE_INTEGRATION = my_storage_int
  DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
    NOTIFICATION_INTEGRATION = 'MY_NOTIFICATION_INT'
  );

-- Example 9511
CREATE OR ALTER STAGE my_int_stage
  COMMENT='my_comment'
  ;

-- Example 9512
CREATE OR ALTER STAGE my_int_stage
  DIRECTORY=(ENABLE=true);

-- Example 9513
CREATE OR ALTER STAGE my_ext_stage
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z');

-- Example 9514
CREATE OR ALTER STAGE my_ext_stage
  URL='s3://load/files/'
  CREDENTIALS=(AWS_KEY_ID='1a2b3c' AWS_SECRET_KEY='4x5y6z')
  DIRECTORY=(ENABLE=true);

-- Example 9515
REMOVE { internalStage | externalStage } [ PATTERN = '<regex_pattern>' ]

-- Example 9516
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 9517
externalStage ::=
    @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 9518
rm @%mytable/myobject;

-- Example 9519
rm @%mytable/myobject/;

-- Example 9520
REMOVE @mystage/path1/subpath2;

-- Example 9521
REMOVE @%orders;

-- Example 9522
RM @~ pattern='.*jun.*';

-- Example 9523
SHOW [ TERSE ] DATABASES [ HISTORY ] [ LIKE '<pattern>' ]
                                     [ STARTS WITH '<name_string>' ]
                                     [ LIMIT <rows> [ FROM '<name_string>' ] ]
                                     [ WITH PRIVILEGES <object_privilege> [ , <object_privilege> [ , ... ] ] ]

-- Example 9524
SHOW DATABASES;

-- Example 9525
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+----------+----------+-----------------+-------------------+
| created_on                      | name      | is_default | is_current | origin | owner  | comment | options | retention_time | kind     | budget   | owner_role_type | OBJECT_VISIBILITY |
|---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+----------+----------|-----------------|-------------------|
| Tue, 17 Mar 2015 16:57:04 -0700 | MYTESTDB  | N          | Y          |        | PUBLIC |         |         | 1              | STANDARD | NULL     | ROLE            | NULL              |
| Wed, 25 Feb 2015 17:30:04 -0800 | SALES1    | N          | N          |        | PUBLIC |         |         | 1              | STANDARD | NULL     | ROLE            | NULL              |
| Fri, 13 Feb 2015 19:21:49 -0800 | DEMO1     | N          | N          |        | PUBLIC |         |         | 1              | STANDARD | MYBUDGET | ROLE            | NULL              |
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+----------+----------+-----------------+-------------------+

-- Example 9526
SHOW DATABASES HISTORY;

-- Example 9527
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------+----------+----------+-----------------+-------------------+
| created_on                      | name      | is_default | is_current | origin | owner  | comment | options | retention_time | dropped_on                      | kind     | budget   | owner_role_type | OBJECT_VISIBILITY |
|---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------|----------+----------|-----------------|-------------------|
| Tue, 17 Mar 2015 16:57:04 -0700 | MYTESTDB  | N          | Y          |        | PUBLIC |         |         | 1              | [NULL]                          | STANDARD | NULL     | ROLE            | NULL              |
| Wed, 25 Feb 2015 17:30:04 -0800 | SALES1    | N          | N          |        | PUBLIC |         |         | 1              | [NULL]                          | STANDARD | NULL     | ROLE            | NULL              |
| Fri, 13 Feb 2015 19:21:49 -0800 | DEMO1     | N          | N          |        | PUBLIC |         |         | 1              | [NULL]                          | STANDARD | MYBUDGET | ROLE            | NULL              |
| Wed, 25 Feb 2015 16:16:54 -0800 | MYTESTDB2 | N          | N          |        | PUBLIC |         |         | 1              | Fri, 13 May 2016 17:35:09 -0700 | STANDARD | NULL     | ROLE            | NULL              |
+---------------------------------+-----------+------------+------------+--------+--------+---------+---------+----------------+---------------------------------+----------+----------+-----------------+-------------------+

-- Example 9528
SHOW DATABASES WITH PRIVILEGES USAGE, MODIFY;

-- Example 9529
+-------------------------------+-----------------------------------------------------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-------------------+--------------+-----------------+-------------------+
| created_on                    | name                                                      | is_default | is_current | origin                                                    | owner        | comment | options | retention_time | kind              | budget       | owner_role_type | OBJECT_VISIBILITY |
|-------------------------------+-----------------------------------------------------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-------------------+--------------+-----------------|-------------------|
| 2023-01-27 14:33:11.417 -0800 | BOOKS_DB                                                  | N          | N          |                                                           | DATA_ADMIN   |         |         | 1              | STANDARD          | NULL         | ROLE            | NULL              |
| 2023-09-15 15:22:51.111 -0700 | TEST_DB                                                   | N          | N          |                                                           | ACCOUNTADMIN |         |         | 4              | STANDARD          | TEST_BUDGET  | ROLE            | NULL              |
| 2023-08-18 13:33:01.024 -0700 | SNOWFLAKE                                                 | N          | N          | SNOWFLAKE.ACCOUNT_USAGE                                   |              |         |         | 0              | APPLICATION       | NULL         |                 | NULL              |
+-------------------------------+-----------------------------------------------------------+------------+------------+-----------------------------------------------------------+--------------+---------+---------+----------------+-------------------+--------------+-----------------+-------------------+

-- Example 9530
USE [ DATABASE ] <name>

-- Example 9531
USE DATABASE mydb;

-- Example 9532
USE [ SCHEMA ] [<db_name>.]<name>

-- Example 9533
USE SCHEMA myschema;

-- Example 9534
USE mydb.myschema;

-- Example 9535
USE WAREHOUSE <name>

-- Example 9536
USE WAREHOUSE mywarehouse;

-- Example 9537
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  ..

-- Example 9538
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  PARTITION_TYPE = USER_SPECIFIED
  ..

-- Example 9539
ALTER EXTERNAL TABLE <name> ADD PARTITION ( <part_col_name> = '<string>' [ , <part_col_name> = '<string>' ] ) LOCATION '<path>'

-- Example 9540
SHOW EXTERNAL TABLES LIKE 'my_delta_ext_table';

-- Example 9541
CREATE OR REPLACE EXTERNAL VOLUME delta_migration_ext_vol
STORAGE_LOCATIONS = (
  (
    NAME = storage_location_1
    STORAGE_PROVIDER = 'S3'
    STORAGE_BASE_URL = 's3://my-bucket/'
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789123:role/my-storage-role' )
);

-- Example 9542
CREATE ICEBERG TABLE my_delta_table_1
  BASE_LOCATION = 'delta-ext-table-1'
  EXTERNAL_VOLUME = 'delta_migration_ext_vol'
  CATALOG = 'delta_catalog_integration';

-- Example 9543
DROP EXTERNAL TABLE my_delta_ext_table_1;

-- Example 9544
CREATE or replace PROCEDURE remove_old_files(external_table_name varchar, num_days float)
  RETURNS varchar
  LANGUAGE javascript
  EXECUTE AS CALLER
  AS
  $$
  // 1. Get the relative path of the external table
  // 2. Find all files registered before the specified time period
  // 3. Remove the files


  var resultSet1 = snowflake.execute({ sqlText:
    `call exttable_bucket_relative_path('` + EXTERNAL_TABLE_NAME + `');`
  });
  resultSet1.next();
  var relPath = resultSet1.getColumnValue(1);


  var resultSet2 = snowflake.execute({ sqlText:
    `select file_name
     from table(information_schema.EXTERNAL_TABLE_FILES (
         TABLE_NAME => '` + EXTERNAL_TABLE_NAME +`'))
     where last_modified < dateadd(day, -` + NUM_DAYS + `, current_timestamp());`
  });

  var fileNames = [];
  while (resultSet2.next())
  {
    fileNames.push(resultSet2.getColumnValue(1).substring(relPath.length));
  }

  if (fileNames.length == 0)
  {
    return 'nothing to do';
  }


  var alterCommand = `ALTER EXTERNAL TABLE ` + EXTERNAL_TABLE_NAME + ` REMOVE FILES ('` + fileNames.join(`', '`) + `');`;

  var resultSet3 = snowflake.execute({ sqlText: alterCommand });

  var results = [];
  while (resultSet3.next())
  {
    results.push(resultSet3.getColumnValue(1) + ' -> ' + resultSet3.getColumnValue(2));
  }

  return results.length + ' files: \n' + results.join('\n');

  $$;

  CREATE or replace PROCEDURE exttable_bucket_relative_path(external_table_name varchar)
  RETURNS varchar
  LANGUAGE javascript
  EXECUTE AS CALLER
  AS
  $$
  var resultSet = snowflake.execute({ sqlText:
    `show external tables like '` + EXTERNAL_TABLE_NAME + `';`
  });

  resultSet.next();
  var location = resultSet.getColumnValue(10);

  var relPath = location.split('/').slice(3).join('/');
  return relPath.endsWith("/") ? relPath : relPath + "/";

  $$;

-- Example 9545
-- Remove all files from the exttable external table metadata:
call remove_old_files('exttable', 0);

-- Remove files staged longer than 90 days ago from the exttable external table metadata:
call remove_old_files('exttable', 90);

-- Example 9546
create view myview as select * from mytable;

-- Example 9547
create stage my_ext_stage
  url='s3://load/files/'
  storage_integration = myint;

-- Example 9548
create or replace view v_on_stage_function
as
select *
from T1
where get_presigned_url(@stage1, 'data_0.csv.gz')
is not null;

-- Example 9549
CREATE OR REPLACE MATERIALIZED VIEW sales_view AS SELECT * FROM sales_staging_table;

-- Example 9550
SELECT referencing_object_name, referencing_object_domain, referenced_object_name, referenced_object_domain
FROM snowflake.account_usage.object_dependencies
WHERE referenced_object_name = 'SALES_STAGING_TABLE' and referenced_object_domain = 'EXTERNAL TABLE';

-- Example 9551
+-------------------------+---------------------------+------------------------+--------------------------+
| REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN |
+-------------------------+---------------------------+------------------------+--------------------------+
| SALES_VIEW              | MATERIALIZED VIEW         | SALES_STAGING_TABLE    | EXTERNAL TABLE           |
+-------------------------+---------------------------+------------------------+--------------------------+

-- Example 9552
CREATE TABLE sales_na(product string);
CREATE OR REPLACE VIEW north_america_sales AS SELECT * FROM sales_na;
CREATE VIEW us_sales AS SELECT * FROM north_america_sales;
CREATE VIEW cal_sales AS SELECT * FROM north_america_sales;

-- Example 9553
CREATE TABLE sales_uk (product string);
CREATE VIEW global_sales AS SELECT * FROM sales_uk UNION ALL SELECT * FROM north_america_sales;

-- Example 9554
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

-- Example 9555
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+
| OBJECT_NAME_PATH                              | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN | REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN |
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+
| SALES_NA-->NORTH_AMERICA_SALES                | SALES_NA               | TABLE                    | NORTH_AMERICA_SALES     | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->CAL_SALES    | NORTH_AMERICA_SALES    | VIEW                     | CAL_SALES               | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->US_SALES     | NORTH_AMERICA_SALES    | VIEW                     | US_SALES                | VIEW                      |
| SALES_NA-->NORTH_AMERICA_SALES-->GLOBAL_SALES | NORTH_AMERICA_SALES    | VIEW                     | GLOBAL_SALES            | VIEW                      |
+-----------------------------------------------+------------------------+--------------------------+-------------------------+---------------------------+

-- Example 9556
CREATE TABLE sales_na (product string);
CREATE OR REPLACE VIEW north_america_sales AS SELECT * FROM sales_na;
CREATE TABLE sales_uk (product string);
CREATE VIEW global_sales AS SELECT * FROM sales_uk UNION ALL SELECT * FROM north_america_sales;

-- Example 9557
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

-- Example 9558
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+
| OBJECT_NAME_PATH                              | REFERENCING_OBJECT_NAME | REFERENCING_OBJECT_DOMAIN | REFERENCED_OBJECT_NAME | REFERENCED_OBJECT_DOMAIN |
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+
| SALES_UK<--GLOBAL_SALES                       | GLOBAL_SALES            | VIEW                      | SALES_UK               | TABLE                    |
| NORTH_AMERICA_SALES<--GLOBAL_SALES            | GLOBAL_SALES            | VIEW                      | NORTH_AMERICA_SALES    | VIEW                     |
| SALES_NA<--NORTH_AMERICA_SALES<--GLOBAL_SALES | NORTH_AMERICA_SALES     | VIEW                      | SALES_NA               | TABLE                    |
+-----------------------------------------------+-------------------------+---------------------------+------------------------+--------------------------+

-- Example 9559
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
    WHERE TAG_NAME = 'PRIVACY_CATEGORY'
    ORDER BY OBJECT_DATABASE, OBJECT_SCHEMA, OBJECT_NAME, COLUMN_NAME;

-- Example 9560
SELECT * FROM
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES(
      'my_db.my_schema.hr_data.fname',
      'COLUMN'
    ));

-- Example 9561
SELECT * from
  TABLE(
    MY_DB.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
      'my_db.my_schema.hr_data',
      'table'
    ));

