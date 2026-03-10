-- CREAR BASE DE DATOS
CREATE DATABASE inventario_db;

USE inventario_db;

-- TABLA USUARIOS
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin','operador') NOT NULL
);

-- TABLA PRODUCTOS
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    ubicacion VARCHAR(100) NOT NULL
);

-- TABLA VENTAS
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    cantidad INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- TRIGGER PARA CALCULAR TOTAL AUTOMATICAMENTE
DELIMITER $$

CREATE TRIGGER calcular_total_venta
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    DECLARE precio DECIMAL(10,2);

    SELECT precio_unitario INTO precio
    FROM productos
    WHERE id = NEW.producto_id;

    SET NEW.total = precio * NEW.cantidad;
END$$

DELIMITER ;

-- VISTA REPORTE INVENTARIO GENERAL
CREATE VIEW reporte_inventario AS
SELECT
codigo_producto,
nombre,
stock,
precio_unitario,
(stock * precio_unitario) AS valor_total
FROM productos;

-- VISTA PRODUCTOS POR UBICACION
CREATE VIEW productos_por_ubicacion AS
SELECT
ubicacion,
nombre,
stock
FROM productos
ORDER BY ubicacion;

-- PROCEDIMIENTO PARA REGISTRAR PRODUCTO
DELIMITER $$

CREATE PROCEDURE registrar_producto(
    IN p_codigo VARCHAR(50),
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_precio DECIMAL(10,2),
    IN p_stock INT,
    IN p_ubicacion VARCHAR(100)
)
BEGIN
    INSERT INTO productos(
        codigo_producto,
        nombre,
        descripcion,
        precio_unitario,
        stock,
        ubicacion
    )
    VALUES(
        p_codigo,
        p_nombre,
        p_descripcion,
        p_precio,
        p_stock,
        p_ubicacion
    );
END$$

DELIMITER ;

-- CONSULTAS AVANZADAS

-- PRODUCTOS CON BAJO STOCK
SELECT * FROM productos
WHERE stock < 10;

-- PRODUCTOS POR RANGO DE PRECIOS
SELECT * FROM productos
WHERE precio_unitario BETWEEN 50 AND 500;

-- PRODUCTOS POR UBICACION
SELECT * FROM productos
WHERE ubicacion = 'Almacen A';