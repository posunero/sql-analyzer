-- Example 9428
USE SCHEMA mydb.public;

CREATE STAGE my_s3_stage
  STORAGE_INTEGRATION = s3_int
  URL = 's3://bucket1/path1/'
  FILE_FORMAT = my_csv_format;

-- Example 9429
ALTER WAREHOUSE mywarehouse RESUME;

-- Example 9430
COPY INTO mytable
  FROM @my_ext_stage
  PATTERN='.*sales.*.csv';

-- Example 9431
COPY INTO mytable
  FROM s3://mybucket/data/files credentials=(AWS_KEY_ID='$AWS_ACCESS_KEY_ID' AWS_SECRET_KEY='$AWS_SECRET_ACCESS_KEY')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9432
COPY INTO mytable
  FROM s3://mybucket credentials=(AWS_KEY_ID='$AWS_ACCESS_KEY_ID' AWS_SECRET_KEY='$AWS_SECRET_ACCESS_KEY')
  FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

-- Example 9433
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 9434
ALTER WAREHOUSE mywarehouse RESUME;

-- Example 9435
COPY INTO mytable
  FROM @my_azure_stage
  PATTERN='.*sales.*.csv';

-- Example 9436
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/mycontainer/data/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=abcDEFGHIjklmNOPqrsTUVwxyZ123456789%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'aBcDeFGHI0jklMnoP0QrsTUVWXyz1234567891abcDEFG=')
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9437
COPY INTO mytable
  FROM 'azure://myaccount.blob.core.windows.net/mycontainer/data/files'
  CREDENTIALS=(AZURE_SAS_TOKEN='?sv=2016-05-31&ss=b&srt=sco&sp=rwdl&se=2018-06-27T10:05:50Z&st=2017-06-27T02:05:50Z&spr=https,http&sig=abcDEFGHIjklmNOPqrsTUVwxyZ123456789%3D')
  ENCRYPTION=(TYPE='AZURE_CSE' MASTER_KEY = 'aBcDeFGHI0jklMnoP0QrsTUVWXyz1234567891abcDEFG=')
  FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

-- Example 9438
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 9439
ALTER WAREHOUSE mywarehouse RESUME;

-- Example 9440
LIST @my_gcs_stage;

+---------------------------------------+------+----------------------------------+-------------------------------+
| name                                  | size | md5                              | last_modified                 |
|---------------------------------------+------+----------------------------------+-------------------------------|
| my_gcs_stage/load/                    |  12  | 12348f18bcb35e7b6b628ca12345678c | Mon, 11 Sep 2019 16:57:43 GMT |
| my_gcs_stage/load/data_0_0_0.csv.gz   |  147 | 9765daba007a643bdff4eae10d43218y | Mon, 11 Sep 2019 18:13:07 GMT |
+---------------------------------------+------+----------------------------------+-------------------------------+

-- Example 9441
COPY INTO mytable
  FROM @my_gcs_stage
  PATTERN='.*sales.*.csv';

-- Example 9442
COPY INTO mytable
  FROM @my_gcs_stage/mybucket/data/files
  FILE_FORMAT = (FORMAT_NAME = my_csv_format);

-- Example 9443
COPY INTO mytable
  FROM 'gcs://mybucket/data/files'
  STORAGE_INTEGRATION = myint
  FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = '|' SKIP_HEADER = 1);

-- Example 9444
COPY FILES
  INTO @trg_stage
  FROM @src_stage;

-- Example 9445
ID|lastname|firstname|company|email|workphone|cellphone|streetaddress|city|postalcode
6|Reed|Moses|Neque Corporation|eget.lacus@facilisis.com|1-449-871-0780|1-454-964-5318|Ap #225-4351 Dolor Ave|Titagarh|62631

-- Example 9446
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

-- Example 9447
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

-- Example 9448
CREATE OR REPLACE FILE FORMAT mycsvformat
   TYPE = 'CSV'
   FIELD_DELIMITER = '|'
   SKIP_HEADER = 1;

