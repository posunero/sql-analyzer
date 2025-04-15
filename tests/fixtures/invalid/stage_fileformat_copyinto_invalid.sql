CREATE FILE FORMAT missing_type FIELD_DELIMITER = ',';
CREATE STAGE no_url_or_fileformat;
COPY INTO FROM @missing_table;
COPY INTO mytable FROM @stage FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER); 