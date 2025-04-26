-- Example 25770
call samooha_by_snowflake_local_db.library.disable_local_db_auto_upgrades();

-- Example 25771
call samooha_by_snowflake_local_db.provider.view_ui_registration_request_log();

-- Example 25772
call samooha_by_snowflake_local_db.library.register_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 25773
call samooha_by_snowflake_local_db.library.register_table_or_view(
        ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
        false, 
        true,
        false,
        false);

-- Example 25774
call samooha_by_snowflake_local_db.library.register_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25775
call samooha_by_snowflake_local_db.library.register_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25776
call samooha_by_snowflake_local_db.library.register_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25777
call samooha_by_snowflake_local_db.library.register_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25778
call samooha_by_snowflake_local_db.library.unregister_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 25779
call samooha_by_snowflake_local_db.library.unregister_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25780
call samooha_by_snowflake_local_db.library.unregister_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25781
call samooha_by_snowflake_local_db.library.unregister_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25782
call samooha_by_snowflake_local_db.library.unregister_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25783
call samooha_by_snowflake_local_db.provider.create_cleanroom_listing($cleanroom_name, <consumerorg.consumeracct>);

-- Example 25784
call samooha_by_snowflake_local_db.provider.register_cleanroom_in_ui($cleanroom_name, 'prod_custom_template', <CONSUMER ACCOUNT LOCATOR>, <USER_EMAIL>)

-- Example 25785
-- Revoke access to a query you had previously approved
UPDATE samooha_cleanroom_Samooha_Cleanroom_Multiprovider_Clean_Room_1.admin.request_log_multiprovider
  SET APPROVED=FALSE
  WHERE PARTY_ACCOUNT='<CONSUMER_LOCATOR>';

-- Example 25786
samooha_by_snowflake_local_db.consumer

-- Example 25787
USE ROLE SAMOOHA_APP_ROLE;

-- Call any clean room function here
CALL samooha_by_snowflake_local_db.consumer.install_cleanroom(...)

-- Example 25788
GRANT USAGE ON WAREHOUSE MY_WAREHOUSE TO SAMOOHA_APP_ROLE;

-- Example 25789
USE ROLE <ADMIN_ASSIGNED_ROLE>;

-- Call run-only consumer functions here
CALL samooha_by_snowflake_local_db.consumer.run_analysis(...)

-- Example 25790
CREATE ROLE MARKETING_ANALYST_ROLE;
CALL samooha_by_snowflake_local_db.consumer.grant_run_on_cleanrooms_to_role(
  ['overlap_cleanroom', 'market_share_cleanroom'],
  'MARKETING_ANALYST_ROLE'
);

-- Example 25791
CALL samooha_by_snowflake_local_db.consumer.revoke_run_on_cleanrooms_from_role(
  ['overlap_cleanroom', 'market_share_cleanroom'],
  'TEMP_USERS_ROLE'
);

-- Example 25792
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, $provider_locator);

-- Example 25793
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 25794
call samooha_by_snowflake_local_db.consumer.uninstall_cleanroom($cleanroom_name);

-- Example 25795
call samooha_by_snowflake_local_db.library.is_provider_run_enabled($cleanroom_name)

-- Example 25796
-- Simple example
CALL samooha_by_snowflake_local_db.consumer.enable_templates_for_provider_run($cleanroom_name, ['prod_overlap_analysis'], FALSE);

-- Specify warehouse types that the provider can request for each template.
call samooha_by_snowflake_local_db.CONSUMER.enable_templates_for_provider_run(
  $cleanroom_name,
  [$template1, $template2],
  TRUE,
  {
    $template1: {'warehouse_type': 'STANDARD', 'warehouse_size': ['MEDIUM', 'LARGE']},
    $template1: {'warehouse_type': 'SNOWPARK-OPTIMIZED', 'warehouse_size': ['MEDIUM', 'XLARGE']},
    $template2: {'warehouse_type': 'STANDARD', 'warehouse_size': ['MEDIUM', 'XLARGE']} 
  });

