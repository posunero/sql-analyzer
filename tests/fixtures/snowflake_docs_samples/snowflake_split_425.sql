-- Example 28450
>>> schema_reference.delete(if_exists=True)
The `delete` method is deprecated; use `drop` instead.

-- Example 28451
>>> schema_reference.drop()

-- Example 28452
>>> schema_reference.drop(if_exists=True)

-- Example 28453
>>> my_schema = my_db.schemas["my_schema"].fetch()
>>> print(my_schema.name, my_schema.is_current)

-- Example 28454
>>> schema_reference.drop()
>>> schema_reference.undrop()

-- Example 28455
>>> my_service = Service(
...     name="my_service",
...     min_instances=1,
...     max_instances=2,
...     compute_pool="my_compute_pool",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml")
...    )
>>> root.databases["my_db"].schemas["my_schema"].services.create(my_service)

-- Example 28456
>>> services = root.databases["my_db"].schemas["my_schema"].services
>>> my_service = Service(
...     name="my_service",
...     compute_pool="my_compute_pool",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml")
... )
>>> services.create(my_service, mode=CreateMode.or_replace)

-- Example 28457
>>> job_service = JobService(
...     name="my_job_service",
...     compute_pool="my_cp",
...     spec=ServiceSpec("@my_stage/my_service_spec.yaml"),
... )
>>> services.execute_job(job_service)

-- Example 28458
>>> services = service_collection.iter()

-- Example 28459
>>> services = service_collection.iter(like="your-service-name")

-- Example 28460
>>> services = service_collection.iter(like="your-service-name-%")

-- Example 28461
>>> for service in services:
>>>    print(service.name)

-- Example 28462
>>> service_parameters = Service(
...     name="your-service-name",
...     compute_pool="my_cp"
...     spec=ServiceSpecStageFile(stage="stage_name", spec_file=spec_file),
...)
>>> services = root.databases["my_db"].schemas["my_schema"].services
>>> services["your-service-name"].create_or_alter(service_parameters)

-- Example 28463
>>> service_reference.drop()

-- Example 28464
>>> service_reference.fetch()

-- Example 28465
>>> service_reference.get_containers()

-- Example 28466
>>> service_reference.get_endpoints()

-- Example 28467
>>> service_reference.get_instances()

-- Example 28468
>>> service_reference.get_roles()

-- Example 28469
>>> service_reference.get_service_logs(instance_id="instance_id", container_name="container_name")

-- Example 28470
>>> service_reference.get_service_status()

-- Example 28471
>>> service_reference.get_service_status(timeout=10)

-- Example 28472
>>> service_reference.iter_grants_of_service_role("all_endpoints_usage")

-- Example 28473
>>> service_reference.iter_grants_to_service_role("all_endpoints_usage")

-- Example 28474
>>> service_reference.resume()

-- Example 28475
>>> service_reference.suspend()

-- Example 28476
>>> stage_reference.drop()

-- Example 28477
>>> my_stage = stage_reference.fetch()
>>> print(my_stage.name)

-- Example 28478
>>> stage_reference.get("/folder/file_name.txt", "/local_folder")

-- Example 28479
>>> stage_reference.get("/folder", "/local_folder", pattern=".*.txt")

-- Example 28480
>>> files = stage_reference.list_files()

-- Example 28481
>>> files = stage_reference.list_files(pattern=".*.txt")

-- Example 28482
>>> for file in files:
...     print(file.name)

-- Example 28483
>>> stage_reference.put("local_file.csv", "/folder", auto_compress=True)

-- Example 28484
>>> stages = root.databases["my_db"].schemas["my_schema"].stages
>>> new_stage = Stage(
...     name="my_stage",
...     comment="This is a stage",
... )
>>> stages.create(new_stage)

-- Example 28485
>>> stages = root.databases["my_db"].schemas["my_schema"].stages
>>> new_stage = Stage(
...     name="my_stage",
...     comment="This is a stage",
... )
>>> stages.create(new_stage, mode=CreateMode.or_replace)

-- Example 28486
>>> stages = stage_collection.iter()

-- Example 28487
>>> stages = stage_collection.iter(like="your-stage-name")

-- Example 28488
>>> stages = stage_collection.iter(like="your-stage-name-%")

-- Example 28489
>>> for stage in stages:
...     print(stage.name)

-- Example 28490
>>> stream_reference.drop()

-- Example 28491
>>> stream_reference.drop(if_exists = True)

-- Example 28492
>>> print(stream_reference.fetch().created_on)

-- Example 28493
>>> streams = schema.streams
>>> streams.create(
...     "new_stream_name",
...     clone_stream="stream_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 28494
>>> streams = schema.streams
>>> streams.create(
...     "new_stream_name",
...     clone_stream="stream_database_name.stream_schema_name.stream_name_to_be_cloned",
...     mode=CreateMode.if_not_exists,
...     copy_grants=True
... )

-- Example 28495
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

-- Example 28496
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

-- Example 28497
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

-- Example 28498
>>> streams = stream_collection.iter()

-- Example 28499
>>> streams = stream_collection.iter(like="your-stream-name")

-- Example 28500
>>> streams = stream_collection.iter(like="your-stream-name-%")

-- Example 28501
>>> for stream in streams:
...     print(stream.name)

-- Example 28502
>>> my_schema.table["my_table"].create_or_alter(my_table_def)

-- Example 28503
>>> my_schema.table["my_table"].create_or_update(my_table_def)

-- Example 28504
>>> table_ref.delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 28505
>>> table_ref.drop()

-- Example 28506
>>> table_ref = my_schema.tables["my_table"].fetch()
>>> print(table_ref.comment)

-- Example 28507
>>> my_schema.tables["my_table"].resume_recluster()

-- Example 28508
>>> my_schema.tables["my_table"].suspend_recluster()

-- Example 28509
>>> my_table = my_schema.tables["my_table"].swap("other_table")

-- Example 28510
>>> table_ref.delete()
>>> table_ref.undelete()
The `undelete` method is deprecated; use `undrop` instead.

-- Example 28511
>>> table_ref.drop()
>>> table_ref.undrop()

-- Example 28512
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> new_table = Table(
...     name="accounts",
...     columns=[
...         TableColumn(
...             name="id",
...             datatype="int",
...             nullable=False,
...             autoincrement=True,
...             autoincrement_start=0,
...             autoincrement_increment=1,
...         ),
...         TableColumn(name="created_on", datatype="timestamp_tz", nullable=False),
...         TableColumn(name="email", datatype="string", nullable=False),
...         TableColumn(name="password_hash", datatype="string", nullable=False),
...     ],
... )
>>> tables.create(new_tables)

-- Example 28513
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> new_table = Table(
...     name="events",
...     columns=[
...         TableColumn(
...             name="id",
...             datatype="int",
...             nullable=False,
...             autoincrement=True,
...             autoincrement_start=0,
...             autoincrement_increment=1,
...         ),
...         TableColumn(name="category", datatype="string"),
...         TableColumn(name="event", datatype="string"),
...     ],
...     comment="store events/logs in here",
... )
>>> tables.create(new_tables)

-- Example 28514
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> tables.create("new_table", clone_table="original_table_name")

-- Example 28515
>>> tables = root.databases["my_db"].schemas["my_schema"].tables
>>> tables.create("new_table", clone_table="database_name.schema_name.original_table_name")

-- Example 28516
>>> tables = my_schema.tables.iter()

