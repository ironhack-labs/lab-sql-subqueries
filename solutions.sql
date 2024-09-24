USE sakila;

SELECT COUNT(i.inventory_id) AS copies_count
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

SELECT f.title, f.length
FROM film f
WHERE f.length > (SELECT AVG(length) FROM film);

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
	SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
    );

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';


SELECT 
    c.first_name, 
    c.last_name, 
    c.email
FROM 
    customer c
WHERE 
    c.address_id IN (
        SELECT 
            a.address_id
        FROM 
            address a
        JOIN 
            city ci ON a.city_id = ci.city_id
        JOIN 
            country co ON ci.country_id = co.country_id
        WHERE 
            co.country = 'Canada'
    );
    

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
	SELECT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
	GROUP BY a.actor_id
	ORDER BY COUNT(fa.film_id) DESC
	LIMIT 1
);

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

SELECT c.customer_id, SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING total_amount_spent > (
	SELECT AVG(total_spent)
    FROM (
		SELECT SUM(p.amount) AS total_spent
        FROM customer c
        JOIN payment p ON c.customer_id = p.customer_id
        GROUP BY c.customer_id
        ) AS subquery
);
    

