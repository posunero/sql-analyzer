-- Example 23626
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE governance TO ROLE functions_admin;

GRANT USAGE ON SCHEMA governance.functions TO ROLE functions_admin;

GRANT CREATE FUNCTION ON SCHEMA governance.functions TO ROLE functions_admin;

-- Example 23627
USE ROLE functions_admin;

USE SCHEMA governance.functions;

CREATE OR REPLACE function allowed_regions()
  RETURNS array
  memoizable
  AS 'SELECT ARRAY_AGG(id) FROM regions';

-- Example 23628
USE ROLE rap_admin;

CREATE OR REPLACE ROW ACCESS POLICY rap_with_memoizable_function
  AS (region_id number, customer_id number, product_id number)
  RETURNS BOOLEAN ->
    ARRAY_CONTAINS(region_id, allowed_regions()) OR
    ARRAY_CONTAINS(customer_id, allowed_customers()) OR
    ARRAY_CONTAINS(product_id, allowed_products())
  ;

-- Example 23629
CREATE OR REPLACE TABLE sales.tables.regional_managers (
  allowed_regions varchar
  allowed_roles varchar
);

-- Example 23630
INSERT INTO sales.tables.regional_managers
(allowed_regions, allowed_roles)
VALUES
('na', 'NA_MANAGER'),
('eu', 'EU_MANAGER'),
('apac', 'APAC_MANAGER');

-- Example 23631
CREATE OR REPLACE ROW ACCESS POLICY governance.policies.rap_map_exempt
AS (allowed_roles varchar) RETURNS BOOLEAN ->
IS_ROLE_IN_SESSION(allowed_roles);

-- Example 23632
ALTER TABLE sales.tables.regional_managers
  ADD ROW ACCESS POLICY governance.policies.rap_map_exempt
  ON (allowed_roles);

-- Example 23633
CREATE OR REPLACE ROW ACCESS POLICY governance.policies.rap_map_lookup
 AS (allowed_regions varchar) RETURNS BOOLEAN ->
 EXISTS (
   SELECT * FROM sales.tables.regional_managers
   WHERE
     REGION = allowed_regions
);

-- Example 23634
ALTER TABLE sales.tables.data
  ADD ROW ACCESS POLICY governance.policies.rap_map_lookup
  ON (allowed_regions);

-- Example 23635
USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE sales TO ROLE na_manager;
GRANT USAGE ON SCHEMA sales.tables TO ROLE na_manager;
GRANT SELECT ON TABLE sales.tables.regional_managers TO ROLE na_manager;
GRANT SELECT ON TABLE sales.tables.data TO ROLE na_manager;

-- Example 23636
CREATE FUNCTION area_of_circle(radius FLOAT)
  RETURNS FLOAT
  AS
  $$
    pi() * radius * radius
  $$
  ;

-- Example 23637
SELECT area_of_circle(1.0);

-- Example 23638
SELECT area_of_circle(1.0);
+---------------------+
| AREA_OF_CIRCLE(1.0) |
|---------------------|
|         3.141592654 |
+---------------------+

-- Example 23639
CREATE FUNCTION profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
    SELECT SUM((retail_price - wholesale_price) * number_sold)
        FROM purchases
  $$
  ;

-- Example 23640
CREATE FUNCTION pi_udf()
  RETURNS FLOAT
  AS '3.141592654::FLOAT'
  ;

-- Example 23641
SELECT pi_udf();

-- Example 23642
SELECT pi_udf();
+-------------+
|    PI_UDF() |
|-------------|
| 3.141592654 |
+-------------+

-- Example 23643
CREATE TABLE purchases (number_sold INTEGER, wholesale_price NUMBER(7,2), retail_price NUMBER(7,2));
INSERT INTO purchases (number_sold, wholesale_price, retail_price) VALUES 
   (3,  10.00,  20.00),
   (5, 100.00, 200.00)
   ;

-- Example 23644
CREATE FUNCTION profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
    SELECT SUM((retail_price - wholesale_price) * number_sold)
        FROM purchases
  $$
  ;

-- Example 23645
SELECT profit();

-- Example 23646
SELECT profit();
+----------+
| PROFIT() |
|----------|
|   530.00 |
+----------+

