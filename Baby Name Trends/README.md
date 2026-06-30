
# Baby Name Trends

Project overview
-----------------
This project explores historical and spatial trends in baby names using the included CSV dataset and a set of SQL analysis scripts. The filder contains raw data, a database creation script, a data dictionary, and several SQL queries that generate comparisons, historical popularity trends, and spatial analyses.

Repository structure
---------------------
- Data/
	- `baby_names_db_data_dictionary.csv` — data dictionary describing the dataset columns and types
	- `create_baby_names_db.sql` — SQL script to create the database schema and tables
	- `names_data.csv` — core dataset with baby name records (year, name, sex, counts, etc.)
- Scripts/
	- `names_comparison.sql` — queries for comparing name popularity across groups or years
	- `popularity_historical_trends.sql` — queries to analyze name popularity over time
	- `popularity_spatial_trends.sql` — queries that join names with geographic dimensions for spatial analysis
	- `views.sql` — convenience view definitions used by the analysis scripts

Files and purpose
------------------
- Data/baby_names_db_data_dictionary.csv: Use this to understand each column in `names_data.csv` and the intended table layout.
- Data/create_baby_names_db.sql: Run this first to create tables and constraints in your SQL database.
- Data/names_data.csv: Import this CSV into the main names table.
- Scripts/*.sql: These scripts expect the schema and table names created by `create_baby_names_db.sql`. 

