# Lesson 4: Object-Oriented Programming (OOP)

**Duration**: 3 hours  
**Prerequisites**: Lesson 1, 2, 3  
**Goal**: Master OOP concepts to build reusable, maintainable code for data engineering

---

## 📋 **What You'll Learn**

By the end of this lesson, you will:

✅ Understand what Object-Oriented Programming is and why it matters  
✅ Create classes and objects (instances)  
✅ Use `__init__` constructor to initialize objects  
✅ Work with instance attributes and methods  
✅ Understand class attributes and class methods  
✅ Implement encapsulation with private/protected members  
✅ Use inheritance to create specialized classes  
✅ Apply polymorphism for flexible code  
✅ Use special methods (dunder methods) like `__str__`, `__repr__`  
✅ Build real-world data engineering classes  

---

## 🗂️ **Table of Contents**

1. [OOP Fundamentals - Classes and Objects](#1-oop-fundamentals---classes-and-objects)
2. [Instance vs Class Attributes and Methods](#2-instance-vs-class-attributes-and-methods)
3. [Encapsulation and Data Hiding](#3-encapsulation-and-data-hiding)
4. [Inheritance and Code Reuse](#4-inheritance-and-code-reuse)
5. [Polymorphism and Special Methods](#5-polymorphism-and-special-methods)
6. [Practice Exercises](#6-practice-exercises)

---

## Why Learn OOP for Data Engineering?

Before diving in, let's understand **why OOP matters in data engineering**:

### ❌ **Without OOP (Procedural Code)**

```python
# Scattered functions and variables
campsite_name = "Camping Vale"
campsite_state = "BA"
campsite_price = 120.00

def calculate_total(price, nights):
    return price * nights

def apply_discount(price, discount_percent):
    return price * (1 - discount_percent / 100)

# Hard to maintain, hard to extend, data is separate from behavior
```

### ✅ **With OOP (Object-Oriented Code)**

```python
class Campsite:
    def __init__(self, name, state, price):
        self.name = name
        self.state = state
        self.price = price
    
    def calculate_total(self, nights):
        return self.price * nights
    
    def apply_discount(self, discount_percent):
        self.price = self.price * (1 - discount_percent / 100)

# Data and behavior together, easy to maintain and extend!
campsite = Campsite("Camping Vale", "BA", 120.00)
total = campsite.calculate_total(3)
```

**Benefits:**
- 📦 **Encapsulation**: Data and functions are bundled together
- 🔄 **Reusability**: Create templates (classes) and reuse them
- 🧩 **Modularity**: Easier to understand and maintain
- 🎯 **Real-World Modeling**: Code matches how we think about things

---

## 1. OOP Fundamentals - Classes and Objects

### What is a Class?

A **class** is a blueprint or template for creating objects. Think of it like a cookie cutter - it defines the shape, but isn't the cookie itself.

### What is an Object?

An **object** (or **instance**) is a specific example created from a class. It's the actual cookie!

```python
# Class = Blueprint
# Object = Actual thing created from blueprint

# Analogy:
# Class = "House Blueprint"
# Object = Your actual house at 123 Main St
```

### Creating Your First Class

```python
# ---------- BASIC CLASS ----------

class Campsite:
    """A class representing a campsite."""
    pass  # Empty class (for now)

# Create objects (instances) from the class
camp1 = Campsite()  # First object
camp2 = Campsite()  # Second object

print(camp1)  # <__main__.Campsite object at 0x...>
print(camp2)  # <__main__.Campsite object at 0x...>

# They are different objects!
print(camp1 == camp2)  # False
```

### The `__init__` Method (Constructor)

The `__init__` method is called automatically when you create an object. It's used to initialize the object's attributes.

```python
class Campsite:
    """A class representing a campsite."""
    
    def __init__(self, name, state, price):
        """Initialize a new campsite.
        
        Args:
            name: Campsite name
            state: State abbreviation (e.g., 'BA')
            price: Price per night
        """
        # self refers to the object being created
        self.name = name      # Instance attribute
        self.state = state    # Instance attribute
        self.price = price    # Instance attribute
        
        print(f"✅ Created campsite: {name}")

# Create objects with initial data
camp1 = Campsite("Camping Vale do Pati", "BA", 120.00)
camp2 = Campsite("Serra dos Órgãos", "RJ", 80.00)

# Access attributes
print(f"{camp1.name} - R${camp1.price}")
print(f"{camp2.name} - R${camp2.price}")

# Output:
# ✅ Created campsite: Camping Vale do Pati
# ✅ Created campsite: Serra dos Órgãos
# Camping Vale do Pati - R$120.0
# Serra dos Órgãos - R$80.0
```

### Understanding `self`

**What is `self`?**
- `self` represents the instance of the class
- It's how the object refers to itself
- MUST be the first parameter in instance methods
- Python passes it automatically - you don't provide it when calling

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name      # self.name = THIS object's name
        self.price = price    # self.price = THIS object's price

camp1 = Campsite("Camp A", 100.00)
camp2 = Campsite("Camp B", 80.00)

# When you call: camp1 = Campsite("Camp A", 100.00)
# Python actually does: Campsite.__init__(camp1, "Camp A", 100.00)
#                                          ^^^^^ Python adds self automatically!

print(camp1.name)  # "Camp A" - camp1's name
print(camp2.name)  # "Camp B" - camp2's name
```

### Instance Methods

Methods are functions that belong to a class. They can access and modify the object's attributes.

```python
class Campsite:
    """A class representing a campsite."""
    
    def __init__(self, name, state, price, capacity):
        self.name = name
        self.state = state
        self.price = price
        self.capacity = capacity
    
    def calculate_total(self, nights):
        """Calculate total cost for multiple nights.
        
        Args:
            nights: Number of nights
            
        Returns:
            Total cost
        """
        return self.price * nights
    
    def apply_discount(self, discount_percent):
        """Apply a discount to the price.
        
        Args:
            discount_percent: Discount percentage (e.g., 10 for 10%)
        """
        discount_amount = self.price * (discount_percent / 100)
        self.price = self.price - discount_amount
        print(f"💰 Applied {discount_percent}% discount. New price: R${self.price:.2f}")
    
    def is_available_for(self, required_capacity):
        """Check if campsite can accommodate required capacity.
        
        Args:
            required_capacity: Number of people
            
        Returns:
            True if available, False otherwise
        """
        return self.capacity >= required_capacity
    
    def display_info(self):
        """Display campsite information."""
        print(f"📍 {self.name}")
        print(f"   State: {self.state}")
        print(f"   Price: R${self.price:.2f}/night")
        print(f"   Capacity: {self.capacity} people")

# Create a campsite
camp = Campsite("Camping Vale do Pati", "BA", 120.00, 30)

# Call methods
camp.display_info()
# Output:
# 📍 Camping Vale do Pati
#    State: BA
#    Price: R$120.00/night
#    Capacity: 30 people

total = camp.calculate_total(3)
print(f"\nTotal for 3 nights: R${total:.2f}")
# Output: Total for 3 nights: R$360.00

camp.apply_discount(10)
# Output: 💰 Applied 10% discount. New price: R$108.00

available = camp.is_available_for(25)
print(f"Available for 25 people? {available}")
# Output: Available for 25 people? True
```

### Multiple Instances

Each object is independent with its own data:

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def apply_discount(self, percent):
        self.price = self.price * (1 - percent / 100)

# Create three different campsites
camp1 = Campsite("Camp A", 100.00)
camp2 = Campsite("Camp B", 80.00)
camp3 = Campsite("Camp C", 120.00)

# Apply discount only to camp1
camp1.apply_discount(20)

# Each has independent price
print(f"{camp1.name}: R${camp1.price:.2f}")  # Camp A: R$80.00 (discounted)
print(f"{camp2.name}: R${camp2.price:.2f}")  # Camp B: R$80.00 (unchanged)
print(f"{camp3.name}: R${camp3.price:.2f}")  # Camp C: R$120.00 (unchanged)
```

### Real-World Example: Booking System

```python
from datetime import datetime, timedelta

class Booking:
    """Represents a campsite booking."""
    
    def __init__(self, customer_name, campsite_name, check_in, check_out, guests):
        """Initialize a booking.
        
        Args:
            customer_name: Customer's name
            campsite_name: Name of campsite
            check_in: Check-in date (datetime object)
            check_out: Check-out date (datetime object)
            guests: Number of guests
        """
        self.customer_name = customer_name
        self.campsite_name = campsite_name
        self.check_in = check_in
        self.check_out = check_out
        self.guests = guests
        self.booking_id = self._generate_booking_id()
    
    def _generate_booking_id(self):
        """Generate a unique booking ID."""
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        return f"BK-{timestamp}"
    
    def get_duration_nights(self):
        """Calculate booking duration in nights."""
        duration = self.check_out - self.check_in
        return duration.days
    
    def calculate_total(self, price_per_night):
        """Calculate total cost.
        
        Args:
            price_per_night: Price per night
            
        Returns:
            Total cost
        """
        nights = self.get_duration_nights()
        return nights * price_per_night
    
    def is_active(self):
        """Check if booking is currently active."""
        now = datetime.now()
        return self.check_in <= now <= self.check_out
    
    def days_until_checkin(self):
        """Calculate days until check-in."""
        now = datetime.now()
        if now < self.check_in:
            delta = self.check_in - now
            return delta.days
        return 0
    
    def display_summary(self):
        """Display booking summary."""
        print(f"{'='*50}")
        print(f"Booking ID: {self.booking_id}")
        print(f"Customer: {self.customer_name}")
        print(f"Campsite: {self.campsite_name}")
        print(f"Check-in: {self.check_in.strftime('%Y-%m-%d')}")
        print(f"Check-out: {self.check_out.strftime('%Y-%m-%d')}")
        print(f"Duration: {self.get_duration_nights()} nights")
        print(f"Guests: {self.guests}")
        print(f"Status: {'Active' if self.is_active() else 'Upcoming'}")
        print(f"{'='*50}")

# Create a booking
check_in = datetime(2024, 7, 15)
check_out = datetime(2024, 7, 18)

booking = Booking(
    customer_name="João Silva",
    campsite_name="Camping Vale do Pati",
    check_in=check_in,
    check_out=check_out,
    guests=4
)

# Use the booking
booking.display_summary()
# Output:
# ==================================================
# Booking ID: BK-20241019143022
# Customer: João Silva
# Campsite: Camping Vale do Pati
# Check-in: 2024-07-15
# Check-out: 2024-07-18
# Duration: 3 nights
# Guests: 4
# Status: Upcoming
# ==================================================

total = booking.calculate_total(120.00)
print(f"\nTotal Cost: R${total:.2f}")
# Output: Total Cost: R$360.00

days_until = booking.days_until_checkin()
print(f"Days until check-in: {days_until}")
```

### Working with Lists of Objects

```python
class Campsite:
    def __init__(self, name, state, price, capacity):
        self.name = name
        self.state = state
        self.price = price
        self.capacity = capacity

# Create multiple campsites
campsites = [
    Campsite("Camping Vale do Pati", "BA", 120.00, 30),
    Campsite("Serra dos Órgãos", "RJ", 80.00, 25),
    Campsite("Pico da Bandeira", "MG", 100.00, 20),
    Campsite("Cachoeira Camp", "BA", 95.00, 15),
    Campsite("Trilha Azul", "SP", 110.00, 28)
]

# Find campsites in Bahia
print("Campsites in BA:")
ba_camps = [camp for camp in campsites if camp.state == "BA"]
for camp in ba_camps:
    print(f"  - {camp.name}: R${camp.price:.2f}")

# Find affordable campsites (< R$100)
print("\nAffordable campsites (<R$100):")
affordable = [camp for camp in campsites if camp.price < 100]
for camp in affordable:
    print(f"  - {camp.name} ({camp.state}): R${camp.price:.2f}")

# Sort by price
print("\nSorted by price:")
sorted_camps = sorted(campsites, key=lambda camp: camp.price)
for camp in sorted_camps:
    print(f"  - {camp.name}: R${camp.price:.2f}")

# Calculate average price
avg_price = sum(camp.price for camp in campsites) / len(campsites)
print(f"\nAverage price: R${avg_price:.2f}")
```

---

## 2. Instance vs Class Attributes and Methods

### Instance Attributes

**Instance attributes** are unique to each object. Each instance has its own copy.

```python
class Campsite:
    def __init__(self, name, price):
        # Instance attributes - each object has its own
        self.name = name
        self.price = price

camp1 = Campsite("Camp A", 100.00)
camp2 = Campsite("Camp B", 80.00)

# Each has its own name and price
print(camp1.name)  # "Camp A"
print(camp2.name)  # "Camp B"
```

### Class Attributes

**Class attributes** are shared by ALL instances of the class.

```python
class Campsite:
    # Class attribute - shared by ALL campsites
    total_campsites = 0
    service_fee_percent = 10
    
    def __init__(self, name, price):
        # Instance attributes - unique to each campsite
        self.name = name
        self.price = price
        
        # Increment class attribute
        Campsite.total_campsites += 1
    
    def calculate_total_with_fee(self, nights):
        """Calculate total including service fee."""
        base_total = self.price * nights
        fee = base_total * (Campsite.service_fee_percent / 100)
        return base_total + fee

# Create campsites
camp1 = Campsite("Camp A", 100.00)
print(f"Total campsites: {Campsite.total_campsites}")  # 1

camp2 = Campsite("Camp B", 80.00)
print(f"Total campsites: {Campsite.total_campsites}")  # 2

camp3 = Campsite("Camp C", 120.00)
print(f"Total campsites: {Campsite.total_campsites}")  # 3

# All instances share the class attribute
print(f"Service fee: {camp1.service_fee_percent}%")  # 10%
print(f"Service fee: {camp2.service_fee_percent}%")  # 10%

# Change class attribute - affects ALL instances
Campsite.service_fee_percent = 15

print(f"New service fee: {camp1.service_fee_percent}%")  # 15%
print(f"New service fee: {camp2.service_fee_percent}%")  # 15%
```

### Class Methods

**Class methods** operate on the class itself, not on instances. They're defined with the `@classmethod` decorator.

```python
class Campsite:
    total_campsites = 0
    all_campsites = []
    
    def __init__(self, name, price):
        self.name = name
        self.price = price
        Campsite.total_campsites += 1
        Campsite.all_campsites.append(self)
    
    @classmethod
    def get_total_count(cls):
        """Get total number of campsites created.
        
        Note: cls refers to the class itself (like self refers to instance)
        """
        return cls.total_campsites
    
    @classmethod
    def get_average_price(cls):
        """Calculate average price of all campsites."""
        if not cls.all_campsites:
            return 0
        total = sum(camp.price for camp in cls.all_campsites)
        return total / len(cls.all_campsites)
    
    @classmethod
    def find_by_name(cls, name):
        """Find campsite by name."""
        for camp in cls.all_campsites:
            if camp.name.lower() == name.lower():
                return camp
        return None
    
    @classmethod
    def create_from_dict(cls, data):
        """Factory method to create campsite from dictionary.
        
        Args:
            data: Dictionary with campsite data
            
        Returns:
            New Campsite instance
        """
        return cls(name=data['name'], price=data['price'])

# Create campsites
camp1 = Campsite("Camping Vale", 120.00)
camp2 = Campsite("Serra Camp", 80.00)
camp3 = Campsite("Pico Camp", 100.00)

# Call class methods
print(f"Total campsites: {Campsite.get_total_count()}")  # 3
print(f"Average price: R${Campsite.get_average_price():.2f}")  # R$100.00

# Find by name
found = Campsite.find_by_name("Serra Camp")
if found:
    print(f"Found: {found.name} - R${found.price:.2f}")

# Factory method
data = {'name': 'New Camp', 'price': 90.00}
camp4 = Campsite.create_from_dict(data)
print(f"Created: {camp4.name} - R${camp4.price:.2f}")
```

### Static Methods

**Static methods** don't access instance or class data. They're utility functions that belong to the class.

```python
class Campsite:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    @staticmethod
    def validate_price(price):
        """Validate if price is acceptable.
        
        Note: No self or cls parameter - doesn't access instance or class data
        """
        if not isinstance(price, (int, float)):
            return False, "Price must be a number"
        if price <= 0:
            return False, "Price must be positive"
        if price > 1000:
            return False, "Price seems too high (max: R$1000)"
        return True, "Price is valid"
    
    @staticmethod
    def calculate_discount_amount(price, discount_percent):
        """Calculate discount amount (utility function)."""
        return price * (discount_percent / 100)
    
    @staticmethod
    def format_currency(amount):
        """Format amount as Brazilian currency."""
        return f"R$ {amount:,.2f}".replace(',', 'X').replace('.', ',').replace('X', '.')

# Use static methods - no need for instance!
is_valid, message = Campsite.validate_price(120.00)
print(f"{message}: {is_valid}")  # Price is valid: True

is_valid, message = Campsite.validate_price(-50)
print(f"{message}: {is_valid}")  # Price must be positive: False

discount = Campsite.calculate_discount_amount(120.00, 10)
print(f"Discount: {Campsite.format_currency(discount)}")  # Discount: R$ 12,00

# Can also call from instance (but unusual)
camp = Campsite("Test", 100)
formatted = camp.format_currency(100.00)
print(formatted)  # R$ 100,00
```

### When to Use Each?

| Type | Use When | Access To |
|------|----------|-----------|
| **Instance Method** | Operating on instance data | `self` (instance attributes) |
| **Class Method** | Operating on class data or creating instances | `cls` (class attributes) |
| **Static Method** | Utility function related to class | Nothing (no self or cls) |

```python
class Campsite:
    total_count = 0  # Class attribute
    
    def __init__(self, name, price):
        self.name = name  # Instance attribute
        self.price = price
        Campsite.total_count += 1
    
    def display_info(self):
        """Instance method - uses instance data (self)."""
        print(f"{self.name}: R${self.price:.2f}")
    
    @classmethod
    def get_total_count(cls):
        """Class method - uses class data (cls)."""
        return cls.total_count
    
    @staticmethod
    def is_valid_state(state):
        """Static method - just utility, no class/instance data."""
        valid_states = ['BA', 'RJ', 'MG', 'SP', 'RS']
        return state in valid_states
```

---

## 3. Encapsulation and Data Hiding

### What is Encapsulation?

**Encapsulation** is the bundling of data (attributes) and methods that operate on that data within a single unit (class), and controlling access to that data.

**Why Encapsulation?**
- 🔒 **Data Protection**: Prevent accidental modification
- ✅ **Validation**: Control how data is set
- 🧩 **Flexibility**: Change internal implementation without breaking code
- 📦 **Abstraction**: Hide complexity from users

### Public, Protected, and Private Members

Python uses naming conventions to indicate access levels:

| Convention | Access Level | Example | Meaning |
|------------|--------------|---------|---------|
| `name` | Public | `self.price` | Can be accessed from anywhere |
| `_name` | Protected | `self._cost` | Internal use, but not enforced |
| `__name` | Private | `self.__secret` | Name mangling applied |

```python
class Campsite:
    def __init__(self, name, price):
        # Public attribute - can access directly
        self.name = name
        
        # Protected attribute - internal use (convention only)
        self._cost = price * 0.8  # Our cost (not for public)
        
        # Private attribute - name mangling applied
        self.__secret_discount = 15  # Secret discount code
    
    def get_price(self):
        """Public method to get price."""
        return self._cost * 1.25  # Add markup

# Create campsite
camp = Campsite("Test Camp", 100.00)

# Public - works fine
print(f"Name: {camp.name}")  # ✅ Works: Test Camp

# Protected - works but shouldn't use externally (just convention)
print(f"Cost: {camp._cost}")  # ⚠️  Works but discouraged: 80.0

# Private - doesn't work (name mangling)
# print(camp.__secret_discount)  # ❌ AttributeError

# Python mangles the name to _ClassName__attribute
print(camp._Campsite__secret_discount)  # 😈 Can still access (but don't!)
```

### Properties and Getters/Setters

Use `@property` decorator to control attribute access:

```python
class Campsite:
    def __init__(self, name, price, capacity):
        self.name = name
        self._price = price  # Protected attribute
        self._capacity = capacity
    
    @property
    def price(self):
        """Getter for price."""
        return self._price
    
    @price.setter
    def price(self, value):
        """Setter for price with validation."""
        if not isinstance(value, (int, float)):
            raise TypeError("Price must be a number")
        if value <= 0:
            raise ValueError("Price must be positive")
        if value > 1000:
            raise ValueError("Price seems too high (max R$1000)")
        
        self._price = value
        print(f"✅ Price updated to R${value:.2f}")
    
    @property
    def capacity(self):
        """Getter for capacity."""
        return self._capacity
    
    @capacity.setter
    def capacity(self, value):
        """Setter for capacity with validation."""
        if not isinstance(value, int):
            raise TypeError("Capacity must be an integer")
        if value <= 0:
            raise ValueError("Capacity must be positive")
        
        self._capacity = value
        print(f"✅ Capacity updated to {value}")
    
    @property
    def price_per_person(self):
        """Computed property (read-only)."""
        return self._price / self._capacity

# Create campsite
camp = Campsite("Camping Vale", 120.00, 30)

# Access price like an attribute (calls getter)
print(f"Price: R${camp.price:.2f}")  # R$120.00

# Set price (calls setter with validation)
camp.price = 150.00  # ✅ Price updated to R$150.00

# Validation works!
try:
    camp.price = -50  # ValueError: Price must be positive
except ValueError as e:
    print(f"❌ {e}")

try:
    camp.price = "invalid"  # TypeError: Price must be a number
except TypeError as e:
    print(f"❌ {e}")

# Read-only computed property
print(f"Price per person: R${camp.price_per_person:.2f}")  # R$5.00

# Can't set computed property
# camp.price_per_person = 10  # ❌ AttributeError
```

### Real-World Example: Bank Account with Encapsulation

```python
from datetime import datetime

class BankAccount:
    """Bank account with encapsulated balance."""
    
    def __init__(self, account_number, owner_name, initial_balance=0):
        self.account_number = account_number
        self.owner_name = owner_name
        self.__balance = initial_balance  # Private balance
        self.__transactions = []  # Private transaction history
    
    @property
    def balance(self):
        """Get current balance (read-only)."""
        return self.__balance
    
    def deposit(self, amount):
        """Deposit money with validation."""
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        
        self.__balance += amount
        self.__record_transaction("DEPOSIT", amount)
        print(f"✅ Deposited R${amount:.2f}. New balance: R${self.__balance:.2f}")
    
    def withdraw(self, amount):
        """Withdraw money with validation."""
        if amount <= 0:
            raise ValueError("Withdrawal amount must be positive")
        
        if amount > self.__balance:
            raise ValueError(f"Insufficient funds. Balance: R${self.__balance:.2f}")
        
        self.__balance -= amount
        self.__record_transaction("WITHDRAW", amount)
        print(f"✅ Withdrew R${amount:.2f}. New balance: R${self.__balance:.2f}")
    
    def __record_transaction(self, transaction_type, amount):
        """Private method to record transaction."""
        self.__transactions.append({
            'type': transaction_type,
            'amount': amount,
            'timestamp': datetime.now(),
            'balance_after': self.__balance
        })
    
    def get_transaction_history(self):
        """Get transaction history (copy to prevent modification)."""
        return self.__transactions.copy()
    
    def display_info(self):
        """Display account information."""
        print(f"{'='*50}")
        print(f"Account: {self.account_number}")
        print(f"Owner: {self.owner_name}")
        print(f"Balance: R${self.__balance:.2f}")
        print(f"Transactions: {len(self.__transactions)}")
        print(f"{'='*50}")

# Create account
account = BankAccount("12345-6", "João Silva", 1000.00)
account.display_info()

# Deposit
account.deposit(500.00)

# Withdraw
account.withdraw(200.00)

# Can't directly modify balance (it's private)
# account.__balance = 999999.99  # Won't work!

# Can only read balance through property
print(f"\nCurrent balance: R${account.balance:.2f}")

# View transaction history
print("\nTransaction History:")
for trans in account.get_transaction_history():
    print(f"  {trans['type']}: R${trans['amount']:.2f} at {trans['timestamp']}")
```

---

## 4. Inheritance and Code Reuse

### What is Inheritance?

**Inheritance** allows you to create a new class based on an existing class, inheriting its attributes and methods.

**Why Inheritance?**
- ♻️ **Code Reuse**: Don't repeat yourself (DRY)
- 🎯 **Specialization**: Create more specific versions
- 🧩 **Hierarchy**: Model real-world relationships
- 🔧 **Maintainability**: Change once, affect all children

### Basic Inheritance

```python
# Parent class (Base class, Superclass)
class Accommodation:
    """Base class for all accommodations."""
    
    def __init__(self, name, location, price):
        self.name = name
        self.location = location
        self.price = price
    
    def display_info(self):
        """Display basic information."""
        print(f"📍 {self.name}")
        print(f"   Location: {self.location}")
        print(f"   Price: R${self.price:.2f}/night")
    
    def calculate_total(self, nights):
        """Calculate total cost."""
        return self.price * nights

# Child class (Derived class, Subclass)
class Campsite(Accommodation):
    """Campsite inherits from Accommodation."""
    
    def __init__(self, name, location, price, capacity, has_electricity):
        # Call parent's __init__
        super().__init__(name, location, price)
        
        # Add campsite-specific attributes
        self.capacity = capacity
        self.has_electricity = has_electricity
    
    def display_info(self):
        """Override parent's method with more details."""
        # Call parent's method first
        super().display_info()
        
        # Add campsite-specific info
        print(f"   Capacity: {self.capacity} people")
        print(f"   Electricity: {'Yes' if self.has_electricity else 'No'}")

# Another child class
class Hotel(Accommodation):
    """Hotel inherits from Accommodation."""
    
    def __init__(self, name, location, price, stars, has_breakfast):
        super().__init__(name, location, price)
        self.stars = stars
        self.has_breakfast = has_breakfast
    
    def display_info(self):
        """Override parent's method."""
        super().display_info()
        print(f"   Stars: {'⭐' * self.stars}")
        print(f"   Breakfast: {'Included' if self.has_breakfast else 'Not included'}")

# Create instances
campsite = Campsite("Camping Vale", "Palmeiras, BA", 120.00, 30, True)
hotel = Hotel("Hotel Serra", "Petrópolis, RJ", 250.00, 4, True)

# Both inherit calculate_total from parent
print(f"Campsite 3 nights: R${campsite.calculate_total(3):.2f}")
print(f"Hotel 3 nights: R${hotel.calculate_total(3):.2f}")

print("\n")

# Each has its own display_info
campsite.display_info()
# Output:
# 📍 Camping Vale
#    Location: Palmeiras, BA
#    Price: R$120.00/night
#    Capacity: 30 people
#    Electricity: Yes

print("\n")

hotel.display_info()
# Output:
# 📍 Hotel Serra
#    Location: Petrópolis, RJ
#    Price: R$250.00/night
#    Stars: ⭐⭐⭐⭐
#    Breakfast: Included
```

### Method Overriding

Child classes can override (replace) parent methods:

```python
class Accommodation:
    def __init__(self, name, price):
        self.name = name
        self.price = price
    
    def calculate_total(self, nights):
        """Base calculation."""
        return self.price * nights

class Campsite(Accommodation):
    def __init__(self, name, price):
        super().__init__(name, price)
    
    def calculate_total(self, nights):
        """Campsite: 10% discount for 7+ nights."""
        total = super().calculate_total(nights)  # Call parent method
        
        if nights >= 7:
            discount = total * 0.10
            total = total - discount
            print(f"✅ Applied 10% weekly discount: R${discount:.2f}")
        
        return total

class Hotel(Accommodation):
    def __init__(self, name, price):
        super().__init__(name, price)
    
    def calculate_total(self, nights):
        """Hotel: Add 10% service fee."""
        base_total = super().calculate_total(nights)
        service_fee = base_total * 0.10
        total = base_total + service_fee
        print(f"ℹ️  Service fee added: R${service_fee:.2f}")
        return total

# Test different behaviors
campsite = Campsite("Camp A", 100.00)
hotel = Hotel("Hotel B", 200.00)

print("Campsite (3 nights):")
print(f"Total: R${campsite.calculate_total(3):.2f}\n")

print("Campsite (7 nights):")
print(f"Total: R${campsite.calculate_total(7):.2f}\n")
# Output:
# ✅ Applied 10% weekly discount: R$70.00
# Total: R$630.00

print("Hotel (3 nights):")
print(f"Total: R${hotel.calculate_total(3):.2f}")
# Output:
# ℹ️  Service fee added: R$60.00
# Total: R$660.00
```

### Multiple Inheritance

Python supports multiple inheritance (inheriting from multiple parents):

```python
class Amenity:
    """Mixin class for amenities."""
    
    def __init__(self):
        self.amenities = []
    
    def add_amenity(self, amenity):
        """Add an amenity."""
        self.amenities.append(amenity)
        print(f"✅ Added amenity: {amenity}")
    
    def list_amenities(self):
        """List all amenities."""
        if self.amenities:
            print("Amenities:")
            for amenity in self.amenities:
                print(f"  ✓ {amenity}")
        else:
            print("No amenities")

class Review:
    """Mixin class for reviews."""
    
    def __init__(self):
        self.reviews = []
    
    def add_review(self, rating, comment):
        """Add a review."""
        self.reviews.append({'rating': rating, 'comment': comment})
        print(f"✅ Added review: ⭐{rating}/5")
    
    def get_average_rating(self):
        """Calculate average rating."""
        if not self.reviews:
            return 0
        total = sum(r['rating'] for r in self.reviews)
        return total / len(self.reviews)

class Campsite(Accommodation, Amenity, Review):
    """Campsite with multiple inheritance."""
    
    def __init__(self, name, location, price, capacity):
        # Initialize all parent classes
        Accommodation.__init__(self, name, location, price)
        Amenity.__init__(self)
        Review.__init__(self)
        
        self.capacity = capacity
    
    def display_full_info(self):
        """Display all information."""
        self.display_info()
        print(f"   Capacity: {self.capacity}")
        print(f"   Average Rating: ⭐{self.get_average_rating():.1f}/5")
        self.list_amenities()

# Create campsite
camp = Campsite("Camping Vale", "Palmeiras, BA", 120.00, 30)

# Use methods from all parent classes
camp.add_amenity("Toilet")
camp.add_amenity("Shower")
camp.add_amenity("Electricity")

camp.add_review(5, "Amazing place!")
camp.add_review(4, "Very good")
camp.add_review(5, "Perfect!")

print("\n")
camp.display_full_info()
```

### Real-World Example: Data Source Hierarchy

```python
from abc import ABC, abstractmethod
from pathlib import Path

class DataSource(ABC):
    """Abstract base class for data sources."""
    
    def __init__(self, name):
        self.name = name
        self._data = None
    
    @abstractmethod
    def load(self):
        """Load data from source. Must be implemented by children."""
        pass
    
    @abstractmethod
    def save(self, data):
        """Save data to source. Must be implemented by children."""
        pass
    
    def get_data(self):
        """Get loaded data."""
        if self._data is None:
            raise ValueError("Data not loaded. Call load() first.")
        return self._data
    
    def get_row_count(self):
        """Get number of rows."""
        data = self.get_data()
        return len(data)

class CSVDataSource(DataSource):
    """CSV file data source."""
    
    def __init__(self, name, file_path):
        super().__init__(name)
        self.file_path = Path(file_path)
    
    def load(self):
        """Load data from CSV."""
        import csv
        
        print(f"📖 Loading CSV from {self.file_path}")
        
        with open(self.file_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            self._data = list(reader)
        
        print(f"✅ Loaded {len(self._data)} rows from CSV")
        return self._data
    
    def save(self, data):
        """Save data to CSV."""
        import csv
        
        if not data:
            raise ValueError("No data to save")
        
        print(f"💾 Saving {len(data)} rows to {self.file_path}")
        
        self.file_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.file_path, 'w', newline='', encoding='utf-8') as file:
            writer = csv.DictWriter(file, fieldnames=data[0].keys())
            writer.writeheader()
            writer.writerows(data)
        
        print(f"✅ Saved to {self.file_path}")

class JSONDataSource(DataSource):
    """JSON file data source."""
    
    def __init__(self, name, file_path):
        super().__init__(name)
        self.file_path = Path(file_path)
    
    def load(self):
        """Load data from JSON."""
        import json
        
        print(f"📖 Loading JSON from {self.file_path}")
        
        with open(self.file_path, 'r', encoding='utf-8') as file:
            self._data = json.load(file)
        
        print(f"✅ Loaded {len(self._data)} rows from JSON")
        return self._data
    
    def save(self, data):
        """Save data to JSON."""
        import json
        
        if not data:
            raise ValueError("No data to save")
        
        print(f"💾 Saving {len(data)} rows to {self.file_path}")
        
        self.file_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.file_path, 'w', encoding='utf-8') as file:
            json.dump(data, file, indent=4, ensure_ascii=False)
        
        print(f"✅ Saved to {self.file_path}")

class DatabaseDataSource(DataSource):
    """Database table data source."""
    
    def __init__(self, name, connection_string, table_name):
        super().__init__(name)
        self.connection_string = connection_string
        self.table_name = table_name
    
    def load(self):
        """Load data from database."""
        # Note: This is a simplified example
        # In real code, use pandas: pd.read_sql_table()
        print(f"📖 Loading from database table: {self.table_name}")
        
        # Simulated data
        self._data = [
            {'id': 1, 'name': 'Camp A', 'price': 100},
            {'id': 2, 'name': 'Camp B', 'price': 80}
        ]
        
        print(f"✅ Loaded {len(self._data)} rows from database")
        return self._data
    
    def save(self, data):
        """Save data to database."""
        print(f"💾 Saving {len(data)} rows to table: {self.table_name}")
        # In real code: df.to_sql(table_name, engine)
        print(f"✅ Saved to database")

# Use polymorphism - same interface, different implementations!
sources = [
    CSVDataSource("Campsites CSV", "data/campsites.csv"),
    JSONDataSource("Campsites JSON", "data/campsites.json"),
    DatabaseDataSource("Campsites DB", "postgresql://...", "campsites")
]

# Process all sources the same way!
for source in sources:
    print(f"\nProcessing: {source.name}")
    data = source.load()
    print(f"Rows: {source.get_row_count()}")
    print("-" * 50)
```

---

## 5. Polymorphism and Special Methods

### What is Polymorphism?

**Polymorphism** means "many forms". It allows different classes to be treated through the same interface.

```python
# Different classes, same method name
class Campsite:
    def get_type(self):
        return "Campsite"

class Hotel:
    def get_type(self):
        return "Hotel"

class Hostel:
    def get_type(self):
        return "Hostel"

# Polymorphism - call same method on different objects
accommodations = [Campsite(), Hotel(), Hostel()]

for acc in accommodations:
    print(acc.get_type())  # Different behavior for each!
```

### Special Methods (Dunder Methods)

Special methods (also called **magic methods**) start and end with double underscores `__`.

```python
class Campsite:
    def __init__(self, name, state, price):
        self.name = name
        self.state = state
        self.price = price
    
    def __str__(self):
        """String representation for users (str(obj) or print(obj))."""
        return f"{self.name} ({self.state}) - R${self.price:.2f}/night"
    
    def __repr__(self):
        """String representation for developers (repr(obj))."""
        return f"Campsite(name='{self.name}', state='{self.state}', price={self.price})"
    
    def __eq__(self, other):
        """Equality comparison (obj1 == obj2)."""
        if not isinstance(other, Campsite):
            return False
        return self.name == other.name and self.state == other.state
    
    def __lt__(self, other):
        """Less than comparison (obj1 < obj2) - for sorting."""
        return self.price < other.price
    
    def __len__(self):
        """Length (len(obj))."""
        return len(self.name)
    
    def __add__(self, other):
        """Addition (obj1 + obj2)."""
        if isinstance(other, (int, float)):
            return Campsite(self.name, self.state, self.price + other)
        raise TypeError("Can only add numbers to price")
    
    def __getitem__(self, key):
        """Indexing (obj[key])."""
        if key == 'name':
            return self.name
        elif key == 'state':
            return self.state
        elif key == 'price':
            return self.price
        raise KeyError(f"Invalid key: {key}")

# Test special methods
camp = Campsite("Camping Vale", "BA", 120.00)

# __str__ - for print()
print(camp)
# Output: Camping Vale (BA) - R$120.00/night

# __repr__ - for debugging
print(repr(camp))
# Output: Campsite(name='Camping Vale', state='BA', price=120.0)

# __eq__ - for comparison
camp2 = Campsite("Camping Vale", "BA", 120.00)
print(camp == camp2)  # True (same name and state)

# __lt__ - for sorting
camps = [
    Campsite("Camp A", "BA", 100.00),
    Campsite("Camp B", "RJ", 80.00),
    Campsite("Camp C", "MG", 120.00)
]
sorted_camps = sorted(camps)  # Uses __lt__ to compare
for c in sorted_camps:
    print(f"{c.name}: R${c.price:.2f}")
# Output (sorted by price):
# Camp B: R$80.00
# Camp A: R$100.00
# Camp C: R$120.00

# __len__
print(f"Name length: {len(camp)}")  # Length of name: 13

# __add__
expensive_camp = camp + 30  # Add R$30 to price
print(expensive_camp)
# Output: Camping Vale (BA) - R$150.00/night

# __getitem__
print(camp['name'])   # Camping Vale
print(camp['price'])  # 120.0
```

### Complete Special Methods Reference

```python
class CompleteExample:
    """Class demonstrating common special methods."""
    
    # Object Creation and Deletion
    def __init__(self, value):
        """Constructor."""
        self.value = value
    
    def __del__(self):
        """Destructor (called when object is deleted)."""
        print(f"Object {self.value} is being deleted")
    
    # String Representation
    def __str__(self):
        """User-friendly string (print, str)."""
        return f"Value: {self.value}"
    
    def __repr__(self):
        """Developer string (repr, debugging)."""
        return f"CompleteExample({self.value})"
    
    # Comparison Operators
    def __eq__(self, other):
        """Equal to =="""
        return self.value == other.value
    
    def __ne__(self, other):
        """Not equal to !="""
        return self.value != other.value
    
    def __lt__(self, other):
        """Less than <"""
        return self.value < other.value
    
    def __le__(self, other):
        """Less than or equal <="""
        return self.value <= other.value
    
    def __gt__(self, other):
        """Greater than >"""
        return self.value > other.value
    
    def __ge__(self, other):
        """Greater than or equal >="""
        return self.value >= other.value
    
    # Arithmetic Operators
    def __add__(self, other):
        """Addition +"""
        return CompleteExample(self.value + other.value)
    
    def __sub__(self, other):
        """Subtraction -"""
        return CompleteExample(self.value - other.value)
    
    def __mul__(self, other):
        """Multiplication *"""
        if isinstance(other, (int, float)):
            return CompleteExample(self.value * other)
        return CompleteExample(self.value * other.value)
    
    def __truediv__(self, other):
        """Division /"""
        return CompleteExample(self.value / other)
    
    # Container Methods
    def __len__(self):
        """Length len()"""
        return len(str(self.value))
    
    def __getitem__(self, key):
        """Indexing obj[key]"""
        return str(self.value)[key]
    
    def __contains__(self, item):
        """Membership 'item in obj'"""
        return str(item) in str(self.value)
    
    # Context Manager
    def __enter__(self):
        """Enter 'with' statement."""
        print(f"Entering context: {self.value}")
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Exit 'with' statement."""
        print(f"Exiting context: {self.value}")
        return False
    
    # Callable
    def __call__(self, *args, **kwargs):
        """Make object callable like a function."""
        print(f"Called with args: {args}, kwargs: {kwargs}")
        return self.value
```

---

## 6. Practice Exercises

### Exercise 1: Customer Management System (⭐)

**Objective:** Create a `Customer` class with basic OOP concepts.

**Requirements:**
- Create a `Customer` class with attributes: `name`, `email`, `phone`
- Add method `display_info()` to show customer details
- Add method `update_email(new_email)` to update email with validation
- Create 3 customers and test all methods

<details>
<summary>💡 Click to see solution</summary>

```python
class Customer:
    """Customer class for managing customer data."""
    
    def __init__(self, name, email, phone):
        """Initialize customer."""
        self.name = name
        self.email = email
        self.phone = phone
    
    def display_info(self):
        """Display customer information."""
        print(f"{'='*40}")
        print(f"Customer: {self.name}")
        print(f"Email: {self.email}")
        print(f"Phone: {self.phone}")
        print(f"{'='*40}")
    
    def update_email(self, new_email):
        """Update email with validation."""
        # Simple validation
        if '@' not in new_email or '.' not in new_email:
            print(f"❌ Invalid email: {new_email}")
            return False
        
        old_email = self.email
        self.email = new_email
        print(f"✅ Email updated from {old_email} to {new_email}")
        return True

# Test the class
customer1 = Customer("João Silva", "joao@email.com", "(11) 98765-4321")
customer2 = Customer("Maria Santos", "maria@email.com", "(21) 99876-5432")
customer3 = Customer("Pedro Costa", "pedro@email.com", "(31) 97654-3210")

# Display all customers
customer1.display_info()
customer2.display_info()
customer3.display_info()

# Update email
customer1.update_email("joao.silva@newemail.com")  # Valid
customer2.update_email("invalid-email")  # Invalid
```

**What you learned:**
- ✅ Creating classes with `__init__`
- ✅ Instance attributes
- ✅ Instance methods
- ✅ Basic validation
</details>

---

### Exercise 2: Bank Account with Encapsulation (⭐⭐)

**Objective:** Create a `BankAccount` class with proper encapsulation.

**Requirements:**
- Private attribute `__balance`
- Property `balance` (read-only)
- Methods: `deposit(amount)`, `withdraw(amount)`, `transfer(other_account, amount)`
- Validate all operations (positive amounts, sufficient funds)
- Track number of transactions

<details>
<summary>💡 Click to see solution</summary>

```python
from datetime import datetime

class BankAccount:
    """Bank account with encapsulated balance."""
    
    # Class attribute - track total accounts
    total_accounts = 0
    
    def __init__(self, account_number, owner_name, initial_balance=0):
        """Initialize bank account."""
        self.account_number = account_number
        self.owner_name = owner_name
        self.__balance = initial_balance  # Private
        self.__transaction_count = 0  # Private
        
        # Increment class counter
        BankAccount.total_accounts += 1
    
    @property
    def balance(self):
        """Get balance (read-only)."""
        return self.__balance
    
    @property
    def transaction_count(self):
        """Get transaction count (read-only)."""
        return self.__transaction_count
    
    def deposit(self, amount):
        """Deposit money."""
        if amount <= 0:
            print(f"❌ Deposit amount must be positive")
            return False
        
        self.__balance += amount
        self.__transaction_count += 1
        print(f"✅ Deposited R${amount:.2f}. New balance: R${self.__balance:.2f}")
        return True
    
    def withdraw(self, amount):
        """Withdraw money."""
        if amount <= 0:
            print(f"❌ Withdrawal amount must be positive")
            return False
        
        if amount > self.__balance:
            print(f"❌ Insufficient funds. Balance: R${self.__balance:.2f}")
            return False
        
        self.__balance -= amount
        self.__transaction_count += 1
        print(f"✅ Withdrew R${amount:.2f}. New balance: R${self.__balance:.2f}")
        return True
    
    def transfer(self, other_account, amount):
        """Transfer money to another account."""
        if not isinstance(other_account, BankAccount):
            print(f"❌ Invalid account")
            return False
        
        print(f"\n💸 Transfer R${amount:.2f}: {self.owner_name} → {other_account.owner_name}")
        
        # Withdraw from this account
        if self.withdraw(amount):
            # Deposit to other account
            other_account.deposit(amount)
            print(f"✅ Transfer complete!")
            return True
        
        return False
    
    def display_info(self):
        """Display account information."""
        print(f"\n{'='*50}")
        print(f"Account: {self.account_number}")
        print(f"Owner: {self.owner_name}")
        print(f"Balance: R${self.__balance:.2f}")
        print(f"Transactions: {self.__transaction_count}")
        print(f"{'='*50}")
    
    @classmethod
    def get_total_accounts(cls):
        """Get total number of accounts."""
        return cls.total_accounts

# Test the class
account1 = BankAccount("001-1", "João Silva", 1000.00)
account2 = BankAccount("002-2", "Maria Santos", 500.00)
account3 = BankAccount("003-3", "Pedro Costa", 2000.00)

print(f"Total accounts: {BankAccount.get_total_accounts()}\n")

# Test deposits
account1.deposit(500.00)
account1.deposit(-100.00)  # Invalid

# Test withdrawals
account2.withdraw(200.00)
account2.withdraw(5000.00)  # Insufficient funds

# Test transfers
account1.transfer(account2, 300.00)
account3.transfer(account1, 1500.00)

# Display all accounts
account1.display_info()
account2.display_info()
account3.display_info()

# Try to directly modify balance (won't work!)
# account1.__balance = 999999.99  # Won't work!
print(f"\nAccount 1 balance (read-only): R${account1.balance:.2f}")
```

**What you learned:**
- ✅ Private attributes with `__`
- ✅ Properties with `@property`
- ✅ Encapsulation and data protection
- ✅ Class attributes and methods
- ✅ Object interaction (transfer between accounts)
</details>

---

### Exercise 3: Vehicle Hierarchy (⭐⭐)

**Objective:** Create an inheritance hierarchy for vehicles.

**Requirements:**
- Base class `Vehicle` with: `brand`, `model`, `year`, `price`
- Method `calculate_age()` to calculate vehicle age
- Method `display_info()` to show details
- Child class `Car` adds: `doors`, `fuel_type`
- Child class `Motorcycle` adds: `cylinder_capacity`, `has_abs`
- Override `display_info()` in child classes
- Create 2 cars and 2 motorcycles

<details>
<summary>💡 Click to see solution</summary>

```python
from datetime import datetime

class Vehicle:
    """Base class for all vehicles."""
    
    def __init__(self, brand, model, year, price):
        """Initialize vehicle."""
        self.brand = brand
        self.model = model
        self.year = year
        self.price = price
    
    def calculate_age(self):
        """Calculate vehicle age."""
        current_year = datetime.now().year
        return current_year - self.year
    
    def display_info(self):
        """Display vehicle information."""
        print(f"\n{'='*50}")
        print(f"🚗 {self.brand} {self.model}")
        print(f"   Year: {self.year} ({self.calculate_age()} years old)")
        print(f"   Price: R${self.price:,.2f}")
    
    def apply_depreciation(self, percentage):
        """Apply depreciation to price."""
        depreciation = self.price * (percentage / 100)
        self.price -= depreciation
        print(f"✅ Applied {percentage}% depreciation: -R${depreciation:,.2f}")
        print(f"   New price: R${self.price:,.2f}")

class Car(Vehicle):
    """Car class - inherits from Vehicle."""
    
    def __init__(self, brand, model, year, price, doors, fuel_type):
        """Initialize car."""
        super().__init__(brand, model, year, price)
        self.doors = doors
        self.fuel_type = fuel_type
    
    def display_info(self):
        """Display car information."""
        super().display_info()  # Call parent method
        print(f"   Type: Car")
        print(f"   Doors: {self.doors}")
        print(f"   Fuel: {self.fuel_type}")
        print(f"{'='*50}")
    
    def calculate_fuel_cost(self, distance_km, consumption_km_per_liter, fuel_price_per_liter):
        """Calculate fuel cost for a trip."""
        liters_needed = distance_km / consumption_km_per_liter
        total_cost = liters_needed * fuel_price_per_liter
        
        print(f"\n⛽ Fuel calculation for {distance_km}km trip:")
        print(f"   Consumption: {consumption_km_per_liter} km/L")
        print(f"   Fuel needed: {liters_needed:.2f} liters")
        print(f"   Cost: R${total_cost:.2f}")
        
        return total_cost

class Motorcycle(Vehicle):
    """Motorcycle class - inherits from Vehicle."""
    
    def __init__(self, brand, model, year, price, cylinder_capacity, has_abs):
        """Initialize motorcycle."""
        super().__init__(brand, model, year, price)
        self.cylinder_capacity = cylinder_capacity
        self.has_abs = has_abs
    
    def display_info(self):
        """Display motorcycle information."""
        super().display_info()
        print(f"   Type: Motorcycle")
        print(f"   Engine: {self.cylinder_capacity}cc")
        print(f"   ABS: {'Yes' if self.has_abs else 'No'}")
        print(f"{'='*50}")
    
    def calculate_fuel_cost(self, distance_km, consumption_km_per_liter, fuel_price_per_liter):
        """Calculate fuel cost for a trip."""
        liters_needed = distance_km / consumption_km_per_liter
        total_cost = liters_needed * fuel_price_per_liter
        
        print(f"\n⛽ Fuel calculation for {distance_km}km trip:")
        print(f"   Consumption: {consumption_km_per_liter} km/L")
        print(f"   Fuel needed: {liters_needed:.2f} liters")
        print(f"   Cost: R${total_cost:.2f}")
        print(f"   💚 Motorcycle efficiency advantage!")
        
        return total_cost

# Create vehicles
car1 = Car("Toyota", "Corolla", 2020, 85000.00, 4, "Gasoline")
car2 = Car("Honda", "Civic", 2019, 95000.00, 4, "Flex")

moto1 = Motorcycle("Honda", "CG 160", 2021, 12000.00, 160, False)
moto2 = Motorcycle("Yamaha", "MT-07", 2022, 45000.00, 689, True)

# Display all vehicles
vehicles = [car1, car2, moto1, moto2]

for vehicle in vehicles:
    vehicle.display_info()

# Apply depreciation
print("\n📉 Applying depreciation...")
car1.apply_depreciation(10)  # 10% depreciation
moto1.apply_depreciation(5)   # 5% depreciation

# Calculate fuel costs
car1.calculate_fuel_cost(distance_km=500, consumption_km_per_liter=12, fuel_price_per_liter=5.50)
moto1.calculate_fuel_cost(distance_km=500, consumption_km_per_liter=35, fuel_price_per_liter=5.50)

# Sort by price
print("\n💰 Vehicles sorted by price:")
sorted_vehicles = sorted(vehicles, key=lambda v: v.price)
for v in sorted_vehicles:
    print(f"   {v.brand} {v.model}: R${v.price:,.2f}")
```

**What you learned:**
- ✅ Creating inheritance hierarchies
- ✅ Using `super()` to call parent methods
- ✅ Method overriding
- ✅ Polymorphism (same method, different behavior)
- ✅ Working with collections of objects
</details>

---

### Exercise 4: Data Processor with Special Methods (⭐⭐⭐)

**Objective:** Create a `DataProcessor` class with special methods.

**Requirements:**
- Store a list of data records (dictionaries)
- Implement `__len__()` to get record count
- Implement `__getitem__()` for indexing
- Implement `__iter__()` to make iterable
- Implement `__str__()` and `__repr__()`
- Implement `__add__()` to merge processors
- Add methods: `add_record()`, `filter_by()`, `get_stats()`

<details>
<summary>💡 Click to see solution</summary>

```python
from statistics import mean, median

class DataProcessor:
    """Data processor with special methods."""
    
    def __init__(self, name, records=None):
        """Initialize data processor."""
        self.name = name
        self._records = records if records else []
        self._current_index = 0
    
    def add_record(self, record):
        """Add a record."""
        if not isinstance(record, dict):
            raise TypeError("Record must be a dictionary")
        
        self._records.append(record)
        print(f"✅ Added record: {record}")
    
    def filter_by(self, field, value):
        """Filter records by field value."""
        filtered = [r for r in self._records if r.get(field) == value]
        return DataProcessor(f"{self.name} (filtered)", filtered)
    
    def get_stats(self, numeric_field):
        """Get statistics for a numeric field."""
        values = [r[numeric_field] for r in self._records if numeric_field in r]
        
        if not values:
            return None
        
        stats = {
            'count': len(values),
            'min': min(values),
            'max': max(values),
            'mean': mean(values),
            'median': median(values),
            'sum': sum(values)
        }
        
        return stats
    
    # Special methods
    def __len__(self):
        """Return number of records."""
        return len(self._records)
    
    def __getitem__(self, index):
        """Get record by index."""
        return self._records[index]
    
    def __iter__(self):
        """Make iterable."""
        self._current_index = 0
        return self
    
    def __next__(self):
        """Get next item in iteration."""
        if self._current_index < len(self._records):
            record = self._records[self._current_index]
            self._current_index += 1
            return record
        else:
            raise StopIteration
    
    def __str__(self):
        """User-friendly string."""
        return f"DataProcessor: {self.name} ({len(self)} records)"
    
    def __repr__(self):
        """Developer string."""
        return f"DataProcessor(name='{self.name}', records={len(self._records)})"
    
    def __add__(self, other):
        """Merge two processors."""
        if not isinstance(other, DataProcessor):
            raise TypeError("Can only add DataProcessor objects")
        
        merged_name = f"{self.name} + {other.name}"
        merged_records = self._records + other._records
        
        return DataProcessor(merged_name, merged_records)
    
    def __eq__(self, other):
        """Check equality."""
        if not isinstance(other, DataProcessor):
            return False
        return self._records == other._records
    
    def display_summary(self):
        """Display summary."""
        print(f"\n{'='*60}")
        print(f"📊 {self.name}")
        print(f"   Records: {len(self)}")
        
        if self._records:
            print(f"   First record: {self._records[0]}")
            print(f"   Last record: {self._records[-1]}")
        
        print(f"{'='*60}")

# Create processor
processor = DataProcessor("Campsite Bookings")

# Add records
processor.add_record({'id': 1, 'campsite': 'Vale', 'nights': 3, 'price': 120})
processor.add_record({'id': 2, 'campsite': 'Serra', 'nights': 5, 'price': 100})
processor.add_record({'id': 3, 'campsite': 'Vale', 'nights': 2, 'price': 120})
processor.add_record({'id': 4, 'campsite': 'Praia', 'nights': 7, 'price': 150})

# Test special methods
print(f"\n🔢 Length: {len(processor)} records")

# Indexing
print(f"\n📇 First record (index 0): {processor[0]}")
print(f"📇 Last record (index -1): {processor[-1]}")

# Iteration
print(f"\n🔄 Iterating through records:")
for record in processor:
    print(f"   ID {record['id']}: {record['campsite']} - {record['nights']} nights")

# String representations
print(f"\n📝 str(): {str(processor)}")
print(f"📝 repr(): {repr(processor)}")

# Filter
filtered = processor.filter_by('campsite', 'Vale')
print(f"\n🔍 Filtered: {filtered}")
for record in filtered:
    print(f"   {record}")

# Statistics
stats = processor.get_stats('nights')
print(f"\n📈 Statistics for 'nights':")
for key, value in stats.items():
    print(f"   {key}: {value}")

stats = processor.get_stats('price')
print(f"\n📈 Statistics for 'price':")
for key, value in stats.items():
    print(f"   {key}: R${value:.2f}" if isinstance(value, float) else f"   {key}: {value}")

# Merge processors
processor2 = DataProcessor("More Bookings")
processor2.add_record({'id': 5, 'campsite': 'Monte', 'nights': 4, 'price': 130})
processor2.add_record({'id': 6, 'campsite': 'Vale', 'nights': 3, 'price': 120})

merged = processor + processor2
print(f"\n➕ Merged: {merged}")
print(f"   Total records: {len(merged)}")

# Display summaries
processor.display_summary()
merged.display_summary()
```

**What you learned:**
- ✅ Special methods (`__len__`, `__getitem__`, `__iter__`, `__next__`)
- ✅ Making classes iterable
- ✅ String representations (`__str__`, `__repr__`)
- ✅ Operator overloading (`__add__`, `__eq__`)
- ✅ Data processing patterns
- ✅ Statistics with standard library
</details>

---

### Exercise 5: Complete ETL Pipeline with OOP (⭐⭐⭐)

**Objective:** Build a complete ETL (Extract, Transform, Load) system using OOP principles.

**Requirements:**
- Abstract base class `ETLPipeline` with abstract methods
- `CSVExtractor` to read CSV files
- `DataTransformer` to clean and transform data
- `CSVLoader` to save processed data
- Use inheritance, encapsulation, and polymorphism
- Add logging and error handling
- Process real campsite booking data

<details>
<summary>💡 Click to see solution</summary>

```python
from abc import ABC, abstractmethod
from pathlib import Path
from datetime import datetime
import csv

class ETLComponent(ABC):
    """Abstract base class for ETL components."""
    
    def __init__(self, name):
        """Initialize component."""
        self.name = name
        self._log_messages = []
    
    def log(self, message):
        """Log a message."""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        log_entry = f"[{timestamp}] {self.name}: {message}"
        self._log_messages.append(log_entry)
        print(log_entry)
    
    def get_logs(self):
        """Get all log messages."""
        return self._log_messages.copy()
    
    @abstractmethod
    def execute(self, data=None):
        """Execute component. Must be implemented by subclasses."""
        pass

class CSVExtractor(ETLComponent):
    """Extract data from CSV file."""
    
    def __init__(self, file_path):
        """Initialize extractor."""
        super().__init__("CSVExtractor")
        self.file_path = Path(file_path)
    
    def execute(self, data=None):
        """Extract data from CSV."""
        self.log(f"Starting extraction from {self.file_path}")
        
        if not self.file_path.exists():
            self.log(f"❌ File not found: {self.file_path}")
            return []
        
        try:
            with open(self.file_path, 'r', encoding='utf-8') as file:
                reader = csv.DictReader(file)
                records = list(reader)
            
            self.log(f"✅ Extracted {len(records)} records")
            return records
        
        except Exception as e:
            self.log(f"❌ Error during extraction: {e}")
            return []

class DataTransformer(ETLComponent):
    """Transform and clean data."""
    
    def __init__(self):
        """Initialize transformer."""
        super().__init__("DataTransformer")
        self._transformations_applied = 0
    
    def execute(self, data):
        """Transform data."""
        if not data:
            self.log("⚠️  No data to transform")
            return []
        
        self.log(f"Starting transformation of {len(data)} records")
        
        transformed = []
        errors = 0
        
        for record in data:
            try:
                # Transform record
                transformed_record = self._transform_record(record)
                
                # Validate record
                if self._validate_record(transformed_record):
                    transformed.append(transformed_record)
                    self._transformations_applied += 1
                else:
                    self.log(f"⚠️  Invalid record skipped: {record}")
                    errors += 1
            
            except Exception as e:
                self.log(f"❌ Error transforming record: {e}")
                errors += 1
        
        self.log(f"✅ Transformed {len(transformed)} records ({errors} errors)")
        return transformed
    
    def _transform_record(self, record):
        """Transform a single record."""
        # Convert strings to appropriate types
        transformed = record.copy()
        
        # Convert numeric fields
        if 'nights' in transformed:
            transformed['nights'] = int(transformed['nights'])
        
        if 'price' in transformed:
            transformed['price'] = float(transformed['price'])
        
        # Calculate total cost
        if 'nights' in transformed and 'price' in transformed:
            transformed['total_cost'] = transformed['nights'] * transformed['price']
        
        # Add processing timestamp
        transformed['processed_at'] = datetime.now().isoformat()
        
        # Clean whitespace
        for key, value in transformed.items():
            if isinstance(value, str):
                transformed[key] = value.strip()
        
        return transformed
    
    def _validate_record(self, record):
        """Validate a record."""
        # Check required fields
        required_fields = ['id', 'campsite', 'nights', 'price']
        
        for field in required_fields:
            if field not in record:
                return False
        
        # Validate values
        if record['nights'] <= 0:
            return False
        
        if record['price'] <= 0:
            return False
        
        return True
    
    def get_stats(self):
        """Get transformation statistics."""
        return {
            'transformations_applied': self._transformations_applied
        }

class CSVLoader(ETLComponent):
    """Load data to CSV file."""
    
    def __init__(self, file_path):
        """Initialize loader."""
        super().__init__("CSVLoader")
        self.file_path = Path(file_path)
    
    def execute(self, data):
        """Load data to CSV."""
        if not data:
            self.log("⚠️  No data to load")
            return False
        
        self.log(f"Starting load of {len(data)} records to {self.file_path}")
        
        try:
            # Create directory if needed
            self.file_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Write CSV
            with open(self.file_path, 'w', newline='', encoding='utf-8') as file:
                writer = csv.DictWriter(file, fieldnames=data[0].keys())
                writer.writeheader()
                writer.writerows(data)
            
            self.log(f"✅ Loaded {len(data)} records to {self.file_path}")
            return True
        
        except Exception as e:
            self.log(f"❌ Error during load: {e}")
            return False

class ETLPipeline:
    """Complete ETL pipeline."""
    
    def __init__(self, name):
        """Initialize pipeline."""
        self.name = name
        self._components = []
        self._execution_time = None
    
    def add_component(self, component):
        """Add a component to pipeline."""
        if not isinstance(component, ETLComponent):
            raise TypeError("Component must be an ETLComponent")
        
        self._components.append(component)
        print(f"✅ Added component: {component.name}")
    
    def run(self):
        """Run the pipeline."""
        print(f"\n{'='*60}")
        print(f"🚀 Starting ETL Pipeline: {self.name}")
        print(f"   Components: {len(self._components)}")
        print(f"{'='*60}\n")
        
        start_time = datetime.now()
        
        # Run components in sequence
        data = None
        
        for i, component in enumerate(self._components, 1):
            print(f"\n--- Step {i}/{len(self._components)}: {component.name} ---")
            data = component.execute(data)
            
            if data is None or (isinstance(data, list) and len(data) == 0):
                print(f"⚠️  Pipeline stopped - no data from {component.name}")
                break
        
        end_time = datetime.now()
        self._execution_time = (end_time - start_time).total_seconds()
        
        print(f"\n{'='*60}")
        print(f"✅ Pipeline completed in {self._execution_time:.2f} seconds")
        print(f"{'='*60}\n")
    
    def get_all_logs(self):
        """Get logs from all components."""
        all_logs = []
        for component in self._components:
            all_logs.extend(component.get_logs())
        return all_logs
    
    def display_summary(self):
        """Display pipeline summary."""
        print(f"\n{'='*60}")
        print(f"📊 Pipeline Summary: {self.name}")
        print(f"   Components: {len(self._components)}")
        print(f"   Execution Time: {self._execution_time:.2f} seconds")
        print(f"\n   Component Details:")
        
        for component in self._components:
            print(f"      • {component.name}")
            
            if isinstance(component, DataTransformer):
                stats = component.get_stats()
                print(f"        Transformations: {stats['transformations_applied']}")
        
        print(f"{'='*60}\n")

# Example usage
def main():
    """Run ETL pipeline example."""
    
    # Create sample input CSV
    input_file = Path("data/bookings_raw.csv")
    input_file.parent.mkdir(parents=True, exist_ok=True)
    
    sample_data = [
        {'id': '1', 'campsite': 'Vale  ', 'nights': '3', 'price': '120.00'},
        {'id': '2', 'campsite': 'Serra', 'nights': '5', 'price': '100.00'},
        {'id': '3', 'campsite': 'Vale', 'nights': '2', 'price': '120.00'},
        {'id': '4', 'campsite': 'Praia ', 'nights': '7', 'price': '150.00'},
        {'id': '5', 'campsite': 'Monte', 'nights': '4', 'price': '130.00'},
    ]
    
    with open(input_file, 'w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=['id', 'campsite', 'nights', 'price'])
        writer.writeheader()
        writer.writerows(sample_data)
    
    print(f"✅ Created sample input file: {input_file}")
    
    # Create pipeline
    pipeline = ETLPipeline("Campsite Bookings ETL")
    
    # Add components
    pipeline.add_component(CSVExtractor("data/bookings_raw.csv"))
    pipeline.add_component(DataTransformer())
    pipeline.add_component(CSVLoader("data/bookings_processed.csv"))
    
    # Run pipeline
    pipeline.run()
    
    # Display summary
    pipeline.display_summary()
    
    # Show logs
    print("📝 Pipeline Logs:")
    for log in pipeline.get_all_logs():
        print(f"   {log}")

# Run the example
if __name__ == "__main__":
    main()
```

**What you learned:**
- ✅ Abstract base classes with ABC
- ✅ Inheritance hierarchies
- ✅ Encapsulation (protected attributes)
- ✅ Polymorphism (same interface, different implementations)
- ✅ Composition (pipeline contains components)
- ✅ Error handling and logging
- ✅ Real-world ETL pattern
- ✅ Professional code structure
</details>

---

## 7. Summary and Next Steps

### What You Learned

**🎯 OOP Fundamentals:**
- ✅ Classes and Objects (blueprints vs instances)
- ✅ `__init__` constructor method
- ✅ `self` parameter (instance reference)
- ✅ Instance attributes and methods
- ✅ Class attributes and methods (`@classmethod`)
- ✅ Static methods (`@staticmethod`)

**🔒 Encapsulation:**
- ✅ Public, protected (`_`), and private (`__`) members
- ✅ Property decorators (`@property`)
- ✅ Getters and setters with validation
- ✅ Data hiding and protection

**♻️ Inheritance:**
- ✅ Parent/child class relationships
- ✅ `super()` function
- ✅ Method overriding
- ✅ Multiple inheritance
- ✅ Abstract base classes (ABC)

**🎭 Polymorphism:**
- ✅ Same interface, different implementations
- ✅ Method overriding
- ✅ Special methods (dunder methods)
- ✅ Operator overloading
- ✅ Making classes work with built-in functions

**🏗️ Design Patterns:**
- ✅ Factory methods
- ✅ Composition over inheritance
- ✅ ETL pipeline pattern
- ✅ Iterator pattern

### Why This Matters for Data Engineering

Now you understand the OOP concepts used in:

1. **SQLAlchemy ORM** (from Lesson 3):
   - Model classes (classes representing tables)
   - Relationships (inheritance and composition)
   - `__repr__` for debugging
   - Properties for computed columns

2. **pandas DataFrames**:
   - `df.head()` - instance method
   - `df.shape` - property
   - `df + df2` - operator overloading (`__add__`)
   - `len(df)` - special method (`__len__`)

3. **PySpark** (future lesson):
   - DataFrame operations (method chaining)
   - Custom transformers (inheritance)
   - UDFs wrapped in classes

4. **Airflow** (future lesson):
   - Custom operators (inheritance from `BaseOperator`)
   - Task definitions using classes
   - Plugins and hooks

### Next Steps

**✅ Completed:**
- Module 2, Lesson 1: Python Fundamentals
- Module 2, Lesson 2: Files & Data Formats
- Module 2, Lesson 3: Database Connectivity
- Module 2, Lesson 4: Object-Oriented Programming ← **YOU ARE HERE**

**⏭️  Next Lesson:**
- Module 2, Lesson 5: Error Handling & Logging
  - Exception handling in class methods
  - Custom exception classes (using inheritance!)
  - Logging with class-based loggers
  - Context managers for resource management

**🚀 Future Modules:**
- Module 3: Advanced Python & Testing
- Module 4: SQL Performance & Optimization
- Module 5: Data Processing with Polars & DuckDB
- Module 6: Apache Airflow for Data Pipelines
- Module 7: PySpark for Big Data
- Module 8: Real Project - Digital Marketing Pipeline
- Module 9: Real Project - Brazilian Outdoor Platform

### Practice Recommendations

1. **Revisit Lesson 3** (Database Connectivity):
   - Now you understand the SQLAlchemy ORM examples!
   - Review the Model classes with inheritance
   - Understand the special methods used

2. **Create Your Own Classes**:
   - Model your own domain (e-commerce, inventory, etc.)
   - Practice inheritance hierarchies
   - Use special methods

3. **Refactor Old Code**:
   - Take procedural code from earlier lessons
   - Refactor it to use OOP
   - Compare readability and maintainability

---

**🎉 Congratulations!**

You now have a solid foundation in Object-Oriented Programming! You understand:
- How to structure code with classes
- How to reuse code with inheritance
- How to protect data with encapsulation
- How to create flexible interfaces with polymorphism

These skills are essential for:
- Working with modern Python libraries
- Building scalable data pipelines
- Writing maintainable production code
- Collaborating with software engineers

**Ready to continue with Error Handling & Logging?** 🚀
