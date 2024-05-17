-- How many copies of the film Hunchback Impossible exist in the inventory system?

select * from sakila.inventory;

select f.title, i.film_id, count(i.inventory_id)
from sakila.inventory i
left join sakila.film f
on f.film_id = i.film_id
where 3 = 'Hunchback'
group by 1, 2;

-- List all films whose length is longer than the average of all the films.

select * from sakila.film;

select title, length, avg(length) as avg
from sakila.film
where length > (select avg(length) FROm sakila.film)
group by 1, 2 
order by 3 desc;

-- Use subqueries to display all actors who appear in the film Alone Trip.

select * from sakila.film;

select * from sakila.film_actor;

select * from sakila.actor;

select * from sakila.inventory;

select * from sakila.film_text;

select a.first_name, a.capital_surname, f.title
from sakila.actor a
left join sakila.film_actor fa
on a.actor_id = fa.actor_id 
left join sakila.film f
on fa.film_id = f.film_id
where f.title = 'Alone trip';

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select * from sakila.category;

select * from sakila.film;

select * from sakila.rental;

select * from sakila.inventory;

select * from sakila.film_actor;

select * from sakila.film_text;

select * from sakila.film_category;

select f.title, c.name
from sakila.film f
left join sakila.film_category fm
on f.film_id = fm.film_id
left join sakila.category c
on fm.category_id = c.category_id
where c.name = 'Family';

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select * from sakila.customer;

select * from sakila.address;

select * from sakila.city;

select * from sakila.country;

select c.first_name, c.last_name, c.email, co.country
from sakila.customer  c
left join sakila.address a
on c.address_id = a.address_id
left join sakila.city ci
on a.city_id = ci.city_id
left join sakila.country co
on ci.country_id = co.country_id
where co.country = 'Canada'
order by 1 asc;


select c.first_name, c.last_name, c.email
from sakila.customer c
where address_id in (
select address_id
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id = (
select country_id 
from sakila.country co
where country = 'Canada'
)
)
);

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select *
from sakila.film;

select * from sakila.actor;

select * from sakila.film_actor;

select * from sakila.film_text;

select a.actor_id, count(f.title)
from sakila.actor a
left join sakila.film_actor fa
on a.actor_id = fa.actor_id
left join sakila.film f
on fa.film_id = f.film_id
group by 1
order by 2 desc;

select f.title, a.actor_id
from sakila.film f
left join sakila.film_actor fa
on f.film_id = fa.film_id 
left join sakila.actor a
on fa.actor_id = a.actor_id
where a.actor_id = '107';   

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
 
 select * from sakila.customer;
 
 select * from sakila.payment;
 
 select * from sakila.inventory;
 
 select * from sakila.rental;
 
 select * from sakila.film;
 
 select * from sakila.film_actor;
 
 select  * from sakila.film_text;
 
 select c.customer_id, c.first_name, count(p.rental_id)
 from sakila.customer c
 left join sakila.payment p
 on c.customer_id = p.customer_id
 group by 1, 2
 order by 3 desc;
 

select f.title, c.first_name, c.last_name, c.customer_id
from sakila.film f
left join sakila.inventory i
on f.film_id = i.film_id
left join sakila.rental r
on i.inventory_id = r.inventory_id
left join sakila.customer c
on r.customer_id = c.customer_id
where c.customer_id = '148'
order by 1 asc;


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, total_amount
from (
select customer_id, sum(amount) as total_amount
from sakila.payment
group by customer_id
) as customer_totals
where total_amount > (
select avg(total_amount)
from (
select sum(amount) as total_amount
from sakila.payment
group by customer_id
) as avg_totals
);


