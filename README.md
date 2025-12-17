## Contoso-General-Analysis-SQL

This project is based on Contoso retail analysis, the aim (analysis goals) of which is to understand the overall performance of business operations and the result of the analysis to make or help in decision-making for stakeholders(s) to improve business health.

### Datasets

This datasets or database file is a fictional dataset created by Microsoft, it's about a hardware retail (online) store. The purpose of creating the dataset is to help learners practice their SQL (PostgreSQL, SQLite, MySQL, Power BI, etc.) skills and extend their knowledge beyond. It consists of one fact (sales) table, four dimensions (date, customer, product, and store) tables, and one other (exchange) table that has no relationship with any of the other tables.
Let's dive in

[Queries File](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/contoso_analysis.sql)

### Tools
- VS Code
- DBcode (VS Code Extension, it provides a Jupyter notebook-like interface for interactive querying)
- PostgreSQL
- Contoso_db file

### Functions Used
- Aggregation Function (Sum, Count)
- Scaler Functions (Date_Trunc(), Extract, To_Char, Round, DATE, TEXT, NUMERIC etc)
- Statistical Functions (Avg, Min, Max)
- Windows Functions (RANK, DENSE_RANK, NTILE, LAG, Moving Average, CumSum

### Analysis Steps
- Sales Performance Analysis
- Customer Analysis
- Product Analysis
- Time Analysis

[Queries File](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/contoso_analysis.sql)

## Sale Performance Analysis

### Analysis And Business Question

1. **How much revenue are we generating overall:**

  > The Total Revenue we have generated is **$203,723,867.07** in total

2. **Is our revenue increasing or decreasing compared to the last period?**

| Order year | Revenue     | Pct change |
| :--------- | :---------- | :--------- |
| 2015-01-01 | $7,563,504.71  | 0%      |
| 2016-01-01 | $10,492,836.62 | 39%      |
| 2017-01-01 | $13,356,053.79 | 27%      |
| 2018-01-01 | $24,936,034.34 | 87%      |
| 2019-01-01 | $31,509,447.70 | 26%     |
| 2020-01-01 | $11,066,210.09 | -65%     |
| 2021-01-01 | $21,410,725.38 | 93%      |
| 2022-01-01 | $43,426,105.74 | 103%    |
| 2023-01-01 | $31,871,225.18 | -27%    |
| 2024-01-01 | $8,091,723.52  | -75%    |

3. **How many orders are customers placing**

  > Customer placed a total of 83,130 orders across the years

4. **Is order volume growing with time**

![order_volume_by_year](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/OrderVolumeByyear.png)

  > Order volumes are growing with time, with the peak being **2022** and a decline both in 2020 and 2024

5. **On average how much, how much does each customer spend**

  > On average customer spend **$4,116.71** 

6. **Which period shows the strongest and weakest growth**

  > 2022 shows the strongest growth and 2024, the weakest

7. **How fast are our sales growing yearly**

  > On average our sales was growing at **23%** yearly from the previous year

  [Queries File](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/contoso_analysis.sql)

8. **Which category(s) contribute the most to revenue**

  ![sales_by_cat.](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/SalesByCategory.png)

  > The Computers Category **(44%)** contributes the most to revenue, followed by Cell Phones **(16%)**

 ## Customer Analysis
 
9. **How many unique buyers are buying from us**

  > The Total number of customers buying from us is: **49,487**

10. **Are we expanding our customer base over time**

  ![customer_acquire_per_year](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/CustomerAcquisition(FirstPurchase)ByYear.png)

11. **How much is each customer worth over their entire relationship with us (Behavioural Analysis)**

    [Customer LTV file](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/customer_ltv.html)

12. **Average revenue per user increasing with time**

  ![customer_avg_by_year](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/CustomerAVGSpendByYear.png)

13. **What share of customers make more than 1 purchase**

  ![repeat_purchase](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/purchase(repeatvsonce).png)

  > About **44%** of customers purchase repeatedly; our retention efforts are working, but can still be improved upon.

## Product Analysis

14. **Which products are our best sellers (top 10)**

  ![top10_best_sellers](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/Top10ProductBysale.png)

15. **Do top products differ by region**

  ![top_product_by_region](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/TopProductByCountry.png)

> The top **2** products don't really differ by region except in colour variation

[Queries File](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/contoso_analysis.sql)

16. Do top products differ by season (months in years)

[Top product by season (year)](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/top_product_by_season.html)

17. **Which top 10 products are the most profitable**

  ![Top profitable Product](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/Top10MostProfitableProducts.png)

18. **What percentage of total revenue comes from each category and the category to prioritize during promotion**

  ![Sales Share By category](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/SalesByCategory.png)

| Categoryname                  | Revenue     | Pct share |
| :---------------------------- | :---------- | :-------- |
| Computers                     | 95455490.99 | 44%    |
| Cell phones                   | 34072136.45 | 16%     |
| Home Appliances               | 27894563.74 | 13%    |
| TV and Video                  | 21371302.77 | 10%    |
| Cameras and camcorders        | 19511997.82 | 9%     |
| Music, Movies and Audio Books | 11047053.58 | 5%     |
| Audio                         | 5572794.14  | 3%     |
| Games and Toys                | 1749979.68  | 1%     |


## Time Analysis

19. **Monthly revenue trend**

  ![monthly sales trend](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/MonthlySalesTrend.png)

20. **Is revenue stable or seasonal**

  ![seasonality](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/SeasonalSale.png)

  > Revenue is Seasonal

21. **Which Month generates the Highest sales?**

  ![sales_trend](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/SalesTrend.png)

  | Month name | Sale        |
| :--------- | :---------- |
| Jan        | $19,647,340.15 |
| Feb        | $25,656,119.25 |
| Mar        | $13,401,720.10 |
| Apr        | $7,044,374.50  |
| May        | $17,047,743.92 |
| Jun        | $18,585,158.07 |
| Jul        | $14,400,505.03 |
| Aug        | $15,925,243.69 |
| Sep        | $16,555,169.35 |
| Oct        | $17,247,648.57 |
| Nov        | $17,239,553.01 |
| Dec        | $20,973,291.43 |

  > The month of **February** generates the highest revenue

[Queries File](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/contoso_analysis.sql)

22. **Who are our top customers by total sales in each region (RANK)**

| Country | Customerkey | Givenname | Revenue  | Rank  |
| :------ | :---------- | :-------- | :------- | :---- |
| AU      | 72844       | Ben       | 55026.30 | 1     |
| CA      | 399184      | Peter     | 57051.11 | 1     |
| DE      | 552225      | Janina    | 62044.12 | 1     |
| FR      | 680583      | Oliver    | 45153.78 | 1     |
| GB      | 1151535     | Dylan     | 49382.45 | 1     |
| IT      | 724961      | Arcangela | 42053.47 | 1     |
| NL      | 861510      | Natacha   | 34815.82 | 1     |
| US      | 1743963     | Patricia  | 65431.97 | 1     |

23. **How are sales cumulating over time**

  ![cumulative sum](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/CummulativeSumOverTime.png)

24. **How is average order value changing over time (3 months moving average)**

 ![3 months moving avg](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/AverageOrderValueOverTime(3MonthsMovingAvg).png)

25. **What is the (avg) time gap between each purchase of a customer**

  ![avg time gap](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/Gaps_between_purchase.png)

26. **What are the top 5 products in each category (DENSE RANK)**

  [Top 5 products in each category](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/query/top_products_5_by_category.csv)

27. **Segment customers into quartiles based on spending behaviour**

  ![customer segment](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/customer_spending.png)



## Recommendations

The following recommendations are derived directly from the SQL analysis performed on the Contoso retail dataset. They are intended to support data-driven decision-making for business stakeholders.

---

### 1. Revenue Stability and Growth

- Revenue growth is inconsistent across years, with sharp declines in 2020, 2023, and 2024.
- **Action:** Investigate operational or data completeness issues in low-performing years, especially 2024, before making long-term strategic decisions.
- **Action:** Use 2022 (highest revenue and order volume) as a benchmark year to evaluate pricing, promotions, and inventory strategy.

---

### 2. Category-Level Focus

- The **Computers** category contributes **44% of total revenue**, making it the primary revenue driver.
- **Action:** Prioritize inventory availability, promotions, and product expansion in this category.
- **Action:** Allocate secondary focus to **Cell Phones (16%)** and **Home Appliances (13%)**, which show strong revenue potential.

- Low-performing categories such as **Games & Toys (1%)** and **Audio (3%)** contribute minimally.
- **Action:** Reduce SKU depth or use these categories primarily for cross-selling rather than standalone promotions.

---

### 3. Product Strategy

- Best-selling products are largely consistent across regions, with only minor variations (e.g., color).
- **Action:** Standardize core product offerings globally while localizing cosmetic variants.
- **Action:** Promote products based on **profitability**, not just sales volume, to improve overall margins.

---

### 4. Customer Retention

- Only **44% of customers** make repeat purchases.
- **Action:** Focus on retention strategies such as loyalty incentives, second-purchase discounts, and targeted remarketing.
- **Action:** Time retention campaigns using the observed average gap between customer purchases.

- Customer spending varies significantly across quartiles.
- **Action:** Use spending-based segmentation to deliver differentiated offers to high- and low-value customers.

---

### 5. Seasonal Optimization

- Revenue is strongly seasonal, with **February** and **December** generating the highest sales.
- **Action:** Increase marketing spend and inventory levels ahead of peak months.
- **Action:** Scale back growth-focused campaigns during weak months (e.g., April) and use clearance or cost-control strategies instead.

---

### 6. Order Value Improvement

- Average Order Value (AOV) shows fluctuation over time.
- **Action:** Introduce product bundles, cross-sell accessories, and minimum-spend incentives to increase AOV.
- **Action:** Monitor AOV using moving averages to detect early changes in customer purchasing behavior.

---

### 7. Data & Analysis Enhancements

- Revenue-only analysis limits insight into true business performance.
- **Action:** Incorporate cost, margin, and discount data to enable profitability-focused analysis.
- **Action:** Implement cohort-based retention analysis to track long-term customer behavior trends.

---

### 8. Strategic Priority Summary

- Short-term priority: Stabilize revenue volatility and validate recent-year data.
- Mid-term priority: Improve customer retention and average order value.
- Long-term priority: Focus on high-margin products and dominant revenue categories to sustain growth.

---
