use sakila;

-- 1

SELECT COUNT(*)
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

-- 2

SELECT 
    film_id, 
    title, 
    length 
FROM 
    film 
WHERE 
    length > (SELECT AVG(length) FROM film);

-- 3

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id
    FROM film_actor
    WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
    )
);

-- 4

SELECT 
    f.film_id,
    f.title
FROM 
    film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

-- 5

SELECT 
    first_name, 
    last_name, 
    email 
FROM customer 
WHERE address_id IN (
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


SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country cn ON ct.country_id = cn.country_id
WHERE cn.country = 'Canada';

-- 6

SELECT f.film_id, f.title, a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.actor_id = (
    SELECT fa.actor_id
    FROM film_actor fa
    GROUP BY fa.actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 7

SELECT f.film_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN (SELECT p.customer_id
      FROM payment p
      GROUP BY p.customer_id
      ORDER BY SUM(p.amount) DESC
      LIMIT 1) c ON r.customer_id = c.customer_id
ORDER BY f.title;

-- 8

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
  SELECT AVG(total_amount_spent)
  FROM (
    SELECT SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
  ) AS t
);