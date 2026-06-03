-- Create database
CREATE DATABASE IF NOT EXISTS DCM_TEST_CASES;

-- Create schema
CREATE SCHEMA IF NOT EXISTS DCM_TEST_CASES.test_cases;

-- Create table
CREATE TABLE IF NOT EXISTS DCM_TEST_CASES.test_cases.some_cases (
    id INT,
    name STRING,
    description STRING
);