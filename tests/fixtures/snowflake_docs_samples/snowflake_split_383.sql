-- Example 25636
SELECT index, value AS project_name
  FROM TABLE(FLATTEN(INPUT => ARRAY_CONSTRUCT('project1', 'project2')));

-- Example 25637
+-------+--------------+
| INDEX | PROJECT_NAME |
|-------+--------------|
|     0 | "project1"   |
|     1 | "project2"   |
+-------+--------------+

-- Example 25638
SELECT * FROM table1, LATERAL FLATTEN(...);

-- Example 25639
SELECT emp.employee_ID, emp.last_name, index, value AS project_name
  FROM employees AS emp,
    LATERAL FLATTEN(INPUT => emp.project_names) AS proj_names
  ORDER BY employee_ID;

-- Example 25640
+-------------+-----------+-------+----------------------+
| EMPLOYEE_ID | LAST_NAME | INDEX | PROJECT_NAME         |
|-------------+-----------+-------+----------------------|
|         101 | Richards  |     0 | "Materialized Views" |
|         101 | Richards  |     1 | "UDFs"               |
|         102 | Paulson   |     0 | "Materialized Views" |
|         102 | Paulson   |     1 | "Lateral Joins"      |
+-------------+-----------+-------+----------------------+

-- Example 25641
CREATE OR REPLACE TABLE test_table (id INT, c1 INT, c2 STRING, c3 DATE) AS
  SELECT * FROM VALUES
    (1, 3, '4',  '1985-05-11'),
    (2, 4, '3',  '1996-12-20'),
    (3, 2, '1',  '1974-02-03'),
    (4, 1, '2',  '2004-03-09'),
    (5, NULL, NULL, NULL);

-- Example 25642
ALTER TABLE test_table ADD SEARCH OPTIMIZATION;

-- Example 25643
SELECT * FROM test_table WHERE id = 2;

-- Example 25644
SELECT * FROM test_table WHERE c2 = '1';

-- Example 25645
SELECT * FROM test_table WHERE c3 = '1985-05-11';

-- Example 25646
SELECT * FROM test_table WHERE c1 IS NULL;

-- Example 25647
SELECT * FROM test_table WHERE c1 = 4 AND c3 = '1996-12-20';

-- Example 25648
SELECT * FROM test_table WHERE c2 = 2;

-- Example 25649
SELECT * FROM test_table WHERE CAST(c2 AS NUMBER) = 2;

-- Example 25650
SELECT id, c1, c2, c3
  FROM test_table
  WHERE id IN (2, 3)
  ORDER BY id;

-- Example 25651
SELECT id, c1, c2, c3
  FROM test_table
  WHERE c1 = 1
    AND c3 = TO_DATE('2004-03-09')
  ORDER BY id;

-- Example 25652
DELETE FROM test_table WHERE id = 3;

-- Example 25653
UPDATE test_table SET c1 = 99 WHERE id = 4;

-- Example 25654
MATCH_RECOGNIZE (
    [ PARTITION BY <expr> [, ... ] ]
    [ ORDER BY <expr> [, ... ] ]
    [ MEASURES <expr> [AS] <alias> [, ... ] ]
    [ ONE ROW PER MATCH |
      ALL ROWS PER MATCH [ { SHOW EMPTY MATCHES | OMIT EMPTY MATCHES | WITH UNMATCHED ROWS } ]
      ]
    [ AFTER MATCH SKIP
          {
          PAST LAST ROW   |
          TO NEXT ROW   |
          TO [ { FIRST | LAST} ] <symbol>
          }
      ]
    PATTERN ( <pattern> )
    DEFINE <symbol> AS <expr> [, ... ]
)

-- Example 25655
DEFINE <symbol1> AS <expr1> [ , <symbol2> AS <expr2> ]

-- Example 25656
...
define
    my_example_symbol as true
...

-- Example 25657
PATTERN ( <pattern> )

-- Example 25658
PATTERN (S1 S2)

-- Example 25659
^ S1 S2*? ( {- S3 -} S4 )+ | PERMUTE(S1, S2){1,2} $

-- Example 25660
symbol1+ any_symbol* symbol2

-- Example 25661
symbol1{1,limit} not_symbol1{,limit} symbol2

-- Example 25662
orderItem ::= { <column_alias> | <expr> } [ ASC | DESC ] [ NULLS { FIRST | LAST } ]

-- Example 25663
MEASURES <expr1> [AS] <alias1> [ ... , <exprN> [AS] <aliasN> ]

-- Example 25664
{
  ONE ROW PER MATCH  |
  ALL ROWS PER MATCH [ { SHOW EMPTY MATCHES | OMIT EMPTY MATCHES | WITH UNMATCHED ROWS } ]
}

