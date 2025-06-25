use matpi;

/*  -------------------------------------------------------------------------------------  */
/*  ------------------------------------inserciones--------------------------------------  */
/*  -------------------------------------------------------------------------------------  */

-- USUARIO

INSERT INTO usuario (id, nombre_completo, contraseña, correo, telefono, direccion, fecha_nacimiento, estado, rol) VALUES
(1, 'Laura Gómez', 'clave123', 'laura@example.com', 3001234567, 'Calle 10 #12-34', '1990-05-20', TRUE, 'cliente'),
(2, 'Carlos Pérez', 'adminpass', 'carlos@example.com', 3009876543, 'Carrera 45 #67-89', '1985-09-12', TRUE, 'administrador'),
(3, 'Sofía Ramírez', 'sofiapass', 'sofia@example.com', 3012345678, 'Calle 23 #45-67', '1992-03-15', TRUE, 'cliente'),
(4, 'Daniel Vélez', 'danielpass', 'daniel@example.com', 3023456789, 'Carrera 12 #34-56', '1988-11-20', TRUE, 'empleado'),
(5, 'Mariana Díaz', 'mdiaz2024', 'mariana@example.com', 3034567890, 'Av. 10 #20-30', '1995-07-01', TRUE, 'cliente'),
(6, 'Lucía Martínez', 'luciapass', 'lucia@example.com', 3045678901, 'Calle 50 #60-70', '1990-10-10', TRUE, 'cliente'),
(7, 'Pedro Salazar', 'pedro456', 'pedro@example.com', 3056789012, 'Carrera 30 #40-50', '1993-02-05', FALSE, 'cliente'),
(8, 'Angela Moreno', 'angelpass', 'angela@example.com', 3067890123, 'Av. 80 #90-100', '1987-09-30', TRUE, 'administrador'),
(9, 'Andrés Ríos', 'rios123', 'andres@example.com', 3078901234, 'Calle 77 #88-99', '1991-06-18', TRUE, 'cliente'),
(10, 'Paula Gil', 'paulapass', 'paula@example.com', 3089012345, 'Carrera 8 #9-10', '1996-12-12', TRUE, 'empleado');


-- FIDELIZACION
INSERT INTO fidelizacion (id, numero_visitas, fecha_inicio, cantidad_logros, id_usuario) VALUES
(1, 10, '2024-01-01', 3, 1),
(2, 25, '2023-05-15', 7, 1),
(3, 5, '2024-02-01', 1, 3),
(4, 12, '2023-08-20', 4, 5),
(5, 30, '2022-05-10', 10, 6),
(6, 0, '2025-01-01', 0, 7),
(7, 17, '2023-12-01', 6, 9),
(8, 4, '2024-11-10', 1, 4),
(9, 2, '2024-09-15', 0, 10),
(10, 19, '2023-06-30', 5, 2);


-- INVENTARIO
INSERT INTO inventario (id, nombre_producto, descripcion, cantidad, valor, categoria) VALUES
(1, 'Hamburguesa Clásica', 'Hamburguesa con carne y queso', 15, 18000, 'Comida rápida'),
(2, 'Gaseosa 350ml', 'Bebida refrescante', 50, 4000, 'Bebidas'),
(3, 'Papas Fritas', 'Papas crocantes', 25, 8000, 'Comida rápida'),
(4, 'Jugo Natural', 'Jugo de fruta natural', 30, 6000, 'Bebidas'),
(5, 'Combo Infantil', 'Hamburguesa pequeña, papas y jugo', 10, 15000, 'Combo'),
(6, 'Pizza Mediana', 'Pizza de 4 porciones', 8, 20000, 'Comida rápida'),
(7, 'Cerveza', 'Botella 330ml', 40, 5000, 'Bebidas alcohólicas'),
(8, 'Agua Botella', 'Agua sin gas 500ml', 50, 3000, 'Bebidas'),
(9, 'Ensalada Mixta', 'Verduras frescas con aderezo', 12, 9000, 'Saludable'),
(10, 'Té Helado', 'Té con limón frío', 20, 4500, 'Bebidas');


