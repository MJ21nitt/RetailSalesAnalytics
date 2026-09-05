/*
===============================================================================
File: 05_time_analysis.sql
Purpose: Time-series sales analysis
===============================================================================
*/

-- 1. Monthly revenue
SELECT
    d.year,
    d.month_name,
    ROUND(SUM(t.sales_amount), 2) AS Monthly_Revenue
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY
    d.year,
    d.month_name
ORDER BY
    d.year,
    MIN(d.date);

-- 2. Monthly sales quantity
SELECT
    d.year,
    d.month_name,
    SUM(t.sales_qty) AS Total_Quantity
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY
    d.year,
    d.month_name
ORDER BY
    d.year,
    MIN(d.date);

-- 3. Monthly average selling price
SELECT
    d.year,
    d.month_name,
    ROUND(
        SUM(t.sales_amount) /
        SUM(t.sales_qty),
        2
    ) AS Avg_Selling_Price
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY
    d.year,
    d.month_name
ORDER BY
    d.year,
    MIN(d.date);

-- 4. Monthly sales summary
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS first_day,
        SUM(t.sales_amount) AS Revenue,
        SUM(t.sales_qty) AS Quantity,
        ROUND(SUM(t.sales_amount) / SUM(t.sales_qty), 2) AS ASP
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
)
SELECT *
FROM MonthlySales
ORDER BY first_day;
