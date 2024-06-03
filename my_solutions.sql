USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system? --
SELECT COUNT(*) AS copies_available
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films. --
SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);

-- Use subqueries to display all actors who appear in the film Alone Trip. --
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor 
WHERE film_id = 
(SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- Identify all movies categorized as family films. --
SELECT f.title, c.name AS category
FROM film f
JOIN 
film_category fc ON f.film_id = fc.film_id
JOIN 
category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';


-- Get name and email from customers from Canada using subqueries. --
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address
WHERE city_id IN (SELECT city_id FROM city
WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')));


-- Which are films starred by the most prolific actor? --
SELECT actor_id, f.title
FROM film f
JOIN 
film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM (SELECT actor_id, COUNT(*) AS film_count
FROM film_actor GROUP BY actor_id
ORDER BY film_count DESC LIMIT 1) AS most_prolific_actor);

-- Films rented by most profitable customer. --
SELECT f.title
FROM film f
JOIN 
inventory i ON f.film_id = i.film_id
JOIN 
rental r ON i.inventory_id = r.inventory_id
JOIN 
payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (SELECT customer_id FROM 
(SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1) AS most_profitable_customer);


-- Get the client_id and the total_amount_spent of those clients who --
-- spent more than the average of the total_amount spent by each client. --
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (SELECT AVG(total_payments)
FROM (SELECT customer_id, SUM(amount) AS total_payments
FROM payment GROUP BY customer_id) AS avg_payments);
