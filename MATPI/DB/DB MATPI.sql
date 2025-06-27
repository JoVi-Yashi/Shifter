create database MATPI;
use MATPI;

/*  -------------------------------------------------------------------------------------  */
/*  --------------------------------------Estructura-------------------------------------  */
/*  -------------------------------------------------------------------------------------  */
CREATE TABLE usuario (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada usuario. Es la clave primaria de la tabla, lo que asegura que cada usuario sea único y fácilmente referenciable en el sistema. El tipo TINYINT UNSIGNED es adecuado si la cantidad máxima de usuarios registrados no superará 255.",
    nombre_completo VARCHAR(60) NOT NULL comment "Almacena el nombre y apellido(s) completos del usuario. VARCHAR(60) permite una longitud suficiente para la mayoría de los nombres.",
    contraseña VARCHAR(20) NOT NULL comment "Contraseña de acceso del usuario. Para garantizar la seguridad, se recomienda enfáticamente no almacenar contraseñas en texto plano. En su lugar, se deben utilizar funciones de hash unidireccionales y seguras (como bcrypt o argon2) y almacenar únicamente el hash resultante. Esto protege la información del usuario en caso de una posible brecha de seguridad.",
    correo VARCHAR(50) NOT NULL comment "Dirección de correo electrónico del usuario. Es un campo crucial para la comunicación, notificaciones y posibles procesos de recuperación de cuenta. VARCHAR(50) es un tamaño común para direcciones de correo.",
    telefono BIGINT NOT NULL comment "Número de teléfono de contacto del usuario. BIGINT es una buena elección para números de teléfono, ya que permite almacenar dígitos suficientes para códigos de país y números largos sin preocuparse por desbordamientos.",
    direccion VARCHAR(100) NOT NULL comment "Dirección postal o física del usuario. VARCHAR(100) debería ser suficiente para la mayoría de las direcciones.",
    fecha_nacimiento DATE NULL comment "Fecha de nacimiento del usuario. Se permite NULL ya que este dato podría no ser siempre obligatorio o disponible para todos los usuarios.", 
    estado BOOLEAN NOT NULL comment "Indica el estado actual de la cuenta del usuario (ej., TRUE para activo, FALSE para inactivo o suspendido). BOOLEAN es el tipo de dato ideal para valores de verdadero/falso.",
    rol ENUM('administrador', 'empleado', 'cliente') NOT NULL comment "Define el perfil o tipo de usuario dentro del sistema. ENUM('administrador', 'empleado', 'cliente') es excelente para restringir los valores a un conjunto predefinido y asegurar la consistencia."
);

CREATE TABLE pedido (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada pedido. Es la clave primaria de la tabla.",
    descripcion varchar (150) NOT NULL comment "Un campo para añadir detalles o una breve descripción del contenido del pedido. VARCHAR(150) ofrece un espacio adecuado.",
    fecha DATE NOT NULL comment "La fecha en la que se creó o registró el pedido. DATE almacena solo la fecha sin la información de tiempo.",
    estado BOOLEAN NOT NULL comment "Indica el estado actual del pedido (ej., TRUE para completado/entregado, FALSE para pendiente/en proceso). BOOLEAN es útil para estados binarios.",
    valor MEDIUMINT UNSIGNED NOT NULL comment "El monto monetario total del pedido. MEDIUMINT UNSIGNED es adecuado para valores enteros que no excedan 16,777,215. Para mayor precisión o valores fraccionarios, DECIMAL sería más apropiado.",
    id_usuario TINYINT UNSIGNED NOT NULL comment "Clave foránea que establece una relación con la tabla usuario. Indica qué usuario realizó este pedido, garantizando la integridad referencial.",
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE reserva (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada reserva. Es la clave primaria.",
    fecha DATE NOT NULL comment "La fecha para la cual se ha realizado la reserva.",
    estado BOOLEAN NOT NULL comment "Indica si la reserva está activa, pendiente, cancelada o completada. BOOLEAN puede representar estados simples. Si hay más de dos estados, un ENUM o una tabla de estados de reserva podrían ser mejores.",
    id_usuario TINYINT UNSIGNED NOT NULL comment "Clave foránea que vincula esta reserva al usuario que la hizo.",
    id_pedido TINYINT UNSIGNED NOT NULL comment "Clave foránea que asocia esta reserva con un pedido específico. Esto sugiere que las reservas están directamente relacionadas con la creación de pedidos.",
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id) 
);

