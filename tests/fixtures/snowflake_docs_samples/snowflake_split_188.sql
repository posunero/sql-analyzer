-- Example 12576
ALTER TABLE t1
  ADD ROW ACCESS POLICY rap_t1 ON (empl_id);

-- Example 12577
ALTER TABLE t1
  ADD ROW ACCESS POLICY rap_test2 ON (cost, item);

-- Example 12578
ALTER TABLE t1
  DROP ROW ACCESS POLICY rap_v1;

-- Example 12579
alter table t1
  drop row access policy rap_t1_version_1,
  add row access policy rap_t1_version_2 on (empl_id);

-- Example 12580
CREATE REPLICATION GROUP [ IF NOT EXISTS ] <name>
    OBJECT_TYPES = <object_type> [ , <object_type> , ... ]
    [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
    [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]
    [ ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> , ... ] ]
    ALLOWED_ACCOUNTS = <org_name>.<target_account_name> [ , <org_name>.<target_account_name> , ... ]
    [ IGNORE EDITION CHECK ]
    [ REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ ERROR_INTEGRATION = <integration_name> ]

-- Example 12581
CREATE REPLICATION GROUP [ IF NOT EXISTS ] <secondary_name>
    AS REPLICA OF <org_name>.<source_account_name>.<name>

-- Example 12582
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 12583
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12584
CREATE REPLICATION GROUP myrg
    AS REPLICA OF myorg.myaccount1.myrg;

-- Example 12585
CREATE REPLICATION GROUP myrg
    OBJECT_TYPES = DATABASES, SHARES
    ALLOWED_DATABASES = db1
    ALLOWED_SHARES = s1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12586
CREATE REPLICATION GROUP myrg
    AS REPLICA OF myorg.myaccount1.myrg;

-- Example 12587
CREATE FAILOVER GROUP [ IF NOT EXISTS ] <name>
    OBJECT_TYPES = <object_type> [ , <object_type> , ... ]
    [ ALLOWED_DATABASES = <db_name> [ , <db_name> , ... ] ]
    [ ALLOWED_SHARES = <share_name> [ , <share_name> , ... ] ]
    [ ALLOWED_INTEGRATION_TYPES = <integration_type_name> [ , <integration_type_name> , ... ] ]
    ALLOWED_ACCOUNTS = <org_name>.<target_account_name> [ , <org_name>.<target_account_name> ,  ... ]
    [ IGNORE EDITION CHECK ]
    [ REPLICATION_SCHEDULE = '{ <num> MINUTE | USING CRON <expr> <time_zone> }' ]
    [ [ WITH ] TAG ( <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' , ... ] ) ]
    [ ERROR_INTEGRATION = <integration_name> ]

-- Example 12588
CREATE FAILOVER GROUP [ IF NOT EXISTS ] <secondary_name>
    AS REPLICA OF <org_name>.<source_account_name>.<name>

-- Example 12589
# __________ minute (0-59)
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L)
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L)
# | | | | |
# | | | | |
  * * * * *

-- Example 12590
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12591
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 12592
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = DATABASES
    ALLOWED_DATABASES = db1, db2, db3
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12593
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 12594
CREATE FAILOVER GROUP myfg
    OBJECT_TYPES = USERS, ROLES, WAREHOUSES, RESOURCE MONITORS, INTEGRATIONS
    ALLOWED_INTEGRATION_TYPES = STORAGE INTEGRATIONS, NOTIFICATION INTEGRATIONS
    ALLOWED_ACCOUNTS = myorg.myaccount2
    REPLICATION_SCHEDULE = '10 MINUTE';

-- Example 12595
CREATE FAILOVER GROUP myfg
    AS REPLICA OF myorg.myaccount1.myfg;

-- Example 12596
CREATE DATABASE database1;
CREATE SCHEMA database1.sch;
CREATE TABLE database1.sch.table1 (id INT);
CREATE VIEW database1.sch.view1 AS SELECT * FROM database1.sch.table1;

-- Example 12597
CREATE DATABASE database2;
CREATE SCHEMA database2.sch;
CREATE TABLE database2.sch.table2 (id INT);

-- Example 12598
CREATE DATABASE database3;
CREATE SCHEMA database3.sch;
CREATE TABLE database3.sch.table3 (id INT);

-- Example 12599
CREATE SECURE VIEW database3.sch.view3 AS
  SELECT view1.id AS View1Id,
         table2.id AS table2id,
         table3.id AS table3id
  FROM database1.sch.view1 view1,
       database2.sch.table2 table2,
       database3.sch.table3 table3;

