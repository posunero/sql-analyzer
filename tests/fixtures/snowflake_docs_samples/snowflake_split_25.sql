-- Example 1633
SHOW ENDPOINTS IN SERVICE tutorial_db.data_schema.query_service;

-- Example 1634
p6bye-myorg-myacct.snowflakecomputing.app

-- Example 1635
SELECT * FROM ingress_user_db.ingress_user_schema.ingress_user_table;

-- Example 1636
['this table is only accessible to ingress_user_role']

-- Example 1637
Encountered an error when executing query:... SQL compilation error: Database 'INGRESS_USER_DB' does not exist or not authorized.

-- Example 1638
from flask import Flask
from flask import request
from flask import render_template
import logging
import os
import sys

from snowflake.snowpark import Session
from snowflake.snowpark.exceptions import *

# Environment variables below will be automatically populated by Snowflake.
SNOWFLAKE_ACCOUNT = os.getenv("SNOWFLAKE_ACCOUNT")
SNOWFLAKE_HOST = os.getenv("SNOWFLAKE_HOST")
SNOWFLAKE_DATABASE = os.getenv("SNOWFLAKE_DATABASE")
SNOWFLAKE_SCHEMA = os.getenv("SNOWFLAKE_SCHEMA")

# Custom environment variables
SNOWFLAKE_USER = os.getenv("SNOWFLAKE_USER")
SNOWFLAKE_PASSWORD = os.getenv("SNOWFLAKE_PASSWORD")
SNOWFLAKE_ROLE = os.getenv("SNOWFLAKE_ROLE")
SNOWFLAKE_WAREHOUSE = os.getenv("SNOWFLAKE_WAREHOUSE")

SERVICE_HOST = os.getenv("SERVER_HOST", "0.0.0.0")
SERVER_PORT = os.getenv("SERVER_PORT", 8080)


def get_logger(logger_name):
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.DEBUG)
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.DEBUG)
    handler.setFormatter(
        logging.Formatter("%(name)s [%(asctime)s] [%(levelname)s] %(message)s")
    )
    logger.addHandler(handler)
    return logger


def get_login_token():
    """
    Read the login token supplied automatically by Snowflake. These tokens
    are short lived and should always be read right before creating any new connection.
    """
    with open("/snowflake/session/token", "r") as f:
        return f.read()


def get_connection_params(ingress_user_token=None):
    """
    Construct Snowflake connection params from environment variables.
    """
    if os.path.exists("/snowflake/session/token"):
        if ingress_user_token:
            logger.info("Creating a session on behalf of user.")
            token = get_login_token() + "." + ingress_user_token
        else:
            logger.info("Creating a session as service user.")
            token = get_login_token()

        return {
            "account": SNOWFLAKE_ACCOUNT,
            "host": SNOWFLAKE_HOST,
            "authenticator": "oauth",
            "token": token,
            "warehouse": SNOWFLAKE_WAREHOUSE,
            "database": SNOWFLAKE_DATABASE,
            "schema": SNOWFLAKE_SCHEMA,
        }
    else:
        return {
            "account": SNOWFLAKE_ACCOUNT,
            "host": SNOWFLAKE_HOST,
            "user": SNOWFLAKE_USER,
            "password": SNOWFLAKE_PASSWORD,
            "role": SNOWFLAKE_ROLE,
            "warehouse": SNOWFLAKE_WAREHOUSE,
            "database": SNOWFLAKE_DATABASE,
            "schema": SNOWFLAKE_SCHEMA,
        }


logger = get_logger("query-service")
app = Flask(__name__)


@app.get("/healthcheck")
def readiness_probe():
    return "I'm ready!"


