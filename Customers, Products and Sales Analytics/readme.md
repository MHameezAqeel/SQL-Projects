# Product Cost Overview

## 1) Project Overview  
This project involves the analysis of product cost data from a retail database. The objective is to categorize products based on their cost into meaningful segments and summarize their distribution. The goal is to generate a clear understanding of cost concentration across various pricing bands, enabling more informed decision-making for inventory management, pricing strategies, and marketing focus.

---

## 2) Objectives  
- Categorize products based on their cost into four defined ranges.  
- Count the number of products falling into each cost category.  
- Organize the categories in ascending order of cost for clearer reporting.  
- Present a structured view of how products are distributed across cost brackets.

---

## 3) Tech Stack  
- **SQL (T-SQL, MS SQL Server)**  
- **SSMS** (SQL Server Management Studio)

---

## 4) Dataset Characteristics  
- **Source:** `gold.dim_products`  
- **Key Columns:**  
  - `product_name`: Name of the product  
  - `cost`: Cost associated with the product  
- **Volume:** Each row represents a unique product record.

---

## 5) Key Findings  
- Products are distributed across four primary cost categories:  
  - Below 100  
  - Between 100 and 500  
  - Between 500 and 1000  
  - Above 1000  
- Most products fall in the **"Between 100 and 500"** category, indicating a mid-range pricing focus.  
- A smaller share of products is priced **above 1000**, suggesting limited high-cost inventory.

---

## 6) Recommendations  
- Focus promotional campaigns on mid-range products due to their higher count.  
- Consider expanding the high-cost product line if market demand supports premium offerings.  
- Monitor low-cost product segments for volume-driven sales opportunities.

---

## 7) Limitations  
- The analysis is based only on product cost without incorporating demand, sales, or inventory turnover.  
- Cost ranges are static and may not reflect dynamic market pricing behavior.  
- No category or department-level breakdown is included at this stage.

---

## 8) Contact  
For any queries, suggestions, or collaborations:  
**Muhammad Hameez Aqeel**  
📧 mhameezaqeel@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/mhameezaqeel)

---

## 9) License  
This project is licensed under the MIT License - see the [LICENSE](https://github.com/MHameezAqeel/SQL-Projects/blob/main/LICENSE) file for details.

