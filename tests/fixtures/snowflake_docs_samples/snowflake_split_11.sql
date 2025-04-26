-- Example 681
USE ROLE accountadmin;

-- Example 682
USE WAREHOUSE compute_wh;

-- Example 683
CREATE OR REPLACE DATABASE cloud_data_db
  COMMENT = 'Database for loading cloud data';

-- Example 684
CREATE OR REPLACE SCHEMA cloud_data_db.azure_data
  COMMENT = 'Schema for tables loaded from Azure';

-- Example 685
CREATE OR REPLACE TABLE cloud_data_db.azure_data.calendar
  (
  full_date DATE
  ,day_name VARCHAR(10)
  ,month_name VARCHAR(10)
  ,day_number VARCHAR(2)
  ,full_year VARCHAR(4)
  ,holiday BOOLEAN
  )
  COMMENT = 'Table to be loaded from Azure calendar data file';

-- Example 686
SELECT * FROM cloud_data_db.azure_data.calendar;

-- Example 687
CREATE OR REPLACE STORAGE INTEGRATION azure_data_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '075f576e-6f9b-4955-8e99-4086736225d9'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('azure://tutorial99.blob.core.windows.net/snow-tutorial-container/');

-- Example 688
DESCRIBE INTEGRATION azure_data_integration;

-- Example 689
SHOW INTEGRATIONS;

-- Example 690
CREATE OR REPLACE STAGE cloud_data_db.azure_data.azuredata_stage
  STORAGE_INTEGRATION = azure_data_integration
  URL = 'azure://tutorial99.blob.core.windows.net/snow-tutorial-container/'
  FILE_FORMAT = (TYPE = CSV);

-- Example 691
SHOW STAGES;

-- Example 692
COPY INTO cloud_data_db.azure_data.calendar
  FROM @cloud_data_db.azure_data.azuredata_stage
    FILES = ('calendar.txt');

-- Example 693
SELECT * FROM cloud_data_db.azure_data.calendar;

-- Example 694
DROP TABLE calendar;

-- Example 695
USE ROLE accountadmin;

-- Example 696
USE WAREHOUSE compute_wh;

-- Example 697
CREATE OR REPLACE DATABASE cloud_data_db
  COMMENT = 'Database for loading cloud data';

-- Example 698
CREATE OR REPLACE SCHEMA cloud_data_db.gcs_data
  COMMENT = 'Schema for tables loaded from GCS';

-- Example 699
CREATE OR REPLACE TABLE cloud_data_db.gcs_data.calendar
  (
  full_date DATE,
  day_name VARCHAR(10),
  month_name VARCHAR(10),
  day_number VARCHAR(2),
  full_year VARCHAR(4),
  holiday BOOLEAN
  )
  COMMENT = 'Table to be loaded from GCS calendar data file';

-- Example 700
SELECT * FROM cloud_data_db.gcs_data.calendar;

-- Example 701
CREATE OR REPLACE STORAGE INTEGRATION gcs_data_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://tutorial24bucket/gcsdata/');

-- Example 702
DESCRIBE INTEGRATION gcs_data_integration;

-- Example 703
SHOW INTEGRATIONS;

-- Example 704
CREATE OR REPLACE STAGE cloud_data_db.gcs_data.gcsdata_stage
  STORAGE_INTEGRATION = gcs_data_integration
  URL = 'gcs://tutorial24bucket/gcsdata/'
  FILE_FORMAT = (TYPE = CSV);

-- Example 705
SHOW STAGES;

-- Example 706
COPY INTO cloud_data_db.gcs_data.calendar
  FROM @cloud_data_db.gcs_data.gcsdata_stage
    FILES = ('calendar.txt');

-- Example 707
SELECT * FROM cloud_data_db.gcs_data.calendar;

-- Example 708
ID|lastname|firstname|company|email|workphone|cellphone|streetaddress|city|postalcode
6|Reed|Moses|Neque Corporation|eget.lacus@facilisis.com|1-449-871-0780|1-454-964-5318|Ap #225-4351 Dolor Ave|Titagarh|62631

