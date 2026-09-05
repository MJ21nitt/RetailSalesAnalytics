/*
===============================================================================
File: 07_profitability_analysis.sql
Purpose: Profitability and financial performance analysis
===============================================================================
*/

-- 1. Sample transaction-level profit calculation
SELECT
    sales_amount,
    cost_price,
    profit_margin,
    sales_amount - cost_price AS Calculated_Profit
FROM transactions
LIMIT 20;

-- 2. Compare stored profit margin percentage with calculated percentage
SELECT
    sales_amount,
    cost_price,
    profit_margin,
    profit_margin_percentage,
    ROUND(
        (profit_margin / sales_amount) * 100,
        2
    ) AS Calculated_Percentage
FROM transactions
LIMIT 20;

-- 3. Inspect transaction data
SELECT *
FROM transactions;

-- 4. Overall revenue, cost, profit, and profit margin
SELECT
    ROUND(SUM(sales_amount), 2) AS Total_Revenue,
    ROUND(SUM(cost_price), 2) AS Total_Cost,
    ROUND(SUM(profit_margin), 2) AS Total_Profit,
    ROUND(
        (SUM(profit_margin) / SUM(sales_amount)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM transactions;

-- 5. Profitability by market
SELECT
    m.markets_name AS Market,
    ROUND(SUM(t.sales_amount), 2) AS Total_Revenue,
    ROUND(SUM(t.cost_price), 2) AS Total_Cost,
    ROUND(SUM(t.profit_margin), 2) AS Total_Profit,
    ROUND(
        (SUM(t.profit_margin) / SUM(t.sales_amount)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM transactions t
JOIN markets m
    ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY Total_Revenue DESC;

-- 6. Profitability and revenue ranking by product
SELECT
    t.product_code,
    COALESCE(TRIM(p.product_type), 'Unknown') AS Product_Type,
    ROUND(SUM(t.sales_amount), 2) AS Revenue,
    SUM(t.sales_qty) AS Quantity_Sold,
    ROUND(SUM(t.cost_price), 2) AS Total_Cost,
    ROUND(SUM(t.profit_margin), 2) AS Profit,
    ROUND(
        (SUM(t.profit_margin) / SUM(t.sales_amount)) * 100,
        2
    ) AS Profit_Margin_Percentage,
    ROUND(
        SUM(t.sales_amount) / SUM(t.sales_qty),
        2
    ) AS Average_Selling_Price,
    DENSE_RANK() OVER (
        ORDER BY SUM(t.sales_amount) DESC
    ) AS Revenue_Rank
FROM transactions t
LEFT JOIN products p
    ON t.product_code = p.product_code
GROUP BY
    t.product_code,
    Product_Type
ORDER BY Quantity_Sold DESC;
