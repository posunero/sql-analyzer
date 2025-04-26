-- Example 17331
CREATE OR REPLACE NETWORK RULE hf_network_rule
MODE = EGRESS
TYPE = HOST_PORT
VALUE_LIST = ('huggingface.co', 'cdn-lfs.huggingface.co');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION hf_access_integration
ALLOWED_NETWORK_RULES = (hf_network_rule)
ENABLED = true;

-- Example 17332
CREATE OR REPLACE NETWORK RULE allow_all_rule
MODE= 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION allow_all_integration
ALLOWED_NETWORK_RULES = (allow_all_rule)
ENABLED = true;

-- Example 17333
GRANT USAGE ON INTEGRATION pypi_access_integration TO ROLE my_notebook_role;
GRANT USAGE ON INTEGRATION hf_access_integration TO ROLE my_notebook_role;
GRANT USAGE ON INTEGRATION allow_all_integration TO ROLE my_notebook_role;

-- Example 17334
ALTER NOTEBOOK <name>
 SET SECRETS = ('<secret_variable_name>' = <secret_name>);

-- Example 17335
CREATE OR REPLACE FUNCTION add_numbers (n1 NUMBER, n2 NUMBER)
  RETURNS NUMBER
  AS 'n1 + n2';

-- Example 17336
SELECT add_numbers(n1 => 10, n2 => 5);

-- Example 17337
SELECT add_numbers(n2 => 5, n1 => 10);

-- Example 17338
GRANT IMPORTED PRIVILEGES ON DATA EXCHANGE <exchange_name> TO <role_name>;

-- Example 17339
USE ROLE ACCOUNTADMIN;

GRANT IMPORTED PRIVILEGES ON DATA EXCHANGE mydataexchange TO myrole;

-- Example 17340
USE ROLE ACCOUNTADMIN;

-- Example 17341
GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE myrole;

-- Example 17342
GRANT CREATE DATA EXCHANGE LISTING ON ACCOUNT TO ROLE myrole WITH GRANT OPTION;

-- Example 17343
GRANT MODIFY ON DATA EXCHANGE PROFILE "<provider_profile_name>" TO ROLE myrole;

-- Example 17344
GRANT OWNERSHIP ON DATA EXCHANGE PROFILE "<provider_profile_name>" TO ROLE myrole;

-- Example 17345
SHOW TABLES LIKE ? LIMIT ?;

-- Example 17346
BEGIN
  LET a INT := 10;
  LET p STRING := 'mytable';
  LET res RESULTSET := (SHOW TABLES LIKE :p LIMIT :a);
  RETURN TABLE(res);
END;

-- Example 17347
SHOW TABLES LIKE ? LIMIT ?;

-- Example 17348
BEGIN
  LET a INT := 10;
  LET p STRING := 'mytable';
  LET res RESULTSET := (SHOW TABLES LIKE :p LIMIT :a);
  RETURN TABLE(res);
END;

-- Example 17349
GRANT SELECT ON ALL TABLES IN DATABASE DB1 TO DATABASE ROLE db1.viewer;
GRANT DATABASE ROLE db1.viewer TO APPLICATION hello_snowflake_app;

-- Example 17350
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET DISABLE_UI_DOWNLOAD_BUTTON = TRUE;

-- Example 17351
USE ROLE ACCOUNTADMIN;
ALTER USER <username> SET DISABLE_UI_DOWNLOAD_BUTTON =  TRUE;

-- Example 17352
GRANT SELECT ON ALL TABLES IN DATABASE DB1 TO DATABASE ROLE db1.viewer;
GRANT DATABASE ROLE db1.viewer TO APPLICATION hello_snowflake_app;

-- Example 17353
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET DISABLE_UI_DOWNLOAD_BUTTON = TRUE;

-- Example 17354
USE ROLE ACCOUNTADMIN;
ALTER USER <username> SET DISABLE_UI_DOWNLOAD_BUTTON =  TRUE;

-- Example 17355
EXECUTE IMMEDIATE $$
BEGIN
  LET c1 := 0;
  IF (c1 = 0) THEN
    INSERT invalid_text VALUES (1);
  END IF;
END;
$$
;

-- Example 17356
001003 (42000): SQL compilation error:
syntax error line 4 at position 5 unexpected '('.
syntax error line 4 at position 9 unexpected '='.

