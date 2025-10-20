# Brazilian Outdoor Adventure Platform - Project Overview

**Project Type**: Data Engineering Capstone Project  
**Technologies**: PostgreSQL, Python, Apache Airflow, APIs, DuckDB  
**Duration**: 4-6 weeks (spread across the course)  
**Difficulty**: Beginner to Advanced

---

## 🎯 **Project Goal**

Build a complete end-to-end data platform that aggregates outdoor adventure information across Brazil, including:
- Camping locations and pricing
- Hiking trails and difficulty ratings
- Mountain climbing routes
- Weather data for outdoor locations
- Outdoor gear pricing and reviews
- Seasonal recommendations

---

## 📊 **Business Problem**

**Scenario**: You're building a data platform for "Aventura Brasil" - a startup helping outdoor enthusiasts plan trips across Brazil.

**User Needs**:
1. Find affordable camping spots with desired amenities
2. Discover trails matching their skill level
3. Check weather patterns for planning
4. Compare gear prices across Brazilian retailers
5. Read authentic reviews from other adventurers
6. Get seasonal recommendations for different regions

**Data Sources**:
1. **Internal Database**: Locations, trails, campsites (PostgreSQL)
2. **Weather APIs**: Current and historical weather data
3. **E-commerce APIs**: Gear pricing from Brazilian retailers
4. **User Reviews**: Aggregated from multiple platforms

---

## 🏗️ **Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────┐
│                     DATA SOURCES                                 │
├─────────────────────────────────────────────────────────────────┤
│  Weather APIs  │  E-commerce APIs  │  Review Sites  │  Manual   │
│  (OpenWeather) │  (Decathlon, etc) │  (Aggregated)  │  (CSV)    │
└────────┬────────────────┬────────────────┬────────────┬──────────┘
         │                │                │            │
         │                │                │            │
┌────────▼────────────────▼────────────────▼────────────▼──────────┐
│                   INGESTION LAYER                                 │
│              (Apache Airflow DAGs)                                │
├───────────────────────────────────────────────────────────────────┤
│  • Weather Data Collector (Daily)                                │
│  • Gear Price Scraper (Weekly)                                   │
│  • Review Aggregator (Daily)                                     │
│  • Data Quality Checks                                           │
└────────┬──────────────────────────────────────────────────────────┘
         │
         │
┌────────▼──────────────────────────────────────────────────────────┐
│                   STORAGE LAYER                                    │
├────────────────────────────────────────────────────────────────────┤
│  PostgreSQL (Primary Database)                                    │
│  • Structured data (locations, trails, campsites)                 │
│  • Transactional data                                             │
│                                                                    │
│  DuckDB (Analytics)                                               │
│  • Fast analytical queries                                        │
│  • Data exploration                                               │
│                                                                    │
│  Parquet Files (Data Lake)                                        │
│  • Historical weather data                                        │
│  • Price history                                                  │
└────────┬──────────────────────────────────────────────────────────┘
         │
         │
┌────────▼──────────────────────────────────────────────────────────┐
│                 PROCESSING LAYER                                  │
│              (Python, Pandas, Polars)                             │
├────────────────────────────────────────────────────────────────────┤
│  • Data Transformation                                            │
│  • Aggregations and Analytics                                    │
│  • ML-based Recommendations (future)                             │
└────────┬──────────────────────────────────────────────────────────┘
         │
         │
┌────────▼──────────────────────────────────────────────────────────┐
│                   OUTPUT LAYER                                     │
├────────────────────────────────────────────────────────────────────┤
│  • SQL Views for Analytics                                        │
│  • REST API (FastAPI - future)                                   │
│  • CSV/JSON Exports                                               │
│  • Dashboards (future)                                           │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📁 **Project Structure**

```
brazilian_outdoor_platform/
├── README.md                          # This file
├── config/
│   ├── database.yaml                  # Database configuration
│   ├── api_keys.yaml.example          # API credentials template
│   └── airflow.cfg                    # Airflow configuration
├── dags/
│   ├── weather_data_pipeline.py       # Daily weather data collection
│   ├── gear_price_pipeline.py         # Weekly gear price updates
│   ├── review_aggregation_pipeline.py # Review data collection
│   └── data_quality_checks.py         # Data validation DAG
├── src/
│   ├── extractors/
│   │   ├── weather_api.py             # Weather API client
│   │   ├── ecommerce_scraper.py       # Gear price scraping
│   │   └── review_collector.py        # Review aggregation
│   ├── transformers/
│   │   ├── weather_transformer.py     # Weather data transformation
│   │   ├── price_transformer.py       # Price normalization
│   │   └── text_processor.py          # Review text processing
│   ├── loaders/
│   │   ├── postgres_loader.py         # PostgreSQL data loader
│   │   ├── duckdb_loader.py           # DuckDB data loader
│   │   └── parquet_writer.py          # Parquet file writer
│   ├── utils/
│   │   ├── database.py                # Database connection utilities
│   │   ├── logging_config.py          # Logging setup
│   │   └── validators.py              # Data quality validators
│   └── analytics/
│       ├── seasonal_analysis.py       # Season recommendations
│       ├── price_trends.py            # Price trend analysis
│       └── trail_recommender.py       # Trail recommendation engine
├── sql/
│   ├── views/
│   │   ├── best_camping_deals.sql     # Affordable camping options
│   │   ├── weather_patterns.sql       # Historical weather analysis
│   │   └── gear_price_comparison.sql  # Multi-store price comparison
│   └── queries/
│       ├── analytics_queries.sql      # Common analytical queries
│       └── reporting_queries.sql      # Business reporting
├── tests/
│   ├── test_extractors.py             # Test data extraction
│   ├── test_transformers.py           # Test transformations
│   ├── test_loaders.py                # Test data loading
│   └── test_data_quality.py           # Data quality tests
├── notebooks/
│   ├── 01_data_exploration.ipynb      # Initial data exploration
│   ├── 02_weather_analysis.ipynb      # Weather pattern analysis
│   ├── 03_price_trends.ipynb          # Gear price trends
│   └── 04_recommendations.ipynb       # Recommendation development
├── data/
│   ├── raw/                           # Raw data from APIs
│   ├── processed/                     # Transformed data
│   └── exports/                       # Final exports
├── docs/
│   ├── architecture.md                # Detailed architecture
│   ├── api_documentation.md           # API endpoints documentation
│   └── deployment_guide.md            # Production deployment
├── requirements.txt                   # Python dependencies
└── .env.example                       # Environment variables template
```

