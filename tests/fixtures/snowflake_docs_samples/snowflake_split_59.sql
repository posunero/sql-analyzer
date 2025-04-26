-- Example 3936
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-7b',
    [
        {
            'role': 'user',
            'content': <'Prompt that generates an unsafe response'>
        }
    ],
    {
        'guardrails': true
    }
);

-- Example 3937
{
    "choices": [
        {
            "messages": "Response filtered by Cortex Guard"
        }
    ],
    "created": 1718882934,
    "model": "mistral-7b",
    "usage": {
        "completion_tokens": 402,
        "prompt_tokens": 93,
        "guardrails _tokens": 677,
        "total_tokens": 1172
    }
}

-- Example 3938
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'llama2-70b-chat',
    [
        {'role': 'system', 'content': 'You are a helpful AI assistant. Analyze the movie review text and determine the overall sentiment. Answer with just \"Positive\", \"Negative\", or \"Neutral\"' },
        {'role': 'user', 'content': 'this was really good'}
    ], {}
    ) as response;

-- Example 3939
{
    "choices": [
        {
        "messages": " Positive"
        }
    ],
    "created": 1708479449,
    "model": "llama2-70b-chat",
    "usage": {
        "completion_tokens": 3,
        "prompt_tokens": 64,
        "total_tokens": 67
    }
}

-- Example 3940
COMPLETE_TASK_GRAPHS(
      [ RESULT_LIMIT => <integer> ]
      [, ROOT_TASK_NAME => '<string>' ]
      [, ERROR_ONLY => { TRUE | FALSE } ] )

-- Example 3941
select *
  from table(information_schema.complete_task_graphs())
  order by scheduled_time;

-- Example 3942
select *
  from table(information_schema.complete_task_graphs (
    result_limit => 10,
    root_task_name=>'MYTASK'));

-- Example 3943
COMPRESS(<input>, <method>)

-- Example 3944
SELECT COMPRESS('Snowflake', 'SNAPPY');
+---------------------------------+
| COMPRESS('SNOWFLAKE', 'SNAPPY') |
|---------------------------------|
| 0920536E6F77666C616B65          |
+---------------------------------+

-- Example 3945
CONCAT( <expr> [ , <expr> ... ] )

<expr> || <expr> [ || <expr> ... ]

-- Example 3946
SELECT CONCAT('George Washington ', 'Carver');

-- Example 3947
+----------------------------------------+
| CONCAT('GEORGE WASHINGTON ', 'CARVER') |
|----------------------------------------|
| George Washington Carver               |
+----------------------------------------+

-- Example 3948
CREATE OR REPLACE TABLE concat_function_example (s1 VARCHAR, s2 VARCHAR, s3 VARCHAR);
INSERT INTO concat_function_example (s1, s2, s3) VALUES
  ('co', 'd', 'e'),
  ('Colorado ', 'River ', NULL);

-- Example 3949
SELECT CONCAT(s1, s2)
  FROM concat_function_example;

-- Example 3950
+-----------------+
| CONCAT(S1, S2)  |
|-----------------|
| cod             |
| Colorado River  |
+-----------------+

-- Example 3951
SELECT CONCAT(s1, s2, s3)
  FROM concat_function_example;

-- Example 3952
+--------------------+
| CONCAT(S1, S2, S3) |
|--------------------|
| code               |
| NULL               |
+--------------------+

-- Example 3953
SELECT CONCAT(
    IFF(s1 IS NULL, '', s1),
    IFF(s2 IS NULL, '', s2),
    IFF(s3 IS NULL, '', s3)) AS concat_non_null_strings
  FROM concat_function_example;

-- Example 3954
+-------------------------+
| CONCAT_NON_NULL_STRINGS |
|-------------------------|
| code                    |
| Colorado River          |
+-------------------------+

-- Example 3955
SELECT 'This ' || 'is ' || 'another ' || 'concatenation ' || 'technique.';

-- Example 3956
+--------------------------------------------------------------------+
| 'THIS ' || 'IS ' || 'ANOTHER ' || 'CONCATENATION ' || 'TECHNIQUE.' |
|--------------------------------------------------------------------|
| This is another concatenation technique.                           |
+--------------------------------------------------------------------+

-- Example 3957
CONCAT_WS( <separator> , <expression1> [ , <expressionN> ... ] )

-- Example 3958
SELECT CONCAT_WS(',', 'one', 'two', 'three');
+---------------------------------------+
| CONCAT_WS(',', 'ONE', 'TWO', 'THREE') |
|---------------------------------------|
| one,two,three                         |
+---------------------------------------+

