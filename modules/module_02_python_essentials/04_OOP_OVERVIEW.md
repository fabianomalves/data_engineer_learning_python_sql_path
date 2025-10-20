# Lesson 4: Object-Oriented Programming (OOP) - Complete Overview

## 📖 Introduction

Welcome to **Lesson 4: Object-Oriented Programming (OOP)**! This lesson teaches you how to organize code into reusable, maintainable classes and objects—essential for building production-quality data engineering systems.

**Why This Lesson Matters:**
- **Industry Standard** - OOP is the foundation of professional Python code
- **Reusable Components** - Build classes once, use everywhere
- **Maintainable Systems** - Organize complex data engineering pipelines
- **Clean Architecture** - Separate concerns and responsibilities
- **Team Collaboration** - Write code others can understand and extend

---

## 📊 Lesson Statistics

| Metric | Value |
|--------|-------|
| **Total Lines** | 2,475 lines |
| **Sections** | 7 comprehensive sections |
| **Code Examples** | 70+ working examples |
| **Practice Exercises** | 5 with complete solutions |
| **Estimated Study Time** | 8-10 hours |
| **Difficulty Level** | Intermediate |
| **Prerequisites** | Lessons 1-3 completed |

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

✅ **OOP Fundamentals:**
- Understand what OOP is and why it matters
- Create classes as blueprints for objects
- Instantiate objects from classes
- Use `__init__` constructor to initialize objects
- Work with instance attributes and methods
- Understand `self` parameter
- Compare OOP vs procedural programming

✅ **Attributes and Methods:**
- Distinguish instance vs class attributes
- Create instance methods for object behavior
- Use class methods with `@classmethod`
- Implement static methods with `@staticmethod`
- Understand when to use each type
- Access class and instance data properly

✅ **Encapsulation:**
- Hide internal implementation details
- Use private attributes with `__attribute`
- Use protected attributes with `_attribute`
- Implement properties with `@property`
- Create getters and setters
- Validate data in setters
- Control attribute access

✅ **Inheritance:**
- Create parent and child classes
- Override parent methods
- Use `super()` to call parent methods
- Build class hierarchies
- Apply single and multiple inheritance
- Understand the Method Resolution Order (MRO)
- Reuse code through inheritance

✅ **Polymorphism:**
- Implement special methods (dunder methods)
- Override `__str__` and `__repr__` for string representation
- Use `__len__`, `__getitem__`, `__setitem__`
- Implement comparison operators
- Create context managers with `__enter__` and `__exit__`
- Make objects behave like built-in types

✅ **Real-World Applications:**
- Build data extractor classes
- Create data validator classes
- Implement ETL pipeline components
- Design database repository classes
- Build configuration managers

---

## 📚 Lesson Structure

### **Section 1: OOP Fundamentals - Classes and Objects** (~356 lines)

**What You'll Learn:**
- What OOP is and why it's essential
- How to create classes and objects
- Use `__init__` to initialize objects
- Work with instance attributes and methods

**Key Topics:**

**Why OOP?**
- **Problem**: Procedural code scatters data and functions
- **Solution**: OOP bundles data and behavior together
- Benefits: Encapsulation, reusability, modularity, maintainability

**Creating Classes:**
```python
class Campsite:
    """A class representing a campsite"""
    
    def __init__(self, name, state, price):
        """Initialize campsite with attributes"""
        self.name = name
        self.state = state
        self.price = price
    
    def calculate_total(self, nights):
        """Calculate total cost for given nights"""
        return self.price * nights
```

**Creating Objects:**
```python
# Create instances (objects) from class
site1 = Campsite("Vale Verde", "BA", 120.00)
site2 = Campsite("Serra Azul", "MG", 95.50)

# Access attributes
print(site1.name)  # "Vale Verde"

# Call methods
total = site1.calculate_total(3)  # 360.00
```

**Understanding `self`:**
- `self` represents the instance
- Always first parameter of instance methods
- Gives access to instance attributes
- Python passes it automatically when calling methods

