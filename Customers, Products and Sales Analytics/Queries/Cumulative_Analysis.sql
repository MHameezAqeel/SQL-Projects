-- Calculate the total sales per month and the running total of sales over time.

WITH MonthlySales AS (
    SELECT 
        FORMAT(order_date, 'MMM-yyyy') AS [Month],
        MIN(order_date) AS OrderDate, -- for correct chronological sorting
        SUM(sales_amount) AS Total_Sales
    FROM gold.fact_sales
	WHERE order_date IS NOT NULL
    GROUP BY FORMAT(order_date, 'MMM-yyyy')
)
SELECT 
    [Month],
    Total_Sales,
    SUM(Total_Sales) OVER (ORDER BY OrderDate) AS Running_Sales
FROM MonthlySales;
