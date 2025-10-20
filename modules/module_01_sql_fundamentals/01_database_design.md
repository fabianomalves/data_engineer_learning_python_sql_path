# Lesson 1: Database Design Fundamentals

**Duration**: 2-3 hours  
**Difficulty**: Beginner

---

## 🎯 **Learning Objectives**

- Understand what relational databases are and why we use them
- Learn about entities, attributes, and relationships
- Master primary keys and foreign keys
- Apply normalization principles (1NF, 2NF, 3NF)
- Design the Brazilian Outdoor Adventure Platform database

---

## 📚 **1. What is a Relational Database?**

### **Definition**
A **relational database** organizes data into tables (also called relations) that can be linked—or related—based on data common to each.

### **Why Relational Databases?**

**Real-World Analogy**: Think of a library system:
- One table stores **books** (title, author, ISBN)
- Another stores **members** (name, ID, address)
- Another stores **loans** (which member borrowed which book, when)

Instead of repeating member information for every loan, we use relationships to connect the data efficiently.

### **Key Characteristics**

1. **Structured Data**: Data organized in rows and columns
2. **Relationships**: Tables connected through common fields
3. **ACID Properties**:
   - **Atomicity**: Transactions complete fully or not at all
   - **Consistency**: Data remains valid after transactions
   - **Isolation**: Concurrent transactions don't interfere
   - **Durability**: Committed data persists

### **When to Use Relational Databases**

✅ **Use when you need:**
- Complex queries and joins
- Data integrity and consistency
- Transaction support
- Structured, predictable data
- ACID compliance

❌ **Consider alternatives when:**
- Dealing with unstructured data (documents, images)
- Need horizontal scaling across many servers
- Schema changes very frequently
- Working with graph or hierarchical data primarily

---

## 🏗️ **2. Core Database Concepts**

### **2.1 Entities and Attributes**

**Entity**: A thing or object in the real world that we want to store data about.

**Examples from our Brazilian Outdoor Platform:**
- Camping location (e.g., Chapada Diamantina National Park)
- Climbing route (e.g., Pico da Bandeira route)
- Outdoor gear (e.g., tent, sleeping bag)
- Weather record (e.g., temperature on a specific date)

**Attributes**: Properties or characteristics of an entity.

**Example - Camping Location Entity:**
```
Camping Location
├── location_id (unique identifier)
├── location_name (e.g., "Chapada Diamantina")
├── state (e.g., "Bahia")
├── latitude (-12.4333)
├── longitude (-41.4167)
├── elevation (1200 meters)
└── description (text about the location)
```

### **2.2 Tables**

A **table** represents an entity type. Each row is an instance of that entity.

**Example - campsites table:**

| campsite_id | location_id | campsite_name | capacity | price_per_night | facilities |
|-------------|-------------|---------------|----------|-----------------|------------|
| 1 | 101 | Acampamento Vale do Capão | 50 | 25.00 | toilet, shower |
| 2 | 101 | Camping Guiné | 30 | 20.00 | toilet |
| 3 | 102 | Camping Pedra do Sino | 40 | 30.00 | toilet, shower, kitchen |

**Key Points:**
- Each row = one campsite
- Each column = one attribute
- Each cell = one value

### **2.3 Primary Keys (PK)**

A **primary key** uniquely identifies each row in a table.

**Requirements:**
- Must be unique (no duplicates)
- Cannot be NULL
- Should not change over time
- Typically a single column, but can be composite

**Examples:**

```sql
-- Good primary keys
campsite_id (auto-incrementing integer)
gear_id (UUID)
location_id (sequential number)

-- Bad primary keys
user_email (people change emails)
gear_name (multiple products can have same name)
phone_number (can change, might be NULL)
```

**In our project:**
```sql
CREATE TABLE campsites (
    campsite_id SERIAL PRIMARY KEY,  -- Auto-incrementing integer
    campsite_name VARCHAR(200) NOT NULL,
    capacity INTEGER
);
```

### **2.4 Foreign Keys (FK)**

A **foreign key** creates a relationship between two tables by referencing the primary key of another table.

**Purpose:**
- Maintain referential integrity
- Prevent orphaned records
- Enable joins between tables

**Example:**

```sql
-- Parent table (locations)
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(200) NOT NULL
);

-- Child table (campsites) - references locations
CREATE TABLE campsites (
    campsite_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    campsite_name VARCHAR(200) NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
```

**What this means:**
- Every campsite must belong to a valid location
- You cannot delete a location if campsites reference it (unless you use CASCADE)
- You cannot insert a campsite with a non-existent location_id

**Foreign Key Actions:**

