-- ============================================================================
-- BRAZILIAN OUTDOOR ADVENTURE PLATFORM - SAMPLE DATA (PART 1)
-- ============================================================================
-- Version: 1.0
-- Created: October 2025
-- Description: Realistic sample data for Brazilian outdoor locations
-- ============================================================================

-- Clear existing data (maintain referential integrity order)
TRUNCATE TABLE gear_reviews CASCADE;
TRUNCATE TABLE outdoor_gear CASCADE;
TRUNCATE TABLE gear_categories CASCADE;
TRUNCATE TABLE weather_data CASCADE;
TRUNCATE TABLE trails CASCADE;
TRUNCATE TABLE climbing_routes CASCADE;
TRUNCATE TABLE campsites CASCADE;
TRUNCATE TABLE locations CASCADE;
TRUNCATE TABLE regions CASCADE;

-- Reset sequences
ALTER SEQUENCE regions_region_id_seq RESTART WITH 1;
ALTER SEQUENCE locations_location_id_seq RESTART WITH 1;
ALTER SEQUENCE campsites_campsite_id_seq RESTART WITH 1;
ALTER SEQUENCE climbing_routes_route_id_seq RESTART WITH 1;
ALTER SEQUENCE trails_trail_id_seq RESTART WITH 1;
ALTER SEQUENCE weather_data_weather_id_seq RESTART WITH 1;
ALTER SEQUENCE gear_categories_category_id_seq RESTART WITH 1;
ALTER SEQUENCE outdoor_gear_gear_id_seq RESTART WITH 1;
ALTER SEQUENCE gear_reviews_review_id_seq RESTART WITH 1;

-- ============================================================================
-- REGIONS DATA - Brazilian outdoor adventure regions
-- ============================================================================

INSERT INTO regions (region_name, state, description) VALUES
('Chapada Diamantina Region', 'BA', 
 'One of Brazil''s most stunning national parks featuring waterfalls, caves, and plateaus. Located in central Bahia, known for trekking and adventure tourism.'),
 
('Serra dos Órgãos Region', 'RJ', 
 'Mountain range in Rio de Janeiro state, famous for its distinctive peaks resembling organ pipes. Popular for rock climbing and challenging hikes.'),
 
('Serra da Mantiqueira Region', 'MG', 
 'Mountain range spanning Minas Gerais, São Paulo, and Rio de Janeiro. Home to Brazil''s highest peaks including Pico da Bandeira.'),
 
('Aparados da Serra Region', 'RS', 
 'Located on the border of Rio Grande do Sul and Santa Catarina, featuring dramatic canyons and unique Atlantic Forest ecosystems.'),
 
('Serra do Mar Region', 'SP', 
 'Coastal mountain range in São Paulo state with lush Atlantic Forest, waterfalls, and diverse wildlife. Popular for eco-tourism.'),
 
('Jalapão Region', 'TO', 
 'Tocantins savanna region known for golden sand dunes, crystal-clear rivers, and dramatic waterfalls. Remote adventure destination.'),
 
('Pantanal Region', 'MT', 
 'World''s largest tropical wetland area, spanning Mato Grosso and Mato Grosso do Sul. Prime wildlife observation and eco-camping destination.'),
 
('Amazonia Region', 'AM', 
 'Brazilian Amazon rainforest region offering jungle trekking, river expeditions, and wildlife encounters. Base in Amazonas state.');

-- ============================================================================
-- LOCATIONS DATA - Specific outdoor adventure locations
-- ============================================================================

-- Chapada Diamantina locations (Bahia)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(1, 'Parque Nacional da Chapada Diamantina', -12.5833333, -41.3166667, 1200, 'national_park',
 'Brazil''s 4th largest national park, covering 152,000 hectares. Features stunning table-top mountains, waterfalls over 300m high, vast cave systems, and unique rock formations. Major highlights include Cachoeira da Fumaça, Morro do Pai Inácio, and Poço Azul.',
 'Access via Lençóis (main gateway town), 420km from Salvador. Daily bus service available. Rental car recommended for flexibility.',
 'April to October (dry season)'),

(1, 'Vale do Capão', -12.5833333, -41.4500000, 1100, 'trail_system',
 'Picturesque valley community known as a trekking hub. Base for accessing Cachoeira da Fumaça, Riachinho, and various multi-day treks. Alternative hippie community vibe with eco-lodges.',
 'Access from Palmeiras (50km dirt road) or Lençóis (70km). 4WD recommended in rainy season.',
 'Year-round, best April-October'),

