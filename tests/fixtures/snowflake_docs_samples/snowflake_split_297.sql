-- Example 19877
EXECUTE IMMEDIATE $$
    DECLARE
        MY_EXCEPTION EXCEPTION (-20001, 'Sample message');
    BEGIN
        RAISE MY_EXCEPTION;
    EXCEPTION
        WHEN STATEMENT_ERROR THEN
            RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT_ERROR',
                                    'SQLCODE', SQLCODE,
                                    'SQLERRM', SQLERRM,
                                    'SQLSTATE', SQLSTATE);
        WHEN EXPRESSION_ERROR THEN
            RETURN OBJECT_CONSTRUCT('Error type', 'EXPRESSION_ERROR',
                                    'SQLCODE', SQLCODE,
                                    'SQLERRM', SQLERRM,
                                    'SQLSTATE', SQLSTATE);
        WHEN OTHER THEN
            RETURN OBJECT_CONSTRUCT('Error type', 'Other error',
                                    'SQLCODE', SQLCODE,
                                    'SQLERRM', SQLERRM,
                                    'SQLSTATE', SQLSTATE);
    END;
$$
;

-- Example 19878
+--------------------------------+
| anonymous block                |
|--------------------------------|
| {                              |
|   "Error type": "Other error", |
|   "SQLCODE": -20001,           |
|   "SQLERRM": "Sample message", |
|   "SQLSTATE": "P0001"          |
| }                              |
+--------------------------------+

-- Example 19879
declare
    e1 exception;
    e2 exception;
begin
    statement_1;
    ...
    RETURN x;
exception
    when e1 then begin
        ...
        RETURN y;
        end;
    when e2 then begin
        ...
        RETURN z;
        end;
end;

-- Example 19880
*.duosecurity.com:443

-- Example 19881
ALTER ACCOUNT SET ALLOW_CLIENT_MFA_CACHING = TRUE;

-- Example 19882
pip install "snowflake-connector-python[secure-local-storage]"

-- Example 19883
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 19884
ALTER ACCOUNT UNSET ALLOW_CLIENT_MFA_CACHING;

-- Example 19885
SELECT EVENT_TIMESTAMP,
       USER_NAME,
       IS_SUCCESS
  FROM SNOWFLAKE.ACCOUNT_USAGE.LOGIN_HISTORY
  WHERE SECOND_AUTHENTICATION_FACTOR = 'MFA_TOKEN';

-- Example 19886
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=demo&passcode=123456

-- Example 19887
jdbc:snowflake://xy12345.snowflakecomputing.com/?user=demo&passcodeInPassword=on

-- Example 19888
authenticator: 'USERNAME_PASSWORD_MFA',
password: "abc123987654", // passcode 987654 is part of the password
passcodeInPassword: true  // because passcodeInPassword is true

-- Example 19889
authenticator: 'USERNAME_PASSWORD_MFA',
password: "abc123", // password and MFA passcode are input separately
passcode: "987654"

-- Example 19890
alter account set allow_id_token = true;

-- Example 19891
pip install "snowflake-connector-python[secure-local-storage]"

-- Example 19892
pip install "snowflake-connector-python[secure-local-storage,pandas]"

-- Example 19893
-- The following calls are equivalent.
-- Both log information-level messages.
SYSTEM$LOG('info', 'Information-level message');
SYSTEM$LOG_INFO('Information-level message');

-- The following calls are equivalent.
-- Both log error messages.
SYSTEM$LOG('error', 'Error message');
SYSTEM$LOG_ERROR('Error message');


-- The following calls are equivalent.
-- Both log warning messages.
SYSTEM$LOG('warning', 'Warning message');
SYSTEM$LOG_WARN('Warning message');

-- The following calls are equivalent.
-- Both log debug messages.
SYSTEM$LOG('debug', 'Debug message');
SYSTEM$LOG_DEBUG('Debug message');

-- The following calls are equivalent.
-- Both log trace messages.
SYSTEM$LOG('trace', 'Trace message');
SYSTEM$LOG_TRACE('Trace message');

-- The following calls are equivalent.
-- Both log fatal messages.
SYSTEM$LOG('fatal', 'Fatal message');
SYSTEM$LOG_FATAL('Fatal message');

-- Example 19894
CREATE OR REPLACE TABLE test_auto_event_logging (id INTEGER, num NUMBER(12, 2));

