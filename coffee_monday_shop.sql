CREATE SCHEMA Monday_Coffee_Sales;
USE Monday_Coffee_Sales;

SELECT * FROM city;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

SELECT count(*) FROM city;
SELECT count(*) FROM customers;
SELECT count(*) FROM products;
SELECT count(*) FROM sales;


-- ACTIVITY 1

CREATE TABLE customers(
	customer_id int primary key,
    customer_name varchar (100),
    city_id int (50)
    );
    
CREATE TABLE products(
	product_id int primary key,
    product_name varchar (100),
    price int (100)
    );
    
CREATE TABLE sales(
	sale_id int,
    sale_date date,
    product_id int,
    quantity int,
    customer_id INT,FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    total_amount int,
    rating int
    );
    

-- ACTIVITY 2
-- 1. identify null values 
		
SELECT*
FROM city
where city_id is null
	OR city_name IS NULL
	OR population IS NULL
	OR estimated_rent IS NULL
	OR city_rank IS NULL;


-- 2. CHECK DUPLICATE ENTRIES IN CUSTOMER TABLE?

SELECT customer_id, COUNT(*)customer_name,city_id  AS duplicate_entries
FROM customers
GROUP BY customer_id,customer_name,city_id
HAVING customer_name > 1;

-- 3. Check mismatch (price × quantity vs total_amount)

SELECT s.sale_id, p.price, s.quantity, s.total_amount,
       (p.price * s.quantity) AS calculated_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.total_amount != (p.price * s.quantity);

-- ACIVITY 3
-- How do you create a comprehensive sales report with customer and product details?

SELECT s.sale_id, s.sale_date, c.customer_id, c.customer_name, p.product_name
FROM sales s
INNER JOIN customers c ON s.customer_id=  c.customer_id
INNER JOIN products p ON s.product_id = p.product_id;


-- ACTIVITY 4 
-- (A) TOTAL SALES PER CITY

SELECT ci.city_name, SUM(s.total_amount) AS total_sales
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY total_sales DESC;

-- (B) total transactions occurred per city?

SELECT ci.city_name, count(s.total_amount) AS total_transaction_per_city
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name;

-- (c) How many unique customers are there in each city?

SELECT ci.city_name, COUNT(DISTINCT c.customer_id) AS unique_customers
FROM customers c
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name;

-- (d) what is the avg order value per city?

SELECT ci.city_name, AVG(s.total_amount) AS avg_order_value
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name;

-- (E) WHAT IS THE DEMAND FOR EACH PRODUCT IN DIFF CITIES?

SELECT ci.city_name, p.product_name, SUM(s.quantity) AS total_demand
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name, p.product_name
ORDER BY total_demand DESC;

-- (F) WHAT IS THE MONTHLY SALES TREND ?
-- nill

-- (g) what is the avg product rating per city based on customer purchases?

SELECT ci.city_name, AVG(s.rating) AS avg_rating
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name;


-- ACTIVITY 5
-- HOW DO YOU IDENTIFY TOP 3 CITIES BASED ON (SALES,UNIQUE CUSTOMERS & ORDER COUNT)?

SELECT ci.city_name, COUNT(s.total_amount) AS order_count
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
LIMIT 3;

-- what are the final recomendation for expanding monday coffee shops ?

High total sales
Large customer base
High transaction count
Also consider:
Lower rent (profitability)
Higher ratings (customer satisfaction)