-- Example 3959
SELECT CONCAT_WS(',', 'one');
+-----------------------+
| CONCAT_WS(',', 'ONE') |
|-----------------------|
| one                   |
+-----------------------+

-- Example 3960
CONDITIONAL_CHANGE_EVENT( <expr1> ) OVER ( [ PARTITION BY <expr2> ] ORDER BY <expr3> )

-- Example 3961
CREATE TABLE voltage_readings (
    site_ID INTEGER, -- which refrigerator the measurement was taken in.
    ts TIMESTAMP,  -- the time at which the temperature was measured.
    VOLTAGE FLOAT
    );
INSERT INTO voltage_readings (site_ID, ts, voltage) VALUES
    (1, '2019-10-30 13:00:00', 120),
    (1, '2019-10-30 13:15:00', 120),
    (1, '2019-10-30 13:30:00',   0),
    (1, '2019-10-30 13:45:00',   0),
    (1, '2019-10-30 14:00:00',   0),
    (1, '2019-10-30 14:15:00',   0),
    (1, '2019-10-30 14:30:00', 120)
    ;

-- Example 3962
SELECT site_ID, ts, voltage
    FROM voltage_readings
    WHERE voltage = 0
    ORDER BY ts;
+---------+-------------------------+---------+
| SITE_ID | TS                      | VOLTAGE |
|---------+-------------------------+---------|
|       1 | 2019-10-30 13:30:00.000 |       0 |
|       1 | 2019-10-30 13:45:00.000 |       0 |
|       1 | 2019-10-30 14:00:00.000 |       0 |
|       1 | 2019-10-30 14:15:00.000 |       0 |
+---------+-------------------------+---------+

-- Example 3963
SELECT
      site_ID,
      ts,
      voltage,
      CONDITIONAL_CHANGE_EVENT(voltage = 0) OVER (ORDER BY ts) AS power_changes
    FROM voltage_readings;
+---------+-------------------------+---------+---------------+
| SITE_ID | TS                      | VOLTAGE | POWER_CHANGES |
|---------+-------------------------+---------+---------------|
|       1 | 2019-10-30 13:00:00.000 |     120 |             0 |
|       1 | 2019-10-30 13:15:00.000 |     120 |             0 |
|       1 | 2019-10-30 13:30:00.000 |       0 |             1 |
|       1 | 2019-10-30 13:45:00.000 |       0 |             1 |
|       1 | 2019-10-30 14:00:00.000 |       0 |             1 |
|       1 | 2019-10-30 14:15:00.000 |       0 |             1 |
|       1 | 2019-10-30 14:30:00.000 |     120 |             2 |
+---------+-------------------------+---------+---------------+

-- Example 3964
WITH power_change_events AS
    (
    SELECT
      site_ID,
      ts,
      voltage,
      CONDITIONAL_CHANGE_EVENT(voltage = 0) OVER (ORDER BY ts) AS power_changes
    FROM voltage_readings
    )
SELECT
      site_ID,
      MIN(ts),
      voltage,
      power_changes
    FROM power_change_events
    GROUP BY site_ID, power_changes, voltage
    ORDER BY 2
    ;
+---------+-------------------------+---------+---------------+
| SITE_ID | MIN(TS)                 | VOLTAGE | POWER_CHANGES |
|---------+-------------------------+---------+---------------|
|       1 | 2019-10-30 13:00:00.000 |     120 |             0 |
|       1 | 2019-10-30 13:30:00.000 |       0 |             1 |
|       1 | 2019-10-30 14:30:00.000 |     120 |             2 |
+---------+-------------------------+---------+---------------+

-- Example 3965
WITH power_change_events AS
    (
    SELECT
          site_ID,
          CONDITIONAL_CHANGE_EVENT(voltage = 0) OVER (ORDER BY ts) AS power_changes
        FROM voltage_readings
    )
SELECT MAX(power_changes) 
    FROM power_change_events
    GROUP BY site_ID
    ;
+--------------------+
| MAX(POWER_CHANGES) |
|--------------------|
|                  2 |
+--------------------+

-- Example 3966
CREATE TABLE table1 (province VARCHAR, o_col INTEGER, o2_col INTEGER);
INSERT INTO table1 (province, o_col, o2_col) VALUES
    ('Alberta',    0, 10),
    ('Alberta',    0, 10),
    ('Alberta',   13, 10),
    ('Alberta',   13, 11),
    ('Alberta',   14, 11),
    ('Alberta',   15, 12),
    ('Alberta', NULL, NULL),
    ('Manitoba',    30, 30);

