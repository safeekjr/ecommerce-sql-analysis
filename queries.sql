
-- E-COMMERCE SALES ANALYSIS — SQL QUERIES

-- Q1. View all customers
SELECT * FROM customers;

-- Q2. List all products in the Electronics category, cheapest first
SELECT name, price
FROM products
WHERE category = 'Electronics'
ORDER BY price ASC;

-- Q3. How many customers signed up in 2023?
SELECT COUNT(*) AS total_customers
FROM customers
WHERE signup_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Q4. What are the distinct cities our customers are from?
SELECT DISTINCT city FROM customers ORDER BY city;

-- Q5. How many orders are in each status?
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- Q6. What is the total revenue collected through payments?
SELECT SUM(amount) AS total_revenue FROM payments;

-- Q7. What is the most expensive product in each category?
SELECT category, MAX(price) AS max_price
FROM products
GROUP BY category
ORDER BY max_price DESC;

-- Q8. List the 5 most recent orders
SELECT order_id, customer_id, order_date, status
FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- Q9. Which customers placed which orders?
SELECT
    c.name        AS customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- Q10. Full order breakdown: customer + product + quantity + subtotal
SELECT
    c.name                        AS customer,
    p.name                        AS product,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS subtotal
FROM order_items oi
JOIN orders    o ON oi.order_id   = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON oi.product_id = p.product_id
ORDER BY subtotal DESC;

-- Q11. Which customers have placed more than 1 order?
SELECT
    c.name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Q12. Orders that have no payment (data quality check)
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.name AS customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

-- Q13. Classify customers by order count
SELECT
    c.name,
    COUNT(o.order_id) AS order_count,
    CASE
        WHEN COUNT(o.order_id) = 0 THEN 'Never ordered'
        WHEN COUNT(o.order_id) = 1 THEN 'One-time buyer'
        WHEN COUNT(o.order_id) BETWEEN 2 AND 3 THEN 'Returning customer'
        ELSE 'Loyal customer'
    END AS customer_type
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY order_count DESC;

-- Q14. Revenue by payment method
SELECT
    method,
    COUNT(*)              AS total_transactions,
    SUM(amount)           AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM payments
GROUP BY method
ORDER BY total_revenue DESC;

-- Q15. Top 5 best-selling products by revenue
SELECT
    p.name     AS product,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    SUM(oi.quantity)                 AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name, p.category
ORDER BY total_revenue DESC
LIMIT 5;

-- Q16. Which city generates the most revenue?
SELECT
    c.city,
    SUM(p.amount) AS city_revenue
FROM payments p
JOIN orders    o ON p.order_id    = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- Q17. Products that have never been ordered
SELECT name, category, price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);