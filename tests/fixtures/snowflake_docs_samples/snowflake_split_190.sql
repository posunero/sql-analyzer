-- Example 12710
CREATE AGGREGATION POLICY my_policy AS ()
  RETURNS AGGREGATION_CONSTRAINT ->
  AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5);

-- Example 12711
CREATE AGGREGATION POLICY my_policy AS ()
  RETURNS AGGREGATION_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ADMIN'
        THEN NO_AGGREGATION_CONSTRAINT()
      ELSE AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5)
    END;

-- Example 12712
DESC[RIBE] AGGREGATION POLICY <name>

-- Example 12713
DESC AGGREGATION POLICY my_aggpolicy;

-- Example 12714
[ ( ] <query> [ ) ] { INTERSECT | { MINUS | EXCEPT } | UNION [ ALL ] } [ ( ] <query> [ ) ]
[ ORDER BY ... ]
[ LIMIT ... ]

-- Example 12715
SELECT LastName, FirstName FROM employees
UNION ALL
SELECT FirstName, LastName FROM contractors;

-- Example 12716
SELECT * FROM table1
UNION ALL
SELECT * FROM table2;

-- Example 12717
SELECT LastName, FirstName FROM employees
UNION ALL
SELECT FirstName, LastName FROM contractors;

-- Example 12718
SELECT LastName, FirstName FROM employees
UNION ALL
SELECT FirstName AS LastName, LastName AS FirstName FROM contractors;

-- Example 12719
CREATE OR REPLACE TABLE sales_office_zip_example(
  office_name VARCHAR,
  zip VARCHAR);

INSERT INTO sales_office_zip_example VALUES ('sales1', '94061');
INSERT INTO sales_office_zip_example VALUES ('sales2', '94070');
INSERT INTO sales_office_zip_example VALUES ('sales3', '98116');
INSERT INTO sales_office_zip_example VALUES ('sales4', '98005');

CREATE OR REPLACE TABLE customer_zip_example(
  customer VARCHAR,
  zip VARCHAR);

INSERT INTO customer_zip_example VALUES ('customer1', '94066');
INSERT INTO customer_zip_example VALUES ('customer2', '94061');
INSERT INTO customer_zip_example VALUES ('customer3', '98444');
INSERT INTO customer_zip_example VALUES ('customer4', '98005');

-- Example 12720
SELECT ...
INTERSECT
SELECT ...

-- Example 12721
SELECT zip FROM sales_office_zip_example
INTERSECT
SELECT zip FROM customer_zip_example;

-- Example 12722
+-------+
| ZIP   |
|-------|
| 94061 |
| 98005 |
+-------+

-- Example 12723
SELECT ...
MINUS
SELECT ...

SELECT ...
EXCEPT
SELECT ...

-- Example 12724
SELECT zip FROM sales_office_zip_example
MINUS
SELECT zip FROM customer_zip_example;

-- Example 12725
+-------+
| ZIP   |
|-------|
| 98116 |
| 94070 |
+-------+

-- Example 12726
SELECT zip FROM customer_zip_example
MINUS
SELECT zip FROM sales_office_zip_example;

-- Example 12727
+-------+
| ZIP   |
|-------|
| 98444 |
| 94066 |
+-------+

-- Example 12728
SELECT ...
UNION [ ALL ]
SELECT ...

-- Example 12729
SELECT office_name office_or_customer, zip FROM sales_office_zip_example
UNION
SELECT customer, zip FROM customer_zip_example
ORDER BY zip;

-- Example 12730
+--------------------+-------+
| OFFICE_OR_CUSTOMER | ZIP   |
|--------------------+-------|
| sales1             | 94061 |
| customer2          | 94061 |
| customer1          | 94066 |
| sales2             | 94070 |
| sales4             | 98005 |
| customer4          | 98005 |
| sales3             | 98116 |
| customer3          | 98444 |
+--------------------+-------+

-- Example 12731
CREATE OR REPLACE TABLE union_test1 (v VARCHAR);
CREATE OR REPLACE TABLE union_test2 (i INTEGER);

