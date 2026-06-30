--------------------------------------------------------------------------------------------------
--PLAYERS WITH THE SAME BIRTHDAY
--------------------------------------------------------------------------------------------------
-- Self-join approach
SELECT 
    p1.playerid, p1.namegiven,  p1.birth_date,
    p2.playerid, p2.namegiven
FROM v_players_careers p1
INNER JOIN  v_players_careers p2 ON p1.birth_date = p2.birth_date AND p1.playerid < p2.playerid -- < sign prevents symmetrical duplicates
ORDER BY p1.namegiven;

-- Cleaner table with string agg
SELECT
    birth_date,
    STRING_AGG(namegiven, ', ') plaplayers_with_same_birthdayyers,
    COUNT(playerid) number_of_players
FROM v_players_careers
GROUP BY birth_date
HAVING COUNT(playerid) > 1
ORDER BY birth_date;

--------------------------------------------------------------------------------------------------------------------
--  BAT TYPE PERCENT BY TEAM
--------------------------------------------------------------------------------------------------------------------
WITH unique_players_per_team AS (
    SELECT DISTINCT s.teamid, s.playerid, p.bats
    FROM salaries s 
    LEFT JOIN players p ON s.playerid = p.playerid
)
SELECT 
    teamid,
    ROUND(AVG(CASE WHEN bats='R' THEN 1 ELSE 0 END)*100, 2) AS bat_right_percent,
    ROUND(AVG(CASE WHEN bats='L' THEN 1 ELSE 0 END)*100, 2) AS bat_left_percent,
    ROUND(AVG(CASE WHEN bats='B' THEN 1 ELSE 0 END)*100, 2) AS bat_both_percent
FROM unique_players_per_team
GROUP BY teamid;

--------------------------------------------------------------------------------------------------------------------
-- AVERAGE DEBUT HEIGHT AND WEIGHT OVER DECADES
--------------------------------------------------------------------------------------------------------------------

WITH decades AS (SELECT 
    FLOOR(EXTRACT(YEAR from debut)/10)*10 debut_decade,
    weight,
    height
FROM players)

SELECT 
    debut_decade,
    ROUND(AVG(height),2) avg_weight,
    ROUND (AVG(height) - LAG(AVG(weight)) OVER(ORDER BY debut_decade),2) weight_diff_previous_decade,
    ROUND(AVG(weight),2) avg_height,
   ROUND(AVG(weight) - LAG(AVG(weight)) OVER(ORDER BY debut_decade),2) height_diff_previous_decade
FROM decades
WHERE debut_decade IS NOT NULL
GROUP BY debut_decade;

-- weight and height columns were inverted, this is why I computed avg weight on height and avg height on weight variables