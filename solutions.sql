-- Solutions.sql -- 
USE sakila;
/*How many copies of the film Hunchback Impossible exist in the inventory system?*/
SELECT 
	film.title, COUNT(*) as copies
    FROM film
    INNER JOIN inventory
    ON film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible"
GROUP BY film.title;

-- with subquery -- $$$ GIVES DIFFERENT NUMBER OF COPIES (4581) $$$ WWHYYYYYYY?
Select 
	COUNT(*) AS copies
    FROM inventory
    WHERE film_id = (
    SELECT
			film_id
            FROM film_text
		WHERE film_text.title = "Hunchback Impossible");
            
;
        
        
        
/*List all films whose length is longer than the average of all the films.*/
SELECT
	film.title, film.length
    FROM sakila.film
WHERE film.length > (
    SELECT
		AVG(film.length) AS Average_length 
        FROM sakila.film)
ORDER BY film.length;

/*Use subqueries to display all actors who appear in the film Alone Trip.*/
	
SELECT
	actor.first_name, actor.last_name
    FROM sakila.actor
INNER JOIN (
-- Subquery to find out the actor_id that matches the film_id from 'Alone Trip'
    SELECT
		film_actor.actor_id
		FROM sakila.film_actor
	INNER JOIN (
    -- Subquery to get the film_id from title 'Alone Trip'
		SELECT
			film.film_id
			FROM sakila.film
		WHERE film.title = 'Alone Trip') AS selected_movie
	ON sakila.film_actor.film_id = selected_movie.film_id) AS actors_in_selected_movie
ON sakila.actor.actor_id = actors_in_selected_movie.actor_id
ORDER BY actor.last_name asc;

/*Sales have been lagging among young families, and you wish to target all 
family movies for a promotion. Identify all movies categorized as family films.*/
SELECT
	film.title
    FROM sakila.film
INNER JOIN (
    SELECT 
		film_category.film_id
		FROM sakila.film_category
	INNER JOIN (
		SELECT 
			category.category_id
			FROM sakila.category
		WHERE category.name = 'Family') AS category_family
	ON sakila.film_category.category_id = category_family.category_id) AS film_id_family
ON sakila.film.film_id = film_id_family.film_id
ORDER BY film.title;


/*Get name and email from customers from Canada using subqueries. 
Do the same with joins. Note that to create a join, you will have to identify the correct 
tables with their primary keys and foreign keys, that will help you get the relevant information.*/
SELECT 
	customer.first_name, customer.last_name, customer.email
    FROM sakila.customer
INNER JOIN (
    SELECT
		address.address_id
		FROM sakila.address
	INNER JOIN ( 
    -- Subquery to get the city_id from country_id from "Canada")
		SELECT
			city.city_id
			FROM sakila.city
		INNER JOIN (
        -- Subquery to get the country_id from "Canada"
			SELECT
				country.country_id
				FROM sakila.country
			WHERE country = 'Canada') AS country_selected
		ON sakila.city.country_id = country_selected.country_id) AS city_id_canada -- country_id that matches in city
        --
	ON sakila.address.city_id = city_id_canada.city_id) AS address_id_canada -- city_id that matches in address
ON sakila.customer.address_id = address_id_canada.address_id -- address_id that matches in customer
;

/*Which are films starred by the most prolific actor? Most prolific actor is defined 
as the actor that has acted in the most number of films. First you will have to find 
the most prolific actor and then use that actor_id to find the different films that he/she starred.*/

SELECT
	film.title
    FROM sakila.film
INNER JOIN (
    -- subquery to find the film_id for all movies that match actor_id 
	SELECT 
		film_id, actor_id
		FROM film_actor
	WHERE film_actor.actor_id = (
	-- Subquery to find the most prolifict actor 
		SELECT DISTINCT	
			film_actor.actor_id
			FROM sakila.film_actor
		GROUP BY actor_id
		ORDER BY COUNT(film_actor.actor_id) desc
		limit 1)
	) AS films_top_actor
ON sakila.film.film_id = films_top_actor.film_id
;
    
/*Films rented by most profitable customer. You can use the customer table and payment table 
to find the most profitable customer ie the customer that has made the largest sum of payments*/

SELECT DISTINCT
	film.title
    FROM sakila.film 
INNER JOIN (
	-- Subquery to find the film ids from the films rented by the most profitable customer
	SELECT 
		film_id
		FROM sakila.inventory
	INNER JOIN (
		-- Subquery to find the inventory ids of the films rented by the most profitable customer
		SELECT 
			rental.inventory_id
			FROM sakila.rental
		INNER JOIN (
			-- Subquery to find the most profitable customer SUM(payment.amount)
			SELECT 
				payment.customer_id
				from sakila.payment
				GROUP BY customer_id
				ORDER BY SUM(payment.amount) desc
				limit 1) AS most_profitable_customer
		ON rental.customer_id = most_profitable_customer.customer_id) AS inventory_selected
	ON inventory.inventory_id = inventory_selected.inventory_id) AS films_selected
ON film.film_id = films_selected.film_id
ORDER BY film.title asc;


/*Get the client_id and the total_amount_spent of those clients who 
spent more than the average of the total_amount spent by each client.*/
SELECT distinct
	customer_id, SUM(amount) AS total_amount_spent
    FROM sakila.payment
GROUP BY payment.customer_id
HAVING SUM(amount) > (
-- Subquery to find the Average spent by client
	SELECT
		SUM(amount) / COUNT(DISTINCT customer_id)
		FROM sakila.payment) 
ORDER BY SUM(amount) desc;

