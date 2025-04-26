-- Example 27780
definition_version: 2
entities:
  my_compute_pool:
    type: compute-pool
    identifier:
      name: my_compute_pool
    min_nodes: 1
    max_nodes: 2
    instance_family: CPU_X64_XS
    auto_resume: true
    initially_suspended: true
    auto_suspend_seconds: 60
    comment: "My compute pool"
    tags:
      - name: my_tag
        value: tag_value

-- Example 27781
identifier: my-compute-pool

-- Example 27782
identifier:
  name: my-compute-pool
  schema: my-schema # optional
  database: my-db # optional

-- Example 27783
snow spcs compute-pool deploy

-- Example 27784
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Compute pool MY_COMPUTE_POOL successfully created.         |
+---------------------------------------------------------------------+

-- Example 27785
snow spcs compute-pool suspend tutorial_compute_pool

-- Example 27786
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27787
snow spcs compute-pool resume tutorial_compute_pool

-- Example 27788
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27789
snow spcs compute-pool set tutorial_compute_pool --min-nodes 2 --max-nodes 4

-- Example 27790
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27791
snow spcs compute-pool unset tutorial_compute_pool --auto-resume

-- Example 27792
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27793
snow spcs compute-pool stop-all "pool_1"

-- Example 27794
snow spcs service create "job_1" --compute-pool "pool_1" --spec-path "/some-dir/spec_file.yaml"

-- Example 27795
definition_version: 2
entities:
  my_service:
    type: service
    identifier: my_service
    stage: my_stage
    compute_pool: my_compute_pool
    spec_file: spec.yml
    min_instances: 1
    max_instances: 2
    query_warehouse: my_warehouse
    auto_resume: true
    external_access_integrations:
      - my_external_access
    secrets:
        cred: my_cred_name
    artifacts:
      - spec.yml
    comment: "My service"
    tags:
      - name: test_tag
        value: test_value

-- Example 27796
identifier: my-service

-- Example 27797
identifier:
  name: my-service
  schema: my-schema # optional
  database: my-db # optional

-- Example 27798
snow spcs service deploy

-- Example 27799
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Service MY_SERVICE successfully created.                   |
+---------------------------------------------------------------------+

-- Example 27800
snow spcs service suspend echo_service

-- Example 27801
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27802
snow spcs service resume echo_service

-- Example 27803
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27804
snow spcs service list

-- Example 27805
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

-- Example 27806
snow spcs service describe echo_service

-- Example 27807
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

-- Example 27808
snow spcs service list-instances echo_service

-- Example 27809
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| database_name | schema_name | service_name | instance_id | status | spec_digest                                                      | creation_time        | start_time           |
|---------------+-------------+--------------+-------------+--------+------------------------------------------------------------------+----------------------+----------------------|
| TEST00_DB     | TEST_SCHEMA | ECHO_SERVICE | 0           | READY  | 336c065739dd2b96e770f01804affdc7810e6df68a23b23052d851627abfbdf9 | 2024-10-10T06:06:30Z | 2024-10-10T06:06:30Z |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27810
snow spcs service list-containers echo_service

-- Example 27811
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| database_name | schema_name | service_name | instance_id | container_name | status | message | image_name                                | image_digest                              | restart_count | start_time           |
|---------------+-------------+--------------+-------------+----------------+--------+---------+-------------------------------------------+-------------------------------------------+---------------+----------------------|
| TEST00_DB     | TEST_SCHEMA | ECHO_SERVICE | 0           | main           | READY  | Running | org-test-account-00.registry.registry.sno | sha256:06c3d54edc24925abe398eda70d37eb6b8 | 0             | 2024-10-16T22:09:35Z |
|               |             |              |             |                |        |         | wflakecomputing.com/test00_db/test_schema | 7b1c4dd6211317592764e1e7d94498            |               |                      |
|               |             |              |             |                |        |         | /test00_repo/echo_service:latest          |                                           |               |                      |
+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 27812
snow spcs service list-endpoints echo_service

-- Example 27813
+--------------+------+----------+-----------------+-----------------------------------------+
| name         | port | protocol | ingress_enabled | ingress_url                             |
|--------------+------+----------+-----------------+-----------------------------------------|
| echoendpoint | 8000 | TCP      | true            | org-id-acct-id.snowflakecomputing.app   |
+--------------+------+----------+-----------------+-----------------------------------------+

-- Example 27814
snow spcs service list-roles my_service

-- Example 27815
+------------------------------------------------------------------+
| created_on                       | name                | comment |
|----------------------------------+---------------------+---------|
| 2024-10-09 16:48:52.980000-07:00 | ALL_ENDPOINTS_USAGE | None    |
+------------------------------------------------------------------+

