-- Example 6145
SELECT
  usage_date AS date,
  account_name,
  SUM(usage) AS credits,
  currency,
  SUM(usage_in_currency) AS usage_in_currency
FROM
  SNOWFLAKE.ORGANIZATION_USAGE.USAGE_IN_CURRENCY_DAILY
WHERE
  USAGE_TYPE ILIKE '%SERVERLESS_TASK%'
GROUP BY
  usage_date, account_name, currency
ORDER BY
  USAGE_DATE DESC;

-- Example 6146
USE SYSADMIN;

CREATE ROLE warehouse_task_creation
  COMMENT = 'This role can create user-managed tasks.';

-- Example 6147
from snowflake.core.role import Role

root.session.use_role("SYSADMIN")

my_role = Role(
    name="warehouse_task_creation",
    comment="This role can create user-managed tasks."
)
root.roles.create(my_role)

-- Example 6148
USE ACCOUNTADMIN;

GRANT CREATE TASK
  ON SCHEMA schema1
  TO ROLE warehouse_task_creation;

-- Example 6149
from snowflake.core.role import Securable

root.session.use_role("ACCOUNTADMIN")

root.roles['warehouse_task_creation'].grant_privileges(
    privileges=["CREATE TASK"], securable_type="schema", securable=Securable(name='schema1')
)

-- Example 6150
GRANT USAGE
  ON WAREHOUSE warehouse1
  TO ROLE warehouse_task_creation;

-- Example 6151
from snowflake.core.role import Securable

root.roles['warehouse_task_creation'].grant_privileges(
    privileges=["USAGE"], securable_type="warehouse", securable=Securable(name='warehouse1')
)

-- Example 6152
USE SYSADMIN;

CREATE ROLE serverless_task_creation
  COMMENT = 'This role can create serverless tasks.';

-- Example 6153
from snowflake.core.role import Role

root.session.use_role("SYSADMIN")

my_role = Role(
    name="serverless_task_creation",
    comment="This role can create serverless tasks."
)
root.roles.create(my_role)

-- Example 6154
USE ACCOUNTADMIN;

GRANT CREATE TASK
  ON SCHEMA schema1
  TO ROLE serverless_task_creation;

-- Example 6155
from snowflake.core.role import Securable

root.session.use_role("ACCOUNTADMIN")

root.roles['serverless_task_creation'].grant_privileges(
    privileges=["CREATE TASK"], securable_type="schema", securable=Securable(name='schema1')
)

-- Example 6156
GRANT EXECUTE MANAGED TASK ON ACCOUNT
  TO ROLE serverless_task_creation;

-- Example 6157
root.roles['serverless_task_creation'].grant_privileges(
    privileges=["EXECUTE MANAGED TASK"], securable_type="account"
)

-- Example 6158
USE ROLE securityadmin;

CREATE ROLE taskadmin;

-- Example 6159
from snowflake.core.role import Role

root.session.use_role("securityadmin")

root.roles.create(Role(name="taskadmin"))

-- Example 6160
USE ROLE accountadmin;

GRANT EXECUTE TASK, EXECUTE MANAGED TASK ON ACCOUNT TO ROLE taskadmin;

-- Example 6161
root.session.use_role("accountadmin")

root.roles['taskadmin'].grant_privileges(
    privileges=["EXECUTE TASK", "EXECUTE MANAGED TASK"], securable_type="account"
)

-- Example 6162
USE ROLE securityadmin;

GRANT ROLE taskadmin TO ROLE myrole;

-- Example 6163
from snowflake.core.role import Securable

root.session.use_role("securityadmin")

root.roles['myrole'].grant_role(role_type="ROLE", role=Securable(name='taskadmin'))

-- Example 6164
SHA1(<msg>)

SHA1_HEX(<msg>)

-- Example 6165
SELECT sha1('Snowflake');

------------------------------------------+
            SHA1('SNOWFLAKE')             |
------------------------------------------+
 fda76b0bcc1e87cf259b1d1e3271d76f590fb5dd |
------------------------------------------+

-- Example 6166
CREATE TABLE sha_table(
    v VARCHAR, 
    v_as_sha1 VARCHAR,
    v_as_sha1_hex VARCHAR,
    v_as_sha1_binary BINARY,
    v_as_sha2 VARCHAR,
    v_as_sha2_hex VARCHAR,
    v_as_sha2_binary BINARY
    );
INSERT INTO sha_table(v) VALUES ('AbCd0');
UPDATE sha_table SET 
    v_as_sha1 = SHA1(v),
    v_as_sha1_hex = SHA1_HEX(v),
    v_as_sha1_binary = SHA1_BINARY(v),
    v_as_sha2 = SHA2(v),
    v_as_sha2_hex = SHA2_HEX(v),
    v_as_sha2_binary = SHA2_BINARY(v)
    ;

