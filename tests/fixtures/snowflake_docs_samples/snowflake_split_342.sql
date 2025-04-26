-- Example 22892
...
  ST_INTERSECTS(
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1)

-- Example 22893
...
  ST_CONTAINS(
    TO_GEOGRAPHY('POLYGON((-74.17 40.64, -74.1796875 40.58, -74.09 40.58, -74.09 40.64, -74.17 40.64))'),
    g1)

-- Example 22894
...
  ST_CONTAINS(
    g1,
    TO_GEOGRAPHY('MULTIPOINT((0 0), (1 1))'))

-- Example 22895
...
  ST_WITHIN(
   TO_GEOGRAPHY('{"type" : "MultiPoint","coordinates" : [[-122.30, 37.55], [-122.20, 47.61]]}'),
   g1)

-- Example 22896
...
  ST_WITHIN(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'))

-- Example 22897
...
  ST_COVERS(
    TO_GEOGRAPHY('POLYGON((-1 -1, -1 4, 4 4, 4 -1, -1 -1))'),
    g1)

-- Example 22898
...
  ST_COVERS(
    g1,
    TO_GEOGRAPHY('POINT(0 0)'))

-- Example 22899
...
  ST_COVEREDBY(
    TO_GEOGRAPHY('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))'),
    g1)

-- Example 22900
...
  ST_COVEREDBY(
    g1,
    TO_GEOGRAPHY('POINT(-122.35 37.55)'))

-- Example 22901
...
  ST_DWITHIN(
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1,
    100000)

-- Example 22902
...
  ST_DWITHIN(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    100000)

-- Example 22903
...
  ST_INTERSECTS(
    g1,
    ST_GEOGRAPHYFROMWKT('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'))

-- Example 22904
...
  ST_INTERSECTS(
    ST_GEOGFROMTEXT('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1)

-- Example 22905
...
  ST_CONTAINS(
    ST_GEOGRAPHYFROMEWKT('POLYGON((-74.17 40.64, -74.1796875 40.58, -74.09 40.58, -74.09 40.64, -74.17 40.64))'),
    g1)

-- Example 22906
...
  ST_WITHIN(
    ST_GEOGRAPHYFROMWKB('01010000006666666666965EC06666666666C64240'),
    g1)

-- Example 22907
...
  ST_COVERS(
    g1,
    ST_MAKEPOINT(0.2, 0.8))

-- Example 22908
...
  ST_INTERSECTS(
    g1,
    ST_MAKELINE(
      TO_GEOGRAPHY('MULTIPOINT((0 0), (1 1))'),
      TO_GEOGRAPHY('POINT(0.8 0.2)')))

-- Example 22909
...
  ST_INTERSECTS(
    ST_POLYGON(
      TO_GEOGRAPHY('SRID=4326;LINESTRING(0.0 0.0, 1.0 0.0, 1.0 2.0, 0.0 2.0, 0.0 0.0)')),
    g1)

-- Example 22910
...
  ST_WITHIN(
    g1,
    TRY_TO_GEOGRAPHY('POLYGON((-1 -1, -1 4, 4 4, 4 -1, -1 -1))'))

-- Example 22911
...
  ST_COVERS(
    g1,
    ST_GEOGPOINTFROMGEOHASH('s00'))

-- Example 22912
SELECT id, c1, c2, c3
  FROM test_table
  WHERE c1 = 1
    AND c3 = TO_DATE('2004-03-09')
  ORDER BY id;

-- Example 22913
DELETE FROM test_table WHERE id = 3;

-- Example 22914
UPDATE test_table SET c1 = 99 WHERE id = 4;

-- Example 22915
ALTER TABLE t1 DROP SEARCH OPTIMIZATION;

-- Example 22916
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(mycol);

-- Example 22917
ALTER TABLE mytable ADD SEARCH OPTIMIZATION;

-- Example 22918
SELECT * FROM test_table WHERE id = 3;

-- Example 22919
SELECT id, c1, c2, c3
  FROM test_table
  WHERE id IN (2, 3)
  ORDER BY id;

-- Example 22920
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(mycol);

-- Example 22921
LIKE '%TEST%'

-- Example 22922
LIKE '%SEARCH%IS%OPTIMIZED%'

-- Example 22923
RLIKE '(string)+'

-- Example 22924
RLIKE $$.*email=[\w\.]+@snowflake\.com.*$$

-- Example 22925
RLIKE '.*country=(Germany|France|Spain).*'

-- Example 22926
RLIKE '.*phone=[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22927
RLIKE '.*[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22928
RLIKE '.*tel=[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22929
RLIKE '.*(option1|option2|opt3).*'

-- Example 22930
RLIKE '.*[a-zA-z]+(string)?[0-9]+.*'

-- Example 22931
.*st=(CA|AZ|NV).*(-->){2,4}.*

-- Example 22932
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(myvariantcol);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c4:user.uuid);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(myvariantcol);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON SUBSTRING(c4:user.uuid);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(object_column);
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(object_column);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(array_column);
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(array_column);

-- Example 22933
CREATE OR REPLACE TABLE test_table
(
  id INTEGER,
  src VARIANT
);

INSERT INTO test_table SELECT 1, TO_VARIANT('true'::BOOLEAN);
INSERT INTO test_table SELECT 2, TO_VARIANT('2020-01-09'::DATE);
INSERT INTO test_table SELECT 3, TO_VARIANT('2020-01-09 01:02:03.899'::TIMESTAMP);

-- Example 22934
SELECT * FROM test_table WHERE src::TEXT = 'true';
SELECT * FROM test_table WHERE src::TEXT = '2020-01-09';
SELECT * FROM test_table WHERE src::TEXT = '2020-01-09 01:02:03.899';

-- Example 22935
WHERE src:person.age = 42;

-- Example 22936
WHERE src:location.temperature::NUMBER(8, 6) = 23.456789;

-- Example 22937
WHERE src:sender_info.ip_address = '123.123.123.123';

-- Example 22938
WHERE src:salesperson.name::TEXT = 'John Appleseed';

-- Example 22939
WHERE src:events.date::DATE = '2021-03-26';

-- Example 22940
WHERE src:event_logs.exceptions.timestamp_info(3) = '2021-03-26 15:00:00.123 -0800';

-- Example 22941
WHERE my_array_column[2] = 5;

WHERE my_array_column[2]::NUMBER(4, 1) = 5;

-- Example 22942
WHERE object_column['mykey'] = 3;

WHERE object_column:mykey = 3;

WHERE object_column['mykey']::NUMBER(4, 1) = 3;

WHERE object_column:mykey::NUMBER(4, 1) = 3;

-- Example 22943
WHERE ARRAY_CONTAINS('77.146.211.88'::VARIANT, src:logs.ip_addresses)

-- Example 22944
WHERE ARRAY_CONTAINS(300, my_array_column)

-- Example 22945
WHERE ARRAYS_OVERLAP(
  ARRAY_CONSTRUCT('122.63.45.75', '89.206.83.107'), src:senders.ip_addresses)

-- Example 22946
WHERE ARRAYS_OVERLAP(
  ARRAY_CONSTRUCT('a', 'b'), my_array_column)

-- Example 22947
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22948
SELECT * FROM test_table WHERE col2:data.search LIKE '%optimization%';

-- Example 22949
SELECT * FROM test_table WHERE col2:name LIKE '%simon%parker%';
SELECT * FROM test_table WHERE col2 LIKE '%hello%world%';

-- Example 22950
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:name);
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22951
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data);
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22952
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON GEO(mygeocol);

