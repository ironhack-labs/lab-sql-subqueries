-- How many copies of the film Hunchback Impossible exist in the inventory system?

select * from sakila.inventory;
select * from sakila.film ;

select * 
from sakila.inventory i
left join sakila.film f
on f.film_id = i.film_id;

select f.film_id as film_id, f.title as title , count(i.inventory_id) as Nb_film_inventory
from sakila.inventory i
left join sakila.film f
on f.film_id = i.film_id
where f.title = 'Hunchback Impossible'
group by film_id
 ;

-- Result 
-- '439', 'HUNCHBACK IMPOSSIBLE', '6'

-- List all films whose length is longer than the average of all the films.

select * from sakila.film ;

-- Subqerie to get the average and then appply to our table to get only film length > avg
select * 
from sakila.film
where length > (
	select  avg(length) as average
	from sakila.film
)
order by length asc;

-- Use subqueries to display all actors who appear in the film Alone Trip.

select * from sakila.film;
select * from sakila.film_actor;
select * from sakila.actor;

select actor_id
from sakila.film_actor fa
left join sakila.film f
on fa.film_id = f.film_id

where f.title = 'ALONE TRIP' 
;


select *  from 
(
select a.actor_id, a.last_name, a.first_name, f.film_id, f.title
from sakila.film f
left join sakila.film_actor fa
on f.film_id = fa.film_id
left join sakila.actor a
on a.actor_id = fa.actor_id
where title = 'ALONE TRIP' 
) sub1
 ;
 
 
 SELECT
    a.actor_id,
    a.last_name,
    a.first_name,
    f.film_id,
    f.title
FROM
    sakila.film f,
    sakila.actor a
WHERE
    f.film_id IN (SELECT film_id FROM sakila.film WHERE title = 'ALONE TRIP') AND
    a.actor_id IN (SELECT actor_id FROM sakila.film_actor WHERE film_id IN (SELECT film_id FROM sakila.film WHERE title = 'ALONE TRIP'));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films. 
 
select * from sakila.film,sakila.category;

select distinct(name) from sakila.category;

-- family

SELECT *
FROM sakila.film ,sakila.category
WHERE film_id IN (
    SELECT f.film_id
    FROM sakila.film f
    JOIN sakila.film_category fc ON f.film_id = fc.film_id
    JOIN sakila.category c ON fc.category_id = c.category_id
    WHERE c.name = 'Family'
);


SELECT *
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.film_category
    WHERE category_id IN (
        SELECT category_id
        FROM sakila.category
        WHERE name = 'Family'
    )
);



-- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join,
--  you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select * from sakila.customer,sakila.country, sakila.address;

select * from sakila.address;

select * from sakila.city;

select * from sakila.country;

SELECT *
FROM sakila.customer,sakila.country, sakila.address ,sakila.city
WHERE customer_id IN (
    SELECT c.customer_id
    FROM sakila.film f
    JOIN sakila.film_category fc ON f.film_id = fc.film_id
    JOIN sakila.category c ON fc.category_id = c.category_id
    WHERE c.name = 'Family'
);



SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (
    SELECT address_id
    FROM sakila.address
    WHERE city_id IN (
        SELECT city_id
        FROM sakila.city
        WHERE country_id IN (
            SELECT country_id
            FROM sakila.country
            WHERE country = 'Canada'
        )
    )
);


-- Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select * from sakila.actor ;
select * from sakila.film_actor;


SELECT *
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.film_actor
    WHERE actor_id IN (
        SELECT count(film_id)
        FROM sakila.film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
       
    )
)
 LIMIT 1;


SELECT *
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM sakila.film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    )
);



-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

select * from sakila.customer ;
select * from sakila.payment;
select * from rental;
select * from inventory;

 SELECT customer_id , sum(amount)
        FROM sakila.payment
        GROUP BY customer_id
        ORDER BY sum(amount) DESC
        LIMIT 1;

SELECT *
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.inventory
    WHERE inventory_id in (
    select inventory_id
    from sakila.rental
    WHERE customer_id = (
        SELECT customer_id 
        FROM sakila.payment
        GROUP BY customer_id
        ORDER BY sum(amount) DESC
        LIMIT 1
    )
)
);


-- Get the client_id and the total_amount_spent of those clients
-- who spent more than the average of the total_amount spent by each client.

SELECT
    client_id,
    SUM(total_amount) AS total_amount_spent
FROM
    sakila.payment-- replace with your actual table name
WHERE
    client_id IN (
        SELECT
            client_id
        FROM
            your_table -- replace with your actual table name
        GROUP BY
            client_id
        HAVING
            AVG(total_amount) < (SELECT AVG(total_amount) FROM your_table) -- replace with your actual table name
    )
GROUP BY
    client_id;

select * from sakila.payment;
    
    SELECT
    customer_id,
    SUM(amount) AS total_amount_spent
FROM
    sakila.payment
GROUP BY
    customer_id
HAVING
    total_amount_spent > (
        SELECT AVG(total_amount_spent) AS avg_total_payment
        FROM (
            SELECT
                customer_id,
                SUM(amount) AS total_amount_spent
            FROM
                sakila.payment
            GROUP BY
                customer_id
        ) sub1
    );
    