-- Example 6167
SELECT v, v_as_sha1, v_as_sha1_hex
  FROM sha_table
  ORDER BY v;
+-------+------------------------------------------+------------------------------------------+
| V     | V_AS_SHA1                                | V_AS_SHA1_HEX                            |
|-------+------------------------------------------+------------------------------------------|
| AbCd0 | 9ddb991863d53b35a52c490db256207c776ab8d8 | 9ddb991863d53b35a52c490db256207c776ab8d8 |
+-------+------------------------------------------+------------------------------------------+

-- Example 6168
SHA1_BINARY(<msg>)

-- Example 6169
SELECT sha1_binary('Snowflake');

------------------------------------------+
         SHA1_BINARY('SNOWFLAKE')         |
------------------------------------------+
 FDA76B0BCC1E87CF259B1D1E3271D76F590FB5DD |
------------------------------------------+

-- Example 6170
CREATE TABLE sha_table(
    v VARCHAR, 
    v_as_sha1 VARCHAR,
    v_as_sha1_hex VARCHAR,
    v_as_sha1_binary BINARY,
    v_as_sha2 VARCHAR,
    v_as_sha2_hex VARCHAR,
    v_as_sha2_binary BINARY
    );
INSERT INTO sha_table(v) VALUES ('AbCd0');
UPDATE sha_table SET 
    v_as_sha1 = SHA1(v),
    v_as_sha1_hex = SHA1_HEX(v),
    v_as_sha1_binary = SHA1_BINARY(v),
    v_as_sha2 = SHA2(v),
    v_as_sha2_hex = SHA2_HEX(v),
    v_as_sha2_binary = SHA2_BINARY(v)
    ;

-- Example 6171
SELECT v, v_as_sha1_binary
  FROM sha_table
  ORDER BY v;
+-------+------------------------------------------+
| V     | V_AS_SHA1_BINARY                         |
|-------+------------------------------------------|
| AbCd0 | 9DDB991863D53B35A52C490DB256207C776AB8D8 |
+-------+------------------------------------------+

-- Example 6172
SHA2( <msg> [, <digest_size>] )

SHA2_HEX( <msg> [, <digest_size>] )

-- Example 6173
SELECT sha2('Snowflake', 224);

----------------------------------------------------------+
                  SHA2('SNOWFLAKE', 224)                  |
----------------------------------------------------------+
 6267d3d7a59929e6864dd4b737d98e3ef8569d9f88a7466647838532 |
----------------------------------------------------------+

-- Example 6174
CREATE TABLE sha_table(
    v VARCHAR, 
    v_as_sha1 VARCHAR,
    v_as_sha1_hex VARCHAR,
    v_as_sha1_binary BINARY,
    v_as_sha2 VARCHAR,
    v_as_sha2_hex VARCHAR,
    v_as_sha2_binary BINARY
    );
INSERT INTO sha_table(v) VALUES ('AbCd0');
UPDATE sha_table SET 
    v_as_sha1 = SHA1(v),
    v_as_sha1_hex = SHA1_HEX(v),
    v_as_sha1_binary = SHA1_BINARY(v),
    v_as_sha2 = SHA2(v),
    v_as_sha2_hex = SHA2_HEX(v),
    v_as_sha2_binary = SHA2_BINARY(v)
    ;

-- Example 6175
SELECT v, v_as_sha2, v_as_sha2_hex
  FROM sha_table
  ORDER BY v;
+-------+------------------------------------------------------------------+------------------------------------------------------------------+
| V     | V_AS_SHA2                                                        | V_AS_SHA2_HEX                                                    |
|-------+------------------------------------------------------------------+------------------------------------------------------------------|
| AbCd0 | e1d8ba27889d6782008f495473278c4f071995c5549a976e4d4f93863ce93643 | e1d8ba27889d6782008f495473278c4f071995c5549a976e4d4f93863ce93643 |
+-------+------------------------------------------------------------------+------------------------------------------------------------------+

-- Example 6176
SHA2_BINARY(<msg> [, <digest_size>])

-- Example 6177
SELECT sha2_binary('Snowflake', 384);

--------------------------------------------------------------------------------------------------+
                                   SHA2_BINARY('SNOWFLAKE', 384)                                  |
--------------------------------------------------------------------------------------------------+
 736BD8A53845348830B1EE63A8CD3972F031F13B111F66FFDEC2271A7AE709662E503A0CA305BD50DA8D1CED48CD45D9 |
--------------------------------------------------------------------------------------------------+

