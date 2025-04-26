-- Example 5743
+---------------+
| CITY          |
|---------------|
| San Francisco |
| San Jose      |
+---------------+

-- Example 5744
REGEXP_REPLACE( <subject> , <pattern> [ , <replacement> , <position> , <occurrence> , <parameters> ] )

-- Example 5745
SELECT REGEXP_REPLACE('Customers - (NY)','\\(|\\)','') AS customers;

-- Example 5746
+----------------+
| CUSTOMERS      |
|----------------|
| Customers - NY |
+----------------+

-- Example 5747
SELECT REGEXP_REPLACE('It was the best of times, it was the worst of times',
                      '( ){1,}',
                      '') AS result;

-- Example 5748
+------------------------------------------+
| RESULT                                   |
|------------------------------------------|
| Itwasthebestoftimes,itwastheworstoftimes |
+------------------------------------------+

-- Example 5749
SELECT REGEXP_REPLACE('It was the best of times, it was the worst of times',
                      'times',
                      'days',
                      1,
                      2) AS result;

-- Example 5750
+----------------------------------------------------+
| RESULT                                             |
|----------------------------------------------------|
| It was the best of times, it was the worst of days |
+----------------------------------------------------+

-- Example 5751
SELECT REGEXP_REPLACE('firstname middlename lastname',
                      '(.*) (.*) (.*)',
                      '\\3, \\1 \\2') AS name_sort;

-- Example 5752
+--------------------------------+
| NAME_SORT                      |
|--------------------------------|
| lastname, firstname middlename |
+--------------------------------+

-- Example 5753
REGEXP_SUBSTR( <subject> , <pattern> [ , <position> [ , <occurrence> [ , <regex_parameters> [ , <group_num> ] ] ] ] )

-- Example 5754
CREATE OR REPLACE TABLE demo2 (id INT, string1 VARCHAR);

INSERT INTO demo2 (id, string1) VALUES
    (2, 'It was the best of times, it was the worst of times.'),
    (3, 'In    the   string   the   extra   spaces  are   redundant.'),
    (4, 'A thespian theater is nearby.');

SELECT * FROM demo2;

-- Example 5755
+----+-------------------------------------------------------------+
| ID | STRING1                                                     |
|----+-------------------------------------------------------------|
|  2 | It was the best of times, it was the worst of times.        |
|  3 | In    the   string   the   extra   spaces  are   redundant. |
|  4 | A thespian theater is nearby.                               |
+----+-------------------------------------------------------------+

-- Example 5756
SELECT id,
       REGEXP_SUBSTR(string1, 'the\\W+\\w+') AS result
  FROM demo2
  ORDER BY id;

-- Example 5757
+----+--------------+
| ID | RESULT       |
|----+--------------|
|  2 | the best     |
|  3 | the   string |
|  4 | NULL         |
+----+--------------+

-- Example 5758
SELECT id,
       REGEXP_SUBSTR(string1, 'the\\W+\\w+', 1, 2) AS result
  FROM demo2
  ORDER BY id;

-- Example 5759
+----+-------------+
| ID | RESULT      |
|----+-------------|
|  2 | the worst   |
|  3 | the   extra |
|  4 | NULL        |
+----+-------------+

-- Example 5760
SELECT id,
       REGEXP_SUBSTR(string1, 'the\\W+(\\w+)', 1, 2, 'e', 1) AS result
  FROM demo2
  ORDER BY id;

-- Example 5761
+----+--------+
| ID | RESULT |
|----+--------|
|  2 | worst  |
|  3 | extra  |
|  4 | NULL   |
+----+--------+

-- Example 5762
CREATE OR REPLACE TABLE test_regexp_substr (string1 VARCHAR);;
INSERT INTO test_regexp_substr (string1) VALUES ('A MAN A PLAN A CANAL');