-- Example 12600
CREATE SHARE share1;
GRANT USAGE ON DATABASE database3 TO SHARE share1;
GRANT USAGE ON SCHEMA database3.sch TO SHARE share1;

-- Example 12601
GRANT REFERENCE_USAGE ON DATABASE database1 TO SHARE share1;
GRANT REFERENCE_USAGE ON DATABASE database2 TO SHARE share1;

GRANT SELECT ON VIEW database3.sch.view3 TO SHARE share1;

-- Example 12602
CREATE DATABASE customer1_db;
CREATE SCHEMA customer1_db.sch;
CREATE TABLE customer1_db.sch.table1 (id INT);
CREATE VIEW customer1_db.sch.view1 AS SELECT * FROM customer1_db.sch.table1;

-- Example 12603
CREATE DATABASE customer2_db;
CREATE SCHEMA customer2_db.sch;
CREATE TABLE customer2_db.sch.table2 (id INT);

-- Example 12604
CREATE DATABASE new_db;
CREATE SCHEMA new_db.sch;

-- Example 12605
CREATE SECURE VIEW new_db.sch.view3 AS
  SELECT view1.id AS view1Id,
         table2.id AS table2ID
  FROM customer1_db.sch.view1 view1,
       customer2_db.sch.table2 table2;

-- Example 12606
CREATE SHARE share1;

GRANT USAGE ON DATABASE new_db TO SHARE share1;
GRANT USAGE ON SCHEMA new_db.sch TO SHARE share1;

-- Example 12607
GRANT REFERENCE_USAGE ON DATABASE customer1_db TO SHARE share1;
GRANT REFERENCE_USAGE ON DATABASE customer2_db TO SHARE share1;

GRANT SELECT ON VIEW new_db.sch.view3 TO SHARE share1;

-- Example 12608
SHOW TAGS [ LIKE '<pattern>' ]
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

-- Example 12609
SHOW TAGS IN SCHEMA my_db.my_schema;

-- Example 12610
------------------------------+----------------+---------------+-------------+--------------+--------------------+----------------+-----------------+
                   created_on | name           | database_name | schema_name | owner        | comment            | allowed_values | owner_role_type |
------------------------------+----------------+---------------+-------------+--------------+--------------------+----------------+-----------------+
2021-03-20 21:09:38.317 +0000 | CLASSIFICATION | MY_DB         | MY_SCHEMA   | ACCOUNTADMIN | secure information | [NULL]         | ROLE            |
2021-03-20 21:08:59.000 +0000 | COST_CENTER    | MY_DB         | MY_SCHEMA   | ACCOUNTADMIN | cost_center tag    | [NULL]         | ROLE            |
------------------------------+----------------+---------------+-------------+--------------+--------------------+----------------+-----------------+

-- Example 12611
select * from snowflake.account_usage.tags
order by tag_name;

-- Example 12612
'tag_map': {
  'column_tag_map': [
    {
      'tag_name':'tag_db.sch.pii',
      'tag_value':'Highly Confidential',
      'semantic_categories':[
        'NAME',
        'NATIONAL_IDENTIFIER'
      ]
    },
    {
      'tag_name': 'tag_db.sch.pii',
      'tag_value':'Confidential',
      'semantic_categories': [
        'EMAIL'
      ]
    }
  ]
}

-- Example 12613
CALL SYSTEM$GET_CLASSIFICATION_RESULT('mydb.sch.t1');

-- Example 12614
SELECT * FROM snowflake.account_usage.data_classification_latest;

-- Example 12615
SELECT
  service_type,
  start_time,
  end_time,
  entity_id,
  name,
  credits_used_compute,
  credits_used_cloud_services,
  credits_used,
  budget_id
  FROM snowflake.account_usage.metering_history
  WHERE service_type = 'SENSITIVE_DATA_CLASSIFICATION';

-- Example 12616
SELECT
  service_type,
  usage_date,
  credits_used_compute,
  credits_used_cloud_services,
  credits_used
  FROM snowflake.account_usage.metering_daily_history
  WHERE service_type = 'SENSITIVE_DATA_CLASSIFICATION';

-- Example 12617
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON DATABASE mydb TO ROLE data_engineer;
GRANT EXECUTE AUTO CLASSIFICATION ON SCHEMA mydb.sch TO ROLE data_engineer;

GRANT DATABASE ROLE SNOWFLAKE.CLASSIFICATION_ADMIN TO ROLE data_engineer;
GRANT CREATE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE ON SCHEMA mydb.sch TO ROLE data_engineer;

GRANT APPLY TAG ON ACCOUNT TO ROLE data_engineer;

-- Example 12618
USE ROLE data_engineer;

