-- ============================================================================
-- BRAZILIAN OUTDOOR ADVENTURE PLATFORM - SAMPLE DATA (PART 2)
-- ============================================================================
-- Version: 1.0
-- Created: October 2025
-- Description: Trails, climbing routes, weather data, and outdoor gear
-- ============================================================================
-- NOTE: Run data_insert_part1.sql BEFORE running this file
-- ============================================================================

-- ============================================================================
-- TRAILS DATA - Hiking trails across Brazilian outdoor locations
-- ============================================================================

-- Chapada Diamantina trails
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(1, 'Cachoeira da Fumaça (Smoke Waterfall)', 12.00, 'moderate', 450, 6.00, 'out_and_back',
 'Rocky, dirt path', true, 'April to October', false, false,
 'Trail to one of Brazil''s highest waterfalls (380m drop). Starts in Vale do Capão. Relatively flat until final descent to canyon rim. Spectacular views. No access to waterfall base from top.',
 'Vertigo warning - steep cliff edges. Do not attempt in fog or rain. Stay on marked trail.'),

(1, 'Cachoeira do Sossego (Peace Waterfall)', 14.00, 'hard', 600, 8.00, 'out_and_back',
 'Rocky, river crossings', true, 'April to October', true, false,
 'Beautiful trail following Rio Ribeirão. Multiple river crossings required. Ends at stunning multi-tiered waterfall with natural swimming pool.',
 'River crossings dangerous during/after rain. Check water levels before starting.'),

(3, 'Morro do Pai Inácio Summit', 1.50, 'easy', 320, 1.50, 'out_and_back',
 'Rocky, some stairs', true, 'Year-round', false, false,
 'Short but steep climb to iconic table-top summit. 360-degree views of Chapada Diamantina. Sunset and sunrise extremely popular.',
 'Crowded at sunset. Arrive early. Bring headlamp if descending after dark.'),

(2, 'Vale do Capão to Águas Claras', 26.00, 'hard', 800, 12.00, 'point_to_point',
 'Mixed - dirt, rocky, river', true, 'April to October', true, true,
 'Multi-day trek option through remote valleys. Passes through pristine cerrado and cloud forest. Camping required.',
 'Guide recommended. Bring water purification. Multiple river crossings.');

-- Serra dos Órgãos trails
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(5, 'Pedra do Sino (Bell Rock) Summit', 13.00, 'hard', 1670, 9.00, 'out_and_back',
 'Rocky, technical sections', true, 'May to September', true, false,
 'Climb to highest peak in Rio de Janeiro state (2,263m). Challenging ascent through Atlantic Forest. Summit offers 360-degree views to ocean.',
 'Start before 8 AM (park rule). Weather changes rapidly. Bring warm layers for summit.'),

(4, 'Trilha Cartão Postal (Postcard Trail)', 5.00, 'easy', 200, 3.00, 'loop',
 'Well-maintained dirt path', true, 'Year-round', false, false,
 'Family-friendly trail with classic views of Dedo de Deus and other peaks. Good introduction to park.',
 'Can be slippery after rain. Moderate crowds on weekends.'),

(4, 'Trilha da Pedra do Açu', 8.00, 'moderate', 580, 5.00, 'out_and_back',
 'Rocky, some scrambling', true, 'May to September', true, false,
 'Trail to large boulder formation with excellent viewpoint. Passes through dense Atlantic Forest.',
 'Some exposed sections. Not recommended in wet conditions.'),

(4, 'Travessia Petrópolis-Teresópolis', 42.00, 'extreme', 2800, 36.00, 'point_to_point',
 'Highly technical, varied', true, 'June to August', true, true,
 'Legendary 3-day traverse crossing Serra dos Órgãos. Requires technical climbing skills. Camping at designated sites only. Permit required.',
 'Advanced hikers only. Guide mandatory. Rope skills required for exposed sections.');

-- Serra da Mantiqueira trails
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(7, 'Pico da Bandeira Summit via Tronqueira', 3.50, 'moderate', 600, 3.50, 'out_and_back',
 'Rocky, high altitude', true, 'May to September', false, false,
 'Summit trail from upper parking lot at Tronqueira (2,300m). Relatively short but high altitude. Sunrise hikes very popular.',
 'Freezing temperatures possible (below 0°C). Altitude sickness possible. Bring warm clothes.'),

(8, 'Travessia dos Três Picos', 18.00, 'extreme', 1400, 14.00, 'point_to_point',
 'Technical, rocky, exposed', true, 'May to September', false, false,
 'Advanced trek connecting Pico da Bandeira, Pico do Cristal, and Pico do Calçado. Technical sections require scrambling.',
 'Guide strongly recommended. Weather changes rapidly. Not for beginners.'),

(7, 'Trilha do Vale Verde', 8.00, 'moderate', 400, 5.00, 'loop',
 'Dirt path through forest', true, 'April to October', true, false,
 'Scenic loop through valley with waterfalls and Atlantic Forest. Good acclimatization hike.',
 'Less crowded than summit trails. Good for wildlife observation.');

