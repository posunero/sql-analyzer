-- Example 19408
SHOW TERSE SEMANTIC VIEWS;

-- Example 19409
+-------------------------------+-----------------------+---------------+---------------+-------------------+
| created_on                    | name                  | kind          | database_name | schema_name       |
|-------------------------------+-----------------------+---------------+---------------+-------------------|
| 2025-04-10 08:29:02.732 -0700 | MY_SEMANTIC_VIEW_1    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-04-10 08:29:21.117 -0700 | MY_SEMANTIC_VIEW_2    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-04-10 08:29:38.040 -0700 | MY_SEMANTIC_VIEW_3    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-04-10 08:47:33.161 -0700 | MY_SEMANTIC_VIEW_4    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-04-10 08:47:46.294 -0700 | MY_SEMANTIC_VIEW_5    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-04-10 08:47:58.480 -0700 | MY_SEMANTIC_VIEW_6    | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-02-28 16:16:04.002 -0800 | O_TPCH_SEMANTIC_VIEW  | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
| 2025-03-21 07:03:54.120 -0700 | TPCH_REV_ANALYSIS     | SEMANTIC_VIEW | MY_DB         | MY_SCHEMA         |
+-------------------------------+-----------------------+---------------+---------------+-------------------+

-- Example 19410
SHOW SEMANTIC VIEWS LIKE '%tpch%';

-- Example 19411
+-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------+
| created_on                    | name                 | database_name | schema_name | comment | owner   | owner_role_type | extension |
|-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------|
| 2025-02-28 16:16:04.002 -0800 | O_TPCH_SEMANTIC_VIEW | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-03-21 07:03:54.120 -0700 | TPCH_REV_ANALYSIS    | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
+-------------------------------+----------------------+---------------+-------------+---------+---------+-----------------+-----------+

-- Example 19412
SHOW SEMANTIC VIEWS STARTS WITH 'MY_SEMANTIC_VIEW';

-- Example 19413
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+
| created_on                    | name               | database_name | schema_name | comment | owner   | owner_role_type | extension |
|-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------|
| 2025-04-10 08:29:02.732 -0700 | MY_SEMANTIC_VIEW_1 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:21.117 -0700 | MY_SEMANTIC_VIEW_2 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:38.040 -0700 | MY_SEMANTIC_VIEW_3 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:33.161 -0700 | MY_SEMANTIC_VIEW_4 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:46.294 -0700 | MY_SEMANTIC_VIEW_5 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:58.480 -0700 | MY_SEMANTIC_VIEW_6 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+

-- Example 19414
SHOW SEMANTIC VIEWS STARTS WITH 'MY_SEMANTIC_VIEW' LIMIT 3;

-- Example 19415
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+
| created_on                    | name               | database_name | schema_name | comment | owner   | owner_role_type | extension |
|-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------|
| 2025-04-10 08:29:02.732 -0700 | MY_SEMANTIC_VIEW_1 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:21.117 -0700 | MY_SEMANTIC_VIEW_2 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:29:38.040 -0700 | MY_SEMANTIC_VIEW_3 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+

-- Example 19416
SHOW SEMANTIC VIEWS STARTS WITH 'MY_SEMANTIC_VIEW' LIMIT 3 FROM 'MY_SEMANTIC_VIEW_3';

-- Example 19417
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+
| created_on                    | name               | database_name | schema_name | comment | owner   | owner_role_type | extension |
|-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------|
| 2025-04-10 08:47:33.161 -0700 | MY_SEMANTIC_VIEW_4 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:46.294 -0700 | MY_SEMANTIC_VIEW_5 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
| 2025-04-10 08:47:58.480 -0700 | MY_SEMANTIC_VIEW_6 | MY_DB         | MY_SCHEMA   |         | MY_ROLE | ROLE            | NULL      |
+-------------------------------+--------------------+---------------+-------------+---------+---------+-----------------+-----------+

-- Example 19418
SHOW SEQUENCES [ LIKE '<pattern>' ]
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

-- Example 19419
SHOW SERVICE INSTANCES IN SERVICE <name>

-- Example 19420
SHOW SERVICE INSTANCES IN SERVICE echo_service;

