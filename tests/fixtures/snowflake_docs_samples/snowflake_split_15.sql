-- Example 953
CREATE OR REPLACE TABLE ts_test(ts TIMESTAMP_TZ);

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2024-01-01 16:00:00');
INSERT INTO ts_test VALUES('2024-01-02 16:00:00 +00:00');

-- Example 954
SELECT ts, HOUR(ts) FROM ts_test;

-- Example 955
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 16:00:00.000 +0000 |       16 |
+-------------------------------+----------+

-- Example 956
ALTER SESSION SET TIMEZONE = 'America/New_York';

SELECT ts, HOUR(ts) FROM ts_test;

-- Example 957
+-------------------------------+----------+
| TS                            | HOUR(TS) |
|-------------------------------+----------|
| 2024-01-01 16:00:00.000 -0800 |       16 |
| 2024-01-02 16:00:00.000 +0000 |       16 |
+-------------------------------+----------+

-- Example 958
CREATE OR REPLACE TABLE timestamp_demo_table(
  tstmp TIMESTAMP,
  tstmp_tz TIMESTAMP_TZ,
  tstmp_ntz TIMESTAMP_NTZ,
  tstmp_ltz TIMESTAMP_LTZ);
INSERT INTO timestamp_demo_table (tstmp, tstmp_tz, tstmp_ntz, tstmp_ltz) VALUES (
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789',
  '2024-03-12 01:02:03.123456789');

-- Example 959
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_TZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_LTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';

-- Example 960
SELECT tstmp, tstmp_tz, tstmp_ntz, tstmp_ltz
  FROM timestamp_demo_table;

-- Example 961
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+
| TSTMP                         | TSTMP_TZ                      | TSTMP_NTZ                     | TSTMP_LTZ                     |
|-------------------------------+-------------------------------+-------------------------------+-------------------------------|
| 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 | 2024-03-12 01:02:03.123456789 |
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+

-- Example 962
DATE '2024-08-14'
TIME '10:03:56'
TIMESTAMP '2024-08-15 10:59:43'

-- Example 963
CREATE TABLE t1 (d1 DATE);

INSERT INTO t1 (d1) VALUES (DATE '2024-08-15');

-- Example 964
{ + | - } INTERVAL '<integer> [ <date_time_part> ] [ , <integer> [ <date_time_part> ] ... ]'

-- Example 965
SELECT TO_DATE ('2019-02-28') + INTERVAL '1 day, 1 year';

-- Example 966
+---------------------------------------------------+
| TO_DATE ('2019-02-28') + INTERVAL '1 DAY, 1 YEAR' |
|---------------------------------------------------|
| 2020-03-01                                        |
+---------------------------------------------------+

-- Example 967
SELECT TO_DATE ('2019-02-28') + INTERVAL '1 year, 1 day';

-- Example 968
+---------------------------------------------------+
| TO_DATE ('2019-02-28') + INTERVAL '1 YEAR, 1 DAY' |
|---------------------------------------------------|
| 2020-02-29                                        |
+---------------------------------------------------+

-- Example 969
SET v1 = '1 year';

SELECT TO_DATE('2023-04-15') + INTERVAL $v1;

-- Example 970
SELECT TO_DATE('2023-04-15') + INTERVAL '1 year';

-- Example 971
+-------------------------------------------+
| TO_DATE('2023-04-15') + INTERVAL '1 YEAR' |
|-------------------------------------------|
| 2024-04-15                                |
+-------------------------------------------+

-- Example 972
SELECT TO_TIME('04:15:29') + INTERVAL '3 hours, 18 minutes';

-- Example 973
+------------------------------------------------------+
| TO_TIME('04:15:29') + INTERVAL '3 HOURS, 18 MINUTES' |
|------------------------------------------------------|
| 07:33:29                                             |
+------------------------------------------------------+

