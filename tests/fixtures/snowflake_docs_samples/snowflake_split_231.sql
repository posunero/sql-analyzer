-- Example 15457
>>> function_body = '''
...     SELECT 1, 2
...     UNION ALL
...     SELECT 3, 4
... '''
>>> user_defined_function_created = user_defined_functions.create(
...     UserDefinedFunction(
...         name="my_sql_function",
...         arguments=[],
...         return_type=ReturnTable(
...             column_list=[ColumnType(name="x", datatype="INTEGER"), ColumnType(name="y", datatype="INTEGER")]
...         ),
...         language_config=SQLFunction(),
...         body=function_body,
...     )
... )

-- Example 15458
>>> user_defined_functions = user_defined_function_collection.iter()

-- Example 15459
>>> user_defined_functions = user_defined_function_collection.iter(like="your-user-defined-function-name")

-- Example 15460
>>> user_defined_functions = user_defined_function_collection.iter(like="your-user-defined-function-name-%")

-- Example 15461
>>> for user_defined_function in user_defined_functions:
...     print(user_defined_function.name)

-- Example 15462
>>> view_reference.drop()

-- Example 15463
>>> view_reference.drop(if_exists = True)

-- Example 15464
>>> my_view = view_reference.fetch()
>>> print(my_view.name, my_view.query)

-- Example 15465
>>> views = root.databases["my_db"].schemas["my_schema"].views
>>> new_view = View(
...     name="my_view",
...     columns=[
...        ViewColumn(name="col1"), ViewColumn(name="col2"), ViewColumn(name="col3"),
...     ],
...     query="SELECT * FROM my_table",
...    )
>>> views.create(new_view)

-- Example 15466
>>> views = root.databases["my_db"].schemas["my_schema"].views
>>> new_view = View(
...     name="my_view",
...     columns=[
...        ViewColumn(name="col1"), ViewColumn(name="col2"), ViewColumn(name="col3"),
...     ],
...     query="SELECT * FROM my_table",
...    )
>>> views.create(new_view, mode=CreateMode.or_replace)

-- Example 15467
>>> views = view_collection.iter()

-- Example 15468
>>> views = view_collection.iter(like="your-view-name")

-- Example 15469
>>> views = view_collection.iter(like="your-view-name-%")

-- Example 15470
>>> for view in views:
...     print(view.name, view.query)

-- Example 15471
>>> warehouses = root.warehouses
>>> new_wh = Warehouse(
...     name="my_wh",
...     warehouse_size="XSMALL")
>>> warehouses.create(new_wh)

-- Example 15472
>>> warehouse_parameters = Warehouse(
...     name="your-warehouse-name",
...     warehouse_size="SMALL",
...     auto_suspend=500,
...)

-- Example 15473
>>> # Use the warehouse collection created before to create a reference to a warehouse resource
>>> # in Snowflake.
>>> warehouse_reference = warehouse_collection.create(warehouse_parameters)

-- Example 15474
>>> warehouses = warehouse_collection.iter()

-- Example 15475
>>> warehouses = warehouse_collection.iter(like="your-warehouse-name")

-- Example 15476
>>> warehouses = warehouse_collection.iter(like="your-warehouse-name-%")

-- Example 15477
>>> for warehouse in warehouses:
>>>     print(warehouse.name, warehouse.warehouse_size)

-- Example 15478
>>> warehouse = warehouse_reference.abort_all_queries()

-- Example 15479
>>> warehouse_parameters = Warehouse(
...     name="your-warehouse-name",
...     warehouse_size="SMALL",
...     auto_suspend=500,
...)

-- Example 15480
>>> warehouse_reference.drop()

-- Example 15481
>>> warehouse_reference.drop(if_exists=True)

-- Example 15482
>>> warehouse = warehouse_reference.fetch()

-- Example 15483
>>> warehouse_reference.resume()

-- Example 15484
>>> warehouse_reference.resume(if_exists=True)

-- Example 15485
>>> warehouse_reference.suspend()

-- Example 15486
>>> warehouse_reference.suspend(if_exists=True)

-- Example 15487
>>> warehouse_reference.use_warehouse()

