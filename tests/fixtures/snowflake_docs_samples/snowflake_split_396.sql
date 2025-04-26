-- Example 26507
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION google_apis_access_integration
  ALLOWED_NETWORK_RULES = (google_apis_network_rule)
  ALLOWED_AUTHENTICATION_SECRETS = (oauth_token)
  ENABLED = true;

-- Example 26508
CREATE OR REPLACE FUNCTION google_translate_python(sentence STRING, language STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
HANDLER = 'get_translation'
EXTERNAL_ACCESS_INTEGRATIONS = (google_apis_access_integration)
PACKAGES = ('snowflake-snowpark-python','requests')
SECRETS = ('cred' = oauth_token )
AS
$$
import _snowflake
import requests
import json
session = requests.Session()
def get_translation(sentence, language):
  token = _snowflake.get_oauth_access_token('cred')
  url = "https://translation.googleapis.com/language/translate/v2"
  data = {'q': sentence,'target': language}
  response = session.post(url, json = data, headers = {"Authorization": "Bearer " + token})
  return response.json()['data']['translations'][0]['translatedText']
$$;

-- Example 26509
CREATE FUNCTION area_of_circle(radius FLOAT)
  RETURNS FLOAT
  AS
  $$
    pi() * radius * radius
  $$
  ;

-- Example 26510
USE ROLE dataadmin;

DESC TABLE users;

-- Example 26511
+-----------+--------------+--------+-------+---------+-------------+------------+--------+------------+---------+
| name      | type         | kind   | null? | default | primary key | unique key | check  | expression | comment |
|-----------+--------------+--------+-------+---------+-------------+------------+--------+------------+---------|
| USER_ID   | NUMBER(38,0) | COLUMN | Y     | [NULL]  | N           | N          | [NULL] | [NULL]     | [NULL]  |
| USER_NAME | VARCHAR(100) | COLUMN | Y     | [NULL]  | N           | N          | [NULL] | [NULL]     | [NULL]  |
  ...
  ...
  ...
+-----------+--------------+--------+-------+---------+-------------+------------+--------+------------+---------+

-- Example 26512
CREATE FUNCTION total_user_count() RETURNS NUMBER AS 'select count(*) from users';

GRANT USAGE ON FUNCTION total_user_count() TO ROLE analyst;

USE ROLE analyst;

-- This will fail because the role named "analyst" does not have the
-- privileges required in order to access the table named "users".
SELECT * FROM users;

-- Example 26513
FAILURE: SQL compilation error:
Object 'USERS' does not exist.

-- Example 26514
-- However, this will succeed.
SELECT total_user_count();

-- Example 26515
+--------------------+
| TOTAL_USER_COUNT() |
|--------------------+
| 123                |
+--------------------+

-- Example 26516
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "GOVERNANCE.FUNCTIONS.RETURN_SUM",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  },
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "GOVERNANCE.TABLES.T1"
  }
]

-- Example 26517
[
  {
    "objectDomain": "FUNCTION",
    "objectName": "GOVERNANCE.FUNCTIONS.RETURN_SUM",
    "objectId": "2",
    "argumentSignature": "(NUM1 NUMBER, NUM2 NUMBER)",
    "dataType": "NUMBER(38,0)"
  },
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "CONTENT"
      }
    ],
    "objectDomain": "Table",
    "objectId": 66564,
    "objectName": "GOVERNANCE.TABLES.T1"
  }
]

-- Example 26518
[
  {
    "objectDomain": "STRING",
    "objectId":  NUMBER,
    "objectName": "STRING",
    "columns": [
      {
        "columnId": "NUMBER",
        "columnName": "STRING",
        "baseSources": [
          {
            "columnName": STRING,
            "objectDomain": "STRING",
            "objectId": NUMBER,
            "objectName": "STRING"
          }
        ],
        "directSources": [
          {
            "columnName": STRING,
            "objectDomain": "STRING",
            "objectId": NUMBER,
            "objectName": "STRING"
          }
        ]
      }
    ]
  },
  ...
]

