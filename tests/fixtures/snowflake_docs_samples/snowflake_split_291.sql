-- Example 19475
{
  SHOW SNOWFLAKE.CORE.BUDGET           |
  SHOW SNOWFLAKE.CORE.BUDGET INSTANCES
}
  [ LIKE '<pattern>' ]
  [ IN
        {
          ACCOUNT                  |

          DATABASE                 |
          DATABASE <database_name> |

          SCHEMA                   |
          SCHEMA <schema_name>     |
          <schema_name>
        }
  ]
  [ LIMIT <rows> [ FROM '<name_string>' ]

-- Example 19476
SHOW SNOWFLAKE.CORE.BUDGET INSTANCES IN SCHEMA budget_db.budget_schema;

-- Example 19477
SHOW SNOWFLAKE.CORE.BUDGET LIKE '%DEPT%' IN SCHEMA budget_db.budget_schema;

-- Example 19478
CALL account_root_budget!ACTIVATE()

-- Example 19479
activated

-- Example 19480
CALL snowflake.local.account_root_budget!ACTIVATE();

-- Example 19481
<budget_name>!ADD_NOTIFICATION_INTEGRATION( '<integration_name>' )

-- Example 19482
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!ADD_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration',
);

-- Example 19483
<budget_name>!ADD_RESOURCE( { '<object_reference>' | <reference_statement> } )

-- Example 19484
Successfully added resource to resource group

-- Example 19485
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'APPLYBUDGET');

-- Example 19486
ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7

-- Example 19487
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  'ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7');

-- Example 19488
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  SELECT SYSTEM$REFERENCE('TABLE', 't2', 'SESSION', 'APPLYBUDGET'));

-- Example 19489
CALL budget_db.budget_schema.my_budget!ADD_RESOURCE(
  SELECT SYSTEM$REFERENCE('DATABASE', 'my_app', 'SESSION', 'APPLYBUDGET'));

-- Example 19490
CALL account_root_budget!DEACTIVATE()

-- Example 19491
Deactivated!

-- Example 19492
CALL snowflake.local.account_root_budget!DEACTIVATE();

-- Example 19493
<budget_name>!GET_CONFIG()

-- Example 19494
CALL budget_db.budget_schema.my_budget!GET_CONFIG();

-- Example 19495
CALL snowflake.local.account_root_budget!GET_CONFIG();

-- Example 19496
<budget_name>!GET_LINKED_RESOURCES()

-- Example 19497
CALL budget_db.budget_schema.my_budget!GET_LINKED_RESOURCES();

-- Example 19498
<budget_name>!GET_MEASUREMENT_TABLE()

-- Example 19499
CALL budget_db.budget_schema.my_budget!GET_MEASUREMENT_TABLE();

-- Example 19500
CALL snowflake.local.account_root_budget!GET_MEASUREMENT_TABLE();

-- Example 19501
<budget_name>!GET_NOTIFICATION_EMAIL()

-- Example 19502
CALL budget_db.budget_schema.my_budget!GET_NOTIFICATION_EMAIL();

-- Example 19503
CALL snowflake.local.account_root_budget!GET_NOTIFICATION_EMAIL();

-- Example 19504
<budget_name>!GET_NOTIFICATION_INTEGRATION_NAME()

-- Example 19505
CALL budget_db.budget_schema.my_budget!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 19506
CALL snowflake.local.account_root_budget!GET_NOTIFICATION_INTEGRATION_NAME();

-- Example 19507
<budget_name>!GET_NOTIFICATION_INTEGRATIONS()

-- Example 19508
CALL budget_db.budget_schema.my_budget!GET_NOTIFICATION_INTEGRATIONS();

-- Example 19509
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!GET_NOTIFICATION_INTEGRATIONS();

-- Example 19510
<budget_name>!GET_NOTIFICATION_MUTE_FLAG()

-- Example 19511
CALL budget_db.budget_schema.my_budget!GET_NOTIFICATION_MUTE_FLAG();

-- Example 19512
CALL snowflake.local.account_root_budget!GET_NOTIFICATION_MUTE_FLAG();

-- Example 19513
<budget_name>!GET_SERVICE_TYPE_USAGE( SERVICE_TYPE => '<service_type>' ,
                                      TIME_DEPART => '<time_interval>' ,
                                      USER_TIMEZONE => '<timezone>' ,
                                      TIME_LOWER_BOUND => <constant_expr> ,
                                      TIME_UPPER_BOUND => <constant_expr>
                                    )

