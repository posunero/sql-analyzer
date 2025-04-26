-- Example 9964
call samooha_by_snowflake_local_db.provider.restrict_template_options_to_consumers(
    $cleanroom_name,
    {
        'prod_template_1': ['CONSUMER_1_LOCATOR', 'CONSUMER_2_LOCATOR']
    }
);

-- Example 9965
CALL samooha_by_snowflake_local_db.provider.request_laf_cleanroom_requests(
  $cleanroom_name, $consumer_locator);

-- Example 9966
CALL samooha_by_snowflake_local_db.provider.mount_laf_cleanroom_requests_share(
  $cleanroom_name, $consumer_locator);

-- Example 9967
call samooha_by_snowflake_local_db.provider.list_pending_template_requests($template_name);

-- Example 9968
call samooha_by_snowflake_local_db.provider.list_template_requests($template_name);

-- Example 9969
call samooha_by_snowflake_local_db.provider.approve_template_request($cleanroom_name, 
    '815324e5-54f2-4039-b5fb-bb0613846a5b');

-- Example 9970
CALL samooha_by_snowflake_local_db.provider.approve_multiple_template_requests($cleanroom_name, 
    ['cfd538e2-3a17-48e3-9773-14275e7d2cc9','2982fb0a-02b7-496b-b1c1-56e6578f5eac']);

-- Example 9971
call samooha_by_snowflake_local_db.provider.reject_template_request('dcr_cleanroom',
  'cfd538e2-3a17-48e3-9773-14275e7d2cc9',
  'Failed security assessment');

-- Example 9972
CALL samooha_by_snowflake_local_db.provider.reject_multiple_template_requests($cleanroom_name,
  [OBJECT_CONSTRUCT('request_id', '815324e5-54f2-4039-b5fb-bb0613846a5b', 'reason_for_rejection', 'Failed security assessment'),
   OBJECT_CONSTRUCT('request_id', '2982fb0a-02b7-496b-b1c1-56e6578f5eac', 'reason_for_rejection', 'Some other reason')
  ]);

-- Example 9973
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

-- Example 9974
call samooha_by_snowflake_local_db.provider.view_added_template_chains($cleanroom_name);

-- Example 9975
call samooha_by_snowflake_local_db.provider.view_template_chain_definition($cleanroom_name, 'my_chain');

-- Example 9976
call samooha_by_snowflake_local_db.provider.clear_template_chain($cleanroom_name, 'my_chain');

-- Example 9977
CALL samooha_by_snowflake_local_db.provider.enable_multiprovider_computation(
  $cleanroom_name,
  $consumer_account_locator,
  <org_name>.<account_locator>.<cleanroom_name>);

-- Example 9978
CALL samooha_by_snowflake_local_db.provider.view_multiprovider_requests($cleanroom_name, $consumer_locator);

-- Example 9979
CALL samooha_by_snowflake_local_db.provider.process_multiprovider_request($cleanroom_name_1, $consumer_account_locator, $request_id);

-- Example 9980
CALL samooha_by_snowflake_local_db.provider.suspend_multiprovider_tasks($cleanroom_name, $consumer_locator);

-- Example 9981
CALL samooha_by_snowflake_local_db.provider.resume_multiprovider_tasks('my_cleanroom', $consumer_locator);

