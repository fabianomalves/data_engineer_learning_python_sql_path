"""
Pandas Basics - Essential Operations for Data Engineers
"""

import pandas as pd
import numpy as np

# Creating DataFrames
print("=" * 50)
print("Creating DataFrames")
print("=" * 50)

# From dictionary
data = {
    'name': ['Alice', 'Bob', 'Charlie', 'David', 'Eve'],
    'age': [25, 30, 35, 28, 32],
    'city': ['New York', 'San Francisco', 'Los Angeles', 'Chicago', 'Boston'],
    'salary': [70000, 85000, 90000, 75000, 80000]
}
df = pd.DataFrame(data)
print("\nDataFrame from dictionary:")
print(df)

# Basic information
print("\n" + "=" * 50)
print("Basic DataFrame Information")
print("=" * 50)
print("\nShape:", df.shape)
print("\nColumns:", df.columns.tolist())
print("\nData types:")
print(df.dtypes)
print("\nBasic statistics:")
print(df.describe())

# Selecting data
print("\n" + "=" * 50)
print("Selecting Data")
print("=" * 50)

# Select a column
print("\nNames column:")
print(df['name'])

# Select multiple columns
print("\nNames and ages:")
print(df[['name', 'age']])

# Select rows by condition
print("\nPeople older than 30:")
print(df[df['age'] > 30])

# Multiple conditions
print("\nPeople older than 30 with salary > 80000:")
print(df[(df['age'] > 30) & (df['salary'] > 80000)])

# Sorting
print("\n" + "=" * 50)
print("Sorting Data")
print("=" * 50)

print("\nSorted by age (ascending):")
print(df.sort_values('age'))

print("\nSorted by salary (descending):")
print(df.sort_values('salary', ascending=False))

# Adding new columns
print("\n" + "=" * 50)
print("Adding New Columns")
print("=" * 50)

df['monthly_salary'] = df['salary'] / 12
df['senior'] = df['age'] > 30
print(df)

# Grouping and aggregation
print("\n" + "=" * 50)
print("Grouping and Aggregation")
print("=" * 50)

# Group by senior status
print("\nAverage salary by senior status:")
print(df.groupby('senior')['salary'].mean())

# Multiple aggregations
print("\nMultiple statistics by senior status:")
print(df.groupby('senior')['salary'].agg(['mean', 'min', 'max', 'count']))

# Handling missing data
print("\n" + "=" * 50)
print("Handling Missing Data")
print("=" * 50)

# Create DataFrame with missing values
df_missing = pd.DataFrame({
    'A': [1, 2, np.nan, 4],
    'B': [5, np.nan, np.nan, 8],
    'C': [9, 10, 11, 12]
})

print("\nDataFrame with missing values:")
print(df_missing)

print("\nCheck for missing values:")
print(df_missing.isnull())

print("\nCount of missing values per column:")
print(df_missing.isnull().sum())

print("\nDrop rows with any missing values:")
print(df_missing.dropna())

print("\nFill missing values with 0:")
print(df_missing.fillna(0))

print("\nFill missing values with column mean:")
print(df_missing.fillna(df_missing.mean()))

# Merging DataFrames
print("\n" + "=" * 50)
print("Merging DataFrames")
print("=" * 50)

# Create two DataFrames
df1 = pd.DataFrame({
    'employee_id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
    'department': ['Sales', 'IT', 'HR']
})

df2 = pd.DataFrame({
    'employee_id': [1, 2, 4],
    'salary': [70000, 85000, 75000]
})

print("\nDataFrame 1:")
print(df1)
print("\nDataFrame 2:")
print(df2)

print("\nInner join:")
print(pd.merge(df1, df2, on='employee_id', how='inner'))

print("\nLeft join:")
print(pd.merge(df1, df2, on='employee_id', how='left'))

print("\nOuter join:")
print(pd.merge(df1, df2, on='employee_id', how='outer'))

# Apply functions
print("\n" + "=" * 50)
print("Applying Functions")
print("=" * 50)

# Apply function to a column
df['name_length'] = df['name'].apply(len)
print("\nAdded name length column:")
print(df[['name', 'name_length']])

# Apply custom function
def categorize_salary(salary):
    if salary < 75000:
        return 'Low'
    elif salary < 85000:
        return 'Medium'
    else:
        return 'High'

df['salary_category'] = df['salary'].apply(categorize_salary)
print("\nSalary categories:")
print(df[['name', 'salary', 'salary_category']])

print("\n" + "=" * 50)
print("String Operations")
print("=" * 50)

# String methods
df['name_upper'] = df['name'].str.upper()
df['city_lower'] = df['city'].str.lower()
print("\nString transformations:")
print(df[['name', 'name_upper', 'city', 'city_lower']])

# Filtering with string methods
print("\nNames containing 'a':")
print(df[df['name'].str.contains('a', case=False)])
