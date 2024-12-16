-- Which vehicles are likely to be stolen?


-- The vehicle types that are most and least often stolen

SELECT vehicle_type,COUNT(*) AS Number_of_Vehicles_Stolen 
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY Number_of_Vehicles_Stolen DESC;

-- Average age of cars stolen for each vehicle type

SELECT vehicle_type,
       AVG(YEAR(date_stolen) - model_year) AS Average_Age
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY Average_Age;

-- Percentage of luxury and standard vehicles stolen

WITH lux_std AS (SELECT vehicle_type,
CASE  
     WHEN make_type = 'Luxury' THEN 1 ELSE 0 
END AS Luxury,
1 AS All_Cars
FROM stolen_vehicles
INNER JOIN make_details
   ON stolen_vehicles.make_id = make_details.make_id)

SELECT vehicle_type, 
       100*SUM(Luxury)/SUM(All_Cars) AS pc_lux,
	   100-(100*SUM(Luxury)/SUM(All_Cars)) AS pc_std
FROM lux_std
GROUP BY vehicle_type
ORDER BY pc_lux DESC;

-- Vehicles stolen by Type and Colour

SELECT TOP 10 vehicle_type,count(vehicle_id) AS num_vehicles,
       SUM(CASE WHEN color='Silver' THEN 1 ELSE 0 END) AS Silver,
	   SUM(CASE WHEN color='White' THEN 1 ELSE 0 END) AS White,
	   SUM(CASE WHEN color='Black' THEN 1 ELSE 0 END) AS Black,
	   SUM(CASE WHEN color='Blue' THEN 1 ELSE 0 END) AS Blue,
	   SUM(CASE WHEN color='Red' THEN 1 ELSE 0 END) AS Red,
	   SUM(CASE WHEN color='Grey' THEN 1 ELSE 0 END) AS Grey,
	   SUM(CASE WHEN color='Green' THEN 1 ELSE 0 END) AS Green,
	   SUM(CASE WHEN color IN ('Gold','Brown','Yellow','Orange','Purple','Cream','Pink') THEN 1 ELSE 0 END) AS Other
FROM stolen_vehicles 
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
