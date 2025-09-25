CREATE DATABASE IF NOT EXISTS MATPI;
USE MATPI;

/*  -------------------------------------------------------------------------------------  */
/*  ------------------------------------inserciones--------------------------------------  */
/*  -------------------------------------------------------------------------------------  */
INSERT INTO usuario (id, nombre_completo, contraseña, correo, telefono, direccion, fecha_nacimiento, estado, rol) VALUES
(1, 'Maricruz Menéndez Barriga', '*40ISOlrn7', 'fulgenciovalenzuela@gmail.com', 3189134799, 'Cañada de Gerardo Cuevas 22 Álava, 62714', '2001-03-10', true, 'administrador'),
(2, 'Eustaquio Segarra Navarro', 'GCyLFDYu*1', 'kalvarado@gmail.com', 3969442166, 'Callejón Jordana Pellicer 7 Tarragona, 41876', '2002-11-11', true, 'administrador'),
(3, 'Ani Ramírez Páez', 'SU&8uIHp*8', 'bgabaldon@gmail.com', 3432650006, 'Plaza Maxi Baquero 75 Ciudad, 01006', '2005-04-15', true, 'empleado'),
(4, 'Demetrio Bernal-Gonzalo', '*7EfuHyD7c', 'luis08@gmail.com', 3726383424, 'Plaza Florentina Aragonés 830 Madrid, 43701', '1998-12-30', true, 'empleado'),
(5, 'Nicodemo Rosales Chaves', '#z0W%qSP4+', 'tono91@gmail.com', 3968802411, 'Ronda de Juliana Mendizábal 40 La Rioja, 98008', '1998-03-28', true, 'cliente'),
(6, 'Evita Palacios Villegas', '(90DpUbr)r', 'viviana67@gmail', 3329558638, 'Ronda de Gracia Villaverde 8 Badajoz, 19654', '1991-03-12', true, 'cliente'),
(7, 'Victorino Cortés', '*+71I(Fg!+', 'norbertocantero@gmail.com', 3346718025, 'Via Quirino Valero 73 Santa Cruz de Tenerife, 80422', '2003-01-31', false, 'empleado'),
(8, 'Custodio Sedano Chacón', 'TR&2Yeq+JS', 'nazaret04@gmail.com', 3392087437, 'Alameda de Albina Beltran 8 Guadalajara, 26174', '2000-11-08', true, 'administrador'),
(9, 'Encarnación Nogueira Pablo', 'Z#2eSDulom', 'elisabenitez@gmail.com', 3458908557, 'C. de Maura Galán 124 Piso 4  Ceuta, 08576', '2004-11-24', true, 'administrador'),
(10, 'Jordán del Diez', '&ko3dLowqY', 'vvilla@gmail.com', 3080691091, 'Vial de Danilo Caparrós 40 Lleida, 18730', '1990-12-20', true, 'cliente');

INSERT INTO pedido (id, descripcion, fecha, estado, valor, id_usuario) VALUES
(1, 'Combo Clásico', '2025-06-01', true, 23000, 1),
(2, 'Hamburguesa BBQ con papas', '2025-06-02', true, 18500, 2),
(3, 'Combo Vegetariano', '2025-06-03', false, 21500, 3),
(4, 'Sandwich de pollo', '2025-06-04', true, 16000, 4),
(5, 'Doble carne con queso', '2025-06-05', true, 27000, 5),
(6, 'Agua + Papas', '2025-06-06', false, 12000, 6),
(7, 'Hamburguesa sencilla', '2025-06-07', true, 18000, 7),
(8, 'Ensalada fresca', '2025-06-08', true, 14500, 8),
(9, 'Wrap + Gaseosa', '2025-06-09', true, 19000, 9),
(10, 'Menú infantil', '2025-06-10', false, 15000, 10);

INSERT INTO reserva (id, fecha, estado, id_usuario, id_pedido) VALUES
(1, '2025-06-01', true, 1, 1),
(2, '2025-06-02', true, 2, 2),
(3, '2025-06-03', false, 3, 3),
(4, '2025-06-04', true, 4, 4),
(5, '2025-06-05', true, 5, 5),
(6, '2025-06-06', true, 6, 6),
(7, '2025-06-07', false, 7, 7),
(8, '2025-06-08', true, 8, 8),
(9, '2025-06-09', true, 9, 9),
(10, '2025-06-10', true, 10, 10);

INSERT INTO factura (id, cantidad, valor_total, iva, id_pedido, id_usuario) VALUES
(1, 2, 27370, 4370.00, 1, 1),
(2, 1, 22015, 3515.00, 2, 2),
(3, 3, 53550, 8550.00, 3, 3),
(4, 1, 20825, 3325.00, 4, 4),
(5, 2, 35050, 5550.00, 5, 5),
(6, 1, 25585, 4085.00, 6, 6),
(7, 1, 38080, 6080.00, 7, 7),
(8, 1, 29155, 4655.00, 8, 8),
(9, 2, 18445, 2945.00, 9, 9),
(10, 2, 45715, 7155.00, 10, 10);

