-- Lab | SQL Subqueries

-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
COUNT(*) as number_copies
FROM sakila.inventory
JOIN sakila.film USING (film_id)
WHERE title = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films.

SELECT 
	title, 
	length
FROM sakila.film
WHERE length > (
    SELECT avg(length)
    FROM sakila.film ); -- the avg is 115

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
	a.first_name, 
	a.last_name
FROM sakila.actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM sakila.film_actor fa
    WHERE fa.film_id = (
        SELECT f.film_id
        FROM sakila.film f
        WHERE f.title = 'Alone Trip'
    )
);

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT 
	title 
FROM sakila.film
JOIN sakila.film_category fc USING (film_id)
JOIN sakila.category c USING(category_id)
WHERE c.name = "Family";

-- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables 
-- with their primary keys and foreign keys, that will help you get the relevant information.

-- USING SUBQUERIES

SELECT 
	first_name, 
	last_name, 
	email
FROM sakila.customer
WHERE address_id IN (
    SELECT address_id
    FROM sakila.address
    WHERE city_id IN (
        SELECT city_id
        FROM sakila.city
        WHERE country_id IN (
            SELECT country_id
            FROM sakila.country
            WHERE country = 'Canada'
        )
    )
);

-- USING JOINS

SELECT 
c.first_name, 
c.last_name, 
c.email
FROM sakila.customer c
JOIN sakila.address a USING (address_id)
JOIN sakila.city ci USING (city_id)
JOIN sakila.country co USING (country_id)
WHERE co.country = 'Canada';

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
-- that has acted in the most number of films. First you will have to find the most prolific actor and 
-- then use that actor_id to find the different films that he/she starred.

SELECT 
	film.title
FROM sakila.film
JOIN sakila.film_actor fa USING (film_id)
WHERE fa.actor_id = (
    SELECT actor_id
    FROM (
        SELECT 
        actor_id, 
        COUNT(*) as film_count
        FROM sakila.film_actor
        GROUP BY actor_id
        ORDER BY film_count DESC
        LIMIT 1
    ) as most_prolific_actor
);
   
        
-- Films rented by most profitable customer. You can use the customer table and payment table to find the most 
-- profitable customer ie the customer that has made the largest sum of payments

SELECT 
	f.title 
FROM sakila.film f 
JOIN sakila.film_actor fa USING(film_id) 
JOIN (
SELECT 
	actor_id, COUNT(*) as num_films 
FROM sakila.film_actor 
GROUP BY actor_id 
ORDER BY num_films DESC 
LIMIT 1
) a ON fa.actor_id = a.actor_id;

-- Get the client_id and the total_amount_spent of those clients who spent more than the average of 
-- the total_amount spent by each client.

SELECT c.customer_id as client_id, sum(p.amount) as total_amount_spent
FROM sakila.customer c
JOIN sakila.payment p USING (customer_id)
WHERE c.customer_id IN (
    SELECT customer_id
    FROM sakila.payment
    GROUP BY customer_id
    HAVING sum(amount) > (
        SELECT avg(total)
        FROM (
            SELECT customer_id, sum(amount) as total
            FROM sakila.payment
            GROUP BY customer_id
        ) as payment_totals
    )
)
GROUP BY c.customer_id
ORDER BY client_id, total_amount_spent DESC;