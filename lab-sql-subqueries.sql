-- Instructions

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

Select
	f.title,
	count(*) as Number_of_copies_in_the_inventory_system
From sakila.inventory i
join sakila.film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.

Select
	title
From sakila.film
where length > (select avg(length) from sakila.film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

Select
	first_name,
    Last_name
From sakila.actor
where actor_id in(
Select
	actor_id
From sakila.film_actor
where film_id in (
select
	film_id
from sakila.film
where title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select
title
from sakila.film
where film_id in (
Select
	film_id
from sakila.film_category
where category_id in (
select
	category_id
from sakila.category
where name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select
	first_name,
    last_name,
    email
From sakila.customer
where address_id in (
select
	address_id
From sakila.address
where city_id in (
Select
	city_id
from sakila.city
where country_id in (
select
	country_id
from sakila.country
where country = 'canada')));

Select 
	c.first_name,
    c.Last_name,
    c.email
From sakila.customer c
join sakila.address a using(address_id)
join sakila.city ct using (city_id)
join sakila.country cou using (country_id)
where country = 'canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
    
select
	title
From sakila.film
where film_id in (
Select 
	film_id
From sakila.film_actor
where actor_id = (
SELECT actor_id 
    FROM sakila.film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 2));
    
-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

Select
	title
from sakila.film
where film_id in (
SELECT
	film_id
From sakila.inventory
where inventory_id in (
select
	inventory_id
From sakila.rental
Where customer_id = (
Select
	customer_id
From sakila.payment
group by customer_id
order by sum(amount) desc
Limit 1)));


-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

SELECT 
	customer_id,
    SUM(amount) AS total_amount_spent
FROM sakila.payment
GROUP BY customer_id
HAVING total_amount_spent > (
 SELECT AVG(total_amount_spent) 
 FROM (
   SELECT customer_id, SUM(amount) AS total_amount_spent
   FROM sakila.payment
   GROUP BY customer_id
 ) AS t
);




