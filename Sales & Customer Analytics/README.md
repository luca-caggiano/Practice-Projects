
# Sales & Customer Analytics

Overview
--------
This project contains a small sales data warehouse (star schema CSVs), data-preparation utilities, SQL exploration & analysis scripts, and visualization notebooks to derive customer- and product-level insights.

Repository layout
-----------------
- `dataset/` — source CSV files used to populate the warehouse:
	- `dim_customers.csv` — customer dimension with demographic and contact fields
	- `dim_products.csv` — product dimension with category, cost and product metadata
	- `fact_sales.csv` — sales fact table with orders, quantities, prices and dates
- `preparation/` — utilities for importing and preparing the dataset
	- `.env.example` — example environment variables for DB connection
	- `file_preparation.ipynb` — notebook documenting any CSV shaping or cleaning steps
	- `import.py` — simple script that reads CSVs from `dataset/` and writes them to a Postgres database using `pandas.to_sql`
- `sql scripts/` — analysis queries and views
	- `tables.sql` — DDL to create the three tables: `dim_customers`, `dim_products`, `fact_sales`
	- `eda.sql` — exploratory queries (schema introspection, cardinality, distribution, ranking, and quick KPIs)
	- `analysis.sql` — time series, cumulative/running totals, performance vs prior year, part-to-whole, segmentation and customer labelling
	- `customer_report.sql` — view `V_customer_report` that aggregates per-customer KPIs: lifespan, recency, avg order value, avg monthly spend, segments and age groups
	- `products_report.sql` — view `v_product_report` that aggregates per-product KPIs: total sales, quantity, customers, lifespan, performance buckets and monthly averages
- `charts/` — visualization notebooks (e.g., `charts.ipynb`) to present results

What each script does (details)
--------------------------------
- `preparation/import.py`:
	- Loads environment variables from `.env`.
	- Iterates CSV files in `dataset/` and writes them to a PostgreSQL database using SQLAlchemy and `pandas.to_sql` (appends if table exists).

- `sql scripts/tables.sql`:
	- Defines the simple star schema DDL for `dim_customers`, `dim_products`, and `fact_sales` used by the rest of the project.

- `sql scripts/eda.sql`:
	- Introspects schema and data types via `information_schema`.
	- Samples rows from each table and inspects cardinality via `pg_stats`.
	- Computes basic KPIs (total sales, total items, average price, totals and counts).
	- Explores distributions by country, gender and product category, plus revenue by category and customer.
	- Produces ranking queries for top/bottom products and customers.

- `sql scripts/analysis.sql`:
	- Time-series summaries: yearly and monthly totals for sales, customers and quantity.
	- Running cumulative totals per month.
	- Performance analysis per product vs yearly averages and prior-year sales using window functions.
	- Part-to-whole contribution of categories to total sales.
	- Segmentation of products by cost buckets and customers into `VIP` / `Regular` / `New` based on lifespan and spend.

- `sql scripts/customer_report.sql`:
	- Builds `V_customer_report` view combining `dim_customers` and `fact_sales`.
	- Aggregates customer-level metrics: age, lifespan (months), total orders, total sales, quantity, distinct products.
	- Computes KPIs: recency, average order value, average monthly spend and assigns age groups and customer categories.

- `sql scripts/products_report.sql`:
	- Builds `v_product_report` view aggregating product metrics joined with `fact_sales`.
	- Calculates total orders, sales, quantity, distinct customers, lifespan and recency.
	- Classifies products into performance buckets (High / Mid / Low) and computes average order and monthly revenue.

