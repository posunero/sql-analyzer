-- Example 5676
+-------------------------------------+
| V                                   |
|-------------------------------------|
| Contains embedded single \backslash |
| Sacramento                          |
| San Francisco                       |
| San Jose                            |
| Santa Clara                         |
+-------------------------------------+

-- Example 5677
SELECT v, v REGEXP 'San\\b.*' AS matches
  FROM strings
  ORDER BY v;

-- Example 5678
+-------------------------------------+---------+
| V                                   | MATCHES |
|-------------------------------------+---------|
| Contains embedded single \backslash | False   |
| Sacramento                          | False   |
| San Francisco                       | True    |
| San Jose                            | True    |
| Santa Clara                         | False   |
+-------------------------------------+---------+

-- Example 5679
SELECT v, v REGEXP '.*\\s\\\\.*' AS matches
  FROM strings
  ORDER BY v;

-- Example 5680
+-------------------------------------+---------+
| V                                   | MATCHES |
|-------------------------------------+---------|
| Contains embedded single \backslash | True    |
| Sacramento                          | False   |
| San Francisco                       | False   |
| San Jose                            | False   |
| Santa Clara                         | False   |
+-------------------------------------+---------+

-- Example 5681
SELECT v, v REGEXP $$.*\s\\.*$$ AS MATCHES
  FROM strings
  ORDER BY v;

-- Example 5682
+-------------------------------------+---------+
| V                                   | MATCHES |
|-------------------------------------+---------|
| Contains embedded single \backslash | True    |
| Sacramento                          | False   |
| San Francisco                       | False   |
| San Jose                            | False   |
| Santa Clara                         | False   |
+-------------------------------------+---------+

-- Example 5683
REGEXP_COUNT( <subject> , <pattern> [ , <position> , <parameters> ] )

-- Example 5684
SELECT REGEXP_COUNT('It was the best of times, it was the worst of times',
                    '\\bwas\\b',
                    1) AS result;

-- Example 5685
+--------+
| RESULT |
|--------|
|      2 |
+--------+

-- Example 5686
CREATE OR REPLACE TABLE overlap (id NUMBER, a STRING);
INSERT INTO overlap VALUES (1,',abc,def,ghi,jkl,');
INSERT INTO overlap VALUES (2,',abc,,def,,ghi,,jkl,');

SELECT * FROM overlap;

-- Example 5687
+----+----------------------+
| ID | A                    |
|----+----------------------|
|  1 | ,abc,def,ghi,jkl,    |
|  2 | ,abc,,def,,ghi,,jkl, |
+----+----------------------+

-- Example 5688
SELECT id,
       REGEXP_COUNT(a,
                    '[[:punct:]][[:alnum:]]+[[:punct:]]',
                    1,
                    'i') AS result
  FROM overlap;

-- Example 5689
+----+--------+
| ID | RESULT |
|----+--------|
|  1 |      2 |
|  2 |      4 |
+----+--------+

-- Example 5690
REGEXP_INSTR( <subject> , <pattern> [ , <position> [ , <occurrence> [ , <option> [ , <regexp_parameters> [ , <group_num> ] ] ] ] ] )

-- Example 5691
CREATE OR REPLACE TABLE demo1 (id INT, string1 VARCHAR);
INSERT INTO demo1 (id, string1) VALUES
  (1, 'nevermore1, nevermore2, nevermore3.');

-- Example 5692
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'nevermore\\d') AS substring,
       REGEXP_INSTR( string1, 'nevermore\\d') AS position
  FROM demo1
  ORDER BY id;

-- Example 5693
+----+-------------------------------------+------------+----------+
| ID | STRING1                             | SUBSTRING  | POSITION |
|----+-------------------------------------+------------+----------|
|  1 | nevermore1, nevermore2, nevermore3. | nevermore1 |        1 |
+----+-------------------------------------+------------+----------+

-- Example 5694
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'nevermore\\d', 5) AS substring,
       REGEXP_INSTR( string1, 'nevermore\\d', 5) AS position
  FROM demo1
  ORDER BY id;

-- Example 5695
+----+-------------------------------------+------------+----------+
| ID | STRING1                             | SUBSTRING  | POSITION |
|----+-------------------------------------+------------+----------|
|  1 | nevermore1, nevermore2, nevermore3. | nevermore2 |       13 |
+----+-------------------------------------+------------+----------+

