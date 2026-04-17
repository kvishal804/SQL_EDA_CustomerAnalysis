-- check retention of customers by each year
--How many customers from a cohort are active in each future year

WITH cohort AS (
    SELECT  
        CustomerID,
        MIN(OrderDate) OVER (PARTITION BY CustomerID) AS FirstOrderDate,
        OrderDate
    FROM Sales.SalesOrderHeader
)
SELECT 
    YEAR(FirstOrderDate) AS cohort_year,
    YEAR(OrderDate) AS order_year,
    COUNT(DISTINCT CustomerID) AS TotalCustomers
FROM cohort
GROUP BY 
    YEAR(FirstOrderDate),
    YEAR(OrderDate)
ORDER BY 
    cohort_year, order_year;


    ----------------------------------
    --Count Customers by CohortYear and OrderYear
with cohort as (
    select  
    CustomerID,
    YEAR(MIN(OrderDate) OVER (PARTITION BY CustomerID)) cohort_year,
    Year(OrderDate) as order_year
    from Sales.SalesOrderHeader
)
select 
    cohort_year,
    order_year,
    count(Distinct CustomerID)  as total_customers
    from cohort
    Group by 
        cohort_year,
        order_year
    order by 
    cohort_year, order_year;

