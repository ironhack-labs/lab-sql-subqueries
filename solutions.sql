use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select
count(inventory_id) as total_copies
from inventory
where film_id = (select distinct film_id from sakila.film where title = 'hunchback impossible');


-- 2. List all films whose length is longer than the average of all the films.
select distinct
sakila.film.title
from sakila.film
where sakila.film.length > (select avg(length) from sakila.film);


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select
	concat (sakila.actor.first_name, ' ', sakila.actor.last_name) as actor_name
from sakila.film_actor
	inner join sakila.film on sakila.film.film_id = sakila.film_actor.film_id
    inner join sakila.actor on sakila.actor.actor_id = sakila.film_actor.actor_id
where 
	sakila.film_actor.film_id = (select sakila.film.film_id from sakila.film where title = 'Alone Trip');
    

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select 
sakila.film.title
from sakila.film
where sakila.film.film_id in (
	select sakila.film_category.film_id from sakila.film_category where sakila.film_category.category_id = 
		(select sakila.category.category_id from sakila.category where sakila.category.name = 'family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select 
concat (sakila.customer.first_name, ' ', sakila.customer.last_name) as customer_name,
sakila.customer.email
from sakila.customer
where sakila.customer.address_id in 
	(select sakila.address.address_id from sakila.address where sakila.address.city_id in 
		(select sakila.city.city_id from sakila.city where sakila.city.country_id in 
			(select sakila.country.country_id from sakila.country where sakila.country.country = 'canada')));

select 
concat (sakila.customer.first_name, ' ', sakila.customer.last_name) as customer_name,
sakila.customer.email
from sakila.customer
	inner join sakila.address on sakila.address.address_id = sakila.customer.address_id
    inner join sakila.city on sakila.city.city_id = sakila.address.city_id
    inner join sakila.country on sakila.country.country_id = sakila.city.country_id
where sakila.country.country = 'canada';


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select sakila.film.title
from sakila.film_actor 
	inner join sakila.film on sakila.film_actor.film_id = sakila.film.film_id
where sakila.film_actor.actor_id = 
	(select sakila.film_actor.actor_id 
    from sakila.film_actor 
    group by sakila.film_actor.actor_id 
    order by count(sakila.film_actor.film_id) desc 
    limit 1);
	
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select
concat(sakila.customer.first_name,' ',sakila.customer.last_name) as customer
from sakila.customer
where sakila.customer.customer_id =
	(select sakila.payment.customer_id
    from sakila.payment
    group by sakila.payment.customer_id
    order by sum(sakila.payment.amount) desc
    limit 1);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select sakila.payment.customer_id, 
sum(sakila.payment.amount) as total_amount_spent
from sakila.payment
join (select customer_id, 
		sum(sakila.payment.amount) as total_amount 
        from sakila.payment 
        group by sakila.payment.customer_id
        ) as avg_amount -- Total amount spent by each customer_id 
        on sakila.payment.customer_id = avg_amount.customer_id
group by sakila.payment.customer_id
having sum(sakila.payment.amount) > (select avg(total_amount) from 
	(select sum(sakila.payment.amount) as total_amount from sakila.payment group by sakila.payment.customer_id) as avg_total)

   



