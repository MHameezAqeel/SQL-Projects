DELETE FROM Retail_Sales_Data
WHERE quantiy IS NULL
AND price_per_unit IS NULL
AND cogs IS NULL
AND total_sale IS NULL

-- Data Exploration

-- How many sales do we have?

SELECT COUNT(*) AS Total_Sales FROM Retail_Sales_Data 

-- How many customers do we have?

SELECT COUNT(DISTINCT customer_id) AS Total_Customers 
FROM Retail_Sales_Data

-- Which categories do we have?

SELECT DISTINCT category FROM Retail_Sales_Data

-- BUSINESS CASE PROBLEMS

-- 1) Retrieve all sales made on '2022-11-05'.

SELECT * FROM Retail_Sales_Data
WHERE sale_date = '2022-11-05'

/* 2) Retrieve all transactions for clothing category where quantity is not less than 4	
	  for the month of November.        */	

SELECT * FROM Retail_Sales_Data
WHERE category = 'Clothing' 
AND quantiy >=4
AND MONTH(sale_date) = 11

-- 3) Calcuate the total sales for each category.

SELECT category,SUM(total_sale) AS Total_Sales 
FROM Retail_Sales_Data
GROUP BY category

-- 4) Find the average age of customers who bought from beauty category.

SELECT AVG(age) AS Average_Age 
FROM Retail_Sales_Data
WHERE category = 'Beauty'

-- 5) Find all transactions where the sale exceeds or equals $2000.

SELECT * FROM Retail_Sales_Data
WHERE total_sale >= 2000

-- 6) Find the number of transaction for both genders in each category.

SELECT category,gender,COUNT(*) AS Total_Transactions 
FROM Retail_Sales_Data
GROUP BY category,gender

-- 7) Calculate the average sale for each month. Which was the best selling month?

SELECT DATENAME(MONTH,sale_date) AS Month_of_Year, AVG(total_sale) AS Average_Sales
FROM Retail_Sales_Data
GROUP BY DATENAME(MONTH,sale_date)
ORDER BY Average_Sales DESC

-- 8) Find the Top 5 highest paying customers.

SELECT TOP 5 customer_id, SUM(total_sale) AS Total_Sale
FROM Retail_Sales_Data
GROUP BY customer_id
ORDER BY Total_Sale DESC

-- 9) For each category, find the number of unique customers who purachased items.

SELECT category, COUNT(DISTINCT customer_id) AS Unique_Customers
FROM Retail_Sales_Data
GROUP BY category
ORDER BY 2 DESC

-- 10) For 4 shifts of 6 hours each, find total orders for each shift.

SELECT Shift,COUNT(transactions_id) AS Number_of_Orders FROM 
(SELECT *,CASE 
	WHEN DATEPART(HOUR,sale_time) BETWEEN 5 AND 11 THEN 'Shift 1'
	WHEN DATEPART(HOUR,sale_time) BETWEEN 11 AND 17 THEN 'Shift 2'
	WHEN DATEPART(HOUR,sale_time) BETWEEN 17 AND 23 THEN 'Shift 3'
	ELSE 'Shift 4'
END AS Shift
FROM Retail_Sales_Data
) AS Shift_Table
GROUP BY Shift