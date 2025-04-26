-- Example 25703
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 25704
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25705
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25706
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 25707
call samooha_by_snowflake_local_db.provider.link_datasets(
  $cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 25708
grant reference_usage on database <DB NAME> to share in application package samooha_cleanroom_<cleanroom_name>;

-- Example 25709
call samooha_by_snowflake_local_db.provider.unlink_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 25710
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 25711
call samooha_by_snowflake_local_db.provider.restrict_table_options_to_consumers(
    $cleanroom_name,
    {
        'DB.SCHEMA.TABLE1': ['CONSUMER_1_LOCATOR'],
        'DB.SCHEMA.TABLE2': ['CONSUMER_1_LOCATOR', 'CONSUMER_2_LOCATOR']
    }
);

-- Example 25712
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 25713
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:EMAIL', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:EMAIL']);

-- Example 25714
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 25715
call samooha_by_snowflake_local_db.provider.view_template_definition($cleanroom_name, 'prod_overlap_analysis');

-- Example 25716
call samooha_by_snowflake_local_db.provider.add_templates($cleanroom_name, ['prod_overlap_analysis']);

-- Example 25717
call samooha_by_snowflake_local_db.provider.clear_template($cleanroom_name, 'prod_custom_template');

-- Example 25718
call samooha_by_snowflake_local_db.provider.clear_all_templates($cleanroom_name);

