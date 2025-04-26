-- Example 26842
CASE
  WHEN EXISTS
    (SELECT role FROM <db>.<schema>.entitlement WHERE mask_method='unmask' AND role = current_role()) THEN val
  ELSE '********'
END;

-- Example 26843
case
  when current_role() in ('ANALYST') then DECRYPT(val, $passphrase)
  else val -- shows encrypted value
end;

-- Example 26844
-- Flatten the JSON data

create or replace table <table_name> (v variant) as
select value::variant
from @<table_name>,
  table(flatten(input => parse_json($1):stationLocation));

-- JavaScript UDF to mask latitude, longitude, and location data

CREATE OR REPLACE FUNCTION full_location_masking(v variant)
  RETURNS variant
  LANGUAGE JAVASCRIPT
  AS
  $$
    if ("latitude" in V) {
      V["latitude"] = "**latitudeMask**";
    }
    if ("longitude" in V) {
      V["longitude"] = "**longitudeMask**";
    }
    if ("location" in V) {
      V["location"] = "**locationMask**";
    }

    return V;
  $$;

  -- Grant UDF usage to ACCOUNTADMIN

  grant ownership on function FULL_LOCATION_MASKING(variant) to role accountadmin;

  -- Create a masking policy using JavaScript UDF

  create or replace masking policy json_location_mask as (val variant) returns variant ->
    CASE
      WHEN current_role() IN ('ANALYST') THEN val
      else full_location_masking(val)
      -- else object_insert(val, 'latitude', '**locationMask**', true) -- limited to one value at a time
    END;

-- Example 26845
create masking policy mask_geo_point as (val geography) returns geography ->
  case
    when current_role() IN ('ANALYST') then val
    else to_geography('POINT(-122.35 37.55)')
  end;

-- Example 26846
alter table mydb.myschema.geography modify column b set masking policy mask_geo_point;
alter session set geography_output_format = 'GeoJSON';
use role public;
select * from mydb.myschema.geography;

-- Example 26847
---+--------------------+
 A |         B          |
---+--------------------+
 1 | {                  |
   |   "coordinates": [ |
   |     -122.35,       |
   |     37.55          |
   |   ],               |
   |   "type": "Point"  |
   | }                  |
 2 | {                  |
   |   "coordinates": [ |
   |     -122.35,       |
   |     37.55          |
   |   ],               |
   |   "type": "Point"  |
   | }                  |
---+--------------------+

-- Example 26848
alter session set geography_output_format = 'WKT';
select * from mydb.myschema.geography;

---+----------------------+
 A |         B            |
---+----------------------+
 1 | POINT(-122.35 37.55) |
 2 | POINT(-122.35 37.55) |
---+----------------------+

-- Example 26849
-- Conditional Masking

create masking policy email_visibility as
(email varchar, visibility string) returns varchar ->
  case
    when current_role() = 'ADMIN' then email
    when visibility = 'Public' then email
    else '***MASKED***'
  end;

-- Example 26850
-- Conditional Tokenization

create masking policy de_email_visibility as
 (email varchar, visibility string) returns varchar ->
   case
     when current_role() = 'ADMIN' and visibility = 'Public' then de_email(email)
     else email -- sees tokenized data
   end;

-- Example 26851
create or replace masking policy governance.policies.email_mask
as (val string) returns string ->
case
  when current_role() in ('ANALYST') then val
  when current_role() in ('SUPPORT') then regexp_replace(val,'.+\@','*****@')
  else '********'
end
comment = 'specify in row access policy'
exempt_other_policies = true
;

-- Example 26852
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  ..

-- Example 26853
CREATE EXTERNAL TABLE
  <table_name>
     ( <part_col_name> <col_type> AS <part_expr> )
     [ , ... ]
  [ PARTITION BY ( <part_col_name> [, <part_col_name> ... ] ) ]
  PARTITION_TYPE = USER_SPECIFIED
  ..

-- Example 26854
ALTER EXTERNAL TABLE <name> ADD PARTITION ( <part_col_name> = '<string>' [ , <part_col_name> = '<string>' ] ) LOCATION '<path>'

-- Example 26855
SHOW EXTERNAL TABLES LIKE 'my_delta_ext_table';

-- Example 26856
CREATE OR REPLACE EXTERNAL VOLUME delta_migration_ext_vol
STORAGE_LOCATIONS = (
  (
    NAME = storage_location_1
    STORAGE_PROVIDER = 'S3'
    STORAGE_BASE_URL = 's3://my-bucket/'
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::123456789123:role/my-storage-role' )
);

-- Example 26857
CREATE ICEBERG TABLE my_delta_table_1
  BASE_LOCATION = 'delta-ext-table-1'
  EXTERNAL_VOLUME = 'delta_migration_ext_vol'
  CATALOG = 'delta_catalog_integration';

-- Example 26858
DROP EXTERNAL TABLE my_delta_ext_table_1;

-- Example 26859
CREATE or replace PROCEDURE remove_old_files(external_table_name varchar, num_days float)
  RETURNS varchar
  LANGUAGE javascript
  EXECUTE AS CALLER
  AS
  $$
  // 1. Get the relative path of the external table
  // 2. Find all files registered before the specified time period
  // 3. Remove the files


  var resultSet1 = snowflake.execute({ sqlText:
    `call exttable_bucket_relative_path('` + EXTERNAL_TABLE_NAME + `');`
  });
  resultSet1.next();
  var relPath = resultSet1.getColumnValue(1);


  var resultSet2 = snowflake.execute({ sqlText:
    `select file_name
     from table(information_schema.EXTERNAL_TABLE_FILES (
         TABLE_NAME => '` + EXTERNAL_TABLE_NAME +`'))
     where last_modified < dateadd(day, -` + NUM_DAYS + `, current_timestamp());`
  });

  var fileNames = [];
  while (resultSet2.next())
  {
    fileNames.push(resultSet2.getColumnValue(1).substring(relPath.length));
  }

  if (fileNames.length == 0)
  {
    return 'nothing to do';
  }


  var alterCommand = `ALTER EXTERNAL TABLE ` + EXTERNAL_TABLE_NAME + ` REMOVE FILES ('` + fileNames.join(`', '`) + `');`;

  var resultSet3 = snowflake.execute({ sqlText: alterCommand });

  var results = [];
  while (resultSet3.next())
  {
    results.push(resultSet3.getColumnValue(1) + ' -> ' + resultSet3.getColumnValue(2));
  }

  return results.length + ' files: \n' + results.join('\n');

  $$;

  CREATE or replace PROCEDURE exttable_bucket_relative_path(external_table_name varchar)
  RETURNS varchar
  LANGUAGE javascript
  EXECUTE AS CALLER
  AS
  $$
  var resultSet = snowflake.execute({ sqlText:
    `show external tables like '` + EXTERNAL_TABLE_NAME + `';`
  });

  resultSet.next();
  var location = resultSet.getColumnValue(10);

  var relPath = location.split('/').slice(3).join('/');
  return relPath.endsWith("/") ? relPath : relPath + "/";

  $$;

-- Example 26860
-- Remove all files from the exttable external table metadata:
call remove_old_files('exttable', 0);

-- Remove files staged longer than 90 days ago from the exttable external table metadata:
call remove_old_files('exttable', 90);

-- Example 26861
SELECT col1
  FROM tab1
  WHERE location = 'New York';

-- Example 26862
CREATE TABLE patients
  (patient_ID INTEGER,
   category VARCHAR,      -- 'PhysicalHealth' or 'MentalHealth'
   diagnosis VARCHAR
   );

INSERT INTO patients (patient_ID, category, diagnosis) VALUES
  (1, 'MentalHealth', 'paranoia'),
  (2, 'PhysicalHealth', 'lung cancer');

-- Example 26863
CREATE VIEW mental_health_view AS
  SELECT * FROM patients WHERE category = 'MentalHealth';

CREATE VIEW physical_health_view AS
  SELECT * FROM patients WHERE category = 'PhysicalHealth';

-- Example 26864
SELECT * FROM physical_health_view
  WHERE 1/IFF(category = 'MentalHealth', 0, 1) = 1;

-- Example 26865
SELECT * FROM patients
  WHERE
    category = 'PhysicalHealth' AND
    1/IFF(category = 'MentalHealth', 0, 1) = 1;

-- Example 26866
restricted_features:
  - external_data:
     description: “The reason for enabling an external or Iceberg table.”

-- Example 26867
TAG_REFERENCES( '<object_name>' , '<object_domain>' )

-- Example 26868
select *
  from table(my_db.information_schema.tag_references('my_table', 'table'));

-- Example 26869
select *
  from table(my_db.information_schema.tag_references('my_table.result', 'COLUMN'));

-- Example 26870
ALTER ACCOUNT SET SESSION POLICY mydb.policies.session_policy_prod_1;

-- Example 26871
ALTER ACCOUNT UNSET SESSION POLICY;

-- Example 26872
ALTER USER jsmith SET SESSION POLICY mydb.policies.session_policy_prod_1_jsmith;

-- Example 26873
ALTER USER jsmith UNSET SESSION POLICY;

-- Example 26874
POLICY_REFERENCES( POLICY_NAME => '<session_policy_name>' )

-- Example 26875
SELECT *
FROM TABLE(
  my_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
    POLICY_NAME => 'my_db.my_schema.session_policy_prod_1'
  ));

-- Example 26876
CREATE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

-- Example 26877
CREATE OR REPLACE TABLE join_table (
  col1 INT,
  col2 VARCHAR,
  col3 NUMBER )
  JOIN POLICY jp1;

-- Example 26878
SELECT * FROM join_table;

-- Example 26879
506037 (23001): SQL compilation error: Join Policy violation, please contact the policy admin for details

-- Example 26880
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 26881
+------+------+------+------+------+------+
| COL1 | COL2 | COL3 | COL1 | COL2 | COL3 |
|------+------+------+------+------+------|
+------+------+------+------+------+------+

