select * from bank.account a1
join bank.account a2
on a1.account_id <> a2.account_id -- self join
and a1.district_id = a2.district_id
order by a1.district_id;

select * from ( -- select from a query, sub quering
	select distinct type from bank.card) sub1 -- cross join - gets all the possibilities
cross join (
	select distinct type from bank.disp) sub2
where sub1.type = 'gold';

CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);

CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13 , 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    PRIMARY KEY (product_id , store_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
        ON DELETE CASCADE ON UPDATE CASCADE);
        

INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);

INSERT INTO stores(store_name)
VALUES('North'),
      ('South');

INSERT INTO sales(store_id,product_id,quantity,sales_date)
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');
      
SELECT 
    store_name,
    product_name,
    SUM(quantity * price) AS revenue
FROM
    sales
        INNER JOIN
    products ON products.id = sales.product_id
        INNER JOIN
    stores ON stores.id = sales.store_id
GROUP BY store_name , product_name; 

SELECT 
    store_name, product_name
FROM
    stores AS a
        CROSS JOIN
    products AS b;
    
SELECT 
    b.store_name,
    a.product_name,
    IFNULL(c.revenue, 0) AS revenue
FROM
    products AS a
        CROSS JOIN
    stores AS b
        LEFT JOIN
    (SELECT 
        stores.id AS store_id,
        products.id AS product_id,
        store_name,
            product_name,
            ROUND(SUM(quantity * price), 0) AS revenue
    FROM
        sales
    INNER JOIN products ON products.id = sales.product_id
    INNER JOIN stores ON stores.id = sales.store_id
    GROUP BY stores.id, products.id, store_name , product_name) AS c ON c.store_id = b.id
        AND c.product_id= a.id
ORDER BY b.store_name;

create temporary table bank.district_cards
select distinct type from bank.card;

create temporary table bank.district_frequency
select distinct frequency from bank.account;

select * from bank.district_cards cross join bank.district_frequency;

select * from bank.loan
where amount > (select avg(amount) from bank.loan)
order by amount desc
limit 10;

select * from (
	select account_id, bank_to, account_to, sum(amount) as Total
from bank.order
group by 1,2,3) sub1 -- when you do a sub query you have to give it an alias
where Total >10000;

select * from bank.order
where bank_to in (
select bank from (
select bank, avg(amount) as avg_amount
from bank.trans
where bank <> ''
group by 1
having avg_amount > 5000) sub1);

select k_symbol from (
select k_symbol, avg (amount) as avg_amount -- this gets the k-symbol of the rows that have avg amount bigger than 3000
from bank.order
group by 1
having avg_amount > 3000) sub1;

select * from bank.trans;

SELECT account_id
FROM bank.trans
GROUP BY account_id
HAVING COUNT(trans_id) > (
  SELECT AVG(num_transactions)
  FROM (
    SELECT COUNT(trans_id) AS num_transactions
    FROM bank.trans
    GROUP BY account_id
  ) sub1
);