-- Example 6614
USE ROLE accountadmin;

SELECT SYSTEM$BLOCK_INTERNAL_STAGES_PUBLIC_ACCESS();

-- Example 6615
SYSTEM$CANCEL_ALL_QUERIES( <session_id> )

-- Example 6616
SELECT SYSTEM$CANCEL_ALL_QUERIES(1065153872298);

+------------------------------------------+
| SYSTEM$CANCEL_ALL_QUERIES(1065153872298) |
|------------------------------------------|
| 1 cancelled.                             |
+------------------------------------------+

-- Example 6617
SYSTEM$CANCEL_QUERY( <query_id> )

-- Example 6618
SELECT SYSTEM$CANCEL_QUERY('d5493e36-5e38-48c9-a47c-c476f2111ce5');

+-------------------------------------------------------------+
| SYSTEM$CANCEL_QUERY('D5493E36-5E38-48C9-A47C-C476F2111CE5') |
|-------------------------------------------------------------|
| query [d5493e36-5e38-48c9-a47c-c476f2111ce5] terminated.    |
+-------------------------------------------------------------+

-- Example 6619
SYSTEM$CLEANUP_DATABASE_ROLE_GRANTS( '<database_role_name>' , '<share_name>' )

-- Example 6620
SELECT SYSTEM$CLEANUP_DATABASE_ROLE_GRANTS('mydb.dbr1' , 'myshare');

-- Example 6621
SYSTEM$CLIENT_VERSION_INFO()

-- Example 6622
{
  "clientId": "DOTNETDriver",
  "clientAppId": ".NET",
  "minimumSupportedVersion": "2.0.9",
  "minimumNearingEndOfSupportVersion": "2.0.11",
  "recommendedVersion": "2.1.5",
  "deprecatedVersions": [],
  "_customSupportedVersions_": []
},

-- Example 6623
SELECT SYSTEM$CLIENT_VERSION_INFO();

-- Example 6624
[
  {
    "clientId": "DOTNETDriver",
    "clientAppId": ".NET",
    "minimumSupportedVersion": "2.0.9",
    "minimumNearingEndOfSupportVersion": "2.0.11",
    "recommendedVersion": "2.1.5",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "GO",
    "clientAppId": "Go",
    "minimumSupportedVersion": "1.6.6",
    "minimumNearingEndOfSupportVersion": "1.6.9",
    "recommendedVersion": "1.7.1",
    "deprecatedVersions": [],
    "_customSupportedVersions_": [
      "1.1.5"
    ]
  },
  {
    "clientId": "JDBC",
    "clientAppId": "JDBC",
    "minimumSupportedVersion": "3.13.14",
    "minimumNearingEndOfSupportVersion": "3.13.18",
    "recommendedVersion": "3.14.4",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "JSDriver",
    "clientAppId": "JavaScript",
    "minimumSupportedVersion": "1.6.6",
    "minimumNearingEndOfSupportVersion": "1.6.9",
    "recommendedVersion": "1.9.2",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "ODBC",
    "clientAppId": "ODBC",
    "minimumSupportedVersion": "2.24.5",
    "minimumNearingEndOfSupportVersion": "2.24.7",
    "recommendedVersion": "3.1.4",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "PHP_PDO",
    "clientAppId": "PDO",
    "minimumSupportedVersion": "1.2.0",
    "minimumNearingEndOfSupportVersion": "1.2.1",
    "recommendedVersion": "2.0.1",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "PythonConnector",
    "clientAppId": "PythonConnector",
    "minimumSupportedVersion": "2.7.3",
    "minimumNearingEndOfSupportVersion": "2.7.7",
    "recommendedVersion": "3.6.0",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "SnowSQL",
    "clientAppId": "SnowSQL",
    "minimumSupportedVersion": "1.2.21",
    "minimumNearingEndOfSupportVersion": "1.2.21",
    "recommendedVersion": "1.2.31",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  },
  {
    "clientId": "SQLAPI",
    "clientAppId": "SQLAPI",
    "minimumSupportedVersion": "1.0.0",
    "minimumNearingEndOfSupportVersion": "",
    "recommendedVersion": "",
    "deprecatedVersions": [],
    "_customSupportedVersions_": []
  }
]