INSERT INTO union_test1 (v) VALUES ('Adams, Douglas');
INSERT INTO union_test2 (i) VALUES (42);

-- Example 12732
SELECT v FROM union_test1
UNION
SELECT i FROM union_test2;

-- Example 12733
100038 (22018): Numeric value 'Adams, Douglas' is not recognized

-- Example 12734
SELECT v::VARCHAR FROM union_test1
UNION
SELECT i::VARCHAR FROM union_test2;

-- Example 12735
+----------------+
| V::VARCHAR     |
|----------------|
| Adams, Douglas |
| 42             |
+----------------+

-- Example 12736
select my_database.my_schema.my_external_function(col1) from table1;

-- Example 12737
select my_external_function_2(column_1, column_2)
    from table_1;

select col1
    from table_1
    where my_external_function_3(col2) < 0;

create view view1 (col1) as
    select my_external_function_5(col1)
        from table9;

-- Example 12738
select upper(zipcode_to_city_external_function(zipcode))
  from address_table;

-- Example 12739
CREATE VIEW my_shared_view AS SELECT my_external_function(x) ...;
CREATE SHARE things_to_share;
...
GRANT SELECT ON VIEW my_shared_view TO SHARE things_to_share;
...

-- Example 12740
https://api-id.execute-api.region.amazonaws.com/stage

-- Example 12741
SELECT ...
FROM ...
   PIVOT ( <aggregate_function> ( <pivot_column> )
            FOR <value_column> IN (
              <pivot_value_1> [ , <pivot_value_2> ... ]
              | ANY [ ORDER BY ... ]
              | <subquery>
            )
            [ DEFAULT ON NULL (<value>) ]
         )

[ ... ]

-- Example 12742
CREATE OR REPLACE TABLE quarterly_sales(
  empid INT,
  amount INT,
  quarter TEXT)
  AS SELECT * FROM VALUES
    (1, 10000, '2023_Q1'),
    (1, 400, '2023_Q1'),
    (2, 4500, '2023_Q1'),
    (2, 35000, '2023_Q1'),
    (1, 5000, '2023_Q2'),
    (1, 3000, '2023_Q2'),
    (2, 200, '2023_Q2'),
    (2, 90500, '2023_Q2'),
    (1, 6000, '2023_Q3'),
    (1, 5000, '2023_Q3'),
    (2, 2500, '2023_Q3'),
    (2, 9500, '2023_Q3'),
    (3, 2700, '2023_Q3'),
    (1, 8000, '2023_Q4'),
    (1, 10000, '2023_Q4'),
    (2, 800, '2023_Q4'),
    (2, 4500, '2023_Q4'),
    (3, 2700, '2023_Q4'),
    (3, 16000, '2023_Q4'),
    (3, 10200, '2023_Q4');

-- Example 12743
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (ANY ORDER BY quarter))
  ORDER BY empid;

-- Example 12744
+-------+-----------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-------+-----------+-----------+-----------+-----------|
|     1 |     10400 |      8000 |     11000 |     18000 |
|     2 |     39500 |     90700 |     12000 |      5300 |
|     3 |      NULL |      NULL |      2700 |     28900 |
+-------+-----------+-----------+-----------+-----------+

-- Example 12745
CREATE OR REPLACE TABLE ad_campaign_types_by_quarter(
  quarter VARCHAR,
  television BOOLEAN,
  radio BOOLEAN,
  print BOOLEAN)
  AS SELECT * FROM VALUES
    ('2023_Q1', TRUE, FALSE, FALSE),
    ('2023_Q2', FALSE, TRUE, TRUE),
    ('2023_Q3', FALSE, TRUE, FALSE),
    ('2023_Q4', TRUE, FALSE, TRUE);

-- Example 12746
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (
      SELECT DISTINCT quarter
        FROM ad_campaign_types_by_quarter
        WHERE television = TRUE
        ORDER BY quarter))
  ORDER BY empid;

-- Example 12747
+-------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q4' |
|-------+-----------+-----------|
|     1 |     10400 |     18000 |
|     2 |     39500 |      5300 |
|     3 |      NULL |     28900 |
+-------+-----------+-----------+

