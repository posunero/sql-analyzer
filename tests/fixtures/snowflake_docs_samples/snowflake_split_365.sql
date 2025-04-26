-- Example 24430
INSERT INTO mytable (customer_id, full_name, email, extended_customer_info)
  SELECT 100, 'Jane Doe', 'jdoe@example.com',
    parse_json('{"address": "1234 Main St", "city": "San Francisco", "state": "CA", "zip":"94110"}');

-- Example 24431
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       1 |
+-------------------------+

-- Example 24432
200001 (22000): Primary key already exists

-- Example 24433
Duplicate key value violates unique constraint "SYS_INDEX_MYTABLE_UNIQUE_EMAIL"

-- Example 24434
SHOW TABLES LIKE 'mytable';

-- Example 24435
+-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+
| created_on                    | name    | database_name | schema_name | kind  | is_hybrid | comment | cluster_by | rows | bytes | owner  | retention_time | automatic_clustering | change_tracking | search_optimization | search_optimization_progress | search_optimization_bytes | is_external |
|-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------|
| 2022-02-23 23:53:19.707 +0000 | MYTABLE | MYDB          | PUBLIC      | TABLE | Y         |         |            | NULL |  NULL | MYROLE | 10             | OFF                  | OFF             | OFF                 |                         NULL |                      NULL | N           |
+-------------------------------+---------+---------------+-------------+-------+-----------+---------+------------+------+-------+--------+----------------+----------------------+-----------------+---------------------+------------------------------+---------------------------+-------------+

-- Example 24436
SHOW HYBRID TABLES;

-- Example 24437
+-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------+
| created_on                    | name                      | database_name | schema_name | owner        | datastore_id | rows | bytes | comment |
|-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------|
| 2022-02-24 02:07:31.877 +0000 | MYTABLE                   | DEMO_DB       | PUBLIC      | ACCOUNTADMIN |         2002 | NULL |  NULL |         |
+-------------------------------+---------------------------+---------------+-------------+--------------+--------------+------+-------+---------+

-- Example 24438
DESCRIBE TABLE mytable;

-- Example 24439
+-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+
| name              | type         | kind   | null? | default | primary key | unique key | check | expression | comment | policy name |
|-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------|
| CUSTOMER_ID       | NUMBER(38,0) | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | NULL    | NULL        |
| FULL_NAME         | VARCHAR(256) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
| APPLICATION_STATE | VARIANT      | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL    | NULL        |
+-------------------+--------------+--------+-------+---------+-------------+------------+-------+------------+---------+-------------+

-- Example 24440
SELECT customer_id, full_name, email, extended_customer_info
  FROM mytable
  WHERE extended_customer_info['state'] = 'CA';

-- Example 24441
+-------------+-----------+------------------+------------------------------+
| CUSTOMER_ID | FULL_NAME | EMAIL            | EXTENDED_CUSTOMER_INFO       |
|-------------+-----------+------------------+------------------------------|
|         100 | Jane Doe  | jdoe@example.com | {                            |
|             |           |                  |   "address": "1234 Main St", |
|             |           |                  |   "city": "San Francisco",   |
|             |           |                  |   "state": "CA",             |
|             |           |                  |   "zip": "94110"             |
|             |           |                  | }                            |
+-------------+-----------+------------------+------------------------------+

-- Example 24442
CREATE OR REPLACE HYBRID TABLE team
  (team_id INT PRIMARY KEY,
  team_name VARCHAR(40),
  stadium VARCHAR(40));

CREATE OR REPLACE HYBRID TABLE player
  (player_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  team_id INT,
  FOREIGN KEY (team_id) REFERENCES team(team_id));

-- Example 24443
INSERT INTO team VALUES (1, 'Bayern Munich', 'Allianz Arena');
INSERT INTO player VALUES (100, 'Harry', 'Kane', 1);
INSERT INTO player VALUES (301, 'Gareth', 'Bale', 3);

-- Example 24444
200009 (22000): Foreign key constraint "SYS_INDEX_PLAYER_FOREIGN_KEY_TEAM_ID_TEAM_TEAM_ID" was violated.

-- Example 24445
INSERT INTO player VALUES (200, 'Tommy', 'Atkins', NULL);

-- Example 24446
200009 (22000): Foreign key constraint "SYS_INDEX_PLAYER_FOREIGN_KEY_TEAM_ID_TEAM_TEAM_ID" was violated.

-- Example 24447
SELECT * FROM team t, player p WHERE t.team_id=p.team_id;

-- Example 24448
+---------+---------------+---------------+-----------+------------+-----------+---------+
| TEAM_ID | TEAM_NAME     | STADIUM       | PLAYER_ID | FIRST_NAME | LAST_NAME | TEAM_ID |
|---------+---------------+---------------+-----------+------------+-----------+---------|
|       1 | Bayern Munich | Allianz Arena |       100 | Harry      | Kane      |       1 |
+---------+---------------+---------------+-----------+------------+-----------+---------+

