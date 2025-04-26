-- Example 6011
SELECT * FROM lines
  WHERE line_id=34230;

-- Example 6012
+---------+--------+------------+----------------+-----------+--------------------------------------------+
| LINE_ID | PLAY   | SPEECH_NUM | ACT_SCENE_LINE | CHARACTER | LINE                                       |
|---------+--------+------------+----------------+-----------+--------------------------------------------|
|   34230 | Hamlet |         19 | 3.1.64         | HAMLET    | To be, or not to be, that is the question: |
+---------+--------+------------+----------------+-----------+--------------------------------------------+

-- Example 6013
CREATE OR REPLACE TABLE lines(
  line_id INT,
  play VARCHAR(50),
  speech_num INT,
  act_scene_line VARCHAR(10),
  character VARCHAR(30),
  line VARCHAR(2000)
  );

INSERT INTO lines VALUES
  (4,'Henry IV Part 1',1,'1.1.1','KING HENRY IV','So shaken as we are, so wan with care,'),
  (13,'Henry IV Part 1',1,'1.1.10','KING HENRY IV','Which, like the meteors of a troubled heaven,'),
  (9526,'Henry VI Part 3',1,'1.1.1','WARWICK','I wonder how the king escaped our hands.'),
  (12664,'All''s Well That Ends Well',1,'1.1.1','COUNTESS','In delivering my son from me, I bury a second husband.'),
  (15742,'All''s Well That Ends Well',114,'5.3.378','KING','Your gentle hands lend us, and take our hearts.'),
  (16448,'As You Like It',2,'2.3.6','ADAM','And wherefore are you gentle, strong and valiant?'),
  (24055,'The Comedy of Errors',14,'5.1.41','AEMELIA','Be quiet, people. Wherefore throng you hither?'),
  (28487,'Cymbeline',3,'1.1.10','First Gentleman','Is outward sorrow, though I think the king'),
  (33522,'Hamlet',1,'2.2.1','KING CLAUDIUS','Welcome, dear Rosencrantz and Guildenstern!'),
  (33556,'Hamlet',5,'2.2.35','KING CLAUDIUS','Thanks, Rosencrantz and gentle Guildenstern.'),
  (33557,'Hamlet',6,'2.2.36','QUEEN GERTRUDE','Thanks, Guildenstern and gentle Rosencrantz:'),
  (33776,'Hamlet',67,'2.2.241','HAMLET','Guildenstern? Ah, Rosencrantz! Good lads, how do ye both?'),
  (34230,'Hamlet',19,'3.1.64','HAMLET','To be, or not to be, that is the question:'),
  (35672,'Hamlet',7,'4.6.27','HORATIO','where I am. Rosencrantz and Guildenstern hold their'),
  (36289,'Hamlet',14,'5.2.60','HORATIO','So Guildenstern and Rosencrantz go to''t.'),
  (36640,'Hamlet',143,'5.2.389','First Ambassador','That Rosencrantz and Guildenstern are dead:'),
  (43494,'King John',1,'1.1.1','KING JOHN','Now, say, Chatillon, what would France with us?'),
  (43503,'King John',5,'1.1.10','CHATILLON','To this fair island and the territories,'),
  (49031,'King Lear',1,'1.1.1','KENT','I thought the king had more affected the Duke of'),
  (49040,'King Lear',4,'1.1.10','GLOUCESTER','so often blushed to acknowledge him, that now I am'),
  (52797,'Love''s Labour''s Lost',1,'1.1.1','FERDINAND','Let fame, that all hunt after in their lives,'),
  (55778,'Love''s Labour''s Lost',405,'5.2.971','ADRIANO DE ARMADO','Apollo. You that way: we this way.'),
  (67000,'A Midsummer Night''s Dream',1,'1.1.1','THESEUS','Now, fair Hippolyta, our nuptial hour'),
  (69296,'A Midsummer Night''s Dream',104,'5.1.428','PUCK','And Robin shall restore amends.'),
  (75787,'Pericles',178,'1.0.21','LODOVICO','This king unto him took a fere,'),
  (78407,'Richard II',1,'1.1.1','KING RICHARD II','Old John of Gaunt, time-honour''d Lancaster,'),
  (91998,'The Tempest',108,'1.2.500','FERDINAND','Were I but where ''tis spoken.'),
  (92454,'The Tempest',150,'2.1.343','ALONSO','Wherefore this ghastly looking?'),
  (99330,'Troilus and Cressida',30,'1.1.102','AENEAS','How now, Prince Troilus! wherefore not afield?'),
  (100109,'Troilus and Cressida',31,'2.1.53','ACHILLES','Why, how now, Ajax! wherefore do you thus? How now,'),
  (108464,'The Winter''s Tale',106,'1.2.500','CAMILLO','As or by oath remove or counsel shake')
  ;

