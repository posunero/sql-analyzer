-- Example 7485
SELECT TO_TIMESTAMP_TZ('2024-04-05 01:02:03');

-- Example 7486
+----------------------------------------+
| TO_TIMESTAMP_TZ('2024-04-05 01:02:03') |
|----------------------------------------|
| 2024-04-05 01:02:03.000 -0700          |
+----------------------------------------+

-- Example 7487
SELECT TO_TIMESTAMP_NTZ('2024-04-05 01:02:03');

-- Example 7488
+-----------------------------------------+
| TO_TIMESTAMP_NTZ('2024-04-05 01:02:03') |
|-----------------------------------------|
| 2024-04-05 01:02:03.000                 |
+-----------------------------------------+

-- Example 7489
SELECT TO_TIMESTAMP_TZ('04/05/2024 01:02:03', 'mm/dd/yyyy hh24:mi:ss');

-- Example 7490
+-----------------------------------------------------------------+
| TO_TIMESTAMP_TZ('04/05/2024 01:02:03', 'MM/DD/YYYY HH24:MI:SS') |
|-----------------------------------------------------------------|
| 2024-04-05 01:02:03.000 -0700                                   |
+-----------------------------------------------------------------+

-- Example 7491
SELECT TO_TIMESTAMP_TZ('04/05/2024 01:02:03', 'dd/mm/yyyy hh24:mi:ss');

-- Example 7492
+-----------------------------------------------------------------+
| TO_TIMESTAMP_TZ('04/05/2024 01:02:03', 'DD/MM/YYYY HH24:MI:SS') |
|-----------------------------------------------------------------|
| 2024-05-04 01:02:03.000 -0700                                   |
+-----------------------------------------------------------------+

-- Example 7493
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF9 TZH:TZM';

-- Example 7494
SELECT TO_TIMESTAMP_NTZ(40 * 365.25 * 86400);

-- Example 7495
+---------------------------------------+
| TO_TIMESTAMP_NTZ(40 * 365.25 * 86400) |
|---------------------------------------|
| 2010-01-01 00:00:00.000               |
+---------------------------------------+

-- Example 7496
SELECT TO_TIMESTAMP_NTZ(40 * 365.25 * 86400 * 1000 + 456, 3);

-- Example 7497
+-------------------------------------------------------+
| TO_TIMESTAMP_NTZ(40 * 365.25 * 86400 * 1000 + 456, 3) |
|-------------------------------------------------------|
| 2010-01-01 00:00:00.456                               |
+-------------------------------------------------------+

-- Example 7498
SELECT TO_TIMESTAMP(1000000000, 0) AS "Scale in seconds",
       TO_TIMESTAMP(1000000000, 3) AS "Scale in milliseconds",
       TO_TIMESTAMP(1000000000, 6) AS "Scale in microseconds",
       TO_TIMESTAMP(1000000000, 9) AS "Scale in nanoseconds";

-- Example 7499
+-------------------------+-------------------------+-------------------------+-------------------------+
| Scale in seconds        | Scale in milliseconds   | Scale in microseconds   | Scale in nanoseconds    |
|-------------------------+-------------------------+-------------------------+-------------------------|
| 2001-09-09 01:46:40.000 | 1970-01-12 13:46:40.000 | 1970-01-01 00:16:40.000 | 1970-01-01 00:00:01.000 |
+-------------------------+-------------------------+-------------------------+-------------------------+

-- Example 7500
CREATE OR REPLACE TABLE demo1 (
  description VARCHAR,
  value VARCHAR -- string rather than bigint
);

INSERT INTO demo1 (description, value) VALUES
  ('Seconds',      '31536000'),
  ('Milliseconds', '31536000000'),
  ('Microseconds', '31536000000000'),
  ('Nanoseconds',  '31536000000000000');

-- Example 7501
SELECT description,
       value,
       TO_TIMESTAMP(value),
       TO_DATE(value)
  FROM demo1
  ORDER BY value;

-- Example 7502
+--------------+-------------------+-------------------------+----------------+
| DESCRIPTION  | VALUE             | TO_TIMESTAMP(VALUE)     | TO_DATE(VALUE) |
|--------------+-------------------+-------------------------+----------------|
| Seconds      | 31536000          | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Milliseconds | 31536000000       | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Microseconds | 31536000000000    | 1971-01-01 00:00:00.000 | 1971-01-01     |
| Nanoseconds  | 31536000000000000 | 1971-01-01 00:00:00.000 | 1971-01-01     |
+--------------+-------------------+-------------------------+----------------+

-- Example 7503
SELECT 0::TIMESTAMP_NTZ, PARSE_JSON(0)::TIMESTAMP_NTZ, PARSE_JSON(0)::INT::TIMESTAMP_NTZ;

