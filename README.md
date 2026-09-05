# Sales Data Analysis Using SQL

## 📊 Project Overview

This project analyzes sales transaction data using SQL to explore data quality, customer behavior, product performance, market performance, time-based trends, advanced analytical calculations, and profitability.

The SQL scripts are organized by analytical area so the work can be reviewed and reproduced easily.

## 🎯 Objectives

- Validate the quality and consistency of transaction data
- Analyze customer revenue and contribution
- Identify top-performing products
- Compare performance across markets
- Analyze monthly revenue, quantity, and average selling price
- Calculate Month-over-Month (MoM) and Year-over-Year (YoY) growth
- Calculate running totals and rolling averages
- Analyze cumulative customer revenue contribution
- Segment customers using revenue contribution
- Evaluate overall, market-level, and product-level profitability

## 🗂️ Repository Structure

```text
sales-data-analysis/
├── README.md
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_product_analysis.sql
│   ├── 04_market_analysis.sql
│   ├── 05_time_analysis.sql
│   ├── 06_window_functions_and_ctes.sql
│   └── 07_profitability_analysis.sql
├── data/
│   └── README.md
├── dashboard/
    └── README.md

```

## 🗃️ Data Model

The queries use the following tables and fields from the source SQL notes:

| Table | Main fields used |
|---|---|
| `transactions` | `product_code`, `customer_code`, `market_code`, `order_date`, `sales_amount`, `sales_qty`, `cost_price`, `profit_margin`, `profit_margin_percentage` |
| `products` | `product_code`, `product_type` |
| `customers` | `customer_code`, `custmer_name` |
| `markets` | `markets_code`, `markets_name` |
| `date` | `date`, `year`, `month_name` |

> **Note:** The source data uses the column name `custmer_name`. The SQL files preserve that name so they remain aligned with the source schema.

## 🔍 Analysis Areas

### 1. Data Quality

Checks for missing product references, unknown product types, invalid sales values, negative profit margins, cost exceeding sales, loss-making transactions, and overall revenue.

See: `sql/01_data_quality.sql`

### 2. Customer Analysis

Measures unique customers, revenue by customer, top customers, average customer revenue, customer ranking, revenue contribution, and revenue-based segmentation.

See: `sql/02_customer_analysis.sql`

### 3. Product Analysis

Measures revenue by product, top products, average product revenue, and product contribution to total revenue.

See: `sql/03_product_analysis.sql`

### 4. Market Analysis

Compares revenue, revenue percentage, sales quantity, average selling price, and revenue rank across markets.

See: `sql/04_market_analysis.sql`

### 5. Time Analysis

Analyzes monthly revenue, monthly quantity, average selling price, and monthly sales summaries.

See: `sql/05_time_analysis.sql`

### 6. Advanced SQL: CTEs & Window Functions

Demonstrates `LAG()`, `SUM() OVER()`, `AVG() OVER()`, `PARTITION BY`, running totals, MoM growth, YoY growth, YTD revenue, rolling three-month averages, and cumulative revenue analysis.

See: `sql/06_window_functions_and_ctes.sql`

### 7. Profitability Analysis

Calculates revenue, cost, profit, profit margin percentage, market profitability, product profitability, average selling price, and revenue ranking.

See: `sql/07_profitability_analysis.sql`

## 🧠 SQL Skills Demonstrated

- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`
- `DISTINCT`
- `JOIN` and `LEFT JOIN`
- `COALESCE()` and `CASE`
- Aggregate functions such as `SUM()`, `COUNT()`, `MIN()`, `MAX()`, and `AVG()`
- `ROUND()`
- `RANK()` and `DENSE_RANK()`
- `LAG()`
- Common Table Expressions (CTEs)
- Window functions
- Running totals
- Rolling averages
- MoM and YoY calculations
- YTD calculations
- Cumulative revenue and contribution analysis

## ▶️ How to Use

1. Create or connect to a SQL database containing the required tables.
2. Load the source data into the tables listed above.
3. Verify that table and column names match the queries.
4. Start with `01_data_quality.sql`.
5. Continue through the remaining scripts according to the analysis area.

The repository contains SQL analysis scripts only; no source dataset is included in this package.

## 📌 Query Organization

```text
01 → Data Quality
02 → Customer Analysis
03 → Product Analysis
04 → Market Analysis
05 → Time Analysis
06 → Window Functions & CTEs
07 → Profitability Analysis
```

## 👤 Author

**Jaisarves M**

Data Analytics | SQL | Business Intelligence
