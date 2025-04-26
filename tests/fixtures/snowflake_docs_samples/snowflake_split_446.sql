-- Example 29854
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The Snowflake service
connection associated with the Polaris catalog integration does not have the required privileges to send notifications. The minimum
required privileges are TABLE_CREATE, TABLE_WRITE_PROPERTIES, TABLE_DROP, NAMESPACE_CREATE, and NAMESPACE_DROP.

-- Example 29855
SQL Execution Error: Failed to access the REST endpoint of catalog integration <catalog_integration_name> with error: Unable to
process: Failed to get subscoped credentials: Error assuming AWS_ROLE:
User: <IAM_user_arn> is not authorized to perform: sts:AssumeRole on resource: <S3_role_arn>. Check the accessibility of the REST
catalog URI or warehouse.

-- Example 29856
{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "",
         "Effect": "Allow",
         "Principal": {
           "AWS": [
               "arn:aws:iam::111111111111:user/----0000-s",
               "arn:aws:iam::222222222222:user/----0000-s"
            ]
         },
         "Action": "sts:AssumeRole",
         "Condition": {
           "StringEquals": {
             "sts:ExternalId": "iceberg_table_external_id"
           }
         }
       }
     ]
   }

-- Example 29857
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: The associated Polaris
catalog cannot be of type INTERNAL.

-- Example 29858
SQL Execution Error: Failed to validate CATALOG_SYNC target '<catalog_integration_name>' due to error: SQL Execution Error:
Resource on the REST endpoint of catalog integration CATINT is forbidden due to error: Forbidden: Invalid locations '[<path to metadata file>]'
for identifier '<identifier>': <path to metadata file> is not in the list of allowed locations: [<list of allowed locations>].

-- Example 29859
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

-- Example 29860
CREATE ICEBERG TABLE myGlueTable
  EXTERNAL_VOLUME='glueCatalogVolume'
  CATALOG='glueCatalogInt'
  CATALOG_TABLE_NAME='myGlueTable';

-- Example 29861
CREATE ICEBERG TABLE myIcebergTable
  EXTERNAL_VOLUME='icebergMetadataVolume'
  CATALOG='icebergCatalogInt'
  METADATA_FILE_PATH='path/to/metadata/v1.metadata.json';

-- Example 29862
CREATE ICEBERG TABLE my_delta_iceberg_table
  CATALOG = delta_catalog_integration
  EXTERNAL_VOLUME = delta_external_volume
  BASE_LOCATION = 'relative/path/from/ext/vol/';

-- Example 29863
CREATE OR REPLACE ICEBERG TABLE my_iceberg_table
  EXTERNAL_VOLUME = 'my_external_volume'
  CATALOG = 'my_rest_catalog_integration'
  CATALOG_TABLE_NAME = 'my_remote_table';

-- Example 29864
CREATE OR REPLACE CATALOG INTEGRATION open_catalog_int_vended_credentials
  CATALOG_SOURCE = POLARIS
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my-namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://myrestapi.com/polaris/api/catalog'
    CATALOG_NAME = 'my_catalog_name'
    ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_CLIENT_ID = 'my_client_id'
    OAUTH_CLIENT_SECRET = 'my_client_secret'
    OAUTH_ALLOWED_SCOPES = ('PRINCIPAL_ROLE:ALL')
  )
  ENABLED = TRUE;

-- Example 29865
CREATE OR REPLACE CATALOG INTEGRATION my_rest_catalog_integration
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://asdlkfjwoalk-execute-api.us-west-2-amazonaws.com/MyApiStage'
    ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789012:role/my_api_permissions_role'
  )
  ENABLED = TRUE;

-- Example 29866
CREATE OR REPLACE CATALOG INTEGRATION my_s3_tables_catalog_integration
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'my_namespace'
  REST_CONFIG = (
    CATALOG_URI = 'https://glue.us-west-2.amazonaws.com/iceberg'
    CATALOG_API_TYPE = AWS_GLUE
    CATALOG_NAME = '123456789012:S3tablescatalog/my_table_bucket'
    ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
  )
  REST_AUTHENTICATION = (
    TYPE = SIGV4
    SIGV4_IAM_ROLE = 'arn:aws:iam::123456789012:role/my_api_permissions_role'
  )
  ENABLED = TRUE;

