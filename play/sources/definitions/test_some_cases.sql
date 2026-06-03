-- Create database
DEFINE DATABASE DCM_TEST_CASES;

-- Create schema
DEFINE SCHEMA  DCM_TEST_CASES.test_cases;

-- Create table
DEFINE TABLE  DCM_TEST_CASES.test_cases.some_cases (
    id INT,
    name STRING,
    description STRING
);