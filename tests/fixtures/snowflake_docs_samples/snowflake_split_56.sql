-- Example 3735
+------+----------+----------------------------+---------------------------+----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'LEFT') | BITOR(BIT1, BIT3, 'LEFT') | BITXOR(BIT1, BIT3, 'LEFT') |
|------+----------+----------------------------+---------------------------+----------------------------|
| 1010 | 11001010 | 00001010                   | 11001010                  | 11000000                   |
| 1100 | 01011010 | 00001000                   | 01011110                  | 01010110                   |
| BCBC | ABCDABCD | 0000A88C                   | ABCDBFFD                  | ABCD1771                   |
| NULL | NULL     | NULL                       | NULL                      | NULL                       |
+------+----------+----------------------------+---------------------------+----------------------------+

-- Example 3736
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'RIGHT'),
       BITOR(bit1, bit3, 'RIGHT'),
       BITXOR(bit1, bit3, 'RIGHT')
  FROM bits;

-- Example 3737
+------+----------+-----------------------------+----------------------------+-----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'RIGHT') | BITOR(BIT1, BIT3, 'RIGHT') | BITXOR(BIT1, BIT3, 'RIGHT') |
|------+----------+-----------------------------+----------------------------+-----------------------------|
| 1010 | 11001010 | 10000000                    | 11101010                   | 01101010                    |
| 1100 | 01011010 | 01000000                    | 11011010                   | 10011010                    |
| BCBC | ABCDABCD | A88C0000                    | BFFDABCD                   | 1771ABCD                    |
| NULL | NULL     | NULL                        | NULL                       | NULL                        |
+------+----------+-----------------------------+----------------------------+-----------------------------+

-- Example 3738
BITNOT( <expr> )

-- Example 3739
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3740
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3741
SELECT bit1, 
       bit2, 
       BITNOT(bit1), 
       BITNOT(bit2)
  FROM bits
  ORDER BY bit1;

-- Example 3742
+------+-------+--------------+--------------+
| BIT1 |  BIT2 | BITNOT(BIT1) | BITNOT(BIT2) |
|------+-------+--------------+--------------|
|    0 | 65504 |           -1 |       -65505 |
|    1 |     1 |           -2 |           -2 |
|    2 |     4 |           -3 |           -5 |
|    4 |     2 |           -5 |           -3 |
|   16 |    24 |          -17 |          -25 |
| NULL |  NULL |         NULL |         NULL |
+------+-------+--------------+--------------+

-- Example 3743
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3744
SELECT bit1,
       bit2,
       bit3,
       BITNOT(bit1),
       BITNOT(bit2),
       BITNOT(bit3)
  FROM bits;

-- Example 3745
+------+------+----------+--------------+--------------+--------------+
| BIT1 | BIT2 | BIT3     | BITNOT(BIT1) | BITNOT(BIT2) | BITNOT(BIT3) |
|------+------+----------+--------------+--------------+--------------|
| 1010 | 0101 | 11001010 | EFEF         | FEFE         | EEFFEFEF     |
| 1100 | 0011 | 01011010 | EEFF         | FFEE         | FEFEEFEF     |
| BCBC | EEFF | ABCDABCD | 4343         | 1100         | 54325432     |
| NULL | NULL | NULL     | NULL         | NULL         | NULL         |
+------+------+----------+--------------+--------------+--------------+

-- Example 3746
BITOR( <expr1> , <expr2> [ , '<padside>' ] )

-- Example 3747
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3748
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3749
SELECT bit1, 
       bit2, 
       BITAND(bit1, bit2), 
       BITOR(bit1, bit2), 
       BITXOR(bit1, BIT2)
  FROM bits
  ORDER BY bit1;

