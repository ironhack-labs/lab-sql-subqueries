select title, count(inventory_id) as nr_copies from sakila.film f 
inner join sakila.inventory i on f.film_id=i.film_id
group by title having title='Hunchback Impossible';

select title, length from sakila.film where length > (select avg(length) from sakila.film); 

select actor_id from sakila.film_actor a inner join 
(select * from sakila.film where title='Alone Trip') sub1 on a.film_id=sub1.film_id;

select title from sakila.category a inner join sakila.film_category b
on a.category_id = b.category_id 
inner join sakila.film c on b.film_id=c.film_id
where name='Family';

select first_name, last_name, email, country from sakila.customer cust inner join sakila.address a
on cust.address_id=a.address_id inner join sakila.city c on a.city_id=c.city_id
inner join sakila.country co on c.country_id=co.country_id
where country='Canada'; 

select title from sakila.film f 
inner join sakila.film_actor fa on f.film_id=fa.film_id
inner join (select actor_id, count(film_id) as nr_films from sakila.film_actor 
group by actor_id order by 2 desc limit 1) sub1
on fa.actor_id=sub1.actor_id;

select title from sakila.film f inner join sakila.inventory i on f.film_id=i.film_id
inner join sakila.rental r on i.inventory_id=r.inventory_id
inner join (
select c.customer_id, sum(amount) as total_amount from sakila.customer c 
inner join sakila.payment p on c.customer_id=p.customer_id
group by c.customer_id order by 2 desc limit 1) sub1
on r.customer_id=sub1.customer_id;

select c.customer_id, sum(amount) as total_amount from sakila.customer c 
inner join sakila.payment p on c.customer_id=p.customer_id
group by c.customer_id;

select avg(total_amount) from (
select c.customer_id, sum(amount) as total_amount from sakila.customer c 
inner join sakila.payment p on c.customer_id=p.customer_id
group by c.customer_id) sub1; 

select c.customer_id, sum(amount) as total_amount from sakila.customer c inner join 
sakila.payment p on c.customer_id=p.customer_id group by c.customer_id
having total_amount >
(select avg(total_amount) from (
select c.customer_id, sum(amount) as total_amount from sakila.customer c 
inner join sakila.payment p on c.customer_id=p.customer_id
group by c.customer_id) sub1);