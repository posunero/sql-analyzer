-- Example 10298
set cleanroom_name = 'Machine Learning Demo Clean room';

-- Example 10299
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10300
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10301
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10302
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10303
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['samooha_provider_sample_database.lookalike_modeling.customers']);

-- Example 10304
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10305
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10306
select * from samooha_provider_sample_database.lookalike_modeling.customers limit 10;

-- Example 10307
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['samooha_provider_sample_database.lookalike_modeling.customers:hashed_email']);

-- Example 10308
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10309
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
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
        """
        Train the model in a threadsafe way
        """
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
        """
        Save down the model as a json string to load up for scoring/inference
        """
        pickle_jar = codecs.encode(pickle.dumps([model, self.ohe]), "base64").decode()
        return pickle_jar

    def dump_model(self):
        """
        Save down the model as a json string to load up for scoring/inference
        """
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
    $$
);

-- Example 10310
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
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
    $$
);

-- Example 10311
-- See the versions available inside the cleanroom
show versions in application package samooha_cleanroom_Machine_Learning_Demo_clean_room;

-- Once the security scan is approved, update the release directive to the latest version
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '2');

-- Example 10312
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name, 
    'prod_custom_lookalike_template', 
    $$
WITH
features AS (
    SELECT
        p.hashed_email,
        array_construct(identifier({{ dimensions[0] | column_policy }}) {% for feat in dimensions[1:] %} , identifier({{ feat | column_policy }}) {% endfor %}) as features
    FROM
        identifier({{ source_table[0] }}) as p
),
labels AS (
    SELECT
        c.hashed_email,
        {{ filter_clause | sqlsafe | column_policy }} as label_value
    FROM
        identifier({{ my_table[0] }}) as c
),
trained_model AS (
    SELECT
        train_out:model::varchar as model,
        train_out:error::float as error
    FROM (
      SELECT
        cleanroom.lookalike_train(array_agg(f.features), array_agg(l.label_value)) as train_out
      FROM features f, labels l
      WHERE f.hashed_email = l.hashed_email
    )
),
inference_output AS (
    SELECT
        MOD(seq4(), 100) as batch,
        cleanroom.lookalike_score(
            array_agg(distinct t.model), 
            array_agg(p.hashed_email), 
            array_agg(array_construct( identifier({{ dimensions[0] | column_policy }}) {% for feat in dimensions[1:] %} , identifier({{ feat | column_policy }}) {% endfor %}) )
        ) as scores
    FROM trained_model t, identifier({{ source_table[0] }}) p
    WHERE p.hashed_email NOT IN (SELECT c.hashed_email FROM identifier({{ my_table[0] }}) c)
    GROUP BY batch
),
processed_output AS (
    SELECT value:email::string as email, value:score::float as score FROM (select scores from inference_output), lateral flatten(input => parse_json(scores))
)
SELECT p.audience_size, t.error from (SELECT count(distinct email) as audience_size FROM processed_output WHERE score > 0.5) p, trained_model t;
    $$
);

-- Example 10313
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10314
select * from samooha_provider_sample_database.lookalike_modeling.customers limit 10;

-- Example 10315
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:status', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:age', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:region_code', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:days_active', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:income_bracket', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:household_size', 
    'prod_custom_lookalike_template:samooha_provider_sample_database.lookalike_modeling.customers:gender'
]);

-- Example 10316
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10317
show versions in application package samooha_cleanroom_Machine_Learning_Demo_clean_room;

-- Example 10318
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSUMER_ACCOUNT_LOCATOR>', '<CONSUMER_ACCOUNT_NAME>');
call samooha_By_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10319
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10320
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10321
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10322
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10323
use role samooha_app_role;
use warehouse app_wh;

-- Example 10324
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10325
set cleanroom_name = 'Machine Learning Demo Clean room';

-- Example 10326
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10327
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10328
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['samooha_consumer_sample_database.lookalike_modeling.customers']);

-- Example 10329
use role accountadmin;
call samooha_by_snowflake_local_db.consumer.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10330
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10331
call samooha_by_snowflake_local_db.consumer.run_analysis(
    $cleanroom_name,                     -- cleanroom
    'prod_custom_lookalike_template',    -- template name

    ['samooha_consumer_sample_database.lookalike_modeling.customers'],                -- consumer tables

    ['samooha_provider_sample_database.lookalike_modeling.customers'],                -- provider tables

    object_construct(                    -- Rest of the custom arguments needed for the template
        'dimensions', ['p.STATUS', 'p.AGE', 'p.REGION_CODE', 'p.DAYS_ACTIVE', 'p.INCOME_BRACKET'], -- Features used in training

        'filter_clause', 'c.SALES_DLR > 2000' -- Consumer flag for which customers are considered high value
    )
);

-- Example 10332
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10333
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_custom_lookalike_template');

-- Example 10334
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_custom_lookalike_template');

-- Example 10335
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10336
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10337
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10338
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10339
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10340
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10341
use role samooha_app_role;
use warehouse app_wh;

-- Example 10342
set cleanroom_name = 'Custom Secure Python UDTF Demo Clean room';

-- Example 10343
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10344
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10345
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10346
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10347
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10348
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10349
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10350
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10351
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HEM']);

-- Example 10352
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10353
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'mod_days_and_age',                     -- Name of the UDF
    ['age integer', 'days integer'],        -- Arguments of the UDF, specified as (variable name, variable type)
    ['pandas', 'numpy'],                    -- Packages UDF will use
    'table(decade integer, years float)',   -- Return type of UDF
    'ModifyAgeAndDays',                     -- Handler
    $$
import pandas as pd
import numpy as np

class ModifyAgeAndDays:
    def __init__(self):
        self.year = 365

    def process(self, age, days):
        rounded_age = int(np.floor(age / 10)) * 10
        years = np.round(days / self.year)
        yield (rounded_age, years)
    $$
);

-- Example 10354
-- See the versions available inside the clean room
show versions in application package samooha_cleanroom_Custom_Secure_Python_UDTF_Demo_clean_room;

-- Once the security scan is approved, update the release directive to the latest version
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '1');

-- Example 10355
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name,
    'prod_custom_udtf_age_days',
$$
    select decade, years from identifier({{ source_table[0] }}) p, table(cleanroom.mod_days_and_age(identifier({{ dimensions[0] | column_policy }}), identifier({{ dimensions[1] | column_policy }})));
$$
);

-- Example 10356
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name,
    'prod_custom_udtf_age_days_with_overlap',
$$
    select 
        c.status,
        decade, 
        avg(years) as years,
        sum(c.days_active) as days_active_c
    from 
        identifier({{ source_table[0] }}) p 
        inner join 
        identifier({{ my_table[0] }}) c
        on p.hem = c.hem,
        table(cleanroom.mod_days_and_age(identifier({{ dimensions[0] | column_policy }}), identifier({{ dimensions[1] | column_policy }})))
    group by c.status, decade
    order by c.status, decade
$$
);

-- Example 10357
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10358
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10359
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_custom_udtf_age_days:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND', 
    'prod_custom_udtf_age_days:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE',
    'prod_custom_udtf_age_days_with_overlap:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND', 
    'prod_custom_udtf_age_days_with_overlap:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE'
]);

-- Example 10360
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10361
show versions in application package samooha_cleanroom_Custom_Secure_Python_UDTF_Demo_clean_room;

-- Example 10362
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSMUMER_ACCOUNT_LOCATOR>');
CALL samooha_By_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10363
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10364
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

