-- Add you solution queries below:
-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
SELECT
film.title,
count(inventory.inventory_id) AS number_of_copies
FROM film
LEFT JOIN
inventory on film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible"
GROUP BY film.title;

-- 2. List all films whose length is longer than the average of all the films.

SELECT AVG(film.length)
FROM film;

SELECT
film.title,
film.length
FROM film
WHERE film.length > (
SELECT AVG(film.length)
FROM film)
ORDER BY film.length ASC;


-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.
SELECT
film.title,
actor.actor_id,
actor.first_name,
actor.last_name
FROM actor
LEFT JOIN
film_actor on actor.actor_id = film_actor.actor_id
LEFT JOIN
film on film_actor.film_id = film.film_id
WHERE film.title = (
SELECT film.title
FROM film
WHERE film.title = "Alone Trip"
);
-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT
film.title,
category.name
from film
left join 
film_category on film.film_id = film_category.film_id
left join
category on film_category.category_id = category.category_id
WHERE category.name = (
SELECT category.name
FROM category
WHERE category.name = "family"
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Subqueries

SELECT
    customer.first_name,
    customer.last_name,
    customer.email
FROM
    customer
WHERE
    customer.address_id IN (
        SELECT address.address_id
        FROM address
        WHERE address.city_id IN (
            SELECT city.city_id
            FROM city
            WHERE city.country_id IN (
                SELECT country.country_id
                FROM country
                WHERE country = 'Canada'
            )
        )
    );
    
-- JOINS
SELECT
customer.first_name,
customer.last_name,
customer.email
FROM customer
LEFT JOIN
address on customer.address_id = address.address_id
LEFT JOIN
city on address.city_id = city.city_id
LEFT JOIN
country on city.country_id = country.country_id
WHERE country = "Canada";


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT 
    a.first_name,
    a.last_name,
    f.title
FROM 
    film AS f
JOIN 
    film_actor AS fa ON f.film_id = fa.film_id
JOIN 
    actor AS a ON fa.actor_id = a.actor_id
WHERE 
    fa.actor_id = (
        SELECT 
            fa2.actor_id
        FROM 
            film_actor AS fa2
        GROUP BY 
            fa2.actor_id
        ORDER BY 
            COUNT(fa2.film_id) DESC
        LIMIT 1
    );

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT 
    f.title,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_payment
FROM 
    customer AS c
JOIN 
    payment AS p ON c.customer_id = p.customer_id
JOIN 
    rental AS r ON c.customer_id = r.customer_id
JOIN 
    inventory AS i ON r.inventory_id = i.inventory_id
JOIN 
    film AS f ON i.film_id = f.film_id
WHERE 
    c.customer_id = (
        SELECT 
            c2.customer_id
        FROM 
            customer AS c2
        JOIN 
            payment AS p2 ON c2.customer_id = p2.customer_id
        GROUP BY 
            c2.customer_id
        ORDER BY 
            SUM(p2.amount) DESC
        LIMIT 1
    )
GROUP BY 
    f.title, c.first_name, c.last_name
ORDER BY 
    total_payment DESC;

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.

SELECT 
    c.customer_id AS client_id,
    SUM(p.amount) AS total_amount_spent
FROM 
    customer AS c
JOIN 
    payment AS p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id
HAVING 
    total_amount_spent > (
        SELECT 
            AVG(total_spent) 
        FROM (
            SELECT 
                SUM(amount) AS total_spent
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS subquery
    );
