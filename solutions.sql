-- Add you solution queries below:
use sakila; 

-- 1

SELECT 
    f.title, 
    COUNT(i.inventory_id) AS total_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;
 
 
 -- 2
 
 SELECT 
    title, 
    length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
 
 
 -- 3
 
 SELECT 
    a.first_name, 
    a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);


-- 4

SELECT 
    f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 5

SELECT 
    first_name, 
    last_name, 
    email
FROM customer
WHERE address_id IN (
    SELECT a.address_id 
    FROM address a 
    JOIN city ci ON a.city_id = ci.city_id
    JOIN country co ON ci.country_id = co.country_id
    WHERE co.country = 'Canada'
);


-- 6

SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

-- 6.1

SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

-- 6.2 

SELECT 
    f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = X;


-- 7

SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_payments
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_payments DESC
LIMIT 1;




-- 7.1

SELECT 
    f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.customer_id = Y;

-- 8

SELECT 
    customer_id, 
    total_amount_spent
FROM (
    SELECT 
        c.customer_id, 
        SUM(p.amount) AS total_amount_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) AS customer_totals
WHERE total_amount_spent > (SELECT AVG(total_amount_spent) FROM (
    SELECT 
        SUM(p.amount) AS total_amount_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) AS total_spent);


