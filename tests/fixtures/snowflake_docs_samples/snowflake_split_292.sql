-- Example 19542
CALL snowflake.local.account_root_budget!SET_SPENDING_LIMIT(500);

-- Example 19543
CALL my_database.my_schema.my_budget!SET_SPENDING_LIMIT(100);

-- Example 19544
CREATE [ OR REPLACE ] SNOWFLAKE.ML.CLASSIFICATION [ IF NOT EXISTS ] <model_name> (
    INPUT_DATA => <input_data>,
    TARGET_COLNAME => '<target_colname>',
    [CONFIG_OBJECT => <config_object>],
)
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19545
DROP SNOWFLAKE.ML.CLASSIFICATION [ IF EXISTS ] <name>

-- Example 19546
DROP SNOWFLAKE.ML.CLASSIFICATION my_model;

-- Example 19547
{
  SHOW SNOWFLAKE.ML.CLASSIFICATION           |
  SHOW SNOWFLAKE.ML.CLASSIFICATION INSTANCES
}
                                 [ LIKE <pattern> ]
                                 [ IN
                                     {
                                         ACCOUNT                  |

                                         DATABASE                 |
                                         DATABASE <database_name> |

                                         SCHEMA                   |
                                         SCHEMA <schema_name>     |
                                         <schema_name>
                                      }
                                  ]

-- Example 19548
<model_name>!PREDICT(
    INPUT_DATA => <input_data>,
    [CONFIG_OBJECT => <config_object>]
)

-- Example 19549
SELECT model_binary!PREDICT(INPUT_DATA => {*})
    as prediction from prediction_purchase_data;

-- Example 19550
<model_name>!SHOW_FEATURE_IMPORTANCE();

-- Example 19551
<model_name>!SHOW_TRAINING_LOGS();

-- Example 19552
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.CLASSIFICATION ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 19553
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 19554
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 19555
REVOKE CREATE SNOWFLAKE.ML.CLASSIFICATION ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 19556
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION <model_name>(...);

-- Example 19557
SELECT <model_name>!PREDICT(...);

-- Example 19558
CALL <model_name>!SHOW_EVALUATION_METRICS();
CALL <model_name>!SHOW_GLOBAL_EVALUATION_METRICS();
CALL <model_name>!SHOW_THRESHOLD_METRICS();
CALL <model_name>!SHOW_CONFUSION_MATRIX();

-- Example 19559
CALL <model_name>!SHOW_FEATURE_IMPORTANCE();

-- Example 19560
CALL <model_name>!SHOW_TRAINING_LOGS();

-- Example 19561
SHOW SNOWFLAKE.ML.CLASSIFICATION;

-- Example 19562
DROP SNOWFLAKE.ML.CLASSIFICATION <model_name>;

-- Example 19563
CREATE OR REPLACE TABLE training_purchase_data AS (
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(0, 3, RANDOM()) AS user_rating,
        FALSE AS label,
        'not_interested' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(3, 7, RANDOM()) AS user_rating,
        FALSE AS label,
        'add_to_wishlist' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(7, 10, RANDOM()) AS user_rating,
        TRUE AS label,
        'purchase' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
);