-- Example 25665
AFTER MATCH SKIP
{
    PAST LAST ROW   |
    TO NEXT ROW   |
    TO [ { FIRST | LAST} ] <symbol>
}

-- Example 25666
expr ::= ... [ { RUNNING | FINAL } ] windowFunction ...

-- Example 25667
predicatedColumnReference ::= <symbol>.<column>

-- Example 25668
create table stock_price_history (company TEXT, price_date DATE, price INT);

-- Example 25669
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

-- Example 25670
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
+---------+--------------+------------+------------+------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | ROWS_IN_SEQUENCE | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                5 |             1 |             3 |
| XYZ     |            1 | 2020-10-01 | 2020-10-05 |                5 |             1 |             3 |
| XYZ     |            2 | 2020-10-05 | 2020-10-08 |                4 |             2 |             1 |
| XYZ     |            3 | 2020-10-08 | 2020-10-10 |                3 |             1 |             1 |
+---------+--------------+------------+------------+------------------+---------------+---------------+

-- Example 25671
select price_date, match_number, msq, price, cl from
  (select * from stock_price_history where company='ABCD') match_recognize(
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        match_sequence_number() as msq,
        classifier() as cl
    all rows per match
    pattern(ANY_ROW UP+)
    define
        ANY_ROW AS TRUE,
        UP as price > lag(price)
)
order by match_number, msq;
+------------+--------------+-----+-------+---------+
| PRICE_DATE | MATCH_NUMBER | MSQ | PRICE | CL      |
|------------+--------------+-----+-------+---------|
| 2020-10-02 |            1 |   1 |    36 | ANY_ROW |
| 2020-10-03 |            1 |   2 |    39 | UP      |
| 2020-10-04 |            1 |   3 |    42 | UP      |
| 2020-10-05 |            2 |   1 |    30 | ANY_ROW |
| 2020-10-06 |            2 |   2 |    47 | UP      |
| 2020-10-07 |            2 |   3 |    71 | UP      |
| 2020-10-08 |            2 |   4 |    80 | UP      |
+------------+--------------+-----+-------+---------+

-- Example 25672
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER"
    all rows per match omit empty matches
    pattern(OVERAVG*)
    define
        OVERAVG as price > avg(price) over (rows between unbounded
                                  preceding and unbounded following)
)
order by company, price_date;
+---------+------------+-------+--------------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER |
|---------+------------+-------+--------------|
| ABCD    | 2020-10-07 |    71 |            7 |
| ABCD    | 2020-10-08 |    80 |            7 |
| ABCD    | 2020-10-09 |    75 |            7 |
| ABCD    | 2020-10-10 |    63 |            7 |
| XYZ     | 2020-10-01 |    89 |            1 |
| XYZ     | 2020-10-04 |    63 |            4 |
| XYZ     | 2020-10-05 |    65 |            4 |
| XYZ     | 2020-10-06 |    56 |            4 |
| XYZ     | 2020-10-08 |    54 |            6 |
+---------+------------+-------+--------------+

-- Example 25673
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        classifier() as cl
    all rows per match with unmatched rows
    pattern(OVERAVG+)
    define
        OVERAVG as price > avg(price) over (rows between unbounded
                                 preceding and unbounded following)
)
order by company, price_date;
+---------+------------+-------+--------------+---------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER | CL      |
|---------+------------+-------+--------------+---------|
| ABCD    | 2020-10-01 |    50 |         NULL | NULL    |
| ABCD    | 2020-10-02 |    36 |         NULL | NULL    |
| ABCD    | 2020-10-03 |    39 |         NULL | NULL    |
| ABCD    | 2020-10-04 |    42 |         NULL | NULL    |
| ABCD    | 2020-10-05 |    30 |         NULL | NULL    |
| ABCD    | 2020-10-06 |    47 |         NULL | NULL    |
| ABCD    | 2020-10-07 |    71 |            1 | OVERAVG |
| ABCD    | 2020-10-08 |    80 |            1 | OVERAVG |
| ABCD    | 2020-10-09 |    75 |            1 | OVERAVG |
| ABCD    | 2020-10-10 |    63 |            1 | OVERAVG |
| XYZ     | 2020-10-01 |    89 |            1 | OVERAVG |
| XYZ     | 2020-10-02 |    24 |         NULL | NULL    |
| XYZ     | 2020-10-03 |    37 |         NULL | NULL    |
| XYZ     | 2020-10-04 |    63 |            2 | OVERAVG |
| XYZ     | 2020-10-05 |    65 |            2 | OVERAVG |
| XYZ     | 2020-10-06 |    56 |            2 | OVERAVG |
| XYZ     | 2020-10-07 |    50 |         NULL | NULL    |
| XYZ     | 2020-10-08 |    54 |            3 | OVERAVG |
| XYZ     | 2020-10-09 |    30 |         NULL | NULL    |
| XYZ     | 2020-10-10 |    32 |         NULL | NULL    |
+---------+------------+-------+--------------+---------+

