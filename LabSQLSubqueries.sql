-- Lab | SQL Subqueries
-- In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;
SELECT f.title, COUNT(i.inventory_id)
FROM film f 
LEFT JOIN inventory i 
ON f.film_id=i.inventory_id
WHERE f.title ="Hunchback Impossible"
GROUP BY f.title;

-- 2. List all films whose length is longer than the average of all the films.

SELECT AVG(length), length 
FROM film;

SELECT title, length
FROM film 
WHERE length > (SELECT AVG(length)FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM (
	SELECT a.first_name, a.last_name, f.title
	FROM actor a 
	JOIN  film_actor fa
	ON a.actor_id=fa.actor_id
	JOIN film f
	ON f.film_id=fa.film_id
) AS t 
WHERE title ="Alone trip";


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- * Identify all movies categorized as family films.
SELECT f.title, c.name
FROM category c
JOIN film_category fc
ON c.category_id=fc.category_id
JOIN film f 
ON f.film_id=fc.film_id
WHERE c.name="Family";

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT c.first_name, c.last_name, c.email
FROM customer c 
JOIN address a 
ON a.address_id=c.address_id
JOIN city ci
ON ci.city_id=a.city_id
JOIN country co
ON co.country_id=ci.country_id
WHERE co.country="Canada";

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT COUNT(a.actor_id) AS conteo, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa 
ON a.actor_id=fa.actor_id
JOIN film f 
ON f.film_id=fa.film_id
GROUP BY a.actor_id
ORDER BY conteo DESC
LIMIT 1;

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments
SELECT cu.first_name, cu.last_name, SUM(pa.amount) AS gasto_total, cu.customer_id
FROM customer cu
JOIN payment pa 
ON cu.customer_id=pa.customer_id
GROUP BY cu.customer_id
ORDER BY gasto_total DESC
LIMIT 1;

-- 8. Get the client_id and total_amount_spent of those clients who spent more than the avg of the total_amount spent by each client.
SELECT AVG(amount) AS gasto_promedio
FROM payment;

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING AVG(amount) > (SELECT AVG(amount) AS gasto_promedio
FROM payment)
;