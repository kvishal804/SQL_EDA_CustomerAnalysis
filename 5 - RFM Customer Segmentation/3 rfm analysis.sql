-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------


 With rfm as 
 (
		 select
		 CustomerID,
		 MAX(OrderDate) as last_order,
		 (select Max(OrderDate) from Sales.SalesOrderHeader)last_orderDate ,
		 count(*) as total_orders,
		 sum(TotalDue)  as amount_spent,
		 avg(TotalDue) as avg_spending,
		 DATEDIFF(DAY,MAX(OrderDate),(select Max(OrderDate) from Sales.SalesOrderHeader)) day_sincelastorder
		 from Sales.SalesOrderHeader
		 Group by CustomerID
 ),
 rfm_mid as (
 select *,
	NTILE(5) OVER (ORDER BY day_sincelastorder ASC)  AS recency_score,
    NTILE(5) OVER (ORDER BY total_orders DESC)        AS frequency_score,
    NTILE(5) OVER (ORDER BY amount_spent DESC)        AS monetary_score
 from rfm
 )

 select 
 CustomerID,
 total_orders,
 amount_spent,
 day_sincelastorder,
 avg_spending,
 case
	when recency_score =1 and frequency_score = 1 and monetary_score = 1 then 'Champions'
	when recency_score = 1 and frequency_score != 1 and monetary_score = 1 then 'Loyal Customers'
	when recency_score = 2 then 'Potential Loyalist' 
	when recency_score = 3 and frequency_score = 1 then 'At Risk'
	when recency_score = 3 and frequency_score = 2 then 'Hibernating' 
	else 'Lost' 
	end as Segment
 from rfm_mid