-- Example 6014
SEARCH_IP( <search_data>, <search_string> )

-- Example 6015
ALTER TABLE ipt ADD SEARCH OPTIMIZATION ON FULL_TEXT(
  ip1,
  ANALYZER => 'ENTITY_ANALYZER');

-- Example 6016
CREATE OR REPLACE TABLE ipt(id INT, ip1 VARCHAR(20), ip2 VARCHAR(20));
INSERT INTO ipt VALUES(1, '192.0.2.146', '203.0.113.5');
INSERT INTO ipt VALUES(2, '192.0.2.111', '192.000.002.146');

-- Example 6017
SELECT ip1,
       ip2,
       SEARCH_IP((ip1, ip2), '192.0.2.146')
  FROM ipt
  ORDER BY ip1;

-- Example 6018
+-------------+-----------------+--------------------------------------+
| IP1         | IP2             | SEARCH_IP((IP1, IP2), '192.0.2.146') |
|-------------+-----------------+--------------------------------------|
| 192.0.2.111 | 192.000.002.146 | True                                 |
| 192.0.2.146 | 203.0.113.5     | True                                 |
+-------------+-----------------+--------------------------------------+

-- Example 6019
SELECT ip1,
       ip2,
       SEARCH_IP((ip1, ip2), '192.0.2.1/20')
  FROM ipt
  ORDER BY ip1;

-- Example 6020
+-------------+-----------------+---------------------------------------+
| IP1         | IP2             | SEARCH_IP((IP1, IP2), '192.0.2.1/20') |
|-------------+-----------------+---------------------------------------|
| 192.0.2.111 | 192.000.002.146 | True                                  |
| 192.0.2.146 | 203.0.113.5     | True                                  |
+-------------+-----------------+---------------------------------------+

-- Example 6021
SELECT ip1,
       ip2,
       SEARCH_IP((ip1, ip2), '203.000.113.005')
  FROM ipt
  ORDER BY ip1;

-- Example 6022
+-------------+-----------------+------------------------------------------+
| IP1         | IP2             | SEARCH_IP((IP1, IP2), '203.000.113.005') |
|-------------+-----------------+------------------------------------------|
| 192.0.2.111 | 192.000.002.146 | False                                    |
| 192.0.2.146 | 203.0.113.5     | True                                     |
+-------------+-----------------+------------------------------------------+

-- Example 6023
SELECT ip1,
       ip2
  FROM ipt
  WHERE SEARCH_IP(ip2, '203.0.113.5')
  ORDER BY ip1;

-- Example 6024
+-------------+-------------+
| IP1         | IP2         |
|-------------+-------------|
| 192.0.2.146 | 203.0.113.5 |
+-------------+-------------+

-- Example 6025
SELECT ip1,
       ip2
  FROM ipt
  WHERE SEARCH_IP(ip2, '203.0.113.1')
  ORDER BY ip1;

-- Example 6026
+-----+-----+
| IP1 | IP2 |
|-----+-----|
+-----+-----+

-- Example 6027
SELECT ip1,
       ip2
  FROM ipt
  WHERE SEARCH_IP((*), '203.0.113.5')
  ORDER BY ip1;

-- Example 6028
+-------------+-------------+
| IP1         | IP2         |
|-------------+-------------|
| 192.0.2.146 | 203.0.113.5 |
+-------------+-------------+

-- Example 6029
SELECT ip1,
       ip2
  FROM ipt
  WHERE SEARCH_IP(* ILIKE 'ip%', '192.0.2.111')
  ORDER BY ip1;

-- Example 6030
+-------------+-----------------+
| IP1         | IP2             |
|-------------+-----------------|
| 192.0.2.111 | 192.000.002.146 |
+-------------+-----------------+