-- Aparados da Serra trails
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(10, 'Trilha do Vértice (Rim Trail)', 3.60, 'easy', 50, 2.00, 'out_and_back',
 'Boardwalk and dirt', true, 'October to March', false, false,
 'Easy trail along canyon rim with dramatic viewpoints. Suitable for families. Spectacular views of 720m deep canyon.',
 'Stay behind safety barriers. Fatal falls have occurred. Fog can reduce visibility to zero.'),

(10, 'Trilha do Cotovelo (Elbow Trail)', 6.40, 'hard', 800, 5.00, 'out_and_back',
 'Steep descent, technical', true, 'October to March', true, false,
 'Descends into Itaimbezinho Canyon. Steep stairs and switchbacks. Access to canyon floor and waterfalls.',
 'Strenuous return climb (800m elevation). Start early. Bring plenty of water.'),

(11, 'Trilha do Rio do Boi', 14.00, 'extreme', 400, 9.00, 'out_and_back',
 'River walking, swimming required', true, 'November to February only', true, false,
 'Epic canyon walk through Fortaleza Canyon. Multiple river crossings, swimming sections, and waterfalls. Guide mandatory.',
 'Weather dependent. Flash flood danger. Guide required. Good swimming ability essential.');

-- Serra do Mar trails  
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(13, 'Trilha do Rio Bonito', 8.00, 'moderate', 300, 5.00, 'out_and_back',
 'Forest trail, river crossings', true, 'April to October', true, false,
 'Beautiful river trail through pristine Atlantic Forest. Natural swimming pools and small waterfalls.',
 'Leeches common in wet season. River crossings after rain can be dangerous.'),

(14, 'Trilha da Cachoeira do Veado', 12.00, 'hard', 650, 7.00, 'out_and_back',
 'Steep, muddy in places', true, 'April to October', true, false,
 'Remote trail to stunning waterfall. Dense forest, wildlife common. Less visited.',
 'Guide recommended. Trail can be overgrown. Wildlife includes venomous snakes.');

-- Jalapão trails
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(15, 'Trilha das Dunas do Jalapão', 4.00, 'easy', 100, 2.50, 'loop',
 'Sand dunes', false, 'May to September', false, false,
 'Walk across golden sand dunes up to 40m high. Sunset views spectacular. No marked trail - navigation skills needed.',
 'Extreme heat. Bring plenty of water. Easy to get disoriented in dunes.'),

(17, 'Trilha da Cachoeira da Velha', 1.00, 'easy', 20, 0.50, 'out_and_back',
 'Sandy, flat', false, 'May to September', true, false,
 'Short walk to massive 100m-wide waterfall. Swimming allowed in designated areas.',
 'Strong currents near waterfall. Swim only in marked safe zones.');

-- Pantanal trails (mostly vehicle-based, limited hiking)
INSERT INTO trails (location_id, trail_name, distance_km, difficulty, elevation_gain, estimated_hours, trail_type, surface_type, marked, best_season, water_available, camping_allowed, description, safety_notes) VALUES
(18, 'Trilha da Lagoa', 3.00, 'easy', 10, 2.00, 'loop',
 'Dirt, can be muddy', true, 'July to September', false, false,
 'Wetland observation trail. Excellent for bird watching and wildlife. Elevated wooden sections over wet areas.',
 'Wildlife caution: jaguars, caimans present. Do not approach wildlife. Go with guide.');

-- ============================================================================
-- CLIMBING ROUTES DATA - Technical climbing routes
-- ============================================================================

-- Chapada Diamantina climbing routes
INSERT INTO climbing_routes (location_id, route_name, difficulty_grade, height_meters, route_type, pitches, estimated_hours, best_season, first_ascent_date, first_ascent_by, description, gear_required, danger_notes) VALUES
(3, 'Via Normal do Pai Inácio', 'II', 320, 'trad', 2, 3.00, 'April to October', '1940-06-15', 'Unknown local climbers',
 'Classic route up the north face. Easy climbing but exposed. Good for beginners with guide.',
 'Standard trad rack, helmet, 60m rope', 'Loose rock in sections. Rockfall danger.'),

(1, 'Morro do Camelo - Nordeste', 'IV', 400, 'trad', 4, 6.00, 'April to October', '1985-08-20', 'Paulo Silva, João Santos',
 'Multi-pitch route on sandstone formation. Technical sections with good protection opportunities.',
 'Full trad rack to #3 camalots, 2x60m ropes, helmet', 'Sandstone can be fragile. Test holds carefully.');