-- Example 3750
+------+-------+--------------------+-------------------+--------------------+
| BIT1 |  BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+-------+--------------------+-------------------+--------------------|
|    0 | 65504 |                  0 |             65504 |              65504 |
|    1 |     1 |                  1 |                 1 |                  0 |
|    2 |     4 |                  0 |                 6 |                  6 |
|    4 |     2 |                  0 |                 6 |                  6 |
|   16 |    24 |                 16 |                24 |                  8 |
| NULL |  NULL |               NULL |              NULL |               NULL |
+------+-------+--------------------+-------------------+--------------------+

-- Example 3751
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3752
SELECT bit1,
       bit2,
       BITAND(bit1, bit2),
       BITOR(bit1, bit2),
       BITXOR(bit1, bit2)
  FROM bits;

-- Example 3753
+------+------+--------------------+-------------------+--------------------+
| BIT1 | BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+------+--------------------+-------------------+--------------------|
| 1010 | 0101 | 0000               | 1111              | 1111               |
| 1100 | 0011 | 0000               | 1111              | 1111               |
| BCBC | EEFF | ACBC               | FEFF              | 5243               |
| NULL | NULL | NULL               | NULL              | NULL               |
+------+------+--------------------+-------------------+--------------------+

-- Example 3754
SELECT bit1,
       bit3,
       BITAND(bit1, bit3),
       BITOR(bit1, bit3),
       BITXOR(bit1, bit3)
  FROM bits;

-- Example 3755
100544 (22026): The lengths of two variable-sized fields do not match: first length 2, second length 4

-- Example 3756
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'LEFT'),
       BITOR(bit1, bit3, 'LEFT'),
       BITXOR(bit1, bit3, 'LEFT')
  FROM bits;

-- Example 3757
+------+----------+----------------------------+---------------------------+----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'LEFT') | BITOR(BIT1, BIT3, 'LEFT') | BITXOR(BIT1, BIT3, 'LEFT') |
|------+----------+----------------------------+---------------------------+----------------------------|
| 1010 | 11001010 | 00001010                   | 11001010                  | 11000000                   |
| 1100 | 01011010 | 00001000                   | 01011110                  | 01010110                   |
| BCBC | ABCDABCD | 0000A88C                   | ABCDBFFD                  | ABCD1771                   |
| NULL | NULL     | NULL                       | NULL                      | NULL                       |
+------+----------+----------------------------+---------------------------+----------------------------+

-- Example 3758
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'RIGHT'),
       BITOR(bit1, bit3, 'RIGHT'),
       BITXOR(bit1, bit3, 'RIGHT')
  FROM bits;

-- Example 3759
+------+----------+-----------------------------+----------------------------+-----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'RIGHT') | BITOR(BIT1, BIT3, 'RIGHT') | BITXOR(BIT1, BIT3, 'RIGHT') |
|------+----------+-----------------------------+----------------------------+-----------------------------|
| 1010 | 11001010 | 10000000                    | 11101010                   | 01101010                    |
| 1100 | 01011010 | 01000000                    | 11011010                   | 10011010                    |
| BCBC | ABCDABCD | A88C0000                    | BFFDABCD                   | 1771ABCD                    |
| NULL | NULL     | NULL                        | NULL                       | NULL                        |
+------+----------+-----------------------------+----------------------------+-----------------------------+

-- Example 3760
BITSHIFTLEFT( <expr1> , <n> )

-- Example 3761
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3762
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3763
SELECT bit1, 
       bit2, 
       BITSHIFTLEFT(bit1, 1), 
       BITSHIFTRIGHT(bit2, 1)
  FROM bits
  ORDER BY bit1;

-- Example 3764
+------+-------+-----------------------+------------------------+
| BIT1 |  BIT2 | BITSHIFTLEFT(BIT1, 1) | BITSHIFTRIGHT(BIT2, 1) |
|------+-------+-----------------------+------------------------|
|    0 | 65504 |                     0 |                  32752 |
|    1 |     1 |                     2 |                      0 |
|    2 |     4 |                     4 |                      2 |
|    4 |     2 |                     8 |                      1 |
|   16 |    24 |                    32 |                     12 |
| NULL |  NULL |                  NULL |                   NULL |
+------+-------+-----------------------+------------------------+