---

## 🚀 **Implementation Phases**

### **Phase 1: Foundation (Weeks 1-2)**
**Goal**: Set up database and basic data model

**Tasks**:
- ✅ Design database schema (COMPLETED)
- ✅ Create PostgreSQL tables (COMPLETED)
- ✅ Load initial sample data (COMPLETED)
- ✅ Write basic SQL queries
- [ ] Create database connection utilities in Python

**Deliverables**:
- Working PostgreSQL database
- Python connection module
- Basic CRUD operations

---

### **Phase 2: Data Ingestion (Week 3)**
**Goal**: Build data collection pipelines

**Tasks**:
- [ ] Integrate weather API (OpenWeatherMap or similar)
- [ ] Build e-commerce price scraper
- [ ] Create data validation functions
- [ ] Implement error handling and logging
- [ ] Write to PostgreSQL from Python

**Deliverables**:
- Weather data collector script
- Price scraper for Brazilian retailers
- Data quality checks

---

### **Phase 3: Airflow Orchestration (Week 4)**
**Goal**: Automate data pipelines

**Tasks**:
- [ ] Set up Apache Airflow locally
- [ ] Create weather data DAG (daily runs)
- [ ] Create gear price DAG (weekly runs)
- [ ] Implement retry logic and alerts
- [ ] Add data quality DAG

**Deliverables**:
- 3+ production-ready Airflow DAGs
- Monitoring and alerting setup
- Documentation for each pipeline

---

### **Phase 4: Analytics & Transformation (Week 5)**
**Goal**: Process data for insights

**Tasks**:
- [ ] Create analytical SQL views
- [ ] Build seasonal recommendation logic
- [ ] Price trend analysis
- [ ] Weather pattern detection
- [ ] Generate reports

**Deliverables**:
- SQL views for common queries
- Python analytics scripts
- Automated reports

---

### **Phase 5: Advanced Features (Week 6)**
**Goal**: Add production-ready features

**Tasks**:
- [ ] Implement DuckDB for fast analytics
- [ ] Add data export functionality
- [ ] Create Jupyter notebooks for exploration
- [ ] Write comprehensive tests
- [ ] Performance optimization

**Deliverables**:
- DuckDB integration
- Test coverage >80%
- Performance benchmarks
- User documentation

---

## 📊 **Key Metrics & KPIs**

### **Data Pipeline Health**
- Pipeline success rate (target: >95%)
- Average execution time
- Data freshness (how recent is data)
- Error rate per pipeline

### **Data Quality**
- Completeness (% of expected records)
- Accuracy (validated against sources)
- Consistency (cross-table validation)
- Timeliness (data lag)

### **Business Metrics**
- Number of locations tracked
- Weather data points collected
- Gear items monitored
- User reviews aggregated
- Query performance (avg response time)

---

## 🛠️ **Technologies Used**

| Technology | Purpose | Why This? |
|------------|---------|-----------|
| **PostgreSQL** | Primary database | Industry standard, ACID compliance, complex queries |
| **Apache Airflow** | Workflow orchestration | Standard for data pipelines, robust scheduling |
| **Python** | Processing language | Data ecosystem, extensive libraries |
| **Pandas** | Data manipulation | Standard for data wrangling |
| **Polars** | Fast data processing | High performance alternative to Pandas |
| **DuckDB** | Analytics database | Fast analytical queries on files |
| **Pytest** | Testing framework | Industry standard Python testing |
| **SQLAlchemy** | Database ORM | Python database abstraction |
| **Requests** | HTTP library | API calls and web scraping |

---

## 📚 **Learning Objectives**

By completing this project, you'll learn:

1. **Database Design**
   - Normalization and schema design
   - Indexing for performance
   - Complex SQL queries

2. **Data Engineering**
   - ETL/ELT pipeline design
   - Data quality validation
   - Error handling and retries

3. **Workflow Orchestration**
   - Airflow DAG creation
   - Task dependencies
   - Scheduling and monitoring

4. **API Integration**
   - RESTful API consumption
   - Rate limiting and throttling
   - Authentication handling

5. **Data Processing**
   - Data transformation patterns
   - Aggregation and analytics
   - Performance optimization

6. **Software Engineering**
   - Code organization
   - Testing strategies
   - Documentation practices

---

## 🎯 **Next Steps**

Ready to begin? Start with:

1. **Review the database schema** - `database/setup_schema.sql`
2. **Explore sample data** - Run queries from Module 1 lessons
3. **Set up development environment** - Follow `docs/setup_guides/local_environment_setup.md`
4. **Begin Phase 1** - Create Python database utilities

---

## 📖 **Additional Resources**

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Apache Airflow Docs](https://airflow.apache.org/docs/)
- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Python Data Engineering Best Practices](https://docs.python.org/)

---

**Let's build something amazing! 🏔️🏕️⛰️**
