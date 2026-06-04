-- Create database
DEFINE DATABASE DCM_TEST_CASES;

-- Create schema
DEFINE SCHEMA  DCM_TEST_CASES.test_cases;

-- Create table
DEFINE TABLE  DCM_TEST_CASES.test_cases.some_cases (
    id INT,
    name VARCHAR,
    description VARCHAR
    --,test_new_column VARCHAR(50)  -- new column added for testing purposes

);

-- Created table 2
DEFINE TABLE  DCM_TEST_CASES.test_cases.test_fact_demo (
    id INT,
    name_demo VARCHAR
);