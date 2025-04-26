-- Example 6279
SELECT ST_CENTROID(TO_GEOMETRY('POLYGON((10 10, 10 20, 20 20, 20 10, 10 10))'));

-- Example 6280
+--------------------------------------------------------------------------+
| ST_CENTROID(TO_GEOMETRY('POLYGON((10 10, 10 20, 20 20, 20 10, 10 10))')) |
|--------------------------------------------------------------------------|
| POINT(15 15)                                                             |
+--------------------------------------------------------------------------+

-- Example 6281
Scalar:

    ST_COLLECT( <geography_expression_1> , <geography_expression_2> )

Aggregate:

    ST_COLLECT( <geography_expression_1> )

-- Example 6282
CREATE TABLE geo3 (g1 GEOGRAPHY, g2 GEOGRAPHY);
INSERT INTO geo3 (g1, g2) VALUES
    ( 'POINT(-180 -90)', 'POINT(-45 -45)' ),
    ( 'POINT(   0   0)', 'POINT(-60 -60)' ),
    ( 'POINT(+180 +90)', 'POINT(+45 +45)' );

-- Example 6283
-- Scalar function:
SELECT ST_COLLECT(g1, g2) FROM geo3;
+------------------------+
| ST_COLLECT(G1, G2)     |
|------------------------|
| {                      |
|   "coordinates": [     |
|     [                  |
|       -180,            |
|       -90              |
|     ],                 |
|     [                  |
|       -45,             |
|       -45              |
|     ]                  |
|   ],                   |
|   "type": "MultiPoint" |
| }                      |
| {                      |
|   "coordinates": [     |
|     [                  |
|       0,               |
|       0                |
|     ],                 |
|     [                  |
|       -60,             |
|       -60              |
|     ]                  |
|   ],                   |
|   "type": "MultiPoint" |
| }                      |
| {                      |
|   "coordinates": [     |
|     [                  |
|       180,             |
|       90               |
|     ],                 |
|     [                  |
|       45,              |
|       45               |
|     ]                  |
|   ],                   |
|   "type": "MultiPoint" |
| }                      |
+------------------------+

-- Example 6284
-- Aggregate function:
SELECT ST_COLLECT(g1), ST_COLLECT(g2) FROM geo3;
+------------------------+------------------------+
| ST_COLLECT(G1)         | ST_COLLECT(G2)         |
|------------------------+------------------------|
| {                      | {                      |
|   "coordinates": [     |   "coordinates": [     |
|     [                  |     [                  |
|       -180,            |       -45,             |
|       -90              |       -45              |
|     ],                 |     ],                 |
|     [                  |     [                  |
|       0,               |       -60,             |
|       0                |       -60              |
|     ],                 |     ],                 |
|     [                  |     [                  |
|       180,             |       45,              |
|       90               |       45               |
|     ]                  |     ]                  |
|   ],                   |   ],                   |
|   "type": "MultiPoint" |   "type": "MultiPoint" |
| }                      | }                      |
+------------------------+------------------------+

-- Example 6285
-- Aggregate and then Collect:
SELECT ST_COLLECT(ST_COLLECT(g1), ST_COLLECT(g2)) FROM geo3;
+--------------------------------------------+
| ST_COLLECT(ST_COLLECT(G1), ST_COLLECT(G2)) |
|--------------------------------------------|
| {                                          |
|   "geometries": [                          |
|     {                                      |
|       "coordinates": [                     |
|         [                                  |
|           -180,                            |
|           -90                              |
|         ],                                 |
|         [                                  |
|           0,                               |
|           0                                |
|         ],                                 |
|         [                                  |
|           180,                             |
|           90                               |
|         ]                                  |
|       ],                                   |
|       "type": "MultiPoint"                 |
|     },                                     |
|     {                                      |
|       "coordinates": [                     |
|         [                                  |
|           -45,                             |
|           -45                              |
|         ],                                 |
|         [                                  |
|           -60,                             |
|           -60                              |
|         ],                                 |
|         [                                  |
|           45,                              |
|           45                               |
|         ]                                  |
|       ],                                   |
|       "type": "MultiPoint"                 |
|     }                                      |
|   ],                                       |
|   "type": "GeometryCollection"             |
| }                                          |
+--------------------------------------------+

-- Example 6286
ST_CONTAINS( <geography_expression_1> , <geography_expression_2> )

ST_CONTAINS( <geometry_expression_1> , <geometry_expression_2> )

