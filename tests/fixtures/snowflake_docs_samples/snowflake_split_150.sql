-- Example 10031
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, $provider_locator);

-- Example 10032
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10033
call samooha_by_snowflake_local_db.consumer.uninstall_cleanroom($cleanroom_name);

-- Example 10034
call samooha_by_snowflake_local_db.library.is_provider_run_enabled($cleanroom_name)

-- Example 10035
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

-- Example 10036
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

-- Example 10037
CALL samooha_by_snowflake_local_db.consumer.execute_multiprovider_flow([$cleanroom1, $cleanroom2]);

-- Example 10038
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.consumer.register_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 10039
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 10040
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 10041
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.register_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 10042
USE ROLE ACCOUNTADMIN;

CALL samooha_by_snowflake_local_db.library.enable_external_tables_on_account();

-- Example 10043
CALL samooha_by_snowflake_local_db.provider.enable_external_tables_for_cleanroom(
    $cleanroom_name);

-- Example 10044
call samooha_by_snowflake_local_db.library.register_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 10045
call samooha_by_snowflake_local_db.library.register_table_or_view(
        ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'], 
        false, 
        true,
        false,
        false);

-- Example 10046
call samooha_by_snowflake_local_db.library.register_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10047
call samooha_by_snowflake_local_db.library.register_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10048
call samooha_by_snowflake_local_db.library.register_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10049
call samooha_by_snowflake_local_db.library.register_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10050
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_db('SAMOOHA_SAMPLE_DATABASE');

-- Example 10051
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 10052
call samooha_by_snowflake_local_db.library.unregister_managed_access_schema(['SAMOOHA_SAMPLE_DATABASE.DEMO']);

-- Example 10053
USE ROLE <ROLE_WITH_MANAGE GRANTS>;

call samooha_by_snowflake_local_db.library.unregister_objects(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS','SAMOOHA_SAMPLE_DATABASE.INFORMATION_SCHEMA.FIELDS']);

-- Example 10054
call samooha_by_snowflake_local_db.library.unregister_table_or_view(
    ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],
    false,
    false,
    false,
    false);