-- Example 7504
+-------------------------+------------------------------+-----------------------------------+
| 0::TIMESTAMP_NTZ        | PARSE_JSON(0)::TIMESTAMP_NTZ | PARSE_JSON(0)::INT::TIMESTAMP_NTZ |
|-------------------------+------------------------------+-----------------------------------|
| 1970-01-01 00:00:00.000 | 1969-12-31 16:00:00.000      | 1970-01-01 00:00:00.000           |
+-------------------------+------------------------------+-----------------------------------+

-- Example 7505
SELECT TO_TIMESTAMP_NTZ(0), TO_TIMESTAMP_NTZ(PARSE_JSON(0)), TO_TIMESTAMP_NTZ(PARSE_JSON(0)::INT);

-- Example 7506
+-------------------------+---------------------------------+--------------------------------------+
| TO_TIMESTAMP_NTZ(0)     | TO_TIMESTAMP_NTZ(PARSE_JSON(0)) | TO_TIMESTAMP_NTZ(PARSE_JSON(0)::INT) |
|-------------------------+---------------------------------+--------------------------------------|
| 1970-01-01 00:00:00.000 | 1969-12-31 16:00:00.000         | 1970-01-01 00:00:00.000              |
+-------------------------+---------------------------------+--------------------------------------+

-- Example 7507
TO_VARIANT( <expr> )

-- Example 7508
CREATE OR REPLACE TABLE to_variant_example (
  v_varchar   VARIANT,
  v_number    VARIANT,
  v_timestamp VARIANT,
  v_array     VARIANT,
  v_object    VARIANT);

INSERT INTO to_variant_example (v_varchar, v_number, v_timestamp, v_array, v_object)
  SELECT
    TO_VARIANT('Skiing is fun!'),
    TO_VARIANT(3.14),
    TO_VARIANT('2024-01-25 01:02:03'),
    TO_VARIANT(ARRAY_CONSTRUCT('San Mateo', 'Seattle', 'Berlin')),
    PARSE_JSON(' { "key1": "value1", "key2": "value2" } ');

SELECT * FROM to_variant_example;

-- Example 7509
+------------------+----------+-----------------------+----------------+---------------------+
| V_VARCHAR        | V_NUMBER | V_TIMESTAMP           | V_ARRAY        | V_OBJECT            |
|------------------+----------+-----------------------+----------------+---------------------|
| "Skiing is fun!" | 3.14     | "2024-01-25 01:02:03" | [              | {                   |
|                  |          |                       |   "San Mateo", |   "key1": "value1", |
|                  |          |                       |   "Seattle",   |   "key2": "value2"  |
|                  |          |                       |   "Berlin"     | }                   |
|                  |          |                       | ]              |                     |
+------------------+----------+-----------------------+----------------+---------------------+

-- Example 7510
TO_XML( <expression> )

-- Example 7511
<SnowflakeData type="OBJECT"> </SnowflakeData>

-- Example 7512
<key1 type="VARCHAR">value1</key1>

-- Example 7513
<e type="VARCHAR"> </e>

-- Example 7514
<SnowflakeData type="OBJECT">
    <key1 type="VARCHAR">value1</key1>
    <key2 type="VARCHAR">value2</key2>
</SnowflakeData>

-- Example 7515
<SnowflakeData type="ARRAY">
    <e type="VARCHAR">v1</e>
    <e type="VARCHAR">v2</e>
</SnowflakeData>

-- Example 7516
CREATE OR REPLACE TABLE xml_02 (x OBJECT);

INSERT INTO xml_02 (x)
  SELECT PARSE_XML('<note> <body>Sample XML</body> </note>');

-- Example 7517
SELECT x, TO_VARCHAR(x), TO_XML(x) FROM xml_02;

-- Example 7518
+---------------------------+--------------------------------------+--------------------------------------+
| X                         | TO_VARCHAR(X)                        | TO_XML(X)                            |
|---------------------------+--------------------------------------+--------------------------------------|
| <note>                    | <note><body>Sample XML</body></note> | <note><body>Sample XML</body></note> |
|   <body>Sample XML</body> |                                      |                                      |
| </note>                   |                                      |                                      |
+---------------------------+--------------------------------------+--------------------------------------+

-- Example 7519
CREATE OR REPLACE TABLE xml_03 (object_col_1 OBJECT);

INSERT INTO xml_03 (object_col_1)
  SELECT OBJECT_CONSTRUCT('key1', 'value1', 'key2', 'value2');

-- Example 7520
SELECT object_col_1, TO_XML(object_col_1)
  FROM xml_03;

