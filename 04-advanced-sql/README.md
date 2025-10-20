# Advanced SQL

Welcome to Advanced SQL! Here you'll learn optimization, database design, and advanced query techniques.

## 📚 What You'll Learn

- Database design and normalization
- Indexes and query optimization
- Window functions
- Stored procedures and functions
- Transactions and concurrency
- Performance tuning
- Advanced query patterns

## 📖 Lessons

1. [Database Design Principles](lessons/01-database-design.md)
2. [Normalization](lessons/02-normalization.md)
3. [Indexes and Performance](lessons/03-indexes.md)
4. [Window Functions](lessons/04-window-functions.md)
5. [Stored Procedures](lessons/05-stored-procedures.md)
6. [Transactions](lessons/06-transactions.md)
7. [Query Optimization](lessons/07-query-optimization.md)
8. [Advanced Patterns](lessons/08-advanced-patterns.md)

## 💻 Sample Queries

Check the `queries/` folder for advanced SQL examples:
- Window functions
- Complex aggregations
- Recursive queries
- Performance optimization examples

## ⏱️ Estimated Time

3-4 weeks with hands-on practice

## ✅ Completion Checklist

- [ ] Understand database normalization
- [ ] Design efficient database schemas
- [ ] Use indexes effectively
- [ ] Write window functions
- [ ] Create stored procedures
- [ ] Understand transactions
- [ ] Optimize slow queries
- [ ] Complete all exercises

## 🎯 Key Concepts

### Window Functions
```sql
-- Running total
SELECT 
    date,
    amount,
    SUM(amount) OVER (ORDER BY date) AS running_total
FROM sales;

-- Ranking
SELECT 
    employee_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Partitioned aggregation
SELECT 
    department,
    employee_name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees;
```

### Indexes
```sql
-- Create index
CREATE INDEX idx_employee_name ON employees(last_name, first_name);

-- Create unique index
CREATE UNIQUE INDEX idx_employee_email ON employees(email);

-- Create partial index
CREATE INDEX idx_active_employees 
ON employees(department_id) 
WHERE status = 'active';
```

### Common Table Expressions (CTEs)
```sql
-- Simple CTE
WITH high_earners AS (
    SELECT * FROM employees
    WHERE salary > 80000
)
SELECT department_id, COUNT(*) 
FROM high_earners 
GROUP BY department_id;

-- Recursive CTE (org hierarchy)
WITH RECURSIVE employee_hierarchy AS (
    SELECT employee_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT e.employee_id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM employee_hierarchy;
```

## 💡 Best Practices

1. **Indexing**: Index foreign keys and frequently queried columns
2. **Query Design**: Avoid SELECT *, use specific columns
3. **Joins**: Use appropriate join types
4. **Transactions**: Keep them short and focused
5. **Testing**: Test queries with production-like data volumes
6. **Documentation**: Document complex queries
7. **Monitoring**: Track slow queries

## 🔍 Query Optimization Tips

1. **Use EXPLAIN**: Analyze query execution plans
2. **Limit Result Sets**: Use WHERE clauses effectively
3. **Avoid Functions in WHERE**: Can prevent index usage
4. **Use Joins Instead of Subqueries**: Often faster
5. **Proper Data Types**: Use appropriate types for columns
6. **Batch Operations**: Bulk inserts instead of row-by-row
7. **Connection Pooling**: Reuse database connections

## 📚 Additional Resources

- [Use The Index, Luke](https://use-the-index-luke.com/)
- [PostgreSQL Performance Tuning](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [SQL Server Execution Plans](https://www.red-gate.com/simple-talk/databases/sql-server/performance-sql-server/execution-plans/)

## Real-World Scenarios

### Scenario 1: Slow Dashboard Query
- Analyze execution plan
- Add appropriate indexes
- Rewrite query to reduce joins
- Consider materialized views

### Scenario 2: Concurrent Updates
- Implement proper transactions
- Handle deadlocks
- Use appropriate isolation levels
- Design for concurrency

### Scenario 3: Large Data Imports
- Use bulk insert methods
- Disable indexes during import
- Rebuild indexes after import
- Use transactions appropriately
