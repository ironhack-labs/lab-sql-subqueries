SELECT cu.customer_id, cu.first_name, cu.last_name, SUM(p.amount) AS total_spent
FROM customer cu
JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name
ORDER BY total_spent DESC
LIMIT 1;
