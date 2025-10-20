# Lesson 6: Testing with pytest

## 📚 Table of Contents

1. [Introduction to Testing &amp; pytest](#introduction)
2. [Writing Your First Tests](#first-tests)
3. [Testing Functions](#testing-functions)
4. [Testing Classes](#testing-classes)
5. [Fixtures and Setup](#fixtures)
6. [Parametrized Tests](#parametrized)
7. [Mocking and Patching](#mocking)
8. [Test Organization &amp; Best Practices](#best-practices)
9. [Real-World Testing &amp; Exercises](#real-world)

---

## 1. Introduction to Testing & pytest

### 📖 Why Testing Matters

**The Problem Without Tests:**

```python
# calculator.py
def divide(a, b):
    return a / b

# main.py
result = divide(10, 2)
print(f"Result: {result}")  # Works fine!

# Later in production...
user_input = 0
result = divide(10, user_input)  # 💥 ZeroDivisionError!
```

**What went wrong?**

- ❌ No validation of inputs
- ❌ No edge case testing
- ❌ Code breaks in production
- ❌ Users see errors
- ❌ Data pipeline fails

**With Tests:**

```python
# calculator.py
def divide(a, b):
    """Divide a by b.
  
    Args:
        a (float): Numerator
        b (float): Denominator
  
    Returns:
        float: Result of division
  
    Raises:
        ValueError: If b is zero
    """
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# test_calculator.py
import pytest
from calculator import divide

def test_divide_normal():
    """Test division with normal values."""
    assert divide(10, 2) == 5.0

def test_divide_negative():
    """Test division with negative numbers."""
    assert divide(-10, 2) == -5.0

def test_divide_by_zero():
    """Test that division by zero raises ValueError."""
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(10, 0)

# Run tests: pytest test_calculator.py
# ✅ All tests pass - code is validated!
```

**Benefits:**

- ✅ Catches bugs before production
- ✅ Documents expected behavior
- ✅ Enables safe refactoring
- ✅ Increases confidence in code
- ✅ Saves debugging time

---

### 🏗️ The Testing Pyramid

```
        /\
       /  \        E2E Tests (Few)
      /    \       - Full system tests
     /______\      - Slow, expensive
    /        \   
   /          \    Integration Tests (Some)
  /            \   - Module interactions
 /______________\  - Database, API tests
/                \ 
/                 \ Unit Tests (Many)
/___________________\ - Individual functions
                    - Fast, focused, many
```

**Testing Strategy:**

1. **Unit Tests (70-80%)** - Test individual functions/methods

   - Fast execution (milliseconds)
   - Test one thing at a time
   - Easy to debug when they fail
2. **Integration Tests (15-25%)** - Test module interactions

   - Test database connections
   - Test API integrations
   - Test file operations
3. **End-to-End Tests (5-10%)** - Test complete workflows

   - Test entire ETL pipeline
   - Test user scenarios
   - Slow but comprehensive

**For Data Engineering:**

- Many unit tests for data transformations
- Integration tests for database operations
- E2E tests for complete pipelines

---

### 🎯 Types of Tests

**1. Unit Tests**

```python
# Test individual function
def test_calculate_tax():
    assert calculate_tax(100, 0.1) == 10.0
```

**2. Integration Tests**

```python
# Test database interaction
def test_save_to_database(db_connection):
    user = User(name="John")
    user.save(db_connection)
    assert db_connection.query("SELECT name FROM users").first() == "John"
```

**3. Functional Tests**

```python
# Test complete feature
def test_user_registration_flow():
    user = register_user("john@email.com", "password123")
    assert user.is_verified == False
    verify_email(user.verification_token)
    assert user.is_verified == True
```

**4. Regression Tests**

```python
# Test that previously fixed bugs stay fixed
def test_bug_123_date_parsing():
    # Bug: dates with single-digit days failed
    assert parse_date("2024-1-5") == date(2024, 1, 5)
```

---

### 🚀 Why pytest?

**Python has unittest (built-in), so why pytest?**

**unittest (built-in):**

```python
import unittest

class TestCalculator(unittest.TestCase):
    def test_divide(self):
        self.assertEqual(divide(10, 2), 5.0)
  
    def test_divide_by_zero(self):
        with self.assertRaises(ValueError):
            divide(10, 0)

if __name__ == '__main__':
    unittest.main()
```

**pytest (modern, popular):**

```python
import pytest

def test_divide():
    assert divide(10, 2) == 5.0

def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)
```

**Advantages of pytest:**

| Feature                   | unittest               | pytest                       |
| ------------------------- | ---------------------- | ---------------------------- |
| **Syntax**          | Requires classes       | Simple functions             |
| **Assertions**      | `self.assertEqual()` | `assert` statement         |
| **Setup**           | `setUp()` method     | Fixtures                     |
| **Parametrization** | Complex                | `@pytest.mark.parametrize` |
| **Output**          | Basic                  | Rich, colorful               |
| **Plugins**         | Limited                | 800+ plugins                 |
| **Learning Curve**  | Steeper                | Gentle                       |

**pytest Features:**

- ✅ Simple, Pythonic syntax
- ✅ Detailed failure reports
- ✅ Powerful fixtures
- ✅ Parametrized tests
- ✅ Plugin ecosystem
- ✅ Auto-discovery of tests
- ✅ Better assertions

---

### 🛠️ Installing pytest

**Create a virtual environment (recommended):**

```bash
# Create virtual environment
python -m venv venv

# Activate it
# Linux/Mac:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Install pytest
pip install pytest

# Verify installation
pytest --version
# Output: pytest 7.4.3
```

**Install additional pytest plugins (optional):**

```bash
pip install pytest-cov      # Code coverage
pip install pytest-mock     # Mocking utilities
pip install pytest-xdist    # Parallel test execution
```

**Create requirements-test.txt:**

```txt
pytest==7.4.3
pytest-cov==4.1.0
pytest-mock==3.12.0
```

**Install from file:**

```bash
pip install -r requirements-test.txt
```

---

### 📁 Project Structure for Testing

**Recommended structure:**

```
my_project/
├── src/                    # Source code
│   ├── __init__.py
│   ├── calculator.py
│   ├── database.py
│   └── etl.py
├── tests/                  # Test files
│   ├── __init__.py
│   ├── conftest.py        # Shared fixtures
│   ├── test_calculator.py
│   ├── test_database.py
│   └── test_etl.py
├── requirements.txt        # Production dependencies
├── requirements-test.txt   # Test dependencies
└── pytest.ini             # pytest configuration
```

**Alternative structure (tests alongside code):**

```
my_project/
├── calculator.py
├── test_calculator.py
├── database.py
├── test_database.py
├── etl.py
└── test_etl.py
```

**pytest.ini configuration:**

```ini
[pytest]
# Test discovery patterns
python_files = test_*.py *_test.py
python_classes = Test*
python_functions = test_*

# Show extra test summary info
addopts = 
    -v
    --tb=short
    --strict-markers

# Test paths
testpaths = tests

# Markers for organizing tests
markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    unit: marks tests as unit tests
```

---

### 🎯 Test Discovery

**pytest automatically finds tests based on naming conventions:**

**Files:** `test_*.py` or `*_test.py`

```
✅ test_calculator.py
✅ calculator_test.py
❌ calculator.py (no test prefix)
```

**Functions:** `test_*()`

```python
✅ def test_divide():
✅ def test_addition():
❌ def divide():  # No test prefix
```

**Classes:** `Test*` (no `__init__`)

```python
✅ class TestCalculator:
✅ class TestDatabase:
❌ class Calculator:  # No Test prefix
```

**Methods in test classes:** `test_*()`

```python
class TestCalculator:
    ✅ def test_divide(self):
    ✅ def test_add(self):
    ❌ def divide(self):  # No test prefix
```

---

### 🔑 Key Takeaways: Introduction to Testing

1. **Tests prevent bugs** - Catch errors before production
2. **Tests document behavior** - Show how code should work
3. **Testing pyramid** - Many unit tests, fewer integration tests, few E2E tests
4. **pytest is modern** - Simpler syntax than unittest
5. **Simple assertions** - Use `assert` instead of `self.assertEqual()`
6. **Auto-discovery** - pytest finds tests automatically
7. **Project structure matters** - Organize tests properly
8. **Configuration** - Use pytest.ini for settings

---

**🎯 Next:** We'll write our first tests and learn pytest basics!

---

## 2. Writing Your First Tests

### 🎬 Your First Test

Let's create a simple function and test it.

**Create calculator.py:**

```python
# calculator.py
"""Simple calculator functions for learning pytest."""

def add(a, b):
    """Add two numbers.
  
    Args:
        a (int/float): First number
        b (int/float): Second number
  
    Returns:
        int/float: Sum of a and b
    """
    return a + b


def subtract(a, b):
    """Subtract b from a.
  
    Args:
        a (int/float): First number
        b (int/float): Second number
  
    Returns:
        int/float: Difference of a and b
    """
    return a - b


def multiply(a, b):
    """Multiply two numbers.
  
    Args:
        a (int/float): First number
        b (int/float): Second number
  
    Returns:
        int/float: Product of a and b
    """
    return a * b
```

**Create test_calculator.py:**

```python
# test_calculator.py
"""Tests for calculator module."""

from calculator import add, subtract, multiply


def test_add():
    """Test addition function."""
    result = add(2, 3)
    assert result == 5


def test_subtract():
    """Test subtraction function."""
    result = subtract(5, 3)
    assert result == 2


def test_multiply():
    """Test multiplication function."""
    result = multiply(4, 3)
    assert result == 12
```

**Run the tests:**

```bash
$ pytest test_calculator.py

================================ test session starts =================================
platform linux -- Python 3.11.0, pytest-7.4.3, pluggy-1.3.0
rootdir: /home/user/project
collected 3 items

test_calculator.py ...                                                         [100%]

================================= 3 passed in 0.01s ==================================
```

**Understanding the output:**

- `collected 3 items` - pytest found 3 test functions
- `...` - Three dots mean 3 tests passed
- `3 passed in 0.01s` - All tests passed quickly

---

### ✅ The assert Statement

**Basic assertions:**

```python
def test_assertions():
    """Examples of different assertions."""
  
    # Equality
    assert 2 + 2 == 4
    assert "hello".upper() == "HELLO"
  
    # Inequality
    assert 5 != 6
    assert "cat" != "dog"
  
    # Greater/Less than
    assert 10 > 5
    assert 3 < 7
    assert 5 >= 5
    assert 4 <= 4
  
    # Boolean
    assert True
    assert not False
  
    # Membership
    assert 3 in [1, 2, 3, 4]
    assert "a" in "apple"
    assert "key" in {"key": "value"}
  
    # Type checking
    assert isinstance(42, int)
    assert isinstance("hello", str)
    assert isinstance([1, 2], list)
  
    # None checking
    value = None
    assert value is None
    assert value is not False  # None is not the same as False
```

**Why use assert instead of self.assertEqual()?**

```python
# unittest way (verbose)
import unittest

class TestCalculator(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertNotEqual(add(2, 3), 6)
        self.assertTrue(add(2, 3) > 4)
        self.assertIn(3, [1, 2, 3])

# pytest way (simple)
def test_add():
    assert add(2, 3) == 5
    assert add(2, 3) != 6
    assert add(2, 3) > 4
    assert 3 in [1, 2, 3]
```

**pytest provides better error messages:**

```python
def test_string_comparison():
    expected = "Hello, World!"
    actual = "Hello, Python!"
    assert actual == expected

# Output:
# AssertionError: assert 'Hello, Python!' == 'Hello, World!'
#   - Hello, World!
#   ?        ^^ ^^
#   + Hello, Python!
#   ?        ^^^  +
```

---

### 🎯 Multiple Tests

**Organize tests logically:**

```python
# test_calculator.py
"""Comprehensive calculator tests."""

from calculator import add, subtract, multiply


# ============= Addition Tests =============

def test_add_positive_numbers():
    """Test adding two positive numbers."""
    assert add(2, 3) == 5
    assert add(10, 20) == 30


def test_add_negative_numbers():
    """Test adding two negative numbers."""
    assert add(-2, -3) == -5
    assert add(-10, -5) == -15


def test_add_mixed_numbers():
    """Test adding positive and negative numbers."""
    assert add(5, -3) == 2
    assert add(-5, 3) == -2


def test_add_zero():
    """Test adding zero."""
    assert add(0, 5) == 5
    assert add(5, 0) == 5
    assert add(0, 0) == 0


# ============= Subtraction Tests =============

def test_subtract_positive_numbers():
    """Test subtracting positive numbers."""
    assert subtract(5, 3) == 2
    assert subtract(10, 4) == 6


def test_subtract_negative_numbers():
    """Test subtracting negative numbers."""
    assert subtract(-5, -3) == -2
    assert subtract(-10, -15) == 5


def test_subtract_result_negative():
    """Test subtraction resulting in negative."""
    assert subtract(3, 5) == -2
    assert subtract(10, 15) == -5


# ============= Multiplication Tests =============

def test_multiply_positive_numbers():
    """Test multiplying positive numbers."""
    assert multiply(2, 3) == 6
    assert multiply(4, 5) == 20


def test_multiply_by_zero():
    """Test multiplying by zero."""
    assert multiply(5, 0) == 0
    assert multiply(0, 5) == 0
    assert multiply(0, 0) == 0


def test_multiply_negative_numbers():
    """Test multiplying with negatives."""
    assert multiply(-2, 3) == -6
    assert multiply(2, -3) == -6
    assert multiply(-2, -3) == 6
```

**Run tests:**

```bash
$ pytest test_calculator.py -v

================================ test session starts =================================
test_calculator.py::test_add_positive_numbers PASSED                           [  8%]
test_calculator.py::test_add_negative_numbers PASSED                           [ 16%]
test_calculator.py::test_add_mixed_numbers PASSED                              [ 25%]
test_calculator.py::test_add_zero PASSED                                       [ 33%]
test_calculator.py::test_subtract_positive_numbers PASSED                      [ 41%]
test_calculator.py::test_subtract_negative_numbers PASSED                      [ 50%]
test_calculator.py::test_subtract_result_negative PASSED                       [ 58%]
test_calculator.py::test_multiply_positive_numbers PASSED                      [ 66%]
test_calculator.py::test_multiply_by_zero PASSED                               [ 75%]
test_calculator.py::test_multiply_negative_numbers PASSED                      [ 83%]

================================ 10 passed in 0.02s ==================================
```

**The `-v` flag shows:**

- Each test name
- Pass/Fail status
- Progress percentage

---

### 🔴 Test Failures

**What happens when a test fails?**

```python
# calculator.py
def divide(a, b):
    """Divide a by b."""
    return a / b  # Bug: no zero check!

# test_calculator.py
def test_divide():
    """Test division."""
    assert divide(10, 2) == 5  # This passes
    assert divide(10, 0) == 0  # This will fail!
```

**Run the test:**

```bash
$ pytest test_calculator.py::test_divide

================================ test session starts =================================
test_calculator.py::test_divide FAILED                                         [100%]

====================================== FAILURES ======================================
______________________________________ test_divide ___________________________________

    def test_divide():
        """Test division."""
        assert divide(10, 2) == 5  # This passes
>       assert divide(10, 0) == 0  # This will fail!

test_calculator.py:5: ZeroDivisionError

During handling of the above exception, another exception occurred:

    def test_divide():
        """Test division."""
        assert divide(10, 2) == 5
>       assert divide(10, 0) == 0
E       ZeroDivisionError: division by zero

test_calculator.py:5: ZeroDivisionError
============================== 1 failed in 0.03s ==================================
```

**pytest shows:**

- ❌ The failing test name
- 📍 The exact line that failed
- 🔍 The exception raised
- 📊 Full traceback

**Better test - expect the error:**

```python
import pytest

def test_divide_by_zero():
    """Test that division by zero raises error."""
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)
```

---

### 🎨 Running Tests - Command Line Options

**Basic commands:**

```bash
# Run all tests in current directory
pytest

# Run specific file
pytest test_calculator.py

# Run specific test function
pytest test_calculator.py::test_add

# Verbose output (-v)
pytest -v

# Very verbose output (-vv) - shows more details
pytest -vv

# Show print statements (-s)
pytest -s

# Stop at first failure (-x)
pytest -x

# Show local variables in tracebacks (-l)
pytest -l

# Run last failed tests only (--lf)
pytest --lf

# Run failed tests first, then rest (--ff)
pytest --ff
```

**Combining options:**

```bash
# Verbose + stop on first failure
pytest -v -x

# Show prints + local variables
pytest -s -l

# Very verbose + show prints
pytest -vv -s
```

**Running specific tests:**

```bash
# Run all tests in a directory
pytest tests/

# Run tests matching a pattern (-k)
pytest -k "add"  # Runs test_add, test_add_zero, etc.
pytest -k "add or subtract"  # Runs tests with 'add' OR 'subtract'
pytest -k "not slow"  # Skip tests with 'slow' in name

# Run tests by marker (we'll cover markers later)
pytest -m "unit"  # Run only unit tests
pytest -m "not integration"  # Skip integration tests
```

---

### 📊 Test Output Examples

**All tests passing:**

```bash
$ pytest -v

================================ test session starts =================================
collected 5 items

test_calculator.py::test_add PASSED                                            [ 20%]
test_calculator.py::test_subtract PASSED                                       [ 40%]
test_calculator.py::test_multiply PASSED                                       [ 60%]
test_calculator.py::test_divide PASSED                                         [ 80%]
test_calculator.py::test_power PASSED                                          [100%]

================================= 5 passed in 0.02s ==================================
```

**Some tests failing:**

```bash
$ pytest -v

================================ test session starts =================================
collected 5 items

test_calculator.py::test_add PASSED                                            [ 20%]
test_calculator.py::test_subtract FAILED                                       [ 40%]
test_calculator.py::test_multiply PASSED                                       [ 60%]
test_calculator.py::test_divide FAILED                                         [ 80%]
test_calculator.py::test_power PASSED                                          [100%]

================================= 2 failed, 3 passed in 0.05s =========================
```

**Test with print statements (use -s):**

```python
def test_with_debugging():
    """Test with debug prints."""
    result = add(2, 3)
    print(f"Result: {result}")  # Won't show unless -s flag
    assert result == 5
```

```bash
$ pytest test_calculator.py::test_with_debugging -s

================================ test session starts =================================
test_calculator.py::test_with_debugging Result: 5
PASSED

================================= 1 passed in 0.01s ==================================
```

---

### 🔑 Key Takeaways: Writing Your First Tests

1. **Simple syntax** - Just use `def test_*():` and `assert`
2. **Clear names** - Test names should describe what they test
3. **One concept per test** - Test one thing at a time
4. **assert is powerful** - Use Python's assert statement
5. **pytest finds tests** - Follows naming conventions
6. **Rich output** - pytest shows exactly what failed
7. **Command line power** - Many options for running tests
8. **Organize tests** - Group related tests together

**Test naming pattern:**

```python
def test_<function>_<scenario>_<expected>():
    # Examples:
    # test_add_positive_numbers_returns_sum
    # test_divide_by_zero_raises_error
    # test_parse_date_invalid_format_returns_none
```

---

**🎯 Next:** We'll learn how to test functions more thoroughly, including edge cases and exceptions!

---

## 3. Testing Functions

### 🎯 Testing Different Input Types

**Function to test:**

```python
# data_validator.py
"""Data validation functions for ETL pipeline."""

def validate_age(age):
    """Validate age is a valid positive integer.
  
    Args:
        age (int): Age to validate
  
    Returns:
        bool: True if valid, False otherwise
    """
    if not isinstance(age, int):
        return False
    if age < 0 or age > 150:
        return False
    return True


def clean_email(email):
    """Clean and validate email address.
  
    Args:
        email (str): Email address
  
    Returns:
        str: Cleaned email in lowercase
  
    Raises:
        ValueError: If email is invalid
    """
    if not isinstance(email, str):
        raise ValueError("Email must be a string")
  
    email = email.strip().lower()
  
    if '@' not in email or '.' not in email:
        raise ValueError(f"Invalid email format: {email}")
  
    return email


def parse_price(price_string):
    """Parse price string to float.
  
    Args:
        price_string (str): Price as string (e.g., "$19.99", "25.50")
  
    Returns:
        float: Price as float
  
    Raises:
        ValueError: If price cannot be parsed
    """
    if not isinstance(price_string, str):
        raise ValueError("Price must be a string")
  
    # Remove currency symbols and whitespace
    cleaned = price_string.strip().replace('$', '').replace('€', '').replace('£', '')
  
    try:
        return float(cleaned)
    except ValueError:
        raise ValueError(f"Cannot parse price: {price_string}")
```

**Comprehensive tests:**

```python
# test_data_validator.py
"""Tests for data validation functions."""

import pytest
from data_validator import validate_age, clean_email, parse_price


# ============= Testing validate_age =============

def test_validate_age_valid():
    """Test valid age values."""
    assert validate_age(0) == True
    assert validate_age(25) == True
    assert validate_age(65) == True
    assert validate_age(150) == True


def test_validate_age_invalid_negative():
    """Test negative ages are invalid."""
    assert validate_age(-1) == False
    assert validate_age(-100) == False


def test_validate_age_invalid_too_high():
    """Test ages over 150 are invalid."""
    assert validate_age(151) == False
    assert validate_age(200) == False


def test_validate_age_wrong_type():
    """Test non-integer types are invalid."""
    assert validate_age(25.5) == False  # Float
    assert validate_age("25") == False  # String
    assert validate_age(None) == False  # None
    assert validate_age([25]) == False  # List


# ============= Testing clean_email =============

def test_clean_email_valid():
    """Test cleaning valid email addresses."""
    assert clean_email("user@example.com") == "user@example.com"
    assert clean_email("User@Example.COM") == "user@example.com"
    assert clean_email("  user@example.com  ") == "user@example.com"


def test_clean_email_invalid_format():
    """Test invalid email formats raise ValueError."""
    with pytest.raises(ValueError, match="Invalid email format"):
        clean_email("notanemail")
  
    with pytest.raises(ValueError, match="Invalid email format"):
        clean_email("user@")
  
    with pytest.raises(ValueError, match="Invalid email format"):
        clean_email("@example.com")


def test_clean_email_wrong_type():
    """Test non-string types raise ValueError."""
    with pytest.raises(ValueError, match="Email must be a string"):
        clean_email(123)
  
    with pytest.raises(ValueError, match="Email must be a string"):
        clean_email(None)
  
    with pytest.raises(ValueError, match="Email must be a string"):
        clean_email(["user@example.com"])


# ============= Testing parse_price =============

def test_parse_price_valid():
    """Test parsing valid price strings."""
    assert parse_price("19.99") == 19.99
    assert parse_price("$19.99") == 19.99
    assert parse_price("€25.50") == 25.50
    assert parse_price("£10.00") == 10.00


def test_parse_price_with_whitespace():
    """Test parsing prices with whitespace."""
    assert parse_price("  19.99  ") == 19.99
    assert parse_price(" $ 19.99 ") == 19.99


def test_parse_price_integers():
    """Test parsing integer prices."""
    assert parse_price("25") == 25.0
    assert parse_price("$100") == 100.0


def test_parse_price_invalid():
    """Test invalid price strings raise ValueError."""
    with pytest.raises(ValueError, match="Cannot parse price"):
        parse_price("abc")
  
    with pytest.raises(ValueError, match="Cannot parse price"):
        parse_price("$19.99.99")
  
    with pytest.raises(ValueError, match="Cannot parse price"):
        parse_price("")


def test_parse_price_wrong_type():
    """Test non-string types raise ValueError."""
    with pytest.raises(ValueError, match="Price must be a string"):
        parse_price(19.99)
  
    with pytest.raises(ValueError, match="Price must be a string"):
        parse_price(None)
```

**What we're testing:**

- ✅ **Valid inputs** - Normal expected values
- ✅ **Edge cases** - Boundary values (0, 150, etc.)
- ✅ **Invalid inputs** - Values that should fail
- ✅ **Wrong types** - Type validation
- ✅ **Exceptions** - Expected errors are raised

---

### 🔍 Testing Edge Cases

**Edge cases are critical for data engineering!**

```python
# text_processor.py
"""Text processing functions."""

def truncate_string(text, max_length):
    """Truncate string to maximum length.
  
    Args:
        text (str): Text to truncate
        max_length (int): Maximum length
  
    Returns:
        str: Truncated string with '...' if truncated
    """
    if len(text) <= max_length:
        return text
    return text[:max_length - 3] + "..."


def split_into_chunks(data_list, chunk_size):
    """Split list into chunks of specified size.
  
    Args:
        data_list (list): List to split
        chunk_size (int): Size of each chunk
  
    Returns:
        list: List of chunks
    """
    if chunk_size <= 0:
        raise ValueError("Chunk size must be positive")
  
    chunks = []
    for i in range(0, len(data_list), chunk_size):
        chunks.append(data_list[i:i + chunk_size])
    return chunks


def calculate_percentage(part, total):
    """Calculate percentage.
  
    Args:
        part (float): Part value
        total (float): Total value
  
    Returns:
        float: Percentage (0-100)
  
    Raises:
        ValueError: If total is zero
    """
    if total == 0:
        raise ValueError("Total cannot be zero")
    return (part / total) * 100
```

**Edge case tests:**

```python
# test_text_processor.py
"""Tests focusing on edge cases."""

import pytest
from text_processor import truncate_string, split_into_chunks, calculate_percentage


# ============= Testing truncate_string =============

def test_truncate_string_normal():
    """Test normal truncation."""
    result = truncate_string("Hello, World!", 10)
    assert result == "Hello, ..."
    assert len(result) == 10


def test_truncate_string_no_truncation_needed():
    """Test when string is shorter than max length."""
    result = truncate_string("Hello", 10)
    assert result == "Hello"


def test_truncate_string_exact_length():
    """Test when string is exactly max length."""
    result = truncate_string("Hello", 5)
    assert result == "Hello"


def test_truncate_string_empty():
    """Test empty string."""
    result = truncate_string("", 10)
    assert result == ""


def test_truncate_string_very_short_limit():
    """Test very short max length."""
    result = truncate_string("Hello, World!", 5)
    assert result == "He..."
    assert len(result) == 5


def test_truncate_string_limit_three():
    """Test max length of 3 (edge case)."""
    result = truncate_string("Hello", 3)
    assert result == "..."


# ============= Testing split_into_chunks =============

def test_split_into_chunks_normal():
    """Test normal chunking."""
    data = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    result = split_into_chunks(data, 3)
    assert result == [[1, 2, 3], [4, 5, 6], [7, 8, 9]]


def test_split_into_chunks_uneven():
    """Test when data doesn't divide evenly."""
    data = [1, 2, 3, 4, 5, 6, 7, 8]
    result = split_into_chunks(data, 3)
    assert result == [[1, 2, 3], [4, 5, 6], [7, 8]]


def test_split_into_chunks_empty_list():
    """Test empty list."""
    result = split_into_chunks([], 3)
    assert result == []


def test_split_into_chunks_single_element():
    """Test single element."""
    result = split_into_chunks([1], 3)
    assert result == [[1]]


def test_split_into_chunks_chunk_larger_than_list():
    """Test chunk size larger than list."""
    result = split_into_chunks([1, 2, 3], 10)
    assert result == [[1, 2, 3]]


def test_split_into_chunks_chunk_size_one():
    """Test chunk size of 1."""
    result = split_into_chunks([1, 2, 3], 1)
    assert result == [[1], [2], [3]]


def test_split_into_chunks_invalid_chunk_size():
    """Test invalid chunk sizes."""
    with pytest.raises(ValueError, match="Chunk size must be positive"):
        split_into_chunks([1, 2, 3], 0)
  
    with pytest.raises(ValueError, match="Chunk size must be positive"):
        split_into_chunks([1, 2, 3], -1)


# ============= Testing calculate_percentage =============

def test_calculate_percentage_normal():
    """Test normal percentage calculation."""
    assert calculate_percentage(25, 100) == 25.0
    assert calculate_percentage(50, 200) == 25.0


def test_calculate_percentage_zero_part():
    """Test when part is zero."""
    assert calculate_percentage(0, 100) == 0.0


def test_calculate_percentage_part_equals_total():
    """Test when part equals total (100%)."""
    assert calculate_percentage(100, 100) == 100.0


def test_calculate_percentage_part_greater_than_total():
    """Test when part is greater than total (>100%)."""
    result = calculate_percentage(150, 100)
    assert result == 150.0


def test_calculate_percentage_decimals():
    """Test with decimal values."""
    result = calculate_percentage(33.33, 100)
    assert result == pytest.approx(33.33, rel=1e-2)


def test_calculate_percentage_zero_total():
    """Test division by zero."""
    with pytest.raises(ValueError, match="Total cannot be zero"):
        calculate_percentage(50, 0)


def test_calculate_percentage_negative_values():
    """Test with negative values."""
    # Negative part
    assert calculate_percentage(-25, 100) == -25.0
  
    # Negative total
    assert calculate_percentage(25, -100) == -25.0
  
    # Both negative
    assert calculate_percentage(-25, -100) == 25.0
```

**Edge cases to always consider:**

- 🔸 **Empty inputs** - Empty strings, empty lists, None
- 🔸 **Zero values** - Division by zero, multiplication by zero
- 🔸 **Boundary values** - Min/max values, exact limits
- 🔸 **Single elements** - Lists with one item
- 🔸 **Negative values** - Negative numbers where unexpected
- 🔸 **Very large/small values** - Performance and overflow

---

### 🚨 Testing Exceptions

**When to expect exceptions:**

```python
# file_processor.py
"""File processing functions."""

import json
from pathlib import Path


def read_json_file(filepath):
    """Read and parse JSON file.
  
    Args:
        filepath (str): Path to JSON file
  
    Returns:
        dict: Parsed JSON data
  
    Raises:
        FileNotFoundError: If file doesn't exist
        json.JSONDecodeError: If file is not valid JSON
    """
    path = Path(filepath)
  
    if not path.exists():
        raise FileNotFoundError(f"File not found: {filepath}")
  
    with open(path, 'r') as f:
        return json.load(f)


def divide_numbers(a, b):
    """Divide two numbers with validation.
  
    Args:
        a (float): Numerator
        b (float): Denominator
  
    Returns:
        float: Result of division
  
    Raises:
        TypeError: If inputs are not numbers
        ValueError: If denominator is zero
    """
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Both arguments must be numbers")
  
    if b == 0:
        raise ValueError("Cannot divide by zero")
  
    return a / b


def process_user_age(age):
    """Process user age with multiple validations.
  
    Args:
        age: User age
  
    Returns:
        str: Age category
  
    Raises:
        TypeError: If age is not an integer
        ValueError: If age is negative or unrealistic
    """
    if not isinstance(age, int):
        raise TypeError(f"Age must be an integer, got {type(age).__name__}")
  
    if age < 0:
        raise ValueError("Age cannot be negative")
  
    if age > 150:
        raise ValueError("Age is unrealistically high")
  
    # Categorize age
    if age < 18:
        return "minor"
    elif age < 65:
        return "adult"
    else:
        return "senior"
```

**Testing exceptions properly:**

```python
# test_file_processor.py
"""Tests for exception handling."""

import pytest
import json
from pathlib import Path
from file_processor import read_json_file, divide_numbers, process_user_age


# ============= Testing read_json_file =============

def test_read_json_file_not_found():
    """Test FileNotFoundError for missing file."""
    with pytest.raises(FileNotFoundError) as exc_info:
        read_json_file("nonexistent.json")
  
    # Check the exception message
    assert "File not found" in str(exc_info.value)
    assert "nonexistent.json" in str(exc_info.value)


def test_read_json_file_invalid_json(tmp_path):
    """Test JSONDecodeError for invalid JSON."""
    # Create a file with invalid JSON
    invalid_file = tmp_path / "invalid.json"
    invalid_file.write_text("not valid json {")
  
    with pytest.raises(json.JSONDecodeError):
        read_json_file(str(invalid_file))


def test_read_json_file_valid(tmp_path):
    """Test reading valid JSON file."""
    # Create a valid JSON file
    valid_file = tmp_path / "valid.json"
    data = {"name": "John", "age": 30}
    valid_file.write_text(json.dumps(data))
  
    result = read_json_file(str(valid_file))
    assert result == data


# ============= Testing divide_numbers =============

def test_divide_numbers_type_error_first_arg():
    """Test TypeError when first argument is not a number."""
    with pytest.raises(TypeError, match="Both arguments must be numbers"):
        divide_numbers("10", 2)


def test_divide_numbers_type_error_second_arg():
    """Test TypeError when second argument is not a number."""
    with pytest.raises(TypeError, match="Both arguments must be numbers"):
        divide_numbers(10, "2")


def test_divide_numbers_type_error_both():
    """Test TypeError when both arguments are not numbers."""
    with pytest.raises(TypeError, match="Both arguments must be numbers"):
        divide_numbers("10", "2")


def test_divide_numbers_value_error():
    """Test ValueError for division by zero."""
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide_numbers(10, 0)


def test_divide_numbers_valid():
    """Test valid division."""
    assert divide_numbers(10, 2) == 5.0
    assert divide_numbers(7, 2) == 3.5
    assert divide_numbers(-10, 2) == -5.0


# ============= Testing process_user_age =============

def test_process_user_age_type_error():
    """Test TypeError for non-integer age."""
    with pytest.raises(TypeError, match="Age must be an integer"):
        process_user_age(25.5)
  
    with pytest.raises(TypeError, match="Age must be an integer, got str"):
        process_user_age("25")
  
    with pytest.raises(TypeError, match="Age must be an integer, got NoneType"):
        process_user_age(None)


def test_process_user_age_negative():
    """Test ValueError for negative age."""
    with pytest.raises(ValueError, match="Age cannot be negative"):
        process_user_age(-1)
  
    with pytest.raises(ValueError, match="Age cannot be negative"):
        process_user_age(-100)


def test_process_user_age_too_high():
    """Test ValueError for unrealistic age."""
    with pytest.raises(ValueError, match="Age is unrealistically high"):
        process_user_age(151)
  
    with pytest.raises(ValueError, match="Age is unrealistically high"):
        process_user_age(200)


def test_process_user_age_valid_minor():
    """Test valid age categorization for minors."""
    assert process_user_age(0) == "minor"
    assert process_user_age(10) == "minor"
    assert process_user_age(17) == "minor"


def test_process_user_age_valid_adult():
    """Test valid age categorization for adults."""
    assert process_user_age(18) == "adult"
    assert process_user_age(30) == "adult"
    assert process_user_age(64) == "adult"


def test_process_user_age_valid_senior():
    """Test valid age categorization for seniors."""
    assert process_user_age(65) == "senior"
    assert process_user_age(80) == "senior"
    assert process_user_age(150) == "senior"
```

**Using pytest.raises() - Different patterns:**

```python
# Pattern 1: Simple exception check
def test_simple_exception():
    """Just check that exception is raised."""
    with pytest.raises(ValueError):
        some_function()


# Pattern 2: Check exception message
def test_exception_message():
    """Check exception message contains text."""
    with pytest.raises(ValueError, match="Cannot be negative"):
        some_function(-5)


# Pattern 3: Check exception message with regex
def test_exception_regex():
    """Check exception message with regex pattern."""
    with pytest.raises(ValueError, match=r"Invalid value: \d+"):
        some_function(123)


# Pattern 4: Inspect exception object
def test_exception_details():
    """Access exception object for detailed checks."""
    with pytest.raises(ValueError) as exc_info:
        some_function()
  
    # Check exception message
    assert "expected text" in str(exc_info.value)
  
    # Check exception type
    assert exc_info.type == ValueError
  
    # Check traceback
    assert exc_info.traceback


# Pattern 5: Multiple possible exceptions
def test_multiple_exceptions():
    """Test that one of several exceptions is raised."""
    with pytest.raises((ValueError, TypeError)):
        some_function()  # Could raise either
```

---

### 🔑 Key Takeaways: Testing Functions

1. **Test valid inputs** - Normal expected cases
2. **Test edge cases** - Boundaries, empty, zero, max values
3. **Test invalid inputs** - What should fail
4. **Test type checking** - Wrong types should be handled
5. **Test exceptions** - Use `pytest.raises()` properly
6. **Use descriptive names** - Test name shows what's tested
7. **One assertion per concept** - Keep tests focused
8. **Check exception messages** - Use `match` parameter

**Testing checklist for any function:**

```
✅ Valid inputs (normal cases)
✅ Edge cases (boundaries, empty, zero)
✅ Invalid inputs (negative, wrong type, None)
✅ Expected exceptions (with correct messages)
✅ Return values (correct type and value)
✅ Side effects (if any)
```

---

**🎯 Next:** We'll learn how to test classes and object-oriented code!

---

## 4. Testing Classes

### 🏗️ Basic Class Testing

**Class to test:**

```python
# bank_account.py
"""Bank account class for testing."""


class BankAccount:
    """Represents a bank account.
  
    Attributes:
        owner (str): Account owner name
        balance (float): Current balance
    """
  
    def __init__(self, owner, initial_balance=0):
        """Initialize bank account.
      
        Args:
            owner (str): Account owner name
            initial_balance (float): Starting balance (default 0)
      
        Raises:
            ValueError: If initial balance is negative
        """
        if initial_balance < 0:
            raise ValueError("Initial balance cannot be negative")
      
        self.owner = owner
        self.balance = initial_balance
  
    def deposit(self, amount):
        """Deposit money into account.
      
        Args:
            amount (float): Amount to deposit
      
        Raises:
            ValueError: If amount is not positive
        """
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
      
        self.balance += amount
        return self.balance
  
    def withdraw(self, amount):
        """Withdraw money from account.
      
        Args:
            amount (float): Amount to withdraw
      
        Returns:
            float: New balance
      
        Raises:
            ValueError: If amount is not positive or exceeds balance
        """
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
      
        if amount > self.balance:
            raise ValueError("Insufficient funds")
      
        self.balance -= amount
        return self.balance
  
    def get_balance(self):
        """Get current balance.
      
        Returns:
            float: Current balance
        """
        return self.balance
  
    def __str__(self):
        """String representation of account."""
        return f"BankAccount(owner={self.owner}, balance=${self.balance:.2f})"
  
    def __repr__(self):
        """Developer representation of account."""
        return f"BankAccount('{self.owner}', {self.balance})"
```

**Testing the class:**

```python
# test_bank_account.py
"""Tests for BankAccount class."""

import pytest
from bank_account import BankAccount


# ============= Testing __init__ =============

def test_init_default_balance():
    """Test initialization with default balance."""
    account = BankAccount("John Doe")
  
    assert account.owner == "John Doe"
    assert account.balance == 0


def test_init_with_initial_balance():
    """Test initialization with custom balance."""
    account = BankAccount("Jane Smith", 1000)
  
    assert account.owner == "Jane Smith"
    assert account.balance == 1000


def test_init_negative_balance():
    """Test that negative initial balance raises error."""
    with pytest.raises(ValueError, match="Initial balance cannot be negative"):
        BankAccount("John Doe", -100)


# ============= Testing deposit =============

def test_deposit_positive_amount():
    """Test depositing positive amount."""
    account = BankAccount("John Doe", 100)
    new_balance = account.deposit(50)
  
    assert new_balance == 150
    assert account.balance == 150


def test_deposit_multiple_times():
    """Test multiple deposits."""
    account = BankAccount("John Doe", 100)
  
    account.deposit(50)
    assert account.balance == 150
  
    account.deposit(25)
    assert account.balance == 175
  
    account.deposit(100)
    assert account.balance == 275


def test_deposit_zero():
    """Test that depositing zero raises error."""
    account = BankAccount("John Doe", 100)
  
    with pytest.raises(ValueError, match="Deposit amount must be positive"):
        account.deposit(0)


def test_deposit_negative():
    """Test that depositing negative amount raises error."""
    account = BankAccount("John Doe", 100)
  
    with pytest.raises(ValueError, match="Deposit amount must be positive"):
        account.deposit(-50)


# ============= Testing withdraw =============

def test_withdraw_valid_amount():
    """Test withdrawing valid amount."""
    account = BankAccount("John Doe", 100)
    new_balance = account.withdraw(30)
  
    assert new_balance == 70
    assert account.balance == 70


def test_withdraw_all_funds():
    """Test withdrawing entire balance."""
    account = BankAccount("John Doe", 100)
    new_balance = account.withdraw(100)
  
    assert new_balance == 0
    assert account.balance == 0


def test_withdraw_insufficient_funds():
    """Test withdrawing more than balance."""
    account = BankAccount("John Doe", 100)
  
    with pytest.raises(ValueError, match="Insufficient funds"):
        account.withdraw(150)


def test_withdraw_zero():
    """Test that withdrawing zero raises error."""
    account = BankAccount("John Doe", 100)
  
    with pytest.raises(ValueError, match="Withdrawal amount must be positive"):
        account.withdraw(0)


def test_withdraw_negative():
    """Test that withdrawing negative amount raises error."""
    account = BankAccount("John Doe", 100)
  
    with pytest.raises(ValueError, match="Withdrawal amount must be positive"):
        account.withdraw(-50)


# ============= Testing get_balance =============

def test_get_balance():
    """Test getting account balance."""
    account = BankAccount("John Doe", 250)
    assert account.get_balance() == 250


def test_get_balance_after_transactions():
    """Test balance after multiple transactions."""
    account = BankAccount("John Doe", 100)
  
    account.deposit(50)
    assert account.get_balance() == 150
  
    account.withdraw(30)
    assert account.get_balance() == 120


# ============= Testing __str__ and __repr__ =============

def test_str_representation():
    """Test string representation."""
    account = BankAccount("John Doe", 123.45)
    result = str(account)
  
    assert result == "BankAccount(owner=John Doe, balance=$123.45)"


def test_repr_representation():
    """Test developer representation."""
    account = BankAccount("John Doe", 123.45)
    result = repr(account)
  
    assert result == "BankAccount('John Doe', 123.45)"


# ============= Integration Tests =============

def test_complex_transaction_sequence():
    """Test a complex sequence of transactions."""
    account = BankAccount("John Doe", 0)
  
    # Make deposits
    account.deposit(1000)
    account.deposit(500)
    assert account.balance == 1500
  
    # Make withdrawals
    account.withdraw(200)
    account.withdraw(300)
    assert account.balance == 1000
  
    # More transactions
    account.deposit(250)
    account.withdraw(150)
    assert account.balance == 1100
```

**What we're testing:**

- ✅ **__init__ method** - Object initialization
- ✅ **Instance methods** - deposit(), withdraw(), get_balance()
- ✅ **Attributes** - owner, balance
- ✅ **Special methods** - __str__(), __repr__()
- ✅ **State changes** - Balance updates correctly
- ✅ **Integration** - Multiple operations in sequence

---

### 🎓 Testing Class Properties

```python
# user.py
"""User class with properties."""


class User:
    """Represents a user with validation.
  
    Attributes:
        username (str): User's username
        email (str): User's email address
        _age (int): User's age (private)
    """
  
    def __init__(self, username, email, age):
        """Initialize user.
      
        Args:
            username (str): Username
            email (str): Email address
            age (int): User age
        """
        self.username = username
        self.email = email
        self._age = None
        self.age = age  # Use property setter
  
    @property
    def age(self):
        """Get user age.
      
        Returns:
            int: User's age
        """
        return self._age
  
    @age.setter
    def age(self, value):
        """Set user age with validation.
      
        Args:
            value (int): New age
      
        Raises:
            ValueError: If age is invalid
        """
        if not isinstance(value, int):
            raise ValueError("Age must be an integer")
      
        if value < 0:
            raise ValueError("Age cannot be negative")
      
        if value > 150:
            raise ValueError("Age cannot exceed 150")
      
        self._age = value
  
    @property
    def is_adult(self):
        """Check if user is an adult.
      
        Returns:
            bool: True if age >= 18
        """
        return self._age >= 18
  
    @property
    def email_domain(self):
        """Get email domain.
      
        Returns:
            str: Email domain
        """
        return self.email.split('@')[1]
  
    def get_info(self):
        """Get user information.
      
        Returns:
            dict: User information
        """
        return {
            'username': self.username,
            'email': self.email,
            'age': self.age,
            'is_adult': self.is_adult,
            'domain': self.email_domain
        }
```

**Testing properties:**

```python
# test_user.py
"""Tests for User class properties."""

import pytest
from user import User


# ============= Testing initialization =============

def test_user_init():
    """Test user initialization."""
    user = User("john_doe", "john@example.com", 25)
  
    assert user.username == "john_doe"
    assert user.email == "john@example.com"
    assert user.age == 25


# ============= Testing age property =============

def test_age_property_getter():
    """Test getting age property."""
    user = User("john_doe", "john@example.com", 25)
    assert user.age == 25


def test_age_property_setter():
    """Test setting age property."""
    user = User("john_doe", "john@example.com", 25)
  
    user.age = 30
    assert user.age == 30


def test_age_property_invalid_type():
    """Test age property with invalid type."""
    with pytest.raises(ValueError, match="Age must be an integer"):
        User("john_doe", "john@example.com", "25")
  
    # Test setting invalid type
    user = User("john_doe", "john@example.com", 25)
    with pytest.raises(ValueError, match="Age must be an integer"):
        user.age = 25.5


def test_age_property_negative():
    """Test age property with negative value."""
    with pytest.raises(ValueError, match="Age cannot be negative"):
        User("john_doe", "john@example.com", -5)
  
    # Test setting negative
    user = User("john_doe", "john@example.com", 25)
    with pytest.raises(ValueError, match="Age cannot be negative"):
        user.age = -10


def test_age_property_too_high():
    """Test age property with value too high."""
    with pytest.raises(ValueError, match="Age cannot exceed 150"):
        User("john_doe", "john@example.com", 200)


# ============= Testing is_adult property =============

def test_is_adult_property_adult():
    """Test is_adult property for adults."""
    user = User("john_doe", "john@example.com", 18)
    assert user.is_adult == True
  
    user.age = 25
    assert user.is_adult == True
  
    user.age = 65
    assert user.is_adult == True


def test_is_adult_property_minor():
    """Test is_adult property for minors."""
    user = User("jane_doe", "jane@example.com", 17)
    assert user.is_adult == False
  
    user.age = 10
    assert user.is_adult == False
  
    user.age = 0
    assert user.is_adult == False


# ============= Testing email_domain property =============

def test_email_domain_property():
    """Test email_domain property."""
    user = User("john_doe", "john@example.com", 25)
    assert user.email_domain == "example.com"
  
    user.email = "john@gmail.com"
    assert user.email_domain == "gmail.com"


# ============= Testing get_info method =============

def test_get_info():
    """Test get_info method."""
    user = User("john_doe", "john@example.com", 25)
    info = user.get_info()
  
    assert info == {
        'username': 'john_doe',
        'email': 'john@example.com',
        'age': 25,
        'is_adult': True,
        'domain': 'example.com'
    }


def test_get_info_minor():
    """Test get_info for minor."""
    user = User("jane_doe", "jane@example.com", 15)
    info = user.get_info()
  
    assert info['is_adult'] == False
    assert info['age'] == 15
```

---

### 🔧 Testing Class Methods and Static Methods

```python
# data_processor.py
"""Data processor with class and static methods."""


class DataProcessor:
    """Process data with various utilities.
  
    Class Attributes:
        default_encoding (str): Default encoding for files
        max_file_size (int): Maximum file size in bytes
    """
  
    default_encoding = 'utf-8'
    max_file_size = 10 * 1024 * 1024  # 10 MB
  
    def __init__(self, name):
        """Initialize processor.
      
        Args:
            name (str): Processor name
        """
        self.name = name
        self.processed_count = 0
  
    @staticmethod
    def validate_filename(filename):
        """Validate filename format.
      
        Args:
            filename (str): Filename to validate
      
        Returns:
            bool: True if valid
      
        Note:
            Static method - doesn't access instance or class
        """
        if not isinstance(filename, str):
            return False
      
        if not filename:
            return False
      
        invalid_chars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|']
        return not any(char in filename for char in invalid_chars)
  
    @classmethod
    def from_config(cls, config):
        """Create processor from configuration.
      
        Args:
            config (dict): Configuration dictionary
      
        Returns:
            DataProcessor: New processor instance
      
        Note:
            Class method - alternative constructor
        """
        name = config.get('name', 'default')
        processor = cls(name)
      
        # Set class attributes if provided
        if 'encoding' in config:
            cls.default_encoding = config['encoding']
      
        if 'max_size' in config:
            cls.max_file_size = config['max_size']
      
        return processor
  
    @classmethod
    def get_default_config(cls):
        """Get default configuration.
      
        Returns:
            dict: Default configuration
      
        Note:
            Class method - accesses class attributes
        """
        return {
            'encoding': cls.default_encoding,
            'max_size': cls.max_file_size
        }
  
    def process_item(self):
        """Process a single item.
      
        Returns:
            int: Updated count
        """
        self.processed_count += 1
        return self.processed_count
```

**Testing class and static methods:**

```python
# test_data_processor.py
"""Tests for DataProcessor class methods."""

import pytest
from data_processor import DataProcessor


# ============= Testing static methods =============

def test_validate_filename_valid():
    """Test validating valid filenames."""
    assert DataProcessor.validate_filename("file.txt") == True
    assert DataProcessor.validate_filename("data_2024.csv") == True
    assert DataProcessor.validate_filename("my-file.json") == True


def test_validate_filename_invalid_chars():
    """Test validating filenames with invalid characters."""
    assert DataProcessor.validate_filename("file/path.txt") == False
    assert DataProcessor.validate_filename("file\\path.txt") == False
    assert DataProcessor.validate_filename("file:name.txt") == False
    assert DataProcessor.validate_filename("file*.txt") == False


def test_validate_filename_empty():
    """Test validating empty filename."""
    assert DataProcessor.validate_filename("") == False


def test_validate_filename_wrong_type():
    """Test validating non-string filename."""
    assert DataProcessor.validate_filename(123) == False
    assert DataProcessor.validate_filename(None) == False


# ============= Testing class methods =============

def test_from_config_default():
    """Test creating processor from minimal config."""
    config = {}
    processor = DataProcessor.from_config(config)
  
    assert processor.name == 'default'
    assert processor.processed_count == 0


def test_from_config_with_name():
    """Test creating processor with custom name."""
    config = {'name': 'my_processor'}
    processor = DataProcessor.from_config(config)
  
    assert processor.name == 'my_processor'


def test_from_config_with_encoding():
    """Test creating processor with custom encoding."""
    config = {'name': 'test', 'encoding': 'latin-1'}
    processor = DataProcessor.from_config(config)
  
    assert DataProcessor.default_encoding == 'latin-1'


def test_from_config_with_max_size():
    """Test creating processor with custom max size."""
    config = {'name': 'test', 'max_size': 5000}
    processor = DataProcessor.from_config(config)
  
    assert DataProcessor.max_file_size == 5000


def test_get_default_config():
    """Test getting default configuration."""
    # Reset to defaults
    DataProcessor.default_encoding = 'utf-8'
    DataProcessor.max_file_size = 10 * 1024 * 1024
  
    config = DataProcessor.get_default_config()
  
    assert config == {
        'encoding': 'utf-8',
        'max_size': 10 * 1024 * 1024
    }


# ============= Testing instance methods =============

def test_process_item():
    """Test processing items."""
    processor = DataProcessor("test")
  
    assert processor.processed_count == 0
  
    count = processor.process_item()
    assert count == 1
    assert processor.processed_count == 1
  
    processor.process_item()
    processor.process_item()
    assert processor.processed_count == 3


# ============= Testing class attributes =============

def test_class_attributes():
    """Test default class attributes."""
    assert hasattr(DataProcessor, 'default_encoding')
    assert hasattr(DataProcessor, 'max_file_size')
  
    # Check default values
    assert isinstance(DataProcessor.default_encoding, str)
    assert isinstance(DataProcessor.max_file_size, int)
```

---

### 🔑 Key Takeaways: Testing Classes

1. **Test initialization** - __init__ method with various inputs
2. **Test instance methods** - All public methods
3. **Test properties** - Both getters and setters
4. **Test class methods** - Alternative constructors
5. **Test static methods** - Utility functions
6. **Test state changes** - Attributes update correctly
7. **Test special methods** - __str__, __repr__, etc.
8. **Create test instances** - Each test creates its own object

**Class testing pattern:**

```python
def test_class_feature():
    """Test specific feature of class."""
    # 1. Arrange: Create instance
    obj = MyClass(args)
  
    # 2. Act: Call method
    result = obj.method()
  
    # 3. Assert: Verify result
    assert result == expected
    assert obj.attribute == expected_state
```

---

**🎯 Next:** We'll learn about fixtures for setting up test data and avoiding repetition!

---

## 5. Fixtures and Setup

### 🎪 What Are Fixtures?

**The Problem - Repetitive Setup Code:**

```python
# test_bank_account_bad.py
"""Tests with repetitive setup - BAD PRACTICE."""

from bank_account import BankAccount

def test_deposit():
    """Test deposit."""
    account = BankAccount("John Doe", 100)  # Repetitive setup
    account.deposit(50)
    assert account.balance == 150

def test_withdraw():
    """Test withdraw."""
    account = BankAccount("John Doe", 100)  # Same setup repeated
    account.withdraw(30)
    assert account.balance == 70

def test_get_balance():
    """Test get balance."""
    account = BankAccount("John Doe", 100)  # Again!
    assert account.get_balance() == 100
```

**Problems:**

- ❌ Duplicated code
- ❌ Hard to maintain
- ❌ Changes require updating multiple tests
- ❌ More code to write

**The Solution - Fixtures:**

```python
# test_bank_account_good.py
"""Tests with fixtures - GOOD PRACTICE."""

import pytest
from bank_account import BankAccount


@pytest.fixture
def account():
    """Create a bank account for testing.
  
    Returns:
        BankAccount: Account with $100 balance
    """
    return BankAccount("John Doe", 100)


def test_deposit(account):
    """Test deposit."""
    account.deposit(50)
    assert account.balance == 150


def test_withdraw(account):
    """Test withdraw."""
    account.withdraw(30)
    assert account.balance == 70


def test_get_balance(account):
    """Test get balance."""
    assert account.get_balance() == 100
```

**Benefits:**

- ✅ No duplication
- ✅ Easy to maintain
- ✅ Change once, affects all tests
- ✅ Clean, readable tests

**How fixtures work:**

1. Define fixture with `@pytest.fixture` decorator
2. Fixture name becomes a parameter
3. pytest automatically calls fixture
4. Fixture return value is passed to test

---

### 🎯 Basic Fixtures

**Simple fixture examples:**

```python
# conftest.py or test file
"""Fixture examples."""

import pytest


@pytest.fixture
def sample_number():
    """Provide a sample number.
  
    Returns:
        int: Sample number for testing
    """
    return 42


@pytest.fixture
def sample_list():
    """Provide a sample list.
  
    Returns:
        list: Sample list for testing
    """
    return [1, 2, 3, 4, 5]


@pytest.fixture
def sample_dict():
    """Provide a sample dictionary.
  
    Returns:
        dict: Sample dictionary for testing
    """
    return {
        'name': 'John Doe',
        'age': 30,
        'email': 'john@example.com'
    }


@pytest.fixture
def empty_list():
    """Provide an empty list.
  
    Returns:
        list: Empty list
    """
    return []


# Using fixtures in tests
def test_with_number(sample_number):
    """Test using sample_number fixture."""
    assert sample_number == 42
    assert isinstance(sample_number, int)


def test_with_list(sample_list):
    """Test using sample_list fixture."""
    assert len(sample_list) == 5
    assert sample_list[0] == 1


def test_with_dict(sample_dict):
    """Test using sample_dict fixture."""
    assert sample_dict['name'] == 'John Doe'
    assert sample_dict['age'] == 30


def test_multiple_fixtures(sample_number, sample_list):
    """Test using multiple fixtures."""
    assert sample_number in sample_list  # 42 not in list
    assert len(sample_list) == 5
```

**Fixture with setup logic:**

```python
import pytest
from datetime import datetime


@pytest.fixture
def timestamp():
    """Get current timestamp.
  
    Returns:
        datetime: Current timestamp
    """
    return datetime.now()


@pytest.fixture
def user_data():
    """Create user data with processing.
  
    Returns:
        dict: Processed user data
    """
    # Setup logic
    raw_data = {
        'name': '  John Doe  ',
        'email': 'JOHN@EXAMPLE.COM',
        'age': '30'
    }
  
    # Process data
    processed = {
        'name': raw_data['name'].strip(),
        'email': raw_data['email'].lower(),
        'age': int(raw_data['age'])
    }
  
    return processed


def test_user_data(user_data):
    """Test processed user data."""
    assert user_data['name'] == 'John Doe'  # Stripped
    assert user_data['email'] == 'john@example.com'  # Lowercase
    assert user_data['age'] == 30  # Converted to int
```

---

### 🔄 Fixture Scopes

**Fixtures can have different lifetimes:**

```python
import pytest


# Function scope (default) - runs for each test
@pytest.fixture(scope="function")
def function_fixture():
    """Runs before each test function.
  
    This is the default scope.
    """
    print("\n  Setting up function fixture")
    return "function data"


# Class scope - runs once per test class
@pytest.fixture(scope="class")
def class_fixture():
    """Runs once per test class.
  
    Shared by all test methods in the class.
    """
    print("\n  Setting up class fixture")
    return "class data"


# Module scope - runs once per module
@pytest.fixture(scope="module")
def module_fixture():
    """Runs once per test module.
  
    Shared by all tests in the file.
    """
    print("\n  Setting up module fixture")
    return "module data"


# Session scope - runs once per test session
@pytest.fixture(scope="session")
def session_fixture():
    """Runs once per entire test session.
  
    Shared by all tests in all files.
    """
    print("\n  Setting up session fixture")
    return "session data"


# Tests to demonstrate scopes
def test_1(function_fixture):
    """First test."""
    print(f"  Test 1 using: {function_fixture}")
    assert function_fixture == "function data"


def test_2(function_fixture):
    """Second test."""
    print(f"  Test 2 using: {function_fixture}")
    assert function_fixture == "function data"


def test_3(module_fixture):
    """Third test."""
    print(f"  Test 3 using: {module_fixture}")
    assert module_fixture == "module data"
```

**When to use each scope:**

| Scope              | Use Case                    | Example                  |
| ------------------ | --------------------------- | ------------------------ |
| **function** | Default, test isolation     | Creating test objects    |
| **class**    | Shared setup for class      | Test class configuration |
| **module**   | Expensive setup, file-level | Database connection      |
| **session**  | Very expensive, once        | Test database creation   |

**Practical example with different scopes:**

```python
# test_database.py
"""Database tests with different fixture scopes."""

import pytest
import sqlite3
from pathlib import Path


@pytest.fixture(scope="session")
def test_database_path(tmp_path_factory):
    """Create test database file path.
  
    Runs once per test session.
  
    Args:
        tmp_path_factory: pytest's temp directory factory
  
    Returns:
        Path: Path to test database
    """
    print("\n📁 Creating test database path (SESSION)")
    db_path = tmp_path_factory.mktemp("data") / "test.db"
    return db_path


@pytest.fixture(scope="session")
def database_connection(test_database_path):
    """Create database connection.
  
    Runs once per test session.
  
    Args:
        test_database_path: Path to database
  
    Yields:
        sqlite3.Connection: Database connection
    """
    print("\n🔌 Connecting to database (SESSION)")
    conn = sqlite3.connect(test_database_path)
  
    # Create tables
    conn.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        )
    """)
    conn.commit()
  
    yield conn
  
    print("\n🔌 Closing database connection (SESSION)")
    conn.close()


@pytest.fixture(scope="function")
def clean_database(database_connection):
    """Clean database before each test.
  
    Runs before each test function.
  
    Args:
        database_connection: Database connection
    """
    print("\n🧹 Cleaning database (FUNCTION)")
    database_connection.execute("DELETE FROM users")
    database_connection.commit()


def test_insert_user(database_connection, clean_database):
    """Test inserting a user."""
    print("\n✅ Running test_insert_user")
  
    database_connection.execute(
        "INSERT INTO users (name, email) VALUES (?, ?)",
        ("John Doe", "john@example.com")
    )
    database_connection.commit()
  
    cursor = database_connection.execute("SELECT * FROM users")
    users = cursor.fetchall()
  
    assert len(users) == 1
    assert users[0][1] == "John Doe"


def test_query_user(database_connection, clean_database):
    """Test querying a user."""
    print("\n✅ Running test_query_user")
  
    # Insert test data
    database_connection.execute(
        "INSERT INTO users (name, email) VALUES (?, ?)",
        ("Jane Smith", "jane@example.com")
    )
    database_connection.commit()
  
    # Query
    cursor = database_connection.execute(
        "SELECT name FROM users WHERE email = ?",
        ("jane@example.com",)
    )
    result = cursor.fetchone()
  
    assert result is not None
    assert result[0] == "Jane Smith"
```

**Output when running (with -s flag):**

```
📁 Creating test database path (SESSION)
🔌 Connecting to database (SESSION)
🧹 Cleaning database (FUNCTION)
✅ Running test_insert_user
🧹 Cleaning database (FUNCTION)
✅ Running test_query_user
🔌 Closing database connection (SESSION)
```

---

### 📂 conftest.py - Sharing Fixtures

**The conftest.py file:**

- Special pytest file
- Automatically discovered
- Fixtures available to all test files
- Can have multiple (one per directory)

**Project structure:**

```
project/
├── conftest.py              # Root-level fixtures
├── test_app.py
├── tests/
│   ├── conftest.py         # Test-directory fixtures
│   ├── test_users.py
│   └── test_products.py
└── src/
    └── app.py
```

**conftest.py example:**

```python
# conftest.py
"""Shared fixtures for all tests."""

import pytest
from datetime import datetime
import tempfile
from pathlib import Path


@pytest.fixture
def sample_user():
    """Provide a sample user dictionary.
  
    Returns:
        dict: User data for testing
    """
    return {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'active': True
    }


@pytest.fixture
def sample_users():
    """Provide multiple sample users.
  
    Returns:
        list: List of user dictionaries
    """
    return [
        {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
        {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
        {'id': 3, 'name': 'Bob Wilson', 'email': 'bob@example.com'}
    ]


@pytest.fixture
def temp_directory():
    """Create a temporary directory.
  
    Yields:
        Path: Path to temporary directory
    """
    with tempfile.TemporaryDirectory() as tmpdir:
        yield Path(tmpdir)


@pytest.fixture
def sample_csv_file(temp_directory):
    """Create a sample CSV file.
  
    Args:
        temp_directory: Temporary directory fixture
  
    Returns:
        Path: Path to CSV file
    """
    csv_file = temp_directory / "data.csv"
    csv_content = """name,age,city
John Doe,30,New York
Jane Smith,25,Los Angeles
Bob Wilson,35,Chicago"""
  
    csv_file.write_text(csv_content)
    return csv_file


@pytest.fixture
def current_timestamp():
    """Get current timestamp.
  
    Returns:
        datetime: Current timestamp
    """
    return datetime.now()
```

**Using conftest.py fixtures:**

```python
# test_users.py
"""User tests using conftest fixtures."""

def test_user_structure(sample_user):
    """Test user has required fields."""
    assert 'id' in sample_user
    assert 'name' in sample_user
    assert 'email' in sample_user


def test_user_count(sample_users):
    """Test number of sample users."""
    assert len(sample_users) == 3


def test_csv_file_exists(sample_csv_file):
    """Test CSV file was created."""
    assert sample_csv_file.exists()
    assert sample_csv_file.suffix == '.csv'


def test_csv_content(sample_csv_file):
    """Test CSV file content."""
    content = sample_csv_file.read_text()
    assert 'John Doe' in content
    assert 'Jane Smith' in content
```

```python
# test_products.py
"""Product tests using conftest fixtures."""

def test_timestamp_type(current_timestamp):
    """Test timestamp fixture."""
    from datetime import datetime
    assert isinstance(current_timestamp, datetime)


def test_temp_directory(temp_directory):
    """Test temporary directory fixture."""
    assert temp_directory.exists()
    assert temp_directory.is_dir()
  
    # Create a file in temp directory
    test_file = temp_directory / "test.txt"
    test_file.write_text("test content")
    assert test_file.exists()
```

---

### 🎭 Yield Fixtures (Setup and Teardown)

**Fixtures that need cleanup:**

```python
import pytest
import sqlite3
from pathlib import Path


@pytest.fixture
def database_connection():
    """Create and cleanup database connection.
  
    Yields:
        sqlite3.Connection: Database connection
    """
    # Setup - runs before test
    print("\n🔌 Setting up database connection")
    conn = sqlite3.connect(':memory:')
  
    # Create table
    conn.execute("""
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
        )
    """)
    conn.commit()
  
    # Provide connection to test
    yield conn
  
    # Teardown - runs after test (even if test fails)
    print("\n🔌 Closing database connection")
    conn.close()


@pytest.fixture
def log_file(tmp_path):
    """Create and cleanup log file.
  
    Args:
        tmp_path: pytest's temporary path fixture
  
    Yields:
        Path: Path to log file
    """
    # Setup
    log_path = tmp_path / "test.log"
    print(f"\n📝 Creating log file: {log_path}")
    log_path.write_text("Log started\n")
  
    # Provide to test
    yield log_path
  
    # Teardown
    print(f"\n📝 Log file final content:")
    print(log_path.read_text())


@pytest.fixture
def file_handler():
    """Open and close a file handler.
  
    Yields:
        file: Open file handler
    """
    # Setup
    print("\n📁 Opening file")
    f = open('test_data.txt', 'w')
  
    yield f
  
    # Teardown
    print("\n📁 Closing file")
    f.close()
  
    # Additional cleanup
    Path('test_data.txt').unlink(missing_ok=True)


# Using yield fixtures
def test_database_operations(database_connection):
    """Test database with automatic cleanup."""
    # Insert data
    database_connection.execute(
        "INSERT INTO users (name) VALUES (?)",
        ("John Doe",)
    )
    database_connection.commit()
  
    # Query data
    cursor = database_connection.execute("SELECT name FROM users")
    result = cursor.fetchone()
  
    assert result[0] == "John Doe"
    # Connection will be automatically closed after test


def test_log_writing(log_file):
    """Test log file with automatic cleanup."""
    # Append to log
    with open(log_file, 'a') as f:
        f.write("Test log entry\n")
  
    # Verify content
    content = log_file.read_text()
    assert "Log started" in content
    assert "Test log entry" in content
    # Log content will be printed during teardown
```

**Yield fixture pattern:**

```python
@pytest.fixture
def my_fixture():
    """Fixture with setup and teardown."""
    # 1. Setup code (before yield)
    resource = create_resource()
  
    # 2. Provide resource to test
    yield resource
  
    # 3. Teardown code (after yield)
    # This runs even if test fails!
    cleanup_resource(resource)
```

---

### 🔑 Key Takeaways: Fixtures

1. **Fixtures eliminate duplication** - Write setup once
2. **Use @pytest.fixture decorator** - Makes function a fixture
3. **Fixture name = parameter name** - Auto-injection
4. **Choose appropriate scope** - function, class, module, session
5. **conftest.py for sharing** - Available to all tests
6. **Yield for teardown** - Setup before, cleanup after
7. **Fixtures can use fixtures** - Dependencies work
8. **tmp_path built-in fixture** - For temporary files

**Fixture best practices:**

```python
# ✅ Good fixture
@pytest.fixture
def user():
    """Create test user with clear purpose."""
    return User(name="Test User", email="test@example.com")

# ❌ Bad fixture
@pytest.fixture
def data():
    """Generic fixture with unclear purpose."""
    return {"stuff": [1, 2, 3]}
```

---

**🎯 Next:** We'll learn about parametrized tests to run the same test with different inputs!

---

## 6. Parametrized Tests

### 🔄 Why Parametrize?

**The Problem - Repetitive Test Code:**

```python
# test_calculator_repetitive.py
"""Repetitive tests - BAD PRACTICE."""

from calculator import add

def test_add_2_and_3():
    """Test adding 2 and 3."""
    assert add(2, 3) == 5

def test_add_10_and_20():
    """Test adding 10 and 20."""
    assert add(10, 20) == 30

def test_add_negative_numbers():
    """Test adding negative numbers."""
    assert add(-5, -3) == -8

def test_add_zero():
    """Test adding zero."""
    assert add(0, 5) == 5

def test_add_large_numbers():
    """Test adding large numbers."""
    assert add(1000, 2000) == 3000
```

**Problems:**

- ❌ 5 test functions for the same logic
- ❌ Lots of duplication
- ❌ Hard to add more test cases
- ❌ Verbose and repetitive

**The Solution - Parametrized Tests:**

```python
# test_calculator_parametrized.py
"""Parametrized tests - GOOD PRACTICE."""

import pytest
from calculator import add


@pytest.mark.parametrize("a, b, expected", [
    (2, 3, 5),           # Test case 1
    (10, 20, 30),        # Test case 2
    (-5, -3, -8),        # Test case 3
    (0, 5, 5),           # Test case 4
    (1000, 2000, 3000),  # Test case 5
])
def test_add(a, b, expected):
    """Test addition with multiple inputs."""
    result = add(a, b)
    assert result == expected
```

**Benefits:**

- ✅ One test function
- ✅ Multiple test cases
- ✅ Easy to add more cases
- ✅ Clean and maintainable
- ✅ pytest shows each case separately

**Output:**

```bash
$ pytest test_calculator_parametrized.py -v

test_calculator_parametrized.py::test_add[2-3-5] PASSED              [ 20%]
test_calculator_parametrized.py::test_add[10-20-30] PASSED           [ 40%]
test_calculator_parametrized.py::test_add[-5--3--8] PASSED           [ 60%]
test_calculator_parametrized.py::test_add[0-5-5] PASSED              [ 80%]
test_calculator_parametrized.py::test_add[1000-2000-3000] PASSED    [100%]

========================= 5 passed in 0.02s ===========================
```

---

### 📝 Basic Parametrization

**Syntax:**

```python
@pytest.mark.parametrize("parameter_names", [
    (value1, value2, ...),
    (value1, value2, ...),
])
def test_function(parameter_names):
    # Test logic
```

**Example - Testing string operations:**

```python
# test_strings.py
"""Parametrized string tests."""

import pytest


@pytest.mark.parametrize("text, expected_upper", [
    ("hello", "HELLO"),
    ("world", "WORLD"),
    ("Python", "PYTHON"),
    ("test", "TEST"),
])
def test_string_upper(text, expected_upper):
    """Test string upper() method."""
    assert text.upper() == expected_upper


@pytest.mark.parametrize("text, expected_length", [
    ("hello", 5),
    ("world", 5),
    ("Python", 6),
    ("", 0),
    ("a", 1),
])
def test_string_length(text, expected_length):
    """Test string length."""
    assert len(text) == expected_length


@pytest.mark.parametrize("text, substring, expected", [
    ("hello world", "world", True),
    ("hello world", "python", False),
    ("Python is great", "Python", True),
    ("Python is great", "python", False),  # Case sensitive
])
def test_substring_in_string(text, substring, expected):
    """Test substring checking."""
    assert (substring in text) == expected
```

---

### 🎯 Multiple Parameters

**Testing data validation:**

```python
# test_validators.py
"""Testing validators with parametrization."""

import pytest


def validate_email(email):
    """Validate email format."""
    if not isinstance(email, str):
        return False
    if '@' not in email or '.' not in email:
        return False
    return True


def validate_age(age):
    """Validate age is valid."""
    if not isinstance(age, int):
        return False
    if age < 0 or age > 150:
        return False
    return True


# Test valid emails
@pytest.mark.parametrize("email", [
    "user@example.com",
    "john.doe@company.co.uk",
    "admin@test.org",
    "support+tag@service.com",
])
def test_validate_email_valid(email):
    """Test valid email addresses."""
    assert validate_email(email) == True


# Test invalid emails
@pytest.mark.parametrize("email", [
    "notanemail",
    "user@",
    "@example.com",
    "user@domain",
    123,
    None,
    "",
])
def test_validate_email_invalid(email):
    """Test invalid email addresses."""
    assert validate_email(email) == False


# Test ages with expected results
@pytest.mark.parametrize("age, expected", [
    (0, True),
    (25, True),
    (150, True),
    (-1, False),
    (151, False),
    (25.5, False),
    ("25", False),
])
def test_validate_age(age, expected):
    """Test age validation."""
    assert validate_age(age) == expected
```

---

### 🔢 Parametrizing with IDs

**Make test output more readable:**

```python
# test_math_operations.py
"""Parametrized tests with custom IDs."""

import pytest


def divide(a, b):
    """Divide a by b."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b


# Without IDs (default)
@pytest.mark.parametrize("a, b, expected", [
    (10, 2, 5.0),
    (20, 4, 5.0),
    (15, 3, 5.0),
])
def test_divide_without_ids(a, b, expected):
    """Test division without custom IDs."""
    assert divide(a, b) == expected


# With custom IDs
@pytest.mark.parametrize("a, b, expected", [
    (10, 2, 5.0),
    (20, 4, 5.0),
    (15, 3, 5.0),
], ids=["10÷2", "20÷4", "15÷3"])
def test_divide_with_ids(a, b, expected):
    """Test division with custom IDs."""
    assert divide(a, b) == expected


# Using ID function
@pytest.mark.parametrize("a, b, expected", [
    (10, 2, 5.0),
    (20, 4, 5.0),
    (15, 3, 5.0),
], ids=lambda params: f"{params[0]}÷{params[1]}={params[2]}")
def test_divide_with_id_function(a, b, expected):
    """Test division with ID function."""
    assert divide(a, b) == expected


# Testing exceptions with IDs
@pytest.mark.parametrize("a, b", [
    (10, 0),
    (5, 0),
    (100, 0),
], ids=["divide 10 by 0", "divide 5 by 0", "divide 100 by 0"])
def test_divide_by_zero(a, b):
    """Test division by zero raises error."""
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(a, b)
```

**Output comparison:**

```bash
# Without IDs:
test_math_operations.py::test_divide_without_ids[10-2-5.0] PASSED
test_math_operations.py::test_divide_without_ids[20-4-5.0] PASSED

# With IDs:
test_math_operations.py::test_divide_with_ids[10÷2] PASSED
test_math_operations.py::test_divide_with_ids[20÷4] PASSED
```

---

### 🎨 Multiple Parametrize Decorators

**Combining parameters creates a matrix:**

```python
# test_matrix.py
"""Test matrix with multiple parametrize decorators."""

import pytest


def format_greeting(name, greeting, punctuation):
    """Format a greeting message."""
    return f"{greeting} {name}{punctuation}"


# Multiple decorators create a test matrix
@pytest.mark.parametrize("name", ["Alice", "Bob", "Charlie"])
@pytest.mark.parametrize("greeting", ["Hello", "Hi", "Hey"])
def test_greeting_combinations(name, greeting):
    """Test all combinations of names and greetings.
  
    This creates 3 × 3 = 9 tests
    """
    result = format_greeting(name, greeting, "!")
    assert name in result
    assert greeting in result


# Three parameters = 3D matrix
@pytest.mark.parametrize("name", ["Alice", "Bob"])
@pytest.mark.parametrize("greeting", ["Hello", "Hi"])
@pytest.mark.parametrize("punctuation", ["!", ".", "?"])
def test_full_combinations(name, greeting, punctuation):
    """Test all combinations.
  
    This creates 2 × 2 × 3 = 12 tests
    """
    result = format_greeting(name, greeting, punctuation)
    assert name in result
    assert greeting in result
    assert result.endswith(punctuation)
```

**Output:**

```bash
$ pytest test_matrix.py -v

test_matrix.py::test_greeting_combinations[Hello-Alice] PASSED
test_matrix.py::test_greeting_combinations[Hello-Bob] PASSED
test_matrix.py::test_greeting_combinations[Hello-Charlie] PASSED
test_matrix.py::test_greeting_combinations[Hi-Alice] PASSED
test_matrix.py::test_greeting_combinations[Hi-Bob] PASSED
test_matrix.py::test_greeting_combinations[Hi-Charlie] PASSED
test_matrix.py::test_greeting_combinations[Hey-Alice] PASSED
test_matrix.py::test_greeting_combinations[Hey-Bob] PASSED
test_matrix.py::test_greeting_combinations[Hey-Charlie] PASSED

========================= 9 passed in 0.03s ===========================
```

---

### 🔍 Data-Driven Testing

**Testing with real-world data:**

```python
# test_data_processing.py
"""Data-driven testing examples."""

import pytest
from datetime import date


def parse_date_string(date_str):
    """Parse date string in various formats.
  
    Args:
        date_str (str): Date string
  
    Returns:
        date: Parsed date object
    """
    # Try different formats
    formats = [
        "%Y-%m-%d",      # 2024-01-15
        "%d/%m/%Y",      # 15/01/2024
        "%m-%d-%Y",      # 01-15-2024
        "%Y.%m.%d",      # 2024.01.15
    ]
  
    for fmt in formats:
        try:
            from datetime import datetime
            return datetime.strptime(date_str, fmt).date()
        except ValueError:
            continue
  
    raise ValueError(f"Cannot parse date: {date_str}")


# Test different date formats
@pytest.mark.parametrize("date_str, expected", [
    ("2024-01-15", date(2024, 1, 15)),
    ("15/01/2024", date(2024, 1, 15)),
    ("01-15-2024", date(2024, 1, 15)),
    ("2024.01.15", date(2024, 1, 15)),
])
def test_parse_date_formats(date_str, expected):
    """Test parsing different date formats."""
    result = parse_date_string(date_str)
    assert result == expected


def clean_phone_number(phone):
    """Clean and format phone number.
  
    Args:
        phone (str): Phone number
  
    Returns:
        str: Cleaned phone number (digits only)
    """
    # Remove common separators
    cleaned = phone.replace("-", "").replace(" ", "")
    cleaned = cleaned.replace("(", "").replace(")", "")
    cleaned = cleaned.replace(".", "")
  
    # Keep only digits
    return ''.join(c for c in cleaned if c.isdigit())


# Test phone number cleaning
@pytest.mark.parametrize("input_phone, expected", [
    ("123-456-7890", "1234567890"),
    ("(123) 456-7890", "1234567890"),
    ("123.456.7890", "1234567890"),
    ("123 456 7890", "1234567890"),
    ("+1-123-456-7890", "11234567890"),
], ids=[
    "dashes",
    "parentheses",
    "dots",
    "spaces",
    "international",
])
def test_clean_phone_number(input_phone, expected):
    """Test cleaning various phone formats."""
    result = clean_phone_number(input_phone)
    assert result == expected


def calculate_grade(score):
    """Calculate letter grade from score.
  
    Args:
        score (int): Score (0-100)
  
    Returns:
        str: Letter grade
    """
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"


# Test grade calculation with edge cases
@pytest.mark.parametrize("score, expected", [
    # A grades
    (100, "A"),
    (95, "A"),
    (90, "A"),
    # B grades
    (89, "B"),
    (85, "B"),
    (80, "B"),
    # C grades
    (79, "C"),
    (75, "C"),
    (70, "C"),
    # D grades
    (69, "D"),
    (65, "D"),
    (60, "D"),
    # F grades
    (59, "F"),
    (50, "F"),
    (0, "F"),
], ids=lambda params: f"score_{params[0]}_is_{params[1]}")
def test_calculate_grade(score, expected):
    """Test grade calculation."""
    result = calculate_grade(score)
    assert result == expected
```

---

### 💡 Parametrizing Fixtures

**You can also parametrize fixtures:**

```python
# test_database_parametrized.py
"""Parametrized fixtures example."""

import pytest


@pytest.fixture(params=["sqlite", "mysql", "postgresql"])
def database_type(request):
    """Provide different database types.
  
    Tests using this fixture will run once for each database type.
  
    Args:
        request: pytest request object
  
    Returns:
        str: Database type
    """
    return request.param


@pytest.fixture(params=[10, 100, 1000])
def sample_size(request):
    """Provide different sample sizes.
  
    Args:
        request: pytest request object
  
    Returns:
        int: Sample size
    """
    return request.param


def test_database_connection(database_type):
    """Test database connection for different databases.
  
    This test runs 3 times (once per database type).
    """
    print(f"\nTesting with: {database_type}")
    assert database_type in ["sqlite", "mysql", "postgresql"]


def test_data_processing(sample_size):
    """Test data processing with different sizes.
  
    This test runs 3 times (once per sample size).
    """
    print(f"\nProcessing {sample_size} items")
    data = list(range(sample_size))
    assert len(data) == sample_size


# Combining parametrized fixtures
def test_database_with_size(database_type, sample_size):
    """Test combining parametrized fixtures.
  
    This test runs 3 × 3 = 9 times!
    """
    print(f"\nDatabase: {database_type}, Size: {sample_size}")
    assert database_type is not None
    assert sample_size > 0
```

---

### 🔑 Key Takeaways: Parametrized Tests

1. **@pytest.mark.parametrize** - Decorator for parametrization
2. **Eliminates duplication** - One test, many cases
3. **Easy to add cases** - Just add to the list
4. **Each case runs separately** - Individual pass/fail
5. **Use IDs for clarity** - Custom test names
6. **Multiple decorators = matrix** - All combinations tested
7. **Parametrize fixtures** - Run tests with different setups
8. **Great for edge cases** - Test boundaries easily

**When to use parametrization:**

- ✅ Testing same logic with different inputs
- ✅ Testing edge cases and boundaries
- ✅ Testing data transformations
- ✅ Testing validation functions
- ✅ Testing multiple similar scenarios

**Parametrization pattern:**

```python
@pytest.mark.parametrize("input, expected", [
    # Normal cases
    (valid_input_1, expected_1),
    (valid_input_2, expected_2),
    # Edge cases
    (edge_case_1, expected_3),
    (edge_case_2, expected_4),
    # Invalid cases (if testing exception)
], ids=["case1", "case2", "edge1", "edge2"])
def test_function(input, expected):
    result = function_under_test(input)
    assert result == expected
```

---

**🎯 Next:** We'll learn about mocking and patching for testing external dependencies!

---

## 7. Mocking and Patching

### 🎭 Why Mocking?

**The Problem - External Dependencies:**

```python
# email_service.py
"""Email service with external dependency."""

import smtplib
from datetime import datetime


def send_email(to_address, subject, body):
    """Send email via SMTP server.
  
    Problem: How do we test this without:
    - Actually sending emails
    - Having an SMTP server
    - Needing credentials
    - Waiting for network calls
    """
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login('user@gmail.com', 'password')
  
    message = f"Subject: {subject}\n\n{body}"
    server.sendmail('user@gmail.com', to_address, message)
    server.quit()
  
    return True


def send_welcome_email(user):
    """Send welcome email to new user.
  
    This function depends on send_email().
    We want to test the logic without actually sending emails!
    """
    subject = f"Welcome, {user['name']}!"
    body = f"Hello {user['name']}, welcome to our service!"
  
    result = send_email(user['email'], subject, body)
  
    if result:
        return f"Welcome email sent to {user['email']}"
    else:
        return "Failed to send email"
```

**Testing challenges:**

- ❌ Can't test without real SMTP server
- ❌ Tests would send real emails
- ❌ Tests would be slow (network calls)
- ❌ Tests would fail without internet
- ❌ Hard to test error conditions

**The Solution - Mocking:**

```python
# test_email_service.py
"""Testing with mocks."""

import pytest
from unittest.mock import Mock, patch
from email_service import send_welcome_email


def test_send_welcome_email():
    """Test welcome email logic without sending real email."""
  
    # Create a mock for send_email function
    with patch('email_service.send_email') as mock_send:
        # Configure the mock to return True
        mock_send.return_value = True
      
        # Test data
        user = {'name': 'John Doe', 'email': 'john@example.com'}
      
        # Call function (uses mock instead of real send_email)
        result = send_welcome_email(user)
      
        # Verify result
        assert result == "Welcome email sent to john@example.com"
      
        # Verify send_email was called correctly
        mock_send.assert_called_once()
        mock_send.assert_called_with(
            'john@example.com',
            'Welcome, John Doe!',
            'Hello John Doe, welcome to our service!'
        )
```

**Benefits of mocking:**

- ✅ No external dependencies needed
- ✅ Tests run fast (no network)
- ✅ Tests are reliable
- ✅ Can simulate errors easily
- ✅ Focus on testing logic, not integration

---

### 🎪 unittest.mock Basics

**The Mock object:**

```python
from unittest.mock import Mock

# Create a mock object
mock = Mock()

# Mock can be called like a function
result = mock()
print(result)  # <Mock name='mock()' id='...'>

# Mock can have attributes
mock.some_attribute = "value"
print(mock.some_attribute)  # "value"

# Mock can have methods
mock.some_method.return_value = 42
print(mock.some_method())  # 42

# Check if mock was called
mock.my_function()
print(mock.my_function.called)  # True
print(mock.my_function.call_count)  # 1
```

**Setting return values:**

```python
from unittest.mock import Mock

# Simple return value
mock_function = Mock(return_value=42)
print(mock_function())  # 42

# Return different values on each call
mock_function = Mock()
mock_function.side_effect = [1, 2, 3]
print(mock_function())  # 1
print(mock_function())  # 2
print(mock_function())  # 3

# Raise an exception
mock_function = Mock()
mock_function.side_effect = ValueError("Something went wrong")
try:
    mock_function()
except ValueError as e:
    print(f"Caught: {e}")  # Caught: Something went wrong

# Use a custom function
def custom_behavior(x):
    return x * 2

mock_function = Mock()
mock_function.side_effect = custom_behavior
print(mock_function(5))  # 10
print(mock_function(7))  # 14
```

**Checking mock calls:**

```python
from unittest.mock import Mock

mock = Mock()

# Call the mock
mock(1, 2, 3)
mock(x=10, y=20)
mock("hello")

# Check if called
print(mock.called)  # True
print(mock.call_count)  # 3

# Check call arguments
print(mock.call_args)  # call('hello')
print(mock.call_args_list)  # [call(1, 2, 3), call(x=10, y=20), call('hello')]

# Assert methods
mock.assert_called()  # Passes - mock was called
mock.assert_called_with("hello")  # Passes - last call was with "hello"
mock.assert_called_once()  # Fails - called 3 times

# Reset mock
mock.reset_mock()
print(mock.called)  # False
print(mock.call_count)  # 0
```

---

### 🔧 The @patch Decorator

**Basic patching:**

```python
# calculator.py
"""Calculator with logging."""

import logging


def add(a, b):
    """Add two numbers."""
    result = a + b
    logging.info(f"Adding {a} + {b} = {result}")
    return result


def multiply(a, b):
    """Multiply two numbers."""
    result = a * b
    logging.info(f"Multiplying {a} * {b} = {result}")
    return result
```

```python
# test_calculator.py
"""Testing with @patch decorator."""

import pytest
from unittest.mock import patch, Mock
from calculator import add, multiply


@patch('calculator.logging')
def test_add_with_logging(mock_logging):
    """Test add function logs correctly.
  
    Args:
        mock_logging: Automatically injected mock for logging module
    """
    result = add(5, 3)
  
    # Verify result
    assert result == 8
  
    # Verify logging was called
    mock_logging.info.assert_called_once()
    mock_logging.info.assert_called_with("Adding 5 + 3 = 8")


@patch('calculator.logging')
def test_multiply_with_logging(mock_logging):
    """Test multiply function logs correctly."""
    result = multiply(4, 3)
  
    assert result == 12
    mock_logging.info.assert_called_with("Multiplying 4 * 3 = 12")


# Multiple patches
@patch('calculator.logging')
@patch('calculator.multiply')
def test_multiple_patches(mock_multiply, mock_logging):
    """Test with multiple patches.
  
    Note: Patches are applied bottom-to-top,
          but parameters are top-to-bottom!
    """
    mock_multiply.return_value = 100
  
    result = multiply(10, 10)
  
    assert result == 100  # Using mocked value
    mock_multiply.assert_called_once_with(10, 10)
```

**Patching as context manager:**

```python
# test_with_context_manager.py
"""Using patch as context manager."""

from unittest.mock import patch
from calculator import add


def test_add_with_context_manager():
    """Test using patch as context manager."""
  
    with patch('calculator.logging') as mock_logging:
        result = add(10, 20)
      
        assert result == 30
        mock_logging.info.assert_called_once()
  
    # Mock is no longer active here
    # Original logging is restored


def test_multiple_context_managers():
    """Test with nested context managers."""
  
    with patch('calculator.logging') as mock_logging:
        with patch('calculator.add') as mock_add:
            mock_add.return_value = 999
          
            result = add(1, 1)
          
            assert result == 999
            mock_add.assert_called_once()
```

---

### 🌐 Mocking External API Calls

**API client to test:**

```python
# weather_service.py
"""Weather service that calls external API."""

import requests


def get_weather(city):
    """Get weather for a city.
  
    Args:
        city (str): City name
  
    Returns:
        dict: Weather data
  
    Raises:
        requests.RequestException: If API call fails
    """
    api_key = "your_api_key"
    url = f"https://api.weather.com/v1/weather?city={city}&key={api_key}"
  
    response = requests.get(url, timeout=10)
    response.raise_for_status()
  
    return response.json()


def get_temperature(city):
    """Get temperature for a city.
  
    Args:
        city (str): City name
  
    Returns:
        float: Temperature in Celsius
    """
    weather_data = get_weather(city)
    return weather_data['temperature']


def is_raining(city):
    """Check if it's raining in a city.
  
    Args:
        city (str): City name
  
    Returns:
        bool: True if raining
    """
    weather_data = get_weather(city)
    return weather_data['conditions'] == 'rain'
```

**Testing with mocked API:**

```python
# test_weather_service.py
"""Testing weather service with mocked API."""

import pytest
from unittest.mock import patch, Mock
import requests
from weather_service import get_weather, get_temperature, is_raining


@patch('weather_service.requests.get')
def test_get_weather_success(mock_get):
    """Test successful API call."""
  
    # Create mock response
    mock_response = Mock()
    mock_response.json.return_value = {
        'temperature': 25.5,
        'conditions': 'sunny',
        'humidity': 60
    }
    mock_response.status_code = 200
  
    # Configure mock to return our response
    mock_get.return_value = mock_response
  
    # Call function
    result = get_weather('London')
  
    # Verify result
    assert result['temperature'] == 25.5
    assert result['conditions'] == 'sunny'
  
    # Verify API was called correctly
    mock_get.assert_called_once()
    call_args = mock_get.call_args
    assert 'London' in call_args[0][0]


@patch('weather_service.requests.get')
def test_get_weather_api_error(mock_get):
    """Test API error handling."""
  
    # Configure mock to raise exception
    mock_get.side_effect = requests.RequestException("API Error")
  
    # Verify exception is raised
    with pytest.raises(requests.RequestException):
        get_weather('London')


@patch('weather_service.get_weather')
def test_get_temperature(mock_get_weather):
    """Test temperature extraction."""
  
    # Mock get_weather to return test data
    mock_get_weather.return_value = {
        'temperature': 20.0,
        'conditions': 'cloudy'
    }
  
    # Call function
    temp = get_temperature('Paris')
  
    # Verify
    assert temp == 20.0
    mock_get_weather.assert_called_once_with('Paris')


@patch('weather_service.get_weather')
def test_is_raining_true(mock_get_weather):
    """Test rain detection when raining."""
  
    mock_get_weather.return_value = {
        'temperature': 15.0,
        'conditions': 'rain'
    }
  
    result = is_raining('Seattle')
  
    assert result == True
    mock_get_weather.assert_called_once_with('Seattle')


@patch('weather_service.get_weather')
def test_is_raining_false(mock_get_weather):
    """Test rain detection when not raining."""
  
    mock_get_weather.return_value = {
        'temperature': 25.0,
        'conditions': 'sunny'
    }
  
    result = is_raining('Los Angeles')
  
    assert result == False


@patch('weather_service.requests.get')
def test_api_timeout(mock_get):
    """Test API timeout handling."""
  
    # Simulate timeout
    mock_get.side_effect = requests.Timeout("Request timed out")
  
    with pytest.raises(requests.Timeout):
        get_weather('Tokyo')


@patch('weather_service.requests.get')
def test_api_different_status_codes(mock_get):
    """Test different HTTP status codes."""
  
    # Test 404 - Not Found
    mock_response = Mock()
    mock_response.raise_for_status.side_effect = requests.HTTPError("404 Not Found")
    mock_get.return_value = mock_response
  
    with pytest.raises(requests.HTTPError):
        get_weather('InvalidCity')
```

---

### 💾 Mocking Database Operations

**Database service to test:**

```python
# user_service.py
"""User service with database operations."""

import sqlite3


class UserService:
    """Service for user database operations."""
  
    def __init__(self, db_connection):
        """Initialize service.
      
        Args:
            db_connection: Database connection
        """
        self.db = db_connection
  
    def get_user(self, user_id):
        """Get user by ID.
      
        Args:
            user_id (int): User ID
      
        Returns:
            dict: User data or None
        """
        cursor = self.db.execute(
            "SELECT id, name, email FROM users WHERE id = ?",
            (user_id,)
        )
        row = cursor.fetchone()
      
        if row:
            return {
                'id': row[0],
                'name': row[1],
                'email': row[2]
            }
        return None
  
    def create_user(self, name, email):
        """Create new user.
      
        Args:
            name (str): User name
            email (str): User email
      
        Returns:
            int: New user ID
        """
        cursor = self.db.execute(
            "INSERT INTO users (name, email) VALUES (?, ?)",
            (name, email)
        )
        self.db.commit()
        return cursor.lastrowid
  
    def update_user(self, user_id, name=None, email=None):
        """Update user information.
      
        Args:
            user_id (int): User ID
            name (str, optional): New name
            email (str, optional): New email
      
        Returns:
            bool: True if updated
        """
        if name:
            self.db.execute(
                "UPDATE users SET name = ? WHERE id = ?",
                (name, user_id)
            )
        if email:
            self.db.execute(
                "UPDATE users SET email = ? WHERE id = ?",
                (email, user_id)
            )
      
        self.db.commit()
        return True
  
    def delete_user(self, user_id):
        """Delete user.
      
        Args:
            user_id (int): User ID
      
        Returns:
            bool: True if deleted
        """
        self.db.execute("DELETE FROM users WHERE id = ?", (user_id,))
        self.db.commit()
        return True
```

**Testing with mocked database:**

```python
# test_user_service.py
"""Testing user service with mocked database."""

import pytest
from unittest.mock import Mock, MagicMock, call
from user_service import UserService


@pytest.fixture
def mock_db():
    """Create mock database connection.
  
    Returns:
        Mock: Mocked database connection
    """
    return Mock()


@pytest.fixture
def user_service(mock_db):
    """Create user service with mock database.
  
    Args:
        mock_db: Mock database fixture
  
    Returns:
        UserService: Service instance
    """
    return UserService(mock_db)


def test_get_user_found(user_service, mock_db):
    """Test getting existing user."""
  
    # Setup mock cursor
    mock_cursor = Mock()
    mock_cursor.fetchone.return_value = (1, 'John Doe', 'john@example.com')
    mock_db.execute.return_value = mock_cursor
  
    # Call function
    user = user_service.get_user(1)
  
    # Verify result
    assert user is not None
    assert user['id'] == 1
    assert user['name'] == 'John Doe'
    assert user['email'] == 'john@example.com'
  
    # Verify SQL was executed
    mock_db.execute.assert_called_once()
    call_args = mock_db.execute.call_args[0]
    assert "SELECT" in call_args[0]
    assert call_args[1] == (1,)


def test_get_user_not_found(user_service, mock_db):
    """Test getting non-existent user."""
  
    # Setup mock to return None
    mock_cursor = Mock()
    mock_cursor.fetchone.return_value = None
    mock_db.execute.return_value = mock_cursor
  
    # Call function
    user = user_service.get_user(999)
  
    # Verify result
    assert user is None


def test_create_user(user_service, mock_db):
    """Test creating new user."""
  
    # Setup mock cursor with lastrowid
    mock_cursor = Mock()
    mock_cursor.lastrowid = 42
    mock_db.execute.return_value = mock_cursor
  
    # Call function
    user_id = user_service.create_user('Jane Smith', 'jane@example.com')
  
    # Verify result
    assert user_id == 42
  
    # Verify SQL was executed
    mock_db.execute.assert_called_once()
    call_args = mock_db.execute.call_args[0]
    assert "INSERT" in call_args[0]
    assert call_args[1] == ('Jane Smith', 'jane@example.com')
  
    # Verify commit was called
    mock_db.commit.assert_called_once()


def test_update_user_name(user_service, mock_db):
    """Test updating user name."""
  
    result = user_service.update_user(1, name='New Name')
  
    assert result == True
    mock_db.execute.assert_called_once()
    mock_db.commit.assert_called_once()


def test_update_user_email(user_service, mock_db):
    """Test updating user email."""
  
    result = user_service.update_user(1, email='new@example.com')
  
    assert result == True
    mock_db.execute.assert_called_once()
    mock_db.commit.assert_called_once()


def test_update_user_both(user_service, mock_db):
    """Test updating both name and email."""
  
    result = user_service.update_user(1, name='New Name', email='new@example.com')
  
    assert result == True
    assert mock_db.execute.call_count == 2  # Called twice
    mock_db.commit.assert_called_once()


def test_delete_user(user_service, mock_db):
    """Test deleting user."""
  
    result = user_service.delete_user(1)
  
    assert result == True
    mock_db.execute.assert_called_once()
    call_args = mock_db.execute.call_args[0]
    assert "DELETE" in call_args[0]
    assert call_args[1] == (1,)
    mock_db.commit.assert_called_once()
```

---

### 🔑 Key Takeaways: Mocking and Patching

1. **Mock external dependencies** - Don't test external systems
2. **Use unittest.mock** - Built-in mocking library
3. **@patch decorator** - Replace objects during tests
4. **return_value** - Set what mock returns
5. **side_effect** - Simulate exceptions or complex behavior
6. **assert_called** - Verify mock was used correctly
7. **Mock databases and APIs** - Keep tests fast and reliable
8. **Patch at usage location** - Patch where object is used, not where it's defined

**Mocking best practices:**

```python
# ✅ Good - Mock at usage location
@patch('my_module.requests.get')  # Where it's used
def test_function(mock_get):
    ...

# ❌ Bad - Mock at definition location
@patch('requests.get')  # Where it's defined
def test_function(mock_get):
    ...
```

---

**🎯 Next:** We'll learn about test organization, best practices, and code coverage!

---

## 8. Test Organization & Best Practices

### 📐 The AAA Pattern (Arrange-Act-Assert)

**Structure every test with three clear sections:**

```python
# test_user_registration.py
"""Example of AAA pattern."""

import pytest
from user_service import UserService


def test_user_registration():
    """Test user registration with AAA pattern."""
  
    # ========== ARRANGE ==========
    # Setup: Create objects, prepare data, configure mocks
    service = UserService()
    user_data = {
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'SecurePass123!'
    }
  
    # ========== ACT ==========
    # Action: Execute the code being tested
    result = service.register_user(user_data)
  
    # ========== ASSERT ==========
    # Assert: Verify the outcome
    assert result['success'] == True
    assert result['user_id'] is not None
    assert result['message'] == 'User registered successfully'


def test_calculate_discount():
    """Test discount calculation with AAA pattern."""
  
    # ARRANGE
    original_price = 100.0
    discount_percent = 20
  
    # ACT
    final_price = calculate_discount(original_price, discount_percent)
  
    # ASSERT
    assert final_price == 80.0


def test_data_transformation():
    """Test data transformation with AAA pattern."""
  
    # ARRANGE - Prepare input data
    raw_data = {
        'name': '  John Doe  ',
        'email': 'JOHN@EXAMPLE.COM',
        'age': '30'
    }
  
    # ACT - Transform data
    cleaned_data = clean_user_data(raw_data)
  
    # ASSERT - Verify transformation
    assert cleaned_data['name'] == 'John Doe'  # Trimmed
    assert cleaned_data['email'] == 'john@example.com'  # Lowercase
    assert cleaned_data['age'] == 30  # Converted to int
```

**Why AAA pattern?**

- ✅ Clear test structure
- ✅ Easy to understand
- ✅ Easy to maintain
- ✅ Consistent across codebase
- ✅ Helps identify what's being tested

---

### 🏷️ Test Naming Conventions

**Good test names are descriptive:**

```python
# ❌ BAD - Unclear test names
def test1():
    """Test something."""
    assert add(2, 2) == 4

def test_function():
    """Test the function."""
    assert validate_email("test") == False

def test_edge_case():
    """Test edge case."""
    assert divide(10, 0)


# ✅ GOOD - Clear, descriptive test names
def test_add_two_positive_numbers_returns_sum():
    """Test adding two positive numbers returns their sum."""
    assert add(2, 3) == 5

def test_validate_email_with_invalid_format_returns_false():
    """Test email validation returns False for invalid format."""
    assert validate_email("notanemail") == False

def test_divide_by_zero_raises_value_error():
    """Test division by zero raises ValueError."""
    with pytest.raises(ValueError):
        divide(10, 0)
```

**Naming patterns:**

```python
# Pattern 1: test_<function>_<scenario>_<expected>
def test_calculate_tax_with_zero_rate_returns_zero():
    """Test tax calculation with 0% rate returns 0."""
    pass

# Pattern 2: test_<what>_when_<condition>_then_<result>
def test_user_login_when_invalid_password_then_returns_error():
    """Test user login with invalid password returns error."""
    pass

# Pattern 3: test_<action>_<expected_result>
def test_empty_list_returns_zero_sum():
    """Test summing empty list returns zero."""
    pass

# Pattern 4: test_<scenario>
def test_successful_user_registration():
    """Test user can register with valid data."""
    pass
```

---

### 🎯 Test Independence

**Each test should be independent:**

```python
# ❌ BAD - Tests depend on each other
class TestUserBad:
    """Bad example - tests are interdependent."""
  
    user_id = None  # Shared state!
  
    def test_create_user(self):
        """Create user."""
        TestUserBad.user_id = create_user("John")
        assert TestUserBad.user_id is not None
  
    def test_get_user(self):
        """Get user - depends on test_create_user!"""
        user = get_user(TestUserBad.user_id)  # Fails if create_user didn't run
        assert user['name'] == "John"
  
    def test_delete_user(self):
        """Delete user - depends on previous tests!"""
        delete_user(TestUserBad.user_id)
        assert get_user(TestUserBad.user_id) is None


# ✅ GOOD - Tests are independent
class TestUserGood:
    """Good example - each test is independent."""
  
    @pytest.fixture
    def user_id(self):
        """Create user for testing."""
        user_id = create_user("John")
        yield user_id
        # Cleanup
        delete_user(user_id)
  
    def test_create_user(self):
        """Test user creation."""
        user_id = create_user("Alice")
        assert user_id is not None
        # Cleanup
        delete_user(user_id)
  
    def test_get_user(self, user_id):
        """Test getting user - independent setup."""
        user = get_user(user_id)
        assert user['name'] == "John"
  
    def test_delete_user(self, user_id):
        """Test deleting user - independent setup."""
        delete_user(user_id)
        assert get_user(user_id) is None
```

**Why test independence matters:**

- ✅ Tests can run in any order
- ✅ Tests can run in parallel
- ✅ Failing test doesn't affect others
- ✅ Easy to debug failures
- ✅ Tests are more reliable

---

### 🏷️ Test Markers

**Organize and categorize tests:**

```python
# test_with_markers.py
"""Using pytest markers."""

import pytest


# Mark slow tests
@pytest.mark.slow
def test_large_dataset_processing():
    """Test processing large dataset - takes 10 seconds."""
    data = list(range(1000000))
    result = process_data(data)
    assert len(result) == 1000000


# Mark integration tests
@pytest.mark.integration
def test_database_connection():
    """Test database connection - needs database."""
    conn = connect_to_database()
    assert conn.is_connected()


# Mark unit tests
@pytest.mark.unit
def test_addition():
    """Test simple addition - fast unit test."""
    assert add(2, 3) == 5


# Mark with multiple markers
@pytest.mark.slow
@pytest.mark.integration
def test_full_etl_pipeline():
    """Test complete ETL pipeline - slow integration test."""
    result = run_etl_pipeline()
    assert result['success'] == True


# Custom markers
@pytest.mark.database
def test_user_crud_operations():
    """Test CRUD operations - requires database."""
    pass


@pytest.mark.api
def test_external_api_call():
    """Test API call - requires network."""
    pass
```

**Running tests by marker:**

```bash
# Run only unit tests
pytest -m "unit"

# Run only integration tests
pytest -m "integration"

# Run everything except slow tests
pytest -m "not slow"

# Run unit tests that are not slow
pytest -m "unit and not slow"

# Run integration or database tests
pytest -m "integration or database"
```

**Register markers in pytest.ini:**

```ini
[pytest]
markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    unit: marks tests as unit tests
    database: marks tests that require database
    api: marks tests that call external APIs
    smoke: marks tests for smoke testing
```

---

### ⏭️ Skip and XFail

**Skip tests conditionally:**

```python
import pytest
import sys


# Skip unconditionally
@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    """Test feature that's not implemented."""
    pass


# Skip conditionally
@pytest.mark.skipif(sys.version_info < (3, 8), reason="Requires Python 3.8+")
def test_python_38_feature():
    """Test feature requiring Python 3.8+."""
    pass


@pytest.mark.skipif(not has_database(), reason="Database not available")
def test_database_operation():
    """Test that requires database."""
    pass


# Skip in test body
def test_conditional_skip():
    """Test with conditional skip."""
    if not check_environment():
        pytest.skip("Environment not configured")
  
    # Test continues if environment is configured
    assert perform_operation() == True


# Expected to fail (known bug)
@pytest.mark.xfail(reason="Known bug #123")
def test_known_bug():
    """Test that is expected to fail."""
    assert buggy_function() == "correct"  # This will fail


# Expected to fail with condition
@pytest.mark.xfail(sys.platform == "win32", reason="Bug on Windows")
def test_platform_specific():
    """Test that fails on Windows."""
    pass


# Strict xfail - fail if test unexpectedly passes
@pytest.mark.xfail(strict=True, reason="Should fail")
def test_strict_xfail():
    """Test that should fail, error if it passes."""
    pass
```

**Output explanation:**

```
test.py::test_skip SKIPPED (Not implemented yet)
test.py::test_xfail XFAIL (Known bug #123)
test.py::test_xpass XPASS (Expected to fail but passed)
```

---

### 📊 Test Coverage

**Measure how much code is tested:**

```bash
# Install pytest-cov
pip install pytest-cov

# Run tests with coverage
pytest --cov=my_module

# Output:
# Name                Stmts   Miss  Cover
# ---------------------------------------
# my_module.py           45      5    89%
# ---------------------------------------
# TOTAL                  45      5    89%

# Coverage report with missing lines
pytest --cov=my_module --cov-report=term-missing

# Output:
# Name                Stmts   Miss  Cover   Missing
# ------------------------------------------------
# my_module.py           45      5    89%   12, 25-28
# ------------------------------------------------

# Generate HTML coverage report
pytest --cov=my_module --cov-report=html

# Creates htmlcov/index.html - open in browser
```

**Example with coverage:**

```python
# calculator.py
"""Calculator module."""

def add(a, b):
    """Add two numbers."""
    return a + b  # Line 5 - Covered

def subtract(a, b):
    """Subtract b from a."""
    return a - b  # Line 9 - Covered

def multiply(a, b):
    """Multiply two numbers."""
    return a * b  # Line 13 - NOT COVERED!

def divide(a, b):
    """Divide a by b."""
    if b == 0:  # Line 17 - Covered
        raise ValueError("Cannot divide by zero")  # Line 18 - Covered
    return a / b  # Line 19 - Covered
```

```python
# test_calculator.py
"""Tests for calculator."""

import pytest
from calculator import add, subtract, divide

def test_add():
    assert add(2, 3) == 5  # Covers line 5

def test_subtract():
    assert subtract(5, 3) == 2  # Covers line 9

# No test for multiply! Line 13 not covered

def test_divide():
    assert divide(10, 2) == 5  # Covers line 19

def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)  # Covers lines 17-18
```

**Coverage output:**

```
Name                Stmts   Miss  Cover   Missing
------------------------------------------------
calculator.py          10      1    90%   13
```

**Adding missing test:**

```python
def test_multiply():
    """Test multiplication."""
    assert multiply(4, 3) == 12  # Now line 13 is covered!
```

**New coverage: 100%!**

---

### 🔑 Best Practices Summary

**1. Test Structure:**

```python
def test_feature():
    """Clear docstring explaining what's tested."""
    # ARRANGE - Setup
    data = prepare_data()
  
    # ACT - Execute
    result = function_under_test(data)
  
    # ASSERT - Verify
    assert result == expected
```

**2. Test Naming:**

```python
# ✅ Descriptive
def test_validate_email_with_invalid_format_returns_false():
    pass

# ❌ Not descriptive
def test_email():
    pass
```

**3. One Assertion Per Concept:**

```python
# ✅ Good - Related assertions
def test_user_creation():
    user = create_user("John", "john@example.com")
    assert user.name == "John"
    assert user.email == "john@example.com"

# ❌ Bad - Unrelated assertions
def test_multiple_things():
    assert add(2, 2) == 4
    assert validate_email("test@test.com") == True
    assert len([1, 2, 3]) == 3
```

**4. Test Independence:**

```python
# ✅ Each test sets up its own data
@pytest.fixture
def user():
    return create_test_user()

def test_a(user):
    # Has its own user
    pass

def test_b(user):
    # Has its own user
    pass
```

**5. Use Markers:**

```python
@pytest.mark.slow
@pytest.mark.integration
def test_full_pipeline():
    pass
```

**6. Meaningful Test Data:**

```python
# ✅ Clear test data
def test_adult_age():
    user = User(name="Adult User", age=25)
    assert user.is_adult() == True

# ❌ Magic numbers
def test_user():
    user = User(name="Test", age=42)
    assert user.is_adult() == True
```

**7. Test Error Cases:**

```python
def test_divide_by_zero():
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(10, 0)
```

**8. Keep Tests Simple:**

```python
# ✅ Simple and clear
def test_addition():
    assert add(2, 3) == 5

# ❌ Too complex
def test_complex():
    for i in range(10):
        if i % 2 == 0:
            result = process(i)
            if result > 5:
                assert result < 10
```

---

### 🎯 Quick Testing Checklist

**Before committing code:**

```
✅ All tests pass
✅ New code has tests
✅ Tests use AAA pattern
✅ Tests are independent
✅ Tests have clear names
✅ Edge cases are tested
✅ Error cases are tested
✅ Coverage is acceptable (>80%)
✅ No skipped tests without reason
✅ Tests run fast (<1 second per test)
```

---

**🎯 Next:** We'll apply everything to real-world examples and practice exercises!

---

## 9. Real-World Testing & Exercises

### 🏗️ Testing an ETL Pipeline

**Complete ETL pipeline with tests:**

```python
# etl_pipeline.py
"""ETL Pipeline for data processing."""

import csv
import json
import logging
from pathlib import Path
from typing import List, Dict
import requests


class DataExtractor:
    """Extract data from various sources."""
  
    def extract_from_csv(self, filepath: str) -> List[Dict]:
        """Extract data from CSV file.
      
        Args:
            filepath: Path to CSV file
      
        Returns:
            List of dictionaries
      
        Raises:
            FileNotFoundError: If file doesn't exist
            ValueError: If CSV is invalid
        """
        path = Path(filepath)
      
        if not path.exists():
            raise FileNotFoundError(f"File not found: {filepath}")
      
        try:
            with open(path, 'r') as f:
                reader = csv.DictReader(f)
                return list(reader)
        except csv.Error as e:
            raise ValueError(f"Invalid CSV file: {e}")
  
    def extract_from_api(self, url: str) -> List[Dict]:
        """Extract data from API.
      
        Args:
            url: API endpoint URL
      
        Returns:
            List of dictionaries
      
        Raises:
            requests.RequestException: If API call fails
        """
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            logging.error(f"API call failed: {e}")
            raise


class DataTransformer:
    """Transform and clean data."""
  
    def clean_data(self, data: List[Dict]) -> List[Dict]:
        """Clean data by removing invalid entries.
      
        Args:
            data: List of data dictionaries
      
        Returns:
            Cleaned data list
        """
        cleaned = []
      
        for record in data:
            # Skip empty records
            if not record:
                continue
          
            # Skip records with missing required fields
            if 'id' not in record or 'name' not in record:
                logging.warning(f"Skipping record with missing fields: {record}")
                continue
          
            cleaned.append(record)
      
        return cleaned
  
    def transform_data(self, data: List[Dict]) -> List[Dict]:
        """Transform data to target format.
      
        Args:
            data: List of data dictionaries
      
        Returns:
            Transformed data list
        """
        transformed = []
      
        for record in data:
            transformed_record = {
                'id': int(record['id']),
                'name': record['name'].strip().title(),
                'email': record.get('email', '').lower(),
                'active': record.get('active', 'true').lower() == 'true'
            }
            transformed.append(transformed_record)
      
        return transformed


class DataLoader:
    """Load data to destination."""
  
    def load_to_json(self, data: List[Dict], filepath: str) -> bool:
        """Load data to JSON file.
      
        Args:
            data: Data to load
            filepath: Destination file path
      
        Returns:
            True if successful
      
        Raises:
            IOError: If write fails
        """
        try:
            path = Path(filepath)
            path.parent.mkdir(parents=True, exist_ok=True)
          
            with open(path, 'w') as f:
                json.dump(data, f, indent=2)
          
            logging.info(f"Data loaded to {filepath}")
            return True
        except IOError as e:
            logging.error(f"Failed to load data: {e}")
            raise


class ETLPipeline:
    """Complete ETL pipeline."""
  
    def __init__(self):
        """Initialize pipeline components."""
        self.extractor = DataExtractor()
        self.transformer = DataTransformer()
        self.loader = DataLoader()
  
    def run(self, source: str, destination: str, source_type: str = 'csv') -> Dict:
        """Run complete ETL pipeline.
      
        Args:
            source: Source location (file path or URL)
            destination: Destination file path
            source_type: Type of source ('csv' or 'api')
      
        Returns:
            Pipeline result statistics
        """
        try:
            # Extract
            logging.info(f"Extracting data from {source}")
            if source_type == 'csv':
                raw_data = self.extractor.extract_from_csv(source)
            elif source_type == 'api':
                raw_data = self.extractor.extract_from_api(source)
            else:
                raise ValueError(f"Unknown source type: {source_type}")
          
            # Transform
            logging.info("Transforming data")
            cleaned_data = self.transformer.clean_data(raw_data)
            transformed_data = self.transformer.transform_data(cleaned_data)
          
            # Load
            logging.info(f"Loading data to {destination}")
            self.loader.load_to_json(transformed_data, destination)
          
            # Return statistics
            return {
                'success': True,
                'records_extracted': len(raw_data),
                'records_loaded': len(transformed_data),
                'records_skipped': len(raw_data) - len(cleaned_data)
            }
      
        except Exception as e:
            logging.error(f"Pipeline failed: {e}")
            return {
                'success': False,
                'error': str(e)
            }
```

**Comprehensive tests for ETL pipeline:**

```python
# test_etl_pipeline.py
"""Tests for ETL pipeline."""

import pytest
import json
import csv
from pathlib import Path
from unittest.mock import Mock, patch, mock_open
import requests

from etl_pipeline import (
    DataExtractor,
    DataTransformer,
    DataLoader,
    ETLPipeline
)


# ==================== DataExtractor Tests ====================

class TestDataExtractor:
    """Tests for DataExtractor class."""
  
    @pytest.fixture
    def extractor(self):
        """Create DataExtractor instance."""
        return DataExtractor()
  
    @pytest.fixture
    def sample_csv_file(self, tmp_path):
        """Create sample CSV file."""
        csv_file = tmp_path / "data.csv"
        csv_file.write_text("id,name,email\n1,John,john@example.com\n2,Jane,jane@example.com")
        return str(csv_file)
  
    def test_extract_from_csv_success(self, extractor, sample_csv_file):
        """Test successful CSV extraction."""
        # ACT
        result = extractor.extract_from_csv(sample_csv_file)
      
        # ASSERT
        assert len(result) == 2
        assert result[0]['id'] == '1'
        assert result[0]['name'] == 'John'
        assert result[1]['name'] == 'Jane'
  
    def test_extract_from_csv_file_not_found(self, extractor):
        """Test CSV extraction with missing file."""
        with pytest.raises(FileNotFoundError, match="File not found"):
            extractor.extract_from_csv("nonexistent.csv")
  
    def test_extract_from_csv_invalid_format(self, extractor, tmp_path):
        """Test CSV extraction with invalid file."""
        invalid_file = tmp_path / "invalid.csv"
        invalid_file.write_text("not,a,valid,csv\n\n\n")
      
        # Should not raise error for this case
        result = extractor.extract_from_csv(str(invalid_file))
        assert isinstance(result, list)
  
    @patch('etl_pipeline.requests.get')
    def test_extract_from_api_success(self, mock_get, extractor):
        """Test successful API extraction."""
        # ARRANGE
        mock_response = Mock()
        mock_response.json.return_value = [
            {'id': 1, 'name': 'John'},
            {'id': 2, 'name': 'Jane'}
        ]
        mock_response.raise_for_status.return_value = None
        mock_get.return_value = mock_response
      
        # ACT
        result = extractor.extract_from_api("https://api.example.com/data")
      
        # ASSERT
        assert len(result) == 2
        assert result[0]['name'] == 'John'
        mock_get.assert_called_once()
  
    @patch('etl_pipeline.requests.get')
    def test_extract_from_api_failure(self, mock_get, extractor):
        """Test API extraction with request failure."""
        # ARRANGE
        mock_get.side_effect = requests.RequestException("API Error")
      
        # ACT & ASSERT
        with pytest.raises(requests.RequestException):
            extractor.extract_from_api("https://api.example.com/data")


# ==================== DataTransformer Tests ====================

class TestDataTransformer:
    """Tests for DataTransformer class."""
  
    @pytest.fixture
    def transformer(self):
        """Create DataTransformer instance."""
        return DataTransformer()
  
    def test_clean_data_removes_empty_records(self, transformer):
        """Test cleaning removes empty records."""
        # ARRANGE
        data = [
            {'id': '1', 'name': 'John'},
            {},  # Empty - should be removed
            {'id': '2', 'name': 'Jane'}
        ]
      
        # ACT
        result = transformer.clean_data(data)
      
        # ASSERT
        assert len(result) == 2
        assert all('id' in record for record in result)
  
    def test_clean_data_removes_invalid_records(self, transformer):
        """Test cleaning removes records with missing fields."""
        # ARRANGE
        data = [
            {'id': '1', 'name': 'John'},
            {'id': '2'},  # Missing 'name' - should be removed
            {'name': 'Jane'},  # Missing 'id' - should be removed
            {'id': '3', 'name': 'Bob'}
        ]
      
        # ACT
        result = transformer.clean_data(data)
      
        # ASSERT
        assert len(result) == 2
        assert result[0]['id'] == '1'
        assert result[1]['id'] == '3'
  
    def test_transform_data_converts_types(self, transformer):
        """Test transformation converts data types."""
        # ARRANGE
        data = [{'id': '1', 'name': '  john doe  ', 'email': 'JOHN@EXAMPLE.COM', 'active': 'true'}]
      
        # ACT
        result = transformer.transform_data(data)
      
        # ASSERT
        assert result[0]['id'] == 1  # Converted to int
        assert result[0]['name'] == 'John Doe'  # Title case
        assert result[0]['email'] == 'john@example.com'  # Lowercase
        assert result[0]['active'] == True  # Converted to bool
  
    def test_transform_data_handles_missing_fields(self, transformer):
        """Test transformation with missing optional fields."""
        # ARRANGE
        data = [{'id': '1', 'name': 'John'}]  # No email or active
      
        # ACT
        result = transformer.transform_data(data)
      
        # ASSERT
        assert result[0]['email'] == ''
        assert result[0]['active'] == True  # Default


# ==================== DataLoader Tests ====================

class TestDataLoader:
    """Tests for DataLoader class."""
  
    @pytest.fixture
    def loader(self):
        """Create DataLoader instance."""
        return DataLoader()
  
    def test_load_to_json_success(self, loader, tmp_path):
        """Test successful JSON loading."""
        # ARRANGE
        data = [{'id': 1, 'name': 'John'}, {'id': 2, 'name': 'Jane'}]
        output_file = tmp_path / "output.json"
      
        # ACT
        result = loader.load_to_json(data, str(output_file))
      
        # ASSERT
        assert result == True
        assert output_file.exists()
      
        # Verify content
        with open(output_file) as f:
            loaded_data = json.load(f)
        assert loaded_data == data
  
    def test_load_to_json_creates_directories(self, loader, tmp_path):
        """Test loading creates parent directories."""
        # ARRANGE
        data = [{'id': 1, 'name': 'John'}]
        output_file = tmp_path / "nested" / "dir" / "output.json"
      
        # ACT
        result = loader.load_to_json(data, str(output_file))
      
        # ASSERT
        assert result == True
        assert output_file.exists()
        assert output_file.parent.exists()


# ==================== ETLPipeline Integration Tests ====================

class TestETLPipeline:
    """Integration tests for complete ETL pipeline."""
  
    @pytest.fixture
    def pipeline(self):
        """Create ETLPipeline instance."""
        return ETLPipeline()
  
    @pytest.fixture
    def sample_csv(self, tmp_path):
        """Create sample CSV for testing."""
        csv_file = tmp_path / "input.csv"
        content = "id,name,email,active\n1,john doe,JOHN@EXAMPLE.COM,true\n2,jane smith,JANE@EXAMPLE.COM,false"
        csv_file.write_text(content)
        return str(csv_file)
  
    def test_pipeline_run_csv_success(self, pipeline, sample_csv, tmp_path):
        """Test complete pipeline execution with CSV."""
        # ARRANGE
        output_file = tmp_path / "output.json"
      
        # ACT
        result = pipeline.run(sample_csv, str(output_file), source_type='csv')
      
        # ASSERT
        assert result['success'] == True
        assert result['records_extracted'] == 2
        assert result['records_loaded'] == 2
        assert output_file.exists()
      
        # Verify output content
        with open(output_file) as f:
            data = json.load(f)
        assert len(data) == 2
        assert data[0]['name'] == 'John Doe'  # Transformed
        assert data[0]['email'] == 'john@example.com'  # Lowercase
  
    @patch('etl_pipeline.requests.get')
    def test_pipeline_run_api_success(self, mock_get, pipeline, tmp_path):
        """Test complete pipeline execution with API."""
        # ARRANGE
        mock_response = Mock()
        mock_response.json.return_value = [
            {'id': '1', 'name': 'john', 'email': 'JOHN@EXAMPLE.COM'}
        ]
        mock_response.raise_for_status.return_value = None
        mock_get.return_value = mock_response
      
        output_file = tmp_path / "output.json"
      
        # ACT
        result = pipeline.run(
            "https://api.example.com/data",
            str(output_file),
            source_type='api'
        )
      
        # ASSERT
        assert result['success'] == True
        assert result['records_extracted'] == 1
        assert result['records_loaded'] == 1
  
    def test_pipeline_run_invalid_source_type(self, pipeline, tmp_path):
        """Test pipeline with invalid source type."""
        # ACT
        result = pipeline.run("source", str(tmp_path / "output.json"), source_type='invalid')
      
        # ASSERT
        assert result['success'] == False
        assert 'error' in result
  
    def test_pipeline_run_file_not_found(self, pipeline, tmp_path):
        """Test pipeline with missing source file."""
        # ACT
        result = pipeline.run("nonexistent.csv", str(tmp_path / "output.json"))
      
        # ASSERT
        assert result['success'] == False
        assert 'error' in result
```

---

### 🎓 Practice Exercises

**Exercise 1: Test a Data Validator**

```python
# data_validator.py
"""Data validator to test."""

def validate_user_data(data):
    """Validate user data.
  
    Rules:
    - name: required, 2-50 characters
    - email: required, valid format
    - age: required, 18-120
    - phone: optional, 10 digits if provided
  
    Returns:
        tuple: (is_valid, error_messages)
    """
    errors = []
  
    # Validate name
    if 'name' not in data:
        errors.append("Name is required")
    elif len(data['name']) < 2 or len(data['name']) > 50:
        errors.append("Name must be 2-50 characters")
  
    # Validate email
    if 'email' not in data:
        errors.append("Email is required")
    elif '@' not in data['email'] or '.' not in data['email']:
        errors.append("Email format is invalid")
  
    # Validate age
    if 'age' not in data:
        errors.append("Age is required")
    elif not isinstance(data['age'], int) or data['age'] < 18 or data['age'] > 120:
        errors.append("Age must be between 18 and 120")
  
    # Validate phone (optional)
    if 'phone' in data and data['phone']:
        if not data['phone'].isdigit() or len(data['phone']) != 10:
            errors.append("Phone must be 10 digits")
  
    return (len(errors) == 0, errors)


# TODO: Write comprehensive tests for validate_user_data
# Hint: Test valid data, missing fields, invalid formats, edge cases
```

**Exercise 2: Test a Report Generator**

```python
# report_generator.py
"""Report generator to test."""

from datetime import datetime
from typing import List, Dict

def generate_sales_report(sales_data: List[Dict]) -> Dict:
    """Generate sales report from data.
  
    Args:
        sales_data: List of sale dictionaries with 'amount', 'date', 'product'
  
    Returns:
        Report dictionary with statistics
    """
    if not sales_data:
        return {
            'total_sales': 0,
            'average_sale': 0,
            'total_transactions': 0,
            'top_product': None
        }
  
    # Calculate statistics
    total = sum(sale['amount'] for sale in sales_data)
    average = total / len(sales_data)
  
    # Find top product
    product_counts = {}
    for sale in sales_data:
        product = sale['product']
        product_counts[product] = product_counts.get(product, 0) + 1
  
    top_product = max(product_counts, key=product_counts.get)
  
    return {
        'total_sales': round(total, 2),
        'average_sale': round(average, 2),
        'total_transactions': len(sales_data),
        'top_product': top_product
    }


# TODO: Write tests for generate_sales_report
# Hint: Test empty data, single sale, multiple sales, edge cases
```

**Exercise 3: Test with Mocking**

```python
# notification_service.py
"""Notification service to test."""

import smtplib
import requests

class NotificationService:
    """Send notifications via email and SMS."""
  
    def send_email_notification(self, to_email, subject, body):
        """Send email notification."""
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login('user@gmail.com', 'password')
        message = f"Subject: {subject}\n\n{body}"
        server.sendmail('user@gmail.com', to_email, message)
        server.quit()
        return True
  
    def send_sms_notification(self, phone_number, message):
        """Send SMS via API."""
        response = requests.post(
            'https://api.sms.com/send',
            json={'to': phone_number, 'message': message}
        )
        response.raise_for_status()
        return response.json()
  
    def notify_user(self, user_data, notification_type, message):
        """Send notification to user."""
        if notification_type == 'email':
            return self.send_email_notification(
                user_data['email'],
                'Notification',
                message
            )
        elif notification_type == 'sms':
            return self.send_sms_notification(
                user_data['phone'],
                message
            )
        else:
            raise ValueError(f"Unknown notification type: {notification_type}")


# TODO: Write tests using mocks
# Hint: Mock smtplib and requests, test both notification types
```

---

### ✅ Exercise Solutions

**Solution 1: Data Validator Tests**

```python
# test_data_validator.py
"""Tests for data validator."""

import pytest
from data_validator import validate_user_data


class TestValidateUserData:
    """Tests for validate_user_data function."""
  
    def test_valid_data_complete(self):
        """Test with all valid data."""
        data = {
            'name': 'John Doe',
            'email': 'john@example.com',
            'age': 30,
            'phone': '1234567890'
        }
        is_valid, errors = validate_user_data(data)
        assert is_valid == True
        assert len(errors) == 0
  
    def test_valid_data_without_optional_phone(self):
        """Test valid data without optional phone."""
        data = {
            'name': 'Jane Smith',
            'email': 'jane@example.com',
            'age': 25
        }
        is_valid, errors = validate_user_data(data)
        assert is_valid == True
  
    def test_missing_name(self):
        """Test with missing name."""
        data = {'email': 'test@example.com', 'age': 30}
        is_valid, errors = validate_user_data(data)
        assert is_valid == False
        assert "Name is required" in errors
  
    def test_invalid_name_too_short(self):
        """Test with name too short."""
        data = {'name': 'A', 'email': 'test@example.com', 'age': 30}
        is_valid, errors = validate_user_data(data)
        assert is_valid == False
        assert "Name must be 2-50 characters" in errors
  
    def test_invalid_email_format(self):
        """Test with invalid email."""
        data = {'name': 'John', 'email': 'notanemail', 'age': 30}
        is_valid, errors = validate_user_data(data)
        assert is_valid == False
        assert "Email format is invalid" in errors
  
    @pytest.mark.parametrize("age,should_be_valid", [
        (17, False),  # Too young
        (18, True),   # Min valid
        (30, True),   # Normal
        (120, True),  # Max valid
        (121, False), # Too old
    ])
    def test_age_boundaries(self, age, should_be_valid):
        """Test age boundary conditions."""
        data = {'name': 'John', 'email': 'john@example.com', 'age': age}
        is_valid, errors = validate_user_data(data)
        assert is_valid == should_be_valid
  
    def test_invalid_phone_format(self):
        """Test with invalid phone."""
        data = {
            'name': 'John',
            'email': 'john@example.com',
            'age': 30,
            'phone': '123'  # Too short
        }
        is_valid, errors = validate_user_data(data)
        assert is_valid == False
        assert "Phone must be 10 digits" in errors
```

**Key Takeaways:**

- Test all validation rules
- Test boundary conditions
- Use parametrize for multiple test cases
- Test both valid and invalid data

---

### 🎯 Final Summary

**What You've Learned:**

1. **Testing Fundamentals**

   - Why testing matters
   - Types of tests (unit, integration, E2E)
   - pytest vs unittest
2. **Core Testing Skills**

   - Writing tests with assert
   - Testing functions and classes
   - Testing exceptions
   - Edge case testing
3. **Advanced Techniques**

   - Fixtures for reusable setup
   - Parametrized tests for multiple cases
   - Mocking external dependencies
   - Test organization and best practices
4. **Real-World Application**

   - ETL pipeline testing
   - Integration testing
   - Practice exercises

**Testing Mindset:**

- ✅ Test before you commit
- ✅ Test edge cases
- ✅ Test error conditions
- ✅ Keep tests simple and focused
- ✅ Make tests independent
- ✅ Use descriptive names
- ✅ Aim for good coverage (>80%)

**Next Steps:**

1. Practice writing tests for your code
2. Add tests to existing projects
3. Learn pytest plugins
4. Explore test-driven development (TDD)
5. Study continuous integration (CI)

---

🎉 **Congratulations!** You now have comprehensive knowledge of testing with pytest!
