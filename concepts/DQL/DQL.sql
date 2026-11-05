-- ! DQL - Data Query Language

-- 1. Display every column and every row from the products table.
SELECT * FROM products;


-- 2. Display only the product ID, product name, and stock quantity for each product. Show the product name under the heading Product Name.
SELECT product_id, product_name AS "Product Name", stock_quantity FROM products;


-- 3. Display every row and column from the customers table.
SELECT * FROM customers;


-- 4. Display each country from the customers table only once.
SELECT DISTINCT country FROM customers;


-- 5. Display products whose price is greater than 200.
SELECT * FROM products
WHERE price > 200;


-- 6. Display products that have a stock quantity greater than 0 and a price less than 150.
SELECT * FROM products
WHERE stock_quantity > 0 AND price < 150;


-- 7. Display products that have a stock quantity of 0 or a price less than 150.
SELECT * FROM products
WHERE stock_quantity = 0 OR price < 150;



-- 8. Display products that are not active.
SELECT * FROM products
WHERE NOT is_active;

SELECT * FROM products
WHERE is_active = TRUE;


-- 9. Display products whose price is between 120 and 200, including both endpoints.
SELECT * FROM products
WHERE price >= 120 AND price <= 200;

SELECT * FROM products
WHERE price BETWEEN 120 AND 200;



-- 10. Display products that belong to category IDs 1, 3, or 4.
SELECT * FROM products
WHERE category_id = 1 
OR category_id = 3 
OR category_id = 4;

SELECT * FROM products
WHERE category_id IN (1,3,4);



-- 11. Display products whose name contains the text “less”.

INSERT INTO products
(product_name, price, stock_quantity, category_id)
VALUES
('Wireless keyboard', 100, 20, 1),
('Wireless light', 200, 0, 1),
('Wireless headphones', 150, 0, 1);


SELECT * FROM products
WHERE product_name LIKE '%less%';



-- 12. Display customers who have a phone number.
SELECT * FROM customers;

SELECT * FROM customers
WHERE phone IS NOT NULL;



-- 13. Display each customer’s first name, last name, phone number, and city. If the phone number is missing, show “Phone number unavailable”; if the city is missing, show “No city”.
SELECT 
first_name, 
last_name, 
COALESCE(phone, 'Phone number unavailable') AS Phone_no, 
COALESCE(city, 'No city') AS city
FROM customers;




-- 14. Display products from the most expensive to the cheapest.
SELECT * FROM products
ORDER BY price DESC;



-- 15. Display products grouped by category ID in descending order, and within each category, from cheapest to most expensive.
SELECT * FROM products
ORDER BY category_id DESC, price ASC;



-- 16. Display the 10 most expensive products.
SELECT * FROM products
ORDER BY price DESC
LIMIT 10;



-- Display the second page of products when each page contains 10 products. Sort by product ID so the page order is consistent.
SELECT * FROM products
ORDER BY product_id
LIMIT 10
OFFSET 10;

-- offset = (page - 1) * limit