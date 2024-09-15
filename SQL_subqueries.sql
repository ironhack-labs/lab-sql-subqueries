-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
select film_id, count(inventory_id) as inventory_for_film
from sakila.inventory 
where film_id in (select film_id from sakila.film where title = 'Hunchback Impossible')
group by film_id;

-- 2.List all films whose length is longer than the average of all the films.

select title
from sakila.film 
where length > (select round(avg(length)) from sakila.film) 
order by title;

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) as actors_present
from sakila.actor 
where actor_id in (select distinct actor_id from sakila.film_actor 
where film_id = (select film_id from sakila.film where title = 'Alone Trip'));

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title 
from sakila.film 
where film_id in (select film_id from sakila.film_category 
where category_id = (select category_id from sakila.category where name = 'Family'));


-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
		-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name, ' ', last_name) as customer_name, email from sakila.customer 
where address_id in (select address_id from sakila.address 
where city_id in (select city_id from sakila.city where country_id = (select country_id from sakila.country where country='Canada')));
 
 -- joins
 select 
	concat(first_name, ' ', last_name) as customer_name, 
	email 
from sakila.customer c
	join sakila.address a on c.address_id = a.address_id
	join sakila.city ci on a.city_id = ci.city_id
	join sakila.country cou on ci.country_id = cou.country_id
where country = 'Canada';
        
-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
        -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select title 
from sakila.film 
where film_id in (select film_id from sakila.film_actor 
where actor_id =(select actor_id from (select actor_id, count(film_id) as actor_in_films from sakila.film_actor 
group by actor_id
order by actor_in_films desc
limit 1
) as actor_in_most_films
)
)order by title;

-- or 


select title
from sakila.film_actor actor
left join sakila.film film on actor.film_id = film.film_id
where actor_id = (select actor_id from sakila.film_actor
group by actor_id
order by count(*) desc
limit 1);

-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer 
		-- ie the customer that has made the largest sum of payments
select distinct title
from sakila.rental r
left join sakila.inventory i on r.inventory_id= i.inventory_id
left join sakila.film f on i.film_id=f.film_id
where customer_id =
(select customer_id from sakila.payment group by customer_id order by sum(amount) limit 1 
);
        
        
-- 8.Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, sum(amount) as total_amount_spent 
from sakila.payment
group by customer_id
having total_amount_spent > (select avg(total_amount_spent)
from (select customer_id, sum(amount) as total_amount_spent from sakila.payment group by customer_id) sub1
)
order by total_amount_spent desc;