USE sakila;

/* Query 1*/
SELECT film.title, COUNT(inventory.inventory_id) AS Num_Copies
FROM film INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'
GROUP BY film.title;


/* Query 2*/
SELECT film.title 
FROM sakila.film 
WHERE length > (SELECT AVG(length) AS average 
FROM sakila.film)
ORDER BY length DESC;


/* Query 3*/
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
        SELECT film_actor.actor_id
        FROM film_actor
        INNER JOIN film 
        ON film_actor.film_id = film.film_id
        WHERE film.title = 'Alone Trip');


/* Query 4*/
SELECT film.title
FROM film
WHERE film.film_id IN (
		SELECT film.film_id
        FROM film_category
        INNER JOIN category
        ON film_category.category_id = category.category_id
        WHERE category.name = 'Family');


/* Query 5*/
/* Using Subquery*/
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, customer.email
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
                        WHERE country = 'Canada')));

/* Using Joins*/
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS name, customer.email
FROM customer INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada';

/* Query 6*/
SELECT actor_id, COUNT(*) AS film_count
FROM  film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;
-- Use the most prolific actor_id to find the films starred by them
SELECT film.title AS film_title
FROM film
JOIN film_actor 
ON film.film_id = film_actor.film_id
WHERE
    film_actor.actor_id = (
        SELECT actor_id
        FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1);


/* Query 7*/
-- Find the most profitable customer
SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;

-- Use the most profitable customer_id to find the films rented by them
SELECT film.title AS film_title
FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
JOIN customer 
ON rental.customer_id = customer.customer_id
WHERE customer.customer_id = (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1);


/* Query 8*/
SELECT customer_id, total_amount_spent
FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
	FROM payment
    GROUP BY customer_id) AS client_payments
    WHERE total_amount_spent > (SELECT AVG(total_amount_spent)
		FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id) AS avg_payments);



