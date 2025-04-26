-- Example 9830
CREATE OR REPLACE TABLE heavy_weather
   (start_time TIMESTAMP, precip NUMBER(3,2), city VARCHAR(20), county VARCHAR(20));

INSERT INTO heavy_weather VALUES
  ('2021-12-23 06:56:00.000',0.08,'Mount Shasta','Siskiyou'),
  ('2021-12-23 07:51:00.000',0.09,'Mount Shasta','Siskiyou'),
  ('2021-12-23 16:23:00.000',0.56,'South Lake Tahoe','El Dorado'),
  ('2021-12-23 17:24:00.000',0.38,'South Lake Tahoe','El Dorado'),
  ('2021-12-23 18:30:00.000',0.28,'South Lake Tahoe','El Dorado'),
  ('2021-12-23 19:35:00.000',0.37,'Mammoth Lakes','Mono'),
  ('2021-12-23 19:36:00.000',0.80,'South Lake Tahoe','El Dorado'),
  ('2021-12-24 04:43:00.000',0.25,'Alta','Placer'),
  ('2021-12-24 05:26:00.000',0.34,'Alta','Placer'),
  ('2021-12-24 05:35:00.000',0.42,'Big Bear City','San Bernardino'),
  ('2021-12-24 06:49:00.000',0.17,'South Lake Tahoe','El Dorado'),
  ('2021-12-24 07:40:00.000',0.07,'Alta','Placer'),
  ('2021-12-24 08:36:00.000',0.07,'Alta','Placer'),
  ('2021-12-24 11:52:00.000',0.08,'Alta','Placer'),
  ('2021-12-24 12:52:00.000',0.38,'Alta','Placer'),
  ('2021-12-24 15:44:00.000',0.13,'Alta','Placer'),
  ('2021-12-24 15:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
  ('2021-12-24 16:55:00.000',0.09,'Big Bear City','San Bernardino'),
  ('2021-12-24 21:53:00.000',0.07,'Montague','Siskiyou'),
  ('2021-12-25 02:52:00.000',0.07,'Alta','Placer'),
  ('2021-12-25 07:52:00.000',0.07,'Alta','Placer'),
  ('2021-12-25 08:52:00.000',0.08,'Alta','Placer'),
  ('2021-12-25 09:48:00.000',0.18,'Alta','Placer'),
  ('2021-12-25 12:52:00.000',0.10,'Alta','Placer'),
  ('2021-12-25 17:21:00.000',0.23,'Alturas','Modoc'),
  ('2021-12-25 17:52:00.000',1.54,'Alta','Placer'),
  ('2021-12-26 01:52:00.000',0.61,'Alta','Placer'),
  ('2021-12-26 05:43:00.000',0.16,'South Lake Tahoe','El Dorado'),
  ('2021-12-26 05:56:00.000',0.08,'Bishop','Inyo'),
  ('2021-12-26 06:52:00.000',0.75,'Bishop','Inyo'),
  ('2021-12-26 06:53:00.000',0.08,'Lebec','Los Angeles'),
  ('2021-12-26 07:52:00.000',0.65,'Alta','Placer'),
  ('2021-12-26 09:52:00.000',2.78,'Alta','Placer'),
  ('2021-12-26 09:55:00.000',0.07,'Big Bear City','San Bernardino'),
  ('2021-12-26 14:22:00.000',0.32,'Alta','Placer'),
  ('2021-12-26 14:52:00.000',0.34,'Alta','Placer'),
  ('2021-12-26 15:43:00.000',0.35,'Alta','Placer'),
  ('2021-12-26 17:31:00.000',5.24,'Alta','Placer'),
  ('2021-12-26 22:52:00.000',0.07,'Alta','Placer'),
  ('2021-12-26 23:15:00.000',0.52,'Alta','Placer'),
  ('2021-12-27 02:52:00.000',0.08,'Alta','Placer'),
  ('2021-12-27 03:52:00.000',0.14,'Alta','Placer'),
  ('2021-12-27 04:52:00.000',1.52,'Alta','Placer'),
  ('2021-12-27 14:37:00.000',0.89,'Alta','Placer'),
  ('2021-12-27 14:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
  ('2021-12-27 17:53:00.000',0.07,'South Lake Tahoe','El Dorado'),
  ('2021-12-30 11:23:00.000',0.12,'Lebec','Los Angeles'),
  ('2021-12-30 11:43:00.000',0.98,'Lebec','Los Angeles'),
  ('2021-12-30 13:53:00.000',0.23,'Lebec','Los Angeles'),
  ('2021-12-30 14:53:00.000',0.13,'Lebec','Los Angeles'),
  ('2021-12-30 15:15:00.000',0.29,'Lebec','Los Angeles'),
  ('2021-12-30 17:53:00.000',0.10,'Lebec','Los Angeles'),
  ('2021-12-30 18:53:00.000',0.09,'Lebec','Los Angeles'),
  ('2021-12-30 19:53:00.000',0.07,'Lebec','Los Angeles'),
  ('2021-12-30 20:53:00.000',0.07,'Lebec','Los Angeles')
  ;

-- Example 9831
+---------+--------------+------------+------------+------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | ROWS_IN_SEQUENCE | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                5 |             1 |             3 |
+---------+--------------+------------+------------+------------------+---------------+---------------+

-- Example 9832
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

-- Example 9833
create table stock_price_history (company TEXT, price_date DATE, price INT);

-- Example 9834
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

-- Example 9835
MATCH_RECOGNIZE(
  PARTITION BY company
  ORDER BY price_date
  ...
)

-- Example 9836
.[A-Z]+[a-z]+

-- Example 9837
row_before_decrease row_with_price_decrease+ row_with_price_increase+

-- Example 9838
.[A-Z]+[a-z]+

-- Example 9839
MATCH_RECOGNIZE(
  ...
  PATTERN(row_before_decrease row_with_price_decrease+ row_with_price_increase+)
  ...
)

-- Example 9840
MATCH_RECOGNIZE(
  ...
  DEFINE
    row_with_price_decrease AS price < LAG(price)
    row_with_price_increase AS price > LAG(price)
  ...
)

-- Example 9841
MATCH_RECOGNIZE(
  ...
  ONE ROW PER MATCH
  ...
)

-- Example 9842
<expression> AS <column_name>

-- Example 9843
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

-- Example 9844
+---------+--------------+------------+------------+-------------------+---------------+---------------+
| COMPANY | MATCH_NUMBER | START_DATE | END_DATE   | NUM_MATCHING_ROWS | NUM_DECREASES | NUM_INCREASES |
|---------+--------------+------------+------------+-------------------+---------------+---------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |                 4 |             1 |             2 |
| ABCD    |            2 | 2020-10-04 | 2020-10-08 |                 5 |             1 |             3 |
+---------+--------------+------------+------------+-------------------+---------------+---------------+

-- Example 9845
MATCH_RECOGNIZE(
  ...
  AFTER MATCH SKIP TO LAST row_with_price_increase
  ...
)

-- Example 9846
SELECT ...
    FROM stock_price_history
        MATCH_RECOGNIZE (
            PARTITION BY company
            ORDER BY price_date
            ...
        );

-- Example 9847
define
    low_priced_stock as price < 45.00,
    decreased_10_percent as lag(price) * 0.90 >= price,
    increased_05_percent as lag(price) * 1.05 <= price

-- Example 9848
pattern ( low_priced_stock  decreased_10_percent  increased_05_percent )

-- Example 9849
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

-- Example 9850
symbol1+ any_symbol* symbol2

-- Example 9851
symbol1{1,limit} not_symbol1{,limit} symbol2

-- Example 9852
pattern (decreased_10_percent+ increased_05_percent+)
define
    decreased_10_percent as lag(price) * 0.90 >= price,
    increased_05_percent as lag(price) * 1.05 <= price

-- Example 9853
PATTERN (^ GT75)
DEFINE
    GT75 AS price > 75.00

-- Example 9854
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

-- Example 9855
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

-- Example 9856
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

-- Example 9857
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

-- Example 9858
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

-- Example 9859
PATTERN(LESS_THAN_45 UP {- UP* -} DOWN {- DOWN* -})

-- Example 9860
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

-- Example 9861
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

-- Example 9862
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

-- Example 9863
PATTERN (START DOWN UP)

-- Example 9864
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

-- Example 9865
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

-- Example 9866
SELECT *
    FROM stock_price_history
       MATCH_RECOGNIZE (
           PARTITION BY company
           ORDER BY price_date
           MEASURES
               MATCH_NUMBER() AS "Match #",
               MATCH_SEQUENCE_NUMBER() AS "Match Sequence #"
           ALL ROWS PER MATCH
           PATTERN (MINIMUM_37 UP UP)
           DEFINE
               MINIMUM_37 AS price >= 37.00,
               UP AS price > LAG(price)
           )
    ORDER BY company, "Match #", "Match Sequence #";
+---------+------------+-------+---------+------------------+
| COMPANY | PRICE_DATE | PRICE | Match # | Match Sequence # |
|---------+------------+-------+---------+------------------|
| ABCD    | 2020-10-06 |    47 |       1 |                1 |
| ABCD    | 2020-10-07 |    71 |       1 |                2 |
| ABCD    | 2020-10-08 |    80 |       1 |                3 |
| XYZ     | 2020-10-03 |    37 |       1 |                1 |
| XYZ     | 2020-10-04 |    63 |       1 |                2 |
| XYZ     | 2020-10-05 |    65 |       1 |                3 |
+---------+------------+-------+---------+------------------+

-- Example 9867
select * from stock_price_history match_recognize(
        partition by company
        order by price_date
        measures
            match_number() as "MATCH_NUMBER",
            first(price_date) as "START",
            last(price_date) as "END",
            count(up.price) as ups,
            count(*) as "PRICE_COUNT",
            last(classifier()) = 'DOWN' up_spike
        after match skip to next row
        pattern(ANY_ROW PERMUTE(UP{2}, DOWN+))
        define
            ANY_ROW AS TRUE,
            UP as price > lag(price),
            DOWN as price < lag(price)
    )
    order by company, match_number;
+---------+--------------+------------+------------+-----+-------------+----------+
| COMPANY | MATCH_NUMBER | START      | END        | UPS | PRICE_COUNT | UP_SPIKE |
|---------+--------------+------------+------------+-----+-------------+----------|
| ABCD    |            1 | 2020-10-01 | 2020-10-04 |   2 |           4 | False    |
| ABCD    |            2 | 2020-10-02 | 2020-10-05 |   2 |           4 | True     |
| ABCD    |            3 | 2020-10-04 | 2020-10-07 |   2 |           4 | False    |
| ABCD    |            4 | 2020-10-06 | 2020-10-10 |   2 |           5 | True     |
| XYZ     |            1 | 2020-10-01 | 2020-10-04 |   2 |           4 | False    |
| XYZ     |            2 | 2020-10-03 | 2020-10-07 |   2 |           5 | True     |
+---------+--------------+------------+------------+-----+-------------+----------+

-- Example 9868
select * from stock_price_history match_recognize(
    partition by company
    order by price_date
    measures
        match_number() as "MATCH_NUMBER",
        first(price_date) as "START",
        last(price_date) as "END",
        count(*) as "PRICE_COUNT"
    after match skip to next row
    pattern(ANY_ROW DOWN+ UP+ DOWN+ UP+)
    define
        ANY_ROW AS TRUE,
        UP as price > lag(price),
        DOWN as price < lag(price)
)
order by company, match_number;
+---------+--------------+------------+------------+-------------+
| COMPANY | MATCH_NUMBER | START      | END        | PRICE_COUNT |
|---------+--------------+------------+------------+-------------|
| ABCD    |            1 | 2020-10-01 | 2020-10-08 |           8 |
| XYZ     |            1 | 2020-10-01 | 2020-10-08 |           8 |
| XYZ     |            2 | 2020-10-05 | 2020-10-10 |           6 |
| XYZ     |            3 | 2020-10-06 | 2020-10-10 |           5 |
+---------+--------------+------------+------------+-------------+

-- Example 9869
select * from stock_price_history match_recognize(
        partition by company
        order by price_date
        measures
            match_number() as "MATCH_NUMBER",
            classifier as cl,
            count(*) as "PRICE_COUNT"
        all rows per match
        pattern(ANY_ROW {- DOWN+ -} UP+ {- DOWN+ -} UP+)
        define
            ANY_ROW AS TRUE,
            UP as price > lag(price),
            DOWN as price < lag(price)
    )
    order by company, price_date;
+---------+------------+-------+--------------+---------+-------------+
| COMPANY | PRICE_DATE | PRICE | MATCH_NUMBER | CL      | PRICE_COUNT |
|---------+------------+-------+--------------+---------+-------------|
| ABCD    | 2020-10-01 |    50 |            1 | ANY_ROW |           1 |
| ABCD    | 2020-10-03 |    39 |            1 | UP      |           3 |
| ABCD    | 2020-10-04 |    42 |            1 | UP      |           4 |
| ABCD    | 2020-10-06 |    47 |            1 | UP      |           6 |
| ABCD    | 2020-10-07 |    71 |            1 | UP      |           7 |
| ABCD    | 2020-10-08 |    80 |            1 | UP      |           8 |
| XYZ     | 2020-10-01 |    89 |            1 | ANY_ROW |           1 |
| XYZ     | 2020-10-03 |    37 |            1 | UP      |           3 |
| XYZ     | 2020-10-04 |    63 |            1 | UP      |           4 |
| XYZ     | 2020-10-05 |    65 |            1 | UP      |           5 |
| XYZ     | 2020-10-08 |    54 |            1 | UP      |           8 |
+---------+------------+-------+--------------+---------+-------------+

-- Example 9870
MATCH_RECOGNIZE (
    ...
    ORDER BY log_message_timestamp
    ...
    ALL ROWS PER MATCH
    PATTERN ( WARNING1  {- ANY_ROW* -}  WARNING2  {- ANY_ROW* -}  FATAL_ERROR )
    DEFINE
        ANY_ROW AS TRUE,
        WARNING1 AS SUBSTR(log_message, 1, 42) = 'WARNING: Available memory is less than 10%',
        WARNING2 AS SUBSTR(log_message, 1, 41) = 'WARNING: Available memory is less than 5%',
        FATAL_ERROR AS SUBSTR(log_message, 1, 11) = 'FATAL ERROR'
    )
...

-- Example 9871
SELECT DISTINCT(severity) FROM weather_events;
SELECT DISTINCT(severity) FROM weather_events;
SELECT DISTINCT(severity) FROM weather_events we;
select distinct(severity) from weather_events;

-- Example 9872
SHOW TABLES;

+-----+-------------------------------+-------------+-------+-------+------+
| Row |           created_on          | name        | ...   | ...   | rows |
+-----+-------------------------------+-------------+-------+-------+------+
|  1  | 2018-07-02 09:43:49.971 -0700 | employees   | ...   | ...   | 2405 |
+-----+-------------------------------+-------------+-------+-------+------+
|  2  | 2018-07-02 09:43:52.483 -0700 | dependents  | ...   | ...   | 5280 |
+-----+-------------------------------+-------------+-------+-------+------+
|  3  | 2018-07-03 11:43:52.483 -0700 | injuries    | ...   | ...   |    0 |
+-----+-------------------------------+-------------+-------+-------+------+
|  4  | 2018-07-03 11:43:52.483 -0700 | claims      | ...   | ...   |    0 |
+-----+-------------------------------+-------------+-------+-------+------+
| ...                                                                      |
| ...                                                                      |
+-----+-------------------------------+-------------+-------+-------+------+

-- Show the tables that are empty.
SELECT  "schema_name", "name" as "table_name", "rows"
    FROM table(RESULT_SCAN(LAST_QUERY_ID()))
    WHERE "rows" = 0;

+-----+-------------+-------------+------+
| Row | schema_name | name        | rows |
+-----+-------------+-------------+------+
|  1  |  PUBLIC     | injuries    |    0 |
+-----+-------------+-------------+------+
|  2  |  PUBLIC     | claims      |    0 |
+-----+-------------+-------------+------+
| ...                                    |
| ...                                    |
+-----+-------------+-------------+------+

-- Example 9873
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 9874
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 9875
SELECT
    query_hash,
    COUNT(*),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE warehouse_name = 'MY_WAREHOUSE'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 7
  GROUP BY query_hash
  ORDER BY SUM(total_elapsed_time) DESC
  LIMIT 100;

-- Example 9876
SELECT * FROM table1 WHERE table1.name = 'TIM'

-- Example 9877
SELECT * FROM table1 WHERE table1.name = 'AIHUA'

-- Example 9878
SELECT
    DATE_TRUNC('day', start_time),
    SUM(total_elapsed_time),
    ANY_VALUE(query_id)
  FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
  WHERE query_parameterized_hash = 'cbd58379a88c37ed6cc0ecfebb053b03'
    AND DATE_TRUNC('day', start_time) >= CURRENT_DATE() - 30
  GROUP BY DATE_TRUNC('day', start_time);

-- Example 9879
...
WHERE (query_hash = 'hash_from_v1' AND query_hash_version = 1)
  OR (query_hash = 'hash_from_v2' AND query_hash_version = 2)

-- Example 9880
CREATE OR REPLACE TABLE variant_topk_test (var_col VARIANT);

INSERT INTO variant_topk_test
  SELECT PARSE_JSON(column1)
    FROM VALUES
      ('{"s": "aa", "i": 1}'),
      ('{"s": "bb", "i": 2}'),
      ('{"s": "cc", "i": 3}'),
      ('{"s": "dd", "i": 4}'),
      ('{"s": "ee", "i": 5}'),
      ('{"s": "ff", "i": 6}'),
      ('{"s": "gg", "i": 7}'),
      ('{"s": "hh", "i": 8}'),
      ('{"s": "ii", "i": 9}'),
      ('{"s": "jj", "i": 10}');

-- Example 9881
SELECT * FROM variant_topk_test ORDER BY TO_VARCHAR(var_col:s) LIMIT 5;

-- Example 9882
SELECT * FROM variant_topk_test ORDER BY var_col:s::VARCHAR LIMIT 5;

-- Example 9883
SELECT * FROM variant_topk_test ORDER BY TO_NUMBER(var_col:i) LIMIT 5;

-- Example 9884
SELECT * FROM variant_topk_test ORDER BY var_col:i::NUMBER LIMIT 5;

-- Example 9885
SELECT * FROM variant_topk_test ORDER BY var_col:s LIMIT 5;

-- Example 9886
SELECT * FROM variant_topk_test ORDER BY var_col:i::VARCHAR LIMIT 5;

-- Example 9887
SELECT c1, c2, c3, COUNT(*) AS agg_col
  FROM mytable
  GROUP BY c1, c2, c3
  ORDER BY c2, c1, agg_col, c3
  LIMIT 5;

-- Example 9888
SELECT c1, c2, c3, COUNT(*) AS agg_col
  FROM mytable
  GROUP BY c1, c2, c3
  ORDER BY agg_col, c2, c1
  LIMIT 5;

-- Example 9889
public void testCancelQuery() throws IOException, SQLException
{
  Statement         statement         = null;
  ResultSet         resultSet         = null;
  ResultSetMetaData resultSetMetaData = null;
  final Connection  connection        = getConnection(true);
  try
  {
    // Get the current session identifier
    Statement getSessionIdStmt = connection.createStatement();
    resultSet                  = getSessionIdStmt.executeQuery("SELECT current_session()");
    resultSetMetaData          = resultSet.getMetaData();
    assertTrue(resultSet.next());
    final int sessionId = resultSet.getInt(1);

    // Use Timer to cancel all queries of session in 5 seconds
    Timer timer = new Timer();
    timer.schedule( new TimerTask()
    {
      @Override
      public void run()
      {
        try
        {
          // Cancel all queries on session
          PreparedStatement cancelAll;
          cancelAll = connection.prepareStatement(
                                    "call system$cancel_all_queries(?)");

          // bind the session identifier as first argument
          cancelAll.setInt(1, sessionId);
          cancelAll.executeQuery();
        }
        catch (SQLException ex)
        {
          logger.log(Level.SEVERE, "Cancel failed with exception {}", ex);
        }
      }
    }, 5000);

    // Use the internal row generator to execute a query for 120 seconds
    statement = connection.createStatement();
    resultSet = statement.executeQuery(
                   "SELECT count(*) FROM TABLE(generator(timeLimit => 120))");
    resultSetMetaData = resultSet.getMetaData();
    statement.close();
  }
  catch (SQLException ex)
  {
    // assert the sqlstate is what we expect (QUERY CANCELLED)
    assertEquals("sqlstate mismatch",
                 SqlState.QUERY_CANCELED, ex.getSQLState());
  }
  catch (Throwable ex)
  {
    logger.log(Level.SEVERE, "Test failed with exception: ", ex);
  }
  finally
  {
    if (resultSet != null)
      resultSet.close();
    if (statement != null)
      statement.close();
    // close connection
    if (connection != null)
      connection.close();
  }
}

-- Example 9890
SELECT f.*
FROM fact_sales f
LEFT OUTER JOIN dim_products p
ON f.product_id = p.product_id;

-- Example 9891
SELECT p1.product_id, p2.product_name
FROM dim_products p1, dim_products p2
WHERE p1.product_id = p2.product_id;

-- Example 9892
SELECT p.product_id, f.units_sold
FROM   fact_sales f, dim_products p
WHERE  f.product_id = p.product_id;

-- Example 9893
USE WAREHOUSE app_wh;
USE ROLE ACCOUNTADMIN;
-- Using ACCOUNTADMIN role because you need a role that allows you to create a database.
-- Feel free to use any other role that can create a database.

-- Generate a provider dataset based on the first 1,000 rows of sample data.
CREATE DATABASE IF NOT EXISTS cleanroom_tut_db;
CREATE SCHEMA IF NOT EXISTS cleanroom_tut_db.cleanroom_tut_sch;

CREATE TABLE IF NOT EXISTS cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table AS
  SELECT TOP 1000 * FROM SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS ORDER BY HASHED_EMAIL ASC;

DESCRIBE TABLE cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table;

-- Example 9894
USE ROLE samooha_app_role;
SET cleanroom_name = 'Developer Tutorial';
CALL samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 9895
USE ROLE ACCOUNTADMIN;
CALL samooha_by_snowflake_local_db.provider.register_db('cleanroom_tut_db');

-- Example 9896
-- Back to samooha_app_role until you need to clean things up at the end.
USE ROLE samooha_app_role;
CALL samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name,
  ['cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table']);

CALL samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

