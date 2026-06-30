-- CHANGE OVER TIME
-- Sales performance over time

SELECT
    EXTRACT(YEAR FROM order_date) "Year",
    SUM(sales_amount) "Total Sales",
    COUNT(DISTINCT customer_key) "Total Customers",
    SUM(quantity) "Total Quantity"
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


SELECT 
    to_char(Sales_Month, 'YYYY-Mon') Sales_Month,
    Total_Sales,
    Total_Customers,
    Total_Quantity
FROM(
    SELECT
        DATE_TRUNC('month', order_date) Sales_Month,
        SUM(sales_amount) Total_Sales,
        COUNT(DISTINCT customer_key) Total_Customers,
        SUM(quantity) Total_Quantity
    FROM fact_sales
    GROUP BY DATE_TRUNC('month', order_date)
    ORDER BY DATE_TRUNC('month', order_date)
)t;

-- CUMULATIVE ANALYSIS
-- Total sales for each month and running total of sales over time

WITH cte AS(SELECT
    DATE_TRUNC('month', fact_sales.order_date) Sales_Month,
    SUM(fact_sales.sales_amount) Total_Sales
FROM fact_sales
WHERE fact_sales.order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', fact_sales.order_date)
ORDER BY DATE_TRUNC('month', fact_sales.order_date))


SELECT 
    TO_CHAR(Sales_Month, 'YYYY-Mon'),
    Total_Sales,
    SUM(Total_Sales) OVER(ORDER BY Sales_Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) Running_Total
FROM cte;

-- PERFORMANCE ANALYSIS
WITH cte AS(SELECT
    EXTRACT(YEAR FROM f.order_date) order_year,
    p.product_name,
    SUM(f.sales_amount) total_sales,
    ROUND(AVG(f.sales_amount),2) avg_sales,
    LAG(SUM(f.sales_amount) , 1) OVER(PARTITION BY p.product_name ORDER BY EXTRACT(YEAR FROM f.order_date)) py_sales
FROM dim_products p
INNER JOIN fact_sales f ON p.product_key = f.product_key
GROUP BY p.product_name, EXTRACT(YEAR FROM f.order_date))

SELECT
    order_year,
    product_name,
    total_sales,
    avg_sales,
    py_sales,
    total_sales - avg_sales AS diff_avg,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        WHEN total_sales = avg_sales THEN 'Equal to Average' 
        ELSE NULL
    END AS avg_change,
    total_sales - py_sales  AS diff_py,
    CASE 
        WHEN total_sales > py_sales THEN 'Increase'
        WHEN total_sales < py_sales THEN 'Decrease'
        WHEN total_sales = py_sales THEN 'No change'
    END AS py_change
FROM cte
ORDER BY product_name, order_year;

-- PART TO WHOLE ANALYSIS

WITH cte AS(SELECT
    p.category,
    SUM(f.sales_amount) product_sales
FROM fact_sales f
INNER JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category)


SELECT
    category,
    CONCAT(ROUND((product_sales::numeric(10,2) / (SELECT SUM(sales_amount) FROM fact_sales)) * 100 ,2 ), '%') AS contribution_to_total
FROM cte
ORDER BY contribution_to_total DESC

-- DATA SEGMENTATION
WITH cost_categories AS(SELECT  
    dim_products.product_key,
    CASE 
        WHEN cost <= 100 THEN 'Below 100'
        WHEN cost <= 500 THEN '100-500'
        WHEN cost <= 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS cost_range
FROM dim_products)

SELECT
    cost_range,
    COUNT(product_key)
FROM cost_categories
GROUP BY cost_range
ORDER BY CASE cost_range
            WHEN 'Below 100' THEN 1
            WHEN '100-500' THEN 2
            WHEN '500-1000' THEN 3
            WHEN 'ABOVE 1000' THEN 4
        END

/* Group customers into three segments based on their spending behavior:
- VIP: at least 12 months of history and spending more than €5,000.
- Regular: at least 12 months of history but spending €5,000 or less.
- New: lifespan less than 12 months. */
WITH labeled_customers AS(SELECT
    customer_id,
    CASE 
        WHEN ((MAX(f.order_date) - MIN(f.order_date)) /12) >= 12 AND SUM(f.sales_amount) > 5000 THEN 'VIP'
        WHEN ((MAX(f.order_date) - MIN(f.order_date)) /12) >= 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
        ELSE'New'
    END AS category
FROM dim_customers c
INNER JOIN fact_sales f ON c.customer_key = f.customer_key
GROUP BY c.customer_id)


SELECT
    category,
    COUNT(customer_id) customer_count
FROM labeled_customers
GROUP BY category
ORDER BY CASE category
            WHEN 'VIP' THEN 1
            WHEN 'Regular' THEN 2
            WHEN 'New' THEN 3
        END;


