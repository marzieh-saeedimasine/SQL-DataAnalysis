SQL Data Cleaning Repo:

This repository provides End to End projects for data learning and analysis using MYSQL.


## Overview of layoff data cleaning project:
-- Download Dataset:https://www.kaggle.com/datasets/swaptr/layoffs-2022  
-- Check for Duplicates: Identify and remove any duplicate records.  
-- Standardize Data and Fix Errors: Ensure data consistency and correct any errors.  
-- Handle Null Values: Identify null values and determine the best approach to address them.  
-- Remove Columns with Null Values: Eliminate columns that contain only null values.   

## Overview of retail data analysis project:  
-- Data downloaded from kaggle: https://www.kaggle.com/datasets/ankitbansal06/retail-orders  
-- Some cleaning and transformation has been performed in python and loaded data to mysql (df.to_sql)   
**Data analysis part:**   
-- find top 10 highest reveue generating products     
-- find top 5 highest selling products in each region  
-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023  
-- for each category which month had highest sales   
-- which sub category had highest growth by profit in 2023 compare to 2022  

## Overview of Netflix ETL (extract, transform and load data) as well as data analysis project:   
-- Download data from: https://www.kaggle.com/datasets/shivamb/netflix-shows  
-- Extract data in python and transform to MySQL  
-- For data cleaning, remove duplicates, type conversions for date, populate missing values in some columns, make new tables for splited columns, and drop some columns    
**Data analysis part:**  
-- for each director count the no of movies and tv shows created by them in separate columns for directors who have created tv shows and movies both  
-- which country has highest number of comedy movies   
-- for each year (as per date added to netflix), which director has maximum number of movies release  
-- what is average duration of movies in each genre  
-- find the list of directors who have created horror and comedy movies both.  
-- display director names along with number of comedy and horror movies directed by them   

## Overview of chocolate sales data analysis project:     
-- Download sql dataset from: https://www.kaggle.com/datasets/anshika2301/data-analysis-of-chocolates       
**Data analysis part:**  
-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100.  
-- How many shipments (sales) each of the sales persons had in the month of January 2022?  
-- Which product sells more boxes? Milk Bars or Eclairs?  
-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?  
-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?  
-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?  
-- Which salespersons did not make any shipments in the first 7 days of January 2022?  
-- How many times we shipped more than 1,000 boxes in each month of each year?  
-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?  
-- India or Australia? Who buys more chocolate boxes on a monthly basis?  