create database matpi;
use matpi;

create table Usuario
(
ID varchar(16) primary key not null,
Telefono varchar(14) not null,
Contraseña varchar(255) not null,
Correo_Electronico varchar(35) not null,
Rol enum(
	'Administrador', 
	'Empleado'
		) not null,
Fecha_Nacimiento date null,
Nombre_Completo varchar(40) not null,
Estado boolean not null,
Direccion varchar(50) not null,
Fecha_ingreso date not null,
Experiencia_Laboral varchar(15) not null,
-- validaciones
    constraint chk_email check (Correo_Electronico REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    constraint chk_telefono check (Telefono REGEXP '^[0-9+\-\s()]+$')
);

create table Administrador
(
Ult_Fecha_login datetime null,
Ult_IP_login varchar(45) null,
Formacion_Educativa varchar(35) null,
	ID_Usr varchar(16) not null,
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
			) not null,
tipo_contrato enum(
	'Indefinido',
	'Fijo',
	'Servicios',
	'Temporal'
					) not null,
Contacto_Emergencia_Nombre varchar(35) not null, 
Contacto_Emergencia_Parentesco varchar(15) not null,
Contacto_Emergencia_Numero varchar(14) not null,
Fecha_Terminacion_Contrato date null,
	ID_Usr varchar(16) not null,
		constraint Usuario_Hereda_Empleado 
		foreign key (ID_Usr) references Usuario(ID) 
);

create table Cliente
(
ID smallint unsigned primary key not null,
Nombre_Completo varchar(40) not null,
Telefono varchar(14) not null,
Ultima_Visita datetime null,
Total_Consumo int unsigned not null,
Fecha_Registro timestamp not null,
	ID_Usr varchar(16) not null,
		constraint fk_empleado_cliente foreign key (ID_Usr) references Empleado(ID_Usr) 
);

create table Reserva
(
ID smallint unsigned primary key not null,
Fecha datetime not null,
Estado boolean not null,
Observaciones tinytext null,
	ID_Usr varchar(16) not null,
		constraint fk_reserva_empleado foreign key (ID_Usr) references Empleado(ID_Usr)
);

create table Pedido
(
ID smallint unsigned primary key not null, 
Fecha date not null,
Estado boolean not null,
Valor int unsigned not null,
Mesa tinyint unsigned null,
Numero_Personas tinyint unsigned null,
	ID_Usr varchar(16) not null,
		constraint fk_pedido_empleado 
		foreign key (ID_Usr) 
		references Empleado(ID_Usr),
	ID_Reserva smallint unsigned null,
		constraint fk_pedido_reserva 
		foreign key (ID_Reserva) 
		references Reserva(ID),
	ID_Cliente smallint unsigned null,
		constraint fk_pedido_cliente
        foreign key (ID_Cliente)
        references Cliente(ID)
        on delete set null  
        on update cascade
);

create table Proveedor
(
ID smallint unsigned primary key not null,
Nombre_Proveedor varchar(50) not null,
Direccion varchar(120) not null,
Correo_Electronico varchar(35) null,
Telefono varchar(14) not null,
	ID_Usr varchar(16) not null,
		constraint fk_proveedor_empleado foreign key (ID_Usr) references Empleado(ID_Usr)
);

create table Producto
(
ID smallint unsigned primary key not null,
Nombre_Producto varchar(35) not null,
Descripcion tinytext null,
Cantidad smallint unsigned not null,
Valor int unsigned not null,
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
			) not null
);

create table Factura
(
ID smallint unsigned primary key not null,
Valor_Total int unsigned not null,
Descripcion tinytext null,
IVA float not null,
Metodo_Pago varchar(40) not null,
	ID_Pedi smallint unsigned not null,
		constraint fk_factura_pedido
        foreign key (ID_Pedi)
        references Pedido(ID)
        on delete cascade
        on update cascade
);

create table Materia_Prima
(
ID smallint unsigned primary key not null,
Nombre_Materia_Prima varchar(60) not null,
Unidad_Medida varchar(20) not null,
Cantidad smallint unsigned not null,
Fecha_Ingreso datetime not null,
Fecha_Vencimiento date null
);

-- tablas intermedias

create table Details_Producto_MateriaP
(
 Producto_ID smallint unsigned not null,
    MateriaPrima_ID smallint unsigned not null,
    Cantidad_Usada smallint unsigned not null, 

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
    Proveedor_ID smallint unsigned not null,
    MateriaPrima_ID smallint unsigned not null,
    Precio_Unitario decimal(10,2) not null,  
    Fecha_Suministro datetime not null,   

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
        on update cascade
);

create table Details_Pedido_Producto
(
	ID smallint unsigned auto_increment primary key not null,
    ID_Pedido smallint unsigned not null,
    ID_Producto smallint unsigned not null,
    Cantidad smallint unsigned not null,
    Precio_Unitario int unsigned not null,

    constraint fk_producto_pedido_pedido 
        foreign key (ID_Pedido) 
        references Pedido(ID)
        on delete cascade,

    constraint fk_producto_pedido_producto 
        foreign key (ID_Producto) 
        references Producto(ID)
        on delete cascade
);

--
-- indices 
--

create index idx_usuario_correo on Usuario(Correo_Electronico);
create index idx_pedido_fecha on Pedido(Fecha);
create index idx_cliente_ultima_visita on Cliente(Ultima_Visita);
create index idx_materia_prima_vencimiento on Materia_Prima(Fecha_Vencimiento);

-- hash2 para contraseñas