-- Example 3967
SELECT province, o_col,
      CONDITIONAL_CHANGE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS change_event
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+--------------+
| PROVINCE | O_COL | CHANGE_EVENT |
|----------+-------+--------------|
| Alberta  |     0 |            0 |
| Alberta  |     0 |            0 |
| Alberta  |    13 |            1 |
| Alberta  |    13 |            1 |
| Alberta  |    14 |            2 |
| Alberta  |    15 |            3 |
| Alberta  |  NULL |            3 |
| Manitoba |    30 |            0 |
+----------+-------+--------------+

-- Example 3968
SELECT province, o_col,
      'o_col < 15' AS condition,
      CONDITIONAL_CHANGE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS change_event,
      CONDITIONAL_CHANGE_EVENT(o_col < 15) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS change_event_2
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+------------+--------------+----------------+
| PROVINCE | O_COL | CONDITION  | CHANGE_EVENT | CHANGE_EVENT_2 |
|----------+-------+------------+--------------+----------------|
| Alberta  |     0 | o_col < 15 |            0 |              0 |
| Alberta  |     0 | o_col < 15 |            0 |              0 |
| Alberta  |    13 | o_col < 15 |            1 |              0 |
| Alberta  |    13 | o_col < 15 |            1 |              0 |
| Alberta  |    14 | o_col < 15 |            2 |              0 |
| Alberta  |    15 | o_col < 15 |            3 |              1 |
| Alberta  |  NULL | o_col < 15 |            3 |              1 |
| Manitoba |    30 | o_col < 15 |            0 |              0 |
+----------+-------+------------+--------------+----------------+

-- Example 3969
SELECT province, o_col,
      CONDITIONAL_CHANGE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS change_event,
      CONDITIONAL_TRUE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS true_event
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+--------------+------------+
| PROVINCE | O_COL | CHANGE_EVENT | TRUE_EVENT |
|----------+-------+--------------+------------|
| Alberta  |     0 |            0 |          0 |
| Alberta  |     0 |            0 |          0 |
| Alberta  |    13 |            1 |          1 |
| Alberta  |    13 |            1 |          2 |
| Alberta  |    14 |            2 |          3 |
| Alberta  |    15 |            3 |          4 |
| Alberta  |  NULL |            3 |          4 |
| Manitoba |    30 |            0 |          1 |
+----------+-------+--------------+------------+

-- Example 3970
CREATE TABLE borrowers (
    name VARCHAR,
    status_date DATE,
    late_balance NUMERIC(11, 2),
    thirty_day_late_balance NUMERIC(11, 2)
    );
INSERT INTO borrowers (name, status_date, late_balance, thirty_day_late_balance) VALUES

    -- Pays late frequently, but catches back up rather than falling further
    -- behind.
    ('Geoffrey Flake', '2018-01-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-02-01'::DATE, 1000.0,    0.0),
    ('Geoffrey Flake', '2018-03-01'::DATE, 2000.0, 1000.0),
    ('Geoffrey Flake', '2018-04-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-05-01'::DATE, 1000.0,    0.0),
    ('Geoffrey Flake', '2018-06-01'::DATE, 2000.0, 1000.0),
    ('Geoffrey Flake', '2018-07-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-08-01'::DATE,    0.0,    0.0),

    -- Keeps falling further behind.
    ('Cy Dismal', '2018-01-01'::DATE,    0.0,    0.0),
    ('Cy Dismal', '2018-02-01'::DATE,    0.0,    0.0),
    ('Cy Dismal', '2018-03-01'::DATE, 1000.0,    0.0),
    ('Cy Dismal', '2018-04-01'::DATE, 2000.0, 1000.0),
    ('Cy Dismal', '2018-05-01'::DATE, 3000.0, 2000.0),
    ('Cy Dismal', '2018-06-01'::DATE, 4000.0, 3000.0),
    ('Cy Dismal', '2018-07-01'::DATE, 5000.0, 4000.0),
    ('Cy Dismal', '2018-08-01'::DATE, 6000.0, 5000.0),

    -- Fell behind and isn't catching up, but isn't falling further and 
    -- further behind. Essentially, this person just 'failed' once.
    ('Leslie Safer', '2018-01-01'::DATE,    0.0,    0.0),
    ('Leslie Safer', '2018-02-01'::DATE,    0.0,    0.0),
    ('Leslie Safer', '2018-03-01'::DATE, 1000.0, 1000.0),
    ('Leslie Safer', '2018-04-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-05-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-06-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-07-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-08-01'::DATE, 2000.0, 1000.0),

    -- Always pays on time and in full.
    ('Ida Idyll', '2018-01-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-02-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-03-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-04-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-05-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-06-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-07-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-08-01'::DATE,    0.0,    0.0)

    ;

