-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) as Number_Of_Copies
FROM sakila.inventory
WHERE film_id = (
SELECT film_id FROM sakila.film WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length FROM sakila.film
WHERE length > (SELECT avg(length) FROM sakila.film)
ORDER BY title;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
-- SELECT actor_id FROM sakila.film_actor WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip');

SELECT B.first_name, B.last_name FROM sakila.film_actor A JOIN sakila.actor B USING(actor_id) WHERE film_id = (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT title FROM sakila.film A WHERE film_id IN (SELECT film_id FROM sakila.film_category B WHERE category_id = 8);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM sakila.customer WHERE address_id IN (SELECT address_id FROM sakila.address WHERE city_id IN (SELECT city_id FROM sakila.city WHERE country_id = (SELECT country_id FROM sakila.country WHERE country = 'Canada')));


-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title FROM sakila.film WHERE film_id IN (SELECT film_id FROM sakila.film_actor WHERE actor_id = (SELECT actor_id FROM sakila.film_actor GROUP BY actor_id ORDER BY count(film_id) DESC LIMIT 1));


-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.
SELECT A.title FROM sakila.film A 
JOIN sakila.inventory B USING (film_id)
JOIN sakila.rental C USING (inventory_id)
WHERE C.customer_id = (SELECT customer_id FROM sakila.payment GROUP BY customer_id ORDER BY sum(amount) DESC LIMIT 1);

-- 8. Get the client_id and the total_amount_spent of those clients
-- who spent more than the average of the total_amount spent by each client.

SELECT customer_id, sum(amount) as total_amount
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount) FROM 
                      (SELECT customer_id, SUM(amount) as total_amount FROM sakila.payment GROUP BY customer_id) as sub_query);