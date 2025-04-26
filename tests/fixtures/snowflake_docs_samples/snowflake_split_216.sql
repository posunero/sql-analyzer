-- Example 14452
- name: Execute Snowflake CLI command
  env:
    PRIVATE_KEY_PASSPHRASE: ${{ secrets.PASSPHARSE }}

-- Example 14453
- name: Execute Snowflake CLI command
  env:
    SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_USER }}
    SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
    SNOWFLAKE_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}

-- Example 14454
run: |
  snow --version
  snow connection test --temporary-connection

-- Example 14455
name: deploy
on: [push]

jobs:
  version:
    name: "Check Snowflake CLI version"
    runs-on: ubuntu-latest
    steps:
      # Snowflake CLI installation
      - uses: snowflakedb/snowflake-cli-action@v1.5

        # Use the CLI
      - name: Execute Snowflake CLI command
        env:
          SNOWFLAKE_AUTHENTICATOR: SNOWFLAKE_JWT
          SNOWFLAKE_USER: ${{ secrets.SNOWFLAKE_USER }}
          SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_PRIVATE_KEY_RAW: ${{ secrets.SNOWFLAKE_PRIVATE_KEY_RAW }}
          PRIVATE_KEY_PASSPHRASE: ${{ secrets.PASSPHARSE }} # Passphrase is only necessary if private key is encrypted.
        run: |
          snow --help
          snow connection test -x

-- Example 14456
default_connection_name = "myconnection"

[connections.myconnection]

-- Example 14457
env:
  SNOWFLAKE_CONNECTIONS_MYCONNECTION_PRIVATE_KEY_RAW: ${{ secrets.SNOWFLAKE_PRIVATE_KEY_RAW }}
  SNOWFLAKE_CONNECTIONS_MYCONNECTION_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}

-- Example 14458
- uses: snowflakedb/snowflake-cli-action@v1.5
  with:
    cli-version: "3.6.0"
    default-config-file-path: "config.toml"

-- Example 14459
- name: Execute Snowflake CLI command
  env:
    PRIVATE_KEY_PASSPHRASE: ${{ secrets.PASSPHARSE }}

-- Example 14460
- name: Execute Snowflake CLI command
  env:
    SNOWFLAKE_CONNECTIONS_MYCONNECTION_USER: ${{ secrets.SNOWFLAKE_USER }}
    SNOWFLAKE_CONNECTIONS_MYCONNECTION_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
    SNOWFLAKE_CONNECTIONS_MYCONNECTION_PASSWORD: ${{ secrets.SNOWFLAKE_PASSWORD }}

-- Example 14461
run: |
  snow --version
  snow connection test

-- Example 14462
default_connection_name = "myconnection"

[connections.myconnection]

-- Example 14463
name: deploy
on: [push]
jobs:
  version:
    name: "Check Snowflake CLI version"
    runs-on: ubuntu-latest
    steps:
      # Checkout step is necessary if you want to use a config file from your repo
      - name: Checkout repo
        uses: actions/checkout@v4
        with:
          persist-credentials: false

        # Snowflake CLI installation
      - uses: snowflakedb/snowflake-cli-action@v1.5
        with:
          default-config-file-path: "config.toml"

        # Use the CLI
      - name: Execute Snowflake CLI command
        env:
          SNOWFLAKE_CONNECTIONS_MYCONNECTION_AUTHENTICATOR: SNOWFLAKE_JWT
          SNOWFLAKE_CONNECTIONS_MYCONNECTION_USER: ${{ secrets.SNOWFLAKE_USER }}
          SNOWFLAKE_CONNECTIONS_MYCONNECTION_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}
          SNOWFLAKE_CONNECTIONS_MYCONNECTION_PRIVATE_KEY_RAW: ${{ secrets.SNOWFLAKE_PRIVATE_KEY_RAW }}
          PRIVATE_KEY_PASSPHRASE: ${{ secrets.PASSPHARSE }} #Passphrase is only necessary if private key is encrypted.
        run: |
          snow --help
          snow connection test

-- Example 14464
CREATE DATABASE example_db;
USE DATABASE example_db;
CREATE SCHEMA example_schema;
USE SCHEMA example_schema;

CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');

-- Example 14465
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
  df = session.table(table_name)
  return df.filter(col("role") == role)

-- Example 14466
$ git add python-handlers/filter.py
$ git commit -m "Adding code to filter by role"
$ git push

-- Example 14467
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 14468
@snowflake_extensions/branches/main/python-handlers/filter.py

-- Example 14469
CREATE OR REPLACE PROCEDURE filter_by_role(tableName VARCHAR, role VARCHAR)
  RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  IMPORTS = ('@example_db.example_schema.snowflake_extensions/branches/main/python-handlers/filter.py')
  HANDLER = 'filter.filter_by_role';

-- Example 14470
CALL filter_by_role('employees', 'dev');