-- Example 6178
CREATE TABLE sha_table(
    v VARCHAR, 
    v_as_sha1 VARCHAR,
    v_as_sha1_hex VARCHAR,
    v_as_sha1_binary BINARY,
    v_as_sha2 VARCHAR,
    v_as_sha2_hex VARCHAR,
    v_as_sha2_binary BINARY
    );
INSERT INTO sha_table(v) VALUES ('AbCd0');
UPDATE sha_table SET 
    v_as_sha1 = SHA1(v),
    v_as_sha1_hex = SHA1_HEX(v),
    v_as_sha1_binary = SHA1_BINARY(v),
    v_as_sha2 = SHA2(v),
    v_as_sha2_hex = SHA2_HEX(v),
    v_as_sha2_binary = SHA2_BINARY(v)
    ;

-- Example 6179
SELECT v, v_as_sha2_binary
  FROM sha_table
  ORDER BY v;
+-------+------------------------------------------------------------------+
| V     | V_AS_SHA2_BINARY                                                 |
|-------+------------------------------------------------------------------|
| AbCd0 | E1D8BA27889D6782008F495473278C4F071995C5549A976E4D4F93863CE93643 |
+-------+------------------------------------------------------------------+

-- Example 6180
SNOWFLAKE.SNOWPARK.SHOW_PYTHON_PACKAGES_DEPENDENCIES( '<Python_runtime_version>', '<packages_list>' )

-- Example 6181
USE ROLE ACCOUNTADMIN;

select SNOWFLAKE.SNOWPARK.SHOW_PYTHON_PACKAGES_DEPENDENCIES('3.10', ['numpy']);

-- Example 6182
['_libgcc_mutex==0.1', '_openmp_mutex==5.1', 'blas==1.0', 'ca-certificates==2023.05.30', 'intel-openmp==2021.4.0',
'ld_impl_linux-64==2.38', 'ld_impl_linux-aarch64==2.38', 'libffi==3.4.4', 'libgcc-ng==11.2.0', 'libgfortran-ng==11.2.0',
'libgfortran5==11.2.0', 'libgomp==11.2.0', 'libopenblas==0.3.21', 'libstdcxx-ng==11.2.0', 'mkl-service==2.4.0',
'mkl==2021.4.0', 'mkl_fft==1.3.1', 'mkl_random==1.2.2', 'ncurses==6.4', 'numpy-base==1.24.3', 'numpy==1.24.3',
'openssl==3.0.10', 'python==3.10', 'readline==8.2', 'six==1.16.0', 'sqlite==3.41.2', 'tk==8.6.12', 'xz==5.4.2', 'zlib==1.2.13']

-- Example 6183
SIGN( <expr> )

-- Example 6184
SELECT SIGN(5), SIGN(-1.35e-10), SIGN(0);

---------+-----------------+---------+
 SIGN(5) | SIGN(-1.35E-10) | SIGN(0) |
---------+-----------------+---------+
 1       | -1              | 0       |
---------+-----------------+---------+

-- Example 6185
SIN( <real_expr> )

-- Example 6186
SELECT SIN(0), SIN(PI()/3), SIN(RADIANS(90));
--------+--------------+------------------+
 SIN(0) | SIN(PI()/3)  | SIN(RADIANS(90)) |
--------+--------------+------------------+
 0      | 0.8660254038 | 1                |
--------+--------------+------------------+

-- Example 6187
SINH( <real_expr> )

-- Example 6188
SELECT SINH(1.5);

-------------+
  SINH(1.5)  |
-------------+
 2.129279455 |
-------------+

-- Example 6189
SOUNDEX( <varchar_expr> )

-- Example 6190
SELECT SOUNDEX('I love rock and roll music.'),
       SOUNDEX('I love rocks and gemstones.'),
       SOUNDEX('I leave a rock wherever I go.');
+----------------------------------------+--------------------------+------------------------------------------+
| SOUNDEX('I LOVE ROCK AND ROLL MUSIC.') | SOUNDEX('I LOVE ROCKS.') | SOUNDEX('I LEAVE A ROCK WHEREVER I GO.') |
|----------------------------------------+--------------------------+------------------------------------------|
| I416                                   | I416                     | I416                                     |
+----------------------------------------+--------------------------+------------------------------------------+

-- Example 6191
SELECT SOUNDEX('Marks'), SOUNDEX('Marx');
+------------------+-----------------+
| SOUNDEX('MARKS') | SOUNDEX('MARX') |
|------------------+-----------------|
| M620             | M620            |
+------------------+-----------------+

-- Example 6192
CREATE TABLE sounding_board (v VARCHAR);
CREATE TABLE sounding_bored (v VARCHAR);
INSERT INTO sounding_board (v) VALUES ('Marsha');
INSERT INTO sounding_bored (v) VALUES ('Marcia');

