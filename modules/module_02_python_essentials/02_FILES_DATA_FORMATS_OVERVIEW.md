# Lesson 2: Working with Files & Data Formats - Complete Overview

## 📖 Introduction

Welcome to **Lesson 2: Working with Files & Data Formats**! This lesson teaches you how to read, write, and process data files—the foundation of all data engineering work. You'll master CSV, JSON, and Parquet formats, the three most common formats in modern data pipelines.

**Why This Lesson Matters:**
- **Data is in Files** - Real data engineering starts with file I/O
- **Industry Standard Formats** - CSV, JSON, and Parquet power most pipelines
- **Production Skills** - Learn to handle files safely and efficiently
- **Format Conversion** - Master transforming between formats
- **Error Handling** - Handle file errors gracefully in production

---

## 📊 Lesson Statistics

| Metric | Value |
|--------|-------|
| **Total Lines** | 3,211 lines |
| **Sections** | 6 comprehensive sections |
| **Code Examples** | 90+ working examples |
| **Practice Exercises** | 5 with complete solutions |
| **Estimated Study Time** | 8-10 hours |
| **Difficulty Level** | Intermediate |
| **Prerequisites** | Lesson 1 completed |

---

## 🎯 Learning Objectives

By the end of this lesson, you will be able to:

✅ **File Path Management:**
- Use pathlib for cross-platform paths
- Join paths with the `/` operator
- Check file/directory existence
- Create directories and handle missing paths
- Navigate relative and absolute paths
- Work with file extensions and names

✅ **CSV Files:**
- Read CSV files with csv.reader and csv.DictReader
- Write CSV files with proper headers
- Handle different delimiters and quote characters
- Process large CSV files line by line
- Clean and validate CSV data
- Convert CSV to other formats

✅ **JSON Data:**
- Parse JSON strings to Python objects
- Convert Python dicts/lists to JSON
- Read and write JSON files
- Handle nested JSON structures
- Work with JSON APIs
- Pretty-print JSON for debugging
- Validate JSON structure

✅ **Parquet Files:**
- Understand columnar storage benefits
- Read Parquet files with pyarrow
- Write DataFrames to Parquet format
- Choose compression algorithms
- Handle partitioned Parquet files
- Convert between CSV/JSON and Parquet

✅ **Context Managers:**
- Use `with` statement for safe file handling
- Understand resource management
- Create custom context managers
- Handle file closing automatically
- Avoid resource leaks

✅ **Error Handling:**
- Handle FileNotFoundError gracefully
- Catch JSON parsing errors
- Validate file formats before processing
- Recover from malformed data
- Log errors appropriately

---

## 📚 Lesson Structure

### **Section 1: File Path Management with pathlib** (~244 lines)

**What You'll Learn:**
- Modern path handling with pathlib
- Cross-platform path operations
- File and directory management
- Path navigation and manipulation

**Key Topics:**

**pathlib Basics:**
- Why pathlib over os.path (readability, cross-platform)
- Creating Path objects: `Path('data/file.csv')`
- Joining paths with `/` operator: `base_dir / 'data' / 'file.csv'`
- Current directory: `Path.cwd()`
- Home directory: `Path.home()`

**Path Operations:**
- Check existence: `.exists()`, `.is_file()`, `.is_dir()`
- Get file info: `.name`, `.stem`, `.suffix`, `.parent`
- Create directories: `.mkdir(parents=True, exist_ok=True)`
- List directory contents: `.iterdir()`, `.glob()`, `.rglob()`
- Read/write text: `.read_text()`, `.write_text()`

**Real-World Examples:**
```python
from pathlib import Path

# Cross-platform data directory
data_dir = Path('data')
csv_file = data_dir / 'campsites.csv'

# Check before processing
if csv_file.exists():
    content = csv_file.read_text()

# Find all CSV files
csv_files = list(data_dir.glob('*.csv'))
```

**Practical Skills:**
- Write portable code for Windows/Mac/Linux
- Navigate project directories safely
- Check files exist before opening
- Create directory structures
- Find files by pattern

---

### **Section 2: Working with CSV Files** (~431 lines)

**What You'll Learn:**
- Read CSV files with csv module
- Write CSV files with proper formatting
- Handle headers and different delimiters
- Process large CSV files efficiently

**Key Topics:**