-- Example 25674
SELECT company, price_date, price, "FINAL FIRST(LT45.price)", "FINAL LAST(LT45.price)"
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               FINAL FIRST(LT45.price) AS "FINAL FIRST(LT45.price)",
               FINAL LAST(LT45.price)  AS "FINAL LAST(LT45.price)"
           ALL ROWS PER MATCH
           AFTER MATCH SKIP PAST LAST ROW
           PATTERN (LT45 LT45)
           DEFINE
               LT45 AS price < 45.00
           )
    WHERE company = 'ABCD'
    ORDER BY price_date;
+---------+------------+-------+-------------------------+------------------------+
| COMPANY | PRICE_DATE | PRICE | FINAL FIRST(LT45.price) | FINAL LAST(LT45.price) |
|---------+------------+-------+-------------------------+------------------------|
| ABCD    | 2020-10-02 |    36 |                      36 |                     39 |
| ABCD    | 2020-10-03 |    39 |                      36 |                     39 |
| ABCD    | 2020-10-04 |    42 |                      42 |                     30 |
| ABCD    | 2020-10-05 |    30 |                      42 |                     30 |
+---------+------------+-------+-------------------------+------------------------+

-- Example 25675
SELECT warehouse_name
  ,COUNT(*) AS query_count
  ,SUM(bytes_scanned) AS bytes_scanned
  ,SUM(bytes_scanned*percentage_scanned_from_cache) AS bytes_scanned_from_cache
  ,SUM(bytes_scanned*percentage_scanned_from_cache) / SUM(bytes_scanned) AS percent_scanned_from_cache
FROM snowflake.account_usage.query_history
WHERE start_time >= dateadd(month,-1,current_timestamp())
  AND bytes_scanned > 0
GROUP BY 1
ORDER BY 5;

-- Example 25676
ALTER WAREHOUSE my_wh SET AUTO_SUSPEND = 600;

-- Example 25677
GRANT ROLE SAMOOHA_APP_ROLE TO USER <user_name>;

-- Example 25678
USE ROLE samooha_app_role;

-- Example 25679
CALL samooha_by_snowflake_local_db.provider.link_datasets('dcr_cleanroom', 
   ['MY_DB.MY_SCHEMA.MY_TABLE']);

-- Example 25680
SELECT * FROM TABLE(result_scan(ABC123));

-- Example 25681
CALL samooha_by_snowflake_local_db.library.register_schema(['MY_DB.MY_SCHEMA']);

-- Example 25682
USE ROLE ACCOUNTADMIN;
CALL samooha_by_snowflake_local_db.library.enable_external_tables_on_account();

-- Example 25683
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.provider.enable_external_tables_for_cleanroom(
  $cleanroom_name);

-- Call until scan is complete.
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- When scan is successful, update with patch version mentioned in return value from enable_external_tables_for_cleanroom.
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '<PATCH_VERSION>');

-- Example 25684
USE ROLE SAMOOHA_APP_ROLE;
CALL samooha_by_snowflake_local_db.consumer.enable_external_tables_for_cleanroom(
  $cleanroom_name);

-- Example 25685
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

-- Example 25686
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 25687
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 25688
alter application package samooha_cleanroom_<CLEANROOM_ID> SET DISTRIBUTION = EXTERNAL;

-- Example 25689
-- Create an internal clean room
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 25690
show versions in application package samooha_cleanroom_<CLEANROOM_ID>;

-- Example 25691
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 25692
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 25693
call samooha_by_snowflake_local_db.provider.enable_consumer_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR_1>']);

-- Example 25694
call samooha_by_snowflake_local_db.provider.disable_consumer_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR_1>']);

-- Example 25695
call samooha_by_snowflake_local_db.library.is_consumer_run_enabled($cleanroom_name)

-- Example 25696
call samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 25697
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.provider.register_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 25698
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25699
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25700
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 25701
USE ROLE ACCOUNTADMIN;

CALL samooha_by_snowflake_local_db.library.enable_external_tables_on_account();

-- Example 25702
CALL samooha_by_snowflake_local_db.provider.enable_external_tables_for_cleanroom(
    $cleanroom_name);