-- Example 26882
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col2=jt2.col2;

-- Example 26883
+------+------+------+------+------+------+
| COL1 | COL2 | COL3 | COL1 | COL2 | COL3 |
|------+------+------+------+------+------|
+------+------+------+------+------+------+

-- Example 26884
ALTER TABLE join_table UNSET JOIN POLICY;

DROP JOIN POLICY jp1;

CREATE JOIN POLICY jp1
  AS () RETURNS JOIN_CONSTRAINT -> JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE);

CREATE OR REPLACE TABLE join_table (
  col1 INT,
  col2 VARCHAR,
  col3 NUMBER )
  JOIN POLICY jp1 ALLOWED JOIN KEYS (col1);

-- Example 26885
SELECT * FROM join_table jt1 INNER JOIN join_table_2 jt2 ON jt1.col2=jt2.col2;

-- Example 26886
506038 (23001): SQL compilation error: Join Policy violation, invalid join condition with reason: Disallowed join key used.

-- Example 26887
SHOW JOIN POLICIES;

-- Example 26888
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+
| created_on                    | name | database_name | schema_name    | kind        | owner        | comment | owner_role_type | options |
|-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------|
| 2024-12-04 15:15:49.591 -0800 | JP1  | POLICY1_DB    | POLICY1_SCHEMA | JOIN_POLICY | POLICY1_ROLE |         | ROLE            |         |
+-------------------------------+------+---------------+----------------+-------------+--------------+---------+-----------------+---------+

-- Example 26889
DESCRIBE JOIN POLICY jp1;

-- Example 26890
+------+-----------+-----------------+----------------------------------------+
| name | signature | return_type     | body                                   |
|------+-----------+-----------------+----------------------------------------|
| JP1  | ()        | JOIN_CONSTRAINT | JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE) |
+------+-----------+-----------------+----------------------------------------+

-- Example 26891
CREATE JOIN POLICY my_join_policy
  AS () RETURNS JOIN_CONSTRAINT ->
    CASE
      WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'
          OR CURRENT_ROLE() = 'FINANCE_ROLE'
          OR CURRENT_ROLE() = 'HR_ROLE'
        THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE)
      ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)
    END;

-- Example 26892
SELECT col1, col2 FROM join_table;

-- Example 26893
SELECT *
  FROM join_table jt1, join_table_2 jt2
  WHERE jt1.col1=jt2.col1;

-- Example 26894
SELECT * FROM join_table jt1
  LEFT OUTER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 26895
SELECT * FROM join_table jt1
  RIGHT OUTER JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 26896
SELECT * FROM join_table jt1 JOIN join_table_2 jt2 ON jt1.col1=jt2.col1;

-- Example 26897
SELECT * FROM JOIN_TABLE
UNION
SELECT * FROM JOIN_TABLE_3;

-- Example 26898
SELECT * FROM JOIN_TABLE
INTERSECT
SELECT * FROM JOIN_TABLE_3;

-- Example 26899
SELECT * FROM JOIN_TABLE
EXCEPT
SELECT * FROM JOIN_TABLE_3;

-- Example 26900
SELECT * FROM JOIN_TABLE_3
EXCEPT
SELECT * FROM JOIN_TABLE;

-- Example 26901
CREATE VIEW join_table_view AS
  SELECT * FROM join_table;

-- Example 26902
SELECT * FROM join_table_view;

-- Example 26903
ALTER JOIN POLICY jp3 SET BODY -> JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE);

-- Example 26904
ALTER TABLE join_table SET JOIN POLICY jp2 FORCE;

-- Example 26905
ALTER VIEW join_view UNSET JOIN POLICY;

-- Example 26906
SELECT policy_name, policy_body, created
  FROM SNOWFLAKE.ACCOUNT_USAGE.JOIN_POLICIES
  WHERE policy_name='JP2' AND created LIKE '2024-11-26%';

-- Example 26907
+-------------+----------------------------------------------------------+-------------------------------+
| POLICY_NAME | POLICY_BODY                                              | CREATED                       |
|-------------+----------------------------------------------------------+-------------------------------|
| JP2         | CASE                                                     | 2024-11-26 11:22:54.848 -0800 |
|             |           WHEN CURRENT_ROLE() = 'ACCOUNTADMIN'           |                               |
|             |             THEN JOIN_CONSTRAINT(JOIN_REQUIRED => FALSE) |                               |
|             |           ELSE JOIN_CONSTRAINT(JOIN_REQUIRED => TRUE)    |                               |
|             |         END                                              |                               |
+-------------+----------------------------------------------------------+-------------------------------+

-- Example 26908
USE DATABASE my_db;
USE SCHEMA INFORMATION_SCHEMA;
SELECT
    policy_name,
    policy_kind,
    ref_entity_name,
    ref_entity_domain,
    ref_column_name,
    ref_arg_column_names,
    policy_status
  FROM TABLE(INFORMATION_SCHEMA.POLICY_REFERENCES(policy_name => 'my_db.my_schema.jp1'));

