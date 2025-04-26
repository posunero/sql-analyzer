-- Example 24698
CREATE OR REPLACE PROJECTION POLICY <name>
  AS () RETURNS PROJECTION_CONSTRAINT -> <body>

-- Example 24699
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => true)

-- Example 24700
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => false)

-- Example 24701
CREATE OR REPLACE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN CURRENT_ROLE() = 'ANALYST'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 24702
CREATE PROJECTION POLICY mypolicy
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('tags.accounting_col') = 'public'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 24703
CREATE OR REPLACE PROJECTION POLICY restrict_consumer_accounts
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN CURRENT_ACCOUNT() = 'provider.account'
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 24704
CREATE OR REPLACE PROJECTION POLICY projection_share
AS () RETURNS PROJECTION_CONSTRAINT ->
CASE
  WHEN INVOKER_SHARE() IN ('SHARE1', 'SHARE2')
    THEN PROJECTION_CONSTRAINT(ALLOW => true)
  ELSE PROJECTION_CONSTRAINT(ALLOW => false)
END;

-- Example 24705
-- Create mapping table with two columns: role name, whether that role can project the column
CREATE OR REPLACE TABLE roles_with_access(role string, allowed boolean)
AS SELECT * FROM VALUES ('ACCOUNTADMIN', true), ('RANDOM_ROLE', false);

-- Create a policy that queries the mapping table, and allows projection when current
-- user role has an `allowed` value of TRUE.
-- Note that the logic is written to default to FALSE in all other cases, including the
-- current role not being in the queried table.
CREATE OR REPLACE PROJECTION POLICY pp AS () RETURNS projection_constraint ->
  CASE WHEN
    exists(
      SELECT 1 FROM roles_with_access WHERE role = current_role() AND allowed = true
    ) THEN projection_constraint(ALLOW=>true)
  ELSE projection_constraint(ALLOW=>false) END;

-- Create a new table with the policy and query it in one step.
CREATE OR REPLACE TABLE t(user string, address string WITH PROJECTION POLICY pp)
  AS SELECT * FROM VALUES ('Carson', 'CA'), ('Emily', 'NY'), ('John', 'NV');

-- Succeeds
USE ROLE ACCOUNTADMIN;
SELECT * FROM t;

-- Fails with projection policy error on column ADDRESS
USE ROLE any_other_role;
SELECT * FROM t;

-- Example 24706
ALTER { TABLE | VIEW } <name>
{ ALTER | MODIFY } COLUMN <col1_name>
SET PROJECTION POLICY <policy_name> [ FORCE ]
[ , <col2_name> SET PROJECTION POLICY <policy_name> [ FORCE ] ... ]

-- Example 24707
ALTER TABLE finance.accounting.customers
 MODIFY COLUMN account_number
 SET PROJECTION POLICY proj_policy_acctnumber;

-- Example 24708
CREATE TABLE t1 (account_number NUMBER WITH PROJECTION POLICY my_proj_policy);

-- Example 24709
ALTER TABLE customers ADD COLUMN account_number NUMBER WITH PROJECTION POLICY my_proj_policy;

-- Example 24710
ALTER TABLE finance.accounting.customers
  MODIFY COLUMN account_number
  SET PROJECTION POLICY proj_policy2 FORCE;

-- Example 24711
ALTER { TABLE | VIEW } <name>
{ ALTER | MODIFY } COLUMN <col1_name>
UNSET PROJECTION POLICY
[ , <col2_name> UNSET PROJECTION POLICY ... ]

-- Example 24712
ALTER TABLE finance.accounting.customers
 MODIFY COLUMN account_number
 UNSET PROJECTION POLICY;

-- Example 24713
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.PROJECTION_POLICIES
ORDER BY POLICY_NAME;

-- Example 24714
USE DATABASE my_db;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(policy_name => 'my_db.my_schema.projpolicy'));

-- Example 24715
USE DATABASE my_db;
USE SCHEMA information_schema;
SELECT policy_name,
       policy_kind,
       ref_entity_name,
       ref_entity_domain,
       ref_column_name,
       ref_arg_column_names,
       policy_status
FROM TABLE(information_schema.policy_references(ref_entity_name => 'my_db.my_schema.my_table', ref_entity_domain => 'table'));

-- Example 24716
USE ROLE useradmin;

CREATE ROLE proj_policy_admin;

