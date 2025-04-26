-- Example 22557
Effective row count limit = 1 epoch limit for base model / number of epochs trained

-- Example 22558
GRANT CREATE MODEL ON SCHEMA my_schema TO ROLE my_role;

-- Example 22559
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT a AS prompt, d AS completion FROM train',
  'SELECT a AS prompt, d AS completion FROM validation'
);

-- Example 22560
USE DATABASE mydb;
USE SCHEMA myschema;

SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM my_training_data',
  'SELECT prompt, completion FROM my_validation_data'
);

-- Example 22561
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'mydb.myschema.my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM mydb2.myschema2.my_training_data',
  'SELECT prompt, completion FROM mydb2.myschema2.my_validation_data'
);

-- Example 22562
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'my_tuned_model',
  'How to fine-tune mistral models'
);

-- Example 22563
Mistral models are a type of deep learning model used for image recognition and classification. Fine-tuning a Mistral model involves adjusting the model's parameters to ...

-- Example 22564
SELECT ...
  FROM left_hand_table_expression AS lhte,
    LATERAL (SELECT col_1 FROM table_2 AS t2 WHERE t2.col_1 = lhte.col_1);

-- Example 22565
... FROM te1, LATERAL iv1 ...

-- Example 22566
CREATE TABLE departments (department_id INTEGER, name VARCHAR);
CREATE TABLE employees (employee_ID INTEGER, last_name VARCHAR,
  department_ID INTEGER, project_names ARRAY);

INSERT INTO departments (department_ID, name) VALUES
  (1, 'Engineering'),
  (2, 'Support');
INSERT INTO employees (employee_ID, last_name, department_ID) VALUES
  (101, 'Richards', 1),
  (102, 'Paulson',  1),
  (103, 'Johnson',  2);

-- Example 22567
SELECT *
  FROM departments AS d, employees AS e
  WHERE e.department_ID = d.department_ID
  ORDER BY employee_ID;

-- Example 22568
+---------------+-------------+-------------+-----------+---------------+---------------+
| DEPARTMENT_ID | NAME        | EMPLOYEE_ID | LAST_NAME | DEPARTMENT_ID | PROJECT_NAMES |
|---------------+-------------+-------------+-----------+---------------+---------------|
|             1 | Engineering |         101 | Richards  |             1 | NULL          |
|             1 | Engineering |         102 | Paulson   |             1 | NULL          |
|             2 | Support     |         103 | Johnson   |             2 | NULL          |
+---------------+-------------+-------------+-----------+---------------+---------------+

-- Example 22569
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the current row in the LHT

-- Example 22570
SELECT *
  FROM departments AS d,
    LATERAL (SELECT * FROM employees AS e WHERE e.department_ID = d.department_ID) AS iv2
  ORDER BY employee_ID;

-- Example 22571
+---------------+-------------+-------------+-----------+---------------+---------------+
| DEPARTMENT_ID | NAME        | EMPLOYEE_ID | LAST_NAME | DEPARTMENT_ID | PROJECT_NAMES |
|---------------+-------------+-------------+-----------+---------------+---------------|
|             1 | Engineering |         101 | Richards  |             1 | NULL          |
|             1 | Engineering |         102 | Paulson   |             1 | NULL          |
|             2 | Support     |         103 | Johnson   |             2 | NULL          |
+---------------+-------------+-------------+-----------+---------------+---------------+

-- Example 22572
for each row in left_hand_table LHT:
  for each row in right_hand_table RHT:
    concatenate the columns of the RHT to the columns of the LHT

-- Example 22573
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the LHT row,
    and concatenate LHT columns to RHS columns

-- Example 22574
SELECT *
  FROM t1, TABLE(udtf2(t1.col1))
  ...
  ;

-- Example 22575
for each row in left_hand_table LHT:
  udtf2(row) -- that is, call udtf2() with the value(s) from the LHT row.

-- Example 22576
for each row in left_hand_table LHT:
  execute right_hand_subquery RHS using the values from the LHT row

-- Example 22577
UPDATE employees SET project_names = ARRAY_CONSTRUCT('Materialized Views', 'UDFs')
  WHERE employee_ID = 101;
UPDATE employees SET project_names = ARRAY_CONSTRUCT('Materialized Views', 'Lateral Joins')
  WHERE employee_ID = 102;

-- Example 22578
SELECT index, value AS project_name
  FROM TABLE(FLATTEN(INPUT => ARRAY_CONSTRUCT('project1', 'project2')));

-- Example 22579
+-------+--------------+
| INDEX | PROJECT_NAME |
|-------+--------------|
|     0 | "project1"   |
|     1 | "project2"   |
+-------+--------------+

