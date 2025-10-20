-- WHERE Clause Examples
-- Filtering data with various conditions

-- Basic equality
SELECT * FROM employees
WHERE department_id = 5;

-- Not equal
SELECT * FROM employees
WHERE department_id != 5;
-- or
SELECT * FROM employees
WHERE department_id <> 5;

-- Comparison operators
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 50000;

SELECT * FROM employees
WHERE hire_date >= '2020-01-01';

-- BETWEEN operator
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 40000 AND 60000;

-- IN operator (match any value in a list)
SELECT * FROM employees
WHERE department_id IN (1, 3, 5);

SELECT * FROM products
WHERE category IN ('Electronics', 'Clothing', 'Books');

-- LIKE operator (pattern matching)
-- % matches any sequence of characters
-- _ matches any single character

-- Names starting with 'J'
SELECT * FROM employees
WHERE first_name LIKE 'J%';

-- Names ending with 'son'
SELECT * FROM employees
WHERE last_name LIKE '%son';

-- Names containing 'ar'
SELECT * FROM employees
WHERE first_name LIKE '%ar%';

-- Email addresses from gmail
SELECT * FROM employees
WHERE email LIKE '%@gmail.com';

-- Names with exactly 4 characters
SELECT * FROM employees
WHERE first_name LIKE '____';

-- NULL checks
SELECT * FROM employees
WHERE manager_id IS NULL;

SELECT * FROM employees
WHERE phone_number IS NOT NULL;

-- Combining conditions with AND
SELECT * FROM employees
WHERE salary > 50000 
  AND department_id = 3;

-- Combining conditions with OR
SELECT * FROM employees
WHERE department_id = 1 
   OR department_id = 5;

-- Using AND with OR (use parentheses for clarity)
SELECT * FROM employees
WHERE (department_id = 1 OR department_id = 5)
  AND salary > 50000;

-- NOT operator
SELECT * FROM employees
WHERE NOT department_id = 5;

SELECT * FROM employees
WHERE department_id NOT IN (1, 2, 3);

-- Complex conditions
SELECT 
    first_name,
    last_name,
    salary,
    department_id
FROM employees
WHERE 
    (salary BETWEEN 40000 AND 70000)
    AND department_id IN (2, 4, 6)
    AND hire_date >= '2019-01-01'
    AND email LIKE '%@company.com';
