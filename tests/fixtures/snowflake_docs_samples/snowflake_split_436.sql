-- Example 29186
SELECT * FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLES(result_limit => <max_value>)) WHERE TARGET_LAG_SEC = 60 ;

-- Example 29187
SELECT schemaId FROM SNOWFLAKE.ACCOUNT_USAGE.DATA_CLASSIFICATION_LATEST LIMIT 1;

-- Example 29188
+----------+
| SCHEMAID |
|----------|
| ...      |
+----------+

-- Example 29189
SELECT schemaId FROM SNOWFLAKE.ACCOUNT_USAGE.DATA_CLASSIFICATION_LATEST LIMIT 1;

-- Example 29190
000904 (42000): SQL compilation error: error line 1 at position 7
invalid identifier 'SCHEMAID'

-- Example 29191
CREATE [ OR REPLACE ] FUNCTION <name> ( [ <arg_name> <arg_data_type> ] [ , ... ] )
  RETURNS <result_data_type>
  …
  [ MAX_BATCH_RETRIES = <integer> ]
  AS '<http_path_to_request_handler>'
  …

-- Example 29192
ALTER FUNCTION [ IF EXISTS ] <name> ( [ <arg_data_type> , ... ] ) SET MAX_BATCH_RETRIES = <integer>

-- Example 29193
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.BLOCK_STORAGE_HISTORY;

-- Example 29194
+-------------------------------+--------------------+-------------------------+----------------+-----------------------+-----------------------------+
| USAGE_DATE                    | STORAGE_TYPE       | COMPUTE_POOL_NAME       |       BYTES    |       ADDITIONAL_IOPS |       ADDITIONAL_THROUGHPUT |
|-------------------------------+--------------------+-------------------------+----------------|-----------------------|-----------------------------|
| 2025-02-01 00:00:00.000 -0700 | BLOCK_STORAGE      | POOL_1                  | 2,684,354,560  | 250.000000000         | 25.000000000                |
| 2025-02-01 00:00:00.000 -0700 | BLOCK_STORAGE      | POOL_2                  | 5,368,709,120  | 0.50000000            | 0.500000000                 |
| 2025-02-01 00:00:00.000 -0700 | SNAPSHOT           | NULL                    | 21,474,836,480 | 0.000000000           | 0.000000000                 |
+-------------------------------+--------------------+-------------------------+----------------+-----------------------+-----------------------------+

-- Example 29195
SELECT PARSE_XML('<?PITarget PIContent ??><mytag />') AS mytag;

-- Example 29196
100100 (22P02): Error parsing XML: prematurely terminated XML document in processing instructions, pos 33

-- Example 29197
+-----------------+
| MYTAG           |
|-----------------|
| <mytag></mytag> |
+-----------------+

-- Example 29198
SELECT PARSE_XML('<mytag myattr="&lt;&gt;\'"/>') AS mytag;

-- Example 29199
+------------------------------+
| MYTAG                        |
|------------------------------|
| <mytag myattr="<>'"></mytag> |
+------------------------------+

-- Example 29200
+-----------------------------------------+
| MYTAG                                   |
|-----------------------------------------|
| <mytag myattr="&lt;&gt;&apos;"></mytag> |
+-----------------------------------------+

-- Example 29201
SELECT PARSE_XML('<!DOCTYPE doc [<!ENTITY placeholder "some text">]><doc>&placeholder;</doc>')
  AS placeholder;

-- Example 29202
100100 (22P02): Error parsing XML: unknown entity &placeholder;, pos 68

