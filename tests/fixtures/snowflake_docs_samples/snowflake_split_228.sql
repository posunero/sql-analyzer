-- Example 15256
>>> notification_integrations = notification_integrations.iter()

-- Example 15257
>>> notification_integrations = notification_integrations.iter(like="your-notification-integration-name")

-- Example 15258
>>> notification_integrations = notification_integrations.iter(like="your-notification-integration-name-%")

-- Example 15259
>>> for notification_integration in notification_integrations:
>>>     print(
...         notification_integration.name,
...         notification_integration.enabled,
...         repr(notification_integration.notification_hook),
...     )

-- Example 15260
>>> ni_reference.drop()

-- Example 15261
>>> ni_reference.drop(if_exists=True)

-- Example 15262
>>> my_ni = ni_reference.fetch()
>>> print(my_ni.name, my_ni.enabled, repr(my_ni.notification_hook))

-- Example 15263
>>> pipes = root.databases["my_db"].schemas["my_schema"].pipes
>>>     new_pipe = Pipe(
...         name="my_pipe",
...         comment="This is a pipe")
>>> pipes.create(new_pipe)

-- Example 15264
>>> pipe_parameters = Pipe(
...     name="my_pipe",
...     comment="This is a pipe"
... )
>>> # Use the pipe collection created before to create a referece to the pipe resource
>>> # in Snowflake.
>>> pipe_reference = pipe_collection.create(pipe_parameters)

-- Example 15265
>>> pipes = pipe_collection.iter()

-- Example 15266
>>> pipes = pipe_collection.iter(like="your-pipe-name")

-- Example 15267
>>> pipes = pipe_collection.iter(like="your-pipe-name%")

-- Example 15268
>>> for pipe in pipes:
>>>     print(pipe.name, pipe.comment)

-- Example 15269
>>> pipe_reference.drop()

-- Example 15270
>>> pipe_reference.drop(if_exists=True)

-- Example 15271
>>> pipe = pipe_reference.fetch()
# Accessing information of the pipe with pipe instance.
>>> print(pipe.name, pipe.comment)

-- Example 15272
>>> pipe_reference.refresh(prefix="your_prefix")

-- Example 15273
>>> procedure = Procedure(
...     name="sql_proc_table_func",
...     arguments=[Argument(name="id", datatype="VARCHAR")],
...     return_type=ReturnTable(
...         column_list=[
...             ColumnType(name="id", datatype="NUMBER"),
...             ColumnType(name="price", datatype="NUMBER"),
...         ]
...     ),
...     language_config=SQLFunction(),
...     body="
...         DECLARE
...             res RESULTSET DEFAULT (SELECT * FROM invoices WHERE id = :id);
...         BEGIN
...             RETURN TABLE(res);
...         END;
...     ",
... )
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures
>>> procedures.create(procedure)

-- Example 15274
>>> procedure = Procedure(
...     name="my_procedure",
...     arguments=[],
...     return_type=ReturnDataType(datatype="FLOAT"),
...     language_config=JavaScriptFunction(),
...     body="return 3.14;"
... )
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures
>>> procedures.create(procedure, mode=CreateMode.or_replace)

-- Example 15275
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter()

-- Example 15276
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="your-procedure-name")

-- Example 15277
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="your-procedure-name-%")

-- Example 15278
>>> for procedure in procedures:
...     print(procedure.name)

-- Example 15279
>>> procedure_reference.call(call_argument_list=CallArgumentList(call_arguments=[]))

-- Example 15280
>>> procedure_reference.call(call_argument_list=CallArgumentList(call_arguments=[
...     CallArgument(name="id", datatype="NUMBER", value=1),
...     CallArgument(name="tableName", datatype="VARCHAR", value="my_table_name"),
... ]))

-- Example 15281
>>> procedure_reference.drop()

-- Example 15282
>>> procedure_reference.drop(if_exists=True)

-- Example 15283
>>> my_procedure = procedure_reference.fetch()
>>> print(my_procedure.name)

-- Example 15284
>>> role_collection = root.roles
>>> role_collection.create(Role(
...     name="test-role",
...     comment="samplecomment"
... ))

-- Example 15285
>>> role = Role(
...     name="test-role",
...     comment="samplecomment"
... )
>>> role_ref = root.roles.create(role, mode=CreateMode.or_replace)

-- Example 15286
>>> roles = role_collection.iter()

-- Example 15287
>>> roles = role_collection.iter(like="your-role-name")

-- Example 15288
>>> roles = role_collection.iter(like="your-role-name-%")
>>> roles = role_collection.iter(starts_with="your-role-name")

-- Example 15289
>>> for role in roles:
...    print(role.name, role.comment)

-- Example 15290
>>> role_reference.drop()

-- Example 15291
>>> reference_role.grant_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15292
>>> reference_role.grant_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15293
>>> reference_role.grant_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15294
>>> reference_role.grant("role", Securable(name="test_role"))

-- Example 15295
>>> reference_role.iter_future_grants_to()

-- Example 15296
>>> reference_role.iter_grants_of()

-- Example 15297
>>> reference_role.iter_grants_on()

-- Example 15298
>>> reference_role.iter_grants_to()

-- Example 15299
>>> reference_role.revoke_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15300
>>> reference_role.revoke_grant_option_for_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15301
>>> reference_role.revoke_grant_option_for_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15302
>>> reference_role.revoke_grant_option_for_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15303
>>> reference_role.revoke_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 15304
>>> reference_role.revoke_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 15305
>>> reference_role.revoke("role", Securable(name="test_role"))

-- Example 15306
>>> schemas = root.databases["my_db"].schemas
>>> new_schema = Schema("my_schema")
>>> schemas.create(new_schema)

-- Example 15307
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(Schema("new_schema"))

-- Example 15308
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(
...     "new_schema",
...     clone = Clone(source="original_schema", point_of_time=PointOfTimeOffset(reference="at", when="-5")),
...     mode = CreateMode.or_replace
... )

-- Example 15309
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(
...     "new_schema",
...     clone = Clone(
...         source="another_database.original_schema",
...         point_of_time=PointOfTimeOffset(reference="at", when="-5")
...     ),
...     mode = CreateMode.or_replace
... )

-- Example 15310
>>> schemas = db_ref.schemas.iter()

-- Example 15311
>>> schemas = db_ref.schemas.iter(like="your-schema-name")

-- Example 15312
>>> schemas = db_ref.schemas.iter(like="your-schema-name-%")

-- Example 15313
>>> for schema in schemas:
>>>     print(schema.name, schema.query)

-- Example 15314
>>> my_db.schemas["my_schema"].alerts

-- Example 15315
>>> my_db.schemas["my_schema"].cortex_search_service

-- Example 15316
>>> my_db.schemas["my_schema"].dynamic_tables

-- Example 15317
>>> my_db.schemas["my_schema"].events

-- Example 15318
>>> my_db.schemas["my_schema"].functions

-- Example 15319
>>> my_db.schemas["my_schema"].iceberg_tables

-- Example 15320
>>> my_db.schemas["my_schema"].image_repositories

-- Example 15321
>>> my_db.schemas["my_schema"].notebooks

-- Example 15322
>>> my_db.schemas["my_schema"].pipes

