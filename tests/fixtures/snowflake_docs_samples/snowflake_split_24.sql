-- Example 1565
SELECT SYSTEM$ENABLE_PREVIEW_ACCESS();

-- Example 1566
+---------------------------------------------------------------+
| SELECT SYSTEM$ENABLE_PREVIEW_ACCESS();                        |
+---------------------------------------------------------------+
| Preview access has been successfully enabled for this account |
+---------------------------------------------------------------+

-- Example 1567
SELECT SYSTEM$DISABLE_PREVIEW_ACCESS();

-- Example 1568
+----------------------------------------------------------------+
| SYSTEM$DISABLE_PREVIEW_ACCESS()                                |
+----------------------------------------------------------------+
| Preview access has been successfully disabled for this account |
+----------------------------------------------------------------+

-- Example 1569
from snowflake.snowpark import Session
from snowflake.core import Root

session = Session.builder.config("connection_name", "default").create()
root = Root(session)

-- Example 1570
conda create -n <env_name> python==3.10
conda activate <env_name>

-- Example 1571
python3 -m venv '.venv'
source '.venv/bin/activate'

-- Example 1572
pip install snowflake -U

-- Example 1573
[default]
account = "<YOUR ACCOUNT NAME>"
user = "<YOUR ACCOUNT USER>"
password = "<YOUR ACCOUNT USER PASSWORD>"
# optional
# warehouse = "<YOUR COMPUTE WH>"
# optional
# database = "<YOUR DATABASE>"
# optional
# schema = "<YOUR SCHEMA>"

-- Example 1574
from datetime import timedelta

from snowflake.snowpark import Session
from snowflake.snowpark.functions import col
from snowflake.core import Root, CreateMode
from snowflake.core.database import Database
from snowflake.core.schema import Schema
from snowflake.core.stage import Stage
from snowflake.core.table import Table, TableColumn, PrimaryKey
from snowflake.core.task import StoredProcedureCall, Task
from snowflake.core.task.dagv1 import DAGOperation, DAG, DAGTask
from snowflake.core.warehouse import Warehouse

-- Example 1575
session = Session.builder.config("connection_name", "default").create()

-- Example 1576
root = Root(session)

-- Example 1577
SHOW AUTHENTICATION POLICIES; alter AUTHENTICATION POLICY <your authentication policy> set AUTHENTICATION_METHODS = ('KEYPAIR', 'PASSWORD', 'OAUTH');

-- Example 1578
USE ROLE ACCOUNTADMIN;

CREATE ROLE test_role;

CREATE DATABASE IF NOT EXISTS tutorial_db;
GRANT OWNERSHIP ON DATABASE tutorial_db TO ROLE test_role COPY CURRENT GRANTS;

CREATE OR REPLACE WAREHOUSE tutorial_warehouse WITH
  WAREHOUSE_SIZE='X-SMALL';
GRANT USAGE ON WAREHOUSE tutorial_warehouse TO ROLE test_role;

GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE test_role;

CREATE COMPUTE POOL tutorial_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;
GRANT USAGE, MONITOR ON COMPUTE POOL tutorial_compute_pool TO ROLE test_role;

GRANT ROLE test_role TO USER <user_name>

-- Example 1579
USE ROLE test_role;
USE DATABASE tutorial_db;
USE WAREHOUSE tutorial_warehouse;

CREATE SCHEMA IF NOT EXISTS data_schema;
CREATE IMAGE REPOSITORY IF NOT EXISTS tutorial_repository;
CREATE STAGE IF NOT EXISTS tutorial_stage
  DIRECTORY = ( ENABLE = true );

-- Example 1580
SHOW COMPUTE POOLS; --or DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 1581
SHOW WAREHOUSES;

-- Example 1582
SHOW IMAGE REPOSITORIES;

-- Example 1583
SHOW STAGES;