-- Example 24449
INSERT INTO team VALUES (0, 'Unknown', 'Unknown');
INSERT INTO player VALUES (200, 'Tommy', 'Atkins', 0);

SELECT * FROM team t, player p WHERE t.team_id=p.team_id;

-- Example 24450
+---------+---------------+---------------+-----------+------------+-----------+---------+
| TEAM_ID | TEAM_NAME     | STADIUM       | PLAYER_ID | FIRST_NAME | LAST_NAME | TEAM_ID |
|---------+---------------+---------------+-----------+------------+-----------+---------|
|       1 | Bayern Munich | Allianz Arena |       100 | Harry      | Kane      |       1 |
|       0 | Unknown       | Unknown       |       200 | Tommy      | Atkins    |       0 |
+---------+---------------+---------------+-----------+------------+-----------+---------+

-- Example 24451
CREATE HYBRID TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(200),
    employee_department VARCHAR(200),
    INDEX idx_department (employee_department) INCLUDE (employee_name)
);

-- Example 24452
INSERT INTO employee VALUES
  (1, 'John Doe', 'Marketing'),
  (2, 'Jane Smith', 'Sales'),
  (3, 'Bob Johnson', 'Finance'),
  (4, 'Alice Brown', 'Marketing');

-- Example 24453
SELECT employee_name FROM employee WHERE employee_department = 'Marketing';
SELECT employee_name FROM employee WHERE employee_department IN ('Marketing', 'Sales');

-- Example 24454
CREATE OR REPLACE HYBRID TABLE ht1pk
  (COL1 NUMBER(38,0) NOT NULL COMMENT 'Primary key',
  COL2 NUMBER(38,0) NOT NULL,
  COL3 VARCHAR(16777216),
  CONSTRAINT PKEY_1 PRIMARY KEY (COL1));

DESCRIBE TABLE ht1pk;

-- Example 24455
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------+
| name | type              | kind   | null? | default | primary key | unique key | check | expression | comment     | policy name | privacy domain |
|------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------|
| COL1 | NUMBER(38,0)      | COLUMN | N     | NULL    | Y           | N          | NULL  | NULL       | Primary key | NULL        | NULL           |
| COL2 | NUMBER(38,0)      | COLUMN | N     | NULL    | N           | N          | NULL  | NULL       | NULL        | NULL        | NULL           |
| COL3 | VARCHAR(16777216) | COLUMN | Y     | NULL    | N           | N          | NULL  | NULL       | NULL        | NULL        | NULL           |
+------+-------------------+--------+-------+---------+-------------+------------+-------+------------+-------------+-------------+----------------+

-- Example 24456
Cannot connect: connection refused: Java::NetSnowflakeClientJdbc::SnowflakeSQLException: JDBC driver encountered communication error. Message: Exception encountered for HTTP request: Connection reset.

-- Example 24457
JDBC driver encountered communication error. Message: Exception encountered for HTTP request:

sun.security.validator.ValidatorException: No trusted certificate found.

OR

javax.net.ssl.SSLHandshakeException: No trusted certificate found

OR

'SSL peer certificate or SSH remote key was not OK'

-- Example 24458
JDBC driver encountered a communication error. Message: Exception encountered for an HTTP request: Network is unreachable (Connect Failed)

-- Example 24459
JDBC driver encountered communication error. Message: Exception encountered for HTTP request: <SERVICE_ENDPOINT>: nodename nor servname provided, or not known.

-- Example 24460
WARNING!!! Using fail-open to connect. Driver is connecting to an HTTPS endpoint without OCSP based Certificate Revocation checking as it could not obtain a valid OCSP Response to use from the CA OCSP responder. Details: {"cacheEnabled":true,"ocspReqBase64":null,"ocspMode":"FAIL_OPEN","sfcPeerHost":"<SERVICE_ENDPOINT>","ocspResponderURL":null,"cacheHit":true,"eventType":"OCSPValidationError","certId":"<OBFUSCATED>"}

-- Example 24461
JDBC driver internal error: Max retry reached for the download of #chunk0 (Total chunks:<x>) retry=<y>, error=net.snowflake.client.jdbc.SnowflakeSQLException: JDBC driver encountered communication error. Message: Error encountered when downloading a result chunk:

-- Example 24462
JDBC driver encountered communication error. Message: Exception encountered for HTTP request: Failed to find the root CA

-- Example 24463
net.snowflake.client.jdbc.internal.apache.http.impl.execchain.RetryExec execute INFO: I/O exception (java.net.SocketException) caught when processing request to {s}->https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443: Broken pipe (Write failed)

-- Example 24464
JDBC driver encountered communication error. Message: Exception encountered for HTTP request: Remote host terminated the handshake

-- Example 24465
net.snowflake.client.jdbc.SnowflakeSQLLoggedException: JDBC driver encountered IO error. Message: Encountered exception during upload: null.

-- Example 24466
JDBC driver encountered communication error. Message: Exception encountered for HTTP request: Certificate for [<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>] doesn't match any of the subject alternative names: [*.us-west-2.snowflakecomputing.com, *.us-west-2.aws.snowflakecomputing.com, *.global.snowflakecomputing.com, *.snowflakecomputing.com, *.prod1.us-west-2.aws.snowflakecomputing.com, *.prod2.us-west-2.aws.snowflakecomputing.com].

-- Example 24467
I/O exception (net.snowflake.client.jdbc.internal.apache.http.NoHttpResponseException) caught when processing request to {s}->https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>].snowflakecomputing.com:443: The target server failed to respond

-- Example 24468
'OLE DB or ODBC error: [DataSource.Error] ERROR [HY000] [Snowflake][Snowflake] (25) Result download worker error: Worker error: [Snowflake][Snowflake] (4) REST request for URL <>.... :  CURLerror (curl_easy_perform() failed) - code=60 msg='SSL peer certificate or SSH remote key was not OK' osCode=9 osMsg='Bad file descriptor'. . '.*

-- Example 24469
Error: nanodbc/nanodbc.cpp:1135: 01S00: [Snowflake][Snowflake] (4) REST request for URL *** failed: CURLerror (curl_easy_perform() failed) - code=60 msg='SSL peer certificate or SSH remote key was not OK'.

-- Example 24470
'SSL peer certificate or SSH remote key was not OK'

-- Example 24471
SSL certificate problem: self signed certificate in certificate chain. Please check for SSL interception proxy in your network.

-- Example 24472
CURLerror (curl _easy_perform failed) - code=35 msg='SSL connect error' osCode=10054 osMsg='Unknown error'.

-- Example 24473
'Empty reply from server' (CURLerror (curl_easy_perform() failed) - code=52 msg='Server returned nothing (no header..)

-- Example 24474
ERROR 5052 Simba::ODBC::Connection::SQLDriverConnectW: [Snowflake][Snowflake] (4) REST request for URL https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443/session/v1/login-request?requestId=<OBFUSCATED>&request_guid=<OBFUSCATED>&databaseName=<OBFUSCATED>&schemaName=<OBFUSCATED>&warehouse=<OBFUSCATED>failed: CURLerror (curl_easy_perform() failed) - code=35 msg='SSL connect error'.

-- Example 24475
ERROR 710 Simba::ODBC::Statement::SQLFetchScroll: [Snowflake][Snowflake] (25) Result download worker error: Worker error: [Snowflake][Snowflake] (4) REST request for URL https://<STAGE>/<OBFUSCATED>/results/<OBFUSCATED>_0/main/data_0_0_1?x-amz-server-side-encryption-customer-algorithm=<OBFUSCATED>&response-content-encoding=gzip&AWSAccessKeyId=<OBFUSCATED>&Expires=<OBFUSCATED>&Signature=<OBFUSCATED> failed: CURLerror (curl_easy_perform() failed) - code=52 msg='Server returned nothing (no headers, no data)'.

-- Example 24476
[Snowflake][Snowflake] (6) Assertion failure: error_in_response_json

-- Example 24477
WARN 9594 sf::RestRequest::httpPerform: Got CURL(0000015547C0CC10) error: Failed to connect to <PROXY_HOST> port 80: Timed out when fetching data from https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443/session/v1/login-request?requestId=<OBFUSCATED>&request_guid=<OBFUSCATED>. Status code: 11, curl error code: 28

-- Example 24478
ERROR [HY000] [Microsoft][Snowflake] (4) REST request for URL https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443/session/v1/login-request?requestId=<OBFUSCATED>&request_guid=<OBFUSCATED> failed: CURLerror (curl_easy_perform() failed) - code=6 msg='Couldn't resolve host name'.

-- Example 24479
ERROR [HY000] [Snowflake][Snowflake] (4) REST request for URL https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443/session/v1/login-request?requestId=<OBFUSCATED>&request_guid=<OBFUSCATED> failed: CURLerror (curl_easy_perform() failed) - code=5 msg='Couldn't resolve proxy name' osCode=9 osMsg='Bad file descriptor'.

-- Example 24480
[Snowflake][Snowflake] (25) Result download worker error: Worker error: [Snowflake][Snowflake] (4) REST request for URL https://<STAGE>/results/<OBFUSCATED>_02Fmain2Fdata_0_0_8?sv=<OBFUSCATED>&spr=https&se=<OBFUSCATED>&sr=b&sp=r&sig=<OBFUSCATED>&rsce=gzip failed: CURLerror (curl_easy_perform() failed) - code=42 msg='Operation was aborted by an application callback'.

-- Example 24481
SSL validation failed for https://<STAGE>/?accelerate [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:852)

-- Example 24482
SSLError: HTTPSConnectionPool(host='<STAGE>', port=443): Max retries exceeded with url: /<OBFUSCATED>/results/<OBFUSCATED>_0/main/data_0_0_1?x-amz-server-side-encryption-customer-algorithm=<OBFUSCATED>&response-content-encoding=gzip&AWSAccessKeyId=<OBFUSCATED>&Expires=<OBFUSCATED>&Signature=<OBFUSCATED> (Caused by SSLError(SSLError("bad handshake: Error([('SSL routines', 'tls_process_server_certificate', 'certificate verify failed')])")))

-- Example 24483
(Caused by ProxyError('Cannot connect to proxy.', OSError('Tunnel connection failed: 407 Request rejected by proxy')))

-- Example 24484
250001 (n/a): Could not connect to Snowflake backend after 0 attempt(s).Aborting

-- Example 24485
snowflake.connector.network.RetryRequest: HTTP 403: Forbidden

-- Example 24486
250003 (n/a): Failed to get the response. Hanging? method: post, url: https://[<SNOWFLAKE_DEPLOYMENT>|<SNOWFLAKE_DEPLOYMENT_REGIONLESS>|<CLIENT_FAILOVER>]:443/session/authenticator-request?request_guid=<OBFUSCATED>

-- Example 24487
Retrying (Retry(total=0, connect=None, read=None, redirect=None)) after connection broken by 'ProtocolError('Connection aborted.', RemoteDisconnected ('Remote end closed connection without response'))'

-- Example 24488
HTTPSConnectionPool(host='<STAGE>', port=443): Max retries exceeded with url: /<OBFUSCATED>/results/<OBFUSCATED>_0/main/data_0_0_1?x-amz-server-side-encryption-customer-algorithm=<OBFUSCATED>&response-content-encoding=gzip&X-Amz-Algorithm=<OBFUSCATED>&X-Amz-Date=<OBFUSCATED>&X-Amz-SignedHeaders=<OBFUSCATED>&X-Amz-Expires=<OBFUSCATED>&X-Amz-Credential=<OBFUSCATED>&X-Amz-Signature=<OBFUSCATED> (Caused by SSLError(SSLError("bad handshake: SysCallError(-1, 'Unexpected EOF')")))

-- Example 24489
REPLICATION_GROUP_REFRESH_PROGRESS( '<secondary_group_name>' )

REPLICATION_GROUP_REFRESH_PROGRESS_BY_JOB( '<query_id>' )

REPLICATION_GROUP_REFRESH_PROGRESS_ALL()

-- Example 24490
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS('rg1'));

-- Example 24491
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(
    INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS_BY_JOB(
      '012a3b45-1234-a12b-0000-1aa200012345'));

-- Example 24492
SELECT phase_name, start_time, end_time, progress, details
  FROM TABLE(INFORMATION_SCHEMA.REPLICATION_GROUP_REFRESH_PROGRESS_ALL());

-- Example 24493
USE WAREHOUSE app_wh;
USE ROLE samooha_app_role;
SET cleanroom_name = 'Developer Tutorial';
CALL samooha_by_snowflake_local_db.provider.cleanroom_init(
  $cleanroom_name,
  'INTERNAL');      -- Use EXTERNAL to share outside your Snowflake org

-- Example 24494
USE WAREHOUSE app_wh;
USE ROLE samooha_app_role;
SET cleanroom_name = 'Developer Tutorial'; -- Get the actual clean room name and provider's account locator from the provider.
CALL samooha_by_snowflake_local_db.consumer.
  install_cleanroom($cleanroom_name, <PROVIDER_LOCATOR>);

-- Example 24495
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

-- List created and published clean rooms
CALL samooha_by_snowflake_local_db.provider.view_cleanrooms();
SELECT CLEANROOM_ID AS "cleanroom_name"
  FROM TABLE(RESULT_SCAN(last_query_id()))
  WHERE STATE = 'CREATED' AND IS_PUBLISHED = TRUE;

-- Specify a clean room name from the list and drop it
CALL samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 24496
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

CALL samooha_by_snowflake_local_db.consumer.view_cleanrooms();
SELECT CLEANROOM_ID AS "cleanroom_name"
  FROM TABLE(RESULT_SCAN(last_query_id()))
  WHERE IS_ALREADY_INSTALLED = TRUE;

CALL samooha_by_snowflake_local_db.consumer.uninstall_cleanroom($cleanroom_name);

