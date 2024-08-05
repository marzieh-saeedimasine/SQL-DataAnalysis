-- Download data from: https://www.kaggle.com/datasets/shivamb/netflix-shows
-- load data in python and transform to MySQL
-- remove duplicates 
-- data type conversions for date added 
-- populate missing values in country,duration columns
-- new table for listed_in,director, country,cast
-- drop columns director , listed_in,country,cast
-- netflix data analysis:
-- for each director count the no of movies and tv shows created by them in separate columns for directors who have created tv shows and movies both
-- which country has highest number of comedy movies 
-- for each year (as per date added to netflix), which director has maximum number of movies released
-- what is average duration of movies in each genre
-- find the list of directors who have created horror and comedy movies both.
-- display director names along with number of comedy and horror movies directed by them 
DROP table netflix_project;

CREATE TABLE `netflix_project` (
  `show_id` varchar(10) primary key,
  `type` varchar(10),
  `title` nvarchar(200),
  `director` varchar(300),
  `cast` varchar(1000),
  `country` varchar(200),
  `date_added` varchar(20),
  `release_year` int NULL,
  `rating` varchar(10),
  `duration` varchar(10),
  `listed_in` varchar(100),
  `description` varchar(1000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- check is show_id is duplicated 
SELECT show_id, count(*) as cnt FROM netflix_project group by show_id having cnt >1;

-- remove duplicates 
SELECT  title,type, count(*) as cnt FROM netflix_project group by title, type having cnt=1;

CREATE TABLE `netflix_table` (
  `show_id` varchar(10) primary key,
  `type` varchar(10),
  `title` nvarchar(200),
  `director` varchar(300),
  `cast` varchar(1000),
  `country` varchar(200),
  `date_added` varchar(20),
  `release_year` int NULL,
  `rating` varchar(10),
  `duration` varchar(10),
  `listed_in` varchar(100),
  `description` varchar(1000),
  `row_num` int NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO netflix_table 
WITH cte as (SELECT *,
ROW_NUMBER() over(partition by title, type) AS row_num FROM netflix_project)
SELECT * FROM cte where row_num =1;
ALTER TABLE netflix_table DROP COLUMN row_num;


-- data type conversions for date added 
SELECT date_added, str_to_date(date_added, '%M %d, %Y') as str_date FROM netflix_table;
UPDATE netflix_table SET date_added= str_to_date(date_added, '%M %d, %Y');
ALTER TABLE netflix_table MODIFY column date_added DATE;

-- populate missing values in duration columns and replace "min" in duration to the empty
SELECT * FROM netflix_table where duration is null;

UPDATE netflix_table SET duration = 
CASE 
    WHEN duration IS NULL THEN rating 
    ELSE duration 
END;

SELECT duration, REPLACE(duration,' min','') FROM netflix_table;
UPDATE netflix_table SET duration=REPLACE(duration,' min','');


-- populate missing values in country columns
SELECT count(*) FROM netflix_table where country is null;

SELECT n1.director, n1.country, n2.country 
FROM netflix_table n1
join netflix_table n2 ON n1.director=n2.director
where n1.country is NULl and n2.country is not null order by 1;

UPDATE netflix_table n1
join netflix_table n2 ON n1.director=n2.director
SET n1.country = n2.country
where n1.country is NULl and n2.country is not null;

-- new table for director,country,cast, listed_in,
CREATE TABLE netflix_listed_in (
    show_id varchar(10),
    listed_in VARCHAR(200)
);

INSERT INTO netflix_listed_in (show_id, listed_in)
WITH RECURSIVE spliter_cte AS (
    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS listed_in,
        SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2) AS rest,
        1 AS level
    FROM 
        netflix_table
    WHERE 
        listed_in IS NOT NULL

    UNION ALL
    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS listed_in,
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2) AS rest,
        level + 1
    FROM 
        spliter_cte
    WHERE 
        rest != ''
)
SELECT show_id, listed_in
FROM spliter_cte
ORDER BY show_id;

-- drop columns director , listed_in,country,cast
ALTER TABLE netflix_table
DROP COLUMN director,
DROP COLUMN country,
DROP COLUMN cast,
DROP COLUMN listed_in;

-- netflix data analysis:

-- for each director count the no of movies and tv shows created by them in separate columns for directors who have created tv shows and movies both
SELECT nd.director,
count(distinct(case WHEN nt.type="Movie" THEN nd.show_id end)) as Movie_num,
count(distinct(case WHEN nt.type="TV Show" THEN nd.show_id end)) as Show_num
FROM netflix_table nt
inner join netflix_director nd ON nt.show_id=nd.show_id 
group by nd.director having count(Distinct(nt.type))>1 order by 1 ;

-- which country has highest number of comedy movies 
SELECT nc.country, count(distinct(nc.show_id)) as num_movies
FROM netflix_country nc 
INNER Join netflix_listed_in nl ON nc.show_id=nl.show_id
INNER Join netflix_table nt  ON nc.show_id=nt.show_id
where nl.listed_in="Comedies" and nt.type="Movie" 
group by nc.country order by 2 DESC;

-- for each year (as per date added to netflix), which director has maximum number of movies
WITH director_cts as (
SELECT year(nt.date_added) as year_added, nd.director, count(distinct(nd.show_id)) as num_movies
FROM netflix_table nt 
inner join netflix_director nd ON nt.show_id=nd.show_id 
group by year_added,nd.director),
ranking_cts as (
SELECT *,
row_number()OVER(Partition by year_added order by num_movies DESC) as ranking
FROM director_cts)
SELECT * FROM ranking_cts where ranking=1;

-- what is average duration of movies in each genre
SELECT nl.listed_in, round(avg(nt.duration),0) as avg_duration
FROM netflix_listed_in nl
INNER Join netflix_table nt ON nl.show_id=nt.show_id 
Where nt.type="movie"
group by nl.listed_in;

-- find the list of directors who have created horror and comedy movies both.
-- display director names along with number of comedy and horror movies directed by them 
SELECT nd.director,
count(distinct(CASE  WHEN nl.listed_in="Comedies" THEN nl.show_id  END)) as num_Comedies,
count(distinct(CASE  WHEN nl.listed_in="Horror Movies" THEN nl.show_id END)) as num_Comedies 
FROM netflix_director nd
INNER Join netflix_listed_in nl ON nd.show_id=nl.show_id 
INNER Join netflix_table nt  ON nl.show_id=nt.show_id
Where nt.type="movie" and nl.listed_in in ("Comedies","Horror Movies")
group by nd.director having count(distinct(nl.listed_in)) =2;