-- Example 6287
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 6288
SELECT ST_CONTAINS(g1, g2) 
    FROM geospatial_table_01;
+---------------------+
| ST_CONTAINS(G1, G2) |
|---------------------|
| True                |
+---------------------+

-- Example 6289
SELECT ST_CONTAINS(poly, poly_inside),
      ST_CONTAINS(poly, poly),
      ST_CONTAINS(poly, line_on_boundary),
      ST_CONTAINS(poly, line_inside)
  FROM (SELECT
    TO_GEOMETRY('POLYGON((-2 0, 0 2, 2 0, -2 0))') AS poly,
    TO_GEOMETRY('POLYGON((-1 0, 0 1, 1 0, -1 0))') AS poly_inside,
    TO_GEOMETRY('LINESTRING(-1 1, 0 2, 1 1)') AS line_on_boundary,
    TO_GEOMETRY('LINESTRING(-2 0, 0 0, 0 1)') AS line_inside);

-- Example 6290
+--------------------------------+------------------------+------------------------------------+-------------------------------+
| ST_CONTAINS(POLY, POLY_INSIDE) | ST_CONTAINS(POLY,POLY) | ST_CONTAINS(POLY,LINE_ON_BOUNDARY) | ST_CONTAINS(POLY,LINE_INSIDE) |
|--------------------------------+------------------------+------------------------------------+-------------------------------|
| True                           | True                   | False                              | True                          |
+--------------------------------+------------------------+------------------------------------+-------------------------------+

-- Example 6291
ST_COVEREDBY( <geography_expression_1> , <geography_expression_2> )

ST_COVEREDBY( <geometry_expression_1> , <geometry_expression_2> )

-- Example 6292
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 6293
SELECT ST_COVEREDBY(g1, g2) 
    FROM geospatial_table_01;
+----------------------+
| ST_COVEREDBY(G1, G2) |
|----------------------|
| False                |
+----------------------+

-- Example 6294
ST_COVERS( <geography_expression_1> , <geography_expression_2> )

ST_COVERS( <geometry_expression_1> , <geometry_expression_2> )

-- Example 6295
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 6296
SELECT ST_COVERS(g1, g2) 
    FROM geospatial_table_01;
+-------------------+
| ST_COVERS(G1, G2) |
|-------------------|
| True              |
+-------------------+

-- Example 6297
SELECT ST_COVERS(poly, poly_inside),
       ST_COVERS(poly, poly),
       ST_COVERS(poly, line_on_boundary),
       ST_COVERS(poly, line_inside)
  FROM (SELECT TO_GEOMETRY('POLYGON((-2 0, 0 2, 2 0, -2 0))') AS poly,
               TO_GEOMETRY('POLYGON((-1 0, 0 1, 1 0, -1 0))') AS poly_inside,
               TO_GEOMETRY('LINESTRING(-1 1, 0 2, 1 1)') AS line_on_boundary,
               TO_GEOMETRY('LINESTRING(-2 0, 0 0, 0 1)') AS line_inside);

-- Example 6298
+------------------------------+----------------------+----------------------------------+-----------------------------+
| ST_COVERS(POLY, POLY_INSIDE) | ST_COVERS(POLY,POLY) | ST_COVERS(POLY,LINE_ON_BOUNDARY) | ST_COVERS(POLY,LINE_INSIDE) |
|------------------------------+----------------------+----------------------------------+-----------------------------|
| True                         | True                 | True                             | True                        |
+------------------------------+----------------------+----------------------------------+-----------------------------+

-- Example 6299
ST_DIFFERENCE( <geography_expression_1> , <geography_expression_2> )

-- Example 6300
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT = 'WKT';

SELECT ST_DIFFERENCE(
  TO_GEOGRAPHY('POLYGON((0 0, 1 0, 2 1, 1 2, 2 3, 1 4, 0 4, 0 0))'),
  TO_GEOGRAPHY('POLYGON((3 0, 3 4, 2 4, 1 3, 2 2, 1 1, 2 0, 3 0))'))
AS difference_between_objects;

-- Example 6301
+-------------------------------------------------------------------------------------------------------------+
| DIFFERENCE_BETWEEN_OBJECTS                                                                                  |
|-------------------------------------------------------------------------------------------------------------|
| POLYGON((1 1,1.5 1.500171359,1 2,1.5 2.500285599,1 3,1.5 3.500399839,1 4,0 4,0 0,1 0,1.5 0.5000571198,1 1)) |
+-------------------------------------------------------------------------------------------------------------+