CREATE OR REPLACE table prediction_purchase_data AS (
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(0, 3, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(3, 7, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS user_interest_score,
        UNIFORM(7, 10, RANDOM()) AS user_rating
    FROM TABLE(GENERATOR(rowCount => 100))
);

-- Example 19564
CREATE OR REPLACE view binary_classification_view AS
    SELECT user_interest_score, user_rating, label
FROM training_purchase_data;
SELECT * FROM binary_classification_view ORDER BY RANDOM(42) LIMIT 5;

-- Example 19565
+---------------------+-------------+-------+
| USER_INTEREST_SCORE | USER_RATING | LABEL |
|---------------------+-------------+-------|
| 5                   |           4 | False |
| 8                   |           8 | True  |
| 6                   |           5 | False |
| 7                   |           7 | True  |
| 7                   |           4 | False |
+---------------------+-------------+-------+

-- Example 19566
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_binary(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
    TARGET_COLNAME => 'label'
);

-- Example 19567
SELECT model_binary!PREDICT(INPUT_DATA => {*})
    AS prediction FROM prediction_purchase_data;

-- Example 19568
+-------------------------------------+
| PREDICTION                          |
|-------------------------------------|
| {                                   |
|   "class": "True",                  |
|   "logs": null,                     |
|   "probability": {                  |
|     "False": 1.828038600000000e-03, |
|     "True": 9.981719614000000e-01   |
|   }                                 |
| }                                   |
| {                                   |
|   "class": "False",                 |
|   "logs": null,                     |
|   "probability": {                  |
|     "False": 9.992944771000000e-01, |
|     "True": 7.055229000000000e-04   |
|   }                                 |
| }                                   |
| {                                   |
|   "class": "True",                  |
|   "logs": null,                     |
|   "probability": {                  |
|     "False": 3.429796010000000e-02, |
|     "True": 9.657020399000000e-01   |
|   }                                 |
| }                                   |
| {                                   |
|   "class": "False",                 |
|   "logs": null,                     |
|   "probability": {                  |
|     "False": 9.992687686000000e-01, |
|     "True": 7.312314000000000e-04   |
|   }                                 |
| }                                   |
| {                                   |
|   "class": "False",                 |
|   "logs": null,                     |
|   "probability": {                  |
|     "False": 9.992951615000000e-01, |
|     "True": 7.048385000000000e-04   |
|   }                                 |
| }                                   |
+-------------------------------------+

-- Example 19569
SELECT *, model_binary!PREDICT(INPUT_DATA => {*})
    AS predictions FROM prediction_purchase_data;

-- Example 19570
+---------------------+-------------+-------------------------------------+
| USER_INTEREST_SCORE | USER_RATING | PREDICTIONS                         |
|---------------------+-------------+-------------------------------------|
| 9                   |           8 | {                                   |
|                     |             |   "class": "True",                  |
|                     |             |   "logs": null,                     |
|                     |             |   "probability": {                  |
|                     |             |     "False": 1.828038600000000e-03, |
|                     |             |     "True": 9.981719614000000e-01   |
|                     |             |   }                                 |
|                     |             | }                                   |
| 3                   |           0 | {                                   |
|                     |             |   "class": "False",                 |
|                     |             |   "logs": null,                     |
|                     |             |   "probability": {                  |
|                     |             |     "False": 9.992944771000000e-01, |
|                     |             |     "True": 7.055229000000000e-04   |
|                     |             |   }                                 |
|                     |             | }                                   |
| 10                  |           7 | {                                   |
|                     |             |   "class": "True",                  |
|                     |             |   "logs": null,                     |
|                     |             |   "probability": {                  |
|                     |             |     "False": 3.429796010000000e-02, |
|                     |             |     "True": 9.657020399000000e-01   |
|                     |             |   }                                 |
|                     |             | }                                   |
| 6                   |           6 | {                                   |
|                     |             |   "class": "False",                 |
|                     |             |   "logs": null,                     |
|                     |             |   "probability": {                  |
|                     |             |     "False": 9.992687686000000e-01, |
|                     |             |     "True": 7.312314000000000e-04   |
|                     |             |   }                                 |
|                     |             | }                                   |
| 1                   |           3 | {                                   |
|                     |             |   "class": "False",                 |
|                     |             |   "logs": null,                     |
|                     |             |   "probability": {                  |
|                     |             |     "False": 9.992951615000000e-01, |
|                     |             |     "True": 7.048385000000000e-04   |
|                     |             |   }                                 |
|                     |             | }                                   |
+---------------------+-------------+-------------------------------------+

-- Example 19571
CREATE OR REPLACE VIEW multiclass_classification_view AS
    SELECT user_interest_score, user_rating, class
FROM training_purchase_data;
SELECT * FROM multiclass_classification_view ORDER BY RANDOM(42) LIMIT 10;

-- Example 19572
+---------------------+-------------+-----------------+
| USER_INTEREST_SCORE | USER_RATING | CLASS           |
|---------------------+-------------+-----------------|
| 5                   |           4 | add_to_wishlist |
| 8                   |           8 | purchase        |
| 6                   |           5 | add_to_wishlist |
| 7                   |           7 | purchase        |
| 7                   |           4 | add_to_wishlist |
| 1                   |           1 | not_interested  |
| 2                   |           1 | not_interested  |
| 7                   |           3 | add_to_wishlist |
| 2                   |           0 | not_interested  |
| 0                   |           1 | not_interested  |
+---------------------+-------------+-----------------+

-- Example 19573
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_multiclass(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'multiclass_classification_view'),
    TARGET_COLNAME => 'class'
);

-- Example 19574
SELECT *, model_multiclass!PREDICT(INPUT_DATA => {*})
    AS predictions FROM prediction_purchase_data;

-- Example 19575
+---------------------+-------------+-----------------------------------------------+
| USER_INTEREST_SCORE | USER_RATING | PREDICTIONS                                   |
|---------------------+-------------+-----------------------------------------------|
| 9                   |           8 | {                                             |
|                     |             |   "class": "purchase",                        |
|                     |             |   "logs": null,                               |
|                     |             |   "probability": {                            |
|                     |             |     "add_to_wishlist": 3.529288000000000e-04, |
|                     |             |     "not_interested": 2.259768000000000e-04,  |
|                     |             |     "purchase": 9.994210944000000e-01         |
|                     |             |   }                                           |
|                     |             | }                                             |
| 3                   |           0 | {                                             |
|                     |             |   "class": "not_interested",                  |
|                     |             |   "logs": null,                               |
|                     |             |   "probability": {                            |
|                     |             |     "add_to_wishlist": 3.201690000000000e-04, |
|                     |             |     "not_interested": 9.994749885000000e-01,  |
|                     |             |     "purchase": 2.048425000000000e-04         |
|                     |             |   }                                           |
|                     |             | }                                             |
| 10                  |           7 | {                                             |
|                     |             |   "class": "purchase",                        |
|                     |             |   "logs": null,                               |
|                     |             |   "probability": {                            |
|                     |             |     "add_to_wishlist": 1.271809310000000e-02, |
|                     |             |     "not_interested": 3.992673600000000e-03,  |
|                     |             |     "purchase": 9.832892333000000e-01         |
|                     |             |   }                                           |
|                     |             | }                                             |
| 6                   |           6 | {                                             |
|                     |             |   "class": "add_to_wishlist",                 |
|                     |             |   "logs": null,                               |
|                     |             |   "probability": {                            |
|                     |             |     "add_to_wishlist": 9.999112027000000e-01, |
|                     |             |     "not_interested": 4.612520000000000e-05,  |
|                     |             |     "purchase": 4.267210000000000e-05         |
|                     |             |   }                                           |
|                     |             | }                                             |
| 1                   |           3 | {                                             |
|                     |             |   "class": "not_interested",                  |
|                     |             |   "logs": null,                               |
|                     |             |   "probability": {                            |
|                     |             |     "add_to_wishlist": 2.049559150000000e-02, |
|                     |             |     "not_interested": 9.759854413000000e-01,  |
|                     |             |     "purchase": 3.518967300000000e-03         |
|                     |             |   }                                           |
|                     |             | }                                             |
+---------------------+-------------+-----------------------------------------------+

-- Example 19576
CREATE OR REPLACE TABLE my_predictions AS
SELECT *, model_multiclass!PREDICT(INPUT_DATA => {*}) AS predictions FROM prediction_purchase_data;

SELECT * FROM my_predictions;

-- Example 19577
SELECT
    predictions:class AS predicted_class,
    ROUND(predictions:probability:not_interested,4) AS not_interested_class_probability,
    ROUND(predictions['probability']['purchase'],4) AS purchase_class_probability,
    ROUND(predictions['probability']['add_to_wishlist'],4) AS add_to_wishlist_class_probability
FROM my_predictions
LIMIT 5;

-- Example 19578
+-------------------+----------------------------------+----------------------------+-----------------------------------+
| PREDICTED_CLASS   | NOT_INTERESTED_CLASS_PROBABILITY | PURCHASE_CLASS_PROBABILITY | ADD_TO_WISHLIST_CLASS_PROBABILITY |
|-------------------+----------------------------------+----------------------------+-----------------------------------|
| "purchase"        |                           0.0002 |                     0.9994 |                            0.0004 |
| "not_interested"  |                           0.9995 |                     0.0002 |                            0.0003 |
| "purchase"        |                           0.0002 |                     0.9994 |                            0.0004 |
| "purchase"        |                           0.0002 |                     0.9994 |                            0.0004 |
| "not_interested"  |                           0.9994 |                     0.0002 |                            0.0004 |
| "purchase"        |                           0.0002 |                     0.9994 |                            0.0004 |
| "add_to_wishlist" |                           0      |                     0      |                            0.9999 |
| "add_to_wishlist" |                           0.4561 |                     0.0029 |                            0.5409 |
| "purchase"        |                           0.0002 |                     0.9994 |                            0.0004 |
| "not_interested"  |                           0.9994 |                     0.0002 |                            0.0003 |
+-------------------+----------------------------------+----------------------------+-----------------------------------+

-- Example 19579
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
    TARGET_COLNAME => 'label',
    CONFIG_OBJECT => {'evaluate': TRUE}
);

