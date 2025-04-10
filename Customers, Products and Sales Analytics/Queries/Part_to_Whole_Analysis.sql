WITH Category_Sales AS (
SELECT category,SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales Sales
LEFT JOIN gold.dim_products Products
	ON Sales.product_key = Products.product_key
GROUP BY category
)

SELECT category, Total_Sales,
SUM(Total_Sales) OVER () AS Overall_Sales,
CONCAT(ROUND((CAST(Total_Sales as float)/(SUM(Total_Sales) OVER ())) * 100,2),'%') AS Percentage_of_Overall_Sales
FROM Category_Sales