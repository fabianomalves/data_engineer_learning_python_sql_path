# Module 2: Python Essentials for Data Engineering

## Overview

This module covers essential Python skills for data engineering, from fundamentals to advanced topics. You'll learn how to work with files, databases, and build robust data pipelines.

**Duration:** ~8-10 weeks  
**Difficulty:** Beginner to Intermediate  
**Prerequisites:** Module 1 (SQL Fundamentals) completed

---

## Learning Objectives

By the end of this module, you will be able to:

- ✅ Write clean, efficient Python code following best practices
- ✅ Work with various data formats (CSV, JSON, Parquet)
- ✅ Connect to databases and perform CRUD operations
- ✅ Apply Object-Oriented Programming principles to data pipelines
- ✅ Handle errors gracefully and implement logging
- ✅ Write tests to ensure code quality
- ✅ Build production-ready data engineering solutions

---

## Module Structure

### **Lesson 1: Python Fundamentals** ✅
**File:** `01_python_fundamentals.md`  
**Duration:** 1-2 weeks

Master Python basics essential for data engineering:
- Data types and structures (lists, dicts, sets, tuples)
- Control flow (if/else, loops)
- Functions and lambda expressions
- List and dictionary comprehensions
- String manipulation
- Built-in functions for data processing
- 10 practice exercises

**Why This Matters:** Foundation for all data engineering work. These concepts are used daily in ETL pipelines, data transformations, and automation scripts.

---

### **Lesson 2: Files and Data Formats** ✅
**File:** `02_files_data_formats.md`  
**Duration:** 1-2 weeks

Learn to work with files and common data formats:
- Modern file path management with `pathlib`
- Reading and writing CSV files
- Working with JSON data
- Parquet files for big data
- Context managers and resource management
- Best practices for file I/O

**Why This Matters:** Data engineers constantly read from and write to various file formats. Understanding these formats is crucial for building data pipelines.

---

### **Lesson 3: Database Connectivity with Python** ✅
**File:** `03_database_connectivity.md`  
**Duration:** 1-2 weeks

Connect Python to PostgreSQL and work with databases:
- PostgreSQL connectivity with psycopg2
- Parameterized queries and SQL injection prevention
- Transaction management
- SQLAlchemy Core (Expression Language)
- SQLAlchemy ORM (Object-Relational Mapping)
- Connection pooling for production
- Integration with pandas DataFrames

**Why This Matters:** Databases are at the heart of data engineering. You'll learn how to efficiently query, transform, and load data using Python and SQL together.

**Note:** pandas is recommended for small datasets (<1GB) and data exploration. For big data production workloads, use Polars or DuckDB (covered in later modules).

---

### **Lesson 4: Object-Oriented Programming (OOP)** ✅
**File:** `04_object_oriented_programming.md`  
**Duration:** 1-2 weeks

Master OOP concepts essential for understanding data engineering frameworks:
- Classes and objects (blueprints vs instances)
- `__init__` constructor and `self` parameter
- Instance, class, and static methods
- Encapsulation (public, protected, private)
- Properties and getters/setters
- Inheritance and code reuse
- Polymorphism and method overriding
- Special methods (dunder methods)
- Abstract base classes
- ETL pipeline design patterns

**Why This Matters:** Modern data engineering libraries (SQLAlchemy, PySpark, Airflow) heavily use OOP. Understanding these concepts is essential before working with ORMs and building scalable data pipelines.

**Important:** This lesson should be studied BEFORE diving deep into SQLAlchemy ORM patterns, as it provides the foundation for understanding Model classes, relationships, and inheritance used in database ORMs.

---

### **Lesson 5: Error Handling and Logging**
**File:** `05_error_handling_logging.md`  
**Duration:** 1 week

Build robust applications with proper error handling:
- Try/except blocks and exception types
- Custom exception classes (using OOP inheritance!)
- Error handling in class methods
- Logging with Python's logging module
- Class-based loggers
- Log levels and formatting
- Handling errors in data pipelines

**Why This Matters:** Production data pipelines must handle errors gracefully. Proper logging helps debug issues and monitor pipeline health.