```sql
-- ON DELETE CASCADE: Delete campsites when location is deleted
FOREIGN KEY (location_id) 
    REFERENCES locations(location_id) 
    ON DELETE CASCADE

-- ON DELETE SET NULL: Set location_id to NULL when location deleted
FOREIGN KEY (location_id) 
    REFERENCES locations(location_id) 
    ON DELETE SET NULL

-- ON DELETE RESTRICT: Prevent deletion if references exist (default)
FOREIGN KEY (location_id) 
    REFERENCES locations(location_id) 
    ON DELETE RESTRICT
```

---

## 🔄 **3. Normalization**

**Normalization** is the process of organizing data to reduce redundancy and improve data integrity.

### **Why Normalize?**

**Problem - Unnormalized Data:**

| campsite_name | location_name | state | latitude | longitude | facilities |
|---------------|---------------|-------|----------|-----------|------------|
| Acampamento Vale do Capão | Chapada Diamantina | Bahia | -12.4333 | -41.4167 | toilet, shower |
| Camping Guiné | Chapada Diamantina | Bahia | -12.4333 | -41.4167 | toilet |
| Camping Pedra do Sino | Serra dos Órgãos | Rio de Janeiro | -22.4500 | -43.0167 | toilet, shower, kitchen |

**Issues:**
1. **Redundancy**: Location data repeated for each campsite
2. **Update Anomalies**: If coordinates change, must update multiple rows
3. **Insertion Anomalies**: Can't add a location without a campsite
4. **Deletion Anomalies**: Deleting last campsite loses location info
5. **Storage Waste**: Same data stored multiple times

### **3.1 First Normal Form (1NF)**

**Rule**: Each cell contains only one value (atomic values). No repeating groups.

**Violation Example:**
```sql
-- BAD: facilities column contains multiple values
| campsite_id | facilities |
|-------------|------------|
| 1 | toilet, shower, kitchen |
```

**Corrected (1NF):**
```sql
-- Option 1: Separate table
campsites:
| campsite_id | campsite_name |
|-------------|---------------|
| 1 | Vale do Capão |

facilities:
| facility_id | campsite_id | facility_type |
|-------------|-------------|---------------|
| 1 | 1 | toilet |
| 2 | 1 | shower |
| 3 | 1 | kitchen |

-- Option 2: Boolean columns (if fixed set)
| campsite_id | has_toilet | has_shower | has_kitchen |
|-------------|------------|------------|-------------|
| 1 | TRUE | TRUE | TRUE |
```

### **3.2 Second Normal Form (2NF)**

**Rule**: Must be in 1NF AND all non-key attributes must depend on the entire primary key.

**Issue**: Partial dependencies (relevant when using composite primary keys)

**Violation Example:**
```sql
-- Composite key: (campsite_id, date)
campsite_bookings:
| campsite_id | date | campsite_name | location_name | guest_name |
|-------------|------|---------------|---------------|------------|
| 1 | 2025-11-15 | Vale do Capão | Chapada | João |
| 1 | 2025-11-16 | Vale do Capão | Chapada | Maria |
```

**Problem**: `campsite_name` and `location_name` depend only on `campsite_id`, not on the full key `(campsite_id, date)`

**Corrected (2NF):**
```sql
-- campsites table (campsite details)
| campsite_id | campsite_name | location_name |
|-------------|---------------|---------------|
| 1 | Vale do Capão | Chapada |

-- bookings table (date-specific data)
| booking_id | campsite_id | date | guest_name |
|------------|-------------|------|------------|
| 1 | 1 | 2025-11-15 | João |
| 2 | 1 | 2025-11-16 | Maria |
```

### **3.3 Third Normal Form (3NF)**

**Rule**: Must be in 2NF AND no transitive dependencies (non-key columns depend only on the primary key, not on other non-key columns).

**Violation Example:**
```sql
campsites:
| campsite_id | campsite_name | location_id | location_name | state |
|-------------|---------------|-------------|---------------|-------|
| 1 | Vale do Capão | 101 | Chapada Diamantina | Bahia |
| 2 | Camping Guiné | 101 | Chapada Diamantina | Bahia |
```

**Problem**: 
- `location_name` depends on `location_id` (not directly on `campsite_id`)
- `state` depends on `location_id` (not directly on `campsite_id`)
- This is a **transitive dependency**: campsite_id → location_id → location_name

**Corrected (3NF):**
```sql
-- locations table
| location_id | location_name | state |
|-------------|---------------|-------|
| 101 | Chapada Diamantina | Bahia |

-- campsites table (only direct dependencies)
| campsite_id | campsite_name | location_id |
|-------------|---------------|-------------|
| 1 | Vale do Capão | 101 |
| 2 | Camping Guiné | 101 |
```