-- Example 29867
CREATE ICEBERG TABLE my_iceberg_table
  CATALOG = open_catalog_int_vended_credentials
  CATALOG_TABLE_NAME = 'my_table';

-- Example 29868
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid": "AllowGlueCatalogTableAccess",
         "Effect": "Allow",
         "Action": [
            "glue:GetTable",
            "glue:GetTables"
         ],
         "Resource": [
            "arn:aws:glue:*:<accountid>:table/*/*",
            "arn:aws:glue:*:<accountid>:catalog",
            "arn:aws:glue:*:<accountid>:database/<database-name>"
         ]
      }
   ]
}

-- Example 29869
CREATE CATALOG INTEGRATION glueCatalogInt
  CATALOG_SOURCE = GLUE
  CATALOG_NAMESPACE = 'my.catalogdb'
  TABLE_FORMAT = ICEBERG
  GLUE_AWS_ROLE_ARN = 'arn:aws:iam::123456789012:role/myGlueRole'
  GLUE_CATALOG_ID = '123456789012'
  GLUE_REGION = 'us-east-2'
  ENABLED = TRUE;

-- Example 29870
DESCRIBE CATALOG INTEGRATION glueCatalogInt;

-- Example 29871
{
   "Version": "2012-10-17",
   "Statement": [
      {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
         "AWS": "<glue_iam_user_arn>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
         "StringEquals": {
            "sts:ExternalId": "<glue_aws_external_id>"
         }
      }
      }
   ]
}

-- Example 29872
<budget_name>!ADD_RESOURCE( { '<object_reference>' | <reference_statement> } )

-- Example 29873
Successfully added resource to resource group

-- Example 29874
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'APPLYBUDGET');

-- Example 29875
ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7

-- Example 29876
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  'ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7');

-- Example 29877
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  SELECT SYSTEM$REFERENCE('TABLE', 't2', 'SESSION', 'APPLYBUDGET'));

-- Example 29878
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  SELECT SYSTEM$REFERENCE('DATABASE', 'my_app', 'SESSION', 'APPLYBUDGET'));

-- Example 29879
<budget_name>!SET_EMAIL_NOTIFICATIONS( [ '<notification_integration>', ]
                                       '<email> [ , <email> [ , ... ] ]' )

-- Example 29880
The email integration is updated.

-- Example 29881
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION SNOWFLAKE;

-- Example 29882
CALL budgets_db.budgets_schema.my_budget!SET_EMAIL_NOTIFICATIONS(
   'costadmin@domain.com, budgetadmin@domain.com');

-- Example 29883
CALL snowflake.local.account_root_budget!SET_EMAIL_NOTIFICATIONS(
   'budgets_notification', 'budgetadmin@domain.com');

-- Example 29884
<budget_name>!GET_SERVICE_TYPE_USAGE( SERVICE_TYPE => '<service_type>' ,
                                      TIME_DEPART => '<time_interval>' ,
                                      USER_TIMEZONE => '<timezone>' ,
                                      TIME_LOWER_BOUND => <constant_expr> ,
                                      TIME_UPPER_BOUND => <constant_expr>
                                    )

-- Example 29885
CALL snowflake.local.account_root_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'WAREHOUSE_METERING',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => dateadd('day', -7, current_timestamp()),
   TIME_UPPER_BOUND => current_timestamp()
);

-- Example 29886
+---------+--------------+------------+------------+------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | ROWS_IN_SEQUENCE | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                5 |             1 |             3 |
+---------+--------------+------------+------------+------------------+---------------+---------------+