-- Serra dos Órgãos climbing routes
INSERT INTO climbing_routes (location_id, route_name, difficulty_grade, height_meters, route_type, pitches, estimated_hours, best_season, first_ascent_date, first_ascent_by, description, gear_required, danger_notes) VALUES
(6, 'Via Normal do Dedo de Deus', 'V', 600, 'trad', 8, 10.00, 'May to September', '1912-01-06', 'José Teixeira Guimarães and others',
 'Historic first ascent route up Brazil''s most iconic peak. Technical climbing with sustained difficulty. Legendary route.',
 'Full trad rack, nuts, cams to #4, 2x60m ropes, approach shoes', 'Serious commitment. Weather changes rapidly. Several accidents recorded.'),

(6, 'Escalavrada', 'VI+', 650, 'sport', 12, 14.00, 'June to August', '1992-11-15', 'André Ilha, Marcelo Motta',
 'One of Brazil''s hardest long routes. Sustained technical climbing on perfect granite. Advanced climbers only.',
 'Full sport climbing kit, 80m rope, many quickdraws (20+)', 'Committing. Long, hard pitches. Bail options limited.'),

(5, 'Agulha do Diabo - Sudeste', 'IV+', 500, 'trad', 6, 8.00, 'May to September', '1952-03-10', 'Club Excursionista Carioca',
 'Classic granite route with varied climbing. Mix of crack and face climbing. Popular moderate route.',
 'Standard trad rack, 60m rope, helmet', 'Some loose blocks. Afternoon thunderstorms common.'),

(4, 'Pedra do Açu - Face Norte', 'III', 280, 'trad', 3, 4.00, 'May to September', '1970-07-22', 'Unknown',
 'Fun moderate route with good protection. Popular weekend destination.',
 'Basic trad rack, 60m rope', 'Crowded on good weather weekends.');

-- Serra da Mantiqueira climbing routes
INSERT INTO climbing_routes (location_id, route_name, difficulty_grade, height_meters, route_type, pitches, estimated_hours, best_season, first_ascent_date, first_ascent_by, description, gear_required, danger_notes) VALUES
(7, 'Paredão da Bandeira - Via Direta', 'IV', 380, 'alpine', 5, 7.00, 'May to September', '1965-08-15', 'Expedição Mineira',
 'Alpine route on the main face of Pico da Bandeira. High altitude. Cold conditions possible.',
 'Alpine rack, ice axe (winter), crampons (winter), warm layers', 'Altitude effects common above 2,500m. Freezing conditions possible year-round.'),

(9, 'Cristal - Aresta Sul', 'V', 420, 'alpine', 6, 9.00, 'June to August', '1975-06-20', 'Pedro Hauck',
 'Technical ridge climb with exposure. Beautiful but serious. Weather critical.',
 'Full alpine rack, rope, helmet, warm gear', 'Extreme exposure. Lightning danger. Rapid weather changes.');

-- Aparados da Serra climbing (limited due to conservation)
INSERT INTO climbing_routes (location_id, route_name, difficulty_grade, height_meters, route_type, pitches, estimated_hours, best_season, first_ascent_date, first_ascent_by, description, gear_required, danger_notes) VALUES
(10, 'Cascata Véu de Noiva - Via Lateral', 'III', 180, 'trad', 2, 3.00, 'November to February', '1998-12-10', 'Grupo Cambará',
 'Climb alongside waterfall. Wet conditions common. Limited access.',
 'Standard rack, helmet, expect wet rock', 'Slippery when wet. Waterfall spray. Check park regulations.');

-- ============================================================================
-- WEATHER DATA - Historical weather for locations
-- ============================================================================
-- Sample weather data for multiple locations across different months

-- Chapada Diamantina (Location 1) - Dry season samples
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(1, '2025-05-15', 16.5, 28.3, 0.0, 65, 12.5, 'SE', 'sunny', 25.0, 1015),
(1, '2025-06-15', 14.2, 26.8, 0.0, 60, 10.2, 'E', 'sunny', 25.0, 1018),
(1, '2025-07-15', 13.8, 25.5, 0.0, 58, 11.8, 'SE', 'sunny', 25.0, 1020),
(1, '2025-08-15', 15.1, 27.2, 0.0, 55, 13.2, 'E', 'sunny', 25.0, 1017),
(1, '2025-09-15', 16.8, 29.1, 5.2, 62, 14.5, 'SE', 'partly_cloudy', 22.0, 1014);

-- Chapada Diamantina - Wet season samples  
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(1, '2025-11-15', 18.5, 27.8, 35.5, 78, 15.2, 'NE', 'rainy', 12.0, 1010),
(1, '2025-12-15', 19.2, 28.5, 58.3, 82, 16.8, 'NE', 'rainy', 10.0, 1008),
(1, '2026-01-15', 19.8, 29.2, 85.6, 85, 18.2, 'N', 'stormy', 8.0, 1006),
(1, '2026-02-15', 19.5, 28.8, 72.4, 84, 17.5, 'NE', 'rainy', 9.0, 1007),
(1, '2026-03-15', 18.8, 28.1, 45.2, 80, 15.8, 'E', 'rainy', 11.0, 1009);

