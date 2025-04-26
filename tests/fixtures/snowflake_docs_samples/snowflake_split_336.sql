-- Example 22490
SELECT COUNT(*)
  FROM patients
  LEFT JOIN (SELECT zip_code, ANY_VALUE(state) AS residence_state
            FROM geo_lookup
            GROUP BY zip_code)
  USING zip_code
  WHERE birth_state = residence_state;

-- Example 22491
SELECT COUNT(*)
  FROM patients
  WHERE insurance_type = 'Commercial';

-- Example 22492
SELECT COUNT(DISTINCT patient_id)
  FROM patients
  WHERE insurance_type = 'Commercial';

-- Example 22493
SELECT COUNT(bmi)
  FROM (SELECT patient_id, ANY_VALUE(zip_code) AS zip_code
    FROM patients
    GROUP BY patient_id) AS p
  JOIN geo_lookup AS g
    ON p.zip_code = g.zip_code
  WHERE state='CA';

-- Example 22494
SELECT COUNT(bmi)
  FROM (SELECT patient_id, ANY_VALUE(bmi) as bmi, ANY_VALUE(state) as state
      FROM patients AS p
      JOIN geo_lookup AS g
        ON p.zip_code = g.zip_code
      GROUP BY patient_id)
  WHERE state='CA';

-- Example 22495
SELECT COUNT(num_visits)
  FROM (SELECT COUNT((visit_reason<>'Regular checkup')::INT) AS num_visits
        WHERE visit_reason IS NOT NULL
        GROUP BY patient_id)
  WHERE num_visits > 0 AND num_visits < 20;

-- Example 22496
SELECT COUNT(num_claims) AS count_claims,
    DP_INTERVAL_LOW(count_claims),
    DP_INTERVAL_HIGH(count_claims)
FROM t1;

-- Example 22497
+----------------+----------------------------------+----------------------------------+
|  count_claims  |  dp_interval_low("count_claims") |  dp_interval_high("count_claims")|
|----------------+----------------------------------+----------------------------------+
|  50            |  35                              |    75                            |
+----------------+----------------------------------+----------------------------------+

-- Example 22498
SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 22499
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 996               |     233      |     WEEKLY    |     0.0      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 22500
SELECT COUNT(salary) FROM my_table;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 22501
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 995               |     233      |     WEEKLY    |     0.6      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 22502
SELECT COUNT(salary), COUNT(age) FROM my_table GROUP BY STATE;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 22503
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 993               |     233      |     WEEKLY    |     1.8      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 22504
SELECT COUNT(salary), COUNT(age) FROM T GROUP BY STATE;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 22505
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 991               |     233      |     WEEKLY    |     3.0      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 22506
SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();

-- Example 22507
+---------------------+--------------------+------------------+
| CURRENT_WAREHOUSE() | CURRENT_DATABASE() | CURRENT_SCHEMA() |
|---------------------+--------------------+------------------+
| MY_WAREHOUSE        | MY_DB              | PUBLIC           |
|---------------------+--------------------+------------------+

-- Example 22508
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;

-- Example 22509
+--------------+--------------+-------------------------------+
| CURRENT_DATE | CURRENT_TIME | CURRENT_TIMESTAMP             |
|--------------+--------------+-------------------------------|
| 2024-06-07   | 10:45:15     | 2024-06-07 10:45:15.064 -0700 |
+--------------+--------------+-------------------------------+

-- Example 22510
EXECUTE IMMEDIATE
$$
DECLARE
  currdate DATE;
BEGIN
  SELECT CURRENT_DATE INTO currdate;
  RETURN currdate;
END;
$$
;

-- Example 22511
+-----------------+
| anonymous block |
|-----------------|
| 2024-06-07      |
+-----------------+

-- Example 22512
EXECUTE IMMEDIATE
$$
DECLARE
  today DATE;
BEGIN
  today := CURRENT_DATE;
  RETURN today;
END;
$$
;

-- Example 22513
000904 (42000): SQL compilation error: error line 5 at position 11
invalid identifier 'CURRENT_DATE'

-- Example 22514
EXECUTE IMMEDIATE
$$
DECLARE
  today DATE;
BEGIN
  today := CURRENT_DATE();
  RETURN today;
END;
$$
;

-- Example 22515
+-----------------+
| anonymous block |
|-----------------|
| 2024-06-07      |
+-----------------+

