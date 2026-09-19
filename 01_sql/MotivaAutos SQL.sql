--View Car Table.
SELECT *
FROM cars;
SELECT *
FROM customers;
SELECT *
FROM orders;

--Return car_model and unit_price from the cars Table.
SELECT car_model, unit_price
FROM cars;

--DISTINCT CLAUSE
--Return distinct Cities where customers live
SELECT DISTINCT city
FROM customers;

--Return car colors from cars table
SELECT DISTINCT car_color
FROM cars;

--COUNT CLAUSE
--How many orders do we have?
SELECT COUNT(order_id)
FROM orders;

--How many customers do we have in the customer table
SELECT COUNT(customer_id)
FROM customers;

--How many car do we have?
SELECT COUNT(car_id)
FROM cars;

--COUNT AND DISTINCT CLAUSE
--How many cities are our customers in?
SELECT COUNT (DISTINCT(city))
FROM customers;

--How many Coors of cars do we sell
SELECT COUNT(Distinct(car_color))
FROM cars;

--WHERE CLAUSE
--Return all customers residing in the city of 'San Diego'
SELECT *
FROM customers
WHERE city = 'San Diego';

--Return cars with unit price greater than $30,000.
SELECT *
FROM cars
WHERE unit_price > 30000;

--WHERE CLAUSE USING AND/OR
--Return cars that are mercedes-benz brand and also greater than 50,000
SELECT *
FROM cars
WHERE car_brand = 'Mercedes-Benz' AND unit_price > 50000;

--Return cars that are either mercedes-benz brand or also greater than 50,000
SELECT *
FROM cars
WHERE car_brand = 'Mercedes-Benz' OR unit_price > 50000;

--ORDER BY CLAUSE
--List customers arranged by first_name alphabetically
SELECT *
FROM customers
ORDER BY first_name;

--List cars from the most expensive to least expensive
SELECT *
FROM cars
ORDER BY unit_price DESC;

--LIMIT CLAUSE
-- Return the first 5 customers from the Customers table.
SELECT *
FROM customers
LIMIT 5;

--Return the 3 most expensive cars from the Cars table.
SELECT *
FROM cars
ORDER BY unit_price DESC
LIMIT 3;

--BETWEEN CLAUSE
--Return all customers aged between 25 and 35
SELECT *
FROM customers
WHERE age BETWEEN 25 AND 35;

--Return cars priced between 40,000 and 50,000.
SELECT *
FROM cars
WHERE unit_price BETWEEN 40000 AND 50000;

--IN CLAUSE
--Return customers living in the cities of Chicago, Austin, and Boston
SELECT *
FROM customers
WHERE city IN ('Chicago', 'Austin', 'Boston');

--Return order details for orders with id as 1, 4, 17
SELECT *
FROM orders
WHERE order_id IN (1,4,17);

--LIKE/ILIKE CLAUSE
--Show customers whose first name starts with 'A’
SELECT *
FROM customers
WHERE first_name ILIKE'a%';

--Show customers whose first name ends with 'e’
SELECT *
FROM customers
WHERE first_name ILIKE'%e';
--Show cars where the brand name contains 'oyo'
SELECT *
FROM cars
WHERE car_brand ILIKE '%oyo%';

--AS CLAUSE
SELECT first_name AS customer_name
FROM customers;
--Basic Arithmetic Operations in SQL
-- Mgts wants to increase the price of all cars byb 20%,
-- Return car_model, current_price and updated price

SELECT 
car_model,
unit_price,
(unit_price *0.2) + unit_price AS updated_price
FROM cars;

--AGGREGATE FUNCTIONS
--SUM FUNCTION
--Calculate the total revenue from all sales in the Orders table.
SELECT SUM(sales_amount) AS Total_revenue

--COUNT FUNCTION
--Count the total number of orders we have gotten so far.
SELECT Count(distinct(order_id))
FROM orders;

--Average Age of customers
SELECT ROUND(AVG(age)) AS avg_age
FROM  customers;
-- Get the avg revenue
SELECT ROUND(AVG(sales_amount), 2)
FROM orders;

--MAX FUNTION
--what is the price of the most expensive car
SELECT Max(unit_price) AS max_price
FROM cars;

--MIN FUNCTION
--what is the price of the least expensive car
SELECT MIN(unit_price) AS min_price
FROM cars;

--CASE STUDY 1
-- STEP 1: Understand the question
-- STEP 2: What table/tables do i need
-- STEP 3: Is there a relationship btw tables
-- STEP 4: What join do i use/need
-- STEP 5: Adjust your query based on business question
-- Q1: Provide the full name, email address, and total orders for 
--customers who have placed an order
-- Return details of customers who have ordered
-- customer_id
-- inner join/join

select 	
	c.first_name ||' '||c.last_name as full_name,
	c.email,
	count(o.order_id) as total_orders
from customers c
join orders o on
c.customer_id = o.customer_id
group by c.first_name, c.last_name, c.email;

--Retrieve a list of cars that have been ordered, with their corresponding revenue and units sold
-- returning cars that have been sold
-- car_id
-- inner join/ join

