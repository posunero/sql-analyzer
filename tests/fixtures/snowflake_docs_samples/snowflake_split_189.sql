-- Example 12643
CREATE OR REPLACE TABLE hr_data (
    age INTEGER,
    email_address VARCHAR,
    fname VARCHAR,
    lname VARCHAR
    );

-- Example 12644
use role accountadmin;

create role data_engineer;

grant usage on database my_db to role data_engineer;

grant usage on schema my_db.my_schema to role data_engineer;

grant select, update on table my_db.my_schema.hr_data to role data_engineer;

grant database role snowflake.governance_admin to role data_engineer;

-- Example 12645
use role accountadmin;
create role policy_admin;
grant apply masking policy on account to role policy_admin;
grant database role snowflake.governance_viewer to role policy_admin;

-- Example 12646
USE ROLE data_engineer;

SELECT EXTRACT_SEMANTIC_CATEGORIES('my_db.my_schema.hr_data');

-- Example 12647
CALL ASSOCIATE_SEMANTIC_CATEGORY_TAGS(
   'my_db.my_schema.hr_data',
    EXTRACT_SEMANTIC_CATEGORIES('my_db.my_schema.hr_data')
);

-- Example 12648
USE ROLE data_engineer;

ALTER TABLE my_db.my_schema.hr_data
  MODIFY COLUMN fname
  SET TAG SNOWFLAKE.CORE.SEMANTIC_CATEGORY='NAME';

-- Example 12649
ALTER TABLE my_db.my_schema.hr_data
  MODIFY COLUMN fname
  SET TAG SNOWFLAKE.CORE.PRIVACY_CATEGORY='IDENTIFIER';

-- Example 12650
USE ROLE policy_admin;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
  WHERE TAG_NAME = 'PRIVACY_CATEGORY'
  AND TAG_VALUE = 'IDENTIFIER';

-- Example 12651
ALTER TABLE my_db.my_schema.hr_data
  MODIFY COLUMN fname
  SET MASKING POLICY governance.policies.identifier_mask;

-- Example 12652
USE ROLE SECURITYADMIN;

SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
    WHERE TAG_NAME = 'PRIVACY_CATEGORY'
    AND TAG_VALUE= 'IDENTIFIER';

REVOKE SELECT ON TABLE my_db.my_schema.hr_data FROM ROLE analyst;

-- Example 12653
create or replace procedure classify_schema(schema_name string, result_table string)
returns object language JavaScript
as $$
// 1
const table_names = snowflake.execute({
  sqlText: `show terse tables in schema identifier(?)`,
  binds: [SCHEMA_NAME],
});

// helper function for quoted table names
function quote(name) {
  return '"'+ name.replace(/"/g,'""') + '"';
}

// create table to store results in. if it already exists, we will add to it rather than overwrite
snowflake.execute({
    sqlText: `create temp table if not exists identifier(?) (table_name string, result variant)`,
    binds: [RESULT_TABLE],
})
// loop through tables
while (table_names.next()) {
  let name = table_names.getColumnValue('name');
  // add schema to table name
  name = SCHEMA_NAME + "." + quote(name);
  // insert qualified table name and result into result table
  const results = snowflake.execute({
    sqlText: `insert into identifier(?) select ?, extract_semantic_categories(?)`,
    binds: [RESULT_TABLE, name, name],
  });
}
// return the number of tables classified
return {tables_classified: table_names.getRowCount()};
$$;

-- Example 12654
create or replace procedure associate_tag_batch(result_table string)
returns Object language JavaScript
as $$
// get table names and classification results to loop through
const tags_to_apply = snowflake.execute({
  sqlText: `select table_name, result from identifier(?)`,
  binds: [RESULT_TABLE],
});

const out = {};
while (tags_to_apply.next()) {
  // get table name
  const name = tags_to_apply.getColumnValue('TABLE_NAME');
  // get classification result
  const classification_results = tags_to_apply.getColumnValue('RESULT');
  // call associate semantic category tags with table name and classification result
  const results = snowflake.execute({
    sqlText: `call associate_semantic_category_tags(?, parse_json(?))`,
    binds: [name, JSON.stringify(classification_results)],
  });
  results.next();
  out[name] = results.getColumnValue(1).split('\n');
}
// return number of tags applied per table
return out;
$$;

-- Example 12655
call classify_schema('my_db.my_schema','my_temporary_classification_table');

-- Example 12656
call associate_tag_batch('my_temporary_classification_table');

-- Example 12657
create or replace procedure classify_database(database_name string, result_table string)
returns Object language JavaScript
as $$
// get list of schemas in database
const schema_names = snowflake.execute({
  sqlText: `show terse schemas in database identifier(?)`,
  binds: [DATABASE_NAME],
});

// helper function for quoted schema names
function quote(name) {
  return '"'+ name.replace(/"/g,'""') + '"';
}

// counter for tables. will use result from classify_schema to increment
let table_count = 0
while (schema_names.next()) {
  let name = schema_names.getColumnValue('name');
  // skip the information schema
  if (name == "INFORMATION_SCHEMA") {
    continue;
  }
  // add database name to schema
  name = DATABASE_NAME + "." + quote(name);
  // call classify_schema on each schema. This will loop over tables in schema
  const results = snowflake.execute({
    sqlText: `call classify_schema(?, ?)`,
    binds: [name, RESULT_TABLE],
  });
  results.next();
  // increment total number of tables by the number of tables in the schema
  table_count += results.getColumnValue(1).tables_classified ;
}

return {
    tables_classified: table_count,
    // subtract one from number of schemas because we skip the information schema
    schemas_classified: schema_names.getRowCount() - 1,
};
$$;

-- Example 12658
call classify_database('my_db','my_temporary_classification_table');

-- Example 12659
call associate_tag_batch('my_temporary_classification_table');

-- Example 12660
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', {'auto_tag': true});

-- Example 12661
SELECT *
FROM TABLE(
  hr.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'hr.tables.empl_info',
    'table'
));

-- Example 12662
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'auto_tag': true});

