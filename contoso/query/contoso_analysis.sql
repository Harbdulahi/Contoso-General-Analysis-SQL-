-- This project is based on contoso retail analysis, the aim (analysis goals) which is to understand the overall performance of business operations and the result of analysis to
-- help make or help in decision making to improve business health.

-- Datasets
-- This datasets or database file is a fictional dataset created by Microsoft it's about a hardware retail (online) store, the purpose of the datasets creation is to help learners
-- practice there SQL (PostgresQL, SQLITE, MYSQL, Power BI etc) skill and far beyond. it consist of 1 fact (sales) table, 4 dimension (date, customer, product and store) table 
-- and 1 other (exchange) table that has no relationship with any of the other tables.

-- Let dive in



-- Sales Performance Analysis And Business question

---- How much revenue are generating overall----

SELECT
    SUM(ROUND((netprice * quantity)::NUMERIC, 2)) AS "revenue"
FROM
    sales;

--------------------------------------------

---- Is our revenue increasing or decreasing compare to last period---
WITH
    order_year_cte AS (
        SELECT
            DATE_TRUNC('year', orderdate)::DATE AS order_year,
            SUM(ROUND((netprice * quantity)::NUMERIC, 2)) AS revenue
        FROM
            sales
        GROUP BY
            order_year
        ORDER BY
            order_year ASC
    )
SELECT
    *,
    ROUND(
        ((revenue - previous_revenue) / previous_revenue)::NUMERIC,
        2
    ) * 100 AS pct_change
FROM
    (
        SELECT
            order_year,
            revenue,
            LAG(revenue) OVER (
                ORDER BY
                    order_year
            ) AS previous_revenue
        FROM
            order_year_cte
    );

---------------------------------------------------------------

--- How many orders are customers placing---
SELECT
    COUNT(DISTINCT orderkey) AS order_count
FROM
    sales;

----------------------------------------------------------------

--- Are order volume growing with time---
SELECT
    EXTRACT(
        YEAR
        FROM
            orderdate
    )::TEXT AS _year,
    COUNT(DISTINCT orderkey) AS unique_orders
FROM
    sales
GROUP BY
    _year;

----------------------------------------------------------------

--- On average how much, how much does each customer spend-----
SELECT
    ROUND(
        (
            SUM(quantity * netprice) / COUNT(DISTINCT customerkey)
        )::NUMERIC,
        2
    ) AS customer_avg
FROM
    sales;

---------------------------------------------------------------

--- Which period shows the strongest and weakest growth ---

WITH
    order_year_cte AS (
        SELECT
            DATE_TRUNC('year', orderdate)::DATE AS order_year,
            SUM(ROUND((netprice * quantity)::NUMERIC, 2)) AS revenue
        FROM
            sales
        GROUP BY
            order_year
        ORDER BY
            order_year ASC
    )
SELECT
    order_year,
    ROUND(
        ((revenue - previous_revenue) / previous_revenue)::NUMERIC,
        2
    ) * 100 AS pct_change
FROM
    (
        SELECT
            order_year,
            revenue,
            LAG(revenue) OVER (
                ORDER BY
                    order_year
            ) AS previous_revenue
        FROM
            order_year_cte
    );

    -------------------------------------------------------------

    --- How fast are our sales growing yearly ---
WITH
    order_year_cte AS (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    orderdate
            ) AS order_year,
            SUM(ROUND((netprice * quantity)::NUMERIC, 2)) AS revenue
        FROM
            sales
        GROUP BY
            order_year
        ORDER BY
            order_year ASC
    )
SELECT
    ROUND(AVG(
        ((revenue - previous_revenue) / previous_revenue))::NUMERIC,
        2
    ) * 100 || '%' AS AVG_pct_change
FROM
    (
        SELECT
            order_year,
            revenue,
            LAG(revenue) OVER (
                ORDER BY
                    order_year
            ) AS previous_revenue
        FROM
            order_year_cte
    );

--------------------------------------------------------------------------

--- Which category(s) contribute the most to revenue ----
WITH
    category_sale AS (
        SELECT
            p.categoryname AS category,
            SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS total_sale
        FROM
            sales s
            LEFT JOIN product p on s.productkey = p.productkey
        GROUP BY
            category
        ORDER BY
            total_sale DESC
    )
SELECT
    *,
    ROUND(
        (
            total_sale / (
                SELECT
                    SUM(total_sale)
                FROM
                    category_sale
            )
        )::NUMERIC,
        2
    ) * 100 AS pct_share
FROM
    category_sale;

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------


-- Customer Analysis (Business question)

--- How many unique are buying from us ---
SELECT
    COUNT(DISTINCT customerkey) AS customer_count
