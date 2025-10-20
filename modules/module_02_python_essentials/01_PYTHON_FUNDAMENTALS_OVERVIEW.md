# Lesson 1: Python Fundamentals Review - Complete Overview

## 📖 Introduction

Welcome to **Lesson 1: Python Fundamentals Review**! This lesson provides a comprehensive review of core Python concepts essential for data engineering. Whether you're refreshing your knowledge or solidifying the basics, this lesson ensures you have a strong foundation for the advanced topics ahead.

**Why This Lesson Matters:**
- **Foundation for Everything** - All data engineering builds on these fundamentals
- **Professional Code** - Learn to write clean, Pythonic code from day one
- **Interview Ready** - Master the concepts technical interviews test
- **Real-World Skills** - Apply Python to actual data engineering scenarios
- **Best Practices** - Learn idiomatic Python patterns used by professionals

---

## 📊 Lesson Statistics

| Metric | Value |
|--------|-------|
| **Total Lines** | 2,845 lines |
| **Sections** | 8 comprehensive sections |
| **Code Examples** | 100+ working examples |
| **Practice Exercises** | 10 with complete solutions |
| **Estimated Study Time** | 6-8 hours |
| **Difficulty Level** | Beginner to Intermediate |
| **Prerequisites** | Basic programming knowledge |

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

✅ **Data Types & Variables:**
- Understand and use integers, floats, strings, and booleans
- Know when to use each data type
- Check types with `type()` and `isinstance()`
- Convert between types with `int()`, `float()`, `str()`
- Work with collections: lists, tuples, dictionaries, sets
- Choose the right collection for each scenario

✅ **Control Flow:**
- Write clear if/elif/else statements
- Use comparison and logical operators correctly
- Master for loops and while loops
- Use enumerate() and range() effectively
- Control loop flow with break and continue
- Write concise ternary operators

✅ **Functions:**
- Define functions with parameters and return values
- Use default parameters effectively
- Master *args and **kwargs for flexible functions
- Write lambda functions for simple operations
- Understand function scope and namespaces
- Create reusable, well-documented functions

✅ **Data Structures:**
- Perform essential list operations (append, extend, slicing)
- Write efficient list comprehensions
- Master dictionary operations and methods
- Use sets for uniqueness and fast lookups
- Choose between lists, tuples, dicts, and sets appropriately
- Work with nested data structures

✅ **String Operations:**
- Format strings with f-strings, format(), and %
- Use string methods (strip, split, join, replace)
- Handle multiline strings
- Work with string indexing and slicing
- Validate and clean text data

✅ **Built-in Functions:**
- Use len(), sum(), min(), max() effectively
- Master map(), filter(), and zip()
- Work with sorted() and reversed()
- Use any(), all(), and enumerate()
- Apply functional programming concepts

---

## 📚 Lesson Structure

### **Section 1: Variables and Data Types** (~362 lines)

**What You'll Learn:**
- How variables work in Python's dynamic type system
- The four fundamental data types: int, float, str, bool
- Type checking and type conversion
- Collections overview: lists, tuples, dicts, sets

**Key Topics:**

**1.1 Basic Data Types:**
- **Integers (int)**: Whole numbers for counting, IDs, quantities
  ```python
  campsite_capacity = 50
  year_established = 1985
  ```
- **Floats (float)**: Decimal numbers for prices, coordinates, measurements
  ```python
  price_per_night = 78.50
  latitude = -22.9519
  ```
- **Strings (str)**: Text data with single, double, or triple quotes
  ```python
  location_name = "Chapada Diamantina"
  description = """Multi-line text"""
  ```
- **Booleans (bool)**: True/False values for conditions
  ```python
  is_available = True
  has_wifi = False
  ```

**1.2 Type Checking and Conversion:**
- `type()` function to check data types
- `isinstance()` for type validation
- Type conversion: `int()`, `float()`, `str()`, `bool()`
- Common conversion pitfalls and how to avoid them

**1.3 Collections - Storing Multiple Values:**
- **Lists**: Ordered, mutable sequences `[1, 2, 3]`
- **Tuples**: Ordered, immutable sequences `(1, 2, 3)`
- **Dictionaries**: Key-value pairs `{"name": "João", "age": 30}`
- **Sets**: Unique, unordered collections `{1, 2, 3}`

