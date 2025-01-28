create database adventure_works;
use adventure_works;

select * from fact_internet_sales_new;
select * from factinternetsales;

create table factnew as
select * from fact_internet_sales_new
union all
select * from factinternetsales;
select * from factnew;

-- Example for SQL Server

alter table factnew modify column OrderDateKey date;
alter table factnew modify column DueDateKey date;
alter table factnew modify column ShipDateKey date;
alter table factnew drop column CarrierTrackingNumber;
alter table factnew drop column CustomerPONumber;
alter table factnew rename column ProductStandardCost to Production_cost;

set sql_safe_updates=0; 
alter table factnew add column year int;
update factnew set year=year(orderdatekey);
alter table factnew add column month_name varchar(255);
update factnew set month_name=monthname(orderdatekey);
alter table factnew add column quarter int;
update factnew set quarter=quarter(orderdatekey);
alter table factnew drop column monthname;
alter table factnew add column day_name varchar(255);
update factnew set day_name=dayname(orderdatekey);

select * from dimcustomer;

alter table dimcustomer add column Name1 varchar(50) after Title;
update dimcustomer set name1=concat(FirstName,' ',MiddleName,' ',LastName);
alter table dimcustomer drop column FirstName;
alter table dimcustomer drop column MiddleName;
alter table dimcustomer drop column LastName;
alter table dimcustomer drop column Title;
select * from factnew;

set sql_safe_updates=0; 
alter table factnew add column totalprofit decimal(10,2);
update factnew set totalprofit = SalesAmount - (production_cost + TaxAmt + Freight);
alter table factnew drop column  profit;


-- 1) Total  Salesamount
select round( sum(SalesAmount),2) as sales  from factnew ;

-- 2) Total Profit
select round(sum(totalprofit),2) as profit from factnew;

-- 3) Production cost
select round(sum(production_cost),2) as productioncost from factnew;

-- 4) Tax + freight
select round(sum(taxamt+freight),2) as taxes from factnew;

-- 5) Total Product
select count(EnglishProductName) as product from dimproducts;
select * from  dimproducts;

-- 6) Total customer
select count(distinct CustomerKey) as total_customers from factnew;

-- 7) Sales and Profit by month 
select * from factnew;
select month_name as month,sum(salesamount) as sales,sum(totalprofit) profit from factnew group by month_name order by sales desc;  

-- 8) country wise sales and profit
select b.SalesTerritoryCountry as country,sum(a.SalesAmount) as Sales,sum(a.totalprofit) as Profit from factnew a 
join salesterritory b on a.SalesTerritoryKey=b.SalesTerritoryKey group by b.SalesTerritoryCountry;

-- 9) sales, production cost and profit by year
select year, sum(salesamount) as sales,sum(totalprofit) as profit,sum(production_cost) as production 
from factnew group by year order by year asc;

-- 10) Country Wise Product order and profit
select * from salesterritory;
select * from factnew;
select b.salesterritorycountry as Country, count(a.orderquantity) as ProductOrder from factnew as a 
join salesterritory as b on a.salesterritorykey= b.salesterritorykey- group by b.salesterritorycountry order by ProductOrder desc;

-- 11) Quarter Wise Sales and Profit
select Quarter, Sum(salesamount) Sales, Sum(totalprofit) Profit from factnew group by quarter order by sales desc;

