-- CREATE DATABASE
CREATE DATABASE inventory_db;

USE inventory_db;

-- USERS TABLE
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','operator') NOT NULL
);

-- PRODUCTS TABLE
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- SALES TABLE
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT,
    date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- TRIGGER TO CALCULATE SALE TOTAL
DELIMITER $$

CREATE TRIGGER calculate_sale_total
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE price DECIMAL(10,2);

    SELECT unit_price INTO price
    FROM products
    WHERE id = NEW.product_id;

    SET NEW.total = price * NEW.quantity;
END$$

DELIMITER ;

-- INVENTORY REPORT VIEW
CREATE VIEW inventory_report AS
SELECT
product_code,
name,
stock,
unit_price,
(stock * unit_price) AS total_value
FROM products;

-- PRODUCTS BY LOCATION VIEW
CREATE VIEW products_by_location AS
SELECT
location,
name,
stock
FROM products
ORDER BY location;

-- STORED PROCEDURE TO REGISTER PRODUCT
DELIMITER $$

CREATE PROCEDURE register_product(
    IN p_code VARCHAR(50),
    IN p_name VARCHAR(100),
    IN p_description TEXT,
    IN p_price DECIMAL(10,2),
    IN p_stock INT,
    IN p_location VARCHAR(100)
)
BEGIN
    INSERT INTO products(
        product_code,
        name,
        description,
        unit_price,
        stock,
        location
    )
    VALUES(
        p_code,
        p_name,
        p_description,
        p_price,
        p_stock,
        p_location
    );
END$$

DELIMITER ;

-- ADVANCED QUERIES

-- LOW STOCK PRODUCTS
SELECT * FROM products
WHERE stock < 10;

-- PRODUCTS BY PRICE RANGE
SELECT * FROM products
WHERE unit_price BETWEEN 50 AND 500;

-- PRODUCTS BY LOCATION
SELECT * FROM products
WHERE location = 'Warehouse A';