-- Example 22580
SELECT * FROM table1, LATERAL FLATTEN(...);

-- Example 22581
SELECT emp.employee_ID, emp.last_name, index, value AS project_name
  FROM employees AS emp,
    LATERAL FLATTEN(INPUT => emp.project_names) AS proj_names
  ORDER BY employee_ID;

-- Example 22582
+-------------+-----------+-------+----------------------+
| EMPLOYEE_ID | LAST_NAME | INDEX | PROJECT_NAME         |
|-------------+-----------+-------+----------------------|
|         101 | Richards  |     0 | "Materialized Views" |
|         101 | Richards  |     1 | "UDFs"               |
|         102 | Paulson   |     0 | "Materialized Views" |
|         102 | Paulson   |     1 | "Lateral Joins"      |
+-------------+-----------+-------+----------------------+

-- Example 22583
CREATE SEMANTIC VIEW tpch_rev_analysis

  TABLES (
    orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
      PRIMARY KEY (o_orderkey)
      WITH SYNONYMS ('sales orders')
      COMMENT = 'All orders table for the sales domain',
    customers AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
      PRIMARY KEY (c_custkey)
      COMMENT = 'Main table for customer data',
    line_items AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
      PRIMARY KEY (l_orderkey, l_linenumber)
      COMMENT = 'Line items in orders'
  )

  RELATIONSHIPS (
    orders_to_customers AS
      orders (o_custkey) REFERENCES customers,
    line_item_to_orders AS
      line_items (l_orderkey) REFERENCES orders
  )

  FACTS (
    line_items.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
    orders.count_line_items AS COUNT(line_items.line_item_id),
    line_items.discounted_price AS l_extendedprice * (1 - l_discount)
      COMMENT = 'Extended price after discount'
  )

  DIMENSIONS (
    customers.customer_name AS customers.c_name
      WITH SYNONYMS = ('customer name')
      COMMENT = 'Name of the customer',
    orders.order_date AS o_orderdate
      COMMENT = 'Date when the order was placed',
    orders.order_year AS YEAR(o_orderdate)
      COMMENT = 'Year when the order was placed'
  )

  METRICS (
    customers.customer_count AS COUNT(c_custkey)
      COMMENT = 'Count of number of customers',
    orders.order_average_value AS AVG(orders.o_totalprice)
      COMMENT = 'Average order value across all orders',
    orders.average_line_items_per_order AS AVG(orders.count_line_items)
      COMMENT = 'Average number of line items per order'
  )

  COMMENT = 'Semantic view for revenue analysis';

