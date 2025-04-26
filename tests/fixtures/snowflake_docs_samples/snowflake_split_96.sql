-- Example 6413
SELECT ST_MAKELINE(
  TO_GEOMETRY('LINESTRING(1.0 2.0, 10.1 5.5)'),
  TO_GEOMETRY('MULTIPOINT(3.5 4.5, 6.1 7.9)')) AS line_from_linestring_and_multipoint;

-- Example 6414
+------------------------------------------+
| LINE_FROM_LINESTRING_AND_MULTIPOINT      |
|------------------------------------------|
| LINESTRING(1 2,10.1 5.5,3.5 4.5,6.1 7.9) |
+------------------------------------------+

-- Example 6415
ST_MAKEPOINT( <longitude> , <latitude> )

-- Example 6416
SELECT ST_MAKEPOINT(37.5, 45.5);
+--------------------------+
| ST_MAKEPOINT(37.5, 45.5) |
|--------------------------|
| POINT(37.5 45.5)         |
+--------------------------+

-- Example 6417
ST_MAKEPOLYGON( <geography_or_geometry_expression> )

-- Example 6418
SELECT ST_MAKEPOLYGON(
   TO_GEOGRAPHY('LINESTRING(0.0 0.0, 1.0 0.0, 1.0 2.0, 0.0 2.0, 0.0 0.0)')
   ) AS polygon1;
+--------------------------------+
| POLYGON1                       |
|--------------------------------|
| POLYGON((0 0,1 0,1 2,0 2,0 0)) |
+--------------------------------+

-- Example 6419
SELECT ST_MAKEPOLYGON(
  TO_GEOMETRY('LINESTRING(0.0 0.0, 1.0 0.0, 1.0 2.0, 0.0 2.0, 0.0 0.0)')
  ) AS polygon;

-- Example 6420
+--------------------------------+
| POLYGON                        |
|--------------------------------|
| POLYGON((0 0,1 0,1 2,0 2,0 0)) |
+--------------------------------+

-- Example 6421
ST_MAKEPOLYGONORIENTED( <geography_expression> )

-- Example 6422
SELECT ST_AREA(
  ST_MAKEPOLYGONORIENTED(
    TO_GEOGRAPHY('LINESTRING(0.0 0.0, 1.0 0.0, 1.0 2.0, 0.0 2.0, 0.0 0.0)')
  )
) AS area_of_polygon;

+------------------+
|  AREA_OF_POLYGON |
|------------------|
| 24724306355.5504 |
+------------------+

-- Example 6423
SELECT ST_AREA(
  ST_MAKEPOLYGONORIENTED(
    TO_GEOGRAPHY('LINESTRING(0.0 0.0, 0.0 2.0, 1.0 2.0, 1.0 0.0, 0.0 0.0)')
  )
) AS area_of_polygon;

+-----------------+
| AREA_OF_POLYGON |
|-----------------|
| 510041348811633 |
+-----------------+

-- Example 6424
ST_NPOINTS( <geography_or_geometry_expression> )

-- Example 6425
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 6426
SELECT ST_NPOINTS(g1) 
    FROM geospatial_table_01;
+----------------+
| ST_NPOINTS(G1) |
|----------------|
|              5 |
+----------------+

-- Example 6427
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

SELECT ST_NPOINTS(g), ST_ASWKT(g) FROM geometry_shapes;

-- Example 6428
+---------------+-------------------------------------------------------------------------------------------------+
| ST_NPOINTS(G) | ST_ASWKT(G)                                                                                     |
|---------------+-------------------------------------------------------------------------------------------------|
|             1 | POINT(66 12)                                                                                    |
|             2 | MULTIPOINT((45 21),(12 54))                                                                     |
|             3 | LINESTRING(40 60,50 50,60 40)                                                                   |
|             5 | MULTILINESTRING((1 1,32 17),(33 12,73 49,87.1 6.1))                                             |
|             5 | POLYGON((17 17,17 30,30 30,30 17,17 17))                                                        |
|             8 | MULTIPOLYGON(((-10 0,0 10,10 0,-10 0)),((-10 40,10 40,0 20,-10 40)))                            |
|             8 | GEOMETRYCOLLECTION(POLYGON((-10 0,0 10,10 0,-10 0)),LINESTRING(40 60,50 50,60 40),POINT(99 11)) |
+---------------+-------------------------------------------------------------------------------------------------+

