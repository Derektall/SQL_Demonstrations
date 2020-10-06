--Examples of creating and altering views using Chinook database (sample database simulating data from a digital media store)

Use Chinook

--Looking at the top 20 most popular tracks put in playlists, using a view in order to be able to see most up to date information every week

GO
CREATE VIEW [Popular Playlist Tracks] AS
SELECT TOP 20 art.name as Artist, t.name as TrackName, COUNT(pt.PlaylistId) as PlayCount
FROM Artist art 
JOIN Album alb ON art.ArtistID=alb.ArtistID
JOIN Track t ON t.AlbumID=alb.AlbumID
JOIN PlaylistTrack pt ON pt.TrackID=t.TrackID
GROUP BY art.Name, t.name
Order by PlayCount DESC

Select * From [Popular Playlist Tracks]

--Now we'll Alter the view in order to add a column for the Genre

GO
ALTER VIEW [Popular Playlist Tracks] AS
SELECT TOP 20 art.name as Artist, t.name as TrackName, COUNT(pt.PlaylistId) as PlayCount, g.Name as Genre
FROM Artist art 
JOIN Album alb ON art.ArtistID=alb.ArtistID
JOIN Track t ON t.AlbumID=alb.AlbumID
JOIN Genre g ON g.GenreId=T.GenreId
JOIN PlaylistTrack pt ON pt.TrackID=t.TrackID
GROUP BY art.Name, t.name, g.Name
Order by PlayCount DESC

Select * From [Popular Playlist Tracks]

--We'll also create a view showing the tracks that have sold the most (top 20 again)
GO 
CREATE VIEW [Top 20 Best Selling Tracks] AS
SELECT TOP 20 art.name as Artist, t.Name as TrackName, COUNT(il.InvoiceID) as Sales
FROM Artist art
JOIN Album alb ON art.ArtistId=alb.ArtistId
JOIN Track t ON t.AlbumId=alb.AlbumID 
JOIN InvoiceLine il ON il.TrackId=t.TrackId
GROUP BY art.name, t.name
ORDER BY Sales DESC

Select * FROM [Top 20 Best Selling Tracks]