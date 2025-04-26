-- Example 10165
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_custom_template');

-- Example 10166
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10167
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10168
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10169
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10170
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10171
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10172
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

-- Example 10173
SET cleanroom_name = 'UI Registration ML Clean room';

-- Example 10174
CALL samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10175
CALL samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10176
CALL samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10177
CALL samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10178
CALL samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['samooha_provider_sample_database.lookalike_modeling.customers']);

-- Example 10179
USE ROLE accountadmin;
CALL samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
USE ROLE samooha_app_role;

-- Example 10180
CALL samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10181
SELECT * FROM <PROVIDER_TABLE> LIMIT 10;

-- Example 10182
CALL samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['samooha_provider_sample_database.lookalike_modeling.customers:hashed_email']);

-- Example 10183
CALL samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10184
CALL samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'lookalike_train',
    ['input_data variant', 'labels variant'],
    ['pandas', 'numpy', 'xgboost'],
    'variant',
    'train',
$$
import numpy as np
import pandas as pd
import xgboost
from sklearn import preprocessing
import sys
import os
import pickle
import codecs
import threading


class TrainXGBoostClassifier(object):
    def __init__(self):
        self.model = None
        self._params = {
            "objective": "binary:logistic",
            "max_depth": 3,
            "nthread": 1,
            "eval_metric": "auc",
        }
        self.num_boosting_rounds = 10

    def get_params(self):
        if self.model is not None and "updater" not in self._params:
            self._params.update(
                {"process_type": "update", "updater": "refresh", "refresh_leaf": True}
            )
        return self._params

    def train(self, X, y):
        # Train the model in a threadsafe way

        # pick only the categorical attributes
        categorical = X.select_dtypes(include=[object])

        # fit a one-hot-encoder to convert categorical features to binary features (required by XGBoost)
        ohe = preprocessing.OneHotEncoder()
        categorical_ohe = ohe.fit_transform(categorical)
        self.ohe = ohe

        # get the rest of the features and add them to the binary features
        non_categorical = X.select_dtypes(exclude=[object])
        train_x = np.concatenate((categorical_ohe.toarray(), non_categorical.to_numpy()), axis=1)

        xg_train = xgboost.DMatrix(train_x, label=y)

        params = self.get_params()
        params["eval_metric"] = "auc"
        evallist = [(xg_train, "train")]
        evals_result = {}

        self.model = xgboost.train(
            params, xg_train, self.num_boosting_rounds, evallist, evals_result=evals_result
        )

        self.evals_result = evals_result

    def __dump_model(self, model):
        # Save down the model as a json string to load up for scoring/inference

        pickle_jar = codecs.encode(pickle.dumps([model, self.ohe]), "base64").decode()
        return pickle_jar

    def dump_model(self):
        # Save down the model as a json string to load up for scoring/inference
        if self.model is not None:
            return self.__dump_model(self.model)
        else:
            raise ValueError("Model needs to be trained first")


def train(d1, l1):
    # get take training features and put them in a pandas dataframe
    X = pd.DataFrame(d1)

    # get the labels into a Numpy array
    y = np.array(l1)

    trainer = TrainXGBoostClassifier()
    trainer.train(X, y)

    # return training stats, accuracy, and the pickled model and pickled one-hot-encoder
    return {
        "total_rows": len(d1),
        "total_bytes_in": sys.getsizeof(d1),
        "model": trainer.dump_model(),
        "iteration": trainer.num_boosting_rounds,
        "auc": np.max(trainer.evals_result["train"]["auc"]),
        "error": 1 - np.max(trainer.evals_result["train"]["auc"])
    }   
$$);

-- Example 10185
CALL samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'lookalike_score',
    ['pickle_jar variant', 'emails variant', 'features variant'],
    ['pandas', 'numpy', 'xgboost', 'scikit-learn'],
    'string',
    'score',
$$
import numpy as np
import pandas as pd
import xgboost as xgb
import pickle
import codecs
import json