-- Example 709
[
 {
   "customer": {
     "address": "509 Kings Hwy, Comptche, Missouri, 4848",
     "phone": "+1 (999) 407-2274",
     "email": "blankenship.patrick@orbin.ca",
     "company": "ORBIN",
     "name": {
       "last": "Patrick",
       "first": "Blankenship"
     },
     "_id": "5730864df388f1d653e37e6f"
   }
 },
]

-- Example 710
-- Create a database. A database automatically includes a schema named 'public'.

CREATE OR REPLACE DATABASE mydatabase;

/* Create target tables for CSV and JSON data. The tables are temporary, meaning they persist only for the duration of the user session and are not visible to other users. */

CREATE OR REPLACE TEMPORARY TABLE mycsvtable (
  id INTEGER,
  last_name STRING,
  first_name STRING,
  company STRING,
  email STRING,
  workphone STRING,
  cellphone STRING,
  streetaddress STRING,
  city STRING,
  postalcode STRING);

CREATE OR REPLACE TEMPORARY TABLE myjsontable (
  json_data VARIANT);

-- Create a warehouse

CREATE OR REPLACE WAREHOUSE mywarehouse WITH
  WAREHOUSE_SIZE='X-SMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED=TRUE;

-- Example 711
CREATE OR REPLACE FILE FORMAT mycsvformat
  TYPE = 'CSV'
  FIELD_DELIMITER = '|'
  SKIP_HEADER = 1;

-- Example 712
CREATE OR REPLACE FILE FORMAT myjsonformat
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Example 713
CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat;

-- Example 714
CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = myjsonformat;

-- Example 715
PUT file:///tmp/load/contacts*.csv @my_csv_stage AUTO_COMPRESS=TRUE;

-- Example 716
PUT file://C:\temp\load\contacts*.csv @my_csv_stage AUTO_COMPRESS=TRUE;

-- Example 717
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source        | target           | source_size | target_size | source_compression | target_compression | status   | message |
|---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| contacts1.csv | contacts1.csv.gz |         694 |         506 | NONE               | GZIP               | UPLOADED |         |
| contacts2.csv | contacts2.csv.gz |         763 |         565 | NONE               | GZIP               | UPLOADED |         |
| contacts3.csv | contacts3.csv.gz |         771 |         567 | NONE               | GZIP               | UPLOADED |         |
| contacts4.csv | contacts4.csv.gz |         750 |         561 | NONE               | GZIP               | UPLOADED |         |
| contacts5.csv | contacts5.csv.gz |         887 |         621 | NONE               | GZIP               | UPLOADED |         |
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+

-- Example 718
PUT file:///tmp/load/contacts.json @my_json_stage AUTO_COMPRESS=TRUE;

-- Example 719
PUT file://C:\temp\load\contacts.json @my_json_stage AUTO_COMPRESS=TRUE;

-- Example 720
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source        | target           | source_size | target_size | source_compression | target_compression | status   | message |
|---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| contacts.json | contacts.json.gz |         965 |         446 | NONE               | GZIP               | UPLOADED |         |
+---------------+------------------+-------------+-------------+--------------------+--------------------+----------+---------+

-- Example 721
LIST @my_csv_stage;

-- Example 722
LIST @my_json_stage;

-- Example 723
COPY INTO mycsvtable
  FROM @my_csv_stage/contacts1.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

-- Example 724
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                        | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts1.csv.gz | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 725
COPY INTO mycsvtable
  FROM @my_csv_stage
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  PATTERN='.*contacts[1-5].csv.gz'
  ON_ERROR = 'skip_file';

-- Example 726
+-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+
| file                        | status      | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                                                                                                                                                          | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts2.csv.gz | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| mycsvtable/contacts3.csv.gz | LOAD_FAILED |           5 |           0 |           1 |           2 | Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error |                3 |                     1 | "MYCSVTABLE"[11]        |
| mycsvtable/contacts4.csv.gz | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| mycsvtable/contacts5.csv.gz | LOADED      |           6 |           6 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
+-----------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+

-- Example 727
COPY INTO myjsontable
  FROM @my_json_stage/contacts.json.gz
  FILE_FORMAT = (FORMAT_NAME = myjsonformat)
  ON_ERROR = 'skip_file';

