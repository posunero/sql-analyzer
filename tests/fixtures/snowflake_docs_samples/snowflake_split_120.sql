-- Example 8021
SELECT 'HELP',
       BASE64_ENCODE('HELP'),
       BASE64_DECODE_STRING(BASE64_ENCODE('HELP')),
       TO_VARCHAR(b, 'BASE64'),
       BASE64_DECODE_STRING(TO_VARCHAR(b, 'BASE64'))
 FROM demo_binary_base64;

-- Example 8022
+--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------+
| 'HELP' | BASE64_ENCODE('HELP') | BASE64_DECODE_STRING(BASE64_ENCODE('HELP')) | TO_VARCHAR(B, 'BASE64') | BASE64_DECODE_STRING(TO_VARCHAR(B, 'BASE64')) |
|--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------|
| HELP   | SEVMUA==              | HELP                                        | SEVMUA==                | HELP                                          |
+--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------+

-- Example 8023
CREATE OR REPLACE TABLE demo_binary_utf8 (b BINARY);

-- Example 8024
INSERT INTO demo_binary_utf8 (b) SELECT TO_BINARY('HELP', 'UTF-8');

-- Example 8025
SELECT 'HELP',
       TO_VARCHAR(b, 'UTF-8')
  FROM demo_binary_utf8;

-- Example 8026
+--------+------------------------+
| 'HELP' | TO_VARCHAR(B, 'UTF-8') |
|--------+------------------------|
| HELP   | HELP                   |
+--------+------------------------+

-- Example 8027
CREATE OR REPLACE TABLE binary_table (v VARCHAR, b BINARY);

INSERT INTO binary_table (v, b)
  SELECT 'AB', TO_BINARY('AB');

SELECT v, b FROM binary_table;

-- Example 8028
+----+----+
| V  | B  |
|----+----|
| AB | AB |
+----+----+

-- Example 8029
CREATE OR REPLACE TABLE demo_binary_hex (b BINARY);

-- Example 8030
INSERT INTO demo_binary_hex (b) SELECT TO_BINARY('HELP', 'HEX');

-- Example 8031
100115 (22000): The following string is not a legal hex-encoded value: 'HELP'

-- Example 8032
INSERT INTO demo_binary_hex (b) SELECT TO_BINARY(HEX_ENCODE('HELP'), 'HEX');

-- Example 8033
SELECT TO_VARCHAR(b), HEX_DECODE_STRING(TO_VARCHAR(b)) FROM demo_binary_hex;

-- Example 8034
+---------------+----------------------------------+
| TO_VARCHAR(B) | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|---------------+----------------------------------|
| 48454C50      | HELP                             |
+---------------+----------------------------------+

-- Example 8035
SELECT 'HELP',
       HEX_ENCODE('HELP'),
       b,
       HEX_DECODE_STRING(HEX_ENCODE('HELP')),
       TO_VARCHAR(b),
       HEX_DECODE_STRING(TO_VARCHAR(b))
  FROM demo_binary_hex;

-- Example 8036
+--------+--------------------+----------+---------------------------------------+---------------+----------------------------------+
| 'HELP' | HEX_ENCODE('HELP') | B        | HEX_DECODE_STRING(HEX_ENCODE('HELP')) | TO_VARCHAR(B) | HEX_DECODE_STRING(TO_VARCHAR(B)) |
|--------+--------------------+----------+---------------------------------------+---------------+----------------------------------|
| HELP   | 48454C50           | 48454C50 | HELP                                  | 48454C50      | HELP                             |
+--------+--------------------+----------+---------------------------------------+---------------+----------------------------------+

-- Example 8037
CREATE OR REPLACE TABLE demo_binary_base64 (b BINARY);

-- Example 8038
INSERT INTO demo_binary_base64 (b) SELECT TO_BINARY(BASE64_ENCODE('HELP'), 'BASE64');

-- Example 8039
SELECT 'HELP',
       BASE64_ENCODE('HELP'),
       BASE64_DECODE_STRING(BASE64_ENCODE('HELP')),
       TO_VARCHAR(b, 'BASE64'),
       BASE64_DECODE_STRING(TO_VARCHAR(b, 'BASE64'))
 FROM demo_binary_base64;

-- Example 8040
+--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------+
| 'HELP' | BASE64_ENCODE('HELP') | BASE64_DECODE_STRING(BASE64_ENCODE('HELP')) | TO_VARCHAR(B, 'BASE64') | BASE64_DECODE_STRING(TO_VARCHAR(B, 'BASE64')) |
|--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------|
| HELP   | SEVMUA==              | HELP                                        | SEVMUA==                | HELP                                          |
+--------+-----------------------+---------------------------------------------+-------------------------+-----------------------------------------------+

