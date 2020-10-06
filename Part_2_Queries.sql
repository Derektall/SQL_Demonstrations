/* Below are some examples of the use of stored functions, views, joins, and other queries to find information from a dataset. 
The database is a sample database based on a digital media store */

Use Chinook

-- Looking at all the values in Genre

SELECT * FROM Genre

SELECT * FROM Album

-- Listing All Artists listed under the "Jazz" genre

SELECT Artist.name AS name
FROM Artist Join Album
ON Album.ArtistId=Artist.ArtistId JOIN Track
ON Track.AlbumId=Album.AlbumId JOIN Genre
ON Genre.GenreID=Track.GenreId
Where Genre.name= 'Jazz'
GROUP BY Artist.name

--Looking further to see which Jazz artists have sold the most
SELECT Artist.Name,
	   SUM(InvoiceLine.Quantity*InvoiceLine.UnitPrice) AS Earnings
FROM Artist JOIN Album
ON  Artist.ArtistId=Album.ArtistId JOIN Track
ON Track.AlbumID=Album.AlbumId JOIN Genre
ON Genre.GenreID=Track.GenreId
JOIN InvoiceLine
ON InvoiceLine.TrackID=Track.TrackId
Where Genre.Name = 'Jazz'
GROUP BY Artist.Name
Order By Earnings DESC

-- Looking to see differences in geopgraphic markets by seeing the most popular genre (which has the most quantity of sales)
--Using CTE for readability
WITH PopularGenre AS 
(SELECT count(*) as Sales, g.Name as GenreName, i.BillingCountry as Country
FROM 	InvoiceLine il
		JOIN Track t ON t.TrackId=il.TrackId
		JOIN Genre g ON g.GenreId=t.GenreId
		JOIN Invoice i ON il.InvoiceId=i.InvoiceId
GROUP BY i.BillingCountry, g.GenreId, g.Name)

SELECT pg.Country, pg.GenreName, pg.Sales 
FROM PopularGenre pg
WHERE 	pg.Sales = (SELECT 	max(Sales) FROM PopularGenre
									WHERE pg.Country=Country
									GROUP BY Country
									)
ORDER BY Country

--Finding the customers who spend the most money in each country

With BestCustomers AS
(SELECT SUM(il.Quantity*il.UnitPrice) AS Spending, c.Country AS Country, c.FirstName AS First, c.LastName AS Last,
c.Company as Company, c.State as State, c.Email as Email, c.Phone as Phone
FROM InvoiceLine il
JOIN Invoice i on i.InvoiceId=il.Invoiceid
JOIN Customer c on c.CustomerId=i.CustomerId
GROUP BY c.FirstName,c.LastName,c.Company,c.Email,c.State,c.Country,c.Phone)

Select bc.Country, Spending, bc.First, bc.Last, bc.Company, bc.Email, bc.Phone
FROM BestCustomers bc
Where bc.Spending = (SELECT max(Spending) from BestCustomers
										  WHERE bc.Country=Country
										  GROUP BY Country
										  )
ORDER BY Country

Select * FROM Invoice

--Finding the top 10 most common customer locations (city,country) based on number of sales

SELECT TOP 10 c.City as City, c.Country as Country, COUNT(i.InvoiceID) as Sales
FROM Customer c JOIN Invoice i
ON c.CustomerId=i.CustomerId
GROUP BY City,Country
ORDER BY Sales DESC

--Doing the same as above, but this time finding the percentage each location makes up of total number of sales (not sales amounts)

SELECT TOP 10 c.City as City, c.Country as Country, COUNT(i.InvoiceID) as Sales, COUNT(i.InvoiceID) * 100 / (Select Count(*) From Invoice) as Sales_Percent
FROM Customer c JOIN Invoice i
ON c.CustomerId=i.CustomerId
GROUP BY City,Country
ORDER BY Sales DESC

--Finding the top 20 Artists by sales in 2009, including a percentage of how much each track made up of sales that year

SELECT TOP 20 art.Name AS Artist, COUNT(i.InvoiceID) As Sales, COUNT(i.InvoiceID) * 100 / (Select Count(*) From Invoice) as Sales_Percent
FROM Artist art JOIN Album alb
ON  Art.ArtistId=Alb.ArtistId JOIN Track t
ON t.AlbumID=Alb.AlbumId JOIN InvoiceLine il
ON il.TrackId=t.TrackId JOIN Invoice i
ON i.InvoiceId=il.InvoiceId
WHERE i.InvoiceDate LIKE '%2010%'
GROUP BY art.name
ORDER BY Sales DESC

Select * FROM Invoice

--Finding all invoices where between $10-$15 was spent (including songs, artists, and albums on each invoice)
SELECT i.InvoiceID AS Invoice, i.CustomerId AS Customer,, i.Total AS Total
FROM Artist art JOIN Album alb
ON alb.ArtistId=art.ArtistId JOIN Track t
ON t.AlbumId=alb.AlbumId JOIN InvoiceLine il
ON il.Trackid=t.TrackID JOIN Invoice i
ON i.InvoiceId=il.InvoiceId
WHERE Total BETWEEN 10 AND 15
GROUP BY i.InvoiceID,i.CustomerId, t.name, art.name, i.Total
ORDER BY i.Total DESC

--Finding all Playlists with 5 or more Iron Maiden songs
Select p.PlaylistId, COUNT(art.ArtistID) As TrackCount
FROM Artist art JOIN Album alb
ON alb.ArtistId=art.ArtistId JOIN Track t
ON t.AlbumId=alb.AlbumId JOIN PlaylistTrack pt
ON pt.TrackId=t.TrackId JOIN Playlist p
ON p.PlaylistId=pt.PlaylistId
WHERE art.Name = 'Iron Maiden'
GROUP BY p.PlaylistId
HAVING COUNT(art.ArtistId) >= 5
ORDER BY TrackCount DESC

Select * FROM Artist

--Finding all the artist names that start with the letter B using the LIKE operator

SELECT Artist.Name as Name
FROM Artist
WHERE Artist.Name LIKE 'B%'

--Finding all collaborations ("Feat." somewhere in the name

Select Artist.Name as Name
FROM Artist
WHERE Artist.Name LIKE '%feat%'






