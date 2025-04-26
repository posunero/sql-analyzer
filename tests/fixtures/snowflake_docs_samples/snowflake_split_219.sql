-- Example 14653
{
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What is the month over month revenue growth for 2021 in Asia?"
                }
            ]
        },
        {
            "role": "analyst",
            "content": [
                {
                    "type": "text",
                    "text": "We interpreted your question as ..."
                },
                {
                    "type": "sql",
                    "statement": "SELECT * FROM table"
                }
            ]
        },
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What about North America?"
                }
            ]
        },
    ],
    "semantic_model_file": "@my_stage/my_semantic_model.yaml"
}

-- Example 14654
CREATE DATABASE semantic_model;
CREATE SCHEMA semantic_model.definitions;
GRANT USAGE ON DATABASE semantic_model TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA semantic_model.definitions TO ROLE PUBLIC;

USE SCHEMA semantic_model.definitions;

-- Example 14655
CREATE STAGE public DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE public TO ROLE PUBLIC;

CREATE STAGE sales DIRECTORY = (ENABLE = TRUE);
GRANT READ ON STAGE sales TO ROLE sales_analyst;

-- Example 14656
snow stage copy file:///path/to/local/file.yaml @sales

-- Example 14657
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET ENABLE_CORTEX_ANALYST = FALSE;

-- Example 14658
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;

-- Example 14659
CREATE [ OR REPLACE ] CORTEX SEARCH SERVICE [ IF NOT EXISTS ] <name>
  ON <search_column>
  ATTRIBUTES <col_name> [ , ... ]
  WAREHOUSE = <warehouse_name>
  TARGET_LAG = '<num> { seconds | minutes | hours | days }'
  [ EMBEDDING_MODEL = <embedding_model_name> ]
  [ INITIALIZE = { ON_CREATE | ON_SCHEDULE } ]
  [ COMMENT = '<comment>' ]
  AS <query>;

-- Example 14660
Your service has not yet been loaded into our serving system. Please retry your request in a few minutes.

-- Example 14661
CREATE OR REPLACE CORTEX SEARCH SERVICE mysvc
  ON transcript_text
  ATTRIBUTES region,agent_id
  WAREHOUSE = mywh
  TARGET_LAG = '1 hour'
  EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
AS (
  SELECT
      transcript_text,
      date,
      region,
      agent_id
  FROM support_db.public.transcripts_etl
);

-- Example 14662
CREATE OR REPLACE CORTEX SEARCH SERVICE mysvc
  ON transcript_text
  ATTRIBUTES region
  WAREHOUSE = mywh
  TARGET_LAG = '1 hour'
  INITIALIZE = ON_SCHEDULE
AS SELECT * FROM support_db.public.transcripts_etl;

-- Example 14663
pip install snowflake -U

-- Example 14664
import os
from snowflake.core import Root
from snowflake.snowpark import Session

CONNECTION_PARAMETERS = {
    "account": os.environ["snowflake_account_demo"],
    "user": os.environ["snowflake_user_demo"],
    "password": os.environ["snowflake_password_demo"],
    "role": "test_role",
    "database": "test_database",
    "warehouse": "test_warehouse",
    "schema": "test_schema",
}

session = Session.builder.configs(CONNECTION_PARAMETERS).create()
root = Root(session)

-- Example 14665
# fetch service
my_service = (root
  .databases["<service_database>"]
  .schemas["<service_schema>"]
  .cortex_search_services["<service_name>"]
)

# query service
resp = my_service.search(
  query="<query>",
  columns=["<col1>", "<col2>"],
  filter={"@eq": {"<column>": "<value>"} },
  limit=5
)
print(resp.to_json())

-- Example 14666
https://<account_url>/api/v2/databases/<db_name>/schemas/<schema_name>/cortex-search-services/<service_name>:query

-- Example 14667
curl --location https://<ACCOUNT_URL>/api/v2/databases/<DB_NAME>/schemas/<SCHEMA_NAME>/cortex-search-services/<SERVICE_NAME>\:query \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $CORTEX_SEARCH_JWT" \
--data '{
  "query": "<search_query>",
  "columns": ["col1", "col2"],
  "filter": <filter>
  "limit": <limit>
}'

