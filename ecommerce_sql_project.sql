-- ============================================================
--  E-COMMERCE SALES ANALYSIS  |  PostgreSQL Project
--  For: AIDS 2nd Year Student  |  Goal: Data Analyst / DS / MLE
--  Structure:
--    1. Schema creation
--    2. Sample data (50+ rows across tables)
--    3. BEGINNER queries   (SELECT, WHERE, ORDER BY, GROUP BY)
--    4. INTERMEDIATE queries (JOINs, HAVING, CASE WHEN, Subqueries)
--    5. ADVANCED queries   (CTEs, Window Functions, Date Analysis)
--    6. Challenge questions (solve these yourself!)
-- ============================================================


-- =======================
--  SECTION 1: SCHEMA
-- =======================

DROP TABLE IF EXISTS payments    CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders      CASCADE;
DROP TABLE IF EXISTS products    CASCADE;
DROP TABLE IF EXISTS customers   CASCADE;

CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    city          VARCHAR(80),
    signup_date   DATE NOT NULL
);

CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(150) NOT NULL,
    category      VARCHAR(80),
    price         NUMERIC(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers(customer_id),
    order_date    DATE NOT NULL,
    status        VARCHAR(30) CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

CREATE TABLE order_items (
    item_id       SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    product_id    INT REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10, 2) NOT NULL   -- price at time of order
);

CREATE TABLE payments (
    payment_id    SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    amount        NUMERIC(10, 2) NOT NULL,
    method        VARCHAR(30) CHECK (method IN ('UPI','credit_card','debit_card','netbanking','COD')),
    paid_at       TIMESTAMP
);


-- =======================
--  SECTION 2: SAMPLE DATA
-- =======================

-- Customers (20 rows)
INSERT INTO customers (name, email, city, signup_date) VALUES
('Arjun Sharma',    'arjun@gmail.com',    'Chennai',    '2023-01-15'),
('Priya Nair',      'priya@gmail.com',    'Bangalore',  '2023-02-20'),
('Rahul Verma',     'rahul@gmail.com',    'Delhi',      '2023-03-05'),
('Sneha Iyer',      'sneha@gmail.com',    'Chennai',    '2023-03-18'),
('Karthik Raj',     'karthik@gmail.com',  'Hyderabad',  '2023-04-01'),
('Anjali Das',      'anjali@gmail.com',   'Mumbai',     '2023-04-22'),
('Vikram Singh',    'vikram@gmail.com',   'Delhi',      '2023-05-10'),
('Meera Pillai',    'meera@gmail.com',    'Kochi',      '2023-05-30'),
('Suresh Kumar',    'suresh@gmail.com',   'Chennai',    '2023-06-12'),
('Deepa Menon',     'deepa@gmail.com',    'Bangalore',  '2023-06-25'),
('Arun Patel',      'arun@gmail.com',     'Ahmedabad',  '2023-07-08'),
('Lakshmi Bai',     'lakshmi@gmail.com',  'Chennai',    '2023-07-20'),
('Naveen Reddy',    'naveen@gmail.com',   'Hyderabad',  '2023-08-02'),
('Pooja Gupta',     'pooja@gmail.com',    'Mumbai',     '2023-08-15'),
('Harish Nair',     'harish@gmail.com',   'Kochi',      '2023-09-01'),
('Divya Rajan',     'divya@gmail.com',    'Bangalore',  '2023-09-18'),
('Mithun Babu',     'mithun@gmail.com',   'Chennai',    '2023-10-05'),
('Kavitha Sree',    'kavitha@gmail.com',  'Delhi',      '2023-10-22'),
('Rajesh Pillai',   'rajesh@gmail.com',   'Kochi',      '2023-11-10'),
('Saranya Kumar',   'saranya@gmail.com',  'Bangalore',  '2023-12-01');

