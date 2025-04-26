-- Example 5944
(mytable.* ILIKE 'col1%')

-- Example 5945
SELECT *
  FROM t AS T1
    JOIN t AS T2 USING (col1)
  WHERE SEARCH((*), 'string');

-- Example 5946
SELECT *
  FROM t AS T1
    JOIN t AS T2 USING (col1)
  WHERE SEARCH((T2.*), 'string');

-- Example 5947
SEARCH((col1, col2, col3), 'string')
SEARCH((t1.*), 'string')
SEARCH((*), 'string')

-- Example 5948
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 5949
SELECT SEARCH('king','KING');

-- Example 5950
+-----------------------------+
| SEARCH('KING','KING')       |
|-----------------------------|
| True                        |
+-----------------------------+

-- Example 5951
SELECT SEARCH('5.1.33','32');

-- Example 5952
+-----------------------------+
| SEARCH('5.1.33','32')       |
|-----------------------------|
| False                       |
+-----------------------------+

-- Example 5953
SELECT SEARCH(character, 'king queen'), character
  FROM lines
  WHERE line_id=4;

-- Example 5954
+---------------------------------+---------------+
| SEARCH(CHARACTER, 'KING QUEEN') | CHARACTER     |
|---------------------------------+---------------|
| True                            | KING HENRY IV |
+---------------------------------+---------------+

-- Example 5955
SELECT SEARCH(character, 'king queen', SEARCH_MODE => 'AND'), character
  FROM lines
  WHERE line_id=4;

-- Example 5956
+-------------------------------------------------------+---------------+
| SEARCH(CHARACTER, 'KING QUEEN', SEARCH_MODE => 'AND') | CHARACTER     |
|-------------------------------------------------------+---------------|
| False                                                 | KING HENRY IV |
+-------------------------------------------------------+---------------+

-- Example 5957
SELECT *
  FROM lines
  WHERE SEARCH(line, 'wherefore')
  ORDER BY character LIMIT 5;

-- Example 5958
+---------+----------------------+------------+----------------+-----------+-----------------------------------------------------+
| LINE_ID | PLAY                 | SPEECH_NUM | ACT_SCENE_LINE | CHARACTER | LINE                                                |
|---------+----------------------+------------+----------------+-----------+-----------------------------------------------------|
|  100109 | Troilus and Cressida |         31 | 2.1.53         | ACHILLES  | Why, how now, Ajax! wherefore do you thus? How now, |
|   16448 | As You Like It       |          2 | 2.3.6          | ADAM      | And wherefore are you gentle, strong and valiant?   |
|   24055 | The Comedy of Errors |         14 | 5.1.41         | AEMELIA   | Be quiet, people. Wherefore throng you hither?      |
|   99330 | Troilus and Cressida |         30 | 1.1.102        | AENEAS    | How now, Prince Troilus! wherefore not afield?      |
|   92454 | The Tempest          |        150 | 2.1.343        | ALONSO    | Wherefore this ghastly looking?                     |
+---------+----------------------+------------+----------------+-----------+-----------------------------------------------------+

-- Example 5959
SELECT play, character
  FROM lines
  WHERE SEARCH((play, character), 'king')
  ORDER BY play, character LIMIT 10;

-- Example 5960
+---------------------------+-----------------+
| PLAY                      | CHARACTER       |
|---------------------------+-----------------|
| All's Well That Ends Well | KING            |
| Hamlet                    | KING CLAUDIUS   |
| Hamlet                    | KING CLAUDIUS   |
| Henry IV Part 1           | KING HENRY IV   |
| Henry IV Part 1           | KING HENRY IV   |
| King John                 | CHATILLON       |
| King John                 | KING JOHN       |
| King Lear                 | GLOUCESTER      |
| King Lear                 | KENT            |
| Richard II                | KING RICHARD II |
+---------------------------+-----------------+

-- Example 5961
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.*), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 5962
+-----------------+-----------------+----------------------------------------------------+----------------+
| PLAY            | CHARACTER       | LINE                                               | ACT_SCENE_LINE |
|-----------------+-----------------+----------------------------------------------------+----------------|
| Pericles        | LODOVICO        | This king unto him took a fere,                    | 1.0.21         |
| Richard II      | KING RICHARD II | Old John of Gaunt, time-honour'd Lancaster,        | 1.1.1          |
| Henry VI Part 3 | WARWICK         | I wonder how the king escaped our hands.           | 1.1.1          |
| King John       | KING JOHN       | Now, say, Chatillon, what would France with us?    | 1.1.1          |
| King Lear       | KENT            | I thought the king had more affected the Duke of   | 1.1.1          |
| Henry IV Part 1 | KING HENRY IV   | So shaken as we are, so wan with care,             | 1.1.1          |
| Henry IV Part 1 | KING HENRY IV   | Which, like the meteors of a troubled heaven,      | 1.1.10         |
| King Lear       | GLOUCESTER      | so often blushed to acknowledge him, that now I am | 1.1.10         |
| Cymbeline       | First Gentleman | Is outward sorrow, though I think the king         | 1.1.10         |
| King John       | CHATILLON       | To this fair island and the territories,           | 1.1.10         |
+-----------------+-----------------+----------------------------------------------------+----------------+

