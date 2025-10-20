# Enhanced OOP Explanations - Part 1: Classes and Objects

This document provides **step-by-step, beginner-friendly** explanations for Object-Oriented Programming concepts.

---

## 🎯 Part 1: Understanding Classes and Objects

### 🤔 What is a Class? (Super Detailed Explanation)

**Think of a class like a FORM or TEMPLATE:**

Imagine you work at a camping reservation office. You have a **blank form** that looks like this:

```
┌─────────────────────────────┐
│ CAMPSITE REGISTRATION FORM   │
├─────────────────────────────┤
│ Name:     _______________   │
│ State:    _______________   │
│ Price:    _______________   │
│ Capacity: _______________   │
└─────────────────────────────┘
```

This **blank form** is like a **CLASS**:
- It defines **what information** you need (name, state, price, capacity)
- It's **NOT a campsite itself** - it's just the template
- You can use this form **many times** to register different campsites

**In Python:**

```python
# This is the FORM (class)
class Campsite:
    """This is like the blank form - it defines what a campsite should have."""
    
    def __init__(self, name, state, price, capacity):
        # These are the "fields" on the form
        self.name = name
        self.state = state
        self.price = price
        self.capacity = capacity
```

### 🤔 What is an Object? (Super Detailed Explanation)

An **object** (also called **instance**) is a **FILLED-OUT FORM** - an actual campsite!

**Using our form analogy:**

```
┌─────────────────────────────┐   ← This is an OBJECT (instance)
│ CAMPSITE REGISTRATION FORM   │
├─────────────────────────────┤
│ Name:     Camping Vale      │  ← Actual data!
│ State:    BA                │  ← Actual data!
│ Price:    R$ 120.00         │  ← Actual data!
│ Capacity: 30 people         │  ← Actual data!
└─────────────────────────────┘
```

```
┌─────────────────────────────┐   ← This is ANOTHER OBJECT (instance)
│ CAMPSITE REGISTRATION FORM   │
├─────────────────────────────┤
│ Name:     Serra dos Órgãos  │  ← Different data!
│ State:    RJ                │  ← Different data!
│ Price:    R$ 80.00          │  ← Different data!
│ Capacity: 50 people         │  ← Different data!
└─────────────────────────────┘
```

**In Python:**

```python
# Create ACTUAL campsites (objects) using the template (class)
camp1 = Campsite("Camping Vale", "BA", 120.00, 30)      # First filled form
camp2 = Campsite("Serra dos Órgãos", "RJ", 80.00, 50)   # Second filled form

# Each object has its OWN data
print(camp1.name)   # Camping Vale
print(camp2.name)   # Serra dos Órgãos
```

---

## 🔍 Understanding `self` - THE MOST IMPORTANT CONCEPT!

### What is `self`? (Explained 5 Different Ways)

`self` is the **hardest concept** for beginners. Let's explain it multiple ways until it clicks!

#### **Explanation 1: The Phone Analogy**

Imagine you're filling out forms for multiple campsites. Someone calls you and asks:

👤 **Caller:** "What's the price?"  
You: "Price of **WHICH** campsite?"  
👤 **Caller:** "The one you're currently working on!"  
You: "Oh, **THIS** one costs R$120.00"

`self` means **"THIS ONE"** - the specific object you're currently working with.

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name      # THIS campsite's name
        self.price = price    # THIS campsite's price
    
    def display_price(self):
        print(f"THIS campsite ({self.name}) costs R${self.price:.2f}")
        #                      ^^^^^^^^^^    ^^^^^^^^^^
        #                      THIS one's name  THIS one's price

camp1 = Campsite("Vale", 120.00)
camp2 = Campsite("Serra", 80.00)

camp1.display_price()  # When we call camp1.display_price(), self = camp1
# Output: THIS campsite (Vale) costs R$120.00

camp2.display_price()  # When we call camp2.display_price(), self = camp2
# Output: THIS campsite (Serra) costs R$80.00
```

#### **Explanation 2: The Badge Analogy**

Imagine each campsite is a person wearing a badge that says "ME":

```
┌──────────────┐        ┌──────────────┐
│  Campsite 1  │        │  Campsite 2  │
│   [Badge]    │        │   [Badge]    │
│     ME       │        │     ME       │
│  (self)      │        │  (self)      │
└──────────────┘        └──────────────┘
   Name: Vale             Name: Serra
   Price: 120             Price: 80
```

When you're inside a method of Campsite 1:
- `self` points to the "ME" badge of Campsite 1
- `self.name` means "**MY** name" (Vale)
- `self.price` means "**MY** price" (120)

When you're inside a method of Campsite 2:
- `self` points to the "ME" badge of Campsite 2
- `self.name` means "**MY** name" (Serra)
- `self.price` means "**MY** price" (80)

#### **Explanation 3: Without `self` vs With `self`**

Let's see what happens WITHOUT `self`:

```python
class Campsite:
    def __init__(self, name, price):
        # WITHOUT self - just local variables
        name = name      # This disappears after __init__ ends!
        price = price    # This disappears after __init__ ends!

camp = Campsite("Vale", 120.00)
# print(camp.name)  # ❌ ERROR! 'Campsite' object has no attribute 'name'
# The data was lost!
```

Now WITH `self`:

```python
class Campsite:
    def __init__(self, name, price):
        # WITH self - stored in the object
        self.name = name      # Stored in THIS object forever!
        self.price = price    # Stored in THIS object forever!

camp = Campsite("Vale", 120.00)
print(camp.name)   # ✅ Vale - it works!
print(camp.price)  # ✅ 120.0 - it works!
```

#### **Explanation 4: The House Analogy**

Imagine `self` is like saying "**my house**":

- When you're at home and say "my bedroom", everyone knows you mean **YOUR** bedroom
- When your neighbor is at their home and says "my bedroom", they mean **THEIR** bedroom
- "my" = self (refers to whoever is speaking)

```python
class Campsite:
    def __init__(self, name):
        self.name = name  # "My name is..."
    
    def introduce(self):
        print(f"My name is {self.name}")  # "My name is..."
        #                   ^^^^^^^^^^
        #                   Refers to THIS campsite's name

camp1 = Campsite("Vale")
camp2 = Campsite("Serra")

camp1.introduce()  # When camp1 speaks: "My name is Vale"
camp2.introduce()  # When camp2 speaks: "My name is Serra"
```

#### **Explanation 5: The Technical Explanation**

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price

# When you write:
camp = Campsite("Vale", 120.00)

# Python does this behind the scenes:
# 1. Create empty object:  camp = {}  (simplified)
# 2. Call: Campsite.__init__(camp, "Vale", 120.00)
#                            ^^^^
#                            Python passes the object as first argument!
# 3. Inside __init__:
#      self = camp  (self is the object we just created)
#      self.name = "Vale"  →  camp.name = "Vale"
#      self.price = 120.00 →  camp.price = 120.00
```

**Key Points:**
- `self` is automatically passed by Python - you don't type it when calling!
- `self` represents the specific object the method is being called on
- `self.attribute` stores data **IN THE OBJECT** (not just in the method)

---

## 📝 Complete Example with Line-by-Line Explanation

Let's create a complete class and trace **exactly** what happens:

```python
class Campsite:
    """A campsite class."""
    
    def __init__(self, name, price):
        """Initialize the campsite."""
        print(f"🔧 __init__ starting for: {name}")
        print(f"   self is: {self}")
        
        self.name = name
        print(f"   ✅ Stored name: {name} into self.name")
        
        self.price = price
        print(f"   ✅ Stored price: {price} into self.price")
        
        print(f"🎉 __init__ done! Object is ready.")
    
    def display_info(self):
        """Display information."""
        print(f"📋 display_info called")
        print(f"   self is: {self}")
        print(f"   My name is: {self.name}")
        print(f"   My price is: R${self.price:.2f}")

# ==================== CREATE FIRST OBJECT ====================
print("="*60)
print("CREATING camp1:")
print("="*60)
camp1 = Campsite("Vale", 120.00)

# ==================== CREATE SECOND OBJECT ====================
print("\n" + "="*60)
print("CREATING camp2:")
print("="*60)
camp2 = Campsite("Serra", 80.00)

# ==================== CALL METHODS ====================
print("\n" + "="*60)
print("CALLING camp1.display_info():")
print("="*60)
camp1.display_info()

print("\n" + "="*60)
print("CALLING camp2.display_info():")
print("="*60)
camp2.display_info()

# ==================== THEY ARE INDEPENDENT ====================
print("\n" + "="*60)
print("PROOF THEY ARE INDEPENDENT:")
print("="*60)
print(f"camp1.name = {camp1.name}")
print(f"camp2.name = {camp2.name}")

camp1.name = "CHANGED!"
print(f"\nAfter changing camp1.name:")
print(f"camp1.name = {camp1.name}")
print(f"camp2.name = {camp2.name}")  # camp2 is NOT affected!
```

**Output:**
```
============================================================
CREATING camp1:
============================================================
🔧 __init__ starting for: Vale
   self is: <__main__.Campsite object at 0x7f8a9c1b2d30>
   ✅ Stored name: Vale into self.name
   ✅ Stored price: 120.0 into self.price
🎉 __init__ done! Object is ready.

============================================================
CREATING camp2:
============================================================
🔧 __init__ starting for: Serra
   self is: <__main__.Campsite object at 0x7f8a9c1b2e50>
   ✅ Stored name: Serra into self.name
   ✅ Stored price: 80.0 into self.price
🎉 __init__ done! Object is ready.

============================================================
CALLING camp1.display_info():
============================================================
📋 display_info called
   self is: <__main__.Campsite object at 0x7f8a9c1b2d30>
   My name is: Vale
   My price is: R$120.00

============================================================
CALLING camp2.display_info():
============================================================
📋 display_info called
   self is: <__main__.Campsite object at 0x7f8a9c1b2e50>
   My name is: Serra
   My price is: R$80.00

============================================================
PROOF THEY ARE INDEPENDENT:
============================================================
camp1.name = Vale
camp2.name = Serra

After changing camp1.name:
camp1.name = CHANGED!
camp2.name = Serra
```

**Notice:**
- `self` has **different memory addresses** for camp1 and camp2!
- When `display_info()` is called on camp1, `self` refers to camp1
- When `display_info()` is called on camp2, `self` refers to camp2
- Each object maintains its own data independently!

---

## 🎯 Practice Exercise: Test Your Understanding

Try to predict the output before running:

```python
class Product:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def apply_discount(self, percent):
        self.price = self.price * (1 - percent / 100)
        print(f"{self.name} new price: R${self.price:.2f}")

# Create products
tent = Product("Tent", 500.00)
backpack = Product("Backpack", 200.00)

# Apply discounts
tent.apply_discount(10)      # What's the output?
backpack.apply_discount(20)  # What's the output?

print(f"Tent: R${tent.price:.2f}")      # What's printed?
print(f"Backpack: R${backpack.price:.2f}")  # What's printed?
```

<details>
<summary>Click to see answer and explanation</summary>

**Output:**
```
Tent new price: R$450.00
Backpack new price: R$160.00
Tent: R$450.00
Backpack: R$160.00
```

**Explanation:**
1. `tent.apply_discount(10)`: 
   - `self` = tent object
   - `self.price` = 500.00
   - New price: 500 × (1 - 10/100) = 500 × 0.9 = 450.00
   - tent.price is now 450.00

2. `backpack.apply_discount(20)`:
   - `self` = backpack object (different object!)
   - `self.price` = 200.00
   - New price: 200 × (1 - 20/100) = 200 × 0.8 = 160.00
   - backpack.price is now 160.00

3. Each object maintains its own price!
</details>

---

## ✅ Key Takeaways

Before moving to the next part, make sure you understand:

1. ✅ **Class** = Template/Blueprint (defines structure)
2. ✅ **Object** = Instance (actual thing created from class)
3. ✅ **`__init__`** = Constructor (runs automatically when creating object)
4. ✅ **`self`** = "This object" (refers to the specific instance)
5. ✅ **Attributes** = Data stored in object (e.g., `self.name`)
6. ✅ **Each object is independent** (has its own copy of data)

**If any of these concepts is still unclear, re-read the sections above!**

---

## 🏗️ DEEP DIVE: Classes and Objects in Data Engineering

Now that you understand the basics, let's see **real data engineering examples** where classes are essential.

### Example 1: Database Connection Class

**Problem:** You need to connect to PostgreSQL many times in your data pipeline.

**❌ Without OOP (Messy!):**

```python
# Every time you need a connection, repeat all this code:
import psycopg2

# Connection 1
conn1 = psycopg2.connect(
    host="localhost",
    database="camping_db",
    user="postgres",
    password="secret123"
)
cursor1 = conn1.cursor()
cursor1.execute("SELECT * FROM campsites")
results1 = cursor1.fetchall()
cursor1.close()
conn1.close()

# Connection 2 - repeat everything!
conn2 = psycopg2.connect(
    host="localhost",
    database="camping_db",
    user="postgres",
    password="secret123"
)
cursor2 = conn2.cursor()
cursor2.execute("SELECT * FROM bookings")
results2 = cursor2.fetchall()
cursor2.close()
conn2.close()

# 😫 So much repetition!
```

**✅ With OOP (Clean!):**

```python
import psycopg2

class DatabaseConnection:
    """Reusable database connection class."""
    
    def __init__(self, host, database, user, password):
        """Initialize connection parameters."""
        print(f"🔧 Setting up connection to {database} on {host}")
        
        # Store connection parameters in THIS object
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.conn = None
        self.cursor = None
        
        print(f"✅ Connection object ready!")
    
    def connect(self):
        """Establish database connection."""
        print(f"📡 Connecting to {self.database}...")
        
        self.conn = psycopg2.connect(
            host=self.host,
            database=self.database,
            user=self.user,
            password=self.password
        )
        self.cursor = self.conn.cursor()
        
        print(f"✅ Connected to {self.database}")
    
    def execute_query(self, query):
        """Execute a SQL query."""
        print(f"🔍 Executing: {query[:50]}...")
        
        self.cursor.execute(query)
        results = self.cursor.fetchall()
        
        print(f"✅ Fetched {len(results)} rows")
        return results
    
    def close(self):
        """Close connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        
        print(f"🔒 Connection to {self.database} closed")

# ==================== USAGE ====================

# Create connection object (blueprint filled with data)
db = DatabaseConnection(
    host="localhost",
    database="camping_db",
    user="postgres",
    password="secret123"
)

# Connect
db.connect()

# Run multiple queries using the SAME connection object
campsites = db.execute_query("SELECT * FROM campsites")
bookings = db.execute_query("SELECT * FROM bookings")
customers = db.execute_query("SELECT * FROM customers")

# Close when done
db.close()

# ✨ Much cleaner! All connection logic in one reusable class!
```

**Why This is Better:**
- 📦 All connection logic in ONE place
- ♻️ Reusable across your entire project
- 🔧 Easy to modify (change once, affects all uses)
- 📖 Easy to understand and maintain

---

### Example 2: CSV File Reader Class

**Problem:** You need to read CSV files with different formats.

**❌ Without OOP:**

```python
import csv

# Reading customers.csv
with open('customers.csv', 'r') as f:
    reader = csv.DictReader(f)
    customers = list(reader)
    print(f"Loaded {len(customers)} customers")

# Reading bookings.csv - repeat similar code!
with open('bookings.csv', 'r') as f:
    reader = csv.DictReader(f)
    bookings = list(reader)
    print(f"Loaded {len(bookings)} bookings")

# Reading campsites.csv - repeat again!
with open('campsites.csv', 'r') as f:
    reader = csv.DictReader(f)
    campsites = list(reader)
    print(f"Loaded {len(campsites)} campsites")
```

**✅ With OOP:**

```python
import csv
from pathlib import Path
from datetime import datetime

class CSVReader:
    """Reusable CSV file reader for data engineering."""
    
    def __init__(self, file_path, encoding='utf-8'):
        """Initialize CSV reader.
        
        Args:
            file_path: Path to CSV file
            encoding: File encoding (default: utf-8)
        """
        print(f"📄 Setting up CSV reader for: {file_path}")
        
        self.file_path = Path(file_path)
        self.encoding = encoding
        self.data = []
        self.row_count = 0
        self.column_names = []
        
        # Validate file exists
        if not self.file_path.exists():
            raise FileNotFoundError(f"File not found: {file_path}")
        
        print(f"✅ CSV reader ready!")
    
    def load(self):
        """Load CSV data into memory."""
        print(f"📖 Loading data from {self.file_path.name}...")
        
        start_time = datetime.now()
        
        with open(self.file_path, 'r', encoding=self.encoding) as file:
            reader = csv.DictReader(file)
            
            # Store column names
            self.column_names = reader.fieldnames
            
            # Load all rows
            self.data = list(reader)
            self.row_count = len(self.data)
        
        elapsed = (datetime.now() - start_time).total_seconds()
        
        print(f"✅ Loaded {self.row_count} rows in {elapsed:.2f}s")
        print(f"   Columns: {', '.join(self.column_names)}")
        
        return self.data
    
    def get_row_count(self):
        """Get number of rows loaded."""
        return self.row_count
    
    def get_column_names(self):
        """Get list of column names."""
        return self.column_names
    
    def filter_by(self, column, value):
        """Filter data by column value.
        
        Args:
            column: Column name to filter on
            value: Value to match
        
        Returns:
            List of matching rows
        """
        filtered = [row for row in self.data if row.get(column) == value]
        print(f"🔍 Found {len(filtered)} rows where {column} = {value}")
        return filtered
    
    def get_unique_values(self, column):
        """Get unique values in a column.
        
        Args:
            column: Column name
        
        Returns:
            Set of unique values
        """
        values = set(row.get(column) for row in self.data)
        print(f"📊 Found {len(values)} unique values in '{column}'")
        return values
    
    def display_summary(self):
        """Display data summary."""
        print(f"\n{'='*60}")
        print(f"📊 CSV FILE SUMMARY: {self.file_path.name}")
        print(f"{'='*60}")
        print(f"Rows: {self.row_count}")
        print(f"Columns: {len(self.column_names)}")
        print(f"Column Names: {', '.join(self.column_names)}")
        
        if self.data:
            print(f"\nFirst Row Sample:")
            for key, value in list(self.data[0].items())[:5]:
                print(f"  {key}: {value}")
        
        print(f"{'='*60}\n")

# ==================== USAGE ====================

# Create CSV reader objects for different files
customers_reader = CSVReader('data/customers.csv')
bookings_reader = CSVReader('data/bookings.csv')
campsites_reader = CSVReader('data/campsites.csv')

# Load data
customers = customers_reader.load()
bookings = bookings_reader.load()
campsites = campsites_reader.load()

# Display summaries
customers_reader.display_summary()
bookings_reader.display_summary()
campsites_reader.display_summary()

# Use methods
ba_campsites = campsites_reader.filter_by('state', 'BA')
print(f"Campsites in BA: {len(ba_campsites)}")

states = campsites_reader.get_unique_values('state')
print(f"States with campsites: {states}")

# ✨ Each reader object is independent and tracks its own file!
```

