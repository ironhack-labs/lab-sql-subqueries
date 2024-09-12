-- 1) How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title, count(*) as number_of_copies
from sakila.inventory inventory
left join sakila.film film on inventory.film_id = film.film_id
group by film.title
having film.title = "Hunchback Impossible";

-- 2) Listing all films whose length is longer than the average of all the films
select title, length
from sakila.film
where length > (select avg(length) as average_length from sakila.film);

-- 3) Using subqueries to display all actors who appear in the film Alone Trip
select a1.first_name, a1.last_name
from sakila.actor a1
right join (
select *
from sakila.film_actor
where film_id = (select film_id from sakila.film where title = "Alone Trip")
) a2 on a1.actor_id = a2.actor_id;

-- 4) Identifying all movies categorized as family films
select f2.title
from sakila.film_category f1
left join sakila.film f2 on f1.film_id = f2.film_id
where category_id = (select category_id from sakila.category where name = "Family");

-- 5. a) Geting name and email from customers from Canada using subqueries
select first_name, last_name, email
from sakila.customer
where address_id in
(
	select address_id
	from sakila.address
	where city_id in
	(
	select city_id
	from sakila.city
	where country_id = 
		(
		select country_id
		from sakila.country
		where country = "Canada"
		)
	)
);

-- 5. b) Geting name and email from customers from Canada using joins
select customer.first_name, customer.last_name, customer.email
from sakila.customer customer
left join sakila.address address on customer.address_id = address.address_id
left join sakila.city city on address.city_id = city.city_id
left join sakila.country country on city.country_id = country.country_id
where country = "Canada";

-- 6) Which are films starred by the most prolific actor?
select title
from sakila.film_actor actor
left join sakila.film film on actor.film_id = film.film_id
where actor_id = 
(select actor_id
from sakila.film_actor
group by actor_id
order by count(*) desc
limit 1);

-- 7) Displaying the films rented by most profitable customer
select distinct title
from sakila.rental rental
left join sakila.inventory inventory on rental.inventory_id = inventory.inventory_id
left join sakila.film film on inventory.film_id = film.film_id
where customer_id =
(select customer_id
from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1);

-- 8) Getting the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client
select customer_id, sum(amount) as total_amount 
from sakila.payment 
group by customer_id
having total_amount > 
(
select avg(total_amount)
from (select customer_id, sum(amount) as total_amount from sakila.payment group by customer_id) sub1
);