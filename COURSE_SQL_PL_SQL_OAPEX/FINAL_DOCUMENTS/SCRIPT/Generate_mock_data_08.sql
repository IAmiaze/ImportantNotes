-- Clean up existing tables
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;

-- 1. Customers Table
CREATE TABLE customers (
    customer_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    email         VARCHAR2(100),
    created_date  DATE
);

-- 2. Products Table
CREATE TABLE products (
    product_id    NUMBER PRIMARY KEY,
    product_name  VARCHAR2(100),
    category      VARCHAR2(50),
    price         NUMBER(10, 2)
);

-- 3. Orders Table
CREATE TABLE orders (
    order_id      NUMBER PRIMARY KEY,
    customer_id   NUMBER REFERENCES customers(customer_id),
    product_id    NUMBER REFERENCES products(product_id),
    quantity      NUMBER(3),
    total_amount  NUMBER(10, 2),
    order_date    DATE
);

---generate 5k Customers

INSERT INTO customers (customer_id, first_name, last_name, email, created_date)
WITH first_names AS (
    SELECT column_value AS fname, ROWNUM AS id 
    FROM TABLE(sys.odcivarchar2list('James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth'))
),
last_names AS (
    SELECT column_value AS lname, ROWNUM AS id 
    FROM TABLE(sys.odcivarchar2list('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez'))
)
SELECT 
    level AS customer_id,
    fn.fname,
    ln.lname,
    LOWER(fn.fname || '.' || ln.lname || level || '@example.com') AS email,
    TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 1095)) AS created_date
FROM dual
CROSS JOIN (
    SELECT fn.fname, ln.lname 
    FROM (SELECT fname, DBMS_RANDOM.VALUE() rnd FROM first_names) fn
    CROSS JOIN (SELECT lname, DBMS_RANDOM.VALUE() rnd FROM last_names) ln
) 
WHERE ROWNUM <= 5000
CONNECT BY level <= 5000;

---generate 5k productss


INSERT INTO products (product_id, product_name, category, price)
WITH categories AS (
    SELECT column_value AS cat_name, ROWNUM AS id
    FROM TABLE(sys.odcivarchar2list('Electronics', 'Clothing', 'Home & Kitchen', 'Books', 'Sports'))
),
adjectives AS (
    SELECT column_value AS adj, ROWNUM AS id
    FROM TABLE(sys.odcivarchar2list('Pro', 'Ultra', 'Basic', 'Deluxe', 'Compact'))
)
SELECT 
    level AS product_id,
    a.adj || ' ' || c.cat_name || ' Item ' || level AS product_name,
    c.cat_name AS category,
    ROUND(DBMS_RANDOM.VALUE(10, 1000), 2) AS price
FROM dual
CROSS JOIN categories c
CROSS JOIN adjectives a
WHERE ROWNUM <= 5000
CONNECT BY level <= 5000;

COMMIT;

----generate 5k Ordes

INSERT INTO orders (order_id, customer_id, product_id, quantity, total_amount, order_date)
WITH raw_orders AS (
    SELECT 
        level AS order_id,
        TRUNC(DBMS_RANDOM.VALUE(1, 5001)) AS customer_id,
        TRUNC(DBMS_RANDOM.VALUE(1, 5001)) AS product_id,
        TRUNC(DBMS_RANDOM.VALUE(1, 10)) AS quantity,
        TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 365)) AS order_date
    FROM dual
    CONNECT BY level <= 5000
)
SELECT 
    o.order_id,
    o.customer_id,
    o.product_id,
    o.quantity,
    ROUND(o.quantity * p.price, 2) AS total_amount,
    o.order_date
FROM raw_orders o
JOIN products p ON o.product_id = p.product_id;

COMMIT;