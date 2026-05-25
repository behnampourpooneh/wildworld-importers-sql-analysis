------------------------Porblem Number 01------------------------
SELECT c.CustomerName
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
------------------------Porblem Number 02------------------------
select sc.CustomerName , count(distinct so.OrderID) as [Total number of orders] , 
sum((Quantity * UnitPrice) - TaxAmount) as [Total invoice amount]
from Sales.Customers as sc
join sales.Orders as so
on sc.CustomerID = so.CustomerID
join Sales.Invoices Si
on so.OrderID = Si.OrderID
join sales.InvoiceLines Sil
on Si.InvoiceID = Sil.InvoiceID
group by sc.CustomerName , sc.CustomerID
------------------------Porblem Number 03------------------------
select ws.StockItemName , sol.StockItemID from Warehouse.StockItems ws
left join Sales.OrderLines as sol
on ws.StockItemID = sol.StockItemID
where sol.StockItemID is null
------------------------Porblem Number 04------------------------
with my_cte01 as
(
select YEAR(si.InvoiceDate) as [year] , MONTH(si.InvoiceDate) as [Month],
sum((sil.Quantity * sil.UnitPrice) - sil.TaxAmount) as [Total invoice amount] , 
LAG(sum((sil.Quantity * sil.UnitPrice) - sil.TaxAmount)) over (order by year(si.InvoiceDate), month(si.invoiceDate)) as [Previous Invoice Amount]
from Sales.Invoices as si
join  Sales.InvoiceLines  as sil
on si.InvoiceID = sil.InvoiceID
group by month(si.InvoiceDate) , YEAR(si.InvoiceDate)
) 
select year , Month , [Total invoice amount] ,
(([Total invoice amount] - [Previous Invoice Amount])/[Previous Invoice Amount]) * 100 as [Change amount]
from my_cte01
order by year , Month
------------------------Porblem Number 05------------------------
with my_cte01 as
(
select So.CustomerID ,So.OrderDate as [Order date] , Si.InvoiceDate as [Invoice Date] from Sales.Orders as So
join Sales.Invoices as Si
on So.OrderID = Si.OrderID
)
select CustomerID , AVG(DATEDIFF(day , [Order date] ,[Invoice Date] ))  as [Average time interval] from my_cte01
group by CustomerID
order by [Average time interval]
------------------------Porblem Number 06------------------------
select top 10  Ws.StockItemName , sum(Sil.Quantity) as [Total Quantity]  
 from Sales.Invoices Si
join Sales.InvoiceLines Sil
on Si.InvoiceID = Sil.InvoiceID
join Warehouse.StockItems Ws
on Sil.StockItemID = Ws.StockItemID
group by Ws.StockItemName
order by [Total Quantity] desc
------------------------Porblem Number 07------------------------
select Sc.CustomerID, SC.CustomerName , SUM(Sct.AmountExcludingTax) as [CLV] from Sales.Customers Sc
join Sales.CustomerTransactions Sct
on Sc.CustomerID = Sct.CustomerID
group by Sc.CustomerID ,Sc.CustomerName
order by CLV desc
------------------------Porblem Number 08------------------------
with my_cte01 as 
(
select Sc.CustomerID , Sc.CustomerName ,
DATEDIFF(DAY,  So.OrderDate, Si.InvoiceDate) as [Time Diff] from Sales.Customers as Sc
join Sales.Invoices as Si
on Sc.BillToCustomerID = Si.CustomerID
join Sales.Orders So
on Si.CustomerID = So.CustomerID
where DATEDIFF(DAY,  So.OrderDate, Si.InvoiceDate) >0 
)
select CustomerID , CustomerName , [Time Diff] 
, count([Time Diff]) as [Count Diff] from my_cte01 
group by CustomerID , CustomerName , [Time Diff]