-- Products (15 rows)
INSERT INTO products (name, category, price) VALUES
('Wireless Earbuds',       'Electronics',   1499.00),
('Mechanical Keyboard',    'Electronics',   3299.00),
('USB-C Hub',              'Electronics',    899.00),
('Yoga Mat',               'Fitness',        699.00),
('Resistance Bands Set',   'Fitness',        349.00),
('Protein Powder 1kg',     'Health',        1199.00),
('Cotton T-Shirt',         'Clothing',       399.00),
('Running Shoes',          'Clothing',      2499.00),
('Stainless Steel Bottle', 'Kitchen',        549.00),
('Air Fryer',              'Kitchen',       4999.00),
('Novel - Atomic Habits',  'Books',          299.00),
('Python Crash Course',    'Books',          499.00),
('Desk Lamp LED',          'Electronics',    799.00),
('Multivitamin 60 tabs',   'Health',         649.00),
('Notebook Set (3 pack)',   'Stationery',    199.00);

-- Orders (30 rows)
INSERT INTO orders (customer_id, order_date, status) VALUES
(1,  '2024-01-05', 'delivered'),
(2,  '2024-01-12', 'delivered'),
(3,  '2024-01-20', 'delivered'),
(4,  '2024-02-03', 'delivered'),
(5,  '2024-02-14', 'shipped'),
(1,  '2024-02-28', 'delivered'),
(6,  '2024-03-05', 'delivered'),
(7,  '2024-03-15', 'cancelled'),
(8,  '2024-03-22', 'delivered'),
(9,  '2024-04-01', 'delivered'),
(10, '2024-04-10', 'delivered'),
(2,  '2024-04-18', 'processing'),
(11, '2024-05-02', 'delivered'),
(12, '2024-05-10', 'delivered'),
(3,  '2024-05-20', 'delivered'),
(13, '2024-06-01', 'delivered'),
(14, '2024-06-12', 'cancelled'),
(4,  '2024-06-25', 'delivered'),
(15, '2024-07-05', 'delivered'),
(16, '2024-07-18', 'delivered'),
(5,  '2024-07-30', 'pending'),
(17, '2024-08-08', 'delivered'),
(18, '2024-08-20', 'delivered'),
(6,  '2024-09-01', 'delivered'),
(19, '2024-09-14', 'shipped'),
(20, '2024-09-28', 'delivered'),
(1,  '2024-10-10', 'delivered'),
(9,  '2024-10-22', 'delivered'),
(12, '2024-11-05', 'delivered'),
(7,  '2024-11-18', 'pending');

-- Order items (40 rows)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1,  1, 1499.00), (1,  3,  1,  899.00),
(2,  4,  1,  699.00), (2,  5,  2,  349.00),
(3,  2,  1, 3299.00),
(4,  6,  1, 1199.00), (4,  14, 1,  649.00),
(5,  8,  1, 2499.00),
(6,  7,  3,  399.00), (6,  15, 2,  199.00),
(7,  10, 1, 4999.00),
(8,  11, 2,  299.00), (8,  12, 1,  499.00),
(9,  9,  2,  549.00),
(10, 1,  1, 1499.00), (10, 13, 1,  799.00),
(11, 6,  2, 1199.00),
(12, 4,  2,  699.00),
(13, 3,  1,  899.00), (13, 1,  1, 1499.00),
(14, 8,  1, 2499.00), (14, 7,  2,  399.00),
(15, 2,  1, 3299.00),
(16, 5,  3,  349.00), (16, 9,  1,  549.00),
(17, 10, 1, 4999.00),
(18, 12, 2,  499.00), (18, 11, 3,  299.00),
(19, 14, 2,  649.00),
(20, 7,  4,  399.00), (20, 15, 5,  199.00),
(21, 1,  2, 1499.00),
(22, 13, 1,  799.00), (22, 3,  2,  899.00),
(23, 6,  1, 1199.00),
(24, 8,  1, 2499.00), (24, 5,  2,  349.00),
(25, 2,  1, 3299.00),
(26, 4,  1,  699.00),
(27, 1,  1, 1499.00), (27, 13, 2,  799.00),
(28, 9,  3,  549.00),
(29, 12, 1,  499.00), (29, 11, 1,  299.00),
(30, 7,  2,  399.00);