**Practical Skills:**
- Choose appropriate data types for different scenarios
- Convert between types safely
- Understand mutability vs immutability
- Select the right collection type for your use case

---

### **Section 2: Control Flow** (~350 lines)

**What You'll Learn:**
- Make decisions with if/elif/else statements
- Use comparison and logical operators
- Write efficient loops with for and while
- Control loop execution with break and continue

**Key Topics:**

**2.1 If/Elif/Else Statements:**
- Basic if syntax and indentation rules
- Comparison operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical operators: `and`, `or`, `not`
- Multiple conditions with elif
- Nested if statements (when and when not to use them)

**2.2 Ternary Operator:**
- One-line if/else for simple conditions
- Syntax: `value_if_true if condition else value_if_false`
- When to use vs regular if/else
- Readability considerations

**2.3 For Loops:**
- Iterating over lists, strings, ranges
- Using `enumerate()` to get index and value
- Using `range()` for number sequences
- Nested loops for matrix/grid operations
- Loop best practices

**2.4 While Loops & Loop Control:**
- While loop syntax and use cases
- Infinite loops and how to avoid them
- `break` to exit loops early
- `continue` to skip to next iteration
- Choosing between for and while loops

**Practical Skills:**
- Write clean, readable conditional logic
- Choose the right loop type for each situation
- Use enumerate() instead of manual counters
- Control loop flow effectively
- Avoid common loop pitfalls

---

### **Section 3: Functions** (~261 lines)

**What You'll Learn:**
- Define reusable functions with clear purposes
- Use parameters and return values effectively
- Master default parameters and variable arguments
- Write lambda functions for simple operations

**Key Topics:**

**3.1 Basic Function Definition:**
- Function syntax with `def` keyword
- Parameters and arguments
- Return values vs print()
- Docstrings for documentation
- Function naming conventions

**3.2 Default Parameters:**
- Setting default values for optional parameters
- Calling functions with and without defaults
- Best practices: defaults at the end, immutable defaults
- When to use default parameters

**3.3 Variable Arguments (*args and **kwargs):**
- `*args` for variable number of positional arguments
- `**kwargs` for variable number of keyword arguments
- Combining regular params, *args, and **kwargs
- Unpacking with * and **
- Real-world use cases

**3.4 Lambda Functions:**
- Syntax: `lambda arguments: expression`
- When to use lambda vs regular functions
- Common use cases with map(), filter(), sorted()
- Limitations of lambda functions
- Readability considerations

**Practical Skills:**
- Write functions that do one thing well
- Use descriptive function and parameter names
- Document functions with docstrings
- Handle flexible inputs with *args and **kwargs
- Apply lambda functions appropriately

---

### **Section 4: Lists and List Comprehensions** (~227 lines)

**What You'll Learn:**
- Perform essential list operations
- Master list comprehensions for concise code
- Understand when comprehensions improve readability
- Work with nested comprehensions

**Key Topics:**

**4.1 Essential List Operations:**
- Creating lists with `[]` and `list()`
- Accessing elements with indexing (positive and negative)
- Slicing: `list[start:end:step]`
- Modifying: append(), extend(), insert(), remove(), pop()
- Checking membership with `in`
- List methods: sort(), reverse(), count(), index()

**4.2 List Comprehensions:**
- Basic syntax: `[expression for item in iterable]`
- With conditions: `[expr for item in iterable if condition]`
- Transforming data efficiently
- Filtering with comprehensions
- Nested list comprehensions
- Comprehensions vs traditional loops (readability)

**Real-World Examples:**
- Data transformation pipelines
- Filtering valid records
- Extracting fields from dictionaries
- Building lookup tables
- Data cleaning operations

**Practical Skills:**
- Manipulate lists efficiently
- Write readable list comprehensions
- Choose comprehensions vs loops based on clarity
- Chain operations for data transformations
- Avoid overly complex comprehensions

---

### **Section 5: Dictionaries and Sets** (~310 lines)