-- Example 19580
CALL model!SHOW_EVALUATION_METRICS();
CALL model!SHOW_GLOBAL_EVALUATION_METRICS();
CALL model!SHOW_THRESHOLD_METRICS();
CALL model!SHOW_CONFUSION_MATRIX();

-- Example 19581
CALL model_multiclass!SHOW_EVALUATION_METRICS();

-- Example 19582
+--------------+-----------------+--------------+---------------+------+
| DATASET_TYPE | CLASS           | ERROR_METRIC |  METRIC_VALUE | LOGS |
|--------------+-----------------+--------------+---------------+------|
| EVAL         | add_to_wishlist | precision    |  0.8888888889 | NULL |
| EVAL         | add_to_wishlist | recall       |  1            | NULL |
| EVAL         | add_to_wishlist | f1           |  0.9411764706 | NULL |
| EVAL         | add_to_wishlist | support      | 16            | NULL |
| EVAL         | not_interested  | precision    |  1            | NULL |
| EVAL         | not_interested  | recall       |  0.9090909091 | NULL |
| EVAL         | not_interested  | f1           |  0.9523809524 | NULL |
| EVAL         | not_interested  | support      | 22            | NULL |
| EVAL         | purchase        | precision    |  1            | NULL |
| EVAL         | purchase        | recall       |  1            | NULL |
| EVAL         | purchase        | f1           |  1            | NULL |
| EVAL         | purchase        | support      | 22            | NULL |
+--------------+-----------------+--------------+---------------+------+