-- Example 14471
---------------------
| ID | NAME  | ROLE |
---------------------
| 2  | Bob   | dev  |
---------------------
| 3  | Cindy | dev  |
---------------------

-- Example 14472
CREATE ROLE analyst;

CREATE USER gladys;

GRANT ROLE analyst TO USER gladys;

SHOW GRANTS TO USER gladys;

-- Example 14473
git add scripts/setup.sql
git commit -m "Adding code to set up new accounts"
git push

-- Example 14474
ALTER GIT REPOSITORY configuration_repo FETCH;

-- Example 14475
EXECUTE IMMEDIATE FROM @configuration_repo/branches/main/scripts/setup.sql;

-- Example 14476
+-------------------------------+---------+------------+--------------+--------------+
| created_on                    | role    | granted_to | grantee_name | granted_by   |
|-------------------------------+---------+------------+--------------+--------------|
| 2023-07-24 22:07:04.354 -0700 | ANALYST | USER       | GLADYS       | ACCOUNTADMIN |
+-------------------------------+---------+------------+--------------+--------------+

-- Example 14477
CREATE DATABASE example_db;
USE DATABASE example_db;
CREATE SCHEMA example_schema;
USE SCHEMA example_schema;

CREATE OR REPLACE TABLE employees(id NUMBER, name VARCHAR, role VARCHAR);
INSERT INTO employees (id, name, role) VALUES (1, 'Alice', 'op'), (2, 'Bob', 'dev'), (3, 'Cindy', 'dev');

-- Example 14478
from snowflake.snowpark.functions import col

def filter_by_role(session, table_name, role):
  df = session.table(table_name)
  return df.filter(col("role") == role)

-- Example 14479
$ git add python-handlers/filter.py
$ git commit -m "Adding code to filter by role"
$ git push

-- Example 14480
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 14481
@snowflake_extensions/branches/main/python-handlers/filter.py

-- Example 14482
CREATE OR REPLACE PROCEDURE filter_by_role(tableName VARCHAR, role VARCHAR)
  RETURNS TABLE(id NUMBER, name VARCHAR, role VARCHAR)
  LANGUAGE PYTHON
  RUNTIME_VERSION = '3.9'
  PACKAGES = ('snowflake-snowpark-python')
  IMPORTS = ('@example_db.example_schema.snowflake_extensions/branches/main/python-handlers/filter.py')
  HANDLER = 'filter.filter_by_role';

-- Example 14483
CALL filter_by_role('employees', 'dev');

-- Example 14484
---------------------
| ID | NAME  | ROLE |
---------------------
| 2  | Bob   | dev  |
---------------------
| 3  | Cindy | dev  |
---------------------

-- Example 14485
CREATE ROLE analyst;

CREATE USER gladys;

GRANT ROLE analyst TO USER gladys;

SHOW GRANTS TO USER gladys;

-- Example 14486
git add scripts/setup.sql
git commit -m "Adding code to set up new accounts"
git push

-- Example 14487
ALTER GIT REPOSITORY configuration_repo FETCH;

-- Example 14488
EXECUTE IMMEDIATE FROM @configuration_repo/branches/main/scripts/setup.sql;

-- Example 14489
+-------------------------------+---------+------------+--------------+--------------+
| created_on                    | role    | granted_to | grantee_name | granted_by   |
|-------------------------------+---------+------------+--------------+--------------|
| 2023-07-24 22:07:04.354 -0700 | ANALYST | USER       | GLADYS       | ACCOUNTADMIN |
+-------------------------------+---------+------------+--------------+--------------+

-- Example 14490
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 14491
SHOW GIT BRANCHES IN snowflake_extensions;

-- Example 14492
--------------------------------------------------------------------------------
| name | path           | checkouts | commit_hash                              |
--------------------------------------------------------------------------------
| main | /branches/main |           | 0f81b1487dfc822df9f73ac6b3096b9ea9e42d69 |
--------------------------------------------------------------------------------

-- Example 14493
LS @repository_stage_name/branches/branch_name;

-- Example 14494
LS @repository_stage_name/tags/tag_name;

-- Example 14495
LS @repository_stage_name/commits/commit_hash;

-- Example 14496
LS @snowflake_extensions/branches/main;

-- Example 14497
-------------------------------------------------------------------------------------------------------------------------------------------------------
| name                                                         | size | md5 | sha1                                     | last_modified                |
-------------------------------------------------------------------------------------------------------------------------------------------------------
| snowflake_extensions/branches/main/.gitignore                | 10   |     | e43b0f988953ae3a84b00331d0ccf5f7d51cb3cf | Wed, 5 Jul 2023 22:42:34 GMT |
-------------------------------------------------------------------------------------------------------------------------------------------------------
| snowflake_extensions/branches/main/python-handlers/filter.py | 169  |     | c717137b18d7b75005849d76d89037fafc7b5223 | Wed, 5 Jul 2023 22:42:34 GMT |
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14498
DESCRIBE GIT REPOSITORY snowflake_extensions;

