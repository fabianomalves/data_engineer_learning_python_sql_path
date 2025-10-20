# Lesson 6: Testing with pytest - Complete Overview

## 📖 Introduction

Welcome to **Lesson 6: Testing with pytest**! This comprehensive lesson teaches you how to write professional, maintainable tests for your Python applications using pytest, the industry-standard testing framework.

**Why This Lesson Matters:**
- Production code **must** have tests - learn to write them effectively
- Tests catch bugs before they reach production
- Well-tested code is easier to refactor and maintain
- pytest makes testing fast, simple, and powerful
- Professional developers write tests - it's not optional

---

## 📊 Lesson Statistics

| Metric | Value |
|--------|-------|
| **Total Lines** | 5,907 lines |
| **Sections** | 9 comprehensive sections |
| **Code Examples** | 80+ working examples |
| **Practice Exercises** | 3 with complete solutions |
| **Estimated Study Time** | 10-14 hours |
| **Difficulty Level** | Intermediate to Advanced |
| **Prerequisites** | Lessons 1-5 completed |

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

✅ **Testing Fundamentals:**
- Understand why testing is critical for production code
- Explain the testing pyramid (unit, integration, E2E tests)
- Install and configure pytest
- Write basic tests with assert statements
- Run tests and interpret results
- Organize tests effectively

✅ **pytest Core Features:**
- Use fixtures to eliminate code duplication
- Master fixture scopes (function, class, module, session)
- Share fixtures via conftest.py
- Write parametrized tests to test multiple inputs efficiently
- Use test markers to organize and filter tests
- Skip and xfail tests conditionally

✅ **Advanced Testing:**
- Mock external dependencies (APIs, databases, file systems)
- Use unittest.mock and patch decorator
- Verify mock calls and return values
- Test classes and object-oriented code
- Test exception handling properly
- Test edge cases and boundary conditions

✅ **Professional Practices:**
- Follow the AAA pattern (Arrange-Act-Assert)
- Write meaningful test names
- Keep tests independent and isolated
- Measure code coverage
- Build real-world ETL pipeline tests
- Apply industry best practices

---

## 📚 Lesson Structure

### **Section 1: Introduction to Testing & pytest** (~394 lines)

**What You'll Learn:**
- The cost of bugs in production vs catching them early
- Why automated testing is essential
- The testing pyramid strategy
- pytest vs unittest comparison

**Key Topics:**
- Real-world problem/solution comparison (divide by zero example)
- Testing pyramid: 70% unit, 25% integration, 5% E2E
- Types of tests: unit, integration, functional, regression
- pytest advantages: simple syntax, powerful features, rich ecosystem
- Installation with virtual environments
- Project structure recommendations
- Test discovery rules and naming conventions

**Practical Skills:**
- Install pytest and pytest plugins
- Understand when to use different test types
- Organize test files in your projects
- Configure pytest with pytest.ini

---

### **Section 2: Writing Your First Tests** (~521 lines)

**What You'll Learn:**
- Create your first test functions
- Use Python's assert statement effectively
- Run tests and interpret output
- Handle test failures

**Key Topics:**
- Creating simple calculator tests
- Assert statement patterns (equality, inequality, membership, type checking)
- pytest vs unittest assertion comparison
- Better error messages with pytest
- Organizing multiple tests logically
- Test failure output interpretation
- Command line options: -v, -vv, -s, -x, -k, --lf, --ff
- Running specific tests and test patterns

**Practical Skills:**
- Write test functions with assert
- Group related tests together
- Run tests in various ways
- Debug test failures effectively
- Use pytest's rich output to find problems

---

### **Section 3: Testing Functions** (~652 lines)

**What You'll Learn:**
- Test functions with different input types
- Handle edge cases and boundaries
- Test exception raising properly
- Test return values and side effects

**Key Topics:**
- Data validation testing (age, email, price parsing)
- Testing with valid, invalid, and edge case inputs
- Type validation tests
- Edge cases: empty inputs, zero values, boundaries, single elements
- Text processing edge cases (truncation, chunking)
- Exception testing with pytest.raises()
- Multiple assertion patterns
- Testing file operations

**Practical Skills:**
- Test all input scenarios comprehensively
- Identify and test edge cases
- Verify exceptions are raised correctly
- Test both happy path and error cases
- Write thorough validation tests

---

### **Section 4: Testing Classes** (~602 lines)

**What You'll Learn:**
- Test class initialization (__init__)
- Test instance methods and properties
- Test class methods and static methods
- Test state changes

**Key Topics:**
- BankAccount class: testing __init__, deposit, withdraw, get_balance
- Testing class properties (getters and setters with validation)
- User class with property validation (age, email)
- DataProcessor: testing class methods and static methods
- Testing special methods (__str__, __repr__)
- Testing state changes across multiple operations
- Integration tests for complete workflows

