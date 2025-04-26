-- Example 27713
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27714
snow spcs service resume echo_service

-- Example 27715
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27716
snow spcs service list

-- Example 27717
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        |        |        |        |        |        |        |        |        |        |        |         | extern |         |        |         |        |         |        |        |         |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         | al_acc |         |        |         |        |         |        |        |         |        | managin | managi |
|        |        | databa |        |        |        |        | curren | target | min_in | max_in |         | ess_in |         |        |         |        | owner_r | query_ |        |         |        | g_objec | ng_obj |
|        |        | se_nam | schema |        | comput | dns_na | t_inst | _insta | stance | stance | auto_re | tegrat | created | update | resumed | commen | ole_typ | wareho |        | spec_di | is_upg | t_domai | ect_na |
| name   | status | e      | _name  | owner  | e_pool | me     | ances  | nces   | s      | s      | sume    | ions   | _on     | d_on   | _on     | t      | e       | use    | is_job | gest    | rading | n       | me     |
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+---------+--------+---------+--------+---------+--------+---------+--------+--------+---------+--------+---------+--------|
| ECHO_S | RUNNIN | TEST00 | TEST_S | SYSADM | TUTORI | echo-s | 1      | 1      | 1      | 1      | true    | None   | 2024-10 | 2024-1 | None    | This   | ROLE    | COMPUT | false  | 52e62d1 | false  | None    | None   |
| ERVICE | G      | _DB    | CHEMA  | IN     | AL_COM | ervice |        |        |        |        |         |        | -16     | 0-16   |         | is a   |         | E_WH   |        | f19c720 |        |         |        |
|        |        |        |        |        | PUTE_P | .imhd. |        |        |        |        |         |        | 15:09:3 | 15:09: |         | test   |         |        |        | 6b5f4ef |        |         |        |
|        |        |        |        |        | OOL    | svc.sp |        |        |        |        |         |        | 0.49300 | 31.905 |         | servic |         |        |        | c069557 |        |         |        |
|        |        |        |        |        |        | cs.int |        |        |        |        |         |        | 0-07:00 | 000-07 |         | e      |         |        |        | 8b6c2b3 |        |         |        |
|        |        |        |        |        |        | ernal  |        |        |        |        |         |        |         | :00    |         |        |         |        |        | 806ad76 |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 67d78cc |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | ce8b6ed |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 6501a8a |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 3       |        |         |        |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27718
snow spcs service describe echo_service

-- Example 27719
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|        |        |        |        |        |        |        |        |        |        |        |         | extern |         |        |         |        |         |        |        |         |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         | al_acc |         |        |         |        |         |        |        |         |        | managin | managi |
|        |        | databa |        |        |        |        | curren | target | min_in | max_in |         | ess_in |         |        |         |        | owner_r | query_ |        |         |        | g_objec | ng_obj |
|        |        | se_nam | schema |        | comput | dns_na | t_inst | _insta | stance | stance | auto_re | tegrat | created | update | resumed | commen | ole_typ | wareho |        | spec_di | is_upg | t_domai | ect_na |
| name   | status | e      | _name  | owner  | e_pool | me     | ances  | nces   | s      | s      | sume    | ions   | _on     | d_on   | _on     | t      | e       | use    | is_job | gest    | rading | n       | me     |
|--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+--------+---------+--------+---------+--------+---------+--------+---------+--------+--------+---------+--------+---------+--------|
| ECHO_S | RUNNIN | TEST00 | TEST_S | SYSADM | TUTORI | echo-s | 1      | 1      | 1      | 1      | true    | None   | 2024-10 | 2024-1 | None    | This   | ROLE    | COMPUT | false  | 52e62d1 | false  | None    | None   |
| ERVICE | G      | _DB    | CHEMA  | IN     | AL_COM | ervice |        |        |        |        |         |        | -16     | 0-16   |         | is a   |         | E_WH   |        | f19c720 |        |         |        |
|        |        |        |        |        | PUTE_P | .imhd. |        |        |        |        |         |        | 15:09:3 | 15:09: |         | test   |         |        |        | 6b5f4ef |        |         |        |
|        |        |        |        |        | OOL    | svc.sp |        |        |        |        |         |        | 0.49300 | 31.905 |         | servic |         |        |        | c069557 |        |         |        |
|        |        |        |        |        |        | cs.int |        |        |        |        |         |        | 0-07:00 | 000-07 |         | e      |         |        |        | 8b6c2b3 |        |         |        |
|        |        |        |        |        |        | ernal  |        |        |        |        |         |        |         | :00    |         |        |         |        |        | 806ad76 |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 67d78cc |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | ce8b6ed |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 6501a8a |        |         |        |
|        |        |        |        |        |        |        |        |        |        |        |         |        |         |        |         |        |         |        |        | 3       |        |         |        |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27720
snow spcs service list-instances echo_service

