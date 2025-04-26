-- Example 3869
COPY INTO sample_xml_parts
  FROM @~/xml_stage
  FILE_FORMAT=(TYPE=XML) ON_ERROR='CONTINUE';

-- Example 3870
SELECT src FROM sample_xml_parts;

-- Example 3871
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

-- Example 3872
SELECT src:"$" FROM sample_xml_parts;

-- Example 3873
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

-- Example 3874
SELECT src:"@" FROM sample_xml_parts;

-- Example 3875
+---------+
| SRC:"@" |
|---------|
| "parts" |
+---------+

-- Example 3876
SELECT src:"$"[0]."@count", src:"$"[1]."@count" FROM sample_xml_parts;

-- Example 3877
+---------------------+---------------------+
| SRC:"$"[0]."@COUNT" | SRC:"$"[1]."@COUNT" |
|---------------------+---------------------|
| 4                   | 1                   |
+---------------------+---------------------+

-- Example 3878
SELECT XMLGET(src, 'part') FROM sample_xml_parts;

SELECT XMLGET(src, 'part', 0) FROM sample_xml_parts;

-- Example 3879
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

-- Example 3880
SELECT XMLGET(src, 'part', 3) FROM sample_xml_parts;

-- Example 3881
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

-- Example 3882
SELECT XMLGET(VALUE, 'item'):"$"::VARCHAR AS item,
       XMLGET(VALUE, 'partnum'):"$"::VARCHAR AS partnum,
       COALESCE(XMLGET(VALUE, 'manufacturer'):"$"::VARCHAR,
                XMLGET(VALUE, 'source'):"$"::VARCHAR) AS manufacturer_or_source,
       XMLGET(VALUE, 'price'):"$"::VARCHAR AS price,
  FROM sample_xml_parts,
    LATERAL FLATTEN(INPUT => SRC:"$");

-- Example 3883
+----------------+---------+------------------------+-------+
| ITEM           | PARTNUM | MANUFACTURER_OR_SOURCE | PRICE |
|----------------+---------+------------------------+-------|
| Spark Plugs    | A3-400  | ABC company            | 27    |
| Motor Oil      | B5-200  | XYZ company            | 14    |
| Motor Oil      | B5-300  | XYZ company            | 16.75 |
| Engine Coolant | B6-120  | XYZ company            | 19    |
| Engine Coolant | B6-220  | XYZ company            | 18.25 |
+----------------+---------+------------------------+-------+

-- Example 3884
CHR( <input> )

-- Example 3885
SELECT column1, CHR(column1)
FROM (VALUES(83), (33), (169), (8364), (0), (null));

-- Example 3886
+---------+--------------+
| COLUMN1 | CHR(COLUMN1) |
|---------+--------------|
|      83 | S            |
|      33 | !            |
|     169 | ©            |
|    8364 | €            |
|       0 |              |
|    NULL | NULL         |
+---------+--------------+

-- Example 3887
SELECT column1, CHR(column1)
FROM (VALUES(-1));

-- Example 3888
FAILURE: Invalid character code -1 in the CHR input

-- Example 3889
SELECT column1, CHR(column1)
FROM (VALUES(999999999999));

-- Example 3890
FAILURE: Invalid character code 999999999999 in the CHR input

-- Example 3891
SNOWFLAKE.CORTEX.CLASSIFY_TEXT( <input> , <list_of_categories>, [ <options> ] )

-- Example 3892
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT('One day I will see the world', ['travel', 'cooking']);

-- Example 3893
{
  "label": "travel"
}

-- Example 3894
CREATE OR REPLACE TEMPORARY TABLE text_classification_table AS
SELECT 'France' AS input, ['North America', 'Europe', 'Asia'] AS classes
UNION ALL
SELECT 'Singapore', ['North America', 'Europe', 'Asia']
UNION ALL
SELECT 'one day I will see the world', ['travel', 'cooking', 'dancing']
UNION ALL
SELECT 'my lobster bisque is second to none', ['travel', 'cooking', 'dancing'];

SELECT input,
       classes,
       SNOWFLAKE.CORTEX.CLASSIFY_TEXT(input, classes)['label'] as classification
FROM text_classification_table;

-- Example 3895
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
  'When I am not at work, I love creating recipes using every day ingredients',
  ['travel', 'cooking', 'fitness'],
  {
    'task_description': 'Return a classification of the Hobby identified in the text'
  }
);

