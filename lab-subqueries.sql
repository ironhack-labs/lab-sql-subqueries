-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT
    COUNT(inventory_id) AS count
FROM
    (SELECT 
        inv.inventory_id,
		inv.film_id,
		f.title
     FROM sakila.inventory inv
     LEFT JOIN sakila.film f ON inv.film_id = f.film_id
    ) sub1
WHERE
    title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT
    title AS film_below_avg
FROM
    sakila.film
WHERE length > (SELECT 
		avg(length) as avg_length
	FROM sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
    actor_name
FROM
    (SELECT
        f.title AS title,
		fa.actor_id AS actor_id,
		CONCAT(a.first_name, ' ', a.last_name) AS actor_name
	FROM sakila.film f
	LEFT JOIN sakila.film_actor fa ON f.film_id = fa.film_id
	LEFT JOIN sakila.actor a ON fa.actor_id = a.actor_id) sub1
WHERE title = 'Alone Trip';

-- 4. Identify all movies categorized as family films.
SELECT
    title AS family_film
FROM
    (SELECT
        f.title AS title,
		c.name AS category_name
	FROM sakila.film f
	LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id
	LEFT JOIN sakila.category c ON fc.category_id = c.category_id) sub1
WHERE category_name = 'Family';

-- 4. Get name and email from customers from Canada using subqueries. Do the same with joins. 

-- 4.1 With joins
SELECT 
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email AS email
FROM
    sakila.customer cu
LEFT JOIN sakila.address a ON cu.address_id = a.address_id
LEFT JOIN sakila.city ci ON a.city_id = ci.city_id
LEFT JOIN sakila.country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 4.2 with subqueries
SELECT
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email
FROM
    sakila.customer
WHERE
    address_id IN (
        SELECT
            address_id
        FROM
            sakila.address
        WHERE
            city_id IN (
                SELECT
                    city_id
                FROM
                    sakila.city
                WHERE
                    country_id IN (
                        SELECT
                            country_id
                        FROM
                            sakila.country
                        WHERE
                            country = 'Canada')));

-- 6. Which are films starred by the most prolific actor?
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT
    f.title AS films_most_prolific_actor_starred
FROM 
    sakila.film f
INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id =
    (SELECT
        actor_id
    FROM
        sakila.film_actor
    GROUP BY
        actor_id
    ORDER BY
        COUNT(film_id) DESC
    LIMIT 1);

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT
    f.title AS films_rented_best_customer
FROM sakila.film f
INNER JOIN sakila.inventory inv ON f.film_id = inv.film_id
INNER JOIN sakila.rental r ON inv.inventory_id = r.inventory_id
WHERE r.customer_id =
    (SELECT
        p.customer_id AS customer_id
    FROM
        sakila.payment p
    LEFT JOIN sakila.customer c ON p.customer_id = c.customer_id
    GROUP BY p.customer_id
    ORDER BY sum(p.amount) DESC
    LIMIT 1);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT
    customer_id,
    sum(amount) AS total_amount_spent
FROM
    sakila.payment
GROUP BY customer_id
HAVING total_amount_spent >
    (SELECT
        avg(total_amount)
    FROM
        (SELECT
            customer_id,
            sum(amount) AS total_amount
        FROM sakila.payment
        GROUP BY customer_id) sub1);