INSERT INTO test_auto_event_logging (id, num) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 19895
CREATE OR REPLACE PROCEDURE auto_event_logging_sp(
  table_name VARCHAR,
  id_val INTEGER,
  num_val NUMBER(12, 2))
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
  UPDATE IDENTIFIER(:table_name)
    SET num = :num_val
    WHERE id = :id_val;
  LET res RESULTSET := (SELECT * FROM IDENTIFIER(:table_name) ORDER BY id);
  RETURN TABLE(res);
EXCEPTION
  WHEN statement_error THEN
    res := (SELECT :sqlcode sql_code, :sqlerrm error_message, :sqlstate sql_state);
    RETURN TABLE(res);
END;
$$
;

-- Example 19896
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'LOGGING';

-- Example 19897
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'ALL';

-- Example 19898
CALL auto_event_logging_sp('test_auto_event_logging', 2, 33.33);

-- Example 19899
+----+-------+
| ID |   NUM |
|----+-------|
|  1 | 11.11 |
|  2 | 33.33 |
+----+-------+

-- Example 19900
SELECT
    TIMESTAMP as time,
    RECORD['severity_text'] as severity,
    VALUE as message
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE = 'LOG';

-- Example 19901
+-------------------------+----------+----------------------------------+
| TIME                    | SEVERITY | MESSAGE                          |
|-------------------------+----------+----------------------------------|
| 2024-10-25 20:42:24.134 | "TRACE"  | "Entering outer block at line 2" |
| 2024-10-25 20:42:24.135 | "TRACE"  | "Entering block at line 2"       |
| 2024-10-25 20:42:24.135 | "TRACE"  | "Starting child job"             |
| 2024-10-25 20:42:24.633 | "TRACE"  | "Ending child job"               |
| 2024-10-25 20:42:24.633 | "TRACE"  | "Starting child job"             |
| 2024-10-25 20:42:24.721 | "TRACE"  | "Ending child job"               |
| 2024-10-25 20:42:24.721 | "TRACE"  | "Exiting with return at line 7"  |
+-------------------------+----------+----------------------------------+

-- Example 19902
SYSTEM$ADD_EVENT('SProcEmptyEvent');
SYSTEM$ADD_EVENT('SProcEventWithAttributes', {'key1': 'value1', 'key2': 'value2'});

-- Example 19903
{
  "name": "SProcEmptyEvent"
}

-- Example 19904
{
  "name": "SProcEventWithAttributes"
}

-- Example 19905
{
  "key1": "value1",
  "key2": "value2"
}

-- Example 19906
SYSTEM$SET_SPAN_ATTRIBUTES(<object>);

-- Example 19907
SYSTEM$SET_SPAN_ATTRIBUTES('{'attr1':'value1', 'attr2':true}');

-- Example 19908
{
  "attr1": "value1",
  "attr2": "value2"
}

-- Example 19909
CREATE OR REPLACE PROCEDURE pi_proc()
  RETURNS DOUBLE
  LANGUAGE SQL
  AS $$
  BEGIN
    -- Add an event without attributes
    SYSTEM$ADD_EVENT('name_a');

    -- Add an event with attributes
    LET attr := {'score': 89, 'pass': TRUE};
    SYSTEM$ADD_EVENT('name_b', attr);

    -- Set attributes for the span
    SYSTEM$SET_SPAN_ATTRIBUTES({'key1': 'value1', 'key2': TRUE});

    RETURN 3.14;
  END;
  $$;

-- Example 19910
CALL pi_proc();

-- Example 19911
CREATE OR REPLACE TABLE test_auto_event_logging (id INTEGER, num NUMBER(12, 2));

INSERT INTO test_auto_event_logging (id, num) VALUES
  (1, 11.11),
  (2, 22.22);

-- Example 19912
CREATE OR REPLACE PROCEDURE auto_event_logging_sp(
  table_name VARCHAR,
  id_val INTEGER,
  num_val NUMBER(12, 2))
RETURNS TABLE()
LANGUAGE SQL
AS
$$
BEGIN
  UPDATE IDENTIFIER(:table_name)
    SET num = :num_val
    WHERE id = :id_val;
  LET res RESULTSET := (SELECT * FROM IDENTIFIER(:table_name) ORDER BY id);
  RETURN TABLE(res);