-- Example 19583
CALL model_multiclass!SHOW_GLOBAL_EVALUATION_METRICS();

-- Example 19584
+--------------+--------------+--------------+---------------+------+
| DATASET_TYPE | AVERAGE_TYPE | ERROR_METRIC |  METRIC_VALUE | LOGS |
|--------------+--------------+--------------+---------------+------|
| EVAL         | macro        | precision    | 0.962962963   | NULL |
| EVAL         | macro        | recall       | 0.9696969697  | NULL |
| EVAL         | macro        | f1           | 0.964519141   | NULL |
| EVAL         | macro        | auc          | 0.9991277911  | NULL |
| EVAL         | weighted     | precision    | 0.9703703704  | NULL |
| EVAL         | weighted     | recall       | 0.9666666667  | NULL |
| EVAL         | weighted     | f1           | 0.966853408   | NULL |
| EVAL         | weighted     | auc          | 0.9991826156  | NULL |
| EVAL         | NULL         | log_loss     | 0.06365200147 | NULL |
+--------------+--------------+--------------+---------------+------+

-- Example 19585
CALL model_multiclass!SHOW_CONFUSION_MATRIX();

-- Example 19586
+--------------+-----------------+-----------------+-------+------+
| DATASET_TYPE | ACTUAL_CLASS    | PREDICTED_CLASS | COUNT | LOGS |
|--------------+-----------------+-----------------+-------+------|
| EVAL         | add_to_wishlist | add_to_wishlist |    16 | NULL |
| EVAL         | add_to_wishlist | not_interested  |     0 | NULL |
| EVAL         | add_to_wishlist | purchase        |     0 | NULL |
| EVAL         | not_interested  | add_to_wishlist |     2 | NULL |
| EVAL         | not_interested  | not_interested  |    20 | NULL |
| EVAL         | not_interested  | purchase        |     0 | NULL |
| EVAL         | purchase        | add_to_wishlist |     0 | NULL |
| EVAL         | purchase        | not_interested  |     0 | NULL |
| EVAL         | purchase        | purchase        |    22 | NULL |
+--------------+-----------------+-----------------+-------+------+

-- Example 19587
CALL model_multiclass!SHOW_FEATURE_IMPORTANCE();

-- Example 19588
+------+---------------------+---------------+---------------+
| RANK | FEATURE             |         SCORE | FEATURE_TYPE  |
|------+---------------------+---------------+---------------|
|    1 | USER_RATING         | 0.9186571982  | user_provided |
|    2 | USER_INTEREST_SCORE | 0.08134280181 | user_provided |
+------+---------------------+---------------+---------------+

