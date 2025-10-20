# Lesson 6: Advanced SQL - Subqueries, CTEs, Window Functions & Database Fundamentals
**Module 1: SQL Fundamentals - Lesson 6 of 6**

## 🎯 Learning Objectives

By the end of this lesson, you will:
- Write subqueries in SELECT, WHERE, and FROM clauses
- Use correlated subqueries for row-by-row analysis
- Master Common Table Expressions (CTEs) with WITH clause
- Apply window functions for advanced analytics
- Understand ACID properties and database transactions
- Implement transactions with BEGIN, COMMIT, ROLLBACK
- Grasp data architecture fundamentals
- Apply performance optimization techniques

**Estimated Time**: 3.5 hours

---

## 📚 Table of Contents

1. [Subqueries](#1-subqueries)
2. [Common Table Expressions (CTEs)](#2-common-table-expressions-ctes)
3. [Window Functions](#3-window-functions)
4. [ACID Properties](#4-acid-properties)
5. [Transactions](#5-transactions)
6. [Database Architecture Fundamentals](#6-database-architecture-fundamentals)
7. [Performance & Optimization](#7-performance--optimization)
8. [Practice Exercises](#8-practice-exercises)

---

## 1. Subqueries

### What is a Subquery?

A **subquery** (or inner query) is a query nested inside another query. It runs first and provides results to the outer query.

### Types of Subqueries

| Type | Location | Returns | Example Use |
|------|----------|---------|-------------|
| **Scalar** | SELECT, WHERE | Single value | Find average price |
| **Row** | WHERE | Single row | Match multiple columns |
| **Column** | WHERE with IN | Single column | List of IDs |
| **Table** | FROM | Result set | Temporary table |

---

### 1.1 Scalar Subqueries (Single Value)

Returns **one value** (one row, one column).

#### Example 1: Compare to Average

```sql
-- Find campsites more expensive than average
SELECT 
    campsite_name,
    price_per_night,
    (SELECT ROUND(AVG(price_per_night), 2) FROM campsites) AS avg_price
FROM campsites
WHERE price_per_night > (SELECT AVG(price_per_night) FROM campsites)
ORDER BY price_per_night DESC;
```

**Result:**
```
campsite_name          | price_per_night | avg_price
-----------------------|-----------------|----------
Camping Vale do Pati   | 120.00          | 78.50
Camping Topo do Mundo  | 80.00           | 78.50
```

#### Example 2: Percentage of Average

```sql
-- Show each campsite price as percentage of average
SELECT 
    campsite_name,
    price_per_night,
    ROUND(
        100.0 * price_per_night / (SELECT AVG(price_per_night) FROM campsites),
        1
    ) AS percent_of_avg
FROM campsites
ORDER BY percent_of_avg DESC;
```

---

### 1.2 Column Subqueries (IN, NOT IN, ANY, ALL)

Returns **one column** (multiple rows).

#### Example 1: IN Subquery

```sql
-- Find campsites in locations with climbing routes
SELECT campsite_name, location_id
FROM campsites
WHERE location_id IN (
    SELECT DISTINCT location_id 
    FROM climbing_routes
)
ORDER BY campsite_name;
```

#### Example 2: NOT IN - Find Exclusions

```sql
-- Find locations WITHOUT any trails
SELECT location_name, state
FROM locations
WHERE location_id NOT IN (
    SELECT DISTINCT location_id 
    FROM trails
)
ORDER BY state, location_name;
```

#### Example 3: ANY/ALL Operators

```sql
-- Find campsites cheaper than ANY campsite in Rio (RJ)
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.state
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE c.price_per_night < ANY (
    SELECT c2.price_per_night
    FROM campsites c2
    JOIN locations l2 ON c2.location_id = l2.location_id
    WHERE l2.state = 'RJ'
)
ORDER BY c.price_per_night;
```

**ANY** = at least one match  
**ALL** = must match every value

```sql
-- Campsites cheaper than ALL campsites in Rio
WHERE price_per_night < ALL (subquery)
```

---

### 1.3 Table Subqueries (FROM clause)

Returns a **result set** used as a temporary table.

#### Example 1: Derived Table

```sql
-- Average prices by state, then filter
SELECT 
    state,
    avg_price,
    location_count
FROM (
    SELECT 
        l.state,
        ROUND(AVG(c.price_per_night), 2) AS avg_price,
        COUNT(DISTINCT l.location_id) AS location_count
    FROM locations l
    JOIN campsites c ON l.location_id = c.location_id
    GROUP BY l.state
) AS state_stats
WHERE avg_price > 70
ORDER BY avg_price DESC;
```

#### Example 2: Complex Filtering

```sql
-- Find top 3 most expensive campsites per state
SELECT *
FROM (
    SELECT 
        l.state,
        c.campsite_name,
        c.price_per_night,
        ROW_NUMBER() OVER (PARTITION BY l.state ORDER BY c.price_per_night DESC) AS price_rank
    FROM campsites c
    JOIN locations l ON c.location_id = l.location_id
) AS ranked_campsites
WHERE price_rank <= 3
ORDER BY state, price_rank;
```

---

### 1.4 Correlated Subqueries

A **correlated subquery** references columns from the outer query. It runs **once per outer row**.

#### Example 1: Row-by-Row Comparison

```sql
-- Find campsites more expensive than location average
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    (
        SELECT ROUND(AVG(c2.price_per_night), 2)
        FROM campsites c2
        WHERE c2.location_id = c.location_id  -- References outer query!
    ) AS location_avg_price
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE c.price_per_night > (
    SELECT AVG(c2.price_per_night)
    FROM campsites c2
    WHERE c2.location_id = c.location_id
)
ORDER BY l.location_name, c.price_per_night DESC;
```

#### Example 2: EXISTS - Check for Existence

```sql
-- Find locations that HAVE at least one trail
SELECT location_name, state
FROM locations l
WHERE EXISTS (
    SELECT 1 
    FROM trails t 
    WHERE t.location_id = l.location_id
)
ORDER BY location_name;
```

**EXISTS** is faster than `IN` for large datasets because it stops at first match.

#### Example 3: NOT EXISTS - Opposite Check

```sql
-- Find gear categories with NO products
SELECT category_name
FROM gear_categories gc
WHERE NOT EXISTS (
    SELECT 1
    FROM outdoor_gear og
    WHERE og.category_id = gc.category_id
)
ORDER BY category_name;
```

---

## 2. Common Table Expressions (CTEs)

### What are CTEs?

**CTEs** (WITH clause) create **named temporary result sets** that exist only during query execution. They make queries more readable and maintainable.

### Basic CTE Syntax

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;
```

---

### 2.1 Simple CTE

#### Example 1: Readable Alternative to Subquery

```sql
-- Instead of nested subquery, use CTE
WITH expensive_campsites AS (
    SELECT 
        campsite_id,
        campsite_name,
        price_per_night,
        location_id
    FROM campsites
    WHERE price_per_night > 80
)
SELECT 
    ec.campsite_name,
    ec.price_per_night,
    l.location_name,
    l.state
FROM expensive_campsites ec
JOIN locations l ON ec.location_id = l.location_id
ORDER BY ec.price_per_night DESC;
```

#### Example 2: Calculate Once, Use Multiple Times

```sql
WITH price_stats AS (
    SELECT 
        AVG(price_per_night) AS avg_price,
        MIN(price_per_night) AS min_price,
        MAX(price_per_night) AS max_price
    FROM campsites
)
SELECT 
    c.campsite_name,
    c.price_per_night,
    ps.avg_price,
    CASE
        WHEN c.price_per_night < ps.avg_price THEN 'Below Average'
        WHEN c.price_per_night = ps.avg_price THEN 'Average'
        ELSE 'Above Average'
    END AS price_category
FROM campsites c
CROSS JOIN price_stats ps
ORDER BY c.price_per_night;
```

---

### 2.2 Multiple CTEs

You can define **multiple CTEs** separated by commas.

```sql
WITH 
-- CTE 1: Location statistics
location_stats AS (
    SELECT 
        location_id,
        location_name,
        state,
        difficulty_level
    FROM locations
    WHERE difficulty_level IN ('easy', 'moderate')
),
-- CTE 2: Campsite averages
campsite_avg AS (
    SELECT 
        location_id,
        COUNT(*) AS campsite_count,
        ROUND(AVG(price_per_night), 2) AS avg_price
    FROM campsites
    GROUP BY location_id
),
-- CTE 3: Trail counts
trail_count AS (
    SELECT 
        location_id,
        COUNT(*) AS trail_count
    FROM trails
    GROUP BY location_id
)
-- Main query using all 3 CTEs
SELECT 
    ls.location_name,
    ls.state,
    ls.difficulty_level,
    COALESCE(ca.campsite_count, 0) AS campsites,
    COALESCE(ca.avg_price, 0) AS avg_price,
    COALESCE(tc.trail_count, 0) AS trails
FROM location_stats ls
LEFT JOIN campsite_avg ca ON ls.location_id = ca.location_id
LEFT JOIN trail_count tc ON ls.location_id = tc.location_id
ORDER BY campsites DESC, trails DESC;
```

---

### 2.3 Recursive CTEs

**Recursive CTEs** reference themselves to traverse hierarchical data (trees, graphs).

#### Syntax

```sql
WITH RECURSIVE cte_name AS (
    -- Anchor member (base case)
    SELECT ...
    
    UNION ALL
    
    -- Recursive member (references cte_name)
    SELECT ...
    FROM cte_name
    WHERE ...  -- Termination condition
)
SELECT * FROM cte_name;
```

#### Example 1: Gear Category Hierarchy

```sql
-- Show complete category hierarchy (parent -> child -> grandchild)
WITH RECURSIVE category_tree AS (
    -- Base case: top-level categories (no parent)
    SELECT 
        category_id,
        category_name,
        parent_category_id,
        1 AS level,
        category_name AS path
    FROM gear_categories
    WHERE parent_category_id IS NULL
    
    UNION ALL
    
    -- Recursive case: child categories
    SELECT 
        gc.category_id,
        gc.category_name,
        gc.parent_category_id,
        ct.level + 1,
        ct.path || ' > ' || gc.category_name
    FROM gear_categories gc
    JOIN category_tree ct ON gc.parent_category_id = ct.category_id
)
SELECT 
    REPEAT('  ', level - 1) || category_name AS hierarchy,
    level,
    path
FROM category_tree
ORDER BY path;
```

**Result:**
```
hierarchy                  | level | path
---------------------------|-------|---------------------------
Camping Gear               | 1     | Camping Gear
  Tents                    | 2     | Camping Gear > Tents
    2-Person Tents         | 3     | Camping Gear > Tents > 2-Person Tents
    4-Person Tents         | 3     | Camping Gear > Tents > 4-Person Tents
  Sleeping Bags            | 2     | Camping Gear > Sleeping Bags
```

#### Example 2: Number Series

```sql
-- Generate numbers 1 to 12 (months)
WITH RECURSIVE months AS (
    SELECT 1 AS month_num
    UNION ALL
    SELECT month_num + 1
    FROM months
    WHERE month_num < 12
)
SELECT 
    month_num,
    CASE month_num
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name
FROM months;
```

---

## 3. Window Functions

### What are Window Functions?

Window functions perform calculations **across rows** related to the current row, without collapsing results like GROUP BY.

### Key Concepts

- **Window**: Set of rows related to current row
- **Partition**: Divide data into groups (like GROUP BY, but keeps all rows)
- **Order**: Define row order within partition
- **Frame**: Subset of partition (ROWS BETWEEN...)

### Basic Syntax

```sql
function_name() OVER (
    PARTITION BY column1, column2
    ORDER BY column3
    ROWS BETWEEN ... AND ...
)
```

---

### 3.1 Ranking Functions

#### ROW_NUMBER() - Sequential Number

```sql
-- Rank campsites by price within each state
SELECT 
    l.state,
    c.campsite_name,
    c.price_per_night,
    ROW_NUMBER() OVER (PARTITION BY l.state ORDER BY c.price_per_night DESC) AS price_rank
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.state, price_rank;
```

**Result:**
```
state | campsite_name          | price_per_night | price_rank
------|------------------------|-----------------|------------
BA    | Camping Vale do Pati   | 120.00          | 1
BA    | Camping Pai Inácio     | 100.00          | 2
BA    | Camping Marimbus       | 40.00           | 3
RJ    | Camping Topo do Mundo  | 80.00           | 1
RJ    | Camping Três Picos     | 60.00           | 2
```

#### RANK() - With Gaps for Ties

```sql
-- Rank trails by distance (ties get same rank, gaps after ties)
SELECT 
    trail_name,
    distance_km,
    RANK() OVER (ORDER BY distance_km DESC) AS distance_rank
FROM trails
ORDER BY distance_rank;
```

**If two trails tie for rank 2, next rank is 4 (gap).**

#### DENSE_RANK() - No Gaps for Ties

```sql
-- Rank trails by distance (ties get same rank, NO gaps)
SELECT 
    trail_name,
    distance_km,
    DENSE_RANK() OVER (ORDER BY distance_km DESC) AS distance_rank
FROM trails
ORDER BY distance_rank;
```

**If two trails tie for rank 2, next rank is 3 (no gap).**

#### NTILE() - Divide into Buckets

```sql
-- Divide campsites into 4 price quartiles
SELECT 
    campsite_name,
    price_per_night,
    NTILE(4) OVER (ORDER BY price_per_night) AS price_quartile
FROM campsites
ORDER BY price_per_night;
```

**Result:** Quartile 1 = cheapest 25%, Quartile 4 = most expensive 25%

---

### 3.2 Aggregate Window Functions

#### Running Total (Cumulative Sum)

```sql
-- Running total of trail distances
SELECT 
    trail_name,
    distance_km,
    SUM(distance_km) OVER (ORDER BY trail_id) AS cumulative_distance
FROM trails
ORDER BY trail_id;
```

#### Moving Average

```sql
-- 3-month moving average of temperature
SELECT 
    location_id,
    recorded_date,
    avg_temp_celsius,
    ROUND(
        AVG(avg_temp_celsius) OVER (
            PARTITION BY location_id 
            ORDER BY recorded_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        1
    ) AS moving_avg_3months
FROM weather_data
ORDER BY location_id, recorded_date;
```

#### Compare to Group Average

```sql
-- Show each campsite price vs. location average
SELECT 
    l.location_name,
    c.campsite_name,
    c.price_per_night,
    ROUND(AVG(c.price_per_night) OVER (PARTITION BY l.location_id), 2) AS location_avg,
    ROUND(c.price_per_night - AVG(c.price_per_night) OVER (PARTITION BY l.location_id), 2) AS diff_from_avg
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.location_name, c.price_per_night DESC;
```

---

### 3.3 Value Functions

#### LAG() - Previous Row Value

```sql
-- Compare each month's temperature to previous month
SELECT 
    location_id,
    recorded_date,
    avg_temp_celsius,
    LAG(avg_temp_celsius) OVER (PARTITION BY location_id ORDER BY recorded_date) AS prev_month_temp,
    avg_temp_celsius - LAG(avg_temp_celsius) OVER (PARTITION BY location_id ORDER BY recorded_date) AS temp_change
FROM weather_data
ORDER BY location_id, recorded_date;
```

#### LEAD() - Next Row Value

```sql
-- Compare current price to next campsite in location
SELECT 
    l.location_name,
    c.campsite_name,
    c.price_per_night,
    LEAD(c.campsite_name) OVER (PARTITION BY l.location_id ORDER BY c.price_per_night) AS next_campsite,
    LEAD(c.price_per_night) OVER (PARTITION BY l.location_id ORDER BY c.price_per_night) AS next_price
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.location_name, c.price_per_night;
```

#### FIRST_VALUE() / LAST_VALUE()

```sql
-- Show cheapest and most expensive in each location
SELECT 
    l.location_name,
    c.campsite_name,
    c.price_per_night,
    FIRST_VALUE(c.campsite_name) OVER (
        PARTITION BY l.location_id 
        ORDER BY c.price_per_night
    ) AS cheapest_campsite,
    FIRST_VALUE(c.price_per_night) OVER (
        PARTITION BY l.location_id 
        ORDER BY c.price_per_night
    ) AS cheapest_price,
    LAST_VALUE(c.campsite_name) OVER (
        PARTITION BY l.location_id 
        ORDER BY c.price_per_night
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS most_expensive_campsite
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.location_name, c.price_per_night;
```

---

## 4. ACID Properties

### What is ACID?

**ACID** ensures database **reliability** and **data integrity** through transactions.

| Property | Meaning | Example |
|----------|---------|---------|
| **A**tomicity | All or nothing | Transfer money: debit AND credit, or neither |
| **C**onsistency | Valid state always | Balance never negative |
| **I**solation | Transactions don't interfere | Two users booking same campsite |
| **D**urability | Changes persist | After commit, survives crash |

---

### 4.1 Atomicity

**All operations succeed, or all fail.** No partial updates.

#### Example: Book Campsite (Atomic)

```sql
BEGIN;

-- Reduce campsite capacity
UPDATE campsites 
SET available_spots = available_spots - 1
WHERE campsite_id = 5 AND available_spots > 0;

-- Create booking record
INSERT INTO bookings (user_id, campsite_id, booking_date, nights)
VALUES (123, 5, '2025-07-15', 3);

-- Either BOTH succeed, or BOTH fail
COMMIT;  -- Success: both changes saved
-- OR
ROLLBACK;  -- Failure: both changes undone
```

**Without atomicity:** Capacity decreases but booking isn't created = data inconsistency!

---

### 4.2 Consistency

**Database stays in valid state** (all constraints satisfied).

#### Example: Price Must Be Positive

```sql
-- Constraint prevents invalid data
ALTER TABLE campsites 
ADD CONSTRAINT check_price_positive 
CHECK (price_per_night > 0);

-- This INSERT will FAIL (maintains consistency)
INSERT INTO campsites (campsite_name, price_per_night)
VALUES ('Bad Campsite', -50);  -- ERROR: violates check_price_positive

-- Database remains in valid state
```

**Consistency ensures:**
- Foreign keys point to existing records
- NOT NULL columns have values
- CHECK constraints are satisfied
- UNIQUE constraints aren't violated

---

### 4.3 Isolation

**Concurrent transactions don't interfere** with each other.

#### Isolation Levels (PostgreSQL)

| Level | Dirty Read | Non-Repeatable Read | Phantom Read | Performance |
|-------|------------|---------------------|--------------|-------------|
| READ UNCOMMITTED | ✅ Possible | ✅ Possible | ✅ Possible | Fastest |
| READ COMMITTED (default) | ❌ Prevented | ✅ Possible | ✅ Possible | Good |
| REPEATABLE READ | ❌ Prevented | ❌ Prevented | ✅ Possible | Slower |
| SERIALIZABLE | ❌ Prevented | ❌ Prevented | ❌ Prevented | Slowest |

#### Example: Two Users Booking Same Spot

**Transaction 1:**
```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT available_spots FROM campsites WHERE campsite_id = 5;  -- Returns 1
-- User takes time to confirm...
UPDATE campsites SET available_spots = 0 WHERE campsite_id = 5;
COMMIT;
```

**Transaction 2 (concurrent):**
```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT available_spots FROM campsites WHERE campsite_id = 5;  -- Returns 1
-- User takes time to confirm...
UPDATE campsites SET available_spots = 0 WHERE campsite_id = 5;  -- BLOCKS or FAILS
COMMIT;
```

**With proper isolation:** Second transaction waits or fails, preventing double-booking.

---

### 4.4 Durability

**Committed changes survive crashes.** Data persists even if server fails immediately after commit.

#### How PostgreSQL Ensures Durability

1. **Write-Ahead Logging (WAL)**: Changes written to log before data files
2. **Checkpoints**: Periodic flush of dirty pages to disk
3. **Crash Recovery**: Replay WAL on restart

```sql
BEGIN;
UPDATE campsites SET price_per_night = 95 WHERE campsite_id = 10;
COMMIT;  -- Written to WAL and disk

-- Server crashes here...
-- After restart: change still exists (durable)
```

---

## 5. Transactions

### What is a Transaction?

A **transaction** is a sequence of SQL statements executed as a **single unit of work**.

### Transaction Commands

| Command | Purpose |
|---------|---------|
| `BEGIN` or `START TRANSACTION` | Start transaction |
| `COMMIT` | Save all changes |
| `ROLLBACK` | Undo all changes |
| `SAVEPOINT name` | Create rollback point |
| `ROLLBACK TO name` | Undo to savepoint |

---

### 5.1 Basic Transaction

```sql
BEGIN;

-- Multiple operations
INSERT INTO locations (location_name, state, location_type)
VALUES ('New Mountain', 'MG', 'mountain_peak');

INSERT INTO campsites (location_id, campsite_name, price_per_night)
VALUES (currval('locations_location_id_seq'), 'Base Camp', 60);

-- Check results before committing
SELECT * FROM locations WHERE location_name = 'New Mountain';

-- Decide: save or discard
COMMIT;     -- Save changes
-- OR
ROLLBACK;   -- Discard changes
```

---

### 5.2 Savepoints (Partial Rollback)

```sql
BEGIN;

-- Operation 1
INSERT INTO locations (location_name, state, location_type)
VALUES ('Location A', 'SP', 'national_park');

SAVEPOINT after_location;

-- Operation 2
INSERT INTO campsites (location_id, campsite_name, price_per_night)
VALUES (1, 'Campsite X', 70);

SAVEPOINT after_campsite;

-- Operation 3 (oops, mistake!)
INSERT INTO trails (location_id, trail_name, distance_km)
VALUES (999, 'Invalid Trail', 10);  -- location_id 999 doesn't exist

-- Roll back only operation 3
ROLLBACK TO after_campsite;

-- Location A and Campsite X still pending
-- Can continue with more operations or commit
COMMIT;  -- Saves Location A and Campsite X
```

---

### 5.3 Transaction Best Practices

#### ✅ DO:
- Keep transactions **short**
- Handle errors with `BEGIN/EXCEPTION/END` (in stored procedures)
- Use appropriate isolation level
- Commit or rollback explicitly

#### ❌ DON'T:
- Leave transactions open for user input
- Mix DDL and DML in same transaction (some databases)
- Use long-running transactions (locks resources)

---

## 6. Database Architecture Fundamentals

### 6.1 Client-Server Architecture

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│   Client     │◄───────►│  Database Server │◄───────►│  Storage     │
│  Application │  Network│   (PostgreSQL)   │   I/O   │    (Disk)    │
└──────────────┘         └──────────────────┘         └──────────────┘
     │                            │
     │ SQL Queries                │ Process Management
     │ Results                    │ Query Optimization
     │                            │ Transaction Control
     └────────────────────────────┘ ACID Guarantees
```

**Components:**
- **Client**: Application (Python, psql, pgAdmin)
- **Server**: PostgreSQL process
- **Storage**: Data files, indexes, WAL

---

### 6.2 PostgreSQL Internal Architecture

```
PostgreSQL Server
├── Postmaster (Main Process)
│   ├── Backend Processes (one per connection)
│   ├── Background Processes
│   │   ├── Autovacuum (cleanup)
│   │   ├── Checkpointer (write dirty pages)
│   │   ├── WAL Writer (write-ahead log)
│   │   └── Stats Collector
│   └── Shared Memory
│       ├── Shared Buffers (data cache)
│       ├── WAL Buffers
│       └── Lock Tables
└── Storage
    ├── Data Files (tables, indexes)
    ├── WAL Files (transaction log)
    └── Configuration Files
```

---

### 6.3 Query Execution Process

```
1. Parser
   ↓ (Parse SQL, check syntax)
2. Analyzer/Rewriter
   ↓ (Validate tables/columns, apply rules)
3. Planner/Optimizer
   ↓ (Choose best execution plan)
4. Executor
   ↓ (Execute plan, fetch data)
5. Results
   ↓ (Return to client)
```

#### View Query Plan with EXPLAIN

```sql
EXPLAIN ANALYZE
SELECT c.campsite_name, l.location_name
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE l.state = 'BA'
ORDER BY c.price_per_night DESC;
```

**Output shows:**
- Execution plan (sequential scan vs. index scan)
- Estimated cost
- Actual runtime
- Rows processed

---

### 6.4 Indexes

#### What are Indexes?

Data structures that **speed up queries** by avoiding full table scans.

#### B-Tree Index (Default)

```sql
-- Create index on foreign key
CREATE INDEX idx_campsites_location_id ON campsites(location_id);

-- Query now uses index (faster)
SELECT * FROM campsites WHERE location_id = 5;
```

#### Composite Index

```sql
-- Index on multiple columns
CREATE INDEX idx_location_state_type ON locations(state, location_type);

-- Speeds up queries filtering both columns
SELECT * FROM locations WHERE state = 'RJ' AND location_type = 'mountain_peak';
```

#### When to Use Indexes

✅ **Index these:**
- Primary keys (automatic)
- Foreign keys
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY

❌ **Don't index these:**
- Small tables (< 1000 rows)
- Columns with low cardinality (few unique values)
- Columns frequently updated (index maintenance overhead)

---

### 6.5 Normalization vs. Denormalization

#### Normalization (Avoid Duplication)

**Benefits:**
- Data integrity
- Easier updates
- Less storage

**Use for:** Transactional systems (OLTP)

#### Denormalization (Duplicate for Speed)

**Benefits:**
- Faster queries (fewer joins)
- Simpler queries

**Use for:** Analytics systems (OLAP)

**Example:**
```sql
-- Denormalized table for reporting (fast queries)
CREATE TABLE campsite_summary AS
SELECT 
    c.campsite_id,
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    l.state,
    l.difficulty_level
FROM campsites c
JOIN locations l ON c.location_id = l.location_id;

-- No JOIN needed in queries (faster)
SELECT * FROM campsite_summary WHERE state = 'BA';
```

---

## 7. Performance & Optimization

### 7.1 Query Optimization Tips

#### 1. Select Only Needed Columns

```sql
-- ❌ Slow
SELECT * FROM campsites;

-- ✅ Fast
SELECT campsite_name, price_per_night FROM campsites;
```

#### 2. Use LIMIT for Large Results

```sql
-- Prevent returning millions of rows
SELECT * FROM weather_data 
WHERE avg_temp_celsius > 25
LIMIT 100;
```

#### 3. Filter Early with WHERE

```sql
-- ❌ Filters AFTER join (slow)
SELECT c.*, l.*
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE l.state = 'BA';

-- ✅ Filters BEFORE join (faster if index exists)
SELECT c.*, l.*
FROM campsites c
JOIN (SELECT * FROM locations WHERE state = 'BA') l 
ON c.location_id = l.location_id;
```

#### 4. Use EXISTS Instead of IN for Large Subqueries

```sql
-- ❌ Slower for large subqueries
SELECT * FROM locations 
WHERE location_id IN (SELECT location_id FROM trails);

-- ✅ Faster (stops at first match)
SELECT * FROM locations l
WHERE EXISTS (SELECT 1 FROM trails t WHERE t.location_id = l.location_id);
```

#### 5. Analyze Statistics

```sql
-- Update table statistics for better query plans
ANALYZE campsites;
ANALYZE locations;

-- Or all tables
ANALYZE;
```

---

### 7.2 Vacuum and Maintenance

```sql
-- Remove dead rows (PostgreSQL specific)
VACUUM ANALYZE campsites;

-- Full vacuum (locks table, reclaims space)
VACUUM FULL campsites;

-- Autovacuum (runs automatically, usually sufficient)
-- Check status
SELECT schemaname, tablename, last_vacuum, last_autovacuum 
FROM pg_stat_user_tables;
```

---

## 8. Practice Exercises

### Exercise 1: Scalar Subquery ⭐

**Question:** Find all trails longer than the average trail distance. Show trail name and distance.

<details>
<summary>✅ Solution</summary>

```sql
SELECT trail_name, distance_km
FROM trails
WHERE distance_km > (SELECT AVG(distance_km) FROM trails)
ORDER BY distance_km DESC;
```
</details>

---

### Exercise 2: CTE ⭐⭐

**Question:** Use a CTE to find campsites in the top 3 most expensive states (by average campsite price).

<details>
<summary>💡 Hint</summary>

First CTE: average price by state. Second CTE or main query: top 3 states.
</details>

<details>
<summary>✅ Solution</summary>

```sql
WITH state_avg_prices AS (
    SELECT 
        l.state,
        AVG(c.price_per_night) AS avg_price
    FROM locations l
    JOIN campsites c ON l.location_id = c.location_id
    GROUP BY l.state
),
top_states AS (
    SELECT state
    FROM state_avg_prices
    ORDER BY avg_price DESC
    LIMIT 3
)
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.state
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE l.state IN (SELECT state FROM top_states)
ORDER BY l.state, c.price_per_night DESC;
```
</details>

---

### Exercise 3: Window Function - Ranking ⭐⭐

**Question:** Rank campsites by price within each location. Show location name, campsite name, price, and rank.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    c.campsite_name,
    c.price_per_night,
    RANK() OVER (PARTITION BY l.location_id ORDER BY c.price_per_night DESC) AS price_rank
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.location_name, price_rank;
```
</details>

---

### Exercise 4: Window Function - Running Total ⭐⭐⭐

**Question:** For each location, show cumulative count of campsites ordered by price (cheapest first). Include location name, campsite name, price, and cumulative count.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    c.campsite_name,
    c.price_per_night,
    ROW_NUMBER() OVER (PARTITION BY l.location_id ORDER BY c.price_per_night) AS cumulative_count
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
ORDER BY l.location_name, cumulative_count;
```
</details>

---

### Exercise 5: Recursive CTE ⭐⭐⭐⭐

**Question:** Generate a list of all dates in July 2025. Use recursive CTE.

<details>
<summary>💡 Hint</summary>

Base case: '2025-07-01'. Recursive case: add 1 day until '2025-07-31'.
</details>

<details>
<summary>✅ Solution</summary>

```sql
WITH RECURSIVE july_dates AS (
    -- Base case: first day of July
    SELECT DATE '2025-07-01' AS date
    
    UNION ALL
    
    -- Recursive case: add one day
    SELECT date + INTERVAL '1 day'
    FROM july_dates
    WHERE date < '2025-07-31'
)
SELECT 
    date,
    TO_CHAR(date, 'Day') AS day_name,
    EXTRACT(DAY FROM date) AS day_number
FROM july_dates
ORDER BY date;
```
</details>

---

### Exercise 6: Transaction ⭐⭐⭐

**Question:** Write a transaction that:
1. Adds a new location "Serra da Canastra" in MG
2. Adds a campsite "Camping Canastra" at that location for R$55/night
3. Uses a savepoint after the location insert
4. If campsite insert fails, rolls back only the campsite

<details>
<summary>✅ Solution</summary>

```sql
BEGIN;

-- Insert location
INSERT INTO locations (location_name, state, location_type, difficulty_level)
VALUES ('Serra da Canastra', 'MG', 'national_park', 'moderate');

SAVEPOINT after_location;

-- Insert campsite (using currval to get last location_id)
INSERT INTO campsites (location_id, campsite_name, price_per_night, has_toilet, has_shower)
VALUES (
    currval('locations_location_id_seq'),
    'Camping Canastra',
    55.00,
    TRUE,
    FALSE
);

-- If there was an error in campsite insert:
-- ROLLBACK TO after_location;
-- Then can retry or add different campsite

COMMIT;
```
</details>

---

### Exercise 7: Complex Analytics ⭐⭐⭐⭐

**Question:** Create a report showing:
- Location name and state
- Total number of campsites
- Average campsite price
- Cheapest and most expensive campsite names
- Price difference between cheapest and most expensive
- Rank of location by total campsites (most campsites = rank 1)

Use CTEs and window functions. Only include locations with at least 2 campsites.

<details>
<summary>✅ Solution</summary>

```sql
WITH location_campsite_stats AS (
    SELECT 
        l.location_id,
        l.location_name,
        l.state,
        COUNT(c.campsite_id) AS campsite_count,
        ROUND(AVG(c.price_per_night), 2) AS avg_price,
        MIN(c.price_per_night) AS min_price,
        MAX(c.price_per_night) AS max_price
    FROM locations l
    JOIN campsites c ON l.location_id = c.location_id
    GROUP BY l.location_id, l.location_name, l.state
    HAVING COUNT(c.campsite_id) >= 2
),
cheapest_campsites AS (
    SELECT DISTINCT ON (c.location_id)
        c.location_id,
        c.campsite_name AS cheapest_name
    FROM campsites c
    ORDER BY c.location_id, c.price_per_night ASC
),
expensive_campsites AS (
    SELECT DISTINCT ON (c.location_id)
        c.location_id,
        c.campsite_name AS most_expensive_name
    FROM campsites c
    ORDER BY c.location_id, c.price_per_night DESC
)
SELECT 
    lcs.location_name,
    lcs.state,
    lcs.campsite_count,
    lcs.avg_price,
    cc.cheapest_name,
    lcs.min_price,
    ec.most_expensive_name,
    lcs.max_price,
    lcs.max_price - lcs.min_price AS price_range,
    RANK() OVER (ORDER BY lcs.campsite_count DESC) AS campsite_rank
FROM location_campsite_stats lcs
JOIN cheapest_campsites cc ON lcs.location_id = cc.location_id
JOIN expensive_campsites ec ON lcs.location_id = ec.location_id
ORDER BY campsite_rank, lcs.location_name;
```
</details>

---

## 🎯 Key Takeaways

✅ **Subqueries** - Query within a query (scalar, column, table, correlated)  
✅ **CTEs** - WITH clause for readable, reusable query parts  
✅ **Window Functions** - Analytics without collapsing rows  
✅ **ACID** - Atomicity, Consistency, Isolation, Durability  
✅ **Transactions** - BEGIN, COMMIT, ROLLBACK, SAVEPOINT  
✅ **Architecture** - Client-server, query execution, indexes  
✅ **Optimization** - Indexes, EXPLAIN, statistics, vacuum  

---

## 🎓 Module 1 Complete!

**Congratulations!** You've completed SQL Fundamentals! 

You now know:
- Database design (normalization, ERD)
- SQL basics (SELECT, WHERE, filtering)
- Aggregations (COUNT, SUM, AVG, GROUP BY)
- Joins (INNER, LEFT, RIGHT, FULL, CROSS, SELF)
- Advanced queries (subqueries, CTEs, window functions)
- Database fundamentals (ACID, transactions, architecture)
- Performance optimization

---

## 🚀 Next Module

**Module 2: Python Essentials for Data Engineering**
- Python basics review
- Virtual environments
- Database connections with psycopg2
- Data manipulation with pandas
- File I/O and error handling
- Object-oriented programming
- Testing with pytest

---

## 📖 Additional Resources

- [PostgreSQL Window Functions](https://www.postgresql.org/docs/current/tutorial-window.html)
- [CTEs Explained](https://www.postgresql.org/docs/current/queries-with.html)
- [ACID Properties](https://en.wikipedia.org/wiki/ACID)
- [Database Internals](https://www.interdb.jp/pg/)
- [Query Optimization](https://www.postgresql.org/docs/current/performance-tips.html)

---

**Estimated Completion Time**: 3.5 hours  
**Difficulty**: ⭐⭐⭐⭐ Advanced  
**Prerequisites**: Lessons 1-5 completed

*Congratulations on mastering SQL! 🎉*
