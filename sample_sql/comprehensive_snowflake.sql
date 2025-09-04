-- Sample Snowflake SQL covering various common statement types

-- DDL Statements
CREATE OR REPLACE DATABASE my_sample_db;

USE DATABASE my_sample_db;

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS production;

USE SCHEMA staging;

CREATE OR REPLACE TABLE raw_events (
    event_id STRING PRIMARY KEY,
    event_timestamp TIMESTAMP_NTZ,
    user_id STRING,
    event_type VARCHAR(50),
    payload VARIANT,
    load_time TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE dim_users (
    user_key INT AUTOINCREMENT START 1 INCREMENT 1,
    user_id STRING UNIQUE,
    user_name VARCHAR(255),
    email VARCHAR(255),
    created_at TIMESTAMP_NTZ,
    updated_at TIMESTAMP_NTZ
);

ALTER TABLE raw_events ADD COLUMN processed_flag BOOLEAN DEFAULT FALSE;
ALTER TABLE raw_events RENAME COLUMN user_id TO client_id;

CREATE OR REPLACE VIEW recent_events_v AS
SELECT
    event_id,
    event_timestamp,
    client_id,
    event_type
FROM raw_events
WHERE event_timestamp >= DATEADD(day, -7, CURRENT_DATE());

CREATE OR REPLACE FUNCTION get_user_email(p_user_id STRING) 
RETURNS STRING 
LANGUAGE SQL 
AS
$$
SELECT email FROM production.dim_users WHERE user_id = p_user_id
$$;

CREATE OR REPLACE PROCEDURE process_raw_events(load_batch_id STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
    // Placeholder for JS procedure logic
    var sql_command = `INSERT INTO production.processed_events SELECT * FROM staging.raw_events WHERE batch = '${LOAD_BATCH_ID}';`;
    try {
        snowflake.execute({sqlText: sql_command});
        return "Success";
    } catch (err) {
        return "Failed: " + err;
    }
$$;

-- DML Statements
INSERT INTO raw_events (event_id, event_timestamp, client_id, event_type, payload)
VALUES 
    ('evt1001', '2023-10-27 10:00:00', 'user_abc', 'login', PARSE_JSON('{"source":"web"}')),
    ('evt1002', '2023-10-27 10:05:00', 'user_xyz', 'click', PARSE_JSON('{"target":"button1"}')),
    ('evt1003', '2023-10-27 10:15:00', 'user_abc', 'logout', NULL);

UPDATE raw_events 
SET processed_flag = TRUE 
WHERE event_id = 'evt1001';

MERGE INTO production.dim_users AS target
USING (
    SELECT DISTINCT 
        client_id,
        PARSE_JSON(payload):name::STRING AS user_name,
        PARSE_JSON(payload):email::STRING AS email,
        MIN(event_timestamp) as first_seen
    FROM staging.raw_events
    WHERE PARSE_JSON(payload):email IS NOT NULL
    GROUP BY 1, 2, 3
) AS source
ON target.user_id = source.client_id
WHEN MATCHED THEN 
    UPDATE SET target.updated_at = CURRENT_TIMESTAMP(), target.user_name = source.user_name
WHEN NOT MATCHED THEN
    INSERT (user_id, user_name, email, created_at, updated_at)
    VALUES (source.client_id, source.user_name, source.email, source.first_seen, CURRENT_TIMESTAMP());

DELETE FROM raw_events WHERE event_type = 'test_event';

-- Query Statements
USE SCHEMA production;

SELECT 
    u.user_name,
    COUNT(e.event_id) AS event_count
FROM raw_events e -- Assuming table exists in production schema after processing
JOIN dim_users u ON e.client_id = u.user_id
WHERE e.event_timestamp > DATEADD(month, -1, CURRENT_DATE())
GROUP BY u.user_name
ORDER BY event_count DESC
LIMIT 10;

-- Other Common Commands
COPY INTO raw_events
FROM @my_stage/events/
FILE_FORMAT = (TYPE = JSON)
ON_ERROR = 'CONTINUE';

CREATE OR REPLACE STAGE my_internal_stage;

GRANT SELECT ON VIEW production.recent_events_v TO ROLE analyst;

-- Database role examples
CREATE DATABASE ROLE IF NOT EXISTS reporting_role;
GRANT DATABASE ROLE reporting_role TO ROLE analyst;

-- Application role examples
CREATE APPLICATION ROLE app_role;
GRANT APPLICATION ROLE app_role TO ROLE analyst;

-- Alert examples
CREATE ALERT sales_alert WAREHOUSE = analytics_wh SCHEDULE = '5 minute' IF EXISTS (SELECT 1) THEN CALL process_sales();
EXECUTE ALERT sales_alert;

-- Notification integration examples
CREATE NOTIFICATION INTEGRATION email_int TYPE = EMAIL DIRECTION = OUTBOUND ENABLED = TRUE NOTIFICATION_PROVIDER = AWS_SES;

-- Dropping objects (commented out by default)
-- DROP TABLE IF EXISTS staging.raw_events;
-- DROP VIEW IF EXISTS production.recent_events_v;
-- DROP SCHEMA IF EXISTS staging;
-- DROP DATABASE IF EXISTS my_sample_db;
