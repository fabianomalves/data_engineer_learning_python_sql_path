# Environment Setup Guide - Data Engineering Learning Path

**Last Updated**: October 2025  
**Estimated Time**: 1-2 hours

---

## 🎯 **Overview**

This guide will help you set up a complete local development environment for the Data Engineering course, including:
- PostgreSQL database
- Python 3.10+ with virtual environment
- Essential tools and editors
- Database sample data
- Verification steps

---

## 📋 **Prerequisites**

- **Operating System**: Ubuntu 20.04+, macOS 11+, or Windows 10+ with WSL2
- **RAM**: 8GB minimum (16GB recommended)
- **Disk Space**: 20GB free space
- **Internet**: For downloading packages and dependencies

---

## 🐧 **Part 1: PostgreSQL Installation**

### **Ubuntu/Debian**

```bash
# Update package list
sudo apt update

# Install PostgreSQL
sudo apt install postgresql postgresql-contrib postgresql-client

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check status
sudo systemctl status postgresql
```

### **macOS**

```bash
# Install via Homebrew
brew install postgresql@15

# Start PostgreSQL
brew services start postgresql@15

# Verify installation
psql --version
```

### **Windows (WSL2)**

```bash
# From WSL2 Ubuntu terminal
sudo apt update
sudo apt install postgresql postgresql-contrib

# Start service
sudo service postgresql start

# Auto-start on WSL boot (optional)
echo "sudo service postgresql start" >> ~/.bashrc
```

### **Verify Installation**

```bash
# Switch to postgres user
sudo -u postgres psql

# You should see PostgreSQL prompt:
# postgres=#

# Check version
SELECT version();

# Exit
\q
```

---

## 🗄️ **Part 2: Database Setup**

### **Step 1: Create Database and User**

```bash
# Switch to postgres user
sudo -u postgres psql

# Run these SQL commands:
```

```sql
-- Create database
CREATE DATABASE outdoor_adventure_br;

-- Create user with password
CREATE USER outdoor_admin WITH PASSWORD 'your_secure_password_here';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE outdoor_adventure_br TO outdoor_admin;

-- Exit
\q
```

### **Step 2: Test Connection**

```bash
# Connect to database as outdoor_admin
psql -U outdoor_admin -d outdoor_adventure_br -h localhost

# You may need to enter password
# If successful, you'll see:
# outdoor_adventure_br=>

# Exit
\q
```

### **Step 3: Load Schema**

```bash
# Navigate to project directory
cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"

# Load database schema
psql -U outdoor_admin -d outdoor_adventure_br -h localhost -f database/setup_schema.sql

# Load sample data - Part 1
psql -U outdoor_admin -d outdoor_adventure_br -h localhost -f database/data_insert_part1.sql

# Load sample data - Part 2
psql -U outdoor_admin -d outdoor_adventure_br -h localhost -f database/data_insert_part2.sql
```

### **Step 4: Verify Data**

```bash
# Connect to database
psql -U outdoor_admin -d outdoor_adventure_br -h localhost
```

```sql
-- Check tables exist
\dt

-- Check record counts
SELECT 'regions' AS table_name, COUNT(*) AS count FROM regions
UNION ALL
SELECT 'locations', COUNT(*) FROM locations
UNION ALL
SELECT 'campsites', COUNT(*) FROM campsites
UNION ALL
SELECT 'trails', COUNT(*) FROM trails
UNION ALL
SELECT 'climbing_routes', COUNT(*) FROM climbing_routes
UNION ALL
SELECT 'weather_data', COUNT(*) FROM weather_data
UNION ALL
SELECT 'outdoor_gear', COUNT(*) FROM outdoor_gear
UNION ALL
SELECT 'gear_reviews', COUNT(*) FROM gear_reviews;

-- Expected output:
-- regions: 8
-- locations: 20+
-- campsites: 20+
-- trails: 20+
-- climbing_routes: 12+
-- weather_data: 30+
-- outdoor_gear: 15+
-- gear_reviews: 15+
```

---

## 🐍 **Part 3: Python Environment**

### **Step 1: Install Python 3.10+**

**Ubuntu/Debian:**
```bash
# Add deadsnakes PPA
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update

# Install Python 3.10
sudo apt install python3.10 python3.10-venv python3.10-dev

# Verify
python3.10 --version
```

**macOS:**
```bash
# Via Homebrew
brew install python@3.10

# Verify
python3.10 --version
```

**Windows WSL2:**
```bash
# Same as Ubuntu
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.10 python3.10-venv python3.10-dev
```

### **Step 2: Create Virtual Environment**

```bash
# Navigate to project root
cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"

# Create virtual environment
python3.10 -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Your prompt should change to show (.venv)
```

### **Step 3: Install Python Packages**