-- Example 3971
SELECT name, status_date, late_balance AS "OVERDUE", 
        thirty_day_late_balance AS "30 DAYS OVERDUE",
        CONDITIONAL_CHANGE_EVENT(thirty_day_late_balance) 
          OVER (PARTITION BY name ORDER BY status_date) AS change_event_cnt,
        CONDITIONAL_TRUE_EVENT(thirty_day_late_balance) 
          OVER (PARTITION BY name ORDER BY status_date) AS true_cnt
    FROM borrowers
    ORDER BY name, status_date
    ;
+----------------+-------------+---------+-----------------+------------------+----------+
| NAME           | STATUS_DATE | OVERDUE | 30 DAYS OVERDUE | CHANGE_EVENT_CNT | TRUE_CNT |
|----------------+-------------+---------+-----------------+------------------+----------|
| Cy Dismal      | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-03-01  | 1000.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-04-01  | 2000.00 |         1000.00 |                1 |        1 |
| Cy Dismal      | 2018-05-01  | 3000.00 |         2000.00 |                2 |        2 |
| Cy Dismal      | 2018-06-01  | 4000.00 |         3000.00 |                3 |        3 |
| Cy Dismal      | 2018-07-01  | 5000.00 |         4000.00 |                4 |        4 |
| Cy Dismal      | 2018-08-01  | 6000.00 |         5000.00 |                5 |        5 |
| Geoffrey Flake | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Geoffrey Flake | 2018-02-01  | 1000.00 |            0.00 |                0 |        0 |
| Geoffrey Flake | 2018-03-01  | 2000.00 |         1000.00 |                1 |        1 |
| Geoffrey Flake | 2018-04-01  |    0.00 |            0.00 |                2 |        1 |
| Geoffrey Flake | 2018-05-01  | 1000.00 |            0.00 |                2 |        1 |
| Geoffrey Flake | 2018-06-01  | 2000.00 |         1000.00 |                3 |        2 |
| Geoffrey Flake | 2018-07-01  |    0.00 |            0.00 |                4 |        2 |
| Geoffrey Flake | 2018-08-01  |    0.00 |            0.00 |                4 |        2 |
| Ida Idyll      | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-03-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-04-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-05-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-06-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-07-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-08-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-03-01  | 1000.00 |         1000.00 |                1 |        1 |
| Leslie Safer   | 2018-04-01  | 2000.00 |         1000.00 |                1 |        2 |
| Leslie Safer   | 2018-05-01  | 2000.00 |         1000.00 |                1 |        3 |
| Leslie Safer   | 2018-06-01  | 2000.00 |         1000.00 |                1 |        4 |
| Leslie Safer   | 2018-07-01  | 2000.00 |         1000.00 |                1 |        5 |
| Leslie Safer   | 2018-08-01  | 2000.00 |         1000.00 |                1 |        6 |
+----------------+-------------+---------+-----------------+------------------+----------+

-- Example 3972
CREATE OR REPLACE TABLE tbl
(p int, o int, i int, r int, s varchar(100));

INSERT INTO tbl VALUES
(100,1,1,70,'seventy'),(100,2,2,30, 'thirty'),(100,3,3,40,'fourty'),(100,4,NULL,90,'ninety'),(100,5,5,50,'fifty'),(100,6,6,30,'thirty'),
(200,7,7,40,'fourty'),(200,8,NULL,NULL,'n_u_l_l'),(200,9,NULL,NULL,'n_u_l_l'),(200,10,10,20,'twenty'),(200,11,NULL,90,'ninety'),
(300,12,12,30,'thirty'),
(400,13,NULL,20,'twenty');

SELECT * FROM tbl ORDER BY p, o, i;

+-----+----+--------+--------+---------+
|  P  | O  |   I    |   R    |    S    |
+-----+----+--------+--------+---------+
| 100 | 1  | 1      | 70     | seventy |
| 100 | 2  | 2      | 30     | thirty  |
| 100 | 3  | 3      | 40     | fourty  |
| 100 | 4  | [NULL] | 90     | ninety  |
| 100 | 5  | 5      | 50     | fifty   |
| 100 | 6  | 6      | 30     | thirty  |
| 200 | 7  | 7      | 40     | fourty  |
| 200 | 8  | [NULL] | [NULL] | n_u_l_l |
| 200 | 9  | [NULL] | [NULL] | n_u_l_l |
| 200 | 10 | 10     | 20     | twenty  |
| 200 | 11 | [NULL] | 90     | ninety  |
| 300 | 12 | 12     | 30     | thirty  |
| 400 | 13 | [NULL] | 20     | twenty  |
+-----+----+--------+--------+---------+

