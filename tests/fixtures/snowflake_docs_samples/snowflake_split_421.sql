-- Example 28182
>>> root.catalog_integrations.create(CatalogIntegration(
...     name = 'my_catalog_integration',
...     catalog = ObjectStore(),
...     table_format = "ICEBERG",
...     enabled = True,
... ))

-- Example 28183
>>> root.catalog_integrations.create(CatalogIntegration(
...     name = 'my_catalog_integration',
...     catalog = Polaris(
...         catalog_namespace="abcd-ns",
...         rest_config=RestConfig(
...             catalog_uri="https://my_account.snowflakecomputing.com/polaris/api/catalog",
...             warehouse_name="my_warehouse",
...         ),
...         rest_authenticator=OAuth(
...             type="OAUTH",
...             oauth_client_id="my_oauth_client_id",
...             oauth_client_secret="my_oauth_client_secret",
...             oauth_allowed_scopes=["PRINCIPAL_ROLE:ALL"],
...         ),
...     ),
...     table_format = "ICEBERG",
...     enabled = True,
... ))

-- Example 28184
>>> catalog_integrations = catalog_integration_collection.iter()

-- Example 28185
>>> catalog_integrations = catalog_integration_collection.iter(like="your-catalog-integration-name")

-- Example 28186
>>> catalog_integrations = catalog_integration_collection.iter(like="your-catalog-integration-name-%")

-- Example 28187
>>> for catalog_integration in catalog_integrations:
...     print(catalog_integration.name)

-- Example 28188
>>> compute_pool = ComputePool(name="my_compute_pool", instance_family="CPU_X64_XS", min_nodes=1, max_nodes=2)
>>> compute_pool_reference = root.compute_pools.create(compute_pool)

-- Example 28189
>>> compute_pool = ComputePool(name='my_compute_pool', instance_family="CPU_X64_XS", min_nodes=1, max_nodes=2)
>>> compute_pool_reference = compute_pools.create(compute_pool, mode=CreateMode.or_replace)

-- Example 28190
>>> compute_pool = ComputePool(name='my_compute_pool', instance_family="CPU_X64_XS", min_nodes=1, max_nodes=5)
>>> compute_pool_reference = compute_pools.create(compute_pool, initially_suspended=True)

-- Example 28191
>>> compute_pools = root.compute_pools.iter()

-- Example 28192
>>> compute_pools = root.compute_pools.iter(like="your-compute-pool-name")

-- Example 28193
>>> compute_pools = root.compute_pools.iter(like="your-compute-pool-name-%")

-- Example 28194
>>> for compute_pool in compute_pools:
>>>     print(compute_pool.name)

-- Example 28195
>>> cp_parameters = ComputePool(
...     name="your-cp-name",
...     instance_family="CPU_X64_XS",
...     min_nodes=1,
...     max_nodes=1,
...)

-- Example 28196
>>> compute_pool_reference.delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 28197
>>> compute_pool_reference.drop()

-- Example 28198
>>> my_compute_pool = compute_pool_reference.fetch()
>>> print(my_compute_pool.name)

-- Example 28199
>>> compute_pool_reference.resume()

-- Example 28200
>>> compute_pool_reference.stop_all_services()

-- Example 28201
>>> compute_pool_reference.suspend()

