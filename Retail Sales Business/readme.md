# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `Retail_Sales`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_Sales`.
- **Table Creation**: A table named `Retail_Sales_Data` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_Sales;

CREATE TABLE Retail_Sales_Data
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantiy INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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
```

### 3. Business Case Findings

The following SQL queries were developed to answer specific business questions:

1) **Retrieve all sales made on '2022-11-05'**:
```sql
SELECT * FROM Retail_Sales_Data
WHERE sale_date = '2022-11-05'
```

2) **Retrieve all transactions for clothing category where quantity is not less than 4	for the month of November**:	
```sql
SELECT * FROM Retail_Sales_Data
WHERE category = 'Clothing' 
AND quantiy >=4
AND MONTH(sale_date) = 11
```

3) **Calcuate the total sales for each category**:
```sql
SELECT category,SUM(total_sale) AS Total_Sales 
FROM Retail_Sales_Data
GROUP BY category
```

4) **Find the average age of customers who bought from beauty category**:
```sql
SELECT AVG(age) AS Average_Age 
FROM Retail_Sales_Data
WHERE category = 'Beauty'
```

5) **Find all transactions where the sale exceeds or equals $2000**:
```sql
SELECT * FROM Retail_Sales_Data
WHERE total_sale >= 2000
```

6) **Find the number of transaction for both genders in each category**:
```sql
SELECT category,gender,COUNT(*) AS Total_Transactions 
FROM Retail_Sales_Data
GROUP BY category,gender
```

7) **Calculate the average sale for each month. Which was the best selling month?**
```sql
SELECT DATENAME(MONTH,sale_date) AS Month_of_Year, AVG(total_sale) AS Average_Sales
FROM Retail_Sales_Data
GROUP BY DATENAME(MONTH,sale_date)
ORDER BY Average_Sales DESC
```

8) **Find the Top 5 highest paying customers**:
```sql
SELECT TOP 5 customer_id, SUM(total_sale) AS Total_Sale
FROM Retail_Sales_Data
GROUP BY customer_id
ORDER BY Total_Sale DESC
```

9) **For each category, find the number of unique customers who purachased items**:

```sql
SELECT category, COUNT(DISTINCT customer_id) AS Unique_Customers
FROM Retail_Sales_Data
GROUP BY category
ORDER BY 2 DESC
```

10) **For 4 shifts of 6 hours each, find total orders for each shift.**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount equalling $2000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.