-- Example 29887
SELECT * FROM stock_price_history
  MATCH_RECOGNIZE(
    PARTITION BY company
    ORDER BY price_date
    MEASURES
      MATCH_NUMBER() AS match_number,
      FIRST(price_date) AS start_date,
      LAST(price_date) AS end_date,
      COUNT(*) AS rows_in_sequence,
      COUNT(row_with_price_decrease.*) AS num_decreases,
      COUNT(row_with_price_increase.*) AS num_increases
    ONE ROW PER MATCH
    AFTER MATCH SKIP TO LAST row_with_price_increase
    PATTERN(row_before_decrease row_with_price_decrease+ row_with_price_increase+)
    DEFINE
      row_with_price_decrease AS price < LAG(price),
      row_with_price_increase AS price > LAG(price)
  )
ORDER BY company, match_number;

-- Example 29888
create table stock_price_history (company TEXT, price_date DATE, price INT);

-- Example 29889
insert into stock_price_history values
    ('ABCD', '2020-10-01', 50),
    ('XYZ' , '2020-10-01', 89),
    ('ABCD', '2020-10-02', 36),
    ('XYZ' , '2020-10-02', 24),
    ('ABCD', '2020-10-03', 39),
    ('XYZ' , '2020-10-03', 37),
    ('ABCD', '2020-10-04', 42),
    ('XYZ' , '2020-10-04', 63),
    ('ABCD', '2020-10-05', 30),
    ('XYZ' , '2020-10-05', 65),
    ('ABCD', '2020-10-06', 47),
    ('XYZ' , '2020-10-06', 56),
    ('ABCD', '2020-10-07', 71),
    ('XYZ' , '2020-10-07', 50),
    ('ABCD', '2020-10-08', 80),
    ('XYZ' , '2020-10-08', 54),
    ('ABCD', '2020-10-09', 75),
    ('XYZ' , '2020-10-09', 30),
    ('ABCD', '2020-10-10', 63),
    ('XYZ' , '2020-10-10', 32);

-- Example 29890
MATCH_RECOGNIZE(
  PARTITION BY company
  ORDER BY price_date
  ...
)

-- Example 29891
.[A-Z]+[a-z]+

-- Example 29892
row_before_decrease row_with_price_decrease+ row_with_price_increase+

-- Example 29893
.[A-Z]+[a-z]+

-- Example 29894
MATCH_RECOGNIZE(
  ...
  PATTERN(row_before_decrease row_with_price_decrease+ row_with_price_increase+)
  ...
)

-- Example 29895
MATCH_RECOGNIZE(
  ...
  DEFINE
    row_with_price_decrease AS price < LAG(price)
    row_with_price_increase AS price > LAG(price)
  ...
)

-- Example 29896
MATCH_RECOGNIZE(
  ...
  ONE ROW PER MATCH
  ...
)

-- Example 29897
<expression> AS <column_name>

-- Example 29898
MATCH_RECOGNIZE(
  ...
  MEASURES
    MATCH_NUMBER() AS match_number,
    FIRST(price_date) AS start_date,
    LAST(price_date) AS end_date,
    COUNT(*) AS num_matching_rows,
    COUNT(row_with_price_decrease.*) AS num_decreases,
    COUNT(row_with_price_increase.*) AS num_increases
  ...
)

-- Example 29899
+---------+--------------+------------+------------+-------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | NUM_MATCHING_ROWS | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+-------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                 4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                 5 |             1 |             3 |
+---------+--------------+------------+------------+-------------------+---------------+---------------+

-- Example 29900
MATCH_RECOGNIZE(
  ...
  AFTER MATCH SKIP TO LAST row_with_price_increase
  ...
)

-- Example 29901
SELECT ...
    FROM stock_price_history
        MATCH_RECOGNIZE (
            PARTITION BY company
            ORDER BY price_date
            ...
        );

-- Example 29902
define
    low_priced_stock as price < 45.00,
    decreased_10_percent as lag(price) * 0.90 >= price,
    increased_05_percent as lag(price) * 1.05 <= price

-- Example 29903
pattern ( low_priced_stock  decreased_10_percent  increased_05_percent )

