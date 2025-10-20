-- Basic SELECT Queries
-- This file contains examples of basic SELECT statements

-- Select all columns from a table
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, email
FROM employees;

-- Select with column aliases
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name",
    salary AS "Annual Salary"
FROM employees;

-- Select distinct values (remove duplicates)
SELECT DISTINCT department_id
FROM employees;

SELECT DISTINCT city, country
FROM customers;

-- Select with calculations
SELECT 
    first_name,
    last_name,
    salary,
    salary * 1.1 AS salary_with_raise,
    salary / 12 AS monthly_salary
FROM employees;

-- Concatenate strings
SELECT 
    first_name || ' ' || last_name AS full_name,
    email
FROM employees;

-- Using CONCAT function (in some SQL dialects)
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    email
FROM employees;

-- Select with LIMIT (restrict number of rows)
SELECT first_name, last_name
FROM employees
LIMIT 5;

-- Select current date/time
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;

-- Select literal values
SELECT 'Hello' AS greeting, 42 AS answer;
