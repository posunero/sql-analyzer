-- Example 10232
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10233
set cleanroom_name = 'Provider Data Analysis Demo Clean room';

-- Example 10234
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10235
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10236
-- Example run analysis procedure with single provider dataset

call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,                    -- cleanroom
  'prod_provider_data_analysis',      -- template name

  [],                                 -- consumer tables - this is empty since this template operates only on provider data
  
  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],    -- the provider table we want to carry out analysis on

  object_construct(                        -- The keyword arguments needed for the SQL Jinja template
      'dimensions', ['p.STATUS'],          -- Group by column

      'measure_type', ['COUNT'],           -- Aggregate function you want to perform like COUNT, AVG, etc.

      'measure_column', ['p.DAYS_ACTIVE'], -- The column that you want to perform aggregate function on

      'where_clause', 'p.REGION_CODE=$$REGION_10$$'  -- Acts as a filter to consider only certain records
                                                      -- $$ is used to pass string literals
    )
);

-- Example 10237
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10238
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_provider_data_analysis');

-- Example 10239
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_provider_data_analysis');

-- Example 10240
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10241
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10242
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10243
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10244
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10245
use role samooha_app_role;
use warehouse app_wh;

-- Example 10246
set cleanroom_name = 'Custom Secure Python UDF Demo clean room';

-- Example 10247
call samooha_by_snowflake_local_db.provider.cleanroom_init($cleanroom_name, 'INTERNAL');

-- Example 10248
call samooha_by_snowflake_local_db.provider.view_cleanroom_scan_status($cleanroom_name);

-- Example 10249
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '0');

-- Example 10250
call samooha_by_snowflake_local_db.provider.enable_laf_for_cleanroom($cleanroom_name);

-- Example 10251
call samooha_by_snowflake_local_db.provider.link_datasets($cleanroom_name, [ 'SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10252
use role accountadmin;
call samooha_by_snowflake_local_db.provider.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10253
call samooha_by_snowflake_local_db.provider.view_provider_datasets($cleanroom_name);

-- Example 10254
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10255
call samooha_by_snowflake_local_db.provider.set_join_policy($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:HEM']);

-- Example 10256
call samooha_by_snowflake_local_db.provider.view_join_policy($cleanroom_name);

-- Example 10257
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name, 
    'assign_group',                      -- Name of the UDF
    ['data variant', 'index integer'],   -- Arguments of the UDF, specified as (variable name, variable type)
    ['numpy', 'pandas'],                 -- Packages UDF will use
    'integer',                           -- Return type of UDF
    'main',                              -- Handler
    $$
import numpy as np
import pandas as pd

def main(data, index):
    df = pd.DataFrame(data) # Just as an example of what we could do
    np.random.seed(0)
    
    # First let's combine the data row and the additional index into a string
    data.append(index)
    data_string = ",".join(str(d) for d in data)

    # Hash it 
    encoded_data_string = data_string.encode()
    hashed_string = hash(encoded_data_string)

    # Return the hashed string
    return hashed_string
    $$
);

-- Example 10258
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name, 
    'group_agg',              -- Name of the UDF
    ['data variant'],         -- Arguments of the UDF, specified as (variable name, variable type)
    ['pandas'],               -- Packages UDF will use
    'integer',                -- Return type of UDF
    'main',                   -- Handler
    $$
import pandas as pd

def main(s):
    s = pd.Series(s)
    return (s == 'SILVER').sum()
    $$
);

-- Example 10259
-- See the versions available inside the clean room
show versions in application package samooha_cleanroom_Custom_Secure_Python_UDF_Demo_clean_room;

-- Once the security scan is approved, update the release directive to the latest version
call samooha_by_snowflake_local_db.provider.set_default_release_directive($cleanroom_name, 'V1_0', '2');

-- Example 10260
import numpy as np
import pandas as pd


def main(data, index):
    _ = pd.DataFrame(data)  # Just as an example of what we could do
    np.random.seed(0)

    # First let's combine the data row and the additional index into a string
    data.append(index)
    data_string = ",".join(str(d) for d in data)

    # Hash it
    encoded_data_string = data_string.encode()
    hashed_string = hash(encoded_data_string)

    # Return the hashed string
    return hashed_string

-- Example 10261
call samooha_by_snowflake_local_db.provider.get_stage_for_python_files($cleanroom_name);

-- Example 10262
-- @samooha_cleanroom_Custom_Secure_Python_UDF_Demo_clean_room.app.code/V1_0P1/ was returned by get_stage_for_python_files. You'll need
-- to use the specific path returned by get_stage_for_python_files for your own clean room.

PUT file://~/assign_group.py @samooha_cleanroom_Custom_Secure_Python_UDF_Demo_clean_room.app.code/V1_0P1/test_folder overwrite=True auto_compress=False;

-- Example 10263
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'assign_group',                      // Name of the UDF
    ['data variant', 'index integer'],   // Arguments of the UDF, specified as (variable name, variable type)
    ['numpy', 'pandas'],                 // Packages UDF will use
    ['/test_folder/assign_group.py'],                // Name of Python file to import, relative to stage folder uploaded to
    'integer',                           // Return type of UDF
    'assign_group.main'                  // Handler - now scoped to file
);

-- Example 10264
import pandas as pd


def main(s):
    s = pd.Series(s)
    return (s == "SILVER").sum()

-- Example 10265
call samooha_by_snowflake_local_db.provider.get_stage_for_python_files($cleanroom_name);

-- Example 10266
PUT file://~/group_agg.py @samooha_cleanroom_Custom_Secure_Python_UDF_Demo_clean_room.app.code/V1_0P2 overwrite=True auto_compress=False;

