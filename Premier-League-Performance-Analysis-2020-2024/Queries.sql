-- 1) Which teams had the highest average expected goals (xG) across all seasons, and how
--    does that compare to their actual goals scored? 

SELECT team,
       CAST(AVG(xg) AS decimal(4,2)) AS Average_xg_per_game,
	   CAST(AVG(gf*1.0) AS decimal(4,2)) AS Average_Goals_per_game,
       CAST(AVG(gf*1.0) - AVG(xg) AS decimal(4,2)) AS xg_performance
FROM PL20_24
GROUP BY team
ORDER BY Average_xg_per_game DESC

-- 2) What is the correlation between possession percentage and the number of goals scored?
--    Do teams with higher possession tend to score more?

SELECT team, AVG(poss*1.0) AS Average_Possession, 
       CAST(ROUND(AVG(gf * 1.0), 2) AS DECIMAL(10,2)) AS Average_Goals_per_game,
	   DENSE_RANK() OVER(ORDER BY AVG(poss*1.0) DESC) AS Possession_Ranking
FROM PL20_24
GROUP BY team
ORDER BY Average_Goals_per_game DESC

-- 3) Which teams consistently overperform their xG (i.e., score more goals than expected)
--    across different seasons? 

SELECT team,
       Total_Goals_Scored, 
       Total_xg_generated, 
       Total_Goals_Scored - Total_xg_generated AS xg_Performance
FROM (
    SELECT DISTINCT team, 
           SUM(gf) OVER (PARTITION BY team) AS Total_Goals_Scored, 
           CAST(SUM(xg) OVER (PARTITION BY team) AS DECIMAL(10,2)) AS Total_xg_generated
    FROM PL20_24
) AS goals_and_xg
ORDER BY xg_Performance desc

-- 4)  Which team has the best defensive record (lowest xGA) over all the seasons? 
--     Does this team also concede the fewest actual goals?

SELECT team, Total_xga_conceded, Total_Goals_Conceded, 
       RANK() OVER (ORDER BY Total_Goals_Conceded) Goals_Conceded_Rank
FROM (SELECT DISTINCT team, 
       SUM(ga) OVER (PARTITION BY team) AS Total_Goals_Conceded, 
       CAST(SUM(xga) OVER (PARTITION BY team) AS DECIMAL(10,2)) AS Total_xga_conceded
FROM PL20_24
WHERE team IN (
    SELECT team FROM PL20_24
    GROUP BY team
    HAVING COUNT(DISTINCT season) = 5
)) AS xga_and_ga
ORDER BY Total_xga_conceded;

-- 5) What is the average possession, shots, and shots on target for home vs. away matches?

SELECT venue, AVG(poss) as Avg_Possession,
       CAST(AVG(shots*1.0) AS decimal(10,2)) AS Avg_Shots_Attempted,
	   CAST(AVG(shots_on_target*1.0) AS decimal(10,2)) AS Avg_Shots_on_Target
FROM PL20_24
GROUP BY venue 

-- 6) Which opponent teams were the most difficult to score against, based on 
--    average xG allowed and actual goals conceded?

SELECT opponent,
       Total_Goals_Conceded, 
       Total_xga, 
       Total_Goals_Conceded - Total_xga AS xga_Performance
FROM (
    SELECT DISTINCT opponent, 
           SUM(gf) OVER (PARTITION BY opponent) AS Total_Goals_Conceded, 
           CAST(SUM(xg) OVER (PARTITION BY opponent) AS DECIMAL(10,2)) AS Total_xga
    FROM PL20_24 
	WHERE opponent IN (
		SELECT opponent FROM PL20_24
		GROUP BY opponent
		HAVING COUNT(DISTINCT season) >= 4
)
) AS goals_and_xg
ORDER BY xga_Performance

-- 7) How does attendance affect team performance in home matches in terms of goals scored,
--    xG, and possession?

SELECT Team, 
    AVG(attendance) AS avg_attendance, 
    CAST(AVG(gf*1.0) AS decimal(10,2)) AS avg_home_goals, 
	RANK() OVER (ORDER BY AVG(gf*1.0) DESC) AS goals_ranking,
    CAST(AVG(xg) AS decimal(10,2)) AS avg_home_xG,
	RANK() OVER (ORDER BY AVG(xg) DESC) AS xg_ranking,
    CAST(AVG(poss*1.0) AS decimal(10,1)) AS avg_home_possession,
	RANK() OVER (ORDER BY AVG(poss*1.0) DESC) AS possession_ranking
FROM PL20_24
WHERE venue = 'Home'
GROUP BY team
ORDER BY avg_attendance DESC;

-- 8) Which formations were most effective in terms of the average number of goals scored
--    and expected goals (xG)?

SELECT formation,COUNT(*) AS Frequency_of_Formation, 
       CAST(AVG(gf*1.0) AS decimal(10,2)) as Avg_Goals_Scored,
	   CAST(AVG(xg) AS decimal(10,2)) as Avg_xg_generated
