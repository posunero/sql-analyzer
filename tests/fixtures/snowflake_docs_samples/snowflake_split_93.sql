-- Example 6212
SELECT column1 part_number_value, column2 portion
  FROM VALUES
    (1, split_part('user@snowflake.com', '',  1)),
    (-1, split_part('user@snowflake.com', '', -1)),
    (2, split_part('user@snowflake.com', '',  2)),
    (-2, split_part('user@snowflake.com', '', -2));

-- Example 6213
+-------------------+--------------------+
| PART_NUMBER_VALUE | PORTION            |
|-------------------+--------------------|
|                 1 | user@snowflake.com |
|                -1 | user@snowflake.com |
|                 2 |                    |
|                -2 |                    |
+-------------------+--------------------+

-- Example 6214
SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER (
  '<text_to_split>',
  '<format>',
  <chunk_size>,
  [ <overlap> ],
  [ <separators> ]
)

-- Example 6215
SELECT SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER (
   'hello world are you here',
   'none',
   15,
   10
);

-- Example 6216
['hello world are', 'world are you', 'are you here']

-- Example 6217
-- Create sample markdown data table
CREATE OR REPLACE TABLE sample_documents (
   doc_id INT AUTOINCREMENT, -- Monotonically increasing integer
   document STRING
);

-- Insert sample data
INSERT INTO sample_documents (document)
VALUES
   ('### Heading 1\\nThis is a sample markdown document. It contains a list:\\n- Item 1\\n- Item 2\\n- Item 3\\n'),
   ('## Subheading\\nThis markdown contains a link [example](http://example.com) and some \**bold*\* text.'),
   ('### Heading 2\\nHere is a code snippet:\\n```\\ncode_block_here()\\n```\\nAnd some more regular text.'),
   ('## Another Subheading\\nMarkdown example with \_italic\_ text and a [second link](http://example.com).'),
   ('### Heading 3\\nText with an ordered list:\\n1. First item\\n2. Second item\\n3. Third item\\nMore text follows here.');

-- split text
SELECT
   doc_id,
   c.value
FROM
   sample_documents,
   LATERAL FLATTEN( input => SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER (
      document,
      'markdown',
      25,
      10
   )) c;

-- Example 6218
SPLIT_TO_TABLE(<string>, <delimiter>)

-- Example 6219
SELECT table1.value
  FROM TABLE(SPLIT_TO_TABLE('a.b', '.')) AS table1
  ORDER BY table1.value;

-- Example 6220
+-------+
| VALUE |
|-------|
| a     |
| b     |
+-------+

-- Example 6221
CREATE OR REPLACE TABLE splittable (v VARCHAR);
INSERT INTO splittable (v) VALUES ('a.b.c'), ('d'), ('');
SELECT * FROM splittable;

-- Example 6222
+-------+
| V     |
|-------|
| a.b.c |
| d     |
|       |
+-------+

-- Example 6223
SELECT *
  FROM splittable, LATERAL SPLIT_TO_TABLE(splittable.v, '.')
  ORDER BY SEQ, INDEX;

-- Example 6224
+-------+-----+-------+-------+
| V     | SEQ | INDEX | VALUE |
|-------+-----+-------+-------|
| a.b.c |   1 |     1 | a     |
| a.b.c |   1 |     2 | b     |
| a.b.c |   1 |     3 | c     |
| d     |   2 |     1 | d     |
|       |   3 |     1 |       |
+-------+-----+-------+-------+

-- Example 6225
CREATE OR REPLACE TABLE authors_books_test (author VARCHAR, titles VARCHAR);
INSERT INTO authors_books_test (author, titles) VALUES
  ('Nathaniel Hawthorne', 'The Scarlet Letter , The House of the Seven Gables,The Blithedale Romance'),
  ('Herman Melville', 'Moby Dick,The Confidence-Man');
SELECT * FROM authors_books_test;

-- Example 6226
+---------------------+---------------------------------------------------------------------------+
| AUTHOR              | TITLES                                                                    |
|---------------------+---------------------------------------------------------------------------|
| Nathaniel Hawthorne | The Scarlet Letter , The House of the Seven Gables,The Blithedale Romance |
| Herman Melville     | Moby Dick,The Confidence-Man                                              |
+---------------------+---------------------------------------------------------------------------+

-- Example 6227
SELECT author, TRIM(value) AS title
  FROM authors_books_test, LATERAL SPLIT_TO_TABLE(titles, ',')
  ORDER BY author;

-- Example 6228
+---------------------+-------------------------------+
| AUTHOR              | TITLE                         |
|---------------------+-------------------------------|
| Herman Melville     | Moby Dick                     |
| Herman Melville     | The Confidence-Man            |
| Nathaniel Hawthorne | The Scarlet Letter            |
| Nathaniel Hawthorne | The House of the Seven Gables |
| Nathaniel Hawthorne | The Blithedale Romance        |
+---------------------+-------------------------------+

