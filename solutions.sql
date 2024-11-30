-- Add you solution queries below:
#How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(i.inventory_id) AS num_hunch
FROM sakila.inventory i
WHERE i.film_id = (SELECT film_id FROM sakila.film WHERE title = 'Hunchback Impossible');

#List all films whose length is longer than the average of all the films.
select f.title, f.length
from sakila.film f
where length > (select avg(length) from sakila.film)
order by length;

#Use subqueries to display all actors who appear in the film Alone Trip.
select  concat(first_name,' ',last_name) as actor_name
from sakila.actor
where actor_id in (select ft.actor_id from sakila.film f inner join film_actor ft
on f.film_id = ft.film_id and f.title = 'Alone Trip');


#Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
select distinct title from film
where film_id in (
select film_id from film_category
where category_id in (
select category_id from category 
where name = 'Family')); 

#Get name and email from customers from Canada using subqueries. 
#Do the same with joins. Note that to create a join, you will have to identify the correct tables 
#with their primary keys and foreign keys, that will help you get the relevant information.
select concat(cust.first_name,' ',cust.last_name) as customer_name,
       cust.email
from customer as cust
inner join store as s
on cust.store_id = s.store_id
inner join address a
on s.address_id = a.address_id
inner join city c
on a.city_id = c.city_id
inner join country ct
on c.country_id = ct.country_id
and ct.country = 'Canada';


#Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id 
#to find the different films that he/she starred.
select f.film_id, f.title
from film as f
where film_id in (select film_id
from film_actor as fa
where fa.actor_id in 
(select actor_id as prolific_actor
from film_actor
group by actor_id
having count(film_id) = (select max(num_films) from 
(select count(film_id) as num_films
from film_actor
group by actor_id)as tab )));


#Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable customer 
#i.e. the customer that has made the largest sum of payments
with cust_rank as 
(select customer_id , dense_rank() over (order by total_revenue) as rnk
from (
select customer_id, 
	   sum(amount) total_revenue
from payment
group by customer_id) as tbl)
select f.title
from film as f
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
and r.customer_id in (select customer_id from cust_rank
where rnk = 1);

#Get the client_id and the total_amount_spent of those clients 
#who spent more than the average of the total_amount spent by each client.
select customer_id, sum(amount) as total_spent
from payment
group by customer_id
having sum(amount) > (select avg(total_spent)
from (select sum(amount) as total_spent from payment group by customer_id) as tbl);