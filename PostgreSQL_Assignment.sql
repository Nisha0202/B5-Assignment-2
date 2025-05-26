-- Create Database
create DATABASE conservation_db;

-- Connect to Database
\c conservation_db

-- Table: rangers
create table rangers (
ranger_id SERIAL PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  region VARCHAR(50) NOT NULL
);

-- Table: species
create table species (
 species_id SERIAL PRIMARY KEY,
 common_name VARCHAR(40) NOT NULL,
 scientific_name VARCHAR(100) NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status VARCHAR(30) NOT NULL
);

-- Table: sightings
create table sightings (
  sighting_id SERIAL PRIMARY KEY,
 species_id INT REFERENCES species(species_id),
 ranger_id INT REFERENCES rangers(ranger_id),
 sighting_time TIMESTAMP NOT NULL,
  location VARCHAR(100) NOT NULL,
  notes VARCHAR(300)
);

-- Insert rangers
INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

-- Insert species
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Insert sightings
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) values
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- Problem 1:Register a new ranger
insert into rangers (name, region) VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2: count unique species ever sighted
select count(distinct species_id) as unique_species_count from sightings;

-- Problem 3: Find all sightings where the location includes "Pass"
select * from sightings WHERE location ILIKE '%Pass%';

-- Problem 4: List each ranger's name and their total number of sightings
select r.name, count(s.sighting_id) AS total_sightings
from rangers r
join sightings s on r.ranger_id = s.ranger_id
group by r.name;

-- Problem 5: List species that have never been sighted
SELECT s.common_name
FROM species s
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

-- Problem 6: Show the most recent 2 sightings
select sp.common_name, si.sighting_time, r.name from sightings si
join species sp on si.species_id = sp.species_id
join rangers r on si.ranger_id = r.ranger_id
order by si.sighting_time desc
limit 2;

-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'
update species
set conservation_status = 'Historic'
where discovery_date < '1800-01-01';

-- Problem 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'
select sighting_id,
case
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
    else 'Evening'
end as time_of_day
from sightings;


-- Problem 9: Delete rangers who have never sighted any species
delete FROM rangers
where ranger_id not in (select DISTINCT ranger_id from sightings);

























