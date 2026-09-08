# 📊 Power BI Sales & Profitability Dashboard Documentation

## ⚠️ Project Recovery & Data Integrity Statement

> **Note on File Availability:** Prior to repository deployment, the compiled binary Power BI dashboard file (`.pbix`) was lost due to a local technical storage failure. However, the complete analytical architecture—including database validation queries, Star Schema data modeling specifications, Power Query ETL transformations, explicit DAX measure definitions, page-by-page visual designs, and executive insights—has been fully reconstructed and preserved from development logs and SQL audit records.
>
> This document serves as an exhaustive, production-grade technical manual for the Power BI layer of the **Sales Analytics Project**.

---

## 📌 Executive Summary & Architecture Overview

The Power BI dashboard layer bridges transactional data (audited across **148,395 transactions** from **2017 to 2020**) with executive-level financial reporting. By moving beyond top-line revenue metrics, the dashboard evaluates operational cost structures, raw dollar returns, customer concentration risks, and product line margins across **38 clients**, **279 products**, and **17 regional markets**.

### Core Performance Metrics
* **Total Transactions Audited:** 148,395
* **Time Horizon:** 2017 – 2020 (1,126 Days)
* **Overall Portfolio Net Profit Margin:** $\sim 2.50\%$
* **Data Model Architecture:** Single-Fact Star Schema ($*:1$ Cardinality)

---

## 📐 Data Modeling & Star Schema Architecture

The data model was constructed as a single-fact **Star Schema** to ensure optimal query performance, efficient memory usage, and predictable DAX filter propagation across visual elements.

```text
                   +------------------+
                   |    Customers     |
                   |------------------|
                   | PK customer_code |
                   +--------+---------+
                            | 1
                            |
                            | *
+------------------+       +--------------------+       +------------------+
|     Markets      |       |    Transactions    |       |     Products     |
|------------------|       |--------------------|       |------------------|
| PK  market_code  |1    * | FK customer_code   | *    1| PK product_code  |
+--------+---------+-------+ FK market_code     +-------+--------+---------+
                           | FK product_code    |
                           | FK date            |
                           +--------+-----------+
                                    | *
                                    |
                                    | 1
                           +--------+-----------+
                           |        Date        |
                           |--------------------|
                           | PK date            |
                           |    DATE_YY_MMMM    |
                           +--------------------+
```

### Table & Relationship Specifications

| Table Name | Entity Type | Confirmed Row Count | Primary Key / Foreign Key | Relationship & Cardinality | Cross-Filter Direction |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`Transactions`** | Central Fact | **148,395** | Composite / FKs | Many Side (`*`) | Target of Filters |
| **`Customers`** | Dimension | **38** | PK: `customer_code` | One-to-Many (`1:*`) | Downstream to Fact |
| **`Products`** | Dimension | **279** | PK: `product_code` | One-to-Many (`1:*`) | Downstream to Fact |
| **`Markets`** | Dimension | **17** | PK: `market_code` | One-to-Many (`1:*`) | Downstream to Fact |
| **`Date`** | Dimension | **1,126** | PK: `date` | One-to-Many (`1:*`) | Downstream to Fact |

---

## 🛠️ Power Query ETL & Data Transformation Pipeline

1. **Dataset Truncation Bug Fix (Critical Resolution):**
   * *Issue:* Initial Power Query imports were truncated to a sample CSV of **5,000 records**, severely warping total revenue calculations.
   * *Resolution:* Traced data pipeline parameters, re-extracted source files, and successfully loaded the complete **148,395 transaction records** into Power Query.

2. **Custom Date Dimension Engineering:**
   * Power BI's automatic date hierarchies were disabled to reduce runtime memory overhead and eliminate auto-generated date tables.
   * Constructed an explicit `Date` dimension table with a custom display and sorting attribute: `DATE_YY_MMMM` (e.g., `"2019-January"`). The `DATE_YY_MMMM` column was configured with **Sort by Column** set to an integer date key to guarantee chronological ordering in visual axis displays.

3. **Product Master Data Quality Audit:**
   * Identified metadata gaps where high-revenue products lacked a valid classification in `Products[product_type]` and were tagged as `"Unknown"`.
   * Flagged this issue for upstream database governance while maintaining the records in the model to avoid revenue distortion.

4. **Column Data Types & Schema Audit:**
   * Verified data types across all fields: `sales_amount` (Fixed Decimal), `cost_price` (Fixed Decimal), `profit_margin` (Fixed Decimal), `quantity` (Integer), `date` (Date).

---

## 🧮 DAX Measures & Financial Logic

All KPIs, visual aggregations, and visual calculations were driven by explicit DAX measures stored in a dedicated measure table.

### Key Financial Interpretation Rule
In the source schema, the field `Transactions[profit_margin]` stores the **raw monetary net profit (\$ or local currency)** for each line item (e.g., $\text{Sales} = \$102.00$, $\text{Cost} = \$73.44$, $\text{Profit Value} = \$28.56$). The percentage profit margin is calculated dynamically via DAX using ratio division.

$$\text{Profit Margin \%} = \left( \frac{\sum \text{profit\_margin}}{\sum \text{sales\_amount}} \right) \times 100$$

### Measure Repository