FROM
    sales;

-----------------------------------------------------------------------

--- are we expanding our customer base over time ---

WITH
    first_purchase AS (
        SELECT
            customerkey,
            MIN(orderdate) AS first_purchase_year
        FROM
            sales
        GROUP BY
            customerkey
        ORDER BY
            first_purchase_year
    )

SELECT
    "year",
    COUNT(customerkey) AS customer_first_purchase
FROM
    (
        SELECT
            customerkey,
            DATE_TRUNC('year', first_purchase_year)::DATE AS "year"
        FROM
            first_purchase
    )
GROUP BY
    "year"
ORDER BY
    year ASC;

---------------------------------------------------------------------

--- How much is each customer worth over their entire relationship with us ---
-- Customer LTV using behavioural segmentation --
WITH
    cltv_ AS (
        SELECT
            customerkey,
            COUNT(DISTINCT orderkey) AS order_count,
            SUM(quantity * netprice) / COUNT(DISTINCT orderkey) AS aov,
            (MAX(orderdate) - MIN(orderdate)) / 30 AS age_month
        FROM
            sales
        GROUP BY
            customerkey
        HAVING
            (MAX(orderdate) - MIN(orderdate)) / 30 > 0
    )
SELECT
    *,
    ROUND((order_count::NUMERIC / age_month::NUMERIC), 5) AS purchase_freq_month,
    ROUND((order_count * aov * (order_count::NUMERIC / age_month))::NUMERIC) AS LTV
FROM
    cltv_;

----------------------------------------------------------------------

--- Average revenue per user increasing with time ---
-- How much does each customer spend on average --
SELECT
    EXTRACT(
        YEAR
        FROM
            orderdate
    )::TEXT AS order_year,
    SUM(quantity * netprice) / COUNT(DISTINCT customerkey) AS arpu
FROM
    sales
GROUP BY
    order_year;

-----------------------------------------------------------------------

--- What share of customers makes more than 1 purchase ----
WITH
    customer_order AS (
        SELECT
            customerkey,
            COUNT(DISTINCT orderkey) as unique_order_count
        FROM
            sales
        GROUP BY
            customerkey
    ),
    repeat_purchase_type AS (
        SELECT
            customerkey,
            unique_order_count,
            CASE
                WHEN unique_order_count > 1 THEN 'repeat'
                ELSE 'once'
            END AS order_count_type
        FROM
            customer_order
    ),
    once_vs_repeat_count AS (
        SELECT
            order_count_type,
            COUNT(order_count_type) AS count
        FROM
            repeat_purchase_type
        GROUP BY
            order_count_type
    )
SELECT
    *,
    ROUND(
        (
            count / (
                SELECT
                    SUM(count)
                FROM
                    once_vs_repeat_count
            )
        )::NUMERIC,
        2
    )*100 AS pct_share
FROM
    once_vs_repeat_count;

------------------------------------------------------------------
------------------------------------------------------------------
------------------------------------------------------------------

--- Product Analysis (Business question)

-----------------------------------------------------------------------

--- Do top product differ by region ---
WITH
    products_sales AS (
        SELECT
            c.country,
            p.productname,
            SUM(ROUND((s.quantity * s.netprice)::NUMERIC, 2)) AS revenue
        FROM
            sales s
            LEFT JOIN product p ON s.productkey = p.productkey
            LEFT JOIN customer c ON s.customerkey = c.customerkey
        GROUP BY
            c.country,
            p.productname
        ORDER BY
            revenue DESC,
            c.country ASC
    ),
    top_product_rank AS (
        SELECT
            *,
            RANK() OVER (
                PARTITION BY
                    country
                ORDER BY
                    revenue DESC
            ) AS rank
        FROM
            products_sales
    )
SELECT
    *
FROM
    top_product_rank
WHERE
    rank = 1
ORDER BY
    productname ASC;

---------------------------------------------------------------------

--- Do top product differ by season (months in years) ---
WITH
    seasonal_sale AS (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    orderdate
            ) AS "year",
            TO_CHAR(orderdate, 'Month') AS "month_name",
            EXTRACT(
                MONTH
                FROM
                    orderdate
            ) AS "month_no",
            p.productname,
            SUM(ROUND((s.quantity * s.netprice)::NUMERIC, 2)) AS revenue
        FROM
            sales s
            LEFT JOIN product p ON s.productkey = p.productkey
        GROUP BY
            "year",
            "month_name",
            "month_no",
            p.productname
        ORDER BY
            "year",
            "month_no" ASC,
            revenue DESC
    ),
    product_rank_by_season AS (
        SELECT
            "year",
            "month_name",
            productname,
            revenue,
            RANK() OVER (
                PARTITION BY
                    "year",
                    "month_name"
                ORDER BY
                    revenue DESC
            ) AS rank
        FROM
            seasonal_sale
        ORDER BY
            "year",
            "month_no"
    )
