# Lesson 5: Error Handling and Logging

**Duration:** 1 week
**Difficulty:** Intermediate
**Prerequisites:** Lessons 1-4 completed (especially OOP concepts)

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

- ✅ Handle errors gracefully using try/except blocks
- ✅ Understand different exception types and when they occur
- ✅ Create custom exception classes using OOP inheritance
- ✅ Implement error handling in class methods
- ✅ Use Python's logging module effectively
- ✅ Configure loggers, handlers, and formatters
- ✅ Build robust data pipelines with comprehensive error handling
- ✅ Debug production issues using logs

---

## 📚 Table of Contents

1. [Introduction: Why Error Handling Matters](#introduction)
2. [Basic Try/Except Blocks](#basic-try-except)
3. [Common Exception Types](#exception-types)
4. [Finally, Else, and Exception Chaining](#advanced-error-handling)
5. [Custom Exception Classes](#custom-exceptions)
6. [Error Handling in Classes](#class-error-handling)
7. [Python Logging Basics](#logging-basics)
8. [Advanced Logging Features](#advanced-logging)
9. [ETL Pipeline Error Handling](#etl-error-handling)
10. [Best Practices](#best-practices)
11. [Practice Exercises](#exercises)

---

## `<a name="introduction"></a>`1. Introduction: Why Error Handling Matters

### 🔴 The Problem: Code Without Error Handling

Imagine you're running a critical data pipeline that processes millions of customer records every night. Without proper error handling:

```python
# ❌ BAD: No error handling
def load_customer_data():
    data = open("customers.csv").read()  # What if file doesn't exist?
    records = data.split("\n")
  
    for record in records:
        customer_id = int(record.split(",")[0])  # What if not a number?
        db.insert(customer_id)  # What if database is down?
  
    print("All done!")  # You'll never know if it actually worked!
```

**What can go wrong?**

1. **File doesn't exist** → Program crashes immediately
2. **File is empty** → Silent failure, no data loaded
3. **Invalid data format** → Crash midway through processing
4. **Database connection fails** → Data partially loaded, inconsistent state
5. **No logging** → When it fails at 3 AM, you have no idea why

**Real-World Impact:**

- ❌ Pipeline fails silently
- ❌ Incomplete data in production
- ❌ Hours spent debugging with no logs
- ❌ Business decisions made on bad data
- ❌ Your manager gets angry calls from stakeholders

---

### ✅ The Solution: Robust Error Handling + Logging

```python
# ✅ GOOD: With error handling and logging
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def load_customer_data():
    try:
        logger.info("Starting customer data load...")
      
        # Open file with error handling
        with open("customers.csv", "r") as f:
            data = f.read()
      
        if not data.strip():
            logger.warning("Customer file is empty, skipping load")
            return 0
      
        records = data.split("\n")
        loaded_count = 0
        error_count = 0
      
        for line_num, record in enumerate(records, start=1):
            try:
                customer_id = int(record.split(",")[0])
                db.insert(customer_id)
                loaded_count += 1
              
            except ValueError:
                logger.error(f"Line {line_num}: Invalid customer ID format: {record}")
                error_count += 1
                continue  # Skip this record, continue with others
          
            except DatabaseError as e:
                logger.critical(f"Database error: {e}")
                raise  # Stop processing, this is serious
      
        logger.info(f"Load complete: {loaded_count} records loaded, {error_count} errors")
        return loaded_count
      
    except FileNotFoundError:
        logger.error("Customer file not found: customers.csv")
        raise  # Re-raise so calling code knows it failed
  
    except Exception as e:
        logger.exception(f"Unexpected error during load: {e}")
        raise

# Usage
try:
    count = load_customer_data()
    print(f"Successfully loaded {count} customers")
except Exception as e:
    print(f"Pipeline failed: {e}")
    # Send alert to team
```

**Benefits:**

- ✅ Handles file not found gracefully
- ✅ Detects empty files and warns
- ✅ Continues processing valid records even if some fail
- ✅ Logs everything for debugging
- ✅ Different error severities (WARNING, ERROR, CRITICAL)
- ✅ Returns count so you know what happened
- ✅ Re-raises critical errors that should stop the pipeline

**Real-World Impact:**

- ✅ Pipeline recovers from expected errors
- ✅ Partial data loads are tracked
- ✅ Logs tell you exactly what happened at 3 AM
- ✅ Alerts sent only for critical issues
- ✅ You look like a hero! 🦸

---

## 2. Basic Try/Except Blocks

### 📖 How Try/Except Works

**The Pattern:**

```python
try:
    # Code that might raise an exception
    risky_operation()
except ExceptionType:
    # Code that runs if the exception occurs
    handle_error()
```

**Execution Flow:**

```
Normal Flow (no error):
┌─────────────┐
│ try block   │ ← Executes completely
└─────────────┘
       ↓
┌─────────────┐
│ except      │ ← SKIPPED (no error occurred)
└─────────────┘
       ↓
   Continue

Error Flow (exception raised):
┌─────────────┐
│ try block   │ ← Executes until error occurs
│ line 1 ✅   │
│ line 2 ❌   │ ← Exception raised here
│ line 3      │ ← SKIPPED (never executes)
└─────────────┘
       ↓
┌─────────────┐
│ except      │ ← Catches the error and handles it
└─────────────┘
       ↓
   Continue
```

---

### 🧪 Example 1: Basic Division Error

```python
# Without error handling
def divide_no_handling(a, b):
    result = a / b
    return result

# Try it:
print(divide_no_handling(10, 2))   # Works: 5.0
print(divide_no_handling(10, 0))   # ❌ CRASHES: ZeroDivisionError!
print("This line never runs")      # Never reached

# Output:
# 5.0
# Traceback (most recent call last):
#   File "script.py", line 8, in <module>
#     print(divide_no_handling(10, 0))
#   File "script.py", line 3, in divide_no_handling
#     result = a / b
# ZeroDivisionError: division by zero
```

**With error handling:**

```python
def divide_with_handling(a, b):
    try:
        result = a / b
        return result
    except ZeroDivisionError:
        print(f"Error: Cannot divide {a} by zero!")
        return None  # Return a safe default value

# Try it:
print(divide_with_handling(10, 2))   # Works: 5.0
print(divide_with_handling(10, 0))   # Handles error gracefully
print("This line DOES run now!")     # ✅ Program continues!

# Output:
# 5.0
# Error: Cannot divide 10 by zero!
# None
# This line DOES run now!
```

**Line-by-Line Breakdown:**

```python
def divide_with_handling(a, b):
    try:                              # 1. Start the "risky" code block
        result = a / b                # 2. Attempt division (might fail!)
        return result                 # 3. If successful, return result
    except ZeroDivisionError:         # 4. Catch this specific error type
        print(f"Error: Cannot divide {a} by zero!")  # 5. Handle it
        return None                   # 6. Return safe value instead of crashing
```

**What happens when b=0:**

1. Line 2 (`result = a / b`) raises `ZeroDivisionError`
2. Python immediately jumps to line 4 (the `except` block)
3. Line 3 (`return result`) is **skipped** (never executes)
4. Lines 5-6 execute (print error, return None)
5. Function returns `None` instead of crashing

---

### 🧪 Example 2: File Reading Errors

```python
# Real-world scenario: Reading a configuration file
def load_config_unsafe(filename):
    file = open(filename, 'r')
    data = file.read()
    file.close()
    return data

# Try it:
config = load_config_unsafe("settings.txt")  # ❌ FileNotFoundError if file doesn't exist!
```

**With error handling:**

```python
def load_config_safe(filename):
    try:
        with open(filename, 'r') as file:
            data = file.read()
        print(f"✅ Successfully loaded {filename}")
        return data
      
    except FileNotFoundError:
        print(f"❌ File not found: {filename}")
        print("Using default configuration instead")
        return "default_config_data"  # Fallback to defaults
  
    except PermissionError:
        print(f"❌ Permission denied: {filename}")
        print("Check file permissions")
        return None
  
    except Exception as e:
        print(f"❌ Unexpected error reading {filename}: {e}")
        return None

# Try it:
config1 = load_config_safe("settings.txt")     # File exists
config2 = load_config_safe("missing.txt")      # File doesn't exist
config3 = load_config_safe("/root/secure.txt") # No permission

# Output:
# ✅ Successfully loaded settings.txt
# ❌ File not found: missing.txt
# Using default configuration instead
# ❌ Permission denied: /root/secure.txt
# Check file permissions
```

**Key Points:**

1. **Multiple except blocks** catch different error types
2. **Specific exceptions first**, generic last
3. **Fallback values** prevent crashes
4. **User-friendly messages** explain what happened

---

### 🧪 Example 3: Data Type Conversion Errors

```python
# Converting user input to integers
def process_age(age_input):
    try:
        age = int(age_input)
      
        if age < 0:
            print("Age cannot be negative!")
            return None
      
        if age < 18:
            return "Minor"
        elif age < 65:
            return "Adult"
        else:
            return "Senior"
  
    except ValueError:
        print(f"Invalid age format: '{age_input}' is not a number")
        return None

# Test with different inputs:
print(process_age("25"))       # Works: "Adult"
print(process_age("70"))       # Works: "Senior"
print(process_age("abc"))      # Handles error gracefully
print(process_age("12.5"))     # Handles error (int() doesn't accept floats as strings)
print(process_age("-5"))       # Works, but caught by validation

# Output:
# Adult
# Senior
# Invalid age format: 'abc' is not a number
# None
# Invalid age format: '12.5' is not a number
# None
# Age cannot be negative!
# None
```

---

### 🔑 Key Takeaways: Basic Try/Except

1. **`try` block** contains code that might raise an exception
2. **`except` block** handles the exception if it occurs
3. **Specific exceptions** are better than catching everything
4. **Multiple except blocks** can handle different error types
5. **Program continues** after handling the error (doesn't crash)
6. **Return safe defaults** or None when errors occur
7. **Print helpful messages** to explain what went wrong

---

### ⚠️ Common Mistakes to Avoid

**Mistake 1: Catching too broadly**

```python
# ❌ BAD: Catches everything, even bugs you should fix
try:
    result = risky_operation()
except:  # Catches ALL exceptions, even KeyboardInterrupt!
    print("Something went wrong")
  
# ✅ GOOD: Catch specific exceptions
try:
    result = risky_operation()
except ValueError:
    print("Invalid value")
except KeyError:
    print("Key not found")
```

**Mistake 2: Empty except blocks**

```python
# ❌ BAD: Silent failure - errors disappear without a trace
try:
    result = risky_operation()
except:
    pass  # ERROR IS HIDDEN! You'll never know what happened

# ✅ GOOD: At minimum, log the error
try:
    result = risky_operation()
except Exception as e:
    print(f"Error: {e}")  # At least you know something went wrong
```

**Mistake 3: Not re-raising critical errors**

```python
# ❌ BAD: Database down? Let's continue anyway!
try:
    db.connect()
except DatabaseError:
    print("DB error, ignoring")  # Pipeline continues with no DB!
  
# ✅ GOOD: Re-raise errors that should stop the pipeline
try:
    db.connect()
except DatabaseError:
    logger.critical("Database connection failed!")
    raise  # Stop execution - this is critical!
```

---

**🎯 Next:** We'll explore different exception types and when each one occurs!

---

## <a name="exception-types"></a>3. Common Exception Types

Python has many built-in exception types. Understanding when each occurs helps you write better error handling.

### 📋 Common Exception Types Reference

| Exception Type | When It Occurs | Common Causes |
|---------------|----------------|---------------|
| `ValueError` | Valid type, wrong value | `int("abc")`, `float("xyz")` |
| `TypeError` | Wrong data type | `"text" + 5`, `len(123)` |
| `KeyError` | Dictionary key not found | `dict["missing_key"]` |
| `IndexError` | List index out of range | `list[999]` when list has 10 items |
| `FileNotFoundError` | File doesn't exist | `open("missing.txt")` |
| `PermissionError` | No permission to access | `open("/root/file.txt")` |
| `AttributeError` | Attribute doesn't exist | `"text".missing_method()` |
| `ZeroDivisionError` | Division by zero | `10 / 0` |
| `ImportError` | Module can't be imported | `import missing_module` |
| `ModuleNotFoundError` | Module doesn't exist | `import nonexistent` |
| `ConnectionError` | Network/database connection fails | API calls, DB connections |
| `TimeoutError` | Operation takes too long | Long-running queries |

---

### 🧪 Example 1: ValueError - Invalid Value Conversions

**When it occurs:** You have the right type, but the value can't be converted or used.

```python
# Converting strings to numbers
def parse_temperature(temp_string):
    """Convert temperature string to float."""
    try:
        temperature = float(temp_string)
        print(f"✅ Temperature: {temperature}°C")
        return temperature
        
    except ValueError as e:
        print(f"❌ Invalid temperature format: '{temp_string}'")
        print(f"   Error details: {e}")
        return None

# Test with different inputs
print("=== Testing Temperature Parsing ===")
parse_temperature("25.5")      # ✅ Works
parse_temperature("-10")       # ✅ Works
parse_temperature("abc")       # ❌ ValueError
parse_temperature("25.5.5")    # ❌ ValueError (too many decimals)
parse_temperature("")          # ❌ ValueError (empty string)

# Output:
# === Testing Temperature Parsing ===
# ✅ Temperature: 25.5°C
# ✅ Temperature: -10.0°C
# ❌ Invalid temperature format: 'abc'
#    Error details: could not convert string to float: 'abc'
# ❌ Invalid temperature format: '25.5.5'
#    Error details: could not convert string to float: '25.5.5'
# ❌ Invalid temperature format: ''
#    Error details: could not convert string to float: ''
```

**Real-World ETL Scenario:**

```python
def clean_sales_data(raw_data):
    """Clean sales data from CSV, handling invalid values."""
    cleaned_records = []
    error_records = []
    
    for row_num, row in enumerate(raw_data, start=1):
        try:
            # Try to convert price string to float
            price = float(row['price'])
            quantity = int(row['quantity'])
            
            # Validate values
            if price < 0:
                raise ValueError(f"Price cannot be negative: {price}")
            if quantity < 0:
                raise ValueError(f"Quantity cannot be negative: {quantity}")
            
            cleaned_records.append({
                'price': price,
                'quantity': quantity,
                'total': price * quantity
            })
            
        except ValueError as e:
            error_records.append({
                'row': row_num,
                'data': row,
                'error': str(e)
            })
    
    print(f"✅ Cleaned: {len(cleaned_records)} records")
    print(f"❌ Errors: {len(error_records)} records")
    
    return cleaned_records, error_records

# Test data
raw_data = [
    {'price': '19.99', 'quantity': '5'},      # Valid
    {'price': '29.99', 'quantity': '3'},      # Valid
    {'price': 'abc', 'quantity': '2'},        # Invalid price
    {'price': '15.00', 'quantity': 'xyz'},    # Invalid quantity
    {'price': '-5.00', 'quantity': '1'},      # Negative price
]

cleaned, errors = clean_sales_data(raw_data)

print("\n=== Error Report ===")
for error in errors:
    print(f"Row {error['row']}: {error['error']}")

# Output:
# ✅ Cleaned: 2 records
# ❌ Errors: 3 records
# 
# === Error Report ===
# Row 3: could not convert string to float: 'abc'
# Row 4: invalid literal for int() with base 10: 'xyz'
# Row 5: Price cannot be negative: -5.0
```

---

### 🧪 Example 2: TypeError - Wrong Data Types

**When it occurs:** You're using an operation on an incompatible data type.

```python
# Common TypeError scenarios
def demonstrate_type_errors():
    """Show common TypeError scenarios and how to handle them."""
    
    print("=== Scenario 1: Adding incompatible types ===")
    try:
        result = "Hello" + 5  # Can't add string and int
    except TypeError as e:
        print(f"❌ Error: {e}")
        print("✅ Fix: Convert to same type first")
        result = "Hello" + str(5)  # Convert int to string
        print(f"   Result: {result}")
    
    print("\n=== Scenario 2: Using len() on wrong type ===")
    try:
        length = len(12345)  # len() only works on sequences
    except TypeError as e:
        print(f"❌ Error: {e}")
        print("✅ Fix: Convert to string first")
        length = len(str(12345))
        print(f"   Length: {length}")
    
    print("\n=== Scenario 3: Calling non-callable object ===")
    try:
        my_var = 10
        result = my_var()  # 10 is not a function!
    except TypeError as e:
        print(f"❌ Error: {e}")
        print("✅ Fix: Check if object is callable")
        if callable(my_var):
            result = my_var()
        else:
            print("   my_var is not callable, skipping")

demonstrate_type_errors()

# Output:
# === Scenario 1: Adding incompatible types ===
# ❌ Error: can only concatenate str (not "int") to str
# ✅ Fix: Convert to same type first
#    Result: Hello5
# 
# === Scenario 2: Using len() on wrong type ===
# ❌ Error: object of type 'int' has no len()
# ✅ Fix: Convert to string first
#    Length: 5
# 
# === Scenario 3: Calling non-callable object ===
# ❌ Error: 'int' object is not callable
# ✅ Fix: Check if object is callable
#    my_var is not callable, skipping
```

**ETL Example: Type Validation**

```python
def validate_record_types(record):
    """Validate that record fields have correct types."""
    expected_types = {
        'customer_id': int,
        'name': str,
        'email': str,
        'age': int,
        'balance': (int, float),  # Can be either int or float
    }
    
    errors = []
    
    for field, expected_type in expected_types.items():
        if field not in record:
            errors.append(f"Missing field: {field}")
            continue
        
        try:
            value = record[field]
            
            # Check if value is instance of expected type
            if not isinstance(value, expected_type):
                errors.append(
                    f"Field '{field}': expected {expected_type.__name__}, "
                    f"got {type(value).__name__} (value: {value})"
                )
        except Exception as e:
            errors.append(f"Field '{field}': {e}")
    
    return errors

# Test records
test_records = [
    {
        'customer_id': 1,
        'name': 'Alice',
        'email': 'alice@email.com',
        'age': 30,
        'balance': 100.50
    },  # ✅ Valid
    {
        'customer_id': 'ABC',  # ❌ Should be int
        'name': 'Bob',
        'email': 'bob@email.com',
        'age': '25',  # ❌ Should be int
        'balance': 200
    },  # Partial errors
]

for i, record in enumerate(test_records, 1):
    print(f"\n=== Record {i} ===")
    errors = validate_record_types(record)
    
    if not errors:
        print("✅ All types valid")
    else:
        print(f"❌ Found {len(errors)} type errors:")
        for error in errors:
            print(f"   - {error}")

# Output:
# === Record 1 ===
# ✅ All types valid
# 
# === Record 2 ===
# ❌ Found 2 type errors:
#    - Field 'customer_id': expected int, got str (value: ABC)
#    - Field 'age': expected int, got str (value: 25)
```

---

### 🧪 Example 3: KeyError & IndexError - Missing Data

**KeyError:** Dictionary key doesn't exist  
**IndexError:** List/tuple index out of range

```python
# KeyError example
def get_customer_info(customer_data, customer_id):
    """Safely retrieve customer information."""
    try:
        # Direct dictionary access - raises KeyError if not found
        customer = customer_data[customer_id]
        print(f"✅ Found customer: {customer['name']}")
        return customer
        
    except KeyError:
        print(f"❌ Customer ID {customer_id} not found")
        return None

# Test data
customers = {
    101: {'name': 'Alice', 'email': 'alice@email.com'},
    102: {'name': 'Bob', 'email': 'bob@email.com'},
}

print("=== Testing KeyError Handling ===")
get_customer_info(customers, 101)  # ✅ Exists
get_customer_info(customers, 999)  # ❌ Doesn't exist

# Output:
# === Testing KeyError Handling ===
# ✅ Found customer: Alice
# ❌ Customer ID 999 not found
```

**Alternative: Using .get() method (no exception)**

```python
def get_customer_info_safe(customer_data, customer_id):
    """Retrieve customer using .get() - no exception raised."""
    # .get() returns None if key doesn't exist
    customer = customer_data.get(customer_id)
    
    if customer is None:
        print(f"❌ Customer ID {customer_id} not found")
        return None
    
    print(f"✅ Found customer: {customer['name']}")
    return customer

# Same behavior, but no exception is raised
get_customer_info_safe(customers, 101)  # ✅ Exists
get_customer_info_safe(customers, 999)  # ❌ Doesn't exist
```

**IndexError example:**

```python
def get_first_n_items(items, n):
    """Get first N items from a list."""
    try:
        # This will raise IndexError if n > len(items)
        result = items[:n]  # Slicing doesn't raise IndexError
        
        # But direct indexing does:
        last_item = items[n - 1]  # This can raise IndexError
        
        print(f"✅ Retrieved {len(result)} items")
        print(f"   Last item: {last_item}")
        return result
        
    except IndexError:
        print(f"❌ Index {n - 1} out of range (list has {len(items)} items)")
        return items  # Return all items instead

# Test
sales_data = [100, 200, 300, 400, 500]

print("=== Testing IndexError Handling ===")
get_first_n_items(sales_data, 3)   # ✅ Valid
get_first_n_items(sales_data, 10)  # ❌ Out of range

# Output:
# === Testing IndexError Handling ===
# ✅ Retrieved 3 items
#    Last item: 300
# ❌ Index 9 out of range (list has 5 items)
```

**ETL Example: Safe Data Access**

```python
def process_csv_row(row, row_num):
    """Process CSV row with safe field access."""
    required_fields = ['product_id', 'quantity', 'price']
    
    try:
        # Check if all required fields exist
        for field in required_fields:
            if field not in row:
                raise KeyError(f"Missing required field: {field}")
        
        # Extract values
        product_id = row['product_id']
        quantity = int(row['quantity'])
        price = float(row['price'])
        
        # Calculate total
        total = quantity * price
        
        print(f"✅ Row {row_num}: Product {product_id}, Total: ${total:.2f}")
        return {'product_id': product_id, 'total': total}
        
    except KeyError as e:
        print(f"❌ Row {row_num}: {e}")
        return None
    
    except ValueError as e:
        print(f"❌ Row {row_num}: Invalid number format - {e}")
        return None

# Test CSV data (as list of dictionaries)
csv_rows = [
    {'product_id': 'A001', 'quantity': '5', 'price': '19.99'},   # ✅ Valid
    {'product_id': 'B002', 'quantity': '3'},                     # ❌ Missing 'price'
    {'product_id': 'C003', 'quantity': 'abc', 'price': '29.99'}, # ❌ Invalid quantity
    {'product_id': 'D004', 'quantity': '2', 'price': '15.00'},   # ✅ Valid
]

print("=== Processing CSV Rows ===")
results = []
for i, row in enumerate(csv_rows, 1):
    result = process_csv_row(row, i)
    if result:
        results.append(result)

print(f"\n✅ Successfully processed {len(results)} out of {len(csv_rows)} rows")

# Output:
# === Processing CSV Rows ===
# ✅ Row 1: Product A001, Total: $99.95
# ❌ Row 2: Missing required field: price
# ❌ Row 3: Invalid number format - invalid literal for int() with base 10: 'abc'
# ✅ Row 4: Product D004, Total: $30.00
# 
# ✅ Successfully processed 2 out of 4 rows
```

---

### 🔑 Key Takeaways: Exception Types

1. **ValueError** - Right type, wrong value (e.g., `int("abc")`)
2. **TypeError** - Wrong type for operation (e.g., `"text" + 5`)
3. **KeyError** - Dictionary key doesn't exist (use `.get()` to avoid)
4. **IndexError** - List index out of range (check length first)
5. **FileNotFoundError** - File doesn't exist (check with `Path.exists()`)
6. **Catch specific exceptions** - Don't use bare `except:`
7. **Store error details** - Keep track of which records failed
8. **Continue processing** - Don't let one bad record stop the entire pipeline

---

**🎯 Next:** We'll learn about `finally`, `else`, and exception chaining!

---

## <a name="advanced-error-handling"></a>4. Finally, Else, and Exception Chaining

### 📖 The Complete Try/Except Structure

Python's error handling has **4 optional clauses**:

```python
try:
    # Code that might raise an exception
    risky_operation()
except ExceptionType:
    # Runs if exception occurs
    handle_error()
else:
    # Runs if NO exception occurs
    success_code()
finally:
    # ALWAYS runs (exception or not)
    cleanup_code()
```

**Execution Flow Diagram:**

```
┌─────────────────────────────────────────────────┐
│ 1. try block starts                             │
└─────────────────────────────────────────────────┘
                    ↓
         ┌──────────┴──────────┐
         │                     │
    Exception?            No Exception?
         │                     │
         ↓                     ↓
┌──────────────────┐  ┌──────────────────┐
│ 2. except block  │  │ 2. else block    │
│    (handles it)  │  │    (success!)    │
└──────────────────┘  └──────────────────┘
         │                     │
         └──────────┬──────────┘
                    ↓
         ┌─────────────────────┐
         │ 3. finally block    │
         │    (ALWAYS runs)    │
         └─────────────────────┘
                    ↓
              Continue
```

---

### 🧪 Example 1: The `finally` Block - Guaranteed Cleanup

**Use Case:** Code that **must** run, regardless of errors (cleanup, closing files, releasing locks).

```python
def read_file_with_finally(filename):
    """Demonstrate finally block for file cleanup."""
    file = None
    
    try:
        print(f"📂 Opening file: {filename}")
        file = open(filename, 'r')
        
        print("📖 Reading content...")
        content = file.read()
        
        print("🔢 Processing content...")
        # Simulate error during processing
        if len(content) > 1000:
            raise ValueError("File too large!")
        
        print(f"✅ Success! Read {len(content)} characters")
        return content
        
    except FileNotFoundError:
        print(f"❌ Error: File '{filename}' not found")
        return None
        
    except ValueError as e:
        print(f"❌ Error: {e}")
        return None
        
    finally:
        # This ALWAYS runs - even if there's a return or exception!
        if file is not None:
            print("🔒 Closing file (cleanup in finally block)")
            file.close()
        print("✅ finally block completed\n")

# Test 1: File doesn't exist
print("=== Test 1: Missing File ===")
read_file_with_finally("missing.txt")

# Test 2: File exists (create a test file)
print("=== Test 2: Valid File ===")
with open("test.txt", "w") as f:
    f.write("Hello, World!")
read_file_with_finally("test.txt")

# Output:
# === Test 1: Missing File ===
# 📂 Opening file: missing.txt
# ❌ Error: File 'missing.txt' not found
# ✅ finally block completed
# 
# === Test 2: Valid File ===
# 📂 Opening file: test.txt
# 📖 Reading content...
# 🔢 Processing content...
# ✅ Success! Read 13 characters
# 🔒 Closing file (cleanup in finally block)
# ✅ finally block completed
```

**Why `finally` is Important:**

```python
# ❌ BAD: File might not be closed if exception occurs
def read_file_bad(filename):
    file = open(filename, 'r')
    content = file.read()  # If this raises exception...
    file.close()           # ...this NEVER runs! File stays open!
    return content

# ✅ GOOD: finally ensures file is always closed
def read_file_good(filename):
    file = None
    try:
        file = open(filename, 'r')
        content = file.read()
        return content
    finally:
        if file:
            file.close()  # ALWAYS runs, even if exception or return

# ✅ BEST: Use context manager (with statement)
def read_file_best(filename):
    with open(filename, 'r') as file:  # Automatically closes file
        content = file.read()
        return content
```

---

### 🧪 Example 2: The `else` Block - Success-Only Code

**Use Case:** Code that should **only** run if no exception occurred.

```python
def process_data_with_else(data):
    """Demonstrate else block for success-only operations."""
    
    try:
        print("🔍 Validating data...")
        
        # Validate data
        if not data:
            raise ValueError("Data is empty")
        
        if not isinstance(data, list):
            raise TypeError("Data must be a list")
        
        print("✅ Validation passed")
        
    except ValueError as e:
        print(f"❌ Validation error: {e}")
        return None
        
    except TypeError as e:
        print(f"❌ Type error: {e}")
        return None
        
    else:
        # This ONLY runs if NO exception occurred
        print("📊 Processing data (else block)...")
        total = sum(data)
        average = total / len(data)
        
        print(f"   Total: {total}")
        print(f"   Average: {average}")
        
        return {'total': total, 'average': average}
    
    finally:
        print("🏁 Done\n")

# Test different scenarios
print("=== Test 1: Valid Data ===")
process_data_with_else([10, 20, 30, 40, 50])

print("=== Test 2: Empty Data ===")
process_data_with_else([])

print("=== Test 3: Wrong Type ===")
process_data_with_else("not a list")

# Output:
# === Test 1: Valid Data ===
# 🔍 Validating data...
# ✅ Validation passed
# 📊 Processing data (else block)...
#    Total: 150
#    Average: 30.0
# 🏁 Done
# 
# === Test 2: Empty Data ===
# 🔍 Validating data...
# ❌ Validation error: Data is empty
# 🏁 Done
# 
# === Test 3: Wrong Type ===
# 🔍 Validating data...
# ❌ Type error: Data must be a list
# 🏁 Done
```

**When to use `else` vs just putting code in `try`:**

```python
# ❌ CONFUSING: Everything in try block
try:
    validate_data()
    process_data()  # Did this fail validation or processing?
    save_data()     # Hard to tell which step failed
except Exception as e:
    print(f"Error: {e}")  # Which operation failed?

# ✅ CLEAR: Use else for success-only code
try:
    validate_data()  # Only validation in try
except ValidationError:
    print("Validation failed")
else:
    # These ONLY run if validation succeeded
    process_data()
    save_data()
```

---

### 🧪 Example 3: Database Connection with Finally

**Real-World Scenario:** Always close database connections.

```python
import psycopg2

def execute_query_safely(query):
    """Execute database query with proper cleanup."""
    connection = None
    cursor = None
    
    try:
        print("📡 Connecting to database...")
        connection = psycopg2.connect(
            dbname="mydb",
            user="user",
            password="pass",
            host="localhost"
        )
        
        print("✅ Connected")
        cursor = connection.cursor()
        
        print(f"🔍 Executing query: {query}")
        cursor.execute(query)
        
        print("📊 Fetching results...")
        results = cursor.fetchall()
        
        connection.commit()
        print(f"✅ Success! Got {len(results)} rows")
        
        return results
        
    except psycopg2.Error as e:
        print(f"❌ Database error: {e}")
        if connection:
            connection.rollback()
        return None
        
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return None
        
    finally:
        # ALWAYS clean up, even if there's an error
        print("🧹 Cleaning up...")
        
        if cursor:
            cursor.close()
            print("   ✅ Cursor closed")
        
        if connection:
            connection.close()
            print("   ✅ Connection closed")
        
        print("🏁 Cleanup complete\n")

# Usage
execute_query_safely("SELECT * FROM customers LIMIT 10")
```

---

### 🧪 Example 4: Exception Chaining with `from`

**Use Case:** Show the **original cause** of an error when re-raising or creating a new exception.

```python
def load_config_file(filename):
    """Load configuration with exception chaining."""
    try:
        with open(filename, 'r') as f:
            import json
            config = json.load(f)
        return config
        
    except FileNotFoundError as e:
        # Chain the exception - show both the original and new error
        raise RuntimeError(f"Failed to load config from {filename}") from e
        
    except json.JSONDecodeError as e:
        raise RuntimeError(f"Invalid JSON in {filename}") from e

def start_application():
    """Start application with config."""
    try:
        config = load_config_file("config.json")
        print(f"✅ Loaded config: {config}")
        
    except RuntimeError as e:
        print(f"❌ Application startup failed: {e}")
        print(f"   Original cause: {e.__cause__}")

# Test with missing file
print("=== Test: Missing Config ===")
start_application()

# Output:
# === Test: Missing Config ===
# ❌ Application startup failed: Failed to load config from config.json
#    Original cause: [Errno 2] No such file or directory: 'config.json'
```

**Full Traceback Shows the Chain:**

```python
# When exception chaining is used, Python shows:
# 
# Traceback (most recent call last):
#   File "script.py", line 5, in load_config_file
#     with open(filename, 'r') as f:
# FileNotFoundError: [Errno 2] No such file or directory: 'config.json'
# 
# The above exception was the direct cause of the following exception:
#                                    ↑ Shows the chain!
# 
# Traceback (most recent call last):
#   File "script.py", line 12, in start_application
#     config = load_config_file("config.json")
#   File "script.py", line 8, in load_config_file
#     raise RuntimeError(f"Failed to load config from {filename}") from e
# RuntimeError: Failed to load config from config.json
```

**Without Chaining vs With Chaining:**

```python
# ❌ WITHOUT CHAINING: Original error is hidden
try:
    result = int("abc")
except ValueError:
    raise RuntimeError("Processing failed")  # Why did it fail? Unknown!

# ✅ WITH CHAINING: Original error is preserved
try:
    result = int("abc")
except ValueError as e:
    raise RuntimeError("Processing failed") from e  # Shows both errors!

# ✅ WITH IMPLICIT CHAINING: Let Python handle it
try:
    result = int("abc")
except ValueError as e:
    # Just re-raise - Python automatically chains it
    raise
```

---

### 🧪 Example 5: Complete ETL with Finally and Else

**Real-World ETL Pipeline:**

```python
def etl_pipeline_with_cleanup(source_file, destination_db):
    """Complete ETL with proper error handling and cleanup."""
    
    # Resources to clean up
    source = None
    db_connection = None
    records_processed = 0
    
    try:
        # === EXTRACT ===
        print("📂 EXTRACT: Opening source file...")
        source = open(source_file, 'r')
        import csv
        reader = csv.DictReader(source)
        data = list(reader)
        print(f"✅ Extracted {len(data)} records")
        
        # === TRANSFORM ===
        print("\n🔄 TRANSFORM: Cleaning data...")
        cleaned_data = []
        
        for record in data:
            # Validate and transform
            if not record.get('customer_id'):
                raise ValueError(f"Missing customer_id in record: {record}")
            
            cleaned_data.append({
                'customer_id': int(record['customer_id']),
                'name': record['name'].strip().upper(),
                'email': record['email'].lower()
            })
        
        print(f"✅ Transformed {len(cleaned_data)} records")
        
        # === LOAD ===
        print("\n💾 LOAD: Connecting to database...")
        db_connection = connect_to_db(destination_db)
        print("✅ Connected")
        
        print("📥 Inserting records...")
        for record in cleaned_data:
            insert_record(db_connection, record)
            records_processed += 1
        
        db_connection.commit()
        print(f"✅ Loaded {records_processed} records")
        
    except FileNotFoundError as e:
        print(f"\n❌ EXTRACT ERROR: Source file not found: {e}")
        return False
        
    except ValueError as e:
        print(f"\n❌ TRANSFORM ERROR: Invalid data: {e}")
        if db_connection:
            db_connection.rollback()
        return False
        
    except Exception as e:
        print(f"\n❌ UNEXPECTED ERROR: {e}")
        if db_connection:
            db_connection.rollback()
        return False
        
    else:
        # Only runs if NO exceptions occurred
        print("\n✅ ETL PIPELINE COMPLETED SUCCESSFULLY!")
        print(f"   Records processed: {records_processed}")
        return True
        
    finally:
        # ALWAYS runs - cleanup resources
        print("\n🧹 CLEANUP:")
        
        if source is not None:
            source.close()
            print("   ✅ Source file closed")
        
        if db_connection is not None:
            db_connection.close()
            print("   ✅ Database connection closed")
        
        print(f"   📊 Final count: {records_processed} records processed")
        print("🏁 Pipeline execution complete\n")

# Usage
success = etl_pipeline_with_cleanup("customers.csv", "postgres://localhost/mydb")

if success:
    print("🎉 Pipeline succeeded!")
else:
    print("😞 Pipeline failed - check logs")
```

---

### 🔑 Key Takeaways: Finally, Else, and Chaining

1. **`finally`** - ALWAYS runs (cleanup, closing files/connections)
2. **`else`** - Only runs if NO exception occurred (success-only code)
3. **Use `finally` for cleanup** - Close files, connections, release locks
4. **Use `else` for clarity** - Separate validation from processing
5. **Context managers are better** - `with` statement handles cleanup automatically
6. **Exception chaining with `from`** - Preserves original error cause
7. **`raise` without arguments** - Re-raises the current exception
8. **Always clean up resources** - Use try/finally or context managers

---

**🎯 Next:** We'll create custom exception classes using OOP!

---

## <a name="custom-exceptions"></a>5. Custom Exception Classes

### 📖 Why Create Custom Exceptions?

Built-in exceptions like `ValueError` and `TypeError` are generic. Custom exceptions make your code more:
- **Specific** - Exact error types for your domain
- **Readable** - Clear what went wrong
- **Catchable** - Handle different errors differently
- **Professional** - Industry best practice

**Example of the Problem:**

```python
# ❌ BAD: Everything raises ValueError
def validate_customer(customer):
    if not customer.get('email'):
        raise ValueError("Email is missing")
    
    if '@' not in customer['email']:
        raise ValueError("Email is invalid")
    
    if customer.get('age', 0) < 18:
        raise ValueError("Customer too young")

# How do you know WHICH validation failed?
try:
    validate_customer(bad_data)
except ValueError as e:
    # Was it missing email? Invalid format? Age? Can't tell!
    print(f"Error: {e}")
```

**✅ GOOD: Specific custom exceptions**

```python
# Custom exception hierarchy
class ValidationError(Exception):
    """Base class for all validation errors."""
    pass

class MissingFieldError(ValidationError):
    """Raised when a required field is missing."""
    pass

class InvalidFormatError(ValidationError):
    """Raised when a field has invalid format."""
    pass

class BusinessRuleError(ValidationError):
    """Raised when business rules are violated."""
    pass

# Now you can catch specific errors!
def validate_customer(customer):
    if not customer.get('email'):
        raise MissingFieldError("Email is required")
    
    if '@' not in customer['email']:
        raise InvalidFormatError(f"Invalid email format: {customer['email']}")
    
    if customer.get('age', 0) < 18:
        raise BusinessRuleError("Customer must be 18 or older")

# Usage with specific handling
try:
    validate_customer(bad_data)
except MissingFieldError as e:
    print(f"Missing data: {e}")
    # Maybe use default values
except InvalidFormatError as e:
    print(f"Format issue: {e}")
    # Maybe try to fix the format
except BusinessRuleError as e:
    print(f"Business rule violated: {e}")
    # Maybe notify admin
```

---

### 🧪 Example 1: Basic Custom Exception

**The simplest custom exception:**

```python
class CustomError(Exception):
    """A custom exception class.
    
    Inherits from Exception - this is the base class for all exceptions.
    """
    pass

# Usage
def risky_operation():
    """Demonstrate custom exception."""
    raise CustomError("Something went wrong in my custom way!")

try:
    risky_operation()
except CustomError as e:
    print(f"Caught custom error: {e}")

# Output:
# Caught custom error: Something went wrong in my custom way!
```

**Line-by-Line Breakdown:**

```python
class CustomError(Exception):
    # ↑         ↑     ↑
    # |         |     └─ Inherit from Exception (Python's base exception class)
    # |         └─ Name of your custom exception (always ends with "Error")
    # └─ Define a new class (using OOP from Lesson 4!)
    
    """A custom exception class.
    
    Docstring explains:
    - What this exception represents
    - When it should be raised
    - Any special attributes or methods
    """
    
    pass
    # ↑
    # └─ Empty body (inherits everything from Exception)
```

---

### 🧪 Example 2: Custom Exception with Custom Message

**Add more context to your exceptions:**

```python
class DataQualityError(Exception):
    """Raised when data quality checks fail.
    
    Attributes:
        field (str): The field that failed validation
        value (any): The invalid value
        rule (str): The rule that was violated
    """
    
    def __init__(self, field, value, rule):
        """Initialize the exception with detailed information.
        
        Args:
            field: Name of the field that failed
            value: The actual value that was invalid
            rule: Description of the validation rule
        """
        self.field = field
        self.value = value
        self.rule = rule
        
        # Create a detailed error message
        message = f"Data quality error in field '{field}': {rule}"
        message += f"\n  Invalid value: {value}"
        
        # Call parent class __init__ with the message
        super().__init__(message)
    
    def __str__(self):
        """Return a readable string representation."""
        return f"DataQualityError({self.field}={self.value}, rule={self.rule})"

# Usage
def validate_age(age):
    """Validate age with detailed error information."""
    if not isinstance(age, (int, float)):
        raise DataQualityError(
            field='age',
            value=age,
            rule='Age must be a number'
        )
    
    if age < 0:
        raise DataQualityError(
            field='age',
            value=age,
            rule='Age cannot be negative'
        )
    
    if age > 150:
        raise DataQualityError(
            field='age',
            value=age,
            rule='Age must be less than 150'
        )
    
    return True

# Test different scenarios
print("=== Testing Age Validation ===")

test_cases = [
    25,      # ✅ Valid
    "abc",   # ❌ Not a number
    -5,      # ❌ Negative
    200,     # ❌ Too large
]

for test_age in test_cases:
    try:
        validate_age(test_age)
        print(f"✅ Age {test_age} is valid")
    except DataQualityError as e:
        print(f"❌ {e}")
        print(f"   Field: {e.field}")
        print(f"   Value: {e.value}")
        print(f"   Rule: {e.rule}\n")

# Output:
# === Testing Age Validation ===
# ✅ Age 25 is valid
# ❌ Data quality error in field 'age': Age must be a number
#   Invalid value: abc
#    Field: age
#    Value: abc
#    Rule: Age must be a number
# 
# ❌ Data quality error in field 'age': Age cannot be negative
#   Invalid value: -5
#    Field: age
#    Value: -5
#    Rule: Age cannot be negative
# 
# ❌ Data quality error in field 'age': Age must be less than 150
#   Invalid value: 200
#    Field: age
#    Value: 200
#    Rule: Age must be less than 150
```

---

### 🧪 Example 3: Exception Hierarchy for ETL Pipeline

**Create a family of related exceptions:**

```python
# Base exception for the entire ETL system
class ETLError(Exception):
    """Base exception for all ETL pipeline errors.
    
    All custom ETL exceptions inherit from this, making it easy
    to catch ANY ETL-related error with a single except block.
    """
    pass

# Extract phase exceptions
class ExtractError(ETLError):
    """Base exception for extraction errors."""
    pass

class DataSourceNotFoundError(ExtractError):
    """Raised when data source doesn't exist."""
    
    def __init__(self, source_path):
        self.source_path = source_path
        super().__init__(f"Data source not found: {source_path}")

class DataSourceConnectionError(ExtractError):
    """Raised when connection to data source fails."""
    
    def __init__(self, source, reason):
        self.source = source
        self.reason = reason
        super().__init__(f"Failed to connect to {source}: {reason}")

# Transform phase exceptions
class TransformError(ETLError):
    """Base exception for transformation errors."""
    pass

class DataValidationError(TransformError):
    """Raised when data validation fails."""
    
    def __init__(self, record, validation_errors):
        self.record = record
        self.validation_errors = validation_errors
        
        error_list = "\n  - ".join(validation_errors)
        super().__init__(
            f"Validation failed for record:\n  - {error_list}"
        )

class DataTransformationError(TransformError):
    """Raised when data transformation fails."""
    
    def __init__(self, field, value, transformation):
        self.field = field
        self.value = value
        self.transformation = transformation
        super().__init__(
            f"Failed to transform field '{field}' using {transformation}: "
            f"value={value}"
        )

# Load phase exceptions
class LoadError(ETLError):
    """Base exception for loading errors."""
    pass

class DatabaseConnectionError(LoadError):
    """Raised when database connection fails."""
    
    def __init__(self, database, reason):
        self.database = database
        self.reason = reason
        super().__init__(f"Cannot connect to database '{database}': {reason}")

class DatabaseInsertError(LoadError):
    """Raised when inserting data fails."""
    
    def __init__(self, table, record, reason):
        self.table = table
        self.record = record
        self.reason = reason
        super().__init__(
            f"Failed to insert into {table}: {reason}\n"
            f"Record: {record}"
        )

# Exception hierarchy visualization:
#
# ETLError (base)
# ├── ExtractError
# │   ├── DataSourceNotFoundError
# │   └── DataSourceConnectionError
# ├── TransformError
# │   ├── DataValidationError
# │   └── DataTransformationError
# └── LoadError
#     ├── DatabaseConnectionError
#     └── DatabaseInsertError
```

**Using the Exception Hierarchy:**

```python
def run_etl_pipeline(source_file, db_connection):
    """Run ETL pipeline with specific error handling.
    
    Args:
        source_file: Path to source data file
        db_connection: Database connection string
    
    Raises:
        DataSourceNotFoundError: If source file doesn't exist
        DataValidationError: If data validation fails
        DatabaseConnectionError: If cannot connect to database
        DatabaseInsertError: If insert operation fails
    """
    
    # === EXTRACT ===
    try:
        print("📂 EXTRACT: Reading source file...")
        
        import os
        if not os.path.exists(source_file):
            raise DataSourceNotFoundError(source_file)
        
        with open(source_file, 'r') as f:
            raw_data = f.read()
        
        print(f"✅ Extracted data from {source_file}")
        
    except FileNotFoundError:
        # Convert generic Python exception to our custom exception
        raise DataSourceNotFoundError(source_file)
    
    # === TRANSFORM ===
    try:
        print("\n🔄 TRANSFORM: Validating and transforming...")
        
        # Simulate validation
        validation_errors = []
        
        if not raw_data:
            validation_errors.append("Data is empty")
        
        if len(raw_data) < 10:
            validation_errors.append("Data too short (< 10 characters)")
        
        if validation_errors:
            raise DataValidationError(
                record=raw_data[:50],  # First 50 chars
                validation_errors=validation_errors
            )
        
        # Simulate transformation
        transformed_data = raw_data.upper()  # Simple transformation
        
        print(f"✅ Transformed {len(raw_data)} characters")
        
    except ValueError as e:
        # Convert generic exception to our custom exception
        raise DataTransformationError(
            field='data',
            value=raw_data[:50],
            transformation='uppercase'
        ) from e
    
    # === LOAD ===
    try:
        print("\n💾 LOAD: Inserting into database...")
        
        # Simulate database connection
        if 'invalid' in db_connection:
            raise DatabaseConnectionError(
                database=db_connection,
                reason="Invalid connection string"
            )
        
        # Simulate insert
        print(f"✅ Loaded data to {db_connection}")
        
    except Exception as e:
        if 'connection' in str(e).lower():
            raise DatabaseConnectionError(
                database=db_connection,
                reason=str(e)
            ) from e
        else:
            raise DatabaseInsertError(
                table='customers',
                record=transformed_data[:50],
                reason=str(e)
            ) from e

# Test the pipeline with different error scenarios
print("="*60)
print("=== Scenario 1: File Not Found ===")
print("="*60)
try:
    run_etl_pipeline("missing.csv", "postgres://localhost/db")
except DataSourceNotFoundError as e:
    print(f"❌ Extract Error: {e}")
    print(f"   Source: {e.source_path}")

print("\n" + "="*60)
print("=== Scenario 2: Database Connection Error ===")
print("="*60)
# Create test file
with open("test.csv", "w") as f:
    f.write("test,data,here")

try:
    run_etl_pipeline("test.csv", "invalid://connection")
except DatabaseConnectionError as e:
    print(f"❌ Load Error: {e}")
    print(f"   Database: {e.database}")
    print(f"   Reason: {e.reason}")

print("\n" + "="*60)
print("=== Scenario 3: Catch ANY ETL Error ===")
print("="*60)
try:
    run_etl_pipeline("missing.csv", "db")
except ETLError as e:
    # This catches ALL ETL-related errors!
    print(f"❌ ETL Pipeline Error: {type(e).__name__}")
    print(f"   Message: {e}")

# Output:
# ============================================================
# === Scenario 1: File Not Found ===
# ============================================================
# 📂 EXTRACT: Reading source file...
# ❌ Extract Error: Data source not found: missing.csv
#    Source: missing.csv
# 
# ============================================================
# === Scenario 2: Database Connection Error ===
# ============================================================
# 📂 EXTRACT: Reading source file...
# ✅ Extracted data from test.csv
# 
# 🔄 TRANSFORM: Validating and transforming...
# ✅ Transformed 14 characters
# 
# 💾 LOAD: Inserting into database...
# ❌ Load Error: Cannot connect to database 'invalid://connection': Invalid connection string
#    Database: invalid://connection
#    Reason: Invalid connection string
# 
# ============================================================
# === Scenario 3: Catch ANY ETL Error ===
# ============================================================
# 📂 EXTRACT: Reading source file...
# ❌ ETL Pipeline Error: DataSourceNotFoundError
#    Message: Data source not found: missing.csv
```

---

### 🔑 Key Takeaways: Custom Exceptions

1. **Inherit from Exception** - Base class for all exceptions
2. **Create hierarchies** - Base exception → Specific exceptions
3. **Add custom attributes** - Store field, value, rule information
4. **Override `__init__`** - Customize the error message
5. **Use descriptive names** - Always end with "Error"
6. **Document well** - Docstrings explain when to raise
7. **Catch specific exceptions** - Handle different errors differently
8. **Convert generic exceptions** - Wrap with custom exceptions for clarity

---

**🎯 Next:** We'll see how to handle errors within class methods!

---

## <a name="class-error-handling"></a>6. Error Handling in Classes

### 📖 Why Error Handling in Classes Matters

When building OOP systems (like ETL pipelines), you need to:
- **Validate in constructors** - Ensure objects are created in valid state
- **Validate in setters** - Prevent invalid data from being assigned
- **Handle errors in methods** - Methods can fail, handle gracefully
- **Raise custom exceptions** - Use your custom exception hierarchy

---

### 🧪 Example 1: Validation in `__init__` Constructor

**Ensure objects are never created in an invalid state:**

```python
class Customer:
    """Represents a customer with validation.
    
    A customer must have:
    - Valid email (contains @)
    - Age between 18 and 120
    - Non-empty name
    
    Raises:
        ValueError: If any validation fails
    """
    
    def __init__(self, name, email, age):
        """Initialize a customer with validation.
        
        Args:
            name (str): Customer's full name
            email (str): Customer's email address
            age (int): Customer's age
        
        Raises:
            ValueError: If name is empty
            ValueError: If email is invalid
            ValueError: If age is out of range
        """
        # Validate name
        if not name or not name.strip():
            raise ValueError("Name cannot be empty")
        
        # Validate email
        if not email or '@' not in email:
            raise ValueError(f"Invalid email address: {email}")
        
        # Validate age
        if not isinstance(age, int):
            raise TypeError(f"Age must be an integer, got {type(age).__name__}")
        
        if age < 18:
            raise ValueError(f"Customer must be at least 18 years old, got {age}")
        
        if age > 120:
            raise ValueError(f"Age must be less than 120, got {age}")
        
        # All validations passed - set attributes
        self.name = name.strip()
        self.email = email.lower()
        self.age = age
    
    def __repr__(self):
        """Return string representation of customer."""
        return f"Customer(name='{self.name}', email='{self.email}', age={self.age})"


# Test valid customer
print("=== Test 1: Valid Customer ===")
try:
    customer1 = Customer("Alice Smith", "alice@email.com", 25)
    print(f"✅ Created: {customer1}")
except ValueError as e:
    print(f"❌ Error: {e}")

# Test invalid customers
print("\n=== Test 2: Empty Name ===")
try:
    customer2 = Customer("", "bob@email.com", 30)
except ValueError as e:
    print(f"❌ Error: {e}")

print("\n=== Test 3: Invalid Email ===")
try:
    customer3 = Customer("Charlie", "invalid-email", 35)
except ValueError as e:
    print(f"❌ Error: {e}")

print("\n=== Test 4: Age Too Young ===")
try:
    customer4 = Customer("David", "david@email.com", 15)
except ValueError as e:
    print(f"❌ Error: {e}")

print("\n=== Test 5: Wrong Type for Age ===")
try:
    customer5 = Customer("Eve", "eve@email.com", "twenty-five")
except TypeError as e:
    print(f"❌ Error: {e}")

# Output:
# === Test 1: Valid Customer ===
# ✅ Created: Customer(name='Alice Smith', email='alice@email.com', age=25)
# 
# === Test 2: Empty Name ===
# ❌ Error: Name cannot be empty
# 
# === Test 3: Invalid Email ===
# ❌ Error: Invalid email address: invalid-email
# 
# === Test 4: Age Too Young ===
# ❌ Error: Customer must be at least 18 years old, got 15
# 
# === Test 5: Wrong Type for Age ===
# ❌ Error: Age must be an integer, got str
```

---

### 🧪 Example 2: Validation with Property Setters

**Use `@property` to validate when attributes are changed:**

```python
class BankAccount:
    """Bank account with validated balance.
    
    Balance must always be non-negative (no overdrafts).
    Uses property setter to validate all balance changes.
    """
    
    def __init__(self, account_number, initial_balance=0):
        """Initialize bank account.
        
        Args:
            account_number (str): Unique account identifier
            initial_balance (float): Starting balance (default 0)
        
        Raises:
            ValueError: If initial_balance is negative
        """
        self.account_number = account_number
        self._balance = 0  # Private attribute
        
        # Use the property setter for validation
        self.balance = initial_balance
    
    @property
    def balance(self):
        """Get current balance.
        
        Returns:
            float: Current account balance
        """
        return self._balance
    
    @balance.setter
    def balance(self, value):
        """Set balance with validation.
        
        Args:
            value (float): New balance amount
        
        Raises:
            ValueError: If value is negative
            TypeError: If value is not a number
        """
        # Type validation
        if not isinstance(value, (int, float)):
            raise TypeError(
                f"Balance must be a number, got {type(value).__name__}"
            )
        
        # Business rule validation
        if value < 0:
            raise ValueError(
                f"Balance cannot be negative, attempted to set: {value}"
            )
        
        # Validation passed - set the private attribute
        self._balance = float(value)
    
    def deposit(self, amount):
        """Deposit money into account.
        
        Args:
            amount (float): Amount to deposit
        
        Raises:
            ValueError: If amount is not positive
        
        Returns:
            float: New balance after deposit
        """
        if amount <= 0:
            raise ValueError(f"Deposit amount must be positive, got {amount}")
        
        self.balance += amount  # Uses setter validation
        print(f"💰 Deposited ${amount:.2f}")
        return self.balance
    
    def withdraw(self, amount):
        """Withdraw money from account.
        
        Args:
            amount (float): Amount to withdraw
        
        Raises:
            ValueError: If amount is not positive
            ValueError: If insufficient funds
        
        Returns:
            float: New balance after withdrawal
        """
        if amount <= 0:
            raise ValueError(f"Withdrawal amount must be positive, got {amount}")
        
        if amount > self.balance:
            raise ValueError(
                f"Insufficient funds: balance=${self.balance:.2f}, "
                f"attempted withdrawal=${amount:.2f}"
            )
        
        self.balance -= amount  # Uses setter validation
        print(f"💸 Withdrew ${amount:.2f}")
        return self.balance
    
    def __repr__(self):
        """Return string representation."""
        return f"BankAccount({self.account_number}, balance=${self.balance:.2f})"


# Test the bank account
print("=== Creating Account ===")
account = BankAccount("ACC-12345", initial_balance=1000)
print(f"✅ {account}")

print("\n=== Valid Operations ===")
try:
    account.deposit(500)
    print(f"Balance: ${account.balance:.2f}")
    
    account.withdraw(200)
    print(f"Balance: ${account.balance:.2f}")
except ValueError as e:
    print(f"❌ Error: {e}")

print("\n=== Invalid Operations ===")

# Test negative deposit
try:
    account.deposit(-100)
except ValueError as e:
    print(f"❌ Deposit Error: {e}")

# Test overdraft
try:
    account.withdraw(2000)  # More than balance
except ValueError as e:
    print(f"❌ Withdrawal Error: {e}")

# Test direct balance manipulation (blocked by setter!)
try:
    account.balance = -500
except ValueError as e:
    print(f"❌ Balance Error: {e}")

print(f"\n✅ Final {account}")

# Output:
# === Creating Account ===
# ✅ BankAccount(ACC-12345, balance=$1000.00)
# 
# === Valid Operations ===
# 💰 Deposited $500.00
# Balance: $1500.00
# 💸 Withdrew $200.00
# Balance: $1300.00
# 
# === Invalid Operations ===
# ❌ Deposit Error: Deposit amount must be positive, got -100
# ❌ Withdrawal Error: Insufficient funds: balance=$1300.00, attempted withdrawal=$2000.00
# ❌ Balance Error: Balance cannot be negative, attempted to set: -500
# 
# ✅ Final BankAccount(ACC-12345, balance=$1300.00)
```

---

### 🧪 Example 3: Error Handling in Class Methods

**Methods that interact with external resources need error handling:**

```python
class DataExtractor:
    """Extracts data from various sources with error handling.
    
    Handles file reading errors gracefully and tracks failures.
    """
    
    def __init__(self):
        """Initialize the extractor."""
        self.successful_reads = 0
        self.failed_reads = 0
        self.errors = []
    
    def extract_from_file(self, filename):
        """Extract data from a file with error handling.
        
        Args:
            filename (str): Path to file to read
        
        Returns:
            dict: Data and metadata, or None if failed
        """
        try:
            print(f"📂 Attempting to read: {filename}")
            
            # Try to open and read file
            with open(filename, 'r') as file:
                content = file.read()
            
            # Validate content
            if not content.strip():
                raise ValueError(f"File is empty: {filename}")
            
            # Success!
            self.successful_reads += 1
            print(f"✅ Successfully read {len(content)} characters")
            
            return {
                'filename': filename,
                'content': content,
                'size': len(content),
                'status': 'success'
            }
        
        except FileNotFoundError as e:
            # File doesn't exist
            error_msg = f"File not found: {filename}"
            print(f"❌ {error_msg}")
            
            self.failed_reads += 1
            self.errors.append({
                'filename': filename,
                'error_type': 'FileNotFoundError',
                'message': error_msg
            })
            
            return None
        
        except PermissionError as e:
            # No permission to read
            error_msg = f"Permission denied: {filename}"
            print(f"❌ {error_msg}")
            
            self.failed_reads += 1
            self.errors.append({
                'filename': filename,
                'error_type': 'PermissionError',
                'message': error_msg
            })
            
            return None
        
        except ValueError as e:
            # Custom validation error
            error_msg = str(e)
            print(f"❌ Validation Error: {error_msg}")
            
            self.failed_reads += 1
            self.errors.append({
                'filename': filename,
                'error_type': 'ValueError',
                'message': error_msg
            })
            
            return None
        
        except Exception as e:
            # Unexpected error
            error_msg = f"Unexpected error reading {filename}: {e}"
            print(f"❌ {error_msg}")
            
            self.failed_reads += 1
            self.errors.append({
                'filename': filename,
                'error_type': type(e).__name__,
                'message': error_msg
            })
            
            return None
    
    def extract_batch(self, filenames):
        """Extract data from multiple files.
        
        Args:
            filenames (list): List of file paths
        
        Returns:
            list: Successfully extracted data (excludes failures)
        """
        results = []
        
        print(f"📦 Starting batch extraction of {len(filenames)} files\n")
        
        for filename in filenames:
            result = self.extract_from_file(filename)
            
            if result is not None:
                results.append(result)
            
            print()  # Blank line between files
        
        return results
    
    def get_summary(self):
        """Get extraction summary statistics.
        
        Returns:
            dict: Summary of extraction results
        """
        total = self.successful_reads + self.failed_reads
        success_rate = (self.successful_reads / total * 100) if total > 0 else 0
        
        return {
            'total_attempts': total,
            'successful': self.successful_reads,
            'failed': self.failed_reads,
            'success_rate': f"{success_rate:.1f}%",
            'errors': self.errors
        }
    
    def print_summary(self):
        """Print a formatted summary."""
        summary = self.get_summary()
        
        print("="*60)
        print("📊 EXTRACTION SUMMARY")
        print("="*60)
        print(f"Total Attempts:  {summary['total_attempts']}")
        print(f"✅ Successful:   {summary['successful']}")
        print(f"❌ Failed:       {summary['failed']}")
        print(f"Success Rate:    {summary['success_rate']}")
        
        if summary['errors']:
            print(f"\n❌ Errors ({len(summary['errors'])}):")
            for i, error in enumerate(summary['errors'], 1):
                print(f"  {i}. {error['filename']}")
                print(f"     Type: {error['error_type']}")
                print(f"     Message: {error['message']}")
        
        print("="*60)


# Create test files
with open("valid_file.txt", "w") as f:
    f.write("This is valid data content")

with open("empty_file.txt", "w") as f:
    f.write("")  # Empty file

# Test the extractor
extractor = DataExtractor()

# Extract from multiple files (some exist, some don't)
files_to_extract = [
    "valid_file.txt",      # ✅ Exists
    "missing_file.txt",    # ❌ Doesn't exist
    "empty_file.txt",      # ❌ Empty
    "another_missing.txt"  # ❌ Doesn't exist
]

results = extractor.extract_batch(files_to_extract)

print(f"\n✅ Successfully extracted {len(results)} files")
print(f"❌ Failed to extract {len(files_to_extract) - len(results)} files\n")

extractor.print_summary()

# Output:
# 📦 Starting batch extraction of 4 files
# 
# 📂 Attempting to read: valid_file.txt
# ✅ Successfully read 27 characters
# 
# 📂 Attempting to read: missing_file.txt
# ❌ File not found: missing_file.txt
# 
# 📂 Attempting to read: empty_file.txt
# ❌ Validation Error: File is empty: empty_file.txt
# 
# 📂 Attempting to read: another_missing.txt
# ❌ File not found: another_missing.txt
# 
# ✅ Successfully extracted 1 files
# ❌ Failed to extract 3 files
# 
# ============================================================
# 📊 EXTRACTION SUMMARY
# ============================================================
# Total Attempts:  4
# ✅ Successful:   1
# ❌ Failed:       3
# Success Rate:    25.0%
# 
# ❌ Errors (3):
#   1. missing_file.txt
#      Type: FileNotFoundError
#      Message: File not found: missing_file.txt
#   2. empty_file.txt
#      Type: ValueError
#      Message: File is empty: empty_file.txt
#   3. another_missing.txt
#      Type: FileNotFoundError
#      Message: File not found: another_missing.txt
# ============================================================
```

---

### 🔑 Key Takeaways: Error Handling in Classes

1. **Validate in `__init__`** - Prevent invalid objects from being created
2. **Use property setters** - Validate when attributes change
3. **Raise specific exceptions** - Use ValueError, TypeError, or custom exceptions
4. **Document exceptions** - Use docstrings to specify what can be raised
5. **Track errors in methods** - Store error information for reporting
6. **Continue on non-critical errors** - Don't stop processing for recoverable errors
7. **Provide summaries** - Report success/failure statistics
8. **Clean error messages** - Help users understand what went wrong

---

**🎯 Next:** We'll learn Python's logging module for professional error tracking!

---

## <a name="logging-basics"></a>7. Python Logging Basics

### 📖 Why Use Logging Instead of Print?

**The Problem with `print()` statements:**

```python
# ❌ BAD: Using print() for debugging
def process_data(data):
    print("Starting processing...")
    print(f"Got {len(data)} records")
    
    for record in data:
        print(f"Processing {record}")
        # ... process ...
    
    print("Done!")
```

**Problems:**
- ❌ Goes to stdout (mixed with normal output)
- ❌ No severity levels (info, warning, error)
- ❌ Can't disable without editing code
- ❌ No timestamps
- ❌ Can't save to files
- ❌ No control over format
- ❌ Not professional

**✅ GOOD: Using Python's logging module**

```python
import logging

# Configure logging once
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def process_data(data):
    logger.info("Starting processing...")
    logger.info(f"Got {len(data)} records")
    
    for record in data:
        logger.debug(f"Processing {record}")
        # ... process ...
    
    logger.info("Done!")
```

**Benefits:**
- ✅ Separate log levels (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- ✅ Timestamps automatically added
- ✅ Can save to files
- ✅ Can disable debug logs in production
- ✅ Professional and standard
- ✅ Flexible formatting

---

### 📊 Understanding Log Levels

Python has **5 log levels** in order of severity:

| Level | Numeric Value | When to Use | Example |
|-------|--------------|-------------|---------|
| **DEBUG** | 10 | Detailed diagnostic info (development only) | Variable values, loop iterations |
| **INFO** | 20 | General informational messages | Pipeline started, record counts |
| **WARNING** | 30 | Something unexpected but not an error | Missing optional field, deprecated API |
| **ERROR** | 40 | Error occurred, but program continues | Failed to process one record |
| **CRITICAL** | 50 | Serious error, program may crash | Database down, out of memory |

**How Level Filtering Works:**

```python
# If you set level to INFO:
logging.basicConfig(level=logging.INFO)

logger.debug("This won't appear")     # ❌ Filtered out (DEBUG < INFO)
logger.info("This appears")           # ✅ Shows (INFO == INFO)
logger.warning("This appears")        # ✅ Shows (WARNING > INFO)
logger.error("This appears")          # ✅ Shows (ERROR > INFO)
logger.critical("This appears")       # ✅ Shows (CRITICAL > INFO)
```

---

### 🧪 Example 1: Basic Logging Setup

**The simplest logging configuration:**

```python
import logging

# Configure logging (do this ONCE at the start of your program)
logging.basicConfig(
    level=logging.DEBUG,  # Show all messages DEBUG and above
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Create a logger for this module
logger = logging.getLogger(__name__)

# Test all log levels
logger.debug("🔍 This is a DEBUG message - detailed diagnostics")
logger.info("ℹ️  This is an INFO message - general information")
logger.warning("⚠️  This is a WARNING message - something unexpected")
logger.error("❌ This is an ERROR message - something failed")
logger.critical("🔥 This is a CRITICAL message - serious problem!")

# Output:
# 2024-01-15 14:30:01,234 - DEBUG - 🔍 This is a DEBUG message - detailed diagnostics
# 2024-01-15 14:30:01,235 - INFO - ℹ️  This is an INFO message - general information
# 2024-01-15 14:30:01,236 - WARNING - ⚠️  This is a WARNING message - something unexpected
# 2024-01-15 14:30:01,237 - ERROR - ❌ This is an ERROR message - something failed
# 2024-01-15 14:30:01,238 - CRITICAL - 🔥 This is a CRITICAL message - serious problem!
```

**Understanding the Format String:**

```python
format='%(asctime)s - %(levelname)s - %(message)s'
#       ↑            ↑               ↑
#       |            |               └─ Your log message
#       |            └─ Log level (DEBUG, INFO, etc.)
#       └─ Timestamp when log was created

# Common format placeholders:
# %(asctime)s     - Timestamp (2024-01-15 14:30:01,234)
# %(levelname)s   - Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
# %(message)s     - The log message
# %(name)s        - Logger name (usually module name)
# %(filename)s    - File where log was called
# %(lineno)d      - Line number where log was called
# %(funcName)s    - Function name where log was called
```

---

### 🧪 Example 2: Logging to Files

**Save logs to a file instead of console:**

```python
import logging

# Configure logging to save to file
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    filename='application.log',      # Save to this file
    filemode='a'                      # 'a' = append, 'w' = overwrite
)

logger = logging.getLogger(__name__)

logger.info("Application started")
logger.info("Processing data...")
logger.warning("Configuration file not found, using defaults")
logger.error("Failed to connect to database")
logger.info("Application finished")

print("✅ Logs saved to application.log")

# Check the file
with open('application.log', 'r') as f:
    print("\n📄 Log file contents:")
    print(f.read())

# Output (in application.log):
# 2024-01-15 14:35:00,123 - INFO - Application started
# 2024-01-15 14:35:00,124 - INFO - Processing data...
# 2024-01-15 14:35:00,125 - WARNING - Configuration file not found, using defaults
# 2024-01-15 14:35:00,126 - ERROR - Failed to connect to database
# 2024-01-15 14:35:00,127 - INFO - Application finished
```

---

### 🧪 Example 3: Logging to Both Console and File

**Most production applications log to both:**

```python
import logging

# Create a logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# Create console handler (for terminal output)
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)  # Only INFO+ to console

# Create file handler (for file output)
file_handler = logging.FileHandler('debug.log')
file_handler.setLevel(logging.DEBUG)  # Everything to file

# Create formatters
console_format = logging.Formatter('%(levelname)s - %(message)s')
file_format = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Set formatters
console_handler.setFormatter(console_format)
file_handler.setFormatter(file_format)

# Add handlers to logger
logger.addHandler(console_handler)
logger.addHandler(file_handler)

# Now log some messages
logger.debug("Detailed debug information")       # Only in file
logger.info("General information")               # Console + file
logger.warning("Warning message")                # Console + file
logger.error("Error occurred")                   # Console + file

print("\n📺 Console output above ☝️")
print("📄 Check debug.log for complete logs")

# Console shows:
# INFO - General information
# WARNING - Warning message
# ERROR - Error occurred
#
# debug.log contains:
# 2024-01-15 14:40:00,100 - __main__ - DEBUG - Detailed debug information
# 2024-01-15 14:40:00,101 - __main__ - INFO - General information
# 2024-01-15 14:40:00,102 - __main__ - WARNING - Warning message
# 2024-01-15 14:40:00,103 - __main__ - ERROR - Error occurred
```

---

### 🧪 Example 4: Logging in Functions with Context

**Add context to your logs to make debugging easier:**

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(funcName)s - %(message)s'
)

logger = logging.getLogger(__name__)

def divide(a, b):
    """Divide two numbers with logging.
    
    Args:
        a (float): Numerator
        b (float): Denominator
    
    Returns:
        float: Result of division, or None if error
    """
    logger.debug(f"divide() called with a={a}, b={b}")
    
    try:
        result = a / b
        logger.info(f"Successfully divided {a} by {b} = {result}")
        return result
        
    except ZeroDivisionError:
        logger.error(f"Division by zero: {a} / {b}")
        return None
    
    except TypeError as e:
        logger.error(f"Type error: {e}")
        return None

def process_calculations(calculations):
    """Process a list of calculations.
    
    Args:
        calculations (list): List of (a, b) tuples
    """
    logger.info(f"Starting to process {len(calculations)} calculations")
    
    results = []
    errors = 0
    
    for i, (a, b) in enumerate(calculations, 1):
        logger.debug(f"Processing calculation {i}/{len(calculations)}")
        
        result = divide(a, b)
        
        if result is not None:
            results.append(result)
        else:
            errors += 1
    
    logger.info(f"Completed: {len(results)} successful, {errors} errors")
    
    return results

# Test the functions
print("="*60)
calculations = [
    (10, 2),    # ✅ Valid
    (15, 3),    # ✅ Valid
    (20, 0),    # ❌ Division by zero
    (25, "5"),  # ❌ Type error
]

results = process_calculations(calculations)

print(f"\n✅ Got {len(results)} results: {results}")

# Output:
# ============================================================
# 2024-01-15 15:00:00,100 - INFO - process_calculations - Starting to process 4 calculations
# 2024-01-15 15:00:00,101 - INFO - divide - Successfully divided 10 by 2 = 5.0
# 2024-01-15 15:00:00,102 - INFO - divide - Successfully divided 15 by 3 = 5.0
# 2024-01-15 15:00:00,103 - ERROR - divide - Division by zero: 20 / 0
# 2024-01-15 15:00:00,104 - ERROR - divide - Type error: unsupported operand type(s) for /: 'int' and 'str'
# 2024-01-15 15:00:00,105 - INFO - process_calculations - Completed: 2 successful, 2 errors
# 
# ✅ Got 2 results: [5.0, 5.0]
```

---

### 🧪 Example 5: Logging Exceptions with Stack Traces

**Use `logger.exception()` to log full error details:**

```python
import logging

logging.basicConfig(
    level=logging.ERROR,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

def risky_function(data):
    """Function that might raise exceptions."""
    try:
        # Simulate various operations
        result = data['value'] * 2
        return result
        
    except KeyError as e:
        # Log the exception with full stack trace
        logger.exception("KeyError occurred - missing key in data")
        raise  # Re-raise the exception
    
    except TypeError as e:
        logger.exception("TypeError occurred - invalid data type")
        raise

# Test with bad data
print("=== Test 1: Missing Key ===")
try:
    risky_function({'wrong_key': 10})
except KeyError:
    print("❌ Caught KeyError\n")

print("=== Test 2: Wrong Type ===")
try:
    risky_function({'value': 'not a number'})
except TypeError:
    print("❌ Caught TypeError\n")

# Output includes full traceback:
# === Test 1: Missing Key ===
# 2024-01-15 15:10:00,100 - ERROR - KeyError occurred - missing key in data
# Traceback (most recent call last):
#   File "script.py", line 14, in risky_function
#     result = data['value'] * 2
# KeyError: 'value'
# ❌ Caught KeyError
# 
# === Test 2: Wrong Type ===
# 2024-01-15 15:10:00,200 - ERROR - TypeError occurred - invalid data type
# Traceback (most recent call last):
#   File "script.py", line 14, in risky_function
#     result = data['value'] * 2
# TypeError: can't multiply sequence by non-int of type 'str'
# ❌ Caught TypeError
```

**Important:** Use `logger.exception()` **only inside except blocks**. For other logging, use `logger.error()`.

---

### 🔑 Key Takeaways: Logging Basics

1. **Use logging, not print()** - Professional and flexible
2. **5 log levels** - DEBUG, INFO, WARNING, ERROR, CRITICAL
3. **Configure once** - Use `logging.basicConfig()` at program start
4. **Log to files** - Use `filename` parameter
5. **Format strings** - Customize log appearance with `format`
6. **Use logger.exception()** - In except blocks to log full stack trace
7. **Set appropriate levels** - DEBUG for development, INFO for production
8. **Add context** - Include function names, variable values in messages

---

**🎯 Next:** We'll explore advanced logging features like handlers and rotating logs!


---

## <a name="advanced-logging"></a>8. Advanced Logging Features

### 📖 Introduction to Advanced Logging

**Why you need advanced logging:**

In production applications, basic `logging.basicConfig()` isn't enough. You need:
- ✅ **Rotating logs** - Prevent log files from growing forever
- ✅ **Multiple handlers** - Log to files, console, and remote servers
- ✅ **Different formats** - Different output styles for different destinations
- ✅ **Logger hierarchies** - Separate loggers for different modules
- ✅ **Performance** - Efficient logging that doesn't slow down your app

**This section covers:**
1. Rotating File Handlers (size-based and time-based)
2. Multiple Handlers with different configurations
3. Logger hierarchies and organization
4. Production-ready logging setup
5. Performance considerations

---

### 🔄 Example 1: Rotating File Handler (Size-Based)

**Problem:** Log files grow indefinitely and fill up disk space.

**Solution:** Use `RotatingFileHandler` to limit file size and keep backups.

```python
import logging
from logging.handlers import RotatingFileHandler

# Create a logger
logger = logging.getLogger('my_app')
logger.setLevel(logging.DEBUG)

# Create rotating file handler
# maxBytes: Maximum size of each log file (5MB in this example)
# backupCount: Number of backup files to keep (3 in this example)
rotating_handler = RotatingFileHandler(
    filename='app.log',
    maxBytes=5 * 1024 * 1024,  # 5 MB
    backupCount=3,              # Keep 3 backup files
    encoding='utf-8'
)

# Set format
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
rotating_handler.setFormatter(formatter)

# Add handler to logger
logger.addHandler(rotating_handler)

# Test it
logger.info("Application started")
logger.debug("This is a debug message")
logger.warning("This is a warning")

print("✅ Log rotation configured!")
print("📁 Files created:")
print("   - app.log (current log)")
print("   - app.log.1 (backup 1, when rotated)")
print("   - app.log.2 (backup 2)")
print("   - app.log.3 (backup 3)")
```

**How rotation works:**

```python
# When app.log reaches 5MB:
# 1. app.log.2 → app.log.3 (oldest backup moves)
# 2. app.log.1 → app.log.2
# 3. app.log → app.log.1
# 4. New app.log is created (starts empty)
# 5. app.log.3 is deleted if it exists (only keep 3 backups)
```

**Line-by-line breakdown:**

```python
rotating_handler = RotatingFileHandler(
    filename='app.log',              # ← Base log file name
    maxBytes=5 * 1024 * 1024,        # ← Max size: 5MB (5 × 1024 × 1024 bytes)
    backupCount=3,                   # ← Keep 3 old files (app.log.1, .2, .3)
    encoding='utf-8'                 # ← Use UTF-8 for special characters
)
# When app.log reaches 5MB:
# - It's renamed to app.log.1
# - A fresh app.log is created
# - Old backups are shifted (.1 → .2 → .3)
# - Oldest backup (.3) is deleted
```

---

### ⏰ Example 2: Timed Rotating File Handler

**Use case:** Create a new log file every day/hour/week automatically.

```python
import logging
from logging.handlers import TimedRotatingFileHandler

# Create logger
logger = logging.getLogger('timed_app')
logger.setLevel(logging.INFO)

# Create timed rotating handler
# when='midnight' - Rotate at midnight every day
# interval=1 - Every 1 day
# backupCount=7 - Keep 7 days of logs
timed_handler = TimedRotatingFileHandler(
    filename='daily_app.log',
    when='midnight',        # Rotate at midnight
    interval=1,             # Every 1 day
    backupCount=7,          # Keep 7 days of logs
    encoding='utf-8'
)

# Set format
formatter = logging.Formatter(
    '%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
timed_handler.setFormatter(formatter)

logger.addHandler(timed_handler)

# Log some messages
logger.info("Daily log entry")
logger.warning("This will be in today's log file")

print("✅ Timed rotation configured!")
print("📅 New log file created every day at midnight")
print("📁 Example files:")
print("   - daily_app.log (today)")
print("   - daily_app.log.2024-10-19 (yesterday)")
print("   - daily_app.log.2024-10-18 (2 days ago)")
print("   - ... (up to 7 days)")
```

**Common rotation intervals:**

```python
# Different rotation options:

# 1. Every hour
TimedRotatingFileHandler('hourly.log', when='H', interval=1, backupCount=24)

# 2. Every day at midnight
TimedRotatingFileHandler('daily.log', when='midnight', interval=1, backupCount=7)

# 3. Every Monday at midnight
TimedRotatingFileHandler('weekly.log', when='W0', interval=1, backupCount=4)
# W0=Monday, W1=Tuesday, W2=Wednesday, etc.

# 4. Every 6 hours
TimedRotatingFileHandler('six_hour.log', when='H', interval=6, backupCount=8)

# 5. Every Sunday at midnight (weekly)
TimedRotatingFileHandler('sunday.log', when='W6', interval=1, backupCount=4)
```

---

### 🎯 Example 3: Multiple Handlers with Different Levels

**Scenario:** Log everything to a file, but only show warnings+ on console.

```python
import logging
from logging.handlers import RotatingFileHandler

# Create logger
logger = logging.getLogger('multi_handler_app')
logger.setLevel(logging.DEBUG)  # Capture everything

# Handler 1: Console - only WARNING and above
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)  # Only warnings, errors, critical
console_format = logging.Formatter('%(levelname)s: %(message)s')
console_handler.setFormatter(console_format)

# Handler 2: File (debug.log) - everything (DEBUG+)
debug_file_handler = RotatingFileHandler(
    'debug.log',
    maxBytes=10 * 1024 * 1024,  # 10 MB
    backupCount=3
)
debug_file_handler.setLevel(logging.DEBUG)  # Everything
debug_format = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s'
)
debug_file_handler.setFormatter(debug_format)

# Handler 3: File (errors.log) - only ERROR and CRITICAL
error_file_handler = RotatingFileHandler(
    'errors.log',
    maxBytes=5 * 1024 * 1024,  # 5 MB
    backupCount=5
)
error_file_handler.setLevel(logging.ERROR)  # Only errors
error_format = logging.Formatter(
    '%(asctime)s - %(levelname)s - %(message)s'
)
error_file_handler.setFormatter(error_format)

# Add all handlers to logger
logger.addHandler(console_handler)
logger.addHandler(debug_file_handler)
logger.addHandler(error_file_handler)

# Test with different log levels
logger.debug("Detailed debug info")           # → Only in debug.log
logger.info("Application started")            # → Only in debug.log
logger.warning("Low disk space")              # → Console + debug.log
logger.error("Failed to connect to database") # → Console + debug.log + errors.log
logger.critical("System out of memory!")      # → Console + debug.log + errors.log

print("\n📊 Log Distribution:")
print("Console:      WARNING, ERROR, CRITICAL")
print("debug.log:    DEBUG, INFO, WARNING, ERROR, CRITICAL (everything)")
print("errors.log:   ERROR, CRITICAL only")
```

**Visual representation:**

```
DEBUG    → [debug.log]
INFO     → [debug.log]
WARNING  → [Console] [debug.log]
ERROR    → [Console] [debug.log] [errors.log]
CRITICAL → [Console] [debug.log] [errors.log]
```

---

### 🏗️ Example 4: Logger Hierarchies for Multiple Modules

**Scenario:** Large application with multiple modules needing separate loggers.

```python
import logging

# Root logger configuration
root_logger = logging.getLogger()
root_logger.setLevel(logging.INFO)

# Console handler for root
console = logging.StreamHandler()
console.setFormatter(logging.Formatter('%(name)s - %(levelname)s - %(message)s'))
root_logger.addHandler(console)

# Module-specific loggers (hierarchical naming)
database_logger = logging.getLogger('myapp.database')
api_logger = logging.getLogger('myapp.api')
etl_logger = logging.getLogger('myapp.etl')

# Each module logs with its own name
database_logger.info("Database connection opened")
api_logger.warning("API rate limit approaching")
etl_logger.error("Failed to process record")

# Output:
# myapp.database - INFO - Database connection opened
# myapp.api - WARNING - API rate limit approaching
# myapp.etl - ERROR - Failed to process record

print("\n✅ Logger hierarchy created:")
print("   Root: (root)")
print("   ├── myapp.database")
print("   ├── myapp.api")
print("   └── myapp.etl")
```

**Real-world example with file structure:**

```python
# database.py
import logging
logger = logging.getLogger('myapp.database')

def connect():
    logger.info("Connecting to database...")
    logger.debug("Connection string: localhost:5432")

# api.py
import logging
logger = logging.getLogger('myapp.api')

def fetch_data():
    logger.info("Fetching data from API...")
    logger.warning("Response time: 2.5s (slow)")

# etl.py
import logging
logger = logging.getLogger('myapp.etl')

def extract():
    logger.info("Starting extraction...")
    logger.error("Failed to read file: missing_data.csv")

# main.py
import logging
from database import connect
from api import fetch_data
from etl import extract

# Configure root logger once
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler('app.log')
    ]
)

# Now all modules use their hierarchical loggers
connect()
fetch_data()
extract()
```

---

### 🎛️ Example 5: Production-Ready Logging Configuration

**Complete setup for production applications:**

```python
import logging
import logging.handlers
import sys
from pathlib import Path

def setup_logging(app_name='myapp', log_dir='logs', debug=False):
    """
    Set up production-grade logging configuration.
    
    Args:
        app_name (str): Application name for log files
        log_dir (str): Directory to store log files
        debug (bool): If True, set DEBUG level; otherwise INFO
    
    Creates:
        - logs/myapp.log (rotating, all logs)
        - logs/myapp_error.log (rotating, errors only)
        - Console output (INFO+ in production, DEBUG+ in debug mode)
    """
    # Create logs directory
    log_path = Path(log_dir)
    log_path.mkdir(exist_ok=True)
    
    # Root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.DEBUG if debug else logging.INFO)
    
    # Remove existing handlers
    root_logger.handlers.clear()
    
    # Format for detailed file logs
    detailed_formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - '
        '%(filename)s:%(lineno)d - %(funcName)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # Format for console (simpler)
    console_formatter = logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%H:%M:%S'
    )
    
    # Handler 1: Console (INFO+ or DEBUG+ if debug mode)
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.DEBUG if debug else logging.INFO)
    console_handler.setFormatter(console_formatter)
    root_logger.addHandler(console_handler)
    
    # Handler 2: Rotating file for all logs
    all_logs_file = log_path / f'{app_name}.log'
    file_handler = logging.handlers.RotatingFileHandler(
        all_logs_file,
        maxBytes=10 * 1024 * 1024,  # 10 MB
        backupCount=5,
        encoding='utf-8'
    )
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(detailed_formatter)
    root_logger.addHandler(file_handler)
    
    # Handler 3: Rotating file for errors only
    error_logs_file = log_path / f'{app_name}_error.log'
    error_handler = logging.handlers.RotatingFileHandler(
        error_logs_file,
        maxBytes=5 * 1024 * 1024,  # 5 MB
        backupCount=10,
        encoding='utf-8'
    )
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(detailed_formatter)
    root_logger.addHandler(error_handler)
    
    # Log startup message
    root_logger.info(f"Logging initialized for {app_name}")
    root_logger.info(f"Log directory: {log_path.absolute()}")
    root_logger.info(f"Debug mode: {debug}")
    
    return root_logger

# Usage example
if __name__ == "__main__":
    # Set up logging for production
    logger = setup_logging(app_name='my_etl_pipeline', debug=False)
    
    # Now use logging throughout your application
    logger.info("Application started")
    logger.debug("This won't appear in production (debug=False)")
    
    try:
        # Simulate some work
        result = 10 / 0
    except ZeroDivisionError:
        logger.error("Division by zero error!", exc_info=True)
    
    logger.info("Application finished")
    
    print("\n✅ Check the 'logs/' directory for:")
    print("   - my_etl_pipeline.log (all logs)")
    print("   - my_etl_pipeline_error.log (errors only)")
```

**Line-by-line breakdown of key parts:**

```python
# Remove existing handlers to avoid duplicates
root_logger.handlers.clear()
# ↑ Important! If you run setup_logging() twice,
#   without this you'll get duplicate log entries

# Handler with rotation
file_handler = logging.handlers.RotatingFileHandler(
    all_logs_file,                  # ← File path
    maxBytes=10 * 1024 * 1024,      # ← 10 MB max size
    backupCount=5,                  # ← Keep 5 backups
    encoding='utf-8'                # ← Support Unicode
)
# This creates:
# - my_etl_pipeline.log (current)
# - my_etl_pipeline.log.1 (most recent backup)
# - my_etl_pipeline.log.2
# - my_etl_pipeline.log.3
# - my_etl_pipeline.log.4
# - my_etl_pipeline.log.5 (oldest backup)

# exc_info=True includes full stack trace
logger.error("Division by zero error!", exc_info=True)
# ↑ Same as logger.exception(), but can be used outside except blocks
```

---

### 🔑 Key Takeaways: Advanced Logging

1. **Use RotatingFileHandler** - Prevent infinite log file growth
2. **Use TimedRotatingFileHandler** - Automatic daily/hourly/weekly rotation
3. **Multiple handlers** - Different destinations, levels, and formats
4. **Logger hierarchies** - Organize loggers by module (e.g., `myapp.database`)
5. **Production setup** - Separate error logs, detailed file logs, simple console
6. **Clear handlers** - Use `logger.handlers.clear()` before reconfiguring
7. **exc_info=True** - Include stack traces in error logs
8. **Create log directories** - Use `Path.mkdir(exist_ok=True)`

---

**🎯 Next:** We'll build a complete ETL pipeline with error handling and logging!


---

## <a name="etl-pipeline"></a>9. Complete ETL Pipeline with Error Handling & Logging

### 📖 Introduction: Building a Production-Grade ETL Pipeline

**What we'll build:**

A complete ETL (Extract, Transform, Load) pipeline that demonstrates:
- ✅ **Custom exception hierarchy** - Specific errors for each stage
- ✅ **Comprehensive logging** - Track every step with appropriate levels
- ✅ **Retry logic** - Automatically retry failed operations
- ✅ **Error recovery** - Continue processing despite individual failures
- ✅ **Detailed reporting** - Summary statistics and error reports
- ✅ **Production-ready** - Handles real-world scenarios

**Pipeline stages:**
1. **Extract** - Read data from CSV files
2. **Transform** - Clean and validate data
3. **Load** - Save to database (simulated)
4. **Report** - Generate execution summary

---

### 🏗️ Step 1: Custom Exception Hierarchy

**First, define our exception classes:**

```python
"""
Custom exceptions for ETL pipeline.
Organized by pipeline stage for easy debugging.
"""

class ETLError(Exception):
    """Base exception for all ETL errors."""
    pass

# ========== EXTRACT ERRORS ==========
class ExtractError(ETLError):
    """Base class for extraction errors."""
    pass

class FileNotFoundError(ExtractError):
    """Raised when source file doesn't exist."""
    def __init__(self, filepath):
        self.filepath = filepath
        super().__init__(f"File not found: {filepath}")

class FileReadError(ExtractError):
    """Raised when file exists but can't be read."""
    def __init__(self, filepath, reason):
        self.filepath = filepath
        self.reason = reason
        super().__init__(f"Cannot read {filepath}: {reason}")

# ========== TRANSFORM ERRORS ==========
class TransformError(ETLError):
    """Base class for transformation errors."""
    pass

class ValidationError(TransformError):
    """Raised when data validation fails."""
    def __init__(self, field, value, rule):
        self.field = field
        self.value = value
        self.rule = rule
        super().__init__(
            f"Validation failed: {field}='{value}' violates rule: {rule}"
        )

class DataTypeError(TransformError):
    """Raised when data type conversion fails."""
    def __init__(self, field, value, expected_type):
        self.field = field
        self.value = value
        self.expected_type = expected_type
        super().__init__(
            f"Cannot convert {field}='{value}' to {expected_type}"
        )

# ========== LOAD ERRORS ==========
class LoadError(ETLError):
    """Base class for loading errors."""
    pass

class DatabaseConnectionError(LoadError):
    """Raised when database connection fails."""
    def __init__(self, db_name, reason):
        self.db_name = db_name
        self.reason = reason
        super().__init__(f"Cannot connect to {db_name}: {reason}")

class DataInsertError(LoadError):
    """Raised when inserting data fails."""
    def __init__(self, record, reason):
        self.record = record
        self.reason = reason
        super().__init__(f"Cannot insert record: {reason}")

print("✅ Exception hierarchy defined!")
print("   ETLError")
print("   ├── ExtractError")
print("   │   ├── FileNotFoundError")
print("   │   └── FileReadError")
print("   ├── TransformError")
print("   │   ├── ValidationError")
print("   │   └── DataTypeError")
print("   └── LoadError")
print("       ├── DatabaseConnectionError")
print("       └── DataInsertError")
```

**Why this hierarchy?**

```python
# Allows catching errors at different levels:

try:
    # ... ETL operations ...
    pass
except ExtractError:
    # Handle ALL extraction errors
    pass
except TransformError:
    # Handle ALL transformation errors
    pass
except LoadError:
    # Handle ALL loading errors
    pass
except ETLError:
    # Catch any other ETL error
    pass
```

---

### 📊 Step 2: ETL Pipeline Class with Logging

**Core pipeline class with comprehensive logging:**

```python
import logging
import csv
import time
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any

class ETLPipeline:
    """
    Production-grade ETL Pipeline with error handling and logging.
    
    Features:
    - Automatic retry on transient failures
    - Detailed logging at each stage
    - Error tracking and reporting
    - Continue processing despite individual record failures
    """
    
    def __init__(self, pipeline_name: str, max_retries: int = 3):
        """
        Initialize ETL pipeline.
        
        Args:
            pipeline_name (str): Name for this pipeline instance
            max_retries (int): Maximum retry attempts for failed operations
        """
        self.pipeline_name = pipeline_name
        self.max_retries = max_retries
        
        # Set up logger for this pipeline
        self.logger = logging.getLogger(f'etl.{pipeline_name}')
        
        # Statistics tracking
        self.stats = {
            'extracted': 0,
            'transformed': 0,
            'loaded': 0,
            'extract_errors': 0,
            'transform_errors': 0,
            'load_errors': 0,
            'start_time': None,
            'end_time': None
        }
        
        # Error tracking
        self.errors = []
        
        self.logger.info(f"ETL Pipeline '{pipeline_name}' initialized")
        self.logger.info(f"Max retries: {max_retries}")
    
    def extract(self, filepath: str) -> List[Dict[str, Any]]:
        """
        Extract data from CSV file with retry logic.
        
        Args:
            filepath (str): Path to CSV file
            
        Returns:
            List[Dict]: List of records as dictionaries
            
        Raises:
            ExtractError: If extraction fails after all retries
        """
        self.logger.info(f"Starting extraction from: {filepath}")
        
        # Check if file exists
        file_path = Path(filepath)
        if not file_path.exists():
            error = FileNotFoundError(filepath)
            self.logger.error(f"File not found: {filepath}")
            self.stats['extract_errors'] += 1
            self.errors.append({
                'stage': 'extract',
                'error': str(error),
                'filepath': filepath
            })
            raise error
        
        # Try to read file with retries
        for attempt in range(1, self.max_retries + 1):
            try:
                self.logger.debug(f"Read attempt {attempt}/{self.max_retries}")
                
                with open(filepath, 'r', encoding='utf-8') as f:
                    reader = csv.DictReader(f)
                    records = list(reader)
                
                self.stats['extracted'] = len(records)
                self.logger.info(f"✅ Extracted {len(records)} records")
                return records
                
            except Exception as e:
                self.logger.warning(
                    f"Attempt {attempt} failed: {e}",
                    exc_info=attempt == self.max_retries
                )
                
                if attempt == self.max_retries:
                    error = FileReadError(filepath, str(e))
                    self.stats['extract_errors'] += 1
                    self.errors.append({
                        'stage': 'extract',
                        'error': str(error),
                        'filepath': filepath
                    })
                    self.logger.error(f"❌ Extraction failed after {self.max_retries} attempts")
                    raise error
                
                # Wait before retry (exponential backoff)
                wait_time = 2 ** attempt
                self.logger.info(f"Retrying in {wait_time}s...")
                time.sleep(wait_time)
    
    def transform_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """
        Transform and validate a single record.
        
        Args:
            record (Dict): Raw record from extraction
            
        Returns:
            Dict: Cleaned and validated record
            
        Raises:
            TransformError: If transformation/validation fails
        """
        self.logger.debug(f"Transforming record: {record.get('id', 'unknown')}")
        
        transformed = {}
        
        try:
            # Example transformations:
            
            # 1. Required field validation
            if 'name' not in record or not record['name'].strip():
                raise ValidationError('name', record.get('name'), 'must not be empty')
            transformed['name'] = record['name'].strip().title()
            
            # 2. Email validation
            email = record.get('email', '').strip().lower()
            if not email or '@' not in email:
                raise ValidationError('email', email, 'must be valid email')
            transformed['email'] = email
            
            # 3. Age conversion and validation
            try:
                age = int(record.get('age', 0))
                if age < 0 or age > 150:
                    raise ValidationError('age', age, 'must be between 0 and 150')
                transformed['age'] = age
            except ValueError:
                raise DataTypeError('age', record.get('age'), 'integer')
            
            # 4. Optional field with default
            transformed['city'] = record.get('city', 'Unknown').strip().title()
            
            self.logger.debug(f"✅ Transformed: {transformed['name']}")
            return transformed
            
        except TransformError as e:
            self.logger.warning(f"Transform error: {e}")
            raise
    
    def transform(self, records: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """
        Transform all records, continuing despite individual failures.
        
        Args:
            records (List[Dict]): Raw records from extraction
            
        Returns:
            List[Dict]: Successfully transformed records
        """
        self.logger.info(f"Starting transformation of {len(records)} records")
        
        transformed_records = []
        
        for i, record in enumerate(records, 1):
            try:
                transformed = self.transform_record(record)
                transformed_records.append(transformed)
                self.stats['transformed'] += 1
                
            except TransformError as e:
                self.stats['transform_errors'] += 1
                self.errors.append({
                    'stage': 'transform',
                    'error': str(e),
                    'record_number': i,
                    'record': record
                })
                self.logger.error(f"Record {i} failed transformation: {e}")
                # Continue with next record
        
        success_rate = (len(transformed_records) / len(records)) * 100
        self.logger.info(
            f"✅ Transformed {len(transformed_records)}/{len(records)} records "
            f"({success_rate:.1f}% success rate)"
        )
        
        return transformed_records
    
    def load_record(self, record: Dict[str, Any], db_name: str = 'production_db'):
        """
        Load a single record to database (simulated).
        
        Args:
            record (Dict): Transformed record to load
            db_name (str): Target database name
            
        Raises:
            LoadError: If loading fails
        """
        self.logger.debug(f"Loading record: {record['name']}")
        
        # Simulate database operation
        try:
            # Simulate potential database issues
            import random
            if random.random() < 0.05:  # 5% random failure for demo
                raise Exception("Database connection timeout")
            
            # In real scenario, this would be:
            # cursor.execute("INSERT INTO users VALUES (?, ?, ?)", record.values())
            
            self.logger.debug(f"✅ Loaded: {record['name']}")
            
        except Exception as e:
            raise DataInsertError(record, str(e))
    
    def load(self, records: List[Dict[str, Any]]) -> int:
        """
        Load all records to database with retry logic.
        
        Args:
            records (List[Dict]): Transformed records to load
            
        Returns:
            int: Number of successfully loaded records
        """
        self.logger.info(f"Starting load of {len(records)} records")
        
        loaded_count = 0
        
        for i, record in enumerate(records, 1):
            # Retry logic for each record
            for attempt in range(1, self.max_retries + 1):
                try:
                    self.load_record(record)
                    loaded_count += 1
                    self.stats['loaded'] += 1
                    break  # Success, move to next record
                    
                except LoadError as e:
                    if attempt == self.max_retries:
                        self.stats['load_errors'] += 1
                        self.errors.append({
                            'stage': 'load',
                            'error': str(e),
                            'record_number': i,
                            'record': record
                        })
                        self.logger.error(
                            f"Record {i} failed loading after {self.max_retries} attempts: {e}"
                        )
                    else:
                        self.logger.warning(f"Load attempt {attempt} failed, retrying...")
                        time.sleep(1)
        
        success_rate = (loaded_count / len(records)) * 100 if records else 0
        self.logger.info(
            f"✅ Loaded {loaded_count}/{len(records)} records "
            f"({success_rate:.1f}% success rate)"
        )
        
        return loaded_count
    
    def run(self, filepath: str) -> Dict[str, Any]:
        """
        Execute complete ETL pipeline.
        
        Args:
            filepath (str): Path to source CSV file
            
        Returns:
            Dict: Pipeline execution statistics
        """
        self.logger.info("="*60)
        self.logger.info(f"Starting ETL Pipeline: {self.pipeline_name}")
        self.logger.info("="*60)
        
        self.stats['start_time'] = datetime.now()
        
        try:
            # EXTRACT
            self.logger.info("STAGE 1: EXTRACT")
            records = self.extract(filepath)
            
            # TRANSFORM
            self.logger.info("STAGE 2: TRANSFORM")
            transformed = self.transform(records)
            
            # LOAD
            self.logger.info("STAGE 3: LOAD")
            loaded = self.load(transformed)
            
            self.stats['end_time'] = datetime.now()
            
            # Generate report
            self.logger.info("="*60)
            self.logger.info("ETL Pipeline Completed")
            self.logger.info("="*60)
            
            return self.get_stats()
            
        except ExtractError as e:
            self.logger.critical(f"❌ Pipeline failed at EXTRACT stage: {e}")
            self.stats['end_time'] = datetime.now()
            raise
        
        except Exception as e:
            self.logger.critical(f"❌ Unexpected error: {e}", exc_info=True)
            self.stats['end_time'] = datetime.now()
            raise
    
    def get_stats(self) -> Dict[str, Any]:
        """Get pipeline execution statistics."""
        duration = None
        if self.stats['start_time'] and self.stats['end_time']:
            duration = (self.stats['end_time'] - self.stats['start_time']).total_seconds()
        
        return {
            **self.stats,
            'duration_seconds': duration,
            'total_errors': len(self.errors),
            'error_details': self.errors
        }
    
    def print_report(self):
        """Print formatted execution report."""
        stats = self.get_stats()
        
        print("\n" + "="*60)
        print(f"📊 ETL PIPELINE REPORT: {self.pipeline_name}")
        print("="*60)
        
        print(f"\n⏱️  Duration: {stats['duration_seconds']:.2f}s")
        
        print("\n📈 Records Processed:")
        print(f"   Extracted:   {stats['extracted']:>5}")
        print(f"   Transformed: {stats['transformed']:>5}")
        print(f"   Loaded:      {stats['loaded']:>5}")
        
        print("\n❌ Errors:")
        print(f"   Extract:     {stats['extract_errors']:>5}")
        print(f"   Transform:   {stats['transform_errors']:>5}")
        print(f"   Load:        {stats['load_errors']:>5}")
        print(f"   Total:       {stats['total_errors']:>5}")
        
        if stats['total_errors'] > 0:
            print("\n🔍 Error Details:")
            for i, error in enumerate(stats['error_details'][:5], 1):
                print(f"   {i}. [{error['stage'].upper()}] {error['error']}")
            if stats['total_errors'] > 5:
                print(f"   ... and {stats['total_errors'] - 5} more errors")
        
        print("="*60 + "\n")

print("✅ ETL Pipeline class defined!")
```

---

### 🧪 Step 3: Complete Working Example

**Let's run the pipeline with test data:**

```python
# First, create test CSV file
import csv
from pathlib import Path

# Create test data directory
test_dir = Path('test_data')
test_dir.mkdir(exist_ok=True)

# Create sample CSV with some intentional errors
test_file = test_dir / 'customers.csv'

sample_data = [
    {'name': 'John Doe', 'email': 'john@example.com', 'age': '30', 'city': 'New York'},
    {'name': 'Jane Smith', 'email': 'jane@example.com', 'age': '25', 'city': 'Los Angeles'},
    {'name': '', 'email': 'invalid@example.com', 'age': '35', 'city': 'Chicago'},  # Empty name
    {'name': 'Bob Wilson', 'email': 'invalid-email', 'age': '40', 'city': 'Houston'},  # Invalid email
    {'name': 'Alice Brown', 'email': 'alice@example.com', 'age': 'invalid', 'city': 'Phoenix'},  # Invalid age
    {'name': 'Charlie Davis', 'email': 'charlie@example.com', 'age': '28', 'city': 'Philadelphia'},
    {'name': 'Eva Martinez', 'email': 'eva@example.com', 'age': '-5', 'city': 'San Antonio'},  # Negative age
    {'name': 'Frank Taylor', 'email': 'frank@example.com', 'age': '45', 'city': 'San Diego'},
]

with open(test_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['name', 'email', 'age', 'city'])
    writer.writeheader()
    writer.writerows(sample_data)

print(f"✅ Created test file: {test_file}")
print(f"📊 Records: {len(sample_data)} (3 with errors)")
```

**Now run the pipeline:**

```python
import logging

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%H:%M:%S'
)

# Create and run pipeline
pipeline = ETLPipeline(pipeline_name='customer_import', max_retries=3)

try:
    stats = pipeline.run('test_data/customers.csv')
    pipeline.print_report()
    
except ExtractError as e:
    print(f"\n❌ Pipeline failed at extraction: {e}")
except ETLError as e:
    print(f"\n❌ Pipeline failed: {e}")

# Expected Output:
# ============================================================
# 14:30:45 - etl.customer_import - INFO - ============================================================
# 14:30:45 - etl.customer_import - INFO - Starting ETL Pipeline: customer_import
# 14:30:45 - etl.customer_import - INFO - ============================================================
# 14:30:45 - etl.customer_import - INFO - STAGE 1: EXTRACT
# 14:30:45 - etl.customer_import - INFO - Starting extraction from: test_data/customers.csv
# 14:30:45 - etl.customer_import - INFO - ✅ Extracted 8 records
# 14:30:45 - etl.customer_import - INFO - STAGE 2: TRANSFORM
# 14:30:45 - etl.customer_import - INFO - Starting transformation of 8 records
# 14:30:45 - etl.customer_import - WARNING - Transform error: Validation failed: name='' violates rule: must not be empty
# 14:30:45 - etl.customer_import - ERROR - Record 3 failed transformation: ...
# 14:30:45 - etl.customer_import - WARNING - Transform error: Validation failed: email='invalid-email' violates rule: must be valid email
# 14:30:45 - etl.customer_import - ERROR - Record 4 failed transformation: ...
# 14:30:45 - etl.customer_import - WARNING - Transform error: Cannot convert age='invalid' to integer
# 14:30:45 - etl.customer_import - ERROR - Record 5 failed transformation: ...
# 14:30:45 - etl.customer_import - INFO - ✅ Transformed 5/8 records (62.5% success rate)
# 14:30:45 - etl.customer_import - INFO - STAGE 3: LOAD
# 14:30:45 - etl.customer_import - INFO - Starting load of 5 records
# 14:30:45 - etl.customer_import - INFO - ✅ Loaded 5/5 records (100.0% success rate)
# 14:30:45 - etl.customer_import - INFO - ============================================================
# 14:30:45 - etl.customer_import - INFO - ETL Pipeline Completed
# 14:30:45 - etl.customer_import - INFO - ============================================================
# 
# ============================================================
# 📊 ETL PIPELINE REPORT: customer_import
# ============================================================
# 
# ⏱️  Duration: 0.15s
# 
# 📈 Records Processed:
#    Extracted:       8
#    Transformed:     5
#    Loaded:          5
# 
# ❌ Errors:
#    Extract:         0
#    Transform:       3
#    Load:            0
#    Total:           3
# 
# 🔍 Error Details:
#    1. [TRANSFORM] Validation failed: name='' violates rule: must not be empty
#    2. [TRANSFORM] Validation failed: email='invalid-email' violates rule: must be valid email
#    3. [TRANSFORM] Cannot convert age='invalid' to integer
# ============================================================
```

---

### 🔑 Key Takeaways: ETL Pipeline Error Handling

1. **Custom exceptions** - Create hierarchy for each pipeline stage
2. **Comprehensive logging** - Track every step with appropriate levels
3. **Retry logic** - Automatically retry transient failures
4. **Continue on errors** - Don't stop entire pipeline for single record failures
5. **Error tracking** - Collect all errors for detailed reporting
6. **Statistics** - Track success rates and performance metrics
7. **Detailed reports** - Provide actionable information about failures
8. **Production-ready** - Handle real-world scenarios gracefully

---

**🎯 Next:** We'll wrap up with best practices and exercises!


---

## <a name="best-practices"></a>9. Best Practices & Exercises

### 📋 Error Handling Best Practices

#### 1. **Be Specific with Exceptions**

```python
# ❌ BAD: Too broad
try:
    result = process_data(data)
except Exception:  # Catches EVERYTHING including system errors!
    print("Error occurred")

# ✅ GOOD: Specific exceptions
try:
    result = process_data(data)
except ValueError as e:
    logger.error(f"Invalid data format: {e}")
except KeyError as e:
    logger.error(f"Missing required field: {e}")
except Exception as e:
    logger.critical(f"Unexpected error: {e}", exc_info=True)
    raise  # Re-raise unexpected errors
```

**Why?** Catching broad exceptions can hide bugs and make debugging harder.

---

#### 2. **Never Use Empty Except Blocks**

```python
# ❌ BAD: Silently swallows errors
try:
    risky_operation()
except:
    pass  # Error is lost forever!

# ✅ GOOD: At minimum, log the error
try:
    risky_operation()
except Exception as e:
    logger.error(f"Operation failed: {e}", exc_info=True)
    # Decide: re-raise, return default, or continue
```

**Why?** Silent failures make debugging impossible.

---

#### 3. **Use Finally for Cleanup**

```python
# ❌ BAD: Resource might not be closed
file = open('data.txt')
try:
    data = file.read()
except Exception as e:
    logger.error(f"Read failed: {e}")
# If error occurs, file stays open!

# ✅ GOOD: Always cleanup with finally
file = open('data.txt')
try:
    data = file.read()
except Exception as e:
    logger.error(f"Read failed: {e}")
finally:
    file.close()  # Always executes

# ✅ BETTER: Use context manager
try:
    with open('data.txt') as file:
        data = file.read()
except Exception as e:
    logger.error(f"Read failed: {e}")
# File automatically closed
```

**Why?** Prevents resource leaks (files, connections, locks).

---

#### 4. **Don't Catch What You Can't Handle**

```python
# ❌ BAD: Catching errors you can't fix
def read_config():
    try:
        with open('config.json') as f:
            return json.load(f)
    except FileNotFoundError:
        print("Config not found")
        return {}  # Wrong! App can't work without config

# ✅ GOOD: Let it propagate
def read_config():
    """Read configuration file.
    
    Raises:
        FileNotFoundError: If config.json doesn't exist
        json.JSONDecodeError: If config is invalid JSON
    """
    with open('config.json') as f:
        return json.load(f)

# Let the caller decide how to handle it
try:
    config = read_config()
except FileNotFoundError:
    logger.critical("Config file missing - cannot start application")
    sys.exit(1)
```

**Why?** If you can't recover, let the error propagate to code that can.

---

#### 5. **Use Custom Exceptions for Business Logic**

```python
# ❌ BAD: Using built-in exceptions for domain logic
def process_order(order):
    if order['total'] < 0:
        raise ValueError("Invalid total")  # Too generic
    if order['customer_id'] not in customers:
        raise KeyError("Customer not found")  # Confusing

# ✅ GOOD: Custom exceptions
class InvalidOrderError(Exception):
    """Raised when order data is invalid."""
    pass

class CustomerNotFoundError(Exception):
    """Raised when customer doesn't exist."""
    pass

def process_order(order):
    if order['total'] < 0:
        raise InvalidOrderError(f"Order total cannot be negative: {order['total']}")
    if order['customer_id'] not in customers:
        raise CustomerNotFoundError(f"Customer {order['customer_id']} not found")
```

**Why?** Makes errors clear and allows specific handling.

---

### 📊 Logging Best Practices

#### 1. **Choose the Right Log Level**

```python
# Use this guide:

logger.debug("Variable x = 42")           # Development debugging only
logger.info("Pipeline started")           # Normal operations
logger.warning("Disk space low (10%)")    # Warning, but not an error
logger.error("Failed to process record")  # Error, but app continues
logger.critical("Database down!")         # Critical, app might crash

# ❌ BAD: Wrong levels
logger.error("User logged in")         # Not an error!
logger.info("Database connection failed")  # Too low, this is an error!

# ✅ GOOD: Appropriate levels
logger.info("User logged in")
logger.error("Database connection failed")
```

---

#### 2. **Include Context in Log Messages**

```python
# ❌ BAD: No context
logger.error("Processing failed")

# ✅ GOOD: Rich context
logger.error(
    f"Processing failed for file: {filename}, "
    f"record: {record_id}, "
    f"error: {str(e)}"
)

# ✅ BETTER: Structured logging
logger.error(
    "Processing failed",
    extra={
        'filename': filename,
        'record_id': record_id,
        'error_type': type(e).__name__,
        'error_message': str(e)
    }
)
```

---

#### 3. **Log Exceptions with Stack Traces**

```python
# ❌ BAD: Losing stack trace
try:
    result = process()
except Exception as e:
    logger.error(f"Error: {e}")  # No stack trace!

# ✅ GOOD: Include stack trace
try:
    result = process()
except Exception as e:
    logger.exception("Processing failed")  # Includes full traceback

# ✅ ALSO GOOD: Use exc_info
try:
    result = process()
except Exception as e:
    logger.error("Processing failed", exc_info=True)
```

---

#### 4. **Don't Log Sensitive Information**

```python
# ❌ BAD: Logging sensitive data
logger.info(f"User login: {username}, password: {password}")
logger.debug(f"Credit card: {credit_card_number}")
logger.info(f"API key: {api_key}")

# ✅ GOOD: Mask or omit sensitive data
logger.info(f"User login: {username}")  # No password
logger.debug(f"Credit card: ****{credit_card_number[-4:]}")  # Last 4 digits only
logger.info("API authentication successful")  # Don't log the key
```

---

#### 5. **Configure Logging Once, Use Everywhere**

```python
# ❌ BAD: Configuring in every module
# module1.py
logging.basicConfig(level=logging.INFO)

# module2.py
logging.basicConfig(level=logging.DEBUG)  # Conflicts!

# ✅ GOOD: Configure once in main entry point
# main.py
import logging
from module1 import func1
from module2 import func2

def setup_logging():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler('app.log')
        ]
    )

if __name__ == "__main__":
    setup_logging()  # Configure once
    func1()
    func2()

# module1.py
import logging
logger = logging.getLogger(__name__)  # Just get logger

def func1():
    logger.info("Function 1 called")

# module2.py
import logging
logger = logging.getLogger(__name__)

def func2():
    logger.info("Function 2 called")
```

---

### 🎯 Common Pitfalls to Avoid

#### ❌ Pitfall 1: Catching and Re-raising Without Adding Value

```python
# ❌ BAD: Pointless catch and re-raise
try:
    result = process()
except ValueError as e:
    raise ValueError(e)  # No value added!

# ✅ GOOD: Add context or convert
try:
    result = process()
except ValueError as e:
    raise DataValidationError(f"Invalid data in {filename}: {e}") from e
```

---

#### ❌ Pitfall 2: Using Bare Except

```python
# ❌ BAD: Catches system exits too!
try:
    process()
except:  # Catches KeyboardInterrupt, SystemExit, etc.
    logger.error("Error")

# ✅ GOOD: At minimum, catch Exception
try:
    process()
except Exception as e:  # Doesn't catch system signals
    logger.error(f"Error: {e}")
```

---

#### ❌ Pitfall 3: Modifying Mutable Default Arguments

```python
# ❌ BAD: Mutable default argument
def process_items(items=[]):  # DANGER!
    items.append("new")
    return items

print(process_items())  # ['new']
print(process_items())  # ['new', 'new'] - WRONG!

# ✅ GOOD: Use None
def process_items(items=None):
    if items is None:
        items = []
    items.append("new")
    return items

print(process_items())  # ['new']
print(process_items())  # ['new'] - CORRECT!
```

---

#### ❌ Pitfall 4: Ignoring Return Codes

```python
# ❌ BAD: Not checking if operation succeeded
def save_data(data):
    try:
        with open('data.txt', 'w') as f:
            f.write(data)
    except Exception:
        pass  # Silently fails!

result = save_data(important_data)
# No way to know if it worked!

# ✅ GOOD: Return success status
def save_data(data):
    try:
        with open('data.txt', 'w') as f:
            f.write(data)
        return True
    except Exception as e:
        logger.error(f"Save failed: {e}")
        return False

if not save_data(important_data):
    logger.critical("Critical: Failed to save data")
    notify_admin()
```

---

### 💪 Practice Exercises

#### 📝 Exercise 1: Error Handler Decorator

**Task:** Create a decorator that catches exceptions and logs them.

```python
import logging
from functools import wraps

# Your task: Implement this decorator
def error_handler(func):
    """Decorator that catches exceptions and logs them.
    
    Should:
    - Catch any exception
    - Log the error with function name and arguments
    - Re-raise the exception
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        # TODO: Implement error handling
        pass
    return wrapper

# Test it
@error_handler
def divide(a, b):
    return a / b

# Should log error but still raise exception
try:
    divide(10, 0)
except ZeroDivisionError:
    print("Caught the error!")
```

<details>
<summary>💡 Solution</summary>

```python
import logging
from functools import wraps

logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)

def error_handler(func):
    """Decorator that catches exceptions and logs them."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            logger.error(
                f"Error in {func.__name__}({args}, {kwargs}): {e}",
                exc_info=True
            )
            raise
    return wrapper

@error_handler
def divide(a, b):
    return a / b

# Test
try:
    result = divide(10, 2)
    print(f"Result: {result}")  # 5.0
    
    result = divide(10, 0)  # Logs error and raises
except ZeroDivisionError:
    print("Caught the error!")
```
</details>

---

#### 📝 Exercise 2: Retry Mechanism

**Task:** Implement a retry decorator for functions that might fail temporarily.

```python
import time
from functools import wraps

# Your task: Implement this decorator
def retry(max_attempts=3, delay=1):
    """Retry a function if it raises an exception.
    
    Args:
        max_attempts (int): Maximum number of attempts
        delay (float): Seconds to wait between attempts
    """
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # TODO: Implement retry logic
            pass
        return wrapper
    return decorator

# Test it
attempt_count = 0

@retry(max_attempts=3, delay=0.5)
def unreliable_function():
    global attempt_count
    attempt_count += 1
    if attempt_count < 3:
        raise ConnectionError("Connection failed")
    return "Success!"

# Should succeed on 3rd attempt
result = unreliable_function()
print(result)  # "Success!"
```

<details>
<summary>💡 Solution</summary>

```python
import time
import logging
from functools import wraps

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def retry(max_attempts=3, delay=1):
    """Retry a function if it raises an exception."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_exception = None
            
            for attempt in range(1, max_attempts + 1):
                try:
                    logger.info(f"Attempt {attempt}/{max_attempts}")
                    return func(*args, **kwargs)
                    
                except Exception as e:
                    last_exception = e
                    logger.warning(
                        f"Attempt {attempt} failed: {e}"
                    )
                    
                    if attempt < max_attempts:
                        logger.info(f"Waiting {delay}s before retry...")
                        time.sleep(delay)
            
            # All attempts failed
            logger.error(f"All {max_attempts} attempts failed")
            raise last_exception
            
        return wrapper
    return decorator

# Test
attempt_count = 0

@retry(max_attempts=3, delay=0.5)
def unreliable_function():
    global attempt_count
    attempt_count += 1
    print(f"Execution #{attempt_count}")
    
    if attempt_count < 3:
        raise ConnectionError("Connection failed")
    return "Success!"

result = unreliable_function()
print(f"Final result: {result}")
```
</details>

---

#### 📝 Exercise 3: Data Validator Class

**Task:** Create a class that validates dictionary data and raises custom exceptions.

```python
# Your task: Implement this class
class DataValidator:
    """Validate dictionary data against rules.
    
    Should raise:
    - MissingFieldError if required field is missing
    - InvalidTypeError if field has wrong type
    - InvalidValueError if field value is invalid
    """
    
    def __init__(self, schema):
        """
        Args:
            schema (dict): Validation rules
                {
                    'field_name': {
                        'required': bool,
                        'type': type,
                        'min': int/float (optional),
                        'max': int/float (optional)
                    }
                }
        """
        self.schema = schema
    
    def validate(self, data):
        """Validate data against schema.
        
        Args:
            data (dict): Data to validate
            
        Raises:
            MissingFieldError: Required field missing
            InvalidTypeError: Field has wrong type
            InvalidValueError: Field value out of range
        """
        # TODO: Implement validation
        pass

# Test it
validator = DataValidator({
    'name': {'required': True, 'type': str},
    'age': {'required': True, 'type': int, 'min': 0, 'max': 150},
    'email': {'required': False, 'type': str}
})

# Should pass
validator.validate({'name': 'John', 'age': 30})

# Should raise errors
validator.validate({'age': 30})  # Missing name
validator.validate({'name': 'John', 'age': '30'})  # Wrong type
validator.validate({'name': 'John', 'age': 200})  # Out of range
```

<details>
<summary>💡 Solution</summary>

```python
# Custom exceptions
class ValidationError(Exception):
    """Base validation error."""
    pass

class MissingFieldError(ValidationError):
    """Raised when required field is missing."""
    pass

class InvalidTypeError(ValidationError):
    """Raised when field has wrong type."""
    pass

class InvalidValueError(ValidationError):
    """Raised when field value is invalid."""
    pass

class DataValidator:
    """Validate dictionary data against rules."""
    
    def __init__(self, schema):
        self.schema = schema
    
    def validate(self, data):
        """Validate data against schema."""
        for field_name, rules in self.schema.items():
            # Check required fields
            if rules.get('required', False):
                if field_name not in data:
                    raise MissingFieldError(
                        f"Required field '{field_name}' is missing"
                    )
            
            # Skip validation if field not present and not required
            if field_name not in data:
                continue
            
            value = data[field_name]
            
            # Check type
            expected_type = rules.get('type')
            if expected_type and not isinstance(value, expected_type):
                raise InvalidTypeError(
                    f"Field '{field_name}' must be {expected_type.__name__}, "
                    f"got {type(value).__name__}"
                )
            
            # Check min value
            if 'min' in rules and value < rules['min']:
                raise InvalidValueError(
                    f"Field '{field_name}' must be >= {rules['min']}, "
                    f"got {value}"
                )
            
            # Check max value
            if 'max' in rules and value > rules['max']:
                raise InvalidValueError(
                    f"Field '{field_name}' must be <= {rules['max']}, "
                    f"got {value}"
                )
        
        return True

# Test
validator = DataValidator({
    'name': {'required': True, 'type': str},
    'age': {'required': True, 'type': int, 'min': 0, 'max': 150},
    'email': {'required': False, 'type': str}
})

# Test cases
test_cases = [
    ({'name': 'John', 'age': 30}, True, "Valid data"),
    ({'age': 30}, False, "Missing name"),
    ({'name': 'John', 'age': '30'}, False, "Wrong type"),
    ({'name': 'John', 'age': 200}, False, "Out of range"),
    ({'name': 'John', 'age': -5}, False, "Below min"),
]

for data, should_pass, description in test_cases:
    try:
        validator.validate(data)
        if should_pass:
            print(f"✅ {description}: PASS")
        else:
            print(f"❌ {description}: Should have failed!")
    except ValidationError as e:
        if not should_pass:
            print(f"✅ {description}: Caught - {e}")
        else:
            print(f"❌ {description}: Unexpected error - {e}")
```
</details>

---

### 🎓 Final Summary

**You've learned:**

✅ **Error Handling:**
- Try/except/finally/else blocks
- Common exception types
- Custom exception hierarchies
- Error handling in classes

✅ **Logging:**
- Log levels (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- Basic and advanced configuration
- Rotating file handlers
- Production-ready setups

✅ **Real-World Application:**
- Complete ETL pipeline example
- Retry logic
- Error recovery strategies
- Comprehensive reporting

✅ **Best Practices:**
- Specific exception handling
- Appropriate log levels
- Resource cleanup
- Never silent failures

---

### 📚 Next Steps

1. **Practice:** Complete all exercises above
2. **Build:** Create your own ETL pipeline with error handling
3. **Review:** Revisit sections as needed
4. **Apply:** Use these patterns in your projects

---

### 🎯 Quick Reference Card

```python
# Error Handling Pattern
try:
    # Main code
    result = risky_operation()
    
except SpecificError as e:
    # Handle specific error
    logger.error(f"Specific error: {e}")
    
except Exception as e:
    # Handle unexpected errors
    logger.critical(f"Unexpected: {e}", exc_info=True)
    raise
    
else:
    # Success-only code
    logger.info("Operation successful")
    
finally:
    # Always cleanup
    cleanup_resources()

# Logging Pattern
import logging

logger = logging.getLogger(__name__)

logger.debug("Detailed debug info")
logger.info("Normal operation")
logger.warning("Something unusual")
logger.error("Error occurred", exc_info=True)
logger.critical("Critical failure")
```

---

**🎉 Congratulations-l "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path/modules/module_02_python_essentials/05_error_handling_logging.md"* You've completed the comprehensive Error Handling and Logging lesson!

---

