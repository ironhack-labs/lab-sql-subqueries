-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(F.TITLE) AS COPIES
FROM SAKILA.INVENTORY I 
LEFT JOIN SAKILA.FILM F 
ON I.FILM_ID = F.FILM_ID
WHERE F.TITLE = 'Hunchback Impossible';

-- List all films whose length is longer than the average of all the films.
SELECT TITLE
FROM SAKILA.FILM 
WHERE LENGTH > (
SELECT AVG(LENGTH) 
FROM SAKILA.FILM)
ORDER BY LENGTH ; 

-- Use subqueries to display all actors who appear in the film Use subqueries to display all actors who appear in the film Alone Trip..
SELECT CONCAT(FIRST_NAME, ' ' , LAST_NAME) AS ACTOR_NAME
FROM SAKILA.ACTOR
WHERE ACTOR_ID IN (
SELECT FA.ACTOR_ID AS ALONE_TRIP_ACT
FROM SAKILA.FILM_ACTOR FA
LEFT JOIN SAKILA.FILM F 
ON FA.FILM_ID = F.FILM_ID
WHERE F.TITLE = 'Alone Trip');

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT NAME
FROM SAKILA.CATEGORY;

SELECT TITLE
FROM SAKILA.FILM 
WHERE FILM_ID IN (
SELECT FILM_ID
FROM SAKILA.FILM_CATEGORY 
WHERE CATEGORY_ID IN (
SELECT CATEGORY_ID
FROM SAKILA.CATEGORY
WHERE NAME = 'Family'));

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

-- Using Joins
SELECT CONCAT(C.FIRST_NAME, ' ' , LAST_NAME) AS CUSTOM_NAME_CA, C.EMAIL
FROM SAKILA.CUSTOMER C
LEFT JOIN SAKILA.ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID
LEFT JOIN SAKILA.CITY CC 
ON A.CITY_ID = CC.CITY_ID
LEFT JOIN SAKILA.COUNTRY CN
ON CC.COUNTRY_ID = CN.COUNTRY_ID
WHERE CN.COUNTRY = 'Canada';
 
-- Using subqueries
SELECT CONCAT(FIRST_NAME, ' ' , LAST_NAME) AS CUSTOM_NAME_CA, EMAIL 
FROM SAKILA.CUSTOMER
WHERE ADDRESS_ID IN (
SELECT ADDRESS_ID
FROM SAKILA.ADDRESS
WHERE CITY_ID IN (
SELECT CITY_ID
FROM SAKILA.CITY 
WHERE COUNTRY_ID IN (
SELECT COUNTRY_ID
FROM SAKILA.COUNTRY
WHERE COUNTRY = 'Canada')));

-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT ACTOR_ID, COUNT(DISTINCT FILM_ID) AS NUMBER_OF_FILMS
FROM SAKILA.FILM_ACTOR
GROUP BY 1
ORDER BY 2 DESC;

SELECT TITLE
FROM SAKILA.FILM
WHERE FILM_ID IN (
SELECT FILM_ID
FROM SAKILA.FILM_ACTOR
WHERE ACTOR_ID = '107');

-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer 
-- that has made the largest sum of payments.

SELECT CUSTOMER_ID, SUM(AMOUNT) AS PAYMENTS
FROM SAKILA.PAYMENT
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1;

