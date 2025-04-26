-- Example 23827
CREATE OR REPLACE VIEW input_view AS (
    SELECT
        metric,
        dim_country as country,
        dim_vertical as vertical,
        ds >= '2021-01-01' AS label
    FROM input_table
);

-- Example 23828
CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS my_insights_model()

CALL my_insights_model!GET_DRIVERS(
  INPUT_DATA => TABLE(input_view),
  LABEL_COLNAME => 'label',
  METRIC_COLNAME => 'metric'
)

-- Example 23829
+---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------+
| CONTRIBUTOR                                                         | METRIC_CONTROL | METRIC_TEST | CONTRIBUTION | RELATIVE_CONTRIBUTION |   GROWTH_RATE |
|---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------|
| ["Overall"]                                                         |         128445 |      158456 |        30011 |         1             |  0.2336486434 |
| ["COUNTRY = usa"]                                                   |         116238 |      154574 |        38336 |         1.277398287   |  0.3298060875 |
| ["COUNTRY = usa","VERTICAL = finance"]                              |          64281 |       87423 |        23142 |         0.771117257   |  0.3600130676 |
| ["COUNTRY = usa","VERTICAL = auto"]                                 |          48930 |       66131 |        17201 |         0.5731565093  |  0.3515430206 |
| ["COUNTRY = usa","VERTICAL = tech"]                                 |           1543 |         503 |        -1040 |        -0.03465396021 | -0.6740116656 |
| ["COUNTRY = canada","VERTICAL = finance"]                           |           1538 |         482 |        -1056 |        -0.03518709806 | -0.6866059818 |
| ["COUNTRY = canada","VERTICAL = fashion"]                           |           1519 |         446 |        -1073 |        -0.03575355703 | -0.7063857801 |
| ["COUNTRY = france","VERTICAL = auto"]                              |           1534 |         460 |        -1074 |        -0.03578687814 | -0.7001303781 |
| ["COUNTRY = usa","not VERTICAL = auto","not VERTICAL = finance"]    |           3027 |        1020 |        -2007 |        -0.06687547899 | -0.6630327056 |
| ["COUNTRY = france","not VERTICAL = fashion","not VERTICAL = tech"] |           3100 |         962 |        -2138 |        -0.07124054513 | -0.6896774194 |
| ["COUNTRY = france","not VERTICAL = fashion"]                       |           4687 |        1456 |        -3231 |        -0.1076605245  | -0.689353531  |
| ["COUNTRY = france"]                                                |           6202 |        1947 |        -4255 |        -0.1417813468  | -0.68606901   |
| ["not COUNTRY = usa"]                                               |          12207 |        3882 |        -8325 |        -0.2773982873  | -0.6819857459 |
+---------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+---------------+

-- Example 23830
CREATE OR REPLACE TABLE vertical_input_table(
  region VARCHAR, industry VARCHAR, num_employee NUMBER, credits FLOAT);

INSERT INTO vertical_input_table
  SELECT
    'USA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(1000, 3000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 450));

INSERT INTO vertical_input_table
  SELECT
    'EMEA' as region,
    ['technology', 'finance', 'healthcare', 'consumer'][MOD(ABS(RANDOM()), 4)] as industry,
    UNIFORM(100, 10000, RANDOM()) as num_employee,
    UNIFORM(100, 5000, RANDOM()) AS credits,
  FROM TABLE(GENERATOR(ROWCOUNT => 350));

-- Example 23831
CREATE OR REPLACE VIEW vertical_input_view AS (
    SELECT
        credits,
        industry,
        num_employee,
        region = 'EMEA' AS label
    FROM vertical_input_table
);

-- Example 23832
CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS my_insights_model();

CALL my_insights_model!get_drivers(
  INPUT_DATA => TABLE(vertical_input_view),
  LABEL_COLNAME => 'label',
  METRIC_COLNAME => 'credits'
);

