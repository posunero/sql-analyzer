-- More Extracted Snowflake SQL Examples (Set 7)

-- From snowflake_split_404.sql

CREATE OR REPLACE TABLE sample_a (
  id_a INTEGER,
  name_a VARCHAR,
  value INTEGER
);
INSERT INTO sample_a (id_a, name_a, value) VALUES
  (10, 'A1', 5),
  (40, 'A2', 10),
  (80, 'A3', 15),
  (90, 'A4', 20)
;
CREATE OR REPLACE TABLE sample_b (
  id_b INTEGER,
  name_b VARCHAR,
  id_a INTEGER,
  value INTEGER
);
INSERT INTO sample_b (id_b, name_b, id_a, value) VALUES
  (4000, 'B1', 40, 10),
  (4001, 'B2', 10, 5),
  (9000, 'B3', 80, 15),
  (9099, 'B4', NULL, 200)
;
CREATE OR REPLACE TABLE sample_c (
  id_c INTEGER,
  name_c VARCHAR,
  id_a INTEGER,
  id_b INTEGER
);
INSERT INTO sample_c (id_c, name_c, id_a, id_b) VALUES
  (1012, 'C1', 10, NULL),
  (1040, 'C2', 40, 4000),
  (1041, 'C3', 40, 4001)
;

-- Join examples
SELECT * FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a;
SELECT a.value AS LeftValue, b.value AS RightValue FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a;
SELECT * FROM sample_a a NATURAL JOIN sample_b b;
SELECT * FROM sample_a a LEFT OUTER JOIN sample_b b ON a.id_a = b.id_a;
SELECT * FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a JOIN sample_c c ON a.id_a = c.id_a; 