# Module 1: SQL Fundamentals & Database Design

**Duration**: Week 1-2 (12-20 hours)
**Focus**: Master SQL basics through the Brazilian Outdoor Adventure Platform project

---

## 🎯 **Learning Objectives**

By the end of this module, you will:

✅ Understand relational database concepts and design principles
✅ Write SELECT queries with WHERE clauses confidently
✅ Use filtering operators (AND, OR, IN, BETWEEN, LIKE)
✅ Perform basic aggregations (COUNT, SUM, AVG, MIN, MAX)
✅ Group and filter data with GROUP BY and HAVING
✅ Join multiple tables (INNER, LEFT, RIGHT, FULL)
✅ Design normalized database schemas
✅ Create tables with proper data types and constraints
✅ Understand indexes and basic performance optimization

---

## 📚 **Module Structure**

### **Lesson 1: Database Design Fundamentals**

- What is a relational database?
- Entities, attributes, and relationships
- Primary keys and foreign keys
- Normalization (1NF, 2NF, 3NF)
- Brazilian Outdoor Platform database design

### **Lesson 2: SQL Basics - SELECT & WHERE**

- SELECT statement anatomy
- Filtering with WHERE clause
- Comparison operators (=, !=, <, >, <=, >=)
- Logical operators (AND, OR, NOT)
- NULL handling (IS NULL, IS NOT NULL)

### **Lesson 3: Advanced Filtering**

- IN and NOT IN operators
- BETWEEN for range queries
- LIKE pattern matching with wildcards
- CASE expressions
- Practical examples from outdoor gear pricing

### **Lesson 4: Aggregations & GROUP BY**

- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY clause
- HAVING clause for filtering groups
- Analyzing trail difficulty and weather patterns

### **Lesson 5: Joins - Combining Data**

- INNER JOIN - matching records
- LEFT JOIN - keeping all from left table
- RIGHT JOIN - keeping all from right table
- FULL OUTER JOIN - keeping all records
- Self-joins and multi-table joins
- Joining gear, weather, and trail data

### **Lesson 6: Subqueries & CTEs**

- Subqueries in SELECT, WHERE, FROM
- Correlated subqueries
- Common Table Expressions (CTEs)
- Recursive CTEs for hierarchical data

---

## 🗄️ **Brazilian Outdoor Adventure Platform Database**

### **Database Overview**

We're building a comprehensive platform for outdoor enthusiasts in Brazil. The database will track:

1. **Camping Locations** - National parks, campsites, facilities
2. **Climbing Routes** - Mountains, difficulty ratings, season information
3. **Trail Information** - Hiking paths, distances, elevation data
4. **Weather Data** - Historical and current weather for locations
5. **Outdoor Gear** - Equipment, pricing, reviews, availability
6. **User Reviews** - Ratings and experiences from adventurers

### **Entity Relationship Diagram (ERD)**

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│    regions      │         │   locations      │         │   campsites     │
├─────────────────┤         ├──────────────────┤         ├─────────────────┤
│ region_id (PK)  │────┬───>│ location_id (PK) │<────┬───│ campsite_id (PK)│
│ region_name     │    │    │ region_id (FK)   │     │   │ location_id (FK)│
│ state           │    │    │ location_name    │     │   │ campsite_name   │
│ description     │    │    │ latitude         │     │   │ capacity        │
└─────────────────┘    │    │ longitude        │     │   │ facilities      │
                       │    │ elevation        │     │   │ price_per_night │
                       │    │ location_type    │     │   │ season_open     │
                       │    └──────────────────┘     │   └─────────────────┘
                       │                             │
                       │    ┌──────────────────┐     │   ┌─────────────────┐
                       │    │  climbing_routes │     │   │     trails      │
                       │    ├──────────────────┤     │   ├─────────────────┤
                       └───>│ route_id (PK)    │     └───>│ trail_id (PK)   │
                            │ location_id (FK) │         │ location_id (FK)│
                            │ route_name       │         │ trail_name      │
                            │ difficulty_grade │         │ distance_km     │
                            │ height_meters    │         │ difficulty      │
                            │ best_season      │         │ elevation_gain  │
                            │ first_ascent_date│         │ estimated_hours │
                            └──────────────────┘         └─────────────────┘

┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  weather_data   │         │   outdoor_gear   │         │  gear_reviews   │
├─────────────────┤         ├──────────────────┤         ├─────────────────┤
│ weather_id (PK) │         │ gear_id (PK)     │<────────│ review_id (PK)  │
│ location_id (FK)│         │ category         │         │ gear_id (FK)    │
│ date_recorded   │         │ gear_name        │         │ user_name       │
│ temperature_c   │         │ brand            │         │ rating          │
│ rainfall_mm     │         │ price_brl        │         │ review_text     │
│ wind_speed_kmh  │         │ weight_grams     │         │ date_posted     │
│ conditions      │         │ availability     │         └─────────────────┘
└─────────────────┘         │ store_name       │
                            │ store_url        │
                            └──────────────────┘
```

---

## 💻 **Setting Up Your Database**

### **Step 1: Install PostgreSQL**

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**macOS:**

```bash
brew install postgresql@15
brew services start postgresql@15
```

**Windows:**
Download from: https://www.postgresql.org/download/windows/

### **Step 2: Create Database**

```bash
# Switch to postgres user
sudo -u postgres psql

# In psql console
CREATE DATABASE outdoor_adventure_br;
CREATE USER outdoor_admin WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE outdoor_adventure_br TO outdoor_admin;
\q
```

### **Step 3: Connect to Database**

```bash
psql -U outdoor_admin -d outdoor_adventure_br -h localhost
```

---

## 📖 **Lessons & Tutorials**

Each lesson includes:

1. **Theory** - Detailed concept explanation
2. **Syntax** - SQL command structure
3. **Examples** - Real queries from our project
4. **Practice** - Questions with solutions
5. **Best Practices** - Industry standards
6. **Common Pitfalls** - What to avoid

### **Lesson Files**

- `01_database_design.md` - Database design principles
- `02_sql_basics_select_where.md` - Basic queries
- `03_advanced_filtering.md` - Complex filtering
- `04_aggregations_groupby.md` - Data aggregation
- `05_joins.md` - Combining tables
- `06_subqueries_ctes.md` - Advanced queries

---

## 🎯 **Practice Projects**

### **Project 1: Database Schema Creation**

Design and create the complete outdoor adventure database schema.

### **Project 2: Data Analysis Queries**

Write queries to answer business questions about camping, climbing, and gear.

### **Project 3: Performance Optimization**

Add indexes and optimize slow queries.

---

## ✅ **Module Completion Checklist**

- [ ] Understand database normalization
- [ ] Create all tables with proper constraints
- [ ] Write SELECT queries with WHERE
- [ ] Use comparison and logical operators
- [ ] Apply LIKE and IN operators
- [ ] Perform aggregations (COUNT, SUM, AVG)
- [ ] Group data with GROUP BY
- [ ] Filter groups with HAVING
- [ ] Join tables (INNER, LEFT, RIGHT, FULL)
- [ ] Write subqueries and CTEs
- [ ] Create indexes for performance
- [ ] Complete all practice questions

---

## 📚 **Additional Resources**

- PostgreSQL Documentation: https://www.postgresql.org/docs/
- SQL Style Guide: https://www.sqlstyle.guide/
- Database Normalization: https://en.wikipedia.org/wiki/Database_normalization
- SQL Tutorial: https://mode.com/sql-tutorial/

---

## 🚀 **Next Module**

After completing this module, proceed to:
**Module 2: Python Essentials for Data Engineering**

---

**Let's start with Lesson 1: Database Design Fundamentals!**