-- Example 29203
+-------------------------------------------------------------+
| PLACEHOLDER                                                 |
|-------------------------------------------------------------|
| <!DOCTYPE doc [<!ENTITY placeholder "some                   |
| text">]><doc>some text</doc>                                |
+-------------------------------------------------------------+

-- Example 29204
SELECT PARSE_XML('<mytag xsl:space="preserve"> my content </mytag>')
  AS space_preserve;

-- Example 29205
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xsl:space="preserve"> my content </mytag> |
+--------------------------------------------------+

-- Example 29206
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xsl:space="preserve">my content</mytag>   |
+--------------------------------------------------+

-- Example 29207
SELECT PARSE_XML('<mytag xml:space="preserve"> my content </mytag>')
  AS space_preserve;

-- Example 29208
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xml:space="preserve">my content</mytag>   |
+--------------------------------------------------+

-- Example 29209
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xml:space="preserve"> my content </mytag> |
+--------------------------------------------------+

-- Example 29210
COPY INTO mytable
  FROM @my_xml_stage
  FILE_FORMAT = (TYPE = 'XML' PRESERVE_SPACE = TRUE);

-- Example 29211
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xsl:space="preserve"> my content </mytag> |
+--------------------------------------------------+

-- Example 29212
+--------------------------------------------------+
| SPACE_PRESERVE                                   |
|--------------------------------------------------|
| <mytag xml:space="preserve"> my content </mytag> |
+--------------------------------------------------+

-- Example 29213
SQL execution error: Cannot drop role <x> as it is the current primary role.

-- Example 29214
CREATE TABLE table1(columnA INT, columnB INT);

CREATE VIEW view1(columnC, columnD)
  AS
    SELECT * FROM table1;

CREATE STREAM stream1 ON VIEW view1;

-- Example 29215
CREATE TABLE table1(columnA INT, columnB INT);

CREATE VIEW view1(columnC, columnD)
AS
  SELECT * FROM table1;

CREATE STREAM stream1 ON VIEW view1;

-- Example 29216
CREATE INSTANCE INST OF CLASS test_class();
SHOW INSTANCES OF CLASS test_class;

-- Example 29217
CREATE TEST_CLASS inst();
SHOW TEST_CLASS instances;
SHOW test_class;

-- Example 29218
CREATE [ OR REPLACE ] STREAMLIT [ IF NOT EXISTS ] <name>
  [ { VERSION <version_alias_name> |
      VERSION (COMMENT = <version_comment>) |
      VERSION <version_alias_name> (COMMENT = <version_comment>) } ]
  [ FROM <source_location>]
  MAIN_FILE = '<path_to_main_file_in_root_directory>'
  QUERY_WAREHOUSE = <warehouse_name>
  [ COMMENT = <create_comment> ]
  [ DEFAULT_VERSION = <default_version_name_or_alias> ]
  [ TITLE = '<app_title>' ]
  [ IMPORTS = ( '<stage_path_and_file_name_to_read>' [ , ... ] ) ]
  [ EXTERNAL_ACCESS_INTEGRATIONS = ( <integration_name> [ , ... ] ) ]

-- Example 29219
CREATE STREAMLIT app
  FROM @streamlit_db.streamlit_schema.streamlit_stage;
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = my_warehouse;

-- Example 29220
CREATE STREAMLIT app
  FROM @streamlit_db.streamlit_schema.streamlit_repo/branches/streamlit_branch/;
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = my_warehouse;

-- Example 29221
ALTER STREAMLIT <name> ADD VERSION [ [ IF NOT EXISTS] <version_alias_name> ]
FROM <source_location>
[ COMMENT = <add_version_comment> ]

ALTER STREAMLIT <name> ADD VERSION <version_name>
FROM { <snowgit_tag_uri> | <snowgit_commit_uri> }
[ COMMENT = <git_pull_comment> ]

ALTER STREAMLIT <name> ADD LIVE VERSION [ [IF NOT EXISTS] <version_alias_name> ]
[ FROM LAST ]
[ COMMENT = <add_version_comment> ]

ALTER STREAMLIT <name> VERSION <existing_version_name_or_alias>
SET ALIAS = <new_version_name_alias>

ALTER STREAMLIT <name> COMMIT [ VERSION <live_version_alias> ] [COMMENT = <version_comment>]

ALTER STREAMLIT <name> SET DEFAULT_VERSION = <version_name> | <version_name_alias>

ALTER STREAMLIT <name> PUSH [TO <git_branch_uri>] [ { GIT_CREDENTIALS = <snowflake_secret> | USERNAME = <git_username> password = <git_password> } NAME = <git_author_name> EMAIL = <git_author_email> ] [ COMMENT = <git_push_comment>]

ALTER STREAMLIT <name> ABORT [ VERSION  <live_version_alias> ]

ALTER STREAMLIT <name> PULL

-- Example 29222
CREATE [ OR REPLACE ] NOTEBOOK [ IF NOT EXISTS ] <name>
  [ FROM '<source_location>' ]
  [ MAIN_FILE = '<main_file_name>' ]
  [ COMMENT = '<string_literal>' ]
  [ QUERY_WAREHOUSE = <warehouse_to_run_nb_and_sql_queries_in> ]
  [ IDLE_AUTO_SHUTDOWN_TIME_SECONDS = <number_of_seconds> ]

-- Example 29223
CREATE [ OR REPLACE ] NOTEBOOK [ IF NOT EXISTS ] <name>
  WAREHOUSE = <notebook_kernel_warehouse_name>
  [ FROM '<source_location>' ]
  [ MAIN_FILE = '<main_file_name>' ]
  [ COMMENT = '<string_literal>' ]
  [ QUERY_WAREHOUSE = <warehouse_to_run_sql_queries> ]
  [ IDLE_AUTO_SHUTDOWN_TIME_SECONDS = <number_of_seconds> ]

-- Example 29224
CREATE OR REPLACE PROCEDURE update_default_secondary_roles()
RETURNS VARIANT NOT NULL
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
let updated_users = [];
let users = snowflake.execute({sqlText: "SHOW USERS"});
while (users.next()) {
  let username = users.getColumnValue("name");
  let dsr = users.getColumnValue("default_secondary_roles");
  if (dsr !== "") {
    continue;
  }
  snowflake.execute({
    sqlText: "alter user identifier(?) set default_secondary_roles=()",
    binds: ["\"" + username + "\""],
  });
  updated_users.push(username);
}
return updated_users;
$$;

CALL update_default_secondary_roles();

-- Example 29225
CREATE ACCOUNT my_admin ADMIN_USER_TYPE = PERSON;

-- Example 29226
CREATE ACCOUNT my_admin
  ADMIN_USER_TYPE = SERVICE
  ADMIN_RSA_PUBLIC_KEY = 'MIIBIj...';

-- Example 29227
CREATE ACCOUNT my_admin
  ADMIN_USER_TYPE = LEGACY_SERVICE
  ADMIN_PASSWORD = 'password';

-- Example 29228
CREATE OR REPLACE FUNCTION udf_varchar(g1 VARCHAR)
  RETURNS VARCHAR
  AS $$
    'Hello' || g1
  $$;

-- Example 29229
SELECT GET_DDL('function', 'udf_varchar(VARCHAR)');

-- Example 29230
CREATE OR REPLACE FUNCTION "UDF_VARCHAR"("G1" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
AS '
  ''Hello'' || g1
';

-- Example 29231
CREATE OR REPLACE FUNCTION "UDF_VARCHAR"("G1" VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS '
  ''Hello'' || g1
';

-- Example 29232
DESCRIBE FUNCTION udf_varchar(VARCHAR);

-- Example 29233
+-----------+-------------------+
| property  | value             |
|-----------+-------------------|
| signature | (G1 VARCHAR)      |
| returns   | VARCHAR(16777216) |
| language  | SQL               |
| body      |                   |
|           |   'Hello' || g1   |
|           |                   |
+-----------+-------------------+

-- Example 29234
+-----------+-------------------+
| property  | value             |
|-----------+-------------------|
| signature | (G1 VARCHAR)      |
| returns   | VARCHAR           |
| language  | SQL               |
| body      |                   |
|           |   'Hello' || g1   |
|           |                   |
+-----------+-------------------+

-- Example 29235
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "UDF_VARCHAR(X VARCHAR):VARCHAR(16777216)",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

-- Example 29236
{
  "db.user": "MYUSERNAME",
  "snow.database.id": 13,
  "snow.database.name": "MY_DB",
  "snow.executable.id": 197,
  "snow.executable.name": "UDF_VARCHAR(X VARCHAR):VARCHAR",
  "snow.executable.type": "FUNCTION",
  "snow.owner.id": 2,
  "snow.owner.name": "MY_ROLE",
  "snow.query.id": "01ab0f07-0000-15c8-0000-0129000592c2",
  "snow.schema.id": 16,
  "snow.schema.name": "PUBLIC",
  "snow.session.id": 1275605667850,
  "snow.session.role.primary.id": 2,
  "snow.session.role.primary.name": "MY_ROLE",
  "snow.user.id": 25,
  "snow.warehouse.id": 5,
  "snow.warehouse.name": "MYWH",
  "telemetry.sdk.language": "python"
}

-- Example 29237
CREATE OR REPLACE TABLE table_with_default(x INT, v TEXT DEFAULT x::VARCHAR);

-- Example 29238
SELECT GET_DDL('table', 'table_with_default');

-- Example 29239
create or replace TABLE TABLE_WITH_DEFAULT ( |
      X NUMBER(38,0),
      V VARCHAR(16777216) DEFAULT CAST(TABLE_WITH_DEFAULT.X AS VARCHAR(16777216))
);

-- Example 29240
create or replace TABLE TABLE_WITH_DEFAULT ( |
      X NUMBER(38,0),
      V VARCHAR(16777216) DEFAULT CAST(TABLE_WITH_DEFAULT.X AS VARCHAR)
);

-- Example 29241
CREATE OR REPLACE EXTERNAL TABLE ext_table(
    data_str VARCHAR AS (value:c1::TEXT))
  LOCATION = @csv_stage
  AUTO_REFRESH = false
  FILE_FORMAT =(type = csv);

-- Example 29242
SELECT GET_DDL('table', 'ext_table');

-- Example 29243
create or replace external table EXT_TABLE(
      DATA_STR VARCHAR(16777216) AS (CAST(GET(VALUE, 'c1') AS VARCHAR(16777216))))
location=@CSV_STAGE/
auto_refresh=false
file_format=(TYPE=csv)
;

-- Example 29244
create or replace external table EXT_TABLE(
      DATA_STR VARCHAR(16777216) AS (CAST(GET(VALUE, 'c1') AS VARCHAR)))
location=@CSV_STAGE/
auto_refresh=false
file_format=(TYPE=csv)
;

-- Example 29245
SELECT SYSTEM$TYPEOF(REPEAT('a',10));

-- Example 29246
VARCHAR(16777216)[LOB]

-- Example 29247
VARCHAR[LOB]

-- Example 29248
CREATE OR REPLACE TABLE t AS
  SELECT TO_VARIANT('abc') AS col;

SHOW COLUMNS IN t;

-- Example 29249
{
  "type":"VARIANT",
  "length":16777216,
  "byteLength":16777216,
  "nullable":true,
  "fixed":false
}

-- Example 29250
{
  "type":"VARIANT",
  "nullable":true,
  "fixed":false
}

-- Example 29251
CREATE OR REPLACE FILE FORMAT json_format TYPE = JSON;

CREATE OR REPLACE TABLE table_varchar (lob_column VARCHAR) AS
  SELECT $1::VARCHAR
    FROM @lob_int_stage/driver_status.json.gz (FILE_FORMAT => 'json_format');

-- Example 29252
100069 (22P02): Error parsing JSON: document is too large, max size 16777216 bytes

