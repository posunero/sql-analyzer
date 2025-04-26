-- Example 29720
ALTER TASK <name> SET SUCCESS_INTEGRATION = <integration_name>;

-- Example 29721
{"version":"1.0",
 "messageId":"3ff1eff0-7ad7-493c-9552-c0307087e0c6",
 "messageType":"GRAPH_SUCCEEDED",
 "timestamp":"2021-11-11T19:46:39.648Z",
 "accountName":"XY12345",
 "rootTaskName":"AWS_UTEN_DPO_DB.AWS_UTEN_SC.UTEN_AWS_TK1",
 "rootTaskId":"01a03962-2b57-889e-0000-000000000001",
 "messages": [{
              "runId":"2021-11-11T19:46:23.826Z",
              "scheduledTime":"2021-11-11T19:46:23.826Z",
              "queryStartTime":"2021-11-11T19:46:24.879Z",
              "graphCompletedTime":"2021-11-11T19:54:24.5591",
              "queryId":"01a03962-0300-0002-0000-0000000034d8",
              "attemptNumber":5
}]}

-- Example 29722
SELECT * FROM snowflake.monitoring.iceberg_access_errors
  WHERE EXTERNAL_VOLUME_NAME ILIKE 'my_s3_external_volume';

-- Example 29723
SELECT * FROM snowflake.monitoring.iceberg_access_errors
  WHERE EXTERNAL_VOLUME_NAME ILIKE 'my_external_volume'
  AND CREATED_ON > DATEADD(HOUR, -1, CURRENT_TIMESTAMP());

-- Example 29724
use role useradmin;
CREATE ROLE masking_admin;

-- Example 29725
use role securityadmin;
GRANT CREATE MASKING POLICY on SCHEMA <db_name.schema_name> to ROLE masking_admin;
GRANT APPLY MASKING POLICY on ACCOUNT to ROLE masking_admin;

-- Example 29726
GRANT APPLY ON MASKING POLICY ssn_mask to ROLE table_owner;

-- Example 29727
GRANT ROLE masking_admin TO USER jsmith;

-- Example 29728
CREATE OR REPLACE MASKING POLICY email_mask AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '*********'
  END;

-- Example 29729
-- apply masking policy to a table column

ALTER TABLE IF EXISTS user_info MODIFY COLUMN email SET MASKING POLICY email_mask;

-- apply the masking policy to a view column

ALTER VIEW user_info_v MODIFY COLUMN email SET MASKING POLICY email_mask;

-- Example 29730
-- using the ANALYST role

USE ROLE analyst;
SELECT email FROM user_info; -- should see plain text value

-- using the PUBLIC role

USE ROLE PUBLIC;
SELECT email FROM user_info; -- should see full data mask

-- Example 29731
+----------+-------------+---------------+
| USERNAME |     ID      | PHONE_NUMBER  |
+----------+-------------+---------------+
| JSMITH   | 12-3456-89  | 1555-523-8790 |
| AJONES   | 12-0124-32  | 1555-125-1548 |
+----------+-------------+---------------+

-- Example 29732
+---------------+---------------+
| ROLE          | IS_AUTHORIZED |
+---------------+---------------+
| DATA_ENGINEER | TRUE          |
| DATA_STEWARD  | TRUE          |
| IT_ADMIN      | TRUE          |
| PUBLIC        | FALSE         |
+---------------+---------------+

-- Example 29733
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

-- Example 29734
SELECT is_role_authorized(IT_ADMIN);

-- Example 29735
+---------------------------------------------+
|         is_role_authorized(IT_ADMIN)        |
+---------------------------------------------+
|                    TRUE                     |
+---------------------------------------------+

-- Example 29736
CREATE OR REPLACE MASKING POLICY empl_id_mem_mask
AS (val VARCHAR) RETURNS VARCHAR ->
CASE
  WHEN is_role_authorized(CURRENT_ROLE()) THEN val
  ELSE NULL
END;

-- Example 29737
ALTER TABLE employee_data MODIFY COLUMN id
  SET MASKING POLICY empl_id_mem_mask;

-- Example 29738
USE ROLE data_engineer;
SELECT * FROM employee_data;

-- Example 29739
case
  when current_account() in ('<prod_account_identifier>') then val
  else '*********'