**Instance Attributes vs Methods:**
- **Attributes**: Data stored in the object (`self.name`)
- **Methods**: Functions that act on object data (`self.calculate_total()`)
- Methods can access and modify attributes

**Real-World Examples:**
- Campsite class for managing campground data
- Booking class for reservation management
- User class for user profiles
- ETL pipeline component classes

**Practical Skills:**
- Define classes with clear purposes
- Initialize objects with `__init__`
- Create methods that work with instance data
- Instantiate multiple objects from one class
- Organize related data and behavior

---

### **Section 2: Instance vs Class Attributes and Methods** (~222 lines)

**What You'll Learn:**
- Difference between instance and class attributes
- When to use class methods vs instance methods
- Static methods for utility functions
- Class design patterns

**Key Topics:**

**Instance Attributes:**
```python
class Campsite:
    def __init__(self, name, price):
        self.name = name      # Instance attribute
        self.price = price    # Instance attribute
        
# Each object has its own copy
site1 = Campsite("Vale", 100)
site2 = Campsite("Serra", 150)
site1.name != site2.name  # True - different data
```

**Class Attributes:**
```python
class Campsite:
    total_sites = 0       # Class attribute (shared)
    tax_rate = 0.10       # Class attribute
    
    def __init__(self, name, price):
        self.name = name
        self.price = price
        Campsite.total_sites += 1  # Increment shared counter
        
# Shared across all instances
print(Campsite.total_sites)  # Access via class
```

**Class Methods:**
```python
class Campsite:
    @classmethod
    def from_dict(cls, data):
        """Alternative constructor from dictionary"""
        return cls(
            name=data['name'],
            price=data['price']
        )

# Call on class, not instance
site = Campsite.from_dict({'name': 'Vale', 'price': 100})
```

**Static Methods:**
```python
class Campsite:
    @staticmethod
    def is_valid_price(price):
        """Utility function, doesn't need instance or class"""
        return price > 0 and price < 10000

# Call on class
if Campsite.is_valid_price(150):
    site = Campsite("Vale", 150)
```

**When to Use Each:**
- **Instance methods**: Operate on instance data (use `self`)
- **Class methods**: Alternative constructors, factory patterns (use `cls`)
- **Static methods**: Utility functions, validation (no `self` or `cls`)

**Real-World Examples:**
- Class attributes for configuration
- Class methods for data loaders
- Static methods for validation
- Instance tracking with class attributes

**Practical Skills:**
- Choose appropriate attribute and method types
- Share data across instances with class attributes
- Create alternative constructors with class methods
- Write utility functions as static methods
- Understand scope and access patterns

---

### **Section 3: Encapsulation and Data Hiding** (~217 lines)

**What You'll Learn:**
- Hide internal implementation details
- Use private and protected attributes
- Create properties for controlled access
- Validate data with setters

**Key Topics:**

**The Problem:**
```python
class BankAccount:
    def __init__(self, balance):
        self.balance = balance

account = BankAccount(1000)
account.balance = -500  # PROBLEM: Direct access, no validation!
```

**The Solution - Encapsulation:**
```python
class BankAccount:
    def __init__(self, balance):
        self.__balance = balance  # Private attribute
    
    def get_balance(self):
        return self.__balance
    
    def deposit(self, amount):
        if amount > 0:  # Validation!
            self.__balance += amount
        else:
            raise ValueError("Amount must be positive")
```

**Private Attributes:**
- Prefix with `__` (double underscore)
- Not accessible from outside: `account.__balance` raises AttributeError
- Name mangling: `_ClassName__attribute`
- Use to hide implementation details

**Protected Attributes:**
- Prefix with `_` (single underscore)
- Convention: "Internal use, don't touch"
- Still accessible but signals "private"
- Used within class and subclasses

**Properties - The Pythonic Way:**
```python
class Campsite:
    def __init__(self, name, price):
        self._name = name
        self._price = price
    
    @property
    def price(self):
        """Getter"""
        return self._price
    
    @price.setter
    def price(self, value):
        """Setter with validation"""
        if value < 0:
            raise ValueError("Price can't be negative")
        self._price = value

# Usage looks like attribute access
site = Campsite("Vale", 100)
print(site.price)     # Calls getter
site.price = 150      # Calls setter with validation
site.price = -10      # Raises ValueError
```