**Why This is Better:**
- 📊 Each `CSVReader` object tracks its own file
- 🎯 Reusable for ANY CSV file
- 📈 Built-in analytics (filter, unique values, summary)
- ⚡ Easy to extend with more methods

---

### Example 3: Data Validator Class

**Problem:** You need to validate data quality before loading into database.

```python
class DataValidator:
    """Validates data quality for data engineering pipelines."""
    
    def __init__(self, data, required_columns):
        """Initialize validator.
        
        Args:
            data: List of dictionaries (rows)
            required_columns: List of required column names
        """
        print(f"🔍 Setting up data validator")
        
        self.data = data
        self.required_columns = required_columns
        self.errors = []
        self.warnings = []
        self.valid_count = 0
        self.invalid_count = 0
        
        print(f"✅ Validator ready! Will validate {len(data)} rows")
    
    def validate_all(self):
        """Run all validation checks."""
        print(f"\n{'='*60}")
        print(f"🔍 STARTING VALIDATION")
        print(f"{'='*60}\n")
        
        # Check each row
        for i, row in enumerate(self.data, 1):
            row_errors = []
            
            # Check required columns
            missing = self._check_required_columns(row)
            if missing:
                row_errors.append(f"Missing columns: {missing}")
            
            # Check for empty values
            empty = self._check_empty_values(row)
            if empty:
                row_errors.append(f"Empty values: {empty}")
            
            # Check data types (example: price should be numeric)
            if 'price' in row:
                if not self._is_numeric(row['price']):
                    row_errors.append(f"Price not numeric: {row['price']}")
            
            # Record results
            if row_errors:
                self.invalid_count += 1
                self.errors.append({
                    'row': i,
                    'data': row,
                    'errors': row_errors
                })
            else:
                self.valid_count += 1
        
        # Display results
        self._display_results()
        
        return self.valid_count, self.invalid_count
    
    def _check_required_columns(self, row):
        """Check if all required columns are present."""
        missing = [col for col in self.required_columns if col not in row]
        return missing
    
    def _check_empty_values(self, row):
        """Check for empty or null values."""
        empty = [col for col, val in row.items() 
                if val is None or str(val).strip() == '']
        return empty
    
    def _is_numeric(self, value):
        """Check if value is numeric."""
        try:
            float(value)
            return True
        except (ValueError, TypeError):
            return False
    
    def _display_results(self):
        """Display validation results."""
        print(f"\n{'='*60}")
        print(f"✅ VALIDATION COMPLETE")
        print(f"{'='*60}")
        print(f"Total rows: {len(self.data)}")
        print(f"✅ Valid rows: {self.valid_count}")
        print(f"❌ Invalid rows: {self.invalid_count}")
        
        if self.errors:
            print(f"\n⚠️  ERRORS FOUND:")
            for error in self.errors[:5]:  # Show first 5
                print(f"\n  Row {error['row']}:")
                for err in error['errors']:
                    print(f"    • {err}")
        
        print(f"{'='*60}\n")
    
    def get_valid_data(self):
        """Get only valid rows."""
        if not self.errors:
            return self.data
        
        invalid_indices = {err['row'] - 1 for err in self.errors}
        valid_data = [row for i, row in enumerate(self.data) 
                     if i not in invalid_indices]
        
        print(f"📊 Returning {len(valid_data)} valid rows")
        return valid_data
    
    def get_invalid_data(self):
        """Get only invalid rows."""
        return [err['data'] for err in self.errors]

# ==================== USAGE ====================

# Sample data with issues
data = [
    {'name': 'Camping Vale', 'state': 'BA', 'price': '120.00'},
    {'name': 'Serra', 'state': '', 'price': '80.00'},  # Missing state
    {'name': '', 'state': 'RJ', 'price': '100.00'},    # Missing name
    {'name': 'Praia', 'state': 'SC', 'price': 'FREE'}, # Invalid price
    {'name': 'Monte', 'state': 'MG', 'price': '90.00'},
]

# Create validator
validator = DataValidator(
    data=data,
    required_columns=['name', 'state', 'price']
)

# Run validation
valid_count, invalid_count = validator.validate_all()

# Get clean data
clean_data = validator.get_valid_data()
print(f"✅ Ready to load {len(clean_data)} clean rows into database")

# Get problematic data for review
bad_data = validator.get_invalid_data()
print(f"⚠️  Need to fix {len(bad_data)} problematic rows")
```

**Why This is Better:**
- 🔍 Comprehensive validation logic in one place
- 📊 Tracks validation statistics
- 🎯 Separates valid from invalid data
- ♻️ Reusable for any dataset

---

## 🧠 DEEPER UNDERSTANDING: Why `self` is Not Optional

Let's see what happens when you forget `self`:

```python
# ❌ WRONG: Forgot self in method definition
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def display_info():  # ❌ Missing self!
        print(f"Name: {self.name}")  # This will fail!
        print(f"Price: {self.price}")

camp = Campsite("Vale", 120.00)
# camp.display_info()  # ❌ TypeError: display_info() takes 0 positional arguments but 1 was given

# Why? Because Python does this:
# Campsite.display_info(camp)  ← Python passes 'camp' but method expects 0 args!


# ✅ CORRECT: With self
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def display_info(self):  # ✅ Has self!
        print(f"Name: {self.name}")
        print(f"Price: {self.price}")

camp = Campsite("Vale", 120.00)
camp.display_info()  # ✅ Works! Python passes 'camp' as 'self'
```

---

## 🎯 MEMORY VISUALIZATION: How Objects are Stored

Let's visualize what happens in memory:

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price

# Create objects
camp1 = Campsite("Vale", 120.00)
camp2 = Campsite("Serra", 80.00)

print(f"camp1 memory address: {id(camp1)}")  # e.g., 140234567890123
print(f"camp2 memory address: {id(camp2)}")  # e.g., 140234567891456
# ☝️ Different addresses = different objects in memory!

# Memory visualization:
#
# ┌─────────────────────────┐
# │ MEMORY LOCATION:        │
# │ 140234567890123         │  ← camp1 stored here
# ├─────────────────────────┤
# │ Campsite Object         │
# │ • name: "Vale"          │
# │ • price: 120.00         │
# └─────────────────────────┘
#
# ┌─────────────────────────┐
# │ MEMORY LOCATION:        │
# │ 140234567891456         │  ← camp2 stored here
# ├─────────────────────────┤
# │ Campsite Object         │
# │ • name: "Serra"         │
# │ • price: 80.00          │
# └─────────────────────────┘
#
# They are COMPLETELY SEPARATE in memory!

# Changing one doesn't affect the other
camp1.price = 200.00
print(f"camp1.price: {camp1.price}")  # 200.00
print(f"camp2.price: {camp2.price}")  # 80.00 (unchanged!)
```

---

**If any of these concepts is still unclear, re-read the sections above!**

---

**Next:** Part 2 will cover Instance Methods in detail (coming next)

---

## 🎯 Part 2: Understanding Instance Methods

### 🤔 What is a Method?

A **method** is a **function that belongs to a class**.

**Simple Analogy:**
- A **function** is like a **standalone tool** (a hammer you carry in your hand)
- A **method** is like a **tool attached to a machine** (a drill attached to a robot)

**In Python:**

```python
# This is a FUNCTION (standalone)
def calculate_total(price, nights):
    return price * nights

# This is a METHOD (attached to a class)
class Campsite:
    def calculate_total(self, nights):
        return self.price * nights
```

###🔍 Difference Between Function and Method

```python
# ==================== FUNCTION ====================
# Standalone - not attached to anything

def calculate_total(price, nights):
    """A regular function."""
    return price * nights

# Call it directly
result = calculate_total(120.00, 3)  # 360.00
print(f"Total: R${result:.2f}")


# ==================== METHOD ====================
# Attached to a class - works with object's data

class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def calculate_total(self, nights):
        """A method - has access to self.price!"""
        return self.price * nights

# Create object
camp = Campsite("Vale", 120.00)

# Call method ON the object
result = camp.calculate_total(3)  # Uses camp.price (120.00)
print(f"Total: R${result:.2f}")
```

**Key Difference:**
- **Function**: You must pass ALL data as parameters
- **Method**: Has access to the object's data through `self`!

---

### 📝 Understanding Instance Methods Step-by-Step

**Instance method** = A function inside a class that works with **self** (a specific object).

#### **Step 1: Simple Method**

```python
class Campsite:
    def __init__(self, name):
        self.name = name
    
    def greet(self):
        """Simple method that uses self."""
        print(f"Hello from {self.name}!")
        #                   ^^^^^^^^^^
        #                   Access this object's name

# Create object
camp = Campsite("Camping Vale")

# Call method
camp.greet()  # Hello from Camping Vale!

# What Python does:
# Campsite.greet(camp)  ← Python passes 'camp' as 'self' automatically!
```

#### **Step 2: Method That Takes Parameters**

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def calculate_total(self, nights):
        """Method with parameters.
        
        Args:
            nights: Number of nights (we pass this)
        
        Uses:
            self.price: Price per night (from the object)
        """
        total = self.price * nights
        return total

# Create object
camp = Campsite("Vale", 120.00)

# Call method with parameter
cost_3_nights = camp.calculate_total(3)     # Pass 3 nights
cost_7_nights = camp.calculate_total(7)     # Pass 7 nights

print(f"3 nights: R${cost_3_nights:.2f}")   # 360.00
print(f"7 nights: R${cost_7_nights:.2f}")   # 840.00
```

**What happens when you call `camp.calculate_total(3)`:**

```python
# You write:
camp.calculate_total(3)

# Python does:
Campsite.calculate_total(camp, 3)
#                        ^^^^  ^
#                        self  nights
#
# Inside the method:
#   self = camp  (the object)
#   nights = 3   (what you passed)
#   self.price = 120.00  (from the object)
#   total = 120.00 * 3 = 360.00
#   return 360.00
```

#### **Step 3: Method That Modifies the Object**

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def apply_discount(self, percent):
        """Method that CHANGES the object's data.
        
        Args:
            percent: Discount percentage (e.g., 10 for 10%)
        """
        print(f"Original price: R${self.price:.2f}")
        
        # Calculate discount amount
        discount_amount = self.price * (percent / 100)
        print(f"Discount ({percent}%): R${discount_amount:.2f}")
        
        # Modify THIS object's price
        self.price = self.price - discount_amount
        print(f"New price: R${self.price:.2f}")

# Create object
camp = Campsite("Vale", 120.00)

print(f"Before discount: R${camp.price:.2f}")  # 120.00

# Apply 10% discount
camp.apply_discount(10)

print(f"After discount: R${camp.price:.2f}")   # 108.00

# The object's data was permanently changed!
```

**Output:**
```
Before discount: R$120.00
Original price: R$120.00
Discount (10%): R$12.00
New price: R$108.00
After discount: R$108.00
```

#### **Step 4: Multiple Methods Working Together**

```python
class Campsite:
    def __init__(self, name, price, capacity):
        self.name = name
        self.price = price
        self.capacity = capacity
    
    def calculate_total(self, nights):
        """Calculate total cost."""
        return self.price * nights
    
    def apply_discount(self, percent):
        """Apply discount to price."""
        self.price = self.price * (1 - percent / 100)
    
    def is_available_for(self, group_size):
        """Check if campsite can accommodate group."""
        return group_size <= self.capacity
    
    def display_info(self):
        """Display all information."""
        print(f"{'='*50}")
        print(f"📍 {self.name}")
        print(f"   Price: R${self.price:.2f}/night")
        print(f"   Capacity: {self.capacity} people")
        print(f"{'='*50}")

# Create campsite
camp = Campsite("Camping Vale", 120.00, 30)

# Use different methods
camp.display_info()

# Check availability
if camp.is_available_for(25):
    print("✅ Available for group of 25!")
    
    # Calculate cost
    total = camp.calculate_total(3)
    print(f"💰 Cost for 3 nights: R${total:.2f}")
    
    # Apply discount
    camp.apply_discount(10)
    print(f"After 10% discount: R${camp.price:.2f}/night")
    
    # Recalculate
    new_total = camp.calculate_total(3)
    print(f"💰 New cost for 3 nights: R${new_total:.2f}")
else:
    print("❌ Not available for group of 25")
```

**Output:**
```
==================================================
📍 Camping Vale
   Price: R$120.00/night
   Capacity: 30 people
==================================================
✅ Available for group of 25!
💰 Cost for 3 nights: R$360.00
After 10% discount: R$108.00/night
💰 New cost for 3 nights: R$324.00
```

---

### 🎯 Complete Real-World Example

Let's create a complete example that shows everything we've learned:

```python
class Campsite:
    """A campsite for outdoor adventures."""
    
    def __init__(self, name, state, price, capacity):
        """Initialize campsite with all details."""
        print(f"🏕️  Creating campsite: {name}")
        
        self.name = name
        self.state = state
        self.price = price
        self.capacity = capacity
        self.is_open = True  # Default: campsite is open
        
        print(f"✅ Campsite ready!")
    
    # ========== CALCULATION METHODS ==========
    
    def calculate_total(self, nights, num_people):
        """Calculate total cost for a booking.
        
        Args:
            nights: Number of nights
            num_people: Number of people
        
        Returns:
            Total cost
        """
        cost_per_night = self.price * num_people
        total = cost_per_night * nights
        return total
    
    def calculate_discount(self, nights):
        """Calculate discount based on length of stay.
        
        Args:
            nights: Number of nights
        
        Returns:
            Discount percentage
        """
        if nights >= 7:
            return 15  # 15% discount for week+
        elif nights >= 3:
            return 10  # 10% discount for 3+ nights
        else:
            return 0   # No discount
    
    # ========== VALIDATION METHODS ==========
    
    def is_available_for(self, num_people):
        """Check if campsite can accommodate group.
        
        Args:
            num_people: Number of people in group
        
        Returns:
            True if available, False otherwise
        """
        if not self.is_open:
            return False
        
        return num_people <= self.capacity
    
    def can_book(self, nights, num_people):
        """Check if booking is possible.
        
        Args:
            nights: Number of nights
            num_people: Number of people
        
        Returns:
            (bool, str): (Can book?, Reason if not)
        """
        if not self.is_open:
            return False, "Campsite is closed"
        
        if num_people > self.capacity:
            return False, f"Too many people (max {self.capacity})"
        
        if nights < 1:
            return False, "Must book at least 1 night"
        
        return True, "Booking available"
    
    # ========== MODIFICATION METHODS ==========
    
    def apply_discount(self, percent):
        """Apply discount to base price.
        
        Args:
            percent: Discount percentage
        """
        old_price = self.price
        self.price = self.price * (1 - percent / 100)
        saved = old_price - self.price
        
        print(f"💰 Applied {percent}% discount")
        print(f"   Old price: R${old_price:.2f}")
        print(f"   New price: R${self.price:.2f}")
        print(f"   You save: R${saved:.2f}")
    
    def close_temporarily(self):
        """Close the campsite."""
        self.is_open = False
        print(f"🔒 {self.name} is now closed")
    
    def reopen(self):
        """Reopen the campsite."""
        self.is_open = True
        print(f"🔓 {self.name} is now open")
    
    # ========== DISPLAY METHODS ==========
    
    def display_info(self):
        """Display detailed campsite information."""
        status = "🟢 OPEN" if self.is_open else "🔴 CLOSED"
        
        print(f"\n{'='*60}")
        print(f"📍 {self.name} ({self.state}) - {status}")
        print(f"{'='*60}")
        print(f"💰 Price: R${self.price:.2f} per person/night")
        print(f"👥 Capacity: {self.capacity} people")
        print(f"{'='*60}\n")
    
    def get_quote(self, nights, num_people):
        """Get a price quote for a booking.
        
        Args:
            nights: Number of nights
            num_people: Number of people
        """
        print(f"\n{'='*60}")
        print(f"💰 PRICE QUOTE - {self.name}")
        print(f"{'='*60}")
        
        # Check if booking is possible
        can_book, reason = self.can_book(nights, num_people)
        
        if not can_book:
            print(f"❌ Cannot book: {reason}")
            print(f"{'='*60}\n")
            return
        
        # Calculate base cost
        base_total = self.calculate_total(nights, num_people)
        
        # Calculate discount
        discount_percent = self.calculate_discount(nights)
        
        print(f"Group size: {num_people} people")
        print(f"Duration: {nights} nights")
        print(f"Price per person/night: R${self.price:.2f}")
        print(f"-" * 60)
        print(f"Subtotal: R${base_total:.2f}")
        
        if discount_percent > 0:
            discount_amount = base_total * (discount_percent / 100)
            final_total = base_total - discount_amount
            
            print(f"Discount ({discount_percent}%): -R${discount_amount:.2f} 🎉")
            print(f"-" * 60)
            print(f"✅ TOTAL: R${final_total:.2f}")
        else:
            print(f"Discount: R$0.00")
            print(f"-" * 60)
            print(f"✅ TOTAL: R${base_total:.2f}")
        
        print(f"{'='*60}\n")


# ==================== DEMO ====================

# Create campsite
camp = Campsite("Camping Vale do Pati", "BA", 45.00, 30)

# Display info
camp.display_info()

# Get quotes for different scenarios
print("SCENARIO 1: Weekend trip")
camp.get_quote(nights=2, num_people=4)

print("SCENARIO 2: Week-long trip (discount applies!)")
camp.get_quote(nights=7, num_people=4)

print("SCENARIO 3: Too many people")
camp.get_quote(nights=3, num_people=35)

# Apply general discount
camp.apply_discount(5)

# Get new quote
print("SCENARIO 4: After 5% discount")
camp.get_quote(nights=3, num_people=4)

# Close campsite
camp.close_temporarily()

# Try to book while closed
print("SCENARIO 5: While closed")
camp.get_quote(nights=2, num_people=4)

# Reopen
camp.reopen()
```

**This example demonstrates:**
1. ✅ Multiple methods with different purposes
2. ✅ Methods that calculate values
3. ✅ Methods that validate data
4. ✅ Methods that modify the object
5. ✅ Methods that display information
6. ✅ Methods calling other methods
7. ✅ Real-world logic and edge cases

---

## 🎯 Practice Exercise: Build Your Own Class

Try creating a `Booking` class with these requirements:

```python
class Booking:
    """Represents a campsite booking."""
    
    def __init__(self, customer_name, campsite_name, nights, num_people):
        # Store booking details
        pass
    
    def calculate_total(self, price_per_person_night):
        # Calculate total cost
        pass
    
    def add_extra_night(self):
        # Add one more night
        pass
    
    def add_person(self):
        # Add one more person (if capacity allows)
        pass
    
    def display_summary(self):
        # Show booking summary
        pass

