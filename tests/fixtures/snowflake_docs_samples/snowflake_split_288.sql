-- Example 19274
REVOKE ROLE analyst FROM ROLE SYSADMIN;

-- Example 19275
REVOKE ROLE analyst FROM USER user1;

-- Example 19276
REVOKE SERVICE ROLE <name> FROM
{
  ROLE <role_name>                     |
  APPLICATION ROLE <application_role_name>  |
  DATABASE ROLE <database_role_name>
}

-- Example 19277
REVOKE SERVICE ROLE echo_service!echoendpoint_role FROM ROLE service_function_user_role;

-- Example 19278
ROLLBACK [ WORK ]

-- Example 19279
SELECT COUNT(*) FROM A1;

+----------+
| COUNT(*) |
|----------+
|        0 |
+----------+

BEGIN NAME T4;

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------+
| 1432071523422         |
+-----------------------+

INSERT INTO A1 VALUES (1), (2);

+-------------------------+
| number of rows inserted |
|-------------------------+
| 2                       |
+-------------------------+

ROLLBACK;

SELECT COUNT(*) FROM A1;

+----------+
| COUNT(*) |
|----------+
|        0 |
+----------+

SELECT CURRENT_TRANSACTION();

+-----------------------+
| CURRENT_TRANSACTION() |
|-----------------------+
| [NULL]                |
+-----------------------+

SELECT LAST_TRANSACTION();

+--------------------+
| LAST_TRANSACTION() |
|--------------------+
| 1432071523422      |
+--------------------+

-- Example 19280
SET <var> = <expr>

SET ( <var> [ , <var> ... ] )  = ( <expr> [ , <expr> ... ] )

-- Example 19281
SET V1 = 10;

SET V2 = 'example';

-- Example 19282
SET (V1, V2) = (10, 'example');

-- Example 19283
SET id_threshold = (SELECT COUNT(*)/2 FROM table1);

-- Example 19284
SET (min, max) = (40, 70);

-- Example 19285
SET (min, max) = (50, 2 * $min);

SELECT $max;

-- Example 19286
+------+
| $MAX |
|------|
|   80 |
+------+

-- Example 19287
SHOW AUTHENTICATION POLICIES
  [ LIKE '<pattern>' ]
  [ IN
       {
         ACCOUNT                                         |

         DATABASE                                        |
         DATABASE <database_name>                        |

         SCHEMA                                          |
         SCHEMA <schema_name>                            |

         APPLICATION <application_name>                  |
         APPLICATION PACKAGE <application_package_name>  |
       }
    |
    ON
       {
         ACCOUNT           |
         USER <user_name>  |
       }
  ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> ]

-- Example 19288
SHOW AUTHENTICATION POLICIES;

-- Example 19289
SHOW CALLER GRANTS
{
{ ON <object_type> <object_name> | ON ACCOUNT }
| TO { ROLE | DATABASE ROLE }  <owner_name>
}

-- Example 19290
SHOW CALLER GRANTS ON TABLE t1;

-- Example 19291
SHOW CALLER GRANTS ON ACCOUNT;

-- Example 19292
SHOW CALLER GRANTS TO DATABASE ROLE db.owner_role;

-- Example 19293
SHOW CATALOG INTEGRATIONS [ LIKE '<pattern>' ]

-- Example 19294
SHOW CATALOG INTEGRATIONS;

-- Example 19295
SHOW CATALOG INTEGRATIONS LIKE 'demo%';

-- Example 19296
SHOW CHANNELS [ LIKE '<pattern>' ]
           [ IN
                {
                  ACCOUNT                  |

                  DATABASE                 |
                  DATABASE <database_name> |

                  SCHEMA                   |
                  SCHEMA <schema_name>     |
                  <schema_name>

                  TABLE                    |
                  TABLE <table_name>
                }
           ]

-- Example 19297
use database mydb;

show channels;