-- Example 22516
SELECT * FROM TABLE(get_widgets_function()) ORDER BY created_on;

------+-----------------------+-------+-------+-------------------------------+
  ID  |         NAME          | COLOR | PRICE |          CREATED_ON           |
------+-----------------------+-------+-------+-------------------------------+
...
 315  | Small round widget    | Red   | 1     | 2017-01-07 15:22:14.810 -0700 |
 1455 | Small cylinder widget | Blue  | 2     | 2017-01-15 03:00:12.106 -0700 |
...

-- Example 22517
SHOW FUNCTIONS LIKE 'MYFUNCTION';

-- Example 22518
SELECT *
    FROM widgets_view
    WHERE 1/iff(color = 'Purple', 0, 1) = 1;

-- Example 22519
select table_catalog, table_schema, table_name, is_secure
    from mydb.information_schema.views
    where table_name = 'MYVIEW';

-- Example 22520
select table_catalog, table_schema, table_name, is_secure
    from snowflake.account_usage.views
    where table_name = 'MYVIEW';

-- Example 22521
SHOW VIEWS LIKE 'myview';

-- Example 22522
SHOW MATERIALIZED VIEWS LIKE 'my_mv';

-- Example 22523
CREATE TABLE widgets (
    id NUMBER(38,0) DEFAULT widget_id_sequence.nextval, 
    name VARCHAR,
    color VARCHAR,
    price NUMBER(38,0),
    created_on TIMESTAMP_LTZ(9));
CREATE TABLE widget_access_rules (
    widget_id NUMBER(38,0),
    role_name VARCHAR);
CREATE OR REPLACE SECURE VIEW widgets_view AS
    SELECT w.*
        FROM widgets AS w
        WHERE w.id IN (SELECT widget_id
                           FROM widget_access_rules AS a
                           WHERE upper(role_name) = CURRENT_ROLE()
                      )
    ;

-- Example 22524
SELECT *
    FROM widgets_view
    WHERE 1/iff(color = 'Purple', 0, 1) = 1;

-- Example 22525
select * from widgets_view order by created_on;

------+-----------------------+-------+-------+-------------------------------+
  ID  |         NAME          | COLOR | PRICE |          CREATED_ON           |
------+-----------------------+-------+-------+-------------------------------+
...
 315  | Small round widget    | Red   | 1     | 2017-01-07 15:22:14.810 -0700 |
 1455 | Small cylinder widget | Blue  | 2     | 2017-01-15 03:00:12.106 -0700 |
...

-- Example 22526
USE ROLE ACCOUNTADMIN;
GRANT APPLICATION ROLE SNOWFLAKE.DATA_QUALITY_MONITORING_VIEWER TO ROLE analyst;

-- Example 22527
SELECT COUNT(age) AS count_age where age >= 20 and age <= 100 FROM t1 GROUP BY score

-- Example 22528
SELECT COUNT(score_derived)
  FROM (SELECT score, score_derived FROM t1 WHERE score <= 2);

-- Example 22529
----------------------------
|"count(""SCORE_DERIVED"")"|
----------------------------
|31                        |
----------------------------

-- Example 22530
SELECT COUNT(num_scores)
  FROM (SELECT COUNT(score) AS num_scores
    FROM t1
    GROUP BY age)
  WHERE num_scores >= 0 AND num_scores <= 100;

-- Example 22531
SELECT * FROM projects ORDER BY project_ID;
+------------+------------------+
| PROJECT_ID | PROJECT_NAME     |
|------------+------------------|
|       1000 | COVID-19 Vaccine |
|       1001 | Malaria Vaccine  |
|       1002 | NewProject       |
+------------+------------------+

-- Example 22532
SELECT * FROM employees ORDER BY employee_ID;
+-------------+-----------------+------------+
| EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|-------------+-----------------+------------|
|    10000001 | Terry Smith     | 1000       |
|    10000002 | Maria Inverness | 1000       |
|    10000003 | Pat Wang        | 1001       |
|    10000004 | NewEmployee     | NULL       |
+-------------+-----------------+------------+

-- Example 22533
SELECT p.project_ID, project_name, employee_ID, employee_name, e.project_ID
    FROM projects AS p JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------+------------------+-------------+-----------------+------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|------------+------------------+-------------+-----------------+------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     | 1000       |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness | 1000       |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        | 1001       |