**Reading CSV Files:**
- **csv.reader()**: Row-by-row as lists
  ```python
  import csv
  with open('data.csv') as f:
      reader = csv.reader(f)
      for row in reader:
          print(row)  # ['name', 'age', 'city']
  ```

- **csv.DictReader()**: Rows as dictionaries (recommended)
  ```python
  with open('data.csv') as f:
      reader = csv.DictReader(f)
      for row in reader:
          print(row['name'], row['age'])  # Named access
  ```

**Writing CSV Files:**
- **csv.writer()**: Write lists
- **csv.DictWriter()**: Write dictionaries with headers
- Automatic header writing
- Proper quoting and escaping
- Custom delimiters (tabs, pipes)

**Advanced CSV Techniques:**
- Handling different encodings (UTF-8, Latin-1)
- Processing files larger than RAM
- Filtering rows while reading
- Data validation during load
- Converting data types
- Handling missing values

**Real-World Examples:**
- Reading campsite data from CSV
- Filtering and transforming rows
- Writing cleaned data to new CSV
- Handling malformed CSV data
- Building CSV data pipelines

**Practical Skills:**
- Choose reader vs DictReader appropriately
- Write CSVs with headers automatically
- Handle large files without loading all into memory
- Clean and validate CSV data
- Debug CSV parsing issues

---

### **Section 3: JSON Data Format** (~869 lines)

**What You'll Learn:**
- Parse JSON strings and files
- Convert Python objects to JSON
- Handle nested JSON structures
- Work with JSON APIs

**Key Topics:**

**JSON Basics:**
- What is JSON (JavaScript Object Notation)
- JSON data types: objects, arrays, strings, numbers, booleans, null
- Python equivalents: dict, list, str, int/float, bool, None
- Use cases: APIs, configuration, NoSQL databases

**Reading JSON:**
- **json.loads()**: Parse JSON string to Python object
  ```python
  import json
  data = json.loads('{"name": "João", "age": 30}')
  print(data['name'])  # Access as dictionary
  ```

- **json.load()**: Read JSON from file
  ```python
  with open('data.json') as f:
      data = json.load(f)
  ```

**Writing JSON:**
- **json.dumps()**: Convert Python to JSON string
  ```python
  data = {"name": "Maria", "age": 25}
  json_string = json.dumps(data, indent=2)  # Pretty print
  ```

- **json.dump()**: Write Python object to JSON file
  ```python
  with open('output.json', 'w') as f:
      json.dump(data, f, indent=2)
  ```

**Advanced JSON:**
- Handle nested structures (lists of dicts, nested dicts)
- Pretty printing with `indent` parameter
- `ensure_ascii=False` for non-English characters
- Custom serialization for dates and custom objects
- JSON validation and schema checking
- Handling large JSON files

**Real-World Examples:**
- API response processing
- Configuration file management
- NoSQL document storage
- Nested campsite data structures
- Converting CSV to JSON
- JSON to CSV flattening

**Practical Skills:**
- Parse JSON from APIs
- Build complex JSON structures
- Navigate nested JSON safely
- Convert between JSON and Python objects
- Debug JSON parsing errors
- Format JSON for readability

---

### **Section 4: Parquet Files** (~389 lines)

**What You'll Learn:**
- Understand columnar storage format
- Read and write Parquet files
- Choose compression strategies
- Optimize for analytics workloads

**Key Topics:**

**Why Parquet?**
- **Columnar storage**: Fast analytics queries
- **Compression**: 10x smaller than CSV
- **Type safety**: Preserves data types
- **Metadata**: Schema included in file
- **Industry standard**: Hadoop, Spark, data warehouses
- **Fast reads**: Only read columns you need

**Reading Parquet:**
```python
import pyarrow.parquet as pq
import pandas as pd

# Read with pyarrow
table = pq.read_table('data.parquet')
df = table.to_pandas()

# Or directly with pandas
df = pd.read_parquet('data.parquet')
```

**Writing Parquet:**
```python
import pandas as pd

df = pd.DataFrame({
    'name': ['Ana', 'Bruno', 'Carlos'],
    'age': [25, 30, 35],
    'city': ['Rio', 'SP', 'BH']
})

# Write with compression
df.to_parquet('output.parquet', compression='snappy')
```

