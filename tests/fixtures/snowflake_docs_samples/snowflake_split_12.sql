-- Example 749
CREATE OR REPLACE FILE FORMAT myjsonformat
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Example 750
CREATE OR REPLACE STAGE my_csv_stage
  FILE_FORMAT = mycsvformat
  URL = 's3://snowflake-docs';

-- Example 751
CREATE OR REPLACE STAGE my_json_stage
  FILE_FORMAT = myjsonformat
  URL = 's3://snowflake-docs';

-- Example 752
CREATE OR REPLACE STAGE external_stage
  FILE_FORMAT = mycsvformat
  URL = 's3://private-bucket'
  STORAGE_INTEGRATION = myint;

-- Example 753
COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/contacts1.csv
  ON_ERROR = 'skip_file';

-- Example 754
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                    | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts1.csv | LOADED |           5 |           5 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 755
COPY INTO mycsvtable
  FROM @my_csv_stage/tutorials/dataloading/
  PATTERN='.*contacts[1-5].csv'
  ON_ERROR = 'skip_file';

-- Example 756
+---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+
| file                                                    | status      | rows_parsed | rows_loaded | error_limit | errors_seen | first_error                                                                                                                                                          | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts2.csv | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| s3://snowflake-docs/tutorials/dataloading/contacts3.csv | LOAD_FAILED |           5 |           0 |           1 |           2 | Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error |                3 |                     1 | "MYCSVTABLE"[11]        |
| s3://snowflake-docs/tutorials/dataloading/contacts4.csv | LOADED      |           5 |           5 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
| s3://snowflake-docs/tutorials/dataloading/contacts5.csv | LOADED      |           6 |           6 |           1 |           0 | NULL                                                                                                                                                                 |             NULL |                  NULL | NULL                    |
+---------------------------------------------------------+-------------+-------------+-------------+-------------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------+-----------------------+-------------------------+

-- Example 757
COPY INTO myjsontable
  FROM @my_json_stage/tutorials/dataloading/contacts.json
  ON_ERROR = 'skip_file';

-- Example 758
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+
| file                                                    | status | rows_parsed | rows_loaded | error_limit | errors_seen | first_error | first_error_line | first_error_character | first_error_column_name |
|---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------|
| s3://snowflake-docs/tutorials/dataloading/contacts.json | LOADED |           3 |           3 |           1 |           0 |        NULL |             NULL |                  NULL |                    NULL |
+---------------------------------------------------------+--------+-------------+-------------+-------------+-------------+-------------+------------------+-----------------------+-------------------------+

-- Example 759
CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(mycsvtable, JOB_ID=>'<query_id>'));

-- Example 760
SELECT * FROM SAVE_COPY_ERRORS;

-- Example 761
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+
| ERROR                                                                                                                                                                | FILE                                | LINE | CHARACTER | BYTE_OFFSET | CATEGORY |   CODE | SQL_STATE | COLUMN_NAME                   | ROW_NUMBER | ROW_START_LINE | REJECTED_RECORD                                                                                                                                     |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Number of columns in file (11) does not match that of the corresponding table (10), use file format option error_on_column_count_mismatch=false to ignore this error | mycsvtable/contacts3.csv.gz         |    3 |         1 |         234 | parsing  | 100080 |     22000 | "MYCSVTABLE"[11]              |          1 |              2 | 11|Ishmael|Burnett|Dolor Elit Pellentesque Ltd|vitae.erat@necmollisvitae.ca|1-872|600-7301|1-513-592-6779|P.O. Box 975, 553 Odio, Road|Hulste|63345 |
| Field delimiter '|' found while expecting record delimiter '\n'                                                                                                      | mycsvtable/contacts3.csv.gz         |    5 |       125 |         625 | parsing  | 100016 |     22000 | "MYCSVTABLE"["POSTALCODE":10] |          4 |              5 | 14|Sophia|Christian|Turpis Ltd|lectus.pede@non.ca|1-962-503-3253|1-157-|850-3602|P.O. Box 824, 7971 Sagittis Rd.|Chattanooga|56188                  |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------+------+-----------+-------------+----------+--------+-----------+-------------------------------+------------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 762
SELECT * FROM mycsvtable;

