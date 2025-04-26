-- Example 19341
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| created_on                      | name      | database_name | schema_name | type | owner        | comment | owner_role_type |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+
| Wed, 29 Apr 2015 18:59:03 -0700 | MY_FORMAT | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | CSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | VSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
| Mon, 27 Apr 2015 17:49:12 -0700 | TSV       | TESTDB        | PUBLIC      | CSV  | ACCOUNTADMIN |         | ROLE            |
+---------------------------------+-----------+---------------+-------------+------+--------------+---------+-----------------+

-- Example 19342
SHOW FUNCTIONS [ LIKE '<pattern>' ] IN MODEL <model_name>
               [ VERSION <version_name> ]

-- Example 19343
SHOW GLOBAL ACCOUNTS [ LIKE '<pattern>' ]

-- Example 19344
SHOW GLOBAL ACCOUNTS LIKE 'myaccount%';

-- Example 19345
SHOW [ TERSE ] [ ICEBERG ] TABLES [ LIKE '<pattern>' ]
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
                                  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19346
[
  {
    "field-id": 1,
    "names": [
      "id",
      "record_id"
    ]
  },
  {
    "field-id": 2,
    "names": [
      "data"
    ]
  },
  {
    "field-id": 3,
    "names": [
      "location"
    ],
    "fields": [
      {
        "field-id": 4,
        "names": [
          "latitude",
          "lat"
        ]
      },
      {
        "field-id": 5,
        "names": [
          "longitude",
          "long"
        ]
      }
    ]
  }
]

-- Example 19347
SHOW ICEBERG TABLES LIKE 'glue%' IN tpch.public;

-- Example 19348
SHOW JOIN POLICIES  [ LIKE '<pattern>' ]
                           [ IN
                               {
                                 ACCOUNT |
                                 DATABASE [ <database_name> ] |
                                 SCHEMA [ <schema_name> ] |
                               }
                           ]

-- Example 19349
SHOW JOIN POLICIES;

-- Example 19350
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+
| created_on                    | name | database_name | schema_name    | kind        | owner        | comment | owner_role_type | options |
|-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------|
| 2024-12-04 15:15:49.591 -0800 | JP1  | POLICY1_DB    | POLICY1_SCHEMA | JOIN_POLICY | POLICY1_ROLE |         | ROLE            |         |
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+

