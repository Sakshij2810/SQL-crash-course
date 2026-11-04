DROP TABLE IF EXISTS
    order_items,
    payments,
    orders,
    customers,
    products,
    categories
CASCADE;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- update stock_quantity of 1 product_id to 200
UPDATE products
SET stock_quantity = 200
WHERE product_id = 1;

-- update price of all products by 100 due 
UPDATE products
SET price = price + 100;

-- set all products to FALSE is_active status
UPDATE products
SET is_active = FALSE;

-- delet department of id 4
DELETE FROM departments
WHERE department_id = 4;

-- show all order_items whose order_id is 1
SELECT * FROM order_items
WHERE order_id = 1;

-- delete order of id 1
DELETE FROM orders
WHERE order_id = 1;

------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM departments
ORDER BY department_id;

SELECT * FROM products
ORDER BY product_id;