EXCEPTION
  WHEN statement_error THEN
    res := (SELECT :sqlcode sql_code, :sqlerrm error_message, :sqlstate sql_state);
    RETURN TABLE(res);
END;
$$
;

-- Example 19913
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'TRACING';

-- Example 19914
ALTER PROCEDURE auto_event_logging_sp(VARCHAR, INTEGER, NUMBER)
  SET AUTO_EVENT_LOGGING = 'ALL';

-- Example 19915
CALL auto_event_logging_sp('test_auto_event_logging', 2, 44.44);

-- Example 19916
+----+-------+
| ID |   NUM |
|----+-------|
|  1 | 11.11 |
|  2 | 44.44 |
+----+-------+

-- Example 19917
SELECT
    TIMESTAMP as time,
    RECORD['name'] as event_name,
    RECORD_ATTRIBUTES as attributes,
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE LIKE 'SPAN%';

-- Example 19918
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------+
| TIME                    | EVENT_NAME               | ATTRIBUTES                                                                                    |
|-------------------------+--------------------------+-----------------------------------------------------------------------------------------------|
| 2024-10-25 20:48:49.844 | "snow.auto_instrumented" | {                                                                                             |
|                         |                          |   "childJobTime": 474,                                                                        |
|                         |                          |   "executionTime": 2,                                                                         |
|                         |                          |   "inputArgumentValues": "{ ID_VAL: 2, TABLE_NAME: test_auto_event_logging, NUM_VAL: 44.44 }" |
|                         |                          | }                                                                                             |
| 2024-10-25 20:48:49.740 | "child_job"              | {                                                                                             |
|                         |                          |   "childJobUUID": "01b7ef00-0003-01d1-0000-a99501233092",                                     |
|                         |                          |   "rowCount": 1,                                                                              |
|                         |                          |   "rowsAffected": 1                                                                           |
|                         |                          | }                                                                                             |
| 2024-10-25 20:48:49.843 | "child_job"              | {                                                                                             |
|                         |                          |   "childJobUUID": "01b7ef00-0003-01d1-0000-a99501233096",                                     |
|                         |                          |   "rowCount": 2,                                                                              |
|                         |                          |   "rowsAffected": 0                                                                           |
|                         |                          | }                                                                                             |
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------+

-- Example 19919
CALL auto_event_logging_sp('no_table', 2, 82.44);

-- Example 19920
+----------+-----------------------------------------------------+-----------+
| SQL_CODE | ERROR_MESSAGE                                       | SQL_STATE |
|----------+-----------------------------------------------------+-----------|
|     2003 | SQL compilation error:                              | 42S02     |
|          | Object 'NO_TABLE' does not exist or not authorized. |           |
+----------+-----------------------------------------------------+-----------+

-- Example 19921
SELECT
    TIMESTAMP as time,
    RECORD['name'] as event_name,
    RECORD_ATTRIBUTES as attributes,
  FROM
    my_db.public.my_events
  WHERE
    RESOURCE_ATTRIBUTES['snow.executable.name'] LIKE '%AUTO_EVENT_LOGGING_SP%'
    AND RECORD_TYPE LIKE 'SPAN%';

-- Example 19922
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------+
| TIME                    | EVENT_NAME               | ATTRIBUTES                                                                                          |
|-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------|
| 2024-10-25 20:52:43.633 | "snow.auto_instrumented" | {                                                                                                   |
|                         |                          |   "childJobTime": 66,                                                                               |
|                         |                          |   "executionTime": 4,                                                                               |
|                         |                          |   "inputArgumentValues": "{ ID_VAL: 2, TABLE_NAME: no_table, NUM_VAL: 82.44 }"                      |
|                         |                          | }                                                                                                   |
| 2024-10-25 20:52:43.601 | "caught_exception"       | {                                                                                                   |
|                         |                          |   "exceptionCode": 2003,                                                                            |
|                         |                          |   "exceptionMessage": "SQL compilation error:\nObject 'NO_TABLE' does not exist or not authorized." |
|                         |                          | }                                                                                                   |
+-------------------------+--------------------------+-----------------------------------------------------------------------------------------------------+

-- Example 19923
SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('my_external_volume');

