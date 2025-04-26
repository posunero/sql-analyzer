-- Example 27847
get_custom_package_version:
  handler: "functions.get_custom_package_version"
  signature: ""
  returns: string
  type: function
  imports:
    - "@packages/july.zip"
  meta:
    use_mixins:
      - snowpark_shared

-- Example 27848
# functions.py
import july

def get_custom_package_version():
  return july.__VERSION__

-- Example 27849
snow notebook create
  <identifier>
  --notebook-file <notebook_file>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27850
snow notebook create MY_NOTEBOOK -f @MY_STAGE/path/to/notebook.ipynb

-- Example 27851
snow notebook deploy
  <entity_id>
  --replace
  --prune
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent
  --enhanced-exit-codes

-- Example 27852
snow notebook deploy my_notebook

-- Example 27853
Uploading artifacts to @notebooks/my_notebook
  Creating stage notebooks if not exists
  Uploading artifacts
Creating notebook my_notebook
Notebook successfully deployed and available under https://snowflake.com/provider-deduced-from-connection/#/notebooks/DB.SCHEMA.MY_NOTEBOOK

-- Example 27854
snow notebook execute
  <identifier>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27855
snow notebook execute MY_NOTEBOOK

-- Example 27856
Notebook MY_NOTEBOOK executed.

-- Example 27857
snow notebook get-url
  <identifier>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27858
snow notebook get-url database.schema.my_notebook

-- Example 27859
snow notebook open
  <identifier>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent

-- Example 27860
snow notebook open database.schema.my_notebook

-- Example 27861
snow sql
  --query <query>
  --filename <files>
  --stdin
  --variable <data_override>
  --retain-comments
  --project <project_definition>
  --env <env_overrides>
  --connection <connection>
  --host <host>
  --port <port>
  --account <account>
  --user <user>
  --password <password>
  --authenticator <authenticator>
  --private-key-file <private_key_file>
  --token-file-path <token_file_path>
  --database <database>
  --schema <schema>
  --role <role>
  --warehouse <warehouse>
  --temporary-connection
  --mfa-passcode <mfa_passcode>
  --enable-diag
  --diag-log-path <diag_log_path>
  --diag-allowlist-path <diag_allowlist_path>
  --format <format>
  --verbose
  --debug
  --silent
  --enhanced-exit-codes

-- Example 27862
snow sql -q "select * from my-database order by <% column_name %>" -D "column_name=Country"

-- Example 27863
EXECUTE IMMEDIATE $$
-- Snowflake Scripting code
DECLARE
  radius_of_circle FLOAT;
  area_of_circle FLOAT;
BEGIN
  radius_of_circle := 3;
  area_of_circle := pi() * radius_of_circle * radius_of_circle;
  RETURN area_of_circle;
END;
$$
;

-- Example 27864
snow sql --enhanced-exit-codes -q 'select 1' -f my.query

echo $?

-- Example 27865
2

-- Example 27866
snow sql --enhanced-exit-codes -q 'slect 1'

echo $?

-- Example 27867
5

-- Example 27868
snow sql --enhanced-exit-codes -q 'slect 1'

echo $?

-- Example 27869
1

-- Example 27870
snow sql --query 'SELECT SYSTEM$CLIENT_VERSION_INFO();'

-- Example 27871
select current_version();
+-------------------+
| CURRENT_VERSION() |
|-------------------|
| 8.25.1            |
+-------------------+

-- Example 27872
snow sql -q "select * from <% database %>.logs" -D "database=dev"

-- Example 27873
snow sql -q "select '<% ctx.env.test %>'" --env test=value_from_cli

-- Example 27874
select 'column1';
-- My comment
select 'column2';

-- Example 27875
snow sql -f example.sql --retain-comments

-- Example 27876
select 'column1';
+-----------+
| 'COLUMN1' |
|-----------|
| ABC       |
+-----------+

-- My comment
select 'bar';
+-----------+
| 'COLUMN2' |
|-----------|
| 123       |
+-----------+

-- Example 27877
snow git setup <REPO_NAME>

-- Example 27878
$ snow git setup snowcli_git
Origin url: https://github.com/snowflakedb/snowflake-cli.git
Use secret for authentication? [y/N]: y
Secret identifier (will be created if not exists) [snowcli_git_secret]: new_secret
Secret 'new_secret' will be created
username: john_doe
password/token: ****
API integration identifier (will be created if not exists) [snowcli_git_api_integration]:

-- Example 27879
Secret 'new_secret' successfully created.
API integration snowcli_git_api_integration successfully created.
+------------------------------------------------------+
| status                                               |
|------------------------------------------------------|
| Git Repository SNOWCLI_GIT was successfully created. |
+------------------------------------------------------+

