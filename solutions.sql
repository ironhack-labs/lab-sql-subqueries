-- Add you solution queries below:
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT 
    COUNT(*) AS "Number of Copies"
FROM 
    inventory 
INNER JOIN 
    film  ON inventory.film_id = film.film_id
WHERE 
    film.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT 
    actor.first_name, 
    actor.last_name
FROM 
    actor 
WHERE 
    actor.actor_id IN (
        SELECT film_actor.actor_id
        FROM film_actor 
        WHERE film_actor.film_id = (
            SELECT film.film_id
            FROM film 
            WHERE film.title = 'Alone Trip'
        )
    );

-- 4. Sales have been lagging among young families, and you wish to target all family 
-- movies for a promotion. Identify all movies categorized as family films.
SELECT 
    film.title
FROM 
    film
INNER JOIN 
    film_category ON film.film_id = film_category.film_id
INNER JOIN 
    category ON film_category.category_id = category.category_id
WHERE 
    category.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to 
-- identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT 
    customer.first_name, 
    customer.last_name, 
    customer.email
FROM 
    customer
INNER JOIN 
    address ON customer.address_id = address.address_id
INNER JOIN 
    city ON address.city_id = city.city_id
INNER JOIN 
    country ON city.country_id = country.country_id
WHERE 
    country.country = 'Canada';


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as 
-- the actor that has acted in the most number of films. First you will have to find the most prolific
--  actor and then use that actor_id to find the different films that he/she starred.
-- Most prolific actor
SELECT 
    actor_id,
    COUNT(film_id) AS film_count
FROM 
    film_actor
GROUP BY 
    actor_id
ORDER BY 
    film_count DESC
LIMIT 1;


-- Films he's been on
SELECT 
    film.title
FROM 
    film
INNER JOIN 
    film_actor ON film.film_id = film_actor.film_id
WHERE 
    film_actor.actor_id = (
        SELECT 
            actor_id
        FROM 
            film_actor
        GROUP BY 
            actor_id
        ORDER BY 
            COUNT(film_id) DESC
        LIMIT 1
    );

-- 7. Films rented by most profitable customer. You can use the customer table and payment 
-- table to find the most profitable customer ie the customer that has made the largest sum of payments
-- Most profitable customer
SELECT 
    customer_id,
    SUM(amount) AS total_payment
FROM 
    payment
GROUP BY 
    customer_id
ORDER BY 
    total_payment DESC
LIMIT 1;

-- Films rented
SELECT 
    film.title
FROM 
    rental
INNER JOIN 
    inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN 
    film ON inventory.film_id = film.film_id
WHERE 
    rental.customer_id = (
        SELECT 
            customer_id
        FROM 
            payment
        GROUP BY 
            customer_id
        ORDER BY 
            SUM(amount) DESC
        LIMIT 1
    );

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the 
-- average of the `total_amount` spent by each client.
SELECT 
    customer_id, 
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (
        SELECT AVG(total_amount) 
        FROM (
            SELECT SUM(amount) AS total_amount 
            FROM payment 
            GROUP BY customer_id
        ) AS avg_spent
    );
