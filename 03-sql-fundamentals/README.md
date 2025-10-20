# SQL Fundamentals

Welcome to SQL Fundamentals! Here you'll learn the essential skills for working with relational databases.

## 📚 What You'll Learn

- Basic SQL query syntax
- Filtering and sorting data
- Joining tables
- Aggregate functions
- Grouping data
- Subqueries and CTEs

## 📖 Lessons

1. [Introduction to SQL and Databases](lessons/01-intro-to-sql.md)
2. [SELECT Statements](lessons/02-select-statements.md)
3. [Filtering with WHERE](lessons/03-where-clause.md)
4. [Sorting and Limiting Results](lessons/04-order-limit.md)
5. [Joins](lessons/05-joins.md)
6. [Aggregate Functions](lessons/06-aggregates.md)
7. [GROUP BY and HAVING](lessons/07-groupby-having.md)
8. [Subqueries](lessons/08-subqueries.md)
9. [Common Table Expressions (CTEs)](lessons/09-ctes.md)

## 💻 Practice Database

We'll use a sample database with the following tables:

- `employees` - Employee information
- `departments` - Department details
- `projects` - Project information
- `sales` - Sales transactions
- `customers` - Customer data

## 🗄️ Setting Up Your Database

### Using SQLite (Easiest for Beginners)
```bash
# SQLite comes pre-installed on most systems
sqlite3 practice.db
```

### Using PostgreSQL (Recommended for Production)
```bash
# Install PostgreSQL
# Ubuntu/Debian
sudo apt install postgresql

# Mac
brew install postgresql

# Start the service and create database
createdb learning_db
psql learning_db
```

## 📝 Sample Queries

Check the `queries/` folder for example SQL queries organized by topic.

## ✏️ Exercises

Complete the exercises in the `exercises/` folder. Each exercise includes:
- Problem description
- Sample data
- Expected output
- Solution (try solving on your own first!)

## ⏱️ Estimated Time

3-4 weeks of consistent practice

## ✅ Completion Checklist

- [ ] Complete all lessons
- [ ] Run all sample queries
- [ ] Solve all exercises
- [ ] Create your own practice database
- [ ] Write 50+ SQL queries

## 🎯 Project Idea

Build a sample e-commerce database with:
- Products table
- Orders table
- Customers table
- Order items table

Write queries to:
- Find top-selling products
- Calculate revenue by month
- Identify best customers
- Analyze product categories

## 📚 Additional Resources

- [SQLZoo](https://sqlzoo.net/) - Interactive SQL tutorial
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [LeetCode SQL Problems](https://leetcode.com/problemset/database/)
- [Mode SQL Tutorial](https://mode.com/sql-tutorial/)

## 🔑 Key SQL Concepts

### Basic Query Structure
```sql
SELECT column1, column2
FROM table_name
WHERE condition
ORDER BY column1
LIMIT 10;
```

### Common Data Types
- `INTEGER` / `INT` - Whole numbers
- `DECIMAL` / `NUMERIC` - Decimal numbers
- `VARCHAR(n)` - Variable-length text
- `TEXT` - Long text
- `DATE` - Date values
- `TIMESTAMP` - Date and time
- `BOOLEAN` - True/false

### SQL Keywords to Know
- `SELECT` - Retrieve data
- `FROM` - Specify table
- `WHERE` - Filter rows
- `JOIN` - Combine tables
- `GROUP BY` - Group rows
- `HAVING` - Filter groups
- `ORDER BY` - Sort results
- `LIMIT` - Restrict number of rows