-- Example 6302
ST_DIMENSION( <geography_or_geometry_expression> )

-- Example 6303
create table geospatial_table_02 (id INTEGER, g GEOGRAPHY);
insert into geospatial_table_02 values
    (1, 'POINT(-122.35 37.55)'),
    (2, 'MULTIPOINT((-122.35 37.55), (0.00 -90.0))'),
    (3, 'LINESTRING(-124.20 42.00, -120.01 41.99)'),
    (4, 'LINESTRING(-124.20 42.00, -120.01 41.99, -122.5 42.01)'),
    (5, 'MULTILINESTRING((-124.20 42.00, -120.01 41.99, -122.5 42.01), (10.0 0.0, 20.0 10.0, 30.0 0.0))'),
    (6, 'POLYGON((-124.20 42.00, -120.01 41.99, -121.1 42.01, -124.20 42.00))'),
    (7, 'MULTIPOLYGON(((-124.20 42.00, -120.01 41.99, -121.1 42.01, -124.20 42.0)), ((20.0 20.0, 40.0 20.0, 40.0 40.0, 20.0 40.0, 20.0 20.0)))')
    ;

-- Example 6304
select st_dimension(g) as dimension, st_aswkt(g)
    from geospatial_table_02
    order by dimension, id;
+-----------+----------------------------------------------------------------------------------------------------+
| DIMENSION | ST_ASWKT(G)                                                                                        |
|-----------+----------------------------------------------------------------------------------------------------|
|         0 | POINT(-122.35 37.55)                                                                               |
|         0 | MULTIPOINT((-122.35 37.55),(0 -90))                                                                |
|         1 | LINESTRING(-124.2 42,-120.01 41.99)                                                                |
|         1 | LINESTRING(-124.2 42,-120.01 41.99,-122.5 42.01)                                                   |
|         1 | MULTILINESTRING((-124.2 42,-120.01 41.99,-122.5 42.01),(10 0,20 10,30 0))                          |
|         2 | POLYGON((-124.2 42,-120.01 41.99,-121.1 42.01,-124.2 42))                                          |
|         2 | MULTIPOLYGON(((-124.2 42,-120.01 41.99,-121.1 42.01,-124.2 42)),((20 20,40 20,40 40,20 40,20 20))) |
+-----------+----------------------------------------------------------------------------------------------------+

-- Example 6305
CREATE OR REPLACE TABLE geometry_shapes (g GEOMETRY);
INSERT INTO geometry_shapes VALUES
    ('POINT(66 12)'),
    ('MULTIPOINT((45 21), (12 54))'),
    ('LINESTRING(40 60, 50 50, 60 40)'),
    ('MULTILINESTRING((1 1, 32 17), (33 12, 73 49, 87.1 6.1))'),
    ('POLYGON((17 17, 17 30, 30 30, 30 17, 17 17))'),
    ('MULTIPOLYGON(((-10 0,0 10,10 0,-10 0)),((-10 40,10 40,0 20,-10 40)))'),
    ('GEOMETRYCOLLECTION(POLYGON((-10 0,0 10,10 0,-10 0)),LINESTRING(40 60, 50 50, 60 40), POINT(99 11))')
    ;

SELECT ST_DIMENSION(g), ST_ASWKT(g) FROM geometry_shapes;

-- Example 6306
+-----------------+-------------------------------------------------------------------------------------------------+
| ST_DIMENSION(G) | ST_ASWKT(G)                                                                                     |
|-----------------+-------------------------------------------------------------------------------------------------|
|               0 | POINT(66 12)                                                                                    |
|               0 | MULTIPOINT((45 21),(12 54))                                                                     |
|               1 | LINESTRING(40 60,50 50,60 40)                                                                   |
|               1 | MULTILINESTRING((1 1,32 17),(33 12,73 49,87.1 6.1))                                             |
|               2 | POLYGON((17 17,17 30,30 30,30 17,17 17))                                                        |
|               2 | MULTIPOLYGON(((-10 0,0 10,10 0,-10 0)),((-10 40,10 40,0 20,-10 40)))                            |
|               2 | GEOMETRYCOLLECTION(POLYGON((-10 0,0 10,10 0,-10 0)),LINESTRING(40 60,50 50,60 40),POINT(99 11)) |
+-----------------+-------------------------------------------------------------------------------------------------+

-- Example 6307
ST_DISJOINT( <geography_expression_1> , <geography_expression_2> )