-- Example 29904
SELECT company, price_date, price
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           ALL ROWS PER MATCH
           PATTERN (LESS_THAN_45 DECREASED_10_PERCENT INCREASED_05_PERCENT)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               DECREASED_10_PERCENT AS LAG(price) * 0.90 >= price,
               INCREASED_05_PERCENT AS LAG(price) * 1.05 <= price
           )
    ORDER BY company, price_date;
+---------+------------+-------+
| COMPANY | PRICE_DATE | PRICE |
|---------+------------+-------|
| ABCD    | 2020-10-04 |    42 |
| ABCD    | 2020-10-05 |    30 |
| ABCD    | 2020-10-06 |    47 |
+---------+------------+-------+

-- Example 29905
symbol1+ any_symbol* symbol2

-- Example 29906
symbol1{1,limit} not_symbol1{,limit} symbol2

-- Example 29907
pattern (decreased_10_percent+ increased_05_percent+)
define
    decreased_10_percent as lag(price) * 0.90 >= price,
    increased_05_percent as lag(price) * 1.05 <= price

-- Example 29908
PATTERN (^ GT75)
DEFINE
    GT75 AS price > 75.00

-- Example 29909
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #"
           ALL ROWS PER MATCH
           PATTERN (^ GT60)
           DEFINE
               GT60 AS price > 60.00
           )
    ORDER BY "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # |
|---------+------------+-------+---------+------------------|
| XYZ     | 2020-10-01 |    89 |       1 |                1 |
+---------+------------+-------+---------+------------------+

-- Example 29910
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #"
           ALL ROWS PER MATCH
           PATTERN (GT50 $)
           DEFINE
               GT50 AS price > 50.00
           )
    ORDER BY "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # |
|---------+------------+-------+---------+------------------|
| ABCD    | 2020-10-10 |    63 |       1 |                1 |
+---------+------------+-------+---------+------------------+

-- Example 29911
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #",
               COUNT(*) AS "Num Rows In Match"
           ALL ROWS PER MATCH
           PATTERN (LESS_THAN_45 UP UP)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               UP AS price > LAG(price)
           )
    WHERE company = 'ABCD'
    ORDER BY "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+-------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # | Num Rows In Match |
|---------+------------+-------+---------+------------------+-------------------|
| ABCD    | 2020-10-02 |    36 |       1 |                1 |                 1 |
| ABCD    | 2020-10-03 |    39 |       1 |                2 |                 2 |
| ABCD    | 2020-10-04 |    42 |       1 |                3 |                 3 |
| ABCD    | 2020-10-05 |    30 |       2 |                1 |                 1 |
| ABCD    | 2020-10-06 |    47 |       2 |                2 |                 2 |
| ABCD    | 2020-10-07 |    71 |       2 |                3 |                 3 |
+---------+------------+-------+---------+------------------+-------------------+

-- As you can see, the MATCH_SEQUENCE_NUMBER isn't useful when using
-- "ONE ROW PER MATCH". But the COUNT(*), which wasn't very useful in
-- "ALL ROWS PER MATCH", is useful here.
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #",
               COUNT(*) AS "Num Rows In Match"
           ONE ROW PER MATCH
           PATTERN (LESS_THAN_45 UP UP)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               UP AS price > LAG(price)
           )
    WHERE company = 'ABCD'
    ORDER BY "Match #", "Match Sequence #";
+---------+---------+------------------+-------------------+
| COMPANY | Match # | Match Sequence # | Num Rows In Match |
|---------+---------+------------------+-------------------|
| ABCD    |       1 |                3 |                 3 |
| ABCD    |       2 |                3 |                 3 |
+---------+---------+------------------+-------------------+

-- Example 29912
SELECT company, price_date, price
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           ALL ROWS PER MATCH
           PATTERN (LESS_THAN_45 DECREASED_10_PERCENT INCREASED_05_PERCENT)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               DECREASED_10_PERCENT AS LAG(price) * 0.90 >= price,
               INCREASED_05_PERCENT AS LAG(price) * 1.05 <= price
           )
    ORDER BY price_date;
+---------+------------+-------+
| COMPANY | PRICE_DATE | PRICE |
|---------+------------+-------|
| ABCD    | 2020-10-04 |    42 |
| ABCD    | 2020-10-05 |    30 |
| ABCD    | 2020-10-06 |    47 |
+---------+------------+-------+

