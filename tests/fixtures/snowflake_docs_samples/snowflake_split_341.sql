-- Example 22825
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(mycol);

-- Example 22826
ALTER TABLE mytable ADD SEARCH OPTIMIZATION;

-- Example 22827
SELECT *
  FROM test_so_scalar_function_system
  WHERE mycol = SHA2('Snowflake');

-- Example 22828
CREATE OR REPLACE FUNCTION test_scalar_udf(x INTEGER)
RETURNS INTEGER
AS
$$
  SELECT x + POW(2, 3)::INTEGER + 2
$$
;

-- Example 22829
SELECT *
  FROM test_so_scalar_function_udf
  WHERE mycol = test_scalar_udf(15750);

-- Example 22830
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 22831
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(line, ANALYZER => 'UNICODE_ANALYZER');

-- Example 22832
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22833
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 22834
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(line);

-- Example 22835
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22836
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | LINE   | VARCHAR(2000)    | false  |
+---------------+----------------------------+--------+------------------+--------+

-- Example 22837
ALTER TABLE car_sales ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(src);

DESCRIBE SEARCH OPTIMIZATION ON car_sales;

-- Example 22838
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | SRC    | VARIANT          | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 22839
CREATE OR REPLACE TABLE so_object_example (object_column OBJECT);

INSERT INTO so_object_example (object_column)
  SELECT OBJECT_CONSTRUCT('a', 1::VARIANT, 'b', 2::VARIANT);

-- Example 22840
ALTER TABLE so_object_example ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(object_column);

DESCRIBE SEARCH OPTIMIZATION ON so_object_example;

-- Example 22841
+---------------+----------------------------+---------------+------------------+--------+
| expression_id | method                     | target        | target_data_type | active |
|---------------+----------------------------+---------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | OBJECT_COLUMN | OBJECT           | true   |
+---------------+----------------------------+---------------+------------------+--------+

-- Example 22842
CREATE OR REPLACE TABLE so_array_example (array_column ARRAY);

INSERT INTO so_array_example (array_column)
  SELECT ARRAY_CONSTRUCT('a', 'b', 'c');

-- Example 22843
ALTER TABLE so_array_example ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(array_column);

DESCRIBE SEARCH OPTIMIZATION ON so_array_example;

-- Example 22844
+---------------+----------------------------+--------------+------------------+--------+
| expression_id | method                     | target       | target_data_type | active |
|---------------+----------------------------+--------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | ARRAY_COLUMN | ARRAY            | true   |
+---------------+----------------------------+--------------+------------------+--------+

-- Example 22845
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, act_scene_line, character, line, ANALYZER => 'UNICODE_ANALYZER');

DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22846
+---------------+----------------------------+----------------+------------------+--------+
| expression_id | method                     | target         | target_data_type | active |
|---------------+----------------------------+----------------+------------------+--------|
|             1 | FULL_TEXT UNICODE_ANALYZER | PLAY           | VARCHAR(50)      | true   |
|             2 | FULL_TEXT UNICODE_ANALYZER | ACT_SCENE_LINE | VARCHAR(10)      | true   |
|             3 | FULL_TEXT UNICODE_ANALYZER | CHARACTER      | VARCHAR(30)      | true   |
|             4 | FULL_TEXT UNICODE_ANALYZER | LINE           | VARCHAR(2000)    | true   |
+---------------+----------------------------+----------------+------------------+--------+

-- Example 22847
ALTER TABLE lines DROP SEARCH OPTIMIZATION ON 1, 2, 3;

-- Example 22848
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22849
+---------------+----------------------------+--------+------------------+--------+
| expression_id | method                     | target | target_data_type | active |
|---------------+----------------------------+--------+------------------+--------|
|             4 | FULL_TEXT UNICODE_ANALYZER | LINE   | VARCHAR(2000)    | true   |
+---------------+----------------------------+--------+------------------+--------+

-- Example 22850
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(*);

-- Example 22851
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22852
+---------------+----------------------------+----------------+------------------+--------+
| expression_id | method                     | target         | target_data_type | active |
|---------------+----------------------------+----------------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | PLAY           | VARCHAR(50)      | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | ACT_SCENE_LINE | VARCHAR(10)      | true   |
|             3 | FULL_TEXT DEFAULT_ANALYZER | CHARACTER      | VARCHAR(30)      | true   |
|             4 | FULL_TEXT DEFAULT_ANALYZER | LINE           | VARCHAR(2000)    | true   |
+---------------+----------------------------+----------------+------------------+--------+

-- Example 22853
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, speech_num, act_scene_line, character, line);

-- Example 22854
001128 (42601): SQL compilation error: error line 1 at position 76
Expression FULL_TEXT(IDX_SRC_TABLE.SPEECH_NUM) cannot be used in search optimization.

-- Example 22855
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(mycol);

-- Example 22856
LIKE '%TEST%'

