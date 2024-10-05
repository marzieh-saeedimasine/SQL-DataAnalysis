-- Dataset of Chicago Crime was downloaded and loaded to the google bigquery:https://www.kaggle.com/datasets/chicago/chicago-crime
-- Google BigQuery has been configured for SQL environment. 
-- SQL queries have been implemented to break down information of different questions.


-- From what date is the oldest data point in the data set? 
SELECT MIN(date) AS oldest_date FROM crime;

-- Which year had the highest amount of crimes?
SELECT year, COUNT(*) AS crime_count FROM crime GROUP BY year ORDER BY crime_count DESC LIMIT 1;


-- Let's define "Arrest Rate" as the share of crimes that led to an arrest.What year had the highest arrest rate? What is the overall trend in number of crimes per year?

SELECT year, 
       SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) AS total_arrests,
       COUNT(*) AS total_crimes,
       (SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS arrest_rate
FROM crime GROUP BY year ORDER BY arrest_rate DESC LIMIT 1;


-- What were the five most common crimes in 2020?
SELECT primary_type, COUNT(*) AS crime_count FROM crime
WHERE year = 2020 GROUP BY primary_type ORDER BY crime_count DESC LIMIT 5;

-- Which of those crimes had the highest and lowest arrest rate?
WITH CommonCrimes AS (
    SELECT primary_type FROM crime 
    WHERE year = 2020 GROUP BY primary_type ORDER BY COUNT(*) DESC LIMIT 5
)
SELECT c.primary_type,
       SUM(CASE WHEN t.arrest = TRUE THEN 1 ELSE 0 END) AS total_arrests,
       COUNT(*) AS total_crimes,
       (SUM(CASE WHEN t.arrest = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS arrest_rate
FROM CommonCrimes c
JOIN crime t ON c.primary_type = t.primary_type
WHERE t.year = 2020
GROUP BY c.primary_type
ORDER BY arrest_rate DESC;

--Investigate which year that had the highest number of crimes leading to an arrest. What year was it, and how many arrests were made during that year?
SELECT year, COUNT(*) AS total_arrests
FROM crime WHERE arrest = TRUE GROUP BY year ORDER BY total_arrests DESC LIMIT 1;

--How has the arrest rate looked like over time? 

SELECT year, 
       SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) AS total_arrests,
       COUNT(*) AS total_crimes,
       (SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS arrest_rate
FROM crime GROUP BY year ORDER BY year;

--What was the arrest rate for thefts during 2017 and 2018?
SELECT 
    year,
    SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) AS total_arrests,
    COUNT(*) AS total_crimes,
    (SUM(CASE WHEN arrest = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS arrest_rate
FROM crime WHERE primary_type = 'THEFT' AND year IN (2017, 2018) GROUP BY year ORDER BY year;