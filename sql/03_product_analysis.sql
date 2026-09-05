/*
===============================================================================
File: 03_product_analysis.sql
Purpose: Product performance analysis
===============================================================================
*/

-- 1. Revenue by product
SELECT
    t.product_code,
    COALESCE(p.product_type, 'Unknown') AS Product_Type,
    ROUND(SUM(t.sales_amount), 2) AS Revenue
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
GROUP BY
    t.product_code,
    Product_Type
ORDER BY Revenue DESC;

-- 2. Top 10 products by revenue
SELECT
    t.product_code,
    COALESCE(p.product_type, 'Unknown') AS Product_Type,
    ROUND(SUM(t.sales_amount), 2) AS Revenue
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
GROUP BY
    t.product_code,
    Product_Type
ORDER BY Revenue DESC
LIMIT 10;

-- 3. Average revenue per product
SELECT
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT product_code),
        2
    ) AS Avg_Product_Revenue
FROM transactions;

-- 4. Product contribution to total revenue
SELECT
    t.product_code,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    ROUND(
        SUM(t.sales_amount) * 100 /
        (
            SELECT SUM(sales_amount)
            FROM transactions
        ),
        2
    ) AS Contribution
FROM transactions t
GROUP BY t.product_code
ORDER BY Revenue DESC;
