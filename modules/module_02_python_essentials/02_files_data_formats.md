# Lesson 2: Working with Files & Data Formats

**Duration**: 2.5 hours  
**Prerequisites**: Lesson 1 - Python Fundamentals  
**Goal**: Master file I/O operations and common data formats for data engineering

---

## 📋 **What You'll Learn**

By the end of this lesson, you will:

✅ Read and write CSV files with Python's `csv` module  
✅ Parse and create JSON data structures  
✅ Work with Parquet files using `pyarrow`  
✅ Use `pathlib` for cross-platform file path management  
✅ Implement context managers (`with` statement) for safe file handling  
✅ Handle file errors gracefully  
✅ Process large files efficiently  
✅ Convert between different data formats  

---

## 🗂️ **Table of Contents**

1. [File Path Management with pathlib](#1-file-path-management-with-pathlib)
2. [Working with CSV Files](#2-working-with-csv-files)
3. [JSON Data Format](#3-json-data-format)
4. [Parquet Files](#4-parquet-files)
5. [Context Managers](#5-context-managers)
6. [Practice Exercises](#6-practice-exercises)

---

## 1. File Path Management with pathlib

### What is pathlib?

**pathlib** is Python's modern way to handle file paths. It replaces the older `os.path` module with an object-oriented approach.

### Why Use pathlib?

✅ **Cross-platform** - Works on Windows, Mac, Linux  
✅ **Readable** - Uses `/` operator to join paths  
✅ **Object-oriented** - Paths are objects with useful methods  
✅ **Type-safe** - Catches path errors early  

### Basic pathlib Operations

```python
from pathlib import Path

# ---------- CREATING PATHS ----------

# Current working directory
current_dir = Path.cwd()
print(current_dir)  # /home/user/project

# Home directory
home_dir = Path.home()
print(home_dir)  # /home/user

# Create path from string
data_dir = Path("data")
print(data_dir)  # data

# Absolute path
abs_path = Path("/home/user/project/data")
print(abs_path)  # /home/user/project/data


# ---------- JOINING PATHS (The / operator!) ----------

# Join paths with / (works on all operating systems!)
csv_file = Path("data") / "campsites.csv"
print(csv_file)  # data/campsites.csv

# Multiple levels
nested_file = Path("data") / "raw" / "2024" / "january.csv"
print(nested_file)  # data/raw/2024/january.csv

# Joining with variables
folder = "exports"
filename = "output.json"
output_path = Path(folder) / filename
print(output_path)  # exports/output.json


# ---------- PATH PROPERTIES ----------

file_path = Path("data/campsites.csv")

# Get filename
print(file_path.name)        # campsites.csv

# Get filename without extension
print(file_path.stem)        # campsites

# Get extension
print(file_path.suffix)      # .csv

# Get parent directory
print(file_path.parent)      # data

# Get all parts
print(file_path.parts)       # ('data', 'campsites.csv')


# ---------- CHECKING EXISTENCE ----------

file_path = Path("data/campsites.csv")

# Check if exists (file or directory)
if file_path.exists():
    print("Path exists!")

# Check if it's a file
if file_path.is_file():
    print("It's a file")

# Check if it's a directory
if file_path.is_dir():
    print("It's a directory")


# ---------- CREATING DIRECTORIES ----------

# Create single directory
new_dir = Path("output")
new_dir.mkdir(exist_ok=True)  # exist_ok=True: don't error if exists

# Create nested directories (like mkdir -p)
nested_dir = Path("data/processed/2024")
nested_dir.mkdir(parents=True, exist_ok=True)
# parents=True: create parent directories if needed


# ---------- LISTING FILES ----------

data_dir = Path("data")

# List all items (files and directories)
for item in data_dir.iterdir():
    print(item)

# List only CSV files (pattern matching)
for csv_file in data_dir.glob("*.csv"):
    print(csv_file)

# List CSV files recursively (in subdirectories too)
for csv_file in data_dir.rglob("*.csv"):
    print(csv_file)


# ---------- READING AND WRITING TEXT ----------

file_path = Path("data/notes.txt")

# Write text to file
file_path.write_text("Hello, Data Engineering!")

# Read text from file
content = file_path.read_text()
print(content)  # Hello, Data Engineering!

# Read as bytes
binary_data = file_path.read_bytes()
```

### Real-World Example: Project File Structure

```python
from pathlib import Path

def setup_project_structure(base_path="."):
    """Create standard data engineering project structure.
    
    Args:
        base_path (str): Base project directory
    """
    base = Path(base_path)
    
    # Define directory structure
    directories = [
        base / "data" / "raw",
        base / "data" / "processed",
        base / "data" / "exports",
        base / "logs",
        base / "scripts",
        base / "notebooks",
        base / "tests",
    ]
    
    # Create all directories
    for directory in directories:
        directory.mkdir(parents=True, exist_ok=True)
        print(f"✅ Created: {directory}")
    
    # Create .gitkeep files (so empty dirs are tracked in git)
    for directory in directories:
        gitkeep = directory / ".gitkeep"
        gitkeep.touch()  # Create empty file

# Use it
setup_project_structure("my_data_project")

# Output:
# ✅ Created: my_data_project/data/raw
# ✅ Created: my_data_project/data/processed
# ✅ Created: my_data_project/data/exports
# ✅ Created: my_data_project/logs
# ✅ Created: my_data_project/scripts
# ✅ Created: my_data_project/notebooks
# ✅ Created: my_data_project/tests
```

### Path Resolution and Absolute Paths

```python
from pathlib import Path

# Relative path
rel_path = Path("data/campsites.csv")
print(rel_path)  # data/campsites.csv

# Convert to absolute path
abs_path = rel_path.resolve()
print(abs_path)  # /home/user/project/data/campsites.csv

# Check if path is absolute
print(abs_path.is_absolute())  # True
print(rel_path.is_absolute())  # False

# Resolve .. (parent directory) and . (current directory)
complex_path = Path("data/../data/./campsites.csv")
clean_path = complex_path.resolve()
print(clean_path)  # /home/user/project/data/campsites.csv
```

### Common pathlib Patterns

```python
from pathlib import Path
import shutil

# Pattern 1: Find all Python files in project
project_dir = Path(".")
python_files = list(project_dir.rglob("*.py"))
print(f"Found {len(python_files)} Python files")

# Pattern 2: Create timestamped output file
from datetime import datetime
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
output_file = Path("exports") / f"data_{timestamp}.csv"

# Pattern 3: Copy file to backup location
source = Path("data/important.csv")
backup_dir = Path("backups")
backup_dir.mkdir(exist_ok=True)
backup = backup_dir / source.name
shutil.copy(source, backup)

# Pattern 4: Check file size
file_path = Path("data/large_file.csv")
if file_path.exists():
    size_mb = file_path.stat().st_size / (1024 * 1024)
    print(f"File size: {size_mb:.2f} MB")

# Pattern 5: Get file modification time
from datetime import datetime
file_path = Path("data/campsites.csv")
if file_path.exists():
    mtime = datetime.fromtimestamp(file_path.stat().st_mtime)
    print(f"Last modified: {mtime}")
```

---

## 2. Working with CSV Files

### What is CSV?

**CSV (Comma-Separated Values)** is a simple text format for storing tabular data. Each line is a row, and values are separated by commas (or other delimiters).

**Example CSV:**
```csv
id,name,state,price,capacity
1,Camping Vale do Pati,BA,120.00,30
2,Serra dos Órgãos,RJ,80.00,25
3,Pico da Bandeira,MG,100.00,20
```

### Why CSV is Popular in Data Engineering

✅ **Simple** - Plain text, human-readable  
✅ **Universal** - Supported by all tools (Excel, databases, Python, R)  
✅ **Lightweight** - No overhead, small file size  
✅ **Easy to generate** - Most systems can export CSV  
❌ **No type information** - Everything is text (you must convert)  
❌ **No nested structures** - Only flat tables  

### Method 1: Using Python's csv Module

The `csv` module is part of Python's standard library - no installation needed!

#### Reading CSV Files

```python
import csv
from pathlib import Path

# ---------- BASIC CSV READING ----------

csv_file = Path("data/campsites.csv")

# Open and read CSV
with open(csv_file, 'r', encoding='utf-8') as file:
    csv_reader = csv.reader(file)
    
    # Read header (first row)
    header = next(csv_reader)
    print(f"Columns: {header}")
    
    # Read data rows
    for row in csv_reader:
        print(row)

# Output:
# Columns: ['id', 'name', 'state', 'price', 'capacity']
# ['1', 'Camping Vale do Pati', 'BA', '120.00', '30']
# ['2', 'Serra dos Órgãos', 'RJ', '80.00', '25']
# ['3', 'Pico da Bandeira', 'MG', '100.00', '20']
```

**Important:** Notice everything is a string! You need to convert types manually.

#### Reading CSV as Dictionaries (Recommended!)

```python
import csv
from pathlib import Path

csv_file = Path("data/campsites.csv")

# Read CSV as dictionaries (column names as keys)
with open(csv_file, 'r', encoding='utf-8') as file:
    csv_reader = csv.DictReader(file)
    
    # Each row is a dictionary
    for row in csv_reader:
        print(row)
        print(f"Name: {row['name']}, Price: {row['price']}")

# Output:
# {'id': '1', 'name': 'Camping Vale do Pati', 'state': 'BA', 'price': '120.00', 'capacity': '30'}
# Name: Camping Vale do Pati, Price: 120.00
```

**Advantages of DictReader:**
- Access columns by name (more readable)
- No need to track column positions
- Self-documenting code

#### Reading CSV into List of Dictionaries

```python
import csv
from pathlib import Path

def read_csv_to_list(csv_file):
    """Read CSV file into list of dictionaries.
    
    Args:
        csv_file (Path): Path to CSV file
        
    Returns:
        list: List of dictionaries, one per row
    """
    data = []
    
    with open(csv_file, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            data.append(row)
    
    return data

# Use it
campsites = read_csv_to_list(Path("data/campsites.csv"))
print(f"Loaded {len(campsites)} campsites")
print(campsites[0])  # First campsite
```

#### Type Conversion When Reading

```python
import csv
from pathlib import Path

def read_campsites_typed(csv_file):
    """Read CSV with proper type conversion.
    
    Args:
        csv_file (Path): Path to CSV file
        
    Returns:
        list: List of properly-typed dictionaries
    """
    campsites = []
    
    with open(csv_file, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        
        for row in csv_reader:
            # Convert types manually
            campsite = {
                'id': int(row['id']),
                'name': row['name'],  # Keep as string
                'state': row['state'],
                'price': float(row['price']),
                'capacity': int(row['capacity'])
            }
            campsites.append(campsite)
    
    return campsites

# Use it
campsites = read_campsites_typed(Path("data/campsites.csv"))
print(campsites[0])
# {'id': 1, 'name': 'Camping Vale do Pati', 'state': 'BA', 'price': 120.0, 'capacity': 30}

# Now you can do math!
total_capacity = sum(c['capacity'] for c in campsites)
average_price = sum(c['price'] for c in campsites) / len(campsites)
```

#### Handling Different Delimiters

```python
import csv

# Semicolon-separated (common in Europe)
with open('data_semicolon.csv', 'r') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        print(row)

# Tab-separated (TSV)
with open('data.tsv', 'r') as file:
    reader = csv.DictReader(file, delimiter='\t')
    for row in reader:
        print(row)

# Pipe-separated
with open('data_pipe.txt', 'r') as file:
    reader = csv.DictReader(file, delimiter='|')
    for row in reader:
        print(row)
```

#### Writing CSV Files

```python
import csv
from pathlib import Path

# Sample data
campsites = [
    {'id': 1, 'name': 'Camping Vale', 'state': 'BA', 'price': 120.00, 'capacity': 30},
    {'id': 2, 'name': 'Serra Camp', 'state': 'RJ', 'price': 80.00, 'capacity': 25},
    {'id': 3, 'name': 'Pico Camp', 'state': 'MG', 'price': 100.00, 'capacity': 20},
]

# ---------- WRITING CSV FROM DICTIONARIES ----------

output_file = Path("output/campsites_export.csv")

# Create output directory if needed
output_file.parent.mkdir(parents=True, exist_ok=True)

# Write CSV
with open(output_file, 'w', newline='', encoding='utf-8') as file:
    # Get column names from first dictionary
    fieldnames = campsites[0].keys()
    
    # Create CSV writer
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    
    # Write header
    writer.writeheader()
    
    # Write data rows
    writer.writerows(campsites)

print(f"✅ Exported {len(campsites)} rows to {output_file}")
```

**Important Notes:**
- `newline=''` - Required on Windows to avoid extra blank lines
- `encoding='utf-8'` - Ensures proper handling of special characters (like ã, ç, ó)
- `writeheader()` - Writes column names as first row
- `writerows()` - Writes multiple rows at once (faster than loop)

#### Writing CSV with Custom Formatting

```python
import csv
from pathlib import Path

campsites = [
    {'name': 'Camping Vale', 'price': 120.00},
    {'name': 'Serra Camp', 'price': 80.50},
]

output_file = Path("output/formatted.csv")

with open(output_file, 'w', newline='', encoding='utf-8') as file:
    # Custom settings
    writer = csv.DictWriter(
        file,
        fieldnames=['name', 'price'],
        delimiter=';',           # Use semicolon instead of comma
        quotechar='"',          # Quote character for strings with delimiters
        quoting=csv.QUOTE_MINIMAL  # Only quote when necessary
    )
    
    writer.writeheader()
    writer.writerows(campsites)
```

#### Appending to Existing CSV

```python
import csv
from pathlib import Path

output_file = Path("output/campsites.csv")

# New data to append
new_campsite = {'id': 4, 'name': 'New Camp', 'state': 'SP', 'price': 90.00, 'capacity': 15}

# Append mode ('a' instead of 'w')
with open(output_file, 'a', newline='', encoding='utf-8') as file:
    fieldnames = new_campsite.keys()
    writer = csv.DictWriter(file, fieldnames=fieldnames)
    
    # Only write header if file is empty
    if output_file.stat().st_size == 0:
        writer.writeheader()
    
    writer.writerow(new_campsite)
```

### Real-World Example: CSV Data Processing Pipeline

```python
import csv
from pathlib import Path
from datetime import datetime

def process_campsite_bookings(input_csv, output_csv, min_price=50):
    """Process campsite bookings: filter, transform, export.
    
    Args:
        input_csv (Path): Input CSV file
        output_csv (Path): Output CSV file
        min_price (float): Minimum price filter
        
    Returns:
        dict: Processing statistics
    """
    # Statistics
    stats = {
        'total_read': 0,
        'filtered_out': 0,
        'exported': 0
    }
    
    processed_data = []
    
    # Read input CSV
    with open(input_csv, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        
        for row in reader:
            stats['total_read'] += 1
            
            # Convert types
            price = float(row['price'])
            capacity = int(row['capacity'])
            
            # Filter: only campsites >= min_price
            if price < min_price:
                stats['filtered_out'] += 1
                continue
            
            # Transform: add calculated fields
            processed_row = {
                'id': int(row['id']),
                'name': row['name'],
                'state': row['state'],
                'price': price,
                'capacity': capacity,
                'price_per_person': round(price / capacity, 2),
                'category': 'premium' if price > 100 else 'standard',
                'processed_at': datetime.now().isoformat()
            }
            
            processed_data.append(processed_row)
            stats['exported'] += 1
    
    # Write output CSV
    if processed_data:
        output_csv.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_csv, 'w', newline='', encoding='utf-8') as file:
            fieldnames = processed_data[0].keys()
            writer = csv.DictWriter(file, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(processed_data)
    
    return stats

# Use it
input_file = Path("data/raw/campsites.csv")
output_file = Path("data/processed/campsites_processed.csv")

stats = process_campsite_bookings(input_file, output_file, min_price=70)

print(f"""
Processing Complete!
-------------------
Total read:      {stats['total_read']}
Filtered out:    {stats['filtered_out']}
Exported:        {stats['exported']}
Output file:     {output_file}
""")
```

### Handling CSV Errors

```python
import csv
from pathlib import Path

def read_csv_safe(csv_file):
    """Read CSV with error handling.
    
    Args:
        csv_file (Path): Path to CSV file
        
    Returns:
        list: Data rows or empty list on error
    """
    try:
        # Check if file exists
        if not csv_file.exists():
            print(f"❌ Error: File not found: {csv_file}")
            return []
        
        # Check if file is empty
        if csv_file.stat().st_size == 0:
            print(f"⚠️  Warning: File is empty: {csv_file}")
            return []
        
        data = []
        with open(csv_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            for row_num, row in enumerate(reader, start=2):  # start=2 (line 1 is header)
                try:
                    # Validate required fields
                    if not row.get('id'):
                        print(f"⚠️  Warning: Missing 'id' at line {row_num}, skipping")
                        continue
                    
                    # Try type conversion
                    row['id'] = int(row['id'])
                    row['price'] = float(row['price'])
                    row['capacity'] = int(row['capacity'])
                    
                    data.append(row)
                    
                except ValueError as e:
                    print(f"⚠️  Warning: Invalid data at line {row_num}: {e}, skipping")
                    continue
        
        print(f"✅ Successfully loaded {len(data)} rows from {csv_file}")
        return data
        
    except PermissionError:
        print(f"❌ Error: Permission denied: {csv_file}")
        return []
    
    except UnicodeDecodeError:
        print(f"❌ Error: Invalid encoding (try different encoding)")
        return []
    
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return []

# Use it
campsites = read_csv_safe(Path("data/campsites.csv"))
```

---

## 3. JSON Data Format

### What is JSON?

**JSON (JavaScript Object Notation)** is a lightweight data format for storing and exchanging structured data. It's human-readable and widely used in APIs, configuration files, and data storage.

### JSON vs CSV - When to Use Each?

| Feature | JSON | CSV |
|---------|------|-----|
| **Structure** | Nested/hierarchical | Flat table only |
| **Data Types** | String, Number, Boolean, Array, Object, null | All text (must convert) |
| **Readability** | Very readable | Readable but limited |
| **File Size** | Larger (more verbose) | Smaller (compact) |
| **Best For** | APIs, configs, nested data | Tabular data, Excel export |
| **Performance** | Slower for large datasets | Faster for large datasets |

**Use JSON when:**
- Data has nested structures (lists within objects)
- You need to preserve data types
- Working with APIs (most APIs use JSON)
- Configuration files
- Small to medium datasets

**Use CSV when:**
- Data is flat/tabular
- Working with Excel or spreadsheets
- Large datasets (better performance)
- Simple data exchange

### JSON Structure Examples

```python
# JSON supports multiple data types:

# 1. Object (Python dictionary)
campsite = {
    "id": 1,
    "name": "Camping Vale do Pati",
    "state": "BA"
}

# 2. Array (Python list)
states = ["BA", "RJ", "MG", "SP"]

# 3. Nested structures
campsite_detailed = {
    "id": 1,
    "name": "Camping Vale do Pati",
    "location": {                    # Nested object
        "state": "BA",
        "city": "Palmeiras",
        "coordinates": {
            "latitude": -12.5234,
            "longitude": -41.4567
        }
    },
    "amenities": ["toilet", "shower", "electricity"],  # Array
    "prices": {                      # Nested object
        "low_season": 100.00,
        "high_season": 150.00
    },
    "available": True,               # Boolean
    "max_capacity": 30,              # Number
    "notes": None                    # Null
}
```

### Reading JSON Files

Python's `json` module makes working with JSON simple and intuitive.

#### Basic JSON Reading

```python
import json
from pathlib import Path

# ---------- READING JSON FROM FILE ----------

json_file = Path("data/campsites.json")

# Method 1: Read entire file at once
with open(json_file, 'r', encoding='utf-8') as file:
    data = json.load(file)  # Parses JSON to Python objects
    print(type(data))  # <class 'dict'> or <class 'list'>
    print(data)

# Example JSON file content:
# {
#     "campsites": [
#         {"id": 1, "name": "Camp A", "price": 120.00},
#         {"id": 2, "name": "Camp B", "price": 80.00}
#     ],
#     "total": 2
# }

# Access data
print(f"Total campsites: {data['total']}")
for campsite in data['campsites']:
    print(f"{campsite['name']}: R${campsite['price']}")
```

#### Reading JSON String

```python
import json

# JSON as string (from API response, for example)
json_string = '{"name": "Camping Vale", "price": 120.00, "capacity": 30}'

# Parse JSON string to Python dictionary
data = json.loads(json_string)  # Note: loads (with 's' for string)
print(data)
# {'name': 'Camping Vale', 'price': 120.0, 'capacity': 30}

# Access data
print(f"Name: {data['name']}")
print(f"Price: R${data['price']}")
```

#### Handling Different JSON Structures

```python
import json
from pathlib import Path

# ---------- EXAMPLE 1: Single Object ----------

json_file = Path("data/config.json")

with open(json_file, 'r', encoding='utf-8') as file:
    config = json.load(file)

# JSON content:
# {
#     "database": {
#         "host": "localhost",
#         "port": 5432,
#         "name": "camping_db"
#     },
#     "logging": {
#         "level": "INFO",
#         "file": "app.log"
#     }
# }

# Access nested data
db_host = config['database']['host']
log_level = config['logging']['level']


# ---------- EXAMPLE 2: Array of Objects ----------

json_file = Path("data/campsites_list.json")

with open(json_file, 'r', encoding='utf-8') as file:
    campsites = json.load(file)

# JSON content:
# [
#     {"id": 1, "name": "Camp A", "price": 120.00},
#     {"id": 2, "name": "Camp B", "price": 80.00},
#     {"id": 3, "name": "Camp C", "price": 100.00}
# ]

# Process each campsite
for campsite in campsites:
    print(f"{campsite['id']}: {campsite['name']}")


# ---------- EXAMPLE 3: Complex Nested Structure ----------

json_file = Path("data/bookings.json")

with open(json_file, 'r', encoding='utf-8') as file:
    bookings_data = json.load(file)

# JSON content:
# {
#     "bookings": [
#         {
#             "id": 1,
#             "campsite": {
#                 "name": "Camping Vale",
#                 "location": {"state": "BA", "city": "Palmeiras"}
#             },
#             "customer": {
#                 "name": "João Silva",
#                 "email": "joao@example.com"
#             },
#             "dates": {
#                 "check_in": "2024-07-15",
#                 "check_out": "2024-07-18"
#             },
#             "guests": 4,
#             "total": 360.00
#         }
#     ],
#     "metadata": {
#         "generated_at": "2024-06-01T10:30:00",
#         "version": "1.0"
#     }
# }

# Navigate nested structure
for booking in bookings_data['bookings']:
    campsite_name = booking['campsite']['name']
    state = booking['campsite']['location']['state']
    customer = booking['customer']['name']
    nights = (
        # Calculate nights from dates
        # (simplified - would use datetime in real code)
    )
    print(f"{customer} → {campsite_name} ({state})")
```

### Writing JSON Files

```python
import json
from pathlib import Path
from datetime import datetime

# ---------- WRITING SIMPLE JSON ----------

campsites = [
    {"id": 1, "name": "Camping Vale", "state": "BA", "price": 120.00},
    {"id": 2, "name": "Serra Camp", "state": "RJ", "price": 80.00},
    {"id": 3, "name": "Pico Camp", "state": "MG", "price": 100.00}
]

output_file = Path("output/campsites.json")
output_file.parent.mkdir(parents=True, exist_ok=True)

# Write JSON file
with open(output_file, 'w', encoding='utf-8') as file:
    json.dump(campsites, file)  # Write Python object as JSON

print(f"✅ Saved to {output_file}")

# Result: Compact JSON (no formatting)
# [{"id":1,"name":"Camping Vale","state":"BA","price":120.0},{"id":2,...}]


# ---------- WRITING PRETTY JSON (Indented) ----------

with open(output_file, 'w', encoding='utf-8') as file:
    json.dump(
        campsites,
        file,
        indent=4,              # Indent with 4 spaces
        ensure_ascii=False     # Keep special characters (ã, ç, etc.)
    )

# Result: Pretty formatted JSON
# [
#     {
#         "id": 1,
#         "name": "Camping Vale",
#         "state": "BA",
#         "price": 120.0
#     },
#     ...
# ]


# ---------- WRITING JSON STRING ----------

# Convert Python object to JSON string
json_string = json.dumps(campsites, indent=2)
print(json_string)

# Save string to file
output_file.write_text(json_string, encoding='utf-8')
```

### JSON Formatting Options

```python
import json
from datetime import datetime
from decimal import Decimal

# Sample data with various types
data = {
    "campsite": "Camping Vale do Pati",
    "price": 120.50,
    "available": True,
    "amenities": ["toilet", "shower", "electricity"],
    "coordinates": {"lat": -12.5234, "lon": -41.4567}
}

# ---------- OPTION 1: Compact (No Spaces) ----------
compact = json.dumps(data, separators=(',', ':'))
print(compact)
# {"campsite":"Camping Vale do Pati","price":120.5,"available":true,...}


# ---------- OPTION 2: Pretty with Indent ----------
pretty = json.dumps(data, indent=4)
print(pretty)
# {
#     "campsite": "Camping Vale do Pati",
#     "price": 120.5,
#     ...
# }


# ---------- OPTION 3: Sort Keys Alphabetically ----------
sorted_json = json.dumps(data, indent=4, sort_keys=True)
print(sorted_json)
# {
#     "amenities": [...],
#     "available": true,
#     "campsite": "Camping Vale do Pati",
#     ...
# }


# ---------- OPTION 4: Ensure ASCII (Escape Special Chars) ----------
ascii_json = json.dumps(data, ensure_ascii=True)
print(ascii_json)
# {"campsite":"Camping Vale do Pati",...}  (no special chars)

# vs ensure_ascii=False (keep special chars)
utf8_json = json.dumps(data, ensure_ascii=False)
print(utf8_json)
# {"campsite":"Camping Vale do Pati",...}  (keeps ã, ç, etc.)
```

### Handling Special Python Types in JSON

JSON doesn't support all Python types. Here's how to handle them:

```python
import json
from datetime import datetime, date
from decimal import Decimal

# ---------- PROBLEM: datetime, Decimal, set not JSON serializable ----------

data = {
    "created_at": datetime.now(),      # ❌ Can't serialize datetime
    "price": Decimal("120.50"),        # ❌ Can't serialize Decimal
    "states": {"BA", "RJ", "MG"}       # ❌ Can't serialize set
}

# This will raise: TypeError: Object of type datetime is not JSON serializable
# json.dumps(data)


# ---------- SOLUTION 1: Custom JSON Encoder ----------

class CustomJSONEncoder(json.JSONEncoder):
    """Custom encoder for datetime, Decimal, and set."""
    
    def default(self, obj):
        # Handle datetime
        if isinstance(obj, (datetime, date)):
            return obj.isoformat()  # "2024-07-15T10:30:00"
        
        # Handle Decimal
        if isinstance(obj, Decimal):
            return float(obj)
        
        # Handle set
        if isinstance(obj, set):
            return list(obj)
        
        # Let the base class handle other types
        return super().default(obj)

# Use custom encoder
data = {
    "created_at": datetime.now(),
    "price": Decimal("120.50"),
    "states": {"BA", "RJ", "MG"}
}

json_string = json.dumps(data, cls=CustomJSONEncoder, indent=2)
print(json_string)
# {
#   "created_at": "2024-07-15T10:30:00.123456",
#   "price": 120.5,
#   "states": ["BA", "RJ", "MG"]
# }


# ---------- SOLUTION 2: Convert Before Serializing ----------

def prepare_for_json(obj):
    """Convert Python objects to JSON-compatible types."""
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    elif isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, set):
        return list(obj)
    elif isinstance(obj, dict):
        return {key: prepare_for_json(value) for key, value in obj.items()}
    elif isinstance(obj, list):
        return [prepare_for_json(item) for item in obj]
    else:
        return obj

# Prepare data first
data = {
    "created_at": datetime.now(),
    "price": Decimal("120.50"),
    "states": {"BA", "RJ", "MG"}
}

json_ready = prepare_for_json(data)
json_string = json.dumps(json_ready, indent=2)
```

### Real-World Example: API Response Processing

```python
import json
from pathlib import Path
from typing import List, Dict, Any

def process_api_response(json_file: Path) -> Dict[str, Any]:
    """Process campsite API response from JSON file.
    
    Args:
        json_file: Path to JSON response file
        
    Returns:
        Dictionary with processed statistics
    """
    # Read JSON response
    with open(json_file, 'r', encoding='utf-8') as file:
        response = json.load(file)
    
    # Example JSON structure:
    # {
    #     "status": "success",
    #     "data": {
    #         "campsites": [
    #             {
    #                 "id": 1,
    #                 "name": "Camping Vale",
    #                 "location": {"state": "BA", "city": "Palmeiras"},
    #                 "pricing": {"base": 120.0, "weekend": 150.0},
    #                 "amenities": ["toilet", "shower"],
    #                 "ratings": [5, 4, 5, 5, 4],
    #                 "available": true
    #             },
    #             ...
    #         ]
    #     },
    #     "metadata": {
    #         "total_count": 10,
    #         "page": 1,
    #         "per_page": 10
    #     }
    # }
    
    # Extract data
    campsites = response['data']['campsites']
    metadata = response['metadata']
    
    # Process statistics
    stats = {
        'total_campsites': metadata['total_count'],
        'available_count': sum(1 for c in campsites if c['available']),
        'states': list(set(c['location']['state'] for c in campsites)),
        'price_range': {
            'min': min(c['pricing']['base'] for c in campsites),
            'max': max(c['pricing']['base'] for c in campsites),
            'avg': sum(c['pricing']['base'] for c in campsites) / len(campsites)
        },
        'top_rated': []
    }
    
    # Find top-rated campsites (avg rating >= 4.5)
    for campsite in campsites:
        if campsite['ratings']:
            avg_rating = sum(campsite['ratings']) / len(campsite['ratings'])
            if avg_rating >= 4.5:
                stats['top_rated'].append({
                    'name': campsite['name'],
                    'state': campsite['location']['state'],
                    'rating': round(avg_rating, 2)
                })
    
    # Sort top-rated by rating
    stats['top_rated'].sort(key=lambda x: x['rating'], reverse=True)
    
    return stats

# Use it
json_file = Path("data/api_response.json")
stats = process_api_response(json_file)

# Save processed stats
output_file = Path("output/campsite_stats.json")
with open(output_file, 'w', encoding='utf-8') as file:
    json.dump(stats, file, indent=4, ensure_ascii=False)

print(f"✅ Processed {stats['total_campsites']} campsites")
print(f"📍 States: {', '.join(stats['states'])}")
print(f"💰 Price range: R${stats['price_range']['min']:.2f} - R${stats['price_range']['max']:.2f}")
print(f"⭐ Top rated: {len(stats['top_rated'])} campsites")
```

### Converting Between CSV and JSON

A common data engineering task is converting between formats.

```python
import csv
import json
from pathlib import Path
from typing import List, Dict

# ---------- CSV TO JSON ----------

def csv_to_json(csv_file: Path, json_file: Path, indent: int = 4) -> int:
    """Convert CSV file to JSON.
    
    Args:
        csv_file: Input CSV file path
        json_file: Output JSON file path
        indent: JSON indentation (None for compact)
        
    Returns:
        Number of records converted
    """
    # Read CSV
    data = []
    with open(csv_file, 'r', encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        for row in csv_reader:
            # Convert numeric strings to actual numbers
            processed_row = {}
            for key, value in row.items():
                # Try to convert to number
                try:
                    # Try int first
                    if '.' not in value:
                        processed_row[key] = int(value)
                    else:
                        processed_row[key] = float(value)
                except (ValueError, AttributeError):
                    # Keep as string
                    processed_row[key] = value
            
            data.append(processed_row)
    
    # Write JSON
    json_file.parent.mkdir(parents=True, exist_ok=True)
    with open(json_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=indent, ensure_ascii=False)
    
    return len(data)

# Use it
csv_file = Path("data/campsites.csv")
json_file = Path("output/campsites.json")
count = csv_to_json(csv_file, json_file)
print(f"✅ Converted {count} records from CSV to JSON")


# ---------- JSON TO CSV ----------

def json_to_csv(json_file: Path, csv_file: Path) -> int:
    """Convert JSON array to CSV.
    
    Args:
        json_file: Input JSON file path (must be array of objects)
        csv_file: Output CSV file path
        
    Returns:
        Number of records converted
    """
    # Read JSON
    with open(json_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    if not data:
        print("⚠️  Empty JSON file")
        return 0
    
    # Ensure data is list
    if not isinstance(data, list):
        raise ValueError("JSON must be an array of objects")
    
    # Get all unique keys from all objects (in case some objects have different keys)
    all_keys = set()
    for item in data:
        all_keys.update(item.keys())
    
    fieldnames = sorted(all_keys)  # Sort for consistent column order
    
    # Write CSV
    csv_file.parent.mkdir(parents=True, exist_ok=True)
    with open(csv_file, 'w', newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    return len(data)

# Use it
json_file = Path("data/campsites.json")
csv_file = Path("output/campsites_from_json.csv")
count = json_to_csv(json_file, csv_file)
print(f"✅ Converted {count} records from JSON to CSV")


# ---------- HANDLING NESTED JSON TO CSV ----------

def flatten_json(nested_obj: Dict, parent_key: str = '', sep: str = '_') -> Dict:
    """Flatten nested JSON for CSV export.
    
    Args:
        nested_obj: Nested dictionary
        parent_key: Parent key for recursion
        sep: Separator for flattened keys
        
    Returns:
        Flattened dictionary
    """
    items = []
    
    for key, value in nested_obj.items():
        new_key = f"{parent_key}{sep}{key}" if parent_key else key
        
        if isinstance(value, dict):
            # Recursive call for nested dict
            items.extend(flatten_json(value, new_key, sep=sep).items())
        elif isinstance(value, list):
            # Convert list to JSON string
            items.append((new_key, json.dumps(value)))
        else:
            items.append((new_key, value))
    
    return dict(items)

# Example with nested JSON
nested_data = [
    {
        "id": 1,
        "name": "Camping Vale",
        "location": {"state": "BA", "city": "Palmeiras"},
        "amenities": ["toilet", "shower"]
    }
]

# Flatten each object
flattened_data = [flatten_json(item) for item in nested_data]

# Result:
# [
#     {
#         "id": 1,
#         "name": "Camping Vale",
#         "location_state": "BA",
#         "location_city": "Palmeiras",
#         "amenities": '["toilet", "shower"]'
#     }
# ]

# Now write to CSV
csv_file = Path("output/flattened.csv")
with open(csv_file, 'w', newline='', encoding='utf-8') as file:
    if flattened_data:
        writer = csv.DictWriter(file, fieldnames=flattened_data[0].keys())
        writer.writeheader()
        writer.writerows(flattened_data)
```

### JSON Error Handling

```python
import json
from pathlib import Path
from typing import Optional, Dict, Any

def read_json_safe(json_file: Path) -> Optional[Dict[str, Any]]:
    """Read JSON file with comprehensive error handling.
    
    Args:
        json_file: Path to JSON file
        
    Returns:
        Parsed JSON data or None on error
    """
    try:
        # Check if file exists
        if not json_file.exists():
            print(f"❌ Error: File not found: {json_file}")
            return None
        
        # Check if file is empty
        if json_file.stat().st_size == 0:
            print(f"⚠️  Warning: File is empty: {json_file}")
            return {}
        
        # Read and parse JSON
        with open(json_file, 'r', encoding='utf-8') as file:
            data = json.load(file)
        
        print(f"✅ Successfully loaded JSON from {json_file}")
        return data
        
    except json.JSONDecodeError as e:
        print(f"❌ Error: Invalid JSON format")
        print(f"   Line {e.lineno}, Column {e.colno}: {e.msg}")
        print(f"   Near: {e.doc[max(0, e.pos-20):e.pos+20]}")
        return None
    
    except UnicodeDecodeError as e:
        print(f"❌ Error: Invalid encoding (try utf-8-sig or latin-1)")
        return None
    
    except PermissionError:
        print(f"❌ Error: Permission denied: {json_file}")
        return None
    
    except Exception as e:
        print(f"❌ Unexpected error: {type(e).__name__}: {e}")
        return None

# Use it
data = read_json_safe(Path("data/campsites.json"))
if data:
    print(f"Loaded {len(data)} items")


# ---------- VALIDATE JSON STRUCTURE ----------

def validate_campsite_json(data: Dict) -> bool:
    """Validate campsite JSON structure.
    
    Args:
        data: Parsed JSON data
        
    Returns:
        True if valid, False otherwise
    """
    required_fields = ['id', 'name', 'state', 'price']
    
    if not isinstance(data, dict):
        print("❌ Error: JSON must be an object")
        return False
    
    if 'campsites' not in data:
        print("❌ Error: Missing 'campsites' key")
        return False
    
    if not isinstance(data['campsites'], list):
        print("❌ Error: 'campsites' must be an array")
        return False
    
    # Validate each campsite
    for idx, campsite in enumerate(data['campsites']):
        # Check required fields
        for field in required_fields:
            if field not in campsite:
                print(f"❌ Error: Campsite {idx} missing required field: {field}")
                return False
        
        # Validate types
        if not isinstance(campsite['id'], int):
            print(f"❌ Error: Campsite {idx} 'id' must be integer")
            return False
        
        if not isinstance(campsite['price'], (int, float)):
            print(f"❌ Error: Campsite {idx} 'price' must be number")
            return False
    
    print(f"✅ JSON structure is valid ({len(data['campsites'])} campsites)")
    return True

# Use it
json_file = Path("data/campsites.json")
data = read_json_safe(json_file)
if data:
    if validate_campsite_json(data):
        print("Ready to process!")
```

### JSON Schema Validation (Advanced)

For production systems, use JSON Schema for robust validation:

```python
# First, install: pip install jsonschema

import json
from pathlib import Path
from jsonschema import validate, ValidationError, Draft7Validator

# Define JSON schema
campsite_schema = {
    "type": "object",
    "properties": {
        "campsites": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "id": {"type": "integer", "minimum": 1},
                    "name": {"type": "string", "minLength": 1},
                    "state": {
                        "type": "string",
                        "pattern": "^[A-Z]{2}$"  # Two uppercase letters
                    },
                    "price": {"type": "number", "minimum": 0},
                    "capacity": {"type": "integer", "minimum": 1},
                    "available": {"type": "boolean"}
                },
                "required": ["id", "name", "state", "price"]
            }
        },
        "metadata": {
            "type": "object",
            "properties": {
                "total_count": {"type": "integer"},
                "generated_at": {"type": "string", "format": "date-time"}
            }
        }
    },
    "required": ["campsites"]
}

def validate_against_schema(json_file: Path, schema: dict) -> bool:
    """Validate JSON file against schema.
    
    Args:
        json_file: Path to JSON file
        schema: JSON Schema definition
        
    Returns:
        True if valid, False otherwise
    """
    try:
        # Read JSON
        with open(json_file, 'r', encoding='utf-8') as file:
            data = json.load(file)
        
        # Validate against schema
        validate(instance=data, schema=schema)
        
        print(f"✅ JSON is valid according to schema")
        return True
        
    except ValidationError as e:
        print(f"❌ Validation Error:")
        print(f"   Path: {' -> '.join(str(p) for p in e.path)}")
        print(f"   Message: {e.message}")
        return False
    
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

# Use it
json_file = Path("data/campsites.json")
is_valid = validate_against_schema(json_file, campsite_schema)
```

---

## 4. Parquet Files

### What is Parquet?

**Parquet** is a columnar storage format optimized for analytics and big data processing. It's the industry standard for data engineering and data science.

### Why Use Parquet?

| Feature | Parquet | CSV | JSON |
|---------|---------|-----|------|
| **File Size** | ⭐⭐⭐⭐⭐ Smallest (compression) | ⭐⭐ Medium | ⭐ Largest |
| **Read Speed** | ⭐⭐⭐⭐⭐ Very fast | ⭐⭐⭐ Medium | ⭐⭐ Slow |
| **Write Speed** | ⭐⭐⭐ Medium | ⭐⭐⭐⭐ Fast | ⭐⭐⭐⭐ Fast |
| **Data Types** | ✅ Preserved | ❌ Lost (all text) | ✅ Basic types |
| **Compression** | ✅ Built-in (snappy, gzip) | ❌ None | ❌ None |
| **Schema** | ✅ Self-describing | ❌ No schema | ❌ No schema |
| **Partial Read** | ✅ Column selection | ❌ Read all | ❌ Read all |
| **Best For** | Analytics, large datasets | Excel, simple data | APIs, configs |

**Use Parquet when:**
- Working with large datasets (> 100MB)
- Need fast analytics/queries
- Want to save storage space
- Working with data lakes (S3, Azure, GCS)
- Using Spark, Pandas, DuckDB
- Need to preserve data types

### Installing PyArrow

```bash
# Install pyarrow (required for Parquet support)
pip install pyarrow

# Or install with pandas (includes pyarrow)
pip install pandas pyarrow
```

### Writing Parquet Files

```python
import pyarrow as pa
import pyarrow.parquet as pq
from pathlib import Path

# ---------- METHOD 1: Using PyArrow Directly ----------

# Sample data
campsites_data = {
    'id': [1, 2, 3, 4, 5],
    'name': [
        'Camping Vale do Pati',
        'Serra dos Órgãos',
        'Pico da Bandeira',
        'Cachoeira Camp',
        'Trilha Azul'
    ],
    'state': ['BA', 'RJ', 'MG', 'BA', 'SP'],
    'price': [120.00, 80.00, 100.00, 95.00, 110.00],
    'capacity': [30, 25, 20, 15, 28],
    'available': [True, True, False, True, True]
}

# Create PyArrow Table
table = pa.table(campsites_data)

# Write to Parquet file
output_file = Path("output/campsites.parquet")
output_file.parent.mkdir(parents=True, exist_ok=True)

pq.write_table(table, output_file)
print(f"✅ Wrote {len(campsites_data['id'])} rows to {output_file}")

# Check file size
file_size_kb = output_file.stat().st_size / 1024
print(f"📁 File size: {file_size_kb:.2f} KB")
```

### Reading Parquet Files

```python
import pyarrow.parquet as pq
from pathlib import Path

# ---------- READ ENTIRE FILE ----------

parquet_file = Path("output/campsites.parquet")

# Read as PyArrow Table
table = pq.read_table(parquet_file)

# Convert to Python dictionary
data = table.to_pydict()
print(data)
# {
#     'id': [1, 2, 3, 4, 5],
#     'name': ['Camping Vale do Pati', ...],
#     'state': ['BA', 'RJ', 'MG', 'BA', 'SP'],
#     ...
# }

# Get row count
print(f"Rows: {table.num_rows}")
print(f"Columns: {table.num_columns}")

# Get column names
print(f"Columns: {table.column_names}")

# Access specific column
prices = table.column('price').to_pylist()
print(f"Prices: {prices}")


# ---------- READ SPECIFIC COLUMNS (Faster!) ----------

# Only read name and price columns
table_partial = pq.read_table(
    parquet_file,
    columns=['name', 'price']
)
print(f"Read {table_partial.num_columns} columns instead of {table.num_columns}")


# ---------- READ WITH FILTER ----------

# Read only rows where price > 90
import pyarrow.compute as pc

table = pq.read_table(parquet_file)
filtered = table.filter(pc.field('price') > 90)

print(f"Filtered: {filtered.num_rows} rows (price > 90)")
print(filtered.to_pydict())
```

### Parquet with Pandas (Most Common)

```python
import pandas as pd
from pathlib import Path

# ---------- WRITE PARQUET WITH PANDAS ----------

# Create DataFrame
df = pd.DataFrame({
    'id': [1, 2, 3, 4, 5],
    'name': [
        'Camping Vale do Pati',
        'Serra dos Órgãos',
        'Pico da Bandeira',
        'Cachoeira Camp',
        'Trilha Azul'
    ],
    'state': ['BA', 'RJ', 'MG', 'BA', 'SP'],
    'price': [120.00, 80.00, 100.00, 95.00, 110.00],
    'capacity': [30, 25, 20, 15, 28],
    'available': [True, True, False, True, True],
    'created_at': pd.to_datetime([
        '2024-01-15', '2024-02-20', '2024-03-10',
        '2024-04-05', '2024-05-12'
    ])
})

# Write to Parquet
output_file = Path("output/campsites_pandas.parquet")
df.to_parquet(output_file, index=False)  # index=False: don't save index
print(f"✅ Saved {len(df)} rows to Parquet")


# ---------- READ PARQUET WITH PANDAS ----------

# Read entire file
df_read = pd.read_parquet(output_file)
print(df_read.head())
print(f"\nData types:\n{df_read.dtypes}")

# Output:
#    id                 name state  price  capacity  available  created_at
# 0   1  Camping Vale do Pati    BA  120.0        30       True  2024-01-15
# 1   2     Serra dos Órgãos    RJ   80.0        25       True  2024-02-20
# ...
#
# Data types:
# id                       int64
# name                    object
# state                   object
# price                  float64
# capacity                 int64
# available                 bool
# created_at      datetime64[ns]


# ---------- READ SPECIFIC COLUMNS ----------

# Only read name and price
df_partial = pd.read_parquet(output_file, columns=['name', 'price'])
print(df_partial.head())


# ---------- READ WITH FILTER ----------

# Filter while reading (more efficient than reading then filtering)
df_filtered = pd.read_parquet(
    output_file,
    filters=[('price', '>', 90)]  # SQL-like filter
)
print(f"Filtered: {len(df_filtered)} rows")
```

### Parquet Compression Options

```python
import pandas as pd
from pathlib import Path

# Sample DataFrame
df = pd.DataFrame({
    'id': range(1, 10001),
    'name': [f'Campsite {i}' for i in range(1, 10001)],
    'price': [50 + (i % 100) for i in range(1, 10001)]
})

# ---------- TEST DIFFERENT COMPRESSION ----------

compression_methods = ['none', 'snappy', 'gzip', 'brotli', 'lz4', 'zstd']

for method in compression_methods:
    output_file = Path(f"output/campsites_{method}.parquet")
    
    try:
        df.to_parquet(output_file, compression=method, index=False)
        
        file_size_kb = output_file.stat().st_size / 1024
        print(f"{method:10s}: {file_size_kb:6.2f} KB")
        
    except Exception as e:
        print(f"{method:10s}: Not available ({e})")

# Typical output:
# none      :  XX.XX KB (no compression)
# snappy    :  XX.XX KB (fast compression, default)
# gzip      :  XX.XX KB (better compression, slower)
# brotli    :  XX.XX KB (best compression, slowest)
# lz4       :  XX.XX KB (very fast, moderate compression)
# zstd      :  XX.XX KB (good balance)
```

**Compression Recommendations:**
- **snappy** (default): Good balance of speed and compression
- **gzip**: Better compression, slower (good for long-term storage)
- **none**: Fastest read/write, largest size (use for temporary files)
- **zstd**: Modern, efficient (good all-around choice)

### Partitioned Parquet Files

For very large datasets, partition by a column (like date or state):

```python
import pandas as pd
from pathlib import Path

# Large dataset
df = pd.DataFrame({
    'id': range(1, 1001),
    'name': [f'Camp {i}' for i in range(1, 1001)],
    'state': ['BA', 'RJ', 'MG', 'SP'] * 250,  # Repeat states
    'price': [50 + (i % 100) for i in range(1, 1001)],
    'date': pd.date_range('2024-01-01', periods=1000, freq='H')
})

# ---------- WRITE PARTITIONED BY STATE ----------

output_dir = Path("output/campsites_partitioned")

df.to_parquet(
    output_dir,
    partition_cols=['state'],  # Create subdirectory for each state
    index=False
)

# This creates structure:
# output/campsites_partitioned/
# ├── state=BA/
# │   └── part-0.parquet
# ├── state=RJ/
# │   └── part-0.parquet
# ├── state=MG/
# │   └── part-0.parquet
# └── state=SP/
#     └── part-0.parquet


# ---------- READ SPECIFIC PARTITION ----------

# Read only BA campsites (faster!)
df_ba = pd.read_parquet(output_dir, filters=[('state', '==', 'BA')])
print(f"BA campsites: {len(df_ba)}")


# ---------- READ ALL PARTITIONS ----------

# Read everything
df_all = pd.read_parquet(output_dir)
print(f"All campsites: {len(df_all)}")
```

### Real-World Example: CSV to Parquet Conversion Pipeline

```python
import pandas as pd
from pathlib import Path
from typing import Dict, Any
import time

def convert_csv_to_parquet(
    csv_file: Path,
    parquet_file: Path,
    compression: str = 'snappy',
    chunk_size: int = 10000
) -> Dict[str, Any]:
    """Convert CSV to Parquet with statistics.
    
    Args:
        csv_file: Input CSV file
        parquet_file: Output Parquet file
        compression: Compression method
        chunk_size: Rows per chunk (for large files)
        
    Returns:
        Dictionary with conversion statistics
    """
    start_time = time.time()
    
    # Read CSV
    print(f"📖 Reading CSV: {csv_file}")
    df = pd.read_csv(csv_file)
    
    # Get CSV file size
    csv_size_mb = csv_file.stat().st_size / (1024 * 1024)
    
    # Write Parquet
    print(f"💾 Writing Parquet with {compression} compression...")
    parquet_file.parent.mkdir(parents=True, exist_ok=True)
    df.to_parquet(parquet_file, compression=compression, index=False)
    
    # Get Parquet file size
    parquet_size_mb = parquet_file.stat().st_size / (1024 * 1024)
    
    # Calculate stats
    elapsed_time = time.time() - start_time
    compression_ratio = (1 - (parquet_size_mb / csv_size_mb)) * 100
    
    stats = {
        'rows': len(df),
        'columns': len(df.columns),
        'csv_size_mb': round(csv_size_mb, 2),
        'parquet_size_mb': round(parquet_size_mb, 2),
        'space_saved_mb': round(csv_size_mb - parquet_size_mb, 2),
        'compression_ratio': round(compression_ratio, 2),
        'elapsed_seconds': round(elapsed_time, 2)
    }
    
    return stats

# Use it
csv_file = Path("data/large_campsites.csv")
parquet_file = Path("output/campsites_optimized.parquet")

stats = convert_csv_to_parquet(csv_file, parquet_file)

print(f"""
✅ Conversion Complete!
----------------------
Rows:              {stats['rows']:,}
Columns:           {stats['columns']}
CSV size:          {stats['csv_size_mb']} MB
Parquet size:      {stats['parquet_size_mb']} MB
Space saved:       {stats['space_saved_mb']} MB ({stats['compression_ratio']}%)
Time:              {stats['elapsed_seconds']} seconds
""")
```

---

**🎯 Part 2 Section 1 Complete!**

This covers JSON and Parquet extensively. Next, I'll add Context Managers and Exercises. Continue?

---

## 5. Context Managers and the `with` Statement

### What is a Context Manager?

A **context manager** is a Python feature that helps manage resources (files, connections, locks) by automatically cleaning them up when you're done. The `with` statement is how you use context managers.

### Why Use Context Managers?

```python
# ❌ WITHOUT context manager (BAD PRACTICE)
file = open('data.txt', 'r')
data = file.read()
file.close()  # Easy to forget!
# If an error occurs before close(), file stays open forever!

# ✅ WITH context manager (BEST PRACTICE)
with open('data.txt', 'r') as file:
    data = file.read()
# File automatically closed here, even if error occurs!
```

**Benefits:**
1. **Automatic cleanup**: Resources released automatically
2. **Error safety**: Cleanup happens even if exception occurs
3. **Cleaner code**: Less boilerplate
4. **Prevents resource leaks**: No forgotten `close()` calls

### The `with` Statement Anatomy

```python
with EXPRESSION as VARIABLE:
    # CODE BLOCK
    # VARIABLE is available here
    # When block ends, cleanup happens automatically
# VARIABLE no longer available here (out of scope)

# Example:
with open('data.txt', 'r') as file:
    #    ^^^^^^^^^^^^^^^^^^^^  ^^^^
    #    EXPRESSION            VARIABLE
    content = file.read()
    # File is open and usable here
# File is automatically closed here
```

### File Operations with Context Managers

```python
from pathlib import Path

# ---------- READING FILES ----------

file_path = Path("data/campsites.csv")

# Read entire file
with open(file_path, 'r', encoding='utf-8') as file:
    content = file.read()
    print(content)
# File automatically closed

# Read line by line
with open(file_path, 'r', encoding='utf-8') as file:
    for line in file:
        print(line.strip())
# File automatically closed

# Read all lines into list
with open(file_path, 'r', encoding='utf-8') as file:
    lines = file.readlines()
    print(f"Total lines: {len(lines)}")
# File automatically closed


# ---------- WRITING FILES ----------

output_file = Path("output/report.txt")
output_file.parent.mkdir(parents=True, exist_ok=True)

# Write text
with open(output_file, 'w', encoding='utf-8') as file:
    file.write("Campsite Report\n")
    file.write("===============\n")
    file.write("Total: 150 campsites\n")
# File automatically closed and saved


# ---------- APPENDING TO FILES ----------

with open(output_file, 'a', encoding='utf-8') as file:
    file.write("\nAdditional info...\n")
# File automatically closed
```

### Multiple Context Managers

You can use multiple context managers in one `with` statement:

```python
from pathlib import Path

# ---------- METHOD 1: Separate with statements ----------

input_file = Path("data/campsites.csv")
output_file = Path("output/processed.csv")

with open(input_file, 'r', encoding='utf-8') as infile:
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for line in infile:
            # Process and write
            processed = line.upper()
            outfile.write(processed)
# Both files automatically closed


# ---------- METHOD 2: Single with statement (Python 3.1+) ----------

with open(input_file, 'r', encoding='utf-8') as infile, \
     open(output_file, 'w', encoding='utf-8') as outfile:
    for line in infile:
        processed = line.upper()
        outfile.write(processed)
# Both files automatically closed


# ---------- METHOD 3: Parentheses (Python 3.10+, most readable) ----------

with (
    open(input_file, 'r', encoding='utf-8') as infile,
    open(output_file, 'w', encoding='utf-8') as outfile
):
    for line in infile:
        processed = line.upper()
        outfile.write(processed)
# Both files automatically closed
```

### Context Managers for Different Resources

```python
import csv
import json
import sqlite3
from pathlib import Path

# ---------- CSV FILES ----------

csv_file = Path("data/campsites.csv")
with open(csv_file, 'r', encoding='utf-8') as file:
    reader = csv.DictReader(file)
    for row in reader:
        print(row)
# File automatically closed


# ---------- JSON FILES ----------

json_file = Path("data/config.json")
with open(json_file, 'r', encoding='utf-8') as file:
    config = json.load(file)
    print(config)
# File automatically closed


# ---------- DATABASE CONNECTIONS ----------

db_file = Path("data/camping.db")
with sqlite3.connect(db_file) as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM campsites")
    results = cursor.fetchall()
    print(results)
# Connection automatically closed


# ---------- PATHLIB (Python 3.11+) ----------

# Path objects can be context managers
data_file = Path("data/report.txt")
with data_file.open('r', encoding='utf-8') as file:
    content = file.read()
# File automatically closed
```

### Creating Custom Context Managers (Class-Based)

```python
from pathlib import Path
from typing import TextIO
import time

class TimedFileWriter:
    """Context manager that times file writing operations."""
    
    def __init__(self, file_path: Path, mode: str = 'w'):
        """Initialize the context manager.
        
        Args:
            file_path: Path to file
            mode: File open mode ('w', 'a', etc.)
        """
        self.file_path = file_path
        self.mode = mode
        self.file: TextIO = None
        self.start_time: float = None
    
    def __enter__(self):
        """Called when entering 'with' block.
        
        Returns:
            The file object to use in the with statement
        """
        print(f"⏱️  Opening {self.file_path}...")
        self.start_time = time.time()
        self.file = open(self.file_path, self.mode, encoding='utf-8')
        return self.file  # This becomes the 'as' variable
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when exiting 'with' block.
        
        Args:
            exc_type: Exception type (if error occurred)
            exc_val: Exception value
            exc_tb: Exception traceback
            
        Returns:
            False to propagate exceptions, True to suppress them
        """
        elapsed = time.time() - self.start_time
        
        if self.file:
            self.file.close()
        
        if exc_type is None:
            # No error
            print(f"✅ Completed in {elapsed:.3f} seconds")
        else:
            # Error occurred
            print(f"❌ Error after {elapsed:.3f} seconds: {exc_val}")
        
        return False  # Don't suppress exceptions

# Use it
output_file = Path("output/timed_report.txt")
output_file.parent.mkdir(parents=True, exist_ok=True)

with TimedFileWriter(output_file) as file:
    file.write("Processing campsites...\n")
    for i in range(100000):
        file.write(f"Campsite {i}\n")
# Output:
# ⏱️  Opening output/timed_report.txt...
# ✅ Completed in 0.234 seconds
```

### Creating Custom Context Managers (Function-Based)

```python
from contextlib import contextmanager
from pathlib import Path
import time

@contextmanager
def timed_operation(operation_name: str):
    """Context manager that times an operation.
    
    Args:
        operation_name: Name of operation to time
        
    Yields:
        None (just provides timing context)
    """
    print(f"⏱️  Starting {operation_name}...")
    start_time = time.time()
    
    try:
        yield  # Code in 'with' block runs here
    finally:
        # This runs whether error occurs or not
        elapsed = time.time() - start_time
        print(f"✅ {operation_name} completed in {elapsed:.3f} seconds")

# Use it
with timed_operation("Data Processing"):
    # Simulate work
    data = []
    for i in range(1000000):
        data.append(i * 2)
# Output:
# ⏱️  Starting Data Processing...
# ✅ Data Processing completed in 0.123 seconds


# ---------- ANOTHER EXAMPLE: Temporary Directory ----------

@contextmanager
def temporary_directory(base_path: Path):
    """Create temporary directory that's automatically deleted.
    
    Args:
        base_path: Base path for temp directory
        
    Yields:
        Path to temporary directory
    """
    import shutil
    from datetime import datetime
    
    # Create temp directory
    temp_name = f"temp_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    temp_dir = base_path / temp_name
    temp_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"📁 Created temporary directory: {temp_dir}")
    
    try:
        yield temp_dir  # Provide temp directory to 'with' block
    finally:
        # Clean up
        if temp_dir.exists():
            shutil.rmtree(temp_dir)
            print(f"🗑️  Deleted temporary directory: {temp_dir}")

# Use it
base = Path("output")
with temporary_directory(base) as temp_dir:
    # Use temp directory
    temp_file = temp_dir / "temp_data.txt"
    temp_file.write_text("Temporary data")
    print(f"Working in: {temp_dir}")
# Directory automatically deleted here
# Output:
# 📁 Created temporary directory: output/temp_20240715_143022
# Working in: output/temp_20240715_143022
# 🗑️  Deleted temporary directory: output/temp_20240715_143022
```

### Real-World Example: Safe File Processing Pipeline

```python
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator
import csv
import json

@contextmanager
def safe_file_processing(
    input_file: Path,
    output_file: Path,
    backup: bool = True
) -> Iterator[tuple]:
    """Safely process file with automatic backup and error recovery.
    
    Args:
        input_file: Input file path
        output_file: Output file path
        backup: Whether to create backup of output file
        
    Yields:
        Tuple of (input_handle, output_handle)
    """
    import shutil
    
    backup_file = None
    
    # Create backup if output exists
    if backup and output_file.exists():
        backup_file = output_file.with_suffix(output_file.suffix + '.backup')
        shutil.copy2(output_file, backup_file)
        print(f"💾 Created backup: {backup_file}")
    
    # Ensure output directory exists
    output_file.parent.mkdir(parents=True, exist_ok=True)
    
    input_handle = None
    output_handle = None
    
    try:
        # Open both files
        input_handle = open(input_file, 'r', encoding='utf-8')
        output_handle = open(output_file, 'w', encoding='utf-8')
        
        print(f"📖 Processing: {input_file} → {output_file}")
        
        yield (input_handle, output_handle)
        
        print(f"✅ Successfully processed {input_file}")
        
        # If successful, delete backup
        if backup_file and backup_file.exists():
            backup_file.unlink()
            print(f"🗑️  Removed backup (processing successful)")
        
    except Exception as e:
        print(f"❌ Error during processing: {e}")
        
        # Restore from backup if available
        if backup_file and backup_file.exists():
            shutil.copy2(backup_file, output_file)
            print(f"↩️  Restored from backup")
        
        raise  # Re-raise exception
    
    finally:
        # Always close files
        if input_handle:
            input_handle.close()
        if output_handle:
            output_handle.close()

# Use it
input_csv = Path("data/campsites.csv")
output_json = Path("output/campsites_converted.json")

with safe_file_processing(input_csv, output_json) as (infile, outfile):
    # Convert CSV to JSON
    reader = csv.DictReader(infile)
    data = list(reader)
    json.dump(data, outfile, indent=4, ensure_ascii=False)
```

### Context Manager Error Handling

```python
from pathlib import Path

# ---------- BASIC ERROR HANDLING ----------

file_path = Path("data/might_not_exist.txt")

try:
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
        print(content)
except FileNotFoundError:
    print(f"❌ File not found: {file_path}")
except PermissionError:
    print(f"❌ Permission denied: {file_path}")
except Exception as e:
    print(f"❌ Unexpected error: {e}")
# File automatically closed even if error occurs


# ---------- SUPPRESS ERRORS (contextlib.suppress) ----------

from contextlib import suppress

file_path = Path("data/optional_file.txt")

# If file doesn't exist, just skip (no error)
with suppress(FileNotFoundError):
    with open(file_path, 'r', encoding='utf-8') as file:
        print(file.read())
# If FileNotFoundError occurs, it's silently suppressed


# ---------- MULTIPLE ERROR HANDLING ----------

file_path = Path("data/campsites.csv")

try:
    with open(file_path, 'r', encoding='utf-8') as file:
        # Process file
        for line_num, line in enumerate(file, 1):
            # Might have errors parsing specific lines
            try:
                # Process line
                data = line.strip().split(',')
                price = float(data[2])  # Might fail
                print(f"Line {line_num}: ${price}")
            except (IndexError, ValueError) as e:
                print(f"⚠️  Skipping line {line_num}: {e}")
                continue  # Skip bad line, continue processing
                
except FileNotFoundError:
    print(f"❌ File not found: {file_path}")
# File automatically closed
```

---

## 6. Practice Exercises

### Exercise 1: File Path Explorer ⭐

Create a function that explores a directory and returns statistics.

**Requirements:**
- Use pathlib to navigate directories
- Count total files and directories
- Calculate total size of all files
- List file extensions found

```python
from pathlib import Path
from typing import Dict, List

def explore_directory(directory: Path) -> Dict:
    """Explore directory and return statistics.
    
    Args:
        directory: Path to directory to explore
        
    Returns:
        Dictionary with statistics
    """
    # Your code here
    pass

# Test it
project_dir = Path(".")
stats = explore_directory(project_dir)
print(stats)
# Expected output:
# {
#     'total_files': 42,
#     'total_dirs': 8,
#     'total_size_mb': 15.3,
#     'extensions': ['.py', '.md', '.csv', '.json']
# }
```

<details>
<summary>💡 Hint</summary>

Use `rglob('*')` to recursively get all items. Check `is_file()` and `is_dir()`. Use `stat().st_size` for file sizes.
</details>

<details>
<summary>✅ Solution</summary>

```python
from pathlib import Path
from typing import Dict, List

def explore_directory(directory: Path) -> Dict:
    """Explore directory and return statistics."""
    total_files = 0
    total_dirs = 0
    total_size_bytes = 0
    extensions = set()
    
    # Recursively explore directory
    for item in directory.rglob('*'):
        if item.is_file():
            total_files += 1
            total_size_bytes += item.stat().st_size
            
            # Track extensions
            if item.suffix:
                extensions.add(item.suffix)
        
        elif item.is_dir():
            total_dirs += 1
    
    return {
        'total_files': total_files,
        'total_dirs': total_dirs,
        'total_size_mb': round(total_size_bytes / (1024 * 1024), 2),
        'extensions': sorted(extensions)
    }

# Test it
project_dir = Path(".")
stats = explore_directory(project_dir)
print(f"""
Directory Statistics
-------------------
Files:       {stats['total_files']}
Directories: {stats['total_dirs']}
Total Size:  {stats['total_size_mb']} MB
Extensions:  {', '.join(stats['extensions'])}
""")
```
</details>

---

### Exercise 2: CSV Data Validator ⭐⭐

Create a function that validates CSV data and reports errors.

**Requirements:**
- Read CSV file with DictReader
- Validate required fields exist
- Validate data types (price must be number, capacity must be integer)
- Return list of validation errors with line numbers

```python
from pathlib import Path
from typing import List, Dict
import csv

def validate_campsite_csv(csv_file: Path) -> List[Dict]:
    """Validate campsite CSV and return errors.
    
    Args:
        csv_file: Path to CSV file
        
    Returns:
        List of error dictionaries
    """
    # Your code here
    pass

# Test it
csv_file = Path("data/campsites.csv")
errors = validate_campsite_csv(csv_file)
if errors:
    print(f"Found {len(errors)} errors:")
    for error in errors:
        print(f"  Line {error['line']}: {error['message']}")
else:
    print("✅ All data is valid!")
```

<details>
<summary>💡 Hint</summary>

Use enumerate() to track line numbers. Try to convert strings to int/float and catch ValueError exceptions.
</details>

<details>
<summary>✅ Solution</summary>

```python
from pathlib import Path
from typing import List, Dict
import csv

def validate_campsite_csv(csv_file: Path) -> List[Dict]:
    """Validate campsite CSV and return errors."""
    errors = []
    required_fields = ['id', 'name', 'state', 'price', 'capacity']
    
    with open(csv_file, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        
        # Check header
        if not all(field in reader.fieldnames for field in required_fields):
            missing = set(required_fields) - set(reader.fieldnames)
            errors.append({
                'line': 'header',
                'message': f"Missing required fields: {missing}"
            })
            return errors
        
        # Validate each row
        for line_num, row in enumerate(reader, start=2):  # start=2 (line 1 is header)
            # Check required fields not empty
            for field in required_fields:
                if not row.get(field, '').strip():
                    errors.append({
                        'line': line_num,
                        'field': field,
                        'message': f"Field '{field}' is empty"
                    })
            
            # Validate id is integer
            try:
                int(row['id'])
            except ValueError:
                errors.append({
                    'line': line_num,
                    'field': 'id',
                    'message': f"ID must be integer, got: {row['id']}"
                })
            
            # Validate price is number
            try:
                price = float(row['price'])
                if price < 0:
                    errors.append({
                        'line': line_num,
                        'field': 'price',
                        'message': f"Price cannot be negative: {price}"
                    })
            except ValueError:
                errors.append({
                    'line': line_num,
                    'field': 'price',
                    'message': f"Price must be number, got: {row['price']}"
                })
            
            # Validate capacity is positive integer
            try:
                capacity = int(row['capacity'])
                if capacity <= 0:
                    errors.append({
                        'line': line_num,
                        'field': 'capacity',
                        'message': f"Capacity must be positive: {capacity}"
                    })
            except ValueError:
                errors.append({
                    'line': line_num,
                    'field': 'capacity',
                    'message': f"Capacity must be integer, got: {row['capacity']}"
                })
            
            # Validate state is 2 uppercase letters
            state = row['state'].strip()
            if len(state) != 2 or not state.isupper():
                errors.append({
                    'line': line_num,
                    'field': 'state',
                    'message': f"State must be 2 uppercase letters, got: {state}"
                })
    
    return errors

# Test it
csv_file = Path("data/campsites.csv")
errors = validate_campsite_csv(csv_file)

if errors:
    print(f"❌ Found {len(errors)} validation errors:\n")
    for error in errors:
        line = error['line']
        field = error.get('field', 'N/A')
        message = error['message']
        print(f"  Line {line} [{field}]: {message}")
else:
    print("✅ All data is valid!")
```
</details>

---

### Exercise 3: JSON Configuration Manager ⭐⭐

Create a class to manage application configuration stored in JSON.

**Requirements:**
- Load configuration from JSON file
- Get configuration value by key (support nested keys like "database.host")
- Update configuration value
- Save configuration back to JSON file
- Use context managers for file operations

```python
from pathlib import Path
from typing import Any

class ConfigManager:
    """Manage application configuration in JSON format."""
    
    def __init__(self, config_file: Path):
        """Initialize with config file path."""
        pass
    
    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value.
        
        Args:
            key: Configuration key (supports dot notation: "database.host")
            default: Default value if key not found
        """
        pass
    
    def set(self, key: str, value: Any) -> None:
        """Set configuration value."""
        pass
    
    def save(self) -> None:
        """Save configuration to file."""
        pass

# Test it
config = ConfigManager(Path("config/app.json"))
print(config.get("database.host"))  # "localhost"
config.set("database.port", 5433)
config.save()
```

<details>
<summary>✅ Solution</summary>

```python
from pathlib import Path
from typing import Any
import json

class ConfigManager:
    """Manage application configuration in JSON format."""
    
    def __init__(self, config_file: Path):
        """Initialize with config file path."""
        self.config_file = config_file
        self.config = {}
        
        # Load configuration if file exists
        if self.config_file.exists():
            with open(self.config_file, 'r', encoding='utf-8') as file:
                self.config = json.load(file)
    
    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value.
        
        Supports dot notation for nested keys: "database.host"
        """
        keys = key.split('.')
        value = self.config
        
        for k in keys:
            if isinstance(value, dict) and k in value:
                value = value[k]
            else:
                return default
        
        return value
    
    def set(self, key: str, value: Any) -> None:
        """Set configuration value.
        
        Supports dot notation for nested keys: "database.port"
        """
        keys = key.split('.')
        config = self.config
        
        # Navigate to parent
        for k in keys[:-1]:
            if k not in config:
                config[k] = {}
            config = config[k]
        
        # Set value
        config[keys[-1]] = value
    
    def save(self) -> None:
        """Save configuration to file."""
        self.config_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(self.config_file, 'w', encoding='utf-8') as file:
            json.dump(self.config, file, indent=4, ensure_ascii=False)
        
        print(f"✅ Configuration saved to {self.config_file}")

# Test it
config_file = Path("config/app.json")

# Create initial config
initial_config = {
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "camping_db"
    },
    "logging": {
        "level": "INFO",
        "file": "app.log"
    }
}

# Save initial config
config_file.parent.mkdir(parents=True, exist_ok=True)
with open(config_file, 'w', encoding='utf-8') as f:
    json.dump(initial_config, f, indent=4)

# Use ConfigManager
config = ConfigManager(config_file)

print(f"Database host: {config.get('database.host')}")
print(f"Database port: {config.get('database.port')}")
print(f"Log level: {config.get('logging.level')}")

# Update config
config.set('database.port', 5433)
config.set('api.timeout', 30)  # Add new nested key
config.save()

print(f"\nUpdated port: {config.get('database.port')}")
print(f"New API timeout: {config.get('api.timeout')}")
```
</details>

---

### Exercise 4: Multi-Format Data Converter ⭐⭐⭐

Create a tool that converts between CSV, JSON, and Parquet formats.

**Requirements:**
- Support CSV → JSON, CSV → Parquet
- Support JSON → CSV, JSON → Parquet
- Support Parquet → CSV, Parquet → JSON
- Detect format from file extension
- Handle nested JSON when converting to CSV (flatten)
- Use context managers appropriately

```python
from pathlib import Path
from typing import Optional

def convert_data_format(
    input_file: Path,
    output_file: Path,
    flatten_json: bool = True
) -> bool:
    """Convert between CSV, JSON, and Parquet formats.
    
    Args:
        input_file: Input file path
        output_file: Output file path
        flatten_json: Whether to flatten nested JSON for CSV
        
    Returns:
        True if successful, False otherwise
    """
    # Your code here
    pass

# Test it
csv_file = Path("data/campsites.csv")
json_file = Path("output/campsites.json")
parquet_file = Path("output/campsites.parquet")

# CSV to JSON
convert_data_format(csv_file, json_file)

# JSON to Parquet
convert_data_format(json_file, parquet_file)

# Parquet to CSV
convert_data_format(parquet_file, Path("output/campsites_from_parquet.csv"))
```

<details>
<summary>💡 Hint</summary>

Use pandas for easy conversion! `pd.read_csv()`, `pd.read_json()`, `pd.read_parquet()` and corresponding `.to_*()` methods.
</details>

<details>
<summary>✅ Solution</summary>

```python
from pathlib import Path
from typing import Optional
import pandas as pd
import json

def flatten_dict(nested_dict: dict, parent_key: str = '', sep: str = '_') -> dict:
    """Flatten nested dictionary."""
    items = []
    for k, v in nested_dict.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten_dict(v, new_key, sep=sep).items())
        elif isinstance(v, list):
            items.append((new_key, json.dumps(v)))
        else:
            items.append((new_key, v))
    return dict(items)

def convert_data_format(
    input_file: Path,
    output_file: Path,
    flatten_json: bool = True
) -> bool:
    """Convert between CSV, JSON, and Parquet formats."""
    
    try:
        # Detect input format
        input_ext = input_file.suffix.lower()
        output_ext = output_file.suffix.lower()
        
        print(f"🔄 Converting {input_ext} → {output_ext}")
        
        # Read input based on format
        if input_ext == '.csv':
            df = pd.read_csv(input_file)
        elif input_ext == '.json':
            with open(input_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Handle array of objects vs single object
            if isinstance(data, list):
                # Flatten if needed
                if flatten_json and data and isinstance(data[0], dict):
                    data = [flatten_dict(item) for item in data]
                df = pd.DataFrame(data)
            else:
                df = pd.DataFrame([data])
                
        elif input_ext == '.parquet':
            df = pd.read_parquet(input_file)
        else:
            print(f"❌ Unsupported input format: {input_ext}")
            return False
        
        # Ensure output directory exists
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Write output based on format
        if output_ext == '.csv':
            df.to_csv(output_file, index=False)
        elif output_ext == '.json':
            df.to_json(
                output_file,
                orient='records',
                indent=4,
                force_ascii=False
            )
        elif output_ext == '.parquet':
            df.to_parquet(output_file, index=False)
        else:
            print(f"❌ Unsupported output format: {output_ext}")
            return False
        
        # Report statistics
        file_size_kb = output_file.stat().st_size / 1024
        print(f"✅ Converted {len(df)} rows, {len(df.columns)} columns")
        print(f"📁 Output: {output_file} ({file_size_kb:.2f} KB)")
        
        return True
        
    except Exception as e:
        print(f"❌ Error during conversion: {e}")
        return False

# Test it
print("=" * 60)
print("Multi-Format Data Converter")
print("=" * 60)

# Create sample CSV
csv_file = Path("data/sample_campsites.csv")
csv_file.parent.mkdir(parents=True, exist_ok=True)

with open(csv_file, 'w', encoding='utf-8') as f:
    f.write("id,name,state,price,capacity\n")
    f.write("1,Camping Vale,BA,120.00,30\n")
    f.write("2,Serra Camp,RJ,80.00,25\n")
    f.write("3,Pico Camp,MG,100.00,20\n")

print(f"\n📝 Created sample CSV with 3 rows\n")

# CSV → JSON
json_file = Path("output/converted.json")
print("1. CSV → JSON")
convert_data_format(csv_file, json_file)

# JSON → Parquet
parquet_file = Path("output/converted.parquet")
print("\n2. JSON → Parquet")
convert_data_format(json_file, parquet_file)

# Parquet → CSV
csv_output = Path("output/converted_back.csv")
print("\n3. Parquet → CSV")
convert_data_format(parquet_file, csv_output)

print("\n" + "=" * 60)
print("✅ All conversions complete!")
print("=" * 60)
```
</details>

---

### Exercise 5: Log File Analyzer ⭐⭐⭐

Create a log file analyzer that processes application logs and generates a report.

**Requirements:**
- Read log file line by line (memory efficient)
- Parse log lines (timestamp, level, message)
- Count logs by level (INFO, WARNING, ERROR)
- Extract error messages
- Generate JSON report with statistics
- Use context managers for all file operations

```python
from pathlib import Path
from typing import Dict, List
from datetime import datetime

def analyze_log_file(log_file: Path, output_json: Path) -> Dict:
    """Analyze log file and generate statistics report.
    
    Args:
        log_file: Path to log file
        output_json: Path for JSON report
        
    Returns:
        Dictionary with statistics
    """
    # Your code here
    pass

# Test it
log_file = Path("logs/app.log")
report_file = Path("output/log_report.json")
stats = analyze_log_file(log_file, report_file)
print(f"Total logs: {stats['total_lines']}")
print(f"Errors: {stats['counts']['ERROR']}")
```

<details>
<summary>✅ Solution</summary>

```python
from pathlib import Path
from typing import Dict, List
from datetime import datetime
import json
import re

def analyze_log_file(log_file: Path, output_json: Path) -> Dict:
    """Analyze log file and generate statistics report."""
    
    # Initialize statistics
    stats = {
        'file': str(log_file),
        'analyzed_at': datetime.now().isoformat(),
        'total_lines': 0,
        'counts': {
            'INFO': 0,
            'WARNING': 0,
            'ERROR': 0,
            'DEBUG': 0
        },
        'errors': [],
        'warnings': []
    }
    
    # Log line pattern: 2024-07-15 10:30:45 [ERROR] Something went wrong
    pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \[(\w+)\] (.+)'
    
    # Process log file line by line (memory efficient)
    with open(log_file, 'r', encoding='utf-8') as file:
        for line_num, line in enumerate(file, 1):
            stats['total_lines'] += 1
            
            # Parse log line
            match = re.match(pattern, line.strip())
            if match:
                timestamp_str, level, message = match.groups()
                
                # Count by level
                if level in stats['counts']:
                    stats['counts'][level] += 1
                
                # Collect errors
                if level == 'ERROR':
                    stats['errors'].append({
                        'line': line_num,
                        'timestamp': timestamp_str,
                        'message': message
                    })
                
                # Collect warnings
                if level == 'WARNING':
                    stats['warnings'].append({
                        'line': line_num,
                        'timestamp': timestamp_str,
                        'message': message
                    })
    
    # Calculate percentages
    total = stats['total_lines']
    if total > 0:
        stats['percentages'] = {
            level: round((count / total) * 100, 2)
            for level, count in stats['counts'].items()
        }
    
    # Save report
    output_json.parent.mkdir(parents=True, exist_ok=True)
    with open(output_json, 'w', encoding='utf-8') as file:
        json.dump(stats, file, indent=4, ensure_ascii=False)
    
    print(f"✅ Report saved to {output_json}")
    
    return stats

# Create sample log file for testing
log_file = Path("logs/app.log")
log_file.parent.mkdir(parents=True, exist_ok=True)

with open(log_file, 'w', encoding='utf-8') as f:
    f.write("2024-07-15 10:30:45 [INFO] Application started\n")
    f.write("2024-07-15 10:30:46 [INFO] Loading configuration\n")
    f.write("2024-07-15 10:30:47 [WARNING] Configuration file not found, using defaults\n")
    f.write("2024-07-15 10:30:48 [INFO] Connecting to database\n")
    f.write("2024-07-15 10:30:50 [ERROR] Failed to connect to database: Connection timeout\n")
    f.write("2024-07-15 10:30:51 [INFO] Retrying connection\n")
    f.write("2024-07-15 10:30:55 [INFO] Successfully connected to database\n")
    f.write("2024-07-15 10:31:00 [INFO] Processing data\n")
    f.write("2024-07-15 10:31:15 [WARNING] Slow query detected (5.2s)\n")
    f.write("2024-07-15 10:31:20 [INFO] Data processing complete\n")

# Analyze log file
report_file = Path("output/log_report.json")
stats = analyze_log_file(log_file, report_file)

# Print summary
print(f"""
Log Analysis Report
==================
Total Lines:    {stats['total_lines']}

Counts:
  INFO:         {stats['counts']['INFO']} ({stats['percentages']['INFO']}%)
  WARNING:      {stats['counts']['WARNING']} ({stats['percentages']['WARNING']}%)
  ERROR:        {stats['counts']['ERROR']} ({stats['percentages']['ERROR']}%)
  DEBUG:        {stats['counts']['DEBUG']} ({stats['percentages']['DEBUG']}%)

Errors Found:   {len(stats['errors'])}
Warnings Found: {len(stats['warnings'])}
""")

if stats['errors']:
    print("Errors:")
    for error in stats['errors']:
        print(f"  Line {error['line']}: {error['message']}")

if stats['warnings']:
    print("\nWarnings:")
    for warning in stats['warnings']:
        print(f"  Line {warning['line']}: {warning['message']}")
```
</details>

---

**🎯 Lesson 2: Files & Data Formats - Complete!**

You've mastered:
- ✅ **pathlib**: Cross-platform file path management
- ✅ **CSV**: Reading/writing tabular data with type conversion and error handling
- ✅ **JSON**: Working with nested data structures, custom encoders, validation
- ✅ **Parquet**: Columnar format for analytics with compression
- ✅ **Context Managers**: Safe resource management with `with` statement
- ✅ **5 Real-World Exercises**: From basic to advanced data processing

**Next Steps:**
- Practice all exercises
- Try mixing formats in your own projects
- Explore pandas/polars for more advanced data manipulation
- Move to Lesson 3: Database Connectivity (psycopg2, SQLAlchemy)

**Total Content:** ~2,500 lines of comprehensive explanations, examples, and exercises! 🚀
