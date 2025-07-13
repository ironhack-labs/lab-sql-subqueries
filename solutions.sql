-- Add you solution queries below:
use sakila;

-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
select count(*) from inventory where film_id = (select film_id from film where title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.

SELECT title 
FROM film 
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

select 
    CONCAT(ac.first_name, ' ', ac.last_name) as Name_Actor,
    f.title
from film f 
LEFT JOIN 
    film_actor fa on f.film_id = fa.film_id
inner JOIN
    actor ac on fa.actor_id = ac.actor_id
where f.title = 'Alone Trip';

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select 
    f.title,
    ca.name 
from film f
left join 
    film_category fc on f.film_id = fc.film_id
inner join 
    category ca on fc.category_id = ca.category_id
where ca.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select 
    CONCAT(c.first_name, ' ', c.last_name, ' ', c.email) as Name_Customer,
    co.country
from customer c
left join
    address ad on c.address_id = ad.address_id
inner join
    city ci on ad.city_id = ci.city_id
inner join
    country co on ci.country_id = co.country_id
where  co.country = 'Canada';

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT
    f.title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    (SELECT COUNT(*) FROM film_actor WHERE actor_id = a.actor_id) AS total_films
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select 
    concat(c.first_name, ' ', c.last_name) as customer_name,
    sum(p.amount) as total_amount,
    count(f.film_id) as films_rented
from customer c
inner join 
    payment p on c.customer_id = p.customer_id
inner join
    rental r on p.rental_id = r.rental_id
inner join 
    inventory v on r.inventory_id = v.inventory_id
inner join
    film f on v.film_id = f.film_id
group by concat(c.first_name, ' ', c.last_name)
order by total_amount
limit 1;

-- 8. Get the `client_id` and the `total_amount_spent` of those clients 
-- who spent more than the average of the `total_amount` spent by each client.

WITH customer_totals AS (
    SELECT 
        c.customer_id,
        SUM(p.amount) AS total_amount_spent
    FROM customer c
    INNER JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
)
SELECT 
    customer_id,
    total_amount_spent
FROM customer_totals
WHERE total_amount_spent > (SELECT AVG(total_amount_spent) FROM customer_totals)
ORDER BY total_amount_spent DESC;