@app.route("/ui", methods=["GET", "POST"])
def ui():
    """
    Main handler for providing a web UI.
    """
    if request.method == "POST":
        # get ingress user token
        ingress_user = request.headers.get("Sf-Context-Current-User")
        ingress_user_token = request.headers.get("Sf-Context-Current-User-Token")

        if ingress_user:
            logger.info(f"Received a request from user {ingress_user}")

        # getting input in HTML form
        query = request.form.get("query")
        if query:
            logger.info(f"Received a request for query: {query}.")
            query_result_ingress_user = (
                run_query(query, ingress_user_token)
                if ingress_user_token
                else "Token is missing. Can't execute as ingress user."
            )
            query_result_service_user = run_query(query)
            return render_template(
                "basic_ui.html",
                query_input=query,
                query_result_ingress_user=query_result_ingress_user,
                query_result_service_user=query_result_service_user,
            )
    return render_template("basic_ui.html")


@app.route("/query", methods=["GET"])
def query():
    """
    Main handler for providing programmatic access.
    """
    # get ingress user token
    query = request.args.get("query")
    logger.info(f"Received query request: {query}.")
    if query:
        ingress_user = request.headers.get("Sf-Context-Current-User")
        ingress_user_token = request.headers.get("Sf-Context-Current-User-Token")

        if ingress_user:
            logger.info(f"Received a request from user {ingress_user}")

        res = run_query(query, ingress_user_token)
        return str(res)
    return "DONE"


def run_query(query, ingress_user_token=None):
    # start a Snowflake session as the ingress user
    try:
        with Session.builder.configs(
            get_connection_params(ingress_user_token)
        ).create() as session:
            logger.info(
                f"Snowflake connection established (id={session.session_id}). Now executing query: {query}."
            )
            try:
                res = session.sql(query).collect()
                logger.info(f"Query execution done: {query}.")
                return (
                    "[Empty Result]"
                    if len(res) == 0
                    else [", ".join(row) for row in res]
                )
            except Exception as e:
                return "Encountered an error when executing query: " + str(e)
    except Exception as e:
        return "Encountered an error when connecting to Snowflake: " + str(e)

if __name__ == '__main__':
  app.run(host=SERVICE_HOST, port=SERVER_PORT)

-- Example 1639
@app.route("/ui", methods=["GET", "POST"])
def ui():

-- Example 1640
token = get_login_token() + "." + ingress_user_token

-- Example 1641
token = get_login_token()

-- Example 1642
@app.get("/healthcheck")
def readiness_probe():

-- Example 1643
ARG BASE_IMAGE=python:3.10-slim-buster
FROM $BASE_IMAGE
COPY main.py ./
COPY templates/ ./templates/
RUN pip install --upgrade pip && pip install flask snowflake-snowpark-python
CMD ["python", "main.py"]

-- Example 1644
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Welcome to the query service!</title>
  </head>
  <body>
    <h1>Welcome to the query service!</h1>
    <form action="{{ url_for("ui") }}" method="post">
      <label for="query">query:<label><br>
      <input type="text" id="query" name="query" size="50"><br>
    </form>
    <h2>Query:</h2>
    {{ query_input }}
    <h2>Result (executed on behalf of ingress user):</h2>
    {{ query_result_ingress_user }}
    <h2>Result (executed as service user):</h2>
    {{ query_result_service_user }}
  </body>
</html>

-- Example 1645
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

-- Example 1646
@app.get("/healthcheck")
def readiness_probe():

-- Example 1647
USE ROLE ACCOUNTADMIN;
CREATE ROLE dp_tutorial_analyst;

-- You can find your own user name by running "SELECT CURRENT_USER();"
GRANT ROLE dp_tutorial_analyst TO USER <user_name>;

-- Example 1648
CREATE OR REPLACE WAREHOUSE dp_tutorial_wh;
GRANT USAGE ON WAREHOUSE dp_tutorial_wh TO ROLE dp_tutorial_analyst;

-- Example 1649
-- Create the table
CREATE OR REPLACE DATABASE dp_db;
CREATE OR REPLACE SCHEMA dp_db.dp_schema;
USE SCHEMA dp_db.dp_schema;
CREATE OR REPLACE TABLE dp_tutorial_diabetes_survey (
  patient_id TEXT,
  is_smoker BOOLEAN,
  has_difficulty_walking BOOLEAN,
  gender TEXT,
  age INT,
  has_diabetes BOOLEAN,
  income_code INT);