-- Example 1584
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 1585
USE ROLE ACCOUNTADMIN;
CREATE ROLE service_function_user_role;
GRANT ROLE service_function_user_role TO USER <user-name>;
GRANT USAGE ON WAREHOUSE tutorial_warehouse TO ROLE service_function_user_role;

-- Example 1586
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 1587
CREATE SERVICE echo_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
    spec:
      containers:
      - name: echo
        image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
        env:
          SERVER_PORT: 8000
          CHARACTER_NAME: Bob
        readinessProbe:
          port: 8000
          path: /healthcheck
      endpoints:
      - name: echoendpoint
        port: 8000
        public: true
      - name: echoendpoint2
        port: 8002
        public: true
    serviceRoles:
    - name: echoendpoint_role
      endpoints:
      - echoendpoint
      $$;

-- Example 1588
SHOW SERVICES;
SHOW SERVICE CONTAINERS IN SERVICE echo_service;
DESCRIBE SERVICE echo_service;

-- Example 1589
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;

GRANT USAGE ON DATABASE tutorial_db TO ROLE service_function_user_role;
GRANT USAGE ON SCHEMA data_schema TO ROLE service_function_user_role;
GRANT SERVICE ROLE echo_service!echoendpoint_Role TO ROLE service_function_user_role;

-- Example 1590
USE ROLE service_function_user_role;
CREATE OR REPLACE FUNCTION my_echo_udf_try1 (InputText VARCHAR)
  RETURNS varchar
  SERVICE=echo_service
  ENDPOINT=echoendpoint
  AS '/echo';

-- Example 1591
CREATE OR REPLACE FUNCTION my_echo_udf_try2 (InputText varchar)
  RETURNS varchar
  SERVICE=echo_service
  ENDPOINT=echoendpoint2
  AS '/echo';

-- Example 1592
SELECT my_echo_udf_try1('Hello');

-- Example 1593
SHOW IMAGES IN IMAGE REPOSITORY tutorial_db.data_schema.tutorial_repository;

-- Example 1594
CREATE SERVICE my_service
 IN COMPUTE POOL tutorial_compute_pool
 FROM SPECIFICATION $$
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:latest
    volumeMounts:
    - name: block-vol1
      mountPath: /opt/block/path
    readinessProbe:
      port: 8080
      path: /healthcheck
  endpoints:
  - name: echoendpoint
    port: 8080
    public: true
  volumes:
  - name: block-vol1
    source: block
    size: 10Gi
$$;

-- Example 1595
DESC SERVICE echo_service;

-- Example 1596
SHOW SERVICE CONTAINERS IN SERVICE echo_service;

-- Example 1597
CREATE SNAPSHOT my_snapshot
  FROM SERVICE my_service
  VOLUME "block-vol1"
  INSTANCE 0
  COMMENT='new snapshot';

-- Example 1598
SHOW SNAPSHOTS;

-- Example 1599
DESC SNAPSHOT my_snapshot;

-- Example 1600
ALTER SNAPSHOT my_snapshot SET comment='updated comment';

-- Example 1601
CREATE SERVICE new_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
spec:
  containers:
  - name: echo
    image: /tutorial_db/data_schema/tutorial_repository/my_echo_service_image:tutorial
    volumeMounts:
    - name: fromsnapshotvol
      mountPath: /opt/block/path
    readinessProbe:
      port: 8080
      path: /healthcheck
  endpoints:
  - name: echoendpoint
    port: 8080
    public: true
  volumes:
  - name: fromsnapshotvol
    source: block
    size: 50Gi
    blockConfig:
      initialContents:
        fromSnapshot: MY_SNAPSHOT
$$
min_instances=3
max_instances=3;

-- Example 1602
ALTER SERVICE my_service SUSPEND;

-- Example 1603
ALTER SERVICE my_service RESTORE     -- this will auto RESUME the service.
  VOLUME "block-vol1"
  INSTANCES 0
  FROM SNAPSHOT my_snapshot;

-- Example 1604
DESC SERVICE echo_service;

