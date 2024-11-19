USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS copies
FROM inventory
WHERE film_id = (
  SELECT film_id
  FROM film
  WHERE title = 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
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

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title 
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = 8
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = 20
    )
);

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT film.title, COUNT(film_actor.actor_id) AS appearances
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT film_actor.actor_id
    FROM film_actor
    GROUP BY film_actor.actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY film.title;


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie
-- the customer that has made the largest sum of payments
SELECT film.title, max_payment.total_payment
FROM film
INNER JOIN (
    SELECT inventory.film_id, payment.customer_id, MAX(payment.amount) as total_payment
    FROM rental
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.customer_id = payment.customer_id
    GROUP BY inventory.film_id, payment.customer_id
    ORDER BY total_payment DESC
    LIMIT 5
) max_payment ON film.film_id = max_payment.film_id;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT customer_id, SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS avg_payments
) ORDER BY SUM(amount) DESC;