def score(model, emails, features):
    # load model
    model = model[0] if not isinstance(model, str) else model
    model = pickle.loads(codecs.decode(model.encode(), "base64"))

    # retrieve the XGBoost trainer from the pickle jar
    bst = model[0]

    # retrieve the fitted one-hot-encoder from the pickle jar
    ohe2 = model[1]

    # create pandas dataframe from the inference features
    Y = pd.DataFrame(features)

    # select the categorical attributes and one-hot-encode them
    Y1 = Y.select_dtypes(include=[object])
    Y2 = ohe2.transform(Y1)

    # select the non-categorical attributes
    Y3 = Y.select_dtypes(exclude=[object])

    # join the results of the one-hot encoding to the rest of the attributes
    Y_pred = np.concatenate((Y2.toarray(), Y3.to_numpy()), axis=1)

    # inference
    dscore = xgb.DMatrix(Y_pred)
    pred = bst.predict(dscore)

    retval = list(zip(np.array(emails), list(map(str, pred))))
    retval = [{"email": r[0], "score": r[1]} for r in retval]
    return json.dumps(retval)  
$$);

-- Example 10186
-- See the versions available inside the cleanroom
SHOW VERSIONS IN APPLICATION PACKAGE samooha_cleanroom_UI_Registration_ML_clean_room;

-- Once the security scan is approved, update the release directive to the latest version
CALL samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '2');

-- Example 10187
CALL samooha_by_snowflake_local_db.provider.add_custom_sql_template($cleanroom_name, 'prod_custom_lookalike_template',
$$
WITH
features AS (
    SELECT
        identifier({{ provider_join_col | join_policy }}) AS joincol,
        array_construct({{ dimensions[0] | sqlsafe }} {% for feat in dimensions[1:] %} , {{ feat | sqlsafe }} {% endfor %}) AS features
    FROM
        identifier({{ source_table[0] }}) AS p
),
labels AS (
    SELECT
        c.{{ consumer_join_col | sqlsafe }} AS joincol,
        c.{{ filter_column | default('SALES_DLR') | sqlsafe }} {{ operator | default('>=') | sqlsafe }} {{ filter_value | default(2000) | sqlsafe }} AS label_value
    FROM
        identifier({{ my_table[0] }}) AS c
),
trained_model AS (
    SELECT
        train_out:model::varchar AS model,
        train_out:error::float AS error
    FROM (
      SELECT
        cleanroom.{{ lookalike_train_function | default('lookalike_train') | sqlsafe }}(array_agg(f.features), array_agg(l.label_value)) AS train_out
      FROM features f, labels l
      WHERE f.joincol = l.joincol
    )
),
inference_output AS (
    SELECT
        MOD(seq4(), 100) AS batch,
        cleanroom.{{ lookalike_score_function | default('lookalike_score') | sqlsafe }}(
            array_agg(distinct t.model), 
            array_agg(identifier({{ provider_join_col | join_policy }})), 
            array_agg(array_construct( identifier({{ dimensions[0] }}) {% for feat in dimensions[1:] %} , identifier({{ feat }}) {% endfor %}) )
        ) AS scores
    FROM trained_model t, identifier({{ source_table[0] }}) p
    WHERE identifier({{ provider_join_col | join_policy }}) NOT IN (SELECT c.{{ consumer_join_col | sqlsafe }} FROM identifier({{ my_table[0] }}) c)
    GROUP BY batch
),
processed_output AS (
    SELECT value:email::string as id, value:score::float AS score FROM (select scores from inference_output), lateral flatten(input => parse_json(scores))
), train_results AS (
    SELECT {{ num_boosting_rounds | sqlsafe }} AS num_boosting_rounds, {{ trim_extremes | sqlsafe }} AS trim_extremes, p.audience_size AS audience_size, t.error AS error FROM (SELECT count(distinct id) AS audience_size FROM processed_output WHERE score > 0.5) p, trained_model t
), seed_size AS (
    select count(*) AS seed_audience_size FROM features f, labels l WHERE f.joincol = l.joincol
)
SELECT s.seed_audience_size, t.audience_size AS num_lookalikes_found, t.error FROM train_results t, seed_size s
$$);

