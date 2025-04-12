SELECT YEAR(order_date) AS [Year],
		SUM(sales_amount) AS Total_Sales,
		SUM(quantity) AS Quantity,
		SUM(distinct customer_key) AS Total_Customers
FROM gold.fact_sales
WHERE YEAR(order_date) is not null
GROUP BY YEAR(order_date)
ORDER BY [Year]

SELECT MONTH(order_date) AS [Month],
		SUM(sales_amount) AS Total_Sales,
		SUM(quantity) AS Quantity,
		SUM(distinct customer_key) AS Total_Customers
FROM gold.fact_sales
WHERE MONTH(order_date) is not null
GROUP BY MONTH(order_date)
ORDER BY [Month]

SELECT YEAR(order_date) AS [Year], MONTH(order_date) AS [Month],
		SUM(sales_amount) AS Total_Sales,
		SUM(quantity) AS Quantity,
		SUM(distinct customer_key) AS Total_Customers
FROM gold.fact_sales
WHERE YEAR(order_date) is not null
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY [Year], [Month]