-- Example 14499
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| CREATED_ON                    | NAME                 | DATABASE_NAME | SCHEMA_NAME | ORIGIN                                                 | API_INTEGRATION     | GIT_CREDENTIALS           | OWNER        | OWNER_ROLE_TYPE | COMMENT |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_EXTENSIONS | MY_DB         | MAIN        | https://github.com/my-account/snowflake-extensions.git | GIT_API_INTEGRATION | MY_DB.MAIN.GIT_SECRET     | ACCOUNTADMIN | ROLE            |         |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14500
EXECUTE IMMEDIATE FROM @snowflake_extensions/branches/main/sql/create-database.sql;

-- Example 14501
CREATE [ OR REPLACE ] GIT REPOSITORY [ IF NOT EXISTS ] <name>
  ORIGIN = '<repository_url>'
  API_INTEGRATION = <integration_name>
  [ GIT_CREDENTIALS = <secret_name> ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 14502
$ git config --get remote.origin.url
https://github.com/mycompany/My-Repo.git

-- Example 14503
CREATE OR REPLACE GIT REPOSITORY snowflake_extensions
  API_INTEGRATION = git_api_integration
  GIT_CREDENTIALS = git_secret
  ORIGIN = 'https://github.com/my-account/snowflake-extensions.git';

-- Example 14504
ALTER GIT REPOSITORY <name> SET
  [ GIT_CREDENTIALS = <secret_name> ]
  [ API_INTEGRATION = <integration_name> ]
  [ COMMENT = '<string_literal>' ]

ALTER GIT REPOSITORY <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER GIT REPOSITORY <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER GIT REPOSITORY <name> UNSET {
  GIT_CREDENTIALS |
  COMMENT }
  [ , ... ]

ALTER GIT REPOSITORY <name> FETCH

-- Example 14505
ALTER GIT REPOSITORY snowflake_extensions FETCH;

-- Example 14506
{ DESC | DESCRIBE } GIT REPOSITORY <name>

-- Example 14507
DESCRIBE GIT REPOSITORY snowflake_extensions;

-- Example 14508
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| CREATED_ON                    | NAME                 | DATABASE_NAME | SCHEMA_NAME | ORIGIN                                                 | API_INTEGRATION     | GIT_CREDENTIALS           | OWNER        | OWNER_ROLE_TYPE | COMMENT |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_EXTENSIONS | MY_DB         | MAIN        | https://github.com/my-account/snowflake-extensions.git | GIT_API_INTEGRATION | MY_DB.MAIN.GIT_SECRET     | ACCOUNTADMIN | ROLE            |         |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14509
DROP GIT REPOSITORY [ IF EXISTS ] <name>

-- Example 14510
DROP GIT REPOSITORY my_repository;

-- Example 14511
+-------------------------------------+
|                status               |
+-------------------------------------+
| MY_REPOSITORY successfully dropped. |
+-------------------------------------+

-- Example 14512
SHOW GIT REPOSITORIES [ LIKE '<pattern>' ]
  [ IN
      {
        ACCOUNT                  |

        DATABASE                 |
        DATABASE <database_name> |

        SCHEMA                   |
        SCHEMA <schema_name>     |
        <schema_name>
      }
  ]

-- Example 14513
SHOW GIT REPOSITORIES;

-- Example 14514
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| CREATED_ON                    | NAME                 | DATABASE_NAME | SCHEMA_NAME | ORIGIN                                                  | API_INTEGRATION     | GIT_CREDENTIALS              | OWNER        | OWNER_ROLE_TYPE | COMMENT |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_EXTENSIONS | MY_DB         | MAIN        | https://github.com/my-account/snowflake-extensions.git  | GIT_API_INTEGRATION | MY_DB.MAIN.EXTENSIONS_SECRET | ACCOUNTADMIN | ROLE            |         |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 2023-06-28 08:46:10.886 -0700 | SNOWFLAKE_AI         | MY_DB         | MAIN        | https://github.com/my-account/snowflake-AI.git          | GIT_API_INTEGRATION | MY_DB.MAIN.AI_SECRET         | ACCOUNTADMIN | ROLE            |         |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Example 14515
SHOW GIT BRANCHES [ LIKE '<pattern>' ] IN [ GIT REPOSITORY ] <repository_name>

-- Example 14516
SHOW GIT BRANCHES IN snowflake_extensions;

-- Example 14517
--------------------------------------------------------------------------------
| name | path           | checkouts | commit_hash                              |
--------------------------------------------------------------------------------
| main | /branches/main |           | 0f81b1487dfc822df9f73ac6b3096b9ea9e42d69 |
--------------------------------------------------------------------------------

-- Example 14518
SHOW GIT TAGS [ LIKE '<pattern>' ] IN [ GIT REPOSITORY ] <repository_name>

