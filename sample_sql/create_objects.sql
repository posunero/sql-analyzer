-- DDL statements for creating objects

CREATE OR REPLACE DATABASE finance_db COMMENT = 'Database for financial data';

USE DATABASE finance_db;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS reporting;

USE SCHEMA core;

CREATE TABLE transactions (
    trans_id NUMBER(38,0) NOT NULL,
    trans_date DATE,
    account_id VARCHAR(50),
    amount DECIMAL(18,2),
    description VARCHAR(255)
);

CREATE VIEW reporting.monthly_summary_v AS
SELECT 
    DATE_TRUNC('MONTH', trans_date) as transaction_month,
    account_id,
    SUM(amount) as total_amount,
    COUNT(*) as transaction_count
FROM core.transactions
GROUP BY 1, 2; 