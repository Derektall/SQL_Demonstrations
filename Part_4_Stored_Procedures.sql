/*These are examples of the use and alteration of stored procedures using the Chinook database 
(A sample database based on data from a digital media store)*/



/*Let's say we check the invoices table frequently to find the Sum of sales (the sum of the Total column).
We can use a stored procedure so we don't have to rewrite the Select statement over and over*/

GO
CREATE PROCEDURE TotalSales
AS
Select SUM(Total) As Total
FROM Invoice

EXEC TotalSales

--If we just want the WeeklySales from the previous week we can also use a stored procedure

SET DATEFIRST 1 --Defining Monday as 1st day of the weekly period

GO
CREATE PROCEDURE WeeklySales
AS
Select SUM(Total) As Total, i.InvoiceDate AS InvoiceDate
FROM Invoice i
WHERE InvoiceDate >= dateadd(day, 1-datepart(dw, getdate()), CONVERT(date,getdate())) --Subtracts number of days to get to beginning of the week
AND InvoiceDate <  dateadd(day, 8-datepart(dw, getdate()), CONVERT(date,getdate())) --Removes time portion of getdate because we want data starting at 12:00AM
GROUP BY i.InvoiceDate

EXEC WeeklySales

