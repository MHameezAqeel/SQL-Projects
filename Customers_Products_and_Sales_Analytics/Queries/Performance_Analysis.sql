WITH Category_Sales AS (
SELECT Products.category, 
	   YEAR(Sales.order_date) AS [Year],
	   AVG(Sales.sales_amount) AS [Average Category Sales]
FROM gold.fact_sales Sales
LEFT JOIN gold.dim_products Products
	ON Sales.product_key = Products.product_key
WHERE Sales.order_date IS NOT NULL
GROUP BY Products.category, YEAR(Sales.order_date)
),

Product_Sales AS (
SELECT Products.product_name, Products.category,
	   YEAR(Sales.order_date) AS [Year],
	   AVG(Sales.sales_amount) AS [Average Product Sales]
FROM gold.fact_sales Sales
LEFT JOIN gold.dim_products Products
	ON Sales.product_key = Products.product_key
WHERE Sales.order_date IS NOT NULL
GROUP BY YEAR(Sales.order_date), Products.product_name, Products.category
)

SELECT product_name, Product_Sales.category, Product_Sales.[Year],
	   [Average Product Sales], [Average Category Sales],
	   [Average Product Sales] - [Average Category Sales] AS Diff_Cat
FROM Product_Sales
LEFT JOIN Category_Sales
	ON Product_Sales.category = Category_Sales.category 
	   AND
	   Product_Sales.Year = Category_Sales.Year
ORDER BY product_name, [Year]