-- Serra dos Órgãos (Location 4) - Mountain weather
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(4, '2025-05-15', 12.5, 22.3, 12.0, 75, 18.5, 'S', 'partly_cloudy', 15.0, 1012),
(4, '2025-06-15', 10.2, 20.1, 5.2, 70, 16.2, 'S', 'sunny', 20.0, 1015),
(4, '2025-07-15', 8.8, 18.5, 2.1, 68, 15.5, 'SW', 'sunny', 22.0, 1018),
(4, '2025-08-15', 9.5, 19.8, 3.5, 65, 17.2, 'S', 'partly_cloudy', 18.0, 1016),
(4, '2025-09-15', 11.2, 21.5, 18.5, 72, 19.5, 'SE', 'cloudy', 12.0, 1013);

-- Pico da Bandeira (Location 7) - High altitude
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(7, '2025-05-15', 5.2, 15.8, 8.0, 70, 25.5, 'W', 'partly_cloudy', 18.0, 980),
(7, '2025-06-15', 2.1, 13.2, 0.0, 65, 22.2, 'W', 'sunny', 25.0, 985),
(7, '2025-07-15', -1.5, 11.5, 0.0, 60, 28.5, 'W', 'sunny', 30.0, 988),
(7, '2025-08-15', 0.8, 12.8, 0.0, 58, 26.8, 'SW', 'sunny', 28.0, 986),
(7, '2025-09-15', 3.5, 14.5, 5.5, 68, 24.2, 'W', 'partly_cloudy', 20.0, 982);

-- Aparados da Serra (Location 10) - Canyon region
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(10, '2025-10-15', 13.5, 23.8, 15.2, 78, 20.5, 'E', 'partly_cloudy', 12.0, 1010),
(10, '2025-11-15', 15.2, 25.5, 45.8, 82, 22.8, 'NE', 'rainy', 10.0, 1008),
(10, '2025-12-15', 16.8, 27.2, 68.5, 85, 24.2, 'E', 'rainy', 8.0, 1006),
(10, '2026-01-15', 17.5, 28.5, 95.2, 88, 25.5, 'NE', 'stormy', 6.0, 1004),
(10, '2026-02-15', 16.2, 26.8, 78.5, 86, 23.8, 'E', 'rainy', 9.0, 1007);

-- Jalapão (Location 15) - Savanna climate
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(15, '2025-05-15', 19.5, 32.8, 0.0, 45, 15.5, 'E', 'sunny', 30.0, 1012),
(15, '2025-06-15', 17.8, 31.2, 0.0, 40, 14.2, 'E', 'sunny', 30.0, 1015),
(15, '2025-07-15', 16.5, 30.5, 0.0, 38, 13.8, 'SE', 'sunny', 30.0, 1016),
(15, '2025-08-15', 18.2, 33.5, 0.0, 35, 16.5, 'E', 'sunny', 30.0, 1014),
(15, '2025-09-15', 20.5, 35.2, 2.5, 42, 18.2, 'E', 'sunny', 28.0, 1012);

-- Pantanal (Location 18) - Wetland
INSERT INTO weather_data (location_id, date_recorded, temperature_min_c, temperature_max_c, rainfall_mm, humidity_percent, wind_speed_kmh, wind_direction, conditions, visibility_km, pressure_hpa) VALUES
(18, '2025-07-15', 18.5, 28.5, 0.0, 60, 10.5, 'N', 'sunny', 25.0, 1018),
(18, '2025-08-15', 20.2, 31.2, 0.0, 55, 12.2, 'N', 'sunny', 25.0, 1016),
(18, '2025-09-15', 22.5, 33.8, 5.2, 62, 14.5, 'NE', 'partly_cloudy', 20.0, 1014),
(18, '2025-10-15', 23.8, 35.2, 35.8, 72, 15.8, 'N', 'rainy', 15.0, 1010);

-- ============================================================================
-- GEAR CATEGORIES DATA - Outdoor equipment categories
-- ============================================================================

-- Main categories
INSERT INTO gear_categories (category_name, parent_category_id, description) VALUES
('Camping Equipment', NULL, 'Tents, sleeping bags, camping furniture and accessories'),
('Backpacks & Bags', NULL, 'Hiking backpacks, daypacks, duffels, and luggage'),
('Climbing Gear', NULL, 'Ropes, harnesses, carabiners, and technical climbing equipment'),
('Footwear', NULL, 'Hiking boots, trail running shoes, approach shoes, sandals'),
('Clothing', NULL, 'Outdoor apparel for hiking, camping, and climbing'),
('Navigation & Safety', NULL, 'GPS devices, compasses, first aid kits, emergency gear'),
('Cooking & Hydration', NULL, 'Stoves, cookware, water filters, hydration systems'),
('Lighting', NULL, 'Headlamps, lanterns, flashlights');

-- Subcategories
INSERT INTO gear_categories (category_name, parent_category_id, description) VALUES
-- Camping subcategories
('Tents', 1, 'Backpacking tents, family tents, ultralight shelters'),
('Sleeping Bags', 1, 'Down and synthetic sleeping bags for various temperatures'),
('Sleeping Pads', 1, 'Air pads, foam pads, self-inflating mats'),
('Camp Furniture', 1, 'Chairs, tables, hammocks'),

