-- Sales analysis of Awesome_chocolates was performed to achieve sales goals.
-- Dataset was taken from kaggle: https://www.kaggle.com/datasets/anshika2301/data-analysis-of-chocolates
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


-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100.
SELECT * from sales where amount > 2000 and boxes <100 order by amount DESC;

-- How many shipments (sales) each of the sales persons had in the month of January 2022?
SELECT p.Salesperson, count(*) as count_shipment from sales s
left join people p on s.SPID=p.SPID
where  s.SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
group by p.Salesperson order by count_shipment DESC;

-- Which product sells more boxes? Milk Bars or Eclairs?
SELECT pr.product, sum(s.Boxes) as box_sum from products pr
left join sales s on pr.PID=s.PID
where pr.product in ("Milk Bars", "Eclairs")
group by pr.product;

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
SELECT pr.product, sum(s.Boxes) as box_sum from products pr
left join sales s on pr.PID=s.PID
where s.SaleDate BETWEEN '2022-02-01' AND '2022-02-07' and pr.product in ("Milk Bars", "Eclairs")
group by pr.product;

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
SELECT *,dayofweek(SaleDate) as weekday from sales where customers <100 and boxes <100 and dayofweek(SaleDate)=2;

-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT p.Salesperson, count(PID) as count_sale from sales s
left join people p on s.SPID=p.SPID
where s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07' group by p.Salesperson order by count_sale DESC;

-- Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT Salesperson from people where Salesperson not in 
(SELECT p.Salesperson from sales s
left join people p on s.SPID=p.SPID
where s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07' group by p.Salesperson);

-- How many times we shipped more than 1,000 boxes in each month of each year?
SELECT year(SaleDate) as sale_year, month(SaleDate) as sale_month, count(*) from sales
where boxes > 1000 group by  sale_year,sale_month;

-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
SELECT year(SaleDate) as sale_year, month(s.SaleDate) as sale_month,
Case when sum(s.boxes)>1 then "yes" else "NO" END as status from sales s
left join products pr on s.PID=pr.PID
left join geo g on s.GeoID=g.GeoID
where pr.product="After Nines" and g.Geo="New Zealand" 
group by sale_year,sale_month order by 1;

-- India or Australia? Who buys more chocolate boxes on a monthly basis?
select year(s.SaleDate) as sale_year, month(s.SaleDate) as sale_month,
sum(CASE When g.Geo="India" then boxes else 0 END)  as "India_boxes",
sum(CASE When g.Geo="Australia" then s.boxes else 0 END)  as "Australia_boxes" 
from sales s
left join products pr on s.PID=pr.PID
left join geo g on s.GeoID=g.GeoID
group by sale_year, sale_month;