-- Example 763
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

-- Example 764
SELECT * FROM myjsontable;

-- Example 765
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

-- Example 766
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 767
{
"device_type": "server",
"events": [
  {
    "f": 83,
    "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",
    "t": 1437560931139,
    "v": {
      "ACHZ": 42869,
      "ACV": 709489,
      "DCA": 232,
      "DCV": 62287,
      "ENJR": 2599,
      "ERRS": 205,
      "MXEC": 487,
      "TMPI": 9
    },
    "vd": 54,
    "z": 1437644222811
  },
  {
    "f": 1000083,
    "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22",
    "t": 1437036965027,
    "v": {
      "ACHZ": 6953,
      "ACV": 346795,
      "DCA": 250,
      "DCV": 46066,
      "ENJR": 9033,
      "ERRS": 615,
      "MXEC": 0,
      "TMPI": 112
    },
    "vd": 626,
    "z": 1437660796958
  }
],
"version": 2.6
}

-- Example 768
CREATE OR REPLACE DATABASE mydatabase;

USE SCHEMA mydatabase.public;

CREATE OR REPLACE TABLE raw_source (
  SRC VARIANT);

CREATE OR REPLACE WAREHOUSE mywarehouse WITH
  WAREHOUSE_SIZE='X-SMALL'
  AUTO_SUSPEND = 120
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED=TRUE;

USE WAREHOUSE mywarehouse;

CREATE OR REPLACE STAGE my_stage
  URL = 's3://snowflake-docs/tutorials/json';

-- Example 769
COPY INTO raw_source
  FROM @my_stage/server/2.6/2016/07/15/15
  FILE_FORMAT = (TYPE = JSON);

-- Example 770
SELECT * FROM raw_source;

-- Example 771
+-----------------------------------------------------------------------------------+
| SRC                                                                               |
|-----------------------------------------------------------------------------------|
| {                                                                                 |
|   "device_type": "server",                                                        |
|   "events": [                                                                     |
|     {                                                                             |
|       "f": 83,                                                                    |
|       "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",   |
|       "t": 1437560931139,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 42869,                                                            |
|         "ACV": 709489,                                                            |
|         "DCA": 232,                                                               |
|         "DCV": 62287,                                                             |
|         "ENJR": 2599,                                                             |
|         "ERRS": 205,                                                              |
|         "MXEC": 487,                                                              |
|         "TMPI": 9                                                                 |
|       },                                                                          |
|       "vd": 54,                                                                   |
|       "z": 1437644222811                                                          |
|     },                                                                            |
|     {                                                                             |
|       "f": 1000083,                                                               |
|       "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22", |
|       "t": 1437036965027,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 6953,                                                             |
|         "ACV": 346795,                                                            |
|         "DCA": 250,                                                               |
|         "DCV": 46066,                                                             |
|         "ENJR": 9033,                                                             |
|         "ERRS": 615,                                                              |
|         "MXEC": 0,                                                                |
|         "TMPI": 112                                                               |
|       },                                                                          |
|       "vd": 626,                                                                  |
|       "z": 1437660796958                                                          |
|     }                                                                             |
|   ],                                                                              |
|   "version": 2.6                                                                  |
| }                                                                                 |
+-----------------------------------------------------------------------------------+

-- Example 772
SELECT src:device_type
  FROM raw_source;

-- Example 773
+-----------------+
| SRC:DEVICE_TYPE |
|-----------------|
| "server"        |
+-----------------+

-- Example 774
SELECT src:device_type::string AS device_type
  FROM raw_source;

-- Example 775
+-------------+
| DEVICE_TYPE |
|-------------|
| server      |
+-------------+

-- Example 776
{
"device_type": "server",
"events": [
  {
    "f": 83,
    ..
  }
  {
    "f": 1000083,
    ..
  }
]}

-- Example 777
SELECT
  value:f::number
  FROM
    raw_source
  , LATERAL FLATTEN( INPUT => SRC:events );

-- Example 778
+-----------------+
| VALUE:F::NUMBER |
|-----------------|
|              83 |
|         1000083 |
+-----------------+

