-- Example 817
+---------------------------------+
| $1                              |
|---------------------------------|
| {                               |
|   "CITY": "Paris",              |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
|---------------------------------|
| {                               |
|   "CITY": "Nice",               |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
|---------------------------------|
| {                               |
|   "CITY": "Marseilles",         |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
+---------------------------------+

-- Example 818
REMOVE @sf_tut_stage/cities.parquet;

-- Example 819
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 820
-- Create a database from the share.
CREATE DATABASE SNOWFLAKE_SAMPLE_DATA FROM SHARE SFC_SAMPLES.SAMPLE_DATA;

-- Grant the PUBLIC role access to the database.
-- Optionally change the role name to restrict access to a subset of users.
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE_SAMPLE_DATA TO ROLE PUBLIC;

-- Example 821
show databases like '%sample%';

+-------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+
| created_on                    | name                  | is_default | is_current | origin                  | owner        | comment | options | retention_time |
|-------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------|
| 2016-07-14 14:30:21.711 -0700 | SNOWFLAKE_SAMPLE_DATA | N          | N          | SFC_SAMPLES.SAMPLE_DATA | ACCOUNTADMIN |         |         | 1              |
+-------------------------------+-----------------------+------------+------------+-------------------------+--------------+---------+---------+----------------+

-- Example 822
select count(*) from snowflake_sample_data.tpch_sf1.lineitem;

+----------+
| COUNT(*) |
|----------|
|  6001215 |
+----------+

use schema snowflake_sample_data.tpch_sf1;

select count(*) from lineitem;

+----------+
| COUNT(*) |
|----------|
|  6001215 |
+----------+

-- Example 823
use schema snowflake_sample_data.tpcds_sf10Tcl;

-- QID=TPC-DS_query57

with
v1 as(
  select i_category, i_brand,
         cc_name,
         d_year, d_moy,
         sum(cs_sales_price) sum_sales,
         avg(sum(cs_sales_price)) over
           (partition by i_category, i_brand, cc_name, d_year) avg_monthly_sales,
         rank() over (partition by i_category, i_brand, cc_name order by d_year, d_moy) rn
  from item, catalog_sales, date_dim, call_center
  where cs_item_sk = i_item_sk and
        cs_sold_date_sk = d_date_sk and
        cc_call_center_sk= cs_call_center_sk and
          (
            d_year = 2001 or
          ( d_year = 2001-1 and d_moy =12) or
          ( d_year = 2001+1 and d_moy =1)
          )
  group by i_category, i_brand,
           cc_name , d_year, d_moy),
v2 as(
  select v1.i_brand
    ,v1.d_year, v1.d_moy
    ,v1.avg_monthly_sales
    ,v1.sum_sales, v1_lag.sum_sales psum, v1_lead.sum_sales nsum
  from v1, v1 v1_lag, v1 v1_lead
  where v1.i_category = v1_lag.i_category and
    v1.i_category = v1_lead.i_category and
    v1.i_brand = v1_lag.i_brand and
    v1.i_brand = v1_lead.i_brand and
    v1.cc_name = v1_lag. cc_name and
    v1.cc_name = v1_lead. cc_name and
    v1.rn = v1_lag.rn + 1 and
    v1.rn = v1_lead.rn - 1)
select  *
from v2
where d_year = 2001 and
  avg_monthly_sales > 0 and
  case when avg_monthly_sales > 0
       then abs(sum_sales - avg_monthly_sales) / avg_monthly_sales
       else null
       end > 0.1
order by sum_sales - avg_monthly_sales, nsum
limit 100;

-- Example 824
use schema snowflake_sample_data.tpch_sf1;   -- or snowflake_sample_data.{tpch_sf10 | tpch_sf100 | tpch_sf1000}

select
       l_returnflag,
       l_linestatus,
       sum(l_quantity) as sum_qty,
       sum(l_extendedprice) as sum_base_price,
       sum(l_extendedprice * (1-l_discount)) as sum_disc_price,
       sum(l_extendedprice * (1-l_discount) * (1+l_tax)) as sum_charge,
       avg(l_quantity) as avg_qty,
       avg(l_extendedprice) as avg_price,
       avg(l_discount) as avg_disc,
       count(*) as count_order
 from
       lineitem
 where
       l_shipdate <= dateadd(day, -90, to_date('1998-12-01'))
 group by
       l_returnflag,
       l_linestatus
 order by
       l_returnflag,
       l_linestatus;

-- Example 825
-- Must do the SHOW first to produce the full result set.
SHOW WAREHOUSES;
-- result_scan() helps to customize a report using the result set from the previous query.
SELECT "name", "state", "size", "max_cluster_count", "started_clusters", "type"
  FROM TABLE(result_scan(-1))
  WHERE "state" IN ('STARTED','SUSPENDED')
  ORDER BY "type" DESC, "name";

-- Example 826
CREATE WAREHOUSE mywh WITH MAX_CLUSTER_COUNT = 2, SCALING_POLICY = 'STANDARD';
ALTER WAREHOUSE mywh SET SCALING_POLICY = 'ECONOMY';

-- Example 827
CREATE ROLE create_wh_role;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE create_wh_role;
GRANT ROLE create_wh_role TO ROLE SYSADMIN;

-- Example 828
from snowflake.core.role import Role, Securable

my_role = Role(name="create_wh_role")
my_role_res = root.roles.create(my_role)

my_role_res.grant_privileges(
  privileges=["CREATE WAREHOUSE"], securable_type="ACCOUNT"
)

root.roles['SYSADMIN'].grant_role(role_type="ROLE", role=Securable(name='create_wh_role'))

-- Example 829
CREATE ROLE manage_wh_role;
GRANT MANAGE WAREHOUSES ON ACCOUNT TO ROLE manage_wh_role;
GRANT ROLE manage_wh_role TO ROLE SYSADMIN;

-- Example 830
from snowflake.core.role import Role, Securable

my_role = Role(name="manage_wh_role")
my_role_res = root.roles.create(my_role)

my_role_res.grant_privileges(
  privileges=["MANAGE WAREHOUSES"], securable_type="ACCOUNT"
)

root.roles['SYSADMIN'].grant_role(role_type="ROLE", role=Securable(name='manage_wh_role'))

-- Example 831
USE ROLE create_wh_role;
CREATE OR REPLACE WAREHOUSE test_wh
    WITH WAREHOUSE_SIZE= XSMALL;

-- Example 832
from snowflake.core import CreateMode
from snowflake.core.warehouse import Warehouse

root.session.use_role("create_wh_role")

my_wh = Warehouse(
  name="test_wh",
  warehouse_size="XSMALL"
)
root.warehouses.create(my_wh, mode=CreateMode.or_replace)

-- Example 833
USE ROLE manage_wh_role;

-- Example 834
root.session.use_role("manage_wh_role")

-- Example 835
ALTER WAREHOUSE test_wh SUSPEND;
ALTER WAREHOUSE test_wh RESUME;

-- Example 836
my_wh_res = root.warehouses["test_wh"]
my_wh_res.suspend()
my_wh_res.resume()

-- Example 837
ALTER WAREHOUSE test_wh SET WAREHOUSE_SIZE = SMALL;

-- Example 838
my_wh = root.warehouses["test_wh"].fetch()
my_wh.warehouse_size = "SMALL"
root.warehouses["test_wh"].create_or_alter(my_wh)

-- Example 839
DESC WAREHOUSE test_wh;

-- Example 840
my_wh = root.warehouses["test_wh"].fetch()
print(my_wh.to_dict())

-- Example 841
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('8cd54bf0-1651-5b1c-ac9c-6a9582ebd20f'));

-- Example 842
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

-- Example 843
SELECT PARSE_JSON(SYSTEM$ESTIMATE_QUERY_ACCELERATION('cf23522b-3b91-cf14-9fe0-988a292a4bfa'));

-- Example 844
{
  "estimatedQueryTimes": {},
  "originalQueryTime": 20.291,
  "queryUUID": "cf23522b-3b91-cf14-9fe0-988a292a4bfa",
  "status": "ineligible",
  "upperLimitScaleFactor": 0
}

-- Example 845
USE ROLE ACCOUNTADMIN;

-- Example 846
SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY eligible_query_acceleration_time DESC;

-- Example 847
SELECT query_id, eligible_query_acceleration_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY eligible_query_acceleration_time DESC;

-- Example 848
SELECT warehouse_name, COUNT(query_id) AS num_eligible_queries
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

-- Example 849
SELECT warehouse_name, SUM(eligible_query_acceleration_time) AS total_eligible_time
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY total_eligible_time DESC;

-- Example 850
SELECT MAX(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP());

-- Example 851
SELECT upper_limit_scale_factor, COUNT(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE warehouse_name = 'MYWH'
  AND start_time > DATEADD('day', -7, CURRENT_TIMESTAMP())
  GROUP BY 1 ORDER BY 1;

-- Example 852
CREATE WAREHOUSE my_wh WITH
  ENABLE_QUERY_ACCELERATION = true;

-- Example 853
SHOW WAREHOUSES LIKE 'my_wh';

+---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------+
| name    | state   | type     | size    | running | queued | is_default | is_current | auto_suspend | auto_resume | available | provisioning | quiescing | other | created_on                    | resumed_on                    | updated_on                    | owner        | comment | enable_query_acceleration | query_acceleration_max_scale_factor | resource_monitor | actives | pendings | failed | suspended | uuid       |
|---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------|
| MY_WH   | SUSPENDED | STANDARD | Medium |       0 |      0 | N          | N          |          600 | true        |           |              |           |       | 2023-01-20 14:31:49.283 -0800 | 2023-01-20 14:31:49.388 -0800 | 2023-01-20 16:34:28.583 -0800 | ACCOUNTADMIN |         | true                      |                                   8 | null             |       0 |        0 |      0 |         4 | 1132659053 |
+---------+---------+----------+---------+---------+--------+------------+------------+--------------+-------------+-----------+--------------+-----------+-------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+---------------------------+-------------------------------------+------------------+---------+----------+--------+-----------+------------+

-- Example 854
ALTER WAREHOUSE my_wh SET
  ENABLE_QUERY_ACCELERATION = true
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = 0;

-- Example 855
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

-- Example 856
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

-- Example 857
SELECT warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE start_time >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1
  ORDER BY 2 DESC;

-- Example 858
SELECT account_name,
       warehouse_name,
       SUM(credits_used) AS total_credits_used
  FROM SNOWFLAKE.ORGANIZATION_USAGE.QUERY_ACCELERATION_HISTORY
  WHERE usage_date >= DATE_TRUNC(month, CURRENT_DATE)
  GROUP BY 1, 2
  ORDER BY 3 DESC;

-- Example 859
SELECT start_time,
       end_time,
       credits_used,
       warehouse_name,
       num_files_scanned,
       num_bytes_scanned
  FROM TABLE(INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
    date_range_start=>DATEADD(H, -12, CURRENT_TIMESTAMP)));

-- Example 860
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

-- Example 861
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

-- Example 862
CREATE OR REPLACE TABLE salespeople (
  sp_id INT NOT NULL UNIQUE,
  name VARCHAR DEFAULT NULL,
  region VARCHAR,
  constraint pk_sp_id PRIMARY KEY (sp_id)
);
CREATE OR REPLACE TABLE salesorders (
  order_id INT NOT NULL UNIQUE,
  quantity INT DEFAULT NULL,
  description VARCHAR,
  sp_id INT NOT NULL UNIQUE,
  constraint pk_order_id PRIMARY KEY (order_id),
  constraint fk_sp_id FOREIGN KEY (sp_id) REFERENCES salespeople(sp_id)
);

-- Example 863
from snowflake.core import CreateMode
from snowflake.core.table import ForeignKey, PrimaryKey, Table, TableColumn, UniqueKey

my_table = Table(
  name="salespeople",
  columns=[
      TableColumn(name="sp_id", datatype="int", nullable=False, constraints=[UniqueKey(name='unk')]),
      TableColumn(name="name", datatype="varchar", default="NULL"),
      TableColumn(name="region", datatype="varchar")
  ],
  constraints=[PrimaryKey(name="pk_sp_id", column_names=["sp_id"])]
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_table, mode=CreateMode.or_replace)

my_table = Table(
  name="salesorders",
  columns=[
      TableColumn(name="order_id", datatype="int", nullable=False, constraints=[UniqueKey(name='unk')]),
      TableColumn(name="quantity", datatype="int", default="NULL"),
      TableColumn(name="description", datatype="varchar"),
      TableColumn(name="sp_id", datatype="int", nullable=False, constraints=[UniqueKey(name='unk')])
  ],
  constraints=[
      ForeignKey(referenced_table_name = "salespeople", referenced_column_names=["sp_id"], name="fk_sp_id", column_names=["sp_id"]),
      PrimaryKey(name="pk_order_id", column_names=["order_id"])
  ]
)
root.databases["<database>"].schemas["<schema>"].tables.create(my_table, mode=CreateMode.or_replace)

-- Example 864
SELECT GET_DDL('TABLE', 'mydb.public.salesorders');

-- Example 865
+-----------------------------------------------------------------------------------------------------+
| GET_DDL('TABLE', 'MYDATABASE.PUBLIC.SALESORDERS')                                                   |
|-----------------------------------------------------------------------------------------------------|
| create or replace TABLE SALESORDERS (                                                               |
|   ORDER_ID NUMBER(38,0) NOT NULL,                                                                   |
|   QUANTITY NUMBER(38,0),                                                                            |
|   DESCRIPTION VARCHAR(16777216),                                                                    |
|   SP_ID NUMBER(38,0) NOT NULL,                                                                      |
|   unique (SP_ID),                                                                                   |
|   constraint PK_ORDER_ID primary key (ORDER_ID),                                                    |
|   constraint FK_SP_ID foreign key (SP_ID) references MYDATABASE.PUBLIC.SALESPEOPLE(SP_ID)           |
| );                                                                                                  |
+-----------------------------------------------------------------------------------------------------+

-- Example 866
SELECT table_name, constraint_type, constraint_name
  FROM mydb.INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE constraint_schema = 'PUBLIC'
  ORDER BY table_name;

-- Example 867
+-------------+-----------------+-----------------------------------------------------+
| TABLE_NAME  | CONSTRAINT_TYPE | CONSTRAINT_NAME                                     |
|-------------+-----------------+-----------------------------------------------------|
| SALESORDERS | UNIQUE          | SYS_CONSTRAINT_fce2257e-c343-4e66-9bea-fc1c041b00a6 |
| SALESORDERS | FOREIGN KEY     | FK_SP_ID                                            |
| SALESORDERS | PRIMARY KEY     | PK_ORDER_ID                                         |
| SALESORDERS | UNIQUE          | SYS_CONSTRAINT_bf90e2b3-fd4a-4764-9576-88fb487fe989 |
| SALESPEOPLE | PRIMARY KEY     | PK_SP_ID                                            |
+-------------+-----------------+-----------------------------------------------------+

-- Example 868
CREATE TRANSIENT TABLE my_new_table LIKE my_old_table COPY GRANTS;

-- Example 869
from snowflake.core.table import Table

my_table = Table(
  name="my_new_table",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, like_table="my_old_table", copy_grants=True)

-- Example 870
INSERT INTO my_new_table SELECT * FROM my_old_table;

-- Example 871
CREATE TRANSIENT TABLE my_transient_table AS SELECT * FROM mytable;

-- Example 872
from snowflake.core.table import Table

my_table = Table(
  name="my_transient_table",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, as_select="SELECT * FROM mytable")

-- Example 873
CREATE TRANSIENT TABLE foo CLONE bar COPY GRANTS;

-- Example 874
from snowflake.core.table import Table

my_table = Table(
  name="foo",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, clone_table="bar", copy_grants=True)

-- Example 875
CREATE TABLE hospital_table (patient_id INTEGER,
                             patient_name VARCHAR, 
                             billing_address VARCHAR,
                             diagnosis VARCHAR, 
                             treatment VARCHAR,
                             cost NUMBER(10,2));
INSERT INTO hospital_table 
        (patient_ID, patient_name, billing_address, diagnosis, treatment, cost) 
    VALUES
        (1, 'Mark Knopfler', '1982 Telegraph Road', 'Industrial Disease', 
            'a week of peace and quiet', 2000.00),
        (2, 'Guido van Rossum', '37 Florida St.', 'python bite', 'anti-venom', 
            70000.00)
        ;

-- Example 876
CREATE VIEW doctor_view AS
    SELECT patient_ID, patient_name, diagnosis, treatment FROM hospital_table;

CREATE VIEW accountant_view AS
    SELECT patient_ID, patient_name, billing_address, cost FROM hospital_table;

-- Example 877
SELECT DISTINCT diagnosis FROM doctor_view;
+--------------------+
| DIAGNOSIS          |
|--------------------|
| Industrial Disease |
| python bite        |
+--------------------+

-- Example 878
SELECT treatment, cost 
    FROM doctor_view AS dv, accountant_view AS av
    WHERE av.patient_ID = dv.patient_ID;
+---------------------------+----------+
| TREATMENT                 |     COST |
|---------------------------+----------|
| a week of peace and quiet |  2000.00 |
| anti-venom                | 70000.00 |
+---------------------------+----------+

-- Example 879
CREATE VIEW v1 AS SELECT ... FROM my_database.my_schema.my_table;

CREATE VIEW v1 AS SELECT ... FROM my_schema.my_table;

CREATE VIEW v1 AS SELECT ... FROM my_table;

-- Example 880
CREATE VIEW employee_hierarchy (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
   WITH RECURSIVE employee_hierarchy_cte (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_cte.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_cte.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_cte
       WHERE employee_hierarchy_cte.employee_ID = employees.manager_ID
   )
   SELECT * 
      FROM employee_hierarchy_cte
);

-- Example 881
CREATE RECURSIVE VIEW employee_hierarchy_02 (title, employee_ID, manager_ID, "MGR_EMP_ID (SHOULD BE SAME)", "MGR TITLE") AS (
      -- Start at the top of the hierarchy ...
      SELECT title, employee_ID, manager_ID, NULL AS "MGR_EMP_ID (SHOULD BE SAME)", 'President' AS "MGR TITLE"
        FROM employees
        WHERE title = 'President'
      UNION ALL
      -- ... and work our way down one level at a time.
      SELECT employees.title, 
             employees.employee_ID, 
             employees.manager_ID, 
             employee_hierarchy_02.employee_id AS "MGR_EMP_ID (SHOULD BE SAME)", 
             employee_hierarchy_02.title AS "MGR TITLE"
        FROM employees INNER JOIN employee_hierarchy_02
        WHERE employee_hierarchy_02.employee_ID = employees.manager_ID
);

-- Example 882
CREATE TABLE employees (id INTEGER, title VARCHAR);
INSERT INTO employees (id, title) VALUES
    (1, 'doctor'),
    (2, 'nurse'),
    (3, 'janitor')
    ;

CREATE VIEW doctors as SELECT * FROM employees WHERE title = 'doctor';
CREATE VIEW nurses as SELECT * FROM employees WHERE title = 'nurse';
CREATE VIEW medical_staff AS
    SELECT * FROM doctors
    UNION
    SELECT * FROM nurses
    ;

-- Example 883
SELECT * 
    FROM medical_staff
    ORDER BY id;
+----+--------+
| ID | TITLE  |
|----+--------|
|  1 | doctor |
|  2 | nurse  |
+----+--------+

-- Example 884
DELETE FROM hospital_table 
    WHERE cost > (SELECT AVG(cost) FROM accountant_view);

