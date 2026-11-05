-- Window functions

-- 1. Find the total sum of product prices for each category. Return the category ID and the total price.

-- using GROUP BY 
SELECT category_id,
    SUM(price) as total_products_price
FROM products
GROUP BY category_id;


-- 2. Display every product along with the total sum of product prices for its category. Keep all product rows in the result.

-- using windows
SELECT *,
    SUM(price) OVER (PARTITION BY category_id) AS category_total_price
FROM products;


-- 3. Display every product along with the average price across all products. Keep all product rows in the result.

SELECT *,
    AVG(price) OVER() AS avg_price
FROM products;

-- 4. Rank products from most expensive to least expensive. Show each product’s name and price, along with:
--    - a row number,
--    - a rank that leaves gaps when prices tie,
--    - a dense rank that does not leave gaps when prices tie.

SELECT *,
    ROW_NUMBER() OVER(  ORDER BY price DESC ) AS prod_row_num,
    RANK() OVER(ORDER BY price DESC) AS prod_rank,
     DENSE_RANK() OVER(ORDER BY price DESC) AS prod_dense_rank
FROM products;


-- UNION

-- ! Run this query only for UNION and UNION ALL examples
INSERT INTO employees
    (first_name, last_name, email, phone, job_title, salary, hire_date)
VALUES
    ('Alice', 'Johnson', 'alice.johnson@email.com', '212-555-0101',
     'Sales Manager', 75000, '2024-01-10'),

    ('Brian', 'Kim', 'brian.kim@email.com', NULL,
     'Software Engineer', 85000, '2024-02-15'),

    ('Carla', 'Mendes', 'carla.mendes@email.com', '305-555-0103',
     'Marketing Specialist', 65000, '2024-03-20'),

    ('David', 'Okoro', 'david.okoro@email.com', '312-555-0104',
     'HR Executive', 70000, '2024-04-05'),

    ('Emma', 'Wilson', 'emma.wilson@email.com', NULL,
     'Product Manager', 90000, '2024-05-12');

-- 5. Create one list of people in the community by combining employees and customers. Show each person’s first name, last name, and a role identifying them as either an employee or a customer. Remove duplicate rows.

SELECT first_name , last_name, 'employee' AS role FROM employees
UNION
SELECT first_name , last_name, 'customer' AS role FROM customers;

SELECT first_name , last_name, 'employee' AS role FROM employees
UNION ALL
SELECT first_name , last_name, 'customer' AS role FROM customers;


-- Index
-- 6. Create an index on the email column of the customers table to help queries that search by customer email.

CREATE INDEX idx_customer_email ON customers(email);