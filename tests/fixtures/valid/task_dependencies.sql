-- Test file for TASK dependencies and AS clause SQL statement dependencies

-- Create a sequence of dependent tasks
CREATE OR REPLACE TASK first_task
  WAREHOUSE = analytics_wh
  SCHEDULE = 'USING CRON 0 0 * * * UTC'
AS
  INSERT INTO audit_log (event_time, event_type, event_name) 
  VALUES (CURRENT_TIMESTAMP(), 'TASK_RUN', 'first_task');

CREATE OR REPLACE TASK second_task
  WAREHOUSE = analytics_wh
  AFTER first_task
AS
  UPDATE staging_table 
  SET processed = TRUE 
  WHERE create_date < CURRENT_DATE();

CREATE OR REPLACE TASK third_task
  WAREHOUSE = reporting_wh
  AFTER second_task
AS
  INSERT INTO reporting.monthly_metrics 
  SELECT 
    date_trunc('MONTH', event_date) as month,
    COUNT(*) as event_count,
    SUM(value) as total_value
  FROM staging_table
  WHERE processed = TRUE
  GROUP BY 1;

-- Task with explicit dependencies on multiple objects
CREATE OR REPLACE TASK complex_etl_task
  WAREHOUSE = etl_wh
  SCHEDULE = 'USING CRON 15 * * * * UTC'
AS
  MERGE INTO target_table t
  USING (
    SELECT s.id, s.name, s.value, r.region_name
    FROM source_table s
    JOIN reference_table r ON s.region_id = r.region_id
    WHERE s.create_date > CURRENT_DATE() - 7
  ) src
  ON t.id = src.id
  WHEN MATCHED THEN 
    UPDATE SET t.name = src.name, t.value = src.value, t.region = src.region_name
  WHEN NOT MATCHED THEN
    INSERT (id, name, value, region) VALUES (src.id, src.name, src.value, src.region_name);

-- Alter a task to change its dependencies
ALTER TASK third_task REMOVE AFTER second_task;
ALTER TASK third_task ADD AFTER complex_etl_task;

-- Task that executes a stored procedure
CREATE OR REPLACE TASK proc_task
  WAREHOUSE = proc_wh
  SCHEDULE = 'USING CRON 30 * * * * UTC'
AS
  CALL process_data('param1', 'param2'); 