# Lesson 3: Database Connectivity with Python - Complete Overview

## 📖 Introduction

Welcome to **Lesson 3: Database Connectivity with Python**! This lesson bridges Python and databases, teaching you how to execute SQL queries from Python, handle results, and build robust data pipelines. You'll master both low-level database drivers and high-level ORMs.

**Why This Lesson Matters:**
- **Data Lives in Databases** - Most production data is in relational databases
- **Python + SQL = Power** - Combine Python logic with SQL analytics
- **Production Skills** - Learn industry-standard database connectivity patterns
- **ORM Mastery** - Use SQLAlchemy, the most popular Python ORM
- **Data Integration** - Connect databases to pandas for analysis

---

## 📊 Lesson Statistics

| Metric | Value |
|--------|-------|
| **Total Lines** | 2,850 lines |
| **Sections** | 6 comprehensive sections |
| **Code Examples** | 85+ working examples |
| **Practice Exercises** | 4 with complete solutions |
| **Estimated Study Time** | 8-10 hours |
| **Difficulty Level** | Intermediate |
| **Prerequisites** | Lessons 1-2 + SQL Fundamentals |

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

✅ **psycopg2 Fundamentals:**
- Connect to PostgreSQL databases with connection strings
- Execute SQL queries with cursor.execute()
- Fetch results with fetchone(), fetchall(), fetchmany()
- Use parameterized queries to prevent SQL injection
- Handle database transactions (commit, rollback)
- Manage connections and cursors properly
- Handle database exceptions gracefully

✅ **SQLAlchemy Core:**
- Create database engines and connections
- Build SQL with SQLAlchemy Expression Language
- Use text() for raw SQL with parameters
- Handle connection pooling automatically
- Execute queries with Connection.execute()
- Work with ResultProxy objects
- Convert results to dictionaries

✅ **SQLAlchemy ORM:**
- Define models as Python classes
- Map classes to database tables
- Create sessions for database operations
- Query with ORM query interface
- Insert, update, delete with ORM
- Handle relationships between models
- Use eager loading to avoid N+1 queries

✅ **Connection Management:**
- Create connection pools for production
- Configure pool size and behavior
- Reuse connections efficiently
- Handle connection failures
- Implement connection retry logic
- Use context managers for cleanup

✅ **pandas Integration:**
- Load query results into DataFrames with read_sql()
- Write DataFrames to database with to_sql()
- Handle large datasets with chunking
- Choose appropriate data types
- Create database tables from DataFrames
- Export query results to CSV, JSON, Parquet

✅ **Best Practices:**
- Always use parameterized queries
- Handle exceptions with specific catches
- Use connection pooling in production
- Close connections properly
- Log database operations
- Validate input data before queries

---

## 📚 Lesson Structure

### **Section 1: PostgreSQL with psycopg2** (~767 lines)

**What You'll Learn:**
- Connect to PostgreSQL with psycopg2
- Execute queries and fetch results
- Use parameterized queries safely
- Manage transactions

**Key Topics:**

**Connecting to Databases:**
```python
import psycopg2

# Connection string format
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="campsites_db",
    user="postgres",
    password="your_password"
)
```

**Executing Queries:**
- Create cursor: `cursor = conn.cursor()`
- Execute query: `cursor.execute(sql)`
- Fetch results:
  - `fetchone()`: Single row as tuple
  - `fetchall()`: All rows as list of tuples
  - `fetchmany(n)`: N rows
- Get column names: `cursor.description`

**Parameterized Queries (Critical!):**
```python
# WRONG - SQL Injection vulnerability!
user_id = request.get('id')
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# RIGHT - Safe from SQL injection
cursor.execute(
    "SELECT * FROM users WHERE id = %s",
    (user_id,)  # Tuple of parameters
)
```

**Transaction Management:**
- Auto-commit off by default
- `conn.commit()`: Save changes
- `conn.rollback()`: Undo changes
- Use transactions for data consistency
- Handle errors with try/except/finally

**CRUD Operations:**
- **Create**: INSERT with RETURNING
- **Read**: SELECT with WHERE
- **Update**: UPDATE with WHERE
- **Delete**: DELETE with WHERE
- Always use parameters for values

**Real-World Examples:**
- Querying campsite data
- Filtering with multiple conditions
- Inserting bookings with transactions
- Bulk inserts efficiently
- Handling foreign key relationships

**Practical Skills:**
- Write safe, parameterized queries
- Handle query results properly
- Use transactions correctly
- Close connections and cursors
- Catch and handle database errors

---

### **Section 2: SQLAlchemy Core** (~540 lines)

**What You'll Learn:**
- Create database engines
- Build SQL with Expression Language
- Execute queries with SQLAlchemy
- Use connection pooling

**Key Topics:**