-- Example 6625
WITH output AS (
  SELECT
    PARSE_JSON(SYSTEM$CLIENT_VERSION_INFO()) a
)
SELECT
    value:clientAppId::STRING AS client_app_id,
    value:minimumSupportedVersion::STRING AS minimum_version,
    value:minimumNearingEndOfSupportVersion::STRING AS near_end_of_support_version,
    value:recommendedVersion::STRING AS recommended_version
  FROM output r,
    LATERAL FLATTEN(INPUT => r.a, MODE =>'array');

-- Example 6626
+-----------------+-----------------+-----------------------------+---------------------+
| CLIENT_APP_ID   | MINIMUM_VERSION | NEAR_END_OF_SUPPORT_VERSION | RECOMMENDED_VERSION |
|-----------------+-----------------+-----------------------------+---------------------|
| .NET            | 2.0.9           | 2.0.11                      | 2.1.5               |
| Go              | 1.6.6           | 1.6.9                       | 1.7.1               |
| JDBC            | 3.13.14         | 3.13.18                     | 3.14.4              |
| JavaScript      | 1.6.6           | 1.6.9                       | 1.9.2               |
| ODBC            | 2.23.5          | 2.24.7                      | 3.1.4               |
| PDO             | 1.2.0           | 1.2.1                       | 2.0.1               |
| PythonConnector | 2.7.3           | 2.7.7                       | 3.6.0               |
| SnowSQL         | 1.2.21          | 1.2.21                      | 1.2.31              |
| SQLAPI          | 1.0.0           |                             |                     |
+-----------------+-----------------+-----------------------------+---------------------+

-- Example 6627
WITH output AS (
  SELECT
    PARSE_JSON(SYSTEM$CLIENT_VERSION_INFO()) a
)
SELECT
    value:clientId::STRING AS client_id,
    value:minimumSupportedVersion::STRING AS minimum_version,
    value:minimumNearingEndOfSupportVersion::STRING AS near_end_of_support_version,
    value:recommendedVersion::STRING AS recommended_version
  FROM output r,
    LATERAL FLATTEN(INPUT => r.a, MODE =>'array')
  WHERE client_id = 'JDBC';

-- Example 6628
+-----------+-----------------+-----------------------------+---------------------+
| CLIENT_ID | MINIMUM_VERSION | NEAR_END_OF_SUPPORT_VERSION | RECOMMENDED_VERSION |
|-----------+-----------------+-----------------------------+---------------------|
| JDBC      | 3.13.14         | 3.13.18                     | 3.14.4              |
+-----------+-----------------+-----------------------------+---------------------+

-- Example 6629
SYSTEM$CLUSTERING_DEPTH( '<table_name>' , '( <col1> [ , <col2> ... ] )' [ , '<predicate>' ] )

-- Example 6630
SELECT SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS');

+----------------------------------------+
| SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS') |
|----------------------------------------+
| 2.4865                                 |
+----------------------------------------+

-- Example 6631
SELECT SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS', '(C2, C9)');

+----------------------------------------------------+
| SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS', '(C2, C9)') |
+----------------------------------------------------+
| 23.1351                                            |
+----------------------------------------------------+

-- Example 6632
SELECT SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS', '(C2, C9)', 'C2 = 25');

+----------------------------------------------------+
| SYSTEM$CLUSTERING_DEPTH('TPCH_ORDERS', '(C2, C9)') |
+----------------------------------------------------+
| 11.2452                                            |
+----------------------------------------------------+

-- Example 6633
SYSTEM$CLUSTERING_INFORMATION( '<table_name>'
    [ , { '( <expr1> [ , <expr2> ... ] )' | <number_of_errors> } ] )

-- Example 6634
SELECT SYSTEM$CLUSTERING_INFORMATION('t1', 5);

-- Example 6635
SELECT SYSTEM$CLUSTERING_INFORMATION('test2', '(col1, col3)');

