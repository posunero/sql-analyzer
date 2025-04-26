-- Example 12107
ALTER ACCOUNT SET PACKAGES POLICY packages_policy_prod_1 FORCE;

-- Example 12108
ALTER ACCOUNT UNSET PACKAGES POLICY;

-- Example 12109
ALTER NETWORK POLICY [ IF EXISTS ] <name> SET {
    [ ALLOWED_NETWORK_RULE_LIST = ( '<network_rule>' [ , '<network_rule>' , ... ] ) ]
    [ BLOCKED_NETWORK_RULE_LIST = ( '<network_rule>' [ , '<network_rule>' , ... ] ) ]
    [ ALLOWED_IP_LIST = ( [ '<ip_address>' ] [ , '<ip_address>' ... ] ) ]
    [ BLOCKED_IP_LIST = ( [ '<ip_address>' ] [ , '<ip_address>' ... ] ) ]
    [ COMMENT = '<string_literal>' ] }

ALTER NETWORK POLICY [ IF EXISTS ] <name> UNSET COMMENT

ALTER NETWORK POLICY <name> ADD { ALLOWED_NETWORK_RULE_LIST = '<network_rule>' | BLOCKED_NETWORK_RULE_LIST = '<network_rule>' }

ALTER NETWORK POLICY <name> REMOVE { ALLOWED_NETWORK_RULE_LIST = '<network_rule>' | BLOCKED_NETWORK_RULE_LIST = '<network_rule>' }

ALTER NETWORK POLICY <name>  RENAME TO <new_name>

ALTER NETWORK POLICY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER NETWORK POLICY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

-- Example 12110
DESC NETWORK POLICY allow_access_policy;

-- Example 12111
+---------------------------+-------------------+
| name                      | value             |
|---------------------------+-------------------|
| ALLOWED_NETWORK_RULE_LIST | allow_access_rule |
+---------------------------+-------------------+

-- Example 12112
ALTER NETWORK POLICY IF EXISTS allow_access_policy SET
  BLOCKED_NETWORK_RULE_LIST = 'block_access_rule';
DESC NETWORK POLICY allow_access_policy;

-- Example 12113
+---------------------------+-------------------+
| name                      | value             |
|---------------------------+-------------------|
| ALLOWED_NETWORK_RULE_LIST | ALLOW_ACCESS_RULE |
| BLOCKED_NETWORK_RULE_LIST | BLOCK_ACCESS_RULE |
+---------------------------+-------------------+

-- Example 12114
ALTER NETWORK POLICY allow_access_policy RENAME TO limit_access_policy;

-- Example 12115
ALTER NETWORK POLICY limit_access_policy SET COMMENT = 'No_Lists_See_Rules';
SHOW NETWORK POLICIES;

-- Example 12116
+-------------------------------+---------------------+--------------------+----------------------------+----------------------------+----------------------------------+----------------------------------+
| created on                    | name                | comment            | entries_in_allowed_ip_list | entries_in_blocked_ip_list | entries_in_allowed_network_rules | entries_in_blocked_network_rules |
|-------------------------------+------------------------------------------|----------------------------|----------------------------|----------------------------------|----------------------------------|
|...                            |                     |                    |                            |                            |                                  |                                  |
|-------------------------------+------------------------------------------|----------------------------|----------------------------|----------------------------------|----------------------------------|
| 2024-12-04 10:33:19.853 -0800 | LIMIT_ACCESS_POLICY | NO_LISTS_SEE_RULES |                           0|                           0|                                 1|                                 1|
|-------------------------------+------------------------------------------|----------------------------|----------------------------|----------------------------------|----------------------------------|
|...                            |                     |                    |                            |                            |                                  |                                  |
+-------------------------------+---------------------+--------------------+----------------------------+----------------------------+----------------------------------+----------------------------------+

-- Example 12117
DESC[RIBE] USER <name>

-- Example 12118
GRANT USAGE ON DATABASE securitydb TO ROLE network_admin;
GRANT USAGE ON SCHEMA securitydb.myrules TO ROLE network_admin;
GRANT CREATE NETWORK RULE ON SCHEMA securitydb.myrules TO ROLE network_admin;
USE ROLE network_admin;

CREATE NETWORK RULE cloud_network TYPE = IPV4 MODE = INGRESS VALUE_LIST = ('47.88.25.32/27');

-- Example 12119
use role accountadmin;
alter account set ENABLE_INTERNAL_STAGES_PRIVATELINK = true;
select key, value from table(flatten(input=>parse_json(system$get_privatelink_config())));