-- Example 9449
CREATE OR REPLACE FILE FORMAT myjsonformat
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Example 9450
CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat
  URL = 's3://snowflake-docs';

-- Example 9451
CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = myjsonformat
  URL = 's3://snowflake-docs';

-- Example 9452
CREATE OR REPLACE STAGE external_stage
  FILE_FORMAT = mycsvformat
  URL = 's3://private-bucket'
  STORAGE_INTEGRATION = myint;

-- Example 9453
COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/contacts1.csv
  ON_ERROR = 'skip_file';

-- Example 9454
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                    | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts1.csv | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 9455
COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/
  PATTERN='.*contacts[1-5].csv'
  ON_ERROR = 'skip_file';

-- Example 9456
+---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+
| file                                                    | status      | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                                                                                                                                                          | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts2.csv | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| s3://snowflake-docs/tutorials/dataloading/contacts3.csv | LOAD_FAILED |           5 |           0 |           1 |           2 | Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error |                3 |                     1 | "MYCSVTABLE"[11]        |
| s3://snowflake-docs/tutorials/dataloading/contacts4.csv | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| s3://snowflake-docs/tutorials/dataloading/contacts5.csv | LOADED      |           6 |           6 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+

-- Example 9457
COPY INTO myjsontable
  FROM @my_json_stage/tutorials/dataloading/contacts.json
  ON_ERROR = 'skip_file';

-- Example 9458
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                    | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts.json | LOADED |           3 |           3 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 9459
CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(mycsvtable, JOB_ID=>'<query_id>'));

-- Example 9460
SELECT * FROM SAVE_COPY_ERRORS;

-- Example 9461
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| ERROR                                                                                                                                                                | FILE                                | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |   CODE | SQL_STATE | COLUMN_NAME                   | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error | mycsvtable/contacts3.csv.gz         |    3 |         1 |         234 | parsing  | 100080 |     22000 | "MYCSVTABLE"[11]              |          1 |              2 | 11|Ishmael|Burnett|Dolor Elit Pellentesque Ltd|vitae.erat@necmollisvitae.ca|1-872|600-7301|1-513-592-6779|P.O. Box 975, 553 Odio, Road|Hulste|63345 |
| Field delimiter '|' found while expecting record delimiter '\n'                                                                                                      | mycsvtable/contacts3.csv.gz         |    5 |       125 |         625 | parsing  | 100016 |     22000 | "MYCSVTABLE"["POSTALCODE":10] |          4 |              5 | 14|Sophia|Christian|Turpis Ltd|lectus.pede@non.ca|1-962-503-3253|1-157-|850-3602|P.O. Box 824, 7971 Sagittis Rd.|Chattanooga|56188                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 9462
SELECT * FROM mycsvtable;

