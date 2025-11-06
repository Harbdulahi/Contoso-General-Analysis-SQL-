## Contoso-General-Analysis-SQL

This project is based on Contoso retail analysis, the aim (analysis goals) of which is to understand the overall performance of business operations and the result of the analysis to make or help in decision-making for stakeholders(s) to improve business health.

### Datasets

This datasets or database file is a fictional dataset created by Microsoft, it's about a hardware retail (online) store. The purpose of the dataset's creation is to help learners practice their SQL (PostgreSQL, SQLITE, MYSQL, Power BI, etc) skills and far beyond. It consists of 1 fact (sales) table, 4 dimensions (date, customer, product, and store) table, and 1 other (exchange) table that has no relationship with any of the other tables.
Let's dive in

[Query File]

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

[Query File]

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

21. **Which Month generate the Highest sale**

  ![sales_trend](https://github.com/Harbdulahi/Contoso-General-Analysis-SQL-/blob/main/contoso/png/SalesTrend.png)

  | Month name | Sale        |
| :--------- | :---------- |
| Jan        | $19,647,340.15 |
| Feb        | $25,656,119.25 |
| Mar        | $13401720.10 |
| Apr        | $7044374.50  |
| May        | $17047743.92 |
| Jun        | $18585158.07 |
| Jul        | $14400505.03 |
| Aug        | $15925243.69 |
| Sep        | $16555169.35 |
| Oct        | $17247648.57 |
| Nov        | $17239553.01 |
| Dec        | $20973291.43 |


  