-- Example 19351
SHOW LISTINGS [ LIKE '<pattern>' ]
              [ STARTS WITH '<name_string>' ]
              [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19352
SHOW LISTINGS LIKE 'MYLISTING%'

-- Example 19353
SHOW LISTINGS LIMIT 10 FROM 'MYLISTING%'

-- Example 19354
SHOW LOCKS [ IN ACCOUNT ]

-- Example 19355
SHOW LOCKS;

-- Example 19356
+---------------------------+------------+---------------------+-------------------------------+---------+-------------------------------+--------------------------------------+
| resource                  | type       |         transaction | transaction_started_on        | status  | acquired_on                   | query_id                             |
|---------------------------+------------+---------------------+-------------------------------+---------+-------------------------------+--------------------------------------|
| CALIBAN_DB.PUBLIC.WEATHER | PARTITIONS | 1721330303831000000 | 2024-07-18 12:18:23.831 -0700 | HOLDING | 2024-07-18 12:18:49.832 -0700 | 01b5c1c6-0002-8691-0000-a9950068a0c6 |
+---------------------------+------------+---------------------+-------------------------------+---------+-------------------------------+--------------------------------------+

-- Example 19357
SHOW LOCKS;

-- Example 19358
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+
| resource            | type |         transaction | transaction_started_on        | status  | acquired_on | query_id                             |
|---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------|
| 1721165584820000000 | ROW  | 1721165584820000000 | 2024-07-16 14:33:04.820 -0700 | HOLDING | NULL        |                                      |
| 1721165584820000000 | ROW  | 1721165674582000000 | 2024-07-16 14:34:34.582 -0700 | WAITING | NULL        | 01b5b715-0002-852b-0000-a99500665352 |
+---------------------+------+---------------------+-------------------------------+---------+-------------+--------------------------------------+

-- Example 19359
SHOW MANAGED ACCOUNTS [ LIKE '<pattern>' ]

-- Example 19360
SHOW MANAGED ACCOUNTS;

-- Example 19361
+--------------+-------+-----------+---------+-------------------------------+--------------------------------------------+----------------------------------------+-----------+---------+----------------+
| name         | cloud | region    | locator | created_on                    | url                                        |  account_locator_url                   | is_reader | comment |  region_group  |
|--------------+-------+-----------+---------+-------------------------------+--------------------------------------------+----------------------------------------+-----------+---------|----------------|
| ACCT1        | aws   | us-west-2 | RE47190 | 2018-05-30 14:38:54.479 -0700 | https://bazco-acct1.snowflakecomputing.com  |  https://re47190.snowflakecomputing.com | true    |         |     PUBLIC     |
+--------------+-------+-----------+---------+-------------------------------+--------------------------------------------+----------------------------------------+-----------+---------+----------------+

-- Example 19362
SHOW MODEL MONITORS
[ LIKE <pattern> ]
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

-- Example 19363
SHOW NETWORK POLICIES

-- Example 19364
SHOW NETWORK POLICIES;

-- Example 19365
+-------------------------------+----------+---------+----------------------------+----------------------------+---------------------------------------------------------------------+
| created_on                    | name     | comment | entries_in_allowed_ip_list | entries_in_blocked_ip_list | entries_in_allowed_network_rules | entries_in_blocked_network_rules |
|-------------------------------+----------+---------+----------------------------+----------------------------+----------------------------------+----------------------------------|
| 2016-04-29 13:22:34.034 -0700 | Policy1  |         |                          2 |                          1 |                                 0|                                0 |
| 2016-04-28 17:31:59.269 -0700 | Policy2  |         |                          1 |                          0 |                                 0|                                0 |
+-------------------------------+----------+---------+----------------------------+----------------------------+----------------------------------+----------------------------------+

-- Example 19366
SHOW NETWORK RULES [ LIKE '<pattern>' ]
                   [ IN { ACCOUNT | DATABASE [ <db_name> ] | [ SCHEMA ] [ <schema_name> ] } ]
                   [ STARTS WITH '<name_string>' ]
                   [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19367
SHOW NETWORK RULES;

-- Example 19368
SHOW NOTEBOOKS [ LIKE '<pattern>' ]
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
               [ LIMIT <rows> ]
               [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19369
SHOW NOTEBOOKS;

-- Example 19370
SHOW NOTEBOOKS STARTS WITH 'test';

-- Example 19371
+--------------------------------+--------------+---------------+----------------------------------------------------------------------------------+--------+-----------------+----------------------+-----------------+------------------------------+
| created_on                     | name         | database_name | schema_name | comment                                                            | owner  | query_warehouse | url_id               | owner_role_type | code_warehouse               |
+--------------------------------+--------------+---------------+----------------------------------------------------------------------------------+--------+-----------------+----------------------+-----------------+------------------------------+
|  2024-03-20 06:37:08.402 +0000 | test_notebook| PUBLIC        | PUBLIC      | {"lastUpdatedUser":"309334439262","lastUpdatedTime":1711566800002} | PUBLIC | HLEVE1          | 2mbdchin3kn2tlzgqtca | ROLE            | SYSTEM$STREAMLIT_NOTEBOOK_WH |
+--------------------------------+--------------+---------------+-------------+--------------------------------------------------------------------+--------+-----------------+----------------------+-----------------+------------------------------+

-- Example 19372
SHOW NOTIFICATION INTEGRATIONS [ LIKE '<pattern>' ]

-- Example 19373
SHOW NOTIFICATION INTEGRATIONS;

-- Example 19374
+-----------------------------+-----------------------------+--------------+---------+---------+-------------------------------+-----------+
| name                        | type                        | category     | enabled | comment | created_on                    | direction |
|-----------------------------+-----------------------------+--------------+---------+---------+-------------------------------+-----------|
| MY_AZURE_INBOUND_QUEUE_INT  | QUEUE - AZURE_STORAGE_QUEUE | NOTIFICATION | true    | NULL    | 2025-03-08 11:34:55.861 -0800 | INBOUND   |
| MY_GCP_INBOUND_QUEUE_INT    | QUEUE - GCP_PUBSUB          | NOTIFICATION | true    | NULL    | 2025-03-08 11:35:35.163 -0800 | INBOUND   |
| MY_GCP_OUTBOUND_QUEUE_INT   | QUEUE - GCP_PUBSUB          | NOTIFICATION | true    | NULL    | 2025-03-08 11:37:06.487 -0800 | OUTBOUND  |
| MY_AWS_OUTBOUND_QUEUE_INT   | QUEUE - AWS_SNS             | NOTIFICATION | true    | NULL    | 2025-03-08 11:36:13.072 -0800 | OUTBOUND  |
| MY_EMAIL_INT                | EMAIL                       | NOTIFICATION | true    | NULL    | 2025-03-08 11:38:55.866 -0800 | OUTBOUND  |
| MY_AZURE_OUTBOUND_QUEUE_INT | QUEUE - AZURE_EVENT_GRID    | NOTIFICATION | true    | NULL    | 2025-03-08 11:36:40.822 -0800 | OUTBOUND  |
| MY_WEBHOOK_INT              | WEBHOOK                     | NOTIFICATION | true    | NULL    | 2025-03-08 11:40:17.336 -0800 | OUTBOUND  |
+-----------------------------+-----------------------------+--------------+---------+---------+-------------------------------+-----------+

-- Example 19375
SHOW [ TERSE ] OBJECTS [ LIKE '<pattern>' ]
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

-- Example 19376
SHOW OBJECTS IN DATABASE STARTS WITH 'HT_';

-- Example 19377
+-------------------------------+------------------------+---------------+----------------+-------+---------+------------+---------+-----------+--------------+----------------+-----------------+--------+-----------+------------+
| created_on                    | name                   | database_name | schema_name    | kind  | comment | cluster_by |    rows |     bytes | owner        | retention_time | owner_role_type | budget | is_hybrid | is_dynamic |
|-------------------------------+------------------------+---------------+----------------+-------+---------+------------+---------+-----------+--------------+----------------+-----------------+--------+-----------+------------|
| 2024-05-13 19:08:41.946 -0700 | HT_PRECIP              | HYBRID1_DB    | HYBRID1_SCHEMA | TABLE |         |            |       0 |         0 | HYBRID1_ROLE | 1              | ROLE            | NULL   | Y         | N          |
| 2024-08-23 11:44:13.694 -0700 | HT_SENSOR_DATA_DEVICE1 | HYBRID1_DB    | HYBRID1_SCHEMA | TABLE |         |            | 2678400 | 133920000 | HYBRID1_ROLE | 1              | ROLE            | NULL   | Y         | N          |
| 2024-05-13 16:37:29.217 -0700 | HT_WEATHER             | HYBRID1_DB    | HYBRID1_SCHEMA | TABLE |         |            |      55 |      2985 | HYBRID1_ROLE | 1              | ROLE            | NULL   | Y         | N          |
| 2024-07-18 12:17:27.381 -0700 | HT_WEATHER             | HYBRID1_DB    | PUBLIC         | TABLE |         |            |      55 |      3040 | ACCOUNTADMIN | 1              | ROLE            | NULL   | Y         | N          |
+-------------------------------+------------------------+---------------+----------------+-------+---------+------------+---------+-----------+--------------+----------------+-----------------+--------+-----------+------------+

-- Example 19378
SHOW ORGANIZATION ACCOUNTS [ LIKE '<pattern>' ]

-- Example 19379
SHOW ORGANIZATION ACCOUNTS;

-- Example 19380
SHOW PACKAGES POLICIES [ IN
                            {
                              SCHEMA                   |
                              SCHEMA <schema_name>     |
                              <schema_name>
                            }
                       ]

-- Example 19381
SHOW PACKAGES POLICIES;

-- Example 19382
SHOW PASSWORD POLICIES [ LIKE '<pattern>' ]
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

-- Example 19383
SHOW PASSWORD POLICIES;

-- Example 19384
+---------------------------------+------------------------+------------+------------------------------------+---------+
| CREATED_ON                      | NAME                   | OWNER      | COMMENT                            | options |
+---------------------------------+------------------------+------------+------------------------------------+---------+
| Fri, 10 Dec 2021 00:00:00 -0700 | PASSWORD_POLICY_PROD_1 | PROD_ADMIN | production account password policy | ""      |
+---------------------------------+------------------------+------------+------------------------------------+---------+

-- Example 19385
SHOW [ TERSE ] PRIMARY KEYS
    [ IN { ACCOUNT | DATABASE [ <database_name> ] | SCHEMA [ <schema_name> ] | TABLE | [ TABLE ] <table_name> } ]

-- Example 19386
SHOW PRIMARY KEYS;

SHOW PRIMARY KEYS IN ACCOUNT;

SHOW PRIMARY KEYS IN DATABASE;

SHOW PRIMARY KEYS IN DATABASE my_database;

SHOW PRIMARY KEYS IN SCHEMA;

SHOW PRIMARY KEYS IN SCHEMA my_schema;

SHOW PRIMARY KEYS IN SCHEMA my_database.my_schema;

SHOW PRIMARY KEYS IN my_table;

SHOW PRIMARY KEYS IN my_database.my_schema.my_table;

-- Example 19387
SHOW PRIVACY POLICIES [ LIKE '<pattern>' ]
           [ IN
                {
                  ACCOUNT
                  | DATABASE [ <database_name> ]
                  | SCHEMA [ <schema_name> ]
                }
           ]

-- Example 19388
USE DATABASE privacy_policy_db;
SHOW PRIVACY POLICIES;

-- Example 19389
+---------------------------------+----------------+-------------------------------------+-------------------------------------+----------------+--------------+---------+-----------------+---------+
| created_on                      | name           | database_name                       | schema_name                         | kind           | owner        | comment | owner_role_type | options |
|---------------------------------+----------------+-------------------------------------+-------------------------------------+----------------+--------------+---------+-----------------+---------|
| Fri, 23 Jun 2021 07:00:00 +0000 | MY_PRIV_POLICY | PRIVACY_POLICY_DB                   | PRIVACY_POLICY_SH                   | PRIVACY_POLICY | ACCOUNTADMIN |         | ROLE            |         |
+---------------------------------+----------------+-------------------------------------+-------------------------------------+----------------+--------------+---------+-----------------+---------+

-- Example 19390
SHOW REPLICATION DATABASES [ LIKE '<pattern>' ]
                           [ WITH PRIMARY <account_identifier>.<primary_db_name> ]

-- Example 19391
SHOW REPLICATION DATABASES LIKE 'mydb%';

-- Example 19392
SHOW REPLICATION DATABASES WITH PRIMARY myorg.account1.mydb1;

-- Example 19393
SHOW REPLICATION GROUPS [ IN ACCOUNT <account> ]

-- Example 19394
SHOW REPLICATION GROUPS IN ACCOUNT myaccount1;

+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| snowflake_region | created_on                    | account_name | name | type     | comment | is_primary | primary               | object_types                                | allowed_integration_types | allowed_accounts                             | organization_name | account_locator   | replication_schedule | secondary_state | next_scheduled_refresh        | owner   | is_listing_auto_fulfillment_group |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| AWS_US_EAST_1    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT1   | MYFG | FAILOVER |         | true       | MYORG.MYACCOUNT1.MYFG | DATABASES, ROLES, USERS, WAREHOUSES, SHARES |                           | MYORG.MYACCOUNT1.MYFG,MYORG.MYACCOUNT2.MYFG  | MYORG             | MYACCOUNT1LOCATOR | 10 MINUTE            |                 |                               | MYROLE  | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+
| AWS_US_WEST_2    | 2021-10-25 19:08:15.209 -0700 | MYACCOUNT2   | MYFG | FAILOVER |         | false      | MYORG.MYACCOUNT1.MYFG |                                             |                           |                                              | MYORG             | MYACCOUNT2LOCATOR | 10 MINUTE            | STARTED         | 2022-03-06 12:10:35.280 -0800 | NULL    | false                             |
+------------------+-------------------------------+--------------+------+----------+---------+------------+-----------------------+---------------------------------------------+---------------------------+----------------------------------------------+-------------------+-------------------+----------------------+-----------------+-------------------------------+---------+-----------------------------------+

-- Example 19395
SHOW RESOURCE MONITORS [ LIKE '<pattern>' ]

-- Example 19396
SHOW ROLES IN SERVICE <name>

-- Example 19397
SHOW ROLES IN SERVICE echo_service;

-- Example 19398
+-------------------------------+-------------------------+------------+
| created_on                    |   name                      |  comment   |
+-------------------------------+-------------------------+------------+
| 2024-04-29 14:58:50.063 -0700 |   ALL_ENDPOINTS_USAGE   |            |
+-------------------------------+-------------------------+------------+

-- Example 19399
SHOW ROW ACCESS POLICIES [ LIKE '<pattern>' ]
                         [ LIMIT <rows> [ FROM '<name_string>' ] ]
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

-- Example 19400
SHOW ROW ACCESS POLICIES;

-- Example 19401
---------------------------------+------+---------------+-------------+-------------------+--------------+---------+---------+-----------------+
          created_on             | name | database_name | schema_name |       kind        |    owner     | comment | options | owner_role_type |
---------------------------------+------+---------------+-------------+-------------------+--------------+---------+---------+-----------------+
Fri, 23 Jun 1967 00:00:00 -0700  | P1   | RLS_AUTHZ_DB  | S_D_1       | ROW_ACCESS_POLICY | ACCOUNTADMIN |         | ""      | ROLE            |
Fri, 23 Jun 1967 00:00:00 -0700  | P2   | RLS_AUTHZ_DB  | S_D_2       | ROW_ACCESS_POLICY | ACCOUNTADMIN |         | ""      | ROLE            |
---------------------------------+------+---------------+-------------+-------------------+--------------+---------+---------+-----------------+

-- Example 19402


-- Example 19403
SHOW ROW ACCESS POLICIES;

---------------------------------+------+---------------+-------------+-------------------+--------------+---------+---------+-----------------+
          created_on             | name | database_name | schema_name |       kind        |    owner     | comment | options | owner_role_type |
---------------------------------+------+---------------+-------------+-------------------+--------------+---------+---------+-----------------+

-- Example 19404
SHOW SECRETS [ LIKE '<pattern>' ]
             [ IN { ACCOUNT | [ DATABASE ] <db_name> | [ SCHEMA ] <schema_name> | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]

-- Example 19405
SHOW [ TERSE ] SEMANTIC VIEWS [ LIKE '<pattern>' ]
  [ IN
    {
      ACCOUNT                                         |

      DATABASE                                        |
      DATABASE <database_name>                        |

      SCHEMA                                          |
      SCHEMA <schema_name>                            |
      <schema_name>
    }
  ]

  [ STARTS WITH '<name_string>' ]
  [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19406
SHOW SEMANTIC VIEWS;

-- Example 19407
+-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------+
| created_on                    | name                 | database_name | schema_name | comment | owner   | owner_role_type | extension |
|-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------+
| 2025-04-10 08:29:02.732 -0700 | MY_SEMANTIC_VIEW_1   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:21.117 -0700 | MY_SEMANTIC_VIEW_2   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:38.040 -0700 | MY_SEMANTIC_VIEW_3   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:33.161 -0700 | MY_SEMANTIC_VIEW_4   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:46.294 -0700 | MY_SEMANTIC_VIEW_5   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:58.480 -0700 | MY_SEMANTIC_VIEW_6   | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-02-28 16:16:04.002 -0800 | O_TPCH_SEMANTIC_VIEW | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-03-21 07:03:54.120 -0700 | TPCH_REV_ANALYSIS    | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
+-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------+

