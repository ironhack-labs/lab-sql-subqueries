-- 1. How many copies of the film _Hunchback Impossible_ exist in the inventory system?
select fil.title, count(inv.inventory_id) count_inventory
from sakila.inventory inv
left join sakila.film fil
on inv.film_id = fil.film_id
group by 1
having fil.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films. avg = 115.2720
select title, length from sakila.film
where length >
	(select avg(length) from sakila.film)
order by 2 desc;

-- 3. Use subqueries to display all actors who appear in the film _Alone Trip_.

select fa.actor_id, concat(a.first_name, " ", a.last_name) as actor_name
from sakila.film_actor fa
left join sakila.actor a
on fa.actor_id = a.actor_id
where film_id =
(
	select film_id from sakila.film
	where title = "alone trip"
    );
    
-- no sub-query
select actor_id, title 
from sakila.film_actor fa
left join sakila.film f
on fa.film_id = f.film_id
where f.title = "alone trip";

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
select film_id, title , description, special_features
from sakila.film
where film_id in  
(
	select fc.film_id 
	from sakila.film_category fc
	left join sakila.category c
	on fc.category_id = c.category_id
	where c.name = "family"
    )
and film_id is not null;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- Using SUBQUERIES
 select * from sakila.customer
 where address_id in (
    select address_id from sakila.address
	where city_id in (
		select city_id from sakila.city
		where country_id = 
		(
			select country_id from sakila.country
			where country = 'canada'
			)
	)
)
order by customer_id desc;

-- using join
select * from sakila.customer c
left join sakila.address a
on c.address_id=a.address_id
left join sakila.city ci
on a.city_id = ci.city_id
left join sakila.country co
on ci.country_id = co.country_id
where co.country = 'canada'
order by customer_id desc;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from sakila.film
where film_id in (
	select film_id from sakila.film_actor
	where actor_id =
	(
		select actor_id from (
			select actor_id, count(actor_id) from sakila.film_actor
			group by 1
			order by 2 desc
			limit 1) sub1
	)
)
;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most 
-- profitable customer ie the customer that has made the largest sum of payments
select * from sakila.customer 
where customer_id = (
	select customer_id from (
		select customer_id, sum(amount) from sakila.payment
		group by 1
		order by sum(amount) desc
		limit 1)sub1
)
    ;
-- 8. Get the `client_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` 
-- spent by each client.

	select customer_id, round(avg(amount),2) as avg_tot_amount from sakila.payment 
	where amount > (
		select avg(amount) from sakila.payment
		)
group by 1
order by 2 desc;