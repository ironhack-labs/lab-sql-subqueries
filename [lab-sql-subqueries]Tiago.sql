-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select *
from (
select f.film_id, f.title, count(*)
from sakila.film f
left join sakila.inventory i
on f.film_id = i.film_id
group by  1
) sub1
where title = "Hunchback Impossible" ;

 
-- 2. List all films whose length is longer than the average of all the films.
select f.film_id, f.title, f.length
from sakila.film f
where f.length > (select avg(length) from film)
order by length desc ;


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select *
from (
select f.film_id, f.title, concat(a.first_name, ' ', a.last_name) as name
from sakila.film f
left join sakila.film_actor fa
on f.film_id = fa.film_id
left join sakila.actor a 
on a.actor_id = fa.actor_id
) sub2
where title = "Alone Trip" ;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select *
from(
select f.film_id, f.title, c.name
from sakila.film as f
left join sakila.film_category as fc
on  fc.film_id = f.film_id
left join sakila.category as c
on  c.category_id = fc.category_id
)sub3
where name = 'Family';



-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name, ' ',last_name) as name, email from sakila.customer where address_id in (
select address_id from sakila.address where city_id in (
select city_id from sakila.city where country_id in (
select country_id from sakila.country where country = "Canada")));


select concat(first_name, ' ',last_name) as name, email 
from sakila.customer cu
left join sakila.address a
on  cu.address_id = a.address_id
left join sakila.city as c
on  c.city_id = a.city_id
left join sakila.country co 
on c.country_id = co.country_id
where co.country = "Canada";


-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select title
from sakila.film where film_id in ( select film_id from film_actor where actor_id = (select actor_id from (select actor_id, count(film_id)
from sakila.film_actor
group by 1
order by 2 desc)sub1 limit 1));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select title from sakila.film where film_id in (
select film_id from sakila.inventory where inventory_id in (
select inventory_id from sakila.rental where rental_id in (
select rental_id from sakila.payment where customer_id = ( 
select customer_id from ( 
select customer_id, sum(amount) as total_amount from sakila.payment
group by customer_id
order by 1 desc
)sub1
limit 1))));




-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
select customer_id, total
from (
select customer_id, sum(amount) as total, avg(amount) as average from sakila.payment
group by 1
having average > (select avg(amount)
from sakila.payment))sub1;






