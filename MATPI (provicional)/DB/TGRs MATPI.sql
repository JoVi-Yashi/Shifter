CREATE DATABASE IF NOT EXISTS MATPI;
USE MATPI;


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

