-- Products Segmentation

WITH Cost_Segments AS (
SELECT product_name,cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost >= 100 AND cost < 500 THEN 'Between 100 and 500'	
	 WHEN cost >= 500 AND cost < 1000 THEN 'Between 500 and 1000'
	 ELSE 'Above 1000'
END AS Cost_Category
FROM gold.dim_products
)

SELECT Cost_Category, 
COUNT(Cost_Category) AS Number_of_Products
FROM Cost_Segments
GROUP BY Cost_Category
ORDER BY Number_of_Products DESC

-- Customer Segmentation

WITH Customer_Data AS
(
SELECT Customers.customer_key,	
	   SUM(Sales.sales_amount) AS Total_Sales,
	   MIN(order_date) AS First_Order_Date,
	   MAX(order_date) AS Latest_Order_Date,
	   DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Customer_Life
FROM gold.dim_customers Customers
LEFT JOIN gold.fact_sales Sales
	ON Customers.customer_key = Sales.customer_key
GROUP BY Customers.customer_key
),

Customer_Segments AS 
(
SELECT *,
	CASE 
		WHEN Total_Sales >= 5000 AND Customer_Life >= 12 THEN 'VIP'
		WHEN Total_Sales < 5000 AND Customer_Life >= 12 THEN 'Regular'
		WHEN Total_Sales >= 5000 AND Customer_Life < 12 THEN 'High Future Potential'
		ELSE 'New Customer'
	END AS Customer_Segment
FROM Customer_Data
)

SELECT Customer_Segment,
	   COUNT(*) AS Number_of_Customers	
FROM Customer_Segments
GROUP BY Customer_Segment