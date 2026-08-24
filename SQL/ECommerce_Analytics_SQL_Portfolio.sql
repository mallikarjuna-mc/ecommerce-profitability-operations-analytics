/* E-Commerce Profitability & Operations Analytics

Project: E-Commerce Profitability & Operations Analytics
Tools: MySQL, Power BI

This SQL script contains data preparation, validation,
sales and profitability analysis, customer analysis,
returns analysis, and business analysis.

The queries are written to answer practical business
questions using the e-commerce dataset.*/

CREATE DATABASE ECOMMERCE_ANALYTICS;
USE ECOMMERCE_ANALYTICS;

USE ecommerce_analytics;

-- ============================================
-- 1. DATABASE & TABLE CREATION
-- ============================================

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    signup_date DATE NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    cost_price DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
        
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT NOT NULL,
    return_date DATE NOT NULL,
    refund_amount DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT fk_returns_order_item
        FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id)
);

SHOW TABLES;

-- ============================================
-- 2. DATA LOADING
-- ============================================

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/categories.csv'
INTO TABLE categories
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category_id, category_name);

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

SELECT COUNT(*) FROM CATEGORIES;

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, name, email, signup_date, city, state);

SELECT COUNT(*) FROM CUSTOMERS;

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, category_id, price, cost_price);

SELECT COUNT(*) FROM PRODUCTS;

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, payment_method);

SELECT COUNT(*) FROM ORDERS;

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_item_id, order_id, product_id, quantity, unit_price);

SELECT COUNT(*) FROM order_items;

LOAD DATA LOCAL INFILE 'C:/Users/MALLIKARJUNA/Desktop/Power BI E commerce Analysis/Data/returns.csv'
INTO TABLE returns
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(return_id, order_item_id, return_date, refund_amount);

SELECT COUNT(*) FROM RETURNS;

-- ============================================
-- 3. DATA VALIDATION
-- ============================================

SELECT
    (SELECT COUNT(*) FROM categories) AS categories,
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM returns) AS returns;
    
    SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS ORPHAN_ORDERS
FROM PRODUCTS AS P LEFT JOIN CATEGORIES AS C
ON P.CATEGORY_ID = C.CATEGORY_ID WHERE C.CATEGORY_ID IS NULL;

SELECT COUNT(*) AS ORPHAN_ORDERS
FROM order_items AS OI LEFT JOIN ORDERS AS O
ON OI.order_id = O.ORDER_ID WHERE O.ORDER_ID IS NULL;

SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS orphan_returns
FROM returns r
LEFT JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;

-- How many orders do not have corresponding order items?

SELECT COUNT(*) AS ORDERS_WITHOUT_ITEMS
FROM ORDERS AS O
LEFT JOIN ORDER_ITEMS AS OI
ON O.ORDER_ID = OI.ORDER_ID
WHERE OI.ORDER_ID IS NULL;

-- Which order statuses have orders without order items?

SELECT
    O.ORDER_STATUS,
    COUNT(*) AS ORDERS_WITHOUT_ITEMS
FROM ORDERS AS O
LEFT JOIN ORDER_ITEMS AS OI
ON O.ORDER_ID = OI.ORDER_ID
WHERE OI.ORDER_ID IS NULL
GROUP BY O.ORDER_STATUS
ORDER BY ORDERS_WITHOUT_ITEMS DESC;

-- How many orders have corresponding order item records?

SELECT COUNT(DISTINCT ORDER_ID) AS ORDERS_WITH_ITEMS
FROM ORDER_ITEMS;

-- ============================================
-- 4. SALES & PROFITABILITY ANALYSIS
-- ============================================


-- Which product categories generate the most revenue and profit?
SELECT C.CATEGORY_NAME,ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
ROUND(SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_COST,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE)- SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_PROFIT,
ROUND((SUM(OI.QUANTITY * OI.UNIT_PRICE)- SUM(OI.QUANTITY * P.COST_PRICE))/ NULLIF(SUM(OI.QUANTITY * OI.UNIT_PRICE), 0) * 100,2) AS PROFIT_MARGIN
FROM PRODUCTS AS P
INNER JOIN ORDER_ITEMS AS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN CATEGORIES AS C
ON C.CATEGORY_ID = P.CATEGORY_ID
GROUP BY C.CATEGORY_NAME
ORDER BY TOTAL_REVENUE DESC;