-- Example 3896
{
  "label": "cooking"
}

-- Example 3897
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
  'I love running every morning before the world wakes up',
  [{
    'label': 'travel',
    'description': 'Hobbies related to going from one place to another',
    'examples': ['I like flying to Europe', 'Every summer we go to Italy' , 'I love traveling to learn new cultures']
  },{
    'label': 'cooking',
    'description': 'Hobbies related to preparing food',
    'examples': ['I like learning about new ingredients', 'You must bring your soul to the recipe' , 'Baking is my therapy']
    },{
    'label': 'fitness',
    'description': 'Hobbies related to being active and healthy',
    'examples': ['I cannot live without my Strava app', 'Running is life' , 'I go to the Gym every day']
    }],
  {'task_description': 'Return a classification of the Hobby identified in the text'})

-- Example 3898
{
  "label": "fitness"
}

-- Example 3899
SELECT SNOWFLAKE.CORTEX.CLASSIFY_TEXT(
  'I love running every morning before the world wakes up',
  [{
    'label': 'travel',
    'description': 'Hobbies related to going from one place to another',
    'examples': ['I like flying to Europe']
  },{
    'label': 'cooking',
    'examples': ['I like learning about new ingredients', 'You must bring your soul to the recipe' , 'Baking is my therapy']
    },{
    'label': 'fitness',
    'description': 'Hobbies related to being active and healthy'
    }],
  {'task_description': 'Return a classification of the Hobby identified in the text'})

-- Example 3900
{
  "label": "fitness"
}

-- Example 3901
COALESCE( <expr1> , <expr2> [ , ... , <exprN> ] )

-- Example 3902
SELECT column1, column2, column3, coalesce(column1, column2, column3)
FROM (values
  (1,    2,    3   ),
  (null, 2,    3   ),
  (null, null, 3   ),
  (null, null, null),
  (1,    null, 3   ),
  (1,    null, null),
  (1,    2,    null)
) v;

+---------+---------+---------+-------------------------------------+
| COLUMN1 | COLUMN2 | COLUMN3 | COALESCE(COLUMN1, COLUMN2, COLUMN3) |
|---------+---------+---------+-------------------------------------|
|       1 |       2 |       3 |                                   1 |
|    NULL |       2 |       3 |                                   2 |
|    NULL |    NULL |       3 |                                   3 |
|    NULL |    NULL |    NULL |                                NULL |
|       1 |    NULL |       3 |                                   1 |
|       1 |    NULL |    NULL |                                   1 |
|       1 |       2 |    NULL |                                   1 |
+---------+---------+---------+-------------------------------------+

-- Example 3903
COLLATE(<string_expression>, '<collation_specification>')

-- Example 3904
<string_expression> COLLATE '<collation_specification>'

-- Example 3905
CREATE OR REPLACE TABLE collation1 (v VARCHAR COLLATE 'es');
INSERT INTO collation1 (v) VALUES ('ñ');

-- Example 3906
SELECT v,
       COLLATION(v),
       COLLATE(v, 'es-ci'),
       COLLATION(COLLATE(v, 'es-ci'))
  FROM collation1;

-- Example 3907
+---+--------------+---------------------+--------------------------------+
| V | COLLATION(V) | COLLATE(V, 'ES-CI') | COLLATION(COLLATE(V, 'ES-CI')) |
|---+--------------+---------------------+--------------------------------|
| ñ | es           | ñ                   | es-ci                          |
+---+--------------+---------------------+--------------------------------+

-- Example 3908
SELECT v,
       v = 'ñ' AS "COMPARISON TO LOWER CASE",
       v = 'Ñ' AS "COMPARISON TO UPPER CASE",
       COLLATE(v, 'es-ci'),
       COLLATE(v, 'es-ci') = 'Ñ'
  FROM collation1;

-- Example 3909
+---+--------------------------+--------------------------+---------------------+---------------------------+
| V | COMPARISON TO LOWER CASE | COMPARISON TO UPPER CASE | COLLATE(V, 'ES-CI') | COLLATE(V, 'ES-CI') = 'Ñ' |
|---+--------------------------+--------------------------+---------------------+---------------------------|
| ñ | True                     | False                    | ñ                   | True                      |
+---+--------------------------+--------------------------+---------------------+---------------------------+

-- Example 3910
SELECT *
  FROM t1
  ORDER BY COLLATE(col1 , 'de');