-- Example 12120
use role accountadmin;
select system$authorize_stage_privatelink_access('<privateEndpointResourceID>');

-- Example 12121
dig <storage_account_name>.blob.core.windows.net

-- Example 12122
SELECT SYSTEM$BLOCK_INTERNAL_STAGES_PUBLIC_ACCESS();

-- Example 12123
use role accountadmin;
alter account set enable_internal_stages_privatelink = false;
select system$revoke_stage_privatelink_access('<privateEndpointResourceID>');

-- Example 12124
dig CNAME <storage_account_name>.privatelink.blob.core.windows.net

-- Example 12125
CREATE [ OR REPLACE ] NETWORK RULE <name>
   TYPE = { IPV4 | AWSVPCEID | AZURELINKID | HOST_PORT | PRIVATE_HOST_PORT }
   VALUE_LIST = ( '<value>' [, '<value>', ... ] )
   MODE = { INGRESS | INTERNAL_STAGE | EGRESS }
   [ COMMENT = '<string_literal>' ]

-- Example 12126
CREATE NETWORK RULE corporate_network
  TYPE = AWSVPCEID
  VALUE_LIST = ('vpce-123abc3420c1931')
  MODE = INTERNAL_STAGE
  COMMENT = 'corporate privatelink endpoint';

-- Example 12127
CREATE NETWORK RULE cloud_network
  TYPE = IPV4
  VALUE_LIST = ('47.88.25.32/27')
  COMMENT ='cloud egress ip range';

-- Example 12128
CREATE NETWORK RULE external_access_rule
  TYPE = HOST_PORT
  MODE = EGRESS
  VALUE_LIST = ('example.com', 'example.com:443');

-- Example 12129
CREATE OR REPLACE NETWORK RULE ext_network_access_db.network_rules.azure_sql_private_rule
  MODE = EGRESS
  TYPE = PRIVATE_HOST_PORT
  VALUE_LIST = ('externalaccessdemo.database.windows.net');

-- Example 12130
ALTER NETWORK RULE [ IF EXISTS ] <name> SET
  VALUE_LIST = ( '<value>'  [ , '<value>', ... ] )
  [ COMMENT = '<string_literal>' ]

ALTER NETWORK RULE [ IF EXISTS ] <name> UNSET { VALUE_LIST | COMMENT }

-- Example 12131
ALTER NETWORK RULE cloud_network SET VALUE_LIST = ('47.88.25.32/27');

-- Example 12132
ALTER NETWORK RULE corporate_network SET VALUE_LIST = ('vpce-123abc3420c1931');

-- Example 12133
ALTER NETWORK RULE external_access_rule SET VALUE_LIST = ('example.com', 'example.com:443');

-- Example 12134
DESC[RIBE] NETWORK POLICY <name>

-- Example 12135
DESC NETWORK POLICY mypolicy;

-- Example 12136
-----------------+---------------+
      name       |     value     |
-----------------+---------------+
 ALLOWED_IP_LIST | 192.168.0.100 |
 BLOCKED_IP_LIST | 192.168.0.101 |
-----------------+---------------+