# Test it:
booking = Booking("João Silva", "Camping Vale", 3, 4)
booking.display_summary()
total = booking.calculate_total(45.00)
booking.add_extra_night()
booking.display_summary()
```

<details>
<summary>Click to see solution</summary>

```python
class Booking:
    """Represents a campsite booking."""
    
    def __init__(self, customer_name, campsite_name, nights, num_people):
        """Initialize booking."""
        self.customer_name = customer_name
        self.campsite_name = campsite_name
        self.nights = nights
        self.num_people = num_people
        
        print(f"✅ Booking created for {customer_name}")
    
    def calculate_total(self, price_per_person_night):
        """Calculate total cost."""
        return price_per_person_night * self.num_people * self.nights
    
    def add_extra_night(self):
        """Add one more night."""
        self.nights += 1
        print(f"✅ Added 1 night. Total nights: {self.nights}")
    
    def add_person(self):
        """Add one more person."""
        self.num_people += 1
        print(f"✅ Added 1 person. Total people: {self.num_people}")
    
    def display_summary(self):
        """Show booking summary."""
        print(f"\n{'='*50}")
        print(f"📋 BOOKING SUMMARY")
        print(f"{'='*50}")
        print(f"Customer: {self.customer_name}")
        print(f"Campsite: {self.campsite_name}")
        print(f"Nights: {self.nights}")
        print(f"People: {self.num_people}")
        print(f"{'='*50}\n")

# Test
booking = Booking("João Silva", "Camping Vale", 3, 4)
booking.display_summary()

total = booking.calculate_total(45.00)
print(f"Total cost: R${total:.2f}\n")

booking.add_extra_night()
booking.add_person()
booking.display_summary()

new_total = booking.calculate_total(45.00)
print(f"New total cost: R${new_total:.2f}")
```

</details>

---

## ✅ Key Takeaways - Part 2

Make sure you understand:

1. ✅ **Method** = Function inside a class
2. ✅ **Instance method** = Method that works with `self` (a specific object)
3. ✅ Methods can **access object's data** through `self`
4. ✅ Methods can **modify object's data** by changing `self.attribute`
5. ✅ Methods can **call other methods** using `self.other_method()`
6. ✅ Methods can **return values** just like functions
7. ✅ Methods can **take parameters** (after `self`)
8. ✅ **DATA ENGINEERING**: Use classes for ETL pipelines, data quality monitoring, log analysis
9. ✅ **REAL-WORLD**: Classes encapsulate complex workflows (extract, transform, load)
10. ✅ **ADVANCED**: Method chaining creates fluent, readable APIs

---

## 🏗️ DEEP DIVE: Methods in Data Engineering

Let's see more advanced data engineering examples where methods are essential.

### Example 1: ETL Pipeline Class

**ETL = Extract, Transform, Load** (core data engineering pattern)

```python
import csv
from pathlib import Path
from datetime import datetime
import psycopg2

class ETLPipeline:
    """Extract, Transform, Load pipeline for campsite data."""
    
    def __init__(self, source_file, db_config):
        """Initialize ETL pipeline.
        
        Args:
            source_file: Path to CSV file
            db_config: Dict with database connection info
        """
        print(f"🚀 Initializing ETL Pipeline")
        
        self.source_file = Path(source_file)
        self.db_config = db_config
        self.raw_data = []
        self.transformed_data = []
        self.load_count = 0
        self.error_count = 0
        self.start_time = None
        self.end_time = None
        
        print(f"✅ Pipeline ready!")
        print(f"   Source: {self.source_file}")
        print(f"   Target DB: {self.db_config['database']}")
    
    def extract(self):
        """EXTRACT: Read data from CSV file."""
        print(f"\n{'='*60}")
        print(f"📥 STEP 1: EXTRACTING DATA")
        print(f"{'='*60}")
        
        self.start_time = datetime.now()
        
        try:
            with open(self.source_file, 'r') as file:
                reader = csv.DictReader(file)
                self.raw_data = list(reader)
            
            print(f"✅ Extracted {len(self.raw_data)} rows from {self.source_file.name}")
            return True
        
        except Exception as e:
            print(f"❌ Extract failed: {e}")
            return False
    
    def transform(self):
        """TRANSFORM: Clean and validate data."""
        print(f"\n{'='*60}")
        print(f"🔄 STEP 2: TRANSFORMING DATA")
        print(f"{'='*60}")
        
        for row in self.raw_data:
            try:
                # Transformation logic
                transformed_row = {
                    'name': self._clean_text(row['name']),
                    'state': self._validate_state(row['state']),
                    'price': self._parse_price(row['price']),
                    'capacity': self._parse_integer(row.get('capacity', '0')),
                    'is_active': self._parse_boolean(row.get('is_active', 'true')),
                    'created_at': datetime.now()
                }
                
                # Validate transformed row
                if self._validate_row(transformed_row):
                    self.transformed_data.append(transformed_row)
                else:
                    self.error_count += 1
                    print(f"⚠️  Skipping invalid row: {row}")
            
            except Exception as e:
                self.error_count += 1
                print(f"⚠️  Error transforming row: {e}")
        
        print(f"✅ Transformed {len(self.transformed_data)} rows")
        print(f"⚠️  Errors: {self.error_count}")
        
        return len(self.transformed_data) > 0
    
    def load(self):
        """LOAD: Insert data into database."""
        print(f"\n{'='*60}")
        print(f"📤 STEP 3: LOADING DATA")
        print(f"{'='*60}")
        
        try:
            # Connect to database
            conn = psycopg2.connect(**self.db_config)
            cursor = conn.cursor()
            
            # Insert each row
            for row in self.transformed_data:
                try:
                    cursor.execute("""
                        INSERT INTO campsites (name, state, price_per_night, capacity, is_active, created_at)
                        VALUES (%(name)s, %(state)s, %(price)s, %(capacity)s, %(is_active)s, %(created_at)s)
                    """, row)
                    
                    self.load_count += 1
                
                except Exception as e:
                    print(f"⚠️  Error loading row: {e}")
                    self.error_count += 1
            
            # Commit changes
            conn.commit()
            cursor.close()
            conn.close()
            
            self.end_time = datetime.now()
            
            print(f"✅ Loaded {self.load_count} rows into database")
            return True
        
        except Exception as e:
            print(f"❌ Load failed: {e}")
            return False
    
    def run(self):
        """Run the complete ETL pipeline."""
        print(f"\n{'='*70}")
        print(f"🚀 STARTING ETL PIPELINE: {self.source_file.name}")
        print(f"{'='*70}")
        
        # Run all steps
        if not self.extract():
            return False
        
        if not self.transform():
            return False
        
        if not self.load():
            return False
        
        # Display final summary
        self._display_summary()
        
        return True
    
    # ========== HELPER METHODS (called by main methods) ==========
    
    def _clean_text(self, text):
        """Clean and normalize text."""
        return text.strip().title()
    
    def _validate_state(self, state):
        """Validate Brazilian state code."""
        valid_states = ['BA', 'RJ', 'MG', 'RS', 'SP', 'SC', 'PR']
        state = state.strip().upper()
        
        if state not in valid_states:
            raise ValueError(f"Invalid state: {state}")
        
        return state
    
    def _parse_price(self, price_str):
        """Parse price string to float."""
        # Remove R$, commas, etc.
        cleaned = price_str.replace('R$', '').replace(',', '').strip()
        return float(cleaned)
    
    def _parse_integer(self, value):
        """Parse integer value."""
        return int(value) if value else 0
    
    def _parse_boolean(self, value):
        """Parse boolean value."""
        return str(value).lower() in ['true', 'yes', '1', 't']
    
    def _validate_row(self, row):
        """Validate transformed row."""
        # Check required fields
        if not row['name']:
            return False
        
        if not row['state']:
            return False
        
        if row['price'] <= 0:
            return False
        
        return True
    
    def _display_summary(self):
        """Display pipeline summary."""
        elapsed = (self.end_time - self.start_time).total_seconds()
        
        print(f"\n{'='*70}")
        print(f"📊 ETL PIPELINE SUMMARY")
        print(f"{'='*70}")
        print(f"Source: {self.source_file}")
        print(f"Target DB: {self.db_config['database']}")
        print(f"\n📥 Extract: {len(self.raw_data)} rows")
        print(f"🔄 Transform: {len(self.transformed_data)} rows")
        print(f"📤 Load: {self.load_count} rows")
        print(f"⚠️  Errors: {self.error_count}")
        print(f"⏱️  Time: {elapsed:.2f} seconds")
        print(f"{'='*70}\n")

# ==================== USAGE ====================

# Database configuration
db_config = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'secret123'
}

# Create and run pipeline
pipeline = ETLPipeline(
    source_file='data/new_campsites.csv',
    db_config=db_config
)

success = pipeline.run()

if success:
    print("✅ ETL Pipeline completed successfully!")
else:
    print("❌ ETL Pipeline failed!")

# ✨ All ETL logic organized in one class with clear methods!
```

**Why This is Better:**
- 📦 All ETL logic in one reusable class
- 🔄 Clear separation of Extract → Transform → Load steps
- 🎯 Helper methods for data cleaning/validation
- 📊 Built-in tracking and summary
- ♻️ Reusable for different files/databases

---

### Example 2: Data Quality Monitor Class

```python
from datetime import datetime, timedelta
from collections import Counter
import psycopg2

class DataQualityMonitor:
    """Monitor data quality metrics for data engineering."""
    
    def __init__(self, db_config):
        """Initialize quality monitor."""
        print(f"🔍 Initializing Data Quality Monitor")
        
        self.db_config = db_config
        self.conn = None
        self.cursor = None
        self.metrics = {}
        self.issues = []
        
        print(f"✅ Monitor ready!")
    
    def connect(self):
        """Connect to database."""
        print(f"📡 Connecting to database...")
        
        self.conn = psycopg2.connect(**self.db_config)
        self.cursor = self.conn.cursor()
        
        print(f"✅ Connected!")
    
    def check_null_values(self, table, column):
        """Check for NULL values in column."""
        print(f"🔍 Checking NULLs in {table}.{column}...")
        
        # Count total rows
        self.cursor.execute(f"SELECT COUNT(*) FROM {table}")
        total = self.cursor.fetchone()[0]
        
        # Count NULL rows
        self.cursor.execute(f"SELECT COUNT(*) FROM {table} WHERE {column} IS NULL")
        null_count = self.cursor.fetchone()[0]
        
        null_pct = (null_count / total * 100) if total > 0 else 0
        
        metric = {
            'check': 'null_values',
            'table': table,
            'column': column,
            'total_rows': total,
            'null_count': null_count,
            'null_percentage': null_pct,
            'status': 'PASS' if null_pct < 5 else 'FAIL',
            'checked_at': datetime.now()
        }
        
        self.metrics[f"{table}.{column}_nulls"] = metric
        
        if metric['status'] == 'FAIL':
            self.issues.append(f"⚠️  {table}.{column}: {null_pct:.1f}% NULL values")
        
        print(f"   Total: {total}, NULLs: {null_count} ({null_pct:.1f}%)")
        print(f"   Status: {metric['status']}")
        
        return metric
    
    def check_duplicates(self, table, columns):
        """Check for duplicate records."""
        print(f"🔍 Checking duplicates in {table} on {columns}...")
        
        columns_str = ', '.join(columns)
        
        # Find duplicates
        query = f"""
            SELECT {columns_str}, COUNT(*) as count
            FROM {table}
            GROUP BY {columns_str}
            HAVING COUNT(*) > 1
        """
        
        self.cursor.execute(query)
        duplicates = self.cursor.fetchall()
        
        metric = {
            'check': 'duplicates',
            'table': table,
            'columns': columns,
            'duplicate_count': len(duplicates),
            'status': 'PASS' if len(duplicates) == 0 else 'FAIL',
            'checked_at': datetime.now()
        }
        
        self.metrics[f"{table}_duplicates"] = metric
        
        if metric['status'] == 'FAIL':
            self.issues.append(f"⚠️  {table}: {len(duplicates)} duplicate records found")
        
        print(f"   Duplicates: {len(duplicates)}")
        print(f"   Status: {metric['status']}")
        
        return metric
    
    def check_referential_integrity(self, child_table, child_column, 
                                   parent_table, parent_column):
        """Check foreign key integrity."""
        print(f"🔍 Checking referential integrity: {child_table}.{child_column} → {parent_table}.{parent_column}...")
        
        query = f"""
            SELECT COUNT(*)
            FROM {child_table} c
            LEFT JOIN {parent_table} p ON c.{child_column} = p.{parent_column}
            WHERE p.{parent_column} IS NULL
            AND c.{child_column} IS NOT NULL
        """
        
        self.cursor.execute(query)
        orphan_count = self.cursor.fetchone()[0]
        
        metric = {
            'check': 'referential_integrity',
            'child_table': child_table,
            'child_column': child_column,
            'parent_table': parent_table,
            'parent_column': parent_column,
            'orphan_count': orphan_count,
            'status': 'PASS' if orphan_count == 0 else 'FAIL',
            'checked_at': datetime.now()
        }
        
        key = f"{child_table}.{child_column}_ref"
        self.metrics[key] = metric
        
        if metric['status'] == 'FAIL':
            self.issues.append(f"⚠️  {orphan_count} orphaned records in {child_table}")
        
        print(f"   Orphaned records: {orphan_count}")
        print(f"   Status: {metric['status']}")
        
        return metric
    
    def check_data_freshness(self, table, timestamp_column, max_age_hours=24):
        """Check if data is fresh (recently updated)."""
        print(f"🔍 Checking data freshness in {table}.{timestamp_column}...")
        
        query = f"""
            SELECT MAX({timestamp_column}) as latest
            FROM {table}
        """
        
        self.cursor.execute(query)
        result = self.cursor.fetchone()
        latest = result[0] if result else None
        
        if latest:
            age = datetime.now() - latest
            age_hours = age.total_seconds() / 3600
            is_fresh = age_hours <= max_age_hours
        else:
            age_hours = float('inf')
            is_fresh = False
        
        metric = {
            'check': 'data_freshness',
            'table': table,
            'column': timestamp_column,
            'latest_timestamp': latest,
            'age_hours': age_hours,
            'max_age_hours': max_age_hours,
            'status': 'PASS' if is_fresh else 'FAIL',
            'checked_at': datetime.now()
        }
        
        self.metrics[f"{table}_freshness"] = metric
        
        if metric['status'] == 'FAIL':
            self.issues.append(f"⚠️  {table}: Data is {age_hours:.1f} hours old (max: {max_age_hours}h)")
        
        print(f"   Latest: {latest}")
        print(f"   Age: {age_hours:.1f} hours")
        print(f"   Status: {metric['status']}")
        
        return metric
    
    def run_all_checks(self):
        """Run comprehensive quality checks."""
        print(f"\n{'='*60}")
        print(f"🔍 RUNNING ALL DATA QUALITY CHECKS")
        print(f"{'='*60}\n")
        
        # Check various tables
        self.check_null_values('campsites', 'name')
        self.check_null_values('campsites', 'state')
        self.check_null_values('bookings', 'customer_id')
        
        self.check_duplicates('campsites', ['name', 'state'])
        self.check_duplicates('customers', ['email'])
        
        self.check_referential_integrity('bookings', 'campsite_id', 'campsites', 'id')
        self.check_referential_integrity('bookings', 'customer_id', 'customers', 'id')
        
        self.check_data_freshness('bookings', 'created_at', max_age_hours=24)
        
        # Display summary
        self._display_summary()
    
    def _display_summary(self):
        """Display quality check summary."""
        passed = sum(1 for m in self.metrics.values() if m['status'] == 'PASS')
        failed = sum(1 for m in self.metrics.values() if m['status'] == 'FAIL')
        
        print(f"\n{'='*60}")
        print(f"📊 DATA QUALITY SUMMARY")
        print(f"{'='*60}")
        print(f"Total Checks: {len(self.metrics)}")
        print(f"✅ Passed: {passed}")
        print(f"❌ Failed: {failed}")
        
        if self.issues:
            print(f"\n⚠️  ISSUES FOUND:")
            for issue in self.issues:
                print(f"   {issue}")
        else:
            print(f"\n✅ No issues found! Data quality is good.")
        
        print(f"{'='*60}\n")
    
    def get_metrics_summary(self):
        """Get summary of all metrics."""
        return {
            'total_checks': len(self.metrics),
            'passed': sum(1 for m in self.metrics.values() if m['status'] == 'PASS'),
            'failed': sum(1 for m in self.metrics.values() if m['status'] == 'FAIL'),
            'issues': self.issues,
            'metrics': self.metrics
        }
    
    def close(self):
        """Close database connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        
        print(f"🔒 Monitor connection closed")

# ==================== USAGE ====================

db_config = {
    'host': 'localhost',
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'secret123'
}

# Create monitor
monitor = DataQualityMonitor(db_config)

# Connect and run checks
monitor.connect()
monitor.run_all_checks()

# Get summary
summary = monitor.get_metrics_summary()
print(f"Quality Score: {summary['passed']}/{summary['total_checks']} checks passed")

# Close
monitor.close()
```

**Why This is Better:**
- 🔍 Comprehensive quality checks
- 📊 Tracks all metrics and issues
- 🎯 Reusable across different tables
- ♻️ Easy to add new check methods

---

### Example 3: Method Chaining Pattern

Methods can return `self` to enable chaining:

```python
class DataPipeline:
    """Data pipeline with method chaining."""
    
    def __init__(self):
        self.data = []
        self.filters_applied = []
    
    def load_data(self, data):
        """Load data."""
        self.data = data
        print(f"✅ Loaded {len(data)} rows")
        return self  # Return self for chaining!
    
    def filter_by_state(self, state):
        """Filter by state."""
        self.data = [row for row in self.data if row['state'] == state]
        self.filters_applied.append(f"state={state}")
        print(f"✅ Filtered to {len(self.data)} rows (state={state})")
        return self  # Return self for chaining!
    
    def filter_by_price(self, max_price):
        """Filter by price."""
        self.data = [row for row in self.data if float(row['price']) <= max_price]
        self.filters_applied.append(f"price<={max_price}")
        print(f"✅ Filtered to {len(self.data)} rows (price<={max_price})")
        return self  # Return self for chaining!
    
    def get_results(self):
        """Get filtered results."""
        print(f"📊 Applied filters: {', '.join(self.filters_applied)}")
        return self.data

# METHOD CHAINING
data = [
    {'name': 'Vale', 'state': 'BA', 'price': '120.00'},
    {'name': 'Serra', 'state': 'BA', 'price': '80.00'},
    {'name': 'Praia', 'state': 'RJ', 'price': '150.00'},
]

# Chain methods together!
results = (DataPipeline()
           .load_data(data)
           .filter_by_state('BA')
           .filter_by_price(100)
           .get_results())

# ✨ Clean, readable, fluent API!
```

**If any concept is still unclear, re-read the relevant section!**

---

## ✅ Key Takeaways - Part 2

**If any concept is still unclear, re-read the relevant section!**

---

## 📚 Part 3: Class Attributes and Methods

### 🤔 What's the Difference?

So far, we've seen **instance attributes** (like `self.name`) and **instance methods** (like `def calculate_total(self)`).

But there's another type: **Class attributes** and **Class methods**!

### 📊 Visual Comparison

```
INSTANCE vs CLASS

┌─────────────────────────────────────────────────────────────┐
│ INSTANCE ATTRIBUTES & METHODS                               │
│ • Belong to SPECIFIC OBJECT                                 │
│ • Different for each object                                 │
│ • Use "self" to access                                      │
│ • Example: self.name (each campsite has different name)    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ CLASS ATTRIBUTES & METHODS                                  │
│ • Belong to THE CLASS ITSELF                                │
│ • SHARED by all objects                                     │
│ • Use "ClassName.attribute" to access                       │
│ • Example: Campsite.total_count (count ALL campsites)      │
└─────────────────────────────────────────────────────────────┘
```

---

### 🏕️ Example 1: Understanding Class Attributes

**Analogy:** Think of a camping company:
- **Instance attribute** = Each campsite's name (different for each)
- **Class attribute** = Company's total number of campsites (shared by all)

```python
class Campsite:
    # ⭐ CLASS ATTRIBUTE (defined OUTSIDE __init__)
    # This is SHARED by ALL Campsite objects
    total_count = 0
    company_name = "Brazilian Outdoor Adventures"
    
    def __init__(self, name, state):
        """Initialize a campsite."""
        # ⭐ INSTANCE ATTRIBUTES (unique to THIS object)
        self.name = name
        self.state = state
        
        # Increment the CLASS attribute when new campsite is created
        Campsite.total_count += 1
        
        print(f"✅ Created campsite: {self.name}")
        print(f"   Total campsites now: {Campsite.total_count}")

# Create campsites
camp1 = Campsite("Vale do Capão", "BA")
camp2 = Campsite("Serra da Canastra", "MG")
camp3 = Campsite("Chapada Diamantina", "BA")

# ========== ACCESSING ATTRIBUTES ==========

# Instance attributes (different for each object)
print(f"\nInstance attributes (unique to each):")
print(f"camp1.name: {camp1.name}")  # Vale do Capão
print(f"camp2.name: {camp2.name}")  # Serra da Canastra
print(f"camp3.name: {camp3.name}")  # Chapada Diamantina

# Class attributes (SHARED by all objects)
print(f"\nClass attributes (shared by all):")
print(f"Campsite.total_count: {Campsite.total_count}")  # 3
print(f"Campsite.company_name: {Campsite.company_name}")  # Brazilian Outdoor Adventures

# Can also access class attributes through objects
print(f"\nAccessing through objects:")
print(f"camp1.total_count: {camp1.total_count}")  # 3
print(f"camp2.total_count: {camp2.total_count}")  # 3
print(f"camp3.total_count: {camp3.total_count}")  # 3
# ☝️ All show the SAME value because it's shared!

# Changing class attribute affects ALL objects
Campsite.company_name = "New Company Name"
print(f"\nAfter changing class attribute:")
print(f"camp1.company_name: {camp1.company_name}")  # New Company Name
print(f"camp2.company_name: {camp2.company_name}")  # New Company Name
print(f"camp3.company_name: {camp3.company_name}")  # New Company Name
```

**Output:**
```
✅ Created campsite: Vale do Capão
   Total campsites now: 1
✅ Created campsite: Serra da Canastra
   Total campsites now: 2
✅ Created campsite: Chapada Diamantina
   Total campsites now: 3

Instance attributes (unique to each):
camp1.name: Vale do Capão
camp2.name: Serra da Canastra
camp3.name: Chapada Diamantina

Class attributes (shared by all):
Campsite.total_count: 3
Campsite.company_name: Brazilian Outdoor Adventures

Accessing through objects:
camp1.total_count: 3
camp2.total_count: 3
camp3.total_count: 3

After changing class attribute:
camp1.company_name: New Company Name
camp2.company_name: New Company Name
camp3.company_name: New Company Name
```

---

### 🎯 Real-World Data Engineering Example: Connection Pool

```python
import psycopg2
from datetime import datetime

class DatabaseConnection:
    """Manages database connections with connection pooling."""
    
    # ⭐ CLASS ATTRIBUTES (shared by all connections)
    max_connections = 10  # Maximum allowed connections
    active_connections = 0  # Current number of connections
    total_queries_executed = 0  # Total queries across all connections
    connection_history = []  # History of all connections
    
    def __init__(self, host, database, user, password):
        """Initialize a database connection."""
        print(f"🔌 Initializing connection to {database}...")
        
        # Check if we've reached max connections
        if DatabaseConnection.active_connections >= DatabaseConnection.max_connections:
            raise Exception(f"❌ Max connections ({DatabaseConnection.max_connections}) reached!")
        
        # ⭐ INSTANCE ATTRIBUTES (unique to this connection)
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.conn = None
        self.cursor = None
        self.queries_executed = 0  # Queries for THIS connection
        self.created_at = datetime.now()
        
        # Increment class attribute
        DatabaseConnection.active_connections += 1
        DatabaseConnection.connection_history.append({
            'database': database,
            'created_at': self.created_at
        })
        
        print(f"✅ Connection initialized!")
        print(f"   Active connections: {DatabaseConnection.active_connections}/{DatabaseConnection.max_connections}")
    
    def connect(self):
        """Establish connection."""
        self.conn = psycopg2.connect(
            host=self.host,
            database=self.database,
            user=self.user,
            password=self.password
        )
        self.cursor = self.conn.cursor()
        print(f"✅ Connected to {self.database}")
    
    def execute(self, query):
        """Execute a query."""
        self.cursor.execute(query)
        results = self.cursor.fetchall()
        
        # Increment counters
        self.queries_executed += 1  # Instance counter
        DatabaseConnection.total_queries_executed += 1  # Class counter
        
        print(f"✅ Query executed!")
        print(f"   This connection: {self.queries_executed} queries")
        print(f"   All connections: {DatabaseConnection.total_queries_executed} queries")
        
        return results
    
    def close(self):
        """Close connection."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        
        # Decrement active connections
        DatabaseConnection.active_connections -= 1
        
        print(f"🔒 Connection closed")
        print(f"   Active connections: {DatabaseConnection.active_connections}/{DatabaseConnection.max_connections}")
    
    @classmethod
    def get_statistics(cls):
        """Get statistics for all connections (CLASS METHOD)."""
        print(f"\n{'='*60}")
        print(f"📊 CONNECTION POOL STATISTICS")
        print(f"{'='*60}")
        print(f"Max Connections: {cls.max_connections}")
        print(f"Active Connections: {cls.active_connections}")
        print(f"Total Queries Executed: {cls.total_queries_executed}")
        print(f"Connection History: {len(cls.connection_history)} connections created")
        print(f"{'='*60}\n")

