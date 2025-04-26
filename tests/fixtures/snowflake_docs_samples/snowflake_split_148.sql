-- Example 9897
-- Limit joinable columns in this table to age_band, region_code, and device_type
CALL samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name,
  ['cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:age_band',
   'cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:region_code',
   'cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:device_type']);

CALL samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 9898
SELECT COUNT(*), group_by_col FROM Consumer_Table AS C
  INNER JOIN Provider_Table AS P
  ON C.join_col = P.join_col
  GROUP BY group_col;

-- Example 9899
SELECT COUNT(*), IDENTIFIER({{group_by_col | column_policy}}) FROM IDENTIFIER({{my_table[0]}}) AS C
  INNER JOIN IDENTIFIER({{source_table[0]}}) AS P
  ON IDENTIFIER({{consumer_join_col | join_policy}}) = IDENTIFIER({{provider_join_col | join_policy}})
  GROUP BY IDENTIFIER({{group_by_col | column_policy}});

-- Example 9900
-- Add the template
SET template_name = 'overlap_template';
CALL samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name,
    $template_name,
    $$
    SELECT COUNT(*), IDENTIFIER({{group_by_col | column_policy}}) FROM IDENTIFIER({{my_table[0]}}) AS C
      INNER JOIN IDENTIFIER({{source_table[0]}}) AS P
      ON IDENTIFIER({{consumer_join_col | join_policy}}) = IDENTIFIER({{provider_join_col | join_policy}})
      GROUP BY IDENTIFIER({{group_by_col | column_policy}});
    $$);

CALL samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 9901
-- Set column policies. Column policies are tied to a specific template and table, so we
-- needed to add the template first.
CALL samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name,
  [$template_name || ':cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:STATUS',
   $template_name || ':cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:AGE_BAND',
   $template_name || ':cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table:DAYS_ACTIVE']);

CALL samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 9902
CALL samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 9903
CALL samooha_by_snowflake_local_db.provider.add_consumers(
  $cleanroom_name,
  <CONSUMER_LOCATOR>,
  <ORG_NAME>.<ACCOUNT_NAME>);

CALL samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 9904
-- Publish the clean room.
CALL samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 9905
USE WAREHOUSE app_wh;
USE ROLE samooha_app_role;

-- Example 9906
SET cleanroom_name = 'Developer Tutorial';
CALL samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, <PROVIDER_LOCATOR>);

-- Example 9907
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS cleanroom_tut_db;
CREATE SCHEMA IF NOT EXISTS cleanroom_tut_db.cleanroom_tut_sch;

CREATE TABLE IF NOT EXISTS cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table AS
  SELECT TOP 1000 * FROM SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS ORDER BY HASHED_EMAIL DESC;

DESCRIBE TABLE cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table;

-- Example 9908
-- You need to use a role that has ownership of the object to be registered, probably not samooha_app_role.
USE ROLE ACCOUNTADMIN;
CALL samooha_by_snowflake_local_db.library.register_objects(['cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table']);

-- Drop back down to samooha_app_role for the other actions.
USE ROLE samooha_app_role;
CALL samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table']);

CALL samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 9909
-- Allow same three columns in your data to be joined.
CALL samooha_by_snowflake_local_db.consumer.set_join_policy($cleanroom_name,
  ['cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table:age_band',
  'cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table:region_code',
  'cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table:device_type']);

-- Example 9910
-- List templates in the clean room, then examine the template details
CALL samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

SET template_name = 'overlap_template';
CALL samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, $template_name);

-- Example 9911
-- Table name to use is in the LINKED_TABLE column in the results.
CALL samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 9912
-- See which provider columns can be joined on
CALL samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);

-- See which provider columns can be projected
CALL samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 9913
CALL samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,
  $template_name,
  ['cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table'],
  ['cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table'],
  OBJECT_CONSTRUCT(
    'consumer_join_col','c.age_band',
    'provider_join_col','p.age_band',
    'group_by_col','p.status'
  ),
  FALSE
);

-- Example 9914
USE ROLE samooha_app_role;
CALL samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

USE role ACCOUNTADMIN;
DROP TABLE cleanroom_tut_db.cleanroom_tut_sch.demo_provider_table;
DROP DATABASE cleanroom_tut_db;

-- Example 9915
USE ROLE samooha_app_role;
CALL samooha_by_snowflake_local_db.consumer.uninstall_cleanroom($cleanroom_name);

USE ROLE ACCOUNTADMIN;
DROP VIEW cleanroom_tut_db.cleanroom_tut_sch.demo_consumer_table;
DROP DATABASE cleanroom_tut_db;

-- Example 9916
USE WAREHOUSE app_wh;
USE ROLE samooha_app_role;
SET cleanroom_name = 'Developer Tutorial';
CALL samooha_by_snowflake_local_db.provider.cleanroom_init(
  $cleanroom_name,
  'INTERNAL');      -- Use EXTERNAL to share outside your Snowflake org