-- Example 12663
SELECT SYSTEM$GET_CLASSIFICATION_RESULT('hr.tables.empl_info');

-- Example 12664
SELECT *
FROM TABLE(
  hr.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'hr.tables.empl_info',
    'table'
));

-- Example 12665
CREATE AGGREGATION POLICY my_agg_policy
  AS () RETURNS AGGREGATION_CONSTRAINT ->
  AGGREGATION_CONSTRAINT(MIN_GROUP_SIZE => 5);

-- Example 12666
ALTER TABLE viewership_log
  SET AGGREGATION POLICY my_agg_policy
  ENTITY KEY (first_name,last_name);

-- Example 12667
ALTER TABLE transactions ADD AGGREGATION POLICY ap ENTITY KEY (user_id, user_email);
ALTER TABLE transactions ADD AGGREGATION POLICY ap ENTITY KEY (vendor_id);

-- Example 12668
ALTER TABLE transactions ADD AGGREGATION POLICY ap ENTITY KEY (user_id) ENTITY KEY (vendor_id);

-- Example 12669
CREATE TABLE t1
  WITH AGGREGATION POLICY my_agg_policy
  ENTITY KEY (first_name,last_name);

-- Example 12670
SELECT age, name, zipcode FROM(                        -- Outermost query: my_agg_policy enforced.
  SELECT name, zipcode FROM T GROUP BY name, zipcode   -- Matches my_agg_policy entity key: my_agg_policy deferred
)
  GROUP BY age, name, zipcode;

-- Example 12671
WITH bucketed AS (
  SELECT
    CASE
      WHEN SUM(transaction_amount) BETWEEN 0 AND 100 THEN 'low'
      WHEN SUM(transaction_amount) BETWEEN 101 AND 100000 THEN 'high'
    END AS transaction_bucket,
    zipcode,               -- zipcode and email need not appear in the select list, but this lets us compute entity_count below
    email
  FROM my_transactions
  GROUP BY zipcode, email  -- This would not work if it was only GROUP BY zipcode, since the entity key is (zipcode, email)
)
SELECT
  transaction_bucket,
  COUNT(DISTINCT zipcode, email) AS entity_count
FROM
  bucketed
GROUP BY transaction_bucket;

-- Example 12672
user_id, vendor_id, zipcode, email,         transaction_amount
   1     1001       90000    a@example.com        100
   1     1001       90000    a@example.com         50
   2     2001       90001    b@example.com         12
   2     2001       90001    b@example.com          5
   3     3001       90002    c@example.com         40

-- Example 12673
WITH amounts AS (
  SELECT
    user_id,
    IFF(SUM(transaction_amount) > 50, 'high', 'low') AS bucket
  FROM T
  GROUP BY user_id -- user_policy is deferred, but vendor_policy is enforced
)
SELECT COUNT(*) FROM amounts GROUP BY bucket

-- Example 12674
-- Drop agg policy ap associated with entity key user_id
ALTER TABLE transactions DROP AGGREGATION POLICY ap ENTITY KEY (user_id)

-- Example 12675
-- Drop the agg policies associated with two separate keys
ALTER TABLE transactions DROP AGGREGATION POLICY ap ENTITY KEY (user_id)
ALTER TABLE transactions DROP AGGREGATION POLICY ap ENTITY KEY (vendor_id)

-- Example 12676
-- Drop agg policy ap from the table entirely
ALTER TABLE transactions DROP AGGREGATION POLICY ap

