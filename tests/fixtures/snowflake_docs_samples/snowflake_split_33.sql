-- Example 2177
SELECT warehouse_name, SUM(eligible_query_acceleration_time) AS total_eligible_time, MAX(upper_limit_scale_factor)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
  WHERE start_time > DATEADD(month, -1, CURRENT_TIMESTAMP())
  GROUP BY warehouse_name
  ORDER BY total_eligible_time DESC;

-- Example 2178
ALTER WAREHOUSE <warehouse_name> SET
  enable_query_acceleration = TRUE;

-- Example 2179
DROP WAREHOUSE noqas_wh;

DROP WAREHOUSE qas_wh;

-- Example 2180
{
  "continent": "Europe",
  "country": {
    "city": [
      "Paris",
      "Nice",
      "Marseilles",
      "Cannes"
    ],
    "name": "France"
  }
}

-- Example 2181
create or replace database mydatabase;

 use schema mydatabase.public;

  create or replace temporary table cities (
    continent varchar default null,
    country varchar default null,
    city variant default null
  );

create or replace warehouse mywarehouse with
  warehouse_size='X-SMALL'
  auto_suspend = 120
  auto_resume = true
  initially_suspended=true;

use warehouse mywarehouse;

-- Example 2182
CREATE OR REPLACE FILE FORMAT sf_tut_parquet_format
  TYPE = parquet;

-- Example 2183
CREATE OR REPLACE TEMPORARY STAGE sf_tut_stage
FILE_FORMAT = sf_tut_parquet_format;

-- Example 2184
PUT file:///tmp/load/cities.parquet @sf_tut_stage;

-- Example 2185
PUT file://C:\temp\load\cities.parquet @sf_tut_stage;

-- Example 2186
copy into cities
 from (select $1:continent::varchar,
              $1:country:name::varchar,
              $1:country:city::variant
      from @sf_tut_stage/cities.parquet);

-- Example 2187
SELECT * from cities;

-- Example 2188
+---------------+---------+-----------------+
| CONTINENT     | COUNTRY | CITY            |
|---------------+---------+-----------------|
| Europe        | France  | [               |
|               |         |   "Paris",      |
|               |         |   "Nice",       |
|               |         |   "Marseilles", |
|               |         |   "Cannes"      |
|               |         | ]               |
|---------------+---------+-----------------|
| Europe        | Greece  | [               |
|               |         |   "Athens",     |
|               |         |   "Piraeus",    |
|               |         |   "Hania",      |
|               |         |   "Heraklion",  |
|               |         |   "Rethymnon",  |
|               |         |   "Fira"        |
|               |         | ]               |
|---------------+---------+-----------------|
| North America | Canada  | [               |
|               |         |   "Toronto",    |
|               |         |   "Vancouver",  |
|               |         |   "St. John's", |
|               |         |   "Saint John", |
|               |         |   "Montreal",   |
|               |         |   "Halifax",    |
|               |         |   "Winnipeg",   |
|               |         |   "Calgary",    |
|               |         |   "Saskatoon",  |
|               |         |   "Ottawa",     |
|               |         |   "Yellowknife" |
|               |         | ]               |
+---------------+---------+-----------------+

-- Example 2189
copy into @sf_tut_stage/out/parquet_
from (select continent,
             country,
             c.value::string as city
     from cities,
          lateral flatten(input => city) c)
  file_format = (type = 'parquet')
  header = true;

-- Example 2190
select t.$1 from @sf_tut_stage/out/ t;