-- Example 728
+------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                         | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| myjsontable/contacts.json.gz | LOADED |           3 |           3 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 729
CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(mycsvtable, JOB_ID=>'<query_id>'));

-- Example 730
SELECT * FROM SAVE_COPY_ERRORS;

-- Example 731
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| ERROR                                                                                                                                                                | FILE                                | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |   CODE | SQL_STATE | COLUMN_NAME                   | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error | mycsvtable/contacts3.csv.gz         |    3 |         1 |         234 | parsing  | 100080 |     22000 | "MYCSVTABLE"[11]              |          1 |              2 | 11|Ishmael|Burnett|Dolor Elit Pellentesque Ltd|vitae.erat@necmollisvitae.ca|1-872|600-7301|1-513-592-6779|P.O. Box 975, 553 Odio, Road|Hulste|63345 |
| Field delimiter '|' found while expecting record delimiter '\n'                                                                                                      | mycsvtable/contacts3.csv.gz         |    5 |       125 |         625 | parsing  | 100016 |     22000 | "MYCSVTABLE"["POSTALCODE":10] |          4 |              5 | 14|Sophia|Christian|Turpis Ltd|lectus.pede@non.ca|1-962-503-3253|1-157-|850-3602|P.O. Box 824, 7971 Sagittis Rd.|Chattanooga|56188                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 732
PUT file:///tmp/load/contacts3.csv @my_csv_stage AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

-- Example 733
PUT file://C:\temp\load\contacts3.csv @my_csv_stage AUTO_COMPRESS=TRUE OVERWRITE=TRUE;

-- Example 734
COPY INTO mycsvtable
  FROM @my_csv_stage/contacts3.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

-- Example 735
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                        | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| mycsvtable/contacts3.csv.gz | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+-----------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 736
SELECT * FROM mycsvtable;

