-- Example 1497
definition_version: 2
entities:
   hello_snowflake_package:
      type: application package
      stage: stage_content.hello_snowflake_stage
      manifest: app/manifest.yml
      identifier: hello_snowflake_package
      artifacts:
         - src: app/*
           dest: ./
      meta:
         post_deploy:
            - sql_script: app/scripts/shared_content.sql
   hello_snowflake_app:
      type: application
      from:
         target: hello_snowflake_package
      debug: false

-- Example 1498
CREATE OR ALTER VERSIONED SCHEMA code_schema;
GRANT USAGE ON SCHEMA code_schema TO APPLICATION ROLE app_public;

-- Example 1499
CREATE VIEW IF NOT EXISTS code_schema.accounts_view
  AS SELECT ID, NAME, VALUE
  FROM shared_data.accounts;
GRANT SELECT ON VIEW code_schema.accounts_view TO APPLICATION ROLE app_public;

-- Example 1500
snow app run -c tut1-connection

-- Example 1501
snow sql -q "SELECT * FROM hello_snowflake_app.code_schema.accounts_view" -c tut1-connection

-- Example 1502
+----+----------+-----------+
| ID | NAME     | VALUE     |
|----+----------+-----------|
|  1 | Joe      | Snowflake |
|  2 | Nima     | Snowflake |
|  3 | Sally    | Snowflake |
|  4 | Juan     | Acme      |
+----+----------+-----------+

-- Example 1503
CREATE OR REPLACE FUNCTION code_schema.addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.11'
  HANDLER = 'addone_py'
  AS
  $$
  def addone_py(i):
    return i+1
  $$;

GRANT USAGE ON FUNCTION code_schema.addone(int) TO APPLICATION ROLE app_public;

-- Example 1504
CREATE or REPLACE FUNCTION code_schema.multiply(num1 float, num2 float)
  RETURNS float
  LANGUAGE PYTHON
  RUNTIME_VERSION = 3.9
  IMPORTS = ('/python/hello_python.py')
  HANDLER='hello_python.multiply';

GRANT USAGE ON FUNCTION code_schema.multiply(FLOAT, FLOAT) TO APPLICATION ROLE app_public;

-- Example 1505
def multiply(num1, num2):
  return num1*num2

-- Example 1506
- python/hello_python.py

-- Example 1507
snow app run -c tut1-connection

-- Example 1508
snow sql -q "SELECT hello_snowflake_app.code_schema.addone(1)" -c tut1-connection

-- Example 1509
snow sql -q "SELECT hello_snowflake_app.code_schema.multiply(1,2)" -c tut1-connection

-- Example 1510
# Import python packages
import streamlit as st
from snowflake.snowpark import Session

# Write directly to the app
st.title("Hello Snowflake - Streamlit Edition")
st.write(
   """The following data is from the accounts table in the application package.
      However, the Streamlit app queries this data from a view called
      code_schema.accounts_view.
   """
)

# Get the current credentials
session = Session.builder.getOrCreate()

#  Create an example data frame
data_frame = session.sql("SELECT * FROM code_schema.accounts_view")

# Execute the query and convert it into a Pandas data frame
queried_data = data_frame.to_pandas()

# Display the Pandas data frame as a Streamlit data frame.
st.dataframe(queried_data, use_container_width=True)

-- Example 1511
- streamlit/hello_snowflake.py

-- Example 1512
CREATE STREAMLIT IF NOT EXISTS code_schema.hello_snowflake_streamlit
  FROM '/streamlit'
  MAIN_FILE = '/hello_snowflake.py'
;

-- Example 1513
GRANT USAGE ON STREAMLIT code_schema.hello_snowflake_streamlit TO APPLICATION ROLE app_public;

-- Example 1514
snow app run -c tut1-connection

-- Example 1515
snow app version create v1_0 -c tut1-connection

-- Example 1516
snow app version list -c tut1-connection

-- Example 1517
+---------+-------+-------+---------+-------------------------------+------------+-----------+-------------+-------+---------------+
| version | patch | label | comment | created_on                    | dropped_on | log_level | trace_level | state | review_status |
|---------+-------+-------+---------+-------------------------------+------------+-----------+-------------+-------+---------------|
| V1_0    | 0     | NULL  | NULL    | 2024-05-09 10:33:39.768 -0700 | NULL       | OFF       | OFF         | READY | NOT_REVIEWED  |
+---------+-------+-------+---------+-------------------------------+------------+-----------+-------------+-------+---------------+

-- Example 1518
snow app run --version V1_0 -c tut1-connection

-- Example 1519
USE ROLE tutorial1_role;

-- Example 1520
USE APPLICATION hello_snowflake_app;

-- Example 1521
GRANT ATTACH LISTING ON APPLICATION PACKAGE HELLO_SNOWFLAKE_PACKAGE TO ROLE ACCOUNTADMIN;

-- Example 1522
LIST @hello_snowflake_package.stage_content.hello_snowflake_stage;
CALL core.hello();
SELECT * FROM code_schema.accounts_view;
SELECT code_schema.addone(10);
SELECT code_schema.multiply(2,3);

-- Example 1523
snow app version list -c tut1-connection

-- Example 1524
snow sql -q "ALTER APPLICATION PACKAGE hello_snowflake_package SET DEFAULT RELEASE DIRECTIVE VERSION = v1_0 PATCH = 0" -c tut1-connection

-- Example 1525
+-----------------------------------------------------------+
| status                                                    |
|-----------------------------------------------------------|
| Default release directive set to version 'V1_0', patch 0. |
+-----------------------------------------------------------+

-- Example 1526
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_creator;
GRANT USAGE ON WAREHOUSE streamlit_wh TO ROLE streamlit_creator;
GRANT CREATE STREAMLIT ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;
GRANT CREATE STAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_creator;

-- Example 1527
GRANT USAGE ON DATABASE streamlit_db TO ROLE streamlit_role;
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;
GRANT USAGE ON STREAMLIT streamlit_db.streamlit_schema.streamlit_app TO ROLE streamlit_role;

-- Example 1528
GRANT USAGE ON FUTURE STREAMLITS IN SCHEMA streamlit_db.streamlit_schema TO ROLE streamlit_role;

-- Example 1529
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Get the current credentials
session = get_active_session()

warehouse_sql = f"USE WAREHOUSE LARGE_WH"
session.sql(warehouse_sql).collect()

# Execute the SQL using a different warehouse
sql = """SELECT * from MY_DB.INFORMATION_SCHEMA.PACKAGES limit 100"""
session.sql(sql).collect()

-- Example 1530
CREATE OR REPLACE TABLE <your_database>.<your_schema>.BUG_REPORT_DATA (
  AUTHOR VARCHAR(25),
  BUG_TYPE VARCHAR(25),
  COMMENT VARCHAR(100),
  DATE DATE,
  BUG_SEVERITY NUMBER(38,0)
);

-- Example 1531
INSERT INTO <your_database>.<your_schema>.BUG_REPORT_DATA (AUTHOR, BUG_TYPE, COMMENT, DATE, BUG_SEVERITY)
VALUES
('John Doe', 'UI', 'The button is not aligned properly', '2024-03-01', 3),
('Aisha Patel', 'Performance', 'Page load time is too long', '2024-03-02', 5),
('Bob Johnson', 'Functionality', 'Unable to submit the form', '2024-03-03', 4),
('Sophia Kim', 'Security', 'SQL injection vulnerability found', '2024-03-04', 8),
('Michael Lee', 'Compatibility', 'Does not work on Internet Explorer', '2024-03-05', 2),
('Tyrone Johnson', 'UI', 'Font size is too small', '2024-03-06', 3),
('David Martinez', 'Performance', 'Search feature is slow', '2024-03-07', 4),
('Fatima Abadi', 'Functionality', 'Logout button not working', '2024-03-08', 3),
('William Taylor', 'Security', 'Sensitive data exposed in logs', '2024-03-09', 7),
('Nikolai Petrov', 'Compatibility', 'Not compatible with Safari', '2024-03-10', 2);

-- Example 1532
import streamlit as st

st.set_page_config(page_title="Bug report", layout="centered")

session = st.connection('snowflake').session()

# Change the query to point to your table
def get_data(_session):
    query = """
    select * from <your_database>.<your_schema>.BUG_REPORT_DATA
    order by date desc
    limit 100
    """
    data = _session.sql(query).collect()
    return data

# Change the query to point to your table
def add_row_to_db(session, row):
    sql = f"""INSERT INTO <your_database>.<your_schema>.BUG_REPORT_DATA VALUES
    ('{row['author']}',
    '{row['bug_type']}',
    '{row['comment']}',
    '{row['date']}',
    '{row['bug_severity']}')"""

    session.sql(sql).collect()

st.title("Bug report demo!")

st.sidebar.write(
    f"This app demos how to read and write data from a Snowflake Table"
)

form = st.form(key="annotation", clear_on_submit=True)

with form:
    cols = st.columns((1, 1))
    author = cols[0].text_input("Report author:")
    bug_type = cols[1].selectbox(
        "Bug type:", ["Front-end", "Back-end", "Data related", "404"], index=2
    )
    comment = st.text_area("Comment:")
    cols = st.columns(2)
    date = cols[0].date_input("Bug date occurrence:")
    bug_severity = cols[1].slider("Bug priority :", 1, 5, 2)
    submitted = st.form_submit_button(label="Submit")

if submitted:
    try:
        add_row_to_db(
            session,
            {'author':author,
            'bug_type': bug_type,
            'comment':comment,
            'date':str(date),
            'bug_severity':bug_severity
        })
        st.success("Thanks! Your bug was recorded in the database.")
        st.balloons()
    except Exception as e:
        st.error(f"An error occurred: {e}")

expander = st.expander("See 100 most recent records")
with expander:
    st.dataframe(get_data(session))

-- Example 1533
SELECT MyFunction(col1) FROM table1;

-- Example 1534
CREATE OR REPLACE PROCEDURE do_stuff(input NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
  ERROR VARCHAR DEFAULT 'Bad input. Number must be less than 10.';

BEGIN
  IF (input > 10) THEN
    RETURN ERROR;
  END IF;

  -- Perform an operation that doesn't return a value.

END;
$$
;

-- Example 1535
y = stored_procedure1(x);                         -- Not allowed.

-- Example 1536
SELECT MyFunction_1(column_1) FROM table1;

-- Example 1537
CALL MyStoredProcedure_1(argument_1);

-- Example 1538
CREATE PROCEDURE ...
  $$
  // Create a Statement object that can call a stored procedure named
  // MY_PROCEDURE().
  var stmt1 = snowflake.createStatement( { sqlText: "call MY_PROCEDURE(22)" } );
  // Execute the SQL command; in other words, call MY_PROCEDURE(22).
  stmt1.execute();
  // Create a Statement object that executes a SQL command that includes
  // a call to a UDF.
  var stmt2 = snowflake.createStatement( { sqlText: "select MY_UDF(column1) from table1" } );
  // Execute the SQL statement and store the output (the "result set") in
  // a variable named "rs", which we can access later.
  var rs = stmt2.execute();
  // etc.
  $$;

-- Example 1539
CREATE PROCEDURE ...
  -- Call a stored procedure named my_procedure().
  CALL my_procedure(22);
  -- Execute a SQL statement that includes a call to a UDF.
  SELECT my_udf(column1) FROM table1;

-- Example 1540
CREATE OR REPLACE PROCEDURE myproc(from_table STRING, to_table STRING, count INT)
  RETURNS STRING
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  HANDLER = 'run'
as
$$
def run(session, from_table, to_table, count):
  session.table(from_table).limit(count).write.save_as_table(to_table)
  return "SUCCESS"
$$;

-- Example 1541
CALL myproc('table_a', 'table_b', 5);

-- Example 1542
CREATE OR REPLACE FUNCTION addone(i INT)
  RETURNS INT
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  HANDLER = 'addone_py'
AS $$
def addone_py(i):
 return i+1
$$;

-- Example 1543
SELECT addone(3);

-- Example 1544
{
    "meta":
    {
        "offset": 1,
        "topic": "PressureOverloadWarning",
        "partition": 12,
        "key": "key name",
        "schema_id": 123,
        "CreateTime": 1234567890,
        "headers":
        {
            "name1": "value1",
            "name2": "value2"
        }
    },
    "content":
    {
        "ID": 62,
        "PSI": 451,
        "etc": "..."
    }
}

-- Example 1545
select
       record_metadata:CreateTime,
       record_content:ID
    from table1
    where record_metadata:topic = 'PressureOverloadWarning';

-- Example 1546
+------------+-----+
| CREATETIME | ID  |
+------------+-----+
| 1234567890 | 62  |
+------------+-----+

-- Example 1547
USE ROLE ACCOUNTADMIN;
CREATE ROLE myco_secrets_admin;
GRANT CREATE SECRET ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_secrets_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_secrets_admin;

USE ROLE myco_secrets_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE SECRET myco_git_secret
  TYPE = password
  USERNAME = 'gladyskravitz'
  PASSWORD = 'ghp_token';

-- Example 1548
USE ROLE ACCOUNTADMIN;
CREATE ROLE myco_git_admin;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE myco_git_admin;

USE ROLE myco_db_owner;
GRANT USAGE ON DATABASE myco_db TO ROLE myco_git_admin;
GRANT USAGE ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_secrets_admin;
GRANT USAGE ON SECRET myco_git_secret TO ROLE myco_git_admin;

USE ROLE myco_git_admin;
USE DATABASE myco_db;
USE SCHEMA myco_db.integrations;

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/my-account')
  ALLOWED_AUTHENTICATION_SECRETS = (myco_git_secret)
  ENABLED = TRUE;

-- Example 1549
$ git config --get remote.origin.url

-- Example 1550
https://github.com/my-account/snowflake-extensions.git

-- Example 1551
USE ROLE ACCOUNTADMIN;
GRANT CREATE GIT REPOSITORY ON SCHEMA myco_db.integrations TO ROLE myco_git_admin;

USE ROLE myco_git_admin;

CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = myco_git_secret
  ORIGIN = 'https://github.com/my-account/snowflake-extensions.git';

-- Example 1552
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 1553
SHOW GIT BRANCHES IN snowflake_extensions;

-- Example 1554
--------------------------------------------------------------------------------
| name | path           | checkouts | commit_hash                              |
--------------------------------------------------------------------------------
| main | /branches/main |           | 0f81b1487dfc822df9f73ac6b3096b9ea9e42d69 |
--------------------------------------------------------------------------------

-- Example 1555
LS @repository_stage_name/branches/branch_name;

-- Example 1556
LS @repository_stage_name/tags/tag_name;

-- Example 1557
LS @repository_stage_name/commits/commit_hash;

-- Example 1558
LS @snowflake_extensions/branches/main;

-- Example 1559
-------------------------------------------------------------------------------------------------------------------------------------------------------
| name                                                         | size | md5 | sha1                                     | last_modified                |
-------------------------------------------------------------------------------------------------------------------------------------------------------
| snowflake_extensions/branches/main/.gitignore                | 10   |     | e43b0f988953ae3a84b00331d0ccf5f7d51cb3cf | Wed, 5 Jul 2023 22:42:34 GMT |
-------------------------------------------------------------------------------------------------------------------------------------------------------
| snowflake_extensions/branches/main/python-handlers/filter.py | 169  |     | c717137b18d7b75005849d76d89037fafc7b5223 | Wed, 5 Jul 2023 22:42:34 GMT |
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 1560
DESCRIBE GIT REPOSITORY snowflake_extensions;

-- Example 1561
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| CREATED_ON                    | NAME                 | DATABASE_NAME | SCHEMA_NAME | ORIGIN                                                 | API_INTEGRATION     | GIT_CREDENTIALS           | OWNER        | OWNER_ROLE_TYPE | COMMENT |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_EXTENSIONS | MY_DB         | MAIN        | https://github.com/my-account/snowflake-extensions.git | GIT_API_INTEGRATION | MY_DB.MAIN.GIT_SECRET     | ACCOUNTADMIN | ROLE            |         |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 1562
EXECUTE IMMEDIATE FROM @snowflake_extensions/branches/main/sql/create-database.sql;

-- Example 1563
SELECT SYSTEM$GET_PREVIEW_ACCESS_STATUS();

-- Example 1564
+-------------------------------------------------------+
| SYSTEM$GET_PREVIEW_ACCESS_STATUS()                    |
+-------------------------------------------------------+
| Preview access is [ENABLED|DISABLED] for this account |
+-------------------------------------------------------+

