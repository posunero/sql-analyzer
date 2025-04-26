-- Example 4271
+------------------------------------------------------------+
| SNOWFLAKE.CORE.MIN(SELECT salary FROM hr.tables.empl_info) |
+------------------------------------------------------------+
| 60000                                                      |
+------------------------------------------------------------+

-- Example 4272
SNOWFLAKE.CORE.NULL_COUNT(<query>)

-- Example 4273
SELECT SNOWFLAKE.CORE.NULL_COUNT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4274
+----------------------------------------------------------------+
| SNOWFLAKE.CORE.NULL_COUNT(SELECT ssn FROM hr.tables.empl_info) |
+----------------------------------------------------------------+
| 5                                                              |
+----------------------------------------------------------------+

-- Example 4275
SNOWFLAKE.CORE.NULL_PERCENT(<query>)

-- Example 4276
SELECT SNOWFLAKE.CORE.NULL_PERCENT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4277
+----------------------------------------------------------------+
| SNOWFLAKE.CORE.NULL_COUNT(SELECT ssn FROM hr.tables.empl_info) |
+----------------------------------------------------------------+
| 1                                                              |
+----------------------------------------------------------------+

-- Example 4278
SNOWFLAKE.CORE.STDDEV(<query>)

-- Example 4279
SELECT SNOWFLAKE.CORE.STDDEV(
  SELECT
    salary
  FROM hr.tables.empl_info
);

-- Example 4280
+------------------------------+
|       SNOWFLAKE.CORE.STDDEV( |
|                       SELECT |
|                       SALARY |
|     FROM HR.TABLES.EMPL_INFO |
|                            ) |
|------------------------------|
|               8407.615595399 |
+------------------------------+

-- Example 4281
SNOWFLAKE.CORE.UNIQUE_COUNT(<query>)

-- Example 4282
SELECT SNOWFLAKE.CORE.UNIQUE_COUNT(
  SELECT
    ssn
  FROM hr.tables.empl_info
);

-- Example 4283
+------------------------------------------------------------------+
| SNOWFLAKE.CORE.UNIQUE_COUNT(SELECT ssn FROM hr.tables.empl_info) |
+------------------------------------------------------------------+
| 42                                                               |
+------------------------------------------------------------------+

-- Example 4284
DP_INTERVAL_HIGH( <aggregated_column> )

-- Example 4285
SELECT SUM(num_claims) AS sum_claims,
  DP_INTERVAL_HIGH(sum_claims)
  FROM t1;

-- Example 4286
SELECT COUNT(*)
FROM t1 INNER JOIN t2 ON t1.a=t2.a;

-- Example 4287
SELECT COUNT(*)
FROM (SELECT a, COUNT(b) FROM t1 GROUP BY a) AS g1
    INNER JOIN (SELECT * FROM t2) AS g2
    ON g1.a=g2.a;

-- Example 4288
SELECT COUNT(*)
  FROM patients
  LEFT JOIN (SELECT zip_code, ANY_VALUE(state) AS residence_state
            FROM geo_lookup
            GROUP BY zip_code)
  USING zip_code
  WHERE birth_state = residence_state;

-- Example 4289
SELECT COUNT(*)
  FROM patients
  WHERE insurance_type = 'Commercial';

-- Example 4290
SELECT COUNT(DISTINCT patient_id)
  FROM patients
  WHERE insurance_type = 'Commercial';

-- Example 4291
SELECT COUNT(bmi)
  FROM (SELECT patient_id, ANY_VALUE(zip_code) AS zip_code
    FROM patients
    GROUP BY patient_id) AS p
  JOIN geo_lookup AS g
    ON p.zip_code = g.zip_code
  WHERE state='CA';

-- Example 4292
SELECT COUNT(bmi)
  FROM (SELECT patient_id, ANY_VALUE(bmi) as bmi, ANY_VALUE(state) as state
      FROM patients AS p
      JOIN geo_lookup AS g
        ON p.zip_code = g.zip_code
      GROUP BY patient_id)
  WHERE state='CA';

-- Example 4293
SELECT COUNT(num_visits)
  FROM (SELECT COUNT((visit_reason<>'Regular checkup')::INT) AS num_visits
        WHERE visit_reason IS NOT NULL
        GROUP BY patient_id)
  WHERE num_visits > 0 AND num_visits < 20;

-- Example 4294
SELECT COUNT(num_claims) AS count_claims,
    DP_INTERVAL_LOW(count_claims),
    DP_INTERVAL_HIGH(count_claims)
FROM t1;