-- Example 23833
+-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------+|
| CONTRIBUTOR                                                                                           | METRIC_CONTROL | METRIC_TEST | CONTRIBUTION | RELATIVE_CONTRIBUTION |      GROWTH_RATE |
|-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------|
| ["Overall"]                                                                                           |         896672 |      895326 |        -1346 |           1           |  -0.001501106313 |
| ["not INDUSTRY = consumer","NUM_EMPLOYEE <= 6248.0","NUM_EMPLOYEE > 4235.0"]                          |         141138 |       70337 |       -70801 |          52.601040119 |  -0.5016437813   |
| ["NUM_EMPLOYEE <= 6248.0","NUM_EMPLOYEE > 4235.0"]                                                    |         188770 |      127320 |       -61450 |          45.653789004 |  -0.3255284208   |
| ["not INDUSTRY = technology","NUM_EMPLOYEE <= 8670.0","NUM_EMPLOYEE > 7582.5"]                        |         100533 |       42925 |       -57608 |          42.799405646 |  -0.5730257726   |
| ["not INDUSTRY = consumer","NUM_EMPLOYEE <= 5562.5","NUM_EMPLOYEE > 4235.0"]                          |         103851 |       47052 |       -56799 |          42.198365527 |  -0.54692781     |
+-------------------------------------------------------------------------------------------------------+----------------+-------------+--------------+-----------------------+------------------+

-- Example 23834
CREATE PRIVACY POLICY  <name>
  AS ( ) RETURNS PRIVACY_BUDGET -> <body>

-- Example 23835
CREATE PRIVACY POLICY my_priv_policy
  AS ( ) RETURNS PRIVACY_BUDGET ->
  PRIVACY_BUDGET(BUDGET_NAME=> 'analysts');

-- Example 23836
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
    END;

-- Example 23837
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      WHEN CURRENT_ACCOUNT() = 'YE74187'
        THEN PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'external.' || CURRENT_ACCOUNT())
    END;

-- Example 23838
ALTER PRIVACY POLICY my_priv_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME => 'external_analysts');

-- Example 23839
ALTER { TABLE | [ MATERIALIZED ] VIEW } <name>
  ADD PRIVACY POLICY <policy_name>
  { NO ENTITY KEY | ENTITY KEY ( <column_name> ) }

-- Example 23840
ALTER TABLE t1 ADD PRIVACY POLICY my_priv_policy ENTITY KEY (email);

-- Example 23841
ALTER TABLE finance.accounting.customers
  DROP PRIVACY POLICY priv_policy_1,
  ADD PRIVACY POLICY priv_policy_2 ENTITY KEY (email);

-- Example 23842
ALTER { TABLE | [ MATERIALIZED ] VIEW } <name> DROP PRIVACY POLICY <policy_name>

-- Example 23843
ALTER TABLE finance.accounting.customers
  DROP PRIVACY POLICY my_priv_policy;

-- Example 23844
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.PRIVACY_POLICIES
  ORDER BY POLICY_NAME;

-- Example 23845
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.privpolicy'));

-- Example 23846
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 23847
CREATE [ OR REPLACE ] PRIVACY POLICY [ IF NOT EXISTS ] <name>
  AS () RETURNS PRIVACY_BUDGET -> <body>
  [ COMMENT = '<string_literal>' ]

-- Example 23848
PRIVACY_BUDGET(
  BUDGET_NAME=> '<string>'
  [, BUDGET_LIMIT=> <decimal> ]
  [, MAX_BUDGET_PER_AGGREGATE=> <decimal> ]
  [, BUDGET_WINDOW=> <string> ]
)

-- Example 23849
CREATE PRIVACY POLICY my_priv_policy
  AS ( ) RETURNS PRIVACY_BUDGET ->
  PRIVACY_BUDGET(BUDGET_NAME=> 'analysts');

-- Example 23850
CREATE PRIVACY POLICY my_priv_policy
  AS () RETURNS PRIVACY_BUDGET ->
    CASE
      WHEN CURRENT_USER() = 'ADMIN'
        THEN NO_PRIVACY_POLICY()
      ELSE PRIVACY_BUDGET(BUDGET_NAME => 'analysts')
    END;

-- Example 23851
CREATE OR REPLACE FUNCTION udf_concatenate_strings(
    first_arg VARCHAR,
    second_arg VARCHAR,
    third_arg VARCHAR)
  RETURNS VARCHAR
  LANGUAGE SQL
  AS
  $$
    SELECT first_arg || second_arg || third_arg
  $$;

