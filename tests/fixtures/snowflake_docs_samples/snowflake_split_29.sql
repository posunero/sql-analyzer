-- Example 1905
from snowflake.core.database import Database
from snowflake.core.schema import Schema

database = root.databases.create(Database(name="spcs_python_api_db"), mode="orreplace")
schema = database.schemas.create(Schema(name="public"), mode="orreplace")

-- Example 1906
from snowflake.core.image_repository import ImageRepository

my_repo = ImageRepository("MyImageRepository")
schema.image_repositories.create(my_repo)

-- Example 1907
my_repo_res = schema.image_repositories["MyImageRepository"]
my_repo = my_repo_res.fetch()
print(my_repo.name)

-- Example 1908
repositories = schema.image_repositories
  for repo_obj in repositories.iter():
    print(repo_obj.repository_url)

-- Example 1909
<orgname>-<acctname>.registry.snowflakecomputing.com/spcs_python_api_db/public/myimagerepository

-- Example 1910
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 1911
docker login <registry_hostname> -u <username>

-- Example 1912
docker login myorg-myacct.registry.snowflakecomputing.com -u admin

-- Example 1913
docker pull --platform linux/amd64 amd64/nginx

-- Example 1914
docker tag docker.io/amd64/nginx:latest <repository_url>/<image_name>

-- Example 1915
docker tag docker.io/amd64/nginx:latest myorg-myacct.registry.snowflakecomputing.com/spcs_python_api_db/public/myimagerepository/amd64/nginx:latest

-- Example 1916
docker push <repository_url>/<image_name>

-- Example 1917
docker push myorg-myacct.registry.snowflakecomputing.com/spcs_python_api_db/public/myimagerepository/amd64/nginx:latest

-- Example 1918
new_compute_pool_def = ComputePool(
    name="MyComputePool",
    instance_family="CPU_X64_XS",
    min_nodes=1,
    max_nodes=2,
)

new_compute_pool = root.compute_pools.create(new_compute_pool_def)

-- Example 1919
image_repository = schema.image_repositories["MyImageRepository"]

-- Example 1920
from textwrap import dedent
from io import BytesIO
from snowflake.core.service import Service, ServiceSpecInlineText

specification = dedent(f"""\
    spec:
      containers:
      - name: web-server
        image: {image_repository.fetch().repository_url}/amd64/nginx:latest
      endpoints:
      - name: ui
        port: 80
        public: true
    """)

service_def = Service(
    name="MyService",
    compute_pool="MyComputePool",
    spec=ServiceSpecInlineText(spec_text=specification),
    min_instances=1,
    max_instances=1,
)

nginx_service = schema.services.create(service_def)

-- Example 1921
from pprint import pprint

pprint(nginx_service.get_service_status(timeout=5))

-- Example 1922
{'auto_resume': True,
'auto_suspend_secs': 3600,
'instance_family': 'CPU_X64_XS',
'max_nodes': 1,
'min_nodes': 1,
'name': 'MyService'}

-- Example 1923
import json, time

while True:
    public_endpoints = nginx_service.fetch().public_endpoints
    try:
        endpoints = json.loads(public_endpoints)
    except json.JSONDecodeError:
        print(public_endpoints)
        time.sleep(15)
    else:
        break

-- Example 1924
Endpoints provisioning in progress... check back in a few minutes
Endpoints provisioning in progress... check back in a few minutes
Endpoints provisioning in progress... check back in a few minutes

-- Example 1925
import webbrowser

print(f"Visiting {endpoints['ui']} in your browser. You might need to log in there.")
webbrowser.open(f"https://{endpoints['ui']}")

-- Example 1926
Visiting myorg-myacct.snowflakecomputing.app in your browser. You might need to log in there.

-- Example 1927
from time import sleep

nginx_service.suspend()
sleep(3)
print(nginx_service.get_service_status(timeout=5))

-- Example 1928
nginx_service.resume()
sleep(3)
print(nginx_service.get_service_status(timeout=5))

-- Example 1929
new_compute_pool_def.suspend()
nginx_service.suspend()

-- Example 1930
new_compute_pool_def.drop()
nginx_service.drop()

-- Example 1931
snow connection test -c tut-connection

-- Example 1932
+----------------------------------------------------------------------------------+
| key             | value                                                          |
|-----------------+----------------------------------------------------------------|
| Connection name | tut-connection                                                 |
| Status          | OK                                                             |
| Host            | USER_ACCOUNT.snowflakecomputing.com                            |
| Account         | USER_ACCOUNT                                                   |
| User            | tutorial_user                                                  |
| Role            | TUTORIAL_ROLE                                                  |
| Database        | TUTORIAL_IMAGE_DATABASE                                        |
| Warehouse       | TUTORIAL_WAREHOUSE                                             |
+----------------------------------------------------------------------------------+

-- Example 1933
USE ROLE tutorial_role;

-- Example 1934
SHOW DATABASES LIKE 'tutorial_image_database';

-- Example 1935
SHOW SCHEMAS LIKE 'tutorial_image_schema';

-- Example 1936
SHOW IMAGE REPOSITORIES LIKE 'tutorial_image_repo';

-- Example 1937
CALL na_spcs_tutorial_app.app_public.service_status();

-- Example 1938
├── app
    └── manifest.yml
    └── README.md
    └── setup_script.sql
├── README.md
├── service
    └── echo_service.py
    ├── echo_spec.yaml
    ├── Dockerfile
    └── templates
        └── basic_ui.html
├── snowflake.yml

-- Example 1939
SHOW APPLICATIONS LIKE 'na_spcs_tutorial_app';

