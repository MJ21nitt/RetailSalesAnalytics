# Sales Data Analysis Using SQL and PowerBI

## 📊 Project Overview

This project presents an end-to-end sales and profitability analytics solution using **SQL** and **Power BI** to evaluate **148,395 transaction records** totaling **₹984.81 Million** in gross revenue across 2017 to 2020. 

The analytical workflow bridges raw data validation and advanced SQL querying with an interactive 5-page Power BI dashboard. By moving beyond top-line revenue metrics, the analysis evaluates customer concentration risks, regional market profitability, product line margins, and time-series growth trajectories.

The SQL queries and Power BI artifacts are organized systematically so the work can be easily audited, reproduced, and reviewed.

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
- Build a single-fact Star Schema data model in Power BI with custom DAX measures.
- Evaluate overall portfolio profitability, identifying loss-making products and markets.

## 🗂️ Repository Structure

```text
sales-data-analysis/
├── README.md
├── PROJECT REPORT.md
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
    └── power_bi_dashboard_documentation.md

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

### Power BI Star Schema
The Power BI analytical layer transforms these tables into a single-fact **Star Schema** ($*:1$ cardinality):

```text
               customers
                   | (1)
                   |
                   | (*)
markets (1)---(*) transactions (*)---(1) products
                   |
                   | (*)
                   | (1)
                 date
```

---

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

### 8. Interactive Power BI Dashboard & DAX Modeling
Translates database findings into an executive BI dashboard featuring explicit DAX financial measures, custom calendar display keys (`DATE_YY_MMMM`), dynamic slicers, and 5 detailed visual report pages.
* **Dashboard Documentation:** `dashboard/power_bi_dashboard_documentation.md`


## 🧠 Skills Demonstrated

### SQL & Relational Analytics
- Data validation (`COUNT`, `DISTINCT`, `MIN`, `MAX`, `NULL` checks)
- Relational table joins (`INNER JOIN`, `LEFT JOIN`)
- Advanced aggregation & conditional logic (`GROUP BY`, `HAVING`, `COALESCE`, `CASE WHEN`)
- Common Table Expressions (CTEs) & subqueries
- Analytical window functions (`LAG`, `DENSE_RANK`, `SUM() OVER`, `AVG() OVER`)
- Financial time-series analysis (MoM, YoY, trailing moving averages)

### Power BI & Business Intelligence
- Star Schema data modeling ($*:1$ relationship propagation)
- Power Query ETL data transformation and truncation debugging
- DAX measure engineering (`DIVIDE`, `SUM`, `COUNTROWS`, explicit measures)
- Custom date dimension modeling (`DATE_YY_MMMM` custom sorting)
- Dashboard user experience (UX), page layout design, and interactive slicing
- Business executive reporting and strategic recommendation synthesis

---
The repository contains SQL analysis scripts only; no source dataset is included in this package.

## ⚠️ Project Recovery & Documentation Statement

> **Note on File Availability:** Prior to repository deployment, the compiled binary Power BI dashboard file (`.pbix`) was lost due to a local storage failure. However, the complete analytical architecture—including SQL queries, Star Schema specifications, Power Query transformations, DAX measures, page-by-page visual layouts, and executive insights—has been fully reconstructed and documented in `dashboard/README.md`.

---

## ▶️ How to Use

1. **SQL Analytics:**
   - Import the source database tables listed in the Data Model section.
   - Run the scripts sequentially from `sql/01_data_quality.sql` through `sql/07_profitability_analysis.sql`.
2. **Data & Schema Review:**
   - Refer to `data/README.md` for complete data dictionary details and ingestion parameters.
3. **Power BI Architecture Review:**
   - Navigate to `dashboard/power_bi_dashboard_documentation.md` to examine the Star Schema model, DAX measure repository, visual layout specifications, and detailed business recommendations.

---
## 👤 Author

**Jaisarves M**

Data Analytics | SQL | Business Intelligence
