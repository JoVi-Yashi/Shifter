USE MATPI;

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