**Compression Options:**
- **snappy**: Fast compression (default)
- **gzip**: Better compression ratio
- **brotli**: Best compression, slower
- **none**: No compression, fastest

**Advanced Parquet:**
- Partitioned Parquet (by date, category)
- Schema evolution
- Reading specific columns only
- Predicate pushdown for filtering
- Converting CSV/JSON to Parquet
- Parquet in cloud storage (S3, GCS)

**Real-World Applications:**
- Data lake storage
- Analytics optimization
- ETL pipeline output
- Data archival
- Efficient data sharing

**Practical Skills:**
- Convert CSV to Parquet for efficiency
- Choose appropriate compression
- Read only needed columns
- Partition data for performance
- Work with Spark/Pandas Parquet files

---

### **Section 5: Context Managers and the `with` Statement** (~479 lines)

**What You'll Learn:**
- Use `with` statement for resource management
- Understand automatic cleanup
- Create custom context managers
- Handle files safely

**Key Topics:**

**The Problem:**
```python
# BAD: File might not close if error occurs
f = open('data.csv')
data = f.read()
# If error here, file never closes!
f.close()
```

**The Solution:**
```python
# GOOD: File always closes
with open('data.csv') as f:
    data = f.read()
# File closed automatically here
```

**How `with` Works:**
- Calls `__enter__()` when entering block
- Calls `__exit__()` when leaving block (even on error)
- Guarantees cleanup code runs
- Prevents resource leaks

**Built-in Context Managers:**
- File objects: `open()`
- Database connections
- Network sockets
- Thread locks
- Temporary files

**Multiple Context Managers:**
```python
# Open multiple files safely
with open('input.csv') as infile, open('output.csv', 'w') as outfile:
    # Both files close automatically
    pass
```

**Creating Custom Context Managers:**
- **Class-based**: Implement `__enter__` and `__exit__`
- **Function-based**: Use `@contextmanager` decorator
- **Use cases**: Timers, database transactions, logging

**Real-World Examples:**
- Database connection pooling
- Transaction management
- Temporary file creation
- Performance timing
- Resource acquisition

**Practical Skills:**
- Always use `with` for file operations
- Handle multiple resources cleanly
- Create reusable context managers
- Ensure proper cleanup
- Prevent resource leaks

---

### **Section 6: Practice Exercises** (~799 lines)

**What You'll Learn:**
- Apply all file handling concepts
- Build complete data processing scripts
- Handle real-world data scenarios
- Debug file operation issues

**Practice Problems:**

**Exercise 1: CSV to JSON Converter**
- Read CSV file with campsites data
- Convert to JSON format
- Handle missing values
- Write formatted JSON output
- Complete solution provided

**Exercise 2: Data Aggregation**
- Read sales data from CSV
- Group by category
- Calculate totals and averages
- Write summary to JSON
- Handle edge cases

**Exercise 3: File Format Converter**
- Read CSV campsite data
- Write to Parquet format
- Compare file sizes
- Read Parquet back
- Verify data integrity

**Exercise 4: Multi-File Processor**
- Process multiple CSV files
- Merge data from different sources
- Clean and validate
- Output single Parquet file
- Error handling

**Exercise 5: Configuration Manager**
- Read JSON configuration
- Validate required fields
- Apply defaults for missing values
- Write updated config
- Handle malformed JSON

**Each Exercise Includes:**
- Clear problem statement
- Input data samples
- Expected output format
- Hints and approach
- Complete working solution
- Alternative implementations
- Common pitfalls to avoid

**Practical Skills:**
- Build complete file processing pipelines
- Handle multiple file formats
- Validate and clean real data
- Debug file I/O errors
- Write production-quality code

---

## 🛠️ Technical Requirements

**Python Version:**
- Python 3.8+ (examples use 3.10+ features)

**Required Libraries:**
```bash
# Standard library (included)
import csv
import json
from pathlib import Path

# Install these
pip install pyarrow==14.0.0      # Parquet support
pip install pandas==2.1.3        # Data manipulation (optional)
```

**System Requirements:**
- Any operating system (Windows, macOS, Linux)
- 500MB free disk space for practice files
- Text editor or IDE