# ==================== USAGE ====================

db_config = {
    'host': 'localhost',
    'user': 'postgres',
    'password': 'secret123'
}

# Create multiple connections
conn1 = DatabaseConnection(**db_config, database='camping_db')
conn1.connect()

conn2 = DatabaseConnection(**db_config, database='analytics_db')
conn2.connect()

# Execute queries
conn1.execute("SELECT * FROM campsites")
conn1.execute("SELECT * FROM bookings")
conn2.execute("SELECT * FROM logs")

# Get statistics (uses CLASS data)
DatabaseConnection.get_statistics()

# Close connections
conn1.close()
conn2.close()

# Final statistics
DatabaseConnection.get_statistics()
```

---

### 📘 Understanding Class Methods

**Class methods** are methods that work with **CLASS attributes** instead of instance attributes.

**3 Types of Methods:**

```python
class Example:
    class_variable = 0
    
    # 1️⃣ INSTANCE METHOD (uses self - works with specific object)
    def instance_method(self):
        return self.instance_variable
    
    # 2️⃣ CLASS METHOD (uses cls - works with class attributes)
    @classmethod
    def class_method(cls):
        return cls.class_variable
    
    # 3️⃣ STATIC METHOD (uses neither - just a regular function in the class)
    @staticmethod
    def static_method():
        return "I don't need self or cls!"
```

**When to use each:**
- **Instance method**: When you need to work with specific object's data
- **Class method**: When you need to work with class-level data or create objects
- **Static method**: When you need a utility function related to the class

---

### 🏗️ Real-World Example: ETL Job Manager

```python
from datetime import datetime
from collections import defaultdict

class ETLJob:
    """Manages ETL jobs with class-level tracking."""
    
    # ⭐ CLASS ATTRIBUTES
    all_jobs = []  # Track all jobs
    jobs_by_status = defaultdict(int)  # Count by status
    total_rows_processed = 0  # Total across all jobs
    
    # Status constants (also class attributes)
    STATUS_PENDING = "PENDING"
    STATUS_RUNNING = "RUNNING"
    STATUS_SUCCESS = "SUCCESS"
    STATUS_FAILED = "FAILED"
    
    def __init__(self, job_name, source, destination):
        """Initialize ETL job."""
        self.job_name = job_name
        self.source = source
        self.destination = destination
        self.status = ETLJob.STATUS_PENDING
        self.rows_processed = 0
        self.started_at = None
        self.completed_at = None
        self.error_message = None
        
        # Add to class tracking
        ETLJob.all_jobs.append(self)
        ETLJob.jobs_by_status[self.status] += 1
        
        print(f"📋 ETL Job created: {self.job_name}")
        print(f"   Source: {self.source} → Destination: {self.destination}")
    
    def start(self):
        """Start the job."""
        # Update status
        ETLJob.jobs_by_status[self.status] -= 1
        self.status = ETLJob.STATUS_RUNNING
        ETLJob.jobs_by_status[self.status] += 1
        
        self.started_at = datetime.now()
        print(f"🚀 Job started: {self.job_name}")
    
    def complete(self, rows_processed):
        """Mark job as complete."""
        # Update status
        ETLJob.jobs_by_status[self.status] -= 1
        self.status = ETLJob.STATUS_SUCCESS
        ETLJob.jobs_by_status[self.status] += 1
        
        self.rows_processed = rows_processed
        self.completed_at = datetime.now()
        
        # Update class totals
        ETLJob.total_rows_processed += rows_processed
        
        duration = (self.completed_at - self.started_at).total_seconds()
        print(f"✅ Job completed: {self.job_name}")
        print(f"   Rows: {rows_processed:,} | Duration: {duration:.2f}s")
    
    def fail(self, error_message):
        """Mark job as failed."""
        # Update status
        ETLJob.jobs_by_status[self.status] -= 1
        self.status = ETLJob.STATUS_FAILED
        ETLJob.jobs_by_status[self.status] += 1
        
        self.error_message = error_message
        self.completed_at = datetime.now()
        
        print(f"❌ Job failed: {self.job_name}")
        print(f"   Error: {error_message}")
    
    # ========== CLASS METHODS (work with class-level data) ==========
    
    @classmethod
    def get_statistics(cls):
        """Get statistics for all jobs."""
        print(f"\n{'='*60}")
        print(f"📊 ETL JOB STATISTICS")
        print(f"{'='*60}")
        print(f"Total Jobs: {len(cls.all_jobs)}")
        print(f"  • Pending: {cls.jobs_by_status[cls.STATUS_PENDING]}")
        print(f"  • Running: {cls.jobs_by_status[cls.STATUS_RUNNING]}")
        print(f"  • Success: {cls.jobs_by_status[cls.STATUS_SUCCESS]}")
        print(f"  • Failed: {cls.jobs_by_status[cls.STATUS_FAILED]}")
        print(f"Total Rows Processed: {cls.total_rows_processed:,}")
        print(f"{'='*60}\n")
    
    @classmethod
    def get_failed_jobs(cls):
        """Get all failed jobs."""
        failed = [job for job in cls.all_jobs if job.status == cls.STATUS_FAILED]
        
        print(f"\n❌ FAILED JOBS ({len(failed)}):")
        for job in failed:
            print(f"  • {job.job_name}: {job.error_message}")
        
        return failed
    
    @classmethod
    def get_active_jobs(cls):
        """Get all running jobs."""
        active = [job for job in cls.all_jobs if job.status == cls.STATUS_RUNNING]
        
        print(f"\n🚀 ACTIVE JOBS ({len(active)}):")
        for job in active:
            duration = (datetime.now() - job.started_at).total_seconds()
            print(f"  • {job.job_name}: running for {duration:.1f}s")
        
        return active
    
    @classmethod
    def reset_statistics(cls):
        """Reset all class-level statistics."""
        cls.all_jobs = []
        cls.jobs_by_status = defaultdict(int)
        cls.total_rows_processed = 0
        print("🔄 Statistics reset!")
    
    # ========== STATIC METHODS (utility functions) ==========
    
    @staticmethod
    def format_duration(seconds):
        """Format duration in human-readable format."""
        if seconds < 60:
            return f"{seconds:.1f}s"
        elif seconds < 3600:
            return f"{seconds/60:.1f}m"
        else:
            return f"{seconds/3600:.1f}h"
    
    @staticmethod
    def validate_source_path(path):
        """Validate source path format."""
        valid_prefixes = ['s3://', 'gs://', 'file://', '/']
        return any(path.startswith(prefix) for prefix in valid_prefixes)

# ==================== USAGE ====================

# Create jobs
job1 = ETLJob("Load Campsites", "s3://data/campsites.csv", "postgres://camping_db/campsites")
job2 = ETLJob("Load Bookings", "s3://data/bookings.csv", "postgres://camping_db/bookings")
job3 = ETLJob("Load Customers", "s3://data/customers.csv", "postgres://camping_db/customers")

# Run jobs
job1.start()
job1.complete(rows_processed=1500)

job2.start()
job2.complete(rows_processed=8500)

job3.start()
job3.fail("Connection timeout")

# Get statistics (CLASS METHOD - works with all jobs)
ETLJob.get_statistics()

# Get failed jobs
failed = ETLJob.get_failed_jobs()

# Get active jobs
active = ETLJob.get_active_jobs()

# Use static method
print(f"\nValidating paths:")
print(f"s3://data/file.csv: {ETLJob.validate_source_path('s3://data/file.csv')}")
print(f"invalid_path: {ETLJob.validate_source_path('invalid_path')}")
```

**Output:**
```
📋 ETL Job created: Load Campsites
   Source: s3://data/campsites.csv → Destination: postgres://camping_db/campsites
📋 ETL Job created: Load Bookings
   Source: s3://data/bookings.csv → Destination: postgres://camping_db/bookings
📋 ETL Job created: Load Customers
   Source: s3://data/customers.csv → Destination: postgres://camping_db/customers
🚀 Job started: Load Campsites
✅ Job completed: Load Campsites
   Rows: 1,500 | Duration: 0.00s
🚀 Job started: Load Bookings
✅ Job completed: Load Bookings
   Rows: 8,500 | Duration: 0.00s
🚀 Job started: Load Customers
❌ Job failed: Load Customers
   Error: Connection timeout

============================================================
📊 ETL JOB STATISTICS
============================================================
Total Jobs: 3
  • Pending: 0
  • Running: 0
  • Success: 2
  • Failed: 1
Total Rows Processed: 10,000
============================================================

❌ FAILED JOBS (1):
  • Load Customers: Connection timeout

🚀 ACTIVE JOBS (0):
```

---

### 🎯 Key Differences Summary

```python
class DataPipeline:
    # CLASS ATTRIBUTE (shared by all)
    total_pipelines = 0
    
    def __init__(self, name):
        # INSTANCE ATTRIBUTE (unique to each)
        self.name = name
        DataPipeline.total_pipelines += 1
    
    # INSTANCE METHOD (works with specific object)
    def run(self):
        print(f"Running {self.name}")
    
    # CLASS METHOD (works with class data)
    @classmethod
    def get_count(cls):
        print(f"Total pipelines: {cls.total_pipelines}")
    
    # STATIC METHOD (utility function)
    @staticmethod
    def validate_name(name):
        return len(name) > 0

# Usage
p1 = DataPipeline("ETL Pipeline 1")
p2 = DataPipeline("ETL Pipeline 2")

p1.run()  # Instance method on specific object
DataPipeline.get_count()  # Class method on class
print(DataPipeline.validate_name("test"))  # Static method
```

---

## ✅ Key Takeaways - Part 3

Make sure you understand:

1. ✅ **Instance attributes** = Unique to each object (`self.name`)
2. ✅ **Class attributes** = Shared by all objects (`ClassName.attribute`)
3. ✅ **Instance methods** = Work with specific object (`def method(self)`)
4. ✅ **Class methods** = Work with class data (`@classmethod def method(cls)`)
5. ✅ **Static methods** = Utility functions (`@staticmethod def method()`)
6. ✅ Use class attributes for **shared data** (counters, configs, constants)
7. ✅ Use class methods for **factory methods** or **statistics**
8. ✅ Use static methods for **utility functions** related to the class
9. ✅ **DATA ENGINEERING**: Track job statistics, connection pools, shared configs
10. ✅ **REAL-WORLD**: Monitor system-wide metrics across all instances

**If any concept is still unclear, re-read the relevant section!**

---

## 🔒 Part 4: Encapsulation and Data Hiding

### 🤔 What is Encapsulation?

**Encapsulation** = Hiding internal details and controlling access to data.

**Real-world analogy:**
- Your **car engine** is encapsulated - you use the steering wheel and pedals (public interface), but you don't directly touch the engine internals
- Your **ATM card** - you use the keypad (public interface), but can't access the bank's internal systems

**In Python:**
- **Public** = Anyone can access (normal attributes)
- **Protected** = Should only be used by class and subclasses (prefix with `_`)
- **Private** = Should only be used by the class itself (prefix with `__`)

---

### 📊 Visual Guide

```
ACCESS LEVELS IN PYTHON