-- Example 6229
SQRT(expr)

-- Example 6230
SELECT x, sqrt(x) FROM tab;

--------+-------------+
   x    |   sqrt(x)   |
--------+-------------+
 0      | 0           |
 2      | 1.414213562 |
 10     | 3.16227766  |
 [NULL] | [NULL]      |
--------+-------------+

-- Example 6231
SQUARE(expr)

-- Example 6232
SELECT column1, square(column1)
FROM (values (0), (1), (-2), (3.15), (null)) v;

---------+-----------------+
 column1 | square(column1) |
---------+-----------------+
 0       | 0               |
 1       | 1               |
 -2      | 4               |
 3.15    | 9.9225          |
 [NULL]  | [NULL]          |
---------+-----------------+

-- Example 6233
ST_AREA( <geography_or_geometry_expression> )

-- Example 6234
SELECT ST_AREA(TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))')) AS area;
+------------------+
|             AREA |
|------------------|
| 12364036567.0764 |
+------------------+

-- Example 6235
SELECT ST_AREA(g), ST_ASWKT(g)
FROM (SELECT TO_GEOMETRY(column1) as g
  from values ('POINT(1 1)'),
              ('LINESTRING(0 0, 1 1)'),
              ('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))'));

-- Example 6236
+------------+--------------------------------+
| ST_AREA(G) | ST_ASWKT(G)                    |
|------------+--------------------------------|
|          0 | POINT(1 1)                     |
|          0 | LINESTRING(0 0,1 1)            |
|          1 | POLYGON((0 0,0 1,1 1,1 0,0 0)) |
+------------+--------------------------------+

-- Example 6237
ST_ASEWKB( <geography_or_geometry_expression> )