-- Example 23852
SELECT udf_concatenate_strings(
  first_arg => 'one',
  second_arg => 'two',
  third_arg => 'three');

-- Example 23853
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   FIRST_ARG => 'ONE',    |
|   SECOND_ARG => 'TWO',   |
|   THIRD_ARG => 'THREE')  |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 23854
SELECT udf_concatenate_strings(
  third_arg => 'three',
  first_arg => 'one',
  second_arg => 'two');

-- Example 23855
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   THIRD_ARG => 'THREE',  |
|   FIRST_ARG => 'ONE',    |
|   SECOND_ARG => 'TWO')   |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 23856
SELECT udf_concatenate_strings(
  'one',
  'two',
  'three');

-- Example 23857
+--------------------------+
| UDF_CONCATENATE_STRINGS( |
|   'ONE',                 |
|   'TWO',                 |
|   'THREE')               |
|--------------------------|
| onetwothree              |
+--------------------------+

-- Example 23858
CREATE OR REPLACE FUNCTION build_string_udf(
    word VARCHAR,
    prefix VARCHAR DEFAULT 'pre-',
    suffix VARCHAR DEFAULT '-post'
  )
  RETURNS VARCHAR
  AS
  $$
    SELECT prefix || word || suffix
  $$
  ;

-- Example 23859
SELECT build_string_udf('hello');

-- Example 23860
+---------------------------+
| BUILD_STRING_UDF('HELLO') |
|---------------------------|
| pre-hello-post            |
+---------------------------+

-- Example 23861
SELECT build_string_udf('hello', 'before-');

-- Example 23862
+--------------------------------------+
| BUILD_STRING_UDF('HELLO', 'BEFORE-') |
|--------------------------------------|
| before-hello-post                    |
+--------------------------------------+

-- Example 23863
SELECT build_string_udf(word => 'hello', suffix => '-after');

-- Example 23864
+-------------------------------------------------------+
| BUILD_STRING_UDF(WORD => 'HELLO', SUFFIX => '-AFTER') |
|-------------------------------------------------------|
| pre-hello-after                                       |
+-------------------------------------------------------+

-- Example 23865
SELECT ...
  FROM TABLE ( udtf_name (udtf_arguments) )

-- Example 23866
SELECT ...
  FROM TABLE(my_java_udtf('2021-01-16'::DATE));

-- Example 23867
create table file_names (file_name varchar);
insert into file_names (file_name) values ('sample.txt'),
                                          ('sample_2.txt');

select f.file_name, w.word
   from file_names as f, table(split_file_into_words(f.file_name)) as w;

-- Example 23868
+-------------------+------------+
| FILE_NAME         | WORD       |
+-------------------+------------+
| sample_data.txt   | some       |
| sample_data.txt   | words      |
| sample_data_2.txt | additional |
| sample_data_2.txt | words      |
+-------------------+------------+

-- Example 23869
create function split_file_into_words(inputFileName string)
    ...
    imports = ('@inline_jars/sample.txt', '@inline_jars/sample_2.txt')
    ...

-- Example 23870
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol))

-- Example 23871
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY 1))

-- Example 23872
SELECT *
     FROM stocks_table AS st,
          TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol ORDER BY st.transaction_date))

-- Example 23873
SELECT *
    FROM stocks_table AS st,
         TABLE(my_udtf(st.symbol, st.transaction_date, st.price) OVER (PARTITION BY st.symbol ORDER BY st.transaction_date))
    ORDER BY st.symbol, st.transaction_date, st.transaction_time;

-- Example 23874
SELECT * FROM udtf_table, TABLE(my_func(col1) OVER (PARTITION BY udtf_table.col2 * 2));   -- NO!

-- Example 23875
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('myfg'));

-- Example 23876
SELECT PHASE_NAME, START_TIME, END_TIME, TOTAL_BYTES, OBJECT_COUNT
  FROM TABLE(information_schema.replication_group_refresh_history('myfg'))
  WHERE START_TIME >= CURRENT_DATE() - INTERVAL '7 days';