-- Example 14668
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'my_search_service',
      '{
         "query": "preview query",
         "columns":[
            "col1",
            "col2"
         ],
         "filter": {"@eq": {"col1": "filter value"} },
         "limit":10
      }'
  )
)['results'] as results;

-- Example 14669
{ "@eq": { "string_col": "value" } }

-- Example 14670
{ "@contains": { "array_col": "arr_value" } }

-- Example 14671
{ "@and": [
  { "@gte": { "numeric_col": 10.5 } },
  { "@lte": { "numeric_col": 12.5 } }
]}

-- Example 14672
{ "@and": [
  { "@gte": { "timestamp_col": "2024-11-19" } },
  { "@lte": { "timestamp_col": "2024-12-19" } }
]}

-- Example 14673
// Rows where the "array_col" column contains "arr_value" and the "string_col" column equals "value":
{
    "@and": [
      { "@contains": { "array_col": "arr_value" } },
      { "@eq": { "string_col": "value" } }
    ]
}

// Rows where the "string_col" column does not equal "value"
{
  "@not": { "@eq": { "string_col": "value" } }
}

// Rows where the "array_col" column contains at least one of "val1", "val2", or "val3"
{
  "@or": [
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } }
  ]
}

-- Example 14674
pip install snowflake -U

-- Example 14675
import os
from snowflake.core import Root
from snowflake.snowpark import Session

CONNECTION_PARAMETERS = {
    "account": os.environ["snowflake_account_demo"],
    "user": os.environ["snowflake_user_demo"],
    "password": os.environ["snowflake_password_demo"],
    "role": "test_role",
    "database": "test_database",
    "warehouse": "test_warehouse",
    "schema": "test_schema",
}

session = Session.builder.configs(CONNECTION_PARAMETERS).create()
root = Root(session)

-- Example 14676
# fetch service
my_service = (root
  .databases["<service_database>"]
  .schemas["<service_schema>"]
  .cortex_search_services["<service_name>"]
)

# query service
resp = my_service.search(
  query="<query>",
  columns=["<col1>", "<col2>"],
  filter={"@eq": {"<column>": "<value>"} },
  limit=5
)
print(resp.to_json())

-- Example 14677
https://<account_url>/api/v2/databases/<db_name>/schemas/<schema_name>/cortex-search-services/<service_name>:query

-- Example 14678
curl --location https://<ACCOUNT_URL>/api/v2/databases/<DB_NAME>/schemas/<SCHEMA_NAME>/cortex-search-services/<SERVICE_NAME>\:query \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $CORTEX_SEARCH_JWT" \
--data '{
  "query": "<search_query>",
  "columns": ["col1", "col2"],
  "filter": <filter>
  "limit": <limit>
}'

-- Example 14679
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'my_search_service',
      '{
         "query": "preview query",
         "columns":[
            "col1",
            "col2"
         ],
         "filter": {"@eq": {"col1": "filter value"} },
         "limit":10
      }'
  )
)['results'] as results;

-- Example 14680
{ "@eq": { "string_col": "value" } }

-- Example 14681
{ "@contains": { "array_col": "arr_value" } }

-- Example 14682
{ "@and": [
  { "@gte": { "numeric_col": 10.5 } },
  { "@lte": { "numeric_col": 12.5 } }
]}

-- Example 14683
{ "@and": [
  { "@gte": { "timestamp_col": "2024-11-19" } },
  { "@lte": { "timestamp_col": "2024-12-19" } }
]}

-- Example 14684
// Rows where the "array_col" column contains "arr_value" and the "string_col" column equals "value":
{
    "@and": [
      { "@contains": { "array_col": "arr_value" } },
      { "@eq": { "string_col": "value" } }
    ]
}

// Rows where the "string_col" column does not equal "value"
{
  "@not": { "@eq": { "string_col": "value" } }
}