-- Backpack subcategories
('Hiking Backpacks', 2, 'Multi-day hiking packs 50-80L'),
('Daypacks', 2, '15-35L packs for day hikes'),
('Ultralight Packs', 2, 'Lightweight minimalist packs'),

-- Climbing subcategories
('Ropes & Slings', 3, 'Dynamic ropes, static ropes, webbing, slings'),
('Protection', 3, 'Cams, nuts, hexes, tricams'),
('Carabiners & Quickdraws', 3, 'Locking and non-locking carabiners, quickdraws'),
('Harnesses', 3, 'Climbing harnesses and helmets'),

-- Footwear subcategories
('Hiking Boots', 4, 'Full leather and synthetic hiking boots'),
('Trail Running Shoes', 4, 'Lightweight trail runners'),

-- Clothing subcategories
('Rain Gear', 5, 'Rain jackets, rain pants, ponchos'),
('Insulation', 5, 'Down jackets, fleece, synthetic insulation'),
('Base Layers', 5, 'Merino wool and synthetic base layers');

-- ============================================================================
-- OUTDOOR GEAR DATA - Brazilian market outdoor equipment
-- ============================================================================

-- TENTS --
INSERT INTO outdoor_gear (category_id, gear_name, brand, model_number, price_brl, weight_grams, dimensions, capacity_people, material, color, availability, store_name, store_url, description, features) VALUES
(9, 'Barraca Nautika Apache GT 5/6 Pessoas', 'Nautika', 'APACHE-GT-5/6', 1299.90, 5500, '220 x 250 x 160 cm', 6, 'Poliéster 190T, piso 210D', 'Verde/Cinza', 'in_stock', 'Decathlon Brasil',
 'https://www.decathlon.com.br', 
 'Barraca familiar espaçosa com varanda. Ideal para camping em família. Sistema de ventilação avançado. Impermeabilidade 2000mm.',
 'Varanda coberta, bolsos internos, janelas com tela, saia de proteção, costuras seladas'),

(9, 'Barraca Azteq Katmandu 2/3 Pessoas', 'Azteq', 'KATMANDU-2/3', 489.90, 2800, '210 x 150 x 110 cm', 3, 'Poliéster 190T, piso 210D', 'Laranja/Cinza', 'in_stock', 'Amazon Brasil',
 'https://www.amazon.com.br',
 'Barraca tipo iglu para trekking. Boa relação custo-benefício. Fácil montagem. Impermeabilidade 1500mm.',
 '2 portas, ventilação dupla, bolsos internos, sobreteto impermeável'),

(9, 'Barraca NTK Cherokee GT 5/6 Pessoas', 'NTK', 'CHEROKEE-GT-5/6', 899.00, 4800, '305 x 205 x 165 cm', 6, 'Poliéster 190T', 'Verde', 'in_stock', 'Carrefour',
 'https://www.carrefour.com.br',
 'Barraca família com grande espaço interno. Ótima ventilação. Varanda ampla.',
 'Varanda, divisória removível, janelas grandes, costuras seladas'),

(9, 'Barraca Camping Dome 4 Pessoas Coleman', 'Coleman', 'DOME-4P', 649.90, 4200, '210 x 240 x 130 cm', 4, 'Poliéster', 'Azul/Cinza', 'in_stock', 'Magazine Luiza',
 'https://www.magazineluiza.com.br',
 'Barraca tradicional Coleman com tecnologia WeatherTec. Resistente a chuvas. Montagem rápida.',
 'Sistema WeatherTec, ventilação ajustável, bolsos de armazenamento'),

(9, 'Barraca Ultralight 2P Naturehike Cloud-Up', 'Naturehike', 'CLOUD-UP-2', 899.00, 1500, '210 x 130 x 110 cm', 2, 'Nylon 20D siliconizado', 'Cinza', 'in_stock', 'Trilhas & Rumos',
 'https://www.trilhaserumos.com.br',
 'Barraca ultraleve para trekking. Design free-standing. Excelente para longas caminhadas. Impermeabilidade 4000mm.',
 'Varetas de alumínio, dupla camada, ultra compacta, alta impermeabilidade');

-- SLEEPING BAGS --
INSERT INTO outdoor_gear (category_id, gear_name, brand, model_number, price_brl, weight_grams, temperature_rating, material, color, availability, store_name, store_url, description, features) VALUES
(10, 'Saco de Dormir Nautika Viper 5°C', 'Nautika', 'VIPER-5C', 279.90, 1400, 5, 'Poliéster com isolamento hollow fiber', 'Azul', 'in_stock', 'Decathlon Brasil',
 'https://www.decathlon.com.br',
 'Saco de dormir tipo sarcófago. Temperatura de conforto 5°C. Bom para camping de montanha.',
 'Capuz ajustável, zíper duplo, saco de compressão incluso, isolamento sintético'),

