USE Sakila;
#1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT 
    COUNT(*) AS num_copies
FROM 
    inventory inv
JOIN 
    film fil ON inv.film_id = fil.film_id
WHERE 
    fil.title = 'Hunchback Impossible';

#2. List all films whose length is longer than the average of all the films.
SELECT 
    f.title AS film_title,
    f.length AS film_length
FROM 
    film f
WHERE 
    f.length > (SELECT AVG(length) FROM film);

#3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT 
    actor.first_name,
    actor.last_name
FROM 
    actor
JOIN 
    film_actor ON actor.actor_id = film_actor.actor_id
WHERE 
    film_actor.film_id = (
        SELECT film_id 
        FROM film 
        WHERE title = 'Alone Trip'
    );

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
    f.title AS film_title,
    c.name AS category_name
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

#5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT 
    first_name,
    last_name,
    email
FROM 
    customer
WHERE 
    address_id IN (
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

SELECT 
    cu.first_name,
    cu.last_name,
    cu.email
FROM 
    customer cu
JOIN 
    address ad ON cu.address_id = ad.address_id
JOIN 
    city ci ON ad.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';

#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    fa.actor_id,
    COUNT(*) AS film_count
FROM 
    film_actor fa
GROUP BY 
    fa.actor_id
ORDER BY 
    film_count DESC
LIMIT 1;

SELECT 
    f.title AS film_title
FROM 
    film_actor fa
JOIN 
    film f ON fa.film_id = f.film_id
WHERE 
    fa.actor_id = (
        SELECT 
            actor_id
        FROM 
            film_actor
        GROUP BY 
            actor_id
        ORDER BY 
            COUNT(*) DESC
        LIMIT 1
    );

#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT 
    customer_id,
    SUM(amount) AS total_payments
FROM 
    payment
GROUP BY 
    customer_id
ORDER BY 
    total_payments DESC
LIMIT 1;

SELECT 
    f.title AS film_title
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.customer_id = (
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

#8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
SELECT 
    customer_id AS client_id,
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (
        SELECT 
            AVG(total_amount_spent)
        FROM 
            (
                SELECT 
                    SUM(amount) AS total_amount_spent
                FROM 
                    payment
                GROUP BY 
                    customer_id
            ) AS avg_amount_spent
    );