// Rows where the "array_col" column contains at least one of "val1", "val2", or "val3"
{
  "@or": [
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } }
  ]
}

-- Example 14685
CREATE OR REPLACE DYNAMIC TABLE product
  TARGET_LAG = '20 minutes'
  WAREHOUSE = mywh
  REFRESH_MODE = auto
  INITIALIZE = on_create
  AS
    SELECT product_id, product_name FROM staging_table;

-- Example 14686
CREATE TABLE "quote""andunquote""" ...

-- Example 14687
quote"andunquote"

-- Example 14688
myidentifier
MyIdentifier1
My$identifier
_my_identifier

-- Example 14689
CREATE TABLE mytable(c1 INT, c2 INT);

-- Example 14690
+-------------------------------------+
| status                              |
|-------------------------------------|
| Table MYTABLE successfully created. |
+-------------------------------------+

-- Example 14691
CREATE TABLE "MYTABLE"(c1 INT, c2 INT);

-- Example 14692
002002 (42710): SQL compilation error:
Object 'MYTABLE' already exists.

-- Example 14693
"MyIdentifier"
"my.identifier"
"my identifier"
"My 'Identifier'"
"3rd_identifier"
"$Identifier"
"идентификатор"

-- Example 14694
"My.DB"."My.Schema"."Table.1"

-- Example 14695
TABLENAME
tablename
tableName
TableName

-- Example 14696
"TABLENAME"
"tablename"
"tableName"
"TableName"

-- Example 14697
TABLENAME
tablename
tableName
TableName
"TABLENAME"
"tablename"
"tableName"
"TableName"

-- Example 14698
-- Set the default behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = false;

-- Create a table with a double-quoted identifier
CREATE TABLE "One" (i int);  -- stored as "One"

-- Create a table with an unquoted identifier
CREATE TABLE TWO(j int);     -- stored as "TWO"

-- These queries work
SELECT * FROM "One";         -- searches for "One"
SELECT * FROM two;           -- searched for "TWO"
SELECT * FROM "TWO";         -- searches for "TWO"

-- These queries do not work
SELECT * FROM One;           -- searches for "ONE"
SELECT * FROM "Two";         -- searches for "Two"

-- Change to the all-uppercase behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = true;

-- Create another table with a double-quoted identifier
CREATE TABLE "Three"(k int); -- stored as "THREE"

-- These queries work
SELECT * FROM "Two";         -- searches for "TWO"
SELECT * FROM two;           -- searched for "TWO"
SELECT * FROM "TWO";         -- searches for "TWO"
SELECT * FROM "Three";       -- searches for "THREE"
SELECT * FROM three;         -- searches for "THREE"

-- This query does not work now - "One" is not retrievable
SELECT * FROM "One";         -- searches for "ONE"

-- Example 14699
-- Set the default behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = false;

-- Create a table with a double-quoted identifier
CREATE TABLE "Tab" (i int);  -- stored as "Tab"

-- Create a table with an unquoted identifier
CREATE TABLE TAB(j int);     -- stored as "TAB"

-- This query retrieves "Tab"
SELECT * FROM "Tab";         -- searches for "Tab"

-- Change to the all-uppercase behavior
ALTER SESSION SET QUOTED_IDENTIFIERS_IGNORE_CASE = true;

-- This query retrieves "TAB"
SELECT * FROM "Tab";         -- searches for "TAB"

-- Example 14700
ALTER CORTEX SEARCH SERVICE [ IF EXISTS ] <name>
  { SUSPEND | RESUME } [ { INDEXING | SERVING } ]

-- Example 14701
ALTER CORTEX SEARCH SERVICE mysvc SET WAREHOUSE = my_new_wh;

-- Example 14702
ALTER CORTEX SEARCH SERVICE mysvc SET COMMENT = 'new_comment';

-- Example 14703
ALTER CORTEX SEARCH SERVICE mysvc SET TARGET_LAG = '1 hour';

-- Example 14704
ALTER CORTEX SEARCH SERVICE mysvc SUSPEND SERVING;

-- Example 14705
CREATE PROCEDURE MyProcedure()
...
$$
   READ SESSION_VAR1;
   SET SESSION_VAR2;
$$
;

-- Example 14706
SET SESSION_VAR1 = 'some interesting value';
CALL MyProcedure();
SELECT *
  FROM table1
  WHERE column1 = $SESSION_VAR2;

-- Example 14707
SET SESSION_VAR1 = 'some interesting value';
READ SESSION_VAR1;
SET SESSION_VAR2;
SELECT *
  FROM table1
  WHERE column1 = $SESSION_VAR2;

-- Example 14708
SET Variable_1 = 49;

CREATE PROCEDURE sv_proc2(PARAMETER_1 FLOAT)
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  AS
  $$
    var rs = snowflake.execute( {sqlText: "SELECT 2 * " + PARAMETER_1} );
    rs.next();
    var MyString = rs.getColumnValue(1);
    return MyString;
  $$
  ;

CALL sv_proc2($Variable_1);

-- Example 14709
CREATE PROCEDURE sv_proc1()
  RETURNS VARCHAR
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
  AS
  $$
    var rs = snowflake.execute( {sqlText: "SET SESSION_VAR_ZYXW = 51"} );

    var rs = snowflake.execute( {sqlText: "SELECT 2 * $SESSION_VAR_ZYXW"} );
    rs.next();
    var MyString = rs.getColumnValue(1);

    rs = snowflake.execute( {sqlText: "UNSET SESSION_VAR_ZYXW"} );

    return MyString;
  $$
  ;

CALL sv_proc1();

-- This fails because SESSION_VAR_ZYXW is no longer defined.
SELECT $SESSION_VAR_ZYXW;

-- Example 14710
SET PROVINCE = 'Manitoba';
CALL MyProcedure($PROVINCE);

-- Example 14711
{ DESC | DESCRIBE } CORTEX SEARCH SERVICE <name>;

-- Example 14712
DESCRIBE CORTEX SEARCH SERVICE mysvc;

-- Example 14713
SELECT * FROM SNOWFLAKE.INFORMATION_SCHEMA.CORTEX_SEARCH_SERVICES;

-- Example 14714
SHOW DYNAMIC TABLES LIKE 'product_%' IN SCHEMA mydb.myschema;

-- Example 14715
+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
  | created_on               | name       | database_name | schema_name | cluster_by | rows | bytes  | owner    | target_lag | refresh_mode | refresh_mode_reason  | warehouse | comment | text                            | automatic_clustering | scheduling_state | last_suspended_on | is_clone  | is_replica  | is_iceberg | data_timestamp           | owner_role_type |
  |-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  |2025-01-01 16:32:28 +0000 | product_dt | my_db         | my_schema   |            | 2    | 2048   | ORGADMIN | DOWNSTREAM | INCREMENTAL  | null                 | mywh      |         | create or replace dynamic table | OFF                  | ACTIVE           | null              | false     | false       | false      |2025-01-01 16:32:28 +0000 | ROLE            |
                                                                                                                                                                                         |  product dt ...                 |                                                                                                                                                 |                                                                                                                                                                                                                                                                                                                                                                                                                       |
  +-------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 14716
DESC DYNAMIC TABLE my_dynamic_table;

-- Example 14717
+-------------------+--------------------------------------------------------------------------------------------------------------------------+
  | name   | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name  | privacy domain |
  |-------------------+------------------------------------------------------------------------------------------------------------------------|
  | AMOUNT | NUMBER(38,0) | COLUMN | Y     | null    | N           | N          | null  | null       | null    | null         | null           |                                                                                                                                                  |                                                                                                                                                                                                                                                                                                                                                                                                                       |
  +-------------------+------------------------------------------------------------------------------------------------------------------------+

-- Example 14718
GRANT OWNERSHIP ON DYNAMIC TABLE my_dynamic_table TO ROLE budget_admin;

-- Example 14719
GRANT OWNERSHIP ON FUTURE DYNAMIC TABLES IN SCHEMA mydb.myschema TO ROLE budget_admin;

