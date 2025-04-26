-- Example 28383
>>> pipes = pipe_collection.iter(like="your-pipe-name%")

-- Example 28384
>>> for pipe in pipes:
>>>     print(pipe.name, pipe.comment)

-- Example 28385
>>> pipe_reference.drop()

-- Example 28386
>>> pipe_reference.drop(if_exists=True)

-- Example 28387
>>> pipe = pipe_reference.fetch()
# Accessing information of the pipe with pipe instance.
>>> print(pipe.name, pipe.comment)

-- Example 28388
>>> pipe_reference.refresh(prefix="your_prefix")

-- Example 28389
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

-- Example 28390
>>> procedure = Procedure(
...     name="my_procedure",
...     arguments=[],
...     return_type=ReturnDataType(datatype="FLOAT"),
...     language_config=JavaScriptFunction(),
...     body="return 3.14;"
... )
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures
>>> procedures.create(procedure, mode=CreateMode.or_replace)

-- Example 28391
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter()

-- Example 28392
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="your-procedure-name")

-- Example 28393
>>> procedures = root.databases["my_db"].schemas["my_schema"].procedures.iter(like="your-procedure-name-%")

-- Example 28394
>>> for procedure in procedures:
...     print(procedure.name)

-- Example 28395
>>> procedure_reference.call(call_argument_list=CallArgumentList(call_arguments=[]))

-- Example 28396
>>> procedure_reference.call(call_argument_list=CallArgumentList(call_arguments=[
...     CallArgument(name="id", datatype="NUMBER", value=1),
...     CallArgument(name="tableName", datatype="VARCHAR", value="my_table_name"),
... ]))

-- Example 28397
>>> procedure_reference.drop()

-- Example 28398
>>> procedure_reference.drop(if_exists=True)

-- Example 28399
>>> my_procedure = procedure_reference.fetch()
>>> print(my_procedure.name)

-- Example 28400
>>> role_collection = root.roles
>>> role_collection.create(Role(
...     name="test-role",
...     comment="samplecomment"
... ))

-- Example 28401
>>> role = Role(
...     name="test-role",
...     comment="samplecomment"
... )
>>> role_ref = root.roles.create(role, mode=CreateMode.or_replace)

-- Example 28402
>>> roles = role_collection.iter()

-- Example 28403
>>> roles = role_collection.iter(like="your-role-name")

-- Example 28404
>>> roles = role_collection.iter(like="your-role-name-%")
>>> roles = role_collection.iter(starts_with="your-role-name")

-- Example 28405
>>> for role in roles:
...    print(role.name, role.comment)

-- Example 28406
>>> role_reference.drop()

-- Example 28407
>>> reference_role.grant_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28408
>>> reference_role.grant_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28409
>>> reference_role.grant_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28410
>>> reference_role.grant("role", Securable(name="test_role"))

-- Example 28411
>>> reference_role.iter_future_grants_to()

-- Example 28412
>>> reference_role.iter_grants_of()

-- Example 28413
>>> reference_role.iter_grants_on()

-- Example 28414
>>> reference_role.iter_grants_to()

-- Example 28415
>>> reference_role.revoke_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28416
>>> reference_role.revoke_grant_option_for_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28417
>>> reference_role.revoke_grant_option_for_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28418
>>> reference_role.revoke_grant_option_for_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28419
>>> reference_role.revoke_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28420
>>> reference_role.revoke_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28421
>>> reference_role.revoke("role", Securable(name="test_role"))

-- Example 28422
>>> schemas = root.databases["my_db"].schemas
>>> new_schema = Schema("my_schema")
>>> schemas.create(new_schema)

-- Example 28423
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(Schema("new_schema"))

-- Example 28424
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(
...     "new_schema",
...     clone = Clone(source="original_schema", point_of_time=PointOfTimeOffset(reference="at", when="-5")),
...     mode = CreateMode.or_replace
... )

-- Example 28425
>>> schemas = root.databases["my_db"].schemas
>>> new_schema_ref = schemas.create(
...     "new_schema",
...     clone = Clone(
...         source="another_database.original_schema",
...         point_of_time=PointOfTimeOffset(reference="at", when="-5")
...     ),
...     mode = CreateMode.or_replace
... )

-- Example 28426
>>> schemas = db_ref.schemas.iter()

-- Example 28427
>>> schemas = db_ref.schemas.iter(like="your-schema-name")

-- Example 28428
>>> schemas = db_ref.schemas.iter(like="your-schema-name-%")

-- Example 28429
>>> for schema in schemas:
>>>     print(schema.name, schema.query)

-- Example 28430
>>> my_db.schemas["my_schema"].alerts

-- Example 28431
>>> my_db.schemas["my_schema"].cortex_search_service

-- Example 28432
>>> my_db.schemas["my_schema"].dynamic_tables

-- Example 28433
>>> my_db.schemas["my_schema"].events

-- Example 28434
>>> my_db.schemas["my_schema"].functions

-- Example 28435
>>> my_db.schemas["my_schema"].iceberg_tables

-- Example 28436
>>> my_db.schemas["my_schema"].image_repositories

-- Example 28437
>>> my_db.schemas["my_schema"].notebooks

-- Example 28438
>>> my_db.schemas["my_schema"].pipes

-- Example 28439
>>> root = Root(session)
>>> procedure = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure"]

-- Example 28440
>>> my_db.schemas["my_schema"].services

-- Example 28441
>>> my_db.schemas["my_schema"].stages

-- Example 28442
>>> my_db.schemas["my_schema"].streams

-- Example 28443
>>> my_db.schemas["my_schema"].tables

-- Example 28444
>>> my_db.schemas["my_schema"].tasks

-- Example 28445
>>> my_db.schemas["my_schema"].user_defined_functions

-- Example 28446
>>> my_db.schemas["my_schema"].views

-- Example 28447
>>> my_db.schemas["my_new_schema"].create_or_alter(Schema("my_new_schema"))

-- Example 28448
>>> my_db.schemas["my_new_schema"].create_or_update(Schema("my_new_schema"))
The `create_or_update` method is deprecated; use `create_or_alter` instead.

-- Example 28449
>>> schema_reference.delete()

