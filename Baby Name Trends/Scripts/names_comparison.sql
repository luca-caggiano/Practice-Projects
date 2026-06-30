------------------------------------------------------------------------------------------------------------------
-- 10 MOST POPULAR ANDROGYNOUS NAMES
------------------------------------------------------------------------------------------------------------------
/*
some names like Jordan or Jessica were assigned to both male and female babies. I decided that a name is androgynous 
if it is assigned to at least 30% of females and 30% of males.
*/

WITH gender_split AS(SELECT 
    name,
    SUM(births) AS total_births,
    SUM(CASE WHEN gender='F' THEN births ELSE 0 END) AS female_births,
    SUM(CASE WHEN gender='M' THEN births ELSE 0 END) AS male_births
FROM names
GROUP BY name)

SELECT
    name,
    total_births
FROM gender_split
WHERE (female_births > 1 AND male_births > 1) 
       AND (female_births >= total_births*0.3 AND male_births >= total_births*0.3)
ORDER BY total_births DESC
LIMIT 10;
------------------------------------------------------------------------------------------------------------------
--SHORTEST AND LONGEST NAMES AND  MOST POPULAR SHORT NAMES AND LONG NAMES 
------------------------------------------------------------------------------------------------------------------

WITH name_lengths AS(SELECT 
    name,
    SUM(births) total_births,
    LENGTH(name) name_length,
    DENSE_RANK() OVER(ORDER BY LENGTH(name) DESC) longest,
    DENSE_RANK() OVER(ORDER BY LENGTH(name)) shortest
FROM names
GROUP BY name)

SELECT
    name, name_length, total_births
FROM name_lengths
WHERE longest=1 OR shortest = 1
ORDER BY name_length, total_births DESC;

------------------------------------------------------------------------------------------------------------------
--The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris"
------------------------------------------------------------------------------------------------------------------
SELECT
    state,
    SUM(CASE WHEN name = 'Chris' THEN births ELSE 0 END)*100.0/SUM(births) AS chris_percent
FROM names
GROUP BY state
ORDER BY chris_percent 