-- Example 4295
+----------------+----------------------------------+----------------------------------+
|  count_claims  |  dp_interval_low("count_claims") |  dp_interval_high("count_claims")|
|----------------+----------------------------------+----------------------------------+
|  50            |  35                              |    75                            |
+----------------+----------------------------------+----------------------------------+

-- Example 4296
SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 4297
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 996               |     233      |     WEEKLY    |     0.0      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 4298
SELECT COUNT(salary) FROM my_table;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 4299
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 995               |     233      |     WEEKLY    |     0.6      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 4300
SELECT COUNT(salary), COUNT(age) FROM my_table GROUP BY STATE;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 4301
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 993               |     233      |     WEEKLY    |     1.8      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 4302
SELECT COUNT(salary), COUNT(age) FROM T GROUP BY STATE;

-- results omitted ...

SELECT * FROM TABLE(SNOWFLAKE.DATA_PRIVACY.ESTIMATE_REMAINING_DP_AGGREGATES('my_table'));

-- Example 4303
+-----------------------------------+--------------+---------------+--------------+
| NUMBER_OF_REMAINING_DP_AGGREGATES | BUDGET_LIMIT | BUDGET_WINDOW | BUDGET_SPENT |
|-----------------------------------+--------------+---------------+--------------|
|                 991               |     233      |     WEEKLY    |     3.0      |
+-----------------------------------+--------------+---------------+--------------+

-- Example 4304
DP_INTERVAL_LOW( <aggregated_column> )

-- Example 4305
SELECT SUM(num_claims) AS sum_claims,
  DP_INTERVAL_LOW(sum_claims)
  FROM t1;

-- Example 4306
DYNAMIC_TABLE_GRAPH_HISTORY(
  [ AS_OF => <constant_expr> ]
  [ , HISTORY_START => <constant_expr> [ , HISTORY_END => <constant_expr> ] ]
)

-- Example 4307
DYNAMIC_TABLE_REFRESH_HISTORY(
  [ DATA_TIMESTAMP_START => <constant_expr> ]
  [ , DATA_TIMESTAMP_END => <constant_expr> ]
  [ , RESULT_LIMIT => <integer> ]
  [ , NAME => '<string>' ]
  [ , NAME_PREFIX => '<string>' ]
  [ , ERROR_ONLY => { TRUE | FALSE } ]
)

-- Example 4308
SELECT
  name,
  state,
  state_code,
  state_message,
  query_id,
  data_timestamp,
  refresh_start_time,
  refresh_end_time
FROM
  TABLE (
    INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY (
      NAME_PREFIX => 'MYDB.MYSCHEMA.', ERROR_ONLY => TRUE
    )
  )
ORDER BY
  name,
  data_timestamp;

-- Example 4309
DYNAMIC_TABLES (
  [ NAME => '<string>' ]
  [ , REFRESH_DATA_TIMESTAMP_START => <constant_expr> ]
  [ , RESULT_LIMIT => <integer> ]
  [ , INCLUDE_CONNECTED => { TRUE | FALSE } ]
)

-- Example 4310
SELECT
  name,
  target_lag_sec,
  mean_lag_sec,
  latest_data_timestamp
FROM
  TABLE (
    INFORMATION_SCHEMA.DYNAMIC_TABLES (
      NAME => 'mydb.myschema.mydt',
      INCLUDE_CONNECTED => TRUE
    )
  )
ORDER BY
  target_lag_sec

-- Example 4311
EDITDISTANCE( <string_expr1> , <string_expr2> [ , <max_distance> ] )

-- Example 4312
SELECT s,
       t,
       EDITDISTANCE(s, t),
       EDITDISTANCE(t, s),
       EDITDISTANCE(s, t, 3),
       EDITDISTANCE(s, t, -1)
  FROM ed;

-- Example 4313
+----------------+-----------------+--------------------+--------------------+-----------------------+------------------------+
|      S         |        T        | EDITDISTANCE(S, T) | EDITDISTANCE(T, S) | EDITDISTANCE(S, T, 3) | EDITDISTANCE(S, T, -1) |
|----------------+-----------------+--------------------+--------------------+-----------------------+------------------------|
|                |                 | 0                  | 0                  | 0                     | 0                      |
| Gute nacht     | Ich weis nicht  | 8                  | 8                  | 3                     | 0                      |
| Ich weiß nicht | Ich wei? nicht  | 1                  | 1                  | 1                     | 0                      |
| Ich weiß nicht | Ich weiss nicht | 2                  | 2                  | 2                     | 0                      |
| Ich weiß nicht | [NULL]          | [NULL]             | [NULL]             | [NULL]                | [NULL]                 |
| Snowflake      | Oracle          | 7                  | 7                  | 3                     | 0                      |
| święta         | swieta          | 2                  | 2                  | 2                     | 0                      |
| [NULL]         |                 | [NULL]             | [NULL]             | [NULL]                | [NULL]                 |
| [NULL]         | [NULL]          | [NULL]             | [NULL]             | [NULL]                | [NULL]                 |
+----------------+-----------------+--------------------+--------------------+-----------------------+------------------------+

