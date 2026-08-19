USE ecommerce_sales_analytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    country VARCHAR(50),
    age_range VARCHAR(10),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(10),
    catalog_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    gender VARCHAR(20)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    channel VARCHAR(30),
    discounted TINYINT(1),
    total_amount DECIMAL(10,2),
    sale_date DATE,
    customer_id INT,
    country VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


DESCRIBE customers;