-- Example 12137
CREATE [ OR REPLACE ] NETWORK POLICY [ IF NOT EXISTS ] <name>
  [ ALLOWED_NETWORK_RULE_LIST = ( '<network_rule>' [ , '<network_rule>' , ... ] ) ]
  [ BLOCKED_NETWORK_RULE_LIST = ( '<network_rule>' [ , '<network_rule>' , ... ] ) ]
  [ ALLOWED_IP_LIST = ( [ '<ip_address>' ] [ , '<ip_address>' , ... ] ) ]
  [ BLOCKED_IP_LIST = ( [ '<ip_address>' ] [ , '<ip_address>' , ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 12138
USE ROLE SECURITYADMIN;

ALTER ACCOUNT SET NETWORK_POLICY = <policy_name>;

-- Example 12139
CREATE NETWORK POLICY allow_vpceid_block_public_policy
  ALLOWED_NETWORK_RULE_LIST = 'allow_vpceid_access'
  BLOCKED_NETWORK_RULE_LIST = 'block_public_access';

DESC NETWORK POLICY rule_based_policy;

-- Example 12140
+---------------------------+---------------------+
| name                      | value               |
|---------------------------+---------------------|
| ALLOWED_NETWORK_RULE_LIST | ALLOW_VPCEID_ACCESS |
+---------------------------+---------------------+
| BLOCKED_NETWORK_RULE_LIST | BLOCK_PUBLIC_ACCESS |
+---------------------------+---------------------+

-- Example 12141
SHOW PARAMETERS
  [ LIKE '<pattern>' ]
  [ { IN | FOR } {
        { SESSION | ACCOUNT }
      | { USER | WAREHOUSE | DATABASE | SCHEMA | TASK } [ <name> ]
      | TABLE [ <table_or_view_name> ]
    } ]

-- Example 12142
SHOW PARAMETERS;

+-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| key                                 | value                            | default                          | level   | description                                                                                                                                                                         |
|-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ABORT_DETACHED_QUERY                | false                            | false                            | SESSION | If true, Snowflake will automatically abort queries when it detects that the client has disappeared.                                                                                |
| AUTOCOMMIT                          | true                             | true                             | SESSION | The autocommit property determines whether is statement should to be implicitly                                                                                                     |
|                                     |                                  |                                  |         | wrapped within a transaction or not. If autocommit is set to true, then a                                                                                                           |
|                                     |                                  |                                  |         | statement that requires a transaction is executed within a transaction                                                                                                              |
|                                     |                                  |                                  |         | implicitly. If autocommit is off then an explicit commit or rollback is required                                                                                                    |
|                                     |                                  |                                  |         | to close a transaction. The default autocommit value is true.                                                                                                                       |
| AUTOCOMMIT_API_SUPPORTED            | true                             | true                             |         | Whether autocommit feature is enabled for this client. This parameter is for                                                                                                        |
|                                     |                                  |                                  |         | Snowflake use only.                                                                                                                                                                 |
| BINARY_INPUT_FORMAT                 | HEX                              | HEX                              |         | input format for binary                                                                                                                                                             |
| BINARY_OUTPUT_FORMAT                | HEX                              | HEX                              |         | display format for binary                                                                                                                                                           |
| CLIENT_SESSION_KEEP_ALIVE           | false                            | false                            |         | If true, client session will not expire automatically                                                                                                                               |
| DATE_INPUT_FORMAT                   | AUTO                             | AUTO                             |         | input format for date                                                                                                                                                               |
| DATE_OUTPUT_FORMAT                  | YYYY-MM-DD                       | YYYY-MM-DD                       |         | display format for date                                                                                                                                                             |
| ERROR_ON_NONDETERMINISTIC_MERGE     | true                             | true                             |         | raise an error when attempting to merge-update a row that joins many rows                                                                                                           |
| ERROR_ON_NONDETERMINISTIC_UPDATE    | false                            | false                            |         | raise an error when attempting to update a row that joins many rows                                                                                                                 |
| LOCK_TIMEOUT                        | 43200                            | 43200                            |         | Number of seconds to wait while trying to lock a resource, before timing out                                                                                                        |
|                                     |                                  |                                  |         | and aborting the statement. A value of 0 turns off lock waiting i.e. the                                                                                                            |
|                                     |                                  |                                  |         | statement must acquire the lock immediately or abort. If multiple resources                                                                                                         |
|                                     |                                  |                                  |         | need to be locked by the statement, the timeout applies separately to each                                                                                                          |
|                                     |                                  |                                  |         | lock attempt.                                                                                                                                                                       |
| QUERY_TAG                           |                                  |                                  |         | String (up to 2000 characters) used to tag statements executed by the session                                                                                                       |
| QUOTED_IDENTIFIERS_IGNORE_CASE      | false                            | false                            |         | If true, the case of quoted identifiers is ignored                                                                                                                                  |
| ROWS_PER_RESULTSET                  | 0                                | 0                                |         | maxium number of rows in a result set                                                                                                                                               |
| STATEMENT_QUEUED_TIMEOUT_IN_SECONDS | 0                                | 0                                |         | Timeout in seconds for queued statements: statements will automatically be canceled if they are queued on a warehouse for longer than this amount of time; disabled if set to zero. |
| STATEMENT_TIMEOUT_IN_SECONDS        | 0                                | 0                                |         | Timeout in seconds for statements: statements will automatically be canceled if they run for longer than this amount of time; disabled if set to zero.                              |
| TIMESTAMP_DAY_IS_ALWAYS_24H         | false                            | true                             | SYSTEM  | If set, arithmetic on days always uses 24 hours per day,                                                                                                                            |
|                                     |                                  |                                  |         | possibly not preserving the time (due to DST changes)                                                                                                                               |
| TIMESTAMP_INPUT_FORMAT              | AUTO                             | AUTO                             |         | input format for timestamp                                                                                                                                                          |
| TIMESTAMP_LTZ_OUTPUT_FORMAT         |                                  |                                  |         | Display format for TIMESTAMP_LTZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                 |
| TIMESTAMP_NTZ_OUTPUT_FORMAT         | YYYY-MM-DD HH24:MI:SS.FF3        | YYYY-MM-DD HH24:MI:SS.FF3        | SYSTEM  | Display format for TIMESTAMP_NTZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                 |
| TIMESTAMP_OUTPUT_FORMAT             | YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM | YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM | SYSTEM  | Default display format for all timestamp types.                                                                                                                                     |
| TIMESTAMP_TYPE_MAPPING              | TIMESTAMP_NTZ                    | TIMESTAMP_NTZ                    | SYSTEM  | If TIMESTAMP type is used, what specific TIMESTAMP* type it should map to:                                                                                                          |
|                                     |                                  |                                  |         |   TIMESTAMP_LTZ (default), TIMESTAMP_NTZ or TIMESTAMP_TZ                                                                                                                            |
| TIMESTAMP_TZ_OUTPUT_FORMAT          |                                  |                                  |         | Display format for TIMESTAMP_TZ values. If empty, TIMESTAMP_OUTPUT_FORMAT is used.                                                                                                  |
| TIMEZONE                            | America/Los_Angeles              | America/Los_Angeles              |         | time zone                                                                                                                                                                           |
| TIME_INPUT_FORMAT                   | AUTO                             | AUTO                             |         | input format for time                                                                                                                                                               |
| TIME_OUTPUT_FORMAT                  | HH24:MI:SS                       | HH24:MI:SS                       |         | display format for time                                                                                                                                                             |
| TRANSACTION_ABORT_ON_ERROR          | false                            | false                            |         | If this parameter is true, and a statement issued within a non-autocommit                                                                                                           |
|                                     |                                  |                                  |         | transaction returns with an error, then the non-autocommit transaction is                                                                                                           |
|                                     |                                  |                                  |         | aborted. All statements issued inside that transaction will fail until an                                                                                                           |
|                                     |                                  |                                  |         | commit or rollback statement is executed to close that transaction.                                                                                                                 |
| TRANSACTION_DEFAULT_ISOLATION_LEVEL | READ COMMITTED                   | READ COMMITTED                   |         | The default isolation level when starting a starting a transaction, when no                                                                                                         |
|                                     |                                  |                                  |         | isolation level was specified                                                                                                                                                       |
| TWO_DIGIT_CENTURY_START             | 1970                             | 1970                             |         | For 2-digit dates, defines a century-start year.                                                                                                                                    |
|                                     |                                  |                                  |         | For example, when set to 1980:                                                                                                                                                      |
|                                     |                                  |                                  |         |   - parsing a string '79' will produce 2079                                                                                                                                         |
|                                     |                                  |                                  |         |   - parsing a string '80' will produce 1980                                                                                                                                         |
| UNSUPPORTED_DDL_ACTION              | ignore                           | ignore                           |         | The action to take upon encountering an unsupported ddl statement                                                                                                                   |
| USE_CACHED_RESULT                   | true                             | true                             |         | If enabled, query results can be reused between successive invocations of the same query as long as the original result has not expired                                             |
+-------------------------------------+----------------------------------+----------------------------------+---------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 12143
SHOW PARAMETERS IN WAREHOUSE testwh;

+-------------------------------------+--------+---------+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| key                                 | value  | default | level | description                                                                                                                                                                                                                   |
|-------------------------------------+--------+---------+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MAX_CONCURRENCY_LEVEL               | 8      | 8       |       | Concurrency level for SQL statements (i.e. queries and DML) executed by a warehouse cluster (used to determine when statements are queued or additional clusters are started). Small SQL statements count as a fraction of 1. |
| STATEMENT_QUEUED_TIMEOUT_IN_SECONDS | 0      | 0       |       | Timeout in seconds for queued statements: statements will automatically be canceled if they are queued on a warehouse for longer than this amount of time; disabled if set to zero.                                           |
| STATEMENT_TIMEOUT_IN_SECONDS        | 172800 | 172800  |       | Timeout in seconds for statements: statements are automatically canceled if they run for longer; if set to zero, max value (604800) is enforced.                                                                              |
+-------------------------------------+--------+---------+-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 12144
USE DATABASE testdb;

SHOW PARAMETERS IN DATABASE;

+-----------------------------+-------+---------+-------+------------------------------------------------------------------+
| key                         | value | default | level | description                                                      |
|-----------------------------+-------+---------+-------+------------------------------------------------------------------|
| DATA_RETENTION_TIME_IN_DAYS | 1     | 1       |       | number of days to retain the old version of deleted/updated data |
+-----------------------------+-------+---------+-------+------------------------------------------------------------------+

-- Example 12145
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

-- Example 12146
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

-- Example 12147
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

-- Example 12148
{
  "objectDomain": STRING,
  "objectName": STRING,
  "objectId": NUMBER,
  "operationType": STRING,
  "properties": ARRAY
}

-- Example 12149
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

-- Example 12150
columns: {
  "email": {
    objectId: {
      "value": 1
    },
    "subOperationType": "ADD"
  }
}

-- Example 12151
UPDATE mydb.s1.t1 SET col_1 = col_1 + 1;

-- Example 12152
UPDATE mydb.s1.t1 FROM mydb.s2.t2 SET t1.col1 = t2.col1;

-- Example 12153
insert into a(c1)
select c2
from b
where c3 > 1;

-- Example 12154
insert into A(col1) select f(col2) from B;

-- Example 12155
CREATE OR REPLACE

ALTER ... { SET | UNSET }

ALTER ... ADD ROW ACCESS POLICY

ALTER ... DROP ROW ACCESS POLICY

ALTER ... DROP ALL ROW ACCESS POLICIES

DROP | UNDROP

-- Example 12156
SELECT * FROM snowflake.organization_usage.access_history
  WHERE provider_base_objects_accessed IS NOT NULL;

-- Example 12157
SELECT * FROM snowflake.organization_usage.metering_daily_history
  WHERE service_type = 'ORGANIZATION_USAGE';

-- Example 12158
SELECT
  SUM(active_bytes + time_travel_bytes + failsafe_bytes + retained_for_clone_bytes) / pow(1000, 4)
    AS org_usage_approx_storage_tb
  FROM snowflake.organization_usage.table_storage_metrics
  WHERE 1=1
    AND table_schema = 'ORGANIZATION_USAGE_LOCAL';

-- Example 12159
SELECT ...
FROM <object_ref1> [
                     {
                       INNER
                       | { LEFT | RIGHT | FULL } [ OUTER ]
                     }
                   ]
                   JOIN <object_ref2>
  [ ON <condition> ]
[ ... ]

-- Example 12160
SELECT *
FROM <object_ref1> [
                     {
                       INNER
                       | { LEFT | RIGHT | FULL } [ OUTER ]
                     }
                   ]
                   JOIN <object_ref2>
  [ USING( <column_list> ) ]
[ ... ]

-- Example 12161
SELECT ...
FROM <object_ref1> [
                     {
                       | NATURAL [ { LEFT | RIGHT | FULL } [ OUTER ] ]
                       | CROSS
                     }
                   ]
                   JOIN <object_ref2>
[ ... ]

-- Example 12162
ON object_ref2.id_number = object_ref1.id_number

-- Example 12163
... o1 JOIN o2
    USING (key_column)

-- Example 12164
... o1 JOIN o2
    ON o2.key_column = o1.key_column

-- Example 12165
SELECT ... FROM my_table
  JOIN TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 12166
SELECT ... FROM my_table
  INNER JOIN TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 12167
SELECT ... FROM my_table
  JOIN TABLE(my_js_udtf(col_a))
  ON ... ;

-- Example 12168
SELECT ... FROM my_table
  INNER JOIN TABLE(my_js_udtf(col_a))
  ON ... ;

-- Example 12169
SELECT ... FROM my_table
  LEFT JOIN TABLE(FLATTEN(input=>[a]))
  ON ... ;

-- Example 12170
SELECT ... FROM my_table
  FULL JOIN TABLE(FLATTEN(input=>[a]))
  ON ... ;

-- Example 12171
SELECT ... FROM my_table
  LEFT JOIN TABLE(my_js_udtf(a))
  ON ... ;

-- Example 12172
SELECT ... FROM my_table
  FULL JOIN TABLE(my_js_udtf(a))
  ON ... ;

-- Example 12173
000002 (0A000): Unsupported feature
  'lateral table function called with OUTER JOIN syntax
   or a join predicate (ON clause)'