-- Example 5696
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'nevermore\\d', 1, 3) AS substring,
       REGEXP_INSTR( string1, 'nevermore\\d', 1, 3) AS position
  FROM demo1
  ORDER BY id;

-- Example 5697
+----+-------------------------------------+------------+----------+
| ID | STRING1                             | SUBSTRING  | POSITION |
|----+-------------------------------------+------------+----------|
|  1 | nevermore1, nevermore2, nevermore3. | nevermore3 |       25 |
+----+-------------------------------------+------------+----------+

-- Example 5698
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'nevermore\\d', 1, 3) AS substring,
       REGEXP_INSTR( string1, 'nevermore\\d', 1, 3, 0) AS start_position,
       REGEXP_INSTR( string1, 'nevermore\\d', 1, 3, 1) AS after_position
  FROM demo1
  ORDER BY id;

-- Example 5699
+----+-------------------------------------+------------+----------------+----------------+
| ID | STRING1                             | SUBSTRING  | START_POSITION | AFTER_POSITION |
|----+-------------------------------------+------------+----------------+----------------|
|  1 | nevermore1, nevermore2, nevermore3. | nevermore3 |             25 |             35 |
+----+-------------------------------------+------------+----------------+----------------+

-- Example 5700
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'nevermore', 1, 4) AS substring,
       REGEXP_INSTR( string1, 'nevermore', 1, 4) AS position
  FROM demo1
  ORDER BY id;

-- Example 5701
+----+-------------------------------------+-----------+----------+
| ID | STRING1                             | SUBSTRING | POSITION |
|----+-------------------------------------+-----------+----------|
|  1 | nevermore1, nevermore2, nevermore3. | NULL      |        0 |
+----+-------------------------------------+-----------+----------+

-- Example 5702
CREATE OR REPLACE TABLE demo2 (id INT, string1 VARCHAR);

INSERT INTO demo2 (id, string1) VALUES
    (2, 'It was the best of times, it was the worst of times.'),
    (3, 'In    the   string   the   extra   spaces  are   redundant.'),
    (4, 'A thespian theater is nearby.');

SELECT * FROM demo2;

-- Example 5703
+----+-------------------------------------------------------------+
| ID | STRING1                                                     |
|----+-------------------------------------------------------------|
|  2 | It was the best of times, it was the worst of times.        |
|  3 | In    the   string   the   extra   spaces  are   redundant. |
|  4 | A thespian theater is nearby.                               |
+----+-------------------------------------------------------------+

-- Example 5704
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'the\\W+\\w+') AS substring,
       REGEXP_INSTR(string1, 'the\\W+\\w+') AS position
  FROM demo2
  ORDER BY id;

-- Example 5705
+----+-------------------------------------------------------------+--------------+----------+
| ID | STRING1                                                     | SUBSTRING    | POSITION |
|----+-------------------------------------------------------------+--------------+----------|
|  2 | It was the best of times, it was the worst of times.        | the best     |        8 |
|  3 | In    the   string   the   extra   spaces  are   redundant. | the   string |        7 |
|  4 | A thespian theater is nearby.                               | NULL         |        0 |
+----+-------------------------------------------------------------+--------------+----------+

-- Example 5706
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'the\\W+\\w+', 1, 2) AS substring,
       REGEXP_INSTR(string1, 'the\\W+\\w+', 1, 2) AS position
  FROM demo2
  ORDER BY id;

-- Example 5707
+----+-------------------------------------------------------------+-------------+----------+
| ID | STRING1                                                     | SUBSTRING   | POSITION |
|----+-------------------------------------------------------------+-------------+----------|
|  2 | It was the best of times, it was the worst of times.        | the worst   |       34 |
|  3 | In    the   string   the   extra   spaces  are   redundant. | the   extra |       22 |
|  4 | A thespian theater is nearby.                               | NULL        |        0 |
+----+-------------------------------------------------------------+-------------+----------+

-- Example 5708
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'the\\W+(\\w+)', 1, 2,    'e', 1) AS substring,
       REGEXP_INSTR( string1, 'the\\W+(\\w+)', 1, 2, 0, 'e', 1) AS position
  FROM demo2
  ORDER BY id;

