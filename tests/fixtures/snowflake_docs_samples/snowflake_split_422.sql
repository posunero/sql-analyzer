-- Example 28249
>>> database_role_reference.iter_grants_to()

-- Example 28250
>>> database_role_reference.revoke_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28251
>>> database_role_reference.revoke_grant_option_for_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28252
>>> database_role_reference.revoke_grant_option_for_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28253
>>> database_role_reference.revoke_grant_option_for_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28254
>>> database_role_reference.revoke_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28255
>>> database_role_reference.revoke_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28256
>>> database_role_reference.revoke("database role", Securable(name="test_role"))

-- Example 28257
>>> dynamic_table_reference.drop()

-- Example 28258
>>> my_dynamic_table = dynamic_table_reference.fetch()
>>> print(my_dynamic_table.name, my_dynamic_table.query)

-- Example 28259
>>> dynamic_table_reference.refresh()

-- Example 28260
>>> dynamic_table_reference.resume()

-- Example 28261
>>> dynamic_table_reference.resume_recluster()

-- Example 28262
>>> dynamic_table_reference.suspend()

-- Example 28263
>>> dynamic_table_reference.suspend_recluster()

-- Example 28264
>>> dynamic_table_reference.swap_with("my_other_dynamic_table")

-- Example 28265
>>> dynamic_table_reference.undrop()

-- Example 28266
>>> dynamic_tables = root.databases["my_db"].schemas["my_schema"].dynamic_tables
>>> dynamic_tables.create(
...     DynamicTable(
...        name="my_dynamic_table",
...        columns=[
...            DynamicTableColumn(name="c1"),
...            DynamicTableColumn(name='"cc2"', datatype="varchar"),
...        ],
...        warehouse=db_parameters["my_warehouse"],
...        target_lag=UserDefinedLag(seconds=60),
...        query="SELECT * FROM my_table",
...    ),
...    mode=CreateMode.error_if_exists,
... )

-- Example 28267
>>> dynamic_tables = root.databases["my_db"].schemas["my_schema"].dynamic_tables
>>> dynamic_tables.create(
...     DynamicTable(
...        name="my_dynamic_table",
...        columns=[
...            DynamicTableColumn(name="c1"),
...            DynamicTableColumn(name='"cc2"', datatype="varchar"),
...        ],
...        warehouse=db_parameters["my_warehouse"],
...        target_lag=UserDefinedLag(seconds=60),
...        query="SELECT * FROM my_table",
...    ),
...    mode=CreateMode.error_if_exists,
... )

-- Example 28268
>>> dynamic_tables = root.databases["my_db"].schemas["my_schema"].dynamic_tables
>>> dynamic_tables.create(
...     DynamicTableClone(
...         name="my_dynamic_table",
...         target_lag=UserDefinedLag(seconds=120),
...     ),
...     clone_table=Clone(
...         source="my_source_dynamic_table",
...         point_of_time=PointOfTimeOffset(reference="before", when="-1")
...     ),
...     copy_grants=True,
... )

-- Example 28269
>>> dynamic_tables = root.databases["my_db"].schemas["my_schema"].dynamic_tables
>>> dynamic_tables.create(
...     DynamicTableClone(
...         name="my_dynamic_table",
...         target_lag=UserDefinedLag(seconds=120),
...     ),
...     clone_table=Clone(
...         source="database_of_source_table.schema_of_source_table.my_source_dynamic_table",
...         point_of_time=PointOfTimeOffset(reference="before", when="-1")
...     ),
...     copy_grants=True,
... )

-- Example 28270
>>> dynamic_tables = dynamic_table_collection.iter()

-- Example 28271
>>> dynamic_tables = dynamic_table_collection.iter(like="your-dynamic-table-name")

-- Example 28272
>>> dynamic_tables = dynamic_table_collection.iter(like="your-dynamic-table-name-%")

-- Example 28273
>>> for dynamic_table in dynamic_tables:
...     print(dynamic_table.name, dynamic_table.query)

-- Example 28274
>>> event_table_reference.drop()

-- Example 28275
>>> event_table_reference.drop(if_exists = True)

-- Example 28276
>>> print(event_table_reference.fetch().created_on)

-- Example 28277
>>> event_table_reference.rename("my_other_event_table")

-- Example 28278
>>> event_table_reference.rename("my_other_event_table", if_exists = True)

-- Example 28279
>>> event_tables = schema.event_tables
>>> event_tables.create(new_event_table)

-- Example 28280
>>> event_tables = event_table_collection.iter()

-- Example 28281
>>> event_tables = event_table_collection.iter(like="your-event-table-name")

-- Example 28282
>>> event_tables = event_table_collection.iter(like="your-event-table-name-%")

-- Example 28283
>>> for event_table in event_tables:
...     print(event_table.name)