-- Example 27880
$ snow git setup snowcli_git
Origin url: https://github.com/snowflakedb/snowflake-cli.git
Use secret for authentication [y/N]: n
API integration identifier (will be created if not exists) [snowcli_git_api_integration]: EXISTING_INTEGRATION

-- Example 27881
Using existing API integration 'EXISTING_INTEGRATION'.
+------------------------------------------------------+
| status                                               |
|------------------------------------------------------|
| Git Repository SNOWCLI_GIT was successfully created. |
+------------------------------------------------------+

-- Example 27882
003001 (42501): 01b2f095-0508-c66d-0001-c1be009a66ee: SQL access control error: Insufficient privileges to operate on account XXX

-- Example 27883
snow git fetch <REPO_NAME>

-- Example 27884
snow git fetch my_snow_git

-- Example 27885
alter Git repository my_snow_git fetch
+-------------------------------------------------------------------+
| status                                                            |
|-------------------------------------------------------------------|
| Git Repository MY_SNOW_GIT is up to date. No change was fetched.. |
+-------------------------------------------------------------------+

-- Example 27886
snow git list-branches <REPO_NAME>

-- Example 27887
snow git list-branches my_snow_git

-- Example 27888
show git branches in my_snow_git
+--------------------------------------------------------------------------------------------------------------------------------------------+
| name                                     | path                                     | checkouts | commit_hash                              |
|------------------------------------------+------------------------------------------+-----------+------------------------------------------|
| SNOW-1011750-service-create-options      | /branches/SNOW-1011750-service-create-op |           | 729855df0104c8d0ef1c7a3e8f79fe50c6c8d2fa |
|                                          | tions                                    |           |                                          |
| SNOW-1011775-containers-to-spcs-int-test | /branches/SNOW-1011775-containers-to-spc |           | e81b00de6b0eb73a99a7baaa39b0afa5ea1202d0 |
| s                                        | s-int-tests                              |           |                                          |
| SNOW-1105629-git-integration-tests       | /branches/SNOW-1105629-git-integration-t |           | 712b07b5e692624c34caabe07d64801615ce5f0f |
+--------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27889
snow git list-tags <REPO_NAME>

-- Example 27890
snow git list-tags my_snow_git

-- Example 27891
show git tags in my_snow_git
+--------------------------------------------------------------------------------------------------------------+
| name           | path                 | commit_hash                 | author                       | message |
|----------------+----------------------+-----------------------------+------------------------------+---------|
| v2.0.0rc3      | /tags/v2.0.0rc3      | 2b019d2841da823d8001f23c6f3 | None                         | None    |
|                |                      | 064e5899142a0               |                              |         |
| v2.1.0-rc0     | /tags/v2.1.0-rc0     | 829887b758b43b86959611dd612 | None                         | None    |
|                |                      | 7638da75cf871               |                              |         |
| v2.1.0-rc1     | /tags/v2.1.0-rc1     | b7efe1fe9c0925b95ba214e233b | None                         | None    |
|                |                      | 18924fa0404b3               |                              |         |
+--------------------------------------------------------------------------------------------------------------+

-- Example 27892
snow git list-files <REPO_PATH>

-- Example 27893
snow git list-files @my_snow_git/tags/v2.0.0/

-- Example 27894
ls @snowcli_git/tags/v2.0.0/
+---------------------------------------------------------------------------------------------------------------------------------+
| name                                    | size | md5  | sha1                                     | last_modified                |
|-----------------------------------------+------+------+------------------------------------------+------------------------------|
| snowcli_git/tags/v2.0.0/CONTRIBUTING.md | 5472 | None | 1cc437b88d20afe4d5751bd576114e3b20be27ea | Mon, 5 Feb 2024 13:16:25 GMT |
| snowcli_git/tags/v2.0.0/LEGAL.md        | 251  | None | 4453da50b7a2222006289ff977bfb23583657214 | Mon, 5 Feb 2024 13:16:25 GMT |
| snowcli_git/tags/v2.0.0/README.md       | 1258 | None | bdc918baae93467c258c6634c872ca6bd4ee1e9c | Mon, 5 Feb 2024 13:16:25 GMT |
| snowcli_git/tags/v2.0.0/SECURITY.md     | 308  | None | 27e7e1b2fd28a86943b3f4c0a35a931577422389 | Mon, 5 Feb 2024 13:16:25 GMT |
| ...
+---------------------------------------------------------------------------------------------------------------------------------+

-- Example 27895
snow git list-files @my_snow_git/tags/v2.0.0/tests --pattern ".*\.toml"