-- Example 779
SELECT src:device_type::string,
    src:version::String,
    VALUE
FROM
    raw_source,
    LATERAL FLATTEN( INPUT => SRC:events );

-- Example 780
+-------------------------+---------------------+-------------------------------------------------------------------------------+
| SRC:DEVICE_TYPE::STRING | SRC:VERSION::STRING | VALUE                                                                         |
|-------------------------+---------------------+-------------------------------------------------------------------------------|
| server                  | 2.6                 | {                                                                             |
|                         |                     |   "f": 83,                                                                    |
|                         |                     |   "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",   |
|                         |                     |   "t": 1437560931139,                                                         |
|                         |                     |   "v": {                                                                      |
|                         |                     |     "ACHZ": 42869,                                                            |
|                         |                     |     "ACV": 709489,                                                            |
|                         |                     |     "DCA": 232,                                                               |
|                         |                     |     "DCV": 62287,                                                             |
|                         |                     |     "ENJR": 2599,                                                             |
|                         |                     |     "ERRS": 205,                                                              |
|                         |                     |     "MXEC": 487,                                                              |
|                         |                     |     "TMPI": 9                                                                 |
|                         |                     |   },                                                                          |
|                         |                     |   "vd": 54,                                                                   |
|                         |                     |   "z": 1437644222811                                                          |
|                         |                     | }                                                                             |
| server                  | 2.6                 | {                                                                             |
|                         |                     |   "f": 1000083,                                                               |
|                         |                     |   "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22", |
|                         |                     |   "t": 1437036965027,                                                         |
|                         |                     |   "v": {                                                                      |
|                         |                     |     "ACHZ": 6953,                                                             |
|                         |                     |     "ACV": 346795,                                                            |
|                         |                     |     "DCA": 250,                                                               |
|                         |                     |     "DCV": 46066,                                                             |
|                         |                     |     "ENJR": 9033,                                                             |
|                         |                     |     "ERRS": 615,                                                              |
|                         |                     |     "MXEC": 0,                                                                |
|                         |                     |     "TMPI": 112                                                               |
|                         |                     |   },                                                                          |
|                         |                     |   "vd": 626,                                                                  |
|                         |                     |   "z": 1437660796958                                                          |
|                         |                     | }                                                                             |
+-------------------------+---------------------+-------------------------------------------------------------------------------+

-- Example 781
CREATE OR REPLACE TABLE flattened_source AS
  SELECT
    src:device_type::string AS device_type,
    src:version::string     AS version,
    VALUE                   AS src
  FROM
    raw_source,
    LATERAL FLATTEN( INPUT => SRC:events );

-- Example 782
SELECT * FROM flattened_source;

-- Example 783
+-------------+---------+-------------------------------------------------------------------------------+
| DEVICE_TYPE | VERSION | SRC                                                                           |
|-------------+---------+-------------------------------------------------------------------------------|
| server      | 2.6     | {                                                                             |
|             |         |   "f": 83,                                                                    |
|             |         |   "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",   |
|             |         |   "t": 1437560931139,                                                         |
|             |         |   "v": {                                                                      |
|             |         |     "ACHZ": 42869,                                                            |
|             |         |     "ACV": 709489,                                                            |
|             |         |     "DCA": 232,                                                               |
|             |         |     "DCV": 62287,                                                             |
|             |         |     "ENJR": 2599,                                                             |
|             |         |     "ERRS": 205,                                                              |
|             |         |     "MXEC": 487,                                                              |
|             |         |     "TMPI": 9                                                                 |
|             |         |   },                                                                          |
|             |         |   "vd": 54,                                                                   |
|             |         |   "z": 1437644222811                                                          |
|             |         | }                                                                             |
| server      | 2.6     | {                                                                             |
|             |         |   "f": 1000083,                                                               |
|             |         |   "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22", |
|             |         |   "t": 1437036965027,                                                         |
|             |         |   "v": {                                                                      |
|             |         |     "ACHZ": 6953,                                                             |
|             |         |     "ACV": 346795,                                                            |
|             |         |     "DCA": 250,                                                               |
|             |         |     "DCV": 46066,                                                             |
|             |         |     "ENJR": 9033,                                                             |
|             |         |     "ERRS": 615,                                                              |
|             |         |     "MXEC": 0,                                                                |
|             |         |     "TMPI": 112                                                               |
|             |         |   },                                                                          |
|             |         |   "vd": 626,                                                                  |
|             |         |   "z": 1437660796958                                                          |
|             |         | }                                                                             |
+-------------+---------+-------------------------------------------------------------------------------+