-- Example 23877
SELECT REPLICATION_GROUP_NAME, PHASE_NAME, START_TIME, END_TIME, TOTAL_BYTES, OBJECT_COUNT
  FROM snowflake.account_usage.replication_group_refresh_history
  WHERE START_TIME >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 23878
SELECT start_time, end_time, replication_group_name, credits_used, bytes_transferred
  FROM TABLE(information_schema.replication_group_usage_history(date_range_start=>DATEADD('day', -7, CURRENT_DATE())));

-- Example 23879
SELECT start_time, 
  end_time, 
  replication_group_name, 
  credits_used, 
  bytes_transferred
FROM snowflake.account_usage.replication_group_usage_history
WHERE start_time >= DATE_TRUNC('month', CURRENT_DATE());

-- Example 23880
SELECT SUM(value:totalBytesToReplicate) as sum_database_bytes
  FROM snowflake.account_usage.replication_group_refresh_history rh,
    LATERAL FLATTEN(input => rh.total_bytes:databases)
  WHERE rh.replication_group_name = 'MYRG' AND
        rh.start_time >= CURRENT_DATE() - INTERVAL '30 days';

-- Example 23881
+--------------------+
| SUM_DATABASE_BYTES |
|--------------------|
|              22016 |
+--------------------+

-- Example 23882
SELECT SUM(credits_used) AS credits_used, SUM(bytes_transferred) AS bytes_transferred
  FROM snowflake.account_usage.replication_group_usage_history
  WHERE replication_group_name = 'MYRG' AND
        start_time >= CURRENT_DATE() - INTERVAL '30 days';

-- Example 23883
+--------------+-------------------+
| CREDITS_USED | BYTES_TRANSFERRED |
|--------------+-------------------|
|  1.357923604 |             22013 |
+--------------+-------------------+

-- Example 23884
SELECT SUM(value:totalBytesToReplicate)
  FROM TABLE(information_schema.replication_group_refresh_history('myrg')) AS rh,
  LATERAL FLATTEN(input => total_bytes:databases)
  WHERE rh.phase_name = 'COMPLETED' AND
        rh.start_time >= CURRENT_DATE() - INTERVAL '14 days';

-- Example 23885
SELECT SUM(credits_used), SUM(bytes_transferred)
  FROM TABLE(information_schema.replication_group_usage_history(
    date_range_start => DATEADD('day', -14, CURRENT_DATE()),
    replication_group_name => 'myrg'));

-- Example 23886
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  REFRESH_MODE = auto
  INITIALIZE = on_create
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 23887
CREATE DYNAMIC ICEBERG TABLE product (product_id NUMBER(10,0), product_name STRING, order_time TIMESTAMP_NTZ)
  TARGET_LAG = '20 minutes'
  WAREHOUSE = my_warehouse
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'SNOWFLAKE'
  BASE_LOCATION = 'my_iceberg_table'
  AS
    SELECT product_id, product_name, order_time FROM staging_table;

-- Example 23888
GRANT <privilege> ON FUTURE ICEBERG TABLES IN SCHEMA my_schema TO ROLE my_role;

-- Example 23889
GRANT <privilege> ON FUTURE DYNAMIC TABLES IN SCHEMA my_schema TO ROLE my_role;

-- Example 23890
use role accountadmin;
create role if not exists okta_provisioner;
grant create user on account to role okta_provisioner;
grant create role on account to role okta_provisioner;
grant role okta_provisioner to role accountadmin;
create or replace security integration okta_provisioning
    type = scim
    scim_client = 'okta'
    run_as_role = 'OKTA_PROVISIONER';
select system$generate_scim_access_token('OKTA_PROVISIONING');

-- Example 23891
use role accountadmin;

-- Example 23892
create role if not exists okta_provisioner;
grant create user on account to role okta_provisioner;
grant create role on account to role okta_provisioner;

-- Example 23893
grant role okta_provisioner to role accountadmin;
create or replace security integration okta_provisioning
    type = scim
    scim_client = 'okta'
    run_as_role = 'OKTA_PROVISIONER';