-- Example 9917
USE WAREHOUSE app_wh;
USE ROLE samooha_app_role;
SET cleanroom_name = 'Developer Tutorial'; -- Get the actual clean room name and provider's account locator from the provider.
CALL samooha_by_snowflake_local_db.consumer.
  install_cleanroom($cleanroom_name, <PROVIDER_LOCATOR>);

-- Example 9918
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

-- List created and published clean rooms
CALL samooha_by_snowflake_local_db.provider.view_cleanrooms();
SELECT CLEANROOM_ID AS "cleanroom_name"
  FROM TABLE(RESULT_SCAN(last_query_id()))
  WHERE STATE = 'CREATED' AND IS_PUBLISHED = TRUE;

-- Specify a clean room name from the list and drop it
CALL samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 9919
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

CALL samooha_by_snowflake_local_db.consumer.view_cleanrooms();
SELECT CLEANROOM_ID AS "cleanroom_name"
  FROM TABLE(RESULT_SCAN(last_query_id()))
  WHERE IS_ALREADY_INSTALLED = TRUE;

CALL samooha_by_snowflake_local_db.consumer.uninstall_cleanroom($cleanroom_name);

-- Example 9920
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;
CALL samooha_by_snowflake_local_db.consumer.
  uninstall_cleanroom($cleanroom_name).

-- Example 9921
GRANT ROLE SAMOOHA_APP_ROLE TO USER <user_name>;

-- Example 9922
USE ROLE samooha_app_role;

-- Example 9923
CALL samooha_by_snowflake_local_db.provider.link_datasets('dcr_cleanroom', 
   ['MY_DB.MY_SCHEMA.MY_TABLE']);

-- Example 9924
SELECT * FROM TABLE(result_scan(ABC123));

-- Example 9925
USE ROLE samooha_app_role;
USE WAREHOUSE app_wh;

-- Example 9926
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 9927
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 9928
alter application package samooha_cleanroom_<CLEANROOM_ID> SET DISTRIBUTION = EXTERNAL;

-- Example 9929
-- Create an internal clean room
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 9930
show versions in application package samooha_cleanroom_<CLEANROOM_ID>;

-- Example 9931
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 9932
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 9933
call samooha_by_snowflake_local_db.provider.enable_consumer_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR_1>']);

-- Example 9934
call samooha_by_snowflake_local_db.provider.disable_consumer_run_analysis($cleanroom_name, ['<CONSUMER_ACCOUNT_LOCATOR_1>']);

-- Example 9935
call samooha_by_snowflake_local_db.library.is_consumer_run_enabled($cleanroom_name)

-- Example 9936
call samooha_by_snowflake_local_db.provider.create_or_update_cleanroom_listing($cleanroom_name);

-- Example 9937
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.provider.register_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 9938
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 9939
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 9940
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.register_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 9941
USE ROLE ACCOUNTADMIN;

CALL samooha_by_snowflake_local_db.library.enable_external_tables_on_account();

-- Example 9942
CALL samooha_by_snowflake_local_db.provider.enable_external_tables_for_cleanroom(
    $cleanroom_name);

-- Example 9943
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 9944
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 9945
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 9946
USE ROLE <ROLE_WITH_MANAGE GRANTS>;
call samooha_by_snowflake_local_db.library.unregister_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 9947
call samooha_by_snowflake_local_db.provider.link_datasets(
  $cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 9948
grant reference_usage on database <DB NAME> to share in application package samooha_cleanroom_<cleanroom_name>;

-- Example 9949
call samooha_by_snowflake_local_db.provider.unlink_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 9950
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 9951
call samooha_by_snowflake_local_db.provider.restrict_table_options_to_consumers(
    $cleanroom_name,
    {
        'DB.SCHEMA.TABLE1': ['CONSUMER_1_LOCATOR'],
        'DB.SCHEMA.TABLE2': ['CONSUMER_1_LOCATOR', 'CONSUMER_2_LOCATOR']
    }
);

-- Example 9952
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 9953
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:EMAIL', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:EMAIL']);

-- Example 9954
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 9955
call samooha_by_snowflake_local_db.provider.view_template_definition($cleanroom_name, 'prod_overlap_analysis');

-- Example 9956
call samooha_by_snowflake_local_db.provider.add_templates($cleanroom_name, ['prod_overlap_analysis']);

-- Example 9957
call samooha_by_snowflake_local_db.provider.clear_template($cleanroom_name, 'prod_custom_template');

-- Example 9958
call samooha_by_snowflake_local_db.provider.clear_all_templates($cleanroom_name);

-- Example 9959
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name,
['prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

 -- Same example, but using a variable name for the template.
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name,
[$template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 $template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 $template_name || ':SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

-- Example 9960
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 9961
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

-- Example 9962
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

-- Example 9963
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