### **Normalization Summary**

| Normal Form | Rule | Example Violation |
|-------------|------|-------------------|
| **1NF** | Atomic values, no repeating groups | "toilet, shower" in one cell |
| **2NF** | 1NF + No partial dependencies | campsite_name depends only on campsite_id in (campsite_id, date) key |
| **3NF** | 2NF + No transitive dependencies | state depends on location_id, not campsite_id |

**When to Denormalize:**
- Read-heavy systems (reporting, analytics)
- Performance optimization for complex joins
- Data warehousing scenarios
- When redundancy is manageable

---

## 🏔️ **4. Brazilian Outdoor Adventure Platform - Database Design**

### **4.1 Requirements Analysis**

**What data do we need to store?**

1. **Geographic Regions** (Brazilian states/areas)
2. **Locations** (National parks, mountains, trails)
3. **Campsites** (Camping areas with facilities)
4. **Climbing Routes** (Mountain routes with difficulty)
5. **Trails** (Hiking paths with distances)
6. **Weather Data** (Historical weather records)
7. **Outdoor Gear** (Equipment, pricing, brands)
8. **Gear Reviews** (User ratings and feedback)

### **4.2 Entity Identification**

**Main Entities:**

1. **regions** - Brazilian geographic regions
2. **locations** - Specific outdoor locations
3. **campsites** - Camping facilities
4. **climbing_routes** - Mountain climbing paths
5. **trails** - Hiking trails
6. **weather_data** - Weather records
7. **outdoor_gear** - Equipment/gear items
8. **gear_reviews** - User reviews of gear
9. **gear_categories** - Types of outdoor gear

### **4.3 Relationships**

```
regions (1) ──────> (Many) locations
    One region has many locations
    Example: Bahia state has Chapada Diamantina, Morro do Pai Inácio, etc.

locations (1) ──────> (Many) campsites
    One location can have multiple campsites
    Example: Chapada Diamantina has Vale do Capão, Guiné campsite, etc.

locations (1) ──────> (Many) climbing_routes
    One location can have multiple climbing routes
    Example: Pico da Bandeira has multiple routes with different difficulties

locations (1) ──────> (Many) trails
    One location can have multiple trails
    Example: Serra dos Órgãos has Pedra do Sino trail, Travessia trail, etc.

locations (1) ──────> (Many) weather_data
    One location has many weather records over time
    Example: Daily weather data for each location

outdoor_gear (1) ──────> (Many) gear_reviews
    One piece of gear can have multiple reviews
    Example: A specific tent model has many user reviews

gear_categories (1) ──────> (Many) outdoor_gear
    One category contains many gear items
    Example: "Tents" category contains various tent models
```

### **4.4 Attribute Definition**

**regions table:**
```sql
region_id       INTEGER (PK)
region_name     VARCHAR(100)    -- "Chapada Diamantina Region"
state           VARCHAR(2)       -- "BA" (Bahia)
description     TEXT             -- Detailed description
created_at      TIMESTAMP        -- When record was created
```

**locations table:**
```sql
location_id     INTEGER (PK)
region_id       INTEGER (FK)     -- References regions
location_name   VARCHAR(200)     -- "Parque Nacional da Chapada Diamantina"
latitude        DECIMAL(10,7)    -- -12.4333333
longitude       DECIMAL(10,7)    -- -41.4166667
elevation       INTEGER          -- Meters above sea level
location_type   VARCHAR(50)      -- "national_park", "mountain", "trail_system"
description     TEXT
access_info     TEXT             -- How to get there
best_season     VARCHAR(100)     -- "April to October (dry season)"
created_at      TIMESTAMP
updated_at      TIMESTAMP
```

**campsites table:**
```sql
campsite_id         INTEGER (PK)
location_id         INTEGER (FK)     -- References locations
campsite_name       VARCHAR(200)     -- "Acampamento Vale do Capão"
capacity            INTEGER          -- Maximum number of people
price_per_night     DECIMAL(10,2)    -- Price in BRL
has_toilet          BOOLEAN
has_shower          BOOLEAN
has_kitchen         BOOLEAN
has_electricity     BOOLEAN
reservation_required BOOLEAN
contact_phone       VARCHAR(20)
contact_email       VARCHAR(100)
description         TEXT
season_open_start   INTEGER          -- Month (1-12)
season_open_end     INTEGER          -- Month (1-12)
created_at          TIMESTAMP
updated_at          TIMESTAMP
```