-- Example 12677
SELECT ...
FROM ...
[ ... ]
GROUP BY ROLLUP ( groupRollup [ , groupRollup [ , ... ] ] )
[ ... ]

-- Example 12678
groupRollup ::= { <column_alias> | <position> | <expr> }

-- Example 12679
-- Create some tables and insert some rows.
CREATE TABLE products (product_ID INTEGER, wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES 
    (1, 1.00),
    (2, 2.00);

CREATE TABLE sales (product_ID INTEGER, retail_price REAL, 
    quantity INTEGER, city VARCHAR, state VARCHAR);
INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES 
    (1, 2.00,  1, 'SF', 'CA'),
    (1, 2.00,  2, 'SJ', 'CA'),
    (2, 5.00,  4, 'SF', 'CA'),
    (2, 5.00,  8, 'SJ', 'CA'),
    (2, 5.00, 16, 'Miami', 'FL'),
    (2, 5.00, 32, 'Orlando', 'FL'),
    (2, 5.00, 64, 'SJ', 'PR');

-- Example 12680
SELECT state, city, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit 
 FROM products AS p, sales AS s
 WHERE s.product_ID = p.product_ID
 GROUP BY ROLLUP (state, city)
 ORDER BY state, city NULLS LAST
 ;
+-------+---------+--------+
| STATE | CITY    | PROFIT |
|-------+---------+--------|
| CA    | SF      |     13 |
| CA    | SJ      |     26 |
| CA    | NULL    |     39 |
| FL    | Miami   |     48 |
| FL    | Orlando |     96 |
| FL    | NULL    |    144 |
| PR    | SJ      |    192 |
| PR    | NULL    |    192 |
| NULL  | NULL    |    375 |
+-------+---------+--------+

-- Example 12681
SELECT ...
FROM ...
[ ... ]
GROUP BY CUBE ( groupCube [ , groupCube [ , ... ] ] )
[ ... ]

-- Example 12682
groupCube ::= { <column_alias> | <position> | <expr> }

-- Example 12683
-- Create some tables and insert some rows.
CREATE TABLE products (product_ID INTEGER, wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES 
    (1, 1.00),
    (2, 2.00);

CREATE TABLE sales (product_ID INTEGER, retail_price REAL, 
    quantity INTEGER, city VARCHAR, state VARCHAR);
INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES 
    (1, 2.00,  1, 'SF', 'CA'),
    (1, 2.00,  2, 'SJ', 'CA'),
    (2, 5.00,  4, 'SF', 'CA'),
    (2, 5.00,  8, 'SJ', 'CA'),
    (2, 5.00, 16, 'Miami', 'FL'),
    (2, 5.00, 32, 'Orlando', 'FL'),
    (2, 5.00, 64, 'SJ', 'PR');

-- Example 12684
SELECT state, city, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit 
 FROM products AS p, sales AS s
 WHERE s.product_ID = p.product_ID
 GROUP BY CUBE (state, city)
 ORDER BY state, city NULLS LAST
 ;
+-------+---------+--------+
| STATE | CITY    | PROFIT |
|-------+---------+--------|
| CA    | SF      |     13 |
| CA    | SJ      |     26 |
| CA    | NULL    |     39 |
| FL    | Miami   |     48 |
| FL    | Orlando |     96 |
| FL    | NULL    |    144 |
| PR    | SJ      |    192 |
| PR    | NULL    |    192 |
| NULL  | Miami   |     48 |
| NULL  | Orlando |     96 |
| NULL  | SF      |     13 |
| NULL  | SJ      |    218 |
| NULL  | NULL    |    375 |
+-------+---------+--------+

-- Example 12685
SELECT ...
FROM ...
[ ... ]
GROUP BY GROUPING SETS ( groupSet [ , groupSet [ , ... ] ] )
[ ... ]

-- Example 12686
groupSet ::= { <column_alias> | <position> | <expr> }

-- Example 12687
CREATE or replace TABLE nurses (
  ID INTEGER,
  full_name VARCHAR,
  medical_license VARCHAR,   -- LVN, RN, etc.
  radio_license VARCHAR      -- Technician, General, Amateur Extra
  )
  ;

INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (201, 'Thomas Leonard Vicente', 'LVN', 'Technician'),
    (202, 'Tamara Lolita VanZant', 'LVN', 'Technician'),
    (341, 'Georgeann Linda Vente', 'LVN', 'General'),
    (471, 'Andrea Renee Nouveau', 'RN', 'Amateur Extra')
    ;

-- Example 12688
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

-- Example 12689
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        3 | LVN             | NULL          |
|        1 | RN              | NULL          |
|        2 | NULL            | Technician    |
|        1 | NULL            | General       |
|        1 | NULL            | Amateur Extra |
+----------+-----------------+---------------+

-- Example 12690
INSERT INTO nurses
    (ID, full_name, medical_license, radio_license)
  VALUES
    (101, 'Lily Vine', 'LVN', NULL),
    (102, 'Larry Vancouver', 'LVN', NULL),
    (172, 'Rhonda Nova', 'RN', NULL)
    ;

-- Example 12691
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY GROUPING SETS (medical_license, radio_license);

-- Example 12692
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        5 | LVN             | NULL          |
|        2 | RN              | NULL          |
|        2 | NULL            | Technician    |
|        1 | NULL            | General       |
|        1 | NULL            | Amateur Extra |
|        3 | NULL            | NULL          |
+----------+-----------------+---------------+

-- Example 12693
SELECT COUNT(*), medical_license, radio_license
  FROM nurses
  GROUP BY medical_license, radio_license;

-- Example 12694
+----------+-----------------+---------------+
| COUNT(*) | MEDICAL_LICENSE | RADIO_LICENSE |
|----------+-----------------+---------------|
|        2 | LVN             | Technician    |
|        1 | LVN             | General       |
|        1 | RN              | Amateur Extra |
|        2 | LVN             | NULL          |
|        1 | RN              | NULL          |
+----------+-----------------+---------------+

-- Example 12695
-- Uncorrelated subquery:
SELECT c1, c2
  FROM table1 WHERE c1 = (SELECT MAX(x) FROM table2);

-- Correlated subquery:
SELECT c1, c2
  FROM table1 WHERE c1 = (SELECT x FROM table2 WHERE y = table1.c2);

-- Example 12696
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p
  WHERE p.annual_wage < (SELECT per_capita_GDP
                           FROM international_GDP
                           WHERE name = 'Brazil');

-- Example 12697
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p
  WHERE p.annual_wage < (SELECT MAX(per_capita_GDP)
                           FROM international_GDP i
                           WHERE p.country = i.name);

-- Example 12698
SELECT employee_id
FROM employees
WHERE salary = (SELECT max(salary) FROM employees);

-- Example 12699
SELECT p.name, p.annual_wage, p.country
  FROM pay AS p INNER JOIN (SELECT name, per_capita_GDP
                              FROM international_GDP
                              WHERE per_capita_GDP >= 10000.0) AS pcg
    ON pcg.per_capita_GDP = p.annual_wage AND p.country = pcg.name;

-- Example 12700
for each row in left_hand_table LHT:
    execute right_hand_subquery RHS using the values from the current row in the LHT

-- Example 12701
SELECT ...
FROM <left_hand_table_expression>, LATERAL ( <inline_view> )
...

-- Example 12702
SELECT *
  FROM table_reference_me, LATERAL (...), table_do_not_reference_me ...

-- Example 12703
FROM departments AS d INNER JOIN LATERAL (...)

-- Example 12704
CREATE TABLE departments (department_id INTEGER, name VARCHAR);
CREATE TABLE employees (employee_ID INTEGER, last_name VARCHAR,
  department_ID INTEGER, project_names ARRAY);

INSERT INTO departments (department_ID, name) VALUES
  (1, 'Engineering'),
  (2, 'Support');
INSERT INTO employees (employee_ID, last_name, department_ID) VALUES
  (101, 'Richards', 1),
  (102, 'Paulson',  1),
  (103, 'Johnson',  2);

-- Example 12705
SELECT *
  FROM departments AS d,
    LATERAL (SELECT * FROM employees AS e WHERE e.department_ID = d.department_ID) AS iv2
  ORDER BY employee_ID;

-- Example 12706
+---------------+-------------+-------------+-----------+---------------+---------------+
| DEPARTMENT_ID | NAME        | EMPLOYEE_ID | LAST_NAME | DEPARTMENT_ID | PROJECT_NAMES |
|---------------+-------------+-------------+-----------+---------------+---------------|
|             1 | Engineering |         101 | Richards  |             1 | NULL          |
|             1 | Engineering |         102 | Paulson   |             1 | NULL          |
|             2 | Support     |         103 | Johnson   |             2 | NULL          |
+---------------+-------------+-------------+-----------+---------------+---------------+

-- Example 12707
SELECT *
  FROM departments AS d INNER JOIN
    LATERAL (SELECT * FROM employees AS e WHERE e.department_ID = d.department_ID) AS iv2
  ORDER BY employee_ID;

-- Example 12708
CREATE [ OR REPLACE ] AGGREGATION POLICY [ IF NOT EXISTS ] <name>
  AS () RETURNS AGGREGATION_CONSTRAINT -> <body>
  [ COMMENT = '<string_literal>' ]

-- Example 12709
AGGREGATION_CONSTRAINT (
    { MIN_GROUP_SIZE => <integer_expression>
    | MIN_ROW_COUNT => <integer_expression>, MIN_ENTITY_COUNT => <integer_expression>
    }
)