SELECT p, o, CONDITIONAL_CHANGE_EVENT(o) OVER (PARTITION BY p ORDER BY o) FROM tbl ORDER BY p, o;

+-----+----+--------------------------------------------------------------+
|   P |  O | CONDITIONAL_CHANGE_EVENT(O) OVER (PARTITION BY P ORDER BY O) |
|-----+----+--------------------------------------------------------------|
| 100 |  1 |                                                            0 |
| 100 |  2 |                                                            1 |
| 100 |  3 |                                                            2 |
| 100 |  4 |                                                            3 |
| 100 |  5 |                                                            4 |
| 100 |  6 |                                                            5 |
| 200 |  7 |                                                            0 |
| 200 |  8 |                                                            1 |
| 200 |  9 |                                                            2 |
| 200 | 10 |                                                            3 |
| 200 | 11 |                                                            4 |
| 300 | 12 |                                                            0 |
| 400 | 13 |                                                            0 |
+-----+----+--------------------------------------------------------------+

-- Example 3973
CONDITIONAL_TRUE_EVENT( <expr1> ) OVER ( [ PARTITION BY <expr2> ] ORDER BY <expr3> )

-- Example 3974
CREATE TABLE table1 (province VARCHAR, o_col INTEGER, o2_col INTEGER);
INSERT INTO table1 (province, o_col, o2_col) VALUES
    ('Alberta',    0, 10),
    ('Alberta',    0, 10),
    ('Alberta',   13, 10),
    ('Alberta',   13, 11),
    ('Alberta',   14, 11),
    ('Alberta',   15, 12),
    ('Alberta', NULL, NULL),
    ('Manitoba',    30, 30);

-- Example 3975
SELECT province, o_col, 
      CONDITIONAL_TRUE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS true_event
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+------------+
| PROVINCE | O_COL | TRUE_EVENT |
|----------+-------+------------|
| Alberta  |     0 |          0 |
| Alberta  |     0 |          0 |
| Alberta  |    13 |          1 |
| Alberta  |    13 |          2 |
| Alberta  |    14 |          3 |
| Alberta  |    15 |          4 |
| Alberta  |  NULL |          4 |
| Manitoba |    30 |          1 |
+----------+-------+------------+

-- Example 3976
SELECT province, o_col, 
      CONDITIONAL_TRUE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS true_event,
      CONDITIONAL_TRUE_EVENT(o_col > 20) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS true_event_gt_20
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+------------+------------------+
| PROVINCE | O_COL | TRUE_EVENT | TRUE_EVENT_GT_20 |
|----------+-------+------------+------------------|
| Alberta  |     0 |          0 |                0 |
| Alberta  |     0 |          0 |                0 |
| Alberta  |    13 |          1 |                0 |
| Alberta  |    13 |          2 |                0 |
| Alberta  |    14 |          3 |                0 |
| Alberta  |    15 |          4 |                0 |
| Alberta  |  NULL |          4 |                0 |
| Manitoba |    30 |          1 |                1 |
+----------+-------+------------+------------------+

-- Example 3977
SELECT province, o_col,
      CONDITIONAL_CHANGE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS change_event,
      CONDITIONAL_TRUE_EVENT(o_col) 
        OVER (PARTITION BY province ORDER BY o_col) 
          AS true_event
    FROM table1
    ORDER BY province, o_col
    ;
+----------+-------+--------------+------------+
| PROVINCE | O_COL | CHANGE_EVENT | TRUE_EVENT |
|----------+-------+--------------+------------|
| Alberta  |     0 |            0 |          0 |
| Alberta  |     0 |            0 |          0 |
| Alberta  |    13 |            1 |          1 |
| Alberta  |    13 |            1 |          2 |
| Alberta  |    14 |            2 |          3 |
| Alberta  |    15 |            3 |          4 |
| Alberta  |  NULL |            3 |          4 |
| Manitoba |    30 |            0 |          1 |
+----------+-------+--------------+------------+

-- Example 3978
CREATE TABLE borrowers (
    name VARCHAR,
    status_date DATE,
    late_balance NUMERIC(11, 2),
    thirty_day_late_balance NUMERIC(11, 2)
    );
