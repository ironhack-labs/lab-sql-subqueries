select* from sakila.inventory; 
select* from sakila.film;
select count(*) as 'number_copies'
from sakila.inventory
left join sakila.film using (film_id)
where title = 'Hunchback Impossible';

select* from sakila.film;
select title, length
from sakila.film
where length > (
    select avg(length)
    from sakila.film )
order by 2 desc, 1 asc;

select a.first_name, a.last_name
from sakila.actor a
where a.actor_id in (
    select fa.actor_id
    from sakila.film_actor fa
    where fa.film_id = (
        select f.film_id
        from sakila.film f
        where f.title = 'Alone Trip'
    )
);

select category_id, count(film_id)
from sakila.film
inner join sakila.film_category fc using (film_id)
inner join sakila.category c using(category_id)
where c.name = "Family"
group by category_id
order by 1, 2 asc;


select* from sakila.customer;
select* from sakila.country;
select 	first_name, last_name
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
)
order by 1 asc;

select* from sakila.film;
select* from sakila.actor;
select film.title
from sakila.film
inner join sakila.film_actor fa using (film_id)
where fa.actor_id = (
    select actor_id
    from (
        select
        actor_id, 
        count(*) as film_count
        from sakila.film_actor
        group by actor_id
        order by film_count asc
    ) as most_prolific_actor
    limit 1
);

select customer_id, count(amount) as 'amount' 
from sakila.payment 
group by customer_id 
order by amount desc;

select f.film_id, f.title, sum(p.amount) as 'total_revenue'
from sakila.film f
inner join sakila.inventory i using(film_id)
inner join sakila.rental r using(inventory_id)
inner join sakila.payment p using(rental_id)
inner join  (select customer_id 
from sakila.payment 
group by customer_id 
order by sum(amount) desc) sub1 on p.customer_id = sub1.customer_id
group by 1,2 
order by total_revenue desc;

select c.customer_id as client_id, sum(p.amount) as 'total_amount_spent'
from sakila.customer c
inner join sakila.payment p using (customer_id)
where c.customer_id in (
    select customer_id
    from sakila.payment
    group by customer_id
    having sum(amount) > (
        select avg(total)
        from (
            select customer_id, sum(amount) as 'total'
            from sakila.payment
           group by customer_id
        ) as payment_totals
    )
)
group by c.customer_id
order by 1, 2 desc;















