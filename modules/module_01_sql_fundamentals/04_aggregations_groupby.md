# Lesson 4: Aggregations & GROUP BY
**Module 1: SQL Fundamentals - Lesson 4 of 6**

## 🎯 Learning Objectives

By the end of this lesson, you will:
- Master aggregate functions: COUNT, SUM, AVG, MIN, MAX
- Group data with GROUP BY clause
- Filter grouped data using HAVING
- Combine multiple aggregate functions
- Understand the difference between WHERE and HAVING
- Apply aggregations to real-world analytics

**Estimated Time**: 2 hours

---

## 📚 Table of Contents

1. [Introduction to Aggregations](#1-introduction-to-aggregations)
2. [COUNT - Counting Rows](#2-count---counting-rows)
3. [SUM and AVG - Numeric Calculations](#3-sum-and-avg---numeric-calculations)
4. [MIN and MAX - Finding Extremes](#4-min-and-max---finding-extremes)
5. [GROUP BY - Grouping Data](#5-group-by---grouping-data)
6. [HAVING - Filtering Groups](#6-having---filtering-groups)
7. [Combining Aggregations](#7-combining-aggregations)
8. [Practice Exercises](#8-practice-exercises)

---

## 1. Introduction to Aggregations

### What are Aggregate Functions?

Aggregate functions perform calculations on **multiple rows** and return a **single result**.

### Common Aggregate Functions

| Function | Purpose | Example Use Case |
|----------|---------|------------------|
| `COUNT()` | Count rows | How many campsites exist? |
| `SUM()` | Add values | Total revenue from bookings |
| `AVG()` | Calculate average | Average temperature in July |
| `MIN()` | Find minimum | Cheapest campsite price |
| `MAX()` | Find maximum | Highest mountain peak |

### Basic Syntax

```sql
SELECT aggregate_function(column_name)
FROM table_name
WHERE conditions;
```

---

## 2. COUNT - Counting Rows

### COUNT(*) - Count All Rows

```sql
-- How many locations are in our database?
SELECT COUNT(*) AS total_locations
FROM locations;
```

**Result:**
```
total_locations
---------------
20
```

### COUNT(column) - Count Non-NULL Values

```sql
-- How many campsites have electricity?
SELECT COUNT(has_electricity) AS campsites_counted
FROM campsites;

-- Better: Count TRUE values
SELECT COUNT(*) AS campsites_with_electricity
FROM campsites
WHERE has_electricity = TRUE;
```

### COUNT(DISTINCT) - Count Unique Values

```sql
-- How many different states have locations?
SELECT COUNT(DISTINCT state) AS unique_states
FROM locations;
```

**Result:**
```
unique_states
-------------
8
```

### Example: Counting by Location Type

```sql
SELECT 
    location_type,
    COUNT(*) AS count
FROM locations
GROUP BY location_type;
```

**Result:**
```
location_type    | count
-----------------|------
national_park    | 5
mountain_peak    | 4
canyon           | 2
wetlands         | 1
```

---

## 3. SUM and AVG - Numeric Calculations

### SUM() - Total of Values

```sql
-- What's the total distance of all trails combined?
SELECT SUM(distance_km) AS total_trail_distance_km
FROM trails;
```

**Result:**
```
total_trail_distance_km
-----------------------
245.5
```

### AVG() - Average Value

```sql
-- What's the average campsite price?
SELECT AVG(price_per_night) AS average_price_brl
FROM campsites;
```

**Result:**
```
average_price_brl
-----------------
78.50
```

### Rounding with ROUND()

```sql
-- Average price rounded to 2 decimal places
SELECT ROUND(AVG(price_per_night), 2) AS avg_price
FROM campsites;
```

### Example: Price Statistics

```sql
SELECT 
    ROUND(AVG(price_per_night), 2) AS avg_price,
    ROUND(SUM(price_per_night), 2) AS total_revenue_potential,
    COUNT(*) AS total_campsites
FROM campsites;
```

**Result:**
```
avg_price | total_revenue_potential | total_campsites
----------|-------------------------|----------------
78.50     | 1570.00                 | 20
```

---

## 4. MIN and MAX - Finding Extremes

### MIN() - Minimum Value

```sql
-- What's the cheapest campsite price?
SELECT MIN(price_per_night) AS cheapest_price
FROM campsites;
```

**Result:**
```
cheapest_price
--------------
40.00
```

### MAX() - Maximum Value

```sql
-- What's the highest altitude trail?
SELECT MAX(max_altitude_meters) AS highest_trail_altitude
FROM trails;
```

### Finding the Row with MIN/MAX

**❌ WRONG - This doesn't work:**
```sql
-- This returns wrong results!
SELECT campsite_name, MIN(price_per_night)
FROM campsites;
```

**✅ CORRECT - Use subquery:**
```sql
-- Find the cheapest campsite name and price
SELECT campsite_name, price_per_night
FROM campsites
WHERE price_per_night = (SELECT MIN(price_per_night) FROM campsites);
```

**Result:**
```
campsite_name        | price_per_night
---------------------|----------------
Camping Marimbus     | 40.00
```

### Example: Temperature Range

```sql
-- Temperature extremes for each location
SELECT 
    location_id,
    MIN(avg_temp_celsius) AS coldest_temp,
    MAX(avg_temp_celsius) AS hottest_temp,
    MAX(avg_temp_celsius) - MIN(avg_temp_celsius) AS temp_range
FROM weather_data
GROUP BY location_id
ORDER BY temp_range DESC;
```

---

## 5. GROUP BY - Grouping Data

### What is GROUP BY?

`GROUP BY` divides rows into groups and applies aggregate functions to each group.

### Basic GROUP BY Syntax

```sql
SELECT 
    column_to_group_by,
    aggregate_function(column)
FROM table_name
GROUP BY column_to_group_by;
```

### Example 1: Count Locations by State

```sql
SELECT 
    state,
    COUNT(*) AS location_count
FROM locations
GROUP BY state
ORDER BY location_count DESC;
```

**Result:**
```
state | location_count
------|---------------
RJ    | 4
MG    | 3
BA    | 3
SP    | 2
...
```

### Example 2: Average Prices by Location

```sql
SELECT 
    l.location_name,
    COUNT(c.campsite_id) AS campsite_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_price
FROM locations l
JOIN campsites c ON l.location_id = c.location_id
GROUP BY l.location_name
ORDER BY avg_price DESC;
```

### Example 3: Trails by Difficulty

```sql
SELECT 
    difficulty_level,
    COUNT(*) AS trail_count,
    ROUND(AVG(distance_km), 2) AS avg_distance_km,
    ROUND(AVG(duration_hours), 2) AS avg_duration_hours
FROM trails
GROUP BY difficulty_level
ORDER BY 
    CASE difficulty_level
        WHEN 'easy' THEN 1
        WHEN 'moderate' THEN 2
        WHEN 'hard' THEN 3
        WHEN 'expert' THEN 4
    END;
```

**Result:**
```
difficulty_level | trail_count | avg_distance_km | avg_duration_hours
-----------------|-------------|-----------------|-------------------
easy             | 5           | 8.50            | 3.20
moderate         | 8           | 12.30           | 5.50
hard             | 5           | 18.40           | 8.00
expert           | 2           | 25.00           | 12.00
```

### Multiple GROUP BY Columns

```sql
-- Count locations by state AND location type
SELECT 
    state,
    location_type,
    COUNT(*) AS count
FROM locations
GROUP BY state, location_type
ORDER BY state, location_type;
```

**Result:**
```
state | location_type  | count
------|----------------|------
BA    | national_park  | 2
BA    | canyon         | 1
MG    | mountain_peak  | 2
RJ    | national_park  | 3
...
```

### 💡 Important Rule: SELECT and GROUP BY

**Every column in SELECT must be either:**
1. In the `GROUP BY` clause, OR
2. Inside an aggregate function

**❌ WRONG:**
```sql
SELECT location_name, state, COUNT(*)
FROM locations
GROUP BY state;  -- location_name not in GROUP BY!
```

**✅ CORRECT:**
```sql
SELECT state, COUNT(*) AS count
FROM locations
GROUP BY state;
```

---

## 6. HAVING - Filtering Groups

### WHERE vs HAVING

| Clause | Filters | Applied | Used With |
|--------|---------|---------|-----------|
| `WHERE` | Individual rows | BEFORE grouping | Regular columns |
| `HAVING` | Groups | AFTER grouping | Aggregate functions |

### Basic HAVING Syntax

```sql
SELECT column, aggregate_function(column)
FROM table
GROUP BY column
HAVING aggregate_function(column) condition;
```

### Example 1: States with Multiple Locations

```sql
-- Find states with more than 2 locations
SELECT 
    state,
    COUNT(*) AS location_count
FROM locations
GROUP BY state
HAVING COUNT(*) > 2
ORDER BY location_count DESC;
```

**Result:**
```
state | location_count
------|---------------
RJ    | 4
MG    | 3
BA    | 3
```

### Example 2: Expensive Camping Areas

```sql
-- Find locations where average campsite price > R$80
SELECT 
    l.location_name,
    COUNT(c.campsite_id) AS campsite_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_price
FROM locations l
JOIN campsites c ON l.location_id = c.location_id
GROUP BY l.location_name
HAVING AVG(c.price_per_night) > 80
ORDER BY avg_price DESC;
```

### Example 3: WHERE + GROUP BY + HAVING

```sql
-- Find states in Southeast with more than 2 mountain peaks
SELECT 
    state,
    COUNT(*) AS mountain_count
FROM locations
WHERE location_type = 'mountain_peak'  -- Filter BEFORE grouping
  AND state IN ('RJ', 'MG', 'SP', 'ES')
GROUP BY state
HAVING COUNT(*) >= 2  -- Filter AFTER grouping
ORDER BY mountain_count DESC;
```

### Example 4: Active Gear Categories

```sql
-- Find gear categories with more than 3 products and avg price > R$200
SELECT 
    gc.category_name,
    COUNT(og.gear_id) AS product_count,
    ROUND(AVG(og.price_brl), 2) AS avg_price,
    ROUND(MIN(og.price_brl), 2) AS min_price,
    ROUND(MAX(og.price_brl), 2) AS max_price
FROM gear_categories gc
JOIN outdoor_gear og ON gc.category_id = og.category_id
GROUP BY gc.category_name
HAVING COUNT(og.gear_id) > 3
   AND AVG(og.price_brl) > 200
ORDER BY avg_price DESC;
```

---

## 7. Combining Aggregations

### Complex Real-World Analytics

### Example 1: Comprehensive Location Statistics

```sql
-- Complete overview of each location
SELECT 
    l.location_name,
    l.state,
    l.location_type,
    l.difficulty_level,
    COUNT(DISTINCT c.campsite_id) AS campsite_count,
    COUNT(DISTINCT t.trail_id) AS trail_count,
    COUNT(DISTINCT cr.route_id) AS climbing_route_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_campsite_price,
    ROUND(MIN(c.price_per_night), 2) AS min_price,
    ROUND(MAX(c.price_per_night), 2) AS max_price
FROM locations l
LEFT JOIN campsites c ON l.location_id = c.location_id
LEFT JOIN trails t ON l.location_id = t.location_id
LEFT JOIN climbing_routes cr ON l.location_id = cr.location_id
GROUP BY l.location_id, l.location_name, l.state, l.location_type, l.difficulty_level
HAVING COUNT(DISTINCT c.campsite_id) > 0  -- Only locations with campsites
ORDER BY campsite_count DESC, trail_count DESC;
```

### Example 2: Monthly Weather Analysis

```sql
-- Average conditions by month across all locations
SELECT 
    EXTRACT(MONTH FROM recorded_date) AS month,
    CASE EXTRACT(MONTH FROM recorded_date)
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
    END AS month_name,
    COUNT(*) AS record_count,
    ROUND(AVG(avg_temp_celsius), 1) AS avg_temp,
    ROUND(AVG(rainfall_mm), 1) AS avg_rainfall,
    ROUND(AVG(wind_speed_kmh), 1) AS avg_wind_speed
FROM weather_data
GROUP BY EXTRACT(MONTH FROM recorded_date)
ORDER BY month;
```

### Example 3: Gear Category Analysis

```sql
-- Detailed gear category statistics
SELECT 
    gc.category_name,
    gc.parent_category_id,
    COUNT(og.gear_id) AS total_products,
    COUNT(DISTINCT og.brand) AS brand_count,
    ROUND(AVG(og.price_brl), 2) AS avg_price,
    ROUND(MIN(og.price_brl), 2) AS min_price,
    ROUND(MAX(og.price_brl), 2) AS max_price,
    ROUND(MAX(og.price_brl) - MIN(og.price_brl), 2) AS price_range,
    COUNT(gr.review_id) AS review_count,
    ROUND(AVG(gr.rating), 1) AS avg_rating
FROM gear_categories gc
LEFT JOIN outdoor_gear og ON gc.category_id = og.category_id
LEFT JOIN gear_reviews gr ON og.gear_id = gr.gear_id
GROUP BY gc.category_id, gc.category_name, gc.parent_category_id
HAVING COUNT(og.gear_id) > 0  -- Only categories with products
ORDER BY total_products DESC, avg_rating DESC;
```

### Example 4: Trail Difficulty Statistics

```sql
-- Analyze trail characteristics by difficulty
SELECT 
    difficulty_level,
    COUNT(*) AS trail_count,
    ROUND(AVG(distance_km), 2) AS avg_distance,
    ROUND(MIN(distance_km), 2) AS shortest,
    ROUND(MAX(distance_km), 2) AS longest,
    ROUND(AVG(duration_hours), 2) AS avg_duration,
    ROUND(AVG(max_altitude_meters), 0) AS avg_max_altitude,
    COUNT(CASE WHEN is_circular = TRUE THEN 1 END) AS circular_trails,
    ROUND(
        100.0 * COUNT(CASE WHEN is_circular = TRUE THEN 1 END) / COUNT(*), 
        1
    ) AS percent_circular
FROM trails
GROUP BY difficulty_level
ORDER BY 
    CASE difficulty_level
        WHEN 'easy' THEN 1
        WHEN 'moderate' THEN 2
        WHEN 'hard' THEN 3
        WHEN 'expert' THEN 4
    END;
```

---

## 8. Practice Exercises

### Exercise 1: Basic COUNT ⭐

**Question:** How many campsites have BOTH a shower AND electricity?

<details>
<summary>💡 Hint</summary>

Use WHERE with AND, then COUNT(*).
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT COUNT(*) AS campsites_with_amenities
FROM campsites
WHERE has_shower = TRUE 
  AND has_electricity = TRUE;
```
</details>

---

### Exercise 2: AVG and ROUND ⭐

**Question:** What's the average trail distance for "moderate" difficulty trails? Round to 2 decimal places.

<details>
<summary>✅ Solution</summary>

```sql
SELECT ROUND(AVG(distance_km), 2) AS avg_moderate_distance
FROM trails
WHERE difficulty_level = 'moderate';
```
</details>

---

### Exercise 3: GROUP BY ⭐⭐

**Question:** Count how many campsites each location has. Show location name and count. Order by count (highest first).

<details>
<summary>💡 Hint</summary>

JOIN locations and campsites, GROUP BY location_name.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    COUNT(c.campsite_id) AS campsite_count
FROM locations l
JOIN campsites c ON l.location_id = c.location_id
GROUP BY l.location_name
ORDER BY campsite_count DESC;
```
</details>

---

### Exercise 4: Multiple Aggregates ⭐⭐

**Question:** For each brand of outdoor gear, show:
- Brand name
- Number of products
- Average price (rounded to 2 decimals)
- Cheapest product price
- Most expensive product price

Order by number of products (descending).

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    brand,
    COUNT(*) AS product_count,
    ROUND(AVG(price_brl), 2) AS avg_price,
    MIN(price_brl) AS min_price,
    MAX(price_brl) AS max_price
FROM outdoor_gear
GROUP BY brand
ORDER BY product_count DESC;
```
</details>

---

### Exercise 5: HAVING Clause ⭐⭐

**Question:** Find locations that have more than 2 trails. Show location name and trail count.

<details>
<summary>💡 Hint</summary>

GROUP BY location, then use HAVING COUNT(*) > 2.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    COUNT(t.trail_id) AS trail_count
FROM locations l
JOIN trails t ON l.location_id = t.location_id
GROUP BY l.location_name
HAVING COUNT(t.trail_id) > 2
ORDER BY trail_count DESC;
```
</details>

---

### Exercise 6: WHERE + GROUP BY + HAVING ⭐⭐⭐

**Question:** Find states that have at least 2 "easy" or "moderate" difficulty locations. Show state and count.

<details>
<summary>💡 Hint</summary>

1. WHERE filters difficulty before grouping
2. GROUP BY state
3. HAVING counts after grouping
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    state,
    COUNT(*) AS beginner_friendly_count
FROM locations
WHERE difficulty_level IN ('easy', 'moderate')
GROUP BY state
HAVING COUNT(*) >= 2
ORDER BY beginner_friendly_count DESC;
```
</details>

---

### Exercise 7: Complex Analytics ⭐⭐⭐

**Question:** Create a "Gear Shopping Report" showing:
- Gear category name
- Number of products in that category
- Average price
- Number of reviews
- Average rating

Only include categories with:
- At least 2 products
- At least 1 review
- Average price between R$100 and R$500

Order by average rating (highest first).

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    gc.category_name,
    COUNT(DISTINCT og.gear_id) AS product_count,
    ROUND(AVG(og.price_brl), 2) AS avg_price,
    COUNT(gr.review_id) AS review_count,
    ROUND(AVG(gr.rating), 1) AS avg_rating
FROM gear_categories gc
JOIN outdoor_gear og ON gc.category_id = og.category_id
LEFT JOIN gear_reviews gr ON og.gear_id = gr.gear_id
GROUP BY gc.category_id, gc.category_name
HAVING COUNT(DISTINCT og.gear_id) >= 2
   AND COUNT(gr.review_id) >= 1
   AND AVG(og.price_brl) BETWEEN 100 AND 500
ORDER BY avg_rating DESC, product_count DESC;
```
</details>

---

### Exercise 8: Real-World Scenario ⭐⭐⭐⭐

**Question:** Create a "Best Value Camping Destinations" report:

Find locations where:
1. Average campsite price is below R$80
2. At least 2 campsites exist
3. At least 50% of campsites have toilets
4. Location difficulty is "easy" or "moderate"

Show:
- Location name and state
- Number of campsites
- Average price (rounded)
- Number of campsites with toilets
- Percentage with toilets (rounded to 1 decimal)

Order by percentage with toilets (descending), then by average price (ascending).

<details>
<summary>💡 Hint</summary>

Use COUNT with CASE for conditional counting, then calculate percentage.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    l.location_name,
    l.state,
    COUNT(c.campsite_id) AS campsite_count,
    ROUND(AVG(c.price_per_night), 2) AS avg_price,
    COUNT(CASE WHEN c.has_toilet = TRUE THEN 1 END) AS campsites_with_toilet,
    ROUND(
        100.0 * COUNT(CASE WHEN c.has_toilet = TRUE THEN 1 END) / COUNT(c.campsite_id),
        1
    ) AS percent_with_toilet
FROM locations l
JOIN campsites c ON l.location_id = c.location_id
WHERE l.difficulty_level IN ('easy', 'moderate')
GROUP BY l.location_id, l.location_name, l.state
HAVING COUNT(c.campsite_id) >= 2
   AND AVG(c.price_per_night) < 80
   AND COUNT(CASE WHEN c.has_toilet = TRUE THEN 1 END) >= COUNT(c.campsite_id) * 0.5
ORDER BY percent_with_toilet DESC, avg_price ASC;
```
</details>

---

## 🎯 Key Takeaways

✅ **COUNT** counts rows or non-NULL values  
✅ **SUM/AVG** for numeric calculations  
✅ **MIN/MAX** find extreme values  
✅ **GROUP BY** divides data into groups  
✅ **HAVING** filters groups (not individual rows)  
✅ **WHERE** filters before grouping, **HAVING** filters after  
✅ Combine multiple aggregates for powerful analytics  

---

## 🚀 Next Steps

Congratulations! You can now analyze data like a pro! Next up:

**Lesson 5: Joins - Combining Data from Multiple Tables**
- INNER JOIN
- LEFT/RIGHT/FULL OUTER JOIN
- Self joins and cross joins
- Multi-table joins for complex queries

---

## 📖 Additional Resources

- [PostgreSQL Aggregate Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [GROUP BY Best Practices](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUP)
- [WHERE vs HAVING](https://www.postgresql.org/docs/current/tutorial-agg.html)

---

**Estimated Completion Time**: 2 hours  
**Difficulty**: ⭐⭐ Intermediate  
**Prerequisites**: Lessons 1-3 completed

*Master your data analysis skills! 📊*