-- Example 22953
CREATE TABLE new_table AS SELECT * FROM source_table ORDER BY st_geohash(geom);
ALTER TABLE new_table ADD SEARCH OPTIMIZATION ON GEO(geom);

-- Example 22954
CREATE TABLE new_table AS SELECT *, ST_GEOHASH(geom) AS geom_geohash FROM source_table;
ALTER TABLE new_table CLUSTER BY (geom_geohash);
ALTER TABLE new_table ADD SEARCH OPTIMIZATION ON GEO(geom);

-- Example 22955
CREATE OR REPLACE TABLE geospatial_table (id NUMBER, g1 GEOGRAPHY);
INSERT INTO geospatial_table VALUES
  (1, 'POINT(-122.35 37.55)'),
  (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)'),
  (3, 'POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))');
ALTER TABLE geospatial_table ADD SEARCH OPTIMIZATION ON GEO(g1);

-- Example 22956
SELECT id FROM geospatial_table WHERE
  ST_INTERSECTS(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'));

-- Example 22957
...
  ST_INTERSECTS(
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
    g1)

-- Example 22958
...
  ST_CONTAINS(
    TO_GEOGRAPHY('POLYGON((-74.17 40.64, -74.1796875 40.58, -74.09 40.58, -74.09 40.64, -74.17 40.64))'),
    g1)