-- Example 6429
ST_PERIMETER( <geography_or_geometry_expression> )

-- Example 6430
SELECT ST_PERIMETER(TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'));
+------------------------------------------------------------------+
| ST_PERIMETER(TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))')) |
|------------------------------------------------------------------|
|                                                 444763.468727621 |
+------------------------------------------------------------------+

-- Example 6431
SELECT ST_PERIMETER(g), ST_ASWKT(g)
FROM (SELECT TO_GEOMETRY(column1) AS g
  FROM VALUES ('POINT(1 1)'),
              ('LINESTRING(0 0, 1 1)'),
              ('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))'));

-- Example 6432
+-----------------+--------------------------------+
| ST_PERIMETER(G) | ST_ASWKT(G)                    |
|-----------------+--------------------------------|
|               0 | POINT(1 1)                     |
|               0 | LINESTRING(0 0,1 1)            |
|               4 | POLYGON((0 0,0 1,1 1,1 0,0 0)) |
+-----------------+--------------------------------+

-- Example 6433
ST_POINTN( <geography_or_geometry_expression> , <index> )

-- Example 6434
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';
SELECT ST_POINTN(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), 2);

+--------------------------------------------------------------+
| ST_POINTN(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), 2) |
|--------------------------------------------------------------|
| POINT(2 2)                                                   |
+--------------------------------------------------------------+

-- Example 6435
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';
SELECT ST_POINTN(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), -2);

+---------------------------------------------------------------+
| ST_POINTN(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), -2) |
|---------------------------------------------------------------|
| POINT(3 3)                                                    |
+---------------------------------------------------------------+

-- Example 6436
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';
SELECT ST_POINTN(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), 2);

+-------------------------------------------------------------+
| ST_POINTN(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), 2) |
|-------------------------------------------------------------|
| POINT(2 2)                                                  |
+-------------------------------------------------------------+

-- Example 6437
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';
SELECT ST_POINTN(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), -2);

