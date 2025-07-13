-- Add you solution queries below:
-- 1. How many copies of the film 'Hunchback Impossible' exist in the inventory system?
SELECT COUNT(*) AS copies_count
FROM inventory
WHERE film_id = (
    SELECT film_id 
    FROM film 
    WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
SELECT film_id, title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
)
ORDER BY length DESC;

-- 3. Use subqueries to display all actors who appear in the film 'Alone Trip'.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
)
ORDER BY last_name, first_name;

-- 4. Identify all movies categorized as family films.
SELECT film_id, title, description
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
)
ORDER BY title;

-- 5a. Get name and email from customers from Canada using subqueries.
SELECT customer_id, first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
)
ORDER BY last_name, first_name;

-- 5b. Get name and email from customers from Canada using joins.
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada'
ORDER BY c.last_name, c.first_name;

-- 6. Which are films starred by the most prolific actor?
WITH most_prolific_actor AS (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
)
SELECT f.film_id, f.title, f.description
FROM film f
WHERE f.film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
)
ORDER BY f.title;

-- 7. Films rented by most profitable customer.
SELECT DISTINCT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
)
ORDER BY f.title;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than 
SELECT customer_id AS client_id, 
       SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_per_customer)
    FROM (
        SELECT customer_id, SUM(amount) AS total_per_customer
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_amount_spent DESC;