-- Example 15488
definition_version: 2
entities:
  pkg:
    type: application package
    identifier: <name_of_app_pkg>
    stage: app_src.stage
    manifest: app/manifest.yml
    artifacts:
      - src: app/*
        dest: ./
      - src: src/module-add/target/add-1.0-SNAPSHOT.jar
        dest: module-add/add-1.0-SNAPSHOT.jar
      - src: src/module-ui/src/*
        dest: streamlit/
    meta:
      role: <your_app_pkg_owner_role>
      warehouse: <your_app_pkg_warehouse>
      post_deploy:
        - sql_script: scripts/any-provider-setup.sql
        - sql_script: scripts/shared-content.sql
  app:
    type: application
    identifier: <name_of_app>
    from:
      target: pkg
    debug: <true|false>
    meta:
      role: <your_app_owner_role>
      warehouse: <your_app_warehouse>

-- Example 15489
definition_version: 2
entities:
  myapp_pkg:
    type: application package
    ...
    meta:
      post_deploy:
        - sql_script: scripts/post_deploy1.sql
        - sql_script: scripts/post_deploy2.sql

-- Example 15490
GRANT reference_usage on database provider_data to share in entity <% fn.str_to_id(ctx.entities.myapp_pkg.identifier) %>

-- Example 15491
pkg:
  artifacts:
    - src: app/*
      dest: ./
    - src: streamlit/*
      dest: streamlit/
    - src: src/resources/images/snowflake.png
      dest: streamlit/

-- Example 15492
pkg:
  artifacts:
    - src: qpp/*
      dest: ./
      processors:
          - name: snowpark
            properties:
              env:
                type: conda
                name: <conda_name>

-- Example 15493
from:
  target: my_pkg

-- Example 15494
telemetry:
  share_mandatory_events: true

-- Example 15495
telemetry:
  share_mandatory_events: true
  optional_shared_events:
    - DEBUG_LOGS

-- Example 15496
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true
      optional_shared_events:
        - DEBUG_LOGS

...

-- Example 15497
configuration:
    telemetry_event_definitions:
        - type: ERRORS_AND_WARNINGS
          sharing: MANDATORY
        - type: DEBUG_LOGS
          sharing: OPTIONAL

-- Example 15498
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true

-- Example 15499
definition_version: 2
entities:
  app:
    type: application
    from:
      target: pkg
    telemetry:
      share_mandatory_events: true
      optional_shared_events:
        - DEBUG_LOGS

-- Example 15500
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: conda
                name: <conda_name>

-- Example 15501
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: venv
                path: <venv_path>

-- Example 15502
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark
            properties:
              env:
                type: current

-- Example 15503
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - name: snowpark

-- Example 15504
pkg:
  artifacts:
    - src: <some_src>
      dest: <some_dest>
      processors:
          - snowpark

-- Example 15505
definition_version: 2
entities:
  pkg:
    type: application package
    identifier: myapp_pkg
    artifacts:
      - src: app/*
        dest: ./
        processors:
          - templates
    manifest: app/manifest.yml
  app:
    type: application
    identifier: myapp_<% fn.get_username() %>
    from:
      target: pkg

-- Example 15506
This is a README file for application package <% ctx.entities.pkg.identifier %>.

-- Example 15507
This is a README file for application package myapp_pkg.

-- Example 15508
entities:
  pkg:
    meta:
      role: <your_app_pkg_owner_role>
      name: <name_of_app_pkg>
      warehouse: <your_app_pkg_warehouse>
  app:
    debug: <true|false>
    meta:
      role: <your_app_owner_role>
      name: <name_of_app>
      warehouse: <your_app_warehouse>

-- Example 15509
GRANT MANAGE VERSIONS ON APPLICATION PACKAGE hello_snowflake_package
  TO ROLE release_mgr;

-- Example 15510
ALTER APPLICATION PACKAGE MyAppPackage
  ADD VERSION v1
  USING '@dev_stage/v1'
  LABEL = 'MyApp Version 1.0';

-- Example 15511
ALTER APPLICATION PACKAGE MyAppPackage
 ADD PATCH FOR VERSION V1_0
 USING '@dev_stage/v1_0_p1';

-- Example 15512
ALTER APPLICATION PACKAGE MyAppPackage
 ADD PATCH 3
 FOR VERSION V1_0
 USING '@dev_stage/v1_p1';

-- Example 15513
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 15514
ALTER APPLICATION PACKAGE hello_snowflake_package
  DROP VERSION v1_0;

-- Example 15515
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 15516
GRANT MANAGE RELEASES ON APPLICATION PACKAGE hello_snowflake_package
  TO ROLE release_mgr;

-- Example 15517
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET DEFAULT RELEASE DIRECTIVE
  VERSION = v1_0
  PATCH = 2;

-- Example 15518
ALTER APPLICATION PACKAGE hello_snowflake_package
  SET RELEASE DIRECTIVE hello_snowflake_package_custom
  ACCOUNTS = (CONSUMER_ORG.CONSUMER_ACCOUNT)
  VERSION = v1_0
  PATCH = 0;

-- Example 15519
ALTER APPLICATION PACKAGE hello_snowflake_package
  MODIFY RELEASE DIRECTIVE hello_snowflake_package_custom
  VERSION = v1_0
  PATCH = 0;

-- Example 15520
ALTER APPLICATION PACKAGE hello_snowflake_package
  UNSET RELEASE DIRECTIVE hello_snowflake_package_custom;

-- Example 15521
CREATE APPLICATION hello_snowflake
  FROM APPLICATION PACKAGE hello_snowflake_package

-- Example 15522
SHOW RELEASE DIRECTIVES IN APPLICATION PACKAGE hello_snowflake_package;

-- Example 15523
CREATE APPLICATION <name> FROM APPLICATION PACKAGE <package_name>
   [ COMMENT = '<string_literal>' ]
   [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , ... ] ) ]
   [ AUTHORIZE_TELEMETRY_EVENT_SHARING = { TRUE | FALSE } ]

CREATE APPLICATION <name> FROM APPLICATION PACKAGE <package_name>
  USING <path_to_version_directory>
  [ DEBUG_MODE = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [, ...] ) ]
  [ AUTHORIZE_TELEMETRY_EVENT_SHARING = { TRUE | FALSE } ]


CREATE APPLICATION <name> FROM APPLICATION PACKAGE <package_name>
  USING VERSION  <version_identifier> [ PATCH <patch_num> ]
  [ DEBUG_MODE = { TRUE | FALSE } ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , ... ] ) ]
  [ AUTHORIZE_TELEMETRY_EVENT_SHARING = { TRUE | FALSE } ]

CREATE APPLICATION <name> FROM LISTING <listing_name>
   [ COMMENT = '<string_literal>' ]
   [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , ... ] ) ]
   [ BACKGROUND_INSTALL = { TRUE | FALSE } ]
   [ AUTHORIZE_TELEMETRY_EVENT_SHARING = { TRUE | FALSE } ]