end;

-- Example 29740
case
  when current_role() IN ('ANALYST') then val
  else NULL
end;

-- Example 29741
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE '********'
END;

-- Example 29742
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE sha2(val) -- return hash of the column value
END;

-- Example 29743
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  WHEN current_role() IN ('SUPPORT') THEN regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  ELSE '********'
END;

-- Example 29744
case
  WHEN current_role() in ('SUPPORT') THEN val
  else date_from_parts(0001, 01, 01)::timestamp_ntz -- returns 0001-01-01 00:00:00.000
end;

-- Example 29745
CASE
  WHEN current_role() IN ('ANALYST') THEN val
  ELSE mask_udf(val) -- custom masking function
END;

-- Example 29746
CASE
   WHEN current_role() IN ('ANALYST') THEN val
   ELSE OBJECT_INSERT(val, 'USER_IPADDRESS', '****', true)
END;

-- Example 29747
CASE
  WHEN EXISTS
    (SELECT role FROM <db>.<schema>.entitlement WHERE mask_method='unmask' AND role = current_role()) THEN val
  ELSE '********'
END;

-- Example 29748
case
  when current_role() in ('ANALYST') then DECRYPT(val, $passphrase)
  else val -- shows encrypted value
end;

-- Example 29749
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

-- Example 29750
create masking policy mask_geo_point as (val geography) returns geography ->
  case
    when current_role() IN ('ANALYST') then val
    else to_geography('POINT(-122.35 37.55)')
  end;

-- Example 29751
alter table mydb.myschema.geography modify column b set masking policy mask_geo_point;
alter session set geography_output_format = 'GeoJSON';
use role public;
select * from mydb.myschema.geography;

-- Example 29752
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

-- Example 29753
alter session set geography_output_format = 'WKT';
select * from mydb.myschema.geography;

---+----------------------+
 A |         B            |
---+----------------------+
 1 | POINT(-122.35 37.55) |
 2 | POINT(-122.35 37.55) |
---+----------------------+

-- Example 29754
CREATE APPLICATION PACKAGE HelloSnowflakePackage;

-- Example 29755
GRANT MANAGE RELEASES ON APPLICATION PACKAGE hello_snowflake_package TO ROLE app_release_mgr;

-- Example 29756
GRANT OWNERSHIP ON APPLICATION PACKAGE hello_snowflake_package TO ROLE native_app_dev;

-- Example 29757
DROP APPLICATION PACKAGE hello_snowflake_package;

-- Example 29758
SNOWFLAKE.CORTEX.TRANSLATE(
    <text>, <source_language>, <target_language>)

-- Example 29759
SELECT SNOWFLAKE.CORTEX.TRANSLATE(review_content, 'en', 'de') FROM reviews LIMIT 10;

-- Example 29760
SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'Hit the slopes with Snowflake\'s latest innovation - "Skii Headphones" designed to keep your ears warm and your soul ablaze. Engineered specifically for snow weather, these rugged headphones combine crystal-clear sound with thermally-insulated ear cups to keep the chill out and the beats in. Whether you\'re carving through powder or cruising down groomers, Skii Headphones will fuel your mountain adventures with vibrant sound and unrelenting passion. Stay warm, stay fired up, and shred the mountain with Snowflake Skii Headphones',
'en','es');

-- Example 29761
Sube a las pistas con la última innovación de Snowflake: "Skii Headphones", diseñados para mantener tus oídos calientes y tu alma encendida. Diseñados específicamente para el clima de nieve, estos audífonos resistentes combinan un sonido cristalino con copas de oído aisladas térmicamente para mantener el frío fuera y los ritmos dentro. Ya sea que estés esculpiendo en polvo o deslizándote por pistas preparadas, los Skii Headphones alimentarán tus aventuras en la montaña con un sonido vibrante y una pasión incesante. Mantente caliente, mantente encendido y arrasa la montaña con los Skii Headphones de Snowflake.