**Project Structure:**
```
lesson_02/
├── data/
│   ├── campsites.csv
│   ├── config.json
│   └── output.parquet
├── scripts/
│   ├── csv_reader.py
│   ├── json_processor.py
│   └── parquet_converter.py
└── exercises/
    └── solutions.py
```

---

## 📖 How to Use This Lesson

### **Recommended Approach:**

1. **Read Sequentially** - Sections build on each other
2. **Create Practice Files** - Make sample CSV and JSON files
3. **Type Every Example** - Build muscle memory
4. **Break Things** - Try invalid files to see errors
5. **Complete Exercises** - Apply concepts to real problems

### **Study Schedule:**

**Day 1: Paths & CSV (Sections 1-2)**
- Morning: pathlib basics and path operations
- Afternoon: CSV reading with csv.reader and csv.DictReader
- Practice: Read and filter CSV files

**Day 2: JSON (Section 3)**
- Morning: JSON basics and parsing
- Afternoon: Writing JSON, nested structures
- Practice: Convert CSV to JSON

**Day 3: Parquet & Context Managers (Sections 4-5)**
- Morning: Parquet format and benefits
- Afternoon: Context managers and resource management
- Practice: Convert files to Parquet

**Day 4: Practice & Review (Section 6)**
- Morning: Exercises 1-3
- Afternoon: Exercises 4-5
- Evening: Review and build personal project

### **For Quick Reference:**

Jump to specific sections when you need to:
- **Handle file paths?** → Section 1
- **Read CSV files?** → Section 2
- **Parse JSON?** → Section 3
- **Use Parquet?** → Section 4
- **Manage resources?** → Section 5
- **See complete examples?** → Section 6

---

## 💡 Key Takeaways

### **File Handling Principles:**

1. **Always Use pathlib**
   - Cross-platform by default
   - Readable path operations
   - Object-oriented approach
   - Type-safe path handling

2. **CSV is Universal**
   - Simplest interchange format
   - Use csv.DictReader for named access
   - Always specify encoding
   - Handle missing values explicitly

3. **JSON for Flexibility**
   - Perfect for nested data
   - API standard format
   - Human-readable when formatted
   - Easy Python integration

4. **Parquet for Performance**
   - 10x smaller than CSV
   - 100x faster analytics
   - Type safety built-in
   - Industry standard for big data

### **Best Practices:**

1. **Use Context Managers**
   - Always use `with` for files
   - Guarantees resource cleanup
   - Prevents file handle leaks
   - Works even when errors occur

2. **Validate Before Processing**
   - Check files exist before opening
   - Validate JSON structure
   - Handle malformed CSV gracefully
   - Log errors with context

3. **Choose the Right Format**
   - **CSV**: Simple, universal, human-readable
   - **JSON**: Nested data, APIs, configuration
   - **Parquet**: Large datasets, analytics, archival

4. **Process Large Files Efficiently**
   - Read line-by-line, don't load all
   - Use generators for memory efficiency
   - Stream processing when possible
   - Consider chunking for pandas

---

## 🎯 Real-World Applications

This lesson's skills are used daily in data engineering:

**Data Ingestion:**
- Reading CSV exports from databases
- Parsing JSON from REST APIs
- Loading Parquet from data lakes
- File watching and processing

**Data Transformation:**
- Converting CSV to Parquet for efficiency
- Flattening JSON to CSV for analysis
- Merging multiple CSV files
- Cleaning malformed data

**Data Storage:**
- Writing processed data to Parquet
- Saving configuration as JSON
- Exporting reports as CSV
- Archiving data efficiently

**Examples from Data Engineering:**
```python
# Read CSV, clean, write Parquet
import pandas as pd
from pathlib import Path

data_dir = Path('data')
csv_file = data_dir / 'raw_data.csv'

# Read and clean
df = pd.read_csv(csv_file)
df = df.dropna()  # Remove null rows
df['date'] = pd.to_datetime(df['date'])  # Parse dates

# Write compressed Parquet
output = data_dir / 'cleaned_data.parquet'
df.to_parquet(output, compression='snappy')

# Parquet is 10x smaller and 100x faster to query!
```

---

## ✅ Self-Assessment Checklist

After completing this lesson, you should be able to:

### **File Paths:**
- [ ] Use pathlib for all path operations
- [ ] Join paths with `/` operator
- [ ] Check file/directory existence
- [ ] Create directories safely
- [ ] Navigate relative and absolute paths

