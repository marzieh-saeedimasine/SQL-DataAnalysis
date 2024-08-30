-- data was taken from kaggle:https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting

CREATE DATABASE IF NOT EXISTS walmart;

CREATE TABLE IF NOT EXISTS sales (
invoice_id	VARCHAR(30) NOT NULL PRIMARY KEY, 
branch	VARCHAR(5) NOT NULL,
city  VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT	FLOAT(6, 4) NOT NULL,
total DECIMAL(10, 2) NOT NULL,
date  text NOT NULL,
time text NOT NULL,
payment_method text NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_percentage	FLOAT(11, 9) NOT NULL,
gross_income DECIMAL(10, 2) NOT NULL,
rating	FLOAT(2, 1) NOT NULL
);

SELECT * FROM sales;
ALTER TABLE sales MODIFY COLUMN date DATE;
ALTER TABLE sales MODIFY COLUMN time TIME;

-- create time_of_day from the dataset
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(15);

UPDATE sales SET time_of_day=(
CASE
WHEN time between '00:00:00' and '11:59:59' then "Morning"
WHEN time between '12:00:00' and '16:59:59' then "Afternoon"
ELSE "Evening"
END);

-- create day_name from the dataset
SELECT date, DAYNAME(date) as day_name FROM walmart.sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);
UPDATE sales SET day_name=DAYNAME(date);

-- create month_name from the dataset
SELECT date, monthname(date) as month_name FROM walmart.sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);
UPDATE sales SET month_name=monthname(date);

-- How many unique cities does the data have?
SELECT distinct(city) FROM walmart.sales;

-- In which city is each branch?
SELECT distinct(city), branch FROM walmart.sales;

-- How many unique product lines does the data have?
SELECT distinct product_line FROM walmart.sales;

-- What is the most common payment method?
SELECT payment_method, count(*) FROM walmart.sales group by payment_method;

-- What is the most selling product line?
SELECT product_line, count(*) FROM walmart.sales group by product_line;

-- What is the total revenue by month?
SELECT month_name, sum(total) as revenue FROM sales group by month_name;

-- What month had the largest COGS?
SELECT month_name, sum(cogs) as COGS_total FROM sales group by month_name order by COGS_total DESC;

-- What product line had the largest revenue?
SELECT product_line, sum(total) as revenue FROM sales group by product_line order by revenue DESC limit 1;

-- What is the city with the largest revenue?
SELECT city, sum(total) as revenue FROM sales group by city order by revenue DESC limit 1;

-- What product line had the largest VAT?
SELECT product_line, avg(vat) as VAT FROM sales group by product_line order by VAT DESC limit 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT product_line, sum(total),
CASE WHEN sum(total) >  avg(total) then "Good" 
ELSE "Bad"
END
as revenue_status 
FROM sales group by product_line ;


-- Which branch sold more products than average product sold?
SELECT branch, sum(quantity),
CASE WHEN sum(quantity) > avg(quantity) then "Good" ELSE "Bad" END  as quantity_status
FROM sales group by branch;
SELECT * from sales;

-- What is the most common product line by gender?
SELECT product_line,
count(CASE When gender="Male" THEN gender END) as gender_male,
count(CASE When gender="Female" THEN gender END) as gender_female
from sales group by product_line order by 3 DESC;

SELECT product_line, gender, count(*) as count_tot from sales group by product_line, gender order by count_tot DESC;

-- What is the average rating of each product line?
SELECT product_line, round(avg(rating),2) as avg_rating from sales group by product_line;

-- Number of sales made in each time of the day per weekday
SELECT  weekday(date) as weekday, hour(time) as hour_time, count(*) as total_count from sales group by  weekday,  hour_time order by weekday ;

-- Which of the customer types brings the most revenue?
SELECT customer_type, sum(total) as revenue from sales group by customer_type order by revenue DESC limit 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, avg(VAT) as VAT from sales group by city order by VAT DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type,  avg(VAT) as VAT  from sales group by customer_type order by VAT DESC limit 1;

-- How many unique customer types does the data have?
SELECT distinct customer_type from sales;

-- How many unique payment methods does the data have?
SELECT distinct payment_method from sales;

-- What is the most common customer type?
SELECT customer_type, count(*) as count_customer from sales group by customer_type order by count_customer DESC limit 1;

-- Which customer type buys the most?
SELECT customer_type, sum(quantity) as count_total from sales group by customer_type order by count_total DESC limit 1;

-- What is the gender of most of the customers?
SELECT gender, count(*) as customer_gender from sales group by gender;

-- What is the gender distribution per branch?
SELECT branch,
count(CASE When gender="Male" THEN gender END) as gender_male,
count(CASE When gender="Female" THEN gender END) as gender_female
from sales group by branch order by 1;

-- Which time of the day do customers give most ratings?
select hour(time) as hour_day, round(avg(rating),2) as avg_rating from sales group by hour_day order by avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
select branch, hour(time) as hour_day, round(avg(rating),2) as avg_rating from sales group by branch, hour_day order by branch;

-- Which day fo the week has the best avg ratings?
select day_name, round(avg(rating),2) as avg_rating from sales group by day_name order by avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
select branch, day_name, round(avg(rating),2) as avg_rating from sales group by branch, day_name order by branch ;