-- Sample SQL script with mixed statements, comments, and casing

-- Create a table
CREATE OR REPLACE TABLE my_schema.Mixed_Case_Table (
    ID INT PRIMARY KEY,
    NAME varchar(100),
    UPDATE_TS timestamp_ntz -- A comment at the end of the line
);

/* 
  Multi-line comment
  explaining the next steps.
*/
use warehouse LOAD_WH;

INSERT INTO My_Schema.mixed_case_table (id, name)
VALUES 
    (1, 'First Record'),
    (2, 'Second Record');

USE DATABASE analytics_db;

SELECT id, name FROM my_schema.mixed_case_table WHERE id = 1;

ALTER TABLE my_schema.Mixed_Case_Table ADD COLUMN created_ts timestamp_ltz DEFAULT CURRENT_TIMESTAMP();

-- Drop a view (even if it doesn't exist, for testing)
DROP VIEW IF EXISTS old_reporting_view;

-- TASK statement examples for testing
CREATE OR REPLACE TASK my_hourly_task
  WAREHOUSE = my_wh
  SCHEDULE = 'USING CRON 0 5 * * * UTC'
AS
  INSERT INTO log_tbl VALUES (CURRENT_TIMESTAMP());

ALTER TASK my_hourly_task SET SCHEDULE = 'USING CRON 0 6 * * * UTC';
ALTER TASK my_hourly_task SUSPEND;
ALTER TASK my_hourly_task RESUME;

DROP TASK IF EXISTS my_hourly_task;

EXECUTE TASK my_hourly_task;

SHOW TASKS;

DESCRIBE TASK my_hourly_task; 