-- Example 24717
GRANT USAGE ON DATABASE privacy TO ROLE proj_policy_admin;
GRANT USAGE ON SCHEMA privacy.projpolicies TO ROLE proj_policy_admin;

GRANT CREATE PROJECTION POLICY
  ON SCHEMA privacy.projpolicies TO ROLE proj_policy_admin;

GRANT APPLY PROJECTION POLICY ON ACCOUNT TO ROLE proj_policy_admin;

-- Example 24718
USE ROLE proj_policy_admin;
USE SCHEMA privacy.projpolicies;

CREATE OR REPLACE PROJECTION POLICY proj_policy_false
AS () RETURNS PROJECTION_CONSTRAINT ->
PROJECTION_CONSTRAINT(ALLOW => false);

-- Example 24719
ALTER TABLE customers MODIFY COLUMN active
SET PROJECTION POLICY privacy.projpolicies.proj_policy_false;

-- Example 24720
USE ROLE securityadmin;
GRANT USAGE ON DATABASE mydb TO ROLE projection_policy_admin;
GRANT USAGE ON SCHEMA mydb.schema TO ROLE projection_policy_admin;

GRANT CREATE PROJECTION POLICY ON SCHEMA mydb.schema TO ROLE projection_policy_admin;
GRANT APPLY ON PROJECTION POLICY ON ACCOUNT TO ROLE projection_policy_admin;

-- Example 24721
USE ROLE securityadmin;
GRANT CREATE PROJECTION POLICY ON SCHEMA mydb.schema TO ROLE projection_policy_admin;
GRANT APPLY ON PROJECTION POLICY cost_center TO ROLE finance_role;

-- Example 24722
SEARCH( <search_data>, <search_string>
  [ , ANALYZER => '<analyzer_name>' ]
  [ , SEARCH_MODE => { 'OR' | 'AND' } ] )

-- Example 24723
(mytable.*)

-- Example 24724
(* ILIKE 'col1%')

-- Example 24725
(* EXCLUDE col1)

(* EXCLUDE (col1, col2))

-- Example 24726
(mytable.* ILIKE 'col1%')

-- Example 24727
SELECT *
  FROM t AS T1
    JOIN t AS T2 USING (col1)
  WHERE SEARCH((*), 'string');

-- Example 24728
SELECT *
  FROM t AS T1
    JOIN t AS T2 USING (col1)
  WHERE SEARCH((T2.*), 'string');

-- Example 24729
SEARCH((col1, col2, col3), 'string')
SEARCH((t1.*), 'string')
SEARCH((*), 'string')

-- Example 24730
ALTER TABLE lines ADD SEARCH OPTIMIZATION
  ON FULL_TEXT(play, character, line);

-- Example 24731
SELECT SEARCH('king','KING');

-- Example 24732
+-----------------------------+
| SEARCH('KING','KING')       |
|-----------------------------|
| True                        |
+-----------------------------+

-- Example 24733
SELECT SEARCH('5.1.33','32');

-- Example 24734
+-----------------------------+
| SEARCH('5.1.33','32')       |
|-----------------------------|
| False                       |
+-----------------------------+

-- Example 24735
SELECT SEARCH(character, 'king queen'), character
  FROM lines
  WHERE line_id=4;

-- Example 24736
+---------------------------------+---------------+
| SEARCH(CHARACTER, 'KING QUEEN') | CHARACTER     |
|---------------------------------+---------------|
| True                            | KING HENRY IV |
+---------------------------------+---------------+

-- Example 24737
SELECT SEARCH(character, 'king queen', SEARCH_MODE => 'AND'), character
  FROM lines
  WHERE line_id=4;

-- Example 24738
+-------------------------------------------------------+---------------+
| SEARCH(CHARACTER, 'KING QUEEN', SEARCH_MODE => 'AND') | CHARACTER     |
|-------------------------------------------------------+---------------|
| False                                                 | KING HENRY IV |
+-------------------------------------------------------+---------------+

-- Example 24739
SELECT *
  FROM lines
  WHERE SEARCH(line, 'wherefore')
  ORDER BY character LIMIT 5;