INSERT INTO borrowers (name, status_date, late_balance, thirty_day_late_balance) VALUES

    -- Pays late frequently, but catches back up rather than falling further
    -- behind.
    ('Geoffrey Flake', '2018-01-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-02-01'::DATE, 1000.0,    0.0),
    ('Geoffrey Flake', '2018-03-01'::DATE, 2000.0, 1000.0),
    ('Geoffrey Flake', '2018-04-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-05-01'::DATE, 1000.0,    0.0),
    ('Geoffrey Flake', '2018-06-01'::DATE, 2000.0, 1000.0),
    ('Geoffrey Flake', '2018-07-01'::DATE,    0.0,    0.0),
    ('Geoffrey Flake', '2018-08-01'::DATE,    0.0,    0.0),

    -- Keeps falling further behind.
    ('Cy Dismal', '2018-01-01'::DATE,    0.0,    0.0),
    ('Cy Dismal', '2018-02-01'::DATE,    0.0,    0.0),
    ('Cy Dismal', '2018-03-01'::DATE, 1000.0,    0.0),
    ('Cy Dismal', '2018-04-01'::DATE, 2000.0, 1000.0),
    ('Cy Dismal', '2018-05-01'::DATE, 3000.0, 2000.0),
    ('Cy Dismal', '2018-06-01'::DATE, 4000.0, 3000.0),
    ('Cy Dismal', '2018-07-01'::DATE, 5000.0, 4000.0),
    ('Cy Dismal', '2018-08-01'::DATE, 6000.0, 5000.0),

    -- Fell behind and isn't catching up, but isn't falling further and 
    -- further behind. Essentially, this person just 'failed' once.
    ('Leslie Safer', '2018-01-01'::DATE,    0.0,    0.0),
    ('Leslie Safer', '2018-02-01'::DATE,    0.0,    0.0),
    ('Leslie Safer', '2018-03-01'::DATE, 1000.0, 1000.0),
    ('Leslie Safer', '2018-04-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-05-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-06-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-07-01'::DATE, 2000.0, 1000.0),
    ('Leslie Safer', '2018-08-01'::DATE, 2000.0, 1000.0),

    -- Always pays on time and in full.
    ('Ida Idyll', '2018-01-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-02-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-03-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-04-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-05-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-06-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-07-01'::DATE,    0.0,    0.0),
    ('Ida Idyll', '2018-08-01'::DATE,    0.0,    0.0)

    ;

-- Example 3979
SELECT name, status_date, late_balance AS "OVERDUE", 
        thirty_day_late_balance AS "30 DAYS OVERDUE",
        CONDITIONAL_CHANGE_EVENT(thirty_day_late_balance) 
          OVER (PARTITION BY name ORDER BY status_date) AS change_event_cnt,
        CONDITIONAL_TRUE_EVENT(thirty_day_late_balance) 
          OVER (PARTITION BY name ORDER BY status_date) AS true_cnt
    FROM borrowers
    ORDER BY name, status_date
    ;
+----------------+-------------+---------+-----------------+------------------+----------+
| NAME           | STATUS_DATE | OVERDUE | 30 DAYS OVERDUE | CHANGE_EVENT_CNT | TRUE_CNT |
|----------------+-------------+---------+-----------------+------------------+----------|
| Cy Dismal      | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-03-01  | 1000.00 |            0.00 |                0 |        0 |
| Cy Dismal      | 2018-04-01  | 2000.00 |         1000.00 |                1 |        1 |
| Cy Dismal      | 2018-05-01  | 3000.00 |         2000.00 |                2 |        2 |
| Cy Dismal      | 2018-06-01  | 4000.00 |         3000.00 |                3 |        3 |
| Cy Dismal      | 2018-07-01  | 5000.00 |         4000.00 |                4 |        4 |
| Cy Dismal      | 2018-08-01  | 6000.00 |         5000.00 |                5 |        5 |
| Geoffrey Flake | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Geoffrey Flake | 2018-02-01  | 1000.00 |            0.00 |                0 |        0 |
| Geoffrey Flake | 2018-03-01  | 2000.00 |         1000.00 |                1 |        1 |
| Geoffrey Flake | 2018-04-01  |    0.00 |            0.00 |                2 |        1 |
| Geoffrey Flake | 2018-05-01  | 1000.00 |            0.00 |                2 |        1 |
| Geoffrey Flake | 2018-06-01  | 2000.00 |         1000.00 |                3 |        2 |
| Geoffrey Flake | 2018-07-01  |    0.00 |            0.00 |                4 |        2 |
| Geoffrey Flake | 2018-08-01  |    0.00 |            0.00 |                4 |        2 |
| Ida Idyll      | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-03-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-04-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-05-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-06-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-07-01  |    0.00 |            0.00 |                0 |        0 |
| Ida Idyll      | 2018-08-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-01-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-02-01  |    0.00 |            0.00 |                0 |        0 |
| Leslie Safer   | 2018-03-01  | 1000.00 |         1000.00 |                1 |        1 |
| Leslie Safer   | 2018-04-01  | 2000.00 |         1000.00 |                1 |        2 |
| Leslie Safer   | 2018-05-01  | 2000.00 |         1000.00 |                1 |        3 |
| Leslie Safer   | 2018-06-01  | 2000.00 |         1000.00 |                1 |        4 |
| Leslie Safer   | 2018-07-01  | 2000.00 |         1000.00 |                1 |        5 |
| Leslie Safer   | 2018-08-01  | 2000.00 |         1000.00 |                1 |        6 |
+----------------+-------------+---------+-----------------+------------------+----------+