-- Example 29913
SELECT company, price_date, price
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           ALL ROWS PER MATCH
           PATTERN (LESS_THAN_45 {- DECREASED_10_PERCENT -} INCREASED_05_PERCENT)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               DECREASED_10_PERCENT AS LAG(price) * 0.90 >= price,
               INCREASED_05_PERCENT AS LAG(price) * 1.05 <= price
           )
    ORDER BY price_date;
+---------+------------+-------+
| COMPANY | PRICE_DATE | PRICE |
|---------+------------+-------|
| ABCD    | 2020-10-04 |    42 |
| ABCD    | 2020-10-06 |    47 |
+---------+------------+-------+

-- Example 29914
PATTERN(LESS_THAN_45 UP {- UP* -} DOWN {- DOWN* -})

-- Example 29915
SELECT company, price_date, price
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           ALL ROWS PER MATCH
           PATTERN ( LESS_THAN_45 UP UP* DOWN DOWN* )
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               UP   AS price > LAG(price),
               DOWN AS price < LAG(price)
           )
    WHERE company = 'XYZ'
    ORDER BY price_date;
+---------+------------+-------+
| COMPANY | PRICE_DATE | PRICE |
|---------+------------+-------|
| XYZ     | 2020-10-02 |    24 |
| XYZ     | 2020-10-03 |    37 |
| XYZ     | 2020-10-04 |    63 |
| XYZ     | 2020-10-05 |    65 |
| XYZ     | 2020-10-06 |    56 |
| XYZ     | 2020-10-07 |    50 |
+---------+------------+-------+

-- Example 29916
SELECT company, price_date, price
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           ALL ROWS PER MATCH
           PATTERN ( {- LESS_THAN_45 -}  UP  {- UP* -}  DOWN  {- DOWN* -} )
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               UP   AS price > LAG(price),
               DOWN AS price < LAG(price)
           )
    WHERE company = 'XYZ'
    ORDER BY price_date;
+---------+------------+-------+
| COMPANY | PRICE_DATE | PRICE |
|---------+------------+-------|
| XYZ     | 2020-10-03 |    37 |
+---------+------------+-------+

-- Example 29917
SELECT company, price_date, price,
       "Match #", "Match Sequence #", "Symbol Matched"
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #",
               CLASSIFIER AS "Symbol Matched"
           ALL ROWS PER MATCH
           PATTERN (LESS_THAN_45 DECREASED_10_PERCENT INCREASED_05_PERCENT)
           DEFINE
               LESS_THAN_45 AS price < 45.00,
               DECREASED_10_PERCENT AS LAG(price) * 0.90 >= price,
               INCREASED_05_PERCENT AS LAG(price) * 1.05 <= price
           )
    ORDER BY company, "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+----------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # | Symbol Matched       |
|---------+------------+-------+---------+------------------+----------------------|
| ABCD    | 2020-10-04 |    42 |       1 |                1 | LESS_THAN_45         |
| ABCD    | 2020-10-05 |    30 |       1 |                2 | DECREASED_10_PERCENT |
| ABCD    | 2020-10-06 |    47 |       1 |                3 | INCREASED_05_PERCENT |
+---------+------------+-------+---------+------------------+----------------------+

-- Example 29918
PATTERN (START DOWN UP)

-- Example 29919
SELECT company, price_date,
       "First(price_date)", "Lag(price_date)", "Lead(price_date)", "Last(price_date)",
       "Match#", "MatchSeq#", "Classifier"
    FROM stock_price_history
        MATCH_RECOGNIZE (
            PARTITION BY company
            ORDER BY price_date
            MEASURES
                -- Show the "edges" of the "window frame".
                FIRST(price_date) AS "First(price_date)",
                LAG(price_date) AS "Lag(price_date)",
                LEAD(price_date) AS "Lead(price_date)",
                LAST(price_date) AS "Last(price_date)",
                MATCH_NUMBER() AS "Match#",
                MATCH_SEQUENCE_NUMBER() AS "MatchSeq#",
                CLASSIFIER AS "Classifier"
            ALL ROWS PER MATCH
            AFTER MATCH SKIP TO NEXT ROW
            PATTERN (CURRENT_ROW T2 T3)
            DEFINE
                CURRENT_ROW AS TRUE,
                T2 AS TRUE,
                T3 AS TRUE
            )
    ORDER BY company, "Match#", "MatchSeq#"
    ;
