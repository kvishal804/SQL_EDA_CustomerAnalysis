--First Purchase Year

select 
CustomerID,
OrderDate,
ROW_NUMBER() over(Partition by CustomerID order by OrderDate) as rk
from Sales.SalesOrderHeader;

--Track Customer Activity by Cohort Year/ first_order_year
select  
CustomerID,
YEAR(MIN(OrderDate) OVER (PARTITION BY CustomerID)) first_order_year,
Year(OrderDate) as OrderYear
from Sales.SalesOrderHeader;





