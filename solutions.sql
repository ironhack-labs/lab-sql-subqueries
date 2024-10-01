USE sakila;

/* 1. How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT film.title, COUNT(inventory.film_id)
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible"
;


/* 2. List all films whose length is longer than the average of all the films. */
SELECT title, length
FROM film
WHERE length > 
	(SELECT AVG(length) AS average 
	FROM sakila.film)
ORDER BY length DESC
;


/* 3. Use subqueries to display all actors who appear in the film Alone Trip. */
SELECT DISTINCT first_name, last_name
FROM actor
WHERE actor_id IN 
	(SELECT actor_id
	FROM film_actor
	WHERE film_id =
		(SELECT film_id
		FROM film
		WHERE film.title = "Alone Trip"))
;


/* 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. */
SELECT film_id, title
FROM film
WHERE film_id in
	(SELECT film_id
    FROM film_category
	WHERE category_id =
		(SELECT category_id
		FROM category
		WHERE name = "Family"))
;


/* 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information. */
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE customer.address_id IN
	(SELECT address.address_id
	FROM address
	WHERE address.city_id IN
		(SELECT city.city_id
		FROM city
		WHERE city.country_id =
			(SELECT country.country_id
			FROM country
			WHERE country.country = "Canada")))
;

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = "Canada"
;


/* 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred. */
SELECT film.title
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id =
	(SELECT actor.actor_id
	FROM actor
    INNER JOIN film_actor
    ON actor.actor_id = film_actor.actor_id
	GROUP BY film_actor.actor_id
	ORDER BY COUNT(film_actor.film_id) DESC
	LIMIT 1)
;


/* 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
ie the customer that has made the largest sum of payments */
SELECT DISTINCT film.title
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
INNER JOIN customer
ON rental.customer_id = customer.customer_id
WHERE customer.customer_id =
	(SELECT customer.customer_id
	FROM customer
	INNER JOIN payment
	ON customer.customer_id = payment.customer_id
	GROUP BY customer.customer_id
	ORDER BY SUM(payment.amount) DESC
	LIMIT 1)
;


/* 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. */
SELECT DISTINCT customer.customer_id, SUM(payment.amount) AS total_amount_spent
FROM customer
INNER JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
HAVING total_amount_spent >
	(SELECT AVG(total_spent)
	FROM
		(SELECT SUM(payment.amount) AS total_spent
		FROM payment
		GROUP BY payment.customer_id) AS average_total)
;