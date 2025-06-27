create database MATPI;
use MATPI;

/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------Estructura-------------------------------------  */
/*  -------------------------------------------------------------------------------------  */
CREATE TABLE usuario (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    nombre_completo VARCHAR(60) NOT NULL,
    contraseña VARCHAR(20) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono BIGINT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NULL, 
    estado BOOLEAN NOT NULL,
    rol ENUM('administrador', 'empleado', 'cliente') NOT NULL
);

CREATE TABLE pedido (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    descripcion varchar (150) NOT NULL,
    fecha DATE NOT NULL,
    estado BOOLEAN NOT NULL,
    valor MEDIUMINT UNSIGNED NOT NULL,
    id_usuario TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE reserva (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    fecha DATE NOT NULL,
    estado BOOLEAN NOT NULL,
    id_usuario TINYINT UNSIGNED NOT NULL,
    id_pedido TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE factura (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    cantidad TINYINT(20) UNSIGNED NOT NULL,
    valor_total MEDIUMINT UNSIGNED NOT NULL,
    iva DECIMAL(10,2) NOT NULL,
    id_pedido TINYINT UNSIGNED NOT NULL,
    id_usuario TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE materia_prima (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    cantidad TINYINT UNSIGNED NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL
);

CREATE TABLE producto (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    nombre_producto VARCHAR(10) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    cantidad TINYINT UNSIGNED NOT NULL,
    valor MEDIUMINT UNSIGNED NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    id_reserva TINYINT UNSIGNED NOT NULL,
    id_materia_prima TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id),
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id)
);

CREATE TABLE proveedor (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono BIGINT NOT NULL,
    id_usuario TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE detalles_suministra (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    id_proveedor TINYINT UNSIGNED NOT NULL,
    id_materia_prima TINYINT UNSIGNED NOT NULL,
    cantidad MEDIUMINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id),
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id)
);

CREATE TABLE detalles_agrega (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL,
    id_materia_prima TINYINT UNSIGNED NOT NULL,
    id_producto TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id),
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);



/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------vistas-----------------------------------------  */
/*  -------------------------------------------------------------------------------------  */

-- Vista de usuarios activos con su rol
CREATE VIEW vista_usuarios_activos AS
SELECT id, nombre_completo, correo, rol
FROM usuario
WHERE estado = true;

-- Vista de pedidos realizados por cada usuario con sus datos de contacto
CREATE VIEW vista_pedidos_por_usuario AS
SELECT u.nombre_completo, u.correo, u.telefono, p.id AS id_pedido, p.fecha, p.valor
FROM usuario u
JOIN pedido p ON u.id = p.id_usuario;

-- Vista de reservas confirmadas con nombre del cliente
CREATE VIEW vista_reservas_confirmadas AS
SELECT r.id AS id_reserva, r.fecha, u.nombre_completo
FROM reserva r
JOIN usuario u ON r.id_usuario = u.id
WHERE r.estado = true;

-- Vista de facturación por pedido con total y IVA
CREATE VIEW vista_facturacion_detallada AS
SELECT f.id, f.cantidad, f.valor_total, f.iva, u.nombre_completo, p.fecha
FROM factura f
JOIN pedido p ON f.id_pedido = p.id
JOIN usuario u ON f.id_usuario = u.id;

-- Vista de productos con su materia prima y categoría
CREATE VIEW vista_productos_con_materia_prima AS
SELECT pr.id, pr.nombre_producto, pr.categoria, mp.descripcion AS materia_prima
FROM producto pr
JOIN materia_prima mp ON pr.id_materia_prima = mp.id;

-- Vista de materias primas próximas a vencer
CREATE VIEW vista_materias_primas_a_vencer AS
SELECT id, descripcion, cantidad, fecha_vencimiento
FROM materia_prima
WHERE fecha_vencimiento <= CURDATE() + INTERVAL 7 DAY;

-- Vista de proveedores y los productos que suministran
CREATE VIEW vista_proveedores_materia_prima AS
SELECT p.nombre AS proveedor, mp.descripcion AS materia_prima, ds.cantidad
FROM proveedor p
JOIN detalles_suministra ds ON p.id = ds.id_proveedor
JOIN materia_prima mp ON ds.id_materia_prima = mp.id;

-- Vista de productos y sus ingredientes (materias primas)
CREATE VIEW vista_productos_ingredientes AS
SELECT pr.nombre_producto, mp.descripcion AS ingrediente
FROM detalles_agrega da
JOIN producto pr ON da.id_producto = pr.id
JOIN materia_prima mp ON da.id_materia_prima = mp.id;

-- 9. Vista del inventario actual de productos
CREATE VIEW vista_inventario_productos AS
SELECT nombre_producto, cantidad, valor, categoria
FROM producto;

-- Vista de usuarios con sus pedidos y facturación total
CREATE VIEW vista_usuarios_con_facturacion AS
SELECT u.nombre_completo, p.id AS pedido_id, f.valor_total
FROM usuario u
JOIN pedido p ON u.id = p.id_usuario
JOIN factura f ON f.id_pedido = p.id;



/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------Triggers---------------------------------------  */
/*  -------------------------------------------------------------------------------------  */


DELIMITER $$

CREATE TRIGGER cancelar_pedido_valor_cero
BEFORE INSERT ON pedido
FOR EACH ROW
BEGIN
    IF NEW.valor = 0 THEN
        SET NEW.estado = FALSE;
    END IF;
END$$

DELIMITER ;


-- actualizar el estado del usuario a inactivo si no tiene pedidos
DELIMITER $$
CREATE TRIGGER inactivar_usuario_sin_pedidos
AFTER DELETE ON pedido
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pedido WHERE id_usuario = OLD.id_usuario
    ) THEN
        UPDATE usuario SET estado = false WHERE id = OLD.id_usuario;
    END IF;
END$$
DELIMITER ;



-- prevenir que se inserte una materia prima vencida
DELIMITER $$
CREATE TRIGGER validar_fecha_vencimiento_mp
BEFORE INSERT ON materia_prima
FOR EACH ROW
BEGIN
    IF NEW.fecha_vencimiento < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede ingresar materia prima vencida.';
    END IF;
END$$
DELIMITER ;



-- restar automáticamente la cantidad usada de materia prima al crear un producto
DELIMITER $$
CREATE TRIGGER descontar_materia_prima_producto
AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    UPDATE materia_prima
    SET cantidad = cantidad - NEW.cantidad
    WHERE id = NEW.id_materia_prima;
END$$
DELIMITER ;



-- enviar advertencia si un proveedor repite el correo
DELIMITER $$
CREATE TRIGGER evitar_correo_duplicado_proveedor
BEFORE INSERT ON proveedor
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM proveedor WHERE correo = NEW.correo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El correo del proveedor ya está registrado.';
    END IF;
END$$
DELIMITER ;







