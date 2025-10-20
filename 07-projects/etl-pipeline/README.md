# Project 1: E-commerce ETL Pipeline

## 📋 Project Overview

Build a production-ready ETL pipeline that processes e-commerce sales data from multiple sources, validates and transforms it, and loads it into a database for analytics.

## 🎯 Objectives

1. Extract data from multiple sources (CSV, JSON, API)
2. Implement data validation and quality checks
3. Transform data for analytics
4. Load data into a PostgreSQL database
5. Handle errors and edge cases
6. Implement logging and monitoring
7. Make the pipeline schedulable

## 📊 Data Sources

### Source 1: Orders CSV
Daily exports of order data:
```
order_id,customer_id,order_date,total_amount,status
1001,5001,2024-01-15,99.99,completed
1002,5002,2024-01-15,149.50,pending
```

### Source 2: Product Catalog API
REST API endpoint: `/api/products`
```json
{
  "products": [
    {
      "product_id": "P001",
      "name": "Laptop",
      "category": "Electronics",
      "price": 999.99
    }
  ]
}
```

### Source 3: Customer Data JSON
Customer information updates:
```json
{
  "customer_id": 5001,
  "name": "John Doe",
  "email": "john@example.com",
  "signup_date": "2023-01-10"
}
```

## 🏗️ Architecture

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│   Sources   │────▶│  ETL Process │────▶│   Database   │
└─────────────┘     └──────────────┘     └──────────────┘
     │                     │                      │
     ├─ CSV Files          ├─ Extract             ├─ PostgreSQL
     ├─ JSON Files         ├─ Transform           ├─ Staging Tables
     └─ REST API           ├─ Load                └─ Final Tables
                           └─ Validate
```

## 📁 Project Structure

```
etl-pipeline/
├── README.md
├── requirements.txt
├── config/
│   ├── config.yaml
│   └── logging_config.yaml
├── data/
│   ├── input/
│   │   ├── orders/
│   │   ├── customers/
│   │   └── products/
│   └── output/
├── src/
│   ├── __init__.py
│   ├── extract/
│   │   ├── __init__.py
│   │   ├── csv_extractor.py
│   │   ├── json_extractor.py
│   │   └── api_extractor.py
│   ├── transform/
│   │   ├── __init__.py
│   │   ├── data_cleaner.py
│   │   ├── data_validator.py
│   │   └── data_transformer.py
│   ├── load/
│   │   ├── __init__.py
│   │   └── database_loader.py
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── logger.py
│   │   ├── db_connection.py
│   │   └── config_loader.py
│   └── pipeline.py
├── tests/
│   ├── __init__.py
│   ├── test_extract.py
│   ├── test_transform.py
│   ├── test_load.py
│   └── test_pipeline.py
├── sql/
│   ├── schema.sql
│   └── queries.sql
└── main.py
```

## 🔧 Technical Requirements

### Required Software
- Python 3.8+
- PostgreSQL 12+
- Git

### Python Libraries
```
pandas>=1.3.0
sqlalchemy>=1.4.0
psycopg2-binary>=2.9.0
requests>=2.26.0
pyyaml>=5.4.0
python-dotenv>=0.19.0
pytest>=7.0.0
```

## 📝 Implementation Steps

### Phase 1: Setup (Week 1)
- [ ] Set up project structure
- [ ] Install dependencies
- [ ] Set up database
- [ ] Create configuration files
- [ ] Set up logging

### Phase 2: Extract (Week 1-2)
- [ ] Implement CSV extractor
- [ ] Implement JSON extractor
- [ ] Implement API extractor
- [ ] Handle extraction errors
- [ ] Write extraction tests

### Phase 3: Transform (Week 2-3)
- [ ] Implement data validation
- [ ] Implement data cleaning
- [ ] Implement transformations
- [ ] Add data quality checks
- [ ] Write transformation tests

### Phase 4: Load (Week 3)
- [ ] Create database schema
- [ ] Implement database loader
- [ ] Handle loading errors
- [ ] Implement upsert logic
- [ ] Write loading tests

### Phase 5: Integration (Week 4)
- [ ] Connect all components
- [ ] Implement orchestration
- [ ] Add comprehensive logging
- [ ] Handle end-to-end errors
- [ ] Write integration tests

### Phase 6: Production Ready (Week 4)
- [ ] Add configuration management
- [ ] Implement monitoring
- [ ] Add scheduling capability
- [ ] Create documentation
- [ ] Performance optimization

## 🧪 Testing Strategy

### Unit Tests
Test individual components:
- Extractors
- Transformers
- Loaders
- Utilities

### Integration Tests
Test component interactions:
- Extract → Transform
- Transform → Load
- End-to-end pipeline

### Data Quality Tests
Validate data:
- Schema validation
- Data type checks
- Null value checks
- Duplicate detection
- Business rule validation

## 📊 Database Schema

### Staging Tables
```sql
CREATE TABLE staging_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_date VARCHAR(50),
    total_amount VARCHAR(50),
    status VARCHAR(50),
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Final Tables
```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    signup_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔍 Data Quality Checks

1. **Completeness**: All required fields present
2. **Validity**: Data types and formats correct
3. **Consistency**: Cross-field validation
4. **Accuracy**: Values within expected ranges
5. **Uniqueness**: No duplicate keys
6. **Timeliness**: Data is current

## 📈 Monitoring and Logging

### Log Levels
- **INFO**: Pipeline start/stop, phase transitions
- **WARNING**: Data quality issues, missing data
- **ERROR**: Processing failures
- **DEBUG**: Detailed processing information

### Metrics to Track
- Records processed
- Records failed
- Processing time
- Data quality scores
- Error rates

## 🚀 Running the Pipeline

### Setup
```bash
# Clone repository
git clone <repo-url>
cd etl-pipeline

# Create virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies
pip install -r requirements.txt

# Set up database
psql -U postgres -f sql/schema.sql

# Configure
cp config/config.example.yaml config/config.yaml
# Edit config.yaml with your settings
```

### Execution
```bash
# Run full pipeline
python main.py

# Run specific phase
python main.py --phase extract
python main.py --phase transform
python main.py --phase load

# Run with date range
python main.py --start-date 2024-01-01 --end-date 2024-01-31

# Dry run (no database writes)
python main.py --dry-run
```

## 📖 Documentation Requirements

1. **README**: Project overview and setup
2. **Architecture Diagram**: System design
3. **API Documentation**: If creating APIs
4. **Configuration Guide**: How to configure
5. **Troubleshooting**: Common issues and solutions
6. **Code Comments**: Inline documentation

## 🎯 Success Criteria

- [ ] Pipeline processes all three data sources
- [ ] Data quality checks are implemented
- [ ] Errors are handled gracefully
- [ ] Logging provides adequate information
- [ ] Tests achieve >80% coverage
- [ ] Documentation is complete
- [ ] Code follows Python best practices
- [ ] Pipeline runs without manual intervention

## 🌟 Bonus Features

- **Incremental Loading**: Only process new/changed data
- **Parallel Processing**: Process multiple files simultaneously
- **Email Notifications**: Alert on failures
- **Dashboard**: Visualize pipeline metrics
- **Containerization**: Package in Docker
- **Cloud Deployment**: Deploy to AWS/GCP/Azure

## 📚 Resources

- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Pandas Data Validation](https://pandas.pydata.org/docs/user_guide/indexing.html)
- [Python Logging Best Practices](https://docs.python.org/3/howto/logging.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## 🤝 Getting Help

- Review previous lessons on ETL
- Check Stack Overflow for specific errors
- Refer to library documentation
- Ask in data engineering communities

## 📝 Submission Guidelines

When completed, your repository should include:
1. All source code
2. Requirements file
3. Database schema
4. Sample data (or data generator)
5. Test suite
6. Complete documentation
7. Demo video (optional)

Good luck building your ETL pipeline!
