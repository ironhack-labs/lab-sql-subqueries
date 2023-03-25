SELECT
      i.film_id,
      f.title,
      count(*) as film_count
FROM sakila.film f
JOIN sakila.inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY 1,2;

SELECT 
      title
FROM sakila.film 
WHERE length > (SELECT 
                      avg(length) 
				FROM sakila.film);

SELECT
      a.first_name,
      a.last_name
FROM sakila.actor a
WHERE a.actor_id IN (SELECT
                           fa.actor_id
					 FROM sakila.film_actor fa
                     JOIN sakila.film f ON f.film_id = fa.film_id
                     WHERE f.title = 'Alone Trip');
                     
SELECT
      title
FROM sakila.film f
WHERE f.film_id IN (SELECT
                          fc.film_id
					FROM sakila.film_category fc
                    JOIN sakila.category c ON c.category_id = fc.category_id
                    WHERE c.name = 'Family');
                    
SELECT
      cu.first_name,
      cu.email
FROM sakila.customer cu
WHERE cu.address_id IN (     
                      SELECT
						   a.address
					  FROM sakila.address a
                      JOIN sakila.city ci ON ci.city_id = a.city_id
                      JOIN sakila.country c ON c.country_id = ci.country_id
                      WHERE c.country = 'Canada');


SELECT
	  title
FROM sakila.film
WHERE film_id IN (SELECT
	                    film_id
                  FROM sakila.inventory
                  WHERE inventory_id IN (SELECT
	                                       inventory_id
					FROM sakila.rental
					WHERE customer_id = (SELECT
	                                                           customer_id
                                                              FROM sakila.payment
                                                              GROUP BY customer_id
                                                              ORDER BY SUM(amount) DESC
                                                              LIMIT 1)));
                                                              
SELECT 
	customer_id,
    SUM(amount) AS total_amount
FROM sakila.payment
GROUP BY customer_id
HAVING total_amount > (SELECT 
							 AVG(total_amount) 
					   FROM (SELECT 
								   customer_id, 
								   SUM(amount) AS total_amount
                             FROM sakila.payment
                             GROUP BY customer_id) 
						AS t);