-- Example 974
SELECT CURRENT_TIMESTAMP + INTERVAL
    '1 year, 3 quarters, 4 months, 5 weeks, 6 days, 7 minutes, 8 seconds,
    1000 milliseconds, 4000000 microseconds, 5000000001 nanoseconds'
  AS complex_interval1;

-- Example 975
+-------------------------------+
| COMPLEX_INTERVAL1             |
|-------------------------------|
| 2026-11-07 18:07:19.875000001 |
+-------------------------------+

-- Example 976
SELECT TO_DATE('2025-01-17') + INTERVAL
    '1 y, 3 q, 4 mm, 5 w, 6 d, 7 h, 9 m, 8 s,
    1000 ms, 445343232 us, 898498273498 ns'
  AS complex_interval2;

-- Example 977
+-------------------------------+
| COMPLEX_INTERVAL2             |
|-------------------------------|
| 2027-03-30 07:31:32.841505498 |
+-------------------------------+

-- Example 978
SELECT name, hire_date
  FROM employees
  WHERE hire_date > CURRENT_DATE - INTERVAL '2 y, 3 month';

-- Example 979
SELECT ts + INTERVAL '4 seconds'
  FROM t1
  WHERE ts > TO_TIMESTAMP('2024-04-05 01:02:03');

-- Example 980
SELECT TO_DATE('2024-04-15') + 1;

-- Example 981
+---------------------------+
| TO_DATE('2024-04-15') + 1 |
|---------------------------|
| 2024-04-16                |
+---------------------------+

-- Example 982
SELECT TO_DATE('2024-04-15') - 4;

-- Example 983
+---------------------------+
| TO_DATE('2024-04-15') - 4 |
|---------------------------|
| 2024-04-11                |
+---------------------------+

-- Example 984
SELECT name
  FROM employees
  WHERE end_date > start_date + 365;

