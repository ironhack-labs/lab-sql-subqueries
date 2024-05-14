use sakila;
/* 1 */
select film.title, count(film.title) as count from film join inventory on film.film_id = inventory.film_id where film.title = 'Hunchback Impossible';

/* 2 */
SELECT film.title 
    FROM sakila.film 
    WHERE length > (SELECT AVG(length) AS average FROM sakila.film)
        ORDER BY length DESC;

/* 3 */
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN 
( SELECT film_actor.actor_id FROM film JOIN film_actor ON film.film_id = film_actor.film_id WHERE  film.title = 'Alone Trip');

/* 4 */
select film.title from film
where film.film_id in 
( select film_category.film_id from film_category join category on film_category.category_id = category.category_id 
where category.name = 'Family');

/* 5 */
/* With subqueries */
select first_name, email from customer
where address_id in
(select address_id from address where city_id in (select city_id from city where country_id = (select country_id from country where country = 'Canada')));

/* With joins */
SELECT customer.first_name, customer.email
FROM customer INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada';

/* 6 */
select film.title from film join film_actor on film.film_id = film_actor.film_id

where film_actor.actor_id = (SELECT actor_id FROM film_actor GROUP BY actor_id
ORDER BY count(*) DESC LIMIT 1);

/* 7 */
/* the most profitable customer */
SELECT payment.customer_id, SUM(payment.amount)
FROM payment
GROUP BY payment.customer_id
ORDER BY SUM(payment.amount) DESC LIMIT 1;

/* Use the most profitable customer's customer_id to find the films rented */
SELECT film.title
FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE rental.customer_id = (
        SELECT payment.customer_id
        FROM payment
        GROUP BY payment.customer_id
        ORDER BY SUM(payment.amount) DESC LIMIT 1 );

/* 8 */
SELECT customer_id, total_amount_spent
FROM (SELECT customer_id, SUM(amount) AS total_amount_spent FROM payment GROUP BY customer_id) AS client_payments
WHERE total_amount_spent > (SELECT AVG(total_amount_spent)
FROM (SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment GROUP BY customer_id) AS avg_payments);