-- Example 29762
SELECT SNOWFLAKE.CORTEX.TRANSLATE
  ('Kunde: Hallo
    Agent: Hallo, ich hoffe, es geht Ihnen gut. Um Ihnen am besten helfen zu können, teilen Sie bitte Ihren Vor- und Nachnamen und den Namen der Firma, von der aus Sie anrufen.
    Kunde: Ja, hier ist Thomas Müller von SkiPisteExpress.
    Agent: Danke Thomas, womit kann ich Ihnen heute helfen?
    Kunde: Also wir haben die XtremeX Helme in Größe M bestellt, die wir speziell für die kommende Wintersaison benötigen. Jedoch sind alle Schnallen der Helme defekt, und keiner schließt richtig.
    Agent: Ich verstehe, dass das ein Problem für Ihr Geschäft sein kann. Lassen Sie mich überprüfen, was mit Ihrer Bestellung passiert ist. Um zu bestätigen: Ihre Bestellung endet mit der Nummer 56682?
    Kunde: Ja, das ist meine Bestellung.
    Agent: Ich sehe das Problem. Entschuldigen Sie die Unannehmlichkeiten. Ich werde sofort eine neue Lieferung mit reparierten Schnallen für Sie vorbereiten, die in drei Tagen bei Ihnen eintreffen sollte. Ist das in Ordnung für Sie?
    Kunde: Drei Tage sind ziemlich lang, ich hatte gehofft, diese Helme früher zu erhalten. Gibt es irgendeine Möglichkeit, die Lieferung zu beschleunigen?
    Agent: Ich verstehe Ihre Dringlichkeit. Ich werde mein Bestes tun, um die Lieferung auf zwei Tage zu beschleunigen. Wie kommst du damit zurecht?
    Kunde: Das wäre großartig, ich wäre Ihnen sehr dankbar.
    Agent: Kein Problem, Thomas. Ich kümmere mich um die eilige Lieferung. Danke für Ihr Verständnis und Ihre Geduld.
    Kunde: Vielen Dank für Ihre Hilfe. Auf Wiedersehen!
    Agent: Bitte, gerne geschehen. Auf Wiedersehen und einen schönen Tag noch!'
,'de','en');

-- Example 29763
Customer: Hello
Agent: Hello, I hope you are well. To best assist you, please share your first and last name and the name of the company you are calling from.
Customer: Yes, this is Thomas Müller from SkiPisteExpress.
Agent: Thank you, Thomas, what can I help you with today?
Customer: So, we ordered the XtremeX helmets in size M, which we specifically need for the upcoming winter season. However, all the buckles on the helmets are defective and none of them close properly.
Agent: I understand that this can be a problem for your business. Let me check what happened with your order. To confirm: your order ends with the number 56682?
Customer: Yes, that's my order.
Agent: I see the issue. I apologize for the inconvenience. I will prepare a new delivery with repaired buckles for you immediately, which should arrive in three days. Is that okay for you?
Customer: Three days is quite a long time; I was hoping to receive these helmets sooner. Is there any way to expedite the delivery?
Agent: I understand your urgency. I will do my best to expedite the delivery to two days. How does that sound?
Customer: That would be great, I would be very grateful.
Agent: No problem, Thomas. I will take care of the urgent delivery. Thank you for your understanding and patience.
Customer: Thank you very much for your help. Goodbye!
Agent: You're welcome. Goodbye and have a nice day!

-- Example 29764
SELECT SNOWFLAKE.CORTEX.TRANSLATE ('Voy a likear tus fotos en Insta.', '', 'en')

-- Example 29765
I'm going to like your photos on Insta.

-- Example 29766
-- Find the UUID of the clean room
SELECT * FROM samooha_by_snowflake_local_db.public.cleanroom_record;

-- Replace <uuid> with the UUID of the clean room to find the tables that contain the PAIR IDs
-- Names of tables with PAIR IDs are appended with _PAIR
DESCRIBE SCHEMA samooha_cleanroom_<uuid>.shared_schema;

-- Query the table with PAIR IDs
SELECT * samooha_cleanroom_<uuid>.shared_schema.<tablename_PAIR>;

-- Example 29767
USE DATABASE doc_ai_db;
USE SCHEMA doc_ai_schema;

-- Example 29768
GRANT OWNERSHIP ON TASK mytask TO ROLE myrole;
GRANT DATABASE ROLE USAGE_VIEWER TO ROLE myrole;

-- Example 29769
SELECT ...
  FROM ...
  [ ... ]
  GROUP BY groupItem [ , groupItem [ , ... ] ]
  [ ... ]

