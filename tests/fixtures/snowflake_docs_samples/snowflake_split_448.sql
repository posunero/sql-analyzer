-- Example 29988
FAILURE: Uncaught exception of type 'BUDGET_ALREADY_ACTIVATED' on line X at position X

-- Example 29989
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_CONFIG();

-- Example 29990
-20000 (P0001): Uncaught exception of type 'NO_PERMISSION_TO_ACTIVATE_BUDGET' on line X at position X

-- Example 29991
FAILURE: SQL access control error: Insufficient privileges to operate on class 'BUDGET'

-- Example 29992
FAILURE: Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 :
Uncaught exception of type 'UNSUPPORTED_BUDGET_TYPE' on line X at position X

-- Example 29993
FAILURE: Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 :
Uncaught exception of type 'UNSUPPORTED_BUDGET_TYPE' on line X at position X

-- Example 29994
-20000 (P0001): Uncaught exception of type 'FUNCTION_NOT_SUPPORTED_FOR_ACCOUNT_ROOT_BUDGET' on line 11 at position 18

-- Example 29995
-20000 (P0001): Uncaught exception of type 'ACCOUNT_ROOT_BUDGET_NOT_ACTIVATED' on line X at position X

-- Example 29996
002141 (42601): SQL compilation error:
Unknown user-defined function <budget_db>.<budget_schema>.<budget_name>!ADD_RESOURCE

-- Example 29997
002003 (02000): SQL compilation error:
<object_type> '<object_name>' does not exist or not authorized.

-- Example 29998
Uncaught exception of type 'EXPRESSION_ERROR' on line 10 at position 21 :
Privilege 'APPLYBUDGET' is not authorized on the reference object.

-- Example 29999
505001 (55000): Uncaught exception of type 'EXPRESSION_ERROR' on line 10
at position 21 : Specified object does not exist or not authorized for
the reference.

-- Example 30000
Unknown user-defined function <database_name>.<schema_name>.<budget_name>.SET_EMAIL_NOTIFICATIONS

-- Example 30001
Integration '<INTEG_NAME>' does not exist or not authorized.

-- Example 30002
FAILURE: Uncaught exception of type 'EXPRESSION_ERROR' on line 16 at position 34 : Following email address(es) are not
allowed by the email integration <INTEGRATION_NAME>: [<email>]

-- Example 30003
Email recipients in the given list at indexes [<index_list>] are not allowed. Either these email addresses are not yet validated
or do not belong to any user in the current account.

-- Example 30004
001044 (42P13): SQL compilation error: error line 0 at position -1 Invalid argument types for function 'GET_SERVICE_TYPE_USAGE':
(VARCHAR(X), VARCHAR(X), VARCHAR(X), VARCHAR(X))

-- Example 30005
002151 (22023): Uncaught exception of type 'STATEMENT_ERROR' on line 16 at position 23 : SQL compilation error:
[:TIME_DEPART] is not a valid date/time component for function DATE_TRUNC.

-- Example 30006
100094 (22000): Uncaught exception of type 'STATEMENT_ERROR' on line 16 at position 23 : Unknown timezone: '<invalid_timezone>'

-- Example 30007
FAILURE: SQL compilation error: Class 'SNOWFLAKE.CORE.BUDGET' does not exist or not authorized.

-- Example 30008
000002 (0A000): Uncaught exception of type 'STATEMENT_ERROR' on line 0 at position -1 : Unsupported feature 'TOK_RESOURCE_GROUP'.

-- Example 30009
USE ROLE admin;
GRANT USAGE ON DATABASE admin_db TO ROLE analyst;
GRANT USAGE ON SCHEMA admin_schema TO ROLE analyst;
GRANT CREATE SNOWFLAKE.ML.CLASSIFICATION ON SCHEMA admin_db.admin_schema TO ROLE analyst;

-- Example 30010
USE ROLE analyst;
USE SCHEMA admin_db.admin_schema;

-- Example 30011
USE ROLE analyst;
CREATE SCHEMA analyst_db.analyst_schema;
USE SCHEMA analyst_db.analyst_schema;

-- Example 30012
REVOKE CREATE SNOWFLAKE.ML.CLASSIFICATION ON SCHEMA admin_db.admin_schema FROM ROLE analyst;

-- Example 30013
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION <model_name>(...);

-- Example 30014
SELECT <model_name>!PREDICT(...);

-- Example 30015
CALL <model_name>!SHOW_EVALUATION_METRICS();
CALL <model_name>!SHOW_GLOBAL_EVALUATION_METRICS();
CALL <model_name>!SHOW_THRESHOLD_METRICS();
CALL <model_name>!SHOW_CONFUSION_MATRIX();

-- Example 30016
CALL <model_name>!SHOW_FEATURE_IMPORTANCE();

-- Example 30017
CALL <model_name>!SHOW_TRAINING_LOGS();

-- Example 30018
SHOW SNOWFLAKE.ML.CLASSIFICATION;

-- Example 30019
DROP SNOWFLAKE.ML.CLASSIFICATION <model_name>;

-- Example 30020
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

-- Example 30021
CREATE OR REPLACE view binary_classification_view AS
    SELECT user_interest_score, user_rating, label
FROM training_purchase_data;
SELECT * FROM binary_classification_view ORDER BY RANDOM(42) LIMIT 5;