-- Populate the table
INSERT INTO dp_db.dp_schema.dp_tutorial_diabetes_survey
VALUES
('ID-23493', TRUE, FALSE, 'male', 39, TRUE, 2),
('ID-00923', FALSE, FALSE, 'female', 82, TRUE, 5),
('ID-24020', FALSE, FALSE, 'male', 69, FALSE, 8),
('ID-92848', TRUE, TRUE, 'other', 75, FALSE, 3),
('ID-62937', FALSE, FALSE, 'male', 46, TRUE, 5);

-- Example 1650
-- Define a privacy policy. Use default budget, budget window, max budget per aggregate.
CREATE OR REPLACE DATABASE policy_db;
CREATE OR REPLACE SCHEMA policy_db.diff_priv_policies;
CREATE OR REPLACE PRIVACY POLICY policy_db.diff_priv_policies.patients_policy AS () RETURNS privacy_budget ->
  CASE
    WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN no_privacy_policy()
    WHEN CURRENT_ROLE() IN ('DP_TUTORIAL_ANALYST')
      THEN privacy_budget(budget_name => 'clinical_analysts')
    ELSE privacy_budget(budget_name => 'default')
END;

-- Example 1651
-- Assign the privacy policy to the table.
ALTER TABLE dp_db.dp_schema.dp_tutorial_diabetes_survey
ADD PRIVACY POLICY policy_db.diff_priv_policies.patients_policy ENTITY KEY (patient_id);

-- Example 1652
-- Define privacy domains.
ALTER TABLE dp_db.dp_schema.dp_tutorial_diabetes_survey ALTER (
COLUMN gender SET PRIVACY DOMAIN IN ('female', 'male', 'other'),
COLUMN age SET PRIVACY DOMAIN BETWEEN (0, 90),
COLUMN income_code SET PRIVACY DOMAIN BETWEEN (1, 8)
);

-- Example 1653
GRANT USAGE ON DATABASE dp_db TO ROLE dp_tutorial_analyst;
GRANT USAGE ON SCHEMA dp_schema TO ROLE dp_tutorial_analyst;
GRANT SELECT
  ON TABLE dp_db.dp_schema.dp_tutorial_diabetes_survey
  TO ROLE dp_tutorial_analyst;

-- Example 1654
USE ROLE ACCOUNTADMIN;
SELECT * FROM dp_db.dp_schema.dp_tutorial_diabetes_survey;

-- Example 1655
USE ROLE dp_tutorial_analyst;
SELECT * FROM dp_db.dp_schema.dp_tutorial_diabetes_survey;

-- Example 1656
-- Run a basic query without DP.
USE ROLE ACCOUNTADMIN;
SELECT COUNT(DISTINCT patient_id)
  FROM dp_db.dp_schema.dp_tutorial_diabetes_survey
  WHERE income_code = 5;

-- Example 1657
USE ROLE dp_tutorial_analyst;
SELECT COUNT(DISTINCT patient_id)
  FROM dp_db.dp_schema.dp_tutorial_diabetes_survey
  WHERE income_code = 5;

-- Example 1658
-- Retrieve noise interval for the previous query.
USE ROLE dp_tutorial_analyst;
SELECT COUNT(DISTINCT patient_id) as c,
  DP_INTERVAL_LOW(c) as LOW,
  DP_INTERVAL_HIGH(c) as HIGH
  FROM dp_db.dp_schema.dp_tutorial_diabetes_survey
  WHERE income_code = 5;

-- Example 1659
USE ROLE <role_name>;
SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES(dp_db.dp_schema.dp_tutorial_diabetes_survey));

-- Example 1660
USE ROLE ACCOUNTADMIN;
DROP ROLE dp_tutorial_analyst;
DROP WAREHOUSE dp_tutorial_wh;
ALTER TABLE dp_tutorial_diabetes_survey
  DROP PRIVACY POLICY policy_db.diff_priv_policies.patients_policy;
DROP DATABASE dp_db;
DROP DATABASE policies_db;

