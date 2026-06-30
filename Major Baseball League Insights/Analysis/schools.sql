-------------------------------------------------------------------------------------------------------------------------------------
--NUMBER OF SCHOOLS THAT PRODUCED PLAYERS IN EACH DECADE. 
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    yearid/10 * 10 AS decade,
    COUNT(DISTINCT schoolid) n_schools_players_decades
FROM schools
GROUP BY decade
ORDER by decade;

--Schools is a player-level table that indicates the school they attended.

-------------------------------------------------------------------------------------------------------------------------------------
-- TOP 5 SCHOOLS PER PLAYERS ACROSS ALL DECADES
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    sd.name_full,
    COUNT(DISTINCT sc.playerid) n_players
FROM school_details sd
LEFT JOIN schools sc ON sd.schoolid = sc.schoolid
GROUP BY sd.schoolid, sd.name_full
ORDER BY n_players DESC
LIMIT 5;

-------------------------------------------------------------------------------------------------------------------------------------
-- TOP 3 SCHOOLS PER DECADE 
-------------------------------------------------------------------------------------------------------------------------------------
WITH npl_schools_decades AS(
    SELECT  
        sc.yearid/10*10 AS decade,
        name_full AS school_name,
        COUNT(DISTINCT sc.playerid) AS n_players
    FROM schools sc
    INNER JOIN school_details sd ON sd.schoolid = sc.schoolid
    GROUP BY decade, name_full)

SELECT
     decade, school_name, n_players
FROM(
    SELECT
        decade, school_name, n_players,
        ROW_NUMBER() OVER(PARTITION BY decade ORDER BY n_players DESC) AS rnk 
    FROM npl_schools_decades)t
WHERE rnk <= 3;

/*
The choice of row number instead of dense rank, consists of the high presence of ties, that usually consists on multiple n_players=1
Although dense rank would produce more accurate results, by including two or more schools that produced the same number of players, the 
resulting table would have not been useful to gain insights, since it would presents lots of schools for each decade that produced only 1 player.
*/