**climbing_routes table:**
```sql
route_id            INTEGER (PK)
location_id         INTEGER (FK)
route_name          VARCHAR(200)     -- "Via Normal - Pico da Bandeira"
difficulty_grade    VARCHAR(20)      -- "II - Easy", "VI - Very Difficult"
height_meters       INTEGER          -- Total climbing height
route_type          VARCHAR(50)      -- "trad", "sport", "boulder", "alpine"
pitches             INTEGER          -- Number of rope lengths
estimated_hours     DECIMAL(4,2)     -- Time to complete
best_season         VARCHAR(100)
first_ascent_date   DATE
first_ascent_by     VARCHAR(200)
description         TEXT
gear_required       TEXT
danger_notes        TEXT
created_at          TIMESTAMP
```

**trails table:**
```sql
trail_id            INTEGER (PK)
location_id         INTEGER (FK)
trail_name          VARCHAR(200)     -- "Trilha da Cachoeira da Fumaça"
distance_km         DECIMAL(6,2)     -- 12.5 km
difficulty          VARCHAR(20)      -- "easy", "moderate", "hard", "extreme"
elevation_gain      INTEGER          -- Meters of climbing
estimated_hours     DECIMAL(4,2)     -- 6.5 hours
trail_type          VARCHAR(50)      -- "out_and_back", "loop", "point_to_point"
surface_type        VARCHAR(100)     -- "dirt", "rocky", "mixed"
marked              BOOLEAN          -- Is trail marked?
best_season         VARCHAR(100)
water_available     BOOLEAN
camping_allowed     BOOLEAN
description         TEXT
safety_notes        TEXT
created_at          TIMESTAMP
```

**weather_data table:**
```sql
weather_id          INTEGER (PK)
location_id         INTEGER (FK)
date_recorded       DATE
temperature_min_c   DECIMAL(4,1)     -- -5.5°C
temperature_max_c   DECIMAL(4,1)     -- 28.3°C
rainfall_mm         DECIMAL(6,2)     -- 12.5 mm
humidity_percent    INTEGER          -- 75%
wind_speed_kmh      DECIMAL(5,2)     -- 15.5 km/h
wind_direction      VARCHAR(3)       -- "NW", "SE"
conditions          VARCHAR(50)      -- "sunny", "cloudy", "rainy", "stormy"
visibility_km       DECIMAL(5,2)
pressure_hpa        INTEGER          -- 1013 hPa
created_at          TIMESTAMP
```

**gear_categories table:**
```sql
category_id         INTEGER (PK)
category_name       VARCHAR(100)     -- "Tents", "Sleeping Bags", "Backpacks"
parent_category_id  INTEGER (FK)     -- For subcategories (can be NULL)
description         TEXT
created_at          TIMESTAMP
```

**outdoor_gear table:**
```sql
gear_id             INTEGER (PK)
category_id         INTEGER (FK)
gear_name           VARCHAR(200)     -- "Barraca Nautika Apache GT 5/6"
brand               VARCHAR(100)     -- "Nautika", "Doite", "Coleman"
model_number        VARCHAR(100)
price_brl           DECIMAL(10,2)    -- 1299.90
weight_grams        INTEGER          -- 5500g
dimensions          VARCHAR(100)     -- "220 x 250 x 160 cm"
capacity_people     INTEGER          -- For tents
temperature_rating  INTEGER          -- For sleeping bags (-5°C)
volume_liters       INTEGER          -- For backpacks (65L)
material            VARCHAR(200)
color               VARCHAR(50)
availability        VARCHAR(20)      -- "in_stock", "out_of_stock", "preorder"
store_name          VARCHAR(200)     -- "Decathlon Brasil", "Amazon.com.br"
store_url           TEXT
affiliate_link      TEXT
description         TEXT
features            TEXT
created_at          TIMESTAMP
updated_at          TIMESTAMP
```

**gear_reviews table:**
```sql
review_id           INTEGER (PK)
gear_id             INTEGER (FK)
user_name           VARCHAR(100)     -- Or user_id if we add users table
rating              INTEGER          -- 1-5 stars
review_title        VARCHAR(200)
review_text         TEXT
verified_purchase   BOOLEAN
date_posted         DATE
helpful_count       INTEGER          -- How many found it helpful
location_used       VARCHAR(200)     -- Where they used the gear
duration_used       VARCHAR(100)     -- "6 months", "2 years"
created_at          TIMESTAMP
```

---

## 💻 **5. Creating the Database Schema**

### **Complete SQL Schema**

Now let's create all tables with proper constraints, data types, and relationships.