-- Example 3765
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3766
SELECT bit1,
       bit3,
       BITSHIFTLEFT(bit1, 1),
       BITSHIFTLEFT(bit3, 1),
       BITSHIFTLEFT(bit1, 8),
       BITSHIFTLEFT(bit3, 16)
  FROM bits;

-- Example 3767
+------+----------+-----------------------+-----------------------+-----------------------+------------------------+
| BIT1 | BIT3     | BITSHIFTLEFT(BIT1, 1) | BITSHIFTLEFT(BIT3, 1) | BITSHIFTLEFT(BIT1, 8) | BITSHIFTLEFT(BIT3, 16) |
|------+----------+-----------------------+-----------------------+-----------------------+------------------------|
| 1010 | 11001010 | 2020                  | 22002020              | 1000                  | 10100000               |
| 1100 | 01011010 | 2200                  | 02022020              | 0000                  | 10100000               |
| BCBC | ABCDABCD | 7978                  | 579B579A              | BC00                  | ABCD0000               |
| NULL | NULL     | NULL                  | NULL                  | NULL                  | NULL                   |
+------+----------+-----------------------+-----------------------+-----------------------+------------------------+

-- Example 3768
BITSHIFTRIGHT( <expr1> , <n> )

-- Example 3769
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3770
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3771
SELECT bit1, 
       bit2, 
       BITSHIFTLEFT(bit1, 1), 
       BITSHIFTRIGHT(bit2, 1)
  FROM bits
  ORDER BY bit1;

-- Example 3772
+------+-------+-----------------------+------------------------+
| BIT1 |  BIT2 | BITSHIFTLEFT(BIT1, 1) | BITSHIFTRIGHT(BIT2, 1) |
|------+-------+-----------------------+------------------------|
|    0 | 65504 |                     0 |                  32752 |
|    1 |     1 |                     2 |                      0 |
|    2 |     4 |                     4 |                      2 |
|    4 |     2 |                     8 |                      1 |
|   16 |    24 |                    32 |                     12 |
| NULL |  NULL |                  NULL |                   NULL |
+------+-------+-----------------------+------------------------+

-- Example 3773
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3774
SELECT bit1,
       bit3,
       BITSHIFTRIGHT(bit1, 1),
       BITSHIFTRIGHT(bit3, 1),
       BITSHIFTRIGHT(bit1, 8),
       BITSHIFTRIGHT(bit3, 16)
  FROM bits;

-- Example 3775
+------+----------+------------------------+------------------------+------------------------+-------------------------+
| BIT1 | BIT3     | BITSHIFTRIGHT(BIT1, 1) | BITSHIFTRIGHT(BIT3, 1) | BITSHIFTRIGHT(BIT1, 8) | BITSHIFTRIGHT(BIT3, 16) |
|------+----------+------------------------+------------------------+------------------------+-------------------------|
| 1010 | 11001010 | 0808                   | 08800808               | 0010                   | 00001100                |
| 1100 | 01011010 | 0880                   | 00808808               | 0011                   | 00000101                |
| BCBC | ABCDABCD | 5E5E                   | 55E6D5E6               | 00BC                   | 0000ABCD                |
| NULL | NULL     | NULL                   | NULL                   | NULL                   | NULL                    |
+------+----------+------------------------+------------------------+------------------------+-------------------------+

-- Example 3776
BITXOR( <expr1> , <expr2> [ , '<padside>' ] )

-- Example 3777
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 INTEGER, bit2 INTEGER);

-- Example 3778
INSERT INTO bits (ID, bit1, bit2) VALUES 
  (   11,    1,     1),    -- Bits are all the same.
  (   24,    2,     4),    -- Bits are all different.
  (   42,    4,     2),    -- Bits are all different.
  ( 1624,   16,    24),    -- Bits overlap.
  (65504,    0, 65504),    -- Lots of bits (all but the low 6 bits).
  (    0, NULL,  NULL)     -- No bits.
  ;

