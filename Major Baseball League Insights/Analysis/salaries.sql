--------------------------------------------------------------------------------------------------
--TOP 20 PERCENT OF TEAMS IN TERMS OF AVERAGE ANNUAL SPENDING
--------------------------------------------------------------------------------------------------
WITH spending_per_year AS(
    SELECT
        teamid, 
        yearid, 
        SUM(salary) tot_spending
    FROM salaries
    GROUP BY teamid, yearid)

SELECT teamid, ROUND(avg_annual_spending,2) avg_annual_spending
FROM(SELECT
        teamid, 
        AVG(tot_spending) avg_annual_spending,
        NTILE(5) OVER(ORDER BY AVG(tot_spending) DESC) rnk
    FROM spending_per_year
    GROUP BY teamid)t
WHERE rnk=1
ORDER BY avg_annual_spending DESC;

--------------------------------------------------------------------------------------------------
-- CUMULATIVE TEAMS SPENDING OVER YEARS
--------------------------------------------------------------------------------------------------
WITH spending_per_year AS(
    SELECT
        teamid, 
        yearid, 
        SUM(salary) tot_spending
    FROM salaries
    GROUP BY teamid, yearid)

SELECT
    teamid, yearid,
    SUM(tot_spending) OVER(PARTITION BY teamid ORDER BY yearid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumsum
FROM spending_per_year;

--------------------------------------------------------------------------------------------------
-- FIRST YEAR EACH TEAM'S CUMULATIVE SPENDING SURPASSED 1 BILLION
--------------------------------------------------------------------------------------------------


WITH spending_per_year AS(
    SELECT
        teamid, 
        yearid, 
        SUM(salary) tot_spending
    FROM salaries
    GROUP BY teamid, yearid)

, cum_spending AS(SELECT
    teamid, yearid,
    SUM(tot_spending) OVER(PARTITION BY teamid ORDER BY yearid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumsum
FROM spending_per_year)

SELECT
    teamid,
    MIN(yearid) billion_surpassed
FROM cum_spending
WHERE cumsum > 1000000000
GROUP BY teamid;