-- Example 3911
SELECT spanish_phrase FROM collation_demo 
  ORDER BY COLLATE(spanish_phrase, 'utf8');

-- Example 3912
SELECT spanish_phrase FROM collation_demo 
  ORDER BY spanish_phrase COLLATE 'utf8';

-- Example 3913
COLLATION(<expression>)

-- Example 3914
CREATE OR REPLACE TABLE collation1 (v VARCHAR COLLATE 'es');
INSERT INTO collation1 (v) VALUES ('ñ');

-- Example 3915
SELECT COLLATION(v)
  FROM collation1;

-- Example 3916
+--------------+
| COLLATION(V) |
|--------------|
| es           |
+--------------+

-- Example 3917
SNOWFLAKE.CORTEX.COMPLETE(
    '<model>', '<prompt>', <file_object>)
FROM <table>

-- Example 3918
SNOWFLAKE.CORTEX.COMPLETE(
    '<model>', <prompt_object> )
FROM <table>

-- Example 3919
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    'Which country will observe the largest inflation change in 2024 compared to 2023?',
    TO_FILE('@myimages', 'highest-inflation.png'));

-- Example 3920
Looking at the data, Venezuela will experience the largest change in inflation rates between 2023 and 2024.
The inflation rate in Venezuela is projected to decrease significantly from 337.46% in 2023 to 99.98% in 2024,
representing a reduction of approximately 237.48 percentage points. This is the most dramatic change among
all countries shown in the chart, even though Zimbabwe has higher absolute inflation rates.

-- Example 3921
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    'Classify the landmark identified in this image. Respond in JSON only with the landmark name.',
    TO_FILE('@myimages', 'Seattle.jpg'));

-- Example 3922
{"landmark": "Space Needle"}

-- Example 3923
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    'Extract the kitchen appliances identified in this image. Respond in JSON only with the identified appliances.',
    TO_FILE('@myimages, 'kitchen.png'));

-- Example 3924
{
    "appliances": [ "microwave","electric stove","oven","refrigerator" ]
}

-- Example 3925
CREATE TABLE image_table AS
    (SELECT TO_FILE('@myimages', RELATIVE_PATH) AS img FROM DIRECTORY(@myimages));

-- Example 3926
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Classify the input image {0} in no more than 2 words. Respond in JSON', img_file)) AS image_classification
FROM image_table;

-- Example 3927
{ "classification": "Inflation Rates" }
{ "classification": "beverage refrigerator" }
{ "classification": "Space Needle" }
{ "classification": "Modern Kitchen" }
{ "classification": "Pie Chart" }
{ "classification": "Economic Graph" }
{ "classification": "Persian Cat" }
{ "classification": "Labrador Retriever" }
{ "classification": "Jedi Cat" }
{ "classification": "Sleeping cat" }
{ "classification": "Persian Cat" }
{ "classification": "Garden Costume" }
{ "classification": "Floral Fashion" }

-- Example 3928
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Classify the input image {0} in no more than 2 words. Respond in JSON',
        TO_FILE('@myimages', img_path)) AS image_classification
FROM image_table;

-- Example 3929
SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Classify the input image {0} in no more than 2 words. Respond in JSON',
        TO_FILE('@myimages', RELATIVE_PATH))) as image_classification
FROM DIRECTORY(@myimages);

-- Example 3930
SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',
    PROMPT('Given the input image {0}, {1}. Respond in JSON',
        TO_FILE('@myimages', img_path), prompt) as image_result)
FROM image_table;

-- Example 3931
SNOWFLAKE.CORTEX.COMPLETE(
    <model>, <prompt_or_history> [ , <options> ] )

-- Example 3932
SELECT SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', 'What are large language models?');

-- Example 3933
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
        CONCAT('Critique this review in bullet points: <review>', content, '</review>')
) FROM reviews LIMIT 10;

-- Example 3934
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama2-70b-chat',
    [
        {
            'role': 'user',
            'content': 'how does a snowflake get its unique pattern?'
        }
    ],
    {
        'temperature': 0.7,
        'max_tokens': 10
    }
);

-- Example 3935
{
    "choices": [
        {
            "messages": " The unique pattern on a snowflake is"
        }
    ],
    "created": 1708536426,
    "model": "llama2-70b-chat",
    "usage": {
        "completion_tokens": 10,
        "prompt_tokens": 22,
        "guardrail_tokens": 0,
        "total_tokens": 32
    }
}

