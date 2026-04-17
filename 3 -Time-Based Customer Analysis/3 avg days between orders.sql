-- Average Time Between Customer Orders
with avg_od as 
(  -- finding days sinc last order
	select 
	CustomerID,
	OrderDate  as CurrentOrder,
	lag(OrderDate) over(Partition by CustomerID order by OrderDate) as lastorder,
	datediff(DAY,lag(OrderDate) over(Partition by CustomerID order by OrderDate),OrderDate) daysincelastorder
	from Sales.SalesOrderHeader
)
select 
CustomerID,
avg(daysincelastorder) as avgDaybetweenorders
from avg_od
-- to remove customer who ordered once only
where daysincelastorder is not null  
Group by CustomerID
Order by avgDaybetweenorders desc