**Benefits of Properties:**
- Look like attributes, act like methods
- Add validation logic transparently
- Computed properties (calculate on access)
- Backward compatible (can add later)

**Real-World Examples:**
- Bank account with balance validation
- User with age validation
- Configuration with type checking
- Data validators for ETL pipelines

**Practical Skills:**
- Hide implementation details
- Validate data before setting
- Create computed properties
- Use `@property` decorator
- Design clean class interfaces

---

### **Section 4: Inheritance and Code Reuse** (~391 lines)

**What You'll Learn:**
- Create parent and child classes
- Inherit attributes and methods
- Override parent methods
- Use `super()` to extend functionality
- Build class hierarchies

**Key Topics:**

**Basic Inheritance:**
```python
# Parent class
class Animal:
    def __init__(self, name):
        self.name = name
    
    def speak(self):
        return "Some sound"

# Child class inherits from Animal
class Dog(Animal):
    def speak(self):
        return "Woof!"

dog = Dog("Rex")
print(dog.name)      # Inherited attribute
print(dog.speak())   # Overridden method - "Woof!"
```

**The `super()` Function:**
```python
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

class Manager(Employee):
    def __init__(self, name, salary, department):
        super().__init__(name, salary)  # Call parent __init__
        self.department = department    # Add new attribute
```

**Method Override:**
- Child can replace parent methods completely
- Or extend parent methods with `super()`
- Choose based on needs

**Inheritance Hierarchy:**
```python
# Base class
class DataSource:
    def extract(self):
        raise NotImplementedError

# Specialized classes
class CSVSource(DataSource):
    def extract(self):
        # CSV-specific extraction
        pass

class APISource(DataSource):
    def extract(self):
        # API-specific extraction
        pass
```

**Multiple Inheritance:**
```python
class Reader:
    def read(self):
        pass

class Writer:
    def write(self):
        pass

class FileProcessor(Reader, Writer):
    """Inherits from both Reader and Writer"""
    pass
```

**Method Resolution Order (MRO):**
- Order Python searches for methods
- Check with `ClassName.__mro__`
- Important for multiple inheritance

**Real-World Examples:**
- Data extractors (CSV, JSON, API)
- Database models (BaseModel with common fields)
- Exception hierarchy (custom exceptions)
- ETL components (Extract, Transform, Load base classes)

**Practical Skills:**
- Identify common behavior for parent classes
- Create specialized child classes
- Override methods appropriately
- Use `super()` to extend functionality
- Build flexible class hierarchies
- Apply DRY principle through inheritance

---

### **Section 5: Polymorphism and Special Methods** (~219 lines)

**What You'll Learn:**
- Implement special methods (dunder methods)
- Override string representation
- Implement comparison operators
- Make objects behave like built-ins

**Key Topics:**

**String Representation:**
```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def __str__(self):
        """User-friendly string (for print)"""
        return f"{self.name} - R${self.price:.2f}"
    
    def __repr__(self):
        """Developer-friendly (for debugging)"""
        return f"Campsite(name='{self.name}', price={self.price})"

site = Campsite("Vale", 100)
print(site)        # Calls __str__ - "Vale - R$100.00"
print(repr(site))  # Calls __repr__ - "Campsite(name='Vale', price=100)"
```

**Container Methods:**
```python
class CampsiteList:
    def __init__(self):
        self._sites = []
    
    def __len__(self):
        """len(obj) calls this"""
        return len(self._sites)
    
    def __getitem__(self, index):
        """obj[index] calls this"""
        return self._sites[index]
    
    def __setitem__(self, index, value):
        """obj[index] = value calls this"""
        self._sites[index] = value

sites = CampsiteList()
print(len(sites))      # Calls __len__
site = sites[0]        # Calls __getitem__
sites[0] = new_site    # Calls __setitem__
```