-- Example 5709
+----+-------------------------------------------------------------+-----------+----------+
| ID | STRING1                                                     | SUBSTRING | POSITION |
|----+-------------------------------------------------------------+-----------+----------|
|  2 | It was the best of times, it was the worst of times.        | worst     |       38 |
|  3 | In    the   string   the   extra   spaces  are   redundant. | extra     |       28 |
|  4 | A thespian theater is nearby.                               | NULL      |        0 |
+----+-------------------------------------------------------------+-----------+----------+

-- Example 5710
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'the\\W+(\\w+)', 1, 2,    'e') AS substring,
       REGEXP_INSTR( string1, 'the\\W+(\\w+)', 1, 2, 0, 'e') AS position
  FROM demo2
  ORDER BY id;

-- Example 5711
+----+-------------------------------------------------------------+-----------+----------+
| ID | STRING1                                                     | SUBSTRING | POSITION |
|----+-------------------------------------------------------------+-----------+----------|
|  2 | It was the best of times, it was the worst of times.        | worst     |       38 |
|  3 | In    the   string   the   extra   spaces  are   redundant. | extra     |       28 |
|  4 | A thespian theater is nearby.                               | NULL      |        0 |
+----+-------------------------------------------------------------+-----------+----------+

-- Example 5712
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'the\\W+(\\w+)', 1, 2,    '', 1) AS substring,
       REGEXP_INSTR( string1, 'the\\W+(\\w+)', 1, 2, 0, '', 1) AS position
  FROM demo2
  ORDER BY id;

-- Example 5713
+----+-------------------------------------------------------------+-----------+----------+
| ID | STRING1                                                     | SUBSTRING | POSITION |
|----+-------------------------------------------------------------+-----------+----------|
|  2 | It was the best of times, it was the worst of times.        | worst     |       38 |
|  3 | In    the   string   the   extra   spaces  are   redundant. | extra     |       28 |
|  4 | A thespian theater is nearby.                               | NULL      |        0 |
+----+-------------------------------------------------------------+-----------+----------+

-- Example 5714
CREATE TABLE demo3 (id INT, string1 VARCHAR);
INSERT INTO demo3 (id, string1) VALUES
  (5, 'A MAN A PLAN A CANAL');

-- Example 5715
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 1,    'e', 1) AS substring1,
       REGEXP_INSTR( string1, 'A\\W+(\\w+)', 1, 1, 0, 'e', 1) AS position1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 2,    'e', 1) AS substring2,
       REGEXP_INSTR( string1, 'A\\W+(\\w+)', 1, 2, 0, 'e', 1) AS position2,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 3,    'e', 1) AS substring3,
       REGEXP_INSTR( string1, 'A\\W+(\\w+)', 1, 3, 0, 'e', 1) AS position3,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w+)', 1, 4,    'e', 1) AS substring4,
       REGEXP_INSTR( string1, 'A\\W+(\\w+)', 1, 4, 0, 'e', 1) AS position4
  FROM demo3;

-- Example 5716
+----+----------------------+------------+-----------+------------+-----------+------------+-----------+------------+-----------+
| ID | STRING1              | SUBSTRING1 | POSITION1 | SUBSTRING2 | POSITION2 | SUBSTRING3 | POSITION3 | SUBSTRING4 | POSITION4 |
|----+----------------------+------------+-----------+------------+-----------+------------+-----------+------------+-----------|
|  5 | A MAN A PLAN A CANAL | MAN        |         3 | PLAN       |         9 | CANAL      |        16 | NULL       |         0 |
+----+----------------------+------------+-----------+------------+-----------+------------+-----------+------------+-----------+

-- Example 5717
SELECT id,
       string1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1,    'e', 1) AS substring1,
       REGEXP_INSTR( string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 0, 'e', 1) AS position1,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1,    'e', 2) AS substring2,
       REGEXP_INSTR( string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 0, 'e', 2) AS position2,
       REGEXP_SUBSTR(string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1,    'e', 3) AS substring3,
       REGEXP_INSTR( string1, 'A\\W+(\\w)(\\w)(\\w)', 1, 1, 0, 'e', 3) AS position3
  FROM demo3;

