-- Example 4673
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='EWKT';

-- Example 4674
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 4675
+-----------------------------------------------+
| G                                             |
|-----------------------------------------------|
| SRID=4326;POINT(-122.35 37.55)                |
| SRID=4326;LINESTRING(-124.2 42,-120.01 41.99) |
+-----------------------------------------------+

-- Example 4676
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='EWKB';

-- Example 4677
SELECt g
  FROM geospatial_table
  ORDER BY id;

-- Example 4678
+--------------------------------------------------------------------------------------------+
| G                                                                                          |
|--------------------------------------------------------------------------------------------|
| 0101000020E61000006666666666965EC06666666666C64240                                         |
| 0102000020E610000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+--------------------------------------------------------------------------------------------+

-- Example 4679
SELECT ST_TRANSFORM(geometry_expression, 32633);

-- Example 4680
SELECT ST_TRANSFORM(geometry_expression, 4326, 28992);

-- Example 4681
SELECT ST_SETSRID(geometry_expression, 4326);

-- Example 4682
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

-- Example 4683
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

-- Example 4684
SELECT ST_DISTANCE(
    ST_POINT(13.4814, 52.5015),
    ST_POINT(-121.8212, 36.8252))
  AS distance_in_meters;

-- Example 4685
+--------------------+
| DISTANCE_IN_METERS |
|--------------------|
|   9182410.99227821 |
+--------------------+

-- Example 4686
SELECT ST_DISTANCE(
    ST_GEOMPOINT(13.4814, 52.5015),
    ST_GEOMPOINT(-121.8212, 36.8252))
  AS distance_in_degrees;

-- Example 4687
+---------------------+
| DISTANCE_IN_DEGREES |
|---------------------|
|       136.207708844 |
+---------------------+

-- Example 4688
SELECT ST_AREA(border) AS area_in_sq_meters
  FROM world_countries
  WHERE name = 'Germany';

-- Example 4689
+-------------------+
| AREA_IN_SQ_METERS |
|-------------------|
|  356379183635.591 |
+-------------------+

-- Example 4690
SELECT ST_AREA(border) as area_in_sq_degrees
  FROM world_countries_geom
  WHERE name = 'Germany';

-- Example 4691
+--------------------+
| AREA_IN_SQ_DEGREES |
|--------------------|
|       45.930026848 |
+--------------------+

-- Example 4692
SELECT name FROM world_countries WHERE
  ST_INTERSECTS(border,
    TO_GEOGRAPHY(
      'LINESTRING(13.4814 52.5015, -121.8212 36.8252)'
    ));

-- Example 4693
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

-- Example 4694
SELECT name FROM world_countries_geom WHERE
  ST_INTERSECTS(border,
    TO_GEOMETRY(
      'LINESTRING(13.4814 52.5015, -121.8212 36.8252)'
    ));

-- Example 4695
+--------------------------+
| NAME                     |
|--------------------------|
|                  Germany |
|                  Belgium |
|              Netherlands |
|           United Kingdom |
| United States of America |
+--------------------------+

-- Example 4696
POLYGON((0 50, 25 50, 50 50, 0 50))

-- Example 4697
SELECT TO_GEOMETRY(TO_GEOGRAPHY('POINT(-122.306100 37.554162)'));

-- Example 4698
SELECT TO_GEOMETRY(TO_GEOGRAPHY('POINT(-122.306100 37.554162)', 4326));

-- Example 4699
TO_GEOGRAPHY( <input> [, <allowInvalid> ] )

-- Example 4700
ST_GEOGFROMWKB( <input> [, <allowInvalid> ] )

-- Example 4701
ST_GEOGFROMWKT( <input> [, <allowInvalid> ] )

-- Example 4702
TO_GEOMETRY( <input> [, <allowInvalid> ] )

-- Example 4703
ST_GEOMFROMWKB( <input> [, <allowInvalid> ] )

-- Example 4704
ST_GEOMFROMWKT( <input> [, <allowInvalid> ] )

-- Example 4705
SELECT TO_GEOMETRY('LINESTRING(100 102,100 102)', TRUE);

-- Example 4706
SELECT TO_GEOMETRY('LINESTRING(100 102,100 102)', TRUE) AS g, ST_ISVALID(g);

-- Example 4707
H3_CELL_TO_CHILDREN( <cell_id> , <target_resolution> )

-- Example 4708
SELECT H3_CELL_TO_CHILDREN(613036919424548863, 9);

-- Example 4709
+--------------------------------------------+
| H3_CELL_TO_CHILDREN(613036919424548863, 9) |
|--------------------------------------------|
| [                                          |
|   617540519050084351,                      |
|   617540519050346495,                      |
|   617540519050608639,                      |
|   617540519050870783,                      |
|   617540519051132927,                      |
|   617540519051395071,                      |
|   617540519051657215                       |
| ]                                          |
+--------------------------------------------+

-- Example 4710
H3_CELL_TO_CHILDREN_STRING( <cell_id> , <target_resolution> )

-- Example 4711
SELECT H3_CELL_TO_CHILDREN_STRING('881F1D4887FFFFF', 9);

-- Example 4712
+--------------------------------------------------+
| H3_CELL_TO_CHILDREN_STRING('881F1D4887FFFFF', 9) |
|--------------------------------------------------|
| [                                                |
|   "891f1d48863ffff",                             |
|   "891f1d48867ffff",                             |
|   "891f1d4886bffff",                             |
|   "891f1d4886fffff",                             |
|   "891f1d48873ffff",                             |
|   "891f1d48877ffff",                             |
|   "891f1d4887bffff"                              |
| ]                                                |
+--------------------------------------------------+

