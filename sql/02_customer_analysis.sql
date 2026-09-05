/*
===============================================================================
File: 02_customer_analysis.sql
Purpose: Customer-level sales analysis
===============================================================================
*/

-- 1. Count distinct customers
SELECT COUNT(DISTINCT customer_code)
FROM transactions;

-- 2. Revenue by customer
SELECT
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY Revenue DESC;

-- 3. Top 10 customers by revenue
SELECT
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY Revenue DESC
LIMIT 10;

-- 4. Average revenue per customer
SELECT
    ROUND(
        SUM(sales_amount) /
        COUNT(DISTINCT customer_code),
        2
    ) AS Avg_Customer_Revenue
FROM transactions;

-- 5. Customer revenue ranking
SELECT
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    RANK() OVER (
        ORDER BY SUM(t.sales_amount) DESC
    ) AS Customer_Rank
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY Customer_Rank;

-- 6. Customer revenue contribution percentage
SELECT
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    ROUND(
        SUM(t.sales_amount) * 100 /
        (SELECT SUM(sales_amount) FROM transactions),
        2
    ) AS Revenue_Percentage
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY Revenue DESC;

-- 7. Revenue-based customer segmentation
SELECT
    c.custmer_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    CASE
        WHEN SUM(t.sales_amount) >= 30000000 THEN 'Gold'
        WHEN SUM(t.sales_amount) >= 10000000 THEN 'Silver'
        ELSE 'Bronze'
    END AS Customer_Segment
FROM transactions t
JOIN customers c
    ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY Revenue DESC;

-- 8. Cumulative customer revenue contribution / Pareto-style segmentation
WITH CustomerRevenue AS
(
    SELECT
        c.customer_code,
        c.custmer_name,
        SUM(t.sales_amount) AS Revenue
    FROM customers c
    JOIN transactions t
        ON c.customer_code = t.customer_code
    GROUP BY
        c.customer_code,
        c.custmer_name
),
RunningRevenue AS
(
    SELECT
        custmer_name,
        Revenue,
        SUM(Revenue) OVER (
            ORDER BY Revenue DESC
        ) AS Cumulative_Revenue,
        SUM(Revenue) OVER () AS Total_Revenue
    FROM CustomerRevenue
)
SELECT
    custmer_name,
    Revenue,
    Cumulative_Revenue,
    ROUND(
        (Cumulative_Revenue / Total_Revenue) * 100,
        2
    ) AS Cumulative_Percentage,
    CASE
        WHEN ROUND(
            (Cumulative_Revenue / Total_Revenue) * 100,
            2
        ) <= 80 THEN 'Critical Customers'
        ELSE 'Long Tail'
    END AS Customer_Category
FROM RunningRevenue
ORDER BY Revenue DESC;