**Creating Engines:**
```python
from sqlalchemy import create_engine

# PostgreSQL connection URL
engine = create_engine(
    'postgresql://user:password@localhost:5432/campsites_db'
)

# Get a connection
conn = engine.connect()
```

**Raw SQL with text():**
```python
from sqlalchemy import text

# Execute raw SQL safely
result = conn.execute(
    text("SELECT * FROM campsites WHERE state = :state"),
    {"state": "BA"}
)

for row in result:
    print(row)
```

**Expression Language:**
```python
from sqlalchemy import Table, MetaData, select

# Define table structure
metadata = MetaData()
campsites = Table('campsites', metadata, autoload_with=engine)

# Build query
query = select(campsites).where(campsites.c.state == 'BA')

# Execute
result = conn.execute(query)
```

**Advantages Over psycopg2:**
- Database-agnostic (works with PostgreSQL, MySQL, SQLite, etc.)
- Built-in connection pooling
- Automatic parameter binding
- Better error messages
- Type conversion handled automatically

**Connection Pooling:**
- Connections reused automatically
- Configure pool size: `pool_size=5`
- Handle connection overflow
- Set connection timeouts
- Recycle connections periodically

**Real-World Examples:**
- Dynamic query building
- Cross-database compatibility
- Production connection management
- Complex WHERE conditions
- JOIN operations

**Practical Skills:**
- Create and manage engines
- Execute parameterized queries safely
- Build dynamic SQL with Expression Language
- Handle results efficiently
- Configure connection pools

---

### **Section 3: SQLAlchemy ORM** (~317 lines)

**What You'll Learn:**
- Define models as Python classes
- Map tables to objects
- Query with ORM
- Handle relationships

**Key Topics:**

**Defining Models:**
```python
from sqlalchemy import Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Campsite(Base):
    __tablename__ = 'campsites'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(200))
    state = Column(String(2))
    capacity = Column(Integer)
    price = Column(Float)
```

**Creating Sessions:**
```python
from sqlalchemy.orm import sessionmaker

Session = sessionmaker(bind=engine)
session = Session()
```

**Querying with ORM:**
```python
# Query all
campsites = session.query(Campsite).all()

# Filter
ba_sites = session.query(Campsite)\
    .filter(Campsite.state == 'BA')\
    .all()

# Order and limit
top5 = session.query(Campsite)\
    .order_by(Campsite.price.desc())\
    .limit(5)\
    .all()

# Access as objects
for site in ba_sites:
    print(site.name, site.price)
```

**CRUD with ORM:**
```python
# Create
new_site = Campsite(
    name="Serra Verde",
    state="MG",
    capacity=40,
    price=85.0
)
session.add(new_site)
session.commit()

# Update
site = session.query(Campsite).filter_by(id=1).first()
site.price = 95.0
session.commit()

# Delete
site = session.query(Campsite).filter_by(id=2).first()
session.delete(site)
session.commit()
```

**Relationships:**
- One-to-Many: Campsite to Bookings
- Many-to-Many: Users to Campgrounds
- Foreign keys
- Eager loading with joinedload()
- Avoiding N+1 query problem

**ORM vs Raw SQL:**
- **ORM**: Cleaner code, type safety, relationships
- **Raw SQL**: More control, complex queries, performance
- Use ORM for CRUD, raw SQL for analytics

**Practical Skills:**
- Define models for database tables
- Query with ORM methods
- Handle CRUD operations
- Work with relationships
- Choose ORM vs raw SQL appropriately

---

### **Section 4: Database Connection Pools** (~165 lines)

**What You'll Learn:**
- Understand connection pooling
- Configure pools for production
- Handle pool exhaustion
- Monitor pool health

**Key Topics:**

**Why Connection Pooling?**
- Creating connections is expensive (100ms+)
- Reuse connections for efficiency
- Control maximum connections
- Handle connection failures gracefully
- Essential for production applications

**Configuring Pools:**
```python
from sqlalchemy import create_engine

engine = create_engine(
    'postgresql://user:password@localhost/db',
    pool_size=5,              # Maintain 5 connections
    max_overflow=10,          # Allow 10 extra connections
    pool_timeout=30,          # Wait 30s for connection
    pool_recycle=3600,        # Recycle after 1 hour
    pool_pre_ping=True        # Check connection before use
)
```

**Pool Parameters:**
- **pool_size**: Base connections to maintain
- **max_overflow**: Extra connections when busy
- **pool_timeout**: Max wait time for connection
- **pool_recycle**: Recycle old connections
- **pool_pre_ping**: Validate before using

**Connection Pool Patterns:**
- Get connection from pool
- Use connection
- Return to pool (automatic with context manager)
- Pool manages connection lifecycle

