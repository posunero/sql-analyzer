-- Example 8088
{ "ccAddress" : ["person_to_cc1@example.com", "person_to_cc2@example.com"] }

-- Example 8089
{ "bccAddress" : ["person_to_bcc1@example.com", "person_to_bcc2@example.com"] }

-- Example 8090
{ "my_queue_int": {} }

-- Example 8091
{ "my_email_int": { "subject" : "Different subject" } }

-- Example 8092
{ "my_email_int": { "subject" : "Different subject" }, { "toAddress": ["person_a@example.com"] }

-- Example 8093
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
   -- Message type and content.
  '{ "text/html": "<p>This is a message.</p>" }',
  -- Integration used to send the notification and values used for the subject and recipients.
  -- These values override the defaults specified in the integration.
  '{
    "my_email_int": {
      "subject": "Status update",
      "toAddress": ["person_a@example.com", "person_b@example.com"],
      "ccAddress": ["person_c@example.com"],
      "bccAddress": ["person_d@example.com"]
    }
  }'
);

-- Example 8094
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>a message</p>'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int',
    'Status update',
    ARRAY_CONSTRUCT('person_a@example.com', 'person_b@example.com'),
    ARRAY_CONSTRUCT('person_c@example.com'),
    ARRAY_CONSTRUCT('person_d@example.com')
  )
);

-- Example 8095
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{ "text/html": "<p>This is a message.</p>" }',
  '{
    "my_email_int": {
      "subject": "Status update",
      "toAddress": ["person_a@example.com", "person_b@example.com"],
      "ccAddress": ["person_c@example.com"],
      "bccAddress": ["person_d@example.com"]
    }
  }'
);

-- Example 8096
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('Your message'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int,
    'Service down',
    ARRAY_CONSTRUCT('oncall-a@example.com', 'oncall-b@example.com')
  )
);

-- Example 8097
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('Your message'),
  SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
    'my_email_int,
    'Service down',
    ARRAY_CONSTRUCT('oncall-a@example.com', 'oncall-b@example.com'),
    ARRAY_CONSTRUCT('cc-a@example.com', 'cc-b@example.com'),
    ARRAY_CONSTRUCT('bcc-a@example.com', 'bcc-b@example.com')
  )
);

-- Example 8098
'{ "<message_type>": "<message>" }'

-- Example 8099
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{ "text/html": "<p>This is a message.</p>" }',
  '{ "my_email_int": {} }'
);

-- Example 8100
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>a message</p>'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
);

-- Example 8101
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
);

-- Example 8102
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{ "name": "value" }'),
  SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int')
);

-- Example 8103
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  '{"text/plain":"A message"}',
  ARRAY_CONSTRUCT(
    '{"my_sns_int":{}}',
    '{"my_email_int":{}}',
 )
);

-- Example 8104
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int'),
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
  )
);

-- Example 8105
CALL SYSTEM$SEND_SNOWFLAKE_NOTIFICATION(
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.TEXT_PLAIN('A message'),
    SNOWFLAKE.NOTIFICATION.TEXT_HTML('<p>A message</p>'),
    SNOWFLAKE.NOTIFICATION.APPLICATION_JSON('{ "name": "value" }')
  ),
  ARRAY_CONSTRUCT(
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_sns_int'),
    SNOWFLAKE.NOTIFICATION.INTEGRATION('my_email_int')
  )
);

-- Example 8106
{"firstName":"John", "empid":45611}

-- Example 8107
{"firstName":"John", "lastName":"Doe"}

-- Example 8108
{"employees":[
    {"firstName":"John", "lastName":"Doe"},
    {"firstName":"Anna", "lastName":"Smith"},
    {"firstName":"Peter", "lastName":"Jones"}
  ]
}

-- Example 8109
{"root":[{"employees":[
    {"firstName":"John", "lastName":"Doe"},
    {"firstName":"Anna", "lastName":"Smith"},
    {"firstName":"Peter", "lastName":"Jones"}
]}]}

