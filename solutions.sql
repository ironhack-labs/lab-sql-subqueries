use sakila;

-- 1
select 
	count(i.inventory_id) as num_copies
from inventory i
left join film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- 2
select 
	distinct title, 
    length
from film
where length > (select avg(length) from film);

-- 3
select 
	concat(first_name, ' ', last_name) as actor_name
from (
	select 
		f.film_id,
        f.title,
        a.first_name,
        a.last_name
	from film f
	left join film_actor fa on fa.film_id = f.film_id
    left join actor a on a.actor_id = fa.actor_id
    where f.title = 'Alone Trip'
) alone_trip;

-- 4
select
	distinct title
from (
	select
		f.film_id,
        f.title
    from film f
    join film_category fc on fc.film_id = f.film_id
    join category c on c.category_id = fc.category_id
    where c.`name` = 'Family'
    
) family_movies;

-- 5
select 
	concat(first_name, ' ', last_name) as customer_name,
    email
from (
	select 
		c.first_name,
        c.last_name,
        c.email
	from customer c
    join address a on a.address_id = c.address_id
    join city ci on a.city_id = ci.city_id
    join country co on co.country_id = ci.country_id
    where co.country = 'Canada'
) Canadian_customers;

-- 6
select 
	fa.film_id,
    f.title
from film_actor fa
left join film f on fa.film_id = f.film_id
where fa.actor_id in(
	select actor_id
	from(
		select
			actor_id,
			count(film_id) as num_movies
		from film_actor
		group by actor_id
		order by num_movies desc
		limit 1
	) prolific_actor
);

-- 7
select
	f.title,
    p.customer_id
from film f
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
left join payment p on p.rental_id = r.rental_id
where p.customer_id in (
	select customer_id 
	from (
		select 
			customer_id,
			sum(amount) as total_spent
		from payment
		group by customer_id
		order by total_spent desc
		limit 1
	) most_profitable_customer
);

-- 8
select
	customer_id as client_id,
    sum(amount) as total_amount_spent
from payment
group by client_id
having total_amount_spent > (
	select 
		avg(total_spent) as avg_total_spent
	from (
		select
			customer_id,
			sum(amount) as total_spent
		from payment
		group by customer_id
	) total_spent_each_customer
);