-- Payments (note: orders 8 and 17 are cancelled, no payment; order 21 pending = no payment yet)
INSERT INTO payments (order_id, amount, method, paid_at) VALUES
(1,  2398.00, 'UPI',         '2024-01-05 10:30:00'),
(2,  1397.00, 'credit_card', '2024-01-12 14:15:00'),
(3,  3299.00, 'netbanking',  '2024-01-20 09:00:00'),
(4,  1848.00, 'UPI',         '2024-02-03 11:45:00'),
(5,  2499.00, 'debit_card',  '2024-02-14 16:00:00'),
(6,  1595.00, 'UPI',         '2024-02-28 13:20:00'),
(7,  4999.00, 'credit_card', '2024-03-05 10:10:00'),
(9,  1098.00, 'COD',         '2024-03-22 18:00:00'),
(10, 2298.00, 'UPI',         '2024-04-01 09:30:00'),
(11, 2398.00, 'netbanking',  '2024-04-10 12:00:00'),
(12, 2398.00, 'credit_card', '2024-04-18 15:45:00'),
(13, 1398.00, 'UPI',         '2024-05-02 10:00:00'),
(14, 2398.00, 'debit_card',  '2024-05-10 11:30:00'),
(15, 3299.00, 'credit_card', '2024-05-20 14:00:00'),
(16, 1596.00, 'UPI',         '2024-06-01 09:15:00'),
(18, 1894.00, 'COD',         '2024-06-25 19:00:00'),
(19, 1298.00, 'netbanking',  '2024-07-05 10:30:00'),
(20, 2591.00, 'UPI',         '2024-07-18 13:00:00'),
(22, 2597.00, 'credit_card', '2024-08-08 11:00:00'),
(23, 1199.00, 'UPI',         '2024-08-20 14:30:00'),
(24, 3197.00, 'debit_card',  '2024-09-01 10:45:00'),
(25, 3299.00, 'netbanking',  '2024-09-14 09:00:00'),
(26,  699.00, 'UPI',         '2024-09-28 12:15:00'),
(27, 3097.00, 'credit_card', '2024-10-10 11:30:00'),
(28, 1647.00, 'COD',         '2024-10-22 18:30:00'),
(29,  798.00, 'UPI',         '2024-11-05 10:00:00');
-- orders 8 (cancelled), 17 (cancelled), 21 (pending), 30 (pending) have NO payment row


-- ==============================================
--  SECTION 3: BEGINNER QUERIES
--  Concepts: SELECT, WHERE, ORDER BY, GROUP BY,
--            LIMIT, DISTINCT, basic aggregates
-- ==============================================

-- Q1. View all customers
SELECT * FROM customers;

-- Q2. List all products in the 'Electronics' category, cheapest first
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


-- ==============================================
--  SECTION 4: INTERMEDIATE QUERIES
--  Concepts: JOINs, HAVING, CASE WHEN,
--            Subqueries, string/date functions
-- ==============================================

-- Q9. Which customers placed which orders? (INNER JOIN)
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
    c.name                              AS customer,
    p.name                              AS product,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)       AS subtotal
FROM order_items oi
JOIN orders   o ON oi.order_id   = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON oi.product_id = p.product_id
ORDER BY subtotal DESC;

-- Q11. Which customers have placed MORE THAN 1 order? (HAVING)
SELECT
    c.name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Q12. Orders that have NO payment (unpaid / data quality check) — LEFT JOIN trick
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.name AS customer
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE p.payment_id IS NULL;

-- Q13. Classify customers by order count (CASE WHEN)
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
    COUNT(*)      AS total_transactions,
    SUM(amount)   AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value
FROM payments
GROUP BY method
ORDER BY total_revenue DESC;

-- Q15. Top 5 best-selling products by revenue
SELECT
    p.name        AS product,
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
JOIN orders    o ON p.order_id   = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- Q17. Products that have NEVER been ordered (subquery)
SELECT name, category, price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);


-- ==============================================
--  SECTION 5: ADVANCED QUERIES
--  Concepts: CTEs, Window Functions,
--            Date truncation, Running totals,
--            Ranking, Lag/Lead
-- ==============================================

-- Q18. Monthly revenue trend (date_trunc)
SELECT
    DATE_TRUNC('month', paid_at) AS month,
    COUNT(*)                     AS transactions,
    SUM(amount)                  AS monthly_revenue
FROM payments
GROUP BY DATE_TRUNC('month', paid_at)
ORDER BY DATE_TRUNC('month', paid_at);

