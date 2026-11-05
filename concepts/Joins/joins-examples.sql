
-- ! give me all customers who did not place any order

SELECT o.order_id,
    o.status,
    c.customer_id,
    c.first_name
FROM customers as c
    LEFT JOIN orders as o ON c.customer_id = o.customer_id
WHERE o.status IS NULL;

-- ! give me orders which have not been paid

SELECT 
o.order_id, o.status, p.payment_id, p.status
FROM orders as o
LEFT JOIN payments as p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;


-- ! give information about all orders that are there in DB
-- ! include info about order_items, products, customer, 
-- ! and category the product belongs to.

SELECT o.order_id,
    o.status,
    i.order_item_id,
    i.unit_price,
    p.product_id,
    p.product_name,
    ct.category_id,
    ct.category_name,
    c.customer_id,
    c.first_name
FROM orders as o
    LEFT JOIN order_items as i ON o.order_id = i.order_id
    LEFT JOIN products as p ON i.product_id = p.product_id
    LEFT JOIN categories as ct ON p.category_id = ct.category_id
    LEFT JOIN customers as c ON o.customer_id = c.customer_id;


-- 1 give me info about employee including their manager info

SELECT 
emp.first_name as "Employee First Name",
emp.last_name as "Employee Last Name",
manager_tbl.first_name as "Manager First Name",
manager_tbl.last_name as "Manager Last Name"
FROM employees as emp
LEFT JOIN employees as manager_tbl ON emp.manager_id = manager_tbl.employee_id;




