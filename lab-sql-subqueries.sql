use sakila;

-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS copies
FROM inventory
JOIN film USING(film_id)
WHERE film.title = 'Hunchback Impossible';

-- 2.List all films whose length is longer than the average of all the films.
SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(first_name, ' ', last_name) AS actor
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id = (
SELECT film_id
FROM film
WHERE title = 'Alone Trip')
);

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film 
WHERE film_id IN (
SELECT film_id 
FROM film_category 
WHERE category_id = (
SELECT category_id 
FROM category 
WHERE name = 'Family')
);

-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- using subqueries
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

-- using joins
SELECT first_name, last_name, email 
FROM customer 
JOIN address USING(address_id) 
JOIN city USING(city_id) 
JOIN country USING(country_id) 
WHERE country = 'Canada';

-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT f.title 
FROM film f 
JOIN film_actor fa USING(film_id) 
JOIN (
SELECT actor_id, COUNT(*) AS num_films 
FROM film_actor 
GROUP BY actor_id 
ORDER BY num_films DESC 
LIMIT 1
) a ON fa.actor_id = a.actor_id;

-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT f.title 
FROM film f 
JOIN inventory i USING(film_id) 
JOIN rental r USING(inventory_id) 
JOIN (
SELECT customer_id, SUM(amount) AS total_payments 
FROM payment 
GROUP BY customer_id 
ORDER BY total_payments DESC 
LIMIT 1
) c ON r.customer_id = c.customer_id;

-- 8.Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT c.customer_id, SUM(p.amount) AS total_amount_spent 
FROM customer c 
JOIN payment p USING(customer_id) 
GROUP BY c.customer_id 
HAVING total_amount_spent > (
SELECT AVG(total_amount_spent) 
FROM (
SELECT SUM(amount) AS total_amount_spent  
FROM payment 
GROUP BY customer_id
) AS t
);