-- Example 19421
+---------------+-------------+--------------+-------------+--------+------------------------------------------------------------------+----------------------+----------------------+------------+
| database_name | schema_name | service_name | instance_id | status | spec_digest                                                      | creation_time        | start_time           | ip_address |
|---------------+-------------+--------------+-------------+--------+------------------------------------------------------------------+----------------------+----------------------+------------|
| TUTORIAL_DB   | DATA_SCHEMA | ECHO_SERVICE | 0           | READY  | edaf548eb0c2744a87426529b53aac75756d0ea1c0ba5edb3cbb4295a381f2b4 | 2025-02-21T07:17:02Z | 2025-02-21T07:17:02Z | 10.244.3.8 |
+---------------+-------------+--------------+-------------+--------+------------------------------------------------------------------+----------------------+----------------------+------------+

-- Example 19422
SHOW [ JOB ] SERVICES [ EXCLUDE JOBS ] [ LIKE '<pattern>' ]
           [ IN
                {
                  ACCOUNT                  |

                  DATABASE                 |
                  DATABASE <database_name> |

                  SCHEMA                   |
                  SCHEMA <schema_name>     |
                  <schema_name>            |

                  COMPUTE POOL <compute_pool_name>
                }
           ]
           [ STARTS WITH '<name_string>' ]
           [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19423
SELECT SYSTEM$GET_SERVICE_DNS_DOMAIN('mydb.myschema');

-- Example 19424
SHOW SERVICES;

-- Example 19425
+--------------+---------+---------------+-------------+-----------+-----------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------+
| name         | status  | database_name | schema_name | owner     | compute_pool          | dns_name                            | current_instances | target_instances | min_ready_instances | min_instances | max_instances | auto_resume | external_access_integrations | created_on                    | updated_on                    | resumed_on | suspended_on | auto_suspend_secs | comment | owner_role_type | query_warehouse | is_job | is_async_job | spec_digest                                                      | is_upgrading | managing_object_domain | managing_object_name |
|--------------+---------+---------------+-------------+-----------+-----------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------|
| ECHO_SERVICE | RUNNING | TUTORIAL_DB   | DATA_SCHEMA | TEST_ROLE | TUTORIAL_COMPUTE_POOL | echo-service.k3m6.svc.spcs.internal |                 1 |                1 |                   1 |             1 |             1 | true        | NULL                         | 2024-11-29 12:12:47.310 -0800 | 2024-11-29 12:12:48.843 -0800 | NULL       | NULL         |                 0 | NULL    | ROLE            | NULL            | false  | false        | edaf548eb0c2744a87426529b53aac75756d0ea1c0ba5edb3cbb4295a381f2b4 | false        | NULL                   | NULL                 |
+--------------+---------+---------------+-------------+-----------+-----------------------+-------------------------------------+-------------------+------------------+---------------------+---------------+---------------+-------------+------------------------------+-------------------------------+-------------------------------+------------+--------------+-------------------+---------+-----------------+-----------------+--------+--------------+------------------------------------------------------------------+--------------+------------------------+----------------------+

-- Example 19426
SHOW SERVICES LIMIT 1;

-- Example 19427
SHOW SERVICES LIKE '%echo%';

-- Example 19428
SHOW SERVICES LIKE '%echo%' LIMIT 1;

-- Example 19429
SHOW JOB SERVICES;

-- Example 19430
SHOW SESSION POLICIES
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

-- Example 19431
SHOW SESSION POLICIES;

-- Example 19432
----------------------------------+-----------------------+---------------+-------------+----------------+--------------+--------------------------------------------------+---------+
         created_on               | name                  | database_name | schema_name |      kind      |  owner       |   comment                                        | options |
----------------------------------+-----------------------+---------------+-------------+----------------+--------------+--------------------------------------------------+---------+
  Mon, 11 Jan 2021 00:00:00 -0700 | session_policy_prod_1 | MY_DB         | MY_SCHEMA   | SESSION_POLICY | POLICY_ADMIN | session policy for use in the prod_1 environment | ""      |
----------------------------------+-----------------------+---------------+-------------+----------------+--------------+--------------------------------------------------+---------+

-- Example 19433
SHOW SHARES [ LIKE '<pattern>' ]
            [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19434
SHOW SHARES;

+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+
| created_on                    | kind     | owner_account        | name          | database_name         | to               | owner        | comment                                | listing_global_name |                  |
|-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------|---------------------|
| 2016-07-09 19:18:09.821 -0700 | INBOUND  | SNOW.MY_TEST_ACCOUNT | SAMPLE_DATA   | SNOWFLAKE_SAMPLE_DATA |                  |              | Sample data sets provided by Snowflake |                     |
| 2017-06-15 17:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT | SALES_S       | SALES_DB              | XY12345, YZ23456 | ACCOUNTADMIN |                                        |                     |
+-------------------------------+----------+----------------------+---------------+-----------------------+------------------+--------------+----------------------------------------+---------------------+

-- Example 19435
SHOW SHARES LIMIT 5 FROM 'SNOW';

+-------------------------------+----------+-------------------------+-----------------+----------------+------------------+--------------+---------+---------------------+
| created_on                    | kind     | owner_account           | name            | database_name  | to               | owner        | comment | listing_global_name |
|-------------------------------+----------+-------------------------+-----------------+----------------+------------------+--------------+---------+---------------------|
| 2020-07-07 19:18:09.821 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT    | SNOW_DATA       | EXAMPLE        |                  | ACCOUNTADMIN |         |                     |
| 2020-07-10 19:18:09.821 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT    | DATA_SNOWS      | EXAMPLE        |                  | ACCOUNTADMIN |         |                     |
| 2022-08-18 12:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT    | SNOW_DATA       | ALFALFA_DB     | AB12345, YZ23456 | ACCOUNTADMIN |         |                     |
| 2022-08-18 13:04:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT    | SNOW_SHARE      | SALES_DB       | AB12345          | ACCOUNTADMIN |         |                     |
| 2022-08-18 14:02:40.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT    | SNOWIER_SHARE   | SALES_DB       |                  | ACCOUNTADMIN |         |                     |
+-------------------------------+----------+-------------------------+-----------------+----------------+------------------+--------------+---------+---------------------+

-- Example 19436
SHOW SHARES STARTS WITH 'SNOW' LIMIT 5 FROM 'A';

+-------------------------------+----------+------------------------+------------------------+----------------+------------------+--------------+---------+---------------------+
| created_on                    | kind     | owner_account          |  name                  | database_name  | to               | owner        | comment | listing_global_name |
|-------------------------------+----------+------------------------+------------------------+----------------+------------------+--------------+---------+---------------------|
| 2020-07-07 19:18:09.821 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT   | SNOW_DATA              | EXAMPLE        |                  | ACCOUNTADMIN |         |                     |
| 2022-08-18 12:02:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT   | SNOW_DATA              | ALFALFA_DB     | AB12345, YZ23456 | ACCOUNTADMIN |         |                     |
| 2022-08-18 14:02:40.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT   | SNOWIER_SHARE          | SALES_DB       |                  | ACCOUNTADMIN |         |                     |
| 2022-08-20 15:03:50.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT   | SNOWY_SHARE            | SALES_DB       |                  | ACCOUNTADMIN |         |                     |
| 2022-08-18 13:04:29.625 -0700 | OUTBOUND | SNOW.MY_TEST_ACCOUNT   | SNOW_SHARE             | SALES_DB       | AB12345          | ACCOUNTADMIN |         |                     |
+-------------------------------+----------+------------------------+------------------------+----------------+------------------+--------------+---------+---------------------+

-- Example 19437
SHOW SHARES IN FAILOVER GROUP <name>

-- Example 19438
SHOW SHARES IN FAILOVER GROUP myrg;

-- Example 19439
SHOW SHARES IN REPLICATION GROUP <name>

-- Example 19440
SHOW SHARES IN REPLICATION GROUP myrg;

-- Example 19441
SHOW STAGES [ LIKE '<pattern>' ]
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

-- Example 19442
SHOW [ TERSE ] STREAMLITS [ LIKE '<pattern>' ]
                          [ IN
                                {
                                  ACCOUNT                   |

                                  DATABASE                  |
                                  DATABASE <db_name>        |

                                  SCHEMA
                                  SCHEMA <schema_name>      |
                                  <schema_name>             |
                                }
                          ]
                          [ LIMIT <rows> [ FROM '<name_string>' ]

-- Example 19443
SHOW [ TERSE ] TASKS [ LIKE '<pattern>' ]
                     [ IN { ACCOUNT | DATABASE [ <db_name> ] | [ SCHEMA ] [ <schema_name> ] | APPLICATION <application_name> | APPLICATION PACKAGE <application_package_name> } ]
                     [ STARTS WITH '<name_string>' ]
                     [ ROOT ONLY ]
                     [ LIMIT <rows> [ FROM '<name_string>' ] ]

-- Example 19444
SHOW TASKS LIKE 'line%' IN tpch.public;

-- Example 19445
SHOW TASKS IN tpch.public;

-- Example 19446
configuration:
  ...
  log_level: INFO
  trace_level: ALWAYS
  metric_level: ALL
  ...

-- Example 19447
configuration:
  telemetry_event_definitions:
    - type: ERRORS_AND_WARNINGS
      sharing: MANDATORY
    - type: DEBUG_LOGS
      sharing: OPTIONAL

-- Example 19448
SHOW USER FUNCTIONS [ LIKE '<pattern>' ]
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

-- Example 19449
SHOW USER FUNCTIONS LIKE 'ALLOWED_REGIONS%' IN SCHEMA;

-- Example 19450
---------------------------------+--------------------------+-------------+------------+--------------+---------+-------------------+-------------------+-----------------------------------------+-----------------------+----------------+-------------------+----------------------+-----------+---------+-----------------------------+----------------------+----------+---------------+----------------+
          created_on             |           name           | schema_name | is_builtin | is_aggregate | is_ansi | min_num_arguments | max_num_arguments |                arguments                |      description      |  catalog_name  | is_table_function | valid_for_clustering | is_secure | secrets | external_access_integration | is_external_function | language | is_memoizable | is_data_metric |
---------------------------------+--------------------------+-------------+------------+--------------+---------+-------------------+-------------------+-----------------------------------------+-----------------------+----------------+-------------------+----------------------+-----------+---------+-----------------------------+----------------------+----------+---------------+----------------+
 Fri, 23 Jun 1967 00:00:00 -0700 | ALLOWED_REGIONS          | PUBLIC      | N          | N            | N       | 0                 | 0                 | ALLOWED_REGIONS() RETURN ARRAY          | user-defined function | MEMO_FUNC_TEST | N                 | N                    | N         |         |                             | N                    | SQL      | Y             | N              |
 Fri, 23 Jun 1967 00:00:00 -0700 | ALLOWED_REGIONS_NON_MEMO | PUBLIC      | N          | N            | N       | 0                 | 0                 | ALLOWED_REGIONS_NON_MEMO() RETURN ARRAY | user-defined function | MEMO_FUNC_TEST | N                 | N                    | N         |         |                             | N                    | SQL      | N             | N              |
---------------------------------+--------------------------+-------------+------------+--------------+---------+-------------------+-------------------+-----------------------------------------+-----------------------+----------------+-------------------+----------------------+-----------+---------+-----------------------------+----------------------+----------+---------------+----------------+

-- Example 19451
SHOW USER PROCEDURES [ LIKE '<pattern>' ]
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

-- Example 19452
SHOW USER PROCEDURES LIKE 'GET_%' IN SCHEMA;

-- Example 19453
-------------------------------+-----------------+-------------+------------+--------------+---------+-------------------+-------------------+---------------------------------------+------------------------+--------------+-------------------+----------------------+-----------+---------+------------------------------+
          created_on           | name            | schema_name | is_builtin | is_aggregate | is_ansi | min_num_arguments | max_num_arguments | arguments                             | description            | catalog_name | is_table_function | valid_for_clustering | is_secure | secrets | external_access_integrations |
-------------------------------+-----------------+-------------+------------+--------------+---------+-------------------+-------------------+---------------------------------------+------------------------+--------------+-------------------+----------------------+-----------+---------+------------------------------+
 2023-01-27 15:01:13.862 -0800 | GET_FILE        | PUBLIC      | N          | N            | N       | 1                 | 1                 | GET_FILE(VARCHAR) RETURN VARCHAR      | user-defined procedure | BOOKS_DB     | N                 | N                    | N         |         |                              |
 2023-03-23 10:38:10.423 -0700 | GET_NUM_RESULTS | PUBLIC      | N          | N            | N       | 1                 | 1                 | GET_NUM_RESULTS(VARCHAR) RETURN FLOAT | user-defined procedure | BOOKS_DB     | N                 | N                    | N         |         |                              |
 2023-03-23 09:47:55.840 -0700 | GET_RESULTS     | PUBLIC      | N          | N            | N       | 1                 | 1                 | GET_RESULTS(VARCHAR) RETURN TABLE ()  | user-defined procedure | BOOKS_DB     | Y                 | N                    | N         |         |                              |
-------------------------------+-----------------+-------------+------------+--------------+---------+-------------------+-------------------+---------------------------------------+------------------------+--------------+-------------------+----------------------+-----------+---------+------------------------------+

-- Example 19454
SHOW VARIABLES [ LIKE '<pattern>' ]

-- Example 19455
TRUNCATE MATERIALIZED VIEW <name>

-- Example 19456
UNSET <var>

UNSET ( <var> [ , <var> ... ] )

-- Example 19457
UNSET V1;

UNSET V2;

UNSET (V1, V2);

-- Example 19458
SELECT <model_name>!<method_name>(...) FROM <table_name>;

-- Example 19459
WITH <model_version_alias> AS MODEL <model_name> VERSION <version_or_alias_name>
    SELECT <model_version_alias>!<method_name>(...) FROM <table_name>;

-- Example 19460
WITH latest AS MODEL my_model VERSION LAST
    SELECT latest!predict(...) FROM my_table;

-- Example 19461
CREATE [ OR REPLACE ] SNOWFLAKE.ML.ANOMALY_DETECTION <model_name>(
  INPUT_DATA => <reference_to_training_data>,
  [ SERIES_COLNAME => '<series_column_name>', ]
  TIMESTAMP_COLNAME => '<timestamp_column_name>',
  TARGET_COLNAME => '<target_column_name>',
  LABEL_COLNAME => '<label_column_name>',
  [ CONFIG_OBJECT => <config_object> ]
)
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19462
DROP SNOWFLAKE.ML.ANOMALY_DETECTION [IF EXISTS] <model_name>;

-- Example 19463
{
  SHOW SNOWFLAKE.ML.ANOMALY_DETECTION           |
  SHOW SNOWFLAKE.ML.ANOMALY_DETECTION INSTANCES
}
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

-- Example 19464
<model_name>!DETECT_ANOMALIES(
  INPUT_DATA => <reference_to_data_to_analyze>,
  TIMESTAMP_COLNAME => '<timestamp_column_name>',
  TARGET_COLNAME => '<target_column_name>',
  [ CONFIG_OBJECT => <configuration_object>, ]
  [ SERIES_COLNAME => '<series_column_name>' ]
)

-- Example 19465
<model_name>!EXPLAIN_FEATURE_IMPORTANCE();

-- Example 19466
<model_name>!SHOW_EVALUATION_METRICS();

-- Example 19467
<model_name>!SHOW_EVALUATION_METRICS(
  INPUT_DATA => <input_data>,
  [ SERIES_COLNAME => '<series_colname>', ]
  TIMESTAMP_COLNAME => '<timestamp_colname>',
  TARGET_COLNAME => '<target_colname>',
  LABEL_COLNAME => '<label_column_name>',
  [ CONFIG_OBJECT => <config_object> ]
);

-- Example 19468
<model_name>!SHOW_TRAINING_LOGS();

-- Example 19469
CREATE [ OR REPLACE ] SNOWFLAKE.ML.ANOMALY_DETECTION <model_name>(
  INPUT_DATA => <reference_to_training_data>,
  [ SERIES_COLNAME => '<series_column_name>', ]
  TIMESTAMP_COLNAME => '<timestamp_column_name>',
  TARGET_COLNAME => '<target_column_name>',
  LABEL_COLNAME => '<label_column_name>',
  [ CONFIG_OBJECT => <config_object> ]
)
[ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
[ COMMENT = '<string_literal>' ]

-- Example 19470
<model_name>!DETECT_ANOMALIES(
  INPUT_DATA => <reference_to_data_to_analyze>,
  TIMESTAMP_COLNAME => '<timestamp_column_name>',
  TARGET_COLNAME => '<target_column_name>',
  [ CONFIG_OBJECT => <configuration_object>, ]
  [ SERIES_COLNAME => '<series_column_name>' ]
)

-- Example 19471
CREATE [ OR REPLACE ] SNOWFLAKE.CORE.BUDGET [ IF NOT EXISTS ] <name> ()
  [ [ WITH ] COMMENT = '<string_literal>' ]

-- Example 19472
CREATE SNOWFLAKE.CORE.BUDGET my_budget();

-- Example 19473
DROP SNOWFLAKE.CORE.BUDGET [ IF EXISTS ] <name>

-- Example 19474
DROP SNOWFLAKE.CORE.BUDGET my_budget;