-- Example 28202
>>> future = api.create_cortex_search_service(database, var_schema, create_cortex_search_service_request, create_mode, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param create_cortex_search_service_request: (required)
:type create_cortex_search_service_request: CreateCortexSearchServiceRequest
:param create_mode: Query parameter allowing support for different modes of resource creation. Possible values include: - `errorIfExists`: Throws an error if you try to create a resource that already exists. - `orReplace`: Automatically replaces the existing resource with the current one. - `ifNotExists`: Creates a new resource when an alter is requested for a non-existent resource.
:type create_mode: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[SuccessResponse, Future[SuccessResponse]]

-- Example 28203
>>> future = api.create_cortex_search_service_with_http_info(database, var_schema, create_cortex_search_service_request, create_mode, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param create_cortex_search_service_request: (required)
:type create_cortex_search_service_request: CreateCortexSearchServiceRequest
:param create_mode: Query parameter allowing support for different modes of resource creation. Possible values include: - `errorIfExists`: Throws an error if you try to create a resource that already exists. - `orReplace`: Automatically replaces the existing resource with the current one. - `ifNotExists`: Creates a new resource when an alter is requested for a non-existent resource.
:type create_mode: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[SuccessResponse, Future[SuccessResponse]], status_code(int), headers(HTTPHeaderDict))

-- Example 28204
>>> future = api.delete_cortex_search_service(database, var_schema, name, if_exists, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[SuccessResponse, Future[SuccessResponse]]

-- Example 28205
>>> future = api.delete_cortex_search_service_with_http_info(database, var_schema, name, if_exists, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[SuccessResponse, Future[SuccessResponse]], status_code(int), headers(HTTPHeaderDict))

-- Example 28206
>>> future = api.fetch_cortex_search_service(database, var_schema, name, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[CortexSearchService, Future[CortexSearchService]]

-- Example 28207
>>> future = api.fetch_cortex_search_service_with_http_info(database, var_schema, name, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[CortexSearchService, Future[CortexSearchService]], status_code(int), headers(HTTPHeaderDict))

-- Example 28208
>>> future = api.list_cortex_search_services(database, var_schema, like, from_name, show_limit, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param like: Query parameter to filter the command output by resource name. Uses case-insensitive pattern matching, with support for SQL wildcard characters.
:type like: str
:param from_name: Query parameter to enable fetching rows only following the first row whose object name matches the specified string. Case-sensitive and does not have to be the full name.
:type from_name: str
:param show_limit: Query parameter to limit the maximum number of rows returned by a command.
:type show_limit: int
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[Iterable[CortexSearchService], Future[Iterable[CortexSearchService]]]

-- Example 28209
>>> future = api.list_cortex_search_services_with_http_info(database, var_schema, like, from_name, show_limit, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param like: Query parameter to filter the command output by resource name. Uses case-insensitive pattern matching, with support for SQL wildcard characters.
:type like: str
:param from_name: Query parameter to enable fetching rows only following the first row whose object name matches the specified string. Case-sensitive and does not have to be the full name.
:type from_name: str
:param show_limit: Query parameter to limit the maximum number of rows returned by a command.
:type show_limit: int
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[Iterable[CortexSearchService], Future[Iterable[CortexSearchService]]], status_code(int), headers(HTTPHeaderDict))

-- Example 28210
>>> future = api.query_cortex_search_service(database, var_schema, service_name, query_request, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param service_name: The name of the Cortex Search Service. (required)
:type service_name: str
:param query_request:
:type query_request: QueryRequest
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[QueryResponse, Future[QueryResponse]]

-- Example 28211
>>> future = api.query_cortex_search_service_with_http_info(database, var_schema, service_name, query_request, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param service_name: The name of the Cortex Search Service. (required)
:type service_name: str
:param query_request:
:type query_request: QueryRequest
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[QueryResponse, Future[QueryResponse]], status_code(int), headers(HTTPHeaderDict))

-- Example 28212
>>> future = api.resume_cortex_search_service(database, var_schema, name, if_exists, target, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param target: Query parameter that identifies the target to which suspension or resumption of the cortex search service should be applied.
:type target: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[SuccessResponse, Future[SuccessResponse]]

-- Example 28213
>>> future = api.resume_cortex_search_service_with_http_info(database, var_schema, name, if_exists, target, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param target: Query parameter that identifies the target to which suspension or resumption of the cortex search service should be applied.
:type target: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[SuccessResponse, Future[SuccessResponse]], status_code(int), headers(HTTPHeaderDict))

-- Example 28214
>>> future = api.suspend_cortex_search_service(database, var_schema, name, if_exists, target, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param target: Query parameter that identifies the target to which suspension or resumption of the cortex search service should be applied.
:type target: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: Union[SuccessResponse, Future[SuccessResponse]]

-- Example 28215
>>> future = api.suspend_cortex_search_service_with_http_info(database, var_schema, name, if_exists, target, async_req=True)
>>> result = future.result()
:param database: Identifier (i.e. name) for the database to which the resource belongs. You can use the `/api/v2/databases` GET request to get a list of available databases. (required)
:type database: str
:param var_schema: Identifier (i.e. name) for the schema to which the resource belongs. You can use the `/api/v2/databases/{database}/schemas` GET request to get a list of available schemas for the specified database. (required)
:type var_schema: str
:param name: Identifier (i.e. name) for the resource. (required)
:type name: str
:param if_exists: Query parameter that specifies how to handle the request for a resource that does not exist: - `true`: The endpoint does not throw an error if the resource does not exist. It returns a 200 success response, but does not take any action on the resource. - `false`: The endpoint throws an error if the resource doesn't exist.
:type if_exists: bool
:param target: Query parameter that identifies the target to which suspension or resumption of the cortex search service should be applied.
:type target: str
:param async_req: Whether to execute the request asynchronously.
:type async_req: bool, optional
:param _return_http_data_only: response data without head status code
                               and headers
:type _return_http_data_only: bool, optional
:param _preload_content: if False, the urllib3.HTTPResponse object will
                         be returned without reading/decoding response
                         data. Default is True.
:type _preload_content: bool, optional
:param _request_timeout: timeout setting for this request. If one
                         number provided, it will be total request
                         timeout. It can also be a pair (tuple) of
                         (connection, read) timeouts.
:param _request_auth: set to override the auth_settings for an a single
                      request; this effectively ignores the authentication
                      in the spec for a single request.
:type _request_auth: dict, optional
:type _content_type: string, optional: force content-type for the request
:return: Returns the result object.
         If the method is called asynchronously,
         returns a Future object representing the execution of the method.
:rtype: tuple(Union[SuccessResponse, Future[SuccessResponse]], status_code(int), headers(HTTPHeaderDict))

-- Example 28216
>>> databases = root.databases
>>> new_database = Database(
...     name="my_new_database",
...     comment="this is my new database to prototype a new feature in",
...    )
>>> databases.create(new_database)

-- Example 28217
>>> new_db_ref = root.databases.create(Database(name="my_new_database"), mode=CreateMode.if_not_exists)
>>> print(new_db_ref.fetch())

-- Example 28218
>>> databases = root.databases.iter()

-- Example 28219
>>> databases = root.databases.iter(like="your-database-name")

-- Example 28220
>>> databases = root.databases.iter(like="your-database-name-%")

-- Example 28221
>>> for database in databases:
>>>     print(database.name, database.query)

-- Example 28222
>>> root.databases["my_db"].database_roles

-- Example 28223
>>> root.databases["my_db"].schemas

-- Example 28224
>>> root.databases["my_new_db"].create_or_update(Database("my_new_db"))

-- Example 28225
>>> root.databases["to_be_deleted"].delete()
The `delete` method is deprecated; use `drop` instead.

-- Example 28226
>>> root.databases["my_db"].enable_failover(accounts=["old_failover_acc"])

-- Example 28227
>>> root.databases["my_db"].disable_replication()

-- Example 28228
>>> root.databases["to_be_dropped"].drop()

-- Example 28229
>>> root.databases["to_be_dropped"].drop(if_exists=True)

-- Example 28230
>>> root.databases["my_db"].enable_failover(accounts=["my_failover_acc"])

-- Example 28231
>>> root.databases["my_db"].enable_replication(
...     accounts=["accountName1", "accountName2"],
...     ignore_edition_check=True,
... )

-- Example 28232
>>> my_database = root.databases["my_db"].fetch()
>>> print(my_database.is_current)

-- Example 28233
>>> root.databases["my_db"].promote_to_primary_failover()

-- Example 28234
>>> root.databases["db_replication"].refresh_replication()

-- Example 28235
>>> root.databases["to_be_undropped"].undrop()

-- Example 28236
>>> database_role_collection = root.databases["my_db"].database_roles
>>> database_role_collection.create(DatabaseRole(
...     name="test-role",
...     comment="samplecomment"
... ))

-- Example 28237
>>> database_role = DatabaseRole(
...     name="test-role",
...     comment="samplecomment"
... )
>>> database_role_ref = root.databases["my_db"].database_roles.create(database_role, mode=CreateMode.or_replace)

-- Example 28238
>>> database_roles = database_role_collection.iter()

-- Example 28239
>>> database_roles = database_role_collection.iter(from_name="your-role-name-")

-- Example 28240
>>> for database_role in database_roles:
...    print(database_role.name, database_role.comment)

-- Example 28241
>>> new_database_role_reference = database_role_reference.clone("new-role-name")

-- Example 28242
>>> database_role_reference.drop()

-- Example 28243
>>> database_role_reference.drop(if_exists=True)

-- Example 28244
>>> database_role_reference.grant_future_privileges(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28245
>>> database_role_reference.grant_privileges(["CREATE", "USAGE"], "database", Securable(database="test_db"))

-- Example 28246
>>> database_role_reference.grant_privileges_on_all(["CREATE", "USAGE"], "schema", ContainingScope(database="test_db"))

-- Example 28247
>>> database_role_reference.grant("database role", Securable(name="test_role"))

-- Example 28248
>>> database_role_reference.iter_future_grants_to()

