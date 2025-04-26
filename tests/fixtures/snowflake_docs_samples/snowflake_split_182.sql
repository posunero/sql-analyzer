-- Example 12174
SELECT ... FROM my_table,
  TABLE(FLATTEN(input=>[col_a]))
  ON ... ;

-- Example 12175
CREATE TABLE t1 (col1 INTEGER);
CREATE TABLE t2 (col1 INTEGER);

-- Example 12176
INSERT INTO t1 (col1) VALUES 
   (2),
   (3),
   (4);
INSERT INTO t2 (col1) VALUES 
   (1),
   (2),
   (2),
   (3);

-- Example 12177
SELECT t1.col1, t2.col1
    FROM t1 INNER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 12178
SELECT t1.col1, t2.col1
    FROM t1 LEFT OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
|    4 | NULL |
+------+------+

-- Example 12179
SELECT t1.col1, t2.col1
    FROM t1 RIGHT OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
| NULL |    1 |
+------+------+

-- Example 12180
SELECT t1.col1, t2.col1
    FROM t1 FULL OUTER JOIN t2
        ON t2.col1 = t1.col1
    ORDER BY 1,2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
|    4 | NULL |
| NULL |    1 |
+------+------+

-- Example 12181
SELECT t1.col1, t2.col1
    FROM t1 CROSS JOIN t2
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    1 |
|    2 |    2 |
|    2 |    2 |
|    2 |    3 |
|    3 |    1 |
|    3 |    2 |
|    3 |    2 |
|    3 |    3 |
|    4 |    1 |
|    4 |    2 |
|    4 |    2 |
|    4 |    3 |
+------+------+

-- Example 12182
SELECT t1.col1, t2.col1
    FROM t1 CROSS JOIN t2
    WHERE t2.col1 = t1.col1
    ORDER BY 1, 2;
+------+------+
| COL1 | COL1 |
|------+------|
|    2 |    2 |
|    2 |    2 |
|    3 |    3 |
+------+------+

-- Example 12183
CREATE OR REPLACE TABLE d1 (
  id number,
  name string
  );
+--------------------------------+
| status                         |
|--------------------------------|
| Table D1 successfully created. |
+--------------------------------+
INSERT INTO d1 (id, name) VALUES
  (1,'a'),
  (2,'b'),
  (4,'c');
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
CREATE OR REPLACE TABLE d2 (
  id number,
  value string
  );
+--------------------------------+
| status                         |
|--------------------------------|
| Table D2 successfully created. |
+--------------------------------+
INSERT INTO d2 (id, value) VALUES
  (1,'xx'),
  (2,'yy'),
  (5,'zz');
+-------------------------+
| number of rows inserted |
|-------------------------|
|                       3 |
+-------------------------+
SELECT *
    FROM d1 NATURAL INNER JOIN d2
    ORDER BY id;
+----+------+-------+
| ID | NAME | VALUE |
|----+------+-------|
|  1 | a    | xx    |
|  2 | b    | yy    |
+----+------+-------+

-- Example 12184
SELECT *
  FROM d1 NATURAL FULL OUTER JOIN d2
  ORDER BY ID;
+----+------+-------+
| ID | NAME | VALUE |
|----+------+-------|
|  1 | a    | xx    |
|  2 | b    | yy    |
|  4 | c    | NULL  |
|  5 | NULL | zz    |
+----+------+-------+

-- Example 12185
CREATE TABLE t3 (col1 INTEGER);
INSERT INTO t3 (col1) VALUES 
   (2),
   (6);

-- Example 12186
SELECT t1.*, t2.*, t3.*
  FROM t1
     LEFT OUTER JOIN t2 ON (t1.col1 = t2.col1)
     RIGHT OUTER JOIN t3 ON (t3.col1 = t2.col1)
  ORDER BY t1.col1;
+------+------+------+
| COL1 | COL1 | COL1 |
|------+------+------|
|    2 |    2 |    2 |
|    2 |    2 |    2 |
| NULL | NULL |    6 |
+------+------+------+