-- Example 985
CREATE OR REPLACE TABLE geospatial_table (id INTEGER, g GEOGRAPHY);
INSERT INTO geospatial_table VALUES
  (1, 'POINT(-122.35 37.55)'),
  (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 986
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='GeoJSON';

-- Example 987
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 988
+------------------------+
| G                      |
|------------------------|
| {                      |
|   "coordinates": [     |
|     -122.35,           |
|     37.55              |
|   ],                   |
|   "type": "Point"      |
| }                      |
| {                      |
|   "coordinates": [     |
|     [                  |
|       -124.2,          |
|       42               |
|     ],                 |
|     [                  |
|       -120.01,         |
|       41.99            |
|     ]                  |
|   ],                   |
|   "type": "LineString" |
| }                      |
+------------------------+

-- Example 989
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';

-- Example 990
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 991
+-------------------------------------+
| G                                   |
|-------------------------------------|
| POINT(-122.35 37.55)                |
| LINESTRING(-124.2 42,-120.01 41.99) |
+-------------------------------------+

-- Example 992
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKB';

-- Example 993
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 994
+------------------------------------------------------------------------------------+
| G                                                                                  |
|------------------------------------------------------------------------------------|
| 01010000006666666666965EC06666666666C64240                                         |
| 010200000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+------------------------------------------------------------------------------------+

-- Example 995
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='EWKT';

-- Example 996
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 997
+-----------------------------------------------+
| G                                             |
|-----------------------------------------------|
| SRID=4326;POINT(-122.35 37.55)                |
| SRID=4326;LINESTRING(-124.2 42,-120.01 41.99) |
+-----------------------------------------------+

-- Example 998
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='EWKB';

-- Example 999
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 1000
+--------------------------------------------------------------------------------------------+
| G                                                                                          |
|--------------------------------------------------------------------------------------------|
| 0101000020E61000006666666666965EC06666666666C64240                                         |
| 0102000020E610000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+--------------------------------------------------------------------------------------------+

-- Example 1001
SELECT ST_TRANSFORM(geometry_expression, 32633);

-- Example 1002
SELECT ST_TRANSFORM(geometry_expression, 4326, 28992);

-- Example 1003
SELECT ST_SETSRID(geometry_expression, 4326);

-- Example 1004
CREATE OR REPLACE FUNCTION my_st_x(g GEOGRAPHY) RETURNS REAL
LANGUAGE JAVASCRIPT
AS
$$
  if (G["type"] != "Point")
  {
     throw "Not a point"
  }
  return G["coordinates"][0]
$$;

CREATE OR REPLACE FUNCTION my_st_makepoint(lng REAL, lat REAL) RETURNS GEOGRAPHY
LANGUAGE JAVASCRIPT
AS
$$
  g = {}
  g["type"] = "Point"
  g["coordinates"] = [ LNG, LAT ]
  return g
$$;

-- Example 1005
CREATE OR REPLACE FUNCTION py_numgeographys(geo GEOGRAPHY)
RETURNS INTEGER
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
PACKAGES = ('shapely')
HANDLER = 'udf'
AS $$
from shapely.geometry import shape, mapping
def udf(geo):
    if geo['type'] not in ('MultiPoint', 'MultiLineString', 'MultiPolygon', 'GeometryCollection'):
        raise ValueError('Must be a composite geometry type')
    else:
        g1 = shape(geo)
        return len(g1.geoms)
$$;

-- Example 1006
SELECT ST_DISTANCE(
    ST_POINT(13.4814, 52.5015),
    ST_POINT(-121.8212, 36.8252))
  AS distance_in_meters;

-- Example 1007
+--------------------+
| DISTANCE_IN_METERS |
|--------------------|
|   9182410.99227821 |
+--------------------+

-- Example 1008
SELECT ST_DISTANCE(
    ST_GEOMPOINT(13.4814, 52.5015),
    ST_GEOMPOINT(-121.8212, 36.8252))
  AS distance_in_degrees;

-- Example 1009
+---------------------+
| DISTANCE_IN_DEGREES |
|---------------------|
|       136.207708844 |
+---------------------+

-- Example 1010
SELECT ST_AREA(border) AS area_in_sq_meters
  FROM world_countries
  WHERE name = 'Germany';

-- Example 1011
+-------------------+
| AREA_IN_SQ_METERS |
|-------------------|
|  356379183635.591 |
+-------------------+

-- Example 1012
SELECT ST_AREA(border) as area_in_sq_degrees
  FROM world_countries_geom
  WHERE name = 'Germany';

-- Example 1013
+--------------------+
| AREA_IN_SQ_DEGREES |
|--------------------|
|       45.930026848 |
+--------------------+

-- Example 1014
SELECT name FROM world_countries WHERE
  ST_INTERSECTS(border,
    TO_GEOGRAPHY(
      'LINESTRING(13.4814 52.5015, -121.8212 36.8252)'
    ));

-- Example 1015
+--------------------------+
| NAME                     |
|--------------------------|
|                  Germany |
|                  Denmark |
|                  Iceland |
|                Greenland |
|                   Canada |
| United States of America |
+--------------------------+

-- Example 1016
SELECT name FROM world_countries_geom WHERE
  ST_INTERSECTS(border,
    TO_GEOMETRY(
      'LINESTRING(13.4814 52.5015, -121.8212 36.8252)'
    ));

-- Example 1017
+--------------------------+
| NAME                     |
|--------------------------|
|                  Germany |
|                  Belgium |
|              Netherlands |
|           United Kingdom |
| United States of America |
+--------------------------+

-- Example 1018
POLYGON((0 50, 25 50, 50 50, 0 50))

-- Example 1019
SELECT TO_GEOMETRY(TO_GEOGRAPHY('POINT(-122.306100 37.554162)'));

-- Example 1020
SELECT TO_GEOMETRY(TO_GEOGRAPHY('POINT(-122.306100 37.554162)', 4326));