-- Example 2191
+---------------------------------+
| $1                              |
|---------------------------------|
| {                               |
|   "CITY": "Paris",              |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
|---------------------------------|
| {                               |
|   "CITY": "Nice",               |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
|---------------------------------|
| {                               |
|   "CITY": "Marseilles",         |
|   "CONTINENT": "Europe",        |
|   "COUNTRY": "France"           |
| }                               |
+---------------------------------+

-- Example 2192
REMOVE @sf_tut_stage/cities.parquet;

-- Example 2193
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 2194
DESC SERVICE echo_service;

-- Example 2195
SHOW SERVICE CONTAINERS IN SERVICE echo_service;

-- Example 2196
SHOW IMAGE REPOSITORIES;

-- Example 2197
<orgname>-<acctname>.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository

-- Example 2198
<orgname>-<acctname>.registry.snowflakecomputing.com

-- Example 2199
docker build --rm --platform linux/amd64 -t <repository_url>/<image_name> .

-- Example 2200
docker build --rm --platform linux/amd64 -t myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/service_to_service:latest .

-- Example 2201
docker login <registry_hostname> -u <username>

-- Example 2202
docker push <repository_url>/<image_name>

-- Example 2203
docker push myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/service_to_service:latest

-- Example 2204
PUT file://<absolute-path-to-spec.yaml> @tutorial_stage
  AUTO_COMPRESS=FALSE
  OVERWRITE=TRUE;

-- Example 2205
EXECUTE JOB SERVICE
  IN COMPUTE POOL tutorial_compute_pool
  NAME=tutorial_db.data_schema.tutorial_3_job_service
  FROM @tutorial_stage
  SPEC='service_to_service_spec.yaml';

-- Example 2206
+------------------------------------------------------------------------+
| status                                                                 |
|------------------------------------------------------------------------|
| Job TUTORIAL3_JOB_SERVICE completed successfully with status: DONE     |
+------------------------------------------------------------------------+

-- Example 2207
SHOW SERVICE CONTAINERS IN SERVICE tutorial_3_job_service;

-- Example 2208
+---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------+
| database_name | schema_name | service_name           | instance_id | container_name | status | message                | image_name                                                                                                                             | image_digest                                                            | restart_count | start_time |
|---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------|
| TUTORIAL_DB   | DATA_SCHEMA | TUTORIAL_3_JOB_SERVICE | 0           | main           | DONE   | Completed successfully | myorg-myacct.registry.snowflakecomputing.com/tutorial_db/data_schema/tutorial_repository/service_to_service:latest | sha256:aa3fa2e5c1552d16904a5bbc97d400316ebb4a608bb110467410485491d9d8d0 |             0 |            |
+---------------+-------------+------------------------+-------------+----------------+--------+------------------------+----------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------+---------------+------------+

-- Example 2209
CALL SYSTEM$GET_SERVICE_LOGS('tutorial_3_job_service', 0, 'main');

-- Example 2210
+--------------------------------------------------------------------------------------------------------------------------+
| SYSTEM$GET_JOB_LOGS                                                                                                      |
|--------------------------------------------------------------------------------------------------------------------------|
| service-to-service [2023-04-29 21:52:09,208] [INFO] Calling http://echo-service:8000/echo with input Hello               |
| service-to-service [2023-04-29 21:52:09,212] [INFO] Received response from http://echo-service:8000/echo: Bob said Hello |
+--------------------------------------------------------------------------------------------------------------------------+

-- Example 2211
ALTER COMPUTE POOL tutorial_compute_pool STOP ALL;

-- Example 2212
DROP COMPUTE POOL tutorial_compute_pool;

-- Example 2213
DROP IMAGE REPOSITORY tutorial_repository;
DROP STAGE tutorial_stage;

-- Example 2214
import json
import logging
import os
import requests
import sys

SERVICE_URL = os.getenv('SERVICE_URL', 'http://localhost:8080/echo')
ECHO_TEXT = 'Hello'

def get_logger(logger_name):
  logger = logging.getLogger(logger_name)
  logger.setLevel(logging.DEBUG)
  handler = logging.StreamHandler(sys.stdout)
  handler.setLevel(logging.DEBUG)
  handler.setFormatter(
    logging.Formatter(
      '%(name)s [%(asctime)s] [%(levelname)s] %(message)s'))
  logger.addHandler(handler)
  return logger

logger = get_logger('service-to-service')

def call_service(service_url, echo_input):
  logger.info(f'Calling {service_url} with input {echo_input}')

  row_to_send = {"data": [[0, echo_input]]}
  response = requests.post(url=service_url,
                           data=json.dumps(row_to_send),
                           headers={"Content-Type": "application/json"})

  message = response.json()
  if message is None or not message["data"]:
    logger.error('Received empty response from service ' + service_url)

  response_row = message["data"][0]
  if len(response_row) != 2:
    logger.error('Unexpected response format: ' + response_row)

  echo_reponse = response_row[1]
  logger.info(f'Received response from {service_url}: ' + echo_reponse)

if __name__ == '__main__':
  call_service(SERVICE_URL, ECHO_TEXT)

-- Example 2215
SERVICE_URL = os.getenv('SERVICE_URL', 'http://localhost:8080/echo').

-- Example 2216
ARG BASE_IMAGE=python:3.10-slim-buster
FROM $BASE_IMAGE
COPY service_to_service.py ./
RUN pip install --upgrade pip && \
  pip install requests
CMD ["python3", "service_to_service.py"]

-- Example 2217
spec:
container:
   - name: main
      image: /tutorial_db/data_schema/tutorial_repository/service_to_service:latest
      env:
      SERVICE_URL: "http://echo-service:8000/echo"

-- Example 2218
DESCRIBE SERVICE echo_service;

-- Example 2219
echo-service.fsvv.svc.spcs.internal

-- Example 2220
SERVER_PORT=8000 python3 echo_service.py

-- Example 2221
SERVICE_URL=http://localhost:8000/echo python3 service_to_service.py

-- Example 2222
service-to-service
  [2023-04-23 22:30:41,278]
  [INFO] Calling http://localhost:8000/echo with input Hello


service-to-service
  [2023-04-23 22:30:41,287]
  [INFO] Received response from http://localhost:8000/echo: I said Hello

-- Example 2223
git clone https://github.com/Snowflake-Labs/sftutorial-snowpark-testing

-- Example 2224
# Linux/MacOS
export SNOWSQL_ACCOUNT=<replace with your account identifier>
export SNOWSQL_USER=<replace with your username>
export SNOWSQL_ROLE=<replace with your role>
export SNOWSQL_PWD=<replace with your password>
export SNOWSQL_DATABASE=<replace with your database>
export SNOWSQL_SCHEMA=<replace with your schema>
export SNOWSQL_WAREHOUSE=<replace with your warehouse>

-- Example 2225
# Windows/PowerShell
$env:SNOWSQL_ACCOUNT = "<replace with your account identifier>"
$env:SNOWSQL_USER = "<replace with your username>"
$env:SNOWSQL_ROLE = "<replace with your role>"
$env:SNOWSQL_PWD = "<replace with your password>"
$env:SNOWSQL_DATABASE = "<replace with your database>"
$env:SNOWSQL_SCHEMA = "<replace with your schema>"
$env:SNOWSQL_WAREHOUSE = "<replace with your warehouse>"

-- Example 2226
conda env create --file environment.yml
conda activate snowpark-testing

-- Example 2227
python setup/create_table.py

-- Example 2228
python project/sproc.py

-- Example 2229
mkdir test

-- Example 2230
import pytest
from project.utils import get_env_var_config
from snowflake.snowpark.session import Session

@pytest.fixture
def session() -> Session:
    return Session.builder.configs(get_env_var_config()).create()

-- Example 2231
# test/test_transformers.py

from project.transformers import add_rider_age, calc_bike_facts, calc_month_facts

-- Example 2232
# test/test_transformers.py
from project.transformers import add_rider_age, calc_bike_facts, calc_month_facts
def test_add_rider_age(session):
    ...

def test_calc_bike_facts(session):
    ...


def test_calc_month_facts(session):
    ...

-- Example 2233
# test/test_transformers.py
from project.transformers import add_rider_age, calc_bike_facts, calc_month_facts
from snowflake.snowpark.types import StructType, StructField, IntegerType, FloatType

def test_add_rider_age(session: Session):
    input = session.create_dataframe(
        [
            [1980],
            [1995],
            [2000]
        ],
        schema=StructType([StructField("BIRTH_YEAR", IntegerType())])
    )

    expected = session.create_dataframe(
        [
            [1980, 43],
            [1995, 28],
            [2000, 23]
        ],
        schema=StructType([StructField("BIRTH_YEAR", IntegerType()), StructField("RIDER_AGE", IntegerType())])
    )

    actual = add_rider_age(input)
    assert expected.collect() == actual.collect()


def test_calc_bike_facts(session: Session):
    input = session.create_dataframe([
            [1, 10, 20],
            [1, 5, 30],
            [2, 20, 50],
            [2, 10, 60]
        ],
        schema=StructType([
            StructField("BIKEID", IntegerType()),
            StructField("TRIPDURATION", IntegerType()),
            StructField("RIDER_AGE", IntegerType())
        ])
    )

    expected = session.create_dataframe([
            [1, 2, 7.5, 25.0],
            [2, 2, 15.0, 55.0],
        ],
        schema=StructType([
            StructField("BIKEID", IntegerType()),
            StructField("COUNT", IntegerType()),
            StructField("AVG_TRIPDURATION", FloatType()),
            StructField("AVG_RIDER_AGE", FloatType())
        ])
    )

    actual = calc_bike_facts(input)
    assert expected.collect() == actual.collect()


def test_calc_month_facts(session: Session):
    from patches import patch_to_timestamp

    input = session.create_dataframe(
        data=[
            ['2018-03-01 09:47:00.000 +0000', 1, 10,  15],
            ['2018-03-01 09:47:14.000 +0000', 2, 20, 12],
            ['2018-04-01 09:47:04.000 +0000', 3, 6,  30]
        ],
        schema=['STARTTIME', 'BIKE_ID', 'TRIPDURATION', 'RIDER_AGE']
    )

    expected = session.create_dataframe(
        data=[
            ['Mar', 2, 15, 13.5],
            ['Apr', 1, 6, 30.0]
        ],
        schema=['MONTH', 'COUNT', 'AVG_TRIPDURATION', 'AVG_RIDER_AGE']
    )

    actual = calc_month_facts(input)

    assert expected.collect() == actual.collect()

-- Example 2234
pytest test/test_transformers.py

-- Example 2235
# test/test_sproc.py
from project.sproc import create_fact_tables

def test_create_fact_tables(session):
    ...

-- Example 2236
# test/test_sproc.py
from project.sproc import create_fact_tables
from snowflake.snowpark.types import *

def test_create_fact_tables(session):
    DB = 'CITIBIKE'
    SCHEMA = 'TEST'

    # Set up source table
    tbl = session.create_dataframe(
        data=[
            [1983, '2018-03-01 09:47:00.000 +0000', 551, 30958],
            [1988, '2018-03-01 09:47:01.000 +0000', 242, 19278],
            [1992, '2018-03-01 09:47:01.000 +0000', 768, 18461],
            [1980, '2018-03-01 09:47:03.000 +0000', 690, 15533],
            [1991, '2018-03-01 09:47:03.000 +0000', 490, 32449],
            [1959, '2018-03-01 09:47:04.000 +0000', 457, 29411],
            [1971, '2018-03-01 09:47:08.000 +0000', 279, 28015],
            [1964, '2018-03-01 09:47:09.000 +0000', 546, 15148],
            [1983, '2018-03-01 09:47:11.000 +0000', 358, 16967],
            [1985, '2018-03-01 09:47:12.000 +0000', 848, 20644],
            [1984, '2018-03-01 09:47:14.000 +0000', 295, 16365]
        ],
        schema=['BIRTH_YEAR', 'STARTTIME', 'TRIPDURATION',    'BIKEID'],
    )

    tbl.write.mode('overwrite').save_as_table([DB, SCHEMA, 'TRIPS_TEST'], mode='overwrite')

-- Example 2237
# test/test_sproc.py
from project.sproc import create_fact_tables
from snowflake.snowpark.types import *

def test_create_fact_tables(session):
    DB = 'CITIBIKE'
    SCHEMA = 'TEST'

    # Set up source table
    tbl = session.create_dataframe(
        data=[
            [1983, '2018-03-01 09:47:00.000 +0000', 551, 30958],
            [1988, '2018-03-01 09:47:01.000 +0000', 242, 19278],
            [1992, '2018-03-01 09:47:01.000 +0000', 768, 18461],
            [1980, '2018-03-01 09:47:03.000 +0000', 690, 15533],
            [1991, '2018-03-01 09:47:03.000 +0000', 490, 32449],
            [1959, '2018-03-01 09:47:04.000 +0000', 457, 29411],
            [1971, '2018-03-01 09:47:08.000 +0000', 279, 28015],
            [1964, '2018-03-01 09:47:09.000 +0000', 546, 15148],
            [1983, '2018-03-01 09:47:11.000 +0000', 358, 16967],
            [1985, '2018-03-01 09:47:12.000 +0000', 848, 20644],
            [1984, '2018-03-01 09:47:14.000 +0000', 295, 16365]
        ],
        schema=['BIRTH_YEAR', 'STARTTIME', 'TRIPDURATION',    'BIKEID'],
    )

    tbl.write.mode('overwrite').save_as_table([DB, SCHEMA, 'TRIPS_TEST'], mode='overwrite')

    # Expected values
    n_rows_expected = 12
    bike_facts_expected = session.create_dataframe(
        data=[
            [30958, 1, 551.0, 40.0],
            [19278, 1, 242.0, 35.0],
            [18461, 1, 768.0, 31.0],
            [15533, 1, 690.0, 43.0],
            [32449, 1, 490.0, 32.0],
            [29411, 1, 457.0, 64.0],
            [28015, 1, 279.0, 52.0],
            [15148, 1, 546.0, 59.0],
            [16967, 1, 358.0, 40.0],
            [20644, 1, 848.0, 38.0],
            [16365, 1, 295.0, 39.0]
        ],
        schema=StructType([
            StructField("BIKEID", IntegerType()),
            StructField("COUNT", IntegerType()),
            StructField("AVG_TRIPDURATION", FloatType()),
            StructField("AVG_RIDER_AGE", FloatType())
        ])
    ).collect()

    month_facts_expected = session.create_dataframe(
        data=[['Mar', 11, 502.18182, 43.00000]],
        schema=StructType([
            StructField("MONTH", StringType()),
            StructField("COUNT", IntegerType()),
            StructField("AVG_TRIPDURATION", DecimalType()),
            StructField("AVG_RIDER_AGE", DecimalType())
        ])
    ).collect()

-- Example 2238
# test/test_sproc.py
from project.sproc import create_fact_tables
from snowflake.snowpark.types import *

def test_create_fact_tables(session):
    DB = 'CITIBIKE'
    SCHEMA = 'TEST'

    # Set up source table
    tbl = session.create_dataframe(
        data=[
            [1983, '2018-03-01 09:47:00.000 +0000', 551, 30958],
            [1988, '2018-03-01 09:47:01.000 +0000', 242, 19278],
            [1992, '2018-03-01 09:47:01.000 +0000', 768, 18461],
            [1980, '2018-03-01 09:47:03.000 +0000', 690, 15533],
            [1991, '2018-03-01 09:47:03.000 +0000', 490, 32449],
            [1959, '2018-03-01 09:47:04.000 +0000', 457, 29411],
            [1971, '2018-03-01 09:47:08.000 +0000', 279, 28015],
            [1964, '2018-03-01 09:47:09.000 +0000', 546, 15148],
            [1983, '2018-03-01 09:47:11.000 +0000', 358, 16967],
            [1985, '2018-03-01 09:47:12.000 +0000', 848, 20644],
            [1984, '2018-03-01 09:47:14.000 +0000', 295, 16365]
        ],
        schema=['BIRTH_YEAR', 'STARTTIME', 'TRIPDURATION',    'BIKEID'],
    )

    tbl.write.mode('overwrite').save_as_table([DB, SCHEMA, 'TRIPS_TEST'], mode='overwrite')

    # Expected values
    n_rows_expected = 12
    bike_facts_expected = session.create_dataframe(
        data=[
            [30958, 1, 551.0, 40.0],
            [19278, 1, 242.0, 35.0],
            [18461, 1, 768.0, 31.0],
            [15533, 1, 690.0, 43.0],
            [32449, 1, 490.0, 32.0],
            [29411, 1, 457.0, 64.0],
            [28015, 1, 279.0, 52.0],
            [15148, 1, 546.0, 59.0],
            [16967, 1, 358.0, 40.0],
            [20644, 1, 848.0, 38.0],
            [16365, 1, 295.0, 39.0]
        ],
        schema=StructType([
            StructField("BIKEID", IntegerType()),
            StructField("COUNT", IntegerType()),
            StructField("AVG_TRIPDURATION", FloatType()),
            StructField("AVG_RIDER_AGE", FloatType())
        ])
    ).collect()

    month_facts_expected = session.create_dataframe(
        data=[['Mar', 11, 502.18182, 43.00000]],
        schema=StructType([
            StructField("MONTH", StringType()),
            StructField("COUNT", IntegerType()),
            StructField("AVG_TRIPDURATION", DecimalType()),
            StructField("AVG_RIDER_AGE", DecimalType())
        ])
    ).collect()

    # Call sproc, get actual values
    n_rows_actual = create_fact_tables(session, 'TRIPS_TEST')
    bike_facts_actual = session.table([DB, SCHEMA, 'bike_facts']).collect()
    month_facts_actual = session.table([DB, SCHEMA, 'month_facts']).collect()

    # Comparisons
    assert n_rows_expected == n_rows_actual
    assert bike_facts_expected == bike_facts_actual
    assert month_facts_expected ==  month_facts_actual

-- Example 2239
pytest test/test_sproc.py

-- Example 2240
pytest

-- Example 2241
# test/conftest.py

import pytest
from project.utils import get_env_var_config
from snowflake.snowpark.session import Session

def pytest_addoption(parser):
    parser.addoption("--snowflake-session", action="store", default="live")

@pytest.fixture(scope='module')
def session(request) -> Session:
    if request.config.getoption('--snowflake-session') == 'local':
        return Session.builder.configs({'local_testing': True}).create()
    else:
        return Session.builder.configs(get_env_var_config()).create()

-- Example 2242
from snowflake.snowpark.mock.functions import patch
from snowflake.snowpark.functions import monthname
from snowflake.snowpark.mock.snowflake_data_type import ColumnEmulator, ColumnType
from snowflake.snowpark.types import StringType
import datetime
import calendar

@patch(monthname)
def patch_monthname(column: ColumnEmulator) -> ColumnEmulator:
    ret_column = ColumnEmulator(data=[
        calendar.month_abbr[datetime.datetime.strptime(row, '%Y-%m-%d %H:%M:%S.%f %z').month]
        for row in column])
    ret_column.sf_type = ColumnType(StringType(), True)
    return ret_column

-- Example 2243
# test/test_transformers.py

# No changes to the other unit test methods

def test_calc_month_facts(request, session):
    # Add conditional to include the patch if local testing is being used
    if request.config.getoption('--snowflake-session') == 'local':
        from patches import patch_monthname

    # No other changes

-- Example 2244
pytest test/test_transformers.py --snowflake-session local