FROM PL20_24
GROUP BY formation
HAVING COUNT(*) >= 10
ORDER BY Avg_xg_generated desc

--9) Assess the relationship between possession and goals scored. Do teams with higher
--   possession percentages tend to score more goals, or is there no significant correlation?

SELECT team,
       AVG(poss) AS Avg_Possession_per_Game,
       CAST(AVG(gf*1.0) as decimal(4,2)) As Avg_Goals_per_Game,
	   RANK() OVER (ORDER BY AVG(gf*1.0) desc) AS Goal_Scoring_Ranking
FROM PL20_24
GROUP BY team
ORDER BY AVG(poss) desc

-- 10) What are the top 5 highest-attended matches, and did attendance have any significant
--     effect on the result or team performance?

SELECT TOP 5 * from PL20_24
WHERE venue = 'Home'
ORDER BY attendance desc

-- 11) Analyze the trend of xG and xGA for the top 6 teams across the seasons. How have
--     their offensive and defensive performances evolved?

SELECT Season,Team,
    CAST(AVG(xG) as decimal(4,2)) AS Avg_xG,
    CAST(AVG(xGA) as decimal(4,2)) AS Avg_xGA
FROM PL20_24 
WHERE team IN (
		SELECT TOP 6 team FROM PL20_24
		GROUP BY team
		ORDER BY AVG(xg) desc
)
GROUP BY team,season
ORDER BY team, season, Avg_xG DESC;

-- 12) What is the relationship between total distance covered and match 
--     outcomes (wins, losses, draws)? Do teams that cover more distance tend to win? 

WITH Percentages AS (SELECT Team, 
    CAST(SUM(dist)/COUNT(*) AS decimal(4,1)) AS Distance_Covered_per_Game,
    CAST(COUNT(CASE WHEN Result = 'W' THEN 1 END) * 100.0/COUNT(*) AS DECIMAL(4, 2)) AS Win_Percentage,
    CAST(COUNT(CASE WHEN Result = 'D' THEN 1 END) * 100.0/COUNT(*) AS DECIMAL(4, 2)) AS Loss_Percentage,
    CAST(COUNT(CASE WHEN Result = 'L' THEN 1 END) * 100.0/COUNT(*) AS DECIMAL(4, 2)) AS Draw_Percentage
FROM PL20_24
GROUP BY Team)

SELECT *,RANK() OVER (ORDER BY Win_Percentage DESC, Loss_Percentage) AS [Winning_%_Ranked]
FROM Percentages
ORDER BY Distance_Covered_per_Game DESC

-- 13) Which matches had the biggest discrepancy between xG and xGA and the actual result
--     (e.g., a team with high xG to xGA difference that still lost)?

SELECT Top 10 season,team,opponent,gf,ga,xg,xga,(xg-xga) AS xg_discrepancy
FROM PL20_24
WHERE result = 'L'
ORDER BY xg_discrepancy DESC

-- 14) Create a season-over-season comparison of top-performing teams based on xG, goals,
--     and possession. How consistent were their performances? 

SELECT Team, Season, AVG(poss) AS Avg_Possession,
       CAST(AVG(xG) as decimal(4,2)) AS Avg_xG,
	   CAST(AVG(gf*1.0) as decimal(4,2)) AS Avg_xG
FROM PL20_24
WHERE team IN (
		SELECT TOP 6 team FROM PL20_24
		GROUP BY team
		ORDER BY AVG(xg) desc
)
GROUP BY team,season
ORDER BY team, season;

-- 15) Which teams were most efficient in converting shots on target to goals?
--     How does this efficiency compare between home and away games?

WITH ConversionEfficiency AS (
    SELECT Team,Venue, 
			CAST(SUM(GF)*1.0/NULLIF(SUM(shots_on_target), 0) AS DECIMAL(4, 2)) AS Conversion_Efficiency
    FROM PL20_24
    GROUP BY Team, Venue
)
SELECT Team,
    CAST(AVG(Conversion_Efficiency) as decimal(4,2)) AS Conversion_Efficiency,
    MAX(CASE WHEN Venue = 'Home' THEN Conversion_Efficiency END) AS Home_Conversion_Efficiency,
	MAX(CASE WHEN Venue = 'Away' THEN Conversion_Efficiency END) AS Away_Conversion_Efficiency,
    CAST(AVG(CASE WHEN Venue = 'Home' THEN Conversion_Efficiency END) - AVG(CASE WHEN Venue = 'Away' THEN Conversion_Efficiency END) AS DECIMAL(5, 2)) AS Efficiency_Difference
FROM ConversionEfficiency
GROUP BY Team
ORDER BY Conversion_Efficiency DESC;

-- 16) How does the number of shots and shots on target influence the probability of winning a match?
--     What is the threshold number of shots for a high win probability?