```sql
-- ============================================================================
-- BRAZILIAN OUTDOOR ADVENTURE PLATFORM - DATABASE SCHEMA
-- ============================================================================
-- Version: 1.0
-- Database: PostgreSQL 15+
-- Created: October 2025
-- Description: Complete database for outdoor adventure platform in Brazil
-- ============================================================================

-- Drop existing tables (for clean rebuild)
DROP TABLE IF EXISTS gear_reviews CASCADE;
DROP TABLE IF EXISTS outdoor_gear CASCADE;
DROP TABLE IF EXISTS gear_categories CASCADE;
DROP TABLE IF EXISTS weather_data CASCADE;
DROP TABLE IF EXISTS trails CASCADE;
DROP TABLE IF EXISTS climbing_routes CASCADE;
DROP TABLE IF EXISTS campsites CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS regions CASCADE;

-- ============================================================================
-- TABLE: regions
-- Description: Brazilian geographic regions (states/areas)
-- ============================================================================
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL CHECK (LENGTH(state) = 2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT unique_region_state UNIQUE (region_name, state)
);

-- Index for faster lookups
CREATE INDEX idx_regions_state ON regions(state);

COMMENT ON TABLE regions IS 'Brazilian geographic regions and states';
COMMENT ON COLUMN regions.state IS 'Two-letter state code (e.g., BA, RJ, SP)';

-- ============================================================================
-- TABLE: locations
-- Description: Specific outdoor locations (parks, mountains, etc.)
-- ============================================================================
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    region_id INTEGER NOT NULL,
    location_name VARCHAR(200) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    elevation INTEGER CHECK (elevation >= 0 AND elevation <= 3000),
    location_type VARCHAR(50) NOT NULL,
    description TEXT,
    access_info TEXT,
    best_season VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_location_region 
        FOREIGN KEY (region_id) 
        REFERENCES regions(region_id) 
        ON DELETE RESTRICT,
    
    -- Constraints
    CONSTRAINT check_location_type 
        CHECK (location_type IN (
            'national_park', 'state_park', 'mountain', 
            'trail_system', 'climbing_area', 'camping_area'
        )),
    CONSTRAINT check_latitude 
        CHECK (latitude BETWEEN -33.75 AND 5.27),  -- Brazil's latitude range
    CONSTRAINT check_longitude 
        CHECK (longitude BETWEEN -73.99 AND -34.79) -- Brazil's longitude range
);

-- Indexes
CREATE INDEX idx_locations_region ON locations(region_id);
CREATE INDEX idx_locations_type ON locations(location_type);
CREATE INDEX idx_locations_coordinates ON locations(latitude, longitude);

COMMENT ON TABLE locations IS 'Outdoor locations across Brazil';
COMMENT ON COLUMN locations.elevation IS 'Elevation in meters above sea level';

-- ============================================================================
-- TABLE: campsites
-- Description: Camping facilities and information
-- ============================================================================
CREATE TABLE campsites (
    campsite_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    campsite_name VARCHAR(200) NOT NULL,
    capacity INTEGER CHECK (capacity > 0),
    price_per_night DECIMAL(10,2) CHECK (price_per_night >= 0),
    has_toilet BOOLEAN DEFAULT FALSE,
    has_shower BOOLEAN DEFAULT FALSE,
    has_kitchen BOOLEAN DEFAULT FALSE,
    has_electricity BOOLEAN DEFAULT FALSE,
    reservation_required BOOLEAN DEFAULT FALSE,
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    description TEXT,
    season_open_start INTEGER CHECK (season_open_start BETWEEN 1 AND 12),
    season_open_end INTEGER CHECK (season_open_end BETWEEN 1 AND 12),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_campsite_location 
        FOREIGN KEY (location_id) 
        REFERENCES locations(location_id) 
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT check_email_format 
        CHECK (contact_email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' 
               OR contact_email IS NULL)
);

-- Indexes
CREATE INDEX idx_campsites_location ON campsites(location_id);
CREATE INDEX idx_campsites_price ON campsites(price_per_night);

COMMENT ON TABLE campsites IS 'Camping facilities and amenities';
COMMENT ON COLUMN campsites.price_per_night IS 'Price in Brazilian Reais (BRL)';

-- ============================================================================
-- TABLE: climbing_routes
-- Description: Mountain climbing routes
-- ============================================================================
CREATE TABLE climbing_routes (
    route_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    route_name VARCHAR(200) NOT NULL,
    difficulty_grade VARCHAR(20) NOT NULL,
    height_meters INTEGER CHECK (height_meters > 0),
    route_type VARCHAR(50) NOT NULL,
    pitches INTEGER CHECK (pitches > 0),
    estimated_hours DECIMAL(4,2) CHECK (estimated_hours > 0),
    best_season VARCHAR(100),
    first_ascent_date DATE,
    first_ascent_by VARCHAR(200),
    description TEXT,
    gear_required TEXT,
    danger_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_route_location 
        FOREIGN KEY (location_id) 
        REFERENCES locations(location_id) 
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT check_route_type 
        CHECK (route_type IN ('trad', 'sport', 'boulder', 'alpine', 'ice', 'mixed'))
);

-- Indexes
CREATE INDEX idx_routes_location ON climbing_routes(location_id);
CREATE INDEX idx_routes_difficulty ON climbing_routes(difficulty_grade);

COMMENT ON TABLE climbing_routes IS 'Mountain climbing routes and technical information';
COMMENT ON COLUMN climbing_routes.difficulty_grade IS 'Climbing difficulty (e.g., I-VI, 5.1-5.15)';

-- ============================================================================
-- TABLE: trails
-- Description: Hiking trails
-- ============================================================================
CREATE TABLE trails (
    trail_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    trail_name VARCHAR(200) NOT NULL,
    distance_km DECIMAL(6,2) CHECK (distance_km > 0),
    difficulty VARCHAR(20) NOT NULL,
    elevation_gain INTEGER CHECK (elevation_gain >= 0),
    estimated_hours DECIMAL(4,2) CHECK (estimated_hours > 0),
    trail_type VARCHAR(50) NOT NULL,
    surface_type VARCHAR(100),
    marked BOOLEAN DEFAULT TRUE,
    best_season VARCHAR(100),
    water_available BOOLEAN DEFAULT FALSE,
    camping_allowed BOOLEAN DEFAULT FALSE,
    description TEXT,
    safety_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_trail_location 
        FOREIGN KEY (location_id) 
        REFERENCES locations(location_id) 
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT check_difficulty 
        CHECK (difficulty IN ('easy', 'moderate', 'hard', 'extreme')),
    CONSTRAINT check_trail_type 
        CHECK (trail_type IN ('out_and_back', 'loop', 'point_to_point'))
);

-- Indexes
CREATE INDEX idx_trails_location ON trails(location_id);
CREATE INDEX idx_trails_difficulty ON trails(difficulty);
CREATE INDEX idx_trails_distance ON trails(distance_km);

COMMENT ON TABLE trails IS 'Hiking trails with difficulty and distance information';

-- ============================================================================
-- TABLE: weather_data
-- Description: Historical weather records
-- ============================================================================
CREATE TABLE weather_data (
    weather_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    date_recorded DATE NOT NULL,
    temperature_min_c DECIMAL(4,1),
    temperature_max_c DECIMAL(4,1),
    rainfall_mm DECIMAL(6,2) CHECK (rainfall_mm >= 0),
    humidity_percent INTEGER CHECK (humidity_percent BETWEEN 0 AND 100),
    wind_speed_kmh DECIMAL(5,2) CHECK (wind_speed_kmh >= 0),
    wind_direction VARCHAR(3),
    conditions VARCHAR(50),
    visibility_km DECIMAL(5,2) CHECK (visibility_km >= 0),
    pressure_hpa INTEGER CHECK (pressure_hpa BETWEEN 900 AND 1100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_weather_location 
        FOREIGN KEY (location_id) 
        REFERENCES locations(location_id) 
        ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT check_temperature 
        CHECK (temperature_min_c <= temperature_max_c),
    CONSTRAINT check_wind_direction 
        CHECK (wind_direction IN ('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW') 
               OR wind_direction IS NULL),
    CONSTRAINT unique_location_date 
        UNIQUE (location_id, date_recorded)
);

-- Indexes
CREATE INDEX idx_weather_location ON weather_data(location_id);
CREATE INDEX idx_weather_date ON weather_data(date_recorded);
CREATE INDEX idx_weather_location_date ON weather_data(location_id, date_recorded);

COMMENT ON TABLE weather_data IS 'Historical and current weather data for locations';

-- ============================================================================
-- TABLE: gear_categories
-- Description: Categories for outdoor gear
-- ============================================================================
CREATE TABLE gear_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys (self-referencing for subcategories)
    CONSTRAINT fk_parent_category 
        FOREIGN KEY (parent_category_id) 
        REFERENCES gear_categories(category_id) 
        ON DELETE SET NULL
);

CREATE INDEX idx_categories_parent ON gear_categories(parent_category_id);

COMMENT ON TABLE gear_categories IS 'Hierarchical categories for outdoor gear';

-- ============================================================================
-- TABLE: outdoor_gear
-- Description: Outdoor equipment and gear
-- ============================================================================
CREATE TABLE outdoor_gear (
    gear_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    gear_name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    model_number VARCHAR(100),
    price_brl DECIMAL(10,2) CHECK (price_brl >= 0),
    weight_grams INTEGER CHECK (weight_grams > 0),
    dimensions VARCHAR(100),
    capacity_people INTEGER CHECK (capacity_people > 0),
    temperature_rating INTEGER,
    volume_liters INTEGER CHECK (volume_liters > 0),
    material VARCHAR(200),
    color VARCHAR(50),
    availability VARCHAR(20) NOT NULL DEFAULT 'in_stock',
    store_name VARCHAR(200),
    store_url TEXT,
    affiliate_link TEXT,
    description TEXT,
    features TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_gear_category 
        FOREIGN KEY (category_id) 
        REFERENCES gear_categories(category_id) 
        ON DELETE RESTRICT,
    
    -- Constraints
    CONSTRAINT check_availability 
        CHECK (availability IN ('in_stock', 'out_of_stock', 'preorder', 'discontinued'))
);

-- Indexes
CREATE INDEX idx_gear_category ON outdoor_gear(category_id);
CREATE INDEX idx_gear_brand ON outdoor_gear(brand);
CREATE INDEX idx_gear_price ON outdoor_gear(price_brl);
CREATE INDEX idx_gear_availability ON outdoor_gear(availability);

COMMENT ON TABLE outdoor_gear IS 'Outdoor equipment with pricing and specifications';
COMMENT ON COLUMN outdoor_gear.price_brl IS 'Price in Brazilian Reais';

-- ============================================================================
-- TABLE: gear_reviews
-- Description: User reviews of outdoor gear
-- ============================================================================
CREATE TABLE gear_reviews (
    review_id SERIAL PRIMARY KEY,
    gear_id INTEGER NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_title VARCHAR(200),
    review_text TEXT,
    verified_purchase BOOLEAN DEFAULT FALSE,
    date_posted DATE NOT NULL DEFAULT CURRENT_DATE,
    helpful_count INTEGER DEFAULT 0 CHECK (helpful_count >= 0),
    location_used VARCHAR(200),
    duration_used VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    CONSTRAINT fk_review_gear 
        FOREIGN KEY (gear_id) 
        REFERENCES outdoor_gear(gear_id) 
        ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_reviews_gear ON gear_reviews(gear_id);
CREATE INDEX idx_reviews_rating ON gear_reviews(rating);
CREATE INDEX idx_reviews_date ON gear_reviews(date_posted);

COMMENT ON TABLE gear_reviews IS 'User reviews and ratings for outdoor gear';

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View: Complete location information with region
CREATE VIEW v_locations_complete AS
SELECT 
    l.location_id,
    l.location_name,
    l.location_type,
    r.region_name,
    r.state,
    l.latitude,
    l.longitude,
    l.elevation,
    l.best_season
FROM locations l
JOIN regions r ON l.region_id = r.region_id;

-- View: Campsite summary with pricing
CREATE VIEW v_campsites_summary AS
SELECT 
    c.campsite_id,
    c.campsite_name,
    l.location_name,
    r.state,
    c.capacity,
    c.price_per_night,
    c.has_toilet,
    c.has_shower,
    c.has_kitchen,
    c.has_electricity
FROM campsites c
JOIN locations l ON c.location_id = l.location_id
JOIN regions r ON l.region_id = r.region_id;

-- View: Gear with average ratings
CREATE VIEW v_gear_with_ratings AS
SELECT 
    g.gear_id,
    g.gear_name,
    g.brand,
    g.price_brl,
    gc.category_name,
    COUNT(gr.review_id) AS review_count,
    ROUND(AVG(gr.rating), 2) AS avg_rating
FROM outdoor_gear g
LEFT JOIN gear_reviews gr ON g.gear_id = gr.gear_id
JOIN gear_categories gc ON g.category_id = gc.category_id
GROUP BY g.gear_id, g.gear_name, g.brand, g.price_brl, gc.category_name;

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Function: Calculate average temperature for a location
CREATE OR REPLACE FUNCTION get_avg_temp(loc_id INTEGER, start_date DATE, end_date DATE)
RETURNS DECIMAL(5,2) AS $$
DECLARE
    avg_temp DECIMAL(5,2);
BEGIN
    SELECT ROUND(AVG((temperature_min_c + temperature_max_c) / 2), 2)
    INTO avg_temp
    FROM weather_data
    WHERE location_id = loc_id
    AND date_recorded BETWEEN start_date AND end_date;
    
    RETURN avg_temp;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- GRANTS (adjust based on your user setup)
-- ============================================================================

-- Grant permissions to outdoor_admin user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO outdoor_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO outdoor_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO outdoor_admin;

-- ============================================================================
-- SCHEMA COMPLETE
-- ============================================================================

-- Display success message
DO $$
BEGIN
    RAISE NOTICE '✅ Brazilian Outdoor Adventure Platform schema created successfully!';
    RAISE NOTICE 'Tables created: 9';
    RAISE NOTICE 'Views created: 3';
    RAISE NOTICE 'Functions created: 1';
END $$;
```