┌─────────────────────────────────────────────────────────┐
│ PUBLIC (no prefix)                                      │
│ • name                                                  │
│ • Anyone can access and modify                          │
│ • Use for: Intended public interface                   │
│ • Example: customer.name = "João"                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ PROTECTED (single underscore _)                         │
│ • _connection                                           │
│ • Convention: "Please don't touch (but you can)"        │
│ • Use for: Internal details, subclass access           │
│ • Example: db._connection (not recommended)            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ PRIVATE (double underscore __)                          │
│ • __password                                            │
│ • Python name mangling prevents easy access             │
│ • Use for: Sensitive data, implementation details      │
│ • Example: user.__password (will cause AttributeError) │
└─────────────────────────────────────────────────────────┘
```

---

### 🏕️ Example 1: Basic Encapsulation

```python
class BankAccount:
    """Bank account with encapsulated balance."""
    
    def __init__(self, account_number, initial_balance):
        # PUBLIC attribute (anyone can access)
        self.account_number = account_number
        
        # PRIVATE attribute (should only be accessed through methods)
        self.__balance = initial_balance
        
        print(f"✅ Account {account_number} created with balance: R${initial_balance:.2f}")
    
    def deposit(self, amount):
        """Public method to deposit money."""
        if amount <= 0:
            print(f"❌ Invalid amount: {amount}")
            return False
        
        self.__balance += amount
        print(f"✅ Deposited R${amount:.2f}")
        print(f"   New balance: R${self.__balance:.2f}")
        return True
    
    def withdraw(self, amount):
        """Public method to withdraw money."""
        if amount <= 0:
            print(f"❌ Invalid amount: {amount}")
            return False
        
        if amount > self.__balance:
            print(f"❌ Insufficient funds!")
            print(f"   Balance: R${self.__balance:.2f}, Requested: R${amount:.2f}")
            return False
        
        self.__balance -= amount
        print(f"✅ Withdrawn R${amount:.2f}")
        print(f"   New balance: R${self.__balance:.2f}")
        return True
    
    def get_balance(self):
        """Public method to check balance."""
        return self.__balance
    
    def display_info(self):
        """Display account information."""
        print(f"\n{'='*50}")
        print(f"💳 Account: {self.account_number}")
        print(f"💰 Balance: R${self.__balance:.2f}")
        print(f"{'='*50}\n")

# ==================== USAGE ====================

account = BankAccount("12345-6", 1000.00)

# ✅ Access public attribute
print(f"Account number: {account.account_number}")

# ✅ Use public methods to interact with private data
account.deposit(500.00)
account.withdraw(200.00)

# ✅ Get balance through method
balance = account.get_balance()
print(f"Current balance: R${balance:.2f}")

# ❌ Try to access private attribute directly
try:
    print(account.__balance)  # This will fail!
except AttributeError as e:
    print(f"❌ Cannot access private attribute: {e}")

# ⚠️ Python name mangling allows access (but shouldn't be used!)
print(f"\n⚠️  Accessing through name mangling (DON'T DO THIS!):")
print(f"Balance: {account._BankAccount__balance}")  # Works but BAD PRACTICE!

account.display_info()
```

**Output:**
```
✅ Account 12345-6 created with balance: R$1000.00
Account number: 12345-6
✅ Deposited R$500.00
   New balance: R$1500.00
✅ Withdrawn R$200.00
   New balance: R$1300.00
Current balance: R$1300.00
❌ Cannot access private attribute: 'BankAccount' object has no attribute '__balance'

⚠️  Accessing through name mangling (DON'T DO THIS!):
Balance: 1300.0

==================================================
💳 Account: 12345-6
💰 Balance: R$1300.00
==================================================
```

---

### 🏗️ Real-World Data Engineering: Database Credentials Manager

```python
import hashlib
from datetime import datetime
import psycopg2

class DatabaseCredentials:
    """Manages database credentials securely."""
    
    def __init__(self, host, database, user, password):
        """Initialize credentials with encryption."""
        # PUBLIC attributes
        self.host = host
        self.database = database
        self.user = user
        self.created_at = datetime.now()
        
        # PRIVATE attributes (sensitive data)
        self.__password = password
        self.__password_hash = self._hash_password(password)
        self.__connection = None
        
        print(f"🔐 Credentials created for {user}@{database}")
        print(f"   Password stored securely (hashed)")
    
    def _hash_password(self, password):
        """PROTECTED method to hash password."""
        return hashlib.sha256(password.encode()).hexdigest()
    
    def connect(self):
        """PUBLIC method to establish connection."""
        if self.__connection:
            print(f"⚠️  Already connected!")
            return self.__connection
        
        print(f"📡 Connecting to {self.database}...")
        
        try:
            # Use private password attribute internally
            self.__connection = psycopg2.connect(
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.__password
            )
            
            print(f"✅ Connected successfully!")
            return self.__connection
        
        except Exception as e:
            print(f"❌ Connection failed: {e}")
            return None
    
    def disconnect(self):
        """PUBLIC method to close connection."""
        if self.__connection:
            self.__connection.close()
            self.__connection = None
            print(f"🔒 Disconnected from {self.database}")
        else:
            print(f"⚠️  Not connected!")
    
    def verify_password(self, password):
        """PUBLIC method to verify password without exposing it."""
        provided_hash = self._hash_password(password)
        is_valid = provided_hash == self.__password_hash
        
        print(f"🔍 Password verification: {'✅ Valid' if is_valid else '❌ Invalid'}")
        return is_valid
    
    def change_password(self, old_password, new_password):
        """PUBLIC method to change password securely."""
        if not self.verify_password(old_password):
            print(f"❌ Cannot change password: Old password is incorrect")
            return False
        
        if len(new_password) < 8:
            print(f"❌ New password must be at least 8 characters")
            return False
        
        # Update private password
        self.__password = new_password
        self.__password_hash = self._hash_password(new_password)
        
        print(f"✅ Password changed successfully!")
        return True
    
    def is_connected(self):
        """PUBLIC method to check connection status."""
        return self.__connection is not None
    
    def get_connection_info(self):
        """PUBLIC method to get safe connection information."""
        return {
            'host': self.host,
            'database': self.database,
            'user': self.user,
            'connected': self.is_connected(),
            'created_at': self.created_at
            # Note: password is NOT exposed!
        }
    
    def display_info(self):
        """Display safe credential information."""
        print(f"\n{'='*60}")
        print(f"🔐 DATABASE CREDENTIALS")
        print(f"{'='*60}")
        print(f"Host: {self.host}")
        print(f"Database: {self.database}")
        print(f"User: {self.user}")
        print(f"Password: {'*' * 12} (hidden)")
        print(f"Connected: {'Yes' if self.is_connected() else 'No'}")
        print(f"Created: {self.created_at}")
        print(f"{'='*60}\n")

# ==================== USAGE ====================

# Create credentials
creds = DatabaseCredentials(
    host="localhost",
    database="camping_db",
    user="fabiano",
    password="MySecret123!"
)

# Display info (password is hidden)
creds.display_info()

# Verify password
creds.verify_password("WrongPassword")  # ❌
creds.verify_password("MySecret123!")   # ✅

# Change password
creds.change_password("WrongOld", "NewPass")  # ❌ Wrong old password
creds.change_password("MySecret123!", "short")  # ❌ Too short
creds.change_password("MySecret123!", "NewSecurePassword456")  # ✅

# Connect to database
conn = creds.connect()

# Get safe connection info (no password exposed)
info = creds.get_connection_info()
print(f"\nConnection Info: {info}")

# Disconnect
creds.disconnect()

# ❌ Try to access private password
try:
    print(creds.__password)
except AttributeError:
    print(f"\n✅ Good! Password is properly encapsulated")
```

---

### 🎯 Using @property Decorator (Pythonic Encapsulation)

The `@property` decorator provides a Pythonic way to encapsulate attributes:

```python
class DataValidator:
    """Validates data with encapsulated validation rules."""
    
    def __init__(self, min_value, max_value):
        """Initialize validator."""
        self.__min_value = min_value
        self.__max_value = max_value
        self.__validated_count = 0
    
    # GETTER - read the value
    @property
    def min_value(self):
        """Get minimum value."""
        return self.__min_value
    
    # SETTER - write the value with validation
    @min_value.setter
    def min_value(self, value):
        """Set minimum value with validation."""
        if value >= self.__max_value:
            raise ValueError(f"min_value must be less than max_value ({self.__max_value})")
        
        self.__min_value = value
        print(f"✅ min_value updated to {value}")
    
    @property
    def max_value(self):
        """Get maximum value."""
        return self.__max_value
    
    @max_value.setter
    def max_value(self, value):
        """Set maximum value with validation."""
        if value <= self.__min_value:
            raise ValueError(f"max_value must be greater than min_value ({self.__min_value})")
        
        self.__max_value = value
        print(f"✅ max_value updated to {value}")
    
    @property
    def validated_count(self):
        """Get count of validated values (read-only)."""
        return self.__validated_count
    
    # No setter for validated_count - it's read-only!
    
    def validate(self, value):
        """Validate a value against the range."""
        is_valid = self.__min_value <= value <= self.__max_value
        
        if is_valid:
            self.__validated_count += 1
            print(f"✅ {value} is valid (range: {self.__min_value}-{self.__max_value})")
        else:
            print(f"❌ {value} is invalid (range: {self.__min_value}-{self.__max_value})")
        
        return is_valid
    
    def reset_count(self):
        """Reset validation counter."""
        self.__validated_count = 0
        print(f"🔄 Validation count reset")

# ==================== USAGE ====================

validator = DataValidator(min_value=0, max_value=100)

# Use properties like regular attributes
print(f"Min: {validator.min_value}")  # Calls getter
print(f"Max: {validator.max_value}")  # Calls getter

# Set values (calls setter with validation)
validator.min_value = 10  # ✅
validator.max_value = 200  # ✅

# Try invalid values
try:
    validator.min_value = 250  # ❌ Would be > max_value
except ValueError as e:
    print(f"❌ Error: {e}")

# Validate some values
validator.validate(50)   # ✅
validator.validate(150)  # ✅
validator.validate(5)    # ❌ Below min
validator.validate(250)  # ❌ Above max

# Read validation count (read-only property)
print(f"Valid values processed: {validator.validated_count}")

# ❌ Cannot set validated_count (no setter defined)
try:
    validator.validated_count = 0
except AttributeError as e:
    print(f"❌ Cannot set read-only property: {e}")

# Reset using method instead
validator.reset_count()
```

---

### 🏗️ Complete Data Engineering Example: Configuration Manager

```python
import json
from pathlib import Path
from datetime import datetime

class ConfigurationManager:
    """Manages application configuration with encapsulation."""
    
    def __init__(self, config_file):
        """Initialize configuration manager."""
        self.__config_file = Path(config_file)
        self.__config = {}
        self.__loaded_at = None
        self.__modified = False
        
        print(f"⚙️  Configuration Manager initialized")
        print(f"   Config file: {self.__config_file}")
    
    def load(self):
        """Load configuration from file."""
        if not self.__config_file.exists():
            print(f"⚠️  Config file not found, using defaults")
            self.__config = self._get_default_config()
            return
        
        print(f"📖 Loading configuration from {self.__config_file.name}...")
        
        with open(self.__config_file, 'r') as f:
            self.__config = json.load(f)
        
        self.__loaded_at = datetime.now()
        self.__modified = False
        
        print(f"✅ Configuration loaded!")
        print(f"   Keys: {', '.join(self.__config.keys())}")
    
    def _get_default_config(self):
        """PROTECTED: Get default configuration."""
        return {
            'database': {
                'host': 'localhost',
                'port': 5432,
                'name': 'camping_db'
            },
            'etl': {
                'batch_size': 1000,
                'max_retries': 3,
                'timeout': 300
            },
            'logging': {
                'level': 'INFO',
                'file': 'app.log'
            }
        }
    
    @property
    def database_config(self):
        """Get database configuration (read-only)."""
        return self.__config.get('database', {}).copy()  # Return copy for safety
    
    @property
    def etl_config(self):
        """Get ETL configuration (read-only)."""
        return self.__config.get('etl', {}).copy()
    
    @property
    def logging_config(self):
        """Get logging configuration (read-only)."""
        return self.__config.get('logging', {}).copy()
    
    def get_value(self, section, key, default=None):
        """Get specific configuration value."""
        value = self.__config.get(section, {}).get(key, default)
        print(f"🔍 Config[{section}][{key}] = {value}")
        return value
    
    def set_value(self, section, key, value):
        """Set specific configuration value."""
        if section not in self.__config:
            self.__config[section] = {}
        
        old_value = self.__config[section].get(key)
        self.__config[section][key] = value
        self.__modified = True
        
        print(f"✅ Config[{section}][{key}] changed: {old_value} → {value}")
    
    def save(self):
        """Save configuration to file."""
        if not self.__modified:
            print(f"⚠️  No changes to save")
            return
        
        print(f"💾 Saving configuration to {self.__config_file}...")
        
        # Create parent directory if needed
        self.__config_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.__config_file, 'w') as f:
            json.dump(self.__config, f, indent=2)
        
        self.__modified = False
        
        print(f"✅ Configuration saved!")
    
    def is_modified(self):
        """Check if configuration has been modified."""
        return self.__modified
    
    def display_summary(self):
        """Display configuration summary."""
        print(f"\n{'='*60}")
        print(f"⚙️  CONFIGURATION SUMMARY")
        print(f"{'='*60}")
        print(f"Config File: {self.__config_file}")
        print(f"Loaded At: {self.__loaded_at or 'Not loaded'}")
        print(f"Modified: {'Yes' if self.__modified else 'No'}")
        print(f"\nSections: {len(self.__config)}")
        
        for section, values in self.__config.items():
            print(f"\n[{section}]")
            for key, value in values.items():
                # Hide sensitive values
                if 'password' in key.lower() or 'secret' in key.lower():
                    value = '***HIDDEN***'
                print(f"  {key}: {value}")
        
        print(f"{'='*60}\n")

# ==================== USAGE ====================

# Create configuration manager
config = ConfigurationManager('config/app_config.json')

# Load configuration
config.load()

# Get configuration (read-only properties)
db_config = config.database_config
etl_config = config.etl_config

print(f"\nDatabase: {db_config}")
print(f"ETL: {etl_config}")

# Get specific values
batch_size = config.get_value('etl', 'batch_size')
log_level = config.get_value('logging', 'level')

# Modify configuration
config.set_value('etl', 'batch_size', 5000)
config.set_value('etl', 'max_retries', 5)

# Check if modified
if config.is_modified():
    print(f"\n⚠️  Configuration has unsaved changes")

# Display summary
config.display_summary()

# Save changes
config.save()
```

---

## ✅ Key Takeaways - Part 4

Make sure you understand:

1. ✅ **Encapsulation** = Hiding internal details, controlling access
2. ✅ **Public** attributes = No prefix, anyone can access
3. ✅ **Protected** attributes = Single `_` prefix, internal use
4. ✅ **Private** attributes = Double `__` prefix, name mangling
5. ✅ Use **methods** to control access to private data
6. ✅ `@property` decorator = Pythonic getters/setters
7. ✅ `@property` only (no setter) = Read-only attribute
8. ✅ **DATA ENGINEERING**: Encapsulate credentials, configs, connections
9. ✅ **SECURITY**: Never expose passwords, API keys, sensitive data
10. ✅ **VALIDATION**: Use setters to validate data before changing

**If any concept is still unclear, re-read the relevant section!**

---

## 👪 Part 5: Inheritance and Code Reuse

### 🤔 What is Inheritance?

**Inheritance** = Creating a new class based on an existing class.

**Real-world analogies:**
- **Family tree**: Children inherit traits from parents (eye color, height)
- **Vehicle hierarchy**: Cars, Trucks, Motorcycles all inherit from Vehicle (wheels, engine, steering)
- **Job roles**: Senior Engineer inherits all responsibilities of Junior Engineer, plus more

**In Python:**
- **Parent class** (Base class, Superclass) = The original class
- **Child class** (Derived class, Subclass) = The new class that inherits from parent
- Child gets **all attributes and methods** from parent
- Child can **add new** attributes/methods
- Child can **override** parent methods

---

### 📊 Visual Guide

```
INHERITANCE HIERARCHY

┌─────────────────────────────────────────────────────────┐
│ PARENT CLASS (Base Class)                              │
│ • Has common attributes and methods                     │
│ • Example: DataSource                                   │
│   - connect()                                           │
│   - disconnect()                                        │
│   - validate()                                          │
└─────────────────────────────────────────────────────────┘
                          ▲
                          │
           ┌──────────────┼──────────────┐
           │              │              │
           │              │              │
┌──────────▼─────┐ ┌─────▼──────┐ ┌────▼─────────┐
│ CSVSource      │ │ DBSource   │ │ APISource    │
│ • Inherits all │ │ • Inherits │ │ • Inherits   │
│ • + read_csv() │ │ • + query()│ │ • + fetch()  │
└────────────────┘ └────────────┘ └──────────────┘

All child classes have:
✅ connect() from parent
✅ disconnect() from parent
✅ validate() from parent
✅ Their own specific methods
```

---

### 🏕️ Example 1: Basic Inheritance

```python
# ========== PARENT CLASS ==========

class Campsite:
    """Base campsite class (PARENT)."""
    
    def __init__(self, name, state, price):
        """Initialize campsite."""
        self.name = name
        self.state = state
        self.price = price
        self.is_open = True
        
        print(f"✅ Campsite created: {self.name}")
    
    def display_info(self):
        """Display campsite information."""
        print(f"\n{'='*50}")
        print(f"🏕️  {self.name}")
        print(f"   State: {self.state}")
        print(f"   Price: R${self.price:.2f}/night")
        print(f"   Status: {'Open' if self.is_open else 'Closed'}")
        print(f"{'='*50}\n")
    
    def close(self):
        """Close campsite."""
        self.is_open = False
        print(f"🔒 {self.name} is now closed")
    
    def open(self):
        """Open campsite."""
        self.is_open = True
        print(f"✅ {self.name} is now open")

# ========== CHILD CLASS ==========

class PremiumCampsite(Campsite):
    """Premium campsite with extra amenities (CHILD)."""
    
    def __init__(self, name, state, price, amenities):
        """Initialize premium campsite."""
        # Call parent's __init__ to set up basic attributes
        super().__init__(name, state, price)
        
        # Add new attribute specific to premium campsites
        self.amenities = amenities
        
        print(f"   🌟 Premium campsite with {len(amenities)} amenities")
    
    # Override parent method (customize for premium)
    def display_info(self):
        """Display premium campsite information."""
        print(f"\n{'='*50}")
        print(f"🌟 PREMIUM: {self.name}")
        print(f"   State: {self.state}")
        print(f"   Price: R${self.price:.2f}/night")
        print(f"   Status: {'Open' if self.is_open else 'Closed'}")
        print(f"   Amenities: {', '.join(self.amenities)}")
        print(f"{'='*50}\n")
    
    # Add new method specific to premium campsites
    def add_amenity(self, amenity):
        """Add a new amenity."""
        self.amenities.append(amenity)
        print(f"✅ Added amenity: {amenity}")

# ==================== USAGE ====================