**Practical Skills:**
- Create test instances in each test
- Test object initialization with various inputs
- Verify methods update state correctly
- Test property validation rules
- Test static and class methods appropriately

---

### **Section 5: Fixtures and Setup** (~702 lines)

**What You'll Learn:**
- Eliminate code duplication with fixtures
- Use different fixture scopes
- Share fixtures via conftest.py
- Implement setup and teardown with yield

**Key Topics:**
- Problem: repetitive setup code
- Solution: @pytest.fixture decorator
- Basic fixture examples (sample data, test objects)
- Fixture scopes: function (default), class, module, session
- When to use each scope (performance vs isolation)
- Database connection fixture with session scope
- conftest.py for project-wide fixtures
- Yield fixtures for cleanup (setup/teardown pattern)
- Fixture dependencies (fixtures using other fixtures)
- Built-in fixtures: tmp_path, tmp_path_factory

**Practical Skills:**
- Create reusable fixtures
- Choose appropriate fixture scopes
- Organize fixtures in conftest.py
- Implement proper cleanup with yield
- Build complex fixture dependencies

---

### **Section 6: Parametrized Tests** (~652 lines)

**What You'll Learn:**
- Run the same test with multiple inputs
- Use @pytest.mark.parametrize decorator
- Create test matrices with multiple decorators
- Customize test IDs for readability

**Key Topics:**
- Problem: 5 tests for same logic (bad)
- Solution: 1 parametrized test (good)
- Basic parametrization syntax
- Testing string operations (upper, length, substring)
- Data validation with parametrized tests
- Custom IDs for better test output
- Multiple parametrize decorators (test matrices)
- Data-driven testing patterns
- Date parsing, phone cleaning, grade calculation examples
- Parametrized fixtures for testing with different configurations

**Practical Skills:**
- Write one test that covers many scenarios
- Test edge cases efficiently
- Make test output readable with custom IDs
- Create test matrices for thorough coverage
- Apply data-driven testing patterns

---

### **Section 7: Mocking and Patching** (~752 lines)

**What You'll Learn:**
- Why mocking is essential
- Use unittest.mock.Mock objects
- Apply @patch decorator
- Mock external dependencies

**Key Topics:**
- Problem: testing code with external dependencies
- unittest.mock basics: Mock, MagicMock
- Setting return values and side effects
- Checking mock calls and arguments
- @patch decorator for replacing objects
- Patching as context manager
- Mocking external API calls (weather service example)
- Mocking database operations (user service example)
- Mock assertions: assert_called_once, assert_called_with
- Simulating errors with side_effect

**Practical Skills:**
- Mock API calls to avoid network dependencies
- Mock database operations for fast tests
- Verify code calls external services correctly
- Test error handling without real failures
- Keep tests fast and isolated

---

### **Section 8: Test Organization & Best Practices** (~604 lines)

**What You'll Learn:**
- Follow the AAA pattern
- Write meaningful test names
- Keep tests independent
- Use markers to organize tests
- Measure code coverage

**Key Topics:**
- AAA pattern: Arrange-Act-Assert (structure every test)
- Test naming conventions and patterns
- Test independence principles (avoid shared state)
- Markers: @pytest.mark.slow, @pytest.mark.integration, custom markers
- Running tests by marker (-m flag)
- Skip and XFail: @pytest.mark.skip, @pytest.mark.skipif, @pytest.mark.xfail
- Code coverage with pytest-cov
- Coverage reports (terminal, HTML)
- Best practices summary (8 key principles)
- Testing checklist for code reviews

**Practical Skills:**
- Structure tests with AAA pattern
- Write descriptive, maintainable test names
- Organize tests with markers
- Skip platform-specific tests
- Measure and improve code coverage
- Follow professional testing standards

---

### **Section 9: Real-World Testing & Exercises** (~904 lines)

**What You'll Learn:**
- Test a complete ETL pipeline
- Write integration tests
- Practice with realistic scenarios
- Apply all concepts together

**Key Topics:**

**Complete ETL Pipeline Testing:**
- DataExtractor class (CSV and API extraction)
- DataTransformer class (cleaning and transformation)
- DataLoader class (JSON output)
- ETLPipeline integration class
- Comprehensive test suite (30+ tests)
- Testing with tmp_path fixture
- Mocking API calls in tests
- Testing error scenarios
- Integration tests for full pipeline

**Practice Exercises (with solutions):**
1. **Data Validator** - Test validate_user_data function
   - Test required fields, formats, boundaries
   - Use parametrization for age boundaries
   - Solution with 10+ test cases

