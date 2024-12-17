SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount) 
                      FROM (SELECT SUM(amount) AS total_amount 
                            FROM payment 
                            GROUP BY customer_id) AS subquery);