-- Example 1940
USE ROLE tutorial_role;
DROP APPLICATION IF EXISTS na_spcs_tutorial_app CASCADE;

-- Example 1941
lifecycle_callbacks:
  version_initializer: app_public.version_init

-- Example 1942
CREATE OR REPLACE PROCEDURE app_public.version_init()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
can_create_compute_pool BOOLEAN;  -- Flag to check if 'CREATE COMPUTE POOL' privilege is held
BEGIN
-- Check if the account holds the 'CREATE COMPUTE POOL' privilege
   SELECT SYSTEM$HOLD_PRIVILEGE_ON_ACCOUNT('CREATE COMPUTE POOL')
      INTO can_create_compute_pool;

   ALTER SERVICE IF EXISTS core.echo_service
      FROM SPECIFICATION_FILE = 'service/echo_spec.yaml';
   IF (can_create_compute_pool) THEN
      -- When installing app, the app has no 'CREATE COMPUTE POOL' privilege at that time,
      -- so it will not execute the code below

      -- Since the ALTER SERVICE is an async process, wait for the service to be ready
      SELECT SYSTEM$WAIT_FOR_SERVICES(120, 'core.echo_service');
   END IF;
   RETURN 'DONE';
END;
$$;

-- Example 1943
snow app version create v1 -c tut-connection

-- Example 1944
ALTER APPLICATION PACKAGE na_spcs_tutorial_pkg
  SET DEFAULT RELEASE DIRECTIVE VERSION=v1 PATCH=0;

-- Example 1945
snow app run --from-release-directive -c tut-connection

-- Example 1946
GRANT CREATE COMPUTE POOL ON ACCOUNT TO APPLICATION na_spcs_tutorial_app;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO APPLICATION na_spcs_tutorial_app;

-- Example 1947
CALL na_spcs_tutorial_app.app_public.start_app();

-- Example 1948
SHOW FUNCTIONS LIKE '%my_echo_udf%' IN APPLICATION na_spcs_tutorial_app;

-- Example 1949
CALL na_spcs_tutorial_app.app_public.service_status();

-- Example 1950
SELECT na_spcs_tutorial_app.core.my_echo_udf('hello');

-- Example 1951
DESC APPLICATION na_spcs_tutorial_app;

-- Example 1952
CREATE TABLE IF NOT EXISTS core.setup_script_run(run_at TIMESTAMP);
GRANT SELECT ON TABLE core.setup_script_run to APPLICATION ROLE app_user;
INSERT INTO core.setup_script_run(run_at) values(current_timestamp());

-- Example 1953
snow app version create v2 -c tut-connection

-- Example 1954
ALTER APPLICATION PACKAGE na_spcs_tutorial_pkg
  SET DEFAULT RELEASE DIRECTIVE VERSION=v2 PATCH=0;

-- Example 1955
snow app run --from-release-directive -c tut-connection

-- Example 1956
SELECT na_spcs_tutorial_app.core.my_echo_udf('hello');

-- Example 1957
`Tom said hello.`

-- Example 1958
SELECT * FROM table_does_not_exist;

-- Example 1959
GRANT USAGE ON PROCEDURE app_public.service_status() TO APPLICATION ROLE app_user;

CREATE OR REPLACE PROCEDURE app_public.version_init()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
  -- Flag to check if 'CREATE COMPUTE POOL' privilege is held
  can_create_compute_pool BOOLEAN;
BEGIN
   -- Check if the account holds the 'CREATE COMPUTE POOL' privilege
   SELECT SYSTEM$HOLD_PRIVILEGE_ON_ACCOUNT('CREATE COMPUTE POOL')
     INTO can_create_compute_pool;

   ALTER SERVICE IF EXISTS core.echo_service
     FROM SPECIFICATION_FILE = 'service/echo_spec.yaml';
   IF (can_create_compute_pool) THEN
     -- When installing app, the app has no 'CREATE COMPUTE POOL' privilege at that time,
     -- so it will not execute the code below

     -- Since the ALTER SERVICE is an async process, wait for the service to be ready
     SELECT SYSTEM$WAIT_FOR_SERVICES(120, 'core.echo_service');
   END IF;

   -- trigger an error. The upgrade fails
   SELECT * FROM non_exist_table;

   RETURN 'DONE';
END;
$$;

-- Example 1960
snow app version create v2 --patch 1 -c tut-connection

-- Example 1961
ALTER APPLICATION PACKAGE na_spcs_tutorial_pkg
  SET DEFAULT RELEASE DIRECTIVE VERSION=v2 PATCH=1;

-- Example 1962
snow app run --from-release-directive -c tut-connection

-- Example 1963
DESC APPLICATION na_spcs_tutorial_app;

-- Example 1964
Object 'TABLE_DOES_NOT_EXIST' does not exist or not authorized.'

-- Example 1965
SELECT na_spcs_tutorial_app.core.my_echo_udf('hello');

-- Example 1966
Bob said hello

-- Example 1967
SELECT * FROM table_does_not_exist;

-- Example 1968
ALTER APPLICATION PACKAGE na_spcs_tutorial_pkg
  SET DEFAULT RELEASE DIRECTIVE VERSION=v2 PATCH=2;

-- Example 1969
snow app run --from-release-directive -c tut-connection

-- Example 1970
SELECT na_spcs_tutorial_app.core.my_echo_udf('hello');

-- Example 1971
DESC APPLICATION na_spcs_tutorial_app;

-- Example 1972
snow object list compute-pool -l "na_spcs_tutorial_app_%"

