-- give me all products which are having 
-- price > average price across all products

SELECT  * FROM products;

SELECT 
    product_id,
    product_name,
    price
FROM products
WHERE price > (  (SELECT  AVG(price) AS avg_price FROM products ) )
ORDER BY product_id;


-- give me sales on category level
-- electronics = 3000
-- clothing = 4000
-- give me catrgoeies having sales > 500
-- return category name in the result

SELECT * FROM order_items;
SELECT * FROM products;
SELECT * FROM categories;

SELECT * FROM orders;




SELECT category_name,
    category_stats.item_price AS sales
from (
        SELECT SUM(oi.quantity * oi.unit_price) AS item_price,
            p.category_id
        FROM order_items as oi
            LEFT JOIN products as p on oi.product_id = p.product_id
        GROUP BY p.category_id
    ) as category_stats
    LEFT JOIN categories as c on category_stats.category_id = c.category_id
WHERE category_stats.item_price > 500;

-- step 1: order_items -> product_id -> category_id (so join products table with order_items table)
-- step 2: order_items has (unit_price & qty) which calculates item_price of each category
-- step 3: group by category_id where store sum of (item_prices)
------ this is 1st sub-query (which will gives us category_id and its sales)

-- step 4: to get category name : join category_stats table with categories table
-- step 5: add WHERE for sales > 500