-- Example 24740
+---------+----------------------+------------+----------------+-----------+-----------------------------------------------------+
| LINE_ID | PLAY                 | SPEECH_NUM | ACT_SCENE_LINE | CHARACTER | LINE                                                |
|---------+----------------------+------------+----------------+-----------+-----------------------------------------------------|
|  100109 | Troilus and Cressida |         31 | 2.1.53         | ACHILLES  | Why, how now, Ajax! wherefore do you thus? How now, |
|   16448 | As You Like It       |          2 | 2.3.6          | ADAM      | And wherefore are you gentle, strong and valiant?   |
|   24055 | The Comedy of Errors |         14 | 5.1.41         | AEMELIA   | Be quiet, people. Wherefore throng you hither?      |
|   99330 | Troilus and Cressida |         30 | 1.1.102        | AENEAS    | How now, Prince Troilus! wherefore not afield?      |
|   92454 | The Tempest          |        150 | 2.1.343        | ALONSO    | Wherefore this ghastly looking?                     |
+---------+----------------------+------------+----------------+-----------+-----------------------------------------------------+

-- Example 24741
SELECT play, character
  FROM lines
  WHERE SEARCH((play, character), 'king')
  ORDER BY play, character LIMIT 10;

-- Example 24742
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

-- Example 24743
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.*), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 24744
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

-- Example 24745
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.* ILIKE '%line'), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 24746
+-----------------+-----------------+--------------------------------------------------+----------------+
| PLAY            | CHARACTER       | LINE                                             | ACT_SCENE_LINE |
|-----------------+-----------------+--------------------------------------------------+----------------|
| Pericles        | LODOVICO        | This king unto him took a fere,                  | 1.0.21         |
| Henry VI Part 3 | WARWICK         | I wonder how the king escaped our hands.         | 1.1.1          |
| King Lear       | KENT            | I thought the king had more affected the Duke of | 1.1.1          |
| Cymbeline       | First Gentleman | Is outward sorrow, though I think the king       | 1.1.10         |
+-----------------+-----------------+--------------------------------------------------+----------------+

-- Example 24747
SELECT play, character, line, act_scene_line
  FROM lines
  WHERE SEARCH((lines.* EXCLUDE character), 'king')
  ORDER BY act_scene_line LIMIT 10;

-- Example 24748
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

-- Example 24749
SELECT SEARCH((*), 'king') result, *
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 24750
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

-- Example 24751
SELECT SEARCH(* ILIKE '%line', 'king') result, play, character, line
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 24752
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

-- Example 24753
SELECT SEARCH(* EXCLUDE (play, line), 'king') result, play, character, line
  FROM lines
  ORDER BY act_scene_line LIMIT 10;

-- Example 24754
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

-- Example 24755
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

-- Example 24756
SELECT * FROM t1 JOIN t2 USING(col1)
  WHERE SEARCH((t1.*),'s all4');

-- Example 24757
+------+------+--------------+------+--------------+-------------+
| COL1 | COL2 | COL3         | COL2 | COL3         | COL4        |
|------+------+--------------+------+--------------+-------------|
|    2 | Mini | Cooper S     | Mini | Cooper S     | Convertible |
|    4 | Mini | Countryman S | Mini | Countryman S | ALL4        |
+------+------+--------------+------+--------------+-------------+

-- Example 24758
SELECT * FROM t1 JOIN t2 USING(col1)
  WHERE SEARCH((t2.*),'s all4');

-- Example 24759
+------+------+--------------+------+---------------+-------------+
| COL1 | COL2 | COL3         | COL2 | COL3          | COL4        |
|------+------+--------------+------+---------------+-------------|
|    2 | Mini | Cooper S     | Mini | Cooper S      | Convertible |
|    3 | Mini | Countryman   | Mini | Countryman SE | ALL4        |
|    4 | Mini | Countryman S | Mini | Countryman S  | ALL4        |
+------+------+--------------+------+---------------+-------------+

-- Example 24760
SELECT *
  FROM (
    SELECT col1, col2, col3 FROM t1
    UNION
    SELECT col1, col2, col3 FROM t2
    ) AS T3
  WHERE SEARCH((T3.*),'s');

-- Example 24761
+------+------+--------------+
| COL1 | COL2 | COL3         |
|------+------+--------------|
|    2 | Mini | Cooper S     |
|    4 | Mini | Countryman S |
+------+------+--------------+

-- Example 24762
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'Rosencrantz Guildenstern', SEARCH_MODE => 'AND')
    AND act_scene_line IS NOT NULL;

-- Example 24763
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

-- Example 24764
SELECT act_scene_line, character, line
  FROM lines
  WHERE SEARCH(line, 'KING Rosencrantz', SEARCH_MODE => 'AND')
    AND act_scene_line IS NOT NULL;