-- Last parameter (Differential Privacy) is optional and omitted here. Default is 1

-- Example 10188
CALL samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10189
SELECT * FROM <PROVIDER_TABLE> LIMIT 10;

-- Example 10190
CALL samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:status', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:age', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:region_code', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:days_active', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:income_bracket'
]);

-- Example 10191
CALL samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10192
CALL samooha_by_snowflake_local_db.provider.add_ui_form_customizations(
    $cleanroom_name,
    'prod_custom_lookalike_template',
    {
        'display_name': 'Custom Lookalike Template',
        'description': 'Use our customized ML techniques to find lookalike audiences.',
        'methodology': 'Specify your own seed audience, while matching against our users. Then customize the lookalike model across number of boosting rounds and removing outliers.',
        'warehouse_hints': {
            'warehouse_size': 'medium',
            'snowpark_optimized': TRUE
        }
    },
    {
    'num_boosting_rounds': {
        'display_name': 'Number of Boosting Rounds',
        'type': 'integer',
        'default': 10,
        'order': 7,
        'description': 'How many rounds of boosting should the model do?',
        'size': 'M',
        'group': 'Training & Inference Configuration'
    },
    'trim_extremes': {
        'display_name': 'Trim Extremes',
        'type': 'boolean',
        'default': False,
        'order': 8,
        'description': 'Remove outliers by default?',
        'size': 'M',
        'group': 'Training & Inference Configuration'
    },
    'lookalike_train_function': {
        'display_name': 'Training Function',
        'choices': ['lookalike_train'],
        'type': 'dropdown',
        'order': 9,
        'description': 'Which function do you want to use for training?',
        'size': 'M',
        'group': 'Training & Inference Configuration'
    },
    'lookalike_score_function': {
        'display_name': 'Scoring Function',
        'choices': ['lookalike_score'],
        'type': 'dropdown',
        'order': 10,
        'description': 'Which function do you want to use for scoring?',
        'size': 'M',
        'group': 'Training & Inference Configuration'
    },    
    'provider_join_col': {
        'display_name': 'Provider Join Column',
        'choices': ['p.HASHED_EMAIL'],
        'type': 'dropdown',
        'order': 4,
        'description': 'Select the provider column to join users on.',
        'infoMessage': 'We recommend using HASHED_EMAIL.',
        'size': 'M',
        'group': 'Enable Provider Features'
    },
    'consumer_join_col': {
        'display_name': 'Consumer Join Column',
        'description': 'Specify column in your table that matches the providers (i.e. HASHED_EMAIL).',
        'size': 'M',
        'default': 'HASHED_EMAIL',
        'infoMessage': 'We recommend using HASHED_EMAIL.',
        'order': 5,
        'group': 'Enable Provider Features'
    },
    'dimensions': {
        'display_name': 'Feature Selection',
        'choices': ['p.STATUS', 'p.AGE', 'p.REGION_CODE', 'p.DAYS_ACTIVE'],
        'type': 'multiselect',
        'order': 6,
        'description': 'What features do you want to train on?',
        'infoMessage': 'We recommend selecting all features for maximum signal.',
        'size': 'M',
        'group': 'Enable Provider Features'
    },
    'filter_column': {
        'display_name': 'Filter Column',
        'type': 'any',
        'order': 1,
        'description': 'Specify column in your table to filter for high value users (i.e. SALES_DLR)',
        'size': 'S',
        'default': 'SALES_DLR',
        'infoMessage': 'We recommend you input SALES_DLR over here.',
        'group': 'Seed Audience Selection'
    },
    'operator': {
        'display_name': 'Operator',
        'choices': ['>=', '=', '<='],
        'type': 'dropdown',
        'order': 2,
        'description': 'What is the operator your want to use for the filter?',
        'size': 'S',
        'group': 'Seed Audience Selection'
    },
    'filter_value': {
        'display_name': 'Filter Value',
        'order': 3,
        'description': 'What value do you want to filter to?',
        'default': 2000,        
        'size': 'S',
        'group': 'Seed Audience Selection'
    }
}, {
    'measure_columns': ['seed_audience_size', 'audience_size', 'num_lookalikes_found', 'error'],
    'default_output_type': 'BAR'
});

