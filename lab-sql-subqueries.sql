-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
f.title,
count(*) as Total_copies
FROM sakila.film f
JOIN sakila.inventory i using(film_id)
Where f.title = 'Hunchback Impossible';

-- 2.List all films whose length is longer than the average of all the films.
SELECT
title
FROM sakila.film
Where length > (select avg(length) as avg_len from sakila.film)
;

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
first_name,
last_name
FROM sakila.actor
WHERE actor_id in(SELECT
actor_id
FROM sakila.film_actor
WHERE actor_id in (SELECT actor_id
from sakila.film_actor
WHere film_id in( SELECT film_id from sakila.film
WHere title = 'Alone Trip')))
;

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title
FROM sakila.film
WHERE film_id in(
SELECT 
	film_id
FROM sakila.film_category
WHERE category_id in(SELECT 
category_id
FROM sakila.category
WHERE name = 'Family'));


SELECT name
FROM sakila.category
WHERE name = 'Family';
-- 5.Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify 
-- the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id in(SELECT address_id
FROM sakila.address
WHERE city_id in (SELECT city_id
FROM sakila.city
WHERE country_id in(SELECT country_id
FROM sakila.country
WHERE country = 'Canada')));

SELECT 
c.first_name,
c.last_name,
c.email
FROM sakila.customer c
JOIN sakila.address a using(address_id)
JOIN sakila.city ci using(city_id)
JOIN sakila.country co using(country_id)
Where country = 'Canada';



-- 6.Which are films starred by the most prolific actor? Most prolific actor 
-- is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find 
-- the different films that he/she starred.


SELECT
    title
FROM
    sakila.film
WHERE film_id IN (
SELECT film_id
FROM sakila.film_actor
WHERE actor_id = (
SELECT actor_id
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC
LIMIT 1));




-- 7.Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie 
-- the customer that has made the largest sum of payments

SELECT title
FROM sakila.film
WHERE film_id in (
SELECT film_id
FROM sakila.inventory
WHERE inventory_id in (
SELECT inventory_id
FROM sakila.rental
WHERE customer_id = (
SELECT customer_id
FROM sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1)));



-- 8.Get the client_id and the total_amount_spent of those clients who 
-- spent more than the average of the total_amount spent by each client.

SELECT 
	customer_id,
    SUM(amount) AS total_amount_spent
FROM sakila.payment
GROUP BY customer_id
HAVING total_amount_spent > (
 SELECT AVG(total_amount_spent) 
 FROM (
   SELECT customer_id, SUM(amount) AS total_amount_spent
   FROM sakila.payment
   GROUP BY customer_id
 ) AS t
);