-- Example 10267
call samooha_by_snowflake_local_db.provider.load_python_into_cleanroom(
    $cleanroom_name,
    'group_agg',                         // Name of the UDF
    ['data variant'],                    // Arguments of the UDF, specified as (variable name, variable type)
    ['pandas'],                          // Packages UDF will use
    ['/group_agg.py'],                   // Name of Python file to import, relative to stage folder uploaded to
    'integer',                           // Return type of UDF
    'group_agg.main'                     // Handler - now scoped to file
);

-- Example 10268
call samooha_by_snowflake_local_db.provider.add_custom_sql_template(
    $cleanroom_name, 
    'prod_custom_udf_template', 
    $$
with enriched_provider_data as (
    select 
        cleanroom.assign_group(array_construct(identifier({{ filter_column | column_policy }}), identifier({{ dimensions[0] | column_policy }})), identifier({{ measure_column[0] | column_policy }})) as groupid,
        {{ filter_column | sqlsafe }},
        hem
    from identifier({{ source_table[0] }}) p
), filtered_data as (
    select 
        groupid,
        identifier({{ filter_column | column_policy }})
    from enriched_provider_data p
    inner join identifier({{ my_table[0] }}) c
    on p.hem = c.hem
    {% if where_clause %}
    where {{ where_clause | sqlsafe }}
    {% endif %}
)
select groupid, cleanroom.group_agg(array_agg({{ filter_column | sqlsafe }})) as count from filtered_data p
group by groupid;
    $$
);

-- Example 10269
call samooha_by_snowflake_local_db.provider.view_added_templates($cleanroom_name);

-- Example 10270
select * from SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS limit 10;

-- Example 10271
call samooha_by_snowflake_local_db.provider.set_column_policy($cleanroom_name, [
    'prod_custom_udf_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:STATUS', 
    'prod_custom_udf_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:REGION_CODE',
    'prod_custom_udf_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:AGE_BAND',
    'prod_custom_udf_template:SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS:DAYS_ACTIVE']);

-- Example 10272
call samooha_by_snowflake_local_db.provider.view_column_policy($cleanroom_name);

-- Example 10273
show versions in application package samooha_cleanroom_Custom_Secure_Python_UDF_Demo_clean_room;

-- Example 10274
call samooha_by_snowflake_local_db.provider.add_consumers($cleanroom_name, '<CONSMUMER_ACCOUNT_LOCATOR>');

-- Example 10275
call samooha_by_snowflake_local_db.provider.view_consumers($cleanroom_name);

-- Example 10276
call samooha_by_snowflake_local_db.provider.view_cleanrooms();

-- Example 10277
call samooha_by_snowflake_local_db.provider.describe_cleanroom($cleanroom_name);

-- Example 10278
call samooha_by_snowflake_local_db.provider.drop_cleanroom($cleanroom_name);

-- Example 10279
use role samooha_app_role;
use warehouse app_wh;

-- Example 10280
call samooha_by_snowflake_local_db.consumer.view_cleanrooms();

-- Example 10281
set cleanroom_name = 'Custom Secure Python UDF Demo clean room';

-- Example 10282
call samooha_by_snowflake_local_db.consumer.install_cleanroom($cleanroom_name, '<PROVIDER_ACCOUNT_LOCATOR>');

-- Example 10283
call samooha_by_snowflake_local_db.consumer.is_enabled($cleanroom_name);

-- Example 10284
call samooha_by_snowflake_local_db.consumer.link_datasets($cleanroom_name, ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS']);

-- Example 10285
use role accountadmin;
call samooha_by_snowflake_local_db.consumer.register_db('<DATABASE_NAME>');
use role samooha_app_role;

-- Example 10286
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10287
call samooha_by_snowflake_local_db.consumer.run_analysis(
  $cleanroom_name,               -- cleanroom
  'prod_custom_udf_template',    -- template name

  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],    -- consumer tables

  ['SAMOOHA_SAMPLE_DATABASE.DEMO.CUSTOMERS'],     -- provider tables

  object_construct(    -- Rest of the custom arguments needed for the template
    'filter_column', 'p.status',            -- One of the SQL Jinja arguments, the column the UDF filters on

    'dimensions', ['p.DAYS_ACTIVE'],
    
    'measure_column', ['p.AGE_BAND'],

    'where_clause', 'c.status = $$GOLD$$'   -- A boolean filter applied to the data
  )
);

-- Example 10288
call samooha_by_snowflake_local_db.consumer.view_added_templates($cleanroom_name);

-- Example 10289
call samooha_by_snowflake_local_db.consumer.view_template_definition($cleanroom_name, 'prod_custom_udf_template');

-- Example 10290
call samooha_by_snowflake_local_db.consumer.get_arguments_from_template($cleanroom_name, 'prod_custom_udf_template');

-- Example 10291
call samooha_by_snowflake_local_db.consumer.view_provider_datasets($cleanroom_name);

-- Example 10292
call samooha_by_snowflake_local_db.consumer.view_consumer_datasets($cleanroom_name);

-- Example 10293
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10294
call samooha_by_snowflake_local_db.consumer.view_provider_join_policy($cleanroom_name);
call samooha_by_snowflake_local_db.consumer.view_provider_column_policy($cleanroom_name);

-- Example 10295
call samooha_by_snowflake_local_db.consumer.view_remaining_privacy_budget($cleanroom_name);

-- Example 10296
call samooha_by_snowflake_local_db.consumer.is_dp_enabled($cleanroom_name);

-- Example 10297
use role samooha_app_role;
use warehouse app_wh;