-- Example 12187
SELECT t1.*, t2.*, t3.*
  FROM t1
     LEFT OUTER JOIN
     (t2 RIGHT OUTER JOIN t3 ON (t3.col1 = t2.col1))
     ON (t1.col1 = t2.col1)
  ORDER BY t1.col1;
+------+------+------+
| COL1 | COL1 | COL1 |
|------+------+------|
|    2 |    2 |    2 |
|    2 |    2 |    2 |
|    3 | NULL | NULL |
|    4 | NULL | NULL |
+------+------+------+

-- Example 12188
WITH
    l AS (
         SELECT 'a' AS userid
         ),
    r AS (
         SELECT 'b' AS userid
         )
  SELECT *
    FROM l LEFT JOIN r USING(userid)
;
+--------+
| USERID |
|--------|
| a      |
+--------+

-- Example 12189
WITH
    l AS (
         SELECT 'a' AS userid
       ),
    r AS (
         SELECT 'b' AS userid
         )
  SELECT l.userid as UI_L,
         r.userid as UI_R
    FROM l LEFT JOIN r USING(userid)
;
+------+------+
| UI_L | UI_R |
|------+------|
| a    | NULL |
+------+------+

-- Example 12190
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 12191
SELECT IS_ROLE_IN_SESSION('ANALYST');

-- Example 12192
+-------------------------------+
| IS_ROLE_IN_SESSION('ANALYST') |
+-------------------------------+
| FALSE                         |
+-------------------------------+

-- Example 12193
USE ROLE analyst;

SELECT * FROM mydb.mysch.mytable;

-- Example 12194
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN INVOKER_ROLE() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 12195
SHOW GRANTS OF ROLE analyst;

-- Example 12196
USE ROLE analyst;

SELECT * FROM mydb.mysch.myview;

-- Example 12197
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
  WHEN IS_GRANTED_TO_INVOKER_ROLE('PAYROLL') THEN val
  WHEN IS_GRANTED_TO_INVOKER_ROLE('ANALYST') THEN REGEXP_REPLACE(val, '[0-9]', '*', 7)
  ELSE '*******'
END;

-- Example 12198
SHOW GRANTS TO ROLE view_owner_role;

-- Example 12199
USE ROLE payroll;

SELECT * FROM mydb.mysch.myview;

USE ROLE analyst;

SELECT * FROM mydb.mysch.myview;

-- Example 12200
CREATE OR REPLACE MASKING POLICY mask_string AS
(val string) RETURNS string ->
CASE
    WHEN CURRENT_ROLE() IN ('CSR_EMPL_INFO') THEN HASH(val)
    WHEN INVOKER_ROLE() IN ('DBA_EMPL_INFO') THEN val
    ELSE null
END;

-- Example 12201
CREATE [ OR REPLACE ] MASKING POLICY [ IF NOT EXISTS ] <name> AS
( <arg_name_to_mask> <arg_type_to_mask> [ , <arg_1> <arg_type_1> ... ] )
RETURNS <arg_type_to_mask> -> <body>
[ COMMENT = '<string_literal>' ]
[ EXEMPT_OTHER_POLICIES = { TRUE | FALSE } ]

-- Example 12202
CREATE OR REPLACE MASKING POLICY email_mask AS (val string) returns string ->
  CASE
    WHEN current_role() IN ('ANALYST') THEN VAL
    ELSE '*********'
  END;

-- Example 12203
case
  when current_account() in ('<prod_account_identifier>') then val
  else '*********'
end;

-- Example 12204
case
  when current_role() IN ('ANALYST') then val
  else NULL
end;

-- Example 12205
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 12206
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE sha2(val) -- return hash of the column value
END;

-- Example 12207
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  WHEN current_role() IN ('SUPPORT') THEN regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  ELSE '********'
END;

