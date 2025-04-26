-- Example 12375
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12376
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12377
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12378
CREATE DYNAMIC TABLE dt
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = my_wh
  AS
    SELECT * FROM db2.sch1.source_table

-- Example 12379
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing (referred entity <- [referring entities])

-- Example 12380
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referredentity <- [referring entities])

-- Example 12381
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12382
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12383
Dangling references in the snapshot. Correct the errors before refreshing again. The following references are missing
(referred entity <- [referring entities])

-- Example 12384
CREATE DYNAMIC TABLE dt
  TARGET_LAG = DOWNSTREAM
  WAREHOUSE = my_wh
  AS
    SELECT * FROM db2.sch1.source_table

-- Example 12385
EXPLAIN [ USING { TABULAR | JSON | TEXT } ] <statement>

-- Example 12386
CREATE TABLE Z1 (ID INTEGER);
CREATE TABLE Z2 (ID INTEGER);
CREATE TABLE Z3 (ID INTEGER);

-- Example 12387
EXPLAIN USING TABULAR SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+
| step | id   | parentOperators | operation   | objects                      | alias | expressions              | partitionsTotal | partitionsAssigned | bytesAssigned |
|------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------|
| NULL | NULL |            NULL | GlobalStats | NULL                         | NULL  | NULL                     |               2 |                  2 |          1024 |
|    1 |    0 |            NULL | Result      | NULL                         | NULL  | Z1.ID, Z2.ID             |            NULL |               NULL |          NULL |
|    1 |    1 |             [0] | InnerJoin   | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    2 |             [1] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z2 | NULL  | ID                       |               1 |                  1 |           512 |
|    1 |    3 |             [1] | JoinFilter  | NULL                         | NULL  | joinKey: (Z2.ID = Z1.ID) |            NULL |               NULL |          NULL |
|    1 |    4 |             [3] | TableScan   | TESTDB.TEMPORARY_DOC_TEST.Z1 | NULL  | ID                       |               1 |                  1 |           512 |
+------+------+-----------------+-------------+------------------------------+-------+--------------------------+-----------------+--------------------+---------------+

-- Example 12388
EXPLAIN USING TEXT SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+------------------------------------------------------------------------------------------------------------------------------------+
| content                                                                                                                            |
|------------------------------------------------------------------------------------------------------------------------------------|
| GlobalStats:                                                                                                                       |
|     partitionsTotal=2                                                                                                              |
|     partitionsAssigned=2                                                                                                           |
|     bytesAssigned=1024                                                                                                             |
| Operations:                                                                                                                        |
| 1:0     ->Result  Z1.ID, Z2.ID                                                                                                     |
| 1:1          ->InnerJoin  joinKey: (Z2.ID = Z1.ID)                                                                                 |
| 1:2               ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z2  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512}      |
| 1:3               ->JoinFilter  joinKey: (Z2.ID = Z1.ID)                                                                           |
| 1:4                    ->TableScan  TESTDB.TEMPORARY_DOC_TEST.Z1  ID  {partitionsTotal=1, partitionsAssigned=1, bytesAssigned=512} |
|                                                                                                                                    |
+------------------------------------------------------------------------------------------------------------------------------------+