-- Q19. Month-over-month revenue growth using LAG()
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', paid_at)::DATE AS month,
        SUM(amount) AS revenue
    FROM payments
    GROUP BY DATE_TRUNC('month', paid_at)::DATE
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100
    , 2) AS growth_pct
FROM monthly
ORDER BY month;

-- Q20. Rank products by revenue within each category (RANK + PARTITION BY)
SELECT
    p.category,
    p.name,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.name
ORDER BY p.category, rank_in_category;

-- Q21. Running total of revenue over time (cumulative sum)
SELECT
    DATE_TRUNC('month', paid_at)::DATE AS month,
    SUM(amount)                        AS monthly_revenue,
    SUM(SUM(amount)) OVER (
        ORDER BY DATE_TRUNC('month', paid_at)
    )                                  AS cumulative_revenue
FROM payments
GROUP BY DATE_TRUNC('month', paid_at)
ORDER BY DATE_TRUNC('month', paid_at);

-- Q22. Each customer's most recent order and days since ordering
SELECT
    c.name,
    c.city,
    MAX(o.order_date)                                AS last_order_date,
    CURRENT_DATE - MAX(o.order_date)                 AS days_since_last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name, c.city
ORDER BY days_since_last_order DESC NULLS LAST;

-- Q23. Customers who haven't ordered in last 90 days (churn risk)
WITH last_orders AS (
    SELECT
        c.customer_id,
        c.name,
        c.email,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name, c.email
)
SELECT
    name,
    email,
    last_order_date,
    CURRENT_DATE - last_order_date AS days_inactive
FROM last_orders
WHERE last_order_date < CURRENT_DATE - INTERVAL '90 days'
   OR last_order_date IS NULL
ORDER BY days_inactive DESC NULLS LAST;

-- Q24. Basket analysis — average items per order and average order value
WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity)              AS item_count,
        SUM(quantity * unit_price) AS order_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    ROUND(AVG(item_count),  2) AS avg_items_per_order,
    ROUND(AVG(order_value), 2) AS avg_order_value,
    ROUND(MIN(order_value), 2) AS min_order_value,
    ROUND(MAX(order_value), 2) AS max_order_value
FROM order_totals;

-- Q25. Top customer by revenue in each city (ROW_NUMBER)
WITH customer_revenue AS (
    SELECT
        c.city,
        c.name,
        SUM(p.amount) AS total_spent
    FROM payments p
    JOIN orders    o ON p.order_id    = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.city, c.name
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY city ORDER BY total_spent DESC
        ) AS rn
    FROM customer_revenue
)
SELECT city, name, total_spent
FROM ranked
WHERE rn = 1
ORDER BY total_spent DESC;


-- =============================================
--  SECTION 6: CHALLENGE QUESTIONS
--  Try solving these yourself!
--  (Answers available — just ask)
-- =============================================

-- BEGINNER
-- C1. List all products priced above ₹1000, sorted by price descending.
-- C2. How many customers are from Chennai?
-- C3. What is the average price of products in the 'Health' category?

-- INTERMEDIATE
-- C4. Which orders contain more than 2 different products?
-- C5. Find all customers who have placed at least one 'cancelled' order.
-- C6. What percentage of orders were paid by UPI?
-- C7. List products along with how many times they were ordered.

-- ADVANCED
-- C8. Find the top 3 months with the highest revenue.
-- C9. For each customer, calculate: total orders, total spent, and average order value.
-- C10. Which products appear together most often in the same order? (co-occurrence)
-- C11. Create a cohort: group customers by signup month and count orders per group.
-- C12. Find customers whose spending is above the overall average spending per customer.


SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;


SELECT
    customers.name,
    SUM(payments.amount) AS total_spent,
    CASE
	    WHEN SUM(payments.amount) > 8000 THEN 'VVIP Customer'
        WHEN SUM(payments.amount) > 5000 THEN 'VIP Customer'
        WHEN SUM(payments.amount) > 2000 THEN 'Regular Customer'
        WHEN SUM(payments.amount) > 0    THEN 'Low Spender'
        ELSE 'No Purchase'
    END AS customer_segment
FROM customers
LEFT JOIN orders   ON customers.customer_id = orders.customer_id
LEFT JOIN payments ON orders.order_id       = payments.order_id
GROUP BY customers.name
ORDER BY total_spent DESC NULLS LAST;


