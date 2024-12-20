

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    f.title AS `Film Title`,
    COUNT(i.inventory_id) AS `Total Copies`
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
WHERE 
    f.title = 'Hunchback Impossible'
GROUP BY 
    f.title;


-- List all films whose length is longer than the average of all the films.

SELECT 
    title AS `Film Title`,
    length AS `Film Length`
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film)
ORDER BY 
    length DESC;


-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    a.actor_id AS `Actor ID`,
    a.first_name AS `First Name`,
    a.last_name AS `Last Name`
FROM 
    actor a
WHERE 
    a.actor_id IN (
        SELECT fa.actor_id
        FROM film_actor fa
        JOIN film f ON fa.film_id = f.film_id
        WHERE f.title = 'Alone Trip'
    );


-- Identify all movies categorized as family films.
SELECT 
    f.title AS `Film Title`,
    c.name AS `Category`
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';



-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.
SELECT 
    first_name AS `First Name`,
    last_name AS `Last Name`,
    email AS `Email`
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

-- with joins
SELECT 
    c.first_name AS `First Name`,
    c.last_name AS `Last Name`,
    c.email AS `Email`
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';






-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT 
    fa.actor_id AS `Actor ID`,
    a.first_name AS `First Name`,
    a.last_name AS `Last Name`,
    COUNT(fa.film_id) AS `Total Films`
FROM 
    film_actor fa
JOIN 
    actor a ON fa.actor_id = a.actor_id
GROUP BY 
    fa.actor_id, a.first_name, a.last_name
ORDER BY 
    `Total Films` DESC
LIMIT 1;


-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

SELECT 
    f.title AS `Film Title`
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    r.customer_id = (
        SELECT 
            c.customer_id
        FROM 
            customer c
        JOIN 
            payment p ON c.customer_id = p.customer_id
        GROUP BY 
            c.customer_id
        ORDER BY 
            SUM(p.amount) DESC
        LIMIT 1
    );




-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the 
-- total_amount spent by each client.

SELECT 
    customer_id AS `Customer ID`,
    SUM(amount) AS `Total Amount Spent`
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    SUM(amount) > (
        SELECT AVG(total_amount)
        FROM (
            SELECT 
                customer_id, 
                SUM(amount) AS total_amount
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS customer_totals
    );


