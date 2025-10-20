"""
Simple ETL Pipeline Example
Demonstrates Extract, Transform, Load process
"""

import csv
import sqlite3
from datetime import datetime


def extract_data(csv_file):
    """
    Extract data from CSV file
    
    Args:
        csv_file: Path to CSV file
        
    Returns:
        List of dictionaries containing the data
    """
    print(f"[{datetime.now()}] Extracting data from {csv_file}...")
    data = []
    
    try:
        with open(csv_file, 'r') as file:
            csv_reader = csv.DictReader(file)
            for row in csv_reader:
                data.append(row)
        print(f"[{datetime.now()}] Extracted {len(data)} records")
        return data
    except FileNotFoundError:
        print(f"Error: File {csv_file} not found")
        return []


def transform_data(data):
    """
    Transform and clean the data
    
    Args:
        data: List of dictionaries to transform
        
    Returns:
        Transformed data
    """
    print(f"[{datetime.now()}] Transforming data...")
    transformed = []
    
    for record in data:
        # Example transformations
        transformed_record = {
            'id': int(record.get('id', 0)),
            'name': record.get('name', '').strip().title(),
            'email': record.get('email', '').strip().lower(),
            'age': int(record.get('age', 0)) if record.get('age') else None,
            'city': record.get('city', '').strip().title(),
            'processed_date': datetime.now().strftime('%Y-%m-%d')
        }
        
        # Data quality checks
        if transformed_record['email'] and '@' in transformed_record['email']:
            transformed.append(transformed_record)
        else:
            print(f"Skipping invalid record: {record}")
    
    print(f"[{datetime.now()}] Transformed {len(transformed)} valid records")
    return transformed


def load_data(data, db_name='etl_output.db'):
    """
    Load data into SQLite database
    
    Args:
        data: List of dictionaries to load
        db_name: Name of the database file
    """
    print(f"[{datetime.now()}] Loading data into database...")
    
    # Connect to database (creates if doesn't exist)
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()
    
    # Create table if it doesn't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            age INTEGER,
            city TEXT,
            processed_date TEXT
        )
    ''')
    
    # Insert data
    inserted = 0
    for record in data:
        try:
            cursor.execute('''
                INSERT OR REPLACE INTO users (id, name, email, age, city, processed_date)
                VALUES (?, ?, ?, ?, ?, ?)
            ''', (
                record['id'],
                record['name'],
                record['email'],
                record['age'],
                record['city'],
                record['processed_date']
            ))
            inserted += 1
        except sqlite3.Error as e:
            print(f"Error inserting record {record['id']}: {e}")
    
    conn.commit()
    conn.close()
    
    print(f"[{datetime.now()}] Loaded {inserted} records into database")


def run_etl_pipeline(source_file, target_db='etl_output.db'):
    """
    Run the complete ETL pipeline
    
    Args:
        source_file: Path to source CSV file
        target_db: Name of target database
    """
    print(f"\n{'='*50}")
    print("Starting ETL Pipeline")
    print(f"{'='*50}\n")
    
    start_time = datetime.now()
    
    # Extract
    raw_data = extract_data(source_file)
    
    if not raw_data:
        print("No data to process. Exiting.")
        return
    
    # Transform
    clean_data = transform_data(raw_data)
    
    # Load
    load_data(clean_data, target_db)
    
    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()
    
    print(f"\n{'='*50}")
    print(f"ETL Pipeline Completed in {duration:.2f} seconds")
    print(f"{'='*50}\n")


if __name__ == "__main__":
    # Example usage
    # Create a sample CSV file first or replace with your file
    run_etl_pipeline('sample_data.csv')
