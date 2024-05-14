-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*) as 'copies of Hunchback Impossible'
from sakila.inventory
where film_id in (
	select film_id from sakila.film 
	where title = 'Hunchback Impossible');

-- List all films whose length is longer than the average of all the films.
select title
from sakila.film
where length > (
	select avg(length) from sakila.film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) AS actors_names from sakila.actor
where actor_id in(
	select actor_id from sakila.film_actor
	where film_id in (
		select film_id from sakila.film
		where title = 'Alone Trip'));
        
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
	-- Identify all movies categorized as family films.
select title as 'Family films' from sakila.film
where film_id in(
	select film_id from sakila.film_category
	where category_id in (
		select category_id from sakila.category
		where name = 'Family'));

-- Get name and email from customers from Canada using subqueries. 
	-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
 select first_name, last_name, email from sakila.customer
 where address_id in(
 select address_id from sakila.address
 where city_id in(
	select city_id from sakila.city
	where country_id in(
		select country_id from sakila.country
		where country = 'Canada')));
        
select first_name, last_name, email from sakila.customer c
left join sakila.address ad
on c.address_id = ad.address_id
left join sakila.city ct
on ad.city_id = ct.city_id
left join sakila.country co
on ct.country_id = co.country_id
where country = 'Canada';

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in most films. 
	-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select title as 'films starred by the most prolific actor' from ( 
	select title from sakila.film
		where film_id in (
			select film_id from sakila.film_actor
			where actor_id in (
				select actor_id from (
					select actor_id, count(film_id) as count_films from sakila.film_actor
					group by 1 having count_films = (
						SELECT MAX(count_films) from (
						select actor_id, count(film_id) as count_films from sakila.film_actor
						group by 1) SUB1)
				) SUB2
                    )
			)) SUB_PRINCIPAL;
    

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT * FROM SAKILA.CUSTOMER;
SELECT * FROM SAKILA.PAYMENT;
SELECT * FROM SAKILA.RENTAL;
SELECT * FROM SAKILA.INVENTORY;
SELECT * FROM SAKILA.FILM;

select title as 'Films rented by most profitable customer' from ( 
	select title from sakila.film
		where film_id in (
			select film_id from sakila.inventory
            where inventory_id in (
				select inventory_id from sakila.rental
				where customer_id in (
					select customer_id from sakila.customer
					where customer_id in (
						select customer_id from (
							select customer_id, sum(amount) as total_profit from sakila.payment
							group by 1 having total_profit = (
								select MAX(total_profit) from (
								select customer_id, sum(amount) as total_profit from sakila.payment
								group by 1) SUB1)
						) SUB2 ))))
					)SUB_PRINCIPAL;
             
-- Get the customer_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
with cte_profitable_customers as (
	select customer_id, sum(amount) as 'total_amount_spent'
	from sakila.payment
	group by 1)
select * from cte_profitable_customers
where total_amount_spent > (select avg(total_amount_spent) from cte_profitable_customers);