+------------+------------------+-------------+-----------------+------------+

-- Example 22534
table1 join (table2 join table 3)

-- Example 22535
SELECT p.project_ID, project_name, employee_ID, employee_name, e.project_ID
    FROM projects AS p INNER JOIN employees AS e
        ON e.project_id = p.project_id
    ORDER BY p.project_ID, e.employee_ID;
+------------+------------------+-------------+-----------------+------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   | PROJECT_ID |
|------------+------------------+-------------+-----------------+------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     | 1000       |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness | 1000       |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        | 1001       |
+------------+------------------+-------------+-----------------+------------+

-- Example 22536
SELECT p.project_name, e.employee_name
    FROM projects AS p LEFT OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NewProject       | NULL            |
+------------------+-----------------+

-- Example 22537
SELECT p.project_name, e.employee_name
    FROM projects AS p RIGHT OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NULL             | NewEmployee     |
+------------------+-----------------+

-- Example 22538
SELECT p.project_name, e.employee_name
    FROM projects AS p FULL OUTER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_name, e.employee_name;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Terry Smith     |
| Malaria Vaccine  | Pat Wang        |
| NewProject       | NULL            |
| NULL             | NewEmployee     |
+------------------+-----------------+

-- Example 22539
SELECT p.project_name, e.employee_name
    FROM projects AS p CROSS JOIN employees AS e
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| COVID-19 Vaccine | Pat Wang        |
| COVID-19 Vaccine | NewEmployee     |
| Malaria Vaccine  | Terry Smith     |
| Malaria Vaccine  | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
| Malaria Vaccine  | NewEmployee     |
| NewProject       | Terry Smith     |
| NewProject       | Maria Inverness |
| NewProject       | Pat Wang        |
| NewProject       | NewEmployee     |
+------------------+-----------------+

-- Example 22540
SELECT p.project_name, e.employee_name
    FROM projects AS p CROSS JOIN employees AS e
    WHERE e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
+------------------+-----------------+

-- Example 22541
SELECT p.project_name, e.employee_name
    FROM projects AS p INNER JOIN employees AS e
        ON e.project_ID = p.project_ID
    ORDER BY p.project_ID, e.employee_ID;
+------------------+-----------------+
| PROJECT_NAME     | EMPLOYEE_NAME   |
|------------------+-----------------|
| COVID-19 Vaccine | Terry Smith     |
| COVID-19 Vaccine | Maria Inverness |
| Malaria Vaccine  | Pat Wang        |
+------------------+-----------------+

-- Example 22542
SELECT *
    FROM projects NATURAL JOIN employees
    ORDER BY employee_ID;
+------------+------------------+-------------+-----------------+
| PROJECT_ID | PROJECT_NAME     | EMPLOYEE_ID | EMPLOYEE_NAME   |
|------------+------------------+-------------+-----------------|
|       1000 | COVID-19 Vaccine |    10000001 | Terry Smith     |
|       1000 | COVID-19 Vaccine |    10000002 | Maria Inverness |
|       1001 | Malaria Vaccine  |    10000003 | Pat Wang        |
+------------+------------------+-------------+-----------------+

-- Example 22543
WHERE product = 'hackeysack' OR product = 'frisbee'

-- Example 22544
WHERE product IN ('hackeysack', 'frisbee')

-- Example 22545
WHERE a < 10 AND a >= 0

-- Example 22546
GREATEST(LEAST(a, 100), 0) AS clamped_a

-- Example 22547
WHERE product = 'hackeysack' OR product = 'frisbee'

-- Example 22548
WHERE product IN ('hackeysack', 'frisbee')

-- Example 22549
WHERE a < 10 AND a >= 0

-- Example 22550
GREATEST(LEAST(a, 100), 0) AS clamped_a

-- Example 22551
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts', MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 22552
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts',
  BUDGET_LIMIT=>300,
  MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 22553
003139=SQL compilation error:\nIntegration ''{0}'' associated with the stage ''{1}'' cannot be found.

-- Example 22554
091093 (55000): External table ''{0}'' marked invalid. Stage ''{1}'' location altered.

-- Example 22555
Fine-tuning trained tokens = number of input tokens * number of epochs trained

-- Example 22556
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FINE_TUNING_USAGE_HISTORY;

