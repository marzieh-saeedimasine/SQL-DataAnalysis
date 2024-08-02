-- SQL Data Cleaning, Overview:
-- download dataset frm kaggle: https://www.kaggle.com/datasets/swaptr/layoffs-2022
-- check for duplicates and remove any
-- standardize data and fix errors
-- Look at null values and how to fix it
-- remove columns with null values

-- Create a back_up dataset
SELECT * FROM layoffs;
CREATE TABLE layoffs_backup LIKE layoffs;
INSERT layoffs_backup SELECT * FROM layoffs;

-- check for duplicates and remove them

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() over(partition by company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions)
 AS row_num
 FROM layoffs)
 SELECT * FROM  duplicate_cte where row_num >1 ;


CREATE TABLE `layoffs_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_2 
SELECT *,
ROW_NUMBER() over(partition by company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

-- SET SQL_SAFE_UPDATES = 0; SET SQL_SAFE_UPDATES = 1;
DELETE FROM layoffs_2 where row_num >1;
-- Drop row_num column from layoffs_2
ALTER TABLE layoffs_2 DROP column  row_num;

-- standardize data for company, industry, country columns
SELECT DISTINCT company FROM layoffs_2 order by 1;
UPDATE layoffs_2 SET company=TRIM(company);

SELECT DISTINCT industry FROM layoffs_2 order by 1;
SELECT DISTINCT industry FROM layoffs_2 where industry like "%Crypto%";
UPDATE layoffs_2 SET industry="Crypto" where industry like "%Crypto%";

SELECT DISTINCT country FROM layoffs_2 order by 1;
SELECT DISTINCT country FROM layoffs_2 where country like "%united states%";
UPDATE layoffs_2 SET country=TRIM(TRAILING '.' FROM country) where country like "%united states%";

-- standardize `date` column 
SELECT `date`, str_to_date(`date`,"%m/%d/%Y") as str_date FROM layoffs_2;
UPDATE layoffs_2 SET `date`= str_to_date(`date`,"%m/%d/%Y");
ALTER TABLE layoffs_2 MODIFY column `date` DATE;




-- Join table with itself to fix missed industry
SELECT * FROM layoffs_2 where industry is null or industry='';
UPDATE layoffs_2 SET industry=null where industry='';


SELECT t1.company, t1.industry,t2.industry 
FROM layoffs_2 t1
JOIN layoffs_2 t2 ON t1.company=t2.company
WHERE t1.industry is NULL AND t2.industry is NOT null ;
 
UPDATE layoffs_2 t1 
JOIN layoffs_2 t2 ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry is null AND t2.industry is NOT null ;

-- fix total_laid_off and percentage_laid_off
SELECT * FROM layoffs_2 where total_laid_off is NULL and percentage_laid_off is NULL;
DELETE FROM layoffs_2 where total_laid_off is NULL and percentage_laid_off is NULL;
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_2; 
SELECT * FROM layoffs_2 WHERE percentage_laid_off=1 order by total_laid_off DESC; 
SELECT company, SUM(total_laid_off) FROM layoffs_2 group by company order by 2 DESC; 
SELECT industry, SUM(total_laid_off) FROM layoffs_2 group by industry order by 2 DESC; 
SELECT country, SUM(total_laid_off) FROM layoffs_2 group by country order by 2 DESC;

-- Analyze rolling sum of total_laid_off for different months and years
SELECT MAX(`date`), MIN(`date`) FROM layoffs_2;
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_2 WHERE YEAR(`date`) is NOT null group by YEAR(`date`) order by 1 ASC;

WITH rolling_cte AS 
(SELECT * , substring(`date`,1,7) as `month` FROM layoffs_2)
SELECT `month`, SUM(total_laid_off) FROM rolling_cte group by `month` order by `month` ASC LIMIT 50 OFFSET 1;


-- break down of total_laid_off by company for each year 
SELECT company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_2 group by company, YEAR(`date`) order by 1 ASC; 

WITH company_year_cte (company, years, total_layoff) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_2 group by company, YEAR(`date`)
)
SELECT *, dense_rank() OVER (PARTITION BY years order by total_layoff DESC) as ranking
FROM company_year_cte where years is not NULL order by ranking ASC LIMIT 20;  


