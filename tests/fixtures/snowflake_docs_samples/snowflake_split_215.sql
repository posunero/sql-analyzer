-- Example 14385
snow stage create new_stage

-- Example 14386
+-----------------------------------------------------+
| key    | value                                      |
|--------+--------------------------------------------|
| status | Stage area NEW_STAGE successfully created. |
+-----------------------------------------------------+

-- Example 14387
# stage that already exists
snow stage create packages

-- Example 14388
+--------------------------------------------------------+
| key    | value                                         |
|--------+-----------------------------------------------|
| status | PACKAGES already exists, statement succeeded. |
+--------------------------------------------------------+

-- Example 14389
snow stage copy <source_path> <destination_path>

-- Example 14390
test_case.py
tests/abc.py
tests/test1/x1.txt
tests/test1/x2.txt

-- Example 14391
test_case.py
abc.py
x1.txt
x2.txt

-- Example 14392
snow stage copy local_example_app @example_app_stage/app

-- Example 14393
put file:///.../local_example_app/* @example_app_stage/app4 auto_compress=false parallel=4 overwrite=False
+--------------------------------------------------------------------------------------
| source           | target           | source_size | target_size | source_compression...
|------------------+------------------+-------------+-------------+--------------------
| environment.yml  | environment.yml  | 62          | 0           | NONE             ...
| snowflake.yml    | snowflake.yml    | 252         | 0           | NONE             ...
| streamlit_app.py | streamlit_app.py | 109         | 0           | NONE             ...
+--------------------------------------------------------------------------------------

-- Example 14394
snow stage list-files example_app_stage

-- Example 14395
ls @example_app_stage
​+------------------------------------------------------------------------------------
| name                                   | size | md5                              | ...
|----------------------------------------+------+----------------------------------+-
| example_app_stage/app/environment.yml  | 64   | 45409c8da098125440bfb7ffbcd900f5 | ...
| example_app_stage/app/snowflake.yml    | 256  | a510b1d59fa04f451b679d43c703b6d4 | ...
| example_app_stage/app/streamlit_app.py | 112  | e6c2a89c5a164e34a0faf60b086bbdfc | ...
+------------------------------------------------------------------------------------

-- Example 14396
mkdir local_app_backup
snow stage copy @example_app_stage/app local_app_backup

-- Example 14397
get @example_app_stage/app file:///.../local_app_backup/ parallel=4
+------------------------------------------------+
| file             | size | status     | message |
|------------------+------+------------+---------|
| environment.yml  | 62   | DOWNLOADED |         |
| snowflake.yml    | 252  | DOWNLOADED |         |
| streamlit_app.py | 109  | DOWNLOADED |         |
+------------------------------------------------+

-- Example 14398
ls local_app_backup

-- Example 14399
environment.yml  snowflake.yml    streamlit_app.py

-- Example 14400
snow stage copy "@~" . --recursive

-- Example 14401
+------------------------------------------------+
| file             | size | status     | message |
|------------------+------+------------+---------|
| environment.yml  | 62   | DOWNLOADED |         |
| snowflake.yml    | 252  | DOWNLOADED |         |
| streamlit_app.py | 109  | DOWNLOADED |         |
+------------------------------------------------+

-- Example 14402
snow stage copy "testdir/*.txt" @TEST_STAGE_3

-- Example 14403
put file:///.../testdir/*.txt @TEST_STAGE_3 auto_compress=false parallel=4 overwrite=False
+------------------------------------------------------------------------------------------------------------+
| source | target | source_size | target_size | source_compression | target_compression | status   | message |
|--------+--------+-------------+-------------+--------------------+--------------------+----------+---------|
| b1.txt | b1.txt | 3           | 16          | NONE               | NONE               | UPLOADED |         |
| b2.txt | b2.txt | 3           | 16          | NONE               | NONE               | UPLOADED |         |
+------------------------------------------------------------------------------------------------------------+

-- Example 14404
snow stage list-files <stage_path>

-- Example 14405
snow stage list-files packages

-- Example 14406
ls @packages
+-------------------------------------------------------------------------------------
| name                 | size     | md5                              | last_modified
|----------------------+----------+----------------------------------+----------------
| packages/plp.Ada.zip | 824736   | 90639175a0ac7735e67525118b81047c | Tue, 16 Jan ...
| packages/samrand.zip | 13721024 | 648f0bae2f65fd4c9f178b17c23de7e5 | Tue, 16 Jan ...
+-------------------------------------------------------------------------------------

-- Example 14407
snow stage execute <stage_path>

-- Example 14408
snow stage execute "@scripts"

-- Example 14409
SUCCESS - scripts/script1.sql
SUCCESS - scripts/script2.sql
SUCCESS - scripts/dir/script.sql
+------------------------------------------+
| File                   | Status  | Error |
|------------------------+---------+-------|
| scripts/script1.sql    | SUCCESS | None  |
| scripts/script2.sql    | SUCCESS | None  |
| scripts/dir/script.sql | SUCCESS | None  |
+------------------------------------------+