ST_DISJOINT( <geometry_expression_1> , <geometry_expression_2> )

-- Example 6308
-- These two polygons are disjoint and do not intersect.
SELECT ST_DISJOINT(
    TO_GEOGRAPHY('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))'),
    TO_GEOGRAPHY('POLYGON((3 3, 5 3, 5 5, 3 5, 3 3))')
    );
+---------------------------------------------------------+
| ST_DISJOINT(                                            |
|     TO_GEOGRAPHY('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))'), |
|     TO_GEOGRAPHY('POLYGON((3 3, 5 3, 5 5, 3 5, 3 3))')  |
|     )                                                   |
|---------------------------------------------------------|
| True                                                    |
+---------------------------------------------------------+

-- Example 6309
-- These two polygons intersect and are not disjoint.
SELECT ST_DISJOINT(
    TO_GEOGRAPHY('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))'),
    TO_GEOGRAPHY('POLYGON((1 1, 3 1, 3 3, 1 3, 1 1))')
    );
+---------------------------------------------------------+
| ST_DISJOINT(                                            |
|     TO_GEOGRAPHY('POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))'), |
|     TO_GEOGRAPHY('POLYGON((1 1, 3 1, 3 3, 1 3, 1 1))')  |
|     )                                                   |
|---------------------------------------------------------|
| False                                                   |
+---------------------------------------------------------+

-- Example 6310
ST_DISTANCE( <geography_or_geometry_expression_1> , <geography_or_geometry_expression_2> )

-- Example 6311
WITH d AS
  ( ST_DISTANCE(ST_MAKEPOINT(0, 0), ST_MAKEPOINT(1, 0)) )
SELECT d / 1000 AS kilometers, d / 1609 AS miles;

-- Example 6312
+---------------+--------------+
|    KILOMETERS |        MILES |
|---------------+--------------|
| 111.195101177 | 69.108204585 |
+---------------+--------------+

-- Example 6313
SELECT ST_DISTANCE(ST_MAKEPOINT(0, 0), ST_MAKEPOINT(NULL, NULL)) AS null_input;

-- Example 6314
+------------+
| NULL_INPUT |
|------------|
|       NULL |
+------------+

-- Example 6315
SELECT ST_DISTANCE(TO_GEOMETRY('POINT(0 0)'), TO_GEOMETRY('POINT(1 1)')) AS geometry_distance,
  ST_DISTANCE(TO_GEOGRAPHY('POINT(0 0)'), TO_GEOGRAPHY('POINT(1 1)')) AS geography_distance;

-- Example 6316
+-------------------+--------------------+
| GEOMETRY_DISTANCE | GEOGRAPHY_DISTANCE |
|-------------------+--------------------|
|       1.414213562 |   157249.628092508 |
+-------------------+--------------------+

-- Example 6317
ST_DWITHIN( <geography_expression_1> , <geography_expression_2> , <distance_in_meters> )

-- Example 6318
SELECT ST_DWITHIN (ST_MAKEPOINT(0, 0), ST_MAKEPOINT(1, 0), 150000);
+-------------------------------------------------------------+
| ST_DWITHIN (ST_MAKEPOINT(0, 0), ST_MAKEPOINT(1, 0), 150000) |
|-------------------------------------------------------------|
| True                                                        |
+-------------------------------------------------------------+

-- Example 6319
ST_ENDPOINT( <geography_or_geometry_expression> )