-- Example 7521
+---------------------+-------------------------------------------------------------------------------------------------------------------+
| OBJECT_COL_1        | TO_XML(OBJECT_COL_1)                                                                                              |
|---------------------+-------------------------------------------------------------------------------------------------------------------|
| {                   | <SnowflakeData type="OBJECT"><key1 type="VARCHAR">value1</key1><key2 type="VARCHAR">value2</key2></SnowflakeData> |
|   "key1": "value1", |                                                                                                                   |
|   "key2": "value2"  |                                                                                                                   |
| }                   |                                                                                                                   |
+---------------------+-------------------------------------------------------------------------------------------------------------------+

-- Example 7522
CREATE OR REPLACE TABLE xml_04 (array_col_1 ARRAY);

INSERT INTO xml_04 (array_col_1)
  SELECT ARRAY_CONSTRUCT('v1', 'v2');

-- Example 7523
SELECT array_col_1, TO_XML(array_col_1)
  FROM xml_04;

-- Example 7524
+-------------+----------------------------------------------------------------------------------------------+
| ARRAY_COL_1 | TO_XML(ARRAY_COL_1)                                                                          |
|-------------+----------------------------------------------------------------------------------------------|
| [           | <SnowflakeData type="ARRAY"><e type="VARCHAR">v1</e><e type="VARCHAR">v2</e></SnowflakeData> |
|   "v1",     |                                                                                              |
|   "v2"      |                                                                                              |
| ]           |                                                                                              |
+-------------+----------------------------------------------------------------------------------------------+

-- Example 7525
CREATE OR REPLACE TABLE xml_05 (json_col_1 VARIANT);

INSERT INTO xml_05 (json_col_1)
  SELECT PARSE_JSON(' { "key1": ["a1", "a2"] } ');

-- Example 7526
SELECT json_col_1,
       TO_JSON(json_col_1),
       TO_XML(json_col_1)
  FROM xml_05;

-- Example 7527
+-------------+----------------------+-------------------------------------------------------------------------------------------------------------------------+
| JSON_COL_1  | TO_JSON(JSON_COL_1)  | TO_XML(JSON_COL_1)                                                                                                      |
|-------------+----------------------+-------------------------------------------------------------------------------------------------------------------------|
| {           | {"key1":["a1","a2"]} | <SnowflakeData type="OBJECT"><key1 type="ARRAY"><e type="VARCHAR">a1</e><e type="VARCHAR">a2</e></key1></SnowflakeData> |
|   "key1": [ |                      |                                                                                                                         |
|     "a1",   |                      |                                                                                                                         |
|     "a2"    |                      |                                                                                                                         |
|   ]         |                      |                                                                                                                         |
| }           |                      |                                                                                                                         |
+-------------+----------------------+-------------------------------------------------------------------------------------------------------------------------+

-- Example 7528
TRANSFORM( <array> , <lambda_expression> )

-- Example 7529
<arg> [ <datatype> ] -> <expr>

-- Example 7530
SELECT TRANSFORM([1, 2, 3], a INT -> a * 2) AS "Multiply by Two";

-- Example 7531
+-----------------+
| Multiply by Two |
|-----------------|
| [               |
|   2,            |
|   4,            |
|   6             |
| ]               |
+-----------------+

-- Example 7532
SELECT TRANSFORM([1, 2, 3]::ARRAY(INT), a INT -> a * 2) AS "Multiply by Two (Structured)";

-- Example 7533
+------------------------------+
| Multiply by Two (Structured) |
|------------------------------|
| [                            |
|   2,                         |
|   4,                         |
|   6                          |
| ]                            |
+------------------------------+

-- Example 7534
SELECT TRANSFORM(
  [
    {'name':'Pat', 'value': 50},
    {'name':'Terry', 'value': 75},
    {'name':'Dana', 'value': 25}
  ],
  c -> c:value || ' is the number') AS "Return Values";

-- Example 7535
+-----------------------+
| Return Values         |
|-----------------------|
| [                     |
|   "50 is the number", |
|   "75 is the number", |
|   "25 is the number"  |
| ]                     |
+-----------------------+

-- Example 7536
CREATE OR REPLACE TABLE orders AS
  SELECT 1 AS order_id, '2024-01-01' AS order_date, [
    {'item':'UHD Monitor', 'quantity':3, 'subtotal':1500},
    {'item':'Business Printer', 'quantity':1, 'subtotal':1200}
  ] AS order_detail
  UNION SELECT 2 AS order_id, '2024-01-02' AS order_date, [
    {'item':'Laptop', 'quantity':5, 'subtotal':7500},
    {'item':'Noise-canceling Headphones', 'quantity':5, 'subtotal':1000}
  ] AS order_detail;

SELECT * FROM orders;