-- Example 1661
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE ROLE hybrid_quickstart_role;
SET my_user = CURRENT_USER();
GRANT ROLE hybrid_quickstart_role TO USER IDENTIFIER($my_user);

CREATE OR REPLACE WAREHOUSE hybrid_quickstart_wh WAREHOUSE_SIZE = XSMALL, AUTO_SUSPEND = 300, AUTO_RESUME = TRUE;
GRANT OWNERSHIP ON WAREHOUSE hybrid_quickstart_wh TO ROLE hybrid_quickstart_role;
CREATE OR REPLACE DATABASE hybrid_quickstart_db;
GRANT OWNERSHIP ON DATABASE hybrid_quickstart_db TO ROLE hybrid_quickstart_role;

USE ROLE hybrid_quickstart_role;
CREATE OR REPLACE SCHEMA data;

USE WAREHOUSE hybrid_quickstart_wh;

-- Example 1662
CREATE OR REPLACE FILE FORMAT csv_format TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1 NULL_IF = ('NULL', 'null') EMPTY_FIELD_AS_NULL = true;
CREATE OR REPLACE STAGE frostbyte_tasty_bytes_stage URL = 's3://sfquickstarts/hybrid_table_guide' FILE_FORMAT = csv_format;

-- Example 1663
LIST @frostbyte_tasty_bytes_stage;

-- Example 1664
SET CURRENT_TIMESTAMP = CURRENT_TIMESTAMP();

CREATE OR REPLACE HYBRID TABLE truck (
  truck_id NUMBER(38,0) NOT NULL,
  menu_type_id NUMBER(38,0),
  primary_city VARCHAR(16777216),
  region VARCHAR(16777216),
  iso_region VARCHAR(16777216),
  country VARCHAR(16777216),
  iso_country_code VARCHAR(16777216),
  franchise_flag NUMBER(38,0),
  year NUMBER(38,0),
  make VARCHAR(16777216),
  model VARCHAR(16777216),
  ev_flag NUMBER(38,0),
  franchise_id NUMBER(38,0),
  truck_opening_date DATE,
  truck_email VARCHAR NOT NULL UNIQUE,
  record_start_time TIMESTAMP,
  PRIMARY KEY (truck_id)
  )
  AS
  SELECT
      t.$1 AS truck_id,
      t.$2 AS menu_type_id,
      t.$3 AS primary_city,
      t.$4 AS region,
      t.$5 AS iso_region,
      t.$6 AS country,
      t.$7 AS iso_country_code,
      t.$8 AS franchise_flag,
      t.$9 AS year,
      t.$10 AS make,
      t.$11 AS model,
      t.$12 AS ev_flag,
      t.$13 AS franchise_id,
      t.$14 AS truck_opening_date,
      CONCAT(truck_id, '_truck@email.com') truck_email,
      $CURRENT_TIMESTAMP AS record_start_time
    FROM @FROSTBYTE_TASTY_BYTES_STAGE (PATTERN=>'.*TRUCK.csv') t;

CREATE OR REPLACE TABLE truck_history (
  truck_id NUMBER(38,0) NOT NULL,
  menu_type_id NUMBER(38,0),
  primary_city VARCHAR(16777216),
  region VARCHAR(16777216),
  iso_region VARCHAR(16777216),
  country VARCHAR(16777216),
  iso_country_code VARCHAR(16777216),
  franchise_flag NUMBER(38,0),
  year NUMBER(38,0),
  make VARCHAR(16777216),
  model VARCHAR(16777216),
  ev_flag NUMBER(38,0),
  franchise_id NUMBER(38,0),
  truck_opening_date DATE,
  truck_email VARCHAR NOT NULL UNIQUE,
  record_start_time TIMESTAMP,
  record_end_time TIMESTAMP,
  PRIMARY KEY (truck_id)
  )
  AS
  SELECT
      t.$1 AS truck_id,
      t.$2 AS menu_type_id,
      t.$3 AS primary_city,
      t.$4 AS region,
      t.$5 AS iso_region,
      t.$6 AS country,
      t.$7 AS iso_country_code,
      t.$8 AS franchise_flag,
      t.$9 AS year,
      t.$10 AS make,
      t.$11 AS model,
      t.$12 AS ev_flag,
      t.$13 AS franchise_id,
      t.$14 AS truck_opening_date,
      CONCAT(truck_id, '_truck@email.com') truck_email,
      $CURRENT_TIMESTAMP AS record_start_time,
      NULL AS record_end_time
   FROM @frostbyte_tasty_bytes_stage (PATTERN=>'.*TRUCK.csv') t;

