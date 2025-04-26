-- Example 27378
-------------------------------------------------------------------------------------------------------------------------------------------
| TIME               | HANDLER_NAME                                          | HANDLER_TYPE | EVENT_NAME              | ATTRIBUTES        |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_init          |                   |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_process       | { "input": "42" } |
-------------------------------------------------------------------------------------------------------------------------------------------
| 2023-04-20 0:45:49 | DIGITS_OF_NUMBER(INPUT NUMBER):TABLE: (RESULT NUMBER) | FUNCTION     | test_udtf_end_partition |                   |
-------------------------------------------------------------------------------------------------------------------------------------------

-- Example 27379
conda create -n <env_name> python==3.10

-- Example 27380
conda activate <env_name>

-- Example 27381
cd <your Python project root folder>
python3 -m venv '.venv'

-- Example 27382
source '.venv/bin/activate'

-- Example 27383
pip install snowflake -U

-- Example 27384
pip install "snowflake[ml]" -U

-- Example 27385
%env _SNOWFLAKE_PRINT_VERBOSE_STACK_TRACE=false

-- Example 27386
POST /api/v2/statements
(request body)

-- Example 27387
"data" : [ [ null ], ... ]

-- Example 27388
"data" : [ [ "null" ], ... ]

-- Example 27389
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 18:06:24 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=0>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 4,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "COLUMN1",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 4,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16,
      "collation" : null
    }, {
      "name" : "COLUMN2",
      "database" : "",
      "schema" : "",
      "table" : "\"VALUES\"",
      "scale" : 0,
      "precision" : 1,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 4,
      "uncompressedSize": 1438,
    }]
  },
  "data" : [ [ "test", "2" ], [ "test", "3" ], [ "test", "4" ], [ "test", "5" ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id3}&partition=0",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151584132
}

-- Example 27390
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 18:08:15 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=1>; rel="next",
  </api/v2/statements/{handle}?requestId={id3}&partition=1>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 56090,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "SEQ8()",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : 0,
      "precision" : 19,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    }, {
      "name" : "RANDSTR(1000, RANDOM())",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 16777216,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16777216,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
      "rowCount": 43746,
      "uncompressedSize": 43748274,
      "compressedSize": 746323
    }]
  },
  "data" : [ [ "0", "QqKow2xzdJ....." ],.... [ "98", "ZugTcURrcy...." ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id4}",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151693299
}

-- Example 27391
HTTP/1.1 200 OK
Date: Mon, 31 May 2021 22:50:31 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=1>; rel="last"

{
  "resultSetMetaData" : {
  "numRows" : 56090,
  "format" : "jsonv2",
  "rowType" : [ {
      "name" : "multiple statement execution",
      "database" : "",
      "schema" : "",
      "table" : "",
      "type" : "text",
      "scale" : null,
      "precision" : null,
      "byteLength" : 16777216,
      "nullable" : false,
      "collation" : null,
      "length" : 16777216
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
     "rowCount": 43746,
     "uncompressedSize": 43748274,
     "compressedSize": 746323
    }]
  },
  "data" : [ [ "Multiple statements executed successfully." ] ],
  "code" : "090001",
  "statementHandles" : [ "{handle1}", "{handle2}", "{handle3}" ],
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id3}",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1622501430333
}

-- Example 27392
HTTP/1.1 202 Accepted
Date: Tue, 04 May 2021 18:12:37 GMT
Content-Type: application/json
Content-Length: 285
{
  "code" : "333334",
  "message" :
      "Asynchronous execution in progress. Use provided query id to perform query monitoring and management.",
  "statementHandle" : "019c06a4-0000-df4f-0000-00100006589e",
  "statementStatusUrl" : "/api/v2/statements/019c06a4-0000-df4f-0000-00100006589e"
}

-- Example 27393
HTTP/1.1 422 Unprocessable Entity
Date: Tue, 04 May 2021 20:24:11 GMT
Content-Type: application/json
{
  "code" : "000904",
  "message" : "SQL compilation error: error line 1 at position 7\ninvalid identifier 'AFAF'",
  "sqlState" : "42000",
  "statementHandle" : "019c0728-0000-df4f-0000-00100006606e"
}

-- Example 27394
GET /api/v2/statements/{statementHandle}

