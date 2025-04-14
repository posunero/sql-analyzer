-- A simple SELECT statement

USE DATABASE my_sample_db;
USE SCHEMA production;

SELECT 
    user_name, 
    email
FROM dim_users
WHERE created_at >= '2023-01-01'
ORDER BY user_name; 