-- Example 3779
SELECT bit1, 
       bit2, 
       BITAND(bit1, bit2), 
       BITOR(bit1, bit2), 
       BITXOR(bit1, BIT2)
  FROM bits
  ORDER BY bit1;

-- Example 3780
+------+-------+--------------------+-------------------+--------------------+
| BIT1 |  BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+-------+--------------------+-------------------+--------------------|
|    0 | 65504 |                  0 |             65504 |              65504 |
|    1 |     1 |                  1 |                 1 |                  0 |
|    2 |     4 |                  0 |                 6 |                  6 |
|    4 |     2 |                  0 |                 6 |                  6 |
|   16 |    24 |                 16 |                24 |                  8 |
| NULL |  NULL |               NULL |              NULL |               NULL |
+------+-------+--------------------+-------------------+--------------------+

-- Example 3781
CREATE OR REPLACE TABLE bits (ID INTEGER, bit1 BINARY(2), bit2 BINARY(2), bit3 BINARY(4));

INSERT INTO bits VALUES
  (1, x'1010', x'0101', x'11001010'),
  (2, x'1100', x'0011', x'01011010'),
  (3, x'BCBC', x'EEFF', x'ABCDABCD'),
  (4, NULL, NULL, NULL);

-- Example 3782
SELECT bit1,
       bit2,
       BITAND(bit1, bit2),
       BITOR(bit1, bit2),
       BITXOR(bit1, bit2)
  FROM bits;

-- Example 3783
+------+------+--------------------+-------------------+--------------------+
| BIT1 | BIT2 | BITAND(BIT1, BIT2) | BITOR(BIT1, BIT2) | BITXOR(BIT1, BIT2) |
|------+------+--------------------+-------------------+--------------------|
| 1010 | 0101 | 0000               | 1111              | 1111               |
| 1100 | 0011 | 0000               | 1111              | 1111               |
| BCBC | EEFF | ACBC               | FEFF              | 5243               |
| NULL | NULL | NULL               | NULL              | NULL               |
+------+------+--------------------+-------------------+--------------------+

-- Example 3784
SELECT bit1,
       bit3,
       BITAND(bit1, bit3),
       BITOR(bit1, bit3),
       BITXOR(bit1, bit3)
  FROM bits;

-- Example 3785
100544 (22026): The lengths of two variable-sized fields do not match: first length 2, second length 4

-- Example 3786
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'LEFT'),
       BITOR(bit1, bit3, 'LEFT'),
       BITXOR(bit1, bit3, 'LEFT')
  FROM bits;

-- Example 3787
+------+----------+----------------------------+---------------------------+----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'LEFT') | BITOR(BIT1, BIT3, 'LEFT') | BITXOR(BIT1, BIT3, 'LEFT') |
|------+----------+----------------------------+---------------------------+----------------------------|
| 1010 | 11001010 | 00001010                   | 11001010                  | 11000000                   |
| 1100 | 01011010 | 00001000                   | 01011110                  | 01010110                   |
| BCBC | ABCDABCD | 0000A88C                   | ABCDBFFD                  | ABCD1771                   |
| NULL | NULL     | NULL                       | NULL                      | NULL                       |
+------+----------+----------------------------+---------------------------+----------------------------+

-- Example 3788
SELECT bit1,
       bit3,
       BITAND(bit1, bit3, 'RIGHT'),
       BITOR(bit1, bit3, 'RIGHT'),
       BITXOR(bit1, bit3, 'RIGHT')
  FROM bits;

-- Example 3789
+------+----------+-----------------------------+----------------------------+-----------------------------+
| BIT1 | BIT3     | BITAND(BIT1, BIT3, 'RIGHT') | BITOR(BIT1, BIT3, 'RIGHT') | BITXOR(BIT1, BIT3, 'RIGHT') |
|------+----------+-----------------------------+----------------------------+-----------------------------|
| 1010 | 11001010 | 10000000                    | 11101010                   | 01101010                    |
| 1100 | 01011010 | 01000000                    | 11011010                   | 10011010                    |
| BCBC | ABCDABCD | A88C0000                    | BFFDABCD                   | 1771ABCD                    |
| NULL | NULL     | NULL                        | NULL                       | NULL                        |
+------+----------+-----------------------------+----------------------------+-----------------------------+

