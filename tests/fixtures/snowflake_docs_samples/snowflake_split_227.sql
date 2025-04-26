-- Example 15189
>>> from snowflake.core.grant import Grantees, Privileges, Securables
>>> Grant(grantee=Grantees.role(
...     name="test_role",
...     securable=Securables.current_account,
...     privileges=[Privileges.create_database],
... )

-- Example 15190
>>> root.grants.grant(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 15191
>>> root.grants.revoke(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 15192
>>> root.grants.revoke(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 15193
>>> root.grants.to(
...    Grantee(
...         name="test-user",
...         grantee_type="user",
...     ),
...     limit = 10,
... )

-- Example 15194
>>> Grantee("test-user", "user")
>>> Grantee("test-role", "role")

-- Example 15195
>>> Grantees.role("test-role")
>>> Grantees.user("test-user")

-- Example 15196
>>> Securables.account("test-account")
>>> Securables.database("testdb")
>>> Securables.current_account

-- Example 15197
>>> iceberg_table.convert_to_managed()

-- Example 15198
>>> iceberg_table.convert_to_managed(if_exists=True)

-- Example 15199
>>> iceberg_table_reference.drop()

-- Example 15200
>>> iceberg_table_reference.drop(if_exists=True)

-- Example 15201
>>> iceberg_table_reference = root.databases["my_db"].schemas["my_schema"].iceberg_tables["foo"]
>>> my_iceberg_table = iceberg_table_reference.fetch()
>>> print(my_iceberg_table.name)

-- Example 15202
>>> iceberg_table.refresh()

-- Example 15203
>>> iceberg_table.refresh(if_exists=True)

-- Example 15204
>>> iceberg_table.resume_recluster()

-- Example 15205
>>> iceberg_table.resume_recluster(if_exists=True)

-- Example 15206
>>> iceberg_table.suspend_recluster()

-- Example 15207
>>> iceberg_table.suspend_recluster(if_exists=True)

-- Example 15208
>>> iceberg_table.undrop()

-- Example 15209
>>> iceberg_table.undrop(if_exists=True)

-- Example 15210
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> new_iceberg_table = IcebergTable(
...     name="name",
...     columns=[IcebergTableColumn(name="col1", datatype="string")],
... )
>>> iceberg_tables.create(new_iceberg_table)

-- Example 15211
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> new_iceberg_table = IcebergTable(
...     name="name",
...     columns=[IcebergTableColumn(name="col1", datatype="string")],
... )
>>> iceberg_tables.create(new_iceberg_table, mode=CreateMode.or_replace)

-- Example 15212
>>> iceberg_tables = root.databases["my_db"].schemas["my_schema"].iceberg_tables
>>> iceberg_tables.create(
...     IcebergTable(name="new_table"),
...     clone_iceberg_table="iceberg_table_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
... )

-- Example 15213
>>> iceberg_tables = iceberg_table_collection.iter()

-- Example 15214
>>> iceberg_tables = iceberg_table_collection.iter(like="your-iceberg-table-name")

-- Example 15215
>>> iceberg_tables = iceberg_table_collection.iter(like="your-iceberg-table-name-%")

-- Example 15216
>>> for iceberg_table in iceberg_tables:
...     print(iceberg_table.name)

-- Example 15217
>>> image_repository = ImageRepository(name="my_image_repository")
>>> image_repositories = root.databases["my_db"].schemas["my_schema"].image_repositories
>>> image_repositories.create(image_repository)

-- Example 15218
>>> image_repository = ImageRepository(name="my_image_repository")
>>> image_repositories = root.databases["my_db"].schemas["my_schema"].image_repositories
>>> image_repositories.create(image_repository, mode=CreateMode.or_replace)

-- Example 15219
>>> image_repositories = image_repository_collection.iter()

-- Example 15220
>>> image_repositories = image_repository_collection.iter(like="your-image-repository-name")

-- Example 15221
>>> image_repositories = image_repository_collection.iter(like="your-image-repository-name-%")

-- Example 15222
>>> for image_repository in image_repositories:
>>>     print(image_repository.name)

-- Example 15223
>>> image_repository_reference.delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 15224
>>> image_repository_reference.drop()

-- Example 15225
>>> my_image_repository = image_repository_reference.fetch()
>>> print(my_image_repository.name)

-- Example 15226
>>> for image in image_repository_reference.list_images_in_repository():
...     print(image.name)

-- Example 15227
>>> managed_account_collection = root.managed_accounts
>>> managed_account = ManagedAccount(
...     name="managed_account_name",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     account_type = "READER"
...  )
>>> managed_account_collection.create(managed_account)

-- Example 15228
>>> managed_account_parameters = ManagedAccount(
...     name="managed_account_name",
...     admin_name = "admin"
...     admin_password = 'TestPassword1'
...     account_type = "READER"
...  )
>>> # Use the managed account collection created before to create a reference to a managed account resource
>>> # in Snowflake.
>>> managed_account_reference = managed_account_collection.create(managed_account_parameters)

-- Example 15229
>>> managed_accounts = managed_account_collection.iter()

-- Example 15230
>>> managed_accounts = managed_account_collection.iter(like="your-managed-account-name")

-- Example 15231
>>> managed_accounts = managed_account_collection.iter(like="your-managed-account-name-%")

-- Example 15232
>>> for managed_account in managed_accounts:
>>>     print(managed_account.name, managed_account.comment)

-- Example 15233
>>> managed_account_reference.drop()

-- Example 15234
>>> network_policy_reference.drop()

-- Example 15235
>>> network_policy_reference.drop(if_exists=True)

-- Example 15236
>>> print(network_policy_reference.fetch().created_on)

-- Example 15237
>>> network_policies = root.network_policies
>>> new_network_policy = NetworkPolicy(
...     name = 'single_ip_policy',
...     allowed_ip_list=['192.168.1.32/32'],
...     blocked_ip_list=['0.0.0.0'],
... )
>>> network_policies.create(new_network_policy)

-- Example 15238
>>> root.network_policies.create(NetworkPolicy(
...     name = 'my_network_policy',
...     allowed_network_rule_list = allowed_rules,
...     blocked_network_rule_list = blocked_rules,
...     allowed_ip_list=['8.8.8.8'],
...     blocked_ip_list=['0.0.0.0'],
... ))

-- Example 15239
>>> for network_policy in root.network_policies.iter():
>>>     print(network_policy.name)

-- Example 15240
>>> notebooks = root.databases["my_db"].schemas["my_schema"].notebooks
>>> new_notebook = Notebook(
...     name="my_notebook",
...     comment="This is a notebook"
... )
>>> notebooks.create(new_notebook)

-- Example 15241
>>> notebook = Notebook(
...     name="my_notebook",
...     version="notebook_ver1",
...     comment="This is a notebook"
... )
>>> # Use the notebook collection created before to create a reference to the notebook resource
>>> # in Snowflake.
>>> notebook_reference = notebook_collection.create(notebook)

-- Example 15242
>>> notebooks = notebook_collection.iter()

-- Example 15243
>>> notebooks = notebook_collection.iter(like="your-notebook-name")

-- Example 15244
>>> notebooks = notebook_collection.iter(like="your-notebook-name%")

-- Example 15245
>>> for notebook in notebooks:
...     print(notebook.name, notebook.version, notebook.user_packages)

-- Example 15246
>>> notebook_reference.add_live_version(from_last=True,
...                                     comment="new live version")

-- Example 15247
>>> notebook_reference.commit(version="prod-1.1.0",
...                           comment="prod release 1.1.0")

-- Example 15248
>>> notebook_reference.drop()

-- Example 15249
>>> notebook_reference.drop(if_exists=True)

-- Example 15250
>>> notebook_reference.execute()

-- Example 15251
>>> notebook = notebook_reference.fetch()
>>> print(notebook.name, notebook.comment)

-- Example 15252
>>> notebook_reference.rename("my_other_notebook")

-- Example 15253
>>> notebook_reference.rename("my_other_notebook", if_exists = True)

-- Example 15254
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

-- Example 15255
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

