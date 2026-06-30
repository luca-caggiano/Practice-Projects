
-- These views were originally CTEs. However, as I had to access them in multiple queries, I turned them into views. 
--SELECT COUNT(*), COUNT(DISTINCT playerid), COUNT(DISTINCT teamid), COUNT(DISTINCT yearid) FROM salaries;
--there are 37 unique teams and 30 unique, this means that some players belonged to more than one teams in certain years. 
--I took this fact into account using string agg to get all the teams a player was part of in a given year.

-- some players presented data about their matches but none about their debut and finalgame. 

CREATE OR REPLACE VIEW V_players_careers AS(
    SELECT 
        playerid,
        MAKE_DATE(birthyear, birthmonth, birthday) birth_date,
        MAKE_DATE(deathyear, deathmonth, deathday) death_day,
        EXTRACT(YEAR FROM AGE(debut, MAKE_DATE(birthyear, birthmonth, birthday))) age_first_game,
        EXTRACT(YEAR FROM AGE(finalgame, MAKE_DATE(birthyear, birthmonth, birthday))) age_final_age,
        EXTRACT(YEAR FROM AGE(finalgame, debut)) career_length_years,
        EXTRACT(YEAR FROM debut) AS debut_year,
        EXTRACT(YEAR FROM finalgame) AS finalgame_year,
        namegiven
    FROM players);

CREATE OR REPLACE VIEW V_player_teams AS (SELECT
    pc.playerid,
    STRING_AGG(DISTINCT ft.teamid, ', ') AS first_teams,
    STRING_AGG(DISTINCT lt.teamid, ', ') AS last_teams
FROM V_players_careers pc
INNER JOIN salaries ft
    ON pc.playerid = ft.playerid
    AND pc.debut_year = ft.yearid
INNER JOIN salaries lt
    ON pc.playerid = lt.playerid
    AND pc.finalgame_year = lt.yearid
GROUP BY pc.playerid);


