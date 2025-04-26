-- Example 613
+--------------------+------------------+
| CURRENT_DATABASE() | CURRENT_SCHEMA() |
|--------------------+------------------|
| SF_TUTS            | PUBLIC           |
+--------------------+------------------+

-- Example 614
CREATE OR REPLACE TABLE emp_basic (
   first_name STRING ,
   last_name STRING ,
   email STRING ,
   streetaddress STRING ,
   city STRING ,
   start_date DATE
   );

-- Example 615
CREATE OR REPLACE WAREHOUSE sf_tuts_wh WITH
   WAREHOUSE_SIZE='X-SMALL'
   AUTO_SUSPEND = 180
   AUTO_RESUME = TRUE
   INITIALLY_SUSPENDED=TRUE;

-- Example 616
SELECT CURRENT_WAREHOUSE();

-- Example 617
+---------------------+
| CURRENT_WAREHOUSE() |
|---------------------|
| SF_TUTS_WH          |
+---------------------+

-- Example 618
PUT file://<file-path>[/\]employees0*.csv @sf_tuts.public.%emp_basic;

-- Example 619
PUT file:///tmp/employees0*.csv @sf_tuts.public.%emp_basic;

-- Example 620
PUT file://C:\temp\employees0*.csv @sf_tuts.public.%emp_basic;

-- Example 621
+-----------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source          | target             | source_size | target_size | source_compression | target_compression | status   | message |
|-----------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| employees01.csv | employees01.csv.gz |         360 |         287 | NONE               | GZIP               | UPLOADED |         |
| employees02.csv | employees02.csv.gz |         355 |         274 | NONE               | GZIP               | UPLOADED |         |
| employees03.csv | employees03.csv.gz |         397 |         295 | NONE               | GZIP               | UPLOADED |         |
| employees04.csv | employees04.csv.gz |         366 |         288 | NONE               | GZIP               | UPLOADED |         |
| employees05.csv | employees05.csv.gz |         394 |         299 | NONE               | GZIP               | UPLOADED |         |
+-----------------+--------------------+-------------+-------------+--------------------+--------------------+----------+---------+

-- Example 622
LIST @sf_tuts.public.%emp_basic;

-- Example 623
+--------------------+------+----------------------------------+------------------------------+
| name               | size | md5                              | last_modified                |
|--------------------+------+----------------------------------+------------------------------|
| employees01.csv.gz |  288 | a851f2cc56138b0cd16cb603a97e74b1 | Tue, 9 Jan 2018 15:31:44 GMT |
| employees02.csv.gz |  288 | 125f5645ea500b0fde0cdd5f54029db9 | Tue, 9 Jan 2018 15:31:44 GMT |
| employees03.csv.gz |  304 | eafee33d3e62f079a054260503ddb921 | Tue, 9 Jan 2018 15:31:45 GMT |
| employees04.csv.gz |  304 | 9984ab077684fbcec93ae37479fa2f4d | Tue, 9 Jan 2018 15:31:44 GMT |
| employees05.csv.gz |  304 | 8ad4dc63a095332e158786cb6e8532d0 | Tue, 9 Jan 2018 15:31:44 GMT |
+--------------------+------+----------------------------------+------------------------------+

-- Example 624
COPY INTO emp_basic
  FROM @%emp_basic
  FILE_FORMAT = (type = csv field_optionally_enclosed_by='"')
  PATTERN = '.*employees0[1-5].csv.gz'
  ON_ERROR = 'skip_file';

-- Example 625
+--------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file               | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|--------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| employees02.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| employees04.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| employees05.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| employees03.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
| employees01.csv.gz | LOADED |           5 |           5 |           1 |           0 | NULL        |             NULL |                  NULL | NULL                    |
+--------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 626
SELECT * FROM emp_basic;

