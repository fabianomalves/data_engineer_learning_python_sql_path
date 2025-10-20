# Data Engineer Cheatsheet

Quick reference for common Python and SQL operations used in data engineering.

## Python Basics

### Variables and Data Types
```python
# Numbers
integer = 42
floating = 3.14
complex_num = 3 + 4j

# Strings
text = "Hello"
multi_line = """Multiple
lines"""

# Boolean
is_true = True
is_false = False

# None
empty = None
```

### Lists
```python
# Create
my_list = [1, 2, 3, 4, 5]
mixed = [1, "two", 3.0, True]

# Access
first = my_list[0]
last = my_list[-1]
slice = my_list[1:4]  # [2, 3, 4]

# Modify
my_list.append(6)      # Add to end
my_list.insert(0, 0)   # Insert at position
my_list.remove(3)      # Remove first occurrence
popped = my_list.pop() # Remove and return last

# Common operations
length = len(my_list)
sorted_list = sorted(my_list)
reversed_list = list(reversed(my_list))
```

### Dictionaries
```python
# Create
person = {"name": "Alice", "age": 30, "city": "NYC"}

# Access
name = person["name"]
age = person.get("age", 0)  # With default

# Modify
person["email"] = "alice@example.com"
person.update({"phone": "123-456-7890"})

# Iterate
for key, value in person.items():
    print(f"{key}: {value}")
```

### Control Flow
```python
# If-else
if x > 0:
    print("Positive")
elif x < 0:
    print("Negative")
else:
    print("Zero")

# For loop
for i in range(5):
    print(i)

for item in my_list:
    print(item)

# While loop
while x > 0:
    x -= 1

# List comprehension
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
```

### Functions
```python
# Basic function
def greet(name):
    return f"Hello, {name}!"

# Default arguments
def greet(name="World"):
    return f"Hello, {name}!"

# Multiple return values
def stats(numbers):
    return min(numbers), max(numbers), sum(numbers)

# Lambda function
square = lambda x: x**2
```

## Pandas

### DataFrame Creation
```python
import pandas as pd

# From dictionary
df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': [4, 5, 6]
})

# From CSV
df = pd.read_csv('file.csv')

# From SQL
df = pd.read_sql('SELECT * FROM table', connection)
```

### Data Selection
```python
# Columns
df['column_name']
df[['col1', 'col2']]

# Rows
df.iloc[0]        # By position
df.loc[0]         # By label
df.iloc[0:5]      # First 5 rows
df.head(10)       # First 10 rows
df.tail(10)       # Last 10 rows

# Conditional
df[df['age'] > 30]
df[(df['age'] > 30) & (df['city'] == 'NYC')]
```

### Data Manipulation
```python
# Add column
df['new_col'] = df['col1'] + df['col2']

# Drop column
df = df.drop('column_name', axis=1)

# Rename
df = df.rename(columns={'old': 'new'})

# Sort
df = df.sort_values('column_name')
df = df.sort_values(['col1', 'col2'], ascending=[True, False])

# Group by
grouped = df.groupby('category')['value'].sum()
grouped = df.groupby('category').agg({
    'value': ['sum', 'mean', 'count']
})
```

### Data Cleaning
```python
# Handle missing values
df.isnull().sum()              # Count nulls
df = df.dropna()               # Drop rows with nulls
df = df.fillna(0)              # Fill with value
df = df.fillna(df.mean())      # Fill with mean

# Remove duplicates
df = df.drop_duplicates()
df = df.drop_duplicates(subset=['column'])

# Data types
df.dtypes                      # Check types
df['col'] = df['col'].astype(int)  # Convert type
```

### Merging DataFrames
```python
# Merge (SQL-like joins)
merged = pd.merge(df1, df2, on='key')
merged = pd.merge(df1, df2, on='key', how='left')

# Concat (append)
combined = pd.concat([df1, df2], axis=0)  # Rows
combined = pd.concat([df1, df2], axis=1)  # Columns
```

## SQL

### Basic Queries
```sql
-- Select
SELECT column1, column2 FROM table;
SELECT * FROM table;
SELECT DISTINCT city FROM customers;

-- Where
SELECT * FROM table WHERE age > 25;
SELECT * FROM table WHERE age > 25 AND city = 'NYC';
SELECT * FROM table WHERE age BETWEEN 20 AND 30;
SELECT * FROM table WHERE city IN ('NYC', 'LA', 'SF');
SELECT * FROM table WHERE name LIKE 'A%';

-- Order By
SELECT * FROM table ORDER BY age DESC;
SELECT * FROM table ORDER BY age, name;

-- Limit
SELECT * FROM table LIMIT 10;
SELECT * FROM table LIMIT 10 OFFSET 20;
```

### Joins
```sql
-- Inner Join
SELECT a.*, b.name 
FROM orders a
INNER JOIN customers b ON a.customer_id = b.id;

-- Left Join
SELECT a.*, b.name 
FROM orders a
LEFT JOIN customers b ON a.customer_id = b.id;

-- Multiple Joins
SELECT o.order_id, c.name, p.product_name
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN products p ON o.product_id = p.id;
```

### Aggregations
```sql
-- Basic aggregates
SELECT COUNT(*) FROM table;
SELECT SUM(amount) FROM orders;
SELECT AVG(salary) FROM employees;
SELECT MIN(price), MAX(price) FROM products;

-- Group By
SELECT city, COUNT(*) as count
FROM customers
GROUP BY city;

SELECT department, AVG(salary) as avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 50000;
```