```bash
# Ensure venv is activated
source .venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install all dependencies
pip install -r requirements.txt

# This will install:
# - pandas, polars, numpy (data processing)
# - psycopg2-binary, SQLAlchemy (database)
# - apache-airflow (orchestration)
# - pytest (testing)
# - And many more...
```

**Note**: This may take 5-10 minutes depending on your internet connection.

### **Step 4: Verify Python Installation**

```bash
# With venv activated, test imports
python << EOF
import pandas as pd
import psycopg2
import sqlalchemy
import duckdb
print("✅ All core packages imported successfully!")
print(f"Pandas version: {pd.__version__}")
print(f"SQLAlchemy version: {sqlalchemy.__version__}")
EOF
```

### **Step 5: Test Database Connection from Python**

```bash
# Create test script
cat > test_connection.py << 'EOF'
import psycopg2

# Connection parameters
conn_params = {
    'dbname': 'outdoor_adventure_br',
    'user': 'outdoor_admin',
    'password': 'your_secure_password_here',
    'host': 'localhost',
    'port': '5432'
}

try:
    # Connect
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()
    
    # Test query
    cur.execute("SELECT COUNT(*) FROM locations;")
    count = cur.fetchone()[0]
    
    print(f"✅ Database connection successful!")
    print(f"✅ Found {count} locations in database")
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"❌ Error: {e}")
EOF

# Run test
python test_connection.py

# Clean up
rm test_connection.py
```

---

## 🛠️ **Part 4: Essential Tools**

### **VS Code (Recommended Editor)**

**Installation:**
```bash
# Ubuntu
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# macOS
brew install --cask visual-studio-code
```

**Essential VS Code Extensions:**
- PostgreSQL (cweijan.vscode-postgresql-client2)
- Python (ms-python.python)
- Pylance (ms-python.vscode-pylance)
- SQLTools (mtxr.sqltools)
- Jupyter (ms-toolsai.jupyter)

### **DBeaver (Database Management - Optional)**

```bash
# Ubuntu
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i dbeaver-ce_latest_amd64.deb

# macOS
brew install --cask dbeaver-community
```

### **Git (Version Control)**

```bash
# Ubuntu
sudo apt install git

# macOS
brew install git

# Configure
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## ✅ **Part 5: Verification Checklist**

Run through this checklist to ensure everything is set up correctly:

### **PostgreSQL**
- [ ] PostgreSQL is installed and running
- [ ] Can connect to `outdoor_adventure_br` database
- [ ] All 9 tables exist
- [ ] Sample data is loaded (verified counts)
- [ ] Can run SELECT queries

### **Python**
- [ ] Python 3.10+ is installed
- [ ] Virtual environment created (`.venv`)
- [ ] All packages from `requirements.txt` installed
- [ ] Can import pandas, psycopg2, sqlalchemy
- [ ] Can connect to PostgreSQL from Python

### **Tools**
- [ ] VS Code (or preferred editor) installed
- [ ] Database client available (psql, DBeaver, or VS Code extension)
- [ ] Git configured

### **Project Structure**
- [ ] All module folders exist
- [ ] Database files present (`setup_schema.sql`, `data_insert_*.sql`)
- [ ] `requirements.txt` present

---

## 🚨 **Troubleshooting**

### **Issue: PostgreSQL connection refused**

```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start if not running
sudo systemctl start postgresql

# Check port
sudo netstat -plnt | grep postgres
```

### **Issue: psycopg2 installation fails**

```bash
# Install PostgreSQL development headers
sudo apt install libpq-dev python3-dev  # Ubuntu
brew install postgresql  # macOS

# Then retry
pip install psycopg2-binary
```

### **Issue: Permission denied on database**

```sql
-- Connect as postgres user
sudo -u postgres psql

-- Grant all privileges
GRANT ALL PRIVILEGES ON DATABASE outdoor_adventure_br TO outdoor_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO outdoor_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO outdoor_admin;
```

### **Issue: Python version conflicts**

```bash
# Use specific Python version
python3.10 -m venv .venv
source .venv/bin/activate
which python  # Should show .venv path
python --version  # Should show 3.10+
```

---

## 🎯 **Next Steps**

After completing this setup:

1. ✅ Start with Module 1, Lesson 1: Database Design
2. ✅ Practice SQL queries on the Brazilian outdoor data
3. ✅ Explore the database schema
4. ✅ Run example queries from the lessons

---

## 📚 **Quick Reference**

### **Start Your Development Session**

```bash
# Navigate to project
cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"

# Activate Python virtual environment
source .venv/bin/activate

# Connect to database
psql -U outdoor_admin -d outdoor_adventure_br -h localhost

# Or start VS Code
code .
```

### **Common psql Commands**

```sql
\dt              -- List all tables
\d table_name    -- Describe table structure
\l               -- List all databases
\du              -- List all users
\q               -- Quit
\?               -- Help
```

---

**Setup Complete! 🎉**

You're ready to begin your Data Engineering journey!