-- Example 19589
USE ROLE r1;
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model(
    INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'test_classification_dataset'),
    TARGET_COLNAME => 'LABEL'
);

-- Example 19590
USE ROLE r2;
SELECT model!PREDICT(1);    -- privilege error

-- Example 19591
USE ROLE r1;
GRANT SNOWFLAKE.ML.CLASSIFICATION ROLE model!mlconsumer TO ROLE r2;

USE ROLE r2;
CALL model!PREDICT(
    INPUT_DATA => system$query_reference(
    'SELECT {*} FROM test_classification_dataset')
);

-- Example 19592
USE ROLE r3;
CALL model!SHOW_EVALUATION_METRICS();   -- privilege error

-- Example 19593
USE ROLE r1;
GRANT SNOWFLAKE.ML.CLASSIFICATION ROLE model!mladmin TO ROLE r3;

USE ROLE r3;
CALL model!SHOW_EVALUATION_METRICS();

-- Example 19594
USE ROLE r1;
REVOKE SNOWFLAKE.ML.CLASSIFICATION ROLE model!mlconsumer FROM ROLE r2;
REVOKE SNOWFLAKE.ML.CLASSIFICATION ROLE model!mladmin FROM ROLE r3;

-- Example 19595
SHOW GRANTS TO SNOWFLAKE.ML.CLASSIFICATION ROLE <model_name>!mladmin;
SHOW GRANTS TO SNOWFLAKE.ML.CLASSIFICATION ROLE <model_name>!mlconsumer;

-- Example 19596
CALL model_binary!SHOW_CONFUSION_MATRIX();

-- Example 19597
+--------------+--------------+-----------------+-------+------+
| DATASET_TYPE | ACTUAL_CLASS | PREDICTED_CLASS | COUNT | LOGS |
|--------------+--------------+-----------------+-------+------|
| EVAL         | false        | false           |    37 | NULL |
| EVAL         | false        | true            |     1 | NULL |
| EVAL         | true         | false           |     0 | NULL |
| EVAL         | true         | true            |    22 | NULL |
+--------------+--------------+-----------------+-------+------+

-- Example 19598
CALL model_binary!SHOW_FEATURE_IMPORTANCE();

-- Example 19599
+------+---------------------+---------------+---------------+
| RANK | FEATURE             |         SCORE | FEATURE_TYPE  |
|------+---------------------+---------------+---------------|
|    1 | USER_RATING         | 0.9295302013  | user_provided |
|    2 | USER_INTEREST_SCORE | 0.07046979866 | user_provided |
+------+---------------------+---------------+---------------+

-- Example 19600
CREATE [ OR REPLACE ] SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  [ IF NOT EXISTS ] <classification_profile_name> (  <config_object> )

-- Example 19601
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days': 0,
      'maximum_classification_validity_days': 30,
      'auto_tag': true
    });

-- Example 19602
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE my_classification_profile(
  {
    'minimum_object_age_for_classification_days':0,
    'auto_tag':true,
    'tag_map':{
      'column_tag_map':[
        {
          'tag_name':'tag_db.sch.pii'
        }
      ]
    }
  }
);

-- Example 19603
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days':0,
      'auto_tag':true,
      'tag_map': {
        'column_tag_map':[
          {
            'tag_name':'test_ac_db.test_ac_schema.pii',
            'tag_value':'important',
            'semantic_categories':['NAME']
          },
          {
            'tag_name':'test_ac_db.test_ac_schema.pii',
            'tag_value':'pii',
            'semantic_categories':['EMAIL','NATIONAL_IDENTIFIER']
          }
        ]
      }
    }
  );

-- Example 19604
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE my_classification_profile(
  {
    'minimum_object_age_for_classification_days':0,
    'auto_tag':true,
    'custom_classifiers': {
      'medical_codes': medical_codes!list(),
      'finance_codes': finance_codes!list()
    }
  }
);

-- Example 19605
DROP SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  [ IF EXISTS ] <classification_profile_name>

-- Example 19606
DROP SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE my_classification_profile;

-- Example 19607
SHOW SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  [ LIKE <pattern> ]
  [ IN
    {
      ACCOUNT                  |

      DATABASE                 |
      DATABASE <database_name> |

      SCHEMA                   |
      SCHEMA <schema_name>     |
      <schema_name>
    }
  ]

-- Example 19608
SHOW SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE;

