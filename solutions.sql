-- Add you solution queries below:
/* How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT COUNT(*) AS TOTAL_COPIES
FROM sakila.film f
JOIN sakila.inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

/* List all films whose length is longer than the average of all the films. */
SELECT f.title, f.length
FROM sakila.film f
WHERE f.length > (SELECT AVG(length) FROM sakila.film);

/* Use subqueries to display all actors who appear in the film Alone Trip. */
SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor fa
    JOIN sakila.film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);

/* Sales have been lagging among young families, 
and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films. */
SELECT f.title
FROM sakila.film f
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/* Get name and email from customers from Canada using subqueries. 
Do the same with joins. 
Note that to create a join, you will have to identify the correct tables with their primary keys 
and foreign keys, that will help you get the relevant information. */

/* Subqueried */ 
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer c
WHERE c.address_id IN (
    SELECT a.address_id
    FROM sakila.address a
    WHERE a.city_id IN (
        SELECT ci.city_id
        FROM sakila.city ci
        WHERE ci.country_id = (
            SELECT co.country_id
            FROM sakila.country co
            WHERE co.country = 'Canada'
        )
    )
);

/* Joined */
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer c
JOIN sakila.address a ON c.address_id = a.address_id
JOIN sakila.city ci ON a.city_id = ci.city_id
JOIN sakila.country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

/* Which are films starred by the most prolific actor? 
Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor 
and then use that actor_id to find the different films that he/she starred. */
SELECT f.title
FROM sakila.film_actor fa
JOIN sakila.film f ON fa.film_id = f.film_id
WHERE fa.actor_id = (
    SELECT fa.actor_id
    FROM sakila.film_actor fa
    GROUP BY fa.actor_id
    ORDER BY COUNT(fa.film_id) DESC
    LIMIT 1
);

/* Films rented by most profitable customer. You can use the customer table 
and payment table to find the most profitable customer 
ie the customer that has made the largest sum of payments */
SELECT f.title
FROM sakila.rental r
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON i.film_id = f.film_id
WHERE r.customer_id = (
    SELECT p.customer_id
    FROM sakila.payment p
    GROUP BY p.customer_id
    ORDER BY SUM(p.amount) DESC
    LIMIT 1
);

/* Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. */
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(amount) AS total_spent
        FROM sakila.payment
        GROUP BY customer_id
    ) AS avg_spent
);