**What You'll Learn:**
- Master dictionary operations for key-value data
- Use sets for uniqueness and fast lookups
- Choose between lists, dicts, and sets appropriately
- Work with nested dictionaries

**Key Topics:**

**5.1 Dictionary Basics:**
- Creating dictionaries with `{}` and `dict()`
- Accessing values with keys: `dict[key]`
- Safe access with `.get(key, default)`
- Adding and updating key-value pairs
- Removing items with `del` and `.pop()`
- Checking key existence with `in`

**5.2 Dictionary Methods:**
- `.keys()`, `.values()`, `.items()` for iteration
- `.update()` to merge dictionaries
- `.setdefault()` for default values
- Dictionary comprehensions
- Nested dictionaries for structured data

**5.3 Sets - Unique Collections:**
- Creating sets with `{}` or `set()`
- Set operations: union, intersection, difference
- Adding elements with `.add()`
- Removing duplicates from lists
- Fast membership testing (O(1) lookup)
- When to use sets vs lists

**Real-World Applications:**
- Storing user profiles (dictionaries)
- Configuration management
- Removing duplicate records (sets)
- Data validation and lookups
- Counting occurrences

**Practical Skills:**
- Choose dictionaries for key-value relationships
- Use `.get()` to avoid KeyError
- Iterate over dictionary items efficiently
- Use sets to eliminate duplicates
- Leverage sets for fast membership testing

---

### **Section 6: String Manipulation** (~370 lines)

**What You'll Learn:**
- Format strings with modern f-strings
- Use string methods for cleaning and transformation
- Work with multiline and raw strings
- Validate and sanitize text data

**Key Topics:**

**6.1 String Formatting:**
- **f-strings** (preferred): `f"Hello {name}"`
- `.format()` method: `"Hello {}".format(name)`
- % formatting (legacy): `"Hello %s" % name`
- Formatting numbers: decimals, padding, alignment
- Multiline f-strings

**6.2 Essential String Methods:**
- **Cleaning**: `.strip()`, `.lstrip()`, `.rstrip()`
- **Case**: `.upper()`, `.lower()`, `.title()`, `.capitalize()`
- **Searching**: `.startswith()`, `.endswith()`, `.find()`, `.index()`
- **Splitting**: `.split()` for tokenization
- **Joining**: `" ".join(list)` to combine strings
- **Replacing**: `.replace(old, new)`

**6.3 String Slicing and Indexing:**
- Accessing characters by position
- Slicing substrings: `string[start:end]`
- Negative indexing from the end
- Step slicing: `string[::2]` for every 2nd char
- Reversing strings: `string[::-1]`

**Real-World Applications:**
- Data cleaning: removing whitespace, standardizing case
- Parsing CSV and log files
- Email and phone validation
- Building SQL queries safely
- Text preprocessing for analysis

**Practical Skills:**
- Use f-strings for all string formatting
- Clean user input data
- Parse and extract information from text
- Build dynamic messages and queries
- Validate text format and content

---

### **Section 7: Built-in Functions** (~215 lines)

**What You'll Learn:**
- Use Python's powerful built-in functions
- Apply functional programming with map, filter
- Work with iterables efficiently
- Understand when to use built-ins vs libraries

**Key Topics:**

**7.1 Common Built-in Functions:**
- **Length**: `len()` for size of collections
- **Math**: `sum()`, `min()`, `max()`, `abs()`
- **Conversion**: `int()`, `float()`, `str()`, `list()`, `set()`, `dict()`
- **Range**: `range(start, stop, step)` for sequences
- **Sorting**: `sorted()` returns new sorted list
- **Reversing**: `reversed()` returns iterator
- **Enumeration**: `enumerate()` for index + value

**7.2 Functional Programming:**
- **map()**: Apply function to each item
  ```python
  prices_usd = list(map(lambda x: x * 5.5, prices_brl))
  ```
- **filter()**: Keep items matching condition
  ```python
  adults = list(filter(lambda age: age >= 18, ages))
  ```
- **zip()**: Combine multiple iterables
  ```python
  for name, price in zip(names, prices):
  ```

**7.3 Boolean Functions:**
- `any()`: True if any element is True
- `all()`: True if all elements are True
- Use cases for validation

