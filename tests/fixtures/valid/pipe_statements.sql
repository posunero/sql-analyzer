-- Fixture for PIPE tests: create, alter, refresh, drop
CREATE PIPE my_pipe
  AUTO_INGEST = TRUE
  AWS_SNS_TOPIC = 'arn:aws:sns:topic'
  COMMENT = 'test pipe'
  AS COPY INTO my_table FROM @my_stage FILE_FORMAT = (FORMAT_NAME = 'fmt');

ALTER PIPE my_pipe SET COMMENT = 'new comment', AUTO_INGEST = FALSE;

ALTER PIPE my_pipe REFRESH;

DROP PIPE IF EXISTS my_pipe; 