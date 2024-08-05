SQL Data Cleaning Repo:

This repository provides End to End projects for data learning and analysis using MYSQL.


## Overview of layoff data cleaning project:
-- Download Dataset:https://www.kaggle.com/datasets/swaptr/layoffs-2022  
-- Check for Duplicates: Identify and remove any duplicate records.
-- Standardize Data and Fix Errors: Ensure data consistency and correct any errors.
-- Handle Null Values: Identify null values and determine the best approach to address them.
-- Remove Columns with Null Values: Eliminate columns that contain only null values. 

## Overview of retail data analyzing project:  
-- Data downloaded from kaggle: https://www.kaggle.com/datasets/ankitbansal06/retail-orders  
-- Some cleaning and transformation has been performed in python and loaded data to mysql (df.to_sql)  
-- Analyze data in SQL to answer following questions:  
-- find top 10 highest reveue generating products   
-- find top 5 highest selling products in each region  
-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023  
-- for each category which month had highest sales   
-- which sub category had highest growth by profit in 2023 compare to 2022  

## Overview of Netflix ETL Extract, transform and load data to SQL as well as data analysis: 
-- Download data from: https://www.kaggle.com/datasets/shivamb/netflix-shows  
-- Extract data in python and transform to MySQL  
-- For data cleaning, remove duplicates, data type conversions for date, populate missing values in country and duration columns, make new table for listed_in,director, country,cast columns, and drop columns director, listed_in,country,cast  
Data analysis part:  
-- for each director count the no of movies and tv shows created by them in separate columns for directors who have created tv shows and movies both  
-- which country has highest number of comedy movies   
-- for each year (as per date added to netflix), which director has maximum number of movies release  
-- what is average duration of movies in each genre  
-- find the list of directors who have created horror and comedy movies both.  
-- display director names along with number of comedy and horror movies directed by them   