-- Which individual products generate the highest revenue and profit?
SELECT P.PRODUCT_ID, P.PRODUCT_NAME, 
C.CATEGORY_NAME,ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
ROUND(SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_COST,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE)- SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_PROFIT,
ROUND((SUM(OI.QUANTITY * OI.UNIT_PRICE)- SUM(OI.QUANTITY * P.COST_PRICE))/ NULLIF(SUM(OI.QUANTITY * OI.UNIT_PRICE), 0) * 100,2) AS PROFIT_MARGIN
FROM PRODUCTS AS P
INNER JOIN ORDER_ITEMS AS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN CATEGORIES AS C
ON C.CATEGORY_ID = P.CATEGORY_ID
GROUP BY
P.PRODUCT_ID,
P.PRODUCT_NAME,
C.CATEGORY_NAME
ORDER BY TOTAL_REVENUE DESC LIMIT 10;


-- ============================================
-- 5. CUSTOMER ANALYSIS
-- ============================================

-- Which customers generate the highest profit?

SELECT C.CUSTOMER_ID, C.NAME, C.CITY,
COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE) -
SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_PROFIT
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
ON O.CUSTOMER_ID = C.CUSTOMER_ID
INNER JOIN ORDER_ITEMS AS OI
ON OI.ORDER_ID = O.ORDER_ID
INNER JOIN PRODUCTS AS P
ON P.PRODUCT_ID = OI.PRODUCT_ID
GROUP BY C.CUSTOMER_ID, C.NAME, C.CITY
ORDER BY TOTAL_PROFIT DESC
LIMIT 10;



-- ============================================
-- 6. RETURNS ANALYSIS
-- ============================================

-- Return Rate & Refund Exposure
-- Which products have the highest return rate and refund exposure?

SELECT P.PRODUCT_ID,P.PRODUCT_NAME,C.CATEGORY_NAME,
COUNT(DISTINCT OI.ORDER_ITEM_ID) AS TOTAL_ORDER_ITEMS,
COUNT(DISTINCT R.RETURN_ID) AS TOTAL_RETURNS,
ROUND(COUNT(DISTINCT R.RETURN_ID)/ NULLIF(COUNT(DISTINCT OI.ORDER_ITEM_ID), 0) * 100,2) AS RETURN_RATE,
ROUND(COALESCE(SUM(R.REFUND_AMOUNT), 0),2) AS TOTAL_REFUND_AMOUNT
FROM PRODUCTS AS P
INNER JOIN CATEGORIES AS C
ON C.CATEGORY_ID = P.CATEGORY_ID
INNER JOIN ORDER_ITEMS AS OI ON P.PRODUCT_ID = OI.PRODUCT_ID
LEFT JOIN RETURNS AS R ON OI.ORDER_ITEM_ID = R.ORDER_ITEM_ID
GROUP BY
    P.PRODUCT_ID,
    P.PRODUCT_NAME,
    C.CATEGORY_NAME
HAVING COUNT(DISTINCT OI.ORDER_ITEM_ID) >= 50
ORDER BY RETURN_RATE DESC LIMIT 10;

-- How many orders were returned and what is the overall return rate?

SELECT
COUNT(DISTINCT OI.ORDER_ID) AS RETURNED_ORDERS,
(SELECT COUNT(DISTINCT ORDER_ID) FROM ORDERS) AS TOTAL_ORDERS,
ROUND(
COUNT(DISTINCT OI.ORDER_ID) /
(SELECT COUNT(DISTINCT ORDER_ID) FROM ORDERS) * 100,
2
) AS ORDER_RETURN_RATE
FROM RETURNS AS R
INNER JOIN ORDER_ITEMS AS OI
ON R.ORDER_ITEM_ID = OI.ORDER_ITEM_ID;

-- ============================================
-- 7. LOCATION ANALYSIS
-- ============================================

-- City Performance Analysis
-- Which cities generate the highest revenue and profit, and how many orders do they have?

SELECT C.CITY, COUNT(DISTINCT C.CUSTOMER_ID) AS TOTAL_CUSTOMERS,
COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
round(SUM(OI.QUANTITY* OI.UNIT_PRICE) - SUM(OI.QUANTITY * P.COST_PRICE),2) AS TOTAL_PROFIT,
round(SUM(OI.QUANTITY*OI.UNIT_PRICE)/ COUNT(DISTINCT O.ORDER_ID),2) AS AVERAGE_ORDER_VALUE
FROM customers AS C INNER JOIN ORDERS AS O
ON C.customer_id = O.CUSTOMER_ID INNER JOIN order_items AS OI
ON O.ORDER_ID = OI.order_id INNER JOIN products AS P
ON P.PRODUCT_ID = OI.PRODUCT_ID group by C.CITY order by TOTAL_REVENUE DESC LIMIT 10;

-- ============================================
-- 8. ORDER & PAYMENT ANALYSIS
-- ============================================