-- Example 10193
SHOW VERSIONS IN APPLICATION PACKAGE samooha_cleanroom_UI_Registration_ML_clean_room;

-- Example 10194
CALL samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSUMER_ACCOUNT_LOCATOR>', '<CONSUMER_ACCOUNT_NAME>');
CALL samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10195
CALL samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10196
CALL samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10197
CALL samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10198
CALL samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10199
-- If cross-cloud sharing is enabled for this clean room, begin the setup process for sharing requests.
CALL samooha_by_snowflake_local_db.consumer.is_laf_enabled_for_cleanroom($cleanroom_name);
CALL samooha_by_snowflake_local_db.consumer.setup_cleanroom_request_share_for_laf(
  $cleanroom_name, $provider_locator);

-- Example 10200
-- Call request_laf_cleanroom_requests until it reports the status as FULFILLED,
-- then call mount_laf_cleanroom_requests_share.
CALL samooha_by_snowflake_local_db.provider.request_laf_cleanroom_requests(
  $cleanroom_name, $consumer_locator);
CALL samooha_by_snowflake_local_db.provider.mount_laf_cleanroom_requests_share(
  $cleanroom_name, $consumer_locator);

-- Example 10201
CALL samooha_by_snowflake_local_db.consumer.create_template_request('dcr_cleanroom',
  'my_analysis',
  $$
  SELECT
      identifier({{ dimensions[0] | column_policy }})
  FROM
      identifier({{ my_table[0] }}) c
    INNER JOIN
      identifier({{ source_table[0] }}) p
        ON
          c.identifier({{ consumer_id  }}) = identifier({{ provider_id | join_policy }})
       {% if where_clause %} where {{ where_clause | sqlsafe | join_and_column_policy }} {% endif %};
  $$);

-- Example 10202
CALL samooha_by_snowflake_local_db.provider.list_template_requests('dcr_cleanroom');

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID())) WHERE status = 'PENDING';

-- Example 10203
CALL samooha_by_snowflake_local_db.provider.approve_template_request('dcr_cleanroom',
  '01b4d41d-0001-b572');

-- Example 10204
CALL samooha_by_snowflake_local_db.provider.reject_template_request('dcr_cleanroom',
  '01b4d41d-0001-b572',
  'Failed security assessment');

-- Example 10205
CALL samooha_by_snowflake_local_db.consumer.list_template_requests('dcr_cleanroom');

-- Example 10206
CALL samooha_by_snowflake_local_db.provider.list_template_requests('dcr_cleanroom');

-- Example 10207
-- Revoke access to a query you had previously approved
UPDATE samooha_cleanroom_Samooha_Cleanroom_Multiprovider_Clean_Room_1.admin.request_log_multiprovider
  SET APPROVED=FALSE
  WHERE PARTY_ACCOUNT='<CONSUMER_LOCATOR>';

-- Example 10208
use role samooha_app_role;
use warehouse app_wh;

-- Example 10209
set cleanroom_name = 'Provider Data Analysis Demo Clean room';

-- Example 10210
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10211
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10212
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10213
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10214
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10215
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10216
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10217
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10218
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HEM']);

-- Example 10219
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10220
call samooha_by_snowflake_local_db.provider.add_templates($cleanroom_name, ['prod_provider_data_analysis']);

-- Example 10221
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10222
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10223
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_provider_data_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS', 
    'prod_provider_data_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND', 
    'prod_provider_data_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE',
    'prod_provider_data_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE']);

-- Example 10224
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10225
show versions in application package samooha_cleanroom_Provider_Data_Analysis_Demo_clean_room;

-- Example 10226
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSUMER_ACCOUNT_LOCATOR>', '<CONSUMER_ACCOUNT_NAME>');
call samooha_By_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10227
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10228
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10229
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10230
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10231
use role samooha_app_role;
use warehouse app_wh;