-- Example 5763
SELECT REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 1, 'e', 1) AS result1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 2, 'e', 1) AS result2,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 3, 'e', 1) AS result3,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 4, 'e', 1) AS result4
  FROM test_regexp_substr;

-- Example 5764
+---------+---------+---------+---------+
| RESULT1 | RESULT2 | RESULT3 | RESULT4 |
|---------+---------+---------+---------|
| MAN     | PLAN    | CANAL   | NULL    |
+---------+---------+---------+---------+

-- Example 5765
SELECT REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 1) AS result1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 2) AS result2,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 3) AS result3
  FROM test_regexp_substr;

-- Example 5766
+---------+---------+---------+
| RESULT1 | RESULT2 | RESULT3 |
|---------+---------+---------|
| M       | A       | N       |
+---------+---------+---------+

-- Example 5767
CREATE OR REPLACE TABLE message(body VARCHAR(255));

INSERT INTO message VALUES
  ('Hellooo World'),
  ('How are you doing today?'),
  ('the quick brown fox jumps over the lazy dog'),
  ('PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS');

-- Example 5768
SELECT body,
       REGEXP_SUBSTR(body, '\\b\\S*o\\S*\\b') AS result
  FROM message;

-- Example 5769
+---------------------------------------------+---------+
| BODY                                        | RESULT  |
|---------------------------------------------+---------|
| Hellooo World                               | Hellooo |
| How are you doing today?                    | How     |
| the quick brown fox jumps over the lazy dog | brown   |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     | NULL    |
+---------------------------------------------+---------+

-- Example 5770
SELECT body,
       REGEXP_SUBSTR(body, '\\b\\S*o\\S*\\b', 3) AS result
  FROM message;

-- Example 5771
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               | llooo  |
| How are you doing today?                    | you    |
| the quick brown fox jumps over the lazy dog | brown  |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     | NULL   |
+---------------------------------------------+--------+

-- Example 5772
SELECT body,
       REGEXP_SUBSTR(body, '\\b\\S*o\\S*\\b', 3, 3) AS result
  FROM message;

-- Example 5773
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               | NULL   |
| How are you doing today?                    | today  |
| the quick brown fox jumps over the lazy dog | over   |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     | NULL   |
+---------------------------------------------+--------+

-- Example 5774
SELECT body,
       REGEXP_SUBSTR(body, '\\b\\S*o\\S*\\b', 3, 3, 'i') AS result
  FROM message;

-- Example 5775
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               | NULL   |
| How are you doing today?                    | today  |
| the quick brown fox jumps over the lazy dog | over   |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     | LIQUOR |
+---------------------------------------------+--------+

-- Example 5776
SELECT body,
       REGEXP_SUBSTR(body, '(H\\S*o\\S*\\b).*', 1, 1, '') AS result
  FROM message;

-- Example 5777
+---------------------------------------------+--------------------------+
| BODY                                        | RESULT                   |
|---------------------------------------------+--------------------------|
| Hellooo World                               | Hellooo World            |
| How are you doing today?                    | How are you doing today? |
| the quick brown fox jumps over the lazy dog | NULL                     |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     | NULL                     |
+---------------------------------------------+--------------------------+

-- Example 5778
CREATE OR REPLACE TABLE overlap (
  id NUMBER,
  a STRING);

INSERT INTO overlap VALUES (1, ',abc,def,ghi,jkl,');
INSERT INTO overlap VALUES (2, ',abc,,def,,ghi,,jkl,');

SELECT * FROM overlap;

-- Example 5779
+----+----------------------+
| ID | A                    |
|----+----------------------|
|  1 | ,abc,def,ghi,jkl,    |
|  2 | ,abc,,def,,ghi,,jkl, |
+----+----------------------+

-- Example 5780
SELECT id,
       REGEXP_SUBSTR(a,'[[:punct:]][[:alnum:]]+[[:punct:]]', 1, 2) AS result
  FROM overlap;