**Practical Skills:**
- Choose the right built-in function for each task
- Use map() and filter() for data transformations
- Combine zip() with loops for parallel iteration
- Apply any() and all() for validation
- Write functional-style Python code

---

### **Section 8: Practice Exercises** (~750 lines)

**What You'll Learn:**
- Apply all concepts to real-world problems
- Build complete data processing functions
- Practice with detailed solutions
- Develop problem-solving strategies

**Practice Problems:**

**Exercise 1: Data Validation**
- Validate campsite booking data
- Check required fields exist
- Validate data types and ranges
- Return clear error messages

**Exercise 2: Data Transformation**
- Transform list of dictionaries
- Calculate derived fields
- Filter based on criteria
- Apply discounts and business rules

**Exercise 3: Data Analysis**
- Analyze sales by category
- Calculate totals and averages
- Find top performers
- Generate summary statistics

**Exercise 4: Text Processing**
- Clean and normalize text data
- Extract information with parsing
- Validate formats (email, phone)
- Build formatted output

**Exercise 5: Data Aggregation**
- Group data by keys
- Calculate aggregates (sum, avg, count)
- Build summary dictionaries
- Handle missing data

**Exercise 6-10: Additional Challenges**
- List comprehension challenges
- Dictionary manipulation tasks
- Function composition problems
- Real-world data scenarios
- Integration exercises

**Each Exercise Includes:**
- Clear problem description
- Expected input and output
- Hints and approach suggestions
- Complete working solution
- Explanation of solution approach
- Alternative solutions when applicable

**Practical Skills:**
- Break down complex problems
- Write solution step-by-step
- Test edge cases
- Refactor for clarity
- Debug systematically

---

## 🛠️ Technical Requirements

**Python Version:**
- Python 3.8+ (examples use Python 3.10+ features where applicable)
- No external libraries required - pure Python standard library

**Development Environment:**
- Python interpreter (REPL) for testing snippets
- Text editor or IDE (VS Code, PyCharm, or similar)
- Terminal/command line access

**Standard Library Usage:**
```python
# This lesson uses only built-in Python features
# No pip install required!

# Built-in functions covered:
from typing import List, Dict, Set, Tuple  # Type hints (optional)
import math  # For mathematical operations
import re  # For regex (mentioned, not required)
```

**System Requirements:**
- Any operating system (Windows, macOS, Linux)
- 100MB free disk space
- Internet for documentation access (optional)

---

## 📖 How to Use This Lesson

### **Recommended Approach:**

1. **Read Sequentially** - Concepts build on each other
2. **Type Every Example** - Don't copy-paste, type to learn
3. **Experiment** - Modify examples to see what happens
4. **Test in REPL** - Use Python interpreter to try code immediately
5. **Complete Exercises** - Practice is essential for mastery

### **Study Schedule:**

**Day 1: Data Types & Control Flow (Sections 1-2)**
- Morning: Variables, data types, type conversion
- Afternoon: If/else, loops, control structures
- Practice: Write simple decision and loop programs

**Day 2: Functions & Lists (Sections 3-4)**
- Morning: Function definitions, parameters, returns
- Afternoon: List operations and comprehensions
- Practice: Write utility functions

**Day 3: Dictionaries, Sets & Strings (Sections 5-6)**
- Morning: Dictionaries, sets, and their methods
- Afternoon: String manipulation and formatting
- Practice: Data cleaning and transformation

**Day 4: Built-ins & Practice (Sections 7-8)**
- Morning: Built-in functions and functional programming
- Afternoon: Practice exercises 1-5
- Evening: Practice exercises 6-10

### **For Quick Reference:**

Jump to specific sections when you need to:
- **Check data types?** → Section 1
- **Write a loop?** → Section 2
- **Create a function?** → Section 3
- **Transform a list?** → Section 4
- **Work with dictionaries?** → Section 5
- **Format strings?** → Section 6
- **Use built-ins?** → Section 7
- **See examples?** → Section 8

---

## 💡 Key Takeaways

### **Python Fundamentals:**