-- Example 17357
001003 (42000): SQL compilation error:
syntax error line 5 at position 11 unexpected 'invalid_text'.

-- Example 17358
EXECUTE IMMEDIATE $$
BEGIN
  LET c1 := 0;
  IF (c1 = 0) THEN
    INSERT invalid_text VALUES (1);
  END IF;
END;
$$
;

-- Example 17359
001003 (42000): SQL compilation error:
syntax error line 4 at position 5 unexpected '('.
syntax error line 4 at position 9 unexpected '='.

-- Example 17360
001003 (42000): SQL compilation error:
syntax error line 5 at position 11 unexpected 'invalid_text'.

-- Example 17361
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS dt_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 17362
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS task_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'TASK' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 17363
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS dt_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'DYNAMIC_TABLE' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 17364
SELECT
    timestamp,
    resource_attributes:"snow.executable.name"::VARCHAR AS task_name,
    resource_attributes:"snow.query.id"::VARCHAR AS query_id,
    value:message::VARCHAR AS error
  FROM my_event_table
  WHERE
    resource_attributes:"snow.executable.type" = 'TASK' AND
    resource_attributes:"snow.database.name" = 'MY_DB' AND
    value:state = 'FAILED'
  ORDER BY timestamp DESC;

-- Example 17365
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_01');

-- Example 17366
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2025_01');

-- Example 17367
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_DOCUMENT_PROCESSING_USAGE_HISTORY
  WHERE CREDITS_USED > 0.072

-- Example 17368
'reference_provider_join': {
    'display_name': 'Provider join column',
    'description': 'Which provider col do you want to join on',
    'references': ['PROVIDER_JOIN_POLICY'],
    'provider_parent_table_field': 'source_table',
    'type': 'dropdown'
  },
  'reference_consumer_column': {
    'display_name': 'Consumer join column',
    'description': 'Which consumer col do you want to join on',
    'references': ['CONSUMER_COLUMNS'],
    'consumer_parent_table_field': 'my_table',
    'type': 'dropdown'
  }

-- Example 17369
SELECT COUNT(*) AS cnt_agg FROM identifier({{ source_table[0] }}) AS P
  JOIN IDENTIFIER ({{ my_table[0] }}) AS C
  ON p.{{ reference_provider_join | sqlsafe }} = c.{{ reference_consumer_join | sqlsafe }};

-- Example 17370
SELECT COUNT(*) AS cnt_agg FROM identifier({{ source_table[0] }}) AS P
  JOIN IDENTIFIER ({{ my_table[0] }}) AS C
  ON {{ reference_provider_join | sqlsafe }} = {{ reference_consumer_join | sqlsafe }};

-- Example 17371
'reference_provider_join': {
    'display_name': 'Provider join column',
    'description': 'Which provider col do you want to join on',
    'references': ['PROVIDER_JOIN_POLICY'],
    'provider_parent_table_field': 'source_table',
    'type': 'dropdown'
  },
  'reference_consumer_column': {
    'display_name': 'Consumer join column',
    'description': 'Which consumer col do you want to join on',
    'references': ['CONSUMER_COLUMNS'],
    'consumer_parent_table_field': 'my_table',
    'type': 'dropdown'
  }

-- Example 17372
SELECT COUNT(*) AS cnt_agg FROM identifier({{ source_table[0] }}) AS P
  JOIN IDENTIFIER ({{ my_table[0] }}) AS C
  ON p.{{ reference_provider_join | sqlsafe }} = c.{{ reference_consumer_join | sqlsafe }};

-- Example 17373
SELECT COUNT(*) AS cnt_agg FROM identifier({{ source_table[0] }}) AS P
  JOIN IDENTIFIER ({{ my_table[0] }}) AS C
  ON {{ reference_provider_join | sqlsafe }} = {{ reference_consumer_join | sqlsafe }};

-- Example 17374
from tensorflow.keras.models import Sequential ModuleNotFoundError: No module named 'tensorflow.keras' in function

-- Example 17375
from tensorflow.keras.models import Sequential ModuleNotFoundError: No module named 'tensorflow.keras' in function

-- Example 17376
ALTER TASK [ IF EXISTS ] <name> REMOVE WHEN

-- Example 17377
ALTER TASK [ IF EXISTS ] <name> REMOVE WHEN

