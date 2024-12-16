-- When are vehicles likely to be stolen?

-- Number of vehicles stolen each year

SELECT YEAR(date_stolen) as Year, 
	   COUNT(*) as Number_of_Stolen_Vehicles
FROM stolen_vehicles
GROUP BY YEAR(date_stolen)

-- Number of vehicles stolen by month

SELECT DATENAME(MONTH, date_stolen) AS Month_of_Year,
       MONTH(date_stolen) AS MonthNum,
       COUNT(*) as Number_of_Stolen_Vehicles
FROM stolen_vehicles
GROUP BY DATENAME(MONTH, date_stolen), MONTH(date_stolen)
ORDER BY MonthNum

-- Number of vehicles stolen each day of the week

SELECT DATENAME(WEEKDAY, date_stolen) AS Day_of_Week,
       COUNT(*) as Number_of_Stolen_Vehicles
FROM stolen_vehicles
GROUP BY DATENAME(WEEKDAY, date_stolen)
ORDER BY 
    CASE DATENAME(WEEKDAY, date_stolen)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;