-- Example 27721
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| database_name | schema_name | service_name | instance_id | status | spec_digest                                                      | creation_time        | start_time           |
|---------------+-------------+--------------+-------------+--------+------------------------------------------------------------------+----------------------+----------------------|
| TEST00_DB     | TEST_SCHEMA | ECHO_SERVICE | 0           | READY  | 336c065739dd2b96e770f01804affdc7810e6df68a23b23052d851627abfbdf9 | 2024-10-10T06:06:30Z | 2024-10-10T06:06:30Z |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27722
snow spcs service list-containers echo_service

-- Example 27723
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| database_name | schema_name | service_name | instance_id | container_name | status | message | image_name                                | image_digest                              | restart_count | start_time           |
|---------------+-------------+--------------+-------------+----------------+--------+---------+-------------------------------------------+-------------------------------------------+---------------+----------------------|
| TEST00_DB     | TEST_SCHEMA | ECHO_SERVICE | 0           | main           | READY  | Running | org-test-account-00.registry.registry.sno | sha256:06c3d54edc24925abe398eda70d37eb6b8 | 0             | 2024-10-16T22:09:35Z |
|               |             |              |             |                |        |         | wflakecomputing.com/test00_db/test_schema | 7b1c4dd6211317592764e1e7d94498            |               |                      |
|               |             |              |             |                |        |         | /test00_repo/echo_service:latest          |                                           |               |                      |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27724
snow spcs service list-endpoints echo_service

-- Example 27725
+--------------+------+----------+-----------------+-----------------------------------------+
| name         | port | protocol | ingress_enabled | ingress_url                             |
|--------------+------+----------+-----------------+-----------------------------------------|
| echoendpoint | 8000 | TCP      | true            | org-id-acct-id.snowflakecomputing.app   |
+--------------+------+----------+-----------------+-----------------------------------------+

-- Example 27726
snow spcs service list-roles my_service

-- Example 27727
+------------------------------------------------------------------+
| created_on                       | name                | comment |
|----------------------------------+---------------------+---------|
| 2024-10-09 16:48:52.980000-07:00 | ALL_ENDPOINTS_USAGE | None    |
+------------------------------------------------------------------+

-- Example 27728
snow spcs service set echo_service --min-instances 2 --max-instances 4

-- Example 27729
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27730
snow spcs compute-pool unset tutorial_compute_pool --auto-resume

-- Example 27731
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27732
snow spcs service logs "service_1" --container-name "container_1" --instance-id "0"

-- Example 27733
snow spcs service upgrade echo_service --spec-path spec.yml

-- Example 27734
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27735
example_streamlit/            - project name (default: example_streamlit)
  snowflake.yml               - configuration for snow streamlit commands
  environment.yml             - additional config for Streamlit, for example installing packages
  streamlit_app.py            - entrypoint file of the app
  pages/                      - directory name for Streamlit pages (default pages)
  common/                     - example “shared library”

-- Example 27736
snow init new_streamlit_project --template example_streamlit -D query_warehouse=dev_warehouse -D stage=testing

-- Example 27737
definition_version: 2
entities:
  my_streamlit:
    type: streamlit
    identifier: streamlit_app
    stage: my_streamlit_stage
    query_warehouse: my_streamlit_warehouse
    main_file: streamlit_app.py
    pages_dir: pages/
    external_access_integrations:
      - test_egress
    secrets:
      dummy_secret: "db.schema.dummy_secret"
    imports:
      - "@my_stage/foo.py"
    artifacts:
      - common/hello.py
      - environment.yml

