------------------------------------------------------------------------------------------------------------------
-- NUMBER OF BABIES BORN IN EACH REGION
------------------------------------------------------------------------------------------------------------------
SELECT 
    r.region,
    SUM(births) total_births
FROM names n
LEFT JOIN regions r ON n.state = r.state 
GROUP BY r.region;

------------------------------------------------------------------------------------------------------------------
-- 3 MOST POPULAR GIRL NAMES AND 3 MOST POPULAR BOY NAMES WITHIN EACH REGION
------------------------------------------------------------------------------------------------------------------


WITH ranked_regions AS(SELECT 
    r.region, n.gender, n.name,
    SUM(n.births) AS total_births,
    DENSE_RANK() OVER(PARTITION BY r.region, n.gender ORDER BY SUM(n.births) DESC) rnk 
FROM names n
LEFT JOIN regions r ON n.state = r.state 
GROUP BY r.region, n.gender, n.name)

SELECT
    region, name, gender, total_births
FROM ranked_regions
WHERE rnk<=3
ORDER BY region, total_births DESC;