---

## ✅ **Practice Exercises**

### **Exercise 1: Understanding Normalization**

**Question**: Is this table normalized? If not, what normal form violations exist?

```sql
campsite_bookings:
| booking_id | campsite_name | location_name | state | guest_name | guest_email | booking_date | price |
|------------|---------------|---------------|-------|------------|-------------|--------------|-------|
| 1 | Vale do Capão | Chapada | BA | João Silva | joao@email.com | 2025-11-15 | 25.00 |
| 2 | Vale do Capão | Chapada | BA | Maria Santos | maria@email.com | 2025-11-16 | 25.00 |
```

**Answer**:
No, this violates multiple normal forms:

**1NF Violation**: None (all values are atomic)

**2NF Violation**: If we had a composite key like (booking_id, campsite_name), campsite attributes would depend only on campsite_name

**3NF Violation**: Yes! Multiple transitive dependencies:
- `state` depends on `location_name`, not directly on `booking_id`
- `campsite_name` implies `location_name` and `state`
- `price` might depend on `campsite_name`, not `booking_id`

**Normalized Design**:
```sql
-- bookings table
| booking_id | campsite_id | guest_id | booking_date |

-- campsites table
| campsite_id | location_id | campsite_name | price_per_night |

-- locations table
| location_id | location_name | state |

-- guests table
| guest_id | guest_name | guest_email |
```