(10, 'Saco de Dormir NTK Apache -1°C a -3°C', 'NTK', 'APACHE-N1', 189.90, 1600, -1, 'Poliéster', 'Verde', 'in_stock', 'Amazon Brasil',
 'https://www.amazon.com.br',
 'Saco de dormir com boa proteção térmica. Ideal para regiões frias. Excelente custo-benefício.',
 'Temperatura extrema -3°C, capuz, colarinho térmico, saco de compressão'),

(10, 'Saco de Dormir Azteq Everest -8°C', 'Azteq', 'EVEREST-N8', 449.90, 1850, -8, 'Nylon com isolamento hollow fiber', 'Vermelho/Preto', 'in_stock', 'Netshoes',
 'https://www.netshoes.com.br',
 'Saco de dormir para temperaturas muito baixas. Ideal para Serra da Mantiqueira e Serra dos Órgãos no inverno.',
 'Temperatura extrema -8°C, duplo zíper, capuz com cordão, compacto'),

(10, 'Sleeping Bag Down 800 Deuter -10°C', 'Deuter', 'DOWN-800-N10', 1899.00, 980, -10, 'Down 800-fill power', 'Laranja', 'in_stock', 'Toca do Lobo',
 'https://www.tocadolobo.com.br',
 'Saco de dormir com pluma de ganso 800. Ultralight e super quente. Para expedições e alta montanha.',
 'Pluma de ganso 800, resistente à água, ultra compacto, temperatura extrema -10°C');

-- BACKPACKS --
INSERT INTO outdoor_gear (category_id, gear_name, brand, model_number, price_brl, volume_liters, weight_grams, material, color, availability, store_name, store_url, description, features) VALUES
(14, 'Mochila Cargueira Trilhas & Rumos Atacama 60+10L', 'Trilhas & Rumos', 'ATACAMA-60', 549.90, 70, 2100, 'Nylon 600D', 'Laranja', 'in_stock', 'Trilhas & Rumos',
 'https://www.trilhaserumos.com.br',
 'Mochila cargueira para trekking de vários dias. Sistema de ajuste de tronco. Compartimento para saco de hidratação.',
 'Sistema de ventilação nas costas, cinto acolchoado, compartimento inferior separado, capa de chuva inclusa'),

(14, 'Mochila Deuter Futura 32L', 'Deuter', 'FUTURA-32', 899.00, 32, 1540, 'Nylon Ripstop', 'Verde/Azul', 'in_stock', 'Decathlon Brasil',
 'https://www.decathlon.com.br',
 'Mochila para caminhadas de 1 dia. Sistema Aircomfort para ventilação das costas. Muito confortável.',
 'Sistema Aircomfort, compartimento para hidratação, bolsos laterais, rain cover'),

(14, 'Mochila Ataque Doite Fastpacking Pro 20L', 'Doite', 'FASTPACK-20', 399.00, 20, 580, 'Nylon ultraleve', 'Preto/Vermelho', 'in_stock', 'Kanui',
 'https://www.kanui.com.br',
 'Mochila minimalista para fastpacking e trail running. Ultralight. Bolsos frontais elásticos.',
 'Ultralight, bolsos frontais, compartimento hidratação, sistema de ajuste de tronco'),

(13, 'Mochila Cargueira Azteq Elbrus 80L', 'Azteq', 'ELBRUS-80', 699.00, 80, 2400, 'Nylon 420D', 'Azul', 'in_stock', 'Amazon Brasil',
 'https://www.amazon.com.br',
 'Mochila grande para expedições longas. Excelente capacidade de carga. Reforçada.',
 'Grande capacidade, múltiplos compartimentos, sistema de suporte de carga, capa de chuva');

-- CLIMBING GEAR --
INSERT INTO outdoor_gear (category_id, gear_name, brand, model_number, price_brl, weight_grams, material, color, availability, store_name, store_url, description, features) VALUES
(20, 'Cadeirinha/Baudrier Black Diamond Momentum', 'Black Diamond', 'MOMENTUM-M', 549.00, 385, 'Nylon', 'Azul', 'in_stock', 'Vertical Shop',
 'https://www.verticalshop.com.br',
 'Cadeirinha de escalada versátil para escalada esportiva e tradicional. Confortável e durável.',
 '4 porta-materiais, pernas acolchoadas, ajuste duplo, fácil regulagem'),

(18, 'Corda Dinâmica Maxim Pinnacle 9.5mm 60m', 'Maxim', 'PINNACLE-9.5-60', 1249.00, 3600, 'Nylon dry treated', 'Verde/Amarelo', 'in_stock', 'Vertical Shop',
 'https://www.verticalshop.com.br',
 'Corda dinâmica com tratamento dry. Ótima para escalada em múltiplas vias. Durabilidade excelente.',
 'Tratamento dry, certificação UIAA, middle mark, 9.5mm diâmetro'),

