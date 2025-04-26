-- Example 22758
CREATE OR REPLACE SECRET my_pagerduty_webhook_secret
  TYPE = GENERIC_STRING
  SECRET_STRING = 'xxxxxxxx';

-- Example 22759
https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX

-- Example 22760
CREATE OR REPLACE NOTIFICATION INTEGRATION my_slack_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://hooks.slack.com/services/SNOWFLAKE_WEBHOOK_SECRET'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_slack_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 22761
https://mymsofficehost.webhook.office.com/webhookb2/xxxxxxxx

-- Example 22762
CREATE OR REPLACE NOTIFICATION INTEGRATION my_teams_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://mymsofficehost.webhook.office.com/webhookb2/SNOWFLAKE_WEBHOOK_SECRET'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_teams_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 22763
https://events.pagerduty.com/v2/enqueue

-- Example 22764
CREATE OR REPLACE NOTIFICATION INTEGRATION my_pagerduty_webhook_int
  TYPE=WEBHOOK
  ENABLED=TRUE
  WEBHOOK_URL='https://events.pagerduty.com/v2/enqueue'
  WEBHOOK_SECRET=my_secrets_db.my_secrets_schema.my_pagerduty_webhook_secret
  WEBHOOK_BODY_TEMPLATE='{
    "routing_key": "SNOWFLAKE_WEBHOOK_SECRET",
    "event_action": "trigger",
    "payload": {
      "summary": "SNOWFLAKE_WEBHOOK_MESSAGE",
      "source": "Snowflake monitoring",
      "severity": "INFO"
    }
  }'
  WEBHOOK_HEADERS=('Content-Type'='application/json');

-- Example 22765
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN(
    SNOWFLAKE.NOTIFICATION.SANITIZE_WEBHOOK_CONTENT('my message')
  ),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_slack_webhook_int')
);

-- Example 22766
CREATE OR REPLACE NOTIFICATION INTEGRATION my_slack_webhook_int
  ...
  WEBHOOK_BODY_TEMPLATE='{"text": "SNOWFLAKE_WEBHOOK_MESSAGE"}'
  ...

-- Example 22767
{"text": "my message"}

-- Example 22768
SELECT APPROX_COUNT_DISTINCT(column1) FROM table1;

-- Example 22769
SELECT COUNT(DISTINCT c1), COUNT(DISTINCT c2) FROM test_table;

-- Example 22770
CREATE OR REPLACE TABLE search_optimization_collation_demo (
  en_ci_col VARCHAR COLLATE 'en-ci',
  utf_8_col VARCHAR COLLATE 'utf8');

INSERT INTO search_optimization_collation_demo VALUES (
  'test_collation_1',
  'test_collation_2');

-- Example 22771
ALTER TABLE search_optimization_collation_demo
  ADD SEARCH OPTIMIZATION ON EQUALITY(en_ci_col, utf_8_col);

-- Example 22772
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col = 'test_collation_2';

-- Example 22773
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col COLLATE 'de-ci' = 'test_collation_2';

-- Example 22774
SELECT *
  FROM search_optimization_collation_demo
  WHERE utf_8_col = 'test_collation_2' COLLATE 'de-ci';

-- Example 22775
-- Supported predicate
-- (where the string '2020-01-01' is implicitly cast to a date)
WHERE timestamp1 = '2020-01-01';

-- Supported predicate
-- (where the string '2020-01-01' is explicitly cast to a date)
WHERE timestamp1 = '2020-01-01'::date;

-- Example 22776
-- Unsupported predicate
-- (where values in a VARCHAR column are cast to DATE)
WHERE to_date(varchar_column) = '2020-01-01';

-- Example 22777
-- Supported predicate
-- (where values in a numeric column are cast to a string)
WHERE cast(numeric_column as varchar) = '2'

-- Example 22778
GRANT ADD SEARCH OPTIMIZATION ON SCHEMA <schema_name> TO ROLE <role>

-- Example 22779
ALTER TABLE <name> ADD SEARCH OPTIMIZATION
  ON FULL_TEXT( { * | <col1> [ , <col2>, ... ] } [ , ANALYZER => '<analyzer_name>' ]);

-- Example 22780
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 22781
DESCRIBE SEARCH OPTIMIZATION ON lines;

-- Example 22782
+---------------+----------------------------+-----------+------------------+--------+
| expression_id | method                     | target    | target_data_type | active |
|---------------+----------------------------+-----------+------------------+--------|
|             1 | FULL_TEXT DEFAULT_ANALYZER | PLAY      | VARCHAR(50)      | true   |
|             2 | FULL_TEXT DEFAULT_ANALYZER | CHARACTER | VARCHAR(30)      | true   |
|             3 | FULL_TEXT DEFAULT_ANALYZER | LINE      | VARCHAR(2000)    | true   |
+---------------+----------------------------+-----------+------------------+--------+

-- Example 22783
ALTER TABLE ipt ADD SEARCH OPTIMIZATION ON FULL_TEXT(ip1, ANALYZER => 'ENTITY_ANALYZER');

-- Example 22784
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 22785
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON play, character, line;