-- Example 9463
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+--------------------------------+------------------+------------+
| ID | LAST_NAME | FIRST_NAME | COMPANY                          | EMAIL                                  | WORKPHONE      | CELLPHONE      | STREETADDRESS                  | CITY             | POSTALCODE |
|----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+--------------------------------+------------------+------------|
|  6 | Reed      | Moses      | Neque Corporation                | eget.lacus@facilisis.com               | 1-449-871-0780 | 1-454-964-5318 | Ap #225-4351 Dolor Ave         | Titagarh         |      62631 |
|  7 | Audrey    | Franks     | Arcu Eu Limited                  | eu.dui@aceleifendvitae.org             | 1-527-945-8935 | 1-263-127-1173 | Ap #786-9241 Mauris Road       | Bergen           |      81958 |
|  8 | Jakeem    | Erickson   | A Ltd                            | Pellentesque.habitant@liberoProinmi.ca | 1-381-591-9386 | 1-379-391-9490 | 319-1703 Dis Rd.               | Pangnirtung      |      62399 |
|  9 | Xaviera   | Brennan    | Bibendum Ullamcorper Limited     | facilisi.Sed.neque@dictum.edu          | 1-260-757-1919 | 1-211-651-0925 | P.O. Box 146, 8385 Vel Road    | Béziers          |      13082 |
| 10 | Francis   | Ortega     | Vitae Velit Egestas Associates   | egestas.rhoncus.Proin@faucibus.com     | 1-257-584-6487 | 1-211-870-2111 | 733-7191 Neque Rd.             | Chatillon        |      33081 |
| 16 | Aretha    | Sykes      | Lobortis Tellus Justo Foundation | eget@Naminterdumenim.net               | 1-670-849-1866 | 1-283-783-3710 | Ap #979-2481 Dui. Av.          | Thurso           |      66851 |
| 17 | Akeem     | Casey      | Pharetra Quisque Ac Institute    | dictum.eu@magna.edu                    | 1-277-657-0361 | 1-623-630-8848 | Ap #363-6074 Ullamcorper, Rd.  | Idar-Oberstei    |      30848 |
| 18 | Keelie    | Mendez     | Purus In Foundation              | Nulla.eu.neque@Aeneanegetmetus.co.uk   | 1-330-370-8231 | 1-301-568-0413 | 3511 Tincidunt Street          | Lanklaar         |      73942 |
| 19 | Lane      | Bishop     | Libero At PC                     | non@dapibusligula.ca                   | 1-340-862-4623 | 1-513-820-9039 | 7459 Pede. Street              | Linkebeek        |      89252 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                 | Stornaway        |      61290 |
| 20 | Michelle  | Dickson    | Ut Limited                       | Duis.dignissim.tempor@cursuset.org     | 1-202-490-0151 | 1-129-553-7398 | 6752 Eros. St.                 | Stornaway        |      61290 |
| 21 | Lance     | Harper     | Rutrum Lorem Limited             | Sed.neque@risus.com                    | 1-685-778-6726 | 1-494-188-6168 | 663-7682 Et St.                | Gisborne         |      73449 |
| 22 | Keely     | Pace       | Eleifend Limited                 | ante.bibendum.ullamcorper@necenim.edu  | 1-312-381-5244 | 1-432-225-9226 | P.O. Box 506, 5233 Aliquam Av. | Woodlands County |      61213 |
| 23 | Sage      | Leblanc    | Egestas A Consulting             | dapibus@elementum.org                  | 1-630-981-0327 | 1-301-287-0495 | 4463 Lorem Road                | Woodlands County |      33951 |
| 24 | Marny     | Holt       | Urna Nec Luctus Associates       | ornare@vitaeorci.ca                    | 1-522-364-3947 | 1-460-971-8360 | P.O. Box 311, 4839 Nulla Av.   | Port Coquitlam   |      36733 |
| 25 | Holly     | Park       | Mauris PC                        | Vestibulum.ante@Maecenasliberoest.org  | 1-370-197-9316 | 1-411-413-4602 | P.O. Box 732, 8967 Eu Avenue   | Provost          |      45507 |
|  1 | Imani     | Davidson   | At Ltd                           | nec@sem.net                            | 1-243-889-8106 | 1-730-771-0412 | 369-6531 Molestie St.          | Russell          |      74398 |
|  2 | Kelsie    | Abbott     | Neque Sed Institute              | lacus@pede.net                         | 1-467-506-9933 | 1-441-508-7753 | P.O. Box 548, 1930 Pede. Road  | Campbellton      |      27022 |
|  3 | Hilel     | Durham     | Pede Incorporated                | eu@Craspellentesque.net                | 1-752-108-4210 | 1-391-449-8733 | Ap #180-2360 Nisl. Street      | Etalle           |      84025 |
|  4 | Graiden   | Molina     | Sapien Institute                 | sit@fermentum.net                      | 1-130-156-6666 | 1-269-605-7776 | 8890 A, Rd.                    | Dundee           |      70504 |
|  5 | Karyn     | Howard     | Pede Ac Industries               | sed.hendrerit@ornaretortorat.edu       | 1-109-166-5492 | 1-506-782-5089 | P.O. Box 902, 5398 Et, St.     | Saint-Hilarion   |      26232 |
+----+-----------+------------+----------------------------------+----------------------------------------+----------------+----------------+--------------------------------+------------------+------------+