-- Example 3980
CREATE OR REPLACE TABLE tbl
(p int, o int, i int, r int, s varchar(100));

INSERT INTO tbl VALUES
(100,1,1,70,'seventy'),(100,2,2,30, 'thirty'),(100,3,3,40,'fourty'),(100,4,NULL,90,'ninety'),(100,5,5,50,'fifty'),(100,6,6,30,'thirty'),
(200,7,7,40,'fourty'),(200,8,NULL,NULL,'n_u_l_l'),(200,9,NULL,NULL,'n_u_l_l'),(200,10,10,20,'twenty'),(200,11,NULL,90,'ninety'),
(300,12,12,30,'thirty'),
(400,13,NULL,20,'twenty');

SELECT * FROM tbl ORDER BY p, o, i;

+-----+----+--------+--------+---------+
|  P  | O  |   I    |   R    |    S    |
+-----+----+--------+--------+---------+
| 100 | 1  | 1      | 70     | seventy |
| 100 | 2  | 2      | 30     | thirty  |
| 100 | 3  | 3      | 40     | fourty  |
| 100 | 4  | [NULL] | 90     | ninety  |
| 100 | 5  | 5      | 50     | fifty   |
| 100 | 6  | 6      | 30     | thirty  |
| 200 | 7  | 7      | 40     | fourty  |
| 200 | 8  | [NULL] | [NULL] | n_u_l_l |
| 200 | 9  | [NULL] | [NULL] | n_u_l_l |
| 200 | 10 | 10     | 20     | twenty  |
| 200 | 11 | [NULL] | 90     | ninety  |
| 300 | 12 | 12     | 30     | thirty  |
| 400 | 13 | [NULL] | 20     | twenty  |
+-----+----+--------+--------+---------+

SELECT p, o, CONDITIONAL_TRUE_EVENT(o>2) OVER (PARTITION BY p ORDER BY o) FROM tbl ORDER BY p, o;

+-----+----+--------------------------------------------------------------+
|   P |  O | CONDITIONAL_TRUE_EVENT(O>2) OVER (PARTITION BY P ORDER BY O) |
|-----+----+--------------------------------------------------------------|
| 100 |  1 |                                                            0 |
| 100 |  2 |                                                            0 |
| 100 |  3 |                                                            1 |
| 100 |  4 |                                                            2 |
| 100 |  5 |                                                            3 |
| 100 |  6 |                                                            4 |
| 200 |  7 |                                                            1 |
| 200 |  8 |                                                            2 |
| 200 |  9 |                                                            3 |
| 200 | 10 |                                                            4 |
| 200 | 11 |                                                            5 |
| 300 | 12 |                                                            1 |
| 400 | 13 |                                                            1 |
+-----+----+--------------------------------------------------------------+

SELECT p, o, CONDITIONAL_TRUE_EVENT(LAG(O) OVER (PARTITION BY P ORDER BY O) >1) OVER (PARTITION BY P ORDER BY O) FROM tbl ORDER BY p, o;

+-----+----+-----------------------------------------------------------------------------------------------------+
|   P |  O | CONDITIONAL_TRUE_EVENT(LAG(O) OVER (PARTITION BY P ORDER BY O) >1) OVER (PARTITION BY P ORDER BY O) |
|-----+----+-----------------------------------------------------------------------------------------------------|
| 100 |  1 |                                                                                                   0 |
| 100 |  2 |                                                                                                   0 |
| 100 |  3 |                                                                                                   1 |
| 100 |  4 |                                                                                                   2 |
| 100 |  5 |                                                                                                   3 |
| 100 |  6 |                                                                                                   4 |
| 200 |  7 |                                                                                                   0 |
| 200 |  8 |                                                                                                   1 |
| 200 |  9 |                                                                                                   2 |
| 200 | 10 |                                                                                                   3 |
| 200 | 11 |                                                                                                   4 |
| 300 | 12 |                                                                                                   0 |
| 400 | 13 |                                                                                                   0 |
+-----+----+-----------------------------------------------------------------------------------------------------+

