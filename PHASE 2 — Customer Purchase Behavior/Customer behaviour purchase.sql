/*
	Customer Purchase Behavior
	Understand:
		How often customers buy
		How much they spend
		Who your best customers are
*/

--Total number of orders per customer

select 
CustomerID,
count(*) as total_orders
from Sales.SalesOrderHeader
group by CustomerID
Order by total_orders desc

/*
	Varying purchase frequency of customers
*/

-- Average Order Value (AOV) per customer

select 
CustomerID,
count(*) as total_orders,
cast(sum(TotalDue) as numeric) as total_revenue,
round(avg(TotalDue),2) as average_order_value
from Sales.SalesOrderHeader
group by CustomerID
Order by average_order_value desc

/*
	4 orders lead to 606k means bulk orders or premium purchasing behaviour.
*/

--Top 10 customers by total revenue

select Top 10
CustomerID,
sum(TotalDue) as total_revenue
from Sales.SalesOrderHeader
group by CustomerID
order by total_revenue desc

--Revenue is concentrated among a small group of high-value customers

-----------------
--Customer Distribution by Order Frequency


with orders as(
-- cte to calculate numbers of orders placed by each customers
select 
	CustomerID,
	count(*) as total_orders
from Sales.SalesOrderHeader
Group by CustomerID
)
select 
		order_category,
		count(*) as number_of_customers
from (
select
		Case 
		when total_orders = 1 then '1 Order'
		when total_orders = 2 then '2 Orders'
		when total_orders >2 then '3+ Orders'
		end as order_category
		from orders
		-- subquery to avoid repetation of ordercartegory in group by clause
		)t
group by order_category

/*
	 large number of customers fall into 1 order category opportunities to increase retention
*/

--Top customers by both frequency AND value

select 
CustomerID,
Count(*) as total_orders,
sum(TotalDue) as total_revenue
from Sales.SalesOrderHeader
group by CustomerID
order by  total_orders desc, total_revenue desc