-- Example 1605
DROP SNAPSHOT my_snapshot;

-- Example 1606
DROP SERVICE my_service;
DROP SERVICE new_service;

-- Example 1607
SELECT CURRENT_USER(), CURRENT_ROLE();

-- Example 1608
SHOW IMAGE REPOSITORIES;

-- Example 1609
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 1610
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 1611
docker build --rm --platform linux/amd64 -t <repository_url>/<image_name> .

-- Example 1612
docker build --rm --platform linux/amd64 -t myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/query_service:latest .

-- Example 1613
docker login <registry_hostname> -u <username>

-- Example 1614
docker push <repository_url>/<image_name>

-- Example 1615
docker push myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/query_service:latest

-- Example 1616
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 1617
DESCRIBE COMPUTE POOL tutorial_compute_pool;

-- Example 1618
CREATE SERVICE query_service
  IN COMPUTE POOL tutorial_compute_pool
  FROM SPECIFICATION $$
    spec:
      containers:
      - name: main
        image: /tutorial_db/data_schema/tutorial_repository/query_service:latest
        env:
          SERVER_PORT: 8000
        readinessProbe:
          port: 8000
          path: /healthcheck
      endpoints:
      - name: execute
        port: 8000
        public: true
    capabilities:
      securityContext:
        executeAsCaller: true
    serviceRoles:
    - name: ui_usage
      endpoints:
      - execute
$$;

-- Example 1619
SHOW SERVICES;

-- Example 1620
SHOW SERVICE CONTAINERS IN SERVICE query_service;

-- Example 1621
DESCRIBE SERVICE query_service;

-- Example 1622
USE ROLE test_role;
USE DATABASE tutorial_db;
USE SCHEMA data_schema;
USE WAREHOUSE tutorial_warehouse;

-- Example 1623
SHOW ENDPOINTS IN SERVICE query_service;

-- Example 1624
p6bye-myorg-myacct.snowflakecomputing.app

-- Example 1625
SELECT CURRENT_USER(), CURRENT_ROLE()DONE;

-- Example 1626
['TESTUSER, PUBLIC']

-- Example 1627
['QUERY_SERVICE, TEST_ROLE']

-- Example 1628
SELECT * FROM ingress_user_db.ingress_user_schema.ingress_user_table;

-- Example 1629
USE ROLE accountadmin;

CREATE ROLE ingress_user_role;
GRANT ROLE ingress_user_role TO USER <your_user_name>;

GRANT USAGE ON WAREHOUSE tutorial_warehouse TO ROLE ingress_user_role;

CREATE DATABASE IF NOT EXISTS ingress_user_db;
GRANT OWNERSHIP ON DATABASE ingress_user_db TO ROLE ingress_user_role COPY CURRENT GRANTS;

-- Example 1630
USE ROLE ingress_user_role;

CREATE SCHEMA IF NOT EXISTS ingress_user_db.ingress_user_schema;
USE WAREHOUSE tutorial_warehouse;
CREATE TABLE ingress_user_db.ingress_user_schema.ingress_user_table (col string) AS (
    SELECT 'this table is only accessible to the ingress_user_role'
);

-- Example 1631
USE ROLE accountadmin;

GRANT CALLER USAGE ON DATABASE ingress_user_db TO ROLE test_role;
GRANT INHERITED CALLER USAGE ON ALL SCHEMAS IN DATABASE ingress_user_db TO ROLE test_role;
GRANT INHERITED CALLER SELECT ON ALL TABLES IN DATABASE ingress_user_db TO ROLE test_role;
GRANT CALLER USAGE ON WAREHOUSE tutorial_warehouse TO ROLE test_role;
SHOW CALLER GRANTS TO ROLE test_role;

-- Example 1632
ALTER USER SET DEFAULT_SECONDARY_ROLES = ('ALL');
ALTER USER SET DEFAULT_WAREHOUSE = TUTORIAL_WAREHOUSE;

