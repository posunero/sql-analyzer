-- Example 22624
CREATE TABLE IDENTIFIER($my_table_name) (i INTEGER);
INSERT INTO IDENTIFIER($my_table_name) (i) VALUES (42);

-- Example 22625
SELECT * FROM IDENTIFIER($my_table_name);

-- Example 22626
+----+
|  I |
|----|
| 42 |
+----+

-- Example 22627
SELECT * FROM TABLE($my_table_name);

-- Example 22628
+----+
|  I |
|----|
| 42 |
+----+

-- Example 22629
DROP TABLE IDENTIFIER($my_table_name);

-- Example 22630
SET (min, max)=(40, 70);

-- Example 22631
+----------------------------------+
| status                           |
|----------------------------------|
| Statement executed successfully. |
+----------------------------------+

-- Example 22632
SHOW VARIABLES;

-- Example 22633
+----------------+-------------------------------+-------------------------------+------+-------+-------+---------+
|     session_id | created_on                    | updated_on                    | name | value | type  | comment |
|----------------+-------------------------------+-------------------------------+------+-------+-------+---------|
| 10363773891062 | 2024-06-28 10:09:57.990 -0700 | 2024-06-28 10:09:58.032 -0700 | MAX  | 70    | fixed |         |
| 10363773891062 | 2024-06-28 10:09:57.990 -0700 | 2024-06-28 10:09:58.021 -0700 | MIN  | 40    | fixed |         |
+----------------+-------------------------------+-------------------------------+------+-------+-------+---------+

-- Example 22634
SET var_artist_name = 'Jackson Browne';

-- Example 22635
+----------------------------------+
| status                           |
+----------------------------------+
| Statement executed successfully. |
+----------------------------------+

-- Example 22636
SELECT GETVARIABLE('var_artist_name');

-- Example 22637
SELECT GETVARIABLE('VAR_ARTIST_NAME');

-- Example 22638
+--------------------------------+
| GETVARIABLE('VAR_ARTIST_NAME') |
+--------------------------------+
| Jackson Browne                 |
+--------------------------------+

-- Example 22639
SELECT album_title
  FROM albums
  WHERE artist = $var_artist_name;

-- Example 22640
UNSET my_variable;

-- Example 22641
CREATE CATALOG INTEGRATION auto_refresh_catalog_integration
  CATALOG_SOURCE = GLUE
  CATALOG_NAMESPACE = 'my_catalog_namespace'
  TABLE_FORMAT = ICEBERG
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::123456789123:role/my-catalog-role'
  GLUE_CATALOG_ID = '123456789123'
  ENABLED = TRUE
  REFRESH_INTERVAL_SECONDS = 60;

-- Example 22642
ALTER CATALOG INTEGRATION auto_refresh_catalog_integration SET REFRESH_INTERVAL_SECONDS = 120;

-- Example 22643
CREATE OR REPLACE ICEBERG TABLE auto_refresh_iceberg_table
  CATALOG_TABLE_NAME = 'myGlueTable'
  CATALOG = 'auto_refresh_catalog_integration'
  AUTO_REFRESH = TRUE;

-- Example 22644
ALTER ICEBERG TABLE my_iceberg_table SET AUTO_REFRESH = FALSE;

-- Example 22645
SELECT SYSTEM$AUTO_REFRESH_STATUS('my_iceberg_table');

-- Example 22646
ALTER DATABASE my_database_1
  SET CATALOG = 'shared_catalog_integration';

-- Example 22647
CREATE ICEBERG TABLE my_iceberg_table
   EXTERNAL_VOLUME='my_external_volume'
   METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 22648
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table (
    boolean_col boolean,
    int_col int,
    long_col long,
    float_col float,
    double_col double,
    decimal_col decimal(10,5),
    string_col string,
    fixed_col fixed(10),
    binary_col binary,
    date_col date,
    time_col time,
    timestamp_ntz_col timestamp_ntz(6),
    timestamp_ltz_col timestamp_ltz(6)
  )
  CATALOG = 'SNOWFLAKE'
  EXTERNAL_VOLUME = 'my_ext_vol'
  BASE_LOCATION = 'my/relative/path/from/extvol';

