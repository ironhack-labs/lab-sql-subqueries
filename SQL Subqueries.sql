USE sakila;

# 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT
	count(*) as 'Hunchback Impossible_copies'
FROM inventory
WHERE film_id =	(
	SELECT
		film_id
	FROM film
    WHERE title = 'Hunchback Impossible'
    )
;

# 2. List all films whose length is longer than the average of all the films.
SELECT
	title
FROM film
WHERE length > (
	SELECT
		avg(length)
	FROM film
    )
;

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
	actor_id,
    first_name,
    last_name
FROM actor
WHERE actor_id IN (
	SELECT
		actor_id
	FROM film_actor fa
    LEFT JOIN film f using(film_id)
    WHERE title = 'Alone Trip'
    )
;

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as family films.
SELECT
	title
FROM film
WHERE film_id IN (
	SELECT
		film_id
	FROM film_category fa
    LEFT JOIN category c using(category_id)
    WHERE c.name = 'Family'
    )
;

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to 
# identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT
	first_name,
    last_name,
    email
FROM customer
WHERE customer_id IN (
	SELECT
		customer_id
	FROM customer
    LEFT JOIN address a using(address_id)
    LEFT JOIN city ci using(city_id)
    LEFT JOIN country co using(country_id)
    WHERE country = 'Canada'
    )
;

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT
	title
FROM film_actor
JOIN film using(film_id)
WHERE actor_id = (
	SELECT
		actor_id
    FROM (
		SELECT
			actor_id,
			count(*) as num_films
		FROM film_actor
		GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1
		) sub1
    )
;

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
# ie the customer that has made the largest sum of payments
SELECT
	title
FROM film f
LEFT JOIN inventory i using(film_id)
LEFT JOIN rental r using(inventory_id)
WHERE customer_id = (
	SELECT
		customer_id
    FROM (
		SELECT
			customer_id,
            sum(amount) as total_amount
		FROM payment
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1
        ) sub1
	)
;

# 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT
	c.customer_id,
    sum(p.amount) as total_amount_spent
FROM customer c
LEFT JOIN payment p using(customer_id)
GROUP BY 1
HAVING total_amount_spent > (
	SELECT
		avg(total_amount_spent)
	FROM (
		SELECT
			c.customer_id,
			sum(p.amount) as total_amount_spent
		FROM customer c
		LEFT JOIN payment p using(customer_id)
        GROUP BY 1
        ) sub1
	)
ORDER BY 2 DESC
;