-- Example 12208
case
  WHEN current_role() in ('SUPPORT') THEN val
  else date_from_parts(0001, 01, 01)::timestamp_ntz -- returns 0001-01-01 00:00:00.000
end;

-- Example 12209
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE mask_udf(val) -- custom masking function
END;

-- Example 12210
CASE
   WHEN current_role() IN ('ANALYST') THEN val
   ELSE OBJECT_INSERT(val, 'USER_IPADDRESS', '****', true)
END;

-- Example 12211
CASE
  WHEN EXISTS
    (SELECT role FROM <db>.<schema>.entitlement WHERE mask_method='unmask' AND role = current_role()) THEN val
  ELSE '********'
END;

-- Example 12212
case
  when current_role() in ('ANALYST') then DECRYPT(val, $passphrase)
  else val -- shows encrypted value
end;

-- Example 12213
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

-- Example 12214
create masking policy mask_geo_point as (val geography) returns geography ->
  case
    when current_role() IN ('ANALYST') then val
    else to_geography('POINT(-122.35 37.55)')
  end;

-- Example 12215
alter table mydb.myschema.geography modify column b set masking policy mask_geo_point;
alter session set geography_output_format = 'GeoJSON';
use role public;
select * from mydb.myschema.geography;

-- Example 12216
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

-- Example 12217
alter session set geography_output_format = 'WKT';
select * from mydb.myschema.geography;

---+----------------------+
 A |         B            |
---+----------------------+
 1 | POINT(-122.35 37.55) |
 2 | POINT(-122.35 37.55) |
---+----------------------+

-- Example 12218
-- Conditional Masking

create masking policy email_visibility as
(email varchar, visibility string) returns varchar ->
  case
    when current_role() = 'ADMIN' then email
    when visibility = 'Public' then email
    else '***MASKED***'
  end;

-- Example 12219
-- Conditional Tokenization

create masking policy de_email_visibility as
 (email varchar, visibility string) returns varchar ->
   case
     when current_role() = 'ADMIN' and visibility = 'Public' then de_email(email)
     else email -- sees tokenized data
   end;

-- Example 12220
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

-- Example 12221
DESC[RIBE] MASKING POLICY <name>

-- Example 12222
DESC MASKING POLICY ssn_mask;

-- Example 12223
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+
| Row | name       | signature     | return_type       | body                                                                  |
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+
| 1   | SSN_MASK   | (VAL VARCHAR) | VARCHAR(16777216) | case when current_role() in ('ANALYST') then val else '*********' end |
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+

-- Example 12224
ALTER MASKING POLICY [ IF EXISTS ] <name> RENAME TO <new_name>

ALTER MASKING POLICY [ IF EXISTS ] <name> SET BODY -> <expression_on_arg_name_to_mask>

ALTER MASKING POLICY [ IF EXISTS ] <name> SET TAG <tag_name> = '<tag_value>' [ , <tag_name> = '<tag_value>' ... ]

ALTER MASKING POLICY [ IF EXISTS ] <name> UNSET TAG <tag_name> [ , <tag_name> ... ]

ALTER MASKING POLICY [ IF EXISTS ] <name> SET COMMENT = '<string_literal>'

ALTER MASKING POLICY [ IF EXISTS ] <name> UNSET COMMENT

-- Example 12225
DESCRIBE MASKING POLICY email_mask;

-- Example 12226
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+
| Row | name       | signature     | return_type       | body                                                                  |
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+
| 1   | EMAIL_MASK | (VAL VARCHAR) | VARCHAR(16777216) | case when current_role() in ('ANALYST') then val else '*********' end |
+-----+------------+---------------+-------------------+-----------------------------------------------------------------------+

-- Example 12227
ALTER MASKING POLICY email_mask SET BODY ->
  CASE
    WHEN current_role() IN ('ANALYST') THEN VAL
    ELSE sha2(val, 512)
  END;

-- Example 12228
DROP MASKING POLICY <name>

-- Example 12229
SELECT * from table(information_schema.policy_references(policy_name=>'<string>'));