+--------------------------------------------------------------+
| ST_POINTN(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'), -2) |
|--------------------------------------------------------------|
| POINT(3 3)                                                   |
+--------------------------------------------------------------+

-- Example 6438
ST_SETSRID( <geometry_expression> , <srid> )

-- Example 6439
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT ST_SETSRID(TO_GEOMETRY('POINT(13 51)'), 4326);

+-----------------------------------------------+
| ST_SETSRID(TO_GEOMETRY('POINT(13 51)'), 4326) |
|-----------------------------------------------|
| SRID=4326;POINT(13 51)                        |
+-----------------------------------------------+

-- Example 6440
ST_SIMPLIFY( <geography_expression>, <tolerance> [ , <preserve_collapsed> ] )
ST_SIMPLIFY( <geometry_expression>, <tolerance> )

-- Example 6441
alter session set GEOGRAPHY_OUTPUT_FORMAT='WKT';

-- Example 6442
SELECT ST_SIMPLIFY(
    TO_GEOGRAPHY('LINESTRING(-122.306067 37.55412, -122.32328 37.561801, -122.325879 37.586852)'),
    1000);
+----------------------------------------------------------------------------------------------------+
| ST_SIMPLIFY(                                                                                       |
|     TO_GEOGRAPHY('LINESTRING(-122.306067 37.55412, -122.32328 37.561801, -122.325879 37.586852)'), |
|     1000)                                                                                          |
|----------------------------------------------------------------------------------------------------|
| LINESTRING(-122.306067 37.55412,-122.325879 37.586852)                                             |
+----------------------------------------------------------------------------------------------------+

-- Example 6443
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';

-- Example 6444
SELECT ST_SIMPIFY(
  TO_GEOMETRY('LINESTRING(1100 1100, 2500 2100, 3100 3100, 4900 1100, 3100 1900)'),
  500);

+----------------------------------------------------------------------------------------------------+
| ST_SIMPLIFY(TO_GEOMETRY('LINESTRING(1100 1100, 2500 2100, 3100 3100, 4900 1100, 3100 1900)'), 500) |
|----------------------------------------------------------------------------------------------------|
| LINESTRING(1100 1100,3100 3100,4900 1100,3100 1900)                                                |
+----------------------------------------------------------------------------------------------------+

-- Example 6445
SELECT ST_NUMPOINTS(geom) AS numpoints_before,
  ST_NUMPOINTS(ST_Simplify(geom, 0.5)) AS numpoints_simplified_05,
  ST_NUMPOINTS(ST_Simplify(geom, 1)) AS numpoints_simplified_1
  FROM
  (SELECT ST_BUFFER(to_geometry('LINESTRING(0 0, 1 1)'), 10) As geom);

+------------------+-------------------------+------------------------+
| NUMPOINTS_BEFORE | NUMPOINTS_SIMPLIFIED_05 | NUMPOINTS_SIMPLIFIED_1 |
|------------------+-------------------------+------------------------|
|               36 |                      16 |                     10 |
+------------------+-------------------------+------------------------+

-- Example 6446
ST_SRID( <geography_or_geometry_expression> )

-- Example 6447
SELECT ST_SRID(ST_MAKEPOINT(37.5, 45.5));
+-----------------------------------+
| ST_SRID(ST_MAKEPOINT(37.5, 45.5)) |
|-----------------------------------|
|                              4326 |
+-----------------------------------+

-- Example 6448
SELECT ST_SRID(ST_MAKEPOINT(NULL, NULL)), ST_SRID(NULL);
+-----------------------------------+---------------+
| ST_SRID(ST_MAKEPOINT(NULL, NULL)) | ST_SRID(NULL) |
|-----------------------------------+---------------|
|                              NULL |          NULL |
+-----------------------------------+---------------+

-- Example 6449
ST_STARTPOINT( <geography_or_geometry_expression> )

-- Example 6450
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT='WKT';
SELECT ST_STARTPOINT(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)'));

+---------------------------------------------------------------+
| ST_STARTPOINT(TO_GEOGRAPHY('LINESTRING(1 1, 2 2, 3 3, 4 4)')) |
|---------------------------------------------------------------|
| POINT(1 1)                                                    |
+---------------------------------------------------------------+

-- Example 6451
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';
SELECT ST_STARTPOINT(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)'));

+--------------------------------------------------------------+
| ST_STARTPOINT(TO_GEOMETRY('LINESTRING(1 1, 2 2, 3 3, 4 4)')) |
|--------------------------------------------------------------|
| POINT(1 1)                                                   |
+--------------------------------------------------------------+

-- Example 6452
ST_SYMDIFFERENCE( <geography_expression_1> , <geography_expression_2> )

-- Example 6453
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT = 'WKT';

SELECT ST_SYMDIFFERENCE(
  TO_GEOGRAPHY('POLYGON((0 0, 1 0, 2 1, 1 2, 2 3, 1 4, 0 4, 0 0))'),
  TO_GEOGRAPHY('POLYGON((3 0, 3 4, 2 4, 1 3, 2 2, 1 1, 2 0, 3 0))')
) AS symmetric_difference_between_objects;

-- Example 6454
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| SYMMETRIC_DIFFERENCE_BETWEEN_OBJECTS                                                                                                                                                                                    |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MULTIPOLYGON(((1 1,1.5 1.500171359,1 2,1.5 2.500285599,1 3,1.5 3.500399839,1 4,0 4,0 0,1 0,1.5 0.5000571198,1 1)),((3 0,3 4,2 4,1.5 3.500399839,2 3,1.5 2.500285599,2 2,1.5 1.500171359,2 1,1.5 0.5000571198,2 0,3 0))) |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6455
ST_TRANSFORM( <geometry_expression> [ , <from_srid> ] , <to_srid> );

-- Example 6456
-- Set the output format to EWKT
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT
  ST_TRANSFORM(
    ST_GEOMFROMWKT('POINT(389866.35 5819003.03)', 32633),
    3857
  ) AS transformed_geom;

-- Example 6457
+---------------------------------------------------------------+
| transformed_geom                                              |
|---------------------------------------------------------------|
| SRID=3857;POINT(1489140.093765644 6892872.198680112)          |
+---------------------------------------------------------------+

-- Example 6458
-- Set the output format to EWKT
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';

SELECT
  ST_TRANSFORM(
    ST_GEOMFROMWKT('POINT(4.500212 52.161170)'),
    4326,
    28992
  ) AS transformed_geom;

-- Example 6459
+---------------------------------------------------------------+
| transformed_geom                                              |
|---------------------------------------------------------------|
| SRID=28992;POINT (94308.66600006013 464038.16881095537)       |
+---------------------------------------------------------------+

-- Example 6460
ST_UNION( <geography_expression_1> , <geography_expression_2> )

-- Example 6461
SELECT ST_UNION(
  TO_GEOGRAPHY('POINT(1 1)'),
  TO_GEOGRAPHY('LINESTRING(1 0, 1 2)')
);

-- Example 6462
LINESTRING(1 0, 1 2)

-- Example 6463
GEOMETRYCOLLECTION(POINT(1 1),LINESTRING(1 0,1 1,1 2))

-- Example 6464
ALTER SESSION SET GEOGRAPHY_OUTPUT_FORMAT = 'WKT';

SELECT ST_UNION(
  TO_GEOGRAPHY('POLYGON((0 0, 1 0, 2 1, 1 2, 2 3, 1 4, 0 4, 0 0))'),
  TO_GEOGRAPHY('POLYGON((3 0, 3 4, 2 4, 1 3, 2 2, 1 1, 2 0, 3 0))')
) AS union_of_objects;

-- Example 6465
+-------------------------------------------------------------------------------------------------------------------------------------------+
| UNION_OF_OBJECTS                                                                                                                          |
|-------------------------------------------------------------------------------------------------------------------------------------------|
| POLYGON((3 0,3 4,2 4,1.5 3.500399839,1 4,0 4,0 0,1 0,1.5 0.5000571198,2 0,3 0),(1.5 1.500171359,1 2,1.5 2.500285599,2 2,1.5 1.500171359)) |
+-------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6466
ST_UNION_AGG( <geography_column> )

-- Example 6467
SELECT state_name,
  ST_UNION_AGG(county) as union_of_counties
  FROM counties_by_state
  GROUP BY state_name;

-- Example 6468
ST_WITHIN( <geography_expression_1> , <geography_expression_2> )

ST_WITHIN( <geometry_expression_1> , <geometry_expression_2> )

-- Example 6469
create table geospatial_table_01 (g1 GEOGRAPHY, g2 GEOGRAPHY);
insert into geospatial_table_01 (g1, g2) values 
    ('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0))', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))');

