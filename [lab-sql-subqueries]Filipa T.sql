-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?

select count(inventory_id)
from sakila.inventory
where film_id in (
select film_id
from sakila.film
where title = 'Hunchback Impossible'
)
;

-- 2. List all films whose length is longer than the average of all the films.

select title, length
from sakila.film
where length > (
select round(avg(length))
from sakila.film)
;

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

select first_name, last_name
from sakila.actor
where actor_id in (
select actor_id
from sakila.film_actor fa
inner join sakila.film f
on fa.film_id = f.film_id
where f.title = 'Alone Trip'
) 
;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as family films.

select title, film_id
from sakila.film
where film_id in (
    select film_id
    from sakila.film_category fc
    inner join sakila.category c on fc.category_id = c.category_id
    where c.name = 'family'
);

-- 5. Get name and email from customers from Canada using subqueries.
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
--  that will help you get the relevant information.


select first_name, last_name, email
from sakila.customer
where address_id in (
select address_id
from sakila.address a
left join sakila.city ci
on a.city_id = ci.city_id
left join sakila.country co
on ci.country_id = co.country_id
where co.country = 'Canada'
);

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select f.film_id, f.title
from sakila.film_actor fa
join sakila.film f on fa.film_id = f.film_id
where fa.actor_id = (
select fa.actor_id
from sakila.film_actor fa
group by fa.actor_id
order by count(fa.actor_id) desc
limit 1
);



-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

select distinct f.film_id, f.title
from sakila.rental as r
left join sakila.inventory as i
on r.inventory_id = i.inventory_id
left join sakila.film as f
on i.film_id = f.film_id
where r.customer_id in (
	select customer_id
	from (
		select p.customer_id, sum(amount) as rich_customer
		from sakila.payment as p
		group by 1
		order by 2 desc
        limit 1
		) sub1
	)
order by 1
;

-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` 
-- spent by each client.

select customer_id, sum(amount) as total_amount 
from sakila.payment 
group by customer_id
having total_amount > 
(
select avg(total_amount)
from (select customer_id, sum(amount) as total_amount from sakila.payment group by customer_id) sub1
);