SELECT
    *
FROM
    product_rank_by_season
WHERE
    rank = 1;


------------------------------------------------------------------

--- Which top 10 products are the most profitable ---
SELECT
    p.productname,
    SUM(ROUND((s.unitcost * s.quantity)::NUMERIC, 2)) AS "profit"
FROM
    sales s
    LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY
    p.productname
ORDER BY
    "profit" DESC
LIMIT 10;

-------------------------------------------------------------------

--- What percentage of total revenue comes from each category and the category to prioritize during promotion ---

WITH
    revenue_by_category AS (
        SELECT
            p.categoryname,
            SUM(ROUND((s.quantity * s.unitprice)::NUMERIC, 2)) AS "revenue"
        FROM
            sales s
            LEFT JOIN product p ON s.productkey = p.productkey
        GROUP BY
            p.categoryname
        ORDER BY
            "revenue" DESC
    )
SELECT
    *,
    ROUND(
        (
            "revenue" / (
                SELECT
                    SUM("revenue")
                FROM
                    revenue_by_category
            )
        )::NUMERIC,
        2
    ) * 100 AS pct_share
FROM
    revenue_by_category;

---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

-- Time Analysis (Business Questions) --

--------------------------------------------------------------------

--- monthly revenue trend ---
SELECT
    TO_CHAR(orderdate, 'YYYY-mm') AS "month",
    SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "revenue"
FROM
    sales
GROUP BY
    "month"
ORDER BY
    "month";

----------------------------------------------------------------------

--- Is revenue stable or seasonal ---
-- Which month should we ramp inventory/marketing

WITH
    revenue_by_month AS (
        SELECT
            TO_CHAR(orderdate, 'Month') AS "month_name",
            EXTRACT(
                MONTH
                FROM
                    orderdate
            ) AS "month_no",
            EXTRACT(
                YEAR
                FROM
                    orderdate
            ) AS "year",
            ROUND((quantity * netprice)::NUMERIC, 2) AS "sale"
        FROM
            sales
    )
SELECT
    "month_no",
    "month_name",
    SUM(
        CASE
            WHEN "year" = 2015 THEN "sale"
        END
    ) AS "2015",
    SUM(
        CASE
            WHEN "year" = 2016 THEN "sale"
        END
    ) AS "2016",
    SUM(
        CASE
            WHEN "year" = 2017 THEN "sale"
        END
    ) AS "2017",
    SUM(
        CASE
            WHEN "year" = 2018 THEN "sale"
        END
    ) AS "2018",
    SUM(
        CASE
            WHEN "year" = 2019 THEN "sale"
        END
    ) AS "2019",
    SUM(
        CASE
            WHEN "year" = 2020 THEN "sale"
        END
    ) AS "2020",
    SUM(
        CASE
            WHEN "year" = 2021 THEN "sale"
        END
    ) AS "2021",
    SUM(
        CASE
            WHEN "year" = 2022 THEN "sale"
        END
    ) AS "2022",
    SUM(
        CASE
            WHEN "year" = 2023 THEN "sale"
        END
    ) AS "2023",
    SUM(
        CASE
            WHEN "year" = 2024 THEN "sale"
        END
    ) AS "2024"
FROM
    revenue_by_month
GROUP BY
    "month_name",
    "month_no"
ORDER BY
    "month_no";

---------------------------------------------------------------

--- Which Month generate the Highest sale ---

SELECT
    TO_CHAR(orderdate, 'Mon') AS "month_name",
    EXTRACT(
        MONTH
        FROM
            orderdate
    ) AS "month_no",
    SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "sale"
FROM
    sales
GROUP BY
    "month_no",
    "month_name"
ORDER BY
    "month_no";

---------------------------------------------------------------

--- Who are our the top customers by total sale in each region (RANK) ---
WITH
    customer_revenue AS (
        SELECT
            c.country,
            s.customerkey,
            c.givenname,
            SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "revenue"
        FROM
            sales s
            LEFT JOIN customer c ON (s.customerkey = c.customerkey)
        GROUP BY
            c.country,
            c.givenname,
            s.customerkey
        ORDER BY
            "revenue" DESC
    ),
    customer_rank AS (
        SELECT
            *,
            RANK() OVER (
                PARTITION BY
                    country
                ORDER BY
                    "revenue" DESC
            ) AS "rank"
        FROM
            customer_revenue
    )
SELECT
    *