-- Example 6470
SELECT ST_WITHIN(g1, g2) 
    FROM geospatial_table_01;
+-------------------+
| ST_WITHIN(G1, G2) |
|-------------------|
| False             |
+-------------------+

-- Example 6471
ST_X( <geography_or_geometry_expression> )

-- Example 6472
SELECT ST_X(ST_MAKEPOINT(37.5, 45.5)), ST_Y(ST_MAKEPOINT(37.5, 45.5));
+--------------------------------+--------------------------------+
| ST_X(ST_MAKEPOINT(37.5, 45.5)) | ST_Y(ST_MAKEPOINT(37.5, 45.5)) |
|--------------------------------+--------------------------------|
|                           37.5 |                           45.5 |
+--------------------------------+--------------------------------+

-- Example 6473
SELECT
    ST_X(ST_MAKEPOINT(NULL, NULL)), ST_X(NULL),
    ST_Y(ST_MAKEPOINT(NULL, NULL)), ST_Y(NULL)
    ;
+--------------------------------+------------+--------------------------------+------------+
| ST_X(ST_MAKEPOINT(NULL, NULL)) | ST_X(NULL) | ST_Y(ST_MAKEPOINT(NULL, NULL)) | ST_Y(NULL) |
|--------------------------------+------------+--------------------------------+------------|
|                           NULL |       NULL |                           NULL |       NULL |
+--------------------------------+------------+--------------------------------+------------+