-- Example 5963
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.* ILIKE '%line'), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 5964
+-----------------+-----------------+--------------------------------------------------+----------------+
| PLAY            | CHARACTER       | LINE                                             | ACT_SCENE_LINE |
|-----------------+-----------------+--------------------------------------------------+----------------|
| Pericles        | LODOVICO        | This king unto him took a fere,                  | 1.0.21         |
| Henry VI Part 3 | WARWICK         | I wonder how the king escaped our hands.         | 1.1.1          |
| King Lear       | KENT            | I thought the king had more affected the Duke of | 1.1.1          |
| Cymbeline       | First Gentleman | Is outward sorrow, though I think the king       | 1.1.10         |
+-----------------+-----------------+--------------------------------------------------+----------------+

-- Example 5965
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.* EXCLUDE character), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 5966
+-----------------+-----------------+----------------------------------------------------+----------------+
| PLAY            | CHARACTER       | LINE                                               | ACT_SCENE_LINE |
|-----------------+-----------------+----------------------------------------------------+----------------|
| Pericles        | LODOVICO        | This king unto him took a fere,                    | 1.0.21         |
| Henry VI Part 3 | WARWICK         | I wonder how the king escaped our hands.           | 1.1.1          |
| King John       | KING JOHN       | Now, say, Chatillon, what would France with us?    | 1.1.1          |
| King Lear       | KENT            | I thought the king had more affected the Duke of   | 1.1.1          |
| Cymbeline       | First Gentleman | Is outward sorrow, though I think the king         | 1.1.10         |
| King Lear       | GLOUCESTER      | so often blushed to acknowledge him, that now I am | 1.1.10         |
| King John       | CHATILLON       | To this fair island and the territories,           | 1.1.10         |
+-----------------+-----------------+----------------------------------------------------+----------------+

-- Example 5967
SELECT SEARCH((*), 'king') result, *
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 5968
+--------+---------+---------------------------+------------+----------------+-----------------+--------------------------------------------------------+
| RESULT | LINE_ID | PLAY                      | SPEECH_NUM | ACT_SCENE_LINE | CHARACTER       | LINE                                                   |
|--------+---------+---------------------------+------------+----------------+-----------------+--------------------------------------------------------|
| True   |   75787 | Pericles                  |        178 | 1.0.21         | LODOVICO        | This king unto him took a fere,                        |
| True   |   43494 | King John                 |          1 | 1.1.1          | KING JOHN       | Now, say, Chatillon, what would France with us?        |
| True   |   49031 | King Lear                 |          1 | 1.1.1          | KENT            | I thought the king had more affected the Duke of       |
| True   |   78407 | Richard II                |          1 | 1.1.1          | KING RICHARD II | Old John of Gaunt, time-honour'd Lancaster,            |
| False  |   67000 | A Midsummer Night's Dream |          1 | 1.1.1          | THESEUS         | Now, fair Hippolyta, our nuptial hour                  |
| True   |       4 | Henry IV Part 1           |          1 | 1.1.1          | KING HENRY IV   | So shaken as we are, so wan with care,                 |
| False  |   12664 | All's Well That Ends Well |          1 | 1.1.1          | COUNTESS        | In delivering my son from me, I bury a second husband. |
| True   |    9526 | Henry VI Part 3           |          1 | 1.1.1          | WARWICK         | I wonder how the king escaped our hands.               |
| False  |   52797 | Love's Labour's Lost      |          1 | 1.1.1          | FERDINAND       | Let fame, that all hunt after in their lives,          |
| True   |   28487 | Cymbeline                 |          3 | 1.1.10         | First Gentleman | Is outward sorrow, though I think the king             |
+--------+---------+---------------------------+------------+----------------+-----------------+--------------------------------------------------------+