-- Example 5781
+----+--------+
| ID | RESULT |
|----+--------|
|  1 | ,ghi,  |
|  2 | ,def,  |
+----+--------+

-- Example 5782
CREATE OR REPLACE TABLE test_regexp_log (logs VARCHAR);

INSERT INTO test_regexp_log (logs) VALUES
  ('127.0.0.1 - - [10/Jan/2018:16:55:36 -0800] "GET / HTTP/1.0" 200 2216'),
  ('192.168.2.20 - - [14/Feb/2018:10:27:10 -0800] "GET /cgi-bin/try/ HTTP/1.0" 200 3395');

SELECT * from test_regexp_log

-- Example 5783
+-------------------------------------------------------------------------------------+
| LOGS                                                                                |
|-------------------------------------------------------------------------------------|
| 127.0.0.1 - - [10/Jan/2018:16:55:36 -0800] "GET / HTTP/1.0" 200 2216                |
| 192.168.2.20 - - [14/Feb/2018:10:27:10 -0800] "GET /cgi-bin/try/ HTTP/1.0" 200 3395 |
+-------------------------------------------------------------------------------------+

-- Example 5784
SELECT '{ "ip_addr":"'
       || REGEXP_SUBSTR (logs,'\\b\\d{1,3}\.\\d{1,3}\.\\d{1,3}\.\\d{1,3}\\b')
       || '", "date":"'
       || REGEXP_SUBSTR (logs,'([\\w:\/]+\\s[+\-]\\d{4})')
       || '", "request":"'
       || REGEXP_SUBSTR (logs,'\"((\\S+) (\\S+) (\\S+))\"', 1, 1, 'e')
       || '", "status":"'
       || REGEXP_SUBSTR (logs,'(\\d{3}) \\d+', 1, 1, 'e')
       || '", "size":"'
       || REGEXP_SUBSTR (logs,'\\d{3} (\\d+)', 1, 1, 'e')
       || '"}' as Apache_HTTP_Server_Access
  FROM test_regexp_log;

-- Example 5785
+-----------------------------------------------------------------------------------------------------------------------------------------+
| APACHE_HTTP_SERVER_ACCESS                                                                                                               |
|-----------------------------------------------------------------------------------------------------------------------------------------|
| { "ip_addr":"127.0.0.1", "date":"10/Jan/2018:16:55:36 -0800", "request":"GET / HTTP/1.0", "status":"200", "size":"2216"}                |
| { "ip_addr":"192.168.2.20", "date":"14/Feb/2018:10:27:10 -0800", "request":"GET /cgi-bin/try/ HTTP/1.0", "status":"200", "size":"3395"} |
+-----------------------------------------------------------------------------------------------------------------------------------------+

-- Example 5786
REGEXP_SUBSTR_ALL( <subject> , <pattern> [ , <position> [ , <occurrence> [ , <regex_parameters> [ , <group_num> ] ] ] ] )

-- Example 5787
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', 'a[[:digit:]]') AS matches;

-- Example 5788
+---------+
| MATCHES |
|---------|
| [       |
|   "a1", |
|   "a2", |
|   "a3", |
|   "a4", |
|   "a6"  |
| ]       |
+---------+

-- Example 5789
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', 'a[[:digit:]]', 2) AS matches;

-- Example 5790
+---------+
| MATCHES |
|---------|
| [       |
|   "a2", |
|   "a3", |
|   "a4", |
|   "a6"  |
| ]       |
+---------+

-- Example 5791
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', 'a[[:digit:]]', 1, 3) AS matches;

-- Example 5792
+---------+
| MATCHES |
|---------|
| [       |
|   "a3", |
|   "a4", |
|   "a6"  |
| ]       |
+---------+

-- Example 5793
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', 'a[[:digit:]]', 1, 1, 'i') AS matches;

-- Example 5794
+---------+
| MATCHES |
|---------|
| [       |
|   "a1", |
|   "a2", |
|   "a3", |
|   "a4", |
|   "A5", |
|   "a6"  |
| ]       |
+---------+

