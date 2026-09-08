# Project Report

An end-to-end relational database analytics solution converting raw transactional data into actionable business intelligence. This project evaluates revenue trajectories, customer concentration risks, market-level profitability, product portfolio performance, and time-series trends across **148,395 transactions** (2017–2020) totaling **₹984.81 Million** in gross revenue.

---

## 📌 Business Objective & Overview

The primary objective of this project was to analyze a multi-year transactional sales dataset to uncover critical insights regarding revenue generation, customer distribution, product profitability, geographic performance, and temporal demand shifts. 

By applying advanced SQL querying, data auditing, window functions, and Common Table Expressions (CTEs), the analysis transforms unstructured transaction logs into executive-level reporting to drive strategic decision-making across sales, operations, and supply chain management.

### Key Executive Highlights

* **Total Revenue Analyzed:** ₹984.81 Million
* **Total Transactions Audited:** 148,395 line items
* **Time Horizon:** 2017 – 2020 (1,126 operational days)
* **Overall Portfolio Profit Margin:** $\sim 2.50\%$
* **Active Entities:** 38 Customers, 279 Products, 17 Geographic Markets
* **Core Problem Discovered:** Top-line revenue growth heavily masked severe profitability erosion—nearly $46\%$ of all individual transactions operated at a net financial loss, and customer revenue was dangerously concentrated within a small subset of clients.

---

## 📊 Dataset Profile & Schema Structure

The underlying database models a multi-region commercial supply chain across five primary tables:

* **`Transactions` (Central Fact Table):** 148,395 records containing core transactional attributes: `sales_amount`, `cost_price`, `profit_margin` (monetary profit value), `quantity`, `order_date`, `customer_code`, `product_code`, and `market_code`.
* **`Customers` (Dimension Table):** 38 records mapping `customer_code` and `customer_name`.
* **`Products` (Dimension Table):** 279 records mapping `product_code` and `product_type`.
* **`Markets` (Dimension Table):** 17 records mapping `market_code` and `market_name`.
* **`Date` (Dimension Table):** 1,126 records covering calendar attributes from 2017 to 2020.

---

## 🛠️ 10-Phase Analytical Framework

### Phase 1 — Data Understanding & Validation

#### Business Objective
Validate the integrity, mathematical consistency, and completeness of the transactional dataset prior to performing high-level executive aggregations.

#### SQL Techniques Used
`COUNT()`, `DISTINCT`, `MIN()`, `MAX()`, `NULL` Validation, Aggregate Functions, Conditional Joins, Arithmetic Integrity Audits.

#### Key Insights
* The verified dataset contains **148,395 transactions** spanning 2017 through 2020.
* Revenue and order date fields were $100\%$ complete with zero missing values.
* Master data quality gap identified: **59 products** lacked classification in `Products[product_type]`.
* Nearly **$46\%$ of all transactions** generated negative net profit.
* Audited financial logic confirmed that recorded monetary profit matched:

$$\text{Profit} = \text{Sales Amount} - \text{Cost Price}$$

#### Business Recommendations
1. Enforce master data validation constraints in upstream source databases to classify the 59 unassigned products.
2. Build automated data ingestion checks to catch record truncation or missing metadata before generating executive reports.
3. Conduct root-cause audits on why nearly half of all transactional line items operate at a loss.

---

### Phase 2 — Revenue Analysis

#### Business Objective
Evaluate company-wide top-line gross revenue performance and identify primary volume drivers.

#### SQL Techniques Used
`SUM()`, `GROUP BY`, `ORDER BY`, Aggregate Metrics.

#### Key Findings
* Total gross revenue reached **₹984.81 Million**.
* Revenue demonstrated steady momentum, peaking in 2018 before experiencing continuous declines through 2019 and 2020.
* High sales volume was maintained despite declining net financial margins.

#### Business Recommendations
1. Decouple sales volume tracking from business health evaluations; top-line scale must always be paired with net profitability.
2. Re-align revenue acquisition targets around margin-generating sales rather than gross volume.

---

### Phase 3 — Customer Analytics & Concentration Risk

#### Business Objective
Analyze customer contribution, identify revenue concentration risks, and segment accounts using Pareto principles.

#### SQL Techniques Used
`GROUP BY`, `DENSE_RANK()`, Window Functions, Cumulative `SUM() OVER()`, `CASE` Statements.

