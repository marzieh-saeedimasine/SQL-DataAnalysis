-- Data downloaded from kaggle: https://www.kaggle.com/datasets/ankitbansal06/retail-orders
-- Some cleaning and transformation has been performed in python and loaded data to mysql (df.to_sql)
-- Analyze data in SQL to answer following questions:
-- find top 10 highest reveue generating products 
-- find top 5 highest selling products in each region
-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
-- for each category which month had highest sales 
-- which sub category had highest growth by profit in 2023 compare to 2022


DROP TABLE df_orders;

 CREATE TABLE `df_orders` (
  `order_id` int primary key,
  `order_date` date,
  `ship_mode` varchar(20),
  `segment` varchar(20),
  `country` varchar(20),
  `city` varchar(20),
  `state` varchar(20),
  `postal_code` varchar(20),
  `region` varchar(20),
  `category` text,
  `sub_category` text,
  `product_id` text,
  `quantity` int,
  `discount` decimal(7,2),
  `sale_price` decimal(7,2),
  `profit` decimal(7,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM df_orders;

-- find top 10 highest reveue generating products 
SELECT  product_id, sum(sale_price) as sales FROM df_orders group by product_id order by sales DESC LIMIT 10;


-- find top 5 highest selling products in each region
WITH region_cte as (
SELECT region, product_id, sum(sale_price) as sales FROM df_orders group by region,product_id order by 1),
ranking_cte as (
SELECT *, row_number() over (partition by region order by sales DESC) as ranking FROM region_cte)
SELECT *  FROM ranking_cte where ranking <= 5;


-- find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
WITH year_cte as (
SELECT year(order_date) as year_sale, month(order_date) as month_sale, sum(sale_price) as sales FROM df_orders group by year_sale,month_sale order by 1 DESC),
month_cte as (
SELECT year_sale,month_sale,
IF(year_sale=2023, sales , 0) as sale_2023,
IF(year_sale=2022, sales , 0) as sale_2022
FROM year_cte)
SELECT month_sale,sum(sale_2022), sum(sale_2023) FROM month_cte group by month_sale order by month_sale;


-- for each category which month had highest sales 
WITH category_cte as (
SELECT category, DATE_FORMAT(order_date, '%Y-%m') as year_month_sale, sum(sale_price) as sales FROM df_orders group by category, year_month_sale),
ranking_cte as (
SELECT *, row_number() over (partition by category order by sales DESC) as ranking FROM category_cte)
SELECT *  FROM ranking_cte where ranking =1;


-- which sub category had highest growth by profit in 2023 compare to 2022
WITH profit_cte as (
SELECT sub_category,year(order_date) as year_sale, sum(sale_price) as sales FROM df_orders group by sub_category,year_sale),
year_cte as (
SELECT *,
IF(year_sale=2023, sales, 0) as profit_2023,
IF(year_sale=2022, sales, 0) as profit_2022
FROM profit_cte)
SELECT sub_category,(sum(profit_2023)-sum(profit_2022))/sum(profit_2022) as sale_growth FROM year_cte group by sub_category order by sale_growth DESC;