-- Example 23647
CREATE TABLE circles (diameter FLOAT);

INSERT INTO circles (diameter) VALUES
    (2.0),
    (4.0);

CREATE FUNCTION diameter_to_radius(f FLOAT) 
  RETURNS FLOAT
  AS 
  $$ f / 2 $$
  ;

-- Example 23648
WITH
    radii AS (SELECT diameter_to_radius(diameter) AS radius FROM circles)
  SELECT radius FROM radii
    ORDER BY radius
  ;

-- Example 23649
+--------+
| RADIUS |
|--------|
|      1 |
|      2 |
+--------+

-- Example 23650
CREATE TABLE orders (product_ID varchar, quantity integer, price numeric(11, 2), buyer_info varchar);
CREATE TABLE inventory (product_ID varchar, quantity integer, price numeric(11, 2), vendor_info varchar);
INSERT INTO inventory (product_ID, quantity, price, vendor_info) VALUES 
  ('X24 Bicycle', 4, 1000.00, 'HelloVelo'),
  ('GreenStar Helmet', 8, 50.00, 'MellowVelo'),
  ('SoundFX', 5, 20.00, 'Annoying FX Corporation');
INSERT INTO orders (product_id, quantity, price, buyer_info) VALUES 
  ('X24 Bicycle', 1, 1500.00, 'Jennifer Juniper'),
  ('GreenStar Helmet', 1, 75.00, 'Donovan Liege'),
  ('GreenStar Helmet', 1, 75.00, 'Montgomery Python');

-- Example 23651
CREATE FUNCTION store_profit()
  RETURNS NUMERIC(11, 2)
  AS
  $$
  SELECT SUM( (o.price - i.price) * o.quantity) 
    FROM orders AS o, inventory AS i 
    WHERE o.product_id = i.product_id
  $$
  ;

-- Example 23652
SELECT store_profit();

-- Example 23653
SELECT store_profit();
+----------------+
| STORE_PROFIT() |
|----------------|
|         550.00 |
+----------------+

-- Example 23654
-- ----- These examples show a UDF called from different clauses ----- --

select MyFunc(column1) from table1;

select * from table1 where column2 > MyFunc(column1);

-- Example 23655
SET id_threshold = (SELECT COUNT(*)/2 FROM table1);

-- Example 23656
CREATE OR REPLACE FUNCTION my_filter_function()
RETURNS TABLE (id int)
AS
$$
SELECT id FROM table1 WHERE id > $id_threshold
$$
;

-- Example 23657
CREATE TABLE sales (
  customer   varchar,
  product    varchar,
  spend      decimal(20, 2),
  sale_date  date,
  region     varchar
);

-- Example 23658
CREATE TABLE security.salesmanagerregions (
  sales_manager varchar,
  region        varchar
);

-- Example 23659
USE ROLE SECURITYADMIN;

CREATE ROLE mapping_role;

GRANT SELECT ON TABLE security.salesmanagerregions TO ROLE mapping_role;

-- Example 23660
USE ROLE schema_owner_role;

CREATE OR REPLACE ROW ACCESS POLICY security.sales_policy
AS (sales_region varchar) RETURNS BOOLEAN ->
  'sales_executive_role' = CURRENT_ROLE()
    OR EXISTS (
      SELECT 1 FROM salesmanagerregions
        WHERE sales_manager = CURRENT_ROLE()
        AND region = sales_region
    )
;

-- Example 23661
GRANT OWNERSHIP ON ROW ACCESS POLICY security.sales_policy TO mapping_role;

GRANT APPLY ON ROW ACCESS POLICY security.sales_policy TO ROLE sales_analyst_role;

-- Example 23662
USE ROLE SECURITYADMIN;

ALTER TABLE sales ADD ROW ACCESS POLICY security.sales_policy ON (region);

-- Example 23663
GRANT SELECT ON TABLE sales TO ROLE sales_manager_role;

-- Example 23664
USE ROLE sales_manager_role;
SELECT product, SUM(spend)
FROM sales
WHERE YEAR(sale_date) = 2020
GROUP BY product;