-- Example 12748
SELECT 'Average sale amount' AS aggregate, *
  FROM quarterly_sales
    PIVOT(AVG(amount) FOR quarter IN (ANY ORDER BY quarter))
UNION
SELECT 'Highest value sale' AS aggregate, *
  FROM quarterly_sales
    PIVOT(MAX(amount) FOR quarter IN (ANY ORDER BY quarter))
UNION
SELECT 'Lowest value sale' AS aggregate, *
  FROM quarterly_sales
    PIVOT(MIN(amount) FOR quarter IN (ANY ORDER BY quarter))
UNION
SELECT 'Number of sales' AS aggregate, *
  FROM quarterly_sales
    PIVOT(COUNT(amount) FOR quarter IN (ANY ORDER BY quarter))
UNION
SELECT 'Total amount' AS aggregate, *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (ANY ORDER BY quarter))
ORDER BY aggregate, empid;

-- Example 12749
+---------------------+-------+--------------+--------------+--------------+--------------+
| AGGREGATE           | EMPID |    '2023_Q1' |    '2023_Q2' |    '2023_Q3' |    '2023_Q4' |
|---------------------+-------+--------------+--------------+--------------+--------------|
| Average sale amount |     1 |  5200.000000 |  4000.000000 |  5500.000000 |  9000.000000 |
| Average sale amount |     2 | 19750.000000 | 45350.000000 |  6000.000000 |  2650.000000 |
| Average sale amount |     3 |         NULL |         NULL |  2700.000000 |  9633.333333 |
| Highest value sale  |     1 | 10000.000000 |  5000.000000 |  6000.000000 | 10000.000000 |
| Highest value sale  |     2 | 35000.000000 | 90500.000000 |  9500.000000 |  4500.000000 |
| Highest value sale  |     3 |         NULL |         NULL |  2700.000000 | 16000.000000 |
| Lowest value sale   |     1 |   400.000000 |  3000.000000 |  5000.000000 |  8000.000000 |
| Lowest value sale   |     2 |  4500.000000 |   200.000000 |  2500.000000 |   800.000000 |
| Lowest value sale   |     3 |         NULL |         NULL |  2700.000000 |  2700.000000 |
| Number of sales     |     1 |     2.000000 |     2.000000 |     2.000000 |     2.000000 |
| Number of sales     |     2 |     2.000000 |     2.000000 |     2.000000 |     2.000000 |
| Number of sales     |     3 |     0.000000 |     0.000000 |     1.000000 |     3.000000 |
| Total amount        |     1 | 10400.000000 |  8000.000000 | 11000.000000 | 18000.000000 |
| Total amount        |     2 | 39500.000000 | 90700.000000 | 12000.000000 |  5300.000000 |
| Total amount        |     3 |         NULL |         NULL |  2700.000000 | 28900.000000 |
+---------------------+-------+--------------+--------------+--------------+--------------+

-- Example 12750
CREATE OR REPLACE TABLE emp_manager(
    empid INT,
    managerid INT)
  AS SELECT * FROM VALUES
    (1, 7),
    (2, 8),
    (3, 9);

SELECT * from emp_manager;

-- Example 12751
+-------+-----------+
| EMPID | MANAGERID |
|-------+-----------|
|     1 |         7 |
|     2 |         8 |
|     3 |         9 |
+-------+-----------+

-- Example 12752
WITH
  src AS
  (
    SELECT *
      FROM quarterly_sales
        PIVOT(SUM(amount) FOR quarter IN (ANY ORDER BY quarter))
  )
SELECT em.managerid, src.*
  FROM emp_manager em
  JOIN src ON em.empid = src.empid
  ORDER BY empid;

-- Example 12753
+-----------+-------+-----------+-----------+-----------+-----------+
| MANAGERID | EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-----------+-------+-----------+-----------+-----------+-----------|
|         7 |     1 |     10400 |      8000 |     11000 |     18000 |
|         8 |     2 |     39500 |     90700 |     12000 |      5300 |
|         9 |     3 |      NULL |      NULL |      2700 |     28900 |
+-----------+-------+-----------+-----------+-----------+-----------+