-- Example 19924
CREATE OR REPLACE ICEBERG TABLE iceberg_table_1 (
  col_1 int,
  col_2 string
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'iceberg_table_1';

CREATE OR REPLACE ICEBERG TABLE iceberg_table_2 (
  col_1 int,
  col_2 string
)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'iceberg_external_volume'
  BASE_LOCATION = 'iceberg_table_2';

-- Example 19925
STORAGE_BASE_URL
|-- iceberg_table_1.<randomId>
|   |-- data/
|   |-- metadata/
|-- iceberg_table_2.<randomId>
|   |-- data/
|   |-- metadata/

-- Example 19926
ALTER SCHEMA open_catalog
  SET BASE_LOCATION_PREFIX = 'my-open-catalog-tables';

-- Example 19927
CREATE OR REPLACE CATALOG INTEGRATION my_open_catalog_int
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  REST_CONFIG = (
    CATALOG_URI = 'https://<orgname>-<my-snowflake-open-catalog-account-name>.snowflakecomputing.com/polaris/api/catalog'
    CATALOG_NAME = 'myOpenCatalogExternalCatalogName'
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'myClientId'
    OAUTH_CLIENT_SECRET = 'myClientSecret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;

-- Example 19928
ALTER DATABASE db1 SET CATALOG_SYNC = 'my_open_catalog_int';

-- Example 19929
CREATE DATABASE db2
  CATALOG_SYNC = 'my_open_catalog_int';

-- Example 19930
ALTER SCHEMA public SET CATALOG_SYNC = 'my_open_catalog_int';

-- Example 19931
CREATE SCHEMA schema1
  CATALOG_SYNC = 'my_open_catalog_int';

-- Example 19932
USE SCHEMA open_catalog;

CREATE OR REPLACE ICEBERG TABLE my_iceberg_table (col1 INT)
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_external_volume';

-- Example 19933
function(err, conn)

-- Example 19934
// Load the Snowflake Node.js driver.
var snowflake = require('snowflake-sdk');

-- Example 19935
// Create a Connection object that we can use later to connect.
var connection = snowflake.createConnection({
    account: account,
    username: user,
    password: password,
    application: application
  });

-- Example 19936
// Try to connect to Snowflake, and check whether the connection was successful.
connection.connect( 
    function(err, conn) {
        if (err) {
            console.error('Unable to connect: ' + err.message);
            } 
        else {
            console.log('Successfully connected to Snowflake.');
            // Optional: store the connection ID.
            connection_ID = conn.getId();
            }
    }
);

-- Example 19937
// Create a Connection object and connect to Snowflake
// ..

// Verify if connection is still valid for sending queries over it
const isConnectionValid = await connection.isValidAsync();

// Do further actions based on the value (true or false) of isConnectionValid

-- Example 19938
function(err, stmt, rows)

-- Example 19939
// Create the connection pool instance
const connectionPool = snowflake.createPool(
    // connection options
    {
      account: account,
      username: user,
      password: password
    },
    // pool options
    {
      max: 10, // specifies the maximum number of connections in the pool
      min: 0   // specifies the minimum number of connections in the pool
    }
);

-- Example 19940
// Use the connection pool and execute a statement
connectionPool.use(async (clientConnection) =>
{
    const statement = await clientConnection.execute({
        sqlText: 'select 1;',
        complete: function (err, stmt, rows)
        {
            var stream = stmt.streamRows();
            stream.on('data', function (row)
            {
                console.log(row);
            });
            stream.on('end', function (row)
            {
                console.log('All rows consumed');
            });
        }
    });
});

-- Example 19941
const pool = snowflake.createPool(
    {
      account: account,
      username: username,

      //rest of the connection options

    },
    {
      evictionRunIntervalMillis: 60000 // default = 0, off
      idleTimeoutMillis: 60000, // default = 30000
      max: 2,
      min: 0,
    },
);

-- Example 19942
const pool = snowflake.createPool(
    {
      account: account,
      username: username,

      // rest of the connection options

      clientSessionKeepAlive: true,  // default = false
      clientSessionKeepAliveHeartbeatFrequency: 900 // default = 3600
    },
    {
      max: 2,
      min: 0,
    },
);

-- Example 19943
var connection = snowflake.createConnection({
      account: "account",
      username: "user",
      password: "password",
      proxyHost: "localhost",
      proxyPort: 3128,
});

