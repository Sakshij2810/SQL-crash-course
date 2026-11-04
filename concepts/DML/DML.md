# SQL DML Cheat Sheet (PostgreSQL)

**DML = work with table rows:** `INSERT`, `UPDATE`, `DELETE`.  
`SELECT` reads data (often taught alongside DML; sometimes called DQL).

## 1. INSERT — add rows

```sql
-- One row
INSERT INTO categories (category_name, description)
VALUES ('Books', 'Books and learning');

-- Multiple rows
INSERT INTO categories (category_name, description)
VALUES ('Clothing', 'Apparel'), ('Sports', 'Outdoor gear');

-- Insert from a query
INSERT INTO products (category_id, product_name, price, stock_quantity)
SELECT category_id, category_name || ' Item', 25.00, 10
FROM categories;

-- Show inserted row(s)
INSERT INTO customers (first_name, last_name, email)
VALUES ('Asha', 'Patel', 'asha@example.com')
RETURNING *;
```

## 2. UPDATE — change rows

```sql
-- Update selected row(s)
UPDATE products
SET stock_quantity = 200
WHERE product_id = 1;

-- Update using current value
UPDATE products
SET price = price + 100
WHERE category_id = 1;

-- Update every row (no WHERE!)
UPDATE products
SET is_active = FALSE;

-- Update from another table
UPDATE products AS p
SET price = p.price * 1.05
FROM categories AS c
WHERE p.category_id = c.category_id
  AND c.category_name = 'Electronics';

-- Show changed row(s)
UPDATE products
SET stock_quantity = stock_quantity + 10
WHERE product_id = 1
RETURNING product_id, product_name, stock_quantity;
```

## 3. DELETE — remove rows

```sql
-- Delete selected row(s)
DELETE FROM products
WHERE product_id = 1;

-- Delete all rows (table remains)
DELETE FROM products;

-- Delete using another table
DELETE FROM products AS p
USING categories AS c
WHERE p.category_id = c.category_id
  AND c.category_name = 'Clothing';

-- Show deleted row(s)
DELETE FROM products
WHERE product_id = 1
RETURNING *;
```

**Foreign keys:** deleting an `orders` row cascades to its `order_items` and `payments` in this schema (`ON DELETE CASCADE`). It does not delete the products.

## 4. UPSERT — insert, or handle a conflict

```sql
-- Ignore duplicate category_name
INSERT INTO categories (category_name, description)
VALUES ('Books', 'Books')
ON CONFLICT (category_name) DO NOTHING;

-- Update the existing row on conflict
INSERT INTO categories (category_name, description)
VALUES ('Books', 'Books and learning')
ON CONFLICT (category_name)
DO UPDATE SET description = EXCLUDED.description;
```

`EXCLUDED.column` = value from the attempted insert.

## 5. Transactions — commit or undo a group of changes

```sql
BEGIN;

UPDATE products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1 AND stock_quantity > 0;

-- Check results, then choose one:
COMMIT;    -- keep changes
-- ROLLBACK; -- undo changes
```

## 6. WHERE condition patterns

```sql
WHERE price >= 50
WHERE category_id = 1 AND is_active = TRUE
WHERE status = 'pending' OR status = 'processing'
WHERE status IN ('pending', 'processing')
WHERE price BETWEEN 20 AND 100       -- inclusive
WHERE product_name LIKE '%Book%'     -- contains Book
WHERE city IS NULL
WHERE city IS NOT NULL
```

Use `IS NULL`, not `= NULL`.

## 7. SELECT — read data

```sql
SELECT * FROM products;
SELECT product_name, price FROM products;

-- Filter + sort + limit
SELECT product_name, price
FROM products
WHERE is_active = TRUE
ORDER BY price DESC
LIMIT 5;

-- Unique values
SELECT DISTINCT country FROM customers;

-- Aggregate + group + filter groups
SELECT category_id, COUNT(*) AS product_count, AVG(price) AS avg_price
FROM products
GROUP BY category_id
HAVING COUNT(*) >= 5;
```

**Order to remember:** `WHERE` filters rows; `GROUP BY` makes groups; `HAVING` filters groups; `ORDER BY` sorts; `LIMIT` restricts output.

## 8. JOIN — combine related tables

```sql
-- Only matching rows
SELECT o.order_id, c.first_name, o.status
FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id;

-- Keep all customers, even those without orders
SELECT c.customer_id, c.first_name, o.order_id
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id;

-- Customers with no orders
SELECT c.customer_id, c.first_name
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- Order lines with product names
SELECT o.order_id, p.product_name, oi.quantity, oi.unit_price
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id;
```

## 9. Subqueries / EXISTS

```sql
-- Products priced above the overall average
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Customers who have orders
SELECT c.customer_id, c.first_name
FROM customers AS c
WHERE EXISTS (
    SELECT 1 FROM orders AS o
    WHERE o.customer_id = c.customer_id
);

-- Customers with no orders
SELECT c.customer_id, c.first_name
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1 FROM orders AS o
    WHERE o.customer_id = c.customer_id
);
```

## Before changing data

1. Run a `SELECT` with the same `WHERE` to preview affected rows.
2. Check the `WHERE` clause—**no `WHERE` means all rows**.
3. Consider foreign keys and cascades.
4. Use `BEGIN` / `COMMIT` / `ROLLBACK` for multi-step changes.
5. Use `RETURNING` to inspect rows changed by PostgreSQL `INSERT`, `UPDATE`, or `DELETE`.

```sql
-- Preview, then update
SELECT * FROM products WHERE product_id = 1;
UPDATE products SET price = price + 100
WHERE product_id = 1
RETURNING *;
```
