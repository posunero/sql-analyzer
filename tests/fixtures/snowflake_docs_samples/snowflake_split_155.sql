-- Example 10365
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10366
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10367
use role samooha_app_role;
use warehouse app_wh;

-- Example 10368
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10369
set cleanroom_name = 'Custom Secure Python UDTF Demo Clean room';

-- Example 10370
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10371
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10372
call samooha_by_snowflake_local_db.consumer.run_analysis(
    $cleanroom_name,
    'prod_custom_udtf_age_days',
    [],                                         -- The consumer tables go here
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], -- The provider tables go here
    object_construct(
        'dimensions', ['p.age_band', 'p.days_active']  -- Any parameters the template needs will go here
    )
);

-- Example 10373
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10374
use role accountadmin;
call samooha_by_snowflake_local_db.consumer.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10375
call samooha_by_snowflake_local_db.consumer.run_analysis(
    $cleanroom_name,
    'prod_custom_udtf_age_days_with_overlap',
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],  -- The consumer tables go here
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], -- The provider tables go here
    object_construct(
        'dimensions', ['p.age_band', 'p.days_active']  -- Any parameters the template needs will go here
    )
);

-- Example 10376
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10377
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_custom_udtf_age_days');

-- Example 10378
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_custom_udtf_age_days');

-- Example 10379
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10380
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10381
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10382
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10383
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10384
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10385
use role samooha_app_role;
use warehouse app_wh;

-- Example 10386
set cleanroom_name = 'Snowpark Demo clean room';

-- Example 10387
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10388
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10389
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10390
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10391
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['<IMPRESSIONS_TABLE>']);

-- Example 10392
call samooha_by_snowflake_local_db.provider.link_datasets_advanced($cleanroom_name, ['<VIEW_NAME>'], ['<SOURCE_DB_NAMES>']);

-- Example 10393
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10394
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10395
select * from <IMPRESSIONS_TABLE> limit 10;

-- Example 10396
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'reach_impression_regression',
    ['source_table string', 'my_table string'],
    ['snowflake-snowpark-python', 'pandas', 'statsmodels', 'numpy'],
    'string',
    'main',
    $$
import traceback
import pandas as pd
import numpy as np

import statsmodels.formula.api as sm


def drop_tables(session, table_names):
    """
    Drop the tables passed in
    """
    for tbl in table_names:
        session.sql(f'drop table {tbl}').collect()

def preprocess_regression_data(session, source_table, my_table, suffix):
    """
    Preprocess the impressions and customer data into an intermediary table for regression
    """
    table_name = f'cleanroom.intermediary_{suffix}'

    my_table_statement = f'inner join {my_table} c on p.hem = c.hem' if my_table != 'NONE' else ''
    session.sql(f"""
    create or replace table {table_name} as (
        with joint_data as (
            select
                date,
                p.hem as hem,
                impression_id
            from {source_table} p
            {my_table_statement}
        )
        select
            date,
            count(distinct hem) as reach,
            count(distinct impression_id) as num_impressions
        from joint_data
        group by date
        order by date
    );
    """).collect()

    return table_name

def calculate_regression(df):
    """
    Calculate the regression data from the dataframe we put together
    """
    result = sm.ols('REACH ~ 1 + NUM_IMPRESSIONS', data=df).fit()
    retval = pd.concat([
        result.params,
        result.tvalues,
        result.pvalues
    ], keys=['params', 't-stat', 'p-value'], names=['STATISTIC', 'PARAMETER']).rename('VALUE').reset_index()
    return retval

def main(session, source_table, my_table):
    """
    First compute the regression data from an overlap between customer and provider data, and counting
    the number of impressions and reach per day. Next regress these locally and compute the regression
    statistics. Finally write it to a results table which can be queried to get the output.
    """
    suffix = f'regression_results_{abs(hash((source_table, my_table))) % 10000}'

    try:
        # Preprocess impressions and customer data into an intermediary form to use for regression
        intermediary_table_name = preprocess_regression_data(session, source_table, my_table, suffix)

        # Load the data into Python locally
        df = session.table(intermediary_table_name).to_pandas()

        # Carry out the regression and get statistics as an output
        regression_output = calculate_regression(df)

        # Write the statistics to an output table
        # The table and the schema names should be in upper case to quoted identifier related issues.
        table = f'results_{suffix}'.upper()
        retval_df = session.write_pandas(regression_output, table,  schema = 'CLEANROOM', auto_create_table = True)

        # Drop any intermediary tables
        drop_tables(session, [intermediary_table_name])

        # Tell the user the name of the table the results have been written to
        return f'Done, results have been written to the following suffix: {suffix}'
    except:
        return traceback.format_exc()
$$
);

-- Example 10397
-- See the versions available inside the clean room
show versions in application package samooha_cleanroom_Snowpark_Demo_clean_room;

-- Once the security scan is approved, update the release directive to the latest version
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '1');

-- Example 10398
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
        $cleanroom_name,
        'prod_calculate_regression',
        $$
call cleanroom.reach_impression_regression({{ source_table[0] }}, {{ my_table[0] | default('NONE') }});
$$
);