### **Exercise 2: Primary Key Selection**

**Question**: Which column(s) would make the best primary key for a trail_conditions table that tracks daily trail status?

```sql
trail_conditions:
- trail_id
- date_checked
- condition (open/closed)
- checked_by
- notes
```

**Answer**:
**Composite primary key**: `(trail_id, date_checked)`

**Reasoning**:
- Each trail can have multiple condition records (one per date)
- Each date can have multiple records (one per trail)
- The combination uniquely identifies each record
- We want to track conditions over time, so we can't just use trail_id

**Implementation**:
```sql
CREATE TABLE trail_conditions (
    trail_id INTEGER NOT NULL,
    date_checked DATE NOT NULL,
    condition VARCHAR(20) NOT NULL,
    checked_by VARCHAR(100),
    notes TEXT,
    
    PRIMARY KEY (trail_id, date_checked),
    FOREIGN KEY (trail_id) REFERENCES trails(trail_id)
);
```

### **Exercise 3: Foreign Key Relationships**

**Question**: Design the relationship between gear and reviews. Should we use CASCADE, SET NULL, or RESTRICT on delete?

**Answer**:
```sql
CREATE TABLE gear_reviews (
    review_id SERIAL PRIMARY KEY,
    gear_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    review_text TEXT,
    
    FOREIGN KEY (gear_id) 
        REFERENCES outdoor_gear(gear_id) 
        ON DELETE CASCADE  -- ✅ Use CASCADE
);
```

**Reasoning**:
- **CASCADE is correct**: When gear is deleted, its reviews are meaningless
- **SET NULL would be wrong**: A review without a gear_id is invalid
- **RESTRICT would be problematic**: We'd have to manually delete all reviews before deleting gear

**When to use each**:
- **CASCADE**: Child records are meaningless without parent (reviews, order items)
- **SET NULL**: Child can exist independently (employee.manager_id when manager leaves)
- **RESTRICT**: Prevent accidental deletion (don't delete location if campsites exist)

---

## 🎯 **Key Takeaways**

1. **Relational databases** organize data into related tables, reducing redundancy
2. **Primary keys** uniquely identify records and should never change
3. **Foreign keys** create relationships and maintain data integrity
4. **Normalization** reduces redundancy through 1NF, 2NF, and 3NF
5. **Denormalization** is sometimes acceptable for performance
6. **Good design** prevents data anomalies and makes queries easier

---

## 🚀 **Next Lesson**

Now that you understand database design, let's start writing SQL queries!

**Next**: `02_sql_basics_select_where.md` - Your first SELECT statements

---

**Congratulations on completing Lesson 1!** 🎉
