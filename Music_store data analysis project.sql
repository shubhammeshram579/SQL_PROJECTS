use music

SELECT * FROM album


/* Q1: Who is the senior most employee based on job title? */

SELECT top 1 employee_id,first_name,last_name,title,levels FROM employee
ORDER BY levels desc

/* Q2: Which countries have the most Invoices? */

SELECT billing_country,count(billing_country) as counts
FROM invoice
GROUP BY billing_country 
ORDER BY counts desc

/* Q3: What are top 3 values of total invoice? */

SELECT top 3 total FROM invoice
ORDER BY total desc


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT * FROM invoice

SELECT billing_city ,sum(total) as total
FROM invoice
GROUP BY billing_city
ORDER BY total desc

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT * FROM invoice
SELECT * FROM customer

SELECT top 1 c.customer_id,c.first_name,c.last_name,i.billing_city,sum(total) as total
FROM customer c
JOIN invoice i
on c.customer_id = i.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name,i.billing_city
ORDER BY total desc


/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ORDERed alphabetically BY email starting with A. */

/*Method 1 */


SELECT * FROM customer
SELECT * FROM invoice
SELECT * FROM invoice_line
SELECT * FROM track
SELECT * FROM genre


SELECT c.first_name,c.last_name,c.email
FROM customer c
JOIN invoice i on c.customer_id = i.customer_id
JOIN invoice_line il on il.invoice_id = i.invoice_id
JOIN track t on t.track_id = il.track_id
JOIN genre g on g.genre_id = t.genre_id
where g.name like 'Rock'
GROUP BY c.first_name,c.last_name,c.email
ORDER BY c.email

/* second method*/

SELECT c.first_name,c.last_name,c.email
FROM customer c
JOIN invoice i on c.customer_id = i.customer_id
JOIN invoice_line il on il.invoice_id = i.invoice_id
where il.track_id in (SELECT t.track_id FROM track t JOIN genre g
                      on t.genre_id = g.genre_id where g.name like 'Rock')
GROUP BY c.first_name,c.last_name,c.email
ORDER BY c.email

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT * FROM track
SELECT * FROM album
SELECT * FROM genre
SELECT * FROM artist


SELECT top 10 ar.artist_id,ar.name,count(ar.artist_id) as number_of_songs
FROM track t
JOIN album a on a.album_id = t.album_id
JOIN artist ar on ar.artist_id = a.artist_id
JOIN genre g on g.genre_id = t.genre_id
where g.name like 'Rock'
GROUP BY ar.artist_id,ar.name
ORDER BY number_of_songs desc


/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. ORDER BY the song length with the longest songs listed first. */

SELECT name , milliseconds 
FROM track
where milliseconds > (SELECT avg(milliseconds) as avrage_song_lenths
FROM track )
ORDER BY milliseconds;




/* Question Set 3 - Advance */

/* Q1: Find how much amount spent BY each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this BY the price
for each artist. */

SELECT * FROM customer
SELECT * FROM invoice
SELECT * FROM invoice_line;
SELECT * FROM track;
SELECT * FROM album;
SELECT * FROM artist;

with best_seling_artist as (
      SELECT top 1 artist.artist_id as artist_id ,
      artist.name as astist_name,sum(invoice_line.unit_price * invoice_line.quantity) as total_span
      FROM invoice_line
      JOIN track on track.track_id = invoice_line.track_id
      JOIN album on album.album_id = track.album_id
      JOIN artist on artist.artist_id = album.artist_id
      GROUP BY  artist.artist_id,artist.name
      ORDER BY total_span desc
)
SELECT customer.customer_id,customer.first_name,customer.last_name,best_seling_artist.astist_name,
sum(invoice_line.unit_price * invoice_line.quantity) as total_span
FROM invoice
JOIN customer on customer.customer_id = invoice.customer_id
JOIN invoice_line on invoice_line.invoice_id = invoice.invoice_id
JOIN track on track.track_id = invoice_line.track_id
JOIN album on album.album_id = track.album_id
JOIN best_seling_artist on best_seling_artist.artist_id = album.artist_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name,best_seling_artist.astist_name
ORDER BY total_span desc;




/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */

WITH popular_genre AS 
(
SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
	/*ORDER BY 2 ASC ,1 DESC*/

)
SELECT * FROM popular_genre WHERE RowNo <= 1

with popular_country as (
SELECT count(invoice_line.quantity) as purchase,customer.country,genre.name,genre.genre_id,
ROW_NUMBER() over(partition BY customer.country ORDER BY count(invoice_line.quantity)desc) as Ro_number
FROM customer
JOIN invoice on invoice.customer_id = customer.customer_id
JOIN invoice_line on invoice_line.invoice_id = invoice.invoice_id
JOIN track on track.track_id = invoice_line.track_id
JOIN genre on genre.genre_id = track.genre_id
GROUP BY customer.country,genre.name,genre.genre_id
)
SELECT * FROM popular_country where Ro_number <=1;


/*
With per_co as (
SELECT count(*) as purchase,customer.country,genre.name,genre.genre_id
FROM customer
JOIN invoice on invoice.customer_id = customer.customer_id
JOIN invoice_line on invoice_line.invoice_id = invoice.invoice_id
JOIN track on track.track_id = invoice_line.track_id
JOIN genre on genre.genre_id = track.genre_id
GROUP BY customer.country,genre.name,genre.genre_id
ORDER BY customer.country

),
max_genre_per_country as (SELECT max(purchase) as max_genre_purchase ,country
FROM sales_per_country
GROUP BY country
ORDER BY country 

SELECT sales_per_country.*
FROM sales_per_country  */


/*

WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

JOIN max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchase = max_genre_per_country.max_genre_purchase

*/




/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

/* Method 1: using CTE */


WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY customer.customer_id,first_name,last_name,billing_country
)
SELECT * FROM Customter_with_country WHERE RowNo <= 1


with Customter_with_country as (
SELECT customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total) as total_spending,
ROW_NUMBER() over(partition BY invoice.billing_country ORDER BY sum(invoice.total) desc) as row_no
FROM customer
JOIN invoice on invoice.customer_id = customer.customer_id
GROUP BY customer.customer_id,customer.first_name,customer.last_name,invoice.billing_country
)

SELECT * FROM Customter_with_country where row_no <=1