-- Example 12389
EXPLAIN USING JSON SELECT Z1.ID, Z2.ID 
    FROM Z1, Z2
    WHERE Z2.ID = Z1.ID;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| content                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| {"GlobalStats":{"partitionsTotal":2,"partitionsAssigned":2,"bytesAssigned":1024},"Operations":[[{"id":0,"operation":"Result","expressions":["Z1.ID","Z2.ID"]},{"id":1,"parentOperators":[0],"operation":"InnerJoin","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":2,"parentOperators":[1],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z2"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512},{"id":3,"parentOperators":[1],"operation":"JoinFilter","expressions":["joinKey: (Z2.ID = Z1.ID)"]},{"id":4,"parentOperators":[3],"operation":"TableScan","objects":["TESTDB.TEMPORARY_DOC_TEST.Z1"],"expressions":["ID"],"partitionsAssigned":1,"partitionsTotal":1,"bytesAssigned":512}]]} |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

-- Example 12390
CREATE APPLICATION PACKAGE app_package;

GRANT USAGE ON SCHEMA app_package.shared_schema
  TO SHARE IN APPLICATION PACKAGE app_package;
GRANT SELECT ON TABLE app_package.shared_schema.shared_table
  TO SHARE IN APPLICATION PACKAGE app_package;

-- Example 12391
GRANT REFERENCE_USAGE ON DATABASE other_db
  TO SHARE IN APPLICATION PACKAGE app_pkg;

-- Example 12392
CREATE VIEW app_pkg.shared_schema.shared_view
  AS SELECT c1, c2, c3, c4
  FROM other_db.other_schema.other_table;

-- Example 12393
GRANT USAGE ON SCHEMA app_pkg.shared_schema
  TO SHARE IN APPLICATION PACKAGE app_pkg;
GRANT SELECT ON VIEW app_pkg.shared_schema.shared_view
  TO SHARE IN APPLICATION PACKAGE app_pkg;

-- Example 12394
CREATE APPLICATION ROLE app_user;

CREATE OR ALTER VERSIONED SCHEMA inst_schema;
GRANT USAGE ON SCHEMA inst_schema
  TO APPLICATION ROLE app_user;

CREATE VIEW IF NOT EXISTS inst_schema.shared_view
  AS SELECT c1, c2, c3, c4
  FROM shared_schema.shared_table;

GRANT SELECT ON VIEW inst_schema.shared_view
  TO APPLICATION ROLE app_user;

-- Example 12395
use role useradmin;
CREATE ROLE masking_admin;

-- Example 12396
use role securityadmin;
GRANT CREATE MASKING POLICY on SCHEMA <db_name.schema_name> to ROLE masking_admin;
GRANT APPLY MASKING POLICY on ACCOUNT to ROLE masking_admin;

-- Example 12397
GRANT APPLY ON MASKING POLICY ssn_mask to ROLE table_owner;

-- Example 12398
GRANT ROLE masking_admin TO USER jsmith;

-- Example 12399
CREATE OR REPLACE MASKING POLICY email_mask AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '*********'
  END;

-- Example 12400
-- apply masking policy to a table column

ALTER TABLE IF EXISTS user_info MODIFY COLUMN email SET MASKING POLICY email_mask;

-- apply the masking policy to a view column

ALTER VIEW user_info_v MODIFY COLUMN email SET MASKING POLICY email_mask;

-- Example 12401
-- using the ANALYST role

USE ROLE analyst;
SELECT email FROM user_info; -- should see plain text value

-- using the PUBLIC role

USE ROLE PUBLIC;
SELECT email FROM user_info; -- should see full data mask

-- Example 12402
+----------+-------------+---------------+
| USERNAME |     ID      | PHONE_NUMBER  |
+----------+-------------+---------------+
| JSMITH   | 12-3456-89  | 1555-523-8790 |
| AJONES   | 12-0124-32  | 1555-125-1548 |
+----------+-------------+---------------+

-- Example 12403
+---------------+---------------+
| ROLE          | IS_AUTHORIZED |
+---------------+---------------+
| DATA_ENGINEER | TRUE          |
| DATA_STEWARD  | TRUE          |
| IT_ADMIN      | TRUE          |
| PUBLIC        | FALSE         |
+---------------+---------------+

-- Example 12404
CREATE FUNCTION is_role_authorized(arg1 VARCHAR)
RETURNS BOOLEAN
MEMOIZABLE
AS
$$
  SELECT ARRAY_CONTAINS(
    arg1::VARIANT,
    (SELECT ARRAY_AGG(role) FROM auth_role WHERE is_authorized = TRUE)
  )
$$;

-- Example 12405
SELECT is_role_authorized(IT_ADMIN);

-- Example 12406
+---------------------------------------------+
|         is_role_authorized(IT_ADMIN)        |
+---------------------------------------------+
|                    TRUE                     |
+---------------------------------------------+

-- Example 12407
CREATE OR REPLACE MASKING POLICY empl_id_mem_mask
AS (val VARCHAR) RETURNS VARCHAR ->
CASE
  WHEN is_role_authorized(CURRENT_ROLE()) THEN val
  ELSE NULL
END;

-- Example 12408
ALTER TABLE employee_data MODIFY COLUMN id
  SET MASKING POLICY empl_id_mem_mask;

-- Example 12409
USE ROLE data_engineer;
SELECT * FROM employee_data;

-- Example 12410
case
  when current_account() in ('<prod_account_identifier>') then val
  else '*********'
end;

-- Example 12411
case
  when current_role() IN ('ANALYST') then val
  else NULL
end;

-- Example 12412
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 12413
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE sha2(val) -- return hash of the column value
END;

-- Example 12414
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  WHEN current_role() IN ('SUPPORT') THEN regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  ELSE '********'
END;

-- Example 12415
case
  WHEN current_role() in ('SUPPORT') THEN val
  else date_from_parts(0001, 01, 01)::timestamp_ntz -- returns 0001-01-01 00:00:00.000
end;

-- Example 12416
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE mask_udf(val) -- custom masking function
END;

-- Example 12417
CASE
   WHEN current_role() IN ('ANALYST') THEN val
   ELSE OBJECT_INSERT(val, 'USER_IPADDRESS', '****', true)
END;

-- Example 12418
CASE
  WHEN EXISTS
    (SELECT role FROM <db>.<schema>.entitlement WHERE mask_method='unmask' AND role = current_role()) THEN val
  ELSE '********'
END;

-- Example 12419
case
  when current_role() in ('ANALYST') then DECRYPT(val, $passphrase)
  else val -- shows encrypted value
end;

-- Example 12420
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

-- Example 12421
create masking policy mask_geo_point as (val geography) returns geography ->
  case
    when current_role() IN ('ANALYST') then val
    else to_geography('POINT(-122.35 37.55)')
  end;

-- Example 12422
alter table mydb.myschema.geography modify column b set masking policy mask_geo_point;
alter session set geography_output_format = 'GeoJSON';
use role public;
select * from mydb.myschema.geography;

-- Example 12423
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

-- Example 12424
alter session set geography_output_format = 'WKT';
select * from mydb.myschema.geography;

---+----------------------+
 A |         B            |
---+----------------------+
 1 | POINT(-122.35 37.55) |
 2 | POINT(-122.35 37.55) |
---+----------------------+

-- Example 12425
use role useradmin;
CREATE ROLE masking_admin;

-- Example 12426
use role securityadmin;
GRANT CREATE MASKING POLICY on SCHEMA <db_name.schema_name> to ROLE masking_admin;
GRANT APPLY MASKING POLICY on ACCOUNT to ROLE masking_admin;

-- Example 12427
GRANT APPLY ON MASKING POLICY ssn_mask to ROLE table_owner;

-- Example 12428
use role useradmin;
grant role masking_admin to user jsmith;

-- Example 12429
-- create masking policy

create or replace masking policy email_de_token as (val string) returns string ->
  case
    when current_role() in ('ANALYST') then de_email(val)
    else val
  end;

-- Example 12430
-- apply masking policy to a table column

alter table if exists user_info modify column email set masking policy email_de_token;

-- apply the masking policy to a view column

alter view user_info_v modify column email set masking policy email_de_token;

-- Example 12431
-- using the ANALYST custom role

use role ANALYST;
select email from user_info; -- should see plain text value

-- using the PUBLIC system role

use role public;
select email from user_info; -- should see tokenized value

-- Example 12432
SHOW MASKING POLICIES  [ LIKE '<pattern>' ]
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

-- Example 12433
SHOW MASKING POLICIES IN SCHEMA governance.policies;

-- Example 12434
+-------------------------------+------------+---------------+-------------+----------------+---------------+------------------------------+-----------------------------------+-----------------+
| created_on                    | name       | database_name | schema_name | kind           | owner         | comment                      | options                           | owner_role_type |
+-------------------------------+------------+---------------+-------------+----------------+---------------+------------------------------+-----------------------------------+-----------------+
| 2022-08-13 16:59:59.733 +0000 | EMAIL_MASK | GOVERNANCE    | POLICIES    | MASKING_POLICY | MASKING_ADMIN | SPECIFY IN ROW ACCESS POLICY | {“EXEMPT_OTHER_POLICIES”: "TRUE"} | ROLE            |
+-------------------------------+------------+---------------+-------------+----------------+---------------+------------------------------+-----------------------------------+-----------------+

-- Example 12435
select tag_name, tag_value, domain, object_id
from snowflake.account_usage.tag_references
order by tag_name, domain, object_id;

-- Example 12436
select tag_name, tag_value, domain, object_id
from snowflake.account_usage.tag_references
where object_deleted is null
order by tag_name, domain, object_id;

-- Example 12437
SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.COLUMNS
  WHERE
    table_catalog = 'mydb' AND
    table_name = 'myTable' AND
    deleted IS NULL;

-- Example 12438
SELECT table_schema, SUM(bytes)
  FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES
  WHERE deleted IS NULL
  GROUP BY table_schema;

-- Example 12439
USE ROLE ACCOUNTADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE data_engineer;

GRANT APPLY TAG ON ACCOUNT TO ROLE data_engineer;

-- Example 12440
USE ROLE ACCOUNTADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE schema_owner;

GRANT APPLY ON TAG governance.tags.schema_mask TO ROLE schema_owner;

-- Example 12441
USE ROLE SECURITYADMIN;

GRANT APPLY MASKING POLICY ON ACCOUNT TO ROLE tag_admin;

