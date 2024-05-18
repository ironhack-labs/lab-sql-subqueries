-- How many copies of the film Hunchback Impossible exist in the inventory system?
USE SAKILA;
SELECT F.TITLE, COUNT(I.INVENTORY_ID)
FROM FILM F 
LEFT JOIN INVENTORY I 
ON F.FILM_ID = I.INVENTORY_ID
WHERE F.TITLE = 'Hunchback Impossible'
GROUP BY F.TITLE;

-- List all films whose length is longer than the average of all the films.

SELECT AVG(LENGTH), LENGTH
FROM FILM;

SELECT TITLE, LENGTH
FROM FILM 
WHERE LENGTH > (SELECT AVG(LENGTH)
				FROM FILM);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM (
	SELECT A.FIRST_NAME, A.LAST_NAME, F.TITLE
	FROM ACTOR A 
	JOIN  FILM_ACTOR FA
	ON A.ACTOR_ID = FA.ACTOR_ID
	JOIN FILM F
	ON F.FILM_ID = FA.FILM_ID
) A 
WHERE title = 'Alone Trip';

--  Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT F.TITLE, C.NAME AS CATEGORY
FROM CATEGORY C
JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN FILM F 
ON F.FILM_ID = FC.FILM_ID
WHERE C.NAME = 'Family';

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT C.FIRST_NAME, C.LAST_NAME, C.EMAIL
FROM CUSTOMER C 
JOIN ADDRESS A 
ON A.ADDRESS_ID = C.ADDRESS_ID
JOIN CITY CT
ON CT.CITY_ID = A.CITY_ID_ID
JOIN COUNTRY CO
ON CO.COUNTRY_ID = CT.COUNTRY_ID
WHERE CO.COUNTRY = 'Canada';

-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT COUNT(A.ACTOR_ID) AS COUNT, A.FIRST_NAME, A.LAST_NAME
FROM ACTOR A
JOIN FILM_ACTOR FA 
ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM F 
ON F.FILM_ID = FA.FILM_ID
GROUP BY A.ACTOR_ID
ORDER BY COUNT DESC
LIMIT 1;

-- Films rented by most profitable customer. You can use the customer table and
-- payment table to find the most profitable customer ie
-- the customer that has made the largest sum of payments
SELECT C.FIRST_NAME, C.LAST_NAME, SUM(PAY.AMOUNT) AS TOTAL, C.CUSTOMER_ID
FROM CUSTOMER C
JOIN PAYMENT PAY
ON C.CUSTOMER_ID = PAY.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL DESC
LIMIT 1;

-- Get the client_id and total_amount_spent of those clients who spent more than
-- the avg of the total_amount spent by each client.
SELECT AVG(AMOUNT) AS SPENT
FROM PAYMENT;

SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_AMOUNT_SPENT
FROM PAYMENT
GROUP BY CUSTOMER_ID
HAVING AVG(AMOUNT) > (SELECT AVG(AMOUNT) AS SPENT
FROM PAYMENT)
;