-- Example 737
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------+
| ID | LAST_NAME | FIRST_NAME | COMPANY                          | EMAIL                                  | WORKPHONE      | CELLPHONE      | STREETADDRESS                   | CITY             | POSTALCODE |
|----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------|
|  6 | Reed      | Moses      | Neque Corporation                | eget.lacus@facilisis.com               | 1-449-871-0780 | 1-454-964-5318 | Ap #225-4351 Dolor Ave          | Titagarh         |      62631 |
|  7 | Audrey    | Franks     | Arcu Eu Limited                  | eu.dui@aceleifendvitae.org             | 1-527-945-8935 | 1-263-127-1173 | Ap #786-9241 Mauris Road        | Bergen           |      81958 |
|  8 | Jakeem    | Erickson   | A Ltd                            | Pellentesque.habitant@liberoProinmi.ca | 1-381-591-9386 | 1-379-391-9490 | 319-1703 Dis Rd.                | Pangnirtung      |      62399 |
|  9 | Xaviera   | Brennan    | Bibendum Ullamcorper Limited     | facilisi.Sed.neque@dictum.edu          | 1-260-757-1919 | 1-211-651-0925 | P.O. Box 146, 8385 Vel Road     | Béziers          |      13082 |
| 10 | Francis   | Ortega     | Vitae Velit Egestas Associates   | egestas.rhoncus.Proin@faucibus.com     | 1-257-584-6487 | 1-211-870-2111 | 733-7191 Neque Rd.              | Chatillon        |      33081 |
| 16 | Aretha    | Sykes      | Lobortis Tellus Justo Foundation | eget@Naminterdumenim.net               | 1-670-849-1866 | 1-283-783-3710 | Ap #979-2481 Dui. Av.           | Thurso           |      66851 |
| 17 | Akeem     | Casey      | Pharetra Quisque Ac Institute    | dictum.eu@magna.edu                    | 1-277-657-0361 | 1-623-630-8848 | Ap #363-6074 Ullamcorper, Rd.   | Idar-Oberstei    |      30848 |
| 18 | Keelie    | Mendez     | Purus In Foundation              | Nulla.eu.neque@Aeneanegetmetus.co.uk   | 1-330-370-8231 | 1-301-568-0413 | 3511 Tincidunt Street           | Lanklaar         |      73942 |
| 19 | Lane      | Bishop     | Libero At PC                     | non@dapibusligula.ca                   | 1-340-862-4623 | 1-513-820-9039 | 7459 Pede. Street               | Linkebeek        |      89252 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                  | Stornaway        |      61290 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                  | Stornaway        |      61290 |
| 21 | Lance     | Harper     | Rutrum Lorem Limited             | Sed.neque@risus.com                    | 1-685-778-6726 | 1-494-188-6168 | 663-7682 Et St.                 | Gisborne         |      73449 |
| 22 | Keely     | Pace       | Eleifend Limited                 | ante.bibendum.ullamcorper@necenim.edu  | 1-312-381-5244 | 1-432-225-9226 | P.O. Box 506, 5233 Aliquam Av.  | Woodlands County |      61213 |
| 23 | Sage      | Leblanc    | Egestas A Consulting             | dapibus@elementum.org                  | 1-630-981-0327 | 1-301-287-0495 | 4463 Lorem Road                 | Woodlands County |      33951 |
| 24 | Marny     | Holt       | Urna Nec Luctus Associates       | ornare@vitaeorci.ca                    | 1-522-364-3947 | 1-460-971-8360 | P.O. Box 311, 4839 Nulla Av.    | Port Coquitlam   |      36733 |
| 25 | Holly     | Park       | Mauris PC                        | Vestibulum.ante@Maecenasliberoest.org  | 1-370-197-9316 | 1-411-413-4602 | P.O. Box 732, 8967 Eu Avenue    | Provost          |      45507 |
|  1 | Imani     | Davidson   | At Ltd                           | nec@sem.net                            | 1-243-889-8106 | 1-730-771-0412 | 369-6531 Molestie St.           | Russell          |      74398 |
|  2 | Kelsie    | Abbott     | Neque Sed Institute              | lacus@pede.net                         | 1-467-506-9933 | 1-441-508-7753 | P.O. Box 548, 1930 Pede. Road   | Campbellton      |      27022 |
|  3 | Hilel     | Durham     | Pede Incorporated                | eu@Craspellentesque.net                | 1-752-108-4210 | 1-391-449-8733 | Ap #180-2360 Nisl. Street       | Etalle           |      84025 |
|  4 | Graiden   | Molina     | Sapien Institute                 | sit@fermentum.net                      | 1-130-156-6666 | 1-269-605-7776 | 8890 A, Rd.                     | Dundee           |      70504 |
|  5 | Karyn     | Howard     | Pede Ac Industries               | sed.hendrerit@ornaretortorat.edu       | 1-109-166-5492 | 1-506-782-5089 | P.O. Box 902, 5398 Et, St.      | Saint-Hilarion   |      26232 |
| 11 | Ishmael   | Burnett    | Dolor Elit Pellentesque Ltd      | vitae.erat@necmollisvitae.ca           | 1-872-600-7301 | 1-513-592-6779 | P.O. Box 975, 553 Odio, Road    | Hulste           |      63345 |
| 12 | Ian       | Fields     | Nulla Magna Malesuada PC         | rutrum.non@condimentumDonec.co.uk      | 1-138-621-8354 | 1-369-126-7068 | P.O. Box 994, 7053 Quisque Ave  | Ostra Vetere     |      90433 |
| 13 | Xanthus   | Acosta     | Tortor Company                   | Nunc.lectus@a.org                      | 1-834-909-8838 | 1-693-411-2633 | 282-7994 Nunc Av.               | Belcarra         |      28890 |
| 14 | Sophia    | Christian  | Turpis Ltd                       | lectus.pede@non.ca                     | 1-962-503-3253 | 1-157-850-3602 | P.O. Box 824, 7971 Sagittis Rd. | Chattanooga      |      56188 |
| 15 | Dorothy   | Watson     | A Sollicitudin Orci Company      | diam.dictum@fermentum.co.uk            | 1-158-596-8622 | 1-402-884-3438 | 3348 Nec Street                 | Qu�bec City      |      63320 |
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+---------------------------------+------------------+------------+

-- Example 738
SELECT * FROM myjsontable;

