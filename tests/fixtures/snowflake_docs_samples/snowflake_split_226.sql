-- Example 15122
>>> database_roles = database_role_collection.iter()

-- Example 15123
>>> database_roles = database_role_collection.iter(from_name="your-role-name-")

-- Example 15124
>>> for database_role in database_roles:
...    print(database_role.name, database_role.comment)

-- Example 15125
>>> new_database_role_reference = database_role_reference.clone("new-role-name")

-- Example 15126
>>> database_role_reference.drop()

-- Example 15127
>>> database_role_reference.drop(if_exists=True)

-- Example 15128
>>> database_role_reference.grant_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15129
>>> database_role_reference.grant_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15130
>>> database_role_reference.grant_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15131
>>> database_role_reference.grant("database role", Securable(name="test_role"))

-- Example 15132
>>> database_role_reference.iter_future_grants_to()

-- Example 15133
>>> database_role_reference.iter_grants_to()

-- Example 15134
>>> database_role_reference.revoke_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15135
>>> database_role_reference.revoke_grant_option_for_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15136
>>> database_role_reference.revoke_grant_option_for_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15137
>>> database_role_reference.revoke_grant_option_for_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15138
>>> database_role_reference.revoke_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15139
>>> database_role_reference.revoke_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15140
>>> database_role_reference.revoke("database role", Securable(name="test_role"))

-- Example 15141
>>> dynamic_table_reference.drop()

-- Example 15142
>>> my_dynamic_table = dynamic_table_reference.fetch()
>>> print(my_dynamic_table.name, my_dynamic_table.query)

-- Example 15143
>>> dynamic_table_reference.refresh()

-- Example 15144
>>> dynamic_table_reference.resume()

-- Example 15145
>>> dynamic_table_reference.resume_recluster()

-- Example 15146
>>> dynamic_table_reference.suspend()

-- Example 15147
>>> dynamic_table_reference.suspend_recluster()

-- Example 15148
>>> dynamic_table_reference.swap_with("my_other_dynamic_table")

-- Example 15149
>>> dynamic_table_reference.undrop()

-- Example 15150
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

-- Example 15151
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

-- Example 15152
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

-- Example 15153
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

-- Example 15154
>>> dynamic_tables = dynamic_table_collection.iter()

-- Example 15155
>>> dynamic_tables = dynamic_table_collection.iter(like="your-dynamic-table-name")

-- Example 15156
>>> dynamic_tables = dynamic_table_collection.iter(like="your-dynamic-table-name-%")

-- Example 15157
>>> for dynamic_table in dynamic_tables:
...     print(dynamic_table.name, dynamic_table.query)

-- Example 15158
>>> event_table_reference.drop()

-- Example 15159
>>> event_table_reference.drop(if_exists = True)

-- Example 15160
>>> print(event_table_reference.fetch().created_on)

-- Example 15161
>>> event_table_reference.rename("my_other_event_table")

-- Example 15162
>>> event_table_reference.rename("my_other_event_table", if_exists = True)

-- Example 15163
>>> event_tables = schema.event_tables
>>> event_tables.create(new_event_table)

-- Example 15164
>>> event_tables = event_table_collection.iter()

-- Example 15165
>>> event_tables = event_table_collection.iter(like="your-event-table-name")

-- Example 15166
>>> event_tables = event_table_collection.iter(like="your-event-table-name-%")

-- Example 15167
>>> for event_table in event_tables:
...     print(event_table.name)

-- Example 15168
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

-- Example 15169
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

-- Example 15170
>>> external_volumes = external_volume_collection.iter()

-- Example 15171
>>> external_volumes = external_volume_collection.iter(like="your-external-volume-name")

-- Example 15172
>>> external_volumes = external_volume_collection.iter(like="your-external-volume-name%")

-- Example 15173
>>> for external_volume in external_volumes:
>>>     print(external_volume.name, external_volume.comment)

-- Example 15174
>>> external_volume_reference.drop()

-- Example 15175
>>> external_volume_reference.drop(if_exist=True)

-- Example 15176
>>> external_volume_reference.undrop()

-- Example 15177
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

-- Example 15178
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

-- Example 15179
>>> functions = function_collection.iter()

-- Example 15180
>>> functions = function_collection.iter(like="your-function-name")

-- Example 15181
>>> functions = function_collection.iter(like="your-function-name-%")

-- Example 15182
>>> for function in functions:
...     print(function.name)

-- Example 15183
>>> function_reference.delete()

-- Example 15184
>>> function_reference.delete(if_exists=True)
The `delete` method is deprecated; use `drop` instead.

-- Example 15185
>>> function_reference.drop()

-- Example 15186
>>> function_reference.drop(if_exists=True)

-- Example 15187
>>> function_reference.execute(input_args=[1, 2, "word"])

-- Example 15188
>>> function_reference = root.databases["my_db"].schemas["my_schema"].functions["foo(REAL)"]
>>> my_function = function_reference.fetch()
>>> print(my_function.name)

