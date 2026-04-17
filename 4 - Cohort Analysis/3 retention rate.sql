
with cohort as(
select 
	CustomerID,
	Min(OrderDate) over(Partition by CustomerID) as first_order_date,
	OrderDate
from Sales.SalesOrderHeader
),
 cohort_count as(
select 
Year(first_order_date) as cohort_year,
YEAR(OrderDate) as order_year,
count(Distinct CustomerID) as total_customers
from cohort
group by 
		Year(first_order_date),
		Year(OrderDate)
		),
		 cohort_size as 
		(
select 
cohort_year,
order_year,
total_customers as cohort_total_customer
from cohort_count
where cohort_year = order_year
)
select 
cc.cohort_year,
cc.order_year,
cc.total_customers,
cs.cohort_total_customer,
round((1.0 *cc.total_customers / cs.cohort_total_customer),2) as retention_rate
from cohort_size cs
join cohort_count cc
on cs.cohort_year = cc.cohort_year
order by
	cc.cohort_year,
	cc.order_year