-- Example 23665
CREATE OR REPLACE ROW ACCESS POLICY rap_NO_memoizable_function
  AS (region_id number, customer_id number, product_id number)
  RETURNS BOOLEAN ->
    EXISTS(SELECT 1 FROM regions WHERE id = region_id) OR
    EXISTS(SELECT 1 FROM customers WHERE id = customer_id) OR
    EXISTS(SELECT 1 FROM products WHERE id = product_id)
  ;

-- Example 23666
USE ROLE USERADMIN;

CREATE ROLE functions_admin;

-- Example 23667
USE ROLE SECURITYADMIN;

GRANT USAGE ON DATABASE governance TO ROLE functions_admin;

GRANT USAGE ON SCHEMA governance.functions TO ROLE functions_admin;

GRANT CREATE FUNCTION ON SCHEMA governance.functions TO ROLE functions_admin;

-- Example 23668
USE ROLE functions_admin;

USE SCHEMA governance.functions;

CREATE OR REPLACE function allowed_regions()
  RETURNS array
  memoizable
  AS 'SELECT ARRAY_AGG(id) FROM regions';

-- Example 23669
USE ROLE rap_admin;

CREATE OR REPLACE ROW ACCESS POLICY rap_with_memoizable_function
  AS (region_id number, customer_id number, product_id number)
  RETURNS BOOLEAN ->
    ARRAY_CONTAINS(region_id, allowed_regions()) OR
    ARRAY_CONTAINS(customer_id, allowed_customers()) OR
    ARRAY_CONTAINS(product_id, allowed_products())
  ;

-- Example 23670
CREATE OR REPLACE TABLE sales.tables.regional_managers (
  allowed_regions varchar
  allowed_roles varchar
);

-- Example 23671
INSERT INTO sales.tables.regional_managers
(allowed_regions, allowed_roles)
VALUES
('na', 'NA_MANAGER'),
('eu', 'EU_MANAGER'),
('apac', 'APAC_MANAGER');

-- Example 23672
CREATE OR REPLACE ROW ACCESS POLICY governance.policies.rap_map_exempt
AS (allowed_roles varchar) RETURNS BOOLEAN ->
IS_ROLE_IN_SESSION(allowed_roles);

-- Example 23673
ALTER TABLE sales.tables.regional_managers
  ADD ROW ACCESS POLICY governance.policies.rap_map_exempt
  ON (allowed_roles);

-- Example 23674
CREATE OR REPLACE ROW ACCESS POLICY governance.policies.rap_map_lookup
 AS (allowed_regions varchar) RETURNS BOOLEAN ->
 EXISTS (
   SELECT * FROM sales.tables.regional_managers
   WHERE
     REGION = allowed_regions
);

-- Example 23675
ALTER TABLE sales.tables.data
  ADD ROW ACCESS POLICY governance.policies.rap_map_lookup
  ON (allowed_regions);

-- Example 23676
USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE sales TO ROLE na_manager;
GRANT USAGE ON SCHEMA sales.tables TO ROLE na_manager;
GRANT SELECT ON TABLE sales.tables.regional_managers TO ROLE na_manager;
GRANT SELECT ON TABLE sales.tables.data TO ROLE na_manager;

-- Example 23677
FROM <left_table> ASOF JOIN <right_table>
  MATCH_CONDITION ( <left_table.timecol> <comparison_operator> <right_table.timecol> )
  [ ON <table.col> = <table.col> [ AND ... ] | USING ( <column_list> ) ]

-- Example 23678
->ASOF Join  joinKey: (S.LOCATION = R.LOCATION) AND (S.STATE = R.STATE),
  matchCondition: (S.OBSERVED >= R.OBSERVED)

-- Example 23679
CREATE OR REPLACE TABLE left_table (
  c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2)
);

CREATE OR REPLACE TABLE right_table (
  c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2)
);

INSERT INTO left_table VALUES
  ('A',1,'09:15:00',3.21),
  ('A',2,'09:16:00',3.22),
  ('B',1,'09:17:00',3.23),
  ('B',2,'09:18:00',4.23);

INSERT INTO right_table VALUES
  ('A',1,'09:14:00',3.19),
  ('B',1,'09:16:00',3.04);

-- Example 23680
SELECT * FROM left_table ORDER BY c1, c2;

