# Practice Project 1: Complete ETL System

## 🎯 Project Overview

Build a **production-ready ETL (Extract, Transform, Load) system** for the Brazilian Outdoor Platform using all OOP concepts learned.

**What You'll Build:**
- Multi-source data extraction (CSV, JSON, API simulation)
- Data validation and transformation pipeline
- Multiple destination loaders (PostgreSQL, File, JSON)
- Configuration management
- Logging and error handling
- Data quality monitoring
- Statistics and reporting

**Time Estimate**: 4-6 hours  
**Difficulty**: Intermediate  
**Prerequisites**: Completed OOP Lessons and Enhanced Explanations

---

## 📋 Project Requirements

### Functional Requirements:
1. **Extract** data from multiple sources (CSV files, JSON files)
2. **Transform** data (cleaning, validation, enrichment)
3. **Load** data into PostgreSQL database
4. **Validate** data quality at each step
5. **Log** all operations with timestamps
6. **Handle** errors gracefully without crashing
7. **Report** statistics (rows processed, errors, duration)
8. **Configure** via external config file

### Technical Requirements:
1. Use **classes** for all major components
2. Use **inheritance** for data sources and loaders
3. Use **encapsulation** for credentials and sensitive data
4. Use **polymorphism** for multiple source/loader types
5. Use **special methods** for container-like behavior
6. Follow **OOP best practices**

---

## 🏗️ Project Structure

```
etl_system/
│
├── config/
│   └── etl_config.json          # Configuration file
│
├── data/
│   ├── input/
│   │   ├── campsites.csv        # Sample input data
│   │   ├── bookings.json        # Sample input data
│   │   └── customers.csv        # Sample input data
│   │
│   └── output/
│       └── processed/           # Output files
│
├── logs/
│   └── etl.log                  # Log file
│
├── src/
│   ├── __init__.py
│   ├── config_manager.py        # Configuration management
│   ├── logger.py                # Logging system
│   ├── sources.py               # Data sources (CSV, JSON, API)
│   ├── transformers.py          # Data transformers
│   ├── validators.py            # Data validators
│   ├── loaders.py               # Data loaders (DB, File)
│   ├── pipeline.py              # Main ETL pipeline
│   └── statistics.py            # Statistics collector
│
├── main.py                      # Entry point
├── requirements.txt             # Dependencies
└── README.md                    # Documentation
```

---

## 📝 Step 1: Configuration Manager

### 🎯 What This Does:

The **Configuration Manager** is like a settings control panel for your ETL system. Instead of hardcoding database passwords or file paths in your code, you store them in a JSON file. This class:

- **Reads** configuration from `config/etl_config.json`
- **Hides** sensitive data (passwords) using private attributes
- **Validates** settings before use
- **Provides** read-only access to configs using `@property` decorators

### 💡 Why This Matters:

Imagine you have database connection details scattered throughout your code. If you need to change the password, you'd have to find and update it everywhere! With Configuration Manager:

```python
# ❌ BAD: Hardcoded credentials everywhere
connection = psycopg2.connect("host=localhost user=postgres password=secret123")

# ✅ GOOD: Centralized configuration
config = ConfigurationManager('config/etl_config.json')
db_config = config.database_config
connection = psycopg2.connect(**db_config)
```

### 🔍 Code Explanation:

Create `src/config_manager.py`:

```python
"""Configuration management for ETL system."""

import json
from pathlib import Path
from datetime import datetime


class ConfigurationManager:
    """Manages ETL configuration with encapsulation.
    
    Demonstrates:
    - Encapsulation (private attributes)
    - Property decorators
    - File operations
    """
    
    def __init__(self, config_file):
        """Initialize configuration manager.
        
        Args:
            config_file: Path to configuration JSON file
        
        Example:
            >>> config = ConfigurationManager('config/etl_config.json')
            ⚙️  Configuration Manager initialized
               Config file: config/etl_config.json
        """
        # Private attributes (double underscore = encapsulation)
        self.__config_file = Path(config_file)  # Hide file path
        self.__config = {}                       # Hide raw config data
        self.__loaded_at = None                  # Track when loaded
        self.__modified = False                  # Track if changed
        
        print(f"⚙️  Configuration Manager initialized")
        print(f"   Config file: {self.__config_file}")
    
    def load(self):
        """Load configuration from file.
        
        This method:
        1. Checks if config file exists
        2. If not, creates default configuration
        3. If yes, reads JSON and parses it
        4. Stores loaded data in private __config attribute
        
        Example:
            >>> config.load()
            📖 Loading configuration...
            ✅ Configuration loaded!
        """
        if not self.__config_file.exists():
            print(f"⚠️  Config file not found, creating default...")
            self.__config = self._get_default_config()
            self.save()
            return
        
        print(f"📖 Loading configuration...")
        
        # Read JSON file
        with open(self.__config_file, 'r') as f:
            self.__config = json.load(f)
        
        self.__loaded_at = datetime.now()
        self.__modified = False
        
        print(f"✅ Configuration loaded!")
    
    def _get_default_config(self):
        """Get default configuration.
        
        This creates a complete configuration structure with:
        - Database connection details (PostgreSQL or SQLite)
        - Data source file paths
        - Output settings
        - Pipeline behavior settings
        - Logging configuration
        
        Returns:
            dict: Default configuration dictionary
        """
        return {
            "database": {
                "host": "localhost",
                "port": 5432,
                "database": "camping_db",
                "user": "postgres",
                "password": "your_password"
            },
            "sources": {
                "campsites": "data/input/campsites.csv",
                "bookings": "data/input/bookings.json",
                "customers": "data/input/customers.csv"
            },
            "output": {
                "directory": "data/output/processed",
                "format": "json"
            },
            "pipeline": {
                "batch_size": 100,
                "max_errors": 10,
                "continue_on_error": True
            },
            "logging": {
                "level": "INFO",
                "file": "logs/etl.log",
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            }
        }
    
    @property
    def database_config(self):
        """Get database configuration (read-only).
        
        The @property decorator makes this look like an attribute
        but it's actually a method. This provides read-only access.
        
        Returns:
            dict: Database configuration (copy, not original)
        
        Example:
            >>> db_config = config.database_config
            >>> print(db_config['host'])
            localhost
            
            >>> # User can't modify the original:
            >>> db_config['host'] = 'hacker.com'  # Only changes the copy!
        """
        return self.__config.get('database', {}).copy()
    
    @property
    def sources_config(self):
        """Get sources configuration (read-only).
        
        Returns:
            dict: Sources configuration
        
        Example:
            >>> sources = config.sources_config
            >>> print(sources['campsites'])
            data/input/campsites.csv
        """
        return self.__config.get('sources', {}).copy()
    
    @property
    def output_config(self):
        """Get output configuration (read-only).
        
        Returns:
            dict: Output configuration
        """
        return self.__config.get('output', {}).copy()
    
    @property
    def pipeline_config(self):
        """Get pipeline configuration (read-only).
        
        Returns:
            dict: Pipeline configuration
        """
        return self.__config.get('pipeline', {}).copy()
    
    @property
    def logging_config(self):
        """Get logging configuration (read-only).
        
        Returns:
            dict: Logging configuration
        """
        return self.__config.get('logging', {}).copy()
    
    def get_value(self, section, key, default=None):
        """Get specific configuration value.
        
        Args:
            section: Configuration section (e.g., 'database')
            key: Configuration key (e.g., 'host')
            default: Default value if not found
            
        Returns:
            Configuration value
        
        Example:
            >>> port = config.get_value('database', 'port', default=5432)
            >>> print(port)
            5432
        """
        return self.__config.get(section, {}).get(key, default)
    
    def set_value(self, section, key, value):
        """Set specific configuration value.
        
        Args:
            section: Configuration section
            key: Configuration key
            value: Value to set
        
        Example:
            >>> config.set_value('database', 'host', 'new-server.com')
            >>> config.save()  # Don't forget to save!
        """
        if section not in self.__config:
            self.__config[section] = {}
        
        self.__config[section][key] = value
        self.__modified = True
    
    def save(self):
        """Save configuration to file.
        
        Example:
            >>> config.set_value('database', 'port', 5433)
            >>> config.save()
            💾 Saving configuration...
            ✅ Configuration saved!
        """
        print(f"💾 Saving configuration...")
        
        # Create parent directory if needed
        self.__config_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Write JSON with nice formatting (indent=2)
        with open(self.__config_file, 'w') as f:
            json.dump(self.__config, f, indent=2)
        
        self.__modified = False
        print(f"✅ Configuration saved!")
    
    def is_modified(self):
        """Check if configuration has been modified.
        
        Returns:
            bool: True if modified, False otherwise
        """
        return self.__modified
    
    def display(self):
        """Display configuration summary.
        
        This prints a nice formatted view of all settings,
        hiding sensitive values like passwords.
        """
        print(f"\n{'='*70}")
        print(f"⚙️  ETL CONFIGURATION")
        print(f"{'='*70}")
        print(f"Config File: {self.__config_file}")
        print(f"Loaded At: {self.__loaded_at or 'Not loaded'}")
        print(f"Modified: {'Yes' if self.__modified else 'No'}")
        
        for section, values in self.__config.items():
            print(f"\n[{section}]")
            for key, value in values.items():
                # Hide sensitive values
                if 'password' in key.lower() or 'secret' in key.lower():
                    value = '***HIDDEN***'
                print(f"  {key}: {value}")
        
        print(f"{'='*70}\n")
```

### 📚 Real-World Data Source Examples:

#### Example 1: PostgreSQL Configuration
```json
{
  "database": {
    "type": "postgresql",
    "host": "localhost",
    "port": 5432,
    "database": "camping_db",
    "user": "data_engineer",
    "password": "secure_password_123"
  }
}
```

#### Example 2: SQLite Configuration
```json
{
  "database": {
    "type": "sqlite",
    "path": "data/camping.db"
  }
}
```

#### Example 3: API Configuration
```json
{
  "api": {
    "base_url": "https://api.camping.com",
    "api_key": "your_api_key_here",
    "endpoints": {
      "campsites": "/v1/campsites",
      "bookings": "/v1/bookings"
    }
  }
}
```

### 🎯 How to Use:

```python
# Step 1: Create configuration manager
config = ConfigurationManager('config/etl_config.json')

# Step 2: Load configuration
config.load()

# Step 3: Use configuration
db_config = config.database_config
print(f"Connecting to {db_config['host']}:{db_config['port']}")

# Step 4: Modify if needed
config.set_value('pipeline', 'batch_size', 200)
config.save()
```

---

## 📝 Step 2: Logging System

### 🎯 What This Does:

The **ETL Logger** records everything that happens in your pipeline - like a flight recorder for your data. It:

- **Writes** messages to both file and console
- **Timestamps** every operation
- **Categorizes** messages (INFO, WARNING, ERROR, DEBUG)
- **Uses singleton pattern** - only one logger exists for entire application

### 💡 Why This Matters:

Imagine your ETL runs at 3 AM and fails. Without logging, you'd have no idea what happened! With logging:

```python
# Pipeline runs at night...
logger.info("Starting ETL for 10,000 records")
logger.info("Extracted 10,000 rows from database")
logger.warning("Found 15 rows with missing data")
logger.error("Database connection lost at row 5,432")

# Next morning, you check logs/etl.log and see exactly what failed!
```

### 🔍 Singleton Pattern Explained:

**Problem**: Multiple parts of your code create different loggers, writing to different files = chaos!

**Solution**: Singleton pattern ensures only ONE logger exists:

```python
# In module A
logger1 = ETLLogger.get_instance()
logger1.info("Message from module A")

# In module B
logger2 = ETLLogger.get_instance()
logger2.info("Message from module B")

# logger1 and logger2 are THE SAME OBJECT!
# Both write to the same log file
```

### 🔍 Code Explanation:

Create `src/logger.py`:

```python
"""Logging system for ETL pipeline."""

import logging
from pathlib import Path
from datetime import datetime


class ETLLogger:
    """Custom logger for ETL operations.
    
    Demonstrates:
    - Encapsulation
    - Class methods
    - Singleton pattern (only one logger instance)
    
    Singleton means: No matter how many times you create ETLLogger,
    you always get the SAME instance.
    """
    
    _instance = None  # Class attribute: stores the singleton instance
    
    def __new__(cls, log_file=None, level='INFO'):
        """Create singleton instance.
        
        __new__ is called BEFORE __init__. This is where we control
        object creation to ensure only one instance exists.
        
        How it works:
        1. First call: _instance is None, create new instance
        2. Second call: _instance exists, return existing instance
        
        Example:
            >>> logger1 = ETLLogger()
            >>> logger2 = ETLLogger()
            >>> print(logger1 is logger2)  # True - same object!
        """
        if cls._instance is None:
            # First time: create new instance
            cls._instance = super().__new__(cls)
            cls._instance._initialized = False
        return cls._instance
    
    def __init__(self, log_file=None, level='INFO'):
        """Initialize logger (only once due to singleton).
        
        Args:
            log_file: Path to log file (default: logs/etl.log)
            level: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        
        The _initialized flag prevents re-initialization when
        singleton returns existing instance.
        """
        if self._initialized:
            return
        
        self.log_file = Path(log_file) if log_file else Path('logs/etl.log')
        self.level = level
        self._logger = None
        self._initialized = True
        
        self._setup_logger()
    
    def _setup_logger(self):
        """Setup Python logging.
        
        This method configures Python's built-in logging module:
        1. Create logs directory
        2. Create logger instance
        3. Add file handler (writes to file)
        4. Add console handler (writes to terminal)
        5. Set formatting (timestamp, level, message)
        """
        # Create logs directory
        self.log_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Create logger
        self._logger = logging.getLogger('ETL')
        self._logger.setLevel(getattr(logging, self.level))
        
        # Remove existing handlers (important for singleton!)
        self._logger.handlers.clear()
        
        # File handler - writes to log file
        file_handler = logging.FileHandler(self.log_file)
        file_handler.setLevel(getattr(logging, self.level))
        
        # Console handler - writes to terminal
        console_handler = logging.StreamHandler()
        console_handler.setLevel(getattr(logging, self.level))
        
        # Formatter - defines message format
        # Example output: "2024-03-10 14:30:45,123 - ETL - INFO - Pipeline started"
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        file_handler.setFormatter(formatter)
        console_handler.setFormatter(formatter)
        
        # Add handlers to logger
        self._logger.addHandler(file_handler)
        self._logger.addHandler(console_handler)
        
        self.info(f"Logger initialized: {self.log_file}")
    
    def info(self, message):
        """Log info message.
        
        Use for: Normal operations, progress updates
        
        Example:
            >>> logger.info("Extracted 1000 rows from database")
            2024-03-10 14:30:45,123 - ETL - INFO - Extracted 1000 rows from database
        """
        self._logger.info(message)
    
    def warning(self, message):
        """Log warning message.
        
        Use for: Something unexpected but not critical
        
        Example:
            >>> logger.warning("Found 5 rows with missing data")
            2024-03-10 14:30:46,456 - ETL - WARNING - Found 5 rows with missing data
        """
        self._logger.warning(message)
    
    def error(self, message):
        """Log error message.
        
        Use for: Something failed, but pipeline can continue
        
        Example:
            >>> logger.error("Failed to process row 123")
            2024-03-10 14:30:47,789 - ETL - ERROR - Failed to process row 123
        """
        self._logger.error(message)
    
    def debug(self, message):
        """Log debug message.
        
        Use for: Detailed information for debugging
        Only shown if level is set to DEBUG
        
        Example:
            >>> logger.debug("Processing row: {'id': 1, 'name': 'Camp A'}")
        """
        self._logger.debug(message)
    
    def critical(self, message):
        """Log critical message.
        
        Use for: Severe error, pipeline must stop
        
        Example:
            >>> logger.critical("Database connection lost!")
            2024-03-10 14:30:48,012 - ETL - CRITICAL - Database connection lost!
        """
        self._logger.critical(message)
    
    @classmethod
    def get_instance(cls):
        """Get singleton instance.
        
        This is a class method (works on the class, not instance).
        It's the recommended way to get the logger.
        
        Returns:
            ETLLogger: The singleton logger instance
        
        Example:
            >>> # Anywhere in your code:
            >>> logger = ETLLogger.get_instance()
            >>> logger.info("Hello from anywhere!")
        """
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance
```

### 📚 Logging Levels Explained:

```python
# DEBUG: Detailed information for diagnosing problems
logger.debug(f"Processing row: {row_data}")

# INFO: General informational messages
logger.info("ETL pipeline started")
logger.info("Extracted 1000 rows")

# WARNING: Something unexpected, but not an error
logger.warning("Found 5 duplicate rows, removing...")

# ERROR: An error occurred, but pipeline continues
logger.error("Failed to validate row 123: missing 'name' field")

# CRITICAL: Severe error, pipeline must stop
logger.critical("Database connection lost, cannot continue")
```

### 🎯 Real-World Usage Examples:

#### Example 1: Tracking ETL Progress
```python
logger = ETLLogger.get_instance()

logger.info("=" * 50)
logger.info("ETL PIPELINE STARTED")
logger.info("=" * 50)

# Extract phase
logger.info("EXTRACT: Starting data extraction...")
logger.info(f"EXTRACT: Connected to database at {db_host}")
logger.info(f"EXTRACT: Extracted {row_count} rows")

# Transform phase
logger.info("TRANSFORM: Starting data transformation...")
logger.warning(f"TRANSFORM: Found {null_count} rows with null values")
logger.info(f"TRANSFORM: Cleaned {clean_count} rows")

# Load phase
logger.info("LOAD: Starting data load...")
logger.info(f"LOAD: Loaded {load_count} rows successfully")

logger.info("ETL PIPELINE COMPLETED SUCCESSFULLY")
```

#### Example 2: Error Handling with Logging
```python
logger = ETLLogger.get_instance()

try:
    # Try to connect to database
    connection = psycopg2.connect(connection_string)
    logger.info("Successfully connected to database")
    
except psycopg2.OperationalError as e:
    logger.error(f"Failed to connect to database: {str(e)}")
    logger.error("Check if database is running and credentials are correct")
    
except Exception as e:
    logger.critical(f"Unexpected error: {str(e)}")
    raise  # Re-raise critical errors
```

#### Example 3: Using Logger Across Multiple Modules
```python
# In sources.py
from src.logger import ETLLogger

class CSVSource:
    def __init__(self, name, file_path):
        self.logger = ETLLogger.get_instance()  # Get singleton
        self.logger.info(f"CSV Source initialized: {name}")
    
    def extract(self):
        self.logger.info(f"Extracting from {self.file_path}")
        # ... extract logic ...
        self.logger.info(f"Extracted {row_count} rows")

# In transformers.py
from src.logger import ETLLogger

class DataTransformer:
    def __init__(self):
        self.logger = ETLLogger.get_instance()  # Same logger!
        self.logger.info("Transformer initialized")
    
    def transform(self, data):
        self.logger.info(f"Transforming {len(data)} rows")
        # ... transform logic ...
        self.logger.info("Transformation complete")

# Both classes use THE SAME logger instance!
# All messages go to the same log file.
```

### 📋 Log File Output Example:

```
2024-03-10 14:30:45,123 - ETL - INFO - Logger initialized: logs/etl.log
2024-03-10 14:30:45,456 - ETL - INFO - ETL System started
2024-03-10 14:30:45,789 - ETL - INFO - CSV Source initialized: Campsites
2024-03-10 14:30:46,012 - ETL - INFO - Extracting from data/input/campsites.csv
2024-03-10 14:30:46,234 - ETL - INFO - Extracted 100 rows
2024-03-10 14:30:46,567 - ETL - WARNING - Found 5 rows with missing state
2024-03-10 14:30:46,890 - ETL - INFO - Cleaned 100 rows
2024-03-10 14:30:47,123 - ETL - INFO - Validated 95 valid rows, 5 invalid
2024-03-10 14:30:47,456 - ETL - INFO - Loaded 95 rows to database
2024-03-10 14:30:47,789 - ETL - INFO - ETL System finished
```

### 🎯 How to Use:

```python
# Option 1: Create once at application start
logger = ETLLogger(log_file='logs/etl.log', level='INFO')

# Option 2: Get singleton instance anywhere
logger = ETLLogger.get_instance()

# Use throughout your code
logger.info("Starting process...")
logger.warning("Something unusual happened")
logger.error("Something failed")
```

---

## 📝 Step 3: Data Sources (with Inheritance)

### 🎯 What This Does:

**Data Sources** are classes that know how to read data from different places (CSV files, JSON files, databases, APIs). Using **inheritance**, we create:

1. **Parent class** (`DataSource`) - defines what ALL sources must do
2. **Child classes** (`CSVSource`, `JSONSource`) - implement specific logic for each type

This is **polymorphism** in action: your ETL pipeline can work with ANY source type without knowing the details!

### 💡 Why Inheritance Matters:

**Without Inheritance** (Bad):
```python
# Each source is completely different
csv_source = CSVSource()
csv_source.csv_connect()
csv_source.csv_extract()

json_source = JSONSource()
json_source.json_load()
json_source.json_parse()

# Pipeline needs to know each source type!
if isinstance(source, CSVSource):
    source.csv_connect()
    source.csv_extract()
elif isinstance(source, JSONSource):
    source.json_load()
    source.json_parse()
```

**With Inheritance** (Good):
```python
# All sources have same interface
csv_source = CSVSource("campsites.csv")
json_source = JSONSource("bookings.json")

# Pipeline works with ANY source the same way!
for source in [csv_source, json_source]:
    source.connect()      # Each knows how to connect itself
    source.extract()      # Each knows how to extract itself
    source.disconnect()   # Works for all!
```

### 🔍 Code Explanation:

Create `src/sources.py`:

```python
"""Data sources for ETL system.

Demonstrates:
- Abstract base classes
- Inheritance
- Polymorphism
"""

from abc import ABC, abstractmethod
from pathlib import Path
import csv
import json
from datetime import datetime


class DataSource(ABC):
    """Abstract base class for all data sources.
    
    This is a CONTRACT that says: "Any data source MUST implement
    connect() and extract() methods."
    
    ABC = Abstract Base Class (from abc module)
    
    You CANNOT create an instance of this class directly:
    >>> source = DataSource()  # ERROR!
    
    You MUST create a child class that implements abstract methods:
    >>> source = CSVSource("data.csv")  # OK!
    """
    
    def __init__(self, name, source_type):
        """Initialize data source.
        
        This method is inherited by ALL child classes.
        
        Args:
            name: Human-readable name (e.g., "Campsites Data")
            source_type: Type identifier (e.g., "CSV", "JSON", "PostgreSQL")
        
        Example:
            >>> # In CSVSource child class:
            >>> super().__init__("Campsites", "CSV")
        """
        self.name = name
        self.source_type = source_type
        self.connected = False
        self.data = []
        self.row_count = 0
        
        print(f"📦 {source_type} Source initialized: {name}")
    
    @abstractmethod
    def connect(self):
        """Connect to data source (must be implemented by children).
        
        @abstractmethod means: "Every child class MUST implement this!"
        
        If a child class doesn't implement connect(), Python will
        raise an error when you try to create an instance.
        
        Each source type connects differently:
        - CSV: Check if file exists
        - Database: Open connection
        - API: Authenticate
        """
        pass
    
    @abstractmethod
    def extract(self):
        """Extract data from source (must be implemented by children).
        
        Each source type extracts differently:
        - CSV: Read rows with csv.DictReader
        - JSON: Parse JSON file
        - Database: Execute SELECT query
        - API: Make HTTP request
        """
        pass
    
    def disconnect(self):
        """Disconnect from data source.
        
        This method is NOT abstract because all sources disconnect
        the same way (just set connected=False).
        
        Child classes can override this if they need custom logic.
        """
        self.connected = False
        print(f"🔒 Disconnected from {self.name}")
    
    def get_row_count(self):
        """Get number of rows extracted.
        
        Returns:
            int: Number of rows
        
        Example:
            >>> source = CSVSource("data.csv")
            >>> source.connect()
            >>> source.extract()
            >>> print(source.get_row_count())
            100
        """
        return self.row_count
    
    def get_data(self):
        """Get extracted data.
        
        Returns:
            list: Extracted data (list of dictionaries)
        
        Example:
            >>> data = source.get_data()
            >>> print(data[0])
            {'id': 1, 'name': 'Camp A', 'state': 'MG'}
        """
        return self.data
    
    def __len__(self):
        """Return number of rows (special method).
        
        This allows you to use len() on source objects:
        
        Example:
            >>> source = CSVSource("data.csv")
            >>> source.extract()
            >>> print(len(source))  # Calls __len__()
            100
        """
        return self.row_count
    
    def __str__(self):
        """String representation (special method).
        
        Called when you print() the object:
        
        Example:
            >>> source = CSVSource("data.csv", "Campsites")
            >>> print(source)  # Calls __str__()
            CSV Source: Campsites (100 rows)
        """
        return f"{self.source_type} Source: {self.name} ({self.row_count} rows)"
    
    def __repr__(self):
        """Developer representation (special method).
        
        Called in interactive console or debugger:
        
        Example:
            >>> source = CSVSource("data.csv", "Campsites")
            >>> source  # Calls __repr__()
            DataSource(name='Campsites', type='CSV', rows=100)
        """
        return f"DataSource(name='{self.name}', type='{self.source_type}', rows={self.row_count})"


class CSVSource(DataSource):
    """CSV file data source.
    
    Inherits from DataSource and implements CSV-specific logic.
    
    Inheritance hierarchy:
        DataSource (abstract parent)
            ↓
        CSVSource (concrete child)
    """
    
    def __init__(self, name, file_path):
        """Initialize CSV source.
        
        Args:
            name: Source name
            file_path: Path to CSV file
        
        Example:
            >>> source = CSVSource(
            ...     name="Campsites",
            ...     file_path="data/input/campsites.csv"
            ... )
            📦 CSV Source initialized: Campsites
               📄 CSV file: data/input/campsites.csv
        """
        # Call parent class __init__
        super().__init__(name, "CSV")
        
        self.file_path = Path(file_path)
        
        print(f"   📄 CSV file: {self.file_path}")
    
    def connect(self):
        """Connect to CSV file (check if exists).
        
        This implements the abstract connect() method from parent.
        
        For CSV files, "connecting" means checking if file exists.
        
        Raises:
            FileNotFoundError: If CSV file doesn't exist
        
        Example:
            >>> source = CSVSource("Campsites", "data/campsites.csv")
            >>> source.connect()
            📡 Connecting to CSV: data/campsites.csv...
            ✅ Connected to CSV file
        """
        print(f"📡 Connecting to CSV: {self.file_path}...")
        
        if not self.file_path.exists():
            raise FileNotFoundError(f"CSV file not found: {self.file_path}")
        
        self.connected = True
        print(f"✅ Connected to CSV file")
    
    def extract(self):
        """Extract data from CSV file.
        
        This implements the abstract extract() method from parent.
        
        Reads CSV file and converts each row to a dictionary:
        - Keys: Column names from header row
        - Values: Cell values for that row
        
        Returns:
            list: List of dictionaries (one per row)
        
        Raises:
            Exception: If not connected
        
        Example:
            >>> source.extract()
            📖 Extracting data from CSV...
            ✅ Extracted 100 rows from CSV
            
            >>> data = source.get_data()
            >>> print(data[0])
            {'id': '1', 'name': 'Camp A', 'state': 'MG', 'price': '120.50'}
        """
        if not self.connected:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"📖 Extracting data from CSV...")
        
        with open(self.file_path, 'r', encoding='utf-8') as file:
            # csv.DictReader reads CSV and creates dict for each row
            reader = csv.DictReader(file)
            self.data = list(reader)
            self.row_count = len(self.data)
        
        print(f"✅ Extracted {self.row_count} rows from CSV")
        return self.data
    
    def get_column_names(self):
        """Get CSV column names (CSV-specific method).
        
        This method is ONLY in CSVSource, not in parent DataSource.
        This is OK - child classes can have additional methods.
        
        Returns:
            list: Column names
        
        Example:
            >>> source.extract()
            >>> columns = source.get_column_names()
            >>> print(columns)
            ['id', 'name', 'state', 'city', 'price']
        """
        if self.data:
            return list(self.data[0].keys())
        return []


class JSONSource(DataSource):
    """JSON file data source.
    
    Inherits from DataSource and implements JSON-specific logic.
    
    Inheritance hierarchy:
        DataSource (abstract parent)
            ↓
        JSONSource (concrete child)
    """
    
    def __init__(self, name, file_path):
        """Initialize JSON source.
        
        Args:
            name: Source name
            file_path: Path to JSON file
        
        Example:
            >>> source = JSONSource(
            ...     name="Bookings",
            ...     file_path="data/input/bookings.json"
            ... )
            📦 JSON Source initialized: Bookings
               📄 JSON file: data/input/bookings.json
        """
        # Call parent class __init__
        super().__init__(name, "JSON")
        
        self.file_path = Path(file_path)
        
        print(f"   📄 JSON file: {self.file_path}")
    
    def connect(self):
        """Connect to JSON file (check if exists).
        
        This implements the abstract connect() method from parent.
        
        Example:
            >>> source.connect()
            📡 Connecting to JSON: data/bookings.json...
            ✅ Connected to JSON file
        """
        print(f"📡 Connecting to JSON: {self.file_path}...")
        
        if not self.file_path.exists():
            raise FileNotFoundError(f"JSON file not found: {self.file_path}")
        
        self.connected = True
        print(f"✅ Connected to JSON file")
    
    def extract(self):
        """Extract data from JSON file.
        
        This implements the abstract extract() method from parent.
        
        Reads JSON file and parses it. Handles both:
        - JSON array: [{"id": 1}, {"id": 2}]
        - Single JSON object: {"id": 1, "name": "Camp A"}
        
        Returns:
            list: List of dictionaries
        
        Example:
            >>> source.extract()
            📖 Extracting data from JSON...
            ✅ Extracted 50 records from JSON
            
            >>> data = source.get_data()
            >>> print(data[0])
            {'booking_id': 1, 'campsite_id': 1, 'guests': 4}
        """
        if not self.connected:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"📖 Extracting data from JSON...")
        
        with open(self.file_path, 'r', encoding='utf-8') as file:
            self.data = json.load(file)
        
        # Ensure data is a list
        if not isinstance(self.data, list):
            self.data = [self.data]
        
        self.row_count = len(self.data)
        
        print(f"✅ Extracted {self.row_count} records from JSON")
        return self.data
```

### 📚 Real-World Data Source Examples:

#### Example 1: Reading from PostgreSQL Database
```python
import psycopg2

class PostgreSQLSource(DataSource):
    """PostgreSQL database source."""
    
    def __init__(self, name, connection_string, query):
        super().__init__(name, "PostgreSQL")
        self.connection_string = connection_string
        self.query = query
        self.connection = None
    
    def connect(self):
        """Connect to PostgreSQL database."""
        print(f"📡 Connecting to PostgreSQL...")
        self.connection = psycopg2.connect(self.connection_string)
        self.connected = True
        print(f"✅ Connected to PostgreSQL")
    
    def extract(self):
        """Extract data using SQL query."""
        if not self.connected:
            raise Exception("Not connected!")
        
        print(f"📖 Executing query: {self.query}")
        
        cursor = self.connection.cursor()
        cursor.execute(self.query)
        
        # Get column names
        columns = [desc[0] for desc in cursor.description]
        
        # Convert rows to dictionaries
        self.data = []
        for row in cursor.fetchall():
            self.data.append(dict(zip(columns, row)))
        
        self.row_count = len(self.data)
        cursor.close()
        
        print(f"✅ Extracted {self.row_count} rows from PostgreSQL")
        return self.data
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection:
            self.connection.close()
        super().disconnect()

# Usage:
source = PostgreSQLSource(
    name="Campsites from DB",
    connection_string="host=localhost dbname=camping_db user=postgres password=secret",
    query="SELECT * FROM campsites WHERE state = 'MG' AND active = true"
)
source.connect()
data = source.extract()
source.disconnect()
```

#### Example 2: Reading from SQLite Database
```python
import sqlite3

class SQLiteSource(DataSource):
    """SQLite database source."""
    
    def __init__(self, name, db_path, query):
        super().__init__(name, "SQLite")
        self.db_path = Path(db_path)
        self.query = query
        self.connection = None
    
    def connect(self):
        """Connect to SQLite database."""
        print(f"📡 Connecting to SQLite: {self.db_path}...")
        self.connection = sqlite3.connect(self.db_path)
        self.connection.row_factory = sqlite3.Row  # Enable column access by name
        self.connected = True
        print(f"✅ Connected to SQLite")
    
    def extract(self):
        """Extract data using SQL query."""
        if not self.connected:
            raise Exception("Not connected!")
        
        print(f"📖 Executing query: {self.query}")
        
        cursor = self.connection.cursor()
        cursor.execute(self.query)
        
        # Convert rows to dictionaries
        self.data = [dict(row) for row in cursor.fetchall()]
        self.row_count = len(self.data)
        cursor.close()
        
        print(f"✅ Extracted {self.row_count} rows from SQLite")
        return self.data
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection:
            self.connection.close()
        super().disconnect()

# Usage:
source = SQLiteSource(
    name="Bookings from SQLite",
    db_path="data/camping.db",
    query="SELECT * FROM bookings WHERE check_in >= '2024-01-01'"
)
source.connect()
data = source.extract()
source.disconnect()
```

#### Example 3: Reading from REST API
```python
import requests

class APISource(DataSource):
    """REST API data source."""
    
    def __init__(self, name, base_url, endpoint, api_key=None):
        super().__init__(name, "API")
        self.base_url = base_url
        self.endpoint = endpoint
        self.api_key = api_key
        self.session = None
    
    def connect(self):
        """Prepare API session."""
        print(f"📡 Connecting to API: {self.base_url}...")
        self.session = requests.Session()
        
        if self.api_key:
            self.session.headers.update({'Authorization': f'Bearer {self.api_key}'})
        
        self.connected = True
        print(f"✅ Connected to API")
    
    def extract(self):
        """Extract data from API endpoint."""
        if not self.connected:
            raise Exception("Not connected!")
        
        url = f"{self.base_url}{self.endpoint}"
        print(f"📖 GET {url}")
        
        response = self.session.get(url)
        response.raise_for_status()  # Raise error for bad status codes
        
        self.data = response.json()
        
        # Ensure data is a list
        if isinstance(self.data, dict) and 'results' in self.data:
            self.data = self.data['results']
        elif not isinstance(self.data, list):
            self.data = [self.data]
        
        self.row_count = len(self.data)
        
        print(f"✅ Extracted {self.row_count} records from API")
        return self.data
    
    def disconnect(self):
        """Close API session."""
        if self.session:
            self.session.close()
        super().disconnect()

# Usage:
source = APISource(
    name="Campsites from API",
    base_url="https://api.camping.com",
    endpoint="/v1/campsites?state=MG&active=true",
    api_key="your_api_key_here"
)
source.connect()
data = source.extract()
source.disconnect()
```

### 🎯 Polymorphism in Action:

The beauty of this design is that your ETL pipeline works with ALL sources the same way:

```python
# Create different source types
csv_source = CSVSource("Campsites", "data/campsites.csv")
json_source = JSONSource("Bookings", "data/bookings.json")
db_source = PostgreSQLSource("Customers", "host=localhost...", "SELECT * FROM customers")
api_source = APISource("Reviews", "https://api.camping.com", "/v1/reviews")

# Process all sources the same way!
all_sources = [csv_source, json_source, db_source, api_source]

for source in all_sources:
    source.connect()
    data = source.extract()
    print(f"{source.name}: extracted {len(source)} rows")
    source.disconnect()

# Output:
# Campsites: extracted 100 rows
# Bookings: extracted 50 rows
# Customers: extracted 200 rows
# Reviews: extracted 75 rows
```

---

## 📝 Step 4: Data Validators

### 🎯 What This Does:

**Data Validators** check if your data is correct before loading it into your database. Think of them as quality inspectors on an assembly line:

- ✅ **Required fields**: Is the name present?
- ✅ **Numeric ranges**: Is the price between 0 and 10,000?
- ✅ **Valid values**: Is the state code one of the valid Brazilian states?
- ✅ **Date formats**: Is the date in YYYY-MM-DD format?

### 💡 Why Validation Matters:

**Without Validation**:
```python
# Bad data gets into your database!
INSERT INTO campsites VALUES ('', NULL, -500, 'INVALID')
# Now your database has garbage data
# Reports show negative prices, missing names, invalid states
```

**With Validation**:
```python
validator = RequiredFieldValidator('name')
is_valid, error = validator.validate('')  # False, "name is required"

# Invalid data is rejected BEFORE reaching database
# Your database stays clean!
```

### 🔍 Validator Hierarchy:

```
DataValidator (Abstract Parent)
    ↓
    ├── RequiredFieldValidator (checks not empty)
    ├── NumericRangeValidator (checks min/max)
    ├── StateValidator (checks valid state codes)
    └── DateValidator (checks date format)
```

### 🔍 Code Explanation:

Create `src/validators.py`:

```python
"""Data validators for ETL system.

Demonstrates:
- Abstract base classes
- Inheritance
- Polymorphism
"""

from abc import ABC, abstractmethod
from datetime import datetime


class DataValidator(ABC):
    """Abstract base class for validators.
    
    This defines the CONTRACT: all validators must implement validate().
    
    Why abstract? So we can treat all validators the same way:
    >>> validators = [RequiredFieldValidator('name'), 
    ...               NumericRangeValidator('price', 0, 1000)]
    >>> 
    >>> for validator in validators:
    ...     is_valid, error = validator.validate(value)  # Same interface!
    """
    
    def __init__(self, field_name):
        """Initialize validator.
        
        Args:
            field_name: Name of field to validate
        
        Example:
            >>> validator = RequiredFieldValidator('name')
            >>> print(validator.field_name)
            name
        """
        self.field_name = field_name
        self.validation_count = 0  # How many times validated
        self.error_count = 0        # How many failed
    
    @abstractmethod
    def validate(self, value):
        """Validate value (must be implemented by children).
        
        Every validator MUST implement this method.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid: bool, error_message: str or None)
        
        Example:
            >>> is_valid, error = validator.validate("Camp A")
            >>> if not is_valid:
            ...     print(f"Error: {error}")
        """
        pass
    
    def get_error_message(self, value):
        """Get validation error message.
        
        Args:
            value: Invalid value
            
        Returns:
            str: Error message
        """
        return f"Invalid {self.field_name}: {value}"
    
    def get_statistics(self):
        """Get validation statistics.
        
        Returns:
            dict: Statistics about this validator
        
        Example:
            >>> stats = validator.get_statistics()
            >>> print(stats)
            {'field': 'name', 'total': 100, 'errors': 5, 'valid': 95}
        """
        return {
            'field': self.field_name,
            'total': self.validation_count,
            'errors': self.error_count,
            'valid': self.validation_count - self.error_count
        }


class RequiredFieldValidator(DataValidator):
    """Validate that field is not empty.
    
    Use this when a field MUST have a value.
    
    Examples of required fields:
    - Customer name
    - Product ID
    - Email address
    - Campsite name
    """
    
    def __init__(self, field_name):
        """Initialize required field validator.
        
        Example:
            >>> validator = RequiredFieldValidator('customer_name')
        """
        super().__init__(field_name)
    
    def validate(self, value):
        """Validate field is not empty.
        
        Checks if value is:
        - None
        - Empty string ('')
        - String with only whitespace ('   ')
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Examples:
            >>> validator = RequiredFieldValidator('name')
            >>> 
            >>> # Valid values
            >>> validator.validate('Camp A')
            (True, None)
            >>> 
            >>> # Invalid values
            >>> validator.validate('')
            (False, 'name is required')
            >>> 
            >>> validator.validate(None)
            (False, 'name is required')
            >>> 
            >>> validator.validate('   ')  # Only whitespace
            (False, 'name is required')
        """
        self.validation_count += 1
        
        # Check if value is None or empty string (after stripping whitespace)
        if value is None or str(value).strip() == '':
            self.error_count += 1
            return False, f"{self.field_name} is required"
        
        return True, None


class NumericRangeValidator(DataValidator):
    """Validate numeric values within range.
    
    Use this for:
    - Prices (must be > 0)
    - Ages (must be 0-150)
    - Quantities (must be > 0)
    - Percentages (must be 0-100)
    """
    
    def __init__(self, field_name, min_value=None, max_value=None):
        """Initialize numeric range validator.
        
        Args:
            field_name: Field name
            min_value: Minimum value (optional)
            max_value: Maximum value (optional)
        
        Examples:
            >>> # Price must be positive
            >>> validator = NumericRangeValidator('price', min_value=0)
            >>> 
            >>> # Age must be 0-150
            >>> validator = NumericRangeValidator('age', min_value=0, max_value=150)
            >>> 
            >>> # Percentage must be 0-100
            >>> validator = NumericRangeValidator('discount', min_value=0, max_value=100)
        """
        super().__init__(field_name)
        self.min_value = min_value
        self.max_value = max_value
    
    def validate(self, value):
        """Validate numeric range.
        
        First checks if value is numeric, then checks range.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Examples:
            >>> validator = NumericRangeValidator('price', min_value=0, max_value=1000)
            >>> 
            >>> # Valid values
            >>> validator.validate(50)
            (True, None)
            >>> 
            >>> validator.validate('100')  # String numbers are OK
            (True, None)
            >>> 
            >>> # Invalid: too low
            >>> validator.validate(-10)
            (False, 'price must be >= 0')
            >>> 
            >>> # Invalid: too high
            >>> validator.validate(2000)
            (False, 'price must be <= 1000')
            >>> 
            >>> # Invalid: not a number
            >>> validator.validate('abc')
            (False, 'price must be numeric')
        """
        self.validation_count += 1
        
        try:
            # Convert to float (handles both int and string numbers)
            num_value = float(value)
            
            # Check minimum value
            if self.min_value is not None and num_value < self.min_value:
                self.error_count += 1
                return False, f"{self.field_name} must be >= {self.min_value}"
            
            # Check maximum value
            if self.max_value is not None and num_value > self.max_value:
                self.error_count += 1
                return False, f"{self.field_name} must be <= {self.max_value}"
            
            return True, None
        
        except (ValueError, TypeError):
            # Value can't be converted to number
            self.error_count += 1
            return False, f"{self.field_name} must be numeric"


class StateValidator(DataValidator):
    """Validate Brazilian state codes.
    
    Ensures state codes are valid two-letter abbreviations.
    """
    
    # Valid Brazilian state codes
    VALID_STATES = ['BA', 'RJ', 'MG', 'RS', 'SP', 'SC', 'PR', 'PE', 'CE', 
                    'AM', 'PA', 'GO', 'ES', 'PB', 'RN', 'AL', 'MT', 'MS',
                    'PI', 'SE', 'RO', 'AC', 'AP', 'RR', 'TO', 'MA', 'DF']
    
    def __init__(self):
        """Initialize state validator.
        
        Example:
            >>> validator = StateValidator()
        """
        super().__init__("state")
    
    def validate(self, value):
        """Validate state code.
        
        Converts to uppercase and checks against valid states list.
        
        Args:
            value: State code to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Examples:
            >>> validator = StateValidator()
            >>> 
            >>> # Valid states
            >>> validator.validate('MG')
            (True, None)
            >>> 
            >>> validator.validate('mg')  # Lowercase is OK
            (True, None)
            >>> 
            >>> # Invalid states
            >>> validator.validate('ZZ')
            (False, 'State must be one of: BA, RJ, MG, RS, SP...')
            >>> 
            >>> validator.validate('California')
            (False, 'State must be one of: BA, RJ, MG, RS, SP...')
        """
        self.validation_count += 1
        
        # Convert to uppercase and check
        if str(value).upper() in self.VALID_STATES:
            return True, None
        
        self.error_count += 1
        return False, f"State must be one of: {', '.join(self.VALID_STATES[:11])}..."


class DateValidator(DataValidator):
    """Validate date format.
    
    Ensures dates are in correct format (e.g., YYYY-MM-DD).
    """
    
    def __init__(self, field_name, date_format='%Y-%m-%d'):
        """Initialize date validator.
        
        Args:
            field_name: Field name
            date_format: Expected date format (strftime format)
        
        Common date formats:
        - '%Y-%m-%d' → 2024-03-10 (ISO format)
        - '%d/%m/%Y' → 10/03/2024 (Brazilian format)
        - '%m/%d/%Y' → 03/10/2024 (US format)
        - '%Y-%m-%d %H:%M:%S' → 2024-03-10 14:30:00 (with time)
        
        Examples:
            >>> # ISO date format
            >>> validator = DateValidator('check_in', '%Y-%m-%d')
            >>> 
            >>> # Brazilian date format
            >>> validator = DateValidator('check_in', '%d/%m/%Y')
        """
        super().__init__(field_name)
        self.date_format = date_format
    
    def validate(self, value):
        """Validate date format.
        
        Args:
            value: Date string to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Examples:
            >>> validator = DateValidator('check_in', '%Y-%m-%d')
            >>> 
            >>> # Valid dates
            >>> validator.validate('2024-03-10')
            (True, None)
            >>> 
            >>> # Invalid format
            >>> validator.validate('10/03/2024')
            (False, 'check_in must be in format %Y-%m-%d')
            >>> 
            >>> # Invalid date
            >>> validator.validate('2024-13-45')  # Month 13, day 45
            (False, 'check_in must be in format %Y-%m-%d')
            >>> 
            >>> # Not a date
            >>> validator.validate('not-a-date')
            (False, 'check_in must be in format %Y-%m-%d')
        """
        self.validation_count += 1
        
        try:
            # Try to parse date using specified format
            datetime.strptime(str(value), self.date_format)
            return True, None
        except ValueError:
            self.error_count += 1
            return False, f"{self.field_name} must be in format {self.date_format}"
```

### 📚 Additional Validator Examples:

#### Example 1: Email Validator
```python
import re

class EmailValidator(DataValidator):
    """Validate email addresses."""
    
    # Simple email regex pattern
    EMAIL_PATTERN = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    def __init__(self):
        super().__init__("email")
    
    def validate(self, value):
        """Validate email format.
        
        Examples:
            >>> validator = EmailValidator()
            >>> 
            >>> validator.validate('user@example.com')
            (True, None)
            >>> 
            >>> validator.validate('invalid-email')
            (False, 'email must be valid email address')
        """
        self.validation_count += 1
        
        if re.match(self.EMAIL_PATTERN, str(value)):
            return True, None
        
        self.error_count += 1
        return False, f"{self.field_name} must be valid email address"

# Usage:
validator = EmailValidator()
is_valid, error = validator.validate('john@example.com')
```

#### Example 2: Phone Number Validator (Brazilian)
```python
class PhoneValidator(DataValidator):
    """Validate Brazilian phone numbers."""
    
    def __init__(self):
        super().__init__("phone")
    
    def validate(self, value):
        """Validate Brazilian phone format.
        
        Accepts: 11999998888 or 1199999-8888 or (11) 99999-8888
        
        Examples:
            >>> validator = PhoneValidator()
            >>> 
            >>> validator.validate('11999998888')
            (True, None)
            >>> 
            >>> validator.validate('(11) 99999-8888')
            (True, None)
            >>> 
            >>> validator.validate('123')
            (False, 'phone must be valid Brazilian phone')
        """
        self.validation_count += 1
        
        # Remove non-digits
        digits = re.sub(r'\D', '', str(value))
        
        # Check length (10 or 11 digits)
        if len(digits) in [10, 11]:
            return True, None
        
        self.error_count += 1
        return False, f"{self.field_name} must be valid Brazilian phone"

# Usage:
validator = PhoneValidator()
is_valid, error = validator.validate('(11) 99999-8888')
```

#### Example 3: Custom Business Rule Validator
```python
class BookingDateValidator(DataValidator):
    """Validate booking dates (check-in must be before check-out)."""
    
    def __init__(self):
        super().__init__("booking_dates")
    
    def validate(self, value):
        """Validate booking dates.
        
        Args:
            value: dict with 'check_in' and 'check_out' dates
        
        Examples:
            >>> validator = BookingDateValidator()
            >>> 
            >>> # Valid: check-in before check-out
            >>> booking = {'check_in': '2024-03-10', 'check_out': '2024-03-12'}
            >>> validator.validate(booking)
            (True, None)
            >>> 
            >>> # Invalid: check-out before check-in
            >>> booking = {'check_in': '2024-03-12', 'check_out': '2024-03-10'}
            >>> validator.validate(booking)
            (False, 'check_out must be after check_in')
        """
        self.validation_count += 1
        
        try:
            check_in = datetime.strptime(value['check_in'], '%Y-%m-%d')
            check_out = datetime.strptime(value['check_out'], '%Y-%m-%d')
            
            if check_out <= check_in:
                self.error_count += 1
                return False, "check_out must be after check_in"
            
            return True, None
        
        except (KeyError, ValueError) as e:
            self.error_count += 1
            return False, f"Invalid booking dates: {str(e)}"

# Usage:
validator = BookingDateValidator()
booking = {'check_in': '2024-03-10', 'check_out': '2024-03-12'}
is_valid, error = validator.validate(booking)
```

### 🎯 Using Validators in Practice:

#### Example: Validating a Single Row
```python
# Create validators
validators = {
    'name': RequiredFieldValidator('name'),
    'price': NumericRangeValidator('price', min_value=0, max_value=10000),
    'state': StateValidator(),
    'check_in': DateValidator('check_in', '%Y-%m-%d')
}

# Sample data row
row = {
    'name': 'Serra Verde Camp',
    'price': 120.50,
    'state': 'MG',
    'check_in': '2024-03-10'
}

# Validate all fields
errors = []
for field, validator in validators.items():
    value = row.get(field)
    is_valid, error_msg = validator.validate(value)
    
    if not is_valid:
        errors.append(f"{field}: {error_msg}")

# Check results
if errors:
    print("❌ Validation failed:")
    for error in errors:
        print(f"  - {error}")
else:
    print("✅ All fields valid!")
```

#### Example: Validating Multiple Rows
```python
# Sample dataset
data = [
    {'name': 'Camp A', 'price': 100, 'state': 'MG'},
    {'name': '', 'price': -50, 'state': 'ZZ'},        # Invalid!
    {'name': 'Camp B', 'price': 150, 'state': 'RJ'},
]

# Validate all rows
valid_rows = []
invalid_rows = []

for i, row in enumerate(data):
    row_errors = []
    
    # Check each field
    for field, validator in validators.items():
        value = row.get(field)
        is_valid, error_msg = validator.validate(value)
        
        if not is_valid:
            row_errors.append(error_msg)
    
    # Categorize row
    if row_errors:
        invalid_rows.append({'row': i+1, 'data': row, 'errors': row_errors})
    else:
        valid_rows.append(row)

# Report
print(f"✅ Valid rows: {len(valid_rows)}")
print(f"❌ Invalid rows: {len(invalid_rows)}")

for invalid in invalid_rows:
    print(f"\nRow {invalid['row']}: {invalid['data']}")
    for error in invalid['errors']:
        print(f"  ❌ {error}")
```

### 📊 Validator Statistics:

```python
# After validating data, check statistics
for field, validator in validators.items():
    stats = validator.get_statistics()
    print(f"\n{field}:")
    print(f"  Total validations: {stats['total']}")
    print(f"  Valid: {stats['valid']}")
    print(f"  Errors: {stats['errors']}")
    print(f"  Success rate: {(stats['valid']/stats['total']*100):.1f}%")

# Output:
# name:
#   Total validations: 100
#   Valid: 95
#   Errors: 5
#   Success rate: 95.0%
```

**Why These Statistics Are Useful:**
- **Monitor data quality**: See how many rows pass validation
- **Track error trends**: Are validation errors increasing over time?
- **Identify problem fields**: Which validators reject the most data?
- **Calculate success rates**: What percentage of data is valid?

---

```python
"""Data validators for ETL system (continued).

This section contains the actual validator implementations.
"""
from abc import ABC, abstractmethod
    def validate(self, value):
        """Validate value (must be implemented by children).
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        pass
    
    def get_error_message(self, value):
        """Get validation error message.
        
        Args:
            value: Invalid value
            
        Returns:
            str: Error message
        """
        return f"Invalid {self.field_name}: {value}"
    
    def get_statistics(self):
        """Get validation statistics.
        
        Returns:
            dict: Statistics
        """
        return {
            'field': self.field_name,
            'total': self.validation_count,
            'errors': self.error_count,
            'valid': self.validation_count - self.error_count
        }


class RequiredFieldValidator(DataValidator):
    """Validate that field is not empty."""
    
    def __init__(self, field_name):
        """Initialize required field validator."""
        super().__init__(field_name)
    
    def validate(self, value):
        """Validate field is not empty.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        self.validation_count += 1
        
        if value is None or str(value).strip() == '':
            self.error_count += 1
            return False, f"{self.field_name} is required"
        
        return True, None


class NumericRangeValidator(DataValidator):
    """Validate numeric values within range."""
    
    def __init__(self, field_name, min_value=None, max_value=None):
        """Initialize numeric range validator.
        
        Args:
            field_name: Field name
            min_value: Minimum value (optional)
            max_value: Maximum value (optional)
        """
        super().__init__(field_name)
        self.min_value = min_value
        self.max_value = max_value
    
    def validate(self, value):
        """Validate numeric range.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        self.validation_count += 1
        
        try:
            num_value = float(value)
            
            if self.min_value is not None and num_value < self.min_value:
                self.error_count += 1
                return False, f"{self.field_name} must be >= {self.min_value}"
            
            if self.max_value is not None and num_value > self.max_value:
                self.error_count += 1
                return False, f"{self.field_name} must be <= {self.max_value}"
            
            return True, None
        
        except (ValueError, TypeError):
            self.error_count += 1
            return False, f"{self.field_name} must be numeric"


class StateValidator(DataValidator):
    """Validate Brazilian state codes."""
    
    VALID_STATES = ['BA', 'RJ', 'MG', 'RS', 'SP', 'SC', 'PR', 'PE', 'CE', 'AM', 'PA']
    
    def __init__(self):
        """Initialize state validator."""
        super().__init__("state")
    
    def validate(self, value):
        """Validate state code.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        self.validation_count += 1
        
        if str(value).upper() in self.VALID_STATES:
            return True, None
        
        self.error_count += 1
        return False, f"State must be one of: {', '.join(self.VALID_STATES)}"


class DateValidator(DataValidator):
    """Validate date format."""
    
    def __init__(self, field_name, date_format='%Y-%m-%d'):
        """Initialize date validator.
        
        Args:
            field_name: Field name
            date_format: Expected date format
        """
        super().__init__(field_name)
        self.date_format = date_format
    
    def validate(self, value):
        """Validate date format.
        
        Args:
            value: Value to validate
            
        Returns:
            tuple: (is_valid, error_message)
        """
        self.validation_count += 1
        
        try:
            datetime.strptime(str(value), self.date_format)
            return True, None
        except ValueError:
            self.error_count += 1
            return False, f"{self.field_name} must be in format {self.date_format}"
```

---

---

## 📝 Step 5: Data Transformers

### 🎯 What This Does:

**Data Transformers** modify your data during the ETL process. Think of them as a series of filters that clean and enhance your data:

1. **CleaningTransformer**: Removes junk (trim whitespace, handle nulls)
2. **EnrichmentTransformer**: Adds metadata (timestamps, version info)
3. **ValidationTransformer**: Filters invalid rows using validators
4. **TransformationPipeline**: Chains multiple transformers together

### 💡 Why Transformation Matters:

**Raw Data** (messy):
```python
{'name': '  Camp A  ', 'price': '', 'state': 'mg'}  # Whitespace, empty price, lowercase
```

**After Transformation** (clean):
```python
{
    'name': 'Camp A',           # Trimmed
    'price': None,              # Empty → None
    'state': 'MG',              # Uppercase
    'processed_at': '2024-03-10T14:30:00',  # Added timestamp
    'etl_version': '1.0'        # Added version
}
```

### 🔍 Code Explanation:

Create `src/transformers.py`:

```python
"""Data transformers for ETL system.

Demonstrates:
- Classes with instance methods
- Composition (transformers working together)
"""

from datetime import datetime


class DataTransformer:
    """Base transformer for data cleaning and transformation.
    
    This is NOT an abstract class (no ABC) because it has
    a default implementation that children can use.
    """
    
    def __init__(self, name):
        """Initialize transformer.
        
        Args:
            name: Human-readable transformer name
        
        Example:
            >>> transformer = DataTransformer("My Custom Transformer")
            🔧 Transformer initialized: My Custom Transformer
        """
        self.name = name
        self.transform_count = 0  # Track how many rows transformed
        
        print(f"🔧 Transformer initialized: {name}")
    
    def transform(self, data):
        """Transform data.
        
        Base implementation does nothing - just passes data through.
        Child classes override this to add transformation logic.
        
        Args:
            data: Data to transform (list of dicts)
            
        Returns:
            Transformed data
        
        Example:
            >>> transformer = DataTransformer("Base")
            >>> data = [{'id': 1}, {'id': 2}]
            >>> result = transformer.transform(data)
            ⚙️  Applying transformation: Base...
            >>> print(result)
            [{'id': 1}, {'id': 2}]  # Unchanged
        """
        print(f"⚙️  Applying transformation: {self.name}...")
        return data
    
    def get_transform_count(self):
        """Get number of transformations applied.
        
        Returns:
            int: Transform count
        """
        return self.transform_count


class CleaningTransformer(DataTransformer):
    """Clean data (remove nulls, trim whitespace, etc.).
    
    Cleaning operations:
    - Trim whitespace from strings
    - Convert empty strings to None
    - Normalize data types
    """
    
    def __init__(self):
        """Initialize cleaning transformer.
        
        Example:
            >>> transformer = CleaningTransformer()
            🔧 Transformer initialized: Data Cleaning
        """
        super().__init__("Data Cleaning")
    
    def transform(self, data):
        """Clean data.
        
        For each row:
        1. Iterate through all fields
        2. Trim whitespace from strings
        3. Convert empty strings to None
        
        Args:
            data: List of dictionaries to clean
            
        Returns:
            list: Cleaned data
        
        Example:
            >>> transformer = CleaningTransformer()
            >>> 
            >>> # Messy data
            >>> data = [
            ...     {'name': '  Camp A  ', 'price': '', 'state': '  MG  '},
            ...     {'name': 'Camp B', 'price': '100', 'state': 'RJ'}
            ... ]
            >>> 
            >>> # Clean it
            >>> clean_data = transformer.transform(data)
            ⚙️  Applying transformation: Data Cleaning...
            ✅ Cleaned 2 rows
            >>> 
            >>> # Result
            >>> print(clean_data[0])
            {'name': 'Camp A', 'price': None, 'state': 'MG'}
        """
        super().transform(data)  # Print message
        
        cleaned_data = []
        
        for row in data:
            cleaned_row = {}
            
            for key, value in row.items():
                # Trim whitespace from strings
                if isinstance(value, str):
                    cleaned_row[key] = value.strip()
                # Convert empty strings to None
                elif value == '':
                    cleaned_row[key] = None
                else:
                    cleaned_row[key] = value
            
            cleaned_data.append(cleaned_row)
            self.transform_count += 1
        
        print(f"✅ Cleaned {len(cleaned_data)} rows")
        return cleaned_data


class EnrichmentTransformer(DataTransformer):
    """Enrich data with additional fields.
    
    Adds metadata to help track data:
    - processed_at: When was this row processed?
    - etl_version: Which ETL version processed it?
    - source: Where did this data come from?
    """
    
    def __init__(self):
        """Initialize enrichment transformer.
        
        Example:
            >>> transformer = EnrichmentTransformer()
            🔧 Transformer initialized: Data Enrichment
        """
        super().__init__("Data Enrichment")
    
    def transform(self, data):
        """Enrich data with metadata.
        
        Adds these fields to each row:
        - processed_at: Current timestamp
        - etl_version: ETL version number
        
        Args:
            data: List of dictionaries to enrich
            
        Returns:
            list: Enriched data
        
        Example:
            >>> transformer = EnrichmentTransformer()
            >>> 
            >>> data = [{'name': 'Camp A', 'price': 100}]
            >>> enriched = transformer.transform(data)
            ⚙️  Applying transformation: Data Enrichment...
            ✅ Enriched 1 rows
            >>> 
            >>> print(enriched[0])
            {
                'name': 'Camp A',
                'price': 100,
                'processed_at': '2024-03-10T14:30:45.123456',
                'etl_version': '1.0'
            }
        """
        super().transform(data)
        
        enriched_data = []
        current_time = datetime.now().isoformat()
        
        for row in data:
            # Copy original row
            enriched_row = row.copy()
            
            # Add metadata
            enriched_row['processed_at'] = current_time
            enriched_row['etl_version'] = '1.0'
            
            enriched_data.append(enriched_row)
            self.transform_count += 1
        
        print(f"✅ Enriched {len(enriched_data)} rows")
        return enriched_data


class ValidationTransformer(DataTransformer):
    """Validate data using validators (composition).
    
    This transformer CONTAINS validators (composition).
    It uses them to check data and filter out invalid rows.
    """
    
    def __init__(self, validators):
        """Initialize validation transformer.
        
        Args:
            validators: Dictionary of {field_name: validator}
        
        Example:
            >>> from src.validators import RequiredFieldValidator, NumericRangeValidator
            >>> 
            >>> validators = {
            ...     'name': RequiredFieldValidator('name'),
            ...     'price': NumericRangeValidator('price', 0, 1000)
            ... }
            >>> 
            >>> transformer = ValidationTransformer(validators)
            🔧 Transformer initialized: Data Validation
        """
        super().__init__("Data Validation")
        self.validators = validators  # Composition: contains validators
        self.valid_count = 0
        self.invalid_count = 0
        self.errors = []
    
    def transform(self, data):
        """Validate data and filter invalid rows.
        
        Process:
        1. For each row
        2. Validate all fields
        3. If all valid → keep row
        4. If any invalid → reject row, record errors
        
        Args:
            data: List of dictionaries to validate
            
        Returns:
            list: Valid data only (invalid rows removed)
        
        Example:
            >>> validators = {
            ...     'name': RequiredFieldValidator('name'),
            ...     'price': NumericRangeValidator('price', 0, 1000)
            ... }
            >>> transformer = ValidationTransformer(validators)
            >>> 
            >>> data = [
            ...     {'name': 'Camp A', 'price': 100},      # Valid
            ...     {'name': '', 'price': -50},            # Invalid: no name, negative price
            ...     {'name': 'Camp B', 'price': 200},      # Valid
            ... ]
            >>> 
            >>> valid_data = transformer.transform(data)
            ⚙️  Applying transformation: Data Validation...
            ✅ Validated 3 rows: 2 valid, 1 invalid
            >>> 
            >>> print(len(valid_data))
            2  # Only valid rows
            >>> 
            >>> # Check errors
            >>> report = transformer.get_validation_report()
            >>> print(report['invalid_rows'])
            1
        """
        super().transform(data)
        
        valid_data = []
        
        for i, row in enumerate(data):
            is_valid = True
            row_errors = []
            
            # Validate each field
            for field_name, validator in self.validators.items():
                value = row.get(field_name)
                valid, error_msg = validator.validate(value)
                
                if not valid:
                    is_valid = False
                    row_errors.append({
                        'row': i + 1,
                        'field': field_name,
                        'value': value,
                        'error': error_msg
                    })
            
            # Keep or reject row
            if is_valid:
                valid_data.append(row)
                self.valid_count += 1
            else:
                self.invalid_count += 1
                self.errors.extend(row_errors)
            
            self.transform_count += 1
        
        print(f"✅ Validated {len(data)} rows: {self.valid_count} valid, {self.invalid_count} invalid")
        
        return valid_data
    
    def get_validation_report(self):
        """Get validation statistics report.
        
        Returns:
            dict: Detailed validation report
        
        Example:
            >>> report = transformer.get_validation_report()
            >>> print(f"Total: {report['total_rows']}")
            >>> print(f"Valid: {report['valid_rows']}")
            >>> print(f"Invalid: {report['invalid_rows']}")
            >>> 
            >>> # Show errors
            >>> for error in report['errors']:
            ...     print(f"Row {error['row']}, field {error['field']}: {error['error']}")
        """
        return {
            'total_rows': self.transform_count,
            'valid_rows': self.valid_count,
            'invalid_rows': self.invalid_count,
            'errors': self.errors,
            'validators': {
                field: validator.get_statistics() 
                for field, validator in self.validators.items()
            }
        }


class TransformationPipeline:
    """Pipeline that applies multiple transformers in sequence.
    
    Demonstrates composition: contains multiple transformers.
    
    Think of it like an assembly line:
    Raw Data → Cleaning → Enrichment → Validation → Clean Data
    """
    
    def __init__(self):
        """Initialize transformation pipeline.
        
        Example:
            >>> pipeline = TransformationPipeline()
            🔄 Transformation Pipeline initialized
        """
        self.transformers = []  # List of transformers to apply
        
        print(f"🔄 Transformation Pipeline initialized")
    
    def add_transformer(self, transformer):
        """Add transformer to pipeline.
        
        Transformers are applied in the order they're added.
        
        Args:
            transformer: Transformer to add
        
        Example:
            >>> pipeline = TransformationPipeline()
            >>> pipeline.add_transformer(CleaningTransformer())
            >>> pipeline.add_transformer(EnrichmentTransformer())
            >>> pipeline.add_transformer(ValidationTransformer(validators))
            🔄 Transformation Pipeline initialized
               ➕ Added: Data Cleaning
               ➕ Added: Data Enrichment
               ➕ Added: Data Validation
        """
        self.transformers.append(transformer)
        print(f"   ➕ Added: {transformer.name}")
    
    def execute(self, data):
        """Execute all transformers in sequence.
        
        Process:
        1. Start with raw data
        2. Apply transformer 1 → get result
        3. Apply transformer 2 to result → get result
        4. Apply transformer 3 to result → get result
        5. Return final result
        
        Args:
            data: Data to transform
            
        Returns:
            Transformed data (after all transformers)
        
        Example:
            >>> # Create pipeline
            >>> pipeline = TransformationPipeline()
            >>> pipeline.add_transformer(CleaningTransformer())
            >>> pipeline.add_transformer(EnrichmentTransformer())
            >>> 
            >>> # Run pipeline
            >>> data = [{'name': '  Camp A  ', 'price': '100'}]
            >>> result = pipeline.execute(data)
            
            ======================================================================
            🔄 EXECUTING TRANSFORMATION PIPELINE
            ======================================================================
            Input rows: 1
            ⚙️  Applying transformation: Data Cleaning...
            ✅ Cleaned 1 rows
            ⚙️  Applying transformation: Data Enrichment...
            ✅ Enriched 1 rows
            Output rows: 1
            ======================================================================
            
            >>> print(result[0])
            {
                'name': 'Camp A',
                'price': '100',
                'processed_at': '2024-03-10T14:30:00',
                'etl_version': '1.0'
            }
        """
        print(f"\n{'='*70}")
        print(f"🔄 EXECUTING TRANSFORMATION PIPELINE")
        print(f"{'='*70}")
        print(f"Input rows: {len(data)}")
        
        current_data = data
        
        # Apply each transformer to result of previous transformer
        for transformer in self.transformers:
            current_data = transformer.transform(current_data)
        
        print(f"Output rows: {len(current_data)}")
        print(f"{'='*70}\n")
        
        return current_data
    
    def get_statistics(self):
        """Get statistics from all transformers.
        
        Returns:
            dict: Statistics for each transformer
        
        Example:
            >>> stats = pipeline.get_statistics()
            >>> for name, data in stats.items():
            ...     print(f"{name}: {data['transforms']} transformations")
        """
        stats = {}
        for transformer in self.transformers:
            stats[transformer.name] = {
                'transforms': transformer.get_transform_count()
            }
        return stats
```

### 📚 Additional Transformer Examples:

#### Example 1: Type Conversion Transformer
```python
class TypeConversionTransformer(DataTransformer):
    """Convert data types (string → int, string → float, etc.)."""
    
    def __init__(self, type_mapping):
        """Initialize type conversion transformer.
        
        Args:
            type_mapping: dict of {field: type}
        
        Example:
            >>> transformer = TypeConversionTransformer({
            ...     'price': float,
            ...     'capacity': int,
            ...     'has_wifi': bool
            ... })
        """
        super().__init__("Type Conversion")
        self.type_mapping = type_mapping
    
    def transform(self, data):
        """Convert data types."""
        super().transform(data)
        
        converted_data = []
        
        for row in data:
            converted_row = row.copy()
            
            for field, target_type in self.type_mapping.items():
                if field in converted_row and converted_row[field] is not None:
                    try:
                        # Convert type
                        if target_type == bool:
                            # Handle bool specially ('true' → True)
                            converted_row[field] = str(converted_row[field]).lower() in ['true', '1', 'yes']
                        else:
                            converted_row[field] = target_type(converted_row[field])
                    except (ValueError, TypeError):
                        # Conversion failed, keep original
                        pass
            
            converted_data.append(converted_row)
            self.transform_count += 1
        
        print(f"✅ Converted types for {len(converted_data)} rows")
        return converted_data

# Usage:
transformer = TypeConversionTransformer({
    'price': float,
    'capacity': int,
    'has_wifi': bool
})

data = [{'price': '100.50', 'capacity': '50', 'has_wifi': 'true'}]
result = transformer.transform(data)
print(result[0])
# {'price': 100.5, 'capacity': 50, 'has_wifi': True}
```

#### Example 2: Deduplication Transformer
```python
class DeduplicationTransformer(DataTransformer):
    """Remove duplicate rows."""
    
    def __init__(self, key_fields):
        """Initialize deduplication transformer.
        
        Args:
            key_fields: List of fields that define uniqueness
        
        Example:
            >>> # Rows are duplicate if id AND name match
            >>> transformer = DeduplicationTransformer(['id', 'name'])
        """
        super().__init__("Deduplication")
        self.key_fields = key_fields
        self.duplicates_removed = 0
    
    def transform(self, data):
        """Remove duplicates."""
        super().transform(data)
        
        seen = set()
        unique_data = []
        
        for row in data:
            # Create key from specified fields
            key = tuple(row.get(field) for field in self.key_fields)
            
            if key not in seen:
                seen.add(key)
                unique_data.append(row)
            else:
                self.duplicates_removed += 1
            
            self.transform_count += 1
        
        print(f"✅ Removed {self.duplicates_removed} duplicates, kept {len(unique_data)} unique rows")
        return unique_data

# Usage:
transformer = DeduplicationTransformer(['id'])

data = [
    {'id': 1, 'name': 'Camp A'},
    {'id': 2, 'name': 'Camp B'},
    {'id': 1, 'name': 'Camp A'},  # Duplicate!
]

result = transformer.transform(data)
print(len(result))  # 2 (duplicate removed)
```

#### Example 3: Aggregation Transformer
```python
class AggregationTransformer(DataTransformer):
    """Aggregate data by key fields."""
    
    def __init__(self, group_by, aggregations):
        """Initialize aggregation transformer.
        
        Args:
            group_by: Field to group by
            aggregations: dict of {new_field: (source_field, function)}
        
        Example:
            >>> transformer = AggregationTransformer(
            ...     group_by='state',
            ...     aggregations={
            ...         'total_campsites': ('id', 'count'),
            ...         'avg_price': ('price', 'avg')
            ...     }
            ... )
        """
        super().__init__("Aggregation")
        self.group_by = group_by
        self.aggregations = aggregations
    
    def transform(self, data):
        """Aggregate data."""
        super().transform(data)
        
        # Group data
        groups = {}
        for row in data:
            key = row[self.group_by]
            if key not in groups:
                groups[key] = []
            groups[key].append(row)
        
        # Aggregate each group
        result = []
        for key, rows in groups.items():
            agg_row = {self.group_by: key}
            
            for new_field, (source_field, func) in self.aggregations.items():
                values = [row[source_field] for row in rows if row.get(source_field) is not None]
                
                if func == 'count':
                    agg_row[new_field] = len(values)
                elif func == 'sum':
                    agg_row[new_field] = sum(values)
                elif func == 'avg':
                    agg_row[new_field] = sum(values) / len(values) if values else 0
                elif func == 'min':
                    agg_row[new_field] = min(values) if values else None
                elif func == 'max':
                    agg_row[new_field] = max(values) if values else None
            
            result.append(agg_row)
            self.transform_count += 1
        
        print(f"✅ Aggregated into {len(result)} groups")
        return result

# Usage:
transformer = AggregationTransformer(
    group_by='state',
    aggregations={
        'count': ('id', 'count'),
        'avg_price': ('price', 'avg'),
        'max_capacity': ('capacity', 'max')
    }
)

data = [
    {'id': 1, 'state': 'MG', 'price': 100, 'capacity': 50},
    {'id': 2, 'state': 'MG', 'price': 150, 'capacity': 30},
    {'id': 3, 'state': 'RJ', 'price': 200, 'capacity': 40},
]

result = transformer.transform(data)
print(result)
# [
#   {'state': 'MG', 'count': 2, 'avg_price': 125.0, 'max_capacity': 50},
#   {'state': 'RJ', 'count': 1, 'avg_price': 200.0, 'max_capacity': 40}
# ]
```

### 🎯 Complete Transformation Pipeline Example:

This example shows how ALL transformers work together in sequence:

```python
# Create validators
validators = {
    'name': RequiredFieldValidator('name'),
    'price': NumericRangeValidator('price', 0, 10000),
    'state': StateValidator()
}

# Create transformation pipeline
pipeline = TransformationPipeline()

# Add transformers in order
pipeline.add_transformer(CleaningTransformer())
pipeline.add_transformer(TypeConversionTransformer({
    'price': float,
    'capacity': int
}))
pipeline.add_transformer(EnrichmentTransformer())
pipeline.add_transformer(ValidationTransformer(validators))
pipeline.add_transformer(DeduplicationTransformer(['id']))

# Raw messy data
data = [
    {'id': '1', 'name': '  Camp A  ', 'price': '100.50', 'state': 'mg', 'capacity': '50'},
    {'id': '2', 'name': '', 'price': '-50', 'state': 'ZZ', 'capacity': '30'},  # Invalid!
    {'id': '1', 'name': '  Camp A  ', 'price': '100.50', 'state': 'mg', 'capacity': '50'},  # Duplicate!
]

# Transform!
clean_data = pipeline.execute(data)

# Result: 1 clean row (invalid and duplicate removed)
print(clean_data[0])
# {
#     'id': '1',
#     'name': 'Camp A',
#     'price': 100.5,
#     'state': 'MG',
#     'capacity': 50,
#     'processed_at': '2024-03-10T14:30:00',
#     'etl_version': '1.0'
# }
```

**What Happened in This Pipeline:**
1. **CleaningTransformer**: Removed whitespace from "  Camp A  " → "Camp A", normalized state "mg" → "MG"
2. **TypeConversionTransformer**: Converted "100.50" (string) → 100.5 (float), "50" (string) → 50 (int)
3. **EnrichmentTransformer**: Added `processed_at` timestamp and `etl_version` metadata
4. **ValidationTransformer**: Rejected row 2 (empty name, negative price, invalid state)
5. **DeduplicationTransformer**: Removed row 3 (duplicate of row 1)

**Final Result**: Started with 3 rows → Ended with 1 clean, valid, deduplicated row!

---

```python
"""Data transformers for ETL system (continued).

This section contains the actual transformer implementations.
"""
from datetime import datetime


class DataTransformer:
    """Base transformer for data cleaning and transformation.
    
    This is NOT an abstract class (no ABC) because it has
    a default implementation that children can use.
    """
    
    def __init__(self, name):
        """Initialize transformer.
        
        Args:
            name: Human-readable transformer name
        """
        self.name = name
        self.transform_count = 0
        
        print(f"🔧 Transformer initialized: {name}")
    
    def transform(self, data):
        """Transform data.
        
        Args:
            data: Data to transform
            
        Returns:
            Transformed data
        """
        print(f"⚙️  Applying transformation: {self.name}...")
        return data
    
    def get_transform_count(self):
        """Get number of transformations applied.
        
        Returns:
            int: Transform count
        """
        return self.transform_count


class CleaningTransformer(DataTransformer):
    """Clean data (remove nulls, trim whitespace, etc.)."""
    
    def __init__(self):
        """Initialize cleaning transformer."""
        super().__init__("Data Cleaning")
    
    def transform(self, data):
        """Clean data.
        
        Args:
            data: List of dictionaries to clean
            
        Returns:
            list: Cleaned data
        """
        super().transform(data)
        
        cleaned_data = []
        
        for row in data:
            cleaned_row = {}
            
            for key, value in row.items():
                # Trim whitespace from strings
                if isinstance(value, str):
                    cleaned_row[key] = value.strip()
                # Convert empty strings to None
                elif value == '':
                    cleaned_row[key] = None
                else:
                    cleaned_row[key] = value
            
            cleaned_data.append(cleaned_row)
            self.transform_count += 1
        
        print(f"✅ Cleaned {len(cleaned_data)} rows")
        return cleaned_data


class EnrichmentTransformer(DataTransformer):
    """Enrich data with additional fields."""
    
    def __init__(self):
        """Initialize enrichment transformer."""
        super().__init__("Data Enrichment")
    
    def transform(self, data):
        """Enrich data with metadata.
        
        Args:
            data: List of dictionaries to enrich
            
        Returns:
            list: Enriched data
        """
        super().transform(data)
        
        enriched_data = []
        current_time = datetime.now().isoformat()
        
        for row in data:
            enriched_row = row.copy()
            enriched_row['processed_at'] = current_time
            enriched_row['etl_version'] = '1.0'
            
            enriched_data.append(enriched_row)
            self.transform_count += 1
        
        print(f"✅ Enriched {len(enriched_data)} rows")
        return enriched_data


class ValidationTransformer(DataTransformer):
    """Validate data using validators (composition)."""
    
    def __init__(self, validators):
        """Initialize validation transformer.
        
        Args:
            validators: Dictionary of {field_name: validator}
        """
        super().__init__("Data Validation")
        self.validators = validators
        self.valid_count = 0
        self.invalid_count = 0
        self.errors = []
    
    def transform(self, data):
        """Validate data and filter invalid rows.
        
        Args:
            data: List of dictionaries to validate
            
        Returns:
            list: Valid data only
        """
        super().transform(data)
        
        valid_data = []
        
        for i, row in enumerate(data):
            is_valid = True
            row_errors = []
            
            # Validate each field
            for field_name, validator in self.validators.items():
                value = row.get(field_name)
                valid, error_msg = validator.validate(value)
                
                if not valid:
                    is_valid = False
                    row_errors.append({
                        'row': i + 1,
                        'field': field_name,
                        'value': value,
                        'error': error_msg
                    })
            
            if is_valid:
                valid_data.append(row)
                self.valid_count += 1
            else:
                self.invalid_count += 1
                self.errors.extend(row_errors)
            
            self.transform_count += 1
        
        print(f"✅ Validated {len(data)} rows: {self.valid_count} valid, {self.invalid_count} invalid")
        
        return valid_data
    
    def get_validation_report(self):
        """Get validation statistics report.
        
        Returns:
            dict: Validation report
        """
        return {
            'total_rows': self.transform_count,
            'valid_rows': self.valid_count,
            'invalid_rows': self.invalid_count,
            'errors': self.errors,
            'validators': {
                field: validator.get_statistics() 
                for field, validator in self.validators.items()
            }
        }


class TransformationPipeline:
    """Pipeline that applies multiple transformers in sequence.
    
    Demonstrates composition: contains multiple transformers.
    """
    
    def __init__(self):
        """Initialize transformation pipeline."""
        self.transformers = []
        
        print(f"🔄 Transformation Pipeline initialized")
    
    def add_transformer(self, transformer):
        """Add transformer to pipeline.
        
        Args:
            transformer: Transformer to add
        """
        self.transformers.append(transformer)
        print(f"   ➕ Added: {transformer.name}")
    
    def execute(self, data):
        """Execute all transformers in sequence.
        
        Args:
            data: Data to transform
            
        Returns:
            Transformed data
        """
        print(f"\n{'='*70}")
        print(f"🔄 EXECUTING TRANSFORMATION PIPELINE")
        print(f"{'='*70}")
        print(f"Input rows: {len(data)}")
        
        current_data = data
        
        for transformer in self.transformers:
            current_data = transformer.transform(current_data)
        
        print(f"Output rows: {len(current_data)}")
        print(f"{'='*70}\n")
        
        return current_data
    
    def get_statistics(self):
        """Get statistics from all transformers.
        
        Returns:
            dict: Statistics
        """
        stats = {}
        for transformer in self.transformers:
            stats[transformer.name] = {
                'transforms': transformer.get_transform_count()
            }
        return stats
```

---

## 📝 Step 6: Data Loaders (with Polymorphism)

### 🎯 What This Does:

**Data Loaders** write your transformed data to destinations. Using polymorphism, your ETL pipeline can load to ANY destination without changing the pipeline code:

- **FileLoader**: Save to JSON or CSV files
- **DatabaseLoader**: Load to PostgreSQL database
- **S3Loader**: Upload to AWS S3
- **APILoader**: POST to REST API

### 💡 Why Polymorphism Matters:

**Without Polymorphism** (Bad):
```python
if loader_type == 'file':
    save_to_file(data)
elif loader_type == 'database':
    save_to_database(data)
elif loader_type == 's3':
    upload_to_s3(data)
# New destination? Modify pipeline code!
```

**With Polymorphism** (Good):
```python
# Works with ANY loader!
loader.connect()
loader.load(data)
loader.disconnect()

# Add new loader? No pipeline changes needed!
```

### 🔍 Code Explanation:

Create `src/loaders.py`:

```python
"""Data loaders for ETL system.

Demonstrates:
- Abstract base classes
- Inheritance
- Polymorphism
"""

from abc import ABC, abstractmethod
from pathlib import Path
import json
import csv


class DataLoader(ABC):
    """Abstract base class for data loaders.
    
    Defines the CONTRACT that all loaders must follow:
    1. Must implement connect()
    2. Must implement load()
    3. Can optionally override disconnect()
    """
    
    def __init__(self, name, loader_type):
        """Initialize data loader.
        
        Args:
            name: Human-readable loader name
            loader_type: Type identifier (e.g., 'File', 'Database', 'S3')
        
        Example:
            >>> # In child class:
            >>> super().__init__("Output File", "File")
        """
        self.name = name
        self.loader_type = loader_type
        self.loaded_count = 0  # Track rows loaded
        
        print(f"📤 {loader_type} Loader initialized: {name}")
    
    @abstractmethod
    def connect(self):
        """Connect to destination (must be implemented by children).
        
        Each loader type connects differently:
        - File: Create directory if needed
        - Database: Open database connection
        - S3: Create AWS session
        - API: Initialize HTTP session
        """
        pass
    
    @abstractmethod
    def load(self, data):
        """Load data to destination (must be implemented by children).
        
        Each loader type loads differently:
        - File: Write to JSON/CSV file
        - Database: Execute INSERT statements
        - S3: Upload file to bucket
        - API: POST data to endpoint
        """
        pass
    
    def disconnect(self):
        """Disconnect from destination.
        
        Default implementation - child classes can override if needed.
        """
        print(f"🔒 Disconnected from {self.name}")
    
    def get_loaded_count(self):
        """Get number of rows loaded.
        
        Returns:
            int: Number of rows loaded
        """
        return self.loaded_count
    
    def __str__(self):
        """String representation (special method).
        
        Example:
            >>> loader = FileLoader("Output", "output.json")
            >>> print(loader)
            File Loader: Output (100 rows loaded)
        """
        return f"{self.loader_type} Loader: {self.name} ({self.loaded_count} rows loaded)"


class FileLoader(DataLoader):
    """Load data to file (JSON or CSV).
    
    Supports multiple file formats using the same interface.
    """
    
    def __init__(self, name, output_file, file_format='json'):
        """Initialize file loader.
        
        Args:
            name: Loader name
            output_file: Output file path
            file_format: 'json' or 'csv'
        
        Examples:
            >>> # JSON file
            >>> loader = FileLoader("Output", "data/output.json", "json")
            📤 File Loader initialized: Output
               📁 Output file: data/output.json (json)
            
            >>> # CSV file
            >>> loader = FileLoader("Output", "data/output.csv", "csv")
            📤 File Loader initialized: Output
               📁 Output file: data/output.csv (csv)
        """
        super().__init__(name, "File")
        self.output_file = Path(output_file)
        self.file_format = file_format.lower()
        
        print(f"   📁 Output file: {self.output_file} ({self.file_format})")
    
    def connect(self):
        """Connect (create output directory if needed).
        
        For file loaders, "connecting" means ensuring the
        directory exists and is writable.
        
        Example:
            >>> loader.connect()
            📡 Preparing file output: data/output/processed.json...
            ✅ Ready to write to file
        """
        print(f"📡 Preparing file output: {self.output_file}...")
        
        # Create parent directory if it doesn't exist
        self.output_file.parent.mkdir(parents=True, exist_ok=True)
        
        print(f"✅ Ready to write to file")
    
    def load(self, data):
        """Load data to file.
        
        Delegates to format-specific method based on file_format.
        
        Args:
            data: List of dictionaries to write
        
        Example:
            >>> data = [
            ...     {'id': 1, 'name': 'Camp A'},
            ...     {'id': 2, 'name': 'Camp B'}
            ... ]
            >>> loader.load(data)
            💾 Loading 2 rows to JSON file...
            ✅ Loaded 2 rows to file
        """
        print(f"💾 Loading {len(data)} rows to {self.file_format.upper()} file...")
        
        if self.file_format == 'json':
            self._load_json(data)
        elif self.file_format == 'csv':
            self._load_csv(data)
        else:
            raise ValueError(f"Unsupported file format: {self.file_format}")
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to file")
    
    def _load_json(self, data):
        """Load data to JSON file.
        
        Writes pretty-formatted JSON with indentation.
        """
        with open(self.output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, default=str)  # default=str handles dates
    
    def _load_csv(self, data):
        """Load data to CSV file.
        
        Automatically determines columns from data.
        """
        if not data:
            return
        
        # Get all unique keys from all rows (in case rows have different fields)
        fieldnames = set()
        for row in data:
            fieldnames.update(row.keys())
        
        fieldnames = sorted(fieldnames)  # Sort for consistency
        
        with open(self.output_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(data)


class DatabaseLoader(DataLoader):
    """Load data to PostgreSQL database.
    
    NOTE: This is a simplified version for the project.
    In production, you'd use SQLAlchemy or psycopg2.
    """
    
    def __init__(self, name, connection_string):
        """Initialize database loader.
        
        Args:
            name: Loader name
            connection_string: Database connection string
        
        Example:
            >>> loader = DatabaseLoader(
            ...     "PostgreSQL",
            ...     "host=localhost dbname=camping_db user=postgres password=secret"
            ... )
            📤 Database Loader initialized: PostgreSQL
               🗄️  Connection: host=localhost dbname=camping_db...
        """
        super().__init__(name, "Database")
        self.connection_string = connection_string
        self.connection = None
        
        print(f"   🗄️  Connection: {connection_string}")
    
    def connect(self):
        """Connect to database.
        
        NOTE: For this project, we simulate the connection.
        Real implementation would use:
        >>> import psycopg2
        >>> self.connection = psycopg2.connect(self.connection_string)
        
        Example:
            >>> loader.connect()
            📡 Connecting to database...
            ✅ Connected to database
        """
        print(f"📡 Connecting to database...")
        
        # SIMULATED CONNECTION
        # Real code:
        # import psycopg2
        # self.connection = psycopg2.connect(self.connection_string)
        self.connection = "SIMULATED_DB_CONNECTION"
        
        print(f"✅ Connected to database")
    
    def load(self, data):
        """Load data to database.
        
        Args:
            data: List of dictionaries to insert
        
        NOTE: This is simulated for the project.
        Real implementation would execute INSERT statements.
        
        Example:
            >>> loader.load(data)
            💾 Loading 100 rows to database...
            ✅ Loaded 100 rows to database (SIMULATED)
        """
        if not self.connection:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"💾 Loading {len(data)} rows to database...")
        
        # SIMULATED INSERT
        # Real code:
        # cursor = self.connection.cursor()
        # for row in data:
        #     columns = ', '.join(row.keys())
        #     placeholders = ', '.join(['%s'] * len(row))
        #     query = f"INSERT INTO table_name ({columns}) VALUES ({placeholders})"
        #     cursor.execute(query, list(row.values()))
        # self.connection.commit()
        # cursor.close()
        
        for row in data:
            pass  # Simulated insert
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to database (SIMULATED)")
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection:
            # Real code: self.connection.close()
            self.connection = None
        super().disconnect()
```

### 📚 Real-World Loader Examples:

#### Example 1: PostgreSQL Loader (Real Implementation)
```python
import psycopg2
from psycopg2.extras import execute_batch

class PostgreSQLLoader(DataLoader):
    """Real PostgreSQL loader using psycopg2."""
    
    def __init__(self, name, config, table_name):
        """Initialize PostgreSQL loader.
        
        Args:
            name: Loader name
            config: Database config dict
            table_name: Target table name
        
        Example:
            >>> config = {
            ...     'host': 'localhost',
            ...     'port': 5432,
            ...     'database': 'camping_db',
            ...     'user': 'postgres',
            ...     'password': 'secret123'
            ... }
            >>> loader = PostgreSQLLoader("PostgreSQL", config, "campsites")
        """
        super().__init__(name, "PostgreSQL")
        self.config = config
        self.table_name = table_name
        self.connection = None
        self.cursor = None
    
    def connect(self):
        """Connect to PostgreSQL database."""
        print(f"📡 Connecting to PostgreSQL at {self.config['host']}...")
        
        self.connection = psycopg2.connect(
            host=self.config['host'],
            port=self.config['port'],
            database=self.config['database'],
            user=self.config['user'],
            password=self.config['password']
        )
        self.cursor = self.connection.cursor()
        
        print(f"✅ Connected to PostgreSQL")
    
    def load(self, data):
        """Load data to PostgreSQL table.
        
        Uses execute_batch for better performance.
        """
        if not self.connection:
            raise Exception("Not connected!")
        
        print(f"💾 Loading {len(data)} rows to table {self.table_name}...")
        
        if not data:
            return
        
        # Get columns from first row
        columns = list(data[0].keys())
        placeholders = ', '.join(['%s'] * len(columns))
        columns_str = ', '.join(columns)
        
        # Build INSERT query
        query = f"""
            INSERT INTO {self.table_name} ({columns_str})
            VALUES ({placeholders})
        """
        
        # Prepare data as tuples
        values = [tuple(row[col] for col in columns) for row in data]
        
        # Execute batch insert (faster than individual inserts)
        execute_batch(self.cursor, query, values)
        self.connection.commit()
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to PostgreSQL")
    
    def disconnect(self):
        """Disconnect from PostgreSQL."""
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        super().disconnect()

# Usage:
config = {
    'host': 'localhost',
    'port': 5432,
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'secret123'
}

loader = PostgreSQLLoader("PostgreSQL", config, "campsites")
loader.connect()
loader.load(data)
loader.disconnect()
```

#### Example 2: SQLite Loader
```python
import sqlite3

class SQLiteLoader(DataLoader):
    """SQLite database loader."""
    
    def __init__(self, name, db_path, table_name):
        """Initialize SQLite loader.
        
        Example:
            >>> loader = SQLiteLoader("SQLite", "data/camping.db", "campsites")
        """
        super().__init__(name, "SQLite")
        self.db_path = Path(db_path)
        self.table_name = table_name
        self.connection = None
    
    def connect(self):
        """Connect to SQLite database."""
        print(f"📡 Connecting to SQLite: {self.db_path}...")
        
        # Create directory if needed
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        
        self.connection = sqlite3.connect(self.db_path)
        
        print(f"✅ Connected to SQLite")
    
    def load(self, data):
        """Load data to SQLite table."""
        if not self.connection:
            raise Exception("Not connected!")
        
        print(f"💾 Loading {len(data)} rows to table {self.table_name}...")
        
        if not data:
            return
        
        cursor = self.connection.cursor()
        
        # Get columns
        columns = list(data[0].keys())
        placeholders = ', '.join(['?' * len(columns)])
        columns_str = ', '.join(columns)
        
        # Insert query
        query = f"""
            INSERT INTO {self.table_name} ({columns_str})
            VALUES ({placeholders})
        """
        
        # Insert all rows
        values = [tuple(row[col] for col in columns) for row in data]
        cursor.executemany(query, values)
        self.connection.commit()
        cursor.close()
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to SQLite")
    
    def disconnect(self):
        """Disconnect from SQLite."""
        if self.connection:
            self.connection.close()
        super().disconnect()

# Usage:
loader = SQLiteLoader("SQLite", "data/camping.db", "campsites")
loader.connect()
loader.load(data)
loader.disconnect()
```

#### Example 3: AWS S3 Loader
```python
import boto3
import json
from datetime import datetime

class S3Loader(DataLoader):
    """AWS S3 bucket loader."""
    
    def __init__(self, name, bucket_name, prefix=''):
        """Initialize S3 loader.
        
        Args:
            name: Loader name
            bucket_name: S3 bucket name
            prefix: Optional key prefix (folder path)
        
        Example:
            >>> loader = S3Loader("S3", "my-camping-data", "etl/processed/")
        """
        super().__init__(name, "S3")
        self.bucket_name = bucket_name
        self.prefix = prefix
        self.s3_client = None
    
    def connect(self):
        """Connect to AWS S3."""
        print(f"📡 Connecting to S3 bucket: {self.bucket_name}...")
        
        self.s3_client = boto3.client('s3')
        
        print(f"✅ Connected to S3")
    
    def load(self, data):
        """Load data to S3 as JSON file."""
        if not self.s3_client:
            raise Exception("Not connected!")
        
        print(f"💾 Uploading {len(data)} rows to S3...")
        
        # Generate filename with timestamp
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        key = f"{self.prefix}data_{timestamp}.json"
        
        # Convert data to JSON
        json_data = json.dumps(data, indent=2, default=str)
        
        # Upload to S3
        self.s3_client.put_object(
            Bucket=self.bucket_name,
            Key=key,
            Body=json_data.encode('utf-8'),
            ContentType='application/json'
        )
        
        self.loaded_count = len(data)
        print(f"✅ Uploaded {self.loaded_count} rows to S3: s3://{self.bucket_name}/{key}")

# Usage:
loader = S3Loader("S3", "my-camping-data", "etl/processed/")
loader.connect()
loader.load(data)
```

#### Example 4: REST API Loader
```python
import requests

class APILoader(DataLoader):
    """REST API loader."""
    
    def __init__(self, name, base_url, endpoint, api_key=None):
        """Initialize API loader.
        
        Example:
            >>> loader = APILoader(
            ...     "API",
            ...     "https://api.camping.com",
            ...     "/v1/campsites",
            ...     "your_api_key"
            ... )
        """
        super().__init__(name, "API")
        self.base_url = base_url
        self.endpoint = endpoint
        self.api_key = api_key
        self.session = None
    
    def connect(self):
        """Prepare API session."""
        print(f"📡 Connecting to API: {self.base_url}...")
        
        self.session = requests.Session()
        
        if self.api_key:
            self.session.headers.update({
                'Authorization': f'Bearer {self.api_key}',
                'Content-Type': 'application/json'
            })
        
        print(f"✅ Connected to API")
    
    def load(self, data):
        """Load data to API endpoint."""
        if not self.session:
            raise Exception("Not connected!")
        
        print(f"💾 Posting {len(data)} rows to API...")
        
        url = f"{self.base_url}{self.endpoint}"
        
        # Post data (can be done in batches for large datasets)
        response = self.session.post(url, json=data)
        response.raise_for_status()
        
        self.loaded_count = len(data)
        print(f"✅ Posted {self.loaded_count} rows to API")
    
    def disconnect(self):
        """Close API session."""
        if self.session:
            self.session.close()
        super().disconnect()

# Usage:
loader = APILoader(
    "API",
    "https://api.camping.com",
    "/v1/campsites",
    "your_api_key"
)
loader.connect()
loader.load(data)
loader.disconnect()
```

### 🎯 Polymorphism in Action:

The beauty is that your ETL pipeline works with ALL loaders the same way:

```python
# Create different loaders
file_loader = FileLoader("File", "output.json", "json")
postgres_loader = PostgreSQLLoader("PostgreSQL", db_config, "campsites")
sqlite_loader = SQLiteLoader("SQLite", "data/camping.db", "campsites")
s3_loader = S3Loader("S3", "my-bucket", "etl/")
api_loader = APILoader("API", "https://api.camping.com", "/v1/campsites")

# Use ANY loader with the same code!
for loader in [file_loader, postgres_loader, sqlite_loader, s3_loader, api_loader]:
    loader.connect()
    loader.load(data)
    print(f"Loaded {loader.get_loaded_count()} rows")
    loader.disconnect()

# Pipeline doesn't care which loader is used!
pipeline.set_loader(file_loader)  # or any other loader
pipeline.run()
```

**💡 What Makes This Powerful:**

Your ETL pipeline is **completely decoupled** from the specific destination:
- Want to switch from JSON files to PostgreSQL? Just change the loader!
- Want to load to multiple destinations? Create multiple loaders and run multiple times!
- Want to A/B test different storage systems? Easy - just swap loaders!

This is **polymorphism** in action: same interface (`connect()`, `load()`, `disconnect()`), different implementations.

---

## 📝 Step 7: Statistics Collector

Now let's look at the base `DataLoader` class implementation:

```python
# In src/loaders.py

class DataLoader(ABC):
    """Base class for all data loaders (abstract).
    
    This is the PARENT class that defines the interface.
    All loaders (FileLoader, PostgreSQLLoader, etc.) inherit from this.
    """
    
    def __init__(self, name, loader_type):
        """Initialize loader.
        
        Args:
            name: Loader name
            loader_type: Type of loader (File, Database, etc.)
        """
        self.name = name
        self.loader_type = loader_type
        self.loaded_count = 0
        
        print(f"📤 {loader_type} Loader initialized: {name}")
    
    @abstractmethod
    def connect(self):
        """Connect to destination (must be implemented by children)."""
        pass
    
    @abstractmethod
    def load(self, data):
        """Load data to destination (must be implemented by children)."""
        pass
    
    def disconnect(self):
        """Disconnect from destination."""
        print(f"🔒 Disconnected from {self.name}")
    
    def get_loaded_count(self):
        """Get number of rows loaded.
        
        Returns:
            int: Number of rows loaded
        """
        return self.loaded_count
    
    def __str__(self):
        """String representation (special method)."""
        return f"{self.loader_type} Loader: {self.name} ({self.loaded_count} rows loaded)"


class FileLoader(DataLoader):
    """Load data to file (JSON or CSV)."""
    
    def __init__(self, name, output_file, file_format='json'):
        """Initialize file loader.
        
        Args:
            name: Loader name
            output_file: Output file path
            file_format: 'json' or 'csv'
        """
        super().__init__(name, "File")
        self.output_file = Path(output_file)
        self.file_format = file_format.lower()
        
        print(f"   📁 Output file: {self.output_file} ({self.file_format})")
    
    def connect(self):
        """Connect (create output directory if needed)."""
        print(f"📡 Preparing file output: {self.output_file}...")
        
        # Create parent directory
        self.output_file.parent.mkdir(parents=True, exist_ok=True)
        
        print(f"✅ Ready to write to file")
    
    def load(self, data):
        """Load data to file.
        
        Args:
            data: List of dictionaries to write
        """
        print(f"💾 Loading {len(data)} rows to {self.file_format.upper()} file...")
        
        if self.file_format == 'json':
            self._load_json(data)
        elif self.file_format == 'csv':
            self._load_csv(data)
        else:
            raise ValueError(f"Unsupported file format: {self.file_format}")
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to file")
    
    def _load_json(self, data):
        """Load data to JSON file."""
        with open(self.output_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, default=str)
    
    def _load_csv(self, data):
        """Load data to CSV file."""
        if not data:
            return
        
        # Get all unique keys from all rows
        fieldnames = set()
        for row in data:
            fieldnames.update(row.keys())
        
        fieldnames = sorted(fieldnames)
        
        with open(self.output_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(data)


class DatabaseLoader(DataLoader):
    """Load data to PostgreSQL database.
    
    NOTE: This is a simplified version for the project.
    In production, you'd use SQLAlchemy or psycopg2.
    """
    
    def __init__(self, name, connection_string):
        """Initialize database loader.
        
        Args:
            name: Loader name
            connection_string: Database connection string
        """
        super().__init__(name, "Database")
        self.connection_string = connection_string
        self.connection = None
        
        print(f"   🗄️  Connection: {connection_string}")
    
    def connect(self):
        """Connect to database.
        
        NOTE: For this project, we'll simulate the connection.
        In real code, use: psycopg2.connect(self.connection_string)
        """
        print(f"📡 Connecting to database...")
        
        # Simulated connection
        self.connection = "SIMULATED_DB_CONNECTION"
        
        print(f"✅ Connected to database")
    
    def load(self, data):
        """Load data to database.
        
        Args:
            data: List of dictionaries to insert
            
        NOTE: This is simulated for the project.
        Real code would use INSERT statements.
        """
        if not self.connection:
            raise Exception("Not connected! Call connect() first.")
        
        print(f"💾 Loading {len(data)} rows to database...")
        
        # Simulate database insert
        for row in data:
            # In real code: cursor.execute("INSERT INTO ...", row)
            pass
        
        self.loaded_count = len(data)
        print(f"✅ Loaded {self.loaded_count} rows to database (SIMULATED)")
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection:
            # In real code: self.connection.close()
            self.connection = None
        super().disconnect()
```

---

## 📝 Step 7: Statistics Collector

### 🎯 What This Does:

**Statistics Collector** tracks everything that happens in your ETL pipeline. It's like the "black box" recorder on an airplane - records all the important metrics:

- **Timing**: How long did the pipeline take?
- **Data Flow**: How many rows at each stage (Extracted → Transformed → Loaded)?
- **Success Rate**: What percentage of data made it through?
- **Errors**: What went wrong and where?
- **Data Loss**: How many rows were rejected and why?

### 💡 Why Statistics Matter:

**Without Statistics**:
```
Pipeline finished!
(But... was it successful? How many rows? Any errors? No idea!)
```

**With Statistics**:
```
======================================================================
📊 ETL PIPELINE STATISTICS
======================================================================

⏱️  TIMING:
   Start: 2024-03-10 14:30:45
   End: 2024-03-10 14:30:47
   Duration: 2.15 seconds

📈 DATA FLOW:
   Sources Processed: 3
   Rows Extracted: 1000
   Rows Transformed: 950
   Rows Loaded: 950
   Success Rate: 95.00%

⚠️  DATA LOSS:
   Rows Lost: 50 (5.00%)
   
✅ NO ERRORS!
======================================================================
```

Now you know EXACTLY what happened!

### 🔍 Code Explanation:

Create `src/statistics.py`:

```python
"""Statistics collector for ETL pipeline.

Demonstrates:
- Instance attributes for tracking state
- Calculations (duration, success rate)
- Special methods (__str__, __repr__)
- Formatted output
"""

from datetime import datetime


class ETLStatistics:
class ETLStatistics:
    """Collect and display ETL pipeline statistics.
    
    This class tracks EVERYTHING that happens during ETL:
    - When did it start/end?
    - How many rows at each stage?
    - Were there any errors?
    - What's the success rate?
    
    Think of it as your pipeline's "report card"!
    """
    
    def __init__(self):
        """Initialize statistics collector.
        
        Sets all metrics to default values (None or 0).
        
        Example:
            >>> stats = ETLStatistics()
            📊 Statistics Collector initialized
            >>> 
            >>> # All metrics start empty
            >>> print(stats.rows_extracted)
            0
            >>> print(stats.start_time)
            None
        """
        # Timing attributes
        self.start_time = None  # When pipeline started
        self.end_time = None    # When pipeline ended
        
        # Data flow attributes
        self.sources_processed = 0  # How many data sources used
        self.rows_extracted = 0     # Total rows extracted from all sources
        self.rows_transformed = 0   # Rows after transformation
        self.rows_loaded = 0        # Rows successfully loaded
        
        # Error tracking
        self.errors = []  # List of all errors encountered
        
        print(f"📊 Statistics Collector initialized")
    
    def start(self):
        """Start timing the pipeline.
        
        Records the current time as start_time.
        Call this at the beginning of your pipeline.
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.start()
            ⏱️  Timer started: 14:30:45
        """
        self.start_time = datetime.now()
        print(f"⏱️  Timer started: {self.start_time.strftime('%H:%M:%S')}")
    
    def stop(self):
        """Stop timing the pipeline.
        
        Records the current time as end_time.
        Call this at the end of your pipeline.
        
        Example:
            >>> stats.stop()
            ⏱️  Timer stopped: 14:30:47
            >>> 
            >>> # Now you can calculate duration
            >>> print(stats.get_duration())
            2.15  # seconds
        """
        self.end_time = datetime.now()
        print(f"⏱️  Timer stopped: {self.end_time.strftime('%H:%M:%S')}")
    
    def add_source(self, row_count):
        """Add statistics for a processed source.
        
        Call this each time you extract from a data source.
        It increments source counter and adds to extracted rows.
        
        Args:
            row_count: Number of rows extracted from this source
        
        Example:
            >>> stats = ETLStatistics()
            >>> 
            >>> # Extracted 100 rows from CSV
            >>> stats.add_source(100)
            >>> 
            >>> # Extracted 50 rows from JSON
            >>> stats.add_source(50)
            >>> 
            >>> # Check totals
            >>> print(stats.sources_processed)
            2
            >>> print(stats.rows_extracted)
            150
        """
        self.sources_processed += 1
        self.rows_extracted += row_count
    
    def set_transformed(self, row_count):
        """Set the count of rows after transformation.
        
        Call this after the transformation phase.
        
        Args:
            row_count: Number of rows after transformation
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.rows_extracted = 150
            >>> 
            >>> # After transformation, some invalid rows removed
            >>> stats.set_transformed(140)
            >>> 
            >>> # 10 rows were lost in transformation
            >>> print(stats.rows_extracted - stats.rows_transformed)
            10
        """
        self.rows_transformed = row_count
    
    def set_loaded(self, row_count):
        """Set the count of rows successfully loaded.
        
        Call this after the load phase.
        
        Args:
            row_count: Number of rows loaded to destination
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.rows_transformed = 140
            >>> 
            >>> # All transformed rows loaded successfully
            >>> stats.set_loaded(140)
            >>> 
            >>> # Success rate will be 100%
            >>> print(stats.get_success_rate())
            100.0
        """
        self.rows_loaded = row_count
    
    def add_error(self, error):
        """Add an error to the error list.
        
        Call this whenever an error occurs.
        Can be a string message or a dict with details.
        
        Args:
            error: Error message (string) or error details (dict)
        
        Example:
            >>> stats = ETLStatistics()
            >>> 
            >>> # Add simple error message
            >>> stats.add_error("Failed to connect to database")
            >>> 
            >>> # Add detailed error dict
            >>> stats.add_error({
            ...     'phase': 'extract',
            ...     'source': 'CSV File',
            ...     'message': 'File not found'
            ... })
            >>> 
            >>> print(len(stats.errors))
            2
        """
        self.errors.append(error)
    
    def get_duration(self):
        """Calculate pipeline execution duration.
        
        Calculates the time difference between start and stop.
        
        Returns:
            float: Duration in seconds (e.g., 2.15 means 2.15 seconds)
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.start()
            # ... pipeline runs ...
            >>> stats.stop()
            >>> 
            >>> duration = stats.get_duration()
            >>> print(f"Pipeline took {duration:.2f} seconds")
            Pipeline took 2.15 seconds
        """
        if self.start_time and self.end_time:
            duration = self.end_time - self.start_time
            return duration.total_seconds()
        return 0
    
    def get_success_rate(self):
        """Calculate the success rate percentage.
        
        Success rate = (rows loaded / rows extracted) × 100
        
        Returns:
            float: Success rate percentage (0-100)
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.rows_extracted = 1000
            >>> stats.rows_loaded = 950
            >>> 
            >>> rate = stats.get_success_rate()
            >>> print(f"Success rate: {rate:.2f}%")
            Success rate: 95.00%
            >>> 
            >>> # If 0 extracted, return 0 (avoid division by zero)
            >>> stats2 = ETLStatistics()
            >>> print(stats2.get_success_rate())
            0.0
        """
        if self.rows_extracted == 0:
            return 0.0
        return (self.rows_loaded / self.rows_extracted) * 100
    
    def display(self):
        """Display comprehensive statistics report.
        
        Prints a beautifully formatted report showing:
        - Timing (start, end, duration)
        - Data flow (extracted, transformed, loaded, success rate)
        - Data loss (if any rows were rejected)
        - Errors (if any occurred)
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.start()
            >>> stats.add_source(1000)
            >>> stats.set_transformed(950)
            >>> stats.set_loaded(950)
            >>> stats.add_error("Warning: 50 rows had validation errors")
            >>> stats.stop()
            >>> 
            >>> stats.display()
            
            ======================================================================
            📊 ETL PIPELINE STATISTICS
            ======================================================================
            
            ⏱️  TIMING:
               Start: 2024-03-10 14:30:45
               End: 2024-03-10 14:30:47
               Duration: 2.15 seconds
            
            📈 DATA FLOW:
               Sources Processed: 1
               Rows Extracted: 1000
               Rows Transformed: 950
               Rows Loaded: 950
               Success Rate: 95.00%
            
            ⚠️  DATA LOSS:
               Rows Lost: 50 (5.00%)
            
            ❌ ERRORS (1):
               1. Warning: 50 rows had validation errors
            
            ======================================================================
        """
        print(f"\n{'='*70}")
        print(f"📊 ETL PIPELINE STATISTICS")
        print(f"{'='*70}")
        
        # TIMING SECTION
        print(f"\n⏱️  TIMING:")
        if self.start_time:
            print(f"   Start: {self.start_time.strftime('%Y-%m-%d %H:%M:%S')}")
        if self.end_time:
            print(f"   End: {self.end_time.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"   Duration: {self.get_duration():.2f} seconds")
        
        # DATA FLOW SECTION
        print(f"\n📈 DATA FLOW:")
        print(f"   Sources Processed: {self.sources_processed}")
        print(f"   Rows Extracted: {self.rows_extracted}")
        print(f"   Rows Transformed: {self.rows_transformed}")
        print(f"   Rows Loaded: {self.rows_loaded}")
        print(f"   Success Rate: {self.get_success_rate():.2f}%")
        
        # DATA LOSS SECTION (only if data was lost)
        if self.rows_extracted > self.rows_loaded:
            loss = self.rows_extracted - self.rows_loaded
            loss_percent = (loss / self.rows_extracted) * 100
            print(f"\n⚠️  DATA LOSS:")
            print(f"   Rows Lost: {loss} ({loss_percent:.2f}%)")
        
        # ERRORS SECTION
        if self.errors:
            print(f"\n❌ ERRORS ({len(self.errors)}):")
            # Show first 5 errors (avoid flooding console)
            for i, error in enumerate(self.errors[:5], 1):
                print(f"   {i}. {error}")
            
            # If more than 5 errors, show count
            if len(self.errors) > 5:
                print(f"   ... and {len(self.errors) - 5} more errors")
        else:
            print(f"\n✅ NO ERRORS!")
        
        print(f"{'='*70}\n")
    
    def __str__(self):
        """String representation (for print()).
        
        Special method that Python calls when you use print() or str().
        
        Returns a compact one-line summary.
        
        Returns:
            str: Compact statistics summary
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.rows_extracted = 1000
            >>> stats.rows_transformed = 950
            >>> stats.rows_loaded = 950
            >>> 
            >>> print(stats)
            ETL Statistics: 1000 extracted → 950 transformed → 950 loaded (95.0%)
            >>> 
            >>> # This is more readable than default:
            >>> # <ETLStatistics object at 0x7f8b4c5d6a90>
        """
        return (f"ETL Statistics: {self.rows_extracted} extracted → "
                f"{self.rows_transformed} transformed → "
                f"{self.rows_loaded} loaded ({self.get_success_rate():.1f}%)")
    
    def __repr__(self):
        """Developer representation (for debugging).
        
        Special method that Python calls when you need detailed
        object information (e.g., in debugger, Python shell).
        
        Returns a representation that could recreate the object.
        
        Returns:
            str: Developer-friendly representation
        
        Example:
            >>> stats = ETLStatistics()
            >>> stats.rows_extracted = 1000
            >>> stats.rows_transformed = 950
            >>> stats.rows_loaded = 950
            >>> 
            >>> # In Python shell or debugger:
            >>> stats
            ETLStatistics(extracted=1000, transformed=950, loaded=950)
            >>> 
            >>> # This helps developers see exact values
        """
        return (f"ETLStatistics(extracted={self.rows_extracted}, "
                f"transformed={self.rows_transformed}, "
                f"loaded={self.rows_loaded})")
```

### 📚 Using Statistics in Your Pipeline:

#### Example 1: Basic Usage
```python
# Create statistics collector
stats = ETLStatistics()

# Start timing
stats.start()

# Extract phase
data1 = extract_from_csv()  # Returns 100 rows
stats.add_source(len(data1))

data2 = extract_from_json()  # Returns 50 rows
stats.add_source(len(data2))

all_data = data1 + data2  # 150 rows total

# Transform phase
clean_data = clean_and_transform(all_data)  # Returns 140 rows (10 invalid removed)
stats.set_transformed(len(clean_data))

# Load phase
load_to_database(clean_data)
stats.set_loaded(len(clean_data))

# Stop timing
stats.stop()

# Display report
stats.display()
```

#### Example 2: With Error Tracking
```python
stats = ETLStatistics()
stats.start()

try:
    # Extract
    data = extract_from_source()
    stats.add_source(len(data))
    
except Exception as e:
    # Record the error
    stats.add_error(f"Extract failed: {str(e)}")
    stats.stop()
    stats.display()
    raise

try:
    # Transform
    clean_data = transform(data)
    stats.set_transformed(len(clean_data))
    
except Exception as e:
    stats.add_error(f"Transform failed: {str(e)}")
    stats.stop()
    stats.display()
    raise

# Continue with load...
stats.stop()
stats.display()
```

#### Example 3: Comparing Multiple Runs
```python
# Run 1
stats1 = ETLStatistics()
stats1.start()
# ... run pipeline ...
stats1.stop()

# Run 2
stats2 = ETLStatistics()
stats2.start()
# ... run pipeline again ...
stats2.stop()

# Compare
print(f"Run 1: {stats1}")
print(f"Run 2: {stats2}")

if stats1.get_duration() < stats2.get_duration():
    print("Run 1 was faster!")
else:
    print("Run 2 was faster!")
```

### 🎯 Why This Matters for Data Engineers:

**Production Monitoring:**
- Track pipeline performance over time
- Identify bottlenecks (which phase is slowest?)
- Monitor data quality (how many rows rejected?)
- Debug issues (what errors occurred?)

**SLA Compliance:**
- Prove pipelines meet performance requirements
- Document data loss percentages
- Generate audit reports

**Optimization:**
- Before optimization: Duration = 120 seconds
- After optimization: Duration = 45 seconds
- Improvement: 62.5% faster! 🚀

**Real-World Applications:**
- **Production Dashboards**: Display ETL statistics on monitoring dashboards
- **Alerting Systems**: Send alerts when success rate drops below threshold
- **Performance Tuning**: Identify slow sources/transformers and optimize them
- **Compliance Reporting**: Generate audit reports showing data processing metrics

---

```python
"""Statistics collector implementation (continued).

This section contains the actual ETLStatistics class code.
"""
from datetime import datetime


class ETLStatistics:
    """Collect and display ETL pipeline statistics."""
    # Implementation continues from the detailed explanations above
```

---

## 📝 Step 8: Main ETL Pipeline

### 🎯 What This Does:

**ETL Pipeline** is the CONDUCTOR of your orchestra! It coordinates all the pieces:

1. **Contains** all components (Composition pattern)
2. **Orchestrates** the flow (Extract → Transform → Load)
3. **Handles errors** gracefully
4. **Tracks statistics** automatically
5. **Logs** everything that happens

Think of it as the "main controller" that brings everything together!

### 💡 Why Orchestration Matters:

**Without Orchestra tion** (chaos):
```python
# Manually manage everything (error-prone!)
source1.connect()
data1 = source1.extract()
source1.disconnect()

source2.connect()
data2 = source2.extract()
source2.disconnect()

all_data = data1 + data2

clean_data = cleaner.transform(all_data)
enriched_data = enricher.transform(clean_data)
valid_data = validator.transform(enriched_data)

loader.connect()
loader.load(valid_data)
loader.disconnect()

# What if error occurs? No error handling!
# What about statistics? Manually track!
# What about logging? Manually log!
```

**With Orchestration** (organized):
```python
# Just build the pipeline and run!
pipeline = ETLPipeline("My ETL")
pipeline.add_source(source1)
pipeline.add_source(source2)
pipeline.set_transformation_pipeline(transform_pipeline)
pipeline.set_loader(loader)
pipeline.run()  # Everything happens automatically!

# ✅ Error handling: Built-in
# ✅ Statistics tracking: Automatic
# ✅ Logging: Automatic
# ✅ Clean code: Beautiful!
```

### 🔍 Code Explanation:

Create `src/pipeline.py`:

```python
"""Main ETL pipeline orchestration.

Demonstrates:
- Composition (pipeline contains sources, transformers, loaders)
- Orchestration (coordinates workflow)
- Error handling (try/except blocks)
- Integration (brings all components together)
"""

from src.logger import ETLLogger
from src.statistics import ETLStatistics


class ETLPipeline:
class ETLPipeline:
    """Main ETL pipeline that orchestrates the entire process.
    
    This is the CONDUCTOR of your ETL system!
    
    Composition (CONTAINS):
    - Multiple DataSources (can have CSV, JSON, API sources)
    - TransformationPipeline (contains transformers)
    - DataLoader (one output destination)
    - ETLLogger (tracks all operations)
    - ETLStatistics (measures performance)
    
    Orchestration (COORDINATES):
    - Extract phase: Get data from all sources
    - Transform phase: Clean and validate data
    - Load phase: Write to destination
    
    Error Handling:
    - Catches exceptions at each phase
    - Logs errors automatically
    - Returns success/failure status
    """
    
    def __init__(self, name):
        """Initialize ETL pipeline.
        
        Creates empty pipeline and initializes logger & statistics.
        
        Args:
            name: Pipeline name (for logging and display)
        
        Example:
            >>> pipeline = ETLPipeline("Brazilian Outdoor Platform ETL")
            
            ======================================================================
            🚀 ETL PIPELINE: Brazilian Outdoor Platform ETL
            ======================================================================
            
            📊 Statistics Collector initialized
        """
        self.name = name
        
        # Composition: Pipeline CONTAINS these components
        self.sources = []  # List of data sources (empty initially)
        self.transformation_pipeline = None  # Set later
        self.loader = None  # Set later
        
        # Automatic components
        self.logger = ETLLogger.get_instance()  # Singleton logger
        self.statistics = ETLStatistics()  # Statistics tracker
        
        print(f"\n{'='*70}")
        print(f"🚀 ETL PIPELINE: {name}")
        print(f"{'='*70}\n")
    
    def add_source(self, source):
        """Add data source to pipeline.
        
        You can add multiple sources - pipeline will extract from ALL of them.
        
        Args:
            source: DataSource object (CSVSource, JSONSource, APISource, etc.)
        
        Example:
            >>> pipeline = ETLPipeline("My ETL")
            >>> 
            >>> # Add multiple sources
            >>> pipeline.add_source(CSVSource("Campsites", "campsites.csv"))
            📂 CSV Source initialized: Campsites
               Added source: Campsites
            >>> 
            >>> pipeline.add_source(JSONSource("Bookings", "bookings.json"))
            📂 JSON Source initialized: Bookings
               Added source: Bookings
            >>> 
            >>> # Pipeline will extract from BOTH sources
            >>> print(len(pipeline.sources))
            2
        """
        self.sources.append(source)
        self.logger.info(f"Added source: {source.name}")
    
    def set_transformation_pipeline(self, transformation_pipeline):
        """Set transformation pipeline.
        
        The transformation pipeline contains all transformers
        (cleaning, enrichment, validation, etc.)
        
        Args:
            transformation_pipeline: TransformationPipeline object
        
        Example:
            >>> pipeline = ETLPipeline("My ETL")
            >>> 
            >>> # Create transformation pipeline
            >>> transform_pipeline = TransformationPipeline()
            >>> transform_pipeline.add_transformer(CleaningTransformer())
            >>> transform_pipeline.add_transformer(EnrichmentTransformer())
            >>> 
            >>> # Set it
            >>> pipeline.set_transformation_pipeline(transform_pipeline)
        """
        self.transformation_pipeline = transformation_pipeline
        self.logger.info(f"Set transformation pipeline")
    
    def set_loader(self, loader):
        """Set data loader.
        
        The loader determines WHERE data goes (file, database, S3, etc.)
        
        Args:
            loader: DataLoader object (FileLoader, DatabaseLoader, etc.)
        
        Example:
            >>> pipeline = ETLPipeline("My ETL")
            >>> 
            >>> # Option 1: File loader
            >>> loader = FileLoader("Output", "output.json", "json")
            >>> pipeline.set_loader(loader)
            📤 File Loader initialized: Output
            
            >>> # Option 2: Database loader
            >>> loader = DatabaseLoader("PostgreSQL", "host=localhost...")
            >>> pipeline.set_loader(loader)
            📤 Database Loader initialized: PostgreSQL
        """
        self.loader = loader
        self.logger.info(f"Set loader: {loader.name}")
    
    def run(self):
        """Run the complete ETL pipeline.
        
        This is the MAIN METHOD that executes everything:
        1. Starts timing
        2. Extract phase (get data from all sources)
        3. Transform phase (clean and validate)
        4. Load phase (write to destination)
        5. Display statistics
        6. Return success/failure
        
        Returns:
            bool: True if successful, False if failed
        
        Example:
            >>> pipeline = ETLPipeline("My ETL")
            >>> pipeline.add_source(csv_source)
            >>> pipeline.set_transformation_pipeline(transform_pipeline)
            >>> pipeline.set_loader(file_loader)
            >>> 
            >>> # Run it!
            >>> success = pipeline.run()
            
            ======================================================================
            📥 EXTRACT PHASE
            ======================================================================
            ... (extraction happens)
            
            ======================================================================
            🔄 EXECUTING TRANSFORMATION PIPELINE
            ======================================================================
            ... (transformation happens)
            
            ======================================================================
            📤 LOAD PHASE
            ======================================================================
            ... (loading happens)
            
            ======================================================================
            📊 ETL PIPELINE STATISTICS
            ======================================================================
            ... (statistics displayed)
            
            >>> print(success)
            True
        """
        self.logger.info(f"Starting ETL pipeline: {self.name}")
        self.statistics.start()
        
        try:
            # PHASE 1: EXTRACT
            all_data = self._extract_phase()
            
            # PHASE 2: TRANSFORM
            transformed_data = self._transform_phase(all_data)
            
            # PHASE 3: LOAD
            self._load_phase(transformed_data)
            
            # Success! Stop timing and display stats
            self.statistics.stop()
            self.statistics.display()
            
            self.logger.info(f"ETL pipeline completed successfully!")
            return True
        
        except Exception as e:
            # Failure! Log error, stop timing, display stats
            self.logger.error(f"ETL pipeline failed: {str(e)}")
            self.statistics.add_error(str(e))
            self.statistics.stop()
            self.statistics.display()
            return False
    
    def _extract_phase(self):
        """Extract data from all sources.
        
        Private method (starts with _) - called by run().
        
        Process:
        1. Loop through all sources
        2. For each source:
           - Connect
           - Extract data
           - Disconnect
           - Add to statistics
        3. If source fails, log error but continue with other sources
        4. Return combined data from all sources
        
        Returns:
            list: All extracted data (combined from all sources)
        
        Example:
            >>> # Internal method - you don't call this directly
            >>> # pipeline.run() calls this automatically
            >>> 
            >>> # But here's what happens inside:
            >>> all_data = pipeline._extract_phase()
            
            ======================================================================
            📥 EXTRACT PHASE
            ======================================================================
            
            📡 Connecting to CSV: campsites.csv...
            ✅ Connected to CSV file
            📖 Extracting data from CSV...
            ✅ Extracted 100 rows from CSV
            🔒 Disconnected from Campsites
            
            📡 Connecting to JSON: bookings.json...
            ✅ Connected to JSON file
            📖 Extracting data from JSON...
            ✅ Extracted 50 rows from JSON
            🔒 Disconnected from Bookings
            
            ✅ Extract phase complete: 150 total rows
        """
        print(f"\n{'='*70}")
        print(f"📥 EXTRACT PHASE")
        print(f"{'='*70}\n")
        
        all_data = []
        
        # Loop through each source
        for source in self.sources:
            try:
                self.logger.info(f"Extracting from: {source.name}")
                
                # Connect → Extract → Disconnect
                source.connect()
                data = source.extract()
                source.disconnect()
                
                # Add to combined data
                all_data.extend(data)
                
                # Track statistics
                self.statistics.add_source(len(data))
                
            except Exception as e:
                # Source failed, but continue with others
                self.logger.error(f"Failed to extract from {source.name}: {str(e)}")
                self.statistics.add_error(f"Extract error: {source.name} - {str(e)}")
        
        print(f"\n✅ Extract phase complete: {len(all_data)} total rows\n")
        return all_data
    
    def _transform_phase(self, data):
        """Transform data using transformation pipeline.
        
        Private method - called by run().
        
        Args:
            data: Raw data from extract phase
            
        Returns:
            list: Transformed data (cleaned, enriched, validated)
        
        Example:
            >>> # Internal method - called automatically by pipeline.run()
            >>> 
            >>> transformed = pipeline._transform_phase(raw_data)
            
            ======================================================================
            🔄 EXECUTING TRANSFORMATION PIPELINE
            ======================================================================
            Input rows: 150
            
            ⚙️  Applying transformation: Data Cleaning...
            ✅ Cleaned 150 rows
            
            ⚙️  Applying transformation: Data Enrichment...
            ✅ Enriched 150 rows
            
            ⚙️  Applying transformation: Data Validation...
            ✅ Validated 150 rows: 140 valid, 10 invalid
            
            Output rows: 140
            ======================================================================
        """
        if not self.transformation_pipeline:
            # No transformers set - just pass data through
            self.logger.warning("No transformation pipeline set, skipping transform phase")
            return data
        
        try:
            self.logger.info("Starting transformation phase")
            
            # Execute transformation pipeline
            transformed_data = self.transformation_pipeline.execute(data)
            
            # Track statistics
            self.statistics.set_transformed(len(transformed_data))
            
            return transformed_data
        
        except Exception as e:
            # Transformation failed - this is critical, so raise error
            self.logger.error(f"Transformation failed: {str(e)}")
            self.statistics.add_error(f"Transform error: {str(e)}")
            raise  # Re-raise exception (pipeline will catch it)
    
    def _load_phase(self, data):
        """Load data to destination.
        
        Private method - called by run().
        
        Args:
            data: Transformed data ready to load
        
        Example:
            >>> # Internal method - called automatically by pipeline.run()
            >>> 
            >>> pipeline._load_phase(transformed_data)
            
            ======================================================================
            📤 LOAD PHASE
            ======================================================================
            
            📡 Preparing file output: output.json...
            ✅ Ready to write to file
            💾 Loading 140 rows to JSON file...
            ✅ Loaded 140 rows to file
            🔒 Disconnected from Output
            
            ✅ Load phase complete
        """
        if not self.loader:
            # No loader set - critical error!
            raise Exception("No loader set! Call set_loader() before run()")
        
        print(f"\n{'='*70}")
        print(f"📤 LOAD PHASE")
        print(f"{'='*70}\n")
        
        try:
            self.logger.info(f"Loading to: {self.loader.name}")
            
            # Connect → Load → Disconnect
            self.loader.connect()
            self.loader.load(data)
            self.loader.disconnect()
            
            # Track statistics
            self.statistics.set_loaded(self.loader.get_loaded_count())
            
            print(f"\n✅ Load phase complete\n")
        
        except Exception as e:
            # Load failed - critical error
            self.logger.error(f"Load failed: {str(e)}")
            self.statistics.add_error(f"Load error: {str(e)}")
            raise  # Re-raise exception (pipeline will catch it)
    
    def __str__(self):
        """String representation (special method).
        
        Example:
            >>> pipeline = ETLPipeline("My ETL")
            >>> pipeline.add_source(source1)
            >>> pipeline.add_source(source2)
            >>> 
            >>> print(pipeline)
            ETL Pipeline: My ETL (2 sources)
        """
        return f"ETL Pipeline: {self.name} ({len(self.sources)} sources)"
```

### 📚 Complete Pipeline Example:

```python
"""
Complete example showing how to build and run an ETL pipeline.
"""

# Step 1: Create pipeline
pipeline = ETLPipeline("Brazilian Outdoor Platform ETL")

# Step 2: Add data sources (can add multiple!)
campsites_source = CSVSource("Campsites", "data/campsites.csv")
bookings_source = JSONSource("Bookings", "data/bookings.json")
customers_source = CSVSource("Customers", "data/customers.csv")

pipeline.add_source(campsites_source)
pipeline.add_source(bookings_source)
pipeline.add_source(customers_source)

# Step 3: Create transformation pipeline
transform_pipeline = TransformationPipeline()
transform_pipeline.add_transformer(CleaningTransformer())
transform_pipeline.add_transformer(EnrichmentTransformer())

# Add validators
validators = {
    'name': RequiredFieldValidator('name'),
    'state': StateValidator(),
    'price': NumericRangeValidator('price', 0, 10000)
}
transform_pipeline.add_transformer(ValidationTransformer(validators))

pipeline.set_transformation_pipeline(transform_pipeline)

# Step 4: Create and set loader
loader = FileLoader("Output", "data/output/processed.json", "json")
pipeline.set_loader(loader)

# Step 5: RUN IT!
success = pipeline.run()

if success:
    print("✅ Pipeline completed successfully!")
else:
    print("❌ Pipeline failed!")
```

### 🎯 Error Handling Examples:

#### Example 1: Source Fails (Pipeline Continues)
```python
# If one source fails, pipeline continues with others
pipeline = ETLPipeline("My ETL")
pipeline.add_source(CSVSource("Good", "exists.csv"))  # Works
pipeline.add_source(CSVSource("Bad", "missing.csv"))  # Fails
pipeline.add_source(JSONSource("OK", "data.json"))    # Works

# Run pipeline
success = pipeline.run()

# Result: Extracts from "Good" and "OK", logs error for "Bad"
# Pipeline still completes successfully!
```

#### Example 2: Transform Fails (Pipeline Stops)
```python
# If transformation fails, pipeline stops (critical error)
pipeline = ETLPipeline("My ETL")
pipeline.add_source(source)

# Broken transformer (will cause error)
class BrokenTransformer(DataTransformer):
    def transform(self, data):
        raise Exception("Something went wrong!")

transform_pipeline = TransformationPipeline()
transform_pipeline.add_transformer(BrokenTransformer())
pipeline.set_transformation_pipeline(transform_pipeline)

# Run pipeline
success = pipeline.run()

# Result: Extraction succeeds, transformation fails, loading never happens
# success = False
```

#### Example 3: No Loader Set (Immediate Error)
```python
# Forgot to set loader
pipeline = ETLPipeline("My ETL")
pipeline.add_source(source)
pipeline.set_transformation_pipeline(transform_pipeline)
# Oops! Didn't call pipeline.set_loader()

# Run pipeline
success = pipeline.run()

# Result: Exception raised: "No loader set! Call set_loader() before run()"
# success = False
```

### 🔍 Why This Design Works:

**1. Composition Over Inheritance:**
- Pipeline CONTAINS components (doesn't inherit from them)
- Flexible: Swap any component without changing pipeline code
- Reusable: Same pipeline class works for ANY combination of sources/loaders

**2. Single Responsibility:**
- Pipeline only orchestrates (doesn't do actual work)
- Sources handle extraction
- Transformers handle transformation
- Loaders handle loading
- Each class has ONE job

**3. Error Handling Strategy:**
- Source failures: Log and continue (non-critical)
- Transform failures: Stop pipeline (critical - bad data shouldn't be loaded)
- Load failures: Stop pipeline (critical - can't complete job)

**4. Automatic Features:**
- Logging: Happens automatically
- Statistics: Tracked automatically
- Error reporting: Built-in
- Clean code: Just call run()!

**5. Real-World Deployment:**
- **Development**: Run manually for testing
- **Staging**: Schedule hourly via cron for validation
- **Production**: Schedule daily/hourly via Airflow/cron for live data processing

---

```python
"""Pipeline implementation (continued).

This section contains the actual ETLPipeline class code.
"""
from src.logger import ETLLogger
from src.statistics import ETLStatistics


class ETLPipeline:
    """Main ETL pipeline orchestrator."""
    # Implementation continues from the detailed explanations above
```

---

## 📝 Step 9: Main Application

### 🎯 What This Does:

**Main Application (`main.py`)** is the ENTRY POINT - where you bring ALL the pieces together and run your ETL system!

This is like the "main stage" where all your actors (sources, transformers, loaders) perform together in a coordinated show!

**What it does:**
1. Loads configuration from file
2. Initializes logger
3. Creates all data sources
4. Creates all validators
5. Builds transformation pipeline
6. Creates data loader
7. Assembles complete ETL pipeline
8. RUNS the pipeline!
9. Reports success or failure

### 💡 Why This Matters:

**Without main.py** (scattered code):
```python
# You'd have code scattered everywhere!
# Hard to understand
# Hard to modify
# Hard to run

# In notebook cell 1:
config = ConfigurationManager('config.json')

# In notebook cell 5:
source = CSVSource("data.csv")

# In notebook cell 12:
loader = FileLoader("output.json")

# Where's the pipeline? How do I run it? 🤷
```

**With main.py** (organized):
```python
# Everything in ONE place
# Clear flow from start to finish
# Easy to understand
# Easy to run: python main.py

def main():
    # Step 1: Config
    # Step 2: Logger
    # Step 3: Sources
    # ... etc
    # Step 8: RUN!
```

### 🔍 Code Explanation:

Create `main.py`:

```python
"""Main ETL application entry point.

This file is the STARTING POINT of your ETL system.
When you run `python main.py`, this is what executes!

Structure:
1. Imports: All the components we built
2. main() function: Orchestrates everything
3. if __name__ == "__main__": Entry point
"""

from pathlib import Path

# Import our custom components
from src.config_manager import ConfigurationManager
from src.logger import ETLLogger
from src.sources import CSVSource, JSONSource
from src.transformers import (
    CleaningTransformer, 
    EnrichmentTransformer, 
    ValidationTransformer,
    TransformationPipeline
)
from src.validators import (
    RequiredFieldValidator,
    NumericRangeValidator,
    StateValidator
)
from src.loaders import FileLoader, DatabaseLoader
from src.pipeline import ETLPipeline


def main():
    """Main function that runs the entire ETL system.
    
    This function follows a clear sequence:
    1. Load configuration
    2. Set up logging
    3. Create data sources
    4. Create validators
    5. Build transformation pipeline
    6. Create loader
    7. Assemble ETL pipeline
    8. RUN the pipeline!
    9. Report results
    
    Think of this as your "recipe" - follow steps in order!
    
    Example:
        >>> # Run from command line:
        >>> # python main.py
        >>> 
        >>> # Or call from Python:
        >>> main()
        
        ======================================================================
        🚀 BRAZILIAN OUTDOOR PLATFORM - ETL SYSTEM
        ======================================================================
        
        📋 Step 1: Loading Configuration...
        ... (loads config)
        
        📋 Step 2: Initializing Logger...
        ... (sets up logging)
        
        ... (continues through all steps)
        
        ======================================================================
        ✅ ETL PIPELINE COMPLETED SUCCESSFULLY!
        ======================================================================
    """
    
    # Welcome banner
    print("\n" + "="*70)
    print("🚀 BRAZILIAN OUTDOOR PLATFORM - ETL SYSTEM")
    print("="*70 + "\n")
    
    # ========================================================================
    # STEP 1: LOAD CONFIGURATION
    # ========================================================================
    print("📋 Step 1: Loading Configuration...")
    
    # Create config manager and load settings from JSON file
    config = ConfigurationManager('config/etl_config.json')
    config.load()
    config.display()
    
    # Why? Centralized configuration means:
    # - No hardcoded values in code
    # - Easy to change settings without modifying code
    # - Can have different configs for dev/test/prod
    
    # ========================================================================
    # STEP 2: INITIALIZE LOGGER
    # ========================================================================
    print("📋 Step 2: Initializing Logger...")
    
    # Get logging configuration from config file
    logger_config = config.logging_config
    
    # Create logger (singleton - only one logger for entire system)
    logger = ETLLogger(
        log_file=logger_config.get('file', 'logs/etl.log'),
        level=logger_config.get('level', 'INFO')
    )
    
    # Log that system started
    logger.info("ETL System started")
    
    # Why? Professional logging means:
    # - Track what happens during execution
    # - Debug issues when they occur
    # - Audit trail for compliance
    # - Monitor system health
    
    # ========================================================================
    # STEP 3: CREATE DATA SOURCES
    # ========================================================================
    print("\n📋 Step 3: Creating Data Sources...")
    
    # Get sources configuration
    sources_config = config.sources_config
    
    # List to hold all sources
    sources = []
    
    # CSV Source: Campsites
    # Only create if configured in config file
    if 'campsites' in sources_config:
        campsites_source = CSVSource(
            name="Campsites",
            file_path=sources_config['campsites']
        )
        sources.append(campsites_source)
    
    # JSON Source: Bookings
    if 'bookings' in sources_config:
        bookings_source = JSONSource(
            name="Bookings",
            file_path=sources_config['bookings']
        )
        sources.append(bookings_source)
    
    # CSV Source: Customers
    if 'customers' in sources_config:
        customers_source = CSVSource(
            name="Customers",
            file_path=sources_config['customers']
        )
        sources.append(customers_source)
    
    # Why configuration-driven sources?
    # - Add/remove sources by changing config file
    # - No code changes needed
    # - Flexible and maintainable
    
    # ========================================================================
    # STEP 4: CREATE VALIDATORS
    # ========================================================================
    print("\n📋 Step 4: Creating Validators...")
    
    # Create validators for data quality
    # Each validator checks a specific field
    validators = {
        'name': RequiredFieldValidator('name'),  # Name cannot be empty
        'state': StateValidator(),  # State must be valid Brazilian state
        'price': NumericRangeValidator('price', min_value=0, max_value=10000)  # Price 0-10000
    }
    
    # Why validators?
    # - Ensure data quality before loading
    # - Catch bad data early
    # - Prevent garbage data in your database
    
    # ========================================================================
    # STEP 5: CREATE TRANSFORMATION PIPELINE
    # ========================================================================
    print("\n📋 Step 5: Creating Transformation Pipeline...")
    
    # Create transformation pipeline
    transform_pipeline = TransformationPipeline()
    
    # Add transformers in ORDER (they execute sequentially!)
    # 1. Clean first (remove whitespace, nulls)
    transform_pipeline.add_transformer(CleaningTransformer())
    
    # 2. Enrich second (add metadata, timestamps)
    transform_pipeline.add_transformer(EnrichmentTransformer())
    
    # 3. Validate last (check data quality)
    transform_pipeline.add_transformer(ValidationTransformer(validators))
    
    # Why this order?
    # - Clean data first (remove obvious issues)
    # - Enrich with metadata (add useful info)
    # - Validate last (check final quality)
    
    # ========================================================================
    # STEP 6: CREATE DATA LOADER
    # ========================================================================
    print("\n📋 Step 6: Creating Data Loader...")
    
    # Get output configuration
    output_config = config.output_config
    
    # Option 1: File Loader (default)
    # Saves data to JSON or CSV file
    loader = FileLoader(
        name="Output File",
        output_file=Path(output_config.get('directory', 'data/output/processed')) / 'processed_data.json',
        file_format=output_config.get('format', 'json')
    )
    
    # Option 2: Database Loader (commented out)
    # Uncomment these lines to load to PostgreSQL instead of file:
    # 
    # db_config = config.database_config
    # loader = DatabaseLoader(
    #     name="PostgreSQL Database",
    #     connection_string=f"host={db_config['host']} dbname={db_config['database']}"
    # )
    
    # Why flexible loader?
    # - Easy to switch between file/database/S3/API
    # - Same pipeline code works with ANY loader
    # - Change destination without changing logic
    
    # ========================================================================
    # STEP 7: BUILD ETL PIPELINE
    # ========================================================================
    print("\n📋 Step 7: Building ETL Pipeline...")
    
    # Create the main ETL pipeline
    pipeline = ETLPipeline("Brazilian Outdoor Platform ETL")
    
    # Add all sources to pipeline
    # Pipeline will extract from ALL of them
    for source in sources:
        pipeline.add_source(source)
    
    # Set transformation pipeline
    # All extracted data goes through these transformations
    pipeline.set_transformation_pipeline(transform_pipeline)
    
    # Set loader
    # Transformed data gets loaded here
    pipeline.set_loader(loader)
    
    # Why build like this?
    # - Clear, readable code
    # - Easy to modify (add/remove sources, change loader, etc.)
    # - Reusable pattern
    
    # ========================================================================
    # STEP 8: RUN THE PIPELINE!
    # ========================================================================
    print("\n📋 Step 8: Running ETL Pipeline...")
    
    # This ONE line does EVERYTHING:
    # - Extracts from all sources
    # - Transforms the data
    # - Loads to destination
    # - Handles errors
    # - Tracks statistics
    # - Logs all operations
    success = pipeline.run()
    
    # Magic! 🪄
    
    # ========================================================================
    # STEP 9: FINAL REPORT
    # ========================================================================
    print("\n" + "="*70)
    if success:
        print("✅ ETL PIPELINE COMPLETED SUCCESSFULLY!")
        logger.info("ETL pipeline completed successfully")
    else:
        print("❌ ETL PIPELINE FAILED!")
        logger.error("ETL pipeline failed")
    print("="*70 + "\n")
    
    # Log that system finished
    logger.info("ETL System finished")


# ============================================================================
# ENTRY POINT
# ============================================================================
if __name__ == "__main__":
    """Entry point when script is run directly.
    
    This special block only runs when you execute:
    $ python main.py
    
    It does NOT run when you import this file as a module.
    
    Why? Allows file to be both:
    - Executable script: python main.py
    - Importable module: from main import main
    """
    
    try:
        # Run the main function
        main()
        
    except KeyboardInterrupt:
        # User pressed Ctrl+C
        print("\n\n⚠️  Pipeline interrupted by user")
        print("Cleaning up and exiting gracefully...\n")
        
    except Exception as e:
        # Unexpected error occurred
        print(f"\n\n❌ Fatal error: {str(e)}")
        print("\nFull error details:")
        
        # Print full stack trace for debugging
        import traceback
        traceback.print_exc()
        
        print("\nPlease check:")
        print("  1. Configuration file exists and is valid JSON")
        print("  2. Input data files exist")
        print("  3. Output directory has write permissions")
        print("  4. All required Python modules are imported\n")
```

### 📚 Customization Examples:

#### Example 1: Adding More Sources
```python
# In Step 3, add more sources:

# API Source: Weather Data
if 'weather' in sources_config:
    weather_source = APISource(
        name="Weather API",
        base_url=sources_config['weather']['url'],
        endpoint=sources_config['weather']['endpoint'],
        api_key=sources_config['weather']['api_key']
    )
    sources.append(weather_source)

# Excel Source: Equipment Data
if 'equipment' in sources_config:
    equipment_source = ExcelSource(
        name="Equipment",
        file_path=sources_config['equipment']
    )
    sources.append(equipment_source)
```

#### Example 2: Adding More Validators
```python
# In Step 4, add more validators:

validators = {
    'name': RequiredFieldValidator('name'),
    'state': StateValidator(),
    'price': NumericRangeValidator('price', 0, 10000),
    
    # NEW validators:
    'email': EmailValidator(),  # Validate email format
    'phone': PhoneValidator(),  # Validate Brazilian phone format
    'check_in': DateValidator('check_in'),  # Validate date format
    'cpf': CPFValidator(),  # Validate Brazilian CPF
}
```

#### Example 3: Adding More Transformers
```python
# In Step 5, add more transformers:

transform_pipeline.add_transformer(CleaningTransformer())
transform_pipeline.add_transformer(TypeConversionTransformer({
    'price': float,
    'capacity': int,
    'has_wifi': bool
}))  # NEW: Convert data types
transform_pipeline.add_transformer(DeduplicationTransformer(['id']))  # NEW: Remove duplicates
transform_pipeline.add_transformer(EnrichmentTransformer())
transform_pipeline.add_transformer(ValidationTransformer(validators))
```

#### Example 4: Switching to Database Loader
```python
# In Step 6, use database instead of file:

# Comment out file loader:
# loader = FileLoader("Output", "output.json", "json")

# Uncomment database loader:
db_config = config.database_config
loader = PostgreSQLLoader(
    name="PostgreSQL",
    config=db_config,
    table_name="processed_campsites"
)
```

#### Example 5: Command-Line Arguments
```python
"""Add command-line arguments for flexibility."""

import argparse

def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='Run ETL pipeline')
    parser.add_argument('--config', default='config/etl_config.json', 
                       help='Path to config file')
    parser.add_argument('--output-format', choices=['json', 'csv'], 
                       default='json', help='Output format')
    parser.add_argument('--dry-run', action='store_true', 
                       help='Run without actually loading data')
    args = parser.parse_args()
    
    # Use arguments
    config = ConfigurationManager(args.config)
    config.load()
    
    # ... rest of setup ...
    
    if args.dry_run:
        print("DRY RUN MODE - No data will be loaded")
        # Skip load phase
    
    # ... run pipeline ...

# Run with arguments:
# python main.py --config prod_config.json --output-format csv
# python main.py --dry-run
```

### 🎯 Why This Structure Works:

**1. Clear Flow:**
- Read code top-to-bottom
- Each step builds on previous
- Easy to understand what happens when

**2. Configuration-Driven:**
- Change behavior via config file
- No code changes needed for most adjustments
- Easy to maintain

**3. Error Handling:**
- Catches Ctrl+C gracefully
- Catches unexpected errors
- Provides helpful error messages

**4. Professional:**
- Logging for audit trail
- Statistics for monitoring
- Clean output formatting

**5. Flexible:**
- Easy to add more sources
- Easy to add more transformers
- Easy to switch loader type

### 🚀 Running Your ETL System:

```bash
# Basic run
python main.py

# With different config
python main.py --config prod_config.json

# Dry run (test without loading)
python main.py --dry-run

# Schedule to run periodically
# Add to crontab:
# 0 2 * * * cd /path/to/etl_system && python main.py
```

**Production Deployment Tips:**
- Use virtual environments for dependency isolation
- Store config files outside version control (use environment variables for secrets)
- Implement logging rotation to prevent disk space issues
- Set up monitoring alerts for pipeline failures
- Use scheduling tools like Airflow for enterprise-grade orchestration

---

```python
"""Main application implementation (continued).

The actual main.py code is shown in the detailed explanation above.
This marker separates examples from the implementation section.
"""
```

---

## 📝 Step 10: Sample Data Files

### Create `data/input/campsites.csv`:

```csv
id,name,state,city,price,capacity,has_wifi
1,Serra Verde Camp,MG,Ouro Preto,120.50,50,true
2,Praia do Rosa Camp,SC,Imbituba,95.00,30,false
3,Chapada Camp,BA,Lençóis,85.00,40,true
4,Mountain View,RJ,Petrópolis,150.00,25,true
5,   Eco Camp   ,SP,Brotas,110.00,35,false
6,Invalid Camp,,Invalid City,-50,100,true
```

### Create `data/input/bookings.json`:

```json
[
  {
    "booking_id": 1,
    "campsite_id": 1,
    "customer_name": "João Silva",
    "check_in": "2024-03-15",
    "check_out": "2024-03-17",
    "guests": 4
  },
  {
    "booking_id": 2,
    "campsite_id": 2,
    "customer_name": "Maria Santos",
    "check_in": "2024-04-01",
    "check_out": "2024-04-05",
    "guests": 2
  },
  {
    "booking_id": 3,
    "campsite_id": 3,
    "customer_name": "",
    "check_in": "invalid-date",
    "check_out": "2024-05-10",
    "guests": 6
  }
]
```

### Create `data/input/customers.csv`:

```csv
id,name,email,state,phone
1,João Silva,joao@email.com,MG,11999998888
2,Maria Santos,maria@email.com,SC,21988887777
3,Pedro Costa,pedro@email.com,BA,31977776666
4,   Ana Lima   ,ana@email.com,RJ,41966665555
5,,invalid@email,ZZ,51955554444
```

---

## 📝 Step 11: Project Setup & Execution

### 1. Create Project Structure:

```bash
# Create project directory
mkdir -p etl_system

# Navigate to project
cd etl_system

# Create subdirectories
mkdir -p config data/input data/output/processed logs src

# Create __init__.py
touch src/__init__.py
```

### 2. Create requirements.txt:

```text
# No external dependencies needed for basic version!
# All using Python standard library

# Optional (for database connectivity):
# psycopg2-binary==2.9.9
# sqlalchemy==2.0.23
```

### 3. Copy Code Files:

Copy all the code from Steps 1-9 into their respective files:
- `src/config_manager.py`
- `src/logger.py`
- `src/sources.py`
- `src/validators.py`
- `src/transformers.py`
- `src/loaders.py`
- `src/statistics.py`
- `src/pipeline.py`
- `main.py`

### 4. Create Sample Data:

Copy the sample CSV and JSON files to `data/input/`

### 5. Run the ETL Pipeline:

```bash
python main.py
```

---

## 📊 Expected Output

You should see output like this:

```
======================================================================
🚀 BRAZILIAN OUTDOOR PLATFORM - ETL SYSTEM
======================================================================

📋 Step 1: Loading Configuration...
⚙️  Configuration Manager initialized
   Config file: config/etl_config.json
📖 Loading configuration...
✅ Configuration loaded!

======================================================================
⚙️  ETL CONFIGURATION
======================================================================
Config File: config/etl_config.json
Loaded At: 2024-03-10 14:30:45.123456
Modified: No

[database]
  host: localhost
  port: 5432
  database: camping_db
  user: postgres
  password: ***HIDDEN***
...

======================================================================
📥 EXTRACT PHASE
======================================================================

📡 Connecting to CSV: data/input/campsites.csv...
✅ Connected to CSV file
📖 Extracting data from CSV...
✅ Extracted 6 rows from CSV
🔒 Disconnected from Campsites

📡 Connecting to JSON: data/input/bookings.json...
✅ Connected to JSON file
📖 Extracting data from JSON...
✅ Extracted 3 records from JSON
🔒 Disconnected from Bookings

✅ Extract phase complete: 15 total rows

======================================================================
🔄 EXECUTING TRANSFORMATION PIPELINE
======================================================================
Input rows: 15

⚙️  Applying transformation: Data Cleaning...
✅ Cleaned 15 rows

⚙️  Applying transformation: Data Enrichment...
✅ Enriched 15 rows

⚙️  Applying transformation: Data Validation...
✅ Validated 15 rows: 12 valid, 3 invalid

Output rows: 12
======================================================================

======================================================================
📤 LOAD PHASE
======================================================================

📡 Preparing file output: data/output/processed/processed_data.json...
✅ Ready to write to file
💾 Loading 12 rows to JSON file...
✅ Loaded 12 rows to file
🔒 Disconnected from Output File

✅ Load phase complete

======================================================================
📊 ETL PIPELINE STATISTICS
======================================================================

⏱️  TIMING:
   Start: 2024-03-10 14:30:45
   End: 2024-03-10 14:30:47
   Duration: 2.15 seconds

📈 DATA FLOW:
   Sources Processed: 3
   Rows Extracted: 15
   Rows Transformed: 12
   Rows Loaded: 12
   Success Rate: 80.00%

⚠️  DATA LOSS:
   Rows Lost: 3 (20.00%)

❌ ERRORS (3):
   1. {'row': 6, 'field': 'state', 'value': '', 'error': 'State is required'}
   2. {'row': 6, 'field': 'price', 'value': '-50', 'error': 'price must be >= 0'}
   3. {'row': 11, 'field': 'name', 'value': '', 'error': 'name is required'}

======================================================================

======================================================================
✅ ETL PIPELINE COMPLETED SUCCESSFULLY!
======================================================================
```

---

## 🎯 Learning Objectives Check

After completing this project, verify you understand:

### ✅ Classes and Objects:
- [ ] Created multiple classes (`ConfigurationManager`, `ETLLogger`, etc.)
- [ ] Instantiated objects from classes
- [ ] Used `self` parameter correctly

### ✅ Inheritance:
- [ ] Created abstract base classes (`DataSource`, `DataValidator`, `DataLoader`)
- [ ] Implemented child classes (`CSVSource`, `JSONSource`, `FileLoader`)
- [ ] Used `super()` to call parent methods
- [ ] Understood `@abstractmethod` decorator

### ✅ Encapsulation:
- [ ] Used private attributes (`__config`, `__config_file`)
- [ ] Created property decorators (`@property`)
- [ ] Hid sensitive data (passwords)

### ✅ Polymorphism:
- [ ] Created multiple classes with same interface
- [ ] ETL pipeline works with ANY source type
- [ ] ETL pipeline works with ANY loader type
- [ ] Validators are interchangeable

### ✅ Special Methods:
- [ ] Implemented `__str__()` and `__repr__()`
- [ ] Implemented `__len__()` for DataSource
- [ ] Used `__new__()` for singleton pattern (logger)

### ✅ Composition:
- [ ] ETL Pipeline contains sources, transformers, loaders
- [ ] TransformationPipeline contains multiple transformers
- [ ] Components work together

---

## 🚀 Enhancement Ideas

Want to take it further? Try these enhancements with complete implementations!

---

## 📘 Level 1: Beginner Enhancements

### Enhancement 1.1: Email Validator

**🎯 What It Does:**
Validates email addresses using regex pattern matching to ensure they follow standard email format (e.g., `user@domain.com`).

**💡 Why It Matters:**
- **Data Quality**: Ensures valid email format before loading to database
- **Business Rules**: Prevents sending emails to invalid addresses (failed deliveries cost money)
- **Common Requirement**: Almost every application collects email addresses

---

#### � Complete Implementation with Line-by-Line Explanation

Add to `src/validators.py`:

```python
import re  # Import regex library for pattern matching
```

**🔍 Why we import `re`:**
- `re` is Python's Regular Expression library
- Allows pattern matching (checking if text follows a specific format)
- Much cleaner than manually checking each character

---

#### Part 1: Define the Email Pattern (Regex)

```python
class EmailValidator(DataValidator):
    """Validate email addresses.
    
    Checks:
    - Has @ symbol
    - Has domain
    - Has valid characters
    - Follows standard email format
    """
    
    # Email regex pattern (simplified but effective)
    EMAIL_PATTERN = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
```

**🔍 Let's break down the regex pattern piece by piece:**

```
r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
│  │                 ││              ││ │           │
│  │                 ││              ││ │           └─ $ = End of string
│  │                 ││              ││ └─ {2,} = At least 2 letters (.com, .co.uk, etc.)
│  │                 ││              │└─ \. = Literal dot (escape because . is special in regex)
│  │                 ││              └─ [a-zA-Z0-9.-]+ = Domain (letters, numbers, dots, hyphens)
│  │                 │└─ @ = Literal @ symbol (required in emails)
│  │                 └─ + = One or more characters
│  └─ [a-zA-Z0-9._%+-] = Username can contain: letters, numbers, dots, underscores, %, +, -
└─ r' ' = Raw string (backslashes treated literally)
  ^ = Start of string
```

**Examples that MATCH this pattern:**
- ✅ `user@example.com` → Simple email
- ✅ `john.doe@company.co.uk` → Has dot in username and multi-part domain
- ✅ `name+tag@domain.org` → Has plus sign (used for email filters)
- ✅ `test_user@sub.domain.com` → Has underscore and subdomain

**Examples that DON'T match:**
- ❌ `notanemail` → No @ symbol
- ❌ `user@` → No domain
- ❌ `@example.com` → No username
- ❌ `user @domain.com` → Has space (not in allowed characters)
- ❌ `user@.com` → Domain starts with dot

---

#### Part 2: Initialize the Validator

```python
    def __init__(self):
        """Initialize email validator.
        
        Example:
            >>> validator = EmailValidator()
            ✓ EmailValidator initialized
        """
        super().__init__("email")  # Call parent class constructor
        self.pattern = re.compile(self.EMAIL_PATTERN)  # Compile regex for efficiency
```

**🔍 Line-by-line breakdown:**

**Line 1:** `super().__init__("email")`
- `super()` = Call the parent class (`DataValidator`)
- `__init__("email")` = Initialize parent with field name "email"
- This sets up `self.field_name = "email"` and counters in the parent class

**Line 2:** `self.pattern = re.compile(self.EMAIL_PATTERN)`
- `re.compile()` = Convert string pattern to compiled regex object
- **Why compile?** Much faster when validating many emails (compiled once, used many times)
- Without compile: Pattern re-parsed every time
- With compile: Pattern parsed once, reused efficiently

**Think of it like:**
- Without compile = Reading recipe every time you cook
- With compile = Memorizing recipe once, cooking faster each time

---

#### Part 3: Validation Logic

```python
    def validate(self, value):
        """Validate email format.
        
        Args:
            value: Email address to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Example:
            >>> validator = EmailValidator()
            >>> 
            >>> # Valid email
            >>> valid, msg = validator.validate("user@example.com")
            >>> print(valid)
            True
            >>> 
            >>> # Invalid email
            >>> valid, msg = validator.validate("invalid.email")
            >>> print(valid, msg)
            False email must be a valid email address
        """
        self.validation_count += 1  # Track how many validations we've done
        
        # Convert to string and strip whitespace
        email = str(value).strip() if value else ""
        
        # Check if matches pattern
        if self.pattern.match(email):
            return True, None  # Valid: return success with no error message
        
        self.error_count += 1  # Track validation failures
        return False, f"{self.field_name} must be a valid email address"
```

**🔍 Line-by-line breakdown:**

**Line 1:** `self.validation_count += 1`
- Increment counter (inherited from `DataValidator`)
- Tracks total validations performed
- Useful for statistics: "Validated 1,000 emails"

**Line 2:** `email = str(value).strip() if value else ""`
- `str(value)` = Convert to string (in case it's a number or None)
- `.strip()` = Remove leading/trailing whitespace
- `if value else ""` = If value is None or empty, use empty string
- **Why?** Prevents errors if someone passes `None` or `123` instead of a string

**Examples:**
```python
value = "  user@example.com  "  →  email = "user@example.com"
value = None                     →  email = ""
value = 123                      →  email = "123"
```

**Line 3:** `if self.pattern.match(email):`
- `self.pattern` = Our compiled regex pattern
- `.match(email)` = Check if email matches the pattern
- Returns `Match object` if matches, `None` if doesn't match
- `if Match object:` = Evaluates to `True` (email is valid)
- `if None:` = Evaluates to `False` (email is invalid)

**Line 4:** `return True, None`
- Email is valid!
- Return `True` (validation passed)
- Return `None` (no error message needed)

**Line 5:** `self.error_count += 1`
- Email is invalid
- Increment error counter
- Useful for statistics: "Found 25 invalid emails out of 1,000"

**Line 6:** `return False, f"{self.field_name} must be a valid email address"`
- Return `False` (validation failed)
- Return error message: "email must be a valid email address"
- `f"{self.field_name}"` = Uses the field name from initialization

---

#### Part 4: How to Use It

```python
# In main.py:
validators = {
    'name': RequiredFieldValidator('name'),
    'email': EmailValidator(),  # NEW: Email validation
    'state': StateValidator(),
}
```

**🔍 Integration with existing code:**

This plugs directly into your validation pipeline from Step 4:

```python
# Example row from your data
row = {
    'name': 'João Silva',
    'email': 'joao@example.com',  # Will be validated
    'state': 'MG'
}

# Validation happens automatically in the pipeline
for field_name, validator in validators.items():
    value = row.get(field_name)
    is_valid, error_msg = validator.validate(value)
    
    if not is_valid:
        print(f"❌ {error_msg}")
    # For email field:
    # is_valid = True (joao@example.com is valid)
```

---

#### 📊 Test Cases with Expected Results

```python
# Test the EmailValidator
validator = EmailValidator()

# Valid emails (should all return True, None)
test_cases_valid = [
    "user@example.com",           # Standard format
    "john.doe@company.co.uk",     # Dot in username, multi-part domain
    "name+tag@domain.com",        # Plus sign (Gmail filters)
    "test.email@sub.domain.org"   # Subdomain
]

# Invalid emails (should all return False, error_message)
test_cases_invalid = [
    "notanemail",            # No @ symbol
    "@example.com",          # No username
    "user@",                 # No domain
    "user @example.com",     # Space in username
    "user@.com"              # Domain starts with dot
]

print("✅ Valid Emails:")
for email in test_cases_valid:
    is_valid, msg = validator.validate(email)
    print(f"  {email}: {is_valid}")
    # Output:
    # user@example.com: True
    # john.doe@company.co.uk: True
    # ...

print("\n❌ Invalid Emails:")
for email in test_cases_invalid:
    is_valid, msg = validator.validate(email)
    print(f"  {email}: {is_valid} - {msg}")
    # Output:
    # notanemail: False - email must be a valid email address
    # @example.com: False - email must be a valid email address
    # ...
```

---

#### 🎯 Real-World Usage Example

```python
# Scenario: Validating customer data before loading to database

customers = [
    {'name': 'Ana', 'email': 'ana@gmail.com', 'state': 'SP'},
    {'name': 'Bruno', 'email': 'invalid-email', 'state': 'RJ'},  # BAD EMAIL
    {'name': 'Carlos', 'email': 'carlos@hotmail.com', 'state': 'MG'},
]

email_validator = EmailValidator()
valid_customers = []
invalid_customers = []

for customer in customers:
    is_valid, error_msg = email_validator.validate(customer['email'])
    
    if is_valid:
        valid_customers.append(customer)
    else:
        print(f"⚠️  Skipping {customer['name']}: {error_msg}")
        invalid_customers.append(customer)

print(f"\n✅ Valid customers: {len(valid_customers)}")  # 2
print(f"❌ Invalid customers: {len(invalid_customers)}")  # 1

# Only load valid customers to database
loader.load(valid_customers)
```

---

#### 💡 Advanced: Understanding Regex Patterns

If you want to customize the email pattern:

```python
# More strict (only alphanumeric usernames)
EMAIL_PATTERN = r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$'

# More permissive (allows more special characters)
EMAIL_PATTERN = r'^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

# Enforce specific domain
EMAIL_PATTERN = r'^[a-zA-Z0-9._%+-]+@example\.com$'  # Only @example.com

# Case-insensitive matching
self.pattern = re.compile(self.EMAIL_PATTERN, re.IGNORECASE)
```

---

#### ✅ Key Takeaways

1. **Inheritance**: `EmailValidator` extends `DataValidator` (reuses parent functionality)
2. **Regex**: Pattern matching is powerful for format validation
3. **Compile Once**: Use `re.compile()` for efficiency
4. **Error Handling**: Handle `None` values and type conversion
5. **Return Tuple**: `(is_valid, error_message)` provides both result and reason
6. **Integration**: Plugs seamlessly into existing validation pipeline

**Next**: Apply this same pattern to create phone validators, date validators, etc!

---

### Enhancement 1.2: Phone Number Validator (Brazilian Format)

**🎯 What It Does:**
Validates Brazilian phone numbers in both formatted `(11) 99999-9999` and unformatted `11999999999` styles, supporting both mobile (9 digits) and landline (8 digits) numbers.

**💡 Why It Matters:**
- **Data Consistency**: Ensures phone numbers follow Brazilian format standards
- **Business Integration**: Automated calling/SMS systems require valid phone formats
- **Dual Format Support**: Users can input with or without formatting
- **Mobile vs Landline**: Validates both 8-digit landlines and 9-digit mobile numbers

---

#### 📚 Understanding Brazilian Phone Number Format

Before coding, let's understand the structure:

```
Brazilian Phone Number Structure:

(DDD) XXXXX-XXXX
 │     │     │
 │     │     └─ Last 4 digits
 │     └─ First 5 digits (mobile) or 4 digits (landline)
 └─ Area code (2 digits)

Examples:
Mobile:    (11) 99999-9999  → São Paulo mobile (starts with 9)
Landline:  (11) 3333-4444   → São Paulo landline (starts with 2-5)
Mobile:    (21) 98888-7777  → Rio mobile
Landline:  (85) 3244-5566   → Ceará landline

Without formatting:
11999999999  → 11 digits (mobile)
1133334444   → 10 digits (landline)
```

**Key Rules:**
1. **DDD (Area Code)**: Always 2 digits (11-99)
2. **Mobile**: 9 digits starting with 9 (total: 11 digits with DDD)
3. **Landline**: 8 digits starting with 2-5 (total: 10 digits with DDD)
4. **Formatting**: Optional parentheses, space, and hyphen

---

#### � Complete Implementation with Line-by-Line Explanation

Add to `src/validators.py`:

```python
class BrazilianPhoneValidator(DataValidator):
    """Validate Brazilian phone numbers.
    
    Accepts formats:
    - (11) 99999-9999 (mobile with formatting)
    - (11) 3333-4444 (landline with formatting)
    - 11999999999 (mobile without formatting)
    - 1133334444 (landline without formatting)
    """
```

**🔍 Why inherit from DataValidator:**
- Reuses `field_name`, `validation_count`, `error_count` from parent
- Consistent interface: all validators work the same way
- Follows DRY principle (Don't Repeat Yourself)

---

#### Part 1: Initialize with Two Patterns

```python
    def __init__(self):
        """Initialize Brazilian phone validator."""
        super().__init__("phone")  # Set field name to "phone"
        
        # Pattern for formatted: (11) 99999-9999 or (11) 3333-4444
        self.formatted_pattern = re.compile(r'^\(\d{2}\)\s?\d{4,5}-\d{4}$')
        
        # Pattern for unformatted: 11999999999 or 1133334444
        self.unformatted_pattern = re.compile(r'^\d{10,11}$')
```

**🔍 Line-by-line breakdown:**

**Line 1:** `super().__init__("phone")`
- Initialize parent class with field name "phone"
- Sets up counters and field name

**Line 2:** `self.formatted_pattern = re.compile(r'^\(\d{2}\)\s?\d{4,5}-\d{4}$')`
- Creates regex for formatted phones: `(11) 99999-9999`

**Let's break down this regex:**

```
r'^\(\d{2}\)\s?\d{4,5}-\d{4}$'
│  ││    │││  │      │ │    │
│  ││    │││  │      │ │    └─ $ = End of string
│  ││    │││  │      │ └─ \d{4} = Exactly 4 digits (last part)
│  ││    │││  │      └─ - = Literal hyphen
│  ││    │││  └─ \d{4,5} = 4 or 5 digits (landline=4, mobile=5)
│  ││    ││└─ \s? = Optional space (0 or 1 space)
│  ││    │└─ \) = Literal closing parenthesis (escaped)
│  ││    └─ \d{2} = Exactly 2 digits (area code)
│  │└─ \( = Literal opening parenthesis (escaped)
│  └─ ^ = Start of string
└─ r' ' = Raw string
```

**Examples that MATCH formatted_pattern:**
- ✅ `(11) 99999-9999` → Mobile with space (11 digits total)
- ✅ `(11) 3333-4444` → Landline with space (10 digits total)
- ✅ `(21)98888-7777` → Mobile without space
- ✅ `(85)3244-5566` → Landline without space

**Examples that DON'T match formatted_pattern:**
- ❌ `11 99999-9999` → Missing parentheses
- ❌ `(11)999999999` → Missing hyphen
- ❌ `(1) 99999-9999` → Area code only 1 digit

**Line 3:** `self.unformatted_pattern = re.compile(r'^\d{10,11}$')`
- Creates regex for unformatted phones: `11999999999`

**Let's break down this regex:**

```
r'^\d{10,11}$'
│  │        │
│  │        └─ $ = End of string
│  └─ \d{10,11} = 10 or 11 digits (landline=10, mobile=11)
└─ ^ = Start of string
```

**Examples that MATCH unformatted_pattern:**
- ✅ `11999999999` → 11 digits (mobile)
- ✅ `1133334444` → 10 digits (landline)
- ✅ `2198887777` → 10 digits (landline)
- ✅ `85988887777` → 11 digits (mobile)

**Examples that DON'T match unformatted_pattern:**
- ❌ `119999999` → Only 9 digits (too short)
- ❌ `119999999999` → 12 digits (too long)
- ❌ `(11)99999999` → Has formatting

---

#### Part 2: Validation Logic with Dual Pattern Matching

```python
    def validate(self, value):
        """Validate Brazilian phone number.
        
        Args:
            value: Phone number to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Example:
            >>> validator = BrazilianPhoneValidator()
            >>> 
            >>> # Valid phones
            >>> validator.validate("(11) 99999-9999")  # Mobile formatted
            (True, None)
            >>> 
            >>> validator.validate("11999999999")  # Mobile unformatted
            (True, None)
            >>> 
            >>> # Invalid phones
            >>> validator.validate("123456")
            (False, 'phone must be a valid Brazilian phone number (e.g., (11) 99999-9999)')
        """
        self.validation_count += 1  # Track total validations
        
        # Convert to string and remove extra whitespace
        phone = str(value).strip() if value else ""
        
        # Check against both patterns
        if self.formatted_pattern.match(phone) or self.unformatted_pattern.match(phone):
            return True, None  # Valid phone!
        
        self.error_count += 1  # Track failures
        return False, f"{self.field_name} must be a valid Brazilian phone number (e.g., (11) 99999-9999)"
```

**🔍 Line-by-line breakdown:**

**Line 1:** `self.validation_count += 1`
- Increment validation counter
- Useful for statistics: "Validated 500 phone numbers"

**Line 2:** `phone = str(value).strip() if value else ""`
- Convert to string (handles numbers, None, etc.)
- `.strip()` removes leading/trailing whitespace
- Prevents errors from unexpected input types

**Examples:**
```python
value = "  (11) 99999-9999  "  →  phone = "(11) 99999-9999"
value = 11999999999           →  phone = "11999999999"
value = None                   →  phone = ""
```

**Line 3:** `if self.formatted_pattern.match(phone) or self.unformatted_pattern.match(phone):`
- **First check**: Does it match formatted pattern `(11) 99999-9999`?
- **Second check**: Does it match unformatted pattern `11999999999`?
- **OR logic**: If EITHER pattern matches, it's valid
- This allows both input styles!

**Flow diagram:**
```
Input: "(11) 99999-9999"
  ↓
formatted_pattern.match()  → ✅ Match! → Return True
  ↓ (skip second check because OR short-circuits)
Done

Input: "11999999999"
  ↓
formatted_pattern.match()  → ❌ No match
  ↓
unformatted_pattern.match() → ✅ Match! → Return True
  ↓
Done

Input: "123"
  ↓
formatted_pattern.match()  → ❌ No match
  ↓
unformatted_pattern.match() → ❌ No match
  ↓
Return False (invalid)
```

**Line 4:** `return True, None`
- Phone is valid!
- No error message needed

**Line 5-6:** Error handling
- Increment error counter
- Return helpful error message with example format

---

#### Part 3: Integration with Validators Dictionary

```python
# In main.py:
validators = {
    'name': RequiredFieldValidator('name'),
    'phone': BrazilianPhoneValidator(),  # NEW: Phone validation
    'email': EmailValidator(),
}
```

**🔍 How it integrates:**

```python
# Example customer data
customer = {
    'name': 'João Silva',
    'phone': '(11) 99999-9999',  # Will be validated
    'email': 'joao@example.com'
}

# Validation happens in pipeline
for field_name, validator in validators.items():
    value = customer.get(field_name)
    is_valid, error_msg = validator.validate(value)
    
    if not is_valid:
        print(f"❌ {error_msg}")

# For phone field:
# BrazilianPhoneValidator checks: "(11) 99999-9999"
# formatted_pattern matches → Returns (True, None)
```

---

#### 📊 Comprehensive Test Cases

```python
# Test Brazilian phone numbers
validator = BrazilianPhoneValidator()

# ✅ VALID phones (should all return True, None)
valid_phones = [
    "(11) 99999-9999",  # São Paulo mobile with space
    "(21) 98888-7777",  # Rio mobile with space
    "(85) 3244-5566",   # Ceará landline with space
    "(11)99999-9999",   # Mobile without space (also valid)
    "11999999999",      # Mobile unformatted (11 digits)
    "1133334444",       # Landline unformatted (10 digits)
    "(47) 3333-4444",   # Santa Catarina landline
]

# ❌ INVALID phones (should all return False, error_message)
invalid_phones = [
    "123",              # Too short
    "(11) 9999",        # Incomplete (missing digits)
    "abc123",           # Contains letters
    "99999999999999",   # Too long (14 digits)
    "11 99999-9999",    # Missing parentheses
    "(1) 99999-9999",   # Area code only 1 digit
    "119999999",        # Only 9 digits (too short)
]

print("✅ Valid Phone Numbers:")
for phone in valid_phones:
    is_valid, msg = validator.validate(phone)
    status = "✓" if is_valid else "✗"
    print(f"  {status} {phone}: {is_valid}")

# Output:
#   ✓ (11) 99999-9999: True
#   ✓ (21) 98888-7777: True
#   ✓ (85) 3244-5566: True
#   ...

print("\n❌ Invalid Phone Numbers:")
for phone in invalid_phones:
    is_valid, msg = validator.validate(phone)
    status = "✓" if not is_valid else "✗"
    print(f"  {status} {phone}: {is_valid}")
    if msg:
        print(f"     → {msg}")

# Output:
#   ✓ 123: False
#      → phone must be a valid Brazilian phone number (e.g., (11) 99999-9999)
#   ✓ (11) 9999: False
#      → phone must be a valid Brazilian phone number (e.g., (11) 99999-9999)
#   ...
```

---

#### 🎯 Real-World Usage Example

```python
# Scenario: E-commerce checkout validation

customers = [
    {'name': 'Ana', 'phone': '(11) 99999-9999', 'city': 'São Paulo'},     # Valid
    {'name': 'Bruno', 'phone': '11999999999', 'city': 'São Paulo'},       # Valid (unformatted)
    {'name': 'Carlos', 'phone': '123456', 'city': 'Rio'},                 # INVALID
    {'name': 'Diana', 'phone': '(21) 98888-7777', 'city': 'Rio'},         # Valid
]

phone_validator = BrazilianPhoneValidator()

for customer in customers:
    is_valid, error_msg = phone_validator.validate(customer['phone'])
    
    if is_valid:
        print(f"✅ {customer['name']}: Phone {customer['phone']} is valid")
        # Proceed with SMS verification
    else:
        print(f"❌ {customer['name']}: {error_msg}")
        # Ask user to re-enter phone number

# Output:
# ✅ Ana: Phone (11) 99999-9999 is valid
# ✅ Bruno: Phone 11999999999 is valid
# ❌ Carlos: phone must be a valid Brazilian phone number (e.g., (11) 99999-9999)
# ✅ Diana: Phone (21) 98888-7777 is valid
```

---

#### 💡 Advanced: Phone Number Normalization

Sometimes you want to store phones in a consistent format (e.g., always unformatted). Add a normalization method:

```python
class BrazilianPhoneValidator(DataValidator):
    # ... existing code ...
    
    def normalize(self, phone):
        """Remove formatting from phone number.
        
        Converts: (11) 99999-9999 → 11999999999
        
        Args:
            phone: Phone number (formatted or unformatted)
            
        Returns:
            str: Phone with only digits
        
        Example:
            >>> validator = BrazilianPhoneValidator()
            >>> validator.normalize("(11) 99999-9999")
            '11999999999'
            >>> validator.normalize("11999999999")
            '11999999999'
        """
        # Remove everything except digits
        import re
        digits_only = re.sub(r'\D', '', phone)  # \D = non-digit characters
        return digits_only
    
    def validate_and_normalize(self, value):
        """Validate and return normalized phone.
        
        Returns:
            tuple: (is_valid, normalized_phone or error_message)
        
        Example:
            >>> validator = BrazilianPhoneValidator()
            >>> is_valid, result = validator.validate_and_normalize("(11) 99999-9999")
            >>> print(is_valid, result)
            True 11999999999
        """
        is_valid, error_msg = self.validate(value)
        
        if is_valid:
            phone = str(value).strip()
            normalized = self.normalize(phone)
            return True, normalized
        else:
            return False, error_msg


# Usage:
validator = BrazilianPhoneValidator()

# Validate and normalize
is_valid, result = validator.validate_and_normalize("(11) 99999-9999")
if is_valid:
    print(f"Storing in database: {result}")  # Storing in database: 11999999999
```

---

#### 🌍 Extending to Other Countries

Want to support multiple countries? Use a factory pattern:

```python
class PhoneValidatorFactory:
    """Create phone validators for different countries."""
    
    @staticmethod
    def create(country_code):
        """Create validator for country.
        
        Args:
            country_code: 'BR', 'US', 'UK', etc.
            
        Returns:
            Phone validator for that country
        """
        if country_code == 'BR':
            return BrazilianPhoneValidator()
        elif country_code == 'US':
            return USPhoneValidator()  # You'd implement this
        elif country_code == 'UK':
            return UKPhoneValidator()  # You'd implement this
        else:
            raise ValueError(f"Unsupported country: {country_code}")


# Usage:
validator = PhoneValidatorFactory.create('BR')
is_valid, msg = validator.validate("(11) 99999-9999")
```

---

#### ✅ Key Takeaways

1. **Dual Pattern Support**: Accepts both formatted and unformatted input
2. **OR Logic**: `pattern1.match() or pattern2.match()` allows flexibility
3. **Brazilian Standards**: Validates 10-digit landlines and 11-digit mobiles
4. **Normalization**: Extract digits for consistent storage
5. **User-Friendly**: Accepts common input variations
6. **Regex Power**: Complex validation made simple with patterns

**Next**: Apply this pattern to date validators, currency validators, CPF validators, etc!

---

### Enhancement 1.3: Date Format Validator

**🎯 What It Does:**
Validates dates in a specified format (YYYY-MM-DD, DD/MM/YYYY, MM/DD/YYYY, etc.) and ensures the date is actually valid (prevents impossible dates like February 30th).

**💡 Why It Matters:**
- **Data Consistency**: Ensures all dates follow the same format in your database
- **Validation**: Prevents invalid dates (2024-13-45, 2024-02-30, etc.)
- **Database Compatibility**: Databases require specific date formats
- **International Support**: Handle different regional formats (US, Brazilian, European, etc.)

---

#### 📚 Understanding Date Format Codes

Python uses `strptime()` with format codes to parse dates. Let's understand them:

```
Common Date Format Codes:

%Y = Year with 4 digits    (2024)
%y = Year with 2 digits    (24)
%m = Month with 2 digits   (01-12)
%d = Day with 2 digits     (01-31)
%B = Full month name       (January, February)
%b = Abbreviated month     (Jan, Feb)
%A = Full day name         (Monday, Tuesday)
%a = Abbreviated day       (Mon, Tue)
%H = Hour (24-hour)        (00-23)
%I = Hour (12-hour)        (01-12)
%M = Minute                (00-59)
%S = Second                (00-59)
%p = AM/PM                 (AM, PM)

Examples:
'%Y-%m-%d'       → 2024-03-10 (ISO format, database standard)
'%d/%m/%Y'       → 10/03/2024 (Brazilian format)
'%m/%d/%Y'       → 03/10/2024 (US format)
'%Y/%m/%d'       → 2024/03/10 (Alternative)
'%d-%b-%Y'       → 10-Mar-2024 (With month abbreviation)
'%B %d, %Y'      → March 10, 2024 (Full month name)
'%Y-%m-%d %H:%M' → 2024-03-10 14:30 (With time)
```

---

#### � Complete Implementation with Line-by-Line Explanation

Add to `src/validators.py`:

```python
from datetime import datetime  # Import Python's date/time handling library
```

**🔍 Why import datetime:**
- `datetime` is Python's built-in module for working with dates and times
- `datetime.strptime()` = "string parse time" = Convert string to date object
- Automatically validates dates (rejects Feb 30, month 13, etc.)

---

#### Part 1: Class Definition and Format Support

```python
class DateFormatValidator(DataValidator):
    """Validate date format.
    
    Supports multiple formats:
    - YYYY-MM-DD (ISO format - database standard)
    - DD/MM/YYYY (Brazilian format)
    - MM/DD/YYYY (US format)
    - Any custom format using Python's strptime codes
    """
```

**🔍 Why support multiple formats:**
- **ISO (YYYY-MM-DD)**: Universal standard, database-friendly, sortable
- **Brazilian (DD/MM/YYYY)**: Common in Brazil and Europe
- **US (MM/DD/YYYY)**: Standard in United States
- **Custom**: Hotels might use "10-Mar-2024", others "March 10, 2024"

---

#### Part 2: Initialization with Format Dictionary

```python
    def __init__(self, field_name, date_format='%Y-%m-%d'):
        """Initialize date validator.
        
        Args:
            field_name: Name of the date field (e.g., 'check_in', 'birth_date')
            date_format: Expected date format (default: YYYY-MM-DD)
        
        Common formats:
            - '%Y-%m-%d': 2024-03-10 (ISO - recommended)
            - '%d/%m/%Y': 10/03/2024 (Brazilian)
            - '%m/%d/%Y': 03/10/2024 (US)
            - '%Y/%m/%d': 2024/03/10
        
        Example:
            >>> # ISO format for database dates
            >>> validator = DateFormatValidator('check_in', '%Y-%m-%d')
            >>> 
            >>> # Brazilian format for user input
            >>> validator = DateFormatValidator('birth_date', '%d/%m/%Y')
        """
        super().__init__(field_name)  # Initialize parent class
        self.date_format = date_format  # Store the format to validate against
        
        # Dictionary of example dates for helpful error messages
        self.format_examples = {
            '%Y-%m-%d': '2024-03-10',
            '%d/%m/%Y': '10/03/2024',
            '%m/%d/%Y': '03/10/2024',
            '%Y/%m/%d': '2024/03/10'
        }
```

**🔍 Line-by-line breakdown:**

**Line 1:** `super().__init__(field_name)`
- Call parent `DataValidator.__init__()`
- Sets `self.field_name = field_name`
- Initializes counters (`validation_count`, `error_count`)

**Line 2:** `self.date_format = date_format`
- Store the format string (e.g., '%Y-%m-%d')
- Used later in `strptime()` to parse dates
- **Default**: '%Y-%m-%d' (ISO format) if not specified

**Line 3:** `self.format_examples = {...}`
- Dictionary mapping format codes to example dates
- Used to generate helpful error messages
- **Purpose**: When validation fails, show user what format is expected

**Example:**
```python
# User creates validator
validator = DateFormatValidator('check_in', '%Y-%m-%d')

# Now validator has:
# self.field_name = 'check_in'
# self.date_format = '%Y-%m-%d'
# self.format_examples = {'%Y-%m-%d': '2024-03-10', ...}
```

---

#### Part 3: Validation Logic with Try-Except

```python
    def validate(self, value):
        """Validate date format.
        
        Args:
            value: Date string to validate
            
        Returns:
            tuple: (is_valid, error_message)
        
        Example:
            >>> validator = DateFormatValidator('check_in', '%Y-%m-%d')
            >>> 
            >>> # ✅ Valid date
            >>> validator.validate('2024-03-10')
            (True, None)
            >>> 
            >>> # ❌ Invalid format (wrong format)
            >>> validator.validate('10/03/2024')
            (False, 'check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)')
            >>> 
            >>> # ❌ Invalid date (impossible date)
            >>> validator.validate('2024-13-45')
            (False, 'check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)')
        """
        self.validation_count += 1  # Track total validations
        
        date_str = str(value).strip() if value else ""  # Convert and clean input
        
        try:
            # Try to parse the date - this is where validation happens
            datetime.strptime(date_str, self.date_format)
            return True, None  # Success! Date is valid
        except ValueError:
            # Parsing failed - date is invalid
            self.error_count += 1
            
            # Provide helpful error message with example
            example = self.format_examples.get(self.date_format, 'valid date')
            format_name = self.date_format.replace('%Y', 'YYYY').replace('%m', 'MM').replace('%d', 'DD')
            
            return False, f"{self.field_name} must be in format {format_name} (e.g., {example})"
```

**🔍 Line-by-line breakdown:**

**Line 1:** `self.validation_count += 1`
- Increment counter for statistics
- Tracks how many dates have been validated

**Line 2:** `date_str = str(value).strip() if value else ""`
- Convert to string (handles various input types)
- `.strip()` removes leading/trailing whitespace
- Handle None/empty values gracefully

**Examples:**
```python
value = "  2024-03-10  "  →  date_str = "2024-03-10"
value = 2024             →  date_str = "2024"
value = None              →  date_str = ""
```

**Line 3:** `try:` block
- Attempt to parse the date
- If successful, date is valid
- If fails, catch the error and return error message

**Line 4:** `datetime.strptime(date_str, self.date_format)`
- **strptime** = "string parse time"
- Attempts to convert string to datetime object
- **Validates TWO things:**
  1. Format matches (e.g., "YYYY-MM-DD")
  2. Date is actually valid (no Feb 30, no month 13, etc.)

**How strptime works:**
```python
# Valid dates:
datetime.strptime('2024-03-10', '%Y-%m-%d')  # ✅ Success → datetime object
datetime.strptime('2024-02-29', '%Y-%m-%d')  # ✅ Success (2024 is leap year)
datetime.strptime('31/12/2024', '%d/%m/%Y')  # ✅ Success → different format

# Invalid dates (raise ValueError):
datetime.strptime('2024-13-10', '%Y-%m-%d')  # ❌ Month 13 doesn't exist
datetime.strptime('2024-02-30', '%Y-%m-%d')  # ❌ Feb 30 doesn't exist
datetime.strptime('10/03/2024', '%Y-%m-%d')  # ❌ Wrong format
datetime.strptime('2023-02-29', '%Y-%m-%d')  # ❌ 2023 not leap year
```

**Line 5:** `return True, None`
- Date parsing succeeded!
- Return success with no error message

**Line 6:** `except ValueError:`
- `strptime()` raises `ValueError` when parsing fails
- Catch this exception to return helpful error message
- **Two reasons for ValueError:**
  1. Wrong format (e.g., "10/03/2024" when expecting "2024-03-10")
  2. Invalid date (e.g., "2024-13-45")

**Line 7:** `self.error_count += 1`
- Increment error counter for statistics

**Line 8-9:** Generate helpful error message
```python
example = self.format_examples.get(self.date_format, 'valid date')
# Looks up example date for the format
# '%Y-%m-%d' → '2024-03-10'
# '%d/%m/%Y' → '10/03/2024'

format_name = self.date_format.replace('%Y', 'YYYY').replace('%m', 'MM').replace('%d', 'DD')
# Converts format code to human-readable name
# '%Y-%m-%d' → 'YYYY-MM-DD'
# '%d/%m/%Y' → 'DD/MM/YYYY'
```

**Line 10:** Return error message
```python
return False, f"{self.field_name} must be in format {format_name} (e.g., {example})"
# Example output:
# "check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)"
```

---

#### Part 4: Integration with Validators Dictionary

```python
# In main.py:
validators = {
    'check_in': DateFormatValidator('check_in', '%Y-%m-%d'),      # ISO format
    'check_out': DateFormatValidator('check_out', '%Y-%m-%d'),    # ISO format
    'birth_date': DateFormatValidator('birth_date', '%d/%m/%Y'),  # Brazilian format
}
```

**� Why different formats for different fields:**
- **check_in/check_out**: Use ISO format (database standard)
- **birth_date**: Use Brazilian format (user input)
- Each field can have its own format!

**Example usage in pipeline:**
```python
booking = {
    'check_in': '2024-03-10',   # Will be validated as YYYY-MM-DD
    'check_out': '2024-03-15',  # Will be validated as YYYY-MM-DD
    'birth_date': '15/05/1990'  # Will be validated as DD/MM/YYYY
}

for field_name, validator in validators.items():
    value = booking.get(field_name)
    is_valid, error_msg = validator.validate(value)
    
    if not is_valid:
        print(f"❌ {error_msg}")
```

---

#### �📊 Comprehensive Test Cases

```python
# Test date validator
iso_validator = DateFormatValidator('check_in', '%Y-%m-%d')
br_validator = DateFormatValidator('birth_date', '%d/%m/%Y')
us_validator = DateFormatValidator('purchase_date', '%m/%d/%Y')

print("✅ ISO Format Tests (YYYY-MM-DD):")
iso_tests = [
    ('2024-03-10', True),   # Valid standard date
    ('2024-12-31', True),   # Valid last day of year
    ('2024-02-29', True),   # Valid leap year date
    ('2024-01-01', True),   # Valid first day of year
    ('2024-13-01', False),  # ❌ Invalid month (13)
    ('2024-02-30', False),  # ❌ Invalid day (Feb has 28/29 days)
    ('2023-02-29', False),  # ❌ Invalid (2023 not leap year)
    ('10/03/2024', False),  # ❌ Wrong format
    ('2024/03/10', False),  # ❌ Wrong separator
]

for date_str, expected in iso_tests:
    is_valid, msg = iso_validator.validate(date_str)
    status = "✓" if is_valid == expected else "✗"
    result = "PASS" if is_valid == expected else "FAIL"
    print(f"  {status} {date_str:<15} Expected: {expected:<5} Got: {is_valid:<5} [{result}]")
    if msg and not is_valid:
        print(f"     → {msg}")

# Output:
#   ✓ 2024-03-10      Expected: True  Got: True  [PASS]
#   ✓ 2024-12-31      Expected: True  Got: True  [PASS]
#   ✓ 2024-13-01      Expected: False Got: False [PASS]
#      → check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)
#   ...

print("\n✅ Brazilian Format Tests (DD/MM/YYYY):")
br_tests = [
    ('10/03/2024', True),   # Valid
    ('31/12/2024', True),   # Valid last day
    ('29/02/2024', True),   # Valid leap year
    ('32/01/2024', False),  # ❌ Day 32 doesn't exist
    ('10/13/2024', False),  # ❌ Month 13 doesn't exist
    ('29/02/2023', False),  # ❌ Not leap year
    ('2024-03-10', False),  # ❌ Wrong format
]

for date_str, expected in br_tests:
    is_valid, msg = br_validator.validate(date_str)
    status = "✓" if is_valid == expected else "✗"
    print(f"  {status} {date_str}: {is_valid}")
    if msg and not is_valid:
        print(f"     → {msg}")

print("\n✅ US Format Tests (MM/DD/YYYY):")
us_tests = [
    ('03/10/2024', True),   # Valid (March 10)
    ('12/31/2024', True),   # Valid (December 31)
    ('02/29/2024', True),   # Valid leap year
    ('13/10/2024', False),  # ❌ Month 13
    ('02/30/2024', False),  # ❌ Feb 30
]

for date_str, expected in us_tests:
    is_valid, msg = us_validator.validate(date_str)
    status = "✓" if is_valid == expected else "✗"
    print(f"  {status} {date_str}: {is_valid}")
```

---

#### 🎯 Real-World Usage Example

```python
# Scenario: Hotel booking system validation

bookings = [
    {'customer': 'Ana', 'check_in': '2024-03-10', 'check_out': '2024-03-15'},  # ✅ Valid
    {'customer': 'Bruno', 'check_in': '2024-02-30', 'check_out': '2024-03-05'},  # ❌ Invalid date
    {'customer': 'Carlos', 'check_in': '10/03/2024', 'check_out': '15/03/2024'},  # ❌ Wrong format
    {'customer': 'Diana', 'check_in': '2024-12-25', 'check_out': '2024-12-30'},  # ✅ Valid
]

check_in_validator = DateFormatValidator('check_in', '%Y-%m-%d')
check_out_validator = DateFormatValidator('check_out', '%Y-%m-%d')

valid_bookings = []
invalid_bookings = []

for booking in bookings:
    # Validate check-in
    is_valid_in, error_in = check_in_validator.validate(booking['check_in'])
    is_valid_out, error_out = check_out_validator.validate(booking['check_out'])
    
    if is_valid_in and is_valid_out:
        valid_bookings.append(booking)
        print(f"✅ {booking['customer']}: Booking valid")
    else:
        invalid_bookings.append(booking)
        print(f"❌ {booking['customer']}: Booking invalid")
        if not is_valid_in:
            print(f"   → {error_in}")
        if not is_valid_out:
            print(f"   → {error_out}")

print(f"\n📊 Summary:")
print(f"   Valid bookings: {len(valid_bookings)}")
print(f"   Invalid bookings: {len(invalid_bookings)}")

# Output:
# ✅ Ana: Booking valid
# ❌ Bruno: Booking invalid
#    → check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)
# ❌ Carlos: Booking invalid
#    → check_in must be in format YYYY-MM-DD (e.g., 2024-03-10)
#    → check_out must be in format YYYY-MM-DD (e.g., 2024-03-10)
# ✅ Diana: Booking valid
# 
# 📊 Summary:
#    Valid bookings: 2
#    Invalid bookings: 2
```

---

#### 💡 Advanced: Date Parsing and Conversion

Sometimes you want to parse AND convert the date:

```python
class DateFormatValidator(DataValidator):
    # ... existing code ...
    
    def parse_date(self, value):
        """Parse and return datetime object.
        
        Args:
            value: Date string
            
        Returns:
            datetime object or None if invalid
        
        Example:
            >>> validator = DateFormatValidator('check_in', '%Y-%m-%d')
            >>> dt = validator.parse_date('2024-03-10')
            >>> print(dt)
            2024-03-10 00:00:00
            >>> print(dt.year, dt.month, dt.day)
            2024 3 10
        """
        try:
            return datetime.strptime(str(value).strip(), self.date_format)
        except ValueError:
            return None
    
    def validate_and_parse(self, value):
        """Validate and return parsed date.
        
        Returns:
            tuple: (is_valid, datetime_object or error_message)
        
        Example:
            >>> validator = DateFormatValidator('check_in', '%Y-%m-%d')
            >>> is_valid, result = validator.validate_and_parse('2024-03-10')
            >>> if is_valid:
            ...     print(f"Year: {result.year}, Month: {result.month}")
            Year: 2024, Month: 3
        """
        is_valid, error_msg = self.validate(value)
        
        if is_valid:
            date_obj = self.parse_date(value)
            return True, date_obj
        else:
            return False, error_msg


# Usage:
validator = DateFormatValidator('check_in', '%Y-%m-%d')
is_valid, result = validator.validate_and_parse('2024-03-10')

if is_valid:
    # result is a datetime object
    print(f"Check-in: {result.strftime('%A, %B %d, %Y')}")
    # Output: Check-in: Sunday, March 10, 2024
    
    # Can do date arithmetic
    from datetime import timedelta
    checkout = result + timedelta(days=5)
    print(f"Check-out: {checkout.strftime('%Y-%m-%d')}")
    # Output: Check-out: 2024-03-15
```

---

#### 🌍 Multi-Format Support

Support multiple date formats for user flexibility:

```python
class FlexibleDateValidator(DataValidator):
    """Accept multiple date formats."""
    
    def __init__(self, field_name, accepted_formats=None):
        """Initialize with multiple accepted formats.
        
        Args:
            field_name: Field name
            accepted_formats: List of acceptable format strings
        
        Example:
            >>> validator = FlexibleDateValidator('date', [
            ...     '%Y-%m-%d',    # 2024-03-10
            ...     '%d/%m/%Y',    # 10/03/2024
            ...     '%m/%d/%Y',    # 03/10/2024
            ...     '%d-%b-%Y'     # 10-Mar-2024
            ... ])
        """
        super().__init__(field_name)
        self.accepted_formats = accepted_formats or ['%Y-%m-%d']
    
    def validate(self, value):
        """Try parsing with each accepted format."""
        self.validation_count += 1
        date_str = str(value).strip() if value else ""
        
        # Try each format
        for fmt in self.accepted_formats:
            try:
                datetime.strptime(date_str, fmt)
                return True, None  # Success with this format!
            except ValueError:
                continue  # Try next format
        
        # None of the formats worked
        self.error_count += 1
        return False, f"{self.field_name} must be a valid date (accepted formats: {', '.join(self.accepted_formats)})"


# Usage:
validator = FlexibleDateValidator('date', ['%Y-%m-%d', '%d/%m/%Y', '%m/%d/%Y'])

validator.validate('2024-03-10')   # ✅ Valid (ISO)
validator.validate('10/03/2024')   # ✅ Valid (Brazilian)
validator.validate('03/10/2024')   # ✅ Valid (US)
validator.validate('invalid')      # ❌ Invalid
```

---

#### ✅ Key Takeaways

1. **strptime() Magic**: Validates both format AND date validity (no Feb 30!)
2. **Format Codes**: Learn `%Y`, `%m`, `%d` for building custom formats
3. **Try-Except**: Handle ValueError when parsing fails
4. **Helpful Errors**: Show expected format and example in error messages
5. **Flexibility**: Support multiple formats per field or across fields
6. **Parsing**: Can extract datetime objects for date arithmetic
7. **Real-World**: Handle leap years, month boundaries automatically

**Next**: Use these date validators in booking systems, age verification, scheduling, and more!

---

### Enhancement 1.4: CSV Loader

**🎯 What It Does:**
Loads data to CSV (Comma-Separated Values) files instead of JSON, making data accessible to Excel, Google Sheets, databases, and analytics tools.

**💡 Why It Matters:**
- **Universal Format**: CSV is supported by virtually every data tool
- **Smaller File Size**: CSV files are typically 30-50% smaller than JSON
- **Human-Readable**: Easy to view and edit in spreadsheet applications
- **Database Import**: Most databases can directly import CSV files
- **Excel Compatible**: Opens directly in Microsoft Excel, Google Sheets, LibreOffice

---

#### � Understanding CSV vs JSON

Let's compare the two formats:

**JSON Format (Verbose):**
```json
[
  {
    "id": 1,
    "name": "Camping Paradise",
    "state": "MG",
    "city": "Ouro Preto",
    "price": 150.00,
    "capacity": 20
  },
  {
    "id": 2,
    "name": "Mountain Retreat",
    "state": "SP",
    "city": "Campos do Jordão",
    "price": 200.00,
    "capacity": 15
  }
]
```

**CSV Format (Compact):**
```csv
id,name,state,city,price,capacity
1,Camping Paradise,MG,Ouro Preto,150.0,20
2,Mountain Retreat,SP,Campos do Jordão,200.0,15
```

**Comparison:**
- **JSON**: 287 bytes, structured but verbose
- **CSV**: 127 bytes, compact and simple
- **Size Reduction**: ~56% smaller!

---

#### 📚 CSV Loader Implementation - Already Built In!

**Good news:** The `FileLoader` class from Step 6 already supports CSV! You just need to use it.

**How to Switch:**

```python
# In main.py, when creating the loader:

# ❌ OLD: JSON format
loader = FileLoader("Output", "data/output/processed.json", "json")

# ✅ NEW: CSV format
loader = FileLoader("Output", "data/output/processed.csv", "csv")
#                                                           ^^^^
#                                                    Just change this!
```

**That's it!** The FileLoader automatically handles CSV writing.

---

#### 📚 How FileLoader CSV Works Internally

Let's understand the CSV implementation piece by piece:

```python
# In src/loaders.py (already implemented in Step 6):

import csv  # Python's built-in CSV library

class FileLoader(DataLoader):
    """Load data to file (JSON or CSV)."""
    
    def _load_csv(self, data):
        """Load data to CSV file.
        
        Automatically determines columns from data.
        
        Args:
            data: List of dictionaries to write
        
        Example:
            >>> data = [
            ...     {'id': 1, 'name': 'Camp A', 'price': 100},
            ...     {'id': 2, 'name': 'Camp B', 'price': 150}
            ... ]
            >>> loader._load_csv(data)
            # Creates CSV:
            # id,name,price
            # 1,Camp A,100
            # 2,Camp B,150
        """
        if not data:
            return  # Nothing to write
        
        # Step 1: Get all unique keys from all rows
        fieldnames = set()
        for row in data:
            fieldnames.update(row.keys())
        
        # Step 2: Sort for consistency
        fieldnames = sorted(fieldnames)
        
        # Step 3: Write CSV file
        with open(self.output_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()  # Write column headers
            writer.writerows(data)  # Write all data rows
```

---

#### 🔍 Line-by-Line Breakdown

**Step 1: Extract All Column Names**

```python
fieldnames = set()  # Use set to avoid duplicates
for row in data:
    fieldnames.update(row.keys())  # Add all keys from this row
```

**🔍 Why use a set:**
- Different rows might have different fields
- Set automatically deduplicates
- Ensures we capture ALL columns

**Example:**
```python
data = [
    {'id': 1, 'name': 'Camp A', 'price': 100},
    {'id': 2, 'name': 'Camp B', 'price': 150, 'wifi': True},  # Has extra field!
    {'id': 3, 'name': 'Camp C'}  # Missing price!
]

# After loop:
fieldnames = {'id', 'name', 'price', 'wifi'}  # All unique fields
```

**Step 2: Sort Column Names**

```python
fieldnames = sorted(fieldnames)  # Alphabetical order
```

**🔍 Why sort:**
- **Consistency**: Same column order every time
- **Readability**: Alphabetical is predictable
- **Comparison**: Easier to compare files

**Example:**
```python
# Before sort:
{'wifi', 'id', 'price', 'name'}

# After sort:
['id', 'name', 'price', 'wifi']  # Also converts set → list
```

**Step 3: Open File and Create CSV Writer**

```python
with open(self.output_file, 'w', newline='', encoding='utf-8') as f:
```

**🔍 Parameter breakdown:**

- `'w'` = Write mode (overwrites existing file)
- `newline=''` = **Critical for CSV!** Prevents extra blank lines on Windows
- `encoding='utf-8'` = Support international characters (é, ñ, ã, etc.)

**Why `newline=''` is important:**
```python
# Without newline='':
id,name
1,Camp A

2,Camp B    # ← Extra blank line!

# With newline='':
id,name
1,Camp A
2,Camp B    # ← No blank lines ✓
```

**Step 4: Create DictWriter**

```python
writer = csv.DictWriter(f, fieldnames=fieldnames)
```

**🔍 What is DictWriter:**
- Writes dictionaries to CSV
- Automatically maps dict keys to CSV columns
- Much easier than manually formatting CSV

**Alternative (manual way - harder):**
```python
# Manual CSV writing (don't do this):
f.write('id,name,price\n')
for row in data:
    f.write(f"{row['id']},{row['name']},{row['price']}\n")
# Problems: Must handle missing keys, special characters, commas in data, etc.

# DictWriter way (automatic):
writer = csv.DictWriter(f, fieldnames=['id', 'name', 'price'])
writer.writeheader()
writer.writerows(data)
# Handles everything automatically!
```

**Step 5: Write Header Row**

```python
writer.writeheader()  # Writes: id,name,price,wifi
```

**🔍 What this does:**
- Writes the first row (column names)
- Uses the `fieldnames` list we provided
- Automatically formats and escapes as needed

**Step 6: Write All Data Rows**

```python
writer.writerows(data)  # Writes all data at once
```

**� How it works:**
- Takes list of dictionaries
- For each dict, writes values in the order of `fieldnames`
- Handles missing keys (writes empty string)
- Escapes special characters (commas, quotes, newlines)

**Example:**
```python
data = [
    {'id': 1, 'name': 'Camp A', 'price': 100, 'wifi': True},
    {'id': 2, 'name': 'Camp B', 'price': 150},  # No 'wifi' key
    {'id': 3, 'name': 'Camp "C"', 'price': 200, 'wifi': False}  # Quote in name
]

# Output CSV:
# id,name,price,wifi
# 1,Camp A,100,True
# 2,Camp B,150,          ← Empty wifi column
# 3,"Camp ""C""",200,False  ← Quotes escaped as ""
```

---

#### 📊 Complete Usage Example

```python
# In main.py:

from src.pipeline import ETLPipeline
from src.sources import FileSource
from src.loaders import FileLoader

# Create pipeline
pipeline = ETLPipeline()

# Add sources
pipeline.add_source(FileSource("Campsites", "data/campsites.json"))

# Create CSV loader
csv_loader = FileLoader("CSV Output", "output/processed.csv", "csv")
#                                                                ^^^
#                                                            Format: csv

# Set loader and run
pipeline.set_loader(csv_loader)
pipeline.run()

# Output file: output/processed.csv
# Can be opened in Excel, imported to database, etc.
```

---

#### 🎯 Real-World Scenario: Dual Output

Sometimes you want BOTH JSON (for APIs) and CSV (for Excel):

```python
# In main.py:

def main():
    # Setup pipeline
    pipeline = ETLPipeline()
    pipeline.add_source(FileSource("Campsites", "data/campsites.json"))
    
    # Add transformations
    transform_pipeline = TransformationPipeline()
    transform_pipeline.add_transformer(StateCodeTransformer())
    transform_pipeline.add_transformer(PriceRangeTransformer())
    pipeline.set_transformation(transform_pipeline)
    
    # Output 1: JSON for API
    json_loader = FileLoader("JSON Output", "output/api_data.json", "json")
    pipeline.set_loader(json_loader)
    data_json = pipeline.run()
    print("✅ JSON output saved for API")
    
    # Output 2: CSV for Excel/Analytics
    csv_loader = FileLoader("CSV Output", "output/analytics_data.csv", "csv")
    pipeline.set_loader(csv_loader)
    pipeline.run()
    print("✅ CSV output saved for Excel/Analytics")

if __name__ == "__main__":
    main()
```

**Output:**
```
✅ JSON output saved for API
✅ CSV output saved for Excel/Analytics

Files created:
  output/api_data.json      (287 KB)
  output/analytics_data.csv (127 KB)  ← 56% smaller!
```

---

#### 💡 Advanced: Handling Special Characters in CSV

CSV has special rules for commas, quotes, and newlines:

**Problem Cases:**

```python
data = [
    {'name': 'Camp A, B & C', 'description': 'Nice place'},  # Comma in name
    {'name': 'The "Best" Camp', 'description': 'Great!'},    # Quotes in name
    {'name': 'Mountain\nRetreat', 'description': 'Line\nbreak'},  # Newlines
]
```

**How DictWriter Handles Them:**

```csv
name,description
"Camp A, B & C",Nice place          ← Wrapped in quotes because of comma
"The ""Best"" Camp",Great!          ← Quotes escaped as ""
"Mountain
Retreat","Line
break"                              ← Multiline cells allowed!
```

**Rules Applied Automatically:**
1. **Contains comma** → Wrap field in quotes
2. **Contains quotes** → Escape as double quotes (`"` becomes `""`)
3. **Contains newline** → Wrap field in quotes
4. **Normal text** → No quotes needed

---

#### 📈 Performance Comparison

```python
import time
import os

# Test data: 10,000 rows
test_data = [
    {
        'id': i,
        'name': f'Camp {i}',
        'state': 'MG',
        'city': 'Ouro Preto',
        'price': 100 + i,
        'capacity': 20,
        'wifi': True,
        'description': 'A beautiful camping site in the mountains'
    }
    for i in range(10000)
]

# JSON output
start = time.time()
json_loader = FileLoader("JSON", "test.json", "json")
json_loader.connect()
json_loader.load(test_data)
json_time = time.time() - start
json_size = os.path.getsize("test.json")

# CSV output
start = time.time()
csv_loader = FileLoader("CSV", "test.csv", "csv")
csv_loader.connect()
csv_loader.load(test_data)
csv_time = time.time() - start
csv_size = os.path.getsize("test.csv")

# Results
print(f"\n📊 Performance Comparison (10,000 rows):")
print(f"{'='*50}")
print(f"JSON:")
print(f"  Time:  {json_time:.3f} seconds")
print(f"  Size:  {json_size:,} bytes ({json_size/1024:.1f} KB)")
print(f"\nCSV:")
print(f"  Time:  {csv_time:.3f} seconds")
print(f"  Size:  {csv_size:,} bytes ({csv_size/1024:.1f} KB)")
print(f"\nDifference:")
print(f"  Speed: {((json_time - csv_time) / json_time * 100):+.1f}% (CSV faster)")
print(f"  Size:  {((json_size - csv_size) / json_size * 100):+.1f}% (CSV smaller)")
print(f"{'='*50}")

# Example output:
# 📊 Performance Comparison (10,000 rows):
# ==================================================
# JSON:
#   Time:  0.234 seconds
#   Size:  1,847,234 bytes (1803.9 KB)
#
# CSV:
#   Time:  0.156 seconds
#   Size:  823,456 bytes (804.2 KB)
#
# Difference:
#   Speed: +33.3% (CSV faster)
#   Size:  +55.4% (CSV smaller)
# ==================================================
```

---

#### 🌍 Opening CSV in Different Applications

**Excel:**
1. Double-click `.csv` file
2. Opens directly in Excel
3. All columns automatically separated

**Google Sheets:**
1. Go to Google Sheets
2. File → Import → Upload
3. Select CSV file
4. Automatically detects columns

**Database (PostgreSQL):**
```sql
-- Import CSV to database
COPY campsites(id, name, state, city, price, capacity)
FROM '/path/to/processed.csv'
DELIMITER ','
CSV HEADER;
```

**Python (Pandas):**
```python
import pandas as pd

# Read CSV
df = pd.read_csv('processed.csv')

# Analyze
print(df.describe())
print(df.groupby('state')['price'].mean())
```

---

#### ✅ Key Takeaways

1. **Already Implemented**: FileLoader supports CSV out of the box
2. **Simple Switch**: Change format parameter from "json" to "csv"
3. **Auto-Column Detection**: Extracts columns from data automatically
4. **Special Character Handling**: DictWriter handles commas, quotes, newlines
5. **Performance**: CSV is 30-50% smaller and faster than JSON
6. **Universal Format**: Works with Excel, databases, analytics tools
7. **Dual Output**: Can generate both JSON (for APIs) and CSV (for analysis)

**Next**: Use CSV output for Excel reports, database imports, and data sharing!

---

### Enhancement 1.5: Configuration Validation

**🎯 What It Does:**
Validates configuration file before running the ETL pipeline, catching errors early and providing clear feedback.

**💡 Why It Matters:**
- **Fail Fast**: Catches errors in seconds, not hours into processing
- **Clear Feedback**: Tells you exactly what's wrong and where
- **Prevents Data Loss**: Avoids partial processing failures
- **Saves Time**: Fix config once instead of debugging pipeline failures
- **Professional**: Production systems always validate inputs

**🌟 Real-World Impact:**

**Without Validation:**
```
Starting ETL pipeline...
Loading campsites... ✓
Loading activities... ✓
Loading bookings... ✓
Transforming data... ✓
Loading to database...
❌ ERROR after 45 minutes: Connection refused (port 99999 invalid)
```

**With Validation:**
```
Validating configuration...
❌ Database port out of range: 99999 (must be 1-65535)

Fix takes 10 seconds, pipeline runs successfully!
```

---

#### 📚 The "Fail Fast" Philosophy

**Principle:** Detect and report errors as early as possible.

**Timeline Comparison:**

```
Without Validation:
Config → Extract (30m) → Transform (15m) → Load → ❌ FAIL (45 minutes wasted)

With Validation:
Config → Validate (2s) → ❌ FAIL → Fix (10s) → ✅ SUCCESS (saved 45 minutes!)
```

**Cost of Late Detection:**
- **Time**: Hours of processing wasted
- **Resources**: CPU, memory, disk I/O used unnecessarily
- **Data**: Partial outputs need cleanup
- **Debugging**: Hard to trace root cause
- **Stress**: Deadline pressure if discovered late

---

#### 🔍 Complete Implementation

Add to `src/config_manager.py`:

```python
class ConfigurationManager:
    """Enhanced with validation."""
    
    # ... existing __init__, load, get methods ...
    
    def validate(self):
        """Validate configuration values comprehensively.
        
        Performs 5 types of validation:
        1. Structure validation (required sections exist)
        2. Source validation (files exist and are readable)
        3. Output validation (format valid, directory writable)
        4. Logging validation (log level valid)
        5. Database validation (if configured)
        
        Returns:
            tuple: (is_valid: bool, error_messages: list)
        
        Example:
            >>> config = ConfigurationManager('config.json')
            >>> config.load()
            >>> is_valid, errors = config.validate()
            >>> 
            >>> if not is_valid:
            ...     for error in errors:
            ...         print(f"❌ {error}")
            ...     exit(1)
            >>> else:
            ...     print("✅ All checks passed!")
        """
        errors = []  # Collect all errors (don't stop at first)
        
        # 1. Check required sections exist
        required_sections = ['sources', 'output', 'logging']
        for section in required_sections:
            if section not in self.__config:
                errors.append(f"Missing required section: [{section}]")
        
        # 2. Validate sources
        if 'sources' in self.__config:
            sources = self.__config['sources']
            
            # Check at least one source exists
            if not sources:
                errors.append("At least one data source must be configured in [sources]")
            
            # Validate file paths exist
            for source_name, source_path in sources.items():
                if isinstance(source_path, str):  # File path
                    from pathlib import Path
                    if not Path(source_path).exists():
                        errors.append(f"Source file not found: {source_name} → {source_path}")
        
        # 3. Validate output configuration
        if 'output' in self.__config:
            output = self.__config['output']
            
            # Check format is valid
            if 'format' in output:
                valid_formats = ['json', 'csv']
                if output['format'] not in valid_formats:
                    errors.append(f"Invalid output format: {output['format']} (must be {valid_formats})")
            
            # Check directory is writable
            if 'directory' in output:
                from pathlib import Path
                output_dir = Path(output['directory'])
                try:
                    output_dir.mkdir(parents=True, exist_ok=True)
                except PermissionError:
                    errors.append(f"Output directory not writable: {output_dir}")
        
        # 4. Validate logging configuration
        if 'logging' in self.__config:
            logging = self.__config['logging']
            
            # Check log level is valid
            if 'level' in logging:
                valid_levels = ['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL']
                if logging['level'] not in valid_levels:
                    errors.append(f"Invalid log level: {logging['level']} (must be {valid_levels})")
        
        # 5. Validate database configuration (if present)
        if 'database' in self.__config:
            db = self.__config['database']
            required_db_fields = ['host', 'port', 'database', 'user']
            
            for field in required_db_fields:
                if field not in db:
                    errors.append(f"Missing database field: {field}")
            
            # Check port is numeric and in valid range
            if 'port' in db:
                try:
                    port = int(db['port'])
                    if port < 1 or port > 65535:
                        errors.append(f"Database port out of range: {port} (must be 1-65535)")
                except (ValueError, TypeError):
                    errors.append(f"Database port must be a number: {db['port']}")
        
        # Return validation result
        is_valid = len(errors) == 0
        return is_valid, errors
    
    def validate_or_exit(self):
        """Validate configuration and exit if invalid.
        
        Convenience method that validates and exits on error.
        Use this at the start of your ETL pipeline.
        
        Example:
            >>> config = ConfigurationManager('config.json')
            >>> config.load()
            >>> config.validate_or_exit()  # Exits with error code 1 if invalid
            >>> # Only reaches here if validation passed
        """
        is_valid, errors = self.validate()
        
        if not is_valid:
            print("\n" + "="*70)
            print("❌ CONFIGURATION VALIDATION FAILED")
            print("="*70)
            
            for i, error in enumerate(errors, 1):
                print(f"{i}. {error}")
            
            print("\nPlease fix the configuration file and try again.")
            print("="*70 + "\n")
            
            import sys
            sys.exit(1)  # Exit with error code
        
        print("✅ Configuration validation passed")
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Initialize Error Collection**

```python
errors = []  # Collect all errors (don't stop at first)
```

**🔍 Why use a list:**
- Shows **ALL** errors at once
- User can fix everything in one pass
- Don't stop at first error (annoying!)

**Example:**
```python
# Bad approach (stop at first error):
if 'sources' not in config:
    raise ValueError("Missing sources")  # User only sees this
# They fix it, run again, see next error, fix, run again... frustrating!

# Good approach (collect all errors):
if 'sources' not in config:
    errors.append("Missing sources")
if 'output' not in config:
    errors.append("Missing output")  # Collected!
# User sees both errors, fixes both at once!
```

---

**Part 2: Validate Required Sections**

```python
required_sections = ['sources', 'output', 'logging']
for section in required_sections:
    if section not in self.__config:
        errors.append(f"Missing required section: [{section}]")
```

**🔍 How it works:**
1. Define list of required sections
2. Loop through each one
3. Check if it exists in config dictionary
4. If not, add error message

**Example:**
```python
# Config file (missing 'output'):
{
    "sources": {"campsites": "data/campsites.json"},
    "logging": {"level": "INFO"}
}

# Validation:
required_sections = ['sources', 'output', 'logging']

# Loop iteration 1:
'sources' in config?  → Yes ✓

# Loop iteration 2:
'output' in config?   → No ❌
errors.append("Missing required section: [output]")

# Loop iteration 3:
'logging' in config?  → Yes ✓

# Result: errors = ["Missing required section: [output]"]
```

---

**Part 3: Validate Source Files Exist**

```python
if 'sources' in self.__config:
    sources = self.__config['sources']
    
    # Check at least one source exists
    if not sources:
        errors.append("At least one data source must be configured in [sources]")
    
    # Validate file paths exist
    for source_name, source_path in sources.items():
        if isinstance(source_path, str):  # File path
            from pathlib import Path
            if not Path(source_path).exists():
                errors.append(f"Source file not found: {source_name} → {source_path}")
```

**🔍 Three checks:**

**Check 1: Section exists**
```python
if 'sources' in self.__config:  # Only validate if section exists
```

**Check 2: Not empty**
```python
if not sources:  # Empty dict {} or None
    errors.append("At least one data source must be configured")
```

**Check 3: Files exist**
```python
for source_name, source_path in sources.items():
    # source_name = "campsites"
    # source_path = "data/campsites.json"
    
    if isinstance(source_path, str):  # Make sure it's a path, not dict
        from pathlib import Path
        if not Path(source_path).exists():
            # File doesn't exist!
            errors.append(f"Source file not found: {source_name} → {source_path}")
```

**Example:**
```python
# Config:
{
    "sources": {
        "campsites": "data/campsites.json",      # ✓ Exists
        "activities": "data/activities.json",    # ✓ Exists
        "bookings": "data/missing.json"          # ❌ Doesn't exist
    }
}

# Validation result:
errors = ["Source file not found: bookings → data/missing.json"]
```

---

**Part 4: Validate Output Format and Directory**

```python
if 'output' in self.__config:
    output = self.__config['output']
    
    # Check format is valid
    if 'format' in output:
        valid_formats = ['json', 'csv']
        if output['format'] not in valid_formats:
            errors.append(f"Invalid output format: {output['format']} (must be {valid_formats})")
    
    # Check directory is writable
    if 'directory' in output:
        from pathlib import Path
        output_dir = Path(output['directory'])
        try:
            output_dir.mkdir(parents=True, exist_ok=True)
        except PermissionError:
            errors.append(f"Output directory not writable: {output_dir}")
```

**🔍 Format validation:**

```python
valid_formats = ['json', 'csv']  # Only these are supported
if output['format'] not in valid_formats:
    # User typed 'JSON' (uppercase) or 'xml' (unsupported)
    errors.append(f"Invalid output format: {output['format']} (must be {valid_formats})")
```

**Examples:**
```python
# Valid:
{"format": "json"}  ✓
{"format": "csv"}   ✓

# Invalid:
{"format": "JSON"}  ❌ (case-sensitive)
{"format": "xml"}   ❌ (not supported)
{"format": "excel"} ❌ (not supported)
```

**🔍 Directory writable check:**

```python
output_dir = Path(output['directory'])
try:
    output_dir.mkdir(parents=True, exist_ok=True)
    # parents=True   → Create parent dirs if needed (like mkdir -p)
    # exist_ok=True  → Don't error if already exists
except PermissionError:
    # User doesn't have write permission
    errors.append(f"Output directory not writable: {output_dir}")
```

**Why this works:**
- Tries to create directory
- If successful → Directory is writable ✓
- If PermissionError → Can't write ❌
- Creates missing directories automatically!

---

**Part 5: Validate Logging Level**

```python
if 'logging' in self.__config:
    logging = self.__config['logging']
    
    if 'level' in logging:
        valid_levels = ['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL']
        if logging['level'] not in valid_levels:
            errors.append(f"Invalid log level: {logging['level']} (must be {valid_levels})")
```

**🔍 Python logging levels:**

```
DEBUG     → Most detailed (everything)
INFO      → General information
WARNING   → Something unexpected
ERROR     → Error occurred
CRITICAL  → System failure
```

**Example:**
```python
# Valid:
{"level": "INFO"}  ✓
{"level": "ERROR"} ✓

# Invalid:
{"level": "info"}     ❌ (must be uppercase)
{"level": "TRACE"}    ❌ (not a Python logging level)
{"level": "VERBOSE"}  ❌ (not standard)
```

---

**Part 6: Validate Database Configuration**

```python
if 'database' in self.__config:
    db = self.__config['database']
    required_db_fields = ['host', 'port', 'database', 'user']
    
    # Check all required fields exist
    for field in required_db_fields:
        if field not in db:
            errors.append(f"Missing database field: {field}")
    
    # Check port is numeric and in valid range
    if 'port' in db:
        try:
            port = int(db['port'])  # Convert to integer
            if port < 1 or port > 65535:
                errors.append(f"Database port out of range: {port} (must be 1-65535)")
        except (ValueError, TypeError):
            errors.append(f"Database port must be a number: {db['port']}")
```

**🔍 Port validation breakdown:**

```python
try:
    port = int(db['port'])  # Try to convert to integer
    
    # Check valid port range (1-65535)
    if port < 1 or port > 65535:
        errors.append(f"Database port out of range: {port}")
        
except (ValueError, TypeError):
    # ValueError:  port = "abc" (can't convert to int)
    # TypeError:   port = None or complex type
    errors.append(f"Database port must be a number: {db['port']}")
```

**Examples:**
```python
# Valid ports:
{"port": 5432}      ✓ (PostgreSQL default)
{"port": "5432"}    ✓ (String converted to int)
{"port": 3306}      ✓ (MySQL default)

# Invalid ports:
{"port": "abc"}     ❌ ValueError (not a number)
{"port": 0}         ❌ Too low (min is 1)
{"port": 99999}     ❌ Too high (max is 65535)
{"port": -100}      ❌ Negative
{"port": None}      ❌ TypeError (not a number)
```

---

**Part 7: Return Validation Result**

```python
is_valid = len(errors) == 0  # True if no errors
return is_valid, errors
```

**🔍 Return tuple:**
```python
# No errors:
return (True, [])

# Has errors:
return (False, ["Missing section: [output]", "Invalid port: 99999"])
```

**Usage:**
```python
is_valid, errors = config.validate()

if is_valid:
    print("✅ All good!")
else:
    for error in errors:
        print(f"❌ {error}")
```

---

#### 📊 Complete Usage Example

```python
# In main.py:

from src.config_manager import ConfigurationManager
from src.pipeline import ETLPipeline

def main():
    # 1. Load configuration
    config = ConfigurationManager('config/etl_config.json')
    config.load()
    
    # 2. Validate BEFORE running pipeline
    config.validate_or_exit()  # ← NEW! Exits if invalid
    
    # 3. Only reaches here if validation passed
    pipeline = ETLPipeline()
    
    # ... add sources, transformers, loader ...
    
    # 4. Run with confidence (config is valid)
    pipeline.run()

if __name__ == "__main__":
    main()
```

**Output Examples:**

**✅ Valid Configuration:**
```
✅ Configuration validation passed
Starting ETL pipeline...
Loading data from 3 sources...
Transforming data...
Loading to output/processed.json...
✅ Pipeline completed successfully!
```

**❌ Invalid Configuration:**
```
======================================================================
❌ CONFIGURATION VALIDATION FAILED
======================================================================
1. Source file not found: campsites → data/missing.json
2. Invalid output format: xml (must be ['json', 'csv'])
3. Database port out of range: 99999 (must be 1-65535)
4. Missing database field: user

Please fix the configuration file and try again.
======================================================================

Process exited with code 1
```

---

#### 🎯 Real-World Scenario: Production Deployment

```python
# config/production.json
{
    "sources": {
        "campsites": "/data/production/campsites.json",
        "activities": "/data/production/activities.json"
    },
    "output": {
        "directory": "/var/data/output",
        "format": "csv"
    },
    "database": {
        "host": "db.production.com",
        "port": 5432,
        "database": "outdoor_platform",
        "user": "etl_user"
    },
    "logging": {
        "level": "INFO",
        "file": "/var/log/etl/pipeline.log"
    }
}
```

**Validation checks:**
1. ✓ All source files exist at `/data/production/`
2. ✓ Can write to `/var/data/output/`
3. ✓ Database port 5432 is valid
4. ✓ All required database fields present
5. ✓ Logging level "INFO" is valid

**Result:**
```
✅ Configuration validation passed
[2025-10-20 14:30:15] INFO: Starting ETL pipeline...
[2025-10-20 14:30:16] INFO: Loaded 15,247 campsites
[2025-10-20 14:30:17] INFO: Loaded 8,932 activities
[2025-10-20 14:30:18] INFO: Transforming data...
[2025-10-20 14:30:22] INFO: Loaded 24,179 records to database
[2025-10-20 14:30:22] INFO: Pipeline completed successfully!
```

---

#### ✅ Key Takeaways

1. **Fail Fast**: Validate configuration before processing starts
2. **Collect All Errors**: Show all problems at once, not one-by-one
3. **Clear Messages**: Tell user exactly what's wrong and where
4. **Comprehensive Checks**: Structure, types, ranges, file existence, permissions
5. **Exit on Error**: Use `sys.exit(1)` to prevent invalid pipeline runs
6. **Production Ready**: Essential for reliable production systems
7. **Saves Time**: Fix config in seconds instead of debugging failures after hours

**Next**: Add visual progress feedback with progress bars!

---

### Enhancement 1.6: Progress Bar

**🎯 What It Does:**
Shows visual progress bars during ETL operations, providing real-time feedback on extraction, transformation, and loading progress.

**💡 Why It Matters:**
- **User Feedback**: Shows the pipeline is working, not frozen
- **Time Estimates**: Displays ETA (estimated time remaining)
- **Professional Appearance**: Production-quality visual feedback
- **Debugging**: See exactly which step is slow
- **Confidence**: Know how much work remains

**🌟 Before vs After:**

**Without Progress Bar:**
```
Starting ETL pipeline...
(30 seconds of silence... is it working? frozen? crashed?)
Done!
```
**User thinks:** "Is it broken? Should I kill it?" 😰

**With Progress Bar:**
```
Starting ETL pipeline...
Extracting sources: 67%|████████░░░░| 2/3 [00:15<00:07, 1.2source/s]
```
**User thinks:** "Ah, it's working! 7 seconds left!" 😊

---

#### 📚 Installing tqdm

**tqdm** = "progress" in Arabic (تقدّم‎ - taqaddum)

```bash
pip install tqdm
```

**What is tqdm?**
- Most popular Python progress bar library
- Works with any iterable (lists, files, database queries)
- Automatic time estimates
- Customizable appearance
- Minimal code changes

**GitHub:** 28,000+ stars ⭐
**Used by:** NumPy, Pandas, Scikit-learn, Keras, and thousands more

---

#### 🔍 Basic tqdm Usage

**Simple Example:**

```python
from tqdm import tqdm
import time

# Without tqdm:
for i in range(100):
    time.sleep(0.1)  # Simulate work
# User sees nothing for 10 seconds

# With tqdm:
for i in tqdm(range(100)):
    time.sleep(0.1)  # Simulate work
# Output: 100%|████████████████████| 100/100 [00:10<00:00, 9.99it/s]
```

**What it shows:**
- `100%` - Percentage complete
- `████████████████████` - Visual bar
- `100/100` - Items processed / Total items
- `[00:10<00:00]` - Elapsed time / Time remaining
- `9.99it/s` - Items per second (speed)

---

#### 🔍 tqdm with Manual Updates

```python
from tqdm import tqdm

# When you can't use a for loop:
with tqdm(total=1000, desc="Processing", unit="row") as pbar:
    for batch in get_batches():
        process(batch)
        pbar.update(len(batch))  # Update by batch size

# Output:
# Processing: 450/1000 45%|█████░░░░░| [00:05<00:06, 90.5row/s]
```

**Parameters:**
- `total=1000` - Total number of items
- `desc="Processing"` - Description text
- `unit="row"` - Unit name (appears as "row/s")
- `pbar.update(n)` - Increment progress by n

---

#### 📊 Implementation in ETL Pipeline

Add to `src/pipeline.py`:

```python
from tqdm import tqdm

class ETLPipeline:
    """Enhanced with progress bars."""
    
    # ... existing __init__, add_source, etc. ...
    
    def _extract_phase(self):
        """Extract with progress bar.
        
        Shows:
        - Which source is being extracted
        - Progress through all sources
        - Speed (sources per second)
        - Time remaining
        """
        print(f"\n{'='*70}")
        print(f"📥 EXTRACT PHASE")
        print(f"{'='*70}\n")
        
        all_data = []
        
        # Create progress bar for sources
        with tqdm(total=len(self.sources), desc="Extracting sources", unit="source") as pbar:
            for source in self.sources:
                try:
                    # Update description to show current source
                    pbar.set_description(f"Extracting {source.name}")
                    
                    # Extract data
                    source.connect()
                    data = source.extract()
                    source.disconnect()
                    
                    # Collect data
                    all_data.extend(data)
                    self.statistics.add_source(len(data))
                    
                    # Update progress
                    pbar.update(1)  # Increment by 1 source
                    
                except Exception as e:
                    self.logger.error(f"Failed to extract from {source.name}: {str(e)}")
                    self.statistics.add_error(f"Extract error: {source.name} - {str(e)}")
                    pbar.update(1)  # Still update (mark as attempted)
        
        print(f"\n✅ Extract phase complete: {len(all_data)} total rows\n")
        return all_data
    
    def _transform_phase(self, data):
        """Transform with progress bar.
        
        Shows progress through transformation pipeline.
        """
        if not self.transformation:
            return data
        
        print(f"\n{'='*70}")
        print(f"🔄 TRANSFORM PHASE")
        print(f"{'='*70}\n")
        
        try:
            # If we want to show progress per row:
            transformed = []
            
            with tqdm(total=len(data), desc="Transforming rows", unit="row") as pbar:
                # Option 1: Transform all at once (fast, but no granular progress)
                transformed = self.transformation.transform(data)
                pbar.update(len(data))
                
                # Option 2: Transform row by row (slow, but shows real progress)
                # for row in data:
                #     transformed.append(self.transformation.transform([row])[0])
                #     pbar.update(1)
            
            self.statistics.set_transformed(len(transformed))
            print(f"\n✅ Transform phase complete: {len(transformed)} rows\n")
            return transformed
        
        except Exception as e:
            self.logger.error(f"Transformation failed: {str(e)}")
            self.statistics.add_error(f"Transform error: {str(e)}")
            raise
    
    def _load_phase(self, data):
        """Load with progress bar.
        
        Shows progress during data loading.
        """
        if not self.loader:
            raise Exception("No loader set!")
        
        print(f"\n{'='*70}")
        print(f"📤 LOAD PHASE")
        print(f"{'='*70}\n")
        
        try:
            self.loader.connect()
            
            # Show progress while loading
            with tqdm(total=len(data), desc="Loading rows", unit="row") as pbar:
                # Most loaders batch-load all at once
                self.loader.load(data)
                pbar.update(len(data))  # Update all at once
                
                # For chunked loading (more granular progress):
                # chunk_size = 1000
                # for i in range(0, len(data), chunk_size):
                #     chunk = data[i:i+chunk_size]
                #     self.loader.load(chunk)
                #     pbar.update(len(chunk))
            
            self.loader.disconnect()
            self.statistics.set_loaded(self.loader.get_loaded_count())
            
            print(f"\n✅ Load phase complete\n")
        
        except Exception as e:
            self.logger.error(f"Load failed: {str(e)}")
            self.statistics.add_error(f"Load error: {str(e)}")
            raise
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Create Progress Bar**

```python
with tqdm(total=len(self.sources), desc="Extracting sources", unit="source") as pbar:
```

**� Parameter breakdown:**

- `total=len(self.sources)` - Total items (e.g., 3 sources)
- `desc="Extracting sources"` - Label shown before the bar
- `unit="source"` - What we're counting (shows as "source/s")
- `as pbar` - Variable name for the progress bar

**Example:**
```python
sources = [FileSource("A"), FileSource("B"), FileSource("C")]
with tqdm(total=len(sources), desc="Extracting sources", unit="source") as pbar:
    # Creates:
    # Extracting sources:   0%|              | 0/3 [00:00<?, ?source/s]
```

---

**Part 2: Update Description Dynamically**

```python
pbar.set_description(f"Extracting {source.name}")
```

**🔍 What it does:**
- Changes the description text in real-time
- Shows which specific source is being processed
- User sees exactly what's happening

**Example:**
```python
# Iteration 1:
pbar.set_description("Extracting Campsites")
# Output: Extracting Campsites:  33%|████░░░░░| 1/3 [00:05<00:10, 0.2source/s]

# Iteration 2:
pbar.set_description("Extracting Activities")
# Output: Extracting Activities: 67%|████████░| 2/3 [00:08<00:04, 0.3source/s]

# Iteration 3:
pbar.set_description("Extracting Bookings")
# Output: Extracting Bookings:  100%|██████████| 3/3 [00:12<00:00, 0.25source/s]
```

---

**Part 3: Update Progress**

```python
pbar.update(1)  # Increment by 1 source
```

**🔍 How update works:**

```python
# Initial state:
# Progress: 0/3 (0%)

# After pbar.update(1):
# Progress: 1/3 (33%)

# After pbar.update(1):
# Progress: 2/3 (67%)

# After pbar.update(1):
# Progress: 3/3 (100%)
```

**Can update by any amount:**
```python
pbar.update(5)    # Increment by 5
pbar.update(100)  # Increment by 100

# Useful for batch processing:
for batch in batches:
    process(batch)
    pbar.update(len(batch))  # Update by batch size
```

---

**Part 4: Context Manager (with statement)**

```python
with tqdm(...) as pbar:
    # Do work
    pbar.update(1)
# Progress bar automatically closes here
```

**🔍 Why use `with`:**
- Automatically closes/cleans up the progress bar
- Ensures final state is shown (100%)
- Prevents broken terminal output
- Exception-safe (closes even on error)

**Without `with` (manual):**
```python
pbar = tqdm(total=100)
try:
    for i in range(100):
        pbar.update(1)
finally:
    pbar.close()  # Must manually close!
```

**With `with` (automatic):**
```python
with tqdm(total=100) as pbar:
    for i in range(100):
        pbar.update(1)
# Automatically closed!
```

---

#### 📊 Complete Example Output

```
======================================================================
📥 EXTRACT PHASE
======================================================================

Extracting Campsites:   33%|████░░░░░░░░| 1/3 [00:02<00:04, 0.45source/s]
Extracting Activities:  67%|████████░░░░| 2/3 [00:05<00:02, 0.38source/s]
Extracting Bookings:   100%|████████████| 3/3 [00:08<00:00, 0.35source/s]

✅ Extract phase complete: 1500 total rows

======================================================================
🔄 TRANSFORM PHASE
======================================================================

Transforming rows: 100%|████████████████| 1500/1500 [00:03<00:00, 450.2row/s]

✅ Transform phase complete: 1500 rows

======================================================================
📤 LOAD PHASE
======================================================================

Loading rows: 100%|██████████████████████| 1500/1500 [00:01<00:00, 1200.5row/s]

✅ Load phase complete

======================================================================
📊 PIPELINE STATISTICS
======================================================================
Sources Processed:   3
Total Rows Extracted: 1500
Rows Transformed:    1500
Rows Loaded:         1500
Errors:              0
Duration:            12.5 seconds
======================================================================
```

---

#### 🎯 Advanced: Custom Progress Bar Appearance

```python
from tqdm import tqdm

# Custom colors and format:
with tqdm(
    total=1000,
    desc="Processing",
    unit="row",
    bar_format='{desc}: {percentage:3.0f}%|{bar}| {n_fmt}/{total_fmt} [{elapsed}<{remaining}, {rate_fmt}]',
    colour='green',  # Bar color: 'green', 'red', 'blue', etc.
    ncols=80,        # Bar width in characters
    ascii=False      # Use Unicode characters (█) vs ASCII (#)
) as pbar:
    for i in range(1000):
        process(i)
        pbar.update(1)
```

**Custom Format Codes:**
- `{desc}` - Description text
- `{percentage:3.0f}%` - Percentage (3 digits, no decimals)
- `{bar}` - The visual bar itself
- `{n_fmt}/{total_fmt}` - Current/Total (formatted)
- `{elapsed}` - Time elapsed
- `{remaining}` - Time remaining
- `{rate_fmt}` - Speed (items/second)

---

#### 💡 Nested Progress Bars

For complex pipelines with sub-steps:

```python
from tqdm import tqdm

sources = ["Campsites", "Activities", "Bookings"]

# Outer progress bar: Sources
with tqdm(total=len(sources), desc="Sources", position=0) as outer:
    for source in sources:
        outer.set_description(f"Processing {source}")
        
        # Inner progress bar: Rows within source
        with tqdm(total=500, desc=f"  {source} rows", position=1, leave=False) as inner:
            for row in range(500):
                process(row)
                inner.update(1)
        
        outer.update(1)

# Output:
# Sources:         33%|████░░░░░░| 1/3 [00:05<00:10, 0.2source/s]
#   Campsites rows: 80%|████████░ | 400/500 [00:02<00:00, 200.5row/s]
```

**Parameters:**
- `position=0` - Top-level bar
- `position=1` - Nested bar (below position 0)
- `leave=False` - Remove bar when done (cleaner output)

---

#### 🌍 Real-World Scenario: Large Dataset

```python
# Processing 1 million rows with progress feedback:

from tqdm import tqdm
import time

def process_large_dataset():
    """ETL pipeline for 1 million rows."""
    
    # Extract phase
    print("\n📥 Extracting data from database...")
    data = []
    
    with tqdm(total=1000000, desc="Fetching rows", unit="row") as pbar:
        # Fetch in batches of 10,000
        for offset in range(0, 1000000, 10000):
            batch = fetch_batch(offset, 10000)
            data.extend(batch)
            pbar.update(len(batch))
    
    # Transform phase
    print("\n🔄 Transforming data...")
    transformed = []
    
    with tqdm(total=len(data), desc="Transforming", unit="row") as pbar:
        # Process in chunks for memory efficiency
        chunk_size = 1000
        for i in range(0, len(data), chunk_size):
            chunk = data[i:i+chunk_size]
            transformed.extend(transform_chunk(chunk))
            pbar.update(len(chunk))
    
    # Load phase
    print("\n📤 Loading to destination...")
    
    with tqdm(total=len(transformed), desc="Loading", unit="row") as pbar:
        # Batch insert (much faster)
        batch_size = 5000
        for i in range(0, len(transformed), batch_size):
            batch = transformed[i:i+batch_size]
            bulk_insert(batch)
            pbar.update(len(batch))
    
    print("\n✅ Pipeline complete!")

# Output:
# 📥 Extracting data from database...
# Fetching rows: 100%|████████████| 1000000/1000000 [01:23<00:00, 12000.5row/s]
#
# 🔄 Transforming data...
# Transforming: 100%|█████████████| 1000000/1000000 [00:45<00:00, 22150.3row/s]
#
# 📤 Loading to destination...
# Loading: 100%|██████████████████| 1000000/1000000 [00:30<00:00, 33450.2row/s]
#
# ✅ Pipeline complete!
# Total time: 2 minutes 38 seconds
```

---

#### ✅ Key Takeaways

1. **tqdm is Simple**: Just wrap any iterable or use manual `update()`
2. **Visual Feedback**: Shows percentage, speed, time remaining
3. **Professional**: Makes your ETL look production-ready
4. **Debugging**: See which step is slow immediately
5. **User Confidence**: No more "is it frozen?" anxiety
6. **Nested Support**: Show progress at multiple levels
7. **Customizable**: Colors, formats, appearance all configurable
8. **Zero Overhead**: Minimal performance impact (~0.01% slowdown)

**Next Steps**: Move to Level 2 - Intermediate Enhancements with real database connections!

---

## 📗 Level 2: Intermediate Enhancements

### Enhancement 2.1: Real PostgreSQL Database Connection

**🎯 What It Does:**
Connects to a real PostgreSQL database and loads data using production-ready techniques: connection management, transactions, batch inserts, and error handling.

**💡 Why It Matters:**
- **Production Ready**: Real database integration, not file-based simulation
- **Performance**: Batch inserts are 100x faster than row-by-row
- **Reliability**: Transactions ensure data consistency (all-or-nothing)
- **Industry Standard**: PostgreSQL is the #1 open-source database
- **Career Skills**: Database connectivity is essential for data engineers

**🌟 Real-World Impact:**

**Loading 10,000 rows:**
- **Row-by-row**: 15 minutes ⏱️ (slow, locks database)
- **Batch inserts**: 9 seconds ⚡ (100x faster!)

---

#### 📚 What is psycopg2?

**psycopg2** = PostgreSQL adapter for Python

- Most popular PostgreSQL library for Python
- Used by Django, SQLAlchemy, Pandas
- Supports all PostgreSQL features
- Thread-safe and production-ready

**Installation:**
```bash
pip install psycopg2-binary
```

**Two versions:**
- `psycopg2` - Requires compilation, faster
- `psycopg2-binary` - Pre-compiled, easier to install

**For development**: Use `psycopg2-binary`  
**For production**: Use `psycopg2` (better performance)

---

#### 🔍 Complete PostgreSQL Loader Implementation

Add to `src/loaders.py`:

```python
import psycopg2
from psycopg2.extras import execute_batch
from psycopg2 import pool

class PostgreSQLLoader(DataLoader):
    """Real PostgreSQL loader with production features.
    
    Features:
    - Real database connection using psycopg2
    - Transaction support (commit/rollback)
    - Batch inserts for speed (100x faster)
    - UPSERT support (INSERT ... ON CONFLICT)
    - Automatic table creation
    - Connection timeout handling
    - Error recovery
    
    Example:
        >>> config = {
        ...     'host': 'localhost',
        ...     'port': 5432,
        ...     'database': 'camping_db',
        ...     'user': 'postgres',
        ...     'password': 'secret123'
        ... }
        >>> loader = PostgreSQLLoader("PostgreSQL", config, "campsites", batch_size=500)
        >>> loader.connect()
        >>> loader.load(data)
        >>> loader.disconnect()
    """
    
    def __init__(self, name, config, table_name, batch_size=1000):
        """Initialize PostgreSQL loader.
        
        Args:
            name: Loader name for logging
            config: Database config dictionary:
                - host: Database host (e.g., 'localhost', 'db.example.com')
                - port: Database port (default: 5432)
                - database: Database name
                - user: Username for authentication
                - password: Password for authentication
            table_name: Target table name
            batch_size: Number of rows per batch insert (default: 1000)
        
        Example:
            >>> config = {
            ...     'host': 'localhost',
            ...     'port': 5432,
            ...     'database': 'camping_db',
            ...     'user': 'postgres',
            ...     'password': 'secret123'
            ... }
            >>> loader = PostgreSQLLoader("PostgreSQL", config, "campsites", batch_size=500)
            #    🗄️  Database: camping_db
            #    📊 Table: campsites
            #    📦 Batch size: 500
        """
        super().__init__(name, "PostgreSQL")
        self.config = config
        self.table_name = table_name
        self.batch_size = batch_size
        self.connection = None
        self.cursor = None
        
        # Display configuration
        print(f"   🗄️  Database: {config['database']}")
        print(f"   📊 Table: {table_name}")
        print(f"   📦 Batch size: {batch_size}")
    
    def connect(self):
        """Connect to PostgreSQL database.
        
        Establishes connection, tests it, and displays version.
        Uses 10-second timeout to prevent hanging.
        
        Raises:
            psycopg2.OperationalError: If connection fails (wrong credentials, host unreachable, etc.)
        
        Example:
            >>> loader.connect()
            📡 Connecting to PostgreSQL at localhost:5432...
            ✅ Connected to PostgreSQL
               Version: PostgreSQL 15.3
        """
        print(f"📡 Connecting to PostgreSQL at {self.config['host']}:{self.config['port']}...")
        
        try:
            # Create connection
            self.connection = psycopg2.connect(
                host=self.config['host'],
                port=self.config['port'],
                database=self.config['database'],
                user=self.config['user'],
                password=self.config['password'],
                connect_timeout=10  # 10 second timeout (prevents hanging)
            )
            
            # Set autocommit to False (we'll commit manually for transactions)
            self.connection.autocommit = False
            
            # Create cursor (used to execute SQL)
            self.cursor = self.connection.cursor()
            
            # Test connection with version query
            self.cursor.execute("SELECT version();")
            version = self.cursor.fetchone()[0]
            
            print(f"✅ Connected to PostgreSQL")
            print(f"   Version: {version.split(',')[0]}")
            
        except psycopg2.OperationalError as e:
            print(f"❌ Failed to connect to PostgreSQL: {e}")
            raise
    
    def load(self, data):
        """Load data to PostgreSQL table using batch inserts.
        
        Features:
        - Batch inserts for 100x speed improvement
        - UPSERT support (updates on conflict)
        - Automatic column detection
        - Transaction support (all-or-nothing)
        
        Args:
            data: List of dictionaries to insert
        
        Example:
            >>> data = [
            ...     {'id': 1, 'name': 'Camp A', 'price': 100},
            ...     {'id': 2, 'name': 'Camp B', 'price': 150}
            ... ]
            >>> loader.load(data)
            💾 Loading 2 rows to table campsites...
            ✅ Loaded 2 rows to PostgreSQL
        """
        if not self.connection:
            raise Exception("Not connected! Call connect() first.")
        
        if not data:
            print("⚠️  No data to load")
            return
        
        print(f"💾 Loading {len(data)} rows to table {self.table_name}...")
        
        try:
            # Get columns from first row
            columns = list(data[0].keys())
            placeholders = ', '.join(['%s'] * len(columns))
            columns_str = ', '.join(columns)
            
            # Build INSERT query with UPSERT (ON CONFLICT)
            query = f"""
                INSERT INTO {self.table_name} ({columns_str})
                VALUES ({placeholders})
                ON CONFLICT (id) DO UPDATE SET
                {', '.join([f"{col} = EXCLUDED.{col}" for col in columns if col != 'id'])}
            """
            
            # Prepare data as tuples (required by psycopg2)
            values = [tuple(row.get(col) for col in columns) for row in data]
            
            # Execute batch insert (much faster than executemany)
            execute_batch(self.cursor, query, values, page_size=self.batch_size)
            
            # Commit transaction (make changes permanent)
            self.connection.commit()
            
            self.loaded_count = len(data)
            print(f"✅ Loaded {self.loaded_count} rows to PostgreSQL")
            
        except psycopg2.Error as e:
            # Rollback on error (undo all changes)
            self.connection.rollback()
            print(f"❌ Database error: {e}")
            raise
    
    def disconnect(self):
        """Disconnect from PostgreSQL.
        
        Closes cursor and connection properly.
        """
        if self.cursor:
            self.cursor.close()
        if self.connection:
            self.connection.close()
        super().disconnect()
    
    def create_table_if_not_exists(self, schema):
        """Create table if it doesn't exist.
        
        Useful for initial setup or auto-creating destination tables.
        
        Args:
            schema: Dictionary of {column_name: sql_type}
        
        Example:
            >>> schema = {
            ...     'id': 'SERIAL PRIMARY KEY',
            ...     'name': 'VARCHAR(255) NOT NULL',
            ...     'state': 'VARCHAR(2)',
            ...     'price': 'DECIMAL(10,2)',
            ...     'created_at': 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
            ... }
            >>> loader.create_table_if_not_exists(schema)
            ✅ Table campsites ready
        """
        if not self.connection:
            raise Exception("Not connected!")
        
        # Build CREATE TABLE statement
        columns_def = ',\n    '.join([f"{col} {dtype}" for col, dtype in schema.items()])
        
        create_query = f"""
            CREATE TABLE IF NOT EXISTS {self.table_name} (
                {columns_def}
            );
        """
        
        try:
            self.cursor.execute(create_query)
            self.connection.commit()
            print(f"✅ Table {self.table_name} ready")
        except psycopg2.Error as e:
            self.connection.rollback()
            print(f"❌ Failed to create table: {e}")
            raise
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Connection Parameters**

```python
self.connection = psycopg2.connect(
    host=self.config['host'],          # Database server address
    port=self.config['port'],          # Port (default: 5432)
    database=self.config['database'],  # Database name
    user=self.config['user'],          # Username
    password=self.config['password'],  # Password
    connect_timeout=10                 # Timeout in seconds
)
```

**🔍 What each parameter does:**

- `host`: Where is the database? (`'localhost'`, `'192.168.1.100'`, `'db.example.com'`)
- `port`: Which port? (PostgreSQL default is 5432)
- `database`: Which database on that server?
- `user`: Who is connecting?
- `password`: Authentication
- `connect_timeout`: How long to wait before giving up (prevents hanging forever)

**Example scenarios:**
```python
# Local development:
psycopg2.connect(host='localhost', port=5432, database='camping_db', ...)

# Remote server:
psycopg2.connect(host='db.production.com', port=5432, database='camping_prod', ...)

# Docker container:
psycopg2.connect(host='postgres-container', port=5432, database='camping_db', ...)
```

---

**Part 2: Autocommit and Transactions**

```python
self.connection.autocommit = False
```

**🔍 What is autocommit:**

**autocommit=True** (automatic):
```python
execute("INSERT INTO users VALUES (1, 'Alice')")  # Immediately saved!
execute("INSERT INTO users VALUES (2, 'Bob')")    # Immediately saved!
# Can't undo if something goes wrong
```

**autocommit=False** (manual - better control):
```python
execute("INSERT INTO users VALUES (1, 'Alice')")  # Not saved yet
execute("INSERT INTO users VALUES (2, 'Bob')")    # Not saved yet
connection.commit()  # NOW both are saved together!

# Or if error:
connection.rollback()  # Undo everything!
```

**Why manual is better:**
- **All-or-nothing**: Either all rows load or none (data consistency)
- **Rollback on error**: Can undo changes if something fails
- **Better performance**: One commit is faster than thousands

---

**Part 3: Cursor Creation**

```python
self.cursor = self.connection.cursor()
```

**🔍 What is a cursor:**

Think of it as a "worker" that executes SQL commands:

```python
cursor = connection.cursor()

# Execute SQL
cursor.execute("SELECT * FROM users WHERE age > 25")

# Fetch results
rows = cursor.fetchall()  # Get all rows
# or
row = cursor.fetchone()  # Get one row

# Close when done
cursor.close()
```

**Cursor vs Connection:**
- **Connection** = Pipe to the database (one per session)
- **Cursor** = Worker that executes commands (can have multiple)

---

**Part 4: Building INSERT Query**

```python
columns = list(data[0].keys())  # ['id', 'name', 'price']
placeholders = ', '.join(['%s'] * len(columns))  # '%s, %s, %s'
columns_str = ', '.join(columns)  # 'id, name, price'

query = f"""
    INSERT INTO {self.table_name} ({columns_str})
    VALUES ({placeholders})
    ON CONFLICT (id) DO UPDATE SET
    {', '.join([f"{col} = EXCLUDED.{col}" for col in columns if col != 'id'])}
"""
```

**🔍 Step-by-step:**

```python
# Given data:
data = [
    {'id': 1, 'name': 'Camp A', 'price': 100},
    {'id': 2, 'name': 'Camp B', 'price': 150}
]

# Step 1: Extract columns
columns = list(data[0].keys())
# Result: ['id', 'name', 'price']

# Step 2: Create placeholders
placeholders = ', '.join(['%s'] * len(columns))
# Result: '%s, %s, %s'
# %s = placeholder for psycopg2 (filled with actual values later)

# Step 3: Join column names
columns_str = ', '.join(columns)
# Result: 'id, name, price'

# Step 4: Build query
query = f"""
    INSERT INTO campsites (id, name, price)
    VALUES (%s, %s, %s)
    ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name, price = EXCLUDED.price
"""
```

**🔍 ON CONFLICT (UPSERT):**

```sql
-- If row with id=1 doesn't exist:
INSERT INTO campsites (id, name, price) VALUES (1, 'Camp A', 100);
-- Row created ✓

-- If row with id=1 already exists:
ON CONFLICT (id) DO UPDATE SET name = 'Camp A', price = 100;
-- Row updated ✓ (not error!)
```

**UPSERT = INSERT + UPDATE**
- Try to INSERT
- If conflict (duplicate id) → UPDATE instead
- No error, always succeeds!

---

**Part 5: Prepare Data as Tuples**

```python
values = [tuple(row.get(col) for col in columns) for row in data]
```

**🔍 Why tuples:**

psycopg2 requires tuples, not dictionaries:

```python
# Data (dictionaries):
data = [
    {'id': 1, 'name': 'Camp A', 'price': 100},
    {'id': 2, 'name': 'Camp B', 'price': 150}
]

# Columns order:
columns = ['id', 'name', 'price']

# Convert to tuples in column order:
values = [tuple(row.get(col) for col in columns) for row in data]
# Result: [(1, 'Camp A', 100), (2, 'Camp B', 150)]

# Why this works:
row = {'id': 1, 'name': 'Camp A', 'price': 100}
row.get('id')     → 1
row.get('name')   → 'Camp A'
row.get('price')  → 100
tuple([1, 'Camp A', 100])  → (1, 'Camp A', 100)
```

---

**Part 6: Batch Insert with execute_batch**

```python
execute_batch(self.cursor, query, values, page_size=self.batch_size)
```

**🔍 Why execute_batch is fast:**

**executemany (slow):**
```python
for row in values:
    cursor.execute(query, row)
# Makes 1000 separate trips to database
# Time: ~60 seconds for 1000 rows
```

**execute_batch (fast):**
```python
execute_batch(cursor, query, values, page_size=100)
# Batches rows: sends 100 at a time
# Makes 10 trips instead of 1000
# Time: ~0.5 seconds for 1000 rows (120x faster!)
```

**page_size parameter:**
```python
page_size=100   # Send 100 rows per batch
page_size=500   # Send 500 rows per batch (faster, more memory)
page_size=1000  # Send 1000 rows per batch (fastest, most memory)
```

**Optimal batch size**: 500-1000 rows

---

**Part 7: Commit and Rollback**

```python
try:
    execute_batch(cursor, query, values)
    connection.commit()  # Save changes!
except psycopg2.Error as e:
    connection.rollback()  # Undo changes!
    raise
```

**🔍 Transaction lifecycle:**

```
BEGIN TRANSACTION
  ├─ INSERT 1000 rows
  ├─ (all successful)
  └─ COMMIT → All rows saved! ✓

BEGIN TRANSACTION
  ├─ INSERT 500 rows (OK)
  ├─ INSERT 500 rows (ERROR: duplicate key)
  └─ ROLLBACK → All 1000 rows discarded! ↶
```

**Why this matters:**
- **Data consistency**: Never have partial data
- **Error recovery**: Can retry from scratch
- **Atomicity**: All-or-nothing guarantee

---

#### 📊 Complete Usage Example

```python
# In main.py:

from src.pipeline import ETLPipeline
from src.sources import FileSource
from src.loaders import PostgreSQLLoader

# Database configuration
db_config = {
    'host': 'localhost',
    'port': 5432,
    'database': 'camping_db',
    'user': 'postgres',
    'password': 'your_password'
}

# Table schema
table_schema = {
    'id': 'SERIAL PRIMARY KEY',
    'name': 'VARCHAR(255) NOT NULL',
    'state': 'VARCHAR(2)',
    'city': 'VARCHAR(255)',
    'price': 'DECIMAL(10,2)',
    'capacity': 'INTEGER',
    'has_wifi': 'BOOLEAN',
    'processed_at': 'TIMESTAMP',
    'etl_version': 'VARCHAR(50)',
    'created_at': 'TIMESTAMP DEFAULT CURRENT_TIMESTAMP'
}

def main():
    # Create pipeline
    pipeline = ETLPipeline()
    pipeline.add_source(FileSource("Campsites", "data/campsites.json"))
    
    # Create PostgreSQL loader
    loader = PostgreSQLLoader("PostgreSQL", db_config, "campsites", batch_size=500)
    
    # Connect and create table
    loader.connect()
    loader.create_table_if_not_exists(table_schema)
    
    # Set loader and run
    pipeline.set_loader(loader)
    pipeline.run()
    
    # Disconnect
    loader.disconnect()

if __name__ == "__main__":
    main()
```

**Output:**
```
   🗄️  Database: camping_db
   📊 Table: campsites
   📦 Batch size: 500

📡 Connecting to PostgreSQL at localhost:5432...
✅ Connected to PostgreSQL
   Version: PostgreSQL 15.3

✅ Table campsites ready

======================================================================
📥 EXTRACT PHASE
======================================================================
Loading data from 3 sources...
✅ Extract phase complete: 1500 total rows

======================================================================
📤 LOAD PHASE
======================================================================
💾 Loading 1500 rows to table campsites...
✅ Loaded 1500 rows to PostgreSQL

✅ Pipeline completed successfully!
```

---

#### �️ Database Setup

**Step 1: Install PostgreSQL**

```bash
# Ubuntu/Debian:
sudo apt update
sudo apt install postgresql postgresql-contrib

# macOS (using Homebrew):
brew install postgresql
brew services start postgresql

# Windows:
# Download installer from postgresql.org
```

**Step 2: Create Database**

```sql
-- Connect to PostgreSQL (default user: postgres)
psql -U postgres

-- Create database
CREATE DATABASE camping_db;

-- Connect to database
\c camping_db

-- Verify connection
SELECT current_database();
```

**Step 3: Query Data**

```sql
-- View all data
SELECT * FROM campsites LIMIT 10;

-- Count rows
SELECT COUNT(*) FROM campsites;

-- Filter by state
SELECT name, city, price 
FROM campsites 
WHERE state = 'MG' 
ORDER BY price DESC;

-- Average price by state
SELECT state, 
       COUNT(*) as count, 
       AVG(price) as avg_price,
       MIN(price) as min_price,
       MAX(price) as max_price
FROM campsites
GROUP BY state
ORDER BY count DESC;
```

---

#### 🎯 Performance Comparison

```python
import time

# Test data: 10,000 rows
test_data = [
    {'id': i, 'name': f'Camp {i}', 'price': 100 + i, 'capacity': 20}
    for i in range(10000)
]

# Method 1: Row-by-row (DON'T DO THIS!)
start = time.time()
for row in test_data:
    cursor.execute("INSERT INTO campsites VALUES (%s, %s, %s, %s)", 
                   (row['id'], row['name'], row['price'], row['capacity']))
    connection.commit()  # Commit each row
row_by_row_time = time.time() - start

# Method 2: Batch insert (GOOD!)
start = time.time()
execute_batch(cursor, query, values, page_size=500)
connection.commit()  # Commit once
batch_time = time.time() - start

print(f"\n📊 Performance Comparison (10,000 rows):")
print(f"{'='*50}")
print(f"Row-by-row:  {row_by_row_time:.2f} seconds")
print(f"Batch:       {batch_time:.2f} seconds")
print(f"Speedup:     {row_by_row_time / batch_time:.1f}x faster!")
print(f"{'='*50}")

# Example output:
# 📊 Performance Comparison (10,000 rows):
# ==================================================
# Row-by-row:  923.45 seconds (15 minutes!)
# Batch:       8.76 seconds
# Speedup:     105.4x faster!
# ==================================================
```

---

#### ✅ Key Takeaways

1. **psycopg2**: Industry-standard PostgreSQL adapter for Python
2. **Connections**: Manage properly (connect, use, disconnect)
3. **Transactions**: Use manual commit for reliability (autocommit=False)
4. **Batch Inserts**: 100x faster than row-by-row
5. **UPSERT**: INSERT ... ON CONFLICT for idempotent loads
6. **Error Handling**: Always rollback on error
7. **Timeout**: Use connect_timeout to prevent hanging
8. **Production Ready**: This is how real ETL pipelines work!

**Next**: Add data deduplication to prevent duplicate records!

---

### Enhancement 2.2: Data Deduplication Transformer

**🎯 What It Does:**
Removes duplicate rows based on specified key fields using configurable strategies (first, last, newest, oldest).

**💡 Why It Matters:**
- **Data Quality**: Prevents duplicate records in database
- **Consistency**: Keeps only one version of each record
- **Flexibility**: Choose which duplicate to keep (first, last, newest, oldest)
- **Composite Keys**: Support multi-field uniqueness (e.g., customer_id + product_id)
- **Production Critical**: Real-world data always has duplicates

**🌟 Real-World Problem:**

```python
# Source data has duplicates (common in real ETL):
data = [
    {'id': 1, 'name': 'Camp A (old)', 'updated_at': '2024-01-01'},
    {'id': 2, 'name': 'Camp B', 'updated_at': '2024-01-01'},
    {'id': 1, 'name': 'Camp A (new)', 'updated_at': '2024-06-15'},  # Duplicate!
    {'id': 3, 'name': 'Camp C', 'updated_at': '2024-02-10'},
    {'id': 2, 'name': 'Camp B (updated)', 'updated_at': '2024-05-20'},  # Duplicate!
]

# Without deduplication → Database error or stale data!
# With deduplication → Clean, current data ✓
```

---

#### 📚 Deduplication Strategies

**4 built-in strategies:**

1. **'first'** - Keep first occurrence (ignores later duplicates)
2. **'last'** - Keep last occurrence (overwrites earlier duplicates)
3. **'max'** - Keep occurrence with maximum comparison_field value (newest date, highest price, etc.)
4. **'min'** - Keep occurrence with minimum comparison_field value (oldest date, lowest price, etc.)

**When to use each:**

```python
# Strategy 1: 'first' - Keep earliest data seen
# Use when: First record is authoritative
dedupe = DeduplicationTransformer(['id'], strategy='first')

# Strategy 2: 'last' - Keep latest data seen
# Use when: Order matters, later records are more current
dedupe = DeduplicationTransformer(['id'], strategy='last')

# Strategy 3: 'max' - Keep newest/highest
# Use when: Want most recent updated_at, or highest price
dedupe = DeduplicationTransformer(['id'], strategy='max', comparison_field='updated_at')

# Strategy 4: 'min' - Keep oldest/lowest
# Use when: Want earliest created_at, or lowest price
dedupe = DeduplicationTransformer(['id'], strategy='min', comparison_field='created_at')
```

---

#### 🔍 Complete Implementation

Add to `src/transformers.py`:

```python
class DeduplicationTransformer(DataTransformer):
    """Remove duplicate rows with configurable strategy.
    
    Supports 4 deduplication strategies:
    - 'first': Keep first occurrence (default)
    - 'last': Keep last occurrence
    - 'max': Keep row with maximum value in comparison_field
    - 'min': Keep row with minimum value in comparison_field
    
    Attributes:
        key_fields: List of field names that define uniqueness
        strategy: Which duplicate to keep ('first', 'last', 'max', 'min')
        comparison_field: Field to compare for 'max'/'min' strategies
        duplicates_removed: Count of duplicates removed
    
    Example:
        >>> # Keep first occurrence of each customer_id
        >>> dedupe = DeduplicationTransformer(['customer_id'], strategy='first')
        >>> 
        >>> # Keep latest by timestamp
        >>> dedupe = DeduplicationTransformer(
        ...     ['customer_id'],
        ...     strategy='max',
        ...     comparison_field='updated_at'
        ... )
        >>> 
        >>> # Composite key: customer_id + product_id
        >>> dedupe = DeduplicationTransformer(
        ...     ['customer_id', 'product_id'],
        ...     strategy='last'
        ... )
    """
    
    def __init__(self, key_fields, strategy='first', comparison_field=None):
        """Initialize deduplication transformer.
        
        Args:
            key_fields: List of fields that define uniqueness.
                        Single field: ['id']
                        Multiple fields: ['customer_id', 'product_id']
            strategy: Deduplication strategy:
                      - 'first': Keep first occurrence
                      - 'last': Keep last occurrence
                      - 'max': Keep maximum comparison_field
                      - 'min': Keep minimum comparison_field
            comparison_field: Field to compare for 'max'/'min' strategies
                             (e.g., 'updated_at', 'price', 'created_at')
        
        Example:
            >>> # Simple: Keep first of each ID
            >>> dedupe = DeduplicationTransformer(['id'], strategy='first')
            >>> 
            >>> # Advanced: Keep latest update
            >>> dedupe = DeduplicationTransformer(
            ...     key_fields=['booking_id'],
            ...     strategy='max',
            ...     comparison_field='updated_at'
            ... )
        """
        super().__init__("Deduplication")
        self.key_fields = key_fields if isinstance(key_fields, list) else [key_fields]
        self.strategy = strategy
        self.comparison_field = comparison_field
        self.duplicates_removed = 0
        
        # Validation
        valid_strategies = ['first', 'last', 'max', 'min']
        if strategy not in valid_strategies:
            raise ValueError(f"Invalid strategy '{strategy}'. Must be one of {valid_strategies}")
        
        if strategy in ['max', 'min'] and not comparison_field:
            raise ValueError(f"Strategy '{strategy}' requires comparison_field parameter")
    
    def transform(self, data):
        """Remove duplicates using specified strategy.
        
        Args:
            data: List of dictionaries
            
        Returns:
            list: Deduplicated data
        
        Example:
            >>> dedupe = DeduplicationTransformer(['id'], strategy='last')
            >>> 
            >>> data = [
            ...     {'id': 1, 'name': 'Old Name', 'updated_at': '2024-01-01'},
            ...     {'id': 2, 'name': 'Camp B', 'updated_at': '2024-01-01'},
            ...     {'id': 1, 'name': 'New Name', 'updated_at': '2024-03-10'},  # Duplicate
            ... ]
            >>> 
            >>> result = dedupe.transform(data)
            ⚙️  Applying transformation: Deduplication...
            ✅ Removed 1 duplicates, kept 2 unique rows
            >>> 
            >>> # Result keeps 'New Name' (last occurrence)
            >>> print(result)
            [
                {'id': 2, 'name': 'Camp B', ...},
                {'id': 1, 'name': 'New Name', ...}
            ]
        """
        super().transform(data)
        
        if not data:
            print("⚠️  No data to deduplicate")
            return data
        
        # Select strategy
        if self.strategy == 'first':
            unique_data = self._dedupe_first(data)
        elif self.strategy == 'last':
            unique_data = self._dedupe_last(data)
        elif self.strategy == 'max':
            unique_data = self._dedupe_max(data)
        elif self.strategy == 'min':
            unique_data = self._dedupe_min(data)
        
        self.duplicates_removed = len(data) - len(unique_data)
        self.transform_count = len(data)
        
        print(f"✅ Removed {self.duplicates_removed} duplicates, kept {len(unique_data)} unique rows")
        return unique_data
    
    def _get_key(self, row):
        """Get unique key tuple from row.
        
        Extracts values for all key_fields and returns as tuple.
        
        Args:
            row: Dictionary
        
        Returns:
            tuple: Key values
        
        Example:
            >>> self.key_fields = ['customer_id', 'product_id']
            >>> row = {'customer_id': 123, 'product_id': 456, 'price': 100}
            >>> self._get_key(row)
            (123, 456)
        """
        return tuple(row.get(field) for field in self.key_fields)
    
    def _dedupe_first(self, data):
        """Keep first occurrence of each key.
        
        Uses set to track seen keys.
        First occurrence is added to result, later ones are ignored.
        
        Args:
            data: List of dictionaries
        
        Returns:
            list: Deduplicated data (first occurrences only)
        
        Example:
            >>> data = [
            ...     {'id': 1, 'version': 'v1'},
            ...     {'id': 2, 'version': 'v1'},
            ...     {'id': 1, 'version': 'v2'},  # Ignored (id=1 already seen)
            ... ]
            >>> result = self._dedupe_first(data)
            [{'id': 1, 'version': 'v1'}, {'id': 2, 'version': 'v1'}]
        """
        seen = set()
        unique_data = []
        
        for row in data:
            key = self._get_key(row)
            if key not in seen:
                seen.add(key)
                unique_data.append(row)
        
        return unique_data
    
    def _dedupe_last(self, data):
        """Keep last occurrence of each key.
        
        Uses dictionary to store rows by key.
        Later occurrences overwrite earlier ones.
        
        Args:
            data: List of dictionaries
        
        Returns:
            list: Deduplicated data (last occurrences only)
        
        Example:
            >>> data = [
            ...     {'id': 1, 'version': 'v1'},
            ...     {'id': 2, 'version': 'v1'},
            ...     {'id': 1, 'version': 'v2'},  # Overwrites first id=1
            ... ]
            >>> result = self._dedupe_last(data)
            [{'id': 1, 'version': 'v2'}, {'id': 2, 'version': 'v1'}]
        """
        unique_dict = {}
        
        for row in data:
            key = self._get_key(row)
            unique_dict[key] = row  # Overwrites previous
        
        return list(unique_dict.values())
    
    def _dedupe_max(self, data):
        """Keep occurrence with maximum comparison_field value.
        
        Compares values in comparison_field.
        Keeps row with highest value for each key.
        
        Args:
            data: List of dictionaries
        
        Returns:
            list: Deduplicated data (maximum values)
        
        Example:
            >>> self.comparison_field = 'updated_at'
            >>> data = [
            ...     {'id': 1, 'updated_at': '2024-01-01'},
            ...     {'id': 1, 'updated_at': '2024-06-15'},  # Newer (kept)
            ...     {'id': 2, 'updated_at': '2024-03-10'},
            ... ]
            >>> result = self._dedupe_max(data)
            [{'id': 1, 'updated_at': '2024-06-15'}, {'id': 2, 'updated_at': '2024-03-10'}]
        """
        if not self.comparison_field:
            raise ValueError("comparison_field required for 'max' strategy")
        
        unique_dict = {}
        
        for row in data:
            key = self._get_key(row)
            comparison_value = row.get(self.comparison_field)
            
            if key not in unique_dict:
                # First occurrence of this key
                unique_dict[key] = row
            else:
                # Compare with existing row
                current_value = unique_dict[key].get(self.comparison_field)
                if comparison_value > current_value:
                    # New row has higher value, replace
                    unique_dict[key] = row
        
        return list(unique_dict.values())
    
    def _dedupe_min(self, data):
        """Keep occurrence with minimum comparison_field value.
        
        Compares values in comparison_field.
        Keeps row with lowest value for each key.
        
        Args:
            data: List of dictionaries
        
        Returns:
            list: Deduplicated data (minimum values)
        
        Example:
            >>> self.comparison_field = 'price'
            >>> data = [
            ...     {'id': 1, 'price': 150},
            ...     {'id': 1, 'price': 100},  # Cheaper (kept)
            ...     {'id': 2, 'price': 200},
            ... ]
            >>> result = self._dedupe_min(data)
            [{'id': 1, 'price': 100}, {'id': 2, 'price': 200}]
        """
        if not self.comparison_field:
            raise ValueError("comparison_field required for 'min' strategy")
        
        unique_dict = {}
        
        for row in data:
            key = self._get_key(row)
            comparison_value = row.get(self.comparison_field)
            
            if key not in unique_dict:
                # First occurrence of this key
                unique_dict[key] = row
            else:
                # Compare with existing row
                current_value = unique_dict[key].get(self.comparison_field)
                if comparison_value < current_value:
                    # New row has lower value, replace
                    unique_dict[key] = row
        
        return list(unique_dict.values())
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Get Key from Row**

```python
def _get_key(self, row):
    return tuple(row.get(field) for field in self.key_fields)
```

**🔍 How it works:**

```python
# Single key field:
self.key_fields = ['id']
row = {'id': 123, 'name': 'Camp A', 'price': 100}
key = self._get_key(row)
# Result: (123,)  ← Tuple with one element

# Multiple key fields (composite key):
self.key_fields = ['customer_id', 'product_id']
row = {'customer_id': 456, 'product_id': 789, 'quantity': 5}
key = self._get_key(row)
# Result: (456, 789)  ← Tuple with two elements
```

**Why tuple:**
- Tuples are hashable (can be used as dictionary keys)
- Tuples are immutable (safe for use in sets)
- Supports composite keys naturally

---

**Part 2: Strategy 'first' - Keep First Occurrence**

```python
def _dedupe_first(self, data):
    seen = set()
    unique_data = []
    
    for row in data:
        key = self._get_key(row)
        if key not in seen:
            seen.add(key)
            unique_data.append(row)
    
    return unique_data
```

**🔍 Step-by-step:**

```python
data = [
    {'id': 1, 'name': 'Version 1'},  # ← Keep (first)
    {'id': 2, 'name': 'Camp B'},     # ← Keep (first)
    {'id': 1, 'name': 'Version 2'},  # ← Skip (duplicate)
]

seen = set()
unique_data = []

# Iteration 1:
row = {'id': 1, 'name': 'Version 1'}
key = (1,)
if (1,) not in seen:  # True
    seen.add((1,))  # seen = {(1,)}
    unique_data.append(row)  # unique_data = [{'id': 1, 'name': 'Version 1'}]

# Iteration 2:
row = {'id': 2, 'name': 'Camp B'}
key = (2,)
if (2,) not in seen:  # True
    seen.add((2,))  # seen = {(1,), (2,)}
    unique_data.append(row)  # 2 rows now

# Iteration 3:
row = {'id': 1, 'name': 'Version 2'}
key = (1,)
if (1,) not in seen:  # False (already seen!)
    # Skip this row

# Result: [{'id': 1, 'name': 'Version 1'}, {'id': 2, 'name': 'Camp B'}]
```

---

**Part 3: Strategy 'last' - Keep Last Occurrence**

```python
def _dedupe_last(self, data):
    unique_dict = {}
    
    for row in data:
        key = self._get_key(row)
        unique_dict[key] = row  # Overwrites previous
    
    return list(unique_dict.values())
```

**🔍 How overwriting works:**

```python
data = [
    {'id': 1, 'name': 'Version 1'},  # ← Overwritten
    {'id': 2, 'name': 'Camp B'},     # ← Keep
    {'id': 1, 'name': 'Version 2'},  # ← Keep (last)
]

unique_dict = {}

# Iteration 1:
key = (1,)
unique_dict[(1,)] = {'id': 1, 'name': 'Version 1'}
# unique_dict = {(1,): {'id': 1, 'name': 'Version 1'}}

# Iteration 2:
key = (2,)
unique_dict[(2,)] = {'id': 2, 'name': 'Camp B'}
# unique_dict = {(1,): {...'Version 1'}, (2,): {...'Camp B'}}

# Iteration 3:
key = (1,)
unique_dict[(1,)] = {'id': 1, 'name': 'Version 2'}  # Overwrites!
# unique_dict = {(1,): {...'Version 2'}, (2,): {...'Camp B'}}

# Result: [{'id': 1, 'name': 'Version 2'}, {'id': 2, 'name': 'Camp B'}]
```

---

**Part 4: Strategy 'max' - Keep Maximum Value**

```python
def _dedupe_max(self, data):
    unique_dict = {}
    
    for row in data:
        key = self._get_key(row)
        comparison_value = row.get(self.comparison_field)
        
        if key not in unique_dict:
            unique_dict[key] = row
        else:
            current_value = unique_dict[key].get(self.comparison_field)
            if comparison_value > current_value:
                unique_dict[key] = row  # Replace with newer
    
    return list(unique_dict.values())
```

**🔍 Comparison logic:**

```python
self.comparison_field = 'updated_at'

data = [
    {'id': 1, 'updated_at': '2024-01-01'},  # ← Replaced
    {'id': 1, 'updated_at': '2024-06-15'},  # ← Keep (newer)
]

unique_dict = {}

# Iteration 1:
key = (1,)
if (1,) not in unique_dict:  # True
    unique_dict[(1,)] = {'id': 1, 'updated_at': '2024-01-01'}

# Iteration 2:
key = (1,)
if (1,) not in unique_dict:  # False (already exists)
else:
    current_value = '2024-01-01'
    comparison_value = '2024-06-15'
    if '2024-06-15' > '2024-01-01':  # True (string comparison)
        unique_dict[(1,)] = {'id': 1, 'updated_at': '2024-06-15'}  # Replace!

# Result: [{'id': 1, 'updated_at': '2024-06-15'}]
```

**Works with:**
- Dates (strings): `'2024-06-15' > '2024-01-01'` ✓
- Numbers: `150 > 100` ✓
- Timestamps: `1718409600 > 1704067200` ✓

---

#### 📊 Usage Examples

**Example 1: Simple Deduplication (First)**

```python
# Keep first occurrence of each customer_id
dedupe = DeduplicationTransformer(['customer_id'], strategy='first')

data = [
    {'customer_id': 101, 'name': 'Alice', 'email': 'old@email.com'},
    {'customer_id': 102, 'name': 'Bob', 'email': 'bob@email.com'},
    {'customer_id': 101, 'name': 'Alice', 'email': 'new@email.com'},  # Duplicate
]

result = dedupe.transform(data)
# Result: 2 rows (customer 101 keeps old email, customer 102 kept)
```

**Example 2: Keep Latest Update**

```python
# Keep most recent update for each booking
dedupe = DeduplicationTransformer(
    key_fields=['booking_id'],
    strategy='max',
    comparison_field='updated_at'
)

data = [
    {'booking_id': 'B001', 'status': 'pending', 'updated_at': '2024-01-01T10:00:00'},
    {'booking_id': 'B002', 'status': 'confirmed', 'updated_at': '2024-01-02T11:00:00'},
    {'booking_id': 'B001', 'status': 'confirmed', 'updated_at': '2024-01-05T14:30:00'},  # Newer!
]

result = dedupe.transform(data)
# Result: B001 has status='confirmed' (latest update kept)
```

**Example 3: Composite Key**

```python
# Uniqueness based on customer_id + product_id combination
dedupe = DeduplicationTransformer(
    key_fields=['customer_id', 'product_id'],
    strategy='last'
)

data = [
    {'customer_id': 101, 'product_id': 'P001', 'quantity': 1},
    {'customer_id': 101, 'product_id': 'P002', 'quantity': 2},
    {'customer_id': 101, 'product_id': 'P001', 'quantity': 5},  # Duplicate (customer 101, product P001)
    {'customer_id': 102, 'product_id': 'P001', 'quantity': 3},  # NOT duplicate (different customer)
]

result = dedupe.transform(data)
# Result: 3 rows
# - (101, P001) → quantity=5 (last occurrence)
# - (101, P002) → quantity=2
# - (102, P001) → quantity=3 (different customer, not duplicate)
```

**Example 4: Keep Cheapest Price**

```python
# Keep lowest price for each product
dedupe = DeduplicationTransformer(
    key_fields=['product_id'],
    strategy='min',
    comparison_field='price'
)

data = [
    {'product_id': 'TENT-001', 'price': 299.99, 'supplier': 'A'},
    {'product_id': 'TENT-001', 'price': 249.99, 'supplier': 'B'},  # Cheaper!
    {'product_id': 'TENT-001', 'price': 279.99, 'supplier': 'C'},
]

result = dedupe.transform(data)
# Result: TENT-001 with price=249.99 from supplier B
```

---

#### 🎯 Integration with Pipeline

```python
# In main.py:

from src.pipeline import ETLPipeline, TransformationPipeline
from src.transformers import DeduplicationTransformer

# Create transformation pipeline
transform_pipeline = TransformationPipeline()

# Add deduplication transformer
dedupe = DeduplicationTransformer(
    key_fields=['campsite_id'],
    strategy='max',
    comparison_field='updated_at'
)
transform_pipeline.add_transformer(dedupe)

# Add to ETL pipeline
etl_pipeline = ETLPipeline()
etl_pipeline.set_transformation(transform_pipeline)
etl_pipeline.run()
```

**Output:**
```
======================================================================
🔄 TRANSFORM PHASE
======================================================================

⚙️  Applying transformation: Deduplication...
✅ Removed 37 duplicates, kept 1463 unique rows

✅ Transform phase complete: 1463 rows
```

---

#### ✅ Key Takeaways

1. **4 Strategies**: first, last, max, min - choose based on business logic
2. **Composite Keys**: Support multi-field uniqueness
3. **Flexible Comparison**: Use any field for max/min (dates, prices, timestamps)
4. **Set vs Dict**: Use set for 'first' (faster), dict for 'last/max/min' (flexible)
5. **Tuple Keys**: Enable composite key support and dictionary usage
6. **Production Essential**: Real-world data always has duplicates
7. **Data Quality**: Critical step before loading to prevent database errors

**Next**: Implement incremental loading to process only new/changed data!

---

### Enhancement 2.3: Incremental Loading (Delta Detection)

**🎯 What It Does:**
Processes only new or changed data since the last run, instead of reprocessing all data every time.

**💡 Why It Matters:**
- **Performance**: 80-100x faster for large datasets
- **Efficiency**: Reduces database load and network traffic
- **Scalability**: Essential for daily/hourly production pipelines
- **Cost Savings**: Less compute time = lower costs
- **Freshness**: Process data more frequently (hourly vs daily)

**🌟 Real-World Impact:**

**Without Incremental Loading:**
```
Daily Pipeline:
- Extract: 1,000,000 rows (ALL data)
- Transform: 1,000,000 rows
- Load: 1,000,000 rows
- Time: 45 minutes ⏱️
- Database: High load, slow queries
```

**With Incremental Loading:**
```
Daily Pipeline:
- Extract: 12,500 rows (only TODAY's data)
- Transform: 12,500 rows
- Load: 12,500 rows
- Time: 35 seconds ⚡
- Database: Normal load, fast queries

🚀 77x faster! Can now run hourly instead of daily!
```

---

#### 📚 What is a Watermark?

**Watermark** = A checkpoint that tracks "how far we've processed"

Think of it like a bookmark in a book:
- You read up to page 150 (watermark = 150)
- Next time, you start from page 151 (not page 1!)
- Only read new pages since last time

**Types of watermarks:**

1. **Timestamp Watermark**
   ```
   Last processed: 2024-10-19 14:30:00
   Next run: Process all records with updated_at > 2024-10-19 14:30:00
   ```

2. **ID Watermark**
   ```
   Last processed: booking_id = 12345
   Next run: Process all records with booking_id > 12345
   ```

3. **Sequence Watermark**
   ```
   Last processed: sequence = 98765
   Next run: Process all records with sequence > 98765
   ```

---

#### 🔍 Complete Implementation

Create `src/incremental.py`:

```python
import json
from datetime import datetime
from pathlib import Path

class WatermarkManager:
    """Manage incremental loading watermarks.
    
    A watermark is the last successfully processed value (timestamp, ID, etc.).
    Next run only processes records after the watermark.
    
    Watermarks are persisted to file so they survive restarts.
    
    Attributes:
        state_file: Path to JSON file storing watermarks
        watermarks: Dictionary of {source_name: watermark_value}
    
    Example:
        >>> # First run
        >>> manager = WatermarkManager('data/state/watermarks.json')
        >>> last_id = manager.get_watermark('bookings', default=0)
        >>> # last_id = 0 (no previous watermark)
        >>> 
        >>> # Process data, get max ID = 12345
        >>> manager.update_watermark('bookings', 12345)
        >>> # Saved to file: {"bookings": 12345}
        >>> 
        >>> # Second run (next day)
        >>> manager = WatermarkManager('data/state/watermarks.json')
        >>> last_id = manager.get_watermark('bookings', default=0)
        >>> # last_id = 12345 (loaded from file!)
        >>> # Only process records with ID > 12345
    """
    
    def __init__(self, state_file='data/state/watermarks.json'):
        """Initialize watermark manager.
        
        Creates state directory if it doesn't exist.
        Loads existing watermarks from file.
        
        Args:
            state_file: Path to JSON file storing watermarks
        
        Example:
            >>> manager = WatermarkManager('data/state/watermarks.json')
            >>> # Creates data/state/ directory if needed
            >>> # Loads existing watermarks from file
        """
        self.state_file = Path(state_file)
        self.state_file.parent.mkdir(parents=True, exist_ok=True)
        self.watermarks = self._load_state()
        
        if self.watermarks:
            print(f"📂 Loaded {len(self.watermarks)} watermark(s) from {state_file}")
        else:
            print(f"📂 No existing watermarks (first run)")
    
    def _load_state(self):
        """Load watermarks from file.
        
        Returns:
            dict: Watermarks dictionary, or {} if file doesn't exist
        
        Example:
            >>> # File contains: {"bookings": 12345, "customers": "2024-10-19"}
            >>> watermarks = self._load_state()
            >>> # watermarks = {"bookings": 12345, "customers": "2024-10-19"}
        """
        if self.state_file.exists():
            with open(self.state_file, 'r') as f:
                return json.load(f)
        return {}
    
    def _save_state(self):
        """Save watermarks to file.
        
        Persists watermarks so they survive process restarts.
        
        Example:
            >>> self.watermarks = {"bookings": 12345}
            >>> self._save_state()
            >>> # File now contains: {"bookings": 12345}
        """
        with open(self.state_file, 'w') as f:
            json.dump(self.watermarks, f, indent=2)
    
    def get_watermark(self, source_name, default=None):
        """Get watermark for a specific source.
        
        Args:
            source_name: Name of data source
            default: Default value if no watermark exists (usually 0 or None)
            
        Returns:
            Watermark value or default
        
        Example:
            >>> manager = WatermarkManager()
            >>> 
            >>> # First run (no watermark exists)
            >>> last_id = manager.get_watermark('bookings', default=0)
            >>> # last_id = 0
            >>> 
            >>> # After update_watermark('bookings', 12345)
            >>> last_id = manager.get_watermark('bookings', default=0)
            >>> # last_id = 12345
        """
        return self.watermarks.get(source_name, default)
    
    def update_watermark(self, source_name, value):
        """Update watermark for a source.
        
        Saves to file immediately so it persists.
        
        Args:
            source_name: Name of data source
            value: New watermark value (ID, timestamp, sequence, etc.)
        
        Example:
            >>> manager = WatermarkManager()
            >>> manager.update_watermark('bookings', 12345)
            💾 Updated watermark for bookings: 12345
            >>> 
            >>> # Next run will start from 12346
        """
        self.watermarks[source_name] = value
        self._save_state()
        print(f"💾 Updated watermark for {source_name}: {value}")
    
    def reset_watermark(self, source_name):
        """Reset watermark for a source (forces full reload).
        
        Args:
            source_name: Name of data source to reset
        
        Example:
            >>> manager.reset_watermark('bookings')
            🔄 Reset watermark for bookings (next run will be full load)
        """
        if source_name in self.watermarks:
            del self.watermarks[source_name]
            self._save_state()
            print(f"🔄 Reset watermark for {source_name} (next run will be full load)")


class IncrementalSource(DataSource):
    """Base class for incremental data sources.
    
    Only extracts data modified after the last watermark.
    Automatically updates watermark after successful extraction.
    
    Attributes:
        watermark_field: Field to compare (e.g., 'updated_at', 'id')
        watermark_manager: WatermarkManager instance
        last_watermark: Last processed value
    """
    
    def __init__(self, name, watermark_field, watermark_manager):
        """Initialize incremental source.
        
        Args:
            name: Source name (used as key in watermark file)
            watermark_field: Field to compare (e.g., 'updated_at', 'booking_id')
            watermark_manager: WatermarkManager instance
        
        Example:
            >>> manager = WatermarkManager()
            >>> source = IncrementalFileSource(
            ...     name="Bookings",
            ...     file_path="data/bookings.json",
            ...     watermark_field='booking_id',
            ...     watermark_manager=manager
            ... )
            #    📍 Watermark field: booking_id
            #    🔖 Last watermark: 12345
        """
        super().__init__(name, "Incremental")
        self.watermark_field = watermark_field
        self.watermark_manager = watermark_manager
        self.last_watermark = watermark_manager.get_watermark(name, default=0)
        
        print(f"   📍 Watermark field: {watermark_field}")
        print(f"   🔖 Last watermark: {self.last_watermark}")


class IncrementalFileSource(IncrementalSource):
    """File source with incremental loading.
    
    Reads JSON file but only returns records with watermark_field > last_watermark.
    Automatically updates watermark after extraction.
    
    Example:
        >>> # File contains 100,000 records
        >>> # Last watermark: booking_id = 99500
        >>> 
        >>> source = IncrementalFileSource(
        ...     "Bookings",
        ...     "data/bookings.json",
        ...     watermark_field='booking_id',
        ...     watermark_manager=manager
        ... )
        >>> 
        >>> data = source.extract()
        📖 Reading from data/bookings.json...
        🔍 Filtering: only records where booking_id > 99500
        ✅ Found 500 new/changed records (out of 100,000 total)
        💾 Updated watermark for Bookings: 100000
        >>> 
        >>> # Only 500 records returned (not 100,000!)
    """
    
    def __init__(self, name, file_path, watermark_field, watermark_manager):
        """Initialize incremental file source.
        
        Args:
            name: Source name
            file_path: Path to JSON file
            watermark_field: Field to compare for incremental detection
            watermark_manager: WatermarkManager instance
        
        Example:
            >>> manager = WatermarkManager()
            >>> source = IncrementalFileSource(
            ...     "Bookings",
            ...     "data/bookings.json",
            ...     watermark_field='booking_id',
            ...     watermark_manager=manager
            ... )
        """
        super().__init__(name, watermark_field, watermark_manager)
        self.file_path = file_path
    
    def connect(self):
        """Connect to file source."""
        print(f"📁 Connected to {self.file_path}")
    
    def extract(self):
        """Extract only new/changed records.
        
        Filters data to only include records where:
        watermark_field > last_watermark
        
        Updates watermark to maximum value seen.
        
        Returns:
            list: Records with watermark_field > last_watermark
        
        Example:
            >>> # File contains:
            >>> # [
            >>> #   {"id": 1, "updated_at": "2024-01-01"},  # Old
            >>> #   {"id": 2, "updated_at": "2024-03-01"},  # NEW
            >>> #   {"id": 3, "updated_at": "2024-03-10"}   # NEW
            >>> # ]
            >>> # Last watermark: "2024-02-01"
            >>> 
            >>> data = source.extract()
            📖 Reading from data/bookings.json...
            🔍 Filtering: only records where updated_at > 2024-02-01
            ✅ Found 2 new/changed records (out of 3 total)
            💾 Updated watermark for Bookings: 2024-03-10
            >>> 
            >>> # Returns only records 2 and 3
        """
        print(f"📖 Reading from {self.file_path}...")
        
        # Read all data from file
        with open(self.file_path, 'r') as f:
            all_data = json.load(f)
        
        print(f"🔍 Filtering: only records where {self.watermark_field} > {self.last_watermark}")
        
        # Filter for new/changed records only
        new_data = [
            row for row in all_data
            if row.get(self.watermark_field, 0) > self.last_watermark
        ]
        
        print(f"✅ Found {len(new_data)} new/changed records (out of {len(all_data)} total)")
        
        # Update watermark to maximum value seen
        if new_data:
            max_watermark = max(row.get(self.watermark_field, 0) for row in new_data)
            self.watermark_manager.update_watermark(self.name, max_watermark)
        else:
            print(f"ℹ️  No new data to process")
        
        return new_data
    
    def disconnect(self):
        """Disconnect from file source."""
        print(f"✅ Disconnected from {self.file_path}")
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Load Watermarks from File**

```python
def _load_state(self):
    if self.state_file.exists():
        with open(self.state_file, 'r') as f:
            return json.load(f)
    return {}
```

**🔍 How it works:**

```python
# First run (file doesn't exist):
state_file.exists()  # False
return {}  # Empty dictionary

# Second run (file exists):
state_file.exists()  # True
# File contains: {"bookings": 12345, "customers": "2024-10-19"}
json.load(f)  # Returns: {"bookings": 12345, "customers": "2024-10-19"}
```

---

**Part 2: Save Watermarks to File**

```python
def _save_state(self):
    with open(self.state_file, 'w') as f:
        json.dump(self.watermarks, f, indent=2)
```

**🔍 What it creates:**

```json
{
  "bookings": 12345,
  "customers": "2024-10-19T14:30:00",
  "transactions": 98765
}
```

**File location:** `data/state/watermarks.json`

---

**Part 3: Get Watermark with Default**

```python
def get_watermark(self, source_name, default=None):
    return self.watermarks.get(source_name, default)
```

**🔍 Behavior:**

```python
# watermarks = {"bookings": 12345}

# Source exists:
get_watermark('bookings', default=0)  # Returns: 12345

# Source doesn't exist (first run):
get_watermark('new_source', default=0)  # Returns: 0 (default)

# Using None as default:
get_watermark('new_source', default=None)  # Returns: None
```

---

**Part 4: Filter New Records**

```python
new_data = [
    row for row in all_data
    if row.get(self.watermark_field, 0) > self.last_watermark
]
```

**🔍 Step-by-step:**

```python
# Setup:
self.watermark_field = 'booking_id'
self.last_watermark = 100

all_data = [
    {'booking_id': 95, 'name': 'Old Booking'},    # 95 > 100? No
    {'booking_id': 101, 'name': 'New Booking 1'}, # 101 > 100? Yes ✓
    {'booking_id': 102, 'name': 'New Booking 2'}, # 102 > 100? Yes ✓
]

# Filter:
new_data = []
for row in all_data:
    watermark_value = row.get('booking_id', 0)
    if watermark_value > 100:
        new_data.append(row)

# Result: 2 new records (booking_id 101 and 102)
```

---

**Part 5: Update Watermark to Maximum**

```python
if new_data:
    max_watermark = max(row.get(self.watermark_field, 0) for row in new_data)
    self.watermark_manager.update_watermark(self.name, max_watermark)
```

**🔍 Finding maximum:**

```python
new_data = [
    {'booking_id': 101, 'name': 'Booking 1'},
    {'booking_id': 105, 'name': 'Booking 2'},
    {'booking_id': 103, 'name': 'Booking 3'},
]

# Extract all booking_ids:
ids = [row.get('booking_id', 0) for row in new_data]
# ids = [101, 105, 103]

# Find maximum:
max_watermark = max(ids)
# max_watermark = 105

# Update:
watermark_manager.update_watermark('Bookings', 105)
# File now contains: {"Bookings": 105}
# Next run will process booking_id > 105
```

---

#### 📊 Complete Usage Example

```python
# In main.py:

from src.incremental import WatermarkManager, IncrementalFileSource
from src.pipeline import ETLPipeline

def main():
    # Initialize watermark manager
    watermark_mgr = WatermarkManager('data/state/watermarks.json')
    
    # Create incremental sources
    bookings_source = IncrementalFileSource(
        name="Bookings",
        file_path="data/bookings.json",
        watermark_field='booking_id',
        watermark_manager=watermark_mgr
    )
    
    customers_source = IncrementalFileSource(
        name="Customers",
        file_path="data/customers.json",
        watermark_field='updated_at',
        watermark_manager=watermark_mgr
    )
    
    # Create and run pipeline
    pipeline = ETLPipeline()
    pipeline.add_source(bookings_source)
    pipeline.add_source(customers_source)
    
    # Run pipeline (only processes new data!)
    pipeline.run()

if __name__ == "__main__":
    main()
```

**First Run (no watermarks):**
```
📂 No existing watermarks (first run)

Data Source: Bookings (Incremental)
   📍 Watermark field: booking_id
   🔖 Last watermark: 0

📖 Reading from data/bookings.json...
🔍 Filtering: only records where booking_id > 0
✅ Found 10,000 new/changed records (out of 10,000 total)
💾 Updated watermark for Bookings: 10000

Data Source: Customers (Incremental)
   📍 Watermark field: updated_at
   🔖 Last watermark: 0

📖 Reading from data/customers.json...
🔍 Filtering: only records where updated_at > 0
✅ Found 5,000 new/changed records (out of 5,000 total)
💾 Updated watermark for Customers: 2024-10-19T23:59:59

✅ Pipeline completed successfully!
```

**Second Run (next day, 250 new bookings, 100 updated customers):**
```
📂 Loaded 2 watermark(s) from data/state/watermarks.json

Data Source: Bookings (Incremental)
   📍 Watermark field: booking_id
   🔖 Last watermark: 10000

📖 Reading from data/bookings.json...
🔍 Filtering: only records where booking_id > 10000
✅ Found 250 new/changed records (out of 10,250 total)
💾 Updated watermark for Bookings: 10250

Data Source: Customers (Incremental)
   📍 Watermark field: updated_at
   🔖 Last watermark: 2024-10-19T23:59:59

📖 Reading from data/customers.json...
🔍 Filtering: only records where updated_at > 2024-10-19T23:59:59
✅ Found 100 new/changed records (out of 5,100 total)
💾 Updated watermark for Customers: 2024-10-20T23:59:59

✅ Pipeline completed successfully!
🚀 Processed 350 records instead of 15,350 (43x faster!)
```

---

#### 📁 Watermark State File

**Location:** `data/state/watermarks.json`

**Contents:**
```json
{
  "Bookings": 10250,
  "Customers": "2024-10-20T23:59:59",
  "Transactions": 98765
}
```

**Backup Recommendation:**
```bash
# Backup watermark file (important!)
cp data/state/watermarks.json data/state/watermarks.json.backup

# Version control (recommended)
git add data/state/watermarks.json
git commit -m "Update watermarks after pipeline run"
```

---

#### 🎯 Advanced: Database Watermarks

For real production systems, store watermarks in database:

```python
class DatabaseWatermarkManager(WatermarkManager):
    """Store watermarks in database instead of file."""
    
    def __init__(self, db_connection):
        self.conn = db_connection
        self._create_table()
    
    def _create_table(self):
        """Create watermarks table."""
        self.conn.execute("""
            CREATE TABLE IF NOT EXISTS watermarks (
                source_name VARCHAR(255) PRIMARY KEY,
                watermark_value TEXT NOT NULL,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
    
    def get_watermark(self, source_name, default=None):
        """Get watermark from database."""
        result = self.conn.execute(
            "SELECT watermark_value FROM watermarks WHERE source_name = %s",
            (source_name,)
        ).fetchone()
        
        return result[0] if result else default
    
    def update_watermark(self, source_name, value):
        """Update watermark in database."""
        self.conn.execute("""
            INSERT INTO watermarks (source_name, watermark_value)
            VALUES (%s, %s)
            ON CONFLICT (source_name) DO UPDATE
            SET watermark_value = EXCLUDED.watermark_value,
                updated_at = CURRENT_TIMESTAMP
        """, (source_name, value))
        
        self.conn.commit()
        print(f"💾 Updated watermark for {source_name}: {value}")
```

---

#### 📈 Performance Comparison

```python
import time

# Scenario: Daily pipeline for 1 million row table

# WITHOUT Incremental Loading:
start = time.time()
all_data = extract_all_data()  # 1,000,000 rows
transform(all_data)
load(all_data)
full_load_time = time.time() - start

# WITH Incremental Loading (1% daily change):
start = time.time()
new_data = extract_incremental()  # 10,000 rows (only today's changes)
transform(new_data)
load(new_data)
incremental_time = time.time() - start

print(f"\n📊 Performance Comparison:")
print(f"{'='*50}")
print(f"Full Load:        {full_load_time:.1f} seconds")
print(f"Incremental Load: {incremental_time:.1f} seconds")
print(f"Speedup:          {full_load_time / incremental_time:.1f}x faster!")
print(f"{'='*50}")

# Example output:
# 📊 Performance Comparison:
# ==================================================
# Full Load:        2700.0 seconds (45 minutes)
# Incremental Load: 35.0 seconds
# Speedup:          77.1x faster!
# ==================================================
```

---

#### ✅ Key Takeaways

1. **Watermark**: Checkpoint tracking last processed value
2. **Persistence**: Store watermarks in file or database
3. **Default Value**: Use 0 or None for first run
4. **Filter**: Only process records > last watermark
5. **Update**: Set watermark to maximum value processed
6. **Performance**: 50-100x faster for large datasets
7. **Production Critical**: Essential for daily/hourly pipelines
8. **Backup**: Always backup watermark state!

**Next**: Add data aggregation for analytics and reporting!

---

### Enhancement 2.4: Data Aggregation Transformer

**🎯 What It Does:**
Performs GROUP BY operations with aggregation functions (SUM, AVG, COUNT, MIN, MAX) - like SQL but in Python during transformation.

**💡 Why It Matters:**
- **Analytics**: Generate summary reports directly in ETL
- **Performance**: Pre-aggregate data before loading (reduce database work)
- **Flexibility**: Create multiple aggregation levels (state, city, category)
- **SQL-like**: Familiar GROUP BY syntax but in Python
- **Real-time Insights**: See statistics during pipeline execution

**🌟 Real-World Use Case:**

**Raw Data (1,000,000 booking records):**
```python
[
    {'state': 'MG', 'city': 'Ouro Preto', 'price': 100, 'guests': 2},
    {'state': 'MG', 'city': 'Ouro Preto', 'price': 150, 'guests': 4},
    # ... 999,998 more rows
]
```

**After Aggregation (27 summary rows by state):**
```python
[
    {'state': 'MG', 'total_revenue': 2,450,000, 'avg_price': 125, 'bookings': 19,600},
    {'state': 'SP', 'total_revenue': 3,200,000, 'avg_price': 180, 'bookings': 17,777},
    # ... 25 more states
]
```

**Result:** 1M rows → 27 rows (37,000x data reduction!)

---

#### 📚 SQL vs Python Aggregation

**SQL Approach:**
```sql
SELECT 
    state,
    SUM(price) as total_revenue,
    AVG(price) as avg_price,
    COUNT(*) as num_bookings,
    MIN(price) as min_price,
    MAX(price) as max_price
FROM bookings
GROUP BY state;
```

**Python Approach (this transformer):**
```python
agg = AggregationTransformer(
    group_by_fields=['state'],
    aggregations={
        'total_revenue': ('price', 'sum'),
        'avg_price': ('price', 'avg'),
        'num_bookings': ('price', 'count'),
        'min_price': ('price', 'min'),
        'max_price': ('price', 'max')
    }
)
result = agg.transform(data)
```

**Same logic, different language!**

---

#### 🔍 Complete Implementation

Add to `src/transformers.py`:

```python
from collections import defaultdict

class AggregationTransformer(DataTransformer):
    """Aggregate data by group with multiple aggregation functions.
    
    Implements SQL GROUP BY functionality in Python.
    
    Supported aggregation functions:
    - 'sum': Sum of values
    - 'avg': Average of values
    - 'count': Count of rows
    - 'min': Minimum value
    - 'max': Maximum value
    - 'first': First value in group
    - 'last': Last value in group
    
    Attributes:
        group_by_fields: List of fields to group by (like SQL GROUP BY)
        aggregations: Dict of {output_field: (input_field, function)}
    
    Example:
        >>> # Revenue by state (simple grouping)
        >>> agg = AggregationTransformer(
        ...     group_by_fields=['state'],
        ...     aggregations={
        ...         'total_revenue': ('price', 'sum'),
        ...         'avg_price': ('price', 'avg'),
        ...         'booking_count': ('id', 'count')
        ...     }
        ... )
        >>> 
        >>> # Multi-level grouping (state + city)
        >>> agg = AggregationTransformer(
        ...     group_by_fields=['state', 'city'],
        ...     aggregations={
        ...         'revenue': ('price', 'sum'),
        ...         'bookings': ('id', 'count')
        ...     }
        ... )
    """
    
    def __init__(self, group_by_fields, aggregations):
        """Initialize aggregation transformer.
        
        Args:
            group_by_fields: List of fields to group by
                            Single: ['state']
                            Multiple: ['state', 'city']
            aggregations: Dict of {output_field_name: (input_field, function)}
                         Functions: 'sum', 'avg', 'count', 'min', 'max', 'first', 'last'
        
        Example:
            >>> # Simple: Group by state, calculate totals
            >>> agg = AggregationTransformer(
            ...     group_by_fields=['state'],
            ...     aggregations={
            ...         'total_revenue': ('price', 'sum'),
            ...         'avg_price': ('price', 'avg'),
            ...         'num_camps': ('id', 'count'),
            ...         'min_price': ('price', 'min'),
            ...         'max_price': ('price', 'max')
            ...     }
            ... )
            >>> 
            >>> # Complex: Multi-level grouping
            >>> agg = AggregationTransformer(
            ...     group_by_fields=['customer_id', 'booking_month'],
            ...     aggregations={
            ...         'total_spent': ('amount', 'sum'),
            ...         'num_bookings': ('booking_id', 'count'),
            ...         'first_booking': ('booking_date', 'first'),
            ...         'last_booking': ('booking_date', 'last')
            ...     }
            ... )
        """
        super().__init__("Aggregation")
        self.group_by_fields = group_by_fields if isinstance(group_by_fields, list) else [group_by_fields]
        self.aggregations = aggregations
        
        # Validation
        valid_functions = ['sum', 'avg', 'count', 'min', 'max', 'first', 'last']
        for output_field, (input_field, func) in aggregations.items():
            if func not in valid_functions:
                raise ValueError(f"Invalid function '{func}' for field '{output_field}'. Must be one of {valid_functions}")
    
    def transform(self, data):
        """Aggregate data by groups.
        
        Groups data by group_by_fields and applies aggregation functions.
        Returns one row per unique group combination.
        
        Args:
            data: List of dictionaries
            
        Returns:
            list: Aggregated data (one row per group)
        
        Example:
            >>> data = [
            ...     {'state': 'MG', 'price': 100, 'id': 1},
            ...     {'state': 'MG', 'price': 150, 'id': 2},
            ...     {'state': 'SP', 'price': 200, 'id': 3},
            ...     {'state': 'SP', 'price': 250, 'id': 4},
            ... ]
            >>> 
            >>> agg = AggregationTransformer(
            ...     group_by_fields=['state'],
            ...     aggregations={
            ...         'total_revenue': ('price', 'sum'),
            ...         'avg_price': ('price', 'avg'),
            ...         'count': ('id', 'count')
            ...     }
            ... )
            >>> 
            >>> result = agg.transform(data)
            ⚙️  Applying transformation: Aggregation...
            ✅ Aggregated 4 rows into 2 groups
            >>> 
            >>> # Result:
            >>> [
            ...     {'state': 'MG', 'total_revenue': 250, 'avg_price': 125.0, 'count': 2},
            ...     {'state': 'SP', 'total_revenue': 450, 'avg_price': 225.0, 'count': 2}
            ... ]
        """
        super().transform(data)
        
        if not data:
            print("⚠️  No data to aggregate")
            return data
        
        # Step 1: Group data by key
        groups = defaultdict(list)
        for row in data:
            key = tuple(row.get(field) for field in self.group_by_fields)
            groups[key].append(row)
        
        # Step 2: Aggregate each group
        aggregated_data = []
        for key, group_rows in groups.items():
            agg_row = {}
            
            # Add group by fields to output
            for i, field in enumerate(self.group_by_fields):
                agg_row[field] = key[i]
            
            # Calculate aggregations
            for output_field, (input_field, func) in self.aggregations.items():
                agg_row[output_field] = self._aggregate(group_rows, input_field, func)
            
            aggregated_data.append(agg_row)
        
        print(f"✅ Aggregated {len(data)} rows into {len(aggregated_data)} groups")
        return aggregated_data
    
    def _aggregate(self, rows, field, function):
        """Apply aggregation function to field values.
        
        Args:
            rows: List of dictionaries in this group
            field: Field name to aggregate
            function: Aggregation function ('sum', 'avg', 'count', etc.)
            
        Returns:
            Aggregated value
        
        Example:
            >>> rows = [
            ...     {'price': 100},
            ...     {'price': 150},
            ...     {'price': 200}
            ... ]
            >>> 
            >>> self._aggregate(rows, 'price', 'sum')    # 450
            >>> self._aggregate(rows, 'price', 'avg')    # 150.0
            >>> self._aggregate(rows, 'price', 'count')  # 3
            >>> self._aggregate(rows, 'price', 'min')    # 100
            >>> self._aggregate(rows, 'price', 'max')    # 200
        """
        # Extract values (exclude None)
        values = [row.get(field) for row in rows if row.get(field) is not None]
        
        if function == 'sum':
            return sum(values) if values else 0
        elif function == 'avg':
            return sum(values) / len(values) if values else 0
        elif function == 'count':
            return len(rows)  # Count all rows, not just non-None values
        elif function == 'min':
            return min(values) if values else None
        elif function == 'max':
            return max(values) if values else None
        elif function == 'first':
            return values[0] if values else None
        elif function == 'last':
            return values[-1] if values else None
        else:
            raise ValueError(f"Unknown aggregation function: {function}")
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Group Data by Key**

```python
groups = defaultdict(list)
for row in data:
    key = tuple(row.get(field) for field in self.group_by_fields)
    groups[key].append(row)
```

**🔍 How grouping works:**

```python
# Setup:
group_by_fields = ['state']

data = [
    {'state': 'MG', 'price': 100},
    {'state': 'MG', 'price': 150},
    {'state': 'SP', 'price': 200},
]

groups = defaultdict(list)

# Iteration 1:
row = {'state': 'MG', 'price': 100}
key = tuple(['MG'])  # ('MG',)
groups[('MG',)].append(row)
# groups = {('MG',): [{'state': 'MG', 'price': 100}]}

# Iteration 2:
row = {'state': 'MG', 'price': 150}
key = ('MG',)
groups[('MG',)].append(row)
# groups = {('MG',): [{'state': 'MG', 'price': 100}, {'state': 'MG', 'price': 150}]}

# Iteration 3:
row = {'state': 'SP', 'price': 200}
key = ('SP',)
groups[('SP',)].append(row)
# groups = {
#     ('MG',): [{'state': 'MG', 'price': 100}, {'state': 'MG', 'price': 150}],
#     ('SP',): [{'state': 'SP', 'price': 200}]
# }
```

**Multi-field grouping:**
```python
group_by_fields = ['state', 'city']
row = {'state': 'MG', 'city': 'Ouro Preto', 'price': 100}
key = tuple(['MG', 'Ouro Preto'])  # ('MG', 'Ouro Preto')
groups[('MG', 'Ouro Preto')].append(row)
```

---

**Part 2: Add Group By Fields to Output**

```python
agg_row = {}
for i, field in enumerate(self.group_by_fields):
    agg_row[field] = key[i]
```

**🔍 Reconstructing fields from key:**

```python
# key = ('MG', 'Ouro Preto')
# group_by_fields = ['state', 'city']

agg_row = {}

# i=0, field='state':
agg_row['state'] = key[0]  # 'MG'

# i=1, field='city':
agg_row['city'] = key[1]  # 'Ouro Preto'

# agg_row = {'state': 'MG', 'city': 'Ouro Preto'}
```

---

**Part 3: Calculate Aggregations**

```python
for output_field, (input_field, func) in self.aggregations.items():
    agg_row[output_field] = self._aggregate(group_rows, input_field, func)
```

**🔍 Applying multiple aggregations:**

```python
aggregations = {
    'total_revenue': ('price', 'sum'),
    'avg_price': ('price', 'avg'),
    'count': ('price', 'count')
}

group_rows = [
    {'state': 'MG', 'price': 100},
    {'state': 'MG', 'price': 150}
]

# Iteration 1: total_revenue
output_field = 'total_revenue'
input_field = 'price'
func = 'sum'
agg_row['total_revenue'] = self._aggregate(group_rows, 'price', 'sum')  # 250

# Iteration 2: avg_price
agg_row['avg_price'] = self._aggregate(group_rows, 'price', 'avg')  # 125.0

# Iteration 3: count
agg_row['count'] = self._aggregate(group_rows, 'price', 'count')  # 2

# Final agg_row:
# {'state': 'MG', 'total_revenue': 250, 'avg_price': 125.0, 'count': 2}
```

---

**Part 4: Aggregation Functions**

```python
def _aggregate(self, rows, field, function):
    values = [row.get(field) for row in rows if row.get(field) is not None]
    
    if function == 'sum':
        return sum(values) if values else 0
    elif function == 'avg':
        return sum(values) / len(values) if values else 0
```

**🔍 Each function explained:**

```python
rows = [
    {'price': 100},
    {'price': 150},
    {'price': 200},
    {'price': None}  # Missing value
]

# Extract non-None values:
values = [100, 150, 200]  # Excludes None

# SUM:
sum(values)  # 100 + 150 + 200 = 450

# AVG:
sum(values) / len(values)  # 450 / 3 = 150.0

# COUNT:
len(rows)  # 4 (counts all rows, including None)

# MIN:
min(values)  # 100

# MAX:
max(values)  # 200

# FIRST:
values[0]  # 100

# LAST:
values[-1]  # 200
```

---

#### 📊 Usage Examples

**Example 1: Revenue by State**

```python
agg = AggregationTransformer(
    group_by_fields=['state'],
    aggregations={
        'total_revenue': ('price', 'sum'),
        'avg_price': ('price', 'avg'),
        'num_bookings': ('id', 'count'),
        'min_price': ('price', 'min'),
        'max_price': ('price', 'max')
    }
)

data = [
    {'state': 'MG', 'price': 100, 'id': 1},
    {'state': 'MG', 'price': 150, 'id': 2},
    {'state': 'MG', 'price': 120, 'id': 3},
    {'state': 'SP', 'price': 200, 'id': 4},
    {'state': 'SP', 'price': 180, 'id': 5},
]

result = agg.transform(data)
print(result)

# Output:
# [
#     {
#         'state': 'MG',
#         'total_revenue': 370,
#         'avg_price': 123.33,
#         'num_bookings': 3,
#         'min_price': 100,
#         'max_price': 150
#     },
#     {
#         'state': 'SP',
#         'total_revenue': 380,
#         'avg_price': 190.0,
#         'num_bookings': 2,
#         'min_price': 180,
#         'max_price': 200
#     }
# ]
```

---

**Example 2: Multi-Level Grouping (State + City)**

```python
agg = AggregationTransformer(
    group_by_fields=['state', 'city'],
    aggregations={
        'revenue': ('price', 'sum'),
        'bookings': ('id', 'count'),
        'avg_guests': ('guests', 'avg')
    }
)

data = [
    {'state': 'MG', 'city': 'Ouro Preto', 'price': 100, 'guests': 2, 'id': 1},
    {'state': 'MG', 'city': 'Ouro Preto', 'price': 150, 'guests': 4, 'id': 2},
    {'state': 'MG', 'city': 'Tiradentes', 'price': 120, 'guests': 3, 'id': 3},
    {'state': 'SP', 'city': 'Santos', 'price': 200, 'guests': 5, 'id': 4},
]

result = agg.transform(data)
print(result)

# Output:
# [
#     {'state': 'MG', 'city': 'Ouro Preto', 'revenue': 250, 'bookings': 2, 'avg_guests': 3.0},
#     {'state': 'MG', 'city': 'Tiradentes', 'revenue': 120, 'bookings': 1, 'avg_guests': 3.0},
#     {'state': 'SP', 'city': 'Santos', 'revenue': 200, 'bookings': 1, 'avg_guests': 5.0}
# ]
```

---

**Example 3: Customer Lifetime Value**

```python
agg = AggregationTransformer(
    group_by_fields=['customer_id'],
    aggregations={
        'total_spent': ('amount', 'sum'),
        'num_bookings': ('booking_id', 'count'),
        'avg_booking_value': ('amount', 'avg'),
        'first_booking_date': ('booking_date', 'first'),
        'last_booking_date': ('booking_date', 'last')
    }
)

data = [
    {'customer_id': 101, 'amount': 150, 'booking_date': '2024-01-05', 'booking_id': 'B001'},
    {'customer_id': 101, 'amount': 200, 'booking_date': '2024-03-10', 'booking_id': 'B002'},
    {'customer_id': 101, 'amount': 180, 'booking_date': '2024-05-15', 'booking_id': 'B003'},
    {'customer_id': 102, 'amount': 300, 'booking_date': '2024-02-20', 'booking_id': 'B004'},
]

result = agg.transform(data)

# Output:
# [
#     {
#         'customer_id': 101,
#         'total_spent': 530,
#         'num_bookings': 3,
#         'avg_booking_value': 176.67,
#         'first_booking_date': '2024-01-05',
#         'last_booking_date': '2024-05-15'
#     },
#     {
#         'customer_id': 102,
#         'total_spent': 300,
#         'num_bookings': 1,
#         'avg_booking_value': 300.0,
#         'first_booking_date': '2024-02-20',
#         'last_booking_date': '2024-02-20'
#     }
# ]
```

---

#### 🎯 Integration with Pipeline

```python
# In main.py:

from src.transformers import AggregationTransformer
from src.pipeline import TransformationPipeline

# Create aggregation transformer
revenue_aggregator = AggregationTransformer(
    group_by_fields=['state'],
    aggregations={
        'total_revenue': ('price', 'sum'),
        'avg_price': ('price', 'avg'),
        'num_camps': ('id', 'count')
    }
)

# Add to transformation pipeline
transform_pipeline = TransformationPipeline()
transform_pipeline.add_transformer(revenue_aggregator)

# Add to ETL pipeline
pipeline.set_transformation(transform_pipeline)
pipeline.run()
```

**Output:**
```
======================================================================
🔄 TRANSFORM PHASE
======================================================================

⚙️  Applying transformation: Aggregation...
✅ Aggregated 1,500 rows into 27 groups

✅ Transform phase complete: 27 rows
```

---

#### ✅ Key Takeaways

1. **SQL in Python**: Implements SQL GROUP BY with aggregation functions
2. **7 Functions**: sum, avg, count, min, max, first, last
3. **Multi-Level Grouping**: Support for composite keys (state + city)
4. **defaultdict**: Simplifies grouping logic (auto-creates lists)
5. **Tuple Keys**: Enable multi-field grouping
6. **Data Reduction**: 1M rows → 27 rows (37,000x smaller!)
7. **Pre-Aggregation**: Calculate statistics in ETL, not in queries
8. **Production Use**: Generate analytics, summary reports, dashboards

**🎉 Level 2 Complete!** You've mastered PostgreSQL connections, deduplication, incremental loading, and aggregation!

---


## 📕 Level 3: Advanced Enhancements

### Enhancement 3.1: Parallel Processing

**🎯 What It Does:**
Processes multiple data sources simultaneously using Python's `concurrent.futures` module - like having multiple workers extracting data at the same time instead of one worker doing everything sequentially.

**💡 Why It Matters:**
- **Speed**: 3-10x faster for multiple sources
- **CPU Utilization**: Uses multi-core processors effectively
- **Scalability**: Handle 10+ sources efficiently
- **Production-Ready**: Essential for real-world ETL systems
- **I/O Optimization**: Extract from files/APIs simultaneously

**🌟 Real-World Impact:**

**Serial Processing (Current):**
```
Source A: 3.2s ──────────────────────►
Source B: 2.8s                         ──────────────────►
Source C: 3.5s                                             ──────────────────────►
Source D: 2.9s                                                                     ────────────────►
                                                                                    
Total: 12.4 seconds (one at a time)
```

**Parallel Processing (Enhanced):**
```
Source A: 3.2s ──────────────────────►
Source B: 2.8s ──────────────────►
Source C: 3.5s ──────────────────────────►
Source D: 2.9s ───────────────────►
                                                                                    
Total: 3.5 seconds (all at once!) = 3.5x faster!
```

---

#### 📚 Threads vs Processes

**Thread-Based Parallelism (ThreadPoolExecutor):**
- **Best for**: I/O-bound tasks (files, APIs, databases)
- **When**: Waiting for external resources
- **How**: Multiple threads in same Python process
- **Example**: Reading 10 JSON files simultaneously

**Process-Based Parallelism (ProcessPoolExecutor):**
- **Best for**: CPU-bound tasks (heavy computation, transformations)
- **When**: Number crunching, data processing
- **How**: Multiple separate Python processes
- **Example**: Processing 1M rows with complex calculations

**Our Use Case:** ThreadPoolExecutor (most ETL is I/O-bound)

---

#### 🔍 Complete Implementation

Add to `src/pipeline.py`:

```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor, as_completed
import multiprocessing
import time

class ParallelETLPipeline(ETLPipeline):
    """ETL Pipeline with parallel source extraction.
    
    Extracts from multiple sources simultaneously using thread/process pools.
    
    Features:
    - ThreadPoolExecutor for I/O-bound tasks (files, APIs, databases)
    - ProcessPoolExecutor for CPU-bound tasks (heavy transformations)
    - Automatic worker count based on CPU cores
    - Error handling per source
    - Progress tracking
    
    Attributes:
        max_workers: Number of parallel workers
        executor_type: 'thread' or 'process'
        sources: List of DataSource instances
    
    Example:
        >>> # Extract from 4 files in parallel (I/O-bound)
        >>> pipeline = ParallelETLPipeline(max_workers=4, executor_type='thread')
        >>> pipeline.add_source(FileSource("A", "data/a.json"))
        >>> pipeline.add_source(FileSource("B", "data/b.json"))
        >>> pipeline.add_source(FileSource("C", "data/c.json"))
        >>> pipeline.add_source(FileSource("D", "data/d.json"))
        >>> pipeline.run()
        >>> 
        >>> # Output:
        >>> # 🚀 Parallel pipeline initialized:
        >>> #    Workers: 4
        >>> #    Type: thread
        >>> # 
        >>> # 📥 PARALLEL EXTRACT PHASE (4 workers)
        >>> # 🔄 Extracting from A...
        >>> # 🔄 Extracting from B...
        >>> # 🔄 Extracting from C...
        >>> # 🔄 Extracting from D...
        >>> # ✅ B: 250 rows
        >>> # ✅ A: 300 rows
        >>> # ✅ D: 200 rows
        >>> # ✅ C: 280 rows
        >>> # 
        >>> # ✅ Parallel extract complete: 1030 total rows
    """
    
    def __init__(self, max_workers=None, executor_type='thread'):
        """Initialize parallel ETL pipeline.
        
        Args:
            max_workers: Number of parallel workers
                        None = auto-detect CPU count
                        4 = use 4 workers
                        Default: None (uses multiprocessing.cpu_count())
            executor_type: Type of parallelism
                          'thread' = ThreadPoolExecutor (I/O-bound)
                          'process' = ProcessPoolExecutor (CPU-bound)
                          Default: 'thread'
        
        Example:
            >>> # Auto-detect workers (recommended)
            >>> pipeline = ParallelETLPipeline()
            >>> 
            >>> # I/O-bound (files, APIs, databases):
            >>> pipeline = ParallelETLPipeline(max_workers=4, executor_type='thread')
            >>> 
            >>> # CPU-bound (heavy transformations):
            >>> pipeline = ParallelETLPipeline(max_workers=4, executor_type='process')
            >>> 
            >>> # Many sources (10+ files):
            >>> pipeline = ParallelETLPipeline(max_workers=10, executor_type='thread')
        """
        super().__init__()
        self.max_workers = max_workers or multiprocessing.cpu_count()
        self.executor_type = executor_type
        
        # Validate executor type
        if executor_type not in ['thread', 'process']:
            raise ValueError(f"executor_type must be 'thread' or 'process', got '{executor_type}'")
        
        print(f"🚀 Parallel pipeline initialized:")
        print(f"   Workers: {self.max_workers}")
        print(f"   Type: {executor_type}")
        print(f"   CPU cores: {multiprocessing.cpu_count()}")
    
    def _extract_phase(self):
        """Extract from all sources in parallel.
        
        Overrides parent class method to add parallelism.
        
        Process:
        1. Create thread/process pool
        2. Submit all extraction tasks
        3. Collect results as they complete
        4. Handle errors per source
        
        Returns:
            list: Combined data from all sources
        
        Example:
            >>> # Internal method called by run()
            >>> data = pipeline._extract_phase()
            >>> 
            >>> # Output with 4 sources:
            >>> # 📥 PARALLEL EXTRACT PHASE (4 workers)
            >>> # 🔄 Extracting from Source A...
            >>> # 🔄 Extracting from Source B...
            >>> # 🔄 Extracting from Source C...
            >>> # 🔄 Extracting from Source D...
            >>> # ✅ Source B: 250 rows (finished first)
            >>> # ✅ Source A: 300 rows
            >>> # ✅ Source D: 200 rows
            >>> # ✅ Source C: 280 rows (finished last)
            >>> # ✅ Parallel extract complete: 1030 total rows
        """
        print(f"\n{'='*70}")
        print(f"📥 PARALLEL EXTRACT PHASE ({self.max_workers} workers)")
        print(f"{'='*70}\n")
        
        if not self.sources:
            print("⚠️  No sources configured")
            return []
        
        all_data = []
        start_time = time.time()
        
        # Choose executor type
        if self.executor_type == 'thread':
            Executor = ThreadPoolExecutor
        else:
            Executor = ProcessPoolExecutor
        
        # Extract in parallel
        with Executor(max_workers=self.max_workers) as executor:
            # Submit all extraction tasks
            future_to_source = {
                executor.submit(self._extract_from_source, source): source
                for source in self.sources
            }
            
            # Collect results as they complete
            for future in as_completed(future_to_source):
                source = future_to_source[future]
                try:
                    data = future.result()
                    all_data.extend(data)
                    self.statistics.add_source(len(data))
                    print(f"✅ {source.name}: {len(data)} rows")
                except Exception as e:
                    self.logger.error(f"Failed to extract from {source.name}: {str(e)}")
                    self.statistics.add_error(f"Extract error: {source.name} - {str(e)}")
                    print(f"❌ {source.name}: Failed - {str(e)}")
        
        elapsed = time.time() - start_time
        print(f"\n✅ Parallel extract complete: {len(all_data)} total rows")
        print(f"⏱️  Time: {elapsed:.2f} seconds\n")
        return all_data
    
    def _extract_from_source(self, source):
        """Extract from single source (executed in parallel).
        
        This method runs in a separate thread/process.
        
        Args:
            source: DataSource instance
            
        Returns:
            list: Extracted data
        
        Example:
            >>> # This runs automatically in parallel
            >>> # You don't call this directly
            >>> data = self._extract_from_source(source)
        """
        print(f"🔄 Extracting from {source.name}...")
        
        source.connect()
        data = source.extract()
        source.disconnect()
        
        return data
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Submit Tasks to Pool**

```python
with Executor(max_workers=self.max_workers) as executor:
    future_to_source = {
        executor.submit(self._extract_from_source, source): source
        for source in self.sources
    }
```

**🔍 How task submission works:**

```python
# Setup:
sources = [
    FileSource("A", "a.json"),
    FileSource("B", "b.json"),
    FileSource("C", "c.json"),
    FileSource("D", "d.json")
]

# Create thread pool with 4 workers
executor = ThreadPoolExecutor(max_workers=4)

# Submit tasks (all submitted immediately, not waiting)
future_to_source = {}

# Iteration 1:
source = FileSource("A", "a.json")
future = executor.submit(self._extract_from_source, source)
future_to_source[future] = source
# Worker 1 starts extracting from A

# Iteration 2:
source = FileSource("B", "b.json")
future = executor.submit(self._extract_from_source, source)
future_to_source[future] = source
# Worker 2 starts extracting from B

# Iteration 3:
source = FileSource("C", "c.json")
future = executor.submit(self._extract_from_source, source)
future_to_source[future] = source
# Worker 3 starts extracting from C

# Iteration 4:
source = FileSource("D", "d.json")
future = executor.submit(self._extract_from_source, source)
future_to_source[future] = source
# Worker 4 starts extracting from D

# All 4 workers now running simultaneously!
# future_to_source = {
#     <Future A>: FileSource("A"),
#     <Future B>: FileSource("B"),
#     <Future C>: FileSource("C"),
#     <Future D>: FileSource("D")
# }
```

---

**Part 2: Collect Results as Completed**

```python
for future in as_completed(future_to_source):
    source = future_to_source[future]
    try:
        data = future.result()
        all_data.extend(data)
    except Exception as e:
        print(f"❌ {source.name}: Failed - {str(e)}")
```

**🔍 How as_completed works:**

```python
# Timeline (seconds):
# 0.0s: All 4 workers start
# 2.8s: Source B finishes first
# 3.2s: Source A finishes
# 2.9s: Source D finishes
# 3.5s: Source C finishes last

# as_completed() yields futures in completion order:

# Iteration 1 (at 2.8s):
future = <Future B>  # B finished first
source = future_to_source[future]  # FileSource("B")
data = future.result()  # [250 rows from B]
all_data.extend(data)
print("✅ B: 250 rows")

# Iteration 2 (at 2.9s):
future = <Future D>  # D finished second
source = future_to_source[future]  # FileSource("D")
data = future.result()  # [200 rows from D]
all_data.extend(data)
print("✅ D: 200 rows")

# Iteration 3 (at 3.2s):
future = <Future A>  # A finished third
source = future_to_source[future]  # FileSource("A")
data = future.result()  # [300 rows from A]
all_data.extend(data)
print("✅ A: 300 rows")

# Iteration 4 (at 3.5s):
future = <Future C>  # C finished last
source = future_to_source[future]  # FileSource("C")
data = future.result()  # [280 rows from C]
all_data.extend(data)
print("✅ C: 280 rows")

# all_data = [B's 250 rows] + [D's 200 rows] + [A's 300 rows] + [C's 280 rows]
# Total: 1030 rows in 3.5 seconds (not 12.4 seconds!)
```

**Key Point:** `as_completed()` returns futures in the order they **finish**, not the order they were submitted!

---

**Part 3: Error Handling**

```python
try:
    data = future.result()
    all_data.extend(data)
except Exception as e:
    print(f"❌ {source.name}: Failed - {str(e)}")
```

**🔍 Per-source error handling:**

```python
# If Source B fails:
try:
    data = future.result()  # Raises exception
except Exception as e:
    # Source B fails, but A, C, D continue!
    print(f"❌ B: Failed - Connection timeout")
    # Pipeline continues with remaining sources

# Result:
# ✅ A: 300 rows
# ❌ B: Failed - Connection timeout
# ✅ C: 280 rows
# ✅ D: 200 rows
# Total: 780 rows (B excluded, others succeeded)
```

**Benefit:** One failed source doesn't stop the entire pipeline!

---

#### 📊 Usage Examples

**Example 1: Parallel File Extraction**

```python
# main.py

# Create parallel pipeline
pipeline = ParallelETLPipeline(max_workers=4, executor_type='thread')

# Add 4 file sources (will extract in parallel)
pipeline.add_source(FileSource("Campsite A", "data/camps_a.json"))
pipeline.add_source(FileSource("Campsite B", "data/camps_b.json"))
pipeline.add_source(FileSource("Campsite C", "data/camps_c.json"))
pipeline.add_source(FileSource("Campsite D", "data/camps_d.json"))

# Add transformation
pipeline.set_transformation(TransformationPipeline())

# Add loader
pipeline.set_loader(FileLoader("Output", "data/output/all_camps.json"))

# Run
pipeline.run()

# Output:
# 🚀 Parallel pipeline initialized:
#    Workers: 4
#    Type: thread
#    CPU cores: 8
# 
# ======================================================================
# 📥 PARALLEL EXTRACT PHASE (4 workers)
# ======================================================================
# 
# 🔄 Extracting from Campsite A...
# 🔄 Extracting from Campsite B...
# 🔄 Extracting from Campsite C...
# 🔄 Extracting from Campsite D...
# ✅ Campsite B: 250 rows
# ✅ Campsite A: 300 rows
# ✅ Campsite D: 200 rows
# ✅ Campsite C: 280 rows
# 
# ✅ Parallel extract complete: 1030 total rows
# ⏱️  Time: 0.85 seconds
```

---

**Example 2: Performance Benchmark**

```python
import time

# Test data: 4 sources, each takes 3 seconds to extract
sources = [
    FileSource("Source A", "data/large_a.json"),
    FileSource("Source B", "data/large_b.json"),
    FileSource("Source C", "data/large_c.json"),
    FileSource("Source D", "data/large_d.json"),
]

# Serial extraction (current approach)
print("Testing Serial Extraction...")
serial_pipeline = ETLPipeline()
for source in sources:
    serial_pipeline.add_source(source)

start = time.time()
serial_pipeline.run()
serial_time = time.time() - start

# Parallel extraction (enhanced approach)
print("\nTesting Parallel Extraction...")
parallel_pipeline = ParallelETLPipeline(max_workers=4, executor_type='thread')
for source in sources:
    parallel_pipeline.add_source(source)

start = time.time()
parallel_pipeline.run()
parallel_time = time.time() - start

# Compare results
print("\n" + "="*70)
print("PERFORMANCE COMPARISON")
print("="*70)
print(f"Serial Extraction:   {serial_time:.2f} seconds")
print(f"Parallel Extraction: {parallel_time:.2f} seconds")
print(f"Speedup:             {serial_time/parallel_time:.2f}x faster")
print(f"Time Saved:          {serial_time - parallel_time:.2f} seconds")
print("="*70)

# Example output:
# ======================================================================
# PERFORMANCE COMPARISON
# ======================================================================
# Serial Extraction:   12.45 seconds  (3s + 3s + 3s + 3s)
# Parallel Extraction: 3.82 seconds   (all 4 at once, longest is 3.8s)
# Speedup:             3.26x faster
# Time Saved:          8.63 seconds
# ======================================================================
```

---

**Example 3: Mixed Sources (Files + API)**

```python
# Extract from files and API simultaneously
pipeline = ParallelETLPipeline(max_workers=5)

# Add file sources
pipeline.add_source(FileSource("File A", "data/camps_a.json"))
pipeline.add_source(FileSource("File B", "data/camps_b.json"))
pipeline.add_source(FileSource("File C", "data/camps_c.json"))

# Add API sources
pipeline.add_source(APISource("API 1", "https://api.example.com/camps?region=north"))
pipeline.add_source(APISource("API 2", "https://api.example.com/camps?region=south"))

pipeline.run()

# Output:
# 📥 PARALLEL EXTRACT PHASE (5 workers)
# 🔄 Extracting from File A...
# 🔄 Extracting from File B...
# 🔄 Extracting from File C...
# 🔄 Extracting from API 1...
# 🔄 Extracting from API 2...
# ✅ File A: 300 rows
# ✅ API 1: 150 rows
# ✅ File B: 250 rows
# ✅ File C: 280 rows
# ✅ API 2: 120 rows
# ✅ Parallel extract complete: 1100 total rows
```

---

#### ⚡ When to Use Each Executor Type

**ThreadPoolExecutor (recommended for ETL):**
```python
pipeline = ParallelETLPipeline(executor_type='thread')

# Use for:
# ✅ Reading files (JSON, CSV, XML)
# ✅ API calls (HTTP requests)
# ✅ Database queries
# ✅ Network I/O
# ✅ Waiting for external resources
```

**ProcessPoolExecutor:**
```python
pipeline = ParallelETLPipeline(executor_type='process')

# Use for:
# ✅ Heavy data transformations
# ✅ Complex calculations
# ✅ CPU-intensive operations
# ✅ Large dataset processing
# ⚠️  Requires data to be picklable
```

---

#### ✅ Key Takeaways

1. **Parallelism**: Extract from multiple sources simultaneously
2. **ThreadPoolExecutor**: Best for I/O-bound ETL tasks (files, APIs)
3. **as_completed()**: Process results as they finish (not in order)
4. **Error Isolation**: One failed source doesn't stop others
5. **Auto Workers**: Use `multiprocessing.cpu_count()` for optimal count
6. **3-10x Speedup**: Typical improvement for 4+ sources
7. **Production Ready**: Essential for real-world ETL pipelines
8. **Context Manager**: `with Executor() as executor:` ensures cleanup

**🎉 Parallel processing unlocks true ETL performance!** Your pipeline can now handle dozens of sources efficiently.

---

### Enhancement 3.2: Retry Logic with Exponential Backoff

**🎯 What It Does:**
Automatically retries failed operations with progressively increasing wait times between attempts - like knocking on a door, waiting longer each time before knocking again.

**💡 Why It Matters:**
- **Transient Errors**: Network glitches, temporary timeouts, server overload
- **Production Reliability**: 99.9% uptime requires handling temporary failures
- **Cost Savings**: Avoid manual intervention for recoverable errors
- **User Experience**: Seamless recovery without user awareness
- **API Rate Limits**: Respect API quotas with intelligent backoff

**🌟 Real-World Impact:**

**Without Retry Logic:**
```
Attempt 1: API call → ❌ Connection timeout
Pipeline: ⛔ FAILED (1 temporary error stops entire pipeline)
Result: Manual restart required
```

**With Retry Logic:**
```
Attempt 1: API call → ❌ Connection timeout → Wait 1s
Attempt 2: API call → ❌ Connection timeout → Wait 2s
Attempt 3: API call → ❌ Connection timeout → Wait 4s
Attempt 4: API call → ✅ SUCCESS (retrieved 500 rows)
Result: Pipeline continues automatically!
```

**Exponential Backoff**: Wait time doubles each retry (1s → 2s → 4s → 8s)

---

#### 📚 Why Exponential Backoff?

**Linear Backoff (Bad):**
```
Retry 1: Wait 1s
Retry 2: Wait 1s
Retry 3: Wait 1s
Problem: Hammers server too quickly, may exceed rate limits
```

**Exponential Backoff (Good):**
```
Retry 1: Wait 1s
Retry 2: Wait 2s  (2^1 = 2)
Retry 3: Wait 4s  (2^2 = 4)
Retry 4: Wait 8s  (2^3 = 8)
Benefit: Gives server time to recover, respects rate limits
```

**Formula:**
```python
delay = min(base_delay * (exponential_base ** attempt), max_delay)

# Example with base_delay=1, exponential_base=2, max_delay=60:
attempt=0: delay = min(1 * 2^0, 60) = min(1, 60)   = 1 second
attempt=1: delay = min(1 * 2^1, 60) = min(2, 60)   = 2 seconds
attempt=2: delay = min(1 * 2^2, 60) = min(4, 60)   = 4 seconds
attempt=3: delay = min(1 * 2^3, 60) = min(8, 60)   = 8 seconds
attempt=4: delay = min(1 * 2^4, 60) = min(16, 60)  = 16 seconds
attempt=5: delay = min(1 * 2^5, 60) = min(32, 60)  = 32 seconds
attempt=6: delay = min(1 * 2^6, 60) = min(64, 60)  = 60 seconds (capped)
attempt=7: delay = min(1 * 2^7, 60) = min(128, 60) = 60 seconds (capped)
```

---

#### 🔍 Complete Implementation

Create `src/retry.py`:

```python
import time
from functools import wraps

def retry_with_backoff(max_retries=3, base_delay=1, max_delay=60, exponential_base=2, 
                       exceptions=(Exception,)):
    """Decorator for retrying functions with exponential backoff.
    
    Automatically retries function on failure with increasing delays.
    
    Args:
        max_retries: Maximum number of retry attempts (default: 3)
                    Total attempts = max_retries + 1 (initial + retries)
                    Example: max_retries=3 means 4 total attempts
        
        base_delay: Initial delay in seconds (default: 1)
                   First retry waits this long
                   Example: base_delay=2 means first retry waits 2s
        
        max_delay: Maximum delay in seconds (default: 60)
                  Caps exponential growth
                  Example: max_delay=30 means never wait more than 30s
        
        exponential_base: Multiplier for each retry (default: 2)
                         2 = double each time
                         3 = triple each time
                         Example: base=2 gives 1s, 2s, 4s, 8s...
        
        exceptions: Tuple of exceptions to catch (default: all exceptions)
                   Only retry on these specific errors
                   Example: (ConnectionError, TimeoutError)
    
    Exponential backoff formula:
        delay = min(base_delay * (exponential_base ** attempt), max_delay)
    
    Example delays with base_delay=1, exponential_base=2, max_delay=60:
        Attempt 1: 1 second
        Attempt 2: 2 seconds
        Attempt 3: 4 seconds
        Attempt 4: 8 seconds
        Attempt 5: 16 seconds
        Attempt 6: 32 seconds
        Attempt 7: 60 seconds (capped)
    
    Example:
        >>> @retry_with_backoff(max_retries=3, base_delay=1)
        ... def fetch_api_data(url):
        ...     response = requests.get(url, timeout=5)
        ...     response.raise_for_status()
        ...     return response.json()
        >>> 
        >>> # Usage:
        >>> data = fetch_api_data('https://api.example.com/data')
        >>> 
        >>> # If it fails, will retry 3 times:
        >>> # Attempt 1: Immediate
        >>> # Attempt 2: Wait 1s, retry
        >>> # Attempt 3: Wait 2s, retry
        >>> # Attempt 4: Wait 4s, retry
        >>> # If all fail: raises original exception
    """
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_retries + 1):
                try:
                    # Try to execute function
                    return func(*args, **kwargs)
                
                except exceptions as e:
                    # Check if this was the last attempt
                    if attempt == max_retries:
                        # Last attempt failed, re-raise exception
                        print(f"❌ {func.__name__} failed after {max_retries} retries")
                        raise
                    
                    # Calculate delay with exponential backoff
                    delay = min(base_delay * (exponential_base ** attempt), max_delay)
                    
                    # Log retry information
                    print(f"⚠️  {func.__name__} failed (attempt {attempt + 1}/{max_retries + 1})")
                    print(f"   Error: {str(e)}")
                    print(f"   Retrying in {delay} seconds...")
                    
                    # Wait before retrying
                    time.sleep(delay)
            
        return wrapper
    return decorator
```

---

#### 🔍 Line-by-Line Breakdown

**Part 1: Decorator Pattern**

```python
def retry_with_backoff(max_retries=3, base_delay=1, ...):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Retry logic here
        return wrapper
    return decorator
```

**🔍 How decorators work:**

```python
# When you write:
@retry_with_backoff(max_retries=3, base_delay=1)
def fetch_api_data(url):
    return requests.get(url).json()

# Python internally does:
fetch_api_data = retry_with_backoff(max_retries=3, base_delay=1)(fetch_api_data)

# Step-by-step:
# 1. retry_with_backoff(max_retries=3, base_delay=1) returns decorator function
decorator = retry_with_backoff(max_retries=3, base_delay=1)

# 2. decorator(fetch_api_data) returns wrapper function
wrapper = decorator(fetch_api_data)

# 3. fetch_api_data now points to wrapper
fetch_api_data = wrapper

# 4. When you call fetch_api_data(url):
fetch_api_data('https://api.example.com')  # Actually calls wrapper(url)
# wrapper has retry logic + calls original fetch_api_data
```

**@wraps(func)**: Preserves original function's name and docstring

---

**Part 2: Retry Loop**

```python
for attempt in range(max_retries + 1):
    try:
        return func(*args, **kwargs)
    except exceptions as e:
        if attempt == max_retries:
            raise
        # Calculate delay and retry
```

**🔍 How the retry loop works:**

```python
max_retries = 3

# range(max_retries + 1) = range(4) = [0, 1, 2, 3]
# Total attempts = 4 (1 initial + 3 retries)

# Attempt 0 (initial):
attempt = 0
try:
    return func(*args, **kwargs)  # Try to call function
except Exception as e:
    if attempt == max_retries:    # 0 == 3? No
        raise
    # Calculate delay, sleep, continue to next iteration

# Attempt 1 (first retry):
attempt = 1
try:
    return func(*args, **kwargs)  # Try again
except Exception as e:
    if attempt == max_retries:    # 1 == 3? No
        raise
    # Calculate delay, sleep, continue

# Attempt 2 (second retry):
attempt = 2
try:
    return func(*args, **kwargs)  # Try again
except Exception as e:
    if attempt == max_retries:    # 2 == 3? No
        raise
    # Calculate delay, sleep, continue

# Attempt 3 (third retry, LAST):
attempt = 3
try:
    return func(*args, **kwargs)  # Try again
except Exception as e:
    if attempt == max_retries:    # 3 == 3? YES!
        print("❌ Failed after 3 retries")
        raise  # Give up, re-raise exception
```

---

**Part 3: Exponential Backoff Calculation**

```python
delay = min(base_delay * (exponential_base ** attempt), max_delay)
time.sleep(delay)
```

**🔍 How delay calculation works:**

```python
base_delay = 1
exponential_base = 2
max_delay = 60

# Attempt 0 (before first retry):
attempt = 0
delay = min(1 * (2 ** 0), 60)
      = min(1 * 1, 60)
      = min(1, 60)
      = 1 second
time.sleep(1)  # Wait 1 second

# Attempt 1 (before second retry):
attempt = 1
delay = min(1 * (2 ** 1), 60)
      = min(1 * 2, 60)
      = min(2, 60)
      = 2 seconds
time.sleep(2)  # Wait 2 seconds

# Attempt 2 (before third retry):
attempt = 2
delay = min(1 * (2 ** 2), 60)
      = min(1 * 4, 60)
      = min(4, 60)
      = 4 seconds
time.sleep(4)  # Wait 4 seconds

# Example with higher attempts:
attempt = 6
delay = min(1 * (2 ** 6), 60)
      = min(1 * 64, 60)
      = min(64, 60)
      = 60 seconds (capped by max_delay!)
time.sleep(60)  # Wait 60 seconds (not 64)
```

**Why min()?**: Prevents delay from growing too large

---

#### 📊 Usage Examples

**Example 1: Retryable API Source**

```python
from src.retry import retry_with_backoff
import requests

class RetryableAPISource(DataSource):
    """API source with automatic retry logic.
    
    Retries on connection errors and timeouts.
    """
    
    def __init__(self, name, api_url, max_retries=3):
        """Initialize retryable API source.
        
        Args:
            name: Source name
            api_url: API endpoint URL
            max_retries: Maximum retry attempts (default: 3)
        
        Example:
            >>> source = RetryableAPISource(
            ...     "Booking API",
            ...     "https://api.example.com/bookings",
            ...     max_retries=3
            ... )
        """
        super().__init__(name, "Retryable API")
        self.api_url = api_url
        self.max_retries = max_retries
    
    def connect(self):
        """No connection needed for APIs."""
        pass
    
    @retry_with_backoff(
        max_retries=3, 
        base_delay=1, 
        max_delay=30,
        exceptions=(requests.ConnectionError, requests.Timeout)
    )
    def extract(self):
        """Extract data from API with automatic retry.
        
        Will retry on network errors with exponential backoff.
        Only retries on ConnectionError and Timeout (not on 404, 500, etc.)
        
        Returns:
            list: API data
        
        Example:
            >>> source = RetryableAPISource("API", "https://api.example.com/data")
            >>> data = source.extract()
            >>> 
            >>> # Success on first try:
            >>> # 📡 Calling API: https://api.example.com/data
            >>> # ✅ Retrieved 500 rows from API
            >>> 
            >>> # With retries (transient error):
            >>> # 📡 Calling API: https://api.example.com/data
            >>> # ⚠️  extract failed (attempt 1/4)
            >>> #    Error: Connection timeout
            >>> #    Retrying in 1 seconds...
            >>> # 📡 Calling API: https://api.example.com/data
            >>> # ⚠️  extract failed (attempt 2/4)
            >>> #    Error: Connection timeout
            >>> #    Retrying in 2 seconds...
            >>> # 📡 Calling API: https://api.example.com/data
            >>> # ✅ Retrieved 500 rows from API (success!)
        """
        print(f"📡 Calling API: {self.api_url}")
        
        # This will automatically retry on ConnectionError or Timeout
        response = requests.get(self.api_url, timeout=10)
        response.raise_for_status()  # Raise on 4xx, 5xx (won't retry these)
        
        data = response.json()
        print(f"✅ Retrieved {len(data)} rows from API")
        
        return data
    
    def disconnect(self):
        """No disconnection needed."""
        pass


# Usage in pipeline:
pipeline = ETLPipeline()
pipeline.add_source(RetryableAPISource(
    "Booking API",
    "https://api.campings.com/bookings",
    max_retries=3
))
pipeline.run()
```

---

**Example 2: Retryable Database Loader**

```python
from src.retry import retry_with_backoff
import psycopg2
from psycopg2.extras import execute_batch

class RetryableDatabaseLoader(DataLoader):
    """Database loader with retry logic.
    
    Retries on connection errors, deadlocks, and timeouts.
    """
    
    def __init__(self, name, config, table_name, max_retries=5):
        """Initialize retryable database loader.
        
        Args:
            name: Loader name
            config: Database configuration dict
            table_name: Target table name
            max_retries: Maximum retry attempts (default: 5)
        
        Example:
            >>> db_config = {
            ...     'host': 'localhost',
            ...     'port': 5432,
            ...     'database': 'camping_db',
            ...     'user': 'etl_user',
            ...     'password': 'secret'
            ... }
            >>> 
            >>> loader = RetryableDatabaseLoader(
            ...     "PostgreSQL",
            ...     db_config,
            ...     "bookings",
            ...     max_retries=5
            ... )
        """
        super().__init__(name, "Retryable Database")
        self.config = config
        self.table_name = table_name
        self.max_retries = max_retries
        self.connection = None
    
    @retry_with_backoff(
        max_retries=5, 
        base_delay=2, 
        max_delay=30,
        exceptions=(psycopg2.OperationalError, psycopg2.InterfaceError)
    )
    def connect(self):
        """Connect to database with retry.
        
        Retries on connection failures (network issues, DB restart, etc.)
        
        Example:
            >>> loader.connect()
            >>> # 📡 Connecting to database...
            >>> # ✅ Connected to database
            >>> 
            >>> # With retry (DB temporarily down):
            >>> # 📡 Connecting to database...
            >>> # ⚠️  connect failed (attempt 1/6)
            >>> #    Error: could not connect to server
            >>> #    Retrying in 2 seconds...
            >>> # 📡 Connecting to database...
            >>> # ✅ Connected to database (success!)
        """
        print(f"📡 Connecting to database...")
        
        self.connection = psycopg2.connect(
            host=self.config['host'],
            port=self.config['port'],
            database=self.config['database'],
            user=self.config['user'],
            password=self.config['password'],
            connect_timeout=10
        )
        
        self.connection.autocommit = False
        print(f"✅ Connected to database")
    
    @retry_with_backoff(
        max_retries=3, 
        base_delay=1,
        max_delay=10,
        exceptions=(psycopg2.errors.DeadlockDetected, psycopg2.errors.QueryCanceled)
    )
    def load(self, data):
        """Load data with retry on deadlock/timeout.
        
        Retries on:
        - Deadlock: Two transactions blocking each other
        - QueryCanceled: Query timeout
        
        Args:
            data: List of dictionaries to load
        
        Example:
            >>> loader.load(data)
            >>> # ✅ Loaded 1000 rows
            >>> 
            >>> # With deadlock retry:
            >>> # ⚠️  load failed (attempt 1/4)
            >>> #    Error: deadlock detected
            >>> #    Retrying in 1 seconds...
            >>> # ✅ Loaded 1000 rows (success after retry!)
        """
        if not self.connection:
            raise Exception("Not connected to database!")
        
        cursor = self.connection.cursor()
        
        # Build INSERT query
        columns = list(data[0].keys())
        placeholders = ', '.join(['%s'] * len(columns))
        columns_str = ', '.join(columns)
        
        query = f"INSERT INTO {self.table_name} ({columns_str}) VALUES ({placeholders})"
        
        # Prepare data
        values = [tuple(row.get(col) for col in columns) for row in data]
        
        try:
            # Execute with automatic retry on deadlock/timeout
            execute_batch(cursor, query, values, page_size=1000)
            self.connection.commit()
            
            self.loaded_count = len(data)
            print(f"✅ Loaded {self.loaded_count} rows")
        
        except Exception as e:
            self.connection.rollback()
            raise
    
    def disconnect(self):
        """Disconnect from database."""
        if self.connection:
            self.connection.close()
            print("🔌 Disconnected from database")


# Usage:
db_config = {
    'host': 'localhost',
    'port': 5432,
    'database': 'camping_db',
    'user': 'etl_user',
    'password': 'secret_password'
}

pipeline = ETLPipeline()
pipeline.add_source(FileSource("Bookings", "data/bookings.json"))
pipeline.set_loader(RetryableDatabaseLoader("PostgreSQL", db_config, "bookings"))
pipeline.run()
```

---

**Example 3: Retry Specific Functions**

```python
from src.retry import retry_with_backoff
import requests

# Retry only on specific errors
@retry_with_backoff(
    max_retries=3,
    base_delay=1,
    exceptions=(ConnectionError, TimeoutError)  # Only retry these
)
def fetch_external_data(url):
    """Fetch data with retry on connection errors only.
    
    Won't retry on 404, 500, etc. - only connection issues.
    """
    response = requests.get(url, timeout=5)
    response.raise_for_status()  # 4xx/5xx will NOT retry
    return response.json()


# Aggressive retry for critical operations
@retry_with_backoff(
    max_retries=10,      # Try 11 times total
    base_delay=0.5,      # Start with 0.5s
    max_delay=120,       # Cap at 2 minutes
    exponential_base=2
)
def critical_database_operation():
    """Critical operation with aggressive retry."""
    # Database operation here
    pass


# Custom exponential base
@retry_with_backoff(
    max_retries=5,
    base_delay=1,
    exponential_base=3   # Triple each time: 1s, 3s, 9s, 27s, 81s
)
def slow_external_service():
    """Service that needs longer delays between retries."""
    # External service call
    pass


# Usage examples:
try:
    data = fetch_external_data('https://api.example.com/data')
    print(f"Success: {len(data)} rows")
except Exception as e:
    print(f"Failed after retries: {e}")
```

---

#### 🛡️ Circuit Breaker Pattern (Advanced)

**Problem:** If a service is down, retry logic will keep trying forever, wasting resources.

**Solution:** Circuit Breaker - stop trying after too many failures, check periodically if service recovered.

```python
import time

class CircuitBreaker:
    """Circuit breaker to prevent cascading failures.
    
    States:
    - CLOSED: Normal operation (everything working)
    - OPEN: Too many failures (stop trying, fail fast)
    - HALF_OPEN: Testing if service recovered (try once)
    
    State transitions:
    CLOSED --[too many failures]--> OPEN
    OPEN --[timeout elapsed]--> HALF_OPEN
    HALF_OPEN --[success]--> CLOSED
    HALF_OPEN --[failure]--> OPEN
    
    Example:
        >>> breaker = CircuitBreaker(failure_threshold=5, timeout=60)
        >>> 
        >>> # Normal operation (CLOSED):
        >>> result = breaker.call(lambda: api_call())  # Works
        >>> 
        >>> # After 5 failures (OPEN):
        >>> result = breaker.call(lambda: api_call())  # Fails immediately
        >>> # Exception: Circuit breaker OPEN (too many failures)
        >>> 
        >>> # After 60 seconds (HALF_OPEN):
        >>> result = breaker.call(lambda: api_call())  # Tries once
        >>> # If success: CLOSED
        >>> # If failure: OPEN again
    """
    
    def __init__(self, failure_threshold=5, timeout=60):
        """Initialize circuit breaker.
        
        Args:
            failure_threshold: Number of failures before opening circuit
                              Example: 5 means open after 5 consecutive failures
            timeout: Seconds to wait before testing service again
                    Example: 60 means wait 1 minute before HALF_OPEN
        
        Example:
            >>> # Strict: Open after 3 failures, wait 30s
            >>> breaker = CircuitBreaker(failure_threshold=3, timeout=30)
            >>> 
            >>> # Lenient: Open after 10 failures, wait 2 minutes
            >>> breaker = CircuitBreaker(failure_threshold=10, timeout=120)
        """
        self.failure_threshold = failure_threshold
        self.timeout = timeout
        self.failure_count = 0
        self.last_failure_time = None
        self.state = 'CLOSED'
    
    def call(self, func, *args, **kwargs):
        """Call function through circuit breaker.
        
        Args:
            func: Function to call
            *args: Positional arguments for function
            **kwargs: Keyword arguments for function
        
        Returns:
            Function result
        
        Raises:
            Exception: If circuit is OPEN or function fails
        
        Example:
            >>> breaker = CircuitBreaker(failure_threshold=3, timeout=60)
            >>> 
            >>> def flaky_api_call():
            ...     response = requests.get('https://api.example.com/data')
            ...     return response.json()
            >>> 
            >>> # Use circuit breaker:
            >>> try:
            ...     result = breaker.call(flaky_api_call)
            ...     print(f"Success: {len(result)} rows")
            ... except Exception as e:
            ...     print(f"Failed: {e}")
        """
        # Check if circuit is OPEN
        if self.state == 'OPEN':
            # Check if timeout elapsed
            if time.time() - self.last_failure_time >= self.timeout:
                # Try again (HALF_OPEN)
                self.state = 'HALF_OPEN'
                print("🔄 Circuit breaker: HALF_OPEN (testing if service recovered)")
            else:
                # Still in timeout period, fail fast
                wait_time = self.timeout - (time.time() - self.last_failure_time)
                raise Exception(
                    f"⛔ Circuit breaker OPEN (too many failures). "
                    f"Try again in {wait_time:.0f} seconds"
                )
        
        try:
            # Try to call function
            result = func(*args, **kwargs)
            
            # Success! Reset failure count
            self.failure_count = 0
            
            # If we were HALF_OPEN, service recovered
            if self.state == 'HALF_OPEN':
                self.state = 'CLOSED'
                print("✅ Circuit breaker: CLOSED (service recovered)")
            
            return result
        
        except Exception as e:
            # Failure! Increment count
            self.failure_count += 1
            self.last_failure_time = time.time()
            
            # Check if threshold reached
            if self.failure_count >= self.failure_threshold:
                self.state = 'OPEN'
                print(f"⛔ Circuit breaker: OPEN (failed {self.failure_count} times)")
            
            raise


# Usage with circuit breaker:
breaker = CircuitBreaker(failure_threshold=5, timeout=60)

def fetch_with_breaker(url):
    """Fetch data with circuit breaker protection."""
    return breaker.call(lambda: requests.get(url, timeout=5).json())

# Try to fetch data
for i in range(10):
    try:
        data = fetch_with_breaker('https://unstable-api.example.com/data')
        print(f"✅ Success: {len(data)} rows")
    except Exception as e:
        print(f"❌ Failed: {e}")
    
    time.sleep(5)

# Output example:
# ✅ Success: 100 rows
# ❌ Failed: Connection timeout
# ❌ Failed: Connection timeout
# ❌ Failed: Connection timeout
# ❌ Failed: Connection timeout
# ❌ Failed: Connection timeout
# ⛔ Circuit breaker: OPEN (failed 5 times)
# ❌ Failed: Circuit breaker OPEN. Try again in 55 seconds
# ❌ Failed: Circuit breaker OPEN. Try again in 50 seconds
# ... (waits 60 seconds) ...
# 🔄 Circuit breaker: HALF_OPEN (testing if service recovered)
# ✅ Success: 100 rows
# ✅ Circuit breaker: CLOSED (service recovered)
```

---

#### ✅ Key Takeaways

1. **Exponential Backoff**: Wait time doubles each retry (1s → 2s → 4s → 8s)
2. **Decorator Pattern**: `@retry_with_backoff()` adds retry to any function
3. **Specific Exceptions**: Only retry on transient errors (ConnectionError, Timeout)
4. **Max Delay Cap**: Prevent delays from growing too large
5. **Circuit Breaker**: Stop trying if service is down, fail fast
6. **Production Ready**: Essential for APIs, databases, external services
7. **Configurable**: Adjust max_retries, base_delay, exponential_base per use case
8. **Logging**: Always log retries for debugging

**🎉 Retry logic transforms fragile pipelines into production-ready systems!**

---

### Enhancement 3.3: Data Quality Dashboard (HTML Report)

**🎯 What It Does:**
Generates a beautiful, interactive HTML dashboard that visualizes ETL pipeline metrics - like a health report card for your data pipeline with charts, statistics, and status indicators.

**💡 Why It Matters:**
- **Visual Insights**: See pipeline health at a glance (charts, colors, metrics)
- **Stakeholder Communication**: Share professional reports with non-technical teams
- **Historical Tracking**: Save dashboards to compare performance over time
- **Data Quality Monitoring**: Identify trends, bottlenecks, and errors
- **Professional Presentation**: Impress clients/managers with polished reports

**🌟 Real-World Impact:**

**Without Dashboard (Terminal Output Only):**
```
======================================================================
📊 ETL STATISTICS
======================================================================
Sources extracted: 4
Total rows extracted: 1,523
...
(Gets lost in terminal history, hard to share)
```

**With Dashboard (Beautiful HTML Report):**
```html
📊 Interactive Dashboard
├── 📈 Key Metrics Cards
│   ├── Total Rows: 1,523 (green badge)
│   ├── Sources: 4 (blue badge)
│   ├── Duration: 3.2s (purple badge)
│   └── Success Rate: 100% (green badge)
├── 📊 Visual Charts
│   ├── Rows by Source (bar chart)
│   └── Processing Time (pie chart)
├── 📋 Detailed Tables
│   ├── Source breakdown
│   └── Transformation summary
└── ⚠️ Error Log (if any)

✅ Shareable URL: file:///reports/dashboard.html
✅ Opens in browser automatically
✅ Looks professional and polished
```

---

#### 📚 Dashboard Components

**1. Header Section:**
- Pipeline name and status
- Timestamp of execution
- Overall success/failure indicator

**2. Key Metrics Cards:**
- Total rows processed
- Number of sources
- Execution duration
- Success rate percentage

**3. Visualizations:**
- Bar chart: Rows by source
- Table: Source details
- Error log (if any)

**4. Styling:**
- Modern gradient background
- Card-based layout
- Responsive design
- Professional typography

---

#### 🔍 Complete Implementation

Create `src/dashboard.py`:

```python
from datetime import datetime
from pathlib import Path

class DataQualityDashboard:
    """Generate HTML dashboard with data quality metrics."""
    
    def __init__(self, output_file='reports/data_quality_dashboard.html'):
        """Initialize dashboard generator.
        
        Args:
            output_file: Path to output HTML file
        """
        self.output_file = Path(output_file)
        self.output_file.parent.mkdir(parents=True, exist_ok=True)
    
    def generate(self, statistics):
        """Generate HTML dashboard from statistics.
        
        Args:
            statistics: StatisticsCollector instance
        
        Example:
            >>> dashboard = DataQualityDashboard('reports/dashboard.html')
            >>> dashboard.generate(pipeline.statistics)
            >>> dashboard.open_in_browser()
        """
        html = self._build_html(statistics)
        
        with open(self.output_file, 'w', encoding='utf-8') as f:
            f.write(html)
        
        print(f"📊 Dashboard generated: {self.output_file}")
    
    def _build_html(self, stats):
        """Build HTML content.
        
        Args:
            stats: StatisticsCollector instance
            
        Returns:
            str: Complete HTML document
        """
        return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ETL Data Quality Dashboard</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            min-height: 100vh;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
        }}
        
        .header {{
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }}
        
        .header h1 {{
            color: #333;
            font-size: 32px;
            margin-bottom: 10px;
        }}
        
        .header .timestamp {{
            color: #666;
            font-size: 14px;
        }}
        
        .metrics-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }}
        
        .metric-card {{
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }}
        
        .metric-card .label {{
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }}
        
        .metric-card .value {{
            color: #333;
            font-size: 36px;
            font-weight: bold;
        }}
        
        .metric-card.success .value {{
            color: #10b981;
        }}
        
        .metric-card.warning .value {{
            color: #f59e0b;
        }}
        
        .metric-card.danger .value {{
            color: #ef4444;
        }}
        
        .section {{
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }}
        
        .section h2 {{
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
        }}
        
        .progress-bar {{
            height: 30px;
            background: #e5e7eb;
            border-radius: 15px;
            overflow: hidden;
            margin: 10px 0;
        }}
        
        .progress-fill {{
            height: 100%;
            background: linear-gradient(90deg, #10b981 0%, #059669 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            transition: width 0.3s ease;
        }}
        
        .error-list {{
            list-style: none;
        }}
        
        .error-item {{
            padding: 15px;
            background: #fef2f2;
            border-left: 4px solid #ef4444;
            margin-bottom: 10px;
            border-radius: 4px;
        }}
        
        .error-item .error-message {{
            color: #dc2626;
            font-weight: 500;
        }}
        
        .table {{
            width: 100%;
            border-collapse: collapse;
        }}
        
        .table th {{
            background: #f9fafb;
            padding: 12px;
            text-align: left;
            color: #374151;
            font-weight: 600;
            border-bottom: 2px solid #e5e7eb;
        }}
        
        .table td {{
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            color: #6b7280;
        }}
        
        .badge {{
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }}
        
        .badge.success {{
            background: #d1fae5;
            color: #065f46;
        }}
        
        .badge.warning {{
            background: #fef3c7;
            color: #92400e;
        }}
        
        .badge.info {{
            background: #dbeafe;
            color: #1e40af;
        }}
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>🔍 ETL Data Quality Dashboard</h1>
            <div class="timestamp">Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</div>
        </div>
        
        <!-- Key Metrics -->
        <div class="metrics-grid">
            <div class="metric-card success">
                <div class="label">Total Rows Extracted</div>
                <div class="value">{stats.get_total_extracted():,}</div>
            </div>
            
            <div class="metric-card success">
                <div class="label">Rows Loaded</div>
                <div class="value">{stats.get_loaded_count():,}</div>
            </div>
            
            <div class="metric-card {'danger' if stats.get_error_count() > 0 else 'success'}">
                <div class="label">Errors</div>
                <div class="value">{stats.get_error_count()}</div>
            </div>
            
            <div class="metric-card info">
                <div class="label">Execution Time</div>
                <div class="value">{stats.get_execution_time():.2f}s</div>
            </div>
        </div>
        
        <!-- Data Pipeline Progress -->
        <div class="section">
            <h2>📊 Pipeline Progress</h2>
            <div style="margin-bottom: 15px;">
                <strong>Extraction to Load Success Rate</strong>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: {(stats.get_loaded_count() / stats.get_total_extracted() * 100) if stats.get_total_extracted() > 0 else 0}%">
                        {(stats.get_loaded_count() / stats.get_total_extracted() * 100) if stats.get_total_extracted() > 0 else 0:.1f}%
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Sources Breakdown -->
        <div class="section">
            <h2>📥 Data Sources</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Source</th>
                        <th>Rows Extracted</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    {self._build_sources_table(stats)}
                </tbody>
            </table>
        </div>
        
        <!-- Errors -->
        {self._build_errors_section(stats)}
        
        <!-- Footer -->
        <div class="section" style="text-align: center; color: #666; font-size: 14px;">
            <p>Generated by ETL Pipeline v1.0</p>
            <p>For questions, contact the Data Engineering team</p>
        </div>
    </div>
</body>
</html>"""
    
    def _build_sources_table(self, stats):
        """Build HTML for sources table."""
        rows = []
        for source_name, count in stats.source_counts.items():
            badge = '<span class="badge success">✓ Success</span>'
            rows.append(f"""
                <tr>
                    <td><strong>{source_name}</strong></td>
                    <td>{count:,}</td>
                    <td>{badge}</td>
                </tr>
            """)
        return ''.join(rows) if rows else '<tr><td colspan="3">No sources</td></tr>'
    
    def _build_errors_section(self, stats):
        """Build HTML for errors section."""
        if stats.get_error_count() == 0:
            return """
                <div class="section">
                    <h2>✅ Errors</h2>
                    <p style="color: #10b981; font-weight: 500;">No errors detected! Pipeline executed successfully.</p>
                </div>
            """
        
        error_items = ''.join([
            f'<li class="error-item"><div class="error-message">{error}</div></li>'
            for error in stats.errors
        ])
        
        return f"""
            <div class="section">
                <h2>❌ Errors ({stats.get_error_count()})</h2>
                <ul class="error-list">
                    {error_items}
                </ul>
            </div>
        """
    
    def open_in_browser(self):
        """Open dashboard in web browser."""
        import webbrowser
        import os
        
        file_url = f"file://{os.path.abspath(self.output_file)}"
        webbrowser.open(file_url)
        print(f"🌐 Opening dashboard in browser...")


# Usage in main.py:
def main():
    # ... run pipeline ...
    
    pipeline.run()
    
    # Generate dashboard
    dashboard = DataQualityDashboard('reports/dashboard.html')
    dashboard.generate(pipeline.statistics)
    dashboard.open_in_browser()
```

---

#### 📊 Line-by-Line Breakdown

**Part 1: HTML Structure with f-strings**

```python
return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ETL Data Quality Dashboard</title>
    <style>/* CSS here */</style>
</head>
<body>
    <div class="container">
        <!-- Content here -->
    </div>
</body>
</html>"""
```

**🔍 How f-string HTML generation works:**

```python
# Variables to inject:
total_rows = 1523
num_sources = 4
duration = 3.24

# f-string with HTML:
html = f"""
<div class="metric-card">
    <div class="label">Total Rows</div>
    <div class="value">{total_rows:,}</div>
</div>
"""

# Result:
# <div class="metric-card">
#     <div class="label">Total Rows</div>
#     <div class="value">1,523</div>  ← Formatted with comma!
# </div>

# Format specifiers:
{total_rows:,}      # 1,523 (thousands separator)
{duration:.2f}      # 3.24 (2 decimal places)
{success_rate}%     # 100% (concatenation)
```

---

**Part 2: CSS Inline Styling**

```python
<style>
    body {{
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }}
</style>
```

**🔍 Why double curly braces?**

```python
# In Python f-strings, { and } are special
# To include literal { } in output, double them:

# Wrong (Python tries to evaluate):
f"<style> body {{ color: red; }} </style>"
# Error: '}' expected

# Correct (escape with double braces):
f"<style> body {{{{ color: red; }}}} </style>"
# Output: <style> body { color: red; } </style>

# Inside _build_html():
return f"""<style>
    .container {{    ← Double {{ becomes single {
        max-width: 1200px;
    }}                ← Double }} becomes single }
</style>"""

# Result:
# <style>
#     .container {
#         max-width: 1200px;
#     }
# </style>
```

---

**Part 3: Building Sections Dynamically**

```python
metrics_cards = self._build_metrics_cards(total_rows, num_sources, duration, success_rate)
source_table = self._build_source_table(stats)
errors_section = self._build_errors_section(stats)

return f"""<body>
    {metrics_cards}
    {source_table}
    {errors_section}
</body>"""
```

**🔍 Modular HTML generation:**

```python
# Step 1: Build metrics cards
def _build_metrics_cards(self, total_rows, num_sources, duration, success_rate):
    return f"""
    <div class="metrics-grid">
        <div class="metric-card">
            <div class="value">{total_rows:,}</div>
        </div>
        ...
    </div>
    """

# Returns: String of HTML

# Step 2: Build source table
def _build_source_table(self, stats):
    rows = []
    for source_name, count in stats.source_counts.items():
        rows.append(f"<tr><td>{source_name}</td><td>{count}</td></tr>")
    
    return f"""
    <table>
        <tbody>
            {''.join(rows)}
        </tbody>
    </table>
    """

# Returns: String of HTML

# Step 3: Combine all sections
html = f"""
<!DOCTYPE html>
<html>
<body>
    {self._build_metrics_cards(...)}   ← Injected here
    {self._build_source_table(...)}    ← Injected here
    {self._build_errors_section(...)}  ← Injected here
</body>
</html>
"""

# Each method returns HTML string, injected into final document
```

---

#### 📊 Usage Examples

**Example 1: Basic Dashboard Generation**

```python
# main.py

from src.pipeline import ETLPipeline
from src.sources import FileSource
from src.loaders import FileLoader
from src.dashboard import DataQualityDashboard

def main():
    # Create pipeline
    pipeline = ETLPipeline()
    pipeline.add_source(FileSource("Bookings", "data/bookings.json"))
    pipeline.add_source(FileSource("Reviews", "data/reviews.json"))
    pipeline.set_loader(FileLoader("Output", "data/output/combined.json"))
    
    # Run pipeline
    pipeline.run()
    
    # Generate dashboard
    dashboard = DataQualityDashboard()
    dashboard.generate(pipeline.statistics)
    dashboard.open_in_browser()

if __name__ == '__main__':
    main()

# Output:
# ======================================================================
# 🔄 EXTRACT PHASE
# ======================================================================
# 📂 Extracting from Bookings...
# ✅ Extracted 1,200 rows
# 📂 Extracting from Reviews...
# ✅ Extracted 323 rows
# ✅ Extract phase complete: 1,523 rows
# 
# ======================================================================
# 💾 LOAD PHASE
# ======================================================================
# 📝 Loading to Output...
# ✅ Loaded 1,523 rows
# 
# ======================================================================
# 📊 ETL STATISTICS
# ======================================================================
# Duration: 3.24 seconds
# Errors: 0
# ======================================================================
# 
# 📊 Dashboard generated: reports/data_quality_dashboard.html
#    File size: 8.3 KB
# 🌐 Opening dashboard in browser...
```

---

**Example 2: Timestamped Reports for History**

```python
from datetime import datetime
from src.dashboard import DataQualityDashboard

# Run daily pipeline and save timestamped dashboard
def daily_etl_job():
    # Run pipeline
    pipeline = ETLPipeline()
    # ... configure and run ...
    pipeline.run()
    
    # Generate timestamped dashboard
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    output_file = f'reports/history/dashboard_{timestamp}.html'
    
    dashboard = DataQualityDashboard(output_file)
    dashboard.generate(pipeline.statistics)
    
    print(f"✅ Report saved: {output_file}")

# Run daily
daily_etl_job()

# Result directory structure:
# reports/
#   └── history/
#       ├── dashboard_20241020_060000.html  (Oct 20, 6:00 AM)
#       ├── dashboard_20241020_120000.html  (Oct 20, 12:00 PM)
#       ├── dashboard_20241020_180000.html  (Oct 20, 6:00 PM)
#       ├── dashboard_20241021_060000.html  (Oct 21, 6:00 AM)
#       └── ...
#
# Benefits:
# - Track performance trends over time
# - Compare today vs yesterday
# - Identify when errors started
# - Show improvements to stakeholders
```

---

**Example 3: Email Dashboard to Stakeholders**

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from pathlib import Path

def send_dashboard_email(dashboard_path, recipients, smtp_config):
    """Send dashboard HTML as email attachment.
    
    Args:
        dashboard_path: Path to HTML dashboard file
        recipients: List of email addresses
        smtp_config: Dict with SMTP settings
    
    Example:
        >>> smtp_config = {
        ...     'host': 'smtp.gmail.com',
        ...     'port': 587,
        ...     'username': 'etl@company.com',
        ...     'password': 'app_password'
        ... }
        >>> 
        >>> send_dashboard_email(
        ...     'reports/dashboard.html',
        ...     ['manager@company.com', 'team@company.com'],
        ...     smtp_config
        ... )
    """
    # Read dashboard file
    dashboard_path = Path(dashboard_path)
    
    # Create email
    sender = smtp_config['username']
    subject = f'Daily ETL Dashboard - {datetime.now().strftime("%Y-%m-%d")}'
    
    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = ', '.join(recipients)
    msg['Subject'] = subject
    
    # Email body
    body = """
    Hello Team,
    
    Please find attached today's ETL pipeline dashboard report.
    
    Key Highlights:
    • Total rows processed: 1,523
    • Data sources: 2
    • Execution time: 3.2 seconds
    • Status: ✅ SUCCESS
    
    Open the attached HTML file in your browser to view the full interactive dashboard.
    
    Best regards,
    ETL Pipeline Bot 🤖
    """
    msg.attach(MIMEText(body, 'plain'))
    
    # Attach dashboard HTML
    with open(dashboard_path, 'rb') as f:
        attachment = MIMEBase('text', 'html')
        attachment.set_payload(f.read())
        encoders.encode_base64(attachment)
        attachment.add_header(
            'Content-Disposition',
            f'attachment; filename={dashboard_path.name}'
        )
        msg.attach(attachment)
    
    # Send email
    with smtplib.SMTP(smtp_config['host'], smtp_config['port']) as server:
        server.starttls()
        server.login(smtp_config['username'], smtp_config['password'])
        server.send_message(msg)
    
    print(f"📧 Dashboard emailed to {len(recipients)} recipients")


# Usage in daily pipeline:
def main():
    # Run pipeline
    pipeline = ETLPipeline()
    # ... configure ...
    pipeline.run()
    
    # Generate dashboard
    dashboard = DataQualityDashboard('reports/daily_dashboard.html')
    dashboard.generate(pipeline.statistics)
    
    # Email to stakeholders
    smtp_config = {
        'host': 'smtp.gmail.com',
        'port': 587,
        'username': 'etl@company.com',
        'password': 'your_app_password'
    }
    
    send_dashboard_email(
        'reports/daily_dashboard.html',
        recipients=[
            'manager@company.com',
            'data_team@company.com',
            'cto@company.com'
        ],
        smtp_config=smtp_config
    )

# Run daily at 6 AM
# (see Enhancement 3.4 for scheduling)
```

---

#### ✅ Key Takeaways

1. **HTML Generation**: Use Python f-strings to build HTML dynamically
2. **Inline CSS**: Embed styles in `<style>` tags for single-file portability
3. **Double Braces**: Escape CSS `{ }` with `{{ }}` in f-strings
4. **Modular Building**: Separate methods for metrics, tables, errors
5. **webbrowser Module**: Auto-open HTML in default browser
6. **Format Specifiers**: `{value:,}` for thousands, `{value:.2f}` for decimals
7. **File Paths**: Use `pathlib.Path` for cross-platform compatibility
8. **Timestamped Reports**: Track history for trend analysis

**🎉 Beautiful dashboards make data quality visible and shareable!**

---

### Enhancement 3.4: Automated Scheduling

**🎯 What It Does:**
Runs ETL pipeline automatically on a schedule (hourly, daily, weekly).

**💡 Why It Matters:**
- Automated data updates
- No manual intervention needed
- Production ETL requirement

**🔍 Implementation:**

Install schedule library:
```bash
pip install schedule
```

Create `src/scheduler.py`:

```python
import schedule
import time
from datetime import datetime

class ETLScheduler:
    """Schedule ETL pipeline execution."""
    
    def __init__(self, pipeline_func):
        """Initialize scheduler.
        
        Args:
            pipeline_func: Function that runs the pipeline
        
        Example:
            >>> def run_etl():
            ...     pipeline = ETLPipeline()
            ...     # ... setup pipeline ...
            ...     pipeline.run()
            >>> 
            >>> scheduler = ETLScheduler(run_etl)
        """
        self.pipeline_func = pipeline_func
        self.last_run = None
        self.run_count = 0
    
    def run_pipeline(self):
        """Execute pipeline and track statistics."""
        print("\n" + "="*70)
        print(f"🕐 SCHEDULED RUN #{self.run_count + 1}")
        print(f"   Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("="*70 + "\n")
        
        try:
            self.pipeline_func()
            self.last_run = datetime.now()
            self.run_count += 1
            print(f"\n✅ Scheduled run #{self.run_count} completed successfully")
        except Exception as e:
            print(f"\n❌ Scheduled run failed: {str(e)}")
    
    def schedule_hourly(self, minute=0):
        """Schedule pipeline to run every hour at specified minute.
        
        Args:
            minute: Minute of hour to run (0-59)
        
        Example:
            >>> scheduler.schedule_hourly(minute=30)
            >>> # Runs at: 00:30, 01:30, 02:30, ...
        """
        schedule.every().hour.at(f":{minute:02d}").do(self.run_pipeline)
        print(f"📅 Scheduled: Every hour at minute {minute}")
    
    def schedule_daily(self, time_str="00:00"):
        """Schedule pipeline to run daily at specified time.
        
        Args:
            time_str: Time in "HH:MM" format
        
        Example:
            >>> scheduler.schedule_daily("03:00")
            >>> # Runs every day at 3:00 AM
        """
        schedule.every().day.at(time_str).do(self.run_pipeline)
        print(f"📅 Scheduled: Every day at {time_str}")
    
    def schedule_weekly(self, day="monday", time_str="00:00"):
        """Schedule pipeline to run weekly.
        
        Args:
            day: Day of week (monday, tuesday, ..., sunday)
            time_str: Time in "HH:MM" format
        
        Example:
            >>> scheduler.schedule_weekly("monday", "06:00")
            >>> # Runs every Monday at 6:00 AM
        """
        day_func = getattr(schedule.every(), day.lower())
        day_func.at(time_str).do(self.run_pipeline)
        print(f"📅 Scheduled: Every {day} at {time_str}")
    
    def schedule_interval(self, minutes):
        """Schedule pipeline to run every N minutes.
        
        Args:
            minutes: Interval in minutes
        
        Example:
            >>> scheduler.schedule_interval(30)
            >>> # Runs every 30 minutes
        """
        schedule.every(minutes).minutes.do(self.run_pipeline)
        print(f"📅 Scheduled: Every {minutes} minutes")
    
    def start(self, run_immediately=True):
        """Start scheduler loop.
        
        Args:
            run_immediately: Run pipeline once before scheduling
        
        Example:
            >>> scheduler.schedule_daily("03:00")
            >>> scheduler.start()
            >>> # Runs forever, executing at scheduled times
        """
        print("\n" + "="*70)
        print("🚀 ETL SCHEDULER STARTED")
        print("="*70)
        
        # Show scheduled jobs
        print("\nScheduled jobs:")
        for job in schedule.get_jobs():
            print(f"  • {job}")
        
        print(f"\nPress Ctrl+C to stop scheduler\n")
        
        # Run immediately if requested
        if run_immediately:
            self.run_pipeline()
        
        # Main scheduler loop
        try:
            while True:
                schedule.run_pending()
                time.sleep(1)
        except KeyboardInterrupt:
            print("\n\n" + "="*70)
            print("⏸  SCHEDULER STOPPED")
            print("="*70)
            print(f"Total runs: {self.run_count}")
            if self.last_run:
                print(f"Last run: {self.last_run.strftime('%Y-%m-%d %H:%M:%S')}")


# Example: scheduler_main.py
def run_etl_pipeline():
    """Function that runs your ETL pipeline."""
    from src.pipeline import ETLPipeline
    from src.sources import FileSource
    from src.loaders import FileLoader
    
    # Setup pipeline
    pipeline = ETLPipeline()
    pipeline.add_source(FileSource("Camps", "data/campsites.json"))
    pipeline.set_loader(FileLoader("Output", "output/processed.csv", "csv"))
    
    # Run pipeline
    pipeline.run()
    
    # Generate dashboard
    from src.dashboard import DataQualityDashboard
    dashboard = DataQualityDashboard(f'reports/dashboard_{datetime.now().strftime("%Y%m%d_%H%M%S")}.html')
    dashboard.generate(pipeline.statistics)


if __name__ == "__main__":
    # Create scheduler
    scheduler = ETLScheduler(run_etl_pipeline)
    
    # Option 1: Run every hour
    scheduler.schedule_hourly(minute=0)
    
    # Option 2: Run daily at 3 AM
    # scheduler.schedule_daily("03:00")
    
    # Option 3: Run every Monday at 6 AM
    # scheduler.schedule_weekly("monday", "06:00")
    
    # Option 4: Run every 30 minutes
    # scheduler.schedule_interval(30)
    
    # Start scheduler
    scheduler.start(run_immediately=True)
```

**📊 Advanced Scheduling with APScheduler:**

```bash
pip install apscheduler
```

```python
from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger

class AdvancedETLScheduler:
    """Advanced scheduler with APScheduler."""
    
    def __init__(self, pipeline_func):
        """Initialize advanced scheduler."""
        self.pipeline_func = pipeline_func
        self.scheduler = BlockingScheduler()
    
    def schedule_cron(self, cron_expression, job_id="etl_job"):
        """Schedule using cron expression.
        
        Args:
            cron_expression: Cron string (minute hour day month day_of_week)
            job_id: Unique job identifier
        
        Examples:
            # Every day at 3:00 AM
            scheduler.schedule_cron("0 3 * * *")
            
            # Every Monday at 6:00 AM
            scheduler.schedule_cron("0 6 * * 1")
            
            # Every hour at minute 0
            scheduler.schedule_cron("0 * * * *")
            
            # Every 30 minutes
            scheduler.schedule_cron("*/30 * * * *")
        """
        trigger = CronTrigger.from_crontab(cron_expression)
        self.scheduler.add_job(
            self.pipeline_func,
            trigger=trigger,
            id=job_id,
            max_instances=1,  # Only one instance at a time
            replace_existing=True
        )
        print(f"📅 Cron scheduled: {cron_expression}")
    
    def start(self):
        """Start advanced scheduler."""
        print("\n🚀 Advanced ETL Scheduler Started")
        print("Press Ctrl+C to stop\n")
        
        try:
            self.scheduler.start()
        except KeyboardInterrupt:
            print("\n⏸  Scheduler Stopped")


# Usage:
scheduler = AdvancedETLScheduler(run_etl_pipeline)
scheduler.schedule_cron("0 3 * * *")  # Daily at 3 AM
scheduler.start()
```

---

### 📖 Line-by-Line Breakdown

Let's understand how scheduling works by breaking down the `ETLScheduler` class in detail.

---

#### **Part 1: How `schedule.every()` Works**

The `schedule` library uses **method chaining** to build human-readable schedules. Let's see how it works:

```python
import schedule

# What happens when you call schedule.every():
schedule_obj = schedule.every()  # Returns a Job object

# Method chaining builds the schedule:
schedule_obj.hour.at(":15")  # "Every hour at :15 minutes"

# Equivalent to:
schedule.every().hour.at(":15")  # This is what we actually write
```

**How It Works:**
1. `schedule.every()` → Returns a `Job` object
2. `.hour` → Configures job to run every hour (property access)
3. `.at(":15")` → Specifies minute to run (method call)
4. `.do(function)` → Registers the function to execute

**Visual Timeline:**
```
Without scheduling (manual):
You: Run pipeline manually at random times
     ↓
Pipeline runs when you remember
     ↓
Inconsistent, error-prone

With schedule.every().hour.at(":15"):
12:15 → Pipeline runs automatically
13:15 → Pipeline runs automatically
14:15 → Pipeline runs automatically
15:15 → Pipeline runs automatically
(Every hour at :15 past the hour)
```

---

#### **Part 2: The `schedule_hourly()` Method**

Let's break down how `schedule_hourly()` schedules jobs to run every hour:

```python
def schedule_hourly(self, minute=0):
    """Schedule ETL to run every hour at specified minute."""
    schedule.every().hour.at(f":{minute:02d}").do(self.job_func)
    print(f"⏰ Scheduled: Every hour at :{minute:02d}")
```

**Line-by-Line Explanation:**

**Line 1: `schedule.every().hour.at(f":{minute:02d}").do(self.job_func)`**

Let's break this into parts:

1. **`schedule.every()`**:
   - Returns a `Job` object from the schedule library
   - This object supports method chaining
   - Think of it as: "Start building a schedule"

2. **`.hour`**:
   - Property that configures the job to run every hour
   - Returns the same Job object for continued chaining
   - Think of it as: "Make this happen every hour"

3. **`.at(f":{minute:02d}")`**:
   - Specifies the minute within the hour to run
   - `f":{minute:02d}"` formats the minute with leading zero (e.g., `:05`, `:15`)
   - The `:` prefix indicates "minutes past the hour"
   - Example: `:00` = run at top of each hour, `:30` = run at half past
   - Returns the Job object

4. **`.do(self.job_func)`**:
   - Registers the function to execute on schedule
   - `self.job_func` is the ETL pipeline function passed in `__init__`
   - This completes the schedule configuration

**Example:**
```python
# If minute=15:
schedule.every().hour.at(":15").do(run_etl_pipeline)

# Expands to:
":15" → ":15" (formatted with :02d)
      → "Run at 15 minutes past every hour"
      → 00:15, 01:15, 02:15, 03:15, etc.
```

**Line 2: `print(f"⏰ Scheduled: Every hour at :{minute:02d}")`**

- Confirms the schedule to the user
- `{minute:02d}` formats minute with leading zero (5 → 05, 15 → 15)
- Output example: `⏰ Scheduled: Every hour at :00`

---

#### **Part 3: The Main Scheduler Loop**

Let's understand how `schedule.run_pending()` checks and executes scheduled jobs:

```python
def start(self, run_immediately=True):
    """Start the scheduler loop."""
    print(f"🚀 Scheduler Started at {datetime.now()}")
    
    if run_immediately:
        print("▶  Running pipeline immediately...")
        self.job_func()
    
    print("Press Ctrl+C to stop\n")
    
    while True:
        schedule.run_pending()  # Check if any job should run now
        time.sleep(60)          # Wait 60 seconds before checking again
```

**Line-by-Line Explanation:**

**Line 1: `if run_immediately:`**
- Option to run the pipeline immediately on startup
- Useful to verify pipeline works before waiting for scheduled time
- Calls `self.job_func()` directly (not through scheduler)

**Line 2: `while True:`**
- **Infinite loop** that keeps the scheduler running forever
- The scheduler must continuously check if it's time to run jobs
- Only stops when you press `Ctrl+C` (raises `KeyboardInterrupt`)

**Line 3: `schedule.run_pending()`**
- **Core scheduling function** that checks all registered jobs
- Compares current time with scheduled times
- If a job's scheduled time has arrived, it executes the job function
- Does nothing if no jobs are due

**How `run_pending()` Works Internally:**
```python
# Pseudocode of what schedule.run_pending() does:
current_time = datetime.now()
for job in all_scheduled_jobs:
    if job.should_run(current_time):  # Is it time?
        job.run()                      # Execute the function
        job.schedule_next_run()        # Calculate next run time
```

**Line 4: `time.sleep(60)`**
- **Pause for 60 seconds** before checking again
- Prevents the loop from consuming CPU constantly
- Trade-off: Jobs won't run exactly on time (up to 60s delay)
- For hourly jobs, 60s sleep is fine (1 minute precision)
- For minute-level precision, use smaller sleep (e.g., `time.sleep(1)`)

**Why Sleep 60 Seconds?**
```
Without sleep:
while True:
    run_pending()  # Checks immediately
    run_pending()  # Checks again 0.001s later
    run_pending()  # Checks again 0.001s later
    # CPU: 100% usage checking thousands of times per second! ❌

With sleep(60):
while True:
    run_pending()  # Checks now
    sleep(60)      # Wait 1 minute
    run_pending()  # Checks 1 minute later
    # CPU: <1% usage checking once per minute ✅
```

---

### 🧪 Usage Examples

Now let's see the scheduler in action with real scenarios.

---

#### **Example 1: Hourly ETL Pipeline**

Run your ETL pipeline every hour to keep data fresh:

```python
# main_scheduled.py
import schedule
import time
from datetime import datetime
from pathlib import Path

class ETLScheduler:
    def __init__(self, job_func):
        self.job_func = job_func
    
    def schedule_hourly(self, minute=0):
        schedule.every().hour.at(f":{minute:02d}").do(self.job_func)
        print(f"⏰ Scheduled: Every hour at :{minute:02d}")
    
    def start(self, run_immediately=True):
        print(f"🚀 Scheduler Started at {datetime.now()}")
        
        if run_immediately:
            print("▶  Running pipeline immediately...")
            self.job_func()
        
        print("Press Ctrl+C to stop\n")
        
        while True:
            schedule.run_pending()
            time.sleep(60)

def run_etl_pipeline():
    """Your actual ETL pipeline."""
    print(f"\n{'='*50}")
    print(f"⏰ Pipeline Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*50}")
    
    # Simulate ETL work
    print("📥 Extracting data from API...")
    time.sleep(2)
    print("🔄 Transforming data...")
    time.sleep(2)
    print("💾 Loading data to database...")
    time.sleep(2)
    
    print(f"✅ Pipeline Completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*50}\n")

# Run scheduler
scheduler = ETLScheduler(run_etl_pipeline)
scheduler.schedule_hourly(minute=0)  # Every hour at :00
scheduler.start()
```

**Output:**
```
🚀 Scheduler Started at 2024-01-15 14:23:45
▶  Running pipeline immediately...

==================================================
⏰ Pipeline Started: 2024-01-15 14:23:45
==================================================
📥 Extracting data from API...
🔄 Transforming data...
💾 Loading data to database...
✅ Pipeline Completed: 2024-01-15 14:23:51
==================================================

⏰ Scheduled: Every hour at :00
Press Ctrl+C to stop

(Waits until 15:00:00...)

==================================================
⏰ Pipeline Started: 2024-01-15 15:00:00
==================================================
📥 Extracting data from API...
🔄 Transforming data...
💾 Loading data to database...
✅ Pipeline Completed: 2024-01-15 15:00:06
==================================================

(Waits until 16:00:00...)
```

**Timeline:**
```
14:23 → Scheduler starts, runs pipeline immediately
14:24 → Waits...
...
15:00 → Pipeline runs (scheduled)
15:01 → Waits...
...
16:00 → Pipeline runs (scheduled)
16:01 → Waits...
...
(Continues forever until Ctrl+C)
```

---

#### **Example 2: Daily Data Warehouse Load**

Run a heavy ETL job once per day at night when traffic is low:

```python
# daily_warehouse_load.py
import schedule
import time
from datetime import datetime

class ETLScheduler:
    def __init__(self, job_func):
        self.job_func = job_func
    
    def schedule_daily(self, time_str="00:00"):
        schedule.every().day.at(time_str).do(self.job_func)
        print(f"⏰ Scheduled: Daily at {time_str}")
    
    def start(self, run_immediately=False):
        print(f"🚀 Scheduler Started at {datetime.now()}")
        
        if run_immediately:
            print("▶  Running pipeline immediately...")
            self.job_func()
        
        print("Press Ctrl+C to stop\n")
        
        while True:
            schedule.run_pending()
            time.sleep(60)

def warehouse_etl():
    """Heavy daily ETL job."""
    print(f"\n{'='*60}")
    print(f"🏢 Data Warehouse ETL Started: {datetime.now()}")
    print(f"{'='*60}")
    
    # Simulate heavy processing
    print("📥 Extracting from 10 different sources...")
    time.sleep(3)
    print("🔄 Transforming 1M rows...")
    time.sleep(5)
    print("💾 Loading to Snowflake warehouse...")
    time.sleep(3)
    print("📊 Running aggregations...")
    time.sleep(2)
    
    print(f"✅ Warehouse Load Complete: {datetime.now()}")
    print(f"{'='*60}\n")

# Schedule for 3 AM every night
scheduler = ETLScheduler(warehouse_etl)
scheduler.schedule_daily(time_str="03:00")  # 3 AM daily
scheduler.start(run_immediately=False)  # Don't run on startup
```

**Output:**
```
🚀 Scheduler Started at 2024-01-15 14:30:00
⏰ Scheduled: Daily at 03:00
Press Ctrl+C to stop

(Waits until 03:00:00 next day...)

==================================================
🏢 Data Warehouse ETL Started: 2024-01-16 03:00:00
==================================================
📥 Extracting from 10 different sources...
🔄 Transforming 1M rows...
💾 Loading to Snowflake warehouse...
📊 Running aggregations...
✅ Warehouse Load Complete: 2024-01-16 03:00:13
==================================================

(Waits 24 hours until next 03:00...)
```

---

#### **Example 3: Multiple Schedules for Different Pipelines**

Run different pipelines on different schedules:

```python
# multi_pipeline_scheduler.py
import schedule
import time
from datetime import datetime

def sales_pipeline():
    """Quick sales data update."""
    print(f"💰 Sales Pipeline: {datetime.now().strftime('%H:%M:%S')}")

def inventory_pipeline():
    """Inventory reconciliation."""
    print(f"📦 Inventory Pipeline: {datetime.now().strftime('%H:%M:%S')}")

def analytics_pipeline():
    """Heavy analytics processing."""
    print(f"📊 Analytics Pipeline: {datetime.now().strftime('%H:%M:%S')}")

# Schedule multiple pipelines with different frequencies
schedule.every(15).minutes.do(sales_pipeline)       # Every 15 minutes
schedule.every().hour.at(":00").do(inventory_pipeline)  # Every hour
schedule.every().day.at("02:00").do(analytics_pipeline)  # Daily at 2 AM

print("🚀 Multi-Pipeline Scheduler Started")
print("⏰ Sales: Every 15 minutes")
print("⏰ Inventory: Every hour at :00")
print("⏰ Analytics: Daily at 02:00")
print("Press Ctrl+C to stop\n")

while True:
    schedule.run_pending()
    time.sleep(60)
```

**Output (sample hour):**
```
🚀 Multi-Pipeline Scheduler Started
⏰ Sales: Every 15 minutes
⏰ Inventory: Every hour at :00
⏰ Analytics: Daily at 02:00
Press Ctrl+C to stop

14:00 → 💰 Sales Pipeline: 14:00:00
14:00 → 📦 Inventory Pipeline: 14:00:00
14:15 → 💰 Sales Pipeline: 14:15:00
14:30 → 💰 Sales Pipeline: 14:30:00
14:45 → 💰 Sales Pipeline: 14:45:00
15:00 → 💰 Sales Pipeline: 15:00:00
15:00 → 📦 Inventory Pipeline: 15:00:00
...
```

---

### 📖 Understanding Cron Expressions

**APScheduler** supports **cron expressions** for advanced scheduling. Let's learn how to read them:

---

#### **Cron Expression Format**

A cron expression has **5 fields** separated by spaces:

```
minute  hour  day  month  day_of_week
  |      |     |     |         |
  0      3     *     *         *
```

**Field Values:**
- **minute**: 0-59
- **hour**: 0-23 (24-hour format)
- **day**: 1-31 (day of month)
- **month**: 1-12 (or JAN-DEC)
- **day_of_week**: 0-6 (0 = Sunday, or MON-SUN)

**Special Characters:**
- `*` = Any value (every)
- `/` = Increment (every N units)
- `,` = List of values
- `-` = Range of values

---

#### **Common Cron Expression Examples**

| Expression | Meaning | When It Runs |
|------------|---------|--------------|
| `0 3 * * *` | Daily at 3 AM | 03:00 every day |
| `*/15 * * * *` | Every 15 minutes | :00, :15, :30, :45 every hour |
| `0 */2 * * *` | Every 2 hours | 00:00, 02:00, 04:00, 06:00, ... |
| `0 9-17 * * MON-FRI` | Business hours | 9 AM to 5 PM, Monday-Friday |
| `30 2 * * SUN` | Weekly on Sunday | 02:30 AM every Sunday |
| `0 0 1 * *` | Monthly | Midnight on 1st of each month |
| `0 0 1 1 *` | Yearly | Midnight on January 1st |
| `0 8,12,18 * * *` | Three times daily | 8 AM, 12 PM, 6 PM |

---

#### **Step-by-Step: Reading `0 3 * * *`**

Let's decode the cron expression for "Daily at 3 AM":

```
  0       3       *       *       *
  ↓       ↓       ↓       ↓       ↓
minute  hour    day   month  day_of_week
```

**Field-by-Field:**

1. **Minute = 0**: Run at 0 minutes past the hour (top of the hour)
2. **Hour = 3**: Run at hour 3 (3 AM in 24-hour format)
3. **Day = ***: Every day of the month (1-31)
4. **Month = ***: Every month (1-12)
5. **Day of Week = ***: Every day of the week (0-6)

**Result**: "At minute 0 of hour 3, every day, every month, every day of week" → **Daily at 3:00 AM**

---

#### **Step-by-Step: Reading `*/15 * * * *`**

Let's decode "Every 15 minutes":

```
 */15      *       *       *       *
  ↓        ↓       ↓       ↓       ↓
minute   hour    day   month  day_of_week
```

**Field-by-Field:**

1. **Minute = */15**: Every 15 minutes (0, 15, 30, 45)
   - `/` means "increment"
   - `*/15` means "start at 0, increment by 15"
   - Expands to: 0, 15, 30, 45
2. **Hour = ***: Every hour (0-23)
3. **Day = ***: Every day of the month
4. **Month = ***: Every month
5. **Day of Week = ***: Every day of the week

**Result**: "At minutes 0, 15, 30, 45 of every hour, every day" → **Every 15 minutes, 24/7**

---

#### **Step-by-Step: Reading `0 9-17 * * MON-FRI`**

Let's decode "Business hours on weekdays":

```
  0      9-17      *       *    MON-FRI
  ↓        ↓       ↓       ↓       ↓
minute   hour    day   month  day_of_week
```

**Field-by-Field:**

1. **Minute = 0**: At 0 minutes past the hour
2. **Hour = 9-17**: Range from hour 9 to hour 17 (9 AM to 5 PM)
   - Expands to: 9, 10, 11, 12, 13, 14, 15, 16, 17
3. **Day = ***: Every day of the month
4. **Month = ***: Every month
5. **Day of Week = MON-FRI**: Monday through Friday only
   - MON=1, TUE=2, WED=3, THU=4, FRI=5

**Result**: "At minute 0 of hours 9-17, every day, every month, Monday-Friday" → **Every hour from 9 AM to 5 PM on weekdays**

**Timeline:**
```
Monday:
09:00 ✅ Runs
10:00 ✅ Runs
11:00 ✅ Runs
12:00 ✅ Runs
13:00 ✅ Runs
14:00 ✅ Runs
15:00 ✅ Runs
16:00 ✅ Runs
17:00 ✅ Runs
18:00 ❌ Doesn't run (outside 9-17)

Saturday:
09:00 ❌ Doesn't run (weekend)
```

---

### 🔧 Production Deployment Example

Let's see how to deploy the scheduler as a **background service** using **systemd** (Linux):

---

#### **Step 1: Create the Python Script**

```python
# /opt/etl_scheduler/main.py
import schedule
import time
import logging
from datetime import datetime
from pathlib import Path

# Setup logging
log_dir = Path("/var/log/etl_scheduler")
log_dir.mkdir(exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_dir / "scheduler.log"),
        logging.StreamHandler()
    ]
)

def run_etl_pipeline():
    """Production ETL pipeline."""
    try:
        logging.info("Starting ETL pipeline")
        
        # Your actual ETL code here
        logging.info("Extracting data...")
        # extract_data()
        
        logging.info("Transforming data...")
        # transform_data()
        
        logging.info("Loading data...")
        # load_data()
        
        logging.info("ETL pipeline completed successfully")
        
    except Exception as e:
        logging.error(f"ETL pipeline failed: {e}", exc_info=True)
        # Send alert email/Slack notification here
        raise

# Schedule the job
schedule.every().day.at("03:00").do(run_etl_pipeline)

logging.info("ETL Scheduler started")
logging.info("Schedule: Daily at 03:00 AM")

# Main loop
while True:
    schedule.run_pending()
    time.sleep(60)
```

---

#### **Step 2: Create systemd Service File**

```ini
# /etc/systemd/system/etl-scheduler.service
[Unit]
Description=ETL Pipeline Scheduler
After=network.target

[Service]
Type=simple
User=etl_user
Group=etl_user
WorkingDirectory=/opt/etl_scheduler
ExecStart=/usr/bin/python3 /opt/etl_scheduler/main.py
Restart=always
RestartSec=10

# Logging
StandardOutput=append:/var/log/etl_scheduler/output.log
StandardError=append:/var/log/etl_scheduler/error.log

[Install]
WantedBy=multi-user.target
```

---

#### **Step 3: Deploy and Manage the Service**

```bash
# Copy service file
sudo cp etl-scheduler.service /etc/systemd/system/

# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable etl-scheduler

# Start the service
sudo systemctl start etl-scheduler

# Check service status
sudo systemctl status etl-scheduler

# View logs
sudo journalctl -u etl-scheduler -f

# Stop service
sudo systemctl stop etl-scheduler

# Restart service (after code changes)
sudo systemctl restart etl-scheduler
```

**Output:**
```
● etl-scheduler.service - ETL Pipeline Scheduler
   Loaded: loaded (/etc/systemd/system/etl-scheduler.service; enabled)
   Active: active (running) since Mon 2024-01-15 14:00:00 UTC; 2h 30min ago
 Main PID: 12345 (python3)
   Status: "Running"
    Tasks: 1 (limit: 4915)
   Memory: 45.2M
   CGroup: /system.slice/etl-scheduler.service
           └─12345 /usr/bin/python3 /opt/etl_scheduler/main.py

Jan 15 14:00:00 server systemd[1]: Started ETL Pipeline Scheduler.
Jan 15 14:00:01 server python3[12345]: 2024-01-15 14:00:01 - INFO - ETL Scheduler started
Jan 15 14:00:01 server python3[12345]: 2024-01-15 14:00:01 - INFO - Schedule: Daily at 03:00 AM
```

---

### 🔑 Key Takeaways

1. **`schedule` library** is simple for basic scheduling (hourly, daily, weekly)
2. **Method chaining** makes schedules human-readable: `schedule.every().hour.at(":15")`
3. **`run_pending()`** checks and executes due jobs in the main loop
4. **`time.sleep()`** prevents CPU wastage - 60s is fine for most ETL jobs
5. **Cron expressions** provide powerful scheduling: `0 3 * * *` = daily at 3 AM
6. **APScheduler** offers advanced features: timezones, job persistence, multiple triggers
7. **Production deployment** uses systemd for automatic restarts and boot startup
8. **Always log** to track pipeline execution and debug failures
9. **Multiple schedules** can run different pipelines at different frequencies
10. **Immediate execution** with `run_immediately=True` verifies pipeline before waiting

---

## 🎓 Congratulations!

You've completed all enhancement levels:

**✅ Level 1 (Beginner):**
- Email, Phone, Date Validators
- CSV Loader
- Configuration Validation
- Progress Bars

**✅ Level 2 (Intermediate):**
- Real PostgreSQL Connection
- Data Deduplication
- Incremental Loading
- Data Aggregation

**✅ Level 3 (Advanced):**
- Parallel Processing
- Retry Logic with Exponential Backoff
- Data Quality Dashboard
- Automated Scheduling

---

## 🚀 Next Steps

1. **Combine Enhancements**: Use multiple enhancements together
2. **Real Project**: Build an ETL pipeline for your own data
3. **Add Tests**: Write unit tests for your validators and transformers
4. **Performance Tuning**: Benchmark and optimize your pipeline
5. **Cloud Deployment**: Deploy to AWS, GCP, or Azure
6. **Monitoring**: Add Prometheus/Grafana metrics
7. **Alerting**: Send notifications on pipeline failures

---

## 📚 Additional Resources

- **Database Connections**: psycopg2 documentation
- **Parallel Processing**: Python concurrent.futures guide
- **Scheduling**: APScheduler documentation
- **Data Quality**: Great Expectations library
- **ETL Frameworks**: Apache Airflow, Prefect, Dagster

---

**Happy Data Engineering! 🎉**

---

## 🎓 Congratulations!

You've built a **complete, production-ready ETL system** using OOP principles! 🎉

**What you accomplished:**
- ✅ 500+ lines of professional Python code
- ✅ Used ALL major OOP concepts
- ✅ Created reusable, maintainable components
- ✅ Built real data engineering pipeline
- ✅ Followed best practices

**Skills gained:**
- 🎯 ETL pipeline architecture
- 🎯 Object-oriented design
- 🎯 Configuration management
- 🎯 Data validation
- 🎯 Error handling
- 🎯 Logging and monitoring
- 🎯 Statistics and reporting

---

## 📚 Next Steps

1. **Practice Project 2**: Build a data quality dashboard
2. **Practice Project 3**: Build configuration-driven pipeline
3. **Lesson 5**: Error Handling & Logging
4. **Lesson 6**: Testing with pytest

Keep building! 🚀

---

**Need help?** Review the OOP Enhanced Explanations document for detailed concept explanations!

**Questions?** Try modifying the code and see what happens - that's the best way to learn! 💡