-- SQL Joins - Combining Data from Multiple Tables
-- Demonstrates different types of joins with examples

-- Sample data structure (for reference):
-- employees: employee_id, first_name, last_name, department_id, manager_id
-- departments: department_id, department_name, location
-- projects: project_id, project_name, budget
-- project_assignments: employee_id, project_id, hours_worked

-- ============================================
-- INNER JOIN
-- Returns only rows that have matches in both tables
-- ============================================

-- Basic inner join
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- Join with additional conditions
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE d.location = 'New York';

-- ============================================
-- LEFT JOIN (LEFT OUTER JOIN)
-- Returns all rows from left table and matching rows from right table
-- ============================================

-- Find all employees and their departments (including employees without departments)
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- Find employees who are not assigned to any department
SELECT 
    e.first_name,
    e.last_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- ============================================
-- RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns all rows from right table and matching rows from left table
-- ============================================

-- Find all departments and their employees (including departments with no employees)
SELECT 
    d.department_name,
    e.first_name,
    e.last_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- Find departments with no employees
SELECT 
    d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;

-- ============================================
-- FULL OUTER JOIN
-- Returns all rows when there's a match in either table
-- ============================================

-- Find all employees and departments (including unmatched records from both)
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;

-- ============================================
-- SELF JOIN
-- Joining a table to itself
-- ============================================

-- Find employees and their managers
SELECT 
    e.first_name || ' ' || e.last_name AS employee,
    m.first_name || ' ' || m.last_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- ============================================
-- MULTIPLE JOINS
-- Joining more than two tables
-- ============================================

-- Find employees, their departments, and projects
SELECT 
    e.first_name,
    e.last_name,
    d.department_name,
    p.project_name,
    pa.hours_worked
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN project_assignments pa ON e.employee_id = pa.employee_id
INNER JOIN projects p ON pa.project_id = p.project_id;

-- ============================================
-- JOIN with Aggregate Functions
-- ============================================

-- Count employees per department
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC;

-- Total hours worked by employee on all projects
SELECT 
    e.first_name,
    e.last_name,
    SUM(pa.hours_worked) AS total_hours
FROM employees e
INNER JOIN project_assignments pa ON e.employee_id = pa.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING SUM(pa.hours_worked) > 100;

-- ============================================
-- CROSS JOIN
-- Cartesian product of two tables (all possible combinations)
-- ============================================

-- Create all possible employee-project combinations (use carefully!)
SELECT 
    e.first_name,
    e.last_name,
    p.project_name
FROM employees e
CROSS JOIN projects p;

-- Practical use: Generate date range for each employee
-- (assuming you have a dates table)
SELECT 
    e.first_name,
    d.date
FROM employees e
CROSS JOIN date_range d
WHERE d.date BETWEEN '2024-01-01' AND '2024-01-31';

-- ============================================
-- JOIN with USING clause
-- When column names are the same in both tables
-- ============================================

-- Instead of: ON e.department_id = d.department_id
-- You can use: USING (department_id)
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
INNER JOIN departments d USING (department_id);

-- ============================================
-- Complex JOIN Example
-- ============================================

-- Find employees working on high-budget projects in specific locations
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    d.location,
    p.project_name,
    p.budget,
    pa.hours_worked
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN project_assignments pa ON e.employee_id = pa.employee_id
INNER JOIN projects p ON pa.project_id = p.project_id
WHERE p.budget > 100000
  AND d.location IN ('New York', 'San Francisco')
ORDER BY p.budget DESC, pa.hours_worked DESC;