-- Example 8110
{"root":
   [
    { "kind": "person",
      "fullName": "John Doe",
      "age": 22,
      "gender": "Male",
      "phoneNumber":
        {"areaCode": "206",
         "number": "1234567"},
      "children":
         [
           {
             "name": "Jane",
             "gender": "Female",
             "age": "6"
           },
           {
              "name": "John",
              "gender": "Male",
              "age": "15"
           }
         ],
      "citiesLived":
         [
            {
               "place": "Seattle",
               "yearsLived": ["1995"]
            },
            {
               "place": "Stockholm",
               "yearsLived": ["2005"]
            }
         ]
      },
      {"kind": "person", "fullName": "Mike Jones", "age": 35, "gender": "Male", "phoneNumber": { "areaCode": "622", "number": "1567845"}, "children": [{ "name": "Earl", "gender": "Male", "age": "10"}, {"name": "Sam", "gender": "Male", "age": "6"}, { "name": "Kit", "gender": "Male", "age": "8"}], "citiesLived": [{"place": "Los Angeles", "yearsLived": ["1989", "1993", "1998", "2002"]}, {"place": "Washington DC", "yearsLived": ["1990", "1993", "1998", "2008"]}, {"place": "Portland", "yearsLived": ["1993", "1998", "2003", "2005"]}, {"place": "Austin", "yearsLived": ["1973", "1998", "2001", "2005"]}]},
      {"kind": "person", "fullName": "Anna Karenina", "age": 45, "gender": "Female", "phoneNumber": { "areaCode": "425", "number": "1984783"}, "citiesLived": [{"place": "Stockholm", "yearsLived": ["1992", "1998", "2000", "2010"]}, {"place": "Russia", "yearsLived": ["1998", "2001", "2005"]}, {"place": "Austin", "yearsLived": ["1995", "1999"]}]}
    ]
}

-- Example 8111
{
 "type": "record",
 "name": "person",
 "namespace": "example.avro",
 "fields": [
     {"name": "fullName", "type": "string"},
     {"name": "age",  "type": ["int", "null"]},
     {"name": "gender", "type": ["string", "null"]}
     ]
}

-- Example 8112
"map": [{"key": "chani", "value": {"int1": 5, "string1": "chani"}}, {"key": "mauddib", "value": {"int1": 1, "string1": "mauddib"}}]

-- Example 8113
{"time": "1970-05-05 12:34:56.197", "union": {"tag": 0, "value": 3880900}, "decimal": 3863316326626557453.000000000000000000}

-- Example 8114
+--------------------------------------+
| SRC                                  |
|--------------------------------------|
| {                                    |
|   "boolean1": false,                 |
|   "byte1": 1,                        |
|   "bytes1": "0001020304",            |
|   "decimal1": 12345678.654745,       |
|   "double1": -1.500000000000000e+01, |
|   "float1": 1.000000000000000e+00,   |
|   "int1": 65536,                     |
|   "list": [                          |
|     {                                |
|       "int1": 3,                     |
|       "string1": "good"              |
|     },                               |
|     {                                |
|       "int1": 4,                     |
|       "string1": "bad"               |
|     }                                |
|   ]                                  |
| }                                    |
+--------------------------------------+

-- Example 8115
+------------------------------------------+
| SRC                                      |
|------------------------------------------|
| {                                        |
|   "continent": "Europe",                 |
|   "country": {                           |
|     "city": {                            |
|       "bag": [                           |
|         {                                |
|           "array_element": "Paris"       |
|         },                               |
|         {                                |
|           "array_element": "Nice"        |
|         },                               |
|         {                                |
|           "array_element": "Marseilles"  |
|         },                               |
|         {                                |
|           "array_element": "Cannes"      |
|         }                                |
|       ]                                  |
|     },                                   |
|     "name": "France"                     |
|   }                                      |
| }                                        |
+------------------------------------------+