#### Key Insights
* The business served **38 unique customers** across the four-year timeline.
* **Extreme Concentration:** The single largest client contributed **$41.97\%$** of total gross revenue.
* **Pareto Principle Confirmed:** Approximately **12 customers** generated nearly **$80\%$** of total company revenue.
* Accounts were successfully segmented into Gold, Silver, and Bronze tiers based on revenue contribution thresholds.

#### Business Recommendations
1. Assign dedicated Key Account Managers to safeguard relationships with Gold-tier clients.
2. Implement customer diversification strategies to reduce reliance on the single dominant account ($41.97\%$ share).
3. Develop targeted retention and expansion plans for Silver-tier clients to build account balance.

---

### Phase 4 — Market Analytics

#### Business Objective
Evaluate regional operational performance to isolate high-margin territories from unprofitable sales regions.

#### SQL Techniques Used
`INNER JOIN`, `GROUP BY`, `SUM()`, Profit Margin Ratio Calculations, Regional Ranking.

#### Key Insights
* **Delhi NCR** generated **$52.75\%$** of total gross revenue but yielded a slim **$2.3\%$ profit margin**.
* **Surat** and **Patna** generated significantly lower sales volume but achieved substantially higher percentage margins.
* **Bengaluru** and **Kanpur** operated at net negative profit margins overall.

#### Business Recommendations
1. Review freight, logistics overhead, and regional discounting strategies in Bengaluru and Kanpur to eliminate loss-making operations.
2. Expand sales presence and logistics infrastructure in highly profitable regions like Surat and Patna.
3. Adjust contract pricing structures in Delhi NCR to extract better margins from high market share.

---

### Phase 5 — Product Analytics & Portfolio Health

#### Business Objective
Analyze unit demand, catalog performance, and individual product profitability to improve inventory planning.

#### SQL Techniques Used
`LEFT JOIN`, `GROUP BY`, Revenue Ranking, Profit Margin Calculation, Average Selling Price (ASP), Window Functions.

#### Key Insights
* Premium-priced products did not reliably yield higher percentage margins.
* High revenue was heavily concentrated in low-price, high-volume product lines.
* Several top-selling items operated on paper-thin or negative net margins.
* Most of the top-selling products lacked category assignments (`"Unknown"`), exposing significant data quality gaps.

#### Business Recommendations
1. Audit cost structures and vendor pricing agreements for high-volume, low-margin SKUs.
2. Align procurement and safety-stock levels with high-demand products to prevent stockouts.
3. Clean product master catalogs to ensure full category reporting.

---

### Phase 6 — Time Series Analytics

#### Business Objective
Track long-term sales trajectories, annual momentum, and seasonal demand cycles.

#### SQL Techniques Used
`GROUP BY`, `ORDER BY`, Date Extraction Functions, Monthly Aggregation.

#### Key Insights
* Annual revenue crested during 2018.
* Revenue experienced persistent post-2018 monthly declines.
* Total unit volume contracted sharply during 2020.
* Intra-year demand curves indicated consistent multi-year seasonality.

#### Business Recommendations
1. Investigate internal and market-level drivers behind the sustained post-2018 sales contraction.
2. Optimize procurement and warehouse staffing around historical seasonal demand cycles.

---

### Phase 7 — Month-over-Month (MoM) Growth Analysis

#### Business Objective
Measure short-term sales momentum and isolate sharp monthly variances.

#### SQL Techniques Used
Common Table Expressions (CTEs), `LEFT JOIN`, `LAG()` Window Function.

#### Key Insights
* Monthly performance showed significant short-term volatility.
* The steepest single-month revenue contraction occurred in **June 2020**.
* Revenue growth remained inconsistent across the entire evaluation horizon.

$$\text{MoM Growth \%} = \left( \frac{\text{Revenue}_t - \text{Revenue}_{t-1}}{\text{Revenue}_{t-1}} \right) \times 100$$

#### Business Recommendations
1. Establish automated monthly KPI alerts to flag negative MoM swings exceeding variance tolerances (e.g., $>10\%$ contraction).
2. Conduct operational post-mortems following unexpected monthly downturns.

---

### Phase 8 — Year-over-Year (YoY) Growth Analysis

#### Business Objective
Compare identical calendar months across consecutive years to evaluate true underlying trajectories without seasonal distortion.

#### SQL Techniques Used
`LAG()` with offset windowing, Multi-Period CTEs, Time Series Comparison.