-- Example 8041
CREATE OR REPLACE TABLE demo_binary_utf8 (b BINARY);

-- Example 8042
INSERT INTO demo_binary_utf8 (b) SELECT TO_BINARY('HELP', 'UTF-8');

-- Example 8043
SELECT 'HELP',
       TO_VARCHAR(b, 'UTF-8')
  FROM demo_binary_utf8;

-- Example 8044
+--------+------------------------+
| 'HELP' | TO_VARCHAR(B, 'UTF-8') |
|--------+------------------------|
| HELP   | HELP                   |
+--------+------------------------+

-- Example 8045
CREATE OR REPLACE SEQUENCE seq1;

SELECT seq1.NEXTVAL a, seq1.NEXTVAL b FROM DUAL;

-- Example 8046
CREATE OR REPLACE SEQUENCE seq1;

SELECT seqRef.a a, seqRef.a b FROM (SELECT seq1.NEXTVAL a FROM DUAL) seqRef;

-- Example 8047
CREATE OR REPLACE SEQUENCE seq1;

CREATE OR REPLACE TABLE foo (n NUMBER);

INSERT INTO foo VALUES (100), (101), (102);

SELECT n, s.nextval FROM foo, TABLE(GETNEXTVAL(seq1)) s;

-- Example 8048
CREATE OR REPLACE SEQUENCE seq1;

SELECT t1.*, t2.*, t3.*, t4.*, s.NEXTVAL FROM t1, t2, TABLE(GETNEXTVAL(seq1)) s, t3, t4;

-- Example 8049
CREATE OR REPLACE SEQUENCE seq1;

CREATE OR REPLACE TABLE foo (k NUMBER DEFAULT seq1.NEXTVAL, v NUMBER);

-- insert rows with unique keys (generated by seq1) and explicit values
INSERT INTO foo (v) VALUES (100);
INSERT INTO foo VALUES (DEFAULT, 101);

-- insert rows with unique keys (generated by seq1) and reused values.
-- new keys are distinct from preexisting keys.
INSERT INTO foo (v) SELECT v FROM foo;

-- insert row with explicit values for both columns
INSERT INTO foo VALUES (1000, 1001);

SELECT * FROM foo;

+------+------+
|    K |    V |
|------+------|
|    1 |  100 |
|    2 |  101 |
|    3 |  100 |
|    4 |  101 |
| 1000 | 1001 |
+------+------+

-- Example 8050
-- primary data tables

CREATE OR REPLACE TABLE people (id number, firstName string, lastName string);
CREATE OR REPLACE TABLE contact (id number, p_id number, c_type string, data string);

-- sequences to produce primary keys on our data tables

CREATE OR REPLACE SEQUENCE people_seq;
CREATE OR REPLACE SEQUENCE contact_seq;

-- staging table for json

CREATE OR REPLACE TABLE input (json variant);

-- Example 8051
INSERT INTO input SELECT parse_json(
'[
 {
   firstName : \'John\',
   lastName : \'Doe\',
   contacts : [
     {
       contactType : \'phone\',
       contactData : \'1234567890\',
     }
     ,
     {
       contactType : \'email\',
       contactData : \'jdoe@example.com\',
     }
    ]
   }
,
  {
   firstName : \'Mister\',
   lastName : \'Smith\',
   contacts : [
     {
       contactType : \'phone\',
       contactData : \'0987654321\',
     }
     ,
     {
       contactType : \'email\',
       contactData : \'msmith@example.com\',
     }
     ]
   }
 ,
   {
   firstName : \'George\',
   lastName : \'Washington\',
   contacts : [
     {
       contactType : \'phone\',
       contactData : \'1231231234\',
     }
     ,
     {
       contactType : \'email\',
       contactData : \'gwashington@example.com\',
     }
   ]
 }
]'
);

-- Example 8052
INSERT ALL
  WHEN 1=1 THEN
    INTO contact VALUES (c_next, p_next, contact_value:contactType, contact_value:contactData)
  WHEN contact_index = 0 THEN
    INTO people VALUES (p_next, person_value:firstName, person_value:lastName)

SELECT * FROM
(
  SELECT f1.value person_value, f2.value contact_value, f2.index contact_index, p_seq.NEXTVAL p_next, c_seq.NEXTVAL c_next
  FROM input, LATERAL FLATTEN(input.json) f1, TABLE(GETNEXTVAL(people_seq)) p_seq,
    LATERAL FLATTEN(f1.value:contacts) f2, table(GETNEXTVAL(contact_seq)) c_seq
);

