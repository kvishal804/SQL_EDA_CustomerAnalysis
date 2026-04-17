


with first_order as(
-- first order per customer
		select 
		CustomerID,
		min(OrderDate) as first_order_date
		from Sales.SalesOrderHeader
		Group by CustomerID
),
monthly_cus as(
--find wheather customer is new or repeated
select distinct
		Year(OrderDate) as Year,
		Month(OrderDate) as Month,
		DATENAME(MONTH,OrderDate) as months,
		fo.first_order_date,
		case
		when Year(OrderDate) = YEAR(fo.first_order_date)
			and MOnth(OrderDate) = MONTH(fo.first_order_date)
			then 'New'
			else 'Repeat'
		 end as Customer_type
		from Sales.SalesOrderHeader ordhdr
		join first_order fo
		on ordhdr.CustomerID = fo.CustomerID
)
select
	Year,
	months,
	count(case when Customer_type = 'New' then 1 end ) as NewCustomer,
	count(case when Customer_type = 'Repeat' then 1 end ) as RepeatCustomer
from monthly_cus
Group by Year,MONTH,months
Order by Year, Month