select
	cr.car_id,
	cr.car_model,
	cr.car_brand,
	sum(o.sales_amount)as total_revenue,
	sum(o.quantity_sold) as total_qty_sold
from cars cr
join orders o on
cr.car_id = o.car_id
group by cr.car_id, cr.car_model,cr.car_model;

select
	cr.car_id,
	cr.car_model,
	cr.car_brand,
	sum(o.sales_amount)as total_revenue,
	sum(o.quantity_sold) as total_qty_sold
from cars cr
join orders o on
cr.car_id = o.car_id
group by 1,2,3;

--Find the customers who have spent more than the average sales revenue across all 
select
	c.customer_id,
	c.email,
	sum(o.sales_amount)
from customers c
join orders o
on c.customer_id = o.customer_id
group by 1,2
having sum(o.sales_amount) > (select avg(sales_amount)from orders);

--Retrieve the most expensive car sold by unit price
select *
from cars
where unit_price = (select max(unit_price) from cars);

--TIMESTAMPS AND EXTRACTS
--Extracts Year and Month from the order_date
SELECT 
	order_date,
	EXTRACT(YEAR FROM order_date) as order_year,
	EXTRACT(MONTH FROM order_date) as order_month
FROM orders;

-- Find Total Revenue generated for each year
SELECT 
	EXTRACT(YEAR FROM order_date) AS order_year,
	SUM(sales_amount) AS Total_Revenue
FROM orders
GROUP BY order_year;

--Case Statement
--- Categorize customers based on their age group.
--If the age is less than 30, then youth.,If age is between 30 and 45, Adult
--If age is greater than 45, Senior
SELECT first_name,last_name, age,
	CASE
		WHEN age < 30 THEN 'Youth'
		WHEN age BETWEEN 30 AND 45 THEN'Adult'
		ELSE 'Senior'
	END AS Age_group
FROM customers;

--Categorize the price of cars
SELECT car_model, unit_price,
	CASE
		WHEN unit_price< 10000 THEN 'Affordable'
		WHEN unit_price BETWEEN 10000 AND 25000 THEN 'Mid Range'
		ELSE 'Luxury'
	END AS Price_category
FROM cars;

SELECT car_model, unit_price,
	CASE
		WHEN unit_price < 10000 THEN 'Affordable'
		WHEN unit_price >= 10000 AND unit_price <= 25000 THEN 'Mid Range'
		ELSE 'Luxury'
	END AS Price_category
FROM cars;

--COALESCE
-- Replace customers email with not available
SELECT 
	customer_id, 
	COALESCE(email, 'NO Email') AS Email
FROM customers;

--Return all customers with total_revenue , replace null with 0
SELECT 
	c.customer_id,
	c.email, 
	COALESCE(sum(o.sales_amount),0) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 1,2;

-- Convert unit_price column to integer
SELECT CAST(car_id AS int)
FROM cars;
--Return car_model and price in dollars
SELECT 
	car_model,
	'$' || CAST(unit_price AS VARCHAR) AS Price
FROM cars;

SELECT 
	car_model,
	'$' || TO_CHAR(unit_price, 'FM999,999.00') AS Price
FROM cars;

-- Combining COALESCE, CAST and subquery
-- Show total sales by car color, and include only those colors where
--total sales are above the overall average sales amount per order

SELECT cars.car_color,
'$' || CAST(COALESCE(SUM(orders.sales_amount), 0) as varchar) as sales
FROM cars
LEFT JOIN orders
ON orders.car_id = cars.car_id
GROUP BY cars.car_color
HAVING SUM(orders.sales_amount) > (select avg(orders.sales_amount) FROM orders);

-- What are the total sales and total quantity sold across all orders?
SELECT 
	'$' || to_char(sum(sales_amount),'FM999,999,999')AS "Total Revenue",
	sum(quantity_sold) AS "Total Quantity"
FROM orders;

--Segment customers into loyalty tiers(Gold, Silver,Bronze based on revenue)
SELECT 
	c.customer_id,
	c.first_name || ' ' || c.last_name as full_name,
	sum(o.sales_amount) as  Revenue,
	CASE
		when sum(o.sales_amount) >= 1000000 then 'Gold'
		when sum(o.sales_amount) < 1000000 AND sum(o.sales_amount) > 500000 then 'Silver' 
		else 'Bronze'
		end as  loyalty_tier
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name;

-- Monthly sales trend across years
SELECT 
	EXTRACT(year from order_date) as order_year,
	EXTRACT(MONTH FROM order_date) as month_num,
	to_char(order_date, 'Month') as order_month,
	sum(sales_amount)
FROM orders
GROUP by order_year, month_num, order_month
order by order_year, month_num;

-- Most frequently purchased car_color
SELECT 
	c.car_color,
	Coalesce(sum(o.quantity_sold), 0) As Total_quantity
FROM cars c
LEFT JOIN
orders o ON o.car_id = c.car_id
GROUP BY c.car_color
ORDER BY Total_quantity DESC;

SELECT o.order_id, c.car_color, cs.customer_id
FROM cars c
JOIN orders O
ON O.car_id = c.car_id
JOIN customers cs
ON cs.customer_id = O.customer_id;

EXPLAIN ANALYSE
SELECT *
from customers
WHERE customer_id ='94';