-- Example 5969
SELECT SEARCH(* ILIKE '%line', 'king') result, play, character, line
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 5970
+--------+---------------------------+-----------------+--------------------------------------------------------+
| RESULT | PLAY                      | CHARACTER       | LINE                                                   |
|--------+---------------------------+-----------------+--------------------------------------------------------|
| True   | Pericles                  | LODOVICO        | This king unto him took a fere,                        |
| False  | King John                 | KING JOHN       | Now, say, Chatillon, what would France with us?        |
| True   | King Lear                 | KENT            | I thought the king had more affected the Duke of       |
| False  | Richard II                | KING RICHARD II | Old John of Gaunt, time-honour'd Lancaster,            |
| False  | A Midsummer Night's Dream | THESEUS         | Now, fair Hippolyta, our nuptial hour                  |
| False  | Henry IV Part 1           | KING HENRY IV   | So shaken as we are, so wan with care,                 |
| False  | All's Well That Ends Well | COUNTESS        | In delivering my son from me, I bury a second husband. |
| True   | Henry VI Part 3           | WARWICK         | I wonder how the king escaped our hands.               |
| False  | Love's Labour's Lost      | FERDINAND       | Let fame, that all hunt after in their lives,          |
| True   | Cymbeline                 | First Gentleman | Is outward sorrow, though I think the king             |
+--------+---------------------------+-----------------+--------------------------------------------------------+

-- Example 5971
SELECT SEARCH(* EXCLUDE (play, line), 'king') result, play, character, line
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 5972
+--------+---------------------------+-----------------+--------------------------------------------------------+
| RESULT | PLAY                      | CHARACTER       | LINE                                                   |
|--------+---------------------------+-----------------+--------------------------------------------------------|
| False  | Pericles                  | LODOVICO        | This king unto him took a fere,                        |
| True   | King John                 | KING JOHN       | Now, say, Chatillon, what would France with us?        |
| False  | King Lear                 | KENT            | I thought the king had more affected the Duke of       |
| True   | Richard II                | KING RICHARD II | Old John of Gaunt, time-honour'd Lancaster,            |
| False  | A Midsummer Night's Dream | THESEUS         | Now, fair Hippolyta, our nuptial hour                  |
| True   | Henry IV Part 1           | KING HENRY IV   | So shaken as we are, so wan with care,                 |
| False  | All's Well That Ends Well | COUNTESS        | In delivering my son from me, I bury a second husband. |
| False  | Henry VI Part 3           | WARWICK         | I wonder how the king escaped our hands.               |
| False  | Love's Labour's Lost      | FERDINAND       | Let fame, that all hunt after in their lives,          |
| False  | Cymbeline                 | First Gentleman | Is outward sorrow, though I think the king             |
+--------+---------------------------+-----------------+--------------------------------------------------------+

-- Example 5973
CREATE OR REPLACE TABLE t1 (col1 INT, col2 VARCHAR(20), col3 VARCHAR(20));
INSERT INTO t1 VALUES
  (1,'Mini','Cooper'),
  (2,'Mini','Cooper S'),
  (3,'Mini','Countryman'),
  (4,'Mini','Countryman S');
CREATE OR REPLACE TABLE t2 (col1 INT, col2 VARCHAR(20), col3 VARCHAR(20), col4 VARCHAR(20));
INSERT INTO t2 VALUES
  (1,'Mini','Cooper', 'Convertible'),
  (2,'Mini','Cooper S', 'Convertible'),
  (3,'Mini','Countryman SE','ALL4'),
  (4,'Mini','Countryman S','ALL4');

-- Example 5974
SELECT * FROM t1 JOIN t2 USING(col1)
  WHERE SEARCH((t1.*),'s all4');

-- Example 5975
+------+------+--------------+------+--------------+-------------+
| COL1 | COL2 | COL3         | COL2 | COL3         | COL4        |
|------+------+--------------+------+--------------+-------------|
|    2 | Mini | Cooper S     | Mini | Cooper S     | Convertible |
|    4 | Mini | Countryman S | Mini | Countryman S | ALL4        |
+------+------+--------------+------+--------------+-------------+

-- Example 5976
SELECT * FROM t1 JOIN t2 USING(col1)
  WHERE SEARCH((t2.*),'s all4');

-- Example 5977
+------+------+--------------+------+---------------+-------------+
| COL1 | COL2 | COL3         | COL2 | COL3          | COL4        |
|------+------+--------------+------+---------------+-------------|
|    2 | Mini | Cooper S     | Mini | Cooper S      | Convertible |
|    3 | Mini | Countryman   | Mini | Countryman SE | ALL4        |
|    4 | Mini | Countryman S | Mini | Countryman S  | ALL4        |
+------+------+--------------+------+---------------+-------------+