-- Example 6193
SELECT * 
    FROM sounding_board AS board, sounding_bored AS bored 
    WHERE bored.v = board.v;
+---+---+
| V | V |
|---+---|
+---+---+

-- Example 6194
SELECT * 
    FROM sounding_board AS board, sounding_bored AS bored 
    WHERE SOUNDEX(bored.v) = SOUNDEX(board.v);
+--------+--------+
| V      | V      |
|--------+--------|
| Marsha | Marcia |
+--------+--------+

-- Example 6195
SOUNDEX_P123( <varchar_expr> )

-- Example 6196
SELECT SOUNDEX('Pfister'),
       SOUNDEX_P123('Pfister'),
       SOUNDEX('LLoyd'),
       SOUNDEX_P123('Lloyd');
+--------------------+-------------------------+------------------+-----------------------+
| SOUNDEX('Pfister') | SOUNDEX_P123('Pfister') | SOUNDEX('Lloyd') | SOUNDEX_P123('Lloyd') |
|--------------------+-------------------------+------------------+-----------------------|
| P236               | P123                    | L300             | L430                  |
+--------------------+-------------------------+------------------+-----------------------+

-- Example 6197
SPACE(<n>)

-- Example 6198
SELECT SPACE(3);

-- Example 6199
SPLIT(<string>, <separator>)

-- Example 6200
SELECT SPLIT('127.0.0.1', '.');

+-------------------------+
| SPLIT('127.0.0.1', '.') |
|-------------------------|
| [                       |
|   "127",                |
|   "0",                  |
|   "0",                  |
|   "1"                   |
| ]                       |
+-------------------------+

-- Example 6201
SELECT SPLIT('|a||', '|');

+--------------------+
| SPLIT('|A||', '|') |
|--------------------|
| [                  |
|   "",              |
|   "a",             |
|   "",              |
|   ""               |
| ]                  |
+--------------------+

-- Example 6202
SELECT * FROM persons;

------+---------------------+
 NAME |      CHILDREN       |
------+---------------------+
 Mark | Marky,Mark Jr,Maria |
 John | Johnny,Jane         |
------+---------------------+

SELECT name, C.value::string AS childName
FROM persons,
     LATERAL FLATTEN(input=>split(children, ',')) C;

------+-----------+
 NAME | CHILDNAME |
------+-----------+
 John | Johnny    |
 John | Jane      |
 Mark | Marky     |
 Mark | Mark Jr   |
 Mark | Maria     |
------+-----------+

-- Example 6203
SPLIT_PART(<string>, <delimiter>, <partNumber>)

-- Example 6204
SELECT column1 part_number_value, column2 portion
  FROM VALUES
    (0, SPLIT_PART('11.22.33', '.',  0)),
    (1, SPLIT_PART('11.22.33', '.',  1)),
    (2, SPLIT_PART('11.22.33', '.',  2)),
    (3, SPLIT_PART('11.22.33', '.',  3)),
    (4, SPLIT_PART('11.22.33', '.',  4)),
    (-1, SPLIT_PART('11.22.33', '.',  -1)),
    (-2, SPLIT_PART('11.22.33', '.',  -2)),
    (-3, SPLIT_PART('11.22.33', '.',  -3)),
    (-4, SPLIT_PART('11.22.33', '.',  -4));

-- Example 6205
+-------------------+---------+
| PART_NUMBER_VALUE | PORTION |
|-------------------+---------|
|                 0 | 11      |
|                 1 | 11      |
|                 2 | 22      |
|                 3 | 33      |
|                 4 |         |
|                -1 | 33      |
|                -2 | 22      |
|                -3 | 11      |
|                -4 |         |
+-------------------+---------+

-- Example 6206
SELECT SPLIT_PART('127.0.0.1', '.', 1) AS first_part,
       SPLIT_PART('127.0.0.1', '.', -1) AS last_part;

-- Example 6207
+------------+-----------+
| FIRST_PART | LAST_PART |
|------------+-----------|
| 127        | 1         |
+------------+-----------+

-- Example 6208
SELECT SPLIT_PART('|a|b|c|', '|', 1) AS first_part,
       SPLIT_PART('|a|b|c|', '|', 2) AS last_part;

-- Example 6209
+------------+-----------+
| FIRST_PART | LAST_PART |
|------------+-----------|
|            | a         |
+------------+-----------+

-- Example 6210
SELECT SPLIT_PART('aaa--bbb-BBB--ccc', '--', 2) AS multi_character_separator;

-- Example 6211
+---------------------------+
| MULTI_CHARACTER_SEPARATOR |
|---------------------------|
| bbb-BBB                   |
+---------------------------+