-- Example 23681
+----+----+----------+------+
| C1 | C2 | C3       |   C4 |
|----+----+----------+------|
| A  |  1 | 09:15:00 | 3.21 |
| A  |  2 | 09:16:00 | 3.22 |
| B  |  1 | 09:17:00 | 3.23 |
| B  |  2 | 09:18:00 | 4.23 |
+----+----+----------+------+

-- Example 23682
SELECT * FROM right_table ORDER BY c1, c2;

-- Example 23683
+----+----+----------+------+
| C1 | C2 | C3       |   C4 |
|----+----+----------+------|
| A  |  1 | 09:14:00 | 3.19 |
| B  |  1 | 09:16:00 | 3.04 |
+----+----+----------+------+

-- Example 23684
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
    ON(l.c1=r.c1 and l.c2=r.c2)
  ORDER BY l.c1, l.c2;

-- Example 23685
+----+----+----------+------+------+------+----------+------+
| C1 | C2 | C3       |   C4 | C1   | C2   | C3       |   C4 |
|----+----+----------+------+------+------+----------+------|
| A  |  1 | 09:15:00 | 3.21 | A    |  1   | 09:14:00 | 3.19 |
| A  |  2 | 09:16:00 | 3.22 | NULL | NULL | NULL     | NULL |
| B  |  1 | 09:17:00 | 3.23 | B    |  1   | 09:16:00 | 3.04 |
| B  |  2 | 09:18:00 | 4.23 | NULL | NULL | NULL     | NULL |
+----+----+----------+------+------+------+----------+------+

-- Example 23686
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
  ORDER BY l.c1, l.c2;

-- Example 23687
+----+----+----------+------+----+----+----------+------+
| C1 | C2 | C3       |   C4 | C1 | C2 | C3       |   C4 |
|----+----+----------+------+----+----+----------+------|
| A  |  1 | 09:15:00 | 3.21 | A  |  1 | 09:14:00 | 3.19 |
| A  |  2 | 09:16:00 | 3.22 | B  |  1 | 09:16:00 | 3.04 |
| B  |  1 | 09:17:00 | 3.23 | B  |  1 | 09:16:00 | 3.04 |
| B  |  2 | 09:18:00 | 4.23 | B  |  1 | 09:16:00 | 3.04 |
+----+----+----------+------+----+----+----------+------+

-- Example 23688
CREATE OR REPLACE TABLE right_table
  (c1 VARCHAR(1),
  c2 TINYINT,
  c3 TIME,
  c4 NUMBER(3,2),
  right_id VARCHAR(2));

INSERT INTO right_table VALUES
  ('A',1,'09:14:00',3.19,'A1'),
  ('A',1,'09:14:00',3.19,'A2'),
  ('B',1,'09:16:00',3.04,'B1');

SELECT * FROM right_table ORDER BY 1, 2;

-- Example 23689
+----+----+----------+------+----------+
| C1 | C2 | C3       |   C4 | RIGHT_ID |
|----+----+----------+------+----------|
| A  |  1 | 09:14:00 | 3.19 | A1       |
| A  |  1 | 09:14:00 | 3.19 | A2       |
| B  |  1 | 09:16:00 | 3.04 | B1       |
+----+----+----------+------+----------+

-- Example 23690
SELECT *
  FROM left_table l ASOF JOIN right_table r
    MATCH_CONDITION(l.c3>=r.c3)
  ORDER BY l.c1, l.c2;

-- Example 23691
+----+----+----------+------+----+----+----------+------+----------+
| C1 | C2 | C3       |   C4 | C1 | C2 | C3       |   C4 | RIGHT_ID |
|----+----+----------+------+----+----+----------+------+----------|
| A  |  1 | 09:15:00 | 3.21 | A  |  1 | 09:14:00 | 3.19 | A2       |
| A  |  2 | 09:16:00 | 3.22 | B  |  1 | 09:16:00 | 3.04 | B1       |
| B  |  1 | 09:17:00 | 3.23 | B  |  1 | 09:16:00 | 3.04 | B1       |
| B  |  2 | 09:18:00 | 4.23 | B  |  1 | 09:16:00 | 3.04 | B1       |
+----+----+----------+------+----+----+----------+------+----------+

-- Example 23692
SELECT ...
  FROM t1
    ASOF JOIN t2
      MATCH_CONDITION(...)
      ON t1.c1 = t2.c1
  WHERE t1 ...;

