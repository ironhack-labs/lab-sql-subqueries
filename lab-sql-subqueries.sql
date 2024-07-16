-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS N_COPIES
FROM INVENTORY
LEFT JOIN SAKILA.FILM ON INVENTORY.FILM_ID = FILM.FILM_ID
WHERE FILM.TITLE = 'HUNCHBACK IMPOSSIBLE';

-- List all films whose length is longer than the average of all the films.
SELECT FILM.TITLE, FILM.LENGTH
FROM SAKILA.FILM
WHERE FILM.LENGTH > (SELECT AVG(LENGTH) FROM SAKILA.FILM);


-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT ACTOR.ACTOR_ID, ACTOR.FIRST_NAME, ACTOR.LAST_NAME
FROM SAKILA.ACTOR
WHERE ACTOR.ACTOR_ID IN
    (SELECT FILM_ACTOR.ACTOR_ID
     FROM FILM_ACTOR
     JOIN FILM ON FILM.FILM_ID = FILM_ACTOR.FILM_ID
     WHERE FILM.TITLE = 'ALONE TRIP');


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT FILM.TITLE, CATEGORY.NAME
FROM SAKILA.FILM
JOIN FILM_CATEGORY ON FILM.FILM_ID = FILM_CATEGORY.FILM_ID
JOIN CATEGORY ON FILM_CATEGORY.CATEGORY_ID = CATEGORY.CATEGORY_ID
WHERE CATEGORY.NAME = 'FAMILY';


-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email
FROM customer
WHERE customer_id IN
    (SELECT customer_id 
     FROM address
     WHERE country = 'Canada');


SELECT * FROM SAKILA.ADDRESS;

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.



-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments



-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.