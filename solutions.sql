-- Start by selecting the Sakila database
USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Explanation: The inventory table stores the copies of each film. 
-- We use a subquery to fetch the film_id of "Hunchback Impossible" from the film table and count its occurrences in the inventory table.

SELECT COUNT(*) AS number_of_copies
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
-- Explanation: Calculate the average film length using a subquery and then filter films with length above this average.

SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- Explanation: Find the film_id of "Alone Trip," and use it to find the actors from the film_actor table.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

-- 4. Identify all movies categorized as family films.
-- Explanation: Find all film titles associated with the "Family" category using the film_category and category tables.

SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- 5. Get name and email from customers from Canada using subqueries.
-- Explanation: Find the country_id for "Canada" from the country table, 
-- and then fetch the relevant customers based on their address_id linked through the address table.

SELECT first_name, last_name, email
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
);

-- Same query using JOINs
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 6. Which are films starred by the most prolific actor?
-- Explanation: First, identify the actor who has acted in the most films using GROUP BY and ORDER BY. 
-- Then, find all films they starred in using their actor_id.

-- Step 1: Find the most prolific actor
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;

-- Step 2: Find films starred by the most prolific actor
SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1
    )
);

-- 7. Films rented by the most profitable customer.
-- Explanation: Find the customer who made the largest total payments using the payment table, 
-- then list the films they rented using the rental table.

-- Step 1: Find the most profitable customer
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

-- Step 2: Find films rented by the most profitable customer
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average total amount spent by each client.
-- Explanation: First calculate the average total amount spent using GROUP BY. Then filter clients who exceed this average.

SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS avg_spent
);