-- Example 26519
{
  "objectDomain": STRING,
  "objectName": STRING,
  "objectId": NUMBER,
  "operationType": STRING,
  "properties": ARRAY
}

-- Example 26520
[
  {
    "columns": [
      {
        "columnId": 68610,
        "columnName": "SSN",
        "policies": [
          {
              "policyName": "governance.policies.ssn_mask",
              "policyId": 68811,
              "policyKind": "MASKING_POLICY"
          }
        ]
      }
    ],
    "objectDomain": "VIEW",
    "objectId": 66564,
    "objectName": "GOVERNANCE.VIEWS.V1",
    "policies": [
      {
        "policyName": "governance.policies.rap1",
        "policyId": 68813,
        "policyKind": "ROW_ACCESS_POLICY"
      }
    ]
  }
]

-- Example 26521
columns: {
  "email": {
    objectId: {
      "value": 1
    },
    "subOperationType": "ADD"
  }
}

-- Example 26522
UPDATE mydb.s1.t1 SET col_1 = col_1 + 1;

-- Example 26523
UPDATE mydb.s1.t1 FROM mydb.s2.t2 SET t1.col1 = t2.col1;

-- Example 26524
insert into a(c1)
select c2
from b
where c3 > 1;

-- Example 26525
insert into A(col1) select f(col2) from B;

-- Example 26526
CREATE OR REPLACE

ALTER ... { SET | UNSET }

ALTER ... ADD ROW ACCESS POLICY

ALTER ... DROP ROW ACCESS POLICY

ALTER ... DROP ALL ROW ACCESS POLICIES

DROP | UNDROP

-- Example 26527
SELECT account_name, name, condition, condition_query_id, action, action_query_id, state
  FROM snowflake.organization_usage.alert_history
  LIMIT 10;

-- Example 26528
SELECT account_name, name, condition, condition_query_id, action, action_query_id, state
FROM snowflake.organization_usage.alert_history
WHERE COMPLETED_TIME > DATEADD(hours, -1, CURRENT_TIMESTAMP());

-- Example 26529
SELECT account_name, name, database_name, schema_name
  FROM snowflake.organization_usage.classes;

-- Example 26530
SELECT ACCOUNT_NAME, NAME, DATABASE_NAME, SCHEMA_NAME, CLASS_NAME
  FROM snowflake.organization_usage.class_instances
  WHERE CLASS_NAME = 'ANOMALY_DETECTION';

-- Example 26531
SELECT a.TABLE_NAME,
       b.NAME AS instance_name,
       b.CLASS_NAME
  FROM SNOWFLAKE.ORGANIZATION_USAGE.TABLES a
  JOIN SNOWFLAKE.ORGANIZATION_USAGE.CLASS_INSTANCES b
  ON a.INSTANCE_ID = b.ID
  WHERE b.DELETED IS NULL;

-- Example 26532
SELECT *
  FROM snowflake.organization_usage.columns
  WHERE
    table_catalog = 'mydb' AND
    table_name = 'myTable' AND
    deleted IS NULL;

-- Example 26533
SELECT account_name, root_task_name, state
FROM snowflake.organization_usage.complete_task_graphs
  LIMIT 10;

-- Example 26534
SELECT account_name, file_name, error_count, status, last_load_time
  FROM snowflake.organization_usage.copy-history
  ORDER BY last_load_time desc
  LIMIT 10;

-- Example 26535
WHERE last_load_time > 'Sun, 01 Apr 2016 16:00:00 -0800'

-- Example 26536
SELECT account_name, file_name, last_load_time
FROM snowflake.organization_usage.load_history
  ORDER BY last_load_time DESC
  LIMIT 10;

-- Example 26537
SELECT account_name, query_id, object_name, transaction_id, blocker_queries
  FROM snowflake.organization_usage.alert_history.lock_wait_history
  WHERE requested_at >= DATEADD('hours', -24, CURRENT_TIMESTAMP());

-- Example 26538
select a.PIPE_CATALOG as PIPE_CATALOG,
       a.PIPE_SCHEMA as PIPE_SCHEMA,
       a.PIPE_NAME as PIPE_NAME,
       b.CREDITS_USED as CREDITS_USED