-- Example 12230
DROP MASKING POLICY ssn_mask;

-- Example 12231
ALTER TABLE <name> { ALTER | MODIFY } [ ( ]
                                              [ COLUMN ] <col1_name> DROP DEFAULT
                                            , [ COLUMN ] <col1_name> SET DEFAULT <seq_name>.NEXTVAL
                                            , [ COLUMN ] <col1_name> { [ SET ] NOT NULL | DROP NOT NULL }
                                            , [ COLUMN ] <col1_name> [ [ SET DATA ] TYPE ] <type>
                                            , [ COLUMN ] <col1_name> COMMENT '<string>'
                                            , [ COLUMN ] <col1_name> UNSET COMMENT
                                          [ , [ COLUMN ] <col2_name> ... ]
                                          [ , ... ]
                                      [ ) ]

ALTER TABLE <name> { ALTER | MODIFY } [ COLUMN ] dataGovnPolicyTagAction

-- Example 12232
CREATE TABLE t(x INT);
INSERT INTO t VALUES (1), (2), (3);
ALTER TABLE t ADD COLUMN y INT DEFAULT 100;
INSERT INTO t(x) VALUES (4), (5), (6);

ALTER TABLE t ALTER COLUMN y DROP DEFAULT;

-- Example 12233
CREATE OR REPLACE TABLE t1 (
   c1 NUMBER NOT NULL,
   c2 NUMBER DEFAULT 3,
   c3 NUMBER DEFAULT seq1.nextval,
   c4 VARCHAR(20) DEFAULT 'abcde',
   c5 STRING);

DESC TABLE t1;

+------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------+
| name | type              | kind   | null? | default                 | primary key | unique key | check | expression | comment |
|------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------|
| C1   | NUMBER(38,0)      | COLUMN | N     | NULL                    | N           | N          | NULL  | NULL       | NULL    |
| C2   | NUMBER(38,0)      | COLUMN | Y     | 3                       | N           | N          | NULL  | NULL       | NULL    |
| C3   | NUMBER(38,0)      | COLUMN | Y     | DB1.PUBLIC.SEQ1.NEXTVAL | N           | N          | NULL  | NULL       | NULL    |
| C4   | VARCHAR(20)       | COLUMN | Y     | 'abcde'                 | N           | N          | NULL  | NULL       | NULL    |
| C5   | VARCHAR(16777216) | COLUMN | Y     | NULL                    | N           | N          | NULL  | NULL       | NULL    |
+------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------+

-- Example 12234
ALTER TABLE t1 ALTER COLUMN c1 DROP NOT NULL;

ALTER TABLE t1 MODIFY c2 DROP DEFAULT, c3 SET DEFAULT seq5.nextval ;

ALTER TABLE t1 ALTER c4 SET DATA TYPE VARCHAR(50), COLUMN c4 DROP DEFAULT;

ALTER TABLE t1 ALTER c5 COMMENT '50 character column';

DESC TABLE t1;

+------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------------------+
| name | type              | kind   | null? | default                 | primary key | unique key | check | expression | comment             |
|------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------------------|
| C1   | NUMBER(38,0)      | COLUMN | Y     | NULL                    | N           | N          | NULL  | NULL       | NULL                |
| C2   | NUMBER(38,0)      | COLUMN | Y     | NULL                    | N           | N          | NULL  | NULL       | NULL                |
| C3   | NUMBER(38,0)      | COLUMN | Y     | DB1.PUBLIC.SEQ5.NEXTVAL | N           | N          | NULL  | NULL       | NULL                |
| C4   | VARCHAR(50)       | COLUMN | Y     | NULL                    | N           | N          | NULL  | NULL       | NULL                |
| C5   | VARCHAR(16777216) | COLUMN | Y     | NULL                    | N           | N          | NULL  | NULL       | 50 character column |
+------+-------------------+--------+-------+-------------------------+-------------+------------+-------+------------+---------------------+

