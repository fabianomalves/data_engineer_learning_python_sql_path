# Lesson 2: SQL Basics - SELECT & WHERE

**Duration**: 3-4 hours  
**Difficulty**: Beginner

---

## 🎯 **Learning Objectives**

- Understand SELECT statement anatomy
- Select all columns and specific columns
- Filter data with WHERE clause
- Use comparison operators (=, !=, <, >, <=, >=)
- Combine conditions with AND, OR, NOT
- Handle NULL values properly
- Write clean, readable SQL

---

## 📚 **1. The SELECT Statement**

### **What is SELECT?**

The `SELECT` statement is the most fundamental SQL command. It retrieves data from one or more tables.

**Basic Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

**Real-World Analogy:**
Think of a table as a filing cabinet:
- **SELECT** tells you which files (columns) you want to see
- **FROM** tells you which drawer (table) to look in
- **WHERE** filters which specific documents you need

---

## 💻 **2. Your First SELECT Query**

### **Example 1: Select All Columns**

```sql
-- Select everything from campsites table
SELECT *
FROM campsites;
```

**What this does:**
- `*` means "all columns"
- Returns every row and every column from the campsites table

**When to use `SELECT *`:**
- ✅ Exploring a new table to see what data it contains
- ✅ Ad-hoc analysis in development
- ❌ Production code (specify columns explicitly)
- ❌ Large tables (wastes resources)

### **Example 2: Select Specific Columns**

```sql
-- Select only name and price of campsites
SELECT 
    campsite_name,
    price_per_night
FROM campsites;
```

**Best Practice:**
Always specify column names in production code. This makes queries:
- Faster (less data transferred)
- More maintainable (clear what data you need)
- Less prone to breaking if table structure changes

### **Example 3: Select with Column Aliases**

```sql
-- Select columns with friendlier names
SELECT 
    campsite_name AS nome,
    price_per_night AS preco_diaria,
    capacity AS capacidade
FROM campsites;
```

**What are aliases?**
- Temporary names for columns in the result set
- Make output more readable
- Required when using calculated columns
- Use `AS` keyword (optional but recommended for clarity)

---

## 🔍 **3. The WHERE Clause**

The `WHERE` clause filters rows based on conditions.

### **Comparison Operators**

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal to | `price_per_night = 25.00` |
| `!=` or `<>` | Not equal to | `state != 'SP'` |
| `>` | Greater than | `elevation > 2000` |
| `<` | Less than | `temperature_max_c < 20` |
| `>=` | Greater than or equal | `capacity >= 50` |
| `<=` | Less than or equal | `price_per_night <= 30.00` |

### **Example 4: Filter by Exact Match**

```sql
-- Find campsites that cost exactly R$ 25.00 per night
SELECT 
    campsite_name,
    price_per_night,
    capacity
FROM campsites
WHERE price_per_night = 25.00;
```

### **Example 5: Filter by Comparison**

```sql
-- Find cheap campsites (less than R$ 30 per night)
SELECT 
    campsite_name,
    price_per_night,
    has_shower,
    has_electricity
FROM campsites
WHERE price_per_night < 30.00
ORDER BY price_per_night ASC;
```

---

## 🔗 **4. Logical Operators (AND, OR, NOT)**

### **AND Operator - ALL conditions must be true**

```sql
-- Find affordable campsites (< R$ 30) with showers
SELECT 
    campsite_name,
    price_per_night,
    has_shower,
    has_toilet
FROM campsites
WHERE price_per_night < 30.00
  AND has_shower = true;
```

### **OR Operator - AT LEAST ONE condition must be true**

```sql
-- Find campsites with either kitchen OR electricity
SELECT 
    campsite_name,
    has_kitchen,
    has_electricity,
    price_per_night
FROM campsites
WHERE has_kitchen = true 
   OR has_electricity = true;
```

### **Combining AND/OR (Order of Operations)**

```sql
-- Find cheap campsites (< R$ 30) with showers OR electricity
SELECT 
    campsite_name,
    price_per_night,
    has_shower,
    has_electricity
FROM campsites
WHERE price_per_night < 30.00
  AND (has_shower = true OR has_electricity = true);
```

**CRITICAL - Parentheses Matter!**

Always use parentheses when mixing AND/OR to make logic clear!

---

## 🚫 **5. Working with NULL Values**

### **What is NULL?**

`NULL` represents **missing** or **unknown** data. It's NOT zero, empty string, or false.

### **Testing for NULL**

**WRONG:**
```sql
WHERE contact_email = NULL  -- ❌ Will not work!
```

**CORRECT:**
```sql
WHERE contact_email IS NULL  -- ✅ Correct
WHERE contact_email IS NOT NULL  -- ✅ Also correct
```

### **Example: Find Missing Data**

```sql
-- Find campsites without contact emails
SELECT 
    campsite_name,
    contact_phone,
    contact_email
FROM campsites
WHERE contact_email IS NULL;
```

---

## 📊 **6. Practical Examples**

### **Example: Find Easy Trails**

```sql
-- Find all easy trails suitable for beginners
SELECT 
    trail_name,
    distance_km,
    estimated_hours,
    difficulty
FROM trails
WHERE difficulty = 'easy'
ORDER BY distance_km ASC;
```

### **Example: Find Good Weather Days**

```sql
-- Find sunny days with comfortable temperatures (20-28°C)
SELECT 
    date_recorded,
    temperature_min_c,
    temperature_max_c,
    conditions,
    location_id
FROM weather_data
WHERE conditions = 'sunny'
  AND temperature_max_c >= 20
  AND temperature_max_c <= 28
ORDER BY date_recorded DESC;
```

### **Example: Find Budget Camping**

```sql
-- Find campsites under R$ 25 with basic facilities
SELECT 
    campsite_name,
    price_per_night,
    capacity,
    has_toilet,
    has_shower
FROM campsites
WHERE price_per_night <= 25.00
  AND has_toilet = true
ORDER BY price_per_night ASC, capacity DESC;
```

---

## ✅ **Practice Questions**

### **Question 1: Basic SELECT**
Write a query to select the name, distance, and difficulty of all trails.

<details>
<summary><strong>Solution</strong></summary>

```sql
SELECT 
    trail_name,
    distance_km,
    difficulty
FROM trails;
```
</details>

### **Question 2: Filtering**
Find all locations in Bahia state (BA) that are national parks.

<details>
<summary><strong>Solution</strong></summary>

```sql
SELECT 
    l.location_name,
    l.location_type,
    l.elevation,
    r.state
FROM locations l
JOIN regions r ON l.region_id = r.region_id
WHERE r.state = 'BA'
  AND l.location_type = 'national_park';
```
</details>

### **Question 3: Complex Conditions**
Find all trails longer than 10km that are rated as 'hard' or 'extreme'.

<details>
<summary><strong>Solution</strong></summary>

```sql
SELECT 
    trail_name,
    distance_km,
    difficulty,
    estimated_hours
FROM trails
WHERE distance_km > 10
  AND (difficulty = 'hard' OR difficulty = 'extreme')
ORDER BY distance_km DESC;
```
</details>

---

## 🎯 **Key Takeaways**

1. **SELECT** specifies which columns to retrieve
2. **FROM** specifies which table to query
3. **WHERE** filters rows based on conditions
4. **AND** requires all conditions to be true
5. **OR** requires at least one condition to be true
6. **IS NULL** and **IS NOT NULL** test for missing data
7. **Parentheses** control logic when mixing AND/OR
8. **Code formatting** makes queries readable

---

## 🚀 **Next Lesson**

Continue to: `03_advanced_filtering.md`

**Congratulations on completing Lesson 2!** 🎉