**Comparison Operators:**
```python
class Campsite:
    def __eq__(self, other):
        """obj1 == obj2"""
        return self.name == other.name
    
    def __lt__(self, other):
        """obj1 < obj2"""
        return self.price < other.price

site1 = Campsite("Vale", 100)
site2 = Campsite("Serra", 150)
print(site1 == site2)  # False
print(site1 < site2)   # True (cheaper)
```

**Context Manager Protocol:**
```python
class DatabaseConnection:
    def __enter__(self):
        """Called when entering 'with' block"""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when leaving 'with' block"""
        self.close()
        return False  # Propagate exceptions

# Usage
with DatabaseConnection() as db:
    db.query("SELECT * FROM campsites")
# Connection closes automatically
```

**Common Special Methods:**
- `__init__`: Constructor
- `__str__`, `__repr__`: String representation
- `__len__`: Length
- `__getitem__`, `__setitem__`: Indexing
- `__eq__`, `__lt__`, etc.: Comparisons
- `__enter__`, `__exit__`: Context manager
- `__call__`: Make object callable

**Real-World Examples:**
- Custom collection classes
- Database result wrappers
- Configuration objects
- ETL component managers

**Practical Skills:**
- Override `__str__` for user-friendly output
- Implement `__repr__` for debugging
- Make objects iterable and indexable
- Create context managers
- Implement custom comparisons

---

### **Section 6: Practice Exercises** (~863 lines)

**What You'll Learn:**
- Apply all OOP concepts together
- Build complete class systems
- Design real-world data engineering components
- Refactor procedural code to OOP

**Practice Problems:**

**Exercise 1: Data Validator Class**
- Create Validator class with validation rules
- Implement validation for different data types
- Use properties for rule configuration
- Build reusable validation framework
- Complete solution with inheritance

**Exercise 2: ETL Pipeline Components**
- Create base ETL class
- Implement CSVExtractor, JSONExtractor
- Build DataTransformer with methods
- Create DataLoader for output
- Connect components in pipeline

**Exercise 3: Database Repository**
- Create BaseRepository with common CRUD
- Implement CampsiteRepository inheriting from base
- Use encapsulation for connection management
- Implement query methods
- Handle errors gracefully

**Exercise 4: Configuration Manager**
- Build Config class with properties
- Validate configuration values
- Implement singleton pattern
- Load from JSON file
- Provide default values

**Exercise 5: Data Model Hierarchy**
- Create BaseModel with common fields
- Implement User, Campsite, Booking models
- Add relationships between models
- Implement validation in setters
- Override special methods

**Each Exercise Includes:**
- Clear requirements and constraints
- UML class diagram (when applicable)
- Expected behavior description
- Test cases to verify solution
- Complete working solution
- Explanation of design decisions
- Alternative implementations
- Common mistakes to avoid

**Practical Skills:**
- Design class hierarchies
- Apply SOLID principles
- Build reusable components
- Refactor to OOP patterns
- Write maintainable class code

---

### **Section 7: Summary and Next Steps** (~122 lines)

**What You'll Learn:**
- Review all OOP concepts
- Understand when to use OOP vs functional
- Preview advanced OOP topics
- Connect to next lessons

**Key Review:**
- Classes bundle data and behavior
- Inheritance promotes code reuse
- Encapsulation hides implementation
- Polymorphism enables flexibility
- Special methods integrate with Python

**OOP Best Practices:**
- Single Responsibility Principle
- Don't Repeat Yourself (DRY)
- Favor composition over inheritance
- Program to interfaces
- Keep it simple

**When to Use OOP:**
- Building reusable components
- Managing state and behavior together
- Creating class hierarchies
- Modeling real-world entities
- Large, complex systems

**When NOT to Use OOP:**
- Simple scripts
- One-off transformations
- Purely functional operations
- When simpler approaches work

**Next Steps:**
- Apply OOP in error handling (Lesson 5)
- Test OOP code with pytest (Lesson 6)
- Build OOP data engineering projects

---

