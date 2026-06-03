-- Create database
DEFINE DATABASE IF NOT EXISTS DCM_TEST_CASES;

-- Create schema
DEFINE SCHEMA IF NOT EXISTS DCM_TEST_CASES.test_cases;

-- Create table
DEFINE TABLE IF NOT EXISTS DCM_TEST_CASES.test_cases.some_cases (
    id INT,
    name STRING,
    description STRING
);