-- Example 25719
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name,
['prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

 -- Same example, but using a variable name for the template.
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name,
[$template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 $template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 $template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

-- Example 25720
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 25721
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name, 'prod_custom_template', 
    $$
select 
    identifier({{ dimensions[0] | column_policy }}) 
from 
    identifier({{ my_table[0] }}) c 
    inner join 
    identifier({{ source_table[0] }}) p 
    on 
        c.identifier({{ consumer_id  }}) = identifier({{ provider_id | join_policy }}) 
    {% if where_clause %} where {{ where_clause | sqlsafe | join_and_column_policy }} {% endif %};
    $$);

-- Example 25722
<field_name>: {
  ['type': <enum>,]
  ['default': <value>,]
  ['choices': <string array>,]
  ['infoMessage': <string>,]
  ['size': <enum>]
  ['required': <bool>,]
  ['group': <string>,]
  ['references': <enum>]
  ['provider_parent_table_field':  <string>,]
  ['consumer_parent_table_field': <string>]
}

-- Example 25723
-- Specify the display name, description, and warehouse, and hide the default table dropdown lists. 
-- Define the following two fields in the UI:
--   A provider table selector that shows all provider tables. Chosen tables can be accessed by the template with the variable 'a_provider_table'
--     (This dropdown list is equivalent to setting `render_table_dropdowns.render_provider_table_dropdown: True`)
--   A column selector for the tables chosen in 'a_provider_table'. Chosen columns can be accessed by the template with the variable 'a_provider_col'

call samooha_by_snowflake_local_db.provider.add_ui_form_customizations(
    $cleanroom_name,
    'prod_custom_template',
    {
        'display_name': 'Custom Analysis Template',
        'description': 'Use custom template to run a customized analysis.',
        'methodology': 'This custom template dynamically renders a form for you to fill out, which are then used to generate a customized analysis fitting your request.',
        'warehouse_hints': {
            'warehouse_size': 'xsmall',
            'snowpark_optimized': FALSE
        },
        'render_table_dropdowns': {
            'render_consumer_table_dropdown': false,
            'render_provider_table_dropdown': false
        },
        'activation_template_name': 'activation_my_template',
        'enabled_activations': ['consumer', 'provider']  
    },    
    {
        'a_provider_table': {
            'display_name': 'Provider table',
            'order': 3,
            'description': 'Provider table selection',
            'size': 'S',
            'group': 'Seed Audience Selection',
            'references': ['PROVIDER_TABLES'],
            'type': 'dropdown'
        },
        'a_provider_col': {
            'display_name': 'Provider column',
            'order': 4,
            'description': 'Which col do you want to count on',
            'size': 'S',
            'group': 'Seed Audience Selection',
            'references': ['PROVIDER_COLUMN_POLICY'],
            'provider_parent_table_field': 'a_provider_table',
            'type': 'dropdown'
        }
    },
    {
        'measure_columns': ['col1', 'col2'],
        'default_output_type': 'PIE'
    }
);

-- Example 25724
call samooha_by_snowflake_local_db.provider.restrict_template_options_to_consumers(
    $cleanroom_name,
    {
        'prod_template_1': ['CONSUMER_1_LOCATOR', 'CONSUMER_2_LOCATOR']
    }
);

-- Example 25725
CALL samooha_by_snowflake_local_db.provider.request_laf_cleanroom_requests(
  $cleanroom_name, $consumer_locator);

-- Example 25726
CALL samooha_by_snowflake_local_db.provider.mount_laf_cleanroom_requests_share(
  $cleanroom_name, $consumer_locator);

-- Example 25727
call samooha_by_snowflake_local_db.provider.list_pending_template_requests($template_name);

-- Example 25728
call samooha_by_snowflake_local_db.provider.list_template_requests($template_name);

-- Example 25729
call samooha_by_snowflake_local_db.provider.approve_template_request($cleanroom_name, 
    '815324e5-54f2-4039-b5fb-bb0613846a5b');

-- Example 25730
CALL samooha_by_snowflake_local_db.provider.approve_multiple_template_requests($cleanroom_name, 
    ['cfd538e2-3a17-48e3-9773-14275e7d2cc9','2982fb0a-02b7-496b-b1c1-56e6578f5eac']);

-- Example 25731
call samooha_by_snowflake_local_db.provider.reject_template_request('dcr_cleanroom',
  'cfd538e2-3a17-48e3-9773-14275e7d2cc9',
  'Failed security assessment');

-- Example 25732
CALL samooha_by_snowflake_local_db.provider.reject_multiple_template_requests($cleanroom_name,
  [OBJECT_CONSTRUCT('request_id', '815324e5-54f2-4039-b5fb-bb0613846a5b', 'reason_for_rejection', 'Failed security assessment'),
   OBJECT_CONSTRUCT('request_id', '2982fb0a-02b7-496b-b1c1-56e6578f5eac', 'reason_for_rejection', 'Some other reason')
  ]);

-- Example 25733
call samooha_by_snowflake_local_db.provider.add_template_chain(
  $cleanroom_name,
  'my_chain',
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

-- Example 25734
call samooha_by_snowflake_local_db.provider.view_added_template_chains($cleanroom_name);

-- Example 25735
call samooha_by_snowflake_local_db.provider.view_template_chain_definition($cleanroom_name, 'my_chain');

-- Example 25736
call samooha_by_snowflake_local_db.provider.clear_template_chain($cleanroom_name, 'my_chain');

-- Example 25737
CALL samooha_by_snowflake_local_db.provider.enable_multiprovider_computation(
  $cleanroom_name,
  $consumer_account_locator,
  <org_name>.<account_locator>.<cleanroom_name>);

-- Example 25738
CALL samooha_by_snowflake_local_db.provider.view_multiprovider_requests($cleanroom_name, $consumer_locator);

-- Example 25739
CALL samooha_by_snowflake_local_db.provider.process_multiprovider_request($cleanroom_name_1, $consumer_account_locator, $request_id);

-- Example 25740
CALL samooha_by_snowflake_local_db.provider.suspend_multiprovider_tasks($cleanroom_name, $consumer_locator);

-- Example 25741
CALL samooha_by_snowflake_local_db.provider.resume_multiprovider_tasks('my_cleanroom', $consumer_locator);

-- Example 25742
call samooha_by_snowflake_local_db.provider.set_activation_policy('my_cleanroom', [ 
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HASHED_EMAIL',  
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 25743
call samooha_by_snowflake_local_db.provider.request_provider_activation_consent(
    $cleanroom_name, 'activation_my_activation_template');

-- Example 25744
call samooha_by_snowflake_local_db.provider.enable_provider_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR>']);

-- Example 25745
call samooha_by_snowflake_local_db.provider.disable_provider_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR>']);

-- Example 25746
call samooha_by_snowflake_local_db.library.is_provider_run_enabled($cleanroom_name)

-- Example 25747
CALL samooha_by_snowflake_local_db.PROVIDER.VIEW_WAREHOUSE_SIZES_FOR_TEMPLATE($cleanroom_name, $template_name, $consumer_account_loc);

-- Example 25748
call samooha_by_snowflake_local_db.provider.submit_analysis_request(
    $cleanroom_name, 
    '<CONSUMER_ACCOUNT>',
    'prod_overlap_analysis', 
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
    object_construct(       
      'dimensions', ['c.REGION_CODE'],        
      'measure_type', ['AVG'],           
      'measure_column', ['c.DAYS_ACTIVE'],
      'warehouse_type', 'STANDARD',        -- If this type and size pair were not listed by view_warehouse_sizes_for_template,
      'warehouse_size', 'LARGE'            -- the request will automatically fail.
    ));

-- Example 25749
-- It can take up to 2 minutes for this to pick up the request ID after the initial request
call samooha_by_snowflake_local_db.provider.check_analysis_status(
    $cleanroom_name, 
    $request_id, 
    '<CONSUMER_ACCOUNT>'
);

-- Example 25750
call samooha_by_snowflake_local_db.provider.get_analysis_result(
    $cleanroom_name, 
    $request_id, 
    $locator
);

-- Example 25751
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 25752
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, 'LOCATOR1,LOCATOR2', 'ORG1.NAME1,ORG2.NAME2');

-- Example 25753
call samooha_by_snowflake_local_db.provider.remove_consumers($cleanroom_name, 'locator1,locator2,locator3');

-- Example 25754
call samooha_by_snowflake_local_db.provider.set_cleanroom_ui_accessibility($cleanroom_name, 'HIDDEN');

-- Example 25755
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 25756
call samooha_by_snowflake_local_db.library.is_laf_enabled_on_account();

-- Example 25757
(cleanroom_name String, function_name String, arguments Array, packages Array, rettype String, handler String, code String)

-- Example 25758
(cleanroom_name String, function_name String, arguments Array, packages Array, imports Array, rettype String, handler String)

-- Example 25759
-- Inline UDF

call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name, 
    'assign_group',                      # Name of the UDF
    ['data variant', 'index integer'],   # Arguments of the UDF, along with their type
    ['pandas', 'numpy'],                 # Packages UDF will use
    'integer',                           # Return type of UDF
    'main',                              # Handler
    $$
import pandas as pd
import numpy as np

def main(data, index):
    df = pd.DataFrame(data)  # you can do something with df but this is just an example
    return np.random.randint(1, 100)
    $$
);

-- Example 25760
-- Upload from stage

call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'myfunc',                            # Name of the UDF
    ['data variant', 'index integer'],   # Arguments of the UDF
    ['numpy', 'pandas'],                 # Packages UDF will use
    ['/test_folder/assign_group.py'],    # Python file to import from a stage
    'integer',                           # Return type of UDF
    'assign_group.main'                  # Handler scoped to file name
);

-- Example 25761
call samooha_by_snowflake_local_db.provider.get_stage_for_python_files($cleanroom_name);

-- Example 25762
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 25763
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.view_external_activation_history();

-- Example 25764
call samooha_by_snowflake_local_db.provider.mount_request_logs_for_all_consumers($cleanroom_name);

-- Example 25765
call samooha_by_snowflake_local_db.provider.view_request_logs($cleanroom_name);

-- Example 25766
call samooha_by_snowflake_local_db.provider.is_dp_enabled_on_account();

-- Example 25767
call samooha_by_snowflake_local_db.provider.suspend_account_dp_task();

-- Example 25768
call samooha_by_snowflake_local_db.provider.resume_account_dp_task();

-- Example 25769
call samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

