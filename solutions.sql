-- Add you solution queries below:

use sakila;

--  1. How many copies of the film Hunchback Impossible exist in the inventory system?
-- Select coun.  , from Inveotry, where Film tiel i hunback Via film ID in film table 


select * from inventory;
select * from film;
select * from store;


Select 
	f.title,
    COUNT(i.inventory_id) as number_copies
from film f
JOIN inventory i on f.film_id = i.film_id
where f.title = 'Hunchback Impossible'
group by i.film_id;


--  2. List all films whose length is longer than the average of all the films.

SELECT 
    f.film_id,
    f.title,
    f.length
FROM film f
WHERE f.length > (
    SELECT AVG(length) FROM film
);


-- 3 Use subqueries to display all actors who appear in the film Alone Trip.

-- Selce Acto id, conncat actor name  in in Film_actor, fitlm titel
-- where about film tiel alonte w
-- join film actor and film via film id and film actor id with film actor and acotr tbales 
--

Select 
	f.title,
    a.actor_id,
    concat(a.first_name, ' ', a.last_name) as actor_name
from film f
Join film_actor fa on fa.film_id = f.film_id
Join actor a on fa.actor_id = a.actor_id
where f.title = 'Alone Trip';

--  4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select 
	f.title,
    c.name
from film f
join film_category fc on f.film_id =fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Family';
	
 
--  5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select 
	concat(c.first_name, ' ', c.last_name) as name,
    c.email,
    co.country
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id 
join country co on ci.country_id = co.country_id
where co.country = 'Canada';


--  6 Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

WITH TopActors AS (
	Select 
		a.actor_id,
		concat(a.first_name, ' ', a.last_name) as name_prolific_actor,
		count(fa.film_id) as total_films
	From actor a 
	join film_actor fa on a.actor_id = fa.actor_id
	GROUP BY a.actor_id  -- Grouping by actor_id ensures each actor is counted separately
	order by total_films desc
    limit 10
)
SELECT
    ta.actor_id AS id,
    ta.name_prolific_actor,
    ta.total_films,
    GROUP_CONCAT(f.title) AS films
FROM TopActors ta
JOIN film_actor fa ON ta.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY ta.actor_id, ta.name_prolific_actor, ta.total_films
order by total_films desc;

--  7 Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that 
-- has made the largest sum of payments

With profitable_customer AS (
	select 
		c.customer_id,
		concat(c.first_name, ' ', c.last_name) as name,
		sum(p.amount) as total_amount
	from customer c 
	Join payment p on c.customer_id = p.customer_id
	group by c.customer_id
	order by total_amount desc
	limit 1
)
Select 
	pc.customer_id as id,
    pc.name,
	GROUP_CONCAT(f.title) AS films
from profitable_customer pc
JOIN payment p ON pc.customer_id = p.customer_id  
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
group by pc.customer_id, pc.name;


--  8 Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
WITH customer_totals AS (
    SELECT
        p.customer_id,
        SUM(p.amount) AS total_amount_spent
    FROM payment p
    GROUP BY p.customer_id
)
SELECT 
    ct.customer_id,
    ct.total_amount_spent
FROM customer_totals ct
WHERE ct.total_amount_spent > (
    SELECT AVG(total_amount_spent) FROM customer_totals
);

	