-- Example 9464
SELECT * FROM myjsontable;

-- Example 9465
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

-- Example 9466
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 9467
CREATE [ OR REPLACE ] STORAGE INTEGRATION [IF NOT EXISTS]
  <name>
  TYPE = EXTERNAL_STAGE
  cloudProviderParams
  ENABLED = { TRUE | FALSE }
  STORAGE_ALLOWED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] )
  [ STORAGE_BLOCKED_LOCATIONS = ('<cloud>://<bucket>/<path>/' [ , '<cloud>://<bucket>/<path>/' ... ] ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 9468
cloudProviderParams (for Amazon S3) ::=
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = '<iam_role>'
  [ STORAGE_AWS_EXTERNAL_ID = '<external_id>' ]
  [ STORAGE_AWS_OBJECT_ACL = 'bucket-owner-full-control' ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 9469
cloudProviderParams (for Google Cloud Storage) ::=
  STORAGE_PROVIDER = 'GCS'

-- Example 9470
cloudProviderParams (for Microsoft Azure) ::=
  STORAGE_PROVIDER = 'AZURE'
  AZURE_TENANT_ID = '<tenant_id>'
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 9471
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://mybucket1/path1/', 's3://mybucket2/path2/');

-- Example 9472
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://mybucket1/path1/', 'gcs://mybucket2/path2/');

-- Example 9473
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = '<tenant_id>'
  STORAGE_ALLOWED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer/path1/', 'azure://myaccount.blob.core.windows.net/mycontainer/path2/');

-- Example 9474
CREATE STORAGE INTEGRATION s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::001234567890:role/myrole'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('s3://mybucket3/path3/', 's3://mybucket4/path4/');

-- Example 9475
CREATE STORAGE INTEGRATION gcs_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('gcs://mybucket3/path3/', 'gcs://mybucket4/path4/');

-- Example 9476
CREATE STORAGE INTEGRATION azure_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'AZURE'
  ENABLED = TRUE
  AZURE_TENANT_ID = 'a123b4c5-1234-123a-a12b-1a23b45678c9'
  STORAGE_ALLOWED_LOCATIONS = ('*')
  STORAGE_BLOCKED_LOCATIONS = ('azure://myaccount.blob.core.windows.net/mycontainer/path3/', 'azure://myaccount.blob.core.windows.net/mycontainer/path4/');

-- Example 9477
-- Internal stage
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] STAGE [ IF NOT EXISTS ] <internal_stage_name>
    internalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- External stage
CREATE [ OR REPLACE ] [ { TEMP | TEMPORARY } ] STAGE [ IF NOT EXISTS ] <external_stage_name>
    externalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]
  [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]

-- Example 9478
internalStageParams ::=
  [ ENCRYPTION = (   TYPE = 'SNOWFLAKE_FULL'
                   | TYPE = 'SNOWFLAKE_SSE' ) ]

-- Example 9479
externalStageParams (for Amazon S3) ::=
  URL = '<protocol>://<bucket>[/<path>/]'
  [ AWS_ACCESS_POINT_ARN = '<string>' ]
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } | AWS_ROLE = '<string>'  } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] MASTER_KEY = '<string>'
                   | TYPE = 'AWS_SSE_S3'
                   | TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 9480
externalStageParams (for Google Cloud Storage) ::=
  URL = 'gcs://<bucket>[/<path>/]'
  [ STORAGE_INTEGRATION = <integration_name> ]
  [ ENCRYPTION = (   TYPE = 'GCS_SSE_KMS' [ KMS_KEY_ID = '<string>' ]
                   | TYPE = 'NONE' ) ]