-- Example 3981
CONTAINS( <expr1> , <expr2> )

-- Example 3982
CREATE OR REPLACE TABLE strings_test (s VARCHAR);

INSERT INTO strings_test values
  ('coffee'),
  ('ice tea'),
  ('latte'),
  ('tea'),
  (NULL);

SELECT * from strings_test;

-- Example 3983
+---------+
| S       |
|---------|
| coffee  |
| ice tea |
| latte   |
| tea     |
| NULL    |
+---------+

-- Example 3984
SELECT * FROM strings_test WHERE CONTAINS(s, 'te');

-- Example 3985
+---------+
| S       |
|---------|
| ice tea |
| latte   |
| tea     |
+---------+

-- Example 3986
SELECT CONTAINS(COLLATE('ñ', 'en-ci-ai'), 'n'),
       CONTAINS(COLLATE('ñ', 'es-ci-ai'), 'n');

-- Example 3987
+-----------------------------------------+-----------------------------------------+
| CONTAINS(COLLATE('Ñ', 'EN-CI-AI'), 'N') | CONTAINS(COLLATE('Ñ', 'ES-CI-AI'), 'N') |
|-----------------------------------------+-----------------------------------------|
| True                                    | False                                   |
+-----------------------------------------+-----------------------------------------+

-- Example 3988
CONVERT_TIMEZONE( <source_tz> , <target_tz> , <source_timestamp_ntz> )

CONVERT_TIMEZONE( <target_tz> , <source_timestamp> )

-- Example 3989
ALTER SESSION UNSET TIMESTAMP_OUTPUT_FORMAT;

-- Example 3990
SELECT CONVERT_TIMEZONE(
  'America/Los_Angeles',
  'America/New_York',
  '2024-01-01 14:00:00'::TIMESTAMP_NTZ
) AS conv;

-- Example 3991
+-------------------------+
| CONV                    |
|-------------------------|
| 2024-01-01 17:00:00.000 |
+-------------------------+

-- Example 3992
SELECT CONVERT_TIMEZONE(
  'Europe/Warsaw',
  'UTC',
  '2024-01-01 00:00:00'::TIMESTAMP_NTZ
) AS conv;

-- Example 3993
+-------------------------+
| CONV                    |
|-------------------------|
| 2023-12-31 23:00:00.000 |
+-------------------------+

-- Example 3994
SELECT CONVERT_TIMEZONE(
  'America/Los_Angeles',
  '2024-04-05 12:00:00 +02:00'
) AS time_in_la;

-- Example 3995
+-------------------------------+
| TIME_IN_LA                    |
|-------------------------------|
| 2024-04-05 03:00:00.000 -0700 |
+-------------------------------+

-- Example 3996
SELECT
  CURRENT_TIMESTAMP() AS now_in_la,
  CONVERT_TIMEZONE('America/New_York', CURRENT_TIMESTAMP()) AS now_in_nyc,
  CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()) AS now_in_paris,
  CONVERT_TIMEZONE('Asia/Tokyo', CURRENT_TIMESTAMP()) AS now_in_tokyo;

-- Example 3997
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+
| NOW_IN_LA                     | NOW_IN_NYC                    | NOW_IN_PARIS                  | NOW_IN_TOKYO                  |
|-------------------------------+-------------------------------+-------------------------------+-------------------------------|
| 2024-06-12 08:52:53.114 -0700 | 2024-06-12 11:52:53.114 -0400 | 2024-06-12 17:52:53.114 +0200 | 2024-06-13 00:52:53.114 +0900 |
+-------------------------------+-------------------------------+-------------------------------+-------------------------------+

-- Example 3998
COPY_HISTORY(
      TABLE_NAME => '<string>'
       , START_TIME => <constant_expr>
      [, END_TIME => <constant_expr> ] )

-- Example 3999
select *
from table(information_schema.copy_history(TABLE_NAME=>'MYTABLE', START_TIME=> DATEADD(hours, -1, CURRENT_TIMESTAMP())));

-- Example 4000
CORTEX_SEARCH_DATA_SCAN(
      SERVICE_NAME => '<string>' )

-- Example 4001
CREATE OR REPLACE CORTEX SEARCH SERVICE transcript_search_service
  ON transcript_text
  ATTRIBUTES region
  WAREHOUSE = cortex_search_wh
  TARGET_LAG = '1 day'
  AS (
    SELECT
        transcript_text,
        region,
        agent_id,
    FROM support_transcripts
);

-- Example 4002
SELECT
  *
FROM
  TABLE (
    CORTEX_SEARCH_DATA_SCAN (
      SERVICE_NAME => 'transcript_search_service'
    )
  );

