-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select *
from sakila.inventory
where film_id in (
	select film_id
	from sakila.film
	where title = 'Hunchback Impossible'
	)
;
-- Query to check output
select *
from sakila.film
where film_id = 439
;

-- 2. List all films whose length is longer than the average of all the films.
select film_id, title, length
from sakila.film
where length > (
	select avg(length)
    from sakila.film
    )
;

-- 3. Use subqueries to display all actors who appear in the film 'Alone Trip'.
select a.first_name, a.last_name, 
	(select f.title
    from sakila.film as f
    where fa.film_id = f.film_id
    ) as title
from sakila.actor as a
left join sakila.film_actor as fa
on a.actor_id = fa.actor_id
where 
	(
	select f.title 
    from sakila.film as f
    where fa.film_id = f.film_id
    ) = 'Alone Trip'
;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select *
from sakila.film
left join sakila.film_category as fc
on fc.film_id = film.film_id
where fc.category_id in (
	select category_id
	from sakila.category
	where name = 'Family'
	)
;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys
--    and foreign keys, that will help you get the relevant information.

-- Solution with subqueries
select first_name, last_name, email
from sakila.customer
where address_id in (
	select address_id
    from sakila.address
    where city_id in (
		select city_id
        from sakila.city
        where country_id in (
			select country_id
            from sakila.country
            where country = 'Canada'
            )
		)
	)
;

-- Solution with joins
select c.first_name, c.last_name, c.email, co.country
from sakila.customer as c
join sakila.address as a 
on c.address_id = a.address_id
join sakila.city as ci 
on a.city_id = ci.city_id
join sakila.country as co 
on ci.country_id = co.country_id
where co.country = 'Canada'
order by 1
;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific
--    actor and then use that actor_id to find the different films that he/she starred.
select *
from sakila.film
where film_id in (
	select film_id 
    from sakila.film_actor
    where actor_id in (
		select actor_id
        from 
			(select actor_id, count(film_id) as number_of_movies
			from sakila.film_actor
			group by 1
			order by 2 desc
            limit 1
			) sub1
		)
	)
;
-- First step showed that 'GINA	DEGENERES' is the most prolific actress.
-- Second step showd that 'BED HIGHBALL' is the movie she has starred in the most

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select distinct f.film_id, f.title
from sakila.rental as r
left join sakila.inventory as i
on r.inventory_id = i.inventory_id
left join sakila.film as f
on i.film_id = f.film_id
where r.customer_id in (
	select customer_id
	from (
		select p.customer_id, sum(amount) as sum_payments
		from sakila.payment as p
		group by 1
		order by 2 desc
        limit 1
		) sub1
	)
order by 1
;
-- Step 1 showed that the customer with the customers_id 526 (KARL SEAL) is the most profitable customer with 221.55 € spent.
-- Step 2 showed that this customer rented out 44 movies in total to date.

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as total_amount_spent
from sakila.payment
group by 1
having total_amount_spent > (
	select avg(amount)
    from sakila.payment
    )
order by 2 desc
;
