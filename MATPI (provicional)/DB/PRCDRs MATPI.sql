CREATE DATABASE IF NOT EXISTS MATPI;
USE MATPI;

-- ========================================
-- PROCEDIMIENTOS ALMACENADOS - MATPI
-- ========================================

-- 1. Agregar nuevo pedido
DELIMITER //
CREATE PROCEDURE sp_agregar_pedido (
    IN p_descripcion VARCHAR(150),
    IN p_fecha DATE,
    IN p_estado BOOLEAN,
    IN p_valor MEDIUMINT UNSIGNED,
    IN p_id_usuario TINYINT UNSIGNED
)
BEGIN
    INSERT INTO pedido (descripcion, fecha, estado, valor, id_usuario)
    VALUES (p_descripcion, p_fecha, p_estado, p_valor, p_id_usuario);
END;
//
DELIMITER ;

-- 2. Listar productos
DELIMITER //
CREATE PROCEDURE sp_listar_productos()
BEGIN
    SELECT id, nombre_producto, descripcion, categoria, valor
    FROM producto;
END;
//
DELIMITER ;

-- 3. Consultar facturas de un usuario
DELIMITER //
CREATE PROCEDURE sp_facturas_por_usuario (
    IN p_id_usuario TINYINT UNSIGNED
)
BEGIN
    SELECT f.id, f.cantidad, f.valor_total, f.iva, f.id_pedido
    FROM factura f
    WHERE f.id_usuario = p_id_usuario;
END;
//
DELIMITER ;

-- 4. Actualizar estado de un pedido
DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_pedido (
    IN p_id_pedido TINYINT UNSIGNED,
    IN p_nuevo_estado BOOLEAN
)
BEGIN
    UPDATE pedido
    SET estado = p_nuevo_estado
    WHERE id = p_id_pedido;
END;
//
DELIMITER ;

-- 5. Registrar materia prima
DELIMITER //
CREATE PROCEDURE sp_registrar_materia_prima (
    IN p_descripcion VARCHAR(150),
    IN p_cantidad TINYINT UNSIGNED,
    IN p_fecha_ingreso DATE,
    IN p_fecha_vencimiento DATE
)
BEGIN
    INSERT INTO materia_prima (descripcion, cantidad, fecha_ingreso, fecha_vencimiento)
    VALUES (p_descripcion, p_cantidad, p_fecha_ingreso, p_fecha_vencimiento);
END;
//
DELIMITER ;

-- 6. Materias primas por vencer
DELIMITER //
CREATE PROCEDURE sp_materias_primas_por_vencer (
    IN p_dias INT
)
BEGIN
    SELECT *
    FROM materia_prima
    WHERE fecha_vencimiento <= DATE_ADD(CURDATE(), INTERVAL p_dias DAY);
END;
//
DELIMITER ;

-- 7. Resumen de pedidos por usuario
DELIMITER //
CREATE PROCEDURE sp_resumen_pedidos_usuario (
    IN p_id_usuario TINYINT UNSIGNED
)
BEGIN
    SELECT u.nombre_completo, COUNT(p.id) AS total_pedidos, SUM(p.valor) AS total_valor
    FROM usuario u
    JOIN pedido p ON u.id = p.id_usuario
    WHERE u.id = p_id_usuario
    GROUP BY u.id;
END;
//
DELIMITER ;
