-- How many copies of the film Hunchback Impossible exist in the inventory system?

select count(f.title) as number_copies
from sakila.inventory i 
inner join sakila.film f
on i.film_id = f.film_id
where f.title regexp 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films.

select title
from sakila.film
where length > ( 
select avg(length)
from sakila.film
);

-- Use subqueries to display all actors who appear in the film Alone Trip.

select a.first_name, a.last_name
from sakila.film_actor af
inner join sakila.actor a
on af.actor_id = a.actor_id
inner join sakila.film f
on af.film_id = f.film_id
where title in (select title 
from sakila.film
having title = 'Alone Trip');

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select title
from sakila.film
where film_id in (select film_id
from sakila.film_category
where category_id in (
select category_id
from sakila.category
where name = 'Family'));

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- using subqueries

select cy.first_name, cy.last_name, cy.email
from sakila.customer cy
inner join sakila.address a using (address_id)
inner join sakila.city cc using (city_id)
inner join sakila.country c using (country_id)
where c.country = 'Canada';

-- using joins 
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
where country = 'Canada')));

-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 

-- finding the most prolifc actor

select actor_id, count(distinct film_id)
from sakila.film_actor
group by actor_id
order by 2 desc
limit 1;

select title 
from sakila.film
where film_id in 
	(select film_id
	from sakila.film_actor
    where actor_id in (select actor_id from (select actor_id, count(film_id)  from sakila.film_actor
			group by 1
			order by 2 desc
			limit 1) sub1
)
 ) 
 ;

-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer 
-- ie the customer that has made the largest sum of payments

-- finding the most profitable customer
select customer_id, sum(amount) as Total_amount
from sakila.payment
group by 1
order by 2 desc
limit 1;

select f.title from sakila.rental r
inner join sakila.inventory i using (inventory_id)
inner join sakila.film f using (film_id)
where customer_id in (select customer_id from (select customer_id, sum(amount) as Total_amount
from sakila.payment
group by 1
order by 2 desc
limit 1)Sub );


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount
--  spent by each client.

select customer_id, sum(amount) as Total_amount 
from sakila.payment
group by customer_id
having Total_amount > 
	(select avg(total_amount) 
	from (select customer_id, sum(amount) as total_amount from sakila.payment
	group by customer_id) sub)
	order by Total_amount desc;