-- Example 5978
SELECT *
  FROM (
    SELECT col1, col2, col3 FROM t1
    UNION
    SELECT col1, col2, col3 FROM t2
    ) AS T3
  WHERE SEARCH((T3.*),'s');

-- Example 5979
+------+------+--------------+
| COL1 | COL2 | COL3         |
|------+------+--------------|
|    2 | Mini | Cooper S     |
|    4 | Mini | Countryman S |
+------+------+--------------+

-- Example 5980
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'Rosencrantz Guildenstern', SEARCH_MODE => 'AND')
    AND act_scene_line IS NOT NULL;

-- Example 5981
+----------------+------------------+-----------------------------------------------------------+
| ACT_SCENE_LINE | CHARACTER        | LINE                                                      |
|----------------+------------------+-----------------------------------------------------------|
| 2.2.1          | KING CLAUDIUS    | Welcome, dear Rosencrantz and Guildenstern!               |
| 2.2.35         | KING CLAUDIUS    | Thanks, Rosencrantz and gentle Guildenstern.              |
| 2.2.36         | QUEEN GERTRUDE   | Thanks, Guildenstern and gentle Rosencrantz:              |
| 2.2.241        | HAMLET           | Guildenstern? Ah, Rosencrantz! Good lads, how do ye both? |
| 4.6.27         | HORATIO          | where I am. Rosencrantz and Guildenstern hold their       |
| 5.2.60         | HORATIO          | So Guildenstern and Rosencrantz go to't.                  |
| 5.2.389        | First Ambassador | That Rosencrantz and Guildenstern are dead:               |
+----------------+------------------+-----------------------------------------------------------+

-- Example 5982
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'KING Rosencrantz', SEARCH_MODE => 'AND')
    AND act_scene_line IS NOT NULL;

-- Example 5983
+----------------+-----------+------+
| ACT_SCENE_LINE | CHARACTER | LINE |
|----------------+-----------+------|
+----------------+-----------+------+

-- Example 5984
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'KING Rosencrantz', SEARCH_MODE => 'OR')
    AND act_scene_line IS NOT NULL;

-- Example 5985
+----------------+------------------+-----------------------------------------------------------+
| ACT_SCENE_LINE | CHARACTER        | LINE                                                      |
|----------------+------------------+-----------------------------------------------------------|
| 1.1.1          | WARWICK          | I wonder how the king escaped our hands.                  |
| 1.1.10         | First Gentleman  | Is outward sorrow, though I think the king                |
| 2.2.1          | KING CLAUDIUS    | Welcome, dear Rosencrantz and Guildenstern!               |
| 2.2.35         | KING CLAUDIUS    | Thanks, Rosencrantz and gentle Guildenstern.              |
| 2.2.36         | QUEEN GERTRUDE   | Thanks, Guildenstern and gentle Rosencrantz:              |
| 2.2.241        | HAMLET           | Guildenstern? Ah, Rosencrantz! Good lads, how do ye both? |
| 4.6.27         | HORATIO          | where I am. Rosencrantz and Guildenstern hold their       |
| 5.2.60         | HORATIO          | So Guildenstern and Rosencrantz go to't.                  |
| 5.2.389        | First Ambassador | That Rosencrantz and Guildenstern are dead:               |
| 1.1.1          | KENT             | I thought the king had more affected the Duke of          |
| 1.0.21         | LODOVICO         | This king unto him took a fere,                           |
+----------------+------------------+-----------------------------------------------------------+

-- Example 5986
CREATE OR REPLACE TABLE car_rentals(
  vehicle_make VARCHAR(30),
  dealership VARCHAR(30),
  salesperson VARCHAR(30));

INSERT INTO car_rentals VALUES
  ('Toyota', 'Tindel Toyota', 'Greg Northrup'),
  ('Honda', 'Valley View Auto Sales', 'Frank Beasley'),
  ('Tesla', 'Valley View Auto Sales', 'Arturo Sandoval');

-- Example 5987
SELECT SEARCH((r.vehicle_make, r.dealership, s.src:dealership), 'Toyota Tesla')
    AS contains_toyota_tesla, r.vehicle_make, r.dealership,s.src:dealership
  FROM car_rentals r JOIN car_sales s
    ON r.SALESPERSON=s.src:salesperson.name;