-- Order Status & Payment Method Analysis
-- How do order statuses and payment methods affect order volume and revenue?
SELECT O.ORDER_STATUS, O.PAYMENT_METHOD,
COUNT(DISTINCT O.ORDER_ID) AS TOTAL_ORDERS,
ROUND(SUM(OI.QUANTITY*OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
ROUND(SUM(OI.QUANTITY*OI.UNIT_PRICE)/
( SELECT SUM(QUANTITY*UNIT_PRICE) FROM ORDER_ITEMS)*100,2) AS REVENUE_SHARE,
CASE WHEN ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2)>=200000000 THEN 'HIGH'
WHEN ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2)>=100000000 THEN 'MEDIUM'
ELSE 'LOW' END AS REVENUE_TIER  FROM ORDERS AS O
INNER JOIN ORDER_ITEMS AS OI ON O.ORDER_ID = OI.ORDER_ID
GROUP BY O.ORDER_STATUS, O.PAYMENT_METHOD ORDER BY TOTAL_REVENUE DESC;


-- ============================================
-- 9. ADVANCED SQL ANALYSIS
-- ============================================

-- Rank products within each category based on total revenue.

WITH CATEGORY_ANALYSIS AS 
(SELECT P.PRODUCT_ID, P.PRODUCT_NAME, C.CATEGORY_NAME,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
RANK() OVER(PARTITION BY C.CATEGORY_NAME ORDER BY ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) DESC)
AS CATEGORY_RANK FROM PRODUCTS AS P INNER JOIN order_items AS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID INNER JOIN categories AS C
ON C.category_id = P.CATEGORY_ID  group by P.product_id, P.PRODUCT_NAME, C.category_name)
SELECT PRODUCT_ID,PRODUCT_NAME,CATEGORY_NAME,TOTAL_REVENUE,CATEGORY_RANK
FROM CATEGORY_ANALYSIS WHERE CATEGORY_RANK <=2;


-- ============================================
-- 10. BUSINESS PERFORMANCE ANALYSIS
-- ============================================

/* Which product categories are the strongest overall
when we consider revenue, profit, margin, and return performance together?*/

WITH SALES_ANALYSIS AS 
(SELECT C.CATEGORY_NAME,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE),2) AS TOTAL_REVENUE,
ROUND(SUM(OI.QUANTITY * OI.UNIT_PRICE) - SUM(OI.QUANTITY * P.COST_PRICE),2)
AS TOTAL_PROFIT
FROM CATEGORIES AS C
INNER JOIN PRODUCTS AS P
ON C.CATEGORY_ID = P.CATEGORY_ID
INNER JOIN ORDER_ITEMS AS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
GROUP BY C.CATEGORY_NAME),

RETURN_ANALYSIS AS
(SELECT C.CATEGORY_NAME,
COUNT(DISTINCT OI.ORDER_ID) AS TOTAL_ORDERS,
COUNT(DISTINCT CASE WHEN R.RETURN_ID IS NOT NULL THEN OI.ORDER_ID END) AS RETURNED_ORDERS,
ROUND(COUNT(DISTINCT CASE WHEN R.RETURN_ID IS NOT NULL THEN OI.ORDER_ID END) /
NULLIF(COUNT(DISTINCT OI.ORDER_ID),0) * 100,2) AS RETURN_RATE
FROM CATEGORIES AS C
INNER JOIN PRODUCTS AS P
ON C.CATEGORY_ID = P.CATEGORY_ID
INNER JOIN ORDER_ITEMS AS OI
ON P.PRODUCT_ID = OI.PRODUCT_ID
LEFT JOIN RETURNS AS R
ON OI.ORDER_ITEM_ID = R.ORDER_ITEM_ID
GROUP BY C.CATEGORY_NAME)

SELECT S.CATEGORY_NAME, S.TOTAL_REVENUE, S.TOTAL_PROFIT,
ROUND(S.TOTAL_PROFIT / NULLIF(S.TOTAL_REVENUE,0) * 100,2) AS PROFIT_MARGIN,
R.RETURNED_ORDERS, R.RETURN_RATE,
CASE WHEN S.TOTAL_PROFIT / NULLIF(S.TOTAL_REVENUE,0) * 100 >= 26 AND R.RETURN_RATE < 10
THEN 'STRONG'
WHEN S.TOTAL_PROFIT / NULLIF(S.TOTAL_REVENUE,0) * 100 >= 25
THEN 'AVERAGE' ELSE 'NEEDS ATTENTION'
END AS PERFORMANCE_STATUS
FROM SALES_ANALYSIS AS S
INNER JOIN RETURN_ANALYSIS AS R
ON S.CATEGORY_NAME = R.CATEGORY_NAME;