-- Example 784
create or replace table events as
  select
    src:device_type::string                             as device_type
  , src:version::string                                 as version
  , value:f::number                                     as f
  , value:rv::variant                                   as rv
  , value:t::number                                     as t
  , value:v.ACHZ::number                                as achz
  , value:v.ACV::number                                 as acv
  , value:v.DCA::number                                 as dca
  , value:v.DCV::number                                 as dcv
  , value:v.ENJR::number                                as enjr
  , value:v.ERRS::number                                as errs
  , value:v.MXEC::number                                as mxec
  , value:v.TMPI::number                                as tmpi
  , value:vd::number                                    as vd
  , value:z::number                                     as z
  from
    raw_source
  , lateral flatten ( input => SRC:events );

-- Example 785
SELECT * FROM events;

+-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------+
| DEVICE_TYPE | VERSION |       F | RV                                                                   |             T |  ACHZ |    ACV | DCA |   DCV | ENJR | ERRS | MXEC | TMPI |  VD |             Z |
|-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------|
| server      | 2.6     |      83 | "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19"   | 1437560931139 | 42869 | 709489 | 232 | 62287 | 2599 |  205 |  487 |    9 |  54 | 1437644222811 |
| server      | 2.6     | 1000083 | "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22" | 1437036965027 |  6953 | 346795 | 250 | 46066 | 9033 |  615 |    0 |  112 | 626 | 1437660796958 |
+-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------+

-- Example 786
ALTER TABLE events ADD CONSTRAINT pk_DeviceType PRIMARY KEY (device_type, rv);

-- Example 787
insert into raw_source
  select
  PARSE_JSON ('{
    "device_type": "cell_phone",
    "events": [
      {
        "f": 79,
        "rv": "786954.67,492.68,3577.48,40.11,343.00,345.8,0.22,8765.22",
        "t": 5769784730576,
        "v": {
          "ACHZ": 75846,
          "ACV": 098355,
          "DCA": 789,
          "DCV": 62287,
          "ENJR": 2234,
          "ERRS": 578,
          "MXEC": 999,
          "TMPI": 9
        },
        "vd": 54,
        "z": 1437644222811
      }
    ],
    "version": 3.2
  }');

-- Example 788
insert into events
select
      src:device_type::string
    , src:version::string
    , value:f::number
    , value:rv::variant
    , value:t::number
    , value:v.ACHZ::number
    , value:v.ACV::number
    , value:v.DCA::number
    , value:v.DCV::number
    , value:v.ENJR::number
    , value:v.ERRS::number
    , value:v.MXEC::number
    , value:v.TMPI::number
    , value:vd::number
    , value:z::number
    from
      raw_source
    , lateral flatten( input => src:events )
    where not exists
    (select 'x'
      from events
      where events.device_type = src:device_type
      and events.rv = value:rv);

-- Example 789
select * from EVENTS;

-- Example 790
+-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------+
| DEVICE_TYPE | VERSION |       F | RV                                                                   |             T |  ACHZ |    ACV | DCA |   DCV | ENJR | ERRS | MXEC | TMPI |  VD |             Z |
|-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------|
| server      | 2.6     |      83 | "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19"   | 1437560931139 | 42869 | 709489 | 232 | 62287 | 2599 |  205 |  487 |    9 |  54 | 1437644222811 |
| server      | 2.6     | 1000083 | "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22" | 1437036965027 |  6953 | 346795 | 250 | 46066 | 9033 |  615 |    0 |  112 | 626 | 1437660796958 |
| cell_phone  | 3.2     |      79 | "786954.67,492.68,3577.48,40.11,343.00,345.8,0.22,8765.22"           | 5769784730576 | 75846 |  98355 | 789 | 62287 | 2234 |  578 |  999 |    9 |  54 | 1437644222811 |
+-------------+---------+---------+----------------------------------------------------------------------+---------------+-------+--------+-----+-------+------+------+------+------+-----+---------------+

