# 🚀 Quick Start Guide - Data Engineering Learning Path

**Get up and running in 30 minutes!**

---

## ⚡ **Fast Track Setup**

### **1. Check Prerequisites (2 minutes)**

```bash
# Check Python version (need 3.10+)
python3 --version

# Check PostgreSQL (need 12+)
psql --version

# Check Git
git --version
```

If any are missing, see [Full Setup Guide](docs/setup_guides/local_environment_setup.md)

---

### **2. Setup Database (5 minutes)**

```bash
# Start PostgreSQL (if not running)
sudo systemctl start postgresql  # Linux
# OR
brew services start postgresql@15  # macOS

# Create database
sudo -u postgres psql << EOF
CREATE DATABASE outdoor_adventure_br;
CREATE USER outdoor_admin WITH PASSWORD 'dataeng2025';
GRANT ALL PRIVILEGES ON DATABASE outdoor_adventure_br TO outdoor_admin;
\q
EOF

# Load schema and data
cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"

psql -U outdoor_admin -d outdoor_adventure_br -h localhost << EOF
\i database/setup_schema.sql
\i database/data_insert_part1.sql
\i database/data_insert_part2.sql
EOF
```

---

### **3. Setup Python Environment (10 minutes)**

```bash
# Create virtual environment
python3.10 -m venv .venv

# Activate it
source .venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

---

### **4. Verify Installation (3 minutes)**

```bash
# Test database connection
psql -U outdoor_admin -d outdoor_adventure_br -h localhost -c "SELECT COUNT(*) FROM locations;"

# Test Python
python << EOF
import pandas as pd
import psycopg2
print("✅ Everything works!")
EOF
```

---

### **5. Run Your First Query (5 minutes)**

```bash
# Connect to database
psql -U outdoor_admin -d outdoor_adventure_br -h localhost
```

```sql
-- Find affordable campsites in Bahia with showers
SELECT 
    campsite_name,
    price_per_night,
    capacity,
    has_shower
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
JOIN regions r ON l.region_id = r.region_id
WHERE r.state = 'BA'
  AND c.price_per_night < 30
  AND c.has_shower = true
ORDER BY c.price_per_night;
```

---

### **6. Start Learning! (5 minutes)**

```bash
# Open Module 1, Lesson 1
code "modules/module_01_sql_fundamentals/01_database_design.md"

# Or read in terminal
cat "modules/module_01_sql_fundamentals/01_database_design.md" | less
```

---

## 📚 **Learning Path**

### **Week 1-2: SQL Fundamentals**
- Read: `modules/module_01_sql_fundamentals/01_database_design.md`
- Practice: Run queries from lessons 2-5
- Project: Explore Brazilian outdoor data

### **Week 3-4: Python Essentials**
- Start: `modules/module_02_python_essentials/`
- Practice: Connect Python to PostgreSQL
- Project: Build data extraction scripts

### **Week 5-8: Advanced Topics**
- Learn: Airflow, DuckDB, Polars
- Build: Complete data pipelines
- Deploy: Brazilian Outdoor Platform

---

## 🎯 **Daily Workflow**

```bash
# 1. Navigate to project
cd "/home/fabiano/Software Projects/Personal_Projects/Data Engineer Python SQL Path"

# 2. Activate Python environment
source .venv/bin/activate

# 3. Start PostgreSQL (if needed)
sudo systemctl start postgresql  # or brew services start postgresql@15

# 4. Open your editor
code .

# 5. Connect to database for practice
psql -U outdoor_admin -d outdoor_adventure_br -h localhost
```

---

## 🆘 **Common Issues**

### **Can't connect to database?**
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Start it
sudo systemctl start postgresql
```

### **Permission denied?**
```bash
# Grant privileges
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE outdoor_adventure_br TO outdoor_admin;"
```

### **Module not found in Python?**
```bash
# Make sure venv is activated
source .venv/bin/activate

# Reinstall if needed
pip install -r requirements.txt
```

---

## 📖 **Key Files**

| File | Purpose |
|------|---------|
| `README.md` | Main course overview |
| `requirements.txt` | Python dependencies |
| `database/setup_schema.sql` | Database structure |
| `database/data_insert_part*.sql` | Sample data |
| `modules/module_01_sql_fundamentals/` | SQL lessons |
| `projects/brazilian_outdoor_platform/` | Main project |
| `docs/setup_guides/` | Detailed setup instructions |

---

## 🎉 **You're Ready!**

Start with: `modules/module_01_sql_fundamentals/01_database_design.md`

**Happy Learning! 🚀**

---

**Need help?** Check the [troubleshooting guide](docs/troubleshooting/common_issues.md)
