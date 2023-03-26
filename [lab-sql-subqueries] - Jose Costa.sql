#1. How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;

select f.title as movie, count(*) AS copies
from inventory i
join film f on i.film_id = f.film_id
where f.title = 'Hunchback Impossible';

#2. List all films whose length is longer than the average of all the films.
select avg(length) as avg_length from film;

select title, length from film
where length > (
select avg(length) as avg_length from film) order by length;

#3. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor a 
where actor_id in (select actor_id from film_actor fa left join film f using(film_id)
where f.title="Alone Trip");

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film
join film_category fc using(film_id)
join category c using (category_id)
where c.name="Family";

#5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
# Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name, last_name, email from customer where address_id in(
	select address_id from address where city_id in (
		select city_id from city where country_id in (
			select country_id from country where country="CANADA")));
            
select first_name, last_name, email from customer c
join address a using(address_id)
join city ci using(city_id)
join country co using(country_id)
where co.country="CANADA";

#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select actor_id, count(*) as appearances from film_actor group by actor_id order by count(*) desc limit 1;

select f.film_id, f.title from film f
join film_actor fa using(film_id)
join (select actor_id from film_actor group by actor_id order by count(*) desc limit 1) sub1 using(actor_id) 
group by f.film_id;

#7. Films rented by most profitable customer. 
# You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select customer_id,count(amount) as amo from payment group by customer_id order by amo desc limit 1;

select f.film_id, f.title, sum(p.amount) as total_revenue from film f
join inventory i using(film_id)
join rental r using(inventory_id)
join payment p using(rental_id)
join (select customer_id from payment group by customer_id order by sum(amount) desc limit 1) sub1 on p.customer_id = sub1.customer_id
group by f.film_id, f.title order by total_revenue desc;

#8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id as client_id, sum(amount) as total_amount_spent from payment
	group by client_id
    having
		total_amount_spent > (
    select 
		avg(total_amount_spent) from 
			(select sum(amount) as total_amount_spent from payment group by customer_id)sub1) 
	order by total_amount_spent
    ;
    