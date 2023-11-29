SELECT title, industry FROM movies;
SELECT count(*) FROM movies where industry="bollywood";
SELECT distinct industry FROM movies;
SELECT * FROM movies where title like "%Thor%";
SELECT * FROM movies where studio=""; 
SELECT * FROM movies where imdb_rating >=9;
SELECT * FROM movies where imdb_rating>=6 and imdb_rating<=8;
SELECT * FROM movies where imdb_rating between 6 and 8;
SELECT * FROM movies where release_year=2022 or release_year=2019;
SELECT * FROM movies where release_year in (2022,2019);
SELECT * FROM movies where imdb_rating is null;
SELECT * FROM movies where imdb_rating is NOT null;
SELECT * FROM movies where industry="Bollywood" ORDER by release_year;
SELECT * FROM movies where industry="Bollywood" ORDER by release_year DESC LIMIT 5;
select * from movies where industry="hollywood" order by release_year DESC LIMIT 10 OFFSET 1;
select MAX(imdb_rating) from movies where industry="bollywood";
select round(avg(imdb_rating),2) from movies where industry="bollywood"; 
SELECT round(avg(imdb_rating),2) as avg_rating from movies where industry="bollywood";
SELECT max(imdb_rating) as max_rating,
min(imdb_rating) as min_rating,
round(avg(imdb_rating),2) as avg_rating from movies where industry="bollywood";  
SELECT industry, count(*) from movies GROUP BY industry; 
SELECT studio, avg(imdb_rating) from movies GROUP BY studio; 
SELECT studio, count(*) as cnt from movies GROUP BY studio ORDER by cnt; 
SELECT studio, count(*) as cnt, round(avg(imdb_rating),2) as avg_rating from movies GROUP BY studio ORDER by cnt; 
SELECT studio, count(*) as cnt, round(avg(imdb_rating),1) as avg_rating FROM movies where studio!= "" group by studio order by avg_rating DESC;
SELECT release_year, count(*) as cnt from movies group by release_year having cnt >2 order by cnt DESC;
SELECT * , YEAR(CURDATE())-birth_year as age from actors;
SELECT * ,(revenue-budget) as profit FROM financials;
SELECT *, IF(currency="USD", revenue*80, revenue) as revenue_cur FROM financials;

SELECT *, 
CASE
 WHEN unit="Billions" THEN revenue*1000
 WHEN unit="Thousands" THEN revenue/1000
  WHEN unit="Millions" THEN revenue
 END as revenue_unit
 FROM financials;
 
SELECT movies.movie_id, title, revenue, currency, unit
FROM movies
INNER JOIN financials
ON movies.movie_id=financials.movie_id;

SELECT movies.movie_id, title, revenue, currency, unit
FROM movies
LEFT JOIN financials
ON movies.movie_id=financials.movie_id;

SELECT financials.movie_id, title, revenue, currency, unit
FROM movies
RIGHT JOIN financials
ON movies.movie_id=financials.movie_id;


SELECT movies.movie_id, title, revenue, currency, unit
FROM movies
LEFT JOIN financials
ON movies.movie_id=financials.movie_id

UNION

SELECT financials.movie_id, title, revenue, currency, unit
FROM movies
RIGHT JOIN financials
ON movies.movie_id=financials.movie_id;

SELECT movie_id, title, revenue, currency, unit
FROM movies
RIGHT JOIN financials
USING (movie_id);