-- Example 6031
ALTER TABLE ipt ADD SEARCH OPTIMIZATION ON FULL_TEXT(
  ip1,
  ip2,
  ANALYZER => 'ENTITY_ANALYZER');

-- Example 6032
CREATE OR REPLACE TABLE iptv(ip1 VARIANT);
INSERT INTO iptv(ip1)
  SELECT PARSE_JSON(' { "ipv1": "203.0.113.5", "ipv2": "203.0.113.5" } ');
INSERT INTO iptv(ip1)
  SELECT PARSE_JSON(' { "ipv1": "192.0.2.146", "ipv2": "203.0.113.5" } ');

-- Example 6033
SELECT * FROM iptv
  WHERE SEARCH_IP((ip1:"ipv1"), '203.0.113.5');

-- Example 6034
+--------------------------+
| IP1                      |
|--------------------------|
| {                        |
|   "ipv1": "203.0.113.5", |
|   "ipv2": "203.0.113.5"  |
| }                        |
+--------------------------+

-- Example 6035
SELECT * FROM iptv
  WHERE SEARCH_IP((ip1:"ipv1",ip1:"ipv2"), '203.0.113.5');

-- Example 6036
+--------------------------+
| IP1                      |
|--------------------------|
| {                        |
|   "ipv1": "203.0.113.5", |
|   "ipv2": "203.0.113.5"  |
| }                        |
| {                        |
|   "ipv1": "192.0.2.146", |
|   "ipv2": "203.0.113.5"  |
| }                        |
+--------------------------+

-- Example 6037
ALTER TABLE iptv ADD SEARCH OPTIMIZATION ON FULL_TEXT(
  ip1:"ipv1",
  ip1:"ipv2",
  ANALYZER => 'ENTITY_ANALYZER');

-- Example 6038
CREATE OR REPLACE TABLE ipt_log(id INT, ip_request_log VARCHAR(200));
INSERT INTO ipt_log VALUES(1, 'Connection from IP address 192.0.2.146 succeeded.');
INSERT INTO ipt_log VALUES(2, 'Connection from IP address 203.0.113.5 failed.');
INSERT INTO ipt_log VALUES(3, 'Connection from IP address 192.0.2.146 dropped.');

-- Example 6039
SELECT * FROM ipt_log
  WHERE SEARCH_IP(ip_request_log, '192.0.2.146')
  ORDER BY id;

-- Example 6040
+----+---------------------------------------------------+
| ID | IP_REQUEST_LOG                                    |
|----+---------------------------------------------------|
|  1 | Connection from IP address 192.0.2.146 succeeded. |
|  3 | Connection from IP address 192.0.2.146 dropped.   |
+----+---------------------------------------------------+

-- Example 6041
SELECT SEARCH_IP(ip1, 5) FROM ipt;

-- Example 6042
001045 (22023): SQL compilation error:
argument needs to be a string: '1'

-- Example 6043
SELECT SEARCH_IP(ip1, '1925.0.2.146') FROM ipt;

-- Example 6044
000937 (22023): SQL compilation error: error line 1 at position 22
invalid argument for function [SEARCH_IP(IPT.IP1, '1925.0.2.146')] unexpected argument [1925.0.2.146] at position 1,

-- Example 6045
SELECT SEARCH_IP(ip1, '') FROM ipt;

-- Example 6046
000937 (22023): SQL compilation error: error line 1 at position 22
invalid argument for function [SEARCH_IP(IPT.IP1, '')] unexpected argument [] at position 1,

-- Example 6047
SELECT SEARCH_IP(id, '192.0.2.146') FROM ipt;

-- Example 6048
001173 (22023): SQL compilation error: error line 1 at position 7: Expected non-empty set of columns supporting full-text search.

-- Example 6049
SELECT SEARCH_IP((id, ip1), '192.0.2.146') FROM ipt;

-- Example 6050
+-------------------------------------+
| SEARCH_IP((ID, IP1), '192.0.2.146') |
|-------------------------------------|
| True                                |
| False                               |
+-------------------------------------+

-- Example 6051
SEARCH_OPTIMIZATION_HISTORY(
      [ DATE_RANGE_START => <constant_expr> ]
      [ , DATE_RANGE_END => <constant_expr> ]
      [ , TABLE_NAME => '<string>' ] )