-- Example 22857
LIKE '%SEARCH%IS%OPTIMIZED%'

-- Example 22858
RLIKE '(string)+'

-- Example 22859
RLIKE $$.*email=[\w\.]+@snowflake\.com.*$$

-- Example 22860
RLIKE '.*country=(Germany|France|Spain).*'

-- Example 22861
RLIKE '.*phone=[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22862
RLIKE '.*[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22863
RLIKE '.*tel=[0-9]{3}-?[0-9]{3}-?[0-9]{4}.*'

-- Example 22864
RLIKE '.*(option1|option2|opt3).*'

-- Example 22865
RLIKE '.*[a-zA-z]+(string)?[0-9]+.*'

-- Example 22866
.*st=(CA|AZ|NV).*(-->){2,4}.*

-- Example 22867
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(myvariantcol);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c4:user.uuid);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(myvariantcol);
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON SUBSTRING(c4:user.uuid);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(object_column);
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(object_column);

ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(array_column);
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON SUBSTRING(array_column);

-- Example 22868
CREATE OR REPLACE TABLE test_table
(
  id INTEGER,
  src VARIANT
);

INSERT INTO test_table SELECT 1, TO_VARIANT('true'::BOOLEAN);
INSERT INTO test_table SELECT 2, TO_VARIANT('2020-01-09'::DATE);
INSERT INTO test_table SELECT 3, TO_VARIANT('2020-01-09 01:02:03.899'::TIMESTAMP);

-- Example 22869
SELECT * FROM test_table WHERE src::TEXT = 'true';
SELECT * FROM test_table WHERE src::TEXT = '2020-01-09';
SELECT * FROM test_table WHERE src::TEXT = '2020-01-09 01:02:03.899';

-- Example 22870
WHERE src:person.age = 42;

-- Example 22871
WHERE src:location.temperature::NUMBER(8, 6) = 23.456789;

-- Example 22872
WHERE src:sender_info.ip_address = '123.123.123.123';

-- Example 22873
WHERE src:salesperson.name::TEXT = 'John Appleseed';

-- Example 22874
WHERE src:events.date::DATE = '2021-03-26';

-- Example 22875
WHERE src:event_logs.exceptions.timestamp_info(3) = '2021-03-26 15:00:00.123 -0800';

-- Example 22876
WHERE my_array_column[2] = 5;

WHERE my_array_column[2]::NUMBER(4, 1) = 5;

-- Example 22877
WHERE object_column['mykey'] = 3;

WHERE object_column:mykey = 3;

WHERE object_column['mykey']::NUMBER(4, 1) = 3;

WHERE object_column:mykey::NUMBER(4, 1) = 3;

-- Example 22878
WHERE ARRAY_CONTAINS('77.146.211.88'::VARIANT, src:logs.ip_addresses)

-- Example 22879
WHERE ARRAY_CONTAINS(300, my_array_column)

-- Example 22880
WHERE ARRAYS_OVERLAP(
  ARRAY_CONSTRUCT('122.63.45.75', '89.206.83.107'), src:senders.ip_addresses)

-- Example 22881
WHERE ARRAYS_OVERLAP(
  ARRAY_CONSTRUCT('a', 'b'), my_array_column)

-- Example 22882
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22883
SELECT * FROM test_table WHERE col2:data.search LIKE '%optimization%';

-- Example 22884
SELECT * FROM test_table WHERE col2:name LIKE '%simon%parker%';
SELECT * FROM test_table WHERE col2 LIKE '%hello%world%';

-- Example 22885
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:name);
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22886
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data);
ALTER TABLE test_table ADD SEARCH OPTIMIZATION ON SUBSTRING(col2:data.search);

-- Example 22887
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON GEO(mygeocol);

-- Example 22888
CREATE TABLE new_table AS SELECT * FROM source_table ORDER BY st_geohash(geom);
ALTER TABLE new_table ADD SEARCH OPTIMIZATION ON GEO(geom);

-- Example 22889
CREATE TABLE new_table AS SELECT *, ST_GEOHASH(geom) AS geom_geohash FROM source_table;
ALTER TABLE new_table CLUSTER BY (geom_geohash);
ALTER TABLE new_table ADD SEARCH OPTIMIZATION ON GEO(geom);

-- Example 22890
CREATE OR REPLACE TABLE geospatial_table (id NUMBER, g1 GEOGRAPHY);
INSERT INTO geospatial_table VALUES
  (1, 'POINT(-122.35 37.55)'),
  (2, 'LINESTRING(-124.20 42.00, -120.01 41.99)'),
  (3, 'POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))');
ALTER TABLE geospatial_table ADD SEARCH OPTIMIZATION ON GEO(g1);

-- Example 22891
SELECT id FROM geospatial_table WHERE
  ST_INTERSECTS(
    g1,
    TO_GEOGRAPHY('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'));

