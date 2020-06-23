-- base questions
-- Get all customers and their addresses.
SELECT * FROM customers
JOIN addresses ON customers.id = addresses.customer_id;

-- Get all orders and their line items (orders, quantity and product).
SELECT * FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON products.id = line_items.product_id; 

-- Which warehouses have cheetos?
SELECT * FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

-- Which warehouses have diet pepsi?
SELECT * FROM warehouse
JOIN warehouse_product ON warehouse.id = warehouse_product.warehouse_id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT customers.*, count(orders) AS total_orders FROM customers
JOIN addresses ON addresses.customer_id = customers.id
JOIN orders ON  orders.address_id = addresses.id
GROUP BY customers.id;

-- How many customers do we have?
SELECT count(customers) AS total_customers FROM customers;

-- How many products do we carry?
SELECT count(products) AS total_products FROM products;

-- What is the total available on-hand quantity of diet pepsi?
SELECT products.description, SUM(warehouse_product.on_hand) FROM products
JOIN warehouse_product ON products.id = warehouse_product.product_id
WHERE products.description = 'diet pepsi'
GROUP BY products.description;

-- stretch questions
-- How much was the total cost for each order?
SELECT orders.id AS order_id, SUM(products.unit_price) AS order_total FROM orders
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY orders.id
ORDER BY orders.id;

-- How much has each customer spent in total?
SELECT customers.*, SUM(products.unit_price * line_items.quantity) AS total_spent FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON addresses.id = orders.address_id
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY customers.id
ORDER BY customers.id;

-- How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.*, COALESCE(SUM(products.unit_price * line_items.quantity), 0) AS total_spent FROM customers
LEFT OUTER JOIN addresses ON customers.id = addresses.customer_id
LEFT OUTER JOIN orders ON addresses.id = orders.address_id
LEFT OUTER JOIN line_items ON orders.id = line_items.order_id
LEFT OUTER JOIN products ON line_items.product_id = products.id
GROUP BY customers.id
ORDER BY customers.id;
