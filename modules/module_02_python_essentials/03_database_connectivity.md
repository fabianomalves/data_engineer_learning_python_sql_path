# Lesson 3: Database Connectivity with Python

**Duration**: 3 hours  
**Prerequisites**: Lesson 1 & 2, Module 1 (SQL Fundamentals)  
**Goal**: Master database connections, queries, and data integration with Python

---

## 📋 **What You'll Learn**

By the end of this lesson, you will:

✅ Connect to PostgreSQL databases with `psycopg2`  
✅ Execute SQL queries from Python  
✅ Handle query results and convert to Python data structures  
✅ Use parameterized queries to prevent SQL injection  
✅ Manage database transactions (commit, rollback)  
✅ Work with SQLAlchemy ORM for easier database operations  
✅ Create connection pools for production applications  
✅ Integrate databases with pandas DataFrames  
✅ Handle database errors gracefully  
✅ Export query results to CSV, JSON, and Parquet  

---

## 🗂️ **Table of Contents**

1. [PostgreSQL with psycopg2](#1-postgresql-with-psycopg2)
2. [SQLAlchemy Core](#2-sqlalchemy-core)
3. [SQLAlchemy ORM](#3-sqlalchemy-orm)
4. [Database Connection Pools](#4-database-connection-pools)
5. [pandas Database Integration](#5-pandas-database-integration)
6. [Practice Exercises](#6-practice-exercises)

---

## 1. PostgreSQL with psycopg2

### What is psycopg2?

**psycopg2** is the most popular PostgreSQL adapter for Python. It allows you to connect to PostgreSQL databases, execute SQL queries, and retrieve results.

### Why Use psycopg2?

✅ **Industry Standard** - Most widely used PostgreSQL adapter  
✅ **Fast** - Written in C for performance  
✅ **Reliable** - Battle-tested in production  
✅ **Full-Featured** - Supports all PostgreSQL features  
✅ **DB-API 2.0 Compliant** - Standard Python database interface  

### Installing psycopg2

```bash
# Install psycopg2 (binary version, easiest)
pip install psycopg2-binary

# Or install from source (requires PostgreSQL dev libraries)
pip install psycopg2
```

### Database Connection Basics

```python
import psycopg2
from psycopg2 import sql

# ---------- BASIC CONNECTION ----------

# Connection parameters
conn_params = {
    'host': 'localhost',        # Database server address
    'port': 5432,               # PostgreSQL default port
    'database': 'camping_db',   # Database name
    'user': 'postgres',         # Username
    'password': 'your_password' # Password
}

# Connect to database
conn = psycopg2.connect(**conn_params)
print("✅ Connected to database!")

# Create cursor (used to execute queries)
cursor = conn.cursor()

# Execute a simple query
cursor.execute("SELECT version();")

# Fetch result
result = cursor.fetchone()
print(f"PostgreSQL version: {result[0]}")

# Close cursor and connection
cursor.close()
conn.close()
print("🔌 Disconnected from database")
```

### Using Context Managers (Best Practice!)

```python
import psycopg2
from contextlib import contextmanager

# ---------- CONNECTION WITH CONTEXT MANAGER ----------

conn_params = {
    'host': 'localhost',
    'port': 5432,
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

# Connect using 'with' (automatically closes connection)
with psycopg2.connect(**conn_params) as conn:
    with conn.cursor() as cursor:
        cursor.execute("SELECT version();")
        result = cursor.fetchone()
        print(f"PostgreSQL version: {result[0]}")
# Connection and cursor automatically closed here!


# ---------- CUSTOM CONNECTION MANAGER ----------

@contextmanager
def get_db_connection(conn_params: dict):
    """Context manager for database connections.
    
    Args:
        conn_params: Dictionary with connection parameters
        
    Yields:
        Database connection object
    """
    conn = None
    try:
        # Connect to database
        conn = psycopg2.connect(**conn_params)
        print("✅ Connected to database")
        yield conn
    except psycopg2.Error as e:
        print(f"❌ Database error: {e}")
        if conn:
            conn.rollback()  # Rollback on error
        raise
    finally:
        if conn:
            conn.close()
            print("🔌 Disconnected from database")

# Use it
with get_db_connection(conn_params) as conn:
    with conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM campsites;")
        count = cursor.fetchone()[0]
        print(f"Total campsites: {count}")
```

### Executing SELECT Queries

```python
import psycopg2

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

with psycopg2.connect(**conn_params) as conn:
    with conn.cursor() as cursor:
        
        # ---------- FETCH ONE ROW ----------
        
        cursor.execute("SELECT id, name, state FROM campsites LIMIT 1;")
        row = cursor.fetchone()  # Returns tuple or None
        
        if row:
            print(f"ID: {row[0]}, Name: {row[1]}, State: {row[2]}")
        # Output: ID: 1, Name: Camping Vale do Pati, State: BA
        
        
        # ---------- FETCH ALL ROWS ----------
        
        cursor.execute("SELECT id, name, state FROM campsites LIMIT 5;")
        rows = cursor.fetchall()  # Returns list of tuples
        
        for row in rows:
            print(f"ID: {row[0]}, Name: {row[1]}, State: {row[2]}")
        # Output:
        # ID: 1, Name: Camping Vale do Pati, State: BA
        # ID: 2, Name: Serra dos Órgãos, State: RJ
        # ...
        
        
        # ---------- FETCH MANY ROWS ----------
        
        cursor.execute("SELECT id, name FROM campsites;")
        
        # Fetch in batches (memory efficient for large results)
        while True:
            rows = cursor.fetchmany(100)  # Fetch 100 rows at a time
            if not rows:
                break
            
            for row in rows:
                print(f"ID: {row[0]}, Name: {row[1]}")
        
        
        # ---------- ITERATE OVER RESULTS ----------
        
        cursor.execute("SELECT name, price FROM campsites;")
        
        # Cursor is iterable!
        for row in cursor:
            name, price = row
            print(f"{name}: R${price:.2f}")
```

### Using DictCursor (Column Names as Keys)

```python
import psycopg2
from psycopg2.extras import DictCursor

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

with psycopg2.connect(**conn_params) as conn:
    # Use DictCursor to get results as dictionaries
    with conn.cursor(cursor_factory=DictCursor) as cursor:
        
        cursor.execute("SELECT id, name, state, price FROM campsites LIMIT 3;")
        
        rows = cursor.fetchall()
        
        for row in rows:
            # Access by column name (like a dictionary)
            print(f"ID: {row['id']}")
            print(f"Name: {row['name']}")
            print(f"State: {row['state']}")
            print(f"Price: R${row['price']:.2f}")
            print("-" * 40)
        
        # Convert to regular dict if needed
        cursor.execute("SELECT name, price FROM campsites WHERE state = 'BA';")
        rows = cursor.fetchall()
        
        campsites = [dict(row) for row in rows]
        print(campsites)
        # [
        #     {'name': 'Camping Vale do Pati', 'price': 120.0},
        #     {'name': 'Cachoeira Camp', 'price': 95.0}
        # ]
```

### Parameterized Queries (Prevent SQL Injection!)

```python
import psycopg2

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

# ❌ NEVER DO THIS (SQL Injection vulnerability!)
state = "BA"
cursor.execute(f"SELECT * FROM campsites WHERE state = '{state}';")

# A malicious user could set state = "BA'; DROP TABLE campsites; --"
# This would delete your entire table!


# ✅ ALWAYS USE PARAMETERIZED QUERIES

with psycopg2.connect(**conn_params) as conn:
    with conn.cursor() as cursor:
        
        # ---------- METHOD 1: %s Placeholders (Recommended) ----------
        
        state = "BA"
        cursor.execute(
            "SELECT id, name, price FROM campsites WHERE state = %s;",
            (state,)  # Note: tuple with one element needs comma
        )
        
        rows = cursor.fetchall()
        print(f"Found {len(rows)} campsites in {state}")
        
        
        # ---------- METHOD 2: Named Parameters (%(name)s) ----------
        
        cursor.execute(
            """
            SELECT id, name, price 
            FROM campsites 
            WHERE state = %(state)s 
              AND price <= %(max_price)s
            """,
            {'state': 'BA', 'max_price': 100.00}
        )
        
        rows = cursor.fetchall()
        for row in rows:
            print(f"{row[1]}: R${row[2]:.2f}")
        
        
        # ---------- METHOD 3: Multiple Values ----------
        
        states = ['BA', 'RJ', 'MG']
        cursor.execute(
            "SELECT state, COUNT(*) FROM campsites WHERE state = ANY(%s) GROUP BY state;",
            (states,)
        )
        
        for row in cursor:
            print(f"{row[0]}: {row[1]} campsites")
        
        
        # ---------- METHOD 4: IN Clause ----------
        
        # Generate placeholders dynamically
        states = ['BA', 'RJ', 'MG']
        placeholders = ', '.join(['%s'] * len(states))
        
        query = f"SELECT name, state FROM campsites WHERE state IN ({placeholders});"
        cursor.execute(query, states)
        
        for row in cursor:
            print(f"{row[0]} ({row[1]})")
```

### Executing INSERT, UPDATE, DELETE

```python
import psycopg2
from datetime import datetime

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

with psycopg2.connect(**conn_params) as conn:
    with conn.cursor() as cursor:
        
        # ---------- INSERT SINGLE ROW ----------
        
        cursor.execute(
            """
            INSERT INTO campsites (name, state, city, price, capacity, description)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id;
            """,
            (
                'Novo Camping',
                'SP',
                'São Paulo',
                85.00,
                20,
                'Camping próximo à capital'
            )
        )
        
        # Get the generated ID
        new_id = cursor.fetchone()[0]
        print(f"✅ Inserted campsite with ID: {new_id}")
        
        # Commit the transaction
        conn.commit()
        
        
        # ---------- INSERT MULTIPLE ROWS ----------
        
        campsites_data = [
            ('Camping A', 'BA', 'Salvador', 90.00, 25),
            ('Camping B', 'RJ', 'Rio de Janeiro', 110.00, 30),
            ('Camping C', 'MG', 'Belo Horizonte', 75.00, 15)
        ]
        
        cursor.executemany(
            """
            INSERT INTO campsites (name, state, city, price, capacity)
            VALUES (%s, %s, %s, %s, %s);
            """,
            campsites_data
        )
        
        print(f"✅ Inserted {cursor.rowcount} campsites")
        conn.commit()
        
        
        # ---------- UPDATE ----------
        
        cursor.execute(
            """
            UPDATE campsites 
            SET price = %s, updated_at = %s
            WHERE state = %s AND price < %s;
            """,
            (100.00, datetime.now(), 'BA', 80.00)
        )
        
        print(f"✅ Updated {cursor.rowcount} campsites")
        conn.commit()
        
        
        # ---------- DELETE ----------
        
        cursor.execute(
            "DELETE FROM campsites WHERE capacity < %s;",
            (10,)
        )
        
        print(f"✅ Deleted {cursor.rowcount} campsites")
        conn.commit()
```

### Transaction Management

```python
import psycopg2

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

# ---------- EXPLICIT TRANSACTION CONTROL ----------

conn = psycopg2.connect(**conn_params)
cursor = conn.cursor()

try:
    # Start transaction (implicit with first query)
    
    # Insert customer
    cursor.execute(
        """
        INSERT INTO customers (name, email, phone)
        VALUES (%s, %s, %s)
        RETURNING id;
        """,
        ('João Silva', 'joao@example.com', '11999998888')
    )
    customer_id = cursor.fetchone()[0]
    
    # Insert booking
    cursor.execute(
        """
        INSERT INTO bookings (customer_id, campsite_id, check_in, check_out, guests)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING id;
        """,
        (customer_id, 1, '2024-07-15', '2024-07-18', 4)
    )
    booking_id = cursor.fetchone()[0]
    
    # Update campsite availability
    cursor.execute(
        "UPDATE campsites SET available_spots = available_spots - 1 WHERE id = %s;",
        (1,)
    )
    
    # If everything succeeded, commit
    conn.commit()
    print(f"✅ Transaction successful! Booking ID: {booking_id}")
    
except psycopg2.Error as e:
    # If any error, rollback all changes
    conn.rollback()
    print(f"❌ Transaction failed: {e}")
    print("↩️  All changes rolled back")

finally:
    cursor.close()
    conn.close()


# ---------- USING SAVEPOINTS ----------

with psycopg2.connect(**conn_params) as conn:
    with conn.cursor() as cursor:
        
        try:
            # Insert first campsite
            cursor.execute(
                "INSERT INTO campsites (name, state, price) VALUES (%s, %s, %s);",
                ('Camp A', 'BA', 100.00)
            )
            
            # Create savepoint
            cursor.execute("SAVEPOINT sp1;")
            
            try:
                # Try to insert second campsite (might fail)
                cursor.execute(
                    "INSERT INTO campsites (name, state, price) VALUES (%s, %s, %s);",
                    ('Camp B', 'XX', 'invalid')  # Will fail: invalid price
                )
            except psycopg2.Error:
                # Rollback to savepoint (keeps first insert)
                cursor.execute("ROLLBACK TO SAVEPOINT sp1;")
                print("⚠️  Second insert failed, rolled back to savepoint")
            
            # Commit transaction (first insert is saved)
            conn.commit()
            print("✅ First insert committed")
            
        except psycopg2.Error as e:
            conn.rollback()
            print(f"❌ Transaction failed: {e}")
```

### Error Handling

```python
import psycopg2
from psycopg2 import errorcodes

conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

# ---------- HANDLING SPECIFIC ERRORS ----------

try:
    with psycopg2.connect(**conn_params) as conn:
        with conn.cursor() as cursor:
            
            # Try to insert duplicate ID (will fail if ID exists)
            cursor.execute(
                "INSERT INTO campsites (id, name, state) VALUES (%s, %s, %s);",
                (1, 'Duplicate Camp', 'BA')
            )
            conn.commit()

except psycopg2.IntegrityError as e:
    # Violation of unique constraint, foreign key, etc.
    print(f"❌ Integrity Error: {e}")
    print(f"Error code: {e.pgcode}")
    
    if e.pgcode == errorcodes.UNIQUE_VIOLATION:
        print("This record already exists!")
    elif e.pgcode == errorcodes.FOREIGN_KEY_VIOLATION:
        print("Foreign key constraint violated!")

except psycopg2.DataError as e:
    # Invalid data type, value out of range, etc.
    print(f"❌ Data Error: {e}")

except psycopg2.OperationalError as e:
    # Connection failure, database doesn't exist, etc.
    print(f"❌ Operational Error: {e}")
    print("Check your connection parameters!")

except psycopg2.ProgrammingError as e:
    # SQL syntax error, table doesn't exist, etc.
    print(f"❌ Programming Error: {e}")
    print("Check your SQL syntax!")

except psycopg2.Error as e:
    # Catch all other psycopg2 errors
    print(f"❌ Database Error: {e}")


# ---------- COMPREHENSIVE ERROR HANDLER ----------

def execute_query_safe(conn_params: dict, query: str, params: tuple = None):
    """Execute query with comprehensive error handling.
    
    Args:
        conn_params: Database connection parameters
        query: SQL query to execute
        params: Query parameters (optional)
        
    Returns:
        Query results or None on error
    """
    try:
        with psycopg2.connect(**conn_params) as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                
                # Check if query returns results
                if cursor.description:
                    return cursor.fetchall()
                else:
                    conn.commit()
                    return cursor.rowcount
    
    except psycopg2.OperationalError as e:
        print(f"❌ Connection Error: Could not connect to database")
        print(f"   Details: {e}")
        return None
    
    except psycopg2.ProgrammingError as e:
        print(f"❌ SQL Error: Problem with your query")
        print(f"   Query: {query}")
        print(f"   Details: {e}")
        return None
    
    except psycopg2.IntegrityError as e:
        print(f"❌ Integrity Error: Constraint violation")
        print(f"   Details: {e}")
        return None
    
    except psycopg2.Error as e:
        print(f"❌ Database Error: {e}")
        return None
    
    except Exception as e:
        print(f"❌ Unexpected Error: {type(e).__name__}: {e}")
        return None

# Use it
results = execute_query_safe(
    conn_params,
    "SELECT name, price FROM campsites WHERE state = %s;",
    ('BA',)
)

if results:
    for row in results:
        print(f"{row[0]}: R${row[1]:.2f}")
```

### Real-World Example: Campsite Search API

```python
import psycopg2
from psycopg2.extras import RealDictCursor
from typing import List, Dict, Optional

class CampsiteDatabase:
    """Database interface for campsite operations."""
    
    def __init__(self, conn_params: dict):
        """Initialize with connection parameters."""
        self.conn_params = conn_params
    
    def search_campsites(
        self,
        state: Optional[str] = None,
        max_price: Optional[float] = None,
        min_capacity: Optional[int] = None,
        amenities: Optional[List[str]] = None
    ) -> List[Dict]:
        """Search campsites with filters.
        
        Args:
            state: Filter by state (e.g., 'BA', 'RJ')
            max_price: Maximum price per night
            min_capacity: Minimum capacity
            amenities: Required amenities
            
        Returns:
            List of campsite dictionaries
        """
        # Build query dynamically based on filters
        conditions = []
        params = {}
        
        base_query = """
            SELECT 
                c.id,
                c.name,
                c.state,
                c.city,
                c.price,
                c.capacity,
                c.description,
                COALESCE(AVG(r.rating), 0) as avg_rating,
                COUNT(r.id) as review_count
            FROM campsites c
            LEFT JOIN reviews r ON c.id = r.campsite_id
        """
        
        # Add filters
        if state:
            conditions.append("c.state = %(state)s")
            params['state'] = state
        
        if max_price:
            conditions.append("c.price <= %(max_price)s")
            params['max_price'] = max_price
        
        if min_capacity:
            conditions.append("c.capacity >= %(min_capacity)s")
            params['min_capacity'] = min_capacity
        
        if amenities:
            conditions.append("c.amenities @> %(amenities)s::jsonb")
            params['amenities'] = amenities
        
        # Combine query
        if conditions:
            base_query += " WHERE " + " AND ".join(conditions)
        
        base_query += """
            GROUP BY c.id, c.name, c.state, c.city, c.price, c.capacity, c.description
            ORDER BY avg_rating DESC, c.price ASC
        """
        
        # Execute query
        try:
            with psycopg2.connect(**self.conn_params) as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute(base_query, params)
                    results = cursor.fetchall()
                    return [dict(row) for row in results]
        
        except psycopg2.Error as e:
            print(f"❌ Database error: {e}")
            return []
    
    def get_campsite_details(self, campsite_id: int) -> Optional[Dict]:
        """Get full details for a campsite.
        
        Args:
            campsite_id: Campsite ID
            
        Returns:
            Campsite details dictionary or None
        """
        query = """
            SELECT 
                c.*,
                COALESCE(AVG(r.rating), 0) as avg_rating,
                COUNT(r.id) as review_count,
                json_agg(
                    json_build_object(
                        'customer', r.customer_name,
                        'rating', r.rating,
                        'comment', r.comment,
                        'date', r.created_at
                    )
                ) FILTER (WHERE r.id IS NOT NULL) as reviews
            FROM campsites c
            LEFT JOIN reviews r ON c.id = r.campsite_id
            WHERE c.id = %(id)s
            GROUP BY c.id
        """
        
        try:
            with psycopg2.connect(**self.conn_params) as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute(query, {'id': campsite_id})
                    result = cursor.fetchone()
                    return dict(result) if result else None
        
        except psycopg2.Error as e:
            print(f"❌ Database error: {e}")
            return None

# Use it
conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

db = CampsiteDatabase(conn_params)

# Search campsites in Bahia under R$100
print("🔍 Searching campsites in BA under R$100...\n")
campsites = db.search_campsites(state='BA', max_price=100.00)

for campsite in campsites:
    print(f"📍 {campsite['name']} ({campsite['city']}, {campsite['state']})")
    print(f"   💰 R${campsite['price']:.2f}/night")
    print(f"   👥 Capacity: {campsite['capacity']}")
    print(f"   ⭐ Rating: {campsite['avg_rating']:.1f} ({campsite['review_count']} reviews)")
    print()

# Get details for specific campsite
print("\n📋 Campsite Details:\n")
details = db.get_campsite_details(1)
if details:
    print(f"Name: {details['name']}")
    print(f"Description: {details['description']}")
    print(f"Average Rating: {details['avg_rating']:.1f}")
    print(f"Total Reviews: {details['review_count']}")
```

---

## 2. SQLAlchemy Core

### What is SQLAlchemy?

**SQLAlchemy** is Python's most popular SQL toolkit and Object-Relational Mapper (ORM). It provides two main interfaces:
- **SQLAlchemy Core**: Expression Language for building SQL queries in Python
- **SQLAlchemy ORM**: Map Python classes to database tables

### Why Use SQLAlchemy?

✅ **Database Agnostic** - Works with PostgreSQL, MySQL, SQLite, Oracle, etc.  
✅ **More Pythonic** - Write SQL using Python syntax  
✅ **Type Safety** - Catch errors before runtime  
✅ **Connection Pooling** - Built-in connection management  
✅ **ORM Support** - Map tables to Python classes  
✅ **Migration Tools** - Works with Alembic for schema changes  

### Installing SQLAlchemy

```bash
# Install SQLAlchemy
pip install sqlalchemy

# With PostgreSQL driver
pip install sqlalchemy psycopg2-binary
```

### Creating an Engine (Connection Factory)

```python
from sqlalchemy import create_engine
from sqlalchemy.pool import NullPool, QueuePool

# ---------- BASIC ENGINE CREATION ----------

# Connection string format:
# dialect+driver://username:password@host:port/database

# PostgreSQL
engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# SQLite (for development/testing)
engine = create_engine('sqlite:///camping.db')

# MySQL
engine = create_engine('mysql+pymysql://user:password@localhost/camping_db')


# ---------- ENGINE WITH OPTIONS ----------

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db',
    echo=True,              # Print all SQL statements (debugging)
    pool_size=5,            # Number of connections in pool
    max_overflow=10,        # Additional connections if pool exhausted
    pool_timeout=30,        # Seconds to wait for connection
    pool_recycle=3600,      # Recycle connections after 1 hour
)

# Test connection
with engine.connect() as conn:
    result = conn.execute("SELECT version();")
    print(result.fetchone())
```

### Executing Raw SQL with SQLAlchemy

```python
from sqlalchemy import create_engine, text

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# ---------- BASIC QUERY EXECUTION ----------

with engine.connect() as conn:
    # Execute raw SQL with text()
    result = conn.execute(text("SELECT id, name, state FROM campsites LIMIT 5;"))
    
    # Fetch results
    for row in result:
        print(f"ID: {row.id}, Name: {row.name}, State: {row.state}")
        # or: row[0], row[1], row[2]
        # or: row['id'], row['name'], row['state']


# ---------- PARAMETERIZED QUERIES ----------

with engine.connect() as conn:
    # Named parameters with :param syntax
    result = conn.execute(
        text("SELECT name, price FROM campsites WHERE state = :state"),
        {"state": "BA"}
    )
    
    for row in result:
        print(f"{row.name}: R${row.price:.2f}")


# ---------- INSERT/UPDATE/DELETE ----------

with engine.connect() as conn:
    # INSERT
    result = conn.execute(
        text("""
            INSERT INTO campsites (name, state, price)
            VALUES (:name, :state, :price)
            RETURNING id;
        """),
        {"name": "Novo Camp", "state": "SP", "price": 85.00}
    )
    
    new_id = result.fetchone()[0]
    print(f"✅ Inserted campsite ID: {new_id}")
    
    # Must commit!
    conn.commit()
```

### SQLAlchemy Expression Language

More Pythonic way to build queries without raw SQL strings:

```python
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Float, select

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# ---------- DEFINE TABLE STRUCTURE ----------

metadata = MetaData()

# Define campsites table structure
campsites = Table(
    'campsites',
    metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String(100)),
    Column('state', String(2)),
    Column('city', String(100)),
    Column('price', Float),
    Column('capacity', Integer)
)

# ---------- SELECT QUERIES ----------

with engine.connect() as conn:
    # SELECT * FROM campsites
    query = select(campsites)
    result = conn.execute(query)
    
    for row in result:
        print(f"{row.name} ({row.state}): R${row.price:.2f}")
    
    
    # SELECT specific columns
    query = select(campsites.c.name, campsites.c.price)
    result = conn.execute(query)
    
    for row in result:
        print(f"{row.name}: R${row.price:.2f}")
    
    
    # WHERE clause
    query = select(campsites).where(campsites.c.state == 'BA')
    result = conn.execute(query)
    
    print(f"\nCampsites in BA:")
    for row in result:
        print(f"  {row.name}")
    
    
    # Multiple WHERE conditions (AND)
    query = select(campsites).where(
        campsites.c.state == 'BA',
        campsites.c.price <= 100.00
    )
    result = conn.execute(query)
    
    print(f"\nAffordable campsites in BA:")
    for row in result:
        print(f"  {row.name}: R${row.price:.2f}")
    
    
    # OR conditions
    from sqlalchemy import or_
    
    query = select(campsites).where(
        or_(
            campsites.c.state == 'BA',
            campsites.c.state == 'RJ'
        )
    )
    
    
    # LIKE pattern matching
    query = select(campsites).where(
        campsites.c.name.like('%Serra%')
    )
    
    
    # IN clause
    query = select(campsites).where(
        campsites.c.state.in_(['BA', 'RJ', 'MG'])
    )
    
    
    # ORDER BY
    query = select(campsites).order_by(
        campsites.c.price.desc(),
        campsites.c.name
    )
    
    
    # LIMIT and OFFSET
    query = select(campsites).limit(10).offset(20)
```

### INSERT, UPDATE, DELETE with Expression Language

```python
from sqlalchemy import insert, update, delete

with engine.connect() as conn:
    
    # ---------- INSERT ----------
    
    stmt = insert(campsites).values(
        name='Express Camp',
        state='SP',
        city='São Paulo',
        price=90.00,
        capacity=25
    )
    
    result = conn.execute(stmt)
    conn.commit()
    print(f"✅ Inserted {result.rowcount} row(s)")
    
    
    # INSERT multiple rows
    stmt = insert(campsites)
    conn.execute(stmt, [
        {'name': 'Camp A', 'state': 'BA', 'price': 80.00, 'capacity': 20},
        {'name': 'Camp B', 'state': 'RJ', 'price': 95.00, 'capacity': 30},
        {'name': 'Camp C', 'state': 'MG', 'price': 75.00, 'capacity': 15}
    ])
    conn.commit()
    
    
    # ---------- UPDATE ----------
    
    stmt = update(campsites).where(
        campsites.c.state == 'BA'
    ).values(
        price=campsites.c.price * 1.1  # 10% increase
    )
    
    result = conn.execute(stmt)
    conn.commit()
    print(f"✅ Updated {result.rowcount} row(s)")
    
    
    # ---------- DELETE ----------
    
    stmt = delete(campsites).where(
        campsites.c.capacity < 10
    )
    
    result = conn.execute(stmt)
    conn.commit()
    print(f"✅ Deleted {result.rowcount} row(s)")
```

### Aggregations and GROUP BY

```python
from sqlalchemy import func, select

with engine.connect() as conn:
    
    # COUNT
    query = select(func.count()).select_from(campsites)
    total = conn.execute(query).scalar()
    print(f"Total campsites: {total}")
    
    
    # AVG, MIN, MAX
    query = select(
        func.avg(campsites.c.price).label('avg_price'),
        func.min(campsites.c.price).label('min_price'),
        func.max(campsites.c.price).label('max_price')
    )
    
    result = conn.execute(query).fetchone()
    print(f"Average price: R${result.avg_price:.2f}")
    print(f"Price range: R${result.min_price:.2f} - R${result.max_price:.2f}")
    
    
    # GROUP BY
    query = select(
        campsites.c.state,
        func.count().label('count'),
        func.avg(campsites.c.price).label('avg_price')
    ).group_by(
        campsites.c.state
    ).order_by(
        func.count().desc()
    )
    
    print("\nCampsites by state:")
    for row in conn.execute(query):
        print(f"  {row.state}: {row.count} campsites (avg: R${row.avg_price:.2f})")
```

### JOINs with Expression Language

```python
from sqlalchemy import Table, MetaData, select

metadata = MetaData()

# Define tables
campsites = Table('campsites', metadata, autoload_with=engine)
reviews = Table('reviews', metadata, autoload_with=engine)
bookings = Table('bookings', metadata, autoload_with=engine)

with engine.connect() as conn:
    
    # ---------- INNER JOIN ----------
    
    query = select(
        campsites.c.name,
        reviews.c.rating,
        reviews.c.comment
    ).select_from(
        campsites.join(reviews, campsites.c.id == reviews.c.campsite_id)
    )
    
    for row in conn.execute(query):
        print(f"{row.name}: ⭐{row.rating} - {row.comment}")
    
    
    # ---------- LEFT JOIN with aggregation ----------
    
    query = select(
        campsites.c.name,
        func.avg(reviews.c.rating).label('avg_rating'),
        func.count(reviews.c.id).label('review_count')
    ).select_from(
        campsites.outerjoin(reviews, campsites.c.id == reviews.c.campsite_id)
    ).group_by(
        campsites.c.id, campsites.c.name
    ).order_by(
        func.avg(reviews.c.rating).desc()
    )
    
    print("\nCampsites with ratings:")
    for row in conn.execute(query):
        avg = row.avg_rating if row.avg_rating else 0
        print(f"  {row.name}: ⭐{avg:.1f} ({row.review_count} reviews)")
```

### Real-World Example: Query Builder Class

```python
from sqlalchemy import create_engine, MetaData, Table, select, func, and_, or_
from typing import List, Optional, Dict

class CampsiteQueryBuilder:
    """Build and execute campsite queries using SQLAlchemy."""
    
    def __init__(self, engine):
        """Initialize with SQLAlchemy engine."""
        self.engine = engine
        self.metadata = MetaData()
        self.campsites = Table('campsites', self.metadata, autoload_with=engine)
        self.reviews = Table('reviews', self.metadata, autoload_with=engine)
    
    def search(
        self,
        states: Optional[List[str]] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        min_capacity: Optional[int] = None,
        min_rating: Optional[float] = None,
        limit: int = 100
    ) -> List[Dict]:
        """Search campsites with various filters.
        
        Args:
            states: Filter by states (e.g., ['BA', 'RJ'])
            min_price: Minimum price per night
            max_price: Maximum price per night
            min_capacity: Minimum capacity
            min_rating: Minimum average rating
            limit: Maximum results to return
            
        Returns:
            List of campsite dictionaries
        """
        # Base query with JOIN
        query = select(
            self.campsites.c.id,
            self.campsites.c.name,
            self.campsites.c.state,
            self.campsites.c.city,
            self.campsites.c.price,
            self.campsites.c.capacity,
            func.coalesce(func.avg(self.reviews.c.rating), 0).label('avg_rating'),
            func.count(self.reviews.c.id).label('review_count')
        ).select_from(
            self.campsites.outerjoin(
                self.reviews,
                self.campsites.c.id == self.reviews.c.campsite_id
            )
        )
        
        # Build WHERE conditions
        conditions = []
        
        if states:
            conditions.append(self.campsites.c.state.in_(states))
        
        if min_price is not None:
            conditions.append(self.campsites.c.price >= min_price)
        
        if max_price is not None:
            conditions.append(self.campsites.c.price <= max_price)
        
        if min_capacity is not None:
            conditions.append(self.campsites.c.capacity >= min_capacity)
        
        # Apply WHERE conditions
        if conditions:
            query = query.where(and_(*conditions))
        
        # GROUP BY (required for aggregations)
        query = query.group_by(
            self.campsites.c.id,
            self.campsites.c.name,
            self.campsites.c.state,
            self.campsites.c.city,
            self.campsites.c.price,
            self.campsites.c.capacity
        )
        
        # HAVING (filter on aggregated columns)
        if min_rating is not None:
            query = query.having(func.avg(self.reviews.c.rating) >= min_rating)
        
        # ORDER BY and LIMIT
        query = query.order_by(
            func.avg(self.reviews.c.rating).desc(),
            self.campsites.c.price
        ).limit(limit)
        
        # Execute and return results
        with self.engine.connect() as conn:
            result = conn.execute(query)
            return [dict(row._mapping) for row in result]
    
    def get_statistics(self) -> Dict:
        """Get overall campsite statistics."""
        query = select(
            func.count().label('total_campsites'),
            func.avg(self.campsites.c.price).label('avg_price'),
            func.min(self.campsites.c.price).label('min_price'),
            func.max(self.campsites.c.price).label('max_price'),
            func.sum(self.campsites.c.capacity).label('total_capacity')
        )
        
        with self.engine.connect() as conn:
            result = conn.execute(query).fetchone()
            return dict(result._mapping)
    
    def get_by_state(self) -> List[Dict]:
        """Get statistics grouped by state."""
        query = select(
            self.campsites.c.state,
            func.count().label('campsite_count'),
            func.avg(self.campsites.c.price).label('avg_price'),
            func.sum(self.campsites.c.capacity).label('total_capacity')
        ).group_by(
            self.campsites.c.state
        ).order_by(
            func.count().desc()
        )
        
        with self.engine.connect() as conn:
            result = conn.execute(query)
            return [dict(row._mapping) for row in result]

# Use it
engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

builder = CampsiteQueryBuilder(engine)

# Search campsites
print("🔍 Search Results:\n")
results = builder.search(
    states=['BA', 'RJ'],
    max_price=100.00,
    min_rating=4.0,
    limit=10
)

for camp in results:
    print(f"📍 {camp['name']} ({camp['city']}, {camp['state']})")
    print(f"   💰 R${camp['price']:.2f}/night")
    print(f"   👥 Capacity: {camp['capacity']}")
    print(f"   ⭐ Rating: {camp['avg_rating']:.1f} ({camp['review_count']} reviews)")
    print()

# Get statistics
print("\n📊 Overall Statistics:")
stats = builder.get_statistics()
print(f"Total Campsites: {stats['total_campsites']}")
print(f"Average Price: R${stats['avg_price']:.2f}")
print(f"Price Range: R${stats['min_price']:.2f} - R${stats['max_price']:.2f}")
print(f"Total Capacity: {stats['total_capacity']} people")

# By state
print("\n📍 Statistics by State:")
by_state = builder.get_by_state()
for state_stats in by_state:
    print(f"{state_stats['state']}: {state_stats['campsite_count']} campsites, "
          f"avg R${state_stats['avg_price']:.2f}, "
          f"capacity {state_stats['total_capacity']}")
```

---

## 3. SQLAlchemy ORM

### What is ORM?

**Object-Relational Mapping (ORM)** lets you work with database tables as Python classes. Instead of writing SQL, you work with Python objects.

### Benefits of ORM

✅ **Pythonic** - Write Python code instead of SQL  
✅ **Type Safety** - IDEs can autocomplete and check types  
✅ **Relationships** - Easily navigate related data  
✅ **Less Boilerplate** - No manual query building  
✅ **Database Agnostic** - Switch databases easily  

### Defining ORM Models

```python
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, ForeignKey, Text
from sqlalchemy.orm import declarative_base, relationship, Session
from datetime import datetime

# Create base class for models
Base = declarative_base()

# ---------- DEFINE MODELS ----------

class Campsite(Base):
    """Campsite model."""
    __tablename__ = 'campsites'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    state = Column(String(2), nullable=False)
    city = Column(String(100))
    price = Column(Float, nullable=False)
    capacity = Column(Integer, nullable=False)
    description = Column(Text)
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # Relationships
    reviews = relationship('Review', back_populates='campsite', cascade='all, delete-orphan')
    bookings = relationship('Booking', back_populates='campsite')
    
    def __repr__(self):
        return f"<Campsite(id={self.id}, name='{self.name}', state='{self.state}')>"

class Customer(Base):
    """Customer model."""
    __tablename__ = 'customers'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    phone = Column(String(20))
    created_at = Column(DateTime, default=datetime.now)
    
    # Relationships
    bookings = relationship('Booking', back_populates='customer')
    
    def __repr__(self):
        return f"<Customer(id={self.id}, name='{self.name}', email='{self.email}')>"

class Review(Base):
    """Review model."""
    __tablename__ = 'reviews'
    
    id = Column(Integer, primary_key=True)
    campsite_id = Column(Integer, ForeignKey('campsites.id'), nullable=False)
    customer_name = Column(String(100))
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text)
    created_at = Column(DateTime, default=datetime.now)
    
    # Relationships
    campsite = relationship('Campsite', back_populates='reviews')
    
    def __repr__(self):
        return f"<Review(id={self.id}, rating={self.rating})>"

class Booking(Base):
    """Booking model."""
    __tablename__ = 'bookings'
    
    id = Column(Integer, primary_key=True)
    customer_id = Column(Integer, ForeignKey('customers.id'), nullable=False)
    campsite_id = Column(Integer, ForeignKey('campsites.id'), nullable=False)
    check_in = Column(DateTime, nullable=False)
    check_out = Column(DateTime, nullable=False)
    guests = Column(Integer, nullable=False)
    total_price = Column(Float)
    created_at = Column(DateTime, default=datetime.now)
    
    # Relationships
    customer = relationship('Customer', back_populates='bookings')
    campsite = relationship('Campsite', back_populates='bookings')
    
    def __repr__(self):
        return f"<Booking(id={self.id}, customer_id={self.customer_id}, campsite_id={self.campsite_id})>"

# Create all tables
engine = create_engine('postgresql+psycopg2://postgres:password@localhost:5432/camping_db')
Base.metadata.create_all(engine)
```

### CRUD Operations with ORM

```python
from sqlalchemy.orm import Session

engine = create_engine('postgresql+psycopg2://postgres:password@localhost:5432/camping_db')

# ---------- CREATE (INSERT) ----------

with Session(engine) as session:
    # Create new campsite
    new_camp = Campsite(
        name='ORM Camp',
        state='SP',
        city='São Paulo',
        price=95.00,
        capacity=25,
        description='Created with SQLAlchemy ORM'
    )
    
    # Add to session
    session.add(new_camp)
    
    # Commit transaction
    session.commit()
    
    print(f"✅ Created campsite with ID: {new_camp.id}")


# Create multiple objects
with Session(engine) as session:
    camps = [
        Campsite(name='Camp A', state='BA', price=80.00, capacity=20),
        Campsite(name='Camp B', state='RJ', price=90.00, capacity=25),
        Campsite(name='Camp C', state='MG', price=75.00, capacity=15)
    ]
    
    session.add_all(camps)
    session.commit()
    
    print(f"✅ Created {len(camps)} campsites")


# ---------- READ (SELECT) ----------

with Session(engine) as session:
    # Get by primary key
    campsite = session.get(Campsite, 1)
    if campsite:
        print(f"Found: {campsite.name}")
    
    
    # Get first matching record
    campsite = session.query(Campsite).filter_by(state='BA').first()
    if campsite:
        print(f"First BA campsite: {campsite.name}")
    
    
    # Get all records
    campsites = session.query(Campsite).all()
    for camp in campsites:
        print(f"{camp.name} ({camp.state})")
    
    
    # Filter with WHERE
    campsites = session.query(Campsite).filter(
        Campsite.state == 'BA',
        Campsite.price <= 100.00
    ).all()
    
    
    # OR conditions
    from sqlalchemy import or_
    campsites = session.query(Campsite).filter(
        or_(Campsite.state == 'BA', Campsite.state == 'RJ')
    ).all()
    
    
    # LIKE pattern
    campsites = session.query(Campsite).filter(
        Campsite.name.like('%Serra%')
    ).all()
    
    
    # ORDER BY
    campsites = session.query(Campsite).order_by(
        Campsite.price.desc()
    ).all()
    
    
    # LIMIT and OFFSET
    campsites = session.query(Campsite).limit(10).offset(20).all()
    
    
    # COUNT
    count = session.query(Campsite).filter(Campsite.state == 'BA').count()
    print(f"Total BA campsites: {count}")


# ---------- UPDATE ----------

with Session(engine) as session:
    # Get object
    campsite = session.get(Campsite, 1)
    
    if campsite:
        # Modify attributes
        campsite.price = 130.00
        campsite.description = 'Updated description'
        
        # Commit changes
        session.commit()
        print(f"✅ Updated {campsite.name}")


# Bulk update
with Session(engine) as session:
    # Update all BA campsites
    session.query(Campsite).filter(
        Campsite.state == 'BA'
    ).update({
        'price': Campsite.price * 1.1  # 10% increase
    })
    
    session.commit()
    print("✅ Updated BA campsite prices")


# ---------- DELETE ----------

with Session(engine) as session:
    # Get object
    campsite = session.get(Campsite, 1)
    
    if campsite:
        # Delete object
        session.delete(campsite)
        session.commit()
        print(f"✅ Deleted {campsite.name}")


# Bulk delete
with Session(engine) as session:
    # Delete all campsites with capacity < 10
    deleted = session.query(Campsite).filter(
        Campsite.capacity < 10
    ).delete()
    
    session.commit()
    print(f"✅ Deleted {deleted} campsites")
```

### Working with Relationships

```python
from sqlalchemy.orm import Session

engine = create_engine('postgresql+psycopg2://postgres:password@localhost:5432/camping_db')

with Session(engine) as session:
    
    # ---------- ACCESSING RELATED DATA ----------
    
    # Get campsite with reviews
    campsite = session.query(Campsite).filter_by(id=1).first()
    
    if campsite:
        print(f"Campsite: {campsite.name}")
        print(f"Reviews ({len(campsite.reviews)}):")
        
        for review in campsite.reviews:
            print(f"  ⭐{review.rating}: {review.comment}")
    
    
    # ---------- CREATING RELATED OBJECTS ----------
    
    # Create campsite with reviews
    new_camp = Campsite(
        name='Amazing Camp',
        state='BA',
        price=120.00,
        capacity=30
    )
    
    # Add reviews
    new_camp.reviews = [
        Review(customer_name='Maria', rating=5, comment='Excelente!'),
        Review(customer_name='João', rating=4, comment='Muito bom!')
    ]
    
    session.add(new_camp)
    session.commit()
    
    print(f"✅ Created campsite with {len(new_camp.reviews)} reviews")
    
    
    # ---------- EAGER LOADING (Prevent N+1 queries) ----------
    
    from sqlalchemy.orm import joinedload
    
    # Load campsites with their reviews in one query
    campsites = session.query(Campsite).options(
        joinedload(Campsite.reviews)
    ).all()
    
    for camp in campsites:
        avg_rating = sum(r.rating for r in camp.reviews) / len(camp.reviews) if camp.reviews else 0
        print(f"{camp.name}: ⭐{avg_rating:.1f} ({len(camp.reviews)} reviews)")
```

---

## 4. Database Connection Pools

### What is a Connection Pool?

A **connection pool** is a cache of database connections maintained so connections can be reused. Creating new database connections is expensive (time and resources), so pools improve performance.

### Why Use Connection Pools?

✅ **Performance** - Reuse connections instead of creating new ones  
✅ **Resource Management** - Limit total connections to database  
✅ **Automatic Cleanup** - Handle connection lifecycle  
✅ **Production Ready** - Essential for web applications  
✅ **Prevents Exhaustion** - Database servers have connection limits  

### SQLAlchemy Built-in Pooling

SQLAlchemy includes connection pooling by default!

```python
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool, NullPool, StaticPool

# ---------- DEFAULT POOL (QueuePool) ----------

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db',
    pool_size=5,            # Keep 5 connections in pool
    max_overflow=10,        # Allow 10 more if needed (total: 15)
    pool_timeout=30,        # Wait 30s for available connection
    pool_recycle=3600,      # Recycle connections after 1 hour
    pool_pre_ping=True      # Test connections before use
)

# pool_size: Normal connections kept alive
# max_overflow: Extra connections created if pool exhausted
# pool_timeout: Seconds to wait before raising error
# pool_recycle: Seconds before recycling connection (prevents stale connections)
# pool_pre_ping: Test connection validity before each use


# ---------- NULL POOL (No Pooling) ----------

# Use for testing or when external pool manager is used
engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db',
    poolclass=NullPool
)


# ---------- STATIC POOL (SQLite) ----------

# Single connection, good for SQLite
engine = create_engine(
    'sqlite:///camping.db',
    poolclass=StaticPool
)
```

### Connection Pool Monitoring

```python
from sqlalchemy import create_engine, text
import time

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db',
    pool_size=3,
    max_overflow=2,
    echo_pool=True  # Log pool events
)

# ---------- CHECK POOL STATUS ----------

def print_pool_status(engine):
    """Print current pool status."""
    pool = engine.pool
    print(f"Pool size: {pool.size()}")
    print(f"Checked out: {pool.checkedout()}")
    print(f"Overflow: {pool.overflow()}")
    print(f"Checked in: {pool.checkedin()}")
    print("-" * 40)

# Initial status
print("Initial pool:")
print_pool_status(engine)

# Checkout connections
conns = []
for i in range(5):
    conn = engine.connect()
    conns.append(conn)
    print(f"\nAfter connection {i+1}:")
    print_pool_status(engine)

# Return connections
for i, conn in enumerate(conns):
    conn.close()
    print(f"\nAfter closing connection {i+1}:")
    print_pool_status(engine)
```

### Real-World Pool Configuration

```python
from sqlalchemy import create_engine, event
from sqlalchemy.pool import Pool
import logging

# Setup logging
logging.basicConfig()
logging.getLogger('sqlalchemy.pool').setLevel(logging.DEBUG)

# ---------- PRODUCTION CONFIGURATION ----------

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db',
    
    # Pool settings
    pool_size=10,              # Base pool size
    max_overflow=20,           # Extra connections allowed
    pool_timeout=30,           # Timeout waiting for connection
    pool_recycle=3600,         # Recycle after 1 hour
    pool_pre_ping=True,        # Verify connections are alive
    
    # Connection arguments
    connect_args={
        'connect_timeout': 10,  # Connection timeout
        'application_name': 'camping_app'
    },
    
    # Performance
    echo=False,                # Don't log SQL (production)
    echo_pool=False,           # Don't log pool events (production)
    
    # Execution options
    execution_options={
        'isolation_level': 'READ COMMITTED'
    }
)

# ---------- POOL EVENT LISTENERS ----------

@event.listens_for(Pool, "connect")
def receive_connect(dbapi_conn, connection_record):
    """Called when new connection is created."""
    print(f"🔌 New connection created")

@event.listens_for(Pool, "checkout")
def receive_checkout(dbapi_conn, connection_record, connection_proxy):
    """Called when connection is retrieved from pool."""
    print(f"📤 Connection checked out from pool")

@event.listens_for(Pool, "checkin")
def receive_checkin(dbapi_conn, connection_record):
    """Called when connection is returned to pool."""
    print(f"📥 Connection returned to pool")

# Test the pool
with engine.connect() as conn:
    result = conn.execute(text("SELECT 1"))
    print(f"Query result: {result.scalar()}")
```

---

## 5. pandas Database Integration

### Reading Data into DataFrames

pandas provides easy integration with SQL databases!

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# ---------- READ TABLE INTO DATAFRAME ----------

# Read entire table
df = pd.read_sql_table('campsites', engine)
print(df.head())

#    id                 name state         city   price  capacity
# 0   1  Camping Vale do Pati    BA    Palmeiras  120.00        30
# 1   2     Serra dos Órgãos    RJ  Petrópolis   80.00        25
# ...


# ---------- READ WITH SQL QUERY ----------

# Custom SQL query
query = """
    SELECT c.name, c.state, c.price, AVG(r.rating) as avg_rating
    FROM campsites c
    LEFT JOIN reviews r ON c.id = r.campsite_id
    WHERE c.state IN ('BA', 'RJ', 'MG')
    GROUP BY c.id, c.name, c.state, c.price
    HAVING AVG(r.rating) >= 4.0
    ORDER BY avg_rating DESC
"""

df = pd.read_sql_query(query, engine)
print(df)


# ---------- READ WITH PARAMETERS ----------

# Parameterized query (safe from SQL injection)
query = """
    SELECT name, price, capacity
    FROM campsites
    WHERE state = %(state)s AND price <= %(max_price)s
"""

df = pd.read_sql_query(
    query,
    engine,
    params={'state': 'BA', 'max_price': 100.00}
)


# ---------- READ IN CHUNKS (Large Data) ----------

# Read large table in chunks (memory efficient)
chunk_size = 1000
chunks = []

for chunk in pd.read_sql_query(
    "SELECT * FROM campsites",
    engine,
    chunksize=chunk_size
):
    # Process each chunk
    chunks.append(chunk)
    print(f"Processed {len(chunk)} rows")

# Combine all chunks
df = pd.concat(chunks, ignore_index=True)
```

### Writing DataFrames to Database

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# ---------- WRITE DATAFRAME TO TABLE ----------

# Create sample DataFrame
df = pd.DataFrame({
    'name': ['Camp A', 'Camp B', 'Camp C'],
    'state': ['BA', 'RJ', 'MG'],
    'price': [80.00, 95.00, 75.00],
    'capacity': [20, 30, 15]
})

# Write to database
df.to_sql(
    'campsites_new',      # Table name
    engine,                # Database connection
    if_exists='fail',      # 'fail', 'replace', 'append'
    index=False            # Don't write DataFrame index
)

print("✅ DataFrame written to database")


# ---------- APPEND TO EXISTING TABLE ----------

df.to_sql(
    'campsites',
    engine,
    if_exists='append',   # Append to existing table
    index=False
)


# ---------- REPLACE ENTIRE TABLE ----------

df.to_sql(
    'campsites_temp',
    engine,
    if_exists='replace',  # Drop and recreate table
    index=False
)


# ---------- WRITE IN CHUNKS (Large Data) ----------

# Write large DataFrame in chunks
large_df = pd.DataFrame({
    'name': [f'Camp {i}' for i in range(10000)],
    'state': ['BA'] * 10000,
    'price': [80.00] * 10000
})

large_df.to_sql(
    'campsites_bulk',
    engine,
    if_exists='replace',
    index=False,
    chunksize=1000  # Write 1000 rows at a time
)


# ---------- SPECIFY DATA TYPES ----------

from sqlalchemy.types import Integer, String, Float

df.to_sql(
    'campsites_typed',
    engine,
    if_exists='replace',
    index=False,
    dtype={
        'name': String(100),
        'state': String(2),
        'price': Float,
        'capacity': Integer
    }
)
```

### ETL Pipeline: CSV → pandas → PostgreSQL

```python
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path

def etl_csv_to_postgres(
    csv_file: Path,
    table_name: str,
    engine,
    transform_func=None
):
    """ETL pipeline: Extract from CSV, Transform, Load to PostgreSQL.
    
    Args:
        csv_file: Path to CSV file
        table_name: Destination table name
        engine: SQLAlchemy engine
        transform_func: Optional transformation function
    """
    print(f"📖 Extracting data from {csv_file}...")
    
    # EXTRACT
    df = pd.read_csv(csv_file)
    print(f"   Loaded {len(df)} rows")
    
    # TRANSFORM
    if transform_func:
        print(f"🔄 Transforming data...")
        df = transform_func(df)
        print(f"   Transformed to {len(df)} rows")
    
    # LOAD
    print(f"💾 Loading to PostgreSQL table '{table_name}'...")
    df.to_sql(
        table_name,
        engine,
        if_exists='replace',
        index=False
    )
    
    print(f"✅ ETL complete! {len(df)} rows loaded to {table_name}")

# Transform function
def clean_campsite_data(df):
    """Clean and validate campsite data."""
    # Remove duplicates
    df = df.drop_duplicates(subset=['name', 'state'])
    
    # Remove rows with missing critical data
    df = df.dropna(subset=['name', 'state', 'price'])
    
    # Convert data types
    df['price'] = pd.to_numeric(df['price'], errors='coerce')
    df['capacity'] = pd.to_numeric(df['capacity'], errors='coerce').astype('Int64')
    
    # Filter invalid data
    df = df[df['price'] > 0]
    df = df[df['capacity'] > 0]
    
    # Clean text
    df['name'] = df['name'].str.strip()
    df['state'] = df['state'].str.upper().str.strip()
    
    # Add timestamp
    df['imported_at'] = pd.Timestamp.now()
    
    return df

# Run ETL
engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

csv_file = Path("data/campsites_raw.csv")
etl_csv_to_postgres(csv_file, 'campsites_cleaned', engine, clean_campsite_data)
```

### Advanced pandas + SQL Patterns

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    'postgresql+psycopg2://postgres:password@localhost:5432/camping_db'
)

# ---------- EXPORT QUERY RESULTS TO DIFFERENT FORMATS ----------

# Query data
df = pd.read_sql_query(
    """
    SELECT c.*, AVG(r.rating) as avg_rating
    FROM campsites c
    LEFT JOIN reviews r ON c.id = r.campsite_id
    GROUP BY c.id
    """,
    engine
)

# Export to CSV
df.to_csv('output/campsites_export.csv', index=False)

# Export to Excel
df.to_excel('output/campsites_export.xlsx', index=False)

# Export to JSON
df.to_json('output/campsites_export.json', orient='records', indent=4)

# Export to Parquet
df.to_parquet('output/campsites_export.parquet', index=False)


# ---------- UPSERT PATTERN (Insert or Update) ----------

def upsert_dataframe(df, table_name, engine, key_columns):
    """Insert or update records based on key columns."""
    from sqlalchemy import MetaData, Table
    from sqlalchemy.dialects.postgresql import insert
    
    metadata = MetaData()
    table = Table(table_name, metadata, autoload_with=engine)
    
    # Convert DataFrame to list of dictionaries
    records = df.to_dict('records')
    
    with engine.begin() as conn:
        for record in records:
            # PostgreSQL INSERT ... ON CONFLICT UPDATE
            stmt = insert(table).values(**record)
            
            # Update if conflict on key columns
            update_dict = {c.name: c for c in stmt.excluded if c.name not in key_columns}
            stmt = stmt.on_conflict_do_update(
                index_elements=key_columns,
                set_=update_dict
            )
            
            conn.execute(stmt)
    
    print(f"✅ Upserted {len(records)} records")

# Use it
df_updates = pd.DataFrame({
    'id': [1, 2, 999],
    'name': ['Updated Camp 1', 'Updated Camp 2', 'New Camp'],
    'price': [130.00, 90.00, 100.00]
})

upsert_dataframe(df_updates, 'campsites', engine, key_columns=['id'])
```

---

## 6. Practice Exercises

### Exercise 1: Database Query Wrapper ⭐

Create a reusable function to execute queries with error handling.

```python
from typing import Optional, List, Dict
import psycopg2

def execute_query(
    conn_params: dict,
    query: str,
    params: Optional[tuple] = None,
    fetch: str = 'all'
) -> Optional[List[Dict]]:
    """Execute query and return results.
    
    Args:
        conn_params: Database connection parameters
        query: SQL query to execute
        params: Query parameters (optional)
        fetch: 'all', 'one', or 'none'
        
    Returns:
        Query results or None on error
    """
    # Your code here
    pass

# Test it
conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'password'
}

results = execute_query(
    conn_params,
    "SELECT name, price FROM campsites WHERE state = %s",
    ('BA',),
    fetch='all'
)

for row in results:
    print(f"{row['name']}: R${row['price']}")
```

<details>
<summary>✅ Solution</summary>

```python
from typing import Optional, List, Dict
import psycopg2
from psycopg2.extras import RealDictCursor

def execute_query(
    conn_params: dict,
    query: str,
    params: Optional[tuple] = None,
    fetch: str = 'all'
) -> Optional[List[Dict]]:
    """Execute query and return results."""
    
    try:
        with psycopg2.connect(**conn_params) as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                cursor.execute(query, params)
                
                if fetch == 'all':
                    return [dict(row) for row in cursor.fetchall()]
                elif fetch == 'one':
                    row = cursor.fetchone()
                    return dict(row) if row else None
                elif fetch == 'none':
                    conn.commit()
                    return {'rowcount': cursor.rowcount}
                else:
                    raise ValueError(f"Invalid fetch option: {fetch}")
    
    except psycopg2.Error as e:
        print(f"❌ Database error: {e}")
        return None
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return None

# Test it
conn_params = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'password'
}

# Fetch all
results = execute_query(
    conn_params,
    "SELECT name, price FROM campsites WHERE state = %s ORDER BY price",
    ('BA',),
    fetch='all'
)

if results:
    print(f"Found {len(results)} campsites in BA:")
    for row in results:
        print(f"  {row['name']}: R${row['price']:.2f}")

# Fetch one
result = execute_query(
    conn_params,
    "SELECT name, price FROM campsites WHERE id = %s",
    (1,),
    fetch='one'
)

if result:
    print(f"\nCampsite: {result['name']}, Price: R${result['price']:.2f}")

# Insert (no fetch)
result = execute_query(
    conn_params,
    "INSERT INTO campsites (name, state, price, capacity) VALUES (%s, %s, %s, %s)",
    ('Test Camp', 'SP', 85.00, 20),
    fetch='none'
)

if result:
    print(f"\n✅ Inserted {result['rowcount']} row(s)")
```
</details>

---

### Exercise 2: SQLAlchemy Search API ⭐⭐

Build a search API using SQLAlchemy Core with multiple filters.

```python
from sqlalchemy import create_engine, MetaData, Table, select
from typing import Optional, List, Dict

class CampsiteSearch:
    """Search campsites with SQLAlchemy."""
    
    def __init__(self, engine):
        self.engine = engine
        self.metadata = MetaData()
        self.campsites = Table('campsites', self.metadata, autoload_with=engine)
    
    def search(
        self,
        name_pattern: Optional[str] = None,
        states: Optional[List[str]] = None,
        price_range: Optional[tuple] = None,
        min_capacity: Optional[int] = None
    ) -> List[Dict]:
        """Search campsites with filters."""
        # Your code here
        pass

# Test it
engine = create_engine('postgresql+psycopg2://postgres:password@localhost/camping_db')
search = CampsiteSearch(engine)

results = search.search(
    name_pattern='Serra%',
    states=['BA', 'RJ'],
    price_range=(50, 100),
    min_capacity=20
)

for camp in results:
    print(f"{camp['name']} ({camp['state']}): R${camp['price']}")
```

<details>
<summary>✅ Solution</summary>

```python
from sqlalchemy import create_engine, MetaData, Table, select, and_
from typing import Optional, List, Dict

class CampsiteSearch:
    """Search campsites with SQLAlchemy."""
    
    def __init__(self, engine):
        self.engine = engine
        self.metadata = MetaData()
        self.campsites = Table('campsites', self.metadata, autoload_with=engine)
    
    def search(
        self,
        name_pattern: Optional[str] = None,
        states: Optional[List[str]] = None,
        price_range: Optional[tuple] = None,
        min_capacity: Optional[int] = None
    ) -> List[Dict]:
        """Search campsites with filters."""
        
        # Start with base query
        query = select(self.campsites)
        
        # Build WHERE conditions
        conditions = []
        
        if name_pattern:
            conditions.append(self.campsites.c.name.like(name_pattern))
        
        if states:
            conditions.append(self.campsites.c.state.in_(states))
        
        if price_range:
            min_price, max_price = price_range
            conditions.append(self.campsites.c.price >= min_price)
            conditions.append(self.campsites.c.price <= max_price)
        
        if min_capacity:
            conditions.append(self.campsites.c.capacity >= min_capacity)
        
        # Apply conditions
        if conditions:
            query = query.where(and_(*conditions))
        
        # Order by price
        query = query.order_by(self.campsites.c.price)
        
        # Execute query
        with self.engine.connect() as conn:
            result = conn.execute(query)
            return [dict(row._mapping) for row in result]

# Test it
engine = create_engine('postgresql+psycopg2://postgres:password@localhost/camping_db')
search = CampsiteSearch(engine)

print("🔍 Search Results:\n")

# Search with multiple filters
results = search.search(
    name_pattern='%Camp%',
    states=['BA', 'RJ', 'MG'],
    price_range=(50, 100),
    min_capacity=20
)

if results:
    print(f"Found {len(results)} campsites:\n")
    for camp in results:
        print(f"📍 {camp['name']} ({camp['city']}, {camp['state']})")
        print(f"   💰 R${camp['price']:.2f}/night | 👥 Capacity: {camp['capacity']}")
        print()
else:
    print("No campsites found matching criteria")
```
</details>

---

### Exercise 3: ORM CRUD Manager ⭐⭐

Create a generic CRUD manager class using SQLAlchemy ORM.

```python
from sqlalchemy.orm import Session
from typing import List, Optional, Dict

class CRUDManager:
    """Generic CRUD operations for SQLAlchemy models."""
    
    def __init__(self, model_class, session: Session):
        self.model_class = model_class
        self.session = session
    
    def create(self, **kwargs) -> object:
        """Create new record."""
        # Your code here
        pass
    
    def get_by_id(self, id: int) -> Optional[object]:
        """Get record by ID."""
        # Your code here
        pass
    
    def get_all(self, limit: int = 100) -> List[object]:
        """Get all records."""
        # Your code here
        pass
    
    def update(self, id: int, **kwargs) -> bool:
        """Update record."""
        # Your code here
        pass
    
    def delete(self, id: int) -> bool:
        """Delete record."""
        # Your code here
        pass

# Test it
from sqlalchemy.orm import sessionmaker

Session = sessionmaker(bind=engine)
session = Session()

manager = CRUDManager(Campsite, session)

# Create
camp = manager.create(name='Test Camp', state='SP', price=85.00, capacity=20)
print(f"Created: {camp.name}")

# Update
manager.update(camp.id, price=90.00)

# Delete
manager.delete(camp.id)
```

<details>
<summary>✅ Solution</summary>

```python
from sqlalchemy.orm import Session
from typing import List, Optional, Dict, Any

class CRUDManager:
    """Generic CRUD operations for SQLAlchemy models."""
    
    def __init__(self, model_class, session: Session):
        self.model_class = model_class
        self.session = session
    
    def create(self, **kwargs) -> Any:
        """Create new record."""
        try:
            obj = self.model_class(**kwargs)
            self.session.add(obj)
            self.session.commit()
            self.session.refresh(obj)  # Get generated ID
            print(f"✅ Created {self.model_class.__name__} with ID: {obj.id}")
            return obj
        except Exception as e:
            self.session.rollback()
            print(f"❌ Error creating {self.model_class.__name__}: {e}")
            return None
    
    def get_by_id(self, id: int) -> Optional[Any]:
        """Get record by ID."""
        return self.session.get(self.model_class, id)
    
    def get_all(self, limit: int = 100, **filters) -> List[Any]:
        """Get all records with optional filters."""
        query = self.session.query(self.model_class)
        
        # Apply filters
        for key, value in filters.items():
            if hasattr(self.model_class, key):
                query = query.filter(getattr(self.model_class, key) == value)
        
        return query.limit(limit).all()
    
    def update(self, id: int, **kwargs) -> bool:
        """Update record."""
        try:
            obj = self.session.get(self.model_class, id)
            if not obj:
                print(f"❌ {self.model_class.__name__} with ID {id} not found")
                return False
            
            for key, value in kwargs.items():
                if hasattr(obj, key):
                    setattr(obj, key, value)
            
            self.session.commit()
            print(f"✅ Updated {self.model_class.__name__} ID: {id}")
            return True
        except Exception as e:
            self.session.rollback()
            print(f"❌ Error updating {self.model_class.__name__}: {e}")
            return False
    
    def delete(self, id: int) -> bool:
        """Delete record."""
        try:
            obj = self.session.get(self.model_class, id)
            if not obj:
                print(f"❌ {self.model_class.__name__} with ID {id} not found")
                return False
            
            self.session.delete(obj)
            self.session.commit()
            print(f"✅ Deleted {self.model_class.__name__} ID: {id}")
            return True
        except Exception as e:
            self.session.rollback()
            print(f"❌ Error deleting {self.model_class.__name__}: {e}")
            return False
    
    def count(self, **filters) -> int:
        """Count records with optional filters."""
        query = self.session.query(self.model_class)
        
        for key, value in filters.items():
            if hasattr(self.model_class, key):
                query = query.filter(getattr(self.model_class, key) == value)
        
        return query.count()

# Test it
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

engine = create_engine('postgresql+psycopg2://postgres:password@localhost/camping_db')
Session = sessionmaker(bind=engine)
session = Session()

# Create manager
manager = CRUDManager(Campsite, session)

print("=" * 60)
print("CRUD Manager Test")
print("=" * 60)

# CREATE
print("\n1. CREATE:")
camp = manager.create(
    name='CRUD Test Camp',
    state='SP',
    city='São Paulo',
    price=85.00,
    capacity=20,
    description='Created with CRUD Manager'
)

if camp:
    camp_id = camp.id
    
    # READ
    print("\n2. READ:")
    found = manager.get_by_id(camp_id)
    if found:
        print(f"   Found: {found.name} (ID: {found.id})")
    
    # GET ALL with filter
    print("\n3. GET ALL (filtered by state='SP'):")
    sp_camps = manager.get_all(state='SP', limit=5)
    for c in sp_camps:
        print(f"   {c.name} - R${c.price:.2f}")
    
    # COUNT
    print("\n4. COUNT:")
    total_sp = manager.count(state='SP')
    print(f"   Total SP campsites: {total_sp}")
    
    # UPDATE
    print("\n5. UPDATE:")
    manager.update(camp_id, price=95.00, description='Updated description')
    
    # DELETE
    print("\n6. DELETE:")
    manager.delete(camp_id)

print("\n" + "=" * 60)
```
</details>

---

### Exercise 4: Data Pipeline - CSV to Database ⭐⭐⭐

Create a complete ETL pipeline that reads CSV, transforms data, and loads to PostgreSQL.

```python
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
from typing import Dict

def campsite_etl_pipeline(
    csv_file: Path,
    db_engine,
    table_name: str = 'campsites_imported'
) -> Dict[str, int]:
    """Complete ETL pipeline for campsite data."""
    # Your code here
    pass

# Test it
engine = create_engine('postgresql+psycopg2://postgres:password@localhost/camping_db')
csv_file = Path('data/campsites_raw.csv')

stats = campsite_etl_pipeline(csv_file, engine)
print(f"Processed: {stats['processed']}")
print(f"Loaded: {stats['loaded']}")
print(f"Errors: {stats['errors']}")
```

<details>
<summary>✅ Solution</summary>

```python
import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path
from typing import Dict
import numpy as np

def campsite_etl_pipeline(
    csv_file: Path,
    db_engine,
    table_name: str = 'campsites_imported'
) -> Dict[str, int]:
    """Complete ETL pipeline for campsite data.
    
    Args:
        csv_file: Path to CSV file
        db_engine: SQLAlchemy engine
        table_name: Destination table name
        
    Returns:
        Dictionary with pipeline statistics
    """
    stats = {
        'extracted': 0,
        'processed': 0,
        'loaded': 0,
        'errors': 0
    }
    
    try:
        # ========== EXTRACT ==========
        print(f"📖 Extracting data from {csv_file}...")
        df = pd.read_csv(csv_file)
        stats['extracted'] = len(df)
        print(f"   Extracted {stats['extracted']} rows")
        
        # ========== TRANSFORM ==========
        print(f"🔄 Transforming data...")
        
        # Remove duplicates
        original_count = len(df)
        df = df.drop_duplicates(subset=['name', 'state'], keep='first')
        duplicates_removed = original_count - len(df)
        if duplicates_removed > 0:
            print(f"   Removed {duplicates_removed} duplicates")
        
        # Handle missing values
        # Required fields
        before = len(df)
        df = df.dropna(subset=['name', 'state', 'price', 'capacity'])
        missing_removed = before - len(df)
        if missing_removed > 0:
            print(f"   Removed {missing_removed} rows with missing required fields")
        
        # Optional fields - fill with defaults
        df['city'] = df['city'].fillna('Unknown')
        df['description'] = df['description'].fillna('')
        
        # Data type conversion
        df['price'] = pd.to_numeric(df['price'], errors='coerce')
        df['capacity'] = pd.to_numeric(df['capacity'], errors='coerce')
        
        # Remove invalid data
        before = len(df)
        df = df[df['price'] > 0]
        df = df[df['capacity'] > 0]
        invalid_removed = before - len(df)
        if invalid_removed > 0:
            print(f"   Removed {invalid_removed} rows with invalid values")
        
        # Data cleaning
        df['name'] = df['name'].str.strip()
        df['state'] = df['state'].str.upper().str.strip()
        df['city'] = df['city'].str.strip()
        
        # Validate state codes
        valid_states = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 
                       'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 
                       'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO']
        before = len(df)
        df = df[df['state'].isin(valid_states)]
        invalid_states = before - len(df)
        if invalid_states > 0:
            print(f"   Removed {invalid_states} rows with invalid state codes")
        
        # Add metadata
        df['imported_at'] = pd.Timestamp.now()
        df['data_source'] = csv_file.name
        
        stats['processed'] = len(df)
        print(f"   Processed: {stats['processed']} valid rows")
        
        # ========== LOAD ==========
        print(f"💾 Loading to PostgreSQL table '{table_name}'...")
        
        df.to_sql(
            table_name,
            db_engine,
            if_exists='replace',
            index=False,
            chunksize=1000
        )
        
        stats['loaded'] = len(df)
        print(f"   Loaded {stats['loaded']} rows to database")
        
        # ========== VERIFY ==========
        print(f"✔️  Verifying data...")
        verify_query = f"SELECT COUNT(*) FROM {table_name}"
        with db_engine.connect() as conn:
            result = conn.execute(verify_query)
            db_count = result.scalar()
            
            if db_count == stats['loaded']:
                print(f"   ✅ Verification successful: {db_count} rows in database")
            else:
                print(f"   ⚠️  Warning: Expected {stats['loaded']}, found {db_count}")
        
        return stats
        
    except FileNotFoundError:
        print(f"❌ Error: File not found: {csv_file}")
        stats['errors'] = 1
        return stats
    
    except Exception as e:
        print(f"❌ Error in pipeline: {e}")
        stats['errors'] = 1
        return stats

# Create sample CSV for testing
def create_sample_csv():
    """Create sample CSV file for testing."""
    sample_data = {
        'name': [
            'Camping Vale do Pati', 'Serra dos Órgãos', 'Pico da Bandeira',
            'Cachoeira Camp', 'Trilha Azul', 'Camping Vale do Pati',  # Duplicate
            'Invalid Camp', 'Empty Price Camp', 'Foreign Camp'
        ],
        'state': ['BA', 'RJ', 'MG', 'BA', 'SP', 'BA', 'XX', 'RS', 'ZZ'],
        'city': [
            'Palmeiras', 'Petrópolis', 'Alto Caparaó', 'Salvador', 'São Paulo',
            'Palmeiras', 'Invalid', 'Porto Alegre', 'Invalid'
        ],
        'price': [120.00, 80.00, 100.00, 95.00, 110.00, 120.00, -50.00, None, 75.00],
        'capacity': [30, 25, 20, 15, 28, 30, 10, 20, 0],
        'description': [
            'Beautiful valley', 'Mountain camping', 'Peak adventure',
            'Waterfall nearby', 'Blue trail', 'Beautiful valley',
            'Invalid camp', 'Great place', 'Invalid'
        ]
    }
    
    df = pd.DataFrame(sample_data)
    csv_file = Path('data/campsites_raw.csv')
    csv_file.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(csv_file, index=False)
    return csv_file

# Run pipeline
print("=" * 70)
print("ETL PIPELINE: CSV → Transform → PostgreSQL")
print("=" * 70)

# Create sample data
csv_file = create_sample_csv()
print(f"\n📝 Created sample CSV: {csv_file}\n")

# Run pipeline
engine = create_engine('postgresql+psycopg2://postgres:password@localhost:5432/camping_db')
stats = campsite_etl_pipeline(csv_file, engine, table_name='campsites_imported')

# Print summary
print("\n" + "=" * 70)
print("PIPELINE SUMMARY")
print("=" * 70)
print(f"📊 Extracted:  {stats['extracted']} rows")
print(f"🔄 Processed:  {stats['processed']} rows")
print(f"💾 Loaded:     {stats['loaded']} rows")
print(f"❌ Errors:     {stats['errors']}")
print(f"📉 Filtered:   {stats['extracted'] - stats['loaded']} rows")
print("=" * 70)
```
</details>

---

**🎯 Lesson 3: Database Connectivity - Complete!**

You've mastered:
- ✅ **psycopg2**: Direct PostgreSQL connectivity with parameterized queries
- ✅ **SQLAlchemy Core**: Expression language for building SQL in Python
- ✅ **SQLAlchemy ORM**: Object-relational mapping with Python classes
- ✅ **Connection Pools**: Production-ready connection management
- ✅ **pandas Integration**: DataFrames ↔ Database ETL pipelines
- ✅ **4 Real-World Exercises**: From basic to advanced database operations

**Total Content:** ~2,400 lines of comprehensive database programming! 🚀

**Next Steps:**
- Practice all exercises
- Build your own database applications
- Move to Lesson 4: Error Handling & Logging