WITH MatchOutcomes AS (
    SELECT Team,
        CASE 
            WHEN GF > GA THEN 1   -- Win
            WHEN GF = GA THEN 0   -- Draw
            ELSE -1               -- Loss
        END AS Outcome,
        shots,shots_on_target
    FROM PL20_24
),
ShotWinAnalysis AS (
    SELECT Shots,shots_on_target,
        SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Wins,
        COUNT(*) AS Total_Matches,
        CAST(SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5, 2)) AS Win_Probability
    FROM MatchOutcomes
    GROUP BY shots, shots_on_target
),
BinnedShotWinAnalysis AS (
    SELECT
        CASE 
            WHEN Shots BETWEEN 0 AND 5 THEN '0-5'
            WHEN Shots BETWEEN 6 AND 10 THEN '6-10'
            WHEN Shots BETWEEN 11 AND 15 THEN '11-15'
            WHEN Shots BETWEEN 16 AND 20 THEN '16-20'
            ELSE '21+' 
        END AS Shot_Range,
        SUM(Wins) AS Total_Wins,
        SUM(Total_Matches) AS Total_Matches_in_Range,
        CAST(SUM(Wins) * 100.0 / SUM(Total_Matches) AS DECIMAL(5, 2)) AS Win_Probability
    FROM 
        ShotWinAnalysis
    GROUP BY 
        CASE 
            WHEN Shots BETWEEN 0 AND 5 THEN '0-5'
            WHEN Shots BETWEEN 6 AND 10 THEN '6-10'
            WHEN Shots BETWEEN 11 AND 15 THEN '11-15'
            WHEN Shots BETWEEN 16 AND 20 THEN '16-20'
            ELSE '21+' 
        END
)
SELECT 
   DISTINCT r.Shot_Range,
    r.Win_Probability AS Range_Win_Probability
FROM 
    ShotWinAnalysis b
JOIN 
    BinnedShotWinAnalysis r
ON 
    CASE 
        WHEN b.Shots BETWEEN 0 AND 5 THEN '0-5'
        WHEN b.Shots BETWEEN 6 AND 10 THEN '6-10'
        WHEN b.Shots BETWEEN 11 AND 15 THEN '11-15'
        WHEN b.Shots BETWEEN 16 AND 20 THEN '16-20'
        ELSE '21+' 
    END = r.Shot_Range
ORDER BY 
  Range_Win_Probability DESC;

-- 17) Determine the impact of different formations on match outcomes and xG.
--     Which formation is the most successful across all teams?

SELECT formation, COUNT(*) AS Formation_Used_Count, 
       CAST(AVG(xg) as decimal(4,2)) AS Average_xg_generated,
       CAST(SUM(CASE WHEN Result = 'W' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS DECIMAL(4, 2)) AS Win_Percentage,
       RANK() OVER(ORDER BY AVG(xg) DESC) as xg_rank	   
FROM PL20_24
GROUP BY formation
HAVING COUNT(*) >= 10
ORDER BY Win_Percentage DESC

-- 18) What is the trend of penalty kick success rate over the seasons for all teams?
--     Which team has the highest success rate in penalties?

SELECT team, SUM(pkatt) AS Penalty_Kicks_Attempted,
       CAST(SUM(pk)*100.0/SUM(pkatt) AS decimal(4,1)) AS PK_Success_Rate FROM PL20_24
GROUP BY team
ORDER BY PK_Success_Rate DESC, Penalty_Kicks_Attempted DESC

-- 19) Analyze the relationship between possession and shot efficiency (shots on target
--     per total shots). Which teams are the most efficient with lower possession,
--     and which teams dominate possession but are less efficient in converting shots?

SELECT team, AVG(poss) AS Average_Possession,
       CAST(SUM(shots_on_target)*100.0/SUM(shots) as decimal(4,2)) AS shot_efficicency,
	   RANK() OVER (ORDER BY SUM(shots_on_target)*100.0/SUM(shots) DESC) AS efficiency_ranking
FROM PL20_24
GROUP BY team
ORDER BY Average_Possession DESC

-- 20) Which team had the most consistent performance across the seasons, based on variance
--     in xg, goals scored, and goals conceded?

WITH TeamVariance AS (
    SELECT Team,
        CAST(VAR(xg) AS DECIMAL(4,2)) AS xG_Variance,
        CAST(VAR(gf) AS DECIMAL(4,2)) AS GF_Variance,
        CAST(VAR(ga) AS DECIMAL(4,2)) AS GA_Variance
    FROM PL20_24
    GROUP BY Team
),
TeamConsistency AS (
    SELECT Team,
        xG_Variance,
        GF_Variance,
        GA_Variance,
        -- Total variance as a measure of consistency
        (xG_Variance + GF_Variance + GA_Variance) AS Total_Variance
    FROM TeamVariance
)
SELECT Team,
    xG_Variance,
    GF_Variance,
    GA_Variance,
    Total_Variance
FROM
    TeamConsistency
ORDER BY
    Total_Variance ASC;  -- Lower variance means more consistent