**Handling Pool Exhaustion:**
- Increase pool_size if too small
- Increase max_overflow for spikes
- Reduce pool_timeout if waiting too long
- Log pool statistics
- Monitor active connections

**Real-World Scenarios:**
- Web application with 100+ concurrent users
- ETL pipeline with parallel processing
- Microservices sharing database
- Connection leak debugging

**Practical Skills:**
- Configure appropriate pool sizes
- Handle pool timeout exceptions
- Monitor pool utilization
- Debug connection leaks
- Tune for production workloads

---

### **Section 5: pandas Database Integration** (~321 lines)

**What You'll Learn:**
- Load query results into DataFrames
- Write DataFrames to databases
- Handle large datasets efficiently
- Export in multiple formats

**Key Topics:**

**Reading from Database:**
```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://user:pass@localhost/db')

# Query to DataFrame
df = pd.read_sql(
    "SELECT * FROM campsites WHERE state = 'BA'",
    engine
)

# Or with SQLAlchemy queries
df = pd.read_sql_query(query, engine)

# Or entire table
df = pd.read_sql_table('campsites', engine)
```

**Writing to Database:**
```python
# DataFrame to database table
df.to_sql(
    'campsites_new',
    engine,
    if_exists='replace',  # 'fail', 'replace', 'append'
    index=False,          # Don't write index as column
    chunksize=1000        # Insert 1000 rows at a time
)
```

**Handling Large Datasets:**
- Use `chunksize` for reading: Process in batches
- Use `chunksize` for writing: Insert in chunks
- Read only needed columns: `columns=['id', 'name']`
- Filter at database level: Use WHERE in SQL
- Use `iterator=True` for manual chunking

**Data Type Mapping:**
- pandas infers types from database
- Specify types with `dtype` parameter
- Handle dates with `parse_dates`
- Handle NULLs appropriately

**Complete Workflow Example:**
```python
# Extract from database
df = pd.read_sql("SELECT * FROM sales WHERE year = 2024", engine)

# Transform with pandas
df['revenue'] = df['quantity'] * df['price']
monthly = df.groupby('month')['revenue'].sum()

# Load to database
monthly.to_sql('monthly_revenue', engine, if_exists='replace')

# Export to files
monthly.to_csv('revenue.csv')
monthly.to_json('revenue.json')
monthly.to_parquet('revenue.parquet')
```

**Real-World Applications:**
- Extract data for analysis
- Load processed data back to database
- Export reports in multiple formats
- Build ETL pipelines with pandas
- Data quality checking

**Practical Skills:**
- Query databases into DataFrames
- Write DataFrames to database tables
- Handle large datasets with chunking
- Export query results to files
- Build complete extract-transform-load workflows

---

### **Section 6: Practice Exercises** (~740 lines)

**What You'll Learn:**
- Apply all database connectivity concepts
- Build complete data pipelines
- Handle real-world scenarios
- Debug database issues

**Practice Problems:**

**Exercise 1: Query and Export**
- Connect to campsite database
- Query campsites by state
- Calculate statistics (avg price, total capacity)
- Export results to CSV and JSON
- Complete solution with error handling

**Exercise 2: Bulk Data Loading**
- Read CSV file with booking data
- Validate data before insert
- Bulk insert to database using transactions
- Handle duplicate records
- Roll back on errors

**Exercise 3: ORM CRUD Application**
- Define Campsite and Booking models
- Create relationships
- Implement CRUD functions
- Query with filters and joins
- Handle cascade deletes

**Exercise 4: pandas ETL Pipeline**
- Extract campsite data to DataFrame
- Transform: clean, calculate derived fields
- Aggregate by category
- Load results back to database
- Export to Parquet for archival

**Each Exercise Includes:**
- Clear requirements
- Sample database schema
- Expected output format
- Step-by-step hints
- Complete working solution
- Error handling patterns
- Alternative approaches
- Performance considerations

**Practical Skills:**
- Build complete database applications
- Handle transactions properly
- Validate data before insertion
- Export data in multiple formats
- Debug database connection issues
- Optimize query performance

---

## 🛠️ Technical Requirements

**Python Version:**
- Python 3.8+

**Required Libraries:**
```bash
# Database drivers
pip install psycopg2-binary==2.9.9    # PostgreSQL
# OR for production:
pip install psycopg2==2.9.9           # Requires PostgreSQL dev files

# ORM and utilities
pip install sqlalchemy==2.0.23
pip install pandas==2.1.3
pip install pyarrow==14.0.0           # For Parquet export
```

**Database Setup:**
- PostgreSQL 12+ installed and running
- Campsite database from Module 1
- Test user with appropriate permissions

**Connection String Format:**
```
postgresql://user:password@host:port/database
```

---

## 📖 How to Use This Lesson

### **Recommended Approach:**