(1, 'Morro do Pai Inácio', -12.5277778, -41.4833333, 1150, 'mountain',
 'Iconic table-top mountain offering 360-degree views of Chapada Diamantina. Relatively easy climb, sunset viewpoint extremely popular.',
 'Located 27km from Lençóis on BA-242 highway. Parking available at base.',
 'April to October');

-- Serra dos Órgãos locations (Rio de Janeiro)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(2, 'Parque Nacional da Serra dos Órgãos', -22.4500000, -43.0166667, 1200, 'national_park',
 'One of Brazil''s oldest national parks (est. 1939). Famous for dramatic granite peaks including Dedo de Deus, Pedra do Sino (highest peak at 2,263m), and excellent rock climbing.',
 'Main entrance in Teresópolis, 90km from Rio de Janeiro. Alternative access via Petrópolis.',
 'May to September (dry season)'),

(2, 'Pedra do Sino', -22.4416667, -43.0500000, 2263, 'mountain',
 'Highest peak in Rio de Janeiro state. Challenging 13km trail with 1,670m elevation gain. Summit offers panoramic views.',
 'Trailhead at Teresópolis entrance (Sub-Sede). Required to start before 8 AM. Registration mandatory.',
 'May to September'),

(2, 'Dedo de Deus', -22.4083333, -43.0666667, 1692, 'climbing_area',
 'Iconic finger-shaped peak, one of Brazil''s most recognizable mountains. Popular rock climbing destination with various routes.',
 'Access via Guapimirim. Guide recommended for climbing routes.',
 'April to October');

-- Serra da Mantiqueira locations (Minas Gerais)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(3, 'Pico da Bandeira', -20.4702778, -41.8163889, 2892, 'mountain',
 'Third highest peak in Brazil at 2,892m. Accessible summit with road access to 2,300m. Popular for sunrise hikes and camping.',
 'Access via Alto Caparaó, MG. 4WD vehicle required for upper parking (Tronqueira). 3.5km hike from upper lot.',
 'May to September (dry season)'),

(3, 'Parque Nacional do Caparaó', -20.4166667, -41.8000000, 1800, 'national_park',
 'Home to Pico da Bandeira and Pico do Cristal. 31,800 hectares of Atlantic Forest and high-altitude grasslands. Excellent camping and trekking.',
 'Two main entrances: Alto Caparaó (MG) and Dores do Rio Preto (ES). Registration required at park entrance.',
 'April to October'),

(3, 'Pico do Cristal', -20.4888889, -41.8347222, 2770, 'mountain',
 'Second highest peak in the park. More challenging than Pico da Bandeira. Crystal-clear summit views.',
 'Access via Macieira trail from Tronqueira parking. 4.5km hike, technical sections.',
 'May to September');

-- Aparados da Serra locations (Rio Grande do Sul)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(4, 'Parque Nacional de Aparados da Serra', -29.1833333, -50.1166667, 1200, 'national_park',
 'Features spectacular Itaimbezinho Canyon with 720m vertical walls. Unique ecosystem where Atlantic Forest meets Araucaria Forest.',
 'Access via Cambará do Sul, RS. 18km from town on dirt road. 4WD recommended.',
 'October to March (summer)'),

(4, 'Cânion Itaimbezinho', -29.1666667, -50.1166667, 900, 'trail_system',
 'Most famous canyon in southern Brazil. 5.8km long, 720m deep. Two main trails: Vértice (rim trail) and Cotovelo (descends into canyon).',
 'Within Aparados da Serra National Park. Both trails start from main visitor center.',
 'October to March'),

(4, 'Cânion Fortaleza', -29.2333333, -50.0333333, 1000, 'trail_system',
 'Equally impressive canyon in Serra Geral National Park. Less crowded than Itaimbezinho. 7.5km long with dramatic viewpoints.',
 'Access from Cambará do Sul, 23km on dirt road. Park entrance fee required.',
 'October to March');

-- Serra do Mar locations (São Paulo)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(5, 'Núcleo Santa Virgínia - PESM', -23.3333333, -45.1333333, 800, 'state_park',
 'Part of Serra do Mar State Park, largest protected Atlantic Forest area. Pristine forest, waterfalls, and diverse wildlife. Excellent for multi-day treks.',
 'Access via São Luís do Paraitinga. 4WD required for final approach. Advanced reservation required for camping.',
 'April to October (dry season)'),

(5, 'Trilha do Rio Bonito', -23.3500000, -45.1500000, 900, 'trail_system',
 'Beautiful river trail with swimming holes and waterfalls. 8km round trip through dense Atlantic Forest.',
 'Trailhead at Núcleo Santa Virgínia entrance. Guide recommended for longer routes.',
 'Year-round, avoid heavy rain periods');