-- Example 27395
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 20:25:46 GMT
Content-Type: application/json
Link:
  </api/v2/statements/{handle}?requestId={id1}&partition=0>; rel="first",
  </api/v2/statements/{handle}?requestId={id2}&partition=0>; rel="prev",
  </api/v2/statements/{handle}?requestId={id3}&partition=1>; rel="next",
  </api/v2/statements/{handle}?requestId={id4}&partition=10>; rel="last"
{
  "resultSetMetaData" : {
    "numRows" : 10000,
    "format" : "jsonv2",
    "rowType" : [ {
      "name" : "SEQ8()",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : 0,
      "precision" : 19,
      "length" : null,
      "type" : "fixed",
      "nullable" : false,
      "byteLength" : null,
      "collation" : null
    }, {
      "name" : "RANDSTR(1000, RANDOM())",
      "database" : "",
      "schema" : "",
      "table" : "",
      "scale" : null,
      "precision" : null,
      "length" : 16777216,
      "type" : "text",
      "nullable" : false,
      "byteLength" : 16777216,
      "collation" : null
    } ],
    "partitionInfo": [{
      "rowCount": 12344,
      "uncompressedSize": 14384873,
    },{
      "rowCount": 43746,
      "uncompressedSize": 43748274,
      "compressedSize": 746323
    }]
  },
  "data" : [ [ "10", "lJPPMTSwps......" ], ... [ "19", "VJKoHmUFJz......" ] ],
  "code" : "090001",
  "statementStatusUrl" : "/api/v2/statements/{handle}?requestId={id5}&partition=10",
  "sqlState" : "00000",
  "statementHandle" : "{handle}",
  "message" : "Statement executed successfully.",
  "createdOn" : 1620151693299
}

-- Example 27396
HTTP/1.1 202 Accepted
Date: Tue, 04 May 2021 22:31:33 GMT
Content-Type: application/json
Content-Length: 285
{
  "code" : "333334",
  "message" :
      "Asynchronous execution in progress. Use provided query id to perform query monitoring and management.",
  "statementHandle" : "019c07a7-0000-df4f-0000-001000067872",
  "statementStatusUrl" : "/api/v2/statements/019c07a7-0000-df4f-0000-001000067872"
}

-- Example 27397
POST /api/v2/statements/{statementHandle}/cancel

-- Example 27398
HTTP/1.1 200 OK
Date: Tue, 04 May 2021 22:52:15 GMT
Content-Type: application/json
Content-Length: 230
{
  "code" : "000604",
  "sqlState" : "57014",
  "message" : "SQL execution canceled",
  "statementHandle" : "019c07bc-0000-df4f-0000-001000067c3e",
  "statementStatusUrl" : "/api/v2/statements/019c07bc-0000-df4f-0000-001000067c3e"
}

-- Example 27399
HTTP/1.1 422 Unprocessable Entity
Date: Tue, 04 May 2021 22:52:49 GMT
Content-Type: application/json
Content-Length: 183
{
  "code" : "000709",
  "message" : "Statement 019c07bc-0000-df4f-0000-001000067c3e not found",
  "sqlState" : "02000",
  "statementHandle" : "019c07bc-0000-df4f-0000-001000067c3e"
}

-- Example 27400
{"1":{"type":"FIXED","value":"123"},"2":{"type":"TEXT","value":"teststring"}}

-- Example 27401
{
  "statement" : "select * from T where c1=?",
  "timeout" : 10,
  "database" : "TESTDB",
  "schema" : "TESTSCHEMA",
  "warehouse" : "TESTWH",
  "role" : "TESTROLE",
  "bindings" : {
    "1" : {
      "type" : "FIXED",
      "value" : "123"
    }
  }
}

-- Example 27402
HTTP/1.1 400 Bad Request
Date: Tue, 04 May 2021 22:54:21 GMT
Content-Type: application/json
{
  "code" : "390142",
  "message" : "Incoming request does not contain a valid payload."
}

-- Example 27403
HTTP/1.1 401 Unauthorized
Date: Tue, 04 May 2021 20:17:57 GMT
Content-Type: application/json
{
  "code" : "390303",
  "message" : "Invalid OAuth access token. ...TTTTTTTT"
}

-- Example 27404
HTTP/1.1 405 Method Not Allowed
Date: Tue, 04 May 2021 22:55:38 GMT
Content-Length: 0

-- Example 27405
HTTP/1.1 429 Too many requests
Content-Type: application/json
Content-Length: 69
{
  "code" : "390505",
  "message" : "Too many requests."
 }

