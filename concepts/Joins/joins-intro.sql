-- ! JOINS

-- 1. INNER JOIN
-- Show orders that have a matching employee.
-- Include the details of the employee who processed each order.
-- Orders without an employee and employees without orders are excluded.

SELECT *
FROM orders AS o
INNER JOIN employees AS e
    ON o.employee_id = e.employee_id;


-- 2. LEFT JOIN
-- Show every order and the employee who processed it, if any.
-- If an order has no employee, the employee columns will be NULL.
-- Employees who have no orders are excluded.

SELECT *
FROM orders AS o
LEFT JOIN employees AS e
    ON o.employee_id = e.employee_id;


-- 3. RIGHT JOIN
-- Show every employee and any orders they processed.
-- If an employee has no orders, the order columns will be NULL.
-- Orders without a matching employee are excluded.

SELECT *
FROM orders AS o
RIGHT JOIN employees AS e
    ON o.employee_id = e.employee_id;


-- 4. FULL OUTER JOIN
-- Show every order and every employee.
-- Include matching order-employee pairs.
-- Keep orders without a matching employee and employees without orders.
-- Missing columns from the other table will be NULL.

SELECT *
FROM orders AS o
FULL OUTER JOIN employees AS e
    ON o.employee_id = e.employee_id;


-- 5. CROSS JOIN
-- Combine every department with every category.
-- Each department is paired with every category.
-- This returns every possible department-category combination.

SELECT *
FROM departments
CROSS JOIN categories;