-- Example 791
insert into raw_source
  select
  parse_json ('{
    "device_type": "web_browser",
    "events": [
      {
        "f": 79,
        "rv": "122375.99,744.89,386.99,12.45,78.08,43.7,9.22,8765.43",
        "t": 5769784730576,
        "v": {
          "ACHZ": 768436,
          "ACV": 9475,
          "DCA": 94835,
          "DCV": 88845,
          "ENJR": 8754,
          "ERRS": 567,
          "MXEC": 823,
          "TMPI": 0
        },
        "vd": 55,
        "z": 8745598047355
      }
    ],
    "version": 8.7
  }');

-- Example 792
insert into events
select
      src:device_type::string
    , src:version::string
    , value:f::number
    , value:rv::variant
    , value:t::number
    , value:v.ACHZ::number
    , value:v.ACV::number
    , value:v.DCA::number
    , value:v.DCV::number
    , value:v.ENJR::number
    , value:v.ERRS::number
    , value:v.MXEC::number
    , value:v.TMPI::number
    , value:vd::number
    , value:z::number
    from
      raw_source
    , lateral flatten( input => src:events )
    where not exists
    (select 'x'
      from events
      where events.device_type = src:device_type
      and events.version = src:version
      and events.f = value:f
      and events.rv = value:rv
      and events.t = value:t
      and events.achz = value:v.ACHZ
      and events.acv = value:v.ACV
      and events.dca = value:v.DCA
      and events.dcv = value:v.DCV
      and events.enjr = value:v.ENJR
      and events.errs = value:v.ERRS
      and events.mxec = value:v.MXEC
      and events.tmpi = value:v.TMPI
      and events.vd = value:vd
      and events.z = value:z);

-- Example 793
select * from EVENTS;

-- Example 794
+-------------+---------+---------+----------------------------------------------------------------------+---------------+--------+--------+-------+-------+------+------+------+------+-----+---------------+
| DEVICE_TYPE | VERSION |       F | RV                                                                   |             T |   ACHZ |    ACV |   DCA |   DCV | ENJR | ERRS | MXEC | TMPI |  VD |             Z |
|-------------+---------+---------+----------------------------------------------------------------------+---------------+--------+--------+-------+-------+------+------+------+------+-----+---------------|
| server      | 2.6     |      83 | "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19"   | 1437560931139 |  42869 | 709489 |   232 | 62287 | 2599 |  205 |  487 |    9 |  54 | 1437644222811 |
| server      | 2.6     | 1000083 | "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22" | 1437036965027 |   6953 | 346795 |   250 | 46066 | 9033 |  615 |    0 |  112 | 626 | 1437660796958 |
| cell_phone  | 3.2     |      79 | "786954.67,492.68,3577.48,40.11,343.00,345.8,0.22,8765.22"           | 5769784730576 |  75846 |  98355 |   789 | 62287 | 2234 |  578 |  999 |    9 |  54 | 1437644222811 |
| web_browser | 8.7     |      79 | "122375.99,744.89,386.99,12.45,78.08,43.7,9.22,8765.43"              | 5769784730576 | 768436 |   9475 | 94835 | 88845 | 8754 |  567 |  823 |    0 |  55 | 8745598047355 |
+-------------+---------+---------+----------------------------------------------------------------------+---------------+--------+--------+-------+-------+------+------+------+------+-----+---------------+

-- Example 795
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 796
{
   "location": {
      "state_city": "MA-Lexington",
      "zip": "40503"
   },
   "sale_date": "2017-3-5",
   "price": "275836"
}

-- Example 797
create or replace database mydatabase;

 use schema mydatabase.public;

CREATE OR REPLACE TEMPORARY TABLE home_sales (
  city STRING,
  zip STRING,
  state STRING,
  type STRING DEFAULT 'Residential',
  sale_date timestamp_ntz,
  price STRING
  );