-- Jalapão locations (Tocantins)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(6, 'Parque Estadual do Jalapão', -10.5000000, -46.7500000, 600, 'state_park',
 'Remote savanna wilderness with golden sand dunes, fervedouros (natural springs), and dramatic waterfalls. Adventure tourism hotspot.',
 'Access via Palmas (TO) or Barreiras (BA). 4WD essential. Tours recommended for first-time visitors.',
 'May to September (dry season)'),

(6, 'Fervedouro do Ceiça', -10.4833333, -46.7833333, 580, 'camping_area',
 'Natural spring where high water pressure keeps swimmers floating. Crystal-clear water. Camping available nearby.',
 'Located 60km from Mateiros. Accessible by 4WD only.',
 'May to September'),

(6, 'Cachoeira da Velha', -10.4666667, -46.8333333, 550, 'trail_system',
 'Massive waterfall 100m wide. Swimming and camping allowed. One of Jalapão''s main attractions.',
 'Located 50km from Mateiros. Good access road, regular vehicles possible in dry season.',
 'May to September');

-- Pantanal locations (Mato Grosso)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(7, 'Transpantaneira Highway Region', -16.5000000, -56.5000000, 120, 'camping_area',
 'Famous 147km dirt road through Pantanal wetlands. Prime wildlife observation area. Multiple camping and lodge options along route.',
 'Starts in Poconé, MT. Passable in dry season (April-September). Wetlands flood December-March.',
 'July to September (peak dry season)'),

(7, 'Porto Jofre', -17.4666667, -56.7833333, 100, 'camping_area',
 'End point of Transpantaneira Highway. Best area for jaguar sightings in Brazil. River-based camping and lodges.',
 'End of Transpantaneira, 147km from Poconé. Boat access to remote areas.',
 'July to October (jaguar season)');

-- Amazonia locations (Amazonas)
INSERT INTO locations (region_id, location_name, latitude, longitude, elevation, location_type, description, access_info, best_season) VALUES
(8, 'Parque Nacional do Jaú', -1.9166667, -61.8333333, 100, 'national_park',
 'Largest forest national park in Brazil (2.3 million hectares). Remote jungle expedition destination. River-based camping.',
 'Access only by boat from Novo Airão (3-6 hours). Guide mandatory. Advanced expedition planning required.',
 'June to November (less rain)'),

(8, 'Reserva de Desenvolvimento Sustentável Mamirauá', -3.0666667, -64.8166667, 50, 'state_park',
 'Flooded forest ecosystem. World-renowned for sustainable eco-tourism and research. Unique wildlife including pink dolphins.',
 'Access from Tefé by boat (1.5 hours). Only accessible through authorized lodges and tours.',
 'July to October (optimal water levels)');

-- ============================================================================
-- CAMPSITES DATA
-- ============================================================================

-- Chapada Diamantina campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(2, 'Camping Vale do Capão', 50, 25.00, true, true, false, false, false, '+55 75 3344-1234', 'camping@valedocapao.com',
 'Basic camping in the heart of Vale do Capão. Communal bathrooms with hot showers. Walking distance to restaurants and shops. Base for Cachoeira da Fumaça hike.',
 1, 12),

(2, 'Camping Pousada Vento Norte', 30, 35.00, true, true, true, true, true, '+55 75 3344-1156', 'ventonorte@gmail.com',
 'More structured camping with kitchen access and electricity. Part of a pousada (guesthouse) with additional services available. Reserve ahead in peak season.',
 1, 12),

(1, 'Camping Lençóis Municipal', 100, 15.00, true, true, false, false, false, '+55 75 3334-1112', NULL,
 'Municipal campground in Lençóis town. Basic facilities, good for budget travelers. Convenient base for exploring the national park.',
 1, 12),

(3, 'Camping Morro do Pai Inácio', 20, 20.00, true, false, false, false, false, '+55 75 3332-2156', NULL,
 'Small camping area at the base of Pai Inácio. Best for sunset/sunrise viewings. Bring water and supplies.',
 4, 10);

-- Serra dos Órgãos campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(4, 'Camping Açu - Serra dos Órgãos', 60, 30.00, true, true, false, true, true, '+55 21 2742-4050', 'camping@parqueserradosorgaos.com',
 'Official park campground near Teresópolis entrance. Well-maintained facilities. Base for Pedra do Sino climb. Advanced reservation recommended for weekends.',
 1, 12),

(5, 'Camping do Centro de Visitantes', 40, 25.00, true, true, false, false, true, '+55 21 2742-4050', NULL,
 'Camping at visitor center. Good starting point for day hikes. Rangers on site for trail information.',
 1, 12),

