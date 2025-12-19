/*reset*/
DROP SCHEMA IF EXISTS fitness CASCADE;
CREATE SCHEMA fitness;

/*tables*/
CREATE TABLE fitness.proband (
    proband_id INT PRIMARY KEY,
    age NUMERIC,
    gender VARCHAR(20),
    weight NUMERIC,
    height NUMERIC,
    workout_frequency NUMERIC,
	bmi NUMERIC
);

CREATE TABLE fitness.workout (
    workout_id SERIAL PRIMARY KEY,
	duration NUMERIC,
	calories_burned NUMERIC,
    type VARCHAR(20),    
    proband_id INT NOT NULL REFERENCES fitness.proband(proband_id)
);

CREATE TABLE fitness.nutrition (
    nutrition_id SERIAL PRIMARY KEY,
	water_intake NUMERIC,
	meal_frequency NUMERIC,  
    calories NUMERIC,     
    proband_id INT NOT NULL REFERENCES fitness.proband(proband_id)
);

/*load probands first beacause of reference in other tables*/
COPY fitness.proband(proband_id, age, gender, weight, height, workout_frequency, bmi) 
FROM '/Volumes/Macintosh HD/Datenbanken/Groupwork/proband_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');

COPY fitness.workout(proband_id, duration, calories_burned, type)
FROM '/Volumes/Macintosh HD/Datenbanken/Groupwork/workout_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');

COPY fitness.nutrition(proband_id, water_intake, meal_frequency, calories)
FROM '/Volumes/Macintosh HD/Datenbanken/Groupwork/nutrition_probid.CSV'
WITH (FORMAT csv, HEADER, DELIMITER ',');


SELECT
p.gender, COUNT(*) as n_probands, AVG(n.water_intake) as avg_water_intake
FROM fitness.proband p
JOIN fitness.nutrition n ON p.proband_id = n.proband_id
GROUP BY p.gender ORDER BY p.gender;

