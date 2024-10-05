-- Add you solution queries below:

USE sakila;

SELECT*
FROM sakila.film;

-- 1. How many copies of the film "Hunchback Impossible" exist in the inventory system?
SELECT COUNT(*) AS total_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all films.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (SELECT film_id FROM film WHERE title = 'Alone Trip')
);

-- 4. Identify all movies categorized as family films.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')
    )
);

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country co ON ct.country_id = co.country_id
WHERE co.country = 'Canada';

-- 6. Which are films starred by the most prolific actor?
WITH prolific_actor AS (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
)
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (SELECT actor_id FROM prolific_actor);

-- 7. Films rented by the most profitable customer.
WITH top_customer AS (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
)
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (SELECT customer_id FROM top_customer);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average total amount spent by each client.
WITH customer_spending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
average_spent AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM customer_spending
)
SELECT customer_id, total_spent
FROM customer_spending
WHERE total_spent > (SELECT avg_spent FROM average_spent);