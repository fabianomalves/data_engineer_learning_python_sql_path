# Lesson 5: Joins - Combining Data from Multiple Tables
**Module 1: SQL Fundamentals - Lesson 5 of 6**

## 🎯 Learning Objectives

By the end of this lesson, you will:
- Understand relational database relationships
- Master INNER JOIN for matching records
- Use LEFT/RIGHT JOIN for optional matches
- Apply FULL OUTER JOIN for all records
- Implement CROSS JOIN for combinations
- Use SELF JOIN for hierarchical data
- Combine multiple tables in complex queries
- Understand join performance implications

**Estimated Time**: 2.5 hours

---

## 📚 Table of Contents

1. [Introduction to Joins](#1-introduction-to-joins)
2. [INNER JOIN - Matching Records](#2-inner-join---matching-records)
3. [LEFT JOIN - Keep Left Table Records](#3-left-join---keep-left-table-records)
4. [RIGHT JOIN - Keep Right Table Records](#4-right-join---keep-right-table-records)
5. [FULL OUTER JOIN - Keep All Records](#5-full-outer-join---keep-all-records)
6. [CROSS JOIN - Cartesian Product](#6-cross-join---cartesian-product)
7. [SELF JOIN - Join Table to Itself](#7-self-join---join-table-to-itself)
8. [Multi-Table Joins](#8-multi-table-joins)
9. [Join Performance Tips](#9-join-performance-tips)
10. [Practice Exercises](#10-practice-exercises)

---

## 1. Introduction to Joins

### What are Joins?

Joins combine rows from **two or more tables** based on a **related column** (usually foreign keys).

### Why Use Joins?

In a normalized database, data is split across multiple tables to:
- Avoid duplication
- Maintain data integrity
- Make updates easier

**Example:** Instead of storing location name in every campsite record, we store `location_id` and join to the `locations` table.

### Types of Joins

| Join Type | Returns | Use Case |
|-----------|---------|----------|
| `INNER JOIN` | Only matching records | "Show campsites WITH their locations" |
| `LEFT JOIN` | All left + matching right | "Show ALL locations, even without campsites" |
| `RIGHT JOIN` | All right + matching left | Rarely used (use LEFT instead) |
| `FULL OUTER JOIN` | All records from both | "Show everything, matched or not" |
| `CROSS JOIN` | All combinations | "Create all possible pairs" |
| `SELF JOIN` | Table joined to itself | "Find parent/child relationships" |

### Join Syntax

```sql
SELECT columns
FROM table1
JOIN_TYPE table2 ON table1.column = table2.column;
```

---

## 2. INNER JOIN - Matching Records

### What is INNER JOIN?

Returns **only rows where there's a match** in both tables.

### Basic Syntax

```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.foreign_key = table2.primary_key;

-- INNER is optional (default)
SELECT columns
FROM table1
JOIN table2 ON table1.foreign_key = table2.primary_key;
```

### Example 1: Campsites with Location Names

```sql
-- Show campsite names with their location names
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    l.state
FROM campsites c
INNER JOIN locations l ON c.location_id = l.location_id
ORDER BY l.state, c.campsite_name;
```

**Result:**
```
campsite_name              | price_per_night | location_name           | state
---------------------------|-----------------|-------------------------|------
Camping Marimbus           | 40.00           | Chapada Diamantina      | BA
Camping Vale do Pati       | 120.00          | Chapada Diamantina      | BA
Camping Guinle             | 50.00           | Serra dos Órgãos        | RJ
Camping Três Picos         | 60.00           | Serra dos Órgãos        | RJ
```

### Example 2: Trails with Location Details

```sql
SELECT 
    t.trail_name,
    t.difficulty_level,
    t.distance_km,
    l.location_name,
    l.state
FROM trails t
JOIN locations l ON t.location_id = l.location_id
WHERE t.difficulty_level IN ('easy', 'moderate')
ORDER BY t.distance_km;
```

### Example 3: Gear with Category Names

```sql
-- Show gear items with their category information
SELECT 
    og.gear_name,
    og.brand,
    og.price_brl,
    gc.category_name
FROM outdoor_gear og
JOIN gear_categories gc ON og.category_id = gc.category_id
WHERE og.price_brl < 300
ORDER BY gc.category_name, og.price_brl;
```

### Example 4: Multiple Conditions in JOIN

```sql
-- Join with additional conditions (less common)
SELECT 
    c.campsite_name,
    l.location_name
FROM campsites c
JOIN locations l ON c.location_id = l.location_id 
    AND l.difficulty_level = 'easy'
WHERE c.price_per_night < 100;
```

### 💡 Important: INNER JOIN Excludes Non-Matches

**If a campsite has no location (NULL location_id), it won't appear in INNER JOIN results.**

---

## 3. LEFT JOIN - Keep Left Table Records

### What is LEFT JOIN?

Returns **all rows from the left table**, plus matching rows from the right table. If no match, right table columns are NULL.

### Syntax

```sql
SELECT columns
FROM left_table
LEFT JOIN right_table ON left_table.column = right_table.column;

-- Same as LEFT OUTER JOIN
SELECT columns
FROM left_table
LEFT OUTER JOIN right_table ON left_table.column = right_table.column;
```

### Example 1: All Locations (Even Without Campsites)

```sql
-- Show all locations and count their campsites (including 0)
SELECT 
    l.location_name,
    l.state,
    COUNT(c.campsite_id) AS campsite_count
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
GROUP BY l.location_id, l.location_name, l.state
ORDER BY campsite_count DESC, l.location_name;
```

**Result:**
```
location_name                | state | campsite_count
-----------------------------|-------|---------------
Chapada Diamantina           | BA    | 5
Serra dos Órgãos             | RJ    | 3
Pico da Bandeira             | MG    | 2
Amazon Rainforest            | AM    | 0  ← Shows even without campsites
```

### Example 2: Find Locations Without Campsites

```sql
-- Which locations have NO campsites?
SELECT 
    l.location_name,
    l.state,
    l.location_type
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
WHERE c.campsite_id IS NULL;
```

**Result shows locations with no camping facilities.**

### Example 3: All Gear Categories (Even Empty Ones)

```sql
-- Show all categories and product counts
SELECT 
    gc.category_name,
    COUNT(og.gear_id) AS product_count,
    COALESCE(ROUND(AVG(og.price_brl), 2), 0) AS avg_price
FROM gear_categories gc
LEFT JOIN outdoor_gear og ON gc.category_id = og.category_id
GROUP BY gc.category_id, gc.category_name
ORDER BY product_count DESC;
```

**Note:** `COALESCE` replaces NULL with 0 for empty categories.

### Example 4: All Trails with Optional Weather Data

```sql
SELECT 
    t.trail_name,
    t.difficulty_level,
    l.location_name,
    w.avg_temp_celsius,
    w.rainfall_mm,
    w.recorded_date
FROM trails t
JOIN locations l ON t.location_id = l.location_id
LEFT JOIN weather_data w ON l.location_id = w.location_id
    AND EXTRACT(MONTH FROM w.recorded_date) IN (6, 7, 8)  -- Winter months
ORDER BY t.trail_name;
```

### 💡 LEFT JOIN Use Case

Use LEFT JOIN when you want **all records from one table**, even if there's no match in the other table.

---

## 4. RIGHT JOIN - Keep Right Table Records

### What is RIGHT JOIN?

Returns **all rows from the right table**, plus matching rows from the left table. If no match, left table columns are NULL.

### Syntax

```sql
SELECT columns
FROM left_table
RIGHT JOIN right_table ON left_table.column = right_table.column;
```

### Example: All Campsites (Even if Location Missing)

```sql
-- Show all campsites, even if location data is missing (rare scenario)
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    l.state
FROM locations l
RIGHT JOIN campsites c ON l.location_id = c.location_id
ORDER BY c.campsite_name;
```

### 💡 Pro Tip: Prefer LEFT JOIN

**Most developers prefer LEFT JOIN** because:
- Easier to reason about (main table is first)
- More readable
- `FROM table_a LEFT JOIN table_b` is clearer than `FROM table_b RIGHT JOIN table_a`

**This RIGHT JOIN:**
```sql
FROM locations l
RIGHT JOIN campsites c
```

**Is equivalent to this LEFT JOIN:**
```sql
FROM campsites c
LEFT JOIN locations l
```

**Use LEFT JOIN instead!**

---

## 5. FULL OUTER JOIN - Keep All Records

### What is FULL OUTER JOIN?

Returns **all rows from both tables**. If no match, fills missing columns with NULL.

### Syntax

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.column = table2.column;
```

### Example: All Locations and All Campsites

```sql
-- Show everything: matched and unmatched records
SELECT 
    l.location_name,
    l.state,
    c.campsite_name,
    c.price_per_night
FROM locations l
FULL OUTER JOIN campsites c ON l.location_id = c.location_id
ORDER BY l.location_name, c.campsite_name;
```

**Result includes:**
- Locations with campsites (matched)
- Locations without campsites (location data, campsite columns NULL)
- Campsites without locations (campsite data, location columns NULL) - rare

### Example: Find Orphaned Records

```sql
-- Find locations without campsites OR campsites without locations
SELECT 
    COALESCE(l.location_name, 'NO LOCATION') AS location_name,
    COALESCE(c.campsite_name, 'NO CAMPSITE') AS campsite_name
FROM locations l
FULL OUTER JOIN campsites c ON l.location_id = c.location_id
WHERE l.location_id IS NULL  -- Orphaned campsites
   OR c.campsite_id IS NULL;  -- Locations without campsites
```

### 💡 FULL OUTER JOIN Use Case

Rarely used. Helpful for:
- Data quality checks (finding orphaned records)
- Merging data from two sources
- Comparing two datasets

### ⚠️ SQLite Note

**SQLite does NOT support FULL OUTER JOIN.** Workaround:

```sql
-- Simulate FULL OUTER JOIN in SQLite
SELECT * FROM table1 LEFT JOIN table2 ON table1.id = table2.id
UNION
SELECT * FROM table1 RIGHT JOIN table2 ON table1.id = table2.id;
```

---

## 6. CROSS JOIN - Cartesian Product

### What is CROSS JOIN?

Returns **every possible combination** of rows from both tables (Cartesian product).

### Syntax

```sql
SELECT columns
FROM table1
CROSS JOIN table2;

-- Alternative (implicit syntax)
SELECT columns
FROM table1, table2;
```

### Example 1: All Possible Gear Pairings

```sql
-- Create all possible combinations of tents and sleeping bags
SELECT 
    t.gear_name AS tent,
    t.price_brl AS tent_price,
    s.gear_name AS sleeping_bag,
    s.price_brl AS bag_price,
    t.price_brl + s.price_brl AS total_price
FROM outdoor_gear t
CROSS JOIN outdoor_gear s
WHERE t.category_id = (SELECT category_id FROM gear_categories WHERE category_name = 'Tents')
  AND s.category_id = (SELECT category_id FROM gear_categories WHERE category_name = 'Sleeping Bags')
ORDER BY total_price;
```

**Result:** Every tent paired with every sleeping bag.

### Example 2: Generate Month × Location Combinations

```sql
-- Create a row for each location × month combination (for planning)
WITH months AS (
    SELECT generate_series(1, 12) AS month_num
)
SELECT 
    l.location_name,
    l.state,
    m.month_num,
    CASE m.month_num
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
FROM locations l
CROSS JOIN months m
WHERE l.location_type = 'national_park'
ORDER BY l.location_name, m.month_num;
```

### ⚠️ Warning: CROSS JOIN Can Be Huge!

If `table1` has 100 rows and `table2` has 200 rows:
- CROSS JOIN returns **100 × 200 = 20,000 rows**

**Always filter CROSS JOIN results to avoid performance issues!**

### 💡 When to Use CROSS JOIN

- Generate all combinations (product catalog pairings)
- Create calendar/schedule templates
- Test data generation
- Mathematical permutations

---

## 7. SELF JOIN - Join Table to Itself

### What is SELF JOIN?

A table joined **to itself** using aliases. Useful for hierarchical or relational data within the same table.

### Syntax

```sql
SELECT columns
FROM table_name AS alias1
JOIN table_name AS alias2 ON alias1.column = alias2.column;
```

### Example 1: Gear Categories Hierarchy

```sql
-- Show categories with their parent categories
SELECT 
    child.category_name AS subcategory,
    parent.category_name AS parent_category
FROM gear_categories child
LEFT JOIN gear_categories parent ON child.parent_category_id = parent.category_id
WHERE child.parent_category_id IS NOT NULL
ORDER BY parent.category_name, child.category_name;
```

**Result:**
```
subcategory          | parent_category
---------------------|------------------
2-Person Tents       | Tents
3-Person Tents       | Tents
Winter Sleeping Bags | Sleeping Bags
Summer Sleeping Bags | Sleeping Bags
```

### Example 2: Find Similar Trails

```sql
-- Find pairs of trails in the same location with similar difficulty
SELECT 
    t1.trail_name AS trail_1,
    t2.trail_name AS trail_2,
    l.location_name,
    t1.difficulty_level,
    ABS(t1.distance_km - t2.distance_km) AS distance_difference_km
FROM trails t1
JOIN trails t2 ON t1.location_id = t2.location_id
    AND t1.trail_id < t2.trail_id  -- Avoid duplicates and self-pairing
    AND t1.difficulty_level = t2.difficulty_level
JOIN locations l ON t1.location_id = l.location_id
WHERE ABS(t1.distance_km - t2.distance_km) < 5  -- Similar length
ORDER BY l.location_name, distance_difference_km;
```

### Example 3: Compare Campsites in Same Location

```sql
-- Compare campsite prices within the same location
SELECT 
    l.location_name,
    c1.campsite_name AS campsite_1,
    c1.price_per_night AS price_1,
    c2.campsite_name AS campsite_2,
    c2.price_per_night AS price_2,
    ABS(c1.price_per_night - c2.price_per_night) AS price_difference
FROM campsites c1
JOIN campsites c2 ON c1.location_id = c2.location_id
    AND c1.campsite_id < c2.campsite_id
JOIN locations l ON c1.location_id = l.location_id
WHERE ABS(c1.price_per_night - c2.price_per_night) > 30
ORDER BY l.location_name, price_difference DESC;
```

### 💡 SELF JOIN Tips

1. **Always use table aliases** (e.g., `t1`, `t2`)
2. **Prevent duplicates** with `t1.id < t2.id`
3. **Avoid self-pairing** with `t1.id != t2.id`

---

## 8. Multi-Table Joins

### Joining 3+ Tables

You can chain multiple JOIN clauses to combine many tables.

### Example 1: Campsites with Full Location and Weather

```sql
-- Complete campsite information with location and weather
SELECT 
    c.campsite_name,
    c.price_per_night,
    c.has_toilet,
    c.has_shower,
    l.location_name,
    l.state,
    l.difficulty_level,
    w.avg_temp_celsius,
    w.rainfall_mm,
    w.recorded_date
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
LEFT JOIN weather_data w ON l.location_id = w.location_id
    AND EXTRACT(MONTH FROM w.recorded_date) = 7  -- July only
WHERE c.price_per_night < 100
ORDER BY l.state, c.price_per_night;
```

### Example 2: Complete Trail Information

```sql
-- Trails with location, climbing routes, and weather
SELECT 
    t.trail_name,
    t.difficulty_level,
    t.distance_km,
    l.location_name,
    l.state,
    COUNT(DISTINCT cr.route_id) AS climbing_routes_nearby,
    ROUND(AVG(w.avg_temp_celsius), 1) AS avg_temp,
    ROUND(AVG(w.rainfall_mm), 1) AS avg_rainfall
FROM trails t
JOIN locations l ON t.location_id = l.location_id
LEFT JOIN climbing_routes cr ON l.location_id = cr.location_id
LEFT JOIN weather_data w ON l.location_id = w.location_id
GROUP BY t.trail_id, t.trail_name, t.difficulty_level, t.distance_km, l.location_name, l.state
ORDER BY t.difficulty_level, t.distance_km;
```

### Example 3: Gear Reviews with Full Details

```sql
-- Complete gear review information
SELECT 
    og.gear_name,
    og.brand,
    og.price_brl,
    gc.category_name,
    parent_gc.category_name AS parent_category,
    gr.rating,
    gr.review_text,
    gr.reviewer_name,
    gr.review_date,
    gr.verified_purchase
FROM gear_reviews gr
JOIN outdoor_gear og ON gr.gear_id = og.gear_id
JOIN gear_categories gc ON og.category_id = gc.category_id
LEFT JOIN gear_categories parent_gc ON gc.parent_category_id = parent_gc.category_id
WHERE gr.rating >= 4
  AND gr.verified_purchase = TRUE
ORDER BY gr.rating DESC, gr.review_date DESC
LIMIT 10;
```

### Example 4: Complex Location Analytics

```sql
-- Complete location overview with all related data
SELECT 
    l.location_name,
    l.state,
    l.location_type,
    l.difficulty_level,
    COUNT(DISTINCT c.campsite_id) AS campsite_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_campsite_price,
    COUNT(DISTINCT t.trail_id) AS trail_count,
    ROUND(AVG(t.distance_km), 2) AS avg_trail_distance,
    COUNT(DISTINCT cr.route_id) AS climbing_route_count,
    COUNT(DISTINCT w.weather_id) AS weather_records,
    ROUND(AVG(w.avg_temp_celsius), 1) AS avg_temp
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
LEFT JOIN trails t ON l.location_id = t.location_id
LEFT JOIN climbing_routes cr ON l.location_id = cr.location_id
LEFT JOIN weather_data w ON l.location_id = w.location_id
GROUP BY l.location_id, l.location_name, l.state, l.location_type, l.difficulty_level
HAVING COUNT(DISTINCT c.campsite_id) > 0  -- Only locations with campsites
ORDER BY campsite_count DESC, trail_count DESC;
```

### 💡 Multi-Table Join Tips

1. **Start with the main table** (the one you want all records from)
2. **Use INNER JOIN** for required relationships
3. **Use LEFT JOIN** for optional relationships
4. **Join in logical order** (easier to understand)
5. **Filter early** with WHERE to reduce rows before joining

---

## 9. Join Performance Tips

### Index Foreign Keys

```sql
-- Create indexes on foreign key columns for faster joins
CREATE INDEX idx_campsites_location_id ON campsites(location_id);
CREATE INDEX idx_trails_location_id ON trails(location_id);
CREATE INDEX idx_weather_location_id ON weather_data(location_id);
```

### Filter Before Joining (When Possible)

**❌ Slower:**
```sql
SELECT c.campsite_name, l.location_name
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE l.state = 'BA';
```

**✅ Faster (with subquery):**
```sql
SELECT c.campsite_name, l.location_name
FROM campsites c
JOIN (
    SELECT location_id, location_name 
    FROM locations 
    WHERE state = 'BA'
) l ON c.location_id = l.location_id;
```

**Note:** Modern query optimizers often do this automatically, but it's good practice.

### Use EXPLAIN to Analyze Queries

**PostgreSQL:**
```sql
EXPLAIN ANALYZE
SELECT c.campsite_name, l.location_name
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE l.state = 'RJ';
```

Shows execution plan and actual runtime.

### Avoid SELECT *

**❌ Bad:**
```sql
SELECT * 
FROM campsites c
JOIN locations l ON c.location_id = l.location_id;
```

**✅ Good:**
```sql
SELECT c.campsite_name, c.price_per_night, l.location_name, l.state
FROM campsites c
JOIN locations l ON c.location_id = l.location_id;
```

Only select columns you need!

---

## 10. Practice Exercises

### Exercise 1: Basic INNER JOIN ⭐

**Question:** Show all trail names with their location names and states. Order by state, then trail name.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    t.trail_name,
    l.location_name,
    l.state
FROM trails t
INNER JOIN locations l ON t.location_id = l.location_id
ORDER BY l.state, t.trail_name;
```
</details>

---

### Exercise 2: LEFT JOIN ⭐⭐

**Question:** Show ALL locations with the count of trails in each location. Include locations with zero trails. Order by trail count (descending).

<details>
<summary>💡 Hint</summary>

Use LEFT JOIN and COUNT with GROUP BY.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    l.state,
    COUNT(t.trail_id) AS trail_count
FROM locations l
LEFT JOIN trails t ON l.location_id = t.location_id
GROUP BY l.location_id, l.location_name, l.state
ORDER BY trail_count DESC, l.location_name;
```
</details>

---

### Exercise 3: Find Missing Data ⭐⭐

**Question:** Find all locations that have NO campsites. Show location name, state, and location type.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    l.state,
    l.location_type
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
WHERE c.campsite_id IS NULL;
```
</details>

---

### Exercise 4: Multi-Table Join ⭐⭐

**Question:** Show all campsites with their location name, state, and the location's difficulty level. Only show campsites under R$80 with toilets. Order by state and price.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    l.state,
    l.difficulty_level
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE c.price_per_night < 80
  AND c.has_toilet = TRUE
ORDER BY l.state, c.price_per_night;
```
</details>

---

### Exercise 5: Aggregation with JOIN ⭐⭐⭐

**Question:** For each state, show:
- State code
- Number of locations
- Number of campsites
- Average campsite price (rounded to 2 decimals)

Only include states with at least 2 locations. Order by number of campsites (descending).

<details>
<summary>💡 Hint</summary>

Join locations and campsites, GROUP BY state, use HAVING.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.state,
    COUNT(DISTINCT l.location_id) AS location_count,
    COUNT(c.campsite_id) AS campsite_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_price
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
GROUP BY l.state
HAVING COUNT(DISTINCT l.location_id) >= 2
ORDER BY campsite_count DESC;
```
</details>

---

### Exercise 6: SELF JOIN ⭐⭐⭐

**Question:** Find all pairs of campsites in the same location where the price difference is more than R$50. Show both campsite names, their prices, and the location name. Avoid duplicate pairs.

<details>
<summary>💡 Hint</summary>

SELF JOIN campsites table with `c1.campsite_id < c2.campsite_id` to avoid duplicates.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    c1.campsite_name AS campsite_1,
    c1.price_per_night AS price_1,
    c2.campsite_name AS campsite_2,
    c2.price_per_night AS price_2,
    ABS(c1.price_per_night - c2.price_per_night) AS price_difference
FROM campsites c1
JOIN campsites c2 ON c1.location_id = c2.location_id
    AND c1.campsite_id < c2.campsite_id
JOIN locations l ON c1.location_id = l.location_id
WHERE ABS(c1.price_per_night - c2.price_per_night) > 50
ORDER BY price_difference DESC;
```
</details>

---

### Exercise 7: Complex Multi-Table ⭐⭐⭐⭐

**Question:** Create a "Location Recommendation Report" with:
- Location name and state
- Number of easy/moderate trails
- Number of campsites with toilets
- Average campsite price
- Average temperature from weather data (July only)

Only show locations with:
- At least 1 trail
- At least 1 campsite with toilet
- Difficulty "easy" or "moderate"

Order by number of trails (descending), then average price (ascending).

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    l.state,
    COUNT(DISTINCT CASE 
        WHEN t.difficulty_level IN ('easy', 'moderate') 
        THEN t.trail_id 
    END) AS easy_moderate_trails,
    COUNT(DISTINCT CASE 
        WHEN c.has_toilet = TRUE 
        THEN c.campsite_id 
    END) AS campsites_with_toilet,
    ROUND(AVG(c.price_per_night), 2) AS avg_price,
    ROUND(AVG(CASE 
        WHEN EXTRACT(MONTH FROM w.recorded_date) = 7 
        THEN w.avg_temp_celsius 
    END), 1) AS avg_july_temp
FROM locations l
LEFT JOIN trails t ON l.location_id = t.location_id
LEFT JOIN campsites c ON l.location_id = c.location_id
LEFT JOIN weather_data w ON l.location_id = w.location_id
WHERE l.difficulty_level IN ('easy', 'moderate')
GROUP BY l.location_id, l.location_name, l.state
HAVING COUNT(DISTINCT t.trail_id) >= 1
   AND COUNT(DISTINCT CASE WHEN c.has_toilet = TRUE THEN c.campsite_id END) >= 1
ORDER BY easy_moderate_trails DESC, avg_price ASC;
```
</details>

---

## 🎯 Key Takeaways

✅ **INNER JOIN** - Only matching records from both tables  
✅ **LEFT JOIN** - All left table + matching right (use for optional data)  
✅ **RIGHT JOIN** - Rarely needed; use LEFT JOIN instead  
✅ **FULL OUTER JOIN** - All records from both (rare use)  
✅ **CROSS JOIN** - All combinations (use carefully!)  
✅ **SELF JOIN** - Table joined to itself (hierarchies, comparisons)  
✅ **Multi-table joins** - Chain JOINs for complex queries  
✅ **Performance** - Index foreign keys, select only needed columns  

---

## 🚀 Next Steps

Congratulations! You can now combine data from multiple tables like a pro! 

**Next Lesson: Subqueries & CTEs**
- Subqueries in SELECT, WHERE, FROM
- Common Table Expressions (WITH clause)
- Recursive CTEs
- Window functions
- Advanced query optimization

---

## 📖 Additional Resources

- [PostgreSQL JOIN Types](https://www.postgresql.org/docs/current/tutorial-join.html)
- [Visual JOIN Examples](https://joins.spathon.com/)
- [SQL JOIN Performance](https://www.postgresql.org/docs/current/using-explain.html)

---

**Estimated Completion Time**: 2.5 hours  
**Difficulty**: ⭐⭐⭐ Intermediate to Advanced  
**Prerequisites**: Lessons 1-4 completed

*Master the art of combining data! 🔗*