-- Example 12235
ALTER TABLE t1 ALTER (
   c1 DROP NOT NULL,
   c5 COMMENT '50 character column',
   c4 TYPE VARCHAR(50),
   c2 DROP DEFAULT,
   COLUMN c4 DROP DEFAULT,
   COLUMN c3 SET DEFAULT seq5.nextval
  );

-- Example 12236
-- single column

ALTER TABLE empl_info MODIFY COLUMN empl_id SET MASKING POLICY mask_empl_id;

-- multiple columns

ALTER TABLE empl_info MODIFY
    COLUMN empl_id SET MASKING POLICY mask_empl_id
  , COLUMN empl_dob SET MASKING POLICY mask_empl_dob
;

-- Example 12237
-- single column

ALTER TABLE empl_info modify column empl_id unset masking policy;

-- multiple columns

ALTER TABLE empl_info MODIFY
    COLUMN empl_id UNSET MASKING POLICY
  , COLUMN empl_dob UNSET MASKING POLICY
;

-- Example 12238
GRANT {  { globalPrivileges         | ALL [ PRIVILEGES ] } ON ACCOUNT
       | { accountObjectPrivileges  | ALL [ PRIVILEGES ] } ON { USER | RESOURCE MONITOR | WAREHOUSE | COMPUTE POOL | DATABASE | INTEGRATION | CONNECTION | FAILOVER GROUP | REPLICATION GROUP | EXTERNAL VOLUME } <object_name>
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> } }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
      }
  TO [ ROLE ] <role_name> [ WITH GRANT OPTION ]

-- Example 12239
GRANT {  { CREATE SCHEMA | MODIFY | MONITOR | USAGE } [ , ... ] } ON DATABASE <object_name>
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { SCHEMA <schema_name> | ALL SCHEMAS IN DATABASE <db_name> }
       | { schemaPrivileges         | ALL [ PRIVILEGES ] } ON { FUTURE SCHEMAS IN DATABASE <db_name> }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON { <object_type> <object_name> | ALL <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> } }
       | { schemaObjectPrivileges   | ALL [ PRIVILEGES ] } ON FUTURE <object_type_plural> IN { DATABASE <db_name> | SCHEMA <schema_name> }
      }
  TO DATABASE ROLE <database_role_name> [ WITH GRANT OPTION ]

-- Example 12240
globalPrivileges ::=
  {
      CREATE {
          ACCOUNT | APPLICATION | APPLICATION PACKAGE | COMPUTE POOL | DATA EXCHANGE LISTING
          | DATABASE | EXTERNAL VOLUME | FAILOVER GROUP | INTEGRATION | NETWORK POLICY
          | ORGANIZATION LISTING | ORGANIZATION PROFILE | REPLICATION GROUP | ROLE | SHARE
       | USER | WAREHOUSE
      }
      | ATTACH POLICY | AUDIT | BIND SERVICE ENDPOINT
      | APPLY {
         { AGGREGATION | AUTHENTICATION | JOIN | MASKING | PACKAGES | PASSWORD
           | PROJECTION | ROW ACCESS | SESSION } POLICY
         | TAG }
      | EXECUTE { ALERT | DATA METRIC FUNCTION | MANAGED ALERT | MANAGED TASK | TASK }
      | IMPORT { SHARE | ORGANIZATION LISTING }
      | MANAGE { ACCOUNT SUPPORT CASES | EVENT SHARING | GRANTS | LISTING AUTO FULFILLMENT | ORGANIZATION SUPPORT CASES | SHARE TARGET | USER SUPPORT CASES | WAREHOUSES }
      | MODIFY { LOG LEVEL | TRACE LEVEL | SESSION LOG LEVEL | SESSION TRACE LEVEL }
      | MONITOR { EXECUTION | SECURITY | USAGE }
      | OVERRIDE SHARE RESTRICTIONS | PURCHASE DATA EXCHANGE LISTING | RESOLVE ALL
      | READ SESSION
  }
  [ , ... ]

