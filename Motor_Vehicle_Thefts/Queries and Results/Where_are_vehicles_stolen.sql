-- Identify where vehicles are likely to be stolen


-- Number of vehicles stolen in each region

SELECT region, COUNT(vehicle_id) AS num_vehicles_stolen from stolen_vehicles
LEFT JOIN locations
     ON stolen_vehicles.location_id = locations.location_id
GROUP BY region
ORDER BY num_vehicles_stolen DESC;

-- Population and Density Statistics for Each Region

SELECT region,population,density, 
       COUNT(vehicle_id) AS num_vehicles_stolen 
FROM stolen_vehicles
LEFT JOIN locations
     ON stolen_vehicles.location_id = locations.location_id
GROUP BY region,population,density
ORDER BY num_vehicles_stolen DESC;

-- Types of vehicles stolen in most and least dense regions

SELECT 'High Density' AS region_density, vehicle_type, num_vehicles_stolen
FROM (
    SELECT TOP 5 vehicle_type, COUNT(vehicle_id) AS num_vehicles_stolen
    FROM stolen_vehicles
    LEFT JOIN locations
         ON stolen_vehicles.location_id = locations.location_id
    WHERE region IN ('Auckland', 'Nelson', 'Wellington')
    GROUP BY vehicle_type
    ORDER BY COUNT(vehicle_id) DESC
) AS HighDensityData

UNION

SELECT 'Low Density' AS region_density, vehicle_type, num_vehicles_stolen
FROM (
    SELECT TOP 5 vehicle_type, COUNT(vehicle_id) AS num_vehicles_stolen
    FROM stolen_vehicles
    LEFT JOIN locations
         ON stolen_vehicles.location_id = locations.location_id
    WHERE region IN ('Southland', 'Gisborne', 'Otago')
    GROUP BY vehicle_type
    ORDER BY COUNT(vehicle_id) DESC
) AS LowDensityData

ORDER BY num_vehicles_stolen DESC
