-- Find Tolal players 
select count(*) from NPLPlayers;


-- Total players, teams, overseas vs domestic

SELECT Type, COUNT(*) AS count FROM NPLPlayers GROUP BY Type;
SELECT COUNT(DISTINCT Team) AS total_teams from NPLPlayers;
SELECT SUM(Price_in_lakh) AS league_total_spend_lakh FROM NPLPlayers;

-- Which team spent the most (including rumored overseas prices)?
SELECT Team, ROUND(SUM(Price_in_lakh), 2) AS total_spend_lakh
FROM nplplayers GROUP BY Team ORDER BY total_spend_lakh DESC;

-- Average spend per player by team
SELECT Team, ROUND(AVG(Price_in_lakh), 2) AS avg_per_player
FROM NPLPlayers GROUP BY Team ORDER BY avg_per_player DESC;


--Most Expensive Players (Top 20)

SELECT Player, Team, Price_in_lakh, Type, Role
FROM NPLPlayers
ORDER BY Price_in_lakh DESC
LIMIT 20;

--Cheapest & Free (0 Lakh) Players

SELECT Player, Team, Acquisition, Role
FROM NPLPlayers WHERE Price_in_lakh = 0
ORDER BY Team, Role;

-- Overseas vs Domestic Spending Comparison
SELECT Type,
       COUNT(*) AS players,
       ROUND(SUM(Price_in_lakh), 2) AS total_spend,
       ROUND(AVG(Price_in_lakh), 2) AS avg_price
FROM NPLPlayers
GROUP BY Type;

-- Role-wise Salary Analysis (Who gets paid the most?)

SELECT Role,
       COUNT(*) AS players,
       ROUND(AVG(Price_in_lakh), 2) AS avg_salary,
       ROUND(MAX(Price_in_lakh), 2) AS highest_salary,
       ROUND(MIN(Price_in_lakh), 2) AS lowest_salary
FROM NPLPlayers
GROUP BY Role
ORDER BY avg_salary DESC;

-- Rank the players based on Salary 
SELECT 
    Player,
    Team,
    Price_in_lakh,
    CASE 
        WHEN Price_in_lakh > 20 THEN 'Premium (High)'
        WHEN Price_in_lakh >= 10 THEN 'Mid-Tier (Medium)'
        ELSE 'Budget (Low)'
    END AS salary_tier
FROM NPLPlayers
ORDER BY Price_in_lakh DESC, Player;


-- Running Total of League Spending (Cumulative)
SELECT 
    Player, Team, Price_in_lakh,
    SUM(Price_in_lakh) OVER (ORDER BY Price_in_lakh DESC ROWS UNBOUNDED PRECEDING) AS running_total_league
FROM NPLPlayers
ORDER BY Price_in_lakh DESC;

-- Top 3 Highest-Paid Players in Each Team
SELECT * FROM (
    SELECT 
        Player, Team, Price_in_lakh, Role,
        ROW_NUMBER() OVER (PARTITION BY Team ORDER BY Price_in_lakh DESC) AS rn
    FROM NPLPlayers
) x WHERE rn <= 3
ORDER BY Team, rn;


--Role-wise Salary Ladder in Each Team
SELECT 
    Team, Role, Player, Price_in_lakh,
    RANK() OVER (PARTITION BY Team, Role ORDER BY Price_in_lakh DESC) AS role_rank_in_team
FROM NPLPlayers
ORDER BY Team, Role, role_rank_in_team;


-- Percentage of their team’s total salary budget each player takes up
SELECT 
    Player,
    Team,
    Price_in_lakh,
    ROUND(Price_in_lakh * 100.0 / SUM(Price_in_lakh) OVER (PARTITION BY Team), 2) AS salary_contribution_percent
FROM NPLPlayers
ORDER BY Team, salary_contribution_percent DESC;

--  Role contribution % for the whole league
SELECT 
    Role,
    COUNT(*) AS players,
    ROUND(SUM(Price_in_lakh),2) AS total_salary_lakh,
    ROUND(SUM(Price_in_lakh) * 100.0 / SUM(SUM(Price_in_lakh)) OVER (), 2) AS league_contribution_pct
FROM NPLPlayers
GROUP BY Role
ORDER BY total_salary_lakh DESC;

--  Role contribution % inside each team
SELECT 
    Team,
    Role,
    ROUND(SUM(Price_in_lakh),2) AS role_salary,
    ROUND(SUM(Price_in_lakh) * 100.0 / SUM(SUM(Price_in_lakh)) OVER (PARTITION BY Team), 2) AS role_contribution_pct
FROM NPLPlayers
GROUP BY Team, Role
ORDER BY Team, role_contribution_pct DESC;

-- Players who take >15% of their team’s salary, grouped by role

SELECT *
FROM (
    SELECT 
        Player, 
        Team, 
        Role, 
        Price_in_lakh,
        ROUND(Price_in_lakh * 100.0 / SUM(Price_in_lakh) OVER (PARTITION BY Team), 2) AS contrib_pct
    FROM NPLPlayers
) AS sub
WHERE contrib_pct > 15
ORDER BY contrib_pct DESC;


