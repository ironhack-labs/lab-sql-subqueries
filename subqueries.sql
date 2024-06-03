USE sakila;
/*How many copies of the film Hunchback Impossible exist in the inventory system?*/
SELECT COUNT(*) AS num_copies
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'

/*List all films whose length is longer than the average of all the films.*/
 /*Find the list of actors which starred in movies with 
    lengths higher or equal to the average length of all the movies*/
    /*average length of all the movies*/
    SELECT AVG(length) AS average FROM sakila.film;

    /*movies with lengths higher or equal to the average length of all the movies*/
SELECT * 
FROM sakila.film 
WHERE length > (SELECT AVG(length) AS average FROM sakila.film)
ORDER BY length DESC;



/*Use subqueries to display all actors who appear in the film Alone Trip.*/

SELECT film_actor.actor_id FROM film;


WHERE actor.actor_id IN ( SELECT film_actor.actor_id FROM film
INNER JOIN film_actor ON film.film_id = f);



/*Sales have been lagging among young families, and you wish to target all family movies for a promotion.
 Identify all movies categorized as family films.*/


SELECT film.title
FROM film
INNER JOIN film_category 
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE category.name = 'Family'

SELECT film_id




/*Get name and email from customers from Canada using subqueries. Do the same with joins.
 Note that to create a join, you will have to identify the correct tables with their primary keys 
 and foreign keys, that will help you get the relevant information.*/
 
 SELECT country_id FROM country 
 WHERE country = 'Canada'
 
 SELECT city_id from city where country_in in ()
 

SELECT first_name, last_name, email
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN country
ON address.city_id = country.country
WHERE country.country = ( SELECT country.country_id FROM country 
 WHERE country.country = 'Canada');


SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country  = 'Canada';


/*Which are films starred by the most prolific actor? 
Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find 
the different films that he/she starred.*/

SELECT actor_id FROM film_actor
GROUP BY actor_id 
ORDER BY COUNT(*) DESC 
LIMIT 1;


SELECT film.title FROM film
WHERE film.film_id IN( SELECT film_id FROM film_actor WHERE actor_id = (SELECT actor_id FROM film_actor
GROUP BY actor_id 
ORDER BY COUNT(*) DESC 
LIMIT 1));



/*Films rented by most profitable customer. 
You can use the customer table and payment table to 
find the most profitable customer ie the customer that has 
made the largest sum of payments*/

SELECT customer_id FROM payment
GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1;

SELECT film.title
FROM film INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
WHERE customer_id = (SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1);


/*Get the client_id and the total_amount_spent of those clients 
who spent more than the average of the total_amount spent by each client.*/
SELECT client_id, total_amount_spent
FROM (SELECT client_id, SUM(amount) as total_amount_spent from payment group by client_id) as client_payments 
where total_amount_spent > (select avg(total_amount_spent) from (SELECT SUM(amount) from payment group by client_id
));



SELECT SUM(amount) from payment group by client_id