-- Example 22649
CREATE ICEBERG TABLE myGlueTable
  EXTERNAL_VOLUME='glueCatalogVolume'
  CATALOG='glueCatalogInt'
  CATALOG_TABLE_NAME='myGlueTable';

-- Example 22650
CREATE ICEBERG TABLE myIcebergTable
  EXTERNAL_VOLUME='icebergMetadataVolume'
  CATALOG='icebergCatalogInt'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 22651
CREATE ICEBERG TABLE my_delta_iceberg_table
  CATALOG = delta_catalog_integration
  EXTERNAL_VOLUME = delta_external_volume
  BASE_LOCATION = 'relative/path/from/ext/vol/';

-- Example 22652
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'my_rest_catalog_integration'
  CATALOG_TABLE_NAME = 'my_remote_table';

-- Example 22653
CREATE ICEBERG TABLE myIcebergTable
  EXTERNAL_VOLUME='icebergMetadataVolume'
  CATALOG='icebergCatalogInt'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 22654
ALTER ICEBERG TABLE myIcebergTable REFRESH 'metadata/v2.metadata.json';

-- Example 22655
ALTER ICEBERG TABLE myIcebergTable CONVERT TO MANAGED
  BASE_LOCATION = 'my/relative/path/from/external_volume';

-- Example 22656
spark-shell --packages org.apache.iceberg:iceberg-spark-runtime-3.3_2.13:1.2.0,net.snowflake:snowflake-jdbc:3.13.28
# Configure a catalog named "snowflake_catalog" using the standard Iceberg SparkCatalog adapter
--conf spark.sql.catalog.snowflake_catalog=org.apache.iceberg.spark.SparkCatalog
# Specify the implementation of the named catalog to be Snowflake's Catalog implementation
--conf spark.sql.catalog.snowflake_catalog.catalog-impl=org.apache.iceberg.snowflake.SnowflakeCatalog
# Provide a Snowflake JDBC URI with which the Snowflake Catalog will perform low-level communication with Snowflake services
--conf spark.sql.catalog.snowflake_catalog.uri='jdbc:snowflake://<account_identifier>.snowflakecomputing.com'
# Configure the Snowflake user on whose behalf to perform Iceberg metadata lookups
--conf spark.sql.catalog.snowflake_catalog.jdbc.user=<user_name>
# Provide the user password. To configure the credentials, you can provide either password or private_key_file.
--conf spark.sql.catalog.snowflake_catalog.jdbc.password=<password>
# Configure the private_key_file to use when connecting to Snowflake services; additional connection options can be found at https://docs.snowflake.com/en/user-guide/jdbc-configure.html
--conf spark.sql.catalog.snowflake_catalog.jdbc.private_key_file=<location of the private key>

-- Example 22657
spark.sessionState.catalogManager.setCurrentCatalog("snowflake_catalog");
spark.sql("SHOW NAMESPACES").show()
spark.sql("SHOW NAMESPACES IN my_database").show()
spark.sql("USE my_database.my_schema").show()
spark.sql("SHOW TABLES").show()

-- Example 22658
spark.sql("SELECT * FROM my_database.my_schema.my_table WHERE ").show()

-- Example 22659
df = spark.table("my_database.my_schema.my_table")
df.show()

-- Example 22660
CREATE CATALOG INTEGRATION auto_refresh_catalog_integration
  CATALOG_SOURCE = GLUE
  CATALOG_NAMESPACE = 'my_catalog_namespace'
  TABLE_FORMAT = ICEBERG
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::123456789123:role/my-catalog-role'
  GLUE_CATALOG_ID = '123456789123'
  ENABLED = TRUE
  REFRESH_INTERVAL_SECONDS = 60;

-- Example 22661
ALTER CATALOG INTEGRATION auto_refresh_catalog_integration SET REFRESH_INTERVAL_SECONDS = 120;

-- Example 22662
CREATE OR REPLACE ICEBERG TABLE auto_refresh_iceberg_table
  CATALOG_TABLE_NAME = 'myGlueTable'
  CATALOG = 'auto_refresh_catalog_integration'
  AUTO_REFRESH = TRUE;

-- Example 22663
ALTER ICEBERG TABLE my_iceberg_table SET AUTO_REFRESH = FALSE;