-- Example 8116
<?xml version="1.0"?>
<!DOCTYPE parts system "parts.dtd">
<?xml-stylesheet type="text/css" href="xmlpartsstyle.css"?>
<parts>
   <part count="4">
      <item>Spark Plugs</item>
      <partnum>A3-400</partnum>
      <manufacturer>ABC company</manufacturer>
      <price units="dollar"> 27.00</price>
   </part>
   <part count="1">
      <item>Motor Oil</item>
      <partnum>B5-200</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 14.00</price>
   </part>
   <part count="1">
      <item>Motor Oil</item>
      <partnum>B5-300</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 16.75</price>
   </part>
   <part count="1">
      <item>Engine Coolant</item>
      <partnum>B6-120</partnum>
       <source>XYZ company</source>
      <price units="dollar"> 19.00</price>
   </part>
   <part count="1">
      <item>Engine Coolant</item>
      <partnum>B6-220</partnum>
      <source>XYZ company</source>
      <price units="dollar"> 18.25</price>
   </part>
</parts>

-- Example 8117
PUT FILE:///examples/xml/auto-parts.xml @~/xml_stage;

-- Example 8118
CREATE OR REPLACE TABLE sample_xml_parts(src VARIANT);

-- Example 8119
COPY INTO sample_xml_parts
  FROM @~/xml_stage
  FILE_FORMAT=(TYPE=XML) ON_ERROR='CONTINUE';

-- Example 8120
SELECT src FROM sample_xml_parts;

-- Example 8121
+----------------------------------------------+
| SRC                                          |
|----------------------------------------------|
| <parts>                                      |
|   <part count="4">                           |
|     <item>Spark Plugs</item>                 |
|     <partnum>A3-400</partnum>                |
|     <manufacturer>ABC company</manufacturer> |
|     <price units="dollar">27.00</price>      |
|   </part>                                    |
|   <part count="1">                           |
|     <item>Motor Oil</item>                   |
|     <partnum>B5-200</partnum>                |
|     <source>XYZ company</source>             |
|     <price units="dollar">14.00</price>      |
|   </part>                                    |
|   <part count="1">                           |
|     <item>Motor Oil</item>                   |
|     <partnum>B5-300</partnum>                |
|     <source>XYZ company</source>             |
|     <price units="dollar">16.75</price>      |
|   </part>                                    |
|   <part count="1">                           |
|     <item>Engine Coolant</item>              |
|     <partnum>B6-120</partnum>                |
|     <source>XYZ company</source>             |
|     <price units="dollar">19.00</price>      |
|   </part>                                    |
|   <part count="1">                           |
|     <item>Engine Coolant</item>              |
|     <partnum>B6-220</partnum>                |
|     <source>XYZ company</source>             |
|     <price units="dollar">18.25</price>      |
|   </part>                                    |
| </parts>                                     |
+----------------------------------------------+

-- Example 8122
SELECT src:"$" FROM sample_xml_parts;

