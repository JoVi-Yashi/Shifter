create database MATPI;
use MATPI;

/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------Estructura-------------------------------------  */
/*  -------------------------------------------------------------------------------------  */

create table usuario(
id tinyint unsigned primary key not null ,
nombre_completo varchar(255) not null,
contraseña varchar(255) not null,
correo varchar(255) not null,
telefono int unsigned not null,
direccion varchar(255) not null,
fecha_nacimiento date null, 
estado boolean not null,
rol enum('administrador', 'empleado', 'cliente' ) not null
) ;

create table fidelizacion(
id tinyint unsigned primary key not null,
numero_visitas tinyint unsigned not null,
fecha_inicio date not null,
cantidad_logros tinyint not null,
id_usuario tinyint unsigned not null,
foreign key (id_usuario) references usuario (id)
);

create table inventario(
id tinyint unsigned primary key not null,
nombre_producto varchar(255) not null,
descripcion varchar(255) not null,
cantidad tinyint unsigned not null,
valor mediumint unsigned not null,
categoria varchar(255) not null
);

create table reserva(
id tinyint unsigned primary key not null,
fecha date not null,
estado boolean not null,
id_usuario tinyint unsigned not null,
foreign key (id_usuario) references usuario (id),
cotizacion_inventario tinyint unsigned not null,
foreign key (cotizacion_inventario) references inventario (id)
);

create table pedido(
id tinyint unsigned primary key not null,
fecha date not null,
estado boolean not null,
valor mediumint unsigned not null,
id_usuario tinyint unsigned not null,
foreign key (id_usuario) references usuario (id)
);

create table factura(
id_detalles tinyint unsigned primary key not null,
cantidad tinyint unsigned not null,
valor_total mediumint unsigned not null,
iva float not null,
id_pedido tinyint unsigned not null,
id_inventario tinyint unsigned not null,
foreign key (id_pedido) references pedido(id),
foreign key(id_inventario) references inventario(id)
);


/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------vistas-----------------------------------------  */
/*  -------------------------------------------------------------------------------------  */

-- Vista de usuarios con información de fidelización
CREATE VIEW vista_usuario_fidelizacion AS
SELECT 
    u.id AS id_usuario,
    u.nombre_completo,
    f.numero_visitas,
    f.cantidad_logros,
    f.fecha_inicio
FROM usuario u
JOIN fidelizacion f ON u.id = f.id_usuario;


-- Vista de reservas con información del producto reservado
CREATE VIEW vista_reservas_productos AS
SELECT 
    r.id AS id_reserva,
    r.fecha,
    r.estado,
    u.nombre_completo AS usuario,
    i.nombre_producto,
    i.valor AS valor_producto
FROM reserva r
JOIN usuario u ON r.id_usuario = u.id
JOIN inventario i ON r.cotizacion_inventario = i.id;


-- Vista de pedidos realizados por usuarios
CREATE VIEW vista_pedidos_usuarios AS
SELECT 
    p.id AS id_pedido,
    p.fecha,
    p.estado,
    p.valor,
    u.nombre_completo
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id;

-- Vista de facturas con detalle de productos
CREATE VIEW vista_facturas_detalle AS
SELECT 
    f.id_detalles,
    f.cantidad,
    f.valor_total,
    p.fecha AS fecha_pedido,
    i.nombre_producto,
    u.nombre_completo AS cliente
FROM factura f
JOIN pedido p ON f.id_pedido = p.id
JOIN inventario i ON f.id_inventario = i.id
JOIN usuario u ON p.id_usuario = u.id;


-- Vista de inventario con cantidad baja
CREATE VIEW vista_inventario_bajo AS
SELECT 
    id,
    nombre_producto,
    cantidad,
    valor,
    categoria
FROM inventario
WHERE cantidad < 5;


-- Vista de clientes activos
CREATE VIEW vista_clientes_activos AS
SELECT 
    id,
    nombre_completo,
    correo,
    telefono,
    direccion
