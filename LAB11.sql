-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*) as num_copies
from sakila.inventory 
where film_id = (select film_id from sakila.film where title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
select title, length from sakila.film 
where length > (select avg(length) as avg_length from sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select A.title, C.first_name, C.last_name 
from sakila.film A
left join sakila.film_actor B ON A.film_id = B.film_id
left join sakila.actor C on B.actor_id = C.actor_id
where A.title = 'Alone Trip';

SELECT A.title, C.first_name, C.last_name 
FROM sakila.film A 
JOIN sakila.film_actor B USING(film_id) 
JOIN sakila.actor C using(actor_id) WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT C.name, B.title  
FROM sakila.film_category A 
JOIN sakila.film B USING(film_id) 
JOIN sakila.category C using(category_id)
WHERE name = (SELECT name FROM sakila.category WHERE name = 'Family');


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT A.first_name, A.last_name, A.email  
FROM sakila.customer A
JOIN sakila.address B using(address_id)
JOIN sakila.city C using(city_id)
JOIN sakila.country D using(country_id)
WHERE country = (SELECT country FROM sakila.country WHERE country = 'Canada');

SELECT A.first_name, A.last_name, A.email  
FROM sakila.customer A
JOIN sakila.address B using(address_id)
JOIN sakila.city C using(city_id)
JOIN sakila.country D using(country_id)
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT title FROM sakila.film C 
JOIN (
  SELECT a.first_name, a.last_name, COUNT(film_id) AS num_films
  FROM sakila.actor A
  JOIN sakila.film_actor B USING(actor_id)
  GROUP BY actor_id
  ORDER BY num_films DESC
) sub1
WHERE num_films = (
  SELECT MAX(num_films) 
  FROM (
    SELECT a.first_name, a.last_name, COUNT(film_id) AS num_films
    FROM sakila.actor A
    JOIN sakila.film_actor B USING(actor_id)
    GROUP BY actor_id
  ) sub2
);

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the 
-- largest sum of payments

SELECT title FROM sakila.film C 
JOIN (
  SELECT a.customer_id, COUNT(a.amount) AS TotPaid
  FROM sakila.payment A
  JOIN sakila.rental B USING(customer_id)
  JOIN sakila.inventory C using(inventory_id)
  GROUP BY customer_id
  ORDER BY TotPaid DESC
) sub1
WHERE TotPaid = (
  SELECT MAX(TotPaid) 
  FROM (
	SELECT a.customer_id, COUNT(a.amount) AS TotPaid
	FROM sakila.payment A
	JOIN sakila.rental B USING(customer_id)
	JOIN sakila.inventory C using(inventory_id)
	GROUP BY customer_id
  ) sub2
);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT distinct customer_id, TotPaid FROM sakila.film C 
JOIN (
  SELECT a.customer_id, COUNT(a.amount) AS TotPaid
  FROM sakila.payment A
  JOIN sakila.rental B USING(customer_id)
  JOIN sakila.inventory C using(inventory_id)
  GROUP BY customer_id
  ORDER BY TotPaid DESC
) sub1
WHERE TotPaid > (
  SELECT avg(TotPaid) 
  FROM (
	SELECT a.customer_id, COUNT(a.amount) AS TotPaid
	FROM sakila.payment A
	JOIN sakila.rental B USING(customer_id)
	JOIN sakila.inventory C using(inventory_id)
	GROUP BY customer_id
  ) sub2
);