-- Example 5718
+----+----------------------+------------+-----------+------------+-----------+------------+-----------+
| ID | STRING1              | SUBSTRING1 | POSITION1 | SUBSTRING2 | POSITION2 | SUBSTRING3 | POSITION3 |
|----+----------------------+------------+-----------+------------+-----------+------------+-----------|
|  5 | A MAN A PLAN A CANAL | M          |         3 | A          |         4 | N          |         5 |
+----+----------------------+------------+-----------+------------+-----------+------------+-----------+

-- Example 5719
SELECT REGEXP_INSTR('It was the best of times, it was the worst of times',
                    '\\bwas\\b',
                    1,
                    1) AS result;

-- Example 5720
+--------+
| RESULT |
|--------|
|      4 |
+--------+

-- Example 5721
SELECT REGEXP_INSTR('It was the best of times, it was the worst of times',
                    'the\\W+(\\w+)',
                    1,
                    1,
                    0) AS result;

-- Example 5722
+--------+
| RESULT |
|--------|
|      8 |
+--------+

-- Example 5723
SELECT REGEXP_INSTR('It was the best of times, it was the worst of times',
                    'the\\W+(\\w+)',
                    1,
                    1,
                    0,
                    'e') AS result;

-- Example 5724
+--------+
| RESULT |
|--------|
|     12 |
+--------+

-- Example 5725
SELECT REGEXP_INSTR('It was the best of times, it was the worst of times',
                    '[[:alpha:]]{2,}st',
                    15,
                    1) AS result;

-- Example 5726
+--------+
| RESULT |
|--------|
|     38 |
+--------+

-- Example 5727
CREATE OR REPLACE TABLE message(body VARCHAR(255));
INSERT INTO message VALUES
  ('Hellooo World'),
  ('How are you doing today?'),
  ('the quick brown fox jumps over the lazy dog'),
  ('PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS');

-- Example 5728
SELECT body,
       REGEXP_INSTR(body, '\\b\\S*o\\S*\\b') AS result
  FROM message;

-- Example 5729
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               |      1 |
| How are you doing today?                    |      1 |
| the quick brown fox jumps over the lazy dog |     11 |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     |      0 |
+---------------------------------------------+--------+

-- Example 5730
SELECT body,
       REGEXP_INSTR(body, '\\b\\S*o\\S*\\b', 3) AS result
  FROM message;

-- Example 5731
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               |      3 |
| How are you doing today?                    |      9 |
| the quick brown fox jumps over the lazy dog |     11 |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     |      0 |
+---------------------------------------------+--------+

-- Example 5732
SELECT body, REGEXP_INSTR(body, '\\b\\S*o\\S*\\b', 3, 3) AS result
  FROM message;

-- Example 5733
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               |      0 |
| How are you doing today?                    |     19 |
| the quick brown fox jumps over the lazy dog |     27 |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     |      0 |
+---------------------------------------------+--------+

-- Example 5734
SELECT body, REGEXP_INSTR(body, '\\b\\S*o\\S*\\b', 3, 3, 1) AS result
  FROM message;

-- Example 5735
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               |      0 |
| How are you doing today?                    |     24 |
| the quick brown fox jumps over the lazy dog |     31 |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     |      0 |
+---------------------------------------------+--------+

-- Example 5736
SELECT body, REGEXP_INSTR(body, '\\b\\S*o\\S*\\b', 3, 3, 1, 'i') AS result
  FROM message;

-- Example 5737
+---------------------------------------------+--------+
| BODY                                        | RESULT |
|---------------------------------------------+--------|
| Hellooo World                               |      0 |
| How are you doing today?                    |     24 |
| the quick brown fox jumps over the lazy dog |     31 |
| PACK MY BOX WITH FIVE DOZEN LIQUOR JUGS     |     35 |
+---------------------------------------------+--------+

-- Example 5738
REGEXP_LIKE( <subject> , <pattern> [ , <parameters> ] )

-- Example 5739
CREATE OR REPLACE TABLE cities(city varchar(20));
INSERT INTO cities VALUES
  ('Sacramento'),
  ('San Francisco'),
  ('San Jose'),
  (null);

-- Example 5740
SELECT * FROM cities WHERE REGEXP_LIKE(city, 'san.*');

-- Example 5741
+------+
| CITY |
|------|
+------+

-- Example 5742
SELECT * FROM cities WHERE REGEXP_LIKE(city, 'san.*', 'i');

