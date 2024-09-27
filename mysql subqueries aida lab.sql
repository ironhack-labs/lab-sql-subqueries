-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
-- 2 List all films whose length is longer than the average of all the films.
-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
   -- Identify all movies categorized as family films.
-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins.
   --  Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys
      -- that will help you get the relevant information.
-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
   -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- 7 Films rented by most profitable customer. 
    -- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- 8 Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

use sakila;

-- 1
SELECT COUNT(*) AS num_copies FROM inventory JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'Hunchback Impossible';

-- 2
SELECT * FROM film WHERE length > (SELECT AVG(length) FROM film);

-- 3
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
);

-- 4
SELECT title, film_id
FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id IN (SELECT category_id FROM category WHERE name = 'Family'));

-- 5
   -- a
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN 
(SELECT city_id FROM city WHERE country_id IN (SELECT country_id FROM country WHERE country = 'Canada')));
   -- b
SELECT c.first_name, c.last_name, c.customer_id, c.email AS 'CUSTOMER'
FROM sakila.customer AS c
JOIN sakila.country AS co ON c.customer_id = co.country_id
WHERE co.country = 'Canada';

-- 6
SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS num_films
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY num_films DESC
LIMIT 1;

SELECT title, film_id
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    )
);

-- 7    
SELECT 
    f.film_id,
    f.title,
    COUNT(*) AS 'FILM_COPIES'
FROM 
    sakila.film AS f
JOIN 
    sakila.inventory AS i ON i.film_id = f.film_id
WHERE 
    f.title = 'Hunchback Impossible'
GROUP BY 
    f.film_id, f.title;

-- 8
SELECT c.customer_id AS 'client_id'
FROM sakila.customer AS c
JOIN sakila.payment AS p ON c.customer_id = p.customer_id
WHERE p.amount > (SELECT AVG(amount) FROM sakila.payment);