-- Example 4713
H3_CELL_TO_PARENT( <cell_id> , <target_resolution> )

-- Example 4714
SELECT H3_CELL_TO_PARENT(613036919424548863, 7);

-- Example 4715
+------------------------------------------+
| H3_CELL_TO_PARENT(613036919424548863, 7) |
|------------------------------------------|
|                       608533319805566975 |
+------------------------------------------+

-- Example 4716
SELECT H3_CELL_TO_PARENT('881F1D4887FFFFF', 7);

-- Example 4717
+-----------------------------------------+
| H3_CELL_TO_PARENT('881F1D4887FFFFF', 7) |
|-----------------------------------------|
|  871F1D488FFFFFF                        |
+-----------------------------------------+

-- Example 4718
H3_CELL_TO_POINT( <cell_id> )

-- Example 4719
SELECT H3_CELL_TO_POINT(613036919424548863);

-- Example 4720
+--------------------------------------+
| H3_CELL_TO_POINT(613036919424548863) |
|--------------------------------------|
| {                                    |
|   "coordinates": [                   |
|     1.337676791184706e+01,           |
|     5.251638386722465e+01            |
|   ],                                 |
|   "type": "Point"                    |
| }                                    |
+--------------------------------------+

-- Example 4721
SELECT H3_CELL_TO_POINT('881F1D4887FFFFF');

-- Example 4722
+-------------------------------------+
| H3_CELL_TO_POINT('881F1D4887FFFFF') |
|-------------------------------------|
| {                                   |
|   "coordinates": [                  |
|     1.337676791184706e+01,          |
|     5.251638386722465e+01           |
|   ],                                |
|   "type": "Point"                   |
| }                                   |
+-------------------------------------+

-- Example 4723
H3_COMPACT_CELLS( <array_of_cell_ids> )

-- Example 4724
SELECT H3_COMPACT_CELLS(
  [
    622236750562230271,
    622236750562263039,
    622236750562295807,
    622236750562328575,
    622236750562361343,
    622236750562394111,
    622236750562426879,
    622236750558396415
  ]
) AS compacted;

-- Example 4725
+-----------------------+
| COMPACTED             |
|-----------------------|
| [                     |
|   622236750558396415, |
|   617733150935089151  |
| ]                     |
+-----------------------+

-- Example 4726
H3_COMPACT_CELLS_STRINGS( <array_of_cell_ids> )

-- Example 4727
SELECT H3_COMPACT_CELLS_STRINGS(
  [
    '8a2a10705507fff',
    '8a2a1070550ffff',
    '8a2a10705517fff',
    '8a2a1070551ffff',
    '8a2a10705527fff',
    '8a2a1070552ffff',
    '8a2a10705537fff',
    '8a2a10705cdffff'
    ]
  ) AS compacted;

-- Example 4728
+----------------------+
| COMPACTED            |
|----------------------|
| [                    |
|   "8a2a10705cdffff", |
|   "892a1070553ffff"  |
| ]                    |
+----------------------+

-- Example 4729
H3_COVERAGE( <geography_expression> , <target_resolution> )

-- Example 4730
SELECT H3_COVERAGE(
  TO_GEOGRAPHY(
    'POLYGON((-122.481889 37.826683,-122.479487 37.808548,-122.474150 37.808904,-122.476510 37.826935,-122.481889 37.826683))'),
  8) AS set_of_h3_cells_covering_polygon;

-- Example 4731
+----------------------------------+
| SET_OF_H3_CELLS_COVERING_POLYGON |
|----------------------------------|
| [                                |
|   613196571542028287,            |
|   613196571548319743,            |
|   613196571598651391,            |
|   613196571539931135,            |
|   613196571560902655,            |
|   613196571550416895             |
| ]                                |
+----------------------------------+

-- Example 4732
H3_COVERAGE_STRINGS( <geography_expression> , <target_resolution> )

-- Example 4733
SELECT H3_COVERAGE_STRINGS(
  TO_GEOGRAPHY(
    'POLYGON((-122.481889 37.826683,-122.479487 37.808548,-122.474150 37.808904,-122.476510 37.826935,-122.481889 37.826683))'),
  8) AS set_of_h3_cells_covering_polygon;

-- Example 4734
+----------------------------------+
| SET_OF_H3_CELLS_COVERING_POLYGON |
|----------------------------------|
| [                                |
|   "882830870bfffff",             |
|   "8828308703fffff",             |
|   "8828308739fffff",             |
|   "8828308709fffff",             |
|   "8828308701fffff",             |
|   "8828308715fffff"              |
| ]                                |
|----------------------------------|

-- Example 4735
H3_GET_RESOLUTION( <cell_id> )

-- Example 4736
SELECT H3_GET_RESOLUTION(617540519050084351);

-- Example 4737
+---------------------------------------+
| H3_GET_RESOLUTION(617540519050084351) |
|---------------------------------------|
|                                     9 |
+---------------------------------------+

-- Example 4738
SELECT H3_GET_RESOLUTION('89283087033ffff');

-- Example 4739
+--------------------------------------+
| H3_GET_RESOLUTION('89283087033FFFF') |
|--------------------------------------|
|                                    9 |
+--------------------------------------+

