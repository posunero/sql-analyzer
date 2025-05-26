-- More Extracted Snowflake SQL Examples (Set 8)

-- From snowflake_split_405.sql

-- Example: Table creation and insertion for car_sales
CREATE OR REPLACE TABLE car_sales (
  src VARIANT
);

-- Example: Table creation and insertion for sample_product_data
CREATE OR REPLACE TABLE sample_product_data (
  id INTEGER,
  name VARCHAR,
  serial_number VARCHAR,
  category_id INTEGER,
  parent_id INTEGER
);

-- Example: Table creation and insertion for dealership
CREATE OR REPLACE TABLE dealership (
  id INTEGER,
  name VARCHAR
);

-- Example: Table creation and insertion for vehicle
CREATE OR REPLACE TABLE vehicle (
  id INTEGER,
  make VARCHAR,
  model VARCHAR,
  price NUMBER,
  year INTEGER
);

-- Example: Table creation and insertion for customer
CREATE OR REPLACE TABLE customer (
  id INTEGER,
  name VARCHAR,
  address VARCHAR,
  phone VARCHAR
); 