-- Example 8123
+--------------------------------+
| SRC:"$"                        |
|--------------------------------|
| [                              |
|   {                            |
|     "$": [                     |
|       {                        |
|         "$": "Spark Plugs",    |
|         "@": "item"            |
|       },                       |
|       {                        |
|         "$": "A3-400",         |
|         "@": "partnum"         |
|       },                       |
|       {                        |
|         "$": "ABC company",    |
|         "@": "manufacturer"    |
|       },                       |
|       {                        |
|         "$": 27,               |
|         "@": "price",          |
|         "@units": "dollar"     |
|       }                        |
|     ],                         |
|     "@": "part",               |
|     "@count": 4,               |
|     "item": 0,                 |
|     "manufacturer": 2,         |
|     "partnum": 1,              |
|     "price": 3                 |
|   },                           |
|   {                            |
|     "$": [                     |
|       {                        |
|         "$": "Motor Oil",      |
|         "@": "item"            |
|       },                       |
|       {                        |
|         "$": "B5-200",         |
|         "@": "partnum"         |
|       },                       |
|       {                        |
|         "$": "XYZ company",    |
|         "@": "source"          |
|       },                       |
|       {                        |
|         "$": 14,               |
|         "@": "price",          |
|         "@units": "dollar"     |
|       }                        |
|     ],                         |
|     "@": "part",               |
|     "@count": 1,               |
|     "item": 0,                 |
|     "partnum": 1,              |
|     "price": 3,                |
|     "source": 2                |
|   },                           |
|                                |
|              ...               |
|                                |
+--------------------------------+

-- Example 8124
SELECT src:"@" FROM sample_xml_parts;

-- Example 8125
+---------+
| SRC:"@" |
|---------|
| "parts" |
+---------+

-- Example 8126
SELECT src:"$"[0]."@count", src:"$"[1]."@count" FROM sample_xml_parts;

-- Example 8127
+---------------------+---------------------+
| SRC:"$"[0]."@COUNT" | SRC:"$"[1]."@COUNT" |
|---------------------+---------------------|
| 4                   | 1                   |
+---------------------+---------------------+

-- Example 8128
SELECT XMLGET(src, 'part') FROM sample_xml_parts;

SELECT XMLGET(src, 'part', 0) FROM sample_xml_parts;

-- Example 8129
+--------------------------------------------+
| XMLGET(SRC, 'PART')                        |
|--------------------------------------------|
| <part count="4">                           |
|   <item>Spark Plugs</item>                 |
|   <partnum>A3-400</partnum>                |
|   <manufacturer>ABC company</manufacturer> |
|   <price units="dollar">27.00</price>      |
| </part>                                    |
+--------------------------------------------+

-- Example 8130
SELECT XMLGET(src, 'part', 3) FROM sample_xml_parts;

-- Example 8131
+---------------------------------------+
| XMLGET(SRC, 'PART', 3)                |
|---------------------------------------|
| <part count="1">                      |
|   <item>Engine Coolant</item>         |
|   <partnum>B6-120</partnum>           |
|   <source>XYZ company</source>        |
|   <price units="dollar">19.00</price> |
| </part>                               |
+---------------------------------------+

-- Example 8132
SELECT XMLGET(VALUE, 'item'):"$"::VARCHAR AS item,
       XMLGET(VALUE, 'partnum'):"$"::VARCHAR AS partnum,
       COALESCE(XMLGET(VALUE, 'manufacturer'):"$"::VARCHAR,
                XMLGET(VALUE, 'source'):"$"::VARCHAR) AS manufacturer_or_source,
       XMLGET(VALUE, 'price'):"$"::VARCHAR AS price,
  FROM sample_xml_parts,
    LATERAL FLATTEN(INPUT => SRC:"$");

-- Example 8133
+----------------+---------+------------------------+-------+
| ITEM           | PARTNUM | MANUFACTURER_OR_SOURCE | PRICE |
|----------------+---------+------------------------+-------|
| Spark Plugs    | A3-400  | ABC company            | 27    |
| Motor Oil      | B5-200  | XYZ company            | 14    |
| Motor Oil      | B5-300  | XYZ company            | 16.75 |
| Engine Coolant | B6-120  | XYZ company            | 19    |
| Engine Coolant | B6-220  | XYZ company            | 18.25 |
+----------------+---------+------------------------+-------+

-- Example 8134
CREATE OR REPLACE TABLE car_sales
( 
  src variant
)
AS
SELECT PARSE_JSON(column1) AS src
FROM VALUES
('{ 
    "date" : "2017-04-28", 
    "dealership" : "Valley View Auto Sales",
    "salesperson" : {
      "id": "55",
      "name": "Frank Beasley"
    },
    "customer" : [
      {"name": "Joyce Ridgely", "phone": "16504378889", "address": "San Francisco, CA"}
    ],
    "vehicle" : [
      {"make": "Honda", "model": "Civic", "year": "2017", "price": "20275", "extras":["ext warranty", "paint protection"]}
    ]
}'),
('{ 
    "date" : "2017-04-28", 
    "dealership" : "Tindel Toyota",
    "salesperson" : {
      "id": "274",
      "name": "Greg Northrup"
    },
    "customer" : [
      {"name": "Bradley Greenbloom", "phone": "12127593751", "address": "New York, NY"}
    ],
    "vehicle" : [
      {"make": "Toyota", "model": "Camry", "year": "2017", "price": "23500", "extras":["ext warranty", "rust proofing", "fabric protection"]}  
    ]
}') v;

-- Example 8135
SELECT * FROM car_sales;
+-------------------------------------------+
| SRC                                       |
|-------------------------------------------|
| {                                         |
|   "customer": [                           |
|     {                                     |
|       "address": "San Francisco, CA",     |
|       "name": "Joyce Ridgely",            |
|       "phone": "16504378889"              |
|     }                                     |
|   ],                                      |
|   "date": "2017-04-28",                   |
|   "dealership": "Valley View Auto Sales", |
|   "salesperson": {                        |
|     "id": "55",                           |
|     "name": "Frank Beasley"               |
|   },                                      |
|   "vehicle": [                            |
|     {                                     |
|       "extras": [                         |
|         "ext warranty",                   |
|         "paint protection"                |
|       ],                                  |
|       "make": "Honda",                    |
|       "model": "Civic",                   |
|       "price": "20275",                   |
|       "year": "2017"                      |
|     }                                     |
|   ]                                       |
| }                                         |
| {                                         |
|   "customer": [                           |
|     {                                     |
|       "address": "New York, NY",          |
|       "name": "Bradley Greenbloom",       |
|       "phone": "12127593751"              |
|     }                                     |
|   ],                                      |
|   "date": "2017-04-28",                   |
|   "dealership": "Tindel Toyota",          |
|   "salesperson": {                        |
|     "id": "274",                          |
|     "name": "Greg Northrup"               |
|   },                                      |
|   "vehicle": [                            |
|     {                                     |
|       "extras": [                         |
|         "ext warranty",                   |
|         "rust proofing",                  |
|         "fabric protection"               |
|       ],                                  |
|       "make": "Toyota",                   |
|       "model": "Camry",                   |
|       "price": "23500",                   |
|       "year": "2017"                      |
|     }                                     |
|   ]                                       |
| }                                         |
+-------------------------------------------+

-- Example 8136
SELECT src:dealership
    FROM car_sales
    ORDER BY 1;
+--------------------------+
| SRC:DEALERSHIP           |
|--------------------------|
| "Tindel Toyota"          |
| "Valley View Auto Sales" |
+--------------------------+

-- Example 8137
-- This contains a blank.
SELECT src:"company name" FROM partners;

-- This does not start with a letter or underscore.
SELECT zipcode_info:"94987" FROM addresses;

-- This contains characters that are not letters, digits, or underscores, and
-- it does not start with a letter or underscore.
SELECT measurements:"#sPerSquareInch" FROM english_metrics;

-- Example 8138
SELECT src:salesperson.name
    FROM car_sales
    ORDER BY 1;
+----------------------+
| SRC:SALESPERSON.NAME |
|----------------------|
| "Frank Beasley"      |
| "Greg Northrup"      |
+----------------------+

-- Example 8139
SELECT src['salesperson']['name']
    FROM car_sales
    ORDER BY 1;
+----------------------------+
| SRC['SALESPERSON']['NAME'] |
|----------------------------|
| "Frank Beasley"            |
| "Greg Northrup"            |
+----------------------------+

-- Example 8140
SELECT src:customer[0].name, src:vehicle[0]
    FROM car_sales
    ORDER BY 1;
+----------------------+-------------------------+
| SRC:CUSTOMER[0].NAME | SRC:VEHICLE[0]          |
|----------------------+-------------------------|
| "Bradley Greenbloom" | {                       |
|                      |   "extras": [           |
|                      |     "ext warranty",     |
|                      |     "rust proofing",    |
|                      |     "fabric protection" |
|                      |   ],                    |
|                      |   "make": "Toyota",     |
|                      |   "model": "Camry",     |
|                      |   "price": "23500",     |
|                      |   "year": "2017"        |
|                      | }                       |
| "Joyce Ridgely"      | {                       |
|                      |   "extras": [           |
|                      |     "ext warranty",     |
|                      |     "paint protection"  |
|                      |   ],                    |
|                      |   "make": "Honda",      |
|                      |   "model": "Civic",     |
|                      |   "price": "20275",     |
|                      |   "year": "2017"        |
|                      | }                       |
+----------------------+-------------------------+

-- Example 8141
SELECT src:customer[0].name, src:vehicle[0].price
    FROM car_sales
    ORDER BY 1;
+----------------------+----------------------+
| SRC:CUSTOMER[0].NAME | SRC:VEHICLE[0].PRICE |
|----------------------+----------------------|
| "Bradley Greenbloom" | "23500"              |
| "Joyce Ridgely"      | "20275"              |
+----------------------+----------------------+

-- Example 8142
SELECT src:vehicle[0].price::NUMBER * 0.10 AS tax
    FROM car_sales
    ORDER BY tax;
+--------+
|    TAX |
|--------|
| 2027.5 |
| 2350.0 |
+--------+

-- Example 8143
SELECT src:dealership, src:dealership::VARCHAR
    FROM car_sales
    ORDER BY 2;
+--------------------------+-------------------------+
| SRC:DEALERSHIP           | SRC:DEALERSHIP::VARCHAR |
|--------------------------+-------------------------|
| "Tindel Toyota"          | Tindel Toyota           |
| "Valley View Auto Sales" | Valley View Auto Sales  |
+--------------------------+-------------------------+

-- Example 8144
CREATE TABLE pets (v variant);

INSERT INTO pets SELECT PARSE_JSON ('{"species":"dog", "name":"Fido", "is_dog":"true"} ');
INSERT INTO pets SELECT PARSE_JSON ('{"species":"cat", "name":"Bubby", "is_dog":"false"}');
INSERT INTO pets SELECT PARSE_JSON ('{"species":"cat", "name":"dog terror", "is_dog":"false"}');

SELECT a.v, b.key, b.value FROM pets a,LATERAL FLATTEN(input => a.v) b
WHERE b.value LIKE '%dog%';

+-------------------------+---------+--------------+
| V                       | KEY     | VALUE        |
|-------------------------+---------+--------------|
| {                       | species | "dog"        |
|   "is_dog": "true",     |         |              |
|   "name": "Fido",       |         |              |
|   "species": "dog"      |         |              |
| }                       |         |              |
| {                       | name    | "dog terror" |
|   "is_dog": "false",    |         |              |
|   "name": "dog terror", |         |              |
|   "species": "cat"      |         |              |
| }                       |         |              |
+-------------------------+---------+--------------+

-- Example 8145
SELECT REGEXP_REPLACE(f.path, '\\[[0-9]+\\]', '[]') AS "Path",
  TYPEOF(f.value) AS "Type",
  COUNT(*) AS "Count"
FROM <table>,
LATERAL FLATTEN(<variant_column>, RECURSIVE=>true) f
GROUP BY 1, 2 ORDER BY 1, 2;

-- Example 8146
{"a": 1, "b": 2, "special" : "data"}   <--- row 1 of VARIANT column
{"c": 3, "d": 4, "normal" : "data"}    <----row 2 of VARIANT column

Output from query:

+---------+---------+-------+
| Path    | Type    | Count |
|---------+---------+-------|
| a       | INTEGER |     1 |
| b       | INTEGER |     1 |
| c       | INTEGER |     1 |
| d       | INTEGER |     1 |
| normal  | VARCHAR |     1 |
| special | VARCHAR |     1 |
+---------+---------+-------+

-- Example 8147
SELECT
  t.<variant_column>,
  f.seq,
  f.key,
  f.path,
  REGEXP_COUNT(f.path,'\\.|\\[') +1 AS Level,
  TYPEOF(f.value) AS "Type",
  f.index,
  f.value AS "Current Level Value",
  f.this AS "Above Level Value"
FROM <table> t,
LATERAL FLATTEN(t.<variant_column>, recursive=>true) f;

-- Example 8148
SELECT
  t.<variant_column>,
  f.seq,
  f.key,
  f.path,
  REGEXP_COUNT(f.path,'\\.|\\[') +1 AS Level,
  TYPEOF(f.value) AS "Type",
  f.value AS "Current Level Value",
  f.this AS "Above Level Value"
FROM <table> t,
LATERAL FLATTEN(t.<variant_column>, recursive=>true) f
WHERE "Type" NOT IN ('OBJECT','ARRAY');

-- Example 8149
SELECT
  value:name::string as "Customer Name",
  value:address::string as "Address"
  FROM
    car_sales
  , LATERAL FLATTEN(INPUT => SRC:customer);

+--------------------+-------------------+
| Customer Name      | Address           |
|--------------------+-------------------|
| Joyce Ridgely      | San Francisco, CA |
| Bradley Greenbloom | New York, NY      |
+--------------------+-------------------+

-- Example 8150
"vehicle" : [
     {"make": "Honda", "model": "Civic", "year": "2017", "price": "20275", "extras":["ext warranty", "paint protection"]}
   ]

-- Example 8151
SELECT
  vm.value:make::string as make,
  vm.value:model::string as model,
  ve.value::string as "Extras Purchased"
  FROM
    car_sales
    , LATERAL FLATTEN(INPUT => SRC:vehicle) vm
    , LATERAL FLATTEN(INPUT => vm.value:extras) ve
  ORDER BY make, model, "Extras Purchased";
+--------+-------+-------------------+
| MAKE   | MODEL | Extras Purchased  |
|--------+-------+-------------------|
| Honda  | Civic | ext warranty      |
| Honda  | Civic | paint protection  |
| Toyota | Camry | ext warranty      |
| Toyota | Camry | fabric protection |
| Toyota | Camry | rust proofing     |
+--------+-------+-------------------+

-- Example 8152
CREATE OR replace TABLE colors (v variant);

INSERT INTO
   colors
   SELECT
      parse_json(column1) AS v
   FROM
   VALUES
     ('[{r:255,g:12,b:0},{r:0,g:255,b:0},{r:0,g:0,b:255}]'),
     ('[{c:0,m:1,y:1,k:0},{c:1,m:0,y:1,k:0},{c:1,m:1,y:0,k:0}]')
    v;

SELECT *, GET(v, ARRAY_SIZE(v)-1) FROM colors;

+---------------+-------------------------+
| V             | GET(V, ARRAY_SIZE(V)-1) |
|---------------+-------------------------|
| [             | {                       |
|   {           |   "b": 255,             |
|     "b": 0,   |   "g": 0,               |
|     "g": 12,  |   "r": 0                |
|     "r": 255  | }                       |
|   },          |                         |
|   {           |                         |
|     "b": 0,   |                         |
|     "g": 255, |                         |
|     "r": 0    |                         |
|   },          |                         |
|   {           |                         |
|     "b": 255, |                         |
|     "g": 0,   |                         |
|     "r": 0    |                         |
|   }           |                         |
| ]             |                         |
| [             | {                       |
|   {           |   "c": 1,               |
|     "c": 0,   |   "k": 0,               |
|     "k": 0,   |   "m": 1,               |
|     "m": 1,   |   "y": 0                |
|     "y": 1    | }                       |
|   },          |                         |
|   {           |                         |
|     "c": 1,   |                         |
|     "k": 0,   |                         |
|     "m": 0,   |                         |
|     "y": 1    |                         |
|   },          |                         |
|   {           |                         |
|     "c": 1,   |                         |
|     "k": 0,   |                         |
|     "m": 1,   |                         |
|     "y": 0    |                         |
|   }           |                         |
| ]             |                         |
+---------------+-------------------------+

-- Example 8153
SELECT GET_PATH(src, 'vehicle[0]:make') FROM car_sales;

+----------------------------------+
| GET_PATH(SRC, 'VEHICLE[0]:MAKE') |
|----------------------------------|
| "Honda"                          |
| "Toyota"                         |
+----------------------------------+

-- Example 8154
SELECT GET_PATH(src, 'vehicle[0].make') FROM car_sales;

SELECT src:vehicle[0].make FROM car_sales;