(19, 'Mosquetão com Trava Black Diamond Positron', 'Black Diamond', 'POSITRON', 89.00, 58, 'Alumínio', 'Prata', 'in_stock', 'Vertical Shop',
 'https://www.verticalshop.com.br',
 'Mosquetão de segurança com trava de rosca. Resistência 24kN.',
 'Trava de rosca, gate de arame, leve, certificação CE/UIAA'),

(19, 'Set 12 Quickdraws Petzl Ange', 'Petzl', 'ANGE-SET-12', 2199.00, 1260, 'Alumínio', 'Colorido', 'in_stock', 'Toca do Lobo',
 'https://www.tocadolobo.com.br',
 'Set completo de 12 expressas ultralight. Ideal para escalada esportiva e competição.',
 'Ultra leves, gate de arame, fitas de diferentes comprimentos, resistência 20kN');

-- FOOTWEAR --
INSERT INTO outdoor_gear (category_id, gear_name, brand, model_number, price_brl, weight_grams, material, color, availability, store_name, store_url, description, features) VALUES
(21, 'Bota Salomon Quest 4 GTX', 'Salomon', 'QUEST-4-GTX', 1499.00, 1200, 'Couro/sintético, GORE-TEX', 'Cinza/Azul', 'in_stock', 'Centauro',
 'https://www.centauro.com.br',
 'Bota de trekking top de linha. Impermeável GORE-TEX. Excelente suporte de tornozelo. Ideal para longas caminhadas.',
 'GORE-TEX, solado Contagrip, suporte de tornozelo, sistema de amarração Quicklace'),

(21, 'Bota Merrell Moab 2 Mid GTX', 'Merrell', 'MOAB-2-MID-GTX', 899.00, 1050, 'Couro/mesh, GORE-TEX', 'Marrom', 'in_stock', 'Amazon Brasil',
 'https://www.amazon.com.br',
 'Bota clássica para trekking. Muito confortável. Boa tração. Best-seller mundial.',
 'GORE-TEX, palmilha Kinetic Fit, solado Vibram, proteção de dedos'),

(22, 'Tênis Trail Running Asics Gel-Venture 9', 'Asics', 'GEL-VENTURE-9', 449.00, 680, 'Sintético/mesh', 'Preto/Laranja', 'in_stock', 'Netshoes',
 'https://www.netshoes.com.br',
 'Tênis de trail running versátil. Boa tração. Confortável para longas distâncias.',
 'Tecnologia GEL, solado com travas, respirável, amortecimento'),

(22, 'Tênis Trail La Sportiva Bushido II', 'La Sportiva', 'BUSHIDO-II', 1099.00, 590, 'Sintético respirável', 'Verde/Preto', 'in_stock', 'Vertical Shop',
 'https://www.verticalshop.com.br',
 'Tênis técnico de trail running para terrenos difíceis. Ultra aderência. Usado por atletas profissionais.',
 'Solado FriXion, proteção de dedos, drop 6mm, suporte lateral');

-- ============================================================================
-- GEAR REVIEWS DATA - User reviews
-- ============================================================================

-- Reviews for Nautika Apache tent
INSERT INTO gear_reviews (gear_id, user_name, rating, review_title, review_text, verified_purchase, date_posted, helpful_count, location_used, duration_used) VALUES
(1, 'Carlos Mendes', 5, 'Excelente para família na Chapada',
 'Usei essa barraca no camping Vale do Capão (Chapada Diamantina) por 5 dias. Espaçosa, resistiu bem a chuvas fortes. A varanda é ótima para deixar mochilas e botas. Montagem fácil, cerca de 15 minutos. Único ponto negativo é o peso, mas para camping de carro não é problema.',
 true, '2025-09-20', 15, 'Chapada Diamantina, BA', '5 dias'),

(1, 'Ana Paula Silva', 4, 'Boa barraca, mas pesada',
 'Qualidade excelente da Nautika. Usamos no litoral de SP e em Campos do Jordão. Impermeável de verdade! Mas é pesada para trekking. Recomendo para camping de carro.',
 true, '2025-08-15', 8, 'Campos do Jordão, SP', '3 meses'),

(1, 'Roberto Luz', 5, 'Melhor custo-benefício',
 'Já tive barracas mais caras e essa supera em funcionalidade. A ventilação é excelente, não condensa. Usamos com 5 adultos confortavelmente.',
 true, '2025-07-10', 12, 'Serra dos Órgãos, RJ', '1 ano');

-- Reviews for Azteq Katmandu tent
INSERT INTO gear_reviews (gear_id, user_name, rating, review_title, review_text, verified_purchase, date_posted, helpful_count, location_used, duration_used) VALUES
(2, 'João Trekking', 4, 'Ótima para iniciantes',
 'Primeira barraca de trekking e não decepcionou. Usei na trilha do Pico da Bandeira. Montagem simples, relativamente leve. Impermeabilização boa, mas não excelente.',
 true, '2025-09-05', 6, 'Pico da Bandeira, MG', '2 usos'),

