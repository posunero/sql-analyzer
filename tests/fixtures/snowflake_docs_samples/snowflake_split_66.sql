-- Example 4405
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

-- Example 4406
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

-- Example 4407
SELECT order_id,
       order_date,
       FILTER(o.order_detail, i -> i:subtotal >= 1500) ORDER_DETAIL_GT_EQUAL_1500
  FROM orders o;

-- Example 4408
+----------+------------+----------------------------+
| ORDER_ID | ORDER_DATE | ORDER_DETAIL_GT_EQUAL_1500 |
|----------+------------+----------------------------|
|        1 | 2024-01-01 | [                          |
|          |            |   {                        |
|          |            |     "item": "UHD Monitor", |
|          |            |     "quantity": 3,         |
|          |            |     "subtotal": 1500       |
|          |            |   }                        |
|          |            | ]                          |
|        2 | 2024-01-02 | [                          |
|          |            |   {                        |
|          |            |     "item": "Laptop",      |
|          |            |     "quantity": 5,         |
|          |            |     "subtotal": 7500       |
|          |            |   }                        |
|          |            | ]                          |
+----------+------------+----------------------------+

-- Example 4409
SNOWFLAKE.CORTEX.FINETUNE(
  'CANCEL',
  '<finetune_job_id>'
)

-- Example 4410
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CANCEL',
  'ft_194bbea4-1208-42f3-88c6-cfb202086125'
);

-- Example 4411
Canceled Cortex Fine-tuning job: ft_194bbea4-1208-42f3-88c6-cfb202086125

-- Example 4412
SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  '<name>',
  '<base_model>',
  '<training_data_query>'
  [
    , '<validation_data_query>'
    [, '<options>' ]
  ]
)

-- Example 4413
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM train',
  'SELECT prompt, completion FROM validation'
);

-- Example 4414
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'CREATE',
  'my_tuned_model',
  'mistral-7b',
  'SELECT prompt, completion FROM train'
);

-- Example 4415
ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299

-- Example 4416
SNOWFLAKE.CORTEX.FINETUNE(
  'DESCRIBE',
  '<finetune_job_id>'
)

-- Example 4417
trained tokens = number of input tokens  * number of epochs trained

-- Example 4418
SELECT SNOWFLAKE.CORTEX.FINETUNE(
  'DESCRIBE',
  'ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299'
);

-- Example 4419
{
  "base_model":"mistral-7b",
  "created_on":1717004388348,
  "finished_on":1717004691577,
  "id":"ft_6556e15c-8f12-4d94-8cb0-87e6f2fd2299",
  "model":"mydb.myschema.my_tuned_model",
  "progress":1.0,
  "status":"SUCCESS",
  "training_data":"SELECT prompt, completion FROM train",
  "trained_tokens":2670734,
  "training_result":{"validation_loss":1.0138969421386719,"training_loss":0.6477728401547047},
  "validation_data":"SELECT prompt, completion FROM validation",
  "options":{"max_epochs":3}
}

-- Example 4420
SNOWFLAKE.CORTEX.FINETUNE('SHOW')

-- Example 4421
SELECT SNOWFLAKE.CORTEX.FINETUNE('SHOW');

-- Example 4422
[{"id":"ft_9544250a-20a9-42b3-babe-74f0a6f88f60","status":"SUCCESS","base_model":"llama3.1-8b","created_on":1730835118114},
{"id":"ft_354cf617-2fd1-4ffa-a3f9-190633f42a25","status":"ERROR","base_model":"llama3.1-8b","created_on":1730834536632}]

-- Example 4423
FINETUNE (
  { 'CREATE' | 'SHOW' | 'DESCRIBE' | 'CANCEL' }
  ...
  )

-- Example 4424
FIRST_VALUE( <expr> ) [ { IGNORE | RESPECT } NULLS ]
  OVER ( [ PARTITION BY <expr1> ] ORDER BY <expr2>  [ { ASC | DESC } ] [ <window_frame> ] )

-- Example 4425
PARTITION BY column_1, column_2

-- Example 4426
ORDER BY column_3, column_4

-- Example 4427
... OVER (PARTITION BY p ORDER BY o COLLATE 'lower') ...

-- Example 4428
SELECT
        column1,
        column2,
        FIRST_VALUE(column2) OVER (PARTITION BY column1 ORDER BY column2 NULLS LAST) AS column2_first
    FROM VALUES
       (1, 10), (1, 11), (1, null), (1, 12),
       (2, 20), (2, 21), (2, 22)
    ORDER BY column1, column2;
