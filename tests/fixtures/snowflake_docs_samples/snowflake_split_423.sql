-- Example 28316
>>> iceberg_table_reference.drop(if_exists=True)

-- Example 28317
>>> iceberg_table_reference = root.databases["my_db"].schemas["my_schema"].iceberg_tables["foo"]
>>> my_iceberg_table = iceberg_table_reference.fetch()
>>> print(my_iceberg_table.name)

-- Example 28318
>>> iceberg_table.refresh()

-- Example 28319
>>> iceberg_table.refresh(if_exists=True)

-- Example 28320
>>> iceberg_table.resume_recluster()

-- Example 28321
>>> iceberg_table.resume_recluster(if_exists=True)

-- Example 28322
>>> iceberg_table.suspend_recluster()

-- Example 28323
>>> iceberg_table.suspend_recluster(if_exists=True)

-- Example 28324
>>> iceberg_table.undrop()

-- Example 28325
>>> iceberg_table.undrop(if_exists=True)

-- Example 28326
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> new_iceberg_table = IcebergTable(
...     name="name",
...     columns=[IcebergTableColumn(name="col1", datatype="string")],
... )
>>> iceberg_tables.create(new_iceberg_table)

-- Example 28327
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> new_iceberg_table = IcebergTable(
...     name="name",
...     columns=[IcebergTableColumn(name="col1", datatype="string")],
... )
>>> iceberg_tables.create(new_iceberg_table, mode=CreateMode.or_replace)

-- Example 28328
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> iceberg_tables.create(
...     IcebergTable(name="new_table"),
...     clone_iceberg_table="iceberg_table_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
... )

-- Example 28329
>>> iceberg_tables = iceberg_table_collection.iter()

-- Example 28330
>>> iceberg_tables = iceberg_table_collection.iter(like="your-iceberg-table-name")

-- Example 28331
>>> iceberg_tables = iceberg_table_collection.iter(like="your-iceberg-table-name-%")

-- Example 28332
>>> for iceberg_table in iceberg_tables:
...     print(iceberg_table.name)

-- Example 28333
>>> image_repository = ImageRepository(name="my_image_repository")
>>> image_repositories = root.databases["my_db"].schemas["my_schema"].image_repositories
>>> image_repositories.create(image_repository)

-- Example 28334
>>> image_repository = ImageRepository(name="my_image_repository")
>>> image_repositories = root.databases["my_db"].schemas["my_schema"].image_repositories
>>> image_repositories.create(image_repository, mode=CreateMode.or_replace)

-- Example 28335
>>> image_repositories = image_repository_collection.iter()

-- Example 28336
>>> image_repositories = image_repository_collection.iter(like="your-image-repository-name")

-- Example 28337
>>> image_repositories = image_repository_collection.iter(like="your-image-repository-name-%")

-- Example 28338
>>> for image_repository in image_repositories:
>>>     print(image_repository.name)

-- Example 28339
>>> image_repository_reference.delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 28340
>>> image_repository_reference.drop()

-- Example 28341
>>> my_image_repository = image_repository_reference.fetch()
>>> print(my_image_repository.name)

-- Example 28342
>>> for image in image_repository_reference.list_images_in_repository():
...     print(image.name)

-- Example 28343
>>> managed_account_collection = root.managed_accounts
>>> managed_account = ManagedAccount(
...     name="managed_account_name",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     account_type = "READER"
...  )
>>> managed_account_collection.create(managed_account)

-- Example 28344
>>> managed_account_parameters = ManagedAccount(
...     name="managed_account_name",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     account_type = "READER"
...  )
>>> # Use the managed account collection created before to create a reference to a managed account resource
>>> # in Snowflake.
>>> managed_account_reference = managed_account_collection.create(managed_account_parameters)

-- Example 28345
>>> managed_accounts = managed_account_collection.iter()

-- Example 28346
>>> managed_accounts = managed_account_collection.iter(like="your-managed-account-name")

-- Example 28347
>>> managed_accounts = managed_account_collection.iter(like="your-managed-account-name-%")

-- Example 28348
>>> for managed_account in managed_accounts:
>>>     print(managed_account.name, managed_account.comment)

-- Example 28349
>>> managed_account_reference.drop()

-- Example 28350
>>> network_policy_reference.drop()

-- Example 28351
>>> network_policy_reference.drop(if_exists=True)

-- Example 28352
>>> print(network_policy_reference.fetch().created_on)

-- Example 28353
>>> network_policies = root.network_policies
>>> new_network_policy = NetworkPolicy(
...     name = 'single_ip_policy',
...     allowed_ip_list=['192.168.1.32/32'],
...     blocked_ip_list=['0.0.0.0'],
... )
>>> network_policies.create(new_network_policy)