#### Key Insights
* YoY comparisons confirmed continuous structural contractions across 2019 and 2020.
* YoY metrics provided a clearer representation of long-term business trajectory than unadjusted MoM figures.

#### Business Recommendations
1. Adopt Year-over-Year performance metrics as the primary standard for strategic executive planning and annual budgeting.
2. Address structural business issues contributing to multi-year revenue decline.

---

### Phase 9 — Moving Average Analysis

#### Business Objective
Smooth out short-term monthly volatility to reveal long-term trend trajectories.

#### SQL Techniques Used
`AVG() OVER()`, `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`, Window Frame Specifications.

#### Key Insights
* 3-month trailing moving averages effectively filtered out single-month sales spikes.
* Moving average trendlines highlighted a steady weakening of business momentum beginning after Q2 2018.

#### Business Recommendations
1. Utilize trailing moving averages for long-term demand planning and executive forecast reporting.
2. Combine moving average baselines with inventory reorder points to optimize working capital.

---

### Phase 10 — Profitability Analytics & Audit

#### Business Objective
Audit overall operational efficiency and evaluate bottom-line financial health.

#### SQL Techniques Used
`SUM()`, Calculated Financial KPIs, Ratio Analysis.

#### Key Insights
* Company-wide profit margin averaged **$\sim 2.50\%$** across ₹984.81 Million in revenue.
* Nearly **$46\%$ of all transactions** generated negative profit.
* High revenue scale frequently failed to produce healthy net dollar returns.

$$\text{Profit Margin \%} = \left( \frac{\sum \text{profit\_margin}}{\sum \text{sales\_amount}} \right) \times 100 \approx 2.50\%$$

#### Business Recommendations
1. Enforce strict minimum margin floors across sales contracts to eliminate unviable discounts.
2. Re-evaluate supplier procurement costs and warehouse logistics to reduce cost of goods sold (COGS).

---

## 💻 Major SQL Concepts Demonstrated

```
+-----------------------------------------------------------------------------------+
|                            TECHNICAL SQL CAPABILITIES                             |
+-----------------------+-----------------------------------------------------------+
| Domain                | Functions & Methods Applied                               |
+-----------------------+-----------------------------------------------------------+
| Basic & Advanced Query| SELECT, WHERE, GROUP BY, HAVING, ORDER BY                 |
| Relational Operations | INNER JOIN, LEFT JOIN, Composite Join Predicates          |
| Aggregations          | SUM(), AVG(), COUNT(), COUNT(DISTINCT), MIN(), MAX()      |
| Conditional Logic     | CASE WHEN, COALESCE(), NULL Validation                    |
| Modular SQL           | Common Table Expressions (CTEs), Nested Subqueries        |
| Analytical Windowing  | LAG(), DENSE_RANK(), Cumulative SUM(), Moving AVG()       |
| Time Series & Framing | DATE_FORMAT(), YEAR(), MONTH(), ROWS BETWEEN              |
+-----------------------+-----------------------------------------------------------+
```

---

## 📈 Strategic Summary & Final Business Impact

```
+-----------------------------------------------------------------------------------+
|                               SUMMARY PERFORMANCE BOARD                           |
+-----------------------+-------------------+---------------------------------------+
| Metric / Metric Area  | Recorded Value    | Strategic Impact                      |
+-----------------------+-------------------+---------------------------------------+
| Total Gross Revenue   | ₹984.81 Million   | Broad commercial scale and presence   |
| Portfolio Net Margin  | ~2.50%            | Fragile overall operational returns   |
| Loss-Making Orders    | 46.00%            | High proportion of unviable sales     |
| Top Client Share      | 41.97%            | Severe account concentration risk     |
| Top Market Share      | 52.75% (Delhi)    | Dominant market with narrow margin    |
| Unclassified SKUs     | 59 Products       | Reporting & inventory master data gap |
+-----------------------+-------------------+---------------------------------------+
```

### Final Impact

This project converted raw transactional logs into a structured business intelligence asset. By examining customer concentration, geographic margins, product performance, and multi-year time-series dynamics, the analysis uncovered critical operational risks obscured by top-line revenue numbers. 

Implementing the strategic recommendations—enforcing margin floors, diversifying the account base, restructuring loss-making markets, and cleaning product master data—provides a clear roadmap to transition the organization from pure revenue scale to sustainable profitability.