from SNOWFLAKE.ORGANIZATION_USAGE.PIPES a join SNOWFLAKE.ORGANIZATION_USAGE.PIPE_USAGE_HISTORY b
on a.pipe_id = b.pipe_id
where b.START_TIME > date_trunc(month, current_date);

-- Example 26539
SELECT account_name, warehouse_name, COUNT(query_id) AS num_eligible_queries
  FROM SNOWFLAKE.ORGANIZATION_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time >= '2024-06-01 00:00'::TIMESTAMP
  AND end_time <= '2024-06-07 00:00'::TIMESTAMP
  GROUP BY warehouse_name
  ORDER BY num_eligible_queries DESC;

-- Example 26540
select account_name, policy_name, policy_signature, created
from row_access_policies
order by created
;

-- Example 26541
SELECT account_name, table_schema, SUM(bytes)
    FROM SNOWFLAKE.ORGANIZATION_USAGE.TABLES
    WHERE deleted IS NULL
    GROUP BY table_schema;

-- Example 26542
select * from snowflake.organization_usage.tags
order by tag_name;

-- Example 26543
select account_name, tag_name, tag_value, domain, object_id
from snowflake.organization_usage.tag_references
order by tag_name, domain, object_id;

-- Example 26544
select account_name, tag_name, tag_value, domain, object_id
from snowflake.organization_usage.tag_references
where object_deleted is null
order by tag_name, domain, object_id;

-- Example 26545
SELECT account_name, query_text, completed_time
FROM snowflake.organization_usage.task_history
ORDER BY completed_time DESC
LIMIT 10;

-- Example 26546
SELECT account_name, query_text, completed_time
FROM snowflake.organization_usage.task_history
WHERE completed_time > DATEADD(hours, -1, CURRENT_TIMESTAMP());

-- Example 26547
SELECT *
FROM snowflake.organization_usage.task_versions
WHERE ROOT_TASK_ID = 'afb36ccc-. . .-b746f3bf555d' AND GRAPH_VERSION = 3;

-- Example 26548
SELECT
task_history.* rename state AS task_run_state,
task_versions.state AS task_state,
task_versions.graph_version_created_on,
task_versions.warehouse_name,
task_versions.comment,
task_versions.schedule,
task_versions.predecessors,
task_versions.allow_overlapping_execution,
task_versions.error_integration
FROM snowflake.organization_usage.task_history
JOIN snowflake.organization_usage.task_versions using (root_task_id, graph_version)
WHERE task_history.ROOT_TASK_ID = 'afb36ccc-. . .-b746f3bf555d'

-- Example 26549
SELECT account_name, timestamp, warehouse_name, cluster_number,
       event_name, event_reason, event_state,
       size, cluster_count
  FROM SNOWFLAKE.ORGANIZATION_USAGE.WAREHOUSE_EVENTS_HISTORY
  WHERE warehouse_name = 'MY_WH'
  AND timestamp > DATEADD('day', -7, CURRENT_TIMESTAMP())
  ORDER BY timestamp DESC;

-- Example 26550
ALTER WAREHOUSE my_wh SET
  COMMENT = 'Updated comment for warehouse';

-- Example 26551
ALTER WAREHOUSE my_wh SET
  WAREHOUSE_SIZE = 'SMALL';

-- Example 26552
ALTER TABLE t1 SUSPEND RECLUSTER;

SHOW TABLES LIKE 't1';

+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
|           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |  owner   | retention_time | automatic_clustering |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| Thu, 12 Apr 2018 13:29:01 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         | LINEAR(C1) | 0    | 0     | SYSADMIN | 1              | OFF                  |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 26553
ALTER TABLE t1 RESUME RECLUSTER;

SHOW TABLES LIKE 't1';

+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
|           created_on            | name | database_name | schema_name | kind  | comment | cluster_by | rows | bytes |  owner   | retention_time | automatic_clustering |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+
| Thu, 12 Apr 2018 13:29:01 -0700 | T1   | TESTDB        | MY_SCHEMA   | TABLE |         | LINEAR(C1) | 0    | 0     | SYSADMIN | 1              | ON                   |
+---------------------------------+------+---------------+-------------+-------+---------+------------+------+-------+----------+----------------+----------------------+