## 🛠️ Technical Requirements

**Python Version:**
- Python 3.8+

**No External Libraries Required:**
- Pure Python standard library
- Focus on core OOP concepts

**Recommended Tools:**
- IDE with class inspection (VS Code, PyCharm)
- Python REPL for experimentation
- UML diagram tools (optional)

---

## 📖 How to Use This Lesson

### **Study Schedule:**

**Day 1: Fundamentals (Sections 1-2)**
- Morning: Classes, objects, `__init__`, `self`
- Afternoon: Instance vs class attributes/methods
- Practice: Build simple classes

**Day 2: Encapsulation & Inheritance (Sections 3-4)**
- Morning: Private attributes, properties, validation
- Afternoon: Inheritance, `super()`, method override
- Practice: Build class hierarchies

**Day 3: Polymorphism (Section 5)**
- Morning: Special methods, `__str__`, `__repr__`
- Afternoon: Container methods, context managers
- Practice: Implement dunder methods

**Day 4: Practice & Review (Sections 6-7)**
- Morning: Exercises 1-3
- Afternoon: Exercises 4-5
- Evening: Review and build personal OOP project

---

## 💡 Key Takeaways

1. **Classes Bundle Data and Behavior**
   - Organize related attributes and methods
   - Create reusable blueprints
   - Instantiate multiple objects

2. **Inheritance Promotes Reuse**
   - Extract common behavior to parent classes
   - Specialize with child classes
   - Use `super()` to extend functionality

3. **Encapsulation Hides Details**
   - Use properties for controlled access
   - Validate in setters
   - Hide implementation with private attributes

4. **Polymorphism Enables Flexibility**
   - Override special methods
   - Make objects behave like built-ins
   - Implement protocols (context manager, iterator)

---

## 🎯 Real-World Applications

**Data Engineering:**
- ETL pipeline components
- Data validators and cleaners
- Database repository patterns
- Configuration managers
- Data model hierarchies

---

## ✅ Self-Assessment Checklist

- [ ] Create classes with `__init__`
- [ ] Use instance and class attributes appropriately
- [ ] Implement instance, class, and static methods
- [ ] Create private attributes and properties
- [ ] Build inheritance hierarchies
- [ ] Override methods with `super()`
- [ ] Implement `__str__` and `__repr__`
- [ ] Create context managers
- [ ] Complete all 5 practice exercises

---

## 🚀 Next Steps

1. **Move to Lesson 5: Error Handling & Logging**
   - Apply OOP to custom exceptions
   - Build exception hierarchies
   - Create logging wrappers

2. **Build Projects:**
   - Complete ETL system using OOP
   - Database ORM layer
   - Configuration framework
   - Data validation library

---

## 📚 Additional Resources

**Official Documentation:**
- [Python Classes Tutorial](https://docs.python.org/3/tutorial/classes.html)
- [Python Data Model](https://docs.python.org/3/reference/datamodel.html)
- [Special Method Names](https://docs.python.org/3/reference/datamodel.html#special-method-names)

**Recommended Reading:**
- "Python Object-Oriented Programming" by Steven F. Lott
- "Fluent Python" by Luciano Ramalho (OOP chapters)
- "Clean Code" by Robert Martin (SOLID principles)

---

## 🎉 Congratulations!

You've mastered Object-Oriented Programming in Python! OOP is fundamental to building professional, maintainable data engineering systems.

**You now know:**
- How to design and implement classes
- Inheritance for code reuse
- Encapsulation for data protection
- Polymorphism for flexibility
- Real-world OOP patterns

**Remember:**
- Bundle related data and behavior
- Favor composition over inheritance when appropriate
- Keep classes focused and simple
- Use properties for validation

**Keep coding, keep learning!** 🚀

---

**Ready to master OOP?**  
**→ [Open 04_object_oriented_programming.md](04_object_oriented_programming.md) and build professional classes!**

---

*Last Updated: October 20, 2025*  
*Total Content: 2,475 lines of comprehensive instruction*  
*Focus: Professional OOP for Data Engineering*