(2, 'Mariana Costa', 3, 'Boa mas tem limitações',
 'Para o preço está ok. Resistiu a uma chuva leve, mas em tempestade forte molhou um pouco. Espaço interno justo para 2 pessoas + mochilas.',
 true, '2025-08-22', 4, 'Aparados da Serra, RS', '1 uso');

-- Reviews for Naturehike ultralight tent
INSERT INTO gear_reviews (gear_id, user_name, rating, review_title, review_text, verified_purchase, date_posted, helpful_count, location_used, duration_used) VALUES
(5, 'Pedro Ultralight', 5, 'Incrível! Muito leve!',
 'Com 1.5kg é perfeita para fastpacking. Fiz a travessia da Chapada em 4 dias levando essa barraca. Resistente, impermeável, compacta. Vale cada centavo!',
 true, '2025-09-18', 22, 'Chapada Diamantina, BA', '6 meses'),

(5, 'Lucas Montanha', 5, 'Top para alta montanha',
 'Levei para o Pico da Bandeira no inverno. Resistiu a ventos fortes de 40km/h e temperatura de -2°C. Condensação mínima. Recomendo!',
 true, '2025-07-25', 18, 'Pico da Bandeira, MG', '4 meses');

-- Reviews for sleeping bags
INSERT INTO gear_reviews (gear_id, user_name, rating, review_title, review_text, verified_purchase, date_posted, helpful_count, location_used, duration_used) VALUES
(6, 'Fernando Camping', 4, 'Confortável até 7°C',
 'Testei esse saco na Serra dos Órgãos com temperatura de 7°C e fiquei confortável com roupa térmica. Abaixo disso precisa de roupa extra. Bom custo-benefício.',
 true, '2025-08-30', 9, 'Serra dos Órgãos, RJ', '3 meses'),

(8, 'Cláudio Aventura', 5, 'Muito quente!',
 'Comprei para usar no Caparaó no inverno. Com -5°C dormi tranquilo. Qualidade top Azteq!',
 true, '2025-07-18', 11, 'Parque Nacional do Caparaó', '2 meses'),

(9, 'Ricardo High Mountain', 5, 'Down 800 é outro nível',
 'Saco de dormir premium. Ultralight e super quente. Uso em todas expedições de alta montanha. Investimento que vale a pena.',
 true, '2025-06-10', 25, 'Pico da Bandeira e Pico do Cristal', '8 meses');

-- Reviews for backpacks
INSERT INTO gear_reviews (gear_id, user_name, rating, review_title, review_text, verified_purchase, date_posted, helpful_count, location_used, duration_used) VALUES
(10, 'Gabriel Trilheiro', 5, 'Mochila top nacional',
 'Marca brasileira com qualidade internacional. Fiz 7 dias na Chapada com essa mochila levando 18kg. Confortável, bem distribuído. Sistema de ventilação funciona!',
 true, '2025-09-12', 14, 'Chapada Diamantina, BA', '5 meses'),

(11, 'Paula Montanhista', 5, 'Deuter nunca decepciona',
 'Melhor mochila de 1 dia que já tive. O sistema Aircomfort realmente ventila as costas. Uso em todas trilhas.',
 true, '2025-08-28', 10, 'Várias regiões', '1 ano'),

(13, 'Bruno Expedição', 4, 'Ótima capacidade',
 '80L comporta tudo para expedições longas. Levei para Jalapão por 10 dias. Aguentou bem. Única ressalva: poderia ter mais bolsos externos.',
 true, '2025-07-05', 7, 'Jalapão, TO', '10 dias');

-- ============================================================================
-- END OF PART 2
-- ============================================================================

DO $$
DECLARE
    trail_count INTEGER;
    route_count INTEGER;
    weather_count INTEGER;
    category_count INTEGER;
    gear_count INTEGER;
    review_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO trail_count FROM trails;
    SELECT COUNT(*) INTO route_count FROM climbing_routes;
    SELECT COUNT(*) INTO weather_count FROM weather_data;
    SELECT COUNT(*) INTO category_count FROM gear_categories;
    SELECT COUNT(*) INTO gear_count FROM outdoor_gear;
    SELECT COUNT(*) INTO review_count FROM gear_reviews;
    
    RAISE NOTICE '✅ Part 2 data inserted successfully!';
    RAISE NOTICE 'Trails: %', trail_count;
    RAISE NOTICE 'Climbing Routes: %', route_count;
    RAISE NOTICE 'Weather Records: %', weather_count;
    RAISE NOTICE 'Gear Categories: %', category_count;
    RAISE NOTICE 'Outdoor Gear Items: %', gear_count;
    RAISE NOTICE 'Gear Reviews: %', review_count;
    RAISE NOTICE '';
    RAISE NOTICE '🎉 Brazilian Outdoor Adventure Platform database is complete!';
    RAISE NOTICE 'You can now start practicing SQL queries on real Brazilian outdoor data.';
END $$;