-- Example 19514
CALL snowflake.local.account_root_budget!GET_SERVICE_TYPE_USAGE(
   SERVICE_TYPE => 'WAREHOUSE_METERING',
   TIME_DEPART => 'day',
   USER_TIMEZONE => 'UTC',
   TIME_LOWER_BOUND => dateadd('day', -7, current_timestamp()),
   TIME_UPPER_BOUND => current_timestamp()
);

-- Example 19515
<budget_name>!GET_SPENDING_HISTORY( [ TIME_LOWER_BOUND => <constant_expr> ,
                                      TIME_UPPER_BOUND => <constant_expr> ] )

-- Example 19516
CALL budget_db.budget_schema.my_budget!GET_SPENDING_HISTORY();

-- Example 19517
CALL snowflake.local.account_root_budget!GET_SPENDING_HISTORY(
  TIME_LOWER_BOUND=>dateadd('days', -7, current_timestamp()),
  TIME_UPPER_BOUND=>current_timestamp()
);

-- Example 19518
<budget_name>!GET_SPENDING_LIMIT()

-- Example 19519
CALL budget_db.budget_schema.my_budget!GET_SPENDING_LIMIT();

-- Example 19520
CALL snowflake.local.account_root_budget!GET_SPENDING_LIMIT();

-- Example 19521
<budget_name>!REMOVE_NOTIFICATION_INTEGRATION( '<integration_name>' )

-- Example 19522
CALL budget_db.budget_schema.my_budget!REMOVE_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration');

-- Example 19523
CALL SNOWFLAKE.LOCAL.ACCOUNT_ROOT_BUDGET!REMOVE_NOTIFICATION_INTEGRATION(
  'budgets_notification_integration');

-- Example 19524
<budget_name>!REMOVE_RESOURCE( { '<object_reference>' | <reference_statement> } )

-- Example 19525
Successfully removed resource from resource group

-- Example 19526
SELECT SYSTEM$REFERENCE('TABLE', 't1', 'SESSION', 'APPLYBUDGET');

-- Example 19527
ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7

-- Example 19528
CALL budget_db.budget_schema.my_budget!REMOVE_RESOURCE(
  'ENT_REF_TABLE_5862683050074_5AEB8D58FB3ACF249F2E35F365A9357C46BB00D7');

-- Example 19529
CALL budget_db.budget_schema.my_budget!REMOVE_RESOURCE(
  SELECT SYSTEM$REFERENCE('TABLE', 't2', 'SESSION', 'APPLYBUDGET')

-- Example 19530
CALL budget_db.budget_schema.my_budget!REMOVE_RESOURCE(
  SELECT SYSTEM$REFERENCE('DATABASE', 'my_app', 'SESSION', 'APPLYBUDGET'));

-- Example 19531
<budget_name>!SET_EMAIL_NOTIFICATIONS( [ '<notification_integration>', ]
                                       '<email> [ , <email> [ , ... ] ]' )

-- Example 19532
The email integration is updated.

-- Example 19533
GRANT USAGE ON INTEGRATION budgets_notification_integration
  TO APPLICATION SNOWFLAKE;

-- Example 19534
CALL budgets_db.budgets_schema.my_budget!SET_EMAIL_NOTIFICATIONS(
   'costadmin@domain.com, budgetadmin@domain.com');

-- Example 19535
CALL snowflake.local.account_root_budget!SET_EMAIL_NOTIFICATIONS(
   'budgets_notification', 'budgetadmin@domain.com');

-- Example 19536
<budget_name>!SET_NOTIFICATION_MUTE_FLAG( { TRUE | FALSE } );

-- Example 19537
The notification mute flag has been updated to <true | false>.

-- Example 19538
CALL budget_db.budget_schema.my_budget!SET_NOTIFICATION_MUTE_FLAG(TRUE);

-- Example 19539
CALL snowflake.local.account_root_budget!SET_NOTIFICATION_MUTE_FLAG(FALSE);

-- Example 19540
<budget_name>!SET_SPENDING_LIMIT(<number>)

-- Example 19541
The spending limit has been updated to <n> credits.

