-- SECTION 1: SCHEMA
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


-- SECTION 2: SAMPLE DATA


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
