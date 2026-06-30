-- Most popular names ranking over time (some names were repeaeted multiple times for the same year, therefore I grouped by name and year and sum the births)
CREATE OR REPLACE VIEW V_popularity_over_years AS(SELECT
 name, 
 year,
 SUM(births) AS births,
 DENSE_RANK() OVER(PARTITION BY year ORDER BY SUM(births) DESC) popularity_score
FROM names
GROUP BY name, year)




