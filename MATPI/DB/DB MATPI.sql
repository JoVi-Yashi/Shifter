create database matpi;
use matpi;

create table Usuario
(
ID varchar(16) primary key,
Telefono varchar(14),
Contraseña varchar(20),
Correo_Electronico varchar(35),
Rol enum(
	'Activo', 
	'Licencia', 
	'Vacaciones', 
	'Retirado', 
	'Despedido'
		),
Fecha_Nacimiento date,
Nombre_Completo varchar(40),
Estado boolean,
Direccion varchar(50),
Fecha_ingreso date,
Experiencia_Laboral varchar(15)
);

create table Administrador
(
Ult_Fecha_login datetime,
Ult_IP_login varchar(45),
Formacion_Educativa varchar(35),
	ID_Usr varchar(16),
		constraint Usuario_Hereda_Administrador 
		foreign key (ID_Usr) references Usuario(ID)
);



create table Empleado
(
EPS enum (
	'Nueva EPS',
	'Sanitas', 
    'SURA', 
    'Salud Total', 
    'Compensar', 
    'Famisanar', 
    'Coosalud', 
    'Mutual Ser', 
    'SOS', 
    'Salud Mía', 
    'Aliansalud', 
    'Dusakawi', 
    'Salud Bolívar', 
    'Savia Salud', 
    'Cajacopi', 
    'Asmet Salud', 
    'Emssanar', 
    'Capital Salud'
			),
tipo_contrato enum(
	'Indefinido',
	'Fijo',
	'Servicios',
	'Temporal'
					),
Contacto_Emergencia_Nombre varchar(35), 
Contacto_Emergencia_Parentesco varchar(15),
Contacto_Emergencia_Numero varchar(14),
Fecha_Terminacion_Contrato date,
	ID_Usr varchar(16),
		constraint Usuario_Hereda_Empleado 
		foreign key (ID_Usr) references Usuario(ID) 
);

create table Cliente
(
ID smallint unsigned primary key,
Nombre_Completo varchar(40),
Telefono varchar(14),
Ultima_Visita datetime,
Total_Consumo int unsigned,
	ID_Usr varchar(16),
		constraint fk_empleado_cliente foreign key (ID_Usr) references Empleado(ID_Usr) 
);

create table Reserva
(
ID smallint unsigned primary key,
Fecha datetime,
Estado boolean,
Observciones tinytext,
	ID_Usr varchar(16),
		constraint fk_reserva_empleado foreign key (ID_Usr) references Empleado(ID_Usr)
);

create table Pedido
(
ID smallint unsigned primary key, 
Fecha date,
Estado boolean,
Valor int unsigned,
Mesa tinyint unsigned,
	ID_Usr varchar(16),

		constraint fk_pedido_empleado 
		foreign key (ID_Usr) 
		references Empleado(ID_Usr),
	ID_Reserva smallint unsigned,
		constraint fk_pedido_reserva 
		foreign key (ID_Reserva) 
		references Reserva(ID),


	ID_Cliente smallint unsigned,
		constraint fk_pedido_cliente
        foreign key (ID_Cliente)
        references Cliente(ID)
        on delete set null  
        on update cascade
);

create table Proveedor
(
ID smallint unsigned primary key,
Nombre_Proveedor varchar(50),
Direccion varchar(120),
Correo_Electronico varchar(35),
Telefono varchar(14),
	ID_Usr varchar(16),
		constraint fk_proveedor_empleado foreign key (ID_Usr) references Empleado(ID_Usr)
);

create table Producto
(
ID smallint unsigned primary key,
Nombre_Producto varchar(35),
Descripcion tinytext,
Cantidad smallint unsigned ,
Valor int unsigned,
Categoria enum(
	'Lácteos y Huevos',
    'Carnes y Aves',
    'Pescados y Mariscos',
    'Verduras y Hortalizas',
    'Frutas',
    'Granos y Legumbres',
    'Cereales y Harinas',
    'Aceites y Grasas',
    'Especias y Condimentos',
    'Salsas y Aderezos',
    'Azúcares y Endulzantes',
    'Panadería', 
    'Envases y Empaques', 
    'Otros'
			)
);

create table Factura
(
ID smallint unsigned primary key,
Valor_Total int unsigned,
Descripcion tinytext,
IVA float,
Metodo_Pago varchar(40),
	ID_Pedi smallint unsigned,
		constraint fk_factura_pedido
        foreign key (ID_Pedi)
        references Pedido(ID)
        on delete cascade
        on update cascade
);

create table Materia_Prima
(
ID smallint unsigned primary key,
Nombre_Materia_Prima varchar(60),
Unidad_Medida varchar(20),
Cantidad smallint unsigned,
Fecha_Ingreso datetime,
Fecha_Vencimiento date
);

-- tablas intermedias

create table Details_Producto_MateriaP
(
 Producto_ID smallint unsigned,
    MateriaPrima_ID smallint unsigned,
    Cantidad_Usada smallint unsigned, 

    primary key (Producto_ID, MateriaPrima_ID),

    constraint FK_Producto
        foreign key (Producto_ID) 
        references Producto(ID)
        on delete cascade
        on update cascade,

    constraint FK_MateriaPrima
        foreign key (MateriaPrima_ID) 
        references Materia_Prima(ID)
        on delete cascade
        on update cascade
);

create table Details_Proveedor_MateriaP
(
    Proveedor_ID smallint unsigned,
    MateriaPrima_ID smallint unsigned,
    Precio_Unitario decimal(10,2),  
    Fecha_Suministro datetime,   

    primary key (Proveedor_ID, MateriaPrima_ID),

    constraint FK_Proveedor_MateriaPrima_Proveedor 
        foreign key (Proveedor_ID) 
        references Proveedor(ID)
        on delete cascade
        on update cascade,

    constraint FK_Proveedor_MateriaPrima_MateriaPrima 
        foreign key (MateriaPrima_ID) 
        references Materia_Prima(ID)
        on delete cascade
        on update cascade);

create table Details_Pedido_Producto
(
	ID smallint unsigned auto_increment primary key,
    ID_Pedido smallint unsigned,
    ID_Producto smallint unsigned,
    Cantidad smallint unsigned,
    Precio_Unitario int unsigned,

    constraint fk_producto_pedido_pedido 
        foreign key (ID_Pedido) 
        references Pedido(ID)
        on delete cascade,

    constraint fk_producto_pedido_producto 
        foreign key (ID_Producto) 
        references Producto(ID)
        on delete cascade

);


-- hash2 para contraseñas