-- Example 9481
externalStageParams (for Microsoft Azure) ::=
  URL = 'azure://<account>.blob.core.windows.net/<container>[/<path>/]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = (   TYPE = 'AZURE_CSE' MASTER_KEY = '<string>'
                   | TYPE = 'NONE' ) ]
  [ USE_PRIVATELINK_ENDPOINT = { TRUE | FALSE } ]

-- Example 9482
externalStageParams (for Amazon S3-compatible Storage) ::=
  URL = 's3compat://{bucket}[/{path}/]'
  ENDPOINT = '<s3_api_compatible_endpoint>'
  [ { CREDENTIALS = ( AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' ) } ]

-- Example 9483
directoryTableParams (for internal stages) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 9484
directoryTableParams (for Amazon S3) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ AUTO_REFRESH = { TRUE | FALSE } ] ) ]

-- Example 9485
directoryTableParams (for Google Cloud Storage) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 9486
directoryTableParams (for Microsoft Azure) ::=
  [ DIRECTORY = ( ENABLE = { TRUE | FALSE }
                  [ REFRESH_ON_CREATE =  { TRUE | FALSE } ]
                  [ AUTO_REFRESH = { TRUE | FALSE } ]
                  [ NOTIFICATION_INTEGRATION = '<notification_integration_name>' ] ) ]

-- Example 9487
formatTypeOptions ::=
-- If TYPE = CSV
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
     FILE_EXTENSION = '<string>'
     PARSE_HEADER = TRUE | FALSE
     SKIP_HEADER = <integer>
     SKIP_BLANK_LINES = TRUE | FALSE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     ESCAPE = '<character>' | NONE
     ESCAPE_UNENCLOSED_FIELD = '<character>' | NONE
     TRIM_SPACE = TRUE | FALSE
     FIELD_OPTIONALLY_ENCLOSED_BY = '<character>' | NONE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If TYPE = JSON
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
     FILE_EXTENSION = '<string>'
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If TYPE = AVRO
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = ORC
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = PARQUET
     COMPRESSION = AUTO | LZO | SNAPPY | NONE
     SNAPPY_COMPRESSION = TRUE | FALSE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( '<string>' [ , '<string>' ... ] )
-- If TYPE = XML
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 9488
-- Internal stage
CREATE OR ALTER [ { TEMP | TEMPORARY } ] STAGE <internal_stage_name>
    internalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]

-- External stage
CREATE OR ALTER [ { TEMP | TEMPORARY } ] STAGE <external_stage_name>
    externalStageParams
    directoryTableParams
  [ FILE_FORMAT = ( { FORMAT_NAME = '<file_format_name>' | TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML | CUSTOM } [ formatTypeOptions ] } ) ]
  [ COMMENT = '<string_literal>' ]

-- Example 9489
CREATE [ OR REPLACE ] STAGE [ IF NOT EXISTS ] <name> CLONE <source_stage>
  [ ... ]

-- Example 9490
|"Hello world"|    /* loads as */  >Hello world<
|" Hello world "|  /* loads as */  > Hello world <
| "Hello world" |  /* loads as */  >Hello world<

-- Example 9491
"my_map":
  {
   "k1": "v1",
   "k2": "v2"
  }

-- Example 9492
"person":
 {
  "name": "Adam",
  "nickname": null,
  "age": 34,
  "phone_numbers":
  [
    "1234567890",
    "0987654321",
    null,
    "6781234590"
  ]
  }

-- Example 9493
"my_map":
 {
  "key_value":
  [
   {
          "key": "k1",
          "value": "v1"
      },
      {
          "key": "k2",
          "value": "v2"
      }
    ]
  }

-- Example 9494
"person":
 {
  "name": "Adam",
  "age": 34
  "phone_numbers":
  [
   "1234567890",
   "0987654321",
   "6781234590"
  ]
 }