-- Example 22584
TABLES (
  orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
    PRIMARY KEY (o_orderkey)
    WITH SYNONYMS ('sales orders')
    COMMENT = 'All orders table for the sales domain',
  customers AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
    PRIMARY KEY (c_custkey)
    COMMENT = 'Main table for customer data',
  line_items AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
    PRIMARY KEY (l_orderkey, l_linenumber)
    COMMENT = 'Line items in orders'

-- Example 22585
RELATIONSHIPS (
  orders_to_customers AS
    orders (o_custkey) REFERENCES customers (c_custkey),
  line_item_to_orders AS
    line_items (l_orderkey) REFERENCES orders (o_orderkey)
)

-- Example 22586
FACTS (
  line_items.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
  orders.count_line_items AS COUNT(line_items.line_item_id),
  line_items.discounted_price AS l_extendedprice * (1 - l_discount)
    COMMENT = 'Extended price after discount'
)

DIMENSIONS (
  customers.customer_name AS customers.c_name
    WITH SYNONYMS = ('customer name')
    COMMENT = 'Name of the customer',
  orders.order_date AS o_orderdate
    COMMENT = 'Date when the order was placed',
  orders.order_year AS YEAR(o_orderdate)
    COMMENT = 'Year when the order was placed'
)

METRICS (
  customers.customer_count AS COUNT(c_custkey)
    COMMENT = 'Count of number of customers',
  orders.order_average_value AS AVG(orders.o_totalprice)
    COMMENT = 'Average order value across all orders',
  orders.average_line_items_per_order AS AVG(orders.count_line_items)
    COMMENT = 'Average number of line items per order'
)

-- Example 22587
SHOW SEMANTIC VIEWS;

-- Example 22588
+-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------+
| created_on                    | name                  | database_name | schema_name       | comment                                      | owner           | owner_role_type | extension |
|-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------|
| 2025-03-20 15:06:34.039 -0700 | MY_NEW_SEMANTIC_MODEL | MY_DB         | MY_SCHEMA         | A semantic model created through the wizard. | MY_ROLE         | ROLE            | ["CA"]    |
| 2025-02-28 16:16:04.002 -0800 | O_TPCH_SEMANTIC_VIEW  | MY_DB         | MY_SCHEMA         | NULL                                         | MY_ROLE         | ROLE            | NULL      |
| 2025-03-21 07:03:54.120 -0700 | TPCH_REV_ANALYSIS     | MY_DB         | MY_SCHEMA         | Semantic view for revenue analysis           | MY_ROLE         | ROLE            | NULL      |
+-------------------------------+-----------------------+---------------+-------------------+----------------------------------------------+-----------------+-----------------+-----------+

-- Example 22589
DESCRIBE SEMANTIC VIEW tpch_rev_analysis;

-- Example 22590
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+
| object_kind  | object_name                  | parent_entity | property                 | property_value                         |
|--------------+------------------------------+---------------+--------------------------+----------------------------------------|
| NULL         | NULL                         | NULL          | COMMENT                  | Semantic view for revenue analysis     |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | CUSTOMERS                    | NULL          | BASE_TABLE_NAME          | CUSTOMER                               |
| TABLE        | CUSTOMERS                    | NULL          | PRIMARY_KEY              | ["C_CUSTKEY"]                          |
| TABLE        | CUSTOMERS                    | NULL          | COMMENT                  | Main table for customer data           |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | TABLE                    | CUSTOMERS                              |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | EXPRESSION               | customers.c_name                       |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | DATA_TYPE                | VARCHAR(25)                            |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | SYNONYMS                 | ["customer name"]                      |
| DIMENSION    | CUSTOMER_NAME                | CUSTOMERS     | COMMENT                  | Name of the customer                   |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | LINE_ITEMS                   | NULL          | BASE_TABLE_NAME          | LINEITEM                               |
| TABLE        | LINE_ITEMS                   | NULL          | PRIMARY_KEY              | ["L_ORDERKEY","L_LINENUMBER"]          |
| TABLE        | LINE_ITEMS                   | NULL          | COMMENT                  | Line items in orders                   |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | REF_TABLE                | ORDERS                                 |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | FOREIGN_KEY              | ["L_ORDERKEY"]                         |
| RELATIONSHIP | LINE_ITEM_TO_ORDERS          | LINE_ITEMS    | REF_KEY                  | ["O_ORDERKEY"]                         |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | EXPRESSION               | l_extendedprice * (1 - l_discount)     |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | DATA_TYPE                | NUMBER(25,4)                           |
| FACT         | DISCOUNTED_PRICE             | LINE_ITEMS    | COMMENT                  | Extended price after discount          |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | TABLE                    | LINE_ITEMS                             |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | EXPRESSION               | CONCAT(l_orderkey, '-', l_linenumber)  |
| FACT         | LINE_ITEM_ID                 | LINE_ITEMS    | DATA_TYPE                | VARCHAR(134217728)                     |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_DATABASE_NAME | SNOWFLAKE_SAMPLE_DATA                  |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_SCHEMA_NAME   | TPCH_SF1                               |
| TABLE        | ORDERS                       | NULL          | BASE_TABLE_NAME          | ORDERS                                 |
| TABLE        | ORDERS                       | NULL          | SYNONYMS                 | ["sales orders"]                       |
| TABLE        | ORDERS                       | NULL          | PRIMARY_KEY              | ["O_ORDERKEY"]                         |
| TABLE        | ORDERS                       | NULL          | COMMENT                  | All orders table for the sales domain  |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | TABLE                    | ORDERS                                 |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | REF_TABLE                | CUSTOMERS                              |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | FOREIGN_KEY              | ["O_CUSTKEY"]                          |
| RELATIONSHIP | ORDERS_TO_CUSTOMERS          | ORDERS        | REF_KEY                  | ["C_CUSTKEY"]                          |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | TABLE                    | ORDERS                                 |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | EXPRESSION               | AVG(orders.count_line_items)           |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | DATA_TYPE                | NUMBER(36,6)                           |
| METRIC       | AVERAGE_LINE_ITEMS_PER_ORDER | ORDERS        | COMMENT                  | Average number of line items per order |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | TABLE                    | ORDERS                                 |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | EXPRESSION               | COUNT(line_items.line_item_id)         |
| FACT         | COUNT_LINE_ITEMS             | ORDERS        | DATA_TYPE                | NUMBER(18,0)                           |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | TABLE                    | ORDERS                                 |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | EXPRESSION               | AVG(orders.o_totalprice)               |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | DATA_TYPE                | NUMBER(30,8)                           |
| METRIC       | ORDER_AVERAGE_VALUE          | ORDERS        | COMMENT                  | Average order value across all orders  |
| DIMENSION    | ORDER_DATE                   | ORDERS        | TABLE                    | ORDERS                                 |
| DIMENSION    | ORDER_DATE                   | ORDERS        | EXPRESSION               | o_orderdate                            |
| DIMENSION    | ORDER_DATE                   | ORDERS        | DATA_TYPE                | DATE                                   |
| DIMENSION    | ORDER_DATE                   | ORDERS        | COMMENT                  | Date when the order was placed         |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | TABLE                    | ORDERS                                 |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | EXPRESSION               | YEAR(o_orderdate)                      |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | DATA_TYPE                | NUMBER(4,0)                            |
| DIMENSION    | ORDER_YEAR                   | ORDERS        | COMMENT                  | Year when the order was placed         |
+--------------+------------------------------+---------------+--------------------------+----------------------------------------+

-- Example 22591
SELECT GET_DDL('SEMANTIC_VIEW', 'tpch_rev_analysis', TRUE);

-- Example 22592
+-----------------------------------------------------------------------------------+
| GET_DDL('SEMANTIC_VIEW', 'TPCH_REV_ANALYSIS', TRUE)                               |
|-----------------------------------------------------------------------------------|
| create or replace semantic view DYOSHINAGA_DB.DYOSHINAGA_SCHEMA.TPCH_REV_ANALYSIS |
|     tables (                                                                                                                                                                       |
|             ORDERS primary key (O_ORDERKEY) with synonyms=('sales orders') comment='All orders table for the sales domain',                                                                                                                                                                       |
|             CUSTOMERS as CUSTOMER primary key (C_CUSTKEY) comment='Main table for customer data',                                                                                                                                                                       |
|             LINE_ITEMS as LINEITEM primary key (L_ORDERKEY,L_LINENUMBER) comment='Line items in orders'                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     relationships (                                                                                                                                                                       |
|             ORDERS_TO_CUSTOMERS as ORDERS(O_CUSTKEY) references CUSTOMERS(C_CUSTKEY),                                                                                                                                                                       |
|             LINE_ITEM_TO_ORDERS as LINE_ITEMS(L_ORDERKEY) references ORDERS(O_ORDERKEY)                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     facts (                                                                                                                                                                       |
|             ORDERS.COUNT_LINE_ITEMS as COUNT(line_items.line_item_id),                                                                                                                                                                       |
|             LINE_ITEMS.DISCOUNTED_PRICE as l_extendedprice * (1 - l_discount) comment='Extended price after discount',                                                                                                                                                                       |
|             LINE_ITEMS.LINE_ITEM_ID as CONCAT(l_orderkey, '-', l_linenumber)                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     dimensions (                                                                                                                                                                       |
|             ORDERS.ORDER_DATE as o_orderdate comment='Date when the order was placed',                                                                                                                                                                       |
|             ORDERS.ORDER_YEAR as YEAR(o_orderdate) comment='Year when the order was placed',                                                                                                                                                                       |
|             CUSTOMERS.CUSTOMER_NAME as customers.c_name with synonyms=('customer name') comment='Name of the customer'                                                                                                                                                                       |
|     )                                                                                                                                                                       |
|     metrics (                                                                                                                                                                       |
|             ORDERS.AVERAGE_LINE_ITEMS_PER_ORDER as AVG(orders.count_line_items) comment='Average number of line items per order',                                                                                                                                                                       |
|             ORDERS.ORDER_AVERAGE_VALUE as AVG(orders.o_totalprice) comment='Average order value across all orders'                                                                                                                                                                       |
|     );                                                                                                                                                                       |
+-----------------------------------------------------------------------------------+

-- Example 22593
DROP SEMANTIC VIEW tpch_rev_analysis;

-- Example 22594
SELECT * FROM information_schema.packages WHERE package_name = 'snowflake-snowpark-python' ORDER BY version DESC;

-- Example 22595
def run(session, from_table, to_table, count):

  session.table(from_table).limit(count).write.save_as_table(to_table)

  return "SUCCESS"

-- Example 22596
CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');

-- Example 22597
CREATE OR REPLACE PROCEDURE filterByRole(tableName VARCHAR, role VARCHAR)
RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'filter_by_role'
AS
$$
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
   df = session.table(table_name)
   return df.filter(col("role") == role)
$$;

-- Example 22598
CREATE OR REPLACE PROCEDURE filterByRole(tableName VARCHAR, role VARCHAR)
RETURNS TABLE()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'filter_by_role'
AS
$$
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
  df = session.table(table_name)
  return df.filter(col("role") == role)
$$;

-- Example 22599
CALL filterByRole('employees', 'dev');

-- Example 22600
+----+-------+------+
| ID | NAME  | ROLE |
+----+-------+------+
| 2  | Bob   | dev  |
| 3  | Cindy | dev  |
+----+-------+------+

-- Example 22601
CREATE OR REPLACE PROCEDURE joblib_multiprocessing_proc(i INT)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  HANDLER = 'joblib_multiprocessing'
  PACKAGES = ('snowflake-snowpark-python', 'joblib')
AS $$
import joblib
from math import sqrt

def joblib_multiprocessing(session, i):
  result = joblib.Parallel(n_jobs=-1)(joblib.delayed(sqrt)(i ** 2) for i in range(10))
  return str(result)
$$;

-- Example 22602
import joblib
joblib.parallel_backend('loky')

-- Example 22603
CREATE OR REPLACE PROCEDURE checkStatus()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER='async_handler'
EXECUTE AS CALLER
AS $$
def async_handler(session):
    async_job = session.sql("select system$wait(60)").collect_nowait()
    return async_job.is_done()
$$;

-- Example 22604
CALL checkStatus();

-- Example 22605
+-------------+
| checkStatus |
|-------------|
| False       |
+-------------+

-- Example 22606
CREATE OR REPLACE TABLE test_tb(c1 STRING);

-- Example 22607
CREATE OR REPLACE PROCEDURE cancelJob()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'async_handler'
EXECUTE AS OWNER
AS $$
def async_handler(session):
    async_job = session.sql("insert into test_tb (select system$wait(10))").collect_nowait()
    return async_job.cancel()
$$;

CALL cancelJob();

-- Example 22608
SELECT * FROM test_tb;

-- Example 22609
+----+
| C1 |
|----|
+----+

-- Example 22610
CREATE OR REPLACE PROCEDURE blockUntilDone()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER='async_handler'
EXECUTE AS CALLER
AS $$
def async_handler(session):
    async_job = session.sql("select system$wait(5)").collect_nowait()
    return async_job.result()
$$;

-- Example 22611
CALL blockUntilDone();

-- Example 22612
+------------------------------------------+
| blockUntilDone                               |
|------------------------------------------|
| [Row(SYSTEM$WAIT(5)='waited 5 seconds')] |
+------------------------------------------+

-- Example 22613
CREATE OR REPLACE PROCEDURE earlyReturn()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER='async_handler'
EXECUTE AS CALLER
AS $$
def async_handler(session):
    async_job = session.sql("select system$wait(60)").collect_nowait()
    df = async_job.to_df()
    try:
        df.collect()
    except Exception as ex:
        return 'Error: (02000): Result for query <UUID> has expired'
$$;

-- Example 22614
CALL earlyReturn();

-- Example 22615
+------------------------------------------------------------+
| earlyReturn                                                 |
|------------------------------------------------------------|
| Error: (02000): Result for query <UUID> has expired        |
+------------------------------------------------------------+

-- Example 22616
CREATE OR REPLACE PROCEDURE earlyCancelJob()
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = 3.9
PACKAGES = ('snowflake-snowpark-python')
HANDLER='async_handler'
EXECUTE AS OWNER
AS $$
def async_handler(session):
    async_job = session.sql("insert into test_tb (select system$wait(10))").collect_nowait()
$$;

-- Example 22617
CALL earlyCancelJob();
SELECT * FROM test_tb;

-- Example 22618
+----+
| C1 |
|----|
+----+

-- Example 22619
SET my_variable=10;
SET my_variable='example';

-- Example 22620
SET (var1, var2, var3)=(10, 20, 30);
SET (var1, var2, var3)=(SELECT 10, 20, 30);

-- Example 22621
// Build connection properties
Properties properties = new Properties();

// Required connection properties
properties.put("user"    ,  "jsmith"      );
properties.put("password",  "mypassword");
properties.put("account" ,  "myaccount");

// Set some additional variables.
properties.put("$variable_1", "some example");
properties.put("$variable_2", "1"           );

// Create a new connection
String connectStr = "jdbc:snowflake://localhost:8080";

// Open a connection under the snowflake account and enable variable support
Connection con = DriverManager.getConnection(connectStr, properties);

-- Example 22622
SET (min, max)=(40, 70);

SELECT $min;

SELECT AVG(salary) FROM emp WHERE age BETWEEN $min AND $max;

-- Example 22623
SET my_table_name='table1';

