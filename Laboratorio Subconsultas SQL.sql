-- 1. ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?
USE sakila;
SELECT COUNT(*) AS Copies_of_funchback_impossible
FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE film.title = "hunchback Impossible";

-- 2. Enumere todas las películas cuya duración sea mayor que el promedio de todas las películas.
SELECT *
FROM film
WHERE length > (
	SELECT AVG(length)
    FROM film
);

-- Verificamos cual es la media, en este caso 115.
SELECT AVG(length) AS average_length
FROM film;

-- 3. Utilice subconsultas para mostrar todos los actores que aparecen en la película Alone Trip.
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
        )
);

-- 4. Las ventas se han retrasado entre las familias jóvenes y usted desea orientar la promoción a todas las películas familiares.
-- Identifique todas las películas clasificadas como películas familiares.

SELECT title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM film_category
    WHERE category_id = (
        SELECT category_id
        FROM category
        WHERE name = 'Family'
    )
);

-- 5. Obtenga el nombre y el correo electrónico de clientes de Canadá mediante subconsultas.
-- Haz lo mismo con las uniones. Tenga en cuenta que para crear una combinación,
-- deberá identificar las tablas correctas con sus claves primarias y claves externas, lo que le ayudará a obtener la información relevante.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 6. ¿Cuáles son las películas protagonizadas por el actor más prolífico?
-- Se define actor más prolífico como aquel que ha actuado en el mayor número de películas.
-- Primero tendrás que encontrar el actor más prolífico y luego usar ese actor_id para encontrar las diferentes películas que protagonizó.
SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);

-- Subconsulta  en que pelicula 
SELECT f.title AS film_title
FROM film_actor fa
JOIN film f ON fa.film_id = f.film_id
WHERE fa.actor_id = (SELECT actor_id
                     FROM film_actor
                     GROUP BY actor_id
                     ORDER BY COUNT(*) DESC
                     LIMIT 1);

-- 7. Películas alquiladas por el cliente más rentable.
-- Puede utilizar la tabla de clientes y la tabla de pagos para encontrar el cliente más rentable,
-- es decir, el cliente que ha realizado la mayor suma de pagos.
SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;

-- 8. Obtenga el client_id y el total_amount_spent de aquellos clientes que gastaron más que el promedio de lo total_amount gastado por cada cliente.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount) FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_amount_spent DESC;

