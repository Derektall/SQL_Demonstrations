--Demonstrating different types of joins using the Chinook database (sample data base based on data from digital media store)

USE Chinook


--Finding all the tracks that have been purchased
SELECT art.Name AS Artist, t.Name AS Track
FROM Artist art JOIN Album alb
ON alb.ArtistId=art.ArtistId JOIN Track t
ON t.AlbumID=alb.AlbumId JOIN InvoiceLine il
ON il.TrackId=t.TrackId JOIN Invoice i
ON i.InvoiceId=il.InvoiceId
GROUP BY art.Name, t.Name

--Now finding all the tracks that have NOT been purchased (using Left Join)
SELECT art.Name AS Artist, t.Name AS Track
FROM Artist art JOIN Album alb
ON alb.ArtistId=art.ArtistId JOIN Track t
ON t.AlbumID=alb.AlbumId LEFT JOIN InvoiceLine il
ON il.TrackId=t.TrackId 
WHERE il.TrackId IS NULL 
GROUP BY art.Name, t.Name

--Finding the hierarchichal structure of the employees using a self join
Select m.FirstName+''+m.LastName AS Manager, e.FirstName+''+e.LastName AS Employee
FROM Employee e
JOIN Employee m ON m.EmployeeID=e.ReportsTo
ORDER BY Manager

--We can also use a Cross Join to list all the Tracks from each Artist (returns Cartesian Product)

Select art.Name As Artist, t.Name AS Track
FROM Artist art
CROSS JOIN Track t