CREATE TABLE factura (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada factura. Es la clave primaria.",
    cantidad TINYINT(20) UNSIGNED NOT NULL comment "La cantidad de artículos o unidades facturadas. TINYINT(20) UNSIGNED indica un TINYINT UNSIGNED que puede almacenar hasta 255. El (20) es un display width hint y no cambia el rango de almacenamiento. Considera SMALLINT UNSIGNED o MEDIUMINT UNSIGNED si la cantidad de ítems puede ser mayor a 255.",
    valor_total MEDIUMINT UNSIGNED NOT NULL comment "El valor total de la factura, que debería incluir todos los costos y el IVA. MEDIUMINT UNSIGNED es para valores enteros.",
    iva DECIMAL(10,2) NOT NULL comment "El monto o porcentaje del Impuesto al Valor Agregado aplicado a la factura. DECIMAL(10,2) es el tipo de dato recomendado para valores monetarios con precisión decimal (hasta 8 dígitos enteros y 2 decimales).",
    id_pedido TINYINT UNSIGNED NOT NULL comment "Clave foránea que conecta esta factura al pedido al que corresponde.",
    id_usuario TINYINT UNSIGNED NOT NULL comment "Clave foránea que enlaza esta factura al usuario (cliente) para quien fue emitida.",
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE materia_prima (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada tipo de materia prima. Es la clave primaria.",
    descripcion VARCHAR(150) NOT NULL comment "Una descripción clara y detallada de la materia prima (ej., 'Harina de trigo', 'Azúcar refinada'). VARCHAR(150) es un buen tamaño.",
    cantidad TINYINT UNSIGNED NOT NULL comment "La cantidad en stock de esta materia prima. TINYINT UNSIGNED permite hasta 255 unidades. Si las cantidades pueden ser mayores, considera SMALLINT o MEDIUMINT.",
    fecha_ingreso DATE NOT NULL comment "La fecha en la que la materia prima fue recibida o registrada en el inventario.",
    fecha_vencimiento DATE NOT NULL comment "La fecha de caducidad de la materia prima. Es fundamental para la gestión de inventario, asegurando la calidad y minimizando el desperdicio."
);

CREATE TABLE producto (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada producto final que se ofrece. Es la clave primaria.",
    nombre_producto VARCHAR(10) NOT NULL comment "Nombre corto y distintivo del producto. VARCHAR(10) es bastante limitado; se recomienda aumentar el tamaño (ej., VARCHAR(50)) para nombres de productos más descriptivos.",
    descripcion VARCHAR(150) NOT NULL comment " Una descripción más detallada del producto. VARCHAR(150) es un tamaño adecuado.",
    cantidad TINYINT UNSIGNED NOT NULL comment "La cantidad actual en inventario de este producto. TINYINT UNSIGNED si el stock máximo es 255.",
    valor MEDIUMINT UNSIGNED NOT NULL comment " El precio de venta unitario del producto. MEDIUMINT UNSIGNED para valores enteros.",
    categoria VARCHAR(20) NOT NULL comment "La categoría a la que pertenece el producto (ej., 'Panadería', 'Pastelería', 'Bebidas'). VARCHAR(20) es adecuado para la clasificación.",
    id_reserva TINYINT UNSIGNED NOT NULL comment "Clave foránea que indica a qué reserva pertenece este producto. Esto implicaría que un producto individual solo puede estar asociado a una única reserva, lo cual podría ser limitante si un producto forma parte de múltiples reservas o pedidos.",
    id_materia_prima TINYINT UNSIGNED NOT NULL comment "Clave foránea que relaciona el producto con una materia_prima específica. ¡Advertencia! Si un producto se compone de varias materias primas (que es lo más común), esta relación de uno a muchos (producto a materia_prima) es insuficiente. La tabla detalles_agrega ya modela la relación muchos a muchos necesaria para esto, lo que hace que esta columna en producto sea potencialmente redundante o engañosa si un producto tiene múltiples componentes.",
    FOREIGN KEY (id_reserva) REFERENCES reserva(id),
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id)
);

CREATE TABLE proveedor (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada proveedor de materias primas o servicios. Es la clave primaria.",
    nombre VARCHAR(50) NOT NULL comment "El nombre del proveedor (persona o empresa). VARCHAR(50) es un tamaño común.",
    direccion VARCHAR(100) NOT NULL comment "La dirección física del proveedor.",
    correo VARCHAR(50) NOT NULL comment "La dirección de correo electrónico de contacto del proveedor.",
    telefono BIGINT NOT NULL comment "El número de teléfono de contacto del proveedor.",
    id_usuario TINYINT UNSIGNED NOT NULL comment "Clave foránea que podría vincular a un proveedor con un usuario interno de tu sistema (ej., un empleado encargado de gestionar ese proveedor) o si los proveedores tienen acceso a un portal de usuarios.",
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

CREATE TABLE detalles_suministra (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada registro de suministro. Es la clave primaria.",
    id_proveedor TINYINT UNSIGNED NOT NULL comment "Clave foránea que indica qué proveedor está realizando el suministro.",
    id_materia_prima TINYINT UNSIGNED NOT NULL comment "Clave foránea que especifica qué materia_prima es la que se suministra.",
    cantidad MEDIUMINT UNSIGNED NOT NULL comment "La cantidad de la materia_prima específica que fue suministrada en esta transacción. MEDIUMINT UNSIGNED es adecuado para volúmenes considerables. Esta tabla es fundamental para modelar la relación muchos a muchos entre proveedor y materia_prima, permitiendo que un proveedor suministre varias materias primas y una materia prima sea suministrada por varios proveedores.",
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id),
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id)
);

CREATE TABLE detalles_agrega (
    id TINYINT UNSIGNED PRIMARY KEY NOT NULL comment "Identificador único para cada registro que detalla la composición de un producto. Es la clave primaria.",
    id_materia_prima TINYINT UNSIGNED NOT NULL comment "Clave foránea que indica cuál materia_prima es un componente.",
    id_producto TINYINT UNSIGNED NOT NULL comment "Clave foránea que especifica a qué producto se agrega esta materia prima. Esta tabla es esencial para modelar la relación muchos a muchos entre materia_prima y producto, lo que significa que un producto puede estar compuesto por varias materias primas, y una materia prima puede usarse en la fabricación de varios productos. Esto hace que la columna id_materia_prima directamente en la tabla producto sea redundante o incorrecta si un producto tiene múltiples ingredientes.",
    FOREIGN KEY (id_materia_prima) REFERENCES materia_prima(id),
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);