-- Example 9982
call samooha_by_snowflake_local_db.provider.set_activation_policy('my_cleanroom', [ 
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HASHED_EMAIL',  
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 9983
call samooha_by_snowflake_local_db.provider.request_provider_activation_consent(
    $cleanroom_name, 'activation_my_activation_template');

-- Example 9984
call samooha_by_snowflake_local_db.provider.enable_provider_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR>']);

-- Example 9985
call samooha_by_snowflake_local_db.provider.disable_provider_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR>']);

-- Example 9986
call samooha_by_snowflake_local_db.library.is_provider_run_enabled($cleanroom_name)

-- Example 9987
CALL samooha_by_snowflake_local_db.PROVIDER.VIEW_WAREHOUSE_SIZES_FOR_TEMPLATE($cleanroom_name, $template_name, $consumer_account_loc);

-- Example 9988
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

-- Example 9989
-- It can take up to 2 minutes for this to pick up the request ID after the initial request
call samooha_by_snowflake_local_db.provider.check_analysis_status(
    $cleanroom_name, 
    $request_id, 
    '<CONSUMER_ACCOUNT>'
);

-- Example 9990
call samooha_by_snowflake_local_db.provider.get_analysis_result(
    $cleanroom_name, 
    $request_id, 
    $locator
);

-- Example 9991
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 9992
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, 'LOCATOR1,LOCATOR2', 'ORG1.NAME1,ORG2.NAME2');

-- Example 9993
call samooha_by_snowflake_local_db.provider.remove_consumers($cleanroom_name, 'locator1,locator2,locator3');

-- Example 9994
call samooha_by_snowflake_local_db.provider.set_cleanroom_ui_accessibility($cleanroom_name, 'HIDDEN');

-- Example 9995
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 9996
call samooha_by_snowflake_local_db.library.is_laf_enabled_on_account();

-- Example 9997
(cleanroom_name String, function_name String, arguments Array, packages Array, rettype String, handler String, code String)

-- Example 9998
(cleanroom_name String, function_name String, arguments Array, packages Array, imports Array, rettype String, handler String)

-- Example 9999
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

-- Example 10000
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

-- Example 10001
call samooha_by_snowflake_local_db.provider.get_stage_for_python_files($cleanroom_name);

-- Example 10002
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10003
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.view_external_activation_history();

-- Example 10004
call samooha_by_snowflake_local_db.provider.mount_request_logs_for_all_consumers($cleanroom_name);

-- Example 10005
call samooha_by_snowflake_local_db.provider.view_request_logs($cleanroom_name);

-- Example 10006
call samooha_by_snowflake_local_db.provider.is_dp_enabled_on_account();

-- Example 10007
call samooha_by_snowflake_local_db.provider.suspend_account_dp_task();

-- Example 10008
call samooha_by_snowflake_local_db.provider.resume_account_dp_task();

-- Example 10009
call samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

-- Example 10010
call samooha_by_snowflake_local_db.library.disable_local_db_auto_upgrades();

-- Example 10011
call samooha_by_snowflake_local_db.provider.view_ui_registration_request_log();

-- Example 10012
call samooha_by_snowflake_local_db.library.register_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 10013
call samooha_by_snowflake_local_db.library.register_table_or_view(
        ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
        false, 
        true,
        false,
        false);

-- Example 10014
call samooha_by_snowflake_local_db.library.register_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10015
call samooha_by_snowflake_local_db.library.register_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10016
call samooha_by_snowflake_local_db.library.register_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10017
call samooha_by_snowflake_local_db.library.register_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10018
call samooha_by_snowflake_local_db.library.unregister_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 10019
call samooha_by_snowflake_local_db.library.unregister_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10020
call samooha_by_snowflake_local_db.library.unregister_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10021
call samooha_by_snowflake_local_db.library.unregister_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10022
call samooha_by_snowflake_local_db.library.unregister_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10023
call samooha_by_snowflake_local_db.provider.create_cleanroom_listing($cleanroom_name, <consumerorg.consumeracct>);

-- Example 10024
call samooha_by_snowflake_local_db.provider.register_cleanroom_in_ui($cleanroom_name, 'prod_custom_template', <CONSUMER ACCOUNT LOCATOR>, <USER_EMAIL>)

-- Example 10025
samooha_by_snowflake_local_db.consumer

-- Example 10026
USE ROLE SAMOOHA_APP_ROLE;

-- Call any clean room function here
CALL samooha_by_snowflake_local_db.consumer.install_cleanroom(...)

-- Example 10027
GRANT USAGE ON WAREHOUSE MY_WAREHOUSE TO SAMOOHA_APP_ROLE;

-- Example 10028
USE ROLE <ADMIN_ASSIGNED_ROLE>;

-- Call run-only consumer functions here
CALL samooha_by_snowflake_local_db.consumer.run_analysis(...)

-- Example 10029
CREATE ROLE MARKETING_ANALYST_ROLE;
CALL samooha_by_snowflake_local_db.consumer.grant_run_on_cleanrooms_to_role(
  ['overlap_cleanroom', 'market_share_cleanroom'],
  'MARKETING_ANALYST_ROLE'
);

-- Example 10030
CALL samooha_by_snowflake_local_db.consumer.revoke_run_on_cleanrooms_from_role(
  ['overlap_cleanroom', 'market_share_cleanroom'],
  'TEMP_USERS_ROLE'
);

