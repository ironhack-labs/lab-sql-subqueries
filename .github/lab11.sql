use sakila;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.film_id) 
from sakila.inventory i
join sakila.film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films.
SELECT title
FROM sakila.film
WHERE length > (
  SELECT AVG(length)
  FROM sakila.film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name, a.last_name 
FROM sakila.actor a
WHERE a.actor_id IN (
  SELECT fa.actor_id 
  FROM sakila.film f
  JOIN sakila.film_actor fa ON fa.film_id = f.film_id
  WHERE f.title = 'Alone Trip'
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family 
-- films.
select * from sakila.category;
select f.title , c.name
from sakila.film f
join sakila.film_category fc on f.film_id = fc.film_id
join sakila.category c on fc.category_id = c.category_id
where c.name = 'Family';

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the 
-- correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name, c.email 
FROM sakila.customer c 
JOIN sakila.address a ON a.address_id = c.address_id
JOIN sakila.city ci ON ci.city_id = a.city_id
JOIN sakila.country co ON co.country_id = ci.country_id
WHERE co.country = 'Canada';

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
SELECT address_id
FROM address
WHERE city_id IN (
SELECT city_id
FROM city
WHERE country_id IN (
SELECT country_id
FROM country
WHERE country = 'Canada'
)
)
);

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you
-- will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT f.title
FROM sakila.film f
JOIN sakila.film_actor fa ON f.film_id = fa.film_id 
WHERE fa.actor_id = (
  SELECT fa.actor_id
  FROM sakila.film_actor fa
  GROUP BY fa.actor_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that
-- has made the largest sum of payments.
SELECT f.title
FROM sakila.payment p 
JOIN sakila.customer c ON p.customer_id = c.customer_id 
JOIN sakila.rental r ON p.rental_id = r.rental_id
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON i.film_id = f.film_id
WHERE c.customer_id = (
  SELECT c2.customer_id
  FROM sakila.payment p2 
  JOIN sakila.customer c2 ON p2.customer_id = c2.customer_id 
  GROUP BY c2.customer_id
  ORDER BY SUM(p2.amount) DESC
  LIMIT 1);

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT client_id, total_amount_spent
FROM (
  SELECT customer_id AS client_id, SUM(amount) AS total_amount_spent, AVG(SUM(amount)) OVER () AS avg_total_amount_spent
  FROM sakila.payment
  GROUP BY client_id
) AS t
WHERE total_amount_spent > avg_total_amount_spent;