-- Example 739
+-----------------------------------------------------------------+
| JSON_DATA                                                       |
|-----------------------------------------------------------------|
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864df388f1d653e37e6f",                          |
|     "address": "509 Kings Hwy, Comptche, Missouri, 4848",       |
|     "company": "ORBIN",                                         |
|     "email": "blankenship.patrick@orbin.ca",                    |
|     "name": {                                                   |
|       "first": "Blankenship",                                   |
|       "last": "Patrick"                                         |
|     },                                                          |
|     "phone": "+1 (999) 407-2274"                                |
|   }                                                             |
| }                                                               |
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864d4d8523c8baa8baf6",                          |
|     "address": "290 Lefferts Avenue, Malott, Delaware, 1575",   |
|     "company": "SNIPS",                                         |
|     "email": "anna.glass@snips.name",                           |
|     "name": {                                                   |
|       "first": "Anna",                                          |
|       "last": "Glass"                                           |
|     },                                                          |
|     "phone": "+1 (958) 411-2876"                                |
|   }                                                             |
| }                                                               |
| {                                                               |
|   "customer": {                                                 |
|     "_id": "5730864e375e08523150fc04",                          |
|     "address": "756 Randolph Street, Omar, Rhode Island, 3310", |
|     "company": "ESCHOIR",                                       |
|     "email": "sparks.ramos@eschoir.co.uk",                      |
|     "name": {                                                   |
|       "first": "Sparks",                                        |
|       "last": "Ramos"                                           |
|     },                                                          |
|     "phone": "+1 (962) 436-2519"                                |
|   }                                                             |
| }                                                               |
+-----------------------------------------------------------------+

-- Example 740
REMOVE @my_csv_stage PATTERN='.*.csv.gz';

-- Example 741
+-------------------------------+---------+
| name                          | result  |
|-------------------------------+---------|
| my_csv_stage/contacts1.csv.gz | removed |
| my_csv_stage/contacts4.csv.gz | removed |
| my_csv_stage/contacts2.csv.gz | removed |
| my_csv_stage/contacts3.csv.gz | removed |
| my_csv_stage/contacts5.csv.gz | removed |
+-------------------------------+---------+

-- Example 742
REMOVE @my_json_stage PATTERN='.*.json.gz';

-- Example 743
+--------------------------------+---------+
| name                           | result  |
|--------------------------------+---------|
| my_json_stage/contacts.json.gz | removed |
+--------------------------------+---------+

-- Example 744
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 745
ID|lastname|firstname|company|email|workphone|cellphone|streetaddress|city|postalcode
6|Reed|Moses|Neque Corporation|eget.lacus@facilisis.com|1-449-871-0780|1-454-964-5318|Ap #225-4351 Dolor Ave|Titagarh|62631

-- Example 746
[
 {
   "customer": {
     "address": "509 Kings Hwy, Comptche, Missouri, 4848",
     "phone": "+1 (999) 407-2274",
     "email": "blankenship.patrick@orbin.ca",
     "company": "ORBIN",
     "name": {
       "last": "Patrick",
       "first": "Blankenship"
     },
     "_id": "5730864df388f1d653e37e6f"
   }
 },
]

-- Example 747
CREATE OR REPLACE DATABASE mydatabase;

CREATE OR REPLACE TEMPORARY TABLE mycsvtable (
     id INTEGER,
     last_name STRING,
     first_name STRING,
     company STRING,
     email STRING,
     workphone STRING,
     cellphone STRING,
     streetaddress STRING,
     city STRING,
     postalcode STRING);

CREATE OR REPLACE TEMPORARY TABLE myjsontable (
     json_data VARIANT);

CREATE OR REPLACE WAREHOUSE mywarehouse WITH
     WAREHOUSE_SIZE='X-SMALL'
     AUTO_SUSPEND = 120
     AUTO_RESUME = TRUE
     INITIALLY_SUSPENDED=TRUE;

-- Example 748
CREATE OR REPLACE FILE FORMAT mycsvformat
   TYPE = 'CSV'
   FIELD_DELIMITER = '|'
   SKIP_HEADER = 1;