-- RESERVA
INSERT INTO reserva (id, fecha, estado, id_usuario, cotizacion_inventario) VALUES
(1, '2025-06-15', TRUE, 1, 1),
(2, '2025-06-18', FALSE, 1, 2),
(3, '2025-06-19', TRUE, 3, 3),
(4, '2025-06-20', FALSE, 5, 4),
(5, '2025-06-21', TRUE, 6, 5),
(6, '2025-06-21', FALSE, 7, 6),
(7, '2025-06-22', TRUE, 9, 7),
(8, '2025-06-23', TRUE, 4, 8),
(9, '2025-06-24', FALSE, 10, 9),
(10, '2025-06-25', TRUE, 2, 10);


-- PEDIDO
INSERT INTO pedido (id, fecha, estado, valor, id_usuario) VALUES
(1, '2025-06-10', TRUE, 26000, 1),
(2, '2025-06-11', FALSE, 18000, 1),
(3, '2025-06-12', TRUE, 32000, 3),
(4, '2025-06-13', FALSE, 8000, 5),
(5, '2025-06-14', TRUE, 15000, 6),
(6, '2025-06-15', FALSE, 20000, 7),
(7, '2025-06-16', TRUE, 10000, 9),
(8, '2025-06-17', FALSE, 12000, 4),
(9, '2025-06-18', TRUE, 9000, 10),
(10, '2025-06-19', TRUE, 18000, 2);


-- FACTURA
INSERT INTO factura (id_detalles, cantidad, valor_total, iva, id_pedido, id_inventario) VALUES
(1, 2, 36000, 0.19, 1, 1),
(2, 1, 4000, 0.19, 1, 2),
(3, 1, 8000, 0.19, 3, 3),
(4, 2, 12000, 0.19, 3, 4),
(5, 1, 15000, 0.19, 4, 5),
(6, 2, 40000, 0.19, 5, 6),
(7, 1, 5000, 0.19, 6, 7),
(8, 1, 3000, 0.19, 7, 8),
(9, 1, 9000, 0.19, 8, 9),
(10, 2, 9000, 0.19, 9, 10);

INSERT INTO materia_prima VALUES 
(1, 'Carne de res', 50, '2025-06-20', '2025-07-10'),
(2, 'Pan artesanal', 100, '2025-06-22', '2025-07-05'),
(3, 'Queso cheddar', 40, '2025-06-21', '2025-07-15'),
(4, 'Lechuga fresca', 30, '2025-06-24', '2025-06-30'),
(5, 'Tomate', 30, '2025-06-24', '2025-07-01'),
(6, 'Cebolla', 20, '2025-06-23', '2025-07-02'),
(7, 'Papas criollas', 60, '2025-06-20', '2025-07-10'),
(8, 'Salsas (BBQ, mostaza)', 25, '2025-06-20', '2025-07-30'),
(9, 'Gaseosas', 100, '2025-06-25', '2026-06-25'),
(10, 'Helado vainilla', 20, '2025-06-23', '2025-07-20');

INSERT INTO proveedor VALUES 
(1, 'Carnes Premium SAS', 'Cra 10 #20-30, Bogotá', 'contacto@carnespremium.com', 3215678901, 3),
(2, 'Panadería Don Pan', 'Cll 40 #15-50, Medellín', 'ventas@donpan.com', 3102345678, 3),
(3, 'Lácteos Andinos', 'Cra 25 #60-22, Cali', 'info@lacteosandinos.com', 3123456780, 3),
(4, 'AgroVerduras', 'Cra 8 #12-12, Bucaramanga', 'servicio@agroverduras.com', 3114567890, 3),
(5, 'Papas Colombia', 'Cll 70 #30-15, Pereira', 'contacto@papascolombia.com', 3135678902, 3),
(6, 'Bebidas del Valle', 'Cra 15 #10-50, Cartagena', 'ventas@bebidasvalle.com', 3001234560, 3),
(7, 'Heladería Fresca', 'Cll 50 #18-44, Neiva', 'info@heladeriafresca.com', 3019876543, 3),
(8, 'Salsas La Roca', 'Cra 9 #22-60, Barranquilla', 'ventas@salsalaroca.com', 3106785432, 3),
(9, 'Verduras del Campo', 'Cra 11 #25-60, Villavicencio', 'ventas@verdelcampo.com', 3137894560, 3),
(10, 'Quesos el Paisa', 'Cll 19 #9-90, Manizales', 'info@quesospaisa.com', 3213214321, 3);

