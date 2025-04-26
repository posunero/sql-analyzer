-- Example 10098
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.CONSUMER.RUN_ANALYSIS(
  $cleanroom_name,
  $template_name,
  ['my_db.my_sch.consumer_table],       -- Populates the my_table variable
  ['my_db.my_sch.provider_table'],      -- Populates the source_table variable
  OBJECT_CONSTRUCT(                     -- Populates custom named variables
    'consumer_join_col','c.age_band',
    'provider_join_col','p.age_band',
    'group_by_col','p.device_type'
  )
);

-- Example 10099
SELECT income FROM my_db.my_sch.customers WHERE income < {{ max_income }};

-- Example 10100
SELECT age FROM IDENTIFIER({{ my_table[0] }}) AS C WHERE {{ where_clause }};

-- Example 10101
SELECT age FROM IDENTIFIER( {{ my_table[0] }} ) as C {{ where_clause | sqlsafe }};

-- Example 10102
SELECT col1 FROM IDENTIFIER({{ source_table[0] }}) AS P;

-- Example 10103
-- Provider uploads a Python function that takes two numbers and returns the sum.
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
  $cleanroom_name,
  'simple_addition',                        -- Function name to use in the template
  ['someval integer', 'added_val integer'], -- Arguments
  [],                                       -- No packages needed
  'integer',                                -- Return type
  'main',                                   -- Handler for function name
  $$

def main(input, added_val):
  return input + int(added_val)
    $$
);

-- Template passes value from each row to the function, along with a
-- caller-supplied argument named 'increment'
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name,
    'simple_python_example',
$$
    SELECT val, cleanroom.simple_addition(val, {{ increment | sqlsafe }})
    FROM VALUES (5),(8),(12),(39) AS P(val);
$$
);

-- Example 10104
SHOW APPLICATION PACKAGES STARTS WITH 'SAMOOHA_CLEANROOM_';

-- Example 10105
SHOW VERSIONS IN APPLICATION PACKAGE SAMOOHA_CLEANROOM_MY_FIRST_CLEANROOM;

-- Example 10106
CALL samooha_by_snowflake_local_db.provider.set_default_release_directive(
  $cleanroom_name, 'V1_0', '0');

-- Example 10107
CALL samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status('MY_FIRST_CLEANROOM');

-- When REVIEW_STATUS = APPROVED, you can update the default version to the
-- latest version, if you haven't done so already.
SHOW VERSIONS IN APPLICATION PACKAGE SAMOOHA_CLEANROOM_MY_FIRST_CLEANROOM;
CALL samooha_by_snowflake_local_db.provider.set_default_release_directive(
  $cleanroom_name, 'V1_0', '<<LATEST_PATCH_NUMBER>>');

-- Example 10108
BEGIN
  CREATE OR REPLACE TABLE cleanroom.activation_data_analysis_results AS
    SELECT * FROM identifier({{ my_table[0] }})
  RETURN 'analysis_results';
END;

-- Example 10109
CALL samooha_by_snowflake_local_db.provider.link_datasets(
    'my_activation_cleanroom',
    ['samooha_by_snowflake_local_db.library.temp_public_key']);

