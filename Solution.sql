USE sakila;


/ Q1 / 



SELECT COUNT(*) AS copies
FROM inventory
WHERE film_id = (
  SELECT film_id
  FROM film
  WHERE title = 'Hunchback Impossible'
);





/ Q2 / 




SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);





/ Q3 / 




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






/ Q4 / 




SELECT title 
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = 8
);





/ Q5 / 



SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = 20
    )
);

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';





/ Q6 / 



SELECT film.title, COUNT(film_actor.actor_id) AS appearances
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT film_actor.actor_id
    FROM film_actor
    GROUP BY film_actor.actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY film.title;






/ Q7 / 




-- the customer that has made the largest sum of payments
SELECT film.title, max_payment.total_payment
FROM film
INNER JOIN (
    SELECT inventory.film_id, payment.customer_id, MAX(payment.amount) as total_payment
    FROM rental
    INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
    INNER JOIN payment ON rental.customer_id = payment.customer_id
    GROUP BY inventory.film_id, payment.customer_id
    ORDER BY total_payment DESC
    LIMIT 5
) max_payment ON film.film_id = max_payment.film_id;





/ Q8 / 




SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT customer_id, SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS avg_payments
) ORDER BY SUM(amount) DESC;