-- Example 17378
SELECT COUNT(* ILIKE 'col1%') FROM mytable;

-- Example 17379
SELECT OBJECT_CONSTRUCT(* EXCLUDE col1) AS oc FROM mytable;

-- Example 17380
SELECT {* ILIKE 'col1%'} FROM mytable;

SELECT {* EXCLUDE col1} FROM mytable;

-- Example 17381
ALTER { REPLICATION | FAILOVER } GROUP <name>
    SET TAG <tag_name> = '<tag_value>' [ , <tag_name>= '<tag_value>' … ]

ALTER { REPLICATION | FAILOVER } GROUP <name>
    UNSET TAG <tag_name> [ , <tag_name> … ]

CREATE [ OR REPLACE ] { REPLICATION | FAILOVER } GROUP <name>
    ...
    ...
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17382
ALTER { REPLICATION | FAILOVER } GROUP <name>
    SET TAG <tag_name> = '<tag_value>' [ , <tag_name>= '<tag_value>' … ]

ALTER { REPLICATION | FAILOVER } GROUP <name>
    UNSET TAG <tag_name> [ , <tag_name> … ]

CREATE [ OR REPLACE ] { REPLICATION | FAILOVER } GROUP <name>
    ...
    ...
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 17383
SELECT {*} FROM my_table;

-- Example 17384
SELECT {*} FROM my_table;

-- Example 17385
COPY INTO table1 FROM @stage1
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
INCLUDE_METADATA = (
    ingestdate = METADATA$START_SCAN_TIME, filename = METADATA$FILENAME);

-- Example 17386
+-----+-----------------------+---------------------------------+-----+
| ... | FILENAME              | INGESTDATE                      | ... |
|---------------------------------------------------------------+-----|
| ... | example_file.json.gz  | Thu, 22 Feb 2024 19:14:55 +0000 | ... |
+-----+-----------------------+---------------------------------+-----+

-- Example 17387
COPY INTO table1 FROM @stage1
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
INCLUDE_METADATA = (
    ingestdate = METADATA$START_SCAN_TIME, filename = METADATA$FILENAME);

-- Example 17388
+-----+-----------------------+---------------------------------+-----+
| ... | FILENAME              | INGESTDATE                      | ... |
|---------------------------------------------------------------+-----|
| ... | example_file.json.gz  | Thu, 22 Feb 2024 19:14:55 +0000 | ... |
+-----+-----------------------+---------------------------------+-----+

-- Example 17389
SELECT PARSE_IP('1.1.1', 'inet');
SELECT PARSE_IP('1::abcde', 'inet');

-- Example 17390
SELECT SPLIT_PART('/a/b/c/', '/', -1);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -1) |
|--------------------------------|
| c                              |
+--------------------------------+

SELECT SPLIT_PART('/a/b/c/', '/', -2);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -2) |
|--------------------------------|
| b                              |
+--------------------------------+

-- Example 17391
SELECT SPLIT_PART('/a/b/c/', '/', -1);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -1) |
|--------------------------------|
|                               |
+--------------------------------+

SELECT SPLIT_PART('/a/b/c/', '/', -2);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -2) |
|--------------------------------|
| c                              |
+--------------------------------+

-- Example 17392
SELECT PARSE_IP('1.1.1', 'inet');
SELECT PARSE_IP('1::abcde', 'inet');

-- Example 17393
SELECT SPLIT_PART('/a/b/c/', '/', -1);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -1) |
|--------------------------------|
| c                              |
+--------------------------------+

SELECT SPLIT_PART('/a/b/c/', '/', -2);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -2) |
|--------------------------------|
| b                              |
+--------------------------------+

-- Example 17394
SELECT SPLIT_PART('/a/b/c/', '/', -1);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -1) |
|--------------------------------|
|                               |
+--------------------------------+

SELECT SPLIT_PART('/a/b/c/', '/', -2);

+--------------------------------+
| SPLIT_PART('/A/B/C/', '/', -2) |
|--------------------------------|
| c                              |
+--------------------------------+

-- Example 17395
SELECT emp_id,
       name,
       dept,
FROM employees;

-- Example 17396
SELECT emp_id,
       name,
       dept,
FROM employees;

-- Example 17397
SELECT SYSTEM$ENABLE_BEHAVIOR_CHANGE_BUNDLE('2024_02');