-- Example 27896
ls @snowcli_git/tags/v2.0.0/tests pattern = '.*\.toml'
+-----------------------------------------------------------------------------------------------------------------------------------------+
| name                                            | size | md5  | sha1                                     | last_modified                |
|-------------------------------------------------+------+------+------------------------------------------+------------------------------|
| snowcli_git/tags/v2.0.0/tests/empty_config.toml | 0    | None | e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 | Mon, 5 Feb 2024 13:16:25 GMT |
| snowcli_git/tags/v2.0.0/tests/test.toml         | 381  | None | 45f1c00f16eba1b7bc7b4ab2982afe95d0161e7f | Mon, 5 Feb 2024 13:16:25 GMT |
+-----------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27897
snow git copy <REPO_PATH> <DEST_PATH> [--parallel INT]

-- Example 27898
snow git copy @my_snow_git/tags/v2.0.0/ @public/snowcli2.0/

-- Example 27899
snow git copy @my_snow_git/branches/main/tests/plugin/ @test_stage/plugin_tests/

-- Example 27900
snow git copy @snowcli_git/branches/main/tests/plugin @test_stage/plugin_tests

-- Example 27901
snow git copy @snowcli_git/branches/main/tests/plugin plugin_tests/

-- Example 27902
snow git execute <REPO_PATH> [--silent]

-- Example 27903
snow git execute "@git_test/branches/main/projects/script?.sql"

-- Example 27904
SUCCESS - git_test/branches/main/projects/script1.sql
SUCCESS - git_test/branches/main/projects/script2.sql
SUCCESS - git_test/branches/main/projects/script3.sql
+---------------------------------------------------------------+
| File                                        | Status  | Error |
|---------------------------------------------+---------+-------|
| git_test/branches/main/projects/script1.sql | SUCCESS | None  |
| git_test/branches/main/projects/script2.sql | SUCCESS | None  |
| git_test/branches/main/projects/script3.sql | SUCCESS | None  |
+---------------------------------------------------------------+

-- Example 27905
snow git execute "@git_test/branches/main/projects/script?.sql" --silent

-- Example 27906
+---------------------------------------------------------------+
| File                                        | Status  | Error |
|---------------------------------------------+---------+-------|
| git_test/branches/main/projects/script1.sql | SUCCESS | None  |
| git_test/branches/main/projects/script2.sql | SUCCESS | None  |
| git_test/branches/main/projects/script3.sql | SUCCESS | None  |
+---------------------------------------------------------------+

-- Example 27907
snow [<resource-commands>]
  --version
  --info
  --config-file <configuration_file>
  --install-completion
  --show-completion
  --help

-- Example 27908
snow --version

-- Example 27909
Snowflake CLI version: 3.0.0

-- Example 27910
snow --info

-- Example 27911
[
  {
      "key": "version",
      "value": "3.2.0"
  },
  {
      "key": "default_config_file_path",
      "value": "<user-home>/.snowflake/config.toml"
  },
  {
      "key": "python_version",
      "value": "3.11.6 (v3.11.6:8b6ee5ba3b, Oct  2 2023, 11:18:21) [Clang 13.0.0 (clang-1300.0.29.30)]"
  },
  {
      "key": "system_info",
      "value": "macOS-14.4.1-x86_64-i386-64bit"
  },
  {
      "key": "feature_flags",
      "value": {}
  },
  {
      "key": "SNOWFLAKE_HOME",
      "value": null
  }
]

-- Example 27912
snow --help

-- Example 27913
Usage: snow [OPTIONS] COMMAND [ARGS]...

Snowflake CLI tool for developers.

╭─ Options ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --version                           Shows version of the Snowflake CLI                                                                   │
│ --info                              Shows information about the Snowflake CLI                                                            │
│ --config-file                 FILE  Specifies Snowflake CLI configuration file that should be used [default: None]                       │
│ --install-completion                Install completion for the current shell.                                                            │
│ --show-completion                   Show completion for the current shell, to copy it or customize the installation.                     │
│ --help                -h            Show this message and exit.                                                                          │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ app          Manages a Snowflake Native App                                                                                              │
│ connection   Manages connections to Snowflake.                                                                                           │
│ cortex       Provides access to Snowflake Cortex.                                                                                        │
│ git          Manages git repositories in Snowflake.                                                                                      │
│ notebook     Manages notebooks in Snowflake.                                                                                             │
│ object       Manages Snowflake objects like warehouses and stages                                                                        │
│ snowpark     Manages procedures and functions.                                                                                           │
│ spcs         Manages Snowpark Container Services compute pools, services, image registries, and image repositories.                      │
│ sql          Executes Snowflake query.                                                                                                   │
│ stage        Manages stages.                                                                                                             │
│ streamlit    Manages a Streamlit app in Snowflake.                                                                                       │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