-- Example 14410
snow stage execute "@~/script1.sql"

-- Example 14411
SUCCESS - scripts/script1.sql
+------------------------------------------+
| File                   | Status  | Error |
|------------------------+---------+-------|
| @~/script.sql          | SUCCESS | None  |
+------------------------------------------+

-- Example 14412
snow stage execute "@scripts/dir/*"

-- Example 14413
SUCCESS - scripts/dir/script.sql
+------------------------------------------+
| File                   | Status  | Error |
|------------------------+---------+-------|
| scripts/dir/script.sql | SUCCESS | None  |
+------------------------------------------+

-- Example 14414
snow stage execute "@scripts/script?.sql"

-- Example 14415
SUCCESS - scripts/script1.sql
SUCCESS - scripts/script2.sql
+---------------------------------------+
| File                | Status  | Error |
|---------------------+---------+-------|
| scripts/script1.sql | SUCCESS | None  |
| scripts/script2.sql | SUCCESS | None  |
+---------------------------------------+

-- Example 14416
snow stage execute "@scripts/script1.sql" --silent

-- Example 14417
+---------------------------------------+
| File                | Status  | Error |
|---------------------+---------+-------|
| scripts/script1.sql | SUCCESS | None  |
+---------------------------------------+

-- Example 14418
snow stage remove <stage_name> <file_name>

-- Example 14419
snow stage remove example_app_stage app/pages/my_page.py

-- Example 14420
+-------------------------------------------------+
| key    | value                                  |
|--------+----------------------------------------|
| name   | example_app_stage/app/pages/my_page.py |
| result | removed                                |
+-------------------------------------------------+

-- Example 14421
snow notebook create MY_NOTEBOOK -f @MY_STAGE/path/to/notebook.ipynb

-- Example 14422
definition_version: 2
entities:
  my_notebook:
    type: notebook
    query_warehouse: xsmall
    notebook_file: notebook.ipynb
    artifacts:
    - notebook.ipynb
    - data.csv

-- Example 14423
identifier: my-notebook-id

-- Example 14424
identifier:
  name: my-notebook-id
  schema: my-schema # optional
  database: my-db # optional

-- Example 14425
snow notebook deploy my_notebook

-- Example 14426
Uploading artifacts to @notebooks/my_notebook
  Creating stage notebooks if not exists
  Uploading artifacts
Creating notebook my_notebook
Notebook successfully deployed and available under https://snowflake.com/provider-deduced-from-connection/#/notebooks/DB.SCHEMA.MY_NOTEBOOK

-- Example 14427
snow notebook execute MY_NOTEBOOK

-- Example 14428
Notebook MY_NOTEBOOK executed.

-- Example 14429
snow sql -q "SELECT * FROM FOO"

-- Example 14430
snow sql -f my_query.sql

-- Example 14431
snow sql  -q "select 'a', 'b'; select 'c', 'd';"

-- Example 14432
select 'a', 'b';
+-----------+
| 'A' | 'B' |
|-----+-----|
| a   | b   |
+-----------+

select 'c', 'd';
+-----------+
| 'C' | 'D' |
|-----+-----|
| c   | d   |
+-----------+

-- Example 14433
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

-- Example 14434
snow sql -q "select * from <% database %>.logs" -D "database=dev"

-- Example 14435
snow sql \
-q "grant usage on database <% database %> to <% role %>" \
-D "database=dev" \
-D "role=eng_rl"

-- Example 14436
grant usage on database dev to eng_rl

-- Example 14437
snow sql -q "grant usage on database <% ctx.env.database %> to <% ctx.env.role %>"

-- Example 14438
snow sql -q '!source my_sql_code.sql'

-- Example 14439
select emp_id FROM employees;
!source code_file_2.sql

-- Example 14440
cat code_to_execute.sql

-- Example 14441
select 73;

-- Example 14442
snow sql -q '!source code_to_execute.sql'

-- Example 14443
select 73;
+----+
| 73 |
|----|
| 73 |
+----+

-- Example 14444
snow sql -q '!source https://trusted-host/trusted-content.sql'

-- Example 14445
select 73;
+----+
| 73 |
|----|
| 73 |
+----+

-- Example 14446
cat code_with_variable.sql

-- Example 14447
select '<% ctx.env.Message %>';

-- Example 14448
snow sql -q '!source code_&value.sql;' -D value=with_variable --env Message='Welcome !'

-- Example 14449
select 'Welcome !';
+-------------+
| 'WELCOME !' |
|-------------|
| Welcome !   |
+-------------+

-- Example 14450
env:
  SNOWFLAKE_PRIVATE_KEY_RAW: ${{ secrets.SNOWFLAKE_PRIVATE_KEY_RAW }}
  SNOWFLAKE_ACCOUNT: ${{ secrets.SNOWFLAKE_ACCOUNT }}

-- Example 14451
- uses: snowflakedb/snowflake-cli-action@v1.5
  with:
    cli-version: "3.6.0"

