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