-- Example 28284
>>> external_volume_collection = root.external_volumes
>>> external_volume = ExternalVolume(
...     name="MY_EXTERNAL_VOLUME",
...     storage_location=StorageLocationS3(
...         name="abcd-my-s3-us-west-2",
...         storage_base_url="s3://MY_EXAMPLE_BUCKET/",
...         storage_aws_role_arn="arn:aws:iam::123456789022:role/myrole",
...         encryption=Encryption(type="AWS_SSE_KMS",
...                                kms_key_id="1234abcd-12ab-34cd-56ef-1234567890ab")
...     ),
...     comment="This is my external volume",
... )
>>> external_volume_collection.create(external_volume)

-- Example 28285
>>> external_volume_parameters = ExternalVolume(
...     name="MY_EXTERNAL_VOLUME",
...     storage_location=StorageLocationS3(
...         name="abcd-my-s3-us-west-2",
...         storage_base_url="s3://MY_EXAMPLE_BUCKET/",
...         storage_aws_role_arn="arn:aws:iam::123456789022:role/myrole",
...         encryption=Encryption(type="AWS_SSE_KMS",
...                                kms_key_id="1234abcd-12ab-34cd-56ef-1234567890ab")
...     ),
...     comment="This is my external volume",
... )
>>> # Use the external volume collection created before to create a referece to the external volume resource
>>> # in Snowflake.
>>> external_volume_reference = external_volume_collection.create(external_volume_parameters)

-- Example 28286
>>> external_volumes = external_volume_collection.iter()

-- Example 28287
>>> external_volumes = external_volume_collection.iter(like="your-external-volume-name")

-- Example 28288
>>> external_volumes = external_volume_collection.iter(like="your-external-volume-name%")

-- Example 28289
>>> for external_volume in external_volumes:
>>>     print(external_volume.name, external_volume.comment)

-- Example 28290
>>> external_volume_reference.drop()

-- Example 28291
>>> external_volume_reference.drop(if_exist=True)

-- Example 28292
>>> external_volume_reference.undrop()

-- Example 28293
>>> functions = root.databases["my_db"].schemas["my_schema"].functions
>>> new_function = Function(
...     name="foo",
...     returns="NUMBER",
...     arguments=[FunctionArgument(datatype="NUMBER")],
...     service="python",
...     endpoint="https://example.com",
...     path="example.py"
... )
>>> functions.create(new_function)

-- Example 28294
>>> functions = root.databases["my_db"].schemas["my_schema"].functions
>>> new_function = Function(
...     name="foo",
...     returns="NUMBER",
...     arguments=[FunctionArgument(datatype="NUMBER")],
...     service="python",
...     endpoint="https://example.com",
...     path="example.py"
... )
>>> functions.create(new_function, mode=CreateMode.or_replace)

-- Example 28295
>>> functions = function_collection.iter()

-- Example 28296
>>> functions = function_collection.iter(like="your-function-name")

-- Example 28297
>>> functions = function_collection.iter(like="your-function-name-%")

-- Example 28298
>>> for function in functions:
...     print(function.name)

-- Example 28299
>>> function_reference.delete()

-- Example 28300
>>> function_reference.delete(if_exists=True)
The `delete` method is deprecated; use `drop` instead.

-- Example 28301
>>> function_reference.drop()

-- Example 28302
>>> function_reference.drop(if_exists=True)

-- Example 28303
>>> function_reference.execute(input_args=[1, 2, "word"])

-- Example 28304
>>> function_reference = root.databases["my_db"].schemas["my_schema"].functions["foo(REAL)"]
>>> my_function = function_reference.fetch()
>>> print(my_function.name)

-- Example 28305
>>> from snowflake.core.grant import Grantees, Privileges, Securables
>>> Grant(grantee=Grantees.role(
...     name="test_role",
...     securable=Securables.current_account,
...     privileges=[Privileges.create_database],
... )

-- Example 28306
>>> root.grants.grant(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 28307
>>> root.grants.revoke(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 28308
>>> root.grants.revoke(
...     Grant(
...         grantee=Grantees.role(name=role_name),
...         securable=Securables.current_account,
...         privileges=[Privileges.create_database],
...     )
... )

-- Example 28309
>>> root.grants.to(
...    Grantee(
...         name="test-user",
...         grantee_type="user",
...     ),
...     limit = 10,
... )

-- Example 28310
>>> Grantee("test-user", "user")
>>> Grantee("test-role", "role")

-- Example 28311
>>> Grantees.role("test-role")
>>> Grantees.user("test-user")

-- Example 28312
>>> Securables.account("test-account")
>>> Securables.database("testdb")
>>> Securables.current_account

-- Example 28313
>>> iceberg_table.convert_to_managed()

-- Example 28314
>>> iceberg_table.convert_to_managed(if_exists=True)

-- Example 28315
>>> iceberg_table_reference.drop()