INSERT INTO materia_prima (id, descripcion, cantidad, fecha_ingreso, fecha_vencimiento) VALUES
(1, 'Pan artesanal', 100, '2025-06-01', '2026-07-01'),
(2, 'Carne de res molida', 50, '2025-06-02', '2026-06-29'),
(3, 'Queso cheddar', 80, '2025-06-01', '2026-07-10'),
(4, 'Papas precocidas', 120, '2025-06-03', '2026-06-30'),
(5, 'Bebidas gaseosas', 200, '2025-06-05', '2026-12-01'),
(6, 'Salsa BBQ', 60, '2025-06-01', '2026-09-15'),
(7, 'Lechuga fresca', 40, '2025-06-04', '2026-06-20'),
(8, 'Tomate chonto', 50, '2025-06-03', '2026-06-22'),
(9, 'Aceite vegetal', 70, '2025-06-01', '2026-10-10'),
(10, 'Pechuga de pollo', 55, '2025-06-06', '2026-06-25');

INSERT INTO producto (id, nombre_producto, descripcion, cantidad, valor, categoria, id_reserva, id_materia_prima) VALUES
(1, 'Hamb Clás', 'Con carne y queso cheddar', 20, 15000, 'Hamburguesas', 1, 2),
(2, 'Hamb BBQ', 'Con salsa BBQ y cebolla caramelizada', 15, 18000, 'Hamburguesas', 2, 6),
(3, 'Papas Gas', 'Papas medianas con gaseosa', 30, 9000, 'Combos', 3, 4),
(4, 'Hamb Pol', 'Con pechuga de pollo crocante', 18, 16000, 'Hamburguesas', 4, 10),
(5, 'Veggie', 'Hamburguesa con soya y verduras frescas', 10, 17000, 'Especiales', 5, 7),
(6, 'Doble Car', 'Dos carnes con extra queso', 12, 22000, 'Especiales', 6, 2),
(7, 'Ref Cola', 'Gaseosa 400ml', 50, 4000, 'Bebidas', 7, 5),
(8, 'Papas Q', 'Papas fritas con queso fundido', 25, 10000, 'Complementos', 8, 4),
(9, 'Agua Bot', 'Botella 500ml sin gas', 40, 3000, 'Bebidas', 9, 5),
(10, 'Sand Pol', 'Sándwich de pollo con lechuga y tomate', 14, 12000, 'Sandwiches', 10, 10);

INSERT INTO proveedor (id, nombre, direccion, correo, telefono, id_usuario) VALUES
(1, 'Carnes Colombia S.A.', 'Cra 30 #45-78, Bogotá', 'ventas@carnescolombia.com', 3157894561, 1),
(2, 'Lácteos El Prado', 'Calle 12 #34-56, Medellín', 'contacto@elprado.com', 3104567890, 2),
(3, 'Panadería Rústica', 'Cra 8 #22-10, Cali', 'ventas@panrustico.com', 3191234567, 3),
(4, 'Bebidas Nacionales', 'Av. Las Américas #9-23, Bogotá', 'ventas@bebidasnac.com', 3201122334, 4),
(5, 'Fruver del Campo', 'Cra 7 #10-15, Bucaramanga', 'info@fruvercampo.com', 3123344556, 5),
(6, 'Pollos Santander', 'Av. Sol #20-33, Floridablanca', 'ventas@pollosantander.com', 3114455667, 6),
(7, 'Distrib. Costeñas', 'Calle 40 #78-12, Barranquilla', 'pedidos@costena.com', 3003344556, 7),
(8, 'Salsas Don Pepe', 'Cra 12 #33-44, Cartagena', 'salsas@donpepe.com', 3176677889, 8),
(9, 'Aceites Omega', 'Av. Sur #12-30, Medellín', 'contacto@omega.com', 3167788990, 9),
(10, 'Agroprod. Andinos', 'Cra 14 #55-20, Pasto', 'ventas@agroandinos.com', 3119988776, 10);


INSERT INTO detalles_suministra (id, id_proveedor, id_materia_prima, cantidad) VALUES
(1, 1, 2, 30),
(2, 2, 3, 40),
(3, 3, 1, 100),
(4, 4, 5, 200),
(5, 5, 7, 25),
(6, 6, 10, 50),
(7, 7, 4, 80),
(8, 8, 6, 60),
(9, 9, 9, 40),
(10, 10, 8, 50);

INSERT INTO detalles_agrega (id, id_materia_prima, id_producto) VALUES
(1, 2, 1),
(2, 3, 1),
(3, 6, 2),
(4, 4, 3),
(5, 10, 4),
(6, 7, 5),
(7, 2, 6),
(8, 5, 7),
(9, 4, 8),
(10, 5, 9);