1. **Dynamic Typing is Powerful**
   - Variables can change types
   - Use `type()` to check when needed
   - Type hints help document intent

2. **Choose the Right Collection**
   - Lists: Ordered, mutable sequences
   - Tuples: Immutable sequences
   - Dicts: Key-value mappings
   - Sets: Unique values, fast lookup

3. **Functions Make Code Reusable**
   - Do one thing well
   - Use descriptive names
   - Document with docstrings
   - Return values, don't just print

4. **Comprehensions are Pythonic**
   - More concise than loops
   - But don't sacrifice readability
   - Use for simple transformations
   - Avoid overly complex nesting

### **Best Practices:**

1. **Write Readable Code**
   - Use meaningful variable names
   - Follow PEP 8 style guide
   - Add comments for complex logic
   - Keep functions short and focused

2. **Use Modern Python Features**
   - f-strings for formatting
   - enumerate() instead of range(len())
   - .get() for safe dictionary access
   - List comprehensions for transformations

3. **Think About Data Types**
   - Choose appropriate types from the start
   - Validate input data
   - Convert types explicitly
   - Handle None and empty collections

4. **Practice Functional Thinking**
   - Use map(), filter() when clear
   - Leverage built-in functions
   - Prefer immutability when possible
   - Compose small functions

---

## 🎯 Real-World Applications

This lesson's concepts are used constantly in data engineering:

**Data Validation:**
- Check types before processing
- Validate ranges and formats
- Handle missing data gracefully
- Use dictionaries for validation rules

**Data Transformation:**
- List comprehensions for batch operations
- Functions for reusable transformations
- String methods for cleaning text
- Type conversion for standardization

**Data Analysis:**
- Dictionaries for aggregations
- Built-in functions for statistics
- Sets for deduplication
- Loops for iteration

**Configuration & Setup:**
- Dictionaries for config data
- Functions for environment setup
- String formatting for messages
- Control flow for logic

**Examples from Data Engineering:**
```python
# Validating input data
def validate_record(record: dict) -> bool:
    return all([
        'id' in record,
        isinstance(record.get('age'), int),
        record.get('age', 0) >= 0
    ])

# Transforming data
def clean_names(names: List[str]) -> List[str]:
    return [name.strip().title() for name in names if name.strip()]

# Aggregating results
def total_by_category(sales: List[dict]) -> dict:
    totals = {}
    for sale in sales:
        category = sale['category']
        totals[category] = totals.get(category, 0) + sale['amount']
    return totals
```

---

## ✅ Self-Assessment Checklist

After completing this lesson, you should be able to:

### **Data Types:**
- [ ] Explain the difference between int, float, str, bool
- [ ] Convert between types safely
- [ ] Choose appropriate collection types
- [ ] Work with nested data structures

### **Control Flow:**
- [ ] Write multi-condition if/elif/else statements
- [ ] Use for loops with enumerate() and range()
- [ ] Control loops with break and continue
- [ ] Choose between for and while loops

### **Functions:**
- [ ] Define functions with multiple parameters
- [ ] Use default parameters effectively
- [ ] Understand *args and **kwargs
- [ ] Write lambda functions for simple cases

### **Data Structures:**
- [ ] Perform all basic list operations
- [ ] Write clear list comprehensions
- [ ] Use dictionary methods effectively
- [ ] Apply sets for uniqueness and fast lookup

### **Strings:**
- [ ] Format strings with f-strings
- [ ] Use string methods for cleaning
- [ ] Split and join text data
- [ ] Validate string formats

### **Built-ins:**
- [ ] Use len(), sum(), min(), max() appropriately
- [ ] Apply map() and filter() to collections
- [ ] Understand any() and all()
- [ ] Use enumerate() and zip() in loops

### **Practice:**
- [ ] Complete all 10 practice exercises
- [ ] Understand the solution approach
- [ ] Identify alternative solutions
- [ ] Apply concepts to own problems

---

## 🚀 Next Steps

### **After This Lesson:**

1. **Move to Lesson 2: Working with Files & Data Formats**
   - Apply fundamentals to file I/O
   - Work with CSV, JSON, Parquet
   - Read and write data files
   - Handle file operations