-- Example 12754
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3'))
  ORDER BY empid;

-- Example 12755
+-------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' |
|-------+-----------+-----------+-----------|
|     1 |     10400 |      8000 |     11000 |
|     2 |     39500 |     90700 |     12000 |
|     3 |      NULL |      NULL |      2700 |
+-------+-----------+-----------+-----------+

-- Example 12756
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3',
      '2023_Q4'))
  ORDER BY empid;

-- Example 12757
+-------+-----------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-------+-----------+-----------+-----------+-----------|
|     1 |     10400 |      8000 |     11000 |     18000 |
|     2 |     39500 |     90700 |     12000 |      5300 |
|     3 |      NULL |      NULL |      2700 |     28900 |
+-------+-----------+-----------+-----------+-----------+

-- Example 12758
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3',
      '2023_Q4')) AS p (employee, q1, q2, q3, q4)
  ORDER BY employee;

-- Example 12759
+----------+-------+-------+-------+-------+
| EMPLOYEE |    Q1 |    Q2 |    Q3 |    Q4 |
|----------+-------+-------+-------+-------|
|        1 | 10400 |  8000 | 11000 | 18000 |
|        2 | 39500 | 90700 | 12000 |  5300 |
|        3 |  NULL |  NULL |  2700 | 28900 |
+----------+-------+-------+-------+-------+

-- Example 12760
SELECT empid,
       "'2023_Q1'" AS q1,
       "'2023_Q2'" AS q2,
       "'2023_Q3'" AS q3,
       "'2023_Q4'" AS q4
  FROM quarterly_sales
    PIVOT(sum(amount) FOR quarter IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3',
      '2023_Q4'))
  ORDER BY empid;

-- Example 12761
+-------+-------+-------+-------+-------+
| EMPID |    Q1 |    Q2 |    Q3 |    Q4 |
|-------+-------+-------+-------+-------|
|     1 | 10400 |  8000 | 11000 | 18000 |
|     2 | 39500 | 90700 | 12000 |  5300 |
|     3 |  NULL |  NULL |  2700 | 28900 |
+-------+-------+-------+-------+-------+

-- Example 12762
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount) FOR quarter IN (ANY ORDER BY quarter)
      DEFAULT ON NULL (0))
  ORDER BY empid;

-- Example 12763
+-------+-----------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-------+-----------+-----------+-----------+-----------|
|     1 |     10400 |      8000 |     11000 |     18000 |
|     2 |     39500 |     90700 |     12000 |      5300 |
|     3 |         0 |         0 |      2700 |     28900 |
+-------+-----------+-----------+-----------+-----------+

-- Example 12764
SELECT *
  FROM quarterly_sales
    PIVOT(SUM(amount)
      FOR quarter IN (
        '2023_Q1',
        '2023_Q2')
      DEFAULT ON NULL (0))
  ORDER BY empid;

-- Example 12765
+-------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' |
|-------+-----------+-----------|
|     1 |     10400 |      8000 |
|     2 |     39500 |     90700 |
|     3 |         0 |         0 |
+-------+-----------+-----------+

-- Example 12766
ALTER TABLE quarterly_sales ADD COLUMN discount_percent INT DEFAULT 0;

-- Example 12767
UPDATE quarterly_sales SET discount_percent = UNIFORM(0, 5, RANDOM());

-- Example 12768
SELECT * FROM quarterly_sales;