-- Example 28354
>>> root.network_policies.create(NetworkPolicy(
...     name = 'my_network_policy',
...     allowed_network_rule_list = allowed_rules,
...     blocked_network_rule_list = blocked_rules,
...     allowed_ip_list=['8.8.8.8'],
...     blocked_ip_list=['0.0.0.0'],
... ))

-- Example 28355
>>> for network_policy in root.network_policies.iter():
>>>     print(network_policy.name)

-- Example 28356
>>> notebooks = root.databases["my_db"].schemas["my_schema"].notebooks
>>> new_notebook = Notebook(
...     name="my_notebook",
...     comment="This is a notebook"
... )
>>> notebooks.create(new_notebook)

-- Example 28357
>>> notebook = Notebook(
...     name="my_notebook",
...     version="notebook_ver1",
...     comment="This is a notebook"
... )
>>> # Use the notebook collection created before to create a reference to the notebook resource
>>> # in Snowflake.
>>> notebook_reference = notebook_collection.create(notebook)

-- Example 28358
>>> notebooks = notebook_collection.iter()

-- Example 28359
>>> notebooks = notebook_collection.iter(like="your-notebook-name")

-- Example 28360
>>> notebooks = notebook_collection.iter(like="your-notebook-name%")

-- Example 28361
>>> for notebook in notebooks:
...     print(notebook.name, notebook.version, notebook.user_packages)

-- Example 28362
>>> notebook_reference.add_live_version(from_last=True,
...                                     comment="new live version")

-- Example 28363
>>> notebook_reference.commit(version="prod-1.1.0",
...                           comment="prod release 1.1.0")

-- Example 28364
>>> notebook_reference.drop()

-- Example 28365
>>> notebook_reference.drop(if_exists=True)

-- Example 28366
>>> notebook_reference.execute()

-- Example 28367
>>> notebook = notebook_reference.fetch()
>>> print(notebook.name, notebook.comment)

-- Example 28368
>>> notebook_reference.rename("my_other_notebook")

-- Example 28369
>>> notebook_reference.rename("my_other_notebook", if_exists = True)

-- Example 28370
>>> # This example assumes that mySecret already exists
>>> notification_integrations = root.notification_integrations
>>> new_ni = NotificationIntegration(
...     name="my_notification_integration",
...     enabled=True,
...     notification_hook=NotificationWebhook(
...         webhook_url="https://events.pagerduty.com/v2/enqueue",
...         webhook_secret=WebhookSecret(
...             name="mySecret".upper(), database_name=database, schema_name=schema
...         ),
...         webhook_body_template='{"key": "SNOWFLAKE_WEBHOOK_SECRET", "msg": "SNOWFLAKE_WEBHOOK_MESSAGE"}',
...         webhook_headers={"content-type": "application/json", "user-content": "chrome"},
...     )
... )
>>> notification_integrations.create(new_ni)

-- Example 28371
>>> notification_integrations.create(
...     NotificationIntegration(
...         name="my_notification_integration",
...         notification_hook=NotificationEmail(
...             allowed_recipients=["my_email@company.com"],
...             default_recipients=["my_email@company.com"],
...             default_subject="test default subject",
...         ),
...         comment="This is a comment",
...         enabled=True,
...     ),
...     mode=CreateMode.if_not_exists,
... )

-- Example 28372
>>> notification_integrations = notification_integrations.iter()

-- Example 28373
>>> notification_integrations = notification_integrations.iter(like="your-notification-integration-name")

-- Example 28374
>>> notification_integrations = notification_integrations.iter(like="your-notification-integration-name-%")

-- Example 28375
>>> for notification_integration in notification_integrations:
>>>     print(
...         notification_integration.name,
...         notification_integration.enabled,
...         repr(notification_integration.notification_hook),
...     )

-- Example 28376
>>> ni_reference.drop()

-- Example 28377
>>> ni_reference.drop(if_exists=True)

-- Example 28378
>>> my_ni = ni_reference.fetch()
>>> print(my_ni.name, my_ni.enabled, repr(my_ni.notification_hook))

-- Example 28379
>>> pipes = root.databases["my_db"].schemas["my_schema"].pipes
>>>     new_pipe = Pipe(
...         name="my_pipe",
...         comment="This is a pipe")
>>> pipes.create(new_pipe)

-- Example 28380
>>> pipe_parameters = Pipe(
...     name="my_pipe",
...     comment="This is a pipe"
... )
>>> # Use the pipe collection created before to create a referece to the pipe resource
>>> # in Snowflake.
>>> pipe_reference = pipe_collection.create(pipe_parameters)

-- Example 28381
>>> pipes = pipe_collection.iter()

-- Example 28382
>>> pipes = pipe_collection.iter(like="your-pipe-name")