-- Example 4314
SELECT EDITDISTANCE('future', 'past', 2) < 2;

-- Example 4315
+---------------------------------------+
| EDITDISTANCE('FUTURE', 'PAST', 2) < 2 |
|---------------------------------------|
| False                                 |
+---------------------------------------+

-- Example 4316
SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
  '<email_integration_name>',
  '<subject>',
  <array_of_email_addresses_for_to_line> )

-- Example 4317
SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
  '<email_integration_name>',
  '<subject>',
  <array_of_email_addresses_for_to_line>,
  <array_of_email_addresses_for_cc_line>,
  <array_of_email_addresses_for_bcc_line> )

-- Example 4318
SELECT SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
  'my_email_int',
  'Updates',
   ARRAY_CONSTRUCT('person_a@example.com', 'person_b@example.com')
)

-- Example 4319
'{"my_email_int":{"subject":"Updates","toAddress":["person_a@example.com","person_b@example.com"]}}'

-- Example 4320
SELECT SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
  'my_email_int',
  'Updates',
   ARRAY_CONSTRUCT('person_a@example.com', 'person_b@example.com'),
   ARRAY_CONSTRUCT('cc_person_a@example.com'),
   NULL
)

-- Example 4321
'{"my_email_int":{"subject":"Updates","toAddress":["person_a@example.com","person_b@example.com"],"ccAddress":["cc_person_a@snowflake.com"]}}'

-- Example 4322
SELECT SNOWFLAKE.NOTIFICATION.EMAIL_INTEGRATION_CONFIG(
  'my_email_int',
  'Updates',
   ARRAY_CONSTRUCT('person_a@example.com', 'person_b@example.com'),
   ARRAY_CONSTRUCT('cc_person_a@example.com'),
   ARRAY_CONSTRUCT('bcc_person_b@example.com')
)

-- Example 4323
'{"my_email_int":{"subject":"Updates","toAddress":["person_a@example.com","person_b@example.com"],"ccAddress":["cc_person_a@example.com"],"bccAddress":["bcc_person_b@example.com"]}}'

-- Example 4324
SNOWFLAKE.CORTEX.EMBED_TEXT_768( <model>, <text> )

-- Example 4325
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m-v1.5', 'hello world');

-- Example 4326
SNOWFLAKE.CORTEX.EMBED_TEXT_1024( <model>, <text> )

-- Example 4327
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_1024('snowflake-arctic-embed-l-v2.0', 'hello world');

-- Example 4328
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_1024('snowflake-arctic-embed-l-v2.0', 'hola mundo');

-- Example 4329
ENCRYPT( <value_to_encrypt> , <passphrase> ,
         [ [ <additional_authenticated_data> , ] <encryption_method> ]
       )

-- Example 4330
<algorithm>-<mode> [ /pad: <padding> ]

-- Example 4331
SELECT encrypt('Secret!', 'SamplePassphrase');

-- Example 4332
SET passphrase='poiuqewjlkfsd';

-- Example 4333
SELECT
    TO_VARCHAR(
        DECRYPT(
            ENCRYPT('Patient tested positive for COVID-19', $passphrase),
            $passphrase),
        'utf-8')
        AS decrypted
    ;
+--------------------------------------+
| DECRYPTED                            |
|--------------------------------------|
| Patient tested positive for COVID-19 |
+--------------------------------------+

-- Example 4334
SELECT encrypt(to_binary(hex_encode('Secret!')), 'SamplePassphrase', to_binary(hex_encode('Authenticated Data')));

-- Example 4335
6E1361E297C22969345F978A45205E3E98EB872844E3A0F151713894C273FAEF50C365S

-- Example 4336
SELECT encrypt(to_binary(hex_encode('secret!')), 'sample_passphrase', NULL, 'aes-cbc/pad:pkcs') as encrypted_data;

-- Example 4337
SELECT
    TO_VARCHAR(
        DECRYPT(
            ENCRYPT('penicillin', $passphrase, 'John Dough AAD', 'aes-gcm'),
            $passphrase, 'John Dough AAD', 'aes-gcm'),
        'utf-8')
        AS medicine
    ;
+------------+
| MEDICINE   |
|------------|
| penicillin |
+------------+