-- Example 6052
select *
  from table(information_schema.search_optimization_history(
    date_range_start=>'2019-05-22 19:00:00.000',
    date_range_end=>'2019-05-22 20:00:00.000'));

-- Example 6053
+-------------------------------+-------------------------------+--------------+----------------------------------+
| START_TIME                    | END_TIME                      | CREDITS_USED | TABLE_NAME                       |
|-------------------------------+-------------------------------+--------------+----------------------------------|
| 2019-05-22 19:00:00.000 -0700 | 2019-05-22 20:00:00.000 -0700 |  0.223276651 | TEST_DB.TEST_SCHEMA.TEST_TABLE_1 |
+-------------------------------+-------------------------------+--------------+----------------------------------+

-- Example 6054
select *
  from table(information_schema.search_optimization_history(
    date_range_start=>dateadd(H, -12, current_timestamp)));

-- Example 6055
select *
  from table(information_schema.search_optimization_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date,
    table_name=>'mydb.myschema.my_table')
    );

-- Example 6056
select *
  from table(information_schema.search_optimization_history(
    date_range_start=>dateadd(D, -7, current_date),
    date_range_end=>current_date)
    );

-- Example 6057
CREATE OR REPLACE TABLE test_table (id INT, c1 INT, c2 STRING, c3 DATE) AS
  SELECT * FROM VALUES
    (1, 3, '4',  '1985-05-11'),
    (2, 4, '3',  '1996-12-20'),
    (3, 2, '1',  '1974-02-03'),
    (4, 1, '2',  '2004-03-09'),
    (5, NULL, NULL, NULL);

-- Example 6058
ALTER TABLE test_table ADD SEARCH OPTIMIZATION;

-- Example 6059
SELECT * FROM test_table WHERE id = 2;

-- Example 6060
SELECT * FROM test_table WHERE c2 = '1';

-- Example 6061
SELECT * FROM test_table WHERE c3 = '1985-05-11';

-- Example 6062
SELECT * FROM test_table WHERE c1 IS NULL;

-- Example 6063
SELECT * FROM test_table WHERE c1 = 4 AND c3 = '1996-12-20';

-- Example 6064
SELECT * FROM test_table WHERE c2 = 2;

-- Example 6065
SELECT * FROM test_table WHERE CAST(c2 AS NUMBER) = 2;

-- Example 6066
SELECT id, c1, c2, c3
  FROM test_table
  WHERE id IN (2, 3)
  ORDER BY id;

-- Example 6067
SELECT id, c1, c2, c3
  FROM test_table
  WHERE c1 = 1
    AND c3 = TO_DATE('2004-03-09')
  ORDER BY id;

-- Example 6068
DELETE FROM test_table WHERE id = 3;

-- Example 6069
UPDATE test_table SET c1 = 99 WHERE id = 4;

-- Example 6070
SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    '<service_name>',
    '<query_parameters_object>'
)

-- Example 6071
{ "@eq": { "string_col": "value" } }

-- Example 6072
{ "@contains": { "array_col": "arr_value" } }

-- Example 6073
{ "@and": [
  { "@gte": { "numeric_col": 10.5 } },
  { "@lte": { "numeric_col": 12.5 } }
]}

-- Example 6074
{ "@and": [
  { "@gte": { "timestamp_col": "2024-11-19" } },
  { "@lte": { "timestamp_col": "2024-12-19" } }
]}

-- Example 6075
// Rows where the "array_col" column contains "arr_value" and the "string_col" column equals "value":
{
    "@and": [
      { "@contains": { "array_col": "arr_value" } },
      { "@eq": { "string_col": "value" } }
    ]
}

// Rows where the "string_col" column does not equal "value"
{
  "@not": { "@eq": { "string_col": "value" } }
}

// Rows where the "array_col" column contains at least one of "val1", "val2", or "val3"
{
  "@or": [
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } },
      { "@contains": { "array_col": "val1" } }
  ]
}

-- Example 6076
SELECT
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW (
      'mydb.mysch.sample_service',
      '{
          "query": "test query",
          "columns": ["col1", "col2"],
          "limit": 3
      }'
  );

-- Example 6077
{
  "results":[
      {"col1":"text", "col2":"text"},
      {"col1":"text", "col2":"text"},
      {"col1":"text", "col2":"text"}
  ],
  "request_id":"a27d1d85-e02c-4730-b320-74bf94f72d0d"
}