2. **Report Generator** - Test sales report generation
   - Test empty data, single sale, multiple sales
   - Test statistics calculations
   - Solution with edge cases

3. **Notification Service** - Test with mocks
   - Mock email and SMS sending
   - Test both notification types
   - Verify external services called correctly

**Practical Skills:**
- Test complete applications end-to-end
- Write integration tests that verify component interactions
- Mock multiple dependencies in complex code
- Build comprehensive test suites
- Apply all pytest features in real scenarios

---

## 🛠️ Technical Requirements

**Python Version:**
- Python 3.8+ (examples use 3.10+ features where applicable)

**Required Libraries:**
```bash
# Install pytest and plugins
pip install pytest==7.4.3
pip install pytest-cov==4.1.0    # Code coverage
pip install pytest-mock==3.12.0  # Mocking utilities
```

**Standard Library Imports:**
```python
from unittest.mock import Mock, patch, MagicMock
from pathlib import Path
import json
import csv
import sqlite3
from datetime import datetime
from typing import List, Dict, Optional
```

**Project Structure:**
```
my_project/
├── src/
│   ├── __init__.py
│   ├── calculator.py
│   └── etl.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py          # Shared fixtures
│   ├── test_calculator.py
│   └── test_etl.py
├── pytest.ini               # pytest configuration
└── requirements-test.txt    # Test dependencies
```

---

## 📖 How to Use This Lesson

### **Recommended Approach:**

1. **Read Sequentially** - Each section builds on previous concepts
2. **Code Along** - Type and run every example
3. **Run Tests** - See green ✅ and red ❌ tests yourself
4. **Experiment** - Break tests to see what happens
5. **Practice** - Complete all three exercises

### **Study Schedule:**

**Day 1-2: Testing Basics (Sections 1-2)**
- Understand why testing matters
- Write first tests with assert
- Learn pytest basics
- Run tests various ways

**Day 3-4: Function & Class Testing (Sections 3-4)**
- Test functions thoroughly
- Handle edge cases
- Test classes and OOP code
- Practice with examples

**Day 5-6: Fixtures & Parametrization (Sections 5-6)**
- Master fixtures and scopes
- Write parametrized tests
- Use conftest.py
- Eliminate duplication

**Day 7-8: Mocking & Best Practices (Sections 7-8)**
- Mock external dependencies
- Follow AAA pattern
- Use markers and coverage
- Professional testing practices

**Day 9-10: Real-World & Practice (Section 9)**
- Test ETL pipeline
- Complete exercises
- Integration testing
- Final review

### **For Quick Reference:**

Jump to specific sections when you need to:
- **Write your first test?** → Section 2
- **Test a class?** → Section 4
- **Avoid code duplication?** → Section 5
- **Test many inputs?** → Section 6
- **Mock an API?** → Section 7
- **Organize tests?** → Section 8
- **See complete example?** → Section 9

---

## 💡 Key Takeaways

### **Testing Principles:**

1. **Test Early, Test Often**
   - Write tests as you write code
   - Tests catch bugs before production
   - Testing mindset improves code design

2. **Keep Tests Simple**
   - One test tests one thing
   - Use AAA pattern for clarity
   - Clear names describe what's tested

3. **Test Independence**
   - Tests don't depend on each other
   - Tests can run in any order
   - Each test has its own setup

4. **Mock External Dependencies**
   - Don't test external services
   - Mock APIs, databases, file systems
   - Tests should be fast and reliable

### **pytest Best Practices:**

1. **Use Fixtures Wisely**
   - Fixtures eliminate duplication
   - Choose appropriate scopes
   - Share via conftest.py
   - Use yield for cleanup

2. **Parametrize for Efficiency**
   - One test, many inputs
   - Test edge cases easily
   - Readable with custom IDs
   - Saves time and code

3. **Organize with Markers**
   - Mark slow tests
   - Separate unit and integration
   - Run subsets when needed
   - Document test types

4. **Aim for Good Coverage**
   - 80%+ coverage is good
   - 100% isn't always necessary
   - Cover critical paths
   - Test edge cases

---

## 🎯 Real-World Applications

This lesson's concepts are used daily in:

**Data Engineering:**
- Testing ETL pipelines
- Validating data transformations
- Testing database operations
- Verifying API integrations
- Testing data quality checks

**Software Development:**
- Unit testing application logic
- Integration testing microservices
- Testing API endpoints
- Validating business rules
- Regression testing

**Examples from the Lesson:**
- ETL pipeline with 30+ tests (Section 9)
- API mocking for weather service (Section 7)
- Database mocking for user service (Section 7)
- Data validator with parametrization (Section 6)
- BankAccount class testing (Section 4)

---

## ✅ Self-Assessment Checklist

After completing this lesson, you should be able to:

### **Basic Testing:**
- [ ] Write test functions with assert statements
- [ ] Run tests with pytest command
- [ ] Interpret test output and failures
- [ ] Test functions with different inputs
- [ ] Test exception raising with pytest.raises()

### **pytest Features:**
- [ ] Create and use fixtures
- [ ] Understand fixture scopes
- [ ] Share fixtures via conftest.py
- [ ] Write parametrized tests
- [ ] Use test markers
- [ ] Skip and xfail tests conditionally

### **Advanced Techniques:**
- [ ] Mock external APIs with @patch
- [ ] Mock database operations
- [ ] Verify mock calls
- [ ] Test classes and OOP code
- [ ] Test property setters
- [ ] Test static and class methods

### **Professional Practices:**
- [ ] Follow AAA pattern
- [ ] Write meaningful test names
- [ ] Keep tests independent
- [ ] Measure code coverage
- [ ] Organize tests effectively
- [ ] Apply best practices

### **Real-World Skills:**
- [ ] Test ETL pipelines
- [ ] Write integration tests
- [ ] Mock multiple dependencies
- [ ] Test with temporary files
- [ ] Build comprehensive test suites

---

## 🚀 Next Steps

### **After This Lesson:**

1. **Add Tests to Previous Lessons:**
   - Test your Lesson 4 OOP code
   - Test your Lesson 5 error handling
   - Test database operations from Lesson 3

2. **Practice Projects:**
   - Test the practice_project_01_etl_system.py
   - Add tests to your own projects
   - Aim for 80%+ coverage

3. **Explore pytest Plugins:**
   - pytest-xdist: Run tests in parallel
   - pytest-timeout: Set test timeouts
   - pytest-benchmark: Performance testing
   - pytest-asyncio: Test async code

4. **Advanced Topics:**
   - Test-Driven Development (TDD)
   - Behavior-Driven Development (BDD)
   - Property-based testing (Hypothesis)
   - Mutation testing

### **Continue Learning:**
- **Module 3:** Apply testing to SQL and data engineering projects
- **CI/CD:** Integrate tests into continuous integration
- **Production:** Set up automated test runs

---

## 📚 Additional Resources

### **Official Documentation:**
- [pytest Documentation](https://docs.pytest.org/)
- [pytest-cov Documentation](https://pytest-cov.readthedocs.io/)
- [unittest.mock Documentation](https://docs.python.org/3/library/unittest.mock.html)

### **Recommended Reading:**
- "Python Testing with pytest" by Brian Okken
- "Test-Driven Development with Python" by Harry Percival
- "Effective Python" by Brett Slatkin (Testing chapter)
- "Clean Code" by Robert Martin (Unit Tests chapter)

### **Community Resources:**
- [Real Python: Effective Python Testing with pytest](https://realpython.com/pytest-python-testing/)
- [Real Python: Python Mocking](https://realpython.com/python-mock-library/)
- [pytest GitHub Discussions](https://github.com/pytest-dev/pytest/discussions)

---

## 🎓 Learning Verification

### **Quick Quiz:**

Test your understanding:

1. What are the three parts of the AAA pattern?
2. What's the difference between function and session scope fixtures?
3. How do you test that a function raises an exception?
4. When should you use @pytest.mark.parametrize?
5. How do you mock an API call to avoid network requests?
6. What's the purpose of conftest.py?
7. How do you run only slow tests with markers?
8. What's the difference between @pytest.mark.skip and @pytest.mark.xfail?

**Answers are throughout the lesson!**

---

## 💬 Need Help?

If you're stuck or have questions:

1. **Re-read the section** - Examples are thoroughly explained
2. **Run the code** - See tests pass and fail
3. **Break things** - Remove assert to see failures
4. **Check pytest output** - Error messages are very helpful
5. **Complete exercises** - Solutions are provided
6. **Review Section 8** - Best practices guide

---

## 🎉 Congratulations!

You've mastered pytest and professional Python testing! Testing separates hobbyist code from production-ready, maintainable software.

**You now know how to:**
- Write comprehensive test suites with pytest
- Use fixtures to eliminate duplication
- Mock external dependencies for fast, reliable tests
- Organize and run tests effectively
- Measure and improve code coverage
- Follow industry testing best practices

**Remember:**
- Tests are not optional - they're essential
- Good tests make refactoring safe
- Well-tested code is easier to maintain
- Testing improves your code design

**Keep testing, keep learning!** 🚀

---

**Ready to start?**  
**→ [Open 06_testing_pytest.md](06_testing_pytest.md) and begin testing like a pro!**

---

*Last Updated: October 20, 2025*  
*Total Content: 5,907 lines of comprehensive instruction*  
*kluster.ai Verified: ✅ All code examples validated (9 reviews, 0 issues)*