---

### **Lesson 6: Testing with pytest**
**File:** `06_testing_pytest.md`  
**Duration:** 1 week

Write tests to ensure code quality:
- Unit testing basics
- pytest framework
- Testing classes and methods
- Fixtures and test setup
- Mocking database connections
- Testing data transformations
- Test-driven development (TDD)

**Why This Matters:** Professional data engineers write tests. Tests prevent bugs, document behavior, and enable safe refactoring.

---

## Recommended Learning Path

1. **Start with Lesson 1** - Build your Python foundation
2. **Progress to Lesson 2** - Learn file handling and data formats
3. **Move to Lesson 3** - Connect to databases and work with SQL
4. **Study Lesson 4** - Master OOP concepts (prerequisite for advanced patterns)
5. **Continue to Lesson 5** - Add error handling and logging
6. **Finish with Lesson 6** - Write tests for your code

**Important Note on Lesson Order:** Lesson 4 (OOP) is positioned before Lesson 5 (Error Handling) because understanding OOP concepts is essential for working with:
- SQLAlchemy ORM models and relationships (from Lesson 3)
- Custom exception classes (in Lesson 5)
- Class-based loggers (in Lesson 5)
- pytest fixtures and test classes (in Lesson 6)

---

## Practice Projects

After completing this module, apply your skills to:

1. **CSV to Database ETL**
   - Read CSV files
   - Transform data
   - Load to PostgreSQL
   - Add error handling and logging

2. **Data Quality Checker**
   - Validate data using OOP principles
   - Check for missing values, outliers
   - Generate quality reports
   - Use custom exceptions

3. **API Data Pipeline**
   - Fetch data from REST API
   - Transform JSON to structured format
   - Store in database
   - Test all components

---

## Tools and Technologies

This module uses:
- **Python 3.10+** - Modern Python features
- **PostgreSQL 15+** - Relational database
- **psycopg2** - PostgreSQL adapter
- **SQLAlchemy** - SQL toolkit and ORM
- **pandas** - For small datasets and exploration (<1GB)
- **pyarrow** - For Parquet files
- **pytest** - Testing framework

**Future Modules Will Cover:**
- **Polars** - High-performance DataFrame library (big data)
- **DuckDB** - In-process SQL OLAP database (big data)
- **Apache Airflow** - Workflow orchestration
- **PySpark** - Distributed data processing

---

## Assessment

You'll know you've mastered this module when you can:

- ✅ Write clean, readable Python code
- ✅ Work with CSV, JSON, and Parquet files
- ✅ Connect to databases and perform queries
- ✅ Design class hierarchies using OOP principles
- ✅ Handle errors and implement logging
- ✅ Write comprehensive tests
- ✅ Build a complete ETL pipeline from scratch

---

## Next Module

**Module 3: Advanced Python & Data Processing**
- Advanced pandas techniques (for small data)
- Introduction to Polars (for big data)
- DuckDB for SQL on large files
- Parallel processing
- Performance optimization

---

**Let's get started! Begin with [Lesson 1: Python Fundamentals](01_python_fundamentals.md)** 🚀

---

## 🎯 **Learning Objectives**

By the end of this module, you will:

✅ Write clean, idiomatic Python code  
✅ Work with virtual environments and package management  
✅ Connect to databases using psycopg2 and SQLAlchemy  
✅ Manipulate data with Python data structures  
✅ Handle files (CSV, JSON, Parquet)  
✅ Implement error handling and logging  
✅ Write testable, reusable functions  
✅ Understand Python object-oriented programming basics  
✅ Use list comprehensions and generators efficiently  

---

## 📚 **Module Structure**

### **Lesson 1: Python Fundamentals Review**
- Variables and data types
- Control flow (if/else, loops)
- Functions and parameters
- List comprehensions
- Dictionary and set operations
- String manipulation
- **Duration**: 2 hours

### **Lesson 2: Working with Files & Data Formats**
- Reading/writing CSV files
- JSON parsing and creation
- Parquet files with pyarrow
- File path management (pathlib)
- Context managers (with statement)
- **Duration**: 2.5 hours

