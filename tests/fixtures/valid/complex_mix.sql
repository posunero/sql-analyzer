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