-- Example 1665
CREATE OR REPLACE HYBRID TABLE order_header (
  order_id NUMBER(38,0) NOT NULL,
  truck_id NUMBER(38,0),
  location_id NUMBER(19,0),
  customer_id NUMBER(38,0),
  discount_id FLOAT,
  shift_id NUMBER(38,0),
  shift_start_time TIME(9),
  shift_end_time TIME(9),
  order_channel VARCHAR(16777216),
  order_ts TIMESTAMP_NTZ(9),
  served_ts VARCHAR(16777216),
  order_currency VARCHAR(3),
  order_amount NUMBER(38,4),
  order_tax_amount VARCHAR(16777216),
  order_discount_amount VARCHAR(16777216),
  order_total NUMBER(38,4),
  order_status VARCHAR(16777216) DEFAULT 'INQUEUE',
  PRIMARY KEY (order_id),
  FOREIGN KEY (truck_id) REFERENCES TRUCK(truck_id),
  INDEX IDX01_ORDER_TS(order_ts)
);

-- Example 1666
INSERT INTO order_header (
  order_id,
  truck_id,
  location_id,
  customer_id,
  discount_id,
  shift_id,
  shift_start_time,
  shift_end_time,
  order_channel,
  order_ts,
  served_ts,
  order_currency,
  order_amount,
  order_tax_amount,
  order_discount_amount,
  order_total,
  order_status)
  SELECT
      t.$1 AS order_id,
      t.$2 AS truck_id,
      t.$3 AS location_id,
      t.$4 AS customer_id,
      t.$5 AS discount_id,
      t.$6 AS shift_id,
      t.$7 AS shift_start_time,
      t.$8 AS shift_end_time,
      t.$9 AS order_channel,
      t.$10 AS order_ts,
      t.$11 AS served_ts,
      t.$12 AS order_currency,
      t.$13 AS order_amount,
      t.$14 AS order_tax_amount,
      t.$15 AS order_discount_amount,
      t.$16 AS order_total,
      '' as order_status
    FROM @frostbyte_tasty_bytes_stage (PATTERN=>'.*ORDER_HEADER.csv') t;

-- Example 1667
SHOW TABLES LIKE '%truck%';

-- Example 1668
SHOW HYBRID TABLES LIKE '%order_header%';

-- Example 1669
DESCRIBE TABLE truck;

-- Example 1670
DESCRIBE TABLE order_header;

-- Example 1671
SHOW HYBRID TABLES;

-- Example 1672
SHOW INDEXES;

-- Example 1673
SELECT * FROM truck LIMIT 10;
SELECT * FROM truck_history LIMIT 10;
SELECT * FROM order_header LIMIT 10;

-- Example 1674
SET truck_email = (SELECT truck_email FROM truck LIMIT 1);
SET max_truck_id = (SELECT MAX(truck_id) FROM truck);
SET new_truck_id = $max_truck_id+1;
INSERT INTO truck VALUES
  ($new_truck_id,2,'Stockholm','Stockholm län','Stockholm','Sweden','SE',1,2001,'Freightliner','MT45 Utilimaster',0,276,'2020-10-01',$truck_email,CURRENT_TIMESTAMP());

-- Example 1675
Duplicate key value violates unique constraint SYS_INDEX_TRUCK_UNIQUE_TRUCK_EMAIL

-- Example 1676
SET new_unique_email = CONCAT($new_truck_id, '_truck@email.com');
INSERT INTO truck VALUES ($new_truck_id,2,'Stockholm','Stockholm län','Stockholm','Sweden','SE',1,2001,'Freightliner','MT45 Utilimaster',0,276,'2020-10-01',$new_unique_email,CURRENT_TIMESTAMP());