(4, 'Camping Petrópolis - PARNASO', 35, 28.00, true, true, false, false, true, '+55 24 2233-1100', 'petropolis@parnaso.gov.br',
 'Alternative park entrance camping near Petrópolis. Less crowded than Teresópolis side. Access to different trail network.',
 1, 12);

-- Serra da Mantiqueira campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(7, 'Camping Tronqueira', 80, 40.00, true, true, false, false, true, '+55 32 3747-2555', 'camping@caparao.com',
 'Base camp at 1,900m elevation. Starting point for Pico da Bandeira summit hikes. Cold nights - bring warm sleeping bag. Popular for sunrise hikes.',
 1, 12),

(7, 'Camping Terreirão', 100, 35.00, true, true, true, true, true, '+55 32 3747-2555', 'caparao@icmbio.gov.br',
 'Lower elevation campground (1,200m) with full facilities. Good for acclimatization before summit attempts. Kitchen and electrical outlets available.',
 1, 12),

(8, 'Camping Casa Queimada', 50, 38.00, true, true, false, false, true, '+55 32 3747-2655', NULL,
 'Mid-elevation camping (1,600m). Midpoint between Terreirão and Tronqueira. Less crowded alternative.',
 5, 9);

-- Aparados da Serra campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(10, 'Camping Gralha Azul', 40, 32.00, true, true, false, true, true, '+55 54 3251-1320', 'gralhaazul@aparados.com',
 'Well-maintained camping near Itaimbezinho Canyon. Cold nights even in summer - temperatures can drop to 0°C. Hot showers available.',
 10, 3),

(10, 'Camping do Parque - Aparados', 30, 28.00, true, false, false, false, true, '+55 54 3251-1262', 'camping@icmbio.gov.br',
 'Official park camping. Basic facilities. Bring all supplies from Cambará do Sul (18km away).',
 10, 3);

-- Serra do Mar campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(13, 'Camping Santa Virgínia', 24, 45.00, true, true, false, false, true, '+55 12 3671-9999', 'nucleo.santavirginia@fflorestal.sp.gov.br',
 'Restricted camping in pristine Atlantic Forest. Maximum 24 people per night. Advanced reservation mandatory (30 days). Eco-tourism certified.',
 1, 12);

-- Jalapão campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(16, 'Camping Fervedouro Ceiça', 40, 20.00, true, false, false, false, false, '+55 63 3577-1200', NULL,
 'Rustic camping near fervedouro (natural spring). Basic toilet facilities only. Bring all water and supplies. Remote location.',
 5, 9),

(17, 'Camping Cachoeira da Velha', 60, 18.00, true, false, false, false, false, '+55 63 3577-1200', 'jalapao@naturatins.to.gov.br',
 'Camping at the waterfall. Swimming allowed. Very basic facilities. Popular with 4WD expedition groups.',
 5, 9),

(15, 'Camping Korubo - Jalapão', 35, 50.00, true, true, true, false, true, '+55 63 3577-1305', 'korubo@jalapao.com',
 'More structured private camping with better facilities. Organized tours available. Solar power for charging devices.',
 5, 9);

-- Pantanal campsites
INSERT INTO campsites (location_id, campsite_name, capacity, price_per_night, has_toilet, has_shower, has_kitchen, has_electricity, reservation_required, contact_phone, contact_email, description, season_open_start, season_open_end) VALUES
(18, 'Camping Araras Eco Lodge', 30, 80.00, true, true, true, true, true, '+55 65 3345-1390', 'araras@pantanal.com',
 'Upscale camping at eco-lodge along Transpantaneira. Excellent wildlife viewing. Full amenities. Guided tours available.',
 4, 11),

(19, 'Camping Porto Jofre', 25, 90.00, true, true, false, true, true, '+55 65 3637-1263', 'portojofre@pantanal.com',
 'Prime jaguar observation location. River-based camping. Boat tours essential for wildlife viewing. Book months ahead for July-September.',
 4, 10);

-- ============================================================================
-- END OF PART 1
-- ============================================================================

DO $$
DECLARE
    region_count INTEGER;
    location_count INTEGER;
    campsite_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO region_count FROM regions;
    SELECT COUNT(*) INTO location_count FROM locations;
    SELECT COUNT(*) INTO campsite_count FROM campsites;
    
    RAISE NOTICE '✅ Part 1 data inserted successfully!';
    RAISE NOTICE 'Regions: %', region_count;
    RAISE NOTICE 'Locations: %', location_count;
    RAISE NOTICE 'Campsites: %', campsite_count;
    RAISE NOTICE '';
    RAISE NOTICE 'Next: Run data_insert_part2.sql for trails, climbing routes, and weather data';
END $$;