-- Example 10110
CALL samooha_by_snowflake_local_db.provider.set_activation_policy('my_cleanroom', [
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HASHED_EMAIL',
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE',
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 10111
CALL samooha_by_snowflake_local_db.provider.enable_template_for_consumer_activation(
    'my_cleanroom', 'activation_my_template');

-- Example 10112
CALL samooha_by_snowflake_local_db.provider.request_provider_activation_consent('my_cleanroom', 'activation_my_template');

-- Example 10113
CALL samooha_by_snowflake_local_db.provider.add_ui_form_customizations(
    $cleanroom_name,
    'prod_test_references_1',
    {
      'display_name': 'PROD TEST REFERENCE FIRST',
      'description': 'Use our customized ML techniques to find lookalike audiences.',
      'methodology': 'Specify your own seed audience, while matching against our users. Then customize the lookalike model across number of boosting rounds and removing outliers.',
      'render_table_dropdowns': {
          'render_consumer_table_dropdown': TRUE,
          'render_provider_table_dropdown': TRUE
        },
     'activation_template_name': 'activation_my_template',
     'enabled_activations': ['consumer', 'provider']
    },
    {
    'reference_provider_join': {
        'display_name': 'Provider join column',
        'order': 4,
        'description': 'Which provider col do you want to join on',
        'size': 'S',
        'group': 'Seed Audience Selection',
        'references': ['PROVIDER_JOIN_POLICY'],
        'provider_parent_table_field': 'source_table',
        'type': 'dropdown'
    },
    'reference_consumer_join': {
        'display_name': 'Consumer join column',
        'order': 4,
        'description': 'Which consumer col do you want to join on',
        'size': 'S',
        'group': 'Seed Audience Selection',
        'references': ['CONSUMER_COLUMNS'],
        'consumer_parent_table_field': 'my_table',
        'type': 'dropdown'
    }
  },
  {
    'measure_columns': ['count'],
    'default_output_type': 'BAR'
  });

-- Example 10114
CALL samooha_by_snowflake_local_db.submit_analysis_request(
  'my_clean_room',
  'CONSUMER_1_LOCATOR',
  'activation_custom_template',
  ['provider_source_table'],
  ['consumer_source_table'],
  object_construct(
    'dimensions', ['p.CAMPAIGN'],
    'where_clause', 'p.EMAIL=c.EMAIL'
));

-- Example 10115
CALL samooha_by_snowflake_local_db.consumer.set_activation_policy('my_cleanroom', [
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HASHED_EMAIL',
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 10116
CALL samooha_by_snowflake_local.consumer.approve_provider_activation_consent('my_cleanroom', 'activation_my_template');

-- Example 10117
CALL samooha_by_snowflake_local_db.consumer.run_activation(
  'activation_clean_room',
  'my_activation_segment',
  'activation_custom_template',
  ['consumer_source_table'],
  ['provider_source_table'],
  object_construct(
    'dimensions', ['p.CAMPAIGN'],
    'where_clause', 'p.EMAIL=c.EMAIL'
));

-- Example 10118
CALL samooha_by_snowflake_local_db.provider.add_template_chain(
  'collab_clean_room',
  'insights_chain',
  [
    {
      'template_name': 'crosswalk',
      'cache_results': True,
      'output_table_name': 'crosswalk',
      'jinja_output_table_param': 'crosswalk_table_name',
      'cache_expiration_hours': 2190
    },
    {
      'template_name': 'transaction_insights',
      'cache_results': False
    }
  ]
);

-- Example 10119
CALL samooha_by_snowflake_local_db.consumer.run_analysis(
  'collab_clean_room',
  'insights_chain',
  ['MY_CONSUMER_DB.C_SCHEMA.CONVERSIONS'],
  ['PROVIDER_DB.P_SCHEMA.EXPOSURES'],
  object_construct(
    'where_clause', 'p.EMAIL=c.EMAIL'
  )
);

-- Example 10120
CALL samooha_by_snowflake_local_db.consumer.run_analysis(
  'collab_clean_room',
  'insights_chain',
  ['MY_CONSUMER_DB.C_SCHEMA.CONVERSIONS'],
  ['PROVIDER_DB.P_SCHEMA.EXPOSURES'],
  object_construct(
    'where_clause', 'p.EMAIL=c.EMAIL',
    'crosswalk_template', object_construct(
      'dimensions', ['p.CAMPAIGN']
    )
  )
);

-- Example 10121
SELECT gender, regions
  FROM TABLE sample_db.demo.customer
  GROUP BY gender, region;

-- Example 10122
SELECT gender, regions
  FROM TABLE sample_db.demo.customer;

-- Example 10123
WITH audience AS
  (SELECT COUNT(DISTINCT t1.hashed_email),
    t1.status
    FROM provider_db.overlap.customers t1
    JOIN consumer_db.overlap.customers t2
      ON t1.hashed_email = t2.hashed_email
    GROUP BY t1.status);

SELECT * FROM audience;

-- Example 10124
WITH audience AS
  (SELECT t1.hashed_email,
    t1.status
    FROM provider_db.overlap.customers quoted t1
    JOIN consumer_db.overlap.customers t2
      ON t1.hashed_email = t2.hashed_email
    GROUP BY t1.status)

SELECT * FROM audience

-- Example 10125
SELECT p.education_level,
  c.status,
  AVG(p.days_active),
  COUNT(DISTINCT p.age_band)
  FROM  sample_database_preprod.demo.customers c
  INNER JOIN
  sample_database_preprod.demo.customers p
    ON  c.hashed_email = p.hashed_email
  GROUP BY ALL;

-- Example 10126
SELECT COUNT(*),
  DATE_TRUNC('week', date_joined) AS week
  FROM consumer_sample_database.audience_overlap.customers
  GROUP BY week;

-- Example 10127
SELECT COUNT(DISTINCT t1.”hashed_email”)
  FROM provider_sample_database.audience_overlap."customers quoted" t1
  INNER JOIN
  consumer_sample_database.audience_overlap.customers t2
    ON t1."hashed_email" = t2.hashed_email;

-- Example 10128
-- Estimate the number of credits consumed in the past 5 days.
SELECT * FROM TABLE(SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.PRA_CONSUMPTION_UDTF(-5));

-- Example 10129
CALL samooha_by_snowflake_local_db.CONSUMER.enable_templates_for_provider_run(
  $cleanroom_name,
  [$template1, $template2],
  TRUE,
  {
    $template1: {'warehouse_type': 'STANDARD', 'warehouse_size': ['MEDIUM', 'LARGE']},
    $template1: {'warehouse_type': 'SNOWPARK-OPTIMIZED', 'warehouse_size': ['MEDIUM', 'XLARGE']},
    $template2: {'warehouse_type': 'STANDARD', 'warehouse_size': ['MEDIUM', 'XLARGE']}
  });

-- Example 10130
CALL samooha_by_snowflake_local_db.PROVIDER.VIEW_WAREHOUSE_SIZES_FOR_TEMPLATE($cleanroom_name, $template_name, $consumer_account_loc);
CALL samooha_by_snowflake_local_db.provider.submit_analysis_request(
  $cleanroom_name,
  $consumer_locator_id,
  $template1,
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
  object_construct(
    'dimensions', ['c.REGION_CODE'],
    'measure_type', ['AVG'],
    'measure_column', ['c.DAYS_ACTIVE'],
    'warehouse_type', 'STANDARD',        -- If this type and size pair were not listed by view_warehouse_sizes_for_template,
    'warehouse_size', 'LARGE'            -- the request will automatically fail.
  ));

-- Example 10131
use role samooha_app_role;
use warehouse app_wh;

-- Example 10132
set cleanroom_name = 'Custom Template Demo Clean room';

-- Example 10133
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10134
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10135
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10136
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10137
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10138
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10139
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10140
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10141
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HEM']);

-- Example 10142
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10143
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name,
    'prod_custom_template',    // Name of the template
    $$
select
count(*) as total_count
from identifier({{ my_table[0] }}) c
inner join identifier({{ source_table[0] }}) p
on identifier({{ consumer_id | join_policy }}) = identifier({{ provider_id | join_policy }})
{% if where_clause %}
where {{ where_clause | sqlsafe | column_policy }}
{% endif %};
    $$                         // A string representing the SQL Jinja template
);

-- Example 10144
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10145
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10146
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_custom_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
    'prod_custom_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
    'prod_custom_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

-- Example 10147
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10148
show versions in application package samooha_cleanroom_Custom_Template_Demo_clean_room;

-- Example 10149
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSUMER_ACCOUNT_LOCATOR>', '<CONSUMER_ACCOUNT_NAME>');
call samooha_By_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 10150
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10151
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10152
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10153
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10154
use role samooha_app_role;
use warehouse app_wh;

-- Example 10155
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10156
set cleanroom_name = 'Custom Template Demo Clean room';

-- Example 10157
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10158
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10159
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10160
use role accountadmin;
call samooha_by_snowflake_local_db.consumer.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10161
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10162
call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,              -- cleanroom
  'prod_custom_template',       -- template name

  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],    -- your tables
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],       -- provider tables

  object_construct(                              -- The keyword arguments needed for the SQL Jinja template

    'consumer_id', 'c.hem',                    -- Consumer column to join on, needed by template

    'provider_id', 'p.hem',                    -- Provider column to join on, needed by template

    'where_clause', 'p.STATUS = $$MEMBER$$' -- Boolean filter for custom template
  )
);

-- Example 10163
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10164
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_custom_template');