-- Example 6238
create table geospatial_table (id INTEGER, g GEOGRAPHY);
insert into geospatial_table values
    (1, 'POINT(-122.35 37.55)'), (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 6239
select st_asewkb(g)
    from geospatial_table
    order by id;
+--------------------------------------------------------------------------------------------+
| ST_ASEWKB(G)                                                                               |
|--------------------------------------------------------------------------------------------|
| 0101000020E61000006666666666965EC06666666666C64240                                         |
| 0102000020E610000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+--------------------------------------------------------------------------------------------+

-- Example 6240
CREATE OR REPLACE TABLE geometry_table (g GEOMETRY);
INSERT INTO geometry_table VALUES
  ('SRID=4326;POINT(-122.35 37.55)'),
  ('SRID=0;LINESTRING(0.75 0.75, -10 20)');

SELECT ST_ASEWKB(g) FROM geometry_table;

-- Example 6241
+--------------------------------------------------------------------------------------------+
| ST_ASEWKB(G)                                                                               |
|--------------------------------------------------------------------------------------------|
| 0101000020E61000006666666666965EC06666666666C64240                                         |
| 01020000200000000002000000000000000000E83F000000000000E83F00000000000024C00000000000003440 |
+--------------------------------------------------------------------------------------------+

-- Example 6242
ST_ASEWKT( <geography_or_geometry_expression> )

-- Example 6243
create table geospatial_table (id INTEGER, g GEOGRAPHY);
insert into geospatial_table values
    (1, 'POINT(-122.35 37.55)'), (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 6244
select st_asewkt(g)
    from geospatial_table
    order by id;
+-----------------------------------------------+
| ST_ASEWKT(G)                                  |
|-----------------------------------------------|
| SRID=4326;POINT(-122.35 37.55)                |
| SRID=4326;LINESTRING(-124.2 42,-120.01 41.99) |
+-----------------------------------------------+

-- Example 6245
CREATE OR REPLACE TABLE geometry_table (g GEOMETRY);
INSERT INTO geometry_table VALUES
  ('SRID=4326;POINT(-122.35 37.55)'),
  ('SRID=0;LINESTRING(0.75 0.75, -10 20)');

ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='EWKT';
SELECT ST_ASEWKT(g) FROM geometry_table;

-- Example 6246
+-------------------------------------+
| ST_ASEWKT(G)                        |
|-------------------------------------|
| SRID=4326;POINT(-122.35 37.55)      |
| SRID=0;LINESTRING(0.75 0.75,-10 20) |
+-------------------------------------+

-- Example 6247
ST_ASGEOJSON( <geography_or_geometry_expression> )

-- Example 6248
create table geospatial_table (id INTEGER, g GEOGRAPHY);
insert into geospatial_table values
    (1, 'POINT(-122.35 37.55)'), (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 6249
select st_asgeojson(g)
    from geospatial_table
    order by id;
+------------------------+
| ST_ASGEOJSON(G)        |
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

-- Example 6250
select st_asgeojson(g)::varchar
    from geospatial_table
    order by id;
+-------------------------------------------------------------------+
| ST_ASGEOJSON(G)::VARCHAR                                          |
|-------------------------------------------------------------------|
| {"coordinates":[-122.35,37.55],"type":"Point"}                    |
| {"coordinates":[[-124.2,42],[-120.01,41.99]],"type":"LineString"} |
+-------------------------------------------------------------------+

-- Example 6251
SELECT ST_ASGEOJSON(TO_GEOMETRY('SRID=4326;LINESTRING(389866 5819003, 390000 5830000)')) AS geojson;

-- Example 6252
+------------------------+
| GEOJSON                |
|------------------------|
|{                       |
|  "coordinates": [      |
|    [                   |
|      389866,           |
|      5819003           |
|    ],                  |
|    [                   |
|      390000,           |
|      5830000           |
|    ]                   |
|  ],                    |
|  "type": "LineString"  |
|}                       |
+------------------------+

-- Example 6253
ST_ASWKB( <geography_or_geometry_expression> )

ST_ASBINARY( <geography_or_geometry_expression> )

-- Example 6254
create table geospatial_table (id INTEGER, g GEOGRAPHY);
insert into geospatial_table values
    (1, 'POINT(-122.35 37.55)'), (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 6255
select st_aswkb(g)
    from geospatial_table
    order by id;
+------------------------------------------------------------------------------------+
| ST_ASWKB(G)                                                                        |
|------------------------------------------------------------------------------------|
| 01010000006666666666965EC06666666666C64240                                         |
| 010200000002000000CDCCCCCCCC0C5FC00000000000004540713D0AD7A3005EC01F85EB51B8FE4440 |
+------------------------------------------------------------------------------------+

-- Example 6256
CREATE OR REPLACE TABLE geometry_table (g GEOMETRY);
INSERT INTO geometry_table VALUES
  ('POINT(-122.35 37.55)'), ('LINESTRING(0.75 0.75, -10 20)');

SELECT ST_ASWKB(g) FROM geometry_table;

-- Example 6257
+------------------------------------------------------------------------------------+
| ST_ASWKB(G)                                                                        |
|------------------------------------------------------------------------------------|
| 01010000006666666666965EC06666666666C64240                                         |
| 010200000002000000000000000000E83F000000000000E83F00000000000024C00000000000003440 |
+------------------------------------------------------------------------------------+

-- Example 6258
ST_ASWKT( <geography_or_geometry_expression> )

ST_ASTEXT( <geography_or_geometry_expression> )

-- Example 6259
create table geospatial_table (id INTEGER, g GEOGRAPHY);
insert into geospatial_table values
    (1, 'POINT(-122.35 37.55)'), (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)');

-- Example 6260
select st_astext(g)
    from geospatial_table
    order by id;
+-------------------------------------+
| ST_ASTEXT(G)                        |
|-------------------------------------|
| POINT(-122.35 37.55)                |
| LINESTRING(-124.2 42,-120.01 41.99) |
+-------------------------------------+

-- Example 6261
select st_aswkt(g)
    from geospatial_table
    order by id;
+-------------------------------------+
| ST_ASWKT(G)                         |
|-------------------------------------|
| POINT(-122.35 37.55)                |
| LINESTRING(-124.2 42,-120.01 41.99) |
+-------------------------------------+

-- Example 6262
CREATE OR REPLACE TABLE geometry_table (g GEOMETRY);
INSERT INTO geometry_table VALUES
  ('POINT(-122.35 37.55)'), ('LINESTRING(0.75 0.75, -10 20)');

ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';
SELECT ST_ASWKT(g) FROM geometry_table;

-- Example 6263
+------------------------------+
| ST_ASWKT(G)                  |
|------------------------------|
| POINT(-122.35 37.55)         |
| LINESTRING(0.75 0.75,-10 20) |
+------------------------------+

-- Example 6264
ST_AZIMUTH( <geography_expression_for_origin> , <geography_expression_for_target> )
ST_AZIMUTH( <geometry_expression_for_origin> , <geometry_expression_for_target> )

-- Example 6265
SELECT ST_AZIMUTH(
    TO_GEOGRAPHY('POINT(0 1)'),
    TO_GEOGRAPHY('POINT(0 0)')
);
+---------------------------------+
|                     ST_AZIMUTH( |
|     TO_GEOGRAPHY('POINT(0 1)'), |
|      TO_GEOGRAPHY('POINT(0 0)') |
|                               ) |
|---------------------------------|
|                     3.141592654 |
+---------------------------------+

-- Example 6266
SELECT DEGREES(ST_AZIMUTH(
    TO_GEOGRAPHY('POINT(0 1)'),
    TO_GEOGRAPHY('POINT(1 2)')
));
+---------------------------------+
|             DEGREES(ST_AZIMUTH( |
|     TO_GEOGRAPHY('POINT(0 1)'), |
|      TO_GEOGRAPHY('POINT(1 2)') |
|                              )) |
|---------------------------------|
|                    44.978182941 |
+---------------------------------+

-- Example 6267
SELECT ST_AZIMUTH(
    TO_GEOMETRY('POINT(0 1)', TO_GEOMETRY('POINT(0 0)')
);

+------------------------------------------------------------------+
| ST_AZIMUTH(TO_GEOMETRY('POINT(0 1)'), TO_GEOMETRY('POINT(0 0)')) |
|------------------------------------------------------------------|
| 3.141592654                                                      |
+------------------------------------------------------------------+

-- Example 6268
SELECT ST_AZIMUTH(
    TO_GEOMETRY('POINT(0 0)', TO_GEOMETRY(0.707 0.707')
);

+-------------------------------------------------------------------------+
| ST_AZIMUTH(TO_GEOMETRY('POINT(0 0)'), TO_GEOMETRY('POINT(0.707 0.707')) |
|-------------------------------------------------------------------------|
| 0.7853981634                                                            |
+-------------------------------------------------------------------------+

-- Example 6269
ST_BUFFER( <geometry_expression> , <distance> )

-- Example 6270
ALTER SESSION SET GEOMETRY_OUTPUT_FORMAT='WKT';

-- Example 6271
SELECT ST_BUFFER(TO_GEOMETRY('POINT(0 0)'), 1) AS geom;

-- Example 6272
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GEOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MULTIPOLYGON(((1 0,0.9807852804 -0.195090322,0.9238795325 -0.3826834324,0.8314696123 -0.555570233,0.7071067812 -0.7071067812,0.555570233 -0.8314696123,0.3826834324 -0.9238795325,0.195090322 -0.9807852804,6.123233996e-17 -1,-0.195090322 -0.9807852804,-0.3826834324 -0.9238795325,-0.555570233 -0.8314696123,-0.7071067812 -0.7071067812,-0.8314696123 -0.555570233,-0.9238795325 -0.3826834324,-0.9807852804 -0.195090322,-1 7.657137398e-16,-0.9807852804 0.195090322,-0.9238795325 0.3826834324,-0.8314696123 0.555570233,-0.7071067812 0.7071067812,-0.555570233 0.8314696123,-0.3826834324 0.9238795325,-0.195090322 0.9807852804,2.480838239e-15 1,0.195090322 0.9807852804,0.3826834324 0.9238795325,0.555570233 0.8314696123,0.7071067812 0.7071067812,0.8314696123 0.555570233,0.9238795325 0.3826834324,0.9807852804 0.195090322,1 0))) |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6273
SELECT ST_BUFFER(TO_GEOMETRY('SRID=2261;POLYGON((
  1540792.21541900 290472.63529214, 1547018.61770388 302537.02285369,
  1546965.96550151 302752.51514772, 1547018.61770388 302537.02285369,
  1549532.42729914 301257.07398027, 1543327.42218339 289322.60923536,
  1540792.21541900 290472.63529214))', True), -1e-08) AS geom;

-- Example 6274
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GEOM                                                                                                                                                                                        |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MULTIPOLYGON(((1543327.42218339 289322.609235373,1540792.21541901 290472.635292145,1547018.61770388 302537.022853677,1549532.42729913 301257.073980266,1543327.42218339 289322.609235373))) |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 6275
ST_CENTROID( <geography_or_geometry_expression> )

-- Example 6276
SELECT ST_CENTROID(
    TO_GEOGRAPHY(
        'LINESTRING(0 0, 0 -2)'
    )
) as center_of_linestring;
+----------------------+
| CENTER_OF_LINESTRING |
|----------------------|
| POINT(0 -1)          |
+----------------------+

-- Example 6277
SELECT ST_CENTROID(
    TO_GEOGRAPHY(
        'POLYGON((10 10, 10 20, 20 20, 20 10, 10 10))'
    )
) as center_of_polygon;
+------------------------+
| CENTER_OF_POLYGON      |
|------------------------|
| POINT(15 15.014819855) |
+------------------------+

-- Example 6278
SELECT ST_CENTROID(
    TO_GEOGRAPHY(
        'GEOMETRYCOLLECTION(POLYGON((10 10, 10 20, 20 20, 20 10, 10 10)), LINESTRING(0 0, 0 -2), POINT(50 -50))'
    )
) as center_of_collection_with_polygons;
+------------------------------------+
| CENTER_OF_COLLECTION_WITH_POLYGONS |
|------------------------------------|
| POINT(15 15.014819855)             |
+------------------------------------+