-- Example 1677
SELECT GET_DDL('table', 'order_header');

-- Example 1678
SET max_order_id = (SELECT MAX(order_id) FROM order_header);
SET new_order_id = ($max_order_id +1);
SET no_such_truck_id = -1;
INSERT INTO order_header VALUES
  ($new_order_id,$no_such_truck_id,6090,0,0,0,'16:00:00','23:00:00','','2022-02-18 21:38:46.000','','USD',17.0000,'','',17.0000,'');

-- Example 1679
Foreign key constraint SYS_INDEX_ORDER_HEADER_FOREIGN_KEY_TRUCK_ID_TRUCK_TRUCK_ID was violated.

-- Example 1680
INSERT INTO order_header VALUES
  ($new_order_id,$new_truck_id,6090,0,0,0,'16:00:00','23:00:00','','2022-02-18 21:38:46.000','','USD',17.0000,'','',17.0000,'');

-- Example 1681
TRUNCATE TABLE truck;

-- Example 1682
91458 (0A000): Hybrid table 'TRUCK' cannot be truncated as it is involved in active foreign key constraints.

-- Example 1683
DELETE FROM truck WHERE truck_id = $new_truck_id;

-- Example 1684
Foreign keys that reference key values still exist.

-- Example 1685
DELETE FROM order_header WHERE order_id = $new_order_id;
DELETE FROM truck WHERE truck_id = $new_truck_id;

-- Example 1686
USE ROLE hybrid_quickstart_role;
USE WAREHOUSE hybrid_quickstart_wh;
USE DATABASE hybrid_quickstart_db;
USE SCHEMA data;

SET max_order_id = (SELECT MAX(order_id) FROM order_header);
SELECT $max_order_id;

-- Example 1687
BEGIN;
UPDATE order_header
  SET order_status = 'COMPLETED'
  WHERE order_id = $max_order_id;

-- Example 1688
WHERE order_id = $max_order_id

-- Example 1689
SHOW TRANSACTIONS;

-- Example 1690
USE ROLE hybrid_quickstart_role;
USE WAREHOUSE hybrid_quickstart_wh;
USE DATABASE hybrid_quickstart_db;
USE SCHEMA data;

-- Example 1691
SET min_order_id = (SELECT MIN(order_id) FROM order_header);
SELECT $min_order_id;

-- Example 1692
UPDATE order_header
  SET order_status = 'COMPLETED'
  WHERE order_id = $min_order_id;

-- Example 1693
COMMIT;

-- Example 1694
SELECT * FROM order_header WHERE order_status = 'COMPLETED';

-- Example 1695
BEGIN;
SET CURRENT_TIMESTAMP = CURRENT_TIMESTAMP();
UPDATE truck SET year = '2024', record_start_time=$CURRENT_TIMESTAMP WHERE truck_id = 1;
UPDATE truck_history SET record_end_time=$CURRENT_TIMESTAMP WHERE truck_id = 1 AND record_end_time IS NULL;
INSERT INTO truck_history SELECT *, NULL AS record_end_time FROM truck WHERE truck_id = 1;
COMMIT;

-- Example 1696
SELECT * FROM truck_history WHERE truck_id = 1;

-- Example 1697
SELECT * FROM truck WHERE truck_id = 1;

-- Example 1698
SHOW TABLES IN DATABASE hybrid_quickstart_db;
SELECT "name", "is_hybrid" FROM TABLE(RESULT_SCAN(last_query_id()));

-- Example 1699
SELECT * FROM truck_history LIMIT 10;
SELECT * FROM order_header LIMIT 10;

-- Example 1700
SET order_id = (SELECT order_id FROM order_header LIMIT 1);

SELECT hy.*,st.*
  FROM order_header AS hy JOIN truck_history AS st ON hy.truck_id = st.truck_id
  WHERE hy.order_id = $order_id
    AND st.record_end_time IS NULL;

