-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(*) AS copies_count
FROM 
    inventory i
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT 
    title, 
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT 
    a.first_name,
    a.last_name
FROM 
    actor a
WHERE 
    a.actor_id IN (SELECT fa.actor_id
                   FROM film_actor fa
                   JOIN film f ON fa.film_id = f.film_id
                   WHERE f.title = 'Alone Trip');

-- 4. Identify all movies categorized as family films.
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries.
SELECT 
    first_name, 
    last_name, 
    email
FROM 
    customer
WHERE 
    address_id IN (SELECT address_id 
                   FROM address
                   WHERE city_id IN (SELECT city_id 
                                     FROM city
                                     WHERE country_id = (SELECT country_id 
                                                         FROM country 
                                                         WHERE country = 'Canada')));

-- 5 (continued): Get name and email from customers from Canada using joins.
SELECT 
    c.first_name, 
    c.last_name, 
    c.email
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

-- 6. Which are films starred by the most prolific actor?
SELECT 
    f.title
FROM 
    film f
JOIN 
    film_actor fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (SELECT actor_id
                   FROM film_actor
                   GROUP BY actor_id
                   ORDER BY COUNT(film_id) DESC
                   LIMIT 1);

-- 7. Films rented by the most profitable customer.
SELECT 
    f.title
FROM 
    payment p
JOIN 
    rental r ON p.rental_id = r.rental_id
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    p.customer_id = (SELECT customer_id 
                     FROM payment 
                     GROUP BY customer_id 
                     ORDER BY SUM(amount) DESC 
                     LIMIT 1);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total amount spent by each client.
SELECT 
    customer_id, 
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (SELECT AVG(total) FROM (SELECT SUM(amount) AS total FROM payment GROUP BY customer_id) AS avg_totals);
-- Add you solution queries below:
