
# World Economic Report

Overview
--------
This analysis explores global economic development and inequality by combining World Bank macro indicators with UNDP Human Development Index (HDI) data. The project produces a concise visual report (report.png) and includes the data, transformation steps, and plotting code used to generate the figures.

Repository contents
-------------------
- `main.ipynb` — main analysis notebook that loads the data, performs merging and pivoting, and creates the final multi-panel visualization saved as `report.png`.
- `report.png` — final exported visualization (dashboard) produced by the notebook.
- `Data/WorldBank.xlsx` — World Bank indicators (GDP, GDP per capita, population proxy, electricity consumption, etc.) with Year and Region columns.
- `Data/HDI.csv` — Human Development Index file with country-level HDI series and related indicators.
- `Data/world_indicators_data_dictionary.csv` — column/field descriptions for the data files.

What the analysis does (notebook steps)
--------------------------------------
1. Data loading and cleaning
	- Reads `Data/WorldBank.xlsx` and `Data/HDI.csv` into pandas.
	- Computes a population proxy `Population (M)` from `GDP (USD)` / `GDP per capita (USD)`.
	- Merges 2014 World Bank rows with the HDI 2014 column to create a combined dataset for cross-sectional analysis.

2. Reshaping and aggregation
	- Creates year-by-region pivot tables for total `GDP (USD)` and `Population (M)`.
	- Aggregates average HDI by World Bank `Region` for 2014.

3. Visualizations
	- Builds a 3x2 multi-panel figure with matplotlib and `gridspec`:
	  - Stacked area charts showing world GDP and population by region (1960–2018).
	  - Scatterplot of life expectancy vs GDP per capita, sized by population and colored by region, using a log scale for GDP per capita.
	  - Bar chart with average HDI by region.
	  - Scatterplot showing electricity consumption vs GDP per capita colored by HDI score.
	- Custom styling: `ggplot` base style, axis/spine adjustments, custom legends, and formatted axes.
	- Adds summary annotations and saves the final image as `report.png`.