create or replace warehouse mywarehouse with
  warehouse_size='X-SMALL'
  auto_suspend = 120
  auto_resume = true
  initially_suspended=true;

use warehouse mywarehouse;

-- Example 798
CREATE OR REPLACE FILE FORMAT sf_tut_json_format
  TYPE = JSON;

-- Example 799
CREATE OR REPLACE TEMPORARY STAGE sf_tut_stage
 FILE_FORMAT = sf_tut_json_format;

-- Example 800
PUT file:///tmp/load/sales.json @sf_tut_stage AUTO_COMPRESS=TRUE;

-- Example 801
PUT file://C:\temp\load\sales.json @sf_tut_stage AUTO_COMPRESS=TRUE;

-- Example 802
COPY INTO home_sales(city, state, zip, sale_date, price)
   FROM (SELECT SUBSTR($1:location.state_city,4),
                SUBSTR($1:location.state_city,1,2),
                $1:location.zip,
                to_timestamp_ntz($1:sale_date),
                $1:price
         FROM @sf_tut_stage/sales.json.gz t)
   ON_ERROR = 'continue';

-- Example 803
SELECT * from home_sales;

-- Example 804
REMOVE @sf_tut_stage/sales.json.gz;

-- Example 805
DROP DATABASE IF EXISTS mydatabase;
DROP WAREHOUSE IF EXISTS mywarehouse;

-- Example 806
{
  "continent": "Europe",
  "country": {
    "city": [
      "Paris",
      "Nice",
      "Marseilles",
      "Cannes"
    ],
    "name": "France"
  }
}

-- Example 807
create or replace database mydatabase;

 use schema mydatabase.public;

  create or replace temporary table cities (
    continent varchar default null,
    country varchar default null,
    city variant default null
  );

create or replace warehouse mywarehouse with
  warehouse_size='X-SMALL'
  auto_suspend = 120
  auto_resume = true
  initially_suspended=true;

use warehouse mywarehouse;

-- Example 808
CREATE OR REPLACE FILE FORMAT sf_tut_parquet_format
  TYPE = parquet;

-- Example 809
CREATE OR REPLACE TEMPORARY STAGE sf_tut_stage
FILE_FORMAT = sf_tut_parquet_format;

-- Example 810
PUT file:///tmp/load/cities.parquet @sf_tut_stage;

-- Example 811
PUT file://C:\temp\load\cities.parquet @sf_tut_stage;

-- Example 812
copy into cities
 from (select $1:continent::varchar,
              $1:country:name::varchar,
              $1:country:city::variant
      from @sf_tut_stage/cities.parquet);

-- Example 813
SELECT * from cities;

-- Example 814
+---------------+---------+-----------------+
| CONTINENT     | COUNTRY | CITY            |
|---------------+---------+-----------------|
| Europe        | France  | [               |
|               |         |   "Paris",      |
|               |         |   "Nice",       |
|               |         |   "Marseilles", |
|               |         |   "Cannes"      |
|               |         | ]               |
|---------------+---------+-----------------|
| Europe        | Greece  | [               |
|               |         |   "Athens",     |
|               |         |   "Piraeus",    |
|               |         |   "Hania",      |
|               |         |   "Heraklion",  |
|               |         |   "Rethymnon",  |
|               |         |   "Fira"        |
|               |         | ]               |
|---------------+---------+-----------------|
| North America | Canada  | [               |
|               |         |   "Toronto",    |
|               |         |   "Vancouver",  |
|               |         |   "St. John's", |
|               |         |   "Saint John", |
|               |         |   "Montreal",   |
|               |         |   "Halifax",    |
|               |         |   "Winnipeg",   |
|               |         |   "Calgary",    |
|               |         |   "Saskatoon",  |
|               |         |   "Ottawa",     |
|               |         |   "Yellowknife" |
|               |         | ]               |
+---------------+---------+-----------------+

-- Example 815
copy into @sf_tut_stage/out/parquet_
from (select continent,
             country,
             c.value::string as city
     from cities,
          lateral flatten(input => city) c)
  file_format = (type = 'parquet')
  header = true;

-- Example 816
select t.$1 from @sf_tut_stage/out/ t;

