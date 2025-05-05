Use music_store;

Drop table playlist_tracks;

Select * from employee;
# 1 ) senior most employee based on job title

Select * from employee order by levels desc limit 1;

# 2) Which country has more invoices
select count(*) as c ,billing_country  from invoice group by billing_country order by c desc;

# 3) top 3 values of total invoices
select total from invoice order by total desc limit 3;

# 4) Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
# Write a query that returns one city that has highest sum of invoice total. Return both the city name & sum of all invoices totals?

SELECT 
    billing_city, SUM(total) AS invoice_total
FROM
    invoice
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;

# 5) Who is the best customer? The customer who has spent the most money will be declared the best customer.#
# Write a query that returns the person who has spent the most money?

select * from invoice;

SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name, 
    SUM(invoice.total) AS total 
FROM customer 
JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id, customer.first_name, customer.last_name 
ORDER BY total DESC 
LIMIT 1;


# write a query to return the email, first name , last name & genre of all rock music listners, return the list order alphabatically by emails starts by alter
select * from invoice;
select * from customer;

select distinct email, first_name, last_name from customer 
join invoice on customer.customer_id = invoice.customer_id 
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(select track_id from track join genre on track.genre_id = genre.genre_id 
where genre.name like "Rock")
order by email;

# 2) Lets invite the artist who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count on top 10 rock band

select * from artist;
select * from album2;
select * from track;
select * from genre;

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track 
join album2 on track.album_id = album2.album_id
join artist on album2.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name like "Rock"
group by artist.artist_id, artist.name
order by number_of_songs desc
limit 10;

# Return all the tracker name that have a song length longer than a average song length
# Retrun the name and millisecond for easy track.Order by song length with the longest songs listed firts

Select * from playlist;
select * from playlist_track;
select * from track;

select name, milliseconds from track where milliseconds > (select avg(milliseconds) from track) order by milliseconds desc;

-- Find how much amount spent by each customer on artists?  write a query to return customer name, artist name and total spent?

WITH best_selling_artist AS (
  SELECT artist.artist_id AS artist_id,
         MAX(artist.name) AS artist_name,  -- Using MAX() for non-aggregated column
         SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
  FROM invoice_line
  JOIN track ON track.track_id = invoice_line.track_id
  JOIN album2 ON album2.album_id = track.album_id
  JOIN artist ON artist.artist_id = album2.artist_id
  GROUP BY artist.artist_id
  ORDER BY total_sales DESC
  LIMIT 1
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       bsa.artist_name,
       SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;

