---------------------------------------------------------------------------------------------------------------------
/*
Time-Based Customer Analysis
	Understand:
		Customer lifecycle
		Repeat behavior
		Purchase timing
		Retention patterns
*/
---------------------------------------------------------------------------------------------------------------------
/*
	Monthly customer acquisition trend
*/
WITH first_order AS (
    SELECT 
        CustomerID,
        OrderDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT 
    YEAR(OrderDate) AS Year,
   -- MONTH(OrderDate) AS Month,
    DATENAME(MONTH, OrderDate) AS MonthName,
    COUNT(*) AS NewCustomers
FROM first_order
WHERE rn = 1
GROUP BY 
    YEAR(OrderDate), 
    MONTH(OrderDate), 
    DATENAME(MONTH, OrderDate)
ORDER BY 
    Year,MONTH(OrderDate);