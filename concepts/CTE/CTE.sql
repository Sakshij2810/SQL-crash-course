-- give me total spend of a customer 
-- also give me average spend of all customer
-- also give me flag TRUE | FALSE basis of if the customer have above avg spending

-- order_items (qty * unit_price) -> product_id -> customer_id

SELECT * FROM orders;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM products;
SELECT * FROM categories;



WITH customer_total_table AS (
    SELECT o.customer_id,
        SUM(oi.unit_price * oi.quantity) AS customer_spend
    FROM orders AS o
        LEFT JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.customer_id
),
avg_spend_table AS (
    SELECT ROUND(AVG(customer_spend), 2) AS average_spend
    FROM customer_total_table
)
SELECT ct.customer_id,
    ct.customer_spend,
    a.average_spend,
    ct.customer_spend > a.average_spend AS is_above_avg
FROM customer_total_table AS ct
    CROSS JOIN avg_spend_table AS a;


    -- Step 1: Start with orders and join order_items using order_id.
--         This connects each order to its items.

-- Step 2: Keep only completed orders, because we want completed-order spending.

-- Step 3: Calculate each customer's total spend by summing
--         quantity * unit_price, then GROUP BY customer_id.
--         This is the first subquery/CTE: customer_id and customer_spend.

-- Step 4: Use the first subquery to calculate the average customer spend.
--         This is the second subquery/CTE: one value, average_spend.

-- Step 5: Make the average available to each customer row using CROSS JOIN.

-- Step 6: Show each customer's ID, total spend, and the average spend.

-- Step 7: Compare customer_spend with average_spend.
--         The comparison returns TRUE if the customer's spend is above average,
--         otherwise FALSE.