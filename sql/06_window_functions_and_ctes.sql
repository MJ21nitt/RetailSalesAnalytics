/*
===============================================================================
File: 06_window_functions_and_ctes.sql
Purpose: Advanced SQL analysis using CTEs and window functions
===============================================================================
*/

-- 1. Month-over-Month revenue growth
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS Month_Date,
        SUM(t.sales_amount) AS Revenue,
        SUM(t.sales_qty) AS Quantity,
        ROUND(
            SUM(t.sales_amount) /
            SUM(t.sales_qty),
            2
        ) AS ASP
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
),
MonthlyGrowth AS
(
    SELECT
        *,
        LAG(Revenue) OVER (
            ORDER BY Month_Date
        ) AS Previous_Revenue
    FROM MonthlySales
)
SELECT
    year,
    month_name,
    Revenue,
    Previous_Revenue,
    ROUND(
        (
            Revenue - Previous_Revenue
        ) / Previous_Revenue * 100,
        2
    ) AS MoM_Growth
FROM MonthlyGrowth
ORDER BY Month_Date;

-- 2. Year-over-Year revenue growth
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS Month_Date,
        SUM(t.sales_amount) AS Revenue
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
),
YoY AS
(
    SELECT
        *,
        LAG(Revenue, 12) OVER (
            ORDER BY Month_Date
        ) AS Last_Year_Revenue
    FROM MonthlySales
)
SELECT
    year,
    month_name,
    Revenue,
    Last_Year_Revenue,
    ROUND(
        (
            Revenue - Last_Year_Revenue
        ) / Last_Year_Revenue * 100,
        2
    ) AS YoY_Growth
FROM YoY
ORDER BY Month_Date;

-- 3. Year-to-Date revenue
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS Month_Date,
        SUM(t.sales_amount) AS Revenue
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
)
SELECT
    year,
    month_name,
    Revenue,
    SUM(Revenue) OVER (
        PARTITION BY year
        ORDER BY Month_Date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS YTD_Revenue
FROM MonthlySales
ORDER BY Month_Date;

-- 4. Rolling 3-month average revenue
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS Month_Date,
        SUM(t.sales_amount) AS Revenue
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
)
SELECT
    year,
    month_name,
    Revenue,
    ROUND(
        AVG(Revenue) OVER (
            ORDER BY Month_Date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS Rolling_3_Month_Average
FROM MonthlySales
ORDER BY Month_Date;

-- 5. Running revenue total by year
WITH MonthlySales AS
(
    SELECT
        d.year,
        d.month_name,
        MIN(d.date) AS Month_Date,
        SUM(t.sales_amount) AS Revenue
    FROM transactions t
    JOIN date d
        ON t.order_date = d.date
    GROUP BY
        d.year,
        d.month_name
)
SELECT
    year,
    month_name,
    Revenue,
    SUM(Revenue) OVER (
        PARTITION BY year
        ORDER BY Month_Date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total
FROM MonthlySales
ORDER BY Month_Date;

-- 6. Customer cumulative revenue and total revenue
WITH CustomerRevenue AS (
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
RunningRevenue AS (
    SELECT
        custmer_name,
        Revenue,
        SUM(Revenue) OVER (
            ORDER BY Revenue DESC
        ) AS Cumulative_Revenue,
        SUM(Revenue) OVER () AS Total_Revenue
    FROM CustomerRevenue
)
SELECT *
FROM RunningRevenue;

-- 7. Cumulative revenue contribution percentage
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
    ) AS Cumulative_Percentage
FROM RunningRevenue
ORDER BY Revenue DESC;