-- Example 30022
+---------------------+-------------+-------+
| USER_INTEREST_SCORE | USER_RATING | LABEL |
|---------------------+-------------+-------|
| 5                   |           4 | False |
| 8                   |           8 | True  |
| 6                   |           5 | False |
| 7                   |           7 | True  |
| 7                   |           4 | False |
+---------------------+-------------+-------+

-- Example 30023
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_binary(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
    TARGET_COLNAME => 'label'
);

-- Example 30024
SELECT model_binary!PREDICT(INPUT_DATA => {*})
    AS prediction FROM prediction_purchase_data;

-- Example 30025
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

-- Example 30026
SELECT *, model_binary!PREDICT(INPUT_DATA => {*})
    AS predictions FROM prediction_purchase_data;

-- Example 30027
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

-- Example 30028
CREATE OR REPLACE VIEW multiclass_classification_view AS
    SELECT user_interest_score, user_rating, class
FROM training_purchase_data;
SELECT * FROM multiclass_classification_view ORDER BY RANDOM(42) LIMIT 10;

-- Example 30029
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

-- Example 30030
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model_multiclass(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'multiclass_classification_view'),
    TARGET_COLNAME => 'class'
);

-- Example 30031
SELECT *, model_multiclass!PREDICT(INPUT_DATA => {*})
    AS predictions FROM prediction_purchase_data;

-- Example 30032
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

-- Example 30033
CREATE OR REPLACE TABLE my_predictions AS
SELECT *, model_multiclass!PREDICT(INPUT_DATA => {*}) AS predictions FROM prediction_purchase_data;

SELECT * FROM my_predictions;

-- Example 30034
SELECT
    predictions:class AS predicted_class,
    ROUND(predictions:probability:not_interested,4) AS not_interested_class_probability,
    ROUND(predictions['probability']['purchase'],4) AS purchase_class_probability,
    ROUND(predictions['probability']['add_to_wishlist'],4) AS add_to_wishlist_class_probability
FROM my_predictions
LIMIT 5;

-- Example 30035
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

-- Example 30036
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model(
    INPUT_DATA => SYSTEM$REFERENCE('view', 'binary_classification_view'),
    TARGET_COLNAME => 'label',
    CONFIG_OBJECT => {'evaluate': TRUE}
);

-- Example 30037
CALL model!SHOW_EVALUATION_METRICS();
CALL model!SHOW_GLOBAL_EVALUATION_METRICS();
CALL model!SHOW_THRESHOLD_METRICS();
CALL model!SHOW_CONFUSION_MATRIX();

-- Example 30038
CALL model_multiclass!SHOW_EVALUATION_METRICS();

-- Example 30039
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

-- Example 30040
CALL model_multiclass!SHOW_GLOBAL_EVALUATION_METRICS();

-- Example 30041
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

-- Example 30042
CALL model_multiclass!SHOW_CONFUSION_MATRIX();

-- Example 30043
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

-- Example 30044
CALL model_multiclass!SHOW_FEATURE_IMPORTANCE();

-- Example 30045
+------+---------------------+---------------+---------------+
| RANK | FEATURE             |         SCORE | FEATURE_TYPE  |
|------+---------------------+---------------+---------------|
|    1 | USER_RATING         | 0.9186571982  | user_provided |
|    2 | USER_INTEREST_SCORE | 0.08134280181 | user_provided |
+------+---------------------+---------------+---------------+

-- Example 30046
USE ROLE r1;
CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION model(
    INPUT_DATA => SYSTEM$REFERENCE('TABLE', 'test_classification_dataset'),
    TARGET_COLNAME => 'LABEL'
);

-- Example 30047
USE ROLE r2;
SELECT model!PREDICT(1);    -- privilege error

-- Example 30048
USE ROLE r1;
GRANT SNOWFLAKE.ML.CLASSIFICATION ROLE model!mlconsumer TO ROLE r2;

USE ROLE r2;
CALL model!PREDICT(
    INPUT_DATA => system$query_reference(
    'SELECT {*} FROM test_classification_dataset')
);

-- Example 30049
USE ROLE r3;
CALL model!SHOW_EVALUATION_METRICS();   -- privilege error

-- Example 30050
USE ROLE r1;
GRANT SNOWFLAKE.ML.CLASSIFICATION ROLE model!mladmin TO ROLE r3;

USE ROLE r3;
CALL model!SHOW_EVALUATION_METRICS();

-- Example 30051
USE ROLE r1;
REVOKE SNOWFLAKE.ML.CLASSIFICATION ROLE model!mlconsumer FROM ROLE r2;
REVOKE SNOWFLAKE.ML.CLASSIFICATION ROLE model!mladmin FROM ROLE r3;

-- Example 30052
SHOW GRANTS TO SNOWFLAKE.ML.CLASSIFICATION ROLE <model_name>!mladmin;
SHOW GRANTS TO SNOWFLAKE.ML.CLASSIFICATION ROLE <model_name>!mlconsumer;

-- Example 30053
CALL model_binary!SHOW_CONFUSION_MATRIX();

-- Example 30054
+--------------+--------------+-----------------+-------+------+
| DATASET_TYPE | ACTUAL_CLASS | PREDICTED_CLASS | COUNT | LOGS |
|--------------+--------------+-----------------+-------+------|
| EVAL         | false        | false           |    37 | NULL |
| EVAL         | false        | true            |     1 | NULL |
| EVAL         | true         | false           |     0 | NULL |
| EVAL         | true         | true            |    22 | NULL |
+--------------+--------------+-----------------+-------+------+

