# 1 - How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title,count(*)
from sakila.inventory i
join film f on i.film_id = f.film_id
where title = 'Hunchback Impossible'
;

# 2 - List all films whose length is longer than the average of all the films.
select title  
from sakila.film
where length > (select avg(length) from sakila.film)
order by length desc
limit 10
;

#3 - Use subqueries to display all actors who appear in the film Alone Trip.

select a.first_name, a.last_name 
from sakila.actor a
where a.actor_id in (
  select fa.actor_id 
  from sakila.film f
  join sakila.film_actor fa ON fa.film_id = f.film_id
  where f.title = 'Alone Trip'
);

#4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.

select f.title , c.name
from sakila.film f
join sakila.film_category fc on f.film_id = fc.film_id
join sakila.category c on fc.category_id = c.category_id
where c.name = 'Family';


# 5 - Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
#you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select c.first_name,c.last_name,c.email 
from sakila.customer c
join address a on c.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join country ca on ca.country_id = ci.country_id
where ca.country = 'Canada'
order by c.first_name asc
;

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
);

#6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select f.title
from sakila.film_actor fa
join sakila.film f on f.film_id = fa.film_id
where fa.actor_id = (select actor_id from film_actor group by actor_id order by count(*) desc limit 1)
;

#7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has
# made the largest sum of payments

select f.title
from sakila.inventory i
join sakila.rental r on i.inventory_id = r.inventory_id
join sakila.film f on  i.film_id = f.film_id
join sakila.customer c on r.customer_id = c.customer_id
where c.customer_id = (select c.customer_id
from sakila.payment p
join sakila.customer c on c.customer_id = p.customer_id
group by c.customer_id
order by sum(p.amount) desc
limit 1);

#8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
 
select p1.customer_id, sum(p1.amount) as total_amount_spent 
from sakila.payment p1
where p1.customer_id in (
select p2.customer_id
from sakila.payment p2
where p2.amount > (select avg(p3.amount) from sakila.payment p3) 
group by p2.customer_id
order by sum(p2.amount) desc )
group by p1.customer_id
order by total_amount_spent desc
;

