SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address a
    JOIN city c ON a.city_id = c.city_id
    JOIN country co ON c.country_id = co.country_id
    WHERE co.country = 'Canada'
);