+-------------------------------+-----------+---------------+------------------+------------------------+------------------+---------------+--------------+
| created_on                    | name      | database_name | schema_name      | table_name             | client_sequencer | row_sequencer | offset_token |
|-------------------------------+-----------+---------------+------------------+------------------------+------------------+---------------+--------------+
| 2023-05-05 17:13:17.579 -0700 | CHANNEL8  | TEST_DB1      | STREAMING_INGEST | STREAMING_INGEST_TABLE | 7                | 1             | 0            |
|                               |           |               |                  |                        |                  |               |              |
+-------------------------------+-----------+---------------+------------------+------------------------+------------------+---------------+--------------+

-- Example 19298
SHOW CLASSES [ LIKE '<pattern>' ]
             [ IN DATABASE [ <db_name> ] ]
             [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19299
SHOW CLASSES IN DATABASE SNOWFLAKE;

+-------------------------------+-----------------------+---------------+-------------+---------+---------+-------+------------------+-----------------+
| created_on                    | name                  | database_name | schema_name | version | comment | owner | is_service_class | owner_role_type |
|-------------------------------+-----------------------+---------------+-------------+---------+---------+-------|------------------|-----------------+
| 2023-04-17 11:48:31.222 -0700 | ANOMALY_DETECTION     | SNOWFLAKE     | ML          | NULL    | NULL    |       | false            |                 |
| 2023-05-26 10:01:24.852 -0700 | FORECAST              | SNOWFLAKE     | ML          | NULL    | NULL    |       | false            |                 |
+-------------------------------+-----------------------+---------------+-------------+---------+---------+-------+------------------+-----------------+

-- Example 19300
SHOW COMPUTE POOLS [ LIKE '<pattern>' ]
                   [ STARTS WITH '<name_string>' ]
                   [ LIMIT <ROWS> [ FROM '<name-string>' ] ]

-- Example 19301
SHOW COMPUTE POOLS;

-- Example 19302
SHOW COMPUTE POOLS LIMIT 1;

-- Example 19303
SHOW COMPUTE POOLS LIKE '%tu%';

-- Example 19304
SHOW COMPUTE POOLS LIKE '%my_pool%' LIMIT 2;

-- Example 19305
+-------------------------+-----------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+--------------+-------------+--------+
| name                    | state     | min_nodes | max_nodes | instance_family | num_services | num_jobs | auto_suspend_secs | auto_resume | active_nodes | idle_nodes | target_nodes | created_on                    | resumed_on                    | updated_on                    | owner        | comment | is_exclusive | application | budget |
|-------------------------+-----------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+--------------+-------------+--------|
| TUTORIAL_COMPUTE_POOL   | ACTIVE    |         1 |         1 | CPU_X64_XS      |            3 |        0 |              3600 | true        |            1 |          0 |            1 | 2024-02-24 20:41:31.978 -0800 | 2024-08-08 11:27:01.775 -0700 | 2024-08-18 13:47:08.150 -0700 | TEST_ROLE    | NULL    | false        | NULL        | NULL   |
| TUTORIAL_COMPUTE_POOL_2 | SUSPENDED |         1 |         1 | CPU_X64_XS      |            0 |        0 |              3600 | true        |            0 |          0 |            0 | 2024-01-15 21:23:09.744 -0800 | 2024-04-06 15:24:50.541 -0700 | 2024-08-18 13:46:08.110 -0700 | ACCOUNTADMIN | NULL    | false        | NULL        | NULL   |
+-------------------------+-----------+-----------+-----------+-----------------+--------------+----------+-------------------+-------------+--------------+------------+--------------+-------------------------------+-------------------------------+-------------------------------+--------------+---------+--------------+-------------+--------+

-- Example 19306
SHOW CORTEX SEARCH SERVICES
  [ LIKE PATTERN '<pattern>' ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19307
USE DATABASE mydb;

SHOW CORTEX SEARCH SERVICES;

-- Example 19308
SHOW DATA METRIC FUNCTIONS
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
  [ STARTS WITH '<name_string>' ]

-- Example 19309
USE SCHEMA governance.dmfs;

SHOW DATA METRIC FUNCTIONS;

-- Example 19310
+--------------------------+------------------------+-------------+------------+--------------+---------+-------------------+-------------------+--------------------------------------------------------------------------------------------+-----------------------+--------------+-------------------+----------------------+-----------+----------------------+----------+---------------+----------------+
| created_on               | name                   | schema_name | is_builtin | is_aggregate | is_ansi | min_num_arguments | max_num_arguments | arguments                                                                                  | description           | catalog_name | is_table_function | valid_for_clustering | is_secure | is_external_function | language | is_memoizable | is_data_metric |
+--------------------------+------------------------+-------------+------------+--------------+---------+-------------------+-------------------+--------------------------------------------------------------------------------------------+-----------------------+--------------+-------------------+----------------------+-----------+----------------------+----------+---------------+----------------+
| 2023-12-11T23:30:02.785Z | COUNT_POSITIVE_NUMBERS | DMFS        | N          | N            | N       | 1                 | 1                 | "COUNT_POSITIVE_NUMBERS(TABLE(NUMBER, NUMBER, NUMBER)) RETURNS NUMBER"                     | user-defined function | GOVERNANCE   | N                 | N                    | N         | N                    | SQL      | N             | Y              |
+--------------------------+------------------------+-------------+------------+--------------+---------+-------------------+-------------------+--------------------------------------------------------------------------------------------+-----------------------+--------------+-------------------+----------------------+-----------+----------------------+----------+---------------+----------------+

-- Example 19311
SHOW DATABASE ROLES IN DATABASE <name>
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19312
SHOW DATABASE ROLES IN DATABASE mydb LIMIT 10 FROM 'db_role2';

-- Example 19313
SHOW DATABASES IN FAILOVER GROUP <name>

-- Example 19314
SHOW DATABASES IN FAILOVER GROUP myfg;

-- Example 19315
SHOW DATABASES IN REPLICATION GROUP <name>

-- Example 19316
SHOW DATABASES IN REPLICATION GROUP myrg;

-- Example 19317
SHOW DELEGATED AUTHORIZATIONS

SHOW DELEGATED AUTHORIZATIONS BY USER <username>

SHOW DELEGATED AUTHORIZATIONS TO SECURITY INTEGRATION <integration_name>

-- Example 19318
SHOW DELEGATED AUTHORIZATIONS;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
|-------------------------------+-----------+-----------+-------------------+--------------------|
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT1     | ENABLED            |
| 2018-11-27 08:14:56.123 -0800 | MJONES    | PUBLIC    | MY_OAUTH_INT2     | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 19319
SHOW DELEGATED AUTHORIZATIONS BY USER jsmith;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
|-------------------------------+-----------+-----------+-------------------+--------------------|
| 2018-11-27 07:43:10.914 -0800 | JSMITH    | PUBLIC    | MY_OAUTH_INT1     | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 19320
SHOW DELEGATED AUTHORIZATIONS TO SECURITY INTEGRATION my_oauth_int2;

+-------------------------------+-----------+-----------+-------------------+--------------------+
| created_on                    | user_name | role_name | integration_name  | integration_status |
|-------------------------------+-----------+-----------+-------------------+--------------------|
| 2018-11-27 08:14:56.123 -0800 | MJONES    | PUBLIC    | MY_OAUTH_INT2     | ENABLED            |
+-------------------------------+-----------+-----------+-------------------+--------------------+

-- Example 19321
SHOW DYNAMIC TABLES [ LIKE '<pattern>' ]
                    [ IN
                      {
                           ACCOUNT              |

                           DATABASE             |
                           DATABASE <db_name>   |

                           SCHEMA               |
                           SCHEMA <schema_name> |
                           <schema_name>
                      }
                    ]
                    [ STARTS WITH '<name_string>' ]
                    [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19322
SHOW DYNAMIC TABLES LIKE 'product_%' IN SCHEMA mydb.myschema;

-- Example 19323
SHOW [ TERSE ] EVENT TABLES [ LIKE '<pattern>' ]
  [ IN { ACCOUNT | DATABASE [ <db_name> ] | SCHEMA [ <schema_name> ] } ]
  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19324
SHOW EVENT TABLES LIKE 'mylogs%' IN tpch.public;

-- Example 19325
SHOW EXTERNAL FUNCTIONS [ LIKE '<pattern>' ]
           [ IN { APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> }  ]

-- Example 19326
SHOW EXTERNAL FUNCTIONS;

-- Example 19327
SHOW EXTERNAL FUNCTIONS LIKE 'SQUARE%';

-- Example 19328
SHOW [ TERSE ] EXTERNAL TABLES [ LIKE '<pattern>' ]
                               [ IN
                                        {
                                          ACCOUNT                                         |

                                          DATABASE                                        |
                                          DATABASE <database_name>                        |

                                          SCHEMA                                          |
                                          SCHEMA <schema_name>                            |
                                          <schema_name>

                                          APPLICATION <application_name>                  |
                                          APPLICATION PACKAGE <application_package_name>  |
                                        }
                               ]
                               [ STARTS WITH '<name_string>' ]
                               [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19329
SHOW EXTERNAL TABLES LIKE 'line%' IN tpch.public;

-- Example 19330
SHOW EXTERNAL VOLUMES [ LIKE '<pattern>' ]

-- Example 19331
SHOW EXTERNAL VOLUMES;

-- Example 19332
SHOW EXTERNAL VOLUMES LIKE 'aws%';

-- Example 19333
SHOW FAILOVER GROUPS [ IN ACCOUNT <account> ]

-- Example 19334
SHOW FAILOVER GROUPS IN ACCOUNT myaccount1;

+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| snowflake_region | created_on                    | account_name | name | type     | comment | is_primary | primary               | object_types                                | allowed_integration_types |  allowed_accounts                            | organization_name | account_locator   | replication_schedule | secondary_state | next_scheduled_refresh        | owner      | is_listing_auto_fulfillment_group |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| AWS_US_EAST_1    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT1   | MYFG | FAILOVER |         | true       | MYORG.MYACCOUNT1.MYFG | DATABASES, ROLES, USERS, WAREHOUSES, SHARES |                           | MYORG.MYACCOUNT1.MYFG,MYORG.MYACCOUNT2.MYFG  | MYORG             | MYACCOUNT1LOCATOR | 10 MINUTE            | NULL            |                               | MYROLE     | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+
| AWS_US_WEST_2    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT2   | MYFG | FAILOVER |         | false      | MYORG.MYACCOUNT1.MYFG |                                             |                           |                                              | MYORG             | MYACCOUNT2LOCATOR | 10 MINUTE            | STARTED         | 2022-03-06 12:10:35.280 -0800 | NULL       | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+------------+-----------------------------------+

-- Example 19335
SHOW FILE FORMATS [ LIKE '<pattern>' ]
                  [ IN
                       {
                          ACCOUNT                                         |

                          DATABASE                                        |
                          DATABASE <database_name>                        |

                          SCHEMA                                          |
                          SCHEMA <schema_name>                            |
                          <schema_name>

                          APPLICATION <application_name>                  |
                          APPLICATION PACKAGE <application_package_name>  |
                       }
                  ]

-- Example 19336
USE DATABASE testdb;

SHOW FILE FORMATS;

-- Example 19337
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| created_on                      | name      | database_name | schema_name | type | owner        | comment | owner_role_type |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| Wed, 29 Apr 2015 18:59:03 -0700 | MY_FORMAT | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | CSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | VSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | TSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+

-- Example 19338
SHOW FILE FORMATS IN DATABASE testdb;

-- Example 19339
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| created_on                      | name      | database_name | schema_name | type | owner        | comment | owner_role_type |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| Wed, 29 Apr 2015 18:59:03 -0700 | MY_FORMAT | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | CSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | VSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | TSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+

-- Example 19340
SHOW FILE FORMATS IN SCHEMA testdb.public;

