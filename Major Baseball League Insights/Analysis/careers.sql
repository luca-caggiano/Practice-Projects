
-- Players careers started and ended on the same team and also played for over a decade
SELECT 
    COUNT(*) nplayers
FROM V_players_careers pc
INNER JOIN V_player_teams pt ON pc.playerid = pt.playerid
WHERE first_teams = last_teams AND career_length_years >= 10;

--- Players ordered by longest careers (preview)
SELECT * FROM V_players_careers 
WHERE career_length_years IS NOT NULL
ORDER BY career_length_years DESC;


-- starting and final teams (preview)
SELECT * FROM v_player_teams;
