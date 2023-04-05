-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

use sakila;

SELECT 
    COUNT(*) AS num_copies
FROM
    sakila.inventory inv
        JOIN
    sakila.film fil ON inv.film_id = fil.film_id
WHERE
    fil.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.

SELECT 
    title, length
FROM
    sakila.film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    first_name, last_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT 
    film.title
FROM
    sakila.film AS film
        JOIN
    sakila.film_category AS fc ON film.film_id = fc.film_id
        JOIN
    sakila.category AS cat ON fc.category_id = cat.category_id
WHERE
    cat.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT 
    first_name, last_name, email
FROM
    sakila.customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            sakila.address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    sakila.city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            sakila.country
                        WHERE
                            country = 'canada')));

SELECT 
    c.first_name, c.Last_name, c.email
FROM
    sakila.customer c
        JOIN
    sakila.address a USING (address_id)
        JOIN
    sakila.city ct USING (city_id)
        JOIN
    sakila.country cou USING (country_id)
WHERE
    country = 'canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT 
    f.title
FROM
    film_actor fa
        JOIN
    film f ON fa.film_id = f.film_id
WHERE
    fa.actor_id = (SELECT 
            a.actor_id
        FROM
            actor a
                JOIN
            film_actor fa ON a.actor_id = fa.actor_id
        GROUP BY a.actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1)
ORDER BY f.title;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT 
    f.title,
    COUNT(*) AS rental_count,
    SUM(p.amount) AS total_revenue
FROM
    film f
        JOIN
    inventory i ON f.film_id = i.film_id
        JOIN
    rental r ON i.inventory_id = r.inventory_id
        JOIN
    payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY rental_count DESC , total_revenue DESC
LIMIT 10;

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT 
    customer_id, SUM(amount) AS total_amount_spent
FROM
    sakila.payment
GROUP BY customer_id
HAVING total_amount_spent > (SELECT 
        AVG(total_amount_spent)
    FROM
        (SELECT 
            customer_id, SUM(amount) AS total_amount_spent
        FROM
            sakila.payment
        GROUP BY customer_id) AS t);