# Create basic campsite (parent class)
basic = Campsite("Vale Simples", "BA", 80.00)
basic.display_info()

# Create premium campsite (child class)
premium = PremiumCampsite(
    "Vale Premium",
    "BA",
    200.00,
    ["Wi-Fi", "Hot Shower", "Restaurant"]
)
premium.display_info()

# Child has ALL parent methods
premium.close()  # Inherited from parent!
premium.open()   # Inherited from parent!

# Child has its own methods too
premium.add_amenity("Swimming Pool")
premium.display_info()

# ✨ PremiumCampsite is a Campsite, but with extra features!
```

**Output:**
```
✅ Campsite created: Vale Simples

==================================================
🏕️  Vale Simples
   State: BA
   Price: R$80.00/night
   Status: Open
==================================================

✅ Campsite created: Vale Premium
   🌟 Premium campsite with 3 amenities

==================================================
🌟 PREMIUM: Vale Premium
   State: BA
   Price: R$200.00/night
   Status: Open
   Amenities: Wi-Fi, Hot Shower, Restaurant
==================================================

🔒 Vale Premium is now closed
✅ Vale Premium is now open
✅ Added amenity: Swimming Pool

==================================================
🌟 PREMIUM: Vale Premium
   State: BA
   Price: R$200.00/night
   Status: Open
   Amenities: Wi-Fi, Hot Shower, Restaurant, Swimming Pool
==================================================
```

---

### 🎯 Understanding `super()`

`super()` gives you access to the parent class.

```python
class Parent:
    def __init__(self, name):
        self.name = name
        print(f"Parent __init__: {name}")
    
    def greet(self):
        print(f"Hello from {self.name}")

class Child(Parent):
    def __init__(self, name, age):
        # Call parent's __init__ first
        super().__init__(name)
        
        # Then add child-specific initialization
        self.age = age
        print(f"Child __init__: age {age}")
    
    def greet(self):
        # Call parent's greet first
        super().greet()
        
        # Then add child-specific behavior
        print(f"I am {self.age} years old")

# Create child object
child = Child("João", 10)
child.greet()
```

**Output:**
```
Parent __init__: João
Child __init__: age 10
Hello from João
I am 10 years old
```

**Why use `super()`?**
- ✅ Don't repeat parent's initialization code
- ✅ If parent changes, child automatically gets updates
- ✅ Works correctly with multiple inheritance

---

### 🏗️ Real-World Data Engineering: Data Source Hierarchy

```python
from abc import ABC, abstractmethod
from pathlib import Path
import csv
import json
import psycopg2

# ========== PARENT CLASS (ABSTRACT BASE) ==========

class DataSource(ABC):
    """Abstract base class for all data sources."""
    
    def __init__(self, name, source_type):
        """Initialize data source."""
        self.name = name
        self.source_type = source_type
        self.connected = False
        self.data = []
        
        print(f"📦 DataSource initialized: {name} ({source_type})")
    
    @abstractmethod
    def connect(self):
        """Connect to data source (MUST be implemented by children)."""
        pass
    
    @abstractmethod
    def read(self):
        """Read data from source (MUST be implemented by children)."""
        pass
    
    def disconnect(self):
        """Disconnect from data source (shared by all children)."""
        self.connected = False
        print(f"🔒 Disconnected from {self.name}")
    
    def get_row_count(self):
        """Get number of rows (shared by all children)."""
        return len(self.data)
    
    def display_summary(self):
        """Display data summary (shared by all children)."""
        print(f"\n{'='*60}")
        print(f"📊 DATA SOURCE SUMMARY: {self.name}")
        print(f"{'='*60}")
        print(f"Type: {self.source_type}")
        print(f"Connected: {self.connected}")
        print(f"Rows: {len(self.data)}")
        print(f"{'='*60}\n")

# ========== CHILD CLASS 1: CSV Source ==========

class CSVSource(DataSource):
    """Data source for CSV files."""
    
    def __init__(self, name, file_path):
        """Initialize CSV source."""
        # Call parent constructor
        super().__init__(name, source_type="CSV")
        
        # Add CSV-specific attributes
        self.file_path = Path(file_path)
        
        print(f"   📄 CSV file: {self.file_path}")
    
    def connect(self):
        """Connect to CSV file (check if exists)."""
        print(f"📡 Connecting to CSV: {self.file_path}...")
        
        if not self.file_path.exists():
            raise FileNotFoundError(f"CSV file not found: {self.file_path}")
        
        self.connected = True
        print(f"✅ Connected to CSV file")
    
    def read(self):
        """Read data from CSV file."""
        if not self.connected:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"📖 Reading data from CSV...")
        
        with open(self.file_path, 'r') as file:
            reader = csv.DictReader(file)
            self.data = list(reader)
        
        print(f"✅ Read {len(self.data)} rows from CSV")
        return self.data
    
    # CSV-specific method
    def get_column_names(self):
        """Get CSV column names."""
        if self.data:
            return list(self.data[0].keys())
        return []

# ========== CHILD CLASS 2: Database Source ==========

class DatabaseSource(DataSource):
    """Data source for databases."""
    
    def __init__(self, name, host, database, user, password):
        """Initialize database source."""
        # Call parent constructor
        super().__init__(name, source_type="PostgreSQL")
        
        # Add database-specific attributes
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.conn = None
        self.cursor = None
        
        print(f"   🗄️  Database: {database}")
    
    def connect(self):
        """Connect to database."""
        print(f"📡 Connecting to PostgreSQL: {self.database}...")
        
        self.conn = psycopg2.connect(
            host=self.host,
            database=self.database,
            user=self.user,
            password=self.password
        )
        self.cursor = self.conn.cursor()
        self.connected = True
        
        print(f"✅ Connected to database")
    
    def read(self, query="SELECT * FROM campsites LIMIT 100"):
        """Read data from database."""
        if not self.connected:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"📖 Executing query: {query[:50]}...")
        
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        
        # Get column names
        columns = [desc[0] for desc in self.cursor.description]
        
        # Convert to list of dicts
        self.data = [dict(zip(columns, row)) for row in rows]
        
        print(f"✅ Read {len(self.data)} rows from database")
        return self.data
    
    def disconnect(self):
        """Disconnect from database."""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        
        # Call parent's disconnect
        super().disconnect()
    
    # Database-specific method
    def execute_custom_query(self, query):
        """Execute custom SQL query."""
        if not self.connected:
            raise Exception("Not connected!")
        
        print(f"🔍 Executing custom query...")
        self.cursor.execute(query)
        return self.cursor.fetchall()

# ========== CHILD CLASS 3: JSON Source ==========

class JSONSource(DataSource):
    """Data source for JSON files."""
    
    def __init__(self, name, file_path):
        """Initialize JSON source."""
        # Call parent constructor
        super().__init__(name, source_type="JSON")
        
        # Add JSON-specific attributes
        self.file_path = Path(file_path)
        
        print(f"   📄 JSON file: {self.file_path}")
    
    def connect(self):
        """Connect to JSON file (check if exists)."""
        print(f"📡 Connecting to JSON: {self.file_path}...")
        
        if not self.file_path.exists():
            raise FileNotFoundError(f"JSON file not found: {self.file_path}")
        
        self.connected = True
        print(f"✅ Connected to JSON file")
    
    def read(self):
        """Read data from JSON file."""
        if not self.connected:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"📖 Reading data from JSON...")
        
        with open(self.file_path, 'r') as file:
            self.data = json.load(file)
        
        # Ensure data is a list
        if not isinstance(self.data, list):
            self.data = [self.data]
        
        print(f"✅ Read {len(self.data)} records from JSON")
        return self.data
    
    # JSON-specific method
    def get_nested_value(self, key_path):
        """Get nested value from JSON (e.g., 'user.address.city')."""
        keys = key_path.split('.')
        values = []
        
        for record in self.data:
            value = record
            for key in keys:
                value = value.get(key, None)
                if value is None:
                    break
            values.append(value)
        
        return values

# ==================== USAGE ====================

# Create different data sources (all inherit from DataSource)
csv_source = CSVSource("Campsites CSV", "data/campsites.csv")
db_source = DatabaseSource(
    "Camping Database",
    host="localhost",
    database="camping_db",
    user="postgres",
    password="secret123"
)
json_source = JSONSource("Config JSON", "data/config.json")

print(f"\n{'='*60}")
print(f"📊 WORKING WITH DIFFERENT DATA SOURCES")
print(f"{'='*60}\n")

# All sources have the same interface (thanks to inheritance!)
sources = [csv_source, db_source, json_source]

for source in sources:
    try:
        # Same methods work on all sources!
        source.connect()
        data = source.read()
        count = source.get_row_count()
        source.display_summary()
        source.disconnect()
        
        print(f"✅ Processed {source.name}: {count} rows\n")
    
    except FileNotFoundError as e:
        print(f"⚠️  Skipping {source.name}: {e}\n")
    except Exception as e:
        print(f"❌ Error with {source.name}: {e}\n")

# ✨ All data sources work the same way, but each has its own implementation!
```

---

### 🏗️ Real-World Example: ETL Pipeline Hierarchy

```python
from datetime import datetime
from abc import ABC, abstractmethod

# ========== PARENT CLASS (ABSTRACT) ==========

class BaseETLPipeline(ABC):
    """Base class for all ETL pipelines."""
    
    def __init__(self, pipeline_name):
        """Initialize pipeline."""
        self.pipeline_name = pipeline_name
        self.start_time = None
        self.end_time = None
        self.rows_processed = 0
        self.errors = []
        
        print(f"🚀 Pipeline initialized: {pipeline_name}")
    
    def run(self):
        """Run the complete ETL pipeline (TEMPLATE METHOD)."""
        print(f"\n{'='*70}")
        print(f"🚀 STARTING PIPELINE: {self.pipeline_name}")
        print(f"{'='*70}\n")
        
        self.start_time = datetime.now()
        
        try:
            # Step 1: Extract (implemented by child)
            print(f"📥 STEP 1: EXTRACT")
            data = self.extract()
            print(f"✅ Extracted {len(data)} rows\n")
            
            # Step 2: Transform (implemented by child)
            print(f"🔄 STEP 2: TRANSFORM")
            transformed = self.transform(data)
            print(f"✅ Transformed {len(transformed)} rows\n")
            
            # Step 3: Load (implemented by child)
            print(f"📤 STEP 3: LOAD")
            self.load(transformed)
            self.rows_processed = len(transformed)
            print(f"✅ Loaded {self.rows_processed} rows\n")
            
            self.end_time = datetime.now()
            self._display_summary()
            
            return True
        
        except Exception as e:
            self.errors.append(str(e))
            print(f"❌ Pipeline failed: {e}")
            return False
    
    @abstractmethod
    def extract(self):
        """Extract data (MUST be implemented by child)."""
        pass
    
    @abstractmethod
    def transform(self, data):
        """Transform data (MUST be implemented by child)."""
        pass
    
    @abstractmethod
    def load(self, data):
        """Load data (MUST be implemented by child)."""
        pass
    
    def _display_summary(self):
        """Display pipeline summary (shared by all children)."""
        duration = (self.end_time - self.start_time).total_seconds()
        
        print(f"{'='*70}")
        print(f"📊 PIPELINE SUMMARY: {self.pipeline_name}")
        print(f"{'='*70}")
        print(f"Status: {'✅ SUCCESS' if not self.errors else '❌ FAILED'}")
        print(f"Rows Processed: {self.rows_processed}")
        print(f"Duration: {duration:.2f}s")
        print(f"Errors: {len(self.errors)}")
        print(f"{'='*70}\n")

# ========== CHILD CLASS 1: CSV to Database Pipeline ==========

class CSVToDatabasePipeline(BaseETLPipeline):
    """ETL pipeline to load CSV into database."""
    
    def __init__(self, csv_file, db_connection):
        """Initialize CSV to Database pipeline."""
        super().__init__(f"CSV to Database: {csv_file}")
        
        self.csv_file = csv_file
        self.db_connection = db_connection
    
    def extract(self):
        """Extract data from CSV file."""
        # Simulate reading CSV
        data = [
            {'name': 'Vale do Capão', 'state': 'BA', 'price': '120.00'},
            {'name': 'Serra da Canastra', 'state': 'MG', 'price': '80.00'},
            {'name': 'Chapada Diamantina', 'state': 'BA', 'price': '100.00'},
        ]
        return data
    
    def transform(self, data):
        """Transform data for database."""
        transformed = []
        
        for row in data:
            # Clean and validate
            transformed_row = {
                'name': row['name'].strip().title(),
                'state': row['state'].upper(),
                'price': float(row['price'].replace(',', ''))
            }
            transformed.append(transformed_row)
        
        return transformed
    
    def load(self, data):
        """Load data into database."""
        # Simulate database insert
        for row in data:
            print(f"   INSERT: {row['name']} ({row['state']}) - R${row['price']:.2f}")

# ========== CHILD CLASS 2: API to S3 Pipeline ==========

class APIToS3Pipeline(BaseETLPipeline):
    """ETL pipeline to fetch from API and save to S3."""
    
    def __init__(self, api_url, s3_bucket):
        """Initialize API to S3 pipeline."""
        super().__init__(f"API to S3: {api_url}")
        
        self.api_url = api_url
        self.s3_bucket = s3_bucket
    
    def extract(self):
        """Extract data from API."""
        # Simulate API call
        print(f"   Fetching from {self.api_url}...")
        data = [
            {'id': 1, 'customer': 'João Silva', 'total': 450.00},
            {'id': 2, 'customer': 'Maria Santos', 'total': 320.00},
        ]
        return data
    
    def transform(self, data):
        """Transform data for S3."""
        transformed = []
        
        for row in data:
            # Add metadata
            transformed_row = {
                **row,
                'processed_at': datetime.now().isoformat(),
                'source': 'API'
            }
            transformed.append(transformed_row)
        
        return transformed
    
    def load(self, data):
        """Load data to S3."""
        # Simulate S3 upload
        print(f"   Uploading to s3://{self.s3_bucket}/data.json")
        print(f"   Uploaded {len(data)} records")

# ========== CHILD CLASS 3: Database to Data Lake Pipeline ==========

class DatabaseToDataLakePipeline(BaseETLPipeline):
    """ETL pipeline to copy from database to data lake."""
    
    def __init__(self, source_db, data_lake_path):
        """Initialize Database to Data Lake pipeline."""
        super().__init__(f"DB to Data Lake: {source_db}")
        
        self.source_db = source_db
        self.data_lake_path = data_lake_path
    
    def extract(self):
        """Extract data from database."""
        print(f"   Querying {self.source_db}...")
        # Simulate query
        data = [
            {'campsite_id': 1, 'bookings': 45, 'revenue': 5400.00},
            {'campsite_id': 2, 'bookings': 32, 'revenue': 3840.00},
        ]
        return data
    
    def transform(self, data):
        """Transform data for data lake."""
        # Add partitioning info
        transformed = []
        
        for row in data:
            transformed_row = {
                **row,
                'year': datetime.now().year,
                'month': datetime.now().month,
                'exported_at': datetime.now().isoformat()
            }
            transformed.append(transformed_row)
        
        return transformed
    
    def load(self, data):
        """Load data to data lake."""
        year = datetime.now().year
        month = datetime.now().month
        path = f"{self.data_lake_path}/year={year}/month={month}/data.parquet"
        
        print(f"   Writing to {path}")
        print(f"   Wrote {len(data)} records")

# ==================== USAGE ====================

# Create different pipelines (all inherit from BaseETLPipeline)
pipeline1 = CSVToDatabasePipeline("campsites.csv", "postgres://camping_db")
pipeline2 = APIToS3Pipeline("https://api.example.com/bookings", "my-bucket")
pipeline3 = DatabaseToDataLakePipeline("camping_db", "s3://data-lake/analytics")

# All pipelines have the same interface!
pipelines = [pipeline1, pipeline2, pipeline3]

for pipeline in pipelines:
    success = pipeline.run()
    
    if success:
        print(f"✅ {pipeline.pipeline_name} completed successfully!\n")
    else:
        print(f"❌ {pipeline.pipeline_name} failed!\n")

# ✨ Same interface, different implementations - that's inheritance!
```

---

## ✅ Key Takeaways - Part 5

Make sure you understand:

1. ✅ **Inheritance** = Creating new classes based on existing classes
2. ✅ **Parent class** = Original class with common functionality
3. ✅ **Child class** = New class that inherits from parent
4. ✅ Child gets **all** parent attributes and methods automatically
5. ✅ `super()` = Access parent class methods
6. ✅ **Override** = Replace parent method with child's version
7. ✅ **Extend** = Add new methods/attributes to child
8. ✅ **Abstract base class** = Parent that defines interface (ABC)
9. ✅ **DATA ENGINEERING**: Create hierarchies for data sources, pipelines, transformers
10. ✅ **DRY Principle**: Don't Repeat Yourself - share common code in parent

**If any concept is still unclear, re-read the relevant section!**

---

## 🎭 Part 6: Polymorphism and Duck Typing

### 🤔 What is Polymorphism?

**Polymorphism** = "Many forms" - Same interface, different implementations.

**Real-world analogies:**
- **Universal remote**: Same "play" button works on TV, DVD player, speakers (different devices, same interface)
- **Payment methods**: Whether you pay with card, cash, or phone - the "pay" action is the same
- **Power outlets**: Different plugs (US, EU, UK) but all deliver electricity

**In Python:**
- Different objects respond to the same method call
- Each object implements the method in its own way
- You don't need to know the object's type - just call the method!

---

### 📊 Visual Guide

```
POLYMORPHISM - SAME METHOD, DIFFERENT BEHAVIOR

┌─────────────────────────────────────────────────────────┐
│ COMMON INTERFACE: process_data()                        │
└─────────────────────────────────────────────────────────┘
                          │
           ┌──────────────┼──────────────┐
           │              │              │
           ▼              ▼              ▼
┌──────────────────┐ ┌─────────────┐ ┌──────────────┐
│ CSVProcessor     │ │ XMLProcessor│ │ JSONProcessor│
│                  │ │             │ │              │
│ process_data()   │ │ process_   │ │ process_     │
│ • Read CSV       │ │   data()    │ │   data()     │
│ • Parse rows     │ │ • Parse XML │ │ • Parse JSON │
│ • Return list    │ │ • Return    │ │ • Return     │
│                  │ │   list      │ │   list       │
└──────────────────┘ └─────────────┘ └──────────────┘

Same method name, different implementations!
You can use ANY processor the same way:

processor.process_data()  # Works for all!
```

---

### 🏕️ Example 1: Basic Polymorphism

```python
class CSVExporter:
    """Export data to CSV format."""
    
    def export(self, data, filename):
        """Export data to CSV."""
        print(f"📄 Exporting to CSV: {filename}")
        
        # CSV-specific implementation
        for row in data:
            csv_row = ','.join(str(v) for v in row.values())
            print(f"   {csv_row}")
        
        print(f"✅ CSV export complete!")

