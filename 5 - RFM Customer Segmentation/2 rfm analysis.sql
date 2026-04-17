 select *,
   NTILE(5) OVER (ORDER BY day_sincelastorder ASC)  AS recency_score,
    NTILE(5) OVER (ORDER BY total_orders DESC)        AS frequency_score,
    NTILE(5) OVER (ORDER BY amount_spent DESC)        AS monetary_score
 from 
 (
		 select
		 CustomerID,
		 MAX(OrderDate) as last_order,
		 (select Max(OrderDate) from Sales.SalesOrderHeader)last_orderDate ,
		 count(*) as total_orders,
		 sum(TotalDue)  as amount_spent,
		 DATEDIFF(DAY,MAX(OrderDate),(select Max(OrderDate) from Sales.SalesOrderHeader)) day_sincelastorder
		 from Sales.SalesOrderHeader
		 Group by CustomerID
		
 )t