-- Example 27816
snow spcs service set echo_service --min-instances 2 --max-instances 4

-- Example 27817
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27818
snow spcs compute-pool unset tutorial_compute_pool --auto-resume

-- Example 27819
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27820
snow spcs service logs "service_1" --container-name "container_1" --instance-id "0"

-- Example 27821
snow spcs service upgrade echo_service --spec-path spec.yml

-- Example 27822
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27823
snowflake.yml      - project definition
requirements.txt   - project dependencies
app/               - code of functions and procedures
  __init__.py
  functions.py     - example functions
  procedures.py    - example procedures
  common.py        - example "shared library"

-- Example 27824
definition_version: '2'

mixins:
  snowpark_shared:
    artifacts:
      - dest: my_snowpark_project
        src: app/
    stage: dev_deployment

entities:

  hello_function:
    type: function
    identifier:
      name: hello_function
    handler: functions.hello_function
    signature:
      - name: name
        type: string
    returns: string
    external_access_integrations:
      - my_external_access
    secrets:
        cred: my_cred_name
    meta:
      use_mixins:
        - snowpark_shared

  hello_procedure:
    type: procedure
    identifier:
      name: hello_procedure
    handler: procedures.hello_procedure
    signature:
      - name: name
        type: string
    returns: string
    meta:
      use_mixins:
        - snowpark_shared

  test_procedure:
    type: procedure
    identifier:
      name: test_procedure
    handler: procedures.test_procedure
    signature: ''
    returns: string
    meta:
      use_mixins:
        - snowpark_shared

-- Example 27825
identifier: my-snowpark-id

-- Example 27826
identifier:
  name: my-snowpark-id
  schema: my-schema # optional
  database: my-db # optional

-- Example 27827
signature:
  - name: "first_argument"
    type: int
  - name: "second_argument"
    default: "default value"
    type: string

-- Example 27828
snow snowpark build

-- Example 27829
Resolving dependencies from requirements.txt
  No external dependencies.
Preparing artifacts for source code
  Creating: app.zip
Build done.

-- Example 27830
snow snowpark deploy

-- Example 27831
+-------------------------------------------------------------+
| object                       | type      | status           |
|------------------------------+-----------+------------------|
| hello_procedure(name string) | procedure | created          |
| test_procedure()             | procedure | packages updated |
| hello_function(name string)  | function  | created          |
+-------------------------------------------------------------+

-- Example 27832
snow snowpark execute function "hello_function('Olaf')"

-- Example 27833
+--------------------------------------+
| key                    | value       |
|------------------------+-------------|
| HELLO_FUNCTION('Olaf') | Hello Olaf! |
+--------------------------------------+

-- Example 27834
snow snowpark package lookup numpy

-- Example 27835
Package `numpy` is available in Anaconda. Latest available version: 1.26.4.

-- Example 27836
snow snowpark package lookup july

-- Example 27837
Package `july` is not available in Anaconda. To prepare Snowpark compatible package run:

  snow snowpark package create july

-- Example 27838
snow snowpark package create <name>

-- Example 27839
snow snowpark package create july==0.1

-- Example 27840
Package july.zip created. You can now upload it to a stage using
snow snowpark package upload -f july.zip -s <stage-name>`
and reference it in your procedure or function.
Remember to add it to imports in the procedure or function definition.

The package july==0.1 is successfully created, but depends on the following
Anaconda libraries. They need to be included in project requirements,
as their are not included in .zip.
matplotlib
numpy

-- Example 27841
snow snowpark package create july==0.1 --ignore-anaconda --allow-shared-libraries

-- Example 27842
2024-05-09 15:34:02 ERROR Following dependencies utilise shared libraries, not supported by Conda:
2024-05-09 15:34:02 ERROR contourpy
numpy
pillow
kiwisolver
matplotlib
fonttools
2024-05-09 15:34:02 ERROR You may still try to create your package with --allow-shared-libraries, but the might not work.
2024-05-09 15:34:02 ERROR You may also request adding the package to Snowflake Conda channel
2024-05-09 15:34:02 ERROR at https://support.anaconda.com/

Package july.zip created. You can now upload it to a stage using
snow snowpark package upload -f july.zip -s <stage-name>`
and reference it in your procedure or function.
Remember to add it to imports in the procedure or function definition.

-- Example 27843
snow snowpark package create matplotlib

-- Example 27844
Package matplotlib is already available in Snowflake Anaconda Channel.

-- Example 27845
snow snowpark package upload --file="july.zip" --stage="packages"

-- Example 27846
Package july.zip UPLOADED to Snowflake @packages/july.zip.

