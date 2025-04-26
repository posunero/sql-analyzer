-- Example 15323
>>> root = Root(session)
>>> procedure = root.databases["my_db"].schemas["my_schema"].procedures["my_procedure"]

-- Example 15324
>>> my_db.schemas["my_schema"].services

-- Example 15325
>>> my_db.schemas["my_schema"].stages

-- Example 15326
>>> my_db.schemas["my_schema"].streams

-- Example 15327
>>> my_db.schemas["my_schema"].tables

-- Example 15328
>>> my_db.schemas["my_schema"].tasks

-- Example 15329
>>> my_db.schemas["my_schema"].user_defined_functions

-- Example 15330
>>> my_db.schemas["my_schema"].views

-- Example 15331
>>> my_db.schemas["my_new_schema"].create_or_alter(Schema("my_new_schema"))

-- Example 15332
>>> my_db.schemas["my_new_schema"].create_or_update(Schema("my_new_schema"))
The `create_or_update` method is deprecated; use `create_or_alter` instead.

-- Example 15333
>>> schema_reference.delete()

-- Example 15334
>>> schema_reference.delete(if_exists=True)
The `delete` method is deprecated; use `drop` instead.

-- Example 15335
>>> schema_reference.drop()

-- Example 15336
>>> schema_reference.drop(if_exists=True)

-- Example 15337
>>> my_schema = my_db.schemas["my_schema"].fetch()
>>> print(my_schema.name, my_schema.is_current)

-- Example 15338
>>> schema_reference.drop()
>>> schema_reference.undrop()

-- Example 15339
>>> my_service = Service(
...     name="my_service",
...     min_instances=1,
...     max_instances=2,
...     compute_pool="my_compute_pool",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml")
...    )
>>> root.databases["my_db"].schemas["my_schema"].services.create(my_service)

-- Example 15340
>>> services = root.databases["my_db"].schemas["my_schema"].services
>>> my_service = Service(
...     name="my_service",
...     compute_pool="my_compute_pool",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml")
... )
>>> services.create(my_service, mode=CreateMode.or_replace)

-- Example 15341
>>> job_service = JobService(
...     name="my_job_service",
...     compute_pool="my_cp",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml"),
... )
>>> services.execute_job(job_service)

-- Example 15342
>>> services = service_collection.iter()

-- Example 15343
>>> services = service_collection.iter(like="your-service-name")

-- Example 15344
>>> services = service_collection.iter(like="your-service-name-%")

-- Example 15345
>>> for service in services:
>>>    print(service.name)

-- Example 15346
>>> service_parameters = Service(
...     name="your-service-name",
...     compute_pool="my_cp"
...     spec=ServiceSpecStageFile(stage="stage_name", spec_file=spec_file),
...)
>>> services = root.databases["my_db"].schemas["my_schema"].services
>>> services["your-service-name"].create_or_alter(service_parameters)

-- Example 15347
>>> service_reference.drop()

-- Example 15348
>>> service_reference.fetch()

-- Example 15349
>>> service_reference.get_containers()

-- Example 15350
>>> service_reference.get_endpoints()

-- Example 15351
>>> service_reference.get_instances()

-- Example 15352
>>> service_reference.get_roles()

-- Example 15353
>>> service_reference.get_service_logs(instance_id="instance_id", container_name="container_name")

-- Example 15354
>>> service_reference.get_service_status()

-- Example 15355
>>> service_reference.get_service_status(timeout=10)

-- Example 15356
>>> service_reference.iter_grants_of_service_role("all_endpoints_usage")

-- Example 15357
>>> service_reference.iter_grants_to_service_role("all_endpoints_usage")

-- Example 15358
>>> service_reference.resume()

-- Example 15359
>>> service_reference.suspend()

-- Example 15360
>>> stage_reference.drop()

-- Example 15361
>>> my_stage = stage_reference.fetch()
>>> print(my_stage.name)

-- Example 15362
>>> stage_reference.get("/folder/file_name.txt", "/local_folder")

-- Example 15363
>>> stage_reference.get("/folder", "/local_folder", pattern=".*.txt")

-- Example 15364
>>> files = stage_reference.list_files()

-- Example 15365
>>> files = stage_reference.list_files(pattern=".*.txt")

-- Example 15366
>>> for file in files:
...     print(file.name)

-- Example 15367
>>> stage_reference.put("local_file.csv", "/folder", auto_compress=True)

-- Example 15368
>>> stages = root.databases["my_db"].schemas["my_schema"].stages
>>> new_stage = Stage(
...     name="my_stage",
...     comment="This is a stage",
... )
>>> stages.create(new_stage)

-- Example 15369
>>> stages = root.databases["my_db"].schemas["my_schema"].stages
>>> new_stage = Stage(
...     name="my_stage",
...     comment="This is a stage",
... )
>>> stages.create(new_stage, mode=CreateMode.or_replace)

-- Example 15370
>>> stages = stage_collection.iter()

-- Example 15371
>>> stages = stage_collection.iter(like="your-stage-name")

-- Example 15372
>>> stages = stage_collection.iter(like="your-stage-name-%")

-- Example 15373
>>> for stage in stages:
...     print(stage.name)

-- Example 15374
>>> stream_reference.drop()

-- Example 15375
>>> stream_reference.drop(if_exists = True)

-- Example 15376
>>> print(stream_reference.fetch().created_on)

-- Example 15377
>>> streams = schema.streams
>>> streams.create(
...     "new_stream_name",
...     clone_stream="stream_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 15378
>>> streams = schema.streams
>>> streams.create(
...     "new_stream_name",
...     clone_stream="stream_database_name.stream_schema_name.stream_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 15379
>>> streams.create(
...     Stream(
...         name = "new_stream_name",
...         stream_source = StreamSourceTable(
...             point_of_time = PointOfTimeOffset(reference="before", offset="1"),
...             name = "my_source_table_name"
...             append_only = True,
...             show_initial_rows = False,
...             comment = "create stream by table"
...         )
...     ),
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 15380
>>> streams.create(
...     Stream(
...         name = "new_stream_name",
...         stream_source = StreamSourceView(
...             point_of_time = PointOfTimeOffset(reference="before", offset="1"),
...             name = "my_source_view_name"
...         )
...     ),
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 15381
>>> streams.create(
...     Stream(
...         name = "new_stream_name",
...         stream_source = StreamSourceStage(
...             point_of_time = PointOfTimeOffset(reference="before", offset="1"),
...             name = "my_source_directory_table_name"
...         )
...     ),
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 15382
>>> streams = stream_collection.iter()

-- Example 15383
>>> streams = stream_collection.iter(like="your-stream-name")

-- Example 15384
>>> streams = stream_collection.iter(like="your-stream-name-%")

-- Example 15385
>>> for stream in streams:
...     print(stream.name)

-- Example 15386
>>> my_schema.table["my_table"].create_or_alter(my_table_def)

-- Example 15387
>>> my_schema.table["my_table"].create_or_update(my_table_def)

-- Example 15388
>>> table_ref.delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 15389
>>> table_ref.drop()