-- Example 627
+------------+--------------+---------------------------+-----------------------------+--------------------+------------+
| FIRST_NAME | LAST_NAME    | EMAIL                     | STREETADDRESS               | CITY               | START_DATE |
|------------+--------------+---------------------------+-----------------------------+--------------------+------------|
| Arlene     | Davidovits   | adavidovitsk@sf_tuts.com  | 7571 New Castle Circle      | Meniko             | 2017-05-03 |
| Violette   | Shermore     | vshermorel@sf_tuts.com    | 899 Merchant Center         | Troitsk            | 2017-01-19 |
| Ron        | Mattys       | rmattysm@sf_tuts.com      | 423 Lien Pass               | Bayaguana          | 2017-11-15 |
 ...
 ...
 ...
| Carson     | Bedder       | cbedderh@sf_tuts.co.au    | 71 Clyde Gallagher Place    | Leninskoye         | 2017-03-29 |
| Dana       | Avory        | davoryi@sf_tuts.com       | 2 Holy Cross Pass           | Wenlin             | 2017-05-11 |
| Ronny      | Talmadge     | rtalmadgej@sf_tuts.co.uk  | 588 Chinook Street          | Yawata             | 2017-06-02 |
+------------+--------------+---------------------------+-----------------------------+--------------------+------------+

-- Example 628
INSERT INTO emp_basic VALUES
   ('Clementine','Adamou','cadamou@sf_tuts.com','10510 Sachs Road','Klenak','2017-9-22') ,
   ('Marlowe','De Anesy','madamouc@sf_tuts.co.uk','36768 Northfield Plaza','Fangshan','2017-1-26');

-- Example 629
SELECT email FROM emp_basic WHERE email LIKE '%.uk';

-- Example 630
+--------------------------+
| EMAIL                    |
|--------------------------|
| gbassfordo@sf_tuts.co.uk |
| rtalmadgej@sf_tuts.co.uk |
| madamouc@sf_tuts.co.uk   |
+--------------------------+

-- Example 631
SELECT first_name, last_name, DATEADD('day',90,start_date) FROM emp_basic WHERE start_date <= '2017-01-01';

-- Example 632
+------------+-----------+------------------------------+
| FIRST_NAME | LAST_NAME | DATEADD('DAY',90,START_DATE) |
|------------+-----------+------------------------------|
| Granger    | Bassford  | 2017-03-30                   |
| Catherin   | Devereu   | 2017-03-17                   |
| Cesar      | Hovie     | 2017-03-21                   |
| Wallis     | Sizey     | 2017-03-30                   |
+------------+-----------+------------------------------+

-- Example 633
DROP DATABASE IF EXISTS sf_tuts;

DROP WAREHOUSE IF EXISTS sf_tuts_wh;

-- Example 634
USE ROLE USERADMIN;

-- Example 635
CREATE OR REPLACE USER snowman
PASSWORD = 'sn0wf@ll'
LOGIN_NAME = 'snowstorm'
FIRST_NAME = 'Snow'
LAST_NAME = 'Storm'
EMAIL = 'snow.storm@snowflake.com'
MUST_CHANGE_PASSWORD = true
DEFAULT_WAREHOUSE = COMPUTE_WH;

-- Example 636
User SNOWMAN successfully created.

-- Example 637
USE ROLE SECURITYADMIN;

-- Example 638
GRANT ROLE SYSADMIN TO USER snowman;

-- Example 639
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;

-- Example 640
USE ROLE ACCOUNTADMIN;

-- Example 641
SHOW USERS;

-- Example 642
SHOW ROLES;

-- Example 643
DROP USER snowman;

-- Example 644
USE ROLE accountadmin;

-- Example 645
USE WAREHOUSE compute_wh;

-- Example 646
CREATE OR REPLACE DATABASE tasty_bytes_sample_data;

-- Example 647
CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;

-- Example 648
CREATE OR REPLACE TABLE tasty_bytes_sample_data.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);

-- Example 649
SELECT * FROM tasty_bytes_sample_data.raw_pos.menu;

-- Example 650
CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

-- Example 651
LIST @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

-- Example 652
COPY INTO tasty_bytes_sample_data.raw_pos.menu
FROM @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

-- Example 653
SELECT COUNT(*) AS row_count FROM tasty_bytes_sample_data.raw_pos.menu;

