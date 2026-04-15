/*
	Basic Customer Exploration
	Understand customer base size + growth
*/

-- Total number of customers

select
count(*) as TotalCustomers
from Sales.Customer;


--How many customers have placed at least 1 order? (Active Customers)

select 
Count(distinct CustomerID) as Active_customers
from Sales.SalesOrderHeader;


--Number of customers acquired each year
with first_order as(
-- finding customer first_order
		select 
		CustomerID,
		MIN(OrderDate) as first_order
		from Sales.SalesOrderHeader
		group by CustomerID
)
-- total customers per year
select 
Year(first_order) as Acquisitionyear,
count(*) as total_customers
from first_order
group by Year(first_order)
order by Acquisitionyear

/*
		customer boom in 2013
		also year 2011 and 2014 are not full years 
*/


-- Top countries by number of customers

select 
terr.Name as Region,
count( distinct CustomerID ) as total_customers
from Sales.SalesOrderHeader odrhdr
join Sales.SalesTerritory terr
on odrhdr.TerritoryID = terr.TerritoryID
group by odrhdr.TerritoryID,terr.Name
Order by total_customers desc

-- strong customer base in region 