------------------------------------------------------------------------------------------------------------------
-- TRACK CHANGES IN NAME POPULARITY
------------------------------------------------------------------------------------------------------------------
-- OVERALL MOST POPULAR NAMES
WITH overall_popularity AS(SELECT 
    name,
    SUM(births)  tot_occurrences,
    DENSE_RANK() OVER(PARTITION BY gender ORDER BY SUM(births) DESC) rnk
FROM names
GROUP BY name, gender)

-- MOST POPULAR NAMES OVER TIME
SELECT 
    name, year, births, popularity_score
FROM V_popularity_over_years p1
WHERE EXISTS(SELECT name FROM overall_popularity p2 WHERE p2.name = p1.name AND p2.rnk=1)
ORDER BY year, name;

-- NAMES WITH BIGGEST JUMP IN POPULARITY
WITH ranked_years AS(SELECT 
    name, year, births, popularity_score,
    ROW_NUMBER() OVER(PARTITION BY name ORDER BY year ASC) first_year,
    ROW_NUMBER() OVER(PARTITION BY name ORDER BY year DESC) last_year
FROM V_popularity_over_years)

SELECT 
    start_data.name,
    start_data.year AS first_year,
    end_data.year AS last_year,
    start_data.births initial_birth_count,
    end_data.births AS final_births_count,
    end_data.births - start_data.births AS jump,
    CONCAT((end_data.births - start_data.births)*100/NULLIF(start_data.births,0),'%') AS percentage_change
FROM ranked_years AS start_data
INNER JOIN ranked_years AS end_data ON start_data.name = end_data.name 
WHERE start_data.first_year = 1 AND end_data.last_year = 1
ORDER BY jump DESC
LIMIT 20;


------------------------------------------------------------------------------------------------------------------
-- POPULARITY ACROSS YEAR
------------------------------------------------------------------------------------------------------------------
-- Top 3 most popular girl and boy names by year
SELECT
    year, name, gender, births
FROM(SELECT 
        year, name, gender ,
        SUM(births) AS births,
        DENSE_RANK() OVER(PARTITION BY year, gender ORDER BY SUM(births) DESC) rnk
    FROM names
    GROUP BY name, year, gender)t
WHERE rnk <= 3
ORDER BY 1

-- Top 3 most popular girl and boy names by decade

WITH decades_ranked AS(SELECT
    decade,
    name,
    gender,
    SUM(births) births,
    DENSE_RANK() OVER(PARTITION BY decade, gender ORDER BY SUM(births) DESC) rnk
FROM(SELECT 
        FLOOR(year/10)*10 decade,
        name, gender, births
    FROM names)t
GROUP BY name, decade, gender)

SELECT
    decade,
    name,
    gender,
    births
FROM decades_ranked
WHERE rnk<=3
ORDER BY decade, gender, births DESC