-- Example 6636
+--------------------------------------------------------------------+
| SYSTEM$CLUSTERING_INFORMATION('TEST2', '(COL1, COL3)')             |
|--------------------------------------------------------------------|
| {                                                                  |
|   "cluster_by_keys" : "LINEAR(COL1, COL3)",                        |
|   "total_partition_count" : 1156,                                  |
|   "total_constant_partition_count" : 0,                            |
|   "average_overlaps" : 117.5484,                                   |
|   "average_depth" : 64.0701,                                       |
|   "partition_depth_histogram" : {                                  |
|     "00000" : 0,                                                   |
|     "00001" : 0,                                                   |
|     "00002" : 3,                                                   |
|     "00003" : 3,                                                   |
|     "00004" : 4,                                                   |
|     "00005" : 6,                                                   |
|     "00006" : 3,                                                   |
|     "00007" : 5,                                                   |
|     "00008" : 10,                                                  |
|     "00009" : 5,                                                   |
|     "00010" : 7,                                                   |
|     "00011" : 6,                                                   |
|     "00012" : 8,                                                   |
|     "00013" : 8,                                                   |
|     "00014" : 9,                                                   |
|     "00015" : 8,                                                   |
|     "00016" : 6,                                                   |
|     "00032" : 98,                                                  |
|     "00064" : 269,                                                 |
|     "00128" : 698                                                  |
|   },                                                               |
|   "clustering_errors" : [ {                                        |
|      "timestamp" : "2023-04-03 17:50:42 +0000",                    |
|      "error" : "(003325) Clustering service has been disabled.\n"  |
|      }                                                             |
|   ]                                                                |
| }                                                                  |
+--------------------------------------------------------------------+

-- Example 6637
SYSTEM$CLUSTERING_RATIO( '<table_name>' , '( <col1> [ , <col2> ... ] )' [ , '<predicate>' ] )

-- Example 6638
SELECT SYSTEM$CLUSTERING_RATIO('t2', '(col1, col3)');

+-------------------------------+
| SYSTEM$CLUSTERING_RATIO('T2') |
|-------------------------------|
|                          77.1 |
+-------------------------------+

-- Example 6639
SELECT SYSTEM$CLUSTERING_RATIO('t2', '(col1, col2)', 'col1 = ''A''');

+-------------------------------+
| SYSTEM$CLUSTERING_RATIO('T2') |
|-------------------------------|
|                          87.7 |
+-------------------------------+

-- Example 6640
SELECT SYSTEM$CLUSTERING_RATIO('t1');

+-------------------------------+
| SYSTEM$CLUSTERING_RATIO('T1') |
|-------------------------------|
|                         100.0 |
+-------------------------------+

-- Example 6641
SYSTEM$COMMIT_MOVE_ORGANIZATION_ACCOUNT( <grace_period> )

-- Example 6642
SELECT SYSTEM$COMMIT_MOVE_ORGANIZATION_ACCOUNT(14);

-- Example 6643
USE ROLE GLOBALORGADMIN;

GRANT MANAGE ACCOUNTS ON ACCOUNT TO custom_role;

-- Example 6644
USE ROLE ORGADMIN;

-- Example 6645
CREATE ORGANIZATION ACCOUNT myorgaccount
    ADMIN_NAME = admin
    ADMIN_PASSWORD = 'TestPassword1'
    EMAIL = 'myemail@myorg.org'
    MUST_CHANGE_PASSWORD = true
    EDITION = enterprise;

-- Example 6646
CALL SYSTEM$INITIATE_MOVE_ORGANIZATION_ACCOUNT(
  'MY_TEMP_NAME',
  'aws_us_west_2',
  'ALL');

-- Example 6647
CALL SYSTEM$COMMIT_MOVE_ORGANIZATION_ACCOUNT(14);