FROM usuario
WHERE estado = true AND rol = 'cliente';


-- Vista de empleados o administradores
CREATE VIEW vista_personal_empresa AS
SELECT 
    id,
    nombre_completo,
    rol
FROM usuario
WHERE rol IN ('empleado', 'administrador');


-- Vista resumen de fidelización
CREATE VIEW vista_ranking_fidelizacion AS
SELECT 
    u.nombre_completo,
    f.cantidad_logros,
    f.numero_visitas
FROM fidelizacion f
JOIN usuario u ON f.id_usuario = u.id
ORDER BY f.cantidad_logros DESC;


-- Vista de pedidos con su estado en texto
CREATE VIEW vista_estado_pedidos AS
SELECT 
    p.id,
    u.nombre_completo,
    p.fecha,
    CASE 
        WHEN p.estado = true THEN 'Completado'
        ELSE 'Pendiente'
    END AS estado_texto,
    p.valor
FROM pedido p
JOIN usuario u ON p.id_usuario = u.id;


-- Vista de resumen de facturación por cliente
CREATE VIEW vista_facturacion_clientes AS
SELECT 
    u.nombre_completo,
    SUM(f.valor_total) AS total_facturado,
    COUNT(f.id_detalles) AS numero_de_items
FROM factura f
JOIN pedido p ON f.id_pedido = p.id
JOIN usuario u ON p.id_usuario = u.id
GROUP BY u.id, u.nombre_completo;

/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------Triggers---------------------------------------  */
/*  -------------------------------------------------------------------------------------  */


-- Trigger para validar correo antes de insertar
DELIMITER $$

CREATE TRIGGER before_insert_usuario
BEFORE INSERT ON usuario
FOR EACH ROW
BEGIN
    IF NEW.correo NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo debe contener @';
    END IF;
END$$

DELIMITER ;


-- Trigger para evitar logros negativos
DELIMITER $$

CREATE TRIGGER before_insert_fideizacion
BEFORE INSERT ON fidelizacion
FOR EACH ROW
BEGIN
    IF NEW.cantidad_logros < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Los logros no pueden ser negativos';
    END IF;
END$$

DELIMITER ;


-- Trigger para registrar cambios de cantidad
CREATE TABLE inventario_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto TINYINT,
    cantidad_anterior TINYINT,
    cantidad_nueva TINYINT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER after_update_inventario
AFTER UPDATE ON inventario
FOR EACH ROW
BEGIN
    IF OLD.cantidad <> NEW.cantidad THEN
        INSERT INTO inventario_log (id_producto, cantidad_anterior, cantidad_nueva)
        VALUES (OLD.id, OLD.cantidad, NEW.cantidad);
    END IF;
END$$

DELIMITER ;


-- Trigger para impedir reservas en el pasado
DELIMITER $$

CREATE TRIGGER before_insert_reserva
BEFORE INSERT ON reserva
FOR EACH ROW
BEGIN
    IF NEW.fecha < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se pueden hacer reservas en fechas pasadas';
    END IF;
END$$

DELIMITER ;


-- Trigger para registrar pedidos completados
CREATE TABLE pedido_completado_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido TINYINT,
    fecha_pedido DATE,
    valor MEDIUMINT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE TRIGGER after_insert_pedido
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    IF NEW.estado = TRUE THEN
        INSERT INTO pedido_completado_log (id_pedido, fecha_pedido, valor)
        VALUES (NEW.id, NEW.fecha, NEW.valor);
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_insert_factura
BEFORE INSERT ON factura
FOR EACH ROW
BEGIN
    DECLARE precio_unitario MEDIUMINT;

    SELECT valor INTO precio_unitario
    FROM inventario
    WHERE id = NEW.id_inventario;

    IF NEW.valor_total <> (precio_unitario * NEW.cantidad) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El valor total no coincide con el producto * cantidad';
    END IF;
END$$

DELIMITER ;