```dax
-- 1. Total Gross Revenue
Total Revenue = 
SUM(Transactions[sales_amount])

-- 2. Total Operational Cost
Total Cost = 
SUM(Transactions[cost_price])

-- 3. Total Dollar Net Profit
Total Profit = 
SUM(Transactions[profit_margin])

-- 4. Overall Percentage Profit Margin (~2.50%)
Profit Margin % = 
DIVIDE(
    [Total Profit], 
    [Total Revenue], 
    0
)

-- 5. Total Units Sold
Total Quantity = 
SUM(Transactions[quantity])

-- 6. Total Transactions Processed
Total Transactions = 
COUNTROWS(Transactions)
```

---

## 📊 Dashboard Pages & Visual Architecture

The visual presentation comprised **5 distinct pages**, designed according to user-experience best practices and clear information hierarchy.

### Page 1: Executive Overview
* **Target Audience:** Executive Leadership & C-Suite.
* **Core Goal:** High-level summary of total sales, operational cost efficiency, and overall net dollar returns.
* **KPI Cards:** `Total Revenue`, `Total Cost`, `Total Profit`, `Profit Margin %`.
* **Visual Components:**
  * Monthly Revenue vs. Profit Trend Chart (Line and Clustered Column Chart).
  * Revenue & Profit Margin by Market Region (Bar Chart / Map).
  * Top 5 Customer Accounts by Total Sales Contribution (Horizontal Bar Chart).
* **Global Slicers:** Date Range / Year (`2017`–`2020`), Market Region, Product Category.

### Page 2: Sales & Time Performance Analysis
* **Target Audience:** Sales Directors & Operational Managers.
* **Core Goal:** Temporal breakdown of sales trajectories, evaluating seasonality and YoY momentum.
* **Visual Components:**
  * Chronological Monthly Performance line graph utilizing `DATE_YY_MMMM`.
  * Year-over-Year (YoY) Sales Comparison Bar Visuals ($2017 \rightarrow 2020$).
  * Transaction Volume & Order Quantity trends over time.
* **Interactive Features:** Drill-down from Year $\rightarrow$ Quarter $\rightarrow$ Month.

### Page 3: Customer & Market Analysis
* **Target Audience:** Key Account Managers & Regional Sales Leads.
* **Core Goal:** Identifying customer concentration risk and isolating high-scale versus low-margin markets.
* **Visual Components:**
  * Customer Sales vs. Profit Margin Matrix/Scatter Plot.
  * Revenue Concentration Pareto Chart (Top-tier customer percentage of total revenue).
  * Market Viability Matrix (Sorting 17 markets by `Total Revenue` vs. `Profit Margin %`).
* **Slicers:** Customer Name, Market Name.

### Page 4: Product & Profitability Analysis
* **Target Audience:** Product Managers & Procurement Teams.
* **Core Goal:** Evaluating unit sales vs. profit margins across 279 products and surfacing data quality gaps.
* **Visual Components:**
  * Top 10 and Bottom 10 Products by Profit Margin %.
  * Volume vs. Margin Scatter Chart (Units Sold on X-axis, Margin % on Y-axis).
  * Data Quality Audit Card: Isolating total revenue tied to `product_type = "Unknown"`.
* **Slicers:** Product Type, Product Code search.

### Page 5: Granular Performance Breakdown
* **Target Audience:** Data Analysts & Operational Auditors.
* **Core Goal:** Line-item level auditing and drill-through analysis.
* **Visual Components:**
  * Detail Data Table containing transactional dimensions (`order_date`, `customer_name`, `product_name`, `market_name`, `quantity`, `sales_amount`, `cost_price`, `profit_margin`).
  * Dynamic conditional formatting highlighting negative profit line items in red.

---

## 🎯 Key Performance Indicators (KPIs) Summary

| KPI Name | Current Portfolio Value | Target Benchmark | Business Significance |
| :--- | :--- | :--- | :--- |
| **Total Revenue** | Full Scale Total | Top-line scale | Tracks gross market activity |
| **Total Operational Cost** | Full Cost Total | Minimize cost erosion | Measures overhead and production expenditure |
| **Total Net Profit** | Full Net Dollars | Maximize dollar return | Measures real financial gain |
| **Profit Margin %** | **~2.50%** | **> 5.00%** | Primary operational efficiency metric |
| **Transaction Volume** | 148,395 | Operational throughput | Tracks order process load |

---

## 💡 Key Analytical Insights

1. **Tight Portfolio Margins ($\sim 2.50\%$):** 
   High top-line revenue figures obscure severe operational inefficiencies. A gross portfolio margin of $2.50\%$ leaves the business vulnerable to cost inflation or supply chain fluctuations.

2. **Revenue Scale vs. Profitability Disconnect:** 
   Several of the top-performing geographic markets drive substantial sales volume but yield near-zero or negative net profit margins due to high operational costs.

3. **Customer Concentration Risk:** 
   Over $50\%$ of gross revenue is generated by a small subset of the 38 customer accounts, creating severe risk if key client churn occurs.

4. **Product Metadata Distortion:** 
   A significant portion of total revenue belongs to products tagged as `"Unknown"` under `product_type`, preventing full attribution during category reviews.

---

## 📢 Strategic Business Recommendations

1. **Shift Executive Strategy from Revenue to Net Margin:** Realign sales targets, commissions, and regional bonuses around `Profit Margin %` rather than gross sales volume.
2. **Audit Loss-Making Products & Markets:** Review pricing structures or renegotiate vendor costs for bottom-tier products operating at negative net margins.
3. **Database Remediation:** Enforce mandatory data validation constraints on `Products[product_type]` in source databases to eliminate untagged `"Unknown"` classifications.
4. **Account Diversification:** Focus acquisition pipelines on medium-sized clients to reduce concentration risk on top account holders.

