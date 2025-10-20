# Python for Data Engineering

This section focuses on using Python for data engineering tasks - the practical skills you'll use daily as a data engineer.

## 📚 What You'll Learn

- Working with Pandas for data manipulation
- Reading and writing various file formats (CSV, JSON, Parquet, Excel)
- API interactions and web scraping
- Data cleaning and transformation
- Working with dates and times
- Connecting to databases with Python
- Error handling in data pipelines

## 📖 Lessons

1. [Introduction to Pandas](lessons/01-pandas-intro.md)
2. [Data Cleaning](lessons/02-data-cleaning.md)
3. [File Formats](lessons/03-file-formats.md)
4. [Working with APIs](lessons/04-apis.md)
5. [Database Connections](lessons/05-database-connections.md)
6. [Date and Time Handling](lessons/06-datetime.md)
7. [Data Validation](lessons/07-data-validation.md)

## 💻 Examples

The `examples/` folder contains practical code examples:
- `pandas_basics.py` - Pandas fundamentals
- `csv_processing.py` - CSV file operations
- `json_handling.py` - Working with JSON
- `api_requests.py` - API interactions
- `database_operations.py` - Database connectivity

## ✏️ Exercises

Practice exercises in `exercises/` folder:
- Data cleaning challenges
- File format conversions
- API data extraction
- Database operations
- Real-world scenarios

## 🛠️ Required Libraries

```bash
# Install required packages
pip install pandas numpy
pip install requests
pip install openpyxl  # for Excel files
pip install pyarrow   # for Parquet files
pip install sqlalchemy psycopg2-binary
```

## ⏱️ Estimated Time

4-6 weeks with hands-on practice

## ✅ Completion Checklist

- [ ] Master Pandas basics
- [ ] Work with CSV, JSON, and Excel files
- [ ] Make API requests
- [ ] Connect to databases
- [ ] Clean and transform real datasets
- [ ] Handle errors properly
- [ ] Complete all exercises

## 🎯 Project Ideas

### Project 1: Data Pipeline
Build a pipeline that:
- Fetches data from an API
- Cleans and transforms the data
- Saves to database and CSV

### Project 2: Data Integration
Combine data from:
- Multiple CSV files
- JSON API
- Database tables
- Output: Clean, unified dataset

### Project 3: Automated Report
Create a script that:
- Reads data from database
- Performs analysis
- Generates Excel report
- Sends email notification

## 📊 Real-World Scenarios

### E-commerce Data Processing
- Process order data from CSV
- Validate customer information
- Calculate metrics
- Load into database

### API Data Extraction
- Fetch weather data from API
- Parse JSON responses
- Store in structured format
- Handle rate limits and errors

### Log File Analysis
- Read server log files
- Parse and extract information
- Identify patterns
- Generate reports

## 🔑 Key Skills

### Data Manipulation with Pandas
```python
import pandas as pd

# Read data
df = pd.read_csv('data.csv')

# Basic operations
df.head()
df.info()
df.describe()

# Filtering
df[df['age'] > 30]

# Grouping
df.groupby('category')['sales'].sum()

# Transformation
df['new_column'] = df['old_column'] * 2
```

### File Operations
```python
# CSV
df = pd.read_csv('file.csv')
df.to_csv('output.csv', index=False)

# JSON
df = pd.read_json('file.json')
df.to_json('output.json')

# Excel
df = pd.read_excel('file.xlsx')
df.to_excel('output.xlsx', index=False)

# Parquet
df = pd.read_parquet('file.parquet')
df.to_parquet('output.parquet')
```

### API Requests
```python
import requests

response = requests.get('https://api.example.com/data')
data = response.json()
df = pd.DataFrame(data)
```

### Database Operations
```python
from sqlalchemy import create_engine

engine = create_engine('postgresql://user:pass@localhost/db')
df = pd.read_sql('SELECT * FROM table', engine)
df.to_sql('new_table', engine, if_exists='replace')
```

## 💡 Best Practices

1. **Read Documentation**: Pandas docs are excellent
2. **Use Vectorization**: Avoid loops when possible
3. **Memory Management**: Be aware of large datasets
4. **Error Handling**: Always handle exceptions
5. **Data Validation**: Validate before processing
6. **Type Hints**: Use type hints in functions
7. **Testing**: Write tests for data transformations

## 📚 Additional Resources

- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Python Data Science Handbook](https://jakevdp.github.io/PythonDataScienceHandbook/)
- [Real Python - Pandas Tutorials](https://realpython.com/learning-paths/pandas-data-science/)
- [Kaggle Learn - Pandas](https://www.kaggle.com/learn/pandas)

## Common Pitfalls to Avoid

1. **Chained Indexing**: Use `.loc` instead
2. **Modifying During Iteration**: Use `.apply()` or vectorization
3. **Not Checking Data Types**: Always verify dtypes
4. **Ignoring Missing Data**: Handle NaN values properly
5. **Memory Issues**: Use chunking for large files
6. **Silent Failures**: Add logging and error handling

## Next Steps

After completing this section, you'll be able to:
- Build data ingestion pipelines
- Process various data formats
- Interact with APIs and databases
- Handle real-world data issues
- Write production-quality Python code for data engineering