-- Example 22786
ALTER TABLE lines DROP SEARCH OPTIMIZATION
  ON 1, 2, 3;

-- Example 22787
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2, c3);

-- Example 22788
-- This statement is equivalent to the previous statement.
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), EQUALITY(c2, c3);

-- Example 22789
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(*);

-- Example 22790
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1, c2), SUBSTRING(c3);

-- Example 22791
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1), SUBSTRING(c1);

-- Example 22792
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c4:user.uuid);

-- Example 22793
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON GEO(c1);

-- Example 22794
ALTER TABLE test_table ADD SEARCH OPTIMIZATION;

-- Example 22795
SHOW TABLES LIKE '%test_table%';

-- Example 22796
ALTER TABLE t1 ADD SEARCH OPTIMIZATION ON EQUALITY(c1);

-- Example 22797
DESCRIBE SEARCH OPTIMIZATION ON t1;

-- Example 22798
+---------------+----------+--------+------------------+--------+
| expression_id |  method  | target | target_data_type | active |
+---------------+----------+--------+------------------+--------+
| 1             | EQUALITY | C1     | NUMBER(38,0)     | true   |
+---------------+----------+--------+------------------+--------+

-- Example 22799
DESCRIBE SEARCH OPTIMIZATION ON t1;

-- Example 22800
+---------------+-----------+-----------+-------------------+--------+
| expression_id |  method   | target    | target_data_type  | active |
+---------------+-----------+-----------+-------------------+--------+
|             1 | EQUALITY  | C1        | NUMBER(38,0)      | true   |
|             2 | EQUALITY  | C2        | VARCHAR(16777216) | true   |
|             3 | EQUALITY  | C4        | NUMBER(38,0)      | true   |
|             4 | EQUALITY  | C5        | VARCHAR(16777216) | true   |
|             5 | EQUALITY  | V1        | VARIANT           | true   |
|             6 | SUBSTRING | C2        | VARCHAR(16777216) | true   |
|             7 | SUBSTRING | C5        | VARCHAR(16777216) | true   |
|             8 | GEO       | G1        | GEOGRAPHY         | true   |
|             9 | EQUALITY  | V1:"key1" | VARIANT           | true   |
|            10 | EQUALITY  | V1:"key2" | VARIANT           | true   |
+---------------+-----------+-----------+-------------------+--------+

-- Example 22801
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON SUBSTRING(c2);

-- Example 22802
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON c5;

-- Example 22803
ALTER TABLE t1 DROP SEARCH OPTIMIZATION ON EQUALITY(c1), 6, 8;

-- Example 22804
ALTER TABLE [IF EXISTS] <table_name> DROP SEARCH OPTIMIZATION;

-- Example 22805
ALTER TABLE test_table DROP SEARCH OPTIMIZATION;

-- Example 22806
DESCRIBE SEARCH OPTIMIZATION ON <table_name>;

-- Example 22807
Search optimization service was not used because no
match was found between used predicates and the
search access paths added for the table.

-- Example 22808
DESCRIBE SEARCH OPTIMIZATION ON <table_name>;

-- Example 22809
Search optimization service was not used because the
cost was higher than a table scan for this query.

-- Example 22810
Search optimization service was not used because the
predicate limit was exceeded.

-- Example 22811
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(mycol);

-- Example 22812
ALTER TABLE mytable ADD SEARCH OPTIMIZATION;

-- Example 22813
SELECT * FROM test_table WHERE id = 3;

-- Example 22814
SELECT id, c1, c2, c3
  FROM test_table
  WHERE id IN (2, 3)
  ORDER BY id;

-- Example 22815
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(mycol);

-- Example 22816
ALTER TABLE mytable ADD SEARCH OPTIMIZATION;

-- Example 22817
SELECT sales.date, customer.name
  FROM sales JOIN customers ON (sales.customer_id = customers.customer_id)
  WHERE customers.customer_id = 2094;

-- Example 22818
SELECT sales.date, product.name
  FROM sales JOIN products ON (sales.product_id = product.old_id * 100)
  WHERE product.category = 'Cutlery';

-- Example 22819
SELECT sales.date, product.name
  FROM sales JOIN products ON (sales.product_id = product.id and sales.location = product.place_of_production)
  WHERE product.category = 'Cutlery';

-- Example 22820
SELECT sales.date, product.name
  FROM sales JOIN products ON (sales.product_id = product.id)
  WHERE product.category = 'Cutlery'
  AND sales.location = 'Buenos Aires';

-- Example 22821
ALTER TABLE mytable ADD SEARCH OPTIMIZATION ON EQUALITY(mycol);

-- Example 22822
ALTER TABLE mytable ADD SEARCH OPTIMIZATION;

-- Example 22823
SELECT employee_id
  FROM employees
  WHERE salary = (
    SELECT MAX(salary)
      FROM employees
      WHERE department = 'Engineering');

-- Example 22824
SELECT *
  FROM products
  WHERE products.product_id = (
    SELECT product_id
      FROM sales
      GROUP BY product_id
      ORDER BY COUNT(product_id) DESC
      LIMIT 1);

