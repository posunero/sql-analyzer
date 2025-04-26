-- Example 27646
WARNING  snowflake.cli._plugins.workspace.commands:commands.py:60 Your V1 definition contains templates. We cannot guarantee the correctness of the migration.
Project definition migrated to version 2

-- Example 27647
definition_version: 1
native_app:
  name: myapp
  source_stage: app_src.stage
  artifacts:
    - src: app/*
      dest: ./
      processors:
        - native app setup
        - name: templates
          properties:
            foo: bar
  package:
    role: pkg_role
    distribution: external
  application:
    name: myapp_app
    warehouse: app_wh

-- Example 27648
definition_version: 2
entities:
  pkg:
    type: application package
    meta:
      role: pkg_role
    identifier: <% fn.concat_ids('myapp', '_pkg_', fn.sanitize_id(fn.get_username('unknown_user')) | lower) %>
    manifest: app/manifest.yml
    artifacts:
    - src: app/*
      dest: ./
      processors:
      - name: native app setup
      - name: templates
        properties:
          foo: bar
    stage: app_src.stage
  app:
    meta:
      warehouse: app_wh
    identifier: myapp_app
    type: application
    from:
      target: pkg

-- Example 27649
definition_version: 1
streamlit:
  name: test_streamlit
  stage: streamlit
  query_warehouse: test_warehouse
  main_file: "streamlit_app.py"
  title: "My Fancy Streamlit"

-- Example 27650
definition_version: 2
entities:
  test_streamlit:
    identifier:
      name: test_streamlit
    type: streamlit
    title: My Fancy Streamlit
    query_warehouse: test_warehouse
    main_file: streamlit_app.py
    pages_dir: None
    stage: streamlit
    artifacts:
    - streamlit_app.py

-- Example 27651
definition_version: 1
snowpark:
  project_name: "my_snowpark_project"
  stage_name: "dev_deployment"
  src: "app/"
  functions:
    - name: func1
      handler: "app.func1_handler"
      signature:
        - name: "a"
          type: "string"
          default: "default value"
        - name: "b"
          type: "variant"
      returns: string
      runtime: 3.10
  procedures:
    - name: procedureName
      handler: "hello"
      signature:
        - name: "name"
          type: "string"
      returns: string

-- Example 27652
definition_version: 2
entities:
  procedureName:
    imports: []
    external_access_integrations: []
    secrets: {}
    meta:
      use_mixins:
      - snowpark_shared
    identifier:
      name: procedureName
    handler: hello
    returns: string
    signature:
    - name: name
      type: string
    stage: dev_deployment
    artifacts:
    - src: app
      dest: my_snowpark_project
    type: procedure
    execute_as_caller: false
  func1:
    imports: []
    external_access_integrations: []
    secrets: {}
    meta:
      use_mixins:
      - snowpark_shared
    identifier:
      name: func1
    handler: app.func1_handler
    returns: string
    signature:
    - name: a
      type: string
      default: default value
    - name: b
      type: variant
    runtime: '3.10'
    stage: dev_deployment
    artifacts:
    - src: app
      dest: my_snowpark_project
    type: function
mixins:
  snowpark_shared:
    stage: dev_deployment
    artifacts:
    - src: app/
      dest: my_snowpark_project

-- Example 27653
entities:
  entity_a:
    ...
  entity_b:
    ...

-- Example 27654
entities:
  entity_a:
    ...
  entity_b:
    ...

-- Example 27655
entities:
  entity_a:
    identifier: entity_a_name
    ...
  entity_b:
    identifier:
      name: entity_a_name

-- Example 27656
entities:
  entity_b:
    identifier:
      name: entity_a_name
      schema: public
      database: DEV

-- Example 27657
definition_version: 2
mixins:
  stage_mixin:
    stage: "my_stage"
  snowpark_shared:
    artifacts: ["app/"]
    imports: ["@package_stage/package.zip"]

entities:
  my_function:
    type: "function"
    ...
    meta:
      use_mixins:
        - "stage_mixin"
        - "snowpark_shared"
  my_dashboard:
    type: "dashboard"
    ...
    meta:
      use_mixins:
        - "stage_mixin"

-- Example 27658
mixins:
  mixin_1:
    key: mixin_1_value
  mixin_2:
    key: mixin_2_value

entities:
  foo:
    meta:
      use_mixin:
      - mixin_1
      - mixin_2

-- Example 27659
definition_version: 2
mixins:
  mix1:
    stage: A

  mix2:
    stage: B

entities:
  test_procedure:
    stage: C
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27660
definition_version: 2
entities:
  test_procedure:
    stage: C

-- Example 27661
definition_version: 2
mixins:
  mix1:
    artifacts:
    - a.py

  mix2:
    artifacts:
    - b.py

entities:
  test_procedure:
    artifacts:
      - app/
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27662
definition_version: 2
entities:
  test_procedure:
    artifacts:
      - a.py
      - b.py
      - app/

-- Example 27663
definition_version: 2
mixins:
  mix1:
    secrets:
      secret1: v1

  mix2:
    secrets:
      secret2: v2

entities:
  test_procedure:
    secrets:
      secret3: v3
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27664
definition_version: 2
entities:
  test_procedure:
    secrets:
      secret1: v1
      secret2: v2
      secret3: v3

-- Example 27665
definition_version: 2
mixins:
  mix1:
    secrets:
      secret_name: v1

  mix2:
    secrets:
      secret_name: v2

entities:
  test_procedure:
    secrets:
      secret_name: v3
    meta:
      use_mixins:
        - mix1
        - mix2

-- Example 27666
definition_version: 2
entities:
  test_procedure:
    secrets:
      secret_name: v3

-- Example 27667
definition_version: 2
mixins:
  shared:
    identifier:
      schema: foo

entities:
  sproc1:
    identifier:
      name: sproc
    meta:
      use_mixins: ["shared"]
  sproc2:
    identifier:
      name: sproc
      schema: from_entity
    meta:
      use_mixins: ["shared"]

-- Example 27668
definition_version: 2
entities:
  sproc1:
    identifier:
      name: sproc
      schema: foo
  sproc2:
    identifier:
      name: sproc
      schema: from_entity

-- Example 27669
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

-- Example 27670
identifier: my-snowpark-id

-- Example 27671
identifier:
  name: my-snowpark-id
  schema: my-schema # optional
  database: my-db # optional

-- Example 27672
signature:
  - name: "first_argument"
    type: int
  - name: "second_argument"
    default: "default value"
    type: string

-- Example 27673
snow spcs compute-pool create "pool_1" --min-nodes 2 --max-nodes 2 --family "CPU_X64_XS"

-- Example 27674
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

-- Example 27675
identifier: my-compute-pool

-- Example 27676
identifier:
  name: my-compute-pool
  schema: my-schema # optional
  database: my-db # optional

-- Example 27677
snow spcs compute-pool deploy

-- Example 27678
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Compute pool MY_COMPUTE_POOL successfully created.         |
+---------------------------------------------------------------------+

-- Example 27679
snow spcs compute-pool suspend tutorial_compute_pool

-- Example 27680
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27681
snow spcs compute-pool resume tutorial_compute_pool

-- Example 27682
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27683
snow spcs compute-pool set tutorial_compute_pool --min-nodes 2 --max-nodes 4

-- Example 27684
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27685
snow spcs compute-pool unset tutorial_compute_pool --auto-resume

-- Example 27686
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27687
snow spcs compute-pool stop-all "pool_1"

-- Example 27688
snow spcs image-registry token --connection mytest

-- Example 27689
+----------------------------------------------------------------------------------------------------------------------+
| key        | value                                                                                                   |
|------------+---------------------------------------------------------------------------------------------------------|
| token      | ****************************************************************************************************    |
|            | ****************************************************************************************************    |
| expires_in | 3600                                                                                                    |
+----------------------------------------------------------------------------------------------------------------------+

-- Example 27690
snow spcs image-registry token --format=JSON | docker login <org>-<account>.registry.snowflakecomputing.com -u 0sessiontoken --password-stdin

-- Example 27691
snow spcs image-registry login

-- Example 27692
Login Succeeded

-- Example 27693
snow spcs image-registry url

-- Example 27694
<orgname-acctname>.registry.snowflakecomputing.com

-- Example 27695
snow spcs image-repository create tutorial_repository

-- Example 27696
+-------------------------------------------+
| key    | value                            |
|--------+----------------------------------|
| status | Statement executed successfully. |
+-------------------------------------------+

-- Example 27697
definition_version: 2
entities:
  my_image_repository:
    type: image-repository
    identifier: my_image_repository

-- Example 27698
identifier: my-image-repository

-- Example 27699
identifier:
  name: my-image-repository
  schema: my-schema # optional
  database: my-db # optional

-- Example 27700
snow spcs image-repository deploy

-- Example 27701
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Image Repository MY_IMAGE_REPOSITORY successfully created. |
+---------------------------------------------------------------------+

-- Example 27702
snow spcs image-repository url tutorial_repository

-- Example 27703
<orgname-acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 27704
snow spcs image-repository list-images images --database my_db

-- Example 27705
+----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------+
| created_on                 | image_name    | tags    | digest                                          | image_path                              |
|----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------|
| 2024-10-11 14:23:49-07:00  | echo_service  | latest  | sha256:a8a001fef406fdb3125ce8e8bf9970c35af7084  | my_db/test_schema/images/echo_service:  |
|                            |               |         | fc33b0886d7a8915d3082c781                       | latest                                  |
| 2024-10-14 22:21:14-07:00  | test_counter  | latest  | sha256:8cae96dac29a4a05f54bb5520003f964baf67fc  | my_db/test_schema/images/test_counter:  |
|                            |               |         | 38dcad3d2c85d6c5aa7381174                       | latest                                  |
+----------------------------+---------------+---------+-------------------------------------------------+-----------------------------------------+

-- Example 27706
snow spcs service create "job_1" --compute-pool "pool_1" --spec-path "/some-dir/spec_file.yaml"

-- Example 27707
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

-- Example 27708
identifier: my-service

-- Example 27709
identifier:
  name: my-service
  schema: my-schema # optional
  database: my-db # optional

-- Example 27710
snow spcs service deploy

-- Example 27711
+---------------------------------------------------------------------+
| key    | value                                                      |
|--------+------------------------------------------------------------|
| status | Service MY_SERVICE successfully created.                   |
+---------------------------------------------------------------------+

-- Example 27712
snow spcs service suspend echo_service

