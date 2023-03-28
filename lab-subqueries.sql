-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM(
SELECT f.title, count(inventory_id) as numb_copies
FROM sakila.inventory
JOIN sakila.film f USING (film_id)
GROUP BY film_id
HAVING title = "Hunchback Impossible") sub1;

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM sakila.film
WHERE length > (SELECT avg(length) FROM sakila.film)
ORDER BY length asc;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM(
SELECT a.first_name, a.last_name,f.title FROM sakila.film_actor
JOIN sakila.actor a USING (actor_id)
JOIN sakila.film f USING (film_id)
HAVING title = 'Alone Trip')sub1;

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT * FROM(
SELECT f.title, c.name FROM sakila.film_category fc
JOIN sakila.film f ON fc.film_id = f.film_id
JOIN sakila.category c ON fc.category_id = c.category_id
GROUP BY 1
HAVING name = 'Family')sub1;

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT * FROM(
SELECT c.first_name, c.last_name, co.country
FROM sakila.customer c
LEFT JOIN sakila.address a USING (address_id)
LEFT JOIN sakila.city ci USING (city_id)
LEFT JOIN sakila.country co USING (country_id)
WHERE country = "Canada") sub1;

SELECT c.first_name, c.last_name, co.country
FROM sakila.customer c
LEFT JOIN sakila.address a USING (address_id)
LEFT JOIN sakila.city ci USING (city_id)
LEFT JOIN sakila.country co USING (country_id)
WHERE country = "Canada";


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

 # DISCOVERING THE ACTOR
SELECT * FROM (
SELECT a.first_name, a.last_name, actor_id, count(actor_id) as counts
from sakila.film_actor fa
JOIN sakila.actor a USING (actor_id)
GROUP BY actor_id
ORDER BY counts desc
LIMIT 1)sub1;

 # DISCOVERING THE FILMS
SELECT title, actor_id
FROM sakila.film
JOIN sakila.film_actor USING (film_id)
WHERE actor_id IN ('107');

#WITH SUBQUERIES NOW
SELECT * FROM (
SELECT a.first_name, a.last_name, actor_id, count(actor_id) as counts
from sakila.film_actor fa
JOIN sakila.actor a USING (actor_id)
GROUP BY actor_id
ORDER BY counts desc
LIMIT 1)sub1;


-- 7. Films rented by most profitable customer. 
# You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
 
 # DISCOVERING THE customer

SELECT c.customer_id, c.first_name, c.last_name, 
(SELECT SUM(amount) FROM sakila.payment WHERE customer_id = c.customer_id) AS totalpayments
FROM sakila.customer c
ORDER BY totalpayments DESC
LIMIT 1;
             

# DISCOVERING THE films
SELECT f.title, p.customer_id
FROM sakila.film f
JOIN sakila.inventory i USING (film_id)
JOIN sakila.rental r ON r.inventory_id = i.inventory_id
JOIN sakila.payment p ON r.rental_id = p.rental_id
WHERE p.customer_id = (SELECT c.customer_id
FROM sakila.customer c
JOIN sakila.payment p USING (customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1
);

-- 8.Get the client_id and the total_amount_spent of those clients 
# who spent more than the average of the total_amount spent by each client.

 -- I USED CHATGTP ON THIS - I WAS ALMOST THERE BUT NOT THERE YET :/ 
 
SELECT c.customer_id, SUM(p.amount) as total_amount_spent
FROM sakila.customer c
JOIN sakila.payment p USING (customer_id)
GROUP BY c.customer_id
HAVING SUM(p.amount) > (
  SELECT AVG(total_amount_spent_per_customer)
  FROM (
    SELECT customer_id, SUM(amount) as total_amount_spent_per_customer
    FROM sakila.payment
    GROUP BY customer_id
  ) AS t
)
ORDER BY c.customer_id;