class JSONExporter:
    """Export data to JSON format."""
    
    def export(self, data, filename):
        """Export data to JSON."""
        print(f"📄 Exporting to JSON: {filename}")
        
        # JSON-specific implementation
        import json
        json_str = json.dumps(data, indent=2)
        print(json_str)
        
        print(f"✅ JSON export complete!")

class XMLExporter:
    """Export data to XML format."""
    
    def export(self, data, filename):
        """Export data to XML."""
        print(f"📄 Exporting to XML: {filename}")
        
        # XML-specific implementation
        print("<data>")
        for row in data:
            print("  <row>")
            for key, value in row.items():
                print(f"    <{key}>{value}</{key}>")
            print("  </row>")
        print("</data>")
        
        print(f"✅ XML export complete!")

# ==================== POLYMORPHISM IN ACTION ====================

def export_data(exporter, data, filename):
    """Export data using any exporter (polymorphic function).
    
    We don't care what TYPE of exporter it is!
    We just call export() and it works!
    """
    print(f"\n{'='*60}")
    exporter.export(data, filename)
    print(f"{'='*60}\n")

# Sample data
campsites = [
    {'name': 'Vale do Capão', 'state': 'BA', 'price': 120.00},
    {'name': 'Serra da Canastra', 'state': 'MG', 'price': 80.00},
]

# Create different exporters
csv_exp = CSVExporter()
json_exp = JSONExporter()
xml_exp = XMLExporter()

# Use the SAME function with DIFFERENT exporters!
export_data(csv_exp, campsites, "campsites.csv")    # CSV version
export_data(json_exp, campsites, "campsites.json")  # JSON version
export_data(xml_exp, campsites, "campsites.xml")    # XML version

# ✨ Same interface (export method), different implementations!
# ✨ The export_data function doesn't need to know the type!
```

**Output:**
```
============================================================
📄 Exporting to CSV: campsites.csv
   Vale do Capão,BA,120.0
   Serra da Canastra,MG,80.0
✅ CSV export complete!
============================================================

============================================================
📄 Exporting to JSON: campsites.json
[
  {
    "name": "Vale do Capão",
    "state": "BA",
    "price": 120.0
  },
  {
    "name": "Serra da Canastra",
    "state": "MG",
    "price": 80.0
  }
]
✅ JSON export complete!
============================================================

============================================================
📄 Exporting to XML: campsites.xml
<data>
  <row>
    <name>Vale do Capão</name>
    <state>BA</state>
    <price>120.0</price>
  </row>
  <row>
    <name>Serra da Canastra</name>
    <state>MG</state>
    <price>80.0</price>
  </row>
</data>
✅ XML export complete!
============================================================
```

---

### 🦆 Duck Typing

**"If it walks like a duck and quacks like a duck, it's a duck!"**

Python doesn't check types - it checks if objects have the required methods.

```python
class Dog:
    def speak(self):
        return "Woof!"

class Cat:
    def speak(self):
        return "Meow!"

class Duck:
    def speak(self):
        return "Quack!"

class Car:
    def honk(self):  # Different method name!
        return "Beep!"

def make_it_speak(animal):
    """Make any object speak (duck typing).
    
    We don't check the TYPE.
    We just try to call speak() - if it works, great!
    """
    return animal.speak()

# All these work because they have speak() method
dog = Dog()
cat = Cat()
duck = Duck()

print(make_it_speak(dog))   # Woof!
print(make_it_speak(cat))   # Meow!
print(make_it_speak(duck))  # Quack!

# This fails because Car doesn't have speak()
car = Car()
try:
    print(make_it_speak(car))
except AttributeError as e:
    print(f"❌ Error: {e}")  # 'Car' object has no attribute 'speak'

# ✨ Python doesn't care about the TYPE (Dog, Cat, Duck)
# ✨ Python only cares if the object HAS the method!
```

---

### 🏗️ Real-World Data Engineering: Data Loader Polymorphism

```python
from abc import ABC, abstractmethod
from datetime import datetime
import json

# ========== ABSTRACT BASE CLASS ==========

class DataLoader(ABC):
    """Abstract base class for data loaders."""
    
    def __init__(self, name):
        """Initialize loader."""
        self.name = name
        self.loaded_count = 0
        self.error_count = 0
    
    @abstractmethod
    def load(self, data):
        """Load data (must be implemented by children)."""
        pass
    
    def get_statistics(self):
        """Get loading statistics."""
        return {
            'name': self.name,
            'loaded': self.loaded_count,
            'errors': self.error_count
        }

# ========== CONCRETE IMPLEMENTATIONS ==========

class DatabaseLoader(DataLoader):
    """Load data into database."""
    
    def __init__(self, table_name):
        """Initialize database loader."""
        super().__init__(f"Database: {table_name}")
        self.table_name = table_name
    
    def load(self, data):
        """Load data into database."""
        print(f"\n🗄️  Loading into database table: {self.table_name}")
        
        for row in data:
            try:
                # Simulate database insert
                query = f"INSERT INTO {self.table_name} VALUES ({row})"
                print(f"   ✅ {query[:60]}...")
                self.loaded_count += 1
            
            except Exception as e:
                print(f"   ❌ Error: {e}")
                self.error_count += 1
        
        print(f"📊 Database load complete: {self.loaded_count} rows")

class FileLoader(DataLoader):
    """Load data into file."""
    
    def __init__(self, file_path):
        """Initialize file loader."""
        super().__init__(f"File: {file_path}")
        self.file_path = file_path
    
    def load(self, data):
        """Load data into file."""
        print(f"\n📁 Loading into file: {self.file_path}")
        
        try:
            # Simulate file write
            with open(self.file_path, 'w') as f:
                for row in data:
                    f.write(json.dumps(row) + '\n')
                    self.loaded_count += 1
            
            print(f"📊 File load complete: {self.loaded_count} rows")
        
        except Exception as e:
            print(f"❌ Error: {e}")
            self.error_count = len(data)

class APILoader(DataLoader):
    """Load data to API endpoint."""
    
    def __init__(self, api_url):
        """Initialize API loader."""
        super().__init__(f"API: {api_url}")
        self.api_url = api_url
    
    def load(self, data):
        """Load data to API."""
        print(f"\n🌐 Loading to API: {self.api_url}")
        
        for row in data:
            try:
                # Simulate API POST
                print(f"   ✅ POST {self.api_url} - {row.get('name', 'record')}")
                self.loaded_count += 1
            
            except Exception as e:
                print(f"   ❌ Error: {e}")
                self.error_count += 1
        
        print(f"📊 API load complete: {self.loaded_count} rows")

class S3Loader(DataLoader):
    """Load data to S3 bucket."""
    
    def __init__(self, bucket, key):
        """Initialize S3 loader."""
        super().__init__(f"S3: s3://{bucket}/{key}")
        self.bucket = bucket
        self.key = key
    
    def load(self, data):
        """Load data to S3."""
        print(f"\n☁️  Loading to S3: s3://{self.bucket}/{self.key}")
        
        try:
            # Simulate S3 upload
            print(f"   📦 Preparing data...")
            print(f"   ⬆️  Uploading...")
            self.loaded_count = len(data)
            print(f"📊 S3 load complete: {self.loaded_count} rows")
        
        except Exception as e:
            print(f"❌ Error: {e}")
            self.error_count = len(data)

# ========== POLYMORPHIC PIPELINE ==========

class ETLPipeline:
    """ETL Pipeline that works with ANY loader (polymorphism)."""
    
    def __init__(self, loaders):
        """Initialize pipeline with list of loaders.
        
        Args:
            loaders: List of DataLoader objects (any type!)
        """
        self.loaders = loaders
    
    def run(self, data):
        """Run pipeline - load data to all destinations.
        
        This method doesn't care WHAT TYPE the loaders are!
        It just calls load() on each one - polymorphism!
        """
        print(f"\n{'='*70}")
        print(f"🚀 STARTING ETL PIPELINE")
        print(f"{'='*70}")
        print(f"Data rows: {len(data)}")
        print(f"Loaders: {len(self.loaders)}")
        print(f"{'='*70}")
        
        # Load to each destination
        for loader in self.loaders:
            loader.load(data)  # Polymorphic call!
        
        # Display summary
        self._display_summary()
    
    def _display_summary(self):
        """Display loading summary."""
        print(f"\n{'='*70}")
        print(f"📊 PIPELINE SUMMARY")
        print(f"{'='*70}")
        
        for loader in self.loaders:
            stats = loader.get_statistics()
            print(f"\n{stats['name']}")
            print(f"  ✅ Loaded: {stats['loaded']}")
            print(f"  ❌ Errors: {stats['errors']}")
        
        print(f"\n{'='*70}\n")

# ==================== USAGE ====================

# Sample data
campsites = [
    {'name': 'Vale do Capão', 'state': 'BA', 'price': 120.00},
    {'name': 'Serra da Canastra', 'state': 'MG', 'price': 80.00},
    {'name': 'Chapada Diamantina', 'state': 'BA', 'price': 100.00},
]

# Create different loaders
loaders = [
    DatabaseLoader('campsites'),
    FileLoader('output/campsites.json'),
    APILoader('https://api.example.com/campsites'),
    S3Loader('my-bucket', 'data/campsites.json')
]

# Create pipeline
pipeline = ETLPipeline(loaders)

# Run pipeline - it works with ALL loaders!
pipeline.run(campsites)

# ✨ The pipeline doesn't know the specific loader types!
# ✨ It just calls load() on each - that's polymorphism!
```

---

### 🎯 Real-World Example: Data Validator Polymorphism

```python
from abc import ABC, abstractmethod

# ========== ABSTRACT BASE CLASS ==========

class DataValidator(ABC):
    """Abstract base class for validators."""
    
    def __init__(self, field_name):
        """Initialize validator."""
        self.field_name = field_name
    
    @abstractmethod
    def validate(self, value):
        """Validate value (must be implemented by children)."""
        pass
    
    def get_error_message(self, value):
        """Get validation error message."""
        return f"Invalid {self.field_name}: {value}"

# ========== CONCRETE VALIDATORS ==========

class EmailValidator(DataValidator):
    """Validate email addresses."""
    
    def __init__(self):
        super().__init__("email")
    
    def validate(self, value):
        """Validate email format."""
        if '@' in value and '.' in value.split('@')[1]:
            return True, None
        return False, self.get_error_message(value)

class PriceValidator(DataValidator):
    """Validate prices."""
    
    def __init__(self, min_price=0, max_price=10000):
        super().__init__("price")
        self.min_price = min_price
        self.max_price = max_price
    
    def validate(self, value):
        """Validate price range."""
        try:
            price = float(value)
            if self.min_price <= price <= self.max_price:
                return True, None
            return False, f"Price must be between R${self.min_price} and R${self.max_price}"
        except (ValueError, TypeError):
            return False, self.get_error_message(value)

class StateValidator(DataValidator):
    """Validate Brazilian state codes."""
    
    VALID_STATES = ['BA', 'RJ', 'MG', 'RS', 'SP', 'SC', 'PR', 'PE', 'CE']
    
    def __init__(self):
        super().__init__("state")
    
    def validate(self, value):
        """Validate state code."""
        if value.upper() in self.VALID_STATES:
            return True, None
        return False, f"State must be one of: {', '.join(self.VALID_STATES)}"

class PhoneValidator(DataValidator):
    """Validate phone numbers."""
    
    def __init__(self):
        super().__init__("phone")
    
    def validate(self, value):
        """Validate phone format."""
        # Remove formatting
        digits = ''.join(c for c in value if c.isdigit())
        
        # Brazilian phone: 11 digits (with area code)
        if len(digits) == 11:
            return True, None
        return False, "Phone must have 11 digits (XX-XXXXX-XXXX)"

class DateValidator(DataValidator):
    """Validate dates."""
    
    def __init__(self):
        super().__init__("date")
    
    def validate(self, value):
        """Validate date format."""
        from datetime import datetime
        
        try:
            datetime.strptime(value, '%Y-%m-%d')
            return True, None
        except ValueError:
            return False, "Date must be in format YYYY-MM-DD"

# ========== DATA VALIDATION PIPELINE ==========

class DataQualityChecker:
    """Check data quality using multiple validators (polymorphism)."""
    
    def __init__(self):
        """Initialize checker."""
        self.validators = {}
        self.validation_results = []
    
    def add_validator(self, field_name, validator):
        """Add a validator for a field.
        
        Args:
            field_name: Field to validate
            validator: Any DataValidator object (polymorphism!)
        """
        self.validators[field_name] = validator
    
    def validate_record(self, record):
        """Validate a single record.
        
        Uses polymorphism - doesn't care what TYPE of validators!
        Just calls validate() on each one.
        """
        errors = []
        
        for field_name, validator in self.validators.items():
            if field_name in record:
                is_valid, error_msg = validator.validate(record[field_name])
                
                if not is_valid:
                    errors.append({
                        'field': field_name,
                        'value': record[field_name],
                        'error': error_msg
                    })
        
        return len(errors) == 0, errors
    
    def validate_dataset(self, dataset):
        """Validate entire dataset."""
        print(f"\n{'='*70}")
        print(f"🔍 VALIDATING DATASET")
        print(f"{'='*70}")
        print(f"Records: {len(dataset)}")
        print(f"Validators: {len(self.validators)}")
        print(f"{'='*70}\n")
        
        valid_count = 0
        invalid_count = 0
        
        for i, record in enumerate(dataset, 1):
            is_valid, errors = self.validate_record(record)
            
            if is_valid:
                valid_count += 1
                print(f"✅ Record {i}: Valid")
            else:
                invalid_count += 1
                print(f"❌ Record {i}: Invalid")
                for error in errors:
                    print(f"   • {error['error']}")
        
        # Display summary
        print(f"\n{'='*70}")
        print(f"📊 VALIDATION SUMMARY")
        print(f"{'='*70}")
        print(f"✅ Valid: {valid_count}")
        print(f"❌ Invalid: {invalid_count}")
        print(f"Accuracy: {valid_count/len(dataset)*100:.1f}%")
        print(f"{'='*70}\n")
        
        return valid_count, invalid_count

# ==================== USAGE ====================

# Sample data
customers = [
    {
        'name': 'João Silva',
        'email': 'joao@example.com',
        'phone': '11-98765-4321',
        'state': 'SP'
    },
    {
        'name': 'Maria Santos',
        'email': 'maria.invalid',  # ❌ Invalid email
        'phone': '123',  # ❌ Invalid phone
        'state': 'RJ'
    },
    {
        'name': 'Pedro Costa',
        'email': 'pedro@example.com',
        'phone': '21-99876-5432',
        'state': 'XX'  # ❌ Invalid state
    },
]

bookings = [
    {
        'campsite': 'Vale',
        'price': '150.00',
        'check_in': '2025-10-20'
    },
    {
        'campsite': 'Serra',
        'price': '-50.00',  # ❌ Invalid price
        'check_in': '2025/10/20'  # ❌ Invalid date format
    },
]

# Create checker
customer_checker = DataQualityChecker()

# Add validators (polymorphism - any validator works!)
customer_checker.add_validator('email', EmailValidator())
customer_checker.add_validator('phone', PhoneValidator())
customer_checker.add_validator('state', StateValidator())

# Validate customers
customer_checker.validate_dataset(customers)

# Create another checker for bookings
booking_checker = DataQualityChecker()
booking_checker.add_validator('price', PriceValidator(min_price=0, max_price=1000))
booking_checker.add_validator('check_in', DateValidator())

# Validate bookings
booking_checker.validate_dataset(bookings)

# ✨ Same validation logic works with DIFFERENT validators!
# ✨ We can easily add new validators without changing the checker!
```

---

### 🎯 Operator Overloading (Special Form of Polymorphism)

```python
class Money:
    """Represent money amounts with operator overloading."""
    
    def __init__(self, amount, currency='BRL'):
        """Initialize money."""
        self.amount = amount
        self.currency = currency
    
    def __add__(self, other):
        """Add two money amounts (+ operator)."""
        if isinstance(other, Money):
            if self.currency != other.currency:
                raise ValueError("Cannot add different currencies")
            return Money(self.amount + other.amount, self.currency)
        return Money(self.amount + other, self.currency)
    
    def __sub__(self, other):
        """Subtract money amounts (- operator)."""
        if isinstance(other, Money):
            if self.currency != other.currency:
                raise ValueError("Cannot subtract different currencies")
            return Money(self.amount - other.amount, self.currency)
        return Money(self.amount - other, self.currency)
    
    def __mul__(self, factor):
        """Multiply money (* operator)."""
        return Money(self.amount * factor, self.currency)
    
    def __str__(self):
        """String representation."""
        return f"{self.currency} {self.amount:.2f}"
    
    def __repr__(self):
        """Developer representation."""
        return f"Money({self.amount}, '{self.currency}')"

# ==================== USAGE ====================

# Create money objects
price1 = Money(120.00)
price2 = Money(80.00)
discount = Money(20.00)

# Use operators polymorphically!
total = price1 + price2  # Uses __add__
print(f"Total: {total}")

discounted = total - discount  # Uses __sub__
print(f"After discount: {discounted}")

double = price1 * 2  # Uses __mul__
print(f"Double price: {double}")

# ✨ Operators work like built-in types, but with our custom logic!
```

---

## ✅ Key Takeaways - Part 6

Make sure you understand:

1. ✅ **Polymorphism** = Same interface, different implementations
2. ✅ **Duck typing** = "If it has the method, it works"
3. ✅ Python doesn't check types - it checks methods/attributes
4. ✅ Write functions that work with ANY object that has the right methods
5. ✅ Use abstract base classes (ABC) to define interfaces
6. ✅ **Real benefit**: Add new types without changing existing code
7. ✅ **DATA ENGINEERING**: Multiple data sources, loaders, validators all with same interface
8. ✅ **Operator overloading**: Make custom objects work with +, -, *, etc.
9. ✅ **Flexibility**: Code works with current AND future types
10. ✅ **SOLID Principle**: Open for extension, closed for modification

**If any concept is still unclear, re-read the relevant section!**

---

## ✨ Part 7: Special Methods (Magic Methods / Dunder Methods)

### 🤔 What are Special Methods?

**Special Methods** (also called "Magic Methods" or "Dunder Methods") are methods with **double underscores** before and after the name: `__method__`

**They allow your objects to behave like built-in types!**

**Real-world analogy:**
- Your custom class can work with operators (+, -, *, /)
- Your custom class can work with built-in functions (len(), str(), print())
- Your custom class can be iterable (for loops)
- Your custom class can act like a dictionary or list

---

### 📊 Common Special Methods

```
SPECIAL METHOD CATEGORIES

