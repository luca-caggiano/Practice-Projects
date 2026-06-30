/*
Customer Report
============s
Purpose:
- This report consolidates key customer metrics and behaviors
Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value (total sales / nr orders)
        - average monthly spend (total sales / nr months)
ニニニニニニニニニニニ
*/

/* SELECT
    table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN('dim_customers', 'fact_sales')
ORDER BY table_name */


CREATE OR REPLACE VIEW public.V_customer_report AS

WITH base_query AS(SELECT 
    c.customer_key,
    c.customer_number,
    c.first_name, c.last_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.birthdate)) age,
    f.order_number,
    f.sales_amount,
    f.quantity,
    f.product_key,
    f.order_date
FROM dim_customers c
INNER JOIN fact_sales f ON c.customer_key = f.customer_key)



, metrics AS(SELECT
    customer_key, first_name, last_name, customer_number,
    age, 
    MAX(order_date) AS last_order,
    (MAX(order_date) - MIN(order_date)) / 30 AS lifespan,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products
FROM base_query
GROUP BY customer_key, age, first_name, last_name, customer_number)


, customers_aggregation AS(SELECT
    customer_key,
    CASE 
        WHEN age < 18 THEN 'Below 18'
        WHEN age <= 35 THEN '18-35'
        WHEN age <= 50 THEN '36-50'
        ELSE 'Above 50'
    END AS age_group,
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS category,
    total_sales / NULLIF(total_orders,0) AS avg_order_value,
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan 
        END AS avg_monthly_spend,
    (CURRENT_DATE - last_order)/30 AS recency 
FROM metrics)



 SELECT
    m.customer_key, m.customer_number, 
    CONCAT(m.first_name, ' ', m.last_name) AS customer_name,
    cc.age_group, cc.category,
    m.age, m.last_order, m.lifespan, cc.recency,
     m.total_orders, m.total_sales, 
    m.total_quantity, m.total_products,
    cc.avg_monthly_spend, cc.avg_order_value
 FROM metrics m
 INNER JOIN customers_aggregation cc ON m.customer_key = cc.customer_key



 