-- Example 12769
+-------+--------+---------+------------------+
| EMPID | AMOUNT | QUARTER | DISCOUNT_PERCENT |
|-------+--------+---------+------------------|
|     1 |  10000 | 2023_Q1 |                0 |
|     1 |    400 | 2023_Q1 |                1 |
|     2 |   4500 | 2023_Q1 |                4 |
|     2 |  35000 | 2023_Q1 |                2 |
|     1 |   5000 | 2023_Q2 |                2 |
|     1 |   3000 | 2023_Q2 |                1 |
|     2 |    200 | 2023_Q2 |                2 |
|     2 |  90500 | 2023_Q2 |                1 |
|     1 |   6000 | 2023_Q3 |                1 |
|     1 |   5000 | 2023_Q3 |                3 |
|     2 |   2500 | 2023_Q3 |                1 |
|     2 |   9500 | 2023_Q3 |                3 |
|     3 |   2700 | 2023_Q3 |                1 |
|     1 |   8000 | 2023_Q4 |                1 |
|     1 |  10000 | 2023_Q4 |                4 |
|     2 |    800 | 2023_Q4 |                3 |
|     2 |   4500 | 2023_Q4 |                5 |
|     3 |   2700 | 2023_Q4 |                3 |
|     3 |  16000 | 2023_Q4 |                0 |
|     3 |  10200 | 2023_Q4 |                1 |
+-------+--------+---------+------------------+

-- Example 12770
WITH
  sales_without_discount AS
    (SELECT * EXCLUDE(discount_percent) FROM quarterly_sales)
SELECT *
  FROM sales_without_discount
    PIVOT(SUM(amount) FOR quarter IN (ANY ORDER BY quarter))
  ORDER BY empid;

-- Example 12771
+-------+-----------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-------+-----------+-----------+-----------+-----------|
|     1 |     10400 |      8000 |     11000 |     18000 |
|     2 |     39500 |     90700 |     12000 |      5300 |
|     3 |      NULL |      NULL |      2700 |     28900 |
+-------+-----------+-----------+-----------+-----------+

-- Example 12772
WITH
  sales_without_amount AS
    (SELECT * EXCLUDE(amount) FROM quarterly_sales)
SELECT *
  FROM sales_without_amount
    PIVOT(AVG(discount_percent) FOR quarter IN (ANY ORDER BY quarter))
  ORDER BY empid;

-- Example 12773
+-------+-----------+-----------+-----------+-----------+
| EMPID | '2023_Q1' | '2023_Q2' | '2023_Q3' | '2023_Q4' |
|-------+-----------+-----------+-----------+-----------|
|     1 |  0.500000 |  1.500000 |  2.000000 |  2.500000 |
|     2 |  3.000000 |  1.500000 |  2.000000 |  4.000000 |
|     3 |      NULL |      NULL |  1.000000 |  1.333333 |
+-------+-----------+-----------+-----------+-----------+

-- Example 12774
SELECT SUM($1) AS q1_sales_total,
       SUM($2) AS q2_sales_total,
       SUM($3) AS q3_sales_total,
       SUM($4) AS q4_sales_total,
       MAX($5) AS q1_maximum_discount,
       MAX($6) AS q2_maximum_discount,
       MAX($7) AS q3_maximum_discount,
       MAX($8) AS q4_maximum_discount
  FROM
    (SELECT amount,
            quarter AS quarter_amount,
            quarter AS quarter_discount,
            discount_percent
      FROM quarterly_sales)
  PIVOT (
    SUM(amount)
    FOR quarter_amount IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3',
      '2023_Q4'))
  PIVOT (
    MAX(discount_percent)
    FOR quarter_discount IN (
      '2023_Q1',
      '2023_Q2',
      '2023_Q3',
      '2023_Q4'));

-- Example 12775
+----------------+----------------+----------------+----------------+---------------------+---------------------+---------------------+---------------------+
| Q1_SALES_TOTAL | Q2_SALES_TOTAL | Q3_SALES_TOTAL | Q4_SALES_TOTAL | Q1_MAXIMUM_DISCOUNT | Q2_MAXIMUM_DISCOUNT | Q3_MAXIMUM_DISCOUNT | Q4_MAXIMUM_DISCOUNT |
|----------------+----------------+----------------+----------------+---------------------+---------------------+---------------------+---------------------|
|          49900 |          98700 |          25700 |          52200 |                   4 |                   2 |                   3 |                   5 |
+----------------+----------------+----------------+----------------+---------------------+---------------------+---------------------+---------------------+

-- Example 12776
DROP AGGREGATION POLICY <name>

