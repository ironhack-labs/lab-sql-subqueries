-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*)
FROM inventory
INNER JOIN film
	ON inventory.film_id = film.film_id
WHERE title = "Hunchback Impossible"
;

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (
	SELECT AVG(length)
    FROM film
    )
;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
	ON actor.actor_id = film_actor.actor_id
INNER JOIN film
	ON film_actor.film_id = film.film_id
WHERE title =  "Alone Trip"
;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT film_actor.actor_id
    FROM film_actor
    WHERE film_actor.film_id = (
        SELECT film.film_id
        FROM film
        WHERE film.title = 'Alone Trip'
    )
)
;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title
FROM film
INNER JOIN film_category
	ON film.film_id = film_category.film_id
INNER JOIN category
	ON film_category.category_id = category.category_id
WHERE category.name = "Family"
;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
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
            WHERE country = "Canada"
            )
		)
	)
;

SELECT first_name, last_name, email
FROM customer
INNER JOIN address
	ON customer.address_id = address.address_id
INNER JOIN city
	ON address.city_id = city.city_id
INNER JOIN country
	ON city.country_id = country.country_id
WHERE country = "Canada"
;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT first_name, last_name, COUNT(film_id) AS film_count
FROM actor
INNER JOIN film_actor
	ON actor.actor_id = film_actor.actor_id
GROUP BY last_name, first_name
ORDER BY film_count DESC
LIMIT 1
;
        
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title
FROM film
INNER JOIN inventory
	ON film.film_id = inventory.film_id
INNER JOIN rental
	ON inventory.inventory_id = rental.inventory_id
WHERE customer_id = (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	ORDER BY SUM(amount) DESC
	LIMIT 1
	)
;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, total_amount_spent
FROM (
	SELECT customer_id, SUM(amount) AS total_amount_spent
	FROM payment
	GROUP BY customer_id
    ) AS amount_per_customer
WHERE total_amount_spent > (
	SELECT AVG(total_amount_spent)
	FROM (
		SELECT SUM(amount) AS total_amount_spent
		FROM payment
		GROUP BY customer_id
        ) AS total_avg
    )
;