### **Lesson 3: Database Connectivity with Python**
- psycopg2 for PostgreSQL
- SQLAlchemy basics
- Connection pooling
- Parameterized queries (SQL injection prevention)
- Transactions in Python
- **Duration**: 2.5 hours

### **Lesson 4: Error Handling & Logging**
- Try/except/finally blocks
- Custom exceptions
- Python logging module
- Debugging techniques
- Best practices for production code
- **Duration**: 2 hours

### **Lesson 5: Object-Oriented Programming for Data Engineering**
- Classes and objects
- Inheritance and composition
- Data classes (dataclasses)
- Building reusable components
- Design patterns for pipelines
- **Duration**: 2.5 hours

### **Lesson 6: Testing with pytest**
- Writing unit tests
- Test fixtures
- Mocking external dependencies
- Test coverage
- TDD workflow
- **Duration**: 2.5 hours

---

## 🗄️ **Project Integration**

Throughout this module, you'll build Python utilities for the **Brazilian Outdoor Adventure Platform**:

1. **Database Connection Manager** - Reusable PostgreSQL connector
2. **CSV Data Loader** - Import outdoor gear data from files
3. **Weather API Client** - Fetch weather data for locations
4. **Data Validator** - Check data quality before insertion
5. **ETL Script** - Extract, transform, load pipeline
6. **Test Suite** - Comprehensive tests for all components

---

## 💻 **Prerequisites**

- Python 3.10+ installed
- PostgreSQL database from Module 1
- Basic programming knowledge
- VS Code or preferred IDE

---

## 📖 **Lesson Files**

- `01_python_fundamentals.md` - Python basics review
- `02_files_and_data_formats.md` - Working with data files
- `03_database_connectivity.md` - Python ↔ PostgreSQL
- `04_error_handling_logging.md` - Robust code practices
- `05_object_oriented_programming.md` - OOP for data engineering
- `06_testing_with_pytest.md` - Test-driven development

---

## 🎯 **Practice Projects**

### **Project 1: Database Manager Class**
Create a reusable `DatabaseManager` class that:
- Handles connections and disconnections
- Provides query execution methods
- Implements connection pooling
- Logs all operations

### **Project 2: Weather Data ETL**
Build a Python script that:
- Fetches weather data from an API
- Transforms data into proper format
- Loads into PostgreSQL
- Handles errors gracefully
- Logs the entire process

### **Project 3: Gear Price Scraper**
Create a web scraper that:
- Extracts gear prices from Brazilian e-commerce
- Parses HTML data
- Stores in database
- Runs on schedule
- Includes comprehensive tests

---

## ✅ **Module Completion Checklist**

- [ ] Set up Python virtual environment
- [ ] Install all required packages
- [ ] Write basic Python scripts
- [ ] Connect to PostgreSQL from Python
- [ ] Execute queries and fetch results
- [ ] Read/write CSV and JSON files
- [ ] Implement proper error handling
- [ ] Use logging for debugging
- [ ] Create reusable classes
- [ ] Write unit tests with pytest
- [ ] Build complete ETL script
- [ ] Complete all practice questions

---

## 📚 **Key Python Libraries**

```python
# Database
psycopg2-binary==2.9.9
SQLAlchemy==2.0.23

# Data Processing
pandas==2.1.3
numpy==1.26.2

# File Formats
pyarrow==14.0.1

# Testing
pytest==7.4.3
pytest-cov==4.1.0

# Utilities
python-dotenv==1.0.0
requests==2.31.0
```

---

## 📚 **Additional Resources**

- [Python Official Tutorial](https://docs.python.org/3/tutorial/)
- [Real Python](https://realpython.com/)
- [psycopg2 Documentation](https://www.psycopg.org/docs/)
- [SQLAlchemy Tutorial](https://docs.sqlalchemy.org/en/20/tutorial/)
- [pytest Documentation](https://docs.pytest.org/)

---

## 🚀 **Next Module**

After completing this module, proceed to:
**Module 3: Setting Up Your Development Environment**

---

**Let's start with Lesson 1: Python Fundamentals Review!**
