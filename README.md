# E-Commerce Profitability & Operations Analytics

An end-to-end data analytics project focused on understanding e-commerce revenue, profitability, customer performance, product performance, returns, and operational data quality.

The project combines MySQL for data preparation and analysis with Power BI for interactive business reporting and dashboard development.

## Project Overview

The objective of this project is to transform raw e-commerce data into actionable business insights.

The analysis focuses on:

- Revenue and profit performance
- Product and category profitability
- Customer performance
- Order and payment analysis
- Return performance
- Location performance
- Data quality validation
- Business recommendations

## Business Questions

The project answers the following business questions:

1. How much revenue and profit does the business generate?
2. What is the overall profit margin?
3. Which product categories contribute the most profit?
4. Which products generate the highest revenue and profit?
5. Which customers generate the highest revenue and profit?
6. What is the overall return rate?
7. Which categories and products have higher return activity?
8. How does business performance vary by city?
9. How do order statuses and payment methods contribute to revenue?
10. Are there any data-quality issues affecting the analysis?
11. Which areas require management attention?

## Dataset

The project uses six relational tables:

- Categories
- Customers
- Products
- Orders
- Order Items
- Returns

### Dataset Scale

| Entity | Records |
|---|---:|
| Categories | 5 |
| Customers | 5,000 |
| Products | 300 |
| Orders | 9,000 |
| Order Items | 15,000 |
| Returns | 1,176 |

## Data Model

The project follows a relational data model.

Categories → Products  
Customers → Orders  
Orders → Order Items  
Products → Order Items  
Order Items → Returns

Detailed data-model documentation is available in:

`Documentation/Data_Model.md`

## Tools & Technologies

### MySQL

Used for:

- Database creation
- Table creation
- Data loading
- Data validation
- Joins
- Aggregations
- Subqueries
- CTEs
- Window functions
- Profitability analysis
- Customer analysis
- Return analysis
- Business classification

### Power BI

Used for:

- Data modeling
- DAX calculations
- KPI development
- Interactive dashboards
- Category analysis
- Profitability analysis
- Returns analysis
- Operational reporting
- Business storytelling

### GitHub

Used for:

- Version control
- Project documentation
- Portfolio presentation
- Sharing SQL and analytical work

## SQL Analysis

The SQL analysis is organized into the following sections:

1. Database & Table Creation
2. Data Loading
3. Data Validation
4. Sales & Profitability Analysis
5. Customer Analysis
6. Returns Analysis
7. Location Analysis
8. Order & Payment Analysis
9. Advanced SQL Analysis
10. Business Performance Analysis

### SQL Techniques Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- CASE WHEN
- JOINs
- Subqueries
- CTEs
- Aggregate functions
- Window functions
- RANK()
- NULLIF()
- Percentage calculations
- Business classification

SQL portfolio file:

`SQL/ECommerce_Analytics_SQL_Portfolio.sql`

## Power BI Dashboards

The project contains three main dashboard pages.

### 1. Executive Overview

Provides a high-level view of business performance.

Key areas include:

- Revenue
- Cost
- Profit
- Profit Margin
- Orders
- Customers
- Average Order Value
- Profit per Order
- Category performance
- Overall business trends

### 2. Profitability Analysis

Focuses on understanding the drivers of profitability.

Key analysis includes:

- Revenue by category
- Profit by category
- Profit margin
- Product profitability
- Top-performing products
- Customer profitability
- Category-level performance

### 3. Operations & Returns Analysis

Focuses on operational performance and return activity.

Key analysis includes:

- Returned orders
- Return rate
- Return performance by category
- Product return activity
- Order status
- Payment analysis
- Data-quality observations

## Key KPIs

