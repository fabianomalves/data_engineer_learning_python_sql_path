# Lesson 1: Python Fundamentals Review
**Module 2: Python Essentials for Data Engineering - Lesson 1 of 6**

## 🎯 Learning Objectives

By the end of this lesson, you will:
- Master Python data types and variables
- Write clean control flow statements
- Create reusable functions with proper parameters
- Use list comprehensions for concise code
- Work efficiently with dictionaries and sets
- Apply string manipulation techniques
- Understand Python's built-in functions
- Write Pythonic, idiomatic code

**Estimated Time**: 2 hours

---

## 📚 Table of Contents

1. [Variables and Data Types](#1-variables-and-data-types)
2. [Control Flow](#2-control-flow)
3. [Functions](#3-functions)
4. [Lists and List Comprehensions](#4-lists-and-list-comprehensions)
5. [Dictionaries and Sets](#5-dictionaries-and-sets)
6. [String Manipulation](#6-string-manipulation)
7. [Built-in Functions](#7-built-in-functions)
8. [Practice Exercises](#8-practice-exercises)

---

## 1. Variables and Data Types

### What are Variables?

**Variables** are named containers that store data in your program's memory. Think of them as labeled boxes where you put information you want to use later.

**Key Concepts:**
- **Variable names** should be descriptive (use `campsite_capacity` not `x`)
- Python is **dynamically typed** - you don't need to declare types
- Use **snake_case** for variable names in Python (words separated by underscores)

### 1.1 Basic Data Types

Python has several built-in data types. Here are the most important ones:

#### Integers (int) - Whole Numbers

Integers are whole numbers without decimals. Use them for counting, IDs, quantities.

```python
# Integers - whole numbers (no decimals)
campsite_capacity = 50           # How many people can stay
year_established = 1985          # Year (whole number)
location_id = 42                 # Database ID
negative_altitude = -100         # Can be negative (below sea level)

# You can do math with integers
total_capacity = campsite_capacity + 20  # 70
half_capacity = campsite_capacity // 2   # 25 (// is integer division)
```

#### Floats (float) - Decimal Numbers

Floats are numbers with decimal points. Use them for prices, coordinates, measurements.

```python
# Floats - numbers with decimals
price_per_night = 78.50          # Money value
latitude = -22.9519              # GPS coordinate
longitude = -43.2105             # GPS coordinate
temperature = 23.5               # Temperature in Celsius
distance_km = 12.75              # Distance with precision

# Math with floats
tax = price_per_night * 0.15     # 11.775
total_price = price_per_night + tax  # 90.275
```

#### Strings (str) - Text

Strings are text data. Use single quotes `'...'` or double quotes `"..."` (both work the same).

```python
# Strings - text data (use quotes)
location_name = "Chapada Diamantina"     # Double quotes
state_code = 'BA'                        # Single quotes (same thing)
description = """This is a multi-line
string that spans multiple lines"""     # Triple quotes for multiple lines

# Strings can contain numbers but they're still text!
zip_code = "12345"  # This is a string, not a number (can't do math with it)
```

#### Booleans (bool) - True/False

Booleans have only two values: `True` or `False`. Used for yes/no, on/off situations.

```python
# Booleans - True or False only (note capital T and F)
has_electricity = True           # Campsite has power
is_open = False                  # Campsite is closed
accepts_reservations = True      # Accepts bookings

# Booleans come from comparisons
is_expensive = price_per_night > 100  # False (78.50 is not > 100)
has_capacity = campsite_capacity > 0  # True (50 > 0)
```

**Important:** In Python, `True` and `False` must have capital first letters!

#### None - "No Value"

`None` represents the absence of a value. It's like saying "this is empty" or "not set yet".

```python
# None - represents "no value" or "empty"
contact_email = None             # Email not provided yet
optional_notes = None            # No notes added

# Use None when something is missing or optional
if contact_email is None:
    print("Email not provided")
```

### 1.2 Type Checking and Conversion

#### What is Type Checking?

Sometimes you need to know what type of data you're working with. Python provides built-in functions for this.

```python
# Check what type something is
print(type(price_per_night))  # <class 'float'>
print(type(campsite_capacity))  # <class 'int'>
print(type(location_name))  # <class 'str'>

# Check if something is a specific type (returns True/False)
print(isinstance(campsite_capacity, int))  # True - yes, it's an integer
print(isinstance(price_per_night, str))    # False - no, it's not a string
```

#### Why Check Types?

Different types support different operations:
- You can do math with numbers (`int`, `float`)
- You can't do math with strings (unless you convert them first)
- Understanding types prevents errors!

```python
# This works - both are numbers
result = 10 + 5  # 15

# This causes an error - can't add string and number!
# result = "10" + 5  # TypeError!

# You must convert first
result = int("10") + 5  # 15 (converted string to int, then added)
```

#### Type Conversion - Changing Data Types

**Type conversion** (also called "casting") means changing data from one type to another.

```python
# String to Number
price_str = "78.50"                # This is a string (text)
price_float = float(price_str)     # Convert to float: 78.5
price_int = int(float(price_str))  # Convert to int: 78 (loses decimals!)

# Number to String
capacity_num = 50
capacity_str = str(capacity_num)   # "50" (now it's text, not a number)

# Why convert? Example: building a message
message = "Capacity: " + str(50) + " people"  # "Capacity: 50 people"
# Without str(), you'd get an error trying to add string + number!

# Better way: use f-strings (we'll cover these later)
message = f"Capacity: {50} people"  # Automatic conversion!
```

#### Safe Conversion - Handling Errors

What if you try to convert "hello" to a number? It will crash! Use error handling:

```python
def safe_float_conversion(value):
    """Safely convert a value to float.
    
    Args:
        value: Any value to convert
        
    Returns:
        float or None: Converted number, or None if conversion fails
    """
    try:
        return float(value)  # Try to convert
    except (ValueError, TypeError):  # If it fails...
        return None  # Return None instead of crashing

# Usage examples
result1 = safe_float_conversion("78.50")  # Returns 78.5 ✓
result2 = safe_float_conversion("invalid")  # Returns None (instead of crashing) ✓
result3 = safe_float_conversion(None)  # Returns None ✓

# Now you can check if conversion worked
price = safe_float_conversion(user_input)
if price is not None:
    print(f"Price: R${price}")
else:
    print("Invalid price entered!")
```

**Key Points:**
- `int()` - Converts to integer (whole number, removes decimals)
- `float()` - Converts to decimal number
- `str()` - Converts to text/string
- Always handle cases where conversion might fail!


### 1.3 Collections - Storing Multiple Values

So far we've seen how to store single values. But what if you need to store multiple related items? Python has several **collection types**.

#### List - Ordered, Changeable Collection

**Lists** store multiple items in order. Think of it like a numbered list where you can add, remove, or change items.

**Key Properties:**
- **Ordered**: Items stay in the order you put them
- **Mutable**: You can change, add, or remove items
- **Allows duplicates**: Same item can appear multiple times
- Created with square brackets `[...]`

```python
# List - ordered, mutable (changeable)
locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

# Access items by index (position) - starts at 0!
first_location = locations[0]   # "Chapada Diamantina"
second_location = locations[1]  # "Serra dos Órgãos"
last_location = locations[-1]   # "Pico da Bandeira" (negative counts from end)

# Change an item
locations[0] = "Pantanal"  # Now list is ["Pantanal", "Serra dos Órgãos", "Pico da Bandeira"]

# Add items
locations.append("Amazonia")  # Add to end

# Remove items
locations.remove("Pantanal")  # Remove by value

# Check how many items
count = len(locations)  # 3
```

**Why use lists?** When you have multiple related items that you might need to change.

#### Tuple - Ordered, UNCHANGEABLE Collection

**Tuples** are like lists but **you cannot change them** after creation. They're "frozen" lists.

**Key Properties:**
- **Ordered**: Items stay in order
- **Immutable**: CANNOT change after creation
- **Allows duplicates**: Same item can appear multiple times
- Created with parentheses `(...)`

```python
# Tuple - ordered, immutable (cannot change)
coordinates = (-22.9519, -43.2105)  # (latitude, longitude)

# Access items (same as list)
latitude = coordinates[0]   # -22.9519
longitude = coordinates[1]  # -43.2105

# You CANNOT change tuple items - this would cause an error:
# coordinates[0] = -20.0  # TypeError! Tuples can't be modified

# You CAN replace the entire tuple
coordinates = (-20.0, -40.0)  # This creates a NEW tuple
```

**Why use tuples?** When you have data that should never change (like coordinates, dates, fixed configurations).

#### Dictionary - Key-Value Pairs

**Dictionaries** store data as **key: value** pairs. Like a real dictionary where you look up a word (key) to get its definition (value).

**Key Properties:**
- **Unordered**: No specific order (Python 3.7+ maintains insertion order)
- **Mutable**: Can add, change, remove items
- **Keys must be unique**: Each key appears only once
- Created with curly braces `{key: value}`

```python
# Dictionary - key-value pairs
campsite = {
    "name": "Camping Vale do Pati",
    "price": 120.00,
    "capacity": 30,
    "has_toilet": True
}

# Access values using keys (not numbers!)
name = campsite["name"]      # "Camping Vale do Pati"
price = campsite["price"]    # 120.00

# Add or change values
campsite["has_shower"] = True     # Add new key-value pair
campsite["price"] = 130.00        # Change existing value

# Remove items
del campsite["capacity"]  # Remove the capacity key
```

**Why use dictionaries?** When you want to label your data with meaningful names instead of positions.

#### Set - Unique, Unordered Collection

**Sets** store unique values only. Like a bag of items where duplicates automatically disappear.

**Key Properties:**
- **Unordered**: No specific order
- **Mutable**: Can add/remove items
- **NO duplicates**: Each item appears only once
- Created with curly braces `{...}` or `set()`

```python
# Set - unordered, unique values only
states = {"BA", "RJ", "MG", "SP"}

# Add items
states.add("RS")  # Now has 5 items
states.add("BA")  # Already exists - nothing happens! Still 5 items

# Remove items
states.remove("RS")  # Removed

# Sets automatically remove duplicates
duplicate_states = {"BA", "RJ", "BA", "MG", "BA"}
unique_states = set(duplicate_states)  # {"BA", "RJ", "MG"} - only 3 items!
```

**Why use sets?** When you need unique values or want to do set operations (union, intersection).

#### Quick Comparison Table

| Type | Ordered? | Changeable? | Duplicates? | Syntax | Use When... |
|------|----------|-------------|-------------|--------|-------------|
| **List** | ✅ Yes | ✅ Yes | ✅ Yes | `[1, 2, 3]` | Need ordered, changeable data |
| **Tuple** | ✅ Yes | ❌ No | ✅ Yes | `(1, 2, 3)` | Need ordered, fixed data |
| **Dict** | Sort of* | ✅ Yes | Keys: ❌ No<br>Values: ✅ Yes | `{"a": 1}` | Need labeled data |
| **Set** | ❌ No | ✅ Yes | ❌ No | `{1, 2, 3}` | Need unique values |

*Dictionaries maintain insertion order in Python 3.7+, but order isn't their primary feature.


---

## 2. Control Flow

**Control flow** determines which code runs and when. It's how you make decisions and repeat actions in your programs.

### 2.1 If/Elif/Else Statements - Making Decisions

**If statements** let your program make decisions based on conditions.

#### Basic Structure

```python
if condition:
    # Code runs ONLY if condition is True
    do_something()
```

#### How It Works

1. Python checks if the condition is `True`
2. If `True`, it runs the indented code
3. If `False`, it skips the indented code

**Important:** Python uses **indentation** (spaces) to show what code belongs inside the if!

```python
def categorize_price(price):
    """Categorize campsite price into budget/mid-range/premium.
    
    Args:
        price (float): Price per night
        
    Returns:
        str: Category name
    """
    # Check conditions in order
    if price < 50:
        return "Budget"         # If price is less than 50, return this
    elif price < 100:           # "elif" = "else if" - check next condition
        return "Mid-Range"      # If price is 50-99, return this
    else:                       # If none of the above
        return "Premium"        # If price is 100+, return this

# Try it out!
category1 = categorize_price(40)    # "Budget" (40 < 50)
category2 = categorize_price(78.50) # "Mid-Range" (78.50 < 100)
category3 = categorize_price(120)   # "Premium" (120 >= 100)
```

#### Understanding Conditions

**Conditions** are expressions that evaluate to `True` or `False`:

```python
# Comparison operators
price = 78.50

price < 100       # True (78.50 is less than 100)
price > 100       # False (78.50 is not greater than 100)
price == 78.50    # True (equals - note double ==)
price != 100      # True (not equal to 100)
price >= 50       # True (greater than or equal to 50)
price <= 80       # True (less than or equal to 80)

# Common mistake: = vs ==
# price = 100   # This SETS price to 100 (assignment)
# price == 100  # This CHECKS if price equals 100 (comparison)
```

#### Multiple Conditions with AND/OR

Combine conditions using `and` and `or`:

```python
price = 78.50
has_toilet = True

# AND - both conditions must be True
if price < 100 and has_toilet:
    print("Affordable with good amenities!")  # This runs
    
# OR - at least one condition must be True
if price < 50 or has_toilet:
    print("Either cheap OR has toilet")  # This runs (has_toilet is True)

# NOT - inverts the condition
if not has_toilet:
    print("No toilet available")  # This does NOT run (has_toilet is True)
```

### 2.2 Ternary Operator (One-Line If/Else)

**Ternary operator** is a shortcut for simple if/else statements.

#### Traditional Way (3 lines)

```python
if has_electricity:
    amenity_level = "Modern"
else:
    amenity_level = "Basic"
```

#### Ternary Way (1 line)

```python
# Syntax: value_if_true if condition else value_if_false
amenity_level = "Modern" if has_electricity else "Basic"
```

**When to use:** Simple True/False choices. Don't use for complex logic!

```python
# Good use cases
status = "Open" if is_open else "Closed"
price_type = "Expensive" if price > 100 else "Affordable"
min_value = a if a < b else b  # Get minimum of two values

# Bad use case (too complex, hard to read)
# result = "A" if x > 10 else "B" if x > 5 else "C" if x > 0 else "D"  # DON'T DO THIS!
```

### 2.3 Loops - Repeating Actions

**Loops** let you repeat code multiple times without writing it over and over.

#### Why Use Loops?

Without loops:
```python
# BAD - repetitive code
print(campsites[0])
print(campsites[1])
print(campsites[2])
# ... what if you have 100 campsites?
```

With loops:
```python
# GOOD - works for any number of campsites
for campsite in campsites:
    print(campsite)
```

#### For Loops - Iterate Over Items

**For loops** run once for each item in a collection.

```python
# Loop through a list
locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

for location in locations:  # "for each location in locations"
    print(f"Processing: {location}")  # This runs 3 times, once per location
    
# Output:
# Processing: Chapada Diamantina
# Processing: Serra dos Órgãos
# Processing: Pico da Bandeira
```

**How it works:**
1. Python takes the first item from `locations` → `"Chapada Diamantina"`
2. Sets the variable `location = "Chapada Diamantina"`
3. Runs the indented code
4. Goes back, takes next item → `"Serra dos Órgãos"`
5. Repeats until all items are processed

#### Enumerate - Loop With Index Numbers

**enumerate()** gives you both the **item** and its **position number**.

```python
locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

# Without enumerate (you only get the item)
for location in locations:
    print(location)  # Just the name

# With enumerate (you get position + item)
for idx, location in enumerate(locations):
    print(f"{idx}. {location}")  # Position starts at 0
    
# Output:
# 0. Chapada Diamantina
# 1. Serra dos Órgãos
# 2. Pico da Bandeira

# Start numbering at 1 instead of 0
for idx, location in enumerate(locations, start=1):
    print(f"{idx}. {location}")
    
# Output:
# 1. Chapada Diamantina
# 2. Serra dos Órgãos
# 3. Pico da Bandeira
```

**When to use enumerate:** When you need to know the position of items (like numbering a list).

#### Looping Through Dictionaries

```python
campsite = {"name": "Camping Vale", "price": 120.00, "capacity": 30}

# Loop through keys only
for key in campsite:
    print(key)  # name, price, capacity

# Loop through values only
for value in campsite.values():
    print(value)  # Camping Vale, 120.00, 30

# Loop through key-value pairs (most common!)
for key, value in campsite.items():
    print(f"{key}: {value}")
    
# Output:
# name: Camping Vale
# price: 120.00
# capacity: 30
```

#### Range Function - Loop a Specific Number of Times

**range()** creates a sequence of numbers.

```python
# range(stop) - starts at 0, stops before 'stop'
for i in range(5):  # i = 0, 1, 2, 3, 4 (5 numbers, but stops before 5!)
    print(i)

# Practical example: Loop 5 days
for i in range(1, 6):  # 1, 2, 3, 4, 5
    print(f"Day {i}")
    
# Output:
# Day 1
# Day 2
# Day 3
# Day 4
# Day 5
```

### 2.4 While Loops & Loop Control

#### While Loops - Repeat Until Condition is False

**While loops** keep running as long as a condition is `True`.

```python
# While loop structure
while condition:
    # Code runs repeatedly until condition becomes False
    do_something()
```

**Use for loops when:** You know how many times to repeat (iterate over items)  
**Use while loops when:** You don't know how many times (repeat until something happens)

```python
# Example: Count bookings until campsite is full
capacity = 50
booked = 0

while booked < capacity:  # Keep looping while not full
    booked += 5           # Book 5 more spots
    print(f"Booked: {booked}/{capacity}")
    # Loop exits when booked >= capacity
```

**Warning:** Be careful with while loops! Make sure the condition eventually becomes `False`, or you'll have an **infinite loop**:

```python
# BAD - Infinite loop (never stops!)
# while True:
#     print("This will print forever!")

# GOOD - Has an exit condition
counter = 0
while counter < 5:  # Condition will become False
    print(counter)
    counter += 1    # Make sure to change the condition!
```

#### Break - Exit Loop Early

**break** immediately stops the loop and exits.

```python
# Find the first expensive campsite and stop
prices = [40, 60, 120, 80]

for price in prices:
    if price > 100:
        print(f"Found expensive campsite: ${price}")
        break  # Stop the loop immediately
    print(f"Checking ${price}")

# Output:
# Checking $40
# Checking $60
# Found expensive campsite: $120
# (Loop stopped, $80 is never checked)
```

**When to use break:** When you found what you're looking for and don't need to continue.

#### Continue - Skip to Next Iteration

**continue** skips the rest of the current iteration and jumps to the next one.

```python
# Process only campsites >= $50
prices = [40, 60, 120, 80]

for price in prices:
    if price < 50:
        continue  # Skip this price, go to next one
    print(f"Acceptable price: ${price}")

# Output:
# Acceptable price: $60
# Acceptable price: $120
# Acceptable price: $80
# ($40 was skipped by continue)
```

**When to use continue:** When you want to skip certain items but keep processing the rest.

#### Break vs Continue

```python
# Same list, different behaviors
numbers = [1, 2, 3, 4, 5]

# With break - stops completely
for num in numbers:
    if num == 3:
        break  # Exit the loop
    print(num)  # Prints: 1, 2 (then stops)

# With continue - skips only that iteration
for num in numbers:
    if num == 3:
        continue  # Skip to next iteration
    print(num)  # Prints: 1, 2, 4, 5 (skips 3)
```

---

## 3. Functions

**Functions** are reusable blocks of code that perform specific tasks. Think of them as mini-programs inside your program.

### What Are Functions?

**Functions** let you:
1. **Avoid repetition** - Write code once, use it many times
2. **Organize code** - Break complex programs into smaller pieces
3. **Make code readable** - Name explains what the code does

#### Without Functions (Repetitive)
```python
# Calculate cost for booking 1
total1 = 3 * 78.50  # 235.5

# Calculate cost for booking 2
total2 = 5 * 78.50  # 392.5

# Calculate cost for booking 3
total3 = 2 * 78.50  # 157.0
```

#### With Functions (Reusable)
```python
def calculate_total_price(nights, price_per_night):
    return nights * price_per_night

# Use the function multiple times
total1 = calculate_total_price(3, 78.50)  # 235.5
total2 = calculate_total_price(5, 78.50)  # 392.5
total3 = calculate_total_price(2, 78.50)  # 157.0
```

### 3.1 Basic Function Definition

**Function anatomy:**
```python
def function_name(parameter1, parameter2):  # def = define, parameters in ()
    """Docstring explaining what the function does."""  # Optional but recommended
    
    # Function body - the code that runs
    result = parameter1 + parameter2
    
    return result  # Send back the result
```

**Key Parts:**
1. **def** - Keyword that says "I'm defining a function"
2. **function_name** - What you call the function (use descriptive names!)
3. **Parameters** - Input values the function needs (in parentheses)
4. **Docstring** - Description of what the function does (in triple quotes)
5. **return** - Send back the result (optional - some functions just do actions)

```python
def calculate_total_price(nights, price_per_night):
    """Calculate total camping cost.
    
    Args:
        nights (int): Number of nights to stay
        price_per_night (float): Price per night
        
    Returns:
        float: Total price for all nights
    """
    # Multiply nights by price per night
    total = nights * price_per_night
    return total  # Send back the result

# Using the function (this is called "calling" the function)
result = calculate_total_price(3, 78.50)  # 3 nights × $78.50 = $235.50
print(result)  # 235.5
```

**Parameters vs Arguments:**
- **Parameters** = The variables in the function definition (`nights`, `price_per_night`)
- **Arguments** = The actual values you pass in when calling (`3`, `78.50`)

### 3.2 Default Parameters

**Default parameters** have pre-set values that are used if you don't provide them.

```python
def create_campsite_url(location_id, base_url="https://camping.br"):
    """Generate campsite URL.
    
    Args:
        location_id (int): Location ID
        base_url (str, optional): Base URL. Defaults to "https://camping.br".
        
    Returns:
        str: Full URL to the campsite
    """
    return f"{base_url}/location/{location_id}"

# Call WITHOUT providing base_url (uses default)
url1 = create_campsite_url(5)  
print(url1)  # https://camping.br/location/5

# Call WITH custom base_url (overrides default)
url2 = create_campsite_url(5, "https://api.camping.br")
print(url2)  # https://api.camping.br/location/5
```

**When to use defaults:** For parameters that usually have the same value but might occasionally change.

**Important Rule:** Parameters with defaults MUST come after parameters without defaults!

```python
# GOOD - default parameter comes last
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

# BAD - this causes an error!
# def greet(greeting="Hello", name):  # SyntaxError!
#     return f"{greeting}, {name}!"
```

### 3.3 Variable Arguments: *args and **kwargs

Sometimes you don't know how many arguments a function will receive. That's where **\*args** and **\*\*kwargs** come in.

#### \*args - Variable Number of Positional Arguments

**\*args** lets you pass any number of arguments (like a list).

```python
def calculate_stats(*prices):  # * means "accept any number of arguments"
    """Calculate price statistics for any number of prices.
    
    Args:
        *prices: Variable number of price values
        
    Returns:
        dict: Statistics dictionary
    """
    if not prices:  # Check if no prices provided
        return {"count": 0}
    
    return {
        "count": len(prices),      # How many prices
        "min": min(prices),        # Lowest price
        "max": max(prices),        # Highest price
        "avg": sum(prices) / len(prices)  # Average price
    }

# You can pass any number of arguments!
stats1 = calculate_stats(40, 60, 120, 80)  # 4 arguments
# Result: {'count': 4, 'min': 40, 'max': 120, 'avg': 75.0}

stats2 = calculate_stats(100, 200)  # 2 arguments
# Result: {'count': 2, 'min': 100, 'max': 200, 'avg': 150.0}

stats3 = calculate_stats()  # 0 arguments
# Result: {'count': 0}
```

**How it works:** Python packs all arguments into a **tuple** called `prices`.

#### \*\*kwargs - Variable Number of Keyword Arguments

**\*\*kwargs** lets you pass any number of **named** arguments (like a dictionary).

```python
def create_campsite(**attributes):  # ** means "accept any number of named arguments"
    """Create campsite with any number of attributes.
    
    Args:
        **attributes: Keyword arguments for campsite attributes
        
    Returns:
        dict: Campsite data dictionary
    """
    return {
        "type": "campsite",
        **attributes  # Unpack all the keyword arguments
    }

# You can pass any named arguments you want!
campsite1 = create_campsite(
    name="Camping Vale",
    price=120.00,
    capacity=30,
    has_toilet=True
)
# Result: {'type': 'campsite', 'name': 'Camping Vale', 'price': 120.0, 'capacity': 30, 'has_toilet': True}

campsite2 = create_campsite(
    name="Mountain Camp",
    price=80.00
)
# Result: {'type': 'campsite', 'name': 'Mountain Camp', 'price': 80.0}
```

**How it works:** Python packs all keyword arguments into a **dictionary** called `attributes`.

**Note:** The names `args` and `kwargs` are conventions. What matters is the `*` and `**`, not the names!

### 3.4 Lambda Functions (Anonymous Functions)

**Lambda functions** are small, one-line functions without a name. They're shortcuts for simple functions.

#### Regular Function vs Lambda

```python
# Regular function - multiple lines, has a name
def is_expensive(price):
    return price > 100

# Lambda function - one line, no name
is_expensive = lambda price: price > 100

# Both work the same way!
result1 = is_expensive(120)  # True
result2 = is_expensive(80)   # False
```

**Lambda syntax:**
```python
lambda arguments: expression
#  ^              ^
#  |              |
#  inputs         what to return (automatically returned)
```

**Key differences:**
- Lambda: One expression only, returns automatically
- Regular function: Multiple statements, explicit `return`

**When to use lambdas:** For simple, one-time functions (often with `map()`, `filter()`, `sorted()`).

```python
# Practical lambda examples
campsites = [
    {"name": "Camp A", "price": 80},
    {"name": "Camp B", "price": 40},
    {"name": "Camp C", "price": 120}
]

# Sort by price using lambda
# sorted() needs a function to tell it what to sort by
sorted_campsites = sorted(campsites, key=lambda x: x["price"])
# Result: [{'name': 'Camp B', 'price': 40}, {'name': 'Camp A', 'price': 80}, {'name': 'Camp C', 'price': 120}]

# Filter expensive campsites using lambda
# filter() keeps items where the function returns True
expensive = list(filter(lambda x: x["price"] > 100, campsites))
# Result: [{'name': 'Camp C', 'price': 120}]

# Map (transform) all prices with 10% discount
discounted = list(map(lambda x: x["price"] * 0.9, campsites))
# Result: [72.0, 36.0, 108.0]
```

**When NOT to use lambdas:**
- Complex logic (use regular functions instead)
- Multiple statements (lambdas can only have one expression)
- When you need to reuse the function multiple times (give it a proper name!)

---

## 4. Lists and List Comprehensions

### What Are List Operations?

Lists are Python's most versatile data structure. You'll constantly be adding items, removing items, checking items, and transforming lists.

### 4.1 Essential List Operations

```python
# Start with a list
locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

# ---------- ADDING ITEMS ----------

# append() - Add ONE item to the END
locations.append("Pantanal")
# Now: ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira", "Pantanal"]

# insert() - Add item at SPECIFIC POSITION
locations.insert(0, "Amazonia")  # Insert at index 0 (beginning)
# Now: ["Amazonia", "Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira", "Pantanal"]

# extend() - Add MULTIPLE items from another list
more_locations = ["Bonito", "Jalapão"]
locations.extend(more_locations)
# Now: ["Amazonia", ..., "Pantanal", "Bonito", "Jalapão"]


# ---------- REMOVING ITEMS ----------

# remove() - Remove by VALUE (removes first occurrence)
locations.remove("Pantanal")  # Finds "Pantanal" and removes it

# pop() - Remove by INDEX and return the item
last_location = locations.pop()  # Remove and return last item
# last_location = "Jalapão", and it's now gone from the list

first_location = locations.pop(0)  # Remove and return first item
# first_location = "Amazonia"

# clear() - Remove ALL items
# locations.clear()  # List becomes empty: []


# ---------- ACCESSING ITEMS (Slicing) ----------

locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

# Get first 2 items
first_two = locations[:2]  # ['Chapada Diamantina', 'Serra dos Órgãos']

# Get last 2 items
last_two = locations[-2:]  # ['Serra dos Órgãos', 'Pico da Bandeira']

# Get middle item(s)
middle = locations[1:2]  # ['Serra dos Órgãos']

# Reverse a list
reversed_list = locations[::-1]  # ['Pico da Bandeira', 'Serra dos Órgãos', 'Chapada Diamantina']


# ---------- CHECKING ITEMS ----------

# Check if item exists
if "Chapada Diamantina" in locations:
    print("Found!")  # This prints
    
if "Pantanal" not in locations:
    print("Not in the list")  # This prints


# ---------- OTHER USEFUL OPERATIONS ----------

# Count items
count = len(locations)  # 3

# Find index of item
index = locations.index("Serra dos Órgãos")  # 1

# Count occurrences of an item
locations_with_duplicates = ["BA", "RJ", "BA", "SP", "BA"]
ba_count = locations_with_duplicates.count("BA")  # 3

# Sort the list (changes original)
numbers = [5, 2, 8, 1, 9]
numbers.sort()  # Now: [1, 2, 5, 8, 9]

# Sort without changing original (returns new list)
numbers = [5, 2, 8, 1, 9]
sorted_numbers = sorted(numbers)  # [1, 2, 5, 8, 9]
# numbers is still [5, 2, 8, 1, 9]
```

### 4.2 List Comprehensions - Compact List Creation

**List comprehensions** let you create new lists in a single line. They're a Python shortcut that's faster and more readable than loops.

#### What Problem Do They Solve?

Traditional way (with loop):
```python
# Create list of squared numbers
numbers = [1, 2, 3, 4, 5]
squares = []
for num in numbers:
    squares.append(num ** 2)  # ** means "to the power of"
# Result: [1, 4, 9, 16, 25]
```

With list comprehension (one line):
```python
numbers = [1, 2, 3, 4, 5]
squares = [num ** 2 for num in numbers]
# Result: [1, 4, 9, 16, 25]
```

#### List Comprehension Syntax

```python
# Basic syntax:
[expression for item in iterable]
#     ^          ^         ^
#     |          |         |
#   what to    loop      what to
#   create    variable   loop over

# With condition (filter):
[expression for item in iterable if condition]
#                                  ^
#                                  |
#                            only include if True
```

#### Example 1: Transform List

```python
# Create list of prices
prices = [40, 60, 120, 80]

# Traditional loop way
prices_with_tax = []
for price in prices:
    prices_with_tax.append(price * 1.15)
# Result: [46.0, 69.0, 138.0, 92.0]

# List comprehension way (same result, one line)
prices_with_tax = [price * 1.15 for price in prices]
# Result: [46.0, 69.0, 138.0, 92.0]
```

**Reading comprehensions:** Read them from right to left!
- "for price in prices" - loop through prices
- "price * 1.15" - for each price, multiply by 1.15

#### Example 2: Filter and Transform

You can combine filtering (if) and transforming in one comprehension!

```python
# Get expensive prices (> 70) with tax applied
prices = [40, 60, 120, 80]

# Traditional way
expensive_with_tax = []
for price in prices:
    if price > 70:  # Filter: only expensive
        expensive_with_tax.append(price * 1.15)  # Transform: add tax

# List comprehension way
expensive_with_tax = [
    price * 1.15 
    for price in prices 
    if price > 70
]
# Result: [138.0, 92.0]  (120*1.15, 80*1.15)
```

#### Example 3: Nested Comprehension

List comprehensions can replace nested loops!

```python
# Create all combinations of state-year
states = ["BA", "RJ", "MG"]
years = [2024, 2025]

# Traditional nested loop
combinations = []
for state in states:
    for year in years:
        combinations.append(f"{state}-{year}")

# List comprehension with nested loops
combinations = [
    f"{state}-{year}"
    for state in states
    for year in years
]
# Result: ['BA-2024', 'BA-2025', 'RJ-2024', 'RJ-2025', 'MG-2024', 'MG-2025']
```

#### Example 4: Dictionary Comprehension from List

You can also create dictionaries with comprehensions!

```python
locations = ["Chapada Diamantina", "Serra dos Órgãos", "Pico da Bandeira"]

# Create ID mapping {location_name: id}
location_map = {
    location: idx 
    for idx, location in enumerate(locations, start=1)
}
# Result: {'Chapada Diamantina': 1, 'Serra dos Órgãos': 2, 'Pico da Bandeira': 3}
```

**When to use list comprehensions:**
- ✅ Simple transformations or filters
- ✅ Creating new lists from existing ones
- ✅ When it's more readable than a loop

**When NOT to use:**
- ❌ Complex logic (use regular loops for clarity)
- ❌ Side effects (print, file operations, etc.)

---

## 5. Dictionaries and Sets

### 5.1 Dictionary Operations - Working with Key-Value Data

Dictionaries are one of Python's most powerful features. You'll use them constantly in data engineering!

```python
# Create dictionary
campsite = {
    "id": 1,
    "name": "Camping Vale do Pati",
    "price": 120.00,
    "capacity": 30
}

# ---------- ACCESSING VALUES ----------

# Using brackets [] - throws error if key doesn't exist
name = campsite["name"]  # "Camping Vale do Pati"
# campsite["discount"]  # KeyError! Key doesn't exist

# Using .get() - returns None (or default) if key doesn't exist (SAFER!)
price = campsite.get("price")  # 120.00
discount = campsite.get("discount")  # None (key doesn't exist)
discount = campsite.get("discount", 0)  # 0 (custom default value)


# ---------- ADDING / UPDATING VALUES ----------

# Add new key-value pair
campsite["has_toilet"] = True
# Now: {..., "has_toilet": True}

# Update existing value
campsite["price"] = 130.00
# Now: {..., "price": 130.00}

# Update multiple at once with .update()
campsite.update({"has_shower": True, "has_electricity": False})
# Now: {..., "has_shower": True, "has_electricity": False}


# ---------- REMOVING VALUES ----------

# Delete key-value pair
del campsite["capacity"]
# "capacity" is now gone

# Remove and return value with .pop()
price = campsite.pop("price", None)  # Returns 130.00 and removes it
# price = 130.00, and "price" key is gone
# If key doesn't exist, returns None (the default)


# ---------- CHECKING EXISTENCE ----------

# Check if key exists
if "name" in campsite:
    print("Has name")  # This prints
    
if "price" not in campsite:
    print("No price set")  # This prints (we removed it above)


# ---------- LOOPING THROUGH DICTIONARIES ----------

campsite = {"id": 1, "name": "Camping Vale", "price": 120.00}

# Loop through key-value pairs (most common!)
for key, value in campsite.items():
    print(f"{key}: {value}")
# Output:
# id: 1
# name: Camping Vale
# price: 120.0

# Loop through keys only
for key in campsite.keys():
    print(key)  # id, name, price

# Loop through values only
for value in campsite.values():
    print(value)  # 1, Camping Vale, 120.0


# ---------- GETTING ALL KEYS/VALUES ----------

# Get all keys as a list
keys = list(campsite.keys())  # ['id', 'name', 'price']

# Get all values as a list
values = list(campsite.values())  # [1, 'Camping Vale', 120.0]

# Get all key-value pairs as list of tuples
items = list(campsite.items())  # [('id', 1), ('name', 'Camping Vale'), ('price', 120.0)]
```

### 5.2 Dictionary Comprehension - Create Dictionaries in One Line

Just like list comprehensions, you can create dictionaries compactly!

```python
# Create price dictionary from two lists
locations = ["Chapada", "Serra", "Pico"]
prices = [120, 80, 100]

# Traditional way
price_map = {}
for location, price in zip(locations, prices):  # zip pairs up items
    price_map[location] = price
# Result: {'Chapada': 120, 'Serra': 80, 'Pico': 100}

# Dictionary comprehension way (one line!)
price_map = {
    location: price 
    for location, price in zip(locations, prices)
}
# Result: {'Chapada': 120, 'Serra': 80, 'Pico': 100}


# Filter dictionary - keep only expensive locations
expensive_only = {
    location: price 
    for location, price in price_map.items() 
    if price > 90  # Only include if price > 90
}
# Result: {'Chapada': 120, 'Pico': 100}


# Transform dictionary values - add 15% tax
with_tax = {
    location: price * 1.15 
    for location, price in price_map.items()
}
# Result: {'Chapada': 138.0, 'Serra': 92.0, 'Pico': 115.0}
```

**Dictionary comprehension syntax:**
```python
{key_expression: value_expression for item in iterable if condition}
```

### 5.3 Set Operations - Working with Unique Collections

**Sets** are great for removing duplicates and performing set mathematics (union, intersection, difference).

#### What Makes Sets Special?

- **Automatic uniqueness** - duplicates are removed automatically
- **Fast membership testing** - checking if item exists is very fast
- **Set math** - union, intersection, difference operations

```python
# Create sets
brazilian_states = {"BA", "RJ", "MG", "SP"}
southeast_states = {"RJ", "MG", "SP", "ES"}

# ---------- ADDING / REMOVING ITEMS ----------

# Add single item
brazilian_states.add("RS")
# Now: {"BA", "RJ", "MG", "SP", "RS"}

# Try to add duplicate (nothing happens - sets only keep unique values!)
brazilian_states.add("BA")
# Still: {"BA", "RJ", "MG", "SP", "RS"}

# Remove item (raises KeyError if not found)
brazilian_states.remove("RS")
# Now: {"BA", "RJ", "MG", "SP"}

# Remove item safely (no error if not found)
brazilian_states.discard("RS")  # Does nothing (RS not in set)
brazilian_states.discard("XY")  # Also does nothing, no error


# ---------- SET OPERATIONS (Math!) ----------

brazilian_states = {"BA", "RJ", "MG", "SP"}
southeast_states = {"RJ", "MG", "SP", "ES"}

# INTERSECTION (&) - Items in BOTH sets
common = brazilian_states & southeast_states
# Result: {'RJ', 'MG', 'SP'}
# Alternative: common = brazilian_states.intersection(southeast_states)

# UNION (|) - Items in EITHER set (combined, no duplicates)
all_states = brazilian_states | southeast_states
# Result: {'BA', 'RJ', 'MG', 'SP', 'ES'}
# Alternative: all_states = brazilian_states.union(southeast_states)

# DIFFERENCE (-) - Items in FIRST set but NOT in second
only_in_first = brazilian_states - southeast_states
# Result: {'BA'}
# Alternative: only_in_first = brazilian_states.difference(southeast_states)

# SYMMETRIC DIFFERENCE (^) - Items in EITHER set but NOT in both
unique_to_each = brazilian_states ^ southeast_states
# Result: {'BA', 'ES'} (BA only in first, ES only in second)


# ---------- CHECKING MEMBERSHIP ----------

# Check if item exists (very fast!)
if "BA" in brazilian_states:
    print("Bahia is included")  # This prints

# Check if set is subset (all items in another set)
small_set = {"RJ", "MG"}
is_subset = small_set <= brazilian_states  # True (RJ and MG are in brazilian_states)

# Check if set is superset (contains all items of another set)
is_superset = brazilian_states >= small_set  # True


# ---------- PRACTICAL USE CASE: Remove Duplicates ----------

# You have a list with duplicates
cities = ["Rio", "São Paulo", "Rio", "Salvador", "São Paulo", "Rio"]

# Convert to set to remove duplicates
unique_cities = set(cities)
# Result: {'Rio', 'São Paulo', 'Salvador'}

# Convert back to list if needed
unique_cities_list = list(unique_cities)
# Result: ['Rio', 'São Paulo', 'Salvador']
```

**When to use sets:**
- ✅ Need unique values only
- ✅ Fast membership testing (`if item in set`)
- ✅ Set mathematics (union, intersection, difference)
- ✅ Remove duplicates from lists

**When NOT to use sets:**
- ❌ Need to maintain order (use list or dict instead)
- ❌ Need duplicate values (use list)
- ❌ Need to access items by index (sets don't have indexes)

---

## 6. String Manipulation

**Strings** are sequences of characters (text). In Python, strings are **immutable** - you can't change them after creation, but you can create new strings based on existing ones.

### What is String Immutability?

```python
# This doesn't change the original string - it creates a NEW string
location = "chapada"
location_upper = location.upper()  # Creates "CHAPADA"

# Original is unchanged
print(location)  # Still "chapada"
print(location_upper)  # "CHAPADA"
```

### 6.1 Essential String Methods

```python
location = "  Chapada Diamantina  "  # Note: spaces before and after

# ---------- CASE CONVERSION ----------

# upper() - Convert ALL to uppercase
upper = location.upper()  # "  CHAPADA DIAMANTINA  "

# lower() - Convert ALL to lowercase
lower = location.lower()  # "  chapada diamantina  "

# title() - Capitalize First Letter Of Each Word
title = location.title()  # "  Chapada Diamantina  "

# capitalize() - Capitalize only first letter
cap = location.strip().capitalize()  # "Chapada diamantina"


# ---------- WHITESPACE REMOVAL ----------

# strip() - Remove spaces from BOTH ends
stripped = location.strip()  # "Chapada Diamantina"

# lstrip() - Remove spaces from LEFT side only
left_stripped = location.lstrip()  # "Chapada Diamantina  "

# rstrip() - Remove spaces from RIGHT side only
right_stripped = location.rstrip()  # "  Chapada Diamantina"


# ---------- REPLACING TEXT ----------

# replace(old, new) - Replace ALL occurrences
location_clean = "Chapada Diamantina"
replaced = location_clean.replace("Chapada", "Serra")
# Result: "Serra Diamantina"

# Replace multiple occurrences
text = "BA-BA-MG"
fixed = text.replace("BA", "RJ")
# Result: "RJ-RJ-MG" (ALL BAs replaced)


# ---------- SPLITTING STRINGS ----------

# split() - Split string into list
csv_data = "BA,RJ,MG"
states = csv_data.split(",")  # Split by comma
# Result: ['BA', 'RJ', 'MG']

# Split by whitespace (default)
sentence = "Camping in Brazil"
words = sentence.split()  # Split by any whitespace
# Result: ['Camping', 'in', 'Brazil']

# Split with limit
text = "BA-RJ-MG-SP"
limited = text.split("-", 2)  # Split only first 2 times
# Result: ['BA', 'RJ', 'MG-SP']


# ---------- JOINING STRINGS ----------

# join() - Combine list into string
states = ["BA", "RJ", "MG"]
joined = ", ".join(states)  # Join with ", " between items
# Result: "BA, RJ, MG"

# Join with different separator
path = "/".join(["home", "user", "documents"])
# Result: "home/user/documents"


# ---------- CHECKING STRING CONTENTS ----------

location_clean = "Chapada Diamantina"

# startswith() - Check if starts with text
starts = location_clean.startswith("Chap")  # True
starts2 = location_clean.startswith("Serra")  # False

# endswith() - Check if ends with text
ends = location_clean.endswith("tina")  # True
ends2 = location_clean.endswith("xyz")  # False

# in operator - Check if contains text
contains = "Diamantina" in location_clean  # True
contains2 = "Serra" in location_clean  # False

# find() - Get position of substring (returns -1 if not found)
pos = location_clean.find("Diamantina")  # 8 (starts at position 8)
pos2 = location_clean.find("xyz")  # -1 (not found)

# count() - Count occurrences
text = "banana"
count = text.count("a")  # 3 (three 'a's in "banana")
```

### 6.2 String Formatting - Creating Dynamic Strings

There are several ways to format strings in Python. **f-strings** (Python 3.6+) are the modern, preferred way.

```python
location = "Chapada Diamantina"
price = 120.50
capacity = 30

# ---------- F-STRINGS (Recommended!) ----------

# Basic f-string
message = f"{location} costs R${price} per night"
# Result: "Chapada Diamantina costs R$120.5 per night"

# Format numbers with specific decimals
message = f"{location} costs R${price:.2f} per night"
# Result: "Chapada Diamantina costs R$120.50 per night"
# :.2f means "2 decimal places"

# Multiple values
info = f"{location} | Capacity: {capacity} | Price: R${price:.2f}"
# Result: "Chapada Diamantina | Capacity: 30 | Price: R$120.50"

# Expressions inside f-strings
discount = f"Discounted: R${price * 0.9:.2f}"
# Result: "Discounted: R$108.45"

# ---------- ALIGNMENT AND PADDING ----------

# Left align (<), Right align (>), Center (^)
header = f"{'Location':<20} {'Price':>10}"
# Result: "Location             Price"
#         (Location left-aligned in 20 chars, Price right-aligned in 10)

row = f"{location:<20} {price:>10.2f}"
# Result: "Chapada Diamantina      120.50"

# Center alignment
centered = f"{'Title':^20}"
# Result: "       Title        " (centered in 20 characters)

# Padding with specific character
padded = f"{'BA':*>10}"
# Result: "********BA" (padded with * to 10 characters)


# ---------- MULTI-LINE F-STRINGS ----------

summary = f"""
Location: {location}
Price: R${price:.2f}
Capacity: {capacity} people
Total for 3 nights: R${price * 3:.2f}
"""
# Result is a multi-line string with all values filled in


# ---------- FORMAT METHOD (Older Way) ----------

# Still works, but f-strings are more readable
message = "{} costs R${:.2f} per night".format(location, price)
# Result: "Chapada Diamantina costs R$120.50 per night"

# Named placeholders
message = "{loc} costs R${p:.2f}".format(loc=location, p=price)
```

**Formatting Cheat Sheet:**
```python
value = 123.456

f"{value}"         # "123.456"
f"{value:.2f}"     # "123.46" (2 decimal places)
f"{value:10}"      # "   123.456" (right-aligned in 10 spaces)
f"{value:<10}"     # "123.456   " (left-aligned in 10 spaces)
f"{value:^10}"     # " 123.456  " (centered in 10 spaces)
f"{value:010}"     # "000123.456" (padded with zeros)
f"{value:,.2f}"    # "123.46" (with thousands separator)
```

### 6.3 String Validation - Checking String Types

Python provides methods to check what kind of characters a string contains.

```python
# ---------- CHECKING CONTENT TYPE ----------

# isdigit() - Check if ALL characters are digits
"123".isdigit()       # True
"12.5".isdigit()      # False (has a dot)
"12a".isdigit()       # False (has a letter)
"".isdigit()          # False (empty string)


# isalnum() - Check if ALL characters are alphanumeric (letters or digits)
"BA123".isalnum()     # True (letters + digits)
"BA-123".isalnum()    # False (has a hyphen)
"Chapada".isalnum()   # True (all letters)


# isalpha() - Check if ALL characters are letters
"Chapada".isalpha()   # True
"Chapada123".isalpha()  # False (has digits)
"Chapada ".isalpha()  # False (has space)


# isspace() - Check if ALL characters are whitespace
"   ".isspace()       # True
"  a  ".isspace()     # False (has a letter)


# isupper() / islower() - Check case
"CHAPADA".isupper()   # True
"chapada".islower()   # True
"Chapada".isupper()   # False (mixed case)


# ---------- PRACTICAL VALIDATION EXAMPLE ----------

def validate_state_code(code):
    """Validate Brazilian state code (2 uppercase letters)."""
    if len(code) != 2:
        return False, "Must be exactly 2 characters"
    
    if not code.isalpha():
        return False, "Must contain only letters"
    
    if not code.isupper():
        return False, "Must be uppercase"
    
    return True, "Valid state code"

# Test it
print(validate_state_code("BA"))    # (True, 'Valid state code')
print(validate_state_code("ba"))    # (False, 'Must be uppercase')
print(validate_state_code("B1"))    # (False, 'Must contain only letters')
print(validate_state_code("BAH"))   # (False, 'Must be exactly 2 characters')
```

**Common String Validation Uses:**
- Validating user input (IDs, codes, names)
- Cleaning data before processing
- Checking file formats
- Form validation in web applications

---

## 7. Built-in Functions

**Built-in functions** are functions that come with Python - you don't need to import anything to use them. They're always available!

### Why Are Built-ins Important?

- ✅ **No import needed** - Always available
- ✅ **Highly optimized** - Written in C, very fast
- ✅ **Common tasks** - Solve frequent programming needs
- ✅ **Standard** - Everyone uses them, easy to read

### 7.1 Common Built-in Functions

```python
prices = [40, 60, 120, 80, 100]

# ---------- MATHEMATICAL FUNCTIONS ----------

# sum() - Add all numbers
total = sum(prices)  # 400 (40+60+120+80+100)

# len() - Count items
count = len(prices)  # 5

# min() - Get smallest value
cheapest = min(prices)  # 40

# max() - Get largest value
most_expensive = max(prices)  # 120

# Calculate average (no built-in average function)
average = sum(prices) / len(prices)  # 80.0


# ---------- TYPE CONVERSION FUNCTIONS ----------

# int() - Convert to integer
price_str = "120"
price_int = int(price_str)  # 120 (integer)

# float() - Convert to decimal number
price_float = float(price_str)  # 120.0 (float)

# str() - Convert to string
number = 120
number_str = str(number)  # "120" (string)

# list() - Convert to list
text = "ABC"
letters = list(text)  # ['A', 'B', 'C']

# set() - Convert to set (removes duplicates)
numbers = [1, 2, 2, 3, 3, 3]
unique = set(numbers)  # {1, 2, 3}

# dict() - Create dictionary from key-value pairs
pairs = [("BA", "Bahia"), ("RJ", "Rio de Janeiro")]
state_dict = dict(pairs)  # {'BA': 'Bahia', 'RJ': 'Rio de Janeiro'}


# ---------- RANGE FUNCTION ----------

# range(stop) - Generate sequence from 0 to stop-1
numbers = list(range(5))  # [0, 1, 2, 3, 4]

# range(start, stop) - Generate sequence from start to stop-1
numbers = list(range(1, 6))  # [1, 2, 3, 4, 5]

# range(start, stop, step) - Generate with specific increment
even = list(range(0, 10, 2))  # [0, 2, 4, 6, 8]


# ---------- SORTING ----------

# sorted() - Return NEW sorted list (doesn't change original)
prices_unsorted = [120, 40, 80, 100, 60]
prices_sorted = sorted(prices_unsorted)
# prices_sorted = [40, 60, 80, 100, 120]
# prices_unsorted is still [120, 40, 80, 100, 60]

# Sort in reverse
prices_desc = sorted(prices, reverse=True)  # [120, 100, 80, 60, 40]

# Sort by custom key
words = ["banana", "pie", "Washington", "book"]
sorted_by_length = sorted(words, key=len)
# ['pie', 'book', 'banana', 'Washington'] (sorted by word length)


# ---------- TYPE CHECKING ----------

# type() - Get the type of a variable
print(type(120))        # <class 'int'>
print(type(120.5))      # <class 'float'>
print(type("text"))     # <class 'str'>
print(type([1, 2, 3]))  # <class 'list'>

# isinstance() - Check if variable is specific type
is_int = isinstance(120, int)  # True
is_str = isinstance(120, str)  # False
```

### 7.2 zip() - Combine Multiple Lists

**zip()** takes multiple iterables and combines them into tuples.

**Think of it like a zipper** - it pairs up items from different lists!

```python
locations = ["Chapada", "Serra", "Pico"]
prices = [120, 80, 100]
capacities = [30, 20, 15]

# Combine into list of tuples
combined = list(zip(locations, prices, capacities))
# Result: [('Chapada', 120, 30), ('Serra', 80, 20), ('Pico', 100, 15)]

# Loop through zipped items
for location, price, capacity in zip(locations, prices, capacities):
    print(f"{location}: R${price} | Capacity: {capacity}")
# Output:
# Chapada: R$120 | Capacity: 30
# Serra: R$80 | Capacity: 20
# Pico: R$100 | Capacity: 15

# Create dictionary from two lists
price_map = dict(zip(locations, prices))
# Result: {'Chapada': 120, 'Serra': 80, 'Pico': 100}


# ---------- UNZIP (Reverse zip) ----------

# Use * to unzip
combined = [('Chapada', 120, 30), ('Serra', 80, 20), ('Pico', 100, 15)]
locations, prices, capacities = zip(*combined)
# locations = ('Chapada', 'Serra', 'Pico')
# prices = (120, 80, 100)
# capacities = (30, 20, 15)


# ---------- ZIP WITH DIFFERENT LENGTHS ----------

# zip stops at shortest list
list1 = [1, 2, 3, 4, 5]
list2 = ['a', 'b', 'c']
paired = list(zip(list1, list2))
# Result: [(1, 'a'), (2, 'b'), (3, 'c')] - stops at 3 (shortest)
```

### 7.3 enumerate() - Get Index AND Value

**enumerate()** gives you both the position (index) and the item when looping.

```python
locations = ["Chapada", "Serra", "Pico"]

# Basic enumerate (starts at 0)
for idx, location in enumerate(locations):
    print(f"{idx}: {location}")
# Output:
# 0: Chapada
# 1: Serra
# 2: Pico

# Start numbering at 1 (more user-friendly)
for idx, location in enumerate(locations, start=1):
    print(f"{idx}. {location}")
# Output:
# 1. Chapada
# 2. Serra
# 3. Pico

# Get as list of tuples
indexed = list(enumerate(locations, start=1))
# Result: [(1, 'Chapada'), (2, 'Serra'), (3, 'Pico')]
```

**When to use enumerate:**
- Need to know position while looping
- Numbering items for display
- Accessing index for list modifications

### 7.4 map() and filter() - Transform and Filter Data

#### map() - Apply Function to Every Item

**map()** applies a function to each item in a list.

```python
prices = [40, 60, 120, 80]

# Apply tax to all prices
prices_with_tax = list(map(lambda x: x * 1.15, prices))
# Result: [46.0, 69.0, 138.0, 92.0]

# Alternative with function
def add_tax(price):
    return price * 1.15

prices_with_tax = list(map(add_tax, prices))
# Same result: [46.0, 69.0, 138.0, 92.0]
```

#### filter() - Keep Only Items That Match Condition

**filter()** keeps only items where the function returns `True`.

```python
prices = [40, 60, 120, 80]

# Keep only expensive prices (> 70)
expensive = list(filter(lambda x: x > 70, prices))
# Result: [120, 80]

# Alternative with function
def is_expensive(price):
    return price > 70

expensive = list(filter(is_expensive, prices))
# Same result: [120, 80]
```

#### Combining map() and filter()

```python
prices = [40, 60, 120, 80]

# Get expensive prices WITH tax
# Step 1: Filter expensive (> 70) → [120, 80]
# Step 2: Apply tax to filtered → [138.0, 92.0]

expensive_with_tax = list(
    map(lambda x: x * 1.15,          # Step 2: Apply tax
        filter(lambda x: x > 70, prices))  # Step 1: Filter
)
# Result: [138.0, 92.0]
```

**List comprehension alternative (often more readable):**
```python
# Same result with list comprehension
expensive_with_tax = [p * 1.15 for p in prices if p > 70]
# Result: [138.0, 92.0]
```

### 7.5 any() and all() - Check Multiple Conditions

#### any() - True if AT LEAST ONE is True

```python
amenities = [True, True, False, True]

# Check if has any amenity
has_any_amenity = any(amenities)  # True (at least one is True)

# Practical example
prices = [40, 60, 80, 150]
any_expensive = any(price > 100 for price in prices)  # True (150 > 100)
```

#### all() - True if ALL are True

```python
amenities = [True, True, False, True]

# Check if has all amenities
has_all_amenities = all(amenities)  # False (one is False)

# Practical example
prices = [40, 60, 80, 90]
all_affordable = all(price < 100 for price in prices)  # True (all < 100)
```

**Real-world examples:**
```python
# Check if campsite meets ALL requirements
requirements = [
    has_toilet,
    has_shower,
    capacity >= 20,
    price < 150
]
meets_all = all(requirements)  # True only if ALL are True

# Check if campsite has ANY premium feature
premium_features = [
    has_pool,
    has_restaurant,
    has_wifi
]
has_premium = any(premium_features)  # True if at least one is True
```

---

## 8. Practice Exercises

### Exercise 1: Price Categorization ⭐

**Question:** Write a function that takes a list of prices and returns a dictionary with count of budget (<50), mid-range (50-100), and premium (>100) campsites.

<details>
<summary>💡 Hint</summary>

Use a dictionary with counters, loop through prices, and increment appropriate category.
</details>

<details>
<summary>✅ Solution</summary>

```python
def categorize_prices(prices):
    """Categorize prices into budget/mid-range/premium.
    
    Args:
        prices (list): List of price values
        
    Returns:
        dict: Count per category
    """
    categories = {"budget": 0, "mid_range": 0, "premium": 0}
    
    for price in prices:
        if price < 50:
            categories["budget"] += 1
        elif price <= 100:
            categories["mid_range"] += 1
        else:
            categories["premium"] += 1
    
    return categories

# Test
prices = [40, 60, 120, 80, 45, 110]
result = categorize_prices(prices)
print(result)
# {'budget': 2, 'mid_range': 2, 'premium': 2}
```
</details>

---

### Exercise 2: List Comprehension ⭐⭐

**Question:** Given a list of campsite dictionaries, use list comprehension to create a list of names for campsites that have toilets AND cost less than R$90.

<details>
<summary>✅ Solution</summary>

```python
campsites = [
    {"name": "Camp A", "price": 80, "has_toilet": True},
    {"name": "Camp B", "price": 60, "has_toilet": False},
    {"name": "Camp C", "price": 120, "has_toilet": True},
    {"name": "Camp D", "price": 70, "has_toilet": True},
]

# List comprehension
affordable_with_toilet = [
    camp["name"] 
    for camp in campsites 
    if camp["has_toilet"] and camp["price"] < 90
]

print(affordable_with_toilet)
# ['Camp A', 'Camp D']
```
</details>

---

### Exercise 3: Dictionary Operations ⭐⭐

**Question:** Create a function that merges two dictionaries of location prices. If a location exists in both, keep the lower price.

<details>
<summary>💡 Hint</summary>

Loop through both dictionaries, use `get()` to check if key exists, compare prices.
</details>

<details>
<summary>✅ Solution</summary>

```python
def merge_lowest_prices(prices1, prices2):
    """Merge two price dictionaries, keeping lowest price.
    
    Args:
        prices1 (dict): First price dictionary
        prices2 (dict): Second price dictionary
        
    Returns:
        dict: Merged with lowest prices
    """
    merged = prices1.copy()
    
    for location, price in prices2.items():
        if location in merged:
            merged[location] = min(merged[location], price)
        else:
            merged[location] = price
    
    return merged

# Test
prices1 = {"Chapada": 120, "Serra": 80, "Pico": 100}
prices2 = {"Chapada": 110, "Pantanal": 90, "Serra": 85}

result = merge_lowest_prices(prices1, prices2)
print(result)
# {'Chapada': 110, 'Serra': 80, 'Pico': 100, 'Pantanal': 90}
```
</details>

---

### Exercise 4: String Manipulation ⭐⭐

**Question:** Write a function that takes a location name and formats it for a URL slug (lowercase, spaces to hyphens, remove special characters).

Example: "Chapada Diamantina" → "chapada-diamantina"

<details>
<summary>✅ Solution</summary>

```python
import re

def create_slug(name):
    """Create URL slug from location name.
    
    Args:
        name (str): Location name
        
    Returns:
        str: URL-safe slug
    """
    # Convert to lowercase
    slug = name.lower()
    
    # Replace spaces with hyphens
    slug = slug.replace(" ", "-")
    
    # Remove special characters (keep letters, numbers, hyphens)
    slug = re.sub(r'[^a-z0-9-]', '', slug)
    
    # Remove multiple consecutive hyphens
    slug = re.sub(r'-+', '-', slug)
    
    # Strip hyphens from start/end
    slug = slug.strip('-')
    
    return slug

# Test
print(create_slug("Chapada Diamantina"))  # "chapada-diamantina"
print(create_slug("Serra dos Órgãos"))    # "serra-dos-orgos"
print(create_slug("Pico da Bandeira!!!")) # "pico-da-bandeira"
```
</details>

---

### Exercise 5: Functional Programming ⭐⭐⭐

**Question:** Given a list of campsite dictionaries, use `map()` and `filter()` to:
1. Filter campsites with price > R$70
2. Apply 15% tax to prices
3. Return list of dictionaries with updated prices

<details>
<summary>✅ Solution</summary>

```python
def apply_tax_to_expensive(campsites, min_price=70, tax_rate=0.15):
    """Filter expensive campsites and apply tax.
    
    Args:
        campsites (list): List of campsite dicts
        min_price (float): Minimum price threshold
        tax_rate (float): Tax rate to apply
        
    Returns:
        list: Filtered and updated campsites
    """
    # Filter expensive
    expensive = filter(lambda c: c["price"] > min_price, campsites)
    
    # Apply tax
    def apply_tax(campsite):
        updated = campsite.copy()
        updated["price"] = round(updated["price"] * (1 + tax_rate), 2)
        return updated
    
    return list(map(apply_tax, expensive))

# Test
campsites = [
    {"name": "Camp A", "price": 80},
    {"name": "Camp B", "price": 60},
    {"name": "Camp C", "price": 120},
]

result = apply_tax_to_expensive(campsites)
print(result)
# [{'name': 'Camp A', 'price': 92.0}, {'name': 'Camp C', 'price': 138.0}]
```
</details>

---

### Exercise 6: Working with Sets ⭐⭐

**Question:** Given lists of states visited by two travelers, find:
1. States visited by both travelers
2. States visited by only one traveler
3. All unique states visited

<details>
<summary>💡 Hint</summary>

Use set operations: intersection (&), symmetric difference (^), and union (|).
</details>

<details>
<summary>✅ Solution</summary>

```python
def analyze_travels(traveler1_states, traveler2_states):
    """Analyze travel patterns between two travelers.
    
    Args:
        traveler1_states (list): States visited by traveler 1
        traveler2_states (list): States visited by traveler 2
        
    Returns:
        dict: Analysis results
    """
    # Convert to sets
    set1 = set(traveler1_states)
    set2 = set(traveler2_states)
    
    return {
        "both_visited": set1 & set2,           # Intersection
        "only_one_visited": set1 ^ set2,       # Symmetric difference
        "all_unique_states": set1 | set2,      # Union
        "only_traveler1": set1 - set2,         # Difference
        "only_traveler2": set2 - set1          # Difference
    }

# Test
traveler1 = ["BA", "RJ", "MG", "SP", "RJ"]  # Note: duplicate RJ
traveler2 = ["RJ", "SP", "RS", "SC"]

result = analyze_travels(traveler1, traveler2)
print(result)
# {
#     'both_visited': {'RJ', 'SP'},
#     'only_one_visited': {'BA', 'MG', 'RS', 'SC'},
#     'all_unique_states': {'BA', 'RJ', 'MG', 'SP', 'RS', 'SC'},
#     'only_traveler1': {'BA', 'MG'},
#     'only_traveler2': {'RS', 'SC'}
# }
```
</details>

---

### Exercise 7: Data Transformation Pipeline ⭐⭐⭐

**Question:** Create a data processing pipeline that:
1. Filters campsites by minimum capacity (>= 20)
2. Adds 15% tax to prices
3. Sorts by price (ascending)
4. Returns only name and final price

<details>
<summary>💡 Hint</summary>

Chain operations: filter → map → sort → select fields. Can use list comprehension or functional approach.
</details>

<details>
<summary>✅ Solution</summary>

```python
def process_campsite_data(campsites, min_capacity=20, tax_rate=0.15):
    """Process campsite data through transformation pipeline.
    
    Args:
        campsites (list): List of campsite dictionaries
        min_capacity (int): Minimum capacity filter
        tax_rate (float): Tax rate to apply
        
    Returns:
        list: Processed campsite data
    """
    # Method 1: List comprehension (Pythonic)
    processed = [
        {
            "name": camp["name"],
            "final_price": round(camp["price"] * (1 + tax_rate), 2)
        }
        for camp in campsites
        if camp.get("capacity", 0) >= min_capacity
    ]
    
    # Sort by price
    processed.sort(key=lambda x: x["final_price"])
    
    return processed

# Test
campsites = [
    {"name": "Camping Vale", "price": 120, "capacity": 30},
    {"name": "Trilha Azul", "price": 60, "capacity": 15},  # Filtered out
    {"name": "Serra Camp", "price": 80, "capacity": 25},
    {"name": "Cachoeira", "price": 100, "capacity": 20},
]

result = process_campsite_data(campsites)
print(result)
# [
#     {'name': 'Serra Camp', 'final_price': 92.0},
#     {'name': 'Cachoeira', 'final_price': 115.0},
#     {'name': 'Camping Vale', 'final_price': 138.0}
# ]

# Method 2: Functional approach
def process_functional(campsites, min_capacity=20, tax_rate=0.15):
    """Same pipeline using functional programming style."""
    from operator import itemgetter
    
    # Filter by capacity
    filtered = filter(lambda c: c.get("capacity", 0) >= min_capacity, campsites)
    
    # Transform (add tax)
    transformed = map(
        lambda c: {
            "name": c["name"],
            "final_price": round(c["price"] * (1 + tax_rate), 2)
        },
        filtered
    )
    
    # Sort by price
    return sorted(transformed, key=itemgetter("final_price"))
```
</details>

---

### Exercise 8: Nested Data Structures ⭐⭐⭐

**Question:** Given nested booking data, calculate total revenue per state.

<details>
<summary>💡 Hint</summary>

Use nested loops or comprehensions. Aggregate using dictionary to track totals per state.
</details>

<details>
<summary>✅ Solution</summary>

```python
def calculate_revenue_by_state(bookings):
    """Calculate total revenue grouped by state.
    
    Args:
        bookings (list): List of booking dictionaries with nested location data
        
    Returns:
        dict: Total revenue per state, sorted by revenue
    """
    revenue_by_state = {}
    
    for booking in bookings:
        state = booking["location"]["state"]
        revenue = booking["price"] * booking["nights"]
        
        # Add to state total
        if state in revenue_by_state:
            revenue_by_state[state] += revenue
        else:
            revenue_by_state[state] = revenue
    
    # Sort by revenue (descending)
    sorted_revenue = dict(
        sorted(revenue_by_state.items(), key=lambda x: x[1], reverse=True)
    )
    
    return sorted_revenue

# Test
bookings = [
    {
        "id": 1,
        "location": {"name": "Chapada Diamantina", "state": "BA"},
        "price": 120,
        "nights": 3
    },
    {
        "id": 2,
        "location": {"name": "Serra dos Órgãos", "state": "RJ"},
        "price": 80,
        "nights": 2
    },
    {
        "id": 3,
        "location": {"name": "Vale do Capão", "state": "BA"},
        "price": 100,
        "nights": 4
    },
    {
        "id": 4,
        "location": {"name": "Pico da Bandeira", "state": "MG"},
        "price": 90,
        "nights": 2
    }
]

result = calculate_revenue_by_state(bookings)
print(result)
# {'BA': 760.0, 'MG': 180.0, 'RJ': 160.0}

# Alternative with defaultdict (cleaner)
from collections import defaultdict

def calculate_revenue_defaultdict(bookings):
    """Same function using defaultdict for cleaner code."""
    revenue_by_state = defaultdict(float)
    
    for booking in bookings:
        state = booking["location"]["state"]
        revenue = booking["price"] * booking["nights"]
        revenue_by_state[state] += revenue  # No need to check if exists!
    
    # Sort and convert back to regular dict
    return dict(sorted(revenue_by_state.items(), key=lambda x: x[1], reverse=True))
```
</details>

---

### Exercise 9: String Parsing and Validation ⭐⭐⭐

**Question:** Parse and validate Brazilian phone numbers. Format: `(DD) 9XXXX-XXXX` where DD is area code.

<details>
<summary>💡 Hint</summary>

Use string methods like `replace()`, `strip()`, `isdigit()`. Check length and format.
</details>

<details>
<summary>✅ Solution</summary>

```python
def parse_phone_number(phone):
    """Parse and validate Brazilian phone number.
    
    Args:
        phone (str): Phone number string
        
    Returns:
        dict: Parsed components or error
    """
    # Remove common formatting characters
    cleaned = phone.replace("(", "").replace(")", "").replace("-", "").replace(" ", "")
    
    # Validate: should be digits only
    if not cleaned.isdigit():
        return {"valid": False, "error": "Contains non-numeric characters"}
    
    # Validate: should be 10 or 11 digits (with area code)
    if len(cleaned) not in [10, 11]:
        return {"valid": False, "error": f"Invalid length: {len(cleaned)} digits"}
    
    # Parse components
    if len(cleaned) == 11:
        area_code = cleaned[:2]
        prefix = cleaned[2:7]  # 9XXXX
        suffix = cleaned[7:]   # XXXX
        
        # Validate mobile number (starts with 9)
        if not prefix.startswith('9'):
            return {"valid": False, "error": "Mobile number must start with 9"}
    else:
        # Landline (10 digits)
        area_code = cleaned[:2]
        prefix = cleaned[2:6]
        suffix = cleaned[6:]
    
    return {
        "valid": True,
        "area_code": area_code,
        "prefix": prefix,
        "suffix": suffix,
        "formatted": f"({area_code}) {prefix}-{suffix}",
        "type": "mobile" if len(cleaned) == 11 else "landline"
    }

# Test
test_numbers = [
    "(71) 99876-5432",
    "71998765432",
    "(21) 3456-7890",
    "(11) 8888-9999",  # Invalid: mobile without 9
    "invalid123",
]

for number in test_numbers:
    result = parse_phone_number(number)
    print(f"{number}: {result}")

# Output:
# (71) 99876-5432: {'valid': True, 'area_code': '71', 'prefix': '99876', 'suffix': '5432', 'formatted': '(71) 99876-5432', 'type': 'mobile'}
# 71998765432: {'valid': True, 'area_code': '71', 'prefix': '99876', 'suffix': '5432', 'formatted': '(71) 99876-5432', 'type': 'mobile'}
# (21) 3456-7890: {'valid': True, 'area_code': '21', 'prefix': '3456', 'suffix': '7890', 'formatted': '(21) 3456-7890', 'type': 'landline'}
# (11) 8888-9999: {'valid': False, 'error': 'Mobile number must start with 9'}
# invalid123: {'valid': False, 'error': 'Invalid length: 10 digits'}
```
</details>

---

### Exercise 10: Advanced List Comprehension ⭐⭐⭐

**Question:** Create a multiplication table (1-10) as a nested list using list comprehension.

<details>
<summary>💡 Hint</summary>

Use nested list comprehension: `[[expression for inner] for outer]`.
</details>

<details>
<summary>✅ Solution</summary>

```python
def create_multiplication_table(size=10):
    """Create multiplication table using list comprehension.
    
    Args:
        size (int): Size of the table (default 10x10)
        
    Returns:
        list: Nested list representing multiplication table
    """
    # Method 1: List comprehension
    table = [[i * j for j in range(1, size + 1)] for i in range(1, size + 1)]
    
    return table

# Display function
def display_table(table):
    """Pretty print multiplication table."""
    size = len(table)
    
    # Header
    print("    ", end="")
    for i in range(1, size + 1):
        print(f"{i:4}", end="")
    print("\n" + "=" * (size * 4 + 5))
    
    # Rows
    for i, row in enumerate(table, start=1):
        print(f"{i:2} |", end="")
        for value in row:
            print(f"{value:4}", end="")
        print()

# Test
table = create_multiplication_table(10)
display_table(table)

# Output:
#        1   2   3   4   5   6   7   8   9  10
# =============================================
#  1 |   1   2   3   4   5   6   7   8   9  10
#  2 |   2   4   6   8  10  12  14  16  18  20
#  3 |   3   6   9  12  15  18  21  24  27  30
# ... etc

# Bonus: Create as dictionary for easy lookup
def create_table_dict(size=10):
    """Create multiplication table as dictionary."""
    return {
        (i, j): i * j
        for i in range(1, size + 1)
        for j in range(1, size + 1)
    }

table_dict = create_table_dict(10)
print(table_dict[(7, 8)])  # 56
```
</details>

---

## 🧠 Deep Dive: Understanding Python Memory and Performance

### Mutable vs Immutable - Why It Matters

Understanding mutability is crucial for avoiding bugs and writing efficient code.

#### Immutable Types (Cannot Change After Creation)

```python
# Strings are immutable
text = "Hello"
text_upper = text.upper()  # Creates NEW string
print(text)       # "Hello" (unchanged)
print(text_upper) # "HELLO" (new string)

# Numbers are immutable
x = 5
y = x  # y gets the VALUE 5, not a reference
x = 10
print(y)  # Still 5 (not affected by x changing)

# Tuples are immutable
coords = (10, 20)
# coords[0] = 15  # TypeError! Can't modify tuple
```

#### Mutable Types (Can Change After Creation)

```python
# Lists are mutable
numbers = [1, 2, 3]
numbers_ref = numbers  # Both point to SAME list
numbers.append(4)
print(numbers)      # [1, 2, 3, 4]
print(numbers_ref)  # [1, 2, 3, 4] - SAME list!

# To create a copy:
numbers_copy = numbers.copy()  # or list(numbers) or numbers[:]
numbers_copy.append(5)
print(numbers)       # [1, 2, 3, 4] (unchanged)
print(numbers_copy)  # [1, 2, 3, 4, 5]

# Dictionaries are mutable
data = {"price": 100}
data_ref = data  # Both point to SAME dictionary
data["price"] = 200
print(data_ref["price"])  # 200 (same dictionary!)

# To create a copy:
data_copy = data.copy()
data_copy["price"] = 300
print(data["price"])       # 200 (unchanged)
print(data_copy["price"])  # 300
```

### List Comprehension vs Map/Filter - Performance

```python
import time

# Sample data
numbers = list(range(1000000))

# Method 1: List comprehension
start = time.time()
squares1 = [x**2 for x in numbers]
time1 = time.time() - start
print(f"List comprehension: {time1:.4f} seconds")

# Method 2: map()
start = time.time()
squares2 = list(map(lambda x: x**2, numbers))
time2 = time.time() - start
print(f"Map function: {time2:.4f} seconds")

# Method 3: Traditional loop
start = time.time()
squares3 = []
for x in numbers:
    squares3.append(x**2)
time3 = time.time() - start
print(f"Traditional loop: {time3:.4f} seconds")

# Results (approximate):
# List comprehension: ~0.12 seconds (fastest)
# Map function: ~0.14 seconds
# Traditional loop: ~0.18 seconds
```

**Key Insight:** List comprehensions are usually fastest because they're optimized at the C level!

### When to Use What

| Task | Best Choice | Reason |
|------|-------------|---------|
| Simple transformation | List comprehension | Most readable, fastest |
| Complex transformation | Regular function + loop | More readable for complex logic |
| Filtering with transform | List comprehension | `[f(x) for x in items if condition]` |
| Multiple operations | Separate steps | Easier to debug and understand |
| Working with files | Generator expression | Memory efficient for large files |
| Chaining operations | Consider pandas/polars | Built for data transformation |

---

## 🎓 Common Python Patterns for Data Engineering

### Pattern 1: Safe Dictionary Access

```python
# Bad: Can raise KeyError
price = campsite["price"]

# Good: Returns None if key missing
price = campsite.get("price")

# Better: Provide default value
price = campsite.get("price", 0)

# Best for multiple fields: Use .get() with dict comprehension
safe_data = {
    "price": campsite.get("price", 0),
    "capacity": campsite.get("capacity", 0),
    "name": campsite.get("name", "Unknown")
}
```

### Pattern 2: Checking Empty Collections

```python
# Bad: Explicit length check
if len(my_list) == 0:
    print("Empty")

# Good: Direct boolean check (Pythonic!)
if not my_list:
    print("Empty")

# Also works for:
if not my_dict:  # Empty dictionary
if not my_string:  # Empty string
if not my_set:  # Empty set
```

### Pattern 3: Swapping Values

```python
# Bad: Using temporary variable
temp = a
a = b
b = temp

# Good: Pythonic tuple unpacking
a, b = b, a
```

### Pattern 4: Iterating with Index

```python
locations = ["BA", "RJ", "MG"]

# Bad: Manual index tracking
for i in range(len(locations)):
    print(f"{i}: {locations[i]}")

# Good: Use enumerate
for i, location in enumerate(locations):
    print(f"{i}: {location}")
```

### Pattern 5: Building Strings

```python
parts = ["Camping", "Vale", "do", "Pati"]

# Bad: String concatenation in loop (slow!)
result = ""
for part in parts:
    result += part + " "

# Good: Use join (much faster!)
result = " ".join(parts)
```

### Pattern 6: Conditional Assignment

```python
# Bad: If-else for simple assignment
if price > 100:
    category = "expensive"
else:
    category = "affordable"

# Good: Ternary operator
category = "expensive" if price > 100 else "affordable"
```

---

## 🎯 Key Takeaways

✅ **Variables**: Use descriptive names, understand mutable vs immutable  
✅ **Control Flow**: if/elif/else, for/while loops, break/continue  
✅ **Functions**: Reusable code blocks with clear parameters  
✅ **List Comprehensions**: Concise, Pythonic way to transform lists  
✅ **Dictionaries**: Key-value storage for structured data  
✅ **Strings**: Rich manipulation methods, f-strings for formatting  
✅ **Built-ins**: Leverage Python's powerful standard functions  

---

## 🚀 Next Steps

Great job! You've reviewed Python fundamentals. Next up:

**Lesson 2: Working with Files & Data Formats**
- CSV file handling
- JSON parsing
- Parquet with pyarrow
- Context managers
- Practical file operations for data engineering

---

## 📖 Additional Resources

- [Python Style Guide (PEP 8)](https://pep8.org/)
- [Python Built-in Functions](https://docs.python.org/3/library/functions.html)
- [List Comprehensions Explained](https://realpython.com/list-comprehension-python/)
- [Dictionary Methods](https://docs.python.org/3/tutorial/datastructures.html#dictionaries)

---

**Estimated Completion Time**: 2 hours  
**Difficulty**: ⭐⭐ Beginner to Intermediate  
**Prerequisites**: Basic programming knowledge

*Write clean, Pythonic code! 🐍*