-- Example 7537
+----------+------------+-------------------------------------------+
| ORDER_ID | ORDER_DATE | ORDER_DETAIL                              |
|----------+------------+-------------------------------------------|
|        1 | 2024-01-01 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "UHD Monitor",                |
|          |            |     "quantity": 3,                        |
|          |            |     "subtotal": 1500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Business Printer",           |
|          |            |     "quantity": 1,                        |
|          |            |     "subtotal": 1200                      |
|          |            |   }                                       |
|          |            | ]                                         |
|        2 | 2024-01-02 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "Laptop",                     |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 7500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Noise-canceling Headphones", |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 1000                      |
|          |            |   }                                       |
|          |            | ]                                         |
+----------+------------+-------------------------------------------+

-- Example 7538
SELECT order_id,
       order_date,
       TRANSFORM(o.order_detail, i -> OBJECT_INSERT(
         i,
         'unit_price',
         (i:subtotal / i:quantity)::NUMERIC(10,2))) ORDER_DETAIL_WITH_UNIT_PRICE
  FROM orders o;

-- Example 7539
+----------+------------+-------------------------------------------+
| ORDER_ID | ORDER_DATE | ORDER_DETAIL_WITH_UNIT_PRICE              |
|----------+------------+-------------------------------------------|
|        1 | 2024-01-01 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "UHD Monitor",                |
|          |            |     "quantity": 3,                        |
|          |            |     "subtotal": 1500,                     |
|          |            |     "unit_price": 500                     |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Business Printer",           |
|          |            |     "quantity": 1,                        |
|          |            |     "subtotal": 1200,                     |
|          |            |     "unit_price": 1200                    |
|          |            |   }                                       |
|          |            | ]                                         |
|        2 | 2024-01-02 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "Laptop",                     |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 7500,                     |
|          |            |     "unit_price": 1500                    |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Noise-canceling Headphones", |
|          |            |     "quantity": 5,                        |
|          |            |     "subtotal": 1000,                     |
|          |            |     "unit_price": 200                     |
|          |            |   }                                       |
|          |            | ]                                         |
+----------+------------+-------------------------------------------+

-- Example 7540
SELECT order_id,
       order_date,
       TRANSFORM(o.order_detail, i -> OBJECT_DELETE(
         i,
         'quantity')) ORDER_DETAIL_WITHOUT_QUANTITY
  FROM orders o;

-- Example 7541
+----------+------------+-------------------------------------------+
| ORDER_ID | ORDER_DATE | ORDER_DETAIL_WITHOUT_QUANTITY             |
|----------+------------+-------------------------------------------|
|        1 | 2024-01-01 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "UHD Monitor",                |
|          |            |     "subtotal": 1500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Business Printer",           |
|          |            |     "subtotal": 1200                      |
|          |            |   }                                       |
|          |            | ]                                         |
|        2 | 2024-01-02 | [                                         |
|          |            |   {                                       |
|          |            |     "item": "Laptop",                     |
|          |            |     "subtotal": 7500                      |
|          |            |   },                                      |
|          |            |   {                                       |
|          |            |     "item": "Noise-canceling Headphones", |
|          |            |     "subtotal": 1000                      |
|          |            |   }                                       |
|          |            | ]                                         |
+----------+------------+-------------------------------------------+

-- Example 7542
SNOWFLAKE.CORTEX.TRANSLATE(
    <text>, <source_language>, <target_language>)

-- Example 7543
SELECT SNOWFLAKE.CORTEX.TRANSLATE(review_content, 'en', 'de') FROM reviews LIMIT 10;

-- Example 7544
SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'Hit the slopes with Snowflake\'s latest innovation - "Skii Headphones" designed to keep your ears warm and your soul ablaze. Engineered specifically for snow weather, these rugged headphones combine crystal-clear sound with thermally-insulated ear cups to keep the chill out and the beats in. Whether you\'re carving through powder or cruising down groomers, Skii Headphones will fuel your mountain adventures with vibrant sound and unrelenting passion. Stay warm, stay fired up, and shred the mountain with Snowflake Skii Headphones',
'en','es');

-- Example 7545
Sube a las pistas con la última innovación de Snowflake: "Skii Headphones", diseñados para mantener tus oídos calientes y tu alma encendida. Diseñados específicamente para el clima de nieve, estos audífonos resistentes combinan un sonido cristalino con copas de oído aisladas térmicamente para mantener el frío fuera y los ritmos dentro. Ya sea que estés esculpiendo en polvo o deslizándote por pistas preparadas, los Skii Headphones alimentarán tus aventuras en la montaña con un sonido vibrante y una pasión incesante. Mantente caliente, mantente encendido y arrasa la montaña con los Skii Headphones de Snowflake.

-- Example 7546
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

-- Example 7547
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

-- Example 7548
SELECT SNOWFLAKE.CORTEX.TRANSLATE ('Voy a likear tus fotos en Insta.', '', 'en')

-- Example 7549
I'm going to like your photos on Insta.

-- Example 7550
TRANSLATE( <subject>, <sourceAlphabet>, <targetAlphabet> )

-- Example 7551
String '(target alphabet)' is too long and would be truncated.