┌─────────────────────────────────────────────────────────┐
│ STRING REPRESENTATION                                    │
│ __str__()  → str(obj), print(obj)                       │
│ __repr__() → repr(obj), interactive shell               │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ OPERATORS                                               │
│ __add__()  → obj1 + obj2                                │
│ __sub__()  → obj1 - obj2                                │
│ __mul__()  → obj1 * obj2                                │
│ __eq__()   → obj1 == obj2                               │
│ __lt__()   → obj1 < obj2                                │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ CONTAINER OPERATIONS                                    │
│ __len__()      → len(obj)                               │
│ __getitem__()  → obj[key]                               │
│ __setitem__()  → obj[key] = value                       │
│ __contains__() → item in obj                            │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ LIFECYCLE                                               │
│ __init__()  → Object creation                           │
│ __del__()   → Object deletion                           │
│ __call__()  → obj() - make object callable              │
└─────────────────────────────────────────────────────────┘
```

---

### 🏕️ Example 1: String Representation

```python
class Campsite:
    """Campsite with custom string representations."""
    
    def __init__(self, name, state, price):
        """Initialize campsite."""
        self.name = name
        self.state = state
        self.price = price
    
    def __str__(self):
        """User-friendly string representation.
        
        Used by: print(), str(), string formatting
        """
        return f"{self.name} ({self.state}) - R${self.price:.2f}/night"
    
    def __repr__(self):
        """Developer-friendly string representation.
        
        Used by: repr(), interactive shell, debugging
        Should ideally be valid Python code to recreate object
        """
        return f"Campsite('{self.name}', '{self.state}', {self.price})"

# ==================== USAGE ====================

camp = Campsite("Vale do Capão", "BA", 120.00)

# __str__ is used for print() and str()
print(camp)  # Vale do Capão (BA) - R$120.00/night
print(str(camp))  # Vale do Capão (BA) - R$120.00/night

# __repr__ is used in interactive shell and for debugging
print(repr(camp))  # Campsite('Vale do Capão', 'BA', 120.0)

# In interactive Python shell:
# >>> camp
# Campsite('Vale do Capão', 'BA', 120.0)

# In a list:
camps = [camp]
print(camps)  # [Campsite('Vale do Capão', 'BA', 120.0)]
```

---

### 🎯 Example 2: Comparison Operators

```python
class Booking:
    """Booking with comparison operators."""
    
    def __init__(self, customer, campsite, nights, total):
        """Initialize booking."""
        self.customer = customer
        self.campsite = campsite
        self.nights = nights
        self.total = total
    
    def __eq__(self, other):
        """Check equality (==).
        
        Two bookings are equal if they have the same total.
        """
        if not isinstance(other, Booking):
            return False
        return self.total == other.total
    
    def __lt__(self, other):
        """Less than comparison (<).
        
        Used for sorting - booking is less if total is less.
        """
        if not isinstance(other, Booking):
            return NotImplemented
        return self.total < other.total
    
    def __le__(self, other):
        """Less than or equal (<=)."""
        return self.total <= other.total
    
    def __gt__(self, other):
        """Greater than (>)."""
        return self.total > other.total
    
    def __ge__(self, other):
        """Greater than or equal (>=)."""
        return self.total >= other.total
    
    def __str__(self):
        """String representation."""
        return f"{self.customer} @ {self.campsite}: {self.nights} nights = R${self.total:.2f}"

# ==================== USAGE ====================

booking1 = Booking("João", "Vale", 3, 360.00)
booking2 = Booking("Maria", "Serra", 2, 240.00)
booking3 = Booking("Pedro", "Praia", 2, 240.00)

# Equality
print(f"booking1 == booking2: {booking1 == booking2}")  # False
print(f"booking2 == booking3: {booking2 == booking3}")  # True (same total)

# Comparison
print(f"booking1 > booking2: {booking1 > booking2}")  # True (360 > 240)
print(f"booking2 < booking1: {booking2 < booking1}")  # True (240 < 360)

# Sorting (uses __lt__)
bookings = [booking1, booking2, booking3]
sorted_bookings = sorted(bookings)

print("\nSorted by total:")
for booking in sorted_bookings:
    print(f"  {booking}")

# Output:
# Maria @ Serra: 2 nights = R$240.00
# Pedro @ Praia: 2 nights = R$240.00
# João @ Vale: 3 nights = R$360.00
```

---

### 🏗️ Real-World Example: Data Container

```python
class DataSet:
    """A custom dataset container with special methods."""
    
    def __init__(self, name):
        """Initialize dataset."""
        self.name = name
        self._data = []  # Private list to store data
    
    def __len__(self):
        """Return length (len() function).
        
        Usage: len(dataset)
        """
        return len(self._data)
    
    def __getitem__(self, index):
        """Get item by index (bracket notation).
        
        Usage: dataset[0], dataset[-1], dataset[1:3]
        """
        return self._data[index]
    
    def __setitem__(self, index, value):
        """Set item by index.
        
        Usage: dataset[0] = value
        """
        self._data[index] = value
    
    def __delitem__(self, index):
        """Delete item by index.
        
        Usage: del dataset[0]
        """
        del self._data[index]
    
    def __contains__(self, item):
        """Check if item exists ('in' operator).
        
        Usage: if item in dataset:
        """
        return item in self._data
    
    def __iter__(self):
        """Make object iterable (for loops).
        
        Usage: for row in dataset:
        """
        return iter(self._data)
    
    def __add__(self, other):
        """Combine datasets (+ operator).
        
        Usage: dataset1 + dataset2
        """
        if not isinstance(other, DataSet):
            raise TypeError("Can only add DataSet objects")
        
        combined = DataSet(f"{self.name} + {other.name}")
        combined._data = self._data + other._data
        return combined
    
    def __str__(self):
        """String representation."""
        return f"DataSet('{self.name}', {len(self._data)} rows)"
    
    def __repr__(self):
        """Developer representation."""
        return f"DataSet(name='{self.name}', rows={len(self._data)})"
    
    # Regular methods
    def add_row(self, row):
        """Add a row to the dataset."""
        self._data.append(row)
        print(f"✅ Added row: {row}")
    
    def display_summary(self):
        """Display dataset summary."""
        print(f"\n{'='*60}")
        print(f"📊 DATASET: {self.name}")
        print(f"{'='*60}")
        print(f"Rows: {len(self)}")  # Uses __len__
        
        if len(self) > 0:
            print(f"\nFirst row: {self[0]}")  # Uses __getitem__
            print(f"Last row: {self[-1]}")   # Uses __getitem__
        
        print(f"{'='*60}\n")

# ==================== USAGE ====================

# Create dataset
campsites = DataSet("Campsites")

# Add data
campsites.add_row({'name': 'Vale', 'price': 120.00})
campsites.add_row({'name': 'Serra', 'price': 80.00})
campsites.add_row({'name': 'Praia', 'price': 100.00})

# __len__ - works with len()
print(f"\nDataset size: {len(campsites)}")  # 3

# __getitem__ - access with []
print(f"First: {campsites[0]}")  # {'name': 'Vale', 'price': 120.0}
print(f"Last: {campsites[-1]}")  # {'name': 'Praia', 'price': 100.0}

# __setitem__ - modify with []
campsites[0] = {'name': 'Vale Premium', 'price': 150.00}
print(f"Modified: {campsites[0]}")

# __contains__ - check with 'in'
vale = {'name': 'Vale Premium', 'price': 150.00}
print(f"Vale in dataset: {vale in campsites}")  # True

# __iter__ - works in for loops
print("\nIterating:")
for camp in campsites:  # Uses __iter__
    print(f"  {camp}")

# __add__ - combine datasets
bookings = DataSet("Bookings")
bookings.add_row({'customer': 'João', 'total': 360.00})

combined = campsites + bookings  # Uses __add__
print(f"\nCombined: {combined}")  # DataSet('Campsites + Bookings', 4 rows)

# Display summary
campsites.display_summary()

# ✨ Our custom DataSet acts like a built-in list!
```

---

### 🎯 Real-World Example: Query Builder

```python
class QueryBuilder:
    """SQL query builder with special methods."""
    
    def __init__(self, table):
        """Initialize query builder."""
        self.table = table
        self._select_cols = ['*']
        self._where_clauses = []
        self._order_by = None
        self._limit = None
    
    def select(self, *columns):
        """Select columns."""
        self._select_cols = list(columns)
        return self  # Return self for chaining
    
    def where(self, condition):
        """Add WHERE clause."""
        self._where_clauses.append(condition)
        return self  # Return self for chaining
    
    def order_by(self, column):
        """Add ORDER BY clause."""
        self._order_by = column
        return self  # Return self for chaining
    
    def limit(self, n):
        """Add LIMIT clause."""
        self._limit = n
        return self  # Return self for chaining
    
    def __str__(self):
        """Build and return SQL query string."""
        # SELECT clause
        cols = ', '.join(self._select_cols)
        query = f"SELECT {cols} FROM {self.table}"
        
        # WHERE clause
        if self._where_clauses:
            conditions = ' AND '.join(self._where_clauses)
            query += f" WHERE {conditions}"
        
        # ORDER BY clause
        if self._order_by:
            query += f" ORDER BY {self._order_by}"
        
        # LIMIT clause
        if self._limit:
            query += f" LIMIT {self._limit}"
        
        return query
    
    def __repr__(self):
        """Developer representation."""
        return f"QueryBuilder(table='{self.table}')"
    
    def __call__(self):
        """Make query builder callable.
        
        Usage: query() - returns SQL string
        """
        return str(self)

# ==================== USAGE ====================

# Build query using method chaining
query = (QueryBuilder('campsites')
         .select('name', 'state', 'price')
         .where('state = "BA"')
         .where('price < 150')
         .order_by('price')
         .limit(10))

# __str__ is used when converting to string
print("Query:")
print(str(query))

# Output:
# SELECT name, state, price FROM campsites WHERE state = "BA" AND price < 150 ORDER BY price LIMIT 10

# __call__ makes object callable
sql = query()  # Uses __call__
print(f"\nExecuting: {sql}")

# ✨ Fluent interface with special methods!
```

---

### 🎯 Real-World Example: ETL Record

```python
from datetime import datetime

class ETLRecord:
    """ETL record with rich special methods."""
    
    def __init__(self, data, source=None):
        """Initialize ETL record."""
        self._data = data
        self.source = source
        self.created_at = datetime.now()
        self.transformations = []
    
    def __getitem__(self, key):
        """Access data like a dictionary."""
        return self._data[key]
    
    def __setitem__(self, key, value):
        """Set data like a dictionary."""
        self._data[key] = value
        self.transformations.append(f"SET {key} = {value}")
    
    def __delitem__(self, key):
        """Delete data like a dictionary."""
        del self._data[key]
        self.transformations.append(f"DELETE {key}")
    
    def __contains__(self, key):
        """Check if key exists."""
        return key in self._data
    
    def __len__(self):
        """Return number of fields."""
        return len(self._data)
    
    def __iter__(self):
        """Iterate over keys."""
        return iter(self._data)
    
    def __str__(self):
        """User-friendly representation."""
        fields = ', '.join(f"{k}={v}" for k, v in self._data.items())
        return f"ETLRecord({fields})"
    
    def __repr__(self):
        """Developer representation."""
        return f"ETLRecord(data={self._data}, source='{self.source}')"
    
    def __eq__(self, other):
        """Check if records are equal."""
        if not isinstance(other, ETLRecord):
            return False
        return self._data == other._data
    
    def __add__(self, other):
        """Merge two records."""
        if not isinstance(other, ETLRecord):
            raise TypeError("Can only add ETLRecord objects")
        
        merged_data = {**self._data, **other._data}
        merged = ETLRecord(merged_data, source=f"{self.source}+{other.source}")
        return merged
    
    def __call__(self):
        """Get underlying data dictionary."""
        return self._data.copy()
    
    # Regular methods
    def keys(self):
        """Get all keys."""
        return self._data.keys()
    
    def values(self):
        """Get all values."""
        return self._data.values()
    
    def items(self):
        """Get all items."""
        return self._data.items()
    
    def display_history(self):
        """Display transformation history."""
        print(f"\n{'='*60}")
        print(f"📋 ETL RECORD HISTORY")
        print(f"{'='*60}")
        print(f"Source: {self.source}")
        print(f"Created: {self.created_at}")
        print(f"Fields: {len(self)}")
        print(f"\nTransformations: {len(self.transformations)}")
        for i, trans in enumerate(self.transformations, 1):
            print(f"  {i}. {trans}")
        print(f"{'='*60}\n")

# ==================== USAGE ====================

# Create record
record = ETLRecord(
    data={'name': 'Vale', 'price': 120.00},
    source='CSV'
)

# Access like a dictionary
print(f"Name: {record['name']}")  # Uses __getitem__
print(f"Price: {record['price']}")

# Modify like a dictionary
record['state'] = 'BA'  # Uses __setitem__
record['price'] = 150.00  # Uses __setitem__

# Check membership
print(f"'name' in record: {'name' in record}")  # Uses __contains__

# Iterate
print("\nFields:")
for key in record:  # Uses __iter__
    print(f"  {key}: {record[key]}")

# Length
print(f"\nNumber of fields: {len(record)}")  # Uses __len__

# String representation
print(f"\nRecord: {record}")  # Uses __str__

# Merge records
extra = ETLRecord({'capacity': 30, 'amenities': 'Wi-Fi'}, source='API')
combined = record + extra  # Uses __add__
print(f"\nCombined: {combined}")

# Call to get data
data = record()  # Uses __call__
print(f"\nData dict: {data}")

# Display history
record.display_history()

# ✨ ETLRecord acts like a dictionary with extra features!
```

---

### 📚 Complete Special Methods Reference

```python
class CompleteExample:
    """Reference for all common special methods."""
    
    # ========== INITIALIZATION ==========
    
    def __init__(self, value):
        """Called when object is created: obj = Class(value)"""
        self.value = value
    
    def __del__(self):
        """Called when object is deleted: del obj"""
        pass
    
    # ========== STRING REPRESENTATION ==========
    
    def __str__(self):
        """Called by str(), print(): str(obj), print(obj)"""
        return f"Value: {self.value}"
    
    def __repr__(self):
        """Called by repr(): repr(obj), or in shell"""
        return f"CompleteExample({self.value})"
    
    # ========== COMPARISON OPERATORS ==========
    
    def __eq__(self, other):
        """Equal: obj1 == obj2"""
        return self.value == other.value
    
    def __ne__(self, other):
        """Not equal: obj1 != obj2"""
        return self.value != other.value
    
    def __lt__(self, other):
        """Less than: obj1 < obj2"""
        return self.value < other.value
    
    def __le__(self, other):
        """Less than or equal: obj1 <= obj2"""
        return self.value <= other.value
    
    def __gt__(self, other):
        """Greater than: obj1 > obj2"""
        return self.value > other.value
    
    def __ge__(self, other):
        """Greater than or equal: obj1 >= obj2"""
        return self.value >= other.value
    
    # ========== ARITHMETIC OPERATORS ==========
    
    def __add__(self, other):
        """Addition: obj1 + obj2"""
        return CompleteExample(self.value + other.value)
    
    def __sub__(self, other):
        """Subtraction: obj1 - obj2"""
        return CompleteExample(self.value - other.value)
    
    def __mul__(self, other):
        """Multiplication: obj1 * obj2"""
        return CompleteExample(self.value * other.value)
    
    def __truediv__(self, other):
        """Division: obj1 / obj2"""
        return CompleteExample(self.value / other.value)
    
    def __floordiv__(self, other):
        """Floor division: obj1 // obj2"""
        return CompleteExample(self.value // other.value)
    
    def __mod__(self, other):
        """Modulo: obj1 % obj2"""
        return CompleteExample(self.value % other.value)
    
    def __pow__(self, other):
        """Power: obj1 ** obj2"""
        return CompleteExample(self.value ** other.value)
    
    # ========== CONTAINER EMULATION ==========
    
    def __len__(self):
        """Length: len(obj)"""
        return len(self.value)
    
    def __getitem__(self, key):
        """Get item: obj[key]"""
        return self.value[key]
    
    def __setitem__(self, key, value):
        """Set item: obj[key] = value"""
        self.value[key] = value
    
    def __delitem__(self, key):
        """Delete item: del obj[key]"""
        del self.value[key]
    
    def __contains__(self, item):
        """Membership: item in obj"""
        return item in self.value
    
    def __iter__(self):
        """Iteration: for x in obj"""
        return iter(self.value)
    
    # ========== CALLABLE ==========
    
    def __call__(self, *args, **kwargs):
        """Make object callable: obj()"""
        return self.value
    
    # ========== CONTEXT MANAGER ==========
    
    def __enter__(self):
        """Enter context: with obj:"""
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Exit context: end of with block"""
        return False
    
    # ========== ATTRIBUTE ACCESS ==========
    
    def __getattr__(self, name):
        """Get non-existent attribute: obj.attr"""
        return None
    
    def __setattr__(self, name, value):
        """Set attribute: obj.attr = value"""
        self.__dict__[name] = value
    
    def __delattr__(self, name):
        """Delete attribute: del obj.attr"""
        del self.__dict__[name]
```

---

## ✅ Key Takeaways - Part 7

Make sure you understand:

1. ✅ **Special methods** = Methods with `__name__` format
2. ✅ Also called "magic methods" or "dunder methods" (double underscore)
3. ✅ Make your classes work with Python built-ins and operators
4. ✅ `__str__()` = User-friendly string (print, str)
5. ✅ `__repr__()` = Developer-friendly string (debugging)
6. ✅ `__len__()`, `__getitem__()` = Make objects act like containers
7. ✅ `__add__()`, `__eq__()` = Operator overloading
8. ✅ `__call__()` = Make objects callable like functions
9. ✅ **DATA ENGINEERING**: Custom data structures, query builders, ETL records
10. ✅ **BEST PRACTICE**: Implement special methods to make classes Pythonic and intuitive

**If any concept is still unclear, re-read the relevant section!**

---

## 🎉 Congratulations!

You've completed all 7 parts of the enhanced OOP explanations! 

### 📚 What You've Learned:
- **Part 1**: Classes and Objects fundamentals
- **Part 2**: Instance Methods
- **Part 3**: Class Attributes and Methods
- **Part 4**: Encapsulation and Data Hiding
- **Part 5**: Inheritance and Code Reuse
- **Part 6**: Polymorphism and Duck Typing
- **Part 7**: Special Methods (Magic Methods)

### 🚀 Next Steps:
1. **Practice**: Work through the exercises in the main OOP lesson
2. **Build Projects**: Apply these concepts in real data engineering projects
3. **Continue Learning**: Move on to Lesson 5 (Error Handling & Logging)

**Keep coding! 🎓**