1. **Setup Database First** - Ensure PostgreSQL is running
2. **Test Connection** - Verify you can connect
3. **Type Every Example** - Build understanding
4. **Run Queries** - See real results
5. **Complete Exercises** - Apply concepts

### **Study Schedule:**

**Day 1: psycopg2 Basics (Section 1)**
- Morning: Connection, cursors, basic queries
- Afternoon: Parameterized queries, transactions
- Practice: CRUD operations

**Day 2: SQLAlchemy Core & ORM (Sections 2-3)**
- Morning: Engines, text queries, Expression Language
- Afternoon: ORM models, sessions, queries
- Practice: Convert psycopg2 code to ORM

**Day 3: Production Patterns (Sections 4-5)**
- Morning: Connection pooling configuration
- Afternoon: pandas integration, ETL workflows
- Practice: Build complete pipeline

**Day 4: Practice & Integration (Section 6)**
- Morning: Exercises 1-2
- Afternoon: Exercises 3-4
- Evening: Build personal database project

---

## 💡 Key Takeaways

### **Database Connectivity Principles:**

1. **Always Parameterize Queries**
   - Never use f-strings for SQL
   - Use %s (psycopg2) or :param (SQLAlchemy)
   - Prevents SQL injection attacks
   - Handles type conversion

2. **Manage Transactions Properly**
   - Commit on success
   - Rollback on errors
   - Use try/except/finally
   - Keep transactions short

3. **Use Connection Pooling**
   - Essential for production
   - Reuses connections efficiently
   - Configure appropriate sizes
   - Monitor pool health

4. **Choose the Right Tool**
   - **psycopg2**: Low-level control, PostgreSQL-specific
   - **SQLAlchemy Core**: Database-agnostic, connection pooling
   - **SQLAlchemy ORM**: Object mapping, relationships
   - **pandas**: Data analysis, bulk operations

---

## 🎯 Real-World Applications

**Data Engineering:**
- ETL pipelines reading from databases
- Loading transformed data to warehouses
- Incremental data updates
- Data quality validation

**Web Applications:**
- User authentication queries
- CRUD operations
- Transaction processing
- Connection pooling for scalability

**Data Analysis:**
- Extract data to pandas
- Perform analysis
- Store results back to database
- Generate reports

---

## ✅ Self-Assessment Checklist

After completing this lesson, you should be able to:

### **Basic Connectivity:**
- [ ] Connect to PostgreSQL with psycopg2
- [ ] Execute queries with cursors
- [ ] Fetch results properly
- [ ] Use parameterized queries always
- [ ] Handle transactions correctly

### **SQLAlchemy:**
- [ ] Create engines and connections
- [ ] Execute queries with text()
- [ ] Define ORM models
- [ ] Query with ORM interface
- [ ] Choose Core vs ORM appropriately

### **Production Skills:**
- [ ] Configure connection pools
- [ ] Handle pool exhaustion
- [ ] Use pandas for database I/O
- [ ] Export query results to files
- [ ] Handle database errors gracefully

### **Practice:**
- [ ] Complete all 4 exercises
- [ ] Build ETL pipeline
- [ ] Implement CRUD application
- [ ] Handle real-world data scenarios

---

## 🚀 Next Steps

### **After This Lesson:**

1. **Move to Lesson 4: Object-Oriented Programming**
   - Apply database concepts to OOP
   - Build repository pattern
   - Create data access layers

2. **Build Projects:**
   - ETL pipeline with database source
   - Database-backed API
   - Data sync application
   - Database migration tool

3. **Advanced Topics:**
   - Database migrations with Alembic
   - Async database connections
   - Query optimization
   - Database testing strategies

---

## 📚 Additional Resources

**Official Documentation:**
- [psycopg2 Documentation](https://www.psycopg.org/docs/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [pandas SQL Documentation](https://pandas.pydata.org/docs/user_guide/io.html#sql-queries)

**Recommended Reading:**
- "Essential SQLAlchemy" by Jason Myers
- "SQL for Data Analysis" by Cathy Tanimura

---

## 🎉 Congratulations!

You've mastered database connectivity with Python! You can now build complete data pipelines connecting Python to databases.

**You now know:**
- Safe database querying with parameterized queries
- Transaction management
- SQLAlchemy Core and ORM
- Connection pooling for production
- pandas database integration

**Remember:**
- Always parameterize queries
- Use connection pooling in production
- Choose the right tool for the job
- Handle errors gracefully

**Keep coding, keep learning!** 🚀

---

**Ready to connect?**  
**→ [Open 03_database_connectivity.md](03_database_connectivity.md) and master database connectivity!**

---

*Last Updated: October 20, 2025*  
*Total Content: 2,850 lines of comprehensive instruction*  
*Database: PostgreSQL with SQLAlchemy*