-- Example 10399
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
        $cleanroom_name,
        'prod_get_results',
        $$
select * from cleanroom.results_{{ results_suffix | sqlsafe }};
$$
);

-- Example 10400
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10401
show versions in application package samooha_cleanroom_Snowpark_Demo_clean_room;

-- Example 10402
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSUMER_ACCOUNT_LOCATOR>', '<CONSUMER_ACCOUNT_NAME>');
call samooha_By_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10403
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10404
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10405
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10406
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10407
use role samooha_app_role;
use warehouse app_wh;

-- Example 10408
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10409
set cleanroom_name = 'Snowpark Demo clean room';

-- Example 10410
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10411
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10412
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['<USERS_TABLE>']);

-- Example 10413
use role accountadmin;
call samooha_by_snowflake_local_db.consumer.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10414
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10415
call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,               -- cleanroom
  'prod_calculate_regression',    -- template name

  ['<USERS_TABLE>'],    -- consumer tables

  ['<IMPRESSIONS_TABLE>'],     -- provider tables

  object_construct()     -- Rest of the custom arguments needed for the template
);

-- Example 10416
set result_suffix = 'regression_results_<ID>';

call samooha_by_snowflake_local_db.consumer.run_analysis(
    $cleanroom_name,        -- cleanroom
    'prod_get_results',     -- template name
    [],                     -- consumer tables
    [],                     -- provider tables
    object_construct(
        'results_suffix', $result_suffix  -- The suffix with the results
    )
);

-- Example 10417
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10418
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_calculate_regression');

-- Example 10419
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_calculate_regression');

-- Example 10420
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10421
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10422
session.sql("create or replace table cleanroom.intermediary as ...")

-- Example 10423
session.sql("create or replace function cleanroom.udf(...")

-- Example 10424
df_iter = session.table(intermediary_table_name).to_pandas_batches()
for df in df_iter:
    ...

-- Example 10425
SELECT *
   FROM samooha_by_snowflake_local_db.public.provider_activation_summary;

-- Example 10426
SELECT *
    FROM samooha_by_snowflake_local_db.public.consumer_direct_activation_summary;

-- Example 10427
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": "arn:aws:s3:::<bucket>/<prefix>/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::<bucket>",
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "<prefix>/*"
          ]
        }
      }
    }
  ]
}

-- Example 10428
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::115136555074:user/x4gy-s-p2345g38"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "UCA56729_SFCRole=4447_uht2344sdf3mrWLNRM0y3bE="
        }
      }
    }
  ]
}

-- Example 10429
USE ROLE SAMOOHA_APP_ROLE;
USE DATABASE SAMOOHA_BY_SNOWFLAKE_LOCAL_DB;
USE SCHEMA PUBLIC;

/*
  Query the stage name from the connector configuration.
  Use AWS_CONNECTOR_ID for AWS, GCP_CONNECTOR_ID for GCP and
  AZURE_CONNECTOR_ID for Azure.

  For example, if you are connecting to AWS, enter:

  SELECT CONFIGURATION_ID, PARSE_JSON(CONFIGURATION) FROM SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.CONNECTOR_CONFIGURATION WHERE CONNECTOR_ID = 'AWS_CONNECTOR_ID';

/*
  Note that the rest of this script relies on the output of this query so you
  must save the output for use in the rest of the steps.

  Next, check the storage integration. Replace <CONFIGURATION_ID> from the output
  of the query.
*/

  DESC STORAGE INTEGRATION SAMOOHA_STORAGE_INT_<CONFIGURATION_ID>;

/*
  List files in the stage. Replace <STAGE_NAME> from the output of the query.
*/

  LIST @<STAGE_NAME>;

/*
  Check if you are able to query the files in the external stage. Replace
  <STAGE_NAME> from the output of the query.
*/

  SELECT * FROM @<STAGE_NAME> LIMIT 10;

/*
  Check if you are able to infer the schema from the files in the external
  stage. Replace <STAGE_NAME> from the output of the query.
*/

  SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  WITHIN GROUP (ORDER BY order_id)
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION=>'@<STAGE_NAME>',
      FILE_FORMAT=>'SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.PAR_FF'
    )
  );

/*
  Try to create a table from the external stage. Replace <STAGE_NAME> from
  the output of the query.
*/

  CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.CREATE_TABLE_FROM_STAGE('<STAGE_NAME>', 'EXT_INT_TEMP_TABLE');

/*
  Check data in the table.
*/

  SELECT * FROM SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.PUBLIC.EXT_INT_TEMP_TABLE LIMIT 10;

-- Example 10430
-- Find the UUID of the clean room
SELECT * FROM samooha_by_snowflake_local_db.public.cleanroom_record;

-- Replace <uuid> with the UUID of the clean room to find the tables that contain the PAIR IDs
-- Names of tables with PAIR IDs are appended with _PAIR
DESCRIBE SCHEMA samooha_cleanroom_<uuid>.shared_schema;

-- Query the table with PAIR IDs
SELECT * samooha_cleanroom_<uuid>.shared_schema.<tablename_PAIR>;

-- Example 10431
USE ROLE acxiom_admin_role;