-- Example 10055
call samooha_by_snowflake_local_db.library.unregister_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10056
call samooha_by_snowflake_local_db.library.unregister_managed_access_table(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10057
call samooha_by_snowflake_local_db.library.unregister_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10058
call samooha_by_snowflake_local_db.library.unregister_managed_access_view(['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10059
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 10060
call samooha_by_snowflake_local_db.consumer.unlink_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES']);

-- Example 10061
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10062
call samooha_by_snowflake_local_db.consumer.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:EMAIL', 'SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:EMAIL']);

-- Example 10063
call samooha_by_snowflake_local_db.consumer.set_column_policy($cleanroom_name,
['prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE',
 'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES:CAMPAIGN']);

-- Example 10064
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_overlap_analysis');

-- Example 10065
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_overlap_analysis');

-- Example 10066
call samooha_by_snowflake_local_db.consumer.view_added_template_chains($cleanroom_name);

-- Example 10067
call samooha_by_snowflake_local_db.consumer.view_template_chain_definition($cleanroom_name, 'insights_chain');

-- Example 10068
call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,
  'prod_overlap_analysis',
  ['SAMOOHA_SAMPLE_DATABASE.MYDATA.CONVERSIONS'],  -- Consumer tables
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.EXPOSURES'],      -- Provider tables
  object_construct(
    'max_age', 30
  )
);

-- Example 10069
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.LIBRARY.view_external_activation_history();

-- Example 10070
call samooha_by_snowflake_local_db.consumer.set_activation_policy('my_cleanroom', [ 
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE_NAME.DEMO.CUSTOMERS:HASHED_EMAIL',  
    'prod_overlap_analysis:SAMOOHA_SAMPLE_DATABASE_NAME.DEMO.CUSTOMERS:REGION_CODE' ]);

-- Example 10071
call consumer.approve_provider_activation_consent('my_cleanroom', 'activation_my_template');

-- Example 10072
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

-- Example 10073
CALL samooha_by_snowflake_local_db.consumer.is_laf_enabled_for_cleanroom($cleanroom_name);

-- Example 10074
CALL samooha_by_snowflake_local_db.consumer.setup_cleanroom_request_share_for_laf(
      $cleanroom_name, $provider_locator);

-- Example 10075
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

-- Example 10076
CALL SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.CONSUMER.GET_SQL_JINJA(
$$
SELECT COUNT(*), IDENTIFIER({{ group_by_col }})
  FROM IDENTIFIER({{ my_table | sqlsafe }})
  INNER JOIN IDENTIFIER({{ source_table | sqlsafe }})
  ON IDENTIFIER({{ consumer_join_col }}) = IDENTIFIER({{ provider_join_col }})
  GROUP BY IDENTIFIER({{ group_by_col }});
$$,
object_construct(
'group_by_col', 'city',
'consumer_join_col', 'hashed_email',
'provider_join_col', 'hashed_email',
'my_table', 'mydb.mysch.t1',
'source_table', 'mydb.mysch.t2'));

-- Example 10077
SELECT COUNT(*), IDENTIFIER('city')
  FROM IDENTIFIER(mydb.mysch.t1)
  INNER JOIN IDENTIFIER(mydb.mysch.t2)
  ON IDENTIFIER('hashed_email') = IDENTIFIER('hashed_email')
  GROUP BY IDENTIFIER('city');

-- Example 10078
call SAMOOHA_BY_SNOWFLAKE_LOCAL_DB.CONSUMER.GENERATE_PYTHON_REQUEST_TEMPLATE(
  'my_func',                         // SQL should use this name to call your function
  ['data variant', 'index integer'], // Arguments and types for the function
  ['pandas', 'numpy'],               // Standard libraries used
  [],                                // No custom libraries needed.
  'integer',                         // Return type integer
  'main',                            // Standard main handler
// Python implementation as UDF  
  $$
import pandas as pd
import numpy as np

def main(data, index):
    df = pd.DataFrame(data)  # you can do something with df but this is just an example
    return np.random.randint(1, 100)
    $$
);

-- Example 10079
BEGIN

-- First define the Python UDF
CREATE OR REPLACE FUNCTION CLEANROOM.my_func(data variant, index integer)
RETURNS integer
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
PACKAGES = ('pandas', 'numpy')

HANDLER = 'main'
AS '
import pandas as pd
import numpy as np

def main(data, index):
    df = pd.DataFrame(data)  # you can do something with df but this is just an example
    return np.random.randint(1, 100)
    ';
        

-- Then define and execute the SQL query
LET SQL_TEXT varchar := '<INSERT SQL TEMPLATE HERE>';

-- Execute the query and return the result
LET RES resultset := (EXECUTE IMMEDIATE :SQL_TEXT);
RETURN TABLE(RES);

END;

-- Example 10080
CALL samooha_by_snowflake_local_db.consumer.list_template_requests('dcr_cleanroom');

-- Example 10081
call samooha_by_snowflake_local_db.consumer.describe_cleanroom($cleanroom_name);

-- Example 10082
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10083
call samooha_by_snowflake_local_db.consumer.view_join_policy($cleanroom_name);

-- Example 10084
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);

-- Example 10085
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10086
CALL samooha_by_snowflake_local_db.library.is_consumer_run_enabled($cleanroom_name);

-- Example 10087
call samooha_by_snowflake_local_db.consumer.view_column_policy($cleanroom_name);

-- Example 10088
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10089
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10090
CALL samooha_by_snowflake_local_db.consumer.view_installed_cleanrooms();

-- Example 10091
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10092
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10093
call samooha_by_snowflake_local_db.consumer.set_cleanroom_ui_accessibility($cleanroom_name, 'HIDDEN');

-- Example 10094
CALL samooha_by_snowflake_local_db.library.enable_local_db_auto_upgrades();

-- Example 10095
CALL samooha_by_snowflake_local_db.library.disable_local_db_auto_upgrades();

-- Example 10096
SELECT COUNT(*), city FROM consumer_table
  INNER JOIN provider_table
  ON consumer_table.hashed_email = provider_table.hashed_email
  GROUP BY city;

-- Example 10097
SELECT COUNT(*), IDENTIFIER({{ group_by_col | column_policy }})
  FROM IDENTIFIER({{ my_table[0] }}) AS C
  INNER JOIN IDENTIFIER({{ source_table[0] }}) AS P
  ON IDENTIFIER({{ consumer_join_col | join_policy }}) = IDENTIFIER({{ provider_join_col | join_policy }})
  GROUP BY IDENTIFIER({{ group_by_col | column_policy }});

