# Lesson 3: Advanced Filtering Techniques
**Module 1: SQL Fundamentals - Lesson 3 of 6**

## 🎯 Learning Objectives

By the end of this lesson, you will:
- Master the `IN` operator for multiple value matching
- Use `BETWEEN` for range queries efficiently
- Apply `LIKE` and wildcards for pattern matching
- Implement `CASE` expressions for conditional logic
- Combine multiple filtering techniques in complex queries
- Understand performance implications of different filters

**Estimated Time**: 90 minutes

---

## 📚 Table of Contents

1. [The IN Operator](#1-the-in-operator)
2. [BETWEEN for Range Queries](#2-between-for-range-queries)
3. [Pattern Matching with LIKE](#3-pattern-matching-with-like)
4. [CASE Expressions](#4-case-expressions)
5. [Combining Advanced Filters](#5-combining-advanced-filters)
6. [SQLite vs PostgreSQL Notes](#6-sqlite-vs-postgresql-notes)
7. [Practice Exercises](#7-practice-exercises)

---

## 1. The IN Operator

### What is IN?

The `IN` operator allows you to specify multiple values in a WHERE clause. It's a cleaner alternative to multiple `OR` conditions.

### Syntax

```sql
SELECT column1, column2, ...
FROM table_name
WHERE column_name IN (value1, value2, value3, ...);
```

### Example 1: Find Locations in Specific States

**Without IN (verbose):**
```sql
SELECT location_name, state, location_type
FROM locations
WHERE state = 'BA' OR state = 'RJ' OR state = 'MG';
```

**With IN (clean):**
```sql
SELECT location_name, state, location_type
FROM locations
WHERE state IN ('BA', 'RJ', 'MG');
```

**Result:**
```
location_name                    | state | location_type
---------------------------------|-------|---------------
Chapada Diamantina               | BA    | national_park
Parque Nacional da Serra Órgãos  | RJ    | national_park
Pico da Bandeira                 | MG    | mountain_peak
```

### Example 2: Find Specific Location Types

```sql
SELECT location_name, location_type, difficulty_level
FROM locations
WHERE location_type IN ('mountain_peak', 'canyon', 'waterfall');
```

### Example 3: NOT IN - Exclude Values

```sql
-- Find all locations EXCEPT in São Paulo and Rio states
SELECT location_name, state
FROM locations
WHERE state NOT IN ('SP', 'RJ');
```

### 💡 Pro Tip: IN with Subqueries

You can use `IN` with a subquery to create dynamic filters:

```sql
-- Find campsites in locations that have climbing routes
SELECT campsite_name, location_id
FROM campsites
WHERE location_id IN (
    SELECT DISTINCT location_id 
    FROM climbing_routes
);
```

---

## 2. BETWEEN for Range Queries

### What is BETWEEN?

`BETWEEN` tests whether a value falls within a range (inclusive). It works with numbers, dates, and text.

### Syntax

```sql
SELECT column1, column2, ...
FROM table_name
WHERE column_name BETWEEN low_value AND high_value;
```

### Example 1: Price Ranges

**Find campsites between R$50 and R$100 per night:**

```sql
SELECT campsite_name, price_per_night
FROM campsites
WHERE price_per_night BETWEEN 50 AND 100
ORDER BY price_per_night;
```

**Result:**
```
campsite_name                    | price_per_night
---------------------------------|----------------
Camping Guinle                   | 50.00
Camping Três Picos              | 60.00
Camping Topo do Mundo           | 80.00
```

### Example 2: Date Ranges

```sql
-- Weather data from summer months (December to February)
SELECT location_id, recorded_date, avg_temp_celsius
FROM weather_data
WHERE EXTRACT(MONTH FROM recorded_date) BETWEEN 12 AND 2
   OR EXTRACT(MONTH FROM recorded_date) BETWEEN 1 AND 2;
```

**Better approach for date ranges:**
```sql
SELECT location_id, recorded_date, avg_temp_celsius
FROM weather_data
WHERE recorded_date BETWEEN '2024-12-01' AND '2025-02-28';
```

### Example 3: Altitude Ranges

```sql
-- Find trails at medium altitude (500m to 1500m)
SELECT trail_name, max_altitude_meters
FROM trails
WHERE max_altitude_meters BETWEEN 500 AND 1500
ORDER BY max_altitude_meters;
```

### Example 4: NOT BETWEEN

```sql
-- Find expensive or very cheap campsites (exclude mid-range)
SELECT campsite_name, price_per_night
FROM campsites
WHERE price_per_night NOT BETWEEN 60 AND 120;
```

### 💡 Important: BETWEEN is Inclusive

`BETWEEN 10 AND 20` includes both 10 and 20. Equivalent to `>= 10 AND <= 20`.

---

## 3. Pattern Matching with LIKE

### What is LIKE?

`LIKE` allows pattern matching with wildcards for text searching.

### Wildcards

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `%` | Zero or more characters | `'Cha%'` matches "Chapada", "Charqueadas" |
| `_` | Exactly one character | `'S_o'` matches "São", "Seo" |

### Syntax

```sql
SELECT column1, column2, ...
FROM table_name
WHERE column_name LIKE 'pattern';
```

### Example 1: Starts With Pattern

```sql
-- Find all locations starting with "Serra"
SELECT location_name, state
FROM locations
WHERE location_name LIKE 'Serra%';
```

**Result:**
```
location_name                    | state
---------------------------------|-------
Serra dos Órgãos                | RJ
Serra do Mar                    | SP
```

### Example 2: Ends With Pattern

```sql
-- Find trails ending with "Trail" or "Trilha"
SELECT trail_name
FROM trails
WHERE trail_name LIKE '%Trail' OR trail_name LIKE '%Trilha';
```

### Example 3: Contains Pattern

```sql
-- Find gear with "tent" or "barraca" anywhere in the name
SELECT gear_name, price_brl
FROM outdoor_gear
WHERE gear_name LIKE '%Tent%' OR gear_name LIKE '%Barraca%';
```

### Example 4: Specific Position Wildcard

```sql
-- Find 3-letter state codes with 'A' in the middle
SELECT DISTINCT state
FROM locations
WHERE state LIKE '_A_';
```

**Result:** `BA`, `MA`, `PA`

### Example 5: Case-Insensitive Search

**PostgreSQL:**
```sql
-- Use ILIKE for case-insensitive
SELECT location_name
FROM locations
WHERE location_name ILIKE '%chapada%';
```

**SQLite:**
```sql
-- LIKE is case-insensitive by default in SQLite
SELECT location_name
FROM locations
WHERE location_name LIKE '%chapada%';
```

### Example 6: NOT LIKE

```sql
-- Find locations that don't contain "National Park"
SELECT location_name, location_type
FROM locations
WHERE location_name NOT LIKE '%National Park%'
  AND location_name NOT LIKE '%Parque Nacional%';
```

### 💡 Performance Warning

`LIKE '%pattern%'` (wildcard at start) cannot use indexes efficiently. Avoid when possible for large datasets.

**Slow:**
```sql
WHERE location_name LIKE '%Serra%'  -- Full table scan
```

**Fast:**
```sql
WHERE location_name LIKE 'Serra%'   -- Can use index
```

---

## 4. CASE Expressions

### What is CASE?

`CASE` adds conditional logic to your queries - like an if/else statement in SQL.

### Syntax

**Simple CASE:**
```sql
CASE column_name
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

**Searched CASE (more flexible):**
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

### Example 1: Categorize Prices

```sql
SELECT 
    campsite_name,
    price_per_night,
    CASE
        WHEN price_per_night < 50 THEN 'Budget'
        WHEN price_per_night BETWEEN 50 AND 100 THEN 'Mid-Range'
        WHEN price_per_night > 100 THEN 'Premium'
        ELSE 'Unknown'
    END AS price_category
FROM campsites
ORDER BY price_per_night;
```

**Result:**
```
campsite_name                    | price_per_night | price_category
---------------------------------|-----------------|---------------
Camping Marimbus                 | 40.00           | Budget
Camping Guinle                   | 50.00           | Mid-Range
Camping Vale do Pati             | 120.00          | Premium
```

### Example 2: Difficulty Labels

```sql
SELECT 
    trail_name,
    difficulty_level,
    CASE difficulty_level
        WHEN 'easy' THEN '🟢 Easy - Great for beginners'
        WHEN 'moderate' THEN '🟡 Moderate - Some experience needed'
        WHEN 'hard' THEN '🔴 Hard - Experienced hikers only'
        WHEN 'expert' THEN '⚫ Expert - Technical skills required'
        ELSE '⚪ Unknown difficulty'
    END AS difficulty_description
FROM trails;
```

### Example 3: Season Classification

```sql
SELECT 
    location_id,
    recorded_date,
    avg_temp_celsius,
    CASE
        WHEN EXTRACT(MONTH FROM recorded_date) IN (12, 1, 2) THEN 'Summer ☀️'
        WHEN EXTRACT(MONTH FROM recorded_date) IN (3, 4, 5) THEN 'Autumn 🍂'
        WHEN EXTRACT(MONTH FROM recorded_date) IN (6, 7, 8) THEN 'Winter ❄️'
        WHEN EXTRACT(MONTH FROM recorded_date) IN (9, 10, 11) THEN 'Spring 🌸'
    END AS season
FROM weather_data;
```

### Example 4: Conditional Calculations

```sql
-- Apply discount to expensive campsites
SELECT 
    campsite_name,
    price_per_night AS original_price,
    CASE
        WHEN price_per_night > 100 THEN price_per_night * 0.85  -- 15% off
        WHEN price_per_night > 75 THEN price_per_night * 0.90   -- 10% off
        ELSE price_per_night  -- No discount
    END AS discounted_price
FROM campsites;
```

### Example 5: CASE in WHERE Clause

```sql
-- Dynamic filtering based on conditions
SELECT location_name, difficulty_level, location_type
FROM locations
WHERE 
    CASE
        WHEN location_type = 'national_park' THEN difficulty_level IN ('easy', 'moderate')
        WHEN location_type = 'mountain_peak' THEN difficulty_level IN ('hard', 'expert')
        ELSE TRUE  -- No restriction for other types
    END;
```

### Example 6: NULL Handling with CASE

```sql
SELECT 
    trail_name,
    duration_hours,
    CASE
        WHEN duration_hours IS NULL THEN 'Duration not specified'
        WHEN duration_hours < 3 THEN 'Short hike'
        WHEN duration_hours BETWEEN 3 AND 6 THEN 'Half-day hike'
        WHEN duration_hours > 6 THEN 'Full-day hike'
    END AS hike_duration_category
FROM trails;
```

---

## 5. Combining Advanced Filters

### Real-World Query Examples

### Example 1: Complex Location Search

```sql
-- Find challenging mountain locations in southeastern Brazil
-- with specific characteristics
SELECT 
    location_name,
    state,
    difficulty_level,
    CASE
        WHEN state IN ('RJ', 'MG', 'SP') THEN 'Southeast Region'
        WHEN state IN ('BA', 'TO') THEN 'Northeast/North Region'
        ELSE 'Other Region'
    END AS region_group
FROM locations
WHERE 
    difficulty_level IN ('hard', 'expert')
    AND location_type = 'mountain_peak'
    AND state IN ('RJ', 'MG', 'SP', 'ES')
ORDER BY difficulty_level, location_name;
```

### Example 2: Gear Shopping with Multiple Criteria

```sql
-- Find affordable camping gear from Brazilian brands
SELECT 
    gear_name,
    brand,
    price_brl,
    CASE
        WHEN price_brl < 100 THEN '💰 Budget-friendly'
        WHEN price_brl BETWEEN 100 AND 300 THEN '💵 Mid-range'
        ELSE '💎 Premium'
    END AS price_tier
FROM outdoor_gear
WHERE 
    price_brl BETWEEN 50 AND 500
    AND brand IN ('Nautika', 'Azteq', 'NTK', 'Doite')
    AND gear_name LIKE '%Barraca%'  -- Tents in Portuguese
ORDER BY price_brl;
```

### Example 3: Seasonal Trail Recommendations

```sql
-- Find moderate trails best visited in specific months
SELECT 
    t.trail_name,
    t.difficulty_level,
    t.max_altitude_meters,
    w.avg_temp_celsius,
    w.rainfall_mm,
    CASE
        WHEN w.avg_temp_celsius BETWEEN 15 AND 25 
         AND w.rainfall_mm < 100 THEN '✅ Ideal conditions'
        WHEN w.avg_temp_celsius NOT BETWEEN 10 AND 30 THEN '⚠️ Temperature concern'
        WHEN w.rainfall_mm > 200 THEN '⚠️ High rainfall'
        ELSE '✓ Acceptable conditions'
    END AS trail_conditions
FROM trails t
JOIN weather_data w ON t.location_id = w.location_id
WHERE 
    t.difficulty_level IN ('easy', 'moderate')
    AND t.max_altitude_meters BETWEEN 500 AND 1500
    AND EXTRACT(MONTH FROM w.recorded_date) IN (4, 5, 6, 7, 8, 9)  -- Autumn/Winter
ORDER BY trail_conditions, t.trail_name;
```

### Example 4: Advanced Campsite Filter

```sql
-- Find family-friendly campsites with amenities
SELECT 
    c.campsite_name,
    c.price_per_night,
    c.has_toilet,
    c.has_shower,
    c.has_electricity,
    l.location_name,
    CASE
        WHEN c.has_toilet AND c.has_shower AND c.has_electricity 
        THEN '⭐⭐⭐ Full amenities'
        WHEN c.has_toilet AND (c.has_shower OR c.has_electricity) 
        THEN '⭐⭐ Basic amenities'
        WHEN c.has_toilet 
        THEN '⭐ Minimal amenities'
        ELSE '⚠️ No amenities'
    END AS amenity_level
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE 
    c.price_per_night NOT BETWEEN 150 AND 9999  -- Affordable
    AND (c.has_toilet = TRUE OR c.has_shower = TRUE)
    AND l.difficulty_level IN ('easy', 'moderate')
    AND l.location_name NOT LIKE '%Expert%'
ORDER BY amenity_level DESC, c.price_per_night;
```

---

## 6. SQLite vs PostgreSQL Notes

### Using SQLite in VS Code

**Why SQLite?**
- ✅ No server installation needed
- ✅ Perfect for learning SQL
- ✅ Portable database file
- ✅ Great VS Code extensions available

**Setup SQLite in VS Code:**

1. **Install SQLite Extension:**
   - Open Extensions (Ctrl+Shift+X)
   - Search: "SQLite" by alexcvzz
   - Install "SQLite Viewer" or "SQLite"

2. **Create Database File:**
   ```bash
   cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"
   sqlite3 outdoor_adventure_br.db
   ```

3. **Load Schema:**
   ```bash
   # In SQLite shell
   .read database/setup_schema.sql
   .read database/data_insert_part1.sql
   .read database/data_insert_part2.sql
   ```

### Key Differences

| Feature | PostgreSQL | SQLite |
|---------|-----------|--------|
| `SERIAL` | `SERIAL PRIMARY KEY` | `INTEGER PRIMARY KEY AUTOINCREMENT` |
| `BOOLEAN` | `TRUE/FALSE` | `1/0` or `'true'/'false'` |
| `ILIKE` | ✅ Supported | ❌ Use `LIKE` (case-insensitive by default) |
| `EXTRACT()` | ✅ Supported | Use `strftime()` |
| `VARCHAR(n)` | ✅ Enforced | Accepts but doesn't enforce |

### SQLite-Compatible Queries

**Date extraction in SQLite:**
```sql
-- PostgreSQL
SELECT EXTRACT(MONTH FROM recorded_date) FROM weather_data;

-- SQLite equivalent
SELECT CAST(strftime('%m', recorded_date) AS INTEGER) FROM weather_data;
```

**Boolean in SQLite:**
```sql
-- PostgreSQL
WHERE has_toilet = TRUE

-- SQLite
WHERE has_toilet = 1  -- or 'true'
```

### 💡 Pro Tip

For this course, **SQLite is perfect for Module 1** (SQL fundamentals). Switch to PostgreSQL for Module 4+ when learning production features (transactions, replication, etc.).

---

## 7. Practice Exercises

### Exercise 1: IN Operator ⭐

**Question:** Find all locations in the states of Bahia (BA), Tocantins (TO), and Mato Grosso (MT) that are either national parks or state parks.

<details>
<summary>� Hint</summary>

Use `IN` for both state codes and location types.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT location_name, state, location_type
FROM locations
WHERE state IN ('BA', 'TO', 'MT')
  AND location_type IN ('national_park', 'state_park')
ORDER BY state, location_name;
```

**Expected Result:**
```
location_name                    | state | location_type
---------------------------------|-------|---------------
Chapada Diamantina               | BA    | national_park
Pantanal                         | MT    | wetlands
Parque Estadual do Jalapão       | TO    | state_park
```
</details>

---

### Exercise 2: BETWEEN ⭐

**Question:** Find campsites with prices between R$60 and R$120 (inclusive) that have both toilets AND showers.

<details>
<summary>💡 Hint</summary>

Combine `BETWEEN` with `AND` for boolean columns.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    campsite_name, 
    price_per_night,
    has_toilet,
    has_shower
FROM campsites
WHERE price_per_night BETWEEN 60 AND 120
  AND has_toilet = TRUE
  AND has_shower = TRUE
ORDER BY price_per_night;
```
</details>

---

### Exercise 3: LIKE Patterns ⭐⭐

**Question:** Find all trails that:
1. Have "Cachoeira" (waterfall) OR "Rio" (river) in the name
2. Are NOT expert difficulty

<details>
<summary>💡 Hint</summary>

Use `LIKE` with `%` wildcards and combine with `NOT LIKE` or `!=`.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT trail_name, difficulty_level, distance_km
FROM trails
WHERE (trail_name LIKE '%Cachoeira%' OR trail_name LIKE '%Rio%')
  AND difficulty_level != 'expert'
ORDER BY difficulty_level, trail_name;
```
</details>

---

### Exercise 4: CASE Expression ⭐⭐

**Question:** Create a query that categorizes outdoor gear into price ranges:
- Budget: < R$150
- Mid-Range: R$150 - R$400
- Premium: > R$400

Show gear name, price, and category. Order by category then price.

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    gear_name,
    price_brl,
    CASE
        WHEN price_brl < 150 THEN 'Budget'
        WHEN price_brl BETWEEN 150 AND 400 THEN 'Mid-Range'
        WHEN price_brl > 400 THEN 'Premium'
        ELSE 'Uncategorized'
    END AS price_category
FROM outdoor_gear
ORDER BY 
    CASE
        WHEN price_brl < 150 THEN 1
        WHEN price_brl BETWEEN 150 AND 400 THEN 2
        WHEN price_brl > 400 THEN 3
        ELSE 4
    END,
    price_brl;
```
</details>

---

### Exercise 5: Complex Combination ⭐⭐⭐

**Question:** Find climbing routes that meet ALL these criteria:
1. Technical grade between 'III' and 'V' (use IN: 'III', 'IV', 'V')
2. First ascent year between 1950 and 2000
3. Route name contains "Agulha" OR "Pico" OR "Dedo"
4. Add a CASE expression to categorize as:
   - "Classic Route" if first ascent before 1980
   - "Modern Route" if first ascent 1980 or later

<details>
<summary>💡 Hint</summary>

Combine IN, BETWEEN, LIKE (with OR), and CASE all together.
</details>

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    route_name,
    technical_grade,
    first_ascent_year,
    CASE
        WHEN first_ascent_year < 1980 THEN 'Classic Route'
        WHEN first_ascent_year >= 1980 THEN 'Modern Route'
        ELSE 'Unknown Era'
    END AS route_era
FROM climbing_routes
WHERE technical_grade IN ('III', 'IV', 'V')
  AND first_ascent_year BETWEEN 1950 AND 2000
  AND (route_name LIKE '%Agulha%' 
       OR route_name LIKE '%Pico%' 
       OR route_name LIKE '%Dedo%')
ORDER BY first_ascent_year, route_name;
```
</details>

---

### Exercise 6: Real-World Scenario ⭐⭐⭐

**Question:** You're planning a family camping trip in July (winter in Brazil). Find campsites that:
1. Cost between R$40 and R$100 per night
2. Have at least toilet facilities
3. Are in locations with "easy" or "moderate" difficulty
4. Add a recommendation column using CASE:
   - "Highly Recommended" if has toilet, shower, AND electricity
   - "Recommended" if has toilet and one other amenity
   - "Basic Option" otherwise

<details>
<summary>✅ Solution</summary>

```sql
SELECT 
    c.campsite_name,
    c.price_per_night,
    l.location_name,
    l.difficulty_level,
    c.has_toilet,
    c.has_shower,
    c.has_electricity,
    CASE
        WHEN c.has_toilet = TRUE 
         AND c.has_shower = TRUE 
         AND c.has_electricity = TRUE 
        THEN 'Highly Recommended ⭐⭐⭐'
        WHEN c.has_toilet = TRUE 
         AND (c.has_shower = TRUE OR c.has_electricity = TRUE)
        THEN 'Recommended ⭐⭐'
        ELSE 'Basic Option ⭐'
    END AS recommendation
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
WHERE c.price_per_night BETWEEN 40 AND 100
  AND c.has_toilet = TRUE
  AND l.difficulty_level IN ('easy', 'moderate')
ORDER BY recommendation DESC, c.price_per_night;
```
</details>

---

## 🎯 Key Takeaways

✅ **IN** simplifies multiple OR conditions  
✅ **BETWEEN** is inclusive (includes both boundary values)  
✅ **LIKE** with `%` for flexible pattern matching  
✅ **CASE** adds conditional logic to queries  
✅ Combining filters creates powerful, real-world queries  
✅ SQLite works great for learning, PostgreSQL for production  

---

## 🚀 Next Steps

You've mastered advanced filtering! Next up:

**Lesson 4: Aggregations & GROUP BY**
- COUNT, SUM, AVG, MIN, MAX
- GROUP BY for data summarization
- HAVING clause for filtered aggregations
- Real-world analytics on Brazilian outdoor data

---

## 📖 Additional Resources

- [PostgreSQL LIKE Pattern Matching](https://www.postgresql.org/docs/current/functions-matching.html)
- [SQLite Date Functions](https://www.sqlite.org/lang_datefunc.html)
- [SQL CASE Expressions Best Practices](https://modern-sql.com/feature/case)

---

**Estimated Completion Time**: 90 minutes  
**Difficulty**: ⭐⭐ Intermediate  
**Prerequisites**: Lessons 1-2 completed

*Happy filtering! 🎉*
