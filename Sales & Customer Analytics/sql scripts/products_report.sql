/*Product Report
Purpose:
    - This report consolidates key product metrics and behaviors.
Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers (>50000), Mid-Range(10000-50000), or Low-Performers (<10000).
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue
*/

CREATE OR REPLACE VIEW public.v_product_report AS

WITH base_query AS(SELECT
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost,
    s.sales_amount,
    s.order_number, 
    s.customer_key,
    s.order_date,
    s.quantity
FROM dim_products p
LEFT JOIN fact_sales s ON p.product_key = s.product_key)


SELECT
    -- product info
    product_key, product_name, category, subcategory,
    -- basic aggregations
    COUNT(order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS total_customers,
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,
    MAX(order_date) AS last_order,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, MAX(order_date))) recency,
    -- categories
    CASE 
        WHEN SUM(sales_amount) > 50000 THEN 'High Performer'
        WHEN SUM(sales_amount) >= 10000 THEN 'Mid Range'
        ELSE 'Low Performer'
    END AS performance,
    -- KPI
    COALESCE(SUM(sales_amount) / NULLIF(COUNT(order_number),0), SUM(sales_amount)) AS avg_order_revenue,
    COALESCE(SUM(sales_amount) / NULLIF(COUNT(DISTINCT TO_CHAR(order_date, 'YYYY-MM')), 0), SUM(sales_amount)) AS avg_monthly_revenue
FROM base_query 
GROUP BY product_key, product_name, category, subcategory


