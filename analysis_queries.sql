-- Question Set 1 - Easy

--  Q1: Who is the senior most employee based on job title? 

select top (1) * from employee order by levels desc;

-- Q2: Which countries have the most Invoices?

select top (1) count(*) as country_count, billing_country from invoice 
group by billing_country order by country_count desc;

-- Q3: What are top 3 values of total invoice?

select top(3) * from invoice order by total desc;

-- Q4: Which city has the best customers? We would like to throw
-- a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest
-- sum of invoice totals. 
-- Return both the city name & sum of all invoice totals 

select sum(total) as invoice_total , billing_city from invoice
group by billing_city order by invoice_total desc;

-- Q5: Who is the best customer? The customer who has
-- spent the most money will be declared the best customer.
-- Write a query that returns the person who has spent the 
-- most money.


select top 1 c.customer_id, first_name, last_name,
sum(invoice.total) as total_spending
from customer as c
join invoice on c.customer_id = invoice.customer_id
group by c.customer_id, first_name, last_name
order by total_spending desc;

-- Question Set 2 - Moderate 

-- Q1: Write query to return the email, first name,
-- last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email
-- starting with A. 

select distinct c.email , c.first_name, c.last_name from customer as c
join invoice as iv on c.customer_id = iv.customer_id
join invoice_line on iv.invoice_id = invoice_line.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'rock'
order by email;

-- 2nd method
select distinct c.email , c.first_name, c.last_name
from customer as c
join invoice on invoice.customer_id = c.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where invoice_line.track_id in 
(select  track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'rock');


-- Q2: Let's invite the artists who have written the most
-- rock music in our dataset. 
-- Write a query that returns the Artist name and 
-- total track count of the top 10 rock bands.

select top 10 
    artist.artist_id, 
    artist.name, 
    count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id, artist.name
order by number_of_songs desc;

-- Q3: Return all the track names that have a song length
-- longer than the average song length. 
-- Return the Name and Milliseconds for each track. 
-- Order by the song length with the longest songs 
-- listed first. 

select distinct name, milliseconds from track where milliseconds > 
(select AVG(milliseconds) from track)
order by milliseconds desc;

-- Question Set 3 - Advanced

-- Q1: Find how much amount spent by each customer on 
-- artists? Write a query to return customer name, 
-- artist name and total spent

with cte as (
	select top 1 artist.artist_id as artist_id, artist.name as artist_name, sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by artist.artist_id, artist.name
	order by total_sales desc

)
select c.customer_id, c.first_name, c.last_name, cte.artist_name,
sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join cte on cte.artist_id = alb.artist_id
group by c.customer_id, c.first_name, c.last_name, cte.artist_name
order by amount_spent desc;

-- Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each
-- country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.
with cte as (
select g.name , c.country, count(il.quantity) as purchases,
DENSE_RANK() over (partition by c.country order by count(g.name) desc)
as d_rank from customer as c
join invoice as i on c.customer_id = i.customer_id
join invoice_line as il on i.invoice_id = il.invoice_id
join track as t on il.track_id = t.track_id
join genre as g on t.genre_id = g.genre_id
group by c.country, g.name
)
select * from cte where d_rank = 1

-- orignal ans
WITH popular_genre AS 
(
    SELECT 
        COUNT(il.quantity) AS purchases,
        c.country,
        g.name AS genre_name,
        g.genre_id, 
        ROW_NUMBER() OVER (
            PARTITION BY c.country 
            ORDER BY COUNT(il.quantity) DESC
        ) AS RowNo
    FROM invoice_line il
    JOIN invoice i ON il.invoice_id = i.invoice_id
    JOIN customer c ON i.customer_id = c.customer_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY c.country, g.name, g.genre_id
)
SELECT * 
FROM popular_genre 
WHERE RowNo = 1
ORDER BY country;


-- Q3: Write a query that determines the customer that has spent the 
-- most on music for each country. 
-- Write a query that returns the country along with the top customer 
-- and how much they spent. 
-- For countries where the top amount spent is shared, provide all 
-- customers who spent this amount

with cte as(
select i.customer_id , c.first_name , c.last_name , billing_country , sum(total) as total1,
DENSE_RANK () over (partition by billing_country order by sum(total) desc) as d_rank
from invoice as i
join customer as c on i.customer_id = c.customer_id
group by i.customer_id, billing_country, c.first_name, c.last_name
)
select * from cte where d_rank = 1;