-- Example 5795
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', '(a)([[:digit:]])', 1, 1, 'ie') AS matches;

-- Example 5796
+---------+
| MATCHES |
|---------|
| [       |
|   "a",  |
|   "a",  |
|   "a",  |
|   "a",  |
|   "A",  |
|   "a"   |
| ]       |
+---------+

-- Example 5797
SELECT REGEXP_SUBSTR_ALL('a1_a2a3_a4A5a6', 'b') AS matches;

-- Example 5798
+---------+
| MATCHES |
|---------|
| []      |
+---------+

-- Example 5799
CREATE OR REPLACE TABLE test_regexp_substr_all (string1 VARCHAR);;
INSERT INTO test_regexp_substr_all (string1) VALUES ('A MAN A PLAN A CANAL');

-- Example 5800
SELECT REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w+)', 1, 1, 'e', 1) AS result1,
       REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w+)', 1, 2, 'e', 1) AS result2,
       REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w+)', 1, 3, 'e', 1) AS result3
  FROM test_regexp_substr_all;

-- Example 5801
+-----------+-----------+-----------+
| RESULT1   | RESULT2   | RESULT3   |
|-----------+-----------+-----------|
| [         | [         | [         |
|   "MAN",  |   "PLAN", |   "CANAL" |
|   "PLAN", |   "CANAL" | ]         |
|   "CANAL" | ]         |           |
| ]         |           |           |
+-----------+-----------+-----------+

-- Example 5802
SELECT REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 1) AS result1,
       REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 2) AS result2,
       REGEXP_SUBSTR_ALL(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 'e', 3) AS result3
  FROM test_regexp_substr_all;

-- Example 5803
+---------+---------+---------+
| RESULT1 | RESULT2 | RESULT3 |
|---------+---------+---------|
| [       | [       | [       |
|   "M",  |   "A",  |   "N",  |
|   "P",  |   "L",  |   "A",  |
|   "C"   |   "A"   |   "N"   |
| ]       | ]       | ]       |
+---------+---------+---------+

-- Example 5804
REGR_VALX( <y> , <x> )

-- Example 5805
SELECT REGR_VALX(NULL, 10), REGR_VALX(1, NULL), REGR_VALX(1, 10);
+---------------------+--------------------+------------------+
| REGR_VALX(NULL, 10) | REGR_VALX(1, NULL) | REGR_VALX(1, 10) |
|---------------------+--------------------+------------------|
|                NULL |               NULL |               10 |
+---------------------+--------------------+------------------+

-- Example 5806
CREATE TABLE xy (col_x DOUBLE, col_y DOUBLE);
INSERT INTO xy (col_x, col_y) VALUES
    (1.0, 2.0),
    (3.0, NULL),
    (NULL, 6.0);

-- Example 5807
SELECT col_y, col_x, REGR_VALX(col_y, col_x), REGR_VALY(col_y, col_x)
    FROM xy;
+-------+-------+-------------------------+-------------------------+
| COL_Y | COL_X | REGR_VALX(COL_Y, COL_X) | REGR_VALY(COL_Y, COL_X) |
|-------+-------+-------------------------+-------------------------|
|     2 |     1 |                       1 |                       2 |
|  NULL |     3 |                    NULL |                    NULL |
|     6 |  NULL |                    NULL |                    NULL |
+-------+-------+-------------------------+-------------------------+

-- Example 5808
REGR_VALY( <y> , <x> )

-- Example 5809
SELECT REGR_VALY(NULL, 10), REGR_VALY(1, NULL), REGR_VALY(1, 10);
+---------------------+--------------------+------------------+
| REGR_VALY(NULL, 10) | REGR_VALY(1, NULL) | REGR_VALY(1, 10) |
|---------------------+--------------------+------------------|
|                NULL |               NULL |                1 |
+---------------------+--------------------+------------------+

