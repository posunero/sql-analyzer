-- Example 7619
SELECT 
  TRY_TO_DATE('2024-05-10') AS valid_date, 
  TRY_TO_DATE('Invalid') AS invalid_date;

-- Example 7620
+------------+--------------+
| VALID_DATE | INVALID_DATE |
|------------+--------------|
| 2024-05-10 | NULL         |
+------------+--------------+

-- Example 7621
TRY_TO_DECIMAL( <string_expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

TRY_TO_NUMBER( <string_expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

TRY_TO_NUMERIC( <string_expr> [, '<format>' ] [, <precision> [, <scale> ] ] )

-- Example 7622
SELECT column1 AS orig_string,
       TO_DECIMAL(column1) AS dec,
       TO_DECIMAL(column1, 10, 2) AS dec_with_scale,
       TO_DECIMAL(column1, 4, 2) AS dec_with_range_err
  FROM VALUES ('345.123');

-- Example 7623
100039 (22003): Numeric value '345.123' is out of range

-- Example 7624
SELECT column1 AS orig_string,
       TRY_TO_DECIMAL(column1) AS dec,
       TRY_TO_DECIMAL(column1, 10, 2) AS dec_with_scale,
       TRY_TO_DECIMAL(column1, 4, 2) AS dec_with_range_err
  FROM VALUES ('345.123');

-- Example 7625
+-------------+-----+----------------+--------------------+
| ORIG_STRING | DEC | DEC_WITH_SCALE | DEC_WITH_RANGE_ERR |
|-------------+-----+----------------+--------------------|
| 345.123     | 345 |         345.12 |               NULL |
+-------------+-----+----------------+--------------------+

-- Example 7626
SELECT column1 AS orig_string,
       TO_DECIMAL(column1, '$9,999.00') AS num,
       TO_DECIMAL(column1, '$9,999.00', 6, 2) AS num_with_scale,
       TO_DECIMAL(column1, 6, 2) AS num_with_format_err
  FROM VALUES ('$7,543.21');

-- Example 7627
100038 (22018): Numeric value '$7,543.21' is not recognized

-- Example 7628
SELECT column1 AS orig_string,
       TRY_TO_DECIMAL(column1, '$9,999.00') AS num,
       TRY_TO_DECIMAL(column1, '$9,999.00', 6, 2) AS num_with_scale,
       TRY_TO_DECIMAL(column1, 6, 2) AS num_with_format_err
  FROM VALUES ('$7,543.21');

-- Example 7629
+-------------+------+----------------+---------------------+
| ORIG_STRING |  NUM | NUM_WITH_SCALE | NUM_WITH_FORMAT_ERR |
|-------------+------+----------------+---------------------|
| $7,543.21   | 7543 |        7543.21 |                NULL |
+-------------+------+----------------+---------------------+

-- Example 7630
TRY_TO_DOUBLE( <string_expr> [, '<format>' ] )

-- Example 7631
SELECT TRY_TO_DOUBLE('3.1415926'), TRY_TO_DOUBLE('Invalid');

-- Example 7632
+----------------------------+--------------------------+
| TRY_TO_DOUBLE('3.1415926') | TRY_TO_DOUBLE('INVALID') |
|----------------------------+--------------------------|
|                  3.1415926 |                     NULL |
+----------------------------+--------------------------+

-- Example 7633
TRY_TO_FILE( <stage_name>, <relative_path> )

TRY_TO_FILE( <file_url> )

TRY_TO_FILE( <metadata> )

-- Example 7634
TRY_TO_GEOGRAPHY( <varchar_expression> [ , <allow_invalid> ] )

TRY_TO_GEOGRAPHY( <binary_expression> [ , <allow_invalid> ] )

TRY_TO_GEOGRAPHY( <variant_expression> [ , <allow_invalid> ] )

-- Example 7635
select TRY_TO_GEOGRAPHY('Not a valid input for this data type.');
+-----------------------------------------------------------+
| TRY_TO_GEOGRAPHY('NOT A VALID INPUT FOR THIS DATA TYPE.') |
|-----------------------------------------------------------|
| NULL                                                      |
+-----------------------------------------------------------+

-- Example 7636
TRY_TO_GEOMETRY( <varchar_expression> [ , <srid> ] [ , <allow_invalid> ] )

TRY_TO_GEOMETRY( <binary_expression> [ , <srid> ] [ , <allow_invalid> ] )

TRY_TO_GEOMETRY( <variant_expression> [ , <srid> ] [ , <allow_invalid> ] )

-- Example 7637
select try_to_geometry('INVALID INPUT');

-- Example 7638
+--------------------------------------+
| try_to_geometry('INVALID INPUT')     |
|--------------------------------------|
| NULL                                 |
+--------------------------------------+

-- Example 7639
TRY_TO_TIME( <string_expr> [, <format> ] )
TRY_TO_TIME( '<integer>' )

-- Example 7640
SELECT TRY_TO_TIME('12:30:00'), TRY_TO_TIME('Invalid');

-- Example 7641
+-------------------------+------------------------+
| TRY_TO_TIME('12:30:00') | TRY_TO_TIME('INVALID') |
|-------------------------+------------------------|
| 12:30:00                | NULL                   |
+-------------------------+------------------------+

-- Example 7642
timestampFunction ( <string_expr> [, <format> ] )
timestampFunction ( '<integer>' )

-- Example 7643
timestampFunction ::=
    TRY_TO_TIMESTAMP | TRY_TO_TIMESTAMP_LTZ | TRY_TO_TIMESTAMP_NTZ | TRY_TO_TIMESTAMP_TZ

-- Example 7644
SELECT TRY_TO_TIMESTAMP('2024-01-15 12:30:00'), TRY_TO_TIMESTAMP('Invalid');

-- Example 7645
+-----------------------------------------+-----------------------------+
| TRY_TO_TIMESTAMP('2024-01-15 12:30:00') | TRY_TO_TIMESTAMP('INVALID') |
|-----------------------------------------+-----------------------------|
| 2024-01-15 12:30:00.000                 | NULL                        |
+-----------------------------------------+-----------------------------+

-- Example 7646
TYPEOF( <expr> )

-- Example 7647
CREATE OR REPLACE TABLE vartab (n NUMBER(2), v VARIANT);

INSERT INTO vartab
  SELECT column1 AS n, PARSE_JSON(column2) AS v
    FROM VALUES (1, 'null'), 
                (2, null), 
                (3, 'true'),
                (4, '-17'), 
                (5, '123.12'), 
                (6, '1.912e2'),
                (7, '"Om ara pa ca na dhih"  '), 
                (8, '[-1, 12, 289, 2188, false,]'), 
                (9, '{ "x" : "abc", "y" : false, "z": 10} ') 
       AS vals;

-- Example 7648
SELECT n, v, TYPEOF(v)
  FROM vartab
  ORDER BY n;

-- Example 7649
+---+------------------------+------------+
| N | V                      | TYPEOF(V)  |
|---+------------------------+------------|
| 1 | null                   | NULL_VALUE |
| 2 | NULL                   | NULL       |
| 3 | true                   | BOOLEAN    |
| 4 | -17                    | INTEGER    |
| 5 | 123.12                 | DECIMAL    |
| 6 | 1.912000000000000e+02  | DOUBLE     |
| 7 | "Om ara pa ca na dhih" | VARCHAR    |
| 8 | [                      | ARRAY      |
|   |   -1,                  |            |
|   |   12,                  |            |
|   |   289,                 |            |
|   |   2188,                |            |
|   |   false,               |            |
|   |   undefined            |            |
|   | ]                      |            |
| 9 | {                      | OBJECT     |
|   |   "x": "abc",          |            |
|   |   "y": false,          |            |
|   |   "z": 10              |            |
|   | }                      |            |
+---+------------------------+------------+

-- Example 7650
CREATE OR REPLACE TABLE typeof_cast(status VARCHAR, time TIMESTAMP);

INSERT INTO typeof_cast VALUES('check in', '2024-01-17 19:00:00.000 -0800');

-- Example 7651
SELECT status,
       TYPEOF(status::VARIANT) AS "TYPE OF STATUS",
       time,
       TYPEOF(time::VARIANT) AS "TYPE OF TIME"
  FROM typeof_cast;

-- Example 7652
+----------+----------------+-------------------------+---------------+
| STATUS   | TYPE OF STATUS | TIME                    | TYPE OF TIME  |
|----------+----------------+-------------------------+---------------|
| check in | VARCHAR        | 2024-01-17 19:00:00.000 | TIMESTAMP_NTZ |
+----------+----------------+-------------------------+---------------+

-- Example 7653
UNICODE( <input> )

-- Example 7654
SELECT column1, UNICODE(column1), CHAR(UNICODE(column1))
FROM values('a'), ('\u2744'), ('cde'), (''), (null);

+---------+------------------+------------------------+
| COLUMN1 | UNICODE(COLUMN1) | CHAR(UNICODE(COLUMN1)) |
|---------+------------------+------------------------|
| a       |               97 | a                      |
| ❄       |            10052 | ❄                      |
| cde     |               99 | c                      |
|         |                0 |                        |
| NULL    |             NULL | NULL                   |
+---------+------------------+------------------------+

-- Example 7655
UNIFORM( <min> , <max> , <gen> )

-- Example 7656
SELECT UNIFORM(1, 10, RANDOM()) FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- Example 7657
+--------------------------+
| UNIFORM(1, 10, RANDOM()) |
|--------------------------|
|                        6 |
|                        1 |
|                        8 |
|                        5 |
|                        6 |
+--------------------------+

-- Example 7658
SELECT UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- Example 7659
+---------------------------------------+
| UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) |
|---------------------------------------|
|                         0.1180758313  |
|                         0.4945805484  |
|                         0.7113092833  |
|                         0.06170806767 |
|                         0.01635235156 |
+---------------------------------------+

-- Example 7660
SELECT UNIFORM(1, 10, 1234) FROM TABLE(GENERATOR(ROWCOUNT => 5));

-- Example 7661
+----------------------+
| UNIFORM(1, 10, 1234) |
|----------------------|
|                    7 |
|                    7 |
|                    7 |
|                    7 |
|                    7 |
+----------------------+

-- Example 7662
UPPER( <expr> )

-- Example 7663
SELECT v, UPPER(v) FROM lu;

-- Example 7664
+----------------------------------+----------------------------------+
|                v                 |             upper(v)             |
+----------------------------------+----------------------------------+
|                                  |                                  |
| 1č2Щ3ß4Ę!-?abc@                  | 1Č2Щ3SS4Ę!-?ABC@                 |
| AaBbCcDdEeFfGgHhIiJj             | AABBCCDDEEFFGGHHIIJJ             |
| KkLlMmNnOoPpQqRrSsTt             | KKLLMMNNOOPPQQRRSSTT             |
| UuVvWwXxYyZz                     | UUVVWWXXYYZZ                     |
| ÁáÄäÉéÍíÓóÔôÚúÝý                 | ÁÁÄÄÉÉÍÍÓÓÔÔÚÚÝÝ                 |
| ÄäÖößÜü                          | ÄÄÖÖSSÜÜ                         |
| ÉéÀàÈèÙùÂâÊêÎîÔôÛûËëÏïÜüŸÿÇçŒœÆæ | ÉÉÀÀÈÈÙÙÂÂÊÊÎÎÔÔÛÛËËÏÏÜÜŸŸÇÇŒŒÆÆ |
| ĄąĆćĘęŁłŃńÓóŚśŹźŻż               | ĄĄĆĆĘĘŁŁŃŃÓÓŚŚŹŹŻŻ               |
| ČčĎďĹĺĽľŇňŔŕŠšŤťŽž               | ČČĎĎĹĹĽĽŇŇŔŔŠŠŤŤŽŽ               |
| АаБбВвГгДдЕеЁёЖжЗзИиЙй           | ААББВВГГДДЕЕЁЁЖЖЗЗИИЙЙ           |
| КкЛлМмНнОоПпРрСсТтУуФф           | ККЛЛММННООППРРССТТУУФФ           |
| ХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя           | ХХЦЦЧЧШШЩЩЪЪЫЫЬЬЭЭЮЮЯЯ           |
| [NULL]                           | [NULL]                           |
+----------------------------------+----------------------------------+

-- Example 7665
SELECT UPPER('i' COLLATE 'tr');

-- Example 7666
+-------------------------+
| UPPER('I' COLLATE 'TR') |
|-------------------------|
| İ                       |
+-------------------------+

-- Example 7667
UUID_STRING()

UUID_STRING( '<uuid>' , '<name>' )

-- Example 7668
SELECT UUID_STRING();

-- Example 7669
+--------------------------------------+
| UUID_STRING()                        |
|--------------------------------------|
| d47f4e30-306f-4940-8921-c154094df1a1 |
+--------------------------------------+

-- Example 7670
SELECT UUID_STRING('fe971b24-9572-4005-b22f-351e9c09274d','foo');

-- Example 7671
+-----------------------------------------------------------+
| UUID_STRING('FE971B24-9572-4005-B22F-351E9C09274D','FOO') |
|-----------------------------------------------------------|
| dc0b6f65-fca6-5b4b-9d37-ccc3fde1f3e2                      |
+-----------------------------------------------------------+

-- Example 7672
CREATE OR REPLACE TABLE uuid_insert_test(random_uuid VARCHAR(36), test VARCHAR(10));

INSERT INTO uuid_insert_test (random_uuid, test) SELECT UUID_STRING(), 'test1';
INSERT INTO uuid_insert_test (random_uuid, test) SELECT UUID_STRING(), 'test2';
INSERT INTO uuid_insert_test (random_uuid, test) SELECT UUID_STRING(), 'test3';
INSERT INTO uuid_insert_test (random_uuid, test) SELECT UUID_STRING(), 'test4';
INSERT INTO uuid_insert_test (random_uuid, test) SELECT UUID_STRING(), 'test5';

SELECT * FROM uuid_insert_test;

-- Example 7673
+--------------------------------------+-------+
| RANDOM_UUID                          | TEST  |
|--------------------------------------+-------|
| 7745a0cf-d136-406b-9289-38072d242871 | test1 |
| 8c31e031-a6bf-479d-9abb-b7909f298ba1 | test2 |
| e65d5641-01c0-4126-b80d-c5ae6d4848be | test3 |
| bd02bf4e-fa5d-498d-8a9a-d38200f1ca30 | test4 |
| 4df2a34e-ad65-46b4-a51a-3eb9394aeb83 | test5 |
+--------------------------------------+-------+

-- Example 7674
VALIDATE( [<namespace>.]<table_name> , JOB_ID => { '<query_id>' | '_last' } )

-- Example 7675
SELECT * FROM TABLE(VALIDATE(t1, JOB_ID => '_last'));

-- Example 7676
SELECT * FROM TABLE(VALIDATE(t1, JOB_ID=>'5415fa1e-59c9-4dda-b652-533de02fdcf1'));

-- Example 7677
CREATE OR REPLACE TABLE save_copy_errors AS SELECT * FROM TABLE(VALIDATE(t1, JOB_ID=>'5415fa1e-59c9-4dda-b652-533de02fdcf1'));

-- Example 7678
/* Standard data load */
COPY INTO [<namespace>.]<table_name>
     FROM { internalStage | externalStage | externalLocation }
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
                    TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
[ copyOptions ]
[ VALIDATION_MODE = RETURN_<n>_ROWS | RETURN_ERRORS | RETURN_ALL_ERRORS ]

/* Data load with transformation */
COPY INTO [<namespace>.]<table_name> [ ( <col_name> [ , <col_name> ... ] ) ]
     FROM ( SELECT [<alias>.]$<file_col_num>[.<element>] [ , [<alias>.]$<file_col_num>[.<element>] ... ]
            FROM { internalStage | externalStage } )
[ FILES = ( '<file_name>' [ , '<file_name>' ] [ , ... ] ) ]
[ PATTERN = '<regex_pattern>' ]
[ FILE_FORMAT = ( { FORMAT_NAME = '[<namespace>.]<file_format_name>' |
                    TYPE = { CSV | JSON | AVRO | ORC | PARQUET | XML } [ formatTypeOptions ] } ) ]
[ copyOptions ]

-- Example 7679
internalStage ::=
    @[<namespace>.]<int_stage_name>[/<path>]
  | @[<namespace>.]%<table_name>[/<path>]
  | @~[/<path>]

-- Example 7680
externalStage ::=
  @[<namespace>.]<ext_stage_name>[/<path>]

-- Example 7681
externalLocation (for Amazon S3) ::=
  '<protocol>://<bucket>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( {  { AWS_KEY_ID = '<string>' AWS_SECRET_KEY = '<string>' [ AWS_TOKEN = '<string>' ] } } ) } ]
  [ ENCRYPTION = ( [ TYPE = 'AWS_CSE' ] [ MASTER_KEY = '<string>' ] |
                   [ TYPE = 'AWS_SSE_S3' ] |
                   [ TYPE = 'AWS_SSE_KMS' [ KMS_KEY_ID = '<string>' ] ] |
                   [ TYPE = 'NONE' ] ) ]

-- Example 7682
externalLocation (for Google Cloud Storage) ::=
  'gcs://<bucket>[/<path>]'
  [ STORAGE_INTEGRATION = <integration_name> ]
  [ ENCRYPTION = ( [ TYPE = 'GCS_SSE_KMS' ] [ KMS_KEY_ID = '<string>' ] | [ TYPE = 'NONE' ] ) ]

-- Example 7683
externalLocation (for Microsoft Azure) ::=
  'azure://<account>.blob.core.windows.net/<container>[/<path>]'
  [ { STORAGE_INTEGRATION = <integration_name> } | { CREDENTIALS = ( [ AZURE_SAS_TOKEN = '<string>' ] ) } ]
  [ ENCRYPTION = ( [ TYPE = { 'AZURE_CSE' | 'NONE' } ] [ MASTER_KEY = '<string>' ] ) ]

-- Example 7684
formatTypeOptions ::=
-- If FILE_FORMAT = ( TYPE = CSV ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     RECORD_DELIMITER = '<string>' | NONE
     FIELD_DELIMITER = '<string>' | NONE
     MULTI_LINE = TRUE | FALSE
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
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
     ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     EMPTY_FIELD_AS_NULL = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
     ENCODING = '<string>' | UTF8
-- If FILE_FORMAT = ( TYPE = JSON ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     DATE_FORMAT = '<string>' | AUTO
     TIME_FORMAT = '<string>' | AUTO
     TIMESTAMP_FORMAT = '<string>' | AUTO
     BINARY_FORMAT = HEX | BASE64 | UTF8
     TRIM_SPACE = TRUE | FALSE
     MULTI_LINE = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
     ENABLE_OCTAL = TRUE | FALSE
     ALLOW_DUPLICATE = TRUE | FALSE
     STRIP_OUTER_ARRAY = TRUE | FALSE
     STRIP_NULL_VALUES = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE
-- If FILE_FORMAT = ( TYPE = AVRO ... )
     COMPRESSION = AUTO | GZIP | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = ORC ... )
     TRIM_SPACE = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = PARQUET ... )
     COMPRESSION = AUTO | SNAPPY | NONE
     BINARY_AS_TEXT = TRUE | FALSE
     USE_LOGICAL_TYPE = TRUE | FALSE
     TRIM_SPACE = TRUE | FALSE
     USE_VECTORIZED_SCANNER = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     NULL_IF = ( [ '<string>' [ , '<string>' ... ] ] )
-- If FILE_FORMAT = ( TYPE = XML ... )
     COMPRESSION = AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
     IGNORE_UTF8_ERRORS = TRUE | FALSE
     PRESERVE_SPACE = TRUE | FALSE
     STRIP_OUTER_ELEMENT = TRUE | FALSE
     DISABLE_AUTO_CONVERT = TRUE | FALSE
     REPLACE_INVALID_CHARACTERS = TRUE | FALSE
     SKIP_BYTE_ORDER_MARK = TRUE | FALSE

-- Example 7685
copyOptions ::=
     ON_ERROR = { CONTINUE | SKIP_FILE | SKIP_FILE_<num> | 'SKIP_FILE_<num>%' | ABORT_STATEMENT }
     SIZE_LIMIT = <num>
     PURGE = TRUE | FALSE
     RETURN_FAILED_ONLY = TRUE | FALSE
     MATCH_BY_COLUMN_NAME = CASE_SENSITIVE | CASE_INSENSITIVE | NONE
     INCLUDE_METADATA = ( <column_name> = METADATA$<field> [ , <column_name> = METADATA${field} ... ] )
     ENFORCE_LENGTH = TRUE | FALSE
     TRUNCATECOLUMNS = TRUE | FALSE
     FORCE = TRUE | FALSE
     LOAD_UNCERTAIN_FILES = TRUE | FALSE
     FILE_PROCESSOR = (SCANNER = <custom_scanner_type> SCANNER_OPTIONS = (<scanner_options>))
     LOAD_MODE = { FULL_INGEST | ADD_FILES_COPY }