-- Example 6648
SYSTEM$CONVERT_PIPES_SQS_TO_SNS( '<bucket_name>, '<sns_topic_arn>' )

-- Example 6649
SELECT SYSTEM$CONVERT_PIPES_SQS_TO_SNS(
   'my_s3_bucket', 'arn:aws:sns:us-east-2:111122223333:sns_topic');

-- Example 6650
SYSTEM$CREATE_BILLING_EVENT(
 '<class>',
 '<subclass>',
 <start_timestamp>,
 <timestamp>,
 <base_charge>,
 '<objects>',
 '<additional_info>'
 )

-- Example 6651
CREATE OR REPLACE PROCEDURE <schema_name>.custom_event_billing()
 RETURNS NULL
 LANGUAGE JAVASCRIPT
 AS
 $$
   /**
    * Helper method to add a billable event
    * Format timestamps as Unix timestamps in milliseconds
    */

   function createBillingEvent(className, subclassName, startTimestampVal, timestampVal, baseCharge, objects, additionalInfo) {
        try {
            var res = snowflake.createStatement({
            sqlText: `SELECT SYSTEM$CREATE_BILLING_EVENT('${className}',
                                                      '${subclassName}',
                                                      ${startTimestampVal},
                                                      ${timestampVal},
                                                      ${baseCharge},
                                                      '${objects}',
                                                      '${additionalInfo}')`
            }).execute();

            res.next();

            return res.getColumnValue(1);
        } catch(err) {
            return err.message;
        }
    }
$$;

-- Example 6652
CREATE OR REPLACE PROCEDURE <app_provider_db_1><app_provider_schema_1>.external_proc_batch()
 RETURNS STRING
 LANGUAGE JAVASCRIPT
 EXECUTE AS OWNER
 AS
 $$
   function createBillingEventsBulk(events) {
     try {
       var res = snowflake.execute({
                    sqlText: `call SYSTEM$CREATE_BILLING_EVENTS('${events}')`
                 });
       res.next();
       return res.getColumnValueAsString(1);
     } catch (err) {
       return err.message;
     }
   }

   return createBillingEventsBulk(`
                                   [
                                     {
                                       "class": "class_1",
                                       "subclass": "subclass_1",
                                       "start_timestamp": ${Date.now()},
                                       "timestamp": ${Date.now()},
                                       "base_charge": 6.1,
                                       "objects": "obj1",
                                       "additional_info": "info1"
                                     },
                                     {
                                       "class": "class_2",
                                       "subclass": "subclass_2",
                                       "start_timestamp": ${Date.now()},
                                       "timestamp": ${Date.now()},
                                       "base_charge": 9.1,
                                       "objects": "obj2",
                                       "additional_info": "info2"
                                     }
                                   ]
                                 `);
$$;

-- Example 6653
...
  //
  // Send a billable event when a stored procedure is called.
  //
  var event_ts = Date.now();
  var billing_quantity = 1.0;
  var base_charge = billing_quantity;
  var objects = "[ \"db_1.public.procedure_1\" ]";
  var retVal = createBillingEvent("PROCEDURE_CALL", "", event_ts, event_ts, base_charge, objects, "");
  // Run the rest of the procedure ...
$$;

-- Example 6654
...
  // Run a query and get the number of rows in the result
  var select_query = "select i from db_1.public.t1";
  res = snowflake.execute ({sqlText: select_query});
  res.next();
  //
  // Send a billable event for rows returned from the select query
  //
  var event_ts = Date.now();
  var billing_quantity = 2.5;
  var base_charge = res.getRowcount() * billing_quantity;
  var objects = "[ \"db_1.public.t1\" ]";
  createBillingEvent("ROWS_CONSUMED", "", event_ts, event_ts, base_charge, objects, "");
  // Run the rest of the procedure ...
$$;

-- Example 6655
...
    // Run the merge query
    var merge_query = "MERGE INTO target_table USING source_table ON target_table.i = source_table.i
        WHEN MATCHED THEN UPDATE SET target_table.j = source_table.j
        WHEN NOT MATCHED
        THEN INSERT (i, j)
        VALUES (source_table.i, source_table.j)";
    res = snowflake.execute ({sqlText: merge_query});
    res.next();
    // rows ingested = rows inserted + rows updated
    var numRowsIngested = res.getColumnValue(1) + res.getColumnValue(2);

    //
    // Send a billable event for rows changed by the merge query
    //
    var event_ts = Date.now();
    var billing_quantity = 2.5;
    var base_charge = numRowsIngested * billing_quantity;
    var objects = "[ \"db_1.public.target_table\" ]";
    createBillingEvent("ROWS_CHANGED", "", event_ts, event_ts, base_charge, objects, "");
    // Run the rest of the procedure ...
$$;

-- Example 6656
...
    //
    // Get monthly active rows
    //
    var monthly_active_rows_query = "
     SELECT
         count(*)
     FROM
         source_table
     WHERE
         source_table.i not in
         (
           SELECT
             i
           FROM
             target_table
           WHERE
             updated_on >= DATE_TRUNC('MONTH', CURRENT_TIMESTAMP)
         )";
    res = snowflake.execute ({sqlText: monthly_active_rows_query});
    res.next();
    var monthlyActiveRows = parseInt(res.getColumnValue(1));
    //
    // Run the merge query and update the updated_on values for the rows
    //
    var merge_query = "
        MERGE INTO
            target_table
        USING
            source_table
        ON
            target_table.i = source_table.i
        WHEN MATCHED THEN
         UPDATE SET target_table.j = source_table.j
                    ,target_table.updated_on = current_timestamp
        WHEN NOT MATCHED THEN
            INSERT (i, j, updated_on) VALUES (source_table.i, source_table.j, current_timestamp)";
    res = snowflake.execute ({sqlText: merge_query});
    res.next();
    //
    // Emit a billable event for monthly active rows changed by the merge query
    //
    var event_ts = Date.now();
    var billing_quantity = 0.02
    var base_charge = monthlyActiveRows * billing_quantity;
    var objects = "[ \"db_1.public.target_table\" ]";
    createBillingEvent("MONTHLY_ACTIVE_ROWS", "", event_ts, event_ts, base_charge, objects, "");
    // Run the rest of the procedure ...
$$;

-- Example 6657
CREATE OR REPLACE PROCEDURE app_schema.billing_event_rows()
   RETURNS STRING
   LANGUAGE PYTHON
   RUNTIME_VERSION = '3.9'
   PACKAGES = ('snowflake-snowpark-python')
   HANDLER = 'run'
   EXECUTE AS OWNER
   AS $$
import time

# Helper method that calls the system function for billing
def createBillingEvent(session, class_name, subclass_name, start_timestamp, timestamp, base_charge, objects, additional_info):
   session.sql(f"SELECT SYSTEM$CREATE_BILLING_EVENT('{class_name}', '{subclass_name}', {start_timestamp}, {timestamp}, {base_charge}, '{objects}', '{additional_info}')").collect()
   return "Success"

# Handler function for the stored procedure
def run(session):
   # insert code to identify monthly active rows and calculate a charge
   try:

      # Run a query to select rows from a table
      query =  "select i from db_1.public.t1"
      res = session.sql(query).collect()

      # Define the price to charge per row
      billing_quantity = 2.5

      # Calculate the base charge based on number of rows in the result
      charge = len(res) * billing_quantity

      # Current time in Unix timestamp (epoch) time in milliseconds
      current_time_epoch = int(time.time() * 1000)

      return createBillingEvent(session, 'ROWS_CONSUMED', '', current_time_epoch, current_time_epoch, charge, '["billing_event_rows"]', '')
   except Exception as ex:
      return "Error " + ex
$$;

-- Example 6658
CALL merge_procedure()

-- Example 6659
SELECT listing_global_name,
   listing_display_name,
   charge_type,
   charge
FROM SNOWFLAKE.DATA_SHARING_USAGE.MARKETPLACE_PAID_USAGE_DAILY
WHERE charge_type='MONETIZABLE_BILLING_EVENTS'
      AND PROVIDER_ACCOUNT_NAME = <account_name>
      AND PROVIDER_ORGANIZATION_NAME= <organization_name>;

-- Example 6660
+---------------------+------------------------+----------------------------+--------+
| LISTING_GLOBAL_NAME |  LISTING_DISPLAY_NAME  |        CHARGE_TYPE         | CHARGE |
+---------------------+------------------------+----------------------------+--------+
| AAAA0BBB1CC         | Snowy Mountain Listing | MONETIZABLE_BILLING_EVENTS |   18.6 |
+---------------------+------------------------+----------------------------+--------+

-- Example 6661
SYSTEM$CREATE_BILLING_EVENTS('<json_array_of_events>')

-- Example 6662
{
  "class": "my_class",
  "subclass": "my_subclass",
  "start_timestamp": 1730825611,
  "timestamp": 1730826611,
  "base_charge": 1.00,
  "objects": "[\"my_schema.my_udf\"]",
  "additional_info": "my_additional_info"
}

-- Example 6663
SYSTEM$CURRENT_USER_TASK_NAME()

-- Example 6664
CREATE TASK mytask
  WAREHOUSE = mywh,
  SCHEDULE = '5 MINUTE'
AS
  INSERT INTO mytable(ts, task) VALUES(CURRENT_TIMESTAMP, SYSTEM$CURRENT_USER_TASK_NAME());

SELECT * FROM mytable;

+-------------------------+------------------------------------+
| TS                      | TASK                               |
|-------------------------+------------------------------------|
| 2018-11-15 07:41:33.463 | MYDB.PUBLIC.MYTASK                 |
+-------------------------+------------------------------------+

-- Example 6665
SYSTEM$DATA_METRIC_SCAN(
  REF_ENTITY_NAME  => '<object>'
  , METRIC_NAME  => '<data_metric_function>'
  , ARGUMENT_NAME => '<column>'
   [ , AT_TIMESTAMP => '<timestamp>' ] )

-- Example 6666
SELECT *
  FROM TABLE(SYSTEM$DATA_METRIC_SCAN(
    REF_ENTITY_NAME  => 'governance.sch.employeesTable',
    METRIC_NAME  => 'snowflake.core.null_count',
    ARGUMENT_NAME => 'SSN'
  ));

-- Example 6667
SELECT *
  FROM TABLE(SYSTEM$DATA_METRIC_SCAN(
    REF_ENTITY_NAME  => 'governance.sch.employeesTable',
    METRIC_NAME  => 'snowflake.core.blank_count',
    ARGUMENT_NAME => 'name',
    AT_TIMESTAMP => '2024-08-28 02:00:00 -0700'
  ));

-- Example 6668
GRANT USAGE ON FUNCTION
  governance.dmfs.count_positive_numbers(TABLE(NUMBER, NUMBER, NUMBER))
  TO data_engineer;

-- Example 6669
SYSTEM$DATABASE_REFRESH_HISTORY( '<secondary_db_name>' )

-- Example 6670
SELECT SYSTEM$DATABASE_REFRESH_HISTORY('mydb');

-- Example 6671
SELECT
    to_timestamp_ltz(value:startTimeUTC::numeric,3) AS "start_time"
    , to_timestamp_ltz(value:endTimeUTC::numeric,3) AS "end_time"
    , value:currentPhase::string AS "phase"
  , value:jobUUID::string AS "query_ID"
  , value:copy_bytes::integer AS "bytes_transferred"
FROM TABLE(flatten(INPUT=> PARSE_JSON(SYSTEM$DATABASE_REFRESH_HISTORY('mydb'))));

-- Example 6672
SYSTEM$DATABASE_REFRESH_PROGRESS( '<secondary_db_name>' )

SYSTEM$DATABASE_REFRESH_PROGRESS_BY_JOB( '<query_id>' )

-- Example 6673
SELECT SYSTEM$DATABASE_REFRESH_PROGRESS('mydb');

-- Example 6674
SELECT value:phaseName::string AS "Phase",
  value:resultName::string AS "Result",
  TO_TIMESTAMP_LTZ(value:startTimeUTC::numeric,3) AS "startTime",
  TO_TIMESTAMP_LTZ(value:endTimeUTC::numeric,3) AS "endTime",
  value:details AS "details"
  FROM table(flatten(INPUT=> PARSE_JSON(SYSTEM$DATABASE_REFRESH_PROGRESS('mydb1'))));

-- Example 6675
SELECT SYSTEM$DATABASE_REFRESH_PROGRESS_BY_JOB('4cbd7187-51f6-446c-9814-92d7f57d939b');

-- Example 6676
SELECT value:phaseName::string AS "Phase",
  value:resultName::string AS "Result",
  TO_TIMESTAMP_LTZ(value:startTimeUTC::numeric,3) AS "startTime",
  TO_TIMESTAMP_LTZ(value:endTimeUTC::numeric,3) AS "endTime",
  value:details AS "details"
  FROM TABLE(FLATTEN(input=> PARSE_JSON(SYSTEM$DATABASE_REFRESH_PROGRESS_BY_JOB('4cbd7187-51f6-446c-9814-92d7f57d939b'))));

-- Example 6677
SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT( '<provider_service_name>' )

-- Example 6678
SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
 '<provider_resource_id>'
 [, '<subresource>' ]
)

-- Example 6679
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT('com.amazonaws.us-west-2.s3');

-- Example 6680
SELECT SYSTEM$DEPROVISION_PRIVATELINK_ENDPOINT(
  '/subscriptions/f4b00c5f-f6bf-41d6-806b-e1cac4f1f36f/resourceGroups/aztest1-external-function-rg/providers/Microsoft.ApiManagement/service/aztest1-external-function-api',
  'Gateway'
  );

