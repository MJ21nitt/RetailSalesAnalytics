/*
===============================================================================
File: 01_data_quality.sql
Purpose: Data validation and quality checks
===============================================================================
*/

-- 1. Identify transactions with missing product references
SELECT DISTINCT t.product_code
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
WHERE p.product_code IS NULL;

-- 2. Count distinct product codes that do not exist in the products table
SELECT COUNT(DISTINCT t.product_code)
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
WHERE p.product_code IS NULL;

-- 3. Revenue by product type, including unknown product types
SELECT
    COALESCE(p.product_type, 'Unknown') AS product_type,
    SUM(t.sales_amount) AS Revenue
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
GROUP BY COALESCE(p.product_type, 'Unknown');

-- 4. Minimum and maximum sales amount
SELECT MIN(sales_amount), MAX(sales_amount)
FROM transactions;

-- 5. Count transactions with non-positive sales
SELECT COUNT(*)
FROM transactions
WHERE sales_amount <= 0;

-- 6. Count transactions with negative profit margin
SELECT COUNT(*)
FROM transactions
WHERE profit_margin < 0;

-- 7. Count transactions where cost is greater than sales
SELECT COUNT(*)
FROM transactions
WHERE cost_price > sales_amount;

-- 8. Percentage of loss-making transactions
SELECT
    ROUND(
        (COUNT(*) * 100.0) /
        (SELECT COUNT(*) FROM transactions),
        2
    ) AS Loss_Percentage
FROM transactions
WHERE profit_margin < 0;

-- 9. Revenue associated with loss-making transactions
SELECT
    ROUND(SUM(sales_amount), 2) AS Revenue_Loss_Transactions
FROM transactions
WHERE profit_margin < 0;

-- 10. Total revenue
SELECT
    ROUND(SUM(sales_amount), 2) AS Total_Revenue
FROM transactions;