-- Example 3790
BOOLAND( expr1 , expr2 )

-- Example 3791
SELECT BOOLAND(1, -2), BOOLAND(0, 2.35), BOOLAND(0, 0), BOOLAND(0, NULL), BOOLAND(NULL, 3), BOOLAND(NULL, NULL);

+----------------+------------------+---------------+------------------+------------------+---------------------+
| BOOLAND(1, -2) | BOOLAND(0, 2.35) | BOOLAND(0, 0) | BOOLAND(0, NULL) | BOOLAND(NULL, 3) | BOOLAND(NULL, NULL) |
|----------------+------------------+---------------+------------------+------------------+---------------------|
| True           | False            | False         | False            | NULL             | NULL                |
+----------------+------------------+---------------+------------------+------------------+---------------------+

-- Example 3792
BOOLNOT( expr )

-- Example 3793
SELECT BOOLNOT(0), BOOLNOT(10), BOOLNOT(-3.79), BOOLNOT(NULL);

+------------+-------------+----------------+---------------+
| BOOLNOT(0) | BOOLNOT(10) | BOOLNOT(-3.79) | BOOLNOT(NULL) |
|------------+-------------+----------------+---------------|
| True       | False       | False          | NULL          |
+------------+-------------+----------------+---------------+

-- Example 3794
BOOLOR( expr1 , expr2 )

-- Example 3795
SELECT BOOLOR(1, 2), BOOLOR(-1.35, 0), BOOLOR(3, NULL), BOOLOR(0, 0), BOOLOR(NULL, 0), BOOLOR(NULL, NULL);

+--------------+------------------+-----------------+--------------+-----------------+--------------------+
| BOOLOR(1, 2) | BOOLOR(-1.35, 0) | BOOLOR(3, NULL) | BOOLOR(0, 0) | BOOLOR(NULL, 0) | BOOLOR(NULL, NULL) |
|--------------+------------------+-----------------+--------------+-----------------+--------------------|
| True         | True             | True            | False        | NULL            | NULL               |
+--------------+------------------+-----------------+--------------+-----------------+--------------------+

-- Example 3796
BOOLXOR( expr1 , expr2 )

-- Example 3797
SELECT BOOLXOR(2, 0), BOOLXOR(1, -1), BOOLXOR(0, 0), BOOLXOR(NULL, 3), BOOLXOR(NULL, 0), BOOLXOR(NULL, NULL);

+---------------+----------------+---------------+------------------+------------------+---------------------+
| BOOLXOR(2, 0) | BOOLXOR(1, -1) | BOOLXOR(0, 0) | BOOLXOR(NULL, 3) | BOOLXOR(NULL, 0) | BOOLXOR(NULL, NULL) |
|---------------+----------------+---------------+------------------+------------------+---------------------|
| True          | False          | False         | NULL             | NULL             | NULL                |
+---------------+----------------+---------------+------------------+------------------+---------------------+

-- Example 3798
BUILD_SCOPED_FILE_URL(
  @<stage_name> ,
  '<relative_file_path>' ,
  <use_privatelink_host_for_business_critical>)

-- Example 3799
https://<account_identifier>/api/files/<query_id>/<encoded_file_path>

-- Example 3800
SELECT BUILD_SCOPED_FILE_URL(@images_stage,'/us/yosemite/half_dome.jpg', TRUE);

-- Example 3801
https://my_account.snowflakecomputing.com/api/files/019260c2-00c0-f2f2-0000-4383001cf046/bXlfZGF0YWJhc2UvbXlfc2NoZW1hL215X3N0YWdlL2ZvbGRlcjEvZm9sZGVyMi9maWxlMQ