FROM
    customer_rank
WHERE "rank" = 1;

----------------------------------------------------------------------

--- How are sales cummulating over time ---
WITH
    yearly_revenue AS (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    orderdate
            )::TEXT AS "year",
            SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "revenue"
        FROM
            sales
        GROUP BY
            "year"
        ORDER BY
            "year"
    )
SELECT
    *,
    SUM("revenue") OVER(ORDER BY "year") AS "cumsum"
FROM
    yearly_revenue
ORDER BY
    "year";

--------------------------------------------------------------------------

--- How is average order value changing over time (3 months moving average) ---
WITH
    monthly_revenue AS (
        SELECT
            DATE_TRUNC('month', orderdate)::DATE AS "month",
            SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "revenue"
        FROM
            sales
        GROUP BY
            "month"
        ORDER BY
            "month"
    )
SELECT
    *,
    ROUND(
        AVG("revenue") OVER (
            ORDER BY
                "month" ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
        )::NUMERIC,
        2
    ) AS "3_month_MA"
FROM
    monthly_revenue;

---------------------------------------------------------------------------

--- what is the (avg) time gap between each purchase of a customer ---
WITH
    customer_order_interval AS (
        SELECT
            customerkey,
            orderkey,
            orderdate,
            LAG(orderdate) OVER (
                PARTITION BY
                    customerkey
                ORDER BY
                    orderdate
            ) AS previous_order_date
        FROM
            (
                SELECT DISTINCT
                    customerkey,
                    orderkey,
                    orderdate
                FROM
                    sales
            )
    ),
    avg_time_between_orders AS (
        SELECT
            customerkey,
            AVG((orderdate - previous_order_date)) AS avg_days_between_orders
        FROM
            customer_order_interval
        GROUP BY
            customerkey
        HAVING
            AVG((orderdate - previous_order_date)) > 0
        ORDER BY
            avg_days_between_orders ASC,
            customerkey ASC
    ),
    rank_gaps AS (
        SELECT
            customerkey,
            ROUND(avg_days_between_orders::NUMERIC, 0) AS avg_days_between_orders,
            NTILE(4) OVER (
                ORDER BY
                    avg_days_between_orders
            ) AS group_
        FROM
            avg_time_between_orders
    ),
    group_gaps AS (
        SELECT
            *,
            CASE
                WHEN group_ = 1 THEN 'low gap'
                WHEN group_ = 2 THEN 'medium gap'
                WHEN group_ = 3 THEN 'high gap'
                ELSE 'very high gap'
            END AS gap_between_purchase_group
        FROM
            rank_gaps
    )
SELECT
    gap_between_purchase_group,
    COUNT(gap_between_purchase_group) as "_count"
FROM
    group_gaps
GROUP BY
    gap_between_purchase_group;
    -- can be expanded into churn

------------------------------------------------------------------------------

--- What are the top 5 product in each category (DENSE RANK) ---
WITH
    products_sale AS (
        SELECT
            p.categoryname,
            p.productname,
            SUM(ROUND((s.quantity * s.netprice)::NUMERIC, 2)) AS sale
        FROM
            sales s
            LEFT JOIN product p ON s.productkey = p.productkey
        GROUP BY
            p.categoryname,
            p.productname
        ORDER BY
            sale DESC
    ),
    product_rank AS (
        SELECT
            *,
            DENSE_RANK() OVER (
                PARTITION BY
                    categoryname
                ORDER BY
                    sale DESC
            ) AS rank
        FROM
            products_sale
    )
SELECT
    *
FROM
    product_rank
WHERE
    rank <= 5;

--------------------------------------------------------------------------------

--- segment customer into quartiles based on spending behaviour--
WITH
    customer_rev AS (
        SELECT
            customerkey,
            SUM(ROUND((quantity * netprice)::NUMERIC, 2)) AS "revenue"
        FROM
            sales
        GROUP BY
            customerkey
    ),
    customer_label AS (
        SELECT
            *,
            CASE
                WHEN "quartile" = 1 THEN 'very low spender'
                WHEN "quartile" = 2 THEN 'low spender'
                WHEN "quartile" = 3 THEN 'medium spender'
                WHEN "quartile" = 4 THEN 'high spender'
                ELSE 'very high spender'
            END AS "label"
        FROM
            (
                SELECT
                    *,
                    NTILE(5) OVER (
                        ORDER BY
                            "revenue" ASC
                    ) AS "quartile"
                FROM
                    customer_rev
            )
    )
SELECT
    "label",
    COUNT("label") AS "count"
FROM
    customer_label
GROUP BY
    "label";

--------------------------------------------------------------------------

--- END OF ANALYSIS