-- Example 27406
Link: </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=1; rel="last">,
      </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=1; rel="next">,
      </api/v2/statements/e127cc7c-7812-4e72-9a55-3b4d4f969840?partition=0; rel="first">

-- Example 27407
{
  "code" : "0",
  "sqlState" : "",
  "message" : "successfully canceled",
  "statementHandle" : "536fad38-b564-4dc5-9892-a4543504df6c",
  "statementStatusUrl" : "/api/v2/statements/536fad38-b564-4dc5-9892-a4543504df6c"
}

-- Example 27408
{
  "code" : "002140",
  "sqlState" : "42601",
  "message" : "SQL compilation error",
  "statementHandle" : "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl" : "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 27409
{
  "code" : "0",
  "sqlState" : "",
  "message" : "successfully executed",
  "statementHandle" : "e4ce975e-f7ff-4b5e-b15e-bf25f59371ae",
  "statementStatusUrl" : "/api/v2/statements/e4ce975e-f7ff-4b5e-b15e-bf25f59371ae"
}

-- Example 27410
[
  ["customer1","1234 A Avenue","98765","1565481394123000000"],
  ["customer2","987 B Street","98765","1565516712912012345"],
  ["customer3","8777 C Blvd","98765","1565605431999999999"],
  ["customer4","64646 D Circle","98765","1565661272000000000"]
]

-- Example 27411
[
 {"name":"ROWNUM","type":"FIXED","length":0,"precision":38,"scale":0,"nullable":false},
 {"name":"ACCOUNT_ID","type":"FIXED","length":0,"precision":38,"scale":0,"nullable":false},
 {"name":"ACCOUNT_NAME","type":"TEXT","length":1024,"precision":0,"scale":0,"nullable":false},
 {"name":"ADDRESS","type":"TEXT","length":16777216,"precision":0,"scale":0,"nullable":true},
 {"name":"ZIP","type":"TEXT","length":100,"precision":0,"scale":0,"nullable":true},
 {"name":"CREATED_ON","type":"TIMESTAMP_NTZ","length":0,"precision":0,"scale":3,"nullable":false}
]

-- Example 27412
{
 "name":"ACCOUNT_NAME",
 "type":"TEXT",
 "length":1024,
 "precision":0,
 "scale":0,
 "nullable":false
}

-- Example 27413
POST /api/v2/statements HTTP/1.1
Authorization: Bearer <jwt>
Content-Type: application/json
Accept: application/json
User-Agent: myApplication/1.0

{
  "statement": "alter session set QUERY_TAG='mytesttag'; select count(*) from mytable",
  ...
  "parameters": {
      "MULTI_STATEMENT_COUNT": "2"
  }
}

-- Example 27414
Actual statement count <actual_count> did not match the desired statement count <desired_count>.

-- Example 27415
Actual statement count 3 did not match the desired statement count 1.

-- Example 27416
POST /api/v2/statements HTTP/1.1
Authorization: Bearer <jwt>
Content-Type: application/json
Accept: application/json
User-Agent: myApplication/1.0

{
  "statement": "select * from A; select * from B",
  ...
}

-- Example 27417
HTTP/1.1 200 OK
...
{
  ...
  "statementHandles" : [ "019c9fce-0502-f1fc-0000-438300e02412", "019c9fce-0502-f1fc-0000-438300e02416" ],
  ...
}

-- Example 27418
GET /api/v2/statements/019c9fce-0502-f1fc-0000-438300e02412
...

-- Example 27419
GET /api/v2/statements/019c9fce-0502-f1fc-0000-438300e02416
...

-- Example 27420
{
  "statement": "create or replace table table1 (i int); insert into table1 (i) values (1); insert into table1 (i) values ('This is not a valid integer.'); insert into table1 (i) values (2); select i from table1 order by i",
  ...
}

-- Example 27421
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json
...
{
  "code" : "100132",
  "message" : "JavaScript execution error: Uncaught Execution of multiple statements failed on statement \"insert into table1 (i) values ...\" (at line 1, position 75).\nNumeric value 'This is not a valid integer.' is not recognized in SYSTEM$MULTISTMT at '    throw `Execution of multiple statements failed on statement {0} (at line {1}, position {2}).`.replace('{1}', LINES[i])' position 4\nstackstrace: \nSYSTEM$MULTISTMT line: 10",
  "sqlState" : "P0000",
  "statementHandle" : "019d6e97-0502-317e-0000-096d0041f036"
}

-- Example 27422
HTTP/1.1 200 OK
...
{
  "code": "391908",
  ...
}

-- Example 27423
example_streamlit/            - project name (default: example_streamlit)
  snowflake.yml               - configuration for snow streamlit commands
  environment.yml             - additional config for Streamlit, for example installing packages
  streamlit_app.py            - entrypoint file of the app
  pages/                      - directory name for Streamlit pages (default pages)
  common/                     - example “shared library”

-- Example 27424
snow init new_streamlit_project --template example_streamlit -D query_warehouse=dev_warehouse -D stage=testing

-- Example 27425
definition_version: 2
entities:
  my_streamlit:
    type: streamlit
    identifier: streamlit_app
    stage: my_streamlit_stage
    query_warehouse: my_streamlit_warehouse
    main_file: streamlit_app.py
    pages_dir: pages/
    external_access_integrations:
      - test_egress
    secrets:
      dummy_secret: "db.schema.dummy_secret"
    imports:
      - "@my_stage/foo.py"
    artifacts:
      - common/hello.py
      - environment.yml

-- Example 27426
identifier: my-streamlit-id

-- Example 27427
identifier:
  name: my-streamlit-id
  schema: my-schema # optional
  database: my-db # optional

-- Example 27428
snow streamlit get-url my_streamlit_app

-- Example 27429
https://snowflake.com/provider-deduced-from-connection/#/streamlit-apps/DB.SCHEMA.MY_STREAMLIT_APP

-- Example 27430
snow streamlit get-url my_streamlit_app --open

-- Example 27431
snow streamlit share my-app some-role

-- Example 27432
CREATE DATABASE provider_db;
CREATE SCHEMA provider_schema;
CREATE IMAGE REPOSITORY provider_repo;

-- Example 27433
$ docker login org-provider-account.registry.snowflakecomputing.com
$ docker build --rm --platform linux/amd64 -t service:1.0 .
$ docker tag service:1.0 org-provider-account.registry.snowflakecomputing.com/provider_db/provider_schema/provider_repo/service:1.0
$ docker push org-provider-account.registry.snowflakecomputing.comprovider_db/provider_schema/provider_repo/service:1.0

-- Example 27434
spec:
  containers:
  - image: /provider_db/provider_schema/provider_repo/server:prod
    name: server
    ...
  - image: /provider_db/provider_schema/provider_repo/web:1.0
    name: web
    ...
  endpoints:
  - name: invoke
    port: 8000
  - name: ui
    port: 5000
    public: true

-- Example 27435
spec:
  containers:
  - image: /provider_db/provider_schema/provider_repo/server:prod
    name: my_app_container
  endpoints:
  - name: invoke
    port: 8000
  - name: ui
    port: 5000
    public: true

-- Example 27436
@test.schema1.stage1:
└── /
    ├── manifest.yml
    ├── readme.md
    ├── scripts/setup_script.sql
    └── code_artifacts/
        └── streamlit/
            └── environment.yml
            └── streamlit_app.py

-- Example 27437
CREATE OR REPLACE STREAMLIT app_schema.my_test_app_na
     FROM '/code_artifacts/streamlit'
     MAIN_FILE = '/streamlit_app.py';

GRANT USAGE ON SCHEMA APP_SCHEMA TO APPLICATION ROLE app_public;
GRANT USAGE ON STREAMLIT APP_SCHEMA.MY_TEST_APP_NA TO APPLICATION ROLE app_public;

-- Example 27438
name: sf_env
channels:
- snowflake
dependencies:
- scikit-learn

-- Example 27439
name: sf_env
channels:
- snowflake
dependencies:
- streamlit=1.22.0|1.26.0

-- Example 27440
artifacts:
  ...
  default_streamlit: app_schema.streamlit_app_na
  ...

-- Example 27441
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_code.core.hello_snowflake_stage';

-- Example 27442
title: A title for the listing.
subtitle: An optional subtitle.
description: A general description.
profile: Provider profile reference.
listing_terms: ...
targets: ...

-- Example 27443
auto_fulfillment: ...

-- Example 27444
title: "MyFirstListing"
subtitle: "Example listing"
description: "This is my first listing!"
listing_terms:
  type: "OFFLINE"
targets:
   accounts: ["Org1.Account1"]