### **CSV Files:**
- [ ] Read CSV with csv.DictReader
- [ ] Write CSV with headers
- [ ] Handle different delimiters
- [ ] Process large CSV files efficiently
- [ ] Clean and validate CSV data

### **JSON:**
- [ ] Parse JSON strings with json.loads()
- [ ] Read JSON files with json.load()
- [ ] Write formatted JSON with indent
- [ ] Handle nested JSON structures
- [ ] Convert between JSON and Python objects

### **Parquet:**
- [ ] Explain columnar storage benefits
- [ ] Read Parquet with pyarrow/pandas
- [ ] Write DataFrames to Parquet
- [ ] Choose appropriate compression
- [ ] Convert CSV to Parquet

### **Context Managers:**
- [ ] Always use `with` for file operations
- [ ] Understand resource management
- [ ] Handle multiple files safely
- [ ] Create custom context managers
- [ ] Prevent resource leaks

### **Practice:**
- [ ] Complete all 5 practice exercises
- [ ] Build CSV to JSON converter
- [ ] Create Parquet conversion pipeline
- [ ] Handle real-world data scenarios
- [ ] Debug file operation errors

---

## 🚀 Next Steps

### **After This Lesson:**

1. **Move to Lesson 3: Database Connectivity**
   - Apply file skills to database operations
   - Load CSV/JSON into databases
   - Export query results to files
   - Build complete ETL pipelines

2. **Build Projects:**
   - CSV data cleaner
   - JSON API consumer
   - Parquet converter utility
   - Multi-file data merger

3. **Explore Advanced Topics:**
   - Streaming large files
   - Parallel file processing
   - Data validation frameworks
   - Schema management

4. **Practice More:**
   - Process real datasets from Kaggle
   - Build command-line file tools
   - Create data quality checkers
   - Optimize file processing performance

---

## 📚 Additional Resources

### **Official Documentation:**
- [Python pathlib](https://docs.python.org/3/library/pathlib.html)
- [Python csv module](https://docs.python.org/3/library/csv.html)
- [Python json module](https://docs.python.org/3/library/json.html)
- [PyArrow Parquet](https://arrow.apache.org/docs/python/parquet.html)
- [Context Managers](https://docs.python.org/3/reference/datamodel.html#context-managers)

### **Recommended Reading:**
- "Python for Data Analysis" by Wes McKinney (Pandas creator)
- "Data Wrangling with Python" by Jacqueline Kazil
- "Effective Python" by Brett Slatkin (Item on context managers)

### **Tools & Libraries:**
- pandas: DataFrame operations
- polars: Fast alternative to pandas
- dask: Parallel processing
- vaex: Out-of-core DataFrames

---

## 🎓 Learning Verification

### **Quick Quiz:**

1. Why use pathlib instead of os.path?
2. What's the difference between csv.reader and csv.DictReader?
3. How do you pretty-print JSON in Python?
4. What are three benefits of Parquet over CSV?
5. Why always use `with` for file operations?
6. How do you handle JSON parsing errors?

**Answers are throughout the lesson!**

---

## 💬 Need Help?

**Common Issues:**
- **FileNotFoundError**: Check path with pathlib, use absolute paths
- **CSV parsing errors**: Check delimiter, encoding (UTF-8 vs Latin-1)
- **JSON decode error**: Validate JSON with online tools first
- **Parquet import error**: `pip install pyarrow`
- **File not closing**: Always use `with` statement

---

## 🎉 Congratulations!

You've mastered file handling and data formats! These skills are essential for every data engineering task.

**You now know how to:**
- Handle file paths like a pro with pathlib
- Read and write CSV files efficiently
- Parse and create JSON structures
- Use Parquet for performance
- Manage resources safely with context managers
- Build complete file processing pipelines

**Remember:**
- pathlib makes paths cross-platform
- CSV for simple data, JSON for nested, Parquet for performance
- Always use `with` for files
- Validate data before processing

**Keep coding, keep learning!** 🚀

---

**Ready to dive in?**  
**→ [Open 02_files_data_formats.md](02_files_data_formats.md) and master file handling!**

---

*Last Updated: October 20, 2025*  
*Total Content: 3,211 lines of comprehensive instruction*  
*File Formats Covered: CSV, JSON, Parquet*