-- Example 12619
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days': 0,
      'maximum_classification_validity_days': 30,
      'auto_tag': true
    });

-- Example 12620
SELECT my_classification_profile!DESCRIBE();

-- Example 12621
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 12622
CALL SYSTEM$GET_CLASSIFICATION_RESULT('mydb.sch.t1');

-- Example 12623
ALTER SCHEMA mydb.sch UNSET CLASSIFICATION_PROFILE;

-- Example 12624
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE
  my_classification_profile(
    {
      'minimum_object_age_for_classification_days': 0,
      'maximum_classification_validity_days': 30,
      'auto_tag': true
    });

-- Example 12625
CALL my_classification_profile!SET_TAG_MAP(
  {'column_tag_map':[
    {
      'tag_name':'my_db.sch1.pii',
      'tag_value':'sensitive',
      'semantic_categories':['NAME']
    }]});

-- Example 12626
CALL my_classification_profile!set_custom_classifiers(
  {
    'medical_codes': medical_codes!list(),
    'finance_codes': finance_codes!list()
  });

-- Example 12627
SELECT my_classification_profile!DESCRIBE();

-- Example 12628
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 12629
ALTER TAG tag_db.sch.pii SET MASKING POLICY pii_mask;

-- Example 12630
CREATE OR REPLACE SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE my_classification_profile(
  {
    'minimum_object_age_for_classification_days':0,
    'auto_tag':true,
    'tag_map': {
      'column_tag_map':[
        {
          'tag_name':'tag_db.sch.pii',
          'tag_value':'highly sensitive',
          'semantic_categories':['NAME','NATIONAL_IDENTIFIER']
        },
        {
          'tag_name':'tag_db.sch.pii',
          'tag_value':'sensitive',
          'semantic_categories':['EMAIL','MEDICAL_CODE']
        }
      ]
    },
    'custom_classifiers': {
      'medical_codes': medical_codes!list(),
      'finance_codes': finance_codes!list()
    }
  }
);

-- Example 12631
CALL SYSTEM$CLASSIFY(
 'db.sch.table1',
 'db.sch.my_classification_profile'
);

-- Example 12632
{
  "classification_profile_config": {
    "classification_profile_name": "db.schema.my_classification_profile"
  },
  "classification_result": {
    "EMAIL": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "EMAIL",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "EMAIL"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "tag_db.sch.pii",
            "tag_value": "sensitive"
          }
        ]
      },
      "valid_value_ratio": 1
    },
    "FIRST_NAME": {
      "alternates": [],
      "recommendation": {
        "confidence": "HIGH",
        "coverage": 1,
        "details": [],
        "privacy_category": "IDENTIFIER",
        "semantic_category": "NAME",
        "tags": [
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.semantic_category",
            "tag_value": "NAME"
          },
          {
            "tag_applied": true,
            "tag_name": "snowflake.core.privacy_category",
            "tag_value": "IDENTIFIER"
          },
          {
            "tag_applied": true,
            "tag_name": "tag_db.sch.pii",
            "tag_value": "highly sensitive"
          }
        ]
      },
      "valid_value_ratio": 1
    }
  }
}

-- Example 12633
ALTER SCHEMA mydb.sch
 SET CLASSIFICATION_PROFILE = 'mydb.sch.my_classification_profile';

-- Example 12634
SELECT
  record_type,
  record:severity_text::string log_level,
  parse_json(value) error_message
  FROM log_db.log_schema.log_table
  WHERE record_type='LOG' and scope:name ='snow.automatic_sensitive_data_classification'
  ORDER BY log_level;

-- Example 12635
"failure_reason":"NO_TAGGING_PRIVILEGE"

-- Example 12636
"failure_reason":"MANUALLY_APPLIED_VALUE_PRESENT"

-- Example 12637
"failure_reason":"TAG_NOT_ACCESSIBLE_OR_AUTHORIZED"

-- Example 12638
CALL SYSTEM$CLASSIFY('hr.tables.empl_info', {'auto_tag': true});

-- Example 12639
SELECT *
FROM TABLE(
  hr.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'hr.tables.empl_info',
    'table'
));

-- Example 12640
CALL SYSTEM$CLASSIFY_SCHEMA('hr.tables', {'auto_tag': true});

-- Example 12641
SELECT SYSTEM$GET_CLASSIFICATION_RESULT('hr.tables.empl_info');

-- Example 12642
SELECT *
FROM TABLE(
  hr.INFORMATION_SCHEMA.TAG_REFERENCES_ALL_COLUMNS(
    'hr.tables.empl_info',
    'table'
));

