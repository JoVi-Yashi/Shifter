CREATE DATABASE IF NOT EXISTS MATPI;
USE MATPI;

-- ============================================
-- SISTEMA DE ROLES Y USUARIOS PARA BD MATPI
-- Requiere MySQL 8.0 o superior
-- ============================================

-- 0. CREACIÓN DE BASE DE DATOS (si no existe)
CREATE DATABASE IF NOT EXISTS MATPI;
USE MATPI;

-- 1. ELIMINACIÓN DE USUARIOS EXISTENTES
DROP USER IF EXISTS 'dba_matpi'@'localhost';
DROP USER IF EXISTS 'admin_matpi'@'localhost';
DROP USER IF EXISTS 'empleado_matpi'@'localhost';
DROP USER IF EXISTS 'cliente_matpi'@'localhost';

-- 2. ELIMINACIÓN DE ROLES EXISTENTES
DROP ROLE IF EXISTS 'rol_admin', 'rol_empleado', 'rol_cliente';

-- 3. CREACIÓN DE USUARIOS
CREATE USER 'dba_matpi'@'localhost' IDENTIFIED BY 'dba_matpi_2024!';
CREATE USER 'admin_matpi'@'localhost' IDENTIFIED BY 'admin_matpi_2024!';
CREATE USER 'empleado_matpi'@'localhost' IDENTIFIED BY 'empleado_matpi_2024!';
CREATE USER 'cliente_matpi'@'localhost' IDENTIFIED BY 'cliente_matpi_2024!';

-- 4. CREACIÓN DE ROLES
CREATE ROLE 'rol_admin';
CREATE ROLE 'rol_empleado';
CREATE ROLE 'rol_cliente';

-- 5. ASIGNACIÓN DE PRIVILEGIOS A ROLES
-- Administrador: acceso completo a la BD
GRANT ALL PRIVILEGES ON MATPI.* TO 'rol_admin';

-- Empleado: gestión operativa
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.pedido TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.reserva TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.factura TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.materia_prima TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.producto TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.proveedor TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.detalles_suministra TO 'rol_empleado';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.detalles_agrega TO 'rol_empleado';
GRANT SELECT ON MATPI.`usuario` TO 'rol_empleado';

-- Cliente: acceso limitado
GRANT SELECT ON MATPI.producto TO 'rol_cliente';
GRANT SELECT, INSERT ON MATPI.pedido TO 'rol_cliente';
GRANT SELECT, INSERT ON MATPI.reserva TO 'rol_cliente';
GRANT SELECT ON MATPI.factura TO 'rol_cliente';
GRANT SELECT ON MATPI.`usuario` TO 'rol_cliente';

-- 6. ASIGNACIÓN DE ROLES A USUARIOS
GRANT 'rol_admin' TO 'admin_matpi'@'localhost';
GRANT 'rol_empleado' TO 'empleado_matpi'@'localhost';
GRANT 'rol_cliente' TO 'cliente_matpi'@'localhost';

-- 7. ASIGNACIÓN DIRECTA AL DBA (sin rol)
GRANT ALL PRIVILEGES ON *.* TO 'dba_matpi'@'localhost' WITH GRANT OPTION;

-- 8. (OPCIONAL) ESTABLECER ROL POR DEFECTO
SET DEFAULT ROLE 'rol_admin' TO 'admin_matpi'@'localhost';
SET DEFAULT ROLE 'rol_empleado' TO 'empleado_matpi'@'localhost';
SET DEFAULT ROLE 'rol_cliente' TO 'cliente_matpi'@'localhost';

-- 9. VERIFICACIÓN
SELECT User, Host FROM mysql.user WHERE User LIKE '%matpi%';
SELECT * FROM information_schema.applicable_roles WHERE grantee LIKE "'%matpi'%";

-- ============================================
-- COMANDOS DE CONEXIÓN:
-- ============================================
/*
-- Conectar como DBA:
mysql -h localhost -u dba_matpi -p

-- Conectar como Administrador:
mysql -h localhost -u admin_matpi -p

-- Conectar como Empleado:
mysql -h localhost -u empleado_matpi -p

-- Conectar como Cliente:
mysql -h localhost -u cliente_matpi -p
*/