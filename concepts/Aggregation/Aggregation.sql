-- Display all customers in the database.
SELECT *
FROM customers;


-- Find the total number of customers.
SELECT COUNT(*) AS total_customers
FROM customers;


-- Find how many customers have a phone number.
SELECT COUNT(*) AS count_of_customers_with_phone
FROM customers
WHERE phone IS NOT NULL;


-- Find the number of distinct countries represented in the customers table.
SELECT COUNT(DISTINCT country) AS count_distinct_country
FROM customers;


-- Display each order item’s ID, quantity, unit price, and total selling value. Calculate the total selling value as quantity multiplied by unit price.
SELECT order_item_id,
    quantity,
    unit_price,
    (quantity * unit_price) AS total_selling_val
FROM order_items;


-- Calculate the total revenue across all order items by adding up their total selling values.
SELECT SUM(unit_price * quantity) AS revenue
FROM order_items;


-- Calculate the average price of all products, rounded to two decimal places.
SELECT ROUND(AVG(price), 2) as avg_price FROM products;



-- Find the minimum and maximum product prices.
SELECT MIN(price), MAX(price) FROM products;



-- Show the total number of products, average product price (rounded to two decimal places), minimum price, maximum price, and total stock quantity.
SELECT COUNT(*) AS total_products,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    SUM(stock_quantity) AS total_stock_qty
FROM products;


---------------------------------------------------------------- GROUP BY ----------------------------------------------------------------------------------------------------------------

-- Display all products in the database.
SELECT * FROM products;


-- Display all product categories in the database.
SELECT * FROM categories;


-- Count the total number of products.
SELECT COUNT(*) AS total_products FROM products;



-- Find the number of products in each category.
SELECT 
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id;




-- Find the number of active and inactive products in each category.

SELECT * FROM categories;
SELECT * FROM products;


SELECT 
    category_id,
    is_active,
    COUNT(*)
FROM products
GROUP BY category_id, is_active
ORDER BY category_id;


-- Find the number of products in each category, including the category name in the results.
SELECT 
p.category_id,
c.category_name,
COUNT(*) AS product_count
FROM products AS p
LEFT JOIN categories AS c ON p.category_id = c.category_id
GROUP BY p.category_id , c.category_name
ORDER BY p.category_id;


-- Find categories that have more than five products.
SELECT category_id,
    COUNT(*) AS total_product
FROM products
GROUP BY category_id
HAVING COUNT(*) > 5
ORDER BY category_id;


-- Find departments that have more than one employee with a manager, 
-- and whose combined salary for those employees is greater than ₹200,000. 
-- Show the department ID, number of qualifying employees, and their combined salary.

SELECT * FROM employees;


SELECT 
    department_id,
    COUNT(*) AS total_employees,
    SUM(salary) AS combined_salary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) > 1 AND SUM(salary) > 200000
ORDER BY department_id;