+---------+---------+---------------+
| COLUMN1 | COLUMN2 | COLUMN2_FIRST |
|---------+---------+---------------|
|       1 |      10 |            10 |
|       1 |      11 |            10 |
|       1 |      12 |            10 |
|       1 |    NULL |            10 |
|       2 |      20 |            20 |
|       2 |      21 |            20 |
|       2 |      22 |            20 |
+---------+---------+---------------+

-- Example 4429
SELECT
        partition_col, order_col, i,
        FIRST_VALUE(i)  OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS FIRST_VAL,
        NTH_VALUE(i, 2) OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS NTH_VAL,
        LAST_VALUE(i)   OVER (PARTITION BY partition_col ORDER BY order_col
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS LAST_VAL
    FROM demo1
    ORDER BY partition_col, i, order_col;
+---------------+-----------+---+-----------+---------+----------+
| PARTITION_COL | ORDER_COL | I | FIRST_VAL | NTH_VAL | LAST_VAL |
|---------------+-----------+---+-----------+---------+----------|
|             1 |         1 | 1 |      NULL |       1 |        2 |
|             1 |         2 | 2 |         1 |       2 |        3 |
|             1 |         3 | 3 |         2 |       3 |        4 |
|             1 |         4 | 4 |         3 |       4 |        5 |
|             1 |         5 | 5 |         4 |       5 |        5 |
|             2 |         1 | 1 |      NULL |       1 |        2 |
|             2 |         2 | 2 |         1 |       2 |        3 |
|             2 |         3 | 3 |         2 |       3 |        4 |
|             2 |         4 | 4 |         3 |       4 |        4 |
+---------------+-----------+---+-----------+---------+----------+

-- Example 4430
FL_GET_CONTENT_TYPE( <stage_name>, <relative_path> )

FL_GET_CONTENT_TYPE( <file_url> )

FL_GET_CONTENT_TYPE( <metadata> )

-- Example 4431
CREATE TABLE file_table(f FILE);
INSERT INTO file_table
    SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_CONTENT_TYPE(f) FROM file_table;

-- Example 4432
+------------------------+
| FL_GET_CONTENT_TYPE(F) |
|------------------------|
| image/png              |
+------------------------+

-- Example 4433
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table
  SELECT object_construct('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.jpg', 'ETAG', '<ETAG value>',
      'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_CONTENT_TYPE(f) FROM file_table;

-- Example 4434
+------------------------+
| FL_GET_CONTENT_TYPE(F) |
|------------------------|
| image/jpg              |
+------------------------+

-- Example 4435
CREATE TABLE images_table(img FILE);

-- Example 4436
ALTER STAGE my_images DIRECTORY=(ENABLE=true);

-- Example 4437
INSERT INTO images_table
    SELECT TO_FILE(file_url) FROM DIRECTORY(@my_images);

-- Example 4438
SELECT FL_GET_RELATIVE_PATH(f)
    FROM images_table
    WHERE FL_GET_LAST_MODIFIED(f) BETWEEN '2021-01-01' and '2023-01-01';

-- Example 4439
FL_GET_ETAG( <stage_name>, <relative_path> )

FL_GET_ETAG( <file_url> )

FL_GET_ETAG( <metadata> )

-- Example 4440
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_ETAG(f) FROM file_table;

-- Example 4441
+-----------------------------------+
| FL_GET_ETAG(F)                    |
|-----------------------------------|
| <ETAG value>                      |
+-----------------------------------+

-- Example 4442
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.jpg', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_ETAG(f) FROM file_table;

-- Example 4443
+-----------------------------------+
| FL_GET_ETAG(F)                    |
|-----------------------------------|
| <ETAG value>                      |
+-----------------------------------+

-- Example 4444
FL_GET_FILE_TYPE( <stage_name>, <relative_path> )

FL_GET_FILE_TYPE( <file_url> )

FL_GET_FILE_TYPE( <metadata> )

-- Example 4445
CREATE TABLE FILE_TABLE(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_FILE_TYPE(f) FROM file_table;

-- Example 4446
+------------------------+
| FL_GET_FILE_TYPE(F)    |
|------------------------|
| image                  |
+------------------------+

-- Example 4447
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'document.pdf', 'ETAG', '<ETAG value>',
  'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'application/pdf');

SELECT FL_GET_FILE_TYPE(f) FROM file_table;

-- Example 4448
+------------------------+
| FL_GET_FILE_TYPE(F)    |
|------------------------|
| document               |
+------------------------+

-- Example 4449
FL_GET_LAST_MODIFIED( <stage_name>, <relative_path> )

FL_GET_LAST_MODIFIED( <file_url> )

FL_GET_LAST_MODIFIED( <metadata> )

-- Example 4450
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_LAST_MODIFIED(f) FROM file_table;

-- Example 4451
+-------------------------------+
| FL_GET_LAST_MODIFIED(F)       |
|-------------------------------|
| Wed, 11 Dec 2024 20:24:00 GMT |
+-------------------------------+

-- Example 4452
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.jpg', 'ETAG', '<ETAG value>',
    'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_LAST_MODIFIED(f) FROM file_table;

-- Example 4453
+-------------------------------+
| FL_GET_LAST_MODIFIED(F)       |
|-------------------------------|
| Wed, 11 Dec 2024 20:24:00 GMT |
+-------------------------------+

-- Example 4454
FL_GET_RELATIVE_PATH( <stage_name>, <relative_path> )

FL_GET_RELATIVE_PATH( <file_url> )

FL_GET_RELATIVE_PATH( <metadata> )

-- Example 4455
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_RELATIVE_PATH(f) FROM file_table;

-- Example 4456
+-------------------------+
| FL_GET_RELATIVE_PATH(F) |
|-------------------------|
| image.png               |
+-------------------------+

-- Example 4457
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'image.jpg', 'ETAG', '<ETAG value>',
    'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_RELATIVE_PATH(f) FROM file_table;

-- Example 4458
+-------------------------+
| FL_GET_RELATIVE_PATH(F) |
|-------------------------|
| image.png               |
+-------------------------+

-- Example 4459
FL_GET_SCOPED_FILE_URL( <stage_name>, <relative_path> )

FL_GET_SCOPED_FILE_URL( <file_url> )

FL_GET_SCOPED_FILE_URL( <metadata> )

-- Example 4460
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_SCOPED_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_SCOPED_FILE_URL(f) FROM file_table;

-- Example 4461
+--------------------------------------------------------------------------------------------------------------------+
| FL_GET_SCOPED_FILE_URL(F)                                                                                          |
|--------------------------------------------------------------------------------------------------------------------|
| https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV  |
+--------------------------------------------------------------------------------------------------------------------+

-- Example 4462
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('SCOPED_FILE_URL', 'https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV',
  'ETAG', '<ETAG value>', 'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'CONTENT_TYPE', 'image/jpg');

SELECT FL_GET_SCOPED_FILE_URL(f) FROM file_table;

-- Example 4463
+--------------------------------------------------------------------------------------------------------------------+
| FL_GET_SCOPED_FILE_URL(F)                                                                                          |
|--------------------------------------------------------------------------------------------------------------------|
| https://snowflake.account.snowflakecomputing.com/api/files/01ba4df2-0100-0001-0000-00040002e2b6/299017/Y6JShH6KjV  |
+--------------------------------------------------------------------------------------------------------------------+

-- Example 4464
FL_GET_SIZE( <stage_name>, <relative_path> )

FL_GET_SIZE( <file_url> )

FL_GET_SIZE( <metadata> )

-- Example 4465
CREATE TABLE file_table(f FILE);
INSERT INTO file_table SELECT TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_SIZE(f) FROM file_table;

-- Example 4466
+-------------------+
| FL_GET_SIZE(F)    |
|-------------------|
| 105859            |
+-------------------+

-- Example 4467
CREATE TABLE file_table(f OBJECT);
INSERT INTO file_table SELECT OBJECT_CONSTRUCT('STAGE', 'MYSTAGE', 'RELATIVE_PATH', 'document.pdf', 'ETAG', '<ETAG value>', 'LAST_MODIFIED', 'Wed, 11 Dec 2024 20:24:00 GMT', 'SIZE', 105859, 'FILE_TYPE', 'application/pdf');

SELECT FL_GET_SIZE(f) FROM file_table;

-- Example 4468
+-------------------+
| FL_GET_SIZE(F)    |
|-------------------|
| 105859            |
+-------------------+

-- Example 4469
FL_GET_STAGE( <stage_name>, <relative_path> )

FL_GET_STAGE( <file_url> )

FL_GET_STAGE( <metadata> )

-- Example 4470
CREATE TABLE file_table(f FILE);
INSERT INTO file_table select TO_FILE(BUILD_STAGE_FILE_URL('@mystage', 'image.png'));

SELECT FL_GET_STAGE(f) FROM file_table;

-- Example 4471
+------------------------+
| FL_GET_STAGE(F)        |
|------------------------|
| MYSTAGE                |
+------------------------+