-- Example 25797
CALL samooha_by_snowflake_local_db.consumer.prepare_multiprovider_flow(
    [$cleanroom_name_1, $cleanroom_name_2],
    'prod_aggregate_data',
    object_construct(
        'source_table', [
            CONCAT($cleanroom_name_1, '.SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'), 
            CONCAT($cleanroom_name_2, '.SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS')
        ],
        'my_table', ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']),
        'hem_col', ['p1.HASHED_EMAIL', 'p2.HASHED_EMAIL'],
        'dimensions', ['p1.STATUS', 'p2.STATUS'],
        'consumer_join_col', 'HASHED_EMAIL'
    )
);

-- Example 25798
CALL samooha_by_snowflake_local_db.consumer.execute_multiprovider_flow([$cleanroom1, $cleanroom2]);

-- Example 25799
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.consumer.register_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 25800
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25801
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25802
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 25803
USE ROLE ACCOUNTADMIN;

CALL samooha_by_snowflake_local_db.library.enable_external_tables_on_account();

-- Example 25804
CALL samooha_by_snowflake_local_db.provider.enable_external_tables_for_cleanroom(
    $cleanroom_name);

-- Example 25805
call samooha_by_snowflake_local_db.library.register_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 25806
call samooha_by_snowflake_local_db.library.register_table_or_view(
        ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
        false, 
        true,
        false,
        false);

-- Example 25807
call samooha_by_snowflake_local_db.library.register_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25808
call samooha_by_snowflake_local_db.library.register_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25809
call samooha_by_snowflake_local_db.library.register_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25810
call samooha_by_snowflake_local_db.library.register_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25811
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 25812
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25813
call samooha_by_snowflake_local_db.library.unregister_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 25814
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 25815
call samooha_by_snowflake_local_db.library.unregister_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 25816
call samooha_by_snowflake_local_db.library.unregister_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25817
call samooha_by_snowflake_local_db.library.unregister_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25818
call samooha_by_snowflake_local_db.library.unregister_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25819
call samooha_by_snowflake_local_db.library.unregister_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 25820
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 25821
call samooha_by_snowflake_local_db.consumer.unlink_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 25822
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 25823
call samooha_by_snowflake_local_db.consumer.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:EMAIL', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:EMAIL']);

-- Example 25824
call samooha_by_snowflake_local_db.consumer.set_column_policy($cleanroom_name,
['prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:CAMPAIGN']);

-- Example 25825
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_overlap_analysis');

-- Example 25826
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_overlap_analysis');

-- Example 25827
call samooha_by_snowflake_local_db.consumer.view_added_template_chains($cleanroom_name);

-- Example 25828
call samooha_by_snowflake_local_db.consumer.view_template_chain_definition($cleanroom_name, 'insights_chain');

-- Example 25829
call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,
  'prod_overlap_analysis',
  ['SAMOOHA_SAMPLE_DATABASE.MYDATA.CONVERSIONS'],  -- Consumer tables
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES'],      -- Provider tables
  object_construct(
    'max_age', 30
  )
);

-- Example 25830
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.view_external_activation_history();

-- Example 25831
call samooha_by_snowflake_local_db.consumer.set_activation_policy('my_cleanroom', [ 
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE_NAME.DEMO.CUSTOMERS:HASHED_EMAIL',  
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE_NAME.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 25832
call consumer.approve_provider_activation_consent('my_cleanroom', 'activation_my_template');

-- Example 25833
call samooha_by_snowflake_local_db.consumer.run_activation(
  $cleanroom_name,
  'my_activation_segment',
  'activation_custom_template',
  ['consumer_source_table'], 
  ['provider_source_table'],
  object_construct(                 -- Custom arguments needed for the template
    'dimensions', ['p.CAMPAIGN'],   -- always use p. to refer to fields in provider tables, and c. to refer to fields in consumer tables. Use p2, p3, etc. for more than one provider table and c2, c3, etc. for more than one consumer table.
    'where_clause', 'p.EMAIL=c.EMAIL'
  ));

-- Example 25834
CALL samooha_by_snowflake_local_db.consumer.is_laf_enabled_for_cleanroom($cleanroom_name);

-- Example 25835
CALL samooha_by_snowflake_local_db.consumer.setup_cleanroom_request_share_for_laf(
      $cleanroom_name, $provider_locator);

-- Example 25836
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