-- Example 654
SELECT TOP 10 * FROM tasty_bytes_sample_data.raw_pos.menu;

-- Example 655
DROP DATABASE IF EXISTS tasty_bytes_sample_data;

-- Example 656
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
from snowflake.snowpark.types import StructField, StructType, IntegerType, StringType, VariantType

-- Example 657
def main(session: snowpark.Session):

-- Example 658
# Use SQL to create our Tasty Bytes Database
session.sql('CREATE OR REPLACE DATABASE tasty_bytes_sample_data;').collect()

-- Example 659
# Use SQL to create our Raw POS (Point-of-Sale) Schema
session.sql('CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;').collect()

-- Example 660
# Use SQL to create our Blob Stage
session.sql('CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage url = "s3://sfquickstarts/tastybytes/" file_format = (type = csv);').collect()

-- Example 661
# Define our Menu Schema
menu_schema = StructType([StructField("menu_id",IntegerType()),\
                     StructField("menu_type_id",IntegerType()),\
                     StructField("menu_type",StringType()),\
                     StructField("truck_brand_name",StringType()),\
                     StructField("menu_item_id",IntegerType()),\
                     StructField("menu_item_name",StringType()),\
                     StructField("item_category",StringType()),\
                     StructField("item_subcategory",StringType()),\
                     StructField("cost_of_goods_usd",IntegerType()),\
                     StructField("sale_price_usd",IntegerType()),\
                     StructField("menu_item_health_metrics_obj",VariantType())])

-- Example 662
# Create a Dataframe from our Menu file from our Blob Stage
df_blob_stage_read = session.read.schema(menu_schema).csv('@tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/')

-- Example 663
# Save our Dataframe as a Menu table in our Tasty Bytes Database and Raw POS Schema
df_blob_stage_read.write.mode("overwrite").save_as_table("tasty_bytes_sample_data.raw_pos.menu")

-- Example 664
# Create a new Dataframe reading from our Menu table and filtering for the Freezing Point brand
df_menu_freezing_point = session.table("tasty_bytes_sample_data.raw_pos.menu").filter(col("truck_brand_name") == 'Freezing Point')

-- Example 665
# return our Dataframe
return df_menu_freezing_point

-- Example 666
DROP DATABASE IF EXISTS tasty_bytes_sample_data;

-- Example 667
USE ROLE accountadmin;

-- Example 668
USE WAREHOUSE compute_wh;

-- Example 669
CREATE OR REPLACE DATABASE cloud_data_db
  COMMENT = 'Database for loading cloud data';

-- Example 670
CREATE OR REPLACE SCHEMA cloud_data_db.s3_data
  COMMENT = 'Schema for tables loaded from S3';

-- Example 671
CREATE OR REPLACE TABLE cloud_data_db.s3_data.calendar
  (
  full_date DATE
  ,day_name VARCHAR(10)
  ,month_name VARCHAR(10)
  ,day_number VARCHAR(2)
  ,full_year VARCHAR(4)
  ,holiday BOOLEAN
  )
  COMMENT = 'Table to be loaded from S3 calendar data file';

-- Example 672
SELECT * FROM cloud_data_db.s3_data.calendar;

-- Example 673
CREATE OR REPLACE STORAGE INTEGRATION s3_data_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::631373164455:role/tutorial_role'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://snow-tutorial-bucket/s3data/');

-- Example 674
DESCRIBE INTEGRATION s3_data_integration;

-- Example 675
SHOW INTEGRATIONS;

-- Example 676
CREATE OR REPLACE STAGE cloud_data_db.s3_data.s3data_stage
  STORAGE_INTEGRATION = s3_data_integration
  URL = 's3://snow-tutorial-bucket/s3data/'
  FILE_FORMAT = (TYPE = CSV);

-- Example 677
SHOW STAGES;

-- Example 678
COPY INTO cloud_data_db.s3_data.calendar
  FROM @cloud_data_db.s3_data.s3data_stage
    FILES = ('calendar.txt');

-- Example 679
SELECT * FROM cloud_data_db.s3_data.calendar;

-- Example 680
DROP TABLE calendar;