-- Example 22664
SELECT SYSTEM$AUTO_REFRESH_STATUS('my_iceberg_table');

-- Example 22665
BEGIN
  INSERT INTO table1 VALUES (1, "One");
  INSERT INTO table1 VALUES (2, "Two");
  ALTER ICEBERG TABLE table1 ALTER COLUMN c3 SET DATA TYPE ARRAY(long);
  INSERT INTO table1 VALUES (3, "Three");
  INSERT INTO table1 VALUES (4, "Four");
COMMIT;

-- Example 22666
CREATE OR REPLACE CATALOG INTEGRATION icebergCatalogInt
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = ICEBERG
  ENABLED = TRUE;

-- Example 22667
CREATE OR REPLACE CATALOG INTEGRATION delta_catalog_integration
  CATALOG_SOURCE = OBJECT_STORE
  TABLE_FORMAT = DELTA
  ENABLED = TRUE;

-- Example 22668
<subject> [ NOT ] LIKE <pattern> [ ESCAPE <escape> ]

LIKE( <subject> , <pattern> [ , <escape> ] )

-- Example 22669
'SOMETHING%' LIKE '%\\%%' ESCAPE '\\';

-- Example 22670
CREATE OR REPLACE TABLE like_ex(name VARCHAR(20));
INSERT INTO like_ex VALUES
  ('John  Dddoe'),
  ('John \'alias\' Doe'),
  ('Joe   Doe'),
  ('John_down'),
  ('Joe down'),
  ('Elaine'),
  (''),    -- empty string
  (null);

-- Example 22671
SELECT name
  FROM like_ex
  WHERE name LIKE '%Jo%oe%'
  ORDER BY name;

-- Example 22672
+------------------+
| NAME             |
|------------------|
| Joe   Doe        |
| John  Dddoe      |
| John 'alias' Doe |
+------------------+

-- Example 22673
SELECT name
  FROM like_ex
  WHERE name NOT LIKE '%Jo%oe%'
  ORDER BY name;

-- Example 22674
+-----------+
| NAME      |
|-----------|
|           |
| Elaine    |
| Joe down  |
| John_down |
+-----------+

-- Example 22675
SELECT name
  FROM like_ex
  WHERE name NOT LIKE 'John%'
  ORDER BY name;

-- Example 22676
+-----------+                                                                   
| NAME      |
|-----------|
|           |
| Elaine    |
| Joe   Doe |
| Joe down  |
+-----------+

-- Example 22677
SELECT name
  FROM like_ex
  WHERE name NOT LIKE ''
  ORDER BY name;

-- Example 22678
+------------------+
| NAME             |
|------------------|
| Elaine           |
| Joe   Doe        |
| Joe down         |
| John  Dddoe      |
| John 'alias' Doe |
| John_down        |
+------------------+

-- Example 22679
SELECT name
  FROM like_ex
  WHERE name LIKE '%\'%'
  ORDER BY name;

-- Example 22680
+------------------+
| NAME             |
|------------------|
| John 'alias' Doe |
+------------------+

-- Example 22681
SELECT name
  FROM like_ex
  WHERE name LIKE '%J%h%^_do%' ESCAPE '^'
  ORDER BY name;

-- Example 22682
+-----------+                                                                   
| NAME      |
|-----------|
| John_down |
+-----------+

-- Example 22683
INSERT INTO like_ex (name) VALUES 
  ('100 times'),
  ('1000 times'),
  ('100%');

-- Example 22684
SELECT * FROM like_ex WHERE name LIKE '100%'
  ORDER BY 1;

-- Example 22685
+------------+                                                                  
| NAME       |
|------------|
| 100 times  |
| 100%       |
| 1000 times |
+------------+

-- Example 22686
SELECT * FROM like_ex WHERE name LIKE '100^%' ESCAPE '^'
  ORDER BY 1;

-- Example 22687
+------+                                                                        
| NAME |
|------|
| 100% |
+------+

-- Example 22688
SELECT * FROM like_ex WHERE name LIKE '100\\%' ESCAPE '\\'
  ORDER BY 1;

-- Example 22689
+------+                                                                        
| NAME |
|------|
| 100% |
+------+

-- Example 22690
ALTER SESSION SET TIMEZONE = UTC;