-- Example 5988
+-----------------------+--------------+------------------------+--------------------------+
| CONTAINS_TOYOTA_TESLA | VEHICLE_MAKE | DEALERSHIP             | S.SRC:DEALERSHIP         |
|-----------------------+--------------+------------------------+--------------------------|
| True                  | Toyota       | Tindel Toyota          | "Tindel Toyota"          |
| False                 | Honda        | Valley View Auto Sales | "Valley View Auto Sales" |
+-----------------------+--------------+------------------------+--------------------------+

-- Example 5989
SELECT SEARCH((r.vehicle_make, r.dealership, s.src:dealership), 'Toyota Honda')
    AS contains_toyota_honda, r.vehicle_make, r.dealership, s.src:dealership
  FROM car_rentals r JOIN car_sales s
    ON r.SALESPERSON =s.src:salesperson.name;

-- Example 5990
+-----------------------+--------------+------------------------+--------------------------+
| CONTAINS_TOYOTA_HONDA | VEHICLE_MAKE | DEALERSHIP             | S.SRC:DEALERSHIP         |
|-----------------------+--------------+------------------------+--------------------------|
| True                  | Toyota       | Tindel Toyota          | "Tindel Toyota"          |
| True                  | Honda        | Valley View Auto Sales | "Valley View Auto Sales" |
+-----------------------+--------------+------------------------+--------------------------+

-- Example 5991
SELECT line_id, act_scene_line FROM lines
  WHERE SEARCH(act_scene_line, '1.2.500', ANALYZER=>'NO_OP_ANALYZER');

-- Example 5992
+---------+----------------+
| LINE_ID | ACT_SCENE_LINE |
|---------+----------------|
|   91998 | 1.2.500        |
|  108464 | 1.2.500        |
+---------+----------------+

-- Example 5993
SELECT DISTINCT(play)
  FROM lines
  WHERE SEARCH(play, 'love''s', ANALYZER=>'UNICODE_ANALYZER');

-- Example 5994
+----------------------+
| PLAY                 |
|----------------------|
| Love's Labour's Lost |
+----------------------+

-- Example 5995
SELECT DISTINCT(play) FROM lines WHERE SEARCH(play, 'love''s');

-- Example 5996
+---------------------------+
| PLAY                      |
|---------------------------|
| All's Well That Ends Well |
| Love's Labour's Lost      |
| A Midsummer Night's Dream |
| The Winter's Tale         |
+---------------------------+

-- Example 5997
SELECT SEARCH(line, 5) FROM lines;

-- Example 5998
001045 (22023): SQL compilation error:
argument needs to be a string: '1'

-- Example 5999
SELECT SEARCH(line_id, 'dream') FROM lines;

-- Example 6000
001173 (22023): SQL compilation error: error line 1 at position 7: Expected non-empty set of columns supporting full-text search.

-- Example 6001
SELECT SEARCH((line_id, play), 'dream') FROM lines
  ORDER BY play LIMIT 5;

-- Example 6002
+----------------------------------+
| SEARCH((LINE_ID, PLAY), 'DREAM') |
|----------------------------------|
| True                             |
| True                             |
| False                            |
| False                            |
| False                            |
+----------------------------------+

-- Example 6003
SELECT SEARCH('docs@snowflake.com', 'careers@snowflake.com', '@');

-- Example 6004
001881 (42601): SQL compilation error: Expected 1 named argument(s), found 0

-- Example 6005
SELECT SEARCH(play,line,'king', ANALYZER=>'UNICODE_ANALYZER') FROM lines;

-- Example 6006
000939 (22023): SQL compilation error: error line 1 at position 7
too many arguments for function [SEARCH(LINES.PLAY, LINES.LINE, 'king', 'UNICODE_ANALYZER')] expected 3, got 4

-- Example 6007
SELECT SEARCH(line, character) FROM lines;

-- Example 6008
001015 (22023): SQL compilation error:
argument 2 to function SEARCH needs to be constant, found 'LINES.CHARACTER'

-- Example 6009
DESCRIBE TABLE lines;

-- Example 6010
+----------------+---------------+--------+-------+-
| name           | type          | kind   | null? |
|----------------+---------------+--------+-------+-
| LINE_ID        | NUMBER(38,0)  | COLUMN | Y     |
| PLAY           | VARCHAR(50)   | COLUMN | Y     |
| SPEECH_NUM     | NUMBER(38,0)  | COLUMN | Y     |
| ACT_SCENE_LINE | VARCHAR(10)   | COLUMN | Y     |
| CHARACTER      | VARCHAR(30)   | COLUMN | Y     |
| LINE           | VARCHAR(2000) | COLUMN | Y     |
+----------------+---------------+--------+-------+-

