# Conducts the tasks requested in the SQL subqueries lab assignment.
USE sakila;

# 1 - Determines the number of copies of Hunchback Impossible that exist in the inventory system.
SELECT f.title,
       COUNT(i.inventory_id) AS number_of_copies
FROM film AS f
JOIN inventory AS i 
    ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

# 2 - Lists all films whose length is longer than the average length of all films
SELECT title,
       length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

# 3 - Displays all actors who appear in the film Alone Trip
SELECT a.first_name,
       a.last_name
FROM actor AS a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film AS f
        ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);

# 4 - Identifies all movies categorized as family films
SELECT f.title
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON fc.category_id = c.category_id
WHERE c.name = 'Family';

#5a - Obtains the name and email from Canada customers (subquery approach)
SELECT c.first_name,
       c.last_name,
       c.email
FROM customer AS c
WHERE c.address_id IN (
    SELECT a.address_id
    FROM address AS a
    WHERE a.city_id IN (
        SELECT ci.city_id
        FROM city AS ci
        WHERE ci.country_id = (
            SELECT co.country_id
            FROM country AS co
            WHERE co.country = 'Canada'
        )
    )
);

# 5b - Obtains the name and email from Canada customers (join approach)
SELECT c.first_name,
       c.last_name,
       c.email
FROM customer AS c
JOIN address AS a
    ON c.address_id = a.address_id
JOIN city AS ci
    ON a.city_id = ci.city_id
JOIN country AS co
    ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

# 6a Finds the films starred by the most prolific actor (shows the actor_id)
SELECT fa.actor_id,
       COUNT(*) AS film_count
FROM film_actor AS fa
GROUP BY fa.actor_id
ORDER BY film_count DESC
LIMIT 1;

# 6b - finds all the films that the actor in 6a starred in
# Uses the actor_id obtained in 6a
SELECT f.title
FROM film AS f
JOIN film_actor AS fa
    ON f.film_id = fa.film_id
WHERE fa.actor_id = 107; -- actor_id from step 6a

# 7a - Finds the most profitable customer
# Most profitable is defined as the customer with the largest total payments
SELECT p.customer_id,
       SUM(p.amount) AS total_spent
FROM payment AS p
GROUP BY p.customer_id
ORDER BY total_spent DESC
LIMIT 1;

# 7b - finds the films rented by the most profitable customer
# Uses the customer_id from 7a
SELECT DISTINCT f.title
FROM rental AS r
JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
JOIN film AS f
    ON i.film_id = f.film_id
WHERE r.customer_id = 526;  -- customer_id from step 7a

/* 8 - Finds the customer_id(client_id) and the total amount spent for those who spent
more than the average of what each client spends */
SELECT t.customer_id,
       t.total_spent
FROM
(
    -- Subquery: total spent by each customer
    SELECT p.customer_id,
           SUM(p.amount) AS total_spent
    FROM payment AS p
    GROUP BY p.customer_id
) AS t
WHERE t.total_spent > (
    -- Compare to average of total_spent across all customers
    SELECT AVG(t2.total_spent)
    FROM (
        SELECT p2.customer_id,
               SUM(p2.amount) AS total_spent
        FROM payment AS p2
        GROUP BY p2.customer_id
    ) AS t2
);