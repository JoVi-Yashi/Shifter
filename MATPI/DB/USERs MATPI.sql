USE MATPI;

-- 1. Creación de usuarios

-- Usuario DBA (Administrador de Base de Datos - para fines de mantenimiento y desarrollo)
CREATE USER 'dba_matpi'@'localhost' IDENTIFIED BY 'dba_pass123!';

-- Usuario Administrador (Rol de 'administrador' en la aplicación MATPI)
CREATE USER 'admin_matpi'@'localhost' IDENTIFIED BY 'admin_pass123!';

-- Usuario Empleado (Rol de 'empleado' en la aplicación MATPI)
CREATE USER 'empleado_matpi'@'localhost' IDENTIFIED BY 'empleado_pass123!';

-- Usuario Cliente (Rol de 'cliente' en la aplicación MATPI)
CREATE USER 'cliente_matpi'@'localhost' IDENTIFIED BY 'cliente_pass123!';

-- 2. Proporcionar el acceso requerido a los usuarios con la información que requiere.

-- Privilegios para el usuario DBA (acceso completo a todas las bases de datos)
GRANT ALL PRIVILEGES ON * . * TO 'dba_matpi'@'localhost';

-- Privilegios para el usuario Administrador (acceso completo a la base de datos MATPI)
GRANT ALL PRIVILEGES ON MATPI . * TO 'admin_matpi'@'localhost';

-- Privilegios para el usuario Empleado (puede gestionar pedidos, reservas, inventario, etc.)
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.pedido TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.reserva TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.factura TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.materia_prima TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.producto TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.proveedor TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.detalles_suministra TO 'empleado_matpi'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MATPI.detalles_agrega TO 'empleado_matpi'@'localhost';
-- El empleado puede ver usuarios pero no modificarlos (excepto quizás su propia contraseña a través de la aplicación).
GRANT SELECT ON MATPI.usuario TO 'empleado_matpi'@'localhost'; 


-- Privilegios para el usuario Cliente (puede ver productos, realizar pedidos y reservas)
GRANT SELECT ON MATPI.producto TO 'cliente_matpi'@'localhost';
GRANT SELECT, INSERT ON MATPI.pedido TO 'cliente_matpi'@'localhost';
GRANT SELECT, INSERT ON MATPI.reserva TO 'cliente_matpi'@'localhost';
-- Un cliente solo debería ver sus propias facturas y datos de usuario; esto se manejaría mejor en la lógica de la aplicación
-- o con vistas y seguridad a nivel de fila en un entorno de producción avanzado.
GRANT SELECT ON MATPI.factura TO 'cliente_matpi'@'localhost';
GRANT SELECT ON MATPI.usuario TO 'cliente_matpi'@'localhost';

-- 3. Refrescar todos los privilegios para que los cambios surtan efecto.
FLUSH PRIVILEGES;

-- *****************************************************************************
-- Ejemplos de inicio de sesión con los nuevos usuarios
-- (Estos comandos se ejecutan en la terminal o línea de comandos, NO en un cliente SQL)
-- *****************************************************************************

-- Iniciar sesión como DBA:
-- mysql -h localhost -u dba_matpi -p

-- Iniciar sesión como Administrador de MATPI:
-- mysql -h localhost -u admin_matpi -p

-- Iniciar sesión como Empleado de MATPI:
-- mysql -h localhost -u empleado_matpi -p

-- Iniciar sesión como Cliente de MATPI:
-- mysql -h localhost -u cliente_matpi -p