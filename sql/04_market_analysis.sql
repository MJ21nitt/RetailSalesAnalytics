/*
===============================================================================
File: 04_market_analysis.sql
Purpose: Market-level performance analysis
===============================================================================
*/

-- 1. Revenue and revenue contribution by market
SELECT
    m.markets_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    ROUND(
        SUM(t.sales_amount) * 100 /
        (SELECT SUM(sales_amount) FROM transactions),
        2
    ) AS Revenue_Percentage
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY Revenue DESC;

-- 2. Total quantity sold by market
SELECT
    m.markets_name,
    SUM(t.sales_qty) AS Total_Quantity
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY Total_Quantity DESC;

-- 3. Average selling price by market
SELECT
    m.markets_name,
    ROUND(
        SUM(t.sales_amount) /
        SUM(t.sales_qty),
        2
    ) AS Avg_Selling_Price
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY Avg_Selling_Price DESC;

-- 4. Market revenue ranking
SELECT
    m.markets_name,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    RANK() OVER (
        ORDER BY SUM(t.sales_amount) DESC
    ) AS Market_Rank
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY Market_Rank;
