-- Data set was taken from kaggle: https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results
-- SQL queries have been implemented to break down information of different olympic games.  

SELECT * from athlete_events;

-- How many olympics games have been held?
SELECT count(distinct(Games)) as  games_total from athlete_events;
SELECT count(distinct(Games)) as games_summer  from athlete_events where Season="Summer";
SELECT count(distinct(Games)) as games_winter  from athlete_events where Season="Winter";

-- List down all Olympics games held so far.
SELECT distinct(year), Season, city from athlete_events order by 1;

-- Mention the total no of nations who participated in each olympics game?
-- Which year saw the highest and lowest no of countries participating in olympics?
SELECT Games, count(distinct(NOC)) as total_nations from athlete_events group by Games order by 1;

-- Which nation has participated in all of the olympic games?
SELECT re.region, count(distinct(ath.Games)) as total_games 
from athlete_events ath
left join noc_regions re ON ath.NOC=re.NOC
group by re.region having total_games =(SELECT count(distinct(Games)) from athlete_events);

-- Identify the sport which was played in all summer olympics.
SELECT Sport, count(distinct(Games)) as summer_sport FROM athlete_events where Season="Summer" group by Sport
having summer_sport =(SELECT count(distinct(Games)) from athlete_events where Season="Summer");

-- Which Sports were just played only once in the olympics?
SELECT Sport, count(distinct(Games)) as total_games  FROM athlete_events group by Sport having total_games=1;

-- Fetch the total no of sports played in each olympic games.
SELECT Games, count(distinct(Sport)) as total_sport from athlete_events group by Games order by 2 DESC;

-- Fetch details of the oldest athletes to win a gold medal.
SELECT * from athlete_events where medal="Gold" and Age <> "NA" order by Age DESC limit 2;

-- Find the Ratio of male and female athletes participated in all olympic games.
SELECT sum(Sex="M") as sum_M, sum(Sex="F") as sum_F, sum(Sex="M")/sum(Sex="F")  as ratio from athlete_events;

-- Fetch the top 5 athletes who have won the most gold medals.
With gold_cte as (SELECT Name,
 count(CASE When medal="GOLD" then medal END) as gold_medal
 from athlete_events group by Name order by gold_medal DESC),
rank_cte as (
SELECT *, dense_rank() over(order by gold_medal DESC) as rank_gold from gold_cte)
SELECT * from rank_cte where rank_gold<= 5;
 
-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
 with medal_cte as (
 SELECT Name, count(medal) as total_medal from athlete_events where medal <> "NA" group by Name order by 2 DESC limit 10),
 rank_cte as (SELECT *, dense_rank() over(order by total_medal DESC) as rank_medal from medal_cte)
 SELECT *  from rank_cte where rank_medal <=5;
 
-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
SELECT re.region, count(medal) as total_medal
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC
where medal <> "NA" group by region order by total_medal DESC limit 5;

-- List down total gold, silver and broze medals won by each country.
SELECT re.region,
count(CASE When ath.medal="GOLD" then ath.medal END) as gold_medal,
count(CASE When ath.medal="Silver" then ath.medal END) as silver_medal,
count(CASE When ath.medal="Bronze" then ath.medal END) as Bronze_medal 
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC
group by re.region order by 2 DESC,3 DESC, 4 DESC;

-- List down total gold, silver and broze medals won by each country corresponding to each olympic games.
SELECT ath.games, re.region,
count(CASE When ath.medal="GOLD" then ath.medal END) as gold_medal,
count(CASE When ath.medal="Silver" then ath.medal END) as silver_medal,
count(CASE When ath.medal="Bronze" then ath.medal END) as Bronze_medal 
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC
group by  ath.games, re.region order by 1;

-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.
with medal_cte as 
(SELECT ath.games, re.region,
count(CASE When ath.medal="GOLD" then ath.medal END) as gold_medal,
count(CASE When ath.medal="Silver" then ath.medal END) as silver_medal,
count(CASE When ath.medal="Bronze" then ath.medal END) as bronze_medal 
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC
group by  ath.games, re.region order by 1),
rank_cte as (
SELECT *,
row_number() over(partition by games order by gold_medal DESC) as rank_gold,
row_number() over(partition by games order by silver_medal DESC) as rank_silver,
row_number() over(partition by games order by bronze_medal DESC) as rank_bronze
from medal_cte),
final_cte as (
select games, 
CASE WHEN rank_gold=1 then concat( region,"-",gold_medal)END as gold_medal_most,
CASE WHEN rank_silver=1 then concat( region,"-",silver_medal)END as silver_medal_most,
CASE WHEN rank_bronze=1 then concat( region,"-",bronze_medal) END as bronze_medal_most
from rank_cte)
SELECT games,
group_concat(gold_medal_most) as gold_medal,
group_concat(silver_medal_most) as silver_medal,
group_concat(bronze_medal_most) as bronze_medal 
from final_cte group by games;

-- Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
with medal_cte as 
(SELECT ath.games, re.region,
count(CASE When ath.medal="GOLD" then ath.medal END) as gold_medal,
count(CASE When ath.medal="Silver" then ath.medal END) as silver_medal,
count(CASE When ath.medal="Bronze" then ath.medal END) as bronze_medal,
count(CASE When ath.medal in ("GOLD","Silver","Bronze") then ath.medal END) as total_medal 
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC
group by  ath.games, re.region order by 1),
rank_cte as (
SELECT *,
row_number() over(partition by games order by gold_medal DESC) as rank_gold,
row_number() over(partition by games order by silver_medal DESC) as rank_silver,
row_number() over(partition by games order by bronze_medal DESC) as rank_bronze,
row_number() over(partition by games order by total_medal DESC) as rank_total
from medal_cte),
final_cte as (
select games, 
CASE WHEN rank_gold=1 then concat( region,"-",gold_medal)END as gold_medal_most,
CASE WHEN rank_silver=1 then concat( region,"-",silver_medal)END as silver_medal_most,
CASE WHEN rank_bronze=1 then concat( region,"-",bronze_medal) END as bronze_medal_most,
CASE WHEN rank_total=1 then concat( region,"-",total_medal) END as total_medal_most
from rank_cte)
SELECT games,
group_concat(gold_medal_most) as gold_medal,
group_concat(silver_medal_most) as silver_medal,
group_concat(bronze_medal_most) as bronze_medal,
group_concat(total_medal_most) as total_medal  
from final_cte group by games;

-- Which countries have never won gold medal but have won silver/bronze medals?
with medal_cte as (
SELECT re.region, 
count(CASE When ath.medal="GOLD" then ath.medal END) as gold_medal,
count(CASE When ath.medal in ("Silver","Bronze") then ath.medal END) as other_medal
from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC group by re.region)
SELECT * from medal_cte where gold_medal=0 and other_medal !=0 order by 1;

-- In which Sport/event, India has won highest medals.
SELECT Sport, count(Medal) as total_medal from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC where re.region="India" group by Sport order by total_medal DESC limit 1;

-- Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.
SELECT ath.games, count(ath.Medal) as Hockey_medal from athlete_events ath
left join noc_regions re on ath.NOC=re.NOC where re.region="India" and ath.Sport="Hockey" group by ath.games order by 1;