+---------+------------+-------------------+-----------------+------------------+------------------+--------+-----------+-------------+
| COMPANY | PRICE_DATE | First(price_date) | Lag(price_date) | Lead(price_date) | Last(price_date) | Match# | MatchSeq# | Classifier  |
|---------+------------+-------------------+-----------------+------------------+------------------+--------+-----------+-------------|
| ABCD    | 2020-10-01 | 2020-10-01        | NULL            | 2020-10-02       | 2020-10-01       |      1 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-02 | 2020-10-01        | 2020-10-01      | 2020-10-03       | 2020-10-02       |      1 |         2 | T2          |
| ABCD    | 2020-10-03 | 2020-10-01        | 2020-10-02      | NULL             | 2020-10-03       |      1 |         3 | T3          |
| ABCD    | 2020-10-02 | 2020-10-02        | NULL            | 2020-10-03       | 2020-10-02       |      2 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-03 | 2020-10-02        | 2020-10-02      | 2020-10-04       | 2020-10-03       |      2 |         2 | T2          |
| ABCD    | 2020-10-04 | 2020-10-02        | 2020-10-03      | NULL             | 2020-10-04       |      2 |         3 | T3          |
| ABCD    | 2020-10-03 | 2020-10-03        | NULL            | 2020-10-04       | 2020-10-03       |      3 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-04 | 2020-10-03        | 2020-10-03      | 2020-10-05       | 2020-10-04       |      3 |         2 | T2          |
| ABCD    | 2020-10-05 | 2020-10-03        | 2020-10-04      | NULL             | 2020-10-05       |      3 |         3 | T3          |
| ABCD    | 2020-10-04 | 2020-10-04        | NULL            | 2020-10-05       | 2020-10-04       |      4 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-05 | 2020-10-04        | 2020-10-04      | 2020-10-06       | 2020-10-05       |      4 |         2 | T2          |
| ABCD    | 2020-10-06 | 2020-10-04        | 2020-10-05      | NULL             | 2020-10-06       |      4 |         3 | T3          |
| ABCD    | 2020-10-05 | 2020-10-05        | NULL            | 2020-10-06       | 2020-10-05       |      5 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-06 | 2020-10-05        | 2020-10-05      | 2020-10-07       | 2020-10-06       |      5 |         2 | T2          |
| ABCD    | 2020-10-07 | 2020-10-05        | 2020-10-06      | NULL             | 2020-10-07       |      5 |         3 | T3          |
| ABCD    | 2020-10-06 | 2020-10-06        | NULL            | 2020-10-07       | 2020-10-06       |      6 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-07 | 2020-10-06        | 2020-10-06      | 2020-10-08       | 2020-10-07       |      6 |         2 | T2          |
| ABCD    | 2020-10-08 | 2020-10-06        | 2020-10-07      | NULL             | 2020-10-08       |      6 |         3 | T3          |
| ABCD    | 2020-10-07 | 2020-10-07        | NULL            | 2020-10-08       | 2020-10-07       |      7 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-08 | 2020-10-07        | 2020-10-07      | 2020-10-09       | 2020-10-08       |      7 |         2 | T2          |
| ABCD    | 2020-10-09 | 2020-10-07        | 2020-10-08      | NULL             | 2020-10-09       |      7 |         3 | T3          |
| ABCD    | 2020-10-08 | 2020-10-08        | NULL            | 2020-10-09       | 2020-10-08       |      8 |         1 | CURRENT_ROW |
| ABCD    | 2020-10-09 | 2020-10-08        | 2020-10-08      | 2020-10-10       | 2020-10-09       |      8 |         2 | T2          |
| ABCD    | 2020-10-10 | 2020-10-08        | 2020-10-09      | NULL             | 2020-10-10       |      8 |         3 | T3          |
| XYZ     | 2020-10-01 | 2020-10-01        | NULL            | 2020-10-02       | 2020-10-01       |      1 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-02 | 2020-10-01        | 2020-10-01      | 2020-10-03       | 2020-10-02       |      1 |         2 | T2          |
| XYZ     | 2020-10-03 | 2020-10-01        | 2020-10-02      | NULL             | 2020-10-03       |      1 |         3 | T3          |
| XYZ     | 2020-10-02 | 2020-10-02        | NULL            | 2020-10-03       | 2020-10-02       |      2 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-03 | 2020-10-02        | 2020-10-02      | 2020-10-04       | 2020-10-03       |      2 |         2 | T2          |
| XYZ     | 2020-10-04 | 2020-10-02        | 2020-10-03      | NULL             | 2020-10-04       |      2 |         3 | T3          |
| XYZ     | 2020-10-03 | 2020-10-03        | NULL            | 2020-10-04       | 2020-10-03       |      3 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-04 | 2020-10-03        | 2020-10-03      | 2020-10-05       | 2020-10-04       |      3 |         2 | T2          |
| XYZ     | 2020-10-05 | 2020-10-03        | 2020-10-04      | NULL             | 2020-10-05       |      3 |         3 | T3          |
| XYZ     | 2020-10-04 | 2020-10-04        | NULL            | 2020-10-05       | 2020-10-04       |      4 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-05 | 2020-10-04        | 2020-10-04      | 2020-10-06       | 2020-10-05       |      4 |         2 | T2          |
| XYZ     | 2020-10-06 | 2020-10-04        | 2020-10-05      | NULL             | 2020-10-06       |      4 |         3 | T3          |
| XYZ     | 2020-10-05 | 2020-10-05        | NULL            | 2020-10-06       | 2020-10-05       |      5 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-06 | 2020-10-05        | 2020-10-05      | 2020-10-07       | 2020-10-06       |      5 |         2 | T2          |
| XYZ     | 2020-10-07 | 2020-10-05        | 2020-10-06      | NULL             | 2020-10-07       |      5 |         3 | T3          |
| XYZ     | 2020-10-06 | 2020-10-06        | NULL            | 2020-10-07       | 2020-10-06       |      6 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-07 | 2020-10-06        | 2020-10-06      | 2020-10-08       | 2020-10-07       |      6 |         2 | T2          |
| XYZ     | 2020-10-08 | 2020-10-06        | 2020-10-07      | NULL             | 2020-10-08       |      6 |         3 | T3          |
| XYZ     | 2020-10-07 | 2020-10-07        | NULL            | 2020-10-08       | 2020-10-07       |      7 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-08 | 2020-10-07        | 2020-10-07      | 2020-10-09       | 2020-10-08       |      7 |         2 | T2          |
| XYZ     | 2020-10-09 | 2020-10-07        | 2020-10-08      | NULL             | 2020-10-09       |      7 |         3 | T3          |
| XYZ     | 2020-10-08 | 2020-10-08        | NULL            | 2020-10-09       | 2020-10-08       |      8 |         1 | CURRENT_ROW |
| XYZ     | 2020-10-09 | 2020-10-08        | 2020-10-08      | 2020-10-10       | 2020-10-09       |      8 |         2 | T2          |
| XYZ     | 2020-10-10 | 2020-10-08        | 2020-10-09      | NULL             | 2020-10-10       |      8 |         3 | T3          |
+---------+------------+-------------------+-----------------+------------------+------------------+--------+-----------+-------------+

-- Example 29920
Month  | Price | Price Relative to Previous Day
=======|=======|===============================
     1 |   200 |
     2 |   100 | down
     3 |   200 | up
     4 |   100 | down
     5 |   200 | up
     6 |   100 | down
     7 |   200 | up
     8 |   100 | down
     9 |   200 | up