2. **Practice More:**
   - Solve problems on LeetCode (Easy level)
   - Practice list/dict problems on HackerRank
   - Build simple scripts for daily tasks
   - Refactor old code using new patterns

3. **Deepen Your Knowledge:**
   - Read Python's official tutorial
   - Study PEP 8 style guide
   - Learn about Python's data model
   - Explore type hints (typing module)

4. **Build Projects:**
   - Data cleaning script for CSV files
   - Simple data validation tool
   - Text processing utility
   - Configuration file parser

### **Skills to Develop:**
- Write more Pythonic code
- Think in terms of transformations
- Choose the right tool for each job
- Debug systematically

---

## 📚 Additional Resources

### **Official Documentation:**
- [Python Tutorial](https://docs.python.org/3/tutorial/)
- [Python Built-in Functions](https://docs.python.org/3/library/functions.html)
- [Python Data Structures](https://docs.python.org/3/tutorial/datastructures.html)
- [PEP 8 Style Guide](https://pep8.org/)

### **Recommended Reading:**
- "Fluent Python" by Luciano Ramalho (comprehensive)
- "Python Tricks" by Dan Bader (practical tips)
- "Effective Python" by Brett Slatkin (best practices)
- "Automate the Boring Stuff" by Al Sweigart (beginner-friendly)

### **Interactive Learning:**
- [Python.org Tutorial](https://docs.python.org/3/tutorial/index.html)
- [Real Python](https://realpython.com/) - Excellent tutorials
- [Python Tutor](http://pythontutor.com/) - Visualize code execution
- [Exercism Python Track](https://exercism.org/tracks/python) - Practice exercises

### **Video Resources:**
- Corey Schafer's Python Tutorials (YouTube)
- Real Python's video courses
- Python official YouTube channel

---

## 🎓 Learning Verification

### **Quick Quiz:**

Test your understanding:

1. What's the difference between a list and a tuple?
2. When should you use .get() instead of [] for dictionaries?
3. What does enumerate() return?
4. How do you write a list comprehension with a filter?
5. What's the difference between *args and **kwargs?
6. When should you use a set instead of a list?
7. What's the modern way to format strings in Python?
8. What does the any() function do?

**Answers are throughout the lesson!**

### **Hands-On Check:**

Can you write these from memory?

```python
# 1. A function that takes any number of numbers and returns their average
def average(*numbers):
    return sum(numbers) / len(numbers) if numbers else 0

# 2. A list comprehension that squares even numbers from 1-10
squares = [x**2 for x in range(1, 11) if x % 2 == 0]

# 3. A dictionary comprehension that maps names to lengths
name_lengths = {name: len(name) for name in names}

# 4. Using map() to convert strings to integers
numbers = list(map(int, string_numbers))
```

---

## 💬 Need Help?

If you're stuck or have questions:

1. **Re-read the section** - Examples are detailed
2. **Try in Python REPL** - Test code immediately
3. **Check type with type()** - Understand data types
4. **Print intermediate values** - Debug step-by-step
5. **Review exercises** - Solutions show best practices
6. **Consult documentation** - Python docs are excellent

**Common Mistakes:**
- Forgetting colons `:` after if/for/def
- Indentation errors (use 4 spaces)
- Using `=` instead of `==` for comparison
- Mutating lists while iterating
- Not handling empty collections

---

## 🎉 Congratulations!

You've completed Python Fundamentals Review! These concepts form the foundation of all Python programming, especially in data engineering.

**You now know:**
- All core Python data types and when to use them
- How to write clean control flow and functions
- Efficient data structure manipulation
- Modern Python idioms and best practices
- How to solve problems with Python's built-ins

**Remember:**
- Practice makes perfect - write code daily
- Readable code is more important than clever code
- Python has a tool for most common tasks
- The standard library is powerful - learn it well

**Keep coding, keep learning!** 🚀

---

**Ready to continue?**  
**→ [Open 01_python_fundamentals.md](01_python_fundamentals.md) to dive deep into each concept!**

---

*Last Updated: October 20, 2025*  
*Total Content: 2,845 lines of comprehensive instruction*  
*Difficulty: Beginner to Intermediate*