-- Example 6320
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';
SELECT ST_ENDPOINT(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'));

+-------------------------------------------------------------+
| ST_ENDPOINT(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)')) |
|-------------------------------------------------------------|
| POINT(4 4)                                                  |
+-------------------------------------------------------------+

-- Example 6321
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';
SELECT ST_ENDPOINT(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'));

+------------------------------------------------------------+
| ST_ENDPOINT(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)')) |
|------------------------------------------------------------|
| POINT(4 4)                                                 |
+------------------------------------------------------------+

-- Example 6322
ST_ENVELOPE( <geography_or_geometry_expression> )

-- Example 6323
SELECT ST_ENVELOPE(
    TO_GEOGRAPHY(
        'POLYGON((-122.306067 37.55412, -122.32328 37.561801, -122.325879 37.586852, -122.306067 37.55412))'
    )
) as minimum_bounding_box_around_polygon;
+-----------------------------------------------------------------------------------------------------------------------+
| MINIMUM_BOUNDING_BOX_AROUND_POLYGON                                                                                   |
|-----------------------------------------------------------------------------------------------------------------------|
| POLYGON((-122.325879 37.55412,-122.306067 37.55412,-122.306067 37.586852,-122.325879 37.586852,-122.325879 37.55412)) |
+-----------------------------------------------------------------------------------------------------------------------+

-- Example 6324
SELECT ST_ENVELOPE(
    TO_GEOGRAPHY(
        'LINESTRING(-122.32328 37.561801, -122.32328 37.562001)'
    )
) as minimum_bounding_box_around_meridian_arc;
+-------------------------------------------------------+
| MINIMUM_BOUNDING_BOX_AROUND_MERIDIAN_ARC              |
|-------------------------------------------------------|
| LINESTRING(-122.32328 37.561801,-122.32328 37.562001) |
+-------------------------------------------------------+

-- Example 6325
SELECT ST_ENVELOPE(
    TO_GEOGRAPHY(
        'LINESTRING(-122.32328 37.561801,-122.32351 37.561801)'
    )
) as minimum_bounding_box_around_arc_along_parallel;
+---------------------------------------------------------------------------------------------------------------------+
| MINIMUM_BOUNDING_BOX_AROUND_ARC_ALONG_PARALLEL                                                                      |
|---------------------------------------------------------------------------------------------------------------------|
| POLYGON((-122.32351 37.561801,-122.32328 37.561801,-122.32328 37.561801,-122.32351 37.561801,-122.32351 37.561801)) |
+---------------------------------------------------------------------------------------------------------------------+

-- Example 6326
SELECT ST_ENVELOPE(
    TO_GEOGRAPHY(
        'POINT(-122.32328 37.561801)'
    )
) as minimum_bounding_box_around_point;
+-----------------------------------+
| MINIMUM_BOUNDING_BOX_AROUND_POINT |
|-----------------------------------|
| POINT(-122.32328 37.561801)       |
+-----------------------------------+

-- Example 6327
ST_GEOGFROMGEOHASH( <geohash> [, <precision> ] )

-- Example 6328
SELECT ST_GEOGFROMGEOHASH('9q9j8ue2v71y5zzy0s4q')
    AS geography_from_geohash,
    ST_AREA(ST_GEOGFROMGEOHASH('9q9j8ue2v71y5zzy0s4q'))
    AS area_of_geohash;
+---------------------------------+-----------------+
| GEOGRAPHY_FROM_GEOHASH          | AREA_OF_GEOHASH |
|---------------------------------+-----------------|
| {                               |  5.48668572e-16 |
|   "coordinates": [              |                 |
|     [                           |                 |
|       [                         |                 |
|         -1.223061000000001e+02, |                 |
|         3.755416199999996e+01   |                 |
|       ],                        |                 |
|       [                         |                 |
|         -1.223061000000001e+02, |                 |
|         3.755416200000012e+01   |                 |
|       ],                        |                 |
|       [                         |                 |
|         -1.223060999999998e+02, |                 |
|         3.755416200000012e+01   |                 |
|       ],                        |                 |
|       [                         |                 |
|         -1.223060999999998e+02, |                 |
|         3.755416199999996e+01   |                 |
|       ],                        |                 |
|       [                         |                 |
|         -1.223061000000001e+02, |                 |
|         3.755416199999996e+01   |                 |
|       ]                         |                 |
|     ]                           |                 |
|   ],                            |                 |
|   "type": "Polygon"             |                 |
| }                               |                 |
+---------------------------------+-----------------+

-- Example 6329
SELECT ST_GEOGFROMGEOHASH('9q9j8ue2v71y5zzy0s4q', 6)
    AS geography_from_less_precise_geohash,
    ST_AREA(ST_GEOGFROMGEOHASH('9q9j8ue2v71y5zzy0s4q', 6))
    AS area_of_geohash;
+-------------------------------------+-----------------+
| GEOGRAPHY_FROM_LESS_PRECISE_GEOHASH | AREA_OF_GEOHASH |
|-------------------------------------+-----------------|
| {                                   | 591559.75661851 |
|   "coordinates": [                  |                 |
|     [                               |                 |
|       [                             |                 |
|         -1.223107910156250e+02,     |                 |
|         3.755126953125000e+01       |                 |
|       ],                            |                 |
|       [                             |                 |
|         -1.223107910156250e+02,     |                 |
|         3.755676269531250e+01       |                 |
|       ],                            |                 |
|       [                             |                 |
|         -1.222998046875000e+02,     |                 |
|         3.755676269531250e+01       |                 |
|       ],                            |                 |
|       [                             |                 |
|         -1.222998046875000e+02,     |                 |
|         3.755126953125000e+01       |                 |
|       ],                            |                 |
|       [                             |                 |
|         -1.223107910156250e+02,     |                 |
|         3.755126953125000e+01       |                 |
|       ]                             |                 |
|     ]                               |                 |
|   ],                                |                 |
|   "type": "Polygon"                 |                 |
| }                                   |                 |
+-------------------------------------+-----------------+

-- Example 6330
ST_GEOHASH( <geography_expression> [, <precision> ] )

ST_GEOHASH( <geometry_expression> [, <precision> ] )

-- Example 6331
SELECT ST_GEOHASH(
  TO_GEOGRAPHY('POINT(-122.306100 37.554162)'))
  AS geohash_of_point_a;

-- Example 6332
+----------------------+
| GEOHASH_OF_POINT_A   |
|----------------------|
| 9q9j8ue2v71y5zzy0s4q |
+----------------------+

-- Example 6333
SELECT ST_GEOHASH(
  TO_GEOGRAPHY('POINT(-122.306100 37.554162)'),
  5) AS less_precise_geohash_a;

-- Example 6334
+------------------------+
| LESS_PRECISE_GEOHASH_A |
|------------------------|
| 9q9j8                  |
+------------------------+

-- Example 6335
SELECT ST_GEOHASH(
  TO_GEOMETRY('POINT(-122.306100 37.554162)', 4326))
  AS geohash_of_point_a;

-- Example 6336
+----------------------+
| GEOHASH_OF_POINT_A   |
|----------------------|
| 9q9j8ue2v71y5zzy0s4q |
+----------------------+

-- Example 6337
SELECT
  ST_GEOHASH(
    TO_GEOGRAPHY('POINT(-122.306100 37.554162)'))
    AS geohash_of_point_a,
  ST_GEOHASH(
    TO_GEOGRAPHY('POINT(-122.323111 37.562333)'))
    AS geohash_of_point_b;

-- Example 6338
+----------------------+----------------------+
| GEOHASH_OF_POINT_A   | GEOHASH_OF_POINT_B   |
|----------------------+----------------------|
| 9q9j8ue2v71y5zzy0s4q | 9q9j8qp02yms1tpjesmc |
+----------------------+----------------------+

-- Example 6339
SELECT
  ST_GEOHASH(
    TO_GEOGRAPHY('POINT(-122.306100 37.554162)'),
    5) AS less_precise_geohash_a,
  ST_GEOHASH(
    TO_GEOGRAPHY('POINT(-122.323111 37.562333)'),
    5) AS less_precise_geohash_b;

-- Example 6340
+------------------------+------------------------+
| LESS_PRECISE_GEOHASH_A | LESS_PRECISE_GEOHASH_B |
|------------------------+------------------------|
| 9q9j8                  | 9q9j8                  |
+------------------------+------------------------+

-- Example 6341
SELECT
  ST_GEOHASH(
    TO_GEOGRAPHY(
      'POLYGON((-122.306100 37.554162, -122.306100 37.562333, -122.323111 37.562333, -122.323111 37.554162, -122.306100 37.554162))'
    )
  ) AS geohash_of_polygon;

-- Example 6342
+--------------------+
| GEOHASH_OF_POLYGON |
|--------------------|
| 9q9j8              |
+--------------------+

-- Example 6343
ST_GEOGPOINTFROMGEOHASH( <geohash> )

-- Example 6344
SELECT ST_GEOGPOINTFROMGEOHASH('9q9j8ue2v71y5zzy0s4q')
    AS geography_center_point_of_geohash;
+-----------------------------------+
| GEOGRAPHY_CENTER_POINT_OF_GEOHASH |
|-----------------------------------|
| {                                 |
|   "coordinates": [                |
|     -1.223060999999999e+02,       |
|     3.755416200000003e+01         |
|   ],                              |
|   "type": "Point"                 |
| }                                 |
+-----------------------------------+

-- Example 6345
ST_GEOGRAPHYFROMWKB( <varchar_or_binary_expression> [ , <allow_invalid> ] )

ST_GEOGFROMWKB( <varchar_or_binary_expression> [ , <allow_invalid> ] )

ST_GEOGRAPHYFROMEWKB( <varchar_or_binary_expression> [ , <allow_invalid> ] )

ST_GEOGFROMEWKB( <varchar_or_binary_expression> [ , <allow_invalid> ] )