-- Example 8053
SELECT * FROM people;

+----+-----------+------------+
| ID | FIRSTNAME | LASTNAME   |
|----+-----------+------------|
|  1 | John      | Doe        |
|  2 | Mister    | Smith      |
|  3 | George    | Washington |
+----+-----------+------------+

SELECT * FROM contact;

+----+------+--------+-------------------------+
| ID | P_ID | C_TYPE | DATA                    |
|----+------+--------+-------------------------|
|  1 |    1 | phone  | 1234567890              |
|  2 |    1 | email  | jdoe@example.com        |
|  3 |    2 | phone  | 0987654321              |
|  4 |    2 | email  | msmith@example.com      |
|  5 |    3 | phone  | 1231231234              |
|  6 |    3 | email  | gwashington@example.com |
+----+------+--------+-------------------------+

-- Example 8054
TRUNCATE TABLE input;

 INSERT INTO input SELECT PARSE_JSON(
 '[
  {
    firstName : \'Genghis\',
    lastName : \'Khan\',
    contacts : [
      {
        contactType : \'phone\',
        contactData : \'1111111111\',
      }
      ,
      {
        contactType : \'email\',
        contactData : \'gkahn@example.com\',
      }
   ]
 }
,
 {
    firstName : \'Julius\',
    lastName : \'Caesar\',
    contacts : [
      {
        contactType : \'phone\',
        contactData : \'2222222222\',
      }
      ,
      {
        contactType : \'email\',
        contactData : \'gcaesar@example.com\',
      }
    ]
  }
 ]'
 );

 INSERT ALL
   WHEN 1=1 THEN
     INTO contact VALUES (c_next, p_next, contact_value:contactType, contact_value:contactData)
   WHEN contact_index = 0 THEN
     INTO people VALUES (p_next, person_value:firstName, person_value:lastName)
 SELECT * FROM
 (
   SELECT f1.value person_value, f2.value contact_value, f2.index contact_index, p_seq.NEXTVAL p_next, c_seq.NEXTVAL c_next
   FROM input, LATERAL FLATTEN(input.json) f1, table(GETNEXTVAL(people_seq)) p_seq,
     LATERAL FLATTEN(f1.value:contacts) f2, table(GETNEXTVAL(contact_seq)) c_seq
 );

 SELECT * FROM people;

 +----+-----------+------------+
 | ID | FIRSTNAME | LASTNAME   |
 |----+-----------+------------|
 |  4 | Genghis   | Khan       |
 |  5 | Julius    | Caesar     |
 |  1 | John      | Doe        |
 |  2 | Mister    | Smith      |
 |  3 | George    | Washington |
 +----+-----------+------------+

 SELECT * FROM contact;

 +----+------+--------+-------------------------+
 | ID | P_ID | C_TYPE | DATA                    |
 |----+------+--------+-------------------------|
 |  1 |    1 | phone  | 1234567890              |
 |  2 |    1 | email  | jdoe@example.com        |
 |  3 |    2 | phone  | 0987654321              |
 |  4 |    2 | email  | msmith@example.com      |
 |  5 |    3 | phone  | 1231231234              |
 |  6 |    3 | email  | gwashington@example.com |
 |  7 |    4 | phone  | 1111111111              |
 |  8 |    4 | email  | gkahn@example.com       |
 |  9 |    5 | phone  | 2222222222              |
 | 10 |    5 | email  | gcaesar@example.com     |
 +----+------+--------+-------------------------+

-- Example 8055
CREATE OR REPLACE SEQUENCE test_sequence_wraparound_low
   START = 1
   INCREMENT = 1
   ;

CREATE or replace TABLE test_seq_wrap_low (
    i int,
    j int default test_sequence_wraparound_low.nextval
    );

-- Example 8056
INSERT INTO test_seq_wrap_low (i) VALUES
     (1),
     (2),
     (3);

-- Example 8057
SELECT * FROM test_seq_wrap_low ORDER BY i;
+---+---+
| I | J |
|---+---|
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
+---+---+

-- Example 8058
ALTER SEQUENCE test_sequence_wraparound_low SET INCREMENT = -4;

-- Example 8059
INSERT INTO test_seq_wrap_low (i) VALUES
    (4),
    (5);

