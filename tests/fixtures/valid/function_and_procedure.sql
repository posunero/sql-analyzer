-- Functions and Procedures

CREATE OR REPLACE FUNCTION simple_math.add_two_integers(a INT, b INT)
RETURNS INT
LANGUAGE SQL
COMMENT = 'Adds two integers together'
AS $$
    a + b
$$;

CREATE OR REPLACE SECURE FUNCTION financial_data.calculate_tax(amount NUMBER(10,2))
RETURNS NUMBER(10,2)
AS $$
    amount * 0.075
$$;

-- Example of a stored procedure (might need grammar adjustment)
CREATE OR REPLACE PROCEDURE admin_tasks.cleanup_logs(retention_days INT)
RETURNS VARCHAR
LANGUAGE SQL
AS $$
DECLARE
    cutoff_date TIMESTAMP;
BEGIN
    cutoff_date := DATEADD(day, -retention_days, CURRENT_TIMESTAMP());
    
    DELETE FROM internal_logs.audit_trail WHERE event_timestamp < :cutoff_date;
    
    RETURN 'Log cleanup completed for entries older than ' || cutoff_date::varchar;
END;
$$;

-- Use a function (just for testing reference detection)
SELECT simple_math.add_two_integers(5, 3); 