-- Example 26554
SELECT TO_DATE(start_time) AS date,
  database_name,
  schema_name,
  table_name,
  SUM(credits_used) AS credits_used
FROM snowflake.account_usage.automatic_clustering_history
WHERE start_time >= DATEADD(month,-1,CURRENT_TIMESTAMP())
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

-- Example 26555
WITH credits_by_day AS (
  SELECT TO_DATE(start_time) AS date,
    SUM(credits_used) AS credits_used
  FROM snowflake.account_usage.automatic_clustering_history
  WHERE start_time >= DATEADD(year,-1,CURRENT_TIMESTAMP())
  GROUP BY 1
  ORDER BY 2 DESC
)

SELECT DATE_TRUNC('week',date),
      AVG(credits_used) AS avg_daily_credits
FROM credits_by_day
GROUP BY 1
ORDER BY 1;

-- Example 26556
SELECT f.*
FROM fact_sales f
LEFT OUTER JOIN dim_products p
ON f.product_id = p.product_id;

-- Example 26557
SELECT p1.product_id, p2.product_name
FROM dim_products p1, dim_products p2
WHERE p1.product_id = p2.product_id;

-- Example 26558
SELECT p.product_id, f.units_sold
FROM   fact_sales f, dim_products p
WHERE  f.product_id = p.product_id;

-- Example 26559
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

-- Example 26560
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

-- Example 26561
SELECT GET_DDL('TABLE', 'mydb.public.salesorders');

-- Example 26562
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

-- Example 26563
SELECT table_name, constraint_type, constraint_name
  FROM mydb.INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE constraint_schema = 'PUBLIC'
  ORDER BY table_name;

-- Example 26564
+-------------+-----------------+-----------------------------------------------------+
| TABLE_NAME  | CONSTRAINT_TYPE | CONSTRAINT_NAME                                     |
|-------------+-----------------+-----------------------------------------------------|
| SALESORDERS | UNIQUE          | SYS_CONSTRAINT_fce2257e-c343-4e66-9bea-fc1c041b00a6 |
| SALESORDERS | FOREIGN KEY     | FK_SP_ID                                            |
| SALESORDERS | PRIMARY KEY     | PK_ORDER_ID                                         |
| SALESORDERS | UNIQUE          | SYS_CONSTRAINT_bf90e2b3-fd4a-4764-9576-88fb487fe989 |
| SALESPEOPLE | PRIMARY KEY     | PK_SP_ID                                            |
+-------------+-----------------+-----------------------------------------------------+

-- Example 26565
CREATE TRANSIENT TABLE my_new_table LIKE my_old_table COPY GRANTS;

-- Example 26566
from snowflake.core.table import Table

my_table = Table(
  name="my_new_table",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, like_table="my_old_table", copy_grants=True)

-- Example 26567
INSERT INTO my_new_table SELECT * FROM my_old_table;

-- Example 26568
CREATE TRANSIENT TABLE my_transient_table AS SELECT * FROM mytable;

-- Example 26569
from snowflake.core.table import Table

my_table = Table(
  name="my_transient_table",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, as_select="SELECT * FROM mytable")

-- Example 26570
CREATE TRANSIENT TABLE foo CLONE bar COPY GRANTS;

-- Example 26571
from snowflake.core.table import Table

my_table = Table(
  name="foo",
  kind="TRANSIENT"
)
tables = root.databases["<database>"].schemas["<schema>"].tables
tables.create(my_table, clone_table="bar", copy_grants=True)

-- Example 26572
CREATE STAGE my_s3compat_stage
  URL = 's3compat://my_bucket/files/'
  ENDPOINT = 'mystorage.com'
  CREDENTIALS = (AWS_KEY_ID = '1a2b3c...' AWS_SECRET_KEY = '4x5y6z...')

-- Example 26573
COPY INTO t1
  FROM @my_s3compat_stage/load/;