-- Example 8060
SELECT * FROM test_seq_wrap_low ORDER BY i;
+---+---+
| I | J |
|---+---|
| 1 | 1 |
| 2 | 2 |
| 3 | 3 |
| 4 | 4 |
| 5 | 0 |
+---+---+

-- Example 8061
SELECT TO_TIMESTAMP('2019-02-28T23:59:59', 'YYYY-MM-DD"T"HH24:MI:SS');

-- Example 8062
SELECT TO_TIMESTAMP('2019-02-2823:59:59 -07:00', 'YYYY-MM-DD HH24:MI:SS TZH:TZM');

-- Example 8063
SELECT TO_TIMESTAMP('2019-02-28 23:59:59.000000000 -07:00', 'YYYY-MM-DDHH24:MI:SS.FF TZH:TZM');

-- Example 8064
SELECT TO_TIMESTAMP('1487654321');

-- Example 8065
+-------------------------------+
| TO_TIMESTAMP('1487654321')    |
|-------------------------------|
| 2017-02-21 05:18:41.000000000 |
+-------------------------------+

-- Example 8066
SELECT TO_TIMESTAMP('1487654321321');

-- Example 8067
+-------------------------------+
| TO_TIMESTAMP('1487654321321') |
|-------------------------------|
| 2017-02-21 05:18:41.321000000 |
+-------------------------------+

-- Example 8068
SELECT TO_TIMESTAMP(column1) FROM VALUES ('2013-04-05'), ('1487654321');

-- Example 8069
+-------------------------+
| TO_TIMESTAMP(COLUMN1)   |
|-------------------------|
| 2013-04-05 00:00:00.000 |
| 2017-02-21 05:18:41.000 |
+-------------------------+

-- Example 8070
TO_TIMESTAMP(<value>, '<format>')

-- Example 8071
TO_TIMESTAMP(TO_NUMBER(<string_column>), <scale>)

-- Example 8072
SELECT * FROM snowflake.account_usage.privacy_budgets
  WHERE policy_name='patients_policy' AND budget_name='analyst_budget';

-- Example 8073
SELECT *
  FROM TABLE(SNOWFLAKE.DATA_PRIVACY.CUMULATIVE_PRIVACY_LOSSES(
    'my_policy_db.my_policy_schema.my_policy_privacy'));

-- Example 8074
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts',
  BUDGET_LIMIT=>300,
  MAX_BUDGET_PER_AGGREGATE=>0.1);

-- Example 8075
ALTER PRIVACY POLICY users_policy SET BODY ->
  PRIVACY_BUDGET(BUDGET_NAME=>'analysts', BUDGET_WINDOW=>'daily');

-- Example 8076
CALL SNOWFLAKE.DATA_PRIVACY.RESET_PRIVACY_BUDGET(
  'my_policy_db.my_policy_schema.my_policy',
  'analyst_budget',
  'companyorg',
  'account_123');

-- Example 8077
{
    "Flood": flood_date_array::VARIANT,
    "Earthquake": earthquake_date_array::VARIANT,
    ...
}

-- Example 8078
[
    {
        "Event_ID": 54::VARIANT,
        "Type": "Earthquake"::VARIANT,
        "Magnitude": 7.4::VARIANT,
        "Timestamp": "2018-06-09 12:32:15"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT,
    {
        "Event_ID": 55::VARIANT,
        "Type": "Tornado"::VARIANT,
        "Maximum_wind_speed": 186::VARIANT,
        "Timestamp": "2018-07-01 09:42:55"::TIMESTAMP_LTZ::VARIANT
        ...
    }::VARIANT
]

-- Example 8079
CREATE TABLE my_table (my_variant_column VARIANT);
COPY INTO my_table ... FILE FORMAT = (TYPE = 'JSON') ...

-- Example 8080
INSERT INTO my_table (my_variant_column) SELECT PARSE_JSON('{...}');

-- Example 8081
SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  <message>,
  <integration_configuration> )

SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  ( <message>, [ <message>, ... ] ),
  <integration_configuration> )

SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  <message>,
  ( <integration_configuration> [ , <integration_configuration> , ... ] ) )

SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  ( <message> [ , <message> , ... ] ),
  ( <integration_configuration> [ , <integration_configuration> , ... ] ) )

-- Example 8082
{ "<content_type>": "<message_contents>" }

-- Example 8083
{ "text/html": "<p>A message</p>" }

-- Example 8084
{ "<integration_name>": {} }

-- Example 8085
{ "<integration_name>": { <options> } }

-- Example 8086
{ "subject" : "Service status update" }

-- Example 8087
{ "toAddress" : ["person_1@example.com", "person_2@example.com"] }

