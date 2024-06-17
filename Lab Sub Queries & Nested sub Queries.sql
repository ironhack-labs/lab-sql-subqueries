-- Lab | Sub Queries & Nested sub Queries
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT FILM_ID, COUNT(INVENTORY_ID) AS COPIES
FROM SAKILA.INVENTORY
WHERE FILM_ID = 439
GROUP BY FILM_ID;

SELECT COPIES
	FROM (
		SELECT FILM_ID, COUNT(INVENTORY_ID) AS COPIES
		FROM SAKILA.INVENTORY
		WHERE FILM_ID = (
			SELECT FILM_ID FROM SAKILA.FILM
			WHERE TITLE = 'Hunchback Impossible'
		) 
	GROUP BY FILM_ID
	) SUB1
;

-- 2.List all films whose length is longer than the average of all the films.
SELECT AVG(LENGTH) AS AVG_LENGTH
FROM SAKILA.FILM;

SELECT FILM_ID
FROM SAKILA.FILM
WHERE LENGTH > (
	SELECT AVG(LENGTH) AS AVG_LENGTH
	FROM SAKILA.FILM
);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT FILM_ID
FROM SAKILA.FILM
WHERE TITLE = 'Alone Trip';

SELECT ACTOR_ID FROM SAKILA.FILM_ACTOR
WHERE FILM_ID = (
	SELECT FILM_ID
	FROM SAKILA.FILM
	WHERE TITLE = 'Alone Trip'
);

SELECT FIRST_NAME, LAST_NAME
FROM SAKILA.ACTOR
WHERE ACTOR_ID IN (
    SELECT ACTOR_ID
    FROM SAKILA.FILM_ACTOR
    WHERE FILM_ID = (
        SELECT FILM_ID
        FROM SAKILA.FILM
        WHERE TITLE = 'Alone Trip'
    )
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT FILM_ID 
FROM SAKILA.FILM_CATEGORY
WHERE CATEGORY_ID = (
    SELECT CATEGORY_ID 
    FROM SAKILA.CATEGORY
    WHERE NAME = 'FAMILY'
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their 
-- primary keys and foreign keys, that will help you get the relevant information.
SELECT * FROM SAKILA.ADDRESS;
SELECT * FROM SAKILA.CITY;
SELECT * FROM SAKILA.COUNTRY;
SELECT * FROM SAKILA.CUSTOMER;

SELECT COUNTRY_ID
FROM SAKILA.COUNTRY
WHERE COUNTRY = 'CANADA';

SELECT CITY_ID
FROM SAKILA.CITY
WHERE COUNTRY_ID = (
    SELECT COUNTRY_ID
    FROM SAKILA.COUNTRY
    WHERE COUNTRY = 'CANADA'
);

SELECT ADDRESS_ID
FROM SAKILA.ADDRESS
WHERE CITY_ID IN (
    SELECT CITY_ID
    FROM SAKILA.CITY
    WHERE COUNTRY_ID = (
        SELECT COUNTRY_ID
        FROM SAKILA.COUNTRY
        WHERE COUNTRY = 'CANADA'
    )
);

SELECT FIRST_NAME, LAST_NAME, EMAIL
FROM SAKILA.CUSTOMER
WHERE ADDRESS_ID IN (
    SELECT ADDRESS_ID
    FROM SAKILA.ADDRESS
    WHERE CITY_ID IN (
        SELECT CITY_ID
        FROM SAKILA.CITY
        WHERE COUNTRY_ID = (
            SELECT COUNTRY_ID
            FROM SAKILA.COUNTRY
            WHERE COUNTRY = 'CANADA'
        )
    )
);

-- joins
SELECT Store.STORE_ID, City.CITY, Country.COUNTRY
FROM SAKILA.STORE Store
LEFT JOIN SAKILA.ADDRESS Address
ON Store.ADDRESS_ID = Address.ADDRESS_ID
LEFT JOIN SAKILA.CITY City
ON Address.CITY_ID = City.CITY_ID
LEFT JOIN SAKILA.COUNTRY Country
ON City.COUNTRY_ID = Country.COUNTRY_ID;

SELECT Customer.CUSTOMER_ID, Customer.FIRST_NAME, Customer.LAST_NAME, Customer.EMAIL
FROM SAKILA.CUSTOMER Customer
LEFT JOIN SAKILA.ADDRESS Address
ON Customer.ADDRESS_ID = Address.ADDRESS_ID
LEFT JOIN SAKILA.CITY City
ON Address.CITY_ID = City.CITY_ID
LEFT JOIN SAKILA.COUNTRY Country
ON City.COUNTRY_ID = Country.COUNTRY_ID
WHERE Country.COUNTRY = 'CANADA';

-- 6. Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id 
-- to find the different films that he/she starred.
SELECT ACTOR_ID 
FROM SAKILA.FILM_ACTOR
GROUP BY ACTOR_ID
ORDER BY COUNT(FILM_ID) DESC
LIMIT 1;

SELECT TITLE AS 'FILM_LIST'
FROM SAKILA.FILM
WHERE FILM_ID IN (
    SELECT FILM_ID 
    FROM SAKILA.FILM_ACTOR
    WHERE ACTOR_ID  = (
        SELECT ACTOR_ID  
        FROM SAKILA.FILM_ACTOR
        GROUP BY ACTOR_ID 
        ORDER BY COUNT(FILM_ID) DESC
        LIMIT 1
    )
);



-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie 
-- the customer that has made the largest sum of payments
SELECT Customer.FIRST_NAME, Customer.LAST_NAME, Customer.CUSTOMER_ID, MAX_PAYMENT.TOTAL
FROM CUSTOMER Customer
JOIN (
    SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL
    FROM PAYMENT
    GROUP BY CUSTOMER_ID
) AS MAX_PAYMENT ON Customer.CUSTOMER_ID = MAX_PAYMENT.CUSTOMER_ID
WHERE MAX_PAYMENT.TOTAL = (
    SELECT MAX(SUM_AMT) 
    FROM (
        SELECT SUM(AMOUNT) AS SUM_AMT 
        FROM PAYMENT 
        GROUP BY CUSTOMER_ID
    ) AS SUMS
);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average 
-- of the total_amount spent by each client.
SELECT CUSTOMER_ID, TOTAL_AMOUNT
FROM (
    SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_AMOUNT
    FROM SAKILA.PAYMENT
    GROUP BY CUSTOMER_ID
) AS CUSTOMER_TOTALS
WHERE TOTAL_AMOUNT > (
    SELECT AVG(TOTAL_AMOUNT)
    FROM (
        SELECT SUM(AMOUNT) AS TOTAL_AMOUNT
        FROM SAKILA.PAYMENT
        GROUP BY CUSTOMER_ID
    ) AS AVG_TOTALS
);