| KPI | Validated Value |
|---|---:|
| Total Revenue | ₹1.286B |
| Total Cost | ₹958.123M |
| Total Profit | ₹328.183M |
| Profit Margin | ~25.51% |
| Total Orders | 9,000 |
| Orders with Items | 7,342 |
| Total Customers | 5,000 |
| Average Order Value | ₹175.20K |
| Profit per Order | ₹44.70K |
| Returned Orders | 1,176 |
| Return Rate | 13.07% |

Detailed KPI definitions and DAX measures are available in:

`Documentation/KPI_Definitions.md`

## Key Business Insights

### Strong Overall Profitability

The business generated approximately ₹1.286B in revenue and ₹328.18M in profit, resulting in an overall profit margin of approximately 25.51%.

### Food & Beverages Is a Major Profit Contributor

Food & Beverages generated approximately ₹67M in total profit, making it the highest absolute profit contributor among the categories.

### Apparel/Fashion Has the Highest Category Margin

Apparel/Fashion achieved the highest category profit margin at 26.92%.

### Apparel/Fashion Also Has the Highest Return Rate

Apparel/Fashion recorded the highest category return rate at 11.69%.

This means profitability and return performance should be monitored together rather than evaluated independently.

### Overall Return Rate

The business recorded 1,176 returned orders and an overall return rate of 13.07%.

### High-Return Products

Products with high returned-order counts include:

- Smartwatch — 143
- Backpack — 119
- T-shirt — 117
- Water bottle — 111
- Smartphone — 104
- Running shoes — 99

### Data Quality Issue

The dataset contains 9,000 orders but only 7,342 orders with corresponding order-item records.

This leaves 1,658 orders without order-item records.

The missing-item orders include:

- Cancelled — 580
- In Transit — 550
- Delivered — 528

The 528 delivered orders without corresponding order-item records require particular investigation.

## Business Recommendations

### 1. Investigate High-Return Products

Prioritize products and categories with high return activity.

### 2. Investigate Data Completeness

Review the source-system or ETL process responsible for missing order-item records.

### 3. Protect High-Margin Categories

Monitor pricing, product mix and cost structure in high-margin categories.

### 4. Monitor Returns Alongside Profitability

Evaluate profit margin and return performance together when assessing category performance.

### 5. Improve Data Quality Monitoring

Introduce validation checks to identify orders without corresponding order-item records.

## Data Quality Consideration

Revenue and profitability analysis is based on order-item level data.

Because 1,658 orders do not have corresponding order-item records, metrics such as Average Order Value and Profit per Order use Orders with Items as their denominator.

This distinction was identified during the final MySQL and Power BI validation process.

## Analytical Limitations

The dataset identifies return activity but does not provide detailed return reasons.

Therefore, the analysis can identify products and categories with higher return activity, but it cannot conclusively determine why customers returned those products.

Similarly, the dataset identifies missing order-item relationships but does not establish the exact source-system or ETL cause.

Further investigation would be required to determine the root cause.

## Project Structure

E-Commerce-Profitability-Operations-Analytics

- README.md
- PowerBI/
  - ECommerce_Profitability_Operations_Analytics.pbix
- SQL/
  - ECommerce_Analytics_SQL_Portfolio.sql
- Documentation/
  - Data_Model.md
  - KPI_Definitions.md
  - Business_Insights.md
- Screenshots/
  Screenshots/
  - 01_Executive_Overview.png
  - 02_Profitability_Analysis.png
  - 03_Operations_Returns_Analysis.png
  - 04_PowerBI_Data_Model.png
- Data/

## Documentation

Detailed project documentation:

- `Documentation/Data_Model.md`
- `Documentation/KPI_Definitions.md`
- `Documentation/Business_Insights.md`

## Project Outcome

This project demonstrates an end-to-end analytics workflow:

Raw Data → MySQL Database → Data Validation → SQL Analysis → Power BI Data Model → DAX Measures → Interactive Dashboards → Business Insights → Recommendations

The project demonstrates practical skills in SQL, Power BI, DAX, data validation, business analysis, dashboard development and analytical storytelling.