### Subqueries
```sql
-- In WHERE clause
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- In FROM clause
SELECT dept, avg_sal
FROM (
    SELECT department as dept, AVG(salary) as avg_sal
    FROM employees
    GROUP BY department
) subquery
WHERE avg_sal > 60000;
```

### Window Functions
```sql
-- Running total
SELECT date, amount,
    SUM(amount) OVER (ORDER BY date) as running_total
FROM sales;

-- Ranking
SELECT name, salary,
    RANK() OVER (ORDER BY salary DESC) as rank
FROM employees;

-- Partition
SELECT department, name, salary,
    AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees;
```

### Data Modification
```sql
-- Insert
INSERT INTO table (col1, col2) VALUES (val1, val2);
INSERT INTO table VALUES (val1, val2, val3);

-- Update
UPDATE table SET col1 = val1 WHERE condition;

-- Delete
DELETE FROM table WHERE condition;

-- Create Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Database Operations in Python

### SQLAlchemy
```python
from sqlalchemy import create_engine

# Connect
engine = create_engine('postgresql://user:pass@localhost/db')

# Read
df = pd.read_sql('SELECT * FROM table', engine)
df = pd.read_sql_table('table_name', engine)
df = pd.read_sql_query('SELECT * FROM table WHERE x > 5', engine)

# Write
df.to_sql('table_name', engine, if_exists='replace', index=False)
# if_exists: 'fail', 'replace', 'append'
```

### Psycopg2 (PostgreSQL)
```python
import psycopg2

# Connect
conn = psycopg2.connect(
    host="localhost",
    database="mydb",
    user="user",
    password="password"
)

# Execute
cursor = conn.cursor()
cursor.execute("SELECT * FROM table")
rows = cursor.fetchall()

# With parameters
cursor.execute("SELECT * FROM table WHERE id = %s", (id,))

# Commit and close
conn.commit()
cursor.close()
conn.close()
```

## File Operations

### CSV
```python
# Read
df = pd.read_csv('file.csv')
df = pd.read_csv('file.csv', sep=';', encoding='utf-8')

# Write
df.to_csv('output.csv', index=False)
df.to_csv('output.csv', sep='\t', encoding='utf-8')
```

### JSON
```python
# Read
df = pd.read_json('file.json')
df = pd.read_json('file.json', orient='records')

# Write
df.to_json('output.json', orient='records', indent=2)
```

### Excel
```python
# Read
df = pd.read_excel('file.xlsx', sheet_name='Sheet1')

# Write
df.to_excel('output.xlsx', sheet_name='Data', index=False)

# Multiple sheets
with pd.ExcelWriter('output.xlsx') as writer:
    df1.to_excel(writer, sheet_name='Sheet1')
    df2.to_excel(writer, sheet_name='Sheet2')
```

### Parquet
```python
# Read
df = pd.read_parquet('file.parquet')

# Write
df.to_parquet('output.parquet', compression='snappy')
```

## Date/Time Operations

### Python datetime
```python
from datetime import datetime, timedelta

# Current
now = datetime.now()
today = datetime.today()

# Create
dt = datetime(2024, 1, 15, 10, 30)

# Parse
dt = datetime.strptime('2024-01-15', '%Y-%m-%d')

# Format
formatted = dt.strftime('%Y-%m-%d %H:%M:%S')

# Arithmetic
tomorrow = now + timedelta(days=1)
last_week = now - timedelta(weeks=1)
```

### Pandas datetime
```python
# Convert to datetime
df['date'] = pd.to_datetime(df['date_string'])

# Extract components
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day
df['dayofweek'] = df['date'].dt.dayofweek

# Date arithmetic
df['next_week'] = df['date'] + pd.Timedelta(weeks=1)

# Resample (time series)
df.set_index('date').resample('D').mean()  # Daily average
df.set_index('date').resample('M').sum()   # Monthly sum
```

## Common Patterns

### ETL Pattern
```python
def extract_data(source):
    """Extract data from source"""
    return pd.read_csv(source)

def transform_data(df):
    """Clean and transform data"""
    df = df.dropna()
    df['new_col'] = df['col1'] + df['col2']
    return df

def load_data(df, target):
    """Load data to target"""
    df.to_sql('table', engine, if_exists='replace')

# Run ETL
df = extract_data('input.csv')
df = transform_data(df)
load_data(df, 'output_table')
```

### Error Handling
```python
try:
    df = pd.read_csv('file.csv')
except FileNotFoundError:
    print("File not found")
except pd.errors.ParserError:
    print("Error parsing CSV")
except Exception as e:
    print(f"Unexpected error: {e}")
finally:
    print("Cleanup")
```

### Logging
```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

logger.info("Processing started")
logger.warning("Warning message")
logger.error("Error occurred")
```

## Git Commands

```bash
# Clone
git clone <url>

# Status
git status

# Add files
git add file.py
git add .

# Commit
git commit -m "Message"

# Push
git push origin branch_name

# Pull
git pull origin branch_name

# Branch
git branch new_branch
git checkout new_branch
git checkout -b new_branch  # Create and switch

# Merge
git merge branch_name

# View history
git log
git log --oneline
```

## Docker Commands

```bash
# Build
docker build -t myapp .

# Run
docker run myapp
docker run -p 5000:5000 myapp
docker run -d myapp  # Detached

# List
docker ps        # Running
docker ps -a     # All

# Stop/Start
docker stop container_id
docker start container_id

# Remove
docker rm container_id
docker rmi image_id

# Docker Compose
docker-compose up
docker-compose up -d
docker-compose down
docker-compose logs
```

---

This cheatsheet covers the most common operations. Bookmark it for quick reference!
