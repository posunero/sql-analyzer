-- More Extracted Snowflake SQL Examples (Set 9)

-- From snowflake_split_406.sql

-- Join examples
SELECT * FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a;
SELECT a.value AS LeftValue, b.value AS RightValue FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a;
SELECT * FROM sample_a a NATURAL JOIN sample_b b;
SELECT * FROM sample_a a LEFT OUTER JOIN sample_b b ON a.id_a = b.id_a;
SELECT * FROM sample_a a JOIN sample_b b ON a.id_a = b.id_a JOIN sample_c c ON a.id_a = c.id_a;
-- Self-join example
SELECT * FROM sample_product_data l JOIN sample_product_data r ON l.id = r.parent_id; 