-- Example 6474
ST_XMAX( <geography_or_geometry_expression> )

-- Example 6475
CREATE or replace TABLE extreme_point_collection (id INTEGER, g GEOGRAPHY);
INSERT INTO extreme_point_collection (id, g)
    SELECT column1, TO_GEOGRAPHY(column2) FROM VALUES
        (1, 'POINT(-180 0)'),
        (2, 'POINT(180 0)'),
        (3, 'LINESTRING(-179 0, 179 0)'),
        (4, 'LINESTRING(-60 30, 60 30)'),
        (5, 'LINESTRING(-60 -30, 60 -30)');

-- Example 6476
SELECT
    g,
    ST_XMIN(g),
    ST_XMAX(g),
    ST_YMIN(g),
    ST_YMAX(g)
  FROM extreme_point_collection
  ORDER BY id;
+----------------------------+------------+------------+-------------------+-------------------+
| G                          | ST_XMIN(G) | ST_XMAX(G) |        ST_YMIN(G) |        ST_YMAX(G) |
|----------------------------+------------+------------+-------------------+-------------------|
| POINT(-180 0)              |       -180 |        180 |   0               |   0               |
| POINT(180 0)               |       -180 |        180 |   0               |   0               |
| LINESTRING(-179 0,179 0)   |       -180 |        180 |  -6.883275617e-14 |   6.883275617e-14 |
| LINESTRING(-60 30,60 30)   |        -60 |         60 |  30               |  49.106605351     |
| LINESTRING(-60 -30,60 -30) |        -60 |         60 | -49.106605351     | -30               |
+----------------------------+------------+------------+-------------------+-------------------+

-- Example 6477
ST_XMIN( <geography_or_geometry_expression> )

-- Example 6478
CREATE or replace TABLE extreme_point_collection (id INTEGER, g GEOGRAPHY);
INSERT INTO extreme_point_collection (id, g)
    SELECT column1, TO_GEOGRAPHY(column2) FROM VALUES
        (1, 'POINT(-180 0)'),
        (2, 'POINT(180 0)'),
        (3, 'LINESTRING(-179 0, 179 0)'),
        (4, 'LINESTRING(-60 30, 60 30)'),
        (5, 'LINESTRING(-60 -30, 60 -30)');

-- Example 6479
SELECT
    g,
    ST_XMIN(g),
    ST_XMAX(g),
    ST_YMIN(g),
    ST_YMAX(g)
  FROM extreme_point_collection
  ORDER BY id;
+----------------------------+------------+------------+-------------------+-------------------+
| G                          | ST_XMIN(G) | ST_XMAX(G) |        ST_YMIN(G) |        ST_YMAX(G) |
|----------------------------+------------+------------+-------------------+-------------------|
| POINT(-180 0)              |       -180 |        180 |   0               |   0               |
| POINT(180 0)               |       -180 |        180 |   0               |   0               |
| LINESTRING(-179 0,179 0)   |       -180 |        180 |  -6.883275617e-14 |   6.883275617e-14 |
| LINESTRING(-60 30,60 30)   |        -60 |         60 |  30               |  49.106605351     |
| LINESTRING(-60 -30,60 -30) |        -60 |         60 | -49.106605351     | -30               |
+----------------------------+------------+------------+-------------------+-------------------+