-- Example 29770
SELECT ...
  FROM ...
  [ ... ]
  GROUP BY ALL
  [ ... ]

-- Example 29771
groupItem ::= { <column_alias> | <position> | <expr> }

-- Example 29772
SELECT SUM(amount)
  FROM mytable
  GROUP BY ALL;

-- Example 29773
SELECT SUM(amount)
  FROM mytable;

-- Example 29774
CREATE TABLE sales (
  product_ID INTEGER,
  retail_price REAL,
  quantity INTEGER,
  city VARCHAR,
  state VARCHAR);

INSERT INTO sales (product_id, retail_price, quantity, city, state) VALUES
  (1, 2.00,  1, 'SF', 'CA'),
  (1, 2.00,  2, 'SJ', 'CA'),
  (2, 5.00,  4, 'SF', 'CA'),
  (2, 5.00,  8, 'SJ', 'CA'),
  (2, 5.00, 16, 'Miami', 'FL'),
  (2, 5.00, 32, 'Orlando', 'FL'),
  (2, 5.00, 64, 'SJ', 'PR');

CREATE TABLE products (
  product_ID INTEGER,
  wholesale_price REAL);
INSERT INTO products (product_ID, wholesale_price) VALUES (1, 1.00);
INSERT INTO products (product_ID, wholesale_price) VALUES (2, 2.00);

-- Example 29775
SELECT product_ID, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY product_ID;

-- Example 29776
+------------+---------------+
| PRODUCT_ID | GROSS_REVENUE |
+============+===============+
|          1 |          6    |
+------------+---------------+
|          2 |        620    |
+------------+---------------+

-- Example 29777
SELECT p.product_ID, SUM((s.retail_price - p.wholesale_price) * s.quantity) AS profit
  FROM products AS p, sales AS s
  WHERE s.product_ID = p.product_ID
  GROUP BY p.product_ID;

-- Example 29778
+------------+--------+
| PRODUCT_ID | PROFIT |
+============+========+
|          1 |      3 |
+------------+--------+
|          2 |    372 |
+------------+--------+

-- Example 29779
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY state, city;

-- Example 29780
+-------+---------+---------------+
| STATE |   CITY  | GROSS REVENUE |
+=======+=========+===============+
|   CA  | SF      |            22 |
+-------+---------+---------------+
|   CA  | SJ      |            44 |
+-------+---------+---------------+
|   FL  | Miami   |            80 |
+-------+---------+---------------+
|   FL  | Orlando |           160 |
+-------+---------+---------------+
|   PR  | SJ      |           320 |
+-------+---------+---------------+

-- Example 29781
SELECT state, city, SUM(retail_price * quantity) AS gross_revenue
  FROM sales
  GROUP BY ALL;

-- Example 29782
+-------+---------+---------------+
| STATE |   CITY  | GROSS REVENUE |
+=======+=========+===============+
|   CA  | SF      |            22 |
+-------+---------+---------------+
|   CA  | SJ      |            44 |
+-------+---------+---------------+
|   FL  | Miami   |            80 |
+-------+---------+---------------+
|   FL  | Orlando |           160 |
+-------+---------+---------------+
|   PR  | SJ      |           320 |
+-------+---------+---------------+

-- Example 29783
SELECT x, some_expression AS x
  FROM ...

-- Example 29784
Create table employees (salary float, state varchar, employment_state varchar);
insert into employees (salary, state, employment_state) values
    (60000, 'California', 'Active'),
    (70000, 'California', 'On leave'),
    (80000, 'Oregon', 'Active');

-- Example 29785
select sum(salary), ANY_VALUE(employment_state)
    from employees
    group by employment_state;
+-------------+-----------------------------+
| SUM(SALARY) | ANY_VALUE(EMPLOYMENT_STATE) |
|-------------+-----------------------------|
|      140000 | Active                      |
|       70000 | On leave                    |
+-------------+-----------------------------+

-- Example 29786
select sum(salary), ANY_VALUE(employment_state) as state
    from employees
    group by state;
+-------------+--------+
| SUM(SALARY) | STATE  |
|-------------+--------|
|      130000 | Active |
|       80000 | Active |
+-------------+--------+