-- Example 27738
identifier: my-streamlit-id

-- Example 27739
identifier:
  name: my-streamlit-id
  schema: my-schema # optional
  database: my-db # optional

-- Example 27740
snow sql -q "SELECT * FROM FOO"

-- Example 27741
snow sql -f my_query.sql

-- Example 27742
snow sql  -q "select 'a', 'b'; select 'c', 'd';"

-- Example 27743
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

-- Example 27744
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

-- Example 27745
snow sql -q "select * from <% database %>.logs" -D "database=dev"

-- Example 27746
snow sql \
-q "grant usage on database <% database %> to <% role %>" \
-D "database=dev" \
-D "role=eng_rl"

-- Example 27747
grant usage on database dev to eng_rl

-- Example 27748
snow sql -q "grant usage on database <% ctx.env.database %> to <% ctx.env.role %>"

-- Example 27749
snow sql -q '!source my_sql_code.sql'

-- Example 27750
select emp_id FROM employees;
!source code_file_2.sql

-- Example 27751
cat code_to_execute.sql

-- Example 27752
select 73;

-- Example 27753
snow sql -q '!source code_to_execute.sql'

-- Example 27754
select 73;
+----+
| 73 |
|----|
| 73 |
+----+

-- Example 27755
snow sql -q '!source https://trusted-host/trusted-content.sql'

-- Example 27756
select 73;
+----+
| 73 |
|----|
| 73 |
+----+

-- Example 27757
cat code_with_variable.sql

-- Example 27758
select '<% ctx.env.Message %>';

-- Example 27759
snow sql -q '!source code_&value.sql;' -D value=with_variable --env Message='Welcome !'

-- Example 27760
select 'Welcome !';
+-------------+
| 'WELCOME !' |
|-------------|
| Welcome !   |
+-------------+

-- Example 27761
snow spcs image-registry token --connection mytest

-- Example 27762
+----------------------------------------------------------------------------------------------------------------------+
| key        | value                                                                                                   |
|------------+---------------------------------------------------------------------------------------------------------|
| token      | ****************************************************************************************************    |
|            | ****************************************************************************************************    |
| expires_in | 3600                                                                                                    |
+----------------------------------------------------------------------------------------------------------------------+

-- Example 27763
snow spcs image-registry token --format=JSON | docker login <org>-<account>.registry.snowflakecomputing.com -u 0sessiontoken --password-stdin

-- Example 27764
snow spcs image-registry login

-- Example 27765
Login Succeeded

-- Example 27766
snow spcs image-registry url

-- Example 27767
<orgname-acctname>.registry.snowflakecomputing.com

-- Example 27768
snow spcs image-repository create tutorial_repository

-- Example 27769
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27770
definition_version: 2
entities:
  my_image_repository:
    type: image-repository
    identifier: my_image_repository

-- Example 27771
identifier: my-image-repository

-- Example 27772
identifier:
  name: my-image-repository
  schema: my-schema # optional
  database: my-db # optional

-- Example 27773
snow spcs image-repository deploy

-- Example 27774
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Image Repository MY_IMAGE_REPOSITORY successfully created. |
+---------------------------------------------------------------------+

-- Example 27775
snow spcs image-repository url tutorial_repository

-- Example 27776
<orgname-acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 27777
snow spcs image-repository list-images images --database my_db

-- Example 27778
+----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------+
| created_on                 | image_name    | tags    | digest                                          | image_path                              |
|----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------|
| 2024-10-11 14:23:49-07:00  | echo_service  | latest  | sha256:a8a001fef406fdb3125ce8e8bf9970c35af7084  | my_db/test_schema/images/echo_service:  |
|                            |               |         | fc33b0886d7a8915d3082c781                       | latest                                  |
| 2024-10-14 22:21:14-07:00  | test_counter  | latest  | sha256:8cae96dac29a4a05f54bb5520003f964baf67fc  | my_db/test_schema/images/test_counter:  |
|                            |               |         | 38dcad3d2c85d6c5aa7381174                       | latest                                  |
+----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------+

-- Example 27779
snow spcs compute-pool create "pool_1" --min-nodes 2 --max-nodes 2 --family "CPU_X64_XS"

